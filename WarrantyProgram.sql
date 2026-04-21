<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="http://mycompany.com/mynamespace" xmlns:js="urn:the-xml-files:xslt-csharp" xmlns:ntd="http://www.ntd.ru/ntd/" version="1.0">
  <xsl:output method="text"/>
  <xsl:template match="root">
    <xsl:for-each select="WARRANTY_PROGRAM">
      declare @WarrantyProgramID uniqueidentifier
      declare @WarrantyProgramGroupID uniqueidentifier
      declare @WarrantyProgramItemID uniqueidentifier
      declare @WarrantyProgramItemRateID uniqueidentifier
      declare @WarrantyProgramGroupRateID uniqueidentifier
      declare @WarrantyProgramFieldID uniqueidentifier
      declare @WarrantyProgramGroupSortID uniqueidentifier
      declare @WarrantyProgramGroupFieldID uniqueidentifier
      declare @WarrantyProgramRatioID uniqueidentifier
      set @WarrantyProgramID = NEWID();

      INSERT INTO [AKUZ].[T_WARRANTY_PROGRAM] (WarrantyProgramID, Name, ValidThrough, PackName, PackNamePrefix)
      VALUES
      (
      @WarrantyProgramID,
      '<xsl:value-of select="Name"/> от '+CAST(GETDATE() AS nvarchar(30)),
      '<xsl:value-of select="ValidThrough"/>',
      <xsl:choose>
        <xsl:when test="string(PackName)">
          '<xsl:value-of select="PackName"/>',
        </xsl:when>
        <xsl:otherwise>NULL,</xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="string(PackNamePrefix)">
          '<xsl:value-of select="PackNamePrefix"/>'
        </xsl:when>
        <xsl:otherwise>NULL</xsl:otherwise>
      </xsl:choose>
      )


      <xsl:for-each select="WARRANTY_PROGRAM_GROUP">
        set @WarrantyProgramGroupID = NEWID();
        INSERT INTO [AKUZ].[T_WARRANTY_PROGRAM_GROUP] (WarrantyProgramGroupID, Name, Entity, WarrantyProgram, Criteria, DatePath, DateLexem, CriteriaExist, PackNameLexem, CorrCriteria, GroupLexem)
        VALUES
        (
        @WarrantyProgramGroupID,
        '<xsl:value-of select="Name"/>',
        '<xsl:value-of select="Entity"/>',
        @WarrantyProgramID,
        <xsl:choose>
          <xsl:when test="string(Criteria)">
            '<xsl:value-of select="Criteria"/>',
          </xsl:when>
          <xsl:otherwise>NULL,</xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="string(DatePath)">
            '<xsl:value-of select="DatePath"/>',
          </xsl:when>
          <xsl:otherwise>NULL,</xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="string(DateLexem)">
            '<xsl:value-of select="DateLexem"/>',
          </xsl:when>
          <xsl:otherwise>NULL,</xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="string(CriteriaExist)">
            '<xsl:value-of select="CriteriaExist"/>',
          </xsl:when>
          <xsl:otherwise>NULL,</xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="string(PackNameLexem)">
            '<xsl:value-of select="PackNameLexem"/>',
          </xsl:when>
          <xsl:otherwise>NULL,</xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="string(CorrCriteria)">
            '<xsl:value-of select="CorrCriteria"/>',
          </xsl:when>
          <xsl:otherwise>NULL,</xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="string(GroupLexem)">
            '<xsl:value-of select="GroupLexem"/>'
          </xsl:when>
          <xsl:otherwise>NULL</xsl:otherwise>
        </xsl:choose>
        )

        

        <xsl:for-each select="WARRANTY_PROGRAM_ITEM">
          set @WarrantyProgramItemID = NEWID();
          INSERT INTO [AKUZ].[T_WARRANTY_PROGRAM_ITEM] (WarrantyProgramItemID, Code, WarrantyProgramGroup, Name, FullName, Criteria, Priority, ServiceCode, Code2)
          VALUES
          (
          @WarrantyProgramItemID,
          '<xsl:value-of select="Code"/>',
          @WarrantyProgramGroupID,
          '<xsl:value-of select="Name"/>',
          '<xsl:value-of select="FullName"/>',
          <xsl:choose>
            <xsl:when test="string(Criteria)">
              '<xsl:value-of select="Criteria"/>',
            </xsl:when>
            <xsl:otherwise>NULL,</xsl:otherwise>
          </xsl:choose>
          '<xsl:value-of select="Priority"/>',
          <xsl:choose>
            <xsl:when test="string(ServiceCode)">
              '<xsl:value-of select="ServiceCode"/>',
            </xsl:when>
            <xsl:otherwise>NULL,</xsl:otherwise>
          </xsl:choose>
          '<xsl:value-of select="Code2"/>'
          )

          <xsl:for-each select="WARRANTY_PROGRAM_ITEM_RATE">
            set @WarrantyProgramItemRateID = NEWID();
            INSERT INTO [AKUZ].[T_WARRANTY_PROGRAM_ITEM_RATE] (WarrantyProgramItemRateID, EffectiveDate, Rate, WarrantyProgramItem, Ratio, RateExtra)
            VALUES
            (
            @WarrantyProgramItemRateID,
            '<xsl:value-of select="EffectiveDate"/>',
            '<xsl:value-of select="Rate"/>',
            @WarrantyProgramItemID,
            '<xsl:value-of select="Ratio"/>',
            <xsl:choose>
              <xsl:when test="string(RateExtra)">
                '<xsl:value-of select="RateExtra"/>'
              </xsl:when>
              <xsl:otherwise>NULL</xsl:otherwise>
            </xsl:choose>
            )
          </xsl:for-each>

        </xsl:for-each>

        <xsl:for-each select="WARRANTY_PROGRAM_GROUP_RATE">
          set @WarrantyProgramGroupRateID = NEWID();
          INSERT INTO AKUZ.T_WARRANTY_PROGRAM_GROUP_RATE (WarrantyProgramGroupRateID, EffectiveDate, WarrantyProgramGroup, Ratio2)
          VALUES
          (
          @WarrantyProgramGroupRateID,
          '<xsl:value-of select="EffectiveDate"/>',
          @WarrantyProgramGroupID,
          '<xsl:value-of select="Ratio2"/>'
          )
        </xsl:for-each>

        <xsl:for-each select="WARRANTY_PROGRAM_FIELD">
          set @WarrantyProgramFieldID = NEWID();
          INSERT INTO AKUZ.T_WARRANTY_PROGRAM_FIELD(WarrantyProgramFieldID, Name, Lexem, WarrantyProgramGroup, DataType, Condition)
          VALUES
          (
          @WarrantyProgramFieldID,
          '<xsl:value-of select="Name"/>',
          '<xsl:value-of select="Lexem"/>',
          @WarrantyProgramGroupID,
          '<xsl:value-of select="DataType"/>',
          <xsl:choose>
            <xsl:when test="string(Condition)">
              '<xsl:value-of select="Condition"/>'
            </xsl:when>
            <xsl:otherwise>NULL</xsl:otherwise>
          </xsl:choose>
          )
        </xsl:for-each>

        <xsl:for-each select="WARRANTY_PROGRAM_GROUP_SORT">
          set @WarrantyProgramGroupSortID = NEWID();
          INSERT INTO AKUZ.T_WARRANTY_PROGRAM_GROUP_SORT(WarrantyProgramGroupSortID, WarrantyProgramGroup, SortPriority, SortOrder, ValueLexem)
          VALUES
          (
          @WarrantyProgramGroupSortID,
          @WarrantyProgramGroupID,
          '<xsl:value-of select="SortPriority"/>',
          '<xsl:value-of select="SortOrder"/>',
          '<xsl:value-of select="ValueLexem"/>'
          )
        </xsl:for-each>

        <xsl:for-each select="WARRANTY_PROGRAM_GROUP_FIELD">
          set @WarrantyProgramGroupFieldID = NEWID();
          INSERT INTO AKUZ.T_WARRANTY_PROGRAM_GROUP_FIELD(WarrantyProgramGroupFieldID, WarrantyProgramGroup, Name, ValueLexem, CountType, LexemObject)
          VALUES
          (
          @WarrantyProgramGroupFieldID,
          @WarrantyProgramGroupID,
          '<xsl:value-of select="Name"/>',
          '<xsl:value-of select="ValueLexem"/>',
          '<xsl:value-of select="CountType"/>',
          '<xsl:value-of select="LexemObject"/>'
          )
        </xsl:for-each>
        
      </xsl:for-each>

      <xsl:for-each select="WARRANTY_PROGRAM_RATIO">
        set @WarrantyProgramRatioID = NEWID();
        INSERT INTO AKUZ.T_WARRANTY_PROGRAM_RATIO (WarrantyProgramRatioID, WarrantyProgram, Ratio, BeginDate)
        VALUES
        (
        @WarrantyProgramRatioID,
        @WarrantyProgramID,
        '<xsl:value-of select="Ratio"/>',
        '<xsl:value-of select="BeginDate"/>'
        )
      </xsl:for-each>

      GO
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
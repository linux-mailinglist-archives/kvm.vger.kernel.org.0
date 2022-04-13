Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6514FF610
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 13:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbiDMLxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 07:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbiDMLxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 07:53:04 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB845C64A
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 04:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsPvlcC+5j8l4rziRCNJ6nlY+Gmc3h5xVytnWj7szJI=;
 b=xN0v1vFzIv3fJOAVQPbKocLFgkoAdGftctgiYl+N9XHI6HxJHT9MSzy+mT1MF2jR7jdvR8SnQRe2+JeCIg8kZOOxDLrfNjd/hLJvYVd6iQQOYCbnezG6qqAd5QverOzOM2fH0i6VY0KY9d91NK010DOvX9Lzhjk2A3PTXhxCiOE=
Received: from DB6PR0601CA0019.eurprd06.prod.outlook.com (2603:10a6:4:7b::29)
 by DB9PR08MB7083.eurprd08.prod.outlook.com (2603:10a6:10:2c3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 11:50:39 +0000
Received: from DB5EUR03FT052.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:7b:cafe::f7) by DB6PR0601CA0019.outlook.office365.com
 (2603:10a6:4:7b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18 via Frontend
 Transport; Wed, 13 Apr 2022 11:50:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT052.mail.protection.outlook.com (10.152.21.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 11:50:39 +0000
Received: ("Tessian outbound ac9bb5dd84f6:v118"); Wed, 13 Apr 2022 11:50:39 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 48fd30e4f71945dc
X-CR-MTA-TID: 64aa7808
Received: from 70047b4ffa55.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 6AA30E2C-1C0A-42F7-8A6A-ECCBAA7281A4.1;
        Wed, 13 Apr 2022 11:50:32 +0000
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 70047b4ffa55.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 13 Apr 2022 11:50:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+5/KYTLh8npKvKBQC79yRKANhXys3kEYHmA0fWb6AakvWFV8oU16dBIi5HUGUg1NMhYUg+DNYf8Hq7DVHpG7zNKFNANE/V6gMloL5kmvnclqcqWFffOzF2uf004BNkNb9V7ie/kM+RoZRInylGAUwuTxznYQrP6g95t10W13/7UCox7RH0wtU/beViVO6XIrRJW9ThUaZNcOh02jokPA99y3ToqV9E3jn8if0rmoN9nmdpk9NLWYdPo/HhmZvRfa0r0KEfBR/0vO7iFtdfUIm/CcX2dcMg7k/pMCNKOYf+RxW2oWPt0tF+lkhwbs6uotH58UvWQKCd+9QQqIayo2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gsPvlcC+5j8l4rziRCNJ6nlY+Gmc3h5xVytnWj7szJI=;
 b=gUys7YnGu3SG7DQFLSD2I8Pne5bBJuMYErCOu/vZdKJRf4eM2rsQUES3nBRnPMgRP4tTOrBzpfaeRNjHEYjIa68svfN3ekyxwd2zIH6Std4caSsnuEH5F7I7UsEYdeUxuqbn7JVGsYMxu8GMZ+9f3gvrTb8iz0P6gC+xqPBot1SJXR+bOI7+uqV7rKDOG9J3yGbttSd3dhdVcZ700qZAuQzsFUrtuAMzNi96aKZ3QteY1YSoZPE7JOy5d2GnAZqP0W0o1Xa7Fs5rMpkK79lklKQxE6J9h/RAqwk49VlAAOW4TQGszHSIWQu14j3/UpbrSFkMLQivP3HWJexClBxXmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsPvlcC+5j8l4rziRCNJ6nlY+Gmc3h5xVytnWj7szJI=;
 b=xN0v1vFzIv3fJOAVQPbKocLFgkoAdGftctgiYl+N9XHI6HxJHT9MSzy+mT1MF2jR7jdvR8SnQRe2+JeCIg8kZOOxDLrfNjd/hLJvYVd6iQQOYCbnezG6qqAd5QverOzOM2fH0i6VY0KY9d91NK010DOvX9Lzhjk2A3PTXhxCiOE=
Received: from AS9PR0301CA0027.eurprd03.prod.outlook.com
 (2603:10a6:20b:468::14) by AM6PR08MB4551.eurprd08.prod.outlook.com
 (2603:10a6:20b:70::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 11:50:30 +0000
Received: from AM5EUR03FT024.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:468:cafe::dc) by AS9PR0301CA0027.outlook.office365.com
 (2603:10a6:20b:468::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Wed, 13 Apr 2022 11:50:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com;
Received: from nebula.arm.com (40.67.248.234) by
 AM5EUR03FT024.mail.protection.outlook.com (10.152.16.175) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 11:50:30 +0000
Received: from AZ-NEU-EX01.Emea.Arm.com (10.251.26.4) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.27; Wed, 13 Apr
 2022 11:50:37 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX01.Emea.Arm.com
 (10.251.26.4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.27; Wed, 13
 Apr 2022 11:50:29 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.27 via Frontend
 Transport; Wed, 13 Apr 2022 11:50:36 +0000
Date:   Wed, 13 Apr 2022 12:50:27 +0100
From:   Joey Gouly <joey.gouly@arm.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Alexandru Elisei" <alexandru.elisei@arm.com>,
        <kernel-team@android.com>, <nd@arm.com>
Subject: Re: [PATCH 01/10] arm64: Expand ESR_ELx_WFx_ISS_TI to match its
 ARMv8.7 definition
Message-ID: <20220413115027.GB35565@e124191.cambridge.arm.com>
References: <20220412131303.504690-1-maz@kernel.org>
 <20220412131303.504690-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220412131303.504690-2-maz@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 589dfa75-448b-4d12-977e-08da1d43d4a2
X-MS-TrafficTypeDiagnostic: AM6PR08MB4551:EE_|DB5EUR03FT052:EE_|DB9PR08MB7083:EE_
X-Microsoft-Antispam-PRVS: <DB9PR08MB7083E7CAF8F66E196933C3F094EC9@DB9PR08MB7083.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: jMD7gmcenaBQdoa+1xXSa0oo5iKb5xgv/air2cmJPKe3j+kt7GNcEKYhuhzhyIm2HuYdD650JJRqbsCyQ38oUUD1GDknY2eVtaKAzl5+LBscoobpWpFwUe1KuDRLj82COFd36u9bwPoXpC4jLdSf6n5o4QJv3K8/FruVpI8uSjES3dqE4PPSINGcfHhQ0sGfRgZm12t3O0K6eHflw1hvSJMpWlZK6nKDnnTPB/jj33nAHU/FgN7G6quKNVkLHkNIyc2VOiYAc6E60I/Oi3GyOmJ2m2yx0bnV1JAvThhkOkNHg9BizAUBwDObr7bNiABb79wZOR8E/xTfM2i7JbOQXLRatlrS8qkBX1u3KqaQqNbcNa0sitbBuSCM2CRTtBq/gKYAgcDW6Oi4Pkmpnbdwk4BtGaFXEujVsdnBo0G07B8EVQWFtfvX+MtKtEg60xY0EMahtFI9B/A+a6bQOsdIpNVAL3AJmiH7png3KY2gh5s2KAuj63LTfLeiI+sWyCOHu+roSq0z8y7Ey8ilFHBIncEfSoMxi559cOGc1t5MxFEajwyH12hndjmKPMMJk6AM98cEiyZUOiTEGs/lyH4OVW1ztETqDPcleDv+WmNEBNcWerSSD/+YAI+CUI9v14IO+puwhlDsue27WkPKFlVNn9JDywZdaIArGVOq7mnRgwLduqAueyt8Hih1g7ewPk71MMay8pXZGOzBQicYrapYKQ==
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(4326008)(7696005)(356005)(83380400001)(55016003)(33656002)(316002)(44832011)(81166007)(54906003)(6916009)(40460700003)(8936002)(5660300002)(508600001)(36860700001)(8676002)(70206006)(70586007)(2906002)(82310400005)(336012)(26005)(186003)(6666004)(426003)(1076003)(47076005)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4551
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT052.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 627f030b-bd77-441c-a717-08da1d43cf51
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rGjJk+EK295HYLVo/ekxPv291m+CdD7eRy+JqSjuc9QRFHujsZL0nRiEGKQd3LznM+vDq7hNToOnEdrz4+Dli6ioSkEf+jO6m9RFnvwHtkeNUfmABUIdTMldxW9c4ZSFwrGaJyd5jUiZjI8BO07M8KjWZ5qU996XqwXNnXkHb3MJcgrk/kBsSB3WvMB6b/1vafWsbzgxByn1xMq8mdk3Qka3c80lPspU130XC80fI3TCYnn3q1dk8mybrUES3AfsQzj/nKGWEP0r+LzV4nkka3iQqDplGRFMmtQaRLODR2NCW5OJXZTcdxGJnM5A4hcgn+lIj5tIjfFBQVVitVPvNLfX4Kw1hE8EDTg/JHhzRII0ew/aA008PQnzKPmxOJpoLhrsd661ZTyDTwGd0XTcWnTQW2JmHs53aJmyvbHCOH6IP8wNaWNQK1OV6Y590EDyOUWyu2O9KYmg427edyL9PpxZWmiJ1YsbCcbu5pAkFWRDeJkPc9+gmUQaWmSa1Un2L97v9erGJ1FMm73qtKg35jICu5pgb5wZfHalBY+GkoWLAOkPAzJMop/gKAmImYrEUgXMAAoH2HN4A8u6PDA/bOHgRpcMZGLk7r2GcNmqc/umF8sAv9Qa24BJ8+IqDLnJaPL/DNSa0Ss4HegVu0hJ7s2YEc0CVkDxbgjXlssfr5O+GfuUgYKyOHvnszNLWwBM
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(33656002)(83380400001)(508600001)(86362001)(47076005)(186003)(36860700001)(6666004)(26005)(54906003)(4326008)(70206006)(7696005)(1076003)(426003)(336012)(8676002)(6862004)(55016003)(44832011)(5660300002)(70586007)(82310400005)(40460700003)(8936002)(2906002)(81166007)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 11:50:39.3786
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 589dfa75-448b-4d12-977e-08da1d43d4a2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT052.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7083
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022 at 02:12:54PM +0100, Marc Zyngier wrote:
> Starting with FEAT_WFXT in ARMv8.7, the TI field in the ISS
> that is reported on a WFx trap is expanded by one bit to
> allow the description of WFET and WFIT.
> 
> Special care is taken to exclude the WFxT bit from the mask
> used to match WFI so that it also matches WFIT when trapped from
> EL0.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/esr.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index d52a0b269ee8..65c2201b11b2 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -133,7 +133,8 @@
>  #define ESR_ELx_CV		(UL(1) << 24)
>  #define ESR_ELx_COND_SHIFT	(20)
>  #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
> -#define ESR_ELx_WFx_ISS_TI	(UL(1) << 0)
> +#define ESR_ELx_WFx_ISS_TI	(UL(3) << 0)
> +#define ESR_ELx_WFx_ISS_WFxT	(UL(2) << 0)
>  #define ESR_ELx_WFx_ISS_WFI	(UL(0) << 0)
>  #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
>  #define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
> @@ -146,7 +147,8 @@
>  #define DISR_EL1_ESR_MASK	(ESR_ELx_AET | ESR_ELx_EA | ESR_ELx_FSC)
>  
>  /* ESR value templates for specific events */
> -#define ESR_ELx_WFx_MASK	(ESR_ELx_EC_MASK | ESR_ELx_WFx_ISS_TI)
> +#define ESR_ELx_WFx_MASK	(ESR_ELx_EC_MASK |			\
> +				 (ESR_ELx_WFx_ISS_TI & ~ESR_ELx_WFx_ISS_WFxT))
>  #define ESR_ELx_WFx_WFI_VAL	((ESR_ELx_EC_WFx << ESR_ELx_EC_SHIFT) |	\
>  				 ESR_ELx_WFx_ISS_WFI)
>  

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

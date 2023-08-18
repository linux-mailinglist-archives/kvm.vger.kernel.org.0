Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA7278033F
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 03:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357008AbjHRBZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 21:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357001AbjHRBYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 21:24:35 -0400
Received: from refb02.tmes.trendmicro.eu (refb02.tmes.trendmicro.eu [18.185.115.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FAF4212
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 18:24:06 -0700 (PDT)
Received: from 104.47.7.176_.trendmicro.com (unknown [172.21.19.51])
        by refb02.tmes.trendmicro.eu (Postfix) with ESMTPS id 2103E108B1E62;
        Fri, 18 Aug 2023 01:13:16 +0000 (UTC)
Received: from 104.47.7.176_.trendmicro.com (unknown [172.21.162.147])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 2D9B710000957;
        Fri, 18 Aug 2023 01:13:14 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1692321193.352000
X-TM-MAIL-UUID: faf92712-98bc-482d-87eb-5c05d2781dfa
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.176])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 5611710000E3A;
        Fri, 18 Aug 2023 01:13:13 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOgzKL92wFXuR1vF3IouDGJK2ntrMXizQv5c5JJCCRz1tB501gLNzi54DgGrOSuVbT9vdGON95Vim9QBhKnudozv/joFVoMs73lm592PeeS6qQNxbVHQcaoRhpPOqzC5GEG2HPiDHhTqhWB6HO2ARefhlARrF11kyOxcE6V6t5SCoeov/SmPney4kVQNHFgF7IPWscrsUJnAfkx+nSWisdA5I3AaEoDBvHX7LoE7dPVSzVnohrKk3gK24U9uxLAeUMh+jz6Y+hbwrmI5D3C18jKSKAo/oWWVfzZNxtlSynqzW/23J8bGGScXU86P9cH/Tj6z2FjZVzOsAT108OOoEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sd0xMbkVpMdsbjWfGBJLJq9sKsTGT7Cws5IiX58Zxxg=;
 b=BimefBjIHPsMME89ILQ9ojS3CXnZNhwrvBTPEaejC/I1BGnr6F0azgN8CwhCXiBarBbwG+pMHmnuCD3MnyV1Qyit5lnYOm9DytgwIi773Wq7ymSLg6sOczFZ61zsCjfsci435KsXGCWFBueFQ+0K/IYSsQYfWr6+ivO2Bu0d8mxs3B6x3rpVgnqNuw6Qdlvbm9vd+VkvibU/1LcWLcmLz6gpdyS/iu2r1/laYea6J91jrUzC+PShr4MH6gLx4siG4v++lWixwTg9PJNHyOyRZcx05SIYMNVBUedmtiZI9W8V1EIfS1WTAc8CUxjKINgiEiSvLRCqJDo1Ym5cd5tN1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.66.60.4) smtp.rcpttodomain=alien8.de smtp.mailfrom=opensynergy.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=opensynergy.com; dkim=none (message not signed); arc=none
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.66.60.4)
 smtp.mailfrom=opensynergy.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=opensynergy.com;
Received-SPF: Pass (protection.outlook.com: domain of opensynergy.com
 designates 217.66.60.4 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.66.60.4; helo=SR-MAIL-03.open-synergy.com; pr=C
From:   Peter Hilber <peter.hilber@opensynergy.com>
To:     linux-kernel@vger.kernel.org
Cc:     Peter Hilber <peter.hilber@opensynergy.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Richard Cochran <richardcochran@gmail.com>,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH 2/4] x86/kvm: Add clocksource id for kvm-clock
Date:   Fri, 18 Aug 2023 03:12:53 +0200
Message-Id: <20230818011256.211078-3-peter.hilber@opensynergy.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230818011256.211078-1-peter.hilber@opensynergy.com>
References: <20230818011256.211078-1-peter.hilber@opensynergy.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR05FT052:EE_|BEZP281MB2865:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 3fbba8d4-4996-42c1-30dc-08db9f884a6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOK7fGKlUH1S/drI3XnKRIe6c7SEyKHD9Ow+ZikMlJ6MrFYZH5cfqdIvEDMF/2EvHdOgOqcsIfvtA/wF9dLA25VcarVeAVDbKho90AGCeHyozATxADoOou5fv987QnjRvxjQJHhlogmreJsjsP0LSirD+v+nN1J1tLriBTWXnmffbCbMse1/YaGS/lLw+IyQcSTG0m11V3nJEZ1G4pN074Y2oM6ngHLNJcK/WBCvbVy7TdfGL0S3XRyn70XI61TAAKghCioOXNgdO7dTO5qwEDvxvxOtSkwpstQUm9GRdnEH5tpGx7ccfipc9rOMxLvTniWmzr0bKVtb7bfwpT0Nu6GV3R5L3tUGJSGrgmQZpNv8iAA1S0PK1oo7I5vyLK5mXAdqSvI8zVu0d2f4+aS3B2cOcvxWLEtivbPuhP+cRvjmXhv1YgVlezW9rCJUgRfyIIWBo/1i78GbCZdYEiR5JQQIAfyEuCHO5OIvM7ImUcOmWVyRfMw0rLH4u8J1CWLPKQTgiNYs4llBZ0QjoYkKoNosuyg50HK20h05Z/R3BlWW0JpDPvx7yHQoEMO/TphCi5MVWSwukQgUQ6PYSBcjvQV5AHi+h39XFTEIihGX/jQpC6IqmRXA5qWz360PsJ0Byg9W3qB09BGBqVoyyJ4ybqm6c75LwnFbbm1y74vSEqgGwPvQKPbdlYdbs8l8blcNRvC6CIt2J21Q7tLsIXIDBOSDQkteEyN0mtRMAQkrIqgFsUy0VC7Ig+MXQ85Q1KmEUtvPGs8X8mn7feWgzQhsDdb3TnWsSlL0iFVlr3Zmw9/YNq9bfyBLuoCjk81ePTJ0
X-Forefront-Antispam-Report: CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(136003)(39840400004)(451199024)(186009)(82310400011)(1800799009)(36840700001)(46966006)(8676002)(8936002)(4326008)(7416002)(70206006)(70586007)(6916009)(42186006)(54906003)(41300700001)(2616005)(40480700001)(26005)(12101799020)(44832011)(316002)(2906002)(5660300002)(478600001)(36756003)(36860700001)(47076005)(1076003)(83380400001)(81166007)(86362001)(336012)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2023 01:13:11.5027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fbba8d4-4996-42c1-30dc-08db9f884a6b
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR05FT052.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB2865
X-TM-AS-ERS: 104.47.7.176-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1011-27820.003
X-TMASE-Result: 10--3.039900-4.000000
X-TMASE-MatchedRID: 54gb2yeIOXTJ+P2VFrJmrMd/DBuOH903zmG9pmg8ncK3UJJ8+n/4RTRG
        JnoK3ysiDmwVuvw6qAzlE3nSJ4xeM4kc+IJJwSKgDnyoB5C0LDNWjA1tp7oHHtJAzldhFV5ZYfl
        NnW5DFQTfXDU2ciEUMsKjGRQnQ81hzxPIJ+YGuapbyCHfDNuoE3BFR2eL1QJY6cJ/6QfST1xxg7
        svMtapLk+Gkvbc+qu+uF0U3pWVSOzqHNzcF+UCWRfZc1Vhp4ltq2sDwgpzftw=
X-TMASE-XGENCLOUD: 949f7fb3-db96-4bca-a14c-4ad56801ef2a-0-0-200-0
X-TM-Deliver-Signature: BF3823D9FE8A90AF2FD657E72DA1369F
X-TM-Addin-Auth: 77tF3i+02uSzglI/UBL05OzpHP9cD+7voSHBVXYtnPv79XJti6rWQGHx/Ny
        xTaRTKJmk1TckTkKSM6cSQTy/n5HDnfic/3m7UiBBlTfV8UwvSTLmN2CxNkVtir68s4tlAbIrBu
        MkjLJb1BN2GJqEhMiIB2CjSgtdq06iz3zlgwpjSJi1wdXst2y/NEimiPSc1iKCxw9dwp0cGBOmt
        lQlCZuyW0w9RSAuOViXylVv3SQwsGtqpjNgXfvzlA/UQ4Yt5MP5sr2Bt7t48z2SMOaCxn+SKABy
        7jz6pqn3aFJjlPU=.Uz67PAstjBRG8FHdFG1poaU15Ef+jNJ+PtI+1/D9kxnzhr5pTLkGOGESYV
        77tZWZN33LkKye+wveAT8SMhKuTK+MUwYgB7sVTtlrBkd2Cm+DzRrxM4vpImW/EXoolUvKGf7j1
        x7vZnz0TAQOD+/TtJOGb611hQNTmATyhqwYX/I0wLSKjeP66gIbzrCj7vVV32fZc2ZsjoRN0Rpb
        ADyw02CQC3FyeyGnJz4BNN3M0DriUKqt31oaZ7cmHYJ9LQKRXVmo+lHHNsbDh3moBzn96VYW7Uf
        tF8FRvxJVciuCcPpCoCIIxbUO1mz4w38lRs4uZByJOSvG4VK8trEOTkceaw==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1692321194;
        bh=vV7Ej9eKlFTi4+bcWiqABO5eT8vfjs3MtKD94n7mM6Y=; l=1477;
        h=From:To:Date;
        b=ruzXdxi5EQig5kyUNF38IuNBLkkZ+kO3nrPSx2ETu8Uz9NfxtdHh3WRG7kDNoZWze
         Vh3qXlhLkFhVfpG9MoJg1Z6JOL9opLk25D5Cz9LMIMthqOVUl6iEBPHzV18gTnanoY
         SIkps7CzAhI/8GjgfBEI0NeWK2K05R3+T6ZVgsHjQexnrAZ1+sn6GvJcxTrFBnh1de
         oocSMk3engZQlaFqC66efnB5a0cbazvRgfwtwe1Rsb6s7OhLficfVIep7DNxYdPWlO
         0ajBV3YUCY4vHXNTtkIDpvoRI2U899nFkHDkzMlXNsnJbSRWC/thtFDJR7xLlqclaY
         Tbw3G4u2B2oPQ==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a clocksource id for kvm-clock, so that it can be identified through
enum clocksource_ids.

This will keep ptp_kvm working on x86 in the future, when
get_device_system_crosststamp() would be changed to compare enum
clocksource_ids, rather than struct clocksource *. It also makes
identifying kvm-clock easier for outside code in general.

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---
 arch/x86/kernel/kvmclock.c      | 2 ++
 include/linux/clocksource_ids.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index fb8f52149be9..a686733a2d20 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -4,6 +4,7 @@
 */
 
 #include <linux/clocksource.h>
+#include <linux/clocksource_ids.h>
 #include <linux/kvm_para.h>
 #include <asm/pvclock.h>
 #include <asm/msr.h>
@@ -160,6 +161,7 @@ struct clocksource kvm_clock = {
 	.rating	= 400,
 	.mask	= CLOCKSOURCE_MASK(64),
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
+	.id     = CSID_KVM_CLOCK,
 	.enable	= kvm_cs_enable,
 };
 EXPORT_SYMBOL_GPL(kvm_clock);
diff --git a/include/linux/clocksource_ids.h b/include/linux/clocksource_ids.h
index 86d23abfde2a..11d3cc318dc1 100644
--- a/include/linux/clocksource_ids.h
+++ b/include/linux/clocksource_ids.h
@@ -8,6 +8,7 @@ enum clocksource_ids {
 	CSID_ARM_ARCH_COUNTER,
 	CSID_TSC_EARLY,
 	CSID_TSC,
+	CSID_KVM_CLOCK,
 	CSID_MAX,
 };
 
-- 
2.39.2


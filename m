Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A11D1B1348
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 19:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbgDTRji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 13:39:38 -0400
Received: from mail-mw2nam12on2124.outbound.protection.outlook.com ([40.107.244.124]:36000
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725784AbgDTRjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 13:39:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeFDOG3srnAbwUbbMOH/pn/tyDFbfvLeoyD5xcGtHJqaSONKOBAUVNYyugEyeJJ1ZT2AKGytpbiLajHcTi3GluwQ0HDHxA9Z/DGcKTv9OmdbQMk1u0sLju8FdVZfGbzOivDokA70BLh2es++Up1mvzTYAKEV8wtS1JrwSB1Wt/H4YcWVjaLhZ9vCdSOUkCl417ClhuHAuwIN8gQqQm0oz5Qllj079UOHoW+J3afrzh7H6slh22+2GmsW5fAQ7Qel+dlked0CxqFnHmD+0y5eNhYwtmjuhsmfd8BFhRj5ulUKD7z4JhIUtySySYr1PxgNBQUfIsXtul7ag68u2t+eFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+FJPRWCBME3O7KGGef1+PrqQRgqyoCRq2kHsgRrvy0=;
 b=VHrr8fSyQoc6FjjgZG28lIOKbp5CZVxJJ/EjYCx60h51EIylYhhc/KdKURF0f/u/EB3vLv/NNqidRrZgU5vGiqvHaVINL7DLXOm170xuUfhGEqzwpzW87W93Ix3HFxjiJNvumYdeFajmzuAFaw7RRGhLvbWNALGTtCrXnhDmWWtIHkkE4e7klcAWWjEjSX3LIFJgiLOzqFamdgiFXsJIwJ7IgOHJsxxcchojYL/qP2XkqTJFCGm+5rXtA863j9tpRvKloeGOCc6pw5TP6wkdoFLqRfYTJQoW466uoRQAHWcL/5Xbp/nBPiKTxRwv4z20IEiM0F8TGvltdSwAhI/PsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+FJPRWCBME3O7KGGef1+PrqQRgqyoCRq2kHsgRrvy0=;
 b=BpPbVUIMGuEWlLg2jvPJvraaKP7NZVpZYBJPjAfuCu/HN4TMxCJfxn1ghOQ/hw2ZPkqieZ39L+5j3oXiMnK+GBva+DKaLqFiTTWE0mRxkKGlN9TZaWuaT3rtdYcPIADU7h4mWg8gycj/iL4KFS8g2wRrgkWTKrK5bi+Jcr6+Pcw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
Received: from BN6PR21MB0178.namprd21.prod.outlook.com (2603:10b6:404:94::12)
 by BN6PR21MB0691.namprd21.prod.outlook.com (2603:10b6:404:11b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.2; Mon, 20 Apr
 2020 17:39:30 +0000
Received: from BN6PR21MB0178.namprd21.prod.outlook.com
 ([fe80::a97c:360c:9ed2:12ec]) by BN6PR21MB0178.namprd21.prod.outlook.com
 ([fe80::a97c:360c:9ed2:12ec%11]) with mapi id 15.20.2958.001; Mon, 20 Apr
 2020 17:39:30 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Cc:     mikelley@microsoft.com
Subject: [PATCH 2/4] x86/hyperv: Remove HV_PROCESSOR_POWER_STATE #defines
Date:   Mon, 20 Apr 2020 10:38:36 -0700
Message-Id: <20200420173838.24672-3-mikelley@microsoft.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200420173838.24672-1-mikelley@microsoft.com>
References: <20200420173838.24672-1-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:300:c0::21) To BN6PR21MB0178.namprd21.prod.outlook.com
 (2603:10b6:404:94::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MHKdev.corp.microsoft.com (131.107.160.236) by MWHPR08CA0047.namprd08.prod.outlook.com (2603:10b6:300:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 17:39:28 +0000
X-Mailer: git-send-email 2.18.2
X-Originating-IP: [131.107.160.236]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8872f935-c5ef-4940-f5f5-08d7e551c78d
X-MS-TrafficTypeDiagnostic: BN6PR21MB0691:|BN6PR21MB0691:|BN6PR21MB0691:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR21MB069174203767E7019AB92C89D7D40@BN6PR21MB0691.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR21MB0178.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(7416002)(66556008)(66946007)(66476007)(6486002)(4744005)(16526019)(36756003)(6666004)(1076003)(186003)(7696005)(52116002)(86362001)(26005)(5660300002)(4326008)(2616005)(10290500003)(8676002)(956004)(316002)(478600001)(2906002)(82960400001)(82950400001)(81156014)(8936002)(107886003)(921003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZcBzknyZyo/Gfj8flV6mQld4BSlwEhDSvOiH+1k+qoKAJczqCuc7/+YSEbRsMeHMYs8ExDjInuMIBO5m4Ab1rZjQzMVBSxUkaC+SkVBtJkSZRcNsKZdx+xSOsyD8B056ApTVXZpSeBL/PIVqIxlAzriMwOySScvYGFagTtrcdLsJgw1BJGKS6qvHiQ3un1LPzS6JMtXoYT9x98SKfVR9QU9tFqHditFI6SVgAD5g+VM1zt710ojxoqsx0CQx/dZmRsHOZ3dreW4yy7bEbXC/9Ce7ymw589tpRKznRdPo1TnGz2jub0+GanJihdGLpGePctUCQUkjsZvm1BFzSXszlaSFANRDNcfHTQUVdAaBi7LLHswFVw/vkGcBlLxDUvKcR377ulvPjixyXjsNjqOcnPJb6H8W3aPxfliqZ+oPs+C8M+LOg5UWYmoiS6fN8OksIgRxCkf82AIUg1/TTlCnPo1pVZQzCpZQNNl20CiBBrs=
X-MS-Exchange-AntiSpam-MessageData: BMRLLCPj2GRnbn49rEJoZMJmc/GRLFWnx3NdezGRf9wOBEXjw4sbdxcF04otkt1Prh63U1PtDyxqLGb/UAcTT10PN090beK9770RxCubiTYT42jHGVmNTIPYGUm8Cwg2zLEOgp1wlEqt8QFlCsgnKHTg0QA76K9r3cMd26P4/v+E5/Rt6egawEaJFYxys0naFVPq9yWzgFMgy8A1bVPcUxP1fzUjLbjnOnwB8d2IEYyXHU3FutFkUFkkMjZNsTen2rYamdLF1gOiChZLe0keluKG2Rh42azwz14hOzD3TE8cl4NPXgju5N9nHb7xEQ+06B3Y5+QS6Wws1pBh3dk7akcubDc8I6xmE4JCM9tCZ2NFeCq2P3aMJi4o9AI2ovJAcZ6xrud0vWunZl5DTpi8WHqzPJLmvmvyuuQ8rr/IcA5X+Q40C6Rg/Vm3azuc1drrg8zfEVXxy/Njl7T9odF7p7m9+bmfil6Q4Fi61g1bbrcciAIb/dvl5f9zjuUciknAZjgknNhu0d/NhG9myOGqCGnXJkl9r53Mb4jXndsBLM4rSEPnNvMFKYr3MRlFvoQbM54gsm6c0EFfzXMUEtr66ExOFFsiSZVQcuL1w88rpn5lqr5UAp4DykvZ3yrYfoC9xtoPr2pGmxtOheUYuhfV0Wqb8c721nGYkpZ84iKWRmAIFpxTpmUgfvONc4Nbni5AJ/A2gMtKXGDMdSw14DipBhN5JiIi+fpYy3+fnl2rZ1LG7cUmGDJ1i0TGoDVdxR8RTo1HR7j4vclGEochgFpRuQoSZjz8SbIq/Do78kFdIh/JTPNTKWuOLDOzeVtBTMjz
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8872f935-c5ef-4940-f5f5-08d7e551c78d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 17:39:30.1934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R84C3NGGbebtQVShMbDam0tdqYc7YKDiVwDnARWLucrbHBkmxynKPYKpUtyl2i0l/omyYaF3ArGTkUM4zs53Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0691
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The HV_PROCESSOR_POWER_STATE_C<n> #defines date back to year 2010,
but they are not in the TLFS v6.0 document and are not used anywhere
in Linux.  Remove them.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 0e4d76920957..2dd1ceb2bcf8 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -390,11 +390,6 @@ struct hv_tsc_emulation_status {
 #define HV_X64_MSR_TSC_REFERENCE_ENABLE		0x00000001
 #define HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT	12
 
-#define HV_PROCESSOR_POWER_STATE_C0		0
-#define HV_PROCESSOR_POWER_STATE_C1		1
-#define HV_PROCESSOR_POWER_STATE_C2		2
-#define HV_PROCESSOR_POWER_STATE_C3		3
-
 #define HV_FLUSH_ALL_PROCESSORS			BIT(0)
 #define HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES	BIT(1)
 #define HV_FLUSH_NON_GLOBAL_MAPPINGS_ONLY	BIT(2)
-- 
2.18.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176B3347E8E
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237126AbhCXRF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:27 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:50401
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236993AbhCXRE5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:04:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVViZ7dJiTw8pVAXAkLNbGBXKJ5r4TI3ZxzXrlHfrBQaQy5X9KTJc0usJh+saExU1ibEMB/TtmnSdVSMWZEHpkbRCGCgURBY8BBcD240VMIW7131COVL+nk1zmbql4PzMBjOABpjPM4+/Zg1FT9e6p/g1jmHp7wyzdDF6dZSuIZWojplaUIBRZ1wqU+cThbXtB6O8eZ/23b1zd/toLGyjMG3tBBWayGMlJMD07YweTWNX6KPjI/mZLUtyVNG0kvG/mJ0bkYJjEu08AdDH1rN6rYljURkrE1VA0Eig8e/ha/swaJg2zwD0EOl4ipm5hBee9dlCTVug1Dx5eL9lHTUkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IG7ljZ5VGQRURIB0G3dZTvCjGlMm9xP1GQIoqinyO0=;
 b=Uomh6eaPoSI2OyKLqSxY/y+Dh8KAWLiGfDWZm22alS9ip5kZARXMi2nr0EFgAO68uYgRm6lqLVYN1QsIYTyvQ3S2HNI3ue2kpyXJ7QuY3Uu0dLO+pcV8aY3Jizww5AQMuo+iazvqSgsdBGgc6HkUMP4WinYXsVcbxLoCY0vy12oyySgvG3LsvNmZgj1dDn5nGJODtMEZxAi32iUNPzkIpfRo5D1VMY6/uf3+YG0qCT5zJf8qinN0h/gExybV+fXvkEaCxh9WaXojbMZls7LFOSq0FcnuD3yojanqr94cYO17BAT8cGAvogvPUFWuEQZW5mGs9JXMUD5OoFHfjTB8gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IG7ljZ5VGQRURIB0G3dZTvCjGlMm9xP1GQIoqinyO0=;
 b=vX6r6xCyP7kvz9H2KHVLSIMpO3ytmzJU+XiAeFd2REU2hebpww7YVE8Htzp76ekMU9FtjW3ey+mtx75F3kWpuvwMTZtSfUYv0jldJRwQXVBfqISoiU8pRBgvIcmHnZG+fmDv+V86C86u3fXPEwx7P8npoUYeWyXI/K8FQX9wcJg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 17:04:54 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:04:54 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part2 PATCH 05/30] x86: define RMP violation #PF error code
Date:   Wed, 24 Mar 2021 12:04:11 -0500
Message-Id: <20210324170436.31843-6-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:04:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ba61c764-818f-484f-e00f-08d8eee6f233
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45573626FC6E518C6C956C50E5639@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VFFZ/MyinJjrgK1lNWaL4Tnt9tfqFGuKzgxs+/Rw+oGquT1wejxet6XHuY2zkCt0kblLaU5iv1VcbQ4/Lxr6sSFvHRO7EGMHB4hf8aBo4Svkavc2Sm0J6121Tpasm43qj3AGIaiFmTxo51+WNW2feB8LihwOImWL/HiYvnrOpazvH3Jql+ZNsbKc66vC2zi+eG39rJ8nhoMzAoXFBxZIYnfMocvosAz6po8lOZByRUXRrrW6UBB38mTT0IMQnNAnV0Qzb3OOiS3tP5gS2s43zSiRGqqPgPlFgTr08VcEYYRWIE0R02yhpXqNh4BtsK0P7F/8TpYMZ/74lPiHL79UmbM95Qq7swErAE6/tZC4lLdslK0MYSdXYy2Gd6e8bjp+HvoDkn6oo2L4XwRqy586MJlDFQxvI5RSkSIf57Lm4mG9BvCJwxsHWnfpb2JF9GlcjrFvk45T5hbMcHe+3YQLCFMsUAjT6v0kDA9CDgnVV5AmkpnE0CYnluUYEckDgRXM1KNXP0GjfxTdZPeluq7zWmepO5c5NqFCIO5ZEqPzISKUWU6JXJsZe+cQ+NUFtmtjpEeAG8/uUKzJS8poTB6NX9bZjxWSYXUZTadg9zOrcR8UP9z1c+6UBwp725zS4sKaTAJD+LvIFL40bbaxEWW3KQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(54906003)(186003)(44832011)(6666004)(4326008)(38100700001)(26005)(316002)(66476007)(8676002)(16526019)(1076003)(2616005)(83380400001)(5660300002)(6486002)(956004)(52116002)(8936002)(478600001)(7416002)(7696005)(66556008)(36756003)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vUbOCMZ2smncCJJ//K79LXF271PL086l8FXKM5yzYJAspf+ZfcCHmG2kVk8Q?=
 =?us-ascii?Q?DunJDfzHS29edknQLZz6GF57aH7ASTOmqkIufDIaVmns54Jj8/NdOLsDkH8w?=
 =?us-ascii?Q?33s4bVV3YOC8CTJ0gyAWxoxDU42GnViTHvbLywlU92Yar/1njojv37Bf/Dss?=
 =?us-ascii?Q?9mBoWV81OL8kJeEymK5J9XyOjPfqGb0Nmlcj3jOMFBukBskicOykTLDo80OP?=
 =?us-ascii?Q?I49veALxXYgeWI/vEci4zHPof9+Qmdg/eWbYY9YyB0JflwPSljZxItdqsdvu?=
 =?us-ascii?Q?1N1o+Wo/Tvm9Q7Ocnb3xdHCyQTj9EmfFpBCbKzvQ+GulPznJ+iG/d5vlKY4d?=
 =?us-ascii?Q?GDGdWfVlqq2H1z1MV8Wal3pjENN3xp8pYAskyYkFScZbksI0q9Au/R8i/v7j?=
 =?us-ascii?Q?hH+AKW+iRcdgPfofIc/6k5phvI0TMHfnDtgqfQpJa7BLzGtKqv3r5rUxeTTS?=
 =?us-ascii?Q?jTFanFOBp5CHNvjjKE56XmCHYA6T/9Cq6M7fbv9A08secUi2Ibq/QwE957ET?=
 =?us-ascii?Q?aA3BHaHNz10d4YLgk7K9e7w/NFpv088KiVCZw0sYGKQ7fYtusxQWgeTzQQyk?=
 =?us-ascii?Q?Ilk1o7MFU/QCTnH+KHNE86UgUxV968n46F723Sf/w59nWcuYzeogCvTNMgTt?=
 =?us-ascii?Q?lODqpzOsR9vW2LN2DqxhWVBAuDR8anaE3qypJGFXQtW4k27gPFzsXVdaLu+S?=
 =?us-ascii?Q?JObWmfaua2X4HqBd07ES5/ncyNy/f6TpNvNx64oaLQ7eHEcu3ZIbQEc1efRn?=
 =?us-ascii?Q?JcX63MvCkkRJYGnCCr7uVst4n2//12OTpjjIF1KHrEr2RVTgKvMn+/1tNuFO?=
 =?us-ascii?Q?mhn+2Vkfennx0z8dNH6yjwz+Bguk1+kJD+DRRM0B3PlmMP+nNx5OMoGEVBt+?=
 =?us-ascii?Q?4dKH9MdRfxNrW2VuSlFOEjDfzXh/wqwuTHLo1jMY058LnBm632J7zUj96UQm?=
 =?us-ascii?Q?YQiYTf6ajnogBg8apWinozr3SWvategNXU57TRam3xhdLTlqcIQdU3+fzUaR?=
 =?us-ascii?Q?nwDBd//28zwxCaiMhfAfPSiHMfnBxOSoPi66yMPnUtp+Ck8CepMTbzkM1uHJ?=
 =?us-ascii?Q?HikyATr/dv72aTaIAF4iGDHceEPnZ4mArsbni1zUpWcoISIW0o1zb3d5oZwd?=
 =?us-ascii?Q?bTC84mtpcVgAbIAai4zxWtmspZsMs4MZVs8QdtNTFLFQXg4MFmRMV0kiPN6o?=
 =?us-ascii?Q?+hFPfFrRmRQdJo3q8LaqQCJXqx3Kv3AsYsmiFwCCInapMJ/rBbmANfgZc3o1?=
 =?us-ascii?Q?gF0J4ayH0okD3AYt1lrbkXONeFiwj3RG2k6RSoVitqLDtaAzxuO+yEJL+OsQ?=
 =?us-ascii?Q?yAw+EdO4GR3E1TbxbxLslYrX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba61c764-818f-484f-e00f-08d8eee6f233
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:04:54.7499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7YGUSCPNjIGqTQeXmoLd/1LRT85f0Mhy8SGfw5jXhpP8x7TQN6h1F3uDf0NP0/J2PGVhcnnCxtNZRl52z5+fTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bit 31 in the page fault-error bit will be set when processor encounters
an RMP violation.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/trap_pf.h | 2 ++
 arch/x86/mm/fault.c            | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/trap_pf.h b/arch/x86/include/asm/trap_pf.h
index 10b1de500ab1..107f9d947e8d 100644
--- a/arch/x86/include/asm/trap_pf.h
+++ b/arch/x86/include/asm/trap_pf.h
@@ -12,6 +12,7 @@
  *   bit 4 ==				1: fault was an instruction fetch
  *   bit 5 ==				1: protection keys block access
  *   bit 15 ==				1: SGX MMU page-fault
+ *   bit 31 ==				1: fault was an RMP violation
  */
 enum x86_pf_error_code {
 	X86_PF_PROT	=		1 << 0,
@@ -21,6 +22,7 @@ enum x86_pf_error_code {
 	X86_PF_INSTR	=		1 << 4,
 	X86_PF_PK	=		1 << 5,
 	X86_PF_SGX	=		1 << 15,
+	X86_PF_RMP	=		1ull << 31,
 };
 
 #endif /* _ASM_X86_TRAP_PF_H */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f1f1b5a0956a..f39b551f89a6 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -547,6 +547,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 		 !(error_code & X86_PF_PROT) ? "not-present page" :
 		 (error_code & X86_PF_RSVD)  ? "reserved bit violation" :
 		 (error_code & X86_PF_PK)    ? "protection keys violation" :
+		 (error_code & X86_PF_RMP)   ? "rmp violation" :
 					       "permissions violation");
 
 	if (!(error_code & X86_PF_USER) && user_mode(regs)) {
-- 
2.17.1


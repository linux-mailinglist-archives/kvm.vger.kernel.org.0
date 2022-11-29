Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB85263C71A
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 19:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbiK2SX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 13:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbiK2SXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 13:23:22 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB805F85E;
        Tue, 29 Nov 2022 10:23:21 -0800 (PST)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATH78qr018390;
        Tue, 29 Nov 2022 10:22:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=uvRPPR7HWq2+gFtlVBakUAOCyM9VPC5Y9xZaCZN0gt4=;
 b=XIoSECDOFDXYPcUoOigPLNUB4KOX7QUXnyjPHy4xMxs/H5lvjcZskHrdVqsq9wXzfpqi
 ykPCbuV8mp4UZlVBJ2Hyfr8p2Dhf1BliUBuxcBKNN2bBNM8fGk+xZAew664HegomWGZO
 2R6CTiZRx4gwl1rXkmYpS9CQ/G0PVG0K8IphBBHCoB7X1oRGNPjM7dXwyrQhikayxOQG
 dv6drHLNbpnsahn+PmioDXVCTOMzgGbkLO4MgntJvkPkhwL+ijur63kolTFpeFSm2yKc
 3jBKK2Zor9fUU9Pfx6/yGbnw7nofbFfoGXD9f2TWhJsIgS9zUdx34VJIm419QbUvwqWg tw== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3m3k75yu3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 10:22:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8wH8zSqOmISKQU1AbDtt8/6Xjfxdye227rRRqhfeGSzQp9BH4aoCUmjYOWikYYqJMOq/bQmcWQqeq5cHmEcNlJvlBx2lVISt1CZHfSlURX4v/uvLgmka0arQFNU7WDJv2qAA69srWLPax1RdEqeFZB7JZVgvNPM8p8s/yG6qhiGwxNNyIwcolHj+ANafBOp3TbU4O03+tu3gLmrBlNMqkvEmB6c7ja4s1lVDZPpLklww/ssIgimbiHlWixagbzmANr7hvB9nqtkeTSbhmDteY3KdEu0/TGHzm9VL27w5ooNuTmLhCpSRcS2AIiAJNRPm+EBAQN94ePqBLPf1gJrpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uvRPPR7HWq2+gFtlVBakUAOCyM9VPC5Y9xZaCZN0gt4=;
 b=QGLQRMmxeK0qPgipbE+Uq8w4tTv2D6M45+UVSMKRJFXqZ8bLNkOm4vA3hhFE5J+pCzZ2o2D9SNtm755hJqYidlJYP4nWyd1ixu7HhCkvS/UqLAkGfBog75upy9xESyR8+FTp7KDHaKp31tUsLgdt19cRdqqoaD/BXOB9hsirxC461JRjc5aUtChn8/S8MO2BSxX1W+qrns0eLqLr3wLDgNZK4jSvqpoxZWo7Xhy2WO6cA3XklCp2Q2hQ3DtH5Jf7hBls4Nb+sDJhuYQjqC0hw7T/ZAfeHPwee9KqnOheiUCDt55wfPBxixoQetFWiAfXx+JuG12eL6OUotF91EoAKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvRPPR7HWq2+gFtlVBakUAOCyM9VPC5Y9xZaCZN0gt4=;
 b=MqZc3gUVyUSNxyY38p9J9hAwXpYYOmkSv2D6bg24Th08tC5EwIwUBEqqdZColsWsNrSFM6vuE2rSbIUIm/5q876Eh557cHQA97qxdV7Dr8oGpSaZSyyg9/ZnzgTV+yQJLbT9VbGm6C/EqsuC3oFy4k5YJI23SBxiPFxiS+4KpJYiq79R6ISQhhYObkTWl5hLQ1KoV1ODnmJp4rKdYqS4ScDNdvS/yaRgFPVBWoAU7L9Xdypoya6EknX3kopMvJK5OMLlMTAJQFxSY71m44quUZy+laxMxxk49TpLK2QT8k7Rj02FCZKZQ4A4F4I9HupGYVkk9ZaIq7rR88B00EOh8g==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by CO6PR02MB7810.namprd02.prod.outlook.com (2603:10b6:303:ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 18:22:45 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::ea4d:10a4:a7a4:9567]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::ea4d:10a4:a7a4:9567%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 18:22:45 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jon Kohler <jon@nutanix.com>
Subject: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Date:   Tue, 29 Nov 2022 13:22:25 -0500
Message-Id: <20221129182226.82087-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0031.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::44) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR02MB4579:EE_|CO6PR02MB7810:EE_
X-MS-Office365-Filtering-Correlation-Id: 76bdac8c-e460-4bf2-5cb4-08dad236b661
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vxBGq4nXdwYc1zVGows4L7QDpZJ5e+Al6L1WsNwvc/mN9q5+afXPgc0pz4vgvnVXuUS8BAz4nSvmOY8569jiLeehzIJRMGwX/tlZI0nMz6NNwTU4jZ3vQpXA7F82sU0ZhipB3K23uENAxQQ6eMVfmBn8CtwM1kCV2gyv9C11s9x2+xJst7S1SEdtGbYHTGZFoPDpbpkpMDPf2dkVvn19IpKbewgWSA8uLb7RRS4oEXl88g44aeFs7rm4K1788RnsWQwRkiD7rVo7Sk45+rbXJx62ZWgSjmPYKukWwgrSz65PmtCquIrfMA1UP33f7+ht1MesKYJkVUdsLPjE5zUZjC7d1KQ2jnkzsg2JkR/MS386iHtvrXQKAcfbH6fMHalqckFinhuMBVcG4r7zTkGAFn/XyADP7x43IBV55A9vamOOnvEWxmjp0aIC6b6Awv7KqKYWIcjwBTYfT+N90h4J1H6rPV54xxCi2uxHiKeLoNXOjLmuESXvzu+UX4QG60PaZ0v+qaf4mXeMWsEqK1f3O6F4R84flWtXIZpbEVUgu7xtn8+wBCkkCZs4nKfOd1m3JPWc9fw87T1/D1NamoWDUajkMLaUoo/nZ6jg7PTL2u5aDTSueuzncOYA/GB2xkZqS8ZaPTJlnnay/Q0EoulXuV5eXVsEMKiMx5jZEURaKrldkZFOz6ACvtvRTE9pqCDvAWyqLobzdBQdfb5UZaolHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(6506007)(478600001)(83380400001)(86362001)(107886003)(52116002)(6486002)(66899015)(6666004)(2616005)(316002)(6512007)(110136005)(8936002)(41300700001)(5660300002)(7416002)(921005)(2906002)(38100700002)(1076003)(66946007)(66556008)(66476007)(4326008)(8676002)(36756003)(186003)(46800400005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zhmO6h253dT4kIJaebDIkGM6YPu/2ypNVHOPaktn8ESOMIWBSOxfqEyGAj1o?=
 =?us-ascii?Q?zt/tI+DmJTL4l/gqkHzzaMyWellsLTNKb5FMME4TpfSY+3mdXqStMWV6xhOO?=
 =?us-ascii?Q?/ajp0dSuYT98/pxfWbbgYdaONY8tP45l7266fkgi22B0DGAhm6/NrVjf9/44?=
 =?us-ascii?Q?onFLBk2dpC7B+zvssLPnpT1KTVL1QHmDRhDyict+17aRfcOWCdcAmQa73tMg?=
 =?us-ascii?Q?rIk2NpVJ0sgScL/KhH/qdCek3wo5O2EWO33grUqJPOd0Vh+jsqWY7HwIQnZX?=
 =?us-ascii?Q?W81dqSgzogaomXFz8D5Hki9J1pLVXjYHjr4OkdsCfBCaP8C5JJcc2zzuJOS/?=
 =?us-ascii?Q?kp5mAi6P/5ljw0ADfCUWoMOAWv8/GusvVSZTNFl0vUE/kju96V2rqe4IyaP/?=
 =?us-ascii?Q?CCb4q8N1/uPSToj/q1sZJUEUcdRczHcGmnHallut7hjcGRjq3meZ3kGf6EVl?=
 =?us-ascii?Q?yveGkfe1hygM4y7wTVPAk05SuV6/8p4OPyqGjXuaXfDw0/YlX4ZYQ4VDvBQt?=
 =?us-ascii?Q?xohnhwiqVZxPh4NpiOT3EdEj1CuHfW1C/esErcXSVzFu3C7lT2KPklBujWbF?=
 =?us-ascii?Q?2mY8FuzYu+ZUJeYJ82QXl0P2JUS3AFx3wi6MLOzpPtINjRo45jA+5MTothYU?=
 =?us-ascii?Q?405O13O/UdHTMUR47I+jtliYilDIJFIV4nQw2Ly2uuW0k5zI73fAubaxCNl7?=
 =?us-ascii?Q?A1/tAwrS2GcqbqYM3HJ/fpRpjSg2z5Tx7sVe4QtBdf9gsORk02cmsR+Vj8h5?=
 =?us-ascii?Q?liePge5Mo+KQL31OWodkrtykgXPaEnsUddtsKIJHwFpZ5SrcM08P2F/oBQ73?=
 =?us-ascii?Q?r2re8FwkpyUri2rVnXj0eUtsRu5bfvGCzQw6r6hT3MlniZ/ndC+XmuvB4z6Q?=
 =?us-ascii?Q?RTJw7pjpxbJhaDIMiO4R7j4khFb/n6kZFwB1Wc9VAT15Lpy3LLfyijihHCS7?=
 =?us-ascii?Q?BxhERa7inVX7O6DdvULwRz5EjDquhC26nLPRro7Sf3DtSUACLzZKDEl+C5p/?=
 =?us-ascii?Q?bU5/7W/84FgH/ImvGHuhiCT1faYKJgjBy2ZDaAA3fGAik/Yee/EWaW6uM9kQ?=
 =?us-ascii?Q?UE/ke2WyNtJgJIyoEg93utb4SXTQ/aYrjujvnMB7ryspGsG8grfGOfxrRp7W?=
 =?us-ascii?Q?BW1siNAk4snmyn6weFILf3llAs2qk2LAynHa2PfuF5IewnIaf1dU5Iys+rZ0?=
 =?us-ascii?Q?zfUIcn0BqjbsUWChqmzdsqt6Bqh4oVgN39GkmU8sdpMDNApMHzcZzaHRf6fC?=
 =?us-ascii?Q?zNonndsDQ1a+sBJlkOn47KUv1Bv1f3FtHjKAeMtTWAPrc4I9xBTgJ95LF+iG?=
 =?us-ascii?Q?5SMEBY8oTg77+BMT2g3wnNY4/E3bfC+dNOjjhXB8xifnuRi9UOzfWZ3o9d8t?=
 =?us-ascii?Q?rx4GjCAlBzLxOKqbkDFMUTtCe3SRd3Nl7b59R6kPDbJ1BFORXciD6pj5pS//?=
 =?us-ascii?Q?7OlhM4DiEy/qdXZkeLWBARgSmCqsqvtnwUqTex/jCeZWBa1GYFKtptpbQZHr?=
 =?us-ascii?Q?jd3+f3wp3yQaRNodb7ohJarlUT28m79MngfVKjOEoxtGLvuctUMee2wi/hIR?=
 =?us-ascii?Q?8sfMDpWLa169exaawSY3rCniUZSO0D/wCzVeUx7GGoiujCn8M1HgIjs9JwBl?=
 =?us-ascii?Q?l24pKAcUw7xARrBC/8lo6TKhgZv7LYXRk/wBpMWfKT3r26l/tSGd9jLiPqtO?=
 =?us-ascii?Q?DBSe1w=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76bdac8c-e460-4bf2-5cb4-08dad236b661
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 18:22:45.8122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PDFnyZyX6skKSG9HhhqFSweyP8S81eT08S6wuNjFijO1iYswvR9akJ1h+y+4lzICoXmRnLn+hIM0WH8Qvo+0H6dOjSzwf1Dy+zYR8A07UUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7810
X-Proofpoint-ORIG-GUID: pccMGLMFezRjx-wyZiMadVqRJ4l8fTEi
X-Proofpoint-GUID: pccMGLMFezRjx-wyZiMadVqRJ4l8fTEi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_11,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set vcpu->mode to EXITING_GUEST_MODE as soon vCPU exits to reflect
that we are indeed exiting guest mode, but not quite out of guest
mode yet. Note: This is done lazily without an explicit memory
barrier so that we do not regress the cost in the critical path
of going from the exit to the exit handler.

Flip back to IN_GUEST_MODE for exits that use
EXIT_FASTPATH_REENTER_GUEST, such that we are IN_GUEST_MODE upon
reentry.

Changing vcpu->mode away from IN_GUEST_MODE as early as possible
gives IPI senders as much runway as possible to avoid ringing
doorbell or sending posted interrupt IPI in AMD and Intel,
respectively. Since this is done without an explicit memory
barrier, the worst case is that the IPI sender sees IN_GUEST_MODE
still and sends a spurious event, which is the behavior prior
to this patch.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/kvm/svm/svm.c |  7 +++++++
 arch/x86/kvm/vmx/vmx.c | 23 +++++++++++++++++++++++
 arch/x86/kvm/x86.c     |  8 ++++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ce362e88a567..5f0c118a3ffd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3907,6 +3907,13 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	else
 		__svm_vcpu_run(svm, spec_ctrl_intercepted);
 
+	/* Optimize IPI reduction by setting mode immediately after vmexit
+	 * without a memmory barrier as this as not paired anywhere. vcpu->mode
+	 * is will be set to OUTSIDE_GUEST_MODE in x86 common code with a memory
+	 * barrier, after the host is done fully restoring various host states.
+	 */
+	vcpu->mode = EXITING_GUEST_MODE;
+
 	guest_state_exit_irqoff();
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 63247c57c72c..243dcb87c727 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5878,6 +5878,17 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 
 	if (!vmx->req_immediate_exit &&
 	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
+		/* Reset IN_GUEST_MODE since we're going to reenter
+		 * guest as part of this fast path. This is done as
+		 * an optimization without a memory barrier since
+		 * EXITING_GUEST_MODE is also set without a memory
+		 * barrier. This also needs to be reset prior to
+		 * calling apic_timer_expired() so that
+		 * kvm_use_posted_timer_interrupt() returns the proper
+		 * value.
+		 */
+		if (vcpu->mode == EXITING_GUEST_MODE)
+			vcpu->mode = IN_GUEST_MODE;
 		kvm_lapic_expired_hv_timer(vcpu);
 		return EXIT_FASTPATH_REENTER_GUEST;
 	}
@@ -7031,6 +7042,18 @@ void noinstr vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 					unsigned int flags)
 {
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+
+	/* Optimize IPI reduction by setting mode immediately after vmexit
+	 * without a memmory barrier as this as not paired anywhere. vcpu->mode
+	 * is will be set to OUTSIDE_GUEST_MODE in x86 common code with a memory
+	 * barrier, after the host is done fully restoring various host states.
+	 * Since the rdmsr and wrmsr below are expensive, this must be done
+	 * first, so that the IPI suppression window covers the time dealing
+	 * with fixing up SPEC_CTRL.
+	 */
+	vcpu->mode = EXITING_GUEST_MODE;
+
 	u64 hostval = this_cpu_read(x86_spec_ctrl_current);
 
 	if (!cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2835bd796639..0e0d228f3fa5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2160,6 +2160,14 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 		data = kvm_read_edx_eax(vcpu);
 		if (!handle_fastpath_set_tscdeadline(vcpu, data)) {
 			kvm_skip_emulated_instruction(vcpu);
+			/* Reset IN_GUEST_MODE since we're going to reenter
+			 * guest as part of this fast path. This is done as
+			 * an optimization without a memory barrier since
+			 * EXITING_GUEST_MODE is also set without a memory
+			 * barrier.
+			 */
+			if (vcpu->mode == EXITING_GUEST_MODE)
+				vcpu->mode = IN_GUEST_MODE;
 			ret = EXIT_FASTPATH_REENTER_GUEST;
 		}
 		break;
-- 
2.30.1 (Apple Git-130)


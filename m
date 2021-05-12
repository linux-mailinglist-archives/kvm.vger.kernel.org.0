Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B517237B4C2
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 05:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhELEAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 00:00:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51640 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhELEAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 00:00:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14C2ZY7E029450;
        Wed, 12 May 2021 02:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=T6DXo5D3HpC7gxwXj2dOrWQonakJF0RILsSsA4/u6Tk=;
 b=TQQ4PRrom+kBoeEN/eh4/a87tlsCEt0gEYOA4IslF4OTv6Q6vCatPL5gQRPjaOOol7Pu
 eWlyv/GE4m2wUB97RXHV5L9On3IUpWGMHF3fVCCFIrNU+J1+/e14jM3t3+AwZYxgd9hN
 DzXZT8FXI+CE3FddN0Nt2Jq7eWTcFmpZLBLyj71kCim+En5ozWidVsOXnW++g2WvFx4L
 x7vHrr1ggWTlbnVDhFGaFmvj/0JAebKU/+nXSkJ+LNCgbhFsFCMeTbMgyWJAEcLvVD3M
 /pu89sEkepScCwtDG335gnFY3aQ3GjNf+/BmyZFHYsBqafzKx0XXqfniPyyn3PYJlV4m dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38dg5bgrn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 02:37:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14C2YgI4168780;
        Wed, 12 May 2021 02:37:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3020.oracle.com with ESMTP id 38djfadpax-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 02:37:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHCr0jyku5Mco1YF6HP7pziGaL0GtA+hoBgxnmZFQJSYwtcmxLdWp47SlYjVyPgYeswzDepXIHPtwOTSPmQIIBkEixOqu+y6Nl01szdU60KQ+8UETjxM+syWVkf0y4PLaw6f0RgT8SdwSZzP+nuYEScPCnLwLtf6NHgBoY4v/zw4L7W0f86gsNV3y99G1lGjsdnQ+wTRHzwopavOrlxSoieSIJVz2xhK622Rwo6mQ6sm1F09ykta2GVwsDw5leTf1DbRnF/ijcDwojFgOzO6RdwY1EFTrBr9UagSqSzsHFrFCQJv4jj9c8XQ9cTFP/QN1T81rbOhowdoxSGgl8zzRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6DXo5D3HpC7gxwXj2dOrWQonakJF0RILsSsA4/u6Tk=;
 b=OzaACOOGJhbUYo6GOLQBJumKlF9tyfkrDdeGedy8fyjrQN+bMHYFsFXG1QMIagqGQvoAgStM2Mo/jGsOaP4WisMoB5o0v4eAEhPBMVQTKJz45ZOUnSw37USxGZkD0eIbV+QF4FehtR8bYUB++Sd/DSgVovsJizrv2oEL1Yb9nIDapdbfj7dcFZvzGLUeSOqbBw0sXDWnYKRYmqbl6vdwPAW7T1Qr/OQtYJf77hU7gqMR8qt+KaYokXdmXUx6SpfiS3torN+nRLqPn27x8Yz6HsEIkQp5RWF5SCnO4ncOi5popLEYW/5GsyhH055GD1RhAJNynNpfMIuXRwrQ7a/8Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6DXo5D3HpC7gxwXj2dOrWQonakJF0RILsSsA4/u6Tk=;
 b=PXpdh8wAskDbR1xBps/IFXvCWoONKWuApkEJudT2KZCsoV7PaIXuNmlj/0/pcdimYnOjB/dK3Uq0z88/dcqn5MbLgI2MMn21GX59okbPSOCiEsCZQ7HRT0DnOybjtm22EGT0xAutRSu9v1e6wOj+WGyMv+U28kEWoTiibN4p2y0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4425.namprd10.prod.outlook.com (2603:10b6:806:11b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 02:37:11 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4108.031; Wed, 12 May 2021
 02:37:11 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/3] KVM: nVMX: Move 'nested_run' counter to enter_guest_mode()
Date:   Tue, 11 May 2021 21:47:57 -0400
Message-Id: <20210512014759.55556-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210512014759.55556-1-krish.sadhukhan@oracle.com>
References: <20210512014759.55556-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR03CA0016.namprd03.prod.outlook.com (2603:10b6:a03:1e0::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 12 May 2021 02:37:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ab18957-70f2-441e-a896-08d914eed847
X-MS-TrafficTypeDiagnostic: SA2PR10MB4425:
X-Microsoft-Antispam-PRVS: <SA2PR10MB442555D7DCE9E9117210505D81529@SA2PR10MB4425.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:167;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7WfyLZIoF8JTblOjz4u0cJ1U5dJOGR5mZ2OFwn06mn3EJolQCc/wv6cipgy9frq5NWHX1sEeYNpl3sl9fMNFeNtWKiixLq5JwKWZUeA5YaMhipT1bWQxmmnO5ODzlhNf1+Wky5H0QnhlY6wUkt75CBa2bDXBAgjJgM4NAMsyL2Fd/BMEpuV/XNSXnzpeiB/gPeQJvHvYbSm7bXkvi2LfsjPVNEwjiRI2D6EyE5DIUAonsCl1SBARU3+T8DLBs8o7eqimxtAohpHyoHvDCTFnmfP22ABy7Pym9+I5dJxK+ak3U1rd/N7QvZarXZugzAXkLXWZHE9rCJ2vyVKXzMhquon7cISScGYL1DgoMHizac4vBU7m85CmvI3K1fiixS6J6jMeDnSD2M3vhGFjLJjDn0uGVPvlVYsMoDCjSRAB8fW0AdqEU3VCj/j1GLCahtZ7uvItf4au1mMPxd0JPk6Lmreehg8N6OM+iOS8YGt4Fc/u2+/Ifg554TJu/GkU/37SeABLfTwbhniJKT+VQaheMqQVLtTluPW6vYAwZD51So4TlLjr7+KdkFUcPgejUBg8pmt74NaR+oyskmhGz/0Fh1XfFuyqWSiSrEV8H31jrRDFeS0/HxL5CQQWxCzjBaoBbOgYewNbpHDSuDeEo9fqHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(396003)(376002)(66946007)(8936002)(66556008)(478600001)(6486002)(2906002)(1076003)(36756003)(5660300002)(83380400001)(186003)(16526019)(66476007)(316002)(86362001)(6666004)(52116002)(38100700002)(8676002)(26005)(4326008)(38350700002)(6916009)(2616005)(44832011)(7696005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CxkE+bVebwM3Vu7Z7vzAszxgq+9fWHogGmshp05Hiw0nzUleDispzVd5d1A3?=
 =?us-ascii?Q?KicdCDvdixLOoxHXeWl/0FM3IDMXmZaShLxFBCwhzc2ooPNzjVM4z0rbGrnI?=
 =?us-ascii?Q?hEqgdyMDs7O28NLq8G5wxQFK0TJqYJBvIyFqjqSxbWqBbMS02OYdgIjZ70js?=
 =?us-ascii?Q?5o7eXut4RYpvbHZ/S4ZIBYldXmwDb3Gk0dfLLrZHkAUqTA/LyMXFEVxcUdQ1?=
 =?us-ascii?Q?b55JM41jiOSPnp1mFktkwv+f5ooVDfocgchaFyIKUWZD+2LdhTJ1QR+GSPsu?=
 =?us-ascii?Q?tPf/CfwIikoNXJtEFknrrrfYfHblqBotDuvHh/TOlbDdabPxcIQOkc++p4l5?=
 =?us-ascii?Q?1umm8wbNPC2jWJ2DjzaAm4o5B93HUHoOi4xNvcBRSuReBgEdbyMfF97yImeS?=
 =?us-ascii?Q?m6HDxSjS8WNaC4zOR2X0Bvawy1GhzXKO+IAeW0bdIVMRzmBhgsioHVIdExkF?=
 =?us-ascii?Q?y1CcjhdssysP5lbdBNli4cw9YZ9H+4VWeY3avVwbxgsYfRz81NjZjqhDqqiJ?=
 =?us-ascii?Q?OOO01lRvkzY+cR/GkPDcuwemnQfsjAwrIU4+KP6jKlYGOOGpSTyHdcXeQcPF?=
 =?us-ascii?Q?jxf9FgT/Ws6YhDQ6rk1ZhaxZTzU5OmcMyrwf6X/B0hQ/JSQiW1Y4NfCHQfra?=
 =?us-ascii?Q?ynj4GPXa4elRdUMG25j/SzCdzm++LGNDboVjwTU7sNrqxccTDwxGUQDnQgpg?=
 =?us-ascii?Q?ZiSUFfXBLiSTB07+PE5jM7Fsq+Q5FSyvv0chC5TNEqdUptvhdYXLbFkEXnRP?=
 =?us-ascii?Q?21eV3rYy1eOStPAP8NMSlPCoTioF95is1LNOCLTqW3oTdC/Ugyie+4mOYChu?=
 =?us-ascii?Q?vt+1piX+QBAVrOpCLhbaSvlx0DeXoA0eq/vLpFFQdd/BVW2X16CaPfQogu+S?=
 =?us-ascii?Q?u8HOphVGSd3KmxJkbkMLLR1HDSpmJqHlHl8bdTRg6q0KOCF9CKjtumF4dptb?=
 =?us-ascii?Q?4c3uBWOflWp9tSbocMT1vJ5GfO8tNbtUvJrOoM6C5lQEndjy9uSqgyXgw7YT?=
 =?us-ascii?Q?i/3SUWbYLAa+CG0p+Boy0DeoiFeeTKQUFjQKczJYbfR4Zej6d4Mj8jqWjqzS?=
 =?us-ascii?Q?CUb690+kRfFL5yaY4zFo+m2cFolaE3ucH5sevZ9/N6hDbfylH94D/Wu/WVHw?=
 =?us-ascii?Q?DoBOttZswmE31kHj1Pkn333sJ/BLZlrFQo43LDsqUOkbwjs32bf7jTzQaloI?=
 =?us-ascii?Q?kJzPPznT0ULoTIslg04vX9QSC8aUEJF0aP/bJGWhexthT++aFLYqHw90dC9l?=
 =?us-ascii?Q?xs8lFUdUtJXabIwQYXps9gdDl+wyn2VQwwfCZ2fGAG8BYHgd8OBJ1oRQBZ9o?=
 =?us-ascii?Q?S88FkmHX6vO9EM7NkCAzOyxn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ab18957-70f2-441e-a896-08d914eed847
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 02:37:11.5511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ItByUtnHszcqDynPqTbYWlNpiqM/jCuhX0//sKrina7LhbRvK+Xgz1uN3d9AsbR3djQ23NTaAw361ntio4K4kr0tHfxY8rE4NEpEmjz8hUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4425
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120018
X-Proofpoint-GUID: AQ7doeTnY4gdNViQQ8m7Uhss2P90yM6B
X-Proofpoint-ORIG-GUID: AQ7doeTnY4gdNViQQ8m7Uhss2P90yM6B
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120018
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move 'nested_run' counter to enter_guest_mode() because,
    i) This counter is common to both Intel and AMD and can be incremented
       from a common place,
    ii) guest mode is a more finer-grained state than the beginning of
	nested_svm_vmrun() and nested_vmx_run().

Also, rename it to 'nested_runs'.

Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/kvm_cache_regs.h   | 1 +
 arch/x86/kvm/svm/nested.c       | 2 --
 arch/x86/kvm/vmx/nested.c       | 2 --
 arch/x86/kvm/x86.c              | 2 +-
 5 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..cf8557b2b90f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1170,7 +1170,7 @@ struct kvm_vcpu_stat {
 	u64 req_event;
 	u64 halt_poll_success_ns;
 	u64 halt_poll_fail_ns;
-	u64 nested_run;
+	u64 nested_runs;
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
 };
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 3db5c42c9ecd..cf52cbff18d3 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -162,6 +162,7 @@ static inline u64 kvm_read_edx_eax(struct kvm_vcpu *vcpu)
 static inline void enter_guest_mode(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hflags |= HF_GUEST_MASK;
+	++vcpu->stat.nested_runs;
 }
 
 static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5e8d8443154e..34fc74b0d58a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -596,8 +596,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	struct kvm_host_map map;
 	u64 vmcb12_gpa;
 
-	++vcpu->stat.nested_run;
-
 	if (is_smm(vcpu)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6058a65a6ede..94f70c0af4a4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3454,8 +3454,6 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	u32 interrupt_shadow = vmx_get_interrupt_shadow(vcpu);
 	enum nested_evmptrld_status evmptrld_status;
 
-	++vcpu->stat.nested_run;
-
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5bd550eaf683..6d1f51f6c344 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -243,7 +243,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("l1d_flush", l1d_flush),
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
-	VCPU_STAT("nested_run", nested_run),
+	VCPU_STAT("nested_runs", nested_runs),
 	VCPU_STAT("directed_yield_attempted", directed_yield_attempted),
 	VCPU_STAT("directed_yield_successful", directed_yield_successful),
 	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
-- 
2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83F432F639
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 23:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhCEW7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 17:59:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38982 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhCEW7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 17:59:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 125MsTL7009080;
        Fri, 5 Mar 2021 22:57:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=eG552gS+s8mTRpTUGVTwlYXu063UV1k981zm7veNB24=;
 b=a3Y+TSFvvA6elxXvwsLDbrapuFc4r2cjsfYk837yVGCHqr40sM/Tmcs75gZwro62u1dX
 bDkh0dG/P1TbGWpLE7D5qOq6Wgp4a2kDCRkK+lA6A/OmqxpmzpxH4tfsuQbderojvE9n
 p49ry4GVpG8oXb2PeZlmOcJWgx2Q55B6dkk2lzobMTX/rZaN3J7ZqGfB7kAa0o/AcnqV
 m8Co/R8euwhfv70P2tIJ6GYtB4LgTUMw5QqHURX8DVkVG2BOdLdwF/7bJ6g9/BKAa2Fy
 3OtKTsOTuzsMpyyJqnnn2GQiKhHWJcjcrLech0bSXBPczk1tbKgLENenK7JI2lWNIG2n Tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3726v7hhf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Mar 2021 22:57:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 125MpF0Z025660;
        Fri, 5 Mar 2021 22:57:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by aserp3020.oracle.com with ESMTP id 370004jau1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Mar 2021 22:57:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWGrTWEgGXmGTixtXiVDRJdphn51pLHqJqP/P7g2INAiN74SaiLVX8Vz4XfJF16Sj5F1LUhINudvNJ3566N37mpjTYh8Lbt8eVcbf7AHkYRE6QwLnTHXT25iTCTuJpStjlTaO5pj8p1U8uRQpzL4NB69CK9SjWRXCdg/YEaxpsMSmbIWQXYCre4Pqx4bRHZ7AlZAQUFlW9wkGecBIOJl+b6RHhfSKIWnoH01sA/YcD538qk8hv9JJrEf0GPUyAAXp/9k3mogm9R+664C1KOkQPd2VXZX+LfsLzayViDdDN2u28PSVf4YyN4KbFuHUPhkgZU6tuGnhy/pFGFfHQJgkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eG552gS+s8mTRpTUGVTwlYXu063UV1k981zm7veNB24=;
 b=UvfxMDJsOj5n+QzSdJE7LzybOLmzSV93H5mPJb1o1v5xF0ZLq9GODclFrORX3tlALdzeqMoX/XIP2aeKmTFTjMre5t57lEJ12GoHRojiEk0SjzcnwSuqBAg6ttI6RxvZ7X37UZC4iU2yX8oikfFao1So0KWBfxttQaA4MBVePVmzTcnquZiv6kZfI/oejwQW4bXs1ZEkYns+e8viZEvXcTqePa3Zo/sNSzGCcOkt/RhyetUQeEwqzFCg1TUtbchD5kMI7zpnK8NNGqnPJUFXZ8yxiKfI7UTDi7t2HIy+EhnnfHI8Z/LMkjFGivVbnpDBFezliorP4f6+u9dEiMIG/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eG552gS+s8mTRpTUGVTwlYXu063UV1k981zm7veNB24=;
 b=WxWPMmFOewYwj6E+Xgq21ZFqb492ZrOYD+3Wwedwvt1SBYIP8O+HXHQ0gNN1LtMl5IO9+emfZksNrSQaXsLTlVim2pCVOzFASZ4JATdWsUDZKyc0RiLsuH2J32OAU6QYOGQ9tZCLy/uI9dHtbKmutYMyqWeJdI++Vad3H9FBHNw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BYAPR10MB2742.namprd10.prod.outlook.com (2603:10b6:a02:b0::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Fri, 5 Mar
 2021 22:57:49 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::b52e:bdd3:d193:4d14]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::b52e:bdd3:d193:4d14%7]) with mapi id 15.20.3846.041; Fri, 5 Mar 2021
 22:57:49 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     x86@kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, joe.jin@oracle.com
Subject: [PATCH 1/1] KVM: x86: to track if L1 is running L2 VM
Date:   Fri,  5 Mar 2021 14:57:47 -0800
Message-Id: <20210305225747.7682-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [138.3.200.16]
X-ClientProxiedBy: SN4PR0701CA0024.namprd07.prod.outlook.com
 (2603:10b6:803:28::34) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (138.3.200.16) by SN4PR0701CA0024.namprd07.prod.outlook.com (2603:10b6:803:28::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 5 Mar 2021 22:57:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 894606b0-6729-4317-9436-08d8e02a1945
X-MS-TrafficTypeDiagnostic: BYAPR10MB2742:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB274264D9DEB10303CCE5C0C0F0969@BYAPR10MB2742.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E7CncNV9t2TppYZJZZrroOZhXQg/CNO6Tj78frrvPGKvLuYXd8LI7mGWWuk4nWO/hA4IAxvzcEDFRKeGI+ajv9PWvJrDTxPmpA7nHMuk84oBF73Ffqh2tjcK6PNxaA+bsXh6TDFZ/Nk9FfDEVukZ7l+NEcVJ3reWk8dwhpmCLHL4tn349WrobQuBRIml0s8y6ehwAJhaanmXMt2Zo7GMKrsG695MHWm9+mIyAu2ljpxLmwmejCJmNHNMot6RitMq5+6jUodoJnUL9oRD0fNE1nq3PPFKWVrWBNyEk2iO4wvWb9HSeya/8QgvNYB7wEYIYxbHOQyBXV5a3nbj+JL/oPQNERev9dNn35bYeo8ZpratRJOavXbSnoq2iXGpHfWcbbwIRxWisvFxe6Hoce/ktkLrPMSq2ocOz92v26NwqWjwtZKTqxm5kdLRp0oCm/8r0vIl6PNg/J3qL4LD0L1c8YmZ/TmDO5g34lM2f+ZdAI249U+4jz8eztrQAZDwvcgzbQzZ4//HmqQSlWSetiDZjYPxHo+UqO4RV9pU01ULMwv6x9E/wE58ra8ykTcWMkYGFN83qVkUGlUrxt6++yuwqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(346002)(136003)(39860400002)(52116002)(956004)(69590400012)(1076003)(16526019)(186003)(8936002)(36756003)(44832011)(4326008)(2616005)(26005)(2906002)(6512007)(6486002)(66946007)(478600001)(107886003)(7416002)(66476007)(66556008)(83380400001)(316002)(6506007)(5660300002)(86362001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?39158CwicCRpdgUKM89az58mFfU/nkHBI1yncdxAd725vgqqnyZcbx855nZb?=
 =?us-ascii?Q?j1d5/7EuiYYIwCE6xQ0Z2LihVIgl6GEf0sgpQkKJ5FrfBpO2nz48wxuE9vr6?=
 =?us-ascii?Q?YHS88E5BhCWrqbF6/OFFeTf5gH5MKsIITL881KZkGLKFDa+FbFhhwwRoJLMD?=
 =?us-ascii?Q?Q4XkiV72hMd7p1xjx+EbS5j/ndOq0SS7wWQp6umd4QMOVNPLeOMrh3osuFXF?=
 =?us-ascii?Q?8/FU3T+/nRSpZhy4moMVbEF+sGaCFVuMGfmvztokJnP/Gv1BSzkeRC5JntQY?=
 =?us-ascii?Q?td4xkII/6DHUOGad9qWapv+/2B1uGzOnytmya6tY16T0YOhq0W5mYdqBveMA?=
 =?us-ascii?Q?j6U2RuvVXHDzCbttOdlg9LUAU7ccwcz+B8oIBEHrhBVs8aNWq8yoplSCt7U/?=
 =?us-ascii?Q?uoozgz8vYVIDnuJdPxBd+m7XR+4rGgSH1VHqbkj3mWKfAPhS16w4LV19Zchx?=
 =?us-ascii?Q?gn5zgH5Ca2lNFVxPlxz74/d7qvApqVnNIhPqmt1PBF4Ejb93saamZLOFIHbp?=
 =?us-ascii?Q?ronsDIA7bvdKwLvjcLaE9w4yTyjUIpOzXYM9AlUsMCgq2ctFo4olJ0vt5QX4?=
 =?us-ascii?Q?I8kqfTv+MubkwQphkypAd3QuOh+DdhOT8FpnYWkU2nNNcqhM1kwRpssNej6n?=
 =?us-ascii?Q?vY7mEmL5OzHXYUGJCMaiFHPWb6pyxd81KH3DcBQMQ9LXn+0nAyUkL2afAkyL?=
 =?us-ascii?Q?+8gzstg5MdjtnnFgf2MAIA53hboOizODQrtyiOfv3Jan3d3YM/aMwcEXmvC/?=
 =?us-ascii?Q?hr36JFV9tao+ZPkba7cw4xYQpMfy0AwAWlS5fXdFGZxrcjzO7KQUlWgVDsaZ?=
 =?us-ascii?Q?oeuoVK3VJi5likqOUtX758lTrJZiYPz3aVECOB/LcdpbN+G0BvFk30C050RJ?=
 =?us-ascii?Q?xeNyIDtsQKt+P8hIt9BQPoECHtKFN7FiTcBJY6Hx9/bOyAiyu2BtxrLhXtPY?=
 =?us-ascii?Q?VoB6krNyPpup1jRo7/CUwdQ9pKEbnEaBZiHGpNh+k7pnumB0ojzadlnB1Ddz?=
 =?us-ascii?Q?jtv2KIVuyHs35qhnxkf8BlhCm+H2jsoxnIeAHlc17gSEI5BHqSygB3ajM3r2?=
 =?us-ascii?Q?UmQtu984Jw1XLtFsT4YOqdqPpGki6uCHLQy7FHfgO4Uxcz5qQMpyLOdDQz6y?=
 =?us-ascii?Q?5ws7kNVaJWCM5aZDaParc+OxCWQ1D2NTzTDuoRAFpNPio63hKTdoQE7sh/Bp?=
 =?us-ascii?Q?p1Tv+kPA5Q3iQWhFLOiT7vK0wcCCMJUIc2Au+ud5j6uri7wwdPjMpxQG/e3b?=
 =?us-ascii?Q?0a++DEiR95w2NXSN9gGlCS5Mx9WOfLJ5awdf4MKZCZxx9j0jGcIItRbTR7nY?=
 =?us-ascii?Q?RY6Hjlh6IdMqfubq3Qr39GBB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 894606b0-6729-4317-9436-08d8e02a1945
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 22:57:49.1782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lu/BGNv15W91dPugzB4miA43bbqQ4WF2Tv5maNov1/koXevhkwejudhMsJHu1Nb8Lp7RswK4odCq8xWqLxLivA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2742
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9914 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103050117
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9914 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103050117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new per-cpu stat 'nested_run' is introduced in order to track if L1 VM
is running or used to run L2 VM.

An example of the usage of 'nested_run' is to help the host administrator
to easily track if any L1 VM is used to run L2 VM. Suppose there is issue
that may happen with nested virtualization, the administrator will be able
to easily narrow down and confirm if the issue is due to nested
virtualization via 'nested_run'. For example, whether the fix like
commit 88dddc11a8d6 ("KVM: nVMX: do not use dangling shadow VMCS after
guest reset") is required.

Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/nested.c       | 2 ++
 arch/x86/kvm/vmx/nested.c       | 2 ++
 arch/x86/kvm/x86.c              | 1 +
 4 files changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 877a4025d8da..7669215426ac 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1125,6 +1125,7 @@ struct kvm_vcpu_stat {
 	u64 req_event;
 	u64 halt_poll_success_ns;
 	u64 halt_poll_fail_ns;
+	u64 nested_run;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 35891d9a1099..18c02e958a09 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -494,6 +494,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	struct kvm_host_map map;
 	u64 vmcb12_gpa;
 
+	++svm->vcpu.stat.nested_run;
+
 	if (is_smm(&svm->vcpu)) {
 		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 		return 1;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bcca0b80e0d0..bd1343a0896e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3453,6 +3453,8 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	u32 interrupt_shadow = vmx_get_interrupt_shadow(vcpu);
 	enum nested_evmptrld_status evmptrld_status;
 
+	++vcpu->stat.nested_run;
+
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2a20ce60152e..f296febb0485 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -245,6 +245,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("l1d_flush", l1d_flush),
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
+	VCPU_STAT("nested_run", nested_run),
 	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
 	VM_STAT("mmu_pte_write", mmu_pte_write),
 	VM_STAT("mmu_pde_zapped", mmu_pde_zapped),
-- 
2.17.1


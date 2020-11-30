Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7032C92AD
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 00:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388881AbgK3XeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 18:34:06 -0500
Received: from mail-bn7nam10on2065.outbound.protection.outlook.com ([40.107.92.65]:9217
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388814AbgK3XeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 18:34:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bc063egESTz8I+5xq6PkMnm7/Uj0FH6/RSBYTv8fdOIAYkBo6tnYFnLKaXqCaJptocJrRXKhYAum/glse92HwNhS8TddmuKX6myyvVxSYOdvDUv7pN4OqO2FBj3wForrP0CCfTHoGX3pAA6oQMGEDciQQK7ekYAliPf8b7bxgtFg3TKCr+TiyCmuLgfgmsbmSjQiGXMJ+QyvamRURs440lJxlDk8KePOx7R8KokqF5DM56nR9F8fMbLwYX7CG6Y6x2nJDGg1WTlTh7j2LK40oK70mIU9PUT+8d0KahMTv8sm5ww2ymUbyO2ONBgNbBw9XQdif6e/i7BFsLIvPESriA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vszFLMoX/s17wRHoUePPotaCNXNSWa1oBMPFC2/BB9o=;
 b=mHebipH7ek7J+IJgeqrFT1dmW7Vt+P3+FKNYBgSSioogRpBJMH25KoEjcOl9YBi0eWMdpaFGbD8N1YGSv+hBZSoLfjDqYeJfEsiv07yok+Fof7DVoezz7nIT5RdyTIs2/pNvvwpqjgWTQVnvRJ9X32Ghd4P20e2Luz7KAeHAVv6FPd+mvxGV0lDyhavVnOUz05Vd96o0+pMTrswfCzPyeYgFFvb+sPLq/fmoiS3S15f+5rNGsh3xvEdfPdQiDIF8n6tQyOfwR6c/E1JVzdSfrh6QB0ltdQdecoEpd8FaHBjuFZlTJmra7dV8WJtVi8SdRUc3nMPWfeLVUEc+7oBB5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vszFLMoX/s17wRHoUePPotaCNXNSWa1oBMPFC2/BB9o=;
 b=FQaK/B5tq5aRLlk10MFFWr6BVyCgHOcrhInl1aeCnkh3ZQOUR6d3wAZ969ZoRjUuX9XIQ1thcJeI/dRWYxytuLcIneaIkR47bgWe1KgE68BAisBtfoqxZo6pW9N2MCzIfF81FiZG0sflhv/i0KJkLo3Ch1+EXBm3uE0feoziTTI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 23:33:09 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 23:33:09 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH 5/9] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
Date:   Mon, 30 Nov 2020 23:32:59 +0000
Message-Id: <8495534821c6270bd7013085243d8224b91e1e81.1606633738.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606633738.git.ashish.kalra@amd.com>
References: <cover.1606633738.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0053.namprd05.prod.outlook.com
 (2603:10b6:803:41::30) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0053.namprd05.prod.outlook.com (2603:10b6:803:41::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.6 via Frontend Transport; Mon, 30 Nov 2020 23:33:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a40377b-ee4b-4fb9-23c8-08d895884b9b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45093A5D966311AE36EDA61F8EF50@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +sPhFTb89QMYCPBnMz+eqQKTV35NFkIpoTrEt17B2rVSXUeod54K2ulbi2DY0b7aiKqnzC8nSyg0X5FR7nkqTVuD5GV97A2sb8wd8aKz6FigrThoW4rGwWfSRYUmB9oQAlqxJqqBSEW11mFrl8ZGE4xKHqFhL/PKZKZ844wTrbSOOnTXzQm5zTbegqu4UsiIcYLKj/BmIu3bZO+5o3gcug3VcUXmDpDx7jFThT0NSDyWXA/aKcUVKeC1vf/vZw9K7qMO79PFYHmeM6p/tJbse/ljSDZCyQEYFZTxR4m+Nvc5Bw0IBq1NAEJSbOcrDA1Ms4RulGPwXD5YgOWxgGBLfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(26005)(83380400001)(956004)(5660300002)(16526019)(7416002)(4326008)(86362001)(2616005)(186003)(316002)(7696005)(6916009)(2906002)(8936002)(6486002)(52116002)(8676002)(66946007)(478600001)(6666004)(66476007)(66556008)(66574015)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ftO8bvNRzjFUJ5rQIRGlJZwOHO7but112xOuq4LCjlaqI2t/f8U+GfoIlkUYXq2wB6goj3oO4AEvUs6aXQaW8DqLSLdHLsgk7Zw8pXZT7Bw8JdWdccH+3mTNLWAgaeOHrUUi1dwN0rDtU1eK1eNCazCv6XKBh5AOKDGXaB0FJB3KMh2C3R1uHY8Pg+5ohJhdteKCTDwDuk62Vi/M4O8Qtc7/XRs4aGECJ4hFNDJcFhyxJnks9lAt1NzGPrZ3J6XopCO2xhZI2pKtqNN7zRZss/7C304WFXfP3jBE1667B5oz44IpN3L7YLHssCkGsSx4cGxPRntxcsTQYXr1nZs800XxSMh/HKTdUuxSN4yPU0GMZT8qe7112LIYtLNM23BqMsslvxh3Jl/CYVbEorEhrPfkQ1Uvo4fX8T1rGv3U0bQE/5K6LLKiTNjA9COrceNNngVXz6MpDboTVrmsoz0rqAxGyFEtR07FS8RxQa+YTEl9zJfKj3QtzGPxxW80HREHN2NA3Wrck5jUZEYpyU0OrPAo3W/reaP6+D3WbsUl4AKPgOnrubTHtPSVdqpZq/Q22G52OrdS0eBAKz5MqzwfjlMeKyZ+naCv/JWAJunlNkPI3Ilp5f0/AUuIzNMFEqsv6MARQHU0WDrTvhUttT5dLxT/NvUbwQnnsSh8Y1xQ2+HZ4SzRfTjAiKxE8gspM2rOd6ZviQNIiiPJ9upX+GtkNKoCiG/3YObhOvL7ETGhQVEsnuDSOgtHsfpvCSSzcmQI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a40377b-ee4b-4fb9-23c8-08d895884b9b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 23:33:09.1283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QY+iLLf8oDmEAv9un9PKny72HzGuTvagcZnuL0ks/SpWdPFTs+XlXGhzLZ7+jufd8MiW+Y1oW4j7S9jHpxiQrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The ioctl can be used to set page encryption bitmap for an
incoming guest.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/api.rst  | 44 +++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/sev.c          | 50 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 12 ++++++++
 include/uapi/linux/kvm.h        |  1 +
 7 files changed, 111 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ae410f4332ab..1a3336cbbfe8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4698,6 +4698,28 @@ or shared. The bitmap can be used during the guest migration. If the page
 is private then the userspace need to use SEV migration commands to transmit
 the page.
 
+4.126 KVM_SET_PAGE_ENC_BITMAP (vm ioctl)
+---------------------------------------
+
+:Capability: basic
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_page_enc_bitmap (in/out)
+:Returns: 0 on success, -1 on error
+
+/* for KVM_SET_PAGE_ENC_BITMAP */
+struct kvm_page_enc_bitmap {
+	__u64 start_gfn;
+	__u64 num_pages;
+	union {
+		void __user *enc_bitmap; /* one bit per page */
+		__u64 padding2;
+	};
+};
+
+During the guest live migration the outgoing guest exports its page encryption
+bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
+bitmap for an incoming guest.
 
 4.125 KVM_S390_PV_COMMAND
 -------------------------
@@ -4852,6 +4874,28 @@ into user space.
 If a vCPU is in running state while this ioctl is invoked, the vCPU may
 experience inconsistent filtering behavior on MSR accesses.
 
+4.126 KVM_SET_PAGE_ENC_BITMAP (vm ioctl)
+---------------------------------------
+
+:Capability: basic
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_page_enc_bitmap (in/out)
+:Returns: 0 on success, -1 on error
+
+/* for KVM_SET_PAGE_ENC_BITMAP */
+struct kvm_page_enc_bitmap {
+	__u64 start_gfn;
+	__u64 num_pages;
+	union {
+		void __user *enc_bitmap; /* one bit per page */
+		__u64 padding2;
+	};
+};
+
+During the guest live migration the outgoing guest exports its page encryption
+bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
+bitmap for an incoming guest.
 
 5. The kvm_run structure
 ========================
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8c2e40199ecb..352ebc576036 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1286,6 +1286,8 @@ struct kvm_x86_ops {
 				  unsigned long sz, unsigned long mode);
 	int (*get_page_enc_bitmap)(struct kvm *kvm,
 				struct kvm_page_enc_bitmap *bmap);
+	int (*set_page_enc_bitmap)(struct kvm *kvm,
+				struct kvm_page_enc_bitmap *bmap);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7869fca983f5..9fe9fba34e68 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1084,6 +1084,56 @@ int svm_get_page_enc_bitmap(struct kvm *kvm,
 	return ret;
 }
 
+int svm_set_page_enc_bitmap(struct kvm *kvm,
+				   struct kvm_page_enc_bitmap *bmap)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	unsigned long gfn_start, gfn_end;
+	unsigned long *bitmap;
+	unsigned long sz;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+	/* special case of resetting the complete bitmap */
+	if (!bmap->enc_bitmap) {
+		mutex_lock(&kvm->lock);
+		/* by default all pages are marked encrypted */
+		if (sev->page_enc_bmap_size)
+			bitmap_fill(sev->page_enc_bmap,
+				    sev->page_enc_bmap_size);
+		mutex_unlock(&kvm->lock);
+		return 0;
+	}
+
+	gfn_start = bmap->start_gfn;
+	gfn_end = gfn_start + bmap->num_pages;
+
+	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / 8;
+	bitmap = kmalloc(sz, GFP_KERNEL);
+	if (!bitmap)
+		return -ENOMEM;
+
+	ret = -EFAULT;
+	if (copy_from_user(bitmap, bmap->enc_bitmap, sz))
+		goto out;
+
+	mutex_lock(&kvm->lock);
+	ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
+	if (ret)
+		goto unlock;
+
+	bitmap_copy(sev->page_enc_bmap + BIT_WORD(gfn_start), bitmap,
+		    (gfn_end - gfn_start));
+
+	ret = 0;
+unlock:
+	mutex_unlock(&kvm->lock);
+out:
+	kfree(bitmap);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bff89cab3ed0..6ebdf20773ea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4315,6 +4315,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.page_enc_status_hc = svm_page_enc_status_hc,
 	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
+	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4ce73f1034b9..2268c0ab650b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -414,6 +414,7 @@ void sync_nested_vmcb_control(struct vcpu_svm *svm);
 int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
                            unsigned long npages, unsigned long enc);
 int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
+int svm_set_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3cb95a4dd55..3cf64a94004f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5707,6 +5707,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			r = kvm_x86_ops.get_page_enc_bitmap(kvm, &bitmap);
 		break;
 	}
+	case KVM_SET_PAGE_ENC_BITMAP: {
+		struct kvm_page_enc_bitmap bitmap;
+
+		r = -EFAULT;
+		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
+			goto out;
+
+		r = -ENOTTY;
+		if (kvm_x86_ops.set_page_enc_bitmap)
+			r = kvm_x86_ops.set_page_enc_bitmap(kvm, &bitmap);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d0b9171bdb03..8e1adcd598a8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1574,6 +1574,7 @@ struct kvm_pv_cmd {
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
 #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
+#define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc7, struct kvm_page_enc_bitmap)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.17.1


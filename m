Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCBE2C929B
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 00:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388728AbgK3XdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 18:33:19 -0500
Received: from mail-bn7nam10on2065.outbound.protection.outlook.com ([40.107.92.65]:9217
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388510AbgK3XdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 18:33:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjF3vK5RYhSrIP2ypQK1L7JvX01W3UT2Ppgyj7JxkKHNGritWe+GJ9+hWW8z8MndRTBEzFGp4zerd/l6/+R6LFT4RuqN4DC9kx82ws81DQAXZZS4BtGRYrUsrial6cBiULsqeqBRDTWaMn5G2z7AFAchPWSECgN1L3e0T3PKK8HsnYkeCZtVh8fcAN7RWabH1MYKY42t1a+XU3cjTzlrrNJXMZWFKwfPEQvVYT2Mqj3dglCvR8xxS5I6hUQ4lwY0Zu66SSDlekXVSBDL9HlUIbTASgGoSTXiqPAEGdz/kqMnLSSzExPYXzVKVkGxJjTviMSmJP3JkbgOsS/wY/ifuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UXhCfDxTgEvBE5vtdMRkbTkXKFCt0VRwT/duu9C8kI=;
 b=Ivwx7DsOPQjZko5sflW2isFZsoLctak/hfOOF4BoObKPxqLY8y1JgyZKg5cRIlSnxzV+p8qd2OVuCs1DFGGymZnjZqpqvmvNWXRgOBujlfDInIlj1p3F4XeMYyebdxsLCXblfdxqC7hyTPHoG0t+NuXNuEsYkmF5CctNE6tHr97rDk7NUvJ7698gpPs2OBYTZjYHD7b8nuSycUWLrt+nY8rW+ZhKFz/RkgXm+5/0YaX0daek0IhRS5zmZlZNF5xJqN9vkUpDfFobx4LhlVAK51lJ4RGbtNY91svvTOvhqdFBRK4dsTKWQ/L9JevV3/P2SF4FrEcjILX4Gq6iJTBw4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UXhCfDxTgEvBE5vtdMRkbTkXKFCt0VRwT/duu9C8kI=;
 b=vOBFMjjr+r9oQkqAz5bYgPs2K1Imn5z81fAjc0ahbuOMbBQJ0HT8j6JaMapRrEmjGbOj7XnQ4+XKwVYOK7l2K3UPKqhXWcO7tIZdS5NSWYS4bJrLWC2pCu+FHFHQkw42xp6zPgEc74WY3c52Bs0TwuSA45yxcFHoooFSFOmgUYQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 23:32:34 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 23:32:34 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH 3/9] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
Date:   Mon, 30 Nov 2020 23:32:24 +0000
Message-Id: <4770cb6f815a3061d6c6073ed22aa13ef43db783.1606633738.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606633738.git.ashish.kalra@amd.com>
References: <cover.1606633738.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:805:de::27) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR05CA0014.namprd05.prod.outlook.com (2603:10b6:805:de::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.16 via Frontend Transport; Mon, 30 Nov 2020 23:32:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ca8145b7-cf57-4ed4-facc-08d895883688
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45097D474EBF7A81AE24A8CE8EF50@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CRaUwN8ZpSMLYdaCNofowE0pTiGEf+gYIW6NqC57YThDBzbG5hvMTRavQ03Bt/1Sy9juKtyhXfYiP33uhOnsiwVhK4M0MCbBvFvPJeKsHx8oEpp4hjAkw8ufLydjatCixVIQ4TLwZYMculbhmGrCTncFsEtbSPmmr7h6QCW33qRNAIxFVi7VktftLBJrRLVWnWJYhNSkIj6tNH6e1tuVdg23I99RP+QPPnyT0O+OSJwS4cx9C4I+ZSmXWQdTNWxiEhDImvmDFn9tON9iItM3RA9+r/ZSzTMhdzE+CvRaX51/D0Tn+uY8ykyQlECkG7CRmHYe/NTKKOt5o+R1qFtXeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(26005)(83380400001)(956004)(5660300002)(16526019)(7416002)(4326008)(86362001)(2616005)(186003)(316002)(7696005)(6916009)(2906002)(8936002)(6486002)(52116002)(8676002)(66946007)(478600001)(6666004)(66476007)(66556008)(66574015)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DeGe668Ed+oYHTu/nIxg6icmem4x9itcY/bi79epo2FONU14LVO5173M+9ky+OIaEiGgMrSufwY107K9XfArQypgNgKcry2nP9XjbIJD/gScL3UdUc814w8sFiUgr+wR+MUMU6f60Mvn7J2XUkKqjROoCHBCASkDqg/VYz5+cGvgpGe9Y2XIv8GaMw7zk5GKxSSG5MtLWftNWpdszpKvvhVFqETF//UTR2OfV1HmNnh55aIkS/ST/OASGhtayx63cLbmraBff86AdpKT4r3TceINH5A49xBKFc+idXF4eH5OjkWw1OUyFpwQjNlLo1cMBt8bv8SqSZuuQNpWoV2bPEdIKKq3hft5GDx5vbg+qfxk3sRbNKEMwC7jOMV+fn243hitbK2cp0P3r6IU+2AoAm3X5fbiTI1wNTph1yYs5uA1pqdNPxiujvXfDSdDUbx0PijPRw6/7UBeLTpQMZnIX8oXbGrcghAWfsR60GeOjWKoE2IDzLKJdMwJMKeg+JUF6kw7V0v3X6VjWaAt99Wj53tofH22sXWyH2ot0OYODYeLp6in31HNSaH4WqXhKSSk6fOODFVW+dxGZAB/tsqhuk1KoBoiqdpRWowqBhaUApE8dGZ1kSv1F/fBHu9+fEEI8DGEapuIqPjqqXphIFyXqem/ptO1rtx7biKDZUK9owfN9mT6UfLh1+u/7BsokBk5ayTCFXuF6CJbaGsKU+tZN2c6tvd/xB1zqxVnWATGPkp/LCILzlKMARXT1RIFwpfx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca8145b7-cf57-4ed4-facc-08d895883688
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 23:32:33.8181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rzMLLx6F5NCXccLJr5LBGBDr1+8zGz+cWsPdOA3Fyr2dT8fTa6QHFlRYokFqBbBHp9zGgYl9hjg1IUaGPej9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The ioctl can be used to retrieve page encryption bitmap for a given
gfn range.

Return the correct bitmap as per the number of pages being requested
by the user. Ensure that we only copy bmap->num_pages bytes in the
userspace buffer, if bmap->num_pages is not byte aligned we read
the trailing bits from the userspace and copy those bits as is.

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
 Documentation/virt/kvm/api.rst  | 27 +++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/svm/sev.c          | 70 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 12 ++++++
 include/uapi/linux/kvm.h        | 12 ++++++
 7 files changed, 125 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 70254eaa5229..ae410f4332ab 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4671,6 +4671,33 @@ This ioctl resets VCPU registers and control structures according to
 the clear cpu reset definition in the POP. However, the cpu is not put
 into ESA mode. This reset is a superset of the initial reset.
 
+4.125 KVM_GET_PAGE_ENC_BITMAP (vm ioctl)
+---------------------------------------
+
+:Capability: basic
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_page_enc_bitmap (in/out)
+:Returns: 0 on success, -1 on error
+
+/* for KVM_GET_PAGE_ENC_BITMAP */
+struct kvm_page_enc_bitmap {
+	__u64 start_gfn;
+	__u64 num_pages;
+	union {
+		void __user *enc_bitmap; /* one bit per page */
+		__u64 padding2;
+	};
+};
+
+The encrypted VMs have the concept of private and shared pages. The private
+pages are encrypted with the guest-specific key, while the shared pages may
+be encrypted with the hypervisor key. The KVM_GET_PAGE_ENC_BITMAP can
+be used to get the bitmap indicating whether the guest page is private
+or shared. The bitmap can be used during the guest migration. If the page
+is private then the userspace need to use SEV migration commands to transmit
+the page.
+
 
 4.125 KVM_S390_PV_COMMAND
 -------------------------
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d035dc983a7a..8c2e40199ecb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1284,6 +1284,8 @@ struct kvm_x86_ops {
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
 	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
 				  unsigned long sz, unsigned long mode);
+	int (*get_page_enc_bitmap)(struct kvm *kvm,
+				struct kvm_page_enc_bitmap *bmap);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3e56d00aa1c6..7869fca983f5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1014,6 +1014,76 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 	return 0;
 }
 
+int svm_get_page_enc_bitmap(struct kvm *kvm,
+				   struct kvm_page_enc_bitmap *bmap)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	unsigned long gfn_start, gfn_end;
+	unsigned long sz, i, sz_bytes;
+	unsigned long *bitmap;
+	int ret, n;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	gfn_start = bmap->start_gfn;
+	gfn_end = gfn_start + bmap->num_pages;
+
+	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / BITS_PER_BYTE;
+	bitmap = kmalloc(sz, GFP_KERNEL);
+	if (!bitmap)
+		return -ENOMEM;
+
+	/* by default all pages are marked encrypted */
+	memset(bitmap, 0xff, sz);
+
+	mutex_lock(&kvm->lock);
+	if (sev->page_enc_bmap) {
+		i = gfn_start;
+		for_each_clear_bit_from(i, sev->page_enc_bmap,
+				      min(sev->page_enc_bmap_size, gfn_end))
+			clear_bit(i - gfn_start, bitmap);
+	}
+	mutex_unlock(&kvm->lock);
+
+	ret = -EFAULT;
+
+	n = bmap->num_pages % BITS_PER_BYTE;
+	sz_bytes = ALIGN(bmap->num_pages, BITS_PER_BYTE) / BITS_PER_BYTE;
+
+	/*
+	 * Return the correct bitmap as per the number of pages being
+	 * requested by the user. Ensure that we only copy bmap->num_pages
+	 * bytes in the userspace buffer, if bmap->num_pages is not byte
+	 * aligned we read the trailing bits from the userspace and copy
+	 * those bits as is.
+	 */
+
+	if (n) {
+		unsigned char *bitmap_kernel = (unsigned char *)bitmap;
+		unsigned char bitmap_user;
+		unsigned long offset, mask;
+
+		offset = bmap->num_pages / BITS_PER_BYTE;
+		if (copy_from_user(&bitmap_user, bmap->enc_bitmap + offset,
+				sizeof(unsigned char)))
+			goto out;
+
+		mask = GENMASK(n - 1, 0);
+		bitmap_user &= ~mask;
+		bitmap_kernel[offset] &= mask;
+		bitmap_kernel[offset] |= bitmap_user;
+	}
+
+	if (copy_to_user(bmap->enc_bitmap, bitmap, sz_bytes))
+		goto out;
+
+	ret = 0;
+out:
+	kfree(bitmap);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7122ea5f7c47..bff89cab3ed0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4314,6 +4314,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.msr_filter_changed = svm_msr_filter_changed,
 
 	.page_enc_status_hc = svm_page_enc_status_hc,
+	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0103a23ca174..4ce73f1034b9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -413,6 +413,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm);
 void sync_nested_vmcb_control(struct vcpu_svm *svm);
 int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
                            unsigned long npages, unsigned long enc);
+int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3afc78f18f69..d3cb95a4dd55 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5695,6 +5695,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_X86_SET_MSR_FILTER:
 		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
 		break;
+	case KVM_GET_PAGE_ENC_BITMAP: {
+		struct kvm_page_enc_bitmap bitmap;
+
+		r = -EFAULT;
+		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
+			goto out;
+
+		r = -ENOTTY;
+		if (kvm_x86_ops.get_page_enc_bitmap)
+			r = kvm_x86_ops.get_page_enc_bitmap(kvm, &bitmap);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 886802b8ffba..d0b9171bdb03 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -532,6 +532,16 @@ struct kvm_dirty_log {
 	};
 };
 
+/* for KVM_GET_PAGE_ENC_BITMAP */
+struct kvm_page_enc_bitmap {
+	__u64 start_gfn;
+	__u64 num_pages;
+	union {
+		void __user *enc_bitmap; /* one bit per page */
+		__u64 padding2;
+	};
+};
+
 /* for KVM_CLEAR_DIRTY_LOG */
 struct kvm_clear_dirty_log {
 	__u32 slot;
@@ -1563,6 +1573,8 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
+#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.17.1


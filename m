Return-Path: <kvm+bounces-65969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D925CBE508
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:36:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6F3613005D1B
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 14:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C74E3101A5;
	Mon, 15 Dec 2025 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="VeDhvBv1";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b="xTaYQRaE"
X-Original-To: kvm@vger.kernel.org
Received: from mail187-17.suw11.mandrillapp.com (mail187-17.suw11.mandrillapp.com [198.2.187.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B001D86DC
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.2.187.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765808899; cv=none; b=R+I60dx3YVz0/MlCgSZRgtS1wKXxx2E+yD16FKXAY5NHu/a4+wXsEXSV16UR84hKEciQVCYw44kDopUDBbMwHfHuJWKnVOSpYVWAPrlAeVgPk4Ep5ltKUG/Fv750Z/DqF4+viIcrxCOPi80MyE+YSGp0bpSztlTGhRCw8SeaQKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765808899; c=relaxed/simple;
	bh=Xsq5EDj6JfdjBo56zuK3UD6TH0S3xwNLkauF1xvaPg8=;
	h=From:Subject:To:Cc:Message-Id:Date:MIME-Version:Content-Type; b=lX5EBoovwhClmwC4e/VM5CdKW7XJx4GSIofSX14U2xEC5SuSKvB3Yv+Tknlosl3uNpZZ2hIH9SdbihdJFyVyZdWT5aB7UAKaLmtT0NLhRvlDvDiCmY4Q2uLn30x7le0rcvSfwaMWPZzvgjOQ/zcfSOzokpz9RbP2z0HpVZKvyBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=VeDhvBv1; dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b=xTaYQRaE; arc=none smtp.client-ip=198.2.187.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1765807779; x=1766077779;
	bh=Y0vmCttgVu2ttB7leVpGoBwWuJAwz/ma4WmOx09m+TY=;
	h=From:Subject:To:Cc:Message-Id:Feedback-ID:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:CC:Date:Subject:From;
	b=VeDhvBv1RWLjxW+lbg9UziBjuqsqllbt+QZT5qOD7zTPsw3TBbSAHpt87i+sFcDoX
	 oxOENU7LlgL8ABsXClNLY3KW7nqejnmQpsSilyDALY7KeqlVY3G1P5YO36/4VVhT0q
	 3QQswN+KuvW8dlhELOM8HF7LXiVP3vdfl8r4Xn9rTxtlYwXe6KrMO0nVgNHBSqIPEy
	 dNYvAMtgXHE1Ouc5KGRyIaaihV4k/m9CMVyMNKaxOUEterSQlcTzR0DyzbGqMfWQ+t
	 Jhu7EUKDTjswpMDLOg9TQyBV45AX+yXz7hjqP5/726SHMr+U+tJRLi6GpSnAsnOa6G
	 17jv3IuS9wO/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1765807779; x=1766068279; i=thomas.courrege@vates.tech;
	bh=Y0vmCttgVu2ttB7leVpGoBwWuJAwz/ma4WmOx09m+TY=;
	h=From:Subject:To:Cc:Message-Id:Feedback-ID:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:CC:Date:Subject:From;
	b=xTaYQRaE/MdQqjohVaAIgzF5xhzPqbzisvRL7RwQoo45AX3d1uBQ1FoRvXSMBFAAV
	 zBftRCzH2ngpDdlSfRpokKfDmc5dp9BKZWei0g8MrX175Na5FlKfquAG55pnDoYelq
	 1RYDCIT0uPpGI+fdrhV55eqpeWsOdawcu/ftw61fT80bnTfXbgH6Ujl1CXj8LA6Qdh
	 59XLZRKUzDZsHL2THtDpQwkzmubSwzSaGx+TRnIhVp2HaeBBO+p5p97S4JJ1mAmhTR
	 KdvxX99mb+/G/gkU5hK+RXa/lB79kHQEtmvfeZzk07svr8nIY7i0t0+CllkPH8hCsb
	 19Gj/Qxh0UrEA==
Received: from pmta09.mandrill.prod.suw01.rsglab.com (localhost [127.0.0.1])
	by mail187-17.suw11.mandrillapp.com (Mailchimp) with ESMTP id 4dVMPv57K7zRKLwhT
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 14:09:39 +0000 (GMT)
From: "Thomas Courrege" <thomas.courrege@vates.tech>
Subject: =?utf-8?Q?[PATCH=20v3]=20KVM:=20SEV:=20Add=20KVM=5FSEV=5FSNP=5FHV=5FREPORT=5FREQ=20command?=
Received: from [37.26.189.201] by mandrillapp.com id 8061437208dd475ab147eaac3fa407af; Mon, 15 Dec 2025 14:09:39 +0000
X-Mailer: git-send-email 2.52.0
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1765807777356
To: ashish.kalra@amd.com, corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com, nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com, thomas.lendacky@amd.com
Cc: thomas.courrege@vates.tech, kvm@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Message-Id: <20251215140926.2820110-1-thomas.courrege@vates.tech>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.8061437208dd475ab147eaac3fa407af?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20251215:md
Date: Mon, 15 Dec 2025 14:09:39 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Add support for retrieving the SEV-SNP attestation report via the
SNP_HV_REPORT_REQ firmware command and expose it through a new KVM
ioctl for SNP guests.

Signed-off-by: Thomas Courrege <thomas.courrege@vates.tech>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 27 ++++++++
 arch/x86/include/uapi/asm/kvm.h               |  9 +++
 arch/x86/kvm/svm/sev.c                        | 61 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 31 ++++++++++
 5 files changed, 129 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1ddb6a86ce7f..083ed487764e 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -572,6 +572,33 @@ Returns: 0 on success, -negative on error
 See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
 details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
 
+21. KVM_SEV_SNP_HV_REPORT_REQ
+-----------------------------
+
+The KVM_SEV_SNP_HV_REPORT_REQ command requests the hypervisor-generated
+SNP attestation report. This report is produced by the PSP using the
+HV-SIGNED key selected by the caller.
+
+The ``key_sel`` field indicates which key the platform will use to sign the
+report:
+  * ``0``: If VLEK is installed, sign with VLEK. Otherwise, sign with VCEK.
+  * ``1``: Sign with VCEK.
+  * ``2``: Sign with VLEK.
+  * Other values are reserved.
+
+Parameters (in): struct kvm_sev_snp_hv_report_req
+
+Returns:  0 on success, -negative on error
+
+::
+        struct kvm_sev_snp_hv_report_req {
+                __u64 report_uaddr;
+                __u64 report_len;
+                __u8 key_sel;
+                __u8 pad0[7];
+                __u64 pad1[4];
+        };
+
 Device attribute API
 ====================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7ceff6583652..464146bed784 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -743,6 +743,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_LAUNCH_START = 100,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
 	KVM_SEV_SNP_LAUNCH_FINISH,
+	KVM_SEV_SNP_HV_REPORT_REQ,
 
 	KVM_SEV_NR_MAX,
 };
@@ -871,6 +872,14 @@ struct kvm_sev_receive_update_data {
 	__u32 pad2;
 };
 
+struct kvm_sev_snp_hv_report_req {
+	__u64 report_uaddr;
+	__u64 report_len;
+	__u8 key_sel;
+	__u8 pad0[7];
+	__u64 pad1[4];
+};
+
 struct kvm_sev_snp_launch_start {
 	__u64 policy;
 	__u8 gosvw[16];
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..da8d0e13d4ac 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2261,6 +2261,64 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+static int sev_snp_hv_report_request(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct sev_data_snp_msg_report_rsp *report_rsp = NULL;
+	struct sev_data_snp_hv_report_req data;
+	struct kvm_sev_snp_hv_report_req params;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+	void __user *u_report;
+	void __user *u_params = u64_to_user_ptr(argp->data);
+	size_t rsp_size = sizeof(*report_rsp);
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+	if (copy_from_user(&params, u_params, sizeof(params)))
+		return -EFAULT;
+	printk("params.report_len: %llu\n", params.report_len);
+
+	if (params.report_len < rsp_size)
+		return -ENOSPC;
+
+	u_report = u64_to_user_ptr(params.report_uaddr);
+	if (!u_report)
+		return -EINVAL;
+
+	report_rsp = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!report_rsp)
+		return -ENOMEM;
+
+	data.len = sizeof(data);
+	data.key_sel = params.key_sel;
+	data.gctx_addr = __psp_pa(sev->snp_context);
+	data.hv_report_paddr = __psp_pa(report_rsp);
+
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_HV_REPORT_REQ, &data,
+				&argp->error);
+	if (ret)
+		goto e_free_rsp;
+
+	if (!report_rsp->status)
+	rsp_size += report_rsp->report_size;
+
+	if (params.report_len < rsp_size) {
+		rsp_size = sizeof(*report_rsp);
+		ret = -ENOSPC;
+	}
+
+	if (copy_to_user(u_report, report_rsp, rsp_size))
+		ret = -EFAULT;
+
+	params.report_len = sizeof(*report_rsp) + report_rsp->report_size;
+	if (copy_to_user(u_params, &params, sizeof(params)))
+		ret = -EFAULT;
+
+e_free_rsp:
+	snp_free_firmware_page(report_rsp);
+	return ret;
+}
+
 struct sev_gmem_populate_args {
 	__u8 type;
 	int sev_fd;
@@ -2672,6 +2730,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_FINISH:
 		r = snp_launch_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_HV_REPORT_REQ:
+		r = sev_snp_hv_report_request(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 956ea609d0cc..5dd7c3f0d50d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -259,6 +259,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
 	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
 	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
+	case SEV_CMD_SNP_HV_REPORT_REQ:		return sizeof(struct sev_data_snp_hv_report_req);
 	default:				return sev_tio_cmd_buffer_len(cmd);
 	}
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 69ffa4b4d1fa..c651a400d124 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -124,6 +124,7 @@ enum sev_cmd {
 	SEV_CMD_SNP_GCTX_CREATE		= 0x093,
 	SEV_CMD_SNP_GUEST_REQUEST	= 0x094,
 	SEV_CMD_SNP_ACTIVATE_EX		= 0x095,
+	SEV_CMD_SNP_HV_REPORT_REQ	= 0x096,
 	SEV_CMD_SNP_LAUNCH_START	= 0x0A0,
 	SEV_CMD_SNP_LAUNCH_UPDATE	= 0x0A1,
 	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
@@ -594,6 +595,36 @@ struct sev_data_attestation_report {
 	u32 len;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_data_snp_hv_report_req - SNP_HV_REPORT_REQ command params
+ *
+ * @len: length of the command buffer in bytes
+ * @key_sel: Selects which key to use for generating the signature.
+ * @gctx_addr: System physical address of guest context page
+ * @hv_report_paddr: System physical address where MSG_EXPORT_RSP will be written
+ */
+struct sev_data_snp_hv_report_req {
+	u32 len;		/* In */
+	u32 key_sel	:2,	/* In */
+	    rsvd	:30;
+	u64 gctx_addr;		/* In */
+	u64 hv_report_paddr;	/* In */
+} __packed;
+
+/**
+ * struct sev_data_snp_msg_export_rsp
+ *
+ * @status: Status : 0h: Success. 16h: Invalid parameters.
+ * @report_size: Size in bytes of the attestation report
+ * @report: attestation report
+ */
+struct sev_data_snp_msg_report_rsp {
+	u32 status;			/* Out */
+	u32 report_size;		/* Out */
+	u8 rsvd[24];
+	u8 report[];
+} __packed;
+
 /**
  * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE command params
  *
-- 
2.52.0


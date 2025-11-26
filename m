Return-Path: <kvm+bounces-64712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DD871C8B87D
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:11:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3CA924E0306
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94FC33F8B3;
	Wed, 26 Nov 2025 19:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="uee4PgNP";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b="FptX7StJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail136-9.atl41.mandrillapp.com (mail136-9.atl41.mandrillapp.com [198.2.136.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19763126BC
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 19:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.2.136.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764184291; cv=none; b=DTiRfaRmvZv9koGyw+DPdspJ4VAa0M9CORMXdDrdeHqiBNaGYyk89LAvnuMWBoWA3pAKnWn3ATHXDJnexdXFhTvDmh9YTzRFc8BkxxZNiBfuK4fBTHdNccPFRCl0KvZ5AhpNaLF8QWg7A+PvUFWAjUTpFK6hBBZoviqZeTNtD0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764184291; c=relaxed/simple;
	bh=nKeewWW3P5B4SMtRZCew3v4YB5Dt7pUrcKq0obyJyJ8=;
	h=From:Subject:To:Cc:Message-Id:Date:MIME-Version:Content-Type; b=KRuJH+SPP7y6RWYzp8X1+SllcrLEIXMYzOyMdKqcSkHnSxaQp8HzDww0SyssZKu9zenn/uG9sSYg4T0H+QkB4dTZB3TE5QFGgV8QB1SxX6kfvb818PZqGa73qeDK/2vfk6XYPvuyVCrJ6KkdhRFboBnKeAbO00+60bnYicgkyVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=uee4PgNP; dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b=FptX7StJ; arc=none smtp.client-ip=198.2.136.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1764184288; x=1764454288;
	bh=/MREF0EwtVtv19KMTRgY9BsLCx0psIVUg7lgQIree34=;
	h=From:Subject:To:Cc:Message-Id:Feedback-ID:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:CC:Date:Subject:From;
	b=uee4PgNPHaMJtzORRAnfLfcnUn/tlpjDl4BvSOAx/kpAbTQ4L28Pv4nTtjZDE/Rtu
	 QIeoy4RyGLJWHtxLYXvS5iABwAFVMvdAJ2nMm2VBv0QxHflUVNsqjQHkjzdpEZZJe8
	 s9G1+Hp+QrDEw1kijC3eMbNARKjXdZE7jIsHAWzDvOq+gCELtIYy96z/TIugXJuJJR
	 E/qIRDB1BhgTe5cj0RmrN2dsbzO6EEnFIfpTluJpMUPvE2V5B0Tl2duUd5Qn1AeL/Q
	 WdYDhy3r5qI7/bC97Vglpdp2DgBn+UkdAk9ar8CVqAO1LlKjVSbThWWHdNPkIhRHLS
	 bv3j6EQpm1Xrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1764184288; x=1764444788; i=thomas.courrege@vates.tech;
	bh=/MREF0EwtVtv19KMTRgY9BsLCx0psIVUg7lgQIree34=;
	h=From:Subject:To:Cc:Message-Id:Feedback-ID:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:CC:Date:Subject:From;
	b=FptX7StJn2LTfiSVNTFjzkz284ncKESxdCddNcDJou3+5ucokHj5nJySl0bi1YSiU
	 dwQBvcrOmv1bPVs4LFyAJ1KcIzRwKweSZfj4qEVPHcmh9cdlngg0eIBH4ARcWtz+O2
	 eq320kUQ/NIcANYFtguUfBhutpAVpPAGP6CKtszVFvH7KoSTAH+qFV9vfPCq4QDPxH
	 d/IG97SmXaqGfcIzoWLLRrwYC3FVwjwNnYFFCTMX4fa9DeBLY20vqY/BIZxCMrCfU1
	 m+Xndl9f1kkKiHsNmjJtE0IdYJ1NszeH3Kn3ZDOLZJ6EJp3CsWMSAcuq4q+5UUiGkc
	 o9EJbkcNyAGBQ==
Received: from pmta11.mandrill.prod.atl01.rsglab.com (localhost [127.0.0.1])
	by mail136-9.atl41.mandrillapp.com (Mailchimp) with ESMTP id 4dGq0w6lWCzHXZ3Wm
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 19:11:28 +0000 (GMT)
From: "Thomas Courrege" <thomas.courrege@vates.tech>
Subject: =?utf-8?Q?[PATCH]=20KVM:=20SEV:=20Add=20hypervisor=20report=20request=20for=20SNP=20guests?=
Received: from [37.26.189.201] by mandrillapp.com id b41289ca78d149fc8974a9746bc313ff; Wed, 26 Nov 2025 19:11:28 +0000
X-Mailer: git-send-email 2.52.0
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1764184286986
To: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au
Cc: thomas.courrege@vates.tech, x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Message-Id: <20251126191114.874779-1-thomas.courrege@vates.tech>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.b41289ca78d149fc8974a9746bc313ff?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20251126:md
Date: Wed, 26 Nov 2025 19:11:28 +0000
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
 .../virt/kvm/x86/amd-memory-encryption.rst    | 18 ++++++
 arch/x86/include/uapi/asm/kvm.h               |  7 +++
 arch/x86/kvm/svm/sev.c                        | 60 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 28 +++++++++
 5 files changed, 114 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1ddb6a86ce7f..f473e9304634 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -572,6 +572,24 @@ Returns: 0 on success, -negative on error
 See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
 details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
 
+21. KVM_SEV_SNP_GET_HV_REPORT
+-----------------------------
+
+The KVM_SEV_SNP_GET_HV_REPORT command requests the hypervisor-generated
+SNP attestation report. This report is produced by the PSP using the
+HV-SIGNED key selected by the caller.
+
+Parameters (in): struct kvm_sev_snp_hv_report_req
+
+Returns:  0 on success, -negative on error
+
+::
+        struct kvm_sev_snp_hv_report_req {
+                __u8 key_sel;
+                __u64 report_uaddr;
+                __u64 report_len;
+        };
+
 Device attribute API
 ====================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d420c9c066d4..ff034668cac4 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -742,6 +742,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_LAUNCH_START = 100,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
 	KVM_SEV_SNP_LAUNCH_FINISH,
+	KVM_SEV_SNP_HV_REPORT_REQ,
 
 	KVM_SEV_NR_MAX,
 };
@@ -870,6 +871,12 @@ struct kvm_sev_receive_update_data {
 	__u32 pad2;
 };
 
+struct kvm_sev_snp_hv_report_req {
+	__u8 key_sel;
+	__u64 report_uaddr;
+	__u64 report_len;
+};
+
 struct kvm_sev_snp_launch_start {
 	__u64 policy;
 	__u8 gosvw[16];
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0835c664fbfd..4ab572d970a4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2253,6 +2253,63 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+static int sev_snp_report_request(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+	struct sev_data_snp_hv_report_req data;
+	struct kvm_sev_snp_hv_report_req params;
+	void __user *u_report;
+	void __user *u_params = u64_to_user_ptr(argp->data);
+	struct sev_data_snp_msg_report_rsp *report_rsp = NULL;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, u_params, sizeof(params)))
+		return -EFAULT;
+
+	/* A report uses 1184 bytes */
+	if (params.report_len < 1184)
+		return -ENOSPC;
+
+	memset(&data, 0, sizeof(data));
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
+	data.hv_report_paddr = __psp_pa(report_rsp);
+	data.key_sel = params.key_sel;
+
+	data.gctx_addr = __psp_pa(sev->snp_context);
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_HV_REPORT_REQ, &data,
+			    &argp->error);
+
+	if (ret)
+		goto e_free_rsp;
+
+	params.report_len = report_rsp->report_size;
+	if (copy_to_user(u_params, &params, sizeof(params)))
+		ret = -EFAULT;
+
+	if (params.report_len < report_rsp->report_size) {
+		ret = -ENOSPC;
+		/* report is located right after rsp */
+	} else if (copy_to_user(u_report, report_rsp + 1, report_rsp->report_size)) {
+		ret = -EFAULT;
+	}
+
+e_free_rsp:
+	snp_free_firmware_page(report_rsp);
+	return ret;
+}
+
 struct sev_gmem_populate_args {
 	__u8 type;
 	int sev_fd;
@@ -2664,6 +2721,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_FINISH:
 		r = snp_launch_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_HV_REPORT_REQ:
+		r = sev_snp_report_request(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 0d13d47c164b..5236d5ee19ac 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -251,6 +251,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
 	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
 	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
+	case SEV_CMD_SNP_HV_REPORT_REQ:		return sizeof(struct sev_data_snp_hv_report_req);
 	default:				return 0;
 	}
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index e0dbcb4b4fd9..c382edc8713a 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -91,6 +91,7 @@ enum sev_cmd {
 	SEV_CMD_SNP_GCTX_CREATE		= 0x093,
 	SEV_CMD_SNP_GUEST_REQUEST	= 0x094,
 	SEV_CMD_SNP_ACTIVATE_EX		= 0x095,
+	SEV_CMD_SNP_HV_REPORT_REQ	= 0x096,
 	SEV_CMD_SNP_LAUNCH_START	= 0x0A0,
 	SEV_CMD_SNP_LAUNCH_UPDATE	= 0x0A1,
 	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
@@ -554,6 +555,33 @@ struct sev_data_attestation_report {
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
+	u32 key_sel:2;		/* In */
+	u32 rsvd:30;
+	u64 gctx_addr;		/* In */
+	u64 hv_report_paddr;	/* In */
+} __packed;
+/**
+ * struct sev_data_snp_msg_export_rsp
+ *
+ * @status: Status : 0h: Success. 16h: Invalid parameters.
+ * @report_size: Size in bytes of the attestation report
+ */
+struct sev_data_snp_msg_report_rsp {
+	u32 status;			/* Out */
+	u32 report_size;		/* Out */
+	u8 rsvd[24];
+} __packed;
+
 /**
  * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE command params
  *
-- 
2.52.0


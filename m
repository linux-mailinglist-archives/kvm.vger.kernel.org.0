Return-Path: <kvm+bounces-65009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB20C9804D
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 16:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63EA43A3519
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 15:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 557E6328617;
	Mon,  1 Dec 2025 15:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="WzZy7JhE";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b="NEiSECSq"
X-Original-To: kvm@vger.kernel.org
Received: from mail132-20.atl131.mandrillapp.com (mail132-20.atl131.mandrillapp.com [198.2.132.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA4C3242C8
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 15:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.2.132.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764602408; cv=none; b=Jkn8T07Qs1aMZ7ML8kpjCxOjm4pgZCh4waqRVRXGwse7/LrySK3abhmsKRd5zAMGkQ4svlvCqOPj3FS3vN92XL+/YxhtetZjprMjPrZz3lyUw6LvvmG037S4wPxQgzdSFHDF3s7N8jVNKIK20Xem0DHp/vK1Z8GZw1j4Jw8+5kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764602408; c=relaxed/simple;
	bh=7yvqcvgNr7Df/OcCol2acvZnPK406CxxXI3ldV7wZNA=;
	h=From:Subject:To:Cc:Message-Id:Date:MIME-Version:Content-Type; b=kns+QpMZogvr4+q0b8hnSp8YfPkWHcLzR6fCUI2yxv3c+ng4G/Fjcn8hUKjlpySBpbh7pjeBuxNkP9EGnp+KmWlBf9JoCn1LP4i72iecXfT+mCXB2Sog526IjxgFZHsKv9/yu9gDj/UT3GZkgUy5PpQjEIVwCGDoCg4uu+0LYm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=WzZy7JhE; dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b=NEiSECSq; arc=none smtp.client-ip=198.2.132.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1764602393; x=1764872393;
	bh=HlyIaZmMukCXUcketAQUXKxv3ZBzSqoS/mCFII2RnyU=;
	h=From:Subject:To:Cc:Message-Id:Feedback-ID:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:CC:Date:Subject:From;
	b=WzZy7JhEDOlabFhhlc4t4EV4y5rn6IXerAOc1Mcac8uyoEUA2vWcdqhPJIZqGzJkt
	 b8Lr7oDmysBqJgzsQ5vr85y1Xjis3cj+5d1XxwcSwNhvRUU4imhFbPP/ZXckd5MxjM
	 RNs7A/9P4B/RdB4+KwUYPD06oPuWTKDovMf+dostKGGSfLGVFePT50bmlChXj961v7
	 8IcMAwSXmmp1ddyzOG1pooyuqjS7j33uJ8phyEQl2VS/VG8zMo9KuPJVAnVQu5Zf7A
	 dF+hJwK5S4ZVXXnP1jjARUVrsbOGqRzfWwRwcNI3BKnj3f5641D0jaJD5JDb/P8fq8
	 mFmz0KzvwQJiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1764602393; x=1764862893; i=thomas.courrege@vates.tech;
	bh=HlyIaZmMukCXUcketAQUXKxv3ZBzSqoS/mCFII2RnyU=;
	h=From:Subject:To:Cc:Message-Id:Feedback-ID:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:CC:Date:Subject:From;
	b=NEiSECSqLRSVJe2wSXXCqs2+w78UMndMqyYNwsE1reKkjNE3uYm3+g9O2sc9kODDh
	 VRpmZw8UgNDbemXZ29xZNO83EfefDKKHo8IoWuX8ky099rQCbEofAan9T23kBrq2x/
	 m3mSPJ2672YxrrP7ZytX0YjsvMjCChn5Vc4mz7XjfDRuitXaRnEw3GykqAnXIB3nmj
	 ZOtZHqmvSj89eFqS4mKgnjE5hV3IIaY8S3DbLr9T0sMhtsMLtz/1X+dCS+yP8lmCdF
	 iklwxWZtjLYBoNbZeJpiJAi3yvZYD3Q5dh0er2ecqCTnXF7oELC7M49GzaUc0JC/ny
	 8HWCEDlsJ0Leg==
Received: from pmta09.mandrill.prod.atl01.rsglab.com (localhost [127.0.0.1])
	by mail132-20.atl131.mandrillapp.com (Mailchimp) with ESMTP id 4dKndP2WMfzFCWg1B
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 15:19:53 +0000 (GMT)
From: "Thomas Courrege" <thomas.courrege@vates.tech>
Subject: =?utf-8?Q?[PATCH=20v2]=20KVM:=20SEV:=20Add=20KVM=5FSEV=5FSNP=5FHV=5FREPORT=5FREQ=20command?=
Received: from [37.26.189.201] by mandrillapp.com id 7a1ccb47ab0e43a38062ff9369baf756; Mon, 01 Dec 2025 15:19:53 +0000
X-Mailer: git-send-email 2.52.0
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1764602390868
To: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, nikunj@amd.com
Cc: thomas.courrege@vates.tech, x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Message-Id: <20251201151940.172521-1-thomas.courrege@vates.tech>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.7a1ccb47ab0e43a38062ff9369baf756?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20251201:md
Date: Mon, 01 Dec 2025 15:19:53 +0000
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
 .../virt/kvm/x86/amd-memory-encryption.rst    | 25 ++++++++
 arch/x86/include/uapi/asm/kvm.h               |  7 +++
 arch/x86/kvm/svm/sev.c                        | 61 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 31 ++++++++++
 5 files changed, 125 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1ddb6a86ce7f..b3ee25718938 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -572,6 +572,31 @@ Returns: 0 on success, -negative on error
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
index 0835c664fbfd..62f17f4eab42 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2253,6 +2253,64 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, u_params, sizeof(params)))
+		return -EFAULT;
+
+	if (params.report_len < SEV_SNP_ATTESTATION_REPORT_SIZE)
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
+	} else if (copy_to_user(u_report, report_rsp + 1, report_rsp->report_size)) {
+		/* report is located right after rsp */
+		ret = -EFAULT;
+	}
+
+e_free_rsp:
+	/* contains sensitive data */
+	memzero_explicit(report_rsp, PAGE_SIZE);
+	snp_free_firmware_page(report_rsp);
+	return ret;
+}
+
 struct sev_gmem_populate_args {
 	__u8 type;
 	int sev_fd;
@@ -2664,6 +2722,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
index e0dbcb4b4fd9..0e635feb7671 100644
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
@@ -554,6 +555,36 @@ struct sev_data_attestation_report {
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
+
+#define SEV_SNP_ATTESTATION_REPORT_SIZE 1184
+
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


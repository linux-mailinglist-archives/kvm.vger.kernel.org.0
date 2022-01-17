Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185A6490D0B
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241704AbiAQRAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:00:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35092 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241482AbiAQRAA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 12:00:00 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HGSZSZ019375
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:00:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Yvi04KhZKJGYQHLju03aVpn1GsiPFe6gJudAQU3fLFA=;
 b=j76KN/CC1qsYCfOZjYEkvdhTsTyf+9SUWraph+EZmjfymT7QWVNmEasW1A9Wb6aS3dQU
 UodGCjTETY97M+iZ4CSe3lfqI9dI8pHxU89+saL5ZtQ8rFNHkj+tP8dFS55ywI7/M7Ha
 AxPtxSfrcamnxNrN9Vfhyps+MWVrLwB7MmKh65x0eTjkqDVNyA8gGQFM82Y2tBdt2IYd
 gFKN99i1Mrzqr20GGlOwM7ldnx+UQXYPDwn6q4LA7FEOVeaPRpFH+YyR5l38Yy1raKLU
 NVq8UBbMkRIgbbXlrxsPMW3P1ShBqauzhhqL9/Jm8OFcTtsJbDWXBpA/9jTc48SSJu8G sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnc0u8pp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:59 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HGh4PR003887
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:59 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnc0u8pnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:59 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGlCpl030693;
        Mon, 17 Jan 2022 16:59:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3dknw8x2f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGxs7D24969508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:59:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45D42A405F;
        Mon, 17 Jan 2022 16:59:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EED8BA4054;
        Mon, 17 Jan 2022 16:59:53 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.16])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:59:53 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 09/13] lib: s390x: Introduce snippet helpers
Date:   Mon, 17 Jan 2022 17:59:45 +0100
Message-Id: <20220117165949.75964-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220117165949.75964-1-imbrenda@linux.ibm.com>
References: <20220117165949.75964-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rlsZD-a61qJnz9ylD8AvB6YAEAhpxOrj
X-Proofpoint-ORIG-GUID: Qi-mfr-zNKOpJtw0bEeTcO1QC-bMYUBL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

These helpers reduce code duplication for PV snippet tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/snippet.h | 103 ++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/uv.h      |  21 +++++++++
 2 files changed, 124 insertions(+)

diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
index 6b77a8a9..b17b2a4c 100644
--- a/lib/s390x/snippet.h
+++ b/lib/s390x/snippet.h
@@ -9,6 +9,10 @@
 #ifndef _S390X_SNIPPET_H_
 #define _S390X_SNIPPET_H_
 
+#include <sie.h>
+#include <uv.h>
+#include <asm/uv.h>
+
 /* This macro cuts down the length of the pointers to snippets */
 #define SNIPPET_NAME_START(type, file) \
 	_binary_s390x_snippets_##type##_##file##_gbin_start
@@ -26,6 +30,12 @@
 #define SNIPPET_HDR_LEN(type, file) \
 	((uintptr_t)SNIPPET_HDR_END(type, file) - (uintptr_t)SNIPPET_HDR_START(type, file))
 
+#define SNIPPET_PV_TWEAK0	0x42UL
+#define SNIPPET_PV_TWEAK1	0UL
+#define SNIPPET_OFF_C		0
+#define SNIPPET_OFF_ASM		0x4000
+
+
 /*
  * C snippet instructions start at 0x4000 due to the prefix and the
  * stack being before that. ASM snippets don't strictly need a stack
@@ -38,4 +48,97 @@ static const struct psw snippet_psw = {
 	.mask = PSW_MASK_64,
 	.addr = SNIPPET_ENTRY_ADDR,
 };
+
+/*
+ * Sets up a snippet guest on top of an existing and initialized SIE
+ * vm struct.
+ * Once this function has finished without errors the guest can be started.
+ *
+ * @vm: VM that this function will populated, has to be initialized already
+ * @gbin: Snippet gbin data pointer
+ * @gbin_len: Length of the gbin data
+ * @off: Offset from guest absolute 0x0 where snippet is copied to
+ */
+static inline void snippet_init(struct vm *vm, const char *gbin,
+				uint64_t gbin_len, uint64_t off)
+{
+	uint64_t mso = vm->sblk->mso;
+
+	/* Copy test image to guest memory */
+	memcpy((void *)mso + off, gbin, gbin_len);
+
+	/* Setup guest PSW */
+	vm->sblk->gpsw = snippet_psw;
+
+	/*
+	 * We want to exit on PGM exceptions so we don't need
+	 * exception handlers in the guest.
+	 */
+	vm->sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
+}
+
+/*
+ * Sets up a snippet UV/PV guest on top of an existing and initialized
+ * SIE vm struct.
+ * Once this function has finished without errors the guest can be started.
+ *
+ * @vm: VM that this function will populated, has to be initialized already
+ * @gbin: Snippet gbin data pointer
+ * @hdr: Snippet SE header data pointer
+ * @gbin_len: Length of the gbin data
+ * @hdr_len: Length of the hdr data
+ * @off: Offset from guest absolute 0x0 where snippet is copied to
+ */
+static inline void snippet_pv_init(struct vm *vm, const char *gbin,
+				   const char *hdr, uint64_t gbin_len,
+				   uint64_t hdr_len, uint64_t off)
+{
+	uint64_t tweak[2] = {SNIPPET_PV_TWEAK0, SNIPPET_PV_TWEAK1};
+	uint64_t mso = vm->sblk->mso;
+	int i;
+
+	snippet_init(vm, gbin, gbin_len, off);
+
+	uv_create_guest(vm);
+	uv_set_se_hdr(vm->uv.vm_handle, (void *)hdr, hdr_len);
+
+	/* Unpack works on guest addresses so we only need off */
+	uv_unpack(vm, off, gbin_len, tweak[0]);
+	uv_verify_load(vm);
+
+	/*
+	 * Manually import:
+	 * - lowcore 0x0 - 0x1000 (asm)
+	 * - stack 0x3000 (C)
+	 */
+	for (i = 0; i < 4; i++) {
+		uv_import(vm->uv.vm_handle, mso + PAGE_SIZE * i);
+	}
+}
+
+/* Allocates and sets up a snippet based guest */
+static inline void snippet_setup_guest(struct vm *vm, bool is_pv)
+{
+	u8 *guest;
+
+	/* Allocate 1MB as guest memory */
+	guest = alloc_pages(8);
+	memset(guest, 0, HPAGE_SIZE);
+
+	/* Initialize the vm struct and allocate control blocks */
+	sie_guest_create(vm, (uint64_t)guest, HPAGE_SIZE);
+
+	if (is_pv) {
+		/* FMT4 needs a ESCA */
+		sie_guest_sca_create(vm);
+
+		/*
+		 * Initialize UV and setup the address spaces needed
+		 * to run a PV guest.
+		 */
+		uv_init();
+		uv_setup_asces();
+	}
+}
+
 #endif
diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 6ffe537a..8175d9c6 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -3,6 +3,7 @@
 #define _S390X_UV_H_
 
 #include <sie.h>
+#include <asm/pgtable.h>
 
 bool uv_os_is_guest(void);
 bool uv_os_is_host(void);
@@ -14,4 +15,24 @@ void uv_destroy_guest(struct vm *vm);
 int uv_unpack(struct vm *vm, uint64_t addr, uint64_t len, uint64_t tweak);
 void uv_verify_load(struct vm *vm);
 
+/*
+ * To run PV guests we need to setup a few things:
+ * - A valid primary ASCE that contains the guest memory and has the P bit set.
+ * - A valid home space ASCE for the UV calls that use home space addresses.
+ */
+static inline void uv_setup_asces(void)
+{
+	uint64_t asce;
+
+	/* We need to have a valid primary ASCE to run guests. */
+	setup_vm();
+
+	/* Set P bit in ASCE as it is required for PV guests */
+	asce = stctg(1) | ASCE_P;
+	lctlg(1, asce);
+
+	/* Copy ASCE into home space CR */
+	lctlg(13, asce);
+}
+
 #endif /* UV_H */
-- 
2.31.1


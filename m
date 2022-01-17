Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9708A490D0E
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241305AbiAQRAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:00:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64186 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241477AbiAQQ77 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 11:59:59 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HGkjM4025462
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6RW0aN/NjXb5k/nJ1sqYiCUI/pvsKwTgjj7Sde7sGfE=;
 b=WOYlILyQPo4+Z200XJ8Y3lKvr0fX87pwk3l9n9sHhrJ6sZv+oODl5wBJ9JcKf8sGYSdq
 lV+LvooKP8vjbWMl/s6+q59d88MxaqAg9LhnYwQD4AYvv0ozNf++rS7gJ2WJ/aGjvVqd
 IYeYEEqDFNQSMLCJjfeoxgviPlhiGmpL9jxYVJnKqT1goY6Lj95ZkO4+LLpHYxCpvKdN
 dXjq0+a7cpx0ySG5vNd1IculHqlbytibqwUYbaPBGd6UIaH1f8kGd5SX3X/CJTQqBptF
 9OsYcO/m6YOk3K2mONNuDToeNKsv/kTLfNugQIvec2Bl1Uzb5Qv6PcLPPNZlAmhToD2w 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn7kcqdd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:59 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HGmJmG008273
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:59 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn7kcqdc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:58 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGmoGB000733;
        Mon, 17 Jan 2022 16:59:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3dknw8w7ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGxrYH41877812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:59:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01733A405F;
        Mon, 17 Jan 2022 16:59:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B448BA405C;
        Mon, 17 Jan 2022 16:59:52 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.16])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:59:52 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 06/13] s390x: lib: Extend UV library with PV guest management
Date:   Mon, 17 Jan 2022 17:59:42 +0100
Message-Id: <20220117165949.75964-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220117165949.75964-1-imbrenda@linux.ibm.com>
References: <20220117165949.75964-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8hZzzyNYt0rGeXQCLgMx-pKmdRyRPBIm
X-Proofpoint-GUID: iRqRcmjEJqp3Kwe7QazjLl0TS9rC6fm0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 mlxlogscore=999
 adultscore=0 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Let's extend the UV lib with guest 1 code to be able to manage
protected VMs in the future.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/uv.h |  14 +++++
 lib/s390x/sie.h    |   3 ++
 lib/s390x/uv.h     |   7 +++
 lib/s390x/uv.c     | 128 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 152 insertions(+)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 6e331211..97c90e81 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -355,4 +355,18 @@ static inline int uv_set_se_hdr(uint64_t handle, void *hdr, size_t len)
 	return uv_call(0, (uint64_t)&uvcb);
 }
 
+static inline int uv_unp_page(uint64_t handle, uint64_t gaddr, uint64_t tweak1, uint64_t tweak2)
+{
+	struct uv_cb_unp uvcb = {
+		.header.cmd = UVC_CMD_UNPACK_IMG,
+		.header.len = sizeof(uvcb),
+		.guest_handle = handle,
+		.gaddr = gaddr,
+		.tweak[0] = tweak1,
+		.tweak[1] = tweak2,
+	};
+
+	return uv_call(0, (uint64_t)&uvcb);
+}
+
 #endif
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 1a12faa7..6d209793 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -203,6 +203,9 @@ union {
 struct vm_uv {
 	uint64_t vm_handle;
 	uint64_t vcpu_handle;
+	void *conf_base_stor;
+	void *conf_var_stor;
+	void *cpu_stor;
 };
 
 struct vm_save_regs {
diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 2b23407a..6ffe537a 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -2,9 +2,16 @@
 #ifndef _S390X_UV_H_
 #define _S390X_UV_H_
 
+#include <sie.h>
+
 bool uv_os_is_guest(void);
 bool uv_os_is_host(void);
 bool uv_query_test_call(unsigned int nr);
+void uv_init(void);
 int uv_setup(void);
+void uv_create_guest(struct vm *vm);
+void uv_destroy_guest(struct vm *vm);
+int uv_unpack(struct vm *vm, uint64_t addr, uint64_t len, uint64_t tweak);
+void uv_verify_load(struct vm *vm);
 
 #endif /* UV_H */
diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index c5c69c47..6fe11dff 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -17,11 +17,14 @@
 #include <asm/facility.h>
 #include <asm/uv.h>
 #include <uv.h>
+#include <sie.h>
 
 static struct uv_cb_qui uvcb_qui = {
 	.header.cmd = UVC_CMD_QUI,
 	.header.len = sizeof(uvcb_qui),
 };
+static uint64_t uv_init_mem;
+
 
 bool uv_os_is_guest(void)
 {
@@ -54,3 +57,128 @@ int uv_setup(void)
 	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
 	return 1;
 }
+
+void uv_init(void)
+{
+	struct uv_cb_init uvcb_init = {
+		.header.len = sizeof(uvcb_init),
+		.header.cmd = UVC_CMD_INIT_UV,
+	};
+	static bool initialized;
+	int cc;
+
+	/* Let's not do this twice */
+	assert(!initialized);
+	/* Query is done on initialization but let's check anyway */
+	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
+
+	/* Donated storage needs to be over 2GB aligned to 1MB */
+	uv_init_mem = (uint64_t)memalign_pages_flags(HPAGE_SIZE, uvcb_qui.uv_base_stor_len, AREA_NORMAL);
+	uvcb_init.stor_origin = uv_init_mem;
+	uvcb_init.stor_len = uvcb_qui.uv_base_stor_len;
+
+	cc = uv_call(0, (uint64_t)&uvcb_init);
+	assert(cc == 0);
+	initialized = true;
+}
+
+void uv_create_guest(struct vm *vm)
+{
+	struct uv_cb_cgc uvcb_cgc = {
+		.header.cmd = UVC_CMD_CREATE_SEC_CONF,
+		.header.len = sizeof(uvcb_cgc),
+	};
+	struct uv_cb_csc uvcb_csc = {
+		.header.len = sizeof(uvcb_csc),
+		.header.cmd = UVC_CMD_CREATE_SEC_CPU,
+		.state_origin = (uint64_t)vm->sblk,
+		.num = 0,
+	};
+	unsigned long vsize;
+	int cc;
+
+	uvcb_cgc.guest_stor_origin = vm->sblk->mso;
+	uvcb_cgc.guest_stor_len = vm->sblk->msl;
+
+	/* Config allocation */
+	vsize = uvcb_qui.conf_base_virt_stor_len +
+		((uvcb_cgc.guest_stor_len / HPAGE_SIZE) * uvcb_qui.conf_virt_var_stor_len);
+
+	vm->uv.conf_base_stor = memalign_pages_flags(PAGE_SIZE * 4, uvcb_qui.conf_base_phys_stor_len, 0);
+	/*
+	 * This allocation needs to be below the max guest storage
+	 * address so let's simply put it into the physical memory
+	 */
+	vm->uv.conf_var_stor = memalign_pages_flags(PAGE_SIZE, vsize,0);
+	uvcb_cgc.conf_base_stor_origin = (uint64_t)vm->uv.conf_base_stor;
+	uvcb_cgc.conf_var_stor_origin = (uint64_t)vm->uv.conf_var_stor;
+
+	/* CPU allocation */
+	vm->uv.cpu_stor = memalign_pages_flags(PAGE_SIZE, uvcb_qui.cpu_stor_len, 0);
+	uvcb_csc.stor_origin = (uint64_t)vm->uv.cpu_stor;
+
+	uvcb_cgc.guest_asce = (uint64_t)stctg(1);
+	uvcb_cgc.guest_sca = (uint64_t)vm->sca;
+
+	cc = uv_call(0, (uint64_t)&uvcb_cgc);
+	assert(!cc);
+
+	vm->uv.vm_handle = uvcb_cgc.guest_handle;
+	uvcb_csc.guest_handle = uvcb_cgc.guest_handle;
+	cc = uv_call(0, (uint64_t)&uvcb_csc);
+	vm->uv.vcpu_handle = uvcb_csc.cpu_handle;
+	assert(!cc);
+
+	/*
+	 * Convert guest to format 4:
+	 *
+	 *  - Set format 4
+	 *  - Write UV handles into sblk
+	 *  - Allocate and set SIDA
+	 */
+	vm->sblk->sdf = 2;
+	vm->sblk->sidad = (uint64_t)alloc_page();
+	vm->sblk->pv_handle_cpu = uvcb_csc.cpu_handle;
+	vm->sblk->pv_handle_config = uvcb_cgc.guest_handle;
+}
+
+void uv_destroy_guest(struct vm *vm)
+{
+	int cc;
+	u16 rc, rrc;
+
+	cc = uv_cmd_nodata(vm->sblk->pv_handle_cpu,
+			   UVC_CMD_DESTROY_SEC_CPU, &rc, &rrc);
+	assert(cc == 0);
+	free_page((void *)vm->sblk->sidad);
+	free_pages(vm->uv.cpu_stor);
+
+	cc = uv_cmd_nodata(vm->sblk->pv_handle_config,
+			   UVC_CMD_DESTROY_SEC_CONF, &rc, &rrc);
+	assert(cc == 0);
+	free_pages(vm->uv.conf_base_stor);
+	free_pages(vm->uv.conf_var_stor);
+}
+
+int uv_unpack(struct vm *vm, uint64_t addr, uint64_t len, uint64_t tweak)
+{
+	int i, cc;
+
+	for (i = 0; i < len / PAGE_SIZE; i++) {
+		cc = uv_unp_page(vm->uv.vm_handle, addr, tweak, i * PAGE_SIZE);
+		assert(!cc);
+		addr += PAGE_SIZE;
+	}
+	return cc;
+}
+
+void uv_verify_load(struct vm *vm)
+{
+	uint16_t rc, rrc;
+	int cc;
+
+	cc = uv_cmd_nodata(vm->uv.vm_handle, UVC_CMD_VERIFY_IMG, &rc, &rrc);
+	assert(!cc);
+	cc = uv_set_cpu_state(vm->uv.vcpu_handle, PV_CPU_STATE_OPR_LOAD);
+	assert(!cc);
+}
-- 
2.31.1


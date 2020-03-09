Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9C617DBAC
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgCIIwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:52:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29764 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726677AbgCIIwA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:52:00 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0298pqN7075248
        for <kvm@vger.kernel.org>; Mon, 9 Mar 2020 04:51:59 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8c8wnx6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 04:51:56 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 9 Mar 2020 08:51:32 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 08:51:29 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0298oS6b48890162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 08:50:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1ADB11C050;
        Mon,  9 Mar 2020 08:51:27 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D778B11C058;
        Mon,  9 Mar 2020 08:51:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  9 Mar 2020 08:51:27 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 95D9AE0251; Mon,  9 Mar 2020 09:51:27 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ulrich Weigand <uweigand@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL 02/36] s390/protvirt: add ultravisor initialization
Date:   Mon,  9 Mar 2020 09:50:52 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309085126.3334302-1-borntraeger@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030908-0008-0000-0000-0000035AA7DB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030908-0009-0000-0000-00004A7BE6E1
Message-Id: <20200309085126.3334302-3-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 suspectscore=2
 impostorscore=0 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

Before being able to host protected virtual machines, donate some of
the memory to the ultravisor. Besides that the ultravisor might impose
addressing limitations for memory used to back protected VM storage. Treat
that limit as protected virtualization host's virtual memory limit.

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/uv.h | 15 ++++++++++++
 arch/s390/kernel/setup.c   |  5 ++++
 arch/s390/kernel/uv.c      | 48 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index c6a330740e5d..1af6ce8023cc 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -23,12 +23,14 @@
 #define UVC_RC_NO_RESUME	0x0007
 
 #define UVC_CMD_QUI			0x0001
+#define UVC_CMD_INIT_UV			0x000f
 #define UVC_CMD_SET_SHARED_ACCESS	0x1000
 #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
 
 /* Bits in installed uv calls */
 enum uv_cmds_inst {
 	BIT_UVC_CMD_QUI = 0,
+	BIT_UVC_CMD_INIT_UV = 1,
 	BIT_UVC_CMD_SET_SHARED_ACCESS = 8,
 	BIT_UVC_CMD_REMOVE_SHARED_ACCESS = 9,
 };
@@ -59,6 +61,14 @@ struct uv_cb_qui {
 	u8  reserveda0[200 - 160];
 } __packed __aligned(8);
 
+struct uv_cb_init {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 stor_origin;
+	u64 stor_len;
+	u64 reserved28[4];
+} __packed __aligned(8);
+
 struct uv_cb_share {
 	struct uv_cb_header header;
 	u64 reserved08[3];
@@ -160,8 +170,13 @@ static inline int is_prot_virt_host(void)
 {
 	return prot_virt_host;
 }
+
+void setup_uv(void);
+void adjust_to_uv_max(unsigned long *vmax);
 #else
 #define is_prot_virt_host() 0
+static inline void setup_uv(void) {}
+static inline void adjust_to_uv_max(unsigned long *vmax) {}
 #endif
 
 #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) || IS_ENABLED(CONFIG_KVM)
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index a2496382175e..1423090a2259 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -560,6 +560,9 @@ static void __init setup_memory_end(void)
 			vmax = _REGION1_SIZE; /* 4-level kernel page table */
 	}
 
+	if (is_prot_virt_host())
+		adjust_to_uv_max(&vmax);
+
 	/* module area is at the end of the kernel address space. */
 	MODULES_END = vmax;
 	MODULES_VADDR = MODULES_END - MODULES_LEN;
@@ -1134,6 +1137,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	memblock_trim_memory(1UL << (MAX_ORDER - 1 + PAGE_SHIFT));
 
+	if (is_prot_virt_host())
+		setup_uv();
 	setup_memory_end();
 	setup_memory();
 	dma_contiguous_reserve(memory_end);
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index b1f936710360..1ddc42154ef6 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -49,4 +49,52 @@ static int __init prot_virt_setup(char *val)
 	return rc;
 }
 early_param("prot_virt", prot_virt_setup);
+
+static int __init uv_init(unsigned long stor_base, unsigned long stor_len)
+{
+	struct uv_cb_init uvcb = {
+		.header.cmd = UVC_CMD_INIT_UV,
+		.header.len = sizeof(uvcb),
+		.stor_origin = stor_base,
+		.stor_len = stor_len,
+	};
+
+	if (uv_call(0, (uint64_t)&uvcb)) {
+		pr_err("Ultravisor init failed with rc: 0x%x rrc: 0%x\n",
+		       uvcb.header.rc, uvcb.header.rrc);
+		return -1;
+	}
+	return 0;
+}
+
+void __init setup_uv(void)
+{
+	unsigned long uv_stor_base;
+
+	uv_stor_base = (unsigned long)memblock_alloc_try_nid(
+		uv_info.uv_base_stor_len, SZ_1M, SZ_2G,
+		MEMBLOCK_ALLOC_ACCESSIBLE, NUMA_NO_NODE);
+	if (!uv_stor_base) {
+		pr_warn("Failed to reserve %lu bytes for ultravisor base storage\n",
+			uv_info.uv_base_stor_len);
+		goto fail;
+	}
+
+	if (uv_init(uv_stor_base, uv_info.uv_base_stor_len)) {
+		memblock_free(uv_stor_base, uv_info.uv_base_stor_len);
+		goto fail;
+	}
+
+	pr_info("Reserving %luMB as ultravisor base storage\n",
+		uv_info.uv_base_stor_len >> 20);
+	return;
+fail:
+	pr_info("Disabling support for protected virtualization");
+	prot_virt_host = 0;
+}
+
+void adjust_to_uv_max(unsigned long *vmax)
+{
+	*vmax = min_t(unsigned long, *vmax, uv_info.max_sec_stor_addr);
+}
 #endif
-- 
2.24.1


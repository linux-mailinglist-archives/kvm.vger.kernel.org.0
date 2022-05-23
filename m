Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDF6530D83
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 12:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbiEWJ4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiEWJ4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:56:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB0E5F52;
        Mon, 23 May 2022 02:56:33 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24N7XwRZ000846;
        Mon, 23 May 2022 09:56:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=/BDrpHm+aq91DRZo/2Z1wLNJ32oBwPQV5FOZ97QYdgg=;
 b=oJuUoCh+KLHDa+/z3mQG7dCI+N2gYPUbs+/sAG9hqKeBFgU6tT/1q0rE30QocW42FnLd
 iXMynV50pl4D2Gsl55HccpGWEd5s1jenq1BMFdaeOvDC24jJAWK2XUihHbzdfSdnzhUA
 Kg2AHRd9gznxnsrc11ucvsTm3w3uW75/N74AYLVAdtvr7txZ0gKCuqm+KyVfWJmxkgyt
 /AotHf6UuqODUJs2TRvBJO7asikDJ2UuODwf5UL6cs2+GwpEhUDU9+wC3K+h5M+B9yES
 bXF8w1AdR3XOPmnBtWL7W1uW40C3LMXi5BGW3peqh2g2lLtbTsvUyER60fW94qrLuumm uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g7a3s18ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 09:56:32 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24N9uVud026154;
        Mon, 23 May 2022 09:56:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g7a3s18tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 09:56:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24N9HbaJ006018;
        Mon, 23 May 2022 09:56:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3g6qq9ajwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 09:56:29 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24N9uQHp58327496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 09:56:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81960A4053;
        Mon, 23 May 2022 09:56:26 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65CA7A4040;
        Mon, 23 May 2022 09:56:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 23 May 2022 09:56:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 28684E7962; Mon, 23 May 2022 11:56:26 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 2/4] selftests: drivers/s390x: Add uvdevice tests
Date:   Mon, 23 May 2022 11:56:23 +0200
Message-Id: <20220523095625.13913-3-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220523095625.13913-1-borntraeger@linux.ibm.com>
References: <20220523095625.13913-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U8J3rvqjIafEdVh_2AQscEn2Gx-k3jTn
X-Proofpoint-ORIG-GUID: i1cVNBhmQesW2giunYiA8PhiVaRHCJUf
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_03,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 adultscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steffen Eiden <seiden@linux.ibm.com>

Adds some selftests to test ioctl error paths of the uv-uapi.
The Kconfig S390_UV_UAPI must be selected and the Ultravisor facility
must be available. The test can be executed by non-root, however, the
uvdevice special file /dev/uv must be accessible for reading and
writing which may imply root privileges.

  ./test-uv-device
  TAP version 13
  1..6
  # Starting 6 tests from 3 test cases.
  #  RUN           uvio_fixture.att.fault_ioctl_arg ...
  #            OK  uvio_fixture.att.fault_ioctl_arg
  ok 1 uvio_fixture.att.fault_ioctl_arg
  #  RUN           uvio_fixture.att.fault_uvio_arg ...
  #            OK  uvio_fixture.att.fault_uvio_arg
  ok 2 uvio_fixture.att.fault_uvio_arg
  #  RUN           uvio_fixture.att.inval_ioctl_cb ...
  #            OK  uvio_fixture.att.inval_ioctl_cb
  ok 3 uvio_fixture.att.inval_ioctl_cb
  #  RUN           uvio_fixture.att.inval_ioctl_cmd ...
  #            OK  uvio_fixture.att.inval_ioctl_cmd
  ok 4 uvio_fixture.att.inval_ioctl_cmd
  #  RUN           attest_fixture.att_inval_request ...
  #            OK  attest_fixture.att_inval_request
  ok 5 attest_fixture.att_inval_request
  #  RUN           attest_fixture.att_inval_addr ...
  #            OK  attest_fixture.att_inval_addr
  ok 6 attest_fixture.att_inval_addr
  # PASSED: 6 / 6 tests passed.
  # Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20220510144724.3321985-3-seiden@linux.ibm.com>
Link: https://lore.kernel.org/kvm/20220510144724.3321985-3-seiden@linux.ibm.com/
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/drivers/.gitignore    |   1 +
 .../selftests/drivers/s390x/uvdevice/Makefile |  22 ++
 .../selftests/drivers/s390x/uvdevice/config   |   1 +
 .../drivers/s390x/uvdevice/test_uvdevice.c    | 276 ++++++++++++++++++
 6 files changed, 302 insertions(+)
 create mode 100644 tools/testing/selftests/drivers/s390x/uvdevice/Makefile
 create mode 100644 tools/testing/selftests/drivers/s390x/uvdevice/config
 create mode 100644 tools/testing/selftests/drivers/s390x/uvdevice/test_uvdevice.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a74488b7bb7c..bc6fae05ee4b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10784,6 +10784,7 @@ F:	arch/s390/kernel/uv.c
 F:	arch/s390/kvm/
 F:	arch/s390/mm/gmap.c
 F:	drivers/s390/char/uvdevice.c
+F:	tools/testing/selftests/drivers/s390x/uvdevice/
 F:	tools/testing/selftests/kvm/*/s390x/
 F:	tools/testing/selftests/kvm/s390x/
 
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 2319ec87f53d..d6b307371ef7 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -10,6 +10,7 @@ TARGETS += core
 TARGETS += cpufreq
 TARGETS += cpu-hotplug
 TARGETS += drivers/dma-buf
+TARGETS += drivers/s390x/uvdevice
 TARGETS += efivarfs
 TARGETS += exec
 TARGETS += filesystems
diff --git a/tools/testing/selftests/drivers/.gitignore b/tools/testing/selftests/drivers/.gitignore
index ca74f2e1c719..09e23b5afa96 100644
--- a/tools/testing/selftests/drivers/.gitignore
+++ b/tools/testing/selftests/drivers/.gitignore
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /dma-buf/udmabuf
+/s390x/uvdevice/test_uvdevice
diff --git a/tools/testing/selftests/drivers/s390x/uvdevice/Makefile b/tools/testing/selftests/drivers/s390x/uvdevice/Makefile
new file mode 100644
index 000000000000..5e701d2708d4
--- /dev/null
+++ b/tools/testing/selftests/drivers/s390x/uvdevice/Makefile
@@ -0,0 +1,22 @@
+include ../../../../../build/Build.include
+
+UNAME_M := $(shell uname -m)
+
+ifneq ($(UNAME_M),s390x)
+nothing:
+.PHONY: all clean run_tests install
+.SILENT:
+else
+
+TEST_GEN_PROGS := test_uvdevice
+
+top_srcdir ?= ../../../../../..
+KSFT_KHDR_INSTALL := 1
+khdr_dir = $(top_srcdir)/usr/include
+LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
+
+CFLAGS += -Wall -Werror -static -I$(khdr_dir) -I$(LINUX_TOOL_ARCH_INCLUDE)
+
+include ../../../lib.mk
+
+endif
diff --git a/tools/testing/selftests/drivers/s390x/uvdevice/config b/tools/testing/selftests/drivers/s390x/uvdevice/config
new file mode 100644
index 000000000000..f28a04b99eff
--- /dev/null
+++ b/tools/testing/selftests/drivers/s390x/uvdevice/config
@@ -0,0 +1 @@
+CONFIG_S390_UV_UAPI=y
diff --git a/tools/testing/selftests/drivers/s390x/uvdevice/test_uvdevice.c b/tools/testing/selftests/drivers/s390x/uvdevice/test_uvdevice.c
new file mode 100644
index 000000000000..ea0cdc37b44f
--- /dev/null
+++ b/tools/testing/selftests/drivers/s390x/uvdevice/test_uvdevice.c
@@ -0,0 +1,276 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  selftest for the Ultravisor UAPI device
+ *
+ *  Copyright IBM Corp. 2022
+ *  Author(s): Steffen Eiden <seiden@linux.ibm.com>
+ */
+
+#include <stdint.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+
+#include <asm/uvdevice.h>
+
+#include "../../../kselftest_harness.h"
+
+#define UV_PATH  "/dev/uv"
+#define BUFFER_SIZE 0x200
+FIXTURE(uvio_fixture) {
+	int uv_fd;
+	struct uvio_ioctl_cb uvio_ioctl;
+	uint8_t buffer[BUFFER_SIZE];
+	__u64 fault_page;
+};
+
+FIXTURE_VARIANT(uvio_fixture) {
+	unsigned long ioctl_cmd;
+	uint32_t arg_size;
+};
+
+FIXTURE_VARIANT_ADD(uvio_fixture, att) {
+	.ioctl_cmd = UVIO_IOCTL_ATT,
+	.arg_size = sizeof(struct uvio_attest),
+};
+
+FIXTURE_SETUP(uvio_fixture)
+{
+	self->uv_fd = open(UV_PATH, O_ACCMODE);
+
+	self->uvio_ioctl.argument_addr = (__u64)self->buffer;
+	self->uvio_ioctl.argument_len = variant->arg_size;
+	self->fault_page =
+		(__u64)mmap(NULL, (size_t)getpagesize(), PROT_NONE, MAP_ANONYMOUS, -1, 0);
+}
+
+FIXTURE_TEARDOWN(uvio_fixture)
+{
+	if (self->uv_fd)
+		close(self->uv_fd);
+	munmap((void *)self->fault_page, (size_t)getpagesize());
+}
+
+TEST_F(uvio_fixture, fault_ioctl_arg)
+{
+	int rc, errno_cache;
+
+	rc = ioctl(self->uv_fd, variant->ioctl_cmd, NULL);
+	errno_cache = errno;
+	ASSERT_EQ(rc, -1);
+	ASSERT_EQ(errno_cache, EFAULT);
+
+	rc = ioctl(self->uv_fd, variant->ioctl_cmd, self->fault_page);
+	errno_cache = errno;
+	ASSERT_EQ(rc, -1);
+	ASSERT_EQ(errno_cache, EFAULT);
+}
+
+TEST_F(uvio_fixture, fault_uvio_arg)
+{
+	int rc, errno_cache;
+
+	self->uvio_ioctl.argument_addr = 0;
+	rc = ioctl(self->uv_fd, variant->ioctl_cmd, &self->uvio_ioctl);
+	errno_cache = errno;
+	ASSERT_EQ(rc, -1);
+	ASSERT_EQ(errno_cache, EFAULT);
+
+	self->uvio_ioctl.argument_addr = self->fault_page;
+	rc = ioctl(self->uv_fd, variant->ioctl_cmd, &self->uvio_ioctl);
+	errno_cache = errno;
+	ASSERT_EQ(rc, -1);
+	ASSERT_EQ(errno_cache, EFAULT);
+}
+
+/*
+ * Test to verify that IOCTLs with invalid values in the ioctl_control block
+ * are rejected.
+ */
+TEST_F(uvio_fixture, inval_ioctl_cb)
+{
+	int rc, errno_cache;
+
+	self->uvio_ioctl.argument_len = 0;
+	rc = ioctl(self->uv_fd, variant->ioctl_cmd, &self->uvio_ioctl);
+	errno_cache = errno;
+	ASSERT_EQ(rc, -1);
+	ASSERT_EQ(errno_cache, EINVAL);
+
+	self->uvio_ioctl.argument_len = (uint32_t)-1;
+	rc = ioctl(self->uv_fd, variant->ioctl_cmd, &self->uvio_ioctl);
+	errno_cache = errno;
+	ASSERT_EQ(rc, -1);
+	ASSERT_EQ(errno_cache, EINVAL);
+	self->uvio_ioctl.argument_len = variant->arg_size;
+
+	self->uvio_ioctl.flags = (uint32_t)-1;
+	rc = ioctl(self->uv_fd, variant->ioctl_cmd, &self->uvio_ioctl);
+	errno_cache = errno;
+	ASSERT_EQ(rc, -1);
+	ASSERT_EQ(errno_cache, EINVAL);
+	self->uvio_ioctl.flags = 0;
+
+	memset(self->uvio_ioctl.reserved14, 0xff, sizeof(self->uvio_ioctl.reserved14));
+	rc = ioctl(self->uv_fd, variant->ioctl_cmd, &self->uvio_ioctl);
+	errno_cache = errno;
+	ASSERT_EQ(rc, -1);
+	ASSERT_EQ(errno_cache, EINVAL);
+
+	memset(&self->uvio_ioctl, 0x11, sizeof(self->uvio_ioctl));
+	rc = ioctl(self->uv_fd, variant->ioctl_cmd, &self->uvio_ioctl);
+	ASSERT_EQ(rc, -1);
+}
+
+TEST_F(uvio_fixture, inval_ioctl_cmd)
+{
+	int rc, errno_cache;
+	uint8_t nr = _IOC_NR(variant->ioctl_cmd);
+	unsigned long cmds[] = {
+		_IOWR('a', nr, struct uvio_ioctl_cb),
+		_IOWR(UVIO_TYPE_UVC, nr, int),
+		_IO(UVIO_TYPE_UVC, nr),
+		_IOR(UVIO_TYPE_UVC, nr, struct uvio_ioctl_cb),
+		_IOW(UVIO_TYPE_UVC, nr, struct uvio_ioctl_cb),
+	};
+
+	for (size_t i = 0; i < ARRAY_SIZE(cmds); i++) {
+		rc = ioctl(self->uv_fd, cmds[i], &self->uvio_ioctl);
+		errno_cache = errno;
+		ASSERT_EQ(rc, -1);
+		ASSERT_EQ(errno_cache, ENOTTY);
+	}
+}
+
+struct test_attest_buffer {
+	uint8_t arcb[0x180];
+	uint8_t meas[64];
+	uint8_t add[32];
+};
+
+FIXTURE(attest_fixture) {
+	int uv_fd;
+	struct uvio_ioctl_cb uvio_ioctl;
+	struct uvio_attest uvio_attest;
+	struct test_attest_buffer attest_buffer;
+	__u64 fault_page;
+};
+
+FIXTURE_SETUP(attest_fixture)
+{
+	self->uv_fd = open(UV_PATH, O_ACCMODE);
+
+	self->uvio_ioctl.argument_addr = (__u64)&self->uvio_attest;
+	self->uvio_ioctl.argument_len = sizeof(self->uvio_attest);
+
+	self->uvio_attest.arcb_addr = (__u64)&self->attest_buffer.arcb;
+	self->uvio_attest.arcb_len = sizeof(self->attest_buffer.arcb);
+
+	self->uvio_attest.meas_addr = (__u64)&self->attest_buffer.meas;
+	self->uvio_attest.meas_len = sizeof(self->attest_buffer.meas);
+
+	self->uvio_attest.add_data_addr = (__u64)&self->attest_buffer.add;
+	self->uvio_attest.add_data_len = sizeof(self->attest_buffer.add);
+	self->fault_page =
+		(__u64)mmap(NULL, (size_t)getpagesize(), PROT_NONE, MAP_ANONYMOUS, -1, 0);
+}
+
+FIXTURE_TEARDOWN(attest_fixture)
+{
+	if (self->uv_fd)
+		close(self->uv_fd);
+	munmap((void *)self->fault_page, (size_t)getpagesize());
+}
+
+static void att_inval_sizes_test(uint32_t *size, uint32_t max_size, bool test_zero,
+				 struct __test_metadata *_metadata,
+				 FIXTURE_DATA(attest_fixture) *self)
+{
+	int rc, errno_cache;
+	uint32_t tmp = *size;
+
+	if (test_zero) {
+		*size = 0;
+		rc = ioctl(self->uv_fd, UVIO_IOCTL_ATT, &self->uvio_ioctl);
+		errno_cache = errno;
+		ASSERT_EQ(rc, -1);
+		ASSERT_EQ(errno_cache, EINVAL);
+	}
+	*size = max_size + 1;
+	rc = ioctl(self->uv_fd, UVIO_IOCTL_ATT, &self->uvio_ioctl);
+	errno_cache = errno;
+	ASSERT_EQ(rc, -1);
+	ASSERT_EQ(errno_cache, EINVAL);
+	*size = tmp;
+}
+
+/*
+ * Test to verify that attestation IOCTLs with invalid values in the UVIO
+ * attestation control block are rejected.
+ */
+TEST_F(attest_fixture, att_inval_request)
+{
+	int rc, errno_cache;
+
+	att_inval_sizes_test(&self->uvio_attest.add_data_len, UVIO_ATT_ADDITIONAL_MAX_LEN,
+			     false, _metadata, self);
+	att_inval_sizes_test(&self->uvio_attest.meas_len, UVIO_ATT_MEASUREMENT_MAX_LEN,
+			     true, _metadata, self);
+	att_inval_sizes_test(&self->uvio_attest.arcb_len, UVIO_ATT_ARCB_MAX_LEN,
+			     true, _metadata, self);
+
+	self->uvio_attest.reserved136 = (uint16_t)-1;
+	rc = ioctl(self->uv_fd, UVIO_IOCTL_ATT, &self->uvio_ioctl);
+	errno_cache = errno;
+	ASSERT_EQ(rc, -1);
+	ASSERT_EQ(errno_cache, EINVAL);
+
+	memset(&self->uvio_attest, 0x11, sizeof(self->uvio_attest));
+	rc = ioctl(self->uv_fd, UVIO_IOCTL_ATT, &self->uvio_ioctl);
+	ASSERT_EQ(rc, -1);
+}
+
+static void att_inval_addr_test(__u64 *addr, struct __test_metadata *_metadata,
+				FIXTURE_DATA(attest_fixture) *self)
+{
+	int rc, errno_cache;
+	__u64 tmp = *addr;
+
+	*addr = 0;
+	rc = ioctl(self->uv_fd, UVIO_IOCTL_ATT, &self->uvio_ioctl);
+	errno_cache = errno;
+	ASSERT_EQ(rc, -1);
+	ASSERT_EQ(errno_cache, EFAULT);
+	*addr = self->fault_page;
+	rc = ioctl(self->uv_fd, UVIO_IOCTL_ATT, &self->uvio_ioctl);
+	errno_cache = errno;
+	ASSERT_EQ(rc, -1);
+	ASSERT_EQ(errno_cache, EFAULT);
+	*addr = tmp;
+}
+
+TEST_F(attest_fixture, att_inval_addr)
+{
+	att_inval_addr_test(&self->uvio_attest.arcb_addr, _metadata, self);
+	att_inval_addr_test(&self->uvio_attest.add_data_addr, _metadata, self);
+	att_inval_addr_test(&self->uvio_attest.meas_addr, _metadata, self);
+}
+
+static void __attribute__((constructor)) __constructor_order_last(void)
+{
+	if (!__constructor_order)
+		__constructor_order = _CONSTRUCTOR_ORDER_BACKWARD;
+}
+
+int main(int argc, char **argv)
+{
+	int fd = open(UV_PATH, O_ACCMODE);
+
+	if (fd < 0)
+		ksft_exit_skip("No uv-device or cannot access " UV_PATH  "\n"
+			       "Enable CONFIG_S390_UV_UAPI and check the access rights on "
+			       UV_PATH ".\n");
+	close(fd);
+	return test_harness_run(argc, argv);
+}
-- 
2.35.1


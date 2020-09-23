Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D85F275915
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 15:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgIWNsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 09:48:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726550AbgIWNsQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 09:48:16 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NDWNKI178002;
        Wed, 23 Sep 2020 09:48:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SbE/vsOJaxUSDQXMjtRFfmXi25d37+6rMs0F1MCubSo=;
 b=iu+eZu+7vZ8RMl4dWDACBO9eo1/XhLvE3eIX5JWLVjnlqOImw+LZnuqfGdAHM5M1BJiw
 qbKOdnTle1vtoEnzjEAbImxTzG1qRf1qVkhFeTGF98v/hhuTAVIkvoUPHnfTaxwpS7m1
 osSvPXhRfHM1qEySFL55synasEOONhnebszBF28TB4SbtJSln1XNOfmPwXveC1NnglGB
 Hm+3+0oTVYjll1dXtyUY5S2gg78EtUFtX6WTAlsrBSVy94AHWAIPdcHbbAUYlK9UxPEg
 07+VjVaeMKMbMO2QDILkUbtlQ1dxCT9+7v00/71X4CIfNMEmFiK9uIOlT5U5XDYOuBIJ +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33r3tgqrxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 09:48:14 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08NDWf0W179946;
        Wed, 23 Sep 2020 09:48:14 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33r3tgqrwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 09:48:14 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08NDlowB029285;
        Wed, 23 Sep 2020 13:48:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 33n9m7t6c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 13:48:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08NDm9LV25493790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 13:48:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC4E34C05C;
        Wed, 23 Sep 2020 13:48:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5093B4C050;
        Wed, 23 Sep 2020 13:48:09 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.64.218])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 13:48:09 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
Subject: [PATCH kvm-unit-tests v2 4/4] s390x: add Protected VM support
Date:   Wed, 23 Sep 2020 15:47:58 +0200
Message-Id: <20200923134758.19354-5-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923134758.19354-1-mhartmay@linux.ibm.com>
References: <20200923134758.19354-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_09:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 spamscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 suspectscore=13
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009230103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for Protected Virtual Machine (PVM) tests. For starting a
PVM guest we must be able to generate a PVM image by using the
`genprotimg` tool from the s390-tools collection. This requires the
ability to pass a machine-specific host-key document, so the option
`--host-key-document` is added to the configure script.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 configure               |  9 +++++++++
 s390x/Makefile          | 17 +++++++++++++++--
 s390x/selftest.parmfile |  1 +
 s390x/unittests.cfg     |  1 +
 scripts/s390x/func.bash | 36 ++++++++++++++++++++++++++++++++++++
 5 files changed, 62 insertions(+), 2 deletions(-)
 create mode 100644 s390x/selftest.parmfile
 create mode 100644 scripts/s390x/func.bash

diff --git a/configure b/configure
index f9305431a9cb..fe319233eb50 100755
--- a/configure
+++ b/configure
@@ -19,6 +19,7 @@ wa_divide=
 vmm="qemu"
 errata_force=0
 erratatxt="$srcdir/errata.txt"
+host_key_document=
 
 usage() {
     cat <<-EOF
@@ -41,6 +42,9 @@ usage() {
 	                           no environ is provided by the user (enabled by default)
 	    --erratatxt=FILE       specify a file to use instead of errata.txt. Use
 	                           '--erratatxt=' to ensure no file is used.
+	    --host-key-document=HOST_KEY_DOCUMENT
+	                           Specify the machine-specific host-key document for creating
+	                           a PVM image with 'genprotimg' (s390x only)
 EOF
     exit 1
 }
@@ -93,6 +97,9 @@ while [[ "$1" = -* ]]; do
 	    erratatxt=
 	    [ "$arg" ] && erratatxt=$(eval realpath "$arg")
 	    ;;
+	--host-key-document)
+	    host_key_document="$arg"
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -224,6 +231,8 @@ ENVIRON_DEFAULT=$environ_default
 ERRATATXT=$erratatxt
 U32_LONG_FMT=$u32_long
 WA_DIVIDE=$wa_divide
+GENPROTIMG=${GENPROTIMG-genprotimg}
+HOST_KEY_DOCUMENT=$host_key_document
 EOF
 
 cat <<EOF > lib/config.h
diff --git a/s390x/Makefile b/s390x/Makefile
index c2213ad92e0d..b079a26dffb7 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -19,12 +19,19 @@ tests += $(TEST_DIR)/smp.elf
 tests += $(TEST_DIR)/sclp.elf
 tests += $(TEST_DIR)/css.elf
 tests += $(TEST_DIR)/uv-guest.elf
-tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
-all: directories test_cases test_cases_binary
+tests_binary = $(patsubst %.elf,%.bin,$(tests))
+ifneq ($(HOST_KEY_DOCUMENT),)
+tests_pv_binary = $(patsubst %.bin,%.pv.bin,$(tests_binary))
+else
+tests_pv_binary =
+endif
+
+all: directories test_cases test_cases_binary test_cases_pv
 
 test_cases: $(tests)
 test_cases_binary: $(tests_binary)
+test_cases_pv: $(tests_pv_binary)
 
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
@@ -73,6 +80,12 @@ FLATLIBS = $(libcflat)
 %.bin: %.elf
 	$(OBJCOPY) -O binary  $< $@
 
+%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@)
+	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --no-verify --image $< -o $@
+
+%.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
+	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
+
 arch_clean: asm_offsets_clean
 	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
 
diff --git a/s390x/selftest.parmfile b/s390x/selftest.parmfile
new file mode 100644
index 000000000000..5613931aa5c6
--- /dev/null
+++ b/s390x/selftest.parmfile
@@ -0,0 +1 @@
+test 123
\ No newline at end of file
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 6d50c634770f..3feb8bcaa13d 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -21,6 +21,7 @@
 [selftest-setup]
 file = selftest.elf
 groups = selftest
+# please keep the kernel cmdline in sync with $(TEST_DIR)/selftest.parmfile
 extra_params = -append 'test 123'
 
 [intercept]
diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
new file mode 100644
index 000000000000..4eae5e916c61
--- /dev/null
+++ b/scripts/s390x/func.bash
@@ -0,0 +1,36 @@
+# The file scripts/common.bash has to be the only file sourcing this
+# arch helper file
+source config.mak
+
+ARCH_CMD=arch_cmd_s390x
+
+function arch_cmd_s390x()
+{
+	local cmd=$1
+	local testname=$2
+	local groups=$3
+	local smp=$4
+	local kernel=$5
+	local opts=$6
+	local arch=$7
+	local check=$8
+	local accel=$9
+	local timeout=${10}
+
+	# run the normal test case
+	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+
+	# run PV test case
+	kernel=${kernel%.elf}.pv.bin
+	testname=${testname}_PV
+	if [ ! -f "${kernel}" ]; then
+		if [ -z "${HOST_KEY_DOCUMENT}" ]; then
+			print_result 'SKIP' $testname '' 'no host-key document specified'
+			return 2
+		fi
+
+		print_result 'SKIP' $testname '' 'PVM image was not created'
+		return 2
+	fi
+	"$cmd" "$testname" "$groups pv" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+}
-- 
2.25.4


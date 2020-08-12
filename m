Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EAF242793
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 11:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgHLJ1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 05:27:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27860 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727899AbgHLJ1W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Aug 2020 05:27:22 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07C93Oug113926;
        Wed, 12 Aug 2020 05:27:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CpkcsCiIHT1ZLz+tIbVScMEnniEenbhIqlikhJ3QR7M=;
 b=oeD/cX2R6xVZS1t9egOpz3gbYOFJUUb1D6P2zdI+RFnnLTTJsyOc3BLaG0wu2IInz/xZ
 YjE9HkMtwNz5l0NB5NC3wS9psMeatxv098/B+zHe0GTwzyZNzX9+Uy9c98+iTL1MJkUu
 FOKA6/2fIlFuC9emrV6L0VUEDfqWD5gCGpbWZ8y0wnykTB3y35qLAjaaQNp3/iVhoIT8
 ua1RHcOA/fG5T+AO5K4Un8P4LF0WyjpHg1E4h9Sh8jcJ24x26TqiNvWq82G3sdzuGck3
 o1EUCElq0FuSenqHhgadERvzHnB0MB8JSLUhTr27mW1juBI3606OtHuqBj3MkxTT3T/4 KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32v7r493kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 05:27:20 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07C9NJXO195946;
        Wed, 12 Aug 2020 05:27:20 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32v7r493k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 05:27:20 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07C9K2ew006665;
        Wed, 12 Aug 2020 09:27:18 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 32skp82mee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 09:27:18 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07C9RFJx21627306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 09:27:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A6C852051;
        Wed, 12 Aug 2020 09:27:15 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.75.196])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2298352054;
        Wed, 12 Aug 2020 09:27:15 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests RFC v2 4/4] s390x: add Protected VM support
Date:   Wed, 12 Aug 2020 11:27:05 +0200
Message-Id: <20200812092705.17774-5-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200812092705.17774-1-mhartmay@linux.ibm.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_02:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120064
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for Protected Virtual Machine (PVM) tests. For starting a
PVM guest we must be able to generate a PVM image by using the
`genprotimg` tool from the s390-tools collection. This requires the
ability to pass a machine-specific host-key document, so the option
`--host-key-document` is added to the configure script.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 configure               |  8 ++++++++
 s390x/Makefile          | 17 +++++++++++++++--
 s390x/selftest.parmfile |  1 +
 s390x/unittests.cfg     |  1 +
 scripts/s390x/func.bash | 18 ++++++++++++++++++
 5 files changed, 43 insertions(+), 2 deletions(-)
 create mode 100644 s390x/selftest.parmfile
 create mode 100644 scripts/s390x/func.bash

diff --git a/configure b/configure
index f9d030fd2f03..aa528af72534 100755
--- a/configure
+++ b/configure
@@ -18,6 +18,7 @@ u32_long=
 vmm="qemu"
 errata_force=0
 erratatxt="$srcdir/errata.txt"
+host_key_document=
 
 usage() {
     cat <<-EOF
@@ -40,6 +41,8 @@ usage() {
 	                           no environ is provided by the user (enabled by default)
 	    --erratatxt=FILE       specify a file to use instead of errata.txt. Use
 	                           '--erratatxt=' to ensure no file is used.
+	    --host-key-document=HOST_KEY_DOCUMENT
+	                           host-key-document to use (s390x only)
 EOF
     exit 1
 }
@@ -92,6 +95,9 @@ while [[ "$1" = -* ]]; do
 	    erratatxt=
 	    [ "$arg" ] && erratatxt=$(eval realpath "$arg")
 	    ;;
+	--host-key-document)
+	    host_key_document="$arg"
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -205,6 +211,8 @@ PRETTY_PRINT_STACKS=$pretty_print_stacks
 ENVIRON_DEFAULT=$environ_default
 ERRATATXT=$erratatxt
 U32_LONG_FMT=$u32_long
+GENPROTIMG=${GENPROTIMG-genprotimg}
+HOST_KEY_DOCUMENT=$host_key_document
 EOF
 
 cat <<EOF > lib/config.h
diff --git a/s390x/Makefile b/s390x/Makefile
index 0f54bf43bfb7..cd4e270952ec 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -18,12 +18,19 @@ tests += $(TEST_DIR)/skrf.elf
 tests += $(TEST_DIR)/smp.elf
 tests += $(TEST_DIR)/sclp.elf
 tests += $(TEST_DIR)/css.elf
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
@@ -72,6 +79,12 @@ FLATLIBS = $(libcflat)
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
index 0f156afbe741..12f6fb613995 100644
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
index 000000000000..5c682cb47f73
--- /dev/null
+++ b/scripts/s390x/func.bash
@@ -0,0 +1,18 @@
+# Run Protected VM test
+function arch_cmd()
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
+	kernel=${kernel%.elf}.pv.bin
+	# do not run PV test cases by default
+	"$cmd" "${testname}_PV" "$groups pv nodefault" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+}
-- 
2.25.4


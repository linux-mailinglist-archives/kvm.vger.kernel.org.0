Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D4B3BE937
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 16:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhGGOGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 10:06:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10540 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231357AbhGGOGO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 10:06:14 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167DYD7i092280;
        Wed, 7 Jul 2021 10:03:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4QVl43MCG/SpLaVeNLAJrrJyRbVZ2yV6iiZIupc2gAs=;
 b=qXcCB8zP0CTipCVII8gz47s9cgMZ65VcRPPWV9JHROGvJ6NOJKiF1TaadvHZoXThOZS/
 XKd77stVocHySwXFYI55Cb6Kd7xataGQoahdAA1LoRG7Z9FSRbCFhdpZNE5s5KSIGMUg
 2BlrGkvQzhNOxuUXygmByR05c0/h6rMJtMLqb1ubAtq+YEQcOY5j6mRoskZ8Z7Mk181I
 IHy7P617vtyOaVWL7vdrauFYmBjI9bsL3xYT8ZiVwdBnqMoEWVtBpFjuJwcur3ZqExLl
 cz8MVp0ML82hAbjSj3xOOViifVLvp82qodmv5e7Ak11leXAgQ5EY7RGda9ryjhrpyeCK mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39m8xtv8r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:33 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167DZMa7098632;
        Wed, 7 Jul 2021 10:03:33 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39m8xtv8qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:33 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167E2eNS005320;
        Wed, 7 Jul 2021 14:03:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 39jf5h9sn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 14:03:31 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167E1aPU28639570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 14:01:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44261A4051;
        Wed,  7 Jul 2021 14:03:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0FE1A4040;
        Wed,  7 Jul 2021 14:03:27 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.29.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 14:03:27 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 2/8] s390x: snippets: Add snippet compilation
Date:   Wed,  7 Jul 2021 16:03:12 +0200
Message-Id: <20210707140318.44255-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707140318.44255-1-frankja@linux.ibm.com>
References: <20210707140318.44255-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BBiUp3ml5z8RgDrJu7SZ-sefIcRdEJie
X-Proofpoint-GUID: yN1f41g7EZ4oLTumzaozXXLdAXe3G1rV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_06:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steffen Eiden <seiden@linux.ibm.com>

This patch provides the necessary make targets to properly compile
snippets and link them into their associated host.

To define the guest-host definition, we use the make-feature
`SECONDEXPANSION` in combination with `Target specific Variable
Values`. The variable `snippets` has different values depending on the
current target. This enables us to define which snippets (=guests)
belong to which hosts. Furthermore, using the second-expansion, we can
use `snippets` in the perquisites of the host's `%.elf` rule, which
otherwise would be not set.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 8820e998..ba32f4c2 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -76,11 +76,26 @@ OBJDIRS += lib/s390x
 asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
 
 FLATLIBS = $(libcflat)
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
-	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) \
-		$(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
-	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
-		$(filter %.o, $^) $(FLATLIBS) $(@:.elf=.aux.o)
+
+SNIPPET_DIR = $(TEST_DIR)/snippets
+snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
+
+# perquisites (=guests) for the snippet hosts.
+# $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
+
+$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
+	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
+	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
+
+$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
+	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib) $(FLATLIBS)
+	$(OBJCOPY) -O binary $@ $@
+	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
+
+.SECONDEXPANSION:
+%.elf: $$(snippets) %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
+	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
+	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds $(filter %.o, $^) $(FLATLIBS) $(snippets) $(@:.elf=.aux.o)
 	$(RM) $(@:.elf=.aux.o)
 	@chmod a-x $@
 
@@ -94,7 +109,7 @@ FLATLIBS = $(libcflat)
 	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
 
 arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
+	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d $(SNIPPET_DIR)/c/*.{o,gbin} $(SNIPPET_DIR)/c/.*.d lib/s390x/.*.d
 
 generated-files = $(asm-offsets)
 $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
-- 
2.31.1


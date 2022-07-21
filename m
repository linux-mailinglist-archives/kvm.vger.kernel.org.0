Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC8257CBDB
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 15:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiGUN07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 09:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGUN04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 09:26:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5951573915
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 06:26:55 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDDwPU001802
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 13:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SoYxwomgt635bX0uFwkZZbkHy1bLQGSR7p8b+L7JXsA=;
 b=NBGMkbRr02d1YCA3eol+Dn4iV9DhUBQ6Ew5LWWRw7yTnsjRyh22PF1xx6Gfq9Mk2qnvG
 pL6vUrYeAlnE2Z6WeWpZFVgY3JlibyBsd9j4bGbcr/4ueWKFNl7rUY54GKjYrBwxNd4H
 +c15Tahl7Gh2ey4Or6eRIuZp2VREY6hJ7IzeI0wCtrPc9NW7k9jvxuOlYs2mmlF+HbYt
 P3GiGQk3804WdDBKafWecLAdobxq5QfdGqiYbQUuisynRekY4nVU4a3OWE0pbwLI8qAb
 gywJm7TuKoYw6yev7vHkno3zjhIXBXi0bhC5I4Kde1N4e+PXA/QplyflmzoUXZfQErBP gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf74q9dxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 13:26:54 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LDOBXw000674
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 13:26:53 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf74q9dwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:26:53 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LDNtWL001303;
        Thu, 21 Jul 2022 13:26:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3hbmy8waee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:26:51 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LDQmrt10420528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 13:26:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1DFB11C04A;
        Thu, 21 Jul 2022 13:26:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E83011C04C;
        Thu, 21 Jul 2022 13:26:48 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 13:26:48 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/2] s390x: create persistent comm-key
Date:   Thu, 21 Jul 2022 15:26:47 +0200
Message-Id: <20220721132647.552298-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721132647.552298-1-nrb@linux.ibm.com>
References: <20220721132647.552298-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uiC2ycAPOHuvKQ1V7DFMqJoq8Zg0Z-m6
X-Proofpoint-ORIG-GUID: W9pEmT0fp-wm-MhsJf5tJdn46bNnI1pp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_16,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To decrypt the dump of a PV guest, the comm-key (CCK) is required. Until
now, no comm-key was provided to genprotimg, therefore decrypting the
dump of a kvm-unit-test under PV was not possible.

This patch makes sure that we create a random CCK if there's no
$(TEST_DIR)/comm.key file.

Also allow dumping of PV tests by passing the appropriate PCF to
genprotimg (bit 34). --x-pcf is used to be compatible with older
genprotimg versions, which don't support --enable-dump. 0xe0 is the
default PCF value and only bit 34 is added.

Unfortunately, recent versions of genprotimg removed the --x-comm-key
argument which was used by older versions to specify the CCK. To support
these versions, we need to parse the genprotimg help output and decide
which argument to use.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 34de233d09b8..5e3cb5a47bc2 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -162,14 +162,27 @@ $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
 	$(RM) $(@:.elf=.aux.o)
 	@chmod a-x $@
 
+comm-key = $(TEST_DIR)/comm.key
+$(comm-key):
+	dd if=/dev/urandom of=$@ bs=32 count=1 status=none
+
 %.bin: %.elf
 	$(OBJCOPY) -O binary  $< $@
 
-genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify
-%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@)
+GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
+ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
+	GENPROTIMG_COMM_KEY = --comm-key $(comm-key)
+else
+	GENPROTIMG_COMM_KEY = --x-comm-key $(comm-key)
+endif
+# use x-pcf to be compatible with old genprotimg versions
+# allow dumping + PCKMO
+genprotimg_pcf = 0x200000e0
+genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_KEY) --x-pcf $(genprotimg_pcf)
+%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@) $(comm-key)
 	$(GENPROTIMG) $(genprotimg_args) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --image $< -o $@
 
-%.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
+%.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
 	$(GENPROTIMG) $(genprotimg_args) --image $< -o $@
 
 $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
@@ -177,7 +190,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 
 
 arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d
+	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
 
 generated-files = $(asm-offsets)
 $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
-- 
2.36.1


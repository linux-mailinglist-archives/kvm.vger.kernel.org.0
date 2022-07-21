Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEFB57CBDA
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 15:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiGUN06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 09:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGUN04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 09:26:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C3754CBD
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 06:26:54 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDPmZ4028290
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 13:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GtUnMnE0+z/9wykF8fOsNw4kGMRrVRxaFZEmzGb8iXg=;
 b=AFA0CkwieKadNIF+UbBZxpqHMgSJ76A0Bo3gMnyx+BdKSbCtJ1OTvYsNONnwOEyw2WCF
 jSDhLPfZ5o0mMviSYUXzP3TvuHdZSrcA7MY3EoMcEk55NFv8rsRhRl2FR5XhOxmlHWcT
 PLGJhlvJMs7ibVhZ9VRoHlu/x1q/x9u0WryuLISTlSGGSqSF0hmGp8TqkgNmj1ljirRw
 CN9Nw6+IRDt0lA1Ceo9TLhLeQRoGlwq4OBKMf0rm5Z0MdQjxtyfPugSJTdJt516cjWwJ
 UT1GoMfcHGhAMdQ+E13mXwNTH82j8fdntkeRDHHIbB4xddGy2m9UZCDIkTqyxiK/63pJ Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7p3g0m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 13:26:54 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LDQrow030724
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 13:26:53 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7p3g0kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:26:53 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LDP0N0031051;
        Thu, 21 Jul 2022 13:26:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3hbmy8y52f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:26:51 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LDQmL910420526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 13:26:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8343711C04A;
        Thu, 21 Jul 2022 13:26:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4644811C050;
        Thu, 21 Jul 2022 13:26:48 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 13:26:48 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/2] s390x: factor out common args for genprotimg
Date:   Thu, 21 Jul 2022 15:26:46 +0200
Message-Id: <20220721132647.552298-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721132647.552298-1-nrb@linux.ibm.com>
References: <20220721132647.552298-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AqTuuFqV0rTe8OhOUUX332CVB6_75WFs
X-Proofpoint-ORIG-GUID: uPKaLqwGFMDkdX47uN3GCAVqEmdkPncw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_17,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207210053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upcoming changes will add more arguments to genprotimg. To avoid
duplicating this logic, move the arguments to genprotimg to a variable.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index efd5e0c13102..34de233d09b8 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -165,11 +165,12 @@ $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
 %.bin: %.elf
 	$(OBJCOPY) -O binary  $< $@
 
+genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify
 %selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@)
-	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --no-verify --image $< -o $@
+	$(GENPROTIMG) $(genprotimg_args) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --image $< -o $@
 
 %.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
-	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
+	$(GENPROTIMG) $(genprotimg_args) --image $< -o $@
 
 $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
-- 
2.36.1


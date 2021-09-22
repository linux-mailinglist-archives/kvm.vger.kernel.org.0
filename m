Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3E4414287
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 09:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhIVHVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 03:21:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50732 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229697AbhIVHUf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 03:20:35 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M4dqEr007715;
        Wed, 22 Sep 2021 03:19:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=onuTzEAi6x9oc9QB1i0auHZRwIh7r23BCvZM0M2GGUY=;
 b=iDJyyNR0FtsQeeTtjLSrev9vsoNCkH3mkmKAkHjytW/jjry8Hlptbw3OF9+3hdIcpNYp
 /uicGoBHiYjjXYr0dMvrxMKNJ7ZndC4UIQlteIFTNTqKDamyUYPXiSEbQNAYFRDnpI9k
 FBY4EzKqI+WXEQAUrCBYdr9R1zIJnpcCHSzImY5XhhvLjUfIGa7hBnxWbdJJmeBvMN9y
 +F392xwSJq/8CPKV5S2qKhm6HNwg2My0/Ebkx8cQ46L4tMQ74k/SsySpK8HY25Q5E8XS
 4h4KsfZFFDcLhWHny5vCEXwBk4DAYa4PLWslV1wbkJsW9WfJB6YjM3/yk/dQ/yapfxWU FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7vn1bxfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:05 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M76f3A004666;
        Wed, 22 Sep 2021 03:19:05 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7vn1bxf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:05 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M78rna024910;
        Wed, 22 Sep 2021 07:19:03 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3b7q66bb0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:19:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M7EDbY41615738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 07:14:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1BBBA405E;
        Wed, 22 Sep 2021 07:18:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EC0EA405D;
        Wed, 22 Sep 2021 07:18:59 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 07:18:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, linux-s390@vger.kernel.org,
        seiden@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 7/9] s390x: Makefile: Remove snippet flatlib linking
Date:   Wed, 22 Sep 2021 07:18:09 +0000
Message-Id: <20210922071811.1913-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210922071811.1913-1-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Yv44q-Hy5vj1aWXUKGwFFTdlns2Y26Za
X-Proofpoint-ORIG-GUID: cjR4PY0V0WJywuYNnxFa4aTXFulAUSvw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_02,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can't link the flatlib as we do not export everything that it needs
and we don't (want to) call the init functions.

In the future we might implement a tiny lib that uses select lib
object files and re-implements functions like assert() and
test_facility() to be able to use some parts of the lib.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 5d1a33a0..d09c0a17 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -92,7 +92,7 @@ $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
 	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
 
 $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
-	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib) $(FLATLIBS)
+	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib)
 	$(OBJCOPY) -O binary $@ $@
 	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
 
-- 
2.30.2


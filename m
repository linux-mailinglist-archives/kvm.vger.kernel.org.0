Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845E43F7A62
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240819AbhHYQVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:21:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2510 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241399AbhHYQVR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Aug 2021 12:21:17 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17PG6rgO116593
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 12:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=FcP2iSfau3ZzbLcffp0PYnMVjaFZwBnKYqGc6BS78PE=;
 b=UzH9Ji3+bbBIza7yAQs/9ZyzxwBVN27gI/4yTA2CAgnXLS3uWaKrr8Btpt7TlVU4+ffv
 jjnm8WZttTZUwRKhJ8NvDQ0Uca/xj3amxGDullA/zt01hmI3bQOU9wK5gS1I17178fyb
 Xzz5658y6aAsRTwDyiiXFLhB1AKJS6qHXW3zToVew+JXhse6wVGM8vxcI9JQPko9X5hQ
 yrj4EVo0V2ILS2VdnwcP3D5LrLrqKtTEEe/jGtWhuBjGZqOhH+I9ZpZAdA/8JAWWbX0f
 Wi/3jML3VV/38J/OqAQsQ0tTLfPLD14lc7mWVPxIf2RTiXnQgzR83cQj9UBI5TyQ4IB+ Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3anr7r21sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 12:20:29 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17PG7FRF117829
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 12:20:29 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3anr7r21ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 12:20:29 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17PGGEGe026194;
        Wed, 25 Aug 2021 16:20:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3ajrrhfjv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 16:20:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17PGGbbp53870906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Aug 2021 16:16:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C2C711C050;
        Wed, 25 Aug 2021 16:20:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40EFA11C028;
        Wed, 25 Aug 2021 16:20:23 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.34.28])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 Aug 2021 16:20:23 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/2] Makefile: Fix cscope
Date:   Wed, 25 Aug 2021 18:20:20 +0200
Message-Id: <1629908421-8543-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
References: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z-6UHQJcSeBg3idWMzMieiZSG9JGFyyR
X-Proofpoint-ORIG-GUID: VtCrwabuWhwqZtyJGNe16C44iqqefu25
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_06:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 bulkscore=0 mlxlogscore=836 mlxscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108250096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In Linux, cscope uses a wrong directory.
Simply search from the directory where the make is started.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index f7b9f28c..c8b0d74f 100644
--- a/Makefile
+++ b/Makefile
@@ -119,7 +119,7 @@ cscope: cscope_dirs = lib lib/libfdt lib/linux $(TEST_DIR) $(ARCH_LIBDIRS) lib/a
 cscope:
 	$(RM) ./cscope.*
 	find -L $(cscope_dirs) -maxdepth 1 \
-		-name '*.[chsS]' -exec realpath --relative-base=$(PWD) {} \; | sort -u > ./cscope.files
+		-name '*.[chsS]' -exec realpath --relative-base=. {} \; | sort -u > ./cscope.files
 	cscope -bk
 
 .PHONY: tags
-- 
2.25.1


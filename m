Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD5A60703E
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 08:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiJUGns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 02:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJUGnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 02:43:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27776242CA0
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 23:43:38 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29L6bkvB022339
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tYoXkktIQCLd229pSkGFldOxXCBYKlfOSAP53aC1crA=;
 b=fURJAVClA8tAr7FKMaSnP/s3yD1k4MDeVE1EyWLhO0B/3cEl5GZXw6DuhbH0BfSycFXo
 YH7QYxkJg+cOsMtcic159a3EmjOBvyRLiyS7U9L++681oQBPrCdAJ7LCSg+pQrP5r+Lb
 UKbf6aV+kgW34koKds2hE5UFPETjcj+WpDJHmyeUnngAa2Iqp14hQoeMSw0nhYG6Os8x
 T9oqXATaUCJnyQmYj5SVjmL7uRxwpc1yRc0KNCRFuRZaEOYawOoQaSNzw2PrAv6aV+sO
 p9Z+V9bXQaFDxZOfGXJoVB26kiu9OCf9Hpzj5n8OKDQdJ8kQI2PXp8d83gdzG9aOb1/J gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbnxn0mkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:43:37 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29L6fAtC010512
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:43:37 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbnxn0mk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 06:43:37 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29L6ZdRO003384;
        Fri, 21 Oct 2022 06:43:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg9a18s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 06:43:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29L6cRwH27984316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Oct 2022 06:38:27 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8016F11C050;
        Fri, 21 Oct 2022 06:43:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6F3111C04A;
        Fri, 21 Oct 2022 06:43:30 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Oct 2022 06:43:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 5/6] lib: s390x: Enable reusability of VMs that were in PV mode
Date:   Fri, 21 Oct 2022 06:39:01 +0000
Message-Id: <20221021063902.10878-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021063902.10878-1-frankja@linux.ibm.com>
References: <20221021063902.10878-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vDy_TLI0SKHMMQagwNaeYdYgdJIcqiqE
X-Proofpoint-ORIG-GUID: 9FFxN7BHIGiGAMJbwoa0jRo0jc9iEUJU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_01,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert the sblk to non-PV when the PV guest is destroyed.

Early return in uv_init() instead of running into the assert. This is
necessary since snippet_pv_init() will always call uv_init().

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/uv.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index b2a43424..383271a5 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -76,7 +76,8 @@ void uv_init(void)
 	int cc;
 
 	/* Let's not do this twice */
-	assert(!initialized);
+	if (initialized)
+		return;
 	/* Query is done on initialization but let's check anyway */
 	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
 
@@ -188,6 +189,14 @@ void uv_destroy_guest(struct vm *vm)
 	free_pages(vm->uv.conf_var_stor);
 
 	free_pages((void *)(vm->uv.asce & PAGE_MASK));
+	memset(&vm->uv, 0, sizeof(vm->uv));
+
+	/* Convert the sblk back to non-PV */
+	vm->save_area.guest.asce = stctg(1);
+	vm->sblk->sdf = 0;
+	vm->sblk->sidad = 0;
+	vm->sblk->pv_handle_cpu = 0;
+	vm->sblk->pv_handle_config = 0;
 }
 
 int uv_unpack(struct vm *vm, uint64_t addr, uint64_t len, uint64_t tweak)
-- 
2.34.1


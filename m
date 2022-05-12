Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8911E52490E
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352038AbiELJfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352022AbiELJfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4987A69B6B
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:36 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9COaH026688
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=abxldnYww3B0DNMwBpdDTac8ezRaALrnES7naUKLALU=;
 b=XTrR2t+viu6IwlJ61j7qhLk4XwjJlXFVAjiFymmVKRoEUGHiL/MtgvaZYYSEyVHZ1Hxr
 9O/Gni05m8GVKrimuWlawGwaW+70TdLiAGN3tbKbSuaoZfG/PLAB+G4Uc8auJYOyXrbd
 VycpDcDyrAqPGs3BjIfqtgdqcyaFif+izvYMQraVxkN2vohCa/hgFmVBteQmVCSHrjk/
 AsSEZeP4ROCgkv+9PsGfL5sbW5fVxuOM8FyMbBOlYgC7V+/b0j3ouXSFDP6D+IpVe3hx
 DH8hNbmo8fhTQ6Z+GwpceMp+WhFhsVcIrvbi8ui3DDUnZb083C+27n64McPZ5nZqjvEg 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yd50dy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:35 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9NJpm031534
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:35 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yd50dx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:35 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9WfYo020396;
        Thu, 12 May 2022 09:35:33 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3fwgd8xs93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:32 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZTVs50069958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB5A311C04C;
        Thu, 12 May 2022 09:35:29 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6128011C052;
        Thu, 12 May 2022 09:35:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:29 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 03/28] s390x: epsw: fix report_pop_prefix() when running under non-QEMU
Date:   Thu, 12 May 2022 11:34:58 +0200
Message-Id: <20220512093523.36132-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Sp0SeoQcnEUUBPhwhbTE2EdSP4grtftG
X-Proofpoint-ORIG-GUID: XJ0N62nAgvu-Y6nuE0eGBXVqh6LqHVDt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

When we don't run in QEMU, we didn't push a prefix, hence pop won't work. Fix
this by pushing the prefix before the QEMU check.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/epsw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/epsw.c b/s390x/epsw.c
index 5b73f4b3..d8090d95 100644
--- a/s390x/epsw.c
+++ b/s390x/epsw.c
@@ -97,13 +97,13 @@ static void test_epsw(void)
 
 int main(int argc, char **argv)
 {
+	report_prefix_push("epsw");
+
 	if (!host_is_kvm() && !host_is_tcg()) {
 		report_skip("Not running under QEMU");
 		goto done;
 	}
 
-	report_prefix_push("epsw");
-
 	test_epsw();
 
 done:
-- 
2.36.1


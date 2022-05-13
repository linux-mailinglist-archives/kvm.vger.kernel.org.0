Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFEDD525EE6
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 12:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379162AbiEMJvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379152AbiEMJvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:51:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49D65716C;
        Fri, 13 May 2022 02:51:46 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D9kp38013194;
        Fri, 13 May 2022 09:51:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=0T3S6tRbon+PM9LAc9WxUO+kRlwzPPR9f7pIzMW6g+Q=;
 b=ECzPykqdTFnpf9IVgrAq7dq7BM2FbHc689dBVZ4wqOuswkng1Q7jipTO55eDByQegakE
 JEgnRDkVQ9/f0YrY1QTwk3uJUIgoRQi/SQILipAfSoXjbseOsColJEnGKqro7gJRhw3M
 q663MduFTduJj1nkoaBOu9nKgWomHvadYJcUYAoHLUE/hxVXwMicfV21v2TerGTz0eE7
 m8UN/2mrOMuhz2fmzZwXH//oOAdcccwREYsTfRMDcE1jOUbtjkIPGi1KCjM00SOCaeNO
 ZDegceqKasNr5eBuB/N79dqbPhl7t3FyIMZAyWKM32MDxzfUB45sIYwU4+OpR2fCQwmW 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1n0h02pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:46 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24D9oFlW025765;
        Fri, 13 May 2022 09:51:46 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1n0h02nx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:45 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24D9TI3L017591;
        Fri, 13 May 2022 09:51:43 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3fwgd8xhrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24D9peno32178668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 09:51:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DEDF4C04E;
        Fri, 13 May 2022 09:51:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E50F4C044;
        Fri, 13 May 2022 09:51:39 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 09:51:39 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/6] s390x: uv-host: Access check extensions and improvements
Date:   Fri, 13 May 2022 09:50:11 +0000
Message-Id: <20220513095017.16301-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oy8bl5zVctakl3cFlQVsnoM24lZMGohA
X-Proofpoint-ORIG-GUID: jR0mSd3mGgjQnJdU0qpbPAaWHuvCbPNT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 impostorscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 mlxlogscore=830 priorityscore=1501 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205130041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Over the last few weeks I had a few ideas on how to extend the uv-host
test to get more coverage. Most checks are access checks for secure
pages or the UVCB and it's satellites.

I've had limited time to cleanup this series, so consider having a
closer look.

Janosch Frank (6):
  s390x: uv-host: Add access checks for donated memory
  s390x: uv-host: Add uninitialized UV tests
  s390x: uv-host: Test uv immediate parameter
  s390x: uv-host: Add access exception test
  s390x: uv-host: Add a set secure config parameters test function
  s390x: uv-host: Remove duplicated +

 s390x/uv-host.c | 244 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 239 insertions(+), 5 deletions(-)

-- 
2.34.1


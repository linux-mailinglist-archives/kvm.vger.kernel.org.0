Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE40E4E9158
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 11:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239821AbiC1Jck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 05:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236717AbiC1Jci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 05:32:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068B2541A7;
        Mon, 28 Mar 2022 02:30:57 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22S7YfOh027417;
        Mon, 28 Mar 2022 09:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8LW8RjpWwJvhZs9Jo0ks/Klx230WLW8o3ETNwBJMTgI=;
 b=HbvEn1Hs7WQtTzpxSwpxeEtk8yK8F5b1MoG4wr1f4UadFMAH86TyhrmY7kuFrfVTL8yP
 ZbX9rQlWuEu7255QqyxUplaKpYLmRCwFgOxVY2BvhTY8fMMJe9oQeN+58PgzLr8RCn02
 tWgnoaYfChRjBlWx8EUQzX5VwOjXjnc8sxlzPBbWZmGBWsf/oU51tm+FUa1CMz6s8xp8
 9lXo9KdQrkCF9gSi40JpxkiLR5D6jTwXry1l8VecGhutiObIy/MRwq1T8WPIIkqJgw87
 IenwLiTmmvxp46VSThy4JiMMKrDPDO9ICAJepRsUcqFX6gLOYtmGG2DAkIdy2GKbF08u 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f2cghpb8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 09:30:57 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22S98qTv003052;
        Mon, 28 Mar 2022 09:30:56 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f2cghpb7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 09:30:56 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22S9HRAJ003306;
        Mon, 28 Mar 2022 09:30:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3f1t3hu393-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 09:30:52 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22S9UrQD45941192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 09:30:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A03A9A405F;
        Mon, 28 Mar 2022 09:30:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51794A4054;
        Mon, 28 Mar 2022 09:30:48 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Mar 2022 09:30:48 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [PATCH 0/2] s390x: Add tests for SIGP store adtl status
Date:   Mon, 28 Mar 2022 11:30:46 +0200
Message-Id: <20220328093048.869830-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7MgcBx2BUDs8FhLo5ZqK1tIFuPWJkMjT
X-Proofpoint-ORIG-GUID: H3xRgudgi3DtTlyiSfZezFwywxDulO7n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_03,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 malwarescore=0 adultscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=789 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As suggested by Claudio, move the store adtl status I sent previously
("[kvm-unit-tests PATCH v2 0/9] s390x: Further extend instruction interception
 tests") into its own file.

Nico Boehr (2):
  s390x: gs: move to new header file
  s390x: add test for SIGP STORE_ADTL_STATUS order

 lib/s390x/gs.h      |  69 ++++++++
 s390x/Makefile      |   1 +
 s390x/adtl_status.c | 407 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/gs.c          |  54 +-----
 s390x/unittests.cfg |  25 +++
 5 files changed, 503 insertions(+), 53 deletions(-)
 create mode 100644 lib/s390x/gs.h
 create mode 100644 s390x/adtl_status.c

-- 
2.31.1


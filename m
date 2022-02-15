Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E5F4B69A1
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 11:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236659AbiBOKoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 05:44:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236656AbiBOKog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 05:44:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAF5AFF6D;
        Tue, 15 Feb 2022 02:44:27 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F9koSq030804;
        Tue, 15 Feb 2022 10:44:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ApbsUm8LyiDcrYV2wCG5TSa6MePfAKjm2G880xZijoM=;
 b=OK/zqhu9Qyu5yOP35tYMvURNm4mmPkoRw5WCSQ0V492AN/x5CLOkqU+qxaFKXQOgh3aa
 6OEJmFS100dgM/QtNyHry8Qf/TeD4vZ4eUCg4xGvKH1yTYyUL5OOmXv0SZLeC23VuvMm
 f66E9CHNzbYNqxd1sClJfyu5q1ctC2fEKQ39Qfz9lXkf09gMxkp0SJ86jHNNUS4DQPnS
 Xg5jUfPVGaEWlXjabcIT6RKHTtR2pzYdox6gqlQILXI/MAFboPAqr2+80MCmgqCw0/1P
 ywG1FyNt+hReuJb1arBGsWa553U8/JZuzK9P+lg6POnw5sMjZ+laWGmUCxijZZIjlFKg DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e89uased3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 10:44:26 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FAiQd3024351;
        Tue, 15 Feb 2022 10:44:26 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e89uasecn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 10:44:26 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FAgQJD006226;
        Tue, 15 Feb 2022 10:44:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645jp67y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 10:44:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21FAiKGY38666580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 10:44:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B41F242041;
        Tue, 15 Feb 2022 10:44:20 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D5C942045;
        Tue, 15 Feb 2022 10:44:20 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.31.140])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 10:44:20 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/1] s390x: stsi: Define vm_is_kvm to be used in different tests
Date:   Tue, 15 Feb 2022 11:46:31 +0100
Message-Id: <20220215104632.47796-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2YjdB0l4sCgv71Dh8AqJdYVAxClUOEuk
X-Proofpoint-ORIG-GUID: jqTZY5aLOFKsbcK3zm-tajm6RfS5hncS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_03,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 clxscore=1015 suspectscore=0 spamscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 impostorscore=0
 mlxlogscore=521 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Several tests are in need of a way to check on which hypervisor
and virtualization level they are running on to be able to fence
certain tests. This patch adds functions that return true if a
vm is running under KVM, LPAR or generally as a level 2 guest.
 
To check if we're running under KVM we use the STSI 3.2.2
instruction, let's define it's response structure in a central
header.

Pierre Morel (1):
  s390x: stsi: Define vm_is_kvm to be used in different tests

 lib/s390x/stsi.h | 32 ++++++++++++++++++++++++++++
 lib/s390x/vm.c   | 55 ++++++++++++++++++++++++++++++++++++++++++++++--
 lib/s390x/vm.h   |  3 +++
 s390x/stsi.c     | 23 ++------------------
 4 files changed, 90 insertions(+), 23 deletions(-)
 create mode 100644 lib/s390x/stsi.h

-- 
2.27.0


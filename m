Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F052460B630
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 20:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbiJXSuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 14:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiJXSuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 14:50:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7911181A;
        Mon, 24 Oct 2022 10:30:53 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OE7KB0017402;
        Mon, 24 Oct 2022 14:20:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=pbxnAhFCDpff1GUxMHUF6fZP5VjICHD6HXq0aRQWBtc=;
 b=mT86c87DYfVopxMFxgAZBi9V4ZIzWr09zPq7SQ848Ok4J8DTS0lPU6NXTCT3IG7xyJK+
 Xtl/gwzuqXZlUTNC0tNmLYDJTzlcyawV0yYZT6eIiWNeb/9a+8I/KkWW3UHb61utnWrE
 go47aq9U/BYo7EQpyIgXDElXbwsPQJxeyoGWa/eYhICkCFQr2fXGFFZrcMqkXEz0f0lc
 m37Gs6xkeachmP2uZUeyzKv2l7gyhcKLt2uxNMafBFKj+h6o+ORMHFx5HoYLvhOFP2B6
 uCW7ia88b2GGY0KN8g/Tg5MGaQ9vXsfE9plAsOnXWJseUdoKG7g0SEHoP2erqFdHrcvB Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kduu7s6xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 14:20:42 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29OE91gG027532;
        Mon, 24 Oct 2022 14:20:42 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kduu7s6wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 14:20:41 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29OE5cfi018375;
        Mon, 24 Oct 2022 14:20:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3kc859bf1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 14:20:40 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29OEKbil41353512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 14:20:37 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D02352050;
        Mon, 24 Oct 2022 14:20:37 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.20.45])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 858695204E;
        Mon, 24 Oct 2022 14:20:36 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 0/2] S390x: CPU Topology Information
Date:   Mon, 24 Oct 2022 16:20:33 +0200
Message-Id: <20221024142035.22668-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zAYTRceIOoHi3yTa0UauDJIf93pFdf8u
X-Proofpoint-ORIG-GUID: ei4aMkU1mh5oRO2wU64sYxqOPoANjjJ-
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 clxscore=1011 phishscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

new version of the series with corrections.

When facility 11 is available inside the S390x architecture, 2 new
instructions are available: PTF and STSI with function code 15.

Let's check their availability in QEMU/KVM and their coherence
with the CPU topology provided to the QEMU -smp parameter and as
argument for the test.

To run these tests successfully you will Linux 6.0 and the following
QEMU patches (or newer):

  https://lore.kernel.org/all/20221012162107.91734-1-pmorel@linux.ibm.com/#r


To start the test just do:

# ./run_tests.sh topology

or

# ./s390x-run s390x/topology.elf \
	-smp 5,sockets=4,cores=4,maxcpus=16 \
	-append "-mnest 2 -sockets 4 -cores 4"


Of course the declaration of the number of socket and core must be
coherent in -smp and -append arguments.
The "mnest" argument represent the expected nesting level it will be
2 until books and drawer are added to the topology.

Regards,
Pierre

Pierre Morel (2):
  s390x: topology: Check the Perform Topology Function
  s390x: topology: Checking Configuration Topology Information

 lib/s390x/stsi.h    |  44 ++++++
 s390x/Makefile      |   1 +
 s390x/topology.c    | 366 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 4 files changed, 415 insertions(+)
 create mode 100644 s390x/topology.c

-- 
2.31.1

Changelog:

From v4:

- Simplify the tests for socket and cores only.


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D58D6F44BE
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 15:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbjEBNKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 09:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbjEBNJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 09:09:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1570B618F;
        Tue,  2 May 2023 06:09:48 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342D8pTU018242;
        Tue, 2 May 2023 13:09:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=zgYCQGhJ3D/uRnubUPsSK2kU6b67i4hquUMSShegPoQ=;
 b=leHJITyvuqUM++EHdeZmZB0I6Nbz2ZHptrZ7pBJ6sq0cOj2LlDNadEjFVZAJs87strnO
 Xf5d8aOz+CzZCmUXAsIe1Lf6LNC05tOGieND58DX0rn/Daoy+SjXkEqu2C0ggEoB8Prk
 V/mlEDlkkcxO4ARDVr7hpmF0vIRjMlI0YzNyWiXmdXPG4fqLebH5UVmnoQioMlqFjWK2
 oxbfDauAY4JZFNPIVs3YpFQgiITLK7lB3Ca1oc6hEUKVBwU4gAarTfaktBscoE/oAYUj
 iV8AvjujNeppCgg2AtzyVlEsj6MUBtNjwA+TwvLFLnODd3pOpoz0OZv35QMCI0qDTTFJ RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2xv8bvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:46 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342D948w021249;
        Tue, 2 May 2023 13:09:35 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2xv8b55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:35 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 342C8ksS027329;
        Tue, 2 May 2023 13:09:22 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6saka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:21 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342D9IBn43254298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 13:09:18 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43F8C2004D;
        Tue,  2 May 2023 13:09:18 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73F1120040;
        Tue,  2 May 2023 13:09:17 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 13:09:17 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/9] s390x: uv-host: Fixups and extensions part 1
Date:   Tue,  2 May 2023 13:07:23 +0000
Message-Id: <20230502130732.147210-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: npTsAYHB2l_TR0dXzUsmmmO6nmGWvsjM
X-Proofpoint-ORIG-GUID: ehCh25XX_mBvm1McumCZ12cCcUXmaJZK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The uv-host test has a lot of historical growth problems which have
largely been overlooked since running it is harder than running a KVM
(guest 2) based test.

This series fixes up smaller problems but still leaves the test with
fails when running create config base and variable storage
tests. Those problems will either be fixed up with the second series
or with a firmware fix since I'm unsure on which side of the os/fw
fence the problem exists.

The series is based on my other series that introduces pv-ipl and
pv-icpt. The memory allocation fix will be added to the new version of
that series so all G1 tests are fixed.

v3:
	- Re-based on the ipl/icpt series
	- Added review-bys

v2:
	- Added patch that exchanges sigp_retry with the smp variant
	- Re-worked the create config test handling
	- Minor fixups

Janosch Frank (9):
  s390x: uv-host: Fix UV init test memory allocation
  s390x: uv-host: Check for sufficient amount of memory
  s390x: uv-host: Beautify code
  s390x: uv-host: Add cpu number check
  s390x: uv-host: Fix create guest variable storage prefix check
  s390x: uv-host: Switch to smp_sigp
  s390x: uv-host: Properly handle config creation errors
  s390x: uv-host: Fence access checks when UV debug is enabled
  s390x: uv-host: Add the test to unittests.conf

 lib/s390x/asm/uv.h  |   1 +
 s390x/unittests.cfg |   5 ++
 s390x/uv-host.c     | 137 ++++++++++++++++++++++++++++++++++----------
 3 files changed, 114 insertions(+), 29 deletions(-)

-- 
2.34.1


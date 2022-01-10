Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AF5489A0E
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 14:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbiAJNg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 08:36:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55320 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232627AbiAJNg2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 08:36:28 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AChdYw018734;
        Mon, 10 Jan 2022 13:36:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=BH1QB72H62lbVTUPX+CV1u7MpSiiBwN6o/40gDPnTDs=;
 b=iGYzWdtD9TeIxpHdXd/SigmyHpVd6qK4YZWDJPw0Shccj2MH1iz3gys3MmQkqbE/MbdU
 uQ/d6b1RBnGWZ+Z6vKiS84UgUZj7HOzu7x24XF0IrcCQOtWHANX574xvnM4XKiShjJEK
 rZ7UU6z+zdL3TuFU+9v7oh48XI+tBOYhPqkG71Q5DvQqUrM4GeokxGBV6yqrxQmykpS4
 4/A41XUIqbKpXkSHa0Gu7Fdmto5QjzYe62Fxy8eJZoH4/Ly5MYxJA+Dh4Jc0Yu66dbi2
 46rTX3RpIMGYAeXFWOpVjR5qmRbPySYcBXI6Dxfcac8xfHSSOuv0fx2TSpYRgdBp0b0m 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dgn261eft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 13:36:27 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20AD7H8r010159;
        Mon, 10 Jan 2022 13:36:27 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dgn261eer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 13:36:27 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ADW5eS022579;
        Mon, 10 Jan 2022 13:36:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3df2894jhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 13:36:24 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ADRMgU35127558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 13:27:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C8D3420A2;
        Mon, 10 Jan 2022 13:36:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C97D3420FC;
        Mon, 10 Jan 2022 13:36:20 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.85.190])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Jan 2022 13:36:20 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/4] S390x: CPU Topology Information
Date:   Mon, 10 Jan 2022 14:37:51 +0100
Message-Id: <20220110133755.22238-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f6YRmsTVorcPCQJstANVQSBhHpxXf1cz
X-Proofpoint-ORIG-GUID: BYxP7UJnykFsJ-thkodgBJf-uGQp-6fW
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_05,2022-01-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 phishscore=0 mlxscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100095
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

To run these tests successfully you will need both the Linux and the
QEMU patches, at least the following or newer patches:

    https://lkml.org/lkml/2021/8/3/201

    https://lists.nongnu.org/archive/html/qemu-s390x/2021-07/msg00165.html

Then if you have the text you can run directly the unit test or directly
start QEMU with:

# ./s390x-run s390x/topology.elf \
	-smp 5,drawers=2,books=3,sockets=4,cores=4,maxcpus=96 \
	-append "-d 2 -b 3 -s 4 -c 4 -m 96"

If you do not have the patches you can still use the test but only with
the first two topology levels like in:

# ./s390x-run s390x/topology.elf \
	-smp 5,sockets=24,cores=4,maxcpus=96 \
	-append "-s 24 -c 4 -m 96"

Of course the declaration of the number of socket and core must be
coherent.

Regards,
Pierre

Pierre Morel (4):
  s390x: lib: Add SCLP toplogy nested level
  s390x: stsi: Define vm_is_kvm to be used in different tests
  s390x: topology: Check the Perform Topology Function
  s390x: topology: Checking Configuration Topology Information

 lib/s390x/sclp.c    |   6 +
 lib/s390x/sclp.h    |   4 +-
 lib/s390x/stsi.h    |  76 ++++++++++
 lib/s390x/vm.c      |  39 +++++
 lib/s390x/vm.h      |   1 +
 s390x/Makefile      |   1 +
 s390x/stsi.c        |  23 +--
 s390x/topology.c    | 346 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 9 files changed, 478 insertions(+), 22 deletions(-)
 create mode 100644 lib/s390x/stsi.h
 create mode 100644 s390x/topology.c

-- 
2.27.0

Changelog:

From V2:

- Check if the test in running in KVM
  (Janosch)

- patch on "Simplify stsi_get_fc and move it to library"
  pushed separatly

- replace named level with abstracted topology levels
  to get rid of a possible naming controversy
  (Pierre)

- Better checks and new checks for STSI(15,1,x)
  (Pierre)

From V1:

- Simplify the stsi_get_fc function when pushing it into lib
  (Janosch)

- Simplify PTF inline assembly as PTF instruction does not use RRE
  second argument
  (Claudio)

- Rename Test global name
  (Claudio, Janosch)

- readibility, naming for PTF_REQ_* and removed unused globals
  (Janosch)

- skipping tests which could fail when run on LPAR
  (Janosh)

- Missing prefix_pop
  (Janosch)


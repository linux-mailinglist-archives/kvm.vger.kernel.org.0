Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A714AD9D2
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349368AbiBHN3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358064AbiBHN24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 08:28:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DCCC02B665;
        Tue,  8 Feb 2022 05:25:12 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218DCddd029359;
        Tue, 8 Feb 2022 13:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=D3GbL50TVz9q796RLZrtHRfbtH92hRGYQCG+FCaq6v0=;
 b=FKYzK5dIkblMrxA24qT372dSgfPGKTEydvjCAwFO7QZf41jOviLqNcpWYhatgOC0GRkp
 tLEolsuaT1PfeIbKzy8Jyyu6R/AZxrLXS7HY+/N/aS8k/XaxKy6LvPBIEPC8NZZD8TIT
 HsAjntcDVtVUjq6Wp3jkXWarAizbXOlS8gw/yN3p7tTHlvvqbn5HcBQ2My4LkUHtorgv
 anxQqmpGQsw5f0Wgv0b567NFTKLLHvGJCWxZYFgjsbgIczfAwj5fNqEGLUcTOZxo3BiL
 OYRdxGk6RzTPqg9vnlApm4domWQTWc5x+0nuoQPJllN9YsJxmNuas6QAyVENQuxNl+Qr Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e355b26ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:25:11 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218DPBuB020906;
        Tue, 8 Feb 2022 13:25:11 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e355b26jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:25:11 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218DEOUA014541;
        Tue, 8 Feb 2022 13:25:09 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3e1gv9ctr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:25:08 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218DF0uA49611070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 13:15:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D7BB42049;
        Tue,  8 Feb 2022 13:25:05 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38A9A42041;
        Tue,  8 Feb 2022 13:25:05 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.71.76])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 13:25:05 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 0/4] S390x: CPU Topology Information
Date:   Tue,  8 Feb 2022 14:27:05 +0100
Message-Id: <20220208132709.48291-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UinvRcj9ME5sFhw4ciac6tB27k2DxSfS
X-Proofpoint-ORIG-GUID: VyIzCKCDfvS_E59hC2S2Ejb0okzjXJ86
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_04,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 lib/s390x/vm.c      |  56 ++++++-
 lib/s390x/vm.h      |   3 +
 s390x/Makefile      |   1 +
 s390x/stsi.c        |  23 +--
 s390x/topology.c    | 346 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 9 files changed, 495 insertions(+), 24 deletions(-)
 create mode 100644 lib/s390x/stsi.h
 create mode 100644 s390x/topology.c

-- 
2.27.0

Changelog:

From V2:

- Copyrights modifications, assert for allocation failures
  (Claudio)

- adding a vm_is_lpar and modification of vm_is_kvm
  (Janosh)

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


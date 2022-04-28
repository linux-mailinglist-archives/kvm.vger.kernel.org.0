Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D255951347B
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 15:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346811AbiD1NI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 09:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346769AbiD1NIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 09:08:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2F38564D;
        Thu, 28 Apr 2022 06:05:34 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SALMDt002684;
        Thu, 28 Apr 2022 13:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4oXQuczTVcRie5064M9i6bQG8VDeosLW41vaBGG2Djc=;
 b=e5pUB0eaAVmr/cZH1FL8ECSNCNNBPo218Y4JIztUpggS6+UCWpxTOm8xc07+l7k3oqsQ
 bdozEqfCU8S9oYrErENmqDOeJnXzF26ZMOuJnLXdGYeIydcCG6iDWFdgO8ne7nKOjCbe
 qC/jsV0LmV3U+mbAfU7p2r3IzNGisyHSx2bUGS7XJv919IGUHipqa/G1Fbug+nKBZB05
 60N5CI16EuY6k6Zd7VaXCSETJD9h5xrTWUtvvaed+nWDFaqeJLphmW3Jo2CCVqYIGyli
 tf/9biurp4CWjw6uUlw50NwiW3/efmxKmBXhc+AZR6SRxHiePGvr/gMPXoMTwGhYdqrJ PQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqs3muemv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 13:05:34 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23SCwkaf002024;
        Thu, 28 Apr 2022 13:05:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3fm938ygyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 13:05:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23SCqMCj52232684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 12:52:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8046A42042;
        Thu, 28 Apr 2022 13:05:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0356F42041;
        Thu, 28 Apr 2022 13:05:28 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Apr 2022 13:05:27 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH 0/9] kvm: s390: Add PV dump support
Date:   Thu, 28 Apr 2022 13:00:53 +0000
Message-Id: <20220428130102.230790-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x7hsUYoAfVL8sQNtm5OfRmCPxumfwUDO
X-Proofpoint-ORIG-GUID: x7hsUYoAfVL8sQNtm5OfRmCPxumfwUDO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_01,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=620
 suspectscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sometimes dumping inside of a VM fails, is unavailable or doesn't
yield the required data. For these occasions we dump the VM from the
outside, writing memory and cpu data to a file.

Up to now PV guests only supported dumping from the inside of the
guest through dumpers like KDUMP. A PV guest can be dumped from the
hypervisor but the data will be stale and / or encrypted.

To get the actual state of the PV VM we need the help of the
Ultravisor who safeguards the VM state. New UV calls have been added
to initialize the dump, dump storage state data, dump cpu data and
complete the dump process.

I chose not to document the dump data provided by the Ultravisor since
KVM doesn't interprete it in any way. We're currently searching for a
location and enough cycles to make it available to all.

v4:
	* Rebased and fixed up conflicts due to the Documentation
          changes and new KVM capabilities
	* Fixed the dump facility check, now we check for all 4 calls

v3:
	* Added Rev-by
	* Renamed the query function's len variables to len_min

v2:
	* Added vcpu SIE blocking to avoid validities
	* Moved the KVM CAP to patch #7
	* Renamed len to len_max and introduced len_written for extendability
	* Added Rev-bys


Janosch Frank (9):
  s390x: Add SE hdr query information
  s390: uv: Add dump fields to query
  KVM: s390: pv: Add query interface
  KVM: s390: pv: Add dump support definitions
  KVM: s390: pv: Add query dump information
  kvm: s390: Add configuration dump functionality
  kvm: s390: Add CPU dump functionality
  Documentation: virt: Protected virtual machine dumps
  Documentation/virt/kvm/api.rst: Add protvirt dump/info api
    descriptions

 Documentation/virt/kvm/api.rst               | 152 ++++++++-
 Documentation/virt/kvm/s390/index.rst        |   1 +
 Documentation/virt/kvm/s390/s390-pv-dump.rst |  60 ++++
 arch/s390/boot/uv.c                          |   4 +
 arch/s390/include/asm/kvm_host.h             |   1 +
 arch/s390/include/asm/uv.h                   |  45 ++-
 arch/s390/kernel/uv.c                        |  53 ++++
 arch/s390/kvm/kvm-s390.c                     | 306 +++++++++++++++++++
 arch/s390/kvm/kvm-s390.h                     |   3 +
 arch/s390/kvm/pv.c                           | 131 ++++++++
 include/uapi/linux/kvm.h                     |  55 ++++
 11 files changed, 808 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390/s390-pv-dump.rst

-- 
2.32.0


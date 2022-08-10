Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA21058EC6A
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 14:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbiHJM4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 08:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbiHJM4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 08:56:34 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296995C349;
        Wed, 10 Aug 2022 05:56:33 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27ACphew008935;
        Wed, 10 Aug 2022 12:56:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=5t3uckrmX8TZOE2AADmHK/r+GKcm/h3E7WUWVoXfxSw=;
 b=bLP0uM2K/8K4aENzTRKDGr/BwAzoLcUCDgpMsF+VpTkN7dWCarMfFlMgwC/cNC5z7vRv
 AK8VT0ZSS1C1DGJPbBR1bWv+MyfWmnXYTzxr8GT+3Y+Yod/grvf2Buvfo9dQiWTtRg0W
 lQ3W8puQDWCjX2hNKeEG9jhsDkLdMBytCbw6/+Zw5teJVJZ833AzTNsaFEH1RqLcbQMY
 WwA2pgOzwG6pOjWNAs6ToS/xlMNGuHXbZJkFQn6RgVgFdKGNebowkMiVSEGm4/X6Fkhw
 P4BIG6v0tQKAVbeFBA3AsoDZKOaj4SunKJTVCRyoOHKabQyHisUcsIYmZariU/OA+C7c TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv5r6e301-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:56:32 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27ACphGs008926;
        Wed, 10 Aug 2022 12:56:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv5r6e2y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:56:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27ACqK1m013616;
        Wed, 10 Aug 2022 12:56:29 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3huww2guge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:56:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27ACuQ3n20513218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 12:56:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94EBF4C04E;
        Wed, 10 Aug 2022 12:56:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC76B4C040;
        Wed, 10 Aug 2022 12:56:25 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.0.105])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 12:56:25 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v13 0/6] KVM: s390: pv: implement lazy destroy for reboot
Date:   Wed, 10 Aug 2022 14:56:19 +0200
Message-Id: <20220810125625.45295-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _1C-6yW8c1OEFvRSLCTIkC3QhsuufEpO
X-Proofpoint-ORIG-GUID: kBMtHPlgZSWQDuGt6yC4WQp3s8LI-r9F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_07,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 spamscore=0 phishscore=0
 mlxlogscore=857 suspectscore=0 lowpriorityscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, when a protected VM was rebooted or when it was shut down,
its memory was made unprotected, and then the protected VM itself was
destroyed. Looping over the whole address space can take some time,
considering the overhead of the various Ultravisor Calls (UVCs). This
means that a reboot or a shutdown would take a potentially long amount
of time, depending on the amount of used memory.

This patchseries implements a deferred destroy mechanism for protected
guests. When a protected guest is destroyed, its memory can be cleared
in background, allowing the guest to restart or terminate significantly
faster than before.

There are 2 possibilities when a protected VM is torn down:
* it still has an address space associated (reboot case)
* it does not have an address space anymore (shutdown case)

For the reboot case, two new commands are available for the
KVM_S390_PV_COMMAND:

KVM_PV_ASYNC_CLEANUP_PREPARE: prepares the current protected VM for
asynchronous teardown. The current VM will then continue immediately
as non-protected. If a protected VM had already been set aside without
starting the teardown process, this call will fail. In this case the
userspace process should issue a normal KVM_PV_DISABLE

KVM_PV_ASYNC_CLEANUP_PERFORM: tears down the protected VM previously
set aside for asychronous teardown. This PV command should ideally be
issued by userspace from a separate thread. If a fatal signal is
received (or the process terminates naturally), the command will
terminate immediately without completing. The rest of the normal KVM
teardown process will take care of properly cleaning up all leftovers.

The idea is that userspace should first issue the
KVM_PV_ASYNC_CLEANUP_PREPARE command, and in case of success, create a
new thread and issue KVM_PV_ASYNC_CLEANUP_PERFORM from there. This also
allows for proper accounting of the CPU time needed for the
asynchronous teardown.

This means that the same address space can have memory belonging to
more than one protected guest, although only one will be running, the
others will in fact not even have any CPUs.

The shutdown case should be dealt with in userspace (e.g. using
clone(CLONE_VM)).

A module parameter is also provided to disable the new functionality,
which is otherwise enabled by default. This should not be an issue
since the new functionality is opt-in anyway. This is mainly thought to
aid debugging.

v12->v13
* drop the patches that have been already merged
* rebase

Claudio Imbrenda (6):
  KVM: s390: pv: asynchronous destroy for reboot
  KVM: s390: pv: api documentation for asynchronous destroy
  KVM: s390: pv: add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
  KVM: s390: pv: avoid export before import if possible
  KVM: s390: pv: support for Destroy fast UVC
  KVM: s390: pv: module parameter to fence asynchronous destroy

 Documentation/virt/kvm/api.rst   |  30 ++-
 arch/s390/include/asm/kvm_host.h |   2 +
 arch/s390/include/asm/uv.h       |  10 +
 arch/s390/kernel/uv.c            |   2 +
 arch/s390/kvm/kvm-s390.c         |  55 ++++-
 arch/s390/kvm/kvm-s390.h         |   3 +
 arch/s390/kvm/pv.c               | 331 ++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h         |   3 +
 8 files changed, 416 insertions(+), 20 deletions(-)

-- 
2.37.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E3846C68A
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241737AbhLGVU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:20:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10348 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241698AbhLGVU1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:20:27 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JejWx031821;
        Tue, 7 Dec 2021 21:16:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=D9wP2qvugE6CCBUq5ZY/+dUBvsvOLLvvgSgIvPhnYs4=;
 b=cu1M6EPt5isErPo1cDqe0BlTfO/tvMpJY0KrgYzSo7vGDK31lF9Fq8c1Hu6rYjiInPin
 bdjGUO9drlQsuwu1+gyzrGnaOGAfVJy86IPEfEHqPFCOMcgABHPqp6QKgnTI2rUFIiCA
 HwkDNEOvmvffubnn0iNqX4ftQCNhp+f3dxnTxOseWKSvqUI6XKBSvv9B9SJtcEKL867v
 qLNn5CmYZYCcE0HThtC5pWhmzf+Q8d+29iANQYRsLvRKI/blZGvtzKam6YxP9udBo/xI
 utT+wJ0iR53SKxoWZQdzbfouC04djoJa8/veNaGtBTHbxyahQ370kj2TdM/kiEIXjp9u jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctcdbuu84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:16:55 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7Kk96T008960;
        Tue, 7 Dec 2021 21:16:55 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctcdbuu7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:16:55 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7LBnii012782;
        Tue, 7 Dec 2021 21:16:54 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 3cqyyc3g0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:16:54 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7LGqYU19792508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 21:16:52 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10183112070;
        Tue,  7 Dec 2021 21:16:52 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F09911206B;
        Tue,  7 Dec 2021 21:16:47 +0000 (GMT)
Received: from [9.211.152.43] (unknown [9.211.152.43])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 21:16:47 +0000 (GMT)
Message-ID: <6041f49f-08f9-5cb6-0bc9-070f80f3284f@linux.ibm.com>
Date:   Tue, 7 Dec 2021 16:16:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 00/32] KVM: s390: enable zPCI for interpretive execution
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y4j5AyTfMakPcYfMLjCZG3jhq8fZNAG9
X-Proofpoint-ORIG-GUID: zdE7gC4WwjNK-YvcL9teKJ5eYU0fgkK4
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=904 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/21 3:57 PM, Matthew Rosato wrote:
> Enable interpretive execution of zPCI instructions + adapter interruption
> forwarding for s390x KVM vfio-pci.  This is done by introducing a series
> of new vfio-pci feature ioctls that are unique vfio-pci-zdev (s390x) and
> are used to negotiate the various aspects of zPCI interpretation setup.
> By allowing intepretation of zPCI instructions and firmware delivery of
> interrupts to guests, we can significantly reduce the frequency of guest
> SIE exits for zPCI.  We then see additional gains by handling a hot-path
> instruction that can still intercept to the hypervisor (RPCIT) directly
> in kvm.
> 
>  From the perspective of guest configuration, you passthrough zPCI devices
> in the same manner as before, with intepretation support being used by
> default if available in kernel+qemu.
> 
> Will reply with a link to the associated QEMU series.

https://lists.gnu.org/archive/html/qemu-devel/2021-12/msg00873.html

> 
> Matthew Rosato (32):
>    s390/sclp: detect the zPCI interpretation facility
>    s390/sclp: detect the AISII facility
>    s390/sclp: detect the AENI facility
>    s390/sclp: detect the AISI facility
>    s390/airq: pass more TPI info to airq handlers
>    s390/airq: allow for airq structure that uses an input vector
>    s390/pci: externalize the SIC operation controls and routine
>    s390/pci: stash associated GISA designation
>    s390/pci: export some routines related to RPCIT processing
>    s390/pci: stash dtsm and maxstbl
>    s390/pci: add helper function to find device by handle
>    s390/pci: get SHM information from list pci
>    KVM: s390: pci: add basic kvm_zdev structure
>    KVM: s390: pci: do initial setup for AEN interpretation
>    KVM: s390: pci: enable host forwarding of Adapter Event Notifications
>    KVM: s390: expose the guest zPCI interpretation facility
>    KVM: s390: expose the guest Adapter Interruption Source ID facility
>    KVM: s390: expose guest Adapter Event Notification Interpretation
>      facility
>    KVM: s390: mechanism to enable guest zPCI Interpretation
>    KVM: s390: pci: provide routines for enabling/disabling interpretation
>    KVM: s390: pci: provide routines for enabling/disabling interrupt
>      forwarding
>    KVM: s390: pci: provide routines for enabling/disabling IOAT assist
>    KVM: s390: pci: handle refresh of PCI translations
>    KVM: s390: intercept the rpcit instruction
>    vfio/pci: re-introduce CONFIG_VFIO_PCI_ZDEV
>    vfio-pci/zdev: wire up group notifier
>    vfio-pci/zdev: wire up zPCI interpretive execution support
>    vfio-pci/zdev: wire up zPCI adapter interrupt forwarding support
>    vfio-pci/zdev: wire up zPCI IOAT assist support
>    vfio-pci/zdev: add DTSM to clp group capability
>    KVM: s390: introduce CPU feature for zPCI Interpretation
>    MAINTAINERS: additional files related kvm s390 pci passthrough
> 
>   MAINTAINERS                      |   2 +
>   arch/s390/include/asm/airq.h     |   7 +-
>   arch/s390/include/asm/kvm_host.h |   5 +
>   arch/s390/include/asm/kvm_pci.h  |  62 +++
>   arch/s390/include/asm/pci.h      |  13 +
>   arch/s390/include/asm/pci_clp.h  |  11 +-
>   arch/s390/include/asm/pci_dma.h  |   3 +
>   arch/s390/include/asm/pci_insn.h |  29 +-
>   arch/s390/include/asm/sclp.h     |   4 +
>   arch/s390/include/asm/tpi.h      |  14 +
>   arch/s390/include/uapi/asm/kvm.h |   1 +
>   arch/s390/kvm/Makefile           |   2 +-
>   arch/s390/kvm/interrupt.c        |  97 +++-
>   arch/s390/kvm/kvm-s390.c         |  65 ++-
>   arch/s390/kvm/kvm-s390.h         |  10 +
>   arch/s390/kvm/pci.c              | 784 +++++++++++++++++++++++++++++++
>   arch/s390/kvm/pci.h              |  59 +++
>   arch/s390/kvm/priv.c             |  41 ++
>   arch/s390/pci/pci.c              |  47 ++
>   arch/s390/pci/pci_clp.c          |  19 +-
>   arch/s390/pci/pci_dma.c          |   1 +
>   arch/s390/pci/pci_insn.c         |   5 +-
>   arch/s390/pci/pci_irq.c          |  50 +-
>   drivers/s390/char/sclp_early.c   |   4 +
>   drivers/s390/cio/airq.c          |  12 +-
>   drivers/s390/cio/qdio_thinint.c  |   6 +-
>   drivers/s390/crypto/ap_bus.c     |   9 +-
>   drivers/s390/virtio/virtio_ccw.c |   6 +-
>   drivers/vfio/pci/Kconfig         |  11 +
>   drivers/vfio/pci/Makefile        |   2 +-
>   drivers/vfio/pci/vfio_pci_core.c |   8 +
>   drivers/vfio/pci/vfio_pci_zdev.c | 292 +++++++++++-
>   include/linux/vfio_pci_core.h    |  44 +-
>   include/uapi/linux/vfio.h        |  22 +
>   include/uapi/linux/vfio_zdev.h   |  51 ++
>   35 files changed, 1738 insertions(+), 60 deletions(-)
>   create mode 100644 arch/s390/include/asm/kvm_pci.h
>   create mode 100644 arch/s390/kvm/pci.c
>   create mode 100644 arch/s390/kvm/pci.h
> 


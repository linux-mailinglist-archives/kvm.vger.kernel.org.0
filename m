Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14684753B7
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 08:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240579AbhLOHey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 02:34:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65192 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240552AbhLOHey (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 02:34:54 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BF6nupV017019;
        Wed, 15 Dec 2021 07:34:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=psnHTDewaTaXSwr3qd5zJNYxqI27rpEmTAT24XZmzrk=;
 b=ZVdQcaw6dRLXGIFrVBFQlQ3dzob25X+cW4xoHZL13ai3P3dobj3zjbgeHPg/bltquuBg
 2s+Mm/vAHB5t1cfMAkfaZL7QnuL4NKQVALue4xU3WWuzTWzwQXqW2ueV1+yhAIstRVjl
 s8+oiOSu6fAD2C4oPajS/Vc5R9mhBrk07I5kG25ruIHL5gcP4hcucZZVRgkLdT2KmkcB
 UHBIL7XAzkCw3k4+S0qvKm4OfNF4B/5sfbU/g2vOnVfVHtnrTOBPTsSe1a5vK8tBq3aO
 KgFHVTwdL1M758I5n86B28Bc31Nv+Os9Rx8MuQraklFmolscyk6ZUu5G/2DmyUrm/VUO AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r99f5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 07:34:47 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BF6sFFm010261;
        Wed, 15 Dec 2021 07:34:47 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r99f5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 07:34:47 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BF7XBfi006290;
        Wed, 15 Dec 2021 07:34:44 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3cy7qvt0se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 07:34:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BF7YfIr31785442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 07:34:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D38FA404D;
        Wed, 15 Dec 2021 07:34:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78996A4059;
        Wed, 15 Dec 2021 07:34:40 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Dec 2021 07:34:40 +0000 (GMT)
Message-ID: <e1ba4cce-d6b9-bc86-9999-dc135046129d@linux.ibm.com>
Date:   Wed, 15 Dec 2021 08:35:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 00/12] s390x/pci: zPCI interpretation support
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211207210425.150923-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eLzi00A-IV_z8aDBpKJGR-DeP8tH7zjE
X-Proofpoint-GUID: xaNaf6cEi2Nd7fUMmdp1fikkPCrgl92-
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_06,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 bulkscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150042
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/21 22:04, Matthew Rosato wrote:
> Note:  The first 3 patches of this series are included as pre-reqs, but
> should be pulled via a separate series.  Also, patch 5 is needed to
> support 5.16+ linux header-sync and was already done by Paolo but not
> merged yet so is thus included here as well.
> 
> For QEMU, the majority of the work in enabling instruction interpretation
> is handled via new VFIO ioctls to SET the appropriate interpretation and
> interrupt forwarding modes, and to GET the function handle to use for
> interpretive execution.
> 
> This series implements these new ioctls, as well as adding a new, optional
> 'intercept' parameter to zpci to request interpretation support not be used
> as well as an 'intassist' parameter to determine whether or not the
> firmware assist will be used for interrupt delivery or whether the host
> will be responsible for delivering all interrupts.

In which circumstances do we have an added value by not using interrupt 
delivered by firmware?


> 
> The ZPCI_INTERP CPU feature is added beginning with the z14 model to
> enable this support.
> 
> As a consequence of implementing zPCI interpretation, ISM devices now
> become eligible for passthrough (but only when zPCI interpretation is
> available).
> 
>  From the perspective of guest configuration, you passthrough zPCI devices
> in the same manner as before, with intepretation support being used by
> default if available in kernel+qemu.
> 
> Associated kernel series:
> https://lkml.org/lkml/2021/12/7/1179
> 
> Matthew Rosato (11):
>    s390x/pci: use a reserved ID for the default PCI group
>    s390x/pci: don't use hard-coded dma range in reg_ioat
>    s390x/pci: add supported DT information to clp response
>    Update linux headers
>    target/s390x: add zpci-interp to cpu models
>    s390x/pci: enable for load/store intepretation
>    s390x/pci: don't fence interpreted devices without MSI-X
>    s390x/pci: enable adapter event notification for interpreted devices
>    s390x/pci: use I/O Address Translation assist when interpreting
>    s390x/pci: use dtsm provided from vfio capabilities for interpreted
>      devices
>    s390x/pci: let intercept devices have separate PCI groups
> 
> Paolo Bonzini (1):
>    virtio-gpu: do not byteswap padding
> 
>   hw/s390x/s390-pci-bus.c                       | 121 +++++++++-
>   hw/s390x/s390-pci-inst.c                      | 178 +++++++++++++-
>   hw/s390x/s390-pci-vfio.c                      | 221 +++++++++++++++++-
>   include/hw/s390x/s390-pci-bus.h               |  11 +-
>   include/hw/s390x/s390-pci-clp.h               |   3 +-
>   include/hw/s390x/s390-pci-inst.h              |   2 +-
>   include/hw/s390x/s390-pci-vfio.h              |  45 ++++
>   include/hw/virtio/virtio-gpu-bswap.h          |   1 -
>   include/standard-headers/asm-x86/kvm_para.h   |   1 +
>   include/standard-headers/drm/drm_fourcc.h     | 121 +++++++++-
>   include/standard-headers/linux/ethtool.h      |  31 +++
>   include/standard-headers/linux/fuse.h         |  15 +-
>   include/standard-headers/linux/pci_regs.h     |   6 +
>   include/standard-headers/linux/virtio_gpu.h   |  18 +-
>   include/standard-headers/linux/virtio_ids.h   |  24 ++
>   include/standard-headers/linux/virtio_mem.h   |   9 +-
>   include/standard-headers/linux/virtio_vsock.h |   3 +-
>   linux-headers/asm-arm64/unistd.h              |   1 +
>   linux-headers/asm-generic/unistd.h            |  22 +-
>   linux-headers/asm-mips/unistd_n32.h           |   2 +
>   linux-headers/asm-mips/unistd_n64.h           |   2 +
>   linux-headers/asm-mips/unistd_o32.h           |   2 +
>   linux-headers/asm-powerpc/unistd_32.h         |   2 +
>   linux-headers/asm-powerpc/unistd_64.h         |   2 +
>   linux-headers/asm-s390/kvm.h                  |   1 +
>   linux-headers/asm-s390/unistd_32.h            |   2 +
>   linux-headers/asm-s390/unistd_64.h            |   2 +
>   linux-headers/asm-x86/kvm.h                   |   5 +
>   linux-headers/asm-x86/unistd_32.h             |   3 +
>   linux-headers/asm-x86/unistd_64.h             |   3 +
>   linux-headers/asm-x86/unistd_x32.h            |   3 +
>   linux-headers/linux/kvm.h                     |  41 +++-
>   linux-headers/linux/vfio.h                    |  22 ++
>   linux-headers/linux/vfio_zdev.h               |  51 ++++
>   target/s390x/cpu_features_def.h.inc           |   1 +
>   target/s390x/gen-features.c                   |   2 +
>   target/s390x/kvm/kvm.c                        |   1 +
>   37 files changed, 928 insertions(+), 52 deletions(-)
> 

-- 
Pierre Morel
IBM Lab Boeblingen

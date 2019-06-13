Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D015D43B82
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfFMP3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:29:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55966 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728847AbfFMLRe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jun 2019 07:17:34 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5DBHQF7126113
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 07:17:33 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t3kc76184-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 07:17:32 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Thu, 13 Jun 2019 12:17:29 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 13 Jun 2019 12:17:25 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5DBHNBh53674182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 11:17:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CE7EA404D;
        Thu, 13 Jun 2019 11:17:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4DE4A4059;
        Thu, 13 Jun 2019 11:17:22 +0000 (GMT)
Received: from [9.152.97.224] (unknown [9.152.97.224])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jun 2019 11:17:22 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH v5 0/8] s390: virtio: support protected virtualization
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>
References: <20190612111236.99538-1-pasic@linux.ibm.com>
 <4d10d4f8-aeb0-a5bc-6900-ab7901c01cf2@linux.ibm.com>
 <20190613131433.014f2380.pasic@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Thu, 13 Jun 2019 13:17:22 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613131433.014f2380.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19061311-0016-0000-0000-00000288C009
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061311-0017-0000-0000-000032E5FAD8
Message-Id: <625592e2-cdfa-0449-b946-bc6c55118f6c@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sure.

On 13.06.19 13:14, Halil Pasic wrote:
> On Thu, 13 Jun 2019 11:11:13 +0200
> Michael Mueller <mimu@linux.ibm.com> wrote:
>
>> Halil,
>>
>> I just ran my toleration tests successfully on current HW for
>> this series.
>>
>> Michael
> Thanks Michael! May I add a
> Tested-by: Michael Mueller <mimu@linux.ibm.com>
> for each patch?
>
>> On 12.06.19 13:12, Halil Pasic wrote:
>>> Enhanced virtualization protection technology may require the use of
>>> bounce buffers for I/O. While support for this was built into the virtio
>>> core, virtio-ccw wasn't changed accordingly.
>>>
>>> Some background on technology (not part of this series) and the
>>> terminology used.
>>>
>>> * Protected Virtualization (PV):
>>>
>>> Protected Virtualization guarantees, that non-shared memory of a  guest
>>> that operates in PV mode private to that guest. I.e. any attempts by the
>>> hypervisor or other guests to access it will result in an exception. If
>>> supported by the environment (machine, KVM, guest VM) a guest can decide
>>> to change into PV mode by doing the appropriate ultravisor calls.
>>>
>>> * Ultravisor:
>>>
>>> A hardware/firmware entity that manages PV guests, and polices access to
>>> their memory. A PV guest prospect needs to interact with the ultravisor,
>>> to enter PV mode, and potentially to share pages (for I/O which should
>>> be encrypted by the guest). A guest interacts with the ultravisor via so
>>> called ultravisor calls. A hypervisor needs to interact with the
>>> ultravisor to facilitate interpretation, emulation and swapping. A
>>> hypervisor  interacts with the ultravisor via ultravisor calls and via
>>> the SIE state description. Generally the ultravisor sanitizes hypervisor
>>> inputs so that the guest can not be corrupted (except for denial of
>>> service.
>>>
>>>
>>> What needs to be done
>>> =====================
>>>
>>> Thus what needs to be done to bring virtio-ccw up to speed with respect
>>> to protected virtualization is:
>>> * use some 'new' common virtio stuff
>>> * make sure that virtio-ccw specific stuff uses shared memory when
>>>     talking to the hypervisor (except control/communication blocks like ORB,
>>>     these are handled by the ultravisor)
>>> * make sure the DMA API does what is necessary to talk through shared
>>>     memory if we are a protected virtualization guest.
>>> * make sure the common IO layer plays along as well (airqs, sense).
>>>
>>>
>>> Important notes
>>> ================
>>>
>>> * This patch set is based on Martins features branch
>>>    (git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git branch
>>>    'features').
>>>
>>> * Documentation is still very sketchy. I'm committed to improving this,
>>>     but I'm currently hampered by some dependencies currently.
>>>
>>> * The existing naming in the common infrastructure (kernel internal
>>>     interfaces) is pretty much based on the AMD SEV terminology. Thus the
>>>     names aren't always perfect. There might be merit to changing these
>>>     names to more abstract ones. I did not put much thought into that at
>>>     the current stage.
>>>
>>> * Testing: Please use iommu_platform=on for any virtio devices you are
>>>     going to test this code with (so virtio actually uses the DMA API).
>>>
>>> @Sebastian: I kept your r-b on patch 2 "s390/cio: introduce DMA pools to
>>> cio" despite the small changes pointed out below. Please do complain if
>>> it ain't OK for you!
>>>
>>> Change log
>>> ==========
>>>
>>> v4 --> v5:
>>> * work around dma_pool API not tolerating NULL dma pool (patch 4)
>>> * make the genpool based dma pools API  tolerate NULL genpool (patch 2)
>>> * fix typo (patch 2)
>>> * fix unintended code move (patch 7)
>>> * add more r-b's
>>>
>>>
>>>
>>> v3 --> v4
>>> * fixed cleanup in css_bus_init() (Connie)
>>> * made cio.h include genalloc.h instead of a forward declaration
>>>     (Connie)
>>> * added comments about dma_mask/coherent_dma_mask values (Connie)
>>> * fixed error handling in virtio_ccw_init() (Connie)
>>> * got rid of the *vc_dma* wrappers (Connie)
>>> * added some Reviewed-bys
>>> * rebased on top of current master, no changes were necessary
>>>
>>> v2 --> v3:
>>> * patch 2/8
>>>       potential cio_dma_pool_init() returning NULL issue fixed
>>>       potential cio_gp_dma_create() returning NULL issue fixed
>>>       warning issues with doc type comments fixed
>>>       unused define statement removed
>>> * patch 3/8
>>>       potential cio_gp_dma_create() returning NULL issue fixed
>>>       whitespace issue fixed
>>>       warning issues with doc type comments fixed
>>> * patch 8/8
>>>       potential cio_dma_zalloc() returning NULL issue fixed
>>>
>>> v1 --> v2:
>>> * patch "virtio/s390: use vring_create_virtqueue" went already upstream
>>> * patch "virtio/s390: DMA support for virtio-ccw" went already upstream
>>> * patch "virtio/s390: enable packed ring" went already upstream
>>> * Made dev.dma_mask point to dev.coherent_dma_mask for css, subchannel
>>>     and ccw devices.
>>> * While rebasing 's390/airq: use DMA memory for adapter interrupts' the
>>>     newly introduced kmem_cache  was replaced with an equivalent dma_pool;
>>>     the kalloc() allocations are now replaced with cio_dma_zalloc()
>>>     allocations to avoid wasting almost a full page.
>>> * Made virtio-ccw use the new AIRQ_IV_CACHELINE flag.
>>> * fixed all remaining checkpatch issues
>>>
>>> RFC --> v1:
>>> * Fixed bugs found by Connie (may_reduce and handling reduced,  warning,
>>>     split move -- thanks Connie!).
>>> * Fixed console bug found by Sebastian (thanks Sebastian!).
>>> * Removed the completely useless duplicate of dma-mapping.h spotted by
>>>     Christoph (thanks Christoph!).
>>> * Don't use the global DMA pool for subchannel and ccw device
>>>     owned memory as requested by Sebastian. Consequences:
>>> 	* Both subchannel and ccw devices have their dma masks
>>> 	now (both specifying 31 bit addressable)
>>> 	* We require at least 2 DMA pages per ccw device now, most of
>>> 	this memory is wasted though.
>>> 	* DMA memory allocated by virtio is also 31 bit addressable now
>>>           as virtio uses the parent (which is the ccw device).
>>> * Enabled packed ring.
>>> * Rebased onto Martins feature branch; using the actual uv (ultravisor)
>>>     interface instead of TODO comments.
>>> * Added some explanations to the cover letter (Connie, David).
>>> * Squashed a couple of patches together and fixed some text stuff.
>>>
>>> Halil Pasic (8):
>>>     s390/mm: force swiotlb for protected virtualization
>>>     s390/cio: introduce DMA pools to cio
>>>     s390/cio: add basic protected virtualization support
>>>     s390/airq: use DMA memory for adapter interrupts
>>>     virtio/s390: use cacheline aligned airq bit vectors
>>>     virtio/s390: add indirection to indicators access
>>>     virtio/s390: use DMA memory for ccw I/O and classic notifiers
>>>     virtio/s390: make airq summary indicators DMA
>>>
>>>    arch/s390/Kconfig                   |   5 +
>>>    arch/s390/include/asm/airq.h        |   2 +
>>>    arch/s390/include/asm/ccwdev.h      |   4 +
>>>    arch/s390/include/asm/cio.h         |  11 ++
>>>    arch/s390/include/asm/mem_encrypt.h |  18 ++
>>>    arch/s390/mm/init.c                 |  47 ++++++
>>>    drivers/s390/cio/airq.c             |  37 +++--
>>>    drivers/s390/cio/ccwreq.c           |   9 +-
>>>    drivers/s390/cio/cio.h              |   2 +
>>>    drivers/s390/cio/css.c              | 134 ++++++++++++++-
>>>    drivers/s390/cio/device.c           |  68 ++++++--
>>>    drivers/s390/cio/device_fsm.c       |  49 +++---
>>>    drivers/s390/cio/device_id.c        |  20 ++-
>>>    drivers/s390/cio/device_ops.c       |  21 ++-
>>>    drivers/s390/cio/device_pgid.c      |  22 +--
>>>    drivers/s390/cio/device_status.c    |  24 +--
>>>    drivers/s390/cio/io_sch.h           |  20 ++-
>>>    drivers/s390/virtio/virtio_ccw.c    | 246 +++++++++++++++-------------
>>>    18 files changed, 538 insertions(+), 201 deletions(-)
>>>    create mode 100644 arch/s390/include/asm/mem_encrypt.h
>>>
-- 
Mit freundlichen Grüßen / Kind regards
Michael Müller

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294


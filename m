Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF6B16FAD1
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgBZJgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:36:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726764AbgBZJgC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 04:36:02 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01Q9YI77092172
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 04:36:01 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ydcng7mds-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 04:36:01 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 26 Feb 2020 09:35:59 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 26 Feb 2020 09:35:56 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01Q9Zsrr43647156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 09:35:55 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C629711C054;
        Wed, 26 Feb 2020 09:35:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6291811C052;
        Wed, 26 Feb 2020 09:35:54 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.219])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Feb 2020 09:35:54 +0000 (GMT)
Subject: Re: [PATCH v4 00/36] KVM: s390: Add support for protected VMs
To:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Wed, 26 Feb 2020 10:35:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224114107.4646-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20022609-0008-0000-0000-00000356889B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022609-0009-0000-0000-00004A77A6DA
Message-Id: <68e6ba26-6f96-fb6a-db64-2c591526f588@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_02:2020-02-25,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002260072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM part is almost done with review and I have now pushed this to
kvms390/next to give some exposure:
https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git/log/?h=next

We still need a solution for Patch 1,"mm:gup/writeback: add callbacks for
inaccessible pages".
Andrew, I need your guidance here. Take this via s390kvm with an ACK or
take it via your tree?

Christian




On 24.02.20 12:40, Christian Borntraeger wrote:
> mm-related patches CCed on linux-mm, the complete list can be found on
> the KVM and linux-s390 list. 
> 
> Andrew, any chance to take " mm:gup/writeback: add callbacks for
> inaccessible pages" for 5.7? I can then carry the s390/kvm part. There
> is no build dependency on this patch (just a logical one).  As an
> alternative I can take an ack and carry that patch myself. 
> 
> This series contains a "pretty small" common code memory management
> change that will allow paging, guest backing with files etc almost
> just like normal VMs. It should be a no-op for all architectures not
> opting in. And it should be usable for others that also try to get
> notified on "the pages are in the process of being used for things
> like I/O". This time I included error handling and an ACK from Will
> Deacon as well as a Reviewed-by: from David Hildenbrand.
> This patch will be used by
> "[PATCH v4 05/36] s390/mm: provide memory management functions for
> protected KVM guests".
> We need to call into the "make accessible" architecture function when
> the refcount is already increased the writeback bit is set. This will
> make sure that we do not call the reverse function (convert to secure)
> until the host operation has finished.
> 
> 
> Overview
> --------
> Protected VMs (PVM) are KVM VMs, where KVM can't access the VM's state
> like guest memory and guest registers anymore. Instead the PVMs are
> mostly managed by a new entity called Ultravisor (UV), which provides
> an API, so KVM and the PV can request management actions.
> 
> PVMs are encrypted at rest and protected from hypervisor access while
> running. They switch from a normal operation into protected mode, so
> we can still use the standard boot process to load a encrypted blob
> and then move it into protected mode.
> 
> Rebooting is only possible by passing through the unprotected/normal
> mode and switching to protected again.
> 
> All patches are in the protvirtv4 branch of the korg s390 kvm git
> https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git/log/?h=protvirtv6
> 
> Claudio presented the technology at his presentation at KVM Forum
> 2019.
> 
> https://static.sched.com/hosted_files/kvmforum2019/3b/ibm_protected_vms_s390x.pdf
> 
> 
> v3 -> v4:
> general
> -------
> - copyright updates
> - Reviewedby + acked by tags
> 
> KVM: s390/interrupt: do not pin adapter interrupt pages
> -------------------------------------------------------
> - more comments
> - get rid of now obsolete adapter parameter
> 
> s390/mm: provide memory management functions for protected KVM guests
> ---------------------------------------------------------------------
> - improved patch description
> 
> KVM: s390: protvirt: Add initial vm and cpu lifecycle handling
> --------------------------------------------------------------
> - rework tweak logic to not use an array
> - remove _VM_ part of the subfunction names of PV_COMMAND
> - merge alloc/create/destroy/dealloc into init/deinit
> - handle cmma deallocation on failures
> - rework error handling to pass along the first rc/rrc if VCPU or VM CREATE/DESTROY fails
> This was tested successfully with error injection and tracing. We do not deallocate on
> destroy failure and we pass along the first rc/rrc when vcpu destroy fails.
> 
>  KVM: s390: protvirt: Add KVM api documentation
> -----------------------------------------------
> - mention new MP_STATE
> - remove "old" interfaces that are no longer in the previous patch
> - move to the end
> 
> KVM: s390: protvirt: Secure memory is not mergeable
> ---------------------------------------------------
> - rebase on new lifecycle patch
> 
> KVM: s390: protvirt: UV calls in support of diag308 0,1
> -------------------------------------------------------
> - remove _VM_ part of the subfunction names of PV_COMMAND
> 
> KVM: s390: rstify new ioctls in api.rst
> ---------------------------------------
> - removed from this patch queue
> 
> 
> 
> v2 -> v3
> - rebase against v5.6-rc2
> - move some checks into the callers
> - typo fixes
> - extend UV query size
> - do a tlb flush when entering/exiting protected mode
> - more comments
> - change interface to PV_ENABLE/DISABLE instead of vcpu/vm
>   create/destroy
> - lockdep checks for *is_protected calls
> - locking improments
> - move facility 161 to qemu
> - checkpatch fixes
> - merged error handling in mm patch
> - removed vcpu pv commands
> - use mp_state for setting the IPL PSW
> 
> 
> v1 -> v2
> - rebase on top of kvm/master
> - pipe through rc and rrc. This might have created some churn here and
>   there
> - turn off sclp masking when rebooting into "unsecure"
> - memory management simplification
> - prefix page handling now via intercept 112
> - io interrupt intervention request fix (do not use GISA)
> - api.txt conversion to rst
> - sample patches on top of mm/gup/writeback
> - tons of review feedback
> - kvm_uv debug feature fixes and unifications
> - ultravisor information for /sys/firmware
> - 
> 
> RFCv2 -> v1 (you can diff the protvirtv2 and the protvirtv3 branch)
> - tons of review feedback integrated (see mail thread)
> - memory management now complete and working
> - Documentation patches merged
> - interrupt patches merged
> - CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST removed
> - SIDA interface integrated into memop
> - for merged patches I removed reviews that were not in all patches
> 
> 
> 
> Christian Borntraeger (4):
>   KVM: s390/mm: Make pages accessible before destroying the guest
>   KVM: s390: protvirt: Add SCLP interrupt handling
>   KVM: s390: protvirt: do not inject interrupts after start
>   KVM: s390: protvirt: introduce and enable KVM_CAP_S390_PROTECTED
> 
> Claudio Imbrenda (3):
>   mm/gup/writeback: add callbacks for inaccessible pages
>   s390/mm: provide memory management functions for protected KVM guests
>   KVM: s390/mm: handle guest unpin events
> 
> Janosch Frank (24):
>   KVM: s390: protvirt: Add UV debug trace
>   KVM: s390: add new variants of UV CALL
>   KVM: s390: protvirt: Add initial vm and cpu lifecycle handling
>   KVM: s390: protvirt: Secure memory is not mergeable
>   KVM: s390: protvirt: Handle SE notification interceptions
>   KVM: s390: protvirt: Instruction emulation
>   KVM: s390: protvirt: Handle spec exception loops
>   KVM: s390: protvirt: Add new gprs location handling
>   KVM: S390: protvirt: Introduce instruction data area bounce buffer
>   KVM: s390: protvirt: handle secure guest prefix pages
>   KVM: s390: protvirt: Write sthyi data to instruction data area
>   KVM: s390: protvirt: STSI handling
>   KVM: s390: protvirt: disallow one_reg
>   KVM: s390: protvirt: Do only reset registers that are accessible
>   KVM: s390: protvirt: Only sync fmt4 registers
>   KVM: s390: protvirt: Add program exception injection
>   KVM: s390: protvirt: UV calls in support of diag308 0, 1
>   KVM: s390: protvirt: Report CPU state to Ultravisor
>   KVM: s390: protvirt: Support cmd 5 operation state
>   KVM: s390: protvirt: Mask PSW interrupt bits for interception 104 and
>     112
>   KVM: s390: protvirt: Add UV cpu reset calls
>   DOCUMENTATION: Protected virtual machine introduction and IPL
>   s390: protvirt: Add sysfs firmware interface for Ultravisor
>     information
>   KVM: s390: protvirt: Add KVM api documentation
> 
> Michael Mueller (1):
>   KVM: s390: protvirt: Implement interrupt injection
> 
> Ulrich Weigand (1):
>   KVM: s390/interrupt: do not pin adapter interrupt pages
> 
> Vasily Gorbik (3):
>   s390/protvirt: introduce host side setup
>   s390/protvirt: add ultravisor initialization
>   s390/mm: add (non)secure page access exceptions handlers
> 
>  .../admin-guide/kernel-parameters.txt         |   5 +
>  Documentation/virt/kvm/api.rst                |  61 +-
>  Documentation/virt/kvm/devices/s390_flic.rst  |  11 +-
>  Documentation/virt/kvm/index.rst              |   2 +
>  Documentation/virt/kvm/s390-pv-boot.rst       |  83 +++
>  Documentation/virt/kvm/s390-pv.rst            | 116 ++++
>  MAINTAINERS                                   |   1 +
>  arch/s390/boot/Makefile                       |   2 +-
>  arch/s390/boot/uv.c                           |  21 +-
>  arch/s390/include/asm/gmap.h                  |   6 +
>  arch/s390/include/asm/kvm_host.h              | 113 +++-
>  arch/s390/include/asm/mmu.h                   |   2 +
>  arch/s390/include/asm/mmu_context.h           |   1 +
>  arch/s390/include/asm/page.h                  |   5 +
>  arch/s390/include/asm/pgtable.h               |  35 +-
>  arch/s390/include/asm/uv.h                    | 252 ++++++++-
>  arch/s390/kernel/Makefile                     |   1 +
>  arch/s390/kernel/pgm_check.S                  |   4 +-
>  arch/s390/kernel/setup.c                      |   9 +-
>  arch/s390/kernel/uv.c                         | 413 ++++++++++++++
>  arch/s390/kvm/Makefile                        |   2 +-
>  arch/s390/kvm/diag.c                          |   6 +-
>  arch/s390/kvm/intercept.c                     | 117 +++-
>  arch/s390/kvm/interrupt.c                     | 399 +++++++------
>  arch/s390/kvm/kvm-s390.c                      | 532 +++++++++++++++---
>  arch/s390/kvm/kvm-s390.h                      |  51 +-
>  arch/s390/kvm/priv.c                          |  13 +-
>  arch/s390/kvm/pv.c                            | 298 ++++++++++
>  arch/s390/mm/fault.c                          |  78 +++
>  arch/s390/mm/gmap.c                           |  65 ++-
>  include/linux/gfp.h                           |   6 +
>  include/uapi/linux/kvm.h                      |  43 +-
>  mm/gup.c                                      |  15 +-
>  mm/page-writeback.c                           |   5 +
>  34 files changed, 2461 insertions(+), 312 deletions(-)
>  create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
>  create mode 100644 Documentation/virt/kvm/s390-pv.rst
>  create mode 100644 arch/s390/kernel/uv.c
>  create mode 100644 arch/s390/kvm/pv.c
> 


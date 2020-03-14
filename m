Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2AA1857E5
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 02:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgCOBrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 21:47:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726643AbgCOBrG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Mar 2020 21:47:06 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02EFpNR0105089
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 11:58:29 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yrude1sat-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 11:58:29 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Sat, 14 Mar 2020 15:58:27 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 14 Mar 2020 15:58:23 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02EFwMWn52559960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Mar 2020 15:58:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 142D7AE04D;
        Sat, 14 Mar 2020 15:58:22 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B68FAE045;
        Sat, 14 Mar 2020 15:58:21 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.6.32])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 14 Mar 2020 15:58:21 +0000 (GMT)
Subject: Re: [GIT PULL 00/36] KVM: s390: Features and Enhancements for 5.7
 part1
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ulrich Weigand <uweigand@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Sat, 14 Mar 2020 16:58:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200309085126.3334302-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20031415-0008-0000-0000-0000035D2BA3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031415-0009-0000-0000-00004A7E7ABD
Message-Id: <323ef53d-1aab-5971-72cf-0d385f844ea8@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-14_05:2020-03-12,2020-03-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003140084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping.

On 09.03.20 09:50, Christian Borntraeger wrote:
> Paolo,
> 
> an early pull request containing mostly the protected virtualization guest
> support. Some remarks:
> 
> 1.To avoid conflicts I would rather add this early. We do have in KVM
> common code:
> - a new capability KVM_CAP_S390_PROTECTED = 180
> - a new ioctl  KVM_S390_PV_COMMAND =  _IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
> - data structures for KVM_S390_PV_COMMAND
> - new MEMOP ioctl subfunctions
> - new files under Documentation
> - additions to api.rst 4.125 KVM_S390_PV_COMMAND
> 
> 2. There is an mm patch in Andrews mm tree which is needed for full
> functionality. The patch is not necessary to build KVM or to run non
> protected KVM though. So this can go independently.
> 
> 3. I created a topic branch for the non-kvm s390x parts that I merged
> in. Vasily, Heiko or myself will pull that into the s390 tree if there
> will be a conflict.
> 
> 
> The following changes since commit 11a48a5a18c63fd7621bb050228cebf13566e4d8:
> 
>   Linux 5.6-rc2 (2020-02-16 13:16:59 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.7-1
> 
> for you to fetch changes up to cc674ef252f4750bdcea1560ff491081bb960954:
> 
>   KVM: s390: introduce module parameter kvm.use_gisa (2020-02-27 19:47:13 +0100)
> 
> ----------------------------------------------------------------
> KVM: s390: Features and Enhancements for 5.7 part1
> 
> 1. Allow to disable gisa
> 2. protected virtual machines
>   Protected VMs (PVM) are KVM VMs, where KVM can't access the VM's
>   state like guest memory and guest registers anymore. Instead the
>   PVMs are mostly managed by a new entity called Ultravisor (UV),
>   which provides an API, so KVM and the PV can request management
>   actions.
> 
>   PVMs are encrypted at rest and protected from hypervisor access
>   while running.  They switch from a normal operation into protected
>   mode, so we can still use the standard boot process to load a
>   encrypted blob and then move it into protected mode.
> 
>   Rebooting is only possible by passing through the unprotected/normal
>   mode and switching to protected again.
> 
>   One mm related patch will go via Andrews mm tree ( mm/gup/writeback:
>   add callbacks for inaccessible pages)
> 
> ----------------------------------------------------------------
> Christian Borntraeger (5):
>       Merge branch 'pvbase' of git://git.kernel.org/.../kvms390/linux into HEAD
>       KVM: s390/mm: Make pages accessible before destroying the guest
>       KVM: s390: protvirt: Add SCLP interrupt handling
>       KVM: s390: protvirt: do not inject interrupts after start
>       KVM: s390: protvirt: introduce and enable KVM_CAP_S390_PROTECTED
> 
> Claudio Imbrenda (2):
>       s390/mm: provide memory management functions for protected KVM guests
>       KVM: s390/mm: handle guest unpin events
> 
> Janosch Frank (24):
>       s390/protvirt: Add sysfs firmware interface for Ultravisor information
>       KVM: s390: protvirt: Add UV debug trace
>       KVM: s390: add new variants of UV CALL
>       KVM: s390: protvirt: Add initial vm and cpu lifecycle handling
>       KVM: s390: protvirt: Secure memory is not mergeable
>       KVM: s390: protvirt: Handle SE notification interceptions
>       KVM: s390: protvirt: Instruction emulation
>       KVM: s390: protvirt: Handle spec exception loops
>       KVM: s390: protvirt: Add new gprs location handling
>       KVM: S390: protvirt: Introduce instruction data area bounce buffer
>       KVM: s390: protvirt: handle secure guest prefix pages
>       KVM: s390: protvirt: Write sthyi data to instruction data area
>       KVM: s390: protvirt: STSI handling
>       KVM: s390: protvirt: disallow one_reg
>       KVM: s390: protvirt: Do only reset registers that are accessible
>       KVM: s390: protvirt: Only sync fmt4 registers
>       KVM: s390: protvirt: Add program exception injection
>       KVM: s390: protvirt: UV calls in support of diag308 0, 1
>       KVM: s390: protvirt: Report CPU state to Ultravisor
>       KVM: s390: protvirt: Support cmd 5 operation state
>       KVM: s390: protvirt: Mask PSW interrupt bits for interception 104 and 112
>       KVM: s390: protvirt: Add UV cpu reset calls
>       DOCUMENTATION: Protected virtual machine introduction and IPL
>       KVM: s390: protvirt: Add KVM api documentation
> 
> Michael Mueller (2):
>       KVM: s390: protvirt: Implement interrupt injection
>       KVM: s390: introduce module parameter kvm.use_gisa
> 
> Ulrich Weigand (1):
>       KVM: s390/interrupt: do not pin adapter interrupt pages
> 
> Vasily Gorbik (3):
>       s390/protvirt: introduce host side setup
>       s390/protvirt: add ultravisor initialization
>       s390/mm: add (non)secure page access exceptions handlers
> 
>  Documentation/admin-guide/kernel-parameters.txt |   5 +
>  Documentation/virt/kvm/api.rst                  |  65 ++-
>  Documentation/virt/kvm/devices/s390_flic.rst    |  11 +-
>  Documentation/virt/kvm/index.rst                |   2 +
>  Documentation/virt/kvm/s390-pv-boot.rst         |  84 ++++
>  Documentation/virt/kvm/s390-pv.rst              | 116 +++++
>  MAINTAINERS                                     |   1 +
>  arch/s390/boot/Makefile                         |   2 +-
>  arch/s390/boot/uv.c                             |  20 +
>  arch/s390/include/asm/gmap.h                    |   6 +
>  arch/s390/include/asm/kvm_host.h                | 113 ++++-
>  arch/s390/include/asm/mmu.h                     |   2 +
>  arch/s390/include/asm/mmu_context.h             |   1 +
>  arch/s390/include/asm/page.h                    |   5 +
>  arch/s390/include/asm/pgtable.h                 |  35 +-
>  arch/s390/include/asm/uv.h                      | 251 ++++++++++-
>  arch/s390/kernel/Makefile                       |   1 +
>  arch/s390/kernel/entry.h                        |   2 +
>  arch/s390/kernel/pgm_check.S                    |   4 +-
>  arch/s390/kernel/setup.c                        |   9 +-
>  arch/s390/kernel/uv.c                           | 414 +++++++++++++++++
>  arch/s390/kvm/Makefile                          |   2 +-
>  arch/s390/kvm/diag.c                            |   6 +-
>  arch/s390/kvm/intercept.c                       | 122 ++++-
>  arch/s390/kvm/interrupt.c                       | 399 ++++++++++-------
>  arch/s390/kvm/kvm-s390.c                        | 567 +++++++++++++++++++++---
>  arch/s390/kvm/kvm-s390.h                        |  51 ++-
>  arch/s390/kvm/priv.c                            |  13 +-
>  arch/s390/kvm/pv.c                              | 303 +++++++++++++
>  arch/s390/mm/fault.c                            |  78 ++++
>  arch/s390/mm/gmap.c                             |  65 ++-
>  include/uapi/linux/kvm.h                        |  43 +-
>  32 files changed, 2488 insertions(+), 310 deletions(-)
>  create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
>  create mode 100644 Documentation/virt/kvm/s390-pv.rst
>  create mode 100644 arch/s390/kernel/uv.c
>  create mode 100644 arch/s390/kvm/pv.c
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02CE01BB31
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 18:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbfEMQnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 12:43:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32982 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728347AbfEMQnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 12:43:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DGYQKB111927;
        Mon, 13 May 2019 16:42:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=ATziYQM3BisJpEWNrMybm0ATp8Wg9hslherHAIoEXPk=;
 b=PuSpa9RsniOKhHCdnNEDTgZgkxJy6qzjAqG/HMFOTPYOuM74HPQUKAr1aYlxcALUtNTA
 jL+z+1E6jePW1mwzI8KZqIvhhW1FHCcD7rfOw7RlWvgCHdEOMok2UhHBMfd8jnP4zp0O
 z4nwdn0bHevcip6u3LmnvIWJIVxfJUHir388EETTpQHJm+m/cWWghb4A+lNhRlvAP/J/
 qBNolx5LP8i1XcdyGvVYh7wBi0eP81HEdRKorwSfMTy0yKbXp+pPxW6Eupj9rbCQMy2Q
 1B3Opv8gkJY0vTL0WwTQQ0snu2VrxsmPf+ov70n2S5SfbM477F1aeiuKtWlZNmwCoBzu bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2sdq1q87k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 16:42:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DGg9Tx187280;
        Mon, 13 May 2019 16:42:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2sf3cms538-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 16:42:27 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4DGgPph018666;
        Mon, 13 May 2019 16:42:25 GMT
Received: from [10.30.3.22] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 09:42:25 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RFC KVM 00/27] KVM Address Space Isolation
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
Date:   Mon, 13 May 2019 19:42:18 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        dave.hansen@linux.intel.com, Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, x86@kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, jwadams@google.com, snu@amazon.de,
        kayab@google.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B445CF71-477D-4069-9D2C-DB04B4EEFB97@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130113
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 13 May 2019, at 17:38, Alexandre Chartre =
<alexandre.chartre@oracle.com> wrote:
>=20
> Hi,
>=20
> This series aims to introduce the concept of KVM address space =
isolation.
> This is done as part of the upstream community effort to have exploit
> mitigations for CPU info-leaks vulnerabilities such as L1TF.=20
>=20
> These patches are based on an original patches from Liran Alon, =
completed
> with additional patches to effectively create KVM address space =
different
> from the full kernel address space.

Great job for pushing this forward! Thank you!

>=20
> The current code is just an early POC, and it is not fully stable at =
the
> moment (unfortunately you can expect crashes/hangs, see the "Issues"
> section below). However I would like to start a discussion get =
feedback
> and opinions about this approach.
>=20
> Context
> =3D=3D=3D=3D=3D=3D=3D
>=20
> The most naive approach to handle L1TF SMT-variant exploit is to just =
disable
> hyper-threading. But that is not practical for public cloud providers. =
As a
> second next best alternative, there is an approach to combine =
coscheduling
> together with flushing L1D cache on every VMEntry. By coscheduling I =
refer
> to some mechanism which on every VMExit from guest, kicks all sibling
> hyperthreads from guest aswell.
>=20
> However, this approach have some open issues:
>=20
> 1. Kicking all sibling hyperthreads for every VMExit have significant
>   performance hit for some compute shapes (e.g. Emulated and PV).
>=20
> 2. It assumes only CPU core resource which could be leaked by some
>   vulnerability is L1D cache. But future vulnerabilities may also be =
able
>   to leak other CPU core resources. Therefore, we would prefer to have =
a
>   mechanism which prevents these resources to be able to be loaded =
with
>   sensitive data to begin with.
>=20
> To better address (2), upstream community has discussed some =
mechanisms
> related to reducing data that is mapped on kernel virtual address =
space.
> Specifically:
>=20
> a. XPFO: Removes from physmap pages that currently should only be =
accessed
>   by userspace.
>=20
> b. Process-local memory allocations: Allows having a memory area in =
kernel
>   virtual address space that maps different content per-process. Then,
>   allocations made on this memory area can be hidden from other tasks =
in
>   the system running in kernel space. Most obvious use it to allocate
>   there per-vCPU and per-VM KVM structures.
>=20
> However, both (a)+(b) work in a black-list approach (where we decide =
which
> data is considered dangerous and remove it from kernel virtual address
> space) and don't address performance hit described at (1).

+Cc Stefan from AWS and Kaya from Google.
(I have sent them my original patch series for review and discuss with =
them about this subject)
Stefan: Do you know what is Julian's current email address to Cc him =
as-well?

>=20
>=20
> Proposal
> =3D=3D=3D=3D=3D=3D=3D=3D
>=20
> To handle both these points, this series introduce the mechanism of =
KVM
> address space isolation. Note that this mechanism completes (a)+(b) =
and
> don't contradict. In case this mechanism is also applied, (a)+(b) =
should
> still be applied to the full virtual address space as a =
defence-in-depth).
>=20
> The idea is that most of KVM #VMExit handlers code will run in a =
special
> KVM isolated address space which maps only KVM required code and =
per-VM
> information. Only once KVM needs to architectually access other =
(sensitive)
> data, it will switch from KVM isolated address space to full standard
> host address space. At this point, KVM will also need to kick all =
sibling
> hyperthreads to get out of guest (note that kicking all sibling =
hyperthreads
> is not implemented in this serie).
>=20
> Basically, we will have the following flow:
>=20
>  - qemu issues KVM_RUN ioctl
>  - KVM handles the ioctl and calls vcpu_run():
>    . KVM switches from the kernel address to the KVM address space
>    . KVM transfers control to VM (VMLAUNCH/VMRESUME)
>    . VM returns to KVM
>    . KVM handles VM-Exit:
>      . if handling need full kernel then switch to kernel address =
space

*AND* kick sibling hyperthreads before switching to that address space.
I think it=E2=80=99s important to emphasise that one of the main points =
of this KVM address space isolation mechanism is to minimise number of =
times we require to kick sibling hyperthreads outside of guest. By =
hopefully having the vast majority of VMExits handled on KVM isolated =
address space.

>      . else continues with KVM address space
>    . KVM loops in vcpu_run() or return
>  - KVM_RUN ioctl returns
>=20
> So, the KVM_RUN core function will mainly be executed using the KVM =
address
> space. The handling of a VM-Exit can require access to the kernel =
space
> and, in that case, we will switch back to the kernel address space.
>=20
> The high-level idea of how this is implemented is to create a separate
> struct_mm for KVM such that a vCPU thread will switch active_mm =
between
> it's original active_mm and kvm_mm when needed as described above. The
> idea is very similar to how kernel switches between task active_mm and
> efi_mm when calling EFI Runtime Services.
>=20
> Note that because we use the kernel TLB Manager to switch between =
kvm_mm
> and host_mm, we will effectively use TLB with PCID if enabled to make
> these switches fast. As all of this is managed internally in TLB =
Manager's
> switch_mm().
>=20
>=20
> Patches
> =3D=3D=3D=3D=3D=3D=3D
>=20
> The proposed patches implement the necessary framework for creating =
kvm_mm
> and switching between host_mm and kvm_mm at appropriate times. They =
also
> provide functions for populating the KVM address space, and implement =
an
> actual KVM address space much smaller than the full kernel address =
space.
>=20
> - 01-08: add framework for switching between the kernel address space =
and
>  the KVM address space at appropriate times. Note that these patches =
do
>  not create or switch the address space yet. Address space switching =
is
>  implemented in patch 25.
>=20
> - 09-18: add a framework for populating and managing the KVM page =
table;
>  this also include mechanisms to ensure changes are effectively =
limited
>  to the KVM page table and no change is mistakenly propagated to the
>  kernel page table.
>=20
> - 19-23: populate the KVM page table.
>=20
> - 24: add page fault handler to handle and report missing mappings =
when
>  running with the KVM address space. This is based on an original idea
>  from Paul Turner.
>=20
> - 25: implement the actual switch between the kernel address space and
>  the KVM address space.
>=20
> - 26-27: populate the KVM page table with more data.
>=20
>=20
> If a fault occurs while running with the KVM address space, it will be
> reported on the console like this:
>=20
> [ 4840.727476] KVM isolation: page fault #0 (0) at =
fast_page_fault+0x13e/0x3e0 [kvm] on ffffea00005331f0 =
(0xffffea00005331f0)
>=20
> If the KVM page_fault_stack module parameter is set to non-zero =
(that's
> the default) then the stack of the fault will also be reported:
>=20
> [ 5025.630374] KVM isolation: page fault #0 (0) at =
fast_page_fault+0x100/0x3e0 [kvm] on ffff88003c718000 =
(0xffff88003c718000)
> [ 5025.631918] Call Trace:
> [ 5025.632782]  tdp_page_fault+0xec/0x260 [kvm]
> [ 5025.633395]  kvm_mmu_page_fault+0x74/0x5f0 [kvm]
> [ 5025.644467]  handle_ept_violation+0xc3/0x1a0 [kvm_intel]
> [ 5025.645218]  vmx_handle_exit+0xb9/0x600 [kvm_intel]
> [ 5025.645917]  vcpu_enter_guest+0xb88/0x1580 [kvm]
> [ 5025.646577]  kvm_arch_vcpu_ioctl_run+0x403/0x610 [kvm]
> [ 5025.647313]  kvm_vcpu_ioctl+0x3d5/0x650 [kvm]
> [ 5025.648538]  do_vfs_ioctl+0xaa/0x602
> [ 5025.650502]  SyS_ioctl+0x79/0x84
> [ 5025.650966]  do_syscall_64+0x79/0x1ae
> [ 5025.651487]  entry_SYSCALL_64_after_hwframe+0x151/0x0
> [ 5025.652200] RIP: 0033:0x7f74a2f1d997
> [ 5025.652710] RSP: 002b:00007f749f3ec998 EFLAGS: 00000246 ORIG_RAX: =
0000000000000010
> [ 5025.653769] RAX: ffffffffffffffda RBX: 0000562caa83e110 RCX: =
00007f74a2f1d997
> [ 5025.654769] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: =
000000000000000c
> [ 5025.655769] RBP: 0000562caa83e1b3 R08: 0000562ca9b6fa50 R09: =
0000000000000006
> [ 5025.656766] R10: 0000000000000000 R11: 0000000000000246 R12: =
0000562ca9b552c0
> [ 5025.657764] R13: 0000000000801000 R14: 00007f74a59d4000 R15: =
0000562caa83e110
>=20
> This allows to find out what is missing in the KVM address space.
>=20
>=20
> Issues
> =3D=3D=3D=3D=3D=3D
>=20
> Limited tests have been done so far, and mostly with an empty =
single-vcpu
> VM (i.e. qemu-system-i386 -enable-kvm -smp 1). Single-vcpu VM is able =
to
> start and run a full OS but the system will eventually crash/hang at =
some
> point. Multiple vcpus will crash/hang much faster.
>=20
>=20
> Performance Impact
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> As this is a RFC, the effective performance impact hasn't been =
measured
> yet.

> Current patches introduce two additional context switches (kernel to
> KVM, and KVM to kernel) on each KVM_RUN ioctl.

I have never considered this to be an issue.
By design of this patch series, I treated exits to userspace VMM as =
slow-path that should not be important to optimise.

> Also additional context
> switches are added if a VM-Exit has to be handled using the full =
kernel
> address space.

This is by design as well.
The KVM address space should contain enough data that is not-sensitive =
to be leaked by guest from one hand while still be able to handle the =
vast majority of exits without exiting the address space on the other =
hand. If we cannot achieve such a KVM isolated address space, the PoC of =
the series failed.

>=20
> I expect that the KVM address space can eventually be expanded to =
include
> the ioctl syscall entries.

As mentioned above, I do not see a strong reason to do so. The ioctl =
syscalls are considered slow-path that shouldn=E2=80=99t be important to =
optimise.

> By doing so, and also adding the KVM page table
> to the process userland page table (which should be safe to do because =
the
> KVM address space doesn't have any secret), we could potentially =
handle the
> KVM ioctl without having to switch to the kernel pagetable (thus =
effectively
> eliminating KPTI for KVM).

=46rom above reasons, I don=E2=80=99t think this is important.

> Then the only overhead would be if a VM-Exit has
> to be handled using the full kernel address space.

This was always by design the only overhead. And a major one. Because =
not only it switches address space but also it will require in the =
future to kick all sibling hyperthreads outside of guest. The purpose of =
the series is to created an address space such that most VMExits won=E2=80=
=99t require to do such kick to the sibling hyperthreads.

-Liran

>=20
>=20
> Thanks,
>=20
> alex.
>=20
> ---
>=20
> Alexandre Chartre (18):
>  kvm/isolation: function to track buffers allocated for the KVM page
>    table
>  kvm/isolation: add KVM page table entry free functions
>  kvm/isolation: add KVM page table entry offset functions
>  kvm/isolation: add KVM page table entry allocation functions
>  kvm/isolation: add KVM page table entry set functions
>  kvm/isolation: functions to copy page table entries for a VA range
>  kvm/isolation: keep track of VA range mapped in KVM address space
>  kvm/isolation: functions to clear page table entries for a VA range
>  kvm/isolation: improve mapping copy when mapping is already present
>  kvm/isolation: function to copy page table entries for percpu buffer
>  kvm/isolation: initialize the KVM page table with core mappings
>  kvm/isolation: initialize the KVM page table with vmx specific data
>  kvm/isolation: initialize the KVM page table with vmx VM data
>  kvm/isolation: initialize the KVM page table with vmx cpu data
>  kvm/isolation: initialize the KVM page table with the vcpu tasks
>  kvm/isolation: KVM page fault handler
>  kvm/isolation: initialize the KVM page table with KVM memslots
>  kvm/isolation: initialize the KVM page table with KVM buses
>=20
> Liran Alon (9):
>  kernel: Export memory-management symbols required for KVM address
>    space isolation
>  KVM: x86: Introduce address_space_isolation module parameter
>  KVM: x86: Introduce KVM separate virtual address space
>  KVM: x86: Switch to KVM address space on entry to guest
>  KVM: x86: Add handler to exit kvm isolation
>  KVM: x86: Exit KVM isolation on IRQ entry
>  KVM: x86: Switch to host address space when may access sensitive data
>  KVM: x86: Optimize branches which checks if address space isolation
>    enabled
>  kvm/isolation: implement actual KVM isolation enter/exit
>=20
> arch/x86/include/asm/apic.h    |    4 +-
> arch/x86/include/asm/hardirq.h |   10 +
> arch/x86/include/asm/irq.h     |    1 +
> arch/x86/kernel/cpu/common.c   |    2 +
> arch/x86/kernel/dumpstack.c    |    1 +
> arch/x86/kernel/irq.c          |   11 +
> arch/x86/kernel/ldt.c          |    1 +
> arch/x86/kernel/smp.c          |    2 +-
> arch/x86/kvm/Makefile          |    2 +-
> arch/x86/kvm/isolation.c       | 1773 =
++++++++++++++++++++++++++++++++++++++++
> arch/x86/kvm/isolation.h       |   40 +
> arch/x86/kvm/mmu.c             |    3 +-
> arch/x86/kvm/vmx/vmx.c         |  123 +++-
> arch/x86/kvm/x86.c             |   44 +-
> arch/x86/mm/fault.c            |   12 +
> arch/x86/mm/tlb.c              |    4 +-
> arch/x86/platform/uv/tlb_uv.c  |    2 +-
> include/linux/kvm_host.h       |    2 +
> include/linux/percpu.h         |    2 +
> include/linux/sched.h          |    6 +
> mm/memory.c                    |    5 +
> mm/percpu.c                    |    6 +-
> virt/kvm/arm/arm.c             |    4 +
> virt/kvm/kvm_main.c            |    4 +-
> 24 files changed, 2051 insertions(+), 13 deletions(-)
> create mode 100644 arch/x86/kvm/isolation.c
> create mode 100644 arch/x86/kvm/isolation.h
>=20


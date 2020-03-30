Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3600198404
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 21:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgC3TNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 15:13:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56832 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgC3TNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 15:13:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02UJ9VNI090298;
        Mon, 30 Mar 2020 19:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IwYgIaMmDHNmMUyZ2c1qdklAsScG+C9MwfAc2TfiTIg=;
 b=Sxrqg/0lIIqOgWARn1L/daogCMUHFjRbqxo5FNGQADbnl+2FexmZADh4fGKPttVBFzgV
 sLO/FtHEF56Lx7EousLBBgDIo0e/Wydh+oIbyqUVNCGfbx7BO1E/mNa9L/Ri1Xz9jADF
 vs0LlFkDJhIrwZyLzMma8rF6DY2e8XvJu0Vem/mapt7GZWFhr/m5TGOyzOLMRldEI7Wm
 Axq7R9Ah5KJUmdi9KT1Zh4ekYvqyoDDns32tE5JZiy6jpS5oeI7Cx2gDARLLZ126wJMi
 xBB4alA32UeMOR8DPaWhhGcBlrzM0v0h8j7yJdjxkbV3s6TmySGNpBcS8n+Nwn33KctF XQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 301xhkrsu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 19:13:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02UJDCUT125742;
        Mon, 30 Mar 2020 19:13:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 302gca5pec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 19:13:13 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02UJDCao014770;
        Mon, 30 Mar 2020 19:13:12 GMT
Received: from vbusired-dt (/10.154.170.177)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Mar 2020 12:13:11 -0700
Date:   Mon, 30 Mar 2020 14:13:07 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 00/14] Add AMD SEV guest live migration support
Message-ID: <20200330191307.GA586407@vbusired-dt>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <20200330172446.GA584882@vbusired-dt>
 <20200330182845.GA21740@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330182845.GA21740@ashkalra_ubuntu_server>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9576 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003300162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9576 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 clxscore=1015 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300161
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-30 18:28:45 +0000, Ashish Kalra wrote:
> This is applied on top of Linux 5.6, as per commit below :
> 
> commit 7111951b8d4973bda27ff663f2cf18b663d15b48 (tag: v5.6, origin/master, origin/HEAD)
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Mar 29 15:25:41 2020 -0700
> 
>     Linux 5.6
> 
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Not sure what I am missing here! This the current state of my sandbox:

$ git remote -v
origin  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git (fetch)
origin  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git (push)

$ git log --oneline
12acbbfef749 (HEAD -> master) KVM: SVM: Add KVM_SEV_SEND_FINISH command
e5f21e48bfff KVM: SVM: Add KVM_SEND_UPDATE_DATA command
6b2bcf682d08 KVM: SVM: Add KVM_SEV SEND_START command
7111951b8d49 (tag: v5.6, origin/master, origin/HEAD) Linux 5.6

$ git status
On branch master
Your branch is ahead of 'origin/master' by 3 commits.

As can be seen, I started with the commit (7111951b8d49) you mentioned.
I could apply 3 of the patches, but 04/14 is failing.

Any suggestions?

Thanks,

Venu

> Thanks,
> Ashish
> 
> On Mon, Mar 30, 2020 at 12:24:46PM -0500, Venu Busireddy wrote:
> > On 2020-03-30 06:19:27 +0000, Ashish Kalra wrote:
> > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > 
> > > The series add support for AMD SEV guest live migration commands. To protect the
> > > confidentiality of an SEV protected guest memory while in transit we need to
> > > use the SEV commands defined in SEV API spec [1].
> > > 
> > > SEV guest VMs have the concept of private and shared memory. Private memory
> > > is encrypted with the guest-specific key, while shared memory may be encrypted
> > > with hypervisor key. The commands provided by the SEV FW are meant to be used
> > > for the private memory only. The patch series introduces a new hypercall.
> > > The guest OS can use this hypercall to notify the page encryption status.
> > > If the page is encrypted with guest specific-key then we use SEV command during
> > > the migration. If page is not encrypted then fallback to default.
> > > 
> > > The patch adds new ioctls KVM_{SET,GET}_PAGE_ENC_BITMAP. The ioctl can be used
> > > by the qemu to get the page encrypted bitmap. Qemu can consult this bitmap
> > > during the migration to know whether the page is encrypted.
> > > 
> > > [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdeveloper.amd.com%2Fwp-content%2Fresources%2F55766.PDF&amp;data=02%7C01%7CAshish.Kalra%40amd.com%7Cb87828d7e1eb41fe401c08d7d4cf4937%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637211859771455979&amp;sdata=yN1OrvcuNb%2F8JAaLwlf2pIJtEvBRFOSvTKPYWz9ASUY%3D&amp;reserved=0
> > > 
> > > Changes since v5:
> > > - Fix build errors as
> > >   Reported-by: kbuild test robot <lkp@intel.com>
> > 
> > Which upstream tag should I use to apply this patch set? I tried the
> > top of Linus's tree, and I get the following error when I apply this
> > patch set.
> > 
> > $ git am PATCH-v6-01-14-KVM-SVM-Add-KVM_SEV-SEND_START-command.mbox
> > Applying: KVM: SVM: Add KVM_SEV SEND_START command
> > Applying: KVM: SVM: Add KVM_SEND_UPDATE_DATA command
> > Applying: KVM: SVM: Add KVM_SEV_SEND_FINISH command
> > Applying: KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
> > error: patch failed: Documentation/virt/kvm/amd-memory-encryption.rst:375
> > error: Documentation/virt/kvm/amd-memory-encryption.rst: patch does not apply
> > error: patch failed: arch/x86/kvm/svm.c:7632
> > error: arch/x86/kvm/svm.c: patch does not apply
> > Patch failed at 0004 KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
> > 
> > Thanks,
> > 
> > Venu
> > 
> > > 
> > > Changes since v4:
> > > - Host support has been added to extend KVM capabilities/feature bits to 
> > >   include a new KVM_FEATURE_SEV_LIVE_MIGRATION, which the guest can
> > >   query for host-side support for SEV live migration and a new custom MSR
> > >   MSR_KVM_SEV_LIVE_MIG_EN is added for guest to enable the SEV live
> > >   migration feature.
> > > - Ensure that _bss_decrypted section is marked as decrypted in the
> > >   page encryption bitmap.
> > > - Fixing KVM_GET_PAGE_ENC_BITMAP ioctl to return the correct bitmap
> > >   as per the number of pages being requested by the user. Ensure that
> > >   we only copy bmap->num_pages bytes in the userspace buffer, if
> > >   bmap->num_pages is not byte aligned we read the trailing bits
> > >   from the userspace and copy those bits as is. This fixes guest
> > >   page(s) corruption issues observed after migration completion.
> > > - Add kexec support for SEV Live Migration to reset the host's
> > >   page encryption bitmap related to kernel specific page encryption
> > >   status settings before we load a new kernel by kexec. We cannot
> > >   reset the complete page encryption bitmap here as we need to
> > >   retain the UEFI/OVMF firmware specific settings.
> > > 
> > > Changes since v3:
> > > - Rebasing to mainline and testing.
> > > - Adding a new KVM_PAGE_ENC_BITMAP_RESET ioctl, which resets the 
> > >   page encryption bitmap on a guest reboot event.
> > > - Adding a more reliable sanity check for GPA range being passed to
> > >   the hypercall to ensure that guest MMIO ranges are also marked
> > >   in the page encryption bitmap.
> > > 
> > > Changes since v2:
> > >  - reset the page encryption bitmap on vcpu reboot
> > > 
> > > Changes since v1:
> > >  - Add support to share the page encryption between the source and target
> > >    machine.
> > >  - Fix review feedbacks from Tom Lendacky.
> > >  - Add check to limit the session blob length.
> > >  - Update KVM_GET_PAGE_ENC_BITMAP icotl to use the base_gfn instead of
> > >    the memory slot when querying the bitmap.
> > > 
> > > Ashish Kalra (3):
> > >   KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET ioctl
> > >   KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
> > >     Custom MSR.
> > >   KVM: x86: Add kexec support for SEV Live Migration.
> > > 
> > > Brijesh Singh (11):
> > >   KVM: SVM: Add KVM_SEV SEND_START command
> > >   KVM: SVM: Add KVM_SEND_UPDATE_DATA command
> > >   KVM: SVM: Add KVM_SEV_SEND_FINISH command
> > >   KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
> > >   KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
> > >   KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
> > >   KVM: x86: Add AMD SEV specific Hypercall3
> > >   KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
> > >   KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
> > >   mm: x86: Invoke hypercall when page encryption status is changed
> > >   KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
> > > 
> > >  .../virt/kvm/amd-memory-encryption.rst        | 120 +++
> > >  Documentation/virt/kvm/api.rst                |  62 ++
> > >  Documentation/virt/kvm/cpuid.rst              |   4 +
> > >  Documentation/virt/kvm/hypercalls.rst         |  15 +
> > >  Documentation/virt/kvm/msr.rst                |  10 +
> > >  arch/x86/include/asm/kvm_host.h               |  10 +
> > >  arch/x86/include/asm/kvm_para.h               |  12 +
> > >  arch/x86/include/asm/paravirt.h               |  10 +
> > >  arch/x86/include/asm/paravirt_types.h         |   2 +
> > >  arch/x86/include/uapi/asm/kvm_para.h          |   5 +
> > >  arch/x86/kernel/kvm.c                         |  32 +
> > >  arch/x86/kernel/paravirt.c                    |   1 +
> > >  arch/x86/kvm/cpuid.c                          |   3 +-
> > >  arch/x86/kvm/svm.c                            | 699 +++++++++++++++++-
> > >  arch/x86/kvm/vmx/vmx.c                        |   1 +
> > >  arch/x86/kvm/x86.c                            |  43 ++
> > >  arch/x86/mm/mem_encrypt.c                     |  69 +-
> > >  arch/x86/mm/pat/set_memory.c                  |   7 +
> > >  include/linux/psp-sev.h                       |   8 +-
> > >  include/uapi/linux/kvm.h                      |  53 ++
> > >  include/uapi/linux/kvm_para.h                 |   1 +
> > >  21 files changed, 1157 insertions(+), 10 deletions(-)
> > > 
> > > -- 
> > > 2.17.1
> > > 

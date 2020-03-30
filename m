Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC229198246
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 19:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgC3RZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 13:25:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39798 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728857AbgC3RZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 13:25:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02UHAhgl037907;
        Mon, 30 Mar 2020 17:24:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=G0GXAJNQb5hjmkZ6A5SHmuha8DBnqgARxYVn2+XxaJw=;
 b=oXpgKr1xcQjXtviSrKoM71zXnZVBpOJISA1c96DCVLpbaWF3Ibb/BfCR9inCLn+5TYFv
 n1Ef6qxwlG4uKBPODDYbEXupfWoiVeYNS03c1AtZ4p/pV6YjLKwRnbvNWPAJqwc24Q+u
 fYm0aiDDBd6Uu4mwFXpWU7IWjmg4aEFkYqLcJZDnMF1YFMCBDvRrgyjw1v5FToD/lDWm
 fFYNxhJ6Z3URWF1lEq2ABb4w6W7s9nheoDgzdt9XP8GAL6Lp1ZIw0Czw27t1+ulegoC6
 /3kDIkNwOEoVEU1gXoI1mv86mzUNQ47f5pgwbX/b9h8nonOxg/DEwmklj+6PbS46Vd+9 Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 303aqhbj7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 17:24:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02UHKvlO087337;
        Mon, 30 Mar 2020 17:24:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 302g2c907r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 17:24:59 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02UHOpMp015670;
        Mon, 30 Mar 2020 17:24:51 GMT
Received: from vbusired-dt (/10.154.170.177)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Mar 2020 10:24:51 -0700
Date:   Mon, 30 Mar 2020 12:24:46 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 00/14] Add AMD SEV guest live migration support
Message-ID: <20200330172446.GA584882@vbusired-dt>
References: <cover.1585548051.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1585548051.git.ashish.kalra@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9576 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003300153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9576 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003300153
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-30 06:19:27 +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The series add support for AMD SEV guest live migration commands. To protect the
> confidentiality of an SEV protected guest memory while in transit we need to
> use the SEV commands defined in SEV API spec [1].
> 
> SEV guest VMs have the concept of private and shared memory. Private memory
> is encrypted with the guest-specific key, while shared memory may be encrypted
> with hypervisor key. The commands provided by the SEV FW are meant to be used
> for the private memory only. The patch series introduces a new hypercall.
> The guest OS can use this hypercall to notify the page encryption status.
> If the page is encrypted with guest specific-key then we use SEV command during
> the migration. If page is not encrypted then fallback to default.
> 
> The patch adds new ioctls KVM_{SET,GET}_PAGE_ENC_BITMAP. The ioctl can be used
> by the qemu to get the page encrypted bitmap. Qemu can consult this bitmap
> during the migration to know whether the page is encrypted.
> 
> [1] https://developer.amd.com/wp-content/resources/55766.PDF
> 
> Changes since v5:
> - Fix build errors as
>   Reported-by: kbuild test robot <lkp@intel.com>

Which upstream tag should I use to apply this patch set? I tried the
top of Linus's tree, and I get the following error when I apply this
patch set.

$ git am PATCH-v6-01-14-KVM-SVM-Add-KVM_SEV-SEND_START-command.mbox
Applying: KVM: SVM: Add KVM_SEV SEND_START command
Applying: KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Applying: KVM: SVM: Add KVM_SEV_SEND_FINISH command
Applying: KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
error: patch failed: Documentation/virt/kvm/amd-memory-encryption.rst:375
error: Documentation/virt/kvm/amd-memory-encryption.rst: patch does not apply
error: patch failed: arch/x86/kvm/svm.c:7632
error: arch/x86/kvm/svm.c: patch does not apply
Patch failed at 0004 KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command

Thanks,

Venu

> 
> Changes since v4:
> - Host support has been added to extend KVM capabilities/feature bits to 
>   include a new KVM_FEATURE_SEV_LIVE_MIGRATION, which the guest can
>   query for host-side support for SEV live migration and a new custom MSR
>   MSR_KVM_SEV_LIVE_MIG_EN is added for guest to enable the SEV live
>   migration feature.
> - Ensure that _bss_decrypted section is marked as decrypted in the
>   page encryption bitmap.
> - Fixing KVM_GET_PAGE_ENC_BITMAP ioctl to return the correct bitmap
>   as per the number of pages being requested by the user. Ensure that
>   we only copy bmap->num_pages bytes in the userspace buffer, if
>   bmap->num_pages is not byte aligned we read the trailing bits
>   from the userspace and copy those bits as is. This fixes guest
>   page(s) corruption issues observed after migration completion.
> - Add kexec support for SEV Live Migration to reset the host's
>   page encryption bitmap related to kernel specific page encryption
>   status settings before we load a new kernel by kexec. We cannot
>   reset the complete page encryption bitmap here as we need to
>   retain the UEFI/OVMF firmware specific settings.
> 
> Changes since v3:
> - Rebasing to mainline and testing.
> - Adding a new KVM_PAGE_ENC_BITMAP_RESET ioctl, which resets the 
>   page encryption bitmap on a guest reboot event.
> - Adding a more reliable sanity check for GPA range being passed to
>   the hypercall to ensure that guest MMIO ranges are also marked
>   in the page encryption bitmap.
> 
> Changes since v2:
>  - reset the page encryption bitmap on vcpu reboot
> 
> Changes since v1:
>  - Add support to share the page encryption between the source and target
>    machine.
>  - Fix review feedbacks from Tom Lendacky.
>  - Add check to limit the session blob length.
>  - Update KVM_GET_PAGE_ENC_BITMAP icotl to use the base_gfn instead of
>    the memory slot when querying the bitmap.
> 
> Ashish Kalra (3):
>   KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET ioctl
>   KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
>     Custom MSR.
>   KVM: x86: Add kexec support for SEV Live Migration.
> 
> Brijesh Singh (11):
>   KVM: SVM: Add KVM_SEV SEND_START command
>   KVM: SVM: Add KVM_SEND_UPDATE_DATA command
>   KVM: SVM: Add KVM_SEV_SEND_FINISH command
>   KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
>   KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
>   KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
>   KVM: x86: Add AMD SEV specific Hypercall3
>   KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
>   KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
>   mm: x86: Invoke hypercall when page encryption status is changed
>   KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
> 
>  .../virt/kvm/amd-memory-encryption.rst        | 120 +++
>  Documentation/virt/kvm/api.rst                |  62 ++
>  Documentation/virt/kvm/cpuid.rst              |   4 +
>  Documentation/virt/kvm/hypercalls.rst         |  15 +
>  Documentation/virt/kvm/msr.rst                |  10 +
>  arch/x86/include/asm/kvm_host.h               |  10 +
>  arch/x86/include/asm/kvm_para.h               |  12 +
>  arch/x86/include/asm/paravirt.h               |  10 +
>  arch/x86/include/asm/paravirt_types.h         |   2 +
>  arch/x86/include/uapi/asm/kvm_para.h          |   5 +
>  arch/x86/kernel/kvm.c                         |  32 +
>  arch/x86/kernel/paravirt.c                    |   1 +
>  arch/x86/kvm/cpuid.c                          |   3 +-
>  arch/x86/kvm/svm.c                            | 699 +++++++++++++++++-
>  arch/x86/kvm/vmx/vmx.c                        |   1 +
>  arch/x86/kvm/x86.c                            |  43 ++
>  arch/x86/mm/mem_encrypt.c                     |  69 +-
>  arch/x86/mm/pat/set_memory.c                  |   7 +
>  include/linux/psp-sev.h                       |   8 +-
>  include/uapi/linux/kvm.h                      |  53 ++
>  include/uapi/linux/kvm_para.h                 |   1 +
>  21 files changed, 1157 insertions(+), 10 deletions(-)
> 
> -- 
> 2.17.1
> 

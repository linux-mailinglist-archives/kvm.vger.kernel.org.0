Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A724198363
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 20:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgC3S2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 14:28:55 -0400
Received: from mail-bn8nam12on2065.outbound.protection.outlook.com ([40.107.237.65]:6079
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgC3S2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 14:28:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJzUPj2RjqYUNMT8uGwGlq2vUu8TU5+X1VZiDOhqF/1PJrJ1J3JoPryTRmYuT74wtmIqvEr/TffKsbym30/WBcVyPy1SgqpSbpCUm0zN4KRP3Ohxh6lYnplqQKXrbrfR0GAbWAyAMsGU4gYDZV9wuEUD9zM/Jfgo3ilLYPtmFV1PAH47/nH6S8tUlxnh9j67iYE9yaqT2y0AajDaE80oGfS5qpl7FSfEhigPKh/ME9bCvf+QHfEJfKM5polXHp50UiOxjPjyoYP1BacC5VPAvmBQ9Jp0xj0pcJlU/ykeaY79CfAarJS2CS97o4ZAS5DhoXtRdmkpfi5r68dRr5fTbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EYMuNwiPeT2FZlq0oW7bH6/P9EtVfDm+m588vILSBM=;
 b=Yap44JvZ61NjV/out4BBqjAyzUR3nphKer2cuR4DT3oOeNJQ+PB2qsa3Zr0jwuAwd29QLKQpITuyRFJZ5fydRUNoeFfiF9BqvhVZn4Mi7WlwFXJHzskSIXFWl9VIu41q482k4RK32alt2GUueAB9RzKQoxJl58qGFgcMJYBeqoxzpI/6WpqHPtuo+GvSWu/D+3ItlvDVs1BW04lmAn5P6UOGGd+pvTRJIED//f/8W8GNVFO3CFn35NBq2mFcsKAjxyqvgT6BppCO9CJh4uLeP9eABV/XU7NituoX60WJrMeoeMKXeN1ftMFzlrzSmGOy6MYRbdhbLSIuuJf61TXl8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EYMuNwiPeT2FZlq0oW7bH6/P9EtVfDm+m588vILSBM=;
 b=vXAqeDkPIOnn4Xnqn8HFiLoc6pH3CHgy4mJuVuaR/jLwhzFUJDx6oaQ/R+IjtaR6a7n17OMqPri14bk0bm4EqU2tiIaNgTXAAKYTqZ0aTGUq4SR50xgtbdKecjr+8155A6TP6gcuogG9dzmfkYDeu+xw5SUl/ENUoTwLBt97HXU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2582.namprd12.prod.outlook.com (2603:10b6:4:b5::37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Mon, 30 Mar 2020 18:28:52 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 18:28:51 +0000
Date:   Mon, 30 Mar 2020 18:28:45 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Venu Busireddy <venu.busireddy@oracle.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 00/14] Add AMD SEV guest live migration support
Message-ID: <20200330182845.GA21740@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <20200330172446.GA584882@vbusired-dt>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330172446.GA584882@vbusired-dt>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN1PR12CA0088.namprd12.prod.outlook.com
 (2603:10b6:802:21::23) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN1PR12CA0088.namprd12.prod.outlook.com (2603:10b6:802:21::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 18:28:50 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3fb89fb6-9a23-4d1e-76aa-08d7d4d8322d
X-MS-TrafficTypeDiagnostic: DM5PR12MB2582:|DM5PR12MB2582:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2582ED756B8FE38BD02D23D18ECB0@DM5PR12MB2582.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(186003)(4326008)(16526019)(86362001)(81166006)(44832011)(8936002)(956004)(6666004)(81156014)(5660300002)(6496006)(1076003)(53546011)(52116002)(33656002)(66556008)(33716001)(45080400002)(26005)(8676002)(66476007)(478600001)(55016002)(66946007)(9686003)(2906002)(7416002)(316002)(6916009)(966005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WwtdXedJ9fIiek9ilqtHEjMmBw7kfMviK6YSzVC9VGHjhAZpeJl4YePJKBzbJ46z80+TXEkSNfT3seO937W6GW32LbfGSOLU5jBwwV+z1WuRbB06SGYp0Q9S7rhRoAfaXdATsd4L8KeHBpmaOOt/8o1pCvm4GRwHPZVdUPYOYTyYmhspges/et5B5D8D44U728tdWtK4KgLURCshhRhRHmcAypg3txjEBBQw7oFdX2RDFpqa7GDXv1fpu/MguVdJEU29JmeXkOIDECL3qpg4DgUXMU0kpqOsgSJ2CsCcIcxhwRK6eC9Pl0GeC/BF+1LWDUcGH0P0NUzenalctNm14nzW2eFJ8U/bZN+rVr5cxrSoygxz++58SUNqArZj+46R0r7Q7zByDQipQYUpSSiqCJfjsvm4DwvcuGM3GUeU5mSkMsd+sFmpX1M+em7KkucM9Ux7tIrdyEOEKe/tRSzdrnXUiOwqU0aG3VMYgcMQFr/YjEcvzkqLYV3hopkAsc2snw9kMSwnPGVGwGZqiJJUbg==
X-MS-Exchange-AntiSpam-MessageData: ERLzSLGSonEfbNu3tC8CV/B3CajssN6NiEWEkmxHdrhRis5DeKmdqk+gr4LnHdWWcbkfguL+FVeoaxI4tvIz5AKEgvwgR00GhdsZVjM1cWSifSLtuHuLJtjltIXOmzDLBjfYHiAjyiFSuEMssJRykA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb89fb6-9a23-4d1e-76aa-08d7d4d8322d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 18:28:51.8308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QFqOQieoN+4uOfrt6j43LtjiPay4nyf1njWnbNv8FIQMrFQD5Ku82Y1IIvfecqR8jc0+oCCO2twufqi+p9qGww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2582
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is applied on top of Linux 5.6, as per commit below :

commit 7111951b8d4973bda27ff663f2cf18b663d15b48 (tag: v5.6, origin/master, origin/HEAD)
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Mar 29 15:25:41 2020 -0700

    Linux 5.6

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Thanks,
Ashish

On Mon, Mar 30, 2020 at 12:24:46PM -0500, Venu Busireddy wrote:
> On 2020-03-30 06:19:27 +0000, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> > 
> > The series add support for AMD SEV guest live migration commands. To protect the
> > confidentiality of an SEV protected guest memory while in transit we need to
> > use the SEV commands defined in SEV API spec [1].
> > 
> > SEV guest VMs have the concept of private and shared memory. Private memory
> > is encrypted with the guest-specific key, while shared memory may be encrypted
> > with hypervisor key. The commands provided by the SEV FW are meant to be used
> > for the private memory only. The patch series introduces a new hypercall.
> > The guest OS can use this hypercall to notify the page encryption status.
> > If the page is encrypted with guest specific-key then we use SEV command during
> > the migration. If page is not encrypted then fallback to default.
> > 
> > The patch adds new ioctls KVM_{SET,GET}_PAGE_ENC_BITMAP. The ioctl can be used
> > by the qemu to get the page encrypted bitmap. Qemu can consult this bitmap
> > during the migration to know whether the page is encrypted.
> > 
> > [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdeveloper.amd.com%2Fwp-content%2Fresources%2F55766.PDF&amp;data=02%7C01%7CAshish.Kalra%40amd.com%7Cb87828d7e1eb41fe401c08d7d4cf4937%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637211859771455979&amp;sdata=yN1OrvcuNb%2F8JAaLwlf2pIJtEvBRFOSvTKPYWz9ASUY%3D&amp;reserved=0
> > 
> > Changes since v5:
> > - Fix build errors as
> >   Reported-by: kbuild test robot <lkp@intel.com>
> 
> Which upstream tag should I use to apply this patch set? I tried the
> top of Linus's tree, and I get the following error when I apply this
> patch set.
> 
> $ git am PATCH-v6-01-14-KVM-SVM-Add-KVM_SEV-SEND_START-command.mbox
> Applying: KVM: SVM: Add KVM_SEV SEND_START command
> Applying: KVM: SVM: Add KVM_SEND_UPDATE_DATA command
> Applying: KVM: SVM: Add KVM_SEV_SEND_FINISH command
> Applying: KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
> error: patch failed: Documentation/virt/kvm/amd-memory-encryption.rst:375
> error: Documentation/virt/kvm/amd-memory-encryption.rst: patch does not apply
> error: patch failed: arch/x86/kvm/svm.c:7632
> error: arch/x86/kvm/svm.c: patch does not apply
> Patch failed at 0004 KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
> 
> Thanks,
> 
> Venu
> 
> > 
> > Changes since v4:
> > - Host support has been added to extend KVM capabilities/feature bits to 
> >   include a new KVM_FEATURE_SEV_LIVE_MIGRATION, which the guest can
> >   query for host-side support for SEV live migration and a new custom MSR
> >   MSR_KVM_SEV_LIVE_MIG_EN is added for guest to enable the SEV live
> >   migration feature.
> > - Ensure that _bss_decrypted section is marked as decrypted in the
> >   page encryption bitmap.
> > - Fixing KVM_GET_PAGE_ENC_BITMAP ioctl to return the correct bitmap
> >   as per the number of pages being requested by the user. Ensure that
> >   we only copy bmap->num_pages bytes in the userspace buffer, if
> >   bmap->num_pages is not byte aligned we read the trailing bits
> >   from the userspace and copy those bits as is. This fixes guest
> >   page(s) corruption issues observed after migration completion.
> > - Add kexec support for SEV Live Migration to reset the host's
> >   page encryption bitmap related to kernel specific page encryption
> >   status settings before we load a new kernel by kexec. We cannot
> >   reset the complete page encryption bitmap here as we need to
> >   retain the UEFI/OVMF firmware specific settings.
> > 
> > Changes since v3:
> > - Rebasing to mainline and testing.
> > - Adding a new KVM_PAGE_ENC_BITMAP_RESET ioctl, which resets the 
> >   page encryption bitmap on a guest reboot event.
> > - Adding a more reliable sanity check for GPA range being passed to
> >   the hypercall to ensure that guest MMIO ranges are also marked
> >   in the page encryption bitmap.
> > 
> > Changes since v2:
> >  - reset the page encryption bitmap on vcpu reboot
> > 
> > Changes since v1:
> >  - Add support to share the page encryption between the source and target
> >    machine.
> >  - Fix review feedbacks from Tom Lendacky.
> >  - Add check to limit the session blob length.
> >  - Update KVM_GET_PAGE_ENC_BITMAP icotl to use the base_gfn instead of
> >    the memory slot when querying the bitmap.
> > 
> > Ashish Kalra (3):
> >   KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET ioctl
> >   KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
> >     Custom MSR.
> >   KVM: x86: Add kexec support for SEV Live Migration.
> > 
> > Brijesh Singh (11):
> >   KVM: SVM: Add KVM_SEV SEND_START command
> >   KVM: SVM: Add KVM_SEND_UPDATE_DATA command
> >   KVM: SVM: Add KVM_SEV_SEND_FINISH command
> >   KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
> >   KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
> >   KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
> >   KVM: x86: Add AMD SEV specific Hypercall3
> >   KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
> >   KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
> >   mm: x86: Invoke hypercall when page encryption status is changed
> >   KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
> > 
> >  .../virt/kvm/amd-memory-encryption.rst        | 120 +++
> >  Documentation/virt/kvm/api.rst                |  62 ++
> >  Documentation/virt/kvm/cpuid.rst              |   4 +
> >  Documentation/virt/kvm/hypercalls.rst         |  15 +
> >  Documentation/virt/kvm/msr.rst                |  10 +
> >  arch/x86/include/asm/kvm_host.h               |  10 +
> >  arch/x86/include/asm/kvm_para.h               |  12 +
> >  arch/x86/include/asm/paravirt.h               |  10 +
> >  arch/x86/include/asm/paravirt_types.h         |   2 +
> >  arch/x86/include/uapi/asm/kvm_para.h          |   5 +
> >  arch/x86/kernel/kvm.c                         |  32 +
> >  arch/x86/kernel/paravirt.c                    |   1 +
> >  arch/x86/kvm/cpuid.c                          |   3 +-
> >  arch/x86/kvm/svm.c                            | 699 +++++++++++++++++-
> >  arch/x86/kvm/vmx/vmx.c                        |   1 +
> >  arch/x86/kvm/x86.c                            |  43 ++
> >  arch/x86/mm/mem_encrypt.c                     |  69 +-
> >  arch/x86/mm/pat/set_memory.c                  |   7 +
> >  include/linux/psp-sev.h                       |   8 +-
> >  include/uapi/linux/kvm.h                      |  53 ++
> >  include/uapi/linux/kvm_para.h                 |   1 +
> >  21 files changed, 1157 insertions(+), 10 deletions(-)
> > 
> > -- 
> > 2.17.1
> > 

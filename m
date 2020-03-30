Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130281986DB
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 23:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbgC3Vzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 17:55:32 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:23017
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728880AbgC3Vzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 17:55:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUIUXyWModxunggr9UuNVL3GIKYWAww2yQfp3k7Bg52DwXo6A1+EoSsUGdCuSfKY+vTIampRsoMrbVVBZqCCo6qla3IGP72szhM6nNjtMmfD7keB5xfyljg1QXJF0OibhadL5H5egFZNG7q9RlFwuwfQ7wjeBfLst5PwR5SwhlCy7et9OzXG27D63ygdSk+6j3J3TAgR31YmsxAwjX8WH57SecvO7kZNgGRlGTmiwUeVcOdYPdOQ8af6yWyPqMRgSXV6QPFzFhr36JZkpbPS0sxO4JF0BkKErbwtrAr3nfpQEM+gSGLJbZ5p6umtM73mea+OwgvC7AuFVqBF9+12Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOLUlAI3XsNHBzv2BVCSTHrCkS09P+Wtmx9vvnS+Tgk=;
 b=eYA3C7zlUjbdljCQkcDEUjHc+LuIfWqm+6zEptnQ5VssGLi/O1eVr4vfhbhJnSemTyXuu+skL1tVWN7GHly40ACJCrDtwuuOpJbZ/8rp4yR4XZYSEg61h8UCUR5B9/LrcGoFhpsyOKLop8J+JMw2BbrglFeLNrCSPfva4fNEuvQ2Z2QieoWPHJUWGWpkeGTlQOLLbJ4M5oKVVxjmw44Ik9TFzRgPMt5G17boZBu4Af0/qd1dbFY6JH0XVdo8mp/z9FkaD2XxflvHnZkqUSwaN1pvCbkpaF3HNBBsxHLEz8ySHpdeuzbYE4mva6UPC3RjZhkxh2zshu+/QQpJvFKwPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOLUlAI3XsNHBzv2BVCSTHrCkS09P+Wtmx9vvnS+Tgk=;
 b=Buux3xYgHFXhWWLrXqSeOjAEe3RKAm225QxAWFLoIYv9osDnZJEkhl57Tt907D77EBORgw7OSl3zsspNvfbVGYuNwk/mpmiR2yEcW2zM/bIWM6OP1+M4jwl+mS+Rwxbl+1m2xhUpnHE/GmyjovaJfT/QRPt2t0pv03M6TQqZZoE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1545.namprd12.prod.outlook.com (2603:10b6:4:7::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 21:52:51 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 21:52:51 +0000
Date:   Mon, 30 Mar 2020 21:52:45 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Venu Busireddy <venu.busireddy@oracle.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 00/14] Add AMD SEV guest live migration support
Message-ID: <20200330215245.GA22453@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <20200330172446.GA584882@vbusired-dt>
 <20200330182845.GA21740@ashkalra_ubuntu_server>
 <20200330191307.GA586407@vbusired-dt>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330191307.GA586407@vbusired-dt>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:3:d4::29) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR05CA0019.namprd05.prod.outlook.com (2603:10b6:3:d4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.11 via Frontend Transport; Mon, 30 Mar 2020 21:52:50 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: be39b1e1-6b04-4098-a810-08d7d4f4b148
X-MS-TrafficTypeDiagnostic: DM5PR12MB1545:|DM5PR12MB1545:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1545F48F7309E973C93C55C98ECB0@DM5PR12MB1545.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(55016002)(186003)(6916009)(6666004)(5660300002)(966005)(7416002)(66946007)(33656002)(66476007)(66556008)(1076003)(26005)(9686003)(16526019)(45080400002)(81166006)(6496006)(8936002)(52116002)(4326008)(86362001)(316002)(33716001)(53546011)(2906002)(8676002)(81156014)(44832011)(956004)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ru2rOm2RJoNafOrzI2RBhpd8iLFLT2SfOLyjvlv8HSTpjjukO66zfHO+xL6D5aifpjgozhys7UcFC59AmiAozMWimxx18YfEN9dsW815W8WqZRTayY8i7set5ec1CcrxQZXC/w2UaU77v+9Jpq4LbR69Hn086xJC0eh30js6nONu4gOgSxErzLvPX2jUBDDymn77bmAKwJAycyuwlJUyES5xtvrpcOSJkrM455h7vFp0LDe/VLk+mEBykHsC/6rLgRU5ne70vYu/Ehmjcuj55uR4dzEEFwYfSI7ig3eNsOV+7yZcqDVVEAzZUJ6vedU/t/BRDUWU3I467Kd59PB6AAUqeBIjOzdeSGzznPriuqjB+69woUo8WHA6O0zlaFOR7B4vsUd6VC5Zm7KsDmlpNDAYftfbihTzFUYxrv1URKXADE+5ScqNdPO1rpCUi7ON0chBi4gtu0Fb13+pP9R2Fe4vZuNYUTIgtSHCvaRD6TzOqBbYsG+e+h+glt7enTdmx0kQ0W6pWagNgAoXEuMWKQ==
X-MS-Exchange-AntiSpam-MessageData: 07PKawROk9PSfnPC7B2yaE/SlqsAz5b/96EoYRz8IWVEFVlgIS7xZmVz+dQD4jANhJdS2eDF6RxVI9vM/fB5MWFW59E0jd3wGiztkvyw1mXg79kqIbr8cIsxm323cO8Ais0iRfmMea/DXHt3WWuJOw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be39b1e1-6b04-4098-a810-08d7d4f4b148
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 21:52:51.0171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWpvSuW02HgiF/9cypltxnfD+YSb2kAnbiq6hJzv1Xm/u3Rn4AaMtL3Cioodc3wym3RA203Psog5pmLA7BwoNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1545
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I just did a fresh install of Linus's tree and i can install these
patches cleanly on top of the tree.

Thanks,
Ashish

On Mon, Mar 30, 2020 at 02:13:07PM -0500, Venu Busireddy wrote:
> On 2020-03-30 18:28:45 +0000, Ashish Kalra wrote:
> > This is applied on top of Linux 5.6, as per commit below :
> > 
> > commit 7111951b8d4973bda27ff663f2cf18b663d15b48 (tag: v5.6, origin/master, origin/HEAD)
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Sun Mar 29 15:25:41 2020 -0700
> > 
> >     Linux 5.6
> > 
> >  Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Not sure what I am missing here! This the current state of my sandbox:
> 
> $ git remote -v
> origin  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git (fetch)
> origin  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git (push)
> 
> $ git log --oneline
> 12acbbfef749 (HEAD -> master) KVM: SVM: Add KVM_SEV_SEND_FINISH command
> e5f21e48bfff KVM: SVM: Add KVM_SEND_UPDATE_DATA command
> 6b2bcf682d08 KVM: SVM: Add KVM_SEV SEND_START command
> 7111951b8d49 (tag: v5.6, origin/master, origin/HEAD) Linux 5.6
> 
> $ git status
> On branch master
> Your branch is ahead of 'origin/master' by 3 commits.
> 
> As can be seen, I started with the commit (7111951b8d49) you mentioned.
> I could apply 3 of the patches, but 04/14 is failing.
> 
> Any suggestions?
> 
> Thanks,
> 
> Venu
> 
> > Thanks,
> > Ashish
> > 
> > On Mon, Mar 30, 2020 at 12:24:46PM -0500, Venu Busireddy wrote:
> > > On 2020-03-30 06:19:27 +0000, Ashish Kalra wrote:
> > > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > > 
> > > > The series add support for AMD SEV guest live migration commands. To protect the
> > > > confidentiality of an SEV protected guest memory while in transit we need to
> > > > use the SEV commands defined in SEV API spec [1].
> > > > 
> > > > SEV guest VMs have the concept of private and shared memory. Private memory
> > > > is encrypted with the guest-specific key, while shared memory may be encrypted
> > > > with hypervisor key. The commands provided by the SEV FW are meant to be used
> > > > for the private memory only. The patch series introduces a new hypercall.
> > > > The guest OS can use this hypercall to notify the page encryption status.
> > > > If the page is encrypted with guest specific-key then we use SEV command during
> > > > the migration. If page is not encrypted then fallback to default.
> > > > 
> > > > The patch adds new ioctls KVM_{SET,GET}_PAGE_ENC_BITMAP. The ioctl can be used
> > > > by the qemu to get the page encrypted bitmap. Qemu can consult this bitmap
> > > > during the migration to know whether the page is encrypted.
> > > > 
> > > > [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdeveloper.amd.com%2Fwp-content%2Fresources%2F55766.PDF&amp;data=02%7C01%7Cashish.kalra%40amd.com%7C2546be8861e3409b9d3408d7d4de683c%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637211924007781552&amp;sdata=lYAGaXWFveawb7Fre8Qo7iGyKcLREiodSgQswMBirHc%3D&amp;reserved=0
> > > > 
> > > > Changes since v5:
> > > > - Fix build errors as
> > > >   Reported-by: kbuild test robot <lkp@intel.com>
> > > 
> > > Which upstream tag should I use to apply this patch set? I tried the
> > > top of Linus's tree, and I get the following error when I apply this
> > > patch set.
> > > 
> > > $ git am PATCH-v6-01-14-KVM-SVM-Add-KVM_SEV-SEND_START-command.mbox
> > > Applying: KVM: SVM: Add KVM_SEV SEND_START command
> > > Applying: KVM: SVM: Add KVM_SEND_UPDATE_DATA command
> > > Applying: KVM: SVM: Add KVM_SEV_SEND_FINISH command
> > > Applying: KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
> > > error: patch failed: Documentation/virt/kvm/amd-memory-encryption.rst:375
> > > error: Documentation/virt/kvm/amd-memory-encryption.rst: patch does not apply
> > > error: patch failed: arch/x86/kvm/svm.c:7632
> > > error: arch/x86/kvm/svm.c: patch does not apply
> > > Patch failed at 0004 KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
> > > 
> > > Thanks,
> > > 
> > > Venu
> > > 
> > > > 
> > > > Changes since v4:
> > > > - Host support has been added to extend KVM capabilities/feature bits to 
> > > >   include a new KVM_FEATURE_SEV_LIVE_MIGRATION, which the guest can
> > > >   query for host-side support for SEV live migration and a new custom MSR
> > > >   MSR_KVM_SEV_LIVE_MIG_EN is added for guest to enable the SEV live
> > > >   migration feature.
> > > > - Ensure that _bss_decrypted section is marked as decrypted in the
> > > >   page encryption bitmap.
> > > > - Fixing KVM_GET_PAGE_ENC_BITMAP ioctl to return the correct bitmap
> > > >   as per the number of pages being requested by the user. Ensure that
> > > >   we only copy bmap->num_pages bytes in the userspace buffer, if
> > > >   bmap->num_pages is not byte aligned we read the trailing bits
> > > >   from the userspace and copy those bits as is. This fixes guest
> > > >   page(s) corruption issues observed after migration completion.
> > > > - Add kexec support for SEV Live Migration to reset the host's
> > > >   page encryption bitmap related to kernel specific page encryption
> > > >   status settings before we load a new kernel by kexec. We cannot
> > > >   reset the complete page encryption bitmap here as we need to
> > > >   retain the UEFI/OVMF firmware specific settings.
> > > > 
> > > > Changes since v3:
> > > > - Rebasing to mainline and testing.
> > > > - Adding a new KVM_PAGE_ENC_BITMAP_RESET ioctl, which resets the 
> > > >   page encryption bitmap on a guest reboot event.
> > > > - Adding a more reliable sanity check for GPA range being passed to
> > > >   the hypercall to ensure that guest MMIO ranges are also marked
> > > >   in the page encryption bitmap.
> > > > 
> > > > Changes since v2:
> > > >  - reset the page encryption bitmap on vcpu reboot
> > > > 
> > > > Changes since v1:
> > > >  - Add support to share the page encryption between the source and target
> > > >    machine.
> > > >  - Fix review feedbacks from Tom Lendacky.
> > > >  - Add check to limit the session blob length.
> > > >  - Update KVM_GET_PAGE_ENC_BITMAP icotl to use the base_gfn instead of
> > > >    the memory slot when querying the bitmap.
> > > > 
> > > > Ashish Kalra (3):
> > > >   KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET ioctl
> > > >   KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
> > > >     Custom MSR.
> > > >   KVM: x86: Add kexec support for SEV Live Migration.
> > > > 
> > > > Brijesh Singh (11):
> > > >   KVM: SVM: Add KVM_SEV SEND_START command
> > > >   KVM: SVM: Add KVM_SEND_UPDATE_DATA command
> > > >   KVM: SVM: Add KVM_SEV_SEND_FINISH command
> > > >   KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
> > > >   KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
> > > >   KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
> > > >   KVM: x86: Add AMD SEV specific Hypercall3
> > > >   KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
> > > >   KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
> > > >   mm: x86: Invoke hypercall when page encryption status is changed
> > > >   KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
> > > > 
> > > >  .../virt/kvm/amd-memory-encryption.rst        | 120 +++
> > > >  Documentation/virt/kvm/api.rst                |  62 ++
> > > >  Documentation/virt/kvm/cpuid.rst              |   4 +
> > > >  Documentation/virt/kvm/hypercalls.rst         |  15 +
> > > >  Documentation/virt/kvm/msr.rst                |  10 +
> > > >  arch/x86/include/asm/kvm_host.h               |  10 +
> > > >  arch/x86/include/asm/kvm_para.h               |  12 +
> > > >  arch/x86/include/asm/paravirt.h               |  10 +
> > > >  arch/x86/include/asm/paravirt_types.h         |   2 +
> > > >  arch/x86/include/uapi/asm/kvm_para.h          |   5 +
> > > >  arch/x86/kernel/kvm.c                         |  32 +
> > > >  arch/x86/kernel/paravirt.c                    |   1 +
> > > >  arch/x86/kvm/cpuid.c                          |   3 +-
> > > >  arch/x86/kvm/svm.c                            | 699 +++++++++++++++++-
> > > >  arch/x86/kvm/vmx/vmx.c                        |   1 +
> > > >  arch/x86/kvm/x86.c                            |  43 ++
> > > >  arch/x86/mm/mem_encrypt.c                     |  69 +-
> > > >  arch/x86/mm/pat/set_memory.c                  |   7 +
> > > >  include/linux/psp-sev.h                       |   8 +-
> > > >  include/uapi/linux/kvm.h                      |  53 ++
> > > >  include/uapi/linux/kvm_para.h                 |   1 +
> > > >  21 files changed, 1157 insertions(+), 10 deletions(-)
> > > > 
> > > > -- 
> > > > 2.17.1
> > > > 

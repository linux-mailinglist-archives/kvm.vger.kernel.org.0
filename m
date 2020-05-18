Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15861D87D6
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 21:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgERTHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 15:07:22 -0400
Received: from mail-dm6nam12on2066.outbound.protection.outlook.com ([40.107.243.66]:23105
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726378AbgERTHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 15:07:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXDXk4Ok17Ey0UYd5A0CAGt28n1uwLpEOPzEL3A3tun1WuBoTxecGuy0deUcYHqitdqSPQaIqJkra5+Otyw9NitLugE1m8o8EcnLTqKwbFo019LcM+UzYqAna5NawP6h7BbLOKOAgOQB/MCd8iec9HZyQhXcHyogwAZEEd3R2IPX7+UFNjYBLqxKLrNlB0KBE3HZAkfsxmwCoAZC9lkb8UgaCcQ6pvY+asEMB14xdZfCc3TKRLLxmn1+2De9JZBPe/IGHD/2HoVbdestjFe5KhpB92Zw0maOKZ0AYpc0JGZBYFTxk+P45M4g+4BSGJikr7k8nBWJJMRtfH/cAdiatA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SV9R8lOK5y6ajqdrrEOQyg0SBeevl3oGK1mI0IkLXM=;
 b=MAaCCxQmpusRXZLY7bPVNO/6sFZYE7X0fJ6uTmhuClVUdd5gplmjoHA6ZsU/DhHpfXl6eR1ZWDjHfBg2c+yfYfoAhLMBOAqeG40lGjqg0c2Q7WmyIWJgkCo926YV7JhDdwVyi6hRniygZGJ/EOgUr9ALPSYCZrAs7IDIQWqDjsFasqSbFEijJ1VzLhSgAE2CLJI7ijPJhqBysLHJYWeRm54kD4pA4g5MXqL8pjBpEYtQ3YTI+AHzEA3QUxeN6WkZ2pvG9ffmt/XGlqelnDYIWkO/ovr1AYZy8Y4pf8vWGb6OUenF0kiJjtk1gE/TBlt+JtI+wGdpvepQHgVwg3DDZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SV9R8lOK5y6ajqdrrEOQyg0SBeevl3oGK1mI0IkLXM=;
 b=338IIBjc7EWNRs2U4PyVodzdtvHn0UBe2ag3QSHZviAFq+vtFnKXeCnwodXA1P3lF0ita5Yg39Pz0bXv3dGis1B+HFcsbWv6Pv+dnW7IOsnxpN4ejFtuoTe0FSiZxzhDnekAjjF8+2DAqOfySgDBGBM6Y+VHS214rqqIlqAyNSk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1803.namprd12.prod.outlook.com (2603:10b6:3:10d::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.20; Mon, 18 May 2020 19:07:14 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 19:07:14 +0000
Date:   Mon, 18 May 2020 19:07:08 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v8 00/18] Add AMD SEV guest live migration support
Message-ID: <20200518190708.GA7929@ashkalra_ubuntu_server>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN4PR0201CA0048.namprd02.prod.outlook.com
 (2603:10b6:803:2e::34) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0201CA0048.namprd02.prod.outlook.com (2603:10b6:803:2e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Mon, 18 May 2020 19:07:13 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1abb79c4-9c1b-49b9-4e25-08d7fb5ead1c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1803:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB18038E6CF9CF5E8F2BBF8C648EB80@DM5PR12MB1803.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:369;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pKEFEOVVAIAWWRve7+GNsNhwU02Qhr3cVdMKO3GEJrvv5UH9JhgFNq2/JGDkRQp8/Sa9fSiWrU/3qVfQozgcg4mrhDZh8cXLpjOdWWaJK/MwJ4jWFmyfBfFZRQPkKO8Kat3F/aBGpmfTCBE4q3FVlfJtOlbjCB0lLDpVr1+we6yCf9F3hFfpjlqSo5wii0cnUypjrrXHCi2xXuQgp8NucCTB/GB5LMnmLFJnJfNds2TIvr6tRh0uR5URRda0EYqsq7vCYyyab1raJLVw+ln53Ah2laBmMv5Hy1dxWr6hRGpmekRQf6gIoi6K+BGLfPViUqop0sGioy52jIUNE6uLCKXzh6UfgRmoDVkusAVyB8IUKD1X9ZqQipgPSSd4/5shvEdZUZu/lwBUsk+JpbUPbBbBNrzWA9hETKFjZOWxb9ExIlOTbuCZIyura9CeNviRucSFCpeCT0yggDwdG0LiZnC1KtgBb2apOPzUhSZ2UhMr/jNlkV9fTxiWN8l808/3DvTxthKUYxlScqOv1SwUVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(66556008)(33716001)(478600001)(6916009)(5660300002)(33656002)(966005)(86362001)(6666004)(26005)(8676002)(55016002)(7416002)(66476007)(66946007)(16526019)(4326008)(8936002)(2906002)(1076003)(186003)(44832011)(52116002)(316002)(956004)(9686003)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3Q0EiSnqaQGymS5JFDlsp9WLv6FzJsbgu4xMVhm5T+qu4x0w+YHQlhvt9oLNpCx1lTnZ5wfZnBQxAMsorAXxVantprrkfDYlaQ01fF1Q6ACUkepydqxj7tEGkmj6YEN1fnbMLaMKBmeDbz412/Wj9DwiWkATvIAyExczPm8ObAcpNvL0SxKeo2IuPhUWIzwD1AJUD1mQ9yhUJC1XnQj6yuUvN4QKb3BNNgYg0P+DPxRE5vOvQTTo8PN6sLBC4Uxcwdfjvfh86HCbXZVsRilu9Hxj1gKSzyA1wRBaevKEVWWH9CesXDa3NCjX24bzD1o1csXe27fRabr6rQs+lpO18a34OgTjp55gMOfJxKP1DXiaDMBZGLEKVLwzlcLOdI9q4y39rAxHvPR3crz0a3rjZ9pXHr6E02LHBh2N9UWX/bmFgpwD3k0GpcR92QKAQfcQaDGz5zvqsuJvpX231CXvVgRn6X0NDe2CaUPS8NLvkyc=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1abb79c4-9c1b-49b9-4e25-08d7fb5ead1c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 19:07:14.7823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQL8qO4T4Gp8QFjqO59hejFI8tfQF9pCHMv8iCyDkaOR1OPAYhIn/KUzaJYtFY5H09sPUdoHRf3FsSJ10D475A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1803
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello All,

Any other feedback, review or comments on this patch-set ?

Thanks,
Ashish

On Tue, May 05, 2020 at 09:13:49PM +0000, Ashish Kalra wrote:
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
> This section descibes how the SEV live migration feature is negotiated
> between the host and guest, the host indicates this feature support via 
> KVM_FEATURE_CPUID. The guest firmware (OVMF) detects this feature and
> sets a UEFI enviroment variable indicating OVMF support for live
> migration, the guest kernel also detects the host support for this
> feature via cpuid and in case of an EFI boot verifies if OVMF also
> supports this feature by getting the UEFI enviroment variable and if it
> set then enables live migration feature on host by writing to a custom
> MSR, if not booted under EFI, then it simply enables the feature by
> again writing to the custom MSR. The host returns error as part of
> SET_PAGE_ENC_BITMAP ioctl if guest has not enabled live migration.
> 
> A branch containing these patches is available here:
> https://github.com/AMDESE/linux/tree/sev-migration-v8
> 
> [1] https://developer.amd.com/wp-content/resources/55766.PDF
> 
> Changes since v7:
> - Removed the hypervisor specific hypercall/paravirt callback for
>   SEV live migration and moved back to calling kvm_sev_hypercall3 
>   directly.
> - Fix build errors as
>   Reported-by: kbuild test robot <lkp@intel.com>, specifically fixed
>   build error when CONFIG_HYPERVISOR_GUEST=y and
>   CONFIG_AMD_MEM_ENCRYPT=n.
> - Implicitly enabled live migration for incoming VM(s) to handle 
>   A->B->C->... VM migrations.
> - Fixed Documentation as per comments on v6 patches.
> - Fixed error return path in sev_send_update_data() as per comments 
>   on v6 patches. 
> 
> Changes since v6:
> - Rebasing to mainline and refactoring to the new split SVM
>   infrastructre.
> - Move to static allocation of the unified Page Encryption bitmap
>   instead of the dynamic resizing of the bitmap, the static allocation
>   is done implicitly by extending kvm_arch_commit_memory_region() callack
>   to add svm specific x86_ops which can read the userspace provided memory
>   region/memslots and calculate the amount of guest RAM managed by the KVM
>   and grow the bitmap.
> - Fixed KVM_SET_PAGE_ENC_BITMAP ioctl to set the whole bitmap instead
>   of simply clearing specific bits.
> - Removed KVM_PAGE_ENC_BITMAP_RESET ioctl, which is now performed using
>   KVM_SET_PAGE_ENC_BITMAP.
> - Extended guest support for enabling Live Migration feature by adding a
>   check for UEFI environment variable indicating OVMF support for Live
>   Migration feature and additionally checking for KVM capability for the
>   same feature. If not booted under EFI, then we simply check for KVM
>   capability.
> - Add hypervisor specific hypercall for SEV live migration by adding
>   a new paravirt callback as part of x86_hyper_runtime.
>   (x86 hypervisor specific runtime callbacks)
> - Moving MSR handling for MSR_KVM_SEV_LIVE_MIG_EN into svm/sev code 
>   and adding check for SEV live migration enabled by guest in the 
>   KVM_GET_PAGE_ENC_BITMAP ioctl.
> - Instead of the complete __bss_decrypted section, only specific variables
>   such as hv_clock_boot and wall_clock are marked as decrypted in the
>   page encryption bitmap
> 
> Changes since v5:
> - Fix build errors as
>   Reported-by: kbuild test robot <lkp@intel.com>
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
> Ashish Kalra (7):
>   KVM: SVM: Add support for static allocation of unified Page Encryption
>     Bitmap.
>   KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
>     Custom MSR.
>   EFI: Introduce the new AMD Memory Encryption GUID.
>   KVM: x86: Add guest support for detecting and enabling SEV Live
>     Migration feature.
>   KVM: x86: Mark _bss_decrypted section variables as decrypted in page
>     encryption bitmap.
>   KVM: x86: Add kexec support for SEV Live Migration.
>   KVM: SVM: Enable SEV live migration feature implicitly on Incoming
>     VM(s).
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
>  Documentation/virt/kvm/api.rst                |  71 ++
>  Documentation/virt/kvm/cpuid.rst              |   5 +
>  Documentation/virt/kvm/hypercalls.rst         |  15 +
>  Documentation/virt/kvm/msr.rst                |  10 +
>  arch/x86/include/asm/kvm_host.h               |   7 +
>  arch/x86/include/asm/kvm_para.h               |  12 +
>  arch/x86/include/asm/mem_encrypt.h            |  11 +
>  arch/x86/include/asm/paravirt.h               |  10 +
>  arch/x86/include/asm/paravirt_types.h         |   2 +
>  arch/x86/include/uapi/asm/kvm_para.h          |   5 +
>  arch/x86/kernel/kvm.c                         |  90 +++
>  arch/x86/kernel/kvmclock.c                    |  12 +
>  arch/x86/kernel/paravirt.c                    |   1 +
>  arch/x86/kvm/svm/sev.c                        | 732 +++++++++++++++++-
>  arch/x86/kvm/svm/svm.c                        |  21 +
>  arch/x86/kvm/svm/svm.h                        |   9 +
>  arch/x86/kvm/vmx/vmx.c                        |   1 +
>  arch/x86/kvm/x86.c                            |  35 +
>  arch/x86/mm/mem_encrypt.c                     |  68 +-
>  arch/x86/mm/pat/set_memory.c                  |   7 +
>  include/linux/efi.h                           |   1 +
>  include/linux/psp-sev.h                       |   8 +-
>  include/uapi/linux/kvm.h                      |  52 ++
>  include/uapi/linux/kvm_para.h                 |   1 +
>  25 files changed, 1297 insertions(+), 9 deletions(-)
> 
> -- 
> 2.17.1
> 

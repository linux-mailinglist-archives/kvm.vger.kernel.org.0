Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DFB355B11
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 20:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbhDFSO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 14:14:29 -0400
Received: from mail-dm6nam11on2088.outbound.protection.outlook.com ([40.107.223.88]:30721
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232876AbhDFSO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 14:14:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mk++aIhJzfYqyj42tjCZu+NogyLBgHnndi5BtaRrDsQZe8+omBNVXrg5Z6twaZS86o3QH1VC6GYPuDmcY2IUIVJsZrfo9TP87Tb505mX5HdAkWlwKoVT151DR8erqiBL/yiOj/5nWBcHCsXXTKMy44kYqbDsSKvCTVdGcOHYKwk4CYortY8891ko1w4GQaZR9nHp5F3W9oJjjopE/c/vVji9PgiCANb9MRVpLj4RjdST9Qkz3gAeUuxystPWuxF7Dtir5VFunodN098Fdltd+sryHeCWM8mafHatfBktimUXiDLU9UXHaZRFHefSYr3j4fzHhUAdsEqDHD4vbZhBbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BB06Ugymwd+N1F6ytIVzc+5M8Fd8iVoKo8SvMaC9/Ns=;
 b=njP+D4LgVwFvl74l1z0R7+iXr+sVt96zVqy4Pj7dtIHi1UxvEjVU1fL0Ks3IdJEomCK/6Vi31Enr8vYfRZa9WYvsqaMDbGgrTNGGoKmti9wRfHvM034S9kEGsb6W6CtJ3eDKeawzy4X1zKzxOucGaqc9yuuSHBzxKys+Cam2qrskqVfSqqVsqaiUXP8y4Ho2OS4ebbXMCb8D4reeit7eMiK/E2ddlHvQtJX43jZV3h6X0GV0dhiPuoJkTuIYH82pSYmpCCy+qBheOdhZdTeAIT8UyxMR0Mj2AlYLeZtB3hH+LpfAB5TdMj620c/W+MAGKXjGYmXmJASJrTWtsewp9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BB06Ugymwd+N1F6ytIVzc+5M8Fd8iVoKo8SvMaC9/Ns=;
 b=OYkyk9STy9K5Av+b1qMuWGWL/jgJ5fL7Wh6sh+Nm8ob2/UwWMkQEqvXoRWD/1adRRKzeYuVtIRxKmlZ/DsPsoReUOklQ78BZVgYHg1Ff0g9A3UKKX9THqlY/X2eugy+C8fYe/XnglWdficll1WcHikYBxWgMBhG2/4UANl6J2s8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Tue, 6 Apr
 2021 18:14:16 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 18:14:16 +0000
Date:   Tue, 6 Apr 2021 18:14:09 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Will Deacon <will@kernel.org>, maz@kernel.org,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v11 08/13] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <20210406181409.GA24463@ashkalra_ubuntu_server>
References: <cover.1617302792.git.ashish.kalra@amd.com>
 <4da0d40c309a21ba3952d06f346b6411930729c9.1617302792.git.ashish.kalra@amd.com>
 <CABayD+fF7+sn444rMuE_SNwN-SYSPwJr1mrW3qRYw4H7ryi-aw@mail.gmail.com>
 <20210406062248.GA22937@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406062248.GA22937@ashkalra_ubuntu_server>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0128.namprd05.prod.outlook.com
 (2603:10b6:803:42::45) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0501CA0128.namprd05.prod.outlook.com (2603:10b6:803:42::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Tue, 6 Apr 2021 18:14:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7a8ed5b-0448-4e8e-2238-08d8f927ca07
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4432827EBF94D9DC6976BD338E769@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dRwuT4XpF7z8EFWRUFAqSd38A5UwRqJU/t8j4zYEPrlakfjscNyFP5dxugm24FBSpBLGIs5U2ADLMFUhbuNkvK79lbfuqlS8e/ohgVuW7oK8zOyWdzHAWoAoeCcihGPjtXW85irfGg0zJ9p2w91eEuMkeKgfFqDOZ3hAxxIqrIKnN0WXapGR+fpS1/HtbpFtoT3Pw1qVDPGHKl5JOdswZWBVULRG23pbTWTtYFv30P/EGCVUtEGgmzEl8Cw2LWUC8g4rFmUPapRDwvbDYhjf/eYZQZDLEYu/qOxmXwQqQsDxQoz+rJ/jmTz6bpa37k15u+3f5vvWSrTZUq26CDx6LMYxYSxlqmEGOjFLlhZU6aQ0e6dgds/MJzvQk2IgZfvmrOssZgvxDwfnBi0shxXP5p74b45W4KdaS6ZRrNMMMJc+m8NRFWYg9OdJiJgvdA4IMmx8jH3ip7WD+bx3KnqJ8lpzcw+wILzedhIzRsWVd16HE+lwUmsQbmcXhd11MkD7gMd/I7rzByWcUF0pauUOd2+Y/o1uuXcj6ANLRAu44FPgBMt0od2Xi7hU+eebN1zZCKhR/qEKBJLFAsy3EyaDSdlGHgff643HeuNvIopULweIeZLNe5RledroX7KWHu+Y8ZPZ3ICyl7k8EvJiuPW0VxWPTKa3VFyveRaC3YBzGuFL+dUpvKFjeNlKhsHJRZ7G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(54906003)(6916009)(9686003)(33716001)(5660300002)(83380400001)(478600001)(16526019)(52116002)(53546011)(8676002)(38350700001)(33656002)(6496006)(44832011)(2906002)(186003)(26005)(38100700001)(1076003)(8936002)(66476007)(66556008)(66946007)(316002)(956004)(6666004)(55016002)(4326008)(86362001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DQjv526o93IBGvc3lT2JJnK4uypSpf3r0vLbLNIQQlmmghGDxG8/dqJxyXMO?=
 =?us-ascii?Q?1xnQLp6fMmtc/fLs5OIL8Pa7f26HPScoof5x/gaxgP4IcIgxgJeYYqSIuuDb?=
 =?us-ascii?Q?snspc/CqbXceExgeyuGFhhfu+lOnHu5gNI7mQ0aILgkwsFzWTpoLeHL996zJ?=
 =?us-ascii?Q?pEBPrOKUDOWusZWP//Zca2g4Fvnp9yjL5TQmEabd8d5uvp6IsZJTtuZ0L5lA?=
 =?us-ascii?Q?SCzxrOV5sAgw1mVCimWpwFP9jl0edPoBk/LzoZgSzuSu3UeDcra0DeRXyOp7?=
 =?us-ascii?Q?bs2jsvdJxVGf3wLJM2AV/bBwQI+NV1UEJa61blGgo08jc0DUmJgrpx14wYnC?=
 =?us-ascii?Q?KbkCZGBoeCppJz0v0ZeF073+6ncZiJVbF/GS5smXbGCPRkd7KPoT9l3oc+1z?=
 =?us-ascii?Q?exbxzfXwu4RhenCrCy6yudM3mjVZ/ZwAup3DLAkm7p55X2wvdxavIf/+xitI?=
 =?us-ascii?Q?JNmNDZHFLoxJwD7SHL7Gci/ZyVJpKKjFFELn2HyxidZwOsJLsgeQOhfcT6EK?=
 =?us-ascii?Q?R7M4k+7H2zGeb7n2wKWRMxhp/jg/qp6XUn2wV5i5AVvrF82lQVDO4moRpURD?=
 =?us-ascii?Q?Hx13Nslm3DyuJOSFM+6NZ0Y9ErHP+9oa7/AMTJBHWY4yuUWZt8bfLlkUiB5P?=
 =?us-ascii?Q?mBm6M46Zb98RS1QIt/kjUNequ/U9IwGRdWF6dwhjgWgOsdbvOOMLP9pyOvpy?=
 =?us-ascii?Q?HYkkpVy7q9HqyYgyAXqGHl7HKLdd+vLrZxeewv+UlKCKHfTkqUkKu9Xpa/dL?=
 =?us-ascii?Q?89yYODT7nFMeJYHrt0n+cnYYtHXCchFDKT1VkJnycJYnIqO/LgiB622Sivep?=
 =?us-ascii?Q?N+8lt9i7NVQtFE29C/nE+zykoEnsFGPlHBwypBJqh5T5QiXwftRth7e/+S9R?=
 =?us-ascii?Q?P62tGb/pPtz46XDXouZsgYQENRyTvklT884/T+tvDUadZtQAasRTfFK+7Rq1?=
 =?us-ascii?Q?3jGOVfzXJghnRAvA78zU5YRMrLZvUXB43foSSDqOXQCJx7VLRr+531UOVJ/O?=
 =?us-ascii?Q?9f/FYZS3v2kneF/ELpf3IlIXpV4+Nby/u1AGQssaMpQ4GOBIj2F3Gd0QU1I/?=
 =?us-ascii?Q?SgCLFPSoGwabTRgTRZNedC5f59zQONGUtWWoKxBIWxyQIm9HIPcYPcFWG1y4?=
 =?us-ascii?Q?fpCQrD+aELl4/Qc6YLatwlxbf9lY5ZE9utuQIB1iMv0N5vosEw02gsvTnzk/?=
 =?us-ascii?Q?fh59NmN3qVXdUxPTym32m4LHqDlzwDqyo2xw6727vKywuL1DkZMPrYoJZW42?=
 =?us-ascii?Q?zU6hDimFMYg/e1GTQDrHZjp0GLn8QYQrX4pKcg4gN9klFgeLjZmocP6rAZb4?=
 =?us-ascii?Q?4kHcBqg5YN9rjP39aVsqir2l?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7a8ed5b-0448-4e8e-2238-08d8f927ca07
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 18:14:16.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X7CedKpoArYsQ0fkAVdit0vFVChm0kCWYT26jxVDRmeYhuQ4rg5p1XMwrevxNKRt84sudvY5iiBzDpRxd0Iu7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021 at 06:22:48AM +0000, Ashish Kalra wrote:
> On Mon, Apr 05, 2021 at 01:42:42PM -0700, Steve Rutherford wrote:
> > On Mon, Apr 5, 2021 at 7:28 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > >
> > > From: Ashish Kalra <ashish.kalra@amd.com>
> > >
> > > This hypercall is used by the SEV guest to notify a change in the page
> > > encryption status to the hypervisor. The hypercall should be invoked
> > > only when the encryption attribute is changed from encrypted -> decrypted
> > > and vice versa. By default all guest pages are considered encrypted.
> > >
> > > The hypercall exits to userspace to manage the guest shared regions and
> > > integrate with the userspace VMM's migration code.
> > >
> > > The patch integrates and extends DMA_SHARE/UNSHARE hypercall to
> > > userspace exit functionality (arm64-specific) patch from Marc Zyngier,
> > > to avoid arch-specific stuff and have a common interface
> > > from the guest back to the VMM and sharing of the host handling of the
> > > hypercall to support use case for a guest to share memory with a host.
> > >
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Joerg Roedel <joro@8bytes.org>
> > > Cc: Borislav Petkov <bp@suse.de>
> > > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > > Cc: x86@kernel.org
> > > Cc: kvm@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > ---
> > >  Documentation/virt/kvm/api.rst        | 18 ++++++++
> > >  Documentation/virt/kvm/hypercalls.rst | 15 +++++++
> > >  arch/x86/include/asm/kvm_host.h       |  2 +
> > >  arch/x86/kvm/svm/sev.c                | 61 +++++++++++++++++++++++++++
> > >  arch/x86/kvm/svm/svm.c                |  2 +
> > >  arch/x86/kvm/svm/svm.h                |  2 +
> > >  arch/x86/kvm/vmx/vmx.c                |  1 +
> > >  arch/x86/kvm/x86.c                    | 12 ++++++
> > >  include/uapi/linux/kvm.h              |  8 ++++
> > >  include/uapi/linux/kvm_para.h         |  1 +
> > >  10 files changed, 122 insertions(+)
> > >
> > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > index 307f2fcf1b02..52bd7e475fd6 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -5475,6 +5475,24 @@ Valid values for 'type' are:
> > >      Userspace is expected to place the hypercall result into the appropriate
> > >      field before invoking KVM_RUN again.
> > >
> > > +::
> > > +
> > > +               /* KVM_EXIT_DMA_SHARE / KVM_EXIT_DMA_UNSHARE */
> > > +               struct {
> > > +                       __u64 addr;
> > > +                       __u64 len;
> > > +                       __u64 ret;
> > > +               } dma_sharing;
> > > +
> > > +This defines a common interface from the guest back to the KVM to support
> > > +use case for a guest to share memory with a host.
> > > +
> > > +The addr and len fields define the starting address and length of the
> > > +shared memory region.
> > > +
> > > +Userspace is expected to place the hypercall result into the "ret" field
> > > +before invoking KVM_RUN again.
> > > +
> > >  ::
> > >
> > >                 /* Fix the size of the union. */
> > > diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
> > > index ed4fddd364ea..7aff0cebab7c 100644
> > > --- a/Documentation/virt/kvm/hypercalls.rst
> > > +++ b/Documentation/virt/kvm/hypercalls.rst
> > > @@ -169,3 +169,18 @@ a0: destination APIC ID
> > >
> > >  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
> > >                 any of the IPI target vCPUs was preempted.
> > > +
> > > +
> > > +8. KVM_HC_PAGE_ENC_STATUS
> > > +-------------------------
> > > +:Architecture: x86
> > > +:Status: active
> > > +:Purpose: Notify the encryption status changes in guest page table (SEV guest)
> > > +
> > > +a0: the guest physical address of the start page
> > > +a1: the number of pages
> > > +a2: encryption attribute
> > > +
> > > +   Where:
> > > +       * 1: Encryption attribute is set
> > > +       * 0: Encryption attribute is cleared
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 3768819693e5..78284ebbbee7 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1352,6 +1352,8 @@ struct kvm_x86_ops {
> > >         int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
> > >
> > >         void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> > > +       int (*page_enc_status_hc)(struct kvm_vcpu *vcpu, unsigned long gpa,
> > > +                                 unsigned long sz, unsigned long mode);
> > >  };
> > >
> > >  struct kvm_x86_nested_ops {
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index c9795a22e502..fb3a315e5827 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -1544,6 +1544,67 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > >         return ret;
> > >  }
> > >
> > > +static int sev_complete_userspace_page_enc_status_hc(struct kvm_vcpu *vcpu)
> > > +{
> > > +       vcpu->run->exit_reason = 0;
> > I don't believe you need to clear exit_reason: it's universally set on exit.
> > 
> > > +       kvm_rax_write(vcpu, vcpu->run->dma_sharing.ret);
> > > +       ++vcpu->stat.hypercalls;
> > > +       return kvm_skip_emulated_instruction(vcpu);
> > > +}
> > > +
> > > +int svm_page_enc_status_hc(struct kvm_vcpu *vcpu, unsigned long gpa,
> > > +                          unsigned long npages, unsigned long enc)
> > > +{
> > > +       kvm_pfn_t pfn_start, pfn_end;
> > > +       struct kvm *kvm = vcpu->kvm;
> > > +       gfn_t gfn_start, gfn_end;
> > > +
> > > +       if (!sev_guest(kvm))
> > > +               return -EINVAL;
> > > +
> > > +       if (!npages)
> > > +               return 0;
> > > +
> > > +       gfn_start = gpa_to_gfn(gpa);
> > > +       gfn_end = gfn_start + npages;
> > > +
> > > +       /* out of bound access error check */
> > > +       if (gfn_end <= gfn_start)
> > > +               return -EINVAL;
> > > +
> > > +       /* lets make sure that gpa exist in our memslot */
> > > +       pfn_start = gfn_to_pfn(kvm, gfn_start);
> > > +       pfn_end = gfn_to_pfn(kvm, gfn_end);
> > > +
> > > +       if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
> > > +               /*
> > > +                * Allow guest MMIO range(s) to be added
> > > +                * to the shared pages list.
> > > +                */
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> > > +               /*
> > > +                * Allow guest MMIO range(s) to be added
> > > +                * to the shared pages list.
> > > +                */
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       if (enc)
> > > +               vcpu->run->exit_reason = KVM_EXIT_DMA_UNSHARE;
> > > +       else
> > > +               vcpu->run->exit_reason = KVM_EXIT_DMA_SHARE;
> > > +
> > > +       vcpu->run->dma_sharing.addr = gfn_start;
> > > +       vcpu->run->dma_sharing.len = npages * PAGE_SIZE;
> > > +       vcpu->arch.complete_userspace_io =
> > > +               sev_complete_userspace_page_enc_status_hc;
> > > +
> > > +       return 0;
> > > +}
> > > +
> > >  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> > >  {
> > >         struct kvm_sev_cmd sev_cmd;
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 58a45bb139f8..3cbf000beff1 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -4620,6 +4620,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> > >         .complete_emulated_msr = svm_complete_emulated_msr,
> > >
> > >         .vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> > > +
> > > +       .page_enc_status_hc = svm_page_enc_status_hc,
> > >  };
> > >
> > >  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> > > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > > index 39e071fdab0c..9cc16d2c0b8f 100644
> > > --- a/arch/x86/kvm/svm/svm.h
> > > +++ b/arch/x86/kvm/svm/svm.h
> > > @@ -451,6 +451,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
> > >                                bool has_error_code, u32 error_code);
> > >  int nested_svm_exit_special(struct vcpu_svm *svm);
> > >  void sync_nested_vmcb_control(struct vcpu_svm *svm);
> > > +int svm_page_enc_status_hc(struct kvm_vcpu *vcpu, unsigned long gpa,
> > > +                          unsigned long npages, unsigned long enc);
> > >
> > >  extern struct kvm_x86_nested_ops svm_nested_ops;
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 32cf8287d4a7..2c98a5ed554b 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -7748,6 +7748,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
> > >         .can_emulate_instruction = vmx_can_emulate_instruction,
> > >         .apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> > >         .migrate_timers = vmx_migrate_timers,
> > > +       .page_enc_status_hc = NULL,
> > >
> > >         .msr_filter_changed = vmx_msr_filter_changed,
> > >         .complete_emulated_msr = kvm_complete_insn_gp,
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index f7d12fca397b..ef5c77d59651 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -8273,6 +8273,18 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > >                 kvm_sched_yield(vcpu->kvm, a0);
> > >                 ret = 0;
> > >                 break;
> > > +       case KVM_HC_PAGE_ENC_STATUS: {
> > > +               int r;
> > > +
> > > +               ret = -KVM_ENOSYS;
> > > +               if (kvm_x86_ops.page_enc_status_hc) {
> > > +                       r = kvm_x86_ops.page_enc_status_hc(vcpu, a0, a1, a2);
> > > +                       if (r >= 0)
> > > +                               return r;
> > > +                       ret = r;
> > Style nit: Why not just set ret, and return ret if ret >=0?
> > 
> 
> But ret is "unsigned long", if i set ret and return, then i will return to guest
> even in case of error above ?
> 

I actually meant that we will return to userspace in case of errors
above, instead of returning to guest with errors indicated above. 

But i am now more inclined to adopting Sean's latest commments on
this patches and removing the kvm_x86_ops hook and instead using 
a flag to indicate support for this hypercall.

Thanks,
Ashish

> > This looks good. I just had a few nitpicks.
> > Reviewed-by: Steve Rutherford <srutherford@google.com>

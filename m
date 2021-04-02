Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1963352A6E
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 13:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhDBL6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 07:58:21 -0400
Received: from mail-dm6nam10on2064.outbound.protection.outlook.com ([40.107.93.64]:20192
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235204AbhDBL6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 07:58:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LqG9MosB3NXSdn0iHuqfX9GBQ0hlItOMbXgMYw3cNoglssRtu31UY0Ybs/BhQh+essUq7Sb0eXG7dkzI6vrql4CcDZOL+OmOp2tJp4ok/mX3tcCBbTOc6WrtPaqvLxEKOAFMz9jIUBT/DlR2LZTA56c4i3eqDgZwfRtb5OyI4UicKE4J4iXTK2/6RmfaTOe2hrECh0jk/7Czp2my4n9Z0JMdCVdYJusuVXpkfdRoQzxgHsX5tyxUydPHMF6iidRLZA4GMTYnRJAu+bzjkh97fBhGyKoZnjyVRNxus2Y2zo5WXuGzb6sQQ8sHoj0W5qcEA1KL9R6VRS6etqdoya0ekA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFPfiPv2EWrhHrdXYMwAfu4GTW3jEtQWhiIjBdPq+NI=;
 b=GKK3uUwvQ26Bafbf8Jg0shjp/O0dn+z8KKHrWKOSPW4dJotvjY4c5lYhbSd8NT/bNPs8+bwlRY6umYtQGhn3J38leRPeA99PzeUWnV3rDzx799gbdLpNSr5Ru9Db0XVlStuycEup4QRNueWUvA26y/IVU4gnfDbeBANgDoXqMLXdQQRsLqnatDUlfOOg8l18kaY6ymgF+VzwR8PEYoHOhj3A4qbAZ9ik4rD18NmxMqOb4L/KX1CCf7Yanha/9vzCpXtsTVgFdr6G8hyu8JfbkzUbDNbVfm4qrvXXoggh3AmoOrxOipcQuzRh/wEdRJ768cNNC6NaEQ8zu/vch4R7Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFPfiPv2EWrhHrdXYMwAfu4GTW3jEtQWhiIjBdPq+NI=;
 b=s9KvPKdHkk2oaaQ61ibd2Z/nmdVaxvTb674R4qupI8I8G85eynWP+ppSQx7nPb6tGJXCvf2LTcuQq2bQbxtdmM1kmmDfIDk9snsLDT75guryo4wc4y8PvhqhU3cLUxRnq0vUXHpCl766f/3FD5eDDd1b/+fZJnAC9UuHn31OozM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2414.namprd12.prod.outlook.com (2603:10b6:802:2e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Fri, 2 Apr
 2021 11:58:16 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 11:58:16 +0000
Date:   Fri, 2 Apr 2021 11:58:13 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Nathan Tempelman <natet@google.com>
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com, rientjes@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com,
        lersek@redhat.com, jejb@linux.ibm.com, frankeh@us.ibm.com
Subject: Re: [RFC v2] KVM: x86: Support KVM VMs sharing SEV context
Message-ID: <20210402115813.GB17630@ashkalra_ubuntu_server>
References: <20210316014027.3116119-1-natet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316014027.3116119-1-natet@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0098.namprd13.prod.outlook.com
 (2603:10b6:806:24::13) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA9PR13CA0098.namprd13.prod.outlook.com (2603:10b6:806:24::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Fri, 2 Apr 2021 11:58:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2f471b7-22a1-420d-ae45-08d8f5ce9967
X-MS-TrafficTypeDiagnostic: SN1PR12MB2414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB241441A3AB68794D1CB3E78B8E7A9@SN1PR12MB2414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8bm3WZiWoDxo7+j5juT/Ng1FUi5XwhB1vaRRawugPbSeFSTO4D47EN55j6L2+X3JOAhYn4P9I8lEQZw3u+dFLdC00N5hidaMeUhWre5jBHNop5t2Y4QTOTr++nq78FBg3bGmpUk8EpyaxQZb3fCLGwmopZ3vXbfXcW45JiApK+LbLTf5jU6pzZXTy6wo9NI88632pfyqBOjoGzG74VIWZgZTlD7vh3NpH77h6th8b9QGQ3VfgF7a0Kc8hHZpvyxO8Fk82YUy24ViFYiyF3VZZzMK4DVzCyPIl3vW2MjxRYHQJtyhtPBBKCqiQj1eaHbTgbfveysQueb2vYKsRZQgZF4VV0bxhjxCa1uLhVjsfm9p2TrtnrsRO4PBEmHxfnghlZ1Khll++iTKxkaqkuhcMtet6B8kaj8zY+1W0dv1QgxNGWcH7udGJkbMskvxQ7Smch1l6RA9bABfsvObGRuWleUkdHa4bOlbV4CBd36qSNWhdgQMsLIOxxJ5do82f0t3kn65s98fecEKOipq/C0z13Bl2tFFQEGHfCIiAV3EfSqGT0HPgM7+eQgzzH2ZQI9P1chkT/r5HzcWMJG0JY4Q4H5JbJd2iF0Nu34MoGRRCpZUZ1XQ6cGEDFRMhZKwfZDArS8cB2m9KvEBomdN4dRbIwpmOMRo6dGX2yWRX71Lfuc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(39860400002)(396003)(7416002)(4326008)(316002)(86362001)(52116002)(478600001)(6496006)(66946007)(2906002)(186003)(6916009)(956004)(1076003)(44832011)(33716001)(66556008)(5660300002)(66476007)(26005)(33656002)(8936002)(83380400001)(8676002)(9686003)(30864003)(38100700001)(16526019)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FrOifJsA0Br+34Z1N0GLJ/K3mhiqDwDI65PeeMjqH+4NJ4X6cSa+u60gR4vt?=
 =?us-ascii?Q?2ypZtig6st+ntZgG14H7TJ09JDUNGO6zKhvl+9oE5PYkSkPX/U/YIoecumWO?=
 =?us-ascii?Q?qn1Sd86LtVnZCchtam9IOYSElX94XQw6U5PU4cmgWrEtJf1UMSLkCq3G8YKG?=
 =?us-ascii?Q?+laI+X5QOUontjggrVBz1eJ3dZbt2LGxABboBo9C9iNflIOcPyUf6VT6WB7V?=
 =?us-ascii?Q?G9z4E7w6EOkPNKWRKPj6Wn5iNjq16Qwg/oHYToqJxTsWQGtBPlrFxZ9YmwWB?=
 =?us-ascii?Q?PXQext2GUhz60cxP5Nrh2gD3awJcpo25/dPEXWpRVJWvoE/bnCLtdCDIq1/u?=
 =?us-ascii?Q?TNutFP1d5w1Zv88ODfYSvei5mYPcbKcBhe0pFp9TJZ4RF5P/4HTcYpsPTDhI?=
 =?us-ascii?Q?3k57hB+6v/HY3nHScDCzsSWTu6X9YbgITtRvpN2taZKR4o/NnX3gsmL9M048?=
 =?us-ascii?Q?IZI3IKt5PHRrR/kkw/E+nwEilyxVtNMbLt87uR2C7n2h1sCijGmWe9M/cijz?=
 =?us-ascii?Q?tsryT0hDqryXKwmiEp/N1+kq2BhIin3vcC7pumjzu3T0mVDv1Qu8IENAFr4E?=
 =?us-ascii?Q?IqZXNYf0ondR0oTU/jxngvgqKfywJDChG9wkQ7eUpfNhRw2NvLJkViXSkIam?=
 =?us-ascii?Q?K+b5NKgXfAZlQ1xoQz8WSL/gewnWHNR3fTdQyIsC85K4E488PEXzPyq2ysbk?=
 =?us-ascii?Q?c/QQ+F7M15Q0VGL0BEwE4JObX+2/aA5bbbiYd4WEw3N2KXwplxrZcJlDJEjz?=
 =?us-ascii?Q?paBcBbqAKw+ULmzbKRdcaBn9ItgVJhilvRMebURR/rMCgooAw7+ZrTDdFWYs?=
 =?us-ascii?Q?b5UUycGBaEb8Dg0EyGNE10AnfFSbC93K8+iksui+8Pj2eYGwiphe1bDjInAg?=
 =?us-ascii?Q?AVQBkJEWiqPE7G7P48HhDVRhpNA7AnK4e4js2D5YtRPzF+j1OkUlqEcMyVDc?=
 =?us-ascii?Q?ybBCCrrqXZ/k3OaYzA+DL5uzCNvqRuZbWi1kdxQDABEKTK13xbuo6iHi/Sp0?=
 =?us-ascii?Q?wLcJfzs75ZtVmoE4NH0RmfpWRTvEEp6PPtvEyiqs03zaHD0Tt6SNg0Rh3QBh?=
 =?us-ascii?Q?bQd+2JClfIgjrQEeQAdaVm+f1FMpD1COrMnXlU/2WwRqn9NVAD+iNC1XvxqY?=
 =?us-ascii?Q?79rYkfQCLU2uFerICEjBqolX3fPkX8gx7r3Ld62SRtlUxdrrvb9Qjrp6XCme?=
 =?us-ascii?Q?g0ocZgorFLrl/LMVew87fAgp6gU3R0hyvfRzh/mfM3qJQLiyx/LDNVw34PRr?=
 =?us-ascii?Q?HZEi7KJ8Rzz6Ay6+uXVXeSqeLbyE8QS6wMh+uTUEBg/r/1ZwabaKJ67C7+ct?=
 =?us-ascii?Q?0zlPqhN8TBXhH/HcBqqsAZ0D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2f471b7-22a1-420d-ae45-08d8f5ce9967
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 11:58:16.1130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BmGiaRoPp4dkcV9voxPlwbPan+ZuqlVCCfo7K7R/pdcYG4TvoEjDjThA/MOY8FaggDRRDMQ7NbziSwq1GaPQjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2414
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nathan,

Will you be posting a corresponding Qemu patch for this ?

Thanks,
Ashish

On Tue, Mar 16, 2021 at 01:40:27AM +0000, Nathan Tempelman wrote:
> Add a capability for userspace to mirror SEV encryption context from
> one vm to another. On our side, this is intended to support a
> Migration Helper vCPU, but it can also be used generically to support
> other in-guest workloads scheduled by the host. The intention is for
> the primary guest and the mirror to have nearly identical memslots.
> 
> The primary benefits of this are that:
> 1) The VMs do not share KVM contexts (think APIC/MSRs/etc), so they
> can't accidentally clobber each other.
> 2) The VMs can have different memory-views, which is necessary for post-copy
> migration (the migration vCPUs on the target need to read and write to
> pages, when the primary guest would VMEXIT).
> 
> This does not change the threat model for AMD SEV. Any memory involved
> is still owned by the primary guest and its initial state is still
> attested to through the normal SEV_LAUNCH_* flows. If userspace wanted
> to circumvent SEV, they could achieve the same effect by simply attaching
> a vCPU to the primary VM.
> This patch deliberately leaves userspace in charge of the memslots for the
> mirror, as it already has the power to mess with them in the primary guest.
> 
> This patch does not support SEV-ES (much less SNP), as it does not
> handle handing off attested VMSAs to the mirror.
> 
> For additional context, we need a Migration Helper because SEV PSP migration
> is far too slow for our live migration on its own. Using an in-guest
> migrator lets us speed this up significantly.
> 
> Signed-off-by: Nathan Tempelman <natet@google.com>
> ---
>  Documentation/virt/kvm/api.rst  | 17 +++++++
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm/sev.c          | 88 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c          |  2 +
>  arch/x86/kvm/svm/svm.h          |  2 +
>  arch/x86/kvm/x86.c              |  7 ++-
>  include/linux/kvm_host.h        |  1 +
>  include/uapi/linux/kvm.h        |  1 +
>  virt/kvm/kvm_main.c             |  6 +++
>  9 files changed, 124 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 482508ec7cc4..332ba8b5b6f4 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6213,6 +6213,23 @@ the bus lock vm exit can be preempted by a higher priority VM exit, the exit
>  notifications to userspace can be KVM_EXIT_BUS_LOCK or other reasons.
>  KVM_RUN_BUS_LOCK flag is used to distinguish between them.
>  
> +7.23 KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
> +-------------------------------------
> +
> +Architectures: x86 SEV enabled
> +Type: vm
> +Parameters: args[0] is the fd of the source vm
> +Returns: 0 on success; ENOTTY on error
> +
> +This capability enables userspace to copy encryption context from the vm
> +indicated by the fd to the vm this is called on.
> +
> +This is intended to support in-guest workloads scheduled by the host. This
> +allows the in-guest workload to maintain its own NPTs and keeps the two vms
> +from accidentally clobbering each other with interrupts and the like (separate
> +APIC/MSRs/etc).
> +
> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 84499aad01a4..46df415a8e91 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1334,6 +1334,7 @@ struct kvm_x86_ops {
>  	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
>  	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> +	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
>  
>  	int (*get_msr_feature)(struct kvm_msr_entry *entry);
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 874ea309279f..b2c90c67a0d9 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -66,6 +66,11 @@ static int sev_flush_asids(void)
>  	return ret;
>  }
>  
> +static inline bool is_mirroring_enc_context(struct kvm *kvm)
> +{
> +	return to_kvm_svm(kvm)->sev_info.enc_context_owner;
> +}
> +
>  /* Must be called with the sev_bitmap_lock held */
>  static bool __sev_recycle_asids(int min_asid, int max_asid)
>  {
> @@ -1124,6 +1129,10 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
>  		return -EFAULT;
>  
> +	/* enc_context_owner handles all memory enc operations */
> +	if (is_mirroring_enc_context(kvm))
> +		return -ENOTTY;
> +
>  	mutex_lock(&kvm->lock);
>  
>  	switch (sev_cmd.id) {
> @@ -1186,6 +1195,10 @@ int svm_register_enc_region(struct kvm *kvm,
>  	if (!sev_guest(kvm))
>  		return -ENOTTY;
>  
> +	/* If kvm is mirroring encryption context it isn't responsible for it */
> +	if (is_mirroring_enc_context(kvm))
> +		return -ENOTTY;
> +
>  	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
>  		return -EINVAL;
>  
> @@ -1252,6 +1265,10 @@ int svm_unregister_enc_region(struct kvm *kvm,
>  	struct enc_region *region;
>  	int ret;
>  
> +	/* If kvm is mirroring encryption context it isn't responsible for it */
> +	if (is_mirroring_enc_context(kvm))
> +		return -ENOTTY;
> +
>  	mutex_lock(&kvm->lock);
>  
>  	if (!sev_guest(kvm)) {
> @@ -1282,6 +1299,71 @@ int svm_unregister_enc_region(struct kvm *kvm,
>  	return ret;
>  }
>  
> +int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
> +{
> +	struct file *source_kvm_file;
> +	struct kvm *source_kvm;
> +	struct kvm_sev_info *mirror_sev;
> +	unsigned int asid;
> +	int ret;
> +
> +	source_kvm_file = fget(source_fd);
> +	if (!file_is_kvm(source_kvm_file)) {
> +		ret = -EBADF;
> +		goto e_source_put;
> +	}
> +
> +	source_kvm = source_kvm_file->private_data;
> +	mutex_lock(&source_kvm->lock);
> +
> +	if (!sev_guest(source_kvm)) {
> +		ret = -ENOTTY;
> +		goto e_source_unlock;
> +	}
> +
> +	/* Mirrors of mirrors should work, but let's not get silly */
> +	if (is_mirroring_enc_context(source_kvm) || source_kvm == kvm) {
> +		ret = -ENOTTY;
> +		goto e_source_unlock;
> +	}
> +
> +	asid = to_kvm_svm(source_kvm)->sev_info.asid;
> +
> +	/*
> +	 * The mirror kvm holds an enc_context_owner ref so its asid can't
> +	 * disappear until we're done with it
> +	 */
> +	kvm_get_kvm(source_kvm);
> +
> +	fput(source_kvm_file);
> +	mutex_unlock(&source_kvm->lock);
> +	mutex_lock(&kvm->lock);
> +
> +	if (sev_guest(kvm)) {
> +		ret = -ENOTTY;
> +		goto e_mirror_unlock;
> +	}
> +
> +	/* Set enc_context_owner and copy its encryption context over */
> +	mirror_sev = &to_kvm_svm(kvm)->sev_info;
> +	mirror_sev->enc_context_owner = source_kvm;
> +	mirror_sev->asid = asid;
> +	mirror_sev->active = true;
> +
> +	mutex_unlock(&kvm->lock);
> +	return 0;
> +
> +e_mirror_unlock:
> +	mutex_unlock(&kvm->lock);
> +	kvm_put_kvm(source_kvm);
> +	return ret;
> +e_source_unlock:
> +	mutex_unlock(&source_kvm->lock);
> +e_source_put:
> +	fput(source_kvm_file);
> +	return ret;
> +}
> +
>  void sev_vm_destroy(struct kvm *kvm)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> @@ -1293,6 +1375,12 @@ void sev_vm_destroy(struct kvm *kvm)
>  
>  	mutex_lock(&kvm->lock);
>  
> +	/* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
> +	if (is_mirroring_enc_context(kvm)) {
> +		kvm_put_kvm(sev->enc_context_owner);
> +		return;
> +	}
> +
>  	/*
>  	 * Ensure that all guest tagged cache entries are flushed before
>  	 * releasing the pages back to the system for use. CLFLUSH will
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 42d4710074a6..9ffb2bcf5389 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4608,6 +4608,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.mem_enc_reg_region = svm_register_enc_region,
>  	.mem_enc_unreg_region = svm_unregister_enc_region,
>  
> +	.vm_copy_enc_context_from = svm_vm_copy_asid_from,
> +
>  	.can_emulate_instruction = svm_can_emulate_instruction,
>  
>  	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 39e071fdab0c..779009839f6a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -65,6 +65,7 @@ struct kvm_sev_info {
>  	unsigned long pages_locked; /* Number of pages locked */
>  	struct list_head regions_list;  /* List of registered regions */
>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
> +	struct kvm *enc_context_owner; /* Owner of copied encryption context */
>  };
>  
>  struct kvm_svm {
> @@ -561,6 +562,7 @@ int svm_register_enc_region(struct kvm *kvm,
>  			    struct kvm_enc_region *range);
>  int svm_unregister_enc_region(struct kvm *kvm,
>  			      struct kvm_enc_region *range);
> +int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd);
>  void pre_sev_run(struct vcpu_svm *svm, int cpu);
>  void __init sev_hardware_setup(void);
>  void sev_hardware_teardown(void);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3fa140383f5d..343cb05c2a24 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3753,6 +3753,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_X86_USER_SPACE_MSR:
>  	case KVM_CAP_X86_MSR_FILTER:
>  	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
> +	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
>  		r = 1;
>  		break;
>  	case KVM_CAP_XEN_HVM:
> @@ -4649,7 +4650,6 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  			kvm_update_pv_runtime(vcpu);
>  
>  		return 0;
> -
>  	default:
>  		return -EINVAL;
>  	}
> @@ -5321,6 +5321,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			kvm->arch.bus_lock_detection_enabled = true;
>  		r = 0;
>  		break;
> +	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
> +		r = -ENOTTY;
> +		if (kvm_x86_ops.vm_copy_enc_context_from)
> +			r = kvm_x86_ops.vm_copy_enc_context_from(kvm, cap->args[0]);
> +		return r;
>  	default:
>  		r = -EINVAL;
>  		break;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e126ebda36d0..dc5a81115df7 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -637,6 +637,7 @@ void kvm_exit(void);
>  
>  void kvm_get_kvm(struct kvm *kvm);
>  void kvm_put_kvm(struct kvm *kvm);
> +bool file_is_kvm(struct file *file);
>  void kvm_put_kvm_no_destroy(struct kvm *kvm);
>  
>  static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 63f8f6e95648..9dc00f9baf54 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1077,6 +1077,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_SYS_HYPERV_CPUID 191
>  #define KVM_CAP_DIRTY_LOG_RING 192
>  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
> +#define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 194
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 001b9de4e727..5baf82b01e0c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4041,6 +4041,12 @@ static struct file_operations kvm_vm_fops = {
>  	KVM_COMPAT(kvm_vm_compat_ioctl),
>  };
>  
> +bool file_is_kvm(struct file *file)
> +{
> +	return file && file->f_op == &kvm_vm_fops;
> +}
> +EXPORT_SYMBOL_GPL(file_is_kvm);
> +
>  static int kvm_dev_ioctl_create_vm(unsigned long type)
>  {
>  	int r;
> -- 
> 2.31.0.rc2.261.g7f71774620-goog
> 

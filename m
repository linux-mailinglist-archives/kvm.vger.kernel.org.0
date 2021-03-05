Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D6532ECB9
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 15:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhCEOE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 09:04:26 -0500
Received: from mail-dm6nam12on2075.outbound.protection.outlook.com ([40.107.243.75]:54080
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229740AbhCEOES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 09:04:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AAkfNNiCkMGSR9R06H0bqoaPYtbjEvhKJpXyzz+Svi/yoclLdLSZPwh3H6bnrNoBLqdtlaH8J8OulIcteGsoVrsYqDIP5J0kVAcUF8VPD0Rrmhfgq2wLlb2jNZNWFdpJt109Ix/XAuPwS6LvNAEBUexa04ha1C16rGj9pl9mQgnbdq8xLMkLilO/IbB+hLLrAAFELxVEtsVL0yS83M/d8+G7x9Eq49vOtFYB5pJkfINxOUX0Tb1WiXAMz96uCGwH5pR23Uq74CIB2R3NIfIfR3MDSvmMlbjVfoRLUuMwdsnP3en+gW0ZX+5gfQpSJHvHsf2jUOAhfEna0A32oarFWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqQGRN/NB977MPkrfytz57L1dGrGnYfUB6xbIMgCwGY=;
 b=VFzvJriHQImznBPxLoCb46n0AGIygo2BpBIPQtaLsw08xN4BNiq/gzPcIBelaTDjWmaUTAfx7MR8nE7GhoXyIoqDeJE2v6WSXcmrofMUe0Tbte2a8zgqYpJl+OxTiVl1xfKd4VZhrUI5shFeLdAMyqLsJtyMDJS4FDte71BsWQ2WpleQ4/YZ/dRy2EdXrXDZmo5M42ye+mzN5YU776K6JW0kaJUh2tDlnqWGtLlJ8DyP8JpJ5QaxH2nea316wM8vdMWQ/nMXdiX+D/vwiq2St1OXCgCTN6FX1PcAbp68IFJJNrdSHuppEcQHvBan47Ax0BJejBSYF2U9P04D6xc7tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqQGRN/NB977MPkrfytz57L1dGrGnYfUB6xbIMgCwGY=;
 b=nUClxOAyegQs/J/PQpMYtNq2H4g4zaA6Cy/xn3p/Ahi+fvU+T1oJyzfYsmwTzGoq4sGg4HIc7/DDph59YgCEeVkHCqwc2Pr/pGZr1cXKfN7SQo4PbYXQ/UCC0wrf5Z0RdL4sOMgthnMWAu2saC3g7ZzWMKmIh9+oGI8YST0SH1A=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Fri, 5 Mar
 2021 14:04:15 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3912.018; Fri, 5 Mar 2021
 14:04:15 +0000
Date:   Fri, 5 Mar 2021 14:04:09 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Nathan Tempelman <natet@google.com>
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com, rientjes@google.com,
        brijesh.singh@amd.com
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
Message-ID: <20210305140409.GA2116@ashkalra_ubuntu_server>
References: <20210224085915.28751-1-natet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224085915.28751-1-natet@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0065.namprd02.prod.outlook.com
 (2603:10b6:803:20::27) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0201CA0065.namprd02.prod.outlook.com (2603:10b6:803:20::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 5 Mar 2021 14:04:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: df3cabeb-4172-46e2-6999-08d8dfdf8f33
X-MS-TrafficTypeDiagnostic: SA0PR12MB4349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4349819A10203792CA77C21C8E969@SA0PR12MB4349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TbXZK9V2RsdGviAkYZ5ePx7TxGqa1V2aonGG4bkoI2Lulv5rufTbHoB6vPKExCp0VUzlKI1yORHUhQGkyOnoHn4mr1Toz31NAM4uZmB6jzKxjZUuAF2yzf9Ywmi5AlDrq6gz6PBPhBKAV/8emQSR63qTGqWkl1W2RezfQQrk+WbzveOz8HWAyqfsQPblty0J23nJWOD08bpkBhvdmFJWObVW/8T5MKFfs9UbQVERGMa+jJlzbTHnTILFblant8xXXFiW1sGXhKPjCpg8yrwlog1tSDAEMs2cOu4y8Kolz37JnJFaKst7Y0tPkQbkpM1/45REZzKML2P64CAIy0dl+TCkKLoo8rNHYFiQs65WIQfG1x9dcTRX8F5B1uuSQi4T7i0QJTmKi7STETc7j0HShqUxV2TO7wFSfgQHnfdjxfPZodxB9PmFgWiC5yaP9qxNtQ3z9Q4U4s1w4S+NSKtATIMk12ls8vcYQDVMXMa6Lsv6YFhKy4hrkAQbIx1dsvgLPjXXpF1e9yu4+tlOYS6PgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(366004)(346002)(396003)(5660300002)(4326008)(6666004)(66556008)(26005)(33716001)(66476007)(52116002)(8936002)(1076003)(33656002)(66946007)(86362001)(83380400001)(8676002)(478600001)(6916009)(9686003)(16526019)(316002)(44832011)(186003)(2906002)(55016002)(6496006)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wTO5YDA5aAGFjavl7DYnSz8faCkQA1YIFiIuDHluhe8+WldUFo0mTubm7WuA?=
 =?us-ascii?Q?/655UgXK9HOjt0GqNpK92ekasPrHXgyejUTDjWuDwAlvM95yBlSPULV3at7z?=
 =?us-ascii?Q?24GVKLRbN2He2s/6nqygxXN4iErRDMiDwB7VnKRUCmpHybqUO49FrHS+wWuN?=
 =?us-ascii?Q?YekUwYeFdmJYER6IvJ4Q2ixVivDxFSXTyd9An5F74PQVzWhNrUq/toLz+i9r?=
 =?us-ascii?Q?O/Qv3tFDFvLlOc4HtRnqJAehUElwbuU6oa9s0GHRgksYS4hLjNRJcyVw1Lxu?=
 =?us-ascii?Q?IBWjaTrRmUxAlOUUavRlK80CiZ23bE8HejpKvH9WZohQHb0cliRGJAHsF86E?=
 =?us-ascii?Q?7aikDhXKiNbMBba4SjFe3wxhpH83ZIYVaJwF9ZgDKoavfD7G4Eup0XhrPl7/?=
 =?us-ascii?Q?9A8MiGMAd0A/JmVA9L2kBv6uh8DHUtIKKyW1SmoDgagfxi6Fitwv98k8fjpn?=
 =?us-ascii?Q?SEOY1bmuWPh4PgJ4L7oc/agL5miS6DiKqr/mer7wXzGOV+mv3y+zxHBbsWoi?=
 =?us-ascii?Q?TB9BZUq0+bRVyNcztMUGhbOncPgunyk4+KKqbop1NW3jC9FsfLtOnqlTRH6s?=
 =?us-ascii?Q?Fh7QJMF8FRZDOaB5s0D/tYxmth3yK8kEf2ruikVhAJ/o+8OVAGVXsa0yRlm8?=
 =?us-ascii?Q?6kErR5GV0eHctr0QDvqxzNREVPAP25Dmeb9zrD1ep1xoHv9yTTDX7gKdiN0u?=
 =?us-ascii?Q?NJawaT+nxXSeN4tBMxeotRY7gygewf7FqFfQQrBJ7lfz1oqiX8vqDBcMW34m?=
 =?us-ascii?Q?PWGpx4HMzCBoRPW9cNuhNIeJqJJNWbl135KGCuFKTKs88fHh1Jcx+DKpYuVy?=
 =?us-ascii?Q?zHkeGPJMhgo1yBuqqH3sfNu7cVLmdM3yLfpIGzzZ93o/sujp0e7wA1ZNqp/i?=
 =?us-ascii?Q?BHa9gen4mAk7VDIpmUpArHBZrMBq1GBQBU3rHH/1dunoR5KholOH5oeDFoOl?=
 =?us-ascii?Q?uZJbT9ZS/Du1z0q7vSe2fuSxJrL7Ussa1EP6qd8Lu+EcAAUbCIUK1FWjZuk4?=
 =?us-ascii?Q?MQmYdUY+h6F0qBa0B1wCgY4mNplw3yZxMHFAHO6k2M9yHc31KNvAg9M0HfWv?=
 =?us-ascii?Q?idW+5+gujBTQ+lGUNNo5ckK+8j8yUQjRQiBa1KmQk0Hr7qw7q+wItY3fyZJS?=
 =?us-ascii?Q?N3hUQ+f/BNYhdfQ3R/GoS+VFfN5PzZTPn5QSM7nwp7cwKKjapfRaxub8TMVA?=
 =?us-ascii?Q?jk+yJFVvEGgia3pNbur2Ym4pig5/xhNp7l1zZFwFatl+1JdVmO7T9eLI11jQ?=
 =?us-ascii?Q?ooWZfEdJP5YBySQwjLwOajI+Tj4RN6PGATDWTt+HUIGqi3jzM44RwM/GMW6P?=
 =?us-ascii?Q?cPiZuvVia8njM4Y8FWJ/NYzJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df3cabeb-4172-46e2-6999-08d8dfdf8f33
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 14:04:15.0125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ayClP356T20C3iuOPNr87XpOFqWYoujZiyqXanuB3fdGQjgiKLyWDsdwo5dGwQE0XLhg70CEXrCG8DVc/CR+Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 08:59:15AM +0000, Nathan Tempelman wrote:
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
>  arch/x86/kvm/svm/sev.c          | 82 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c          |  2 +
>  arch/x86/kvm/svm/svm.h          |  2 +
>  arch/x86/kvm/x86.c              |  7 ++-
>  include/linux/kvm_host.h        |  1 +
>  include/uapi/linux/kvm.h        |  1 +
>  virt/kvm/kvm_main.c             |  8 ++++
>  9 files changed, 120 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 482508ec7cc4..438b647663c9 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6213,6 +6213,23 @@ the bus lock vm exit can be preempted by a higher priority VM exit, the exit
>  notifications to userspace can be KVM_EXIT_BUS_LOCK or other reasons.
>  KVM_RUN_BUS_LOCK flag is used to distinguish between them.
>  
> +7.23 KVM_CAP_VM_COPY_ENC_CONTEXT_TO
> +-----------------------------------
> +
> +Architectures: x86 SEV enabled
> +Type: system
> +Parameters: args[0] is the fd of the kvm to mirror encryption context to
> +Returns: 0 on success; ENOTTY on error
> +
> +This capability enables userspace to copy encryption context from a primary
> +vm to the vm indicated by the fd.
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
> index 84499aad01a4..b7636c009647 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1334,6 +1334,7 @@ struct kvm_x86_ops {
>  	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
>  	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> +	int (*vm_copy_enc_context_to)(struct kvm *kvm, unsigned int child_fd);
>  
>  	int (*get_msr_feature)(struct kvm_msr_entry *entry);
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 874ea309279f..2bad6cd2cb4c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -66,6 +66,11 @@ static int sev_flush_asids(void)
>  	return ret;
>  }
>  
> +static inline bool is_mirroring_enc_context(struct kvm *kvm)
> +{
> +	return &to_kvm_svm(kvm)->sev_info.enc_context_owner;
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
> @@ -1282,6 +1299,65 @@ int svm_unregister_enc_region(struct kvm *kvm,
>  	return ret;
>  }
>  
> +int svm_vm_copy_asid_to(struct kvm *kvm, unsigned int mirror_kvm_fd)
> +{
> +	struct file *mirror_kvm_file;
> +	struct kvm *mirror_kvm;
> +	struct kvm_sev_info *mirror_kvm_sev;
> +	unsigned int asid;
> +	int ret;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	/* Mirrors of mirrors should work, but let's not get silly */
> +	if (is_mirroring_enc_context(kvm)) {
> +		ret = -ENOTTY;
> +		goto failed;
> +	}

How will A->B->C->... type of live migration work if mirrors of
mirrors are not supported ?

Thanks,
Ashish

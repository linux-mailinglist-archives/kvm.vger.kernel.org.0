Return-Path: <kvm+bounces-6308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BDFB982E882
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 05:15:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19C801F23815
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 04:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F02F79FE;
	Tue, 16 Jan 2024 04:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5dvDu63g"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3A810782;
	Tue, 16 Jan 2024 04:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JayPDIPgFeZzh2qDqidd3HHNtPThXJiMcXs9lQOsnv15/sdKQ55PtJLJQwjB6qSE5yGmRZmLFqCaQdTv2hKQcp2iOdhAUJwQ31qItWg37oR6MxCYbc/xGuBRDmBQJ5pPWo46GXVo6/Dokudw2ze3ReIZwnFy0s88cNayTPHUK+tiO8b6XJ0j8B1Ab4L0sJzQIGrfVRkZKLNQEOz2isczG1mSLsgdF2PpYlNg8f61Ap1eyPjA8Lz2j8EvFVRj5Xd7QQovW/u5BNHXwEXl12s2uQCo8X2ZGTCnu2m6mhhfg0nvMhrECyxO20dCtKBmfscM8LHUPejIJT5CSoJgwaFtkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3fw1rYX+bpHVYNDT6RL4C6tcaGvr2K0220byNOUG5E=;
 b=OvgeW38BWZjKUDhX05gw0h+qRnqq70/niBPQh56nUn0LO2w9YioH6jAehBaJhic7GPNYIypql76kJl/nNTUO9iIrzsj+OD45YAKTNRYQpEUSYLCfNyS3A0MBNSLsyR6ekZ82IHZhplEWmk+ymlarPUi1ijvDIA/iMuktwQ9CG5TF5U+Nuhy8CF5kyXSORQVvO53ielZcMJs+dfjV0E9hdWHC/fG4HPxviuSlhKRz1t7V+EbYgxdy6STnGFxdmQL/9aB8XweNlELg4pEtr0fLY2C5EWiuC35fbh+K1x8PeUJkPP5zUDxD4QoknFtn5hUagdlxrI6z36cu/ZaEsnxCwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3fw1rYX+bpHVYNDT6RL4C6tcaGvr2K0220byNOUG5E=;
 b=5dvDu63gbg5KTmN1Oxhd3oxHR55jYqD+hB75b9cJlARhqem6DbXPxGJAx/nNo+EZPTKIjekrDSv7KBYZz9LjkzPINTXVMQ3SLHjnFsafd+1YH86NaK/TlYlLXEpwdzxyVJzlewR9w1yy8tR9Wx5bzWVzNZKcjd5O4C+LebiRshw=
Received: from MN2PR16CA0043.namprd16.prod.outlook.com (2603:10b6:208:234::12)
 by DS7PR12MB5717.namprd12.prod.outlook.com (2603:10b6:8:70::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.26; Tue, 16 Jan
 2024 04:15:19 +0000
Received: from BL02EPF0001A0FE.namprd03.prod.outlook.com
 (2603:10b6:208:234:cafe::34) by MN2PR16CA0043.outlook.office365.com
 (2603:10b6:208:234::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.23 via Frontend
 Transport; Tue, 16 Jan 2024 04:15:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FE.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7202.16 via Frontend Transport; Tue, 16 Jan 2024 04:15:19 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Mon, 15 Jan
 2024 22:15:17 -0600
Date: Mon, 15 Jan 2024 22:14:57 -0600
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v11 18/35] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Message-ID: <20240116041457.wver7acnwthjaflr@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
 <20231230172351.574091-19-michael.roth@amd.com>
 <ZZ67oJwzAsSvui5U@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZZ67oJwzAsSvui5U@google.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FE:EE_|DS7PR12MB5717:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dde612c-0d03-4705-b3f0-08dc1649c075
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	akEQu0INMcO7VDcqedCuFZpS7CbWu8VJlHCSUwVLBBAbLxs0J/jxAidCN4gO527sTUdMcabiJSnuf5xKjWaRIpxKK6rCNN1/WkjzKdm/vM2tEG2ObbzoS9yHWNQOuzhajGjtVEUUpHfOBWfgCRkb62yAX2Uh35Uhqwh5Yd9o5gZDmjRx+XiL6mIVU2wr9w2vKdFNRmC2gHk0gmlXbUlPhTCM2ns0STG2O5EeCTBPNlm7/W47BitkgaSKHcu36xow01AGGZmX7C5PWvF/pgkbqCBRLQLRJ3BsY4bfVqy42128IQORiUsnwZz4mF5xIcE0Uy6PPuKNdtqeYaD3i4YbR4CWqKGJlfSNYi/7ESKHDV1MybXL1O5byvlXnEQd7yybFzfXQVHlNpvORlMgpv/acQ4cKNai/IzQ92Q9SHSnVQSxDDm2OLFr53tCoEMDCVPFPkE61xApCO73+Ao2OEYkmrXKU0ohVB7F5iXidOYDh5Y+t4RK0niOB7TrjDCflUlS+2mpNAsvmvzBgWukIcnaAoCKnyUr+qOwLhyvHgY3zbPtP4z2kIfMw9QfoVRfCji2FS4QWjUdtCRoLNucVIjkwRmOjC/p41FETu0evgR6dDTuoAx+RwzWlR09ZuyfmNkzIbHFqtpXt9xBsRrYRWcGemXB0ufZv4kmGtNRFzClZ5sqrPDKsFuilO3VYufMY74ap/Qhl7Uf6hvGjc/57T1CaGwpU6I/T6hIWUvwRp+Pjhg/81cwvLmFG+EmX3TJEKHQYLzuTcJaV9UTuTD0DKJcoSkftPK3zWEBh+DTZxlTezE=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(64100799003)(451199024)(1800799012)(82310400011)(186009)(36840700001)(46966006)(40470700004)(966005)(478600001)(16526019)(426003)(6666004)(1076003)(336012)(30864003)(2616005)(26005)(7406005)(2906002)(7416002)(5660300002)(70206006)(70586007)(6916009)(54906003)(316002)(8936002)(44832011)(4326008)(8676002)(36756003)(66899024)(86362001)(36860700001)(83380400001)(41300700001)(47076005)(82740400003)(40480700001)(40460700003)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2024 04:15:19.6505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dde612c-0d03-4705-b3f0-08dc1649c075
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5717

On Wed, Jan 10, 2024 at 07:45:36AM -0800, Sean Christopherson wrote:
> On Sat, Dec 30, 2023, Michael Roth wrote:
> > diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > index b1beb2fe8766..d4325b26724c 100644
> > --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > @@ -485,6 +485,34 @@ Returns: 0 on success, -negative on error
> >  
> >  See the SEV-SNP specification for further detail on the launch input.
> >  
> > +20. KVM_SNP_LAUNCH_UPDATE
> > +-------------------------
> > +
> > +The KVM_SNP_LAUNCH_UPDATE is used for encrypting a memory region. It also
> > +calculates a measurement of the memory contents. The measurement is a signature
> > +of the memory contents that can be sent to the guest owner as an attestation
> > +that the memory was encrypted correctly by the firmware.
> > +
> > +Parameters (in): struct  kvm_snp_launch_update
> > +
> > +Returns: 0 on success, -negative on error
> > +
> > +::
> > +
> > +        struct kvm_sev_snp_launch_update {
> > +                __u64 start_gfn;        /* Guest page number to start from. */
> > +                __u64 uaddr;            /* userspace address need to be encrypted */
> 
> Huh?  Why is KVM taking a userspace address?  IIUC, the address unconditionally
> gets translated into a gfn, so why not pass a gfn?
> 
> And speaking of gfns, AFAICT start_gfn is never used.

I think having both the uaddr and start_gfn parameters makes sense. I
think it's only awkward because how I'm using the memslot to translate
the uaddr to a GFN in the current implementation, but:

 a) It's actually not a requirement that uaddr be associated with a
    memslot. It could just as easily be any random userspace address
    containing the payload that we want to copy into the actual gmem
    pages associated with start_gfn. I think TDX does something similar
    in that regard, and it makes sense to give VMMs the option of
    handling things that way.

 b) If we switch to just having start_gfn, and no uaddr, then things get
    awkward because then you really do need to have a memslot set up to
    get at the payload, and have some way of pre-populating the gmem pages
    prior to conversion, either the way the current code does it (via
    copying shared memory prior to conversion), or by having some way to
    populate the gmem pages directly, which is even more painful.

> 
> Oof, reading more of the code, this *requires* an effective in-place copy-and-convert
> of guest memory.

Yes, I'm having some trouble locating the various threads, but initially
there were some discussions about having a userspace API that allows for
UPM/gmem pages to be pre-populated before they are in-place encrypted, but
we'd all eventually decided that having KVM handle this internally was
the simplest approach.

So that's how it's done here, KVM_SNP_LAUNCH_UPDATE copies the pages into
gmem, then passes those pages on to firmware for encryption. Then the
VMM is expected to mark the GFN range as private via
KVM_SET_MEMORY_ATTRIBUTES, since the VMM understands what constitutes
initial private/encrypted payload. I should document that better in
KVM_SNP_LAUNCH_UPDATE docs however.

> 
> > +                __u32 len;              /* length of memory region */
> 
> Bytes?  Pages?  One field above operates on frame numbers, one apparently operates
> on a byte-granularity address.

If we implement things as mentioned above, it makes sense to decouple
uaddr from any page alignment/size restrictions since it would always be
copied into the target gmem page starting at byte 0. This sort of
assumes that the gmem page will initially be zero'd however, which is
the case currently, but there's a TODO in kvm_gmem_get_folio() about
potentially off-loading that to firmware. I'm not sure it would ever
be applicable for these pages though. Worst case, KVM_SNP_LAUNCH_UPDATE
can pad with 0's.

> 
> > +                __u8 imi_page;          /* 1 if memory is part of the IMI */
> 
> What's "the IMI"?  Initial Measurement Image?

Yes, though the SNP Firmware ABI also references it as "Incoming Migration
Image", which I think is a little clearer about its purpose and so that's
the terminology I've been using in the kernel.

> What's "the IMI"?  Initial Measurement Image?  I assume this is essentially just
> a flag that communicates whether or not the page should be measured?

This is actually for loading a measured migration agent into the target
system so that it can handle receiving the encrypted guest data from the
source. There's still a good deal of planning around how live migration
will be handled however so if you think it's premature to expose this
via KVM I can remove the related fields.

> 
> > +                __u8 page_type;         /* page type */
> > +                __u8 vmpl3_perms;       /* VMPL3 permission mask */
> > +                __u8 vmpl2_perms;       /* VMPL2 permission mask */
> > +                __u8 vmpl1_perms;       /* VMPL1 permission mask */
> 
> Why?  KVM doesn't support VMPLs.

It does actually get used by the SVSM. I can remove these but then we'd
need some capability bit or something to know when they are available if
they get re-introduced. But that may be needed anyway since KVM needs
some additional changes to handle scheduling threads running at
different VMPL levels.

> 
> > +static int snp_page_reclaim(u64 pfn)
> > +{
> > +	struct sev_data_snp_page_reclaim data = {0};
> > +	int err, rc;
> > +
> > +	data.paddr = __sme_set(pfn << PAGE_SHIFT);
> > +	rc = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> > +	if (rc) {
> > +		/*
> > +		 * If the reclaim failed, then page is no longer safe
> > +		 * to use.
> 
> Uh, why can reclaim fail, and why does the kernel apparently not care about
> leaking pages?  AFAICT, nothing ever complains beyond a pr_debug.  That sounds
> bonkers to me, i.e. at the very minimum, why doesn't this warrant a WARN_ON_ONCE?

PAGE_RECLAIM shouldn't happen in practice, so yes, it makes sense to warn
about this when it does. snp_leak_pages() is probably the most
consistent/user-friendly place to convey these failures so I'll add a
pr_warn() there.

> 
> > +		 */
> > +		snp_leak_pages(pfn, 1);
> > +	}
> > +
> > +	return rc;
> > +}
> > +
> > +static int host_rmp_make_shared(u64 pfn, enum pg_level level, bool leak)
> > +{
> > +	int rc;
> > +
> > +	rc = rmp_make_shared(pfn, level);
> > +	if (rc && leak)
> > +		snp_leak_pages(pfn,
> > +			       page_level_size(level) >> PAGE_SHIFT);
> 
> Completely unnecessary wrap.
> 
> > +
> > +	return rc;
> > +}
> > +
> >  static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
> >  {
> >  	struct sev_data_deactivate deactivate;
> > @@ -1990,6 +2020,154 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >  	return rc;
> >  }
> >  
> > +static int snp_launch_update_gfn_handler(struct kvm *kvm,
> > +					 struct kvm_gfn_range *range,
> > +					 void *opaque)
> > +{
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	struct kvm_memory_slot *memslot = range->slot;
> > +	struct sev_data_snp_launch_update data = {0};
> > +	struct kvm_sev_snp_launch_update params;
> > +	struct kvm_sev_cmd *argp = opaque;
> > +	int *error = &argp->error;
> > +	int i, n = 0, ret = 0;
> > +	unsigned long npages;
> > +	kvm_pfn_t *pfns;
> > +	gfn_t gfn;
> > +
> > +	if (!kvm_slot_can_be_private(memslot)) {
> > +		pr_err("SEV-SNP requires private memory support via guest_memfd.\n");
> 
> Yeah, no.  Sprinkling pr_err() all over the place in user-triggerable error paths
> is not acceptable.  I get that it's often hard to extract "what went wrong" out
> of the kernel, but adding pr_err() everywhere is not a viable solution.

Makes sense, I'll drop this.

> 
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params))) {
> > +		pr_err("Failed to copy user parameters for SEV-SNP launch.\n");
> > +		return -EFAULT;
> > +	}
> > +
> > +	data.gctx_paddr = __psp_pa(sev->snp_context);
> > +
> > +	npages = range->end - range->start;
> > +	pfns = kvmalloc_array(npages, sizeof(*pfns), GFP_KERNEL_ACCOUNT);
> > +	if (!pfns)
> > +		return -ENOMEM;
> > +
> > +	pr_debug("%s: GFN range 0x%llx-0x%llx, type %d\n", __func__,
> > +		 range->start, range->end, params.page_type);
> > +
> > +	for (gfn = range->start, i = 0; gfn < range->end; gfn++, i++) {
> > +		int order, level;
> > +		bool assigned;
> > +		void *kvaddr;
> > +
> > +		ret = __kvm_gmem_get_pfn(kvm, memslot, gfn, &pfns[i], &order, false);
> > +		if (ret)
> > +			goto e_release;
> > +
> > +		n++;
> > +		ret = snp_lookup_rmpentry((u64)pfns[i], &assigned, &level);
> > +		if (ret || assigned) {
> > +			pr_err("Failed to ensure GFN 0x%llx is in initial shared state, ret: %d, assigned: %d\n",
> > +			       gfn, ret, assigned);
> > +			return -EFAULT;
> > +		}
> > +
> > +		kvaddr = pfn_to_kaddr(pfns[i]);
> > +		if (!virt_addr_valid(kvaddr)) {
> 
> I really, really don't like that this assume guest_memfd is backed by struct page.

There are similar enforcements in the SEV/SEV-ES code. There was some
initial discussion about relaxing this for SNP so we could support
things like /dev/mem-mapped guest memory, but then guest_memfd came
along and made that to be an unlikely use-case in the near-term given
that it relies on alloc_pages() currently and explicitly guards against
mmap()'ing pages in userspace.

I think it makes to keep the current tightened restrictions in-place
until such a use-case comes along, since otherwise we are relaxing a
bunch of currently-useful sanity checks that span all throughout the code
to support some nebulous potential use-case that might never come along.
I think it makes more sense to cross that bridge when we get there.

> 
> > +			pr_err("Invalid HVA 0x%llx for GFN 0x%llx\n", (uint64_t)kvaddr, gfn);
> > +			ret = -EINVAL;
> > +			goto e_release;
> > +		}
> > +
> > +		ret = kvm_read_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
> 
> Good gravy.  If I'm reading this correctly, KVM:
> 
>   1. Translates an HVA into a GFN.
>   2. Gets the PFN for that GFN from guest_memfd
>   3. Verifies the PFN is not assigned to the guest
>   4. Copies memory from the shared memslot page to the guest_memfd page
>   5. Converts the page to private and asks the PSP to encrypt it
> 
> (a) As above, why is #1 a thing?

Yah, it's probably best to avoid this, as proposed above.

> (b) Why are KVM's memory attributes never consulted?

It doesn't really matter if the attributes are set before or after
KVM_SNP_LAUNCH_UPDATE, only that by the time the guest actually launches
they pages get set to private so they get faulted in from gmem. We could
document our expectations and enforce them here if that's preferable
however. Maybe requiring KVM_SET_MEMORY_ATTRIBUTES(private) in advance
would make it easier to enforce that userspace does the right thing.
I'll see how that looks if there are no objections.

> (c) What prevents TOCTOU issues with respect to the RMP?

Time-of-use will be when the guest faults the gmem page in with C-bit
set. If it is not in the expected Guest-owned/pre-validated state that
SEV_CMD_SNP_LAUNCH_UPDATE expected/set, then the guest will get an RMP
fault or #VC exception for unvalidated page access. It will also fail
attestation. Not sure if that covers the scenarios you had in mind.

> (d) Why is *KVM* copying memory into guest_memfd?

As mentioned above, there were various discussions of ways of allowing
userspace to pwrite() to the guest_memfd in advance of
"sealing"/"binding" it and then encrypting it in place. I think this was
one of the related threads:

  https://lore.kernel.org/linux-mm/YkyKywkQYbr9U0CA@google.com/

My read at the time was that the requirements between pKVM/TDX/SNP were all
so unique that we'd spin forever trying to come up with a userspace ABI
that worked for everyone. At the time you'd suggested for pKVM to handle
their specific requirements internally in pKVM to avoid unecessary churn on
TDX/SNP side, and I took the same approach with SNP in implementing it
internally in SNP's KVM interfaces since it seemed unlikely there would
be much common ground with how TDX handles it via KVM_TDX_INIT_MEM_REGION.

> (e) What guarantees the direct map is valid for guest_memfd?

Are you suggesting this may change in the near-term? If so, we can
re-work the code to write to guest_memfd via a temporary mapping or
something, but otherwise it seems awkward to account for that scenario
in current code given that SNP specifically has hooks to remove/re-add
directmap entries based on RMPUPDATEs to avoid host breakage, so we
would necessarily need to implement changes if guest_memfd ever made
any changes in this regard.

And we had prior discussions about handling directmap invalidation in
guest_memfd, but Kirill mentioned here[1] that special handling didn't
actually seem to be a requirement of TDX private memory, and so it
didn't seem likely that pushing that into gmem would be a welcome
change.

All that said, TDX does still seem to invalidate directmap entries as
part of tdh_mem_page_add(), so maybe there is a requirement there and
this is worth revisiting?

If so though, it's worth mentioning that cpa_lock contention on
directmap updates is actually a significant contributor to some
scalability issues we've noticed with lots of guests/vCPUs doing lazy
acceptance and needing to frequently invalidate directmap entries as part
of rmpupdate() during gmem allocations, so we're considering just forcing
a 4K directmap for SNP until directmap updates can scale better, so that
might be another reason to not have guest_memfd in the business of
managing directmap updates until there's some concrete use-case in
sight, like being able to rebuild 2MB/1GB directmap entries in a
scalable way during run-time.

[1] https://lore.kernel.org/linux-mm/20221102212656.6giugw542jdxsvhh@amd.com/

> (f) Why does KVM's uAPI *require* the source page to come from the same memslot?

As mentioned above, I think it makes sense to do away with this
requirement and just treat source page as any other user-provided blob.

> 
> > +		if (ret) {
> > +			pr_err("Guest read failed, ret: 0x%x\n", ret);
> > +			goto e_release;
> > +		}
> > +
> > +		ret = rmp_make_private(pfns[i], gfn << PAGE_SHIFT, PG_LEVEL_4K,
> > +				       sev_get_asid(kvm), true);
> > +		if (ret) {
> > +			ret = -EFAULT;
> > +			goto e_release;
> > +		}
> > +
> > +		data.address = __sme_set(pfns[i] << PAGE_SHIFT);
> > +		data.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
> > +		data.page_type = params.page_type;
> > +		data.vmpl3_perms = params.vmpl3_perms;
> > +		data.vmpl2_perms = params.vmpl2_perms;
> > +		data.vmpl1_perms = params.vmpl1_perms;
> > +		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
> > +				      &data, error);
> > +		if (ret) {
> > +			pr_err("SEV-SNP launch update failed, ret: 0x%x, fw_error: 0x%x\n",
> > +			       ret, *error);
> > +			snp_page_reclaim(pfns[i]);
> > +
> > +			/*
> > +			 * When invalid CPUID function entries are detected, the firmware
> > +			 * corrects these entries for debugging purpose and leaves the
> > +			 * page unencrypted so it can be provided users for debugging
> > +			 * and error-reporting.
> > +			 *
> > +			 * Copy the corrected CPUID page back to shared memory so
> > +			 * userpsace can retrieve this information.
> 
> Why?  IIUC, this is basically backdooring reads/writes into guest_memfd to avoid
> having to add proper mmap() support.

The CPUID page is private/encrypted, so it needs to be a gmem page.
SNP firmware is doing the backdooring when it writes the unencrypted,
expected contents into the page during failure. What's wrong with copying
the contents back into the source page so userspace can be use of it?
If we implement the above-mentioned changes then the source page is just
a userspace buffer that isn't necessarily associated with a memslot, so
it becomes even more straightforward.

Would that be acceptable? I'm not sure what you're proposing with
mmap().

>  
> > +			 */
> > +			if (params.page_type == SNP_PAGE_TYPE_CPUID &&
> > +			    *error == SEV_RET_INVALID_PARAM) {
> > +				int ret;
> 
> Ugh, do not shadow variables.

Will fix.

> 
> > +
> > +				host_rmp_make_shared(pfns[i], PG_LEVEL_4K, true);
> > +
> > +				ret = kvm_write_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
> > +				if (ret)
> > +					pr_err("Failed to write CPUID page back to userspace, ret: 0x%x\n",
> > +					       ret);
> > +			}
> > +
> > +			goto e_release;
> > +		}
> > +	}
> > +
> > +e_release:
> > +	/* Content of memory is updated, mark pages dirty */
> > +	for (i = 0; i < n; i++) {
> > +		set_page_dirty(pfn_to_page(pfns[i]));
> > +		mark_page_accessed(pfn_to_page(pfns[i]));
> > +
> > +		/*
> > +		 * If its an error, then update RMP entry to change page ownership
> > +		 * to the hypervisor.
> > +		 */
> > +		if (ret)
> > +			host_rmp_make_shared(pfns[i], PG_LEVEL_4K, true);
> > +
> > +		put_page(pfn_to_page(pfns[i]));
> > +	}
> > +
> > +	kvfree(pfns);
> 
> Saving PFNs from guest_memfd, which is fully owned by KVM, is so unnecessarily
> complex.  Add a guest_memfd API (or three) to do this safely, e.g. to lock the
> pages, do (and track) the RMP conversion, etc...

Is adding 3 gmem APIs and tracking RMP states inside gmem really less
complex than what's going on here? The PFNs are only held on to for the
duration of this single function so they can be cleanly rolled back, and
we're using blessed interfaces like kvm_gmem_get_pfn() to get at them.

There's some nuances here that I'm not sure will map to a re-usable gmem
API that would benefit other users. For instance, we need to:

  1) grab the gmem PFN
  2) initialize it in some platform-specific way (copy from source buffer in this case)
  3) switch it private in RMP table
  4) execute SEV_CMD_SNP_LAUNCH_UPDATE firmware cmd

If 2-4 can all be done with self-contained platform-specific callback,
then I could add a gmem API like:

  gmem_initialize_gfn_range(start, end, func, opaque)

  where:
    func: does roughly what snp_launch_update_gfn_handler currently does for
          each PFN it is handed
    opaque: some data structure that would provide the source buffer to
            initialize the gmem pages from

Is that along the lines of what you're suggesting? It wouldn't involve
"tracking" RMP conversions, 'func' would be aware of that for each
PFN it is handed, but it's simple enough that it is easily re-usable for
other platforms without too much fuss.

If you really want to build some deeper tracking of RMP table states
into gmem internals, then I could really use your feedback on the
gmem_prepare() hook I added in this RFC[2] and included as part of this
series, because I ended up not implementing tracking for number of
reason detailed under "Hooks for preparing gmem pages" in the RFC cover
letter and would likely need to revisit that aspect first before
building out this interface.

[2] https://lore.kernel.org/kvm/20231016115028.996656-1-michael.roth@amd.com/

Thanks,

Mike


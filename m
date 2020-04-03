Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9F619E04F
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 23:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgDCVa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 17:30:56 -0400
Received: from mail-co1nam11on2079.outbound.protection.outlook.com ([40.107.220.79]:63745
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727867AbgDCVa4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 17:30:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCneqrFJEN8uzev/BTp7xhpZXbaoCaB7xoFCmVz1GFu0J4wIxZ6yAFid+F8RIKpxUYqJWLPEV24UBt2RfoVfutp3V5VOw4Pc88RfI+pcJ1xfcyhsiTDpBG6+xL7KFKnGWIwtnmN2A65BX5McowQWxbox66+GsRfAk21MZw0iNrH+z6yTtOwZErfpqOAzgikosmW07sVfN8eZkyEKj7wP7IKjBVZs6kuNwdzbtWizMeMlvQre/LELmRUSJPUUsNLe20C7Qw9Xx+mLlv0TzfEe++0oX4PIQA4lwBXFOgctVUcwAoyVUlhZAL/U1RKtgDq8AjKrWh61c7eCaYuRj84+Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jK2edjIOXizjiDDqPW5la2QKu8WsSi1q5NHsbSJCto=;
 b=cW8D4RGy72wCkET+bS+YcpVJ1Ht+cP6VYVIAdUO/Gz4bFftxsKtbANJUhwMmBl4o/J31qrI+ggsL+oEm41n375Tj92P/bqpsoWkxsLyRmQFCej2DriLyMnKRyelpvdfHplvOChmMoN2HEi8tFlLZnZ5I1d7w3jCxcd6DiCSiwVLw/hSkF5oPv5Og1DwdM6EesXZFbmWaERuEhwTkgoWqvjiXpCbf/yOK82jCp8GwFY/H+9GWlviOJIXt/xAHifPTZqUbQmMRmSGzNZ1zRv7r+9BoQrfhTIdhV5i0uD20IBqBKprZoyhkjockHFTPpc8KP2b4/dJzhb18JVRwhikCyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jK2edjIOXizjiDDqPW5la2QKu8WsSi1q5NHsbSJCto=;
 b=pkpSzmizsh2xzfEvaRh0MHA28jmtMFff7G/I+ExX9QjSNqH+9fUtpb5mjTUx9I5AjHpueCsFoqv4ObE9lqeRTf018/PoYVCTyz7ADoP5+MH1uus+zGHavzVdXE4N4o+9l1DAM/KCNC1bBhLw68zxYwQvMjsN7yxzJgk5wCz8T6w=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.19; Fri, 3 Apr 2020 21:30:16 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.017; Fri, 3 Apr 2020
 21:30:16 +0000
Date:   Fri, 3 Apr 2020 21:30:09 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 10/14] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20200403213009.GA28747@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <05c9015fb13b25c07a84d5638a7cd65a8c136cf0.1585548051.git.ashish.kalra@amd.com>
 <4021365b-c43a-02ae-475c-626199c8c451@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4021365b-c43a-02ae-475c-626199c8c451@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN4PR0201CA0067.namprd02.prod.outlook.com
 (2603:10b6:803:20::29) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0201CA0067.namprd02.prod.outlook.com (2603:10b6:803:20::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.17 via Frontend Transport; Fri, 3 Apr 2020 21:30:15 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7287d7b8-e11b-4e07-8ae3-08d7d816335e
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2518F4128F2856C3D25559E38EC70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0362BF9FDB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(5660300002)(4326008)(9686003)(55016002)(66574012)(81156014)(956004)(26005)(33716001)(16526019)(33656002)(1076003)(8676002)(186003)(6666004)(44832011)(8936002)(86362001)(66946007)(478600001)(81166006)(66476007)(66556008)(7416002)(316002)(53546011)(52116002)(6916009)(2906002)(6496006);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2fd7KmAbUljv3PHukzPXk5IYfQ+SV1sltUxQfOvtOSMnWoanDfVcnc80+bPkwvSrwMExd6VNfloD2NAu4FDwraYuTez8KnDEJiIbkENMm9pajio/dOeWM/xAP/xNJUOPngy6UsrJyOSZT0ElTScti6nZjvQD46gi7jZGpXENw9fa/otWg9NXmek6VoVLmQ35+rIbE2dOEh2V4tSgghzEWE/XUXcuyWqmMs76fFYvbEtlcvcH+OFjFQ1di5p1D/Rf/HJahOT0HHHqxkPmCeCUom1YOp2oQJ9GF89Vj3U+BNX4KFHmR5VZlFJL4HVj859J0fXzXYv/Z1KrmJ1weiVm0lJj7XQvsP+dZApYUh9k+rhp3s2xFToHnQRDGR+D7mjAjYQLTHYOgLJJoeZ3CpbbVumXFETChAzkU7/Bkupx3NxGVZEZf83bWPqdCP/H7cUQ
X-MS-Exchange-AntiSpam-MessageData: 8rqJrSVPXhdvUTeerLQkAbTojA66J2jiaX29RDN9CkeUD06LVIz2y2PEG8jkz0nabWR2wyakrkFC1iQW9Smh7Uw7sCWfqd/Tir/vllOCkNBYOngwxm1zmQcgfUTHJ4T0wqptlsx/xp82cRHWN5lAbw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7287d7b8-e11b-4e07-8ae3-08d7d816335e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2020 21:30:16.1227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrxJ/sPt/tdLfnLvhPcUS9qwcxobcYAyoxnwFX0p3bxEP8uP0JNbVoICJEi3Eqa8OKdlMaBVnXLMDt1OQM825w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 03, 2020 at 02:07:02PM -0700, Krish Sadhukhan wrote:
> 
> On 3/29/20 11:22 PM, Ashish Kalra wrote:
> > From: Brijesh Singh <Brijesh.Singh@amd.com>
> > 
> > Invoke a hypercall when a memory region is changed from encrypted ->
> > decrypted and vice versa. Hypervisor need to know the page encryption
> > status during the guest migration.
> > 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >   arch/x86/include/asm/paravirt.h       | 10 +++++
> >   arch/x86/include/asm/paravirt_types.h |  2 +
> >   arch/x86/kernel/paravirt.c            |  1 +
> >   arch/x86/mm/mem_encrypt.c             | 57 ++++++++++++++++++++++++++-
> >   arch/x86/mm/pat/set_memory.c          |  7 ++++
> >   5 files changed, 76 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> > index 694d8daf4983..8127b9c141bf 100644
> > --- a/arch/x86/include/asm/paravirt.h
> > +++ b/arch/x86/include/asm/paravirt.h
> > @@ -78,6 +78,12 @@ static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
> >   	PVOP_VCALL1(mmu.exit_mmap, mm);
> >   }
> > +static inline void page_encryption_changed(unsigned long vaddr, int npages,
> > +						bool enc)
> > +{
> > +	PVOP_VCALL3(mmu.page_encryption_changed, vaddr, npages, enc);
> > +}
> > +
> >   #ifdef CONFIG_PARAVIRT_XXL
> >   static inline void load_sp0(unsigned long sp0)
> >   {
> > @@ -946,6 +952,10 @@ static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
> >   static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
> >   {
> >   }
> > +
> > +static inline void page_encryption_changed(unsigned long vaddr, int npages, bool enc)
> > +{
> > +}
> >   #endif
> >   #endif /* __ASSEMBLY__ */
> >   #endif /* _ASM_X86_PARAVIRT_H */
> > diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> > index 732f62e04ddb..03bfd515c59c 100644
> > --- a/arch/x86/include/asm/paravirt_types.h
> > +++ b/arch/x86/include/asm/paravirt_types.h
> > @@ -215,6 +215,8 @@ struct pv_mmu_ops {
> >   	/* Hook for intercepting the destruction of an mm_struct. */
> >   	void (*exit_mmap)(struct mm_struct *mm);
> > +	void (*page_encryption_changed)(unsigned long vaddr, int npages,
> > +					bool enc);
> >   #ifdef CONFIG_PARAVIRT_XXL
> >   	struct paravirt_callee_save read_cr2;
> > diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> > index c131ba4e70ef..840c02b23aeb 100644
> > --- a/arch/x86/kernel/paravirt.c
> > +++ b/arch/x86/kernel/paravirt.c
> > @@ -367,6 +367,7 @@ struct paravirt_patch_template pv_ops = {
> >   			(void (*)(struct mmu_gather *, void *))tlb_remove_page,
> >   	.mmu.exit_mmap		= paravirt_nop,
> > +	.mmu.page_encryption_changed	= paravirt_nop,
> >   #ifdef CONFIG_PARAVIRT_XXL
> >   	.mmu.read_cr2		= __PV_IS_CALLEE_SAVE(native_read_cr2),
> > diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> > index f4bd4b431ba1..c9800fa811f6 100644
> > --- a/arch/x86/mm/mem_encrypt.c
> > +++ b/arch/x86/mm/mem_encrypt.c
> > @@ -19,6 +19,7 @@
> >   #include <linux/kernel.h>
> >   #include <linux/bitops.h>
> >   #include <linux/dma-mapping.h>
> > +#include <linux/kvm_para.h>
> >   #include <asm/tlbflush.h>
> >   #include <asm/fixmap.h>
> > @@ -29,6 +30,7 @@
> >   #include <asm/processor-flags.h>
> >   #include <asm/msr.h>
> >   #include <asm/cmdline.h>
> > +#include <asm/kvm_para.h>
> >   #include "mm_internal.h"
> > @@ -196,6 +198,47 @@ void __init sme_early_init(void)
> >   		swiotlb_force = SWIOTLB_FORCE;
> >   }
> > +static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
> > +					bool enc)
> > +{
> > +	unsigned long sz = npages << PAGE_SHIFT;
> > +	unsigned long vaddr_end, vaddr_next;
> > +
> > +	vaddr_end = vaddr + sz;
> > +
> > +	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
> > +		int psize, pmask, level;
> > +		unsigned long pfn;
> > +		pte_t *kpte;
> > +
> > +		kpte = lookup_address(vaddr, &level);
> > +		if (!kpte || pte_none(*kpte))
> > +			return;
> > +
> > +		switch (level) {
> > +		case PG_LEVEL_4K:
> > +			pfn = pte_pfn(*kpte);
> > +			break;
> > +		case PG_LEVEL_2M:
> > +			pfn = pmd_pfn(*(pmd_t *)kpte);
> > +			break;
> > +		case PG_LEVEL_1G:
> > +			pfn = pud_pfn(*(pud_t *)kpte);
> > +			break;
> > +		default:
> > +			return;
> > +		}
> 
> 
> Is it possible to re-use the code in __set_clr_pte_enc() ?
> 
> > +
> > +		psize = page_level_size(level);
> > +		pmask = page_level_mask(level);
> > +
> > +		kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> > +				   pfn << PAGE_SHIFT, psize >> PAGE_SHIFT, enc);
> > +
> > +		vaddr_next = (vaddr & pmask) + psize;
> > +	}
> > +}
> > +
> >   static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
> >   {
> >   	pgprot_t old_prot, new_prot;
> > @@ -253,12 +296,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
> >   static int __init early_set_memory_enc_dec(unsigned long vaddr,
> >   					   unsigned long size, bool enc)
> >   {
> > -	unsigned long vaddr_end, vaddr_next;
> > +	unsigned long vaddr_end, vaddr_next, start;
> >   	unsigned long psize, pmask;
> >   	int split_page_size_mask;
> >   	int level, ret;
> >   	pte_t *kpte;
> > +	start = vaddr;
> >   	vaddr_next = vaddr;
> >   	vaddr_end = vaddr + size;
> > @@ -313,6 +357,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
> >   	ret = 0;
> > +	set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
> > +					enc);
> 
> 
> If I haven't missed anything, it seems early_set_memory_encrypted() doesn't
> have a caller. So is there a possibility that we can end up calling it in
> non-SEV context and hence do we need to have the sev_active() guard here ?
> 

As of now early_set_memory_encrypted() is not used, but
early_set_memory_decrypted() is used in __set_percpu_decrypted() and
that is called with the sev_active() check.

Thanks,
Ashish

> >   out:
> >   	__flush_tlb_all();
> >   	return ret;
> > @@ -451,6 +497,15 @@ void __init mem_encrypt_init(void)
> >   	if (sev_active())
> >   		static_branch_enable(&sev_enable_key);
> > +#ifdef CONFIG_PARAVIRT
> > +	/*
> > +	 * With SEV, we need to make a hypercall when page encryption state is
> > +	 * changed.
> > +	 */
> > +	if (sev_active())
> > +		pv_ops.mmu.page_encryption_changed = set_memory_enc_dec_hypercall;
> > +#endif
> > +
> >   	pr_info("AMD %s active\n",
> >   		sev_active() ? "Secure Encrypted Virtualization (SEV)"
> >   			     : "Secure Memory Encryption (SME)");
> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > index c4aedd00c1ba..86b7804129fc 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -26,6 +26,7 @@
> >   #include <asm/proto.h>
> >   #include <asm/memtype.h>
> >   #include <asm/set_memory.h>
> > +#include <asm/paravirt.h>
> >   #include "../mm_internal.h"
> > @@ -1987,6 +1988,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
> >   	 */
> >   	cpa_flush(&cpa, 0);
> > +	/* Notify hypervisor that a given memory range is mapped encrypted
> > +	 * or decrypted. The hypervisor will use this information during the
> > +	 * VM migration.
> > +	 */
> > +	page_encryption_changed(addr, numpages, enc);
> > +
> >   	return ret;
> >   }

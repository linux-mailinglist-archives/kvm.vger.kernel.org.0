Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D0F36B05F
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 11:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhDZJTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 05:19:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232227AbhDZJTr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 05:19:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619428746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fRCyfgt+GT8qVzI/ka9K9YgFmaZJUiE4kycK1aliTbQ=;
        b=GcUuU7D6HdzaSMKuejtc790zqfPOP8apNshg157fLXPnSBA2EkuG9CDRMlwzEx8Djy6Qso
        /yxhZ6CGGzKF8fGCAesKCCl8Y/1TdMEQev7h09BdG0WYiGD6NX2HsW1ce9+e+ostTeGAHL
        WMnvfIK0p7zktLthbewAqikg5qdkv2w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-TX_cFlKrMRmR7U9cNSlufw-1; Mon, 26 Apr 2021 05:19:04 -0400
X-MC-Unique: TX_cFlKrMRmR7U9cNSlufw-1
Received: by mail-wr1-f70.google.com with SMTP id d15-20020a5d538f0000b02901027c18c581so18531871wrv.3
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:19:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fRCyfgt+GT8qVzI/ka9K9YgFmaZJUiE4kycK1aliTbQ=;
        b=UvXZyecpX0G1G6fkqkCbJE60GeicurpfK9ULO93P3wYfqNvIKvDJsGIDKqMsk6uEzo
         V0e606PebKQhai4+WvEzStF4STRD8PSqTq9i7lLoDTWbY1bCyl888o4GSSzdJf881f1v
         i9bAswYX1PWzupNIhFkZj7t4Nmlvh3es92cBQywSVbqVkz1gBhBsIoHeN+qjucb2R+oy
         HxU99seT9nb+j9Ud8mH3g0EXdQ/eB8csctJqEbMihAGDUGPw9DdtTPMSbI+MHu/ah1QY
         H9ionyRPQkpGXypaH5YH9ekxnfETABy4xbvV9aQ6N+vfSil10PgU/dj0ABA60GX0+1Jr
         xS2Q==
X-Gm-Message-State: AOAM533CdxOx4Q65alHyaP0vIhnaJtHjkCu75JR/qie9Jjvc/advFZ8B
        XUvQBGh9h5/2XM0aS5N21lMuG64O+uN4SGxuyceCI98BGjtKEKwAROcEteoBqforIj7UDNR7hhM
        PgW7MUJW8IljT
X-Received: by 2002:adf:e8cf:: with SMTP id k15mr21728500wrn.112.1619428742901;
        Mon, 26 Apr 2021 02:19:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqBil6n9yqk3CWzfM8Zj932AzB4CmXTIFLjwMe5+KjlQIDSW9nCr97slFOzg/FmNvBuR6MeQ==
X-Received: by 2002:adf:e8cf:: with SMTP id k15mr21728481wrn.112.1619428742704;
        Mon, 26 Apr 2021 02:19:02 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id f8sm16705127wmc.8.2021.04.26.02.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 02:19:02 -0700 (PDT)
Date:   Mon, 26 Apr 2021 11:18:55 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests v2 6/8] arm/arm64: setup: Consolidate
 memory layout assumptions
Message-ID: <20210426091855.hnl2nqx6a7myqxpo@gator>
References: <20210420190002.383444-1-drjones@redhat.com>
 <20210420190002.383444-7-drjones@redhat.com>
 <76d8685f-8028-873e-849b-1fbc0d33e95e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76d8685f-8028-873e-849b-1fbc0d33e95e@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 25, 2021 at 11:35:29AM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 4/20/21 8:00 PM, Andrew Jones wrote:
> > Keep as much memory layout assumptions as possible in init::start
> > and a single setup function. This prepares us for calling setup()
> > from different start functions which have been linked with different
> > linker scripts. To do this, stacktop is only referenced from
> > init::start, making freemem_start a parameter to setup(). We also
> > split mem_init() into three parts, one that populates the mem regions
> > per the DT, one that populates the mem regions per assumptions,
> > and one that does the mem init. The concept of a primary region
> > is dropped, but we add a sanity check for the absence of memory
> > holes, because we don't know how to deal with them yet.
> >
> > Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arm/cstart.S        |   4 +-
> >  arm/cstart64.S      |   2 +
> >  arm/flat.lds        |  23 ++++++
> >  lib/arm/asm/setup.h |   8 +-
> >  lib/arm/mmu.c       |   2 -
> >  lib/arm/setup.c     | 173 ++++++++++++++++++++++++--------------------
> >  6 files changed, 127 insertions(+), 85 deletions(-)
> >
> > diff --git a/arm/cstart.S b/arm/cstart.S
> > index bf3c78157e6a..446966de350d 100644
> > --- a/arm/cstart.S
> > +++ b/arm/cstart.S
> > @@ -80,7 +80,9 @@ start:
> >  
> >  	/* complete setup */
> >  	pop	{r0-r1}
> > -	bl	setup
> > +	mov	r3, #0
> > +	ldr	r2, =stacktop		@ r2,r3 is the base of free memory
> > +	bl	setup			@ r0 is the addr of the dtb
> >  
> >  	/* run the test */
> >  	ldr	r0, =__argc
> > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > index 27251fe8b5cd..42ba3a3ca249 100644
> > --- a/arm/cstart64.S
> > +++ b/arm/cstart64.S
> > @@ -92,6 +92,8 @@ start:
> >  	bl	exceptions_init
> >  
> >  	/* complete setup */
> > +	adrp	x1, stacktop
> > +	add	x1, x1, :lo12:stacktop		// x1 is the base of free memory
> >  	bl	setup				// x0 is the addr of the dtb
> >  
> >  	/* run the test */
> > diff --git a/arm/flat.lds b/arm/flat.lds
> > index 6ed377c0eaa0..6fb459efb815 100644
> > --- a/arm/flat.lds
> > +++ b/arm/flat.lds
> > @@ -1,3 +1,26 @@
> > +/*
> > + * init::start will pass stacktop to setup() as the base of free memory.
> > + * setup() will then move the FDT and initrd to that base before calling
> > + * mem_init(). With those movements and this linker script, we'll end up
> > + * having the following memory layout:
> > + *
> > + *    +----------------------+   <-- top of physical memory
> > + *    |                      |
> > + *    ~                      ~
> > + *    |                      |
> > + *    +----------------------+   <-- top of initrd
> > + *    |                      |
> > + *    +----------------------+   <-- top of FDT
> > + *    |                      |
> > + *    +----------------------+   <-- top of cpu0's stack
> > + *    |                      |
> > + *    +----------------------+   <-- top of text/data/bss sections
> > + *    |                      |
> > + *    |                      |
> > + *    +----------------------+   <-- load address
> > + *    |                      |
> > + *    +----------------------+   <-- physical address 0x0
> > + */
> >  
> >  SECTIONS
> >  {
> > diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> > index 210c14f818fb..f0e70b119fb0 100644
> > --- a/lib/arm/asm/setup.h
> > +++ b/lib/arm/asm/setup.h
> > @@ -13,9 +13,8 @@
> >  extern u64 cpus[NR_CPUS];	/* per-cpu IDs (MPIDRs) */
> >  extern int nr_cpus;
> >  
> > -#define MR_F_PRIMARY		(1U << 0)
> > -#define MR_F_IO			(1U << 1)
> > -#define MR_F_CODE		(1U << 2)
> > +#define MR_F_IO			(1U << 0)
> > +#define MR_F_CODE		(1U << 1)
> >  #define MR_F_UNKNOWN		(1U << 31)
> >  
> >  struct mem_region {
> > @@ -26,6 +25,7 @@ struct mem_region {
> >  extern struct mem_region *mem_regions;
> >  extern phys_addr_t __phys_offset, __phys_end;
> >  
> > +extern struct mem_region *mem_region_find(phys_addr_t paddr);
> >  extern unsigned int mem_region_get_flags(phys_addr_t paddr);
> >  
> >  #define PHYS_OFFSET		(__phys_offset)
> > @@ -35,6 +35,6 @@ extern unsigned int mem_region_get_flags(phys_addr_t paddr);
> >  #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
> >  #define SMP_CACHE_BYTES		L1_CACHE_BYTES
> >  
> > -void setup(const void *fdt);
> > +void setup(const void *fdt, phys_addr_t freemem_start);
> >  
> >  #endif /* _ASMARM_SETUP_H_ */
> > diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> > index 4e3cf37e33d0..10df98e7a955 100644
> > --- a/lib/arm/mmu.c
> > +++ b/lib/arm/mmu.c
> > @@ -175,12 +175,10 @@ void *setup_mmu(phys_addr_t phys_end)
> >  		if (r->flags & MR_F_IO) {
> >  			continue;
> >  		} else if (r->flags & MR_F_CODE) {
> > -			assert_msg(r->flags & MR_F_PRIMARY, "Unexpected code region");
> >  			/* armv8 requires code shared between EL1 and EL0 to be read-only */
> >  			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
> >  					   __pgprot(PTE_WBWA | PTE_USER | PTE_RDONLY));
> >  		} else {
> > -			assert_msg(r->flags & MR_F_PRIMARY, "Unexpected data region");
> >  			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
> >  					   __pgprot(PTE_WBWA | PTE_USER));
> >  		}
> > diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> > index 7db308b70744..a5ebec3c5a12 100644
> > --- a/lib/arm/setup.c
> > +++ b/lib/arm/setup.c
> > @@ -28,9 +28,10 @@
> >  
> >  #include "io.h"
> >  
> > -#define NR_INITIAL_MEM_REGIONS 16
> > +#define MAX_DT_MEM_REGIONS	16
> > +#define NR_EXTRA_MEM_REGIONS	16
> > +#define NR_INITIAL_MEM_REGIONS	(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
> >  
> > -extern unsigned long stacktop;
> >  extern unsigned long etext;
> >  
> >  struct timer_state __timer_state;
> > @@ -75,28 +76,68 @@ static void cpu_init(void)
> >  	set_cpu_online(0, true);
> >  }
> >  
> > -unsigned int mem_region_get_flags(phys_addr_t paddr)
> > +static void mem_region_add(struct mem_region *r)
> > +{
> > +	struct mem_region *r_next = mem_regions;
> > +	int i = 0;
> > +
> > +	for (; r_next->end; ++r_next, ++i)
> > +		;
> > +	assert(i != NR_INITIAL_MEM_REGIONS);
> 
> Shouldn't that be i < NR_INITIAL_MEM_REGIONS?

Indeed. Will fix.

> I think it conveys intention better,
> and also helps catch situations where we've set in other parts of the code the
> entire mem_regions array, from index 0 to index NR_INITIAL_MEM_REGIONS (at least),
> which is an error.
> 
> > +
> > +	*r_next = *r;
> > +}
> > +
> > +static void mem_regions_get_dt_regions(void)
> > +{
> > +	struct dt_pbus_reg regs[MAX_DT_MEM_REGIONS];
> > +	int nr_regs, i;
> > +
> > +	nr_regs = dt_get_memory_params(regs, MAX_DT_MEM_REGIONS);
> > +	assert(nr_regs > 0);
> > +
> > +	for (i = 0; i < nr_regs; ++i) {
> > +		mem_region_add(&(struct mem_region){
> > +			.start = regs[i].addr,
> > +			.end = regs[i].addr + regs[i].size,
> > +		});
> > +	}
> > +}
> > +
> > +struct mem_region *mem_region_find(phys_addr_t paddr)
> >  {
> >  	struct mem_region *r;
> >  
> > -	for (r = mem_regions; r->end; ++r) {
> > +	for (r = mem_regions; r->end; ++r)
> >  		if (paddr >= r->start && paddr < r->end)
> > -			return r->flags;
> > -	}
> > +			return r;
> > +	return NULL;
> > +}
> >  
> > -	return MR_F_UNKNOWN;
> > +unsigned int mem_region_get_flags(phys_addr_t paddr)
> > +{
> > +	struct mem_region *r = mem_region_find(paddr);
> > +	return r ? r->flags : MR_F_UNKNOWN;
> >  }
> >  
> > -static void mem_init(phys_addr_t freemem_start)
> > +static void mem_regions_add_assumed(void)
> >  {
> >  	phys_addr_t code_end = (phys_addr_t)(unsigned long)&etext;
> > -	struct dt_pbus_reg regs[NR_INITIAL_MEM_REGIONS];
> > -	struct mem_region mem = {
> > -		.start = (phys_addr_t)-1,
> > +	struct mem_region *r;
> > +
> > +	r = mem_region_find(code_end - 1);
> > +	assert(r);
> > +
> > +	/* Split the region with the code into two regions; code and data */
> > +	mem_region_add(&(struct mem_region){
> > +		.start = code_end,
> > +		.end = r->end,
> > +	});
> > +	*r = (struct mem_region){
> > +		.start = r->start,
> > +		.end = code_end,
> > +		.flags = MR_F_CODE,
> >  	};
> > -	struct mem_region *primary = NULL;
> > -	phys_addr_t base, top;
> > -	int nr_regs, nr_io = 0, i;
> >  
> >  	/*
> >  	 * mach-virt I/O regions:
> > @@ -104,57 +145,47 @@ static void mem_init(phys_addr_t freemem_start)
> >  	 *   - 512M at 256G (arm64, arm uses highmem=off)
> >  	 *   - 512G at 512G (arm64, arm uses highmem=off)
> >  	 */
> > -	mem_regions[nr_io++] = (struct mem_region){ 0, (1ul << 30), MR_F_IO };
> > +	mem_region_add(&(struct mem_region){ 0, (1ul << 30), MR_F_IO });
> >  #ifdef __aarch64__
> > -	mem_regions[nr_io++] = (struct mem_region){ (1ul << 38), (1ul << 38) | (1ul << 29), MR_F_IO };
> > -	mem_regions[nr_io++] = (struct mem_region){ (1ul << 39), (1ul << 40), MR_F_IO };
> > +	mem_region_add(&(struct mem_region){ (1ul << 38), (1ul << 38) | (1ul << 29), MR_F_IO });
> > +	mem_region_add(&(struct mem_region){ (1ul << 39), (1ul << 40), MR_F_IO });
> >  #endif
> > +}
> >  
> > -	nr_regs = dt_get_memory_params(regs, NR_INITIAL_MEM_REGIONS - nr_io);
> > -	assert(nr_regs > 0);
> > -
> > -	for (i = 0; i < nr_regs; ++i) {
> > -		struct mem_region *r = &mem_regions[nr_io + i];
> > +static void mem_init(phys_addr_t freemem_start)
> > +{
> > +	phys_addr_t base, top;
> > +	struct mem_region *freemem, *r, mem = {
> > +		.start = (phys_addr_t)-1,
> > +	};
> >  
> > -		r->start = regs[i].addr;
> > -		r->end = regs[i].addr + regs[i].size;
> > +	freemem = mem_region_find(freemem_start);
> > +	assert(freemem && !(freemem->flags & (MR_F_IO | MR_F_CODE)));
> >  
> > -		/*
> > -		 * pick the region we're in for our primary region
> > -		 */
> > -		if (freemem_start >= r->start && freemem_start < r->end) {
> > -			r->flags |= MR_F_PRIMARY;
> > -			primary = r;
> > +	for (r = mem_regions; r->end; ++r) {
> > +		if (!(r->flags & MR_F_IO)) {
> > +			if (r->start < mem.start)
> > +				mem.start = r->start;
> > +			if (r->end > mem.end)
> > +				mem.end = r->end;
> >  		}
> > -
> > -		/*
> > -		 * set the lowest and highest addresses found,
> > -		 * ignoring potential gaps
> > -		 */
> > -		if (r->start < mem.start)
> > -			mem.start = r->start;
> > -		if (r->end > mem.end)
> > -			mem.end = r->end;
> >  	}
> > -	assert(primary);
> > +	assert(mem.end);
> >  	assert(!(mem.start & ~PHYS_MASK) && !((mem.end - 1) & ~PHYS_MASK));
> >  
> > -	__phys_offset = primary->start;	/* PHYS_OFFSET */
> > -	__phys_end = primary->end;	/* PHYS_END */
> > +	/* Check for holes */
> > +	r = mem_region_find(mem.start);
> > +	while (r && r->end != mem.end)
> > +		r = mem_region_find(r->end);
> > +	assert(r);
> 
> It took me a while to figure this out, what it does is find all memory regions
> adjacent to each other and starting at mem.start and ending precisely at mem.end.
> Looks good.
> 
> >  
> > -	/* Split the primary region into two regions; code and data */
> > -	mem_regions[nr_io + i] = (struct mem_region){
> > -		.start = code_end,
> > -		.end = primary->end,
> > -		.flags = MR_F_PRIMARY,
> > -	};
> > -	*primary = (struct mem_region){
> > -		.start = primary->start,
> > -		.end = code_end,
> > -		.flags = MR_F_PRIMARY | MR_F_CODE,
> > -	};
> > +	/* Ensure our selected freemem region is somewhere in our full range */
> > +	assert(freemem_start >= mem.start && freemem->end <= mem.end);
> 
> That looks a bit strange, the comment refers to checking the freemem region, but
> we're actually checking is the subregion from freemem_start to freemem->end. I
> suppose it's because freemem_start comes after data, stack, fdt and initrd in the
> freemem region, and what we consider available memory is [freemem_start,
> freemem->end), right?

Right. I'll change the comment to say 'freemem range' rather than region.

Thanks,
drew


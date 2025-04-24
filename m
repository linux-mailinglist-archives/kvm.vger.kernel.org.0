Return-Path: <kvm+bounces-44107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4E02A9A756
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 11:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D568F188A64F
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C8921507F;
	Thu, 24 Apr 2025 09:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="JWo++Zv4";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cUJo6TVp"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E0B1DED49;
	Thu, 24 Apr 2025 09:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745485531; cv=none; b=aYXnEb0mNjYMYJNpOB/VF5vUVVw9tiUcOc1OK0ujFAVxnQk4TgmiZY5WHtUbAFvTs95BV4SWWU1JKlQjBoH3FlmHHgkeFgAcsUaLbvIzfyKyy1Tws9iEbgHnwv/nKS8cpV4cpZ9IrLcLGufvK9O7NEnIM8tNxmrnmVDtUsmEMJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745485531; c=relaxed/simple;
	bh=50vd7qIUHMnzv9CAMiYeR7AbsK9P/LKaHFBGTd7omq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RPp489ysIdj3I5TExKY/0I0/wJDaVQpu9SAi5TbZa5wKc45USyEGCTkkBu3f2HTwX3F3MH81Awj8SU0fZWTyia56s3gN4pJ+pKdP40/GBDkAI8DyUwHpkhAWlH/35Y9P+eogdy/LwbTfBWf4p+o1MTvd9im3FOVF2n9Y9qhNcfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=JWo++Zv4; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cUJo6TVp; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 68701114013D;
	Thu, 24 Apr 2025 05:05:27 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 24 Apr 2025 05:05:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1745485527; x=
	1745571927; bh=2As2w1BwDQyaM6DUrbYQpuGL7hUCrqE3Q33vpD0Y0zI=; b=J
	Wo++Zv46QlCkYs5I7it+L8wIZ8GSwaLe/qgof63amQL0zRNsGVTpEWrQNyTPa15X
	/v6ljWVQsanwCMkEJkbn4pCrLngqxbd2sLHza2SCtuW+iuOqziRDjg8ADOpVyGlf
	mpUiudRP/NOct1vE7u1kqP/bVuLkmIjYzs5IGpncHN1AX53+Yh5vSRAAGwxZr54d
	h7V/5DIFCmZhwqmQe4erJd+BVHumuC/RgZpGz3BfExYO9tllaEKGei/ww9Cm+OhN
	M2b+inxO73AEN1CGk+F3KZfbeoG1iriJg6nbN9i8PCftjTJDFgwpc4mSDiaIUnHD
	aAEugfGGU2D5xmnATPlRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1745485527; x=1745571927; bh=2As2w1BwDQyaM6DUrbYQpuGL7hUCrqE3Q33
	vpD0Y0zI=; b=cUJo6TVpMFYz4IoHK9yxdcvVz7tawy5cOsAIxgoM7VWPjopvfDL
	hMKRt84CXIHXTYfd81chbCzLx3UVmV70pyC2UjKuCcbteq9UAbwwjtBf1wA5213Y
	dqi19Tww64vM9dRBnoQqZInczvdGXZgx4ykSB4K/zJXQ0cyH6oPDxr2xG33t0X6c
	e5Qh2SWjDG2uxs7wKJSyH688Z15NW5rc4WCqXD7yV/gmInIhjZh2r/MtgIaBQsff
	sDSbOkrRCrsVSzMeecp7K19BF+HzgHqQWiKFo86Kl6O8lcsSO/GKX6sALjNlMGJh
	mrvceh7f7AMKjyvkW+nOogm6WykRT1JCGfQ==
X-ME-Sender: <xms:1v4JaPICWRcPzo1DEbbHLdL-0FtFCSSVDK1vWP9abN8tksGKDMZ3IQ>
    <xme:1v4JaDLJmcTSUYXiWYRCStCzyd2EXyrBqPSp5LLYQzy_fVV29REUMGdeq1fOrFnz8
    6mGilr4I1XV-4oZZyY>
X-ME-Received: <xmr:1v4JaHvuta3gMwk9IAcIgSq6CAxNKCoJakiNBg-y8IkbLlR5VpbBgJmkyozbv5OJiNdH6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvgeeltdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddt
    vdenucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilh
    hlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeffvdevueetudfh
    hfffveelhfetfeevveekleevjeduudevvdduvdelteduvefhkeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghm
    ohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdegpdhmohguvgepshhmthhpohhuthdprh
    gtphhtthhopeihrghnrdihrdiihhgrohesihhnthgvlhdrtghomhdprhgtphhtthhopehp
    sghonhiiihhnihesrhgvughhrghtrdgtohhmpdhrtghpthhtohepshgvrghnjhgtsehgoh
    hoghhlvgdrtghomhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprhhitghk
    rdhprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrvhgvrd
    hhrghnshgvnhesihhnthgvlhdrtghomhdprhgtphhtthhopehkihhrihhllhdrshhhuhht
    vghmohhvsehinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:1v4JaIZ4ADNQNmVi9HtE2rXd9i0Ym-JAoxNoGZCn7XoLmPrM783Qfg>
    <xmx:1v4JaGZ5R6_biFA0zatPwBkn-QK_MWINsOtEWoIc2B8xu3wNho8nzg>
    <xmx:1v4JaMDwbrfnshL6Wd56bP-ZP-Y38lPrsCRtLv-pqC1hMwSRV55HHg>
    <xmx:1v4JaEaTJqq5L1U6u0TpRPzzoicxFnFypxu6LwBupenmUi5QJCC1cw>
    <xmx:1_4JaG-uxwI1Onyt8i2vN4bcqYH0RMfJp6h6-KFd30FfanKebf-1B73r>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Apr 2025 05:05:19 -0400 (EDT)
Date: Thu, 24 Apr 2025 12:05:15 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, david@redhat.com, 
	vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com, 
	ira.weiny@intel.com, chao.p.peng@intel.com
Subject: Re: [RFC PATCH 00/21] KVM: TDX huge page support for private memory
Message-ID: <6vdj4mfxlyvypn743klxq5twda66tkugwzljdt275rug2gmwwl@zdziylxpre6y>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <e735cpugrs3k5gncjcbjyycft3tuhkm75azpwv6ctwqfjr6gkg@rsf4lyq4gqoj>
 <aAn3SSocw0XvaRye@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAn3SSocw0XvaRye@yzhao56-desk.sh.intel.com>

On Thu, Apr 24, 2025 at 04:33:13PM +0800, Yan Zhao wrote:
> On Thu, Apr 24, 2025 at 10:35:47AM +0300, Kirill A. Shutemov wrote:
> > On Thu, Apr 24, 2025 at 11:00:32AM +0800, Yan Zhao wrote:
> > > Basic huge page mapping/unmapping
> > > ---------------------------------
> > > - TD build time
> > >   This series enforces that all private mappings be 4KB during the TD build
> > >   phase, due to the TDX module's requirement that tdh_mem_page_add(), the
> > >   SEAMCALL for adding private pages during TD build time, only supports 4KB
> > >   mappings. Enforcing 4KB mappings also simplifies the implementation of
> > >   code for TD build time, by eliminating the need to consider merging or
> > >   splitting in the mirror page table during TD build time.
> > >   
> > >   The underlying pages allocated from guest_memfd during TD build time
> > >   phase can still be large, allowing for potential merging into 2MB
> > >   mappings once the TD is running.
> > 
> > It can be done before TD is running. The merging is allowed on TD build
> > stage.
> > 
> > But, yes, for simplicity we can skip it for initial enabling.
> Yes, to avoid complicating kvm_tdx->nr_premapped calculation.
> I also don't see any benefit to allow merging during TD build stage.
> 
> > 
> > > Page splitting (page demotion)
> > > ------------------------------
> > > Page splitting occurs in two paths:
> > > (a) with exclusive kvm->mmu_lock, triggered by zapping operations,
> > > 
> > >     For normal VMs, if zapping a narrow region that would need to split a
> > >     huge page, KVM can simply zap the surrounding GFNs rather than
> > >     splitting a huge page. The pages can then be faulted back in, where KVM
> > >     can handle mapping them at a 4KB level.
> > > 
> > >     The reason why TDX can't use the normal VM solution is that zapping
> > >     private memory that is accepted cannot easily be re-faulted, since it
> > >     can only be re-faulted as unaccepted. So KVM will have to sometimes do
> > >     the page splitting as part of the zapping operations.
> > > 
> > >     These zapping operations can occur for few reasons:
> > >     1. VM teardown.
> > >     2. Memslot removal.
> > >     3. Conversion of private pages to shared.
> > >     4. Userspace does a hole punch to guest_memfd for some reason.
> > > 
> > >     For case 1 and 2, splitting before zapping is unnecessary because
> > >     either the entire range will be zapped or huge pages do not span
> > >     memslots.
> > >     
> > >     Case 3 or case 4 requires splitting, which is also followed by a
> > >     backend page splitting in guest_memfd.
> > > 
> > > (b) with shared kvm->mmu_lock, triggered by fault.
> > > 
> > >     Splitting in this path is not accompanied by a backend page splitting
> > >     (since backend page splitting necessitates a splitting and zapping
> > >      operation in the former path).  It is triggered when KVM finds that a
> > >     non-leaf entry is replacing a huge entry in the fault path, which is
> > >     usually caused by vCPUs' concurrent ACCEPT operations at different
> > >     levels.
> > 
> > Hm. This sounds like funky behaviour on the guest side.
> > 
> > You only saw it in a synthetic test, right? No real guest OS should do
> > this.
> Right. In selftest only.
> Also in case of any guest bugs.
> 
> > It can only be possible if guest is reckless enough to be exposed to
> > double accept attacks.
> > 
> > We should consider putting a warning if we detect such case on KVM side.
> Is it acceptable to put warnings in host kernel in case of guest bugs or
> attacks?

pr_warn_once() shouldn't be a big deal.

> > >     This series simply ignores the splitting request in the fault path to
> > >     avoid unnecessary bounces between levels. The vCPU that performs ACCEPT
> > >     at a lower level would finally figures out the page has been accepted
> > >     at a higher level by another vCPU.
> > > 
> > >     A rare case that could lead to splitting in the fault path is when a TD
> > >     is configured to receive #VE and accesses memory before the ACCEPT
> > >     operation. By the time a vCPU accesses a private GFN, due to the lack
> > >     of any guest preferred level, KVM could create a mapping at 2MB level.
> > >     If the TD then only performs the ACCEPT operation at 4KB level,
> > >     splitting in the fault path will be triggered. However, this is not
> > >     regarded as a typical use case, as usually TD always accepts pages in
> > >     the order from 1GB->2MB->4KB. The worst outcome to ignore the resulting
> > >     splitting request is an endless EPT violation. This would not happen
> > >     for a Linux guest, which does not expect any #VE.
> > 
> > Even if guest accepts memory in response to #VE, it still has to serialize
> > ACCEPT requests to the same memory block. And track what has been
> > accepted.
> > 
> > Double accept is a guest bug.
> In the rare case, there're no double accept.
> 1. Guest acceses a private GPA
> 2. KVM creates a 2MB mapping in PENDING state and returns to guest.
> 3. Guest re-accesses, causing the TDX module to inject a #VE.
> 4. Guest accepts at 4KB level only.
> 5. EPT violation to KVM for page splitting.
> 
> Here, we expect a normal guest to accept from GB->2MB->4KB in step 4.

Okay, I think I misunderstood this case. I thought there is competing 4k
vs 2M ACCEPT requests to the same memory block.

Accepting everything at 4k level is a stupid, but valid behaviour on the
guest behalf. This splitting case has to be supported before the patchset
hits the mainline.

BTW, there's no 1G ACCEPT. I know that guest is written as if it is a
thing, but TDX module only supports 4k and 2M. 1G is only reachable via
promotion.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


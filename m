Return-Path: <kvm+bounces-57702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BC261B59206
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 11:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F8821897647
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6711A299A82;
	Tue, 16 Sep 2025 09:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="oW/O5h38";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RB5svWqQ"
X-Original-To: kvm@vger.kernel.org
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406B328AAEE;
	Tue, 16 Sep 2025 09:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758014553; cv=none; b=K3THq7n/fMnElE9mdliH7667jaXILBf0kg/4HsbdSlyGLzTupQqkbRWa9bk9s4hduhTlWBmaVI4rrT3W9TCCgNeMxRKQA3TMMQC3snLhCJvc3b0Dek9rHF6KEdFrIugg3YXn3v8rLJr5pcGk2eBvWAKo1pz+VsLnrN4G4dWDnoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758014553; c=relaxed/simple;
	bh=uDFP1Elkv6seivo+LIxr0JIvmVyfvOaAlFK/sYvsAvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EANqhV0ttg5F7ULLT9R+QQd85IsohnXdsxL51WFl2qUnMbTe+qFuNs8Qg3SCUsa6Zsusvr2WYFmsuQOYG8BA8m9AKRQGFR1z/nZwgwcbmo3j+Zs4O0IKkBUrq497HoRIBt49TBmwqH/bix8T5EFvTf8ckbkaqzZwerUWZyHiQIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=oW/O5h38; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RB5svWqQ; arc=none smtp.client-ip=103.168.172.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 440D41380341;
	Tue, 16 Sep 2025 05:22:30 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 16 Sep 2025 05:22:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758014550; x=
	1758021750; bh=4+KQ3+PwUEQhtf+X1G7fk/FknoUQqoDfKqod06UBKZY=; b=o
	W/O5h38vUjYtcHCAUJJdLFHPaiY1GD1kabJHh/AKQZ/kLfRom/mRou6mGioDcHzB
	6ePoJmJOhuYVN3nWEYB1JeVZaZgEvsD96Ghyly8JDUz68lINHPjCzUpEGIYAUk8t
	/FZjbNQxyDfVkLSg/M2BZgHfHB0PeMxb6f4jUVhjwoCLt6recB8DmCSZCk/gBGoD
	ZbAJm84tIEG0pWbMehD6dORvzwkYMJtTF/SYuhQMnnbLste3ULLYdBHTFoOBaV5S
	JYhi/Oo5EnAUsvosvZKznVu8yxh0wB+CVj64AgnWflOFLfe2rjcCWWNx9mp1wSog
	k3KRgC1osZIWyb4W0y1sA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758014550; x=1758021750; bh=4+KQ3+PwUEQhtf+X1G7fk/FknoUQqoDfKqo
	d06UBKZY=; b=RB5svWqQ90YJVks1r1cw97+W9YtRY6WreVqQVg+RHn6uQaU5e/9
	4ajcON/phqEEdkuL6D6/YzYxVdrtUHkG3bi6XWOy80U5fzOAQqcyCCK6bqwmZg0h
	SFlpsiDqwAbClt0FygWKlgD+PlV7rvo81NgqMiRXP1sFL0TlaynjKrYy1eSUvgC7
	Mg0/kdis0AaGFLcMOko9ozxBT2d3s0PE8+oa0BYy9ALtOH2E+NW8q5DDAzg/WPT+
	VxT5EDNd093gZfUEl4G93xHZjDGKLqL+5Wk0OoU4xBy1uE9VAZKH7hm9EiweRSDR
	tlRCfSVBtY0g4BUQF5g03PrQyVjfu4r3apw==
X-ME-Sender: <xms:VSzJaDQJKAiOPEQ1mJaM0njFJPrysk_rvLV7mJ1iF-FZRK4YM-BT1w>
    <xme:VSzJaPk0edTXIjbjSa3aVyOzjzkAQM0NxMpsDCN3P3hzFMckLv7YClMpAAYA5UHfi
    vDmEE7kQH5qmC05LsQ>
X-ME-Received: <xmr:VSzJaHEQ5_JfGR-IhrUd0hnTxRGeu_eecL0RAMRzazPCyxAYcYpwyJGRmkB6Vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegtddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegfeehleevvdetffeluefftdffledvgfetheegieevtefgfefhieej
    heevkeeigeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhho
    vhdrnhgrmhgvpdhnsggprhgtphhtthhopeefvddpmhhouggvpehsmhhtphhouhhtpdhrtg
    hpthhtoheprhhitghkrdhprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpdhrtghp
    thhtohepkhhirhhilhhlrdhshhhuthgvmhhovheslhhinhhugidrihhnthgvlhdrtghomh
    dprhgtphhtthhopehpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdhrtghpthhtohep
    shgvrghnjhgtsehgohhoghhlvgdrtghomhdprhgtphhtthhopegurghvvgdrhhgrnhhsvg
    hnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtoheptghhrghordhgrghosehi
    nhhtvghlrdgtohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtoh
    epkhgrihdrhhhurghnghesihhnthgvlhdrtghomhdprhgtphhtthhopeigkeeisehkvghr
    nhgvlhdrohhrgh
X-ME-Proxy: <xmx:VSzJaCk-OzVNIZ8vFX7FoaPBHi9k8zpyWN5vLhPKUZAEAfKU-Ba5Mg>
    <xmx:VSzJaGTObaOODpAZYInvhW9rXVKQqYVoyAPxGk9U0ypdJqOJ6bx4jg>
    <xmx:VSzJaH4DPUS4icMHfGuU_op6OAcjUtOY6G9AaqqvSkFiCwVFFgsG5g>
    <xmx:VSzJaNHMmhi6QhN8Sk9NoTuJEWPY7qji05lyAjFvyRrwV1XuESADSw>
    <xmx:VizJaBm1O3K8VuCU37NtTdh6Jnj2lqU54QaxZCUdojXFn7vHZc5Ep8Ia>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 16 Sep 2025 05:22:29 -0400 (EDT)
Date: Tue, 16 Sep 2025 10:22:26 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"Huang, Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Message-ID: <bfaswqmlsyycr3alibn6f422cjtpd6ybssjekvrrz4zdwgwfcz@pxy25ra4sln2>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
 <6c545c841afcd23e1b3a4fcb47573ee3a178d6e1.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c545c841afcd23e1b3a4fcb47573ee3a178d6e1.camel@intel.com>

On Tue, Sep 16, 2025 at 12:03:26AM +0000, Edgecombe, Rick P wrote:
> On Mon, 2025-06-09 at 22:13 +0300, Kirill A. Shutemov wrote:
> > +
> > +static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
> > +			struct list_head *pamt_pages)
> > +{
> > +	u64 err;
> > +
> > +	guard(spinlock)(&pamt_lock);
> > +
> > +	hpa = ALIGN_DOWN(hpa, PMD_SIZE);
> > +
> > +	/* Lost race to other tdx_pamt_add() */
> > +	if (atomic_read(pamt_refcount) != 0) {
> > +		atomic_inc(pamt_refcount);
> > +		return 1;
> > +	}
> > +
> > +	err = tdh_phymem_pamt_add(hpa | TDX_PS_2M, pamt_pages);
> > +
> > +	/*
> > +	 * tdx_hpa_range_not_free() is true if current task won race
> > +	 * against tdx_pamt_put().
> > +	 */
> > +	if (err && !tdx_hpa_range_not_free(err)) {
> > +		pr_err("TDH_PHYMEM_PAMT_ADD failed: %#llx\n", err);
> > +		return -EIO;
> > +	}
> > +
> > +	atomic_set(pamt_refcount, 1);
> > +
> > +	if (tdx_hpa_range_not_free(err))
> > +		return 1;
> 
> Hey Kirill,
> 
> I couldn't figure out how this tdx_hpa_range_not_free() check helps. We are
> already inside the lock also taken by any operation that might affect PAMT
> state. Can you explain more about this? Otherwise I'm going to drop it for
> inability to explain.

My git has comment for the check:

https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git/tree/arch/x86/virt/vmx/tdx/tdx.c?h=tdx/dpamt&id=375706fe73a8499dbdddb22c13d19d7286280ad6#n2160

Consider the following scenario

		CPU0					CPU1
tdx_pamt_put()
  atomic_dec_and_test() == true
  					tdx_pamt_get()
					  atomic_inc_not_zero() == false
					  tdx_pamt_add()
					    <takes pamt_lock>
					    // CPU0 never removed PAMT memory
					    tdh_phymem_pamt_add() == HPA_RANGE_NOT_FREE
					    atomic_set(1);
					    <drops pamt_lock>
  <takes pamt_lock>
  // Lost the race to CPU1
  atomic_read() > 0
  <drop pamt_lock>

Does it make sense?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov


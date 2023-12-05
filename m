Return-Path: <kvm+bounces-3432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E08C180446C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 03:05:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DC061F21377
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 02:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C4B64A34;
	Tue,  5 Dec 2023 02:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rIVxUr5H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718D0B4
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 18:04:54 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-db53919e062so4036337276.0
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 18:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701741893; x=1702346693; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xVyruI1oo2P7CyHRmmgriyFiz+nPrbAf0CEnIIEh14g=;
        b=rIVxUr5HF1UWZD+e8dN8lnLSaduP/tA82w1nW37ow7y6kke/Y60ewkAdYxBIxHGFvW
         oTx9HYCNuKgIvcqCy3UBAQvUfrpa0QQtBt6LYFkUOooub3UVuMCW8UPz1LcClL8hc0+l
         t0LRzyanWLcpEWcGwQevGMfdrjbmxYa2JEvdCAGqurTpj5qqa/htUr6zZAzAr2CCxBrZ
         MT2AttwokEpPIoGLIBKbxmXEMNknfM5dUr1Tj2RmOcbeIUVmBsXexndDYrgBr8ZKo0WZ
         NEkOtSHYPN9wElsuO/0pP89lPMQH3a/3yHGsF5r8DplhJ7mVs9+MjCxs+OhFVYe8MWEH
         0rJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701741893; x=1702346693;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xVyruI1oo2P7CyHRmmgriyFiz+nPrbAf0CEnIIEh14g=;
        b=T3jUVk5Z0OpY6CkyY7oC8D0Nmf5t9OJv1mGeyLaSGAi3BuhLVXgf9KG665M4BGfnGS
         i4/XWhcLbe+/ZIx6+wcSOo7u/7uJdnt/1WLOgJjAaUUt1jq4cGuH6mssidI9AqO4pwKI
         Am7mlbpset6xWBKvJ3VXz4aTvvhHuPzrAKtIdcm/zmi+DoIQh36hnNbI/AiA91Y30Av0
         AlB3pM/qXP5/WFC6mE6IJLVP1exkDL0R6o93v6gusUQ6uqE15TqS8kvmhX99g3uPyi9p
         yg0aWR3Wkd7xOa9o4JnWmtsg/TYGi5JjPJW0cWGUjsi23OzxXk7wo/Pd16uGpq4cBniW
         rSFA==
X-Gm-Message-State: AOJu0Yxv+zgBoV/mm1ZthLnZwua5KzxJxhqGLDquZa5XNFIJBAabSwGM
	5Q2opuZyQT/P+/lpIUfpetpIcLWlzws=
X-Google-Smtp-Source: AGHT+IGvt/BYarzOkQvF7MzafR7wtNxUC6N6zaGdRUBy9JL4XvnY9hVW0ChWiHwIRD7CBWunxA8ujFYeYug=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ca84:0:b0:db5:4692:3ab7 with SMTP id
 a126-20020a25ca84000000b00db546923ab7mr337717ybg.8.1701741893679; Mon, 04 Dec
 2023 18:04:53 -0800 (PST)
Date: Mon, 4 Dec 2023 18:04:52 -0800
In-Reply-To: <1a5b18b2-3072-46d9-9d44-38589cb54e40@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1699527082.git.kai.huang@intel.com> <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
 <b3b265f9-48fa-4574-a925-cbdaaa44a689@intel.com> <afc875ace6f9f955557f5c7e811b3046278e4c51.camel@intel.com>
 <bcff605a-3b8d-4dcc-a5cb-63dab1a74ed4@intel.com> <dfbfe327704f65575219d8b895cf9f55985758da.camel@intel.com>
 <9b221937-42df-4381-b79f-05fb41155f7a@intel.com> <c12073937fcca2c2e72f9964675ef4ac5dddb6fb.camel@intel.com>
 <1a5b18b2-3072-46d9-9d44-38589cb54e40@intel.com>
Message-ID: <ZW6FRBnOwYV-UCkY@google.com>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rafael@kernel.org" <rafael@kernel.org>, 
	Chao Gao <chao.gao@intel.com>, Tony Luck <tony.luck@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "bagasdotme@gmail.com" <bagasdotme@gmail.com>, 
	"ak@linux.intel.com" <ak@linux.intel.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"hpa@zytor.com" <hpa@zytor.com>, "sagis@google.com" <sagis@google.com>, 
	"imammedo@redhat.com" <imammedo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"bp@alien8.de" <bp@alien8.de>, Len Brown <len.brown@intel.com>, 
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Ying Huang <ying.huang@intel.com>, Dan J Williams <dan.j.williams@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 04, 2023, Dave Hansen wrote:
> On 12/4/23 15:24, Huang, Kai wrote:
> > On Mon, 2023-12-04 at 14:04 -0800, Hansen, Dave wrote:
> ...
> > In ancient time KVM used to immediately enable VMX when it is loaded, but later
> > it was changed to only enable VMX when there's active VM because of the above
> > reason.
> > 
> > See commit 10474ae8945ce ("KVM: Activate Virtualization On Demand").

Huh, I always just assumed it was some backwards thinking about enabling VMX/SVM
being "dangerous" or something.

> Fine.  This doesn't need to change ... until you load TDX.  Once you
> initialize the TDX module, no more out-of-tree VMMs for you.

It's not just out-of-tree hypervisors, which IMO should be little more than an
afterthought.  The other more important issue is that being post-VMXON blocks INIT,
i.e. VMX needs to be disabled before reboot, suspend, etc.  Forcing kvm_usage_count
would work, but it would essentially turn "graceful" reboots, i.e. reboots where
the host isn't running VMs and thus VMX is already disabled.  Having VMX be enabled
so long as KVM is loaded would turn all reboots into the "oh crap, the system is
rebooting, quick do VMXOFF!" variety.

> That doesn't seem too insane.  This is yet *ANOTHER* reason that doing
> dynamic TDX module initialization is a good idea.
> 
> >> It's not wrong to say that TDX is a KVM user.  If KVm wants
> >> 'kvm_usage_count' to go back to 0, it can shut down the TDX module.  Then
> >> there's no PAMT to worry about.
> >>
> >> The shutdown would be something like:
> >>
> >>       1. TDX module shutdown
> >>       2. Deallocate/Convert PAMT
> >>       3. vmxoff
> >>
> >> Then, no SEAMCALL failure because of vmxoff can cause a PAMT-induced #MC
> >> to be missed.
> > 
> > The limitation is once the TDX module is shutdown, it cannot be initialized
> > again unless it is runtimely updated.
> > 
> > Long-termly, if we go this design then there might be other problems when other
> > kernel components are using TDX.  For example, the VT-d driver will need to be
> > changed to support TDX-IO, and it will need to enable TDX module much earlier
> > than KVM to do some initialization.  It might need to some TDX work (e.g.,
> > cleanup) while KVM is unloaded.  I am not super familiar with TDX-IO but looks
> > we might have some problem here if we go with such design.
> 
> The burden for who does vmxon will simply need to change from KVM itself
> to some common code that KVM depends on.  Probably not dissimilar to
> those nutty (sorry folks, just calling it as I see 'em) multi-KVM module

You misspelled "amazing" ;-)

> patches that are floating around.

Joking aside, why shove TDX module ownership into KVM?  It honestly sounds like
a terrible fit, even without the whole TDX-IO mess.  KVM state is largely ephemeral,
in the sense that loading and unloading kvm.ko doesn't allocate/free much memory
or do all that much initialization or teardown.

TDX on the other hand is quite different.  IIRC the PAMT is hundreds of MiB, maybe
over a GiB in most expected use cases?  And also IIRC, TDH.SYS.INIT is rather
long running operation, blocks IRQs, NMIs, (SMIs?), etc.

So rather than shove TDX ownership into KVM and force KVM to figure out how to
manage the TDX module, why not do what us nutty people are suggesting and move
hardware enabling and TDX-module management into a dedicated base module (bonus
points if you call it vac.ko ;-) ).

Alternatively, we could have a dedicated kernel module for TDX, e.g. tdx.ko, and
then have tdx.ko and kvm.ko depend on vac.ko.  But I think that ends up being
quite gross and unnecessary, e.g. in such a setup, kvm-intel.ko ideally wouldn't
take a hard dependency on tdx.ko, as auto-loading tdx.ko would defeat some of the
purpose of the split, and KVM shouldn't fail to load just because TDX isn't supported.
But that'd mean conditionally doing request_module("tdx") or whatever and would
create other conundrums.

(Oof, typing that out made me realize that KVM depends on the PSP driver if
CONFIG_KVM_AMD_SEV=y, even if if the platform owner has no intention of ever using
SEV/SEV-ES.  IIUC, it works because sp_mod_init() just registers a driver, i.e.
doesn't fail out of there's no PSP.  That's kinda gross).

Anyways, vac.ko provides an API to grab a reference to the TDX module, e.g. the
"create a VM" API gets extended to say "create a VM of the TDX variety", and then
vac.ko manages its refcounts to VMX and TDX accordingly.  And KVM obviously keeps
its existing behavior of getting and putting references for each VM.

That way userspace gets to decide when to (un)load tdx.ko without needing to add
a KVM module param or whatever to allow forcefully unloading tdx.ko (which would
be bizarre and probably quite difficult to implement correctly), and unloading
kvm-intel.ko wouldn't require unloading the TDX module.

The end behavior might not be all that different in the short term, but it would
give us more options, e.g. for this erratum, it would be quite easy for vac.ko to
let usersepace choose between keeping VMX "on" (while the TDX module is loaded)
and potentially having imperfect #MC messages.

And out-of-tree hypervisors could even use vac.ko's exported APIs to manage hardware
enabling if they so choose.


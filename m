Return-Path: <kvm+bounces-4149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8266E80E48F
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 07:54:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 378961F21EAB
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 06:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CECD916438;
	Tue, 12 Dec 2023 06:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="h9cZgdMO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC27ECB;
	Mon, 11 Dec 2023 22:53:53 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3C0CD40E00CC;
	Tue, 12 Dec 2023 06:53:51 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id pDdtV7Aw2AiP; Tue, 12 Dec 2023 06:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702364029; bh=ew/p29RsERxODejVJK/prbLDG9ex/vpDFzw9MN3tsq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h9cZgdMOi4AMc5jH32UrN+EA/9cBM1Asn0f/Pr0gfyds7BT+/0Nl8WWbmiFGhFvnL
	 feiBK24dWx5QmKrugrqG+BSkAIjkeoP1DcOAlr/M2EibJQCDDswuey9R+RGJ5GOBlJ
	 Ke4JiNNqMyPNHcXzaLYMVUsplURYCQ0RwHHdrmahz3AGMay87J/8OPpj7rk4tSpVWx
	 bfie+iEo7Ys5+Ckq33dtr0+wXW99FMSLL8DhoG+btVZdKGytgGHbarIRjBV+p3juCO
	 emoCj3qel7qPCyEugklZ4H9n3HSY76Y0c1YrwTA3+61y+5bPZGqJFN8IVUs8TXIlH1
	 15YdOLX5pkgvpOoNGJYKIAhEUmxR/QcsRAbrkbmRTt1A7pFTDLyVLHfzguoLIUpanQ
	 U3jCxGi+/3Wop99zzzymNsV1Y++VkPDUgL31pov6Glf5dVUVjgnaylMQwYtGrHWaTU
	 OZNdBr5Y1qV/GiAuBzSZziTAdc7wTsIHmUOOgg3HRTmDcj3tJnVsieftsrIMOPgLbU
	 cPDLPohB32GLlZcSa0sbWJAb/GhiU51Vl6XWnqftK7X4tvj2EqvSTFcD8DXHQDDIqT
	 Z1KwgUMBNnz0+NuhUZwK0k2PDwNSOxfYqwReoBEx4psdy3ftP8v+81+eCYHbtHFkCs
	 WcXNL786gMn32z/o0RXvSjyI=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 897BA40E00CB;
	Tue, 12 Dec 2023 06:53:08 +0000 (UTC)
Date: Tue, 12 Dec 2023 07:52:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
	alpergun@google.com, jarkko@kernel.org, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>,
	Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH v10 14/50] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Message-ID: <20231212065259.GAZXgDSwV+zaH8MvB6@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-15-michael.roth@amd.com>
 <20231127095937.GLZWRoiaqGlJMX54Xb@fat_crate.local>
 <d5242390-8904-7ec5-d8a1-9e3fb8f6423c@amd.com>
 <20231206170807.GBZXCqd0z8uu2rlhpn@fat_crate.local>
 <9af9b10f-0ab6-1fe8-eaec-c9f98e14a203@amd.com>
 <20231209162015.GBZXSTv738J09Htf51@fat_crate.local>
 <2800d4d6-8ae9-e6c9-287a-301beb0a2f50@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2800d4d6-8ae9-e6c9-287a-301beb0a2f50@amd.com>

On Mon, Dec 11, 2023 at 03:11:17PM -0600, Kalra, Ashish wrote:
> What we need is a mechanism to do legacy SEV/SEV-ES INIT only if a
> SEV/SEV-ES guest is being launched, hence, we want an additional parameter
> added to sev_platform_init() exported interface so that kvm_amd module can
> call this interface during guest launch and indicate if SNP/legacy guest is
> being launched.
> 
> That's the reason we want to add the probe parameter to
> sev_platform_init().

That's not what your original patch does and nowhere in the whole
patchset do I see this new requirement for KVM to be able to control the
probing.

The probe param is added to ___sev_platform_init_locked() which is
called by this new sev_platform_init_on_probe() thing to signal that
whatever calls this, it wants the probing.

And "whatever" is sev_pci_init() which is called from the bowels of the
secure processor drivers. Suffice it to say, this is some sort of an
init path.

So, it wants to init SNP stuff which is unconditional during driver init
- not when KVM starts guests - and probe too on driver init time, *iff*
that psp_init_on_probe thing is set. Which looks suspicious to me:

  "Add psp_init_on_probe module parameter that allows for skipping the
  PSP's SEV platform initialization during module init. User may decouple
  module init from PSP init due to use of the INIT_EX support in upcoming
  patch which allows for users to save PSP's internal state to file."

From b64fa5fc9f44 ("crypto: ccp - Add psp_init_on_probe module
parameter").

And reading about INIT_EX, "This command loads the SEV related
persistent data from user-supplied data and initializes the platform
context."

So it sounds like HV vendor wants to supply something itself. But then
looking at init_ex_path and open_file_as_root() makes me cringe.
I would've never done it this way: we have request_firmware* etc helpers
for loading blobs from userspace which are widely used. But then reading 

  3d725965f836 ("crypto: ccp - Add SEV_INIT_EX support")

that increases the cringe factor even more because that also wants to
*write* into that file. Maybe there were good reasons to do it this way
- it is still yucky for my taste tho...

But I digress - whatever you want to do, the right approach is to split
the functionality:

SNP init
legacy SEV init

and to call them from a wrapper function around it which determines
which ones need to get called depending on that delayed probe thing.

Lumping everything together and handing a silly bool downwards is
already turning into a mess.

Now, looking at sev_guest_init() which calls sev_platform_init() and if
you want to pass back'n'forth more information than just that &error
pointer, then you can define your own struct sev_platform_init_info or
so which you preset before calling sev_platform_init() and pass in
a pointer to it.

And in it you can stick &error, bool probe or whatever else you need to
control what the platform needs to do upon init. And if you need to
extend that in the future, you can add new struct members and so on.

HTH.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


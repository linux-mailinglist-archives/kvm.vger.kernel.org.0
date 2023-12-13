Return-Path: <kvm+bounces-4356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA1B8117E2
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 16:45:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28DD71C212A7
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 15:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF379446C8;
	Wed, 13 Dec 2023 15:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="QOAG/cZ1"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0E5126;
	Wed, 13 Dec 2023 07:42:00 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 834E940E00CB;
	Wed, 13 Dec 2023 15:41:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3WN12W1SPrIZ; Wed, 13 Dec 2023 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702482115; bh=IyhM7Slw/zIKLzW0NKmy0CrnbMXBOwC2G6bxrBly64g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QOAG/cZ16FSsNmwYJBb7r6qQgBeJQZTYcRo4azQifv+sKJfJy0k00NV5msq6ymTAY
	 NdSWQqiaJzIIbbjQawtF5wiDnmZRIpMjCY5i5wVf1mcEiJ5QdOMvwYylKQB0wtBzsA
	 wADGzcVl17JzPGddFLy0pTMafOg2YyX7aoMJdR8zVSaPE7JKCZNzqsXKkBWQRozFUr
	 jaFqS5IATs10wyL7JrP6lrjpe/uG23/9rJkvrNsl+S8T76DZT7ZSxIhSBIwItLek0B
	 4fbUky4Eiz7wCrJoMdKeUoBz12+M+ToP6KNiAj0eYkTIKvM4ANAKMXiWWvW4/ZFTbY
	 tsZr7I8vWlAoUPMOtYV0mVZaUei4nttnjdpAvWsNNX05bY6ByXb10hG7vZuoAnbRiW
	 ZRHqIscTgQNR0E3nEVAczRVmsSUnmQve5Li6FeVGf5BmVgKrVl2psZiiTXV+N6UdWF
	 pRYwOSxj4xEoiW73XfixRM7B8R1yJ01piZAtC1OZHPaBlUT2kqUaUlQVg62qfO/Cjy
	 TQrMu6YCHcrmOGZjE2T5WSBPMUEh/ayPYhujwMrw3O/+wYBDFxhpyeAsLK3xChvB5O
	 HBPreAb4duw1cKA5I6mD6repeSryseqxrlv4kLdUJJTs956fDOM2icXv+LzuLksbOW
	 BbNi0uSQw+rozRuITpo5zsMI=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ED3D640E00CD;
	Wed, 13 Dec 2023 15:41:13 +0000 (UTC)
Date: Wed, 13 Dec 2023 16:41:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
	alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>,
	Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH v10 04/50] x86/cpufeatures: Add SEV-SNP CPU feature
Message-ID: <20231213154107.GGZXnQkxEuw6dJfbc7@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-5-michael.roth@amd.com>
 <0b2eb374-356c-46c6-9c4a-9512fbfece7a@redhat.com>
 <20231213131324.GDZXmt9LsMmJZyzCJw@fat_crate.local>
 <40915dc3-4083-4b9f-bc64-7542833566e1@redhat.com>
 <20231213133628.GEZXmzXFwA1p+crH/5@fat_crate.local>
 <9ac2311c-9ccc-4468-9b26-6cb0872e207f@redhat.com>
 <20231213134945.GFZXm2eTkd+IfdsjVE@fat_crate.local>
 <b4aab361-4494-4a4b-b180-d7df05fd3d5b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b4aab361-4494-4a4b-b180-d7df05fd3d5b@redhat.com>

On Wed, Dec 13, 2023 at 03:18:17PM +0100, Paolo Bonzini wrote:
> Surely we can agree that cpu_feature_enabled(X86_FEATURE_SEV_SNP) has nothing
> to do with SEV-SNP host patches being present? 

It does - we're sanitizing the meaning of a CPUID flag present in
/proc/cpuinfo, see here:

https://git.kernel.org/tip/79c603ee43b2674fba0257803bab265147821955

> And that therefore retpolines are preferred even without any SEV-SNP
> support in KVM?

No, automatic IBRS should be disabled when SNP is enabled. Not CPUID
present - enabled. We clear that bit on a couple of occasions in the SNP
host patchset if we determine that SNP host support is not possible so
4/50 needs to go together with the rest to mean something.

> And can we agree that "Acked-by" means "feel free and take it if you wish,

I can see how it can mean that and I'm sorry for the misunderstanding
I caused. Two things here:

* I acked it because I did a lengthly digging internally on whether
disabling AIBRS makes sense on SNP and this was a note more to myself to
say, yes, that's a good change.

* If I wanted for you to pick it up, I would've acked 4/50 too. Which
I haven't.

> I'm asking because I'm not sure if we agree on these two things, but they
> really seem basic to me?

I think KVM and x86 maintainers should sit down and discuss who picks up
what and through which tree so that there's no more confusion in the
future. It seems things need discussion...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


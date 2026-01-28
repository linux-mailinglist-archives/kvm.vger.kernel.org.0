Return-Path: <kvm+bounces-69418-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4BgaHzeEemnx7AEAu9opvQ
	(envelope-from <kvm+bounces-69418-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 22:48:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DF665A9398
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 22:48:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D050D3053676
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 21:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51EFB33C515;
	Wed, 28 Jan 2026 21:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x4/lfl4R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F94327202
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 21:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769636874; cv=pass; b=jFDAz/BfHueLTJqlMum3liNM0bqCcMJCvennM1YZKogl6ANH2B98O1TR+FyeRtrqvDpdSSbCFAlAqiajBolXGMWspOeuzHiC7F4X2ZWuxbOyxs7llDnCm2k3qDAIZ/vVSpmX+t5pCpMYCUC3PTGLvSssy6j85oTXq+pSNCtmN2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769636874; c=relaxed/simple;
	bh=YC36ImuZe9JdqUv+pVkMpluokr4Llii9CFTV9lQL1NI=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ws/SDkoa1ZNAe6hK0/NuxIUajgXX5Mox3u1+yYq9oLMXXiW91GwCAW/hIQ5xiibJulPBMBz4iEVOMiMN1c1D+tII614OJuRPIG2Xopy4NUWtHv/VuSyjVu+RaFxeR9MyUin4Urgbvp2uLgJogU87pOpUWSi3AIQ2ovW4j+l2ul4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x4/lfl4R; arc=pass smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-566390e7db3so228062e0c.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 13:47:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769636872; cv=none;
        d=google.com; s=arc-20240605;
        b=hvrFI28akXnbI/VzsdBNolyxHmqHSHLIAY6FPdSUL0eZGjM3rVRbdF9hIFR7/p6wk+
         EW8N9qyrNrkBM3QoGSpE15rtEyHgaDa0Qk/IklPzHbZ1lq7Gvpra2eHl0XK+n/urOFjZ
         m0gwq5M2PrOEXemoVgE+sukUxxqubzOPJCL1yTwXjIRpz6YU0G4A1xnCZk/SIDDYSXOD
         mSHjgWJQpVHAPsWI47/8BnF6xpbYH31984B3SbiVHev/ISi4JFWeq4NZL1OzHVYoA7fp
         Rw0pCr3jIg5PkYmCXHf2L3rEKn/j0uKcPAaBh1wR2hWPLlfLK+8RsdcNzCAzlLlXhfb3
         ffsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=8KRtsUWTPrRQfD/St3Ag63nt0POKWslcjlDyzaxfyec=;
        fh=m+E/fwklBjfEVXdPI4C1F6RgE7zU9MLJmamgZEIlTfA=;
        b=APtrXmiXDyR945oCegwTMKrVk8tJ75OZ5/Bw0AIo0gENCLtolDEqV3czqRIegxlpTU
         RDaXbvKlBt+VVWGxni/PWJxtGp0LKusnz3wD0GVvt+3kPR50gBB0WnsEShEJSO1p6XN7
         8oCSHxFVq5BswrdGuh9wrrduEy/eoyqX6HMna0pkm6DJpqQq2OhZk20/5q4TrjRI/ZL8
         LAyw3WV8hRpZppnGRiurdWWQT8+dOPykQVHj4xQuIks+P6UqcGBTO0wyfoXic1g2xJ1Z
         Yhv2RQqTBBSeUV8AQjlLTyFi48Ikd5k4hJKkLCICi4LKSX4QoCDCMKiQ5NOpG2pxWJGt
         /XGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769636872; x=1770241672; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8KRtsUWTPrRQfD/St3Ag63nt0POKWslcjlDyzaxfyec=;
        b=x4/lfl4RC4R6AZIvM1WTIKqANtJTykk9eIGt6qOukMOE1QRTKe0Nd4Kufq4/kTBDvg
         O4gLZ1kkXS5Wi30V8TZbW4QI2U7WSmlwAyOQseQ0Kk86PWxdg+SbVc3mEsim2I63sEvG
         auosx2itHw4eTN+FT8gJmnxpeIRAt/VFWkDpCj2LWJtWlU7MoxlQCFH8mZdrCaD5JeMn
         Eri6ZQ+0pAdOorAluQAH/B4RRioCPqJ6ECaJ0QKnEW0i5Oi8aieYvFzIVSLRMFe+CQHE
         UXxnGatvUwlrhNlh9IwMSkTcDBMYXAFS38Ys5DU1A4L/wOz5EVnX2gsj+2vKxJXrZFW5
         CbbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769636872; x=1770241672;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8KRtsUWTPrRQfD/St3Ag63nt0POKWslcjlDyzaxfyec=;
        b=t2fqP/IXKbyrpZBgFzIG7z41zHczfS29tfRQX66Ki3xhqD9O49yL+2s8Wt0gkBw5A1
         1ThwS/HZx11GKqnTg3QsdaAMS9PlD5ZZ4QkhEsDVHRuBxoqJj65jwFGkXM4CwuCUe3WL
         9uwCzyTLnkk996KxEPbdSxYkAuCUtTUZNRmSmtmqBJ5RORDUzGtbkUZzaaiyBbkanfix
         XBKIeD5EDyCrvyHtFBa0YBi8UEPxa1JfRnK7lVeLQLfvKV7ysLvJ4bwoZM0IcstOA89N
         z80BiE8WqbUIxAWG6k65oXsfYf4SiHgg7jph4st/BzuxQYFgia9GhmSA/9FFoKibz1pL
         c0fA==
X-Forwarded-Encrypted: i=1; AJvYcCUm91fIME/qI4r6YVPHVvMy3vXfImSwLfYFh4loEpxn21X4vmOWxWUOmOnUIyjPAuMt7m0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwanOj6iDSDj7nxWUKNDsv0Don2El1AuTT2qALVx/8xLkbn4P2Z
	bpS9iBiAgQLGEBHRUf7qw7ToOqiw64q1DwaFs9PJl5Aku/4aMVnDCXg2rTUHTGDhFJsT//n7Q26
	pDb8fZB+0aU3bROQHNPG7Jb0lfruhZs/IIBOJyoo7
X-Gm-Gg: AZuq6aJWCq7VLH+TaHAISAlLEKBYjzzFwLiyCA2VyAcO3orNtyVqfc2fLyS4eE04A9e
	PNbE29ciukDmICgFXpjckUbkkhdHWDgqHm/YzyaJzSxI32CwRHx+ln08k7GYs/ib7O24/rDwnZf
	RTB0yZc+piqP4P5fG0GrCCpTP8u+F7vLKant6QRYSgGbbKnDL/CI4Qk+cyeUPinRMalkAqmF4/3
	OqOxDyRUXmnYfAmccNb1lPgPefmKdkuTnyqhEVF+z+pB/5Jcb5W32xxN410inACbwYkx1pHpzb6
	bkju3Sdwho9VWdfHmk1hNl2QFg==
X-Received: by 2002:a05:6102:144b:20b0:5f7:24e9:ece2 with SMTP id
 ada2fe7eead31-5f724e9edc6mr2295689137.28.1769636871290; Wed, 28 Jan 2026
 13:47:51 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Jan 2026 13:47:50 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Jan 2026 13:47:50 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
References: <cover.1760731772.git.ackerleytng@google.com> <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 28 Jan 2026 13:47:50 -0800
X-Gm-Features: AZwV_QgPf8aOvxqDX4gr94R7SzOt27JuvroRVjSaL4ACWGO_5lJuitif3BKdULg
Message-ID: <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 05/37] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
To: Alexey Kardashevskiy <aik@amd.com>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com, 
	mail@maciej.szmigiero.name, maobibo@loongson.cn, 
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org, 
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev, 
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	peterx@redhat.com, pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, 
	qperret@google.com, richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, rostedt@goodmis.org, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shakeel.butt@linux.dev, shuah@kernel.org, 
	steven.price@arm.com, steven.sistare@oracle.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org, 
	willy@infradead.org, wyihan@google.com, xiaoyao.li@intel.com, 
	yan.y.zhao@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com, 
	zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,linux.intel.com,alien8.de,kernel.org,intel.com,lwn.net,redhat.com,google.com,cmpxchg.org,infradead.org,zytor.com,suse.cz,arm.com,ziepe.ca,amazon.com,nvidia.com,suse.de,linux.dev,oracle.com,maciej.szmigiero.name,loongson.cn,efficios.com,digikod.net,amd.com,ellerman.id.au,amazon.es,dabbelt.com,sifive.com,gmail.com,goodmis.org,amazon.co.uk,linutronix.de,zeniv.linux.org.uk,huawei.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69418-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[97];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: DF665A9398
X-Rspamd-Action: no action

Alexey Kardashevskiy <aik@amd.com> writes:

>
> [...snip...]
>
>

Thanks for bringing this up!

> I am trying to make it work with TEE-IO where fd of VFIO MMIO is a dmabuf=
 fd while the rest (guest RAM) is gmemfd. The above suggests that if there =
is gmemfd - then the memory attributes are handled by gmemfd which is... ex=
pected?
>

I think this is not expected.

IIUC MMIO guest physical addresses don't have an associated memslot, but
if you managed to get to that line in kvm_gmem_get_memory_attributes(),
then there is an associated memslot (slot !=3D NULL)?

Either way, guest_memfd shouldn't store attributes for guest physical
addresses that don't belong to some guest_memfd memslot.

I think we need a broader discussion for this on where to store memory
attributes for MMIO addresses.

I think we should at least have line of sight to storing memory
attributes for MMIO addresses, in case we want to design something else,
since we're putting vm_memory_attributes on a deprecation path with this
series.

Sean, what do you think?

Alexey, shall we discuss this at either the upcoming PUCK or guest_memfd
biweekly session?

> The problem at hand is that kvm_mmu_faultin_pfn() fails at "if (fault->is=
_private !=3D kvm_mem_is_private(kvm, fault->gfn))" and marking MMIO as pri=
vate using kvm_vm_ioctl_set_mem_attributes() does not work as kvm_gmem_get_=
memory_attributes() fails on dmabuf fds.
>
> I worked around this like below but wonder what is the proper way? Thanks=
,
>
>
> @@ -768,13 +768,13 @@ unsigned long kvm_gmem_get_memory_attributes(struct=
 kvm *kvm, gfn_t gfn)
>   	 */
>   	if (!slot)
>   		return 0;
>
>   	CLASS(gmem_get_file, file)(slot);
>   	if (!file)
> -		return false;
> +		return kvm_get_vm_memory_attributes(kvm, gfn);
>
>   	/*
>   	 * Don't take the filemap invalidation lock, as temporarily acquiring
>   	 * that lock wouldn't provide any meaningful protection.  The caller
>   	 * _must_ protect consumption of private vs. shared by checking
>   	 * mmu_invalidate_retry_gfn() under mmu_lock.
>
>
>
> --
> Alexey


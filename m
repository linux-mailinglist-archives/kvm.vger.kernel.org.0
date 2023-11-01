Return-Path: <kvm+bounces-340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 392E87DE82A
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 23:35:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE4FEB211DB
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 22:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03BF6101EB;
	Wed,  1 Nov 2023 22:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b5mh1Mru"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD85F3C0B
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 22:35:09 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724F2131
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 15:35:00 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a90d6ab944so5416547b3.2
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 15:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698878099; x=1699482899; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oVrvOLECZXxSaWjRNpKGTaiE8FNIaCo3DEHHzsR8PGo=;
        b=b5mh1MruIW+Wz9fLsRF7Crc1pctj+MHKhH0i16f7UD5/dRSmav+yoNrvmst7G8UVxN
         I8wMqCnPp3K/CRYmZ2I9/ud/fpHYvJokyDibpOhgOr6gnZq1JGwslG+kSFIghY5JE+dG
         ZpD3gs+zFjm2+UXCoAa4ai5nFfbZaNE8xr4VYi+KnkDqR2+hlPod/DQHr/dURW20/rDr
         YXR+1AOEI9w/xR8Kv18S+7QSlILwYZzJ4NHEnkFJmbxTYl8PCIE15p8kMt8iCdHtX9ju
         DElQq7Tm0yx97T5u32j2XuTqQi58aPsvj+AGsdWjECpekqodnFTZo5XZ79BC1Y4psMEi
         BNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698878099; x=1699482899;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oVrvOLECZXxSaWjRNpKGTaiE8FNIaCo3DEHHzsR8PGo=;
        b=Ejkmbj00yE5PnM93H8NHr8CKfaZoX6q7G4reuAJm7HEFDrj/yqu2OGxsVuIRbX6AB0
         YgR8YG+unGiT7R2CH/LU16LMJSmlcc92Xl0ViedhE+Tk5Z3JbH96Ac9DZNPhyK/HUnS7
         eA7mEeFYB+dRy8V7U84dmvE1XQ1gsTAIEXI2gHPp9Hr0dpdYKq83tIcKMDHbO0JLRNA3
         CndYSfVfeRx9KDOmTWf2yEdBqMKHIHI6oZv7ksyGSImzKf12BDYDeuUyw6cqfvYczIpl
         RLY6Q0ter4qbDgkNs6+fmgp7bfxkVUi9Wj/JQ4KsK87HNSphix0qAHh1RrOKmr+kxXDv
         2HSw==
X-Gm-Message-State: AOJu0YwSqIPyofmv3xJ/M18huHeqY3KZH3BswIoW/UCH/0vlkZE/VctZ
	LEBcDq//7QrooUOOuifYTLCcqR+KUrE=
X-Google-Smtp-Source: AGHT+IGD6UN3MOOerdMFLEmny4gzkak60wHqIVXKsA4NlWLNqw1UJj00i84usFlUQuEsQ45Qnt2ok92VRKM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9214:0:b0:5a7:bbdb:6b39 with SMTP id
 j20-20020a819214000000b005a7bbdb6b39mr350826ywg.3.1698878099514; Wed, 01 Nov
 2023 15:34:59 -0700 (PDT)
Date: Wed, 1 Nov 2023 15:34:58 -0700
In-Reply-To: <4ca2253d-276f-43c5-8e9f-0ded5d5b2779@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-18-seanjc@google.com>
 <7c0844d8-6f97-4904-a140-abeabeb552c1@intel.com> <ZUEML6oJXDCFJ9fg@google.com>
 <92ba7ddd-2bc8-4a8d-bd67-d6614b21914f@intel.com> <ZUJVfCkIYYFp5VwG@google.com>
 <CABgObfaw4Byuzj5J3k48jdwT0HCKXLJNiuaA9H8Dtg+GOq==Sw@mail.gmail.com>
 <ZUJ-cJfofk2d_I0B@google.com> <4ca2253d-276f-43c5-8e9f-0ded5d5b2779@redhat.com>
Message-ID: <ZULSkilO-tdgDGyT@google.com>
Subject: Re: [PATCH v13 17/35] KVM: Add transparent hugepage support for
 dedicated guest memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 01, 2023, Paolo Bonzini wrote:
> On 11/1/23 17:36, Sean Christopherson wrote:
> > > > "Allow" isn't perfect, e.g. I would much prefer a straight KVM_GUEST_MEMFD_USE_HUGEPAGES
> > > > or KVM_GUEST_MEMFD_HUGEPAGES flag, but I wanted the name to convey that KVM doesn't
> > > > (yet) guarantee hugepages.  I.e. KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is stronger than
> > > > a hint, but weaker than a requirement.  And if/when KVM supports a dedicated memory
> > > > pool of some kind, then we can add KVM_GUEST_MEMFD_REQUIRE_HUGEPAGE.
> > > I think that the current patch is fine, but I will adjust it to always
> > > allow the flag, and to make the size check even if !CONFIG_TRANSPARENT_HUGEPAGE.
> > > If hugepages are not guaranteed, and (theoretically) you could have no
> > > hugepage at all in the result, it's okay to get this result even if THP is not
> > > available in the kernel.
> > Can you post a fixup patch?  It's not clear to me exactly what behavior you intend
> > to end up with.
> 
> Sure, just this:
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 7d1a33c2ad42..34fd070e03d9 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -430,10 +430,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  {
>  	loff_t size = args->size;
>  	u64 flags = args->flags;
> -	u64 valid_flags = 0;
> -
> -	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> -		valid_flags |= KVM_GUEST_MEMFD_ALLOW_HUGEPAGE;
> +	u64 valid_flags = KVM_GUEST_MEMFD_ALLOW_HUGEPAGE;
>  	if (flags & ~valid_flags)
>  		return -EINVAL;
> @@ -441,11 +438,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  	if (size < 0 || !PAGE_ALIGNED(size))
>  		return -EINVAL;
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  	if ((flags & KVM_GUEST_MEMFD_ALLOW_HUGEPAGE) &&
>  	    !IS_ALIGNED(size, HPAGE_PMD_SIZE))
>  		return -EINVAL;
> -#endif

That won't work, HPAGE_PMD_SIZE is valid only for CONFIG_TRANSPARENT_HUGEPAGE=y.

#else /* CONFIG_TRANSPARENT_HUGEPAGE */
#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
#define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
#define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })

...

>  	return __kvm_gmem_create(kvm, size, flags);
>  }
> 
> Paolo
> 


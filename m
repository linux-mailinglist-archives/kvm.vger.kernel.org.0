Return-Path: <kvm+bounces-5666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FD0582482B
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 19:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44D9E1C225CB
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 18:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56F9828E0F;
	Thu,  4 Jan 2024 18:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HLFcI8aF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACAE28E02
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 18:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-336897b6bd6so714888f8f.2
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 10:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704392993; x=1704997793; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xbjYIxuq4GpjHNJQGMJNaXkZKyDNB4tpT6uaJ84I2fI=;
        b=HLFcI8aF+ZhWhsLf+GXm6nQiTW+eAS3ia8BOOjONHh1qPvzlBz+JxketHgrAT59gpo
         8xmJGd5ULLOBGvVU4FRDb4VXWnWLQtHq1B2ZK4ZhIOJAZjck7hJVD/3GEB/wXzS+VTJX
         xJ/EFkWaqeOXrEV2sjfaz5xQA7o6BmiVBE2ZN0It1UZ1LDFdUcuB0VanNQQAFsOtXcfx
         hL0xprt3/v1C00XVIFOmFg6ZidNCpVlcX+SJgA5WJoLJmEgNJ6CODTCc6Shod5jAHZU6
         m5cpuIUD5t4z6A1a83tFvdwOFcqzwQ6k/IODpA19YFZpHLYaLYYoaU5GqSZFgiETxvKw
         Niow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704392993; x=1704997793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xbjYIxuq4GpjHNJQGMJNaXkZKyDNB4tpT6uaJ84I2fI=;
        b=KubPta2mQRmIUIcxROi7AFl8WxP8NNhi+x24sDec2fBy1gjgyVwAKe8FoGEErfNida
         hNPD5BM7L0e00W0cax70rKmmGUurHJDQezMgofP1sWDBZU8t91VPa/oyfX2sDX3SceuO
         wXV80qK72iw3cK7Gy9gpHDGd5Ua+BAau2zSVr+KGagDXZR/9MejomJYPGoIUEpYVhnuA
         Fu7qqdqHMUOdGieEMvd35Q3aYqgd8saDmDQpMuQq0iZ3REg3ocKLALWaMNk5KEKhbKLh
         AKqtdFMGWGQawsamu5Bo7Bc+j8FEB4OJhPrmGDyjWGpr+gf+HB7IlQNxQDYlWkWaJNNN
         wHBg==
X-Gm-Message-State: AOJu0Yx7b7yEAH5/Q+Kt/0lrfiS+jgmunL4h9WPxEio6cU7wiEltIWLT
	+y8zCKnWplUWYiRIGyOl6kFdgajqjnuqtyplZUyVUigakKR6
X-Google-Smtp-Source: AGHT+IEwnXAETOHlHXjrqQRiM+k251OUQ4PEDmhJXHg+fbwO+fOTCxFZLAovkSsX1Wb174sh7cZsiWni2q94wSXz5PQ=
X-Received: by 2002:adf:f386:0:b0:337:4916:e1e4 with SMTP id
 m6-20020adff386000000b003374916e1e4mr493064wro.24.1704392993231; Thu, 04 Jan
 2024 10:29:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240103123959.46994-1-liangchen.linux@gmail.com>
 <ZZV8gz7wSCZCX0GZ@google.com> <CAKhg4tJA2TQ_1Zwv2N-PD7dsv_b5OW3Y5uRpnrR2ZOy-63Dsng@mail.gmail.com>
In-Reply-To: <CAKhg4tJA2TQ_1Zwv2N-PD7dsv_b5OW3Y5uRpnrR2ZOy-63Dsng@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 4 Jan 2024 10:29:25 -0800
Message-ID: <CALzav=fKKvKzm6fYUyP4=_uPcFeA3wqBZqGonkz6Rd1+6yuVaw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: count number of zapped pages for tdp_mmu
To: Liang Chen <liangchen.linux@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 3, 2024 at 8:14=E2=80=AFPM Liang Chen <liangchen.linux@gmail.co=
m> wrote:
>
> On Wed, Jan 3, 2024 at 11:25=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > +David
> >
> > On Wed, Jan 03, 2024, Liang Chen wrote:
> > > Count the number of zapped pages of tdp_mmu for vm stat.
> >
> > Why?  I don't necessarily disagree with the change, but it's also not o=
bvious
> > that this information is all that useful for the TDP MMU, e.g. the pf_f=
ixed/taken
> > stats largely capture the same information.
> >
>
> We are attempting to make zapping specific to a particular memory
> slot, something like below.
>
> void kvm_tdp_zap_pages_in_memslot(struct kvm *kvm, struct kvm_memory_slot=
 *slot)
> {
>         struct kvm_mmu_page *root;
>         bool shared =3D false;
>         struct tdp_iter iter;
>
>         gfn_t end =3D slot->base_gfn + slot->npages;
>         gfn_t start =3D slot->base_gfn;
>
>         write_lock(&kvm->mmu_lock);
>         rcu_read_lock();
>
>         for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
>
>                 for_each_tdp_pte_min_level(iter, root,
> root->role.level, start, end) {
>                         if (tdp_mmu_iter_cond_resched(kvm, &iter, false, =
false))
>                                 continue;
>
>                         if (!is_shadow_present_pte(iter.old_spte))
>                                 continue;
>
>                         tdp_mmu_set_spte(kvm, &iter, 0);
>                 }
>         }
>
>         kvm_flush_remote_tlbs(kvm);
>
>         rcu_read_unlock();
>         write_unlock(&kvm->mmu_lock);
> }
>
> I noticed that it was previously done to the legacy MMU, but
> encountered some subtle issues with VFIO. I'm not sure if the issue is
> still there with TDP_MMU. So we are trying to do more tests and
> analyses before submitting a patch. This provides me a convenient way
> to observe the number of pages being zapped.

Note you could also use the existing tracepoint to observe the number
of pages being zapped in a given test run. e.g.

  perf stat -e kvmmmu:kvm_mmu_prepare_zap_page -- <cmd>


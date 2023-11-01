Return-Path: <kvm+bounces-336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA527DE7E5
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 23:03:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FA9228196C
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 22:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272DB1BDEA;
	Wed,  1 Nov 2023 22:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dJSfIAoN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA26A1B274
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 22:03:36 +0000 (UTC)
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78788119
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 15:03:35 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-28047b044c7so405038a91.1
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 15:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698876215; x=1699481015; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ZU+1hGLS1p24YJ0Oz/rgPyiteG3BeX33TYEESUTVqo=;
        b=dJSfIAoNGfj8hQbgUtnktt4j7LghDRNWWFKGD4GlAo0JjA6zeRIYLMdc1FmvQxKBB7
         +JNQGFN3xm+0B0eVTMxuIS26KQhXNun6cY73rMLSSNgxs+yXZrVvWZ8UPouL81KmSyAk
         E5RUUc75DFJyT/SgS6gtLYXcODDLNJA62gvm/OpMxFiKwy2uicRUwHBcCos0VdPBam8L
         wj9yx4uTnARs+HEYGI35vkSwdqgFvGGH/huQ5sWf8mMIrQlexGU9V1OFTFk7MY8jhTre
         PiJpYL356Pf7Wpdg0IXxb5BDkt1bnJhJT8ADarkyLqBijvqAnk52hWu1GqYuUFXieA86
         1kEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698876215; x=1699481015;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9ZU+1hGLS1p24YJ0Oz/rgPyiteG3BeX33TYEESUTVqo=;
        b=COuvyMkHgsd5m1S7zj8hp/aNTN04ZHbyvtmGbu86mGsPuoXHamrkhmtOO7Y7wUVwi0
         KoGHf73fSfaUrW++pQeiaSoeusBDyb4G32Lnbn+fgtlH535VGzjfSa/o9+/vOCaNoi3m
         qWwkjiQHQRvim4Ni4leWqo2lE6TfKx1CG2vzgjpPH/2BwzGBSMd5hxEsLIiP0J3P+UAg
         Teali9+toIUnWV8LM/I/WvKkwUJEaH84VoRdDC5fhWTkLl8u5LDJkFefMLzQ7HpAYt+D
         a3+0NTQWkv5gmHL07WLavu315KysCXw8/F6oAUTDtEUNk5F7kG3KDkiOOhHQ46LYxhf8
         cc+w==
X-Gm-Message-State: AOJu0YxIWuKRr7g4juMc42lYTo8H6EgbgdyEbUngVePcD4cb8mLJobQN
	064FJB78GSuKyzv/xNAoQzozCNwtlCk=
X-Google-Smtp-Source: AGHT+IHPcjgmyv9WoTbUQE58M8ZiWzPznaMabtLTbSV5dQBOxggN5DSgAVvI1zvZhKtsRySjP+UptSV3mCU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:185:b0:1cc:3da9:2b96 with SMTP id
 z5-20020a170903018500b001cc3da92b96mr284471plg.3.1698876214832; Wed, 01 Nov
 2023 15:03:34 -0700 (PDT)
Date: Wed, 1 Nov 2023 15:03:33 -0700
In-Reply-To: <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
Message-ID: <ZULLNdp6XKD6Twuc@google.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: David Matlack <dmatlack@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 01, 2023, Anish Moorthy wrote:
> On Wed, Oct 4, 2023 at 6:44=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > Eh, the shortlog basically says "do work" with a lot of fancy words.  I=
t really
> > just boils down to:
> >
> >   KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_ON_MI=
SSING
>=20
> Proposed commit message for v6:
>=20
> > KVM: Implement KVM_CAP EXIT_ON_MISSING by checking memslot flag in __gf=
n_to_pfn_memslot()
> >
> > When the slot flag is enabled, forbid __gfn_to_pfn_memslot() from
> > faulting in pages for which mappings are absent. However, some callers =
of
> > __gfn_to_pfn_memslot() (such as kvm_vcpu_map()) must be able to opt out
> > of this behavior: allow doing so via the new can_exit_on_missing
> > parameter.
>=20
> Although separately, I don't think the parameter should be named
> can_exit_on_missing (or, as you suggested, can_do_userfault)-
> __gfn_to_pfn_memslot() shouldn't know or care how its callers are
> setting up KVM exits, after all.

Why not?  __gfn_to_pfn_memslot() gets passed all kinds of constraints, I do=
n't
see how "I can't handle exits to userspace" is any different.

> I think it makes sense to rename the new parameter and, for the same
> reasoning, the memslot flag to "forbid_fault_on_missing" and
> KVM_MEM_FORBID_FAULT_ON_MISSING respectively. Objections?

Yes.  I very strongly prefer KVM_MEM_EXIT_ON_MISSING.  As David pointed out=
, KVM
already has established nomenclature around exit, i.e. "exit on" should be =
quite
intuitive for most KVM developers.

"Forbid fault" is rather nonsensical because a fault has already happened. =
 The
confusion between "page fault VM-Exit" and "faulting in memory in the host"=
 is
the main reason we wandered away from anything with "fault" in the name.

That said, I do agree that can_do_userfault doesn't work with KVM_MEM_EXIT_=
ON_MISSING.
Maybe just a boring can_exit_on_missing?


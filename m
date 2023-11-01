Return-Path: <kvm+bounces-334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 861887DE7B1
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 22:53:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A59061C209E8
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 21:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A791BDCE;
	Wed,  1 Nov 2023 21:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="due/HLHw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8531B296
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 21:53:47 +0000 (UTC)
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C24119
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 14:53:46 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id 006d021491bc7-581ed744114so146730eaf.0
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 14:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698875625; x=1699480425; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pNGtVCoxYNTqqb91lIin52vLqJx98695iGNTRt2vMkQ=;
        b=due/HLHwDNo3rIbJwyeSI5u8S2s7Z1BKuZ+tyJ3dnIANS2+0O/eCX0HJfStqOFxVvL
         Hx7U2zSO+PiQN8d41w4o22OjHR6PMVXx2Yo39Ly9rwj92/B9nKG9XGWH8ZDHwIoRmWIy
         XSC372amhehCUWpmNI8hIYI/iNXjvZjidZKqKOygQv60RUii0ChUW0qz58p2TL8DwJDX
         dnzFu3+gmQQyzmXKqY8EO/kni1G/cd1zefVEu3TleMouPE0fyhH4itCnKpEMl/NTsyyY
         JgAUxFpSGLm5eyc9gzD9uRm/U5lfWywlvUnnLLpNudQM3ikGuWlRZRjl+R8LojMG6SAS
         pMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698875625; x=1699480425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNGtVCoxYNTqqb91lIin52vLqJx98695iGNTRt2vMkQ=;
        b=LGWpglhoPpeaQFZFiWkkTe3dmhO+hVkXT1Ieiup4/xsLoD+Wdxl8yDh8CkcbP/Lc9m
         PkK7DQFUn0x34aDX9cBHfErUSJJVrJ13ghhbH0GylGswIz0TJ+6fuO0lQ9ntm9Q73pm+
         VEBKJHAZQwlXZTuizWPIv9TjMqRpB1qP/L+OAg7EXNMafPG43BqbLJfa4lW1St/lMyac
         1BbbAZALgi3KXV63+rmzPe8BRS1C2kBMBak/vDKSK+OhHHzRoG0Q/HAi6AE+U0y0tcJJ
         V4mSVj61tvwZSmrsdd2U0pbb5De79AAmOrd3amOt06WxOwtnzx+cyD9sUm6G7elPKUYD
         PuNg==
X-Gm-Message-State: AOJu0YztoAcNjqiHzm6yUDAohvBw8aXYEjVSF3ncKJArA9UJeGd7qrVW
	xFjB1TdwCI9hhUVi8hst0E/hWZqQtQ54+XZcYf3KTg==
X-Google-Smtp-Source: AGHT+IHbn1+cpbAI+nliVXgth/Acy7IzPuB2yfJ1vWUR+O6XaiKCG2ZEex24dfHa/3lbHwAMIWL2L6Fx5V4/upuTheA=
X-Received: by 2002:a4a:de89:0:b0:57b:86f5:701c with SMTP id
 v9-20020a4ade89000000b0057b86f5701cmr13459410oou.4.1698875625558; Wed, 01 Nov
 2023 14:53:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com>
In-Reply-To: <ZR4U_czGstnDrVxo@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 1 Nov 2023 14:53:09 -0700
Message-ID: <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To: Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 4, 2023 at 6:44=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Eh, the shortlog basically says "do work" with a lot of fancy words.  It =
really
> just boils down to:
>
>   KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_ON_MISS=
ING

Proposed commit message for v6:

> KVM: Implement KVM_CAP EXIT_ON_MISSING by checking memslot flag in __gfn_=
to_pfn_memslot()
>
> When the slot flag is enabled, forbid __gfn_to_pfn_memslot() from
> faulting in pages for which mappings are absent. However, some callers of
> __gfn_to_pfn_memslot() (such as kvm_vcpu_map()) must be able to opt out
> of this behavior: allow doing so via the new can_exit_on_missing
> parameter.

Although separately, I don't think the parameter should be named
can_exit_on_missing (or, as you suggested, can_do_userfault)-
__gfn_to_pfn_memslot() shouldn't know or care how its callers are
setting up KVM exits, after all.

I think it makes sense to rename the new parameter and, for the same
reasoning, the memslot flag to "forbid_fault_on_missing" and
KVM_MEM_FORBID_FAULT_ON_MISSING respectively. Objections?


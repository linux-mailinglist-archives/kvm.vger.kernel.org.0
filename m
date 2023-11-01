Return-Path: <kvm+bounces-343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B82D7DE864
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 23:56:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CFAB2819E1
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 22:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACEB1B282;
	Wed,  1 Nov 2023 22:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="De5kuXXi"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A685F18E08
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 22:56:07 +0000 (UTC)
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457BA119
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 15:56:06 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-6d2fedd836fso172115a34.1
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 15:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698879365; x=1699484165; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jrvYQU4WA1un1SeaZQLwsW4KzArk33583vMtLvNHy+s=;
        b=De5kuXXidpIwL0y/k019BbWWjV5dVhZRW8E4cQRIDMby1y2/YXWAsjnMLQPA0GIbuB
         je+fzpJ5ZrY/SWmPo+YDnJgIx/sf5+vAejmZo0R0uaDQrqEWpy5pjAHg1i7pR9n5/M+s
         +EchiBmN6t2Kez28yH8fqi76JFNzH8ZqjrTH0go1BA/XEMvtTjXZhl7HGffhBe82ztmq
         d5dLpx0Ykgss5/cJLksHcc8oG/r8/lsEArDXDL7MpCDnvvBInDv9otj1PLAc2Qz2TFcH
         8KKx9rXOyTOjNGeMVqNpQVcwfa5IOyLiSafbhrSTfszIT+WinEV9t2Rt9GYi5SzQ52k1
         vLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698879365; x=1699484165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jrvYQU4WA1un1SeaZQLwsW4KzArk33583vMtLvNHy+s=;
        b=cGz78P2oGwvVbcDsWJYqixw2yzpdA5lL83CDGpYh/pEtIgT743XCVCEEv/yJuSRk2H
         qY+rT4jYKemgJ5SR+SL8gEl6dqWEddw/8zEkOCugoOYoDf3v6H/kHPboAznTWjGB+t2c
         /TJM2T6UIWZXkp0WA34u4zlbrH1f/sJhLM8Ysa/ANcdeDokknFQDSzb+xGYQMySo+cGt
         f9D+ZZM0B8+xfeLQ9TOOjf3do/KXf+f9Eo+MBvL22MJOZR8RUSPMRa7Yt/1JLbYGDNtp
         ScKPyisC7TJ900drKR5OZpqaFhzqm5Jybwyq/T4X3S8tldj85zeWuzcyO9KP1AaV16lM
         3NdA==
X-Gm-Message-State: AOJu0YxBiWorqoq5275gIE1iNEy4gdSSDWkl1xY6xExO8NEMr+uIImkx
	qKozEZ3ehOkBcGyW3RCEWK749HQeTPmQBS20/TDTtg==
X-Google-Smtp-Source: AGHT+IH+2aIZiuOrtKGaaevt7OnKP2TRzw53ixw7u/I6WI7t+0IGfCTUwcgoNgYWrurLwuw9EkLvMEhLMOj9Z8J00go=
X-Received: by 2002:a05:6870:6b0c:b0:1e9:cde8:6db0 with SMTP id
 mt12-20020a0568706b0c00b001e9cde86db0mr24144773oab.50.1698879365487; Wed, 01
 Nov 2023 15:56:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-12-amoorthy@google.com>
 <ZR4WzE1JOvq_0dhE@google.com>
In-Reply-To: <ZR4WzE1JOvq_0dhE@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 1 Nov 2023 15:55:29 -0700
Message-ID: <CAF7b7mo0Pbju__J+58-0zHxNFn7R2=8WKTHmKYtcb_4eEa5bTw@mail.gmail.com>
Subject: Re: [PATCH v5 11/17] KVM: x86: Enable KVM_CAP_USERFAULT_ON_MISSING
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 4, 2023 at 6:52=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Sep 08, 2023, Anish Moorthy wrote:
> > The relevant __gfn_to_pfn_memslot() calls in __kvm_faultin_pfn()
> > already use MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE.
>
> --verbose

Alright, how about the following?

    KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING

    __gfn_to_pfn_memslot(), used by the stage-2 fault handler, already
    checks the memslot flag to avoid faulting in missing pages as required.
    Therefore, enabling the capability is just a matter of selecting the kc=
onfig
    to allow the flag to actually be set.

> Hmm, I vote to squash this patch with
>
>   KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()
>
> or rather, squash that code into this patch.  Ditto for the ARM patches.
>
> Since we're making KVM_EXIT_MEMORY_FAULT informational-only for flows tha=
t KVM
> isn't committing to supporting, I think it makes sense to enable the arch=
 specific
> paths that *need* to return KVM_EXIT_MEMORY_FAULT at the same time as the=
 feature
> that adds the requirement.
>
> E.g. without HAVE_KVM_USERFAULT_ON_MISSING support, per the contract we a=
re creating,
> it would be totally fine for KVM to not use KVM_EXIT_MEMORY_FAULT for the=
 page
> fault paths.  And that obviously has to be the case since KVM_CAP_MEMORY_=
FAULT_INFO
> is introduced before the arch code is enabled.
>
> But as of this path, KVM *must* return KVM_EXIT_MEMORY_FAULT, so we shoul=
d make
> it impossible to do a straight revert of that dependency.

Should we really be concerned about people reverting the
KVM_CAP_MEMORY_FAULT_INFO commit(s) in this way? I see what you're
saying- but it also seems to me that KVM could add other things akin
to KVM_CAP_EXIT_ON_MISSING in the future, and then we end up in the
exact same situation. Sure the squash might make sense for the
specific commits in the series, but there's a general issue that isn't
really being solved.

Maybe I'm just letting the better be the enemy of the best, but I do
like the current separation/single-focus of the commits. That said,
the squash is nbd and I can go ahead if you're not convinced.


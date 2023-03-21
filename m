Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F926C3955
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 19:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjCUSn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 14:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjCUSnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 14:43:25 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AB0125B1
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 11:43:23 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id eh3so63478215edb.11
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 11:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679424201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ohhqDsCLYfpzIIE4F2lUBUQryvNnStoEMv2pDMLkHdo=;
        b=LetR2f1GPtGj3oeIe6E03BnsjqROtkXnjdIAKl4EdwzEXK1KeCoQ94Hvp9F40ZDsN4
         n2ik4werQ5zw5XjuP08Tx50KscIwXNw/apIKRZdReIQiOkgdFkP86ChT0xio7C/PRCIN
         qJCYAesJ+xD50Eg41Wlx3+oLw6Gytge6dqgtl/wvgPKNAk9hySjO4SYYUh87EYc33NHy
         BVwNU9yPc++6yisaHj6XaIGXEMW6YHG4D4JBEUhnaFa5KDEzjuPsM7cAPqP2KRmeMXxG
         NFbFvcCfrBfWgtoTkxE6QsypD7uQ4MU7vzXDwwhIc/dCx0LNq56NmqPtSpCq6zfy9eQb
         0ZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679424201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ohhqDsCLYfpzIIE4F2lUBUQryvNnStoEMv2pDMLkHdo=;
        b=mOyTx+ZSoyBhURyA2mSjNXTDklriQgVGD8ZexIg7amTNmcWGI7p99PSwjb+7h4o/++
         ODth2NJnEOg4b/VDrNSh029cpTzDBNVK1rhZskbu/k+Mvy8E/dpjUS4mMP5XTP6Ohv2d
         +jeT7EFVG+gjhq5G74I8yE5LMtRwdVt4nseiqUiAUXKMUG+gftX45ux/fK/9m3beF2bz
         n6zVQ9xwiot8qLDXrG52J9gUKT86icGeo6Ti5GmWidAkESUntT8SsRDihO3cfRBZHuTf
         +11l9A0JoqixEbIdjo7yQJlrg5HU5Kn8Oud+qKAdPc7ytzqgTmfokI7QLzJix01SpgHT
         Mp5g==
X-Gm-Message-State: AO0yUKWHGg/S5hU+9H0UWtbd8V8SYD0QZh+4MQuICdv7xfMWd45kAxrU
        Ray3SeqRU2F551p+QiCnj8yahpzQZTjGz7uLz6r8jg==
X-Google-Smtp-Source: AK7set+0GRGAz++2g+LU9YjyhcfCnqkCdU/hDG6hEjnahL+57jED88lUHYAA7JBDFn9X+zBeM2SYmAsToxjlvFv1g/I=
X-Received: by 2002:a17:906:29c4:b0:92f:fc27:8ea0 with SMTP id
 y4-20020a17090629c400b0092ffc278ea0mr1742585eje.9.1679424201695; Tue, 21 Mar
 2023 11:43:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com> <20230202182809.1929122-10-bgardon@google.com>
 <ZBio2Cs7UrkkilTc@google.com>
In-Reply-To: <ZBio2Cs7UrkkilTc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 21 Mar 2023 11:43:10 -0700
Message-ID: <CANgfPd-QFtBO0ndYQwtJ13XSPF6tNSwwJDyq93=B36u3gohoxg@mail.gmail.com>
Subject: Re: [PATCH 09/21] KVM: x86/MMU: Move paging_tmpl.h includes to shadow_mmu.c
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023 at 11:41=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> First off, I apologize for not giving this feedback in the RFC.  I didn't=
 think
> too hard about the impliciations of moving paging_tmpl.h until I actually=
 looked
> at the code.
>
> On Thu, Feb 02, 2023, Ben Gardon wrote:
> > Move the integration point for paging_tmpl.h to shadow_mmu.c since
> > paging_tmpl.h is ostensibly part of the Shadow MMU.
>
> Ostensibly indeed.  While a simple majority of paging_tmpl.h is indeed un=
ique to
> the shadow MMU, all of the guest walker code needs to exist independent o=
f the
> shadow MMU.  And that code is signficant both in terms of lines of code, =
and
> more importantly in terms of understanding its role in KVM at large.
>
> This is essentially the same mess that eventually led the cpu_role vs. ro=
ot_role
> cleanup, and I think we should figure out a way to give paging_tmpl.h sim=
ilar
> treatment.  E.g. split paging_tmpl.h itself in some way.
>
> Unfortunately, this is a sticking point for me.  If the code movement wer=
e minor
> and/or cleaner in nature (definitely not your fault, simply the reality o=
f the
> code base), I might feel differently.  But as it stands, there is a lot o=
f churn
> to get to an endpoint that has significant flaws.
>
> So while I love the idea of separating the MMU implementations from the c=
ommon
> MMU logic, because the guest walker stuff is a lynchpin of sorts, e.g. sp=
litting
> out the guest walker logic could go hand-in-hand with reworking guest_mmu=
, I don't
> want to take this series as is.
>
> Sadly, as much as I'm itching to dive in and do a bit of exploration, I a=
m woefully
> short on bandwidth right now, so all I can do is say no.  Sorry :-(

Fair enough, thanks for taking a look. I'm not going to have bandwidth
in the foreseeable future to work on this any more either,
unfortunately. I'd love it is someone picked up this series and did
the paging_tmpl.h split, but that's  going to be a lot of work, so in
the meantime, I don't mind just letting this die.

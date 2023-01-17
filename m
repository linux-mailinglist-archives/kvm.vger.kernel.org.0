Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4861E670C9E
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 00:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjAQXAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 18:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjAQW7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 17:59:19 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F1120046
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 14:39:59 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id v19so30102784ybv.1
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 14:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gNr6IWvvUdbF90aTVa6CR/q2V8C5Ms8xmIs7PUizTPw=;
        b=hxy5pra7a6Hq9BCw5r79/pjnmnzUrPgb69s0DX0jrJZftLvBtAOYLF7MsMMG3J92VT
         uRHYNPD4CMaeOyj8LKUJM2FiOD+0qpF+mf2NFAB3W9yOsBTECNyuNpIa/3P/7PpVGRyo
         EuUJsv2oAZkJJHJQ+3K5j7+RylV+4CcP4Uqf2bGivjG3kKMhiMSaQSHFKtO54r3yaxdw
         EERSkAIPEqTm2N1wNjQ3SwLcra1CaYLdqGIt5MUdALkvKKgMuglEFpQ74+YT1TQ9FKaT
         m7jPOhreKsTDqOhK6AfVD7PsMLNGhiQ8f+9b4gQCrkRrPlggASW7jHazDad2JMExOyTT
         a/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gNr6IWvvUdbF90aTVa6CR/q2V8C5Ms8xmIs7PUizTPw=;
        b=tQZXhPXlCXBn658PxFkY4dEodgzsjdRl4NZG9bw989IdxcjKnPzKwcu0/f16oK4OQu
         nVBFjH9ewch8qWBTXMnozq03kUiUWKu1Oqeqsa1POX0LhLM7TeVivhDhf4r/MxOh/Bzz
         A1x+68/sXKFHJQfPvNwv3Ju5ugUSnhPSelzVECFEETQq3FjaSzcgLKtDgD66wu4EzFGW
         M3uUieru+Ia1iJ6yDRB2u0egLI1/Gdmm45J3Fhip5lB/o8XkdFlI5DUBO1ZJ68N5xdz+
         wuLHWQK/YoIdkKQRb4WEzRdgBB4p2fpwPvP34UUmrNJfLMWH0MCiulED8S/WNNvsH7li
         c3rg==
X-Gm-Message-State: AFqh2krU0hWojk6/bGv0L6WLbvLAmBI5NJlqKJxQM8b7EZHCS+ECfr6d
        BU0HL7ESvupAQren+gn90N65LZ6w1OHZaUb78qmNEg==
X-Google-Smtp-Source: AMrXdXtBvRvZsX6TBgQoau+fv8bqoSKm4PQuh+uHtprwGHIzSUqlPZf/ADBGsqYdmwep95HxuscMcRf8gfd/Al4cNnQ=
X-Received: by 2002:a25:d55:0:b0:74f:b2de:40cb with SMTP id
 82-20020a250d55000000b0074fb2de40cbmr522955ybn.147.1673995198849; Tue, 17 Jan
 2023 14:39:58 -0800 (PST)
MIME-Version: 1.0
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com> <Y7R36wsXn3JqwfEv@google.com>
 <CAAAPnDHff-2XFdAgKdfTQnG_a4TCVqWN9wxEhUtiOfiOVMuRWA@mail.gmail.com>
 <c87904cb-ce6d-1cf4-5b58-4d588660e20f@intel.com> <Y8BPs2269itL+WQe@google.com>
 <a1308e46-c319-fb73-1fde-eb3b071c10e8@intel.com> <Y8Bcr9VBA/VLjAwd@google.com>
 <6f22cb44-1a29-cb41-51e3-cbe532686c54@intel.com> <Y8B5xIVChfatMio0@google.com>
 <f65d284f-4f06-739b-a555-37d2811acdf3@intel.com> <CAL715WKmJ1BSozF18MOp=jRvMh-28fLWqBJvg87MaK8aOh33cA@mail.gmail.com>
 <CAAAPnDH21dqmHqiM2E3ph-qyEardx4-OkgRzRa27Qc3u2KQ+Zw@mail.gmail.com> <c3be155d-5cff-60ee-fb84-5bda693ea954@intel.com>
In-Reply-To: <c3be155d-5cff-60ee-fb84-5bda693ea954@intel.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 17 Jan 2023 14:39:47 -0800
Message-ID: <CAL715WLd2PJC71ObgZPcxSKdS+0H-o8Cscsfejw0cq5BGgOx-w@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Neel Natu <neelnatu@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Venkatesh Srinivas <venkateshs@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Jan 17, 2023 at 12:34 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
>
> On 1/13/2023 6:43 AM, Aaron Lewis wrote:
> >
> > I'd still like to clean up CPUID.(EAX=0DH,ECX=0):EAX.XTILECFG[17] by
> > keeping it consistent with CPUID.(EAX=0DH,ECX=0):EAX.XTILEDATA[18] in
> > the guest, but it's not clear to me what the best way to do that is.
> > The crux of the issue is that xstate_get_guest_group_perm() returns
> > partial support for AMX when userspace doesn't call
> > prctl(ARCH_REQ_XCOMP_GUEST_PERM), I.e. the guest CPUID will report
> > XTILECFG=1 and XTILEDATA=0 in that case.  In that situation, XTILECFG
> > should be cleared for it to be consistent.  I can see two ways of
> > potentially doing that:
> >
> > 1. We can ensure that perm->__state_perm never stores partial support.
> >
> > 2. We can sanitize the bits in xstate_get_guest_group_perm() before
> > they are returned, to ensure KVM never sees partial support.
> >
> > I like the idea of #1, but if that has negative effects on the host or
> > XFD I'm open to #2.  Though, XFD has its own field, so I thought that
> > wouldn't be an issue.  Would it work to set __state_perm and/or
> > default_features (what originally sets __state_perm) to a consistent
> > view, so partial support is never returned from
> > xstate_get_guest_group_perm()?
>
> FWIW, I was trying to clarify that ARCH_GET_XCOMP_GUEST_PERM is a
> variant of ARCH_GET_XCOMP_PERM in the documentation [1]. So, I guess #1
> will have some side-effect (at least confusion) for this semantics.

Right, before talking in this thread, I was not aware of the other
arch_prctl(2) for AMX. But when I look into it, it looks reasonable to
me from an engineering point of view since it seems reusing almost all
of the code in the host.

ARCH_GET_XCOMP_GUEST_PERM is to ask for "guest permission", but it is
not just about the "permission" (the fp_state size increase for AMX).
It is also about the CPUID feature bits exposure. So for the host side
of AMX usage, this is fine, since there is no partial CPUID exposure
problem. But the guest side does have it.

So, can we just grant two bits instead of 1 bit? For that, I find 1)
seems more reasonable than 2). Of course, if there are many side
effects, option #2 could be considered as well. But before that, it
will be good to understand where the side effects are.

>
> There may be some ways to transform the permission bits to the
> XCR0-capable bits. For instance, when considering this permission
> support in host, the highest feature number was considered to denote the
> rest feature bits [2].

Hmm, this is out of my concern since it is about the host-level
enabling. I have no problem with the existing host side permission
control for AMX.

However, for me, [2] does not seem a little hacky but I get the point.
The concern is that how do we know in the future, the highest bit
always indicates lower bits? Will Intel CPU features always follow
this style?  Even so, there is no such guidance/guarantee that other
CPU vendors (e.g., AMD) will do the same. Also what if there are more
than 1 dynamic features for a feature? Please kindly correct me.

Thanks.
-Mingwei


>
> Thanks,
> Chang
>
> [1]
> https://lore.kernel.org/lkml/20220922195810.23248-5-chang.seok.bae@intel.com/
> [2] https://lore.kernel.org/lkml/878rz7fyhe.ffs@tglx/

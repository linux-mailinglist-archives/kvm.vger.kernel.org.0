Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18DE2676019
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 23:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjATWWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 17:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjATWWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 17:22:00 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68026FD17
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 14:21:58 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-4c131bede4bso92218297b3.5
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 14:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aUZ0ffAJxXSAs75mrnI1JYQKtxulHE6LLibfAEIYCUE=;
        b=Hp9pWr8vPaWaHT+lrAMRQ2ucltxYK2bG/0HMjvFmx3K6MDIeTUplEsmdQbjt4FgodK
         PrAUBGgKy9MnLhlVVEPXB1G2qw5pC/mgmQ3kDbMFNr+T6lwuuu6/xbPfjv7QXrA4BTRI
         Kuga8w97T3EIpIO96C3x8Y1VQT7bioTSMyBKrcwydWpRy4cZkn0qDM2yGNYY4vs4dHhr
         24ziDrJuOztpNU3hRnEqYJhQLzAvvRY7Oz7fi7HVA3ITzX4BSU1xXOYprlZZcQ/DHRyM
         KRYh/85BN6IavNe8kucJOQzQfX0xX28K08m5VF1bzzuteRw29hJ5+WlP0eows+mZyfW/
         guIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aUZ0ffAJxXSAs75mrnI1JYQKtxulHE6LLibfAEIYCUE=;
        b=Z44VPr1vnU/f0Kuxk8CRFyPdmjeNr+ytwwkbsXTdyUru/rM5MAA/wQpNKZYoeg/men
         nl5cpRhmIxsfakwybazDAviQAfuel312nW2GDThYTLBhBl1Wv0CZhuAeYfK57GdhlqC/
         4NaTv4WqKvpLOrhJor+O4bmTJR8h41WbAn0utQY4THvQvlHLdvbiP+c8dFdIJvbKEtGZ
         6pPLaFk+SHLMFrgpOjbGT5pzY7P/fs1ghOnXxkMI5BFMCJgQrlAlA8bWqE+YwKMEbujy
         QJoBEwqUGX6fzGBM+wKChjK0IV4rL3/L2kcTsJ76aj2DtYj95RdKTPWHBcEiG5gSVGgX
         3Evg==
X-Gm-Message-State: AFqh2krjN+lhqLxfQ91UMOdHZ5GnINajSYQr02ErQkw4TR9M4OHZEwK2
        b6X+k3klxrbUsWPffyU2LZdMAEkpT20wCPsZ1h+kGg==
X-Google-Smtp-Source: AMrXdXvfyZ/JFeXqv55u2yuUwNm8Qm2ZSkWJdfn1rcJ73hXEVb6L9MkB0VNXwsliYqKgDcQANAkWmZs9heZw+eiV5dA=
X-Received: by 2002:a0d:e611:0:b0:4ff:b3a2:5962 with SMTP id
 p17-20020a0de611000000b004ffb3a25962mr467741ywe.111.1674253317753; Fri, 20
 Jan 2023 14:21:57 -0800 (PST)
MIME-Version: 1.0
References: <20230114111621.00001840@gmail.com> <Y8bFCb+rs25dKcMY@google.com>
 <20230117214414.00003229@gmail.com> <Y8cLcY12zDWqO8nd@google.com>
 <Y8cMnjHFNIFaoX27@google.com> <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
 <Y8ljwsrrBBdh1aYw@google.com> <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
 <Y8m34OEVBfL7Q4Ns@google.com> <1c71eda35e03372f29162c6a5286f5b4d1e1d7e1.camel@intel.com>
 <Y8ndcGHUHQjHfbF9@google.com>
In-Reply-To: <Y8ndcGHUHQjHfbF9@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 20 Jan 2023 14:21:31 -0800
Message-ID: <CALzav=d4vwHTnXP8wetA_Hqd3Tzc_NLp=3M-akwNSN1-ToL+Eg@mail.gmail.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 4:16 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jan 19, 2023, Huang, Kai wrote:
> > On Thu, 2023-01-19 at 21:36 +0000, Sean Christopherson wrote:
> > > The least invasive idea I have is expand the TDP MMU's concept of "frozen" SPTEs
> > > and freeze (a.k.a. lock) the SPTE (KVM's mirror) until the corresponding S-EPT
> > > update completes.
> >
> > This will introduce another "having-to-wait while SPTE is frozen" problem I
> > think, which IIUC means (one way is) you have to do some loop and retry, perhaps
> > similar to yield_safe.
>
> Yes, but because the TDP MMU already freezes SPTEs (just for a shorter duration),
> I'm 99% sure all of the affected flows already know how to yield/bail when necessary.
>
> The problem with the zero-step mitigation is that it could (theoretically) cause
> a "busy" error on literally any accesses, which makes it infeasible for KVM to have
> sane behavior.  E.g. freezing SPTEs to avoid the ordering issues isn't necessary
> when holding mmu_lock for write, whereas the zero-step madness brings everything
> into play.

(I'm still ramping up on TDX so apologies in advance if the following
is totally off base.)

The complexity, and to a lesser extent the memory overhead, of
mirroring Secure EPT tables with the TDP MMU makes me wonder if it is
really worth it. Especially since the initial TDX support has so many
constraints that would seem to allow a simpler implementation: all
private memory is pinned, no live migration support, no test/clear
young notifiers, etc.

For the initial version of KVM TDX support, what if we implemented the
Secure EPT management entirely off to the side? i.e. Not on top of the
TDP MMU. For example, write TDX-specific routines for:

 - Fully populating the Secure EPT tree some time during VM creation.
 - Tearing down the Secure EPT tree during VM destruction.
 - Support for unmapping/mapping specific regions of the Secure EPT
tree for private<->shared conversions.

With that in place, KVM never would need to handle a fault on a Secure
EPT mapping. Any fault (e.g. due to an in-progress private<->shared
conversion) can just return back to the guest to retry the memory
access until the operation is complete.

If we start with only supporting 4K pages in the Secure EPT, the
Secure EPT routines described above would be almost trivial to
implement. Huge Pages would add some complexity, but I don't think it
would be terrible. Concurrency can be handled with a single lock since
we don't have to worry about concurrent faulting.

This would avoid having TDX add a bunch of complexity to the TDP MMU
(which would only be used for shared mappings). If and when we want to
have more complicated memory management for TDX private mappings, we
could revisit TDP MMU integration. But I think this design could even
get us to the point of supporting Dirty Logging (where the only fault
KVM would have to handle for TDX private mappings would be
write-protection faults). I'm not sure it would work for Demand-Paging
(at least the performance would not be great behind a single lock),
but we can cross that bridge when we get there.

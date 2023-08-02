Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852C976D368
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 18:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjHBQKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 12:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjHBQKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 12:10:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325C01995
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 09:10:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d2a7ec86216so5183748276.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 09:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690992647; x=1691597447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J4aKHKt7aK1dph2vrDmFCSsCX7pNGRd0NMwM4bEJgp8=;
        b=zT0xCNei+dnr4osudv9CAX0NFIvpN9o/MM9DYDQ2quRiRk2ySEcgwiLx53XnB1e+LY
         cWfI4OmX27mBOaJ58zlzT26+ZLcNHSkLH9hi8/662YILNSSO1QkU4G145NcnSjse7Tfi
         xrBWi/aY8NG6dUaFl22owtMyugIfQwHdkO/hgFnA80wpzq4X517qJXwcuOIoXxcIvofm
         vONKX+ciK2E9BoSSjIdQ67NLAviV68y9PDQBJ3S/jrfYmNcLzOoOg269tqqWjlilRydM
         bYWsCmY8tkmpgydfPs6qY/prFitzHw68WvsqFmR4BcVKfrWapat3cp0d7IklIiRVq+z3
         Zr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690992647; x=1691597447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J4aKHKt7aK1dph2vrDmFCSsCX7pNGRd0NMwM4bEJgp8=;
        b=mDx1IbKjsnOWm1Z/+6uIWT4J6GQ4MOk1TrmD4VIo5o8WzkMKpVM0a+35ZS5VPvuBAO
         2u5Z+GPPrBwdldTG4Mame6dPY3SCzbw55pMhJU1b0/3BC5OFcP5qVeJawYGaZi4zCz1n
         FJNxOZNQHl4w8rLrpCU8pWL2YXSpRyuCYtIMPoPQ67vPCL9SjpQD+JWZ5Kgc7KGS+RZX
         isn04ERR7AIO+wF1WXyh8tw25VEHXFSrC6lJYOcJrG3vbpNTHTedW2sKuowsGf9Nb1WX
         FaVwAlriklR66BIUWFv6r9D4+nRVkTQV1OAosmyf16TbVzZ6byjk2qCWUuE4FVH/6G3z
         gvyQ==
X-Gm-Message-State: ABy/qLY5PaOEdUM7J0PP/BEt63pwU4weHXnozVVyIc+wctv/z4fjaiUJ
        mf/W7e0ir8BmC1VvyRo7RK1+uUTdreA=
X-Google-Smtp-Source: APBJJlEeZC4NdvQKtmvRvpxiJWd4xeVqmT7pbWiugvK9iOofl4skg4f0sy48sXdlWulLCE9MeEDt/9unkzk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab0b:0:b0:d0e:e780:81b3 with SMTP id
 u11-20020a25ab0b000000b00d0ee78081b3mr101602ybi.2.1690992647424; Wed, 02 Aug
 2023 09:10:47 -0700 (PDT)
Date:   Wed, 2 Aug 2023 09:10:46 -0700
In-Reply-To: <878ratqw2l.wl-maz@kernel.org>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-2-rananta@google.com>
 <87v8e5r6s6.wl-maz@kernel.org> <CAJHc60wtc2Usei3hKj1ykVRvBZFFCBOHMi9HCxnNvGK2dPFApA@mail.gmail.com>
 <ZMgqueePlmKvgUId@google.com> <CAJHc60xM+KsUKxtoqORnpzrRke4T-sob2uLJRMvBKwruipxnpw@mail.gmail.com>
 <878ratqw2l.wl-maz@kernel.org>
Message-ID: <ZMqABp6OdrgOtsum@google.com>
Subject: Re: [PATCH v7 01/12] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        "Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023, Marc Zyngier wrote:
> On Tue, 01 Aug 2023 01:42:54 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> > Thanks for the suggestions; I can go with a common declaration. Along
> > with that, do we want to keep defining
> > __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS in the arch code that supports it or
> > convert it into a CONFIG_?
> 
> This isn't something that a user can select, more something that is an
> architectural decision. Maybe in a later patch if there is a consensus
> around that, but probably not as part of this series.

+1.  I agree it's annoying that KVM uses a mix of Kconfigs and manual #defines
for the various "KVM_HAVE" knobs, but we have so many of both that one-off
conversions without a real need don't make much sense.

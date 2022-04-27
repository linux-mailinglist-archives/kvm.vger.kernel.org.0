Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185E6510DDD
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 03:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356684AbiD0B1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 21:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351922AbiD0B1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 21:27:36 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EDEB18A6
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:24:26 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u6-20020a17090a1f0600b001d86bd69427so490100pja.5
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s+1DGNfP27csPmcEuUa6GdLkoCCKVhZfePm8utK72a0=;
        b=gjJnXOsK4rrfZw+Ws5lrwQU5BDWtyWrRaNnMu7VdbR+x18pJ0FKC8xVKXILOkJdEn9
         d68FeNLIwRy2jvUBtHmxu6bckYkT1xpyuBR7kmY0YT944RTmKgN3eT/WNwpkh0dpHP1j
         Nzu+Zu9su1znHpY4uDer0N3Nr6TFlJmgCg/SeDJ6x5Ag2sklPVV8TbaLzg2dfyf7Yw1a
         /zYN2skd8pq2/GfYIe7lZyZj3YbB41YaEHlr1J7onqUj+ly9hugUQR0ALOdDpeyWNs5d
         TGRQ+CfM11cu6lV9tkvwrwXREJr9JpGboX4Qc9Re73LKIl4OUJRxTzqxX7iqquQFKtcL
         +TPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s+1DGNfP27csPmcEuUa6GdLkoCCKVhZfePm8utK72a0=;
        b=b2lnolNLfBZkpHUYIQvZgMw/mQdTkAnx8Sen7FJIph8hAJ6E8zXW8YQZU6FMqA0hnA
         jfI/aYPfQnKonv50/U3UH9VV7Wa3Y6w17WMY2YSbr8mON5/GBDmh9FHqm0q7J/zTPr8M
         CX91hcPCP2Yq/2qB/1GMtx9FB1PcDq5XvBtoChuC7gNpst3m4ZuzosyZFNQmC5EzdAFT
         plAAtuzL/ecAEUhkzUsWF6boMdvrK/8mFp1cjhwIpxHmcanPHIzIEr3PGfk0BQK2RhgY
         1+3uigOEIBwI8M+EJTaPsUHu3SbPvpxdC/Vp0bvWHel09HJI/lK0B98acZbGO3Rz0P3r
         09Tg==
X-Gm-Message-State: AOAM5301oeybRC4MOk572aYxz2ESpNOgWcWebOUPWYKnmgF7UIVGJaup
        d/6Arc6zeGENuQhh9XjYk7JAIaLwM6vv31QZnJJM6M/FuHdlyg==
X-Google-Smtp-Source: ABdhPJwUK91O5b+cbAzQvikG1pLBA2K0awm/orzrnsYaLD/yw4NUbNk63jNIpvhit8xkLMz9irAaJVgaGpEJd3Skf4Q=
X-Received: by 2002:a17:903:2444:b0:15d:281d:87 with SMTP id
 l4-20020a170903244400b0015d281d0087mr9336428pls.9.1651022665690; Tue, 26 Apr
 2022 18:24:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220327205803.739336-1-mizhang@google.com> <YkHRYY6x1Ewez/g4@google.com>
 <CAL715WL7ejOBjzXy9vbS_M2LmvXcC-CxmNr+oQtCZW0kciozHA@mail.gmail.com>
 <YkH7KZbamhKpCidK@google.com> <7597fe2c-ce04-0e21-bd6c-4051d7d5101d@redhat.com>
 <Ymg1lzsYAd6v/vGw@google.com> <CAL715WK8-cOJWK+iai=ygdOTzPb-QUvEwa607tVEkmGOu3gyQA@mail.gmail.com>
 <YmiZcZf9YXxMVcfx@google.com>
In-Reply-To: <YmiZcZf9YXxMVcfx@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 26 Apr 2022 18:24:14 -0700
Message-ID: <CAL715W+nMyF_f762Qif8ZsiOT8vgxXJ3Rm8EjgG8A=b7iM-cbg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: add lockdep check before lookup_address_in_mm()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
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

On Tue, Apr 26, 2022 at 6:16 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Apr 26, 2022, Mingwei Zhang wrote:
> > > I completely agree that lookup_address() and friends are unnecessarily fragile,
> > > but I think that attempting to harden them to fix this KVM bug will open a can
> > > of worms and end up delaying getting KVM fixed.
> >
> > So basically, we need to:
> >  - choose perf_get_page_size() instead of using any of the
> > lookup_address*() in mm.
> >  - add a wrapper layer to adapt: 1) irq disabling/enabling and 2) size
> > -> level translation.
> >
> > Agree?
>
> Drat, I didn't see that it returns the page size, not the level.  That's a bit
> unfortunate.  It definitely makes me less averse to fixing lookup_address_in_pgd()
>
> Hrm.  I guess since we know there's at least one broken user, and in theory
> fixing lookup_address_in_pgd() should do no harm to users that don't need protection,
> it makes sense to just fix lookup_address_in_pgd() and see if the x86 maintainers
> push back.

Yeah, fixing lookup_address_in_pgd() should be cleaner(), since the
page fault usage case does not need irq save/restore. But the other
one needs it. So, we can easily fix the function with READ_ONCE and
lockless staff. But wrapping the function with irq save/restore from
the KVM side.

ok, I think I can proceed and upload one version for that.

Thanks.
-Mingwei

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9C3683490
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 19:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjAaSCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 13:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjAaSCO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 13:02:14 -0500
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E77D517
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 10:02:12 -0800 (PST)
Received: by mail-vk1-xa33.google.com with SMTP id v5so7735268vkc.10
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 10:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hd1THhGtDBlQVqSyHF/LS8U0SI+/x7GvR/Q6jc/5tiM=;
        b=EDaFOyJeJI2PjeUcEVVodAjgZDDPZr82ASgXy6rJ1DqKThN2DFDlNMOv0oJNvG/azf
         FahW7Ksk8RHXVY+cpPhKHEPuY8NhNiIzS+Qkp5WV4mNWk07vUS9Mrh7d0phuy3reG5RL
         2RE+9Le1BDJKradDQzMfaDS3vW38c7DqvEHagIP/iW/pTPBTuUuD8OcZE2MI3n35Do5k
         M4JjJoWfFlb4T+cjvTqRo7li7he+vbEeT8NO/6EaCghi/NPLJ/1syl8rgqDNVBf2GsjP
         hgBZipDR/YhgC3uNAtkyoHD/mUQQi8KIkDe0BqrICwmPwMu7Pdx+2zsXlX+ayeQdaTGW
         6KSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hd1THhGtDBlQVqSyHF/LS8U0SI+/x7GvR/Q6jc/5tiM=;
        b=ntw/pCML2hUcrZxuNztJw3lBvoreR5+oOmk2wm6jBQOczOweq9ShHOjQIEhChTyqvn
         dCug/wtcRYJbaftBgQOoB8kQyeSFy8ZYxlwtgRU6Kvy8JMkrgPW0vufIZGxR6l028uBv
         j5M90Md7PBdOabNbGveYydhNo9mRzWWAPdekWBDMYaYpFF6xEOSsKIv+J0c2O4C+Ay0j
         RcFqj2lsPUvsIVh1jD/qzPcU8ggXh8amyEdYxff/t6fe6d1GiSDPu5fVsW5ze6BgyMDy
         Tbv2D7xoJx2ycpt+2Ltuf2G/O8xCkBaJVDy/v3qCW7/HV7QsoPStNrBUgBSNO1WvSud5
         GcDw==
X-Gm-Message-State: AO0yUKWZyPFzvpSBCWNcdBTM5CfN++dATZ3O0DSMpEWPkq9Op11PNl5x
        3iPpoyM0lm2RNXE7v7q/r5fjuQLUj4LG6NUezkrJIg==
X-Google-Smtp-Source: AK7set+lpmKLJYoUX7vniZmPxeL6Puj1OAb4ho8iEEB6jPm6972arYfYsuy28s7wxMx4vHW1VS2Tg21tdB1hDhyYlHo=
X-Received: by 2002:a05:6122:49d:b0:3ea:300e:bbbd with SMTP id
 o29-20020a056122049d00b003ea300ebbbdmr1251193vkn.6.1675188131976; Tue, 31 Jan
 2023 10:02:11 -0800 (PST)
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi> <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
 <86v8ktkqfx.wl-maz@kernel.org> <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
 <Y9g0KGmsZqAZiTSP@google.com> <Y9hsV02TpQeoB0oN@google.com> <Y9lTz3ryasgkfhs/@google.com>
In-Reply-To: <Y9lTz3ryasgkfhs/@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 31 Jan 2023 10:01:45 -0800
Message-ID: <CALzav=esLqUWd-1z=X+qzSxQDLS3Lh_cx4MAznp+rC9f-mrY0A@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is enabled
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Sean Christopherson <seanjc@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        yuzenghui@huawei.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        ricarkol@gmail.com
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

On Tue, Jan 31, 2023 at 9:46 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Tue, Jan 31, 2023 at 01:18:15AM +0000, Sean Christopherson wrote:
> > On Mon, Jan 30, 2023, Oliver Upton wrote:
> > > I think that Marc's suggestion of having userspace configure this is
> > > sound. After all, userspace _should_ know the granularity of the backing
> > > source it chose for guest memory.
> > >
> > > We could also interpret a cache size of 0 to signal that userspace wants
> > > to disable eager page split for a VM altogether. It is entirely possible that
> > > the user will want a differing QoS between slice-of-hardware and
> > > overcommitted VMs.
> >
> > Maybe.  It's also entirely possible that QoS is never factored in, e.g. if QoS
> > guarantees for all VMs on a system are better met by enabling eager splitting
> > across the board.
> >
> > There are other reasons to use module/kernel params beyond what Marc listed, e.g.
> > to let the user opt out even when something is on by default.  x86's TDP MMU has
> > benefited greatly from downstream users being able to do A/B performance testing
> > this way.  I suspect x86's eager_page_split knob was added largely for this
> > reason, e.g. to easily see how a specific workload is affected by eager splitting.
> > That seems like a reasonable fit on the ARM side as well.
>
> There's a rather important distinction here in that we'd allow userspace
> to select the page split cache size, which should be correctly sized for
> the backing memory source. Considering the break-before-make rules of
> the architecture, the only way eager split is performant on arm64 is by
> replacing a block entry with a fully populated table hierarchy in one
> operation.

I don't see how this can be true if we are able to tolerate splitting
2M pages. Splitting 2M pages inherently means 512 Break-Before-Make
operations per 1GiB region of guest physical memory.

If we had a cache size of 1 and were splitting a 1GiB region, we would
then need to do 512+1 BBM per 1GiB region. If we can tolerate 512 per
1GiB, why not 513?

It seems more like the 513 cache size is more to optimize splitting
1GiB pages. I agree it can turn those 513 int 1, but future versions
of the architecture also elide BBM requirements which is another way
to optimize 1GiB pages.


> AFAICT, you don't have this problem on x86, as the
> architecture generally permits a direct valid->valid transformation
> without an intermediate invalidation. Well, ignoring iTLB multihit :)
>
> So, the largest transformation we need to do right now is on a PUD w/
> PAGE_SIZE=4K, leading to 513 pages as proposed in the series. Exposing
> that configuration option in a module parameter is presumptive that all
> VMs on a host use the exact same memory configuration, which doesn't
> feel right to me.
>
> --
> Thanks,
> Oliver

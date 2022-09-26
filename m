Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB305EB5E3
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 01:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiIZXkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 19:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiIZXkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 19:40:13 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA2D5053D
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 16:40:11 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id c7so7894621pgt.11
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 16:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=CV/mbcKH4qX6MXHBANtxht73WgG6wuL82GOFfkKV6Oo=;
        b=cmO1i0bXpBONGQenXSWE8SHA6yaryyoYYkT4mkxsgUgf2jcvBRBzouBtr8+1SuVzDl
         ZY47sAAs3gvxgKC1x32NpztbrLAT2LfGnkJO40OM3nZ37b7ae8o1e28YV0bc0F1boL1N
         UqM3VvJv4OlPuyWDhqUqlNiZxKdqLbB0uMYUt8XEAkuMyOMfWCI4ppGRwbWK6lt0zAMq
         Rrkoly+Y38TnboaGdX0KA+yEioPFhtTfPQhVPRHzgUkHptSX/LAGjx5w0BzqQrZ6vvpu
         rlEyykxv5IaVtXCKdOynNY4KHOOE8mJzTOtYatR60tU+yvDqeZ1HBPokPqHlQPh13LpC
         imng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=CV/mbcKH4qX6MXHBANtxht73WgG6wuL82GOFfkKV6Oo=;
        b=mlAz1DEnPG/U4i0rwBA6c/mDhb9WaHeJb9LcASgGzVH5mxhi8JHaH4eObDuW3DeDD3
         fysTTDrx11TeF/Dfq6NxxkM6la5c6XtdyemJpNTiWEd3hpfkaw1dyBIe7nKjBf7T20Wz
         CLjMcC7YPGVViFQmqShtU9V8B4Sam6ugYqFHvUWzxd9vGPIHlQZLAlQf2VVX6eQ5WNqz
         VToSmI3Bf/L+JLcYJtPCsmqRjSkqIi9OZjE+JSXKeKR7xqu5vE8hkwvLtxYP+mflxpm4
         +90JcT5e0IGvRNjuWzRPgjwcbxltd1rSijTqK91jWylTZQJ229XTHMrX2mA07PxTUWmm
         4Q8A==
X-Gm-Message-State: ACrzQf38k2Z8rStQSFOXGzmqHuRNQtK93jI7N9CnWbqDw/INrKFw9Kqa
        UQ4iNn2WLHvsO7+n3/QhBg/7Gj/qg6hbkLWQr4e1VV49Wq4=
X-Google-Smtp-Source: AMsMyM5K4IdmzFXzkfAqdNpbKl06Dd2pgkXO6kCLJK4hGCT2BUNLtye6deOSLfkAlLcKX+PNq9ErzSN1ASvgTBzFENw=
X-Received: by 2002:a63:1a51:0:b0:43b:e496:f2f4 with SMTP id
 a17-20020a631a51000000b0043be496f2f4mr22554894pgm.99.1664235610798; Mon, 26
 Sep 2022 16:40:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220915000448.1674802-1-vannapurve@google.com>
 <20220915000448.1674802-5-vannapurve@google.com> <Yyt/xgPkHfbOE3vH@google.com>
 <CAGtprH-4nRyA81wock_OVwL-xA+LgNfqZFhJeE7T4iUyEscJKg@mail.gmail.com> <CALzav=fGpN0C1duR8ArnAUyko5bqytNS_V47eBa9JM89pehyAw@mail.gmail.com>
In-Reply-To: <CALzav=fGpN0C1duR8ArnAUyko5bqytNS_V47eBa9JM89pehyAw@mail.gmail.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Mon, 26 Sep 2022 16:40:00 -0700
Message-ID: <CAGtprH_qCyBRVDN3rh88hVX4w0UvvXM=6ScciA_KA7jvRQiBNQ@mail.gmail.com>
Subject: Re: [V2 PATCH 4/8] KVM: selftests: x86: Precompute the result for is_{intel,amd}_cpu()
To:     David Matlack <dmatlack@google.com>
Cc:     x86 <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, shuah <shuah@kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Sep 26, 2022 at 4:34 PM David Matlack <dmatlack@google.com> wrote:
>
> On Mon, Sep 26, 2022 at 4:27 PM Vishal Annapurve <vannapurve@google.com> wrote:
> >
> > On Wed, Sep 21, 2022 at 2:19 PM David Matlack <dmatlack@google.com> wrote:
> > > ...
> >
> > is_amd_cpu is used by guest code within fix_hypercall_test.c, just
> > caching the result will break the guest code execution. I have clubbed
> > these two changes together in order to ensure that is_amd_cpu works
> > fine for both host userspace and guest vm logic.
>
> Ah, so the sync_global_to_guest() part needs to go in the patch that
> adds caching to is_amd_cpu().
>
> But the point still stands that adding AMD support to kvm_hypercall()
> is a logically independent change.
>

I see what you mean. Will split this change into two in the next series.

> > ...
> > > > --
> > > > 2.37.2.789.g6183377224-goog
> > > >

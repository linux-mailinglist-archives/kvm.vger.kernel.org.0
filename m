Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596E67984F9
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 11:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241115AbjIHJpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 05:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjIHJpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 05:45:35 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069DF19A8
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 02:45:31 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-52683b68c2fso2551475a12.0
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 02:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694166329; x=1694771129; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xfuX/wtvWACG6RTooNCOtf7/3iq0sILbAKOhnwnHpbI=;
        b=VNw5as5XutkttoVcqb6cAMQ16kOYb+vOWc1zreD/RGob8QFTWVslmZOd/lQDdwc12W
         th5jGsnuceshnh5QSvWullNnPRQoIi4WCNEKPS0WH1f4JcRUlWMFMRfpxHRWWmcMFEJT
         8vWDS4myITnTAflxakBw6L55GGvYjJGnSHiBMWnqPoyuwPqVo52KQg+DL3h6hgibWxgF
         PLdlG4B21w8jxd2BBl0QFchNDOSWFZsjgmkbM8t4WI8ps+WqS9yuWXvIlU5u0OpGg61K
         wH3bgasokCF6duFnwLLn3d9v+qeeogKRewEtlzvpycgMqm7TE6YiqqBJBkPsJtNvwzt+
         qrPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694166329; x=1694771129;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xfuX/wtvWACG6RTooNCOtf7/3iq0sILbAKOhnwnHpbI=;
        b=QowpFPyP7bCfQ9RngqzYxEF9LEF+9goZ5Rh5bqbbyDchxO7jnT1TKbnN+qn/2chjpk
         /Oxz5MaGJSw3YhMKRXtNn7hUH/W2Haur/4g4u0DYqOeDHm5wrwZmQOHJRD4eQg4+OWvV
         5q3JUQ1TS6RQ05iTEt1IcQ5eGBaPX9AZ4q+iIOO72nq7eMQaxpVLAHUtUYG2I86aXdKF
         syX11PRXnhLWfga0e6qN+GZuZJnVQdOb5TYQb5Gtb8aYPs92fyrULoMBH+GlYxBGoaAx
         F5lMYXg/V2kSeyHKL7g6mSpBZFwpXtM8Tl0k1EZLS3kv81Hm0Jq29I9CZWbvSQPlyhMG
         RRNg==
X-Gm-Message-State: AOJu0Yy3nU5uNeIuDRF9gklv7n6qtjzUxA/gKOMsF+Y7V0SE7quNeJmq
        yiob51DxccVZiEc/HQEErJsYvfschLHa2ghOtU9MPw==
X-Google-Smtp-Source: AGHT+IFTzFGecBJEvO0UDNKNihi9f1Hf/rDRQMkqi6L3ByZkWRKhBL2nK+qFwLLs8yzZfX8EobuuCKedEHuxLQcaDsM=
X-Received: by 2002:a05:6402:2023:b0:523:aef9:3b7b with SMTP id
 ay3-20020a056402202300b00523aef93b7bmr1490001edb.4.1694166329551; Fri, 08 Sep
 2023 02:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230831190052.129045-1-coltonlewis@google.com> <7d3615d0-d501-a28c-eebc-b3f7a599fc23@tls.msk.ru>
In-Reply-To: <7d3615d0-d501-a28c-eebc-b3f7a599fc23@tls.msk.ru>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 8 Sep 2023 10:45:18 +0100
Message-ID: <CAFEAcA-9kGf2SDs9Yp5K-AgqV-41G9YQL6OVzfke6eHNBFt7CA@mail.gmail.com>
Subject: Re: [PATCH] arm64: Restore trapless ptimer access
To:     Michael Tokarev <mjt@tls.msk.ru>
Cc:     Colton Lewis <coltonlewis@google.com>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        qemu-trivial@nongnu.org, qemu-stable <qemu-stable@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 Sept 2023 at 20:31, Michael Tokarev <mjt@tls.msk.ru> wrote:
>
> 31.08.2023 22:00, Colton Lewis wrote:
> > Due to recent KVM changes, QEMU is setting a ptimer offset resulting
> > in unintended trap and emulate access and a consequent performance
> > hit. Filter out the PTIMER_CNT register to restore trapless ptimer
> > access.
> >
> > Quoting Andrew Jones:
> >
> > Simply reading the CNT register and writing back the same value is
> > enough to set an offset, since the timer will have certainly moved
> > past whatever value was read by the time it's written.  QEMU
> > frequently saves and restores all registers in the get-reg-list array,
> > unless they've been explicitly filtered out (with Linux commit
> > 680232a94c12, KVM_REG_ARM_PTIMER_CNT is now in the array). So, to
> > restore trapless ptimer accesses, we need a QEMU patch to filter out
> > the register.
> >
> > See
> > https://lore.kernel.org/kvmarm/gsntttsonus5.fsf@coltonlewis-kvm.c.googlers.com/T/#m0770023762a821db2a3f0dd0a7dc6aa54e0d0da9
> > for additional context.
> >
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> > ---
> >   target/arm/kvm64.c | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> > index 4d904a1d11..2dd46e0a99 100644
> > --- a/target/arm/kvm64.c
> > +++ b/target/arm/kvm64.c
> > @@ -672,6 +672,7 @@ typedef struct CPRegStateLevel {
> >    */
> >   static const CPRegStateLevel non_runtime_cpregs[] = {
> >       { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
> > +    { KVM_REG_ARM_PTIMER_CNT, KVM_PUT_FULL_STATE },
> >   };
> >
> >   int kvm_arm_cpreg_level(uint64_t regidx)
>
> While this patch itself is one-liner and trivial and all, I'd rather
> not apply this to the trivial-patches tree, - it requires a little
> bit more than trivial expertise in this area.
>
> So basically, ping for qemu-arm@ ? :)

It is on my to-review/apply queue, yes.

thanks
-- PMM

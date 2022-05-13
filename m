Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5579525964
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 03:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376349AbiEMB1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 21:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376345AbiEMB1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 21:27:44 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3A028ED02
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 18:27:42 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id p26so11978549lfh.10
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 18:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LIDguYIuVflswIxVe0rDovYuKNJYmCnkOY7D5EehnCk=;
        b=gnm6g4OcKDsmzm8kAbz/QbvXr2vv2GOGZxhV4LL0O8+7Re8GtoOzvW2DzMmvv1MQzh
         JhoNzlMNJOpN1O3ls1KHXJY7844raEnnQuvmDFthG7PL3zI2cZLqRsfN4V5rcM1PuP5a
         GgXbZCCHOJPe8mz+TFwDPNx/rFIRa+eHYy82fRqrIJXyS9FO6uXkIS8s6Ha1EN6T4seK
         l+m1hldQf9OaOOeuF4zfxvcCsCcxZEBaeLmYIJUUpauEPzVgnu5wGH+JwEa3M7u/CuVi
         a4w6cJwYMc62f8t3Uca5/XHEmWLuYVD/RjZQ76WtJYaXPEJ28Rgt26Z7Bw0MnnkzMkH2
         kNZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LIDguYIuVflswIxVe0rDovYuKNJYmCnkOY7D5EehnCk=;
        b=I5z+cu4A0FSGf5BK6STSun3vdu5ytGB8HjVISOK7yzBmDhAcdvpjD4ZPMOBG2enwNc
         eL65Bev+q1KW+G0Li5+Zb9RJcOVyesEfB1oKBf1+2ONlnRA6y8U4jreOk2tu0KTdxjEt
         32X/fWpZ74UHiV6PPQWbFYpb3s/Y5SezYj5o/mO/wIMp0NLvpgeoS7umJDGrGMUNcy5V
         HFEUMg6rGh37yiT5SpMp7U69s5itLCmzZQw5hbjB4xQQtNzjvSXrP4P7HhX1a9Y8zTWM
         p3aU3bx3BQdLB0l1f1g3fhYrBt+wds3Dgk44PhQ3ofivVyh1POBP8tRJB8B170+LW1ku
         WbUA==
X-Gm-Message-State: AOAM530VljWeV1+C+J8oolDiGPdKq+A0xbi3atkTwp2GGyRLRlWYuRbP
        wZbc/rNHFK5uKGh2CZva4hOHYHSVjXG8kcCNLPgPiyS3bzb/Jg==
X-Google-Smtp-Source: ABdhPJyPBWIRQWK2hyN/qACME3hpMhHZpawclOQjdye3yBE/1tV05KQBRCZhkz4WWtlUDCxUL4PEZhFbXOAESFEH1B0=
X-Received: by 2002:a05:6512:509:b0:472:16bb:1c08 with SMTP id
 o9-20020a056512050900b0047216bb1c08mr1689403lfb.584.1652405260781; Thu, 12
 May 2022 18:27:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220512204459.2692060-1-cross@oxidecomputer.com>
 <Yn2ErGvi4XKJuQjI@google.com> <CAA9fzEGdi0k8bkyXQwvt6gFd-gwHNNFF7A89U4DhtGHjKqe4AQ@mail.gmail.com>
In-Reply-To: <CAA9fzEGdi0k8bkyXQwvt6gFd-gwHNNFF7A89U4DhtGHjKqe4AQ@mail.gmail.com>
From:   Dan Cross <cross@oxidecomputer.com>
Date:   Thu, 12 May 2022 21:27:29 -0400
Message-ID: <CAA9fzEGrH3hem6wZA8GiS9VOmkG7do6ei19jSYGnX0xxrkigKQ@mail.gmail.com>
Subject: Fwd: [PATCH] kvm-unit-tests: Build changes for illumos.
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Sean, sorry for the dup; I forgot to switch to plaintext mode]

On Thu, May 12, 2022 at 6:05 PM Sean Christopherson <seanjc@google.com> wrote:
> On Thu, May 12, 2022, Dan Cross wrote:
> > We have begun using kvm-unit-tests to test Bhyve under
> > illumos.  We started by cross-compiling the tests on Linux
> > and transfering the binary artifacts to illumos machines,
> > but it proved more convenient to build them directly on
> > illumos.
> >
> > This change modifies the build infrastructure to allow
> > building on illumos; I have also tested it on Linux.  The
> > required changes were pretty minimal: the most invasive
> > was switching from using the C compiler as a linker driver
> > to simply invoking the linker directly in two places.
> > This allows us to easily use gold instead of the Solaris
> > linker.
>
> Can you please split this into two patches?  One for the $(CC) => $(LD) change,
> and one for the getopt thing.  The switch to $(LD) in particular could be valuable
> irrespective of using a non-Linux OS.

Done.

> [snip]
>
> > +# require enhanced getopt everywhere except illumos
> >  getopt -T > /dev/null
> > -if [ $? -ne 4 ]; then
> > +if [ $? -ne 4 ] && [ "$os" != "SunOS" ]; then
>
> Presumably whatever "enhanced" features are being used are supported by illumos,
> so rather than check the OS, why not improve the probing?

Actually, it looks like I've got some egg on my face here. It appears
that `getopt`
is not used in `configure` beyond this check; presumably this exists
to avoid surprises
when running `run_tests.sh`, which does use extended getopt (for long
options) and
repeats this same test. I had not noticed since `configure` ran
successfully, and we are
not presently using `run_tests.sh` on illumos as we use a rather
different VMM than
qemu. That patch should probably be dropped (or changed to remove the
getopt check
in `configure` entirely, if folks are fine deferring needing to have
it to the invocation of
`run_tests.sh`...). Or I just convince folks to provide a GNU getopt
package on illumos.
Let me know what is preferred.

        - Dan C.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E590A53AAB5
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 18:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354560AbiFAQI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 12:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349714AbiFAQI0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 12:08:26 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A5353701
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 09:08:24 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id v15so2294650pgk.11
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 09:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3m41qQszlJy+6huC2ZWNrXqyv86XkYWKUUXx90k39RU=;
        b=aVt2F3Z5W4wUKsppS8k/UKeq8jgaAtVZLMoT0jbucWhB2X/VUSz+ByWAs6NDn+kzgm
         R/dlvt378yWxLAoRS0G1sYKS+eXDXkl30PR3oTulgHz0i4d7l+XLFAF4GcZ4B6PWX+2x
         IiNfUCXA+9c+5wwlqQK69qbsuf3Ns7lX8lS1CYIgDO1p2rtZvq9ZmI7cAbQTIbR5FUVS
         zc2GfH2IMCdCBgNaY/y2bgVVzwdM7TkQYi96eFCVqvF4pGnomFiRsf5MtCkFEKG4Ta36
         Dx7zg3M3W6cN1YSytcfNjSY4u9PTh/iVal7t91smHBPHc1gkevdodw47asiqkECWzBlj
         KyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3m41qQszlJy+6huC2ZWNrXqyv86XkYWKUUXx90k39RU=;
        b=f6aMbP3vHnz47yDQNaa0KAu/mVPpGwLjwPWxWHhYcjn3Pna67oXay65sfZLMbiHcsG
         x9Kc4H5o+ui2LUyysAfBGjfGKwtbBXrCm89XNCKvVSAI+i/Lq55apnhb6Ob9e85XqEbq
         cPssn8XUZpUKtMlQpjI5x67Rgym+FEh/DbxocEBqIqPPSdypd7kbqjR0oedluy6dp9nd
         RR2KMEUPIkzH1xG1G6N6i4tcK/AUYaUD+uIYRqHtgVGww83u4GjS66Z1dbm5b50f1Y+4
         4DRf9PxFc9gQwEPoCBCgqhRfgmfDi45S/EW2A87xzUX9aJRru2ub/hsu4bGNbcnG1AD5
         /OdA==
X-Gm-Message-State: AOAM531oty7YJX9yYZCh4KoYNRgQY+tOf7OP+w+KuqA0rdPe6Eli5SpO
        ezuiEHEkmUSYHpDoMb3wjxDC0crImYLhhct8dmqJ/dCmoQ==
X-Google-Smtp-Source: ABdhPJzbU8gBaZ/bpxCejzqg/d7eF7PvDLE4U8BX3j1teWxG/HGOt23xqH8aQLZ+iQTYdyOXtjzfihcSUANPSbfRoXk=
X-Received: by 2002:a05:6a00:1683:b0:4f7:e497:6a55 with SMTP id
 k3-20020a056a00168300b004f7e4976a55mr278008pfc.21.1654099703372; Wed, 01 Jun
 2022 09:08:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QXUfFksVLF=gzU3EYkyf7RQKvr5_FU6Ea5enf39vinY3A@mail.gmail.com>
 <CALMp9eQNmxscE1iMCV=ibF9zQ5E+CYGbfjV6vYtL-ddOECrDXw@mail.gmail.com>
In-Reply-To: <CALMp9eQNmxscE1iMCV=ibF9zQ5E+CYGbfjV6vYtL-ddOECrDXw@mail.gmail.com>
From:   Bill Wendling <morbo@google.com>
Date:   Wed, 1 Jun 2022 09:08:11 -0700
Message-ID: <CAGG=3QUs2KvDiwRvQZf7zUFWsFybn7mJFd7Ky2SHfiswN1oY_w@mail.gmail.com>
Subject: Re: [kvm-unit-tests RFC] Inlining in PMU Test
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 31, 2022 at 4:00 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Thu, May 26, 2022 at 6:32 PM Bill Wendling <morbo@google.com> wrote:
> >
> > I'm into an issue when I compile kvm-unit-tests with a new-ish Clang
> > version. It results in a failure similar to this:
> >
> > Serial contents after VMM exited:
> > SeaBIOS (version 1.8.2-20160510_123855-google)
> > Total RAM Size = 0x0000000100000000 = 4096 MiB
> > CPU Mhz=2000
> > CPUs found: 1     Max CPUs supported: 1
> > Booting from ROM...
> > enabling apic
> > paging enabled
> > cr0 = 80010011
> > cr3 = bfefc000
> > cr4 = 20
> > PMU version:         4
> > GP counters:         3
> > GP counter width:    48
> > Mask length:         7
> > Fixed counters:      3
> > Fixed counter width: 48
> >  ---8<---
> > PASS: all counters
> > FAIL: overflow: cntr-0
> > PASS: overflow: status-0
> > PASS: overflow: status clear-0
> > PASS: overflow: irq-0
> > FAIL: overflow: cntr-1
> > PASS: overflow: status-1
> > PASS: overflow: status clear-1
> > PASS: overflow: irq-1
> > FAIL: overflow: cntr-2
> > PASS: overflow: status-2
> > PASS: overflow: status clear-2
> > PASS: overflow: irq-2
> > FAIL: overflow: cntr-3
> > PASS: overflow: status-3
> > PASS: overflow: status clear-3
> > PASS: overflow: irq-3
> >  ---8<---
> >
> > It turns out that newer Clangs are much more aggressive at inlining
> > than GCC. I could replicate this failure with GCC with the patch
> > below[1] (the patch probably isn't minimal). If I add the "noinline"
> > attribute "measure()" in the patch below, the test passes.
> >
> > Is there a subtle assumption being made by the test that breaks with
> > aggressive inlining? If so, is adding the "noinline" attribute to
> > "measure()" the correct fix, or should the test be made more robust?
>
> It's not all that subtle. :-)
>
> The test assumes that every invocation of measure() will retire the
> same number of instructions over the part of measure() where a PMC is
> programmed to count instructions retired.
>
> To set up PMC overflow, check_counter_overflow() first records the
> number of instructions retired in an invocation of measure(). That
> value is stored in 'count.' Then, it initializes a PMC to (1 - count),
> and it invokes measure() again. It expects that 'count' instructions
> will have been retired, and the PMC will now have the value '1.'
>
> If the first measure() and the second measure() are different code
> sequences, this doesn't work.
>
> Adding 'noinline' to measure() is probably the right thing to do.

Woo! Thanks. :-)

-bw

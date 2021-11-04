Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5013D444E15
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 06:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhKDFLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 01:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhKDFL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 01:11:28 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A041C06127A
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 22:08:50 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id j2so9648868lfg.3
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 22:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XxdPZiyinPG7MlZzTO5z3FchXW3VIiom1r+0e1Hhn+s=;
        b=SUO4wh1HcqWW+xqaRGpDo8A7XV/aKyRiM8kvkNEGhUcMWI5xD89gZZLkVzFLhPZ6NE
         7m3B+69ft35d+vs3oHcz5dJR2Pv97lDXNNJcopYCEg43QE1RadAl5vYeEnP5IVzDKk7x
         dF/z+RdrTIOqRxXl9xg24n43CJdqXtEhu2F2I5VuBBa77Vu9sqfuq64IJ5RZPrgzLSiz
         RFxQf43YMstbz7dg9aPHU+NuOJou17uelIP5KGURPrS0qDov7fFmLOm8fPRcoHeSmpWA
         8TLbWjrI9RtuRjTONn2Ba4CEuNxoW0YaVCRuW8+t12VEtjsU1monj7AZmQVXHcshtUsw
         5LVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XxdPZiyinPG7MlZzTO5z3FchXW3VIiom1r+0e1Hhn+s=;
        b=VMD2Odg673RMY4+5i6/qr0bf63QmyZrummvzxs77FgIvYH/Xxwo+5u1e9Q/w4stq1i
         JqFf+CB7A2/TGpmJ01Xv70J6pnY8JFyStjknopVO8LqVUFbfpnh3BNeZ3mgYlLCutbS/
         uifliphH6wpzLspeG36N0V8iUv/rNDYRjuCXmMnqqYDstbAT33yZSTKInSDh/lpNrEIM
         WyvtHeWbkb0ujg2iZ7HUpmxSlGfKcKa9nncyosUFHX1R6QMVFYgf2HRJU+2YGvoOHjak
         80imIH5LmWVVansGC6rPKSASVtQSoITV6nnvaq4XOvOb+2iCKMax3fyg1+uubnrYRGVa
         VGRQ==
X-Gm-Message-State: AOAM533h3PeYKWnaYnNCqqgZRvyLRY4HF6+w4jByoDk0tLiRVFow7a0E
        El/7HBtW5yW8GzkW0Ixm5LGNYkd6IQQtD7AXv04caQ==
X-Google-Smtp-Source: ABdhPJyXMhwa/xIatcMBAgPZWhXg9NkqpxiNsPA5crz18Ywm+fpduZK9aUeITXX7tRWPzboqRpzMcrfJErtvD0ZZybQ=
X-Received: by 2002:a05:6512:2288:: with SMTP id f8mr46437638lfu.368.1636002528485;
 Wed, 03 Nov 2021 22:08:48 -0700 (PDT)
MIME-Version: 1.0
References: <20211103205911.1253463-1-vipinsh@google.com> <YYMWSvDlYZ26D4yU@google.com>
In-Reply-To: <YYMWSvDlYZ26D4yU@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 3 Nov 2021 22:08:12 -0700
Message-ID: <CAHVum0fysMwnWG9SP2O8QAMPPORjvCXWYM6+BGDYhiBoPUUeYw@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Add wrapper to read GPR of INVPCID, INVVPID, and INVEPT
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 3, 2021 at 4:08 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Nov 03, 2021, Vipin Sharma wrote:
> > Hello,
> >
> > v3 is similar to v2 except that the commit message of "PATCH v3 2/2" is now
> > clearer and detailed.
>
> Heh, please wait at _minimum_ one day before spinning a new version.  I know it's
> a bit weird/silly for such a small series, but even in this case I replied to the
> previous version because I circled back to the "series" while waiting for a build
> to complete.  For small series and/or single patches, unless there's a reason for
> urgency, it's polite to wait a few days between versions to give folks a reasonable
> chance to weigh in before getting hit with a new version.

I am sorry about this. I will keep this in mind for any future work.
Thanks for the advice, I appreciate it.

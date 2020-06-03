Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07EA1ED87F
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 00:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgFCWSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 18:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgFCWSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 18:18:18 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1152BC08C5C1
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 15:18:18 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id c17so4754169lji.11
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 15:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xgGugU/qZe89+gnbp+elpA+XCgk1PYAAGN28MPGcHz0=;
        b=MVmmI7ix4V8oho44hahkegOWPRfUVyUUkybcOxtxGA2m1t2HeY9FGNqyy7EikWYv+2
         qanLD+tjEKv8FTonAzfz6Ft80BoAp0v95PUrfHTPvHdDk2LPAp1Ol8OwmHlFA0tw6wck
         gzZoZAzg/XMjnhNCsRrTro/QpUoORyeMuk8qE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xgGugU/qZe89+gnbp+elpA+XCgk1PYAAGN28MPGcHz0=;
        b=qr99l2p927QSNsPwY5BgrO1o2GxRWEVeRxFBnGuAX/ROkCbrdGJaEq/8UTD0fk20Dm
         aSpmO0qqJpvgavoTl+WpJlj+EmgXUhZDRT2HIN2DZhdV86NTmsUbf6ejDuZBd70EQntz
         M4pv/92+bI5nD1VGB/1TN0YZvt/6hzDpEUqrvXxbZdO+lVTW7jP4VG204KG69p7YwD/e
         VBQq0BGL87ojqp3+GngT8XWcyB0UZ/gZpDXEiiWeYsMyIPV/sl+ZKKidLaqRfjRGT3rm
         ARnekWmDY8S7Y4vASMk7LJZ2B8IEqWhXubSnYYYHRZpcxQdxf0rNmWw02BGn2+lBRQrz
         i5iA==
X-Gm-Message-State: AOAM531dEunZwMY/lk6ts+jRwRAKhfCEqNhMamOmhuccss7f/g1hdOt2
        bHt+NvIXQ/1h4gPEdLFkMe/KrK13+1o=
X-Google-Smtp-Source: ABdhPJxzYMJJR1GbZpnAibeQiP+4NW9zLbfKKIk9x1+7NBiMsbyNix8GdGTIyktCwhKcIQmSmh3VAQ==
X-Received: by 2002:a2e:960b:: with SMTP id v11mr645611ljh.77.1591222695826;
        Wed, 03 Jun 2020 15:18:15 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id v2sm803717ljj.96.2020.06.03.15.18.14
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 15:18:14 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id c11so4804047ljn.2
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 15:18:14 -0700 (PDT)
X-Received: by 2002:a2e:b5d7:: with SMTP id g23mr601781ljn.70.1591222694044;
 Wed, 03 Jun 2020 15:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200603173857.1345-1-pbonzini@redhat.com>
In-Reply-To: <20200603173857.1345-1-pbonzini@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 3 Jun 2020 15:17:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjC21siUGvy9zpVOHfLRe4rwiT-ntqqj3zN73qtveKjpQ@mail.gmail.com>
Message-ID: <CAHk-=wjC21siUGvy9zpVOHfLRe4rwiT-ntqqj3zN73qtveKjpQ@mail.gmail.com>
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 5.8
To:     Paolo Bonzini <pbonzini@redhat.com>, Wei Liu <wei.liu@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 3, 2020 at 10:39 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> There could be minor conflicts depending on the order you're processing 5.8
> pull requests.

It would have been good if you had actually pointed to the reports
from linux-next.

As it was, the hyper-v pull request did do that (thanks Wei Liu), so I
could verify my merge against what had been reported and this didn't
take me by surprise, but it would have good to see that kind of detail
from the kvm pull too..

             Linus

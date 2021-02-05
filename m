Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6192310F93
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 19:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbhBEQ1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 11:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbhBEQZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 11:25:34 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C486C06178C
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 10:07:15 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id f1so11169755lfu.3
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 10:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9T498taodTGcCME+4kEpXQ8GfyFgHTEmTtWV4SGhP7E=;
        b=hkV6nHOMDRQRlIePJMWcKyuKlTTTB/EoykUOQZkZ4Z/sOmU4163tSd/QeBxyNz82pr
         cMfp0zaBK+mUb1sCwT6V2GQqvYGI0uqKS1DRVL29EuBN62YHbNG7/nfeieuQ4jjBI/rG
         0Oik3d7ONM/cDYdkscWp6gLmaPTE0duzFPa3k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9T498taodTGcCME+4kEpXQ8GfyFgHTEmTtWV4SGhP7E=;
        b=lL2rB3xidfMExQzP4X3kHe7XgwiE9HUTDAvrhqjkHDXnubcay+4u8WZ/yJ2Dii+RsV
         t6nmA2aDUn8cFenNntUKPI7xT/OwCpTczy0SLwijdD7ycYLVavKeELIniMGWBRhoyHBv
         yObAP62DR6eLQ+9fdPa/aoU4adr5v9ZkWu78ouiRJ/sSwwTOatm4NMcakq1okqRsyKcv
         Etr5tAjM8xH3Ibh7RHa1KoBoWVIljJN6J+QiW6BKdq7EY5qd1d7mPCD2gcQ2heu9mxzy
         33kFZmOJM35JFTPLDEjAS5c32/MQUj4ucrWdc4ASgQ+7rHNRTb+n5CG4XyR4lsa5g0ht
         cM2w==
X-Gm-Message-State: AOAM531ShML3JSDtfIj95uvkkYgXdOxUJ+57DQpStJLujPr/sH1I9rJv
        ddy9hgL7wM0X+bFdYlti2LFAlb+pfFrFxg==
X-Google-Smtp-Source: ABdhPJwF6a568Pets80ydNQ8853nJA9NypK1D1pTX3aiF7BddxlthU3f/tiLLJA3x+WbTSv/3EbriQ==
X-Received: by 2002:a05:6512:4c9:: with SMTP id w9mr3026298lfq.437.1612548433709;
        Fri, 05 Feb 2021 10:07:13 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id e28sm1060300lfn.112.2021.02.05.10.07.12
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 10:07:12 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id l12so8840343ljc.3
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 10:07:12 -0800 (PST)
X-Received: by 2002:a2e:850d:: with SMTP id j13mr3383636lji.507.1612548431551;
 Fri, 05 Feb 2021 10:07:11 -0800 (PST)
MIME-Version: 1.0
References: <20210205080456.30446-1-pbonzini@redhat.com> <YB2HykY8laADI+Qm@google.com>
In-Reply-To: <YB2HykY8laADI+Qm@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 5 Feb 2021 10:06:55 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiA_QoHP6rxK+tSWM3c_N8dGzAPohhdESyL=M7uLuKR0g@mail.gmail.com>
Message-ID: <CAHk-=wiA_QoHP6rxK+tSWM3c_N8dGzAPohhdESyL=M7uLuKR0g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fixes for 5.11-rc7
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Jonny Barker <jonny@jonnybarker.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 5, 2021 at 10:00 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Ah, shoot.  Too late now, but this should have been attributed to Jonny, I was
> just shepherding the official patch along and forgot to make Jonny the author.

I put a note in the merge message, fwiw..

         Linus

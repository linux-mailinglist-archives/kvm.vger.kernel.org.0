Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD351E9358
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 21:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbgE3TVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 15:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729290AbgE3TVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 May 2020 15:21:14 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6557CC08C5CA
        for <kvm@vger.kernel.org>; Sat, 30 May 2020 12:21:14 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id x27so1636355lfg.9
        for <kvm@vger.kernel.org>; Sat, 30 May 2020 12:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6NkuvZ5wxpI0d7nxM1p2cSrZBIeJuPPcRbcbjWmyFH8=;
        b=L2gQT40oxwSdo4IdQediVzzXaQ9+LxXAgiK+MMr6jElRXz3IKpxvX2gNiIHXz8954v
         HtaR/MNXCphqAEFosDyOPCVSqQ3rs19dQLOuWT74IQyI0O7DyzRaJ/4J+KBp/TRoPDSz
         g1kWwuqmvYPoA233IXW/7crOLzFd3q6p7ha5U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6NkuvZ5wxpI0d7nxM1p2cSrZBIeJuPPcRbcbjWmyFH8=;
        b=R2UIED0XSaQkMb3zf0i3GxaQ5Z3RvHXNjtjQ0l/V5DqQSGznUW8fd3pYYJheCD1xbQ
         XeG93ES4c22z8D1wDVzAfzPxS8s7hXWAyfFsFkFGCUSKhpvufE2ANSYyZYAxzYs6NLar
         5H8JfHxjduI6aemzPi8b4gRE2zEinmetIjS7ZDpHvXkWHrer3es8P9V9EUeDffQ3sSMj
         NL9FZlEHhrvJGl9PhwIYTYhap+zlreJS0KsLr5/U5wLw6tElbcDCZRziIQK1sFnqNXj/
         wb7dLVaGMUUSEnQgEdPWjpzoRqL44kyiucdtePESWs1XY5MPTC3d0cOgVhTyJSIv8BWh
         SlpA==
X-Gm-Message-State: AOAM5311UiW2O33885aQkFs2REsHJZkGwT2ngWUIs3RmaolThESnpwgi
        dLJYpm1oMwZNZRzpsIVMoLAIsVC6pic=
X-Google-Smtp-Source: ABdhPJyvufvkvRLW7kT6eSx2+tb7xcSzXOlfDsG9lXXb4lKPwACXkPi66Y8WwCn2zqBsdgr5JpKDtA==
X-Received: by 2002:a19:b06:: with SMTP id 6mr7422109lfl.104.1590866472096;
        Sat, 30 May 2020 12:21:12 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id h2sm3194731ljb.45.2020.05.30.12.21.11
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 12:21:11 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id 202so1642731lfe.5
        for <kvm@vger.kernel.org>; Sat, 30 May 2020 12:21:11 -0700 (PDT)
X-Received: by 2002:a19:6a0e:: with SMTP id u14mr7258369lfu.192.1590866470633;
 Sat, 30 May 2020 12:21:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200528234025.GT23230@ZenIV.linux.org.uk> <20200529232723.44942-1-viro@ZenIV.linux.org.uk>
 <20200529232723.44942-8-viro@ZenIV.linux.org.uk> <CAHk-=wgq2dzOdN4_=eY-XwxmcgyBM_esnPtXCvz1zStZKjiHKA@mail.gmail.com>
 <20200530143147.GN23230@ZenIV.linux.org.uk> <81563af6-6ea2-3e21-fe53-9955910e303a@redhat.com>
 <CAHk-=wiW=cKaMyBKgZMOOJQbpAyeRrz--o2H_7CdDpbn+az9vQ@mail.gmail.com>
 <20200530183853.GQ23230@ZenIV.linux.org.uk> <CAHk-=wjmCBXj0==no0f9Og6NZuAVWPEFXUgRL+fRmJ8PovbdPQ@mail.gmail.com>
 <20200530191424.GR23230@ZenIV.linux.org.uk>
In-Reply-To: <20200530191424.GR23230@ZenIV.linux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 30 May 2020 12:20:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg03AwbLH0zLRbOOQR_cZD89dM0KMU-uLMkG2sG9K_yag@mail.gmail.com>
Message-ID: <CAHk-=wg03AwbLH0zLRbOOQR_cZD89dM0KMU-uLMkG2sG9K_yag@mail.gmail.com>
Subject: Re: [PATCH 8/9] x86: kvm_hv_set_msr(): use __put_user() instead of
 32bit __clear_user()
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 30, 2020 at 12:14 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> > And none of that code verifies that the end result is a user address.
>
> kvm_is_error_hva() is
>         return addr >= PAGE_OFFSET;

Ahh, that's what I missed. It won't work on other architectures, but
within x86 it's fine.

                  Linus

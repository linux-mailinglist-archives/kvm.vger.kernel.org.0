Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAA0226FC1
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 22:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbgGTUdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 16:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgGTUdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 16:33:49 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12385C061794
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 13:33:49 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f5so21662525ljj.10
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 13:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vDmn1h2o2KlEqHHKhXBH9l8ZWcNt0/FAMYjurOyZeZg=;
        b=J4l0ZcnzbDcy4NJWIveg9d5dEt9neEhl18sUfvBpqY56FlAQL21UjlJxwmbxNx+nh5
         KR/TupZ9ygiCPROrZC35vFmtuQ5+WKGjNk9FwuChIo2oD1dzhTyBKJLyBBWSAge2LEwR
         ua9AsxJMZaL58Rq4qor3I5Vc+zo/LVQGM675Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vDmn1h2o2KlEqHHKhXBH9l8ZWcNt0/FAMYjurOyZeZg=;
        b=abs5rCVFjtkZKHWtjzTsn3mWpQGzhI60T0xK/OOBA2IY/tFgpZzh1zcoP3xYvYjJSN
         2fvA1+Pbn33dY6i/1KkZhDLyzBWpQ0AXvTdq3XeR1PBY6u7DW2kAezs51iZbIdBNhLfl
         hJyRCH1+dQmVAEHA1CN74GviGrpPbvS3z9HFxVG5TjVOZ5lgykWUwAFmWt5V6Jxex6mW
         3xGF4zcaT/MrM+0ApBPqUbJeLUBK9UbY7ZUVevDfp/frpyLbJ52HFMP59fsjS0T4zMYk
         R6JIJPgfe4jPIembT6UKVodQxXDkEKs88ZRd8Rzf7R0s0lWRQgqcxC6zqOvrOK/U5b0R
         3lig==
X-Gm-Message-State: AOAM531fX/Ncesb5hGrcTLTjXf5H5c++Is8JGTu2VESekwixmxnmeKnO
        A4H8+9sL3rjk12GL97UbopGwu+jliWo=
X-Google-Smtp-Source: ABdhPJxH2Y4e4URiHZi7Y1+qfH/d6tEgn021/vxyHk37E++CkG7QKE3tHq6SW9k4QtvOYN8+PgwBhA==
X-Received: by 2002:a05:651c:21a:: with SMTP id y26mr10719823ljn.106.1595277227248;
        Mon, 20 Jul 2020 13:33:47 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id h26sm3428004ljb.78.2020.07.20.13.33.46
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 13:33:46 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id 140so50434lfi.5
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 13:33:46 -0700 (PDT)
X-Received: by 2002:ac2:522b:: with SMTP id i11mr276989lfl.30.1595277226113;
 Mon, 20 Jul 2020 13:33:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200720083427.50202e82@x1.home>
In-Reply-To: <20200720083427.50202e82@x1.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 20 Jul 2020 13:33:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wijGPPiUH8-kzu2ZyP9_SgBxbGib7afOMAwpusfx-2K+g@mail.gmail.com>
Message-ID: <CAHk-=wijGPPiUH8-kzu2ZyP9_SgBxbGib7afOMAwpusfx-2K+g@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO fix for v5.8-rc7
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 20, 2020 at 7:34 AM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> VFIO fixes for v5.8-rc7
>
>  - Fix race with eventfd ctx cleared outside of mutex (Zeng Tao)

Why does this take and then re-take the lock immediately? That just
looks insane.

I realize that this isn't likely to be a performance-critical path,
but this is a basic source cleanliness issue. Doing silly things is
silly, and shouldn't be done, even if they don't matter.

              Linus

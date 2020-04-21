Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05091B3077
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 21:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgDUTgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 15:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgDUTgC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 15:36:02 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43596C0610D6
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 12:36:02 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f18so9232682lja.13
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 12:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=soISMDc5vWhNYzK+GwCUX1p3xFLbvdhV8HpKz6VNPro=;
        b=cWm26Mw32WNe1HlZTZP1780+TbW6oTXKHG8/Jk3ZsVNovz7AVAIUeJ7MlbzoLXHWC1
         YavoHy/0AyrgjNdVf1YNA0w0DId/VE3w8ic/s/3ZmNo/liIm2sWDUAEsH4g197A8jpoQ
         QPWMFJ1Qd+bipFsUJFsbEyTMK2eZKmQWkX6u8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=soISMDc5vWhNYzK+GwCUX1p3xFLbvdhV8HpKz6VNPro=;
        b=QYvTPf9sirFBEzXb/rLo1II2iSm39ZalFWzMKgOlvZfyIVV7jhGnM/5YaFMEMicQRY
         9cv/izQoosdTLr4ahiOYTyAQYgXS/XD0xQigVC5tE3DkA+z00qwU/qikswG7cCKjshsW
         jOM9ZgycU2wIf1rUm5F9e6kpHYKsBjsvoKAcQ/Uk4dmbmhr+NwlHMCK/PKeApi/v7lUM
         kUFQqsrBCBsSUARS9AJ9i4Eqcoht3EM2Q8bAszWByG83Aa8cTdRdxaS+dNCsGxfAGj00
         4flp72K2hNrU/4DuqHATmqrnUfh6QKKpNSAahTD21krDCpFEeX1XZ6BOYL5LO9XwkiAi
         OVDA==
X-Gm-Message-State: AGi0PuZHX6xr2/bqh615i0HTUtwEH2lDHWbREY9/qVzr04x5oRPgnQRx
        hRkxpZvI5NBsNoHXPViJCfxhYTRlg3k=
X-Google-Smtp-Source: APiQypInz6O7Q4IOF9JIZLhxWnkITZ/FXlUQxpyP4R/TFWmPjM6FTDk/OLzHIYysAuetnsSYO58atA==
X-Received: by 2002:a2e:9490:: with SMTP id c16mr7247046ljh.110.1587497760187;
        Tue, 21 Apr 2020 12:36:00 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id r206sm2765891lff.65.2020.04.21.12.35.58
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 12:35:59 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id u6so15275381ljl.6
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 12:35:58 -0700 (PDT)
X-Received: by 2002:a05:651c:319:: with SMTP id a25mr2085741ljp.209.1587497758653;
 Tue, 21 Apr 2020 12:35:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200421160651.19274-1-pbonzini@redhat.com>
In-Reply-To: <20200421160651.19274-1-pbonzini@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 21 Apr 2020 12:35:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=whVo7CzzjEYp+G7+MjNSg4cURR4SeUTvQSYVBFn3o5TPw@mail.gmail.com>
Message-ID: <CAHk-=whVo7CzzjEYp+G7+MjNSg4cURR4SeUTvQSYVBFn3o5TPw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 5.7-rc3
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 21, 2020 at 9:07 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
>
> for you to fetch changes up to 00a6a5ef39e7db3648b35c86361058854db84c83:

Did you perhaps forget to force-update that tag?

That tree still shows the tag from April 7 (that I merged in commit
0339eb95403f).

                     Linus

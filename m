Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D09B21CA5
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 19:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbfEQRkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 13:40:16 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:45240 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfEQRkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 13:40:16 -0400
Received: by mail-lj1-f177.google.com with SMTP id r76so6976089lja.12
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 10:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=47UMyUJ+CBYPd1QpBMevlO6cvjKR6YwFCa/M8mKYz3o=;
        b=FBIXKm9hakIxDw4DTZlObC695gPR+rkW9asB4sOkO6J3LDvqrKyN7XuepIETwrTJCv
         ZGawi2ZDJVjQg2C2GJCQRfrfY7D+xe0IV0uS4qtTo25UFA2fZroV6zVfxQ/266OBybNE
         xEztCgDlBKLuYs7p74e+KFnHSnd+ZMi/pm2Zc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=47UMyUJ+CBYPd1QpBMevlO6cvjKR6YwFCa/M8mKYz3o=;
        b=MMMx3xZW4BO4Fo3VvytfkU9QawPKkr/UQangYsLc2rfzzzcD6Bl5sCyIfPn4zUI561
         5t1SunyWpIMhD4sa9UEpNXZcUJffeobslCdtzHRW7LrtdpsSlPEPVk6yXdcenPw30QES
         AxMf6Yq+/cRzC6dAjLF2K5ajWtMd+HLBKLMClzNuJI7029Jyo3iUYBdf4cCPvGP1GgmJ
         +KwsUc9BbRhi+4d1D38RUXrJfOVHngX1L3h/eSsg0Aa7LjNZK2n6gRlDzEzZaCcyxnPC
         Yh8B2YSeFFEhBdenTIWdH4uSewG5lraSI/ZW36k0skiwpR/k+fYIQhA5ywLL6iaJo8ia
         vp0Q==
X-Gm-Message-State: APjAAAW0/hUIF9O/KXhl9/syiX1qyoE5zNGhnfk0K1TUDYdy74+uBMlM
        TimszVYaNYGUeQ6N2b1I7WMqo8mL1g8=
X-Google-Smtp-Source: APXvYqwD5JTdNxbfg7WYZas/3KaGrYlNQnmuSrU/m3dSi9uOAGejjUJsMl96eFXhisFPiEQ8pXOyog==
X-Received: by 2002:a2e:9e18:: with SMTP id e24mr30897345ljk.151.1558114813847;
        Fri, 17 May 2019 10:40:13 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id i12sm1552300lfo.67.2019.05.17.10.40.12
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 10:40:13 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id n134so5877568lfn.11
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 10:40:12 -0700 (PDT)
X-Received: by 2002:a19:f501:: with SMTP id j1mr8047212lfb.156.1558114812565;
 Fri, 17 May 2019 10:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <1558065576-21115-1-git-send-email-pbonzini@redhat.com>
 <20190517062214.GA127599@archlinux-epyc> <a8170dab-7c7d-de3d-9461-9eecb73026ff@redhat.com>
In-Reply-To: <a8170dab-7c7d-de3d-9461-9eecb73026ff@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 17 May 2019 10:39:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg1DYeY9WHP7cf-Ka-HP=6xfqrUj=FCYUCwox5vo2ANKw@mail.gmail.com>
Message-ID: <CAHk-=wg1DYeY9WHP7cf-Ka-HP=6xfqrUj=FCYUCwox5vo2ANKw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for 5.2 merge window
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 17, 2019 at 4:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Ouch, thanks. :/  I'll send a new pull request as soon as I finish
> testing the change you suggested.

I see that you added the trivial fix to things and re-tagged using the
same tag name. I've pulled it,

                  Linus

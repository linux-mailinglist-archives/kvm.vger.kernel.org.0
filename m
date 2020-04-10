Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5060B1A45BD
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 13:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgDJLfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 07:35:44 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34518 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgDJLfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 07:35:44 -0400
Received: by mail-oi1-f196.google.com with SMTP id 7so328208oij.1
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 04:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ak/n/QFprJwiNkpwHaAXa7wOUuxlUvr0M/v9pCPaJMI=;
        b=g/fO0oCdTq+shAT0O/oiCqYJhfzIa9hGLxiBIaL3AVnIw+8BhKYMTlmfAzsAUJsbgV
         R22X9dv9TWsQIiBfWXcx4PsQ3tAjOaxFLjE+1YXXjOX/qepkvLRAUaJLAUqZ6TAdQs9Y
         LR/p85hSzVGooHUOVuolvqHl9+VP3vDiDpTeYyLhdgE61EGPaZh4JUvTsCdY2UOP4dBW
         ZyvISOBdHYMCAIvrOTmt4+EWdfwang5rzwdnmv9U+tRyw6H4WH+ig8UIwmgij3mKmN+M
         M6oL9u0bh9jTRWpV8U1ADfSvzLW6nZkTCFh0ZiQ451twPHf9VQ/sPRpJOchMhKI8mUlq
         j3eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ak/n/QFprJwiNkpwHaAXa7wOUuxlUvr0M/v9pCPaJMI=;
        b=IXdT81dlbgsVcGjWit+1f922bNzT6NhcCZRC6/PjR1YEfGTkGy54ROhk8JR8rmHule
         m+be7J79khDOvRiVk9SBzMwkg1htlU9jkV4kweVAouXYwY+RQmWOgzZVAt7F+6yOVzcW
         yjjl/aN+pgnz65HkB0tIlfP9MOGLhq/6JuZ4YdK5WmBIUDwqezAcuqZ2Bjd9Htnph6TO
         7TWis485oCi+oIJpV5jS/zGC49pvutex5cYvPJncjNTfiXGsnKMauKu9Qy0y/nkhmHio
         BaUVxL2C3547BZ4PkKETlM8DbeAka/+ziTauv95jvhwmnEOmU3oHwoNt36U3VWojb6+6
         X7ew==
X-Gm-Message-State: AGi0Pua5zmoNIv/lxnoSPOl1diMPpFgTw2roREH057qbx039//HAnB9m
        WUpfPkeJ8ihEolXQ3IRCQ+7d7u3es/lK77ga8H43zg==
X-Google-Smtp-Source: APiQypJXW1cPgjMAWgnSQBjgRtK90ggzXpLwoUqiZ3eadrsPdiH5v/+VGC0j+noiEW7A5qZFmLxrcsb2GTkEwFQofUo=
X-Received: by 2002:a05:6808:4e:: with SMTP id v14mr3091006oic.70.1586518541919;
 Fri, 10 Apr 2020 04:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <CANpmjNMR4BgfCxL9qXn0sQrJtQJbEPKxJ5_HEa2VXWi6UY4wig@mail.gmail.com>
 <AC8A5393-B817-4868-AA85-B3019A1086F9@lca.pw>
In-Reply-To: <AC8A5393-B817-4868-AA85-B3019A1086F9@lca.pw>
From:   Marco Elver <elver@google.com>
Date:   Fri, 10 Apr 2020 13:35:30 +0200
Message-ID: <CANpmjNPqQHKUjqAzcFym5G8kHX0mjProOpGu8e4rBmuGRykAUg@mail.gmail.com>
Subject: Re: KCSAN + KVM = host reset
To:     Qian Cai <cai@lca.pw>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "paul E. McKenney" <paulmck@kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Apr 2020 at 13:25, Qian Cai <cai@lca.pw> wrote:
>
>
>
> > On Apr 10, 2020, at 5:47 AM, Marco Elver <elver@google.com> wrote:
> >
> > That would contradict what you said about it working if KCSAN is
> > "off". What kernel are you attempting to use in the VM?

Ah, sorry this was a typo,
  s/working if KCSAN/not working if KCSAN/

> Well, I said set KCSAN debugfs to =E2=80=9Coff=E2=80=9D did not help, i.e=
., it will reset the host running kvm.sh. It is the vanilla ubuntu 18.04 ke=
rnel in VM.
>
> github.com/cailca/linux-mm/blob/master/kvm.sh

So, if you say that CONFIG_KCSAN_INTERRUPT_WATCHER=3Dn works, that
contradicts it not working when KCSAN is "off". Because if KCSAN is
off, it never sets up any watchpoints, and whether or not
KCSAN_INTERRUPT_WATCHER is selected or not shouldn't matter. Does that
make more sense?

But from what you say, it's not the type of kernel run in VM. I just
thought there may be some strange interaction if you also run a KCSAN
kernel inside the VM.

Since I have no way to help debug right now, if you say that
"KCSAN_SANITIZE_svm.o :=3D n" works, I'd suggest that you just send a
patch for that. If you think that's not adequate, it may be possible
to try and find the offending function(s) in that file and add
__no_kcsan to the  function(s) that cause problems.

Thanks,
-- Marco

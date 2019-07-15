Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D05968F8E
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 16:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389526AbfGOOPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 10:15:23 -0400
Received: from mail-oi1-f178.google.com ([209.85.167.178]:42038 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733303AbfGOOPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 10:15:21 -0400
Received: by mail-oi1-f178.google.com with SMTP id s184so12728513oie.9
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 07:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gp/6W37eMu5xDWcpktiKvddaDspKVZ0ts4TydiZK6QI=;
        b=frFvyeq4migi0E1WkLYG1HiN+tKaskBFIwsV3sAJ3JnhCHNFY5eLeimrq57WbqiEgp
         obVXNjhrPhIcu69u3iBQ6VNVBP9CtgxDKLHd1R58yb7EIZKpWqhQ/AFdLvjWG8Pd5eDY
         hFOnV9+Vtm9yL+PL41aa8n9d4pxCGoneqHp/S9oWfrA+e+zxlrwr4LrESP88iKH78G2M
         KmtIwiygOjPOU1JX4l83igz1yhZzosCF2Bad9uCGa/e2mjRLMVI34hMKWUC6JTK9U7a4
         FFn/vRNmhaPSnz8RiqHN9O2NKSuTOS2bDmvoTJZptzvcGbrNS5y2gY2JLcF5XBSxGwaO
         0rOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gp/6W37eMu5xDWcpktiKvddaDspKVZ0ts4TydiZK6QI=;
        b=T1gfjFBczpw1vTMMpO3/WhkfccZj4WxalDe5qXj/2eZYy3z5zZitl3Uw68lBVdpPNi
         s+qMxf6PkUd24ICbfB6Pg9/xevkSvg/TQqk4rlfTbzcfi4tgXMV7FSE3rbhzsidFYJvE
         rdl1z9Xpjk/qrzxELjSkz48sjoZbJOmsSKgs9CTMKd0RjP6ktCiaQ/nizc3a23PqWQ+K
         176vJIA91GevMtWXshcHAbjRDveuGMoRN1yJUPj1u0UNiyWm0jhh+G2tofbDWpKWD1KK
         7q1zkcgbilB1ovFItOrfEM9PhzkZlE3w9/oMI177jNBVZedJrfNGwbRViM3T4/GZz85i
         eI5w==
X-Gm-Message-State: APjAAAV6vxcYocWfqDgWhWKKhbkuiXgLbwVSsSRB2nL0k0/rJjAhblVw
        mPga3EpZ6cllp10sOe+M0q49eXzVEwK3Et9IGSsHHA==
X-Google-Smtp-Source: APXvYqyITPH1BL31hWkIofgCPOhmOJSR/zZZzx8+YHCeQpjANnfXdMX8Nh9PiXRJu8Jaa0Jizr6CWwcZD6jERXrUdlM=
X-Received: by 2002:aca:5cd7:: with SMTP id q206mr12037960oib.146.1563200120863;
 Mon, 15 Jul 2019 07:15:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190712143207.4214-1-quintela@redhat.com> <CAFEAcA-ydNS072OH7CyGNq2+sESgonW-8QSJdNYJq6zW-rYjUQ@mail.gmail.com>
 <CAFEAcA9ncjtGdc8CZOJBDBRtzEU8oL7YicVg5PtyiiO2O4z51w@mail.gmail.com>
 <87zhlf76pk.fsf@trasno.org> <CAFEAcA_9tVQht7bp9_yrFEhQ74ye6LBNjEYK_nftCWsKMrOohw@mail.gmail.com>
 <87pnmb75i3.fsf@trasno.org>
In-Reply-To: <87pnmb75i3.fsf@trasno.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 15 Jul 2019 15:15:09 +0100
Message-ID: <CAFEAcA-Y4kcY54pmPydUATFEzBYd5ptQQoUgVQYfOVJhLu5goQ@mail.gmail.com>
Subject: Re: [PULL 00/19] Migration patches
To:     Juan Quintela <quintela@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Jul 2019 at 15:10, Juan Quintela <quintela@redhat.com> wrote:
> PS.  BTW, did you launched by hand the guests with valgrind, or there is
>      a trick that I am missing for launching a qtest with valgrind?

I quoted the command line I used:

QTEST_QEMU_BINARY='valgrind aarch64-softmmu/qemu-system-aarch64'
tests/migration-test -v -p '/aarch64/migration/multifd/tcp'

(https://wiki.qemu.org/Features/QTest lists this and some other
things you might want to do with qtest tests.)

thanks
-- PMM

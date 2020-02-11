Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 882C815881F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 03:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgBKCH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 21:07:57 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39056 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727594AbgBKCH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 21:07:56 -0500
Received: by mail-lf1-f66.google.com with SMTP id t23so5798132lfk.6
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 18:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ZmktFtWuNRr4MBQJWn7k52Pxjy+kjDuDMoIZxcgghA=;
        b=JShucc8r6D0hpeQT1Nnrm1g5ANmN7Qo/kC9ja9eYheqbwRWtW6iBI7iAF7MqgaTDXe
         EhrqvIPUINQoMoQ8goy1qNA3ZRXhiyGuval5jBA1G2OdAVfZKMH31Bd7+08ReOWRrocf
         QaEnZGmB7acwDOJTWolplby3wrYLVP5sMqcdc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ZmktFtWuNRr4MBQJWn7k52Pxjy+kjDuDMoIZxcgghA=;
        b=cd7D8UTh+uVj31hwxx6arlL5WJngBQd9Q1oMKZRreATqbp6RaJU4CI1+CPKx5XpwTx
         E+/FUWFmpANagrzA+6LN/G6r335BS9lBAYDtU6iqcRiDXHkXDceeoWGBV5qoXHzTk7g1
         nQJxJGPJrsnkbDjGJoiIf0Y1B4unOMLElImGiCSvQpD8Kc9GGx0w7lSMd4zopBu7lv1I
         Cilu8WAtYd5B7A9G69hEgPCKy8iPEPfUvmGWZLmdT8K004NqNaxpze4B2zL3HstKBUQ2
         dFRyK5fSXiaGxK2ml3H0dNpXbm0wkoH9MaHbcU6Kad569JVm3syfcWtIEuGuOQ0Z3ne6
         Ra9g==
X-Gm-Message-State: APjAAAXGO1wv/6wGvJf82MXSeYS/+2WcrUFLYjnuTzxJBfwijKuSz+m+
        B1uNWH+7bb3QXANKxo0zF+Y7A+OKzro=
X-Google-Smtp-Source: APXvYqwnD/BDy0g+yHFXOaQ6+Tmutg1OmlnaJ6gplbtIjzLsEzQIlOdp9nis+IwQ7JWhj3mB2YuFxg==
X-Received: by 2002:a19:cc07:: with SMTP id c7mr2217864lfg.177.1581386872722;
        Mon, 10 Feb 2020 18:07:52 -0800 (PST)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id l12sm1142710lji.52.2020.02.10.18.07.51
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2020 18:07:51 -0800 (PST)
Received: by mail-lj1-f171.google.com with SMTP id h23so9740077ljc.8
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 18:07:51 -0800 (PST)
X-Received: by 2002:a2e:97cc:: with SMTP id m12mr2637598ljj.241.1581386871172;
 Mon, 10 Feb 2020 18:07:51 -0800 (PST)
MIME-Version: 1.0
References: <20200210010252-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200210010252-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 10 Feb 2020 18:07:35 -0800
X-Gmail-Original-Message-ID: <CAHk-=whvPamkPZCyeERbgvmyWhJZhdt37G3ycaeRZgOo1bpVVw@mail.gmail.com>
Message-ID: <CAHk-=whvPamkPZCyeERbgvmyWhJZhdt37G3ycaeRZgOo1bpVVw@mail.gmail.com>
Subject: Re: [PULL] vhost: cleanups and fixes
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <wei.w.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 9, 2020 at 10:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

Hmm? Pull request re-send? This already got merged on Friday as commit
e0f121c5cc2c, as far as I can tell.

It looks like the pr-tracker-bot didn't reply to that old email. Maybe
because the subject line only says "PULL", not "GIT PULL". But more
likely because it looks like lore.kernel.org doesn't have a record of
that email at all.

You might want to check your email settings. You have some odd headers
(including a completely broken name that has "Cc:" in it in the "To:"
field).

               Linus

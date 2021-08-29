Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E429A3FADA6
	for <lists+kvm@lfdr.de>; Sun, 29 Aug 2021 20:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbhH2SM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Aug 2021 14:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhH2SM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Aug 2021 14:12:28 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6C0C06175F
        for <kvm@vger.kernel.org>; Sun, 29 Aug 2021 11:11:36 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id y34so26421919lfa.8
        for <kvm@vger.kernel.org>; Sun, 29 Aug 2021 11:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nOEXbomGVxdTg2YIKOufPA0FWw0BA6Ntj3OHAW88ff4=;
        b=G9weGkeHN8FlJqJ0GQMGRkvYxT9+fXAmH0dB17bI65t7LV9Q70hlMMFtwZr4o4zSms
         C3ZBm+mpNRjS+UkmvFIj8dKgUWkyzIyP3SJa7hZUeOvoF9uuwyCa0eKl5/wXl5LDkYvt
         g1hC/0+a5me3A0DEW79RnUqRw17xLL0C1Ysgk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nOEXbomGVxdTg2YIKOufPA0FWw0BA6Ntj3OHAW88ff4=;
        b=hD9aB/WGBvJw/JcTtN6TZey2P4UPdOeir0ohOCOGndAFCS5tPCpeQsLYvZrjILAEJ9
         twrl4f97D1FdTS4Gb9dbE+3cYlKn4WEc4VgK4boPtToyK/QJavW93IfTjwa2eoHkhOqv
         dgtQpUWzjflyH03OmcOGhayILlsj4I0sn+mWq7v+thC36ZSw5Y7zvryNvAI1Dg8NGI9X
         YrKfnCkhYYzkSWIBuS6iq8+3Ua83t2CaTJ9zzNU4cGUBtpzXpmPl9VviY5xUmqtiWZBU
         eH+gIIeykQFi76cgBUjXlZGuG1c+TI0gzHYwzAqBRjUdrq7S2EtZS1TYQpp349QycgNO
         MHgg==
X-Gm-Message-State: AOAM530Yt2Pyxim8r6dE7lNQrCRy/U6XM4B80kUqoQQBmvkeXbOzhE39
        Kx4IXVdrFDB/2DO/WzcbJgsvDg1Aq9jOPBNQ
X-Google-Smtp-Source: ABdhPJzMc0e+MTIit7m+yVqng8APWh43e2IvzSzdEQUdt/1sozzbpXoqmNkYJ1j1QkzLo9hH2wo5tg==
X-Received: by 2002:a05:6512:301:: with SMTP id t1mr4546437lfp.626.1630260693044;
        Sun, 29 Aug 2021 11:11:33 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id 131sm1523176ljj.52.2021.08.29.11.11.31
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Aug 2021 11:11:31 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id d16so21766291ljq.4
        for <kvm@vger.kernel.org>; Sun, 29 Aug 2021 11:11:31 -0700 (PDT)
X-Received: by 2002:a2e:7d0e:: with SMTP id y14mr17065408ljc.251.1630260691346;
 Sun, 29 Aug 2021 11:11:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210829115343-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210829115343-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 29 Aug 2021 11:11:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjYkPWoQWZEHXzd3azugRO4MCCEx9dBYKkVJLrk+1gsMg@mail.gmail.com>
Message-ID: <CAHk-=wjYkPWoQWZEHXzd3azugRO4MCCEx9dBYKkVJLrk+1gsMg@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: a last minute fix
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 29, 2021 at 8:53 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> Donnu if it's too late - was on vacation and this only arrived
> Wednesday. Seems to be necessary to avoid introducing a regression
> in virtio-mem.

Heh. Not too late for 5.14, but too late in the sense that I had
picked this one up manually already as commit 425bec0032f5
("virtio-mem: fix sleeping in RCU read side section in
virtio_mem_online_page_cb()").

                Linus

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7053BB705
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 07:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhGEF6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 01:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhGEF6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 01:58:05 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9BEC061574
        for <kvm@vger.kernel.org>; Sun,  4 Jul 2021 22:55:29 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id g12so11540075qtb.2
        for <kvm@vger.kernel.org>; Sun, 04 Jul 2021 22:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z70V2P3INfkKoN7cKTG2utQwVT93mpB0I4qZa1V+qNM=;
        b=vpyuQoMiBT3gfitzjxdgI03uowFRh7fwxuoxUcOS3VKythL2KXtkZOalrXUGXv8+jn
         4h6H+0KsgqIeJT7qZ69katX3klAa0AdXHxYdkTvmScSWzni3BbaX7H/pnbN1gmqPGduC
         B6wilTQVYGPYQhpcQEAjKkviLG9rx/fZEKHBuRqq2FUHzcZ2aWJ4smqM4OUT/QSP4tQk
         ePDuyDw2jDG/X+d0sWNpLBiDcXAg7D6WckicKCGcJrgEtRTlFcsMr+2Vs2jrZFjLRKVc
         fPh+I6Ry0Q9Q5fvxVirP70e8jKeJKmY0AuKv+ehmYzJSf9ywIy3MUQz5QvTDdGHyW9Gk
         wgZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z70V2P3INfkKoN7cKTG2utQwVT93mpB0I4qZa1V+qNM=;
        b=WKn3bBZbEnhxiuGD3yxSPQIwEpN9uX9pvZIuUUnRVEhDPDKEm5NWBk+cvwBEaWNJOu
         mt9EhxJSq9zskVFdZCKNZ7mFZMkvtRDzz/YhjQJ6w+vS5gTSvlk6JpbMbyO0E0wJbc3k
         EoHEqeSAfpo8ulN0UdL4y1HCBVCr06bCVBOgk/ZDupyFoPDuyrr7p2ZsTwzoqF2Fo292
         I1KkfVF6KfLFWMK5A1yz1hpgCC6vZ4yLfsXH6iFXYmlRFPUoBFnkjF+iK295SBdEK5AD
         zEI+dlpmXJkvGMUiwf02yne1o00NvA7T1u6T2NyUcWjiAsciYcmCoWxuckMYv161JyIt
         7BOQ==
X-Gm-Message-State: AOAM532jgvuQOPqnF3EykIzsxzurL0wIawvehXt4Sr+p+OnUe2PQtLnq
        mdIP6uW4vvGzRSKiZUMBf3AcC0Yrvwr4N6Ke9NwuQg==
X-Google-Smtp-Source: ABdhPJztTWdJ8hbmYeISjIHPClEr2oST15A13xCUvH/K/TEihlfiIOmPhZ2YTYmvexkE9qiUInkOke0n/dcixpOX/1Y=
X-Received: by 2002:ac8:60ca:: with SMTP id i10mr9003518qtm.43.1625464528330;
 Sun, 04 Jul 2021 22:55:28 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000bfb6cf05c631db0b@google.com> <20210703101243.45cbf143@gmail.com>
In-Reply-To: <20210703101243.45cbf143@gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 5 Jul 2021 07:54:59 +0200
Message-ID: <CACT4Y+Yk5v3=2V_t77RSqACNYQb6PmDM0Mst6N1QEgz9CdYrqw@mail.gmail.com>
Subject: Re: [syzbot] memory leak in kvm_dev_ioctl
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     syzbot <syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 3, 2021 at 9:12 AM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On Fri, 02 Jul 2021 23:05:26 -0700
> syzbot <syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com> wrote:
>
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    e058a84b Merge tag 'drm-next-2021-07-01' of
> > git://anongit... git tree:       upstream
> > console output:
> > https://syzkaller.appspot.com/x/log.txt?x=171fbbdc300000 kernel
> > config:  https://syzkaller.appspot.com/x/.config?x=8c46abb9076f44dc
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=c87d2efb740931ec76c7 syz
> > repro:
> > https://syzkaller.appspot.com/x/repro.syz?x=119d1efc300000 C
> > reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c58c28300000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the
> > commit: Reported-by:
> > syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com
> >
>
> Corresponding fix was sent about 2 days ago
> https://patchwork.kernel.org/project/kvm/patch/20210701195500.27097-1-paskripkin@gmail.com/

Hi Pavel,

Thanks for checking. Let's tell syzbot about the fix:

#syz fix: kvm: debugfs: fix memory leak in kvm_create_vm_debugfs

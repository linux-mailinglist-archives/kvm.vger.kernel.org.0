Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9359C6C7AF0
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 10:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbjCXJNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 05:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjCXJNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 05:13:33 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4A41EBD1
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 02:13:32 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id 9-20020a5ea509000000b0074ca36737d2so796314iog.7
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 02:13:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679649211;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QExb/T1F8/XoorTxuEKbTqt2ECV6VnSe+3ISxG21XUQ=;
        b=XzgWbEAJrWkp2AdO3W3ZYIkqWdtdygxg3oWTcAdT24ky4eHfYPtikrLZn4UoRrPfrI
         XZQQScpczKgBWJRRU7yKTq3b5wTstqygNDxaXBmYIKUNjOzze6wUcZET7BgZhHfzvZfV
         L+wWUDaG2yetnRoxIkx0eNM/ttRuCzx7PVZnY4wDYvALXYacAr9R7Xpn5mLm9/fEYMZP
         zvPOh+pPxNhme7/6CqnYROPab6kj/o2ZkasIUGfQhZc42e06t8J23zhMjTHJCjruvSNY
         ToS7KXRN1mc9uIlKfVKwxadnEfxnY2wkXBoyBATrVkPiUKDvB0LgPuxIHOF+jOPnCbEI
         /s6g==
X-Gm-Message-State: AO0yUKXw32lwh+swX6900pTDcvWLiigYq8Ma7Lb1fetwE6MPjSOVw2gS
        NcENqNQqfd+/Y1YX/bl+1Q4StmeZd34biOF8l5u3riVHdxFu
X-Google-Smtp-Source: AK7set+u9V3h/lFnpss+6vSzDvV1hDPTiWdu/52VHEtBts1JBVTxyLHO1pbJZyyllLB5e3fSkCqgmE/v2lcGcZ6C+6WU1l4vDvHu
MIME-Version: 1.0
X-Received: by 2002:a02:a189:0:b0:3c5:14cb:a83a with SMTP id
 n9-20020a02a189000000b003c514cba83amr639266jah.2.1679649211430; Fri, 24 Mar
 2023 02:13:31 -0700 (PDT)
Date:   Fri, 24 Mar 2023 02:13:31 -0700
In-Reply-To: <CAGxU2F7XjdKgdKwfZMT-sdJ+JK10p_2zNdaQeGBwm3jpEe1Xaw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000098457705f7a1ce42@google.com>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in virtio_transport_purge_skbs
From:   syzbot <syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com>
To:     avkrasnov@sberdevices.ru, bobby.eshleman@bytedance.com,
        bobby.eshleman@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, oxffffaa@gmail.com, pabeni@redhat.com,
        sgarzare@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file net/vmw_vsock/vsock_loopback.c
patch: **** unexpected end of file in patch



Tested on:

commit:         fff5a5e7 Merge tag 'for-linus' of git://git.armlinux.o..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
dashboard link: https://syzkaller.appspot.com/bug?extid=befff0a9536049e7902e
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16b4bba1c80000


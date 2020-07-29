Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD37231BBB
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 10:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgG2I7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 04:59:06 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:42540 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgG2I7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 04:59:06 -0400
Received: by mail-io1-f71.google.com with SMTP id l18so15704463ion.9
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 01:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=gFBRlRWNk92oL6Fz7e42YwVu/c/ZEOEHHkd5Zj/UqNY=;
        b=bwRhkn4nZ0nsTAAklq28oE2Adx5/N8ra5HDl5yi7bqU6RNGluxVmF7XUliOwvG/X+u
         5dZBMN4S1MYWUOa4qclOr1lefgl5qDfyz7hMkFdi/PmfXC+lBfLkC1ce0DNMcBCb5ZEa
         EKlpSHyfwUfPU+y4/0skeY9Bby5/NkXpsJT9wjwsvUm6TLJ2XVrfIGX7xqPPN/lWtBO4
         a47b+BoDTPBwOgxlMKw0/GmcS5jQyd5KhAOyFKkKbSW0awNmSj64Gl2ZRsijQXIMYJVp
         NqddcBnGoGc+n/+IoEE4VFfizk3wCi4y6tl3pVxqPR0WHQ3i41PDDAcgGRK7km64zOdt
         QFcg==
X-Gm-Message-State: AOAM531SDQi6hqGZQyBP3L4E2XkQgCdX9YF7/0xTNHZvDsKNYx43zhv2
        exzy/UjRc2o/C0nZjq5d1ZSRVnn5DrxYgDBM0v9zgjxgjhYw
X-Google-Smtp-Source: ABdhPJyvyX5E1smDObksgtmqLLMrzGTwPv5XpW2cLAchMk5lOO3bPvgvMcHEpqBPYAXEd1vldHGiYB5nuAwSxaE5cK9yKPxGFxaw
MIME-Version: 1.0
X-Received: by 2002:a92:48dd:: with SMTP id j90mr27158851ilg.75.1596013145206;
 Wed, 29 Jul 2020 01:59:05 -0700 (PDT)
Date:   Wed, 29 Jul 2020 01:59:05 -0700
In-Reply-To: <00000000000099052605aafb5923@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000093b5dc05ab90c468@google.com>
Subject: Re: general protection fault in vsock_poll
From:   syzbot <syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com>
To:     davem@davemloft.net, decui@microsoft.com, jhansen@vmware.com,
        kuba@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sgarzare@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this issue to:

commit 408624af4c89989117bb2c6517bd50b7708a2fcd
Author: Stefano Garzarella <sgarzare@redhat.com>
Date:   Tue Dec 10 10:43:06 2019 +0000

    vsock: use local transport when it is loaded

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17e6489b100000
start commit:   92ed3019 Linux 5.8-rc7
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1416489b100000
console output: https://syzkaller.appspot.com/x/log.txt?x=1016489b100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=84f076779e989e69
dashboard link: https://syzkaller.appspot.com/bug?extid=a61bac2fcc1a7c6623fe
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15930b64900000

Reported-by: syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com
Fixes: 408624af4c89 ("vsock: use local transport when it is loaded")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

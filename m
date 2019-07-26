Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6663376CA0
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 17:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387750AbfGZP0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 11:26:02 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:48938 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387755AbfGZP0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 11:26:01 -0400
Received: by mail-io1-f72.google.com with SMTP id z19so59120643ioi.15
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2019 08:26:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=iHIZY3n79tjWiqF4FrsxNYHlKLoyYYCqi0zeJqFjTkY=;
        b=l7TyBf3hG1P4ZlZd29AvsYjgWNuEoV1r2HKjOgcax4di+6dXlx9X7w82WxChu+FZzP
         WKLbJ94X0hEtmcvd9frQgXsyMSqUo9A031sYFNz1qrfsb3bNc6m+6izBp+ojgI4UOe7Z
         7A8tEIBIGNcWiJQGZgaNsvq+OOBNkIpU06TJhqaQ+DThHlecPGOasD25qdFRQmI73BEK
         IAV3BxM4HIlpplK8KBmMBtZ6cljq+3oK04/oNrP9mCxzhRtS8jbolufyV1ITBm8uKSGy
         G63ck0BbPrt1tYv5o+6wcGjzajAL/t6X/p/lupCxZdKTvmFexlxqFc0pACpWLE7WIvcD
         HebQ==
X-Gm-Message-State: APjAAAV2nlB6gAHIgctnvMAt4WY/nYR8+PqX6TJP1SCLnhjFe7GH4gt3
        GA8dwVLj7idEwmnlQIFhPdmS19SZK6XssAjhDEt3ASOFcPkv
X-Google-Smtp-Source: APXvYqzHpk/vEMkIMKMtiMdg8PB4RYhne1o6pJ8WL+G6Degv9dbMalQiRsRdhyVuMJOgTkwheM+dhLdMfqp+YLyIul4ruGrn56Gi
MIME-Version: 1.0
X-Received: by 2002:a02:4484:: with SMTP id o126mr98783066jaa.34.1564154761082;
 Fri, 26 Jul 2019 08:26:01 -0700 (PDT)
Date:   Fri, 26 Jul 2019 08:26:01 -0700
In-Reply-To: <000000000000b4358f058e924c6d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e87d14058e9728d7@google.com>
Subject: Re: INFO: rcu detected stall in vhost_worker
From:   syzbot <syzbot+36e93b425cd6eb54fcc1@syzkaller.appspotmail.com>
To:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.lkml@markovi.net, mst@redhat.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        virtualization@lists.linux-foundation.org,
        yamada.masahiro@socionext.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this bug to:

commit 0ecfebd2b52404ae0c54a878c872bb93363ada36
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jul 7 22:41:56 2019 +0000

     Linux 5.2

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=118810bfa00000
start commit:   13bf6d6a Add linux-next specific files for 20190725
git tree:       linux-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=8ae987d803395886
dashboard link: https://syzkaller.appspot.com/bug?extid=36e93b425cd6eb54fcc1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15112f3fa00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131ab578600000

Reported-by: syzbot+36e93b425cd6eb54fcc1@syzkaller.appspotmail.com
Fixes: 0ecfebd2b524 ("Linux 5.2")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

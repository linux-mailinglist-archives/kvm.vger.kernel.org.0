Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132FE740A5B
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjF1ICt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:02:49 -0400
Received: from mail-oa1-f69.google.com ([209.85.160.69]:58470 "EHLO
        mail-oa1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbjF1IAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:00:45 -0400
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-1b019e26019so4211398fac.0
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 01:00:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687939245; x=1690531245;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0tU/DkiC2cdHNVfkcshEwEdx4UQyiRnmp0Dt8PMj1Z0=;
        b=lNwZ+jWXIWxEeu/SKeHgN19UBS4aACumMo2X7XrJ9V7b+2AVTU/QS883TqnqRk+BSY
         miXM6BNfQmFtPpld/yfWsZUoVnyqAzj2ygSOE0dlqCWT2swMhmaLEkdPWhPKems3NDdc
         I9vQti88wiW0pyMjcE3gmwLMGb1QnWRDkXSd/ONW5Q54PPMl3MQ0O2+t7CtebFiXBkqv
         5RxDSVIwoGh1knKaIVVR2UbglsEFpfwO0666mgEJ/6OhNab/KwEXy2OlYThGMZZ5onIe
         DCfI3uaNh2/3CuW8Rr3v09GWsD55NvbEf/5TEScf3ufmaef/p8b9Gcvs8ITr1Pkl74BK
         3oJA==
X-Gm-Message-State: AC+VfDxNEUwUatItLQLrPBrt2rekcG7aDuphOeWAj/sUU7tdoKE4FbFo
        eWl/ioDT0DQKSoP0qq2YH7kOSDXRvnANHNbCrt2xEj+2F3HJ
X-Google-Smtp-Source: ACHHUZ5cpgvp7soPDJcmISMLPVZMvANV7NjaIOHQgKsTt00uSF8IsG6HtFS3C0HtXvaPSoJCdX+57RlSlPTzVYakrGII8TH/G1sV
MIME-Version: 1.0
X-Received: by 2002:a05:6870:7a0b:b0:1b0:2d25:f5ab with SMTP id
 hf11-20020a0568707a0b00b001b02d25f5abmr3842449oab.0.1687939245302; Wed, 28
 Jun 2023 01:00:45 -0700 (PDT)
Date:   Wed, 28 Jun 2023 01:00:45 -0700
In-Reply-To: <000000000000a2c79f05ed84c7f9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001e68bd05ff2bfbbf@google.com>
Subject: Re: [syzbot] [kernel?] kernel BUG in workingset_activation (2)
From:   syzbot <syzbot+644848628d5e12d5438c@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lrh2000@pku.edu.cn, seanjc@google.com,
        stern@rowland.harvard.edu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 0143d148d1e882fb1538dc9974c94d63961719b9
Author: Ruihan Li <lrh2000@pku.edu.cn>
Date:   Mon May 15 13:09:55 2023 +0000

    usb: usbfs: Enforce page requirements for mmap

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a65abd280000
start commit:   59d0d52c30d4 AMerge tag 'netfs-fixes-20221115' of git://gi..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=11d3fa0b3feb5055
dashboard link: https://syzkaller.appspot.com/bug?extid=644848628d5e12d5438c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fdf3f1880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17b54702880000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: usb: usbfs: Enforce page requirements for mmap

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

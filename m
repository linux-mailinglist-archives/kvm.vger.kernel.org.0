Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92B81B82B0
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 02:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgDYAXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 20:23:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:46431 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgDYAXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 20:23:07 -0400
Received: by mail-io1-f72.google.com with SMTP id e76so12859615iof.13
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 17:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=esBSsBbw+kcCXBkpJEM2iyfuK9TKxh9r1ZoVcdUm/nY=;
        b=Djk1PyeqixspSNhdvLKD/XWJF2mv8GQVrS+mjpADVfTzKmqb6ENZjIZ+AT8DRYf6Xl
         hWUf6DFrFgSWd4FzgX6i/RNI19mqOcZyk/srrqobO9n2hvY+CZrXxDo3bbpdgcIKoO+E
         9DFOum1hAXNdHHGKewtM8phWhsvEuaBVOVasJv8PZdq7SPgs6Efqjp71utY1k14/Q2s2
         EzoJ1azTePKQR7lFlRR/ajwk4g6EnbujOyzKgYrdl1MQ1wuQfayK6TVMuULhNNizz1qv
         sATyZFv3zj4dsAS79TmjF/rba+4oyidiKCD3VNb98NHnPPntkn7UUSGyFBfq3wWaIOfq
         //mw==
X-Gm-Message-State: AGi0PubXPHJ290DHu2tHSzEUp8lyugysfXknc+rTg6ifCdNdVVjdvYaJ
        lUaZCSI97R63XxWSNuNSbEXnK6ntiRU6jxvynonM1hfat3wt
X-Google-Smtp-Source: APiQypL5JVe43wR3OA9+wBM/bsSnyUQzSomysGMB1rykNrbbIzpZF4k6STnA0yLWvTFxmNUaKhUQRanw35nPbZ32kTlU916icgi/
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2d91:: with SMTP id k17mr10959064iow.78.1587774183258;
 Fri, 24 Apr 2020 17:23:03 -0700 (PDT)
Date:   Fri, 24 Apr 2020 17:23:03 -0700
In-Reply-To: <000000000000dd04830598d50133@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002d42ee05a4127cfc@google.com>
Subject: Re: KASAN: use-after-free Read in tty_open
From:   syzbot <syzbot+9af6d43c1beabec8fd05@syzkaller.appspotmail.com>
To:     dvyukov@google.com, ebiggers@google.com, gleb@kernel.org,
        gregkh@linuxfoundation.org, gwshan@linux.vnet.ibm.com,
        hpa@zytor.com, jslaby@suse.com, jslaby@suse.cz,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, mpe@ellerman.id.au, pbonzini@redhat.com,
        ruscur@russell.cc, stewart@linux.vnet.ibm.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit ca4463bf8438b403596edd0ec961ca0d4fbe0220
Author: Eric Biggers <ebiggers@google.com>
Date:   Sun Mar 22 03:43:04 2020 +0000

    vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11594fc8100000
start commit:   07c4b9e9 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=79f79de2a27d3e3d
dashboard link: https://syzkaller.appspot.com/bug?extid=9af6d43c1beabec8fd05
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=113886fae00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1263520ae00000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

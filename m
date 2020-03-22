Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F15018E64C
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 04:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgCVDbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 23:31:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:35045 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgCVDbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 23:31:06 -0400
Received: by mail-io1-f72.google.com with SMTP id c10so1780889ioc.2
        for <kvm@vger.kernel.org>; Sat, 21 Mar 2020 20:31:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8nZWcNO+DrxQ4s8b90bUZeMFLENWFuwrxp+C1YlPnOE=;
        b=TvbxNc9Z3vDSoiSLm/VkDaZv5Wq0SNT+BEOjINRACUDn67ASiEWN9o5x0tH9cOIDfH
         vh06QYZ6FeqSl7SlgORFEoFH+AxCz0qQYolur+m4KK/u8afPx0YiN9MnGfbuIFuI/fw7
         5JPqM89t8J5v9nrzM89WEeG008FbEc7P7CKUaUQtR66oLQlGneJo2IuwuiXSXrg0F7VX
         C1V+Vab3qjzRNk+Y9hsnxnMlK+72cYPpdIE3Hfn04SZHe/jgEZIQ4Xo+0qmJ8XlIckwW
         lklblZApFs99UqIho7/EcVGeUCoy5nPxUfbzlMCSJMYfh9cUpDwajw8fGal3KJQhXDMD
         d5eQ==
X-Gm-Message-State: ANhLgQ0auV2/8W5BJ+W8W5jcbq9bJcCZXkDgGjRd1D3uqk6y2AcQdAYF
        3dKQ44/XQ3jKmE8uxQ4LyHBZAXWVikjVtV7LFFUeJFlb88v/
X-Google-Smtp-Source: ADFU+vu238tJAeWox3dcwhThsCAlmUdZYHUcZI17D3Ju1wPlJpIWrvO0GOq2JFMVs0LzLmjvnsgF4PcQN2ntWGBx/+nbM9k09DIq
MIME-Version: 1.0
X-Received: by 2002:a02:b701:: with SMTP id g1mr8752742jam.92.1584847864144;
 Sat, 21 Mar 2020 20:31:04 -0700 (PDT)
Date:   Sat, 21 Mar 2020 20:31:04 -0700
In-Reply-To: <000000000000f965b8059877e5e6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f725a005a1692508@google.com>
Subject: Re: WARNING in vcpu_enter_guest
From:   syzbot <syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linmiaohe@huawei.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this bug to:

commit 9446e6fce0ab9dfd44b96f630b4e3a0a0ab879fd
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed Feb 12 12:27:10 2020 +0000

    KVM: x86: fix WARN_ON check of an unsigned less than zero

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1744891de00000
start commit:   5076190d mm: slub: be more careful about the double cmpxch..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14c4891de00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10c4891de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
dashboard link: https://syzkaller.appspot.com/bug?extid=00be5da1d75f1cc95f6b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10bb4023e00000

Reported-by: syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com
Fixes: 9446e6fce0ab ("KVM: x86: fix WARN_ON check of an unsigned less than zero")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

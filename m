Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6341B1EE500
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 15:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgFDNJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 09:09:08 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:47489 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgFDNJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 09:09:07 -0400
Received: by mail-il1-f199.google.com with SMTP id w65so3925975ilk.14
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 06:09:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=u+o2RcyaHSofblAhvnfVshy/ql7Met8tthhkmRydCTY=;
        b=YA1yrtZIaA+U5MtJNkC17gMZyEH6/aR5Rb88vlRgpgc0nm7uiqIEIDPUa9PZZQRt7t
         m7puxFYU2+CCHgBq2dI/pL78gKmTEVK6F3lxbddEFef27IBUeJBBALJrzNSQkyo9zvZV
         4Jpotu2Vh2SOCy/cviGBfIBoOcuC8HAPCtTlRxDNBS5zKZRzul2epXF8mmCJ99CuaU9g
         TmYovq3QXzB/KJ/T/ExZkQbkewusCF8nN+0vo/2usyc/YDbsYP/z8y9jJm04+n0qhER0
         3j+ielHACOXzchNuq72VinxW25+K8RoelAKKJqOwq5ZkV7A0chadOb5OXsqAb+zR1gHf
         RD2Q==
X-Gm-Message-State: AOAM530cmU3lw7y6DqgkJ18+kSC6C8O0bLh3F4MYG9DZQIXBi8ESLIzU
        s0YEZTnYALiYwuSEDH2r9Ime7ShTQ0aAECygn+xgNvPR3LgL
X-Google-Smtp-Source: ABdhPJzv0fpa1LEbfmP9G7nInep6IYlF2rdPEZ+bA0p++ozOTMgXiZEO3IRN+O2prm6dT0jXr2eer3ZzH36mkQc4A3bweWh9DzjZ
MIME-Version: 1.0
X-Received: by 2002:a92:9acc:: with SMTP id c73mr3904247ill.74.1591276146848;
 Thu, 04 Jun 2020 06:09:06 -0700 (PDT)
Date:   Thu, 04 Jun 2020 06:09:06 -0700
In-Reply-To: <000000000000c8a76e05a73e3be3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000078fab705a741d901@google.com>
Subject: Re: WARNING in kvm_inject_emulated_page_fault
From:   syzbot <syzbot+2a7156e11dc199bdbd8a@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        junaids@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this bug to:

commit ee1fa209f5e5ca5c1e76c7aa1c2aab292f371f4a
Author: Junaid Shahid <junaids@google.com>
Date:   Fri Mar 20 21:28:03 2020 +0000

    KVM: x86: Sync SPTEs when injecting page/EPT fault into L1

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=138f49de100000
start commit:   cb8e59cc Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=104f49de100000
console output: https://syzkaller.appspot.com/x/log.txt?x=178f49de100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a16ddbc78955e3a9
dashboard link: https://syzkaller.appspot.com/bug?extid=2a7156e11dc199bdbd8a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134ca2de100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178272f2100000

Reported-by: syzbot+2a7156e11dc199bdbd8a@syzkaller.appspotmail.com
Fixes: ee1fa209f5e5 ("KVM: x86: Sync SPTEs when injecting page/EPT fault into L1")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

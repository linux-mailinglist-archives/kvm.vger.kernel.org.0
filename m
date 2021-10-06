Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BE7424A22
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 00:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbhJFWvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 18:51:01 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:51963 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhJFWvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Oct 2021 18:51:00 -0400
Received: by mail-il1-f197.google.com with SMTP id z10-20020a92650a000000b00258e63b8ea1so2712212ilb.18
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 15:49:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ALMwBzPbcoiTV5PvRTqV3OLyZh+7yR20m1kSW7tZ0Q8=;
        b=Q65K4jT/1iIp/xZHGYpVotbPtC0p9Xtedf08WfNS7uqxGDadbqOFqziHRM/c3YBIW+
         pF6oMXYvXKIjJ5UEvRaXSlHyMdXR6h3jh0aoRq2nedlrBpbm22OBuY1WA/Lh9FwIw+1B
         mwCW8rAwLtM+91WepBYchYT3wxRrKNFUqmD0+oxcqCd5QGqxoIl3ej5/wuaCYA+5JLdU
         yLDeTiR1YsFG3pjudwwQ0VhohqhjI/7mbOWOK+NaOtGjVL1VNwj29IuS93kxSMs8LYkx
         7lVubtn6LnAe2qmYgTaWqLBnvcB+zKi3ZZDMJ638Da2CKSYgdYijZE8fw+W0H482bHQi
         MYNw==
X-Gm-Message-State: AOAM530UvQiJidBwy8pZKPcyBId+8iObWoX0E7Ai4rem+MXNdqVPmitg
        HRGtd8KcDl2reepqmrI2BTMKxyehC0HWhPwKIpjj3lgiPFS7
X-Google-Smtp-Source: ABdhPJwgwn/+rLH5RBRah4vMGortYwfLv2GVM+OBafmkhb+7f5XXAOfDEsT5zmnO/gT3pUMne6hbUFquDJ/YSRFvAwQE1LhtB5Xz
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d0e:: with SMTP id q14mr262061jaj.139.1633560548022;
 Wed, 06 Oct 2021 15:49:08 -0700 (PDT)
Date:   Wed, 06 Oct 2021 15:49:08 -0700
In-Reply-To: <00000000000084943605c64a9cbd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002f208405cdb6f447@google.com>
Subject: Re: [syzbot] general protection fault in rcu_segcblist_enqueue
From:   syzbot <syzbot+7590ddacf9f333c18f6c@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, bp@alien8.de, hpa@zytor.com, jack@suse.cz,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        paolo.valente@linaro.org, pbonzini@redhat.com, reijiw@google.com,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 067a456d091d05fdae32cae350410d905968b645
Author: Sean Christopherson <seanjc@google.com>
Date:   Tue Jul 13 16:32:43 2021 +0000

    KVM: SVM: Require exact CPUID.0x1 match when stuffing EDX at INIT

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15d871b7300000
start commit:   0319b848b155 binfmt: a.out: Fix bogus semicolon
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=faed7df0f442c217
dashboard link: https://syzkaller.appspot.com/bug?extid=7590ddacf9f333c18f6c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1308d0ed300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: KVM: SVM: Require exact CPUID.0x1 match when stuffing EDX at INIT

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

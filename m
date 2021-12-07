Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4615E46C370
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 20:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240919AbhLGTWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 14:22:45 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:42594 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240849AbhLGTWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 14:22:45 -0500
Received: by mail-io1-f71.google.com with SMTP id k125-20020a6bba83000000b005e7a312f86dso154454iof.9
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 11:19:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=qwIHKUpEZfXAJ98aaHZ0G3Cq+vGsYXU3+sGI9JUl8Qs=;
        b=BREX5bqGptVLP31Xe4PPBArkOKAGdeEkvd6UWy3MWhYUIRSdJ82kpyREAljap/ywUz
         FFlbEz+dwowZNR4h2WggHqI5WLMtUr+kxdXPt4479rSbYr5z1nOhX6b+JjdRztvq7rvx
         a24XemAdffaP6GNZL/jeGdYoxBTH+iSmWg9Q636rO7jB8elCe16eA3HrVUHfokO29/ZT
         BPR2bap4lDb6EaWN/OeZSkHrpXFQXie6pvWvI1301hr0lWHv/SRiitaV7SN+Ne8u8R24
         5psfYayaawWhr1UTdboVo2arj3hhSaYx3lec3SDmCQk5sqyK8Ykw4UaR0+NDXQWz2qdl
         e3DA==
X-Gm-Message-State: AOAM531qYJKMZM22M+yd+LGOozIRCRFNAZDajwgag/E8nA0+jeGirMQZ
        sApYmt9XSDpcO06NAp3IWsa4pj13vo0DYEQlvsvQB9Zi5b7P
X-Google-Smtp-Source: ABdhPJzsAxGhr40s7GLGaVzV5ZP3zz35qdTxoDeDNmyRGE97aOMtDpkw4j5HGfgIf0P+VpdejmMSHCjtkDqG0IeNhi/TooDucIxx
MIME-Version: 1.0
X-Received: by 2002:a05:6602:8da:: with SMTP id h26mr1442606ioz.76.1638904754048;
 Tue, 07 Dec 2021 11:19:14 -0800 (PST)
Date:   Tue, 07 Dec 2021 11:19:14 -0800
In-Reply-To: <00000000000051f90e05d2664f1d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af941b05d2933f28@google.com>
Subject: Re: [syzbot] WARNING in nested_vmx_vmexit
From:   syzbot <syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, fgheet255t@gmail.com,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, mlevitsk@redhat.com, pbonzini@redhat.com,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this issue to:

commit c8607e4a086fae05efe5bffb47c5199c65e7216e
Author: Maxim Levitsky <mlevitsk@redhat.com>
Date:   Mon Sep 13 14:09:53 2021 +0000

    KVM: x86: nVMX: don't fail nested VM entry on invalid guest state if !from_vmentry

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10f21e3ab00000
start commit:   f80ef9e49fdf Merge tag 'docs-5.16-3' of git://git.lwn.net/..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12f21e3ab00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14f21e3ab00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d5e878e3399b6cc
dashboard link: https://syzkaller.appspot.com/bug?extid=f1d2136db9c80d4733e8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1603533ab00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=175b5f3db00000

Reported-by: syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com
Fixes: c8607e4a086f ("KVM: x86: nVMX: don't fail nested VM entry on invalid guest state if !from_vmentry")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

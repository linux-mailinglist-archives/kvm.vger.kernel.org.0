Return-Path: <kvm+bounces-5742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CA0F825AED
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 20:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF54328549F
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 19:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83E1435EFC;
	Fri,  5 Jan 2024 19:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uMrXD8uP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CCE35EF2
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 19:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d4a87da75dso16622935ad.1
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 11:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704481577; x=1705086377; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Os1W0otks4p8LQYFU41smu7zcRJQ/lmP9rJBKnsRe2Y=;
        b=uMrXD8uP+k4qx6ng/rgarL7eFwk04IzrLOQmKo0uD7ho3EaX8mWyZeQnpZQJeE0Vir
         9IAz2qSr0116PTQ7H3BkQid7EQgA1s/i5vXFkCcfekXtI7wGYYpPz9Gc71BXFLRU4uPf
         JVcA7zBtsNjtkRCl2CjE41HGwNN6MftfXOohSTi6pUJYzNx6wAob7deTD9/4JmoSvJAi
         zA4MjAiTNzHvjo5WaJnbDIqr/TIeyOlfC12SV2cEr/WgxNex7IvoIH5p9NIJpIfdCxnz
         5PZo+g0Gkr60k88P1p0M7TFssz0tJseau8LAXS4bPrsWp1QfZLu0OvrLyA6chLsTrLmX
         k3Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704481577; x=1705086377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Os1W0otks4p8LQYFU41smu7zcRJQ/lmP9rJBKnsRe2Y=;
        b=C2SbT9XabbdP9XWboIbr90aBT9kp34uyzLwz2GKD7RMFmz7OLPiTU4Wo5RtnPN0Pkz
         A4uTALblmMByBLZ26l0Dge5KwDnrBiH8Rg4PV64j4QyVRzvS6leZaAxwDdxyDeIrdcl2
         adkeilVWnTC8pNND189ANhdk+RP1BaOR9pNJIxuSS45JT3blHceceQh1yjs5LQSqJk4s
         UrrPHMh5fi2dAq1C2EVW9P5WMqJuZ9vOCUpsz/+uX7fpSiyXFOoKBm7vG3SgvAkVu3Rc
         zNU7nC2Y5jrYC845karImElEkpwTvkTaZ5w65Xp+B5Vv+bVR2SBfQIC2P6fWsvqdDyAN
         V4rw==
X-Gm-Message-State: AOJu0YzrHrsEp7BKhNCDA2RBsdB4gOTNCJ4retg8hH72upItb39cQEjS
	N9cWV8adtfdihNGu+FGe1Fpk/zszJyBE0f1UeA==
X-Google-Smtp-Source: AGHT+IELEkdvAKu0k9buAiPXOoTP3hb61GfLEFtR4FSAaQ/2m0c9cntZwp9OC7jiaj9IF7GVX/byPXm4Oes=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea11:b0:1d4:59ab:36aa with SMTP id
 s17-20020a170902ea1100b001d459ab36aamr75652plg.11.1704481576844; Fri, 05 Jan
 2024 11:06:16 -0800 (PST)
Date: Fri, 5 Jan 2024 11:06:15 -0800
In-Reply-To: <000000000000f6d051060c6785bc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <000000000000f6d051060c6785bc@google.com>
Message-ID: <ZZhTJ899Hzv8zuzX@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_mmu_notifier_change_pte
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+81227d2bd69e9dedb802@syzkaller.appspotmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, 
	"=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?=" <mirq-linux@rere.qmqm.pl>, Arnd Bergmann <arnd@arndb.de>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrei Vagin <avagin@gmail.com>
Content-Type: text/plain; charset="us-ascii"

+PAGEMAP_SCAN folks

On Wed, Dec 13, 2023, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f2e8a57ee903 Merge tag 'scsi-fixes' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14fdc732e80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e56083f7dbe162c2
> dashboard link: https://syzkaller.appspot.com/bug?extid=81227d2bd69e9dedb802
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=129d09cae80000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b8afeee80000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/7b75e59fc59d/disk-f2e8a57e.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f853580d61be/vmlinux-f2e8a57e.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/8c893ce02e2c/bzImage-f2e8a57e.xz
> 
> Bisection is inconclusive: the first bad commit could be any of:
> 
> d61ea1cb0095 userfaultfd: UFFD_FEATURE_WP_ASYNC
> 52526ca7fdb9 fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs

PAGEMAP_SCAN is indeed to blame, do_pagemap_scan() invokes mmu_notifiers without
holding mmap_lock.  This allows KVM to attach its mmu_notifier between start()
and end(), which causes mn_active_invalidate_count to underflow.  Note, the actual
WARN from KVM fires after the underflow; I'll send a patch to further harden KVM.

Ideally this would be fixed before the final v6.7 release, as it would be trivial
for this to cause deadlock in KVM.  The only reason the repro doesn't cause
deadlock is because it's not creating memslots in KVM, i.e. KVM doesn't truly
consume the corrupted mn_active_invalidate_count.

Side topic, it would be wonderful if we could figure out a semi-efficient way to
add lockdep assertions in the mmu_notifier helpers to assert that at least one of
the locks acquired by mm_take_all_locks() is held.  Relying on KVM's paranoia to
detect these types of bugs is not a good strategy.


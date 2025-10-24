Return-Path: <kvm+bounces-61052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62D86C07D05
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 20:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46DCC19A240D
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 18:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 029E334C83D;
	Fri, 24 Oct 2025 18:48:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F1113C9C4
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 18:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761331711; cv=none; b=R9Gxn6eV2kaE9gweg/AfUQ2iPEdmpIanNo2v7WQ87P8PUPIfzX/huFqkWq/yYQHC9wqv4NVF+uepUubc5KNJw8gi898G0X38xBW+2m5Dzh6VvhCxWPY1ah4Q2Z/vH2wWueJDEBttKRjo3wCUEOfFBxDneT6xkQqXSz4XnI4VW7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761331711; c=relaxed/simple;
	bh=Qbb2WYeO0Y8WFZ14ASW7pEL61yKzgWvQZ292QHupDDU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=I5yXvVicegyz/XtNtSr2pSnhSOWPzUGpcsouIMthLYLh6Ar8uPu8UCn3O9LAG6P3iT+ySE/L2klgJmk0+vM2o/9Yh+Ieo9Rx/x8vQKmWXNEk73TMf73L8DfAWfw9rfnHvxCZLmFtUbNk2Uv4iSt71OHFnQAkjDTVhHfOLR/SY9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-430c3232caeso32002325ab.3
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 11:48:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761331709; x=1761936509;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SvEBYgb7SdAK2PWCckV3bk1FK3VYsE3gB84Sjv6d/Uc=;
        b=XwU0oS5mSJr4VfXPRpUma1dPQaK5dtDfLIFoG6r3+3T1T6SU8T+Pm3QLcDQumAhwqs
         71GogptZhfN9gUsMkhzVWqTuJlrsY7Z/p4fGTH45Ktn9/lSxt+Zg7FjXX1xSAQxlbHCW
         NY/SMcGhaVwct5nr80TXNSrS0YGK4uhyPFpt028qIqm5TlxGMtHfjvz2SKwlvTDPX8Hf
         Kg8l6FDe3LWgB3oq9rxOY7JABk6lbSZs86ecnVYuCNzC7wcQDURgAID6LlbwEo2PwCSN
         QOlsV9tcX1R+1WmJbC/Cl0z7KCxJS2nk+rTsfaVNKITUxF4BTdY0qTP41i0rrVxAq3a4
         ECwQ==
X-Gm-Message-State: AOJu0YzhHqc2ZLRZHdHPWjJ3X2R955hCi3ASYUf02Eof/uY2mZT85iIw
	G81KwiM9nduwDw3go6+MH5VQXR9mJng5PgvlrFvM6vR6bU3EMpAnzfHFj8fSNVQ8E0SMD6NL3M9
	O4Wpt+qKwE2IfRbt5jFkzE4Zcxlx+44/RX3N0Xj9WdxMN4fcj67rW6t3Hhuc=
X-Google-Smtp-Source: AGHT+IF/3GxpmN9Z4MVOoN3pe7SsYeyW2mKEyrmDk5OqUd6R5+YUMUFUNXEnZpMNPGTKBeMZgPcHVwrggtrKpOQ1ZOAySJXdfKZL
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1745:b0:42f:94fd:318f with SMTP id
 e9e14a558f8ab-430c521f9e2mr379341475ab.9.1761331709225; Fri, 24 Oct 2025
 11:48:29 -0700 (PDT)
Date: Fri, 24 Oct 2025 11:48:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fbc9fd.050a0220.346f24.0157.GAE@google.com>
Subject: [syzbot] Monthly kvm-x86 report (Oct 2025)
From: syzbot <syzbot+list4c7e56cf766b2f61a4b7@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm-x86 maintainers/developers,

This is a 31-day syzbot report for the kvm-x86 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm-x86

During the period, 0 new issues were detected and 0 were fixed.
In total, 3 issues are still open and 76 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 655     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 153     Yes   WARNING in handle_exception_nmi (2)
                  https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
<3> 24      Yes   WARNING in vcpu_run
                  https://syzkaller.appspot.com/bug?extid=1522459a74d26b0ac33a

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.


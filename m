Return-Path: <kvm+bounces-48701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D50A3AD1390
	for <lists+kvm@lfdr.de>; Sun,  8 Jun 2025 19:33:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B6AE188B4F5
	for <lists+kvm@lfdr.de>; Sun,  8 Jun 2025 17:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126141A9B46;
	Sun,  8 Jun 2025 17:33:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5AD2A1BA
	for <kvm@vger.kernel.org>; Sun,  8 Jun 2025 17:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749404006; cv=none; b=MNjPSWtGhqlHMxgEwyWfUpqYueMIX/vtdzm442O5KSivH39lZwYasmsXKVTONgpPiR5O9wcgk3THCKhO969xNz/QaZz/CJmTYDH7X0EUgOz7DLIh1tFEmOCwUTmPPlkh3LgbqMXLRWuVDg9A7HcQp1RreHy/n/LVsNoUz26DCtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749404006; c=relaxed/simple;
	bh=1dcZaILzSakXHRsTkrO9kppM/tZMtQJf+QX2iJF1Fxw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PhLXWct3KBiAefF9mMmC6HnClUKU5QcHCcz3pnmxQXBqHo9NTUE/et3MLM6eTkH+qaE6Rd0cy1LmBnJpKXR9fktLeoDSePymWMTe0vmrGW8n0tJQ3UPPMXU3eCu+gFJq7joSyltWdEMe+7DpZVFaKSvoxPNejdrMhpasS5erlYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3ddd90ca184so7112955ab.0
        for <kvm@vger.kernel.org>; Sun, 08 Jun 2025 10:33:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749404004; x=1750008804;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oFW/NuTEn5TNLyBWHCBQOAd2Uud9j7JfPOBL+FUkB7A=;
        b=iBbaTFaIOZQG9BrS0puJxl2jVm6XlUX8pJMaJRsiEmggQLg0oQQcfT2PdK6qwB9XOP
         Fng9Cyn8yyKExDvnvPHDPmkukixEmfLKAlmMZbP4dF/mvl0VzoFWv0R6mLSv901eL9S3
         ooVAZahBiP6LNnku7oiBq7WxnaltWy2HIXN9dv8Ebgl1A+noN6URkdJEGUCyD0wTxBDE
         CsSpcl9fpKudIzH44SfOcnK57HBg7IoYDoxiiEkDgJEUnbfcSM6c/hTSNQI9+aSUy8Zs
         UQ/z48V5DgkBDDZHqyzZzUz6wXvaKubx003/d2iGSSk2y9K7ipEUaqWp1xj0ccEqQaU8
         WC6w==
X-Gm-Message-State: AOJu0YwpeMP4v5rGXY++DFkAUgBb8LvHsXftCBqNjfqppCLS9jxsPkX8
	GFOFMiu/SdGdLE2MAov9pJ8LJWQ1YzTl1UIaSI0Ld1uELB3quk+pd4KqFQS63ECm+yQYN+hDREQ
	EUHZKJq7VCoxkoH9mNzdi4ULOi1GZuoC7vHxoCqKWOtoeebBpCwrDIXz6kb0=
X-Google-Smtp-Source: AGHT+IF0lc9ABofCUqs/RisGvJeLynT7Jt763hXtaN8l8QPAdT4+vCu+y3llhHTSImkSLUsFk4KE5uQJZ/N4Vl8hJase3ANmr23G
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a8a:b0:3dd:a4f0:8339 with SMTP id
 e9e14a558f8ab-3ddce3fe9damr119300195ab.8.1749404004336; Sun, 08 Jun 2025
 10:33:24 -0700 (PDT)
Date: Sun, 08 Jun 2025 10:33:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6845c964.050a0220.daf97.0af2.GAE@google.com>
Subject: [syzbot] Monthly kvm-x86 report (Jun 2025)
From: syzbot <syzbot+list7793d6728ee703d6cd2d@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm-x86 maintainers/developers,

This is a 31-day syzbot report for the kvm-x86 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm-x86

During the period, 1 new issues were detected and 0 were fixed.
In total, 4 issues are still open and 2 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 585     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 147     Yes   WARNING in handle_exception_nmi (2)
                  https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
<3> 6       Yes   WARNING in vcpu_run
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


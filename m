Return-Path: <kvm+bounces-67704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D4BD11488
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:41:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 083C530ACE04
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 08:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D94D334320D;
	Mon, 12 Jan 2026 08:40:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE947342529
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 08:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768207236; cv=none; b=QAeHfARdkrC8bcFAV/0X7gQx6HMX014B3ykUQzOGLsd6kjMnjhhlKtXQsXY0qC2fA+6G185cJtCQBy8giXXSQVqfteW9beH8+qFhyTYY9PMSgPp3jEtuUVt2EbudulSHynwNbbumWklzcuyAakoOxmLDJ3S8oOITozHuQzgLY4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768207236; c=relaxed/simple;
	bh=wyDBDkTtk6G7w6AHFfqdlfQSinv49LnsPo8nuwFZCQY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jd2tKYuZxxekZvF8rmydZqtt09YzthEw6wqmWNyAARrNQ5fPkmoobikYIuQzZDuhBUZrw5bwjiYxXoAXx89+2HIe+ZoPWYtB+/ZOiYtr5m5n9k7twot5WCSVHL6bofd85yEIr/8dXdMqLvyEfWWbkx/A0I9hRiF7FnBwRJfh/uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7c7028db074so18268319a34.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 00:40:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768207234; x=1768812034;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gparABUglWjoRW7xpv3rlbYer4LDYJ2R87NuDCttHCw=;
        b=VaHl0Bz/JjGER6szmHkjhXFKQezoBculF73PM+uIemCzuhN4D3hitQnagW485GcPlZ
         LJKzNe/dPt5EH27BYTTfmJATp9q2vUaBg0N+hOc+ToeQYOwQSrPUiIQu463twx8YuYmr
         0Xo3B+RNfRBD+QWW/KZsZPfp0DqQQKGD305XG8iVqIst4+O0+rTeMzNT1ZDvhvBv0gsb
         Z2jXNGckcplUzh5yrEdL9rpkYaI81+MPv4mI77C8YwqSNk3zKEPmN7O/3lI56oK3uhWx
         K+i6fSg2jXCCsDfwRdgfJPiUtse5QZaFrwKf+nvDH/HmgO0DeNrkR9AbKM6COOQUk+eH
         enLw==
X-Gm-Message-State: AOJu0YxF62bVHGR7jGV+vEe6fFNhlCONMzaEuSIGQ0Q9y2pdXfw/3Ad1
	Cat+BNwYqELaBmgpaomN2Dj4sqph0jo8vvJFvjD7wtFBZ09L1S8z7ZOLnUMEirXZI2cCu9iJ0At
	l8w2BI4m8EuGgu1/a8IGwqXZexkQ3qvJ60H1PXdM3Ns9RIfONicXlmYzyywQ=
X-Google-Smtp-Source: AGHT+IEdRombO2HyVM7sGgtNedsJB665Id7Q4qIo06Zc17es4XydB6IFsTQJ+e5MamyODkiN7CP26tawFPku3NIRGZ/4JKskMfJL
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:dd8b:0:b0:65f:6c35:688c with SMTP id
 006d021491bc7-65f6c357120mr3082154eaf.26.1768207233841; Mon, 12 Jan 2026
 00:40:33 -0800 (PST)
Date: Mon, 12 Jan 2026 00:40:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6964b381.050a0220.eaf7.0091.GAE@google.com>
Subject: [syzbot] Monthly kvm report (Jan 2026)
From: syzbot <syzbot+list5240cc45942723eeb3a7@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 1 new issues were detected and 0 were fixed.
In total, 7 issues are still open and 65 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 660     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 49      Yes   WARNING in __kvm_gpc_refresh (3)
                  https://syzkaller.appspot.com/bug?extid=cde12433b6c56f55d9ed
<3> 12      No    INFO: task hung in kvm_swap_active_memslots (2)
                  https://syzkaller.appspot.com/bug?extid=5c566b850d6ab6f0427a
<4> 4       Yes   WARNING in kvm_read_guest_offset_cached
                  https://syzkaller.appspot.com/bug?extid=bc0e18379a290e5edfe4

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.


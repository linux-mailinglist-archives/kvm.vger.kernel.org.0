Return-Path: <kvm+bounces-6469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBEBC8327BA
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 11:35:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86B0F285B29
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 10:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B054C601;
	Fri, 19 Jan 2024 10:35:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1234C3A9
	for <kvm@vger.kernel.org>; Fri, 19 Jan 2024 10:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705660522; cv=none; b=abm8ZbRKwXXjbR7N4I8gr7qVljehNalyZGg5q3jZx64RvXdSpXRuBLciPV2+58jmS3PPqIVgtrFzFySAZ4LqA1re9xhQ5uHbAysQ5v1osCADoecpTRDQKO1y2SbwoXnZVlTeORxoRGP4t5u9G8U7xDk8nKbDgLTbCaA+k1rzIfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705660522; c=relaxed/simple;
	bh=BhEGgF0OYX2mQw+WrrUpp/YrCQRs2KNvxx0wZlc01Dg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AqHOeIdgi69kJ/N3xm8YcsVlegucasZVGPfI5MHtYQmwsMvttnplH1ynwksX2QoA5sqSCrcx5vmfuvyl0TaT+YmM33FzMcJM1J8gohxTHtAcJlTn+8wVwCpoIY1Bn3ojkqxe+6oXB5SAYffdTX2QSZq9aplEvloWC03Gch73qh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-361a86fefc8so4392685ab.1
        for <kvm@vger.kernel.org>; Fri, 19 Jan 2024 02:35:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705660520; x=1706265320;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1UIDjj9OsfkkoStI3zGZF5cD6xSEckZ9X8zLbwdDtD4=;
        b=VcLooMKS//OGnLUq1/ctTxDA6fymDWfPehki5Vz7uINQZth9OYj+Jw6a3Ua6h6pXjI
         qSYmkjSMmu17//Kxta5kIOJD0ga+uDQOj0+x5Abez2uD5QdaxspuVJDQbpDr0xszWcKu
         ga2EBCoEqoOGli4awtxAa31Nnv59eKQ4hgAG88afkO9aihv3zBI5cQmnbpnGlhf++yzO
         sRAuXBiqDQT4XiKERZkYeeNWfBcJX6ftUQE1s+4U1d/YjDERj5/dZLIOA4eq3MzIff4p
         c0/WVyyCHLPAyHUb+IOFKA1mfdp3/kfFN7VsqgHH8LiXriY4E6rS41Ioipwl4asAc3X+
         2dCg==
X-Gm-Message-State: AOJu0YwNFaAE9aI2j7rmVHk9twxljic6NlYTM4sKxJ3Fs2CPvDa9r7H7
	dJTUxKuQyYOH7tNWa0RrwnfW8ZMFbMWt8gFmubdDcFRYUh55bLNi6D1mN9MRp1LqZbE0k+3mAx/
	Ch9v1Do33EIg31xKOa7+s6n8yCs+tv4vHWgBif5TWssarGD8UU3pqg+iI0w==
X-Google-Smtp-Source: AGHT+IGHEU37cQLH//DqrajLoG2tlcaOASabuDbeyIR1Mbx3cew6fRhHxnf261L+e/iAKTHwYsUt8tPGvVCSBaKAwRgUlDJnQdcX
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:156d:b0:35f:eb20:3599 with SMTP id
 k13-20020a056e02156d00b0035feb203599mr340146ilu.2.1705660520523; Fri, 19 Jan
 2024 02:35:20 -0800 (PST)
Date: Fri, 19 Jan 2024 02:35:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006ef256060f4a0957@google.com>
Subject: [syzbot] Monthly kvm report (Jan 2024)
From: syzbot <syzbot+list412afdd37eacb0ca532d@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 0 new issues were detected and 1 were fixed.
In total, 3 issues are still open and 109 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 146     Yes   WARNING in handle_exception_nmi (2)
                  https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
<2> 44      Yes   WARNING in kvm_mmu_notifier_invalidate_range_start (3)
                  https://syzkaller.appspot.com/bug?extid=c74f40907a9c0479af10
<3> 26      Yes   KMSAN: uninit-value in em_ret_far
                  https://syzkaller.appspot.com/bug?extid=579eb95e588b48b4499c

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.


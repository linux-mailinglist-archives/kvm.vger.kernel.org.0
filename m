Return-Path: <kvm+bounces-71120-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mNv0APUOk2k71QEAu9opvQ
	(envelope-from <kvm+bounces-71120-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 13:35:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ACD11435DB
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 13:35:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A0473020024
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 12:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E726E1DBB3A;
	Mon, 16 Feb 2026 12:34:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0DE18C2C
	for <kvm@vger.kernel.org>; Mon, 16 Feb 2026 12:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771245287; cv=none; b=urHpGttthHHsWELu2fqMii8qUXLbrktr8E8knQN4BUqPTdlp9tC/BNc+4Qoxna2HzHTKbP40w+Z+7NSYAPISYEL5Z0BSoEqfavhCApPV/qmgseNTv/BI7hNyEJDIhSg94TA/2Ma7nNN0DKP6BBSpL8nznX9UQzyiQV7hOfhSkEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771245287; c=relaxed/simple;
	bh=HnCurXXzI+RKwF/jEpyh5slxEQqX9Dyn27KBG2qWdL4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=on7eLUfU1q4FjKIaYlMv25/upZh0OqPMkbD6V9c6XRyns5S5grqGLrswt+brvgmt56UFKCIaLB2Q0rR0BYVJDA5HFlwbQUm+6EEZ9O6iW5S1yIrbkvmqXQSHqxEwKW8ACRcECX2ngfqMAVkHAI8NWni79IRwGrCiaVbOrpM/rls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6795b03ffdbso22149011eaf.0
        for <kvm@vger.kernel.org>; Mon, 16 Feb 2026 04:34:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771245285; x=1771850085;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kczPBrNeI+Up+vKnvezlM2R/1VPvN4R84UaGjAarpBA=;
        b=SFV90X58kdQQv77BwXeYTjlOxCORSVANr2ouuaobPqUL3gymyLbFE/6aQX/zWr406s
         a54LNxmKzEl9H8fnbH1iqzOFZID9aHo6xAnQzxgZg9aNZNfjYS1Am9KoZV9OP4Lhocfo
         ty1WWMiVCj8Bq2BmiGrYPL3CQHtCOq4kq9KDHD7zn+U2NKWnjAhRKJfQOXq1j1WAG+lN
         pBSiuQFCqSR5xwpZDQi44d5qhMAbyN8b4BBgsXraJdpL3yz2lJdH4ujJrdFDf5CGJZog
         qWy6SAVV5t2ruRCwNu3bvLJtLogunR6/nlvp2dzTXUCHUZLWBDDO2lFCraqKNQ+XAsED
         j3PA==
X-Gm-Message-State: AOJu0YyvfX9OHHvOnT3uMwNgT81ngg0SXZIN3P7scVv8Ly7YabS9qIPY
	UQMj72tN36FtM5WMouqRWNTnoeol/dr/MskCuteR5TfLRysBHj+hTilIXLoG2M3Ys5tS44Iaip2
	p/zFY30TUa7GvqwFnFn/IiZ0EaoQxYs+CxaE0SbkEdHWBrEidTp7iDU6u1G8=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2913:b0:662:fef7:4dba with SMTP id
 006d021491bc7-6776757d58dmr5745836eaf.32.1771245285405; Mon, 16 Feb 2026
 04:34:45 -0800 (PST)
Date: Mon, 16 Feb 2026 04:34:45 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69930ee5.a70a0220.2c38d7.00ee.GAE@google.com>
Subject: [syzbot] Monthly kvm report (Feb 2026)
From: syzbot <syzbot+list02fb3dc9d4431bfdbe43@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_SENDER_MAILLIST(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	RCVD_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[googlegroups.com:email,syzkaller.appspot.com:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,goo.gl:url];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71120-lists,kvm=lfdr.de,list02fb3dc9d4431bfdbe43];
	RCPT_COUNT_THREE(0.00)[3]
X-Rspamd-Queue-Id: 5ACD11435DB
X-Rspamd-Action: no action

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 1 new issues were detected and 0 were fixed.
In total, 9 issues are still open and 65 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 672     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 59      Yes   WARNING in __kvm_gpc_refresh (3)
                  https://syzkaller.appspot.com/bug?extid=cde12433b6c56f55d9ed
<3> 1       Yes   WARNING in virtio_transport_send_pkt_info (2)
                  https://syzkaller.appspot.com/bug?extid=28e5f3d207b14bae122a

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.


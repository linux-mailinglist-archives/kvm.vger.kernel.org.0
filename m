Return-Path: <kvm+bounces-70717-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aPAeC974imlBPAAAu9opvQ
	(envelope-from <kvm+bounces-70717-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 10:22:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B1EF118CF3
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 10:22:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C20D53025C7A
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 09:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2347C340A47;
	Tue, 10 Feb 2026 09:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sSTsGN2E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239F91E2614
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 09:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770715350; cv=pass; b=k4+Pl++6XYtE3tJ1lZJz9OhUiE4Nw8pGOr3x/w000HtRtsE445aO9VvoAMl8c+WuKHwf9RlR64iLW6mP5I3u/OPawNPW96rMiVHGk0H7Fo5KbUkcN7ZrKvAvqmp7SAZo1R1nnfVj5CdC20QfqNcBk/mS40LtTvaYj+eS14zgXHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770715350; c=relaxed/simple;
	bh=y9zYDx62HVictZMDHCiD5cIRkjcNm0MX0ytHmaUjLPM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=krbu4MqO3EyYdnDvKq9hXRp4nsTPnqlMYMyj64uAYZ+0sDjzGqlE5TtgqtinSLwI0+N1HwouHe1RMRoSvst81KRcitxmyCIfj9lSb6Sxa7P9wjPgfmk5MZJ0M5jeRpcLe8y49HjTn1kXD0VlG24vF0aKWv+9QxegFo5xd+bbUzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sSTsGN2E; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-502f101d1cfso5275631cf.1
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 01:22:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770715348; cv=none;
        d=google.com; s=arc-20240605;
        b=kif7jq/1LKJjiIARtmp1RzIXlq6Ebf8pIKP8ZgHCHgsp692NsGmlLq4wVbYz9vBnKL
         8MDYTKNaQzoJrFdhIUVqCzGatsnbEQf0kY0HAR0o2yZYMFkKmAFvJ6VlHMU2bnRMGI25
         K5yBNVGyp3vqdcVbJ6TLlqb2d1TY1Fd6ZzguFsG48OBaRqYlAWRyKcwrvJfvoLtGz41y
         8Bgca20JEYvyTMiRzcIt9JASjxmRzpj5Zz2uZBPRdsp1P6x3f7moDs2v5p3irvlkufI4
         wxIl200VIxBEE23zffNSqp96LTplIwFx+0LdpZSuNUuNROUtG2jB88u0XpAZ+b/Xax4V
         zzlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=32Lu0Pd33hhvXoIe91JhogGWm4cKPIj3zXWse6rrNbk=;
        fh=kvaPRe4hpzgO/OBKpZoB6NPL66NdrlIYLfD2cf+RVyg=;
        b=hGG0qdk710lCue/5I8SMNRHUBsk3G7VWDSmOwxQb7b3Xvi61uO2XVdBCm/yoNV6rzq
         27XAjkXmBHRJWYRNzL8aNSHh/f14h85GxWQITZR5qogNboulhy1b7T/j++18PCgzOWcT
         ZgV8aEgpLKVOmTmdU6e9mkUv2bvFz3r9TXTF9acwKsnxx/5mY/9z+LtOd5jDuFtREOjV
         iCRlYaIIuim+7qWhAT05CcPbQyLHG82XLPkiCNRQe1WR05wpDxnKzsPpnVWFHbWXbpQK
         I09lY5fzCyik1SUpDH/OMUxtdvIg6tG+7k9WmnaZ97ttHoKFip5BfV/npfheFN1TM6Xd
         WCIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770715348; x=1771320148; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=32Lu0Pd33hhvXoIe91JhogGWm4cKPIj3zXWse6rrNbk=;
        b=sSTsGN2EMCiZpbIMPhR/LppXStTwYIAqMRAZhjZrzvJc4YvBxMWWdfRCjhgtlGGL6a
         aLzVPOGI2RKxXt83Oz/m6A0TrgKthc5LvCULZ31V0oJg69oaW6xPWnM6E7sTfmo5yBC5
         txyTpujDdz2L2YEmo4wjzvS6XNNFWCzKTEApPkbFeM93rMR+GZKMFAOPm1b81JkJ2hN8
         Bn5sB2zyFQkNg9dI2dwVWz5PNCZIW7k/3e+O3N/T47AlN0Db3xUM0xyH985er+rgTnvH
         YhlaCjREkOsBj2MX0N7ZREiEFEn5kR56qui5Eb65fQzuaZoraJFrQ534a0xxuohRZhjh
         HBCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770715348; x=1771320148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=32Lu0Pd33hhvXoIe91JhogGWm4cKPIj3zXWse6rrNbk=;
        b=HrULQ/l2i3MAoBT4OqDl+ESZHTWNE7Tts3bbRvrfeEpzz5qUShGRKqMUj7FNYsfanf
         YKp23Ug+w5JGu9KaF7bXj9BfeATRymIiH6nhkRHeQHqtTBnqFlLrXXmPCzHoA4Ce4hi6
         e7Uu6QhgxEuaYuXIFx2u3mFe634gVV9xWuQWrvGkSuLyOWHg3fSn4yM+h0NQztVlwFy4
         g2UGwfwU5GSk7UCecZS42XTwlyPAj/MmWeLWnuU3yspl5FfduqbHViQhAfUxVjLAoSv/
         MId+SPG9ouAvNeO70CeB1uJrdJWKvWfGtySX+2f/uejPxLZ+3CeaTZValZtUUJc2SZBv
         EAfg==
X-Forwarded-Encrypted: i=1; AJvYcCWF3BTz8oaeExkyxo3sIdMSsEYGsJ7oUKDxq6Jn9I8KH6hTbdJhoL/tLqhek2w5kjtf3cg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmUk887SZcOr4l3lyOukY6bb0MWZv9csHmyMKBWPRzGN+84uwk
	3/ilEDYLzmH4xeQP7ZTeJ8jIe2rPzP/gZ3yKdxCIZDZZmOJ/xrrWMnTiAGzZNvkL5CbOgtLOVyT
	wEFQij14pLXXvuZIyaA7VX4dU5UegU3Sshm2LgpSb
X-Gm-Gg: AZuq6aIU45o7cMfHlQJWbcQ0dTlvmTKbl3OC5/et+rwtc7ieOYFyYr45yOHIs776ClU
	0mKtzvUnpDa2JyaBNFc3wknINM8vBfm2lmeXFxR4Qh3ImpS7UBHCEBVTaWtHpOB43FknadnQlmt
	17tJcZf1anV8aBQAuyRoCgvJbV5XQEGZ0BAIFnETger0FXu0nLbx86qBGtFRumq0jncU1ZXtZNB
	fnTs1ztMng0e+J+MbBhvnLy9kTXvymmtLTxNdCzhIywnvRG7NZ3JSWoTqdYjwLA+/HiI42caqDS
	5IMnGJv9NAYemHAFsx2Gzerpwo5X9a29HiVAMQ==
X-Received: by 2002:ac8:5a92:0:b0:4ff:a40c:c6c4 with SMTP id
 d75a77b69052e-506398d45f6mr182516091cf.15.1770715347868; Tue, 10 Feb 2026
 01:22:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6877331d.a00a0220.3af5df.000c.GAE@google.com> <aHfD3MczrDpzDX9O@google.com>
In-Reply-To: <aHfD3MczrDpzDX9O@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 10 Feb 2026 10:21:51 +0100
X-Gm-Features: AZwV_QjDYsJUod-JkOMliF8IMkm3bq_KZzCdp0B4M8uEzcaSBvrrmPgHz_hnStY
Message-ID: <CAG_fn=VDPHArKRYDfpzipbWMQ9Zu1S8GCpAXmmOw=hGEyWnqeg@mail.gmail.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_read_guest_offset_cached
To: Sean Christopherson <seanjc@google.com>
Cc: syzbot <syzbot+bc0e18379a290e5edfe4@syzkaller.appspotmail.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=8d5ef2da1e1c848];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70717-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid,appspotmail.com:email,googlegroups.com:email,syzkaller.appspot.com:url,storage.googleapis.com:url];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[glider@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm,bc0e18379a290e5edfe4];
	MISSING_XM_UA(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: 8B1EF118CF3
X-Rspamd-Action: no action

On Wed, Jul 16, 2025 at 5:23=E2=80=AFPM 'Sean Christopherson' via
syzkaller-bugs <syzkaller-bugs@googlegroups.com> wrote:
>
> On Tue, Jul 15, 2025, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    155a3c003e55 Merge tag 'for-6.16/dm-fixes-2' of git://g=
it...
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D103e858c580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8d5ef2da1e1=
c848
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Dbc0e18379a290=
e5edfe4
> > compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for=
 Debian) 2.40
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D153188f05=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16f6198c580=
000
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/d900f083ada3/non_bootable_disk-155a3c00.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/725a320dfe66/vmli=
nux-155a3c00.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/9f06899bb6f3=
/bzImage-155a3c00.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+bc0e18379a290e5edfe4@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 6107 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:=
3459 kvm_read_guest_offset_cached+0x3f5/0x4b0 virt/kvm/kvm_main.c:3459
> > Modules linked in:
> > CPU: 0 UID: 0 PID: 6107 Comm: syz.0.16 Not tainted 6.16.0-rc6-syzkaller=
-00002-g155a3c003e55 #0 PREEMPT(full)
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-=
1.16.3-2~bpo12+1 04/01/2014
> > RIP: 0010:kvm_read_guest_offset_cached+0x3f5/0x4b0 virt/kvm/kvm_main.c:=
3459
> > Code: 0f 01 e8 3e 6c 61 00 e9 9b fc ff ff e8 14 25 85 00 48 8b 3c 24 31=
 d2 48 89 ee e8 16 bf fa 00 e9 2e fe ff ff e8 fc 24 85 00 90 <0f> 0b 90 bb =
ea ff ff ff e9 4d fe ff ff e8 e9 24 85 00 48 8b 74 24
> > RSP: 0018:ffffc9000349f960 EFLAGS: 00010293
> > RAX: 0000000000000000 RBX: ffff888050329898 RCX: ffffffff8136ca66
> > RDX: ffff88803cfa8000 RSI: ffffffff8136cd84 RDI: 0000000000000006
> > RBP: 0000000000000004 R08: 0000000000000006 R09: 0000000000000008
> > R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000004
> > R13: ffffc90003921000 R14: 0000000000000000 R15: ffffc900039215a0
> > FS:  000055558378f500(0000) GS:ffff8880d6713000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000000 CR3: 0000000025de6000 CR4: 0000000000352ef0
> > Call Trace:
> >  <TASK>
> >  apf_pageready_slot_free arch/x86/kvm/x86.c:13452 [inline]
>
> kvm_pv_enable_async_pf() sets vcpu->arch.apf.msr_en_val even if the gpa i=
s bad,
> which leaves the cache in an empty state.  Something like so over a few p=
atches
> fixes the problem:

This bug is still occasionally reproducible on an Intel host running 6.19.


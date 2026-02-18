Return-Path: <kvm+bounces-71221-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMrOCMCclWkESwIAu9opvQ
	(envelope-from <kvm+bounces-71221-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:04:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A840F155C75
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:04:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AFACA300B447
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D88393090DC;
	Wed, 18 Feb 2026 11:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e253DugB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4082FD1BF
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771412668; cv=none; b=SM+0tcaF9/huuD6LIiKTTUAfazjY5X14eYbTXMjTraximkFIc5x06hpt9zVteP6Hauk9WKaeimrrLyAhuMf+AKVZjAdhCLoQDaCVPtEF37dvGu1TeYWaJrLv3c704CyyRlw3scVouYZB4Kv0wJEgbioIhZK+VDQ/vcN91gEqUyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771412668; c=relaxed/simple;
	bh=5VnWZTXyFDazagkCSCC3TMyBBNtU4cm3h/HSudoB1AI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pWnkZ/VamLcLLJm8WrQ3+Xo7ABS0CktIviMlIBzWhxEPjsR7i7m3qVievEJGRtN4irW9YUPVJbfI4DBcJ62flhOE++0PSoqfKJDv6g69zBJoXpZUtENf4ldGc8ClksxSjgN9pQ7KVzP91A9+Z6WWT8RZ065sN2ExQ0JEhyWiBPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e253DugB; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4376acce52eso3358091f8f.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771412664; x=1772017464; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wGTNJ210AsARI4ZD14nsycGl1kgt7uuJ79e/H8Vr1rM=;
        b=e253DugBxCjbBY43h5ZQzbNbQcGmBv+/lp/f51dolSrRbG4dpbIAsfHqfxbTRyhGpZ
         iJF96EZbLEDkM2ASa3EjzaXE7NJ4Eudy7hgDYwJf3E4dER/rDOREABkaL6ltNkclu959
         riceaGSX8KBXHbywPqssl5lHUkRsViVCTm3ZNgInsVWWrcUeKwPWGw95lpWHC6B/3GlR
         iX4t6HRti4m6/em3AXYE5dIBFhL4e2iih/a4J/KXFTA7s31+u9kNGgo8OudRaR8Rccse
         fBZ8fRj8RxOpGuaCAGm7kSGZFkmcH1fC+KSDABM4bbJNojWEy0CPXG77mrB3vcn/JnB9
         DmHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771412664; x=1772017464;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wGTNJ210AsARI4ZD14nsycGl1kgt7uuJ79e/H8Vr1rM=;
        b=a4jBExirwfZQU2U2GXYKEmTNbmqha/tTq3BVq7+QoiyRqLmuzDSj/20bkkF6v9eQ1m
         LgZpA6UTveMX41Nrie0nsP1WMkmna9HtC4nM5F+AuqnameWxaNLUEb7bBsoJuVf+Vwja
         LCmYh1/SGTj+q66lJglRJGYPgbDdTiWmrynFiaOUOWfsPEZa/j7wfcFKjssOO3mjZEIE
         FhP7oYmXzmNSaZLjDtNUDRQk6iZAsNKxX2wCdEaQmv6Trddb0cmyh7WhAGe8K44eIVog
         fXE6D1KwwTHffZvFt2pUWcrORcY8sv5/SeMpbZWxifWp7toyDuWt/L1wZCCX2WAxwMtg
         MwnQ==
X-Gm-Message-State: AOJu0YymPcc80iQTbR1ko2P3J9GNT+XvxTZl7q9qxuU50bakHy8yMQYT
	JiiFfGFubPRk+Qf6PzljM+N4Vb5yndpHXAR2UnZtyITLd/jM1crSy9QP
X-Gm-Gg: AZuq6aL29dw+Nc5qm73hGWGgqKxIZfcpV8X9hffs/vsXqC+sm0JHtRXdCRgtszQB20I
	uGFhIItGii2zOAcN1QzT89YvnTXsdPKHWzCkemEdcfOpdRUEpDG4ENYe2pdPD34ETG4bEkRAp3Z
	NcT/VgSCC9i+6JnklIwnx62Hz1gdLmdLAPnUoUiQgQz02qVowXWk6uao1kiPWEmrrP9BfS8TN4t
	k+SrPJHsNj5J4RHIo5JWMXR2XkCO2Ias92dH9J0BTQFWnUE5YteTt/GiAesAHIR8VxezpZIhzC5
	3R9bfpKshb1A2gW5pfKHzQ+Zkx0dK31lqT9hBnVUxImV47IU2yi9j5wMyTigUwDyv+WRAYTxa0Z
	jhe6jrPnp6G/epZX4XI5jXccYzY4myd7bzPgCUMLjnrGtQOQlTcA1Hh+9Z82xayXd9on4G44x1z
	TsrdiHqZssuLDP2o4yGEncYYJIas1TH6W6OvezJ6/vB+cNbA==
X-Received: by 2002:a05:600c:8011:b0:483:7980:4687 with SMTP id 5b1f17b1804b1-48398ad6e2bmr24556715e9.17.1771412664161;
        Wed, 18 Feb 2026 03:04:24 -0800 (PST)
Received: from debian.local ([2a0a:ef40:e94:5d01:a218:5589:9f9c:4f52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835dd0deeasm539209745e9.12.2026.02.18.03.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:04:23 -0800 (PST)
Date: Wed, 18 Feb 2026 11:04:22 +0000
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-pm@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, pbonzini@redhat.com,
	seanjc@google.com, tglx@linutronix.de
Subject: [BUG] Oops following "Invalid wait context" in pvclock_gtod_notify
Message-ID: <aZWctruDVn8aMZBG@debian.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71221-lists,kvm=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chrisbainbridge@gmail.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A840F155C75
X-Rspamd-Action: no action

Hi,

I just saw the following crash shortly after resume on AMD HP Pavilion
Aero Laptop 13. The laptop resumed, I typed 2 characters, and it hung.

The issue appears to be a recursive Oops:

Lockdep first detects an Invalid wait context in pvclock_gtod_notify
during a timer interrupt update.

While printk attempts to report this locking violation, a General
Protection Fault occurs in lib/vsprintf.c:string due to what KASAN
identifies as a wild-memory-access (non-canonical address
0xe000123080000000).

It appears that the pointer to the lock name passed to printk is
corrupted or pointing to uninitialized memory during the resume
sequence.

I haven't seen this particular issue before in several years of using
this laptop, so I suspect it may be an intermittent regression.

Kernel Version: 6.19.0-09985-gaaeb3769f82e (Tainted: [Not tainted])
Hardware: HP Pavilion Aero Laptop 13-be0xxx (AMD Ryzen)


<6>[207132.447702] ACPI: EC: interrupt blocked
<6>[240547.393406] ACPI: EC: interrupt unblocked
<6>[240547.528470] amdgpu 0000:03:00.0: [drm] PCIE GART of 1024M enabled.
<6>[240547.528481] amdgpu 0000:03:00.0: [drm] PTB located at 0x000000F41FC0=
0000
<6>[240547.528545] amdgpu 0000:03:00.0: SMU is resuming...
<6>[240547.528930] amdgpu 0000:03:00.0: dpm has been disabled
<6>[240547.530414] amdgpu 0000:03:00.0: SMU is resumed successfully!
<6>[240547.607233] nvme nvme0: 8/0/0 default/read/poll queues
<6>[240547.638821] [drm] DM_MST: Differing MST start on aconnector: 0000000=
0f24b38f1 [id: 116]
<6>[240547.640280] amdgpu 0000:03:00.0: ring gfx uses VM inv eng 0 on hub 0
<6>[240547.640285] amdgpu 0000:03:00.0: ring comp_1.0.0 uses VM inv eng 1 o=
n hub 0
<6>[240547.640287] amdgpu 0000:03:00.0: ring comp_1.1.0 uses VM inv eng 4 o=
n hub 0
<6>[240547.640289] amdgpu 0000:03:00.0: ring comp_1.2.0 uses VM inv eng 5 o=
n hub 0
<6>[240547.640291] amdgpu 0000:03:00.0: ring comp_1.3.0 uses VM inv eng 6 o=
n hub 0
<6>[240547.640293] amdgpu 0000:03:00.0: ring comp_1.0.1 uses VM inv eng 7 o=
n hub 0
<6>[240547.640295] amdgpu 0000:03:00.0: ring comp_1.1.1 uses VM inv eng 8 o=
n hub 0
<6>[240547.640298] amdgpu 0000:03:00.0: ring comp_1.2.1 uses VM inv eng 9 o=
n hub 0
<6>[240547.640300] amdgpu 0000:03:00.0: ring comp_1.3.1 uses VM inv eng 10 =
on hub 0
<6>[240547.640302] amdgpu 0000:03:00.0: ring kiq_0.2.1.0 uses VM inv eng 11=
 on hub 0
<6>[240547.640304] amdgpu 0000:03:00.0: ring sdma0 uses VM inv eng 0 on hub=
 8
<6>[240547.640306] amdgpu 0000:03:00.0: ring vcn_dec uses VM inv eng 1 on h=
ub 8
<6>[240547.640308] amdgpu 0000:03:00.0: ring vcn_enc0 uses VM inv eng 4 on =
hub 8
Panic#2 Part7
<6>[240547.640310] amdgpu 0000:03:00.0: ring vcn_enc1 uses VM inv eng 5 on =
hub 8
<6>[240547.640312] amdgpu 0000:03:00.0: ring jpeg_dec uses VM inv eng 6 on =
hub 8
<6>[240547.777611] usb 1-1.3.2.4: reset high-speed USB device number 36 usi=
ng xhci_hcd
<6>[240548.168643] OOM killer enabled.
<6>[240548.168648] Restarting tasks: Starting
<6>[240548.170996] Restarting tasks: Done
<6>[240548.171015] efivarfs: resyncing variable state
<6>[240548.183456] efivarfs: finished resyncing variable state
<5>[240548.183523] random: crng reseeded on system resumption
<6>[240548.319075] PM: suspend exit
<6>[240549.054362] iwlwifi 0000:01:00.0: WFPM_UMAC_PD_NOTIFICATION: 0x20
<6>[240549.054440] iwlwifi 0000:01:00.0: WFPM_LMAC2_PD_NOTIFICATION: 0x1f
<6>[240549.054511] iwlwifi 0000:01:00.0: WFPM_AUTH_KEY_0: 0x90
<6>[240549.054578] iwlwifi 0000:01:00.0: CNVI_SCU_SEQ_DATA_DW9: 0x0
<6>[240552.869040] wlp1s0: authenticate with d6:92:5e:eb:ee:15 (local addre=
ss=3Dc8:15:4e:63:1d:e8)
<6>[240552.870295] wlp1s0: send auth to d6:92:5e:eb:ee:15 (try 1/3)
<6>[240552.934184] wlp1s0: authenticate with d6:92:5e:eb:ee:15 (local addre=
ss=3Dc8:15:4e:63:1d:e8)
<6>[240552.934199] wlp1s0: send auth to d6:92:5e:eb:ee:15 (try 1/3)
<6>[240552.939205] wlp1s0: authenticated
<6>[240552.940960] wlp1s0: associate with d6:92:5e:eb:ee:15 (try 1/3)
<6>[240552.949911] wlp1s0: RX AssocResp from d6:92:5e:eb:ee:15 (capab=3D0x1=
011 status=3D0 aid=3D10)
<6>[240552.965155] wlp1s0: associated
<7>[240553.020321] wlp1s0: Limiting TX power to 23 (23 - 0) dBm as advertis=
ed by d6:92:5e:eb:ee:15
<4>[240561.824922]
<4>[240561.824933] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
<4>[240561.824936] [ BUG: Invalid wait context ]
Oops#1 Part5
<4>[240561.824939] 6.19.0-09985-gaaeb3769f82e #414 Not tainted
<4>[240561.824943] -----------------------------
<4>[240561.824945] swapper/14/0 is trying to lock:
<4>[240561.824948] ffffffffc5512948 (
<4>[240561.824962] Oops: general protection fault, probably for non-canonic=
al address 0xe000123080000000: 0000 [#1] SMP KASAN
<1>[240561.824968] KASAN: maybe wild-memory-access in range [0x0000b1840000=
0000-0x0000b18400000007]
<4>[240561.824974] CPU: 14 UID: 0 PID: 0 Comm: swapper/14 Not tainted 6.19.=
0-09985-gaaeb3769f82e #414 PREEMPT(lazy)
<4>[240561.824979] Hardware name: HP HP Pavilion Aero Laptop 13-be0xxx/8916=
, BIOS F.17 12/18/2024
<4>[240561.824982] RIP: 0010:string (lib/vsprintf.c:655 lib/vsprintf.c:737)
<4>[240561.824989] Code: c0 0f 85 6a 02 00 00 44 88 2b 48 83 c3 01 83 c6 01=
 4c 39 fd 74 2e 48 89 ef 48 83 c5 01 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07=
 <0f> b6 04 08 38 d0 7f 08 84 c0 0f 85 11 02 00 00 44 0f b6 6d ff 45
All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0:	c0 0f 85             	rorb   $0x85,(%rdi)
   3:	6a 02                	push   $0x2
   5:	00 00                	add    %al,(%rax)
   7:	44 88 2b             	mov    %r13b,(%rbx)
   a:	48 83 c3 01          	add    $0x1,%rbx
   e:	83 c6 01             	add    $0x1,%esi
  11:	4c 39 fd             	cmp    %r15,%rbp
  14:	74 2e                	je     0x44
  16:	48 89 ef             	mov    %rbp,%rdi
  19:	48 83 c5 01          	add    $0x1,%rbp
  1d:	48 89 f8             	mov    %rdi,%rax
  20:	48 89 fa             	mov    %rdi,%rdx
  23:	48 c1 e8 03          	shr    $0x3,%rax
  27:	83 e2 07             	and    $0x7,%edx
  2a:*	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax		<-- trapping instru=
ction
  2e:	38 d0                	cmp    %dl,%al
  30:	7f 08                	jg     0x3a
  32:	84 c0                	test   %al,%al
  34:	0f 85 11 02 00 00    	jne    0x24b
  3a:	44 0f b6 6d ff       	movzbl -0x1(%rbp),%r13d
  3f:	45                   	rex.RB

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
   4:	38 d0                	cmp    %dl,%al
   6:	7f 08                	jg     0x10
   8:	84 c0                	test   %al,%al
   a:	0f 85 11 02 00 00    	jne    0x221
  10:	44 0f b6 6d ff       	movzbl -0x1(%rbp),%r13d
  15:	45                   	rex.RB
<4>[240561.824994] RSP: 0018:ffffc90000628360 EFLAGS: 00010046
<4>[240561.824998] RAX: 0000163080000000 RBX: ffffc9000062865a RCX: dffffc0=
000000000
<4>[240561.825001] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000b18=
400000000
<4>[240561.825004] RBP: 0000b18400000001 R08: ffffffffffff0a00 R09: ffffc90=
000628618
<4>[240561.825007] R10: 0000000000000405 R11: 0000000000000000 R12: ffffc90=
000628660
<4>[240561.825009] R13: 0000000000000405 R14: 1ffff920000c506f R15: 0000b18=
4ffffffff
<4>[240561.825012] FS:  0000000000000000(0000) GS:ffff88840118b000(0000) kn=
lGS:0000000000000000
<4>[240561.825015] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[240561.825018] CR2: 00007f45967ea000 CR3: 0000000330491000 CR4: 0000000=
000750ef0
<4>[240561.825021] PKRU: 55555554
Oops#1 Part4
<4>[240561.825024] Call Trace:
<4>[240561.825027]  <IRQ>
<4>[240561.825031]  ? _prb_read_valid (kernel/printk/printk_ringbuffer.c:22=
03 (discriminator 1))
<4>[240561.825036]  ? ip6_addr_string_sa (lib/vsprintf.c:733)
<4>[240561.825042]  ? prb_next_reserve_seq (kernel/printk/printk_ringbuffer=
=2Ec:2166)
<4>[240561.825046]  vsnprintf (lib/vsprintf.c:2887)
<4>[240561.825053]  ? pointer (lib/vsprintf.c:2865)
<4>[240561.825057]  ? prb_final_commit (kernel/printk/printk_ringbuffer.c:2=
241)
<4>[240561.825061]  ? prb_read_valid (kernel/printk/printk_ringbuffer.c:224=
1)
<4>[240561.825065]  vprintk_store (kernel/printk/printk.c:2307 (discriminat=
or 1))
<4>[240561.825072]  ? printk_sprint (kernel/printk/printk.c:2272)
<4>[240561.825075]  ? desc_read (./arch/x86/include/asm/atomic64_64.h:20 ./=
include/linux/atomic/atomic-arch-fallback.h:2629 ./include/linux/atomic/ato=
mic-long.h:79 ./include/linux/atomic/atomic-instrumented.h:3224 kernel/prin=
tk/printk_ringbuffer.c:552)
<4>[240561.825080]  ? desc_read_finalized_seq (kernel/printk/printk_ringbuf=
fer.c:1938)
<4>[240561.825084]  ? desc_read (./arch/x86/include/asm/atomic64_64.h:20 ./=
include/linux/atomic/atomic-arch-fallback.h:2629 ./include/linux/atomic/ato=
mic-long.h:79 ./include/linux/atomic/atomic-instrumented.h:3224 kernel/prin=
tk/printk_ringbuffer.c:552)
<4>[240561.825088]  ? panic_on_this_cpu (./arch/x86/include/asm/atomic.h:23=
 ./include/linux/atomic/atomic-arch-fallback.h:457 ./include/linux/atomic/a=
tomic-instrumented.h:33 kernel/panic.c:488)
<4>[240561.825093]  ? _prb_read_valid (kernel/printk/printk_ringbuffer.c:22=
03 (discriminator 1))
<4>[240561.825096]  ? rcu_is_watching (./include/linux/context_tracking.h:1=
28 (discriminator 1) kernel/rcu/tree.c:752 (discriminator 1))
<4>[240561.825102]  vprintk_emit (kernel/printk/printk.c:2457)
<4>[240561.825107]  ? wake_up_klogd_work_func (kernel/printk/printk.c:2426)
<4>[240561.825112]  ? do_raw_spin_unlock (./arch/x86/include/asm/atomic.h:2=
3 ./include/linux/atomic/atomic-arch-fallback.h:457 ./include/linux/atomic/=
atomic-instrumented.h:33 ./include/asm-generic/qspinlock.h:57 kernel/lockin=
g/spinlock_debug.c:101 kernel/locking/spinlock_debug.c:141)
<4>[240561.825117]  ? _raw_spin_unlock_irqrestore (./include/linux/spinlock=
_api_smp.h:179 (discriminator 3) kernel/locking/spinlock.c:194 (discriminat=
or 3))
<4>[240561.825123]  _printk (kernel/printk/printk.c:2499)
<4>[240561.825128]  ? __em_nl_get_pd_table.cold (kernel/printk/printk.c:249=
9)
<4>[240561.825134]  ? console_unlock (kernel/printk/printk.c:3392 (discrimi=
nator 1) kernel/printk/printk.c:3413 (discriminator 1))
<4>[240561.825139]  __print_lock_name.cold (kernel/locking/lockdep.c:728)
<4>[240561.825153]  print_lock_name (kernel/locking/lockdep.c:745)
<4>[240561.825158]  print_lock.cold (kernel/locking/lockdep.c:783)
<4>[240561.825162]  __lock_acquire (kernel/locking/lockdep.c:4822 kernel/lo=
cking/lockdep.c:4902 kernel/locking/lockdep.c:5187)
<4>[240561.825170]  lock_acquire (kernel/locking/lockdep.c:470 kernel/locki=
ng/lockdep.c:5870 kernel/locking/lockdep.c:5825)
<4>[240561.825174]  ? notifier_call_chain (kernel/notifier.c:87)
<4>[240561.825181] pvclock_gtod_notify (./include/linux/seqlock.h:432 ./inc=
lude/linux/seqlock.h:479 ./include/linux/seqlock.h:504 arch/x86/kvm/x86.c:2=
370 arch/x86/kvm/x86.c:9967) kvm
<4>[240561.825254]  ? notifier_call_chain (kernel/notifier.c:87)
<4>[240561.825258]  notifier_call_chain (kernel/notifier.c:87)
<4>[240561.825263]  timekeeping_update_from_shadow.constprop.0 (kernel/time=
/timekeeping.c:736)
Oops#1 Part3
<4>[240561.825268]  __timekeeping_advance.constprop.0 (kernel/time/timekeep=
ing.c:2379)
<4>[240561.825272]  ? __rwlock_init (kernel/locking/spinlock_debug.c:114)
<4>[240561.825276]  ? do_settimeofday64 (kernel/time/timekeeping.c:2321)
<4>[240561.825280]  ? lock_release (kernel/locking/lockdep.c:470 (discrimin=
ator 4) kernel/locking/lockdep.c:5891 (discriminator 4) kernel/locking/lock=
dep.c:5875 (discriminator 4))
<4>[240561.825285]  update_wall_time (kernel/time/timekeeping.c:2385 kernel=
/time/timekeeping.c:2395)
<4>[240561.825290]  tick_nohz_handler (kernel/time/tick-sched.c:253 kernel/=
time/tick-sched.c:312)
<4>[240561.825294]  ? tick_do_update_jiffies64 (kernel/time/tick-sched.c:30=
7)
<4>[240561.825298]  ? __hrtimer_run_queues (./arch/x86/include/asm/jump_lab=
el.h:37 ./include/trace/events/timer.h:259 kernel/time/hrtimer.c:1782 kerne=
l/time/hrtimer.c:1849)
<4>[240561.825302]  ? lock_release (kernel/locking/lockdep.c:470 (discrimin=
ator 4) kernel/locking/lockdep.c:5891 (discriminator 4) kernel/locking/lock=
dep.c:5875 (discriminator 4))
<4>[240561.825306]  ? tick_do_update_jiffies64 (kernel/time/tick-sched.c:30=
7)
<4>[240561.825310]  __hrtimer_run_queues (kernel/time/hrtimer.c:1785 kernel=
/time/hrtimer.c:1849)
<4>[240561.825315]  ? hrtimer_reprogram (kernel/time/hrtimer.c:1819)
<4>[240561.825319]  ? ktime_get_update_offsets_now (kernel/time/timekeeping=
=2Ec:381 kernel/time/timekeeping.c:404 kernel/time/timekeeping.c:2573)
<4>[240561.825325]  hrtimer_interrupt (kernel/time/hrtimer.c:1914)
<4>[240561.825329]  ? lock_release (kernel/locking/lockdep.c:470 (discrimin=
ator 4) kernel/locking/lockdep.c:5891 (discriminator 4) kernel/locking/lock=
dep.c:5875 (discriminator 4))
<4>[240561.825334]  ? tick_nohz_stop_idle (./include/linux/seqlock.h:453 ./=
include/linux/seqlock.h:525 kernel/time/tick-sched.c:771)
<4>[240561.825338]  __sysvec_apic_timer_interrupt (./arch/x86/include/asm/j=
ump_label.h:37 ./arch/x86/include/asm/trace/irq_vectors.h:40 arch/x86/kerne=
l/apic/apic.c:1063)
<4>[240561.825343]  sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.=
c:1056 (discriminator 35) arch/x86/kernel/apic/apic.c:1056 (discriminator 3=
5))
<4>[240561.825348]  </IRQ>
<4>[240561.825350]  <TASK>
<4>[240561.825353]  asm_sysvec_apic_timer_interrupt (./arch/x86/include/asm=
/idtentry.h:569)
<4>[240561.825357] RIP: 0010:cpuidle_enter_state (drivers/cpuidle/cpuidle.c=
:294)
<4>[240561.825361] Code: 73 04 bf ff ff ff ff 49 89 c6 e8 80 85 6b ff 31 ff=
 e8 f9 da cb fd 45 84 ff 0f 85 a3 01 00 00 e8 cb 33 fd fd fb 0f 1f 44 00 00=
 <45> 85 ed 0f 88 6e 01 00 00 4d 63 fd 49 83 ff 0a 0f 83 c5 02 00 00
All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0:	73 04                	jae    0x6
   2:	bf ff ff ff ff       	mov    $0xffffffff,%edi
   7:	49 89 c6             	mov    %rax,%r14
   a:	e8 80 85 6b ff       	call   0xffffffffff6b858f
   f:	31 ff                	xor    %edi,%edi
  11:	e8 f9 da cb fd       	call   0xfffffffffdcbdb0f
  16:	45 84 ff             	test   %r15b,%r15b
  19:	0f 85 a3 01 00 00    	jne    0x1c2
  1f:	e8 cb 33 fd fd       	call   0xfffffffffdfd33ef
  24:	fb                   	sti
  25:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  2a:*	45 85 ed             	test   %r13d,%r13d		<-- trapping instruction
  2d:	0f 88 6e 01 00 00    	js     0x1a1
  33:	4d 63 fd             	movslq %r13d,%r15
  36:	49 83 ff 0a          	cmp    $0xa,%r15
  3a:	0f 83 c5 02 00 00    	jae    0x305

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:	45 85 ed             	test   %r13d,%r13d
   3:	0f 88 6e 01 00 00    	js     0x177
   9:	4d 63 fd             	movslq %r13d,%r15
   c:	49 83 ff 0a          	cmp    $0xa,%r15
  10:	0f 83 c5 02 00 00    	jae    0x2db
<4>[240561.825364] RSP: 0018:ffffc9000032fd80 EFLAGS: 00000206
<4>[240561.825367] RAX: 0000000029e5cd35 RBX: ffff888122255000 RCX: 0000000=
000000000
<4>[240561.825370] RDX: 0000000000000000 RSI: ffffffff8b234809 RDI: fffffff=
f8acb7b40
<4>[240561.825373] RBP: ffffffff8bd34de0 R08: 0000000000000001 R09: 0000000=
000000000
Oops#1 Part2
<4>[240561.825375] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
000000002
<4>[240561.825378] R13: 0000000000000002 R14: 0000daca2a1ea9c7 R15: 0000000=
000000000
<4>[240561.825384]  ? mark_tsc_async_resets (arch/x86/kernel/tsc_sync.c:52)
<4>[240561.825388]  cpuidle_enter (drivers/cpuidle/cpuidle.c:393 (discrimin=
ator 2))
<4>[240561.825393]  do_idle (kernel/sched/idle.c:241 kernel/sched/idle.c:33=
2)
<4>[240561.825398]  ? arch_cpu_idle_exit+0x30/0x30
<4>[240561.825402]  ? do_idle (./arch/x86/include/asm/bitops.h:202 ./arch/x=
86/include/asm/bitops.h:232 ./include/asm-generic/bitops/instrumented-non-a=
tomic.h:142 ./include/linux/thread_info.h:133 ./include/linux/sched.h:2063 =
=2E/include/linux/livepatch.h:186 kernel/sched/idle.c:362)
<4>[240561.825407]  cpu_startup_entry (kernel/sched/idle.c:429)
<4>[240561.825411]  start_secondary (arch/x86/kernel/smpboot.c:200 (discrim=
inator 10) arch/x86/kernel/smpboot.c:280 (discriminator 10))
<4>[240561.825415]  ? set_cpu_sibling_map (arch/x86/kernel/smpboot.c:230)
<4>[240561.825419]  common_startup_64 (arch/x86/kernel/head_64.S:419)
<4>[240561.825427]  </TASK>
<4>[240561.825429] Modules linked in: snd_seq_dummy snd_hrtimer snd_seq xt_=
conntrack nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntr=
ack nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo xt_addrtype nft_compa=
t x_tables nf_tables br_netfilter bridge stp llc ccm overlay qrtr rfcomm cm=
ac algif_hash algif_skcipher af_alg bnep binfmt_misc ext4 mbcache jbd2 nls_=
ascii nls_cp437 vfat fat snd_hda_codec_generic snd_acp3x_pdm_dma snd_soc_dm=
ic snd_acp3x_rn intel_rapl_msr snd_soc_core snd_compress amd_atl snd_hda_co=
dec_hdmi iwlmvm intel_rapl_common mac80211 libarc4 snd_pci_acp6x btusb btrt=
l snd_hda_intel kvm_amd uvcvideo videobuf2_vmalloc snd_hda_codec snd_usb_au=
dio videobuf2_memops btintel kvm snd_pci_acp5x uvc snd_usbmidi_lib snd_inte=
l_dspcfg btbcm irqbypass videobuf2_v4l2 snd_hwdep iwlwifi snd_rawmidi btmtk=
 videodev snd_rn_pci_acp3x snd_hda_core snd_seq_device videobuf2_common rap=
l bluetooth snd_acp_config cfg80211 mc snd_pcm snd_soc_acpi ecdh_generic pc=
spkr wmi_bmof ecc sg ee1004 snd_timer k10temp snd_pci_acp3x snd
Oops#1 Part1
<4>[240561.825538]  ac battery ccp rfkill soundcore joydev button amd_pmc a=
cpi_tad evdev msr parport_pc ppdev lp parport nvme_fabrics fuse efi_pstore =
configfs nfnetlink efivarfs autofs4 btrfs xor libblake2b raid6_pq dm_crypt =
dm_mod r8153_ecm sd_mod cdc_ether usbnet hid_microsoft ff_memless hid_cmedi=
a uas r8152 mii usb_storage libphy scsi_mod mdio_bus usbhid scsi_common amd=
gpu drm_client_lib i2c_algo_bit drm_ttm_helper ttm drm_exec drm_suballoc_he=
lper drm_buddy drm_panel_backlight_quirks gpu_sched amdxcp hid_multitouch d=
rm_display_helper hid_generic ucsi_acpi video typec_ucsi drm_kms_helper sp5=
100_tco xhci_pci watchdog i2c_hid_acpi roles cec xhci_hcd ghash_clmulni_int=
el nvme i2c_piix4 i2c_hid amd_sfh typec serio_raw rc_core thunderbolt usbco=
re i2c_smbus hid crc16 nvme_core fan usb_common wmi drm aesni_intel
<4>[240561.825632] ---[ end trace 0000000000000000 ]---
<4>[240562.127793] RIP: 0010:string (lib/vsprintf.c:655 lib/vsprintf.c:737)
<4>[240562.127799] Code: c0 0f 85 6a 02 00 00 44 88 2b 48 83 c3 01 83 c6 01=
 4c 39 fd 74 2e 48 89 ef 48 83 c5 01 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07=
 <0f> b6 04 08 38 d0 7f 08 84 c0 0f 85 11 02 00 00 44 0f b6 6d ff 45
All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0:	c0 0f 85             	rorb   $0x85,(%rdi)
   3:	6a 02                	push   $0x2
   5:	00 00                	add    %al,(%rax)
   7:	44 88 2b             	mov    %r13b,(%rbx)
   a:	48 83 c3 01          	add    $0x1,%rbx
   e:	83 c6 01             	add    $0x1,%esi
  11:	4c 39 fd             	cmp    %r15,%rbp
  14:	74 2e                	je     0x44
  16:	48 89 ef             	mov    %rbp,%rdi
  19:	48 83 c5 01          	add    $0x1,%rbp
  1d:	48 89 f8             	mov    %rdi,%rax
  20:	48 89 fa             	mov    %rdi,%rdx
  23:	48 c1 e8 03          	shr    $0x3,%rax
  27:	83 e2 07             	and    $0x7,%edx
  2a:*	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax		<-- trapping instru=
ction
  2e:	38 d0                	cmp    %dl,%al
  30:	7f 08                	jg     0x3a
  32:	84 c0                	test   %al,%al
  34:	0f 85 11 02 00 00    	jne    0x24b
  3a:	44 0f b6 6d ff       	movzbl -0x1(%rbp),%r13d
  3f:	45                   	rex.RB

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
   4:	38 d0                	cmp    %dl,%al
   6:	7f 08                	jg     0x10
   8:	84 c0                	test   %al,%al
   a:	0f 85 11 02 00 00    	jne    0x221
  10:	44 0f b6 6d ff       	movzbl -0x1(%rbp),%r13d
  15:	45                   	rex.RB
<4>[240562.127803] RSP: 0018:ffffc90000628360 EFLAGS: 00010046
<4>[240562.127808] RAX: 0000163080000000 RBX: ffffc9000062865a RCX: dffffc0=
000000000
<4>[240562.127812] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000b18=
400000000
<4>[240562.127815] RBP: 0000b18400000001 R08: ffffffffffff0a00 R09: ffffc90=
000628618
<4>[240562.127818] R10: 0000000000000405 R11: 0000000000000000 R12: ffffc90=
000628660
<4>[240562.127821] R13: 0000000000000405 R14: 1ffff920000c506f R15: 0000b18=
4ffffffff
<4>[240562.127825] FS:  0000000000000000(0000) GS:ffff88840118b000(0000) kn=
lGS:0000000000000000
<4>[240562.127828] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[240562.127832] CR2: 00007f45967ea000 CR3: 0000000330491000 CR4: 0000000=
000750ef0
<4>[240562.127835] PKRU: 55555554
<0>[240562.127839] Kernel panic - not syncing: Fatal exception in interrupt
<0>[240563.374597] Shutting down cpus with NMI


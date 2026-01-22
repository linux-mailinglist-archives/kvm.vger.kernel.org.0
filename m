Return-Path: <kvm+bounces-68913-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 407SIJtgcmnfjQAAu9opvQ
	(envelope-from <kvm+bounces-68913-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:38:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DD816B7F1
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:38:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7E62F30DE131
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E0833DCE2A;
	Thu, 22 Jan 2026 16:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lY+xEbpF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F8237416B
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 16:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769100163; cv=pass; b=J6NZp+DX+XJ6102OMAP/deU/ephrW/6OFphGozXX7D3CFHY4elsdGYOymg+ubJ3VjsUP+gaZzH+YE6eYwmrzm/OtVdnWALO52u0HwWfMTBA47o5JtTP/SEbtN0lpX39dyNw04qah9eH71oqZgDKqwf7hwVPj2gKk5ziD331ZJH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769100163; c=relaxed/simple;
	bh=obNIgoM6xYguvUziGB9OURwd/2RLaTbn3rp4ou46Pno=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EZ7sAOnaRkI37fRp/erAwi7FUUmuyLtJIlS24GZTVT3+P3Ps5R0xWNLIe0EoLv8Ko6ZFIsUVSVOkR4vrsuuz8p/8stf0PA9tBdxCFdUhYDC+SrNbq3FnfYGr7PsajayipHmfTihDknysdULt8TMZfXrMRTOxqOSoGdtcFyn7LU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lY+xEbpF; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8946e0884afso19157766d6.1
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 08:42:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769100151; cv=none;
        d=google.com; s=arc-20240605;
        b=Ka4ODqqKvPrPujtiFCXSO1vLAwphaG/0hdt0GIaCGv2gf6paBF9S3CB7EMMUAKPY8V
         9e8HcPi4UJy31lAfPoiujYlQuaBxxzRrzOScrxz6J5GyjwjIMbS4phcEQ9x82LQmOm4Z
         uiwYIIvDdWqF4ZKebvp2kK+bYzqSOKAZIxsPd/hEa7pkhBd6RYMi1Oldv7qFP7W+semM
         9DVRTIrsvRCd4uz0dEfBFMngP45t6KR5k1eXGaNnugBjkB8nBloF6WZK83HVo/XjpWB1
         6u6x7xbuLlQ66Uciurxj3LtV2NQXeinJcNvXJ3KsjWSPbfrRswIqZO/yrUh51Y/O1yYk
         CDBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nCfXv1f79FGhCIofbRqnmc1tP3uFDpMspjktatk/JLI=;
        fh=gfi/IVbNexyAZjjieetKoSNtpQVY5yV3b+2GSbsvRNQ=;
        b=er5vTcX1kFz7CQPDRrM7mbJ7OssLX/HSiSPtCNDWiR13xrgjOOP7YWsNvSLwp+HNv0
         dYiScdNcfo+98qYfdaFwtB9ezCtMEN9G0QYKEJKt6gmlbBy+stvDtdyonXa4nVXAll5J
         XRD1q0PBY0/flQmoD3jg502mawAekdeuGWCkCihTR8dsm3ATNA09xtKoqL7t9Z/jvaTO
         lVD1jNyDM1EEsxG54vXoiPmvQo4TUEzKIbw3hQyJVn55Sro/ICB+QihmJHTEjzb3n+JM
         c1eirQoodnHUAH7NGxyqJlV3i4et9Fy3F/j2MqVQjx9eN8lvfHs6tbeIGPX9MK6eEyVq
         rIpA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769100151; x=1769704951; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nCfXv1f79FGhCIofbRqnmc1tP3uFDpMspjktatk/JLI=;
        b=lY+xEbpFFqVLMw9g8SqDBr/QGhMq3j4uyt2f7CzXVA8zoPcupgGuKYaTCNSrzdocLl
         ExWp3dUh/Q2n/39toUEhU2+drKIPMZr1yd60UVbA4WgQjcVcmDpNGAuzWUBTGpTgWpRS
         665tZrD24M0rsjFZ9iIp64ZhpfnpIk1GNg1Kt8CNSc4aKPZdQGTE/YvhEnB8U6rImpxu
         oTbyWiVur1n8doZ6haT3xflV5pu+KjObRc3pRKFnH0RFfw9jfhdF4Xhy7KfKtetgatdk
         spqmwg72MiCM56/+3e3/LYh8MchEUPOaNRNTH0RGtV4q/I2z1e2YvGKdeB0a/JKkKcFo
         urdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769100151; x=1769704951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nCfXv1f79FGhCIofbRqnmc1tP3uFDpMspjktatk/JLI=;
        b=BwqtYxcT6XYA/2HgN8B59oVVpTt0IfT2rEvoBS1q22+fQcbhW2+qOVUvqeOSMrbz5m
         3VLs+Hv24lnDDTGRofZuGoFJjMb4uMewjPmttxj21ZBtgHRTN/trrq8SGOUYhIMYR0j1
         k0ecD/R8QnUGGqDgJnH3mL/CaJigJWoj9PqQ1uWAzqQkHe3PVZNcucPjwEXP7N2EuIot
         t/8mWuzOROiOGGb8x0GhPRwnC0XMj/L0s8ElAo202lttkXbnbV2TvmLvMQPL3CNkrmtm
         XVi87r+CK1WBWqMvfpiPo8h1LNxg1tXL4nn57gWGBFvkovu1hrSlJNhZTG84+PVvXJuR
         DbiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhAAQQjKrEeX2mtHp+/ubGMmYlIhejXQBRkErvDuh/R3XzVyDYZf7pBlfR0id0C5YSPng=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSiUzCDB0HlIcZVrbo1VG+3BKSj/J6bwmxTzK6N1N4/fCWxhjv
	o72XLCo3895FQBmJEDtkAyYtE/y/f/s8b2ZiWCGDHiGd7utMmD5AKaYcB3XVnf7c25jxhyJTQmd
	pnS7BE4oCW2KscyOZzGBZ5a2V9bOHL1rXJIvSBZ0Z
X-Gm-Gg: AZuq6aIicW0sYk4j8X3WhW1Tu977mJzxmVVDfNzTsGstL+Pyx85DH3SsmEJA1JX0igO
	59f+Nruco+GPH2PjdQJ3c9Llyr3mzQAfxGWbp0Y9dPUCZ1wVT+BXf6P7lq7/tp5SUmRwSTXU3mR
	9jlG84fC3CAc99Go0UieTKNHE2MMdDnrFetcDrkUf8HcQw9lDymJdm1IxZIJvYtaoaRcy60oM6X
	kQjWsg8ZIeO/VfdmvnpS+sJnC4+rPVhMbWlCXjvDOxWEFxIe4FeKCNGzy5OP3G/s6R9XCkptz/n
	/Kc0Oo7O9/sUu5MdEGHj4ediCQ==
X-Received: by 2002:a05:6214:f21:b0:894:48f7:c535 with SMTP id
 6a1803df08f44-894901fe23dmr698736d6.43.1769100150708; Thu, 22 Jan 2026
 08:42:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6925da1b.a70a0220.d98e3.00b0.GAE@google.com> <692611ac.a70a0220.2ea503.0091.GAE@google.com>
 <aSY3RJI6uvrbh92_@google.com>
In-Reply-To: <aSY3RJI6uvrbh92_@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 22 Jan 2026 17:41:54 +0100
X-Gm-Features: AZwV_QiYBkVXRhVRPM6CPlCjnA7opUW2pRfGTZU1f1151CqoyPQUQfn1FmyHA6E
Message-ID: <CAG_fn=Vz+xPd2jzRPL0jRsb8usA7NzusP_3NsfeAPCZqOgMJeg@mail.gmail.com>
Subject: Re: [syzbot] [kvm-x86?] WARNING in kvm_apic_accept_events (2)
To: Sean Christopherson <seanjc@google.com>
Cc: syzbot <syzbot+59f2c3a3fc4f6c09b8cd@syzkaller.appspotmail.com>, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=a1db0fea040c2a9f];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68913-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,storage.googleapis.com:url,googlegroups.com:email,appspotmail.com:email,mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[glider@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm,59f2c3a3fc4f6c09b8cd];
	MISSING_XM_UA(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: 1DD816B7F1
X-Rspamd-Action: no action

On Wed, Nov 26, 2025 at 12:10=E2=80=AFAM 'Sean Christopherson' via
syzkaller-bugs <syzkaller-bugs@googlegroups.com> wrote:
>
> On Tue, Nov 25, 2025, syzbot wrote:
> > syzbot has found a reproducer for the following issue on:
> >
> > HEAD commit:    8a2bcda5e139 Merge tag 'for-6.18/dm-fixes' of git://git=
.ke..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1604f8b4580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da1db0fea040=
c2a9f
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D59f2c3a3fc4f6=
c09b8cd
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D13ecf6125=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D13d9cf42580=
000
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/d900f083ada3/non_bootable_disk-8a2bcda5.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/fc3f96645396/vmli=
nux-8a2bcda5.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/e20aa7be5d33=
/bzImage-8a2bcda5.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+59f2c3a3fc4f6c09b8cd@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 5495 at arch/x86/kvm/lapic.c:3483 kvm_apic_accept_=
events+0x341/0x490 arch/x86/kvm/lapic.c:3483
> > Modules linked in:
> > CPU: 0 UID: 0 PID: 5495 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT=
(full)
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-=
1.16.3-2~bpo12+1 04/01/2014
> > RIP: 0010:kvm_apic_accept_events+0x341/0x490 arch/x86/kvm/lapic.c:3483
> > Code: eb 0c e8 32 da 71 00 eb 05 e8 2b da 71 00 45 31 ff 44 89 f8 5b 41=
 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 10 da 71 00 90 <0f> 0b 90 e9 =
ec fd ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 4f
> > RSP: 0018:ffffc90002b2fbf0 EFLAGS: 00010293
> > RAX: ffffffff814e3940 RBX: 0000000000000002 RCX: ffff88801f8ca480
> > RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
> > RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff814689b6
> > R10: dffffc0000000000 R11: ffffed1002268008 R12: 0000000000000002
> > R13: dffffc0000000000 R14: ffff888042c95c00 R15: ffff8880113402d8
> > FS:  000055558ab60500(0000) GS:ffff88808d72f000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000200000002000 CR3: 0000000058d0b000 CR4: 0000000000352ef0
> > Call Trace:
> >  <TASK>
> >  kvm_arch_vcpu_ioctl_get_mpstate+0x128/0x480 arch/x86/kvm/x86.c:12147
> >  kvm_vcpu_ioctl+0x625/0xe90 virt/kvm/kvm_main.c:4539
> >  vfs_ioctl fs/ioctl.c:51 [inline]
> >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> >  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f918bd8f749
> > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89=
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffc74a3c2a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > RAX: ffffffffffffffda RBX: 00007f918bfe5fa0 RCX: 00007f918bd8f749
> > RDX: 0000000000000000 RSI: 000000008004ae98 RDI: 0000000000000005
> > RBP: 00007f918be13f91 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007f918bfe5fa0 R14: 00007f918bfe5fa0 R15: 0000000000000003
> >  </TASK>
>
> Syzbot outsmarted me once again.  I thought I had made this impossible in=
 commit
> 0fe3e8d804fd ("KVM: x86: Move INIT_RECEIVED vs. INIT/SIPI blocked check t=
o KVM_RUN"),
> but now syzkaller is triggering the WARN by swapping the order and stuffi=
ng VMXON
> after INIT (ignore the EINVAL, KVM gets through enter_vmx_operation() bef=
ore detecting
> bad guest state).
>
>   ioctl(5, KVM_SET_MP_STATE, 0x200000000000) =3D 0
>   ioctl(5, KVM_SET_NESTED_STATE, 0x200000000a80) =3D -1 EINVAL (Invalid a=
rgument)
>   ioctl(5, KVM_GET_MP_STATE, 0)           =3D -1 EFAULT (Bad address)
>
> At this point, I'm leaning strongly towards dropping the WARN as it's not=
 helping,
> and userspace doing odd things is completely uninteresting.
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 7b1b8f450f4c..df2a69da11b7 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -3521,7 +3521,6 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>          * wait-for-SIPI (WFS).
>          */
>         if (!kvm_apic_init_sipi_allowed(vcpu)) {
> -               WARN_ON_ONCE(vcpu->arch.mp_state =3D=3D KVM_MP_STATE_INIT=
_RECEIVED);
>                 clear_bit(KVM_APIC_SIPI, &apic->pending_events);
>                 return 0;
>         }

Hi Sean, this is still biting us.
Have you made up your mind on the above patch?

Thanks,
Alex


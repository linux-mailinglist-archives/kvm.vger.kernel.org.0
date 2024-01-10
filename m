Return-Path: <kvm+bounces-5994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C47AD829A7E
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 13:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DE701F27033
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 12:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433DA47A61;
	Wed, 10 Jan 2024 12:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="crr712O/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B63339A9
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 12:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ECEF2C433F1
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 12:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704890289;
	bh=dKXbqeCwJj09D4UYa1Ep2dbwm5Q/SF4jv0EX9OZ2qIk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=crr712O/N4VGU+lJocBPTY9uMrotQbr4rxunz+xZSOOE0VAACDoYpFexVZsD/fkqr
	 w5g0xvEuA4pT3s8JjUGpHeQuI+rmGOOcvX0CfqIrSCD6IXS0O8rkO8BP6o9ig3q4BH
	 pjzjxjM5Wh7m7OS5jFWCnGUE9N8RUpgoM4nqQ1U7R29rsMUUYI+iaRNuA1NmMfB0DL
	 ThSRJmoZdhbMPWQx5HqIVEAKkcXPA+H0fP0HwH5xkdngDYjSYQnUIHpHie2dCnLQtX
	 qNh7D1NMZG2NCEU9OIwzZSxQlgI5vYJ1JnRZeTE+8wAyriYI5r2ngo2JOQqWuBwG2g
	 XrVhA+o0DbXAg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D695EC53BC6; Wed, 10 Jan 2024 12:38:08 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218339] kernel goes unresponsive if single-stepping over an
 instruction which writes to an address for which a hardware read/write
 watchpoint has been set
Date: Wed, 10 Jan 2024 12:38:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yaoyuan0329@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218339-28872-dvVdfUc8On@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218339-28872@https.bugzilla.kernel.org/>
References: <bug-218339-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218339

Yao Yuan (yaoyuan0329@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |yaoyuan0329@gmail.com

--- Comment #3 from Yao Yuan (yaoyuan0329@gmail.com) ---
Hi,

I tried on my side but can't reproducce it, logs below. Any steps I missed ?

(gdb) b *0x00007ffff7fe4048=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
Breakpoint 1 at 0x7ffff7fe4048: file ./elf/rtld.c, line 527.=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
(gdb) c=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
Continuing.=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20

Breakpoint 1, 0x00007ffff7fe4048 in _dl_start (arg=3D0x7fffffffe510) at
./elf/rtld.c:527=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
527     in ./elf/rtld.c=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
(gdb) disassemble=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
Dump of assembler code for function _dl_start:=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
   0x00007ffff7fe4030 <+0>:     endbr64=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
   0x00007ffff7fe4034 <+4>:     push   %rbp=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
   0x00007ffff7fe4035 <+5>:     mov    %rsp,%rbp=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
   0x00007ffff7fe4038 <+8>:     push   %r15=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
   0x00007ffff7fe403a <+10>:    push   %r14=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
   0x00007ffff7fe403c <+12>:    push   %r13=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
   0x00007ffff7fe403e <+14>:    push   %r12=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
   0x00007ffff7fe4040 <+16>:    push   %rbx=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
   0x00007ffff7fe4041 <+17>:    sub    $0x88,%rsp=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
=3D> 0x00007ffff7fe4048 <+24>:    mov    %rdi,-0x78(%rbp)=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
   0x00007ffff7fe404c <+28>:    rdtsc=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
(gdb) x/16xb $rbp-0x78=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
0x7fffffffe488: 0x00    0x00    0x00    0x00    0x00    0x00    0x00    0x0=
0=20=20=20=20
0x7fffffffe490: 0x00    0x00    0x00    0x00    0x00    0x00    0x00    0x0=
0=20=20=20=20
(gdb) awatch *0x7fffffffe488=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
Hardware access (read/write) watchpoint 2: *0x7fffffffe488=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
(gdb) stepi=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20

Hardware access (read/write) watchpoint 2: *0x7fffffffe488=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20

Old value =3D 0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
New value =3D -6896=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
0x00007ffff7fe404c in rtld_timer_start (var=3D0x7ffff7ffcaa0 <start_time>) =
at
./elf/rtld.c:85=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
85      in ./elf/rtld.c=20=20=20=20=20


the guest kernel runs properly after above steps inside guest.

My configure:
Host: stable kernel v6.6.8 commit 4c9646a796d66a2d81871a694e88e19a38b115a7
QEMU: v8.1.1 commit 6bb4a8a47a43f35a345f107227fcd6abed59e62c
Guest kernel: kvm tree tags/kvm-6.8-1 commit
1c6d984f523f67ecfad1083bb04c55d91977bb15

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


Return-Path: <kvm+bounces-4746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C239E81793C
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 18:54:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4646BB21344
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D97E571451;
	Mon, 18 Dec 2023 17:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azdrmCTu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164C54FF98
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 17:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83305C433C9
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 17:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702922056;
	bh=to5iq3TVdf155RlkfsND4jN9/sPqMdYv2Zq7lVuJ6KI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=azdrmCTujbxoXXO6bX9afEhDl8VcdC0gjZ5OgszTxAiD0K4drkWZsoLxhzoxc6Km+
	 EqsE4WbZTK4nwURUCzZeTincAd/DL9nhGv88EUJR/sMhLBgW8fh21lgEejwaHqTQUP
	 Pl3QLr/gSp5qQkVkacJ3jFhoEd8/UTyCVkzrdItVQNcvXN44Z1oliyepz3B54iUyYd
	 kU9L35jOzWTT3zK4s8iWrXef8kDDFJmKOive0ebL4OXKxdCWw09yyEPCt5mHZBpubh
	 A9ZbKDTZBq9KtGg9cqSk8dmWLtqCStfqBwkydX1Tm80la+Vpdrrz/jV1++Kk7ErwHD
	 NgNhTpV2NIBbA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 683CBC53BD2; Mon, 18 Dec 2023 17:54:16 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218267] [Sapphire Rapids][Upstream]Boot up multiple Windows VMs
 hang
Date: Mon, 18 Dec 2023 17:54:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218267-28872-gONIuYQMJ8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218267-28872@https.bugzilla.kernel.org/>
References: <bug-218267-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218267

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
On Fri, Dec 15, 2023, bugzilla-daemon@kernel.org wrote:
> Platform: Sapphire Rapids Platform
>=20
> Host OS: CentOS Stream 9
>=20
> Kernel:6.7.0-rc1 (commit:8ed26ab8d59111c2f7b86d200d1eb97d2a458fd1)

...

> Qemu: QEMU emulator version 8.1.94 (v8.2.0-rc4)
> (commit:039afc5ef7367fbc8fb475580c291c2655e856cb)
>=20
> Host Kernel cmdline:BOOT_IMAGE=3D/kvm-vmlinuz root=3D/dev/mapper/cs_spr--=
2s2-root
> ro crashkernel=3Dauto console=3Dtty0 console=3DttyS0,115200,8n1 3 intel_i=
ommu=3Don
> disable_mtrr_cleanup
>=20
> Bug detailed description
> =3D=3D=3D=3D=3D=3D=3D
> We boot up 8 Windows VMs (total vCPUs > pCPUs) in host, random run
> application
> on each VM such as WPS editing etc, and wait for a moment, then Some of t=
he
> Windows Guest hang and console reports "KVM internal error. Suberror: 3".

...

> Code=3D25 88 61 00 00 b9 70 00 00 40 0f ba 32 00 72 06 33 c0 8b d0 <0f> 3=
0 5a
> 58
> 59 c3 cc cc cc cc cc cc 0f 1f 84 00 00 00 00 00 48 81 ec 38 01 00 00 48 8=
d 84
>=20
> KVM internal error. Suberror: 3
> extra data[0]: 0x000000008000002f  <=3D Vectoring IRQ 47 (decimal)
> extra data[1]: 0x0000000000000020  <=3D WRMSR VM-Exit
> extra data[2]: 0x0000000000000f82
> extra data[3]: 0x000000000000004b

KVM exits with an internal error because the CPU indicates that IRQ 47 was
being
delivered/vectored when the VM-Exit occurred, but the VM-Exit is due to WRM=
SR.
A WRMSR VM-Exit is supposed to only occur on an instruction boundary, i.e.
can't
occur while delivering an IRQ (or any exception/event), and so KVM kicks ou=
t to
userspace because something has gone off the rails.

   b9 70 00 00 40          mov    0x40000070, ecx
   0f ba 32 00             btr    0x0, DWORD PTR [rdx]
   72 06                   jb     0x16
   33 c0                   xor    eax,eax
   8b d0                   mov    eax, edx
   0f 30                   wrmsr

FWIW, the MSR in question is Hyper-V's synthetic EOI, a.k.a. HV_X64_MSR_EOI,
though
I doubt the exact MSR matters.

Have you tried an older host kernel?  If not can you try something like v6.=
1?
Note, if you do, use base v6.1, *not* the stable tree in case a bug was
backported.

There was a recent change to relevant code, commit 50011c2a2457 ("KVM: VMX:
Refresh
available regs and IDT vectoring info before NMI handling"), though I don't=
 see
any obvious bugs.  But I'm pretty sure the only alternative explanation is a
CPU/ucode bug, so it's definitely worth checking older versions of KVM.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


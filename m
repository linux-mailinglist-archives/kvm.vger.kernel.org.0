Return-Path: <kvm+bounces-33982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C02329F515A
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 17:46:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13F8C1649F0
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 16:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF6BD1F4E3A;
	Tue, 17 Dec 2024 16:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cKlDoSYj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C88C13D891
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734453966; cv=none; b=HSy3zwDZX9sh0FyyKZiL/8bkR6Q2Ul6AfIMw01N8tcBvXcQYUhZi2cDHV9wm77CFW+spReKvcJ4g2lmKpmTUhavPEIoSoznPbPwj1pIRMYH+bY/XBksN69+cD7hpUc3IPZ9U5rNdUiguPr963fAk6MdCrlWlXyq+E1xhEPBjlJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734453966; c=relaxed/simple;
	bh=lRdofdyedL7gegjhv4biLCGXevi2+kvVVMA05wxKmBU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PTOJ9IPslknnMydvFCoC4fPZo6HWebWnHi+w6HHA37lT+/CykP+XkTcNYty0CNLqMQX7FbebrXoWs+fsODwVwTDbobJFKKFRmUUY6PmqVZnVO0RBurJvV+KXgVbTNyE/BrU9IT9Lutu0sjGN36QM3DpO06mgAoXNM4lVA7Cmsy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cKlDoSYj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B29FCC4CEDD
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734453965;
	bh=lRdofdyedL7gegjhv4biLCGXevi2+kvVVMA05wxKmBU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=cKlDoSYjl+YqMCrDvDkoict8XpY7iKrGCOt+HkDascNpexnBd5cog/uNSOOPTh6y1
	 EfvIR88Lc/t0lW5T2Uo8ZzxP9SK19VVCBS47duRA95cb+Fnx5+geMsl6Q3vr5rArNp
	 +sskka2hUj03Ms0ipMN+kfN6Q2VhNU1RvExbI7siogZ04Vck5kT0b/dcZwBBiJv26E
	 Xb84rfspsqOYBEJpPAjFZ18/OYnMnddOHvFbaChL87oJV99h1i4o8XlW98cxAEhpND
	 qd7lFOFPiS+re4+YvFtC7I163YqJ/dh2YKdibVt4/ciEjjqR7y64qLvz/CpO/1JDYx
	 bs6hLjD1YERgQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A510DC41614; Tue, 17 Dec 2024 16:46:05 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219602] By default kvm.enable_virt_at_load breaks other
 virtualization solutions
Date: Tue, 17 Dec 2024 16:46:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219602-28872-7culb4JiXS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219602-28872@https.bugzilla.kernel.org/>
References: <bug-219602-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219602

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #3 from Sean Christopherson (seanjc@google.com) ---
From the kernel docs:

        kvm.enable_virt_at_load=3D[KVM,ARM64,LOONGARCH,MIPS,RISCV,X86]
                        If enabled, KVM will enable virtualization in hardw=
are
                        when KVM is loaded, and disable virtualization when=
 KVM
                        is unloaded (if KVM is built as a module).

                        If disabled, KVM will dynamically enable and disable
                        virtualization on-demand when creating and destroyi=
ng
                        VMs, i.e. on the 0=3D>1 and 1=3D>0 transitions of t=
he
                        number of VMs.

                        Enabling virtualization at module lode avoids poten=
tial
                        latency for creation of the 0=3D>1 VM, as KVM seria=
lizes
                        virtualization enabling across all online CPUs.  The
                        "cost" of enabling virtualization when KVM is loade=
d,
                        is that doing so may interfere with using out-of-tr=
ee
                        hypervisors that want to "own" virtualization hardw=
are.

In addition to the latency angle, TDX support is effectively going to requi=
re
VMX to be enabled when KVM is loaded, i.e. trying to do something different
will only delay the inevitable.

FWIW, Paolo and I do want to get to a state where out-of-tree hypervisors d=
on't
need to do weird things, but it'll take some time to get to that state.

https://lore.kernel.org/all/ZwQjUSOle6sWARsr@google.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


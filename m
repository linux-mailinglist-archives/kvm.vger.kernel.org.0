Return-Path: <kvm+bounces-34275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 472EA9F9F60
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 09:56:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09D3D7A2C40
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 08:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1621EE7A8;
	Sat, 21 Dec 2024 08:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TVm7HMQh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2672AF16
	for <kvm@vger.kernel.org>; Sat, 21 Dec 2024 08:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734771402; cv=none; b=HAy0uv8pR4+0gTTXQ1A/NusutJx2R1TqMjI/XW21FTctfk6C6Pa/db97B9LwIM+jgIJPzCvGrominZih2b0+OgRQTAQiBafcgkDX9ViRHmZ5CJK7/n65ZpBoWcTmeoSXW6HFEIb6HpqB86WwAsqJR1gIWDpuShstDdgFEDPB000=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734771402; c=relaxed/simple;
	bh=y3xYl9yBnT3ara1rfJeZzHpvkEjlQu397xbsgzYgECg=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=M53RBiKOW8JqNVoF3RmwV4NGXpGe6Y+FttudhFXYOqtQfgjsphSKKk2dkxFke/QDBmmMKbnMMhAZnr6r8ixnLguTl9j2h0DTMG9N6fasn8a3b+soBqHs04HEFvQQRHlQ9GQaOjGa62IKF0QWQ0MEHTjU8sgIHnijHV6/NM0osww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TVm7HMQh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3438FC4CED7
	for <kvm@vger.kernel.org>; Sat, 21 Dec 2024 08:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734771402;
	bh=y3xYl9yBnT3ara1rfJeZzHpvkEjlQu397xbsgzYgECg=;
	h=From:To:Subject:Date:From;
	b=TVm7HMQhmDbkkhanfbBCdvPUM3bBB4a0JRXXWrdHsCUyWO1UQxBiz2Hjg5lU9pvek
	 PDUJfDFBqU0/NasCypBZfBIc4AXuXkw00pzLwT4vvnfp9eY9bhGjCf2jiu6VgxrbBg
	 Z9c95Oc8GZwp9fiuQtL1hJtTl8XMdxJLh4S5jBaE7gl9scLzpMM9esmoHrS1ZgsYdl
	 8z8s3pSzXQJ7b4W+FFYGdJ6DxmLdUd29W7fJac09Dchzt1l3xjhrx5jc31/4rNMjby
	 Vg6WkriKzKVHnBI3kmJOZLsj7tAbpG7yArrL/wBBmHRUaYSirmQ+/aUJpQ1PWK396v
	 3Tbr9FKHikxGA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 22F83C41614; Sat, 21 Dec 2024 08:56:42 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219618] New: qemu cannot not start with -cpu hypervisor=off
 parameter
Date: Sat, 21 Dec 2024 08:56:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: athul.krishna.kr@protonmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219618-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219618

            Bug ID: 219618
           Summary: qemu cannot not start with -cpu hypervisor=3Doff
                    parameter
           Product: Virtualization
           Version: unspecified
          Hardware: AMD
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: athul.krishna.kr@protonmail.com
        Regression: No

Device: Asus Zephyrus GA402RJ
CPU: Ryzen 7 6800HS
Kernel: 6.13.0-rc3-g800f6e23e031

Problem:
After kernel 6.12, my qemu windows 11 vm won't start when using '-cpu
hypervisor=3Doff'.

Commit:
74a0e79df68a8042fb84fd7207e57b70722cf825 is the first bad commit
commit 74a0e79df68a8042fb84fd7207e57b70722cf825
Author: Sean Christopherson <seanjc@google.com>
Date:   Fri Aug 2 11:19:26 2024 -0700

    KVM: SVM: Disallow guest from changing userspace's MSR_AMD64_DE_CFG val=
ue

    Inject a #GP if the guest attempts to change MSR_AMD64_DE_CFG from its
    *current* value, not if the guest attempts to write a value other than
    KVM's set of supported bits.  As per the comment and the changelog of t=
he
    original code, the intent is to effectively make MSR_AMD64_DE_CFG read-
    only for the guest.

    Opportunistically use a more conventional equality check instead of an
    exclusive-OR check to detect attempts to change bits.

    Fixes: d1d93fa90f1a ("KVM: SVM: Add MSR-based feature support for
serializing LFENCE")
    Cc: Tom Lendacky <thomas.lendacky@amd.com>
    Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
    Link: https://lore.kernel.org/r/20240802181935.292540-2-seanjc@google.c=
om
    Signed-off-by: Sean Christopherson <seanjc@google.com>

 arch/x86/kvm/svm/svm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


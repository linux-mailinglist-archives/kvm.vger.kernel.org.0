Return-Path: <kvm+bounces-33839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CE309F2CA7
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 10:15:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32E951632F2
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 09:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF6120100D;
	Mon, 16 Dec 2024 09:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDCPIFVa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1112F200B9B
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 09:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734340523; cv=none; b=iS1s/SPHmL5Unq8YdCNpQdO+F0QjVrk+0W+US0rxBrp8QKgLxmYQ3HSg0pYNGJNOJN4p9voFvXkOmdTnPFRk6qgMvCmGg3P3ldGyndmG5OKNvFFvuBLOVlyCwf3n/M2R1yONEIsazPZtfo5fRmQJSMvPCThtf2Sk8gwzYFZXw2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734340523; c=relaxed/simple;
	bh=TJpYlcg6dWaGA9ySxl7/52eeOV4SoQozbiFW3JnEhFo=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=tUEVGduuWNWwKBxsEeyMkF1/iNdRNHCQm4XXaWjX3pk83tgL/z2/1mrQ2MNvUhoXLDRQnNWpSTnSXpVylDTW8hQmF1/pUa55hG3e+ZLhFnZKbRpMzuMTQmlK5wihTqB/Rg6GUZA3i3bvvAfmQ+RMjMqCdQo9vvIuEA+stc3MtKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDCPIFVa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98A68C4CEDE
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 09:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734340522;
	bh=TJpYlcg6dWaGA9ySxl7/52eeOV4SoQozbiFW3JnEhFo=;
	h=From:To:Subject:Date:From;
	b=EDCPIFVaVUuY8BpwWucQGF2sO15nLb1REiCnNU3s87VSm3RlOgp92EKHxVYHjbW2/
	 lyWJOCAA8zwwF8nrT++2UY4VYpzk/CzbM50ihCMAe9gFHs0/MMxaA+0PMm7qeB9WE0
	 /UvcyCuCVqXpqmqwcAq1GfsBXLQVvR9IOkX2tXcaOPlpp5IyH+Ovq4HSwmuv2ehYEX
	 /WGq+13Yhw9D1825LozT1EMrRrnW/XE4QAnIs4K915lm6nXs91ev45KRqOWcabuxLn
	 +sb9ikVYjXHoRRD7tdsM4If0dha/9np9Hob3iWzEfbFk7QYGxQqPinj+PaFGLjcm5c
	 k6gIEQEgHo1+Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7BE7FC41606; Mon, 16 Dec 2024 09:15:22 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219602] New: Default of kvm.enable_virt_at_load breaks other
 virtualization solutions (by default)
Date: Mon, 16 Dec 2024 09:15:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: acmelab@proton.me
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219602-28872@https.bugzilla.kernel.org/>
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

            Bug ID: 219602
           Summary: Default of kvm.enable_virt_at_load breaks other
                    virtualization solutions (by default)
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: acmelab@proton.me
        Regression: No

Previously (kernel 6.11 and lower) VMs of other virtualization solutions su=
ch
as VirtualBox could be started with the KVM module enabled.

Since 6.12 setting kvm.enable_virt_at_load=3D0 needs to be set at boot if t=
he KVM
module is enabled, if you want to use other virtualization solution beside =
KVM.=20

The commit that introduced the new behavior is
https://github.com/torvalds/linux/commit/b4886fab6fb620b96ad7eeefb9801c42df=
a91741.
To be clear it is not about the feature itself, but the default. I am also
aware that this might be intentional; but given it deviates from
previous/expected behavior, it seems like a regression.

The fix would be to set the feature to be off by default. This would be
trivial, but first I need to know for sure that this is considered a bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


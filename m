Return-Path: <kvm+bounces-66703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 39E03CDE62A
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 07:42:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 16934300B984
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 06:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F92E272E6A;
	Fri, 26 Dec 2025 06:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k40bokTw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8404E135A53
	for <kvm@vger.kernel.org>; Fri, 26 Dec 2025 06:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766731333; cv=none; b=b7hgfllC/9LAL8R60fcVzWAvKT6KFpdKzftaJEyCtVlkLrQiutR9UgR7twnkLozSTZNyc9unu5eD1fF7GLubPtP1gaPeZhGvZDJQbWDfuq2IqmqE/cXKvon4rlqFfd52n4f9K3EMWnqb0a9gzr9E1degQ4POUrcPtg/UAHfhpxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766731333; c=relaxed/simple;
	bh=wgm+TUzi7qxjrylhRVi25BHkWG1CStcMY4tfOqKs+ew=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jKWroZI01Jxu46p8uRV+Zwkw5Q9Ek3aWoL5cD51ELBguJaH0k5F03569qNNt1sNkQIiuO2mSAq16m0Yx8Z9gigTBES2iJSUT5wEy65dOKmvLfQlUvU0jFlOm6qjIHLPRCeCwrQ1MDKPcLio/nMTQClrsE4dKEAKr5f3fD1EJNRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k40bokTw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BFCAC19421
	for <kvm@vger.kernel.org>; Fri, 26 Dec 2025 06:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766731333;
	bh=wgm+TUzi7qxjrylhRVi25BHkWG1CStcMY4tfOqKs+ew=;
	h=From:To:Subject:Date:From;
	b=k40bokTw5T2kaCNvva04ESsOCGTtwaHZ9cBO01sDPf3o97R0ZSliLLGiZ2agTzBvl
	 pUvN8TU5Qyx9HkKo5OyCypSByKmNy6h/Up9nzDaIYEYVeS3sNcU9sgzEHWLXwJRN2u
	 PDJhCJAi+/IGcWqKgSleJYKj0oanV4vyFNXBYpYHJU66CtLLp2tNQn4bELtK8aLtNF
	 SrLLqzZCdXd5tn+Wy+V6qtZGd4JMXmIYsoKuUhlcbDTt6LMrwk0Y9vM39oKA1NFOq/
	 tIv5p3LFcV+LPQqfNV9XQCZRvLmuADxIh4LLxSmnxYp3tQYJxNZdXViaMHLO/baP81
	 0SQCCbytT1efg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 56615C433E1; Fri, 26 Dec 2025 06:42:13 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220915] New: K`ILL N`IGGERS
Date: Fri, 26 Dec 2025 06:42:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cutenessoverload@toolbox.ovh
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-220915-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220915

            Bug ID: 220915
           Summary: K`ILL N`IGGERS
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: cutenessoverload@toolbox.ovh
        Regression: No

K`ILL N`IGGERS

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


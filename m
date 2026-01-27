Return-Path: <kvm+bounces-69208-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yOkBGqBZeGkupgEAu9opvQ
	(envelope-from <kvm+bounces-69208-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 07:22:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CBC24905A7
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 07:22:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7B3A530180BB
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFCAC329C71;
	Tue, 27 Jan 2026 06:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3CY0JQH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015DB1F3FED
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 06:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769494935; cv=none; b=SC16XPxRx1VvOf7XyIoJvH0B4W1hLiEarAmEy4o1JMRuLTqo7PXcRbUqT+G7b9w9zn+p41GMX9EWrvwYX1qQF6ehWVgFuJ9Vbth4S3rkw+6AeFZkmP2rw4Lmh1xuilmG4oTCY+/rccZ0ilZzkmbK1hfglqEjm7g0bVrSfIjVSas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769494935; c=relaxed/simple;
	bh=tcsCLWokNSWtRq1euyx6eu2TeLNaUTh2kVGbP3t/mhE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=G5UgKGJD/ec8uI06KARPQ304XxcA3eWXZsYA7F4ApeMkIabSZDYV0TBRrMwxa5Vn6gSkVS+U4ha8zySXHEXR0gu5xpHTMnStIgmlij+HAG1Psyg2988bUcwX5k2bkHacSlB14XChD+ag/dPoxGPUP0ewmkhUwDpei/8uVBRFo8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3CY0JQH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0756C19425
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 06:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769494934;
	bh=tcsCLWokNSWtRq1euyx6eu2TeLNaUTh2kVGbP3t/mhE=;
	h=From:To:Subject:Date:From;
	b=T3CY0JQH9O2qoBCp4tveUu4rgOL1cOMNYYD6UuP6P7i8H81FOScY54wBl354Urju1
	 YMaNG4kkvo/qKALbkqY1H8CNG+v9qhmW7ce5W1pbMqW3QjKvspR8bxgRN8Red70VYl
	 FGlqepHgGULEr7NTooVzT9KYSuacsUi8JpY4TkM8thfpIc9cXOI0TPPjJXZSXPgDV2
	 9pcPC180CE36X7ikesyuKuKs5H/jQPRnq30Tc3ZVTpz0LjxvXVpM1r1X68ebddcj8r
	 VIYed/k5dSDOYYb6ZlzKAc8/q+yT4a5HeDh9So0Kn6yv0+0BE/nm8FJenJRn5ENUf6
	 lQ2zUrK1LGvCQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 916D0C53BBF; Tue, 27 Jan 2026 06:22:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 221014] New: selftest kvm:guest_memfd_test returns 22 (Invalid
 argument) when the number of NUMA nodes are larger than 8
Date: Tue, 27 Jan 2026 06:22:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yi1.lai@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-221014-28872@https.bugzilla.kernel.org/>
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
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69208-lists,kvm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[bugzilla-daemon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_ONE(0.00)[1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CBC24905A7
X-Rspamd-Action: no action

https://bugzilla.kernel.org/show_bug.cgi?id=3D221014

            Bug ID: 221014
           Summary: selftest kvm:guest_memfd_test returns 22 (Invalid
                    argument) when the number of NUMA nodes are larger
                    than 8
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: yi1.lai@intel.com
        Regression: No

Kernel under test: https://github.com/torvalds/linux/releases/tag/v6.19-rc7

Test case: selftest kvm:guest_memfd_test

Bug description:

The execution of case kvm:guest_memfd_test returns errno 22 (Invalid argume=
nt).
./guest_memfd_test
Random seed: 0x6b8b4567
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
include/numaif.h:13: !r
pid=3D2028402 tid=3D2028402 errno=3D22 - Invalid argument
1 0x0000000000403d2b: kvm_get_mempolicy at numaif.h:13
2 (inlined by) test_mbind at guest_memfd_test.c:95
3 (inlined by) __test_guest_memfd at guest_memfd_test.c:378
4 0x0000000000402b8c: test_guest_memfd at guest_memfd_test.c:399
5 (inlined by) main at guest_memfd_test.c:489
6 0x00007efc8f42a60f: ?? ??:0
7 0x00007efc8f42a6bf: ?? ??:0
8 0x0000000000402db4: _start at ??:?
get_mempolicy failed, rc: -1 errno: 22 (Invalid argument)

The system under test has more than 8 NUMA nodes. When calling the
get_mempolicy() syscall, it uses a fixed value of maxnode (8) for the buffer
size which causes the syscall return error of invalid argument.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


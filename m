Return-Path: <kvm+bounces-69803-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mI5VLsVUgGkd6gIAu9opvQ
	(envelope-from <kvm+bounces-69803-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 08:39:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E2D5C940E
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 08:39:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5C65D3027972
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 07:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09C428CF66;
	Mon,  2 Feb 2026 07:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CAgbUKxi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140951339A4
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 07:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770017664; cv=none; b=RJDKUvp86JwMXH3dZ4a2z+73l7iVNwndzsWDbaYBvczK7/C5z2eIpJsyALt/7Sjb26W7sSQWtIgq7rUhB7o+8HSgKaWbQxaXqdGSNZI4nFj4BFkBv8tFZYfYEg2X5dJnZ1zUC3R3LDUqBvW7CCvA5g8WxwHQWlZR6Sfh1QNyMo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770017664; c=relaxed/simple;
	bh=bz4BMtQpEisORq37jLq/Epf4vK+f2pPhFmc0EpBiPbU=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=OJK1Mppz2aqgUwIxa22lO1Iipz3qoPpEkHp1CWWgTkXv5vjAkOnTpuazgO1ttK+2LaOJ7ongr5JdIm4pYTVre/MPy2Q/t8VI64bc76rvHbLVnuZ1MvO1RwwSf73hXbQfYs+UKeoiJPFFpD0sPpS/cIRVfZS2KWCZ+rv5XQgu3X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CAgbUKxi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id A365CC2BC86
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 07:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770017663;
	bh=bz4BMtQpEisORq37jLq/Epf4vK+f2pPhFmc0EpBiPbU=;
	h=From:To:Subject:Date:From;
	b=CAgbUKxiONpU2b7rZxvqpqmX3AOQ+5mFPWqdMyxaadLp+Uk5FmzPUSA7SXDb1NgSz
	 X1E9VCX+Dux5TCrmCJAaX4bYVDnLH6SDfZpHoDoMoI64todAcPmBv5joWO59coH/j+
	 4329ixBaH9rm0iXHAx6Xz7/2BGVgABGfpL2uahlu1BHg/LYSBZQVhb1nELgo8zbNug
	 WL3Bw11baQBmlEiP8jZpK3CDRKry+6ntoe88ZwOe2Yoj4jUEZ8EIePoMO4fsaOBZ1s
	 0JeyoLsphaU6ipG3rcG3swSipQZwMEW/ON94TljysVAjwrEHjStOgskDGCyWkOyi8y
	 +iRXlHMNAZ79A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 99C40C53BC5; Mon,  2 Feb 2026 07:34:23 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 221033] New: Real time clock does not trigger alarm on QEMU
Date: Mon, 02 Feb 2026 07:34:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: richard.lyu@suse.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-221033-28872@https.bugzilla.kernel.org/>
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
	TAGGED_FROM(0.00)[bounces-69803-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email]
X-Rspamd-Queue-Id: 1E2D5C940E
X-Rspamd-Action: no action

https://bugzilla.kernel.org/show_bug.cgi?id=3D221033

            Bug ID: 221033
           Summary: Real time clock does not trigger alarm on QEMU
           Product: Virtualization
           Version: unspecified
          Hardware: i386
                OS: Linux
            Status: NEW
          Severity: low
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: richard.lyu@suse.com
        Regression: No

LTP test rtc01.c [0] attempts to enable alarm via ioctl() RTC_AIE_ON on
/dev/rtc. Following select() timeouts (returns zero) instead of triggering
alarm. I would expect to fail with -1 or pass, timeout is strange:

./rtc01
rtc01       0  TINFO  :  RTC READ TEST:
rtc01       1  TPASS  :  RTC READ TEST Passed
rtc01       0  TINFO  :  Current RTC date/time is 14-11-2025, 01:35:18.
rtc01       0  TINFO  :  RTC ALARM TEST :
rtc01       0  TINFO  :  Alarm time set to 01:35:23.
rtc01       0  TINFO  :  Waiting 5 seconds for the alarm...
rtc01       2  TFAIL  :  rtc01.c:151: Timed out waiting for the alarm
rtc01       0  TINFO  :  RTC UPDATE INTERRUPTS TEST :
rtc01       0  TINFO  :  Waiting for  5 update interrupts...
rtc01       3  TFAIL  :  rtc01.c:208: Timed out waiting for the update
interrupt
rtc01       0  TINFO  :  RTC Tests Done!

The bug only triggers in a VM, not on bare metal. I'm not sure yet whether =
this
is a bug or expected behavior within a VM environment.

[0]
https://github.com/linux-test-project/ltp/tree/master/testcases/kernel/devi=
ce-drivers/rtc

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


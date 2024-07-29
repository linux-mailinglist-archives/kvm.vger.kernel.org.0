Return-Path: <kvm+bounces-22500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A95AE93F4FD
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 14:17:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 552FC282B7A
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 12:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9CE1474A6;
	Mon, 29 Jul 2024 12:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6pAQpai"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119BE768EE
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 12:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722255432; cv=none; b=YvoXnS2I3EdEhuRWh18Juy1gNngX4fXpaLOFT0XLTMVyt0AR9XdntRCmSCFcJ7/qHgd9s04Zn6I2JKqHEsjwWDDyugLscuP60y5mFk4yFizN2CRnBcJ4cf/ezCT/s/4LWVYt9iB+qzq+6rssL9wL1p5liPCSfQ2ckZlkHmcjscc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722255432; c=relaxed/simple;
	bh=Lk672Co4YSpZfrqBVQe4J83XFLDpbR0ABpHc81T5TEg=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=S3KNpmoaCS5OuB5RoBwSpwZH6VywHa4RbRJ4pX6uf00jpO/KnR38BLP/0fMzMCiS+Pr5Q24EXNVIzzcqHO7JnRR7NX4Kko7F3tHCs9YHRLXjtdtwtkiHxr/hwAg7E7jy4QZzjlAB2Q7X+r/Q4QIR9DFrXo9l2t+YjZnOoDrDQW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p6pAQpai; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9ED08C4AF0E
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 12:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722255431;
	bh=Lk672Co4YSpZfrqBVQe4J83XFLDpbR0ABpHc81T5TEg=;
	h=From:To:Subject:Date:From;
	b=p6pAQpaiW8rcn8MrPctEQIKsp5Zet1/hxJMBEyHezqYJprxV3RrrYiPlEAV7hHzGx
	 zk0onk3T2Jr3evTgeZd+OMx11o/rIfp0Y9cXOY3O9cjGKxX/IP92d96g3Iww0oVGsS
	 jh+vNpxRcEg9feWTXjnI0b7Ebh+CBGHUmRTF7yXHkRWLupe8zSNpvYk8Nrj8Y92RXx
	 Z7g5U52tRVbkjDJH/hlXY4ZOj2PsbyUJergBYQzOjtcmkebkdiJh29DSfOW8EPV/PA
	 4X+yvZ8oLGRN/FCM0x1OUMDoQA2MiiX+DH3SYNU4QaFKjvAJymTwWiFhYrohAdFxTC
	 wIGeMNnPMbkTA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 94EADC433E5; Mon, 29 Jul 2024 12:17:11 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219104] New: A simple typo in kvm_main.c which will lead to
 erroneous memory access
Date: Mon, 29 Jul 2024 12:17:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zyr_ms@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219104-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219104

            Bug ID: 219104
           Summary: A simple typo in kvm_main.c which will lead to
                    erroneous memory access
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: zyr_ms@outlook.com
        Regression: No

It seems there is a rather simple typo in `virt/kvm/kvm_main.c` function
`kvm_clear_guest`.


// virt/kvm/kvm_main.c:#L3586
int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
{
        const void *zero_page =3D (const void *)
__va(page_to_phys(ZERO_PAGE(0)));
        gfn_t gfn =3D gpa >> PAGE_SHIFT;
        int seg;
        int offset =3D offset_in_page(gpa);
        int ret;

        while ((seg =3D next_segment(len, offset)) !=3D 0) {
                ret =3D kvm_write_guest_page(kvm, gfn, zero_page, offset, l=
en);
                if (ret < 0)
                        return ret;
                offset =3D 0;
                len -=3D seg;
                ++gfn;
        }
        return 0;
}


The arg `len` of `kvm_write_guest_page(kvm, gfn, zero_page, offset, len)`
should be `seg`. And this error will lead to clearing a lot of incorrect
memory.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


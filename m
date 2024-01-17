Return-Path: <kvm+bounces-6380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2447E83016F
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 09:44:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00D75B236DE
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 08:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EEA913AED;
	Wed, 17 Jan 2024 08:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m9odmVqO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6149213AC7
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 08:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705481055; cv=none; b=qtXlN158f12NYMNlyARSdVYTiYbVb+DFU4s0muL6hYAnAX4LnAgqEGAGe6lqaIrmjdkHcs1S6Z9CxmC51z1hxaZfjDGzwvsRICVqvWVO87RdOca/4i0yRPGC6vmQXP8x0LDnO6RiS+dod+Cb65ampSVbwNXdMlhnAAYL306N710=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705481055; c=relaxed/simple;
	bh=4Lxxhd/qtcNb5R86uUpOj9cupHe8QEnhCjg7gUFRYJk=;
	h=Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:Content-Type:Content-Transfer-Encoding:X-Bugzilla-URL:
	 Auto-Submitted:MIME-Version; b=jmfQKETRp0MsOJkiIJuezxZ5AEC/11qGVVy071BLiblg/Vj4zuKEUbPyaLONI6WJjHdvD6J3bug7ZZ+7tOBu0/e+QNh/Y2ikapOtswo/jPg+34exng+4A3J1mj24LXFBFvH5ZlWg12SDstC40j1ekdlIXHJPrn1kizWxfX1c9ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m9odmVqO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3297C433F1
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 08:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705481054;
	bh=4Lxxhd/qtcNb5R86uUpOj9cupHe8QEnhCjg7gUFRYJk=;
	h=From:To:Subject:Date:From;
	b=m9odmVqOoXVa8WY379/8J0sTUqtxiOJnPzxIZtT1QRfdud1jOX3I+h54xX+IFJOqC
	 tTHQW04LAzvUXeDfvkGjWKNxpcjpnRPB3f2s6WPPYv6xIPxyGJcaaMaeN2Ua9Zc6cu
	 DHrvF0Y69ix4si4ZP7cMijy1SpS/63aED958N7v5LR9b2bpHZgB3ninDqyKp51dutf
	 A1Xmz3C7fyIPfLDyp6lSTRZ7h7Ll91VkBCojMjx49QYqXscotMkYmcjL1OXoMDh7OH
	 dGT4wiYMa/yzuhY8id20zYrCHnNrBI6Vfu1AZ2xkVek6y0p5sjmvOaDW53dRLjZpWh
	 SgCeYh4g3AK5A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id BD169C53BD0; Wed, 17 Jan 2024 08:44:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218386] New: kvm: enabling virtualization on CPUx failed
Date: Wed, 17 Jan 2024 08:44:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: antonio.petricca@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218386-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218386

            Bug ID: 218386
           Summary: kvm: enabling virtualization on CPUx failed
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: blocking
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: antonio.petricca@gmail.com
        Regression: No

Hi, I am on Ubuntu 22.04.03 with kernel 6.5.0-14-generic.

Running a VM by AndroidStudio, it does not start, and into the DMSG log I s=
ee a
message like "kvm: enabling virtualization on CPUx failed" for each CPU.

It works with kernel 6.2.

Regards,
Antonio Petricca

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


Return-Path: <kvm+bounces-69209-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJ8HHr1ZeGkupgEAu9opvQ
	(envelope-from <kvm+bounces-69209-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 07:22:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CDF57905AF
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 07:22:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 33C0F30180B1
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA87032937A;
	Tue, 27 Jan 2026 06:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ey8x7W3d"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F284A17D2
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 06:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769494964; cv=none; b=GyF0O16LbRTsMhKudtoDYKSWoe4z38zjE27sT2Jnm+ht9YXe3GDXsdAxwinXrGOdyr9yRk7OaAd46RZZsP1KP1N/kRcyzFYj01eC6QmObEWXqngGkn9nN+Xqcc8cnOC3dybaz49uCIbXX1u9e3ZUCa98g9hDu3XRbBHYq//CN4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769494964; c=relaxed/simple;
	bh=baw94JQieZ65DPIBrtpVoERahUzdjStiARs+2/rOwZ8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XgMqYpanVxKtoH1r93Y1ZGPuMCypdCctThfkn1zEZ81Ubr3uqNcKSMba5HQpu2evfAHjqQsdxZCgwB00MmdZfMO5wboJvCCTGRAEmScmjH6/Fg6f5HZ3M18ZlZ6r5rtL7+qnEFPsrkYr6osU+yX4RowXobn8hfsMNLdy0RGvr3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ey8x7W3d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B16AC19425
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 06:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769494963;
	bh=baw94JQieZ65DPIBrtpVoERahUzdjStiARs+2/rOwZ8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ey8x7W3dI/vW/BC5pBH1WGe81TFVKalJU9vUl8/2BnmAdxSyNFSJFTom30uUgjZ5+
	 oFqvWybv1/E7rF108v5FYTo5TACyv68wAQ4Y6sceLOfmdDVmQVX1jdOx0kH/Dy1foS
	 zV36/C42QZr43vhFsHlZ8BXdP/pSsdF+kcB7r58mTvLmQF61fx/GLITyvur8k2QrSW
	 +A+vfO7kdiCEKHjNVMVo+PDZWjvMZT22RTYVmQ0Y6MOD5Qvzvwoamwb5tCDp/04+jP
	 hP6nGj/VixaXjQragHcNCVb/MXOQTXXIr9znAFTZiep63mlY2lxporkphhd8Ox3x06
	 S1eFDhSWUsXIg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 83EB0C3279F; Tue, 27 Jan 2026 06:22:43 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 221014] selftest kvm:guest_memfd_test returns 22 (Invalid
 argument) when the number of NUMA nodes are larger than 8
Date: Tue, 27 Jan 2026 06:22:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
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
X-Bugzilla-Changed-Fields: rep_platform
Message-ID: <bug-221014-28872-As5SwzRllY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-221014-28872@https.bugzilla.kernel.org/>
References: <bug-221014-28872@https.bugzilla.kernel.org/>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69209-lists,kvm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[bugzilla-daemon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_ONE(0.00)[1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email]
X-Rspamd-Queue-Id: CDF57905AF
X-Rspamd-Action: no action

https://bugzilla.kernel.org/show_bug.cgi?id=3D221014

Yi Lai (yi1.lai@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Hardware|All                         |Intel

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


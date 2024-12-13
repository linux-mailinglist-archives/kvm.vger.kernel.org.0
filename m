Return-Path: <kvm+bounces-33756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93CEA9F138F
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 18:25:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BB61281554
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9361E500C;
	Fri, 13 Dec 2024 17:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ty6KmMvA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EBF1422D4
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734110748; cv=none; b=rqFzMBQyyrTVpD/ZkoreP7Z6AlmYbt2K+DJRvMy00c6eUdMYniv6SmGh7gOisYQT32WFJ1p/vE5R1CPIboja7Jvw13UDFCRKZJi9X3gmlr189iR47HfA+DGcU+aAukw0+enyy3axKUVwY7JCQpZVg6d2wwEvOg3osEEc0C6RAJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734110748; c=relaxed/simple;
	bh=NQ3ch2rMJkO6pTAQsDIELog8cM1tR9Db3DznuJsMgLA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KOPTbHHPlUfv2JMyzDCX0Zms3Ch1MkZRCZapYAG5Qkw0SUxNfLIw2rm3vlizEOP5Uke8OZ4/h71f2a7GK+gHvH+hJ6dkzxalPfYBodz3PjGtw46Y4lktsn/CZpIBOPaEqKoo8TcOCL+5EyoqmyBgdC/izOWAilGhVGQsTdN2OxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ty6KmMvA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED991C4CEE3
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734110748;
	bh=NQ3ch2rMJkO6pTAQsDIELog8cM1tR9Db3DznuJsMgLA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ty6KmMvA5xkJqA/omJJfimDNI561GQt96HvmW6muNFm+7x2lloJbDckTp0qXlHeQ9
	 flAXOV3f34RGjindQpoToT/YKfRk7O0v5laO7yR0i5VtsmCBL2FQCDi/WWlrx8Mspa
	 Ev7lLmkOQ2hO14dhw/9RVFOPvsqA0+ZMBMue2TZS0uzjpgSZpr2wZ+qry5fRWkoiPl
	 eAj/HpmxVzHjgfmgAGqig3pwAmPJBzBd2bWhQ0swTYrPc+RsjyGRhPN+r5vMfbZxBq
	 3CVxQby7cZSBRpVh00N+I7KTrORig+n6KkIoaXxWTzZy7ia01rET+zH2v1tF/x09DV
	 vuyFNAXl6nvFg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E5143C41614; Fri, 13 Dec 2024 17:25:47 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218267] [Sapphire Rapids][Upstream]Boot up multiple Windows VMs
 hang
Date: Fri, 13 Dec 2024 17:25:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218267-28872-7E0jDCZcud@https.bugzilla.kernel.org/>
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

--- Comment #6 from mlevitsk@redhat.com ---
On Mon, 2024-04-08 at 17:22 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218267
>=20
> --- Comment #4 from Sean Christopherson (seanjc@google.com) ---
> On Mon, Apr 08, 2024, bugzilla-daemon@kernel.org wrote:
> > This is not considered a Linux/KVM issue.
>=20
> Can you elaborate?  E.g. if this an SPR ucode/CPU bug, it would be nice to
> know
> what's going wrong, so that at the very least we can more easily triage
> issues.
>=20

Hi!

Any update on this? We seem to hit this bug as well but so far I don't have=
 new
details on what is going on.


Best regards,
        Maxim Levitsky

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


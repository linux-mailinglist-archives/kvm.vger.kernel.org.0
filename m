Return-Path: <kvm+bounces-19183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE8E902017
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 13:05:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFFC0283DF5
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 11:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B8478C9D;
	Mon, 10 Jun 2024 11:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HAZ1bQ8A"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB05B75811
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 11:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718017500; cv=none; b=cetYbfzGZJmzeoc1poNDz0gceaOygmM83wkZ3fXShTNVW5wUFTnXjlyZQLAARgoyXcgjcLH6gOFShx9b44eu3ExQ2+aX7qnncQVnOnAn168Brt/tPGs1zthDJtUfmzyuEVmOjR0CMoWjZpvkOUV578F/D8UrUoa7+fWQc9YgCv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718017500; c=relaxed/simple;
	bh=oHTjrGZQIxMB70ZKe35RNhqrx5oXWuEIt4wpuNBXFbk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A16JFT8GA3Ay6ZCe28EivrnsAazXpilqPiB9rJWHvrwKoJ8kKVoZUNih7MdR/BFIMd1h65m0AS48mCtQL9aDQhDTg/yWOs5S+axPnG7muv/SoQT/KBld53TiNTawkearZzMH6Daz0Th4pIYuPMHquD5fDDxNZ0+WN9SnCGk1ii4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HAZ1bQ8A; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A909C4AF1A
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 11:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718017500;
	bh=oHTjrGZQIxMB70ZKe35RNhqrx5oXWuEIt4wpuNBXFbk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HAZ1bQ8AGLUuOY0cTillZ7G9t6fMdxtpd9BSmK7rSKHrNAM6CZK1VeZcG/wdX44oE
	 siLTVKqcc585nJ26v+I9t6GncCME97p4UK5YgikyoWGdlV9elfKlS6qa6ZKsSzaLWm
	 CiquNUUdQ9V0YfpuwOEqeF6P+fw0r/rFg+qePvBflSXz8aVLKFaO/K/aph94UtHyfi
	 dLQf5M58+ZsENtvYa0Xv+H3nze4wSKVJJGnAtMP26Dr8oUmvN8Aj1yaqAHGyJ3HQd/
	 Q6REHydhE+sMU4FPstZAylWlamgmqQt/tUDELr5khukLotPjdex5uE/8mzZHm56Cqb
	 mr+GZgWyM5Mgg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 619F8C53BB8; Mon, 10 Jun 2024 11:05:00 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218949] Kernel panic after upgrading to 6.10-rc2
Date: Mon, 10 Jun 2024 11:05:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: badouri.g@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-218949-28872-sevokGK5Am@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218949-28872@https.bugzilla.kernel.org/>
References: <bug-218949-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218949

Gino Badouri (badouri.g@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|6.10-rc2                    |

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


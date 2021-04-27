Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512AC36C9DF
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 18:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbhD0Q7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 12:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236693AbhD0Q6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 12:58:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 68486611BE
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 16:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619542684;
        bh=+WWoBXXqqCe17BITCPpKTBBkltaGzN8xgsmZt9hHJO4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DXf4Sabr1iJjg5wiqVpKieM7oet9eW3nxLLZgiYHwsVH+S1EJ24Bwjwfrpz0/I2kU
         1W2ayeg5cZ163Zz6UvrWJOR97qp0WbLIJZRc2SqekqVe+xtWXJpOigCJXiwODAWiCo
         MaBG5NSbt+oEn1d5evR2RG1rsEFjzSUiO8y+GTtbJ54fHCw7+DEHSd5cLHWheDamOO
         +2Ppz4DcHqFucSJouSMymKhTqsSYK5RuAvX2P9izIPzpDc/Zs6utHfE3tnEhThSWcz
         QJQFzCQcW6t4THPs5Cesm6u+0w6SzTgD53Et3NDTFaUoN61Fs8Gp5W4K1eI8mXtXjX
         510smai13sLsw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 6556361247; Tue, 27 Apr 2021 16:58:04 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 212859] Nested virtualization does not work well
Date:   Tue, 27 Apr 2021 16:58:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: opw
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ne-vlezay80@yandex.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: keywords cc rep_platform
Message-ID: <bug-212859-28872-nnSi5B04yd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-212859-28872@https.bugzilla.kernel.org/>
References: <bug-212859-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212859

Alexey Boldyrev (ne-vlezay80@yandex.ru) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Keywords|                            |opw
                 CC|                            |ne-vlezay80@yandex.ru
           Hardware|All                         |x86-64

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

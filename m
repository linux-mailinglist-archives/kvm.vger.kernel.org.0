Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BA740A17C
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 01:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344407AbhIMXUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 19:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244272AbhIMXRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 19:17:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9E4C760F51
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 23:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631574406;
        bh=jASxUEWEnBPww+nXjEDRkzFRlS1fKT6zXDr/mq/m6tc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iMA7r1SO+FSmNUAjcS4aKzV5K1f+E7lEal9VB6FtxJCgRUlzIVQ5Q5gjtoWHXUmgC
         tLdognB9V3G1QGObPIfbjkiaUFQo/6yFEBKmK6QZ+kpUJxsnZwLvq35SLSehSOw3zn
         TluhCDAVYtphnB5JlgmzTq/lqEV4riP7oDoXEzhEDzxz78DMJ3TqADM/JCdvmaBb+3
         mGhYnolh+b1YAp8B+nGpiNV/iBVaMGNViJxB6cB+aGATBM4/zMm0fHHzLRwzWn5lT7
         boqEDWPj8UuF6TEpLcpwwUfdiYwNGFJSqx1bE6hqgwpaQjPX/FxgfxEUt2rTpJP1ki
         IWu3PlNLubNTA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 912BE60F6E; Mon, 13 Sep 2021 23:06:46 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 214165] Missing clflush before RECEIVE_UPDATE_DATA
Date:   Mon, 13 Sep 2021 23:06:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-214165-28872-UAKkEJJSJ5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214165-28872@https.bugzilla.kernel.org/>
References: <bug-214165-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214165

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
If you can provided a Signed-off-by, I'll happily write a changelog and post
the patch on your behalf.  Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

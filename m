Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0B3474816
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 17:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhLNQah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 11:30:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43890 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhLNQag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 11:30:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 362FDB81B46
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 16:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5E0DC34606
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 16:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639499433;
        bh=DflI8jrQz4LmP1gRIUuZdp0Jsj8raekDWzH1TyEJWmA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=g8tEddM4UQ1udJbS9Rz4k2apCQsvDW+uHMiynLA7VBYwpHnbrxtN2cps8e8SgryZM
         YV2269Ts3XFgnrxo1CF7tH9NHmXQL0iBKKO73pZHknEW0N279ptdDk78Cu1OJ2L1ti
         RrMyDG8e8RdZANNcVKaOyBmF8mmvx/Vlgnb87s+7w0oaBCmnDsFLaeX411LoQmKvtP
         XB/4ltIvZxpqvVTBx4x4zfyn9ZktJK1SfNKwpbfXnfpu8nJpY7HI8es3JzbPJVeCSr
         +7ojneqrSmze8w/UnyC6HEbNA6ND/A2Hz17oatJU+sMcgyUsgjmmUaOtDFi2CbLl6E
         ZgMML8EdF6u0w==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id D7CA560F5A; Tue, 14 Dec 2021 16:30:33 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215317] Unable to launch QEMU Linux guest VM - "Guest has not
 initialized the display (yet)"
Date:   Tue, 14 Dec 2021 16:30:33 +0000
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
Message-ID: <bug-215317-28872-oY5sK2hMc7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215317-28872@https.bugzilla.kernel.org/>
References: <bug-215317-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215317

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #3 from Sean Christopherson (seanjc@google.com) ---
This is my goof.  We're bikeshedding over a minor detail, but the fix should
definitely be in rc6.

https://lore.kernel.org/all/20211209060552.2956723-2-seanjc@google.com/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

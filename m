Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7121C473EFD
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 10:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhLNJKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 04:10:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59312 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbhLNJKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 04:10:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 379026138B
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 09:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A618C34601
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 09:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639473006;
        bh=aBmFuGgJa2PsfJ/JoXoPOJiDalbcd3Hx0NausXr4+pw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PVgTUd8G9NavfAxydJwhVKCphvtTf7+r54cqQJwZyEC1LFJqSlxhPpI0anbkN6FsQ
         KAocst3mGd/EP4l96+VsgRKBliTJY/o2PTCia+jKc0larTZlIzX1uQK0TjS34H/XYJ
         puxwwKbUzsDxrDW+liceHQDpGxGY+x28odVSJvSQvfz8oXeveWCc7NiWhJFTHPF6QH
         IFoqPHj+AKHwXGBq9ew6pr4wA42EdD52IVqf3SDosqHNxIofR80A8VQ7vXpHQWf95N
         tSiHhF3QtmcCMFwkxky8eIWGLYzNYPp8Tbs05awxLut77jpnx+V9qQJygq89WGwa9Z
         0r3ekSgfOSk5w==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 86DA861139; Tue, 14 Dec 2021 09:10:06 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215317] Unable to launch QEMU Linux guest VM - "Guest has not
 initialized the display (yet)"
Date:   Tue, 14 Dec 2021 09:10:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215317-28872-pyOEhTXj0W@https.bugzilla.kernel.org/>
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

--- Comment #2 from Thorsten Leemhuis (regressions@leemhuis.info) ---
Hi, this is your Linux kernel regression tracker speaking.

[TLDR: adding this regression to regzbot; most of this mail is compiled
from a few templates paragraphs some of you might have seen already.]

On 13.12.21 02:38, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215317
> [...]
> Something changed between kernel 5.16.0-rc3 and -rc4, and remains unfixed
> between -rc4 and -rc5. Attempting to start a QEMU VM, the display is stuc=
k at
> "Guest has not initialized the display (yet)". The QEMU version I'm tryin=
g is
> 6.2.0-rc4, but QEMU version 6.1.0 has also been tried. I noticed many cha=
nges
> in the KVM code between Linux 5.16.0-rc3 and 5.16.0-rc4, and I apologize =
for
> not being able to narrow it down.

Thanks for the report.

Adding the regression mailing list to the list of recipients, as it
should be in the loop for all regressions, as explained here:
https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html

To be sure this issue doesn't fall through the cracks unnoticed, I'm
adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot ^introduced v5.16-rc3..v5.16-rc4
#regzbot title Unable to launch QEMU Linux guest VM - "Guest has not
initialized the display (yet)"
#regzbot ignore-activity
#regzbot link: https://bugzilla.kernel.org/show_bug.cgi?id=3D215317

Reminder: when fixing the issue, please add a 'Link:' tag with the URL
to the report (the parent of this mail), then regzbot will automatically
mark the regression as resolved once the fix lands in the appropriate
tree. For more details about regzbot see footer.

Sending this to everyone that got the initial report, to make all aware
of the tracking. I also hope that messages like this motivate people to
directly get at least the regression mailing list and ideally even
regzbot involved when dealing with regressions, as messages like this
wouldn't be needed then.

Don't worry, I'll send further messages wrt to this regression just to
the lists (with a tag in the subject so people can filter them away), as
long as they are intended just for regzbot. With a bit of luck no such
messages will be needed anyway.

Ciao, Thorsten (wearing his 'Linux kernel regression tracker' hat).

P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
on my table. I can only look briefly into most of them. Unfortunately
therefore I sometimes will get things wrong or miss something important.
I hope that's not the case here; if you think it is, don't hesitate to
tell me about it in a public reply. That's in everyone's interest, as
what I wrote above might be misleading to everyone reading this; any
suggestion I gave thus might sent someone reading this down the wrong
rabbit hole, which none of us wants.

BTW, I have no personal interest in this issue, which is tracked using
regzbot, my Linux kernel regression tracking bot
(https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
this mail to get things rolling again and hence don't need to be CC on
all further activities wrt to this regression.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

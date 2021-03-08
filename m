Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEA2330BA8
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 11:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhCHKqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 05:46:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhCHKqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 05:46:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 581F965203
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 10:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615200371;
        bh=tb70iTu2usueSPChTzC8zlB6gCTr3FZcZENdwUY2oCc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NTDqvk1k02DQZx9mnkaJVGbYdHqUOOe1VEoR7+rtAn4r1MpqP4qCRXQ0DzA2NxnWj
         POYcOb0UaJ8a54GaN/z0aNwvybcwj7a/ma//xcjWrwi2EmRa08ETIuM07/RAnjsZ6o
         4Cjii8IA09rBc88RIfHpTwmNgAZ4TUINxefeY+1jCZl/4E/s7d/zZEunLtc9RJN3rx
         OtPJVg9WMJU2jnVWF7MHVFDmrlTwt7FtokwlMwWG7BfcyiDiY8LEYEMYYP7yNB9V8F
         4QS5VV6IoJy6zEAI3/t7JOskN28ATu6s32GT/0nXYq4xMOTY1+ANVTAXxB7kuOCoIu
         O6ogqA6wQNfPg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 55B3D65351; Mon,  8 Mar 2021 10:46:11 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Mon, 08 Mar 2021 10:46:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david.coe@live.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-luwNmKXOZc@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201753-28872@https.bugzilla.kernel.org/>
References: <bug-201753-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D201753

--- Comment #21 from David Coe (david.coe@live.co.uk) ---
Good morning, Suravee!

One (final?!) test of your patch (with increased retry count and logging) on
the latest git kernel (5.10.0-rc2) all on Ryzen 2400G. In summary:

 5.8.0-44   (Ubuntu 20.10) 6 trys 20 msecs
 5.10.0-14  (Ubuntu 21.04) 5 trys 20 msecs
 5.12.0-rc2 (raw git)      6 trys 20 msecs

AFAIK you are AMD's go-to guru for open-source people and an IOMMU expert. =
It's
your patch that is now both in the kernel commit and (I hope) in Ubuntu's t=
o-do
list. Could I ask if you could patch-the-patch (if there is no esoteric
technical downside) to increase the number of retrys? Maybe if Paul would g=
ive
it another shot with his Ryzen 2200G with a larger maximum count and his
logging :-).

Best regards and our thanks

David

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

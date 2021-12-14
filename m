Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB6D473BF5
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 05:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhLNEZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 23:25:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53508 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhLNEZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 23:25:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66C10B817DB
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 04:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6BD8C34604
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 04:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639455952;
        bh=6e55LovKUpSbuApAjA8NaSPUezarH3QzJXJaPdXlWqY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=lKLcTw2bHxqNcklbjkktvi60uKCH06mg3/2xM9BxeKs0akGpLuf1SGb4Y1LkCbWgV
         ENLXu0GSm0HAmQ0SRbvJbHPXtRHd/qVyukd3unpMlz6UHDgsddTJzhPGkJIL+da7kX
         uY6d7xzYzjXcrL3Zwmecjl5vZY8jYLniLutbahIEgq4YVyxjlo+7EpgL6RCx8pdINw
         48kbWoF0eo/CJN3M3EjeITzHn7NS3a8ohPKO32dFl5qQwAD2iZ/DXlm5ZtMW3FXc0u
         mYejB9xukFBcEg0UW3xBSX6T/16mzlYBRmfvvuXoV7t3ETRGmX/EKhhg/kKMOjgDRh
         5mHtaD3eCoxeg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id C8A6E611AF; Tue, 14 Dec 2021 04:25:52 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215317] Unable to launch QEMU Linux guest VM - "Guest has not
 initialized the display (yet)"
Date:   Tue, 14 Dec 2021 04:25:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rherbert@sympatico.ca
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-215317-28872-gqT72gGzwA@https.bugzilla.kernel.org/>
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

--- Comment #1 from Richard Herbert (rherbert@sympatico.ca) ---
Created attachment 300019
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300019&action=3Dedit
qemu-kvm stack trace kernel 5.16.0-rc5

Qemu-kvm bug when starting VM with kernel 5.16.0-rc5.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

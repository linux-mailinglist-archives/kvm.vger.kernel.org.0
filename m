Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4434D471F2E
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 02:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhLMBir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Dec 2021 20:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhLMBin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Dec 2021 20:38:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB04C06173F
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 17:38:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAE58B80CAB
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 01:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E3A5C341CB
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 01:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639359519;
        bh=Mf7y9AAOijwdV8Kpl7l5HQV7+kgfzvL7u9e9hq2Chkg=;
        h=From:To:Subject:Date:From;
        b=oEFhN1pkq5mwQpUxl2DTwLY1KWS0HnofrHMvaXOlrvr9wp5m8tO+WwRRhga7UPgn2
         GObQTfKZ4xRG+IQ3dmBoM0qoKDdaUrmDjT0+MJXe1M/iZ5GdXo0CJjtNffFDou9K/j
         VmyK3iYqqIxtFLiqVuDH7t/ZU9C5yqukt4wY1JnbNNS+wKTGKCNQ/zRCTPsdrdSxau
         b3GgOf09nwSnxBAYhDv8nhl0vTJwHCVOQKATGiNkdiU8mK3zZBuUHCEavBZuFrOVVU
         kTPs140fMQJJ8FuEFnQ9uy20D3XBTT3axXeSu/jwDlOfgi8XLfX9TjJsgsmezz97Ka
         uUAG/QHQFgkmA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 84FA1610FB; Mon, 13 Dec 2021 01:38:39 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215317] New: Unable to launch QEMU Linux guest VM - "Guest has
 not initialized the display (yet)"
Date:   Mon, 13 Dec 2021 01:38:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-215317-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215317

            Bug ID: 215317
           Summary: Unable to launch QEMU Linux guest VM - "Guest has not
                    initialized the display (yet)"
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.16.0-rc4
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: rherbert@sympatico.ca
        Regression: No

Something changed between kernel 5.16.0-rc3 and -rc4, and remains unfixed
between -rc4 and -rc5. Attempting to start a QEMU VM, the display is stuck =
at
"Guest has not initialized the display (yet)". The QEMU version I'm trying =
is
6.2.0-rc4, but QEMU version 6.1.0 has also been tried. I noticed many chang=
es
in the KVM code between Linux 5.16.0-rc3 and 5.16.0-rc4, and I apologize for
not being able to narrow it down.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

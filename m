Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0B736C9D9
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 18:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237984AbhD0Q6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 12:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237993AbhD0Q6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 12:58:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 48FA36105A
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619542639;
        bh=yKa+ob5V75yry2sndfvZzrSoade7VNgZQo+US3sqfgY=;
        h=From:To:Subject:Date:From;
        b=KQPb+b8fUCNMR4UpgKYbtLIurAAWWglJwlazWPQt5EeFKI2N978aWfJhjJ4XPFRP+
         2SUWtghBtNMzlGzwO+UebJBct/uer7tykVotSSpdw8JnVKvhUHBu32/rdNdJSh6dWC
         rMd+om7jV6vsW5aMBm2zxpSjznRM2+5YHESvzZV3/4sFssR2BhP4unKiWl5BMox4D9
         r/OAWVKH3fRfxCd1Cz9Rz5YnQP6FmzqvabHNp35I3x1V4XOrc6ek88GAS+HXVZBbr9
         udFDOyjfnKiglOdERqm2ISqOESb1bUTtYxZPeP4qNBp5clBVEWMoTAwwI79gsuZR4Z
         JeHWKVUC6OvHQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 41BB661247; Tue, 27 Apr 2021 16:57:19 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 212859] New: Nested virtualization does not work well
Date:   Tue, 27 Apr 2021 16:57:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ne-vlezay80@yandex.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-212859-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212859

            Bug ID: 212859
           Summary: Nested virtualization does not work well
           Product: Virtualization
           Version: unspecified
    Kernel Version: 4.19.188-amd64-cust1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ne-vlezay80@yandex.ru
        Regression: No

Qemu version: 2.8.1

System: Devuan Ascii

Problem:

If you try to use nested virtualization and run linux or openbsd on it, then
the system inside the nested virtual machine periodically freezes. If you w=
atch
strace, there are a lot of timeouts during the hangup. But, if you use a ke=
rnel
from 5.10+ and qemu 5.20 on the host, then everything is fine. Nested
virtualization works fine. Also run kernel 4.19.* on qemu, problem is not
appers.

Demonstration:
https://youtu.be/mrMPukeTntQ

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

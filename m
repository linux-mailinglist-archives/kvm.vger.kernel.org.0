Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24F848D732
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 13:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbiAMMJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 07:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiAMMJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 07:09:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AF1C06173F
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 04:09:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B007B8226C
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 12:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09927C36AF3
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 12:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642075749;
        bh=dBeA/a7eCEuvyfjHc9lXPjmy2xphLybZtH61xccsnP0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qNYnJxyfmXvjD7kozU7FW9MT4NgGs1dnIHbzS92bLXixJzhhU7NGCo7ytbefzvIOQ
         tyj4HMbDCEPjMjgLS+kau4ExnlqR1rvrPOGGexCpMyx3zvtjbY2fi3tuUUD/MaiYeb
         hDd64P+AG0DFne8wxWLcn1h5HoNZp/wToqmya+GXqsWylqxEenjj2fDx504DjVdQE1
         JOMJ6R4QzK2qroWnA7bKVHbWjYU2VBOfJRURG3qQChPc6y/zyOEU03UG2f1NWBCQPi
         cWLef6mt0PFPzOaPbNlGmXTiAUK1VxlUvEddrm6PURamzO/0WE0LpRvlhfc4iHqwMc
         1z8lqv6Kze7sA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E8252CC13AF; Thu, 13 Jan 2022 12:09:08 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Thu, 13 Jan 2022 12:09:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-WlxdwVp4EK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #6 from Roland Kletzing (devzero@web.de) ---
what i have also seen is VM freezes when backup runs in our gitlab vm serve=
r,
which is apparently related to fsync/fdatasync sync writes.=20=20

at least for zfs there exists some write starvation issue , as large sync
writes may starve small ones, as there apparently is no fair scheduling for=
 it,
see=20

https://github.com/openzfs/zfs/issues/10110

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E4464E6E2
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 06:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiLPFRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 00:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiLPFRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 00:17:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842234B9A6
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 21:17:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F280B81D2C
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 05:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4BD3C433F1
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 05:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671167834;
        bh=/gJX48GyCJdQoF/zTgyZVQW91hWg9fk8P8Jmal+KSiU=;
        h=From:To:Subject:Date:From;
        b=Q98aP7TFjSsMrmK2Gi7XCZ8LjfRVPHlJD7tpYQpY4BK/sWdSP0i1YUfwRowWTBzcK
         yroN0vo3u+6jpcIJNa0O2dDTRdmovizpP3LTvjb+SquMWmscnCdcjTqoDsSDx6UOPn
         InvY9Kpwqf1chmDaNus6IC7Up6wM+PVaq5CTSnUUeexJNIHSQuACIG5hmRLqkDnDMl
         wNFp35MI64cxDfX+4oPQWbTd/UVu7WDkaL/fpdHhCz8JAywcd4qVUaP8AnVZv6jByh
         Nwd6Gs4fLVodoJBYZ9+kmqSjcgRnFP75DGdGiCpkHMGM/PFSSto0beKUzvexmQa81Z
         6hgciNh6vGGcQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B8AFDC43144; Fri, 16 Dec 2022 05:17:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216812] New: kvm-unit-test xapic failed on linux 6.1 release
 kernel
Date:   Fri, 16 Dec 2022 05:17:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixiao.yang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216812-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216812

            Bug ID: 216812
           Summary: kvm-unit-test xapic failed on linux 6.1 release kernel
           Product: Virtualization
           Version: unspecified
    Kernel Version: 6.1
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: lixiao.yang@intel.com
        Regression: No

Created attachment 303415
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303415&action=3Dedit
xapic failure log

Environment:
CPU Architecture: x86_64
Host OS: Red Hat Enterprise Linux 9 (Ootpa)
Host kernel: Linux 6.1 release
gcc: gcc (GCC) 11.2.1 20220127 (Red Hat 11.2.1-9)
Host kernel source:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
Branch: master
Commit: 830b3c68

Qemu source: https://git.qemu.org/git/qemu.git
Branch: master
Commit: 5204b499

kvm-unit-tests source: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
Branch: master
Commit: 7cefda524604fe1138333315ce06224d4d864dab

Bug Detailed Description:
kvm-unit-test xapic fails on the linux 6.1 release kernel.=20

FAIL: Want 2 IPI(s) using physical mode, dest =3D 5d, got 1 IPI(s)
qemu-system-x86_64: terminating on signal 15 from pid 208676 (timeout)
FAIL xapic (timeout; duration=3D60)


Reproducing Steps:

git clone https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
cd kvm-unit-tests
./configure
make standalone
cd tests
./xapic

Actual Result:
...
starting broadcast (xapic)
PASS: APIC physical broadcast address
PASS: APIC physical broadcast shorthand
PASS: IPI to single target using logical flat mode
PASS: IPI to single target using logical cluster mode
FAIL: Want 2 IPI(s) using logical flat mode, dest =3D 3, got 1 IPI(s)
FAIL: IPI to multiple targets using logical flat mode
FAIL: Want 2 IPI(s) using logical cluster mode, dest =3D 3, got 1 IPI(s)
FAIL: IPI to multiple targets using logical cluster mode
...
FAIL: Want 2 IPI(s) using physical mode, dest =3D 5b, got 1 IPI(s)
FAIL: Want 2 IPI(s) using physical mode, dest =3D 5c, got 1 IPI(s)
FAIL: Want 2 IPI(s) using physical mode, dest =3D 5d, got 1 IPI(s)
qemu-system-x86_64: terminating on signal 15 from pid 208676 (timeout)
FAIL xapic (timeout; duration=3D60)


Expected Result:
...
PASS xapic

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

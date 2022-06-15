Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0482954C1CC
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 08:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352890AbiFOG0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 02:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245662AbiFOG0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 02:26:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64132899E
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 23:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F56B617E5
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 06:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9CE6FC341C0
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 06:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655274364;
        bh=Y29VKrayNZOT+2oaTVaoWiEzWD+AOIX7ifYk91dc+8E=;
        h=From:To:Subject:Date:From;
        b=aLIoFu8nj4xjX86WgqwOJbHrM2485OayYgslp0wXf5indKfZq/2E/20XsWQR7t3QL
         8S7qYW1GFwqfFg6vCxjHaovZTij3R0x0UVVli5UIHuX3mnY8yerrx4CUixmzsqZ6j3
         nJyp+Sdho3bBsUE5A2nABw4CSbKhArckIJcukLhk1rMpDeGzahIDb2GO0a2bHyvBj1
         2biVE6sW5ZuMFZL2kjiRKIPocLL5DviraYMIEyKG1VDzGhH3wcib8LEvpUh7QV6J2l
         xyWutDgtSTZjdEYBIme6VLpPcdE5a84M0PoRHLn9V7nsb7d5kDzMieLa4+7AfpZcEr
         rffcHmOyorurA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 87484CC13B1; Wed, 15 Jun 2022 06:26:04 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216137] New: Kernel Will Not Compile using GCC 12.1
Date:   Wed, 15 Jun 2022 06:26:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216137-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216137

            Bug ID: 216137
           Summary: Kernel Will Not Compile using GCC 12.1
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.18.0 through 5.18.4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: nanook@eskimo.com
        Regression: No

I've filed a bug on previous versions but it appears to have disappeared fr=
om
the system, at least I can not find it with the search tool.

Using gcc 12.1, 5.18.0 through 5.18.4 fails to compile all with this same e=
rror
in the kvm section:

 dpkg-source --before-build .
 debian/rules binary
In function =E2=80=98reg_read=E2=80=99,
    inlined from =E2=80=98reg_rmw=E2=80=99 at arch/x86/kvm/emulate.c:266:2:
arch/x86/kvm/emulate.c:254:27: error: array subscript 32 is above array bou=
nds
of =E2=80=98long unsigned int[17]=E2=80=99 [-Werror=3Darray-bounds]
  254 |         return ctxt->_regs[nr];
      |                ~~~~~~~~~~~^~~~
In file included from arch/x86/kvm/emulate.c:23:
arch/x86/kvm/kvm_emulate.h: In function =E2=80=98reg_rmw=E2=80=99:
arch/x86/kvm/kvm_emulate.h:366:23: note: while referencing =E2=80=98_regs=
=E2=80=99
  366 |         unsigned long _regs[NR_VCPU_REGS];
      |                       ^~~~~
cc1: all warnings being treated as errors
make[5]: *** [scripts/Makefile.build:288: arch/x86/kvm/emulate.o] Error 1
make[4]: *** [scripts/Makefile.build:550: arch/x86/kvm] Error 2
make[3]: *** [Makefile:1834: arch/x86] Error 2
make[2]: *** [debian/rules:7: build-arch] Error 2
dpkg-buildpackage: error: debian/rules binary subprocess returned exit stat=
us 2
make[1]: *** [scripts/Makefile.package:83: bindeb-pkg] Error 2
make: *** [Makefile:1542: bindeb-pkg] Error 2

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

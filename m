Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C73539B2E
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 04:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349129AbiFACUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 22:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240621AbiFACUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 22:20:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0AB6AA46
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 19:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBB4660B10
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 02:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 338F8C34114
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 02:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654050052;
        bh=KgWqwKTpRttfVDkHucGWOFq4PvG3LJpk7EhV/mr5L2k=;
        h=From:To:Subject:Date:From;
        b=N6/UwWScgQBkSSUk5DpvVwVptfBay8Pjx/TxXNzE+q2eFGNIWm7m4mD6MyzkU/5te
         L9csZRs9JHPNhy1l0Mpn+cgp2WWYF6+kMZchfUZZKkZaqclKRPvbJMygGtCFnXrr7S
         C5BZHfkzH5Ms6mMz1F0R0HinQ9dhF1ZcQPd4JAlmDrhwjuzNGooVrNKQjRXZW/b+1g
         VxT5gmqhwArEBUNKNqsuGVwNotGuBhWvsc8USY3+JEg8HZAbM8IQxjB4fUMlgAtaWC
         H/zBBUKiT2hCcmAWHdsjv9lQBY3kSHINndX1Og0LNqWN7VmfGSsjrYgBQuM43b3J7G
         p47VDBjj5qqFA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1932CC05FD5; Wed,  1 Jun 2022 02:20:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216056] New: Kernel Fails to compile with GCC 12.1 different
 errors than 18.0
Date:   Wed, 01 Jun 2022 02:20:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216056-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216056

            Bug ID: 216056
           Summary: Kernel Fails to compile with GCC 12.1 different errors
                    than 18.0
           Product: Virtualization
           Version: unspecified
    Kernel Version: 18.1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: nanook@eskimo.com
        Regression: No

Created attachment 301084
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301084&action=3Dedit
.config renamed as "config" because stupid browser wouldn't show dot files.

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
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [debian/rules:7: build-arch] Error 2
dpkg-buildpackage: error: debian/rules binary subprocess returned exit stat=
us 2
make[1]: *** [scripts/Makefile.package:83: bindeb-pkg] Error 2
make: *** [Makefile:1542: bindeb-pkg] Error 2

This is the error channel from make bindeb-pkg
Similar error happens with makerpm-pkg

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

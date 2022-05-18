Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B82A52B29E
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 08:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiERGpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 02:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbiERGpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 02:45:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C93C6427
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 23:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1808FB81E8F
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 06:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C40AEC385AA
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 06:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856345;
        bh=uVXgxzwqOSMRmbEojFBMRw4dTLnDkUV9VJ/5VYUC+Eo=;
        h=From:To:Subject:Date:From;
        b=LInWwd2lC3T7fvlI5JA/snHUi4PRVEli8w34eI52Rq4CCEQUN3qhnK1XPA1DwhMdK
         V/6mNSMPclUu61GrfVGYFzgWr6abzyvQgAAr9KiuyIC1GaC7hKrQrxXGiLFX5TUtI7
         /B4dJYfZiOLJ6UnqZ9uwL3YGxPbEc44wP3ybpZgJlW5VyQwiuWrpTq/0Hz6fIeXpTZ
         qxUMb5mFQjmYQbkQJdEQ1Fqj4zso7W6SgaSZfEAPVJf86j3D2UJTkJfLqKDEvZM+vR
         IMssTE969ySu9OtRyFdTj89uTrIA8CkuZC824IrdMFvzJY3Bo4j4cBxDTP1NgXGgug
         6CQ+LSKXWks1w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AD428C05FD0; Wed, 18 May 2022 06:45:45 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: =?UTF-8?B?W0J1ZyAyMTU5OTVdIE5ldzogZXJyb3I6IGFycmF5IHN1YnNjcmlw?=
 =?UTF-8?B?dCAzMiBpcyBhYm92ZSBhcnJheSBib3VuZHMgb2Yg4oCYbG9uZyB1bnNpZ25l?=
 =?UTF-8?B?ZCBpbnRbMTdd4oCZ?=
Date:   Wed, 18 May 2022 06:45:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: ionut_n2001@yahoo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-215995-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215995

            Bug ID: 215995
           Summary: error: array subscript 32 is above array bounds of
                    =E2=80=98long unsigned int[17]=E2=80=99
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.18.0-rc7
          Hardware: AMD
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ionut_n2001@yahoo.com
        Regression: No

Hi Kernel Team,

Today i notice one error on compiling kernel in kvm area.

Error:
  CC [M]  arch/x86/kvm/svm/svm_onhyperv.o
  CHK     kernel/kheaders_data.tar.xz
In function =E2=80=98reg_read=E2=80=99,
    inlined from =E2=80=98reg_rmw=E2=80=99 at arch/x86/kvm/emulate.c:266:2,
    inlined from =E2=80=98decode_register=E2=80=99 at arch/x86/kvm/emulate.=
c:985:7:
arch/x86/kvm/emulate.c:254:27: error: array subscript 32 is above array bou=
nds
of =E2=80=98long unsigned int[17]=E2=80=99 [-Werror=3Darray-bounds]
  254 |         return ctxt->_regs[nr];
      |                ~~~~~~~~~~~^~~~
In file included from arch/x86/kvm/emulate.c:23:
arch/x86/kvm/kvm_emulate.h: In function =E2=80=98decode_register=E2=80=99:
arch/x86/kvm/kvm_emulate.h:366:23: note: while referencing =E2=80=98_regs=
=E2=80=99
  366 |         unsigned long _regs[NR_VCPU_REGS];
      |                       ^~~~~
cc1: all warnings being treated as errors
make[4]: *** [scripts/Makefile.build:288: arch/x86/kvm/emulate.o] Error 1
make[4]: *** Waiting for unfinished jobs....
  CHK     include/generated/compile.h
make[3]: *** [scripts/Makefile.build:550: arch/x86/kvm] Error 2
make[2]: *** [Makefile:1882: arch/x86] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [scripts/Makefile.package:66: binrpm-pkg] Error 2
make: *** [Makefile:1588: binrpm-pkg] Error 2


cat /etc/os-release=20
NAME=3D"openSUSE Tumbleweed"
# VERSION=3D"20220516"
ID=3D"opensuse-tumbleweed"
ID_LIKE=3D"opensuse suse"
VERSION_ID=3D"20220516"
PRETTY_NAME=3D"openSUSE Tumbleweed"
ANSI_COLOR=3D"0;32"
CPE_NAME=3D"cpe:/o:opensuse:tumbleweed:20220516"
BUG_REPORT_URL=3D"https://bugs.opensuse.org"
HOME_URL=3D"https://www.opensuse.org/"
DOCUMENTATION_URL=3D"https://en.opensuse.org/Portal:Tumbleweed"
LOGO=3D"distributor-logo-Tumbleweed"

gcc --version
gcc (SUSE Linux) 12.1.0
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

ldd --version
ldd (GNU libc) 2.35
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper.

CONFIG_KVM_WERROR=3Dy

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

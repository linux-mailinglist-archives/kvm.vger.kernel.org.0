Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0A47CF031
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 08:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjJSGiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 02:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbjJSGiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 02:38:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3427510F
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 23:38:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D27DEC433C7
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 06:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697697488;
        bh=/s+lAViYlWUGD/q0g+yim62CdDApJ2r/a0DHnG06VEU=;
        h=From:To:Subject:Date:From;
        b=Rxrwa+ZWV9F0NC5SqUpo4luv0Y1LlRUjukh9ok/fCbmUDezVECgC0QoJV09vvBK07
         iguiw+4bntQ75gbax2/nlI2A21d/g9Q+xat3ShFg5V9RrzFWfEjzxEBrWOMb35en5f
         sQxM7kDZ8zxzUhj/yqbgLr+5YMl0esDikZ2MeWRFcNV+hDUAH9fJmNQxwdhin7OALr
         k9sGKuyJoEKPo5GrqqFo90UtF8QBLdzV5EYDoFlpthw5gS2kaYRBuvHC5jPWQ4/2jb
         Y9yFHb7JZvMpP8Zd7WV3SHMqT5ArOQ6KeJ18AAAQIsXH6bAHDnDTl0gIx7ylM8BcWe
         JLXPznwh9BvhQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B8BE6C53BD2; Thu, 19 Oct 2023 06:38:08 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 218025] New: Assertion Failure happens in kvm selftest
 vmx_preemption_timer_test
Date:   Thu, 19 Oct 2023 06:38:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ruifeng.gao@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-218025-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D218025

            Bug ID: 218025
           Summary: Assertion Failure happens in kvm selftest
                    vmx_preemption_timer_test
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ruifeng.gao@intel.com
        Regression: No

Created attachment 305265
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305265&action=3Dedit
KERNEL_CONFIG

Environment:
CPU Architecture: x86_64, Sapphire Rapids, Intel(R) Xeon(R) Platinum 8487C
Host OS: CentOS Stream 9
Host kernel: Linux Kernel v6.6-rc6
Host kernel source:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
Branch: master
Commit: 58720809f52779dc0f08e53e54b014209d13eebb
Tag: v6.6-rc6

Bug Detailed Description:
Assertion failure happened after executing kvm selftest
vmx_preemption_timer_test.

Reproducing Steps:
git clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
git checkout v6.6-rc6
cd linux/tools/testing/selftests/kvm && make
cd x86_64 && ./vmx_preemption_timer_test

Actual Result:
[root@spr-2s2 x86_64]# ./vmx_preemption_timer_test
Stage 2: L1 PT expiry TSC (3202723296) , L1 TSC deadline (3202657792)
Stage 2: L2 PT expiry TSC (3202694752) , L2 TSC deadline (3202678752)
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
  x86_64/vmx_preemption_timer_test.c:221: uc.args[4] < uc.args[5]
  pid=3D23920 tid=3D23920 errno=3D4 - Interrupted system call
     1  0x0000000000402874: main at vmx_preemption_timer_test.c:221
     2  0x00007f06c2e3feaf: ?? ??:0
     3  0x00007f06c2e3ff5f: ?? ??:0
     4  0x00000000004028e4: _start at ??:?
  Stage 2: L2 PT expiry TSC (3202694752) > L2 TSC deadline (3202678752)


Expected result:
[root@spr-2s2 x86_64]# ./vmx_preemption_timer_test
[root@spr-2s2 x86_64]#

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

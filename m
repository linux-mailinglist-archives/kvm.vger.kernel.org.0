Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D52A544397
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 08:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbiFIGLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 02:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiFIGLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 02:11:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0353A187
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 23:11:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D32461D7D
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 06:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7A51C3411F
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 06:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654755068;
        bh=w9Hl1jx3RQ6ROZKSBbyqcZxIVCvDSS3IXT00jwwL2/8=;
        h=From:To:Subject:Date:From;
        b=YqA/9/uudbQwQWqc/je+hq9Vw5IsDwTfqVBI032TtL81RzpqNejV8eaKa1fD/S0D+
         hZvTKpca9pr5BhaaonIGREep/Mlbv+8Wnid+UrXHDWApVZk/x0FqsnEs0BVhl5FOr8
         tSG6fmmMNKmHpQtUT351lGavS52c6GwDiUdrTirfFMee3acGYckbeDFFFaYpA3x5Xi
         AxaduuOFGkRTwBy3i3SWJJYqeKU7oM2l3OWX8DD2X9atXc3wZZ7wE0cSjioMzJN2+7
         BTnHw7+pMMj4fuRdsFtiKdoOrtcvrvUwSZoEMHp5e4i9hjcDlma7Xrvugk9BNM7i2N
         fjGKV7ojWHfRg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8F890CC13B1; Thu,  9 Jun 2022 06:11:08 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216098] New: Assertion Failure in kvm selftest mmu_role_test
Date:   Thu, 09 Jun 2022 06:11:08 +0000
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
X-Bugzilla-Changed-Fields: bug_file_loc bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216098-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216098

               URL: https://git.kernel.org/pub/scm/linux/kernel/git/torval
                    ds/linux.git
            Bug ID: 216098
           Summary: Assertion Failure in kvm selftest mmu_role_test
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.18
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

Created attachment 301133
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301133&action=3Dedit
The kernel config file I used to build kernel

Environment:
CPU Architecture: x86_64
Host OS: Red Hat Enterprise Linux 8.4 (Ootpa)
Host kernel: Linux 5.18 release=20
gcc: gcc (GCC) 8.3.1=20
Host kernel source:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
Branch: master
Commit: 4b0986a3613c92f4ec1bdc7f60ec66fea135991f
Tag: v5.18

Bug Detailed Description:
Assertion failure happened after executing kvm selftest mmu_role_test with
argument -g or -m.


Reproducing Steps:
git clone https://git.kernel.org/pub/scm/virt/kvm/kvm.git
cd kvm/tools/testing/selftests/kvm && make
cd x86_64 && ./mmu_role_test -g
./mmu_role_test -m

Actual Result:
[root@icx-2s2 ~]# /usr/local/bin/mmu_role_test -g
Test MMIO after toggling CPUID.GBPAGES
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
  lib/x86_64/processor.c:898: rc =3D=3D 0
  pid=3D189748 tid=3D189748 errno=3D22 - Invalid argument
     1  0x000000000040b66a: vcpu_set_cpuid at processor.c:897
     2  0x00000000004026df: mmu_role_test at mmu_role_test.c:60
     3  0x00000000004024a2: main at mmu_role_test.c:137
     4  0x00007f73b16237b2: ?? ??:0
     5  0x00000000004024ed: _start at ??:?
  KVM_SET_CPUID2 failed, rc: -1 errno: 22

[root@icx-2s2 ~]# /usr/local/bin/mmu_role_test -m
Test MMIO after changing CPUID.MAXPHYADDR
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
  lib/x86_64/processor.c:898: rc =3D=3D 0
  pid=3D189759 tid=3D189759 errno=3D22 - Invalid argument
     1  0x000000000040b66a: vcpu_set_cpuid at processor.c:897
     2  0x00000000004026df: mmu_role_test at mmu_role_test.c:60
     3  0x0000000000402479: main at mmu_role_test.c:143
     4  0x00007f318f8237b2: ?? ??:0
     5  0x00000000004024ed: _start at ??:?
  KVM_SET_CPUID2 failed, rc: -1 errno: 22

Expected result:
[root@icx-2s2 ~]# /usr/local/bin/mmu_role_test -g
[root@icx-2s2 ~]# /usr/local/bin/mmu_role_test -m
[root@icx-2s2 ~]#

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

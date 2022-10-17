Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4DF6007E3
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 09:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiJQHm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 03:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJQHmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 03:42:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE51118B02
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 00:42:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A8D960F1B
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 07:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CEC09C433C1
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 07:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665992539;
        bh=SekP5q8Ms1SLJpCWY4LCPwjG4Vb5I/JeTxqh3D/SDIc=;
        h=From:To:Subject:Date:From;
        b=aRtPH46qXsjTJrkj2KrVa5xqshr1pWmQZ4H+kTsm38todhGVz7SsdcXFuyunI4ZPQ
         MQfdDZT20ksRijTImznvUvkuP3TAA+YdPWoY01zYxGZs/Ho3zJLFgs0s8ZigoyrEec
         UEjyqzhZvfFDSdB2lL9upBk+GERkvjFq0YMhQiUWQqb6F6InNn4ME8j/VQ51gpLX4p
         ovRl6D3BLYswkvpJgx81RtGVRfuCfoR71h8N5Dml2JexVJh8g7hlK0d74zmmdviBPz
         CE4B7ZN4tj2lBO30/diLzDHs3IKQrwZaEN4PKP9Caqbd9GcXZR1QiL4vwkupJ4mrQk
         aoIW5k9uLYAxQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BACA4C433E9; Mon, 17 Oct 2022 07:42:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216598] New: Assertion Failure in kvm selftest
 mmio_warning_test
Date:   Mon, 17 Oct 2022 07:42:19 +0000
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
Message-ID: <bug-216598-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216598

            Bug ID: 216598
           Summary: Assertion Failure in kvm selftest mmio_warning_test
           Product: Virtualization
           Version: unspecified
    Kernel Version: 6.0.0-rc7
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

Created attachment 303018
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303018&action=3Dedit
Host dmesg log

Environment:
CPU Architecture: x86_64
Host OS: Red Hat Enterprise Linux 8.4 (Ootpa)
Host kernel: 6.0.0-rc7
gcc: gcc (GCC) 8.4.1=20
Host kernel source:  https://git.kernel.org/pub/scm/virt/kvm/kvm.git
Branch: next
Commit: e18d6152ff0f41b7f01f9817372022df04e0d354


Bug Detailed Description:
Assertion failure and host call trace happened after executing kvm selftest
mmio_warning_test.


Reproducing Steps:
git clone https://git.kernel.org/pub/scm/virt/kvm/kvm.git
cd kvm && make headers_install
cd kvm/tools/testing/selftests/kvm && make
cd x86_64 && ./mmio_warning_test

Actual Result:
[root@icx-2s2 ~]# kvm/tools/testing/selftests/kvm/x86_64/mmio_warning_test
ret1=3D0 exit_reason=3D17 suberror=3D1
ret1=3D0 exit_reason=3D8 suberror=3D65530
ret1=3D0 exit_reason=3D17 suberror=3D1
ret1=3D0 exit_reason=3D8 suberror=3D65530
ret1=3D0 exit_reason=3D17 suberror=3D1
ret1=3D0 exit_reason=3D8 suberror=3D65530
ret1=3D0 exit_reason=3D17 suberror=3D1
ret1=3D0 exit_reason=3D8 suberror=3D65530
ret1=3D0 exit_reason=3D17 suberror=3D1
ret1=3D0 exit_reason=3D8 suberror=3D65530
ret1=3D0 exit_reason=3D17 suberror=3D1
ret1=3D0 exit_reason=3D8 suberror=3D65530
ret1=3D0 exit_reason=3D17 suberror=3D1
ret1=3D0 exit_reason=3D8 suberror=3D65530
ret1=3D0 exit_reason=3D17 suberror=3D1
ret1=3D0 exit_reason=3D8 suberror=3D65530
ret1=3D0 exit_reason=3D17 suberror=3D1
ret1=3D0 exit_reason=3D8 suberror=3D65530
ret1=3D0 exit_reason=3D17 suberror=3D1
ret1=3D0 exit_reason=3D8 suberror=3D65530
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
  x86_64/mmio_warning_test.c:118: warnings_before =3D=3D warnings_after
  pid=3D4383 tid=3D4383 errno=3D0 - Success
     1  0x0000000000402463: main at mmio_warning_test.c:117
     2  0x00007f5bc5c23492: ?? ??:0
     3  0x00000000004024dd: _start at ??:?
  Warnings found in kernel.  Run 'dmesg' to inspect them.

[root@icx-2s2 ~]#dmesg |grep -i "call trace"
[  208.938961] Call Trace:
[  209.289307] Call Trace:
[  209.683239] Call Trace:
[  210.016660] Call Trace:
[  210.389796] Call Trace:
[  210.727731] Call Trace:
[  211.090710] Call Trace:
[  211.422556] Call Trace:
[  211.785661] Call Trace:
[  212.117551] Call Trace:

Expected Result:
[root@icx-2s2 ~]#kvm/tools/testing/selftests/kvm/x86_64/mmio_warning_test
[root@icx-2s2 ~]
[root@icx-2s2 ~]#dmesg |grep -i "call trace"
[root@icx-2s2 ~]

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82409633486
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 05:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiKVEt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 23:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKVEt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 23:49:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D1927B13
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 20:49:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B185B61549
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 04:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14855C433D6
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 04:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669092564;
        bh=ckOt+J9fY4RuXEo80BumgcHd+xf41WHaXTcOE9WchM8=;
        h=From:To:Subject:Date:From;
        b=W8qZtSNN7Gwf4q/Haptpyti2Rbr9yFTWY1jnLDB0ulMqpjgYMeIWs+xw2ne/bvWVX
         j5gpeb78XKn0hzyiD7w0cj3IvfKU4gLcl7NDqfRZc5fsTmV9TyKk4Ahrl0nzT13y2i
         sCr0M/62VxKKCpbHPy3jpAWIVf9SqK+4W6sDTk/cxk4SpXtQoL4ZomJkMHDK5vresT
         MKHrYLe8BLcohjIMKqw5vS6AKMNwf4Ku43jmmA3gHXC3QLRxR8if+roj8lj34iMRkQ
         27Doq+oV0kVUMdGfg7mpokNoux4kdDfm2VggD+rvJEoaPDV8CJAY9iG0YLXE8PQr+2
         hcbeA0rrQM0Og==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E7C31C433E9; Tue, 22 Nov 2022 04:49:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216725] New: VMXON with CR0 bit 5 cleared should #GP, got '6'
Date:   Tue, 22 Nov 2022 04:49:23 +0000
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
Message-ID: <bug-216725-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216725

            Bug ID: 216725
           Summary: VMXON with CR0 bit 5 cleared should #GP, got '6'
           Product: Virtualization
           Version: unspecified
    Kernel Version: 6.1.0-rc4
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

Created attachment 303260
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303260&action=3Dedit
vmx failure log

Environment:
CPU Architecture: x86_64
Host OS: Red Hat Enterprise Linux 8.4 (Ootpa)
Host kernel: 6.1.0-rc4
gcc: gcc version 8.4.1
Host kernel source: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
Branch: next
Commit: d72cf8ff

Qemu source: https://git.qemu.org/git/qemu.git
Branch: master
Commit: 6d71357a

kvm-unit-tests source: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
Branch: master
Commit: 952cf19c9143e307fe229af8bf909016a02fcc6c

Bug Detailed Description:
kvm-unit-tests vmx fails on the latest kvm.=20
SUMMARY: 430115 tests, 1 unexpected failures, 2 expected failures, 5 skippe=
d.=20
The one unexpected failure is:
FAIL: VMXON with CR0 bit 5 cleared should #GP, got '6'

Reproducing Steps:
rmmod kvm_intel
modprobe kvm_intel nested=3DY
git clone https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
cd kvm-unit-tests
./configure
make standalone
cd tests
./vmx -cpu host

Actual Result:
...
SUMMARY: 430115 tests, 1 unexpected failures, 2 expected failures, 5 skipped
FAIL vmx (430115 tests, 1 unexpected failures, 2 expected failures, 5 skipp=
ed)

Expected Result:
...
SUMMARY: 430115 tests, 2 expected failures, 4 skipped)
PASS vmx (430115 tests, 2 expected failures, 4 skipped)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

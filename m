Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F5155B52B
	for <lists+kvm@lfdr.de>; Mon, 27 Jun 2022 04:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiF0CRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jun 2022 22:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiF0CRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jun 2022 22:17:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D829F2AC8
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 19:17:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67E1561143
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 02:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFF79C341C7
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 02:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656296237;
        bh=9RASu4FRqwdWlt2BqR7x/pAzh1ITo8AKujrBhAjdviU=;
        h=From:To:Subject:Date:From;
        b=pdHpQNV09vu8rEy1b/lFh4UfOb/0RuxGMl8syLKv+RwEfXRItY7ozg0GWxyeeyaE7
         JmiW/M9QvB+u+odC3bDimyF//7tG7FCnCkVUXr1Fr46s5W9y+5oOlovIXZ2/3JJrX+
         pF3ywWstSNzmKspjy459CDHsuZDKY06x4PklxjpVtBAo/njiabdlXBkuvjOSKTJA1u
         5zeAvHq2qfzfuIZ5RzbNmtHS8LBEPHywJ9I0S5n7sq6hTWZB16O7Bw61t0Fd0JgfWn
         FJmawPE/vkrt/hZQ+sfeRJXpzas6sh9WcW8c65RMF6SWYplLIsvoHyqurSrMd1osku
         qxhziXPeT6nFA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AA817CC13B1; Mon, 27 Jun 2022 02:17:17 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216177] New: kvm-unit-tests vmx has about 60% of failure chance
Date:   Mon, 27 Jun 2022 02:17:17 +0000
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
Message-ID: <bug-216177-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216177

            Bug ID: 216177
           Summary: kvm-unit-tests vmx has about 60% of failure chance
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.19-rc1
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

Created attachment 301281
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301281&action=3Dedit
vmx failure log

Environment:
CPU Architecture: x86_64
Host OS: Red Hat Enterprise Linux 8.4 (Ootpa)
Host kernel: 5.19.0-rc1
gcc: gcc version 8.4.1
Host kernel source: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
Branch: next
Commit: 4b88b1a518b337de1252b8180519ca4c00015c9e

Qemu source: https://git.qemu.org/git/qemu.git
Branch: master
Commit: 40d522490714b65e0856444277db6c14c5cc3796

kvm-unit-tests source: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
Branch: master
Commit: ca85dda2671e88d34acfbca6de48a9ab32b1810d

Bug Detailed Description:
kvm-unit-tests vmx has about 60% of chance to fail. In my case, failure
happened 6 times out of 10 times of tests.=20

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
SUMMARY: 430101 tests, 1 unexpected failures, 2 expected failures, 4 skipped
FAIL vmx (430101 tests, 1 unexpected failures, 2 expected failures, 4 skipp=
ed)

Expected Result:
...
SUMMARY: 430101 tests, 2 expected failures, 4 skipped
PASS vmx (430101 tests, 2 expected failures, 4 skipped)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

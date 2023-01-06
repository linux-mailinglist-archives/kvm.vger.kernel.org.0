Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F38965F934
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjAFBig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjAFBiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:38:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB931B1F4
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:38:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F9DE61CCB
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 01:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98DEBC433EF
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 01:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672969101;
        bh=5wMVj5dKq6SWVElxOsy3vhVpkKLuCV4mmV1NUzc7u9I=;
        h=From:To:Subject:Date:From;
        b=AIoSHCUJgNZuzHATpGs4LyIGuUGqGXwmem4/5fstr/RKSJzHWhypHKVT1hty3OCdE
         PFWCoqFmmqhXEROfbIvoGE6E4njNrLl1/aJf7yfs5coHmvzy+lv+R6gkI37HSawtvl
         zuUzRR5C6I5Y0FYTPGfZXy+UKy+Z5iyn4kyk8ul5TLhez0vXVfZbfh7b1Mwkj7zSuB
         zn/BoM7c08jNYW1uwuqevlpHwlOBkr8s4LWPcutk/UICrDDCDc6zlGNWLfHn1jZe7T
         xJm+Td7RAnqpwv++6huYuzAQvTMhHo+xmds46dLoDAxcpM7N4wSOsWAp3fJGt/O7ol
         bk60QhVDbdeMA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 83752C43144; Fri,  6 Jan 2023 01:38:21 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216891] New: The interface for creating SR-IOV VF doesn't exist
Date:   Fri, 06 Jan 2023 01:38:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: lixiao.yang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216891-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216891

            Bug ID: 216891
           Summary: The interface for creating SR-IOV VF doesn't exist
           Product: Virtualization
           Version: unspecified
    Kernel Version: 6.2.0-rc1
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: lixiao.yang@intel.com
        Regression: No

Created attachment 303532
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303532&action=3Dedit
kernel config

Environment:
CPU Architecture: x86_64
Host OS: Red Hat Enterprise Linux 8.4 (Ootpa)
NIC: 98:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710
for 10GbE SFP+ (rev 02)
Host kernel: 6.2.0-rc1
gcc: gcc version 8.4.1
Host kernel source: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
Branch: next
Commit: fc471e83

Qemu source: https://git.qemu.org/git/qemu.git
Branch: master
Commit: cb9c6a8e


Bug Detailed Description:
The interface for creating SR-IOV VF doesn't exist, i.e.
/sys/bus/pci/devices/0000:98:00.0/sriov_numvfs doesn't exist.
This issue didn't happen in my last test with host kernel 6.1.0-rc4,kvm com=
mit
549a715b and qemu commit c15dc499.

Reproducing Steps:
Try to create 2 VFs
echo 2 > /sys/bus/pci/devices/0000:98:00.0/sriov_numvfs


Actual Result:
Error log:=20
No such file:/sys/bus/pci/devices/0000:98:00.0/sriov_numvfs

Expected Result:
2 VFs successfully created

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

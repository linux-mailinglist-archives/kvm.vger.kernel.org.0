Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD675244AC
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 07:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348979AbiELFH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 01:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348960AbiELFHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 01:07:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDCE26AED
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 22:07:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70AC361BF2
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 05:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99492C385B8
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 05:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652332034;
        bh=QCQNXcLkRPPsMwtMHrR0fXkJd+ztRMqxE4Xag6oVJrE=;
        h=From:To:Subject:Date:From;
        b=ief4Zjs40sZLzwMVHJomg4E5zjIU/agI1jUz09F2egfKX0XTcgfqjHmJq1KVd2/64
         K4HgBJVrWSsIAB0gfAp/VHcmZ4I+vsCRuojcVTvXiPXQRFZNjwaLy6Ms2SZ+aw4SZ/
         VDNPgpjN+Yxm3b42/BBrYFgpgcKWjR+3uvM/vx2GNs4EmhWwWx+3BGyYEBPpwl5M+g
         7b8tOZh4PoMYEqPiBPe82SO6yFPJu5JOqeO6BXEO2KaK4T572Iza8KKAqsBLwlmC9o
         3+Li9CvXOws6RAXtei/0I7MwT4Qg2hFU7w81vb0bP/LqMGiGsYxAg1JPcjAUBmk+nL
         oZn1ah6GoruEA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 82DD0CAC6E2; Thu, 12 May 2022 05:07:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215969] New: Guest deploying TAA mitigation on (not affected)
 ICX host
Date:   Thu, 12 May 2022 05:07:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pawan.kumar.gupta@linux.intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-215969-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D215969

            Bug ID: 215969
           Summary: Guest deploying TAA mitigation on (not affected) ICX
                    host
           Product: Virtualization
           Version: unspecified
    Kernel Version: v5.18-rc3
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: pawan.kumar.gupta@linux.intel.com
        Regression: No

On a hardware that enumerates TAA_NO (i.e. not affected by TSX Async Abort
(TAA)), a certain guest/host configuration can result in guest enumerating =
TAA
vulnerability and unnecessarily deploying MD_CLEAR(CPU buffer clear)
mitigation.=20

Icelake Server has TAA_NO and supports MSR TSX_CTRL, and by default linux
disables TSX feature, resetting CPUID.RTM at host bootup.

Currently KVM hides TAA_NO from guests when host has CPUID.RTM=3D0. Because=
 KVM
also exports MSR TSX_CTRL to guests, a guest with "tsx=3Don" cmdline parame=
ter
would enable TSX feature, setting X86_FEATURE_RTM.

taa_select_mitigation() with X86_FEATURE_RTM=3D1 and TAA_NO=3D0, deploys Cl=
ear CPU
buffers mitigation.

A probable fix is to export TAA_NO to guests. Alternately, KVM can choose n=
ot
to export MSR TSX_CTRL.

Guests anyways can't use MSR TSX_CTRL to enable TSX, but I think it was
exported to guest to support some migration scenarios:

  https://lore.kernel.org/lkml/20210129101912.1857809-1-pbonzini@redhat.com/

---
Setup info:

ICX HOST configuration:

Vendor ID:                       GenuineIntel
CPU family:                      6
Model:                           106
Model name:                      Intel(R) Xeon(R) Platinum 8360Y CPU @ 2.40=
GHz
Stepping:                        6

Vulnerability Mds:               Not affected
Vulnerability Tsx async abort:   Not affected

//TSX feature flag not present on host
$ grep rtm /proc/cpuinfo
$


GUEST info:

Launch kvm/qemu guest with "-cpu host" and guest kernel parameter "tsx=3Don"

"rtm" shows up in /proc/cpuinfo

# rdmsr -a 0x122
0
0
0
0

// Guest sysfs shows mitigation being deployed.
[root@vm-fedora-35 ~]# grep .
/sys/devices/system/cpu/vulnerabilities/tsx_async_abort
Mitigation: Clear CPU buffers; SMT Host state unknown

Thanks,
Pawan

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

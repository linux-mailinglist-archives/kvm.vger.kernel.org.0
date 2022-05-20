Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE6352E16F
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 02:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344168AbiETAzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 20:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243354AbiETAzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 20:55:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354C5133255
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 17:54:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E071BB82966
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 00:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1D49C3411E
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 00:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653008096;
        bh=cdQeUsfGHoSlDb/yaa0+35fQeVt9IAokOSypxgkCRbQ=;
        h=From:To:Subject:Date:From;
        b=QyBmqOLDKfw9sN3iXHYzMe8ZOAmjB08qZv2Wms5Vx0LHLKgvg7yHLFqlJ666X7emZ
         95oSwQbafkiAa6zcpAWF7+AEVAl64aRV0+NzmWEG+x056wgua3M0uD4ZGx3iPjLeMF
         NM5dI0HYvwMu9ZHbXVgLAD2By1xHGpkUZX7OUv1+oBaGkGuset5cSgak3/kJYZv81L
         mScxyu8hpF3DZQtVLvOMqUcwiDT+a0PyaLp7XYriZkJnUts6s2GrQV8wUA2Ybw5Jaz
         K37kTepVvUtKRSjiiNhcf74Y3AeK7hMB/0BuRilKncYbBArgNQ8b1Ta3NN6pQWlaAU
         KsHL03IT+90Xw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 88A86C05FD5; Fri, 20 May 2022 00:54:56 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216003] New: Single stepping Windows 7 bootloader results in
 Assertion `ret < cpu->num_ases && ret >= 0' failed.
Date:   Fri, 20 May 2022 00:54:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ercli@ucdavis.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216003-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216003

            Bug ID: 216003
           Summary: Single stepping Windows 7 bootloader results in
                    Assertion `ret < cpu->num_ases && ret >=3D 0' failed.
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.17.6-200.fc35.x86_64
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ercli@ucdavis.edu
        Regression: No

CPU model: Intel(R) Core(TM) i7-4510U CPU @ 2.00GHz
Host kernel version: 5.17.6-200.fc35.x86_64
Host kernel arch: x86_64
Guest: Windows 7 or Windows 10 BIOS mode boot loader. 32-bits.
This bug still exists if using -machine kernel_irqchip=3Doff
This bug no longer exists if using -accel tcg

How to reproduce:

1. Install Windows 7 or Windows 10 in QEMU. Use MBR and BIOS (i.e. do not u=
se
GPT and UEFI). For example, I installed Windows on a 32G disk, and it resul=
ts
in around 3 partitions: 50M, 31.5G (this is C:), 450M. Only the MBR header
(around 1 M) and the 50M disk is needed. For example,
https://drive.google.com/uc?id=3D1mLvKsPSuLbeckwcdnavnQMu8QxOwvX29 can be u=
sed to
reproduce this bug. Suppose Windows is installed in w.img.

2. Start QEMU
qemu-system-x86_64 --drive media=3Ddisk,file=3Dw.img,format=3Draw,index=3D1=
 -s -S
-enable-kvm

3. Start GDB
gdb --ex 'target remote :::1234' --ex 'hb *0x7c00' --ex c --ex 'si 10000' -=
-ex
q
This GDB command starts from the MBR header and runs 10000 instructions. Wh=
en I
am reproducing it, running 1000 is enough to reproduce this problem. If this
problem cannot be reproduced, try to increase this number.

4. See error in QEMU:
qemu-system-x86_64: ../hw/core/cpu-sysemu.c:77: cpu_asidx_from_attrs: Asser=
tion
`ret < cpu->num_ases && ret >=3D 0' failed.
Aborted (core dumped)

Expected behavior: there should not be an assertion error. GDB should be ab=
le
to single step a lot of instructions successfully.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

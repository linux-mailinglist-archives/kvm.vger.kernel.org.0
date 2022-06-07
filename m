Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0559553F464
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 05:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbiFGDRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 23:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiFGDRa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 23:17:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B5C252A0
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 20:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EE33B81C9A
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 03:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2CBB0C3411C
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 03:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654571846;
        bh=goOnu8Y0qF+ueCo5ChJqPyc76kFtJRFOBIpGAN1RSIE=;
        h=From:To:Subject:Date:From;
        b=sGLFoVR/j4gWITDNj4uIPPBH5E+5RRgP18jA5Of5h5Ohb4rR8RPhsYqIxtr8Fvqa6
         vz5DWbskhrav654o0hr6dDVSp1LERcaSkMh9QgTrlHnSgDfEmnHSpYUudrBmB5Rv/+
         q5LJ96gw6kL62aYzpLxZh5AqCcFvE/B3Jv7Oy7U+eKRVJwGXM8S6HEyK56mNbLb6/c
         zz2Icj8afcyXYdvhLW1+22xm9d27g9kkHT9zUAqAXi0QXFSQKqKbogFOKdEjDsQB2e
         rwZxVu+pYGcKuE3ramtK8zigywIetuJa4ZURUdT3iYYioAazarue5+zzl+nicVP8ak
         mXdVbqq4VENNQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 14013C05FD4; Tue,  7 Jun 2022 03:17:26 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216091] New: KVM nested virtualization does not support VMX
 fields that should always be supported
Date:   Tue, 07 Jun 2022 03:17:25 +0000
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
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216091-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216091

            Bug ID: 216091
           Summary: KVM nested virtualization does not support VMX fields
                    that should always be supported
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.17.11-200.fc35.x86_64
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

Created attachment 301112
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301112&action=3Dedit
Guest hypervisor to reproduce this bug (xz compressed) (4.img)

CPU model: Intel(R) Core(TM) i7-4510U CPU @ 2.00GHz
Host kernel version: 5.17.11-200.fc35.x86_64
Host kernel arch: x86_64
Guest: a hypervisor I wrote myself, 32-bits. Compressed and attached as
4.img.xz with this bug. Source code is in
https://github.com/lxylxy123456/uberxmhf/tree/f779b4f5de519d2cc5397a2cee72d=
7fa7963348b
QEMU command line: qemu-system-i386 -m 256M -cpu Haswell,vmx=3Dyes -enable-=
kvm
-serial stdio -drive media=3Ddisk,file=3D4.img,index=3D0
The problem does not go away if I use -machine kernel_irqchip=3Doff.
This problem cannot be tested using -accel tcg, because nested virtualizati=
on
is not supported in TCG.

How to reproduce:

1. Download 4.img.xz from this bug, decompress it to get 4.img.
2. Enter the QEMU command line above
3. Serial port is redirected to stdio. On serial port, see:
VMREAD of 0x2000 gives 0x00000000
VMREAD of 0x200c fails (0xc)
VMREAD of 0x4000 gives 0x00000000
VMREAD of 0x4828 fails (0xc)
VMREAD of 0x6000 gives 0x00000000
VMREAD of 0x6008 fails (0xc)
VMREAD of 0x600a fails (0xc)
VMREAD of 0x600c fails (0xc)
VMREAD of 0x600e fails (0xc)
VMREAD of 0x6402 fails (0xc)
VMREAD of 0x6404 fails (0xc)
VMREAD of 0x6406 fails (0xc)
VMREAD of 0x6408 fails (0xc)
4. The relevant source code that prints these messages is at
https://github.com/lxylxy123456/uberxmhf/blob/f779b4f5de519d2cc5397a2cee72d=
7fa7963348b/xmhf/src/xmhf-core/xmhf-runtime/xmhf-startup/lhv-vmx.c#L20
5. This means that KVM does not support the following 10 fields:
Encoding 0x200c: Executive-VMCS pointer
Encoding 0x4828: Guest SMBASE
Encoding 0x6008: CR3-target value 0
Encoding 0x600a: CR3-target value 1
Encoding 0x600c: CR3-target value 2
Encoding 0x600e: CR3-target value 3
Encoding 0x6402: I/O RCX
Encoding 0x6404: I/O RSI
Encoding 0x6406: I/O RDI
Encoding 0x6408: I/O RIP

Expected behavior: the VMCS fields listed above should be supported. The se=
rial
port should print:
VMREAD of 0x2000 gives 0x00000000
VMREAD of 0x200c gives 0x00000000
VMREAD of 0x4000 gives 0x00000000
VMREAD of 0x4828 gives 0x00000000
VMREAD of 0x6000 gives 0x00000000
VMREAD of 0x6008 gives 0x00000000
VMREAD of 0x600a gives 0x00000000
VMREAD of 0x600c gives 0x00000000
VMREAD of 0x600e gives 0x00000000
VMREAD of 0x6402 gives 0x00000000
VMREAD of 0x6404 gives 0x00000000
VMREAD of 0x6406 gives 0x00000000
VMREAD of 0x6408 gives 0x00000000

Explanation:
Intel's SDM lists all VMCS field name, encoding, and existence information =
in
appendix C. For example, if a field is not supported in some CPUs, then SDM
writes:
> Field Name                       Index         Encoding
> VMX-preemption timer value[1]    000010111B    0000482EH
> NOTES:
> 1. This field exists only on processors that support the 1-setting of the
> "activate VMX-preemption timer" VM-execution control.

However, for the 10 fields above, SDM implies that these fields should alwa=
ys
exist. For example:
> Field Name                       Index         Encoding
> CR3-target value 0               000000100B    00006008H
> CR3-target value 1               000000101B    0000600AH
> CR3-target value 2               000000110B    0000600CH
> CR3-target value 3[1]            000000111B    0000600EH
> NOTES:
> 1. If a future implementation supports more than 4 CR3-target values, they
> will be encoded consecutively following the 4 encodings given here.

Thus, according to SDM I believe the 10 fields should always exist. Using
CR3-target value as an example, I think KVM can say that=20
number of CR3-target values supported by the processor is 0 by setting the
IA32_VMX_MISC MSR. However, the 4 VMCS fields CR3-target value 0 - 3 should
still exist.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

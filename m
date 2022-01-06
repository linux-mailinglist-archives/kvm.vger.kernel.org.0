Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43AB486364
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 12:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbiAFLDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 06:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238102AbiAFLDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 06:03:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66935C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 03:03:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 219C4B82059
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 11:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E63D3C36AEF
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 11:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641467030;
        bh=1HKiVT90sh7uDaNBOha5xePrrvtJ86D/sJ90kFimiNA=;
        h=From:To:Subject:Date:From;
        b=Oe1XGQ+hhlWF7VvK8wsD4kiUJc73kUg9VDwnMsaPNkpWyGSdpEYdyFZolY7m+EEaB
         iDNIFzYiYzsSsNCYLmZjfKgM35Hd/qwFg8AJFtc7Pd2jScK13utmT4dVx+ZZZcPgvd
         Vo26K9ZUSiFNeMYDij8o8KeDyiwaRfOmImwnwaufBRUFtisPsrRCSwJM5n9dY8wXwM
         XE53zvtWL1la+zoa4Th2zFI1O1SopyTUatV+aJjyHKZ4PoNEUB8x82OhDB0K3kPfpL
         AXOV0Lh/pmPkdfo+nWIHBioeG+0OmnVxJSXICkgJpUh6W2YAXJa1VEeKM1qzJJCktB
         jjuwoaPP8G6OQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CA215C05FDF; Thu,  6 Jan 2022 11:03:50 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215459] New: VM freezes starting with kernel 5.15
Date:   Thu, 06 Jan 2022 11:03:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: th3voic3@mailbox.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-215459-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215459

            Bug ID: 215459
           Summary: VM freezes starting with kernel 5.15
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.15.*
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: th3voic3@mailbox.org
        Regression: No

Created attachment 300234
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300234&action=3Dedit
qemu.hook and libvirt xml

Hi,

starting with kernel 5.15 I'm experiencing freezes in my VFIO Windows 10 VM.
Downgrading to 5.14.16 fixes the issue.

I can't find any error messages in dmesg when this happens and comparing the
dmesg output between 5.14.16 and 5.15.7 didn't show any differences.


Additional info:
* 5.15.x
* I'm attaching my libvirt config and my /etc/libvirt/hooks/qemu
* My specs are:
** i7-10700k
** ASUS z490-A PRIME Motherboard
** 64 GB RAM
** Passthrough Card: NVIDIA 2070 Super
** Host is using the integrated Graphics chip

Steps to reproduce:
Boot any 5.15 kernel and start the VM and after some time (no specific trig=
ger
as far as I can see) the VM freezes.

After some testing the solution seems to be:

I read about this:
20210713142023.106183-9-mlevitsk@redhat.com/#24319635">
https://patchwork.kernel.org/project/kvm/patch/20210713142023.106183-9-mlev=
itsk@redhat.com/#24319635

And so I checked
cat /sys/module/kvm_intel/parameters/enable_apicv

which returns Y to me by default.

So I added
options kvm_intel enable_apicv=3D0
to /etc/modprobe.d/kvm.conf


cat /sys/module/kvm_intel/parameters/enable_apicv
now returns N

So far I haven't encountered any freezes.

The confusing part is that APICv shouldn't be available with my CPU

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

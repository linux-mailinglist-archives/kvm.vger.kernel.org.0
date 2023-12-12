Return-Path: <kvm+bounces-4148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1FCC80E469
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 07:48:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C53961C21A7A
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 06:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58D115AF5;
	Tue, 12 Dec 2023 06:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNCuAnVS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89419621
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 06:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9952C433C9
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 06:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702363685;
	bh=h0vOHqwhSOXrgmCgPnbEa6ntLWLsbzJkXgiGys/kNK4=;
	h=From:To:Subject:Date:From;
	b=XNCuAnVSiHSlsLxuVmw1Zn393qTCHXgS/Mpf5cTClJsXbovAYF1P92laRxVYO4w5H
	 SLUBrwXwUF/ApPXOmPpTFDbd7rw3Pyb/RAUefUjxLuxVHhnhR4IAsv7eKe/sh9rxNt
	 L+SksTNWtX+MH4eV0Mfpk6+GNfciCzlHNCKDnXkxBySWVK6QU7WSBw2x9jONOlRprF
	 d5M/NKpeltoG4Dl4+5IUqU2n3OV2BYxibkgPdANBt/QB/vKfIUYNBoFg0EGDIGSRUy
	 yjh5/ZNVqqs2XnanjeJvXGzemEqwrXzdxdd4Rd5lCo6uwpYU4E1MsFrwyaOEIWwAar
	 SBpupfVdeKpdA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D11B8C53BD1; Tue, 12 Dec 2023 06:48:05 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218257] New: [Nested VM] Failed to boot L2 Windows guest on L1
 Windows guest
Date: Tue, 12 Dec 2023 06:48:05 +0000
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
 cf_regression cf_bisect_commit attachments.created
Message-ID: <bug-218257-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218257

            Bug ID: 218257
           Summary: [Nested VM] Failed to boot L2 Windows guest on L1
                    Windows guest
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
        Regression: Yes
           Bisected a1c288f87de7aff94e87724127eabb6cdb38b120
         commit-id:

Created attachment 305591
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305591&action=3Dedit
Captured failed screen on L2 guest

Environment:
------------
CPU Architecture: x86_64
Host OS: CentOS Stream 9
Guest OS L1: Windows 10 Pro (10.0.18362 N/A Build 18362), x64-based PC
Guest OS L2: Windows 10 Enterprises (10.0.10240 N/A Build 10240), x64-based=
 PC
kvm.git next branch commit id: e9e60c82fe391d04db55a91c733df4a017c28b2f
qemu-kvm commit id:=20
Host Kernel Version: 6.7.0-rc1
Hardware: Sapphire Rapids

Bug detailed description:
--------------------------
To verify two nested Windows guests scenarios, we used Windows image to cre=
ate
L1 guest, then failed to boot L2 Windows guest on L1 guest. The error scree=
n is
captured in attachment.=20

Note: this is suspected to be a KVM Kernel bug by bisect the different comm=
its:
kvm next                                 + qemu-kvm   =3D result
a1c288f87de7aff94e87724127eabb6cdb38b120 + d451e32c   =3D bad
e1a6d5cf10dd93fc27d8c85cd7b3e41f08a816e6 + d451e32c   =3D good

Reproduce steps:
----------------
1.create L1 guests:
qemu-system-x86_64 -accel kvm -cpu host -smp 8 -drive
file=3DL1_VMWARE_L2_WIN10.img,if=3Dnone,id=3Dvirtio-disk0 -device
virtio-blk-pci,drive=3Dvirtio-disk0,bootindex=3D0 -m 8192 -monitor pty -dae=
monize
-vnc :7 -device virtio-net-pci,netdev=3Dnic0,mac=3D00:05:66:34:98:e6 -netdev
tap,id=3Dnic0,br=3Dvirbr0,helper=3D/usr/local/libexec/qemu-bridge-helper,vh=
ost=3Don
2. create L2 guests:
Using VMware Workstation to boot Win10 guest.

Current result:
----------------
L2 guest (Windows 10 guest) failed to boot up.

Expected result:
----------------
L2 guest (Windows 10 guest) boot up successfully.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


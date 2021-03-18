Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AC3340A67
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 17:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhCRQl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 12:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232070AbhCRQlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 12:41:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EB98D64F40
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 16:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616085713;
        bh=lVgleVM9mbcn49R9MehwcdTSaAOvy4AUJkgx/3Xs9wI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YYDn7huM8wxilZ4Cbx7kXlWumoAs88ysRfbZ5mT8rSEYCVjsvxlopcG+gNV+zguOA
         tpHrK5OXP5YiBtNd9BLRJiPYbqmSRYwE5ZaYs3wKcQL3dBdl6BXIp5awNhJygZa4+3
         ioYy9GCYxpsjurAAbKFrL+mcOGB2CPsfGroYGpuiDd+9htjOcBWQngb9teK+tK9MVS
         sqtWe886/b/NrRGtasahbxo7eeupPQLPPu5dzdOV7ShDhbouFXkYYCNtAr5Eje+p21
         2rZdP0GgDE4r7S4yFnkAkTxS+oVJ900Tgat7Kv93ypsNFpYmPp+GPl0r8NrrXDdLa2
         br1epGi4nqFXA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id E6F82653C9; Thu, 18 Mar 2021 16:41:52 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Thu, 18 Mar 2021 16:41:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kitchm@tutanota.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-9RAxhZekyv@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201753-28872@https.bugzilla.kernel.org/>
References: <bug-201753-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D201753

--- Comment #28 from kitchm@tutanota.com ---
Thanks, Paul.  Of course you are correct.  A sloppy mistake on my part.

Linux version 4.19.0-14-amd64 (debian-kernel@lists.debian.org) (gcc version
8.3.0 (Debian 8.3.0-6)) #1 SMP Debian 4.19.171-2 (2021-01-30)

[    0.000000] DMI: Micro-Star International Co., Ltd MS-7B86/B450-A PRO
(MS-7B86), BIOS A.D0 06/11/2020
[    0.132574] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    5.445162] input: HD-Audio Generic HDMI/DP,pcm=3D3 as
/devices/pci0000:00/0000:00:08.1/0000:27:00.1/sound/card0/input16
[    5.445197] input: HD-Audio Generic HDMI/DP,pcm=3D7 as
/devices/pci0000:00/0000:00:08.1/0000:27:00.1/sound/card0/input17

I tried to report it to MSI, but they have a terrible communication system.=
=20
Aw, well....

Thanks again.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

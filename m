Return-Path: <kvm+bounces-18149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CCADB8CEF28
	for <lists+kvm@lfdr.de>; Sat, 25 May 2024 15:49:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6765D1F21503
	for <lists+kvm@lfdr.de>; Sat, 25 May 2024 13:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E6164D5AB;
	Sat, 25 May 2024 13:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hNB1/jm3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746652F3B
	for <kvm@vger.kernel.org>; Sat, 25 May 2024 13:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716644942; cv=none; b=tKmCvJPxG2/Zt1vZJnHCf2DjbCdjNSOSjOgRMXsM3kGy7fcphNy4CoSSfyIkN2akjz2L70D0FwWc8I9dQeJHoUbJtyibcLCYQfijUORj2i4ULWVwEW1L5kimDyJadoG6nUN4zffRzDtnpqU5nCn5K4sExOUFHHqzplPOi6qpSvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716644942; c=relaxed/simple;
	bh=OWt59v8XIcNSN0J3p3DlYcbwOnSqIbnudoP/egKG0tI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BLNa1VNkcz0Kp3Pw+jMin0dCDQztuSlH+hd2eVPGXtZ/kaz7yfVM3pR0+TiwU6wE7eUq5xftO1zu5rpSe/Yc1DJ2l4tLDIsOOYPDgRTvmToEGqJs3ueORUCk2aBYY6kJcpkniDviHN+KC18IzhcafjwicIOLa3tx0WBCR3vAYrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hNB1/jm3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id F25FCC32789
	for <kvm@vger.kernel.org>; Sat, 25 May 2024 13:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716644942;
	bh=OWt59v8XIcNSN0J3p3DlYcbwOnSqIbnudoP/egKG0tI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hNB1/jm3Mt4NEAkOM3S5VtLs2tZDnqLDnCprrBd3KHo/arg1y3T7x8jgg8ZA0y2Rq
	 zJEiLihRQYeb4PhUL85mb9InU9dONzkIighdjflg56xgyFDM8h4N0iBVZV/KOe+F3K
	 QDWDhPvAu/3ux7osHd0U71Ekg5BVIRIOxTeXGj3e7UZ2/O1tZDYj9JrgtJ9dVSf9SK
	 PWGMs6IMZl9hJ3cdhj9QhP70+wPp6MFU4HrLIKn3+15usOClxjQ7dAvwbye7vR5nQ7
	 oaycT28NOWhmirN2f3wi6fGihyb95arX8e37Ya0xwY+RbtLtPC7F0PuQYzG9ddreC0
	 jB2Qw7hfvC7bA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E4220C53BB8; Sat, 25 May 2024 13:49:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] PCIE device crash when trying to pass through USB PCIe
 Card to virtual machine
Date: Sat, 25 May 2024 13:49:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: linux@iam.tj
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218876-28872-uejyK0cryi@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218876-28872@https.bugzilla.kernel.org/>
References: <bug-218876-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218876

--- Comment #6 from TJ (linux@iam.tj) ---
Thanks for the logs. An overview of how devices are connected. The PCIE Root
port at address 00:09.0 (Bus:Device:Function) is the 'parent' of the USB ho=
st
controller on Bus 02:00.0.

The issue here appears to be that when the USB host controller is removed it
may actually go into D3Cold state. This actually removes power and, current=
ly,
Linux kernel has no mechanism to control power on PCI bus [0].

There are three possible work-arounds I can think of worth testing:

  1. remove 00:09.0 and then rescan its parent root complex since that *may*
trigger power to be restored to the port (use the script I shared with you =
on
IRC via termbin)

  2. unbind [1] the xhci_hcd driver from the device *before* trying to start
the VM or loading vfio-pci (this could be scripted) so the device remains
powered:

  # echo 0000:02:0.0 > /sys/bus/pci/drivers/xhci_hcd/unbind

  3. avoid this altogether if the USB host controller is only ever wanted f=
or
use in the guest virtual machine by reserving the device so the host's XHCI
controller driver never claims it via kernel command-line; something like:
vfio-pci.ids=3D1912:0014 - but this would require ensuring that vfio-pci was
loaded *very* early in the initrd processing to take control of the USB host
controller before xhci_hcd gets to it! I don't think there is an easy way to
ensure ordering the module load order for that aside from a custom udev rule
that loads vfio-pci for this device ID.



[0]
https://www.kernel.org/doc/html/latest/power/pci.html#native-pci-power-mana=
gement

[1] https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-bus-pci

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


Return-Path: <kvm+bounces-41641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA56A6B32C
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 04:16:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DE03487570
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 03:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078A91DF977;
	Fri, 21 Mar 2025 03:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/fBTnDl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFAAD2FB
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 03:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742526969; cv=none; b=dmEb1pV0feeedBxXjFLboOE6JR1MipF1dIbQ7dw1i4bfcjs+dqCWV609+K6fKvBc9EnvT5hAG4aachqXiaMYe99h8fB6ookPhzu9PYFJIzXMiow4SF6H1fIGj6LJaCXepx4821YmiUMezYpDgHy8noqkZcmpMuhG4l6IWQiZd90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742526969; c=relaxed/simple;
	bh=Q49LJb/J1c2v5ot56dr8cAJsvKMMdxqt9qIlpsQN7kE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Tut6Yx5l/c/36imomKq3CPcyESgaBjevgC2TBJum1W0THh7KPK9b3G9mDsfTHeeuHlRst/4QT279I7QKo+tZb+/j5QoS6sR10UIZo2gfTv6HlDBwrP20BeO6Y1qdP2aK4F5AS9bP6aZMcChCX+CnSy4pX3VRTe9uH4E98Xnn3GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/fBTnDl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02A01C4CEEA
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 03:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742526969;
	bh=Q49LJb/J1c2v5ot56dr8cAJsvKMMdxqt9qIlpsQN7kE=;
	h=From:To:Subject:Date:From;
	b=M/fBTnDlB1wqun5JFLqeI8rDC4ipzZ87sKrssXzEMWyWNIZcRb3x8duFjboObr0bH
	 py+N+TTaqHVJVAW2Y7uQxFSNl+a1j25k+y6lrX9FpsZBRPu1ESX4do4ZoOiZlK0qOr
	 /qsERHKu1+LRfHTC3vgR9cOtfmySLdfiUFMUQOmUA8qxfMEDKVmursIRib1P+/i+Vb
	 dduYClE9t/Atr7rd8Cvt5GyQgyUU4oRFoLk+ROdac4vmFIUGLm/A7TLgk6qAgBPpwh
	 JAZFqTgc4z/Ybr4wCvf6aSh9+qPRktf2mWqAqQNYNASBHIR3VLvDtCsExGXe4et7x9
	 5FksDJU88OgYQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EBCD0C53BBF; Fri, 21 Mar 2025 03:16:08 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219903] New: [6.14.0_rc7] TX timeout and ping failed after
 change the tx queue length
Date: Fri, 21 Mar 2025 03:16:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: leiyang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219903-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219903

            Bug ID: 219903
           Summary: [6.14.0_rc7] TX timeout and ping failed after change
                    the tx queue length
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: low
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: leiyang@redhat.com
        Regression: No

How reproducible:
100%

Steps to reproduce
1.Boot guest with virtio-net device and enable queue_reset:

-device
virtio-net-pci,id=3Dnet0,netdev=3Dhostnet0,queue_reset=3Don,bus=3Dpcie.0,ad=
dr=3D0x5 \
-netdev
tap,id=3Dhostnet0,script=3D/etc/qemu-ifup,downscript=3D/etc/qemu-ifdown,vho=
st=3Don \


2.Ping external host after change the tx size, ping failed

[root@guest ~]# ethtool -G eth0 tx 8
[root@guest ~]# ping 10.72.136.90 -c 10
PING 10.72.136.90 (10.72.136.90) 56(84) bytes of data.
From 10.72.139.48 icmp_seq=3D1 Destination Host Unreachable
From 10.72.139.48 icmp_seq=3D2 Destination Host Unreachable
From 10.72.139.48 icmp_seq=3D3 Destination Host Unreachable
From 10.72.139.48 icmp_seq=3D4 Destination Host Unreachable
From 10.72.139.48 icmp_seq=3D5 Destination Host Unreachable
From 10.72.139.48 icmp_seq=3D6 Destination Host Unreachable
From 10.72.139.48 icmp_seq=3D7 Destination Host Unreachable

=E2=80=94 10.72.136.90 ping statistics =E2=80=94
10 packets transmitted, 0 received, +7 errors, 100% packet loss, time 9227ms
pipe 4

3.Guest dmesg will repeatedly print messages like the following:

[ 488.149842] virtio_net virtio1 eth0: NETDEV WATCHDOG: CPU: 25: transmit q=
ueue
0 timed out 5004 ms
[ 488.149855] virtio_net virtio1 eth0: TX timeout on queue: 0, sq: output.0,
vq: 0x1, name: output.0, 5004000 usecs ago


I don't think this is a regression issues, since this is first time to test
this scenario.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


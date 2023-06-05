Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE44721C74
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 05:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbjFEDRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 23:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjFEDRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 23:17:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D01AB
        for <kvm@vger.kernel.org>; Sun,  4 Jun 2023 20:17:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A14061176
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 03:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B9BFC433D2
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 03:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685935053;
        bh=ADFvx8k27TvK+Agkju8kwA+Mpf3V+VRp+LJn5sTZ554=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JV5rydwl4osCHmFXfYzvih38LgBdyDycxIgXE+ztxKe2WUuhp0rWXuJCy5ibORiTb
         ymxiE6fpaxdXwW91YWRO/yoeCLVqoDkye5okU9KHXsV4wm462IW74DOxKTyHe+fK0b
         UVsDEcu/Xsc6sPxU3wkR/cpcxtvvpiRsrrPdsGhwb9iJ2dUHedbJmow1j5rfWnJG2d
         9q6XruXqKzScJz2Hcz11S3Vdsnza5EEIyCdDfbcbrVSp2BeQRDUVneuaWmgWm+14ce
         t7y9iCaSmWKAcidhmeh9aD9lpyY4o+YB37hacC7POTWkM3sQhnilvjNyks2OwDaG13
         yZqyW8fNetMPg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 54C1FC43144; Mon,  5 Jun 2023 03:17:33 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217516] FAIL: TSC reference precision test when do hyperv_clock
 test of kvm unit test
Date:   Mon, 05 Jun 2023 03:17:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zjuysxie@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217516-28872-fnn14gtqch@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217516-28872@https.bugzilla.kernel.org/>
References: <bug-217516-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217516

--- Comment #3 from Ethan Xie (zjuysxie@hotmail.com) ---
(In reply to Bagas Sanjaya from comment #2)
> (In reply to Ethan Xie from comment #0)
> > # cat /etc/redhat-release
> > CentOS Linux release 8.5.2111
> >=20
> > # uname -r
> > 4.18.0-348.7.1.el8_5.x86_64
> >=20
>=20
> CentOS 8 has been EOLed in 2021. Can you test with Rocky Linux 9 instead
> (and preferably latest mainline kernel)?

I change the OS to Rocky Linux 9 with mainline linux kernel, it also can
reproduce this problem:

# timeout -k 1s --foreground 90s /usr/libexec/qemu-kvm --no-reboot -nodefau=
lts
-device pc-testdev -device isa-debug-exit,iobase=3D0xf4,iosize=3D0x4 -vnc n=
one
-serial stdio -device pci-testdev -machine accel=3Dkvm -kernel
x86/hyperv_clock.flat -cpu host,hv_time # -initrd /tmp/tmp.kFgWZZHuFw
qemu-kvm: warning: Machine type 'pc-i440fx-rhel7.6.0' is deprecated: machine
types for previous major releases are deprecated
enabling apic
smp: waiting for 0 APs
paging enabled
cr0 =3D 80010011
cr3 =3D 1007000
cr4 =3D 20
PASS: MSR value after enabling
scale: 10624dd2e147ae1 offset: -18011
refcnt 257287, TSC 41a33e4, TSC reference 257293
refcnt 20257287 (delta 20000000), TSC 12e2025fc, TSC reference 20257293 (de=
lta
20000000)
suspecting drift on CPU 0? delta =3D 103, acceptable [0, 52)
FAIL: TSC reference precision test
iterations/sec:  47953642
PASS: MSR value after disabling

# uname -r
6.4.0-rc5

# cat /etc/os-release
NAME=3D"Rocky Linux"
VERSION=3D"9.0 (Blue Onyx)"
ID=3D"rocky"
ID_LIKE=3D"rhel centos fedora"
VERSION_ID=3D"9.0"
PLATFORM_ID=3D"platform:el9"
PRETTY_NAME=3D"Rocky Linux 9.0 (Blue Onyx)"
ANSI_COLOR=3D"0;32"
LOGO=3D"fedora-logo-icon"
CPE_NAME=3D"cpe:/o:rocky:rocky:9::baseos"
HOME_URL=3D"https://rockylinux.org/"
BUG_REPORT_URL=3D"https://bugs.rockylinux.org/"
ROCKY_SUPPORT_PRODUCT=3D"Rocky-Linux-9"
ROCKY_SUPPORT_PRODUCT_VERSION=3D"9.0"
REDHAT_SUPPORT_PRODUCT=3D"Rocky Linux"
REDHAT_SUPPORT_PRODUCT_VERSION=3D"9.0"

# cat /etc/redhat-release
Rocky Linux release 9.0 (Blue Onyx)

# rpm -qa | grep qemu-kvm
qemu-kvm-docs-7.2.0-14.el9_2.x86_64
qemu-kvm-common-7.2.0-14.el9_2.x86_64
qemu-kvm-device-display-virtio-gpu-7.2.0-14.el9_2.x86_64
qemu-kvm-device-display-virtio-gpu-pci-7.2.0-14.el9_2.x86_64
qemu-kvm-device-usb-host-7.2.0-14.el9_2.x86_64
qemu-kvm-device-display-virtio-vga-7.2.0-14.el9_2.x86_64
qemu-kvm-block-rbd-7.2.0-14.el9_2.x86_64
qemu-kvm-tools-7.2.0-14.el9_2.x86_64
qemu-kvm-device-usb-redirect-7.2.0-14.el9_2.x86_64
qemu-kvm-audio-pa-7.2.0-14.el9_2.x86_64
qemu-kvm-core-7.2.0-14.el9_2.x86_64
qemu-kvm-ui-opengl-7.2.0-14.el9_2.x86_64
qemu-kvm-ui-egl-headless-7.2.0-14.el9_2.x86_64
qemu-kvm-7.2.0-14.el9_2.x86_64


linux from git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
master branch with commit:
commit 9561de3a55bed6bdd44a12820ba81ec416e705a7 (HEAD -> master, tag: v6.4-=
rc5,
origin/master, origin/HEAD)
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jun 4 14:04:27 2023 -0400

    Linux 6.4-rc5

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

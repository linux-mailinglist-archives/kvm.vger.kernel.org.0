Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A741486397
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 12:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbiAFLSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 06:18:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59408 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiAFLSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 06:18:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B39ECB82059
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 11:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69A14C36AED
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 11:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641467909;
        bh=TDdfz9KexiKP5nEqyXKhIuSwSP13R6TdN3pWD0qnMAg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bPx+H6mTebzhBil7x/dupSQeHU1VZbJqDiSMqo5Djom+9IzMo5TKj5vRgEb3TiVCE
         7VtyKVq4iZWBcyRkkafyjW+GrdCJ9Jv+PA9A41NyvHzl8qVVqaENowsRuXq5FURtup
         hUJ3uQQVE36lamXXzdLAiI4eOa9mAinUX5fRMx2ZuLUBwjkTkKcBC1nsg8PfveaFEP
         ZKKCipdIjjoTrjS3+ElTUK95qYZK1goaJwzth+Dm2VYyQ6J1x9Kwzj/bBSA9jLjB79
         nl4wQVePk3KALZZLwr7d8tTo7tfU+BCgKeJmgCG2XpNTMxhZwuZzTyEms3alTpzn0j
         jkBxEHrhpJJLA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4DA18CAC6E4; Thu,  6 Jan 2022 11:18:29 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215459] VM freezes starting with kernel 5.15
Date:   Thu, 06 Jan 2022 11:18:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215459-28872-stH4AXhLL2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215459-28872@https.bugzilla.kernel.org/>
References: <bug-215459-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215459

--- Comment #1 from mlevitsk@redhat.com ---
On Thu, 2022-01-06 at 11:03 +0000, bugzilla-daemon@bugzilla.kernel.org wrot=
e:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215459
>=20
>             Bug ID: 215459
>            Summary: VM freezes starting with kernel 5.15
>            Product: Virtualization
>            Version: unspecified
>     Kernel Version: 5.15.*
>           Hardware: Intel
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: th3voic3@mailbox.org
>         Regression: No
>=20
> Created attachment 300234
>   --> https://bugzilla.kernel.org/attachment.cgi?id=3D300234&action=3Dedit
> qemu.hook and libvirt xml
>=20
> Hi,
>=20
> starting with kernel 5.15 I'm experiencing freezes in my VFIO Windows 10 =
VM.
> Downgrading to 5.14.16 fixes the issue.
>=20
> I can't find any error messages in dmesg when this happens and comparing =
the
> dmesg output between 5.14.16 and 5.15.7 didn't show any differences.
>=20
>=20
> Additional info:
> * 5.15.x
> * I'm attaching my libvirt config and my /etc/libvirt/hooks/qemu
> * My specs are:
> ** i7-10700k
> ** ASUS z490-A PRIME Motherboard
> ** 64 GB RAM
> ** Passthrough Card: NVIDIA 2070 Super
> ** Host is using the integrated Graphics chip
>=20
> Steps to reproduce:
> Boot any 5.15 kernel and start the VM and after some time (no specific
> trigger
> as far as I can see) the VM freezes.
>=20
> After some testing the solution seems to be:
>=20
> I read about this:
> 20210713142023.106183-9-mlevitsk@redhat.com/#24319635">
>
> https://patchwork.kernel.org/project/kvm/patch/20210713142023.106183-9-ml=
evitsk@redhat.com/#24319635
>=20
> And so I checked
> cat /sys/module/kvm_intel/parameters/enable_apicv
>=20
> which returns Y to me by default.
>=20
> So I added
> options kvm_intel enable_apicv=3D0
> to /etc/modprobe.d/kvm.conf
>=20
>=20
> cat /sys/module/kvm_intel/parameters/enable_apicv
> now returns N
>=20
> So far I haven't encountered any freezes.
>=20
> The confusing part is that APICv shouldn't be available with my CPU

I guess you are lucky and your cpu has it?=20
Does /sys/module/kvm_intel/parameters/enable_apicv show Y on 5.14.16 as wel=
l?

I know that there were few fixes in regard to posted interrupts on intel,
which might explain the problem.

You might want to try 5.16 kernel when it released.

Best regards,
        Maxim Levitsky

>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

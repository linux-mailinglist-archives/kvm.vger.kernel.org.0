Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F27530E36
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 12:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbiEWJJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbiEWJJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463D046642
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 02:09:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 748B060FB7
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8BBAC34116
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653296987;
        bh=f2tc6Kak4lNO+PeNk7y6z0TCPxMfUVb788xshWm3kMQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=C0Eme0PMx787N0dRsVw1DI14kPZJp7nK+UWe4nLvT86CdfvcHp4GHn4NWHXgS2ei6
         E5Xn+iRiTasthizpe1OooGudwkwG3aPGCaBpAXuVwcK+BCa3bJUWI4C8t4UKbObyX8
         Nl9eQNZs8HERC1Jd6Wv3o8CvjCF2Q8AHAc4f2Cr+wNSiVq4Gw3unPlc3GflkjTKeez
         8nxAokkiMmoHLHt+EcK0yC8sAiNWmKB1Xvb+AwWNhRehMqRoe0vNvOrRD8p4jjQrIh
         JDBuQEG4QAApMoXDFuW+QrqpKnXg29Ya8V2iBjjokgM+AiZf7LG+kJm+am8e7Ae6jp
         ht54LfCK84Plg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C3A30CC13B5; Mon, 23 May 2022 09:09:47 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216017] KVM: problem virtualization from kernel 5.17.9
Date:   Mon, 23 May 2022 09:09:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: opw
X-Bugzilla-Severity: high
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216017-28872-tFJMTfYsus@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216017-28872@https.bugzilla.kernel.org/>
References: <bug-216017-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216017

--- Comment #2 from mlevitsk@redhat.com ---
On Mon, 2022-05-23 at 08:48 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216017
>=20
>             Bug ID: 216017
>            Summary: KVM: problem virtualization from kernel 5.17.9
>            Product: Virtualization
>            Version: unspecified
>     Kernel Version: 5.17.9-arch1-1
>           Hardware: AMD
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Keywords: opw
>           Severity: high
>           Priority: P1
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: ne-vlezay80@yandex.ru
>         Regression: No
>=20
> Qemu periodically chaches width:
>=20
> [root@router ne-vlezay80]# qemu-system-x86_64 -enable-kvm
> qemu-system-x86_64: error: failed to set MSR 0xc0000104 to 0x100000000
> qemu-system-x86_64: ../qemu-7.0.0/target/i386/kvm/kvm.c:2996:
> kvm_buf_set_msrs:
> Assertion `ret =3D=3D cpu->kvm_msr_buf->nmsrs' failed.
> Aborted (core dumped)

This is my fault. You can either revert the commit you found in qemu,
or update the kernel to 5.18.

>=20
> Also if running virtual pachine width type -cpu host, system is freezez f=
rom
> kernel panic.=20

Can you check if this happens with 5.18 as well? If so, try to capture the
panic message.


Best regards,
        Maxim Levitsky

>=20
> Kernel version: 5.17.9
> Distribution: Arch Linux
> QEMU: 7.0
> CPU: AMD Phenom X4
> Arch: x86_64
>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B12F554A65
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 15:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349856AbiFVNAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 09:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiFVNAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 09:00:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B082F66E
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 06:00:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D250A619D7
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 13:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3ED76C341C7
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 13:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655902836;
        bh=6NAJTxLBzf59yzYW6DRyP1iqLNBHQqYFWKxboN3uIpI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Z3m8Fu9jjeLoF98nu3aoFPjXfoQ+GWUy5plIfIKNyBNPmInekQf398oqBpTj0xiT5
         D6ylQTF+qagrJDTqAGaL+mQOF+2B3hodZ857RJZ1InsBuVQNxbg0YyKkmbnBgUYT0W
         vB0G7l929IVuduFxPpoYDxPSSDSY0DnQT65iVcMKKgQ+FUO6zJJZd/cmxJvXCjWKO2
         Apo1qwVdRbxTbl9Rb3RcHlMgSp1U4xyTrKnWzruLFCDRStyZEbPcmNLPtq4pZzvjZ+
         k/N+BkxgIFgnKXhKNn0bzhEwm+TK5yGvxkJ9txsob0odPqZKrSJB4h8FcnbbaJwyw7
         G7dq7lAQMTD+A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2DE4BCC13B5; Wed, 22 Jun 2022 13:00:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 213781] KVM: x86/svm: The guest (#vcpu>1) can't boot up with
 QEMU "-overcommit cpu-pm=on"
Date:   Wed, 22 Jun 2022 13:00:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-213781-28872-8MfhE2vI7a@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213781-28872@https.bugzilla.kernel.org/>
References: <bug-213781-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213781

--- Comment #5 from mlevitsk@redhat.com ---
On Wed, 2022-06-22 at 12:49 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D213781
>=20
> Like Xu (like.xu.linux@gmail.com) changed:
>=20
>            What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>      Kernel Version|5.14.0-rc1+                 |5.19.0-rc1+
>=20
> --- Comment #4 from Like Xu (like.xu.linux@gmail.com) ---
> The issue still exits on the AMD after we revert the commit in 31c2558569=
5a.
>=20
> Just confirmed that it's caused by non-atomic accesses to memslot:
> - __do_insn_fetch_bytes() from the prot32 code page #NPF;
> - kvm_vm_ioctl_set_memory_region() from user space;
>=20
> Considering the expected result [selftests::test_zero_memory_regions on
> x86_64]
> is that the guest will trigger an internal KVM error due to the initial c=
ode
> fetch encountering a non-existent memslot and resulting in an emulation
> failure.
>=20
> More similar cases will gradually emerge. I'm not sure if KVM has
> documentation
> pointing out this restriction on memslot updates (fix one application QEMU
> may
> be one-sided), or any need to add something unwise like check
> gfn_to_memslot(kvm, gpa_to_gfn(cr2_or_gpa)) in the x86_emulate_instructio=
n().
>=20
> Any other suggestions ?
>=20

Yep, agree. This has to be fixed on qemu and kvm level (kvm needs new API to
upload
atomaically a set of memslot changes (easy part), and the qemu needs code to
batch the memslot updates when it does SMM related memslot updates.

Best regards,
        Maxim Levitsky

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

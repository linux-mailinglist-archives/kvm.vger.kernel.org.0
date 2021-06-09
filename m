Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA0D3A0F76
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 11:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhFIJRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 05:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhFIJQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 05:16:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 412E7610E6
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 09:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623230105;
        bh=Ap3nCwgJEg8YK6V5nXxzEi4ebCHoe4dYVyikyDZoxe8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Wy5jcxrPP151w4EnRESfEt/h8FASHuLTtsp/FLaCG/WYVbDkljWWU2Yvx5PwS87M4
         cnvUScTUhDO3N5mWXNQ61oFNrlK3vskCC85ATRYSc/I9EwP7Mq+ZdGUvoDhNj0n2RR
         zdXdtpSUyCCRYHHQdV6QvioVBApGozenAjzgzkA561j1i5BFqg0dEY8ByxMquSQXMJ
         kpf2lD/aq5Ryj1DzhyAsBD+zhW9+6I0zwew3AgrrL+p3Tk4ob9F8Q65GpxJ+OOlQch
         1/sMcN03x/K9DZ4U6B6zeAmXAPJKnjsxUNjx1osbi4fd8L6ilJZBzHHCCpL5E3lr9I
         zw7bjyvfrpNMw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 338E76113C; Wed,  9 Jun 2021 09:15:05 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 53851] nVMX: Support live migration of whole L1 guest
Date:   Wed, 09 Jun 2021 09:15:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-53851-28872-Vdw8UMGk97@https.bugzilla.kernel.org/>
In-Reply-To: <bug-53851-28872@https.bugzilla.kernel.org/>
References: <bug-53851-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D53851

--- Comment #3 from mlevitsk@redhat.com ---
On Wed, 2021-06-09 at 08:55 +0000, bugzilla-daemon@bugzilla.kernel.org wrot=
e:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D53851
>=20
> --- Comment #2 from christian.rohmann@frittentheke.de ---
> Sorry for replying to this rather old bug - I was pointed to this via
> https://www.linux-kvm.org/page/Nested_Guests#Limitations=20
>=20
>=20
> If I may ask, is this really the last state of discussion and work on this
> issue?
> Looking at i.e.=20
>=20
> *
> https://github.com/qemu/qemu/commit/ebbfef2f34cfc749c045a4569dedb4f748ec0=
24a
> *
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D039aeb9deb9291f3b19c375a8bc6fa7f768996cc
>=20
>=20
> there have been commits for the kernel as well as QEMU to support migrati=
on
> of
> nested VMs.
>=20

AFAIK, running nested guests and migration while nested guest is running sh=
ould
work on both Intel and AMD, but there were lots of fixes in this area recen=
tly
so a very new kernel should be used.

Plus in some cases if the nested guest is 32 bit, the migration still can f=
ail,
on Intel at least, last time I checked. On AMD I just recently fixed
such issue for 32 bit guest and it seems to work for me.

I also know that if the nested guest is hyper-v enabled (which is a bit
overkill as
this brings us to a double nesting), then it crashes once in a whileafter l=
ots
of migration
cycles.

So there are still bugs, but overall it works.

Best regards,
        Maxim Levitsky

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

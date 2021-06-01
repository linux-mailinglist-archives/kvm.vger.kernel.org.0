Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9419397354
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 14:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhFAMft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 08:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232965AbhFAMft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 08:35:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E1C8613BD
        for <kvm@vger.kernel.org>; Tue,  1 Jun 2021 12:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622550848;
        bh=cLE7p9Vm6x65aZz/IjUOi7sJJASNZ7OkZFx7IZAZA0c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=eCduRLOeJ6QM/EwVxErYf7NumTR96XwntKjbUSzB1HHV9gnB231bIU2d8b0i7NotG
         HaFmerwP9fu2fIOPhETk2KagtxYo2xqcP+xKZ5LUixKguOLy4PHr1O3Obd8OldjZGv
         S1oBMRR9NsGA9Tml1XGpI+3x/8NQ//RaK+w8V1L7Y12nCXCNK5K1P5FwVCTxYrCca7
         EweAxrutQ1jlK62FUqYrI8NJ/BIrhy7kw5s/pE6uGAI2678kDekTZ3h9vBj3bpc88n
         D2SLln5+PjBzdxTWfMPiFk9JdBvIiK2ZtQSWI6gdcnC98e0wAp6dqDTDqYgKXBxvwk
         C8tKc8sIPm1/Q==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 469FB61167; Tue,  1 Jun 2021 12:34:08 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 213257] KVM-PR: FPU is broken when single-stepping
Date:   Tue, 01 Jun 2021 12:34:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lkcl@lkcl.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-213257-28872-U5TLIcEUPx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213257-28872@https.bugzilla.kernel.org/>
References: <bug-213257-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213257

--- Comment #4 from Luke Kenneth Casson Leighton (lkcl@lkcl.net) ---
(In reply to Lauri Kasanen from comment #3)
> That's probably not worth trying, since the computation results were
> also wrong.

ok. and the initial setup starts from a blank FPU, no host modification of =
FPRs
needed

> The computation does not rely on register setting, it
> loads, computes and saves entirely in code.

i realised i just said this exact thing, above, in a different way.

and is it the case that the minippc kvm host program is not attempting to r=
ead
(or write) the FPR regfile after each guest singlestep?

not that i would expect reading of the FPR regfile from the host to affect =
the
guest, but it's worth confirming.

trying to think, how else can this be debugged, to find out what's going on?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

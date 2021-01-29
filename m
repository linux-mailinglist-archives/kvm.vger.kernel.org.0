Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB26308F98
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 22:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbhA2Vrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 16:47:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232727AbhA2Vro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 16:47:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9761E64E0E
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 21:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611956823;
        bh=fEBtJOACN6t1KE7X04aQeOgaKG6+uS3vHPvtuiQciAM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EfCxcYBRbnWMn3VkIF6te2n8fN4FCKxQnmKjPMu6hbzuOml+fVCrbzHwOx+cysoRu
         C1lhAEWQtOzU8uk0VUvVikQU04fxZ8o+xSPU5h1eFXuf6sP9ABGxzLt7psPcYlDq9B
         I3JP3gySSL3Drx7ck09gZW0+zDZjkIku8xyjcoPn2MNsWmBNccF5V08NAiL8gM1+nE
         JqxMy162yYkw/B4bVlvtkKEUCSlrnLxgHstZoz2q+qokvRYw88lFtvb6uhNnA7slpL
         D8embbhvnI+1xz2irysKkHpAgTcGkmfHDkf+yPyUbkzDSY3lXPDG79KMmFu9knfAUL
         EbbHipdlp3btw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 8C5D7613D9; Fri, 29 Jan 2021 21:47:03 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 211467] Regression affecting 32->64 bit SYSENTER on AMD
Date:   Fri, 29 Jan 2021 21:47:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jonny@magicstring.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-211467-28872-QLgqjl5ugU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211467-28872@https.bugzilla.kernel.org/>
References: <bug-211467-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211467

--- Comment #1 from jonny5532 (jonny@magicstring.co.uk) ---
Created attachment 294993
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D294993&action=3Dedit
Simple patch which appears to fix it

This patch stops my VM crashing without removing the truncation.

It is based on the assumption that a SYSENTER which changes the CS flags to
long mode (if applicable) should also change the ctxt->mode to PROT64. I do=
n't
know if that is correct (or safe) though.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

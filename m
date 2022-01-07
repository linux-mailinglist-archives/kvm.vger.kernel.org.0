Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74DE487539
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 11:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346655AbiAGKIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 05:08:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56918 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237202AbiAGKIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 05:08:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16E7561F1C
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 10:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 682B6C36AEF
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 10:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641550127;
        bh=SA33/CUOjDJut13eRZb4YOzUNnLOc8yUEdksjmpwLZc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=M6IR3DSGtfo62vHxk4j//miKxs99HmXrLmDDizPCXwJNVwAaYuxm7ONaBVceOojuT
         bHslD3Ecv0vwUmSUfY+Neizo8ifhkMNY1VEhKkmn6kzDsCZvzKvNr57KG2WaYcl0UC
         8OKnZ3pIfxxi4HzqKsnV/mV9AUJ2tKK1FIiIYngBGyvFzVzmwc6VEV6u17Ujg8hpH4
         W9NR63NLAfuwdPDz3xXP6G3ETl02q2axv7VM3MQbepBrA9APEIUhVQ0UfIV5AlqkyU
         R15GrZZi2i1E2ubG8f7u9LQg2QsC7BIxfo+VXgIPd+ek0/B7CS4Afv91vBTuz0CNCB
         kmc8IfPGm43IQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4D479C05FD9; Fri,  7 Jan 2022 10:08:47 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215459] VM freezes starting with kernel 5.15
Date:   Fri, 07 Jan 2022 10:08:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: th3voic3@mailbox.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215459-28872-Rem7Ev4RiP@https.bugzilla.kernel.org/>
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

--- Comment #8 from th3voic3@mailbox.org ---
Tested again today and now when I disable tdp_mmu the VM takes a very long =
time
to start and it seems the startup never really finishes.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

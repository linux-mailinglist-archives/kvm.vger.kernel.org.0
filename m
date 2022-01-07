Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCE648744F
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 09:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346120AbiAGIwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 03:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236255AbiAGIwj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 03:52:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12401C061245
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 00:52:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A1D9B82530
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 08:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2EEF4C36AED
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 08:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641545555;
        bh=xdoR74idB+ywRG74Jr8laqkNppgidsQ2mADY9ho8mXg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Sn+PzIvlFd8XxRXrcPkTn3DuEBz0LB1dDuoTWos+FpZgrJ6BAZSwODpXABEXUgjJ+
         hyIkzHm40AIPSfPYK4/c+GqGniZR/IX2v29vLUd5qb4VsD+fMrYXK44cKAWbM/lNPl
         foOS3ksOnI1P2L1r9JXRXsEtF1b2UDRmYU6K6zYAspxGfXXvkiPITHftUbApPAlGx4
         4wHOLfM8gOSFSdkQk2lSeEKSwXpUS64QlF0Qj8pKwBZtA9aHWcFXFHMBqJdf89FCjp
         gM66vtjEkXe1DK06BBacB3J7RB07nzhkF6jIpb5kXnVc67VLlafRJvlmX2r4FlV4pe
         tgnc2nSnsIypw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 11BDAC05FE1; Fri,  7 Jan 2022 08:52:35 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215459] VM freezes starting with kernel 5.15
Date:   Fri, 07 Jan 2022 08:52:34 +0000
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
Message-ID: <bug-215459-28872-ZQrcr1auNb@https.bugzilla.kernel.org/>
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

--- Comment #7 from th3voic3@mailbox.org ---
Tested again today and now when I disable tdp_mmu the VM takes a very long =
time
to start and it seems the startup never really finishes.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

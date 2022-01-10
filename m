Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E4B48953D
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 10:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242954AbiAJJaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 04:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242923AbiAJJaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 04:30:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC82C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 01:30:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE40760F4A
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 09:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20FE4C36AEF
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 09:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641807002;
        bh=ec1NSfuR4sL+KyunIpNC1qUY1ppfL0bw8Lb/6kqbtJA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VctDmqamw+sB7N+QR2/j6fvlRQBsO4h8xpe7FRlZeVZEGH0AVNhsY3Akkox6Hm0Ne
         KRe4Jjtvx84DeKTAyuync/OH1g9ieRwOSR/a0i1vDxnuzXEuU0eUjHRVgeCzLJ06UT
         B2d4sd2KcOvcdrYY0jPGGe2CBrm9vx/3S0FqT9BGzu6p4Jl8Qr9KQ9vxdIOBsJPGeD
         +p+KJV8zpdQpnZxd1LLcU8BRUQuoTPqsfj7t9zTxfyQCWH16wChoiYxDlyrGfwfWz9
         wYOHH+ik6nAd7ORzXt7WvbT0hvkj8Y3mB91/L9IUTXjIuuN5ooBjK2Tqb4D/bNuZV6
         U/UlDuWGCcxhA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F3EDCC05FCF; Mon, 10 Jan 2022 09:30:01 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215459] VM freezes starting with kernel 5.15
Date:   Mon, 10 Jan 2022 09:30:01 +0000
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
Message-ID: <bug-215459-28872-yRHoQoMyNS@https.bugzilla.kernel.org/>
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

--- Comment #9 from th3voic3@mailbox.org ---
I've compiled the 5.16 kernel now and so far it's looking very good. APICv =
and
tdp_mmu are both enabled. Also thanks to dynamic PREEMPT I no longer need to
recompile to enable voluntary preemption to cut down my VMs boot time.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

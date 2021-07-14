Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972D43C7B47
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 04:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbhGNCFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 22:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237371AbhGNCFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 22:05:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A55D61380
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 02:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626228153;
        bh=/pjKSeBl++iERhRCAmXSdFKnPrZ/99/MsOi5XeN5Ypc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=E8zkhb1jm/mD3W9p1G8B8TK0RqGfn4XBAZPzW6MU2sFg0Bbak3F/azV8kClDdpZa6
         fJ5um81E77GGcBC6GqeCocndhpXdIGJWFTYxN+0vbvcVikPg2C7e+eZOQjx5vVWSRc
         9plalXMtNKrJt1cnFppORH2zcBrqvffIcIFsxdFQosVZcD7dRnjO0v1GsGL4loLVCC
         PSAJFGh8Ue3WDpgl5SCWDlDA2dTapOUWa+e7wlQNMmFKDNKwyvTqQTjkjJqXxCBVFY
         foiCr2MCKsUTLwviMEpiajXME0z90RPSsASmJaGVJxKRODQc0zUC+orOOf1hmYP4mv
         8qCuUK2aZorEQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 3B7DF6124C; Wed, 14 Jul 2021 02:02:33 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201149] kvm vhost cause kernel crash on CentOS 7.2.1511
Date:   Wed, 14 Jul 2021 02:02:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: lizhijian@cn.fujitsu.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-201149-28872-N8DAXzYVWx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201149-28872@https.bugzilla.kernel.org/>
References: <bug-201149-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D201149

Li Zhijian (lizhijian@cn.fujitsu.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lizhijian@cn.fujitsu.com

--- Comment #1 from Li Zhijian (lizhijian@cn.fujitsu.com) ---
I had a similar calltrace with 3.10.0-327 kernel where some logs indicate:

[53012179.742195] Oops: 0002 [#1] SMP=20
...
[53012181.153015] RIP: 0010:[<ffffffff810b192e>]  [<ffffffff810b192e>]
dequeue_task+0x5e/0xa0

crash> dis -l dequeue_task+94 5
0xffffffff810b192e <dequeue_task+94>:   add    $0x10,%rsp
0xffffffff810b1932 <dequeue_task+98>:   pop    %rbx
0xffffffff810b1933 <dequeue_task+99>:   pop    %rbp
0xffffffff810b1934 <dequeue_task+100>:  retq=20=20=20
0xffffffff810b1935 <dequeue_task+101>:  nopl   (%rax)

but the assembly isn't a memorry access which is not consistent with where
'Oops: 0002' said.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

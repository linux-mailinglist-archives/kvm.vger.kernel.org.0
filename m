Return-Path: <kvm+bounces-2345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D52097F55E8
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 02:32:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7528EB20DFA
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 01:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3980520FE;
	Thu, 23 Nov 2023 01:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0tHg4xT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118FF1FA0
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 01:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8046DC433C9
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 01:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700703112;
	bh=hgmhwiTrNbuhuDwE5cYmjTerXxZfg2WKe8R/hiD7Nq4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=A0tHg4xTa4lM8bGl1WsgtVN6pYKHZp8txZ2+5BsL/NWHAWblLcagwpMTTMRPZwBzv
	 O1TrmufrRUe2KxXWV8vPlVlBeCQ6B/LTyemQw6+Dc+nRP6WtDzsPQEAI8OEmavQjWc
	 h1VZxc8PAwkzdfBHIhFlWvp/zPq7axKZj3fEt1aEJoVRKw8potbGpuXmhtumNGKduA
	 WFKvt93T998oSeNRwZM/3qavPM/5Dz3kB1cauMS/4mA+3M1P7PxhHcsVQa1ETQH+lX
	 3UHFtWwTYaIibT1Jd1HYQGkXs72zAIML/aVfVZ5NP0XT5dzqrLxfF1ro9UBX4HPUGQ
	 qQ/vqOTNY7Oig==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6F4E7C4332E; Thu, 23 Nov 2023 01:31:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218177] qemu got sigabrt when using vpp in guest and dpdk for
 qemu
Date: Thu, 23 Nov 2023 01:31:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zhang.lei.fly@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218177-28872-b5S1rH6QrT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218177-28872@https.bugzilla.kernel.org/>
References: <bug-218177-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218177

--- Comment #3 from Jeffrey zhang (zhang.lei.fly@gmail.com) ---
I change the debug printk to print %s rather than %d, here is the field val=
ues

        hlist_for_each_entry(ei, &rt->map[gsi], link)
                if (ei->type !=3D KVM_IRQ_ROUTING_IRQCHIP ||
                    ue->type !=3D KVM_IRQ_ROUTING_IRQCHIP ||
                    ue->u.irqchip.irqchip =3D=3D ei->irqchip.irqchip){
                        printk("ei->type: %u, KVM_IRQ_ROUTING_IRQCHIP: %u,
ue->type: %u, ue->u.irqchip.irqchip: %u , ei->irqchip.irqchip: %u",  ei->ty=
pe,
KVM_IRQ_ROUTING_IRQCHIP , ue->type, ue->u.irqchip.irqchip ,
ei->irqchip.irqchip);
                        // return -EINVAL;
        }



[Thu Nov 23 09:29:10 2023] ei->type: 2, KVM_IRQ_ROUTING_IRQCHIP: 1, ue->typ=
e:
1, ue->u.irqchip.irqchip: 2 , ei->irqchip.irqchip: 4276097024
[Thu Nov 23 09:29:10 2023] ei->type: 2, KVM_IRQ_ROUTING_IRQCHIP: 1, ue->typ=
e:
1, ue->u.irqchip.irqchip: 2 , ei->irqchip.irqchip: 4276097024


I also tried to just ignore the return -EINVAL, seem it works well.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=


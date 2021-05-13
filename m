Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1D037F1B6
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 05:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhEMDhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 23:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230301AbhEMDha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 23:37:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6474461411
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 03:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620876981;
        bh=gqM8VhOZ1Jl/pbilxkuPTioO3Vtb59judL7M/47PdQo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IAqP5QPcbOvkzJI7irlJ2QTxfRdmi2mNeFvhY+ifGM7HjIZh/LQ8K904XnY/seXk6
         JA/UlGirD1EKMsDJ+JFkqZhLskSl/n7Tlx1o2j1oFKKxNshuPXN4l5KxgWFyCUhDSi
         DWqnF5iJgKjJ2hXwFg8oIgJcvpbh2jk3M0xG/xpcEHe9N1iBYwbSyWX/nRk1OcoNJg
         7uWW9J03HsM0LL+JnnL3aQ25hPwdWNNAXcSq+EnL2Lynin0HKQT+aT/W/u+6qXASCL
         EM5a7Sg/Ho6yZrDqNiC8ANRuI9WRoWWjdkKSoszbvHegQ/k2EYK/sP9EV1AFXYLFyR
         w+GVNQYf7IUoA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 5B50761287; Thu, 13 May 2021 03:36:21 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 209831] Time spent on behalf of vcpu is not accounted as guest
 time
Date:   Thu, 13 May 2021 03:36:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: wanpeng.li@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209831-28872-exjLY2j6cg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209831-28872@https.bugzilla.kernel.org/>
References: <bug-209831-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D209831

Wanpeng Li (wanpeng.li@hotmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |wanpeng.li@hotmail.com

--- Comment #1 from Wanpeng Li (wanpeng.li@hotmail.com) ---
We fix it here
https://lore.kernel.org/kvm/20210505002735.1684165-1-seanjc@google.com/ , t=
he
patchset is upstreamed.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

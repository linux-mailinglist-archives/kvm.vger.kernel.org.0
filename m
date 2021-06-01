Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833D1396E02
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 09:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhFAHhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 03:37:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230326AbhFAHhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 03:37:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8AEFB613A9
        for <kvm@vger.kernel.org>; Tue,  1 Jun 2021 07:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622532940;
        bh=9thMpdpihaUDlVivPRXiWADN/lRPc/RTlPY3C2LhP5M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=THRqfJI2hH2rRSvgH2foo/eXD5G9rLkd6gFZkeJV81CTCRHCqasg6TsueraCF9JLL
         Zy9s/dcDJzJi+F07I4kbQKsWO85kGoVOcXQ8tjzj1f5jEnYcHDC8azd5PNE3eo/9XV
         IR11p4ZGjLxmWd301CBX6JhGCR7oBUKllWPBLheD+/IPRofDY7KMoY06eGIasdnCIy
         8kbT+GZB/WOUAo2kfGuur7RanT4DCSu1FMKKx9iKZF8C3ScIuTSbVYNd1t9m3BKmIL
         QXWa+6LLjJDR/wYJZkP+ZgihJaQ+X+DRv/sMEoYaCSTqZDFknfC0YKVSS8EqEAdijh
         Ok+ca6Lm2dBiA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 7D20A61167; Tue,  1 Jun 2021 07:35:40 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 213257] KVM-PR: FPU is broken when single-stepping
Date:   Tue, 01 Jun 2021 07:35:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cand@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-213257-28872-h8rhlkoIbQ@https.bugzilla.kernel.org/>
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

--- Comment #3 from Lauri Kasanen (cand@gmx.com) ---
That's probably not worth trying, since the computation results were
also wrong. The computation does not rely on register setting, it
loads, computes and saves entirely in code.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

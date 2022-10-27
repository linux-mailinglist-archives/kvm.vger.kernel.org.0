Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79446610691
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 01:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbiJ0Xzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 19:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbiJ0Xzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 19:55:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D466317EA
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 16:55:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F417B82146
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 23:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE3C9C43140
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 23:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666914944;
        bh=Y0N1bJ+4CZuyNEAu2Qt1dNvkZ/7N4YFAwAiG0rrP/jk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=HhJgC9l8yaTYhYKtyIGiMoeyt2jvHmTjkeskaddx7xDWqkpr6bEfjjRfOZaUD3uF3
         Op/tMjMN051DObKAV2hjCHupRU9Ca47wp6wGbO6B6VRncniaDl+BRLTmJXG64/tIRa
         OX18v+pAw4TOcSfeaQukytk+adWKyy2phX3YXOmaLYTWoKzfZqnv2v7Ump32Lw32dE
         EjaPWj4iTjb4qSH7ekiiaDI/p1qyqEBw9bsnRde+vAOx9/rLL/EvnJnzIBXN8dki5m
         XY5YvDaT3F5vopCNNn2X/wKL7UVdFkFY4tGR+vVH3LsskmOk9xStLYoeJAKafvnlOE
         SSU3mjDQrUcDA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DBCECC433E4; Thu, 27 Oct 2022 23:55:43 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panics in VMs running on an Intel N5105 on
 Proxmox
Date:   Thu, 27 Oct 2022 23:55:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: patrick@papaq.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216349-28872-LeI8HW096D@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

Patrick Li (patrick@papaq.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |patrick@papaq.org

--- Comment #14 from Patrick Li (patrick@papaq.org) ---
There are a lot of people reporting this issue on the Proxmox forum and I am
one of them.

Tried 5.19.16 kernel a few days ago, it behaved a lot better than 5.15. Gue=
st
kernel panic after 3.5 days instead of a few hours, but still happens.

There are reports of 5.13 being unaffected, ie, problem started from 5.15. =
But
I can't personally confirm this.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

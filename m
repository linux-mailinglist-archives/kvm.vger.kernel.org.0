Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B6D633987
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 11:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbiKVKQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 05:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbiKVKQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 05:16:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D309C40459
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 02:16:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CC9461629
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 10:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4ADFC43146
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 10:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669112187;
        bh=svnVl0+e7yKCwj6aqZYjxagK8UJKJQrYLa9BN+EiIos=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dhpHjg52cQrsrBdbA8kCACAAK60zctNmjlQxFD/cL/ltd9BoMeYieI60Q2XSYtJYV
         jxKi6803RnXHsvsUIc5D9LIoor/DwYGhrEHz329SF0MAN0g3uyB7zMIJqekIwF/hpc
         iwhq8jiuFjiWwSfQDiyZTmFCamXu+bv6/qp5WP9lZT+sTmPkjQcVdYnwmmTiMuVacY
         SUcTy3qWq5GgjsP2iRhXa7AUfn+rXxLnoIt5okP8uYESMtZDc1JeqVcxrobTIDw/c4
         2VU06OGkTSPlZmFAilDfCVsmkT9byKn7uIcSPjyWrXq1OuBeH2SiA3STtS0VIWYSAA
         ByMNKM1GT/bOw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CCB33C433EA; Tue, 22 Nov 2022 10:16:27 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216725] VMXON with CR0 bit 5 cleared should #GP, got '6'
Date:   Tue, 22 Nov 2022 10:16:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yu.c.zhang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216725-28872-Y8P9rEOWFK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216725-28872@https.bugzilla.kernel.org/>
References: <bug-216725-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216725

Yu Zhang (yu.c.zhang@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |yu.c.zhang@intel.com

--- Comment #1 from Yu Zhang (yu.c.zhang@intel.com) ---
Well, IIUC, the case was added by Sean
(https://lore.kernel.org/all/20220608235238.3881916-1-seanjc@google.com/), =
to
test his fix for nVMX
(https://lore.kernel.org/lkml/Yz7zB7Lxt2DHa4nT@google.com/T/).=20

But the KVM patch has not been queued in next branch yet. Maybe we can just
wait...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B001553178B
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiEWTg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 15:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiEWTga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 15:36:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F0BE8B89
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:23:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 153C361320
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 19:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69497C34119
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 19:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653333836;
        bh=r4c0XazdJddpEBAXsbXjz/T+RIyM0zM10qMzT02aW4s=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OcJhM19EatTA2H4Pv/dNFx2zoCl2Hz+HsMhVknjex8L1CVzjteiaiPLJMlFgiYfgv
         3C9tBHQ2saDXexFIM25lPSdTfnlahUX14MFuV3+vL6Q2D/xX+itrma1uMLnvq5m9CM
         3dzS61ffITM+XOS2Wp1BMB5CwN/ng5UXVxQKBCUfp3W5OEG4vrmEPEQWMlRZt7Y24f
         tiACZByTlT38+4wCcmtJ71e9Shvoamh98wJQ/IL79iatfYYGYG6M0PPG5G9QU24xPH
         yzQxGrd1tbxGOLRehSazIBvx+HSgHY3mRE365x2QlTynERbNNu6uBTEtBMVir5xkQT
         3eNu7TMfQEyog==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5766ACC13B5; Mon, 23 May 2022 19:23:56 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203477] [AMD][KVM] Windows L1 guest becomes extremely slow and
 unusable after enabling Hyper-V
Date:   Mon, 23 May 2022 19:23:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: luoyonggang@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203477-28872-J5pGjPVaY2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203477-28872@https.bugzilla.kernel.org/>
References: <bug-203477-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D203477

--- Comment #9 from Yonggang Luo (luoyonggang@gmail.com) ---
(In reply to Timo Sandmann from comment #8)
> An upgrade to kernel 5.8.13 solved the issue for me.

What's youd qemu command line parameters?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9337661CB
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 04:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbjG1Ca1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 22:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbjG1CaW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 22:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905BB30E0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 19:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B1B861FA5
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 02:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EAB1C433CC
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 02:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690511418;
        bh=oC/HxwdTBV2Zmh6L2kw8MU5RUHSHMr8GaY1SKudgBIs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cu0b2+0x18gUxne6V2ZbFnDfBaZQszWAd3QIwuyJFWi7UzSY0deaJt+wGs+BOg7Uz
         Jl6luKjuCxcD2Qf26PEk6Vvy/Gtqes4+HjsrCDx3C/WTrcP5FEWTmikjd4wYp8CARG
         q9gZsHsQV1K9MXg9fI288CrYJPHMgy7VOnphcw/IPj01q08mu8cy6eggZke3QTNYJX
         6dg2YlNLM2O4I3gkWOfBF3S44v+8iIAyb2NZgBafAHqlenJmQeShmBkBgFH9ayt+Fe
         pP9Au182o2sXrAquQxSvH5kCazVmDhr3bpJ2ItlKFutl7fzEAfrGQrDyrGEfhwhYxd
         VyahECCFUfvAw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6EA4AC53BCD; Fri, 28 Jul 2023 02:30:18 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217688] Guest call trace during boot
Date:   Fri, 28 Jul 2023 02:30:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-217688-28872-bwYIjtMtz6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217688-28872@https.bugzilla.kernel.org/>
References: <bug-217688-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217688

Chen, Fan (farrah.chen@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

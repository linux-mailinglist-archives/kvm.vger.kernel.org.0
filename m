Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998857661C7
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 04:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjG1CaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 22:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjG1CaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 22:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC0030D7
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 19:30:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95D6C61F9E
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 02:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 019F2C433CC
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 02:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690511407;
        bh=Yo37mvdAe7+KFfrPJY9umbOlPyeQ3OMPEHDaD54kjI0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=V+xXHOi2fH/ZNaY+fM3w2l7xo12O+IOLF6Wx7YBbicpGD8UXC2fL31u32t9TP42gK
         SrfCKOaIeO/FBssFIg1mniikOFF8Eh+aTAk+IsmwCUKuWGhTI95S2r65kknQBGDAR5
         hfVRwj5gJmshRwZasQKlmUgAN257+reYMZexMYSDhrHdlmxUi7m8SGgNbOdoRAw4gb
         NXZ36WcwBditqfswFgjy3WQX8GwhQEfWQy8sPgXPjr55ehzaIc1C1sHxrjTz5ZcFFT
         +4QrQ1upQsmtAQMfO7H7bQBMP97SaMZ2qjd9ROTbAFScaXEU3MWpgyuwlwM/kbyzZC
         wsOXAf6y3wmZw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DA7D9C53BD4; Fri, 28 Jul 2023 02:30:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217688] Guest call trace during boot
Date:   Fri, 28 Jul 2023 02:30:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217688-28872-jySHxKYlt2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217688-28872@https.bugzilla.kernel.org/>
References: <bug-217688-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217688

--- Comment #3 from Chen, Fan (farrah.chen@intel.com) ---
Thanks all, cannot be reproduced on 6.5-rc3.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

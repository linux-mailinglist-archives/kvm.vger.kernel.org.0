Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEF977DCEF
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 11:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243206AbjHPJEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 05:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243215AbjHPJEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 05:04:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2015C19A6
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 02:04:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B325F66349
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 09:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E863C433C9
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 09:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692176652;
        bh=8pmALYgfa1+r8YyC8bWT1LAVpG33dHju025mo79vzj8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZhF/iNGIiJ2B5Cbk79tHSCnp6jiN/MW+68bGYQO8JFHJHLCh6fRiuFpKXr8SzBvgE
         J0yNlrm+pwiVQIRV1UbJOyfzsG372qQ0OBDn1a3RSfyZnkUZQQ2YZPN6cygsnU01VA
         rP1IvyeJO0vQQ0gVBi73I+vh/pyh3fVNYDhwUq+LY3jjSOpsKFdNYt5SzycHv1EUsz
         5xybhJx5zVn9LuTkRqSN1gCl9PChrOPw7kBplHfiG1jhPG5orD2mDRXNNTPhO7/j8q
         os54v78w24oDq1n090iEUF9Rn8HJsmWhwZdZbJQIKNPlCrbaB6pYZRUWMIpVvsn7Hu
         z87g7Zmh65irQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0C945C53BD3; Wed, 16 Aug 2023 09:04:12 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217799] kvm: Windows Server 2003 VM fails to work on 6.1.44
 (works fine on 6.1.43)
Date:   Wed, 16 Aug 2023 09:04:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rm+bko@romanrm.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217799-28872-WGu0MTrHH1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217799-28872@https.bugzilla.kernel.org/>
References: <bug-217799-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217799

--- Comment #1 from Roman Mamedov (rm+bko@romanrm.net) ---
Booting the kernel with "spec_rstack_overflow=3Doff" solves the problem.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

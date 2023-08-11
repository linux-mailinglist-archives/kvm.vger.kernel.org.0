Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE7777855D
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 04:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjHKCWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 22:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjHKCWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 22:22:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6475A2D58
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 19:22:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACEAB6537D
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 02:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 220CDC433CD
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 02:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691720548;
        bh=iKFSiCUeO7xdODjF0V1QlmisId87kDwpqxB/+4f+r9M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nuNUN7Sc2KBN7nrZpnHUbrSv4Vp6he0+dvLvnUuHeQexv7kLIDVbqgNek1Grl4S8a
         ah8sU9EnIvoOwrEyw2pUVy8MbtREn5REjO9/an5H7qRFcOMbA/C0wcXGUIO4sV3qOk
         CRD1AGCyw4E5vjszr0l+RTP0eyknekT1B4w0bjvsFzFK5R4pKgJbkRSke+2b7xauVz
         F7on4DQBC9F74tMkiuNPh7V/iGVcim/sTAoDLLLnryzR+V+iRTEy9K3lgUbxhv0uGF
         ctEKXxq2F/KcXLGx1dd/gjTSN8/cFdNjzeUcR7PjpidwW+llPuWa67wYCvojdxRvZJ
         PoWgRYWg1yNjg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0FC39C53BC6; Fri, 11 Aug 2023 02:22:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Fri, 11 Aug 2023 02:22:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Drivers
X-Bugzilla-Component: Network
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217558-28872-YShoNcyDAn@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872@https.bugzilla.kernel.org/>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

--- Comment #13 from Chen, Fan (farrah.chen@intel.com) ---
Hi Patryk,

Do I need to add "tested by"? I cannot find the email.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A2265F939
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjAFBkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjAFBkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:40:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFDC1B1F4
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05B93B81C3C
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 01:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5559C433F2
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 01:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672969207;
        bh=kmxLDNrKIC1f0lkRrg5UXmO3wucxpSX1BCm0Xu5ZjGo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OjULj+X3w5gUpTm+swYo6XNblX3Ud/GrRwYo7DWJ//c6hcNP1A0KSS5mBTKPcT9+P
         IENFE2SSJXnGsyzGT9ra3gbJdldWS2LANn6kAfLn83RYK4HgFeH98cgbMiMQxcMyYS
         jEsZTq5bGreKi8pGck7jM/ZlzKeO5Z6EjhBsMuB1wKvZRtKE4I0VlJED8FA03k1IlN
         xOSoVzjoutGhgVRy14gHtWNFFb1n5EmMUHUowqeSk1XOo2eAJBbg5zmPClh8nv3JLx
         Ua4yrNfagN9OzA/cYUknDD7enzGunfkqWNJuT5IjU6ML0myFKw9HVrPVtv9rU6rk+P
         uZeshZF7KvjwA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A555EC43141; Fri,  6 Jan 2023 01:40:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216891] The interface for creating SR-IOV VF doesn't exist
Date:   Fri, 06 Jan 2023 01:40:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: lixiao.yang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_regression
Message-ID: <bug-216891-28872-qMXolPnpc9@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216891-28872@https.bugzilla.kernel.org/>
References: <bug-216891-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216891

Yang Lixiao (lixiao.yang@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|No                          |Yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFD173885F
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjFUPHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbjFUPGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:06:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFB15FC1
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 08:01:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D4B26157D
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 15:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91D33C433CD
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687359612;
        bh=dzVd3XEM/A5AeKzmH8Zk3lOysroE3QghWiWB+G7L0nw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Gfhh280UNoJVz8OHK9cGCefbQuL8FJRNZjb8Umhk9CadMbKX+NdhEy1PeKxOM6H5Z
         UJTLx9tNdF9WnUZdLmHJOdv1XsCb7yavNQfqRsORXTnPV0u73bNe7DnceCYM7iFFu5
         uLOGJD+YV2lMRylo0A6LHfu4rst5d8jSAgVregLxK56+MBKu8dhvW8jxv1T6JXqAjV
         02kmakCRdDU4jcvWRq4+S/+cuKfyZWsY6QOqGoZJxoCdoyHjDoAi+nyt29lG1m7OhA
         PzGdqgDWGdp9GTyziPxl+8cML2Y0TAyQfI16k/w/JSU5MnMvv+XI75AQ/6tWL3vaiJ
         dtapSQ3zJXdqQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7D6EEC53BD4; Wed, 21 Jun 2023 15:00:12 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Wed, 21 Jun 2023 15:00:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: patryk.piotrowski@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217558-28872-fUR5zGoYFD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872@https.bugzilla.kernel.org/>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

Patryk Piotrowski (patryk.piotrowski@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |patryk.piotrowski@intel.com

--- Comment #5 from Patryk Piotrowski (patryk.piotrowski@intel.com) ---
Thank you very much for reporting this
AFAIR the patch from Sylwester was response to one of the critical issue
We will take a look at this issue and see what can be done here

Many thanks and regards,
Patryk Piotrowski
Intel Technology Poland

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

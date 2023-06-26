Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDEB573D69C
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 05:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjFZDuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 23:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjFZDup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 23:50:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D078E1AB
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 20:50:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D23660C79
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 03:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE675C433D9
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 03:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687751442;
        bh=AcSYdZnTpnMUr4FJlU+9Odc8cN749L9O4ZhD0spA0Bw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=M1xKX4r0+GpzVHHDjopvex9N5/ghLdGf47IbJ1pA+IxvcBwlHYSwSUzVXmi12OIVs
         OMK+2GOC2dSxIcfofe1ehgElb1cpJfBJWvdE32GK+zZrOCWwKAtyTvwCVZLReX8xNd
         UneZqLQ+mMOx33Tfu4/KpRoPD4YsKkslk1GT2fHmxW54/BrsF4Echz8rgzFw/LYGbX
         WPsEUH5ORU/ybWmWpRWP6lKdr8e2rbhfnQOZ+yt/qBVkRryGkNfAkt2ElpMsrOkLy/
         FVMVUx6R5BvSE8K7c5UkSC2BXf7WvpkY9/Z3QYi4TVZfw18nnEbxpD2hRYwg6D9nkZ
         Tcy/RkGLn82dg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BF724C53BD4; Mon, 26 Jun 2023 03:50:42 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Mon, 26 Jun 2023 03:50:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-217558-28872-wYNrAQrB5S@https.bugzilla.kernel.org/>
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

Chen, Fan (farrah.chen@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|6.4.0-rc2                   |6.4.0-rc7

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

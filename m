Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44747314C8
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 12:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245303AbjFOKEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 06:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbjFOKEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 06:04:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF712703
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 03:04:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10A5E62FCC
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 10:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65C53C433CA
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 10:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686823449;
        bh=jZu46Dgse0gRmvpJczcmsjtrwbVqEjM2jaR4qHxBQrY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bA6MD1hmPSvLzoSc5qmE28PrXTM/EHrD9uqgHnXClZDfiCCVRpiD6IJyV/Y2WjRoR
         azcPNKile3Qd6JTvLCPOSQkdHUJo3c13yl/bD1Ss1hhPhKF1MvNNWZ2alUiVnVNFst
         E0DM2ag0SkB029gUfsYYlr9ShmbIMMx5K0bKrAx0NVdZYuaoVnajD9lfIbLp9bGUqd
         IZaR6CiH7T2EDceIQt9CJYVSOisjfflUwFS4wS7dc2N6tQBGJJurnIGgKAlpEy6uZs
         lLUYYIdDyRP/knuCm/7YKroLMNHP2ZTCMRFGSFQmd1Pni2HvC3WOBqztBlUdWwCONP
         er59/hsAHTRuw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4A7F5C53BD1; Thu, 15 Jun 2023 10:04:09 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Thu, 15 Jun 2023 10:04:09 +0000
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
Message-ID: <bug-217558-28872-1QQmv30zhw@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872@https.bugzilla.kernel.org/>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

--- Comment #1 from Chen, Fan (farrah.chen@intel.com) ---
This issue is not found from this commit, it has been going on for some day=
s,
we found kernel 6.0.0-rc7 is good, but not sure when it started from.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1407C67C7F7
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 11:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbjAZKDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 05:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbjAZKD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 05:03:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E5D9756
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 02:03:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DE6E61781
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB9ACC433A1
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674727407;
        bh=PNUQAW/iPLRcDtEgHw0YOe0U5YIeAEN0C3VB2SiIL4k=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oh9vyv+rQuOEwiuF9W6NXC7zgB2BYEXN97FHDeNv0M5cXJoC6kHW48m8ZWM4Rn5KL
         4kx/vAQQsGP61UTcsBl6/XnL2Ti/ctMCV3p6h5g7tpXALwAweAsHikVjHj+dLFJLgq
         ovQUvgXsSaIekxktzkvbgWvH+WQRnMie2rVUUJzPhes0TI2OyCvbBDJkPmucZYxtDD
         Pjh6CWhac6gS9d64Pss7ZtpPZw/bhMueRxzh21kp+otq7IB1tQM49c2WxSh9ANiSwA
         /dzbrU7uOLKRdxYgdufEUVeGg1V1CGnxmfrKrymikb8hWz30Ad0J0BHlfyDBSjLCWB
         GXUW8kIr4M1Iw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B5E54C43165; Thu, 26 Jan 2023 10:03:27 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215964] nVMX: KVM(L0) does not perform a platform reboot when
 guest(L2) trigger a reboot event through IO-Port-0xCF9
Date:   Thu, 26 Jan 2023 10:03:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mail@klee-parthy.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215964-28872-adJlNyHQsp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215964-28872@https.bugzilla.kernel.org/>
References: <bug-215964-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D215964

mail@klee-parthy.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mail@klee-parthy.de

--- Comment #7 from mail@klee-parthy.de ---
This seems similar to what I observed in
https://gitlab.com/qemu-project/qemu/-/issues/530. The AMD nested commit
specifically seems to be the culprit in my experiments.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

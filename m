Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F6359714D
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 16:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239913AbiHQOgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 10:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240194AbiHQOf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 10:35:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6F49AFE6
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 07:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E9FABCE1D3E
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11472C43141
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660746944;
        bh=IKJjfnmqfEI1PN/hk1M8DXdad3UwOw3EaRz2s6UcHL0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VgBw3rEQTDEGHugGi9OU5PvqufIpMIPLIETewG4x+3h75VXQlsnWdj31cqnOtulrn
         zPF8lNC/erxVVbJ/Dswx6BdDEQtGnml/Qr2SBmzMstYAeZgjNrOwgjpMy/xozzy4ep
         nv3jJdKnhqa0eTxONhbxhI4B3qTfF5paQqV2nkEtMGbSQBfBOhJDBUwqXE2dOlkIbW
         Z2KDNjd9SmuS6YYFXmLf+1k0vzt6VdSeAfMd6TC9QisiT4zphUM7kImj5Km8z5lGog
         jP80ciciTffYJXc1Gg/uC2A+y+CgjuLUdfKAFGpIvhxSrkBKmwC3P2VkZODFtA/gus
         ridWr8Df6uEfw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F000DC433EA; Wed, 17 Aug 2022 14:35:43 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panic in a Ubuntu VM running on Proxmox
Date:   Wed, 17 Aug 2022 14:35:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216349-28872-zcyqV0ILR7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

mlevitsk@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mlevitsk@redhat.com

--- Comment #11 from mlevitsk@redhat.com ---
Could you try a new (5.19 for example) kernel and also try an older kernel =
to
try and see if this is a regression.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

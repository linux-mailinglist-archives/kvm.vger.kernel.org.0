Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4471374B2BA
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 16:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbjGGOI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 10:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbjGGOI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 10:08:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B09211B
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 07:08:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEA0F619D0
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 14:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3252DC43395
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 14:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688738890;
        bh=kVbnMYEfaksPGvhquIGRjb7isIeUTPJ0vpM7iORv+F8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JwWHgHKrUCsPAmG4j8yzLbmG+6IVqXEAmrAJzmXOaXoZ/S3HcZr7HV9X/4oT2Tld2
         fDzwiGFtVe498AQ+Vfk+rc82lqJPHy5W0iAgEPv9TE5alaeOpwI+bXF2lqgy5EY2ny
         06jDaiW0+Ar+CVhgcv7pXgvBynERBHfBLP+dtex+raBRiOpWELw3NgWo9Ms5YvHKMC
         xJQ0aRNBjZvC+roUCkJt44vVwqg5s6JzqLgQEVgB8eMc1zWE5yNybhgJ4C3/GbqInt
         BT5e/eL6xTLY2vW277XuWgkgKO2ebHGRgpJi3d/70A7HkOuRy/D6FpB8zmYKZcGNbp
         J+waKlivLmD0A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1E18DC53BCD; Fri,  7 Jul 2023 14:08:10 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Fri, 07 Jul 2023 14:08:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Drivers
X-Bugzilla-Component: Network
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: radoslawx.tyl@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc attachments.created
Message-ID: <bug-217558-28872-XAgvYJObBi@https.bugzilla.kernel.org/>
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

Radoslaw Tyl (radoslawx.tyl@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |radoslawx.tyl@intel.com

--- Comment #9 from Radoslaw Tyl (radoslawx.tyl@intel.com) ---
Created attachment 304564
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D304564&action=3Dedit
[Patch]Fix inconsistent mac address of VF

Proposal fix inconsistent mac address of VF after remove interface on VM.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

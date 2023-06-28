Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81F9740B29
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjF1IWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:22:46 -0400
Received: from dfw.source.kernel.org ([139.178.84.217]:55980 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbjF1IOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:14:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CB2961330
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 07:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09269C433D9
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 07:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687937717;
        bh=rZy+mEYRlLSwkDN86xqeYUTHYSzMlWm3xgp4EnKIXFY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pTBbyUb5ZFsw5uPYjVCnJUlWWPi5r7WIL16xc95R9gZtdm3YonTjL+l4TR6ZEdd8l
         bL2Me/2acE3lywAG3WewXJ1WT/HH9QYU4oOUinzqFKCh3N0lBRxzKrsSmvONj5fXyj
         7Y0z5aqEpAf7kElAeDxhhs9G9fD9mHc1KV1MTgVr7RJEWW+k81M6xQkEPjxIZUuIAA
         KjPK97PIWaHMjn3j0ClzQbjq8NGy0vrzofgb65YePCWwJ8+oUEwAUyKxvpHzqxQRiP
         1ViQImdRIVNFsTYOXkytOW2nIH6Le0BdHuigEuarVZbjjvxd8vdy3vydcSV8jwUrTM
         xNLZnl+IJVrLg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id ED17AC4332E; Wed, 28 Jun 2023 07:35:16 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Wed, 28 Jun 2023 07:35:16 +0000
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
X-Bugzilla-Changed-Fields: component version product
Message-ID: <bug-217558-28872-TWHQrm1oum@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872@https.bugzilla.kernel.org/>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

Chen, Fan (farrah.chen@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|kvm                         |Network
            Version|unspecified                 |2.5
            Product|Virtualization              |Drivers

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

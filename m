Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422887384EF
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 15:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbjFUN0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 09:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjFUN0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 09:26:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6502A1985
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 06:26:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F012B614E5
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 13:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62B65C433CC
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 13:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687353967;
        bh=pM9VwnipsZl2+XQZMqK497x5chTdVSxrOtyDa/n/rN4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rgC1snn+dpbG6YrAmENB8UJisotBJJMTjLNienSY1Aa2e6K2mpuiN7FEuF3Gd2SYW
         usDjVExvjWuigN0EMvqF9eBYfpwQRWS+Yn6LkqTzv/OCh7HVWYZLELy41VmS3c1u4c
         xGbtmEj+P6DiBovssF9LVGD4C/bD6wmysBepvUs+s3qe8HRRqipsQ8yaOyr3gFXykX
         kP0tY27H4ccG9E4klMwkmblgGDPTmssnrz6Zkuic3CSZyu2y8nGi8mq0slvE7WJz0P
         U67/dx9UMzggeWTunPD4Er4fdrrSg3ogFGzQoipYl8ahJ9ZUyGp8HUXo0WWwlB7FNr
         fY+qUCY8kdhpQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5183AC53BC6; Wed, 21 Jun 2023 13:26:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Wed, 21 Jun 2023 13:26:06 +0000
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
X-Bugzilla-Changed-Fields: bug_severity
Message-ID: <bug-217558-28872-7pdgyGJKDo@https.bugzilla.kernel.org/>
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
           Severity|normal                      |high

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

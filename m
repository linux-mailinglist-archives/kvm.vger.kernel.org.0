Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A0B77E783
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 19:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345191AbjHPRXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 13:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345205AbjHPRX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 13:23:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13F2121
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 10:23:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ED5F66DE1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A45C5C433CC
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692206606;
        bh=qry4dwtow5SPeCl/YjePTV5h+SXoG+lIdM39NzQVBQg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qztZBFIeo4ZvaQ1mDvlj+CC92zLLRLeYC70t/4uXvKMcUouXnQHojnQRVn1aX+6if
         a1dKR7r2oefTIdWVyOiKeZBurHg5sDGr6bpRNzqUs1geGGR02fE7SQz27aaQmFbrRw
         zHr1nyB+fKc4dyTHUuVgwl1Ipydzm3kA/vasc57OHj84dUQu30qjlV/nXwm7NfCDii
         j8ZOKdEulUNwwy0r4qo0vXd/aE5GMlr91hL0q0VouxQmy35bxjkN+8sm4N5S8XUwOC
         KM6G65ewBeA7SQofsWTAEYv7vDa6SKeORBevDTo6TUnshLTfVhgfN7KAn+xl3/si5R
         X8+vpXKd64WKw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 91D3EC53BD0; Wed, 16 Aug 2023 17:23:26 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217799] kvm: Speculative RAS Overflow mitigation breaks old
 Windows guest VMs
Date:   Wed, 16 Aug 2023 17:23:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rm+bko@romanrm.net
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-217799-28872-7J5QRmsudy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217799-28872@https.bugzilla.kernel.org/>
References: <bug-217799-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217799

Roman Mamedov (rm+bko@romanrm.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #6 from Roman Mamedov (rm+bko@romanrm.net) ---
Indeed, this patch appears to fix it. I built 6.1.46 with it added, and the
issue is no longer present. Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

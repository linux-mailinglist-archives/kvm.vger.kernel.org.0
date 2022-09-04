Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D115AC246
	for <lists+kvm@lfdr.de>; Sun,  4 Sep 2022 06:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiIDERT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Sep 2022 00:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiIDERR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Sep 2022 00:17:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450B5286D7
        for <kvm@vger.kernel.org>; Sat,  3 Sep 2022 21:17:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A0C60EA6
        for <kvm@vger.kernel.org>; Sun,  4 Sep 2022 04:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44A35C43141
        for <kvm@vger.kernel.org>; Sun,  4 Sep 2022 04:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662265036;
        bh=KIOTtDNaMiGS/S2iKGXicF9/RrOxBjMP+sUMO8+FXac=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EryBVAA4xOy46+VMzjw4JPuh1Q4LJ3kP0MahUwY+p9PpmV1HSP0gUFTeG0WYF12iH
         vdvJDDIGBt/lnzrC0lipp9zY8zOQhuF7L1EY+OtqWh4gfwqV1TAfLZe51C1KLl5cgO
         zxCJzA9ibn7bA61BunUzQGTvRR++zkjPC1BoTW7ScebbV971M2gFPgh/uFVtFLQsvX
         k1gM4HEmo+q2GVUerKDsSXkpXi5kuuZgq4jXRKELFUtwDvJm7qagM4LQgOkWMr+jHt
         Lqa24gTtHmUblkPCqccLBJboyspXntbBb3sGoageVqat1YFgNvCK5xY14ozZdck7Uw
         eUugjhGHCpJbg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 338D2C433E9; Sun,  4 Sep 2022 04:17:16 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Sun, 04 Sep 2022 04:17:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216388-28872-iOeDvp6RDu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216388-28872@https.bugzilla.kernel.org/>
References: <bug-216388-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216388

--- Comment #16 from Robert Dinse (nanook@eskimo.com) ---
*** Bug 216399 has been marked as a duplicate of this bug. ***

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

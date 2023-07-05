Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3657487AC
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 17:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbjGEPS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 11:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjGEPSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 11:18:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9AD11B
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 08:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4DE0615DC
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 15:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E6AEC433CB
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 15:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688570303;
        bh=00kdlym2TIGM2CXNOZ31zECrpS5zdDqKGElWi/hytOU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WZBfFOpYx/y9HXsmpgVl97r7VmlsGvlmySHMWZAE5MRAK7DNlZkvfx4MiOJNq+5yi
         sPxuJSLkM+n74gOS/gUoZ7K/ljp7obEkfaqug4wFfJTdFUXnA2GAO8a/xBmEgugKrz
         X2GQCh8AUxZZj9m4Wo8e59L26/oquOWT8OgeQmQlH8Z6riBRmyGkQ4byNCkA4cm5cU
         xnM85/QPmogtD9p2cGux+LnbInIqrr2zMJ/ZNUif4jpSzW9WEfkcv4Q9/mPTxppUcG
         BRiyXCE4KZprDuBrv0D6uh3dCc8kenwAPbFgHSEj3ZzH1TbRmLno1kiOThENu/PVUI
         Ewao6XB5I2IWQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3FE23C53BC6; Wed,  5 Jul 2023 15:18:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Wed, 05 Jul 2023 15:18:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: webczat@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217307-28872-d3PLV1AXLZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217307-28872@https.bugzilla.kernel.org/>
References: <bug-217307-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217307

--- Comment #15 from Micha=C5=82 Zegan (webczat@outlook.com) ---
what is your host's cpu? from what I read from other posts on forums/etc, o=
nly
it seems that this affects 12th gen intel cpus and above.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

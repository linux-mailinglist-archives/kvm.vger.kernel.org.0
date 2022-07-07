Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C222656A6D1
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 17:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiGGPYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 11:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbiGGPYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 11:24:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C8116585
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 08:24:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AFD6B81188
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 15:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBBDAC341C8
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 15:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657207471;
        bh=VMQYArXToNtjkYs6YlOoS+q0u5s6Hh/hUM7oPYaV1UI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rN9HcTriSlftaDRPT2OwMYjB0MJV2uG2KgV1AS8atD5ZcrCmtnHWvIIyvtClaIhCB
         EU7eEaPNIs5n5o6JigEd4vEJ42sINJXrW/6VqMDtz0TKENYo4qMlaxlL7f+6+k9A1m
         r8/Zj243JGkPzG/9qyqZPUBEQE0IeFOrHpg/+XJQcNp4wPlJL+zyXoc1PiRJngLtuj
         6pWBS4IS0xNbllvx7PKCairZlN2FyVuUAPhjzgx/WMUmo1krVV3jUjHy7xRiPbSN27
         FkfC+9z+zngMTWEG9RhWcMm9qnmQKT9TI23U6ZbCkh0eb4iIoQWH/JA24WmaDfHkfr
         5IHcImV0YzqNw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C47D2CC13B5; Thu,  7 Jul 2022 15:24:31 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216212] KVM does not handle nested guest enable PAE paging
 correctly when CR3 is not mapped in EPT
Date:   Thu, 07 Jul 2022 15:24:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ercli@ucdavis.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: rep_platform
Message-ID: <bug-216212-28872-tldYLSnBm0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216212-28872@https.bugzilla.kernel.org/>
References: <bug-216212-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216212

Eric Li (ercli@ucdavis.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Hardware|All                         |Intel

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

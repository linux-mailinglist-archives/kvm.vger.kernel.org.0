Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA9975A4C9
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 05:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjGTDb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 23:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGTDb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 23:31:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1355F0
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 20:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 208136126D
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 03:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88684C433C7
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 03:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689823914;
        bh=mKchBMI1worfcsJ2ZRT/e+i/zJaVq4cOEtEi09Vo+K8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=n0dXYS3bq7Vx4AkZVNzb42qlrTLnyV53BDjRg/b/p2MLuOlk2YgEAd4elGJaA6aPV
         WVCjJ1w9wLDJpZ877X00WJq4wsQafarm+Xm/1B5T82oNu6AWZO4ynMkAJESqAJ2Dhj
         4WYR8CdLiWhw4QHcjMvLFhoWdmm2cU1w4E1zebOwjyYVs/FJKhFrLbF1i5JHbOACpw
         RShCWqkm/FH3pSLuZDRdU6N0bm6SElmnuImF7GFHLKmqreGEtvakv8PWRQZl8vzmrv
         i3sjE0bgMyyIPZ7w2auLsX5nwrbNEjsOgD985vDev8iMHT4EsUmzNcZ94Cj/FmCqZD
         4kEr9iUKIJAeg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 73C57C53BD2; Thu, 20 Jul 2023 03:31:54 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217688] Guest call trace during boot
Date:   Thu, 20 Jul 2023 03:31:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: chao.gao@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217688-28872-i4m2MwODAb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217688-28872@https.bugzilla.kernel.org/>
References: <bug-217688-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217688

Chao Gao (chao.gao@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |chao.gao@intel.com

--- Comment #1 from Chao Gao (chao.gao@intel.com) ---
this is a known issue. Xiaoyao reported this issue earlier, see
https://lore.kernel.org/all/CAJZ5v0gaZHpAri7LRcfpS2TyK_Bsjuxkw9cZUm_uGZAgiu=
b4Jw@mail.gmail.com/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

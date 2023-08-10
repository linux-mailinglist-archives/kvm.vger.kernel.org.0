Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8913777A06
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 16:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbjHJOAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 10:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbjHJOAb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 10:00:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5B510C7
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 07:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09CC065D32
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 14:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73E88C433BA
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 14:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691676030;
        bh=wKD5PG2QOMvo6nm0oHl3SUkOycPgmpx+6d8ieqE2QJ4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=U9QC/NrUms/yHxb54JFK6nWQgouvjIK9a+w0TP9sh+1E1GPJaoktmRitNqLXFXe0+
         yLnnZvozRLFy4ISqrgcEZ3eLoqgzquNy3HKUoHBWqcMrJXACZ78EV4Ml2OM9n1pFoB
         hC/fl1k6aLcWuwISc0pSlat/LZqAhPXAqwnjaCFhpdqUSY9glZuyoMxkZUxWM0TtJK
         /ABJdXg1FwFgsJ4vCzNbRy3cOS2hRldWQ37C4GqxKHrRdGE8EobyVKxTU76UlHWzZr
         Zh9gKWr31Dz2RZhrOL7onLm2zVLPBDsau3tFfeo+4hQIObF7Qcku77ZswTPgBsJirb
         CQGED7kFBZ9Ng==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 577B6C53BD5; Thu, 10 Aug 2023 14:00:30 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Thu, 10 Aug 2023 14:00:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Drivers
X-Bugzilla-Component: Network
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: patryk.piotrowski@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217558-28872-EqkEjhDYoG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872@https.bugzilla.kernel.org/>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

--- Comment #12 from Patryk Piotrowski (patryk.piotrowski@intel.com) ---
Hello,
The patch is already present on dev queue and it's waiting for "tested by" =
tag
IWL link:
https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20230807125940.9=
85494-1-radoslawx.tyl@intel.com/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215B958F766
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 07:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbiHKFwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 01:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiHKFwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 01:52:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F171637FAD
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 22:52:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FB5561422
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 05:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01A37C433B5
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 05:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660197126;
        bh=3Oqj+GKWrTlFrszrtQytHinOzsCDAPItWzhSI35v870=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=R0oSi21Hsg5A4X4NKfKUXEPHpUGkWxdfFmcuk4+4YOmasO+FS67aioyeFgXzOFETB
         zzIQlof2yKBkQE6BN6dto6D79o16FQVG3PI4/tYJLYOMNHVS/+MXktGaI41buWOrge
         Da3CSiCPr3naIWsmDqwybZbmk9axlSRm0ZI0lZm8mJ+JLBxOo91EXFA1YHPX56k+sP
         bDUhzKIsNmf5rSxk3Tq9K5//e6NMJE4dAPx+1ZUn0dkvL1Qf/5nzcckzTXE9hB12kB
         5Z9WUYLigE90pf4nbtlZ5f1Y+2CnGHPCN+2TSfhzMlhiAbPCMmPY1HGX30tcRkGMcH
         8DFZX1zhr67Ig==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E7E15C433E6; Thu, 11 Aug 2022 05:52:05 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panic in a Ubuntu VM running on Proxmox
Date:   Thu, 11 Aug 2022 05:52:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jdpark.au@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216349-28872-ESmhw6PjRJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

--- Comment #5 from John Park (jdpark.au@gmail.com) ---
Created attachment 301550
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301550&action=3Dedit
Console output from kernel panic after using q35 machine type

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CACC54CAD8
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 16:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356044AbiFOOFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 10:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355999AbiFOOFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 10:05:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CED49CB7
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C776461BAF
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 14:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3015FC341D3
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 14:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655301947;
        bh=cCYoznFVTdRCMjgUYe/7Bx+WEz7E6Gp3ALijU6B9N78=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FWyZDAv+jUrE5vSqE8Gcfw6SmGed/NhJoMprsDz2KrDZbZFTuQxOY5AHZ2dyZ5itR
         qcO9nNDEy4jWFGRS/Fiqpnlj6OI5BkRj4oIyauLTHYE4hatuFcrVIrnA6cyyoORbJ/
         iDL9datIhSnAJtd3qjb2IWmWGyXLLHho0OEI5AzRr9eg/VMwcLcDDS3cxXz7haOJBL
         IllP/zELbvVOKKv158uBgxnIAhDf7scMtU5yGVIhCehkg485wc8BqQnB9AY1u929ty
         U95fMDGZrJaass0dJYitDLK28eo0b43qILtn/UHVBnlS4iqzF6amURLqpWNF8uIgx4
         819AOjLHW5/GA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1C753CBF854; Wed, 15 Jun 2022 14:05:47 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Wed, 15 Jun 2022 14:05:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-XGSWijb309@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

--- Comment #19 from Artem S. Tashkinov (aros@gmx.com) ---
*** Bug 216137 has been marked as a duplicate of this bug. ***

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

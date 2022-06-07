Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C990D54025D
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 17:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245227AbiFGP1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 11:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236718AbiFGP1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 11:27:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FDB21E1B
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 08:27:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B15861716
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 15:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D23C385A5;
        Tue,  7 Jun 2022 15:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654615638;
        bh=ueyRcXFv7rEb7tdf83066lmJl8gE/lV6HoeLB5Uk8VM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKZ659VVSj3rE2txIcfea6nvbu90HicYGxlDUpKKJtmSZcGmMVt2NkIlC9S8fhddd
         Fj28+BkA2aQd3hIOvxQIELcVqba7Y/CSsfaAXK1CmjGKj7oqmx3I2ZtFamJtvGOvvY
         WZUZOQgkNYLV/5aD5dVkhwQ7TSYtsuhNEP+0shTOkUcDWcVou3GDhw/AKPBCvIv9oh
         KFOEjxkxI0+34PY6qUFXvtnzLanT7PW6Vv/35LWGZ1DnJFhFq7suD3/2cAEW/rR9hc
         yWlxJM0ukla5O1GLb+EWWo9D8faRE1Iyc3cV7e29/dMw11p7vkfBJ979KznEJZWYez
         lVJA95gt+d6ZQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nyb6y-00GDdG-0G; Tue, 07 Jun 2022 16:27:16 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     kernel-team@android.com
Subject: Re: (subset) [PATCH v2 0/3] KVM: arm64: Fix userspace access to HW pending state
Date:   Tue,  7 Jun 2022 16:27:12 +0100
Message-Id: <165461559010.127313.6746590114309145143.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220607131427.1164881-1-maz@kernel.org>
References: <20220607131427.1164881-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Jun 2022 14:14:24 +0100, Marc Zyngier wrote:
> This is a followup from [1], which aims at fixing userspace access to
> interrupt pending state for HW interrupts.
> 
> * From v1 [1]:
>   - Keep some of the GICv3-specifics around to avoid regressing the
>     line vs latch distinction (Eric).
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: Don't read a HW interrupt pending state in user context
      commit: bfb5ed4097c75917da5c8a74ab236b5acc703d08

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>


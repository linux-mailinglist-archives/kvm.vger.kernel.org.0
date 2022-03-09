Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD914D2DCC
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 12:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiCILSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 06:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbiCILSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 06:18:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E90832ED2
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 03:17:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ECE0B82040
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 11:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5F5C340E8;
        Wed,  9 Mar 2022 11:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646824663;
        bh=JlkIqCPe8EccB301HGf03mUUxO/iuY/OiZe+7CVnF2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWKcIX1WtcJWMTI3tqI2/IaDK7VQ+5erDN46fkvy68oBIyx2lNZcCSCW/wGoMd1fJ
         qBnqjW50tbhc57u+DxKm6lj7tgzKCKnH9Ki5KMrJMyCI5QQEe8KdoD/HnIfePk+1fW
         nFOIui2aLCxc5gpoMUqhyY0v086Bs+Y+RWi+hx+0PSEXeXdGyg2smYH5zc7taBbE3T
         rvzitDDefdRBmnPpvykjg/JmnNepJgIfpRj5c3Mrp2n0OUQyUfTS95x9YVuKrZDVSF
         Orxywajd/wTklVPvgMgZQyo9cjA6oW9AHo1inb9Txsn/nNfTdzFH8tkj7gNdx7ldfJ
         z5bXYW2ZXItqA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nRuK5-00DIeD-G7; Wed, 09 Mar 2022 11:17:41 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Reiji Watanabe <reijiw@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2] Documentation: KVM: Update documentation to indicate KVM is arm64-only
Date:   Wed,  9 Mar 2022 11:17:34 +0000
Message-Id: <164682464677.3740483.6091628911446790457.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220308172856.2997250-1-oupton@google.com>
References: <20220308172856.2997250-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com, ricarkol@google.com, alexandru.elisei@arm.com, kvm@vger.kernel.org, james.morse@arm.com, pbonzini@redhat.com, suzuki.poulose@arm.com, reijiw@google.com, linux-arm-kernel@lists.infradead.org, pshier@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Mar 2022 17:28:57 +0000, Oliver Upton wrote:
> KVM support for 32-bit ARM hosts (KVM/arm) has been removed from the
> kernel since commit 541ad0150ca4 ("arm: Remove 32bit KVM host
> support"). There still exists some remnants of the old architecture in
> the KVM documentation.
> 
> Remove all traces of 32-bit host support from the documentation. Note
> that AArch32 guests are still supported.

Applied to next, thanks!

[1/1] Documentation: KVM: Update documentation to indicate KVM is arm64-only
      commit: 3fbf4207dc6807bf98e3d32558753cfa5eac2fa1

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4D063C675
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 18:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbiK2Rbz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 12:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236633AbiK2Rbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 12:31:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0155D697CC
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:31:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A95FBB81894
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 17:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4E1C433C1;
        Tue, 29 Nov 2022 17:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669743109;
        bh=UVinZvTim66u4bD8bc5xOZyCcQ1X8BETh6hP7fGDBAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSGqNuRZSJi2DZAT5I2TcjbMZE/x9XmLA+z8A9P8IGRIuSYlKw9zJyOenjacAXnLz
         tNBq75DZ1OC1Zy+G0JU2WKeBmQszUHVCZ5N6LqVK+DnWhXcE2i0kZJdmxaOLClZJe3
         tYENqLz22d1Qx6iif/UjCs+BXDz6hvSDkETK3iARdvMHYpMC7/VHS4kU34eJgt+ooU
         XeIC+ksbjEbmiZu8yjRwjy5NjyIWF19/uxwx24oPX1+McinLXUJAkY82saEXxncT/i
         xNhEBocnLfBppcWb0dTPBa0fHKh7GuQcWYPDY5HDG0R3jKwLnWWUZRL4EeIYJ0Qebi
         YRSkSoXm6Lpcw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1p04SR-009PeW-37;
        Tue, 29 Nov 2022 17:31:47 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Sean Christopherson <seanjc@google.com>,
        Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 0/2] KVM: selftests: Enable access_tracking_perf_test for arm64
Date:   Tue, 29 Nov 2022 17:31:44 +0000
Message-Id: <166974309671.1909695.14457318687237410207.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221118211503.4049023-1-oliver.upton@linux.dev>
References: <20221118211503.4049023-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, james.morse@arm.com, oliver.upton@linux.dev, seanjc@google.com, gshan@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Nov 2022 21:15:01 +0000, Oliver Upton wrote:
> Small series to add support for arm64 to access_tracking_perf_test and
> correct a couple bugs along the way.
> 
> Tested on Ampere Altra w/ all supported guest modes.
> 
> v1 -> v2:
>  - Have perf_test_util indicate when to stop vCPU threads (Sean)
>  - Collect Gavin's R-b on the second patch. I left off Gavin's R-b on
>    the first patch as it was retooled.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: selftests: Have perf_test_util signal when to stop vCPUs
      commit: 9ec1eb1bcceec735fb3c9255cdcdbcc2acf860a0
[2/2] KVM: selftests: Build access_tracking_perf_test for arm64
      commit: 4568180411e0fb5613e217da1c693466e39b9c27

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE57B5F1B27
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 11:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiJAJSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Oct 2022 05:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiJAJSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Oct 2022 05:18:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567BB16BE37
        for <kvm@vger.kernel.org>; Sat,  1 Oct 2022 02:18:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1FBCB8009F
        for <kvm@vger.kernel.org>; Sat,  1 Oct 2022 09:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F69C433D6;
        Sat,  1 Oct 2022 09:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664615919;
        bh=2rogGG85HQXuD7WibeMAU+YBXmWNjHZnGMq/xPogXoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvjoaMOBB+Kv0oI1Nl9I1Ld8FdNCf8olrDdCMMiwlybjRtn/uQb9tKjfcCbxlajKP
         H/4YJpJtYRPiJ/6mEQEothYZBhzkPzalbnxiSfPJShr5DuARt4oGt9vSs+EQd20p9L
         FYX3xoy2PGCq0EeSTk9YdxCHPGmuIGDXiGzoX49iLyOwtV2kUYiuUU8umij0eUGyoe
         aeVK8FsBedk0AI/ndMGhcI8X7p9G1oeUXGDuvMabdcA3REehvuWEzTNwqGF6EUe+fO
         zsc1/YSHil3yVEx6JkybkDXlSkAUmwdahoI3rKUODIYbfw0fCqSpu2C8ZwXOkHXujp
         oFqPC9aZP3CGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oeYdp-00DwbH-8I;
        Sat, 01 Oct 2022 10:18:37 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH] KVM: arm64: Advertise new kvmarm mailing list
Date:   Sat,  1 Oct 2022 10:18:34 +0100
Message-Id: <166461590369.3900755.9396637331085967058.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221001091245.3900668-1-maz@kernel.org>
References: <20221001091245.3900668-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, will@kernel.org, alexandru.elisei@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 1 Oct 2022 10:12:45 +0100, Marc Zyngier wrote:
> As announced on the kvmarm list, we're moving the mailing list over
> to kvmarm@lists.linux.dev:
> 
> <quote>
> As you probably all know, the kvmarm mailing has been hosted on
> Columbia's machines for as long as the project existed (over 13
> years). After all this time, the university has decided to retire the
> list infrastructure and asked us to find a new hosting.
> 
> [...]

Applied to kvm-arm64/misc-6.1, thanks!

[1/1] KVM: arm64: Advertise new kvmarm mailing list
      commit: ac107abef197660c9db529fe550080ad07b46a67

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



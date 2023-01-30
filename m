Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6AC681939
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 19:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbjA3Sb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 13:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbjA3Sbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 13:31:37 -0500
Received: from out-67.mta0.migadu.com (out-67.mta0.migadu.com [IPv6:2001:41d0:1004:224b::43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B78E3D0BC
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 10:30:48 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675103446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lSCOsA3l6Whj8D78VA9+MZnM9iSGeCkaTGiJhbHGKtw=;
        b=Sa3NAHBJGd/Y8jLn840YqKwTtbKLBb+HGNVenj0ef9CdXK0Xb9SKXXkhxcppxxvIqj4Yrr
        H3CXzdNBfsFGrymB0haGCirRyhAMkg4+dQChXLey9s5GsPiufKF0sKUZf0W7IxtfJ8Dc42
        QJUhj+sMPki3unPUtmcmR08P9SMD19Q=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        D Scott Phillips <scott@os.amperecomputing.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/3] KVM: arm64: timer fixes and optimisations
Date:   Mon, 30 Jan 2023 18:30:34 +0000
Message-Id: <167510336269.1083059.9962999448888534799.b4-ty@linux.dev>
In-Reply-To: <20230112123829.458912-1-maz@kernel.org>
References: <20230112123829.458912-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 12:38:26 +0000, Marc Zyngier wrote:
> Having been busy on the NV front the past few weeks, I collected a
> small set of fixes/improvements that make sense even outside of NV.
> 
> The first one is an interesting fix (actually a regression introduced
> by the initial set of NV-related patches) reported by Scott and
> Ganapatrao, where we fail to recognise that a timer that has fired
> doesn't need to fire again. And again.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/3] KVM: arm64: Don't arm a hrtimer for an already pending timer
      https://git.kernel.org/kvmarm/kvmarm/c/4d74ecfa6458
[2/3] KVM: arm64: Reduce overhead of trapped timer sysreg accesses
      https://git.kernel.org/kvmarm/kvmarm/c/fc6ee952cf00
[3/3] KVM: arm64: timers: Don't BUG() on unhandled timer trap
      https://git.kernel.org/kvmarm/kvmarm/c/ba82e06cf7f4

--
Best,
Oliver

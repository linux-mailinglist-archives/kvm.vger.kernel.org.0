Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382E57376CA
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 23:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjFTVnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 17:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjFTVnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 17:43:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34ED21731
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 14:43:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD850611F9
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 21:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BB4C433C0;
        Tue, 20 Jun 2023 21:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687297380;
        bh=l48Dm1TfEbzOJ8sV+HhE8+XYX0C3SnXiIMtgQAyevmU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TSvJ/VoME26uYCi0pc4ZdE8+l3p35sx0y/FNhrv95QhZevaS0ni3HFe1hHGDe1ymD
         SgOBzy/sUI1z04uScROlqnqLHPrYo4es7f8BwgTa+1mqsknPMDMBVs4M3MQCZ1i2gg
         1sm88UmSVeSSvtGiP2qX0t1igAua+M1p5cop5/jp0qiTFwv5J891z0I3rj2orlja7E
         XswoONkAqqZWChZsXJTX+rfwBGRX5lw7hKIqO496RvLZ/m63MiLQrqXHMQRp1s7V9m
         rsF8YYeDWok/PnCo2vqarWNGupZquGpJ612zX63g/1W7zIvpgwooWKL/o4meiZuxqF
         IRJuPWW7FKgbw==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qBj7p-006tqR-Ji;
        Tue, 20 Jun 2023 22:42:57 +0100
MIME-Version: 1.0
Date:   Tue, 20 Jun 2023 22:42:57 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>,
        Sebastian Ott <sebott@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.4, take #4
In-Reply-To: <20230608155255.1850620-1-maz@kernel.org>
References: <20230608155255.1850620-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <dc80e87bbb6a09e7cd05569a1410ca07@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, mark.rutland@arm.com, nathan@kernel.org, oliver.upton@linux.dev, reijiw@google.com, sebott@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On 2023-06-08 16:52, Marc Zyngier wrote:
> Paolo,
> 
> Here's yet another batch of fixes, two of them addressing pretty
> recent regressions: GICv2 emulation on GICv3 was accidently killed,
> and the PMU rework needed some tweaking.
> 
> The last two patches address an annoying PMU (again) problem where
> the KVM requirements were never factored in when PMU counters were
> directly exposed to userspace. Reiji has been working on a fix, which
> is now readdy to be merged.

Can you confirm that you have this earmarked for 6.4 final?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...

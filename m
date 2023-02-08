Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384D868F491
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 18:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjBHRas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 12:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjBHRaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 12:30:46 -0500
Received: from out-33.mta1.migadu.com (out-33.mta1.migadu.com [95.215.58.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E21461BB
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 09:30:44 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675877443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QvQrmg6wMdC1WKfx+eApcx55+x46Ir0VSnGoGHBtgbQ=;
        b=igelcpubwwO9pfWh5R0+Ab7N3aBHvM5R0nLECQAC0W5Fl5fcUjYFfV/1s7TGaXV+LEh9fL
        Gzv280R807M/liQnWMTyXfBtJ+pWxm1EN2VeT9si8AvdllJ/or0hVjh4Y0yWD+pqfwPBWK
        aX/lB6wkT1ZIDEys+ftFCexR2Gw4A1o=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Fix non-kerneldoc comments
Date:   Wed,  8 Feb 2023 17:30:20 +0000
Message-Id: <167587739433.1104197.3306029180799805720.b4-ty@linux.dev>
In-Reply-To: <20230207094321.1238600-1-maz@kernel.org>
References: <20230207094321.1238600-1-maz@kernel.org>
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

On Tue, 7 Feb 2023 09:43:21 +0000, Marc Zyngier wrote:
> The robots amongts us have started spitting out irritating emails about
> random errors such as:
> 
> <quote>
> arch/arm64/kvm/arm.c:2207: warning: expecting prototype for Initialize Hyp().
> Prototype was for kvm_arm_init() instead
> </quote>
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Fix non-kerneldoc comments
      https://git.kernel.org/kvmarm/kvmarm/c/67d953d4d7be

--
Best,
Oliver

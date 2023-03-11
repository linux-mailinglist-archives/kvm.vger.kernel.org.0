Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8C06B6109
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 22:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCKVgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Mar 2023 16:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCKVgh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Mar 2023 16:36:37 -0500
Received: from out-43.mta0.migadu.com (out-43.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3F3474C7
        for <kvm@vger.kernel.org>; Sat, 11 Mar 2023 13:36:35 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678570592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CDvJmKwcQ6mlkbKDImbYY9XC6Sv7fyBerr0ue+LLiOk=;
        b=R8Bg2lPLvmq62VycO4YPWKiU/8+NozgJtqQPdRaRKapbpdc+OkYIa5ziQsd/+npNvaCypP
        FKZNag1uHriCnYCbsoEyjsHU1T8WiJHNp/aZ7hzWRGUzlk/P1GpleGTJMhqfeoiDpYL6VL
        v2Yfi5CwblF4zRltau1qmsL8iaQzkQs=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Joey Gouly <joey.gouly@arm.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2] KVM: arm64: timers: Convert per-vcpu virtual offset to a global value
Date:   Sat, 11 Mar 2023 21:36:15 +0000
Message-Id: <167857054887.1651970.3335887833625425284.b4-ty@linux.dev>
In-Reply-To: <20230224191640.3396734-1-maz@kernel.org>
References: <20230224191640.3396734-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Feb 2023 19:16:40 +0000, Marc Zyngier wrote:
> Having a per-vcpu virtual offset is a pain. It needs to be synchronized
> on each update, and expands badly to a setup where different timers can
> have different offsets, or have composite offsets (as with NV).
> 
> So let's start by replacing the use of the CNTVOFF_EL2 shadow register
> (which we want to reclaim for NV anyway), and make the virtual timer
> carry a pointer to a VM-wide offset.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: timers: Convert per-vcpu virtual offset to a global value
      https://git.kernel.org/kvmarm/kvmarm/c/47053904e182

--
Best,
Oliver

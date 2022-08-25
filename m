Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537D95A17F5
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 19:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbiHYR3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 13:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242346AbiHYR3c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 13:29:32 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82523A4041
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 10:29:31 -0700 (PDT)
Date:   Thu, 25 Aug 2022 10:29:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661448570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zdth8V+Yi5dhI0ba6Qeqn/SaZeHitUYg7hY4PMB4tjs=;
        b=JcVnmGrUDy+xU5oOhDVH5E7TR0ogrnEsL5NSG20fGR19XFIeXqFamJ8yN6v9E8Ba1/W2S0
        d4WodRFs9xgi7bnqqt7NWF8y/VyfKtA6tjciw1Edpu8L68Z8655kUY1itd+T5TtOp6Gf63
        VzcEvmvYg08INaBs/P7H5ocMm/ghoSU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/9] KVM: arm64: selftests: Have debug_version() use
 cpuid_get_ufield() helper
Message-ID: <YwexdqgGpN43qYyy@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-6-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825050846.3418868-6-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022 at 10:08:42PM -0700, Reiji Watanabe wrote:
> Change debug_version() to use cpuid_get_ufield() to extract DebugVer
> field from the AA64DFR0_EL1 register value.

Either squash this into the patch that adds the field accessors or
reorder it to immediately follow said patch.

aarch64_get_supported_page_sizes() is also due for a cleanup, as it
accesses the TGRANx fields of ID_AA64MMFR0_EL1.

--
Thanks,
Oliver

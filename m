Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2830F6E030C
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 02:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjDMAKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 20:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjDMAKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 20:10:53 -0400
Received: from out-19.mta1.migadu.com (out-19.mta1.migadu.com [95.215.58.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D469B3
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 17:10:52 -0700 (PDT)
Date:   Thu, 13 Apr 2023 00:10:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681344650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HCnXOj3LEZN88jyRNUFFg8GsQnQc0xXS8kokzqYep/c=;
        b=UpfE94B7TEW3IFsEyeibHj+V01F9ZaA3Vszow+MunLiFWuLApwY/7uwYcpi0WPcctwKCp2
        zo2MztaA2oCv0QBufKIMOV3ioHt500hShr2DVaQUS0WK9+h+BjH0NXaqg+xGehcu/bnUbp
        egFbBsranYjg2oXQuDxLgNXRy1jVA+k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 3/5] KVM: arm64: pkvm: Document the side effects of
 kvm_flush_dcache_to_poc()
Message-ID: <ZDdIh9xn8F/4S6Zm@linux.dev>
References: <20230408160427.10672-1-maz@kernel.org>
 <20230408160427.10672-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408160427.10672-4-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 08, 2023 at 05:04:25PM +0100, Marc Zyngier wrote:
> We rely on the presence of a DSB at the end of kvm_flush_dcache_to_poc()
> that, on top of ensuring completion of the cache clean, also covers
> the speculative page table walk started from EL1.
> 
> Document this dependency.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

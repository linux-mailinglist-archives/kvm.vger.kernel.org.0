Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491F67CBCF0
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 09:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbjJQH7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 03:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjJQH7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 03:59:08 -0400
Received: from out-194.mta0.migadu.com (out-194.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7575F93
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 00:59:06 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697529544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8wO3vSl0A/4QjUqKCic92wzMg8jg3zFJaYhjGnZWDLw=;
        b=Hl8QQsfnTSD3UC0+SFB3YuAzxdU0WT1NtWd3i5GRouPeGkG4Id4GdK2Dh29gTXxjWyrqcC
        uFiXIkDbWrFW5ac9Vm2E+M+JIcW8DxvuF1Pw+14k8IoOvJgdkY+7HoxtxdblRlpVQLezZP
        aywmcoMAK8/stZhtSPFmy6JuQXeJWBo=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: Move VTCR_EL2 into struct s2_mmu
Date:   Tue, 17 Oct 2023 07:58:45 +0000
Message-ID: <169752952219.1493360.11796864762419741247.b4-ty@linux.dev>
In-Reply-To: <20231012205108.3937270-1-maz@kernel.org>
References: <20231012205108.3937270-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Oct 2023 21:51:08 +0100, Marc Zyngier wrote:
> We currently have a global VTCR_EL2 value for each guest, even
> if the guest uses NV. This implies that the guest's own S2 must
> fit in the host's. This is odd, for multiple reasons:
> 
> - the PARange values and the number of IPA bits don't necessarily
>   match: you can have 33 bits of IPA space, and yet you can only
>   describe 32 or 36 bits of PARange
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Move VTCR_EL2 into struct s2_mmu
      https://git.kernel.org/kvmarm/kvmarm/c/bff4906ad66a

--
Best,
Oliver

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F64B683758
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjAaUSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjAaUSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:18:05 -0500
Received: from out-128.mta0.migadu.com (out-128.mta0.migadu.com [91.218.175.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43608EF8E
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:18:01 -0800 (PST)
Date:   Tue, 31 Jan 2023 20:17:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675196279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=skSmAFiSE0Dtjhlb7qVhiSxPiwmHcN8uiIj+E97KPGs=;
        b=hob2ahBgh81EXOzW/21K6FclEBEe0sNozI9s3tH5sajZiBz20jaAUbHK7dhpp6znM/qryH
        A4ljDdRyvRZyeVOmhmwzefAI1gIcWcCQD9MVQIaXZ5sgFqpzdmo4/D5UPxBtDWN50at4Hy
        GBg6MrEZjDfS0AOI0AlrjzyEdRcbxNI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v8 09/69] KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2
 to sane values
Message-ID: <Y9l3bofl5nMWy3wZ@google.com>
References: <20230131092504.2880505-1-maz@kernel.org>
 <20230131092504.2880505-10-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131092504.2880505-10-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 09:24:04AM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> The VMPIDR_EL2 and VPIDR_EL2 are architecturally UNKNOWN at reset, but
> let's be nice to a guest hypervisor behaving foolishly and reset these
> to something reasonable anyway.

Must we be so kind? :)

In all seriousness, I've found the hexspeak value of reset_unknown() to
be a rather useful debugging aid. And I can promise you that I'll use NV
to debug my own crap changes!

Any particular reason against just using reset_unknown()?

-- 
Thanks,
Oliver

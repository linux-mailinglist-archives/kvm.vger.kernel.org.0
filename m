Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BB1683919
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 23:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjAaWNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 17:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjAaWNp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 17:13:45 -0500
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [IPv6:2001:41d0:203:375::b2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC6037F2B
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 14:13:44 -0800 (PST)
Date:   Tue, 31 Jan 2023 22:13:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675203222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/5Py+tHDVAdvozZXzQG9bOiQCm0L8FtAYrYgynmVZMs=;
        b=MLcZSRScTPZaFF+XagTvRN/7meEv49CEuEJaFOvaAc/R+0tcuoRhsW/POmQcfgdG7ul2gx
        Yec6LFOihvIu0GwMgeumJ061c9ZA9JoJVa0Xms5UFRbTq1EG7ZG7v8aMrAXEmkBnS8AlgF
        fBWzWd7p8y3gg0TtbCl1XbcYQFEdbjk=
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
Subject: Re: [PATCH v8 00/69] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Message-ID: <Y9mSkdPFYotXWklH@google.com>
References: <20230131092504.2880505-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 09:23:55AM +0000, Marc Zyngier wrote:
> - I would suggest that the first 12 patches are in a mergeable
>   state. Only patch #2 hasn't been reviewed yet (because it is new),
>   but it doesn't affect anything non-NV and makes NV work. I really
>   want this in before CCA! :D

Sounds like a reasonable plan to me. I'm still chewing through these
patches, but after they've soaked for a bit on the mailing list could
you repost the set destined for immediate inclusion?

OTOH, if you feel like dropping another patch bomb for the hell of it I
can just grab the subset. But please don't :)

-- 
Thanks,
Oliver

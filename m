Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3990682C28
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 13:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjAaME2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 07:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjAaMET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 07:04:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E174DCDF
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 04:04:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 803C0B81C01
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C025C433EF;
        Tue, 31 Jan 2023 12:03:55 +0000 (UTC)
Date:   Tue, 31 Jan 2023 12:03:52 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
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
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v8 01/69] arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
Message-ID: <Y9kDqLqAwm9BR45J@arm.com>
References: <20230131092504.2880505-1-maz@kernel.org>
 <20230131092504.2880505-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131092504.2880505-2-maz@kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 09:23:56AM +0000, Marc Zyngier wrote:
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 6cfa6e3996cf..b7b0704e360e 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2553,9 +2553,14 @@
>  			protected: nVHE-based mode with support for guests whose
>  				   state is kept private from the host.
>  
> +			nested: VHE-based mode with support for nested
> +				virtualization. Requires at least ARMv8.3
> +				hardware.

So we can't have protected + nested at the same time? ;) (I guess once
you make the protected mode use VHE, this could be revisited)

In the hope that this averts another post of the series:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

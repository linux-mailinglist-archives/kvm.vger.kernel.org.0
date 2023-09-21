Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506AB7A90C9
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 04:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjIUCLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 22:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjIUCLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 22:11:49 -0400
Received: from out-224.mta0.migadu.com (out-224.mta0.migadu.com [91.218.175.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF309C2
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 19:11:43 -0700 (PDT)
Date:   Thu, 21 Sep 2023 02:11:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695262302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FW3p4VZIzuygrjsMUziYPALYuVKWOnunmv01SSe6GfA=;
        b=IDZSCRSwygs8bsWOJ77HlflG6hYQLi5RwZzud31RDVA2h87NoE+NQKWu9MzZzjbNqLH9+b
        4scDyVusgOwT4VG5EsvTvBzKYaveGm4M4S5WNW0B/5kzm8M/Pu8RU68FHwR3vXIn3JlvJk
        L7nbPllEEafHK3nvi+EHW8iEeF87PG4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Joey Gouly <joey.gouly@arm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2 00/11] KVM: arm64: Accelerate lookup of vcpus by MPIDR
 values (and other fixes)
Message-ID: <ZQumWVPQ3nxWjnON@linux.dev>
References: <20230920181731.2232453-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920181731.2232453-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Heh, "and other fixes" is quite the understatement :)

This looks good to me, only issues I've spotted so far are a few typos
that are easty enough to fix when I apply the series. I'll give it a
couple days for folks to have a look, but otherwise intend on picking
this up for 6.7.

On Wed, Sep 20, 2023 at 07:17:20PM +0100, Marc Zyngier wrote:
> This is a follow-up on [1], which contains the original patches, only
> augmented with a bunch of fixes after Zenghui pointed out that I was
> inadvertently fixing bugs (yay!), but that there were plenty more.
> 
> The core of the issue is that we tend to confuse vcpu_id with
> vcpu_idx. The first is a userspace-provided value, from which we
> derive the default MPIDR_EL1 value, while the second is something that
> used to represent the position in the vcpu array, and is now more of
> an internal identifier.

-- 
Thanks,
Oliver

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90947C7D50
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 07:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjJMF5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 01:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJMF47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 01:56:59 -0400
Received: from out-194.mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D92B7
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 22:56:58 -0700 (PDT)
Date:   Thu, 12 Oct 2023 22:56:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697176616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z9xYZluOWeINrDNYpCpjbMOAnY8xg0EvJ0cdWH95J9s=;
        b=Q0wsX4CebIiakLc6bFOP519WBkDO+Bo42cAVFI6AS97tqBM5SzpLOfh1lOKyO9m1GEfw3t
        cQZd7zcFTUF4jTOzBl1YNa9OZerqmqio9924KeMcfo+sVUaN30HtXIpv8Qtpsmim+FJZAZ
        v/x/bt9iLJTrJTAlmiZ3j5uJDXPka9c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Virtualise PMEVTYPER<n>_EL1.{NSU,NSK}
Message-ID: <ZSjcIpdOGpSEjpu8@linux.dev>
References: <20231013052901.170138-1-oliver.upton@linux.dev>
 <20231013052901.170138-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013052901.170138-3-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023 at 05:29:01AM +0000, Oliver Upton wrote:
> Suzuki noticed that KVM's PMU emulation is oblivious to the NSU and NSK
> event filter bits. On systems that have EL3 these bits modify the
> filter behavior in non-secure EL0 and EL1, respectively. Even though the
> kernel doesn't use these bits, it is entirely possible some other guest
> OS does.
> 
> Implement the behavior of NSU and NSK as it appears in the pseudocode.
> 
> Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

This is obviously EL0, not EL1. Assuing there's no respin, I intend to
fix up the shortlog after applying the series.

-- 
Thanks,
Oliver

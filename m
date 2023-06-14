Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FDF72FE50
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 14:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244475AbjFNMTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 08:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244480AbjFNMTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 08:19:31 -0400
Received: from out-60.mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A381F19AC
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 05:19:23 -0700 (PDT)
Date:   Wed, 14 Jun 2023 12:19:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686745161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ziofaVaQl/PXTbCpHDOShli8oK6ZMZB0tTbh4LFMVw=;
        b=SMO9mvVJcjYnn/P4bCdCBz3lAN2DM5NLKp00ItLTi14hFU1FT1BIpCk2cjrgwZl0xjZc1y
        /FofN9ECBlWroHu8kHgTRvxfS0gDNIC0hbKdjeyZrENf2Yu1A//GlFTw/U4bWtErShWk+6
        /898KScKPS3+hua5w8WLamES+SvnJhI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 0/7] KVM: arm64: Add support for FEAT_TLBIRANGE
Message-ID: <ZImwRAuSXcVt3UPV@linux.dev>
References: <20230606192858.3600174-1-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606192858.3600174-1-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On Tue, Jun 06, 2023 at 07:28:51PM +0000, Raghavendra Rao Ananta wrote:
> The series is based off of upstream v6.4-rc2, and applied David
> Matlack's common API for TLB invalidations[1] on top.

Sorry I didn't spot the dependency earlier, but this isn't helpful TBH.

David's series was partially applied, and what remains no longer cleanly
applies to the base you suggest. Independent of that, my *strong*
preference is that you just send out a series containing your patches as
well as David's. Coordinating dependent efforts is the only sane thing
to do. Also, those patches are 5 months old at this point which is
ancient history.

> [1]:
> https://lore.kernel.org/linux-arm-kernel/20230126184025.2294823-1-dmatlack@google.com/

-- 
Thanks,
Oliver

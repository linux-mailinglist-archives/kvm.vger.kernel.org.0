Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000F174F8AC
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 22:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjGKUDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 16:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjGKUDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 16:03:36 -0400
Received: from out-41.mta1.migadu.com (out-41.mta1.migadu.com [IPv6:2001:41d0:203:375::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4141BFD
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 13:03:05 -0700 (PDT)
Date:   Tue, 11 Jul 2023 20:02:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689105771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j7wpPKSWBw5SPfNkCzcIKlvtgTa7z9041l05WeQlyP8=;
        b=p2knxbGe3yEElrh6ORsVsqD09+UwWkdlHYdv7AwamdXCHy7HAb9LoSpOMkPv6hVmc+gct3
        7ye/cwJk4MZUKJ2suXw/hq0Rv0vmOlvqLc2I3OKwkXsGyuGuTspq1eNqEUHG4kNOMMKI/q
        yGVOr4mOfyPNt0fsCTPvRWpGWfLFf58=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Eric Auger <eauger@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: timers: Use CNTHCTL_EL2 when setting
 non-CNTKCTL_EL1 bits
Message-ID: <ZK21Z5WB6+bTjWA0@linux.dev>
References: <20230627140557.544885-1-maz@kernel.org>
 <d49225cb-3240-ea8e-11e6-b8ed30ce2fc8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d49225cb-3240-ea8e-11e6-b8ed30ce2fc8@redhat.com>
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

On Tue, Jul 11, 2023 at 12:35:00PM +0200, Eric Auger wrote:
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks for reviewing this Eric. I addressed your comments and picked up
your R-b when applying Marc's patch.

-- 
Thanks,
Oliver

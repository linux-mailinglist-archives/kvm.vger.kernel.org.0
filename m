Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68FB270E17C
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 18:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbjEWQNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 12:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjEWQNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 12:13:33 -0400
Received: from out-57.mta0.migadu.com (out-57.mta0.migadu.com [IPv6:2001:41d0:1004:224b::39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6BD1A6
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 09:13:23 -0700 (PDT)
Date:   Tue, 23 May 2023 16:13:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684858399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LhWcgX32vYTWdJdDtogaGEXVC2EELZrbClWPu0X5VOU=;
        b=j90Fdtqh4/lNPe6BpQZlyZo6Xt8nkV7lGmhof0FlhlQMWvYm3lAGH9zNr6/Xbv1DkXu/Bz
        vRYEjx23p4wCv7GFW8o8eJ7hh+Epinjv+frcETZK9wU+QArbvOV7eyjo8kKtwxfzDmhR9g
        tVMjsFXMQMwCA8YEqXGVN9UlbMXy2ic=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        steven.price@arm.com, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Handle MTE Set/Way CMOs
Message-ID: <ZGzmGxkL7x7+rokE@linux.dev>
References: <20230515204601.1270428-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515204601.1270428-1-maz@kernel.org>
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

On Mon, May 15, 2023 at 09:45:59PM +0100, Marc Zyngier wrote:
> When the MTE support was added, it seens the handling of MTE Set/Way
> was ommited, meaning that the guest will get an UNDEF if it tries to
> do something that is quite stupid, but still allowed by the
> architecture...
> 
> Found by inspection while writting the trap support for NV.
> 
> Marc Zyngier (2):
>   arm64: Add missing Set/Way CMO encodings
>   KVM: arm64: Handle trap of tagged Set/Way CMOs

For the series:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

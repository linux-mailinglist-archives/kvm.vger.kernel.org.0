Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80ABC6068B1
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 21:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJTTMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 15:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJTTMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 15:12:34 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3321FB7A5
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:12:33 -0700 (PDT)
Date:   Thu, 20 Oct 2022 22:12:29 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666293151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8UxLxujHJ2w8hcXZyfAGTDxrJz5/OfrfjzTusuwGxQc=;
        b=fuHgHLIO7XBKt9+16Uvpzi8QrDhJC54rr/WDX57lVPW/NcnAJwrHJDpueIaZQRPhFdsRX+
        MASPrtpseKq2znAFCqYchHuUYlNRUSQNTa/FDnYpCkBrD/VRxwvLJPiHwG0T1DAo6w0mpy
        OV6oQlpoeCfaDOjHFcW3oGSDia39z5E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v2 5/9] KVM: arm64: selftests: Stop unnecessary test
 stage tracking of debug-exceptions
Message-ID: <Y1GdnaxoFCk+8Mhn@google.com>
References: <20221020054202.2119018-1-reijiw@google.com>
 <20221020054202.2119018-6-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020054202.2119018-6-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022 at 10:41:58PM -0700, Reiji Watanabe wrote:
> Currently, debug-exceptions test unnecessarily tracks some test stages
> using GUEST_SYNC().  The code for it needs to be updated as test cases
> are added or removed.  Stop doing the unnecessary stage tracking,
> as they are not so useful and are a bit pain to maintain.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>

Much cleaner!

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver

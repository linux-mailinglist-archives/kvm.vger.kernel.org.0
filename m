Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD67E6068AF
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 21:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiJTTLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 15:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJTTLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 15:11:20 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869691F9A20
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:11:19 -0700 (PDT)
Date:   Thu, 20 Oct 2022 22:11:15 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666293078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o0ijBOoIwkeAC+4P2wSY2PPVmhiuBD8dwNZ6MmnDsjw=;
        b=rkksVbp2MoNLbNuE2/VH9H075rIDlpGXjs4yiOuHdJDveZrAbGEYF5AS26zLrp3NRwv4u+
        94xaNFW6xx4HxzHn+cRlF3fToiKFMRzIXvqY3SmkCJLTOpLFPMwcGr1GeI1UsJb3pllEAg
        zGKYDZ90o5X6aygpHMn4zGhO2692KZk=
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
Subject: Re: [PATCH v2 3/9] KVM: arm64: selftests: Remove the hard-coded
 {b,w}pn#0 from debug-exceptions
Message-ID: <Y1GdU5891M5lAqvH@google.com>
References: <20221020054202.2119018-1-reijiw@google.com>
 <20221020054202.2119018-4-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020054202.2119018-4-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022 at 10:41:56PM -0700, Reiji Watanabe wrote:
> Remove the hard-coded {break,watch}point #0 from the guest_code() in
> debug-exceptions to allow {break,watch}point number to be specified.
> Change reset_debug_state() to zeroing all dbg{b,w}{c,v}r_el0 registers
> so that guest_code() can use the function to reset those registers
> even when non-zero {break,watch}points are specified for guest_code().
> Subsequent patches will add test cases for non-zero {break,watch}points.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver

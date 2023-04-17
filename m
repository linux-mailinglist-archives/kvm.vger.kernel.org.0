Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3B16E4E18
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 18:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDQQR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 12:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjDQQR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 12:17:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB50524A;
        Mon, 17 Apr 2023 09:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AED96119F;
        Mon, 17 Apr 2023 16:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1E3C433EF;
        Mon, 17 Apr 2023 16:17:51 +0000 (UTC)
Date:   Mon, 17 Apr 2023 17:17:47 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/7] arm64: tlb: Refactor the core flush algorithm of
 __flush_tlb_range
Message-ID: <ZD1xK7aKyBgGsQiF@arm.com>
References: <20230414172922.812640-1-rananta@google.com>
 <20230414172922.812640-2-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414172922.812640-2-rananta@google.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 14, 2023 at 05:29:16PM +0000, Raghavendra Rao Ananta wrote:
> Currently, the core TLB flush functionality of __flush_tlb_range()
> hardcodes vae1is (and variants) for the flush operation. In the
> upcoming patches, the KVM code reuses this core algorithm with
> ipas2e1is for range based TLB invalidations based on the IPA.
> Hence, extract the core flush functionality of __flush_tlb_range()
> into its own macro that accepts an 'op' argument to pass any
> TLBI operation, such that other callers (KVM) can benefit.
> 
> No functional changes intended.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

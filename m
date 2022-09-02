Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D76D5AB3F7
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 16:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbiIBOq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 10:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236918AbiIBOqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 10:46:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496111829FC
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 07:06:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F58C621D3
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 14:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1319C433D7;
        Fri,  2 Sep 2022 14:05:26 +0000 (UTC)
Date:   Fri, 2 Sep 2022 15:05:23 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v3 0/7] KVM: arm64: permit MAP_SHARED mappings with MTE
 enabled
Message-ID: <YxINo9qLJkrVk9/J@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810193033.1090251-1-pcc@google.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 12:30:26PM -0700, Peter Collingbourne wrote:
> I rebased Catalin's series onto -next, addressed the issues that I
> identified in the review and added the proposed userspace enablement
> patches after the series.
> 
> [1] https://lore.kernel.org/all/20220705142619.4135905-1-catalin.marinas@arm.com/
> 
> Catalin Marinas (3):
>   arm64: mte: Fix/clarify the PG_mte_tagged semantics
>   KVM: arm64: Simplify the sanitise_mte_tags() logic
>   arm64: mte: Lock a page for MTE tag initialisation
> 
> Peter Collingbourne (4):
>   mm: Add PG_arch_3 page flag

BTW, I rebased these for patches on top of 6.0-rc3 and hopefully
addressed the review comments. I pushed them here:

git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux devel/mte-pg-flags

You may have rebased them already but just in case you haven't, feel
free to pick them up from the above branch.

-- 
Catalin

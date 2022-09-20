Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B079B5BEA5F
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 17:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiITPkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 11:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiITPkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 11:40:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD2B2982B
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 08:39:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 929B1B82AC6
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 15:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253E9C433D7;
        Tue, 20 Sep 2022 15:39:50 +0000 (UTC)
Date:   Tue, 20 Sep 2022 16:39:47 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kernel test robot <lkp@intel.com>,
        Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kbuild-all@lists.01.org, Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v3 3/7] mm: Add PG_arch_3 page flag
Message-ID: <Yynewxzc6Zy8ls0N@arm.com>
References: <20220810193033.1090251-4-pcc@google.com>
 <202208111500.62e0Bl2l-lkp@intel.com>
 <YxDy+zFasbAP7Yrq@arm.com>
 <YxYrgyybBMUqFswq@arm.com>
 <878rmfkzbu.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rmfkzbu.wl-maz@kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 19, 2022 at 07:12:53PM +0100, Marc Zyngier wrote:
> On Mon, 05 Sep 2022 18:01:55 +0100,
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > Peter, please let me know if you want to pick this series up together
> > with your other KVM patches. Otherwise I can post it separately, it's
> > worth merging it on its own as it clarifies the page flag vs tag setting
> > ordering.
> 
> I'm looking at queuing this, but I'm confused by this comment. Do I
> need to pick this as part of the series? Or is this an independent
> thing (my hunch is that it is actually required not to break other
> architectures...).

This series series (at least the first patches) won't apply cleanly on
top of 6.0-rc1 and, of course, we shouldn't break other architectures. I
can repost the whole series but I don't have the setup to test the
MAP_SHARED KVM option (unless Peter plans to post it soon).

-- 
Catalin

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598395AB32F
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 16:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbiIBOQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 10:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237178AbiIBOPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 10:15:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC82D4F64
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 06:42:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AFFCB82AC5
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 13:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C0EC433C1;
        Fri,  2 Sep 2022 13:41:51 +0000 (UTC)
Date:   Fri, 2 Sep 2022 14:41:47 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v3 5/7] KVM: arm64: unify the tests for VMAs in memslots
 when MTE is enabled
Message-ID: <YxIIG4SNfiqT38kS@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-6-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810193033.1090251-6-pcc@google.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 12:30:31PM -0700, Peter Collingbourne wrote:
> Previously we allowed creating a memslot containing a private mapping that
> was not VM_MTE_ALLOWED, but would later reject KVM_RUN with -EFAULT. Now
> we reject the memory region at memslot creation time.
> 
> Since this is a minor tweak to the ABI (a VMM that created one of
> these memslots would fail later anyway), no VMM to my knowledge has
> MTE support yet, and the hardware with the necessary features is not
> generally available, we can probably make this ABI change at this point.

I don't think that's a noticeable ABI change. As you said, such VMs
would fail later anyway when trying to access such page.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

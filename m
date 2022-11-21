Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6F5632BBD
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 19:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiKUSJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 13:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKUSJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 13:09:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4930093CF0
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 10:09:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F12BDB81283
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 18:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11659C433C1;
        Mon, 21 Nov 2022 18:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669054147;
        bh=/7KHXu25uYdxptbYApPiI4X6tmxB+JZaBclz27zxScA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s/GpyKDjXOFYp5ugSCAdXo1NhlB2IPARJM3jRaplMsXTLpV8lxciaQnUUyxQquulK
         KzEe49FCFaD8LuZy5w40TIz8akrFGG53YphhnwI5jTjvzL+/8C9YHEIelrPhT2xilp
         CFcT+oCqfydITYFEx1ZK3OI+iuL03YCEyIygLd19LEeKPQQ8m2HuC9LebUr+2cA4i0
         /MoOm0DInv0d9t1r/8qvWSt0x+gJwsPr+mi9mVlqj1ORRgENAhZmHOZfClgfcbHTBE
         XmnydxyEqRfCurqpHdYQZDorzFQqvAhcZmuPCp/ecd0IWnHVtsC41IQui39XQPk8/f
         yyvZa3qp0B0/g==
Date:   Mon, 21 Nov 2022 18:09:02 +0000
From:   Will Deacon <will@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 0/3] KVM: arm64: Fixes for parallel faults series
Message-ID: <20221121180901.GC7645@willie-the-truck>
References: <20221118182222.3932898-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118182222.3932898-1-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 18, 2022 at 06:22:19PM +0000, Oliver Upton wrote:
> Small set of fixes for the parallel faults series. Most importantly,
> stop taking the RCU read lock for walking hyp stage-1. For the sake of
> consistency, take a pointer to kvm_pgtable_walker in
> kvm_dereference_pteref() as well.
> 
> Tested on an Ampere Altra system with kvm-arm.mode={nvhe,protected} and
> lockdep. Applies on top of the parallel faults series picked up last
> week.
> 
> v3: https://lore.kernel.org/kvmarm/20221116165655.2649475-1-oliver.upton@linux.dev/
> 
> v3 -> v4:
>  - Return an error instead of WARN() in hyp for shared walks (Will)

For the series:

Acked-by: Will Deacon <will@kernel.org>

Thanks!

Will

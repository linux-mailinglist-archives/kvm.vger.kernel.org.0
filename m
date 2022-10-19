Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782C9604633
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 15:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiJSNA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 09:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbiJSMyM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 08:54:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E011107AA5
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 05:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C5386185A
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 12:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61E0C433C1;
        Wed, 19 Oct 2022 12:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666182964;
        bh=P7FFwg/Wkr7el57I+MGdWjkTZOf1uSf+z9lZS/OE+e0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=El031p3Pncx0SEsDrncIw7CxIevMPN+dkSxrxG3jwDIGiorMNCLptGxzrexmxtXac
         MZL0jhBtoJYy8eBtFcM8z2MzNwvCH+XzMUx6MBbN7hcpEb4mHxtuDAWaxdbR8VsoQ0
         Hogd4CRnbLY8lUVBOfqY2vH/MQlU6LXRDpnejv5O2KNdtCSzyYVcBIsR5fMocQPzqV
         YPu5MMEU6hjM66/9Q8f1FLgOGWBqozNSXgCwjWDyvAWIqzkeoAYC1J5S70Oyt5gRVp
         ZITilSl2+i2HTi1MusZsYVassSY7k9/XWqYz2UNWL1nnaa7fHbvLIEN7eXmE7Xd0Ec
         0eoS6B/EwgU1Q==
Date:   Wed, 19 Oct 2022 13:35:58 +0100
From:   Will Deacon <will@kernel.org>
To:     Quentin Perret <qperret@google.com>
Cc:     kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <20221019123557.GA4220@willie-the-truck>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
 <Y07CoADQH4v7cY5Y@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y07CoADQH4v7cY5Y@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 18, 2022 at 03:13:36PM +0000, Quentin Perret wrote:
> On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> > +/* Maximum number of protected VMs that can be created. */
> > +#define KVM_MAX_PVMS 255
> 
> Nit: I think that limit will apply to non-protected VMs too, at least
> initially, so it'd be worth rewording the comment.

Good point, I've changed this to:

  /* Maximum number of VMs that can co-exist under pKVM. */

Will

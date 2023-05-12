Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC6C6FFDE5
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 02:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239487AbjELAaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 20:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjELAaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 20:30:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44953559F;
        Thu, 11 May 2023 17:30:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA9026528F;
        Fri, 12 May 2023 00:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A52C433D2;
        Fri, 12 May 2023 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683851409;
        bh=Bar/gbz5y7H6MCxXk1BjJQOT97CODrJS8QsqcZqpX18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aO5H0ySdicNCCFht8WVr1bWJZeGDW0NaQ+d2loOJJldlQIoOu7As44DMPZgrR1Thu
         5Mdh714y8XIHQQwuTv9NKwkf6McitMrk4g8irqQeH7hlbgUX8ep7DWjSYgw9AOQvK4
         TQPNq8zWj/42IJfzOce+L4Y+N8qenfNrqid2B8kvxSpwfrkxir70ael7p8vRfn7Q83
         +0Pa6TKarF25ZIEWkXJiShTqnufG+KAs9Vw/40ew5vmCkXR6kn+vQ9pI6yA4FtzhXU
         jKTxkQHoghGi2XJjs34jKhs73+JEfSMk9/yzmf5nDa0wXg7YTVxpHd7mLhZdlDumAI
         BPnZ+clxXe27A==
Date:   Thu, 11 May 2023 20:30:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 6.2 0/5] KVM CR0.WP series backport
Message-ID: <ZF2IkDVh8BMC1am0@sashalap>
References: <20230508154457.29956-1-minipli@grsecurity.net>
 <ZF2HWz7h032Z+X3t@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZF2HWz7h032Z+X3t@sashalap>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 08:24:59PM -0400, Sasha Levin wrote:
>On Mon, May 08, 2023 at 05:44:52PM +0200, Mathias Krause wrote:
>>This is a backport of the CR0.WP KVM series[1] to Linux v6.2. All
>>commits applied either clean or with only minor changes needed to
>>account for missing prerequisite patches, e.g. the lack of a
>>kvm_is_cr0_bit_set() helper for patch 5 or the slightly different
>>surrounding context in patch 4 (__always_inline vs. plain inline for
>>to_kvm_vmx()).
>>
>>I used 'ssdd 10 50000' from rt-tests[2] as a micro-benchmark, running on
>>a grsecurity L1 VM. Below table shows the results (runtime in seconds,
>>lower is better):
>>
>>                       legacy     TDP    shadow
>>   Linux v6.2.10        7.61s    7.98s    68.6s
>>   + patches            3.37s    3.41s    70.2s
>>
>>The KVM unit test suite showed no regressions.
>>
>>Please consider applying.
>
>On our end waiting for ack from the KVM maintainers.

Just saw Sean's reply. Queueing up, thanks!

-- 
Thanks,
Sasha

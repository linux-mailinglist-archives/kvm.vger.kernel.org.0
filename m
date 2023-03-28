Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968BC6CBA58
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 11:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjC1JTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 05:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbjC1JTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 05:19:14 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB457FB
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 02:19:12 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8627C14;
        Tue, 28 Mar 2023 02:19:56 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9416D3F73F;
        Tue, 28 Mar 2023 02:19:11 -0700 (PDT)
Message-ID: <850ad3ea-068a-4dd6-b549-8daf7fadf737@arm.com>
Date:   Tue, 28 Mar 2023 10:19:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 06/11] KVM: arm64: Refactor hvc filtering to support
 different actions
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
 <20230320221002.4191007-7-oliver.upton@linux.dev>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230320221002.4191007-7-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/2023 22:09, Oliver Upton wrote:
> KVM presently allows userspace to filter guest hypercalls with bitmaps
> expressed via pseudo-firmware registers. These bitmaps have a narrow
> scope and, of course, can only allow/deny a particular call. A
> subsequent change to KVM will introduce a generalized UAPI for filtering
> hypercalls, allowing functions to be forwarded to userspace.
> 
> Refactor the existing hypercall filtering logic to make room for more
> than two actions. While at it, generalize the function names around
> SMCCC as it is the basis for the upcoming UAPI.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>



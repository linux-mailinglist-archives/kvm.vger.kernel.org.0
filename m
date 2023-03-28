Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA4B6CB99C
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 10:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjC1Ikn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 04:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjC1IkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 04:40:15 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0147524C
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 01:40:12 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3BC0C14;
        Tue, 28 Mar 2023 01:40:56 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A34003F73F;
        Tue, 28 Mar 2023 01:40:11 -0700 (PDT)
Message-ID: <f377ea4f-5688-eecc-0713-b910757d3a93@arm.com>
Date:   Tue, 28 Mar 2023 09:40:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 04/11] KVM: arm64: Rename SMC/HVC call handler to reflect
 reality
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
 <20230320221002.4191007-5-oliver.upton@linux.dev>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230320221002.4191007-5-oliver.upton@linux.dev>
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
> KVM handles SMCCC calls from virtual EL2 that use the SMC instruction
> since commit bd36b1a9eb5a ("KVM: arm64: nv: Handle SMCs taken from
> virtual EL2"). Thus, the function name of the handler no longer reflects
> reality.
> 
> Normalize the name on SMCCC, since that's the only hypercall interface
> KVM supports in the first place. No fuctional change intended.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B303F0473
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 15:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbhHRNSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 09:18:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233722AbhHRNSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 09:18:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 968B76108F;
        Wed, 18 Aug 2021 13:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629292679;
        bh=JlUFeNxsEk8ffbZ4STeULEr4uHA+Xv6pEtdyqf9Ea4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ReG+ER0rC7KxI+2srUFAOcPJZJSz3c2oz48BBu46iYswAb9jZFOWxXhLuKxAcimIX
         DjbXuVbs8PMt+XwbaUqcZD7T8/mgqBOs5TZvwBceHd2LO1wZZfjpd8iSPertpCTwdH
         L/mbn4Z4XrMNrCdgPRzjhkwKKRoWzMwHgdZGPW7XsZD2UBThC4EoObciO2qK3TjvH1
         qpWP/Um3VYghocI24UCPlREOoXOBa3MBU9UAaKJXOCHsoXjakHbIRQI7CqiFkSHys7
         b+Z89GvnyDj0Ck+DWAdb8S8m/90mkzktvSoEGyjEMADHbxESbiSxU8kX2kbAPD1ieW
         /LqDqCl5W1irA==
Date:   Wed, 18 Aug 2021 14:17:53 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v4 07/15] KVM: arm64: Keep mdcr_el2's value as set by
 __init_el2_debug
Message-ID: <20210818131752.GE14107@willie-the-truck>
References: <20210817081134.2918285-1-tabba@google.com>
 <20210817081134.2918285-8-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817081134.2918285-8-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021 at 09:11:26AM +0100, Fuad Tabba wrote:
> __init_el2_debug configures mdcr_el2 at initialization based on,
> among other things, available hardware support. Trap deactivation
> doesn't check that, so keep the initial value.
> 
> No functional change intended. However, the value of mdcr_el2
> might be different after deactivating traps than it was before
> this patch.

I think this sentence is very confusing, so I'd remove it. I also don't
think it's correct, as the EL2 initialisation code only manipulates the
bits which are being masked here.

So with that sentence removed:

Acked-by: Will Deacon <will@kernel.org>

Will

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE5FE377A
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 18:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436642AbfJXQKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 12:10:25 -0400
Received: from foss.arm.com ([217.140.110.172]:55444 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436636AbfJXQKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 12:10:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84FEF28;
        Thu, 24 Oct 2019 09:10:11 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 63EF73F71F;
        Thu, 24 Oct 2019 09:10:10 -0700 (PDT)
Subject: Re: [PATCH v2 3/5] arm64: KVM: Disable EL1 PTW when invalidating S2
 TLBs
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20191019095521.31722-1-maz@kernel.org>
 <20191019095521.31722-4-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <f7b0fa68-7e21-26fb-96f3-9c471e6cbe54@arm.com>
Date:   Thu, 24 Oct 2019 17:10:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191019095521.31722-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 19/10/2019 10:55, Marc Zyngier wrote:
> When erratum 1319367 is being worked around, special care must
> be taken not to allow the page table walker to populate TLBs
> while we have the stage-2 translation enabled (which would otherwise
> result in a bizare mix of the host S1 and the guest S2).
> 
> We enforce this by setting TCR_EL1.EPD{0,1} before restoring the S2
> configuration, and clear the same bits after having disabled S2.

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James

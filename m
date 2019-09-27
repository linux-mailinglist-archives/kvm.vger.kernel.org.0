Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F759C0140
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 10:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfI0Idw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 04:33:52 -0400
Received: from foss.arm.com ([217.140.110.172]:45422 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbfI0Idw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 04:33:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5F97337;
        Fri, 27 Sep 2019 01:33:51 -0700 (PDT)
Received: from dawn-kernel.cambridge.arm.com (unknown [10.1.197.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C66FD3F739;
        Fri, 27 Sep 2019 01:33:50 -0700 (PDT)
Subject: Re: [PATCH 1/5] arm64: Add ARM64_WORKAROUND_1319367 for all A57 and
 A72 versions
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20190925111941.88103-1-maz@kernel.org>
 <20190925111941.88103-2-maz@kernel.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <403cb5f2-b55a-0e5e-f228-954b3b746334@arm.com>
Date:   Fri, 27 Sep 2019 09:33:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190925111941.88103-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25/09/2019 12:19, Marc Zyngier wrote:
> Rework the EL2 vector hardening that is only selected for A57 and A72
> so that the table can also be used for ARM64_WORKAROUND_1319367.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4641C4E9A6
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 15:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfFUNle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 09:41:34 -0400
Received: from foss.arm.com ([217.140.110.172]:60870 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbfFUNle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 09:41:34 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A0EB344;
        Fri, 21 Jun 2019 06:41:34 -0700 (PDT)
Received: from [192.168.0.21] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0174D3F575;
        Fri, 21 Jun 2019 06:41:31 -0700 (PDT)
Subject: Re: [PATCH 03/59] arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
To:     marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, christoffer.dall@arm.com,
        dave.martin@arm.com, jintack@cs.columbia.edu,
        julien.thierry@arm.com, james.morse@arm.com
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-4-marc.zyngier@arm.com>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <6c868785-55b6-7e3f-375c-8c8494af1dd8@arm.com>
Date:   Fri, 21 Jun 2019 14:44:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-4-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/21/2019 10:37 AM, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> Add a new ARM64_HAS_NESTED_VIRT feature to indicate that the
> CPU has the ARMv8.3 nested virtualization capability.
> 
> This will be used to support nested virtualization in KVM.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>


Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

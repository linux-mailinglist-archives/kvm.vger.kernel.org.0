Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B60D21D1A5
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 10:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgGMI0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 04:26:01 -0400
Received: from foss.arm.com ([217.140.110.172]:46876 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgGMI0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 04:26:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19C2330E;
        Mon, 13 Jul 2020 01:26:01 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 088D83F887;
        Mon, 13 Jul 2020 01:25:59 -0700 (PDT)
Subject: Re: [PATCH 0/5] KVM: arm64: pvtime: Fixes and a new cap
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org
References: <20200711100434.46660-1-drjones@redhat.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <81e3cf61-afa6-134b-e532-419d34349b04@arm.com>
Date:   Mon, 13 Jul 2020 09:25:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200711100434.46660-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/2020 11:04, Andrew Jones wrote:
> The first three patches in the series are fixes that come from testing
> and reviewing pvtime code while writing the QEMU support (I'll reply
> to this mail with a link to the QEMU patches after posting - which I'll
> do shortly). The last patch is only a convenience for userspace, and I
> wouldn't be heartbroken if it wasn't deemed worth it. The QEMU patches
> I'll be posting are currently written without the cap. However, if the
> cap is accepted, then I'll change the QEMU code to use it.

Thanks for this, you've already got my r-b on the last two patches. For 
the others:

Reviewed-by: Steven Price <steven.price@arm.com>

> Thanks,
> drew
> 
> Andrew Jones (5):
>    KVM: arm64: pvtime: steal-time is only supported when configured
>    KVM: arm64: pvtime: Fix potential loss of stolen time
>    KVM: arm64: pvtime: Fix stolen time accounting across migration
>    KVM: Documentation minor fixups
>    arm64/x86: KVM: Introduce steal-time cap
> 
>   Documentation/virt/kvm/api.rst    | 20 ++++++++++++++++----
>   arch/arm64/include/asm/kvm_host.h |  2 +-
>   arch/arm64/kvm/arm.c              |  3 +++
>   arch/arm64/kvm/pvtime.c           | 31 +++++++++++++++----------------
>   arch/x86/kvm/x86.c                |  3 +++
>   include/linux/kvm_host.h          | 19 +++++++++++++++++++
>   include/uapi/linux/kvm.h          |  1 +
>   7 files changed, 58 insertions(+), 21 deletions(-)
> 


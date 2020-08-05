Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9FD23D144
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgHET61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:58:27 -0400
Received: from foss.arm.com ([217.140.110.172]:33258 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgHEQnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 12:43:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FC041045;
        Wed,  5 Aug 2020 08:37:23 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DE223F7D7;
        Wed,  5 Aug 2020 08:37:22 -0700 (PDT)
Subject: Re: [PATCH v2 0/6] KVM: arm64: pvtime: Fixes and a new cap
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, pbonzini@redhat.com
References: <20200804170604.42662-1-drjones@redhat.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <c5dbe385-d0d5-94f5-5e8a-620e439e482b@arm.com>
Date:   Wed, 5 Aug 2020 16:37:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200804170604.42662-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/08/2020 18:05, Andrew Jones wrote:
> v2:
>    - ARM_SMCCC_HV_PV_TIME_FEATURES now also returns SMCCC_RET_NOT_SUPPORTED
>      when steal time is not supported
>    - Added READ_ONCE() for the run_delay read
>    - Reworked kvm_put/get_guest to not require type as a parameter
>    - Added some more text to the documentation for KVM_CAP_STEAL_TIME
>    - Enough changed that I didn't pick up Steven's r-b's

Feel free to add my r-b's - the changes all look fine to me.

Thanks,

Steve

> 
> The first four patches in the series are fixes that come from testing
> and reviewing pvtime code while writing the QEMU support[*]. The last
> patch is only a convenience for userspace, and I wouldn't be heartbroken
> if it wasn't deemed worth it. The QEMU patches are currently written
> without the cap. However, if the cap is accepted, then I'll change the
> QEMU code to use it.
> 
> Thanks,
> drew
> 
> [*] https://lists.gnu.org/archive/html/qemu-devel/2020-07/msg03856.html
>      (a v2 of this series will also be posted shortly)
> 
> Andrew Jones (6):
>    KVM: arm64: pvtime: steal-time is only supported when configured
>    KVM: arm64: pvtime: Fix potential loss of stolen time
>    KVM: arm64: Drop type input from kvm_put_guest
>    KVM: arm64: pvtime: Fix stolen time accounting across migration
>    KVM: Documentation: Minor fixups
>    arm64/x86: KVM: Introduce steal-time cap
> 
>   Documentation/virt/kvm/api.rst    | 22 ++++++++++++++++++----
>   arch/arm64/include/asm/kvm_host.h |  2 +-
>   arch/arm64/kvm/arm.c              |  3 +++
>   arch/arm64/kvm/pvtime.c           | 29 +++++++++++++----------------
>   arch/x86/kvm/x86.c                |  3 +++
>   include/linux/kvm_host.h          | 31 ++++++++++++++++++++++++++-----
>   include/uapi/linux/kvm.h          |  1 +
>   7 files changed, 65 insertions(+), 26 deletions(-)
> 


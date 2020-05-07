Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB8D1C9671
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 18:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgEGQ0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 12:26:10 -0400
Received: from foss.arm.com ([217.140.110.172]:35230 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbgEGQ0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 12:26:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A4B21FB;
        Thu,  7 May 2020 09:26:10 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0701C3F71F;
        Thu,  7 May 2020 09:26:07 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
Subject: Re: [PATCH 09/26] KVM: arm64: vgic-v3: Take cpu_if pointer directly
 instead of vcpu
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-10-maz@kernel.org>
Message-ID: <3174eaad-7d8d-0c52-d71c-afc6b991b636@arm.com>
Date:   Thu, 7 May 2020 17:26:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200422120050.3693593-10-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc, Christoffer,

On 22/04/2020 13:00, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> If we move the used_lrs field to the version-specific cpu interface
> structure, the following functions only operate on the struct
> vgic_v3_cpu_if and not the full vcpu:
> 
>   __vgic_v3_save_state
>   __vgic_v3_restore_state
>   __vgic_v3_activate_traps
>   __vgic_v3_deactivate_traps
>   __vgic_v3_save_aprs
>   __vgic_v3_restore_aprs
> 
> This is going to be very useful for nested virt, 

... because you don't need to consider whether the vcpu is running in vEL2?


> so move the used_lrs
> field and change the prototypes and implementations of these functions to
> take the cpu_if parameter directly.


> No functional change.

Looks like no change!

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James


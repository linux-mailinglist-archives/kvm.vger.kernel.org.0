Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5C31B59F4
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 13:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgDWLFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 07:05:19 -0400
Received: from foss.arm.com ([217.140.110.172]:37514 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbgDWLFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 07:05:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2BDFC31B;
        Thu, 23 Apr 2020 04:05:19 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D22623F68F;
        Thu, 23 Apr 2020 04:05:17 -0700 (PDT)
Subject: Re: [PATCH v3 4/6] KVM: arm: vgic-v2: Only use the virtual state when
 userspace accesses pending bits
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Julien Grall <julien@xen.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200422161844.3848063-1-maz@kernel.org>
 <20200422161844.3848063-5-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <e5297164-b225-37d5-0ffc-b1e2e0227608@arm.com>
Date:   Thu, 23 Apr 2020 12:05:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200422161844.3848063-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 22/04/2020 17:18, Marc Zyngier wrote:
> There is no point in accessing the HW when writing to any of the
> ISPENDR/ICPENDR registers from userspace, as only the guest should
> be allowed to change the HW state.
> 
> Introduce new userspace-specific accessors that deal solely with
> the virtual state. Note that the API differs from that of GICv3,
> where userspace exclusively uses ISPENDR to set the state. Too
> bad we can't reuse it.

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C351ADC0E
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 13:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730236AbgDQLR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 07:17:26 -0400
Received: from foss.arm.com ([217.140.110.172]:50022 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730183AbgDQLRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 07:17:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72186C14;
        Fri, 17 Apr 2020 04:17:25 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 004173F6C4;
        Fri, 17 Apr 2020 04:17:23 -0700 (PDT)
Subject: Re: [PATCH v2 3/6] KVM: arm: vgic: Only use the virtual state when
 userspace accesses enable bits
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Julien Grall <julien@xen.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200417083319.3066217-1-maz@kernel.org>
 <20200417083319.3066217-4-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <040579d5-151f-5263-9f5f-69f86965dfc6@arm.com>
Date:   Fri, 17 Apr 2020 12:17:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200417083319.3066217-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 17/04/2020 09:33, Marc Zyngier wrote:
> There is no point in accessing the HW when writing to any of the
> ISENABLER/ICENABLER registers from userspace, as only the guest
> should be allowed to change the HW state.
> 
> Introduce new userspace-specific accessors that deal solely with
> the virtual state.
> 
> Reported-by: James Morse <james.morse@arm.com>

Tested on both machines I've hit this on:
Tested-by: James Morse <james.morse@arm.com>

and perhaps more useful:
Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James

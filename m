Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74E1210DA7
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 16:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbgGAOYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 10:24:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56503 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731399AbgGAOYq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Jul 2020 10:24:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593613484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tBmVabZ/r13W4Wz52iSUSVBPJD1c2mHsibs2U9wV+k0=;
        b=JORjjIePUZQezCAclKKFkSzAIjrXEE5C88sR05rEKzyedsYViBfL1NJWLq8Q77W/ehHQMQ
        npN5uqEGzShW/ntodx1E0Tw92vNSGgGZoMTZBYnT8oKCipDElDAERLXERcxoEP877jCAzE
        Dk8QDDAKDCylQq4qqEqePtNXUYe4Y+U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-b220VnwzNXG_6eyUFlkDbA-1; Wed, 01 Jul 2020 10:24:43 -0400
X-MC-Unique: b220VnwzNXG_6eyUFlkDbA-1
Received: by mail-wm1-f72.google.com with SMTP id h6so23632522wmb.7
        for <kvm@vger.kernel.org>; Wed, 01 Jul 2020 07:24:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tBmVabZ/r13W4Wz52iSUSVBPJD1c2mHsibs2U9wV+k0=;
        b=VcrAl6n/9lZaEpnSNDDQsCmum1tovFxxVLUsVT7UnS0acS7zdJ+zXYCaqheT5IMwan
         GKTSDDHthKpq68Ue/oZg97m8VXlYaNw+VfndxnHWxpqZfJiTDlXYoSYekrUWY/ajUQy3
         rfQyG9ys36V9NouIgy44AzIjJ68F4lYBjAG1iNjGhgC2/VED6d8UCgJQFo8xGSk6bBd7
         d7ihMeTo94Lz6Fa9s8GCdBiIMOMCZYwyqtlKEL7Dslc76JNi9azEFfwsPxlKudSNVkJt
         mRBL4yo8RdhULeqf9PcO0DzR6S9OELjQBBtzabhlEawACo9RFhFTN2Ftu41twHByxLF6
         On9Q==
X-Gm-Message-State: AOAM5319BnlcuOM8XrJASP+zAu0Bp1RJNZODD/pOedInSPWd5DmTNuT9
        1cRd7HHcYM/VPEtmEx0e4e8NAVz0M2Orl1Dh6H2DEWvuXpmgQkd4tG5cntp6WzD4EJBExOBmC1X
        Jb2T10y2ReD+x
X-Received: by 2002:a7b:c208:: with SMTP id x8mr27080862wmi.49.1593613481929;
        Wed, 01 Jul 2020 07:24:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrQwpCBpIqQTfqMpAOLuxuJU2euPTk+0h0YDWiJcUqEtgDNaujmK6RDYgEkNxjJFdbdhkcfw==
X-Received: by 2002:a7b:c208:: with SMTP id x8mr27080838wmi.49.1593613481707;
        Wed, 01 Jul 2020 07:24:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1142:70d6:6b9b:3cd1? ([2001:b07:6468:f312:1142:70d6:6b9b:3cd1])
        by smtp.gmail.com with ESMTPSA id 133sm7947357wme.5.2020.07.01.07.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 07:24:41 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.8, take #2
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Steven Price <steven.price@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20200629162519.825200-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <733910d5-b4db-3df5-9589-80e0367311fd@redhat.com>
Date:   Wed, 1 Jul 2020 16:24:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200629162519.825200-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/06/20 18:25, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's another pull request for a handful of KVM/arm64 fixes. Nothing
> absolutely critical (see the tag for the gory details), but I'd rather
> get these merged as soon as possible.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:
> 
>   Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvmarm-fixes-5.8-2
> 
> for you to fetch changes up to a3f574cd65487cd993f79ab235d70229d9302c1e:
> 
>   KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell (2020-06-23 11:24:39 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm fixes for 5.8, take #2
> 
> - Make sure a vcpu becoming non-resident doesn't race against the doorbell delivery
> - Only advertise pvtime if accounting is enabled
> - Return the correct error code if reset fails with SVE
> - Make sure that pseudo-NMI functions are annotated as __always_inline
> 
> ----------------------------------------------------------------
> Alexandru Elisei (1):
>       KVM: arm64: Annotate hyp NMI-related functions as __always_inline
> 
> Andrew Jones (1):
>       KVM: arm64: pvtime: Ensure task delay accounting is enabled
> 
> Marc Zyngier (1):
>       KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell
> 
> Steven Price (1):
>       KVM: arm64: Fix kvm_reset_vcpu() return code being incorrect with SVE
> 
>  arch/arm64/include/asm/arch_gicv3.h |  2 +-
>  arch/arm64/include/asm/cpufeature.h |  2 +-
>  arch/arm64/kvm/pvtime.c             | 15 ++++++++++++---
>  arch/arm64/kvm/reset.c              | 10 +++++++---
>  arch/arm64/kvm/vgic/vgic-v4.c       |  8 ++++++++
>  drivers/irqchip/irq-gic-v3-its.c    |  8 ++++++++
>  6 files changed, 37 insertions(+), 8 deletions(-)
> 

Pulled, thanks.

Paolo


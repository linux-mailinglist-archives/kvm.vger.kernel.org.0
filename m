Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B46124E4B
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 17:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfLRQsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 11:48:16 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35711 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727328AbfLRQsL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 11:48:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576687690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3iCukN3naD4fNqdh9fYCT0LHF+dYyNnqG3y3xi+jSBI=;
        b=Om/tmNFsKxEUVWrAdQd84EgFjYBUI8DsjkCPBLL1+FjJYzzlN0K7VyzcpeI3WxdF6tjIu5
        8kv6NUjpx5DRSCidUr2nnTkLvM5AtrYt+mejaMEc2BE778Rbpg3u/HQqZ11NS9wPNra2TN
        eSmoWuzl1jtFue7z2L0UoJ3bcPtWdgE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-cPvDR5n9PuqCWKJCHYZ1Jg-1; Wed, 18 Dec 2019 11:48:09 -0500
X-MC-Unique: cPvDR5n9PuqCWKJCHYZ1Jg-1
Received: by mail-wr1-f71.google.com with SMTP id j13so1088152wrr.20
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 08:48:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3iCukN3naD4fNqdh9fYCT0LHF+dYyNnqG3y3xi+jSBI=;
        b=gHQvZbLTXg+KbRbfzse54K09BSijWFGOxUk2eS/qaTJ8+Gk4YuvbnaimjqtSywK8rA
         QkzKGTEC2q6h9aFS6PbtQu3mtYBATV+zfwvD0WYUYzz6Tjm+PAhRQYMSd74D4geGeF5K
         rXeEWRU7ngqA0PhIWHIycWaocFbpICgbqNztmMQkl9rqiJsaRsb9W694DG42vwpYZwSW
         /WeOL/ltc2HonPeWeggNczNpzxzBJVelFF0pLqCvLuC7QcVd7GXeN2VtmN00gN/ZgsND
         A8e6D4CfX4o5449XoKRFlkACmtH/qQScFBiIvKDnwfL8tdbXcVVie0RBI21j1stfmybN
         qAeg==
X-Gm-Message-State: APjAAAVJmgo6hxKEDac8eyzevrEZYikInyYHGyVAl8VN+1Pzy6GAeOeV
        kogoTrVuJvaiM/VxtzDz5BPJEOI0WBnf5irqnNFH9ZdOYENjG20a/r7HTP4M0euBZykGEqGWmuu
        zFtAX6kbFXSu1
X-Received: by 2002:a1c:bbc3:: with SMTP id l186mr4359423wmf.101.1576687688289;
        Wed, 18 Dec 2019 08:48:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqx38t0P19/s6RsgvAUv2tWoExNQh9N/QMlt/7vD4SmB6ulBRwM6tY/Yad0hhQ0X8xSOGooRiA==
X-Received: by 2002:a1c:bbc3:: with SMTP id l186mr4359398wmf.101.1576687688016;
        Wed, 18 Dec 2019 08:48:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ac09:bce1:1c26:264c? ([2001:b07:6468:f312:ac09:bce1:1c26:264c])
        by smtp.gmail.com with ESMTPSA id c2sm3173159wrp.46.2019.12.18.08.48.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 08:48:07 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm updates for 5.5-rc2
To:     Marc Zyngier <maz@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>, Jia He <justin.he@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20191212172824.11523-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f8f96563-0cc0-1d00-0eb7-2845dba27d84@redhat.com>
Date:   Wed, 18 Dec 2019 17:48:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191212172824.11523-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/19 18:28, Marc Zyngier wrote:
> Paolo, Radim,
> 
> This is the first set of fixes for 5.5-rc2. This time around,
> a couple of MM fixes, a ONE_REG fix for an issue detected by
> GCC-10, and a handful of cleanups.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit cd7056ae34af0e9424da97bbc7d2b38246ba8a2c:
> 
>   Merge remote-tracking branch 'kvmarm/misc-5.5' into kvmarm/next (2019-11-08 11:27:29 +0000)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.5-1
> 
> for you to fetch changes up to 6d674e28f642e3ff676fbae2d8d1b872814d32b6:
> 
>   KVM: arm/arm64: Properly handle faulting of device mappings (2019-12-12 16:22:40 +0000)

Pulled, thanks.

Paolo

> 
> ----------------------------------------------------------------
> KVM/arm fixes for .5.5, take #1
> 
> - Fix uninitialised sysreg accessor
> - Fix handling of demand-paged device mappings
> - Stop spamming the console on IMPDEF sysregs
> - Relax mappings of writable memslots
> - Assorted cleanups
> 
> ----------------------------------------------------------------
> Jia He (1):
>       KVM: arm/arm64: Remove excessive permission check in kvm_arch_prepare_memory_region
> 
> Marc Zyngier (1):
>       KVM: arm/arm64: Properly handle faulting of device mappings
> 
> Mark Rutland (2):
>       KVM: arm64: Sanely ratelimit sysreg messages
>       KVM: arm64: Don't log IMP DEF sysreg traps
> 
> Miaohe Lin (3):
>       KVM: arm/arm64: Get rid of unused arg in cpu_init_hyp_mode()
>       KVM: arm/arm64: vgic: Fix potential double free dist->spis in __kvm_vgic_destroy()
>       KVM: arm/arm64: vgic: Use wrapper function to lock/unlock all vcpus in kvm_vgic_create()
> 
> Will Deacon (1):
>       KVM: arm64: Ensure 'params' is initialised when looking up sys register
> 
>  arch/arm64/kvm/sys_regs.c     | 25 ++++++++++++++++++-------
>  arch/arm64/kvm/sys_regs.h     | 17 +++++++++++++++--
>  virt/kvm/arm/arm.c            |  4 ++--
>  virt/kvm/arm/mmu.c            | 30 +++++++++++++++++-------------
>  virt/kvm/arm/vgic/vgic-init.c | 20 +++++---------------
>  5 files changed, 57 insertions(+), 39 deletions(-)
> 


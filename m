Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C4E9B522
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 19:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732205AbfHWRID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 13:08:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732165AbfHWRIC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 13:08:02 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 40D9F7DD11
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 17:08:02 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id v4so3149827wmh.9
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 10:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L7CFzFZcBTFDB9gXZjKJlWNHgFbguv8P194zUY7iBjo=;
        b=gg7v2X2CKmYKjdi0fvoQNna5m3BB92aFA2/qNbCdqGb9Dn8poPbm0oA+kRO5BMa3ny
         kKoNJwJXH5zS0prEs7YQH1NCSXDA2aO8WKmoysRbnUMYv5qfedur/FWzwfaxBomqD6tQ
         78JRM3NiH/SGALKxl8rBnbbsX7lV2q1Gbn0e/IhAPbJMI1odTs+VnuO8HRE6Ch8aqTBZ
         j57gGI3jgOyOJ23lTWaEB2Gd5dklihKIeypzaeSq5MLF6MX1m6Hg91zflKHwYGSViDlJ
         MSPTQvWqYD0bZMcEWMdUG1aaPxTpPGVJIeOfNGcmcK1bLK/SuLByxDoYvcOOvsfpWaaw
         enIw==
X-Gm-Message-State: APjAAAX27LJ2STE68c8suEMHSa3vQ8eXda4YheAHxS1n7WSz6cbBU7uO
        nSDMc6qJNL1z0qo1e3icTkzkgrZ9yGvevus7uH53gcd1WTdz/hRPYpFzMCoMaHKUfBXTPnFjAiP
        wUCsvXtNabRbF
X-Received: by 2002:a1c:6145:: with SMTP id v66mr6820121wmb.42.1566580080620;
        Fri, 23 Aug 2019 10:08:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz2VfVqVmbNSKh60msz2D85O4kPeYbsxyx65VFv1ZLWWCCH6sSVLhBJZ0JI2ziJHjDOK7yijA==
X-Received: by 2002:a1c:6145:: with SMTP id v66mr6820078wmb.42.1566580080242;
        Fri, 23 Aug 2019 10:08:00 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id n8sm3065205wrw.28.2019.08.23.10.07.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2019 10:07:59 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm updates for 5.3-rc6
To:     Marc Zyngier <maz@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Dave Martin <dave.martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20190823163516.179768-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <21ae69a2-2546-29d0-bff6-2ea825e3d968@redhat.com>
Date:   Fri, 23 Aug 2019 19:07:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190823163516.179768-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/08/19 18:35, Marc Zyngier wrote:
> Paolo, Radim,
> 
> One (hopefully last) set of fixes for KVM/arm for 5.3: an embarassing
> MMIO emulation regression, and a UBSAN splat. Oh well...
> 
> Please pull,

Please send this (and any other changes until the release) through the
ARM tree---same for s390 if need be.

This way Radim can concentrate on pending 5.4 patches while I am away.

Paolo

>        M.
> 
> The following changes since commit 16e604a437c89751dc626c9e90cf88ba93c5be64:
> 
>   KVM: arm/arm64: vgic: Reevaluate level sensitive interrupts on enable (2019-08-09 08:07:26 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.3-3
> 
> for you to fetch changes up to 2e16f3e926ed48373c98edea85c6ad0ef69425d1:
> 
>   KVM: arm/arm64: VGIC: Properly initialise private IRQ affinity (2019-08-23 17:23:01 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm fixes for 5.3, take #3
> 
> - Don't overskip instructions on MMIO emulation
> - Fix UBSAN splat when initializing PPI priorities
> 
> ----------------------------------------------------------------
> Andre Przywara (1):
>       KVM: arm/arm64: VGIC: Properly initialise private IRQ affinity
> 
> Andrew Jones (1):
>       KVM: arm/arm64: Only skip MMIO insn once
> 
>  virt/kvm/arm/mmio.c           |  7 +++++++
>  virt/kvm/arm/vgic/vgic-init.c | 30 ++++++++++++++++++++----------
>  2 files changed, 27 insertions(+), 10 deletions(-)
> 


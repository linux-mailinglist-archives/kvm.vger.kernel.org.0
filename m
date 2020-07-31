Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9E4234484
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 13:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732662AbgGaL0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 07:26:08 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60462 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732303AbgGaL0E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 07:26:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596194763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qOaj9Z+2J+hwBOQBlLHm+67/cw8pKJ5RjzcvJzQQPlo=;
        b=VZPFf98THy8KP3uWNww+8Q1YvWA7rGMOsirY0QnefEUkYt2UJTnJiMC6Sw+XHxN11ptf7B
        YBqv9CExaIztdNCcPvbfgVc2zWwPlXVLAqIK5Is7dG+olw3nuna2U/ikeTBAKNN3J4WySh
        taStOYB/ZRec5CLXZ5HQxj3Dkx4EyJA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-G6j_JAI4MiCY4RXowZ-NCQ-1; Fri, 31 Jul 2020 07:26:01 -0400
X-MC-Unique: G6j_JAI4MiCY4RXowZ-NCQ-1
Received: by mail-wr1-f69.google.com with SMTP id j2so6443593wrr.14
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 04:26:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qOaj9Z+2J+hwBOQBlLHm+67/cw8pKJ5RjzcvJzQQPlo=;
        b=Q11U9PEa2C6zaZUonmUp3CH+m3C7UI0AeQnFfNyon/e4H6Vx6XEC3S/DVVuDMl8PTV
         tGcCfCd7SzssaLE95H2SavqpT96DmXbCWEEjex4qQqS01jK4AjvSXQhKcUI5cs0m8upn
         jj/4hIFgCe6ASJpbIuP85vRV5ffdqaz4C39ag1c1hFF27SsFse+2t4Y7cJ3RswX7FCjX
         2qBn4WLkULB0YIWpeCiA2dO/PKaS3jV0lcimH+Sr5VQGU59012VIKuZu05tcMIBHzeqT
         4Oflv/2s7F+2/STLkPkKHe7MHPqPKr+P8EfbE3JfI4iy791gCaftuZfLiTD/qxmsJQM4
         JP9g==
X-Gm-Message-State: AOAM531IWJuQNNIQswEzKOtEAhe7VES6lXfW6EIGzN+OZ+jbre33Bakt
        lW8f+k9gD5Z4lZU1gVZBC4XXTQxvxQkCzhhMFgj2YAgRyx2GjHOTbhasjGoIkerwo+hJ1/V8WrG
        IXsT986SQYVO4
X-Received: by 2002:adf:f486:: with SMTP id l6mr3109674wro.265.1596194760248;
        Fri, 31 Jul 2020 04:26:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwk/sUGOSyrEXkSz7ip47hO4+s0lhkAC2W0ZVyNgZ4SZAfSzwoO1WyP1uGy8VewJvKt/OOPNQ==
X-Received: by 2002:adf:f486:: with SMTP id l6mr3109648wro.265.1596194759982;
        Fri, 31 Jul 2020 04:25:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:310b:68e5:c01a:3778? ([2001:b07:6468:f312:310b:68e5:c01a:3778])
        by smtp.gmail.com with ESMTPSA id r22sm5313359wmh.45.2020.07.31.04.25.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 04:25:59 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.8, take #4
To:     Marc Zyngier <maz@kernel.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20200728082255.3864378-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <29d7df19-0621-2589-50c6-c00b726e2c05@redhat.com>
Date:   Fri, 31 Jul 2020 13:25:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200728082255.3864378-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/20 10:22, Marc Zyngier wrote:
> Hi Paolo,
> 
> This is the last batch of fixes for 5.8. One fixes a long standing MMU
> issue, while the other addresses a more recent brekage with out-of-line
> helpers in the nVHE code.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit b9e10d4a6c9f5cbe6369ce2c17ebc67d2e5a4be5:
> 
>   KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART (2020-07-06 11:47:02 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.8-4
> 
> for you to fetch changes up to b757b47a2fcba584d4a32fd7ee68faca510ab96f:
> 
>   KVM: arm64: Don't inherit exec permission across page-table levels (2020-07-28 09:03:57 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for Linux 5.8, take #3
> 
> - Fix a corner case of a new mapping inheriting exec permission without
>   and yet bypassing invalidation of the I-cache
> - Make sure PtrAuth predicates oinly generate inline code for the
>   non-VHE hypervisor code
> 
> ----------------------------------------------------------------
> Marc Zyngier (1):
>       KVM: arm64: Prevent vcpu_has_ptrauth from generating OOL functions
> 
> Will Deacon (1):
>       KVM: arm64: Don't inherit exec permission across page-table levels
> 
>  arch/arm64/include/asm/kvm_host.h | 11 ++++++++---
>  arch/arm64/kvm/mmu.c              | 11 ++++++-----
>  2 files changed, 14 insertions(+), 8 deletions(-)
> 

Pulled, thanks.

Paolo


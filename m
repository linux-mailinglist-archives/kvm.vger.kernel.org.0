Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8972E1C5090
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 10:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgEEIkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 04:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbgEEIkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 04:40:02 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 541FE2068E;
        Tue,  5 May 2020 08:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588668001;
        bh=+lAoCLRT0+FEtavrhvzvewEUxnz1O4jXBxyoaAJzyTU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TojqmxZ51MAKtNII0QJTZkHZV54vQs0dYCqdZzSyLZY69CtmzXEUlGOedXp492lYB
         Pb+hXuyVYXaBcWe++5qpKHqNYkLddxXfK29FC3Zy/SVXmLHj6vHNpjYSjFgPHssfM9
         tJSpqFDEEFagx/s4/AinWjXsVVXozQpESISSAN6Q=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jVt7P-009L2s-N3; Tue, 05 May 2020 09:39:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 May 2020 09:39:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, christoffer.dall@arm.com,
        peterx@redhat.com, thuth@redhat.com, chenhuacai@gmail.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/7] KVM: arm64: clean up redundant 'kvm_run'
 parameters
In-Reply-To: <20200427043514.16144-3-tianjia.zhang@linux.alibaba.com>
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-3-tianjia.zhang@linux.alibaba.com>
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <35eb095a344b4192b912385bc02c54e6@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: tianjia.zhang@linux.alibaba.com, pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org, mpe@ellerman.id.au, benh@kernel.crashing.org, borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com, sean.j.christopherson@intel.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com, chenhuacai@gmail.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianjia,

On 2020-04-27 05:35, Tianjia Zhang wrote:
> In the current kvm version, 'kvm_run' has been included in the 
> 'kvm_vcpu'
> structure. For historical reasons, many kvm-related function parameters
> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
> patch does a unified cleanup of these remaining redundant parameters.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

On the face of it, this looks OK, but I haven't tried to run the
resulting kernel. I'm not opposed to taking this patch *if* there
is an agreement across architectures to take the series (I value
consistency over the janitorial exercise).

Another thing is that this is going to conflict with the set of
patches that move the KVM/arm code back where it belongs 
(arch/arm64/kvm),
so I'd probably cherry-pick that one directly.

Thanks,

         M.


-- 
Jazz is not dead. It just smells funny...

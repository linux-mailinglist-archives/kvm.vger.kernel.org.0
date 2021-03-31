Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6057334FCFB
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 11:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbhCaJe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 05:34:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234822AbhCaJeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 05:34:05 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC20061874;
        Wed, 31 Mar 2021 09:34:04 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lRXEg-004ruN-N0; Wed, 31 Mar 2021 10:34:02 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 31 Mar 2021 10:34:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 00/18] KVM: Consolidate and optimize MMU notifiers
In-Reply-To: <a2ca8cb2-5c91-b971-9b6e-65cf9ee97ffa@redhat.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <a2ca8cb2-5c91-b971-9b6e-65cf9ee97ffa@redhat.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <e50f6f28c0446cd328e475859ef05dc4@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, seanjc@google.com, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, paulus@ozlabs.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org, bgardon@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-03-31 08:57, Paolo Bonzini wrote:

> Queued and 1-9 and 18, thanks.  There's a small issue in patch 10 that
> prevented me from committing 10-15, but they mostly look good.

Can you please push the resulting merge somewhere?

I'm concerned that it will conflict in interesting way with other stuff
that is on its way on the arm64 side, not to mentiobn that this hasn't
been tested at all on anything but x86 (and given the series was posted
on Friday, that's a bit of a short notice).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...

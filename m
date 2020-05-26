Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C571E1AC0
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 07:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgEZFoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 01:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgEZFoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 01:44:39 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A9CC061A0E;
        Mon, 25 May 2020 22:44:39 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49WNFb23Kfz9sRY; Tue, 26 May 2020 15:44:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1590471875; bh=j0PNgC0xr6mRDHCZ2htDfbQsT0XH5gFzuCdilAoQCBw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H05nUKbvRSIH+7O5N9VUsnkHeRklB48VujBczf2Xtd7k/msK8glVNwOfwKFhBxaM2
         RMEhFP3061zuW6+4Tyn4tcDNAEbnpgE5y/GbpnLgkqD9inO7dRTJ8JdJazRZlG5By1
         dDTw25f7q0+rjMvV86X6zTMCLnL9GISRBtWJGAOBofFztGdhMaHaSDnzVJeKDOeTRr
         P/gT1fm1rSHSwWvDzu+Yy/x7JV3Y4U7YJfxqHFYoVKLC8zIAnftSk9Bv7oB4+ke1/z
         t+6gHdzDMsO3E/gW5yqaeDf4mGpMKKUTqOEkTCh4o4CEB+cdOrXQUL3itzvvSsvIix
         ogkCA1YC4CmqQ==
Date:   Tue, 26 May 2020 14:36:56 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     pbonzini@redhat.com, tsbogend@alpha.franken.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
        chenhuacai@gmail.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/7] KVM: PPC: Remove redundant kvm_run from vcpu_arch
Message-ID: <20200526043656.GA282305@thinks.paulus.ozlabs.org>
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-4-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427043514.16144-4-tianjia.zhang@linux.alibaba.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 12:35:10PM +0800, Tianjia Zhang wrote:
> The 'kvm_run' field already exists in the 'vcpu' structure, which
> is the same structure as the 'kvm_run' in the 'vcpu_arch' and
> should be deleted.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

This looks fine.

I assume each architecture sub-maintainer is taking the relevant
patches from this series via their tree - is that right?

Reviewed-by: Paul Mackerras <paulus@ozlabs.org>

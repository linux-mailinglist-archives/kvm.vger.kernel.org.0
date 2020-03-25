Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82972191DD2
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 01:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCYABC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 20:01:02 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46608 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgCYABC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 20:01:02 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGtTR-0008It-QH; Wed, 25 Mar 2020 01:00:46 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 1EF2B100C51; Wed, 25 Mar 2020 01:00:45 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v6 4/8] kvm: x86: Emulate split-lock access as a write in emulator
In-Reply-To: <20200324151859.31068-5-xiaoyao.li@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com> <20200324151859.31068-5-xiaoyao.li@intel.com>
Date:   Wed, 25 Mar 2020 01:00:45 +0100
Message-ID: <87lfnpz4k2.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:
>  
> +bool split_lock_detect_on(void)
> +{
> +	return sld_state != sld_off;
> +}
> +EXPORT_SYMBOL_GPL(split_lock_detect_on);

1) You export this function here

2) You change that in one of the next patches to something else

3) According to patch 1/8 X86_FEATURE_SPLIT_LOCK_DETECT is not set when
   sld_state == sld_off. FYI, I did that on purpose.

AFAICT #1 and #2 are just historical leftovers of your previous patch
series and the extra step was just adding more changed lines per patch
for no value.

#3 changed the detection mechanism and at the same time the semantics of
the feature flag.

So what's the point of this exercise? 

Thanks,

        tglx

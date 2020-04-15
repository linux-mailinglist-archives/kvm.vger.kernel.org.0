Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384BE1AB1FA
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 21:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441855AbgDOTrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 15:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406348AbgDOTrU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 15:47:20 -0400
X-Greylist: delayed 7418 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Apr 2020 12:47:19 PDT
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6F6C061A0F;
        Wed, 15 Apr 2020 12:47:19 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jOnzz-0001Ek-Cz; Wed, 15 Apr 2020 21:47:03 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 657DC100C47; Wed, 15 Apr 2020 21:47:02 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v8 4/4] kvm: vmx: virtualize split lock detection
In-Reply-To: <20200414063129.133630-5-xiaoyao.li@intel.com>
References: <20200414063129.133630-1-xiaoyao.li@intel.com> <20200414063129.133630-5-xiaoyao.li@intel.com>
Date:   Wed, 15 Apr 2020 21:47:02 +0200
Message-ID: <87y2qwmszt.fsf@nanos.tec.linutronix.de>
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

> Due to the fact that TEST_CTRL MSR is per-core scope, i.e., the sibling
> threads in the same physical CPU core share the same MSR, only
> advertising feature split lock detection to guest when SMT is disabled
> or unsupported, for simplicitly.

That's not for simplicity. It's for correctness because you cannot
provide consistent state to a guest.

Thanks,

        tglx

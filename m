Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86C757400
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 00:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfFZWAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 18:00:46 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50435 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfFZWAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 18:00:46 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgFxt-0008Je-NF; Thu, 27 Jun 2019 00:00:29 +0200
Date:   Thu, 27 Jun 2019 00:00:28 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Fenghua Yu <fenghua.yu@intel.com>
cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH v9 17/17] x86/split_lock: Warn on unaligned address in
 atomic bit operations
In-Reply-To: <1560897679-228028-18-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1906262352310.32342@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-18-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jun 2019, Fenghua Yu wrote:

> An atomic bit operation operates one bit in a single unsigned long location
> in a bitmap. In 64-bit mode, the location is at:
> base address of the bitmap + (bit offset in the bitmap / 64) * 8
> 
> If the base address is unaligned to unsigned long, each unsigned long
> location operated by the atomic operation will be unaligned to unsigned
> long and a split lock issue will happen if the unsigned long location
> crosses two cache lines.

Stop harping on this split lock stuff.

Unalignedness is a problem per se as myself and others explained you a
gazillion times now.

The fact that it does not matter on x86 except when it crosses a cacheline
does not make it in any way a split lock issue.

The root cause is misalignment per se.

Aside of that this debug enhancement wants to be the first patch in the
series not the last.

Thanks,

	tglx
	




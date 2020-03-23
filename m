Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F94418FAFB
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 18:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbgCWRK7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 13:10:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42139 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbgCWRK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 13:10:59 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGQbC-00035t-Gj; Mon, 23 Mar 2020 18:10:50 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id ED6471040AA; Mon, 23 Mar 2020 18:10:49 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v5 3/9] x86/split_lock: Re-define the kernel param option for split_lock_detect
In-Reply-To: <20200315050517.127446-4-xiaoyao.li@intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com> <20200315050517.127446-4-xiaoyao.li@intel.com>
Date:   Mon, 23 Mar 2020 18:10:49 +0100
Message-ID: <87r1xjov3a.fsf@nanos.tec.linutronix.de>
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

> Change sld_off to sld_disable, which means disabling feature split lock
> detection and it cannot be used in kernel nor can kvm expose it guest.
> Of course, the X86_FEATURE_SPLIT_LOCK_DETECT is not set.
>
> Add a new optioin sld_kvm_only, which means kernel turns split lock
> detection off, but kvm can expose it to guest.

What's the point of this? If the host is not clean, then you better fix
the host first before trying to expose it to guests.

Thanks,

        tglx


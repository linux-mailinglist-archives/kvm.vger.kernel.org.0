Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFD218FAD6
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 18:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgCWRGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 13:06:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42119 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgCWRGi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 13:06:38 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGQX1-0002zH-Ts; Mon, 23 Mar 2020 18:06:32 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 622551040AA; Mon, 23 Mar 2020 18:06:31 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     "Luck\, Tony" <tony.luck@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v5 2/9] x86/split_lock: Avoid runtime reads of the TEST_CTRL MSR
In-Reply-To: <20200321004315.GB6578@agluck-desk2.amr.corp.intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com> <20200315050517.127446-3-xiaoyao.li@intel.com> <20200321004315.GB6578@agluck-desk2.amr.corp.intel.com>
Date:   Mon, 23 Mar 2020 18:06:31 +0100
Message-ID: <87tv2fovag.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Luck, Tony" <tony.luck@intel.com> writes:

> On Sun, Mar 15, 2020 at 01:05:10PM +0800, Xiaoyao Li wrote:
>> In a context switch from a task that is detecting split locks
>> to one that is not (or vice versa) we need to update the TEST_CTRL
>> MSR. Currently this is done with the common sequence:
>> 	read the MSR
>> 	flip the bit
>> 	write the MSR
>> in order to avoid changing the value of any reserved bits in the MSR.
>> 
>> Cache the value of the TEST_CTRL MSR when we read it during initialization
>> so we can avoid an expensive RDMSR instruction during context switch.
>> 
>> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Originally-by: Tony Luck <tony.luck@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>
> Is it bad form to Ack/Review patches originally by oneself?

Only if they are broken ....

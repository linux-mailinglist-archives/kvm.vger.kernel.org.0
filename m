Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B487E1A458B
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 13:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgDJLPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 07:15:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54390 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgDJLPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 07:15:31 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jMrcd-0004L1-Hu; Fri, 10 Apr 2020 13:14:55 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 968FF100C1D; Fri, 10 Apr 2020 13:14:54 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: KVM: VMX: Add basic split-lock #AC handling
In-Reply-To: <b3f2a8d0-fa73-709e-8942-c1597184889f@redhat.com>
References: <20200402124205.334622628@linutronix.de> <20200402155554.27705-1-sean.j.christopherson@intel.com> <b3f2a8d0-fa73-709e-8942-c1597184889f@redhat.com>
Date:   Fri, 10 Apr 2020 13:14:54 +0200
Message-ID: <875ze7pp75.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:
> On 02/04/20 17:55, Sean Christopherson wrote:
>> First three patches from Xiaoyao's series to add split-lock #AC support
>> in KVM.
>> 
>> Xiaoyao Li (3):
>>   KVM: x86: Emulate split-lock access as a write in emulator
>>   x86/split_lock: Refactor and export handle_user_split_lock() for KVM
>>   KVM: VMX: Extend VMX's #AC interceptor to handle split lock #AC in
>>     guest
>
> Sorry I was out of the loop on this (I'm working part time and it's a
> mess).  Sean, can you send the patches as a top-level message?  I'll
> queue them and get them to Linus over the weekend.

I have a reworked version. I'll post it after lunch.

Thanks,

        tglx

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A156E19D687
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 14:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403897AbgDCMQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 08:16:46 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40148 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403836AbgDCMQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 08:16:46 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jKLF5-0005yc-FS; Fri, 03 Apr 2020 14:16:11 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id C5CE3103A01; Fri,  3 Apr 2020 14:16:10 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jim Mattson <jmattson@google.com>,
        "Kenneth R. Crudup" <kenny@panix.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Nadav Amit <namit@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86 <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Covelli <dcovelli@vmware.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Extend VMX's #AC interceptor to handle split lock #AC in guest
In-Reply-To: <CALMp9eSgKQW=rVnBq26cjNfcDXv2BWeA47oHM5pyQke7RpGykw@mail.gmail.com>
References: <20200402124205.334622628@linutronix.de> <20200402155554.27705-1-sean.j.christopherson@intel.com> <20200402155554.27705-4-sean.j.christopherson@intel.com> <87sghln6tr.fsf@nanos.tec.linutronix.de> <20200402174023.GI13879@linux.intel.com> <87h7y1mz2s.fsf@nanos.tec.linutronix.de> <20200402205109.GM13879@linux.intel.com> <87zhbtle15.fsf@nanos.tec.linutronix.de> <08D90BEB-89F6-4D94-8C2E-A21E43646938@vmware.com> <20200402190839.00315012@gandalf.local.home> <alpine.DEB.2.21.2004021613110.10453@xps-7390> <CALMp9eSgKQW=rVnBq26cjNfcDXv2BWeA47oHM5pyQke7RpGykw@mail.gmail.com>
Date:   Fri, 03 Apr 2020 14:16:10 +0200
Message-ID: <87tv20lq7p.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim,

Jim Mattson <jmattson@google.com> writes:
> On Thu, Apr 2, 2020 at 4:16 PM Kenneth R. Crudup <kenny@panix.com> wrote:
>> On Thu, 2 Apr 2020, Steven Rostedt wrote:
>>
>> > If we go the approach of not letting VM modules load if it doesn't have the
>> > sld_safe flag set, how is this different than a VM module not loading due
>> > to kabi breakage?
>>
>> Why not a compromise: if such a module is attempted to be loaded, print up
>> a message saying something akin to "turn the parameter 'split_lock_detect'
>> off" as we reject loading it- and if we see that we've booted with it off
>> just splat a WARN_ON() if someone tries to load such modules?
>
> What modules are we talking about? I thought we were discussing L1
> hypervisors, which are just binary blobs. The only modules at the L0
> level are kvm and kvm_intel.

Maybe in your world, but VmWare (which got this started), VirtualBox,
Jailhouse and who knows what else _are_ L0 hypervisors. Otherwise we
wouldn't have that conversation at all.

Thanks,

        tglx



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9264019CD49
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 01:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389171AbgDBXD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 19:03:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39172 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729549AbgDBXD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 19:03:56 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jK8rq-0004wg-2z; Fri, 03 Apr 2020 01:03:22 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id B84C0103A01; Fri,  3 Apr 2020 01:03:20 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Nadav Amit <namit@vmware.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        x86 <x86@kernel.org>, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Covelli <dcovelli@vmware.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Extend VMX's #AC interceptor to handle split lock #AC in guest
In-Reply-To: <08D90BEB-89F6-4D94-8C2E-A21E43646938@vmware.com>
References: <20200402124205.334622628@linutronix.de> <20200402155554.27705-1-sean.j.christopherson@intel.com> <20200402155554.27705-4-sean.j.christopherson@intel.com> <87sghln6tr.fsf@nanos.tec.linutronix.de> <20200402174023.GI13879@linux.intel.com> <87h7y1mz2s.fsf@nanos.tec.linutronix.de> <20200402205109.GM13879@linux.intel.com> <87zhbtle15.fsf@nanos.tec.linutronix.de> <08D90BEB-89F6-4D94-8C2E-A21E43646938@vmware.com>
Date:   Fri, 03 Apr 2020 01:03:20 +0200
Message-ID: <87wo6xlccn.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nadav Amit <namit@vmware.com> writes:
> Just to communicate the information that was given to me: we do intend to
> fix the SLD issue in VMware and if needed to release a minor version that
> addresses it. Having said that, there are other hypervisors, such as
> virtualbox or jailhouse, which would have a similar issue.

I'm well aware of that and even if VMWare fixes this, this still will
trip up users which fail to install updates for one reason or the other
and leave them puzzled. Maybe we just should not care at all.

Despite that I might have mentioned it before: What a mess ...

Thanks,

        tglx

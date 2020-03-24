Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29E819195B
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgCXSmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:42:47 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45842 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727567AbgCXSmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 14:42:47 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGoVS-0003kz-O8; Tue, 24 Mar 2020 19:42:30 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id EC729100292; Tue, 24 Mar 2020 19:42:29 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v5 3/9] x86/split_lock: Re-define the kernel param option for split_lock_detect
In-Reply-To: <20200324180207.GD5998@linux.intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com> <20200315050517.127446-4-xiaoyao.li@intel.com> <87r1xjov3a.fsf@nanos.tec.linutronix.de> <e708f6d2-8f96-903c-0bce-2eeecc4a237d@intel.com> <87r1xidoj1.fsf@nanos.tec.linutronix.de> <20200324180207.GD5998@linux.intel.com>
Date:   Tue, 24 Mar 2020 19:42:29 +0100
Message-ID: <87wo79d27e.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:
> On Tue, Mar 24, 2020 at 11:40:18AM +0100, Thomas Gleixner wrote:
>> 
>> It's very much about whether the host is split lock clean.
>> 
>> If your host kernel is not, then this wants to be fixed first. If your
>> host application is broken, then either fix it or use "warn".
>
> The "kvm only" option was my suggestion.  The thought was to provide a way
> for users to leverage KVM to debug/test kernels without having to have a
> known good kernel and/or to minimize the risk of crashing their physical
> system.  E.g. debug a misbehaving driver by assigning its associated device
> to a guest.

warn is giving you that, right? I won't crash the host because the #AC
triggers in guest context.

Thanks,

        tglx

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D671ACB72
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 17:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896454AbgDPPqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 11:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2896816AbgDPNeP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 09:34:15 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B934DC061A0C;
        Thu, 16 Apr 2020 06:34:14 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jP4eU-000231-6G; Thu, 16 Apr 2020 15:33:58 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id D02CA100C51; Thu, 16 Apr 2020 15:33:56 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v8 4/4] kvm: vmx: virtualize split lock detection
In-Reply-To: <a6e9867c-15f0-96be-04fa-456cbe826ffb@intel.com>
References: <20200414063129.133630-5-xiaoyao.li@intel.com> <871rooodad.fsf@nanos.tec.linutronix.de> <20200415191802.GE30627@linux.intel.com> <87tv1kmol8.fsf@nanos.tec.linutronix.de> <a6e9867c-15f0-96be-04fa-456cbe826ffb@intel.com>
Date:   Thu, 16 Apr 2020 15:33:56 +0200
Message-ID: <87mu7bmu63.fsf@nanos.tec.linutronix.de>
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
> On 4/16/2020 5:22 AM, Thomas Gleixner wrote:
>> I briefly thought about renaming the flag to TIF_SLD_ENABLED, set it by
>> default and update the 5 places where it is used. But that's
>> inconsistent as well simply because it does not make any sense to set
>> that flag when detection is not available or disabled on the command
>> line.
>> 
>
> Assuming you'll pick TIF_SLD_DISABLED, I guess we need to set this flag 
> by default for the case SLD is no available or disabled on the command, 
> for consistency?

No, because nothing cares if SLD is off. There is no way to make this
fully consistent under all circumstances.

Thanks,

        tglx

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F5B2774FA
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 17:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgIXPPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 11:15:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728273AbgIXPPJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 11:15:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600960507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qeT6DgZlIo7/DnF7C0MWtLCoj3X9qcfUrPyXcRS15nc=;
        b=a5XevXCbwUsvA8daoY7Ej8V1o2sZlOsQ/IkWEKa94zoZdIMTb7HVxgDlF09kafh0hPz2XA
        Ra92Woyddt6m0R4A7XyXYiOcUq6LHd6Z37MnRX1+ZJI7+RmHaOhBltr0ehHGJCK+6G8PdZ
        XJxPPDd/Fg4txPW283iFRsyYyOEr6wE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-uAgn9_DZPwm2RhmAajRrvw-1; Thu, 24 Sep 2020 11:15:03 -0400
X-MC-Unique: uAgn9_DZPwm2RhmAajRrvw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B29FD188C12F;
        Thu, 24 Sep 2020 15:15:01 +0000 (UTC)
Received: from starship (unknown [10.35.206.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A639073672;
        Thu, 24 Sep 2020 15:14:59 +0000 (UTC)
Message-ID: <7fb33d656a97ac5c05f2322de72fbca601fe85a7.camel@redhat.com>
Subject: Re: [PATCH v3 0/5] KVM_{GET,SET}_TSC_OFFSET ioctls
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>
Date:   Thu, 24 Sep 2020 18:14:58 +0300
In-Reply-To: <bc8ada67-fcff-c48b-c4f8-1f4452073a2a@redhat.com>
References: <20200722032629.3687068-1-oupton@google.com>
         <CAOQ_QsgeN4DCghH6ibb68C+P0ETr77s2s7Us+uxF6E6LFx62tw@mail.gmail.com>
         <CAOQ_QshUE_OQmAuWd6SzdfXvn7Y6SVukcC1669Re0TRGCoeEgg@mail.gmail.com>
         <f97789f6-43b4-a607-5af8-4f522f753761@redhat.com>
         <CAOQ_QsjsmVpbi92o_Dz0GzAmU_Oq=Z4KFjZ8BY5dLQr7YmbrFg@mail.gmail.com>
         <CALMp9eQ4zPoRfPQJ2c7H-hyqCWu+B6fjXk+7SsEOvK7aR49ZJg@mail.gmail.com>
         <7dce49db-9175-bfe0-8374-d433a7589de9@redhat.com>
         <CAOQ_Qsg9+a07bva3ZsEhx8-wAw8JPDm6Amss0XnWfMT2mNtqaw@mail.gmail.com>
         <7775b2a5-37b0-38f6-f106-d8960cb5310c@redhat.com>
         <CAOQ_Qsipib1qvTw_o3pAp-t9jjf9kWm8M238zxN+Q=3yAMA9oA@mail.gmail.com>
         <bc8ada67-fcff-c48b-c4f8-1f4452073a2a@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-09-24 at 15:43 +0200, Paolo Bonzini wrote:
> On 17/08/20 21:40, Oliver Upton wrote:
> > > If you don't have time to work on it I can try to find some for 5.10,
> > > but I'm not sure exactly when.
> > 
> > Shouldn't be an issue, I'll futz around with some changes to the
> > series and send them out in the coming weeks.
> 
> Ok, after looking more at the code with Maxim I can confidently say that
> it's a total mess.  And a lot of the synchronization code is dead
> because 1) as far as we could see no guest synchronizes the TSC using
> MSR_IA32_TSC; and 2) writing to MSR_IA32_TSC_ADJUST does not trigger the
> synchronization code in kvm_write_tsc.
> 
> Your patch works not by some sort of miracle, but rather because it
> bypasses the mess and that's the smart thing to do.
> 
> The plan is now as follows:
> 
> 1) guest-initiated MSR_IA32_TSC write never goes through the sync
> heuristics.  I'll shortly send a patch for this, and it will fix the
> testcase issue
> 
> 2) to have a new KVM_X86_DISABLE_QUIRKS value, that will toggle between
> "magic" and "vanilla" semantics for host-initiated TSC and TSC_ADJUST writes
> 
> 3) if the quirk is present we still want existing userspace to work so:
> 
> - host-initiated MSR_IA32_TSC write always returns the L1 TSC as in
> Maxim's recent patch.  They will also always go through the sync heuristics.
> 
> - host-initiated MSR_IA32_TSC_ADJUST write don't make the TSC jump, they
> only write to vcpu->arch.ia32_tsc_adjust_msr (as in the current kernel)
> 
> 4) if the quirk is disabled however:
> 
> - the sync heuristics are never used except in kvm_arch_vcpu_postcreate
> 
> - host-initiated MSR_IA32_TSC and MSR_IA32_TSC_ADJUST accesses work like
> in the guest: reads of MSR_IA32_TSC return the "right" TSC, writes of
> MSR_IA32_TSC_ADJUST writes make the TSC jump.
> 
> - for live migration, userspace is expected to use the new
> KVM_GET/SET_TSC_PRECISE (or whatever the name will be) to get/set a
> (nanosecond, TSC, TSC_ADJUST) tuple.  The sync heuristics will be
> bypassed and it will just set the right value for the MSRs.  Setting
> MSR_IA32_TSC_ADJUST is optional and controlled by a flag in the struct,
> and the flag will be set by KVM_GET_TSC_PRECISE based on the guest CPUID.
> 
> Paolo
> 

I'll soon implement this.
Best regards,
	Maxim Levitsky



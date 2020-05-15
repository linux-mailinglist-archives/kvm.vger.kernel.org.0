Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48101D5C59
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 00:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgEOWXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 18:23:43 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33501 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726228AbgEOWXl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 18:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589581419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mast8/ulH2Tav7VGd7dOuafB8vGOVhxtqzQHSIPHMcQ=;
        b=buU10s0m+nAb1JsYo+9QVIfMLI7m9BjzmaLJ44Pmiisu9AzzMBZMAMrc6Njgr0pa9ev68k
        vqjZwbrtmFzOGoki5mOG4Bmv8CD2m1QkSPzdkOKxLvxBNEtSZyoHdiLT0EfRyOEl8ERnTa
        FGhA+Q+wND/zDBRA2M/hx76vfivHAX4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-Z2uZZF-OMLmxvMmyCYtPTg-1; Fri, 15 May 2020 18:23:36 -0400
X-MC-Unique: Z2uZZF-OMLmxvMmyCYtPTg-1
Received: by mail-wm1-f69.google.com with SMTP id f62so1812916wme.3
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 15:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mast8/ulH2Tav7VGd7dOuafB8vGOVhxtqzQHSIPHMcQ=;
        b=bWe0cwml+kLZjJZ9Ky51y3/fCJ34QNKd3MQ5yerHPXXghvSarUcYcT330tQ8BtC3Jd
         01ZUeXnR/mX7nYUyRF+XDTUuB1jLeeG2M77fSJ087O03IjyRty1CsXH1iBYq4M0b5mpi
         MvEEVOfGtveK+cx6I4wMjf2PrXQtdDNREJdRg1yFrGGYaSabm+1pVFkToKImZWlQTjsu
         ekTq5IhYi1Jcue5i2TKOGf3wMTPeGQoqPaH67dnid4RfiRJSKipUKZc31guBpoEBtHnX
         i/DZQ45t+p1rx64U+JB7IyuE8+aBDPV7dIIQ0Nb1PQPID4KHOzUqu0W2qHab+VWN1Gna
         Fbkw==
X-Gm-Message-State: AOAM532SpHKG82xCutDzZgpIF0dDjK7zWwLc7kAHGvF0bkoL+y2Ojxmw
        Ab/Qi7Skk0q3uKNQxHl9cPqS6GOBTfGXgzidUyZ5nT0l68ICfuYTa+vibUDPDw2o9RdUSJUSyRo
        UELH6IyZsEOx6
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr6940548wrv.166.1589581414869;
        Fri, 15 May 2020 15:23:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0oiFzvaBdq6Kzo+VNSJDCPqwbyVSadNMC8i2dkTwza2qYxhs1/3DMwpFdYAvbePIbdnZwSw==
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr6940529wrv.166.1589581414540;
        Fri, 15 May 2020 15:23:34 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id t14sm1604725wrs.1.2020.05.15.15.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 15:23:33 -0700 (PDT)
Subject: Re: [PATCH 2/8] KVM: x86: extend struct kvm_vcpu_pv_apf_data with
 token info
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Andrew Cooper <andrew.cooper3@citrix.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-3-vkuznets@redhat.com>
 <20200512152709.GB138129@redhat.com> <87o8qtmaat.fsf@vitty.brq.redhat.com>
 <20200512155339.GD138129@redhat.com> <20200512175017.GC12100@linux.intel.com>
 <20200513125241.GA173965@redhat.com>
 <0733213c-9514-4b04-6356-cf1087edd9cf@redhat.com>
 <20200515184646.GD17572@linux.intel.com>
 <d84b6436-9630-1474-52e5-ffcc4d2bd70a@redhat.com>
 <20200515204341.GF17572@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <943cfc2f-5b18-e00a-f5a2-4577472a1ff5@redhat.com>
Date:   Sat, 16 May 2020 00:23:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200515204341.GF17572@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/05/20 22:43, Sean Christopherson wrote:
> On Fri, May 15, 2020 at 09:18:07PM +0200, Paolo Bonzini wrote:
>> On 15/05/20 20:46, Sean Christopherson wrote:
>>> Why even bother using 'struct kvm_vcpu_pv_apf_data' for the #PF case?  VMX
>>> only requires error_code[31:16]==0 and SVM doesn't vet it at all, i.e. we
>>> can (ab)use the error code to indicate an async #PF by setting it to an
>>> impossible value, e.g. 0xaaaa (a is for async!).  That partciular error code
>>> is even enforced by the SDM, which states:
>>
>> Possibly, but it's water under the bridge now.
> 
> Why is that?  I thought we were redoing the entire thing because the current
> ABI is unfixably broken?  In other words, since the guest needs to change,
> why are we keeping any of the current async #PF pieces?  E.g. why keep using
> #PF instead of usurping something like #NP?

Because that would be 3 ABIs to support instead of 2.  The #PF solution
is only broken as long as you allow async PF from ring 0 (which wasn't
even true except for preemptable kernels) _and_ have NMIs that can
generate page faults.  We also have the #PF vmexit part for nested
virtualization.  This adds up and makes a quick fix for 'page not ready'
notifications not that quick.

However, interrupts for 'page ready' do have a bunch of advantages (more
control on what can be preempted by the notification, a saner check for
new page faults which is effectively a bug fix) so it makes sense to get
them in more quickly (probably 5.9 at this point due to the massive
cleanups that are being done around interrupt vectors).

>> And the #PF mechanism also has the problem with NMIs that happen before the
>> error code is read and page faults happening in the handler.
> 
> Hrm, I think there's no unfixable problem except for a pathological
> #PF->NMI->#DB->#PF scenario.  But it is a problem :-(

Yeah, that made no sense.  But still I'm not sure the x86 maintainers
would like it.

The only possible isue with #VE is the re-entrancy at the end.  Andy
proposed re-enabling it from an interrupt, but here is one solution that
can be done almost entirely from C.  The idea is to split the IST in two
halves, and flip between them in the TSS with an XOR operation on entry
to the interrupt handler.  This is possible because there won't ever be
more than two handlers active at the same time.  Unlike if you used
SUB/ADD, with XOR you don't have to restore the IST on exit: the two
halves will take turns as the current IST and there's no problematic
window between the ADD and the IRET.

The pseudocode would be:

- on #VE entry
   xor 512 with the IST address in the TSS
   check if saved RSP comes from the IST
   if so:
     overwrite the saved flags/CS/SS in the "other" IST half with the
       current value of the registers
     overwrite the saved RSP in the "other" IST half with the address
       of the top of the IST itself
     overwrite the saved RIP in the "other" IST half with the address
       of a trampoline (see below)
   else:
     save the top 5 words of the IST somewhere
     do normal stuff

- the trampoline restores the 5 words at the top of the IST with five
  push instructions, and jumps back to the first instruction of the
  handler

Everything except the first step can even be done in C.

Here is an example.

Assuming that on entry to the outer #VE the IST is the "even" half, the
outer #VE moves the IST to the "odd" half and the return
flags/CS/SS/RSP/RIP are saved.

After the reentrancy flag has been cleared, a nested #VE arrives and
runs within the "odd" half of the IST.  The IST is moved back to the
"even" half and the return flags/CS/SS/RSP/RIP in the "even" half are
patched to point to the trampoline.

When we get back to the outer handler the reentrancy flag not zero, so
even though the IST points to the current stack, reentrancy is
impossible and we go just fine through the few final instructions of the
handler.

On outer #VE exit, the IRET instruction jumps to the trampoline, with
RSP pointing at the top of the "even" half.  The return
flags/CS/SS/RSP/RIP are restored, and everything restarts from the
beginning: the outer #VE moves the IST to the "odd" half, the return
flags/CS/SS/RSP/RIP are saved, the data for the nested #VE is fished out
of the virtualization exception area and so on.

Paolo


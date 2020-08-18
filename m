Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF77247F32
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 09:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgHRHPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 03:15:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32166 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726370AbgHRHPG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 03:15:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597734904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VnkZLMte3116urPzW5jKDlxRd4vsRM7I0r+mSa2q174=;
        b=BK5JACzmokInjp/SA5nLIKr1CX86VY8MT8/zEAxBeEM/RPGQcFp5djmRYlpb4zD0GoIaqC
        +N476MV+j83rK/5aWWSbyDxMyCQosTYoDTkpnmBe/GyNmvsGIAsfuJlrmcBi7FS7m33Mli
        1FN+6Lh7tkHH1181xvVADRwXE44VWJU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-JN7rVOcIO0G6WIefvrha8Q-1; Tue, 18 Aug 2020 03:15:01 -0400
X-MC-Unique: JN7rVOcIO0G6WIefvrha8Q-1
Received: by mail-wr1-f72.google.com with SMTP id r29so7885802wrr.10
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 00:15:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VnkZLMte3116urPzW5jKDlxRd4vsRM7I0r+mSa2q174=;
        b=oJYLxljYzfDFGxMyHERACvVnXH3jTvY+xAHJZ2T1U4g+3lFbdHCPf7OolsGOg5lgjm
         ZibkkAZn7IkNGhqypzOzzdQSmoQmNQNJsIqFZAnrYCIYiHbC1Sg6z0BAKMjIZ7KkGX4J
         8WjrnSJQEdJCS86JCl39S6AaUyGHoWKlOIIyIcVQmAcOzJlxnkKdBvRzQM/gSxKic2qv
         /AQRfUTythyXju2yH9B7hFvEV0Us16AoBSgfr4wU0uobpk6DAWP98DYhlBwKUjeLNGM8
         r50NTes6hrvWh9tTSbe/XzZvSzeFBi2FywWfD4UlTfFyF+8X9eZPHWetNtXrait9J+JR
         xV9g==
X-Gm-Message-State: AOAM5325cvfY5JQnl66WhQvG6R59esnOav+tPHlYu2hFfzpvgW4ALSch
        r3P2NVqC6V/fqnwSf9VMQQJrpBI418xK/G09xiz0PspnTaApk5FD2kgU+AVWo3rZZD5PPymF2E+
        v15yQGh4HKdhZ
X-Received: by 2002:adf:b312:: with SMTP id j18mr19499395wrd.142.1597734900806;
        Tue, 18 Aug 2020 00:15:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxDBVc6FNobMFPmLaQ8JBtEJ0j8nc00thHTm7+HAm5Z27/zTChbr9Q9OWX0Of8Uc7BLJHy1Q==
X-Received: by 2002:adf:b312:: with SMTP id j18mr19499363wrd.142.1597734900475;
        Tue, 18 Aug 2020 00:15:00 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id t14sm32631227wrv.14.2020.08.18.00.14.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 00:14:59 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] x86/cpufeatures: Add enumeration for SERIALIZE
 instruction
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Cathy Zhang <cathy.zhang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kyung Min Park <kyung.min.park@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>, fenghua.yu@intel.com
References: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
 <1594088183-7187-2-git-send-email-cathy.zhang@intel.com>
 <CALCETrWudiF8G8r57r5i4JefuP5biG1kHg==0O8YXb-bYS-0BA@mail.gmail.com>
 <20200708022102.GA25016@ranerica-svr.sc.intel.com>
 <87eep3ywz0.fsf@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <be322917-0f10-de4c-9b7c-308d667277eb@redhat.com>
Date:   Tue, 18 Aug 2020 09:14:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87eep3ywz0.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/07/20 01:02, Thomas Gleixner wrote:
>> I am cc'ing Fenghua, who has volunteered to work on this. Addind support
>> for SERIALIZE in sync_core() should not block merging these patches,
>> correct?
> Come on. We are not serving KVM first before making this usable on bare
> metal.

This in the end was merged in 5.9, but: why not?  It is just an
instruction with no other support code needed in the kernel (or KVM for
that matter except for marking the CPUID bit as supported).  It is
common to run hosts with an older kernel than the guests, and by this
line of reasoning, we should not even have enabled support for FSGSBASE
in KVM.

Paolo


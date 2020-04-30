Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598231BF07E
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 08:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgD3Gq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 02:46:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30131 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3Gq1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 02:46:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588229184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RLEL+A2Y8ThCTO/2PBYFiQCG0qUQHEWBfC2HqHC6sUc=;
        b=iq7pg1Nhc9qq7ipNYPveH2Y7+GhPqMO6rdS1ZHgWGpTW88pnFK1EM73e2sEFHWvq7yofRa
        LBDs7Jnmx6zeAyHSYoOkNF8HK5fEBsdoz0Uc/aQMWEt+iib2mtdy44//pXccBMgD8yaCbI
        iw1VZ4L69tEJWMqCgA6Is/GlQRLo1xw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-jQggeoyLP-ep6L7mhi-lrA-1; Thu, 30 Apr 2020 02:46:20 -0400
X-MC-Unique: jQggeoyLP-ep6L7mhi-lrA-1
Received: by mail-wr1-f69.google.com with SMTP id r17so3364096wrg.19
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 23:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RLEL+A2Y8ThCTO/2PBYFiQCG0qUQHEWBfC2HqHC6sUc=;
        b=X201MsnIUBVoWN7j4EXeLAGJFLV9rxiDAKQu+4FzToBwZdl6J+TYpPKMauHSRj5VDZ
         YCTIfC4t0lvGPDRBUgB0mtvf8cpXUf4BIGWBVDWjciSxgV9cbelmAJmsOANUd0wwOZ0a
         CNsI4Oi1PpYUJ5SrFBtigrxisW7oQd+oxqUakcvM/3g2YTdkeklxjiyyiy1Mh2FMF//k
         RohnlsFlQ1L1166+ctclJLXrYdDXQOUzJXDRf2OWaANw1iHGLvuFcP1zAkaId4D79vAT
         vzgaUe4UHHMs7b2YNZEPeYBNGM9HcXNZfduk/4Jb/4w+lJ4DphYzzpRdOsrNMRVa8Ck9
         590Q==
X-Gm-Message-State: AGi0PuY6atLQV/FOo8LOo34EHbec6zLRCnwRCBEVFwROiySajltX5+8A
        oaCSOCwUMtTthtfewM8Zw/6zuIbel5qaa/r/WN8lAxmMPso1IPB26bmGnu7VSSpcSUhbC/pczId
        7JFDFp99dtsOQ
X-Received: by 2002:a05:6000:114c:: with SMTP id d12mr1918072wrx.381.1588229179418;
        Wed, 29 Apr 2020 23:46:19 -0700 (PDT)
X-Google-Smtp-Source: APiQypIcWHDQ8NNR/eZLBVLzbDVLqCqfBNiQOwlCXTe6YPk//VfIN5W3VSPkaw9TeqPPHPYxDiKjcg==
X-Received: by 2002:a05:6000:114c:: with SMTP id d12mr1918041wrx.381.1588229179146;
        Wed, 29 Apr 2020 23:46:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id h16sm2669639wrw.36.2020.04.29.23.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 23:46:18 -0700 (PDT)
Subject: Re: [PATCH RFC 4/6] KVM: x86: acknowledgment mechanism for async pf
 page ready notifications
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-5-vkuznets@redhat.com>
 <CALCETrXEzpKNhNJQm+SshiEfyHjYkB7+1c+7iusZy66rRsWunA@mail.gmail.com>
 <0de4a809-e965-d0ad-489f-5b011aa5bf89@redhat.com>
 <CALCETrWQBmmVODuSXac965o29Oxqo6uo4Ujm2AN2FUMztwCnzA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2be99d33-7b5d-bf2f-a34f-b841cd5c1936@redhat.com>
Date:   Thu, 30 Apr 2020 08:46:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALCETrWQBmmVODuSXac965o29Oxqo6uo4Ujm2AN2FUMztwCnzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/20 02:45, Andy Lutomirski wrote:
>> That's a very bad idea since one is synchronous and one is asynchronous.
>>  Part of the proposal we agreed upon was to keep "page not ready"
>> synchronous while making "page ready" an interrupt.  The data structure
>> for "page not ready" will be #VE.
>
> #VE on SVM will be interesting, to say the least, and I think that a
> solution that is VMX specific doesn't make much sense.

You can always inject it manually.  The same is true of Haswell and
earlier processors.

> #VE also has
> unpleasant issues involving the contexts in which it can occur.  You
> will have quite a hard time convincing me to ack the addition of a #VE
> entry handler for this.  I think a brand new vector is the right
> solution.

I need --verbose. :)  For #VE I liked the idea of re-enabling it from an
IPI, at least in the case where we cannot move out of the IST stack.
And any other vector that behaves like an exception would have the same
issue, wouldn't it (especially re-entrancy)?

Paolo


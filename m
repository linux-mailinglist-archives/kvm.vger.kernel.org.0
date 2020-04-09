Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5977E1A3452
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 14:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgDIMrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 08:47:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33343 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726571AbgDIMrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 08:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586436435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9cZpoXND/3gmTzh1oxxwwcgLLTs9FadoYX5XJNUdgHA=;
        b=MYKw6elCXZLJ/Ye0YvE+gG9Q54G7iu4TLX4u5GIa/BjGE0cSUBoE0UpflhpPxSXJxK1oCS
        ceAa8chcF4F4m6+cZchWrnHIKtMRRex1X81YgLVPueyz5Cp+vK0DIrU8UplW9egB7i/80q
        AHcHdK0e0H8ibLY8RKcGcTbPnXk+np0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-gQzqAgEiPC6uKxuW_B5Bcg-1; Thu, 09 Apr 2020 08:47:13 -0400
X-MC-Unique: gQzqAgEiPC6uKxuW_B5Bcg-1
Received: by mail-wr1-f69.google.com with SMTP id y6so6282035wrq.21
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 05:47:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9cZpoXND/3gmTzh1oxxwwcgLLTs9FadoYX5XJNUdgHA=;
        b=h1mlD3fYeievy8OcpJODeiGpoeu07Y+c0MG6YqLJKu3JEbQMjvS0ZlKMzR/SEYb/g7
         JgNN8JGDWdGjT90i7a6weifGpC/9UDUx86rqBaEbKCkXFwNGwbtZhzCHXPUO/LKLXxAr
         aYEGN5eurKc+e6noKDDhATChMCyb92Jfp/P4Sz82r0452JOo4nLDij6HZnBsdfvUIj0i
         ihvm6IYttSJrUFM/P38SQU9lkMKfBQ61aBzWFrIPWhirTM+60w9jMDw33wDUB3z0u1/P
         jT6GDtWYXO25K/hI97GzgtrcIO5RlRmkgU0odcj9Xkp0U8BehPQVr0ys5T27MZm7fKqz
         jRZg==
X-Gm-Message-State: AGi0PubebqmbsFgdn1Y6WaD9g8LopnPc98cvt3eHcZCGp+b5VCFYR7Z0
        U+17Lfi+uUk7wArZWP3KigLviyPeZ8Mjan1GL/5SuCKxo+41WNnaz4Keg7i9SPZU+bZ7LNqcXm/
        QrOgLUqhgtpJM
X-Received: by 2002:adf:de82:: with SMTP id w2mr11650496wrl.169.1586436432413;
        Thu, 09 Apr 2020 05:47:12 -0700 (PDT)
X-Google-Smtp-Source: APiQypKfSpr+zznIlqiZ5jTI4LNgxdDVUTFZ2rVYdzR0Z4HJ8TlV+mOfJmxmxC04UJ8VX5gcDOs3wg==
X-Received: by 2002:adf:de82:: with SMTP id w2mr11650477wrl.169.1586436432152;
        Thu, 09 Apr 2020 05:47:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e8a3:73c:c711:b995? ([2001:b07:6468:f312:e8a3:73c:c711:b995])
        by smtp.gmail.com with ESMTPSA id f12sm40384763wrm.94.2020.04.09.05.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 05:47:11 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
 <874ktukhku.fsf@nanos.tec.linutronix.de>
 <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
 <20200408153413.GA11322@linux.intel.com>
 <ce28e893-2ed0-ea6f-6c36-b08bb0d814f2@redhat.com>
 <87d08hc0vz.fsf@nanos.tec.linutronix.de>
 <CALCETrWG2Y4SPmVkugqgjZcMfpQiq=YgsYBmWBm1hj_qx3JNVQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <04aca08a-cfce-b4db-559a-23aee0a0b7aa@redhat.com>
Date:   Thu, 9 Apr 2020 14:47:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CALCETrWG2Y4SPmVkugqgjZcMfpQiq=YgsYBmWBm1hj_qx3JNVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/20 06:50, Andy Lutomirski wrote:
> The small
> (or maybe small) one is that any fancy protocol where the guest
> returns from an exception by doing, logically:
> 
> Hey I'm done;  /* MOV somewhere, hypercall, MOV to CR4, whatever */
> IRET;
> 
> is fundamentally racy.  After we say we're done and before IRET, we
> can be recursively reentered.  Hi, NMI!

That's possible in theory.  In practice there would be only two levels
of nesting, one for the original page being loaded and one for the tail
of the #VE handler.  The nested #VE would see IF=0, resolve the EPT
violation synchronously and both handlers would finish.  For the tail
page to be swapped out again, leading to more nesting, the host's LRU
must be seriously messed up.

With IST it would be much messier, and I haven't quite understood why
you believe the #VE handler should have an IST.

Anyhow, apart from the above "small" issue, we have these separate parts:

1) deliver page-ready notifications via interrupt

2) page-in hypercall + deliver page-not-found notifications via #VE

3) propagation of host-side SIGBUS

all of which have both a host and a guest part, and all of which make
(more or less) sense independent of the other.

Paolo


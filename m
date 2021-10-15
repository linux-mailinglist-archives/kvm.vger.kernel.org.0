Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9246542ED0B
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236385AbhJOJEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:04:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236359AbhJOJEr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 05:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634288560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PhlIsRLo815t+m2jVfDd0ZVZoAGb7rOYgz0mDMFFLoY=;
        b=HtXIOO5bcslkKF1RKEflO70XW+oQ5aZx55hGr2p3jJ7BFMxE1wuJvt1/xs810E7Uha/0P0
        BHYSoD9fz6pTg0selOkDUrHhM+Mo8lzgZKr2kUlEACOD1BNOe+N+XWdnXX8benpWxmyNLC
        ZG6RUddvM03Zf7ufXUZzx1Njrt+zLT8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-6qd-NPJVOMavU83bL_Myyg-1; Fri, 15 Oct 2021 05:02:39 -0400
X-MC-Unique: 6qd-NPJVOMavU83bL_Myyg-1
Received: by mail-ed1-f69.google.com with SMTP id s12-20020a50dacc000000b003dbf7a78e88so4622152edj.2
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 02:02:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PhlIsRLo815t+m2jVfDd0ZVZoAGb7rOYgz0mDMFFLoY=;
        b=y/JMHF793god1oxPbQ34JpOMYanTO374+I0/gMSWpiBq0y28HGTWZIiQE5Y84d/g5B
         vJ3AC1bUX4FrldL0+HwWEJ+KgVpWtYbsD3Fmp2i+hfn5yBLAnfKYXjwHhm2vo+wyA/s9
         1ttlAN6fglZdwgScofpM89Y5xh2VyHWFEHhiXAjIuv/fwq+1hrzoD6XzCRqu8OtISHLF
         atxReMZmv5RuASNuLt0pcaGSnruyqXXhLHlp3WGbIeL44ZjWrTTQymsQJ58Xczg8KLBz
         3CNAFoX6+ek+xhMLDT5tFzd3EwE57QS+5XhAm0qAT1Lz3CD7sZ9Nw8AbjwmB6VBdB5Gf
         F9bA==
X-Gm-Message-State: AOAM532xjgIaYnOZvO0MrkYdXIE93fucKcQXx833pM96JPhld0x6UYt0
        sU8HKeqFKrU68Qh7NoWxKDezep3aJMEB4vj2IduYvxH1flM1nHSrNPmkE8wxJTM7d860Eaz3Q39
        h8SrEnuE6AsDe
X-Received: by 2002:a05:6402:1157:: with SMTP id g23mr16943907edw.379.1634288557817;
        Fri, 15 Oct 2021 02:02:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjBoqUowr96DKoVb83o/A9q/NX7u5qyRXRA1DgBIXoYK9ebh5lAWp8ZEEhPoxT2B5TTbDAjQ==
X-Received: by 2002:a05:6402:1157:: with SMTP id g23mr16943848edw.379.1634288557311;
        Fri, 15 Oct 2021 02:02:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j21sm4003886edr.64.2021.10.15.02.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 02:02:36 -0700 (PDT)
Message-ID: <7b2c41cb-31fd-3755-dd34-86e7926f2f49@redhat.com>
Date:   Fri, 15 Oct 2021 11:02:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/2] KVM: x86: Revert to fix apic_hw_disabled underflow
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+9fc046ab2b0cf295a063@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
References: <20211013003554.47705-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211013003554.47705-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 02:35, Sean Christopherson wrote:
> Revert (mostly) a patch from the vCPU RESET cleanup that open coded some
> APIC shenanigans to avoid stuffing vcpu->arch.apic_base at vCPU creation,
> and completely overlooked the side effects on apic_hw_disabled.  I went
> for a revert as I think the original behavior is the least awful solution,
> just somewhat poorly documented.
> 
> The second patch adds WARNs to detect "overflow", where "overflow" means
> KVM incorrectly increments apic_hw_disabled.
> 
> Sean Christopherson (2):
>    Revert "KVM: x86: Open code necessary bits of kvm_lapic_set_base() at
>      vCPU RESET"
>    KVM: x86: WARN if APIC HW/SW disable static keys are non-zero on
>      unload
> 
>   arch/x86/kvm/lapic.c | 20 +++++++++++++-------
>   1 file changed, 13 insertions(+), 7 deletions(-)
> 

Queued for 5.15, thanks.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0566351960
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhDARxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:53:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236267AbhDARoQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:44:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xpun99tvWb1lx2RACJU6X8cw0dJvrT8bzWLMZnVlAdk=;
        b=BNSCE9vYkFpkCSWwwpnQRBzOWrNfRr2mRufSWK5jSjTe0wUQ+gvLXDI/sZZ+gDKLgwkJEF
        V0WXjCMh35J0XVFW2SyKz4xiPD/b3wqgeeunlAojTxD8IiyTlciI4bqhl728cXdLnW7ywi
        uSJIPOh6GbD+En9gr5lZcXvg5dGRsw8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-PuQdAfndOtOOxm4BmJZxmQ-1; Thu, 01 Apr 2021 09:43:12 -0400
X-MC-Unique: PuQdAfndOtOOxm4BmJZxmQ-1
Received: by mail-wr1-f69.google.com with SMTP id t14so2774106wrx.12
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 06:43:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xpun99tvWb1lx2RACJU6X8cw0dJvrT8bzWLMZnVlAdk=;
        b=ARk3t71AQeJAXJB5nKUT1+roGwL5gypoNS/LlyELTW3dybfMZAeaHwesmBqUVe8Iiv
         4IDwW+s3NPDIBt8282QMxW/bc/c3dZBdP64/IFd/lTdEdWJPzhTcQMgl7sFtmuz/lDkC
         7u34LrQTAI8sGuiRCExq3wowvH/3UA3tFj75g4SWyz2+wHVs2DzjbFseuci52fnb7Yyg
         vZ3iBFKznq0orGKixAPlj9x67oFtVeHsD74tozYqcYwo9ovC7vOarjyOyUYW2dDfcVTX
         zWyznsj3bY8UI6y0qf8PTmvAAnzNZEp+CqI583rwvVsRG/dukZo4/25GPcV2VWUKUrvr
         njbA==
X-Gm-Message-State: AOAM531tqRAGIDgrz3XGgD1x3tNHjYa1xoAv0M+Z9tNqWRLyw0l1yItc
        vU4FWjMvTc0DMJyN1p4I7ICZw9GDVmuejr+HByXwQbZ/VBBD2l2XGXUtfPV86aUTNaAbJqoCwzo
        2UwAA4tWlOYv/
X-Received: by 2002:a1c:49c2:: with SMTP id w185mr8144709wma.163.1617284591746;
        Thu, 01 Apr 2021 06:43:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy74Z45BwFltJfqODTBF4QpnKZOLKhdk7mXnXxGmt5DzRb4wc5TlQU8xGt7xNshzePaYeV6yg==
X-Received: by 2002:a1c:49c2:: with SMTP id w185mr8144686wma.163.1617284591546;
        Thu, 01 Apr 2021 06:43:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r1sm12960441wrj.63.2021.04.01.06.43.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 06:43:10 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] KVM: nSVM: improve SYSENTER emulation on AMD
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20210401111928.996871-1-mlevitsk@redhat.com>
 <20210401111928.996871-3-mlevitsk@redhat.com>
 <87h7kqrwb2.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6f138606-d6c3-d332-9dc2-9ba4796fd4ce@redhat.com>
Date:   Thu, 1 Apr 2021 15:43:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <87h7kqrwb2.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/21 15:03, Vitaly Kuznetsov wrote:
>> +		svm->sysenter_eip_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
> 
> (Personal taste) I'd suggest we keep the whole 'sysenter_eip'/'sysenter_esp'
> even if we only use the upper 32 bits of it. That would reduce the code
> churn a little bit (no need to change 'struct vcpu_svm').

Would there really be less changes?  Consider that you'd have to look at 
the VMCB anyway because svm_get_msr can be reached not just for guest 
RDMSR but also for ioctls.

Paolo


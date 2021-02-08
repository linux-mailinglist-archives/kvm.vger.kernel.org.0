Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8330E313B7B
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 18:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbhBHRtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 12:49:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21349 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235001AbhBHRrn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 12:47:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612806367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AGNSJcTi1GoljhoR82wLbrQntb542AwjI3pFM5LOGco=;
        b=E3XzRWm2LEH5CWPb4f5bq64G46CNvB1XiBUKyAiX4QqjqX7c9m3o2BRcHbgvNz6/E0s6s7
        aHa7VL9cBjJGQ1j+IBQnlYa0b8NPqOLs+DMnPHp8RxMjlD6eAx6pekNVogW2S5HTaKzr9R
        9O8OCpHJ0JVcFFmmyVb0rdlFRqxJH+Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-GnA_k6NBPQu_YSGAblo__A-1; Mon, 08 Feb 2021 12:46:04 -0500
X-MC-Unique: GnA_k6NBPQu_YSGAblo__A-1
Received: by mail-wm1-f71.google.com with SMTP id n17so7013401wmk.3
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 09:46:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AGNSJcTi1GoljhoR82wLbrQntb542AwjI3pFM5LOGco=;
        b=WbZIya4cfUR4HmSeLurxHGr8SPrFefbYXwaTe5ts3+r27xK4+FeC0k5qzu1NQMwy6v
         d1CnKyCXTk7YI2bDE2jn4QWT4ngvheCng6euk2+p4TgxWKkG6CfnzHB2IQFhrDQLT7Jo
         M7aq9Sy1866jiXcr0DD9cTpB3eZ7HXc0PIeDjUw4tYE0dATpZVfEjPkqK7CGjiiATHSQ
         L6GRFKAy+7xh8qgCqUizQWEkrxe5UJM58xKCAYPu1PJZrNsBKSkxtyhF3xkrDZaTGFgK
         Yv3K2QwioimRQ/QGlqgalTXjeCAZPEkGf7zfMKpUUzvxWLKs/fo9nd4vkHlDcY4XV2iH
         hPYg==
X-Gm-Message-State: AOAM532iZt9Ji0ivu7Gaf9BQSnHtjPFCCUmYNfwBaOixIOeJ3odZi0Mt
        yGedBaPzZlpjtxB8t259d/GT4n139/pifmj7+iXY3AJzb5ruSTxBEUo3+2jt0dVdQQr3/XBee31
        RMXWRHqYKhlsZ
X-Received: by 2002:a1c:9dcd:: with SMTP id g196mr14067084wme.30.1612806349440;
        Mon, 08 Feb 2021 09:45:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJySadVeryWc/7vUh0Ff5GUx9WW+NmNKRHZ1APFrdW/36WG32BOLRjVIUusY0dEbCCjEaVe5ig==
X-Received: by 2002:a1c:9dcd:: with SMTP id g196mr14066748wme.30.1612806338634;
        Mon, 08 Feb 2021 09:45:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d16sm29664733wrr.59.2021.02.08.09.45.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 09:45:36 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jing Liu <jing2.liu@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-4-jing2.liu@linux.intel.com>
 <ae5b0195-b04f-8eef-9e0d-2a46c761d2d5@redhat.com>
 <YCF1d0F0AqPazYqC@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC 3/7] kvm: x86: XSAVE state and XFD MSRs context switch
Message-ID: <77b27707-721a-5c6a-c00d-e1768da55c64@redhat.com>
Date:   Mon, 8 Feb 2021 18:45:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YCF1d0F0AqPazYqC@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/21 18:31, Sean Christopherson wrote:
> On Mon, Feb 08, 2021, Paolo Bonzini wrote:
>> On 07/02/21 16:42, Jing Liu wrote:
>>> In KVM, "guest_fpu" serves for any guest task working on this vcpu
>>> during vmexit and vmenter. We provide a pre-allocated guest_fpu space
>>> and entire "guest_fpu.state_mask" to avoid each dynamic features
>>> detection on each vcpu task. Meanwhile, to ensure correctly
>>> xsaves/xrstors guest state, set IA32_XFD as zero during vmexit and
>>> vmenter.
>>
>> Most guests will not need the whole xstate feature set.  So perhaps you
>> could set XFD to the host value | the guest value, trap #NM if the host XFD
>> is zero, and possibly reflect the exception to the guest's XFD and XFD_ERR.
>>
>> In addition, loading the guest XFD MSRs should use the MSR autoload feature
>> (add_atomic_switch_msr).
> 
> Why do you say that?  I would strongly prefer to use the load lists only if they
> are absolutely necessary.  I don't think that's the case here, as I can't
> imagine accessing FPU state in NMI context is allowed, at least not without a
> big pile of save/restore code.

I was thinking more of the added vmentry/vmexit overhead due to 
xfd_guest_enter xfd_guest_exit.

That said, the case where we saw MSR autoload as faster involved EFER, 
and we decided that it was due to TLB flushes (commit f6577a5fa15d, 
"x86, kvm, vmx: Always use LOAD_IA32_EFER if available", 2014-11-12). 
Do you know if RDMSR/WRMSR is always slower than MSR autoload?

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E7741E97F
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 11:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352969AbhJAJTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 05:19:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23790 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352995AbhJAJT3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Oct 2021 05:19:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633079864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DGyCDTmKE3Puz9hbd1Bqa93m33TW7tkrO1GY0BEiFrw=;
        b=G8Jl4WIKybM+gbcJax7zMZCw3ZEU2m9u551hCKS16JVEO7DJOd0IsOiVp9aJMUdjrrHgJT
        MszqJ/XlzOn3w9bdqN+qvjwLLnJ8WNDgr/+1lRE25I4ENeneZAmE1JgDKJv69vRf4NkY0I
        2HIAmdhQZAawn6qQcfiyhuxGF8DTAI0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-jezCQGtYPberA3CPaXz6-g-1; Fri, 01 Oct 2021 05:17:43 -0400
X-MC-Unique: jezCQGtYPberA3CPaXz6-g-1
Received: by mail-wm1-f69.google.com with SMTP id x23-20020a05600c21d700b0030d23749278so3466554wmj.2
        for <kvm@vger.kernel.org>; Fri, 01 Oct 2021 02:17:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DGyCDTmKE3Puz9hbd1Bqa93m33TW7tkrO1GY0BEiFrw=;
        b=O8DN4jZ+Q5gvuEDQqes3PK8CKcyimFKvacl1eO7PdYU2HaMwJQAkAPrmMwf+Ca5eRq
         tKF7LryFAp1XUhBc8AaNHKlG1AjOD9DiWEa5JZl0YG0USgM2339o0ekPbh+tnbtPyYTI
         9pgZIjo8OBNrvW1SQZegslSObOaJ2k7Rtdc6JBF0bjx6tllk30BffTP8/GPnBfP6ZWCV
         g24qnmM7mR4IdGtqmPUJIJFQHNVfyQH7/Dt7HNvWwDZDcdWAOBgKaKTl3ZJmMSu1nOxe
         /acK7HVf08052j+Qf0bSFjTjD5VTEbiDpHmb/wQCLl6aFeDh9zQKC37bAann+y0i5lUC
         n/AQ==
X-Gm-Message-State: AOAM532wJCKXVovgYSnaA7EO0ltwR6m61Ww9Am+WPHqM74jk/R/UaJ+B
        lh+3UJ8wvJ4Aj2UhB21F/SsAXH5ZuEVwNjJ4PQrwuWF3lwHPA8S/vbH69L8W/jDKznqiJ3a5jvX
        Myc9S9b1Ev+fk
X-Received: by 2002:a5d:50cf:: with SMTP id f15mr11412189wrt.237.1633079862449;
        Fri, 01 Oct 2021 02:17:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykQN7F6N2QxuVMMTUM6KC2ZEoYFdxkECApzvn9zqqq6yIts+XecYdFr57VC3hfX4SQo9I9wA==
X-Received: by 2002:a5d:50cf:: with SMTP id f15mr11412163wrt.237.1633079862215;
        Fri, 01 Oct 2021 02:17:42 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id n186sm7166424wme.31.2021.10.01.02.17.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 02:17:41 -0700 (PDT)
Message-ID: <48151d08-ee29-2b98-b6e1-f3c8a1ff26bc@redhat.com>
Date:   Fri, 1 Oct 2021 11:17:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 7/7] KVM: x86: Expose TSC offset controls to userspace
Content-Language: en-US
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-8-oupton@google.com>
 <20210930191416.GA19068@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210930191416.GA19068@fuller.cnet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/21 21:14, Marcelo Tosatti wrote:
>> +   new_off_n = t_0 + off_n + (k_1 - k_0) * freq - t_1
> Hi Oliver,
> 
> This won't advance the TSC values themselves, right?

Why not?  It affects the TSC offset in the vmcs, so the TSC in the VM is 
advanced too.

Paolo

> This (advancing the TSC values by the realtime elapsed time) would be
> awesome because TSC clock_gettime() vdso is faster, and some
> applications prefer to just read from TSC directly.
> See "x86: kvmguest: use TSC clocksource if invariant TSC is exposed".
> 
> The advancement with this patchset only applies to kvmclock.
> 


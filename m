Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E951318BC7
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 14:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbhBKNQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 08:16:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231723AbhBKNO1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 08:14:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613049179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0/ylQ7keEMZM2vB0HyhfCbqRdrDWn9fjEd0p4iPMH+0=;
        b=ZrN1Hp6uR5vLudFdPw2lMEXsT0qmHm9wGJMwypm55O1WhwhlcYbt/Msq3heDho8wSyewFJ
        qPO0a3sayxLu/g1SDKonLcFSHCziAg+hha4JsMmR6ltfA1M/QsnwqTolbtmIKRNeNAaUou
        L/Amd0v2LGtnlzE+bUyZTeHMF0GvhZ0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-UHkKVnsDNby3BNeAQ3ap2g-1; Thu, 11 Feb 2021 08:12:55 -0500
X-MC-Unique: UHkKVnsDNby3BNeAQ3ap2g-1
Received: by mail-wm1-f70.google.com with SMTP id z188so5505793wme.1
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 05:12:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0/ylQ7keEMZM2vB0HyhfCbqRdrDWn9fjEd0p4iPMH+0=;
        b=TdQlJepTcesrapw24Bs0fh7IKRNPlkNtSAfhWFbpm5p02/kBWHKZYo8qvkyFaZ3EBa
         toJZka2WK0E4np3Z/jnk8pPKC0oeVVdKp9+WFQpioO7yOZQSwrnXHMH8/r6r1NS7eYKM
         IEVLrTWk2jE+hgix3D6x0bLlT8FRPj1K8ezripSVucLi9jTmubzgYl3uY8XAsdaIrsqT
         n2j4h9X6qMTK8CIuWThmb2zttvSyux2NAf4ZcOZudUWCiRCnYC3kDDkLYiTlu43qOpFz
         tOV6h9w3Ounl6PJ1HTaXHf1wdAI+dReIlrmY+CN4gkip3j+FDVL7vTbyk36iptdg+A6f
         6S9w==
X-Gm-Message-State: AOAM531YkugLC4iA60yU6tBcEiumganAc532XnmC+oJiEbEwCCADdJSu
        Uo8LhQ0QEUINSS6k8Ja4lVbXt7gAWiSExWT7OfiGNVuoP9/qCx9xAD8d2BwVhCZ4mDeWBKoawrw
        KxcPXFwPq/Mmx
X-Received: by 2002:a7b:ce17:: with SMTP id m23mr4931798wmc.80.1613049174454;
        Thu, 11 Feb 2021 05:12:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw86omcCww3Grv2u7cdAIF2HtKvKP9q6OhV7oOtjNAZkcp+eceV3hNZ0A7cl6cyg04lcA/l/Q==
X-Received: by 2002:a7b:ce17:: with SMTP id m23mr4931784wmc.80.1613049174338;
        Thu, 11 Feb 2021 05:12:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d15sm739684wru.80.2021.02.11.05.12.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 05:12:53 -0800 (PST)
Subject: Re: [PATCH 09/15] KVM: selftests: Move per-VM GPA into perf_test_args
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
References: <20210210230625.550939-1-seanjc@google.com>
 <20210210230625.550939-10-seanjc@google.com>
 <CANgfPd8itawTsza-SPSMehUEAAJ4DWtSQX4QRbHg1kX4c6VRBg@mail.gmail.com>
 <YCSOtMzs9OWO2AsR@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <756fed52-8151-97ee-11f2-91f150afab42@redhat.com>
Date:   Thu, 11 Feb 2021 14:12:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YCSOtMzs9OWO2AsR@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/02/21 02:56, Sean Christopherson wrote:
>>> +       pta->gpa = (vm_get_max_gfn(vm) - guest_num_pages) * pta->guest_page_size;
>>> +       pta->gpa &= ~(pta->host_page_size - 1);
>> Also not related to this patch, but another case for align.
>>
>>>          if (backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
>>>              backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB)
>>> -               guest_test_phys_mem &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);
>>> -
>>> +               pta->gpa &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);
>> also align
>>
>>>   #ifdef __s390x__
>>>          /* Align to 1M (segment size) */
>>> -       guest_test_phys_mem &= ~((1 << 20) - 1);
>>> +       pta->gpa &= ~((1 << 20) - 1);
>> And here again (oof)
> 
> Yep, I'll fix all these and the align() comment in v2.

This is not exactly align in fact; it is x & ~y rather than (x + y) & 
~y.  Are you going to introduce a round-down macro or is it a bug?  (I 
am lazy...).

Paolo


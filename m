Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FD338E6F2
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhEXMvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:51:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232533AbhEXMvp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621860617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CDp1ck/iqkKh9LawS0wyID9rHbM7Yj39rDbTlMGePF8=;
        b=NTPDJWUl6EG2AXRF7Sg8IrNWBhIcie5f7xvUa4mMhfTWvokBNKP7hfdNbu35QvPUjomli7
        noXrOKT28ex9fTdbs0SBF2g8bPeJylfsPQrXX/ggdQbGkGQKyv6dlMZezwzwJOnwHy7o2+
        oYQNvpECSgKqWTHZaOxKvYoiBxAvNZw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-pb3VrTp_NAmtG-Bs4DgPWA-1; Mon, 24 May 2021 08:50:13 -0400
X-MC-Unique: pb3VrTp_NAmtG-Bs4DgPWA-1
Received: by mail-ej1-f70.google.com with SMTP id eb10-20020a170907280ab02903d65bd14481so7214542ejc.21
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 05:50:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CDp1ck/iqkKh9LawS0wyID9rHbM7Yj39rDbTlMGePF8=;
        b=fDfbrCjDIqJxPM/jLZcBl38XN2JDhdkhHgkoHMTKWPFCqfC8tn/cw3N7VtcC/pyzan
         1ixk06IaBIL/kqtFeGWeZfKdhhWGI4lY7cJX7Tv+HND1g+AmChcXL9YDtn3Q86dM8NuK
         HJMabIFd4j+gX/5vmBFZNFl5pSklgH4g5XZJL0DE8TyRNIUSoKqPYdRhzuFaZ9+1JDtc
         npoaSH+39/GMeGOWCzhuy0O4HOM+/u44mCBcIvGDTHwJsmYpI1wr95jKVWN7aLbrd/qI
         mA8UTs8E/Pq7SH9wu4brFbdeCUuN93EtASJiQr3XOxc28YaNyDAe3qb5PgEPIGPVpxbT
         4Egg==
X-Gm-Message-State: AOAM531O/j4D8KivFoItvfbj6bnyJ1lqK8L5Efr1FlY/gJWAuO2uhJFt
        K4/eBhljONDfka4XAgBrdTx0j+jO3l/gnnIelTERkCYJaoTKsKDy8/hVe2pthJgRegEyysulJU5
        bxFUiqlEz789I
X-Received: by 2002:aa7:c818:: with SMTP id a24mr25743610edt.310.1621860612147;
        Mon, 24 May 2021 05:50:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvANIP0le26y8Ljpy1/s82WQkRAbDgWKIXeH4TNB3SU6/kXlBn39VXdRZ5rH3YOey8E2fKXQ==
X-Received: by 2002:aa7:c818:: with SMTP id a24mr25743600edt.310.1621860612011;
        Mon, 24 May 2021 05:50:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id lv10sm8307827ejb.32.2021.05.24.05.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 05:50:11 -0700 (PDT)
Subject: Re: [kvm PATCH v6 0/2] shrink vcpu_vmx down to order 2
To:     Jim Mattson <jmattson@google.com>, Marc Orr <marcorr@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <kernellwp@gmail.com>
References: <20181031234928.144206-1-marcorr@google.com>
 <CALMp9eT-tKmt2nFy4eQ0bfLqHrZd9EruQ45p=AsR2aPWnj97gA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <34bf7026-4f83-067e-f3d8-aad76f9cf624@redhat.com>
Date:   Mon, 24 May 2021 14:50:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eT-tKmt2nFy4eQ0bfLqHrZd9EruQ45p=AsR2aPWnj97gA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/21 22:58, Jim Mattson wrote:
> On Wed, Oct 31, 2018 at 4:49 PM Marc Orr <marcorr@google.com> wrote:
>>
>> Compared to the last version, I've:
>> (1) dropped the vmalloc patches
>> (2) updated the kmem cache for the guest_fpu field in the kvm_vcpu_arch
>>      struct to be sized according to fpu_kernel_xstate_size
>> (3) Added minimum FPU checks in KVM's x86 init logic to avoid memory
>>      corruption issues.
>>
>> Marc Orr (2):
>>    kvm: x86: Use task structs fpu field for user
>>    kvm: x86: Dynamically allocate guest_fpu
>>
>>   arch/x86/include/asm/kvm_host.h | 10 +++---
>>   arch/x86/kvm/svm.c              | 10 ++++++
>>   arch/x86/kvm/vmx.c              | 10 ++++++
>>   arch/x86/kvm/x86.c              | 55 ++++++++++++++++++++++++---------
>>   4 files changed, 65 insertions(+), 20 deletions(-)
>>
>> --
> 
> Whatever happened to this series?

There was a question about the usage of kmem_cache_create_usercopy, and 
a v7 was never sent.

Paolo


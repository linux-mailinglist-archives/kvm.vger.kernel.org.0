Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B7428BFB7
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 20:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387832AbgJLS3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 14:29:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387669AbgJLS3O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Oct 2020 14:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602527353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1KMvAtvKDBYaeH7vpaDvjszCZ2uUkSgLQMYqCcOYOR0=;
        b=hMtYyoAupBNyx46f4BhwXZz3WzQp/NB9AwAwnu7TJkELdMffhK8kkf3lYZoYlpmVrs84Y0
        6A4fYBqwn0KWQxbNeQdzB+57KajSDmCz2QxbQpb96Ft+2zigZtQ4wHAQOHfXVlsI3BYCYQ
        bODJJQOrYwvMB6N5ikAtrBuwXiLEFK0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-KZgc_9BnPniHY7vs0UjlWg-1; Mon, 12 Oct 2020 14:29:11 -0400
X-MC-Unique: KZgc_9BnPniHY7vs0UjlWg-1
Received: by mail-wm1-f71.google.com with SMTP id p17so5399559wmi.7
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:29:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1KMvAtvKDBYaeH7vpaDvjszCZ2uUkSgLQMYqCcOYOR0=;
        b=qanFWnn4ueedD7WI9RbOHBoziYEp+tBb/t9IZLlOViD0rHI713QbpJe1yT69l6NuOg
         ErTRFGc2t7LetVs2HyHDMwgZf0yyx8z+jVuf+ypoXhgmC3B4u0btggPK6dJJUM7SVlfE
         PeMfT2UlKgWKKn8vRHyAC9eUVkw+WlTSjGq+bXfCTtXUMThxDw2BuLVkA3dHqWHDKt4e
         uSLIHB0+p3Ej3AHt6Z1AfK2BPh+ES3bgCM8WDgeC2YnBIpu8g8uk8L8fffBdMDYWb0Hg
         XKXnD2qEoiEl71Abdn3glwqwqXiGjJs1JCETe8L1mJZlErR6C87dW6YcIuqYdXIBEpL1
         8zlA==
X-Gm-Message-State: AOAM531Hcph645JUzaYkd/OJV3vYkNapBGNAfcE8NhPY6OIIM4rUWgDP
        Ffb/WlWETQkVIb5jopN4T9UfHpDOysC+uOhMXp+WyqZTk3vfaDunw22aZv8hQVC+V1N74qzbbVA
        zcq/geVFZjT7W
X-Received: by 2002:a1c:111:: with SMTP id 17mr7762732wmb.74.1602527350737;
        Mon, 12 Oct 2020 11:29:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynpw1y9FYhWbRA9/cpFOKjuhGtatNwL3a/KAEU0swRGxGG8xz04FD6gk3kiD5Ga6/aansVPw==
X-Received: by 2002:a1c:111:: with SMTP id 17mr7762718wmb.74.1602527350535;
        Mon, 12 Oct 2020 11:29:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7ffb:1107:73ba:dbcf? ([2001:b07:6468:f312:7ffb:1107:73ba:dbcf])
        by smtp.gmail.com with ESMTPSA id z11sm25459560wrh.70.2020.10.12.11.29.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 11:29:10 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Add a VMX-preemption timer
 expiration test
To:     Nadav Amit <nadav.amit@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        KVM <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
References: <20200508203938.88508-1-jmattson@google.com>
 <D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com>
 <20201012163219.GC26135@linux.intel.com>
 <5A0776F7-7314-408C-8C58-7C4727823906@gmail.com>
 <CALMp9eTkDOCkHaWrqYXKvOuZG4NheSwEgiqGzjwAt6fAdC1Z4A@mail.gmail.com>
 <E545AD34-A593-4753-9F22-A36D99BFFE10@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <386c6f5a-945a-6cef-2a0b-61f91f8c1bfe@redhat.com>
Date:   Mon, 12 Oct 2020 20:29:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <E545AD34-A593-4753-9F22-A36D99BFFE10@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/20 20:17, Nadav Amit wrote:
>>
>> KVM clearly doesn't adhere to the architectural specification. I don't
>> know what is wrong with your Broadwell machine.
> Are you saying that the test is expected to fail on KVM? And that Sean’s
> failures are expected?
> 

It's not expected to fail, but it's apparently broken.

Paolo


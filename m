Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2048F392CE6
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 13:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhE0LnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 07:43:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233044AbhE0LnA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 07:43:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622115687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9g5WJOZ1ArT+DH36KHFOthJm1HE1wLwgNsiQzlQx0kU=;
        b=JheqoagPludxXNrVOoVnQpXcwpWPLb+zkLBJ1g5LWKMVf5AQcVm19ZOgNtT/6zoRV+IfxT
        UEIpZ35h89Nbf535zm/C2aZcXgaRO3XWBalP8FjWefbOF+luNIovRACPdOPJMikKK+UBX0
        ypGMnx6uIWVxL8h550T62SVZbwKKnk8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-m7zu7eLvNMial4rTdyLbnw-1; Thu, 27 May 2021 07:41:26 -0400
X-MC-Unique: m7zu7eLvNMial4rTdyLbnw-1
Received: by mail-ej1-f71.google.com with SMTP id p18-20020a1709067852b02903dab2a3e1easo1556453ejm.17
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 04:41:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9g5WJOZ1ArT+DH36KHFOthJm1HE1wLwgNsiQzlQx0kU=;
        b=Izq8vralE6FU5tLV3F1Q2v2XjX1kRQ0B0Ja4r5t/fHlbHHTcIXjTDj1IQTYWNUs6eC
         P30kb90IOH9LdcTMdNonoC5HkMDYcPIzQ4icxhnheoheTp0e2gDZjWQLdR9kzMUu0uCH
         kOJAs4e/SBX9mTptlIswkKgxO6x7bgrVKBa762sAQhcmOjPNy86N4Oe69UXHGW2XtVH3
         6rxv1j+JkT+mha5eqVGtT8AzUoBI/HFdVz9HigM2bN5pMbHK0yz1nu1ymN9xnw0AbY9B
         VgSJzWBbC4udP9KMXrmT7OLCet8ANofB3K1xS0UHmg43TuWbgSIIIoPmjrBGBueZA2aH
         j1lg==
X-Gm-Message-State: AOAM531eHaIO1D8b4JqkiubpQXiJIdkrln0njzLlG3ux59TJC1WRvw5l
        IWMAEh00JeaX/zLeOfGaCQ/Iabk7DjyMDPFe0pQw5GzVb9cMAB2mxGOxD90whAPAwMLuo/qTp36
        qBURby0+X3fsq
X-Received: by 2002:a17:906:fc0d:: with SMTP id ov13mr3238482ejb.504.1622115684862;
        Thu, 27 May 2021 04:41:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR8doZB7oXK5ggHD/FP2CwDu+40ZAeoM0tGfNqmRDSRO08FtdFL3e8lusOFGppcCAGKK8otg==
X-Received: by 2002:a17:906:fc0d:: with SMTP id ov13mr3238463ejb.504.1622115684593;
        Thu, 27 May 2021 04:41:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bv17sm858059ejb.37.2021.05.27.04.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 04:41:23 -0700 (PDT)
Subject: Re: [PATCH v2 00/13] More parallel operations for the TDP MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210401233736.638171-1-bgardon@google.com>
 <c630df18-c1af-8ece-37d2-3db5dc18ecc8@redhat.com>
 <YK6+9lmToiFTpvmq@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <822c0a82-2609-bd76-2bb6-43134271bccf@redhat.com>
Date:   Thu, 27 May 2021 13:41:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YK6+9lmToiFTpvmq@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/21 23:34, Sean Christopherson wrote:
>> Applied to kvm/mmu-notifier-queue, thanks.
> What's the plan for kvm/mmu-notifier-queue?  More specifically, are the hashes
> stable, i.e. will non-critical review feedback get squashed?  I was finally
> getting around to reviewing this, but what's sitting in that branch doesn't
> appear to be exactly what's posted here.  If the hashes are stable, I'll probably
> test and review functionality, but not do a thorough review.

It's all in 5.13 except for the lock elision patch, for which I was 
waiting for a review.  I'll post that patch separately.

Thanks,

Paolo


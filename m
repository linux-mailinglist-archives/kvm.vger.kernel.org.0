Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0FE197992
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgC3Kpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:45:41 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:35829 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729525AbgC3Kpj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:45:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585565138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ynhonVYHrZ/r6D7ZTeqD8BdSmQrtIP7lxgjgux91PO8=;
        b=LJ9eLKA2oHhYAx9vn4KCTbO/7lTa9x3gnxBQm0WNgMJOz0mYNcoM+XCKWTFQMhwbB1y0HN
        DdZkfa6oLoOc3TjcufX2cUJ/SYJTuQ31wBFxN8ffuNzvIhsTh4zxUqYWPjfefCQJxy2O9G
        JEoEGG0NOZgFWwHELIkgdyCOtciYB0U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-acNh-6muPIiXQgiSUnJjqA-1; Mon, 30 Mar 2020 06:45:35 -0400
X-MC-Unique: acNh-6muPIiXQgiSUnJjqA-1
Received: by mail-wr1-f72.google.com with SMTP id i18so10996108wrx.17
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 03:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ynhonVYHrZ/r6D7ZTeqD8BdSmQrtIP7lxgjgux91PO8=;
        b=NC597JkImuYSPllIJo+Thg8/Tume+nQ4DjSRIrl/dkeAMm/TJoWrDMddvNaAiFVC8h
         rQC/8TCw4/Noh5Br4S2jyGXnOQSSt6hkKIi7tLfrJzqWCCYbnKzUD+TiIvQ6d4FSUy19
         XAA83RxgW98ZtNbpXzlqToS5mKdUgHqGVqm1svr5uumQiQoOLT8SizgATVBjml6uynre
         KVS7UTRaNrcGxf5GGs03S0MQYdrEsC0oZRevg84f8xIMTR1ca0E6p1GZJ5kQglAYG0M5
         7x6UHAc6RIhuFXsqtW0Y7v+63JvNdqBT7Gj0jXgQEZk7cbxuYcPjcOwCS2EKq90m2yg/
         vYLQ==
X-Gm-Message-State: ANhLgQ2iDG944mwhxyRUPZ9YUmaZxiqIXAe1hnLD8OaWunKlI4FmH8I4
        KvcrV734LbUas4ijJf9Vc4tjvxTaKYsrdnw8lL6hlDiO0lfSnu22UyspCxpLIhus3L//xNqXYlN
        XRKBgGirTxx5T
X-Received: by 2002:a1c:62c5:: with SMTP id w188mr12922611wmb.112.1585565134032;
        Mon, 30 Mar 2020 03:45:34 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtRBvzmfOe/mqrcy4dakt/2hWa1Y+CxOuslpf0+gmoGJxhI0JnXw7g3K92OORRg/P22v2uGOg==
X-Received: by 2002:a1c:62c5:: with SMTP id w188mr12922595wmb.112.1585565133825;
        Mon, 30 Mar 2020 03:45:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea? ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id w204sm20754765wma.1.2020.03.30.03.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 03:45:33 -0700 (PDT)
Subject: Re: [PATCH 1/3] KVM: x86: introduce kvm_mmu_invalidate_gva
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Junaid Shahid <junaids@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200326093516.24215-1-pbonzini@redhat.com>
 <20200326093516.24215-2-pbonzini@redhat.com>
 <20200328182631.GQ8104@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2a1f9477-c289-592e-25ff-f22a37044457@redhat.com>
Date:   Mon, 30 Mar 2020 12:45:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200328182631.GQ8104@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/03/20 19:26, Sean Christopherson wrote:
>> +	if (mmu != &vcpu->arch.guest_mmu) {
> Doesn't need to be addressed here, but this is not the first time in this
> series (the large TLB flushing series) that I've struggled to parse
> "guest_mmu".  Would it make sense to rename it something like nested_tdp_mmu
> or l2_tdp_mmu?
> 
> A bit ugly, but it'd be nice to avoid the mental challenge of remembering
> that guest_mmu is in play if and only if nested TDP is enabled.

No, it's not ugly at all.  My vote would be for shadow_tdp_mmu.

Paolo


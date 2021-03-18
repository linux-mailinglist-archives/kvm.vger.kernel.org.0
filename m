Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12C03408E4
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 16:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhCRP2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 11:28:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231963AbhCRP1w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 11:27:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616081271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fgGNe6pYqF3G1iiSjJIodaSGoLEC/55ejSs288fVPig=;
        b=Guk+UpfFW9qMXKI+NZqDP554sIh3t+hIfNvDN+mtpYMLu7bCD+gjbaNlZ54vT31I9zE15N
        i/pDkqmw50ZyTq9mxtl7VAVDuZgq1AhQ3qzkZ5+DYvEgltazJBgO4Syf2o0OkEjp1ZEoLT
        0a5KDsxyr079drkYmpADtzbrSeJLp3c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-YA3kZhbcPRqfli4oITVX7w-1; Thu, 18 Mar 2021 11:27:49 -0400
X-MC-Unique: YA3kZhbcPRqfli4oITVX7w-1
Received: by mail-wm1-f70.google.com with SMTP id l16so7329432wmc.0
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fgGNe6pYqF3G1iiSjJIodaSGoLEC/55ejSs288fVPig=;
        b=fJjNqx1mp6B5AxJ2b5jegTkP6qaZcDvaFybuIuFAOdYairniJXzU0QSf0t26bxHKwi
         vifUC0zVJDJQS4WZhIP82N9JP66OOuhqqp21PxL8/BEeQ4wWQj/8c3ZBLDjTu2I21zZw
         +gQ9wpWYkYwU3+ro5/3tmCR6CCUjnC6B7ZUpUTKLbuik9pTifvgDqySCxAVqvsnmfl8s
         /Q4H+EcBg3MP0Nb9o89iyOdR1kDQT2Pyxv9UZzK5lpTuzbNr1SMnxiEsjOeH8DgYy3ac
         md2vkhoIPuDqmctFr6DEmZJQuQabbUI3l3Ll9Wn9pRzTgd2UvBhljd8fQxP5zAjaFDRh
         vDhQ==
X-Gm-Message-State: AOAM531EqRbd+jVQxjeMPLBrimfQVI4+aYM3cpJSvduZpgbU1HJz//9I
        7RJyagQfDD6y9p0gkCSNrll+IP+j3d6EEAuoK18VVzz389TlQOycvjajcVqLJ4Y73Zo/1W+rErA
        tsG4hYUqjLvOW
X-Received: by 2002:adf:f908:: with SMTP id b8mr10050007wrr.184.1616081268412;
        Thu, 18 Mar 2021 08:27:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMJZdILgqNxmoytUTzhob6gd4zzmT+5qAqlbFrFHwZF1NMt5YH892UM8zQS+6AK7lS4gkCkQ==
X-Received: by 2002:adf:f908:: with SMTP id b8mr10049993wrr.184.1616081268215;
        Thu, 18 Mar 2021 08:27:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w6sm3421740wrl.49.2021.03.18.08.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 08:27:47 -0700 (PDT)
Subject: Re: [PATCH v2 6/4] selftests: kvm: Add basic Hyper-V clocksources
 tests
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210318140949.1065740-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <71087049-de1e-88f9-9af1-e44e3bf21e96@redhat.com>
Date:   Thu, 18 Mar 2021 16:27:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210318140949.1065740-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/21 15:09, Vitaly Kuznetsov wrote:
> +
> +	/* 1% tolerance */
> +	GUEST_ASSERT(delta_ns * 100 < (t2 - t1) * 100);

Since I needed to add a printf to understand this one, I have also added 
a host-side test using KVM_GET_MSR, it doesn't hurt.

Paolo


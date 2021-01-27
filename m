Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C54D305BC3
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 13:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237474AbhA0Ml5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 07:41:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237949AbhA0MdB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 07:33:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611750695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dgQSgW3ijk3bfBjv9KOVXpYx518XkO0noyOhJ5F3E3A=;
        b=E8LtICtCTm0s0hfqaKznxyh3jhWC1bvHISiTHdHooPcUh3x6yKl+FW72Y6jkBJxwlOoKKe
        ELo61wXW8if4f3jj9ai09DrD2KiL0AUZO+PilEnEFBft+nUmVFO3r3lO1PDVc5+1eKkYOQ
        TL+rM5G3RZ2nSzM9v3+UCr8QA5CTEL4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-i5dQJDjhNC6w4VgEfqDA9g-1; Wed, 27 Jan 2021 07:31:33 -0500
X-MC-Unique: i5dQJDjhNC6w4VgEfqDA9g-1
Received: by mail-ej1-f71.google.com with SMTP id by20so588709ejc.1
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 04:31:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dgQSgW3ijk3bfBjv9KOVXpYx518XkO0noyOhJ5F3E3A=;
        b=lFHgoR4TS2cO9x2BGweXP+YepdCmQQDrcpeNh0QQRPjXGqCNOcKJidYNgQ2Lguu+HL
         0s69FMl5ntVOvvHvtEUvY4G2YL9bd+vGJieyY/UnfCnA6CYGwhO4aZ4k148kc+jA7f0k
         BB7z/B3eX+ExwEPctjGCYViB4pf0Z7xfVs2dPDReGnXYUzbHK+/k7QTjLYtjNSLr3Nbz
         HyrkF5+4ka1GNprLhMMJhzjBzGtCSSeiD55ADjg9Ri3tfCDF3lW4VkKPJRb+erSKhpt1
         9gXwrQ51xCkvh2YbOGIu7gxiPaN5JSmQ7Ye8PVRpoUrtw0L3qMwrSKmLUGLQGE+8UNtq
         KPmg==
X-Gm-Message-State: AOAM530DAqlG9QNfl8Xdz4wY0R2k8csHxSMNV+GaO/0A+fX+zBR00m74
        Mu5yhRICXFQVy1i+rDoDkeORPreGcOcCPxk+8NwttwCRLfqymqbzZtUcJ2UlXL2+T1PaENZhhyb
        +zLFlYfnW3yQT
X-Received: by 2002:a17:907:abc:: with SMTP id bz28mr6574912ejc.395.1611750691895;
        Wed, 27 Jan 2021 04:31:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzc1oAB7j1wPAy0H1JqWaCELA6b6i1a9cpil4PF64M6jRO8hfU1/lDcvxu5D+D2AA/JEXdYfQ==
X-Received: by 2002:a17:907:abc:: with SMTP id bz28mr6574901ejc.395.1611750691764;
        Wed, 27 Jan 2021 04:31:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s18sm1250961edw.66.2021.01.27.04.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 04:31:30 -0800 (PST)
Subject: Re: [RESEND PATCH 2/2] KVM: X86: Expose bus lock debug exception to
 guest
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        kernel test robot <lkp@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210108064924.1677-3-chenyi.qiang@intel.com>
 <202101090218.oqYcWXa4-lkp@intel.com>
 <cfc345ea-980d-821d-f3a6-cea1f8e7ba03@redhat.com>
 <3c38f1be-47c3-e8f8-ee72-9642e99ac93f@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bc5dfd66-e9bb-cb1b-fbb7-d3ecefeac52b@redhat.com>
Date:   Wed, 27 Jan 2021 13:31:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <3c38f1be-47c3-e8f8-ee72-9642e99ac93f@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/21 01:57, Chenyi Qiang wrote:
>>
>> What is the status of the patch to introduce 
>> X86_FEATURE_BUS_LOCK_DETECT (I saw 
>> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2389369.html)? 
>>
>>
>> Paolo
> 
> Fenghua sent the v4 patch and pinged x86 maintainers, but still no 
> feedback.
> https://lore.kernel.org/lkml/YA8bkmYjShKwmyXx@otcwcpicx3.sc.intel.com/

Ok, please include it when you repost.  Thanks!

Paolo


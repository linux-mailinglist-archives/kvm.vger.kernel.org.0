Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8968849E147
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 12:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbiA0Ljw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 06:39:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26954 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230084AbiA0Ljv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 06:39:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643283590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OFSkuMtjecn1Ao4cJOdT1Z78AZK8OQBI3s9NUphbPsk=;
        b=TUap3GLJacoPIJKE1/W2y/4mJtCOszNlGoIfQixRPq9ki/QDhkEG6QlJWIEGHNGWZareUM
        pjmY4R7HqLEpuvGWPRUXsmEzw2ei4oTAQvfam/VT7qnAV8wnn4GLtkLqQY0J7ujNCXhUTf
        3sLYyIiBWkXdaYi/fAh8brptYx44Q+U=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-3Gewl8HXN0ik_QjVnr_WDQ-1; Thu, 27 Jan 2022 06:39:49 -0500
X-MC-Unique: 3Gewl8HXN0ik_QjVnr_WDQ-1
Received: by mail-ej1-f71.google.com with SMTP id r18-20020a17090609d200b006a6e943d09eso1185875eje.20
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 03:39:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=OFSkuMtjecn1Ao4cJOdT1Z78AZK8OQBI3s9NUphbPsk=;
        b=wTEeTP7uXmrKbv3Q3I663O1ohkWQoNyQojMvyloGa5wE3dWfkvqd+PSSKDj9+9/4UK
         sg7HHxbqQEgvqLGKYhLj0A+PDc13v3O9uh9G+OUE+2HrYOcEvsZEannnCv+N5vH8A2Oo
         CyjSvKfZ3JtEpqmWOl+rM9EW2OUqPtUH0TYxjmyidF5PoIZ1HRgBJ8eYQzA/9MCCJL2B
         Wn5TbjoxJDrIE9DcbExzUzRafDFb5/NXmqvSYhX62BP3zIFawuEg1zRBSR1YxM60aozU
         /6w69HiGGXIJ2hfFhhAol8GQIZyu9FQsI2Pn/1WCahHnIVsqzB+TktxZxEmYFbln6+Ll
         1EEA==
X-Gm-Message-State: AOAM531wxG7XpJgPR2m+0H+BQKXLee9nuCWl+kpnaoaHwXNYN6skjmDB
        R6cwP+aqNbW9LbjpaSmcgGs7jxLb9bO67k4WxqRZSSHOQAoIlSNjjw/4MCSQnc7AhaW+YsgZpL3
        zuI9XcMUtq7Rl
X-Received: by 2002:a17:907:c01:: with SMTP id ga1mr2609883ejc.704.1643283587972;
        Thu, 27 Jan 2022 03:39:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/ecef1ehAnS/s3juMqmFUV0MZItUuLZABwzSOHgyfLpFssLK+a8jbbDkdglPCHV4YWtBZrg==
X-Received: by 2002:a17:907:c01:: with SMTP id ga1mr2609870ejc.704.1643283587763;
        Thu, 27 Jan 2022 03:39:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id f19sm6524950edu.22.2022.01.27.03.39.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 03:39:47 -0800 (PST)
Message-ID: <444e5056-d593-7fea-afe6-6a35ee9c90b3@redhat.com>
Date:   Thu, 27 Jan 2022 12:39:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm:queue 305/328] arch/x86/kvm/x86.c:4345:32: warning: cast to
 pointer from integer of different size
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        kernel test robot <lkp@intel.com>
References: <202201270930.LTyNaecg-lkp@intel.com>
 <32f14a72-456d-b213-80c5-5d729b829c90@gmail.com>
 <5ec51239-0ec3-a9fd-a770-ea6020815e0c@redhat.com>
In-Reply-To: <5ec51239-0ec3-a9fd-a770-ea6020815e0c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/22 09:09, Paolo Bonzini wrote:
> On 1/27/22 09:08, Like Xu wrote:
>>>
>>
>> Similar to kvm_arch_tsc_{s,g}et_attr(), how about this fix:
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 8033eca6f..6d4e961d0 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4342,7 +4342,7 @@ static int kvm_x86_dev_get_attr(struct 
>> kvm_device_attr *attr)
>>
>>          switch (attr->attr) {
>>          case KVM_X86_XCOMP_GUEST_SUPP:
>> -               if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>> +               if (put_user(supported_xcr0, (u64 __user *)(unsigned 
>> long)attr->addr))
>>                          return -EFAULT;
>>                  return 0;
>>          default:
> 
> This has to be (at least in the future) 64 bits, so it has to use 
> copy_to_user.

Nevermind, I was still asleep.  Of course you're right.

Paolo


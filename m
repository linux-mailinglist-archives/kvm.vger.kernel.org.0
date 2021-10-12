Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFFD42AA3E
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 19:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhJLRF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 13:05:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48636 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231886AbhJLRF4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 13:05:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634058234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8N9AZrtbCUIg+TOcuzcXy+gxTtxbcJnCpc/kWAxsisE=;
        b=BFUWVmGMn1HfqEX3coqS0NFvQ1TtcqHJ0ONjG2FJFvxkM/53CDLHB7AILcs2a5bpTq8jM+
        LzuBxr79XKV9vJcn8cAFieH0UtWNdoz8GPU9B9TUsAHPmSNSLYZxpkKuvinuMxW01ndhPw
        HuY4pzRZmjSVLgEjHMaNYDiIWS3MkT4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-uK2F3vNTPvmw8X2BhTd-SA-1; Tue, 12 Oct 2021 13:03:53 -0400
X-MC-Unique: uK2F3vNTPvmw8X2BhTd-SA-1
Received: by mail-wr1-f71.google.com with SMTP id d13-20020adf9b8d000000b00160a94c235aso16301470wrc.2
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 10:03:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8N9AZrtbCUIg+TOcuzcXy+gxTtxbcJnCpc/kWAxsisE=;
        b=oewaL7fbF3oWMFv66Hq+1/66Nx4b4Q5i3Yi2eaz+OkLjOwJO7nIyqV3DpiOezkRXlH
         KeiUg5rvMQX6igI+Ig19Sbt4PqyFu599cWxCoWIqtxiM0yYlaHEp4xE7vGck2lWDWs9Q
         wt/ITB1Y+CR4EYpGuu1hQBeVUxYnhhUTNRtSVbzwxy7802QK+tldM1+cPhG+ygvGCwXD
         J0CBe9iR5a1iLh0Bwgbp7HZYp1XPVI5ESPiZbaG5m87RiN5FOjxtUz3Us74XOVkckmc5
         02T5WcRgdQdv42Fe/Nob/UChlygkToshOi4238AsRRQW3CItujSx0QB71Z1rZXieWiJ9
         1t6g==
X-Gm-Message-State: AOAM532GftOqAUGN8mHLgWi/r+ZkSgktgcexrhbGDuT7Szlt+OltAZ67
        tCgCw3rPH9ax8cf/UOvgGLsMyxJstgfuAKc9Rc3DBkaWoTTZW7bX/K1AjXgd0YvXGkEjWxDKuWO
        CJ++ddVR+V/ub
X-Received: by 2002:a05:600c:2304:: with SMTP id 4mr7212468wmo.91.1634058231821;
        Tue, 12 Oct 2021 10:03:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwi+JbzPS/yYKPH5w4nLLjYQlyxy5Yj2TA/POpelys/M2iGbaCFdKBMDfeABuopr3hTFA4yRQ==
X-Received: by 2002:a05:600c:2304:: with SMTP id 4mr7212422wmo.91.1634058231542;
        Tue, 12 Oct 2021 10:03:51 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a127sm2818740wme.40.2021.10.12.10.03.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 10:03:50 -0700 (PDT)
Message-ID: <22c1c59f-9b7c-69fa-eff3-1670b94c77af@redhat.com>
Date:   Tue, 12 Oct 2021 19:03:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE ioctl
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com
References: <20211012105708.2070480-1-pbonzini@redhat.com>
 <20211012105708.2070480-3-pbonzini@redhat.com>
 <644db39e4c995e1966b6dbc42af16684e8420785.camel@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <644db39e4c995e1966b6dbc42af16684e8420785.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 18:57, Jarkko Sakkinen wrote:
>> +
>>   static const struct file_operations sgx_vepc_fops = {
>>          .owner          = THIS_MODULE,
>>          .open           = sgx_vepc_open,
>> +       .unlocked_ioctl = sgx_vepc_ioctl,
>> +       .compat_ioctl   = sgx_vepc_ioctl,
>>          .release        = sgx_vepc_release,
>>          .mmap           = sgx_vepc_mmap,
>>   };
> I went through this a few times, the code change is sound and
> reasoning makes sense in the commit message.
> 
> The only thing that I think that is IMHO lacking is a simple
> kselftest. I think a trivial test for SGX_IOC_VEP_REMOVE_ALL
> would do.

Yeah, a trivial test wouldn't cover a lot; it would be much better to at 
least set up a SECS, and check that the first call returns 1 and the 
second returns 0.  There is no existing test for /dev/sgx_vepc at all.

Right now I'm relying on Yang for testing this in QEMU, but I'll look 
into adding a selftest that does the full setup and runs an enclave in a 
guest.

Paolo


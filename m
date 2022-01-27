Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F63D49DC3F
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 09:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237652AbiA0IJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 03:09:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47618 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237585AbiA0IJ4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 03:09:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643270996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cM2HKsmK08OfL8jGWwW+um5b2lMtV5DOC0x0cbQAmhM=;
        b=MK3uPiGYEYHe93epkDWNp/+yQDIYbjLjAtMml38aVYM3YTXwlkB2dr/5oX+hwo8HgMOqTi
        /S6SBky3EhYhREYodXeXMLxr6xm6mLnblbJlHDPB7XMbIsFc2PZcZM4q8x43W9cheKkY83
        Ckm0xZ2NA1j5tBeKwvybZqM0QluXL44=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-5Ge-DQz1P4uBlAp7FYrwIQ-1; Thu, 27 Jan 2022 03:09:54 -0500
X-MC-Unique: 5Ge-DQz1P4uBlAp7FYrwIQ-1
Received: by mail-ed1-f69.google.com with SMTP id ed6-20020a056402294600b004090fd8a936so986797edb.23
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 00:09:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cM2HKsmK08OfL8jGWwW+um5b2lMtV5DOC0x0cbQAmhM=;
        b=ZbiftdLtLj38EE71oS9ycpwHPd2X/Y1HdQUfMxvBadqN2OzAbRn4BY9BknYXHwReyA
         E7Wmui8sIQSauG6S/qP9GcVodn88MPulU9RSriJxgWXyLy7hKKZEA3rHYmiK8E2A+cU1
         sqa7rl2n5kKA+tKtUwtDDkIbwetuRM4AisMjNT2Wi1Vrv8iB49j9tRsr0GBoQbdUSo2Q
         g4HD25Vte4QSo/BRENeq1XpCaAqC1ZuAJIYZAhEwWWsPDolJBnliGyRfFYAHYjMtffIW
         m8pnTIqLI4n9jJNRJ0aMkeBqkmQ7ZhkyHUW825K/1CenCiwZB9M0mJOLJIpN/qvOk34v
         oBEQ==
X-Gm-Message-State: AOAM5304x7v8kKV0Jqo6Q3J+l01AOal+18098EyuqYZYJhePCPF37J4X
        woHvzHXRAlq2tDKAnvAzbzDgUDpZSPtOq1KGO1d5g+8UrQZKZFCpTJ+mTnFmUFcGVCcrDPmnm99
        Mhr2Wpu2y70bJ
X-Received: by 2002:a17:907:3f19:: with SMTP id hq25mr346102ejc.568.1643270993490;
        Thu, 27 Jan 2022 00:09:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/S3OdswWbxjgDD12/Gz9k6kEU7r5zkdS89BHYRPhp3/3N7xd7OqkVXXE32fAQtRoct70WDg==
X-Received: by 2002:a17:907:3f19:: with SMTP id hq25mr346089ejc.568.1643270993255;
        Thu, 27 Jan 2022 00:09:53 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id s19sm8798813edr.23.2022.01.27.00.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 00:09:52 -0800 (PST)
Message-ID: <5ec51239-0ec3-a9fd-a770-ea6020815e0c@redhat.com>
Date:   Thu, 27 Jan 2022 09:09:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm:queue 305/328] arch/x86/kvm/x86.c:4345:32: warning: cast to
 pointer from integer of different size
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        kernel test robot <lkp@intel.com>
References: <202201270930.LTyNaecg-lkp@intel.com>
 <32f14a72-456d-b213-80c5-5d729b829c90@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <32f14a72-456d-b213-80c5-5d729b829c90@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/22 09:08, Like Xu wrote:
>>
> 
> Similar to kvm_arch_tsc_{s,g}et_attr(), how about this fix:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8033eca6f..6d4e961d0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4342,7 +4342,7 @@ static int kvm_x86_dev_get_attr(struct 
> kvm_device_attr *attr)
> 
>          switch (attr->attr) {
>          case KVM_X86_XCOMP_GUEST_SUPP:
> -               if (put_user(supported_xcr0, (u64 __user *)attr->addr))
> +               if (put_user(supported_xcr0, (u64 __user *)(unsigned 
> long)attr->addr))
>                          return -EFAULT;
>                  return 0;
>          default:

This has to be (at least in the future) 64 bits, so it has to use 
copy_to_user.

I'll send a v2 of the patches today.

Paolo


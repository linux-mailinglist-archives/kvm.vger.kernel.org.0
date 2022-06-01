Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFEA53A284
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 12:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351965AbiFAK26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 06:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351930AbiFAK24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 06:28:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93F63167C7
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 03:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654079334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7k3dNvL+kB73yhmA0kTPSDqqr6xZ7Ku8u2rQ5x2shkU=;
        b=Drsr0gp+Tm8tmkRvD2HloALCRaRk2+NxFsn9Xcmlsed1qWb8SDh1NvKX9djgmTDAhKjJg1
        1kpMxK9cIud5hYWfgcJ0yyju3UDC7kiJuK91wyL01sBL6v8YXhQmuL9qTrZad0tRJTMzzI
        U9x1UcP/cUzimwk1kGW/mdyX23j249Y=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-Wji1sgrkMJClL1Nyvhxb2g-1; Wed, 01 Jun 2022 06:28:53 -0400
X-MC-Unique: Wji1sgrkMJClL1Nyvhxb2g-1
Received: by mail-ej1-f71.google.com with SMTP id gf24-20020a170906e21800b006fe8e7f8783so728433ejb.2
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 03:28:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7k3dNvL+kB73yhmA0kTPSDqqr6xZ7Ku8u2rQ5x2shkU=;
        b=3dpJtyHA/VbKMK2LI0EAfrVGkm+lioO2gLHR/2bR01SHNGMVOUuaZSJ3zH3aNvuZLe
         ywH0+t8I5I3dnuJjMNPsGZrhHSMx/1z73tN8obxzI+ow3KhYybVX0IDHZXHgaqocY31E
         j5/3SkzTRZNJUt05X8eeLfGrv6UTFyjkWeU9eeFs/dxev+aJ0h7iqZ+1u47a0abF7UlN
         +WTURN76gw40uYl/TJTvK3oU+EyHIUnpq/bUHQgMA9uHg/zT01z81z3KOP7aJWoKeoBS
         i1r0n2tHdKZEWY/0Zdad3/x+iyMlS9NcU1CCI56hLCcxB8S0TOqFsBm24vtDqTAnId8c
         wUfw==
X-Gm-Message-State: AOAM5330hyyovYlH4aBXxYKQAa6asbdzhaAY/l9j7H3NAwcOtGHa4+Et
        jT8ulcOoziV9nOJg33XIwWwnOQRXvfvoG+pajQfHdY+ahfI/tUgilXIUJSO2vxRU2YgSMw7G4D8
        Z7fduVWCBni1Y
X-Received: by 2002:a05:6402:1b1e:b0:42b:cf35:2621 with SMTP id by30-20020a0564021b1e00b0042bcf352621mr36491774edb.352.1654079332402;
        Wed, 01 Jun 2022 03:28:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJww6nufX+AqsADomqW/YE38MZe+crrSuKmiVbO2h1cjvcGOCTX3nIVriGttaMM54YP4JNtwxw==
X-Received: by 2002:a05:6402:1b1e:b0:42b:cf35:2621 with SMTP id by30-20020a0564021b1e00b0042bcf352621mr36491756edb.352.1654079332126;
        Wed, 01 Jun 2022 03:28:52 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id m25-20020a509999000000b0042bd25ca29asm742996edb.59.2022.06.01.03.28.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 03:28:51 -0700 (PDT)
Message-ID: <d507c4d0-d1b3-adef-8081-64b8b6ee33ae@redhat.com>
Date:   Wed, 1 Jun 2022 12:28:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH kernel v2] KVM: Don't null dereference ops->destroy
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Sean Christopherson <seanjc@google.com>
References: <20220601014328.1444271-1-aik@ozlabs.ru>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220601014328.1444271-1-aik@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/22 03:43, Alexey Kardashevskiy wrote:
> A KVM device cleanup happens in either of two callbacks:
> 1) destroy() which is called when the VM is being destroyed;
> 2) release() which is called when a device fd is closed.
> 
> Most KVM devices use 1) but Book3s's interrupt controller KVM devices
> (XICS, XIVE, XIVE-native) use 2) as they need to close and reopen during
> the machine execution. The error handling in kvm_ioctl_create_device()
> assumes destroy() is always defined which leads to NULL dereference as
> discovered by Syzkaller.
> 
> This adds a checks for destroy!=NULL and adds a missing release().
> 
> This is not changing kvm_destroy_devices() as devices with defined
> release() should have been removed from the KVM devices list by then.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Queued, thanks.

Paolo

> ---
> Changes:
> v2:
> * do not touch kvm_destroy_devices
> * call release() in the error path
> ---
>   virt/kvm/kvm_main.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f30bb8c16f26..e1c4bca95040 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4299,8 +4299,11 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
>   		kvm_put_kvm_no_destroy(kvm);
>   		mutex_lock(&kvm->lock);
>   		list_del(&dev->vm_node);
> +		if (ops->release)
> +			ops->release(dev);
>   		mutex_unlock(&kvm->lock);
> -		ops->destroy(dev);
> +		if (ops->destroy)
> +			ops->destroy(dev);
>   		return ret;
>   	}
>   

Queued, thanks.

Paolo


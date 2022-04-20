Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BFE508D42
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 18:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380561AbiDTQaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 12:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237190AbiDTQaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 12:30:14 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900C530F7E;
        Wed, 20 Apr 2022 09:27:27 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id bg25so856476wmb.4;
        Wed, 20 Apr 2022 09:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=r6/1LJ6bEhhBqRzSKXoEbeE0rdJ9IO1XFkaZ2FJo+Pg=;
        b=VVR/LaYO3RzlOTagucqR1RML8ejvY1psyRLd5bTXvzz7zuT7wgzJwqxg9fnsaVRI/6
         rs7RO2dZR8EwPmC+O/bpn6OkhZoiIa3mQ2kjFFALt9yFJ0eie4tc6GIsJUmzutMQNrAx
         KvSKAZbaumWANWDULse2KHAmFrpMvkzF1zM7rTUaybz98BrSvD0K54EGEDk0nxH1KVCM
         XXw356u/Kb1+DyZkHioKyvI6HWxkNftkOgkUIY/pRXWddHQ3crbc0bhHSSfp0pHmkUCO
         mHCVkXqcWdQ7aV76PRNCBq6BV09p+0WqpWtQvcYIxlciVc9pMy+8zpJJjOlvcDvYL09x
         IizQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=r6/1LJ6bEhhBqRzSKXoEbeE0rdJ9IO1XFkaZ2FJo+Pg=;
        b=7YH2nCfEZHObJ+zqeF1D1E4U4yjHMzfzVKoY9XPneGWKFFrfymNJazYp+BO3ok2Hhl
         MxwKVzV0uh+/UvOo8bmTlxc6rBkfkZFB8gHXx+uWcpQIQUgbm97fy/+2bybTvKrD6cEz
         9w/fdqv9WLs6flN67WYGBEcFoa0s2EWWtbJnZ09+W+By4y+iHL9+hI8jj9QgUTmreJn6
         Bdwp1TI4DN8mI6ciA5cshlrBkms1QIiO8A23uA431fI2vgX06LEP+Oz45fg2oxma194+
         KypDUiVCK8jGcUbzkiMf+ToeuqlyEhvj9fypetgDZUwsA9q/oDDCnyv/gPbfb9gouqn8
         7wRw==
X-Gm-Message-State: AOAM531xEX+QdkN4EoVeyDZcferDxtVY2z4l9rZnLvP3s4dSAis8aZNy
        iEgI2bo6qLXneBkoPTXztL8=
X-Google-Smtp-Source: ABdhPJwF7KqLSE5LuXgnXxDM3O1OPa2mvlH5rrta77NPNra9zi504DUMJ5Ylo71dUF7S6KaqrNQR+g==
X-Received: by 2002:a1c:f211:0:b0:381:6c60:742f with SMTP id s17-20020a1cf211000000b003816c60742fmr4766034wmc.130.1650472046061;
        Wed, 20 Apr 2022 09:27:26 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 2-20020a1c1902000000b00380d3873d6asm210737wmz.43.2022.04.20.09.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 09:27:25 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <e5f976aa-d993-7e4a-c69d-e02e86bec1f4@redhat.com>
Date:   Wed, 20 Apr 2022 18:27:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Babu Moger <babu.moger@amd.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, seanjc@google.com
Cc:     vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        wanpengli@tencent.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
References: <165040157111.1399644.6123821125319995316.stgit@bmoger-ubuntu>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/2] x86/cpufeatures: Add virtual TSC_AUX feature bit
In-Reply-To: <165040157111.1399644.6123821125319995316.stgit@bmoger-ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/19/22 22:53, Babu Moger wrote:
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b24ca7f4ed7c..99a4c078b397 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -674,7 +674,7 @@ void kvm_set_cpu_caps(void)
>   
>   	kvm_cpu_cap_mask(CPUID_8000_001F_EAX,
>   		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
> -		F(SME_COHERENT));
> +		F(V_TSC_AUX) | F(SME_COHERENT));
>   
>   	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
>   		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |

Not needed, since V_TSC_AUX is not exposed to guests.

I made the changes and queued both patches.

Paolo

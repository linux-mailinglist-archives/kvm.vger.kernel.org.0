Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3D04F4351
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 23:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbiDEO6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 10:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242829AbiDEOwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 10:52:51 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587BDBF97B;
        Tue,  5 Apr 2022 06:22:08 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n63-20020a1c2742000000b0038d0c31db6eso1643841wmn.1;
        Tue, 05 Apr 2022 06:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=42pOK9ccsa2jjY6xkX2nlkLQuEWFF7Bk+1tRnHi96GI=;
        b=elxm4jPIzGaUvukiv9OCU5WC3tOGLd7yKl16vtPMjYLE2D5vFxSu4UENBZY1jkWQd2
         gOF0EXNlk1Fxq7wWKfP64LZ9Lg/+oqitp28xGmjju2Vkx+Knrdqcy4Vp8fVJHIwrWSUL
         oou5HkSB9BYIJciPQ6RAN/m4mrcZ2Ef8Cd4iXB6ZbhUp2bCYp7NLp5TiPyJpX248EeJe
         mGJbHmtfNDMd8HzPL6KNQX2D4U//E4h5ToOjWrCOYb9Ztt3fBVe0WLC6Vn2muqOlHZvQ
         eXyrZ3aXEr1cM2rg9qsqcyT/cxSuFyF5tX4HiEM9gZC6YRsgcmCuVTyZFh+mPH4cQ9h2
         rQWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=42pOK9ccsa2jjY6xkX2nlkLQuEWFF7Bk+1tRnHi96GI=;
        b=za3KDLgHTvQ3fyG+npZJwlssjg/RPBLX6XsdepXB/fSXCBS8TRfRdawDstyomjnuav
         NHIvEP2DT6H6cFqed9clyAKHrum+dNyHwS9qrsU+lnxugJwlv0eLN8/MHK3UiGUExy9K
         9X54pe8ZYDpWGPitWQIKS+C/ziyIUH5wJ04hMiips8ReUMZFTEYAN3/OwqvJI3239aG+
         56iWU2V2Fzd8EXxED0gyE6X8nJj5DZd3Y9tvBtZJ8ylM3Y0zlmaWqeUmOqFBv87Al6+d
         o7quqwtwaU3ebvFGD4jANuSbC/r1pJ99KxLOFCXzZAuGByRvJhp/oKxc2y9prLRlGfrQ
         mKlw==
X-Gm-Message-State: AOAM533lRcqD7hJoHLLWLDxcXs7HP1JD0COEwoMhA3QGYlpLGPu3vWCM
        kWj4ZH+bsd3IGKRQZ6v2vWdWZnZIVt0=
X-Google-Smtp-Source: ABdhPJyTin3MLm6VWeXoWs2sztSrpiJP4TM84DHkMzMprxV9AoMxcZavqxVYsbM9sc2yNIC9cEX+RA==
X-Received: by 2002:a05:600c:6026:b0:38e:746b:9414 with SMTP id az38-20020a05600c602600b0038e746b9414mr3202828wmb.141.1649164926604;
        Tue, 05 Apr 2022 06:22:06 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id t4-20020adfe104000000b00205b50f04f0sm11951822wrz.86.2022.04.05.06.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 06:22:06 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <aad44bd9-7f5b-58e6-523a-ce9df57bee30@redhat.com>
Date:   Tue, 5 Apr 2022 15:22:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 039/104] KVM: x86/mmu: Disallow fast page fault on
 private GPA
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <56693f2e1e5bb1933288272255c662d6d04b94df.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <56693f2e1e5bb1933288272255c662d6d04b94df.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX requires TDX SEAMCALL to operate Secure EPT instead of direct memory
> access and TDX SEAMCALL is heavy operation.  Fast page fault on private GPA
> doesn't make sense.  Disallow fast page fault on private GPA.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e9212394a530..d8c1505155b0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3185,6 +3185,13 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   	u64 *sptep = NULL;
>   	uint retry_count = 0;
>   
> +	/*
> +	 * TDX private mapping doesn't support fast page fault because the EPT
> +	 * entry needs TDX SEAMCALL. not direct memory access.

"the EPT entry is read/written with TDX SEAMCALLs instead of direct 
memory access".

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> +	 */
> +	if (kvm_is_private_gpa(vcpu->kvm, fault->addr))
> +		return ret;
> +
>   	if (!page_fault_can_be_fast(fault))
>   		return ret;
>   


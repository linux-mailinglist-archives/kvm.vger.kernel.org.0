Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE1050E4B0
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 17:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbiDYPue (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 11:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242987AbiDYPu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 11:50:29 -0400
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD30114811;
        Mon, 25 Apr 2022 08:47:24 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id k2so1050719wrd.5;
        Mon, 25 Apr 2022 08:47:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N+T1uFPvpk+TduyCL4G0Lj8jCl9tpg3TC+NZTTHptlQ=;
        b=gnbi5e6bs1AJIPkNhhik3bDbXSFhmlu6YiFF11e8OSaT1EqP/juZY83oc63tHeY7yi
         P6VnPJFYtYJjp1y35PZsDROgyDb5n3WFi5yAtViWXJt1mOKuAHF1FSGk5zicdOxK1G2r
         8FeqOPcqK0wPMLZ7vjkAgtU2BYAajx6Xcog8cW5P4Bde1EibDEEhp2EwZ+oG312de2Ci
         kZmGEsRx9jt2gGZbk7UPJkeEYf8LEJjNuJyFLc5c8cBmK1F09zcVkiyYn4o6FYVEyTJT
         YdJtz/H/lxYzrKIQTMBvJ9VQgq/W5Xx7WazW2URTAcUBG52YtIRju5b53PnPuDBwPsfS
         6TVg==
X-Gm-Message-State: AOAM530glSJd0pN1x7GF2hydDnSyY8gRa+gl64+J+qTD7JiIr5RH1RvS
        /tLMnozbAFWdkxSPfulVTfQ=
X-Google-Smtp-Source: ABdhPJzeHBcy+eirxYwlBNqy9SGdHBCiIZ2bHe4FTpA1rEMp3ZPsyGKv/vGBFibEfEDeX1eJPju45Q==
X-Received: by 2002:adf:d1c7:0:b0:20a:963a:1c9f with SMTP id b7-20020adfd1c7000000b0020a963a1c9fmr15001365wrd.221.1650901642851;
        Mon, 25 Apr 2022 08:47:22 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id y9-20020a05600015c900b0020adb0e106asm4217430wry.93.2022.04.25.08.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 08:47:22 -0700 (PDT)
Date:   Mon, 25 Apr 2022 15:47:21 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v3 07/34] x86/hyperv: Introduce
 HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK constants
Message-ID: <20220425154721.xunncuuuzs55nwc7@liuwe-devbox-debian-v2>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-8-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414132013.1588929-8-vkuznets@redhat.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022 at 03:19:46PM +0200, Vitaly Kuznetsov wrote:
> It may not come clear from where the magical '64' value used in
> __cpumask_to_vpset() come from. Moreover, '64' means both the maximum
> sparse bank number as well as the number of vCPUs per bank. Add defines
> to make things clear. These defines are also going to be used by KVM.
> 
> No functional change.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  include/asm-generic/hyperv-tlfs.h |  5 +++++
>  include/asm-generic/mshyperv.h    | 11 ++++++-----
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
> index fdce7a4cfc6f..020ca9bdbb79 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -399,6 +399,11 @@ struct hv_vpset {
>  	u64 bank_contents[];
>  } __packed;
>  
> +/* The maximum number of sparse vCPU banks which can be encoded by 'struct hv_vpset' */
> +#define HV_MAX_SPARSE_VCPU_BANKS (64)
> +/* The number of vCPUs in one sparse bank */
> +#define HV_VCPUS_PER_SPARSE_BANK (64)

I think replacing the magic number with a macro is a good thing.

Where do you get these names? Did you make them up yourself?

I'm trying to dig into internal code to find the most appropriate names,
but I couldn't find any so far. Michael, do you have insight here?

Thanks,
Wei.

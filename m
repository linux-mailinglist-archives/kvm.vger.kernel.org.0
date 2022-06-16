Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C38154E95E
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 20:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358050AbiFPSaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 14:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiFPSae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 14:30:34 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E21517E5
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:30:33 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 129so1989862pgc.2
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2MT5n56eTX6232MDw48kDPyLYs/2jjEt1BMxZqgDQ7Y=;
        b=NiI1HQfcQv9+8Gev0XwEu2FM2Dnd0HiUaP/qsnNNqaSLlODazHtJE57NTHV3K8NG36
         +6JD7VOiwlw49flHCCuycXXpY47ajI0Uf/ZR71NZkslFgx2HEF1zG97CaXBHkwQnJBnC
         HBdlcRIB6olNA3yCBp3JmFyivdT6qwTxQ2x7F/zfEyxUSLtJZyZZR2AvfX8Nf0DF5zaV
         2vN0XwqHb8v1LkDecKeLaQ3yj8mH9DqIsa94VPncBqxCdcOtu1grcByFjBhMZlbwku7H
         hCwAyFnj5kr/Fiu7z7kHeQCJZBi5DMpIhPE0/USwQh+sgBE+svEJr609w8p2WYmJ9EPm
         UZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2MT5n56eTX6232MDw48kDPyLYs/2jjEt1BMxZqgDQ7Y=;
        b=JtjLLknIAc7iEMUwgCnsDHFscKQsaNSpr1RpRARHn8oSRil6ye5oCxu/63To5s9uYs
         zIVp6rqq46bTfzZ7fanymQ/9cMNb3jY3h4CLFIFENpBqoaGNw5fN+yPj1iFAsFj93Es2
         jSUwJp6vDk7aScag6t1X0iFCtWfzgL/spLaJSMDQ1O4pbcLt5u/3q0SIS9J1iXYV4gFv
         l/GfFptE+8bZ/HtG3ryRbqXPHQJucpazPtccF2x91rcQBwi71hJeS4EwDfteJInhJVWK
         ebDFczsZNba0MMhahQg+IDzGbXcSl6zet8Ae9H8UIo0NXaifA14WU5bJKdiFZWv0GiOO
         uLLw==
X-Gm-Message-State: AJIora8FMOF1d9HYmzT+ydeIYZREovRGmkq5UHIdCAtDWN4dbh8T2Vb/
        hVWvX6N1g7FMzW2Htp1M5Gy1Hg==
X-Google-Smtp-Source: AGRyM1tI9hHUbW41iWk6dh+FQxhk3UabYeJ7/dBN2tGZhweR9tWzqxVjaW6nhVpVFEnOxdHwmneWHA==
X-Received: by 2002:a62:a113:0:b0:51c:1b4c:38d1 with SMTP id b19-20020a62a113000000b0051c1b4c38d1mr5975138pff.13.1655404233174;
        Thu, 16 Jun 2022 11:30:33 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z4-20020a62d104000000b005180c127200sm2110263pfg.24.2022.06.16.11.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:30:32 -0700 (PDT)
Date:   Thu, 16 Jun 2022 18:30:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, like.xu.linux@gmail.com, jmattson@google.com,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/3] x86: Remove perf enable bit from
 default config
Message-ID: <Yqt2xBFkFZw3VaQT@google.com>
References: <20220615084641.6977-1-weijiang.yang@intel.com>
 <20220615084641.6977-2-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615084641.6977-2-weijiang.yang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022, Yang Weijiang wrote:
> When pmu is disabled in KVM by enable_pmu=0, bit 7 of guest
> MSR_IA32_MISC_ENABLE is cleared, but the default value of
> the MSR assumes pmu is always available, this leads to test
> failure. Change the logic to make it aligned with KVM config.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

Paolo's more generic approach is preferable, though even that can be more generic.

https://lore.kernel.org/all/20220520183207.7952-1-pbonzini@redhat.com

> ---
>  x86/msr.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/msr.c b/x86/msr.c
> index 44fbb3b..fc05d6c 100644
> --- a/x86/msr.c
> +++ b/x86/msr.c
> @@ -34,7 +34,7 @@ struct msr_info msr_info[] =
>  	MSR_TEST(MSR_IA32_SYSENTER_ESP, addr_ul, false),
>  	MSR_TEST(MSR_IA32_SYSENTER_EIP, addr_ul, false),
>  	// reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
> -	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51889, false),
> +	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51809, false),
>  	MSR_TEST(MSR_IA32_CR_PAT, 0x07070707, false),
>  	MSR_TEST(MSR_FS_BASE, addr_64, true),
>  	MSR_TEST(MSR_GS_BASE, addr_64, true),
> @@ -59,6 +59,8 @@ static void test_msr_rw(struct msr_info *msr, unsigned long long val)
>  	 */
>  	if (msr->index == MSR_EFER)
>  		val |= orig;
> +	if (msr->index == MSR_IA32_MISC_ENABLE)
> +		val |= MSR_IA32_MISC_ENABLE_EMON & orig;
>  	wrmsr(msr->index, val);
>  	r = rdmsr(msr->index);
>  	wrmsr(msr->index, orig);
> -- 
> 2.31.1
> 

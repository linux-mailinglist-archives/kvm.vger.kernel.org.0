Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C3A4CC8C5
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 23:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbiCCWXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 17:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236829AbiCCWXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 17:23:53 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC1810C518
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 14:23:06 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id u2so5502954ioc.11
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 14:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZDyiSlnb5GR7xrn7fUYkxCnceCJroYsxkkmzYk8uQRE=;
        b=ag53/yTwXTxhCQbM9pPl3IpMKr6LjiZSdosbbviofABa7AdlyoMrCLv3bsdPqVv0p+
         iTOqkHdRZMYsm1ilIzRYnbi+r7JNcoJ4X3pY1ysHIGDt/zfsfN5H9VBwI2yWSFey6f8l
         pSfHfRONoEURjqigSBC6VHjz3rkJEfEuYxQwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZDyiSlnb5GR7xrn7fUYkxCnceCJroYsxkkmzYk8uQRE=;
        b=nF72fI99F9fHi84jOdg5TwMhM8FGWQIZr6GxWajKPnKNTMU3VBd6QqHqg6dyU+VBBM
         zkNoieY0amAR+t2U1ZS+c/Xmk38bV67kVxotqKiHdMZeTJOLrZlFimTVMFkgQ9nbCFgD
         RpKeAfSqcjA4tpoEUOZbvBREfy/Fe2kk3cYWa2l+8C0tfH1Wloz6gVqX9LhQEb5WCePV
         cAToCvaToejoYucsFQ1pbAl/RWB+ihE7VG4xltpMfqw1Tjlk/Y8mzOrvIlCruf3CpMuK
         mHVM6++AUYIlP4Xf2sv/gP0lQ2RtxNMX8D0cuWMmTS6hTLXxgiQ8t1iYM1RawN6/Wc6Y
         mlWg==
X-Gm-Message-State: AOAM53192TtZa2eELpaT8Ni7z1+WFF1mB4TulM1Gb4vQhBnKOjL/oDqm
        um/66rjAjPFh9gP8rLTBXWBefQ==
X-Google-Smtp-Source: ABdhPJz7kZop8pzmlRYqjAVCDw9u/15uKLiDsRH78UZ9ON8/oBompeYFzxt2VeTy/Z9I+5Yqesv23g==
X-Received: by 2002:a05:6638:160d:b0:314:e6e5:4699 with SMTP id x13-20020a056638160d00b00314e6e54699mr30638055jas.47.1646346185995;
        Thu, 03 Mar 2022 14:23:05 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id t14-20020a056e02160e00b002c60907ec07sm3009032ilu.62.2022.03.03.14.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 14:23:05 -0800 (PST)
Subject: Re: [PATCH V2 3/3] selftests: kvm: add generated file to the
 .gitignore
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>
Cc:     kernel@collabora.com, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220302180121.1717581-1-usama.anjum@collabora.com>
 <20220302180121.1717581-3-usama.anjum@collabora.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d319d47e-0b98-fe94-8b24-65fa8a61889b@linuxfoundation.org>
Date:   Thu, 3 Mar 2022 15:23:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220302180121.1717581-3-usama.anjum@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/22 11:01 AM, Muhammad Usama Anjum wrote:
> Add hyperv_svm_test to the .gitignore file.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>   tools/testing/selftests/kvm/.gitignore | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 7903580a48ac..4d11adeac214 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -21,6 +21,7 @@
>   /x86_64/hyperv_clock
>   /x86_64/hyperv_cpuid
>   /x86_64/hyperv_features
> +/x86_64/hyperv_svm_test
>   /x86_64/mmio_warning_test
>   /x86_64/mmu_role_test
>   /x86_64/platform_info_test
> 

Applied to linux-kselftest next for Linux 5.18-rc1

thanks,
-- Shuah

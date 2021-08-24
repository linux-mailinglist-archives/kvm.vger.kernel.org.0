Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FBE3F60B7
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 16:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbhHXOmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 10:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237851AbhHXOmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 10:42:04 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1264BC061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 07:41:20 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id s16so20719448ilo.9
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 07:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nZ5/kWskf9Zw4rI98AC9wLSRU3TgzRLaTG5KOGZNlhQ=;
        b=ZGr/bc97J1XNzq2DwO9uRfAH/07Cr6M8sEBPi0LASYNdMqxHcAkKh6eJzTd0VwLiHn
         Pmne3BahuZ8fLGzqVLdQ9V6MfPbgIfjIrXYzbmUO7c7Vl6R2km2pVM8ipntdUCQxMg/p
         mXgjT1Yq8/UgJKAWDDEd/cJOVmO7gTiL1bNN0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nZ5/kWskf9Zw4rI98AC9wLSRU3TgzRLaTG5KOGZNlhQ=;
        b=q81KdbOV6ERrzk/r7kWcDCdNshWYjJ3EDRskTaAlsHDjpGML9gwlR5ziU2fOMeCgS4
         NBp3XcaGEbf0X7A6f1cbE/v259RCefKGX88kt/Cragq3X/iqchITK4xezaJ8CYOsQeQp
         iZo5t5P2eRJTUCXopXqncsbVQlXjPZYsrj2BGDJtF5ni3AvDatAnZFCIXC71tRe4NUMf
         jm7QO1NufSjSw66S2/OZSYRhT+odZ16vs9Ue5eiG5iD7nU7BAu6+osN+LXTA6KMk/0Td
         dgPuOYfv81blsJZZ6ppudflGt4u+tkoGh9dryBQkOQERC/RNS88ytknZhXhGNKZDzfq1
         pGHQ==
X-Gm-Message-State: AOAM531MGlgeIV7cEKaIWw/JW4Y2bWCBiD+ksisQeD6CNG/6pYMzD0OC
        C8dQcS0HdqW4BMgvJ5lIutz/MQ==
X-Google-Smtp-Source: ABdhPJw9j9ppr2heAki1wUs8m9B6VocqtAW2i+bFHkhMaLPSczAs2JoacK/14uO4ycBIZg/W06l91w==
X-Received: by 2002:a05:6e02:1b88:: with SMTP id h8mr27350444ili.237.1629816079540;
        Tue, 24 Aug 2021 07:41:19 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u7sm10505397iog.27.2021.08.24.07.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 07:41:19 -0700 (PDT)
Subject: Re: [PATCH linux-next] tools: remove unneeded semicolon
To:     CGEL <cgel.zte@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        jing yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <cf335b749549186343bcb8f73a17c38afe6c5bdd.1629196408.git.jing.yangyang@zte.com.cn>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <dcbc9904-ea32-ce30-a76b-ae41262c551a@linuxfoundation.org>
Date:   Tue, 24 Aug 2021 08:41:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <cf335b749549186343bcb8f73a17c38afe6c5bdd.1629196408.git.jing.yangyang@zte.com.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/19/21 9:38 PM, CGEL wrote:
> From: jing yangyang <jing.yangyang@zte.com.cn>
> 
> Eliminate the following coccicheck warning:
> 
> ./tools/testing/selftests/kvm/access_tracking_perf_test.c:234:3-4:Unneeded semicolon
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: jing yangyang <jing.yangyang@zte.com.cn>
> ---
>   tools/testing/selftests/kvm/access_tracking_perf_test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> index 71e277c..02a1c0f 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -231,7 +231,7 @@ static void *vcpu_thread_main(void *arg)
>   		case ITERATION_MARK_IDLE:
>   			mark_vcpu_memory_idle(vm, vcpu_id);
>   			break;
> -		};
> +		}
>   
>   		vcpu_last_completed_iteration[vcpu_id] = current_iteration;
>   	}
> 

We can't accept this patch. The from and Signed-off-by don't match.

thanks,
-- Shuah

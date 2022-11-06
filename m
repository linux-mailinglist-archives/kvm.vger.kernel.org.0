Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1AE61E0EB
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 09:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiKFIoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 03:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiKFIoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 03:44:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDFCDEEA
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 01:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667724189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hi3Kr9yF0ps/ryGJaamxGMVq7pZEA+iBNyz5JEVKO1E=;
        b=XYeqRwS+jUezrrhgbRQNtN1cf+2u2lmImxsZwYOHO9KNYVpqmHeu3m9bfKJ4sbN07YRkQO
        xNHQGd9canIAmpFpJBXIhN8T97dpzs1OOxCYwccmJgY8fruo2a58bV3pkaZfC9Wmk519S0
        /4jjDKc+ldEekz/7DyaVPS8JYSije3g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-509-eWQhrWXYP4-PyTsPpvJf1w-1; Sun, 06 Nov 2022 03:43:07 -0500
X-MC-Unique: eWQhrWXYP4-PyTsPpvJf1w-1
Received: by mail-wm1-f69.google.com with SMTP id c5-20020a1c3505000000b003c56da8e894so6858804wma.0
        for <kvm@vger.kernel.org>; Sun, 06 Nov 2022 01:43:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hi3Kr9yF0ps/ryGJaamxGMVq7pZEA+iBNyz5JEVKO1E=;
        b=Yey/x26ZSx42uE9vI6pLNv/Kjn2JtVoKiniW7/At/RwtnBrjYaq4Z5TZYY+adTwbHs
         caCAEvNJrrCP9ufIqd9ihRUaXwyA/1amaYz8Eq1B7oq/EGcS4DsaSTl9Il8WKk8N/0Px
         gdipgypU/9FBtT0QSYLW+048AL8UbGGuLPCVKmyJBHBv0G5fZ3IBnveSngU7ba/2s0yX
         0iqjrGkT8koKJXz2oeuQuSiqAxVKAb1TB/0ExZsYH4+6EsAagg2MmHFrTHHENW/Fre12
         +vnaP1gmTryJi5nR7Td2EHHhOinIRmrOOGHsllrmIUwbD9yuPicZQxJqjVTH2bppuNbJ
         8ucQ==
X-Gm-Message-State: ACrzQf3+LupfGN4RwZ3JWGAwUUcU+/nK1vuUvD3xAgVQOGNCC6SnS9f5
        p0j/8Zjs3g/28DpvEhPtprC2434R/yladcspvKmv8uXEhcpeEMg5K7CnQeCRVwxa4GGk9fNTJY5
        /fldY0SscLQqi
X-Received: by 2002:a5d:6d89:0:b0:236:7d7d:1e79 with SMTP id l9-20020a5d6d89000000b002367d7d1e79mr28903167wrs.673.1667724186350;
        Sun, 06 Nov 2022 01:43:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM78lcm9Uk7DZQ7IUNAGRjQrl/IW+JM33lp9jxerbXYQO70O5ff7N1B7LycbBlhY6j7ONnVWIw==
X-Received: by 2002:a5d:6d89:0:b0:236:7d7d:1e79 with SMTP id l9-20020a5d6d89000000b002367d7d1e79mr28903151wrs.673.1667724186054;
        Sun, 06 Nov 2022 01:43:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id bn23-20020a056000061700b002305cfb9f3dsm4146218wrb.89.2022.11.06.01.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Nov 2022 01:43:05 -0700 (PDT)
Message-ID: <f308e60a-9874-429b-ace9-463fa94cb739@redhat.com>
Date:   Sun, 6 Nov 2022 09:43:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] tools/kvm_stat: fix attack vector with user controlled
 FUSE mounts
Content-Language: en-US
To:     Matthias Gerstner <matthias.gerstner@suse.de>, kvm@vger.kernel.org
References: <20221103135927.13656-1-matthias.gerstner@suse.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221103135927.13656-1-matthias.gerstner@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/22 14:59, Matthias Gerstner wrote:
> The fix is simply to use the file system type field instead. Whitespace
> in the mount path is escaped in /proc/mounts thus no further safety
> measures in the parsing should be necessary to make this correct.
> ---
>   tools/kvm/kvm_stat/kvm_stat | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Matthias, both this patch and the one you sent to linux-afs need to 
include a "Signed-off-by" line, for example:

###
###	Signed-off-by: Matthias Gerstner <matthias.gerstner@suse.de>
###

The meaning of this is visible at https://developercertificate.org/.

For this patch you can just reply to the message with the above line 
(without the "###" in front) and I'll accept it.  However, for linux-afs 
I suggest that you just resend it.  Just committing your patch with the 
"-s" command line argument will include the line for you.

Thanks,

Paolo

> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
> index 9c366b3a676d..88a73999aa58 100755
> --- a/tools/kvm/kvm_stat/kvm_stat
> +++ b/tools/kvm/kvm_stat/kvm_stat
> @@ -1756,7 +1756,7 @@ def assign_globals():
>   
>       debugfs = ''
>       for line in open('/proc/mounts'):
> -        if line.split(' ')[0] == 'debugfs':
> +        if line.split(' ')[2] == 'debugfs':
>               debugfs = line.split(' ')[1]
>               break
>       if debugfs == '':


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396D362F9C7
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 16:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbiKRP5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 10:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbiKRP5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 10:57:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6CD8C491
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 07:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668786993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ttcW/rTHlQzNT+/Ls7pIym1RVV80wz0SllrC7rwVQ0I=;
        b=Ufx+iI2DT0FgN5cAzZwy3H8V3ytbToSVgFE0aVXW0593lqLco9vL8jCRfdScjbVfZ3U3bR
        r0O43ewFWQVVgOJKruUJCuiqnyfj3dASP1tEwfgoM789PzUc6SY99txMGND8WlLvbnsP0h
        KeZ/gvktuWBpWat3g4YSd0auOmblZmU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-608-Cn-fIbaGOGCFeyID1v78Qw-1; Fri, 18 Nov 2022 10:56:31 -0500
X-MC-Unique: Cn-fIbaGOGCFeyID1v78Qw-1
Received: by mail-wr1-f71.google.com with SMTP id j20-20020adfb314000000b002366d9f67aaso1715066wrd.3
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 07:56:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ttcW/rTHlQzNT+/Ls7pIym1RVV80wz0SllrC7rwVQ0I=;
        b=PsCclHbc71/AJOq3Icwx5RxfKTz/LdbZJIGsJGltceqjUnCeHVXAAzCa8+5YUePjKi
         PoVCrExLsonwRifOu19Ndvr/XrHrab+oFu3yotHUBb1BlsQJ4yN+PmxJLkxyike+33zA
         XwWhYwT11q18RMmKXTrCfU7IByCoDmgXMcv4h+/971VPvwaIPDso3c2M6z+UgOPT4bmW
         sbXQqRRI0NTmc+tAJRuC0G6hsKZVBwHuheAoCZNzuYmUOQh2N2ol7GU3Hyxzyvt7i7an
         cKWicyELSXZ/y9XrUCJ7VnR2suWmRVbGdXzlf3BwmxGoLNA1x0phhkSfsob5wuOYWpmS
         Bssg==
X-Gm-Message-State: ANoB5pkc8BQPijzAldduBsODARoY2mXp3ikLnea6O69m93xhyGyzzMPE
        Z71l7XPFMskxNDAH4U4QltaSDizyQreEopDhSoXbWyNlgei1iVnoTr2YCxas/22jCycoAAR2q5J
        iN0HGN+Q90k9O
X-Received: by 2002:a5d:65ca:0:b0:236:8322:4be9 with SMTP id e10-20020a5d65ca000000b0023683224be9mr4655988wrw.171.1668786990626;
        Fri, 18 Nov 2022 07:56:30 -0800 (PST)
X-Google-Smtp-Source: AA0mqf58mrK6oiHpi4faJvPVWUqYvGFYBoXQhcAxwtKY/EG4WxmJJRZvPL83uAm+5Q05Js1Mu2Iusg==
X-Received: by 2002:a5d:65ca:0:b0:236:8322:4be9 with SMTP id e10-20020a5d65ca000000b0023683224be9mr4655980wrw.171.1668786990434;
        Fri, 18 Nov 2022 07:56:30 -0800 (PST)
Received: from [192.168.8.100] (tmo-113-203.customers.d1-online.com. [80.187.113.203])
        by smtp.gmail.com with ESMTPSA id bg21-20020a05600c3c9500b003b497138093sm5529105wmb.47.2022.11.18.07.56.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 07:56:29 -0800 (PST)
Message-ID: <5407a498-2f29-e17d-949b-a9cf43eaa01e@redhat.com>
Date:   Fri, 18 Nov 2022 16:56:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] KVM: s390: remove unused gisa_clear_ipm_gisc() function
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20221118151133.2974602-1-hca@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221118151133.2974602-1-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/11/2022 16.11, Heiko Carstens wrote:
> clang warns about an unused function:
> arch/s390/kvm/interrupt.c:317:20:
>    error: unused function 'gisa_clear_ipm_gisc' [-Werror,-Wunused-function]
> static inline void gisa_clear_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
> 
> Remove gisa_clear_ipm_gisc(), since it is unused and get rid of this
> warning.
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>   arch/s390/kvm/interrupt.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index ab569faf0df2..1dae78deddf2 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -314,11 +314,6 @@ static inline u8 gisa_get_ipm(struct kvm_s390_gisa *gisa)
>   	return READ_ONCE(gisa->ipm);
>   }
>   
> -static inline void gisa_clear_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
> -{
> -	clear_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
> -}

Unused since its introduction in commit d77e64141e322.

Reviewed-by: Thomas Huth <thuth@redhat.com>


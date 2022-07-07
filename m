Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FC7569A42
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 08:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbiGGGJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 02:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiGGGJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 02:09:23 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA52D167DF
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 23:09:20 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 145so16630000pga.12
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 23:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lBLaoCEYu6B1QHs8h0+IT0tcTegt1xNb9sRwZ3Ssx+k=;
        b=KKU3bkWXqYGSAxudAHCMpdwv8k/MbYeL3BlToXsanmScbtdxzj+roiw6qR2/zliDjY
         mwaW+R4IBZ+Ka58Ws9WmrMA4AQaIKZ20XyDoZgTAsfLmauyUznxDtKm2ODX2DUMtIYJJ
         /zwJEtItmn9yQwYFuMLRddzChDg/rK+MBtukcmklhXc9rkFVUd2QXH/llJvvPx7rQF1g
         lxf1MLcbnD55DCmbq4F2eS6P/B4T9Set1dTWbGjO724HjR0uIJhGhllZmcyaUs3o3LBh
         x3y+D9JrfVA+D8pJkm++UejvnJMIIkoTdbUJbSbin+oYXGeKprCkL+Mr3i0NP+9bPrnk
         s7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lBLaoCEYu6B1QHs8h0+IT0tcTegt1xNb9sRwZ3Ssx+k=;
        b=hShZAMZqrBCCc0SP9sgGzBV5fmL1PcFsW+i/rN/kFAS/9C4XVB1vaO7rO+wExwCHCS
         YkmCCwX0AfuXyYyeqPz3+GWZSfLVTDD36GYWgNkq9hblmYTLSB6YZy7w4zTNnmv/6H4p
         uZjkbKZuVme80BpV0CcV5XRGCeILpxTxg4y9WSEjW6/XPfXmpXiK3+uR9Wt2LXicbRQ7
         KhskKVXaArY5LTor5/IBP3t+99QOZ4r/lBEw7bNKovB0HLqqqU87QjFb6ZLlYHKBB1Vj
         HiPBggvDTsD0CCBUJ4JxFKBDVLBFSNC72M0ldEw8dADCtFebxowyswcHlt+F4+zujL+Q
         +4rA==
X-Gm-Message-State: AJIora/J58Kg5PgoGxesecw71mkqLv4lMN7aji7Y+QdPj1trN64FVJM5
        bQZJK83jC/Kd72jHEOkfbBrxvg==
X-Google-Smtp-Source: AGRyM1u8OwT6q0lWS/sIDoJNqoInBK/difGXOMsxhJDf6fRYFUo30HP6JVzORaI0GqdHFToVv2l/NQ==
X-Received: by 2002:a17:90b:3141:b0:1ed:4ffb:f911 with SMTP id ip1-20020a17090b314100b001ed4ffbf911mr3214506pjb.80.1657174160430;
        Wed, 06 Jul 2022 23:09:20 -0700 (PDT)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id ij23-20020a170902ab5700b0016bd5da20casm10364432plb.134.2022.07.06.23.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 23:09:19 -0700 (PDT)
Message-ID: <5e6e43e3-b231-4a93-7d3b-14ddc7991cfe@ozlabs.ru>
Date:   Thu, 7 Jul 2022 16:11:19 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH] vfio/spapr_tce: Remove the unused parameters container
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Deming Wang <wangdeming@inspur.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220702064613.5293-1-wangdeming@inspur.com>
 <20220706131456.3c08c2b7.alex.williamson@redhat.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220706131456.3c08c2b7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/07/2022 05:14, Alex Williamson wrote:
> On Sat, 2 Jul 2022 02:46:13 -0400
> Deming Wang <wangdeming@inspur.com> wrote:
> 
>> The parameter of container has been unused for tce_iommu_unuse_page.
>> So, we should delete it.
>>
>> Signed-off-by: Deming Wang <wangdeming@inspur.com>
>> ---
>>   drivers/vfio/vfio_iommu_spapr_tce.c | 9 ++++-----
>>   1 file changed, 4 insertions(+), 5 deletions(-)
> 
> I'll give Alexey a chance to ack this, but agree that it seems this arg
> has never had any purpose.  Perhaps a debugging remnant.  Thanks,


yup, that was debugging...

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>



> 
> Alex
> 
>>
>> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
>> index 708a95e61831..ea3d17a94e94 100644
>> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
>> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
>> @@ -378,8 +378,7 @@ static void tce_iommu_release(void *iommu_data)
>>   	kfree(container);
>>   }
>>   
>> -static void tce_iommu_unuse_page(struct tce_container *container,
>> -		unsigned long hpa)
>> +static void tce_iommu_unuse_page(unsigned long hpa)
>>   {
>>   	struct page *page;
>>   
>> @@ -474,7 +473,7 @@ static int tce_iommu_clear(struct tce_container *container,
>>   			continue;
>>   		}
>>   
>> -		tce_iommu_unuse_page(container, oldhpa);
>> +		tce_iommu_unuse_page(oldhpa);
>>   	}
>>   
>>   	iommu_tce_kill(tbl, firstentry, pages);
>> @@ -524,7 +523,7 @@ static long tce_iommu_build(struct tce_container *container,
>>   		ret = iommu_tce_xchg_no_kill(container->mm, tbl, entry + i,
>>   				&hpa, &dirtmp);
>>   		if (ret) {
>> -			tce_iommu_unuse_page(container, hpa);
>> +			tce_iommu_unuse_page(hpa);
>>   			pr_err("iommu_tce: %s failed ioba=%lx, tce=%lx, ret=%ld\n",
>>   					__func__, entry << tbl->it_page_shift,
>>   					tce, ret);
>> @@ -532,7 +531,7 @@ static long tce_iommu_build(struct tce_container *container,
>>   		}
>>   
>>   		if (dirtmp != DMA_NONE)
>> -			tce_iommu_unuse_page(container, hpa);
>> +			tce_iommu_unuse_page(hpa);
>>   
>>   		tce += IOMMU_PAGE_SIZE(tbl);
>>   	}
> 

-- 
Alexey

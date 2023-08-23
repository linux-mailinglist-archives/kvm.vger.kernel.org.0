Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCE6784F02
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 05:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbjHWDAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 23:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbjHWDAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 23:00:17 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487C8E4E
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 19:59:49 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1befe39630bso9175005ad.0
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 19:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1692759588; x=1693364388;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bhgEqLuvf9ApSnTvUwn1L76c2o2W1Ei/QD6yE6yt7Vo=;
        b=RzbIwpF/0rWWCHIbil/kmvbYsiH+zzV8cteo0NeX4iqS5Th3aMObOrBBZ5QIYYiYNO
         EzLvxXnwaU3C6HJ66DVx0SYeH6DBUUXE/parOT0tZRTGaLZHY6BYCVv0BWvKsae2+Z4V
         HEkSBtQA++hJt6hjIX8coUzQJXYdSMU0EhPZnC3wJk9rsU5aMcdQM2J2gdrxRnnAl7ZG
         8NIlks8SUC7HZyd+TSNVs6GUNYerNVLSzTLDuAq02G7Vh6n7NQtQV5W2S/tTxnIxqdnK
         Yk0AUrfOj+V8sxulrYV9L4sfBNDgKCkzUecP9KTfiIS3EGmzpdtRXoZ4mpHHvApm3vtv
         04iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692759588; x=1693364388;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bhgEqLuvf9ApSnTvUwn1L76c2o2W1Ei/QD6yE6yt7Vo=;
        b=h+8gZePgEgpp+72sqXALFtFJnH3rOUhUsrya5PvNihnsWWnb+g4icxjhIU34oh8hZM
         Y3J4vQvPTgmobauLKiRaBuwQJ2+PLMg+ODFOPgvweczV3v+lLsiNGLyNPSOiEgRDW9wA
         qmMdgF3t/bnlF+5k450PR9OCkB00QGBZBHcRSnu/l3m2b4ycXCzwZlAfs/MCy2C69zoW
         KoLQpNBv8f/YsaZYbQhDd5zNvU4vsHlPZ1k8JKvhThuj2RrBjx4Yo9yPH7a96J2VJkC3
         Fhv6JVPuoSqKWbfjyOoqvG9qhXiKbc/u5BzYe/1Eu+Y0zIJVVegSybfcw2TXm0HOpBgK
         xoqg==
X-Gm-Message-State: AOJu0YxKXtnaNObknvis16eMx+XtOdoe+JCT+EVYjQNAGRFr3oV1qDV4
        zKD2BU372yp2Bz6qG9Zk9FmxSQ==
X-Google-Smtp-Source: AGHT+IEfrTZGJtg+pRH2EfLUkWhGiT4SJbELosEEcEbXeeoUMWHqtsVXqJsCto+j1ri8qfTaL4v/sQ==
X-Received: by 2002:a17:90a:2f41:b0:26d:4ade:fcf0 with SMTP id s59-20020a17090a2f4100b0026d4adefcf0mr10521410pjd.4.1692759588304;
        Tue, 22 Aug 2023 19:59:48 -0700 (PDT)
Received: from ?IPV6:fdbd:ff1:ce00:1c25:884:3ed:e1db:b610? ([2408:8000:b001:1:1f:58ff:f102:103])
        by smtp.gmail.com with ESMTPSA id z2-20020a17090a1fc200b00262ca945cecsm11045048pjz.54.2023.08.22.19.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 19:59:47 -0700 (PDT)
Message-ID: <63dc1d86-2a15-6b7e-f63a-63fccb25eae2@bytedance.com>
Date:   Wed, 23 Aug 2023 10:59:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v4 43/48] drm/ttm: introduce pool_shrink_rwsem
Content-Language: en-US
To:     daniel@ffwll.ch
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
 <20230807110936.21819-44-zhengqi.arch@bytedance.com>
 <ZOS+g51Yx9PsYkGU@phenom.ffwll.local>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
Cc:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev, simon.horman@corigine.com,
        dlemoal@kernel.org, kvm@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
        dm-devel@redhat.com, linux-mtd@lists.infradead.org, x86@kernel.org,
        cluster-devel@redhat.com, xen-devel@lists.xenproject.org,
        linux-ext4@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        rcu@vger.kernel.org, linux-bcache@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-btrfs@vger.kernel.org, daniel.vetter@ffwll.ch
In-Reply-To: <ZOS+g51Yx9PsYkGU@phenom.ffwll.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Daniel,

On 2023/8/22 21:56, Daniel Vetter wrote:
> On Mon, Aug 07, 2023 at 07:09:31PM +0800, Qi Zheng wrote:
>> Currently, the synchronize_shrinkers() is only used by TTM pool. It only
>> requires that no shrinkers run in parallel.
>>
>> After we use RCU+refcount method to implement the lockless slab shrink,
>> we can not use shrinker_rwsem or synchronize_rcu() to guarantee that all
>> shrinker invocations have seen an update before freeing memory.
>>
>> So we introduce a new pool_shrink_rwsem to implement a private
>> synchronize_shrinkers(), so as to achieve the same purpose.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> 
> On the 5 drm patches (I counted 2 ttm and 3 drivers) for merging through
> some other tree (since I'm assuming that's how this will land):

Yeah, there are 5 drm patches: PATCH v4 07/48 23/48 24/48 25/48 43/48.

> 
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Thanks for your review!

Qi

> 
>> ---
>>   drivers/gpu/drm/ttm/ttm_pool.c | 15 +++++++++++++++
>>   include/linux/shrinker.h       |  2 --
>>   mm/shrinker.c                  | 15 ---------------
>>   3 files changed, 15 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
>> index c9c9618c0dce..38b4c280725c 100644
>> --- a/drivers/gpu/drm/ttm/ttm_pool.c
>> +++ b/drivers/gpu/drm/ttm/ttm_pool.c
>> @@ -74,6 +74,7 @@ static struct ttm_pool_type global_dma32_uncached[MAX_ORDER + 1];
>>   static spinlock_t shrinker_lock;
>>   static struct list_head shrinker_list;
>>   static struct shrinker *mm_shrinker;
>> +static DECLARE_RWSEM(pool_shrink_rwsem);
>>   
>>   /* Allocate pages of size 1 << order with the given gfp_flags */
>>   static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
>> @@ -317,6 +318,7 @@ static unsigned int ttm_pool_shrink(void)
>>   	unsigned int num_pages;
>>   	struct page *p;
>>   
>> +	down_read(&pool_shrink_rwsem);
>>   	spin_lock(&shrinker_lock);
>>   	pt = list_first_entry(&shrinker_list, typeof(*pt), shrinker_list);
>>   	list_move_tail(&pt->shrinker_list, &shrinker_list);
>> @@ -329,6 +331,7 @@ static unsigned int ttm_pool_shrink(void)
>>   	} else {
>>   		num_pages = 0;
>>   	}
>> +	up_read(&pool_shrink_rwsem);
>>   
>>   	return num_pages;
>>   }
>> @@ -572,6 +575,18 @@ void ttm_pool_init(struct ttm_pool *pool, struct device *dev,
>>   }
>>   EXPORT_SYMBOL(ttm_pool_init);
>>   
>> +/**
>> + * synchronize_shrinkers - Wait for all running shrinkers to complete.
>> + *
>> + * This is useful to guarantee that all shrinker invocations have seen an
>> + * update, before freeing memory, similar to rcu.
>> + */
>> +static void synchronize_shrinkers(void)
>> +{
>> +	down_write(&pool_shrink_rwsem);
>> +	up_write(&pool_shrink_rwsem);
>> +}
>> +
>>   /**
>>    * ttm_pool_fini - Cleanup a pool
>>    *
>> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
>> index c55c07c3f0cb..025c8070dd86 100644
>> --- a/include/linux/shrinker.h
>> +++ b/include/linux/shrinker.h
>> @@ -103,8 +103,6 @@ struct shrinker *shrinker_alloc(unsigned int flags, const char *fmt, ...);
>>   void shrinker_register(struct shrinker *shrinker);
>>   void shrinker_free(struct shrinker *shrinker);
>>   
>> -extern void synchronize_shrinkers(void);
>> -
>>   #ifdef CONFIG_SHRINKER_DEBUG
>>   extern int __printf(2, 3) shrinker_debugfs_rename(struct shrinker *shrinker,
>>   						  const char *fmt, ...);
>> diff --git a/mm/shrinker.c b/mm/shrinker.c
>> index 3ab301ff122d..a27779ed3798 100644
>> --- a/mm/shrinker.c
>> +++ b/mm/shrinker.c
>> @@ -650,18 +650,3 @@ void shrinker_free(struct shrinker *shrinker)
>>   	kfree(shrinker);
>>   }
>>   EXPORT_SYMBOL_GPL(shrinker_free);
>> -
>> -/**
>> - * synchronize_shrinkers - Wait for all running shrinkers to complete.
>> - *
>> - * This is equivalent to calling unregister_shrink() and register_shrinker(),
>> - * but atomically and with less overhead. This is useful to guarantee that all
>> - * shrinker invocations have seen an update, before freeing memory, similar to
>> - * rcu.
>> - */
>> -void synchronize_shrinkers(void)
>> -{
>> -	down_write(&shrinker_rwsem);
>> -	up_write(&shrinker_rwsem);
>> -}
>> -EXPORT_SYMBOL(synchronize_shrinkers);
>> -- 
>> 2.30.2
>>
> 

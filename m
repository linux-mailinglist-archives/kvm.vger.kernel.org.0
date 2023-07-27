Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF70E764F3F
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 11:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbjG0JTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 05:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbjG0JSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 05:18:12 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401B69AA0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 02:09:06 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-686f74a8992so86536b3a.1
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 02:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690448946; x=1691053746;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4HPzHhawuqBHwf73jZH4M+rJ1h4rzhX4x1A5fzulUtE=;
        b=XVbZZB1bCuIddvCOd7ZdoZjiMRRT7dPd70cLEHChe028013CtZN4CJhyjaofMQGOCp
         aGQjkAdZJwrw0kO7FWCF+3wJu4Bs3hfpCHjXHte7v9cy4EJx3v2HSegV5fKDUggsvKcE
         rfw3ctmBIqNX3YVyLliz70Ow03c79YTqviRSUBhyV37ISoYoH05fZe12pteMem3zIYaK
         h5yTEuui+F8UDLetCnDn4Wd0BNAlUwOjTRf0Uzpr8uRBgvycDrHuoECz5/KoSjtrxNcd
         VFQA9eIykS0N+Aj/4rgCWZN2Q01gf7n56+E22JNqNX6qv8VxHS7PwBWWAHU3NZ4I85Kn
         Kvtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690448946; x=1691053746;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4HPzHhawuqBHwf73jZH4M+rJ1h4rzhX4x1A5fzulUtE=;
        b=DqHjShJFIIolfc9XjHxS8QDBIcNo6JIaVMgWj5/0hOekHzeRRhmelM2LUlWDzZh/v5
         RMrPekwEPH811CBUuGpRnwdxF4WguHhcoAqloWCCBamfJV8jlyfo5ynHWAXLPZzGVX5i
         tnmhtoxXLYVA1N/vB+iQYrnnTvfRS5V6Trm5pW7LYHFppue+EYLr9jcuqLPEUbktg67k
         6t2Y2Fe+YearvszlArWjMRpltBhqjUbXaRrx/4uXwRw7euXHS0OI/57CAZYXPAaQHSiO
         c78NV+ByG3SiG/CLFG3gmOFzTM4U2f+7o6zxCWQpxp9aX8bs5uTKURndByLs82tBkeNj
         /kwA==
X-Gm-Message-State: ABy/qLYPp/Te0p0fhqiMm7lekC2PRj84BSPVrbpJUagGpMSGrcyO7va5
        4HmoLU6cafOyLH3PQYrCAIqBfw==
X-Google-Smtp-Source: APBJJlGcM2GBnp4i4GpCfKYembVJdmGwthtzp39QltAoTiMbksVAbVCn2LuGL8UI/2xPGfcHp3vTrQ==
X-Received: by 2002:a05:6a20:1595:b0:137:30db:bc1e with SMTP id h21-20020a056a20159500b0013730dbbc1emr5836590pzj.3.1690448945731;
        Thu, 27 Jul 2023 02:09:05 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id f17-20020a635551000000b00563ea47c948sm930669pgm.53.2023.07.27.02.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jul 2023 02:09:05 -0700 (PDT)
Message-ID: <8951e9da-15ae-f05e-a9a4-a9354249cee2@bytedance.com>
Date:   Thu, 27 Jul 2023 17:08:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v3 16/49] nfsd: dynamically allocate the nfsd-filecache
 shrinker
Content-Language: en-US
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
 <20230727080502.77895-17-zhengqi.arch@bytedance.com>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20230727080502.77895-17-zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023/7/27 16:04, Qi Zheng wrote:
> Use new APIs to dynamically allocate the nfsd-filecache shrinker.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   fs/nfsd/filecache.c | 22 ++++++++++++----------
>   1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
> index ee9c923192e0..872eb9501965 100644
> --- a/fs/nfsd/filecache.c
> +++ b/fs/nfsd/filecache.c
> @@ -521,11 +521,7 @@ nfsd_file_lru_scan(struct shrinker *s, struct shrink_control *sc)
>   	return ret;
>   }
>   
> -static struct shrinker	nfsd_file_shrinker = {
> -	.scan_objects = nfsd_file_lru_scan,
> -	.count_objects = nfsd_file_lru_count,
> -	.seeks = 1,
> -};
> +static struct shrinker *nfsd_file_shrinker;
>   
>   /**
>    * nfsd_file_cond_queue - conditionally unhash and queue a nfsd_file
> @@ -746,12 +742,18 @@ nfsd_file_cache_init(void)
>   		goto out_err;
>   	}
>   
> -	ret = register_shrinker(&nfsd_file_shrinker, "nfsd-filecache");
> -	if (ret) {
> -		pr_err("nfsd: failed to register nfsd_file_shrinker: %d\n", ret);
> +	nfsd_file_shrinker = shrinker_alloc(0, "nfsd-filecache");
> +	if (!nfsd_file_shrinker) {

Here should set ret to -ENOMEM, will fix.

> +		pr_err("nfsd: failed to allocate nfsd_file_shrinker\n");
>   		goto out_lru;
>   	}
>   
> +	nfsd_file_shrinker->count_objects = nfsd_file_lru_count;
> +	nfsd_file_shrinker->scan_objects = nfsd_file_lru_scan;
> +	nfsd_file_shrinker->seeks = 1;
> +
> +	shrinker_register(nfsd_file_shrinker);
> +
>   	ret = lease_register_notifier(&nfsd_file_lease_notifier);
>   	if (ret) {
>   		pr_err("nfsd: unable to register lease notifier: %d\n", ret);
> @@ -774,7 +776,7 @@ nfsd_file_cache_init(void)
>   out_notifier:
>   	lease_unregister_notifier(&nfsd_file_lease_notifier);
>   out_shrinker:
> -	unregister_shrinker(&nfsd_file_shrinker);
> +	shrinker_free(nfsd_file_shrinker);
>   out_lru:
>   	list_lru_destroy(&nfsd_file_lru);
>   out_err:
> @@ -891,7 +893,7 @@ nfsd_file_cache_shutdown(void)
>   		return;
>   
>   	lease_unregister_notifier(&nfsd_file_lease_notifier);
> -	unregister_shrinker(&nfsd_file_shrinker);
> +	shrinker_free(nfsd_file_shrinker);
>   	/*
>   	 * make sure all callers of nfsd_file_lru_cb are done before
>   	 * calling nfsd_file_cache_purge

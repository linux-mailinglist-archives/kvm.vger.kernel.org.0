Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505DD763221
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 11:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbjGZJbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 05:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbjGZJae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 05:30:34 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747474483
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 02:28:45 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6862d4a1376so1660744b3a.0
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 02:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690363725; x=1690968525;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ET5z1iXVl3TCzfyIPhSPq9r+sES1n7GH6hJTCnF+vYo=;
        b=RgneqgkXKODRrFr78EJ2DiU2LP1auMSsEluGXDNHK2/ImK1m1wgxIc9rc0KyChzerd
         9pp9E0d70JkoKPUeaRftr+jglcQl9qJ1NHO80UjvVHwRcDm/HyYkv/adcdLVyb0tT2RZ
         DBfPuhO0Xzb3EkxZ8Lnv+NpBNxlgzINPxdWjI2p4gXmhxr9F42wMDqq5WIk8CWvg0ei0
         04D2fNryYi6h/fKlwXKsAJNXxbdFzcjkeSQHK+ZzWAzpfHtAdyeZZlzM27TnNlh1u/69
         UWlC2QlusG6aR16W+ARLMoeEnjaKWlhVg7tepMtvkY5m/QLzYLh0WRDX9uQBe16cx9gs
         O9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690363725; x=1690968525;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ET5z1iXVl3TCzfyIPhSPq9r+sES1n7GH6hJTCnF+vYo=;
        b=crduzJha2QEreU36qYjKHTbUwJMxjhSMUjVYqM7vSvculmDT3hlXD3YMAcIZu/xF0c
         jtNaqQ8qcwKJ3PdBTrWj0p9h3AMWN4stuc87UJGekHCrf3nuIeBJV7uMFfgo4a75+q4O
         0zsh04Zp3dWZEVgE566AtH2ubjCBYndk7fFvy2I5ZHTeFuzRe6Qu2kap08jDvqlfUUEw
         F9NsUT8WPF6VMOsWyrsM9inLXn2Zb91MSIR/EbDZn2z0q/n7lhy1Y3I3IhWZqq6bLDuF
         YEyiY57OmCWpoSvm686QPdOQdxOKV3VeEC7/sQ14LNKd9g8QqbTLRi/ip3slzNIHzR18
         iqEg==
X-Gm-Message-State: ABy/qLZkv9SD/bOg6k0h3t1nOSeySGqisjsEtPG/adkhIrTZUNUvvJ13
        2j7M69DmSuXZ+KjONTXZKJzJQg==
X-Google-Smtp-Source: APBJJlFvSUUJYrPzKxRMgKGWHa7iMtrF7iaocGD/XAPkPO20BZ2/Wf52mLvF02dnCC8LpFHDclZgZw==
X-Received: by 2002:a17:903:41c8:b0:1bb:83ec:832 with SMTP id u8-20020a17090341c800b001bb83ec0832mr2040388ple.2.1690363724990;
        Wed, 26 Jul 2023 02:28:44 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id bc2-20020a170902930200b001a95f632340sm12591323plb.46.2023.07.26.02.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jul 2023 02:28:44 -0700 (PDT)
Message-ID: <acb14ed0-b9ca-e7c9-e81b-a2db290a1b94@bytedance.com>
Date:   Wed, 26 Jul 2023 17:28:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v2 21/47] mm: workingset: dynamically allocate the
 mm-shadow shrinker
Content-Language: en-US
To:     Muchun Song <muchun.song@linux.dev>
Cc:     Andrew Morton <akpm@linux-foundation.org>, david@fromorbit.com,
        tkhai@ya.ru, Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>, djwong@kernel.org,
        Christian Brauner <brauner@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
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
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
 <20230724094354.90817-22-zhengqi.arch@bytedance.com>
 <08F2140B-0684-4FB0-8FB9-CEB88882F884@linux.dev>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <08F2140B-0684-4FB0-8FB9-CEB88882F884@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023/7/26 15:13, Muchun Song wrote:
> 
> 
>> On Jul 24, 2023, at 17:43, Qi Zheng <zhengqi.arch@bytedance.com> wrote:
>>
>> Use new APIs to dynamically allocate the mm-shadow shrinker.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>> mm/workingset.c | 26 ++++++++++++++------------
>> 1 file changed, 14 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/workingset.c b/mm/workingset.c
>> index 4686ae363000..4bc85f739b13 100644
>> --- a/mm/workingset.c
>> +++ b/mm/workingset.c
>> @@ -762,12 +762,7 @@ static unsigned long scan_shadow_nodes(struct shrinker *shrinker,
>> NULL);
>> }
>>
>> -static struct shrinker workingset_shadow_shrinker = {
>> -	.count_objects = count_shadow_nodes,
>> -	.scan_objects = scan_shadow_nodes,
>> -	.seeks = 0, /* ->count reports only fully expendable nodes */
>> -	.flags = SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE,
>> -};
>> +static struct shrinker *workingset_shadow_shrinker;
> 
> 
> Same as patch #17.

OK, will do.


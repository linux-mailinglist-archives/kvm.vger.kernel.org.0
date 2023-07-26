Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C3E7631FB
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 11:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjGZJ2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 05:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbjGZJ1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 05:27:30 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C28E2693
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 02:25:12 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-66d6a9851f3so1488054b3a.0
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 02:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690363511; x=1690968311;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ajWZi1kTG9ZsFll3P13XRfH/M90QTcK5ZSE2yNZ8xrc=;
        b=FbQ/cU5KkBidPkx8Y2uGYCzGutSB6xNfkWiQEKQsSST8W9zvQhHhApft87PlLY8dLU
         DGKfOcVpxkQTOOl80Aro56BnjlNO41fZWD7CmV5GDlB1LjEDjOf3Kop2mVKp+naFiQzY
         As6MgqOMDkFvMljdz6Un/7KTBl/NUqtiNwtAlVNm8YXgeUKehHDEJVTDK07iwDWpbMUs
         Auk85ACWfB5lfW+mTAMWhogzlI0RHaQpyoe7zLfXc22574NosN/xSHT+kEdNg0VX/lgH
         cTQssA2/OElC5yJBDMwL3y7p8+2qs+uUi9JaKT2yW1TXFErKU2nPA1SSCU5AFvvQq6bi
         em9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690363511; x=1690968311;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ajWZi1kTG9ZsFll3P13XRfH/M90QTcK5ZSE2yNZ8xrc=;
        b=U8mfVY+X99o7xsEehQJwOyMRM/xDbzn7tPbJQCAX05zk6JwwEteEBrCyOHWQeoxCB3
         gicgTKyviRRAcjOAZ4Mre7n0noq1NBMgP0AZ0IvM6kcS62ob/bI3OqN/unrUEV65g82z
         qdoU7sHEAYJTaJLkpEvoxGHLwVqnkzWSZXYbxjq46/KJLhFHVvPmfy6kEtMMrhY53O57
         cXhKLx4rBpGdf0aQXzwXjgCD4+mXpyQyC4PbCwSkF0QOKuGV3sncVX9YILIAQc4T9Pav
         ekqC6m0NmAMPx3UeodusoUURY7+fE5GJyToQqHXgdNCmsjHCPEY6qOUl0u1f8D34+S6p
         pWXw==
X-Gm-Message-State: ABy/qLaDDJ1zq7OmqOgWL88mBZd9GMhoqZEwWqNPLL7Jlz8YwZUgoNjd
        +PdsaH2xBnMGWVIAvi/oYDeqlg==
X-Google-Smtp-Source: APBJJlH7Lt4w+KKgSvUzSkJhF0oF8+b3ljHzveqc3Noqsk7KflIEw6xDKQ/sXRTNdo5n0Hc+oIf56w==
X-Received: by 2002:a05:6a20:729a:b0:100:b92b:e8be with SMTP id o26-20020a056a20729a00b00100b92be8bemr1785615pzk.2.1690363511718;
        Wed, 26 Jul 2023 02:25:11 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id h2-20020aa786c2000000b00682a99b01basm2004283pfo.0.2023.07.26.02.25.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jul 2023 02:25:11 -0700 (PDT)
Message-ID: <491f5c8f-ccc6-dab8-71b3-caeedc8c4b39@bytedance.com>
Date:   Wed, 26 Jul 2023 17:24:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v2 17/47] rcu: dynamically allocate the rcu-lazy shrinker
Content-Language: en-US
To:     Muchun Song <muchun.song@linux.dev>
Cc:     Andrew Morton <akpm@linux-foundation.org>, david@fromorbit.com,
        tkhai@ya.ru, Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>, djwong@kernel.org,
        Christian Brauner <brauner@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
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
 <20230724094354.90817-18-zhengqi.arch@bytedance.com>
 <3A164818-56E1-4EB4-A927-1B2D23B81659@linux.dev>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <3A164818-56E1-4EB4-A927-1B2D23B81659@linux.dev>
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



On 2023/7/26 15:04, Muchun Song wrote:
> 
> 
>> On Jul 24, 2023, at 17:43, Qi Zheng <zhengqi.arch@bytedance.com> wrote:
>>
>> Use new APIs to dynamically allocate the rcu-lazy shrinker.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>> kernel/rcu/tree_nocb.h | 19 +++++++++++--------
>> 1 file changed, 11 insertions(+), 8 deletions(-)
>>
>> diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
>> index 43229d2b0c44..919f17561733 100644
>> --- a/kernel/rcu/tree_nocb.h
>> +++ b/kernel/rcu/tree_nocb.h
>> @@ -1397,12 +1397,7 @@ lazy_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>> return count ? count : SHRINK_STOP;
>> }
>>
>> -static struct shrinker lazy_rcu_shrinker = {
>> -	.count_objects = lazy_rcu_shrink_count,
>> -	.scan_objects = lazy_rcu_shrink_scan,
>> -	.batch = 0,
>> -	.seeks = DEFAULT_SEEKS,
>> -};
>> +static struct shrinker *lazy_rcu_shrinker;
> 
> Seems there is no users of this variable, maybe we could drop
> this.

Yeah, will change it to a local variable. And the patch #15 is
the same.

> 

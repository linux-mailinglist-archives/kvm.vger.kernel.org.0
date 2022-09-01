Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150E05AA39A
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 01:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbiIAXSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 19:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbiIAXRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 19:17:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DE29D100
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 16:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662074248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Up7P4fQPv3QO96X8W5CWpvLvhg+1IhrQIUpviyNAatM=;
        b=Q6bk1gMk0hTPlFkqZgmXIMfxJRQSr12koxwsCaOVCuJJ1fLXevvxEXGWzH7PgXdpi84ffb
        xo+3zKyYJgxSbrYFHkVsfXaJBZioP5Gxnx6qzyVqU0F0R4Q3B82iaxU0BZ3r2QksMLPJPG
        kFoiTk7ucG/MkkSOYFPgsgq2gpk77yU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-288-EbrFdIXENUOvsa7eq9tYjA-1; Thu, 01 Sep 2022 19:17:27 -0400
X-MC-Unique: EbrFdIXENUOvsa7eq9tYjA-1
Received: by mail-ej1-f69.google.com with SMTP id qa35-20020a17090786a300b0073d4026a97dso113546ejc.9
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 16:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Up7P4fQPv3QO96X8W5CWpvLvhg+1IhrQIUpviyNAatM=;
        b=I32jckTALhevcv04ybjsMeV+epa37E6el2FiXMK8jIpSc74WOneHduowoI9wR56TCC
         zMSH6kKsPC/nFDHce4XyA+xBCO8+Wjqkb3WAfUEFyMoimWRoyQP9pSgIwMLpsF58/tog
         mF53ilfb3zspIlLsLi+YCulUi51wc/FoqSyfZUJ7HEX3o9J4HEwQUNt09FACSgBninqG
         SWt8BcTMeVHBzRqGeqRPl2vZJ0D2WIVvwrqs0PcGWMFrMWfpFTigny8EU9JIt7eiLphV
         gLTWE5kkjd9hfvEB7nGH7tAxiMaK/esRZlLSMVLFq38dbn5hxuumK34OtjYjLVNVEVxb
         ZC9w==
X-Gm-Message-State: ACgBeo0FPPRztR/eoTRmYwfN8nhNBX+bqZ41t4BFNR1gPNiOzQfIwfeK
        ts+weJHcq2RYI8a+oJsylCxrE2grjEdNAvaqqRiMg7kJbhqmEJGWe14terC3xdp+4cYFDddIDLg
        xl9Kzx5qcsx4L
X-Received: by 2002:a17:907:6d16:b0:731:17b5:699 with SMTP id sa22-20020a1709076d1600b0073117b50699mr27462596ejc.23.1662074246837;
        Thu, 01 Sep 2022 16:17:26 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6y4K1beuBiz4jt6PFGYmDzMiS8qZdf7rIE6G6RXdSmbOqLz+3jUKKZmGZUaP7ftlVLFR0z2A==
X-Received: by 2002:a17:907:6d16:b0:731:17b5:699 with SMTP id sa22-20020a1709076d1600b0073117b50699mr27462584ejc.23.1662074246676;
        Thu, 01 Sep 2022 16:17:26 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id h6-20020a170906828600b0073d6234ceebsm286510ejx.160.2022.09.01.16.17.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 16:17:26 -0700 (PDT)
Message-ID: <5f15a3a0-446f-59a4-6bef-8be0e5630f5b@redhat.com>
Date:   Fri, 2 Sep 2022 01:17:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] KVM: fix memoryleak in kvm_init()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Cc:     vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220823063414.59778-1-linmiaohe@huawei.com>
 <Yw6C+tBZrbP5IX+e@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yw6C+tBZrbP5IX+e@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/30/22 23:36, Sean Christopherson wrote:
> On Tue, Aug 23, 2022, Miaohe Lin wrote:
>> When alloc_cpumask_var_node() fails for a certain cpu, there might be some
>> allocated cpumasks for percpu cpu_kick_mask. We should free these cpumasks
>> or memoryleak will occur.
>>
>> Fixes: baff59ccdc65 ("KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()")
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
> 
> Pushed to branch `for_paolo/6.1` at:
> 
>      https://github.com/sean-jc/linux.git
> 
> Unless you hear otherwise, it will make its way to kvm/queue "soon".
> 
> Note, the commit IDs are not guaranteed to be stable.

Hmm, I was going to merge these memory leak fixes for 6.0, but no big 
deal since they're mostly theoretical anyway.

Paolo


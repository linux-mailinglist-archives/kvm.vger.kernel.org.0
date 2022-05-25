Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F5B53352A
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 04:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239908AbiEYCJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 22:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbiEYCJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 22:09:55 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10444674C8
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 19:09:54 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id fw21-20020a17090b129500b001df9f62edd6so3120688pjb.0
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 19:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7HewgPeYrPk14Yu7XfczHo+WGbtndU4/U9oMWp3iEZQ=;
        b=jCRB1H238SE9kknCMH1tnhSn20Yfz6fSr1f3KJ4/8giQR5vLTkdbsszKjZkEgmj3DO
         dE0aTwD/orguWziTeOK9adLILEzjvM5qTbfN6r0WSNufZoW+7A1VLSjsmmKEMam2vm9h
         WySYeS3dIEvAGWzE92Ee/YC8+A5RFgPmMzg5ZB1FwnXHJOu4+yESW6COB57Zk/WhLzCf
         fL2l0afMZVyelZexUYBoaZ9vMGqhZwwSSquNIansb114vZn0xba0YE725bzSsyPI00tJ
         dpP7w2s9zO6uxL8gTuyWu/96QB17NuJGqxp+CwKU3EsSIBoWGYNByzh0hqFOW2J8AMA5
         ytrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7HewgPeYrPk14Yu7XfczHo+WGbtndU4/U9oMWp3iEZQ=;
        b=SLM5qVSUrr93Pf+aN2SnlVl7KZBa7MVvY1+uvzU8KgetBeWfgOaJjnydl0QEBQBKMz
         QHQ49cMTcR5dlK+W0NGUrKrm9YFyMGyIWQ4gq2vInwbP3yh/derru/rSmzqlz8I9ay0D
         DhddtvDe+SZWi4A6x/oreTwvoByfZ54eQ6v3KVJDxuLkX7CpuLVylVpT9+rkrOjIzHtl
         x9P0v05/jQt3hJiBETk4c+8qsaagpOrL+EtWUGn2DSdJrzchxLTYPdy5LIqLQ8E3uJz2
         CRxsR/ReVidZVn/YzbWPDvTCXfwA4PPaaLE/OStb5GcPuY9gFDKjHvuyC4zjrvcXYsJv
         MbQA==
X-Gm-Message-State: AOAM531GpZLj+AkUCx7RSIWUd70EhD3FvpJiPaJ5cswsYVQBmGJaWRyQ
        8j/XfkBpoG5uhxvAueitjskhAA==
X-Google-Smtp-Source: ABdhPJxJ/2I8pfFqpvWHy6IC95+fRwt2oq1iZC3uN6BehjVLlWXYEqS46Mev9lAqfZnrDLC4Kra0sg==
X-Received: by 2002:a17:90a:191a:b0:1dc:a3d3:f579 with SMTP id 26-20020a17090a191a00b001dca3d3f579mr7860177pjg.30.1653444593610;
        Tue, 24 May 2022 19:09:53 -0700 (PDT)
Received: from [10.61.2.177] (110-175-254-242.static.tpgi.com.au. [110.175.254.242])
        by smtp.gmail.com with ESMTPSA id y13-20020a1709027c8d00b0015e8d4eb2cfsm7885640pll.281.2022.05.24.19.09.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 19:09:53 -0700 (PDT)
Message-ID: <dde9738f-784f-ea7c-4318-a9260ee00683@ozlabs.ru>
Date:   Wed, 25 May 2022 12:09:46 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:101.0) Gecko/20100101
 Thunderbird/101.0
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        iommu@lists.linux-foundation.org,
        Joao Martins <joao.m.martins@oracle.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com> <YmqqXHsCTxVb2/Oa@yekko>
 <67692fa1-6539-3ec5-dcfe-c52dfd1e46b8@ozlabs.ru>
 <20220524132553.GR1343366@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220524132553.GR1343366@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/24/22 23:25, Jason Gunthorpe wrote:
> On Mon, May 23, 2022 at 04:02:22PM +1000, Alexey Kardashevskiy wrote:
> 
>> Which means the guest RAM does not need to be all mapped in that base IOAS
>> suggested down this thread as that would mean all memory is pinned and
>> powervm won't be able to swap it out (yeah, it can do such thing now!). Not
>> sure if we really want to support this or stick to a simpler design.
> 
> Huh? How can it swap? Calling GUP is not optional. Either you call GUP
> at the start and there is no swap, or you call GUP for each vIOMMU
> hypercall.

Correct, not optional.


> Since everyone says PPC doesn't call GUP during the hypercall - how is
> it working?

It does not call GUP during hypercalls because all VM pages are GUPed in 
advance at a special memory preregistration step as we could not call 
GUP from a hypercall handler with MMU off (often the case with POWER8 
when this was developed in the first place). Things are better with 
POWER9 (bare metal can do all sorts of things pretty much) but the 
PowerVM interface with 2 windows is still there and this iommufd 
proposal is going to be ported on top of PowerVM at first.

I am just saying there is a model when not everything is mapped and this 
has its use. The PowerVM's swapping capability is something new and I do 
not really know how that works though.


-- 
Alexey

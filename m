Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D88A70E450
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 20:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237894AbjEWR7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 13:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237873AbjEWR7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 13:59:37 -0400
Received: from smtp.smtpout.orange.fr (smtp-30.smtpout.orange.fr [80.12.242.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1886AC2
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 10:59:35 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id 1W6BqAVKjamWk1W6BqhlwN; Tue, 23 May 2023 19:47:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1684864024;
        bh=yZg3vSPw9MSkRNTDiEkp+0nv0E0aqm0TK0XFzp9sGd0=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To;
        b=hoD51IRCfXNwOIunLVcGpHx4XMxeGsVYQ6IwFU8kp+JsSbq/+G/8xmkbL9fe2jnkh
         M9RcacChxTaOVsCCImmNd6bgxcERFMSGsaj0OSvBZiMyLcWDs/E6RYTT2hYMd1wHQF
         Omy5eUv7x5SJIPazBXOi+u1LLOC7tEREyW9vANQ3g1INzpMeD4kDT1Im6LGDiAmpNi
         WV+Mm4wn85MXXMc2aG+HOiCaVi2EMfQ5iDjOWf6WFGVPb7QG1aGKQtuZtnFCC/BBRh
         YqPPSwGdD91WqNfAIAkmebWdMF7kHaaK7NICSx+yUsKZ5Grf7P7THp22X9P8SneQlf
         4GrI+5CDk3sbw==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 23 May 2023 19:47:04 +0200
X-ME-IP: 86.243.2.178
Message-ID: <98460663-eff1-6f42-1371-6c44ec6dc288@wanadoo.fr>
Date:   Tue, 23 May 2023 19:47:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/2][next] vfio/ccw: Replace one-element array with
 flexible-array member
Content-Language: fr
From:   Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <cover.1684805398.git.gustavoars@kernel.org>
 <3c10549ebe1564eade68a2515bde233527376971.1684805398.git.gustavoars@kernel.org>
 <c3a473c2-1d4a-1b8a-648f-7f75b800ecd7@wanadoo.fr>
In-Reply-To: <c3a473c2-1d4a-1b8a-648f-7f75b800ecd7@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Le 23/05/2023 à 19:45, Christophe JAILLET a écrit :
> Le 23/05/2023 à 03:35, Gustavo A. R. Silva a écrit :
>> One-element arrays are deprecated, and we are replacing them with 
>> flexible
>> array members instead. So, replace one-element array with flexible-array
>> member in struct vfio_ccw_parent and refactor the the rest of the code
>> accordingly.
>>
>> Link: https://github.com/KSPP/linux/issues/79
>> Link: https://github.com/KSPP/linux/issues/297
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>   drivers/s390/cio/vfio_ccw_drv.c     | 3 ++-
>>   drivers/s390/cio/vfio_ccw_private.h | 2 +-
>>   2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c 
>> b/drivers/s390/cio/vfio_ccw_drv.c
>> index ff538a086fc7..57906a9c6324 100644
>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>> @@ -171,7 +171,8 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
>>           return -ENODEV;
>>       }
>> -    parent = kzalloc(sizeof(*parent), GFP_KERNEL);
>> +    parent = kzalloc(sizeof(*parent) + sizeof(struct mdev_type *),
> 
> Hi, wouldn't:
> 
>     parent = kzalloc(struct_size(parent, mdev_types, 1)),
> 
> be more informative and in the spirit of flexible array use?

Ok, patch 2/2.

Sorry for the noise.

CJ

> 
> Just my 2c,
> 
> CJ
> 
>> +             GFP_KERNEL);
>>       if (!parent)
>>           return -ENOMEM;
>> diff --git a/drivers/s390/cio/vfio_ccw_private.h 
>> b/drivers/s390/cio/vfio_ccw_private.h
>> index b441ae6700fd..b62bbc5c6376 100644
>> --- a/drivers/s390/cio/vfio_ccw_private.h
>> +++ b/drivers/s390/cio/vfio_ccw_private.h
>> @@ -79,7 +79,7 @@ struct vfio_ccw_parent {
>>       struct mdev_parent    parent;
>>       struct mdev_type    mdev_type;
>> -    struct mdev_type    *mdev_types[1];
>> +    struct mdev_type    *mdev_types[];
>>   };
>>   /**
> 
> 

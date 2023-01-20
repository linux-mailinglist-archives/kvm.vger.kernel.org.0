Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CA56753F3
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 12:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjATL5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 06:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjATL5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 06:57:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FBDAD11
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 03:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674215775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vg6mJzvu0y8vgifCIBh6KKubBetRO7GYEyZ6/+9wrew=;
        b=CGXn+FIabaRSe4sbmTF3WKw4CwjkMfTDJ/lzn8ingq/03QdycFnDx4PDc+j7xo33M6r14b
        LKyc5aUQGVO83wxLarGsMMLsQZro+cNvEvozMHJtjTF8Oyd3JwGWnef/N4KeYGjT8IQVGH
        TWmXytCEJWxe7On7aMspSUc5blRVa7s=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-211-ukOOJgdBPk2EYpYXQxRe1Q-1; Fri, 20 Jan 2023 06:56:14 -0500
X-MC-Unique: ukOOJgdBPk2EYpYXQxRe1Q-1
Received: by mail-qt1-f198.google.com with SMTP id w25-20020ac86b19000000b003b692f65ca2so1838737qts.20
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 03:56:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vg6mJzvu0y8vgifCIBh6KKubBetRO7GYEyZ6/+9wrew=;
        b=OLUntmRinnu1tsqwKvzf40J0ZMXeU4Ogop/29obEk0o7EAKslBQER0RISx7a9HyUnb
         3PRQZMlRA5dOPBnZwq0TK8JOsYpobs2/Vuw06e3sl/CBwseiPU/zdK2bIFh4uxJGYL7+
         FwCVPHKGrn1bXcsTmkLzzAR0UIPolfFjyI0y8vdI4v1To7AQIbs2ib+BQpBhnxD6xE7L
         8l4kNxwrw6sqUy12k1XuwsL7l/vzYkkr/yDCxMh80mdeXF2evDbJdB4PFcX8aKSLrWIT
         jol+ThhSm9cJy3GNcGawD3wVgxrMPa+qsowDoXI+NFRFmmLJqT3PtzQqJTRf/7IniteC
         RqPA==
X-Gm-Message-State: AFqh2kqwsxxcW0zOI+mNFnhUmGsMShjj9h4WXQoLeJBT3of8537XydNz
        +rGyhRXoibSRH5OXUFCmRl6ylwyszWYJX6Bzmypdgsp9X5AuFTrLgerk25FIOrZlDkytyUo4K+9
        zp6hzQQwplTgb
X-Received: by 2002:ac8:71c1:0:b0:3b6:3abd:fcc2 with SMTP id i1-20020ac871c1000000b003b63abdfcc2mr20104423qtp.46.1674215773700;
        Fri, 20 Jan 2023 03:56:13 -0800 (PST)
X-Google-Smtp-Source: AMrXdXslsqQwJqVGYKeuWvFHUQT4LIkpVZ6nAQtm3xvcGPgl1xP0C5pJn+pZBnsYQhs7SE+EMQ844w==
X-Received: by 2002:ac8:71c1:0:b0:3b6:3abd:fcc2 with SMTP id i1-20020ac871c1000000b003b63abdfcc2mr20104391qtp.46.1674215773482;
        Fri, 20 Jan 2023 03:56:13 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-118.web.vodafone.de. [109.43.177.118])
        by smtp.gmail.com with ESMTPSA id k2-20020a05620a414200b006faaf6dc55asm26231527qko.22.2023.01.20.03.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 03:56:12 -0800 (PST)
Message-ID: <648e62ab-9d66-9a5a-0a03-124c16b85805@redhat.com>
Date:   Fri, 20 Jan 2023 12:56:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v14 10/11] qapi/s390/cpu topology: POLARITY_CHANGE qapi
 event
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-11-pmorel@linux.ibm.com>
 <c338245c-82c3-ed57-9c98-f4d630fa1759@redhat.com>
 <5f177a1b-90d6-7e30-5b58-cdcae7919363@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <5f177a1b-90d6-7e30-5b58-cdcae7919363@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/2023 18.09, Pierre Morel wrote:
> 
> On 1/12/23 12:52, Thomas Huth wrote:
>> On 05/01/2023 15.53, Pierre Morel wrote:
...>>> +#
>>> +# Emitted when the guest asks to change the polarity.
>>> +#
>>> +# @polarity: polarity specified by the guest
>>
>> Please elaborate: Where does the value come from (the PTF instruction)? 
>> Which values are possible?
> 
> Yes what about:
> 
> # @polarity: the guest can specify with the PTF instruction a horizontal
> #            or a vertical polarity.

Maybe something like: "The guest can tell the host (via the PTF instruction) 
whether a CPU should have horizontal or vertical polarity." ?

> #         On horizontal polarity the host is expected to provision
> #            the vCPU equally.

Maybe: "all vCPUs equally" ?
Or: "each vCPU equally" ?

> #            On vertical polarity the host can provision each vCPU
> #            differently
> #            The guest can get information on the provisioning with
> #            the STSI(15) instruction.

  Thomas


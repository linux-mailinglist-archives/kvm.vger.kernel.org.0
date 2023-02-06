Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CE568BD1D
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 13:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjBFMms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 07:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjBFMmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 07:42:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924957D9F
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 04:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675687318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=okOxFNRBawMJX/GrZo7mW7r0/H+vIJ0KrofIPQLvRJo=;
        b=d2gQkG439WQ+QJzKgRxIhcpurK36vbMv+ildjku1tFAdL4atmmUciBpysUKDQZjqA/Mp3N
        kTRkp5Lf1oHywm+ATIXIh486h5xBRGswDMEvL/pz8uU4uYb8Cx/TOwoTe9Hj6XUualAbii
        BMl2zWUZ9gqeIfO8WSyTYUZ9Zm9FFbw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-290-ndomM2xSOh2ZSA8dV1XmRQ-1; Mon, 06 Feb 2023 07:41:50 -0500
X-MC-Unique: ndomM2xSOh2ZSA8dV1XmRQ-1
Received: by mail-qk1-f197.google.com with SMTP id q21-20020a05620a0d9500b0070572ccdbf9so7733546qkl.10
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 04:41:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=okOxFNRBawMJX/GrZo7mW7r0/H+vIJ0KrofIPQLvRJo=;
        b=0+9RXe36vFhYwjDKLOi925RPU926PpmA3O+vsBuDltaXaVlNF3pLw+yWwFDh0/jUZz
         vsl6s11yVErTgOosnwtlKxTivq8sukOXhMONm+VkkIC+BXmIcEuKgFoEK8eI6lHENAU6
         xitIAWMT4AGj2f2gRQ7//BPa4yE9yUK4qHFyL6q4Q5k4zkBknCvks+wQYGTR0fykEtN6
         uWvVsafk/PlLT68+nTE0vJ4jIq+oW8IPyYoSwjDbh3Ymr7FkjEz+sYaEeIsJgj9EMesG
         7UEjkBCbBISBDgSGKfUWy/REqw3V1z32IpFtcWxURH9J4GzYeNHbI2G6pN4T+jFUEa3h
         Rc/Q==
X-Gm-Message-State: AO0yUKULaH2MXXqXWwJMmaphdMZpn2jC74chljlBfIOxjgo2DJ+MeuYF
        B3JHyul7xYNSBc0AcopYV0or4z2SQQZ6wYLoWHN2zBxoVOP/dYnuW1paO1azuxmE45aqpIPqr9W
        dwSlHvG55xxAp
X-Received: by 2002:a05:622a:5ce:b0:3b6:36a0:adbe with SMTP id d14-20020a05622a05ce00b003b636a0adbemr37258155qtb.6.1675687309823;
        Mon, 06 Feb 2023 04:41:49 -0800 (PST)
X-Google-Smtp-Source: AK7set+GAXr9jY6Hh9EW3jsp2Uai+08Q7dFWScNRaKTS4AOBcs+GaunXCokeMxElbmP4WgnciGYbEw==
X-Received: by 2002:a05:622a:5ce:b0:3b6:36a0:adbe with SMTP id d14-20020a05622a05ce00b003b636a0adbemr37258104qtb.6.1675687309463;
        Mon, 06 Feb 2023 04:41:49 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-71.web.vodafone.de. [109.43.177.71])
        by smtp.gmail.com with ESMTPSA id i15-20020a05620a27cf00b006fba0a389a4sm7234075qkp.88.2023.02.06.04.41.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 04:41:48 -0800 (PST)
Message-ID: <a7a235d5-4ded-b83d-dcb6-2cf81ad5f283@redhat.com>
Date:   Mon, 6 Feb 2023 13:41:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v15 09/11] machine: adding s390 topology to query-cpu-fast
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-10-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230201132051.126868-10-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/2023 14.20, Pierre Morel wrote:
> S390x provides two more topology containers above the sockets,
> books and drawers.
> 
> Let's add these CPU attributes to the QAPI command query-cpu-fast.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   qapi/machine.json          | 13 ++++++++++---
>   hw/core/machine-qmp-cmds.c |  2 ++
>   2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/qapi/machine.json b/qapi/machine.json
> index 3036117059..e36c39e258 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -53,11 +53,18 @@
>   #
>   # Additional information about a virtual S390 CPU
>   #
> -# @cpu-state: the virtual CPU's state
> +# @cpu-state: the virtual CPU's state (since 2.12)
> +# @dedicated: the virtual CPU's dedication (since 8.0)
> +# @polarity: the virtual CPU's polarity (since 8.0)
>   #
>   # Since: 2.12
>   ##
> -{ 'struct': 'CpuInfoS390', 'data': { 'cpu-state': 'CpuS390State' } }
> +{ 'struct': 'CpuInfoS390',
> +    'data': { 'cpu-state': 'CpuS390State',
> +              'dedicated': 'bool',
> +              'polarity': 'int'

I think it would also be better to mark the new fields as optional and only 
return them if the guest has the topology enabled, to avoid confusing 
clients that were written before this change.

  Thomas


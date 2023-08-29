Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A8E78C79E
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 16:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbjH2Odx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 10:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236427AbjH2OdY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 10:33:24 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62356CC
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 07:33:21 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-52a0856b4fdso5834658a12.1
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 07:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693319600; x=1693924400;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5MNCHhKUaSJNWbhq7zqf40FNGZbOYQKxHkc3qTW4uug=;
        b=ChN5Owfx7B1FOLTSrOKXD0qLppW3M1xruacD+9w7+EP+5cvz24GPE/IE/DsKO82AFt
         n5w1uOmxKSRkquYxRYnBidqGcM3MOlw9CBxmLxSA3UfCZRMNG5OBDOfCkfBpaNnR4qBX
         sD36mb3vVqX3vPY37p+XX+5xZlZIL8Z/X1zSRXqrPb5G+aUXFN0AJtgicFwU5GJEid1a
         Hx6tnpGqJ1GL9a0YYTdH74v/keQlQGqk8FKK69GrmQGwYIelowyF9NoqjB9uz2Lt8PCJ
         TAvdUg7x8o5S369x0TMG0WSEeuNzyl2EXJc9K7hotb3K+0Kjn2fIQ/nEwuZtOs/fmVgO
         Agew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693319600; x=1693924400;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5MNCHhKUaSJNWbhq7zqf40FNGZbOYQKxHkc3qTW4uug=;
        b=O01UEBCxmSbvD+1fnkpDxp0Zqm4lUFdW9vmxr5zdJZqr92fEH146GVXgrTynYJ/cdc
         z7c2ZgyCcZDK8XTAtstktCmRv1CusbP6IhVUsm8dYC5OCmBzY7isKuQJfx9rXj8Dsm+f
         982L92is9/2KMUP6Ul0gRam18njsHiZWR7YZzcD5RVErZ0+xxtKU6KUYIBdcJj1jgxIZ
         kxk7n31N8qTowSBMnyc0Wj1+NgTKOoDK9648vxvzws0q+h342oqdg4US72TLJcaUaxzg
         3gAa2g5gUYbE67nNxLfE9UHETw30IgiyHbgX3ZYDNvy4HUG6G+FEhFkpJmKuvXHRcW+T
         Cf9g==
X-Gm-Message-State: AOJu0YxmGrMAYLSwrAyb2oCulmS4epoD1iK7otRC5nIHrgFE6lb7Thj/
        D37B6NmCMR4ElJBTc67ge/ZR6g==
X-Google-Smtp-Source: AGHT+IHqkUUmc8lqtheoOUVpJIIMSt0ltxbxM52T15ZmMWwF5FptHJ/KxzonG/lis9cJDWHVZgtWAQ==
X-Received: by 2002:aa7:cd50:0:b0:525:4471:6b5d with SMTP id v16-20020aa7cd50000000b0052544716b5dmr21444068edw.19.1693319599807;
        Tue, 29 Aug 2023 07:33:19 -0700 (PDT)
Received: from [192.168.69.115] (sml13-h01-176-184-15-56.dsl.sta.abo.bbox.fr. [176.184.15.56])
        by smtp.gmail.com with ESMTPSA id l20-20020aa7c3d4000000b0051e0be09297sm5735208edr.53.2023.08.29.07.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 07:33:19 -0700 (PDT)
Message-ID: <68526bca-6054-510e-09fe-f73bf610b005@linaro.org>
Date:   Tue, 29 Aug 2023 16:33:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v2 36/58] memory: Introduce memory_region_init_ram_gmem()
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-37-xiaoyao.li@intel.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230818095041.1973309-37-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/8/23 11:50, Xiaoyao Li wrote:
> Introduce memory_region_init_ram_gmem() to allocate private gmem on the
> MemoryRegion initialization. It's for the usercase of TDVF, which must
> be private on TDX case.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   include/exec/memory.h |  6 +++++
>   softmmu/memory.c      | 52 +++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 58 insertions(+)


> diff --git a/softmmu/memory.c b/softmmu/memory.c
> index af6aa3c1e3c9..ded44dcef1aa 100644
> --- a/softmmu/memory.c
> +++ b/softmmu/memory.c
> @@ -25,6 +25,7 @@
>   #include "qom/object.h"
>   #include "trace.h"
>   
> +#include <linux/kvm.h>

Unlikely to build on non-Linux hosts.

>   #include "exec/memory-internal.h"
>   #include "exec/ram_addr.h"
>   #include "sysemu/kvm.h"


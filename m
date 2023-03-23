Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39BD6C6977
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 14:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjCWN1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 09:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWN0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 09:26:32 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426AAC155
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 06:26:14 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id eg48so86409540edb.13
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 06:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bjorling.me; s=google; t=1679577973;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZynXKaBOZdy4w6ACpnEX28zx5BXt6PUiazSEKSUAnlw=;
        b=d39a52/KOEDT3du7A7P5bT7FZTT+YILP+OI+AUw8gmo3hOgPgAjnijUWZp1LUZ7hv+
         COrOLqSxDxGLBGycGv7lhjxw05r9kTAJoBFpQZsBDZvY9BkM4huYTmk2kZGho42BIzWZ
         3EraOL7ZCN+xxxipRDZPKsvTLbNc7ltu6y29A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679577973;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZynXKaBOZdy4w6ACpnEX28zx5BXt6PUiazSEKSUAnlw=;
        b=m3PpswNk8v4agGvmz6uAmMkLBDjBtJtnkJVExB8ZDO0tpuDveKcSycwfENdrlG1Xvq
         T2198kT92iHGEPlBaq5U7iqzy70MGPllmPEHo2pnZ01P2t6CKqClupsh/wRoaLi0QjIB
         Vpir7vcF2C6O64ILEQ3zqwgwubyn7NAgAkrr2SCH1DmMBHCy13k6qcM0/OgNVcLJvV63
         qit9klocavvGYfqvWVNYsYS7E2+MNPSUqJvh5yKCiHb44LdO6qK+T/r5rm9npil+IqOc
         8oV/pU4brCVkHOGIEq0aYC3Ze7yUbvqBKoiaWUiCDZOIZL2U+WV8EL757D4qwSbNK70s
         7tTw==
X-Gm-Message-State: AO0yUKWKMHjOdFOV59UFSBMZUZfnwYUxj9Nd+4XWGKol/adcI9Epe9dq
        /tdFRJlH8vpSGljqfZSVXOQGrw==
X-Google-Smtp-Source: AK7set9wWH8UvdPf7RrbJNAmyeAIoySKNE2q5bncnFXEWEyL8idCKK8LzAGuO4lmiXQ6ysydd9CfXA==
X-Received: by 2002:a17:907:78cf:b0:889:58bd:86f1 with SMTP id kv15-20020a17090778cf00b0088958bd86f1mr11019725ejc.14.1679577972614;
        Thu, 23 Mar 2023 06:26:12 -0700 (PDT)
Received: from [192.168.10.20] ([87.116.37.42])
        by smtp.gmail.com with ESMTPSA id u23-20020a170906409700b009334a6ef3e8sm6632022ejj.141.2023.03.23.06.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 06:26:11 -0700 (PDT)
Message-ID: <3983f8bc-5be2-bb3c-a5cd-647550f577a0@bjorling.me>
Date:   Thu, 23 Mar 2023 14:26:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v8 0/4] Add zoned storage emulation to virtio-blk driver
Content-Language: en-US
To:     Sam Li <faithilikerun@gmail.com>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        damien.lemoal@opensource.wdc.com, kvm@vger.kernel.org,
        hare@suse.de, Paolo Bonzini <pbonzini@redhat.com>,
        dmitry.fomichev@wdc.com, Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20230323052828.6545-1-faithilikerun@gmail.com>
From:   =?UTF-8?Q?Matias_Bj=c3=b8rling?= <m@bjorling.me>
In-Reply-To: <20230323052828.6545-1-faithilikerun@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/2023 06.28, Sam Li wrote:
> This patch adds zoned storage emulation to the virtio-blk driver.
> 
> The patch implements the virtio-blk ZBD support standardization that is
> recently accepted by virtio-spec. The link to related commit is at
> 
> https://github.com/oasis-tcs/virtio-spec/commit/b4e8efa0fa6c8d844328090ad15db65af8d7d981
> 
> The Linux zoned device code that implemented by Dmitry Fomichev has been
> released at the latest Linux version v6.3-rc1.
> 
> Aside: adding zoned=on alike options to virtio-blk device will be
> considered in following-up plan.
> 
> v7:
> - address Stefan's review comments
>    * rm aio_context_acquire/release in handle_req
>    * rename function return type
>    * rename BLOCK_ACCT_APPEND to BLOCK_ACCT_ZONE_APPEND for clarity
> 
> v6:
> - update headers to v6.3-rc1
> 
> v5:
> - address Stefan's review comments
>    * restore the way writing zone append result to buffer
>    * fix error checking case and other errands
> 
> v4:
> - change the way writing zone append request result to buffer
> - change zone state, zone type value of virtio_blk_zone_descriptor
> - add trace events for new zone APIs
> 
> v3:
> - use qemuio_from_buffer to write status bit [Stefan]
> - avoid using req->elem directly [Stefan]
> - fix error checkings and memory leak [Stefan]
> 
> v2:
> - change units of emulated zone op coresponding to block layer APIs
> - modify error checking cases [Stefan, Damien]
> 
> v1:
> - add zoned storage emulation
> 
> Sam Li (4):
>    include: update virtio_blk headers to v6.3-rc1
>    virtio-blk: add zoned storage emulation for zoned devices
>    block: add accounting for zone append operation
>    virtio-blk: add some trace events for zoned emulation
> 
>   block/qapi-sysemu.c                          |  11 +
>   block/qapi.c                                 |  18 +
>   hw/block/trace-events                        |   7 +
>   hw/block/virtio-blk-common.c                 |   2 +
>   hw/block/virtio-blk.c                        | 405 +++++++++++++++++++
>   include/block/accounting.h                   |   1 +
>   include/standard-headers/drm/drm_fourcc.h    |  12 +
>   include/standard-headers/linux/ethtool.h     |  48 ++-
>   include/standard-headers/linux/fuse.h        |  45 ++-
>   include/standard-headers/linux/pci_regs.h    |   1 +
>   include/standard-headers/linux/vhost_types.h |   2 +
>   include/standard-headers/linux/virtio_blk.h  | 105 +++++
>   linux-headers/asm-arm64/kvm.h                |   1 +
>   linux-headers/asm-x86/kvm.h                  |  34 +-
>   linux-headers/linux/kvm.h                    |   9 +
>   linux-headers/linux/vfio.h                   |  15 +-
>   linux-headers/linux/vhost.h                  |   8 +
>   qapi/block-core.json                         |  62 ++-
>   qapi/block.json                              |   4 +
>   19 files changed, 769 insertions(+), 21 deletions(-)
> 


Hi Sam,

I applied your patches and can report that they work with both SMR HDDs 
and ZNS SSDs. Very nice work!

Regarding the documentation (docs/system/qemu-block-drivers.rst.inc). Is 
it possible to expose the host's zoned block device through something 
else than virtio-blk? If not, I wouldn't mind seeing the documentation 
updated to show a case when using the virtio-blk driver.

For example (this also includes the device part):

-device virtio-blk-pci,drive=drive0,id=virtblk0 \
-blockdev 
host_device,node-name=drive0,filename=/dev/nullb0,cache.direct=on``

It might also be nice to describe the shorthand for those that likes to 
pass in the parameters using only the -drive parameter.

  -drive driver=host_device,file=/dev/nullb0,if=virtio,cache.direct=on

Cheers, Matias

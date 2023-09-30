Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97FC57B41DB
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 17:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbjI3Pu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Sep 2023 11:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjI3Pu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Sep 2023 11:50:57 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663029C
        for <kvm@vger.kernel.org>; Sat, 30 Sep 2023 08:50:53 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1qmcEr-00086K-WD; Sat, 30 Sep 2023 17:50:42 +0200
Message-ID: <239fecd6-c184-4187-85bb-2826ae2ce0d0@maciej.szmigiero.name>
Date:   Sat, 30 Sep 2023 17:50:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/18] virtio-mem: Update state to match bitmap as soon
 as it's been migrated
Content-Language: en-US, pl-PL
To:     David Hildenbrand <david@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
References: <20230926185738.277351-1-david@redhat.com>
 <20230926185738.277351-16-david@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Autocrypt: addr=mail@maciej.szmigiero.name; keydata=
 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
In-Reply-To: <20230926185738.277351-16-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.09.2023 20:57, David Hildenbrand wrote:
> It's cleaner and future-proof to just have other state that depends on the
> bitmap state to be updated as soon as possible when restoring the bitmap.
> 
> So factor out informing RamDiscardListener into a functon and call it in
> case of early migration right after we restored the bitmap.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   hw/virtio/virtio-mem.c | 26 +++++++++++++++++++++-----
>   1 file changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index 0b0e6c5090..0cf47df9cf 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -984,9 +984,8 @@ static int virtio_mem_restore_unplugged(VirtIOMEM *vmem)
>                                                  virtio_mem_discard_range_cb);
>   }
>   
> -static int virtio_mem_post_load(void *opaque, int version_id)
> +static int virtio_mem_post_load_bitmap(VirtIOMEM *vmem)
>   {
> -    VirtIOMEM *vmem = VIRTIO_MEM(opaque);
>       RamDiscardListener *rdl;
>       int ret;
>   
> @@ -1001,6 +1000,20 @@ static int virtio_mem_post_load(void *opaque, int version_id)
>               return ret;
>           }
>       }
> +    return 0;
> +}
> +
> +static int virtio_mem_post_load(void *opaque, int version_id)
> +{
> +    VirtIOMEM *vmem = VIRTIO_MEM(opaque);
> +    int ret;
> +
> +    if (!vmem->early_migration) {
> +        ret = virtio_mem_post_load_bitmap(vmem);
> +        if (ret) {
> +            return ret;
> +        }
> +    }
>   
>       /*
>        * If shared RAM is migrated using the file content and not using QEMU,
> @@ -1043,7 +1056,7 @@ static int virtio_mem_post_load_early(void *opaque, int version_id)
>       int ret;
>   
>       if (!vmem->prealloc) {
> -        return 0;
> +        goto post_load_bitmap;
>       }
>   
>       /*
> @@ -1051,7 +1064,7 @@ static int virtio_mem_post_load_early(void *opaque, int version_id)
>        * don't mess with preallocation and postcopy.
>        */
>       if (migrate_ram_is_ignored(rb)) {
> -        return 0;
> +        goto post_load_bitmap;
>       }
>   
>       /*
> @@ -1084,7 +1097,10 @@ static int virtio_mem_post_load_early(void *opaque, int version_id)
>               return -EBUSY;
>           }
>       }
> -    return 0;
> +
> +post_load_bitmap:
> +    /* Finally, update any other state to be consistent with the new bitmap. */
> +    return virtio_mem_post_load_bitmap(vmem);
>   }
>   
>   typedef struct VirtIOMEMMigSanityChecks {


Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks,
Maciej


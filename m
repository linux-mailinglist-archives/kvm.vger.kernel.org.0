Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB77D7BCBB2
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 04:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344317AbjJHCT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 22:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344249AbjJHCTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 22:19:55 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D4BB9;
        Sat,  7 Oct 2023 19:19:52 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VtcTNin_1696731589;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VtcTNin_1696731589)
          by smtp.aliyun-inc.com;
          Sun, 08 Oct 2023 10:19:50 +0800
Message-ID: <1696731557.4612653-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v2 1/2] tools/virtio: Add dma sync api for virtio test
Date:   Sun, 8 Oct 2023 10:19:17 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     liming.wu@jaguarmicro.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liming Wu <liming.wu@jaguarmicro.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20230926050021.717-1-liming.wu@jaguarmicro.com>
 <20230926050021.717-2-liming.wu@jaguarmicro.com>
 <20230927111904-mutt-send-email-mst@kernel.org>
 <20231007065547.1028-1-liming.wu@jaguarmicro.com>
In-Reply-To: <20231007065547.1028-1-liming.wu@jaguarmicro.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat,  7 Oct 2023 14:55:46 +0800, liming.wu@jaguarmicro.com wrote:
> From: Liming Wu <liming.wu@jaguarmicro.com>
>
> Fixes: 8bd2f71054bd ("virtio_ring: introduce dma sync api for virtqueue")
> also add dma sync api for virtio test.
>
> Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>

You should post a new thread.

Thanks.


> ---
>  tools/virtio/linux/dma-mapping.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/tools/virtio/linux/dma-mapping.h b/tools/virtio/linux/dma-mapping.h
> index 834a90bd3270..822ecaa8e4df 100644
> --- a/tools/virtio/linux/dma-mapping.h
> +++ b/tools/virtio/linux/dma-mapping.h
> @@ -24,11 +24,23 @@ enum dma_data_direction {
>  #define dma_map_page(d, p, o, s, dir) (page_to_phys(p) + (o))
>
>  #define dma_map_single(d, p, s, dir) (virt_to_phys(p))
> +#define dma_map_single_attrs(d, p, s, dir, a) (virt_to_phys(p))
>  #define dma_mapping_error(...) (0)
>
>  #define dma_unmap_single(d, a, s, r) do { (void)(d); (void)(a); (void)(s); (void)(r); } while (0)
>  #define dma_unmap_page(d, a, s, r) do { (void)(d); (void)(a); (void)(s); (void)(r); } while (0)
>
> +#define sg_dma_address(sg) (0)
> +#define dma_need_sync(v, a) (0)
> +#define dma_unmap_single_attrs(d, a, s, r, t) do { \
> +	(void)(d); (void)(a); (void)(s); (void)(r); (void)(t); \
> +} while (0)
> +#define dma_sync_single_range_for_cpu(d, a, o, s, r) do { \
> +	(void)(d); (void)(a); (void)(o); (void)(s); (void)(r); \
> +} while (0)
> +#define dma_sync_single_range_for_device(d, a, o, s, r) do { \
> +	(void)(d); (void)(a); (void)(o); (void)(s); (void)(r); \
> +} while (0)
>  #define dma_max_mapping_size(...) SIZE_MAX
>
>  #endif
> --
> 2.34.1
>

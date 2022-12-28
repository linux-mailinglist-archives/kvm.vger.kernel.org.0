Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB004657779
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 15:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiL1OFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 09:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbiL1OFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 09:05:36 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A362F02B
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 06:05:35 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id m18so38523210eji.5
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 06:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qa1Un2aD6MzOChXpW2lvo7PrB2fYJUYolba5PD+0kxU=;
        b=bgdgeIEN0ymgrgBkrlPWoAACMkGVFu3yQCTxD1XFVC/9Bm1nMbIWaE65ImRQnmVORk
         YivS6/NCdAIcbx+eHLaJNfJj2UF8VSmTTZhl8/K8Sb+cJFhm+7lbAGgiXiUd0A8+5a8R
         vIBOoaF9cGZkaDaSuPAZNksQeewxwYr2XCJ7YPZXT6DyDX73EggMCwcoLKDguPpW6oLQ
         R4w4l4Za6UdBmkJlTWFY4jSqein+5h7XVU+hPxZ9aMlvcIV25x1J1/FJ9D/8VsNrKpOo
         7mgRj2IkOPASy2ur//3aRBQp1jadZN78WsyW56joBTMomDVPfZaEiCKO+MjEtVRJ13xL
         sEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qa1Un2aD6MzOChXpW2lvo7PrB2fYJUYolba5PD+0kxU=;
        b=54Ydppenc6c3eundMXrGVPcoi6E6Qda85KV5awvJ+uztNo0IqB8Ij4oNfsx7nI1Udt
         pRUJ6jMvDmZgS6zX/rhP/pg1dSwROkNJq29Es6ZfEKaD1BOa+zRwbgPoQdrhXyTzFlAj
         0lEP04QWxlpgJ9ScamFW4uIeesXlur5T16Ekl+o8QTRB2FdWhHPhIVSSwsw5+nNvMAVV
         iSKQSV8ADwRVc//OSYvTrGK7aoSDp1cWCjLU6tJnBrp3k0N2XJpX1QwxIJZuwGZBFpjX
         n3m8P5NNsVVKQoRxSEQT0KuN5TjhwnSKgSP/C/4tXyos5TY4C8EDdXGq9yRUdLudSBwj
         02pg==
X-Gm-Message-State: AFqh2kpQb89lGXVjJT1VwzklGsw1vpOZvyQMSg8Lfbr+F+RlU8AGYBBc
        UB66yZ1oRoE/OIePYeWNPXY0GQ==
X-Google-Smtp-Source: AMrXdXvInCyxWng1spL2lajh1TX2U28tgdxPwTbUS+oJTeLxMkgde1znoo+79B+GZpG03BEObk+x4Q==
X-Received: by 2002:a17:907:214d:b0:837:4378:dbd6 with SMTP id rk13-20020a170907214d00b008374378dbd6mr21853776ejb.22.1672236333905;
        Wed, 28 Dec 2022 06:05:33 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id h10-20020a05600c2caa00b003c701c12a17sm27698540wmc.12.2022.12.28.06.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 06:05:33 -0800 (PST)
Message-ID: <8a2fb7aa-316d-b6bc-1e8d-da5678008825@linaro.org>
Date:   Wed, 28 Dec 2022 15:05:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v1 10/12] virtio-mem: Fix typo in
 virito_mem_intersect_memory_section() function name
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org, QEMU Trivial <qemu-trivial@nongnu.org>
References: <20211027124531.57561-1-david@redhat.com>
 <20211027124531.57561-11-david@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20211027124531.57561-11-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/10/21 14:45, David Hildenbrand wrote:
> It's "virtio", not "virito".
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   hw/virtio/virtio-mem.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index d5a578142b..0f5eae4a7e 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -177,7 +177,7 @@ static int virtio_mem_for_each_unplugged_range(const VirtIOMEM *vmem, void *arg,
>    *
>    * Returns false if the intersection is empty, otherwise returns true.
>    */
> -static bool virito_mem_intersect_memory_section(MemoryRegionSection *s,
> +static bool virtio_mem_intersect_memory_section(MemoryRegionSection *s,
>                                                   uint64_t offset, uint64_t size)
>   {
>       uint64_t start = MAX(s->offset_within_region, offset);
> @@ -215,7 +215,7 @@ static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
>                                         first_bit + 1) - 1;
>           size = (last_bit - first_bit + 1) * vmem->block_size;
>   
> -        if (!virito_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
>               break;
>           }
>           ret = cb(&tmp, arg);
> @@ -247,7 +247,7 @@ static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
>                                    first_bit + 1) - 1;
>           size = (last_bit - first_bit + 1) * vmem->block_size;
>   
> -        if (!virito_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
>               break;
>           }
>           ret = cb(&tmp, arg);
> @@ -283,7 +283,7 @@ static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>           MemoryRegionSection tmp = *rdl->section;
>   
> -        if (!virito_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
>               continue;
>           }
>           rdl->notify_discard(rdl, &tmp);
> @@ -299,7 +299,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>           MemoryRegionSection tmp = *rdl->section;
>   
> -        if (!virito_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
>               continue;
>           }
>           ret = rdl->notify_populate(rdl, &tmp);
> @@ -316,7 +316,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>               if (rdl2 == rdl) {
>                   break;
>               }
> -            if (!virito_mem_intersect_memory_section(&tmp, offset, size)) {
> +            if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
>                   continue;
>               }
>               rdl2->notify_discard(rdl2, &tmp);


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DB31ED62B
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 20:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgFCSdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 14:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCSdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 14:33:22 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29525C08C5C0
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 11:33:22 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x6so3400529wrm.13
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 11:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z7ZSaQV8FCkoSIZW6VtjaYv7rq0pKKOrkPApUTO6y6A=;
        b=u1q9f/3e2+8xzbph2+6x6xAGEoU5SNI8kcvSzImcFXvfS5ZPQEkyOoqVKKPdqyXWLX
         hf81nvAXNR0Fm36WEVrpVKw+zPAVkjm0bbM7okM4T0vnbdmKGT/trXVWLk9DJ2kyKCmr
         Dlbd/TlUeaLb7v3quOIrFzFJdpAFavEsTsi0WAbeyd1ToGCDhdrYesXJlFohTdQwGCUc
         X6cWisoo7ihVNjEZJnk51V7pgVXKBjUzK9jVcrQUg7pNMQQiqb1Qpp669zvQkPWf1+hG
         XGXU766JtrIFEcZRjXIBERzHUYmAd/F5OhfIZRRZyxrnvIfQrPNEvGEo701dXcWil5vw
         MJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z7ZSaQV8FCkoSIZW6VtjaYv7rq0pKKOrkPApUTO6y6A=;
        b=Pj4zeksv/kANkF32yPWFbCpEj61wmcGa9hWFrJeVBJCkrlPZoqn3f4uXI8K9QoRLmG
         OI9D7TSK/L6mh1S4XvA7wyIhd1DwSUaJfSOJq3hH02L6D4E1Oxza4Rvs/TfaOMa0p2ph
         YUCCVgN2/8HdnEwFjbHkv3+5ba07+7SF3M1jIPAGcQ0ledIAbK51FM5/HnZ6Ijn4ywJw
         OJAFQRtQywF4N58U0ytgAGKciBr+6Qo+4VIgwag9E15lSoPoDzEy6xU/edkRsAWphcN9
         xEP35O9XsbbiJAfiKcfjPyMnsHa9ogBpYzILPCbd817KDjA6XupU0xTYqTjC7UiLRxhQ
         wMrg==
X-Gm-Message-State: AOAM531IJTZlkhlaoK6c5kGDT1SDVV+hlTxEYKnzvHHoSrGyUTGc6t8A
        vuAqpJYB/ZoCqgC3WFZ5nynh/YPcdFmnwTkOXaI=
X-Google-Smtp-Source: ABdhPJxhzl6xqHC2YqnpHtDWSfzfVs9/1wD5cdtokxBPSWg3b0KGSbnnHwoX/bQ6MSBau//Kj4kMcYG+NPySKwS71TM=
X-Received: by 2002:a5d:4282:: with SMTP id k2mr720391wrq.196.1591209200829;
 Wed, 03 Jun 2020 11:33:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200603144914.41645-1-david@redhat.com> <20200603144914.41645-15-david@redhat.com>
In-Reply-To: <20200603144914.41645-15-david@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Wed, 3 Jun 2020 20:33:09 +0200
Message-ID: <CAM9Jb+jQRteSthE3rWMBEybLcMyXO+C+Q1FiH1h63tLmWBL-wA@mail.gmail.com>
Subject: Re: [PATCH v3 14/20] numa: Handle virtio-mem in NUMA stats
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Account the memory to the configured nid.
>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  hw/core/numa.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/hw/core/numa.c b/hw/core/numa.c
> index 316bc50d75..06960918e7 100644
> --- a/hw/core/numa.c
> +++ b/hw/core/numa.c
> @@ -812,6 +812,7 @@ static void numa_stat_memory_devices(NumaNodeMem node_mem[])
>      MemoryDeviceInfoList *info;
>      PCDIMMDeviceInfo     *pcdimm_info;
>      VirtioPMEMDeviceInfo *vpi;
> +    VirtioMEMDeviceInfo *vmi;
>
>      for (info = info_list; info; info = info->next) {
>          MemoryDeviceInfo *value = info->value;
> @@ -832,6 +833,11 @@ static void numa_stat_memory_devices(NumaNodeMem node_mem[])
>                  node_mem[0].node_mem += vpi->size;
>                  node_mem[0].node_plugged_mem += vpi->size;
>                  break;
> +            case MEMORY_DEVICE_INFO_KIND_VIRTIO_MEM:
> +                vmi = value->u.virtio_mem.data;
> +                node_mem[vmi->node].node_mem += vmi->size;
> +                node_mem[vmi->node].node_plugged_mem += vmi->size;
> +                break;
>              default:
>                  g_assert_not_reached();
>              }

Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FF31C79DC
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 21:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgEFTEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 15:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgEFTEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 15:04:12 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C574FC061A0F
        for <kvm@vger.kernel.org>; Wed,  6 May 2020 12:04:11 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id w7so2644838wre.13
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 12:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zI2rVsBZU/4DMsKQSGJkMc32llG6pwBy1ecLqPkSI7g=;
        b=E8vtdGGL+17QzPBJtAa9W3tTi94Fgj59ETg7/RaYGvfCX6fXLi4+7GDcXed2Q/j005
         XGqEVHRj7j6GWeS+UT5Ida2WifIjZIJzrfJlwEeqaXNpbJiJ20Wp3wthQrg8AfNASolx
         f0xA3X8LaGCfNdK5RxAvBBtRoMxgDcY1KocAA1l/PPU3e2Ww8zxZpbbUqFHB1o1gbzZB
         esJF0RfZ1/BvjQxREkeJCJQZw5etgHhzkJQweYCEfdfRvxUVhG7rtBsvQNAWjHR6M1hO
         PrlUvrkPUubBZMHLYDHsxf4yZtr8uGQIf3YiRTN4mV6R0xi5nHMyi/OEnfkOAv+q1P4W
         RsKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zI2rVsBZU/4DMsKQSGJkMc32llG6pwBy1ecLqPkSI7g=;
        b=fxHNyg5g/P7CrRTKeB/phiBByMQVE/Phw3J/N725DJuAfCJqRfqSrQZsOiQds+JnsN
         iGIiKBFSr6yzUSMPlkyxeodNwDdKXkcgvQs9LEKUHJuZoHYEz1j17AramO2jecWBqBdM
         W87V7o3dFmdMVvUStJs11N4bR7u5U/OHAKD8JaiP99o17Z8m8YDBBHaxmvLTq8Rv32p7
         G/0rgszMXgWsIKaLqQacwsu4pCWRrwv3ZtjwSavLsd686sjsLv2xq8a6wz/Ob9yClT1j
         1DVUcXpXJUKuQejDwRrrcjrO7bT8gNGfXaBGG/GgVpJ6AVpiv+LGAqXEtR65L9wZhUgY
         Cgew==
X-Gm-Message-State: AGi0PuZ5P/4t4dzKECgMjHKZtUOf4Hjn/o78o2L/R/s2oPMN7oEak8dv
        reOL4XO1iQ3aWMXumfz2sZxULX6jPVDHfiVck8z5A1bt7AA=
X-Google-Smtp-Source: APiQypJ695dUm52RTtTasrBQFCirffcM4KKxo32D8lHArg30LaioHoUBnM58Vgt6YYgMOZj02ulQmJOvbIbJGVVR6p4=
X-Received: by 2002:a5d:6b8c:: with SMTP id n12mr9080420wrx.107.1588791850587;
 Wed, 06 May 2020 12:04:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200506094948.76388-1-david@redhat.com> <20200506094948.76388-14-david@redhat.com>
In-Reply-To: <20200506094948.76388-14-david@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Wed, 6 May 2020 21:03:59 +0200
Message-ID: <CAM9Jb+iP8EmMXmHneUSNo+kN75jcF2q0sUF+XzRkh2bV=o4Tbw@mail.gmail.com>
Subject: Re: [PATCH v1 13/17] hmp: Handle virtio-mem when printing memory
 device info
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Print the memory device info just like for other memory devices.
>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  monitor/hmp-cmds.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
> index 7f6e982dc8..4b3638a2a6 100644
> --- a/monitor/hmp-cmds.c
> +++ b/monitor/hmp-cmds.c
> @@ -1805,6 +1805,7 @@ void hmp_info_memory_devices(Monitor *mon, const QDict *qdict)
>      MemoryDeviceInfoList *info_list = qmp_query_memory_devices(&err);
>      MemoryDeviceInfoList *info;
>      VirtioPMEMDeviceInfo *vpi;
> +    VirtioMEMDeviceInfo *vmi;
>      MemoryDeviceInfo *value;
>      PCDIMMDeviceInfo *di;
>
> @@ -1839,6 +1840,21 @@ void hmp_info_memory_devices(Monitor *mon, const QDict *qdict)
>                  monitor_printf(mon, "  size: %" PRIu64 "\n", vpi->size);
>                  monitor_printf(mon, "  memdev: %s\n", vpi->memdev);
>                  break;
> +            case MEMORY_DEVICE_INFO_KIND_VIRTIO_MEM:
> +                vmi = value->u.virtio_mem.data;
> +                monitor_printf(mon, "Memory device [%s]: \"%s\"\n",
> +                               MemoryDeviceInfoKind_str(value->type),
> +                               vmi->id ? vmi->id : "");
> +                monitor_printf(mon, "  memaddr: 0x%" PRIx64 "\n", vmi->memaddr);
> +                monitor_printf(mon, "  node: %" PRId64 "\n", vmi->node);
> +                monitor_printf(mon, "  requested-size: %" PRIu64 "\n",
> +                               vmi->requested_size);
> +                monitor_printf(mon, "  size: %" PRIu64 "\n", vmi->size);
> +                monitor_printf(mon, "  max-size: %" PRIu64 "\n", vmi->max_size);
> +                monitor_printf(mon, "  block-size: %" PRIu64 "\n",
> +                               vmi->block_size);
> +                monitor_printf(mon, "  memdev: %s\n", vmi->memdev);
> +                break;
>              default:
>                  g_assert_not_reached();
>              }
> --
> 2.25.3

Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>

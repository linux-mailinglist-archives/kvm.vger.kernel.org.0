Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A672640ED
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgIJJIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:08:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38906 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728264AbgIJJIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 05:08:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599728929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mVa0T5osyyqVvof03O1uIvNYi/AqP9rH2A9BlQ3d+sw=;
        b=EZcsCd5l5dVfkaGgJhDanlG1o7fs/6677LN7MVfBdLO0XdszGgZnjw9FgoDDb9eVGcwBCh
        EZJWKDJGHW0STiJfsi0rwRXzn+9JxOev0yQGCMbcg6ceT7OWmNZWWds6sn1HpbV93FNmLA
        DjkiDqORN8j7zjiQGhWc2YOVMo0AXuY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-Ng4hHNEbMbmEPxzCCP53Mg-1; Thu, 10 Sep 2020 05:08:44 -0400
X-MC-Unique: Ng4hHNEbMbmEPxzCCP53Mg-1
Received: by mail-ed1-f71.google.com with SMTP id x14so2155256edv.8
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 02:08:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mVa0T5osyyqVvof03O1uIvNYi/AqP9rH2A9BlQ3d+sw=;
        b=fXLGcVw4yxishtZzK2o6c64G/QYnXxYk1aZFe8RNOD5D4VcPIuYfAUzga1TuiL+iyX
         K14pZ/KGY/FwjCt8XNwQxByEoJLIUpd1FXFgKGuyrs6peS3nZnxKQWmMLCU6vepHr3pR
         hQeeLCYjNupo/YqTDZu8qOl/UZixBJ78t2QhTo1a+Q/sdThgRDFeKy2gdfJVTFPm4Wa7
         UV/+9jFpfJRBU8w7dvJZ2zjBs1n9exUi+y09xJvvvX4e6/+Z6tb8UahLTHaTkR1EMg7Z
         3TyNm56poE9d1Wdj7gmCu5UcctvH2J1OJfqgTddhqi1CgQgEReMkyftRh+WZwW0ryWXN
         UKkw==
X-Gm-Message-State: AOAM532ihHXANtRQ2pQVPgP19R/nLJBoobyPQBGRwyoccozVODF/W+BO
        NRxmBvQfPiOVJTaq7LPkNJGf0sLSsFN214mD2vsKb2aSUvKcJXrmjagE5egrnGlLnKmnIPbzM0m
        J9mi0ZVyGAp4j
X-Received: by 2002:a50:e79c:: with SMTP id b28mr8408099edn.371.1599728922798;
        Thu, 10 Sep 2020 02:08:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9eOqrlCECRH6MG50KfAmNafiSMb7Yc+/HffHf28/7mAj1OyLe6oMQieOzo6YU+ROlMiNXbA==
X-Received: by 2002:a50:e79c:: with SMTP id b28mr8408080edn.371.1599728922550;
        Thu, 10 Sep 2020 02:08:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2744:1c91:fa55:fa01? ([2001:b07:6468:f312:2744:1c91:fa55:fa01])
        by smtp.gmail.com with ESMTPSA id m16sm6120969ejl.69.2020.09.10.02.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 02:08:42 -0700 (PDT)
Subject: Re: [PATCH 1/6] hw/ssi/aspeed_smc: Rename max_slaves as max_devices
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-trivial@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Joel Stanley <joel@jms.id.au>
References: <20200910070131.435543-1-philmd@redhat.com>
 <20200910070131.435543-2-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <34760c71-c6da-4730-2b1a-5c5be0b7ff9f@redhat.com>
Date:   Thu, 10 Sep 2020 11:08:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200910070131.435543-2-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/09/20 09:01, Philippe Mathieu-Daudé wrote:
> In order to use inclusive terminology, rename max_slaves
> as max_devices.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>

I think we should consider a wholesale replacement of SSISlave with
SSIPeripheral according to the proposal at
https://www.oshwa.org/a-resolution-to-redefine-spi-signal-names/.

Paolo

> ---
>  include/hw/ssi/aspeed_smc.h |  2 +-
>  hw/ssi/aspeed_smc.c         | 40 ++++++++++++++++++-------------------
>  2 files changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/include/hw/ssi/aspeed_smc.h b/include/hw/ssi/aspeed_smc.h
> index 6fbbb238f15..52ae34e38d1 100644
> --- a/include/hw/ssi/aspeed_smc.h
> +++ b/include/hw/ssi/aspeed_smc.h
> @@ -42,7 +42,7 @@ typedef struct AspeedSMCController {
>      uint8_t r_timings;
>      uint8_t nregs_timings;
>      uint8_t conf_enable_w0;
> -    uint8_t max_slaves;
> +    uint8_t max_devices;
>      const AspeedSegments *segments;
>      hwaddr flash_window_base;
>      uint32_t flash_window_size;
> diff --git a/hw/ssi/aspeed_smc.c b/hw/ssi/aspeed_smc.c
> index 795784e5f36..8219272016c 100644
> --- a/hw/ssi/aspeed_smc.c
> +++ b/hw/ssi/aspeed_smc.c
> @@ -259,7 +259,7 @@ static const AspeedSMCController controllers[] = {
>          .r_timings         = R_TIMINGS,
>          .nregs_timings     = 1,
>          .conf_enable_w0    = CONF_ENABLE_W0,
> -        .max_slaves        = 1,
> +        .max_devices       = 1,
>          .segments          = aspeed_segments_legacy,
>          .flash_window_base = ASPEED_SOC_SMC_FLASH_BASE,
>          .flash_window_size = 0x6000000,
> @@ -275,7 +275,7 @@ static const AspeedSMCController controllers[] = {
>          .r_timings         = R_TIMINGS,
>          .nregs_timings     = 1,
>          .conf_enable_w0    = CONF_ENABLE_W0,
> -        .max_slaves        = 5,
> +        .max_devices       = 5,
>          .segments          = aspeed_segments_fmc,
>          .flash_window_base = ASPEED_SOC_FMC_FLASH_BASE,
>          .flash_window_size = 0x10000000,
> @@ -293,7 +293,7 @@ static const AspeedSMCController controllers[] = {
>          .r_timings         = R_SPI_TIMINGS,
>          .nregs_timings     = 1,
>          .conf_enable_w0    = SPI_CONF_ENABLE_W0,
> -        .max_slaves        = 1,
> +        .max_devices       = 1,
>          .segments          = aspeed_segments_spi,
>          .flash_window_base = ASPEED_SOC_SPI_FLASH_BASE,
>          .flash_window_size = 0x10000000,
> @@ -309,7 +309,7 @@ static const AspeedSMCController controllers[] = {
>          .r_timings         = R_TIMINGS,
>          .nregs_timings     = 1,
>          .conf_enable_w0    = CONF_ENABLE_W0,
> -        .max_slaves        = 3,
> +        .max_devices       = 3,
>          .segments          = aspeed_segments_ast2500_fmc,
>          .flash_window_base = ASPEED_SOC_FMC_FLASH_BASE,
>          .flash_window_size = 0x10000000,
> @@ -327,7 +327,7 @@ static const AspeedSMCController controllers[] = {
>          .r_timings         = R_TIMINGS,
>          .nregs_timings     = 1,
>          .conf_enable_w0    = CONF_ENABLE_W0,
> -        .max_slaves        = 2,
> +        .max_devices       = 2,
>          .segments          = aspeed_segments_ast2500_spi1,
>          .flash_window_base = ASPEED_SOC_SPI_FLASH_BASE,
>          .flash_window_size = 0x8000000,
> @@ -343,7 +343,7 @@ static const AspeedSMCController controllers[] = {
>          .r_timings         = R_TIMINGS,
>          .nregs_timings     = 1,
>          .conf_enable_w0    = CONF_ENABLE_W0,
> -        .max_slaves        = 2,
> +        .max_devices       = 2,
>          .segments          = aspeed_segments_ast2500_spi2,
>          .flash_window_base = ASPEED_SOC_SPI2_FLASH_BASE,
>          .flash_window_size = 0x8000000,
> @@ -359,7 +359,7 @@ static const AspeedSMCController controllers[] = {
>          .r_timings         = R_TIMINGS,
>          .nregs_timings     = 1,
>          .conf_enable_w0    = CONF_ENABLE_W0,
> -        .max_slaves        = 3,
> +        .max_devices       = 3,
>          .segments          = aspeed_segments_ast2600_fmc,
>          .flash_window_base = ASPEED26_SOC_FMC_FLASH_BASE,
>          .flash_window_size = 0x10000000,
> @@ -377,7 +377,7 @@ static const AspeedSMCController controllers[] = {
>          .r_timings         = R_TIMINGS,
>          .nregs_timings     = 2,
>          .conf_enable_w0    = CONF_ENABLE_W0,
> -        .max_slaves        = 2,
> +        .max_devices       = 2,
>          .segments          = aspeed_segments_ast2600_spi1,
>          .flash_window_base = ASPEED26_SOC_SPI_FLASH_BASE,
>          .flash_window_size = 0x10000000,
> @@ -395,7 +395,7 @@ static const AspeedSMCController controllers[] = {
>          .r_timings         = R_TIMINGS,
>          .nregs_timings     = 3,
>          .conf_enable_w0    = CONF_ENABLE_W0,
> -        .max_slaves        = 3,
> +        .max_devices       = 3,
>          .segments          = aspeed_segments_ast2600_spi2,
>          .flash_window_base = ASPEED26_SOC_SPI2_FLASH_BASE,
>          .flash_window_size = 0x10000000,
> @@ -476,7 +476,7 @@ static bool aspeed_smc_flash_overlap(const AspeedSMCState *s,
>      AspeedSegments seg;
>      int i;
>  
> -    for (i = 0; i < s->ctrl->max_slaves; i++) {
> +    for (i = 0; i < s->ctrl->max_devices; i++) {
>          if (i == cs) {
>              continue;
>          }
> @@ -537,7 +537,7 @@ static void aspeed_smc_flash_set_segment(AspeedSMCState *s, int cs,
>       */
>      if ((s->ctrl->segments == aspeed_segments_ast2500_spi1 ||
>           s->ctrl->segments == aspeed_segments_ast2500_spi2) &&
> -        cs == s->ctrl->max_slaves &&
> +        cs == s->ctrl->max_devices &&
>          seg.addr + seg.size != s->ctrl->segments[cs].addr +
>          s->ctrl->segments[cs].size) {
>          qemu_log_mask(LOG_GUEST_ERROR,
> @@ -948,7 +948,7 @@ static void aspeed_smc_reset(DeviceState *d)
>      }
>  
>      /* setup the default segment register values and regions for all */
> -    for (i = 0; i < s->ctrl->max_slaves; ++i) {
> +    for (i = 0; i < s->ctrl->max_devices; ++i) {
>          aspeed_smc_flash_set_segment_region(s, i,
>                      s->ctrl->segment_to_reg(s, &s->ctrl->segments[i]));
>      }
> @@ -995,8 +995,8 @@ static uint64_t aspeed_smc_read(void *opaque, hwaddr addr, unsigned int size)
>          (s->ctrl->has_dma && addr == R_DMA_DRAM_ADDR) ||
>          (s->ctrl->has_dma && addr == R_DMA_LEN) ||
>          (s->ctrl->has_dma && addr == R_DMA_CHECKSUM) ||
> -        (addr >= R_SEG_ADDR0 && addr < R_SEG_ADDR0 + s->ctrl->max_slaves) ||
> -        (addr >= s->r_ctrl0 && addr < s->r_ctrl0 + s->ctrl->max_slaves)) {
> +        (addr >= R_SEG_ADDR0 && addr < R_SEG_ADDR0 + s->ctrl->max_devices) ||
> +        (addr >= s->r_ctrl0 && addr < s->r_ctrl0 + s->ctrl->max_devices)) {
>  
>          trace_aspeed_smc_read(addr, size, s->regs[addr]);
>  
> @@ -1270,7 +1270,7 @@ static void aspeed_smc_write(void *opaque, hwaddr addr, uint64_t data,
>          int cs = addr - s->r_ctrl0;
>          aspeed_smc_flash_update_ctrl(&s->flashes[cs], value);
>      } else if (addr >= R_SEG_ADDR0 &&
> -               addr < R_SEG_ADDR0 + s->ctrl->max_slaves) {
> +               addr < R_SEG_ADDR0 + s->ctrl->max_devices) {
>          int cs = addr - R_SEG_ADDR0;
>  
>          if (value != s->regs[R_SEG_ADDR0 + cs]) {
> @@ -1341,10 +1341,10 @@ static void aspeed_smc_realize(DeviceState *dev, Error **errp)
>      s->conf_enable_w0 = s->ctrl->conf_enable_w0;
>  
>      /* Enforce some real HW limits */
> -    if (s->num_cs > s->ctrl->max_slaves) {
> +    if (s->num_cs > s->ctrl->max_devices) {
>          qemu_log_mask(LOG_GUEST_ERROR, "%s: num_cs cannot exceed: %d\n",
> -                      __func__, s->ctrl->max_slaves);
> -        s->num_cs = s->ctrl->max_slaves;
> +                      __func__, s->ctrl->max_devices);
> +        s->num_cs = s->ctrl->max_devices;
>      }
>  
>      /* DMA irq. Keep it first for the initialization in the SoC */
> @@ -1376,7 +1376,7 @@ static void aspeed_smc_realize(DeviceState *dev, Error **errp)
>                            s->ctrl->flash_window_size);
>      sysbus_init_mmio(sbd, &s->mmio_flash);
>  
> -    s->flashes = g_new0(AspeedSMCFlash, s->ctrl->max_slaves);
> +    s->flashes = g_new0(AspeedSMCFlash, s->ctrl->max_devices);
>  
>      /*
>       * Let's create a sub memory region for each possible slave. All
> @@ -1385,7 +1385,7 @@ static void aspeed_smc_realize(DeviceState *dev, Error **errp)
>       * module behind to handle the memory accesses. This depends on
>       * the board configuration.
>       */
> -    for (i = 0; i < s->ctrl->max_slaves; ++i) {
> +    for (i = 0; i < s->ctrl->max_devices; ++i) {
>          AspeedSMCFlash *fl = &s->flashes[i];
>  
>          snprintf(name, sizeof(name), "%s.%d", s->ctrl->name, i);
> 


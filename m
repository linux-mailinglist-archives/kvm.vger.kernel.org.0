Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9DC265A84
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 09:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgIKH2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 03:28:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50422 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725747AbgIKH2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 03:28:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599809318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JHiQFD3vupbkNfCoZoJphbTkUL+RRIYm7TfbINdW/ro=;
        b=NlP8nAm26DDbV+10ko1EiDZYdKkU95oipUXrk3ZHIXph00qBXv2dPIcEAGemH1/XprD0Kc
        S1hAI2bfTmMJaoXJ2RKKVAa0M/PF9k6uOAhkcegsr/5nxB/wrEr8C2ZjN/zSE58ULQR8h3
        gGd3/mihW/mtiI+QfK4S1MPd0/bhQfU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-O5WWqKtvP7G2k81NbAavKA-1; Fri, 11 Sep 2020 03:28:36 -0400
X-MC-Unique: O5WWqKtvP7G2k81NbAavKA-1
Received: by mail-ej1-f71.google.com with SMTP id ml20so4173710ejb.23
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 00:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JHiQFD3vupbkNfCoZoJphbTkUL+RRIYm7TfbINdW/ro=;
        b=oHi4pKCGzstIlyulgIiQQ96y3UrCKNeuGgfGtT03c7g6aR+mYLs9sXQEHGiTMwANaD
         fUzAzAghJIJmUQIkhqx241jY/asRYfv+nBiDPUiuXQWbqzPKyuQCi11pGJPVNFxyektL
         Dd3jQruuKs5o9tISyCpvjh1EhR8oz8ly2HynHiJXjMNLxRFTfaN7N/EWteyxT1B9KD2C
         ZA4KIpqcIJZ1muNy4+voJ4pieMSUe6Uh1CHmRpHARYfCxdt26j8qDP2KgJ1nVniARO51
         w0XNlquzB9t0b8BOFw3mSqiVZYflYr1sa0x341qtrArJq3tCPeLE6e0zVYhWMhkz1QCy
         OqBQ==
X-Gm-Message-State: AOAM532RrByE9+oz8aY/P7k2uk+Zx7OGE/F4gM78wW8fka6JMkUb4VV9
        J7pWRp71wRH5/ou/eZUxlMMNQRwngvnyXxb/gGBMiwvxLKhLpngZD499iOu2GfkwSi7nOWptL8I
        jxmKbM9V5ZIms
X-Received: by 2002:a05:6402:48a:: with SMTP id k10mr689734edv.22.1599809315429;
        Fri, 11 Sep 2020 00:28:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJza8f0yx04MoOIRTr+QFfy5v71HO/nOCisyuoK5dyFG5uH4B/d9YBDbmug7x0U24mq2ASm0kw==
X-Received: by 2002:a05:6402:48a:: with SMTP id k10mr689714edv.22.1599809315254;
        Fri, 11 Sep 2020 00:28:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:6689:90a2:a29f:8336? ([2001:b07:6468:f312:6689:90a2:a29f:8336])
        by smtp.gmail.com with ESMTPSA id o93sm970877edd.75.2020.09.11.00.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 00:28:34 -0700 (PDT)
Subject: Re: [PATCH 3/6] hw/dma/xilinx_axidma: Rename StreamSlave as
 StreamSink
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
 <20200910070131.435543-4-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <71dad67c-a36e-8cd1-1f47-7a9bba1c74b0@redhat.com>
Date:   Fri, 11 Sep 2020 09:28:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200910070131.435543-4-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/09/20 09:01, Philippe Mathieu-Daudé wrote:
> In order to use inclusive terminology, rename 'slave stream'
> as 'sink stream'.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  hw/dma/xilinx_axidma.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/hw/dma/xilinx_axidma.c b/hw/dma/xilinx_axidma.c
> index cf12a852ea1..19e14a2997e 100644
> --- a/hw/dma/xilinx_axidma.c
> +++ b/hw/dma/xilinx_axidma.c
> @@ -46,11 +46,11 @@
>       OBJECT_CHECK(XilinxAXIDMA, (obj), TYPE_XILINX_AXI_DMA)
>  
>  #define XILINX_AXI_DMA_DATA_STREAM(obj) \
> -     OBJECT_CHECK(XilinxAXIDMAStreamSlave, (obj),\
> +     OBJECT_CHECK(XilinxAXIDMAStreamSink, (obj),\
>       TYPE_XILINX_AXI_DMA_DATA_STREAM)
>  
>  #define XILINX_AXI_DMA_CONTROL_STREAM(obj) \
> -     OBJECT_CHECK(XilinxAXIDMAStreamSlave, (obj),\
> +     OBJECT_CHECK(XilinxAXIDMAStreamSink, (obj),\
>       TYPE_XILINX_AXI_DMA_CONTROL_STREAM)
>  
>  #define R_DMACR             (0x00 / 4)
> @@ -63,7 +63,7 @@
>  #define CONTROL_PAYLOAD_SIZE (CONTROL_PAYLOAD_WORDS * (sizeof(uint32_t)))
>  
>  typedef struct XilinxAXIDMA XilinxAXIDMA;
> -typedef struct XilinxAXIDMAStreamSlave XilinxAXIDMAStreamSlave;
> +typedef struct XilinxAXIDMAStreamSink XilinxAXIDMAStreamSink;
>  
>  enum {
>      DMACR_RUNSTOP = 1,
> @@ -118,7 +118,7 @@ struct Stream {
>      unsigned char txbuf[16 * 1024];
>  };
>  
> -struct XilinxAXIDMAStreamSlave {
> +struct XilinxAXIDMAStreamSink {
>      Object parent;
>  
>      struct XilinxAXIDMA *dma;
> @@ -133,8 +133,8 @@ struct XilinxAXIDMA {
>      uint32_t freqhz;
>      StreamSink *tx_data_dev;
>      StreamSink *tx_control_dev;
> -    XilinxAXIDMAStreamSlave rx_data_dev;
> -    XilinxAXIDMAStreamSlave rx_control_dev;
> +    XilinxAXIDMAStreamSink rx_data_dev;
> +    XilinxAXIDMAStreamSink rx_control_dev;
>  
>      struct Stream streams[2];
>  
> @@ -390,7 +390,7 @@ static size_t
>  xilinx_axidma_control_stream_push(StreamSink *obj, unsigned char *buf,
>                                    size_t len, bool eop)
>  {
> -    XilinxAXIDMAStreamSlave *cs = XILINX_AXI_DMA_CONTROL_STREAM(obj);
> +    XilinxAXIDMAStreamSink *cs = XILINX_AXI_DMA_CONTROL_STREAM(obj);
>      struct Stream *s = &cs->dma->streams[1];
>  
>      if (len != CONTROL_PAYLOAD_SIZE) {
> @@ -407,7 +407,7 @@ xilinx_axidma_data_stream_can_push(StreamSink *obj,
>                                     StreamCanPushNotifyFn notify,
>                                     void *notify_opaque)
>  {
> -    XilinxAXIDMAStreamSlave *ds = XILINX_AXI_DMA_DATA_STREAM(obj);
> +    XilinxAXIDMAStreamSink *ds = XILINX_AXI_DMA_DATA_STREAM(obj);
>      struct Stream *s = &ds->dma->streams[1];
>  
>      if (!stream_running(s) || stream_idle(s)) {
> @@ -423,7 +423,7 @@ static size_t
>  xilinx_axidma_data_stream_push(StreamSink *obj, unsigned char *buf, size_t len,
>                                 bool eop)
>  {
> -    XilinxAXIDMAStreamSlave *ds = XILINX_AXI_DMA_DATA_STREAM(obj);
> +    XilinxAXIDMAStreamSink *ds = XILINX_AXI_DMA_DATA_STREAM(obj);
>      struct Stream *s = &ds->dma->streams[1];
>      size_t ret;
>  
> @@ -534,8 +534,8 @@ static const MemoryRegionOps axidma_ops = {
>  static void xilinx_axidma_realize(DeviceState *dev, Error **errp)
>  {
>      XilinxAXIDMA *s = XILINX_AXI_DMA(dev);
> -    XilinxAXIDMAStreamSlave *ds = XILINX_AXI_DMA_DATA_STREAM(&s->rx_data_dev);
> -    XilinxAXIDMAStreamSlave *cs = XILINX_AXI_DMA_CONTROL_STREAM(
> +    XilinxAXIDMAStreamSink *ds = XILINX_AXI_DMA_DATA_STREAM(&s->rx_data_dev);
> +    XilinxAXIDMAStreamSink *cs = XILINX_AXI_DMA_CONTROL_STREAM(
>                                                              &s->rx_control_dev);
>      int i;
>  
> @@ -634,7 +634,7 @@ static const TypeInfo axidma_info = {
>  static const TypeInfo xilinx_axidma_data_stream_info = {
>      .name          = TYPE_XILINX_AXI_DMA_DATA_STREAM,
>      .parent        = TYPE_OBJECT,
> -    .instance_size = sizeof(struct XilinxAXIDMAStreamSlave),
> +    .instance_size = sizeof(struct XilinxAXIDMAStreamSink),
>      .class_init    = xilinx_axidma_stream_class_init,
>      .class_data    = &xilinx_axidma_data_stream_class,
>      .interfaces = (InterfaceInfo[]) {
> @@ -646,7 +646,7 @@ static const TypeInfo xilinx_axidma_data_stream_info = {
>  static const TypeInfo xilinx_axidma_control_stream_info = {
>      .name          = TYPE_XILINX_AXI_DMA_CONTROL_STREAM,
>      .parent        = TYPE_OBJECT,
> -    .instance_size = sizeof(struct XilinxAXIDMAStreamSlave),
> +    .instance_size = sizeof(struct XilinxAXIDMAStreamSink),
>      .class_init    = xilinx_axidma_stream_class_init,
>      .class_data    = &xilinx_axidma_control_stream_class,
>      .interfaces = (InterfaceInfo[]) {
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


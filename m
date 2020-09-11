Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394F2265A8E
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 09:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgIKHcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 03:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgIKHcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 03:32:00 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE64C061573
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 00:32:00 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id x69so4994898lff.3
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 00:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gLWFaOrTgYE9gb7vfvSK1qpEJDLObDW4x6A89Wj47sE=;
        b=J9S5khHysLs8NJ7BNlj7gJ8WBPGTPm34CVbBTUbMTeVEoOZC0IsmPxU+MQZUOk9i/V
         E8q/IKjL3Z5ny4GYADQ8eDp8Ui7hFaqdizplVDg28yJXb3Pfw3DBXHuDMDVGzDX54yfd
         F042DpuoH9om/VI+nSYQX/jdxWSqPLWhVUM1FwGtjl3w83km8KFct2KMWQ1tTNnrFZq2
         C40FIEU3Dn/R2pLdopymR1Ha22XrDpMBb9XdmYpc38DondqPxynGhYmjwgoAz580clGj
         4tqZUx1u2sK+9Q5Qp8wIupAWzwwUcT+VBcp2HqB48J7u1gp2XKQh0fsP26jUiQXDIZZ7
         N7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gLWFaOrTgYE9gb7vfvSK1qpEJDLObDW4x6A89Wj47sE=;
        b=WItHtWtF8wa374lNmNkQh5ZkbTqzIxrzXktLAHrWwF5tUWbz4PcBvUl+CuMQ7/Z2aJ
         zRFxjZppmrZmqxs8Tqjja0RhYvI0StJb/gPco7Nytm/vGiOMJFtb3vk6c6xk99YRkt0F
         TpMljKscAfdUoRyEfbb0wG1/0XJPfMGErIooPHbnUCDDcgHn3dAcL0s2l9r0ivGp7Zn2
         PAIlbcEn8WJMKsTiHHFmif6IlXS8jOpdaFAq6Asja2vLzpnPvwb/ukksdkHaAmSNiheA
         WjqqtmNFalg0i/f5rz534DKp18txMYcM8rY60P9NRfZWUSUdILGf8qSgSqC5XP1y4/zm
         uqSA==
X-Gm-Message-State: AOAM530dW4gPD1mjDQnRoI+SSW8h+VMqabZtWa9QQaTPKyXHSo+Z5YI0
        MSJhc9Lz7VwfX1BuDE4dZPM=
X-Google-Smtp-Source: ABdhPJynaUdw0cL24VPHKuwLMvVQCWLtF4qVFNhOWznD/sR29cSv/Nil8HkSdxS5NbVPVXctVcFXRA==
X-Received: by 2002:a19:8247:: with SMTP id e68mr304829lfd.65.1599809518529;
        Fri, 11 Sep 2020 00:31:58 -0700 (PDT)
Received: from gmail.com (81-231-232-130-no39.tbcn.telia.com. [81.231.232.130])
        by smtp.gmail.com with ESMTPSA id a12sm365545ljk.109.2020.09.11.00.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 00:31:58 -0700 (PDT)
Date:   Fri, 11 Sep 2020 09:31:57 +0200
From:   "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
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
Subject: Re: [PATCH 3/6] hw/dma/xilinx_axidma: Rename StreamSlave as
 StreamSink
Message-ID: <20200911073157.GD2954729@toto>
References: <20200910070131.435543-1-philmd@redhat.com>
 <20200910070131.435543-4-philmd@redhat.com>
 <71dad67c-a36e-8cd1-1f47-7a9bba1c74b0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71dad67c-a36e-8cd1-1f47-7a9bba1c74b0@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 11, 2020 at 09:28:34AM +0200, Paolo Bonzini wrote:
> On 10/09/20 09:01, Philippe Mathieu-Daudé wrote:
> > In order to use inclusive terminology, rename 'slave stream'
> > as 'sink stream'.
> > 
> > Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> > ---
> >  hw/dma/xilinx_axidma.c | 26 +++++++++++++-------------
> >  1 file changed, 13 insertions(+), 13 deletions(-)
> > 
> > diff --git a/hw/dma/xilinx_axidma.c b/hw/dma/xilinx_axidma.c
> > index cf12a852ea1..19e14a2997e 100644
> > --- a/hw/dma/xilinx_axidma.c
> > +++ b/hw/dma/xilinx_axidma.c
> > @@ -46,11 +46,11 @@
> >       OBJECT_CHECK(XilinxAXIDMA, (obj), TYPE_XILINX_AXI_DMA)
> >  
> >  #define XILINX_AXI_DMA_DATA_STREAM(obj) \
> > -     OBJECT_CHECK(XilinxAXIDMAStreamSlave, (obj),\
> > +     OBJECT_CHECK(XilinxAXIDMAStreamSink, (obj),\
> >       TYPE_XILINX_AXI_DMA_DATA_STREAM)
> >  
> >  #define XILINX_AXI_DMA_CONTROL_STREAM(obj) \
> > -     OBJECT_CHECK(XilinxAXIDMAStreamSlave, (obj),\
> > +     OBJECT_CHECK(XilinxAXIDMAStreamSink, (obj),\
> >       TYPE_XILINX_AXI_DMA_CONTROL_STREAM)
> >  
> >  #define R_DMACR             (0x00 / 4)
> > @@ -63,7 +63,7 @@
> >  #define CONTROL_PAYLOAD_SIZE (CONTROL_PAYLOAD_WORDS * (sizeof(uint32_t)))
> >  
> >  typedef struct XilinxAXIDMA XilinxAXIDMA;
> > -typedef struct XilinxAXIDMAStreamSlave XilinxAXIDMAStreamSlave;
> > +typedef struct XilinxAXIDMAStreamSink XilinxAXIDMAStreamSink;
> >  
> >  enum {
> >      DMACR_RUNSTOP = 1,
> > @@ -118,7 +118,7 @@ struct Stream {
> >      unsigned char txbuf[16 * 1024];
> >  };
> >  
> > -struct XilinxAXIDMAStreamSlave {
> > +struct XilinxAXIDMAStreamSink {
> >      Object parent;
> >  
> >      struct XilinxAXIDMA *dma;
> > @@ -133,8 +133,8 @@ struct XilinxAXIDMA {
> >      uint32_t freqhz;
> >      StreamSink *tx_data_dev;
> >      StreamSink *tx_control_dev;
> > -    XilinxAXIDMAStreamSlave rx_data_dev;
> > -    XilinxAXIDMAStreamSlave rx_control_dev;
> > +    XilinxAXIDMAStreamSink rx_data_dev;
> > +    XilinxAXIDMAStreamSink rx_control_dev;
> >  
> >      struct Stream streams[2];
> >  
> > @@ -390,7 +390,7 @@ static size_t
> >  xilinx_axidma_control_stream_push(StreamSink *obj, unsigned char *buf,
> >                                    size_t len, bool eop)
> >  {
> > -    XilinxAXIDMAStreamSlave *cs = XILINX_AXI_DMA_CONTROL_STREAM(obj);
> > +    XilinxAXIDMAStreamSink *cs = XILINX_AXI_DMA_CONTROL_STREAM(obj);
> >      struct Stream *s = &cs->dma->streams[1];
> >  
> >      if (len != CONTROL_PAYLOAD_SIZE) {
> > @@ -407,7 +407,7 @@ xilinx_axidma_data_stream_can_push(StreamSink *obj,
> >                                     StreamCanPushNotifyFn notify,
> >                                     void *notify_opaque)
> >  {
> > -    XilinxAXIDMAStreamSlave *ds = XILINX_AXI_DMA_DATA_STREAM(obj);
> > +    XilinxAXIDMAStreamSink *ds = XILINX_AXI_DMA_DATA_STREAM(obj);
> >      struct Stream *s = &ds->dma->streams[1];
> >  
> >      if (!stream_running(s) || stream_idle(s)) {
> > @@ -423,7 +423,7 @@ static size_t
> >  xilinx_axidma_data_stream_push(StreamSink *obj, unsigned char *buf, size_t len,
> >                                 bool eop)
> >  {
> > -    XilinxAXIDMAStreamSlave *ds = XILINX_AXI_DMA_DATA_STREAM(obj);
> > +    XilinxAXIDMAStreamSink *ds = XILINX_AXI_DMA_DATA_STREAM(obj);
> >      struct Stream *s = &ds->dma->streams[1];
> >      size_t ret;
> >  
> > @@ -534,8 +534,8 @@ static const MemoryRegionOps axidma_ops = {
> >  static void xilinx_axidma_realize(DeviceState *dev, Error **errp)
> >  {
> >      XilinxAXIDMA *s = XILINX_AXI_DMA(dev);
> > -    XilinxAXIDMAStreamSlave *ds = XILINX_AXI_DMA_DATA_STREAM(&s->rx_data_dev);
> > -    XilinxAXIDMAStreamSlave *cs = XILINX_AXI_DMA_CONTROL_STREAM(
> > +    XilinxAXIDMAStreamSink *ds = XILINX_AXI_DMA_DATA_STREAM(&s->rx_data_dev);
> > +    XilinxAXIDMAStreamSink *cs = XILINX_AXI_DMA_CONTROL_STREAM(
> >                                                              &s->rx_control_dev);
> >      int i;
> >  
> > @@ -634,7 +634,7 @@ static const TypeInfo axidma_info = {
> >  static const TypeInfo xilinx_axidma_data_stream_info = {
> >      .name          = TYPE_XILINX_AXI_DMA_DATA_STREAM,
> >      .parent        = TYPE_OBJECT,
> > -    .instance_size = sizeof(struct XilinxAXIDMAStreamSlave),
> > +    .instance_size = sizeof(struct XilinxAXIDMAStreamSink),
> >      .class_init    = xilinx_axidma_stream_class_init,
> >      .class_data    = &xilinx_axidma_data_stream_class,
> >      .interfaces = (InterfaceInfo[]) {
> > @@ -646,7 +646,7 @@ static const TypeInfo xilinx_axidma_data_stream_info = {
> >  static const TypeInfo xilinx_axidma_control_stream_info = {
> >      .name          = TYPE_XILINX_AXI_DMA_CONTROL_STREAM,
> >      .parent        = TYPE_OBJECT,
> > -    .instance_size = sizeof(struct XilinxAXIDMAStreamSlave),
> > +    .instance_size = sizeof(struct XilinxAXIDMAStreamSink),
> >      .class_init    = xilinx_axidma_stream_class_init,
> >      .class_data    = &xilinx_axidma_control_stream_class,
> >      .interfaces = (InterfaceInfo[]) {
> > 
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Edgar E. Iglesias <edgar.iglesias@xilinx.com>



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E704B265A8F
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 09:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbgIKHc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 03:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgIKHcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 03:32:14 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B28C061756
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 00:32:14 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b12so4958804lfp.9
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 00:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LHK4F2MqWd5dXKy2V+64wHdCsq3BPH6G32kaFVS1Kgg=;
        b=UNV2LkEjubfC/T5nSdh5SJQEeFEi+/GuTRy/PdeUmphzfexU206EnRai71uF2gRuaA
         IzvGp1pSIwarpiPgMDh1q8s8jH8rE0hyo3KMsCt68m0uRFNYIKpoTBbEs+gG0gA1Bm7B
         coX9xzWLNnjUtL1klXrTbpYVZBlCrFnSqCFCnQiY+Xc6vz8amBpGd+V0uQ7LeF256iPo
         7Hn/qLsgr/Y6sCDJgMyfj5L4Hr5+WwWHkIYK8YUs1TehOZDpoDM/ly3ZvJfFcfSp5Z2V
         j65gPkHQWFVCq0S2N6MvkqyLUCq5UIoz+tuVlXjfqd3LGBdwxpVhi3UEsx2FrffvdZVn
         ENNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LHK4F2MqWd5dXKy2V+64wHdCsq3BPH6G32kaFVS1Kgg=;
        b=ckqNd/ze7pbooAzz2TjbQCq7csIYw1vbKeLu4pghCqsPTVfVGWiM+omBTCN+0m9Mg8
         E5ixBsecu512STsiUNeZWY2R/TQABki9scsmiuBN05btm+u9T7LmvpBQhY9B0wg+mq5K
         ZLL2mObVVi1yTkgFIcWoZcV8UxO47nTWJda+uxt2dXYeLgNhqDhECe5GKNV+Cr7tfpky
         +HmzgLPNfVqard47yShN2tFeZqf5NmbMAEtY2TqvAJ2fi8q5cI3c7Tw+lvc4EMQeD7dU
         rIaV8w79TN8W03Fwed6CnBdzlSOeQbMyxIbV4haihohR2u9TyA+UkJpF9aECs9hGboPo
         seZg==
X-Gm-Message-State: AOAM532N+TSv/K7WWBThyImw+FMNIzL7rEdL+pwwWqesNt1ZHAsjesoV
        YVuUnPSB2wX9N4FlnjksxMY=
X-Google-Smtp-Source: ABdhPJxyeuqUgihgOc4fwupdHuaN5J/O1r9PTCdHVhBWU7k75LyYISClw14MKQIX4EKOUkT1VwT9LQ==
X-Received: by 2002:a19:ca48:: with SMTP id h8mr297019lfj.173.1599809532525;
        Fri, 11 Sep 2020 00:32:12 -0700 (PDT)
Received: from gmail.com (81-231-232-130-no39.tbcn.telia.com. [81.231.232.130])
        by smtp.gmail.com with ESMTPSA id j4sm362441ljc.116.2020.09.11.00.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 00:32:11 -0700 (PDT)
Date:   Fri, 11 Sep 2020 09:32:11 +0200
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
Subject: Re: [PATCH 4/6] hw/net/xilinx_axienet: Rename StreamSlave as
 StreamSink
Message-ID: <20200911073211.GE2954729@toto>
References: <20200910070131.435543-1-philmd@redhat.com>
 <20200910070131.435543-5-philmd@redhat.com>
 <9214b56d-59e7-1229-bf01-b6dca0445014@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9214b56d-59e7-1229-bf01-b6dca0445014@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 11, 2020 at 09:28:38AM +0200, Paolo Bonzini wrote:
> On 10/09/20 09:01, Philippe Mathieu-Daudé wrote:
> > In order to use inclusive terminology, rename 'slave stream'
> > as 'sink stream'.
> > 
> > Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> > ---
> >  hw/net/xilinx_axienet.c | 24 ++++++++++++------------
> >  1 file changed, 12 insertions(+), 12 deletions(-)
> > 
> > diff --git a/hw/net/xilinx_axienet.c b/hw/net/xilinx_axienet.c
> > index 0c4ac727207..4e48535f373 100644
> > --- a/hw/net/xilinx_axienet.c
> > +++ b/hw/net/xilinx_axienet.c
> > @@ -46,11 +46,11 @@
> >       OBJECT_CHECK(XilinxAXIEnet, (obj), TYPE_XILINX_AXI_ENET)
> >  
> >  #define XILINX_AXI_ENET_DATA_STREAM(obj) \
> > -     OBJECT_CHECK(XilinxAXIEnetStreamSlave, (obj),\
> > +     OBJECT_CHECK(XilinxAXIEnetStreamSink, (obj),\
> >       TYPE_XILINX_AXI_ENET_DATA_STREAM)
> >  
> >  #define XILINX_AXI_ENET_CONTROL_STREAM(obj) \
> > -     OBJECT_CHECK(XilinxAXIEnetStreamSlave, (obj),\
> > +     OBJECT_CHECK(XilinxAXIEnetStreamSink, (obj),\
> >       TYPE_XILINX_AXI_ENET_CONTROL_STREAM)
> >  
> >  /* Advertisement control register. */
> > @@ -310,10 +310,10 @@ struct TEMAC  {
> >      void *parent;
> >  };
> >  
> > -typedef struct XilinxAXIEnetStreamSlave XilinxAXIEnetStreamSlave;
> > +typedef struct XilinxAXIEnetStreamSink XilinxAXIEnetStreamSink;
> >  typedef struct XilinxAXIEnet XilinxAXIEnet;
> >  
> > -struct XilinxAXIEnetStreamSlave {
> > +struct XilinxAXIEnetStreamSink {
> >      Object parent;
> >  
> >      struct XilinxAXIEnet *enet;
> > @@ -325,8 +325,8 @@ struct XilinxAXIEnet {
> >      qemu_irq irq;
> >      StreamSink *tx_data_dev;
> >      StreamSink *tx_control_dev;
> > -    XilinxAXIEnetStreamSlave rx_data_dev;
> > -    XilinxAXIEnetStreamSlave rx_control_dev;
> > +    XilinxAXIEnetStreamSink rx_data_dev;
> > +    XilinxAXIEnetStreamSink rx_control_dev;
> >      NICState *nic;
> >      NICConf conf;
> >  
> > @@ -859,7 +859,7 @@ xilinx_axienet_control_stream_push(StreamSink *obj, uint8_t *buf, size_t len,
> >                                     bool eop)
> >  {
> >      int i;
> > -    XilinxAXIEnetStreamSlave *cs = XILINX_AXI_ENET_CONTROL_STREAM(obj);
> > +    XilinxAXIEnetStreamSink *cs = XILINX_AXI_ENET_CONTROL_STREAM(obj);
> >      XilinxAXIEnet *s = cs->enet;
> >  
> >      assert(eop);
> > @@ -880,7 +880,7 @@ static size_t
> >  xilinx_axienet_data_stream_push(StreamSink *obj, uint8_t *buf, size_t size,
> >                                  bool eop)
> >  {
> > -    XilinxAXIEnetStreamSlave *ds = XILINX_AXI_ENET_DATA_STREAM(obj);
> > +    XilinxAXIEnetStreamSink *ds = XILINX_AXI_ENET_DATA_STREAM(obj);
> >      XilinxAXIEnet *s = ds->enet;
> >  
> >      /* TX enable ?  */
> > @@ -954,8 +954,8 @@ static NetClientInfo net_xilinx_enet_info = {
> >  static void xilinx_enet_realize(DeviceState *dev, Error **errp)
> >  {
> >      XilinxAXIEnet *s = XILINX_AXI_ENET(dev);
> > -    XilinxAXIEnetStreamSlave *ds = XILINX_AXI_ENET_DATA_STREAM(&s->rx_data_dev);
> > -    XilinxAXIEnetStreamSlave *cs = XILINX_AXI_ENET_CONTROL_STREAM(
> > +    XilinxAXIEnetStreamSink *ds = XILINX_AXI_ENET_DATA_STREAM(&s->rx_data_dev);
> > +    XilinxAXIEnetStreamSink *cs = XILINX_AXI_ENET_CONTROL_STREAM(
> >                                                              &s->rx_control_dev);
> >  
> >      object_property_add_link(OBJECT(ds), "enet", "xlnx.axi-ethernet",
> > @@ -1046,7 +1046,7 @@ static const TypeInfo xilinx_enet_info = {
> >  static const TypeInfo xilinx_enet_data_stream_info = {
> >      .name          = TYPE_XILINX_AXI_ENET_DATA_STREAM,
> >      .parent        = TYPE_OBJECT,
> > -    .instance_size = sizeof(struct XilinxAXIEnetStreamSlave),
> > +    .instance_size = sizeof(struct XilinxAXIEnetStreamSink),
> >      .class_init    = xilinx_enet_data_stream_class_init,
> >      .interfaces = (InterfaceInfo[]) {
> >              { TYPE_STREAM_SINK },
> > @@ -1057,7 +1057,7 @@ static const TypeInfo xilinx_enet_data_stream_info = {
> >  static const TypeInfo xilinx_enet_control_stream_info = {
> >      .name          = TYPE_XILINX_AXI_ENET_CONTROL_STREAM,
> >      .parent        = TYPE_OBJECT,
> > -    .instance_size = sizeof(struct XilinxAXIEnetStreamSlave),
> > +    .instance_size = sizeof(struct XilinxAXIEnetStreamSink),
> >      .class_init    = xilinx_enet_control_stream_class_init,
> >      .interfaces = (InterfaceInfo[]) {
> >              { TYPE_STREAM_SINK },
> > 
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>


Reviewed-by: Edgar E. Iglesias <edgar.iglesias@xilinx.com>


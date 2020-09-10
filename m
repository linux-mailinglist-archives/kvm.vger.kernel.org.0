Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E013263DEF
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 09:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgIJHEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 03:04:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38176 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728350AbgIJHCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 03:02:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599721320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rOfPlRcHNPnFEFQL04D9b7WV0+f6qJ96Y7nXN27AiJ8=;
        b=DqgzaIGC+UQIswSB8VEBdy2lw1XG+YOezbYbLSMdQlgwDmQSL90320eSfnqTZ/Y+qV6Sjx
        1Y233cFPAGjD8SKqVqQpkvzZ6urfFnR9qvtN/yntyS1Lr5MTdbLYx9dZG4QK6EOVJefYku
        Kns2aLcKDaPEUmNNcLEcKPiLQIVtzK0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-qA5pmw3vNBGaA84JvlGttQ-1; Thu, 10 Sep 2020 03:01:58 -0400
X-MC-Unique: qA5pmw3vNBGaA84JvlGttQ-1
Received: by mail-wr1-f72.google.com with SMTP id b7so1891781wrn.6
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 00:01:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rOfPlRcHNPnFEFQL04D9b7WV0+f6qJ96Y7nXN27AiJ8=;
        b=m+0EATNYMmhtx749X0pBnrKMQXikSujYNSFlQqlS6Pn5Z4NssdUbeEw5QXwOpFD+6j
         Kp5lOC1vXvmd2qbIQhk0OKCabteIqwhe87H1vPKqSOYLzNzLtREaciRRN2ZyJShy8bB5
         s4hIehooXfd4u1NwBgJCSIZGyCN6AEkYRNLkjhNDPv6P+nzicqu05ftdqtp/wALOKDKC
         pcbstXrGLBRCMhUVfPLsi2/0hVlEcJBf2GvrAQM8zN5ruRgfZRfZTn9ia6w63EpYg7vg
         2f5gPiDx2hXhFHBGntVXgR9kEh7Qy7aecfPQWQEg7Hx+1n3tjG2gUWSKX1PCsjOJuFIC
         nDmg==
X-Gm-Message-State: AOAM532UIOm54zpClCiJKXU5ut/2lzMEyV3tlvKev8+oCQHp4ONjPjRX
        7Vq93VbNLQJBOuqCq7JBWrpHoB0ic9ekoP1AmGhpg0HMmUbuogaiopb7GBhthkH1dRdkPT3EnEd
        1lkaTwBBwsG0P
X-Received: by 2002:adf:e852:: with SMTP id d18mr8003818wrn.40.1599721316985;
        Thu, 10 Sep 2020 00:01:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlwpG0tUUcWG7cYI6DeHX0M5TDMJpNZQcQfEC1vqrWrbjug/Hj3GDkPn1UBSppzX4Ol1mWhw==
X-Received: by 2002:adf:e852:: with SMTP id d18mr8003791wrn.40.1599721316799;
        Thu, 10 Sep 2020 00:01:56 -0700 (PDT)
Received: from x1w.redhat.com (65.red-83-57-170.dynamicip.rima-tde.net. [83.57.170.65])
        by smtp.gmail.com with ESMTPSA id f6sm2615123wme.32.2020.09.10.00.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 00:01:56 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-trivial@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Joel Stanley <joel@jms.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 4/6] hw/net/xilinx_axienet: Rename StreamSlave as StreamSink
Date:   Thu, 10 Sep 2020 09:01:29 +0200
Message-Id: <20200910070131.435543-5-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910070131.435543-1-philmd@redhat.com>
References: <20200910070131.435543-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to use inclusive terminology, rename 'slave stream'
as 'sink stream'.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/net/xilinx_axienet.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/hw/net/xilinx_axienet.c b/hw/net/xilinx_axienet.c
index 0c4ac727207..4e48535f373 100644
--- a/hw/net/xilinx_axienet.c
+++ b/hw/net/xilinx_axienet.c
@@ -46,11 +46,11 @@
      OBJECT_CHECK(XilinxAXIEnet, (obj), TYPE_XILINX_AXI_ENET)
 
 #define XILINX_AXI_ENET_DATA_STREAM(obj) \
-     OBJECT_CHECK(XilinxAXIEnetStreamSlave, (obj),\
+     OBJECT_CHECK(XilinxAXIEnetStreamSink, (obj),\
      TYPE_XILINX_AXI_ENET_DATA_STREAM)
 
 #define XILINX_AXI_ENET_CONTROL_STREAM(obj) \
-     OBJECT_CHECK(XilinxAXIEnetStreamSlave, (obj),\
+     OBJECT_CHECK(XilinxAXIEnetStreamSink, (obj),\
      TYPE_XILINX_AXI_ENET_CONTROL_STREAM)
 
 /* Advertisement control register. */
@@ -310,10 +310,10 @@ struct TEMAC  {
     void *parent;
 };
 
-typedef struct XilinxAXIEnetStreamSlave XilinxAXIEnetStreamSlave;
+typedef struct XilinxAXIEnetStreamSink XilinxAXIEnetStreamSink;
 typedef struct XilinxAXIEnet XilinxAXIEnet;
 
-struct XilinxAXIEnetStreamSlave {
+struct XilinxAXIEnetStreamSink {
     Object parent;
 
     struct XilinxAXIEnet *enet;
@@ -325,8 +325,8 @@ struct XilinxAXIEnet {
     qemu_irq irq;
     StreamSink *tx_data_dev;
     StreamSink *tx_control_dev;
-    XilinxAXIEnetStreamSlave rx_data_dev;
-    XilinxAXIEnetStreamSlave rx_control_dev;
+    XilinxAXIEnetStreamSink rx_data_dev;
+    XilinxAXIEnetStreamSink rx_control_dev;
     NICState *nic;
     NICConf conf;
 
@@ -859,7 +859,7 @@ xilinx_axienet_control_stream_push(StreamSink *obj, uint8_t *buf, size_t len,
                                    bool eop)
 {
     int i;
-    XilinxAXIEnetStreamSlave *cs = XILINX_AXI_ENET_CONTROL_STREAM(obj);
+    XilinxAXIEnetStreamSink *cs = XILINX_AXI_ENET_CONTROL_STREAM(obj);
     XilinxAXIEnet *s = cs->enet;
 
     assert(eop);
@@ -880,7 +880,7 @@ static size_t
 xilinx_axienet_data_stream_push(StreamSink *obj, uint8_t *buf, size_t size,
                                 bool eop)
 {
-    XilinxAXIEnetStreamSlave *ds = XILINX_AXI_ENET_DATA_STREAM(obj);
+    XilinxAXIEnetStreamSink *ds = XILINX_AXI_ENET_DATA_STREAM(obj);
     XilinxAXIEnet *s = ds->enet;
 
     /* TX enable ?  */
@@ -954,8 +954,8 @@ static NetClientInfo net_xilinx_enet_info = {
 static void xilinx_enet_realize(DeviceState *dev, Error **errp)
 {
     XilinxAXIEnet *s = XILINX_AXI_ENET(dev);
-    XilinxAXIEnetStreamSlave *ds = XILINX_AXI_ENET_DATA_STREAM(&s->rx_data_dev);
-    XilinxAXIEnetStreamSlave *cs = XILINX_AXI_ENET_CONTROL_STREAM(
+    XilinxAXIEnetStreamSink *ds = XILINX_AXI_ENET_DATA_STREAM(&s->rx_data_dev);
+    XilinxAXIEnetStreamSink *cs = XILINX_AXI_ENET_CONTROL_STREAM(
                                                             &s->rx_control_dev);
 
     object_property_add_link(OBJECT(ds), "enet", "xlnx.axi-ethernet",
@@ -1046,7 +1046,7 @@ static const TypeInfo xilinx_enet_info = {
 static const TypeInfo xilinx_enet_data_stream_info = {
     .name          = TYPE_XILINX_AXI_ENET_DATA_STREAM,
     .parent        = TYPE_OBJECT,
-    .instance_size = sizeof(struct XilinxAXIEnetStreamSlave),
+    .instance_size = sizeof(struct XilinxAXIEnetStreamSink),
     .class_init    = xilinx_enet_data_stream_class_init,
     .interfaces = (InterfaceInfo[]) {
             { TYPE_STREAM_SINK },
@@ -1057,7 +1057,7 @@ static const TypeInfo xilinx_enet_data_stream_info = {
 static const TypeInfo xilinx_enet_control_stream_info = {
     .name          = TYPE_XILINX_AXI_ENET_CONTROL_STREAM,
     .parent        = TYPE_OBJECT,
-    .instance_size = sizeof(struct XilinxAXIEnetStreamSlave),
+    .instance_size = sizeof(struct XilinxAXIEnetStreamSink),
     .class_init    = xilinx_enet_control_stream_class_init,
     .interfaces = (InterfaceInfo[]) {
             { TYPE_STREAM_SINK },
-- 
2.26.2


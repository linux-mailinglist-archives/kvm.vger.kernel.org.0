Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEF9263DF4
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 09:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730353AbgIJHEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 03:04:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25804 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728611AbgIJHB7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 03:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599721316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tLJtjbF1Sn9R0haF3xV7HnFQaxPu+haN5ye/cmISEq4=;
        b=W0vZgMUX84Jpl0zQUzhd2STzSkTO/JEHBjG8Iu4nu+YFv6fQOweAuede01zZYU5PpSN/s9
        knhM/EojDR533Mkf5vYuM19pJhSnjx5iQU/mBHoFqJhf8TMXV//xgM8O5JOUzjDk1D7QtK
        2SAL6NIR8bbhY5mWggyFw7qFnjJK5I4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50--og28JQ_NYacGtJ-RMDC-g-1; Thu, 10 Sep 2020 03:01:52 -0400
X-MC-Unique: -og28JQ_NYacGtJ-RMDC-g-1
Received: by mail-wr1-f71.google.com with SMTP id g6so1895151wrv.3
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 00:01:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tLJtjbF1Sn9R0haF3xV7HnFQaxPu+haN5ye/cmISEq4=;
        b=Ri33+Q+J4h2hFrQePHnTPxa1sP2W+FQvYjHOe9VC9PSbDyW/khveeiVPD2/2Kqd3pK
         IyLxnKCaEcUEFQQb03xZcl93gRbfIEVZYEGyawfFFAS6UcS88MLsTe7s5ZQR6mxKmV3C
         DNp1u07uoUmRKjS4HuZjxkTrPA6RPWQTLLpyGY3aTu1iTnSiwZTaiK5gG/G1YM9wuyDc
         CB6vyLFHm1aU8650DghjAGBxXkMcr6YMaKQhY3ngU83ITaC+/kN3I2ITAiZdUOaZDj58
         hHDtQOsikZb4wV4aS4SctnOkHAvu4StO2Z1y6vtMEDXd/VdMriDCw5E4z9r9zy0ua/T5
         8YZQ==
X-Gm-Message-State: AOAM533ZoKIoOvPJSzLwfXA+UWkCTtkcgehWwE5tm6wd9+HyFvcaQ4wi
        dAA8kej4QJvQhBg1wRWb+va5jeushbiDAESVBuB/UtDL4PJkwN6my1BYMIb/RN1UM/rWkasZvje
        FN1QhsQuuzAOX
X-Received: by 2002:a5d:4ccb:: with SMTP id c11mr7278672wrt.159.1599721311427;
        Thu, 10 Sep 2020 00:01:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8i7cmKf45V5kbz2l0XObKJh2WEGqkHysM6c4v7BhvhCTsiOpA+VO+/qwWJnvJcR5KLi5V/A==
X-Received: by 2002:a5d:4ccb:: with SMTP id c11mr7278646wrt.159.1599721311241;
        Thu, 10 Sep 2020 00:01:51 -0700 (PDT)
Received: from x1w.redhat.com (65.red-83-57-170.dynamicip.rima-tde.net. [83.57.170.65])
        by smtp.gmail.com with ESMTPSA id n21sm2230672wmi.21.2020.09.10.00.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 00:01:50 -0700 (PDT)
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
Subject: [PATCH 3/6] hw/dma/xilinx_axidma: Rename StreamSlave as StreamSink
Date:   Thu, 10 Sep 2020 09:01:28 +0200
Message-Id: <20200910070131.435543-4-philmd@redhat.com>
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
 hw/dma/xilinx_axidma.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/hw/dma/xilinx_axidma.c b/hw/dma/xilinx_axidma.c
index cf12a852ea1..19e14a2997e 100644
--- a/hw/dma/xilinx_axidma.c
+++ b/hw/dma/xilinx_axidma.c
@@ -46,11 +46,11 @@
      OBJECT_CHECK(XilinxAXIDMA, (obj), TYPE_XILINX_AXI_DMA)
 
 #define XILINX_AXI_DMA_DATA_STREAM(obj) \
-     OBJECT_CHECK(XilinxAXIDMAStreamSlave, (obj),\
+     OBJECT_CHECK(XilinxAXIDMAStreamSink, (obj),\
      TYPE_XILINX_AXI_DMA_DATA_STREAM)
 
 #define XILINX_AXI_DMA_CONTROL_STREAM(obj) \
-     OBJECT_CHECK(XilinxAXIDMAStreamSlave, (obj),\
+     OBJECT_CHECK(XilinxAXIDMAStreamSink, (obj),\
      TYPE_XILINX_AXI_DMA_CONTROL_STREAM)
 
 #define R_DMACR             (0x00 / 4)
@@ -63,7 +63,7 @@
 #define CONTROL_PAYLOAD_SIZE (CONTROL_PAYLOAD_WORDS * (sizeof(uint32_t)))
 
 typedef struct XilinxAXIDMA XilinxAXIDMA;
-typedef struct XilinxAXIDMAStreamSlave XilinxAXIDMAStreamSlave;
+typedef struct XilinxAXIDMAStreamSink XilinxAXIDMAStreamSink;
 
 enum {
     DMACR_RUNSTOP = 1,
@@ -118,7 +118,7 @@ struct Stream {
     unsigned char txbuf[16 * 1024];
 };
 
-struct XilinxAXIDMAStreamSlave {
+struct XilinxAXIDMAStreamSink {
     Object parent;
 
     struct XilinxAXIDMA *dma;
@@ -133,8 +133,8 @@ struct XilinxAXIDMA {
     uint32_t freqhz;
     StreamSink *tx_data_dev;
     StreamSink *tx_control_dev;
-    XilinxAXIDMAStreamSlave rx_data_dev;
-    XilinxAXIDMAStreamSlave rx_control_dev;
+    XilinxAXIDMAStreamSink rx_data_dev;
+    XilinxAXIDMAStreamSink rx_control_dev;
 
     struct Stream streams[2];
 
@@ -390,7 +390,7 @@ static size_t
 xilinx_axidma_control_stream_push(StreamSink *obj, unsigned char *buf,
                                   size_t len, bool eop)
 {
-    XilinxAXIDMAStreamSlave *cs = XILINX_AXI_DMA_CONTROL_STREAM(obj);
+    XilinxAXIDMAStreamSink *cs = XILINX_AXI_DMA_CONTROL_STREAM(obj);
     struct Stream *s = &cs->dma->streams[1];
 
     if (len != CONTROL_PAYLOAD_SIZE) {
@@ -407,7 +407,7 @@ xilinx_axidma_data_stream_can_push(StreamSink *obj,
                                    StreamCanPushNotifyFn notify,
                                    void *notify_opaque)
 {
-    XilinxAXIDMAStreamSlave *ds = XILINX_AXI_DMA_DATA_STREAM(obj);
+    XilinxAXIDMAStreamSink *ds = XILINX_AXI_DMA_DATA_STREAM(obj);
     struct Stream *s = &ds->dma->streams[1];
 
     if (!stream_running(s) || stream_idle(s)) {
@@ -423,7 +423,7 @@ static size_t
 xilinx_axidma_data_stream_push(StreamSink *obj, unsigned char *buf, size_t len,
                                bool eop)
 {
-    XilinxAXIDMAStreamSlave *ds = XILINX_AXI_DMA_DATA_STREAM(obj);
+    XilinxAXIDMAStreamSink *ds = XILINX_AXI_DMA_DATA_STREAM(obj);
     struct Stream *s = &ds->dma->streams[1];
     size_t ret;
 
@@ -534,8 +534,8 @@ static const MemoryRegionOps axidma_ops = {
 static void xilinx_axidma_realize(DeviceState *dev, Error **errp)
 {
     XilinxAXIDMA *s = XILINX_AXI_DMA(dev);
-    XilinxAXIDMAStreamSlave *ds = XILINX_AXI_DMA_DATA_STREAM(&s->rx_data_dev);
-    XilinxAXIDMAStreamSlave *cs = XILINX_AXI_DMA_CONTROL_STREAM(
+    XilinxAXIDMAStreamSink *ds = XILINX_AXI_DMA_DATA_STREAM(&s->rx_data_dev);
+    XilinxAXIDMAStreamSink *cs = XILINX_AXI_DMA_CONTROL_STREAM(
                                                             &s->rx_control_dev);
     int i;
 
@@ -634,7 +634,7 @@ static const TypeInfo axidma_info = {
 static const TypeInfo xilinx_axidma_data_stream_info = {
     .name          = TYPE_XILINX_AXI_DMA_DATA_STREAM,
     .parent        = TYPE_OBJECT,
-    .instance_size = sizeof(struct XilinxAXIDMAStreamSlave),
+    .instance_size = sizeof(struct XilinxAXIDMAStreamSink),
     .class_init    = xilinx_axidma_stream_class_init,
     .class_data    = &xilinx_axidma_data_stream_class,
     .interfaces = (InterfaceInfo[]) {
@@ -646,7 +646,7 @@ static const TypeInfo xilinx_axidma_data_stream_info = {
 static const TypeInfo xilinx_axidma_control_stream_info = {
     .name          = TYPE_XILINX_AXI_DMA_CONTROL_STREAM,
     .parent        = TYPE_OBJECT,
-    .instance_size = sizeof(struct XilinxAXIDMAStreamSlave),
+    .instance_size = sizeof(struct XilinxAXIDMAStreamSink),
     .class_init    = xilinx_axidma_stream_class_init,
     .class_data    = &xilinx_axidma_control_stream_class,
     .interfaces = (InterfaceInfo[]) {
-- 
2.26.2


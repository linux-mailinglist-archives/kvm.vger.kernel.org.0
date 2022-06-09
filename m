Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52ECB5444B4
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 09:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239836AbiFIHUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 03:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236716AbiFIHUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 03:20:41 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A7C243EE7;
        Thu,  9 Jun 2022 00:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654759240; x=1686295240;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=cAhVzC+Qy8SQ5zAT4fg0oQl3ms6QKh++cVsGH/r5o6M=;
  b=PXdLcVmhXDX3lycrE7XDmz4mFmU7ItzGtia84XGw60belc/agCXeyCdX
   ifzXU2yxPMioYsM1tAZgBPvNAzn62Jsk11H7aSXCB8mIx68ETOuK1kBTt
   palwfy6IJbztfLOO6b592br8RL2xzqSLkaTfwmLpzTHg3STsPaIFmj3ca
   A=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 09 Jun 2022 00:20:39 -0700
X-QCInternal: smtphost
Received: from nasanex01b.na.qualcomm.com ([10.46.141.250])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 00:20:39 -0700
Received: from localhost (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 9 Jun 2022
 00:20:38 -0700
From:   Neeraj Upadhyay <quic_neeraju@quicinc.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <sudeep.holla@arm.com>,
        <cristian.marussi@arm.com>
CC:     <quic_sramana@quicinc.com>, <vincent.guittot@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>
Subject: [RFC 1/3] dt-bindings: arm: Add document for SCMI Virtio backend device
Date:   Thu, 9 Jun 2022 12:49:54 +0530
Message-ID: <20220609071956.5183-2-quic_neeraju@quicinc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220609071956.5183-1-quic_neeraju@quicinc.com>
References: <20220609071956.5183-1-quic_neeraju@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document the properties for ARM SCMI Virtio backend device
node.

Signed-off-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
---
 .../firmware/arm,scmi-vio-backend.yaml        | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/firmware/arm,scmi-vio-backend.yaml

diff --git a/Documentation/devicetree/bindings/firmware/arm,scmi-vio-backend.yaml b/Documentation/devicetree/bindings/firmware/arm,scmi-vio-backend.yaml
new file mode 100644
index 000000000000..c95d4e093a3c
--- /dev/null
+++ b/Documentation/devicetree/bindings/firmware/arm,scmi-vio-backend.yaml
@@ -0,0 +1,85 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/firmware/arm,scmi-vio-backend.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: System Control and Management Interface (SCMI) Virtio backend bindings
+
+maintainers:
+  - Neeraj Upadhyay <quic_neeraju@quicinc.com>
+
+description: |
+  This binding defines the interface for configuring the ARM SCMI Virtio
+  backend using device tree.
+
+properties:
+  $nodename:
+    const: scmi-vio-backend
+
+  compatible:
+    const: arm,scmi-vio-backend
+
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 0
+
+  protocol@11:
+    type: object
+    properties:
+      reg:
+        const: 0x11
+
+  protocol@13:
+    type: object
+    properties:
+      reg:
+        const: 0x13
+
+  protocol@14:
+    type: object
+    properties:
+      reg:
+        const: 0x14
+
+  protocol@15:
+    type: object
+    properties:
+      reg:
+        const: 0x15
+
+  protocol@16:
+    type: object
+    properties:
+      reg:
+        const: 0x16
+
+  protocol@17:
+    type: object
+    properties:
+      reg:
+        const: 0x17
+
+required:
+  - compatible
+
+examples:
+  - |
+    firmware {
+        scmi-vio-backend {
+            compatible = "arm,scmi-vio-backend";
+
+            scmi_vio_backend_clk: protocol@14 {
+                reg = <0x14>;
+            };
+
+            scmi_vio_backend_voltage: protocol@17 {
+                reg = <0x17>;
+            };
+        };
+    };
+
+...
-- 
2.17.1


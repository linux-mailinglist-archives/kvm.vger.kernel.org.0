Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7DD5972AE
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240784AbiHQPG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240662AbiHQPGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:06:13 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927DA2AE1F;
        Wed, 17 Aug 2022 08:06:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EnDz4p2i4UTdl29qdlFuG80mxYXJ+OPtSiNPsEMVU32ks63n0Fnc6R4JhEE4G2sdqgrTIggU7oXtcr1o1QxhSBtsRBwJyLmkgkLlKAyCJoYUlALUSN3fm91tuDoFAPrzlEb1tCrbK+WJu/4MrsrqHqJWHg0qA7GSrRy4JQBCZsQDsjr4Co+W2pQCXHgMiNoAjYrDmdRQd0Fm7xG+yFkHH3aGYSApUSJnK6xIKAUCW6PKDstij7z4sFYMNwolcVkOiJglEV6jZSjbIQihhpQtRzfm4hDJlBz3YRyhJiNJ41qgaxpv+553BN05n4UodB1WmB+UP0qoN2gWLtZJ/cZGlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWsorvBex3Wov6OyMQ2IkUQdba0x5LJ6y8N20iJEwbU=;
 b=K/RiJiz7YNThYwc6FyioFyXmamTwBOzSDGQ6m6GJw/u0UpxqcL6mEL0aEuEX6VsXQJPBtj9Y6KLdtQvpW6x7CcTCrNsSESmhRkx6Qcgbw1rtW+ivdZ5EZMj5w9rsyRYtYlGAQ+JQF8faWzRYGZuNFVIc5dEviGYVKqkCfI/q5ZeG3jtS0rbVRe3fQST8I/pxomzxZELCq1bkrz4CVbQ/NrCE/YvUfXwdTp+rTFQTB1hVXGIzYV8kGrRGinNbD2PVX3VrUgcAlGvkUjtvlTCXfZthS95cR0TlJQ/z3AA6KAp+zFrTMzhJDuXy9yKoJUh/XbM36AYVidQNnucFUdP+Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWsorvBex3Wov6OyMQ2IkUQdba0x5LJ6y8N20iJEwbU=;
 b=nauxjeakQ2apuOTcmrWYgBq7OGCDVXKR5WK8LwjAmPqS4Q9aEIsRcqJ6VW82koNK05PupuHRYjsao6nEQTWI8i3/AZdBBq4fNa47ae5q/27EBpbs3wcmwlfkhqnBPmYhSOrCvfElM/PPgGsSK8NLUNJd4p4jfUfwa9h52GJYNEc=
Received: from MW4PR03CA0297.namprd03.prod.outlook.com (2603:10b6:303:b5::32)
 by DM4PR12MB5069.namprd12.prod.outlook.com (2603:10b6:5:388::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 15:06:02 +0000
Received: from CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::f4) by MW4PR03CA0297.outlook.office365.com
 (2603:10b6:303:b5::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.14 via Frontend
 Transport; Wed, 17 Aug 2022 15:06:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT073.mail.protection.outlook.com (10.13.174.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5546.7 via Frontend Transport; Wed, 17 Aug 2022 15:06:02 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 17 Aug
 2022 10:06:00 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 17 Aug
 2022 10:05:59 -0500
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Wed, 17 Aug 2022 10:05:51 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <puneet.gupta@amd.com>,
        <song.bao.hua@hisilicon.com>, <mchehab+huawei@kernel.org>,
        <maz@kernel.org>, <f.fainelli@gmail.com>,
        <jeffrey.l.hugo@gmail.com>, <saravanak@google.com>,
        <Michael.Srba@seznam.cz>, <mani@kernel.org>, <yishaih@nvidia.com>,
        <jgg@ziepe.ca>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <okaya@kernel.org>, <harpreet.anand@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>, <git@amd.com>,
        Nipun Gupta <nipun.gupta@amd.com>
Subject: [RFC PATCH v2 1/6] Documentation: DT: Add entry for CDX controller
Date:   Wed, 17 Aug 2022 20:35:37 +0530
Message-ID: <20220817150542.483291-2-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220817150542.483291-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89a9516e-c658-4727-1804-08da8062002a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5069:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hAhCkTuD+aIThYlYC4WKeMdKxD5eH0rBlo4EaDRh4bFaiwgjXEtsI6xqzBA8?=
 =?us-ascii?Q?KcyoaZeD+UuSoMY/vLu622gFAImbAB8jaUvF4w0Ivqw4JMzy3/bKswYfJbyv?=
 =?us-ascii?Q?7cHdHujaxVlnHbesr18PVTRlVcrqEBKjeQ6Zt/owybNPXQc/oB/96ErH+m4M?=
 =?us-ascii?Q?kTpi621CDmRGVdoGZQCQLkQ5452PtOLth759n5l12c7qcV9RW+Wm+kMusZmp?=
 =?us-ascii?Q?7KMEEgE5eHiisRPEyOWpxFWd6f2+g0g6H5OTk1EcEQzcNpn/vRJgMNmMSKzR?=
 =?us-ascii?Q?PcF/4Iat4Ca9FNbOReZvTqMuzEePd3UFQUtc79+GpoovIjNpOtnREvlTq3If?=
 =?us-ascii?Q?PUoRJJMNC8zBZK9Jfj3UJK64+mL2sry5uFqTci8K9AB4vnKkYnf3Spe+0sAR?=
 =?us-ascii?Q?nK2VqIJL4QreNpGjDLzFxGkVyv6677lxW8GpHm/ZrqCXv4TBLu5CEt1J8ZBw?=
 =?us-ascii?Q?c59vHd3Dhi1lrMNgEz4URYrQgl8SVw+qrCaXHd131+dZMGvsVTEF1xlwzTCK?=
 =?us-ascii?Q?EzpyNnVT2ssYOetGj62SEsSbgjfknEVdU3MFAHvxNDQBEHCfeqNFrGZE2eLE?=
 =?us-ascii?Q?IezzeFzZ2wnLmtPIv+zde/pX9QfklbpYFQLKy3g4jEUPnfajksCIjqG+Mm1p?=
 =?us-ascii?Q?ZPbENffGj/r4V+67XFdXiBHKpWtj6QV7WL0vlS6lCcBu2k6FJm8+kxsQjNnr?=
 =?us-ascii?Q?TDNnyiJKrvrVNZ9PHPJYxvXGGC0RizLz3ailk8/rhqes8dxzQ3VMwAJNwKs/?=
 =?us-ascii?Q?LgSV3W84cWK4dxyfnqxQMsMRysv37ZQA52PejTJf1jMgPKnZJLvN0gEbRzZx?=
 =?us-ascii?Q?yMAcDXbRsFlovAVHVd8tDcXNm2Mf7jJPVqjgcerrBGjqXGnXVqKlkEs++km7?=
 =?us-ascii?Q?vGF/NjRALIa2V5GIV0GiAteMgbk2vFXV56Vy20j1KeOGJSJCLN2h2/jBOLNk?=
 =?us-ascii?Q?VwAgx46+yrNHOuRCUMF9Z8ExRElmnCB0chzMI5i68Pg=3D?=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(136003)(346002)(39860400002)(36840700001)(40470700004)(46966006)(26005)(41300700001)(478600001)(2616005)(1076003)(186003)(336012)(426003)(47076005)(2906002)(6666004)(82310400005)(966005)(5660300002)(8936002)(7416002)(356005)(83380400001)(86362001)(54906003)(316002)(81166007)(921005)(40460700003)(40480700001)(70586007)(70206006)(110136005)(4326008)(36756003)(8676002)(44832011)(82740400003)(36860700001)(36900700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:06:02.1755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a9516e-c658-4727-1804-08da8062002a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5069
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds a devicetree binding documentation for CDX
controller.

CDX bus controller dynamically detects CDX bus and the
devices on these bus using CDX firmware.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 .../devicetree/bindings/bus/xlnx,cdx.yaml     | 108 ++++++++++++++++++
 MAINTAINERS                                   |   6 +
 2 files changed, 114 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/bus/xlnx,cdx.yaml

diff --git a/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
new file mode 100644
index 000000000000..4247a1cff3c1
--- /dev/null
+++ b/Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
@@ -0,0 +1,108 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/misc/xlnx,cdx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Xilinx CDX bus controller
+
+description: |
+  CDX bus controller for Xilinx devices is implemented to
+  dynamically detect CDX bus and devices on these bus using the
+  firmware. The CDX bus manages multiple FPGA based hardware
+  devices, which can support network, crypto or any other specialized
+  type of device. These FPGA based devices can be added/modified
+  dynamically on run-time.
+
+  All devices on the CDX bus will have a unique streamid (for IOMMU)
+  and a unique device ID (for MSI) corresponding to a requestor ID
+  (one to one associated with the device). The streamid and deviceid
+  are used to configure SMMU and GIC-ITS respectively.
+
+  iommu-map property is used to define the set of stream ids
+  corresponding to each device and the associated IOMMU.
+
+  For generic IOMMU bindings, see:
+  Documentation/devicetree/bindings/iommu/iommu.txt.
+
+  For arm-smmu binding, see:
+  Documentation/devicetree/bindings/iommu/arm,smmu.yaml.
+
+  The MSI writes are accompanied by sideband data (Device ID).
+  The msi-map property is used to associate the devices with the
+  device ID as well as the associated ITS controller.
+
+  For generic MSI bindings, see:
+  Documentation/devicetree/bindings/interrupt-controller/msi.txt.
+
+  For GICv3 and GIC ITS bindings, see:
+  Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml.
+
+maintainers:
+  - Nipun Gupta <nipun.gupta@amd.com>
+  - Nikhil Agarwal <nikhil.agarwal@amd.com>
+
+properties:
+  compatible:
+    const: "xlnx,cdxbus-controller-1.0"
+
+  reg:
+    description: |
+      specifies the CDX firmware region shared memory accessible by the
+      ARM cores.
+
+  iommu-map:
+    description: |
+      Maps device Requestor ID to a stream ID and associated IOMMU. The
+      property is an arbitrary number of tuples of
+      (rid-base,iommu,streamid-base,length).
+
+      Any Requestor ID i in the interval [rid-base, rid-base + length) is
+      associated with the listed IOMMU, with the iommu-specifier
+      (i - streamid-base + streamid-base).
+
+  msi-map:
+    description:
+      Maps an Requestor ID to a GIC ITS and associated msi-specifier
+      data (device ID). The property is an arbitrary number of tuples of
+      (rid-base,gic-its,deviceid-base,length).
+
+      Any Requestor ID in the interval [rid-base, rid-base + length) is
+      associated with the listed GIC ITS, with the msi-specifier
+      (i - rid-base + deviceid-base).
+
+required:
+  - compatible
+  - reg
+  - iommu-map
+  - msi-map
+
+additionalProperties: false
+
+examples:
+  - |
+    smmu@ec000000 {
+        compatible = "arm,smmu-v3";
+        #iommu-cells = <1>;
+        ...
+    };
+
+    gic@e2000000 {
+        compatible = "arm,gic-v3";
+        interrupt-controller;
+        ...
+        its: gic-its@e2040000 {
+            compatible = "arm,gic-v3-its";
+            msi-controller;
+            ...
+        }
+    };
+
+    cdxbus: cdxbus@@4000000 {
+        compatible = "xlnx,cdxbus-controller-1.0";
+        reg = <0x00000000 0x04000000 0 0x1000>;
+        /* define map for RIDs 250-259 */
+        iommu-map = <250 &smmu 250 10>;
+        /* define msi map for RIDs 250-259 */
+        msi-map = <250 &its 250 10>;
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 8a5012ba6ff9..32c5be3d6a53 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22296,6 +22296,12 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/can/xilinx,can.yaml
 F:	drivers/net/can/xilinx_can.c
 
+XILINX CDX BUS DRIVER
+M:	Nipun Gupta <nipun.gupta@amd.com>
+M:	Nikhil Agarwal <nikhil.agarwal@amd.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
+
 XILINX GPIO DRIVER
 M:	Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
 R:	Srinivas Neeli <srinivas.neeli@xilinx.com>
-- 
2.25.1


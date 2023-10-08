Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717067BCEF4
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 16:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344888AbjJHOtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 10:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjJHOtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 10:49:46 -0400
Received: from AUS01-ME3-obe.outbound.protection.outlook.com (mail-me3aus01olkn2165.outbound.protection.outlook.com [40.92.63.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7072AA4;
        Sun,  8 Oct 2023 07:49:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ah6dIJayu7G+cqPEtM8vTDsSlS+IT99Vt29XUuTN7DTHpRDjQ8JP//LMKKoyh3sLbK4aHoBP6zArSacWZADzawTZNKWZ0tkkeyunacKWQIW4SpIE3qfIkbB4KyVudiahsaJgFDq1x/hXzHpRgrFUp/h99tQARHrcDymp8yzLbXrcU/AQcC+6F5+1XQNS9REDRwDPlQUaKwGfztd3bW9ByYges5aEINqFKtKzF2k6TObHx/msU0tm6pbnhVcOW+VYZB4R2iwtk1f6Yq34N6ai73GjXHj3P9V87Iu2I+NUOLPAbSX44WopYNSCH75ODmZsfAC1rYt/ZurZdb+H04a/RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ht2wYdZ+MhkcLxpd75wL9X5gxMweEyNJjLXGbG5Oddo=;
 b=dHpksDRzXpXUkIyAYmQfSKuECCImC3ZWFAeqWSZrjKN1nP84tP6bqaEFu7lTxrz6Z2xQBfIgH0Q0Ab7RX2EWjX2O9RkAPIvXVF6h4aC9VhtUSDAnvxP1EwBYtw3imSo6zudZrb5yNGo7sx7+3pFl4wz7tIEKtAYj4FAmgdWmPoIG+P/LEbRCfQLJ/gRw8g5C8TV0rkWYWjPYQ7PVtlaJsIbcxJb96aM1ocWt4nuA/AEzKDpPl3rgr3q7eEpuwY0LVuvxMWFLSXEFsI5oGcCorN48p9oXnKzAv1Y4kZKWM83ySoYUqluXkQHj1xx2im5MdYPMymua75wzXy4ZItE5LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ht2wYdZ+MhkcLxpd75wL9X5gxMweEyNJjLXGbG5Oddo=;
 b=gQFgU6IMcgwzguyb66kEMd5tkkkFl7m+XqbMHJe/TdP7VRCw0CFO1qDgrMgRxdvTLb7R5PPvqG5O1BnQ5UmDMWILC1h2RHTAtGbp/RFStEf2/C5aOCAv92K3E1IzFsjfp/RSpqD+U9KVTlkKufDLeQ7pIUcAEYfnClihXy3zFBBapRcN9wqAWBMEONOkNLwYFBILdAKoJd79Nxoa543h5X7zFrn5gmFK0xaeoQbqEKlCr3Jm6vN+CJa1lvlETN5lNs24vgoql0KS4AqTxmvD6rukMvo2IptUjuJvRN8L5r1q3Afm5KGz25oaJoDRB/19AzgWoZgClb/vL4JHCIcIIQ==
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13) by
 SY4P282MB1371.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:a2::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.21; Sun, 8 Oct 2023 14:49:37 +0000
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8]) by SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8%3]) with mapi id 15.20.6838.040; Sun, 8 Oct 2023
 14:49:37 +0000
From:   Tianyi Liu <i.pear@outlook.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH v2 0/5] perf: KVM: Enable callchains for guests
Date:   Sun,  8 Oct 2023 22:48:17 +0800
Message-ID: <SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.42.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [07HOgdeVMNn7ajOb8/L2gSiI1xnCCGuRYq0r0qQ99D5Y7Zzx0xt8Mw==]
X-ClientProxiedBy: SG2PR01CA0109.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::13) To SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:ac::13)
X-Microsoft-Original-Message-ID: <20231008144817.7042-1-i.pear@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY4P282MB1084:EE_|SY4P282MB1371:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a587e4b-4e65-4d4a-189e-08dbc80dcad0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZHh83UVI/yxlsPlwmySXDDOzZAzGaETuOnFtVezajClyzzr4f0XOsrZZE06MlRB0hhsBTxtosYMJbqkTV2Ki/bODF/kjMsOYxTcAFhoHDwE4sNpGFq7qq6VhTFOOE90jA2BDLmIiWNkOmRGY/0SKN592GqyYK3hxJKprYRbhRDUguvxZB9gQAmyyKaJYj0zEeDbRnWgQ1P3mCqb8actAaHpxGlK45nzSes2VQhLqRpAeFCD/7qMAELn/Az3CEDQEuvAm6RkwlMbS5fedUhZX0nNYknvbiLX3no9wA3VzjGmTXP1nEiitFccupn9ezcLZhkzfGgV1CR1qViOpWBg2SJUd6khd0hh+Naqz+OFalvvrfxNK9r3Op15/ZGFZFv3cEkjc9bZrya9yBTSpnzluhjGdYA4pYZJDyTssYbAHG1XeyJrpW7R0hMbF3Amrgvwc29qxuB69E1T5nH4mCVFHGADQQIOwRBkPFPh1L0HjYhPL3vzNPOQXT3HzvZIgFiYbur8G5DJK+0Q3HhPaRJV1XfA3+1jZlwV3Z5iWxyE8N2Vs8fiNoXRQx0+uIjAGgNlnujTYP/2YXqruE69h0D7rg1CafHSTBm2IrWRnYMs7sRM67eEXzzn9GzjSAmnJO4YU
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vU+ISLE3up5hGZqv/I69OQpzj7YLftnkp96oOqm36NAReEW1LYffL/uXMOEL?=
 =?us-ascii?Q?htoWP0Z3sGRfFD6KIL+Ra7L7BfrxK9qSdC4XvUNLYoJnNbkHUyUulUSkoO/Y?=
 =?us-ascii?Q?hZX96/5cFWU56uIuTW4XGKu6XZgzjEZbd/A+qUZAaJX8ZR8HLlidJmWhv6mX?=
 =?us-ascii?Q?hjN37B0EgEgdWte64got6uwcl/a39Lk6QMY1I9ek7AxhBSJmdS0+mGszSp3m?=
 =?us-ascii?Q?AtHGBHIpIZr8z2HmajMQ8qgUCO+qrUC7VvdBabDAkkaq7M8fru7Au7veq51Q?=
 =?us-ascii?Q?puPmGO7WWV1YNOJM7aAgmtDEgsyPa+JYSURvhZc8cNi0QiCtqgCzVkuR5rvI?=
 =?us-ascii?Q?9SBT++otI1eP06K1vTNv+/XtD0vQLv29FaHNcHWmekOGFkDQYy35rQEkvxZN?=
 =?us-ascii?Q?hnPWApZLofp6QniwxHbc9R1Em2zUpNrpm60yolZjtf74wokpKiOUMHURAQEg?=
 =?us-ascii?Q?r27k5JIVs0vwpFLm+gj7fTWSR6CGrA1TeKAvJPlBic64SKZ/n1iEiAAcQyT+?=
 =?us-ascii?Q?JqshdZmtkRM+Z+2G6f81UbhCBzEUm5ELn9pZbBK39U+tg8Hv3Oioc+I3s1kI?=
 =?us-ascii?Q?/HiqH/cb2sSRxf/BHEm4dKVJ/kkK9QkhHPiYnkD6Eb2HtQdxaDWNi5V9nFTT?=
 =?us-ascii?Q?4y0YGe43jXnuvdE3hQLdu4ryD0OHbDZ47WQpn6aBVwWB9YYJinTkNgT9Y8qT?=
 =?us-ascii?Q?SdIqOQSoEbZY/ZsgSzOjvEeZTzK14nOYGfJWnQloIazpMXUKUUoea9HNnBFJ?=
 =?us-ascii?Q?xCgCYZ6S0sWEsVGLDDvErJxre9l9/5BldK65JyD0aQ65QoR1Fr5Pjvnx6Em6?=
 =?us-ascii?Q?Pt3c6R5TZvP9UPOX8ZyDzkJ+a6D8093P+zvJUudzjrZczawVzzQhB19MEVMK?=
 =?us-ascii?Q?6W/ZFBcQofbA2VDkQHLifTrvgdqLpLgHxytz1PCvThFGD2NZR2qNa2MSs0RW?=
 =?us-ascii?Q?zVQi1sizwCMWoO1/+OALj1eolUWyrSq7M12KtSG9mAJa2K0usKcEBEcxkMz8?=
 =?us-ascii?Q?HjmpCR0UEbkAZ34Hnh7Ei7eyEp6mDnq5e9r6i2fnjfEOU/OhOtQ48eqmwXmr?=
 =?us-ascii?Q?PDYcuL/R07Y7KUJtnl5qxeAcMo8zLDrNc0KpWz+t9KCPXciNDrBXd6T2vUdx?=
 =?us-ascii?Q?M3EEq3XEYOjfRrEygpCuNb6hJd0/ugD3krCHC4jyvsV6g/kTHIx+6EXSHv/Y?=
 =?us-ascii?Q?yR2a0XBkQqROpu4EQx+YsyyoDc8pwCMMR5pXsVDDnvavrLPsALREBqfzF1Ux?=
 =?us-ascii?Q?ZF0/KnCoKnfoqFZDioix?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a587e4b-4e65-4d4a-189e-08dbc80dcad0
X-MS-Exchange-CrossTenant-AuthSource: SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2023 14:49:37.7868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY4P282MB1371
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi there,

This series of patches enables callchains for guests (used by perf kvm),
which holds the top spot on the perf wiki TODO list [1]. This allows users
to perform guest OS callchain or performance analysis from external
using PMU events.

The event processing flow is as follows (shown as backtrace):
  #0 kvm_arch_vcpu_get_frame_pointer / kvm_arch_vcpu_read_virt (per arch)
  #1 kvm_guest_get_frame_pointer / kvm_guest_read_virt
     <callback function pointers in `struct perf_guest_info_callbacks`>
  #2 perf_guest_get_frame_pointer / perf_guest_read_virt
  #3 perf_callchain_guest
  #4 get_perf_callchain
  #5 perf_callchain

Between #0 and #1 is the interface between KVM and the arch-specific
impl, while between #1 and #2 is the interface between Perf and KVM.
The 1st patch implements #0. The 2nd patch extends interfaces between #1
and #2, while the 3rd patch implements #1. The 4th patch implements #3
and modifies #4 #5. The last patch is for userspace utils.

Since arm64 hasn't provided some foundational infrastructure (interface
for reading from a virtual address of guest), the arm64 implementation
is stubbed for now because it's a bit complex, and will be implemented
later.

Tested with both 32-bit and 64-bit guest operating systems / unikernels,
that `perf script` could correctly show the certain callchains.
FlameGraphs can also be generated with this series of patches and [2].

Any feedback will be greatly appreciated.

[1] https://perf.wiki.kernel.org/index.php/Todo
[2] https://github.com/brendangregg/FlameGraph

v1:
https://lore.kernel.org/kvm/SYYP282MB108686A73C0F896D90D246569DE5A@SYYP282MB1086.AUSP282.PROD.OUTLOOK.COM/

Changes since v1:
- v1 only includes partial KVM modifications, while v2 is a complete
implementation. Also updated based on Sean's feedback.

Tianyi Liu (5):
  KVM: Add arch specific interfaces for sampling guest callchains
  perf kvm: Introduce guest interfaces for sampling callchains
  KVM: implement new perf interfaces
  perf kvm: Support sampling guest callchains
  perf tools: Support PERF_CONTEXT_GUEST_* flags

 arch/arm64/kvm/arm.c                | 17 +++++++++
 arch/x86/events/core.c              | 56 +++++++++++++++++++++++------
 arch/x86/kvm/x86.c                  | 18 ++++++++++
 include/linux/kvm_host.h            |  4 +++
 include/linux/perf_event.h          | 18 +++++++++-
 kernel/bpf/stackmap.c               |  8 ++---
 kernel/events/callchain.c           | 27 +++++++++++++-
 kernel/events/core.c                | 17 ++++++++-
 tools/perf/builtin-timechart.c      |  6 ++++
 tools/perf/util/data-convert-json.c |  6 ++++
 tools/perf/util/machine.c           |  6 ++++
 virt/kvm/kvm_main.c                 | 25 +++++++++++++
 12 files changed, 191 insertions(+), 17 deletions(-)


base-commit: 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
-- 
2.42.0


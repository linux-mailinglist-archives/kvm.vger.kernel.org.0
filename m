Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B71A78032C
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 03:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356957AbjHRBYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 21:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356993AbjHRBYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 21:24:10 -0400
X-Greylist: delayed 624 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Aug 2023 18:23:39 PDT
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0283A9F
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 18:23:39 -0700 (PDT)
Received: from 104.47.7.172_.trendmicro.com (unknown [172.21.10.52])
        by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id B5D5110907317
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 01:13:15 +0000 (UTC)
Received: from 104.47.7.172_.trendmicro.com (unknown [172.21.201.37])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id EAE6C10000464;
        Fri, 18 Aug 2023 01:13:12 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1692321191.878000
X-TM-MAIL-UUID: 1f8497fc-3c8f-43ea-a32b-75fd8a21c102
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.172])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id D673F10002862;
        Fri, 18 Aug 2023 01:13:11 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N78AUlGJDlS/N714InaN/AP569dBZYREazP3+Ao8JucDXt0gz+MDgnXV4E4SmoI1Qf3EX7rvthMGsOpEOYp4RiWof3ydtxacBrADRZQzEdiwEWO/qJTGuim3t7dSqhA09OobGPnGLUrZhERQ9u7eXeu8uXhx8VMT6UrOHPOp/Bxv2KLCWaYDnFcVeMXbK3xXr041OwvS9e1OpgbG1FcAof/pTzwPNSPlJZQY3OcTF14yrKz9aQgu6DjcsoFZXwajFdnCYZpj+XhmlC/1IUzNKUnn+xHNB/c0U6+Y+F7xtIhVY/voxfRU1CZ9aZpnCN8IJeBghz/8aomzcB+8zsWKQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5VpDk08Wu9KG93J0eX+u5xI82UsPR4UBeDBIUDAMX4=;
 b=Ub0JK0LFyTB3FlOFaxz4wGLhKl7DHCQ22QfatvbM2hQTXB6ArvfCzHU7//FmVJFVO+SK1aVtauBxmhVS6Mhx1LBdGZm3kREi69+8/MvlLX43QrQ+savwLo340rphMMDevuMUIZoWUzeAO0xyX9wOQDq0Hu4z1jXrDiIleoxvKGBfGJec60s42R6uwxL1AmwerHGgrWRS2M5QTDSLkO4mjl0iN7XfFHja6V6n5fFYLTw+JKRCRb6e8ln45cqzd/Y81UBUdxdASFYCPmz7ATuxzqsakEt7j2gS8q0G4qK8PGalnAvWPlR6K1mgZzSWQRsy/N9Hhe8mOrUQwf1HPDt2Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.66.60.4) smtp.rcpttodomain=alien8.de smtp.mailfrom=opensynergy.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=opensynergy.com; dkim=none (message not signed); arc=none
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.66.60.4)
 smtp.mailfrom=opensynergy.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=opensynergy.com;
Received-SPF: Pass (protection.outlook.com: domain of opensynergy.com
 designates 217.66.60.4 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.66.60.4; helo=SR-MAIL-03.open-synergy.com; pr=C
From:   Peter Hilber <peter.hilber@opensynergy.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     Peter Hilber <peter.hilber@opensynergy.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <jstultz@google.com>, netdev@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, x86@kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH 0/4] treewide: Use clocksource id for get_device_system_crosststamp()
Date:   Fri, 18 Aug 2023 03:12:51 +0200
Message-Id: <20230818011256.211078-1-peter.hilber@opensynergy.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR05FT036:EE_|BE1P281MB1715:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 27236255-086b-4a96-79f6-08db9f88497e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /0rAwJZy4N+82irST4+FCTKsfGSw0M8OTlnS3LQ4F/hqvenvlhM8bIut2GJIqHAM0/BRAfjDtR6Muv2iMl92RznNJxZAwTlDMqwtnqB34kZtAW4lGEs/9F6iHdIq5c+Gco4p0UAPo1MNQD7dO8kcWnpO+mAVMlb8LHIR6gzUDzbx9DO7T7qUi9kTonz091A7aV24/2ygZ/5iVE2hv1BtX15kxwZZYpYTgtV5h3viWekH+leV/QF5x8sSn3Pesx9dtTgumXxEtg17wLo/ADioGsUT3Zv2UrjGXB0AOnggzi71J54tvu6oR8vyRiT15XE4Jb6lVEfc8tX7ZBcC63+Bgb5+wDflPkIv+PaRtYM03+EahjX/RqoY9+z+61yIlD9MOBf7wcSxrvtPs/DmsX4MgiGzhtoNDqx9cCQrJRoVxngWazedSFI1IWFHJvZfcIJstkeYqGcdQ+zgsIq0NA4Yuuk52XnOT2rEyRMJwrorgXxNO0oHYCIXVsmpcJEnGUvVh6YLEB1plPm3rhCoOQxtyMY76HLtqQoWY8VPcU4z/qSmV++JPvs15CUNkZf5+FmfQqdSseGgLuAQLfQdlzDKzdzuggHGEV8K9HPPM71WbkvqFQ4PQ4KnKfwRGwcro8ttoKUniKgqdhzDsOsJbU+i9LAU1CyLFhCo+Vl5ZxsrrEhd+5l6O09FVd2dEzSzurRxPoNeOPhwat/a6JOuG+nXvYYXofcpiaItmrdFGcfDByTPPjQxj7VC5wxxc5jzfpiA6SNBK4Bk0bz0O+s3WtarluwX1MQ0+k2ykbywVlGpp5vUQ5KTuQTiIAfsF0tScSB3
X-Forefront-Antispam-Report: CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(39840400004)(346002)(376002)(396003)(136003)(451199024)(1800799009)(186009)(82310400011)(46966006)(36840700001)(2616005)(1076003)(336012)(26005)(47076005)(36860700001)(44832011)(83380400001)(5660300002)(4326008)(8936002)(8676002)(2906002)(7416002)(478600001)(41300700001)(70586007)(42186006)(54906003)(316002)(70206006)(81166007)(86362001)(40480700001)(36756003)(12101799020)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2023 01:13:09.9513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27236255-086b-4a96-79f6-08db9f88497e
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR05FT036.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BE1P281MB1715
X-TM-AS-ERS: 104.47.7.172-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1011-27820.003
X-TMASE-Result: 10--4.768100-4.000000
X-TMASE-MatchedRID: ojZhuzNjofOUP+0hdpOx0lmcWIT2GKzJi9V1e7G8XUi3UJJ8+n/4RUA5
        xmkHg/1rT0Y22tvHDFRikRK8IviK3Vju3159ygOAFj4qQx5AVr5SM6qNRfMkElF43i7rWWHIeju
        HJaGIj3+jeOIuPuWDKFojBB4KrwwqLmEURQFcowaxkiMlzRAr9nJ8bM38R9gpJsfJJdVp3fqvng
        kjHjojpH2fbnp7T2HmiXG+DOC9634tUBe4IrvOVzsAVzN+Ov/s56hCrXvA5m0wlRuPCzsUn97rl
        m2FvqSBrCvAq6HXM0PG1fZbjkzlog==
X-TMASE-XGENCLOUD: 0fff1c64-aeb8-412b-8e37-fff3596797ca-0-0-200-0
X-TM-Deliver-Signature: 59401B0EC8BB0BFE31D4BE574A61EA03
X-TM-Addin-Auth: FADmhsUYdP9JrhkVs5VToUTtbM9K81Ai4NuwGZ5Ggt0YCtf0DeqaCFN7+1b
        2sZkIrUK61tOgBElidGrgtGYxFMU143iw74yCZ2Lq3xFo6yCPNKKPaeNPwgVxr9sFiXvhL3NL3I
        uvaLbDCJathp12TM9L5BA6rVPlMJtog9R9mV30Sb2kok5OJq5ioiLNFAylfAiC0/jG4uuqeELuC
        DTHEEG/C+wpc0mtXvsxzpQYecq5G2wrDPoTu2Y7we7SUx7M2+MXJkaze2LWIdArWN06yFkKpF++
        v5ZH1Bf6RdqxXiQ=.dKuC1kUiBNn4r5uKWzvpvm4eKnqmdXjIIZ9wkQmLIGs+FYy7xabCJSrsa7
        FMiAGoVAsXyNS8+UGMl5J2FoCx34LEHHIZYkwCbzg/BLPYO6Cssk/cEjTSrSLdGgxFRS03j35HM
        umo3niLB0eYPIyUZ44vXGzocz04bKrPpMGD16wbcsEXCmIO9vwbnBn80qnrgVmw7W+jXIAgMTZq
        WVg96s01DiKlwCNxs8O4RL2k5a2c+khbRW57F6vxoGFHXQBKfq8FzOQBRTjAEANZhEMu0lv4E+T
        CYCqZ8AMQA7MPZzN8m1FDam+650KyCsx+gZiJo3pC7umG9BYWT0mYjbQI6g==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1692321192;
        bh=Lh7sLmR8+951ZkPlTP5cpggi4UFK/P38I90/uANI3wM=; l=1696;
        h=From:To:Date;
        b=HP2hNrm7KO1TEh6Xlh0zcj1IEAdyaNR9jTQXsVs9R1Mqi4Ns79+J0g7+xSWeGPikr
         6g9WGwnP71XVV+YgSuJ9jWXG2lG57pdVCmSAV7SClgQiSmhNCC0geMbORiKM6Y3daf
         BTn9LI8riGNNvLk7Yi3zkDnmfsJnFWLIglISX0UsVLi1W6/5tYcKHO7P1t6BYtGAi7
         YWQtJw4Qs7saAetBSfgwuSDYBltRd76cjtTi5FU/ARjVXIDVBj8E5dpStypHcTddFm
         4OvFtf6+vOa6/n7KPvga4KvMkoxC/mSFL9CVGhGnWYhgcD04d9gj6IlYo2w0fM0A1m
         MAcGQToSenidg==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series changes struct system_counterval_t to identify the
clocksource through enum clocksource_ids, rather than through struct
clocksource *. The net effect of the patch series is that
get_device_system_crosststamp() callers can supply clocksource ids instead
of clocksource pointers, which can be problematic to get hold of.

For this, modify some code which is relevant to
get_device_system_crosststamp(), in timekeeping, ptp/kvm, x86/kvm, and
x86/tsc.

The series does the following: First, introduce clocksource ids for x86 TSC
and kvm-clock. Then, refactor the x86 TSC a tiny bit to keep changes in the
last, "treewide" patch to a minimum. In the treewide patch, replace
system_counterval_t.cs by .cs_id.

This series should not alter any behavior. Out of the existing
get_device_system_crosststamp() users, only ptp_kvm has been tested (on
x86-64 and arm64). This series is a prerequisite for the virtio_rtc driver
(RFC v2 to be posted). Through this series, virtio_rtc can work without
modifying arm_arch_timer.


Peter Hilber (4):
  x86/tsc: Add clocksource ids for TSC and early TSC
  x86/kvm: Add clocksource id for kvm-clock
  x86/tsc: Use bool, not pointer, for ART availability
  treewide: Use clocksource id for struct system_counterval_t

 arch/x86/kernel/kvmclock.c      |  2 ++
 arch/x86/kernel/tsc.c           | 23 +++++++++++++++--------
 drivers/ptp/ptp_kvm_common.c    |  3 ++-
 include/linux/clocksource_ids.h |  3 +++
 include/linux/timekeeping.h     |  4 ++--
 kernel/time/timekeeping.c       |  3 ++-
 6 files changed, 26 insertions(+), 12 deletions(-)


base-commit: 47762f08697484cf0c2f2904b8c52375ed26c8cb
-- 
2.39.2


Return-Path: <kvm+bounces-4601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39BA2815350
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 23:12:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E1D41C23C34
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 22:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7C25F85C;
	Fri, 15 Dec 2023 22:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="O1XlcfNm"
X-Original-To: kvm@vger.kernel.org
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A774B13F
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 22:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.7.168_.trendmicro.com (unknown [172.21.9.37])
	by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id 69A67101710A4;
	Fri, 15 Dec 2023 22:06:44 +0000 (UTC)
Received: from 104.47.7.168_.trendmicro.com (unknown [172.21.176.220])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id CC429100004D2;
	Fri, 15 Dec 2023 22:06:36 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1702677993.517000
X-TM-MAIL-UUID: 367ca54b-cdc1-4232-9999-2a57a5731058
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.168])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 7E5C5100012AD;
	Fri, 15 Dec 2023 22:06:33 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRQf47ztRRH7bje29hwxD5hYehQW4RJuVGUTFDFZuClpXDfTzK7kyltyRkipDmggeaJQ1c690wyn3dEazHd6I5+SJTT1QUVHsd/cQ4ylkVl2L3IwhdHeF3FQ6byTaU4VJhqxBxaagLbsLxgFr2rQlifcsgW+WJNVig4/Wg/2biB1hsL63SRdXVydXL6o+8r8ttEuhUtdyQnAB+ILt/vDv5NL+HhbW+VN78tHOgevDXHf9vGIigEu//caRInWNjrBeMrIjhDhZ0kJNJmufWi1ewA3dLehoT0uwQMeQt6dcyoBenm2Hl0RM9hi7BIrSAkpB7BT601ZhYxZ/1LxjWffvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=agaYS78USFhMiVlynj7joi46UTiD55ToIWNdi5KYJfo=;
 b=FeckqSr2/oW9kkXAFTewdcZP5Obl6XYA5N5zFMoYnOonRrRxmCs6OKi9LBVB6OfUNjzLAr8B2z4O6PHkRICgP9SG1uOx0MCqr8gxVaX295Mrtx0I1qps28O6t+2ELl/WoLgYyLdpGnXdlMO1RS11E8EM5YoJqti10zIkVgcTbqaTVuO3KIvYaFxvXAQkvgTaZkg3h/ZqJuj7ET4hHBMkVzVwuIUFoAZ+ue1MFvpDxAugPYt87h2vWhrGhb7OAnj/1Bm9i7hARkv8mxr8MgNII2qtUcdPPcuhersnEYRZgSX7wGF1QZt3QEVg/Xuax3MuZP61fYqh8ca0g9azmAUDGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.66.60.4) smtp.rcpttodomain=alien8.de smtp.mailfrom=opensynergy.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=opensynergy.com; dkim=none (message not signed); arc=none (0)
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.66.60.4)
 smtp.mailfrom=opensynergy.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=opensynergy.com;
Received-SPF: Pass (protection.outlook.com: domain of opensynergy.com
 designates 217.66.60.4 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.66.60.4; helo=SR-MAIL-03.open-synergy.com; pr=C
From: Peter Hilber <peter.hilber@opensynergy.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Hilber <peter.hilber@opensynergy.com>,
	"D, Lakshmi Sowjanya" <lakshmi.sowjanya.d@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	jstultz@google.com,
	giometti@enneenne.com,
	corbet@lwn.net,
	andriy.shevchenko@linux.intel.com,
	"Dong, Eddie" <eddie.dong@intel.com>,
	"Hall, Christopher S" <christopher.s.hall@intel.com>,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Richard Cochran <richardcochran@gmail.com>,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	Stephen Boyd <sboyd@kernel.org>
Subject: [RFC PATCH v2 0/7] treewide: Use clocksource id for get_device_system_crosststamp()
Date: Fri, 15 Dec 2023 23:06:05 +0100
Message-Id: <20231215220612.173603-1-peter.hilber@opensynergy.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8EUR05FT046:EE_|FR3P281MB1614:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: c9f8e431-5ab2-4816-d457-08dbfdba1867
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GsGzY8hHLfQ0L4AGGguGVhyW8K9dXjlknys+dK697SEQdPAZhJRMjmdb9BKay3fn+ohKe3erddZx/1xp+z+pt3fqjw7x3iZWZF/kAvSM2YUN7hmTIZRVAi8w3qr1FYTwQRWgJoZOZ15mbkJzqyxaYjPuZ6f2AL3JR0K+fGiIamA4Lt+FSMft3Mbvsk4LRuxPr04mzBHqE2a+JPjWNzJ0QyaFedErrBS/P3SB+ALldNVWj7pq9OpLhgwkC7yp+PtuIDWrCRFlvbNO6pdDK5rjVqM+Af5pAz48Ue02L/pm4bwip+E8tuibkvSp66VoJrrcXfyIPpKVdKORoLYRyIFdpVN3Or/4y7kP9qkwqS7k0tGnk/5y7YOOgCHUfLM8tcKkqFGOhMx5vEOcpHCzcrhrvYv7XXV1JTM1QmV5jPdTJQjTCMI8zvZ0862bcDtKBdCD4ZxYPfgj4Ia+TRgKh+wSjY3Ao5KJqcUXJHKqPGTTs9VAOkYOViolj2/nSUrEvl4SdwxlCbvE2RHNlcsFUulgJ1PF/L2he68HctZzzFhwTGO8GSNKHBRAbpitP89SYK+y02Pzghk3CB2SzodDnF4+mzp/8Z9ZDhKnmzpM9UBzV4/ja/LhSxhxXWdMl+hXMTpQAJe0LyrEXDmUMDoTi1+oxszhoqXbnZRoy/wqq1w04Z+ofAhtU8xGbMoPPMWcaF2sK9u50Yr2fNQsUTYLZzGv/u56fTbmN/QsGGNWNJqmc2NdpOUZ1huPD4K/S41IxyGj1WOrlO1bkKCsb8eE+i+8Pw==
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(376002)(39840400004)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(82310400011)(46966006)(36840700001)(40480700001)(1076003)(336012)(26005)(2616005)(81166007)(36756003)(86362001)(83380400001)(44832011)(5660300002)(36860700001)(47076005)(8936002)(8676002)(4326008)(70586007)(70206006)(316002)(6916009)(42186006)(54906003)(41300700001)(2906002)(7416002)(966005)(478600001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 22:06:31.7321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f8e431-5ab2-4816-d457-08dbfdba1867
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR05FT046.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR3P281MB1614
X-TM-AS-ERS: 104.47.7.168-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28060.002
X-TMASE-Result: 10--7.044400-4.000000
X-TMASE-MatchedRID: KBpjYDzav4OUP+0hdpOx0lmcWIT2GKzJi9V1e7G8XUijN1SoAtAGxtsH
	8mvO8CBHCRqqhJm8rIn5mjPOVI6+s/oKZK4fc4pdc6MQph12+/qgn19QHAlOzICpIfHsTRJvaQX
	O0KwCdXrdTrmsiWLAxD3Dhol2PU5Lmbpduk4zUf/BcAkkfZSxiKJDaGSlxWd0nFPS5wCjpHZ01t
	kgbj61ndpXJMrozGW3YpESvCL4it1Y7t9efcoDgBY+KkMeQFa+ifMOGvxuFI/ksZ3zvFw4d9MBf
	XdbvQpitKCRYZK7Rz5nTzlpJasG9DWKJWzdd27zFNCHhVgQN+RF82F/3Qm0nzB4jJltGVDbLN5w
	GPX3TPXYeXOEzfM22ez1ZBVjJwp/DeUZOJCXHMgMHb/7t/XFB6JYuGaIjh0/IOKWWMbJYW1HjTo
	zLyxgvg4Fzev3p4hIwM0DNfudA4D90bqmL8lIO3PngqD95asR
X-TMASE-XGENCLOUD: c8459977-1676-496e-a985-fa28a5a45d09-0-0-200-0
X-TM-Deliver-Signature: E7EE09502309D7E1DDBA639E64FB9010
X-TM-Addin-Auth: NGr+b3azPpS3/Zeb0aqcby3cr4qWfbpHOOylJ0ffizsQXN2xoOM9FP24F//
	S2Y8DSUO8qDV7rA1UMox0zrZRtF6huNVVfoCBEMI7DOskjye8jV5DJMgYVqfVvhtIO4OZRC5fF8
	5+OmvRIHtOK3oPdmWywNr3F5721WrL/l7pSRRTw/x+Iw+n5fVmwoLBj8ttKjtUmKKduV2/o9IBJ
	A9+8rag0Eff/Ga2QeVdwepXq9mFfyDrpYaILbyDBppknlo5VFJQQNqksJaF8So61dirRg6hQ7OR
	R1rIS1AnzTFeS2E=.mcgyROZTglXZnihSqlUEHXD5imG+ruOwFkZiSILJsbXSPt1P9GoG+yw3Hm
	8Cu8tJZHwveLF5k7AMMS7XUKpEeWU7kc7odnJkmk6FM/AXKChuBsmYK8Yw3NScxtoR1c8nJBw9b
	/d2WwHkv8bawcpqT7LjDV43vU2WpONUGuD8vO0eejHCNidVvZ4S628BrEcqPYC0h8ZGnZ9p94Vl
	bxdAMBw1mi4RdNZjki4J3w8EDSFURZtfcYv2BD3JQqGhLt1pZxEf+xLByXSZ3yeHzjz/tnRfp1A
	aLzSiE/RX5w01/ercq777t3rsSDehzZzkEB99/1OICTpBIg/zCcdS2O24bg==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1702677996;
	bh=fNjbMei4ZWHGq/zEoYBHmdHxSKAaRDbd9h90JPhEwTU=; l=4561;
	h=From:To:Date;
	b=O1XlcfNmz/P0Wr/aCaggb/jVdmLZM5OVq4WpvJV8Kv1KQiZidHvBhlFuc+vMc5kEZ
	 IA9elnN5Wc4B54JlEE2jJ2pDx5p2n2uOQOPw40stPwUZfYg98gPxNd5xmYNp558cr+
	 EVlZnUw6LDI5xxEjgoSRMy6UGDUdUTDFh/crgFO5weKzZa4s3bBRwjjTqkWKFDLxQc
	 ZX+tuSi80hCxdbQLXlcJZWyKLLjXpS3yig8zd18qLlZXV0FRClFvebquQMe1cyg2VT
	 iVRSJ5prPvxf0JisQrHq9wfwUhSAGx0dTRJZ8qjWXUBM26lmIbGa3fnz/TN0A5YGQN
	 uhllv7Edf8XLA==

Overview
--------

This patch series changes struct system_counterval_t to identify the
clocksource through enum clocksource_ids, rather than through struct
clocksource *. The net effect of the patch series is that
get_device_system_crosststamp() callers can supply clocksource ids instead
of clocksource pointers. The pointers can be problematic to get hold of.

The series is also available at

	https://github.com/OpenSynergy/linux clocksource-id-for-xtstamp-v2

Motivation
----------

The immediate motivation for this patch series is to enable the virtio_rtc
RFC driver (v2 cf. [1], v3 to be published after this series) to refer to
the Arm Generic Timer clocksource without requiring new helper functions in
the arm_arch_timer driver. Other future get_device_system_crosststamp()
users may profit from this change as well.

Clocksource structs are normally private to clocksource drivers. Therefore,
get_device_system_crosststamp() callers require that clocksource drivers
expose the clocksource of interest in some way.

Drivers such as virtio_rtc could obtain all information for calling
get_device_system_crosststamp() from their bound device, except for
clocksource identification. Often, such drivers' only direct relation with
the clocksource driver is clocksource identification. So using the
clocksource enum, rather than obtaining pointers in a clocksource driver
specific way, would reduce the coupling between the
get_device_system_crosststamp() callers and clocksource drivers.

Affected Code
-------------

This series modifies code which is relevant to
get_device_system_crosststamp(), in timekeeping, ptp/kvm, x86/kvm, and
x86/tsc.

There are two sorts of get_device_system_crosststamp() callers in the
current kernel:

1) On Intel platforms, some PTP hardware clocks, and the HDA controller,
obtain the clocksource pointer for get_device_system_crosststamp() using
convert_art_to_tsc() or convert_art_ns_to_tsc() from arch/x86.

2) The ptp_kvm driver uses kvm_arch_ptp_get_crosststamp(), which is
implemented for platforms with kvm_clock (x86) or arm_arch_timer.
Amongst other things, kvm_arch_ptp_get_crosststamp() returns a clocksource
pointer. The Arm implementation is in the arm_arch_timer driver.

Changes
-------

The series does the following:

- add clocksource id to the get_device_system_crosststamp() param type

- add required clocksource ids and set them in
  get_device_system_crosststamp() users

- evaluate clocksource id in get_device_system_crosststamp(), rather than
  clocksource pointer

- remove now obsolete clocksource pointer field and related code

This series should not alter any behavior. Out of the existing
get_device_system_crosststamp() users, only ptp_kvm has been tested (on
x86-64 and arm64). This series is a prerequisite for the virtio_rtc driver
(of which RFC v3 is to be posted).

v2:

- Align existing changes with sketch [2] by Thomas Gleixner (omitting
  additional clocksource base changes from [2]).

- Add follow-up improvements in ptp_kvm and kvmclock.

- Split patches differently (Thomas Gleixner).

- Refer to clocksource IDs as such in comments (Thomas Gleixner).

- Update comments which were still referring to clocksource pointers.

[1] https://lore.kernel.org/all/20230818012014.212155-1-peter.hilber@opensynergy.com/
[2] https://lore.kernel.org/lkml/87lec15i4b.ffs@tglx/


Peter Hilber (7):
  timekeeping: Add clocksource ID to struct system_counterval_t
  x86/tsc: Add clocksource ID, set system_counterval_t.cs_id
  x86/kvm, ptp/kvm: Add clocksource ID, set system_counterval_t.cs_id
  ptp/kvm, arm_arch_timer: Set system_counterval_t.cs_id to constant
  timekeeping: Evaluate system_counterval_t.cs_id instead of .cs
  treewide: Remove system_counterval_t.cs, which is never read
  kvmclock: Unexport kvmclock clocksource

 arch/x86/include/asm/kvmclock.h      |  2 --
 arch/x86/kernel/kvmclock.c           |  5 +++--
 arch/x86/kernel/tsc.c                | 29 +++++++++++++++++-----------
 drivers/clocksource/arm_arch_timer.c |  6 +++---
 drivers/ptp/ptp_kvm_common.c         | 10 +++++-----
 drivers/ptp/ptp_kvm_x86.c            |  4 ++--
 include/linux/clocksource_ids.h      |  3 +++
 include/linux/ptp_kvm.h              |  4 ++--
 include/linux/timekeeping.h          | 10 ++++++----
 kernel/time/timekeeping.c            |  9 +++++----
 10 files changed, 47 insertions(+), 35 deletions(-)


base-commit: 17cb8a20bde66a520a2ca7aad1063e1ce7382240
-- 
2.40.1



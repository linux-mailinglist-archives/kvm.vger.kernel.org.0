Return-Path: <kvm+bounces-7636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28BCF844E72
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:12:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3CE2293F82
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492814A32;
	Thu,  1 Feb 2024 01:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="vY+1udhH"
X-Original-To: kvm@vger.kernel.org
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4B01FC8;
	Thu,  1 Feb 2024 01:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=18.185.115.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706749717; cv=fail; b=JIsalB4/OQysR0ysG7rpU1S+oDHUNuCulixvP3mTOHhzI9ZXmTfgIkrJebGgyNUS24CAb3y0qgKl/Ik5pYctDtrcXMD9Pw3UPn2GCAWa2BQXZs5iwlUav85/yGBc5S1cJhRtNKQdSRmeN4MFWZRmlzGRoxuk9a8IUu+SCf5zdhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706749717; c=relaxed/simple;
	bh=oohEjQrzvapv0uR3lS9rKQZ5S5PGY1gElpFaIbQC5+w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Dl3oiPuGc+MNwgL00FCp+dxIEg3m0BP/0q0dN+sOJzem6x+p3SDaE8N+pSwC+9uBdglzR47prFyODp3iFm9bHqu1RQivybx7WOAjnmz2/hVqfrWfG2oyrY4OdjeDmKO2u1lGrkzpsoCxyTIMaOpF0YDHheYrvUp1kYgM1rDJfh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com; spf=pass smtp.mailfrom=opensynergy.com; dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b=vY+1udhH; arc=fail smtp.client-ip=18.185.115.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.7.169_.trendmicro.com (unknown [172.21.176.220])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 0ED311000007B;
	Thu,  1 Feb 2024 01:08:34 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1706749545.465000
X-TM-MAIL-UUID: 91f114d5-cdae-4860-91b8-7a6b17dffd8c
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.169])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 71D17100003AD;
	Thu,  1 Feb 2024 01:05:45 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQg0F0onfrHuJeQMIS3f5yRTmE+7A57wFB3jEQFZNBe+ygqB7bCsDhcPXkJZfPhZ3wT2TRoyaFgGptf2qQT1d3DHQFCHiUpER/9zj9LMxNCJxwwaBhL/yw72/3nEAVDRIUap7qzbPmEV7L0CsMufHrWtYNa62ce7GrrJSIBL6puVc64Bmpp94I303bhj1wM0uSlV/oL2ihFpzRcQ+9fPC9QrlS3quFTzIsjdwsbi0RSM0YWi9eu/Xm7pEiojjBh4IHmjeEK2QDrgIX3YztDh7sipZt9shBPAkVY93E4A23KLxNz0HKZ82Oz2xrmP1j0zYC8ylgVmNZYNq4LKwYyXRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpqQiNj/kxIgYjjUNSOJjdxt9i7tE6QKYLiavqxbOJU=;
 b=ohBfA7DzslpQoVW9xqriHTgooZEzhOAd3L2uPQAcjA/EZe9KlgTHzt3JBWw1l6NXzWwik8TvFDRwuXkIgoQOM+D1zNogULzFPkjv4gpWfW1A9yDC8hGBGACuMrTzkgJNmPivtroeV5cQhfOyJTs3UlDbE4CyBaJXZ3hcJjE76b86gwbA54ipufyqWHkP190yHczOhe59i/CGAACiivClEXh8B4xodZZkMmZwNkHAUegxNACbVgN8ZRZmYDS+whCLhiYG6QqQHFk6Yy2vHXtaN1Rf38rh+57zMSE5hsih4/WDubiktAFf2ERM0WDnCKgVWGKklG2xyP61zCBYmf54Zg==
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
	"Dong, Eddie" <eddie.dong@intel.com>,
	"Hall, Christopher S" <christopher.s.hall@intel.com>,
	Simon Horman <horms@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Subject: [PATCH v3 0/8] treewide: Use clocksource ID for get_device_system_crosststamp()
Date: Thu,  1 Feb 2024 02:04:45 +0100
Message-Id: <20240201010453.2212371-1-peter.hilber@opensynergy.com>
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
X-MS-TrafficTypeDiagnostic: DB8EUR05FT034:EE_|BEZP281MB3106:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: aa9a9031-901c-43ea-7678-08dc22c1e9ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4SwkuaKy26n9g6JnGJkPstpqo116JdztJTGa3iJVyqtG8bFNaUETeF4oR/bCjzXb7Gj3CMMHXivol48RA7V4eFL6/ax8vPACNt7XqGCGePpLHq8SzjAIdRM2d6BiAmDevW52IT45Yie03lx1qQOwWkLUvakgCCOcBCOt9EzAM9mJLYOnoPPEQT1Hr5X/mVtp2tOivFlDpCffebRXKOcIQls+vPZz36hGtJ36If3QVf9qRcAclWIA1cPghgVLug3gvl70aWr+GRyjLS1Fu01SyaVrHifyF9/Qdc/8L5+hmB91teAoxtvdITrKSgxaJXYP6x2Cmbb33XFSnBytlo8IieVdP4DAVQQjoXBeua7rOp+HsQY/VOXxf52Raavn0j0WuZLS9j73W7vE6Pelx9jGDa5xfVEh6yAB2qiNEr7pV06cXLEzNoAMAFdilNGpX1dybpRTwZKlY0RS/84eWm5n98ECntkI9q5mqXveLiU9CEG1xqC38ZXo9NC/eszawUVxMymiap3sFXZxKF7r/7uG6mFDaJajrz/w6Ns9KAS7rknH+GbAQbMHHUviupLA+OaCmNVvSGujammcujvGQO/hvfrHQ2mQgqC7DgRXuaRG1dKtdYhlgUyhWXcn6AK4eFxJj+VpEzEMSkDLLooB4fwRO3aKij4cfQ/+2Q6wmtkkC696HcIdXgpt3eBnRyO0nT7MBktoA+i40ORWpQ3DovWuM0NuVQ0TZYbguzp48ms3cMxejIchzl9Pw/K5gLH/7i4bMoZBrh61ImLqlUATsoZU77xgCP0ThVsQfFb/nGG1bLewHcJqIcQpksyKoY4DKwiV
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(136003)(346002)(39840400004)(396003)(376002)(230922051799003)(230273577357003)(230173577357003)(186009)(82310400011)(451199024)(64100799003)(1800799012)(36840700001)(46966006)(41300700001)(5660300002)(70586007)(4326008)(8676002)(8936002)(2906002)(7416002)(86362001)(44832011)(70206006)(54906003)(42186006)(6916009)(316002)(36756003)(36860700001)(47076005)(81166007)(478600001)(966005)(83380400001)(1076003)(26005)(2616005)(336012)(40480700001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 01:05:42.7163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa9a9031-901c-43ea-7678-08dc22c1e9ea
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR05FT034.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB3106
X-TM-AS-ERS: 104.47.7.169-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28152.007
X-TMASE-Result: 10--9.655700-4.000000
X-TMASE-MatchedRID: kU+oJxJqVp+UP+0hdpOx0lmcWIT2GKzJi9V1e7G8XUijN1SoAtAGxtsH
	8mvO8CBHCRqqhJm8rIn5mjPOVI6+s/oKZK4fc4pdc6MQph12+/qgn19QHAlOzICpIfHsTRJvaQX
	O0KwCdXrdTrmsiWLAxD3Dhol2PU5Lmbpduk4zUf/BcAkkfZSxiKJDaGSlxWd0nFPS5wCjpHZ01t
	kgbj61ndpXJMrozGW3YpESvCL4it1Y7t9efcoDgI/LriVzPuf5wgrtnQK+MOoY5qQDqF7ovmDbt
	ijTkWnp3MnltAZSB6WDdsVaS6GBxzFZ+rmPiUkrsZIjJc0QK/bVLrJfyVWkTeEZbxf3Zciyh21E
	BzIb6ox/PBbU24mRsJqKJrV3x9ZQXV7SCcp2kYuSHQtEOSQwHEXzYX/dCbSfMHiMmW0ZUNss3nA
	Y9fdM9dh5c4TN8zbZ7PVkFWMnCn8N5Rk4kJccyAwdv/u39cUHoli4ZoiOHT9+ICquNi0WJL0Rdj
	vdXSTSc1mnLhfpPYG9EGEki1p2D9gS00QqA5oUftwZ3X11IV0=
X-TMASE-XGENCLOUD: 46464346-aa41-412c-9459-3adbed66af2e-0-0-200-0
X-TM-Deliver-Signature: E53744A90FEB612068C1A10663A0D405
X-TM-Addin-Auth: Hn48YxJdqloKVmrtONTaujT6J+gMYyewEsscs5FseHrjAJvx7khCR8Wm7KA
	QNofComxEaSLqfZNWdFZJliRP+mjmcNc5kQnc+Km0tYSXLzok3OoglhTQH/1D0V1T7udt/gWBaq
	AHiYwLLbR+HnPN8YXGRsXhXgPDO50H5IDvTrKmqYtGlldTcOFI500JFgFVNsBqET0nsHlhuRKsw
	516DlGeblvX7JS1Oz3s8mHDTQ5FUSYAUZt6KUMa0yKhHVtqkmw8jm8y0km88gRj7wtjg+qxP/ef
	5e92o+LihlmRTVJTBAOyDrq1jZbFFrqL2Ek1.bBD+JSCJ8cycENkHPM45HyFYal1+LCHEFbTwRh
	qFtutrcdZJQf8vvJOYtIZbT57MYOE7nKsOKvJrnB0zcRBLhMRa0ZzRyKHIvQlViXhOFZfR1m7ZB
	FGn/kYNORK1a3JI0xYJ2h/A6PaBJ2//EBvSyEZJ2ojua7JT7rw7c9FR4aAsBiVO9BN8PSuEw0UK
	w5EgfcvyhvmaB9D6BLnJPtmZUKPnkJMH9dryP4WftTqTkuJsO6VI3sdF924CgF8uDaB46nSZHpp
	gFYgzi6alLz6yqK/RFgzA06EPpjIcFlXZ24pFUIRJ0ff2aRCdkTDQ++gs/mtM1hhWwZZqyAzz+c
	i+JQ==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1706749713;
	bh=oohEjQrzvapv0uR3lS9rKQZ5S5PGY1gElpFaIbQC5+w=; l=5321;
	h=From:To:Date;
	b=vY+1udhHfDmjfepIYBPpZVPzmT5c82H6cOcSB+pTNjU7Zu63qtFX2KDbl3bGlIM34
	 a3HOtEwNIlTgFgRekkKZwXheDhTdXayNXtS/zTvyWB2zZGHEO9sMbkmVBY43CQdxYg
	 jldYuu1054YMVY9KBgSbEBEV8g4eJnPnDk18mFubq83YFqvArNsN8HBYTAaOoK9jiK
	 Jse7qJQZ0zyoWGLJypYVCY576b0KidBzzY+y6kqFsznfLNPukg/I28l47yXlpRQv9u
	 362BsgrkJyIkVr0WQS+7tAZ3GMsMH1gqiMPsMxQaMYRUDI78+DJhZS7ietRI/Vy4kV
	 MekQ/7SgvBT5g==

Overview
--------

This patch series changes struct system_counterval_t to identify the
clocksource through enum clocksource_ids, rather than through struct
clocksource *. The net effect of the patch series is that
get_device_system_crosststamp() callers can supply clocksource ids instead
of clocksource pointers. The pointers can be problematic to get hold of.

The series is also available at

        https://github.com/OpenSynergy/linux clocksource-id-for-xtstamp-v3

Motivation
----------

The immediate motivation for this patch series is to enable the virtio_rtc
RFC driver (v3 cf. [1]) to refer to the Arm Generic Timer clocksource
without requiring new helper functions in the arm_arch_timer driver. Other
future get_device_system_crosststamp() users may profit from this change as
well.

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

- add clocksource ID to the get_device_system_crosststamp() param type

- add required clocksource ids and set them in
  get_device_system_crosststamp() users

- evaluate clocksource ID in get_device_system_crosststamp(), rather than
  clocksource pointer

- remove now obsolete clocksource pointer field and related code

This series should not alter any behavior. This series is a prerequisite
for the virtio_rtc driver [1].

Verification
------------

Out of the existing get_device_system_crosststamp() users, only ptp_kvm has
been tested (on x86-64 and arm64).

For each patch, with next-20240131 and mainline 1bbb19b6eb1b, on x86-64 and
arm64:

- built allmodconfig, allyesconfig, tinyconfig with GCC and LLVM (with a
  few unrelated features turned off)

- runtime-tested ptp_kvm, checking ioctl PTP_SYS_OFFSET_PRECISE return
  codes and clock synchronization success (reverted unrelated 
  "tty: serial: amba-pl011: Remove QDF2xxx workarounds" from linux-next
  on arm64, to get QEMU with console working)

Changelog
---------

v3:

- Drop RFC.

- Omit redundant clocksource_ids.h includes (Andy Shevchenko).

- Fix tsc.c kernel-doc warnings, omitting some redundant documentation
  (Simon Horman).

- Document relevant verification.

- Improve commit message wording.

v2:

- Align existing changes with sketch [2] by Thomas Gleixner (omitting
  additional clocksource base changes from [2]).

- Add follow-up improvements in ptp_kvm and kvmclock.

- Split patches differently (Thomas Gleixner).

- Refer to clocksource IDs as such in comments (Thomas Gleixner).

- Update comments which were still referring to clocksource pointers.

[1] https://lore.kernel.org/lkml/20231218073849.35294-1-peter.hilber@opensynergy.com/
[2] https://lore.kernel.org/lkml/87lec15i4b.ffs@tglx/


Peter Hilber (8):
  x86/tsc: Fix major kernel-doc warnings for tsc.c
  timekeeping: Add clocksource ID to struct system_counterval_t
  x86/tsc: Add clocksource ID, set system_counterval_t.cs_id
  x86/kvm, ptp/kvm: Add clocksource ID, set system_counterval_t.cs_id
  ptp/kvm, arm_arch_timer: Set system_counterval_t.cs_id to constant
  timekeeping: Evaluate system_counterval_t.cs_id instead of .cs
  treewide: Remove system_counterval_t.cs, which is never read
  kvmclock: Unexport kvmclock clocksource

 arch/x86/include/asm/kvmclock.h      |  2 --
 arch/x86/kernel/kvmclock.c           |  4 ++--
 arch/x86/kernel/tsc.c                | 28 +++++++++++++++-------------
 drivers/clocksource/arm_arch_timer.c |  6 +++---
 drivers/ptp/ptp_kvm_common.c         | 10 +++++-----
 drivers/ptp/ptp_kvm_x86.c            |  4 ++--
 include/linux/clocksource_ids.h      |  3 +++
 include/linux/ptp_kvm.h              |  4 ++--
 include/linux/timekeeping.h          | 10 ++++++----
 kernel/time/timekeeping.c            |  9 +++++----
 10 files changed, 43 insertions(+), 37 deletions(-)


base-commit: 06f658aadff0e483ee4f807b0b46c9e5cba62bfa
-- 
2.40.1



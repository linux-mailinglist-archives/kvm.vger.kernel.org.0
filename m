Return-Path: <kvm+bounces-7637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B01BD844E7A
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:13:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D45961C2A810
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9CB33CED;
	Thu,  1 Feb 2024 01:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="Rd+6oYlw"
X-Original-To: kvm@vger.kernel.org
Received: from refb02.tmes.trendmicro.eu (refb02.tmes.trendmicro.eu [18.185.115.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161351FB3
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 01:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=18.185.115.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706749906; cv=fail; b=tsfVuz/wHdSJ7If/mQK1xxHPr5822s4ZXFNytAFY0IIQfzuHE2gDhlJLRYYBQZxInliCWh9Smd3oBJVzftPRwB/jrL+cHLOVGaeynQtKKW6atEBQdFTGrxzFO5REtTSFdx7wL4K+I647ETARPuordw0e3C7wbeS56Jrkxctfgj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706749906; c=relaxed/simple;
	bh=GD3Um5Fk9KYt8CWRDZT+Iu5Qq0xNhOzbOrimElkMX08=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cHQPzm58NXMwrv8OPNXAj1Fn+6eshY3UNezu8sNymQjAhXy41btAiTHqV3ITt0PDIMBEa4GMCGGxZp47bR2D4X1say0udPATS2Y+F791Ui3b3kqt2PVtHQa9TARwO+W3HH5c/gbh+BHfiM659pPMwFkYch8zYncqi/qL31SVAoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com; spf=pass smtp.mailfrom=opensynergy.com; dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b=Rd+6oYlw; arc=fail smtp.client-ip=18.185.115.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.7.169_.trendmicro.com (unknown [172.21.9.50])
	by refb02.tmes.trendmicro.eu (Postfix) with ESMTPS id 6D78810A7E2D0;
	Thu,  1 Feb 2024 01:06:25 +0000 (UTC)
Received: from 104.47.7.169_.trendmicro.com (unknown [172.21.176.220])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 9666E10000E36;
	Thu,  1 Feb 2024 01:06:17 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1706749549.127000
X-TM-MAIL-UUID: 709e3cc4-757f-4404-9af5-e56d9b0a6509
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.169])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 1F23C10000E27;
	Thu,  1 Feb 2024 01:05:49 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zknp6agk+5MT2WVkC1kU8vBXclZZnhsjEAdXme5JAuPR+tkvaWwisgw8R1Iv3liuFMbCTaNqtqAz5HTs+S9/XC0oMgzzBHIJVpkP1G12UR2E395ArK4lIm5RKb9Ws7MjLUy7eT8IdfcA99t1SubH8sLpd46X8vrUvaJBmY+oA6SdWym+9UeH4ak3L4agMVTD6kcORjA3Jox+E9o2g53SJ9HTFWr7JRy+Cy/9R1HBsiWprVoAndEynM9P5DrcKiK6kvNpGPIPaoiNQ8ITwuIh+KN7hesKr+eqm166rNdBLOQRI/kQpBocq/lp7J3gOYUefkFxligxX8JNoofDdX70Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=19V5f5v4K31vf5r1k2uGbWqScSaz2MU+qssn/Nacn4w=;
 b=b9yZ6yK75RQUi/YqMqz9i4Aee9bK5CqkjYQq5kylpZGU+Fo9Sk7sqEiglON3vlN0Nu1s4nMC0ynQO1+Tqy2hORkgVlthzdexTWNLXZI5t4A/Fgk/hFgyca/VbWY2mEnbICFPKJ+ZEmUppl0FYp+UORJ94F6LkPeQeDL7hlbo2P7L1h6exfoM8nd2scqEVU5FQd8KkaiEz/VKYxat6WiikbEp36nNxkyp55zIRrCLSa21sxSyNVxfrEaUUv7HiMJIhU9DtkOE/gpZkgdMgwiNMtia+nv0ym8IjvcqdJys1vvVttdrjx7aH/2rLpNy6wBAsnMqd1PDBP40VRfXjgr7Yg==
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
Subject: [PATCH v3 6/8] timekeeping: Evaluate system_counterval_t.cs_id instead of .cs
Date: Thu,  1 Feb 2024 02:04:51 +0100
Message-Id: <20240201010453.2212371-7-peter.hilber@opensynergy.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240201010453.2212371-1-peter.hilber@opensynergy.com>
References: <20240201010453.2212371-1-peter.hilber@opensynergy.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8EUR05FT053:EE_|BEVP281MB3522:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 68e8df3a-ccf8-4dc0-f8de-08dc22c1ec77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SMPn4YTEVAuru0q6PEGjScR9cb4/cXYPn25yAmfn1n2RnNTtLvMDwXPiToRJ82YnOhnlYYm1DlLzCMZuXSsOBzxh1i0zrW3CvHARxfYejvUkMZ56alcVtS8Aj1Iuj+zpXG7uHRYi/u9cnRIndVovAO1KWo2yu53PAAJ024q6dZAwyt1rXdi35nkx+A9lyIHeAlU7WZmAdZXTBacP1PbcXG/1Zm8yUuwc00KsDSE/aiWzZHHNq86Oy2Kewph4zn3taHLDx+Ws00PDXEvPWMMwnCKqY3oz8VEmXgpy9rnbMVyEO6lvDcXYo5cLus+RhYTH3fce2aIUeK98aqhsWe/D0UvsBt1toW7zFgb4EjFicwwXtJDeiw9B5MTuOYajxbMDg09N+IxZGP0hYll4GzBuHHPmpEv3MEI15nBds1b8BOSRyryo29kHm2Kjyy4TSZemQilz+04L75tdjyR2gWpNB6X55BTsd/4zSBGAy2TA9wo9pKeti25RV81KF5WNWLMTGcCzzph5/UUnbrqAcAsVLJIS7UhoD0Q8qJ2OBN+8FB0juwuF/IgOE/Ix2Me7Il1uSmxlu4yzk7y+eApzyDpFXRTBuyz5piMgCc6/xbgZee7Gg8N9YpoQDT4wxswW/11iDf00pjqHaevZ97B1q+MUIxuq2uH2UixjTnS5lN7q8Z/41yBzLvRveplJgs4GB4rWQAFg6v0u6kDXC8pHCtKhuea5bxW8oXAqtwnKrHsMtVHDxZAcYJ+DKw58gtRw4Xgj
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(136003)(39840400004)(346002)(376002)(396003)(230922051799003)(451199024)(1800799012)(82310400011)(186009)(64100799003)(36840700001)(46966006)(41300700001)(83380400001)(47076005)(1076003)(2616005)(336012)(26005)(81166007)(36860700001)(4326008)(44832011)(8676002)(8936002)(5660300002)(7416002)(2906002)(478600001)(966005)(42186006)(54906003)(70586007)(70206006)(6916009)(316002)(86362001)(36756003)(40480700001)(142923001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 01:05:46.9992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e8df3a-ccf8-4dc0-f8de-08dc22c1ec77
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR05FT053.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEVP281MB3522
X-TM-AS-ERS: 104.47.7.169-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28152.007
X-TMASE-Result: 10--4.043200-4.000000
X-TMASE-MatchedRID: xPvPRJicGCRt/9ulvM0QMd/Z7q+hZQVe6wJlKkXfZVkJ5yiKyAQmigHW
	HoYGrPh+C2QDPheido9iBl6ePEpdZVlsdSBrk49aju2XlcEx9HRelLFkoMPMWOI/qZVAgf06Vif
	9o7rSV9vm9Tc/GgfFJwFtWueZlMH0t5KZ74QYwoxVSWOKG8Va/NVTzaAe7ACyygHdGJDPWm8TJ/
	T+Ssc4ZVqoLahcwH4L6xA0Ava73nAPm15xyht8lXx2eIlQG1sMfC4IwOLvyucC4DhlAS07elo7G
	mCOJYd1+Tf0tcxKuLqp1o3scZXZMKi/idDT83QQLnekw6JLry5x/K7fMpYywQ==
X-TMASE-XGENCLOUD: bd19414a-342d-4838-91df-7f66a485cb9a-0-0-200-0
X-TM-Deliver-Signature: 2BA278FB04BECBAC442E7F811F5E5EF9
X-TM-Addin-Auth: KNGNGy7t/AMGYYoPNJK33ihSH7nZOlcO1ENE9vIJullXy940AcoaOTWa2EH
	CaJ6tWJPN/O3nktQf4U8z82TJnXEPnNin+3JoCVAHtJJS52G5DRKQm5kOdWRlMM5E+RLfJXjcMs
	PSSGY8C6UENKzGxp/+F69UGZoV1GwNw3+rxSV9eQ5WwxvJLauAlgDfZYcRwtUivqlPJf3SLVzQ9
	GnFCoAa692daYx/wOu86WSacyFs8K5UWgW07fnOgzh9mt8wMHLfWeVzUkBLPZuHZoR22RZps4xR
	T2JwLeXP3oHXap5LIrWC5xK3X/e4m8oenkz4.dzBdD0ueEzIDCZ2p1juT/CU3dycpZ3O8MSXgnj
	e/cu5MlnrLULYa7fhzKgDw2NBlrFuvRXSE7OPgyhF6XTPbcNlYa+H30FOzK0YJBymT9ZuQ7LVaw
	rOMdn/QKgcJgIjXx1AjjZGjsalneCBHi7+U73LyV2AE/ouKwcMBBhJeCmPE4z17kxgOKmr4DBWZ
	GL0HmtJXfBLWR304+8BqiXl/BMdGsmFx167jGXMXOJl6le/59k6hnjC5xMiI7JeK8vlTi+4y64L
	MlwAIzSmOh3HxyBr2mWFIQ8XT48PUxwz0S3CQzZ4zzQQ/GDfkN6LQ9qSD3PChPWr9rVU2Dd4qb4
	3yWg==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1706749577;
	bh=GD3Um5Fk9KYt8CWRDZT+Iu5Qq0xNhOzbOrimElkMX08=; l=3419;
	h=From:To:Date;
	b=Rd+6oYlw0e5i5m/oaOaELqxRPwIeG1mlIQovq3Yvw72ixqAZDaxVS9qRblcqx1kdv
	 XkCyQ5QbF3iMch+YLL2ARfcEB9RTh4IXINOZDGOKAxRIsBP94wTNfGKZt7f9X2x3tq
	 JXH/pICCc7AfoXB/vAaG1V9gf5r64hmQ5oGwNLtRgeosCAXiBRb4BbqggKzBtPzB8e
	 wBw37E42Uce7SUy+17En+9gBVtHgogYStStsLKosCVDryexFvyqfrjgM20s/f2S8Rr
	 ZiTTg7HKGDtAI1PoIuLKbGVJLZ/e/bNkh9PZaRW1AHX8/JxtcFsDFUJ4wWuyOGLbQ9
	 +3BagxUPjpgCA==

Clocksource pointers can be problematic to obtain for drivers which are not
clocksource drivers themselves. In particular, the RFC virtio_rtc driver
[1] would require a new helper function to obtain a pointer to the Arm
Generic Timer clocksource. The ptp_kvm driver also required a similar
workaround.

Address this by evaluating the clocksource ID, rather than the clocksource
pointer, of struct system_counterval_t. By this, setting the clocksource
pointer becomes unneeded, and it will be dropped from struct
system_counterval_t in the future. By this, get_device_system_crosststamp()
callers (such as virtio_rtc and ptp_kvm) will no longer need to supply
clocksource pointers.

This change should not alter any behavior, as the struct
system_counterval_t clocksource ID is already being set wherever the
clocksource pointer is set. get_device_system_crosststamp() will now fail
if the clocksource has ID CSID_GENERIC, but all currently relevant
clocksources have a custom clocksource ID.

[1] https://lore.kernel.org/lkml/20231218073849.35294-1-peter.hilber@opensynergy.com/

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---

Notes:
    v2:
    
    - Refer to clocksource IDs as such in comments (Thomas Gleixner).
    
    - Update comments which were still referring to clocksource pointers.

 include/linux/timekeeping.h | 10 +++++-----
 kernel/time/timekeeping.c   |  9 +++++----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index ca234fa4cc04..3538c5bdf9ee 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -268,13 +268,13 @@ struct system_device_crosststamp {
 };
 
 /**
- * struct system_counterval_t - system counter value with the pointer to the
+ * struct system_counterval_t - system counter value with the ID of the
  *				corresponding clocksource
  * @cycles:	System counter value
- * @cs:		Clocksource corresponding to system counter value. Used by
- *		timekeeping code to verify comparibility of two cycle values
- * @cs_id:	Clocksource ID corresponding to system counter value. To be
- *		used instead of cs in the future.
+ * @cs:		Clocksource corresponding to system counter value. Timekeeping
+ *		code now evaluates cs_id instead.
+ * @cs_id:	Clocksource ID corresponding to system counter value. Used by
+ *		timekeeping code to verify comparability of two cycle values.
  *		The default ID, CSID_GENERIC, does not identify a specific
  *		clocksource.
  */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 266d02809dbb..0ff065c5d25b 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1232,11 +1232,12 @@ int get_device_system_crosststamp(int (*get_time_fn)
 			return ret;
 
 		/*
-		 * Verify that the clocksource associated with the captured
-		 * system counter value is the same as the currently installed
-		 * timekeeper clocksource
+		 * Verify that the clocksource ID associated with the captured
+		 * system counter value is the same as for the currently
+		 * installed timekeeper clocksource
 		 */
-		if (tk->tkr_mono.clock != system_counterval.cs)
+		if (system_counterval.cs_id == CSID_GENERIC ||
+		    tk->tkr_mono.clock->id != system_counterval.cs_id)
 			return -ENODEV;
 		cycles = system_counterval.cycles;
 
-- 
2.40.1



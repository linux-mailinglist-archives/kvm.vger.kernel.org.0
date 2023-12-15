Return-Path: <kvm+bounces-4598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F09815347
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 23:10:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09F471C23596
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 22:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BCB766AD3;
	Fri, 15 Dec 2023 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="UrFihNp8"
X-Original-To: kvm@vger.kernel.org
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228095F841
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 22:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.11.169_.trendmicro.com (unknown [172.21.10.233])
	by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id 5F030100059DF;
	Fri, 15 Dec 2023 22:06:43 +0000 (UTC)
Received: from 104.47.11.169_.trendmicro.com (unknown [172.21.203.211])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 7F14A10000D1C;
	Fri, 15 Dec 2023 22:06:35 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1702677993.924000
X-TM-MAIL-UUID: 699be982-236a-4761-80ca-85345b514ec2
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.169])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id E1DFA10000E34;
	Fri, 15 Dec 2023 22:06:33 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuuUnYpMwXxSLVv/iN+7Al9bP4zmachHgn7QF4Eg8+qWs8VZkeZvTuyzeZlek6qxS97LONQLHGLQmgfUrj+bJysvFgjKLV2IHyz8Wxw/RAYe9pL0rqw0pv9t/bKJGcbA10/+TNFAS4loGW44KIy/DfxpNd0MDNIrUUyFvrReLhkXoZXsyqnJPcqUBWqVndwPWcAgjJkHkI+xPEPJoT0WlmedpYkhzOq+oJ9CAC6RPXZK8vGdYt1Ue+0k0uXKW2dlxhE/L1KMh2J30tiKilgQ2GsC3VHXAWFEuU3YXF/xabS/UIsXvC0+lDzXhkSFM9cFfGUWuMNzBRYJgaq16DUZTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3VgXWgRtg/rFDFxEzHNoE8e1N/NnoOrbD/bAryhxmE=;
 b=U9SgLNh/uY/pPr9gZQLksMgKyoOFUymdqc8zQ2RgZCwponahJKL55++h7oYIb8B+/SgowbwULtGma2xFAuZmQlOFcFzpXtUcvIkJyv03zfhsyPjJiv/eZCMswGRt6vMNOsFyey3GFS9YWKCa3eANzrPSZxRWFnN3ry78xAAUPGhPhIqD8hI32ho1jCHQ9F20Py/gX8XaFqhijV3sbFG8nnnGjop/NGvABxcZ8P6HGpyucsL/+9tc6iU+9XUaSjKutA/uj8F/VDS4qmdlCch8uTUyvSrz5UpTRcUHCgRWABtotQP1LTYHrJ+Iy22cbSI8v/OgY3u/eil43kts7odYJw==
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
Subject: [RFC PATCH v2 1/7] timekeeping: Add clocksource ID to struct system_counterval_t
Date: Fri, 15 Dec 2023 23:06:06 +0100
Message-Id: <20231215220612.173603-2-peter.hilber@opensynergy.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231215220612.173603-1-peter.hilber@opensynergy.com>
References: <20231215220612.173603-1-peter.hilber@opensynergy.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6EUR05FT007:EE_|BEZP281MB2021:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 63315aeb-092b-4706-5d21-08dbfdba1882
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	70l7VtiH1CgCPRQp3C+VSq7rz4BcaCggxj2L0HCM/ngsS4uAgfJMVr+b9FdSSRkwfAVVjloY+jrqi3vTGVeHeBSUweLkaJMxtlEEOS7kjp4RKKeY5R4p6R5VzvJkeDPI5OYErJb3mZEpmlIWi0+bpEzGXNKzDH91Jjca6qTpJtgTnOhIDHkMB0nCLdGNbpcOyf7NKjaytecDezIJE4Tk06xdoa6jRHEhjA2e+Bigfo8LrKa4Uw/jjwMvD8Z+mz9LqxP+7g58y7a20asDogOFFt+WRMT15Eqv2haqLh9ooE6ihlgoof34GjlL9OA9U7Acqdr7np/MrLx7ay8VTFxDliQRhCwx4aSb04JWZr/k2gWXdKoJE5JdukNvHTff42h53jTkgFmlUlQEIX5b/BuW0k44j0MNgMB1rEd53jbDCJ8LVoRhuR0H7wUtJDxQOcPzJnsAqYBwvNfgzzDC2R0x/YalpzoroasoEEtjJHKYHHpggfmTbtiyzB7My4HPYm3eVKbNh7tnQ4PpxiPCanJhqtrp4hNGMHyxLm39gL11uB50fn84qXptsST9n5S9jXwRVK42cQ0tztyXGM9y8AuOSHvXTNzbPjWGnhWVlHGiyGdElazrbj1/yqQC7VvuLEuXJj/WSEp8LOPLFNq/DxWLGKQunIdDaCPAes7CggJJ1347auyQ0lDNZbM5c/TbpXl4z/JL7F0vNt2Al7yxUQilvOFkdxPsjejCY1ejC7L2F5kotbl/zmp8lWo6L+s9P4MVKAVl5KWqITfWApgt0MWnfQ==
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(39840400004)(376002)(230922051799003)(451199024)(82310400011)(64100799003)(186009)(1800799012)(46966006)(36840700001)(47076005)(83380400001)(1076003)(2616005)(336012)(26005)(36860700001)(4326008)(8676002)(8936002)(5660300002)(44832011)(41300700001)(7416002)(2906002)(478600001)(966005)(42186006)(54906003)(70206006)(6916009)(316002)(70586007)(36756003)(81166007)(86362001)(40480700001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2023 22:06:31.9216
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63315aeb-092b-4706-5d21-08dbfdba1882
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM6EUR05FT007.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB2021
X-TM-AS-ERS: 104.47.11.169-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28060.002
X-TMASE-Result: 10--1.225700-4.000000
X-TMASE-MatchedRID: I6rpFm0lrcMEZ1mm50iAbgs6eGQ6Ral9EkUS8Erng9pzi8z2Fvgo+kp9
	UxJnBl3FHDf9l7U5F7SnyNbHJWoNRbkeKW6KfnZEiu6u4shZ+fHcHWFKCmADc2shUDcgZ8ILoMQ
	NBr66IpTrLAe8bL+cp6EWqZPwachiifyRQLERY0pCPQBD3xA/3aODSWu0oxbK6gfKtA7Yhlrtmy
	EvxwC5ZF4L45p2p0pV3+6k97GsyDgqZdHEYvGr9R+AJsLlsQNEJEWB6QUw47pwgry9e+z6K02xv
	NT0DEAe
X-TMASE-XGENCLOUD: e75e3261-40d8-4d1c-aac9-f728c685c5cd-0-0-200-0
X-TM-Deliver-Signature: 4B42FBC32BA0165278B8D7FEBEE10FBB
X-TM-Addin-Auth: lofU8dU7CdFAhD8V9sagn575AEfwI3X3ytRWn+nIQZBRhSeZKXpgWtk8ubW
	QsBx7yYGxPJkY5F/LuMy6srgWd65Qo9+qbrJx0kkJwJbZ7I308Dkk+O54/YXj5rQOiQ8GX33POb
	tI+wMsWLHcGhZAb2HqQZ2d8iE9WKWeV0fo06u2vUq5+u9LpVu9Q0EXqKR7IBL9Pbpzy6TVoJHxO
	ZVKdGzMhvoYlpRbbpEAAF7n6HO5Zz/ESbRSFRAKocnepMuUrzQkaY9FFpK1+mNYwquPne2LevC8
	XXE8/nOWtZqmvQM=.bPpDQlzcOcNoYt9A5H77a9CR386jDRBzQLsgklYU2XMC+ekPsNsfD1BP4A
	Jcb6vPqH/K8HQnLDHrWQFe4mpSdqnShAFqd3aOLNfdPEO08subNevpkOxsjEM6cgsECDXl3VXul
	ORxePK6hlb+HjiJdpifFwSMaiK8h6Up9Y2F3cMoK3utczzCmVZAJBN34jqyVWgruSlZ5Sasdk+t
	vZIJdF/oMam1o+kAAkKUrZS4lHhAy3jlxW0GqQ/B1RPFKHO+3x2EIAk2DQRfLe6551X6wH9YczS
	n2itYa2/OSiyu5Ng1EKUPUVwBELXWXr/49ibhsRpDc7fUnoMUDHJ+ClcjLQ==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1702677995;
	bh=O8MqEDHj5ZPOM57SiFoYrD63DRexH/0RpOMiWwTA4kQ=; l=1727;
	h=From:To:Date;
	b=UrFihNp8K98r1vYbUF27TVe5ZLFY893mdg+6qxxVieR3os+tsgkRTv3vd47WKCotM
	 VO7if4ZlAgEs4+ifyEtmIYcB22F8y8jQdJT8vYcvF5zybfsQIpxQT+xrEiVIcb3xng
	 kAL2FqO7bJlKS0P0gl1TbsxFQM1ZgWMR8/G9Hb/GonrRcu83orW6RAGcshIR0JQ/5o
	 jg7tkio3dvaVTLF8pdrnvBRkh6RX4TJDP5eXRwKfqhqKbraoJRrN3wssNqJkbDYqmn
	 OquQ5QckNTMao5/XvlIDEadWKIwwWJl9nrOp8OJaJGYGjFydGdZXrB294q6wuoBfBw
	 ocH7CA6JWChBg==

Clocksource pointers can be problematic to obtain for drivers which are not
clocksource drivers themselves. In particular, the RFC virtio_rtc driver
[1] would require a new helper function to obtain a pointer to the Arm
Generic Timer clocksource. The ptp_kvm driver also required a similar
workaround.

Add a clocksource ID member to struct system_counterval_t, which in the
future shall identify the clocksource, and shall replace the struct
clocksource * member. By this, get_device_system_crosststamp() callers
(such as virtio_rtc and ptp_kvm) will be able to supply easily accessible
clocksource ids instead of clocksource pointers.

[1] https://lore.kernel.org/lkml/20230818012014.212155-1-peter.hilber@opensynergy.com/

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---

Notes:
    v2:
    
    - Refer to clocksource IDs as such in comments (Thomas Gleixner).

 include/linux/timekeeping.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index fe1e467ba046..74dc7c8b036f 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -272,10 +272,15 @@ struct system_device_crosststamp {
  * @cycles:	System counter value
  * @cs:		Clocksource corresponding to system counter value. Used by
  *		timekeeping code to verify comparibility of two cycle values
+ * @cs_id:	Clocksource ID corresponding to system counter value. To be
+ *		used instead of cs in the future.
+ *		The default ID, CSID_GENERIC, does not identify a specific
+ *		clocksource.
  */
 struct system_counterval_t {
 	u64			cycles;
 	struct clocksource	*cs;
+	enum clocksource_ids	cs_id;
 };
 
 /*
-- 
2.40.1



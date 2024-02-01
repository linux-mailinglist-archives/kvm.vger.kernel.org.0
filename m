Return-Path: <kvm+bounces-7634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71545844E4D
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:07:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28DA5287532
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4499C134C2;
	Thu,  1 Feb 2024 01:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="yVBUe2Sq"
X-Original-To: kvm@vger.kernel.org
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06888569F
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 01:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=18.185.115.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706749601; cv=fail; b=oKSEUyCGhcoF6c95v0XVj9F9MYEG+Mpogx0NM++Bffog8vUZBQYp29MLjUnuhsz5dW53s/hhwrryd7d6MO6JRiUvc7FbrJNTa/0rjuk6dyMQwmnPwHV1NwAbKzn8QS+DRjDXNjt5xwZMbrkea/7L1557ZZgkZfSvbkYUAdakMSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706749601; c=relaxed/simple;
	bh=VEEICBI9hb85ucOIjDdO+txOgLqKBI+xAIKrGkmsBbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C6IWzhitjQz6ADryIyIjgxKhzRN8BQSmx2kld2OP4D/RAWLsg4IZl1bfDZ8Z4uzUeCtRsacudQMbWOIcinx3BOSCercspLBcvPcS36LJ+ciIuZ/fEb/ccse9oVaIM2DdvrvdgtFdBGjkn8cnEqaWjf/phmZNOyfyZOxPqka8ptc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com; spf=pass smtp.mailfrom=opensynergy.com; dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b=yVBUe2Sq; arc=fail smtp.client-ip=18.185.115.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.7.168_.trendmicro.com (unknown [172.21.9.50])
	by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id 42B4610D3A1FF
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 01:06:31 +0000 (UTC)
Received: from 104.47.7.168_.trendmicro.com (unknown [172.21.165.80])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id B3A7C1000007B;
	Thu,  1 Feb 2024 01:06:23 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1706749546.249000
X-TM-MAIL-UUID: 83e2df86-fe60-4be2-bc0a-13be3f96a655
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.168])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 3D02010004D81;
	Thu,  1 Feb 2024 01:05:46 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMez3rGaMDRxG9JWPC/MtVIt4NdDRUvVdAec/6GUE8vsV+g868BfoKNYc30VJEsmvAUtSdgiiz1YYo0QCv1wGderMKe5JgfySakd1X1wL/B3zIIwC30LQZ5DPSZiQM2OMLCw/nmXKnladAA3Myuk7IpiCtKl0bGiOd4+y0B7dx2hU80jblPF5hb2GWa07+wyALhIgLLpneLT903PFfyOIVkEUy2aE/QHQ8s3U6JBZOA18tHqGvcoVYhdydrvHvanJ9T9kT2oDYEXKztZY87ZFe56OloktevPJWaES9nO+OnsyRRmaVxB4khQuzblgfvh/wCP2ajGpKykXijazE6YcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P80BaWCtwU961ML0qd6PJqYYAAwoo7QXKC2rGxLdToo=;
 b=VNcdtBwsaDa7BrEExG/HoZe0b0cqrbo3TsfnWa2SdW2COkkD52oMFB72SH7wvTxFxHb/YJ5EjcdwIICoI3ASo6vtmF5v0VV3u3prM6aN2QUAxpZm5eFD93my0L9JQDrX/2L3k0ZoyXmEYmhxg/uNP+IMBujP7/7EEVi/rBTbNms7cJS+ayRdGvs+wkxoKlS0ZdqEhCWgzY53Xd3v7UOiHoqjJJSS47ZeHUEuU924kQLeOcuvQtE5JWrXAOnY3S5PoBBI9/4uPTTjRzgNeLq9n3r5NKge9oWBZotrLx8Wlak/td2W5dOaMn+0Qwnh4eRtXvArFJ1CRNTEIjNDcj2DjA==
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
Subject: [PATCH v3 2/8] timekeeping: Add clocksource ID to struct system_counterval_t
Date: Thu,  1 Feb 2024 02:04:47 +0100
Message-Id: <20240201010453.2212371-3-peter.hilber@opensynergy.com>
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
X-MS-TrafficTypeDiagnostic: DB8EUR05FT021:EE_|FRYP281MB0032:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 1cfb6228-dfca-482c-2d12-08dc22c1ea60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UJ+33MOJqXy1BUIqjzZao42U6FTXpc6uM6q0Y5jYgacj1BxAR1Ku6fejhtVn89fRbMecP/IR8UWyIq55mQTb7ypblIhJjtbY1udN3Pa4qz38SJMJL3tJhMlOewyPwE5Q/hwAWzU9TF1Rvmx2OCj0CTadCjvdb0jWMdcJTzXkBkAOkL3FsjuAElPL6fFXp2G3eLQa2Gsf/bSVUrLzte03VBsdD+IMarOxtptrdHdhDYTPHA0RNgO3tdD6O1ntverq7fMQ7pQSq9xcIkfduXbwWXutg5YG5+S0hDhF6B60E3LQmpLxuX/ZxUpNJC6bUzST+FYA9JTS/3RP5ZYa3a65ve5f7kC/Y4tpvGenZkiTgvpMDkgi9kDNkMxqkNFIUnxWsv6UUK016EzRQElFOcUvLWAv+ICBogmlepUMIJnKUvZNsUTqAz9zM5EmEEJKyfJuByyaJ7wDdkXOC3xdYd2SyWBMpR1w741Q/h3JclXcX/O/SRuS8JAy+eOUDEgClYNJGU8WVruo43kNn4vJVujycQKoCjYugzcYjHi7zaghhkjxFmpkP7zKXZsTxcSP+PtFwBC4FIFvRa754kIj0IWLQWXIBH1dYvbyZrhYP0PEX7EcxUU/XbdOtSYZkI9x4nizoU7/TDi+RsO1c1nFuOL0EyFZEs/HbwThIJpUYy4SYK1zX5peJlwuUHJbBv8qLWJtCjsH6TXXViuyPbilXm2vIux2ZKnMGgHg76vT9b2GsjM=
X-Forefront-Antispam-Report:
	CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(396003)(39840400004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(82310400011)(46966006)(36840700001)(41300700001)(54906003)(36756003)(47076005)(36860700001)(316002)(1076003)(2616005)(70586007)(70206006)(6916009)(42186006)(966005)(5660300002)(478600001)(7416002)(86362001)(2906002)(8676002)(83380400001)(26005)(8936002)(336012)(4326008)(44832011)(40480700001)(81166007)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 01:05:43.4878
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cfb6228-dfca-482c-2d12-08dc22c1ea60
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR05FT021.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRYP281MB0032
X-TM-AS-ERS: 104.47.7.168-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28152.007
X-TMASE-Result: 10--1.225700-4.000000
X-TMASE-MatchedRID: I6rpFm0lrcMEZ1mm50iAbgs6eGQ6Ral9EkUS8Erng9pzi8z2Fvgo+kp9
	UxJnBl3FHDf9l7U5F7SnyNbHJWoNRbkeKW6KfnZEiu6u4shZ+fHcHWFKCmADc2shUDcgZ8ILoMQ
	NBr66IpTrLAe8bL+cp6EWqZPwachiifyRQLERY0pCPQBD3xA/3aODSWu0oxbK6gfKtA7Yhlrtmy
	EvxwC5ZF4L45p2p0pV3+6k97GsyDgqZdHEYvGr9R+AJsLlsQNEJEWB6QUw47pwgry9e+z6K02xv
	NT0DEAe
X-TMASE-XGENCLOUD: 5b6ea32b-704b-42a3-a7c3-7ea9119431c2-0-0-200-0
X-TM-Deliver-Signature: 31549B26C2C12E238FE761D6A9ABD8F8
X-TM-Addin-Auth: ySrecwAZ6T0lqY5ygKpJic7UH9JZ0ONTg5B4LEUWxWxmxrX+NxzTqbuy9T/
	B1YOtZV39v3RabXTypwHnahUBDDHv+VX35DBWxkf24fZB6OyGUUSw/PxMvOEAvy8Lv9e8M+ZKDO
	jBpsIskkODLgPyD+kxnxbAkpqXZGRK8cXaKG7PBFJJcgwgVNTNO1gHkIwShrHK4jNuGCJL5CVgx
	pRIPNLW4gp6wYLaovr+TFdELhcEfa3rIL/MdnxOnxdAHgtWR47GQgwhOwc0/J8Kdfmh6vsNuVWu
	qBmXceFOihjAAs2U/tqCUdSL6mv/9Vc/MReA.KDDjpmL4E1kvs5qcC+MdSieM0sfsL3FwnH/oBD
	tVaCHFlDpgX0PSjZUwqIx6XdLnB60NJRAbT/YOa0CS2Fuooel4jWkh32+eVuvsbQl7YYGMwNneh
	+7pVeUj28tCQm0KwxQm2KQQQvu3yfLAEthSRVBI5RvkzECC7XqT9EOeZj1iR0u2xGo/rRq9rMUc
	A9Jg0LkFCAbHtLzmUsfeKO6kgvDhUFS7QCz+TzH5pAe6Xpj8ER8e0tqQYj18N+ahwTvF6bU3KQb
	8DopGyCYin6DICZfAOATZzqaP1PX/ZRdRy/fAB/r7TMs/EkydQ9r2tz7YhiHqdUwZh7IS309KcH
	bjyQ==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1706749583;
	bh=VEEICBI9hb85ucOIjDdO+txOgLqKBI+xAIKrGkmsBbI=; l=1732;
	h=From:To:Date;
	b=yVBUe2SqPjElDv94s/Rg71vp8wnuw5LF6WDKlMqqCdt+hab6nWGOcT57byD6WKNP1
	 cWzGJ9G+2IndCT+lUuxAIEtch5gOfm/lZ/uXCQ6sfBgwlq/jCcqHGGQa1nQtTd5eEx
	 o6T3AJd0ryAMy3rwx1y9bDx5he3rtYypPkZtd1hIUwIMvy2Piomov1896bcbD0Fl13
	 WZ66wqj1nAubKgueqMkq+BG84pt0XDA6DXd+cIlk7B9wHnyv39APn/RJFYOPe0StJI
	 8PWq2IlR8E1qDKxn9Wt3YJkpQX4B0C3OdlQ8DppPzYVAfhQ5XI9Ih53GedqlTNA+8U
	 S0b+mMa053b5w==

Clocksource pointers can be problematic to obtain for drivers which are not
clocksource drivers themselves. In particular, the RFC virtio_rtc driver
[1] would require a new helper function to obtain a pointer to the Arm
Generic Timer clocksource. The ptp_kvm driver also required a similar
workaround.

Add a clocksource ID member to struct system_counterval_t, which in the
future shall identify the clocksource, and which shall replace the struct
clocksource * member. By this, get_device_system_crosststamp() callers
(such as virtio_rtc and ptp_kvm) will be able to supply easily accessible
clocksource ids instead of clocksource pointers.

[1] https://lore.kernel.org/lkml/20231218073849.35294-1-peter.hilber@opensynergy.com/

Signed-off-by: Peter Hilber <peter.hilber@opensynergy.com>
---

Notes:
    v2:
    
    - Refer to clocksource IDs as such in comments (Thomas Gleixner).

 include/linux/timekeeping.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 7c43e98cf211..ca234fa4cc04 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -273,10 +273,15 @@ struct system_device_crosststamp {
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



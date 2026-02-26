Return-Path: <kvm+bounces-72030-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id NcV0MGB4oGmzkAQAu9opvQ
	(envelope-from <kvm+bounces-72030-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:44:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2838F1AAEBB
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:44:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 65D2D3586F47
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 010F0451048;
	Thu, 26 Feb 2026 15:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GhnA+gT7";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GhnA+gT7"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010000.outbound.protection.outlook.com [52.101.84.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD1D44D00D
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121579; cv=fail; b=p7roOOdDq3UtjDonhzAcHyytiHIJuc21h/JBq3DZubRbsCtZ04ybppcKMNfqGO7QYlMnyiEQiif5FG7IlIS6A1ZPpgcNTn23P+RavRzaD6n7pT21K7c//6zpM0iYO8rRi4TCTeA++LsgDJHqUFybpO/Y+C1TsL29SQnrl7Xjimk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121579; c=relaxed/simple;
	bh=NrXtve3h+WtNk6WfObfn28QNbvOb7+ufBuHtoeXBswI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dQoGyqfGaEFfgZBHjWBgAVeKVJAuDKltfU3VNn/q1Asoa4syTfSoW0Kay3BYpMB/pWtkgFdlWmJuUJ58n2YTJutzv47U2cVatF7B5nHD7tuUnQ/ex7zl33VfWlWTan0nFfOUyjW2eiUIKnCpB3VpJ7YByZgUetMRN9Ei+lki4iU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GhnA+gT7; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GhnA+gT7; arc=fail smtp.client-ip=52.101.84.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=D06NOcLXecaSmt46DtHCrInKUfnV13Ds9D++BnC5/69EjztR/RF7EYCZknhesjUyUquYjFqfN9cp3AGXsUCXIL2zlGN6/xZKN1/Aq8dk61LUhD3Zve0d5t9UUZF/5/hYls361necUkc90zjVk+eWSelKjV1sN2ZFhqVWdsfMb2H0twIto46FBaaxOV9gTJoI1DazE/COyk71HG4PjNglr5AyQd5lrmtUN4GCg+/25/Bzfzve2jDlr1mNJx9oEyIc4XpGP2YyExQ2XL+NcdW2SivvqxWpKlNKjWeaWxyp4pgjK/v1CCeoAKOnCDrHSW7OZBxrcn4Eme7EUqnCW69Orw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIleNJRcTVWJGdSV2fALSrXzDlEY0F+bA9o4K9WCBz4=;
 b=Br9+XV160amv+LGvOfaKdJ+HrxswUGHAfCbjkMr99sZeN+LnYz+GaYM49Jja1optxbgxPtfQ5doal5HR4+3b6d//e6NPFEqUa18MenbxSu+/7syV8k1G6Pk5meUw9tkYkFWALZfRWNl+PBa6+Vzr5Qv1QMhoUDsUwGZaGgMtyYHR7wax1stH4Vw496sytOjSkettnkfXmYnCnWWrDWRmgGIyNl0wKxGJBFgWB9/wlQXgBackpuAjHswmEVIwZTeKSbCXRiyqJjKxIqM3VKSX5Yy70FOrSPc0FaYt/75rHGia+jQlSTxy0WjOd+h9jVdtsK7Je215gNs/bdNhA3lvGw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIleNJRcTVWJGdSV2fALSrXzDlEY0F+bA9o4K9WCBz4=;
 b=GhnA+gT7hXDShs/wFjPjUXrnmZNXT4DS4Qtrv8A7Bobtc2iVQTlWUIn9ysKAYFBJf/Ya8p5UbkTFGRmuDUf2s2AYvUzWNteuUoj7oQkQuaZHmlIdKNwkvyhqS7p9J0TOTRJR9IXU2GWHgKKgMgEZW/GmXLYLQjtON3tu1qFo58A=
Received: from AM6P193CA0044.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:8e::21)
 by AM0PR08MB11257.eurprd08.prod.outlook.com (2603:10a6:20b:6fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 15:59:19 +0000
Received: from AMS1EPF0000008D.eurprd05.prod.outlook.com
 (2603:10a6:209:8e:cafe::32) by AM6P193CA0044.outlook.office365.com
 (2603:10a6:209:8e::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 15:59:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000008D.mail.protection.outlook.com (10.167.242.84) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 15:59:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ow0Lf+85xG+Qt7dZGUubh48tFVpg0w0LMQMohd1qJa5QU06lG1DHXuiBY/KdKTKAYZ4aTfKXCFlymc55dlum8a3b3wK/kUiJytPbLLry9nj/qqPv+EZEWGJhF6hylldxOGyxeb/w25+j6tG05Onf8Dmii2REiN5wqsIaxeJRkpuK+EYgL1749DtQuA3GQDpq0Vh/6AiN6g7oN41YoAldbHnq3MAxxSV03YLWufZGxSYnO+lKtAsf17lYuFHHGZ4qql31RIZm0Krbg/MUSwXB021NCH8ejhDOyyAhG41IoyI9y999RFEWhCHs3nGM54f6MuO1dqy6TpsdXCV9obsfZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIleNJRcTVWJGdSV2fALSrXzDlEY0F+bA9o4K9WCBz4=;
 b=eAysPcPUwNBAw1SlYfFH0dmrPms4WkMInzvPLThnMyFhx8UWEKb3FwAeHcjF5ZV9GwQr+QoH0hdjPo6qgSNKLLDvIvdAJ/qaWttTJ9jJzdni0nrImspqy6jCvSNMNKMyLg3rK3vtMxPuwlpCmh5S3sdvVgVv4Wg6NT+1K4eOfx+p4pIqI0LQS5Kn6LlsUANuMn/jEF2xy1G4vVsx77cHZw8l1lcciqlpaXoeUaOZ6YCxIi4MxzlKYwr9NiGrDcE53lwKnON9ive8WG0QMODPUAmp7ZuiIc86T26R/4tm6cCjpiE29ua38F98c4PIgpEIqqpg3j5UrzIzE57MKjOB6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIleNJRcTVWJGdSV2fALSrXzDlEY0F+bA9o4K9WCBz4=;
 b=GhnA+gT7hXDShs/wFjPjUXrnmZNXT4DS4Qtrv8A7Bobtc2iVQTlWUIn9ysKAYFBJf/Ya8p5UbkTFGRmuDUf2s2AYvUzWNteuUoj7oQkQuaZHmlIdKNwkvyhqS7p9J0TOTRJR9IXU2GWHgKKgMgEZW/GmXLYLQjtON3tu1qFo58A=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by DU0PR08MB7486.eurprd08.prod.outlook.com (2603:10a6:10:356::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 26 Feb
 2026 15:58:16 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:58:16 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v5 11/36] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Topic: [PATCH v5 11/36] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Index: AQHcpzi3jPx/Wdk8rkGEp/FnlSc3HA==
Date: Thu, 26 Feb 2026 15:58:16 +0000
Message-ID: <20260226155515.1164292-12-sascha.bischoff@arm.com>
References: <20260226155515.1164292-1-sascha.bischoff@arm.com>
In-Reply-To: <20260226155515.1164292-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DBAPR08MB5687:EE_|DU0PR08MB7486:EE_|AMS1EPF0000008D:EE_|AM0PR08MB11257:EE_
X-MS-Office365-Filtering-Correlation-Id: ada12ab7-a3f7-4245-5e64-08de754ffffd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 BSfsyTslwotvXiDHQjvroluqIbNp9Hblu5z4Vor1cMmwXYgRiPFUoXMyxo0uVF0Y8RMWK1brS2F/1hApXwAas4u2ZMptLQJZOESyHf4SnEuX9+O8bqi4IVT64BKXn8Lh7WEf8UPtNDOJsFqH5h1fHKsJHYt4UQyz4qv5eslhHpOWkDI+65U3Kr3gOyaafiOijimSAxgAPHOqXhXJLpZoXSMwJSJPFp7u2NHbOCqu9ue1UV+ZCJEndwBsjDYb97RWwCFCJYxTTGnUHlPeQ6IQXs2uVW5pevrVFQ9NYRPAaMgEu/zQBRCAbglZIw0py/sMP3x/nXEqQkr6NAypsJaCOsOj9CIgrjYRe95hYDCfHUPbHa/P3bbZf5GF779dSiK7CvvbBIEvnas+eZGuemsrGWPhzKdZifBKDi4S/vHGZEbWIDMxujz29m6Y+qKBhCCk5N4lAjg9PbvNFQlxQmQ7Vlr1+QvRKwVhfSbkvI0LAXzB6wUYbL6NwIK5BEn/9Lrj1u0/IqOEZUxQe0mJqZglqWHAWybM1OPjIPb82tmLF90JKKZxhiEAbWAoOAdcuPM7Y9rpjAgtUaZr5cIkLZhaGPGdQbDuDCMIKsJmVZX3a+RMzZm1avuK0iF42X5zq+d7Ftm+RY+q+vcKEqqpg29P662yH10Tjhd+xB5ejsmkd2UYTfuqBerY/2fgL+7kcyYXBlU9aMTmqGvlDRGaw2/ziK8R3if2ngziO5I0tp9nD7a3StuI5qZhyQk2YVtlhD11GgWGKPkSRrXhITolit5141MUxe4xkI6lXCmklZV6C7Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7486
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000008D.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4812e29a-5e31-4189-6a8d-08de754fda6c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|82310400026|376014|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	qeH8NasUUsMiTPdPhNghp6dUhf55003wvjVsGeiFBFprKvbDo4Fd4SToR3VuMmWe4cs7DRxmOVGK9redsOyd2wlMyU86s3FXfllecvKwo5GRpVm+Rvc18KmAQSli52SBkJpeyV63Xd2PUs8Ufk93v38rdTwYLJc+zBRM11dzGRjKpkliPH3nMHPhVx17FpQcHtKs5rUU4umJHvgHyCKds524fFyU6boG3ZeQsdrX0q4CGzYWHirecYqF5xkH5Iu4skS5ZykRZtgDJQPKhFDCGxXKv47de+8rM5CrLqoU7zK7SDZf7nx7AerFvHJlepEis8WBrIhC8JclBf+1uwCTSp9NDLgn9EtVoH9MRAjUFoXhJZ/w2bBzWq/k92wgM4fljJWeLtRfkn098R4zK0TfsJGo7Tq3/N412Vx5CAdDRka+Nk9igL7uvFgzTmDkH9SbDYQWBps1zxvprJoSBrQ9gCmaU6bSVVRzN2aWdKG5J6u1Ceaff3E3CosGdMLDlCbYZR30k1ZSLoXkUAANgKJnSXdJZ25lZt/VNI7kyetIJhphzQs5/iKb8fh1aJBnc/2nsbLRlsrVimvi0UyYS7TenzOUXrEXVbnR3PPOi/31soa2s5H26f4razOFhQ2zQO6zBawsW34aa9C5vczvtBsot4j/AYODU9sSvrkVRyWjHhAzrDD9UeRfp8xIPIO5dR8KYxPbY6jaPXp/+rY1rvK1AXNQxv7+0ohN99NHwSafZfguhlhsuYALS7d8ejjpSrCteKc3THv7/ABlY5/KF5E7H03VwV246MKKOlgWk3+1F9xDTNRTnWyXW8R1sIJTCxvEv+Rx8I6XWwOxs4A4qH0bvA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(82310400026)(376014)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ws9TyMv+BUqbMaL9+vrJBZx26dqUr7qzyp4+n95A3y7k3N1LxZAZgFIOgqJmrKiJfhw79fmDLmnmTcNO1x4sfiuVL+xPJbYBkrVVibd+oNxl2ou+IFwdZBgnEiYi2hw9YMiLoY4KyG/kP6Asv01cHbV6L2RY6JUp1n777bTcNV2nOAUOhcvXgdN2gaagErVZy2/+VEnD+u19rFAbPV1Y0ONJKn0HsHcEcWJUOgDrsztzAqcEYXyuIvWw4KLaHpMdBL3uOyVwjfrPFSAJ6DR0GIq5jEBm43u8ynnUTJVUgsHNkEmKc3qSUrbsMjc+ek/uaNq+zmUCcqGUU9YT17XeuZp2Jj2okKK9v2mm6BsVjkI0DnXhaRgrWMLT6DPkw63ibejJCezRWZ/JNN/WP0XiL1g7at9KKhax3QBXVUWf2gPIHdEBkCCGbRQWVsGrC4Yn
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:59:18.9860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ada12ab7-a3f7-4245-5e64-08de754ffffd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000008D.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB11257
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72030-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:dkim,arm.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 2838F1AAEBB
X-Rspamd-Action: no action

Extend the existing FGT/FGU infrastructure to include the GICv5 trap
registers (ICH_HFGRTR_EL2, ICH_HFGWTR_EL2, ICH_HFGITR_EL2). This
involves mapping the trap registers and their bits to the
corresponding feature that introduces them (FEAT_GCIE for all, in this
case), and mapping each trap bit to the system register/instruction
controlled by it.

As of this change, none of the GICv5 instructions or register accesses
are being trapped.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h       | 19 +++++
 arch/arm64/include/asm/vncr_mapping.h   |  3 +
 arch/arm64/kvm/arm.c                    |  3 +
 arch/arm64/kvm/config.c                 | 97 +++++++++++++++++++++++--
 arch/arm64/kvm/emulate-nested.c         | 68 +++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 27 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  3 +
 arch/arm64/kvm/sys_regs.c               |  2 +
 8 files changed, 215 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index 5d5a3bbdb95e4..332114bd44d2a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -287,6 +287,9 @@ enum fgt_group_id {
 	HDFGRTR2_GROUP,
 	HDFGWTR2_GROUP =3D HDFGRTR2_GROUP,
 	HFGITR2_GROUP,
+	ICH_HFGRTR_GROUP,
+	ICH_HFGWTR_GROUP =3D ICH_HFGRTR_GROUP,
+	ICH_HFGITR_GROUP,
=20
 	/* Must be last */
 	__NR_FGT_GROUP_IDS__
@@ -620,6 +623,10 @@ enum vcpu_sysreg {
 	VNCR(ICH_HCR_EL2),
 	VNCR(ICH_VMCR_EL2),
=20
+	VNCR(ICH_HFGRTR_EL2),
+	VNCR(ICH_HFGWTR_EL2),
+	VNCR(ICH_HFGITR_EL2),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
=20
@@ -675,6 +682,9 @@ extern struct fgt_masks hfgwtr2_masks;
 extern struct fgt_masks hfgitr2_masks;
 extern struct fgt_masks hdfgrtr2_masks;
 extern struct fgt_masks hdfgwtr2_masks;
+extern struct fgt_masks ich_hfgrtr_masks;
+extern struct fgt_masks ich_hfgwtr_masks;
+extern struct fgt_masks ich_hfgitr_masks;
=20
 extern struct fgt_masks kvm_nvhe_sym(hfgrtr_masks);
 extern struct fgt_masks kvm_nvhe_sym(hfgwtr_masks);
@@ -687,6 +697,9 @@ extern struct fgt_masks kvm_nvhe_sym(hfgwtr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hfgitr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hdfgrtr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hdfgwtr2_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgrtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgwtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgitr_masks);
=20
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp =3D sp_el0 */
@@ -1655,6 +1668,11 @@ static __always_inline enum fgt_group_id __fgt_reg_t=
o_group_id(enum vcpu_sysreg
 	case HDFGRTR2_EL2:
 	case HDFGWTR2_EL2:
 		return HDFGRTR2_GROUP;
+	case ICH_HFGRTR_EL2:
+	case ICH_HFGWTR_EL2:
+		return ICH_HFGRTR_GROUP;
+	case ICH_HFGITR_EL2:
+		return ICH_HFGITR_GROUP;
 	default:
 		BUILD_BUG_ON(1);
 	}
@@ -1669,6 +1687,7 @@ static __always_inline enum fgt_group_id __fgt_reg_to=
_group_id(enum vcpu_sysreg
 		case HDFGWTR_EL2:					\
 		case HFGWTR2_EL2:					\
 		case HDFGWTR2_EL2:					\
+		case ICH_HFGWTR_EL2:					\
 			p =3D &(vcpu)->arch.fgt[id].w;			\
 			break;						\
 		default:						\
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm=
/vncr_mapping.h
index c2485a862e690..14366d35ce82f 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -108,5 +108,8 @@
 #define VNCR_MPAMVPM5_EL2       0x968
 #define VNCR_MPAMVPM6_EL2       0x970
 #define VNCR_MPAMVPM7_EL2       0x978
+#define VNCR_ICH_HFGITR_EL2	0xB10
+#define VNCR_ICH_HFGRTR_EL2	0xB18
+#define VNCR_ICH_HFGWTR_EL2	0xB20
=20
 #endif /* __ARM64_VNCR_MAPPING_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 29f0326f7e003..eb2ca65dc7297 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2530,6 +2530,9 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(hfgitr2_masks) =3D hfgitr2_masks;
 	kvm_nvhe_sym(hdfgrtr2_masks)=3D hdfgrtr2_masks;
 	kvm_nvhe_sym(hdfgwtr2_masks)=3D hdfgwtr2_masks;
+	kvm_nvhe_sym(ich_hfgrtr_masks) =3D ich_hfgrtr_masks;
+	kvm_nvhe_sym(ich_hfgwtr_masks) =3D ich_hfgwtr_masks;
+	kvm_nvhe_sym(ich_hfgitr_masks) =3D ich_hfgitr_masks;
=20
 	/*
 	 * Flush entire BSS since part of its data containing init symbols is rea=
d
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index d9f553cbf9dfd..e4ec1bda8dfcb 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -225,6 +225,7 @@ struct reg_feat_map_desc {
 #define FEAT_MTPMU		ID_AA64DFR0_EL1, MTPMU, IMP
 #define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
 #define FEAT_S2PIE		ID_AA64MMFR3_EL1, S2PIE, IMP
+#define FEAT_GCIE		ID_AA64PFR2_EL1, GCIE, IMP
=20
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -1277,6 +1278,58 @@ static const struct reg_bits_to_feat_map vtcr_el2_fe=
at_map[] =3D {
 static const DECLARE_FEAT_MAP(vtcr_el2_desc, VTCR_EL2,
 			      vtcr_el2_feat_map, FEAT_AA64EL2);
=20
+static const struct reg_bits_to_feat_map ich_hfgrtr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGRTR_EL2_ICC_APR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_IDRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_CR0_EL1 |
+		   ICH_HFGRTR_EL2_ICC_HPPIR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PCR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_ICSR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_HMRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_ENABLERn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_PENDRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_PRIORITYRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_ACTIVERn_EL1,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgrtr_desc, ich_hfgrtr_masks,
+				  ich_hfgrtr_feat_map, FEAT_GCIE);
+
+static const struct reg_bits_to_feat_map ich_hfgwtr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGWTR_EL2_ICC_APR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_CR0_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PCR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_ICSR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_ENABLERn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_PENDRn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_PRIORITYRn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_ACTIVERn_EL1,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgwtr_desc, ich_hfgwtr_masks,
+				  ich_hfgwtr_feat_map, FEAT_GCIE);
+
+static const struct reg_bits_to_feat_map ich_hfgitr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGITR_EL2_GICCDEN |
+		   ICH_HFGITR_EL2_GICCDDIS |
+		   ICH_HFGITR_EL2_GICCDPRI |
+		   ICH_HFGITR_EL2_GICCDAFF |
+		   ICH_HFGITR_EL2_GICCDPEND |
+		   ICH_HFGITR_EL2_GICCDRCFG |
+		   ICH_HFGITR_EL2_GICCDHM |
+		   ICH_HFGITR_EL2_GICCDEOI |
+		   ICH_HFGITR_EL2_GICCDDI |
+		   ICH_HFGITR_EL2_GICRCDIA |
+		   ICH_HFGITR_EL2_GICRCDNMIA,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgitr_desc, ich_hfgitr_masks,
+				  ich_hfgitr_feat_map, FEAT_GCIE);
+
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 				  int map_size, u64 resx, const char *str)
 {
@@ -1328,6 +1381,9 @@ void __init check_feature_map(void)
 	check_reg_desc(&sctlr_el2_desc);
 	check_reg_desc(&mdcr_el2_desc);
 	check_reg_desc(&vtcr_el2_desc);
+	check_reg_desc(&ich_hfgrtr_desc);
+	check_reg_desc(&ich_hfgwtr_desc);
+	check_reg_desc(&ich_hfgitr_desc);
 }
=20
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_fea=
t_map *map)
@@ -1460,6 +1516,13 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id =
fgt)
 		val |=3D compute_fgu_bits(kvm, &hdfgrtr2_desc);
 		val |=3D compute_fgu_bits(kvm, &hdfgwtr2_desc);
 		break;
+	case ICH_HFGRTR_GROUP:
+		val |=3D compute_fgu_bits(kvm, &ich_hfgrtr_desc);
+		val |=3D compute_fgu_bits(kvm, &ich_hfgwtr_desc);
+		break;
+	case ICH_HFGITR_GROUP:
+		val |=3D compute_fgu_bits(kvm, &ich_hfgitr_desc);
+		break;
 	default:
 		BUG();
 	}
@@ -1531,6 +1594,15 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum=
 vcpu_sysreg reg)
 	case VTCR_EL2:
 		resx =3D compute_reg_resx_bits(kvm, &vtcr_el2_desc, 0, 0);
 		break;
+	case ICH_HFGRTR_EL2:
+		resx =3D compute_reg_resx_bits(kvm, &ich_hfgrtr_desc, 0, 0);
+		break;
+	case ICH_HFGWTR_EL2:
+		resx =3D compute_reg_resx_bits(kvm, &ich_hfgwtr_desc, 0, 0);
+		break;
+	case ICH_HFGITR_EL2:
+		resx =3D compute_reg_resx_bits(kvm, &ich_hfgitr_desc, 0, 0);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		resx =3D (typeof(resx)){};
@@ -1565,6 +1637,12 @@ static __always_inline struct fgt_masks *__fgt_reg_t=
o_masks(enum vcpu_sysreg reg
 		return &hdfgrtr2_masks;
 	case HDFGWTR2_EL2:
 		return &hdfgwtr2_masks;
+	case ICH_HFGRTR_EL2:
+		return &ich_hfgrtr_masks;
+	case ICH_HFGWTR_EL2:
+		return &ich_hfgwtr_masks;
+	case ICH_HFGITR_EL2:
+		return &ich_hfgitr_masks;
 	default:
 		BUILD_BUG_ON(1);
 	}
@@ -1618,12 +1696,17 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	__compute_hdfgwtr(vcpu);
 	__compute_fgt(vcpu, HAFGRTR_EL2);
=20
-	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
-		return;
+	if (cpus_have_final_cap(ARM64_HAS_FGT2)) {
+		__compute_fgt(vcpu, HFGRTR2_EL2);
+		__compute_fgt(vcpu, HFGWTR2_EL2);
+		__compute_fgt(vcpu, HFGITR2_EL2);
+		__compute_fgt(vcpu, HDFGRTR2_EL2);
+		__compute_fgt(vcpu, HDFGWTR2_EL2);
+	}
=20
-	__compute_fgt(vcpu, HFGRTR2_EL2);
-	__compute_fgt(vcpu, HFGWTR2_EL2);
-	__compute_fgt(vcpu, HFGITR2_EL2);
-	__compute_fgt(vcpu, HDFGRTR2_EL2);
-	__compute_fgt(vcpu, HDFGWTR2_EL2);
+	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
+		__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+		__compute_fgt(vcpu, ICH_HFGITR_EL2);
+	}
 }
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-neste=
d.c
index 22d497554c949..dba7ced74ca5e 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2053,6 +2053,60 @@ static const struct encoding_to_trap_config encoding=
_to_fgt[] __initconst =3D {
 	SR_FGT(SYS_AMEVCNTR0_EL0(2),	HAFGRTR, AMEVCNTR02_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(1),	HAFGRTR, AMEVCNTR01_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
+
+	/*
+	 * ICH_HFGRTR_EL2 & ICH_HFGWTR_EL2
+	 */
+	SR_FGT(SYS_ICC_APR_EL1,			ICH_HFGRTR, ICC_APR_EL1, 0),
+	SR_FGT(SYS_ICC_IDR0_EL1,		ICH_HFGRTR, ICC_IDRn_EL1, 0),
+	SR_FGT(SYS_ICC_CR0_EL1,			ICH_HFGRTR, ICC_CR0_EL1, 0),
+	SR_FGT(SYS_ICC_HPPIR_EL1,		ICH_HFGRTR, ICC_HPPIR_EL1, 0),
+	SR_FGT(SYS_ICC_PCR_EL1,			ICH_HFGRTR, ICC_PCR_EL1, 0),
+	SR_FGT(SYS_ICC_ICSR_EL1,		ICH_HFGRTR, ICC_ICSR_EL1, 0),
+	SR_FGT(SYS_ICC_IAFFIDR_EL1,		ICH_HFGRTR, ICC_IAFFIDR_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_HMR0_EL1,		ICH_HFGRTR, ICC_PPI_HMRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_HMR1_EL1,		ICH_HFGRTR, ICC_PPI_HMRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_ENABLER0_EL1,	ICH_HFGRTR, ICC_PPI_ENABLERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_ENABLER1_EL1,	ICH_HFGRTR, ICC_PPI_ENABLERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CPENDR0_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CPENDR1_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SPENDR0_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SPENDR1_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR0_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR1_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR2_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR3_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR4_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR5_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR6_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR7_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR8_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR9_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR10_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR11_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR12_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR13_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR14_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR15_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_CACTIVER0_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CACTIVER1_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SACTIVER0_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SACTIVER1_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+
+	/*
+	 * ICH_HFGITR_EL2
+	 */
+	SR_FGT(GICV5_OP_GIC_CDEN,	ICH_HFGITR, GICCDEN, 0),
+	SR_FGT(GICV5_OP_GIC_CDDIS,	ICH_HFGITR, GICCDDIS, 0),
+	SR_FGT(GICV5_OP_GIC_CDPRI,	ICH_HFGITR, GICCDPRI, 0),
+	SR_FGT(GICV5_OP_GIC_CDAFF,	ICH_HFGITR, GICCDAFF, 0),
+	SR_FGT(GICV5_OP_GIC_CDPEND,	ICH_HFGITR, GICCDPEND, 0),
+	SR_FGT(GICV5_OP_GIC_CDRCFG,	ICH_HFGITR, GICCDRCFG, 0),
+	SR_FGT(GICV5_OP_GIC_CDHM,	ICH_HFGITR, GICCDHM, 0),
+	SR_FGT(GICV5_OP_GIC_CDEOI,	ICH_HFGITR, GICCDEOI, 0),
+	SR_FGT(GICV5_OP_GIC_CDDI,	ICH_HFGITR, GICCDDI, 0),
+	SR_FGT(GICV5_OP_GICR_CDIA,	ICH_HFGITR, GICRCDIA, 0),
+	SR_FGT(GICV5_OP_GICR_CDNMIA,	ICH_HFGITR, GICRCDNMIA, 0),
 };
=20
 /*
@@ -2127,6 +2181,9 @@ FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2);
 FGT_MASKS(hfgitr2_masks, HFGITR2_EL2);
 FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2);
 FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2);
+FGT_MASKS(ich_hfgrtr_masks, ICH_HFGRTR_EL2);
+FGT_MASKS(ich_hfgwtr_masks, ICH_HFGWTR_EL2);
+FGT_MASKS(ich_hfgitr_masks, ICH_HFGITR_EL2);
=20
 static __init bool aggregate_fgt(union trap_config tc)
 {
@@ -2162,6 +2219,14 @@ static __init bool aggregate_fgt(union trap_config t=
c)
 		rmasks =3D &hfgitr2_masks;
 		wmasks =3D NULL;
 		break;
+	case ICH_HFGRTR_GROUP:
+		rmasks =3D &ich_hfgrtr_masks;
+		wmasks =3D &ich_hfgwtr_masks;
+		break;
+	case ICH_HFGITR_GROUP:
+		rmasks =3D &ich_hfgitr_masks;
+		wmasks =3D NULL;
+		break;
 	}
=20
 	rresx =3D rmasks->res0 | rmasks->res1;
@@ -2232,6 +2297,9 @@ static __init int check_all_fgt_masks(int ret)
 		&hfgitr2_masks,
 		&hdfgrtr2_masks,
 		&hdfgwtr2_masks,
+		&ich_hfgrtr_masks,
+		&ich_hfgwtr_masks,
+		&ich_hfgitr_masks,
 	};
 	int err =3D 0;
=20
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index 2597e8bda8672..ae04fd680d1e2 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -233,6 +233,18 @@ static inline void __activate_traps_hfgxtr(struct kvm_=
vcpu *vcpu)
 	__activate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
=20
+static inline void __activate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *hctxt =3D host_data_ptr(host_ctxt);
+
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__activate_fgt(hctxt, vcpu, ICH_HFGRTR_EL2);
+	__activate_fgt(hctxt, vcpu, ICH_HFGWTR_EL2);
+	__activate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
+}
+
 #define __deactivate_fgt(htcxt, vcpu, reg)				\
 	do {								\
 		write_sysreg_s(ctxt_sys_reg(hctxt, reg),		\
@@ -265,6 +277,19 @@ static inline void __deactivate_traps_hfgxtr(struct kv=
m_vcpu *vcpu)
 	__deactivate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
=20
+static inline void __deactivate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *hctxt =3D host_data_ptr(host_ctxt);
+
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGRTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGWTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
+
+}
+
 static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
 {
 	u64 r =3D MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
@@ -328,6 +353,7 @@ static inline void __activate_traps_common(struct kvm_v=
cpu *vcpu)
 	}
=20
 	__activate_traps_hfgxtr(vcpu);
+	__activate_traps_ich_hfgxtr(vcpu);
 	__activate_traps_mpam(vcpu);
 }
=20
@@ -345,6 +371,7 @@ static inline void __deactivate_traps_common(struct kvm=
_vcpu *vcpu)
 		write_sysreg_s(ctxt_sys_reg(hctxt, HCRX_EL2), SYS_HCRX_EL2);
=20
 	__deactivate_traps_hfgxtr(vcpu);
+	__deactivate_traps_ich_hfgxtr(vcpu);
 	__deactivate_traps_mpam();
 }
=20
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index 779089e42681e..b41485ce295ab 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -44,6 +44,9 @@ struct fgt_masks hfgwtr2_masks;
 struct fgt_masks hfgitr2_masks;
 struct fgt_masks hdfgrtr2_masks;
 struct fgt_masks hdfgwtr2_masks;
+struct fgt_masks ich_hfgrtr_masks;
+struct fgt_masks ich_hfgwtr_masks;
+struct fgt_masks ich_hfgitr_masks;
=20
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)=
;
=20
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1039150716d43..b8b86f5e1adc1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5658,6 +5658,8 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	compute_fgu(kvm, HFGRTR2_GROUP);
 	compute_fgu(kvm, HFGITR2_GROUP);
 	compute_fgu(kvm, HDFGRTR2_GROUP);
+	compute_fgu(kvm, ICH_HFGRTR_GROUP);
+	compute_fgu(kvm, ICH_HFGITR_GROUP);
=20
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
--=20
2.34.1


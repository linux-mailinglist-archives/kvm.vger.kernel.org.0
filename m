Return-Path: <kvm+bounces-71812-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +OfzMLqznmnZWwQAu9opvQ
	(envelope-from <kvm+bounces-71812-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 09:32:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F9DA194474
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 09:32:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3F9683016EC2
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 08:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0E431CA50;
	Wed, 25 Feb 2026 08:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BvLXFj1S";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BvLXFj1S"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012005.outbound.protection.outlook.com [52.101.66.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFB4315D46
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 08:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.5
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772008373; cv=fail; b=NmMJvutIKA4dln/E0csxnMymROPRhXZRnOvlIdvotv7h5N0mPGtHOtQIKlMyvlH8rwih9+5K05JiEeuZNIIHUqxBfIlrsawDNZngUBln968QFAbmiWySOjaYpXcIvJzhfPefAoZymZcVFfdQ1wXGMytGUOf4S+wFqkaWtq0gRxY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772008373; c=relaxed/simple;
	bh=SzxTnnGF9F5UlD1FGwxX2/XLsMxQ6ujXwm7zAa9TZEU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Gj0HrL6/8ai8yhF3bu8XjlFAodHhZIC1xCBGRA+kpeBRl6YCX5xPUxun+5sWvlaqlNQaOHlc0K4A2auujZT7iQA0O39iKuTc0KeC4e8u8IPVXetRrVcAW+pYg6uHKII921ulP1dg36pTMl+CR/sDB+5VR3rh7bVy1Fxclh5dqJI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BvLXFj1S; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BvLXFj1S; arc=fail smtp.client-ip=52.101.66.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=AdicIZaCxsGAaAdB0p7ZlgL7MOqMIziZ1vt++SjQilx71gFYHk9qlGtuCIJBPxHQWSYNVXxuCa4+xib11o1jbqE2tFqy3BdS8nTrsJmu7sXkNgIlu8KLv2s5D/dAJZ9AVws2lPPsyLvIF6hzoXk6KOLHDMf5Nc4QpS/MbKGu1sV/RYd7oKfyuG+wQZDJnjb90fAXGu6SnOoew8isUIrf5lHjn7t+bUU61vXmLXraIDmos2+nFl4l45BYEjSa/QODnFJ7/QoiZ6s0ih3907OZVTnff1zbrYi2SqG1n7ZmsJmw3ms2qkph2L9I2qDJ/JDteXSfT6V+h3g9Dkl58OGAYQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Il538TCNj6KJW8tSEfeG6HiWEsG41WnK5t4KOhYUbR8=;
 b=Q/rMz5/G8e5CLe/drHCYNgKBgYcGWzksKxFLwcRJPfwJeg/D2cfH25tfeRKc3ZfgC13aPLpUS23nUNO7XdZU0+uvPzSohTQuVFXLbFVeT2il256Jk8ht/JwWvYGwjJqYRMq/DdLViQyTPz532vVQki1/30wP5IY+mUGcrrXJP5uPY/MOwiWX98NiTahyuHtyulg7Q3MjkmTTsOSNmp+Xy/eRJ0PKPUCFT81ZH0TnvSkD0883DJCyTWkTmyiwKSbQWCsqWUhyoWPngyCuegOGWoadxNjUSRWKmv2vACHMV2vNijNrAkn4odVVP2WEAOBPS7VcRxTBPLoFQo7rCfx0jQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Il538TCNj6KJW8tSEfeG6HiWEsG41WnK5t4KOhYUbR8=;
 b=BvLXFj1Sbd/8JYSwMuGxqBPbaoSLeNBVDQ77vNj5zXd8ADSXP4d315EeGDD6DWSbGIXcSkc39VW77fFwWBpg+J1GHfG+Ux6PrmUAjENVXaIDnf0hIuAP5sjVIbMpTflnaMuF05wSK7feK31KwIAqpYOjRoqW/4Zx2d5KBxQjArA=
Received: from DU6P191CA0068.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::20)
 by AS2PR08MB10112.eurprd08.prod.outlook.com (2603:10a6:20b:64e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 08:32:43 +0000
Received: from DB5PEPF00014B8D.eurprd02.prod.outlook.com
 (2603:10a6:10:53e:cafe::b1) by DU6P191CA0068.outlook.office365.com
 (2603:10a6:10:53e::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.24 via Frontend Transport; Wed,
 25 Feb 2026 08:32:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8D.mail.protection.outlook.com (10.167.8.201) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Wed, 25 Feb 2026 08:32:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NvXeP1tA5SYC4n184sG9j2psaPAiRSdCxmv/F08d9uYIhABGGJeyz9JWUL9vRlBkSnmqRE9cS3MYFEgRkBlJF4Rwif6x+LkQFw43OjIlOGTpomAouIdB6D8gPt6Cw7VIrNB4w+KJL+JPVOa0Zv5jW23R4nK1U20XSPaU+JhlYVQxAiGGLjHY8xghmyDlu6AF0I1QkLovfTcaNLnqYB0NV2BtvgfS5zyfqvJaRcPTLIp/scNw+bW6n9Jm+LvnkU47HMXYoIKmOn3wA2kmAW4JfAm3jNIw4VyX8sDTVgHYO7RDYsLORq37etKA2FzPeMJV5Qpjszc1FcF5WOciqmMooQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Il538TCNj6KJW8tSEfeG6HiWEsG41WnK5t4KOhYUbR8=;
 b=T9lh9odDwdq4BWg2zXuFThd3x0Qx05Gh7HADBynvv+WIQ7CxKuxVsjJHKok2Cq0+WUqfg3sKYETWjtRLHfVag/cMVmQALAdJNz/kUJA8+KeYoUe29dExD84FVakrFPaUJVWKUULOwc8MDuatu7Nop6uuQfMUHdRKHGG0jl3Z3I4UNhTxNWIPnZsTyDiyKG7+zEl2n6nUGF6PO86spEA8LuwGsX5DF2eTo5jnUcw3yy4FXj38xEza/jjM+lpAP/KH5X52/NIyOmXGnYfr+WDw0SJs2AQLVPygz4CbciVyW0stOwxhVGQJ/1mFzI5Z2ahLSglD0SrwikQFbQmAgX2dag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Il538TCNj6KJW8tSEfeG6HiWEsG41WnK5t4KOhYUbR8=;
 b=BvLXFj1Sbd/8JYSwMuGxqBPbaoSLeNBVDQ77vNj5zXd8ADSXP4d315EeGDD6DWSbGIXcSkc39VW77fFwWBpg+J1GHfG+Ux6PrmUAjENVXaIDnf0hIuAP5sjVIbMpTflnaMuF05wSK7feK31KwIAqpYOjRoqW/4Zx2d5KBxQjArA=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by GV4PR08MB11252.eurprd08.prod.outlook.com (2603:10a6:150:2eb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 08:31:40 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9632.015; Wed, 25 Feb 2026
 08:31:40 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: [PATCH] irqchip/gic-v5: Fix inversion of IRS_IDR0.virt flag
Thread-Topic: [PATCH] irqchip/gic-v5: Fix inversion of IRS_IDR0.virt flag
Thread-Index: AQHcpjEqjlwnZb0aGUyL9K9RPAgpGQ==
Date: Wed, 25 Feb 2026 08:31:40 +0000
Message-ID: <20260225083130.3378490-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DBAPR08MB5687:EE_|GV4PR08MB11252:EE_|DB5PEPF00014B8D:EE_|AS2PR08MB10112:EE_
X-MS-Office365-Filtering-Correlation-Id: d12288d8-eadb-4c27-a8c3-08de7448721a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?XzTszVZp7/P7wZ1OrlldVsP0rsMY7dVP7IlEM+cBfwy9YCzTQIlKfX0Ii6?=
 =?iso-8859-1?Q?XsBkWhDiMPkmFCev+fZKZ/qGzDx42oVZslmhAGYOyS2jSppyM3GJocwENi?=
 =?iso-8859-1?Q?VW9Z5XK9W17G3hekB5ZhOMqhyGQQrgTQ0GAFNE11KdCKswLImgGJhL5IXZ?=
 =?iso-8859-1?Q?09qQcJg+0jypMm0OFfpwjrK9QWoCjDObavvsJ2NgEogZ3TInB47seW9NoI?=
 =?iso-8859-1?Q?9luzR1yY+5eq6aNt0w+5jVyB1c9Njdw/E6sIt0Z56Q3h+fNaStGTwg3aDw?=
 =?iso-8859-1?Q?bkRJ+Bbf9cljhQf87YPD7IiFLzzNDrOuxTKvoZRALV1Kp9Yc62tYi9mjfw?=
 =?iso-8859-1?Q?X28VEeLBrfVlGV8TL62Q71r+UbyaMAwTiMQD7/xTaqgBTHegWfjQc7dJbO?=
 =?iso-8859-1?Q?t0KOnO8L502jfOBcmhlDZMG4a8zwxo9rNDEaVwOQwO+Rv75x2xXEk5SPpz?=
 =?iso-8859-1?Q?CWadkv5rX9AyjfVNkrSwFszAU9l+gavcNu1XS+Usrd/0NjRVzLeZgTFjmk?=
 =?iso-8859-1?Q?oDJfRYbT5GVSSa3iNIuHFUR1fe2KBvwh+O6gIzo8F21YHklIkvKm2G6ssS?=
 =?iso-8859-1?Q?xVMPbJbg4VfC5Ul4UGtGxOS38tTxu2ZO2T8lmkJ0ioBhZ7xySy+dsudnBn?=
 =?iso-8859-1?Q?3JsiOf4sgiTldba5BbvUBZ56jvDEqKwTEC+gNS2PKo1UbsJGmgXHRtrtrY?=
 =?iso-8859-1?Q?+tVBCZ1XIqYXDAr0QtBMS9AL2fquVYeIJENn3BZY+0dymfcNlGE1zcTgZB?=
 =?iso-8859-1?Q?Fpr2Wz/ZpEHTaLI9LjjK7fRnocf7byUrWqRbiQSQeHuirQKRICNN21f8/A?=
 =?iso-8859-1?Q?fDeNLWW7LK+rAYvOaoL2eTXXrT/9AoUrEc4meSYPY7+UkvthGrWd3hZmI1?=
 =?iso-8859-1?Q?YCePaMd0LreTtruopmyK6uZc/BioQbLDp6VJQReHHJ2zTbOgIMoKKxyKVf?=
 =?iso-8859-1?Q?tlzMgXF4UeFNUi3d+2rj8UQAmmGoeseAa5OZvywPJszyTwT5EJPhc/gVLX?=
 =?iso-8859-1?Q?ojmGj1Xz7xFnHEwX9EXx2POJZaQblYiaxA6lQ2tVf+siIMiOLekuL8/8m5?=
 =?iso-8859-1?Q?N7UHrfa/yMBlOqP0+e9stQcLLJURdzyJg+efE6TPOC90rNiRKBSA/oICGv?=
 =?iso-8859-1?Q?6cPS6wzs7OTFeAZkharEmvEGwvn8yYHPS5iFrEx0pdHKHLxEVV9nESZiva?=
 =?iso-8859-1?Q?irKSGtMK8jPSQLX/564R20dH/AVZTaj8eX5WjU8i5f4dXK36fl2ETEXsu9?=
 =?iso-8859-1?Q?3K8rIfVHJ9CyY1f8FF/WsP7dX4qWI4tg0Rdz1RDRJQAStbQctls+nzswe/?=
 =?iso-8859-1?Q?XpNWo9wK4W/EMRnLxzkNOojC/zYqgQPnPfRd1HxLEkWT9/t2RY5SsHqJ/4?=
 =?iso-8859-1?Q?r4ylagqUMycuCcA7oldCYlfqNOhJKi7I8yvjgFBiP96M+WmIfDCh5ZH6Zd?=
 =?iso-8859-1?Q?R/N5WOHWwT7muLRLPj7ro6IN/ZdoKwvvXVxH7JrA2qT2orH/dmMtiu9kIc?=
 =?iso-8859-1?Q?3JgvvMjG4W+Svz50MUXDJP4ku5FWNsGI5S9EQUcJq+nidJUPRAYbB5qVRF?=
 =?iso-8859-1?Q?3rO9Ht3Tdd9Z2Xqp9BBnia6uQAN+nJwoZVd1ucEECihoA0hLOSXECZquP+?=
 =?iso-8859-1?Q?fJ3fyssqwSt3XiA/faD4Qlusaog19NLq1ujED6mCa0aKJmoT7im6SRv/RN?=
 =?iso-8859-1?Q?DaowD/RyaNWRjAHGZYg=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11252
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c465a3bd-c936-4422-d59c-08de74484cae
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|36860700013|82310400026|14060799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?is+dCKDPUUuSIuOxiwmTdK3fJm4mUDcwRXCUXKMQNq0qaOeyYBSC9P8oQP?=
 =?iso-8859-1?Q?+zkVR6MEnZ928Lb1BILtMGFohlnK5zCSeb8vz77ADVHfdy9kopQKF79BSz?=
 =?iso-8859-1?Q?xxvKFLLkm97JAj+lEXinPfKJ7JESYuaq/GJxJilmD4Do0lFmhMfdZmRepX?=
 =?iso-8859-1?Q?K5qRK++JUWXOSu0TqPrWMwEZ8auE2QdYQyFUqEJxWJ7BxXMl9fIZ/oAv8M?=
 =?iso-8859-1?Q?OBsFs6SuuWt1qpiBwFVO7t3t/hohADsvW8DqKQNHoDYBJVku7/IiRE468L?=
 =?iso-8859-1?Q?BaG0rl79C9KqoyDWdDOozttHHtc5zs/X8lLM8z/m7TbH0sljmUBRLRrpns?=
 =?iso-8859-1?Q?6NZxv6nOfm/VTO8IpUmp7UxGDdAJWowHyWlWfRK/3sVKExc/hGKF7ft3wh?=
 =?iso-8859-1?Q?evtKllr5QJ7C5oIHWaOcBR+UgBINZl6gW3mTZUUdv7fkkRUzNDNqzBv6M5?=
 =?iso-8859-1?Q?VoUMUaX+f3NmcNGH5TKSGPs3TDM8eOZpFlFhmQ18+5w9kVfzXMKxRr5n+j?=
 =?iso-8859-1?Q?m6bamweE7Ih4IfJYor5M3R5Mm4sRBs5RIS9oxEyLj/d7afWp7R+83ha/NL?=
 =?iso-8859-1?Q?a+ujQEPgbTbdQBXCF/cHuU6OmQEfMzl/cvrrGrcqDRgGsXc5zPF+QEIWt1?=
 =?iso-8859-1?Q?XBacziSHqJnOHw/5JhoyU32T3T4YgyQtVo+QK7tiC+uSx0MUdNK/WoT8uF?=
 =?iso-8859-1?Q?53ZRXuQzFxD3/ODJojT6jNO567eRLLIa/CVdZ9r7o5JCBJxmFObAcfuvEM?=
 =?iso-8859-1?Q?VSeGDNxn9AGjnfJ9Vav26jzGoGfS1B758I+6dWj63QV5FOAcypMwPARLHG?=
 =?iso-8859-1?Q?05gIIUL5XXjwxsjeigLtvCeDYHNetg40Q6JqeV/DR7SETWUpUQ/6i6f8Ee?=
 =?iso-8859-1?Q?MVZmOIrMAi4u1tZbYZYLcrW+mdKzZIEPvuEbkNB878fpM/emXeYKIAFt2y?=
 =?iso-8859-1?Q?9IoH/X5qcf1gdpC6hBATwNKshXPBbiUJU59StZaaeOCiviPEe2vsMuikrD?=
 =?iso-8859-1?Q?8KD57rxChJ8RnJQnFcSdhqTrboUonJIzJ7Bg2mJpNOs34VZMuH5IUnRWqp?=
 =?iso-8859-1?Q?afCUAqIiqH/+QrdAGvXrhcZVielabgJZvARgUrPCWB/OANlpKqyQVX8rqL?=
 =?iso-8859-1?Q?qhjzAiKVnzP3WV77SJjfnHBJv3EqQ9ZBoqj/EFBXYWPHj1gxmT16+8+Z0e?=
 =?iso-8859-1?Q?hmXBUWdYcKlOI3czh4WOsMc03enLBYjBn6VlPKJudmLn5FDMOPfenBNgZy?=
 =?iso-8859-1?Q?pbE8hEgbipX+5HavfMD2nwQ4VLxAUEizxhHHDS7eYEA4hbwNaOk1/bonkB?=
 =?iso-8859-1?Q?OsXCZgCxds4xCFeNIJ2zXpADz4J6jv1GSabJhdsDzDMo4N132fj0JFJVDL?=
 =?iso-8859-1?Q?6Cf2bNjHL2ADq9zy4NzUXyTVcUwQhxNLzUOE1WcL20oupDYctxYdSwPpnt?=
 =?iso-8859-1?Q?BYNxx310CqkdXecVm6yZq+dF24Ds1kAcnvoduQu7VtcbTA98A5PE5uhFDV?=
 =?iso-8859-1?Q?XEG+cPISOyEZpdSg27Ih00owcV98Sec6qpKz/+Kva+gP/N2LIAcIggcNX7?=
 =?iso-8859-1?Q?WhUHPTOE1pPUza1UEO6SJBFtfAK3rgKZZP7hueL2xGXkqEZmcGsoYSCXn/?=
 =?iso-8859-1?Q?QzwDMjwTf6e0HMWCAbMGJyooUN255lrFK3td5DEDaPn6AjGoTWsuIiNUEP?=
 =?iso-8859-1?Q?RdvxR1ZuLkDFISJX3SmIBoHqlwVr4WEDvp7eoweJcjwCKaq0gVf06Oqu79?=
 =?iso-8859-1?Q?0AzA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(36860700013)(82310400026)(14060799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zItD8yjJMdYG1SUMuwGAHYZP8EqIVd69x1BhpZGLqiSq+JoNwNqPFX/sRNts51hYykCl0w3M1HhDwlHCMQsPLfCpe2AN9GefsSMi6LaiwBWI45vZL43r/5Js3L0q9Z7ZYMf3Snfy6C2BVPq+E0KPFWpoflslf8oSM0Bqk4jer2yqSmcThq7wK7PbnDV9dvYCz2qtwm+U8usTnL313XuSLZjPYGmRlQSnizM13kQ4V4Ip5aGkHPT/nNi3IDCab+07TH7ziMFivNa5jiQR9GOGbQN9CX5BbQNwAGCe5DnB7QLeUVNrqIxRyN+p+5fjxkJjzFpUdnABw5xpXL7If23DDaJ/UsuMXKXlig29+WEf0GsFkqZndZE87jQn3rkxod+8yEXLZooLwlXpsmr+cc+sF1/tdzAn+fE/TTgGyEJ0lowxCVO8PY6BB5CeY+fcaoiS
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 08:32:43.3026
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d12288d8-eadb-4c27-a8c3-08de7448721a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10112
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71812-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 7F9DA194474
X-Rspamd-Action: no action

It appears that a !! became ! during a cleanup, resulting in inverted
logic when detecting if a host GICv5 implementation is capable of
virtualization.

Re-add the missing !, fixing the behaviour.

Fixes: 3227c3a89d65f ("irqchip/gic-v5: Check if impl is virt capable")
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5-irs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index e518e5dfede78..f3fce0b1e25d9 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -699,7 +699,7 @@ static int __init gicv5_irs_init(struct gicv5_irs_chip_=
data *irs_data)
 	 */
 	if (list_empty(&irs_nodes)) {
 		idr =3D irs_readl_relaxed(irs_data, GICV5_IRS_IDR0);
-		gicv5_global_data.virt_capable =3D !FIELD_GET(GICV5_IRS_IDR0_VIRT, idr);
+		gicv5_global_data.virt_capable =3D !!FIELD_GET(GICV5_IRS_IDR0_VIRT, idr)=
;
=20
 		idr =3D irs_readl_relaxed(irs_data, GICV5_IRS_IDR1);
 		irs_setup_pri_bits(idr);
--=20
2.34.1


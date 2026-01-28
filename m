Return-Path: <kvm+bounces-69374-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CJY0LadPemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69374-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:04:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 25D0EA76F2
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:04:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3C297303D2C9
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 052E836D4EC;
	Wed, 28 Jan 2026 18:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dlcorqMj";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dlcorqMj"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010063.outbound.protection.outlook.com [52.101.84.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD9736EAB6
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.63
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623358; cv=fail; b=D7iHBCMgsBKFdG6fwygqRQP+EYz1xpdtKyqoR+f2KW9Z3gIdb/AGlrtj4IAZJIOHOVLhwTGnnKiSP0VvNOAYsXEGdrqOPOlzPNwiBKkUQCzdHiK1HeYaUyE2dklcD3jq2vtN/E0kIw6mrLYoNV/P/Fcna7BvLacDTxixEylRwmg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623358; c=relaxed/simple;
	bh=jWWBGkig1wFWEVvqPbKb2pzh3vhNXyf+cZ8le2jLjqo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s2qHKvKGsdJK5Oli+FwZ6wz7G7xE4eUwQvQToiqa4Kx3Ejfp0dJeVzjDRVdCSKbbKwXj7IG1Jmv4Feyfr/hY4RdYdDMY1IUN8+sALp7g7FtmxWGe8eKQlWx/sr/qSwG7pUxOTJsMwYPhdtqKO2ocP+W9+rFRGHBMeHhijgDUmEQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dlcorqMj; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dlcorqMj; arc=fail smtp.client-ip=52.101.84.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dsb+ai5wHpnbw8f/+QBDJLc3TrfD7YRDHtN335asEB/3DDXTZ9gVbc9WzKgxsmwh86X3gKnyGCotB7uDlxQpiEKu8cSan36hfrn33BhsEJ4kDS4dJpG9sLlY5vuu5SmijHkizW4iV89uJOK4Sf+zGH51VzqfvMYY+8ap0HFklAxNo/g4C8cr7V8A8fX8poeO+SvMbc8jFhclSeOq7gsI8b+tQbaJcdDirjtc+dxZx5WYWfdGHgK3sQ7yS2BFFbgxetFGNEtLmLQBKhI79tmi6xdqhUeNIUddA/DsiZSozQNoTTb6/7AwNQimGzvz6gm0qOANRFnT+ZTNCDlQnnYtgQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+Fq1jmYIwKeRFAhf4JJxDYOkeJGPW8HcW3zmo3xBBI=;
 b=sNhMxiGdwU2zXe81OpL7GQeHwxrQplLDdhPorI42xn8UFbZcrZOGusY05pV/sm5gQ/WB5YjjYZH6WkPpUTBZiY7UObFpyYkIxI/CZdyXDbOe6Dc4w2khk6XWsfKhKkevk7IFZJDDE9k4goQ7gEn86//Zf4H+k5laMJIxrT1GVoru4LU1j/TixyEDKH98jOcwnV66DfD+CZ+568uiPQ278Uf9wvYV/yr3n7i85QJ5UG3gr1LywnVYG+1tSGzMAH14jvUwWOu4Zh+cI+CjbFBUHuZCMz8kAcVmNxUfq390o5f/+KlglNAOFIQqb1QK2gce3ei6eaGVqa8Wauvjmcsv5w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+Fq1jmYIwKeRFAhf4JJxDYOkeJGPW8HcW3zmo3xBBI=;
 b=dlcorqMjjOnxK8ErX8hls2EvCnWlfJIEC9TP7GN4aaf0eWETyVFkVyqZnvcB2AiMxQUJ0oNKvuqets2XYviANM0YpbnxVE508up0SuSItYiFhNecLlDdp77wnqiVOflv94xrXrDYDhE+DsOc8q6BO6xHmn50FpEkw9H9C3zjs2o=
Received: from DU7PR01CA0017.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::19) by GV1PR08MB8257.eurprd08.prod.outlook.com
 (2603:10a6:150:8b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:02:27 +0000
Received: from DB5PEPF00014B96.eurprd02.prod.outlook.com
 (2603:10a6:10:50f:cafe::aa) by DU7PR01CA0017.outlook.office365.com
 (2603:10a6:10:50f::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:03:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B96.mail.protection.outlook.com (10.167.8.234) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:02:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZTAKaSfaRu05ExvnmnJQhA989QzzLdQJiKaxtoz6n3aDZWMDGO1pTTafRFRkzAxWxfLgSsSaAcaaN1ZYdV0K2/sXgjdozzg+gJyIVEPw96EwrknK8mzb+xTzx6wvyxf90v+yDZv8KaIZNOwK0Mmk1L5C5FE+TqirNnD1QCDMlyUhKuRa9xGWuyRhnqRMqfoaeU2miW6Tmuy0R9UaaW4Awdb63e7yI+sAJS/SZVsYQ+NxuuEy4QONWStOGDKxij+v6A+G8n82BL4RFAi4rp/umLmQwMxUbYBzqmhWoNShFm+qLkQ35pSFR4qK0oCOi5qgqucNL+F3w4f47bhsEsoQYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+Fq1jmYIwKeRFAhf4JJxDYOkeJGPW8HcW3zmo3xBBI=;
 b=n2E11lkd5eVYXT1LWjNSRW0g5HatMPQ1grEWBhNNqFpnurq3Y6KNb9MdrAq9HnjU6trLmSaCD31eeFz3Xr8/t9qFyvQ5J+HoHI+L9jTNp08O6CLYSm816o1Zzarlw5YcW8GW+5W5mBujbX2dqHE6ZAwEZvxEOFyqakOE98+Py5BRIFaFax5e7Iv4OUvqD/K7uYR6ovjtGFoO4bUGlQh2OmNFgnIVprLmVET3K8M/BpnIGMRKpOIh5C1JZrICKzS4HDdICCrs0UilayQPOG+dFL6mDKSC/uAzeVABoAevuJPmLLkTvRqvJc0A9F7KOe2FLK5lNy4I8H1sMl6oCU+DXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+Fq1jmYIwKeRFAhf4JJxDYOkeJGPW8HcW3zmo3xBBI=;
 b=dlcorqMjjOnxK8ErX8hls2EvCnWlfJIEC9TP7GN4aaf0eWETyVFkVyqZnvcB2AiMxQUJ0oNKvuqets2XYviANM0YpbnxVE508up0SuSItYiFhNecLlDdp77wnqiVOflv94xrXrDYDhE+DsOc8q6BO6xHmn50FpEkw9H9C3zjs2o=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB10537.eurprd08.prod.outlook.com (2603:10a6:800:204::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:01:23 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:01:23 +0000
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
Subject: [PATCH v4 08/36] KVM: arm64: gic: Introduce interrupt type helpers
Thread-Topic: [PATCH v4 08/36] KVM: arm64: gic: Introduce interrupt type
 helpers
Thread-Index: AQHckIAdTRQXVoJxu02tlYLoY1Oh4g==
Date: Wed, 28 Jan 2026 18:01:23 +0000
Message-ID: <20260128175919.3828384-9-sascha.bischoff@arm.com>
References: <20260128175919.3828384-1-sascha.bischoff@arm.com>
In-Reply-To: <20260128175919.3828384-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|VI0PR08MB10537:EE_|DB5PEPF00014B96:EE_|GV1PR08MB8257:EE_
X-MS-Office365-Filtering-Correlation-Id: cfdc282a-2c45-4a2d-5d7e-08de5e976573
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?te4FD0vUO7zgs8sgxFWAGfsYq6epRx+EwmpWIjqLjUbWNDrr99w4Ek2+KN?=
 =?iso-8859-1?Q?fuB0O2+dYFh87KQB4MSFuW551LXOETTL1GW5XXjuZE184tgrX481lKn8I4?=
 =?iso-8859-1?Q?iK0HLiZdgPKhf7+EAzA4kVbJemnlt2N6vpta1p3Xrs4ndGYGCkZAbflX1H?=
 =?iso-8859-1?Q?/m8JYMYFONQRqwDtOBXHQgky5fERAgKHpWR3J7YJMIPi3Q4YBibVxd3aP2?=
 =?iso-8859-1?Q?fzN4OyS3dtt3gyW3sux5hZLb5iAdcGMhW1+eVjnczyHsTJJ9du95GFMfd6?=
 =?iso-8859-1?Q?zPKWSG5uB3IIJNl1NAZYpiZTZ4iTm+hR/KfQFddSQac1sVet2qARsZ+Tjo?=
 =?iso-8859-1?Q?93arNg5wWQ4hma5JB4H211mhyaCiGFlXFy/M89kfuSh6huFfB5GWt/nS89?=
 =?iso-8859-1?Q?8FY/0NzmVMidDBdKxhAzdmNoe0yLa1oUrPi92+kSnKRnR5K4ImyZCKIOwJ?=
 =?iso-8859-1?Q?jVdw/j3H9+Os9Uuc645yPVFZ/rjQLoyEgW4VGujl8iNVMXbJlOtEdVBB+9?=
 =?iso-8859-1?Q?opBRYTHVXR2/pdL+WKaS+I91sVsurYZmhr3C/p3JZ0jhGy2KFEmVqJ1CnK?=
 =?iso-8859-1?Q?WqTeowjlDisr92If52euF0Sf44N4SaFEsdn+MlbwQ28Pu6H6qV4xijjM6V?=
 =?iso-8859-1?Q?thl2o0Fvo3beS2lMUSS5L9w/K+fPS/4PAWiFgGSYLQ4+bs2NrEr0fRENrs?=
 =?iso-8859-1?Q?yMizHGncRsfpsAhIUZh5qM56yjQi2XFsARukfGz+7nwfL5Csw8JOKmLH07?=
 =?iso-8859-1?Q?oQ8CqUKhsXo3AUZFZrdh4ArFE7C5sReF/YSLenDTSMLxkAAbjqk4N2glo3?=
 =?iso-8859-1?Q?tyTKuMFusKwgG72550KWE+VV3Qcu9DX5yXIZtyjDRDri1/27S8RtwTyuCT?=
 =?iso-8859-1?Q?YkdiahjWYKTSkfMZLBYPqSkGK7WX10JNqaHk/fmNjYh5oK5hEwtxnoCSdM?=
 =?iso-8859-1?Q?2iYmxgL6RNAnZx/NIVfW3/vbo4hMvcx9WyLuC25RU0HXnvSooKj2ETX1xa?=
 =?iso-8859-1?Q?YUPn26tRUTvGUtn0Oh1OK6a+aJ5CDOP+WG7NbUJErezVVZYwJEo4xzlBC8?=
 =?iso-8859-1?Q?bEk7I7pZbi47PdQp5drG2p7sY9rFVSE5lrSaOy032IFbD5hdrcRoXBLOlA?=
 =?iso-8859-1?Q?y9QPCbWceaJkrAwa3AMLgIvrxDS4q7rhzG3CHNiXtHChopFXazLJ1YElUZ?=
 =?iso-8859-1?Q?8j4LV/GkWwZrrL5xGKgnTUDEuUjDiJ3i2J0r2IE5poj1ihXHdoAhc+8wlS?=
 =?iso-8859-1?Q?d4Uv13bp9j5W+3N9MGFrjvYnTKzm/7lcyKQ3fB7hvwkDaUPyC4SRNVGI2Q?=
 =?iso-8859-1?Q?Jotlytev/8aq1ApISUCZJTvRVZx5M4O77SrZ84L4nlCrPTfhvbz24QBXsP?=
 =?iso-8859-1?Q?oKy/UgqLUYNNddDSdjt2AVVfo3j9xwdl2UNZk/N3x6HJHVpfy1tGMJkZGh?=
 =?iso-8859-1?Q?uuWtxu1dGbefjnrWzqSOkKnQm9+dCC8JcgPJNK7jyk7Hdw+TIe0HH9xyHc?=
 =?iso-8859-1?Q?vbB+YQRpm3Ui/uNPM1l77DSlUhALhaAUxJdHFqxkQJRZGXs1oPAK0mnbte?=
 =?iso-8859-1?Q?pQUFw13tcR5UWZLliEgmuiSdVhTyQZMO4aDBZsnOTm4bLvKYcT7J28Hd/5?=
 =?iso-8859-1?Q?j2Q5Q+uGeiNSa2fGxI8s0wR3XWICFFVUcms47VhLKeT8woXCHy+9OET6lJ?=
 =?iso-8859-1?Q?wwxadsirDTksTc6M9f8=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10537
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B96.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8ccbc978-d18d-4f4a-e1dd-08de5e973fb3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|35042699022|82310400026|14060799003|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?/6Lr+ZGMM5oLhcZ529TRTtLgrFrWPCi1nizlBjv6TdGFo20yIodbpPAYtZ?=
 =?iso-8859-1?Q?jwF4NC3XKYh69NQJKNOCksLIhCZqZTwzlb06a8rNuM2Quc5ZFKAERzt8BO?=
 =?iso-8859-1?Q?7hSpiA3BTTEg17NMnpzRerKkOtV2i8zlBw+CDcTPu9kvu+sWAbvxZ5BNPL?=
 =?iso-8859-1?Q?vRvlnubvJ9Ph0JOdv3kdvzedQSWYBW9wMq6zYiwUg5NRojuUZJ/qGjK5M0?=
 =?iso-8859-1?Q?9WIV79MOhSo8pmvJ6pTCJ9zDJ83QUMtpvMFZ0P58knlgQ9y0RYE2g5w5K5?=
 =?iso-8859-1?Q?G18hL8uUCunzkAp78yQmo8XbosZvIH5yUXEDhjUek3BL/T5Rl7dLCSbSMK?=
 =?iso-8859-1?Q?RGQGyo4gJcztE2DcgOf1SKR6Ss1AnYr5urcBvemqaKsvowkfDGgFZpp0il?=
 =?iso-8859-1?Q?4qGoMhLxiY+YbTLRdb5mQDqFthGgxUBgHqbPVtkmpMnxHf8aQvTzGb6Nl6?=
 =?iso-8859-1?Q?z/qbcnkEXqyqlCLK3Y+0kam3eSPWgInboN9ZQN+ea/3n+n6SzYWJW6nJd/?=
 =?iso-8859-1?Q?s0zN8CSke68Jtgn4a+tEquoBIpF/TVBtCEm9+4LXq7ke4OHPRT5vwH2Sjt?=
 =?iso-8859-1?Q?nFMlaCRnmaMw+atAqGQxNe0ylVLGTGhXKGmCQH54yBwPnVeb1rmNmE8RAY?=
 =?iso-8859-1?Q?peyz9cFgbTfxrz2qxmjusi54cr1m330DkxWK+D1zjKYvuslCzyZFs6Ccix?=
 =?iso-8859-1?Q?CTLKvJLnH6rWH7slahc1OgkP63mv5CG4EcOjGNMiCuNPrF52Sc7trEoyJZ?=
 =?iso-8859-1?Q?HqpYW5wOw62jxWGIV2OtYIHuekE0jvIakt6H9uUMw1n9kDig1bQwS+VbJT?=
 =?iso-8859-1?Q?Pc1gccM6H7ahjcwBLHzHyZXd98nq+cnkpOaOUc44mbQi6UGqt2LAvGJSKz?=
 =?iso-8859-1?Q?w6GQ6Lfv2wXAGTSnhvFdbkbdqC1FxRFuCukYtUewnhMir++VD6+xRSGSR6?=
 =?iso-8859-1?Q?BpM5X8Rvj33adfBkMTy3Av3b5KAmAlGYTb3bNb/irSl7tvmcDgtn77BuCy?=
 =?iso-8859-1?Q?DxuDzjDpJHXUcjQXM7SWsI6uTKxlkWhpp4hu+DSm7mZ2GODch5ngQqdivQ?=
 =?iso-8859-1?Q?qcPZPbta/TKYFCMtnmGVBu+6Ibfcqk3yrAU/7suL853kCoXPRnWWpxffYj?=
 =?iso-8859-1?Q?UF0MxO6xvahXTksoN+mi6BeWFidPqCW1akN3gszFqyW9R7Mx7K+HV0KqKO?=
 =?iso-8859-1?Q?7xAt6ZR0Fg5u3XHBhsR/kEb69CeK+JluC1KwGeL7iL/cax9hMtCXEMQvmA?=
 =?iso-8859-1?Q?IRupjhHLD50Fuu41WEFq/mgV6DT2zUNwmApduwilylkCKn6RhepCzADFsE?=
 =?iso-8859-1?Q?ZLrN5OKPBEWf3URGlhAmFBpz0IZzoScOIgQV//AzLzi3wIDCBbq/F6TR3Z?=
 =?iso-8859-1?Q?vwGHoukWMv/W8Ecl9zbSEtcjU34BW0bFyr0cvz/LkTeYuNOGMJ7Q+Wg1pR?=
 =?iso-8859-1?Q?NePPdBZIRh1ZLQVb8xxaaU2K8jGtyHbSqflHq/h3WbPRRw3T0XWoT/7wJn?=
 =?iso-8859-1?Q?Lm+CJLQX94GjDs/ofucZs6wnfr8ggCd9cya0bqNYmfvZxMhxmsecnNRSIj?=
 =?iso-8859-1?Q?bePJ3LBFLDG3YYiVf8kx9U3TWynKX2Oxz/pmTOeHS//708JsoV3zbVk0dV?=
 =?iso-8859-1?Q?ECl+pzua42mWUOxzoq4MICz6Uba8yTqnfMFrhCnL7uRzdWCoAC6yZqGrwK?=
 =?iso-8859-1?Q?MhvvMDkvX5lYIbPYvRy3RbMXXamT+Aal+Puk65vBk+xxw0Uztvf4vuTTqh?=
 =?iso-8859-1?Q?R1zA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(35042699022)(82310400026)(14060799003)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:02:26.7111
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfdc282a-2c45-4a2d-5d7e-08de5e976573
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B96.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8257
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
	TAGGED_FROM(0.00)[bounces-69374-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:email,arm.com:email,arm.com:dkim,arm.com:mid];
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
X-Rspamd-Queue-Id: 25D0EA76F2
X-Rspamd-Action: no action

GICv5 has moved from using interrupt ranges for different interrupt
types to using some of the upper bits of the interrupt ID to denote
the interrupt type. This is not compatible with older GICs (which rely
on ranges of interrupts to determine the type), and hence a set of
helpers is introduced. These helpers take a struct kvm*, and use the
vgic model to determine how to interpret the interrupt ID.

Helpers are introduced for PPIs, SPIs, and LPIs. Additionally, a
helper is introduced to determine if an interrupt is private - SGIs
and PPIs for older GICs, and PPIs only for GICv5.

The helpers are plumbed into the core vgic code, as well as the Arch
Timer and PMU code.

There should be no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/arch_timer.c           |  2 +-
 arch/arm64/kvm/pmu-emul.c             |  7 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  2 +-
 arch/arm64/kvm/vgic/vgic.c            | 14 ++--
 include/kvm/arm_vgic.h                | 92 +++++++++++++++++++++++++--
 5 files changed, 100 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 99a07972068d..6f033f664421 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1598,7 +1598,7 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, str=
uct kvm_device_attr *attr)
 	if (get_user(irq, uaddr))
 		return -EFAULT;
=20
-	if (!(irq_is_ppi(irq)))
+	if (!(irq_is_ppi(vcpu->kvm, irq)))
 		return -EINVAL;
=20
 	mutex_lock(&vcpu->kvm->arch.config_lock);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b03dbda7f1ab..afc838ea2503 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -939,7 +939,8 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 		 * number against the dimensions of the vgic and make sure
 		 * it's valid.
 		 */
-		if (!irq_is_ppi(irq) && !vgic_valid_spi(vcpu->kvm, irq))
+		if (!irq_is_ppi(vcpu->kvm, irq) &&
+		    !vgic_valid_spi(vcpu->kvm, irq))
 			return -EINVAL;
 	} else if (kvm_arm_pmu_irq_initialized(vcpu)) {
 		   return -EINVAL;
@@ -991,7 +992,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			continue;
=20
-		if (irq_is_ppi(irq)) {
+		if (irq_is_ppi(vcpu->kvm, irq)) {
 			if (vcpu->arch.pmu.irq_num !=3D irq)
 				return false;
 		} else {
@@ -1142,7 +1143,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, st=
ruct kvm_device_attr *attr)
 			return -EFAULT;
=20
 		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
-		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
+		if (!(irq_is_ppi(vcpu->kvm, irq) || irq_is_spi(vcpu->kvm, irq)))
 			return -EINVAL;
=20
 		if (!pmu_irq_is_valid(kvm, irq))
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 3d1a776b716d..b12ba99a423e 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -639,7 +639,7 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		if (vgic_initialized(dev->kvm))
 			return -EBUSY;
=20
-		if (!irq_is_ppi(val))
+		if (!irq_is_ppi(dev->kvm, val))
 			return -EINVAL;
=20
 		dev->kvm->arch.vgic.mi_intid =3D val;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 430aa98888fd..2c0e8803342e 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -94,7 +94,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 	}
=20
 	/* LPIs */
-	if (intid >=3D VGIC_MIN_LPI)
+	if (irq_is_lpi(kvm, intid))
 		return vgic_get_lpi(kvm, intid);
=20
 	return NULL;
@@ -123,7 +123,7 @@ static void vgic_release_lpi_locked(struct vgic_dist *d=
ist, struct vgic_irq *irq
=20
 static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *=
irq)
 {
-	if (irq->intid < VGIC_MIN_LPI)
+	if (!irq_is_lpi(kvm, irq->intid))
 		return false;
=20
 	return refcount_dec_and_test(&irq->refcount);
@@ -148,7 +148,7 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq=
)
 	 * Acquire/release it early on lockdep kernels to make locking issues
 	 * in rare release paths a bit more obvious.
 	 */
-	if (IS_ENABLED(CONFIG_LOCKDEP) && irq->intid >=3D VGIC_MIN_LPI) {
+	if (IS_ENABLED(CONFIG_LOCKDEP) && irq_is_lpi(kvm, irq->intid)) {
 		guard(spinlock_irqsave)(&dist->lpi_xa.xa_lock);
 	}
=20
@@ -186,7 +186,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
=20
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
-		if (irq->intid >=3D VGIC_MIN_LPI) {
+		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
 			raw_spin_lock(&irq->irq_lock);
 			list_del(&irq->ap_list);
 			irq->vcpu =3D NULL;
@@ -521,12 +521,12 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_v=
cpu *vcpu,
 	if (ret)
 		return ret;
=20
-	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
+	if (!vcpu && irq_is_private(kvm, intid))
 		return -EINVAL;
=20
 	trace_vgic_update_irq_pending(vcpu ? vcpu->vcpu_idx : 0, intid, level);
=20
-	if (intid < VGIC_NR_PRIVATE_IRQS)
+	if (irq_is_private(kvm, intid))
 		irq =3D vgic_get_vcpu_irq(vcpu, intid);
 	else
 		irq =3D vgic_get_irq(kvm, intid);
@@ -685,7 +685,7 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned =
int intid, void *owner)
 		return -EAGAIN;
=20
 	/* SGIs and LPIs cannot be wired up to any device */
-	if (!irq_is_ppi(intid) && !vgic_valid_spi(vcpu->kvm, intid))
+	if (!irq_is_ppi(vcpu->kvm, intid) && !vgic_valid_spi(vcpu->kvm, intid))
 		return -EINVAL;
=20
 	irq =3D vgic_get_vcpu_irq(vcpu, intid);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b261fb3968d0..67dac9bcc7b0 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -19,6 +19,7 @@
 #include <linux/jump_label.h>
=20
 #include <linux/irqchip/arm-gic-v4.h>
+#include <linux/irqchip/arm-gic-v5.h>
=20
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
@@ -31,9 +32,78 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
=20
-#define irq_is_ppi(irq) ((irq) >=3D VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVAT=
E_IRQS)
-#define irq_is_spi(irq) ((irq) >=3D VGIC_NR_PRIVATE_IRQS && \
-			 (irq) <=3D VGIC_MAX_SPI)
+#define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
+
+#define __irq_is_sgi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D false;					\
+			break;						\
+		default:						\
+			__ret  =3D (i) < VGIC_NR_SGIS;			\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_ppi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_PPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) >=3D VGIC_NR_SGIS;			\
+			__ret &=3D (i) < VGIC_NR_PRIVATE_IRQS;		\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_spi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_SPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) <=3D VGIC_MAX_SPI;			\
+			__ret &=3D (i) >=3D VGIC_NR_PRIVATE_IRQS;		\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_lpi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_LPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) >=3D 8192;				\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define irq_is_sgi(k, i) __irq_is_sgi((k)->arch.vgic.vgic_model, i)
+#define irq_is_ppi(k, i) __irq_is_ppi((k)->arch.vgic.vgic_model, i)
+#define irq_is_spi(k, i) __irq_is_spi((k)->arch.vgic.vgic_model, i)
+#define irq_is_lpi(k, i) __irq_is_lpi((k)->arch.vgic.vgic_model, i)
+
+#define irq_is_private(k, i) (irq_is_ppi(k, i) || irq_is_sgi(k, i))
+
+#define vgic_is_v5(k) ((k)->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_V=
GIC_V5)
=20
 enum vgic_type {
 	VGIC_V2,		/* Good ol' GICv2 */
@@ -418,8 +488,20 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
=20
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
-#define vgic_valid_spi(k, i)	(((i) >=3D VGIC_NR_PRIVATE_IRQS) && \
-			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
+#define vgic_valid_spi(k, i)						\
+	({								\
+		bool __ret =3D irq_is_spi(k, i);				\
+									\
+		switch ((k)->arch.vgic.vgic_model) {			\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret &=3D FIELD_GET(GICV5_HWIRQ_ID, i) < (k)->arch.vgic.nr_spis; \
+			break;						\
+		default:						\
+			__ret &=3D (i) < ((k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS); \
+		}							\
+									\
+		__ret;							\
+	})
=20
 bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
--=20
2.34.1


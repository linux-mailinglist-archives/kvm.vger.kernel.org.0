Return-Path: <kvm+bounces-72556-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OCReIoMhp2mMegAAu9opvQ
	(envelope-from <kvm+bounces-72556-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:59:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EBCEB1F4E1F
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:59:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A2F0F311470D
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 17:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1467A36C0CD;
	Tue,  3 Mar 2026 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OAJCyWFr";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OAJCyWFr"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012010.outbound.protection.outlook.com [52.101.66.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD6036EA87
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 17:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772560534; cv=fail; b=PAL8t06jLDcfDMS1HYCszCKkFJkfDMAtvV30SE4swjaoVweqjSAxAfPOTC+a2Sh4K3+EeVRUApVAqMwpdxLmMua6Xd8+atA0NcINC6OBNfx232iqpQ/5K1PYo6UK2a6wxgEXMJOErjQ/yrBFji3VMM+EwcOmHxvxItgXBZDAxq8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772560534; c=relaxed/simple;
	bh=0graFBEZ7rjTzscAv+8FI5KqjsoARkUnInyEFb5JS7A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BUZRaeDWDFU57XoqEqR8bLDa1ga/oApIa+c203HsE6A82SVO1HESaIIB5d+gI0LxkOmrlCpQAepx3cV3A6qm84sGJuKfyfwTMpA5PVIcVUUfu54AE59qbDwt8oZi0jLX+7IGow27Xb0Pgv5n/qulPVbjkKrzszHiucC/cGSeqDM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OAJCyWFr; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OAJCyWFr; arc=fail smtp.client-ip=52.101.66.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SdWTer6e1itWAOpm3aRrvg7/IlooWZiK73SRdwkNGG/Ruzy50SFOj69OqpoV/5i3of0cpRQ+9kqoMtW7YFg5tq+7TZIYyTy4QcG7Yavk8c0vHzOBYU2quVxmAMoNY+G+WsqLuOQjv9TgigMf2P7TBpFtkdrsZBs2FJUgOnh/r991HjvakRFPfr3PAmnP7XNJwLU9cWMtTz9jxdWETIwwQOXBc7bJ+JR7K05w9QDQV5qPyxAB6rJk8G6udW4DhdTzKQmu97pks2QM/BFmv9qKUrB0tQRSGpprnJj8Awq4J796BNlvKSflATOAjCBOSs5RRlm6eWilRO55N9Rx+DnS5A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0graFBEZ7rjTzscAv+8FI5KqjsoARkUnInyEFb5JS7A=;
 b=mWw5QIC15o3kL+WyQYUklVJ+f+eOifhwqJ9YDKEvYwTHreI+6WGR9r3BFGEpl6ucljFjRiRZeEuuxIpfG8OS1FT0HncOPF6ElKfnRv0m2mhNZqN3VPYLfN+iVo1HxeQuAePflUuACfxE6JePNjzibm446YXZA/nRrOw2f4bMvNUVJZ7nMcJHTzrjnucr0uB0EM7n0lnKcmE1H1bHjlYBFU5Q1O12LpzD6g0ygFMyQ0CplhWA4HkBQ9T670Yon7E8+ZsiQypz17LMz5soQu0dk0MVxtsJNynecuDHQkutSrzu21jUWkHVASs42cfFBTBNSLrczlijBmSrjijep63LLQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0graFBEZ7rjTzscAv+8FI5KqjsoARkUnInyEFb5JS7A=;
 b=OAJCyWFrV5q7rc1bAP2c5r6boa2lgNXBAi9777j4MzbMPxZPIXP4It6ZWfsG4KcdEOpZlDXRsPOjJHn5lsL5408Tilpp7sTZ1oXJYbDK3NFHuyeKE8XwpMxN28nxvFXZvsQqIZHRM741Dy6Dk4m+1ITIELeYPQxMzrb2Q0SudQw=
Received: from DB9PR01CA0024.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::29) by AS8PR08MB8489.eurprd08.prod.outlook.com
 (2603:10a6:20b:568::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 17:55:25 +0000
Received: from DB1PEPF0003922F.eurprd03.prod.outlook.com
 (2603:10a6:10:1d8:cafe::1f) by DB9PR01CA0024.outlook.office365.com
 (2603:10a6:10:1d8::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Tue,
 3 Mar 2026 17:55:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922F.mail.protection.outlook.com (10.167.8.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Tue, 3 Mar 2026 17:55:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IzLG7Afp4V7LVYl/fivGwYe2DdDdWZtJYLV/ceuoRuXt2lNYzpipT+NpREBxtvHRx2NDIDNAYd5atDuktHbsOo8wHpvwkG18V54sbDUeQpvX0F1ft0If5NP5bomVcOt0kIs8s4h585PMH7DGEqQqHvZtISpA+Mh5Z7Zk/VNhO/O1M9e5jrgULOmt8CxbhzCxeMfSxo/TC8Ei4/Kgn3bsiM0/T97ETLsqBX8b5diGV50Q6E+YurEbpFTx9UT4RRw7Cmn/KLuIvHNnd0t1Y6vWNe0xl3ZYL1zPm7g1oM0RshUkCZLAc8mNNmIXIrYXbwiJmpOdP9MZoyl+1tDePtKxzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0graFBEZ7rjTzscAv+8FI5KqjsoARkUnInyEFb5JS7A=;
 b=kA7mcjtJkkoPQJH4EJ8QfApBww1svVauwXO9ZlXa2u8snRfEq5R/mDdQ9EEPSrxijtOBZbBCaEB5wEidxCKzWhCswlTRrACEz4Ha4PHAlPSXB5ZsXIjWf4jil+vM+1BGoJZYwch4X6pogw0zil3/kK2bjUCH/h7xHKjs1eHf+FQdY5gWeLU8BldETo8oW3/NpsjhMMiTHgcnc8t2QxpaE2PRSf8ar0HSiatk9qYzJn7Ptt+p4m33nfcwFZt5tX6EVP+ewawraAeOCae3Tkpi+LnuU+CDi8Ewu2Edrw+XqSGt6pMwQ9CaLJ3iqae24NaHaut5EU7bpD7EftSPrYfZRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0graFBEZ7rjTzscAv+8FI5KqjsoARkUnInyEFb5JS7A=;
 b=OAJCyWFrV5q7rc1bAP2c5r6boa2lgNXBAi9777j4MzbMPxZPIXP4It6ZWfsG4KcdEOpZlDXRsPOjJHn5lsL5408Tilpp7sTZ1oXJYbDK3NFHuyeKE8XwpMxN28nxvFXZvsQqIZHRM741Dy6Dk4m+1ITIELeYPQxMzrb2Q0SudQw=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by VE1PR08MB5823.eurprd08.prod.outlook.com (2603:10a6:800:1a5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 17:54:21 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 17:54:21 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH v5 12/36] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Topic: [PATCH v5 12/36] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Index: AQHcpzjB0snwpfkad0mq/B0b1GJ7YrWc/9wAgAAfOAA=
Date: Tue, 3 Mar 2026 17:54:20 +0000
Message-ID: <78c5516ee8b3a045d1e15c659c59f8734c467337.camel@arm.com>
References: <20260226155515.1164292-1-sascha.bischoff@arm.com>
	 <20260226155515.1164292-13-sascha.bischoff@arm.com>
	 <868qc89a03.wl-maz@kernel.org>
In-Reply-To: <868qc89a03.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DBAPR08MB5687:EE_|VE1PR08MB5823:EE_|DB1PEPF0003922F:EE_|AS8PR08MB8489:EE_
X-MS-Office365-Filtering-Correlation-Id: d0efab9d-c243-4c93-e00e-08de794e0c62
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 Zh9LhTtY91EkzzpTdESG54GCB8VAa/CACmx1hmdeNk9Ivo/od3i+khXCcmjNF1V0mWTuuiwhdA53CTIZhcX+xiJEgvbD1wowsNE1nW2/wQykMalY0WRvOOSwwwyivO2Q8pXwW3WBDZ3miqcjhHNcJLJD0JCH2xQlFT6dsCkWxdkwZ61rBPjZqcU9qKwHvd9n0yw0VoL+RrXqPGUQTlJUQYA6dTAvx7peNRHehyRZrzGXffzgEfmcmhuEb7/vVsZqA5lwtb/o0Q8UKGp6aOu0T9mgLFSTXW39oGQoCcXU5OjJP9X9rKamLDgBrYOxBJ7eUkWQPstpet3mJ7vbP0J09jvTnajdUcKLUMEf6zbG65NLLXoS5y6pn7MM+koFcEL4JSjvq0AaEtEkOJpb4rzItePQvry/os85d/cOd/lpXrbn3Hi32qUhPuut89wZBEbTxovVr+qP7hf66GmZPvUlfCuoDpkgnp6xkjPQ89pFRjWlCGMQVuaHP9vpjjTZ3/DiBkAvbOOMbbPbKu5g57RnUZ2U8zeLMjwk25FyyIzGVv1qN3FsPNFXm1QyoqwyXq0hB/X1UVkn/cdP7W5kEetc15/l5HNaq89ZuC0ZtN/UUj6dHZOleYnnsA/tV+rADSPQA1r4nURMxq102xeDsZknSywRpeZrbMwywEeogWYzPKHxYqRdUcp9z/UPykB2+hiSqvS0cYzCmaVm7HRScuq/38GDc1riwWEXnMsxnQhzhifkpA41hzI1iagUioWrKlF2BGRS12tzE2I4+60Lap3UqBuobsTpIIImlgq3aEfLNzE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <50285F5A80BB034EB2CEF263429FA7DC@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 f2fc7cID7Y/tcTppuuXt5LEpM90fx5gTpKhVcKxyVmDNTk39eZYPlITJUVJnljgcixcdBtukwskoXYE3PYRy0R6ZFdzbDWZ9+8UDS08xd9RZzV25vWS6UWFehPa+ETDqv0TP4s30yeNHQvptm9r3Jc8p3ZRZRfGB0YY9Pw/RdvkCL/JNOog58EGrCBWWjOL6iDl3kFVGD04kP+Y0fb6DoQFMpx63eGgDVD2L0xBVFXupPHaVYlSeR3f7+eNxn0N64uPuBvttFGyQjvrRqz524LZhNjU5haMsAUXa1ANmvHT9T2uCJPKTkjP9SnA6FzGJVIwj3OkkmmI4y5YPCoDW8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5823
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7aec3a03-5e00-4edf-2cb2-08de794de5fb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|35042699022|14060799003|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	PYZiGMFrBJ8FhlWqZXXY8nCe7ssOxECIler5DVQroefVDBjsc53zB1p2CVSc/aR5u0RTrWFIq3cNCBpujkwIJ7dkNJwbJQyCXbmU8h/sbUMx1WomP6sfvhgDrftucjCSkqpPsHEClGDJdSnW049HKa4/vIOkknvJSQiadpDuT8LEDVN6NQYLRBSKWh06ikV2lzxZrjxlngVIxmlJCGPMxf0r9nZfafndaagCzzBCBJaPIIB5MCP//6t/GgxUnknhi9db4SgL5gYmMmR4qMl84W7tZduWSUd5rLE0shaocBGJX7gqRNRg5QI8cy2a/Jw2xkK/grEJfufhEJDhzzcTz3PlLf/2iUECSoZHixJLj5TxGWbHZm0W7KR+V4pv5BAtQ1S4/G6Jaw8pO3NP/2Lnog4cYhyqkASCKGOF60LEAximE/4odz1W4v6oVMMr/Na5Qny2GNVDN33U7zWbS3Kg21IsyVMK8SWOrpP4lMlgUWFtKG6jKuktLilG90tp4kmUNm6AIssoKTiPkEkOZKcZ4v0vQmJE/rOBum1kkeBxrmiHeSdaXZeufw7EY8ul7KBdimObiYtGLV5bD2moGoSgPytfZvFjqxBdQv5OGoVCoBsJKKeDGgK+ckEJbbPW0CaR/rlMTg7vTyv2Avf1A9WtAQNb/CCUI1nvBTQPf00LdqPwy5FzkGgX5ljPeN0F0peLcskJxzvapGpHT/0mhaqseP51de3x8+zL/td36PG5ywyi12ET9bQbnuSWvXQOJzCdh9G2n/S3rX7smoLqcsWMQOJhCzjLHIsw6iJRr77DY3hlhXuK3VFv+/UOwpn7WhB50DFtBqEdRfCMLGq0K0zjtQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(35042699022)(14060799003)(82310400026)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	L+qBfxgtH/chxjWYs81Stv8dESRCApWCBB5xLAuUBLh5e42hjSOvX2bsHutSvYcPZGS5q85JsuViGxeCTkugUgF1YyTPyVWsLPt0Ys3lg/fInzm3WE91VccZUBOFjE+VfzyQ52ej4Jz4wwoNOQ4DvENupSCOsejxyJ9e4XoR5teORXimhpkrEMANPIxGMzbtvdKs4WwcWPGEbCdAvySGUl2J9rOKzIsZ70Ow1V9bnbqpIZuhEXp7qJWghQigmZK7JXHvAzGYuE6vnnD4X+l+eSIzy67SQPcE3xWCXltNWskzDpsTIUkM6GKqxabL1BUrHaDJJK4Bvn3BrGDv6kVoJQJgkxsWKNe0NGMTt0DS6QCsE/w+0UAmhPCkS3uPKxymqQOgvWKlJPw2qxZYoC6jXqPx8pOic7ok/aQLpsVYQNXxOI90mOVPOfJnTnynCXCw
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 17:55:25.4198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0efab9d-c243-4c93-e00e-08de794e0c62
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8489
X-Rspamd-Queue-Id: EBCEB1F4E1F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72556-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,arm.com:dkim,arm.com:email,arm.com:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[arm.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAzLTAzIGF0IDE2OjAyICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFRodSwgMjYgRmViIDIwMjYgMTU6NTg6MzEgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEdJQ3Y1IGRvZXNuJ3Qg
cHJvdmlkZSBhbiBJQ1ZfSUFGRklEUl9FTDEgb3IgSUNIX0lBRkZJRFJfRUwyIGZvcg0KPiA+IHBy
b3ZpZGluZyB0aGUgSUFGRklEIHRvIHRoZSBndWVzdC4gQSBndWVzdCBhY2Nlc3MgdG8gdGhlDQo+
ID4gSUNDX0lBRkZJRFJfRUwxIG11c3QgdGhlcmVmb3JlIGJlIHRyYXBwZWQgYW5kIGVtdWxhdGVk
IHRvIGF2b2lkIHRoZQ0KPiA+IGd1ZXN0IGFjY2Vzc2luZyB0aGUgaG9zdCdzIElDQ19JQUZGSURS
X0VMMS4NCj4gPiANCj4gPiBUaGUgdmlydHVhbCBJQUZGSUQgaXMgcHJvdmlkZWQgdG8gdGhlIGd1
ZXN0IHdoZW4gaXQgcmVhZHMNCj4gPiBJQ0NfSUFGRklEUl9FTDEgKHdoaWNoIGFsd2F5cyB0cmFw
cyBiYWNrIHRvIHRoZSBoeXBlcnZpc29yKS4gV3JpdGVzDQo+ID4gYXJlDQo+ID4gcmlnaHRseSBp
Z25vcmVkLiBLVk0gdHJlYXRzIHRoZSBHSUN2NSBWUEVJRCwgdGhlIHZpcnR1YWwgSUFGRklELA0K
PiA+IGFuZA0KPiA+IHRoZSB2Y3B1X2lkIGFzIHRoZSBzYW1lLCBhbmQgc28gdGhlIHZjcHVfaWQg
aXMgcmV0dXJuZWQuDQo+ID4gDQo+ID4gVGhlIHRyYXBwaW5nIGZvciB0aGUgSUNDX0lBRkZJRFJf
RUwxIGlzIGFsd2F5cyBlbmFibGVkIHdoZW4gaW4gYQ0KPiA+IGd1ZXN0DQo+ID4gY29udGV4dC4N
Cj4gPiANCj4gPiBDby1hdXRob3JlZC1ieTogVGltb3RoeSBIYXllcyA8dGltb3RoeS5oYXllc0Bh
cm0uY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFRpbW90aHkgSGF5ZXMgPHRpbW90aHkuaGF5ZXNA
YXJtLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNj
aG9mZkBhcm0uY29tPg0KPiA+IC0tLQ0KPiA+IMKgYXJjaC9hcm02NC9rdm0vY29uZmlnLmPCoMKg
wqAgfCAxMCArKysrKysrKystDQo+ID4gwqBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jwqAgfCAx
OSArKysrKysrKysrKysrKysrKysrDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuaCB8
wqAgNSArKysrKw0KPiA+IMKgMyBmaWxlcyBjaGFuZ2VkLCAzMyBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2NvbmZpZy5j
IGIvYXJjaC9hcm02NC9rdm0vY29uZmlnLmMNCj4gPiBpbmRleCBlNGVjMWJkYThkZmNiLi5iYWM1
ZjQ5ZmRiZGVmIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2NvbmZpZy5jDQo+ID4g
KysrIGIvYXJjaC9hcm02NC9rdm0vY29uZmlnLmMNCj4gPiBAQCAtMTY4NCw2ICsxNjg0LDE0IEBA
IHN0YXRpYyB2b2lkIF9fY29tcHV0ZV9oZGZnd3RyKHN0cnVjdA0KPiA+IGt2bV92Y3B1ICp2Y3B1
KQ0KPiA+IMKgCQkqdmNwdV9mZ3QodmNwdSwgSERGR1dUUl9FTDIpIHw9DQo+ID4gSERGR1dUUl9F
TDJfTURTQ1JfRUwxOw0KPiA+IMKgfQ0KPiA+IMKgDQo+ID4gK3N0YXRpYyB2b2lkIF9fY29tcHV0
ZV9pY2hfaGZncnRyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiArew0KPiA+ICsJX19jb21w
dXRlX2ZndCh2Y3B1LCBJQ0hfSEZHUlRSX0VMMik7DQo+ID4gKw0KPiA+ICsJLyogSUNDX0lBRkZJ
RFJfRUwxICphbHdheXMqIG5lZWRzIHRvIGJlIHRyYXBwZWQgd2hlbg0KPiA+IHJ1bm5pbmcgYSBn
dWVzdCAqLw0KPiA+ICsJKnZjcHVfZmd0KHZjcHUsIElDSF9IRkdSVFJfRUwyKSAmPQ0KPiA+IH5J
Q0hfSEZHUlRSX0VMMl9JQ0NfSUFGRklEUl9FTDE7DQo+ID4gK30NCj4gPiArDQo+ID4gwqB2b2lk
IGt2bV92Y3B1X2xvYWRfZmd0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiDCoHsNCj4gPiDC
oAlpZiAoIWNwdXNfaGF2ZV9maW5hbF9jYXAoQVJNNjRfSEFTX0ZHVCkpDQo+ID4gQEAgLTE3MDUs
NyArMTcxMyw3IEBAIHZvaWQga3ZtX3ZjcHVfbG9hZF9mZ3Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
KQ0KPiA+IMKgCX0NCj4gPiDCoA0KPiA+IMKgCWlmIChjcHVzX2hhdmVfZmluYWxfY2FwKEFSTTY0
X0hBU19HSUNWNV9DUFVJRikpIHsNCj4gPiAtCQlfX2NvbXB1dGVfZmd0KHZjcHUsIElDSF9IRkdS
VFJfRUwyKTsNCj4gPiArCQlfX2NvbXB1dGVfaWNoX2hmZ3J0cih2Y3B1KTsNCj4gPiDCoAkJX19j
b21wdXRlX2ZndCh2Y3B1LCBJQ0hfSEZHV1RSX0VMMik7DQo+ID4gwqAJCV9fY29tcHV0ZV9mZ3Qo
dmNwdSwgSUNIX0hGR0lUUl9FTDIpOw0KPiA+IMKgCX0NCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cm02NC9rdm0vc3lzX3JlZ3MuYyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMNCj4gPiBpbmRl
eCBiOGI4NmY1ZTFhZGMxLi4zODQ4MjRlODc1NjAzIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJt
NjQva3ZtL3N5c19yZWdzLmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jDQo+
ID4gQEAgLTY4MSw2ICs2ODEsMjQgQEAgc3RhdGljIGJvb2wgYWNjZXNzX2dpY19kaXIoc3RydWN0
IGt2bV92Y3B1DQo+ID4gKnZjcHUsDQo+ID4gwqAJcmV0dXJuIHRydWU7DQo+ID4gwqB9DQo+ID4g
wqANCj4gPiArc3RhdGljIGJvb2wgYWNjZXNzX2dpY3Y1X2lhZmZpZChzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIHN0cnVjdA0KPiA+IHN5c19yZWdfcGFyYW1zICpwLA0KPiA+ICsJCQkJY29uc3Qgc3Ry
dWN0IHN5c19yZWdfZGVzYyAqcikNCj4gPiArew0KPiA+ICsJaWYgKCFrdm1faGFzX2dpY3Y1KHZj
cHUtPmt2bSkpDQo+ID4gKwkJcmV0dXJuIHVuZGVmX2FjY2Vzcyh2Y3B1LCBwLCByKTsNCj4gDQo+
IERvIHdlIHJlYWxseSBuZWVkIHRoaXM/IElmIHRoZSBndWVzdCBkb2Vzbid0IGhhdmUgRkVBVF9H
Q0lFLCB0aGVuIHdlDQo+IHNob3VsZCBoYXZlIGFuIEZHVSBiaXQgc2V0IGZvciBhbnkgRkdUIGJp
dCB0aGF0IGNvbnRyb2wgYSBHQ0lFDQo+IHJlZ2lzdGVyLCBhbmQgdGhhdCByZWdpc3RlciBzaG91
bGQgVU5ERUYgYXQgdGhlIHBvaW50IG9mIHRyaWFnaW5nIHRoZQ0KPiB0cmFwLCBhbmQgbmV2ZXIg
cmVhY2ggdGhpcyBoYW5kbGVyLg0KPiANCj4gSWYgaXQgZG9lc24ndCwgd2UgaGF2ZSBiaWdnZXIg
cHJvYmxlbXMsIGFuZCB3ZSBzaG91bGQgYWRkcmVzcyB0aGVtLg0KDQpJJ3ZlIHRlc3RlZCB0aGlz
ICh1c2luZyB0aGUgbm8tdmdpYyB0ZXN0IGNvbWluZyBsYXRlciBpbiB0aGlzIHNlcmllcyksDQph
bmQgdGhpbmdzIGFyZSBub3QgYXMgZGlyZSBhcyB0aGV5IG1pZ2h0IGhhdmUgZmlyc3Qgc2VlbWVk
LiBXZSBkb24ndA0KaGF2ZSBpc3N1ZXMgd2l0aCB0aGUgRkdVcyBmcm9tIHdoYXQgSSBjYW4gdGVs
bCEgU29ycnkgZm9yIGNhdXNpbmcNCmNvbmNlcm4gdGhlcmUuDQoNCldlIGRvbid0IG5lZWQgdGhl
IGV4cGxpY2l0IHVuZGVmIGluIHRoZSBHSUN2NSBJQ0NfSUFGRklEX0VMMSwNCklDQ19JRFIwX0VM
MSwgb3IgSUNDX1BQSV9FTkFCTEVSeF9FTDEgdHJhcCBoYW5kbGVycywgc28gSSd2ZSBkcm9wcGVk
IGl0DQpmcm9tIHRob3NlIHRocmVlLiBUaGUgY29kZSB3YXMgc3RpbGwgaGFuZ2luZyBhcm91bmQg
ZnJvbSB0aGUgZWFybHkgZGF5cw0KKGJlZm9yZSBGRUFUX0dDSUUgd2FzIGhhbmRsZWQgaW4gdGhl
IEZHVSBjb2RlKSwgc28gaXQgd2FzIG5lZWRlZA0Kb3JpZ2luYWxseSwgYnV0IG5vIG1vcmUuDQoN
ClRoYW5rcywNClNhc2NoYQ0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiAJTS4NCj4gDQoNCg==


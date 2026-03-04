Return-Path: <kvm+bounces-72677-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qCBJB4kYqGmgnwAAu9opvQ
	(envelope-from <kvm+bounces-72677-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 12:33:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CF9721FF035
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 12:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C38C03015DBF
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 11:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C086935AC28;
	Wed,  4 Mar 2026 11:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QQfA/nxH";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QQfA/nxH"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013039.outbound.protection.outlook.com [40.107.159.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6BF2D9796
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 11:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772623998; cv=fail; b=uUi6DXRWm1p1OVwh2L9J/a7+s6RMIXE3fCOaBeElFS2cU8GCxBtc8Q31Mo/hQKoEMbB6XslqjiLCXgcmaSqpGwlCmZgDfFJF7n/LlSYb+/FMiAsCdxKU95JKKvi8dJqJl3DcUro2mPuFdfk9R9wFsEZfStVvw6qWQq+pNQCq13U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772623998; c=relaxed/simple;
	bh=mnBWtmIbFN5Dek+hWA+d9J8IOxoOukb4re7wA8q5dYo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ptFlZCEQ93/X2QGsIKEPmqB2xgZc0/QOlu4/OwpmJZRbprFViTd0fa2QBVx/jS2CcJTAozlyK205s306e6P5Pc4Iz731bSEFj8Z1UZ8aMFChq0aWYrUlUWhQ2VXJehgMjeaR/+I7ihbw0yb90OV87rA8ar42gjVafVT/JFykTy4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QQfA/nxH; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QQfA/nxH; arc=fail smtp.client-ip=40.107.159.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=t3L1uQ+mNwQXDVxjnBt/uaNVwoaTCt6Jw3fUG3hr4Opz+mQ14w2qWRbHfD+5KYOWl48W39T3XayCouQqAWF6IVNArz7rbIKCHUD7iRvU0s6+l6i4zxF7MjeZQfJG0p4GXFjmTyU5QkLEdd3b5PN9XeoOn655S0SggTJMEhVED6489EJqAhhiWFWoBbSLlhe7kFpSbXRhDC3iCeR3GFPW9wHw3vAssgAnfzCbQQOgz6vI9qbcpTRbnssljquYzT2yXQm55koMuh4/46/9AiWIcZlR6hpmh8QtaENE9Bs/mVrRsHvKrBiD39ujEHSC+GPLTVsuuMDM9nEjmbBcGoGL4Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnBWtmIbFN5Dek+hWA+d9J8IOxoOukb4re7wA8q5dYo=;
 b=wT95Xe53iDHar7Gy8aQ/NtYGQxo1UfnIVvX37qwRUwgGcirCQilfaxOD4pkZXB7K8CiQRmTgTC9HgPFkScNPFMcCpCH40MjU1+Y6yYXzvR6b2amy+AL+BwZ5Zp5OJX2bBAwHbgqb9lcydFUpQWqQySIIOrZwZ5icy0WxOwvMRwdpfdzGYt4DN5FYzWoC9v8B9MCK9izrMQRrKDAMof8Swo5rVzPVfwC42Jd/ICgG24Y8oZnfiEVfMx6exr2BovEnGLSo+EzgzxS5PKPpzQLgJMnMqxPEz/6imOgqccozrd+/fLfuRdbE9Qir5/bzle+y0vA7KTL+BipOqtCtptLorw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnBWtmIbFN5Dek+hWA+d9J8IOxoOukb4re7wA8q5dYo=;
 b=QQfA/nxHv+QaW62Xc8huP4hMV4wJ9ARzDhgk1AviwzY7IwVELzazex1sVtaU5otDh3sAP9Ypb/3lK3lJX1M4CjrwJjUop9UTO22qd+bAZ4qHp9/4vgvNq/JXHdlKpTjBtJdy6QZd0aL3z/UI/AxR1RwssY28FzOjOFegqeqkeyQ=
Received: from DUZPR01CA0166.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::9) by FRZPR08MB11024.eurprd08.prod.outlook.com
 (2603:10a6:d10:137::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 11:33:07 +0000
Received: from DU6PEPF0000B621.eurprd02.prod.outlook.com
 (2603:10a6:10:4b3:cafe::73) by DUZPR01CA0166.outlook.office365.com
 (2603:10a6:10:4b3::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.22 via Frontend Transport; Wed,
 4 Mar 2026 11:33:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B621.mail.protection.outlook.com (10.167.8.138) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.16
 via Frontend Transport; Wed, 4 Mar 2026 11:33:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u5tmvj4Rc8WJ1zoBKs6q5yYSiVFHvIyCqL/wnqhreyGLTKkOsw+bfgKxVQgIgupualknlLs2gWrXqUGzxkTh/ShCpeFGpCiC0AbaNyn1lsze0oYcHXHQ1Qqwoy/GKfV8OqNyDez4ng3OWiGGh28SjDr8D4W1P6tZNvYGrRL/ST6mXZVyN5B2ACtvc2O87C7pbjmlDNwEQPOsY4yAL7Cu9i2N8VTHagB0ex/8KHRMLnjry8EaP9w9dgwZpWvo5g3OvppmLYL+qVpp6CSgbjvcEv8mgaxhz9fbllYS/OGJ8SCmotFauDArxxxR5ej7KXQtrvWvGnUlVuGh/b4vYfretA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnBWtmIbFN5Dek+hWA+d9J8IOxoOukb4re7wA8q5dYo=;
 b=vLL3F8uHzn79wS6NSDdSNajzObvaELXXQ5BnsKACnJuLFYAwDPTnKEZiy6OqH2s8pIQGx6gMQ7vseXZQUzcMdqw3oL1KwfzIzfpMagX4Ibpf8DQf1PNoZfzjHqE7ttzx74ofbtUaYMmN3RTx/lOMK+fZmg/zBvpffX2hIjOQysHShSQFvJ3DSo4MPi46apBHq9PnCILihzWGMSGqC5tFHtemnh2gqUXupXjHL3bMIHlilRDcgEKvEVptnG7yqa6/DNUBsrmnpwtOJDbnmF0K4CcFFNT3OC8C2YWesd1G+JhHmW4Kv7Rhwie9M53QeGNkwqJFzHH7UpPQpAOBYxLB3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnBWtmIbFN5Dek+hWA+d9J8IOxoOukb4re7wA8q5dYo=;
 b=QQfA/nxHv+QaW62Xc8huP4hMV4wJ9ARzDhgk1AviwzY7IwVELzazex1sVtaU5otDh3sAP9Ypb/3lK3lJX1M4CjrwJjUop9UTO22qd+bAZ4qHp9/4vgvNq/JXHdlKpTjBtJdy6QZd0aL3z/UI/AxR1RwssY28FzOjOFegqeqkeyQ=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PR3PR08MB5723.eurprd08.prod.outlook.com (2603:10a6:102:89::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 11:32:02 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 11:32:01 +0000
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
Subject: Re: [PATCH v5 14/36] KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp
 interface
Thread-Topic: [PATCH v5 14/36] KVM: arm64: gic-v5: Add vgic-v5 save/restore
 hyp interface
Thread-Index: AQHcpzjTRj8blBECPEqYX+39W8/2XLWdEtAAgAEzx4A=
Date: Wed, 4 Mar 2026 11:32:01 +0000
Message-ID: <9200403dd5782b8712a17823c467562748046e7c.camel@arm.com>
References: <20260226155515.1164292-1-sascha.bischoff@arm.com>
	 <20260226155515.1164292-15-sascha.bischoff@arm.com>
	 <867brs96v1.wl-maz@kernel.org>
In-Reply-To: <867brs96v1.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DBAPR08MB5687:EE_|PR3PR08MB5723:EE_|DU6PEPF0000B621:EE_|FRZPR08MB11024:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e3e623e-b6e7-4504-8407-08de79e1ce14
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 3iPLw40ByegnsvHZf80l2fs4fVQ4LbZTEJoxc4MhjIg/4qoUMmoMzFZf0NHrJBmkLJvNQVrCJGtAUcXp9lmQbJEsf2AsS7o31eAObuNkyAqQGh6IKHL7fkehvp1tF4F0+5674NqofaEC7PNbFekkskesPi7qSLnMM0TQunEnu+dYv+Vg4BGdlsNupM3a/ldMJT0fou0/QzLyXTp0IhbCIN7gaCOYqAkhJNBEpRqP2JMjDXpikA+/L44p44McIrGDUpTSIXIDOYslNXi5EMtV1ALSMM7nvYGgD2c/gy+iVGB9AUsgXN0K+gFvKVmkh4Y+bXUkW/OWtnX7eZSMrfG2DXRoK0D41mi5lcG5h7+aQVOr4EI5jEKsfPNa1AJUJ+nZLde/oiIIXGmCrYLC8vKKM1/mW1Q1SOpsJYBYyFuA31EWN2ObJ1w2TY6ATFuUp8ZUplGl/F7p5rNzZgP6FON3t88iBRa3gdkDEj+9iAnSkyWHks5Uy2G8Z3S33efZqqYyzUWs3kTqulXVbOKNbDa17sOBAU52Hc4GW1NMHtBCx7ND3VGYSu0Xg/EwjSeFNceB/Y40giylULM1IFTBAmj6wRY4t1nBraZo1Hawr/Fbf9aZiMqssfeIqe4Kt5eiLpfGzMB+fG6VOvJlOCrxXyj7cfCcELWZKHajJ2RjITW710/yNvd//eRDsgvmJNHALhiHTfDrJkixzg9zTpEfLAPJKo0PouMz2Ck6CrICivX7qQEFimOP/WiUddFbwCR98V187JXCvQmCIIvO3bRuvLX/BBn4i2ApKKbLTv/qXSQxhAk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D6F4B272BCAAE4A90718A8956F9BC8E@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5723
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B621.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3128815a-369f-469a-0532-08de79e1a788
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|376014|36860700016|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	FGKS0VJvI8Gl0ddmkrRNZ9hrLUHnqBtrYSSND1vRUCGLxmvPfY6+KKZV5hDye8+8oSVC84rNk8K4VO0BClX48nYODYJ4jnX2Mo6cuy/0Ekep5kMfwlH6KmWtf5i86OV0IsUDrQDxUR7gNLps6oMb22oyf2w8D0uElDh0W3aabpVWZa9EwFy28h7QeU+s3gG0CfcpUVEV6IBaxQU5IuZXOyUKGi8K4MTutghmOZezMVtZG/yidPltxq0B1XNaMO0jJ3Vl9ESxNmEAZu0SiRoClro903JtLM7XkaXILKFdwHtbHkIDIMlWaIGSLIrNzBNWDgsQORQ7DKXcaO4p56GK3dZcBopLcmnCGE2ujlmtCCvBgpolgnCRulLmJckso2mp8I7DxjPKdrihZMQwM6T2NdU5At+k2X20Q0c4+MCdlooQxXysUOEm6ed4Ms7VO5vi+qch6vM0aVSrmuVG5NaE11vNOYmHczp4jtXMdIZ88i+8GwdYze2i1Fm+MxAj+L2lNkfdoNISugldJDp5vCkKONu/MnlB+7C2ykXCTKSMRIXj20Cb7AIOMSN+X3gawwSjOnBzbxL5H+D0rL9qLsFUvkI9slxmYRYGO4UNyOl9QgMXdxPBuTvaCzhsoizKEdpqXeWTrtV3NlRcXu66606c/wmpAxRYQAy7BzPHZlQKhPAVM8xt/M4wFS/kRgGIz3uyvX78T8CQ5Lbmp2nmNL/Q1dlF+CzkvnNQ2RD8vYbl8gHY7fnmriVu9WCB1uDhQAM/w7xo7BqvNMgdtxo8SXC/AQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(376014)(36860700016)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BKYFvl+BLV0ATZv6prjM1jRUtVZ5YCrA9yeUrnoT6zv+Nau/6fn1CWY0fBsSkubu+OG0582i+EVl6wzL0Ly0guzd+g6ADRDo4fAbIxFSbOy7X4Hu3jUchtoFQhMamV/v8gnWEY9RFFpv8b4JE8nLUwEM/yftlPdSrTF+4xzWjvp29kT92mULL55Rqzw631S8phbYffInxHqxFDl+r8XxxajYK3tcDSZdP8anN751xAIVwow02JaTJMLDcCs52Bg6NWznjtR1xq8Fgs8T7t/CRevdsN56dCscuErmUU0PFbXVu8zlJ/dg7o3OVeRbaQTxm9HDfsthZaogpxfZ0OvUwhmRWTAs0D5Llx8K2My6QCAzRg4X/QbPHrVbonZjgg+YAJDxFZJBn9upW9/vjYOJ9lxT+DDffptT3O5TIBcS4KN9YexFTARvkCDVdYbkEGV2
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 11:33:06.4087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e3e623e-b6e7-4504-8407-08de79e1ce14
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B621.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB11024
X-Rspamd-Queue-Id: CF9721FF035
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72677-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,arm.com:dkim,arm.com:email,arm.com:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[arm.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
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

T24gVHVlLCAyMDI2LTAzLTAzIGF0IDE3OjEwICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFRodSwgMjYgRmViIDIwMjYgMTU6NTk6MDIgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEludHJvZHVjZSBoeXAg
ZnVuY3Rpb25zIHRvIHNhdmUvcmVzdG9yZSB0aGUgZm9sbG93aW5nIEdJQ3Y1IHN0YXRlOg0KPiA+
IA0KPiA+ICogSUNDX0lDU1JfRUwxDQo+ID4gKiBJQ0hfQVBSX0VMMg0KPiA+ICogSUNIX1BQSV9B
Q1RJVkVSeF9FTDINCj4gPiAqIElDSF9QUElfRFZJUnhfRUwyDQo+ID4gKiBJQ0hfUFBJX0VOQUJM
RVJ4X0VMMg0KPiA+ICogSUNIX1BQSV9QRU5EUlJ4X0VMMg0KPiA+ICogSUNIX1BQSV9QUklPUklU
WVJ4X0VMMg0KPiA+ICogSUNIX1ZNQ1JfRUwyDQo+ID4gDQo+ID4gQWxsIG9mIHRoZXNlIGFyZSBz
YXZlZC9yZXN0b3JlZCB0by9mcm9tIHRoZSBLVk0gdmdpY192NSBDUFVJRg0KPiA+IHNoYWRvdw0K
PiA+IHN0YXRlLCB3aXRoIHRoZSBleGNlcHRpb24gb2YgdGhlIGFjdGl2ZSwgcGVuZGluZywgYW5k
IGVuYWJsZQ0KPiA+IHN0YXRlLiBUaGUgcGVuZGluZyBzdGF0ZSBpcyBzYXZlZCBhbmQgcmVzdG9y
ZWQgZnJvbSBrdm1faG9zdF9kYXRhDQo+ID4gYXMNCj4gPiBhbnkgY2hhbmdlcyBoZXJlIG5lZWQg
dG8gYmUgdHJhY2tlZCBhbmQgcHJvcGFnYXRlZCBiYWNrIHRvIHRoZQ0KPiA+IHZnaWNfaXJxIHNo
YWRvdyBzdHJ1Y3R1cmVzIChjb21pbmcgaW4gYSBmdXR1cmUgY29tbWl0KS4gVGhlcmVmb3JlLA0K
PiA+IGFuDQo+ID4gZW50cnkgYW5kIGFuIGV4aXQgY29weSBpcyByZXF1aXJlZC4gVGhlIGFjdGl2
ZSBhbmQgZW5hYmxlIHN0YXRlIGlzDQo+ID4gcmVzdG9yZWQgZnJvbSB0aGUgdmdpY192NSBDUFVJ
RiwgYnV0IGlzIHNhdmVkIHRvIGt2bV9ob3N0X2RhdGEuDQo+ID4gQWdhaW4sDQo+ID4gdGhpcyBu
ZWVkcyB0byBieSBzeW5jZWQgYmFjayBpbnRvIHRoZSBzaGFkb3cgZGF0YSBzdHJ1Y3R1cmVzLg0K
PiA+IA0KPiA+IFRoZSBJQ1NSIG11c3QgYmUgc2F2ZS9yZXN0b3JlZCBhcyB0aGlzIHJlZ2lzdGVy
IGlzIHNoYXJlZCBiZXR3ZWVuDQo+ID4gaG9zdA0KPiA+IGFuZCBndWVzdC4gVGhlcmVmb3JlLCB0
byBhdm9pZCBsZWFraW5nIGhvc3Qgc3RhdGUgdG8gdGhlIGd1ZXN0LA0KPiA+IHRoaXMNCj4gPiBt
dXN0IGJlIHNhdmVkIGFuZCByZXN0b3JlZC4gTW9yZW92ZXIsIGFzIHRoaXMgY2FuIGJ5IHVzZWQg
YnkgdGhlDQo+ID4gaG9zdA0KPiA+IGF0IGFueSB0aW1lLCBpdCBtdXN0IGJlIHNhdmUvcmVzdG9y
ZWQgZWFnZXJseS4gTm90ZTogdGhlIGhvc3Qgc3RhdGUNCj4gPiBpcw0KPiA+IG5vdCBwcmVzZXJ2
ZWQgYXMgdGhlIGhvc3Qgc2hvdWxkIG9ubHkgdXNlIHRoaXMgcmVnaXN0ZXIgd2hlbg0KPiA+IHBy
ZWVtcHRpb24gaXMgZGlzYWJsZWQuDQo+ID4gDQo+ID4gQXMgcGFydCBvZiByZXN0b3JpbmcgdGhl
IElDSF9WTUNSX0VMMiBhbmQgSUNIX0FQUl9FTDIsIEdJQ3YzLWNvbXBhdA0KPiA+IG1vZGUgaXMg
YWxzbyBkaXNhYmxlZCBieSBzZXR0aW5nIHRoZSBJQ0hfVkNUTFJfRUwyLlYzIGJpdCB0byAwLiBU
aGUNCj4gPiBjb3JyZXNwb2luZGluZyBHSUN2My1jb21wYXQgbW9kZSBlbmFibGUgaXMgcGFydCBv
ZiB0aGUgVk1DUiAmIEFQUg0KPiA+IHJlc3RvcmUgZm9yIGEgR0lDdjMgZ3Vlc3QgYXMgaXQgb25s
eSB0YWtlcyBlZmZlY3Qgd2hlbiBhY3R1YWxseQ0KPiA+IHJ1bm5pbmcgYSBndWVzdC4NCj4gPiAN
Cj4gPiBDby1hdXRob3JlZC1ieTogVGltb3RoeSBIYXllcyA8dGltb3RoeS5oYXllc0Bhcm0uY29t
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IFRpbW90aHkgSGF5ZXMgPHRpbW90aHkuaGF5ZXNAYXJtLmNv
bT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBh
cm0uY29tPg0KPiA+IC0tLQ0KPiA+IMKgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fYXNtLmjC
oMKgIHzCoMKgIDQgKw0KPiA+IMKgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5owqAg
fMKgIDE2ICsrKysNCj4gPiDCoGFyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2h5cC5owqDCoCB8
wqDCoCA4ICsrDQo+ID4gwqBhcmNoL2FybTY0L2t2bS9oeXAvbnZoZS9NYWtlZmlsZcKgwqAgfMKg
wqAgMiArLQ0KPiA+IMKgYXJjaC9hcm02NC9rdm0vaHlwL252aGUvaHlwLW1haW4uYyB8wqAgMzIg
KysrKysrKysNCj4gPiDCoGFyY2gvYXJtNjQva3ZtL2h5cC92Z2ljLXY1LXNyLmPCoMKgwqAgfCAx
MjMNCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+IMKgYXJjaC9hcm02NC9r
dm0vaHlwL3ZoZS9NYWtlZmlsZcKgwqDCoCB8wqDCoCAyICstDQo+ID4gwqBpbmNsdWRlL2t2bS9h
cm1fdmdpYy5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyMSArKysrKw0KPiA+IMKgOCBm
aWxlcyBjaGFuZ2VkLCAyMDYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPiDCoGNy
ZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL2FybTY0L2t2bS9oeXAvdmdpYy12NS1zci5jDQo+ID4gDQo+
ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FzbS5oDQo+ID4gYi9h
cmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9hc20uaA0KPiA+IGluZGV4IGExYWQxMmM3MmViZjEu
LmZlOGQ0YWRmYzI4MWQgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9r
dm1fYXNtLmgNCj4gPiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9hc20uaA0KPiA+
IEBAIC04OSw2ICs4OSwxMCBAQCBlbnVtIF9fa3ZtX2hvc3Rfc21jY2NfZnVuYyB7DQo+ID4gwqAJ
X19LVk1fSE9TVF9TTUNDQ19GVU5DX19fcGt2bV92Y3B1X2xvYWQsDQo+ID4gwqAJX19LVk1fSE9T
VF9TTUNDQ19GVU5DX19fcGt2bV92Y3B1X3B1dCwNCj4gPiDCoAlfX0tWTV9IT1NUX1NNQ0NDX0ZV
TkNfX19wa3ZtX3RsYl9mbHVzaF92bWlkLA0KPiA+ICsJX19LVk1fSE9TVF9TTUNDQ19GVU5DX19f
dmdpY192NV9zYXZlX2FwciwNCj4gPiArCV9fS1ZNX0hPU1RfU01DQ0NfRlVOQ19fX3ZnaWNfdjVf
cmVzdG9yZV92bWNyX2FwciwNCj4gPiArCV9fS1ZNX0hPU1RfU01DQ0NfRlVOQ19fX3ZnaWNfdjVf
c2F2ZV9wcGlfc3RhdGUsDQo+ID4gKwlfX0tWTV9IT1NUX1NNQ0NDX0ZVTkNfX192Z2ljX3Y1X3Jl
c3RvcmVfcHBpX3N0YXRlLA0KPiA+IMKgfTsNCj4gPiDCoA0KPiA+IMKgI2RlZmluZSBERUNMQVJF
X0tWTV9WSEVfU1lNKHN5bSkJZXh0ZXJuIGNoYXIgc3ltW10NCj4gPiBkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+ID4gYi9hcmNoL2FybTY0L2luY2x1ZGUv
YXNtL2t2bV9ob3N0LmgNCj4gPiBpbmRleCAzMzIxMTRiZDQ0ZDJhLi42MGRhODQwNzFjODZlIDEw
MDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiA+ICsr
KyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiA+IEBAIC03OTcsNiArNzk3
LDIyIEBAIHN0cnVjdCBrdm1faG9zdF9kYXRhIHsNCj4gPiDCoAkvKiBOdW1iZXIgb2YgZGVidWcg
YnJlYWtwb2ludHMvd2F0Y2hwb2ludHMgZm9yIHRoaXMgQ1BVDQo+ID4gKG1pbnVzIDEpICovDQo+
ID4gwqAJdW5zaWduZWQgaW50IGRlYnVnX2JycHM7DQo+ID4gwqAJdW5zaWduZWQgaW50IGRlYnVn
X3dycHM7DQo+ID4gKw0KPiA+ICsJLyogUFBJIHN0YXRlIHRyYWNraW5nIGZvciBHSUN2NS1iYXNl
ZCBndWVzdHMgKi8NCj4gPiArCXN0cnVjdCB7DQo+ID4gKwkJLyoNCj4gPiArCQkgKiBGb3IgdHJh
Y2tpbmcgdGhlIFBQSSBwZW5kaW5nIHN0YXRlLCB3ZSBuZWVkDQo+ID4gYm90aA0KPiA+ICsJCSAq
IHRoZSBlbnRyeSBzdGF0ZSBhbmQgZXhpdCBzdGF0ZSB0byBjb3JyZWN0bHkNCj4gPiBkZXRlY3QN
Cj4gPiArCQkgKiBlZGdlcyBhcyBpdCBpcyBwb3NzaWJsZSB0aGF0IGFuIGludGVycnVwdCBoYXMN
Cj4gPiBiZWVuDQo+ID4gKwkJICogaW5qZWN0ZWQgaW4gc29mdHdhcmUgaW4gdGhlIGludGVyaW0u
DQo+ID4gKwkJICovDQo+ID4gKwkJdTY0IHBlbmRyX2VudHJ5WzJdOw0KPiA+ICsJCXU2NCBwZW5k
cl9leGl0WzJdOw0KPiA+ICsNCj4gPiArCQkvKiBUaGUgc2F2ZWQgc3RhdGUgb2YgdGhlIHJlZ3Mg
d2hlbiBsZWF2aW5nIHRoZQ0KPiA+IGd1ZXN0ICovDQo+ID4gKwkJdTY0IGFjdGl2ZXJfZXhpdFsy
XTsNCj4gPiArCQl1NjQgZW5hYmxlcl9leGl0WzJdOw0KPiA+ICsJfSB2Z2ljX3Y1X3BwaV9zdGF0
ZTsNCj4gPiDCoH07DQo+ID4gwqANCj4gPiDCoHN0cnVjdCBrdm1faG9zdF9wc2NpX2NvbmZpZyB7
DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2h5cC5oDQo+ID4g
Yi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaA0KPiA+IGluZGV4IDc2Y2UyYjk0YmQ5
N2UuLjNkY2VjMWRmODdlOWUgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2Fz
bS9rdm1faHlwLmgNCj4gPiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaA0K
PiA+IEBAIC04Nyw2ICs4NywxNCBAQCB2b2lkIF9fdmdpY192M19zYXZlX2FwcnMoc3RydWN0IHZn
aWNfdjNfY3B1X2lmDQo+ID4gKmNwdV9pZik7DQo+ID4gwqB2b2lkIF9fdmdpY192M19yZXN0b3Jl
X3ZtY3JfYXBycyhzdHJ1Y3QgdmdpY192M19jcHVfaWYgKmNwdV9pZik7DQo+ID4gwqBpbnQgX192
Z2ljX3YzX3BlcmZvcm1fY3B1aWZfYWNjZXNzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+ID4g
wqANCj4gPiArLyogR0lDdjUgKi8NCj4gPiArdm9pZCBfX3ZnaWNfdjVfc2F2ZV9hcHIoc3RydWN0
IHZnaWNfdjVfY3B1X2lmICpjcHVfaWYpOw0KPiA+ICt2b2lkIF9fdmdpY192NV9yZXN0b3JlX3Zt
Y3JfYXByKHN0cnVjdCB2Z2ljX3Y1X2NwdV9pZiAqY3B1X2lmKTsNCj4gPiArdm9pZCBfX3ZnaWNf
djVfc2F2ZV9wcGlfc3RhdGUoc3RydWN0IHZnaWNfdjVfY3B1X2lmICpjcHVfaWYpOw0KPiA+ICt2
b2lkIF9fdmdpY192NV9yZXN0b3JlX3BwaV9zdGF0ZShzdHJ1Y3QgdmdpY192NV9jcHVfaWYgKmNw
dV9pZik7DQo+ID4gK3ZvaWQgX192Z2ljX3Y1X3NhdmVfc3RhdGUoc3RydWN0IHZnaWNfdjVfY3B1
X2lmICpjcHVfaWYpOw0KPiA+ICt2b2lkIF9fdmdpY192NV9yZXN0b3JlX3N0YXRlKHN0cnVjdCB2
Z2ljX3Y1X2NwdV9pZiAqY3B1X2lmKTsNCj4gDQo+IFRoZSBsYXN0IHR3byBhcmUgbm90IHBsdWdn
ZWQgYXMgaHlwZXJjYWxscz8gSG93IGRvIHRoZXkgZ2V0IGNhbGxlZD8NCg0KUmlnaHQgeW91IGFy
ZSAtIHRoZXkgYXJlIHRoZSBHSUN2NSBlcXVpdmFsZW50cyBvZiB3aGF0IHdlIGhhdmUgZm9yDQpH
SUN2My4gVGhleSBhcmUgcGx1bWJlZCBhIGJpdCBkaWZmZXJlbnRseS4NCg0KT24gVkhFIHdlIGNh
bGwgdGhlc2UgdmlhIHZnaWNfcmVzdG9yZV9zdGF0ZSgpIGFuZCB2Z2ljX3NhdmVfc3RhdGUoKSwN
CmFuZCB3aXRoIE5WSEUvaFZIRSAmIGZyaWVuZHMgd2UgY2FsbCB0aGVzZSBfX2h5cF92Z2ljX3Jl
c3RvcmVfc3RhdGUoKQ0KYW5kIF9faHlwX3ZnaWNfc2F2ZV9zdGF0ZSgpIGluIHRoZSBzd2l0Y2gg
Y29kZSAobnZoZS9zd2l0Y2guYykuIFRoaXMNCm1lYW5zIHRoYXQgd2UgZG9uJ3QgYWN0dWFsbHkg
bmVlZCB0aGUgaHlwZXJjYWxscyBhbGwgYXMgd2UncmUgYWx3YXlzDQpjYWxsaW5nIHRoZW0gZGly
ZWN0bHkuDQoNCkknbGwgcmUtd29yayB0aGUgY29tbWl0IG1lc3NhZ2UgdG8gbWFrZSB0aGlzIGV4
cGxpY2l0Lg0KDQpIb3dldmVyLCB0aGlzIG1hZGUgbWUgbG9vayBtb3JlIGNsb3NlbHkgYXQgdGhp
cyBjb2RlIGFnYWluLCBhbmQgdGhlIFBQSQ0Kc2F2ZS9yZXN0b3JlIGNvZGUgaGFzIHRoZSBzYW1l
IHByb3BlcnRpZXMgaW4gdGhhdCBpdCBpcyBjYWxsZWQgZnJvbSB0aGUNCkVYQUNUIHNhbWUgcGxh
Y2VzLiBJIGp1c3QgdGVzdGVkIHRoaXMsIGFuZCB3ZSBjYW4gZG8gYXdheSB3aXRoIHRoZQ0KaHlw
ZXJjYWxscyB0aGVyZSB0b28sIHNvIEknbGwgZHJvcCB0aG9zZSBoeXBlcmNhbGxzIHRvbyB3aGVu
IEkgcmVmcmVzaA0KdGhlIHNlcmllcy4NCg0KPiANCj4gT3ZlcmFsbCwgaXQgd291bGQgYmUgZ29v
ZCB0byBkZXNjcmliZSB3aGF0IGdldHMgc2F2ZWQvcmVzdG9yZWQgd2hlbi4NCj4gSSdtIHN1cmUg
dGhlcmUgaXMgYSBsb2dpYyBiZWhpbmQgaXQgYWxsLCBhbmQgbWF5YmUgaXQgaXMgdmVyeSBjbG9z
ZQ0KPiB0bw0KPiB3aGF0IHYzIHJlcXVpcmVzLCBidXQgdGhhdCdzIG5vdCBjb21wbGV0ZWx5IGFw
cGFyZW50IGluIHRoaXMgcGF0Y2gNCj4gKHdlDQo+IGRvbid0IHNlZSB0aGUgY2FsbCBzaXRlcyku
DQoNClllYWgsIEknbGwgbWFrZSB0aGlzIG11Y2ggbW9yZSBhcHBhcmVudCBpbiB0aGUgY29tbWl0
IG1lc3NhZ2UuDQoNClRoYW5rcywNClNhc2NoYQ0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiAJTS4N
Cj4gDQoNCg==


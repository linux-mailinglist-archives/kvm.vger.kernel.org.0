Return-Path: <kvm+bounces-72043-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GH47OL51oGmtjwQAu9opvQ
	(envelope-from <kvm+bounces-72043-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:33:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AD9C1AA7BE
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:33:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6CBDF306B786
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13D347DFBA;
	Thu, 26 Feb 2026 16:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RPh8nSbF";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RPh8nSbF"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011060.outbound.protection.outlook.com [52.101.65.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A14C480346
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121760; cv=fail; b=OL0VODsUxaBi9pt6ivhbA+Rev8ibUWJWJQopUdNnO9CK8Y6bzh56/n40eDDHKTquWlOQT5S8Jm2h0QEH1M0BP5hZHCwTgXB5NhO1EFgaytJukcypoFmP/zS1sqp5u5BaQu5Npw8Yp4CXbjnhwBD/8LQhnMEoc6w8OWYFL99+t9Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121760; c=relaxed/simple;
	bh=EJShdkffakgvQKngY12kprmi3WMnM8cfCU1fFKyd1FE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=grl2UmxkOuGRNfixtzIP6ZbT3weMeLzg9iMhTodFQKtFZCIjql8VNv4mRKrrIolDgPeOwfKjqtlEXQk4Ph3rg1jVqiG88fUr776mLzr7DlR9neGAV1SA4f5OFt0ql1Y4XkKzEbievEpqlnmB1Ub5TVBAwP211bTEkypt01lJyjY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RPh8nSbF; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RPh8nSbF; arc=fail smtp.client-ip=52.101.65.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=V3Pq/kWVwBE0AeiFeW2fT59rjVqDRQK+O1bX/F2IsaCIzfxMcKtxgtnvxyOcYzg7WImXR095wWsYSmOHBWWwXquyMxlui+tUqzvzszh5Vw10ehrXdSiu7X3xdlfrv8W5jCJHUROprnbYd8oPw7+c1/UulBinSy0T7yHxnF7dsa2GgtsbnIzmTGhSywynU/f8CWIsdr+QdPy4l0PwcOZnu/oVtC7dmmFYOL3lln9BZAcv56KiN3ouk5yW2rg997pGfORl84we6oM4lITy/V+N6+mWAFQgoaY8hNHn/Yx9vjT3WCFloLCP0LzEFZb5lOvq1gfvlWVrTBs+sdR4CeNEzg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFQb6xTwjC8N0D0gmaJIEje56fBzsgzkv0l2xfhCWi4=;
 b=hnsC0LzJxE+I+xa4Wag50qYXt8k+oYRLhgeIw7XrmTZwAHFzR5McvK3M855quWtZpEFjzCVjqhHftz+hVfemRSLEGfYRl1buU+wOwV9YKHb+sxbXvj4USEnQP3IAkuLLRH6+JGS+QbxOTD0xHpfgq1xudkOgINrXlHKUsQpcoEUexqHKT3VvXKZQZbK6hoMyPvUIFzvc8cAXsNBSf9nvUV2V8aTE5Fh57RZe5sNCJIHIcp0h7nUEcqmzn5JrW2Ct2IHJOpGkLCzg+2grdbuVpe+JvFwkHXxErQpBDS6owHQi21aIB0I0KuN3FdSI8YHx437nELqXoytN7g4Ni6UxOw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFQb6xTwjC8N0D0gmaJIEje56fBzsgzkv0l2xfhCWi4=;
 b=RPh8nSbF0U0o3P0LuW84R+UF7rhD3SXt3YumSeTf+TGFQkfPNDL9Vg+7TRsQE5u303D/a6fucgY+5VVINrs4SfrDhP4KOJxbdewj3/PAvmk0qZ48XWwZFTHerUW7EEguLLIXUZeqRSBDqR6GBTzibVLbZc5rL9q0LmVBB1+rELM=
Received: from DB8P191CA0025.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::35)
 by GV1PR08MB11052.eurprd08.prod.outlook.com (2603:10a6:150:1f1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:02:27 +0000
Received: from DB1PEPF000509E3.eurprd03.prod.outlook.com
 (2603:10a6:10:130:cafe::99) by DB8P191CA0025.outlook.office365.com
 (2603:10a6:10:130::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Thu,
 26 Feb 2026 16:02:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E3.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:02:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YwPh4y0Pao8eQUEEyrJ95DGGTtVKnyjHT8DQvd6dm40IUl1mndMaOGtdaNY8UIqZ1YPzj9aI6V3qYMLJ/DmtXm+XtB0T9H2WTUwZ6MMR9FHVsxqxXFXgGAn4CUEhmz+N6ELLGtCVTXyWu6OmSX5IzdZbJ9hYs0uStwu6NDrjlQ/iiV3RxF1kBbRhW8H2YwKZnlnNHlCnfENBGzTfJECICFwzkFbZQri3F3tHwP4VNh77uJKThDhmI/w+fpT7DHCterCWzreP87yj4vvCX4XPXvPf2VY14gxUu2sRi6IOVaXqqhfleezFV2h/u3ifTaLYrBWF+PE0YolRRFxAJZXWjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFQb6xTwjC8N0D0gmaJIEje56fBzsgzkv0l2xfhCWi4=;
 b=TwNmnsVx1OefKy5Eg6C3UKeg/18xOc/cMELwNXSlZXjMxOEXTN0k5g20OdUn94F8d28fkK5ZEfemM90uDwjYxkbOARVWn6fHOV7SLXbP1FuFQiOQRvW6dNzWLcjJX8cGNs6gtdBeHjkGoC80ZqGIxNBf/tzRcugIpa9UQK/75d6BN4IZ8LajYTuMD0BANxXgzyhLtJo1sxG7+x0VdlM/6CJTzUAXm2/4ibfVeM8YLAq3nIRComxL8wfUTyNAuWRSf7vrJOVDhUh54GsOYgknfCTzVB4+bMmb+MqKR0zFa6d0Bf389DeFP+G4l/MVHHQqpDtVs7t4S35cyz3DZw3i7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFQb6xTwjC8N0D0gmaJIEje56fBzsgzkv0l2xfhCWi4=;
 b=RPh8nSbF0U0o3P0LuW84R+UF7rhD3SXt3YumSeTf+TGFQkfPNDL9Vg+7TRsQE5u303D/a6fucgY+5VVINrs4SfrDhP4KOJxbdewj3/PAvmk0qZ48XWwZFTHerUW7EEguLLIXUZeqRSBDqR6GBTzibVLbZc5rL9q0LmVBB1+rELM=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by VI1PR08MB5486.eurprd08.prod.outlook.com (2603:10a6:803:13b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 16:01:23 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:01:23 +0000
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
Subject: [PATCH v5 23/36] KVM: arm64: gic-v5: Support GICv5 interrupts with
 KVM_IRQ_LINE
Thread-Topic: [PATCH v5 23/36] KVM: arm64: gic-v5: Support GICv5 interrupts
 with KVM_IRQ_LINE
Thread-Index: AQHcpzknez56qzlCIUaYaadEUAcaIg==
Date: Thu, 26 Feb 2026 16:01:23 +0000
Message-ID: <20260226155515.1164292-24-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|VI1PR08MB5486:EE_|DB1PEPF000509E3:EE_|GV1PR08MB11052:EE_
X-MS-Office365-Filtering-Correlation-Id: 02ba3de2-ffe6-4380-d3fb-08de75506fcf
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 xX/2vLWB/wGvJMOmO7QX+sMM86eAVK/C578QQfwgG4L3Pf/SmWXAQUssZPkudY1O+1kzCJXDCB52ofjL6853jLE0kalf63u0cjEk06lIA1HZdZnioWTAvzsMYV7mbxqLvl2hKyjvuC0bIEowC7Gs5ZUGnhBE/ewQiI59VEDCI0KR9uGhWspUDkOlhI22UiQho5TiqVq067cWynyjLsaF21KfEAVXTGr1KGoLhz6EfPNe9kffuPF7Y3fzwc7rtFAOoB7hJxKV6oMbTwpkJptMlm/Buz890EbvpiMu0o8GZ58N0k5lroImo0fT9OC/qeA4g8psIHXtH0HIHYvh0htmpNvDoXp353CfbxDp5izD7P2xVhWLRqxyZ9H7/6UfDbbjFfc+SzMLoZLHEWnyu6AIKEAQPk4MMAsPN9NN4AQC8NwJX2uRmPZq9gG7L4FlRyDdmzAVQlxeBBo8lV/0hU6oe1Y4SlIbOOU9zxvr0hozLHWq1ZvDW4c6hH/aLgDTy0lMwMLZQqcdQF8yjaf1CGtoixQFL303Wlsy6ARnJ2nGSxUmnxKLj22N5C07QolXDuo+bsg9Ltw+aLGhJZEhfGkvjSOC2jOkFJqzQWgi4AGWDPqOfWcVULwy9UyRiywGSQlswAoJQCcfT9e6Ebu/km7sBDiQl68Q1gvGE/oBTSP4nSlXcnnPTVsQ59QPSIre2TjVglly8wpCVU1vR12gfFc42SvHAlB6W/qMk1iyHrWxr3zctQRdCjF3m0T4MtrmMFA1z3D20HDuNrx7L09xJ9q4wdWxW9WTcfVw7gR6/NdFn14=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5486
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E3.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6c44b029-b138-4a8c-9d3e-08de75504a41
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|376014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	Xvm7nVO+kI5R+03dmAp46SgTNvPkUdsfSvBJ6izsBE2Vvi8oWDQ4AF6yY72JvPTJvmiMYF97SBNyvAc+Bc2HdN7/vVMUyHPCpJenjH7KUFr9mT6fcANOt0DQZMSrYEN03RgRjyd/MrULIz8Mi2tB/tBhZl+XMHmIfCKnErbIIyTzYewOH3pGkGdYXG7ZeCkqTnnOwj27B0JrUHeWi8+iZrhe7egvDJlzMZJ1aV7y4DVTIQbcRY12GB9Ev+NRKyp4yaTDmOUT1Iy0dLxE3fKX4p5mcctOzsg1SwK6G9qBySymZaY0zXKrexQJI5P09SNur284B8JTVeIt/eNI3c8EcalzvY99/ak4fprpnrmOsnUNJfb0xw92Rh4pfDdaoL5ZuoFxwr0WEu346+YRbdPTmf9JdsU1QGXpbKBd4VoNLcAH3aj7mOKWy/PUlZozANmaEXh0j8JASZHkx1pyGBU/hZ1d8m0CcDvDiCE8y4I73CC09Mtd0cbeZKl8Iq8BWnioO2F5eQYekQ5pAprCOXzO3vpYrV3J/MmSHsRHWYz8gwxazcOtuq8PpwJdieG4NsJ3Jt7OwXFhLDagKWiMb4bqeUYR90FfoLdAcvaVs7H+jCI8+qBo3v12F79NzZliJf0TFx4kR7ucwusNDPalaahfdutwgmiHj9H50+GEaKDKsb8MIyHk9hqgBv1yK/QeE3vmtLpQb+41ecrRPgpFhA6VloJboEOL5GZmR02YuITwaDvYvrk4mc2Ei+hyfcbIzQ8hNmzh6v1KNdOAR/v9gaGeVE8sctJoms1s6TuJLF4rQfzZZnliaPE9ZqwU7QznTsWDyUTKExYw+LXeZ7ZmkUOTkw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(376014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jzFM6qHOL2VVDWQitplsV6Sv+zjifCflPjlxH18cKMBjwiVqshYHtKXJKG/d81twKo8kadZhk4JTVUaLJw5wHkHhwE0o2mMZ4ekKXDDqKmfAoOl6fg3+hqkYquBz+fpTTSayGfWJPiqIoMaIeWeNZ1WF4qVh/YR/USrjZHXRd7msDUTaBg7F/JfNe4bsbDUBlUxpTt8GPsyDPbmfC7jW0/lzjI2qBNkdUVuhoyzUh4dzCuMq2CBFQEWxvC5PLqzLE6bL3Q+wiTi6qXCstuqyrjYBdgKb5PstfVRtOh1zNDUMIc7yOkuoJElLAChFXDidPhsqXGR83mb8WT2/wqWBdnPnW26BVDzuMwvKtDUo0jc3+lnbDsNM2LkRNl7reKu0Z8FmJA1R5k+HA9xEcja4y+oLtu09eFQ613W9s+cRDzYLKm1qDdqVUtPEAZow3j+8
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:02:26.5892
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ba3de2-ffe6-4380-d3fb-08de75506fcf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E3.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11052
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72043-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:dkim,arm.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,huawei.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 5AD9C1AA7BE
X-Rspamd-Action: no action

Interrupts under GICv5 look quite different to those from older Arm
GICs. Specifically, the type is encoded in the top bits of the
interrupt ID.

Extend KVM_IRQ_LINE to cope with GICv5 PPIs and SPIs. The requires
subtly changing the KVM_IRQ_LINE API for GICv5 guests. For older Arm
GICs, PPIs had to be in the range of 16-31, and SPIs had to be
32-1019, but this no longer holds true for GICv5. Instead, for a GICv5
guest support PPIs in the range of 0-127, and SPIs in the range
0-65535. The documentation is updated accordingly.

The SPI range doesn't cover the full SPI range that a GICv5 system can
potentially cope with (GICv5 provides up to 24-bits of SPI ID space,
and we only have 16 bits to work with in KVM_IRQ_LINE). However, 65k
SPIs is more than would be reasonably expected on systems for years to
come.

In order to use vgic_is_v5(), the kvm/arm_vgic.h header is added to
kvm/arm.c.

Note: As the GICv5 KVM implementation currently doesn't support
injecting SPIs attempts to do so will fail. This restriction will by
lifted as the GICv5 KVM support evolves.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 Documentation/virt/kvm/api.rst |  6 ++++--
 arch/arm64/kvm/arm.c           | 22 +++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic.c     |  4 ++++
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index fc5736839edd6..e48cf5db52ea6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -907,10 +907,12 @@ The irq_type field has the following values:
 - KVM_ARM_IRQ_TYPE_CPU:
 	       out-of-kernel GIC: irq_id 0 is IRQ, irq_id 1 is FIQ
 - KVM_ARM_IRQ_TYPE_SPI:
-	       in-kernel GIC: SPI, irq_id between 32 and 1019 (incl.)
+	       in-kernel GICv2/GICv3: SPI, irq_id between 32 and 1019 (incl.)
                (the vcpu_index field is ignored)
+	       in-kernel GICv5: SPI, irq_id between 0 and 65535 (incl.)
 - KVM_ARM_IRQ_TYPE_PPI:
-	       in-kernel GIC: PPI, irq_id between 16 and 31 (incl.)
+	       in-kernel GICv2/GICv3: PPI, irq_id between 16 and 31 (incl.)
+	       in-kernel GICv5: PPI, irq_id between 0 and 127 (incl.)
=20
 (The irq_id field thus corresponds nicely to the IRQ ID in the ARM GIC spe=
cs)
=20
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8290c5df0616e..563e18b1ec5aa 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -45,6 +45,9 @@
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_psci.h>
+#include <kvm/arm_vgic.h>
+
+#include <linux/irqchip/arm-gic-v5.h>
=20
 #include "sys_regs.h"
=20
@@ -1477,16 +1480,29 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct k=
vm_irq_level *irq_level,
 		if (!vcpu)
 			return -EINVAL;
=20
-		if (irq_num < VGIC_NR_SGIS || irq_num >=3D VGIC_NR_PRIVATE_IRQS)
+		if (vgic_is_v5(kvm)) {
+			if (irq_num >=3D VGIC_V5_NR_PRIVATE_IRQS)
+				return -EINVAL;
+
+			/* Build a GICv5-style IntID here */
+			irq_num |=3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+		} else if (irq_num < VGIC_NR_SGIS ||
+			   irq_num >=3D VGIC_NR_PRIVATE_IRQS) {
 			return -EINVAL;
+		}
=20
 		return kvm_vgic_inject_irq(kvm, vcpu, irq_num, level, NULL);
 	case KVM_ARM_IRQ_TYPE_SPI:
 		if (!irqchip_in_kernel(kvm))
 			return -ENXIO;
=20
-		if (irq_num < VGIC_NR_PRIVATE_IRQS)
-			return -EINVAL;
+		if (vgic_is_v5(kvm)) {
+			/* Build a GICv5-style IntID here */
+			irq_num |=3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_SPI);
+		} else {
+			if (irq_num < VGIC_NR_PRIVATE_IRQS)
+				return -EINVAL;
+		}
=20
 		return kvm_vgic_inject_irq(kvm, NULL, irq_num, level, NULL);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index cd45e5db03d4b..58a3fc66f2ce2 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -86,6 +86,10 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u3=
2 intid)
  */
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 {
+	/* Non-private IRQs are not yet implemented for GICv5 */
+	if (vgic_is_v5(kvm))
+		return NULL;
+
 	/* SPIs */
 	if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
 	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
--=20
2.34.1


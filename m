Return-Path: <kvm+bounces-72027-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6PpUO+dyoGmDjwQAu9opvQ
	(envelope-from <kvm+bounces-72027-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:20:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B821AA119
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:20:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 36DA731AE41C
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95CCE426D14;
	Thu, 26 Feb 2026 15:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mj6HGeYk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mj6HGeYk"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011036.outbound.protection.outlook.com [40.107.130.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8634A44CAE9
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121549; cv=fail; b=KQySVBIfKqKZxPoseawijYi1P4ltFY0WHvUtJq3o4a0X7s1BK20/AUOHxRyp7OhJizzXhVEli0gX4Q81xJVsDlIrEqe/eSrNt7pUROLuUDdWns4fndTbNPYD0qQlDuro0cDm0PhV+h+GQbfhg5KhNEq41m7yaegQMKC/fdcy6uA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121549; c=relaxed/simple;
	bh=m21aqHCd+lakf/h24hOSvVw+P26UiM4ic2Jku2CnjF8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hX+rIFEp5c5i4trSHWfR+qq3gqEwmvGxisyG0XA3MBrjt3On+JQTFi4Y/jDxY5pUxanOWbN+uTiyi7bPSJPs2bgQL4rw6DLdOYO5xt4OK+RW+GyK61wn2L5sOGm089vG4tf8Hc+yQX/I5J6DJ4oN3MIbj4fciM9THU2X95icyik=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mj6HGeYk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mj6HGeYk; arc=fail smtp.client-ip=40.107.130.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=mopWuPnO+7l6Liuc68+afDoW10dW43CHPl2mykV5OFyaVSVf1kgrNtIkHxTTrsGsWN6T3iwGm0hYrG25mpj3Sj2H6cNhJU8WgjnWBo503meNyFuN+TwcOnSGPPiiNSxmOwBrOksu7GB1qyLWyMSYCyBy5l3ENppS5db1UhnBQit+i24vFVpGRfS07P/lpGBRXPwBp7uxK1a4RYIkmN7WewElJvH0F4LEDgbqW2gfy5n4lgjaxORMjEeFS4haM1w6fiEjIOW6fjvWaK7WTH5/v8h7hjF9A3lV/+9orixXBVqV9fZE4JWHfh0AKpH2mQ+KLqmKueui59DoZWssGl6DiA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGrcql4CqtUQH4TFbKWvUmnd2j3gU/STa5kYwUKGtY4=;
 b=UwEmt4QK9FmXLlbORVmG9aiCEmg5YfD8SKnnJZavZgC0lcYnprBHFqhNABHJmwpFR7I9tL4VGZoI4wOMRmPcIa2WdCvcKBsX2dfSKcrrWvKienIM7mgylgRJEyytK2OKbfsIQMtdz3vUPz3yKhxYWAmL1D/QxSgxZRTKPgDVrpptDMCTIoXnsN1f7y6PB4Dec2kxjepeG1gm1R9WM3oh+QM7v4KmHAv8OBScu+g9Yaj/Fl/mYFAbeKRq2ZtTusUZwzBl5NIpudBqhqqo1PjMdYw8l85sTz6xo6EfRcsVN1KWSb2HlPmGr73qSquVNRlNOxNovdIYeoE0/V84nwMzpA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGrcql4CqtUQH4TFbKWvUmnd2j3gU/STa5kYwUKGtY4=;
 b=mj6HGeYkOO5FxErKX/lraqe/YfzjGF33o8RvoPH7zOaCHM06Zmup0qqjudMZj2AbcnUKxpYR7gasMHT/Tp5IsdO9KnQDxHikSGYi/MsM4InpsC6rdGTQ2QaX7TYuDC3+LCsOSBoqoNRwpO+lcu34S54+C/lVYP+oyF8ma462jsc=
Received: from AM8P251CA0008.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::13)
 by GV2PR08MB7932.eurprd08.prod.outlook.com (2603:10a6:150:7f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 15:58:47 +0000
Received: from AMS0EPF000001A4.eurprd05.prod.outlook.com
 (2603:10a6:20b:21b:cafe::84) by AM8P251CA0008.outlook.office365.com
 (2603:10a6:20b:21b::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Thu,
 26 Feb 2026 15:58:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A4.mail.protection.outlook.com (10.167.16.229) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 15:58:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xmR8F2aj6BFZsYWuSdpWs6Vc2S/hKreeX6um4xT0byGeLM/zj9SRTR0Ekh8jXia+o53MACCrX4+DJgRnELCYVIHhDqwb/HcCdBGmfMVLKhpEc1GZh0CJq4CQCB5Y9XQw/Epq96God1JsKFSVFJXsOcNreRTyS4kVhy8KDpBZwf7oz4JX+VhZ7KiYxHgEaOPfJyIu+PJhekYKHo7xeQH1q65BRWSuiyy35OXPTxSJ4hbP3EPFLAB3MopdgZ8PY/pKcFLxDzt/+q+8Ca8N9ihoSadKckDR/VHYbRw/2eveqdNT2cDbJaXg5YWzWrEBmbSHt27DpZ4J9ZrW6zENKdNcZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGrcql4CqtUQH4TFbKWvUmnd2j3gU/STa5kYwUKGtY4=;
 b=kSEgZn3KsqAe01b3R7Hqa3rg9LwmwjloTFFdpoz6NcpVAmBc9o3E7JG3CwHxfvetUqlnDil37DJp5e2K8eui4FY0MDNLIa9+PT6Zr5GCpGkIKg7H7wuFuIa3XNUO1WEfbePX6THusCYnZ9ax/aT1xBhZML+YqqqRalWK8tFDxxEmy7+AcBzYuY1H2o7CtnLWrvPCemqwDgDR6nxgBmrS0FGtuG11CKX23aUPq36gik93smwfxPctqk+JSl+AUh3yuGeg6RUT+XZVH4E1i9kLJ5C8uZ33CakNMwXvkZEIWZeeLzJO324wtJPKbyqVQ/pbS3ITwtHuwaESvJkNY75syQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGrcql4CqtUQH4TFbKWvUmnd2j3gU/STa5kYwUKGtY4=;
 b=mj6HGeYkOO5FxErKX/lraqe/YfzjGF33o8RvoPH7zOaCHM06Zmup0qqjudMZj2AbcnUKxpYR7gasMHT/Tp5IsdO9KnQDxHikSGYi/MsM4InpsC6rdGTQ2QaX7TYuDC3+LCsOSBoqoNRwpO+lcu34S54+C/lVYP+oyF8ma462jsc=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PR3PR08MB5819.eurprd08.prod.outlook.com (2603:10a6:102:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Thu, 26 Feb
 2026 15:57:45 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:57:45 +0000
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
Subject: [PATCH v5 09/36] KVM: arm64: gic-v5: Detect implemented PPIs on boot
Thread-Topic: [PATCH v5 09/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Thread-Index: AQHcpzilUvdE+ac9kkujPr4tKP7Eig==
Date: Thu, 26 Feb 2026 15:57:45 +0000
Message-ID: <20260226155515.1164292-10-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|PR3PR08MB5819:EE_|AMS0EPF000001A4:EE_|GV2PR08MB7932:EE_
X-MS-Office365-Filtering-Correlation-Id: 37d975db-2f0a-457f-452a-08de754fed3b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 q6A9C6IQCQHNLjT5NYlv5lRX14GgTyXic8JbmYjRI8pOkZMYacLW8lkqeZFYygDN1c3cPVw6BZkQhyLI6M2JAIqkg/uEcLwnPbiDq3KT2Wtx6KEmYOU/BMsXaVdKCsN3XmAMzA/5LBYXXQ+KO+WFPeOeMGOKDOSKtGYrSQ9tupO/gas8aU5YDrLWrPAKsOlQ+k2hjXl5PooQD7r2NPi4FcapeOs3j0cC7Aw2SoycQWTbVQi10mKRNIuv/2L96PbEfHcxElVtJgYyd3SDI++FurNqG1Vmp+FzuZtfz7l9eElEze7f2gGPavKpuqZ19Cko4VPeMlJ1LoqUKqSemt82LMe0AHccxnAjJGBfQ6Ez1r43EwVyUXaMMh+HVU98kICJmw4zeYy6TwvXK92YB9dcHjNhna0CFJBswBL7dLxNO/AmvSK/Y7dWM4dd+/P78oKbZ7PEqAu9W6PoCAIIls678d1NzFPqPGP9GVykgNvbm8XltP41wScY4z6oRUbWScJvfUj50Zfal6thGNSM7Jl/XY2aGM/JU8dAEx93MzCpGMeJzk1FdW75rsoOR7MOMSn9peXO34yqrQmDNEHb9A4OW1PFbqzuxOVdmMqceYm09hdRcubhelUX4NgSW3xrG33r7/wh38JLsCOmsI+oMKKsxTMcf0Pk5EhPpi3qRkCChEbyDiz4vIpSXgQGFc17XU91myB8jmVz76CQxUVVFBify/O2k8k59km4mRR7Sw431rG78iP2qzduV+d/AVvjvyr0XXNU6T0rxBN646JHoirh37nBeISMYTQJ2pM6JAlWbyM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5819
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A4.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	54013cd0-395a-475d-4c31-08de754fc7f4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|14060799003|35042699022|82310400026;
X-Microsoft-Antispam-Message-Info:
	4H+ivQwe0QnfWHRAWZt0PLMRiPQLj+ZqENJ8ByJnivfkq5dB3FRmBWWuXD0hXjijzXzWki8bUAf8RfXtPCPGF7nxi1zhHHt3jOu/ytQQhmaFbgsD/MSkufjEnN3fJuF8vfxzVDHnHyucttwjGPghmY6jF+BzFUVOL7Q1T6QnhQgnH4NtDyumKKgZskxwd48pQyNxDHH3hcNTVar2N/J95AGCA9olXbqucsh9/PaHIT+WcRxzFprSPqnM/sYOSNNkALoabF9+FPfoZEmNG5lqxvzWR95ZerHG3h5WUI+FI+UhmUYY2tIHCSh+nfO44Od1ItnYMRBG1v+DmhMpOTTloIF60juGFxB481Rxpbj1fTt7QY3teeIU8vUpdm55xDExRtoHk5Dp2KmDTg9Wf6mXkhbFSTnVBkN72smRCdT/T3WSWGFUH+1LUeKJj3vXM4dQrX0rpXrGjQuJX05UjmUE1dTj7q3Oov/U9CHldu+SkFPothb6+xP218Mb39tVJFUB9Xk+G82W4ly5hoK/jLy+YTal4BjS/5yLgX2Ls+yVRoM6kMWG7IK+yARi5vKXnFlZpsQzYKOmnYscvMLvQd58LBpBrmvq/gBXJWgAj1L2KwTnGPsX96JeAo8WoA6QxMQFPElqRB/9XqppFRbERAhzKjgRj0SqQGaWVMCE5QS/suiNv9Oeyp9bXL+ptfYYwMv328G0ymZw5mQHm8vNH/gOktBpF68bXHuAMnFCO8ny0f2tG+yD5G7TgzTCfdXGPvkgYP2NbZCaQ1s2plGU8jcs2LnPkLqzmQdapmveikLaYyXIOamCzlFoW7yHIch6cL7PVu3VYHquSIeP96kraezukg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(14060799003)(35042699022)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rnIIwmty2chaTTTcf9NK5V2sGaCE81ULBJN5hpY+Rtpb6q91AeK6Gjo7D0DBcwVW25ZT06pl+HOPp3XA/4TFfXHkOQBEW2NN2j8CkxFBZfop5NBSjO7urNzUlgYpdVeLYr0Foz4gxOW//3DQocVAJiIEAnQk28tZ0jGustR5NaPY4JSpB6CkIlZWQLJ+dD/fRH6t5LrEQ5CheAHNUwvvIvBaaXWuYPppVA3zDuMaryuKbrgTrVcN1KzlY+O6MLPvZpLkNagTXPKulYkPdEC6TTomqmA5SI7IjbwTRefkkGlHwL1/RwIB6QRkM42d2Aid2Qs8QuUaiyBhX+0dfcm6kXVOJSY+uM6Kg9/KoK17+N3dsNum2Fip2mNCfSnUvCNM3xHNYiEYDCVRSv422C+juY4ZI18ukygXt4XQF5EGRGIhG6OTrd3DAoXDiq2M+zXm
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:58:47.4590
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d975db-2f0a-457f-452a-08de754fed3b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A4.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB7932
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72027-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,arm.com:mid,arm.com:dkim,arm.com:email,huawei.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 92B821AA119
X-Rspamd-Action: no action

As part of booting the system and initialising KVM, create and
populate a mask of the implemented PPIs. This mask allows future PPI
operations (such as save/restore or state, or syncing back into the
shadow state) to only consider PPIs that are actually implemented on
the host.

The set of implemented virtual PPIs matches the set of implemented
physical PPIs for a GICv5 host. Therefore, this mask represents all
PPIs that could ever by used by a GICv5-based guest on a specific
host.

Only architected PPIs are currently supported in KVM with
GICv5. Moreover, as KVM only supports a subset of all possible PPIS
(Timers, PMU, GICv5 SW_PPI) the PPI mask only includes these PPIs, if
present. The timers are always assumed to be present; if we have KVM
we have EL2, which means that we have the EL1 & EL2 Timer PPIs. If we
have a PMU (v3), then the PMUIRQ is present. The GICv5 SW_PPI is
always assumed to be present.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c      | 30 ++++++++++++++++++++++++++++++
 include/kvm/arm_vgic.h             |  5 +++++
 include/linux/irqchip/arm-gic-v5.h | 10 ++++++++++
 3 files changed, 45 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 9d9aa5774e634..2c51b9ba4f118 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -8,6 +8,34 @@
=20
 #include "vgic.h"
=20
+static struct vgic_v5_ppi_caps ppi_caps;
+
+/*
+ * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
+ * ones are, and generate a mask.
+ */
+static void vgic_v5_get_implemented_ppis(void)
+{
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	/*
+	 * If we have KVM, we have EL2, which means that we have support for the
+	 * EL1 and EL2 P & V timers.
+	 */
+	ppi_caps.impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_CNTHP);
+	ppi_caps.impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_CNTV);
+	ppi_caps.impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_CNTHV);
+	ppi_caps.impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_CNTP);
+
+	/* The SW_PPI should be available */
+	ppi_caps.impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_SW_PPI);
+
+	/* The PMUIRQ is available if we have the PMU */
+	if (system_supports_pmuv3())
+		ppi_caps.impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
+}
+
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
  * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
@@ -18,6 +46,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	u64 ich_vtr_el2;
 	int ret;
=20
+	vgic_v5_get_implemented_ppis();
+
 	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
 		return -ENODEV;
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f12b47e589abc..9e4798333b46c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -410,6 +410,11 @@ struct vgic_v3_cpu_if {
 	unsigned int used_lrs;
 };
=20
+/* What PPI capabilities does a GICv5 host have */
+struct vgic_v5_ppi_caps {
+	u64	impl_ppi_mask[2];
+};
+
 struct vgic_cpu {
 	/* CPU vif control registers for world switch */
 	union {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index b78488df6c989..1dc05afcab53e 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -24,6 +24,16 @@
 #define GICV5_HWIRQ_TYPE_LPI		UL(0x2)
 #define GICV5_HWIRQ_TYPE_SPI		UL(0x3)
=20
+/*
+ * Architected PPIs
+ */
+#define GICV5_ARCH_PPI_SW_PPI		0x3
+#define GICV5_ARCH_PPI_PMUIRQ		0x17
+#define GICV5_ARCH_PPI_CNTHP		0x1a
+#define GICV5_ARCH_PPI_CNTV		0x1b
+#define GICV5_ARCH_PPI_CNTHV		0x1c
+#define GICV5_ARCH_PPI_CNTP		0x1e
+
 /*
  * Tables attributes
  */
--=20
2.34.1


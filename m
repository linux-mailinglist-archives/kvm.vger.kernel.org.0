Return-Path: <kvm+bounces-72037-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OP7/Dw54oGmtjwQAu9opvQ
	(envelope-from <kvm+bounces-72037-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:42:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 00DFA1AADBE
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:42:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A8D2D30E77B6
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87369472789;
	Thu, 26 Feb 2026 16:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HUYuNzng";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HUYuNzng"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011006.outbound.protection.outlook.com [52.101.70.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E36477E4F
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.6
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121684; cv=fail; b=HLqILssXPJs+6Q6yFSMuRxDnCmfBNrgkKQwv3is7pPaQGo814FIy8JC4ovOeQaDNUDObxYbs4alGCC7l0VnD2eXKSa1gbSGJOxNIEf1b+uCCZ2K3/+PjGEPNM85O/xqu972DZvh2fDI9W8Z3EkECVSWU/0r0WdB6tI4aSlK9T2U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121684; c=relaxed/simple;
	bh=Iva9F9CHyCZuDsVYInaCZeYJf7r0xDGbJhAfgDfZZJs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DMuP8LtwtpJOYj1wadmJFIk96LvZdFp/VExgwuv5nl3lTK+Ey5QStGqlN1jrnJs3f+eASkDnqH0bO2Dm8BmyQr8Nvdl8Fvreok/KfCkouGI7h70LKVM5VqxY09Bn9pcSh3FouTWKQO3uliRzXbF9U+wfB25UX8G9AoWqLuk84wg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HUYuNzng; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HUYuNzng; arc=fail smtp.client-ip=52.101.70.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=j98jV2H2dJ975bOnzJ2hYEANwmp4OkEGG2WeDaX9Hg8E1lHHqcAPGK36gn/ehwKWZzA28P2ChEP0IMd9V/n7zXWVmbfg2QRl+U1xdc+VaJmk23yHciL/OsS3iWpwX8TtDoULgRXnTVDi+NHOWbKEUQnP7wrVgFgLFkFngu0bry1E5T5Tte5GW4A3t1qP1jGw3H10LyqGRuenmBTQ+T9+MEdbmej8C2FQAyb8tgShqq9HIzrilytdtPHSFHGquDo9DEf2ATSdq33XB0eHhkJiQR8lmP8UBaVY2CJUBx4b1L/QkftEIjaN7C5OYSn5Nvs3mSksfpf0mNALua8XZUtALQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbp4kQTKTXKwi7ICbevPJXRwRzPAJjQIVXtDslb8Hn0=;
 b=m/e8u6Uv+7UitABpPaDxBavgdvK9lpcENUtEXNF067+HXkUTBM8zEQSwiIcgKwsAkB6cdiDbCRf17V3YnLRTHGrYPgMU0OxNpfZ9QXrFLnMtukcR4jl1H9niUdJP+ud4NM0EewMNuI64vE2352KALAung7t7LPa4J8c12DXgnVg05Ypjue0VQss2PGoTBUloODjM2tH4b+J58tU1/J2KvfeJiBRFfI49Znjn1QgiQPTBggiyMWMqUuEL58ML7zbzwDDfqqb88w+gpY41M42Kgt8DTSTL5JvC+ZRz+kODxYkYT6m/+K9pjwzIBeHFPgnWvZ01qEmAENp4ZtI0xVrKpw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbp4kQTKTXKwi7ICbevPJXRwRzPAJjQIVXtDslb8Hn0=;
 b=HUYuNzngtn91F5tWymIPN3lZ+NjSUlbSi3qGaVX4L3QR7GVxd+x5g4JWHLlI7os6tKsWZ4UeZORzAiANbtzHGmmmRrHSIWSi2pNeAS3X1rdFxOPJPhwfAfsanyH1eOfcpPCfn1xCkKU/v3JkZSqFogSkgX829WnNCIToAH8EHfg=
Received: from CWLP265CA0299.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:5d::23)
 by PAVPR08MB9554.eurprd08.prod.outlook.com (2603:10a6:102:313::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Thu, 26 Feb
 2026 16:01:08 +0000
Received: from AMS0EPF000001B5.eurprd05.prod.outlook.com
 (2603:10a6:401:5d:cafe::83) by CWLP265CA0299.outlook.office365.com
 (2603:10a6:401:5d::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 16:01:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B5.mail.protection.outlook.com (10.167.16.169) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:01:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GA9SKXzzITvMfCPyGOs0v+y48dVBSBKOTQJTcYp+m7lp1J0z/hAKHzALAuNyvBFzqUAJyoOBmR/S63K9LrACq8HDUCZ6gu3Ne9TEdsPtg11MHY07LvkD6lSOcUVNrNoN+ZIPxXJ7nf845f9SFzkLyEIOXdv6UH9TpTz0bANybBCrzBs1a612pvYGYmyGcVy59YnRC8Z1CoLnDd6taB58XErZXhfHTjUOBvu15f2Bs9Yx0PMv1ZxZ/iVSZwtJpshE2uuot3dpvMTfzSpnO7MqCVJJSwB4VOLbASa/Z8kFQ3fG2ocUDINrzZFb9c8PRTeBpiLrAuIYYmlBlA8NjsUQqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbp4kQTKTXKwi7ICbevPJXRwRzPAJjQIVXtDslb8Hn0=;
 b=AUQLrMARnEFTQCR3ci7BOmMj/BstDZ6/DZF8g3HVjErCEqkbkGnEq2rZa0oGDgKtC7vocfh7H/e5HFRRxAjbAOv7ODDYntwthHuT9V8z97UdgQLRjhJGfjar4m3CZTuRXgGNJ+3VF/Z8ulb13HAL36ctOXN95L3YcWOhk9lXEB5ST3rbc3NWqz21jNL2JhkmzQA4fpkANZKTCy34dHnVW5K0+0RXlQqjTMih+kuNLMyN1SkzhHMd5AQLOdMR5cvqvSBSclsSyw21O3p6mmVhLcpt3Y7g9WSpZFAHKEqUn0Anpy8zMFuhdvLKQnUcb3FsAPcFAFB8k4BPVMgdS/xauA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbp4kQTKTXKwi7ICbevPJXRwRzPAJjQIVXtDslb8Hn0=;
 b=HUYuNzngtn91F5tWymIPN3lZ+NjSUlbSi3qGaVX4L3QR7GVxd+x5g4JWHLlI7os6tKsWZ4UeZORzAiANbtzHGmmmRrHSIWSi2pNeAS3X1rdFxOPJPhwfAfsanyH1eOfcpPCfn1xCkKU/v3JkZSqFogSkgX829WnNCIToAH8EHfg=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by DU0PR08MB7486.eurprd08.prod.outlook.com (2603:10a6:10:356::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 26 Feb
 2026 16:00:04 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:00:04 +0000
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
Subject: [PATCH v5 18/36] KVM: arm64: gic: Introduce queue_irq_unlock to
 irq_ops
Thread-Topic: [PATCH v5 18/36] KVM: arm64: gic: Introduce queue_irq_unlock to
 irq_ops
Thread-Index: AQHcpzj4z2IYfRlruUKfQUOfl8rB7w==
Date: Thu, 26 Feb 2026 16:00:04 +0000
Message-ID: <20260226155515.1164292-19-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|DU0PR08MB7486:EE_|AMS0EPF000001B5:EE_|PAVPR08MB9554:EE_
X-MS-Office365-Filtering-Correlation-Id: 6770a314-2b5b-4eaa-c341-08de755040a2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 e2F86hWxvEVYhamnJUHIB67tUupFV4U1ytrwLnfMscMGzOwkMe7dNSyJnEn9RwwomBNGdPAumcSPAbStjwmzyzVhaSEG952HiFIgpRqD65Jqly4pxrLSOKJiR0ydQ4UfbjmcHTgWmV7tI/8r6suC4PWjcaewDL4P3PbpfoHONxGqBbGR6gNJLowN4Mi5rtVSqT7ggbQRr0ZK9kgVDSh6YF2qhUtKR+RV4MeM3AbAd58kcWpuq2+p1CBAzjoPfnPkrbB2YpqWW3m/5/1sHB6WXO07O8yM/c5P2XwFGzkFl0B4XtkTEDV6hKX1ufxnMzdp2NFsg2sm1yRHKKchTvadbm/h/lgZiDie31+Kd6hDHvHOmSrQUvdQJqBl0uVuH8YNboyDUyFOXNSadn4u9eFORmagwKUaSzGnMav3ut2ER8BsoXhW/Sq8k5pda3pSpKIU2IxPLQQy25AjtEDxqUQE5dl21PvrOfmtZOPrP2GPw/awnE9KVjdhPhq3lNhl6iEDPl3mYm1TILlwA5WHpJ+swhC2ygX+9/CJAtHGnWc45acc4iGHPDQBuxYRou2v+OVfbHecZD/KyBGV1yuOxMpFWle1Lxi8jUVX2qen5MbujtQj5tFqqfE2uIs0drw5iHF8kXZnB9EYjdVzdhptOIIiaIE4ZslarmGI09mgwoAuhKVeD5vMn5MRkyaOXlssSN3N5qiRYc5WIzpvHJ+Bv07F4f/bcuXwERaPa25rw3vi07w6gVYNbg0pL1Zwe/WAsEmPAdsZ5TzZ+iCvHRHx5ufxQwT5lcLmNm3UZvD+V2qnPZc=
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
 AMS0EPF000001B5.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	78ba1223-7b83-4455-09ed-08de75501af1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|376014|35042699022|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	XxX8ESI490Z4iuRwQ2UebRHehq9YCpnWzrSdTGxXq1RlSvvhY9d2jVPhX0zGnF2fGNCP6bfHWx8ap++Q4yu1RVJIU8CCyWmNX4NLTn4cj5UB4ccmioIUFP86Zne5xKjZK1UNYD+nDXIitNwV0w6lOx/9G/YHgYYelEQNtwrKxkRSDC7+1K/qOk4U5hmpb+URMYrUyGmMkvGwQwg280hP+ryEEvRBpQtSeq4XXoiuGS4Q/rbygQLRZjVB4KyZ9O8cV+OalJmdSsID9eVcUKXSapOOxLwp2SwNM+HmyevX5LV7bZ2CsuTloYV7/9DAn/sOHJ9rQinlNjIQvhiWPgMMlFEifKqAheJA++IZTiazW9HvUhskg24XYYIObz6NPgTAAh/KhTwQQvTy8fNr62jKXlK4TuTmyqxng/mgBFgw2hJCEpzrm1+PvXj/qLREG23eZWpE8AqwBZtscI4clV84SmLkI010Ir2qPZk86ks4fgjqYscxvLArel7MZs5yhlImhp6qEiUaoTh4zgcj2gRMvwMaE0/MAmZIQ+ktaWHl2hmUY/oJI+HWfsHvNvvrzZN6NKJnMryjZ4bXzroxwyV4SuCsmoBrmpQUfNaoaacpep5sfK+Q5FQit6EDzIZ4rO599SZWsdsATGwrI6dAJxAVLv3/gAdbJE0ca+vuOP7cLmqg9ctb8AHr6JKm+8hVgm+NTvI8zrVAU5KdLtjsT8LqaCznEREOSaJ4lL0bLbHTSdM9CpupMuMbgroJ/xEilMMejJsk5GyN9EBVhCK6t4KVKpgSZ/EVCkYFVX1dcCYHkSJd3ioq3sjAQxjI7OTVBcqdUkUG9yxBuX6LFXnuron2dQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(376014)(35042699022)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/RbotjWs/wLbK4RPr89UBWUiZ8MTCGEpJC+gWUUvG1YC1UNhfEGLTFDU3IFTbEUJfkQkGsFiCdA393ypCWrBnj8Plm2lKjClRi1tsHb3g3GfC6yp7AVPMkhmGspip5NpjRq3RuMXGhq2BsqgSqMaJk0+mb4psDNUcd9D/goeNLFiAgv21WXC6A34MfJcBLEzErknqqU+wEGFhr2+7J9Lo1sj0lGdXJVLZ305n+P1YXWyseiRtmf2cdT85aCZhxRoL5hEeLmXcCQI7mgoXILXCvBZHyg827moPceyjnT098UgWbu9vqfdiOSt1nMJDnXgkl/WZ4yiOWPuXSMKZSxqiF6bAZ33RQaoNAzjn5+6cj3xqbAUpYrZa7dMmd7EMGVzwc2cClF7WtIkyUFXpKL/RXHzCqEiiNh7jqnkkKlAaimWGOQC3Q2wa0a9W1AWXhfE
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:01:07.4418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6770a314-2b5b-4eaa-c341-08de755040a2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B5.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9554
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72037-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,huawei.com:email,arm.com:mid,arm.com:dkim,arm.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 00DFA1AADBE
X-Rspamd-Action: no action

There are times when the default behaviour of vgic_queue_irq_unlock()
is undesirable. This is because some GICs, such a GICv5 which is the
main driver for this change, handle the majority of the interrupt
lifecycle in hardware. In this case, there is no need for a per-VCPU
AP list as the interrupt can be made pending directly. This is done
either via the ICH_PPI_x_EL2 registers for PPIs, or with the VDPEND
system instruction for SPIs and LPIs.

The vgic_queue_irq_unlock() function is made overridable using a new
function pointer in struct irq_ops. vgic_queue_irq_unlock() is
overridden if the function pointer is non-null.

This new irq_op is unused in this change - it is purely providing the
infrastructure itself. The subsequent PPI injection changes provide a
demonstration of the usage of the queue_irq_unlock irq_op.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic.c | 3 +++
 include/kvm/arm_vgic.h     | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 62e58fdf611d3..49d65e8cc742b 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -404,6 +404,9 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic=
_irq *irq,
=20
 	lockdep_assert_held(&irq->irq_lock);
=20
+	if (irq->ops && irq->ops->queue_irq_unlock)
+		return irq->ops->queue_irq_unlock(kvm, irq, flags);
+
 retry:
 	vcpu =3D vgic_target_oracle(irq);
 	if (irq->vcpu || !vcpu) {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a4416afca5efc..f469ecea959ba 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -173,6 +173,8 @@ enum vgic_irq_config {
 	VGIC_CONFIG_LEVEL
 };
=20
+struct vgic_irq;
+
 /*
  * Per-irq ops overriding some common behavious.
  *
@@ -191,6 +193,13 @@ struct irq_ops {
 	 * peaking into the physical GIC.
 	 */
 	bool (*get_input_level)(int vintid);
+
+	/*
+	 * Function pointer to override the queuing of an IRQ.
+	 */
+	bool (*queue_irq_unlock)(struct kvm *kvm, struct vgic_irq *irq,
+				unsigned long flags) __releases(&irq->irq_lock);
+
 };
=20
 struct vgic_irq {
--=20
2.34.1


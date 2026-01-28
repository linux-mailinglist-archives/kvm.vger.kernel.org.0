Return-Path: <kvm+bounces-69358-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2IT6JUxHemkp5AEAu9opvQ
	(envelope-from <kvm+bounces-69358-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:28:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 402B5A6E82
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:28:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C7552301BD61
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 17:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F9234DCD6;
	Wed, 28 Jan 2026 17:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CMVhlsdZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CMVhlsdZ"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013050.outbound.protection.outlook.com [52.101.83.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C470534886B
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769621292; cv=fail; b=Cv1wJZZDafv2KEESyQ0J/+WmGROHK/hUmFePRyMUaBL3UQygvZOV1mcZg3kxvmKOU3tYHxBocFVf4+iYNVhq0a4yLGp9MhjgcBfBzrtQx6Tr+/eBOGQtzDsiGmdxd0QZZDNlJqHtoJWYcVm7sT9Hiw/selh6IBATZX4Km3vH7rY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769621292; c=relaxed/simple;
	bh=Hg77NGBPhJsFHQ+n1j5idcq4imas/raFhPPalx3nxkA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nVFyUltjkaW4NdNN/Y5wEmHRwUuZy7uaBJouuLPXZW2cJiHIgN9acn2jcBC0bR7g3di7IxOR36zcrx00mae74jogM/anjEsmZnKbF/5IgDrUHai76Ud2qLIJ482xnWUS6pLJsWJA7ePr+a8iwXb6KfYvGUULUG4rbW6C4rp/HuU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CMVhlsdZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CMVhlsdZ; arc=fail smtp.client-ip=52.101.83.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XRjJlTcTIV8r1nsR5+R89ZTqtIBn7nnZvHlc9cLabDA7exMspHvJVt6GIiqV5OKV5FSc/tIifzBUP/j3oMWfxypv5bZ1/+iUn22sjOagnNUuMAqsQWEewk260JuWpa78/6briOJ0eHYPwVhtMN5ouyLT3vfiyLA5ci1T48UXPmu9we5idXUcsnJpSnuoEthQS3nnFPGaFwQLMTB5rpYHdjRcrpNzrcWAinwqOtCYZp2BsM0po9RHNhDQHGfzI6gs40e2DlwKm9WrBJePCOrQahu9KVSwZ0bL1r9lY+fnmY0ylCVEbIpNzlnCdB8NJq874rO2Je4q/MNN2sJuCU38Rg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hg77NGBPhJsFHQ+n1j5idcq4imas/raFhPPalx3nxkA=;
 b=SqwM6lihOEa4UaML0S/dCc99zNjPwhFlybh6C5NDpjecFbXi1qtQ70loI5DULaof5+zEy2y/yrmexg6nZtACjQwAjj4ews75CHEsNPrlQP8l/aM72cOiysgBI3q99DVy/3wlqOrjaAPjH4rzXDpYqZfcraFrly+w3FAIVGRnFVeNe0KWb7fSYuQnr3A7hzIcA6NkJ1GVN1sam1kBghrMMP37Q/rq15ZLtyxqxhUAHZM0wJtbePI7Gy1g9mn8p+oaW1HGHshguz+M9XPv8oi5xCdNyfm2H6ZWlLKbrb3epr00kL3kloQlXaQ4o9S1V5p/xynmCIpFbu5wvZ3wO1fr3Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hg77NGBPhJsFHQ+n1j5idcq4imas/raFhPPalx3nxkA=;
 b=CMVhlsdZQmL97vpRyjpNcEgS8n2cT7eGUvl+3pp/33kOIOqGlZq0wbp/FaedE09vW+HjrfyX8pLwvFnu3w36curuom3n7hCujvD6W3A0kwy6Od4xHxdJLv4NMvxAV6KW6bYWheVNsjKVa2NhtEfQwwkyM4xmhgveXhj2Ot/IqNo=
Received: from DUZPR01CA0209.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::22) by PAVPR08MB9064.eurprd08.prod.outlook.com
 (2603:10a6:102:2ff::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 17:28:02 +0000
Received: from DB1PEPF0003922D.eurprd03.prod.outlook.com
 (2603:10a6:10:4b6:cafe::e0) by DUZPR01CA0209.outlook.office365.com
 (2603:10a6:10:4b6::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Wed,
 28 Jan 2026 17:28:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922D.mail.protection.outlook.com (10.167.8.100) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Wed, 28 Jan 2026 17:28:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D12JQLamX0JIsB6G+rdpPxXDIvAZiP1MKBp/gcniWg1Dj5ybNlPbKm7ghI8GV7/fVtCUdUHxqK8J06e4ckaNEIExSSqljfdDXJBJUghqoBmLhzIubZkMhN+3gG5OMbfWXNqX25yd3DAG8jr8vv/H9F12iPE5pF0iSdmtMaGBrW28XJHxsiDCGx3gRXf0uMrjfUi0O9Hyl1Bw4DQGIy4KVmiEYc4NxFC7h+YLvlt7v+vsC3rN5UlKL4s4Aibr0VkzLmRy+bE+PjiET1JbKQI1G/EnCloiRAMZMb6O9+8dRV5/0KVk8LxHsosPcCMPO7wAiuBsEL0crvQQa2BePi94eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hg77NGBPhJsFHQ+n1j5idcq4imas/raFhPPalx3nxkA=;
 b=ZTbq+oTk8ssnZKJZmpnEITy7zF7lhszTbJTdyWXU5Unrqx8dktfcUciLxb40Nn++VLSyQJ3OOvoCc2rBvh6wzMPHqo7bcOnnjd5o3v8AvzP5GMa4in8sRqvNN0AplvHo0f1wECNaxw/NkoRMRLZ6ws7q4WYWsQlIvEB+9adtHvNe/A3KDt3DtTvaXzURM1GB51xskx2VFSOpFkzvVN0asyKzHRUIaZSroPPDo0EFp0otjJL79yQ0ikmebDSuGJtHhrhVelS2ZNt2a4/RF5P+15yRjLSmrKwbbYO2crKP5GTQBBjEsYvy4HRMQoZVHeNrQ2jbEC5gsw9aAZ1ZY9Hmug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hg77NGBPhJsFHQ+n1j5idcq4imas/raFhPPalx3nxkA=;
 b=CMVhlsdZQmL97vpRyjpNcEgS8n2cT7eGUvl+3pp/33kOIOqGlZq0wbp/FaedE09vW+HjrfyX8pLwvFnu3w36curuom3n7hCujvD6W3A0kwy6Od4xHxdJLv4NMvxAV6KW6bYWheVNsjKVa2NhtEfQwwkyM4xmhgveXhj2Ot/IqNo=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PAXPR08MB7334.eurprd08.prod.outlook.com (2603:10a6:102:231::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Wed, 28 Jan
 2026 17:27:00 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 17:26:59 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Thread-Topic: [PATCH v3 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Thread-Index: AQHcgYoKQmAReHHObEiGZ+Gkrz2rHrVOlG+AgBlfGoA=
Date: Wed, 28 Jan 2026 17:26:59 +0000
Message-ID: <1b255611c7035c527fb7eb382cef7b65c84e7f38.camel@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	 <20260109170400.1585048-3-sascha.bischoff@arm.com>
	 <20260112140007.00002391@huawei.com>
In-Reply-To: <20260112140007.00002391@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|PAXPR08MB7334:EE_|DB1PEPF0003922D:EE_|PAVPR08MB9064:EE_
X-MS-Office365-Filtering-Correlation-Id: 28106643-c552-4fa2-a3cc-08de5e929709
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?RGcrbXA3bGptMGRXTVc5SWxoMTRxR040MW5FVDhoMmp1NmJTUlUzdWRQTHRu?=
 =?utf-8?B?aFlXY2FydzdVVWx3Z0hrRlJUdlpCcThvQXYwNStYekxFZVdJMWIwcTVaTmN6?=
 =?utf-8?B?cXI4c3QvNk1DckRMeCtIenlYMXppZWx0bHQ3QmJQbWRPMXhPc2s2NGRxS3Rq?=
 =?utf-8?B?dTBSSDYyeGRlNlJ2Zms2NlI0U1ZzUXhsSUViQjdTQXZCRjhTNG5qeWd2SXFK?=
 =?utf-8?B?MTJ0OEFSamRvLzNkTnErT084WkxwaXVqcURTelMwTDM1cU5rUEZYallOYk5E?=
 =?utf-8?B?WkpMK2hOL1NPZFdyZk1DYm05ZnFkTGhMMTFLRjQ5aWRYMGM2TGdMdDdRc0Vu?=
 =?utf-8?B?U1JGS3RZa0ZlaXlRM1ZFMHlydFcyMC9tRkRFK3dzWW9EUm9PbllqMHpJRkJ0?=
 =?utf-8?B?QVpybG9NWlZXOHhWK2FtM05FVHVoZUttVmF4VlRRWElYL0Z0QThRVGJDSHJj?=
 =?utf-8?B?cW0xbEFOd3V0dmVuNVpHZWhVU05Ibk1ZemlkUWQzN0FsekdDNTMzOG5LbHd5?=
 =?utf-8?B?MlFQOGlZT282MU9lRTJlNVMzd2dxNjBkSjZlSkVUNnk0M0I3WFJaRDVFZlZB?=
 =?utf-8?B?a2NVek1VQm0yQ3lHM3ZPOWF3VnQ0RmRNUloyeEFJUDlOR3RnQTc2di9vT0Za?=
 =?utf-8?B?RzhYbVFhcU0zSS9QbklXNE9uclhWV0I4NUtUVCt4TzlBS0lUYXhyZ0lDSGps?=
 =?utf-8?B?MFpvb1dzTWE0dmxsd1lVWHkzK05mOWMzUXFKeGdLbkZYNHZsb1Z1eHBSeUQx?=
 =?utf-8?B?Wlc4ZmlsT0cvWmtwK0ZMZnVkSTdjSVMrN3l4MlRhaEZKSG93WE1ZOXdqMm5a?=
 =?utf-8?B?eXUxZ0s1M1gxRysyUE9MT1JYdXlIUjFnTDZDYzI0NXFvTmpaaFh1bVFjVWpj?=
 =?utf-8?B?aXNrVFk0aDBycVN2cEhYWkZwNEk4d3BvdlpuTlN3UndZZUJ2TThGQmVpKzlN?=
 =?utf-8?B?bjB3UkFiVDgzYnlyL0xQeG1NVHpYRHYyWjQxOGlXZFdVNWVKVDh0ajNhVTJO?=
 =?utf-8?B?OG5SN2krV1NLOTNIeEZHWDNmalhsaVVtM2hiNUNGSWViSXFxK3FxbmdlcWVT?=
 =?utf-8?B?TTkvTWxXMkR6MVJhK2xoSlFOR241SUJ3ejhaRW93VFdEQ0ZkUVh0VEJVQS9D?=
 =?utf-8?B?VTJkZVNBaG5LQUNhWWwxQlhHbHUzLzQrb2M0QVJHM05UR3pNbmo2REtpekwv?=
 =?utf-8?B?TlNvZWlGeitPOXlwZGFxRjM3QklCaU8rWnVadnZzSlR0NVVWWXIwTGttd0lG?=
 =?utf-8?B?V2ZxN1RTYzhvaVNSUEZKQW5DWnRCMDd0MWd1RWQrR08xeTZBVWFSbUkyMHVP?=
 =?utf-8?B?eVBxSFhGZmVFd1RodUV1V1NTNitqOHJHUzBqSWIrNUkxR3N4MVRvNDZGM3FZ?=
 =?utf-8?B?ZVFKVE1YYXpENHVDOFJCRk5XemVlMlNmUmI2Nm5JN1UybDJobkl1OFpNRWtq?=
 =?utf-8?B?OEovSEtsVCtMWW9SSFhyWmxoNG52SFdXSzU1VlJuWUJwMlNNelo0a1F4TmR4?=
 =?utf-8?B?THRuQVhEWUxRMytQc2krSUpoeGhxNWNYeUFkSG1hVnJnZ1ZpdkRjZXh6K0V0?=
 =?utf-8?B?VFE5UmJIMXJvQS9MNkxYQndpWXkyTnVSN29HdE1zakJpVmJlazh5RlVjRDNZ?=
 =?utf-8?B?TzlVZFhDeTRNanRFbFcvMm1zcGc1K04vcld1UWt5YXpFQ1lsUGZxc1dRSjR4?=
 =?utf-8?B?Q1JUK1R5Ym1yRHRuVFpmYVFEbXZJWVhiYUpxdUdaajBlS2J5NVltRDR0THRw?=
 =?utf-8?B?OTh1bElBdk5Fazc5NytuZWZYU2ZXTTFHeEowYjBzRjVZWjdwNUFueGU1L1M5?=
 =?utf-8?B?cjJLRWU5YnYzZ3dOMDhFQ0VPZ1pWaW84bG1iWk1qV1FJM3YwRTJxb3ZtV0tk?=
 =?utf-8?B?S2pLeG1CNXFIYjlBdFh5ckNybC9rNjFXd0xjYzNpNElYYzNCaCs3dERrbGF5?=
 =?utf-8?B?M0gzUUhsYVJwZGQxVmVmTDBBaENsSXgwZDlENnJ4TERZN0hWTlU4UTNnZjR3?=
 =?utf-8?B?SHllOGhTL0JjVkhldkhIbHBWemdjb3llZ0N3cmJuUkhIQmsxanI5SVBGZEkw?=
 =?utf-8?B?OGIxYitDZEgxenR2K3VDZFdpUXRpUDJvQ2lodmdTSjlrUU1DOHhodU05MVZZ?=
 =?utf-8?B?TFJteVJjZGVnUERzWS91dHc5dFI3YXNoOEhHRExXUHQxQUdwb25YWnRqZkVx?=
 =?utf-8?Q?KW5NVWBMJ9imUStv9a0nqMQ=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB29CD140DA9894CBD1BD276C74C80D9@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7334
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922D.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2e92e144-03db-4d41-4081-08de5e927195
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|14060799003|36860700013|82310400026|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QjVkZVZJRlg2dkpmY1B3ejI1dE1kK0NQNFUxUzJGU2xwRUhIajNjWVg5RHB5?=
 =?utf-8?B?cTJodzltN0c3akc2L1FLVVMwQjRHMk5KZmdlSGU3M0czNk05dGtWZGd5aDZ5?=
 =?utf-8?B?RHdYT0dlN1ZqQWkwNzlvcTBYZ2JQd0NzeTdEbk53YlQ3MHpiaDdvZFNtTjR4?=
 =?utf-8?B?RGZFVGN5TVVBYjM4bjhzK3lIRVRIYVdYUXlXZjJGUUxrNEFSZjZPdDVJcmYz?=
 =?utf-8?B?R0h5cUVJb0xmNUFuNjFMNkhQQ2t2SXpRd1BUSElHUCtMbUI3M1dWSmhhM1d5?=
 =?utf-8?B?cVlVQ2ZVUld6U01hSldCck1SUTRlTTlEYk5kRXArYjZ5VUo4akFFck1EYVlX?=
 =?utf-8?B?cGtvNjRGY3hwWjM2SHRlQXRzZytEeTJvbUxXaklOQ1NsMXozWkw2SnkvckQ4?=
 =?utf-8?B?VUR3QmREYm5yTjE5WE9ja0ZPNHBoRnlwdHdRN2hIUXI5STR6RW5YQUpiS1E3?=
 =?utf-8?B?SEhhdnZoeE9OSEg0YWtSTVgzbWtjZ1FKM0xxd3hnck1WV1ZyL0oxcVRzRnF0?=
 =?utf-8?B?SU9BMTg1OWRQWkN4Q0JJMjR0QlVMKzVpOFZWV2NoeDlZbkdUYi9mRHJ0MGpT?=
 =?utf-8?B?bzhlM2NLZzNmVGYzTlBYNEluMGRuNkhaTEpjYS84WlNUTGxuenVPaVRwUVp0?=
 =?utf-8?B?ZllWTVlEZ016ZHZSWUV4cC9HcCt2VFdnMHhwYzBsRHVzbGx6VmIzd2hJbXJM?=
 =?utf-8?B?eUVOeHRNN0dWRmM2L29uUEh4ZkJJSVp6RVNwbWhhZ0JRaldmVXJkZjNFcTJU?=
 =?utf-8?B?bXdzdURoSW1VUHM3anhGcW10R2hjMU9wNmRNVTVxYUIyTmxEeXAyVHdkNGtt?=
 =?utf-8?B?TzZRVk8wd2dOS3NPcE5FV0xjVyt6emtOejJCNTdYcXBTbHJObURiMytETTVX?=
 =?utf-8?B?Z1BzTUExU25YenROTkJVdzNSaDBnWHN4aTRRNnFyMHM0QmtrM3Qvbk83NlpL?=
 =?utf-8?B?aGhGZkZiT2tMdTBsTTlqdU5USEFveXdZclV6Y0d5Z2loa2VIQ3M0NVYxWWNy?=
 =?utf-8?B?eEc1UUpTSXhxSHZtdWhuYXhSODlXYWxlR0l1MTdSdmRLNGhCdzAyL3liK09v?=
 =?utf-8?B?UjFlT1lSWHVwOEloQm5wSUF4TEV5ZWg3eGNiMVRaUTVJcDk2bDdMalBucTJQ?=
 =?utf-8?B?NzJ1QVlaZG9rWjhPWUFNQUlKWnoreDM2R01oZGJCL1htTHdyK1ZQK0VCOGFD?=
 =?utf-8?B?aE1tNEFtWXhXOW54LzF5K1B4UWhGeUVvWjg1RzNZdGxYakt3RVRFbkVsRmdV?=
 =?utf-8?B?MDk1NEtjVmN2SFZtOXRDUE9OYWJhWmpzVkpsaEFmeis4UTFTNU53UVUzMlVO?=
 =?utf-8?B?RnZabGhVL3JFa0xlcWFnV1pJdkRHZldBWlVXdkFRQTJ3Sk9BOFkvK1BWWlFl?=
 =?utf-8?B?dWNxdWdGSWdoaTFRZW5WbUdpUUlsM1p5UnpVcjdZR2QwcEZvalpnSk5PTW1C?=
 =?utf-8?B?SzByOExJbWF3ODYzcFhHVy9YeThyd3Y4WWgwcGMzOU5odkYvZkR0a3VsWEpD?=
 =?utf-8?B?SFZUMDlnZkwvUk5hMGVJSlcrZzkvNElqL0MwZythT2RJUTU0THdjczNzdGx2?=
 =?utf-8?B?ZnNrT3ZISlluaEZkWkJwdmdwR1J1S1Z0TnRkMFBtQTVPb240TE85TC9Ld29K?=
 =?utf-8?B?dnhiR3dXd1p5cjg1WEZ6ZTBTZEZoT0NOTXJiazBnMC9zYmw3K3RTRnliN1N5?=
 =?utf-8?B?SjFhSWd6V0M2b2U3Wnh1Wk9JQUlMaW5yUXlZcndHQkdtd3R0VFJXTXc0R2R5?=
 =?utf-8?B?WWo0L2tLS2JrWW41cEllNkVDN1BsbnNpWmhZMGZFZ0pjOEpxQm9sL3llUUwy?=
 =?utf-8?B?OFh3QTcweFNHVmlWem1ZSzQraXVGT1JQeVZRYU8vRHRIMzZ2RUhHWXFQeFpR?=
 =?utf-8?B?S3EzOWd2UktEQi9sc0h1d09pOUtXS2VRemw3aVM1L0wybXlJN21RMm1xYVFN?=
 =?utf-8?B?elg3cEowZW1hRThzcHNHbW1iTlBWN3NndXlMN0RLQ2o4aUdmcEJDa0tBUE5H?=
 =?utf-8?B?Ylc2SnJFaG43TXMvazRpR1MyazJ5K29od0FLSTRCZWR3SzdaR1lQRjNnN1Ja?=
 =?utf-8?B?MFRwbEtndlBVRkp3UjE3RDYwVnFjaTB1K1VraW5ISnZnODUrK1FsZ1JvRUd0?=
 =?utf-8?B?RFJYSlpBUWlIMUVFZEEzUlh4ZzQ2N2NCV09rSHJ6NHp1SXFocXArWXJidGtu?=
 =?utf-8?B?TE52bndlbUp0Ri93TUNlcGdmdmxIOVREaUR2d2lYYU1BQ0ZpVEFXN1FVSFlZ?=
 =?utf-8?B?TElLTllGZXhaS3FUSysrUkx2QU5RPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(14060799003)(36860700013)(82310400026)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 17:28:02.4336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28106643-c552-4fa2-a3cc-08de5e929709
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922D.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9064
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69358-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 402B5A6E82
X-Rspamd-Action: no action

T24gTW9uLCAyMDI2LTAxLTEyIGF0IDE0OjAwICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDkgSmFuIDIwMjYgMTc6MDQ6MzkgKzAwMDANCj4gU2FzY2hhIEJpc2Nob2Zm
IDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4gd3JvdGU6DQo+IA0KPiA+IEZyb206IFNhc2NoYSBC
aXNjaG9mZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+ID4gDQo+ID4gVGhlIFZHSUMtdjMg
Y29kZSByZWxpZWQgb24gaGFuZC13cml0dGVuIGRlZmluaXRpb25zIGZvciB0aGUNCj4gPiBJQ0hf
Vk1DUl9FTDIgcmVnaXN0ZXIuIFRoaXMgcmVnaXN0ZXIsIGFuZCB0aGUgYXNzb2NpYXRlZCBmaWVs
ZHMsIGlzDQo+ID4gbm93IGdlbmVyYXRlZCBhcyBwYXJ0IG9mIHRoZSBzeXNyZWcgZnJhbWV3b3Jr
LiBNb3ZlIHRvIHVzaW5nIHRoZQ0KPiA+IGdlbmVyYXRlZCBkZWZpbml0aW9ucyBpbnN0ZWFkIG9m
IHRoZSBoYW5kLXdyaXR0ZW4gb25lcy4NCj4gPiANCj4gPiBUaGVyZSBhcmUgbm8gZnVuY3Rpb25h
bCBjaGFuZ2VzIGFzIHBhcnQgb2YgdGhpcyBjaGFuZ2UuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1i
eTogU2FzY2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IEhpIFNh
c2NoYSwNCj4gDQo+IEEgY291cGxlIG9mIHRyaXZpYWwgdGhpbmdzIGlubGluZSB0aGF0IHlvdSBj
YW4gZmVlbCBmcmVlIHRvIGlnbm9yZS4NCj4gUmV2aWV3ZWQtYnk6IEpvbmF0aGFuIENhbWVyb24g
PGpvbmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT4NCj4gDQo+ID4gLS0tDQo+ID4gwqBhcmNoL2Fy
bTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5owqDCoMKgwqDCoCB8IDIxIC0tLS0tLS0tLQ0KPiA+IMKg
YXJjaC9hcm02NC9rdm0vaHlwL3ZnaWMtdjMtc3IuY8KgwqDCoMKgwqAgfCA2OCArKysrKysrKysr
LS0tLS0tLS0tLS0tLS0NCj4gPiAtLS0tDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMt
djMtbmVzdGVkLmMgfMKgIDggKystLQ0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYz
LmPCoMKgwqDCoMKgwqDCoCB8IDQ4ICsrKysrKysrKy0tLS0tLS0tLS0tDQo+ID4gwqA0IGZpbGVz
IGNoYW5nZWQsIDUwIGluc2VydGlvbnMoKyksIDk1IGRlbGV0aW9ucygtKQ0KPiANCj4gPiBkaWZm
IC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vaHlwL3ZnaWMtdjMtc3IuYw0KPiA+IGIvYXJjaC9hcm02
NC9rdm0vaHlwL3ZnaWMtdjMtc3IuYw0KPiA+IGluZGV4IDBiNjcwYTAzM2ZkODcuLmZmMTBmYzcx
ZmNkNWQgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vaHlwL3ZnaWMtdjMtc3IuYw0K
PiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL2h5cC92Z2ljLXYzLXNyLmMNCj4gDQo+IA0KPiA+IEBA
IC0xMDY0LDkgKzEwNDcsMTAgQEAgc3RhdGljIHZvaWQgX192Z2ljX3YzX3JlYWRfY3RscihzdHJ1
Y3QNCj4gPiBrdm1fdmNwdSAqdmNwdSwgdTMyIHZtY3IsIGludCBydCkNCj4gPiDCoAkvKiBBM1Yg
Ki8NCj4gPiDCoAl2YWwgfD0gKCh2dHIgPj4gMjEpICYgMSkgPDwgSUNDX0NUTFJfRUwxX0EzVl9T
SElGVDsNCj4gPiDCoAkvKiBFT0ltb2RlICovDQo+ID4gLQl2YWwgfD0gKCh2bWNyICYgSUNIX1ZN
Q1JfRU9JTV9NQVNLKSA+Pg0KPiA+IElDSF9WTUNSX0VPSU1fU0hJRlQpIDw8IElDQ19DVExSX0VM
MV9FT0ltb2RlX1NISUZUOw0KPiA+ICsJdmFsIHw9IEZJRUxEX1BSRVAoSUNDX0NUTFJfRUwxX0VP
SW1vZGVfTUFTSywNCj4gPiArCQkJwqAgRklFTERfR0VUKElDSF9WTUNSX0VMMl9WRU9JTSwgdm1j
cikpOw0KPiA+IMKgCS8qIENCUFIgKi8NCj4gPiAtCXZhbCB8PSAodm1jciAmIElDSF9WTUNSX0NC
UFJfTUFTSykgPj4gSUNIX1ZNQ1JfQ0JQUl9TSElGVDsNCj4gPiArCXZhbCB8PSBGSUVMRF9HRVQo
SUNIX1ZNQ1JfRUwyX1ZDQlBSLCB2bWNyKTsNCj4gDQo+IFRoaXMgb25lIG1ha2VzIG1lIGEgdGlu
eSBiaXQgbmVydm91cyBiZWNhdXNlIGl0J3Mgbm90IG9idmlvdXMgdGhhdA0KPiB0aGlzDQo+IGlz
IGtpbmQgb2YgRklFTERfUFJFUChGSUVMRF9HRVQoKSkgbGlrZSB0aGUgRU9JTW9kZSBhYm92ZS4N
Cj4gDQo+IE9ubHkgYSB0aW55IGJpdCB0aG91Z2gsIHNvIGl0J3MgZmluZSBhcyBpcy4NCg0KSSd2
ZSBnb25lIGFuZCBhZGRlZCBpbiB0aGUgRklFTERfUFJFUCgpIGFzIGl0IGRvZXMgbWFrZSBtZSBt
b3JlDQpjb21mb3J0YWJsZSB0b28uDQoNCj4gDQo+IA0KPiA+IMKgDQo+ID4gwqAJdmNwdV9zZXRf
cmVnKHZjcHUsIHJ0LCB2YWwpOw0KPiA+IMKgfQ0KPiA+IEBAIC0xMDc1LDE1ICsxMDU5LDExIEBA
IHN0YXRpYyB2b2lkIF9fdmdpY192M193cml0ZV9jdGxyKHN0cnVjdA0KPiA+IGt2bV92Y3B1ICp2
Y3B1LCB1MzIgdm1jciwgaW50IHJ0KQ0KPiA+IMKgew0KPiA+IMKgCXUzMiB2YWwgPSB2Y3B1X2dl
dF9yZWcodmNwdSwgcnQpOw0KPiA+IMKgDQo+ID4gLQlpZiAodmFsICYgSUNDX0NUTFJfRUwxX0NC
UFJfTUFTSykNCj4gPiAtCQl2bWNyIHw9IElDSF9WTUNSX0NCUFJfTUFTSzsNCj4gPiAtCWVsc2UN
Cj4gPiAtCQl2bWNyICY9IH5JQ0hfVk1DUl9DQlBSX01BU0s7DQo+ID4gKwlGSUVMRF9NT0RJRlko
SUNIX1ZNQ1JfRUwyX1ZDQlBSLCAmdm1jciwNCj4gPiArCQnCoMKgwqDCoCBGSUVMRF9HRVQoSUND
X0NUTFJfRUwxX0NCUFJfTUFTSywgdmFsKSk7DQo+IA0KPiBJJ20gbm90IGxhdWdoaW5nIGF0IGFs
bCBhbmQgdGhlIF9NQVNLIGhlcmUgYmVjYXVzZSB0aGF0IGhlYWRlcg0KPiBvbmx5IGRlZmluZXMg
dGhlIE1BU0sgZm9ybSwgZXZlbiBmb3Igc2luZ2xlIGJpdHMgOikNCg0KWWVhaC4uLiBObyBjb21t
ZW50IQ0KDQpTYXNjaGENCg0KPiANCj4gDQo+ID4gwqANCj4gPiAtCWlmICh2YWwgJiBJQ0NfQ1RM
Ul9FTDFfRU9JbW9kZV9NQVNLKQ0KPiA+IC0JCXZtY3IgfD0gSUNIX1ZNQ1JfRU9JTV9NQVNLOw0K
PiA+IC0JZWxzZQ0KPiA+IC0JCXZtY3IgJj0gfklDSF9WTUNSX0VPSU1fTUFTSzsNCj4gPiArCUZJ
RUxEX01PRElGWShJQ0hfVk1DUl9FTDJfVkVPSU0sICZ2bWNyLA0KPiA+ICsJCcKgwqDCoMKgIEZJ
RUxEX0dFVChJQ0NfQ1RMUl9FTDFfRU9JbW9kZV9NQVNLLCB2YWwpKTsNCj4gPiDCoA0KPiA+IMKg
CXdyaXRlX2dpY3JlZyh2bWNyLCBJQ0hfVk1DUl9FTDIpOw0KPiA+IMKgfQ0KDQo=


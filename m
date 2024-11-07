Return-Path: <kvm+bounces-31061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BCEF19BFE2E
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 07:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C7A5B2308B
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 06:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13654194089;
	Thu,  7 Nov 2024 06:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="j0u8UUdP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8103C190679
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 06:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730959733; cv=fail; b=ENu7yJU+/2avpiqihos5MXPEAo5bAo1+zfSIZeqnQrBH1XabuyihRwVYIKM+jpN4yc27wrAw40Wy6xwX7avGtJEg4HJK0gYgUjnI5QPJjkY6PVpKGjHuVMaAcCEsF5R6dxI8IWBopUgdq3duzPcHoiT5U5lk65Vj3p5E/zxNDi4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730959733; c=relaxed/simple;
	bh=RPmRQDsdRd2WJT3pR6sDjWmIs7BctGhTNyrsAWdhLbc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=bplE55VSTxOYre8XkBMbH/bQOLnabw1AePyPHPKF88Fmhn5ofHbMi71MKFj+0obivFE5Q1PJUJ2+oI2XrvP7C84Qy/qP6aEd7gpeHJbXDlS/k3XuLuzwAg8hsFOJMKV6u8oLyh1A+mEJRxZP1vvlvLH0msq7mBXaMmdtqU1Byt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=fail (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=j0u8UUdP reason="signature verification failed"; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A75b3hm006197;
	Wed, 6 Nov 2024 22:08:35 -0800
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 42rqj8r1ud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Nov 2024 22:08:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=udFhxycDFlB5FsC2KCWPVi6mzKWM4nbBmttOE2UKBBX6y6dE2bK7a/sTiUAw4VINI1dp21U4J4Qnl0wsXTVRN93dmntYp65BMihA3eSJizxcGP0TQW41D0bsGFJX9K/fI/Eet2xibbL4JYwc7i3IWPfVtXbAuGFnxeKu9gVGU0Cz7cYSyFrBtwRZurwxAryS/nn6wXlw750S1EbKop9tB2k9LYx7803B0v8yPXYUxbv6VvC6iYZNHLoOxNY9hFmsXzfTlIrj0itM14gfNd3t1lG0NRILNL7SN7An+2XVzBHVqbYnC2oJJwmhY+KAHN9PcheOrOHcWsEsItPbX6qvig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdEIoozjTuknpRqjPzM98og4NOn4q92mIsMhT0Nykpo=;
 b=Z0SS91NBOPMOM2IUe3DuMHMclUYWoIFJxZYgh7C2PWhn1A7fBCl5ByZHwJkZNP+mR3Sa3Yd/YS+t5vl7vQyPGTzqfFBazsijp83P0JgHzHBHZ6weYS0eK/6ZHGqzpjaByfae1vPDR4x2KHJqqFQWD+SPfB0bP0Jjryas2JETohfJSiXL7F/P6mEdlTlu91mWe2D5TBIYqxWNF946tXBALUIoVoEfYxDgbl/ZCojudt7ubQlvfUSFdfvd8cssIBtVVRi8dZEkzWqu2fbxDu3zEyt3psa8hCxU2albctOEH4ABeIwzf938zm4/kmUU1DJ8PWqhso9W+yAe8ACPt0XkuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdEIoozjTuknpRqjPzM98og4NOn4q92mIsMhT0Nykpo=;
 b=j0u8UUdPSFIlgNe4I69BDqnFN61GRL4xRzNKhtJ3Zf+dDe8LUl1Jkv8Tieehd48G1WeJPBFrhwg65bWAjHLEP/8ZBvr9R+I4/PW2fQp5EKUdGTv758d7/Z581zBj2NSmnQPB+UaFILEX/31shXjKjnODsIE0gcn3ByX40l7uWuQ=
Received: from DS0PR18MB5368.namprd18.prod.outlook.com (2603:10b6:8:12f::17)
 by DM4PR18MB5425.namprd18.prod.outlook.com (2603:10b6:8:17e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Thu, 7 Nov
 2024 06:08:32 +0000
Received: from DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac]) by DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac%5]) with mapi id 15.20.8137.019; Thu, 7 Nov 2024
 06:08:32 +0000
From: Srujana Challa <schalla@marvell.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        Nithin Kumar Dabilpuram
	<ndabilpuram@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: RE: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Thread-Topic: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Thread-Index:
 AQHbE96PlQaeJdnt006ohvbKHfff0rKGTA1AgAD2ZICAAnsvgIAA0r4AgARSlACABScygIAAFo4AgAGfYICAFKe0YIAANmcAgADs0JA=
Date: Thu, 7 Nov 2024 06:08:32 +0000
Message-ID:
 <DS0PR18MB5368A3903841BDE3BF8C0234A05C2@DS0PR18MB5368.namprd18.prod.outlook.com>
References: <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
 <20241016134127-mutt-send-email-mst@kernel.org>
 <ZxCrqPPbidzZb6w1@infradead.org>
 <20241019201059-mutt-send-email-mst@kernel.org>
 <ZxieizC7zeS7zyrd@infradead.org>
 <20241023041739-mutt-send-email-mst@kernel.org>
 <ZxoN57kleWecXejY@infradead.org>
 <DS0PR18MB5368B1BCC3CFAE5D7E4EB627A0532@DS0PR18MB5368.namprd18.prod.outlook.com>
 <ZyuPMI-VOp8eK-dP@infradead.org>
In-Reply-To: <ZyuPMI-VOp8eK-dP@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR18MB5368:EE_|DM4PR18MB5425:EE_
x-ms-office365-filtering-correlation-id: 15901e7a-9e2c-410c-5142-08dcfef29b48
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?K21rcmprQ0Q5N3M4NGViRjMxcExiU0xPRGtUWlZkMG1CT0t6SEFJcWFIZWZ5?=
 =?utf-8?B?eGcrRndhZnovU2xCWDUyaU9iSlVUOE1lOE9ubzFSSGVDSnVHOEpIbjRMbTNq?=
 =?utf-8?B?clMvUTlZT011WGhPdkV4U3lnNTljQkExMmRmWWxrZDdrQXFLanZLMjdoLytM?=
 =?utf-8?B?VjVEdkhSdjFDSUZHU3lYN2lMWUNXREpiNmd3TW1rbUVmNGhNSG01M0lKeWIw?=
 =?utf-8?B?MTM3ZWRwM3ZVamk3NUIvQVBqWGtVRTR6eDh0dFpIQmxQU3J3ZHVtVjhXYjlo?=
 =?utf-8?B?NFNMWkcwSHJoYVBYcEFRU1V3SXZsdGdJUmYxM3g5eXEzTlpmRWY1TzQ3eVZ1?=
 =?utf-8?B?cHJPZXAyUGVJRjhNQTJsQWl3ajlhdzdsdlRINXFyRzhnbFhGbUo2U3lobG9a?=
 =?utf-8?B?bGF2Qkl2djZmMDQ0SE5SZlBQMmxPc0J4TGVwTFlSVTJpdlVCSjE5STNxbThp?=
 =?utf-8?B?OXVzQnVpakRZSFFJWVZ3cGVYVE44Q2U1WUhsOHB5ajl4eDBtZ3lSdW1iM2F2?=
 =?utf-8?B?MHJNUm5HZjM5aU9tN2VoazZPeWNoRmhhRzBrRldMTjJjTjlVOXlNWTI5VUJZ?=
 =?utf-8?B?VkFYM0FkRUJQYU1jMEhXd1F2QVV6NnA1Yk92bkZKNVBqYkZ5eWE4SlZGNUJR?=
 =?utf-8?B?Q0h6Q1RiSjFIeStVU1NMeUFkanNheFJyM2REcmFMQUptZGhLb1JRdUlndXJT?=
 =?utf-8?B?VmhaVGxhVHI1QkZ1dlllNUhGNndCT2h6dUdDcUxCdlA4bHpGenZtSmlBQ0ND?=
 =?utf-8?B?R0JLMG0xcUZWYmpZQmtkSTdTMlNQc3RIODkrR0h4c1VsVjdmTFBrOHdtb0tB?=
 =?utf-8?B?ZzRaM3kycW1SenlvdU55RndISXZBT2FLMlBuZWVYakMyais2SnFFMWo0RzBX?=
 =?utf-8?B?ZzhZeUh2bzcrOWxtSTA0SW9KSlR0d0psaUxGV0lUaHZMOEs1VDV5dWV6OFNW?=
 =?utf-8?B?YzR5c0tzR1QyL094amhsNTIxUU1NNFFhcjAwaElUaHZoS3d6QVNtU2tTVHQy?=
 =?utf-8?B?MGR3SXJ6U25Yd2NEaVUrUEN1eXRrVHBiOUZ1UThUQ3d2cmtLcldkMExhdXRz?=
 =?utf-8?B?QU9taEJjNWxnL21CZXNiZ1VGaTNYNkRFQnp4V0hCVDQ5T1ZHUzlGV21qUnlD?=
 =?utf-8?B?dXBiRmJiUjIrZGxlZ0JObFhZdk5BYlViT1lEcjZRc0VNa3NTQ2l5YjcxSzYy?=
 =?utf-8?B?MjRsWkcrb25lamJ2Vm02UnIxNjNLcDREYmRRWHFQNWhnMVVqbjVpT1RMZDJ5?=
 =?utf-8?B?dkZRNU45QnBwTk9ldll6NEVpZXNpQ2lXVmxTYTJ2U0xQRnpLS0hmOVU1K2pZ?=
 =?utf-8?B?MW9ESE0zdHZsSis3aUx5UDJHbEpLUU83SHovblBROFRtQ1NQOUJqZlk0d1Qr?=
 =?utf-8?B?MHFScW1oRmZLNndqSGF0ZVp4TmtMaHZzVHQzdExCVFpQY2s2QnM5WXBzUXpl?=
 =?utf-8?B?U2w2czN3bXpuakxjclJaQWxnZ2Q4L3pyRlpzblZ0aW9jaUpack5ReEovcW1n?=
 =?utf-8?B?UEZoaEFsdTBTVi8xUDNPOVRuVVhZeVVwWTExcjU5WmxMMmFpTU9LZXkrcTBj?=
 =?utf-8?B?R2N5Y2ZtZmhHdlNXZWVhQ0hXU3ZWaUxZc3Nyd3RRSkJ1aVNuKzFpM0JraFlG?=
 =?utf-8?B?MzBPcnVYMGpMazVMTEFacGFMMGMwTjNZdlM0M1pMbEwvcnEyc1dud29PWVlk?=
 =?utf-8?B?YUdVNDErZzF2SGJIUWdLRThSS2FvUUswUW5vR2J3bmR5eVloWUhlTXV4N3A5?=
 =?utf-8?Q?LLLdfK25cBhvT8/SNtqdWIaBM2wh47L88UYac9v?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR18MB5368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NE1QUjY5ZklxejRrVUZiMnlwZENsbENkKytrK0dFay9IdEpRMTB3djFsRTF1?=
 =?utf-8?B?aWtjVllmMkZ5L2ZPamFkUVJUWXJ5ODNVWFd2TW9WZXhQVktJVnhnaFRxM2Va?=
 =?utf-8?B?R0xMVHJxbmNnSnV3dnJEZndwVW1XOGtRb3NHSEZyWWFaWVZnVVpKRThVK0tG?=
 =?utf-8?B?bkdJeTd5ZUtSanRrRHJQQVBSTk9IMExoRGRCTUdCN0phbGNydlFYdVFXclhD?=
 =?utf-8?B?T0N0bERjTWRKTUFwMktYZGhyemo2eWVPandYL2xLRVRSdUJwL210UUUyanJY?=
 =?utf-8?B?VUE2K0FVM1hyL3dpRWhKV3pQbmFoRStESDRlYmEvbWJ4aVowNnNDMndaYmNJ?=
 =?utf-8?B?ZmZRd1gyMU1OaWc3UzMzbjl6Y1RwTk9EZENocVVXNStSbi83WkhOU2Z0TXls?=
 =?utf-8?B?RDZzM1FQMmlMZXg0a3AvWG0xcWRoSWZhS2lkTGNyV1J5QTh3WkhKR01hSkJz?=
 =?utf-8?B?WVIvbnE0QzNoRm9OOG9GYlpBUzVoZlFHZjZwdm1TN1hRcElxdlR2K2QwMnEw?=
 =?utf-8?B?c21NVkVESS91OFhqcFZDbUQwdWdzalhLc05mN1ZXcE5QOUwxd0dEYVIvNDNp?=
 =?utf-8?B?NFcra00wZDVSam1uMnN4dXV2K1ZGc29CYWVob3lvMXlVellWSi9qcjRBcmo2?=
 =?utf-8?B?VitHbHBTUTVZcmVkekhNVjl0NWNNbGtTV0tUbVZUbWJYRzkrcXR1YlMrazhs?=
 =?utf-8?B?NmQ3M3p2T0xmUHB5WkdLWDFvR3hEcEZXZUNRTzJpdUk1TVFFSm1qcjIyV25T?=
 =?utf-8?B?RFRCa0dGNTdVT3BpQ09GbjhRck9CRlo4ZEFqWGc4NWRjVUFhaXFNcWpGL2NF?=
 =?utf-8?B?VVJ3dmcwbEVtQml3N25HaytmOUEyZ0pCS21XeEV1dmxiRHZab09ueUNKSmpJ?=
 =?utf-8?B?VGtGM2lZSVhrMzllRnlueFg0RDVXSzEvNWVqVGVGNmJ1cTFXT2l6TDJsUGt0?=
 =?utf-8?B?S0t6c3J0cXcwVllWckdDaGl5M2ZTUVlCdzNQY1J0TXI1cHR0U0VvM3JMcUdK?=
 =?utf-8?B?QU9VU3NzZjIwTWFERmE3SmxhY05HUC9NYkI2STR0dldtSHlBM1dlVmxDN0N3?=
 =?utf-8?B?MkZCSEJJNUdxMVNkS1lPcStUbENZM1p3blJXODY3cnBZeElUOG9uYnhsdmo2?=
 =?utf-8?B?a0hiZjVzcCs4K1FhdWZydS95SmJlUVRqaE8yN3NiQlcxZE1UNVJWQXdDV0pW?=
 =?utf-8?B?VVE5ZWJoU29QTlEyaktOZDlUMk9uUGdJR0FjWTlqMXloYk1TcGZINTRUZ3V5?=
 =?utf-8?B?eTRidUZrcWhPOTdBek5hVXIzYkNmSXJYWnF4YWdkcGJFdjF6QTJucDlTSkU5?=
 =?utf-8?B?RGxUS3NnMHVpSEg3RnRqWlJ2M0NteDZFVFMxRFg4bXpMWUdQcDRTNnlacnB2?=
 =?utf-8?B?QituWE5Db0NxOUZtQVNXOTRwNm9qRVJ1Sk5jWWFaWlVGUFdwdGo4MzNoT1hO?=
 =?utf-8?B?R0F1dVFSZjlxc1poeDRZWHhjUU4yOXJZd1JIWW5xZTJvUjlHVHF4UURwQ0ZW?=
 =?utf-8?B?U2k1V29pQzExTkh3TDBzZXVvVVhIQmc1ZkFoVjhXSWVobzQ4ZkFLeGhQYm5Q?=
 =?utf-8?B?enYwWUJWV3JWNHlPcmRKRWVLTWd6TzhxYlBkMmoxb0c2MS9nczc0bzEybGt3?=
 =?utf-8?B?NHd1SmRPbnQ4S2JOQ2lHTWIyU0FlMkRpM3BvTHB1bC9qSitRNHVheE9uZklG?=
 =?utf-8?B?QjJpMUdqVlM5N1VaM1IrVnFuL1ZuRVh6dm1HT2MxZWJWOXNod3hNZXdoOHNo?=
 =?utf-8?B?d2IvUVBDcXZ2c0tCUjcyaEJyWE5DUjg5ZHUrQVpHN0pLTXJBYk95YW9IMndJ?=
 =?utf-8?B?Tk9MaE40V0VETDloRUdERytsTFFGQ3NmRlhxU0M3SFc5ZUdNVkZ3K3FlZjh5?=
 =?utf-8?B?NGJYajhOOFNzUmg2M0hzZWlZNWZkN1ZVcGErWVE4eHlWZFgvSFZYV3BMdUVK?=
 =?utf-8?B?YTNjRGRKZFd5U05BTE9Cdk1GSTd2aFdXeWZUUXJuOTQxd2ZVZnl6TXFDN004?=
 =?utf-8?B?YW1HVDI5U2ZUMzBKcVNrd2czQVAwV3dkZ2xSRFduTW1TZG5PTi9xeS90SjFW?=
 =?utf-8?B?TThBNFNGem1DZW9wb3V0TDlFNEhPSUVISEZGbDVVS3h6RTNIa2NKeDhVT1d3?=
 =?utf-8?Q?6ldE=3D?=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR18MB5368.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15901e7a-9e2c-410c-5142-08dcfef29b48
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 06:08:32.0376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0DEVTV1wCc1wAjSJw8gSmHIYAt7h79zPgTgXs9GTEbhC5CiQaThzcxoXV4KEUpmR1U7DxBtRfmCRfkAePuz3Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR18MB5425
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: fwa-NHDJLmAQBK0e9ZraNZBQjbGHVmxm
X-Proofpoint-ORIG-GUID: fwa-NHDJLmAQBK0e9ZraNZBQjbGHVmxm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

> Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for NO-
> IOMMU mode
>=20
> On Wed, Nov 06, 2024 at 12:=E2=80=8A38:=E2=80=8A02PM +0000, Srujana Chall=
a wrote: > It is
> going in circles, let me give the summary, > Issue: We need to address th=
e lack
> of no-IOMMU support in the vhost vDPA driver for better performance. >
> Measured=20
> On Wed, Nov 06, 2024 at 12:38:02PM +0000, Srujana Challa wrote:
> > It is going in circles, let me give the summary,
> > Issue: We need to address the lack of no-IOMMU support in the vhost vDPA
> driver for better performance.
> > Measured Performance: On the machine "13th Gen Intel(R) Core(TM)
> > i9-13900K, 32 Cores", we observed
>=20
> Looks ike you are going in circles indeed.  Lack of performance is never a
> reason to disable the basic memoy safety for userspace drivers.
If security is a priority, the IOMMU should stay enabled. In that case,
this patch wouldn=E2=80=99t cause any issues, right?
>=20
> The (also quite bad) reason why vfio-nummu was added was to support
> hardware entirely with an iommu.
>=20
> There is absolutely no reason to add krnel code for new methods of unsafer
> userspace I/O without an IOMMU ever.



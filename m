Return-Path: <kvm+bounces-67928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 739B4D17ECF
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 11:16:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 65A743047941
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 10:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0532938A286;
	Tue, 13 Jan 2026 10:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="i7HRs7dW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1568146588;
	Tue, 13 Jan 2026 10:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768299114; cv=fail; b=q2odUAXCaXWS4RrQkA8d9en0XecQGWEeT9rcQvyjXWmB+pcOkTyNN39FWDhy3ZV4Kxi36sEFIad3ZZoy2VNDMYdeVqBhuheckxhXPWd/J/7GQYWLkXIOcZetA4phUBFXwCUN7X/dGdwG1FBkp7UINOXixGFPg4+E+h9gc5IqXNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768299114; c=relaxed/simple;
	bh=5nZSj8aL3qhXHhBNcfYG38ht0EHBtnHDY98Yh+tvsY0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FdwQjS58hq+4yDFVftMrJNRaR002b9e0D4zSGlnevFLnxg6BBZEgO0hrr5A/LQS4VkoP3PmxqQrqJWzItylcnh/io+fc8kZ2uu0Szzw1jOlzExRZ+t7Wqlpl1JTA0FVDTmpAWcNbDq6qZdmm9EOY8BKrualIwSIQ20u3TPlyRpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=i7HRs7dW; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D7Q7p22460628;
	Tue, 13 Jan 2026 02:11:41 -0800
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11020091.outbound.protection.outlook.com [40.93.198.91])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4bmvfkbckq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Jan 2026 02:11:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pv6IQr8hYyTzgNX7fjzaoONGd1w2rFEimvLOeR+Lo+JuaZxNnsg/OsZ6+k0swWH/sp49KawUObv2SuvkdeNiI4xWQ44RtVYk1vr3yziPLT1osIf+7MIL2nmKqqNfJhu0YJZB6s9qOHkFi4UBFv9kq2ru5pwUGdv5i1MswHMFzT5xj79agpbK89eqGea1NoJhEw/wUBTfkofJZFrFDbs3tq9VnO4QiL1+Mw8/djOPi6CGW7kGx9bJV291vLb5UiP28UGKRENFzb7Jd0fbrzKmJ8z0oZOYr6xD3xKVfnSezIEQj9GcFLq3UjtKwlhcu2rj/AHClx/rqmHjumfiJEgt2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nZSj8aL3qhXHhBNcfYG38ht0EHBtnHDY98Yh+tvsY0=;
 b=b1PvxeL3dWwCdIrMp5Mo5T/2HpGRzKfL1kFb5zpx1DnMmNV5qhqPxJh0Rs8u0YOSL05MDYVctOtLjXxHlxxOZ5zECglCe7dEI4cbetSBvJOt7jejWgdTVAhh+jIRoa0BF98ayny4iZG3JUraVfVKapT8dfrm6XYZyYv2OoiEaNeKofeMOL54EkrNkT8BXCwKSnXAVJozAN4Lk0Y+7A6ZhXTxO1oZRBABGaEfLhkYJ3aTX73F4j2eqKrS7Mc3PqiJKBBMfDguFH4CRtutUAxCj/rOATjwstZQJNnq3q0RUitiCnRkMNjDAA8Lt5VeJsXF8fpry/88j7XmQYdvUJs9eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nZSj8aL3qhXHhBNcfYG38ht0EHBtnHDY98Yh+tvsY0=;
 b=i7HRs7dWaoJUxk/aKz28+GoaybL3fZHo6BhliXkOF5qT/bfqSVbudMlL2JUvDrE/oZqP16DZNnikmOYUZTExadxsnxuZr5DJ7HM6G1dXlA2KYk1pWE6+tXWgJwjNdg9yuVsIfcSzLOw2xhCFwFbsFOQAeMtIZdmKKAJ9SSJMqm0=
Received: from DM4PR18MB4269.namprd18.prod.outlook.com (2603:10b6:5:394::18)
 by CH3PR18MB5597.namprd18.prod.outlook.com (2603:10b6:610:19a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Tue, 13 Jan
 2026 10:11:38 +0000
Received: from DM4PR18MB4269.namprd18.prod.outlook.com
 ([fe80::9796:166:30d:454a]) by DM4PR18MB4269.namprd18.prod.outlook.com
 ([fe80::9796:166:30d:454a%6]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 10:11:38 +0000
From: Shiva Shankar Kommula <kshankar@marvell.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jerin Jacob <jerinj@marvell.com>,
        Nithin Kumar Dabilpuram
	<ndabilpuram@marvell.com>,
        Srujana Challa <schalla@marvell.com>,
        "dtatulea@nvidia.com" <dtatulea@nvidia.com>,
        "jgg@nvidia.com"
	<jgg@nvidia.com>
Subject: Re: [EXTERNAL] Re: [PATCH] vhost: fix caching attributes of MMIO
 regions by setting them explicitly
Thread-Topic: [EXTERNAL] Re: [PATCH] vhost: fix caching attributes of MMIO
 regions by setting them explicitly
Thread-Index: AQHchF6E8HwxgScn3Eusu7veMpFAlbVP4BRD
Date: Tue, 13 Jan 2026 10:11:38 +0000
Message-ID:
 <DM4PR18MB426985710197436081F084C1DF8EA@DM4PR18MB4269.namprd18.prod.outlook.com>
References: <20260102065703.656255-1-kshankar@marvell.com>
 <20260113022538-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260113022538-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR18MB4269:EE_|CH3PR18MB5597:EE_
x-ms-office365-filtering-correlation-id: 1d10a065-32fe-40da-4110-08de528c23c3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SlBkSkc0aWR3Wm1za09ia2p0U2JadzQrTEFuMzNVcVJwd3IzUm42OElNOEpO?=
 =?utf-8?B?aU9jdFpnWXVsellkMjd2OEN2SmpTSytRRForcFRIaTBEOWQ1MnpONHB4VkEx?=
 =?utf-8?B?Y2FrT212REdTWVc2bGg4dGpmeXgybEZNWEpqZXh4R3R2ZkF0NEM4VkZjWDZF?=
 =?utf-8?B?UHdqdWU4UXZJYVVFZyt1K0N6dGJRYlRMNnN0K0R1dzdPellzWTV3YU11bGll?=
 =?utf-8?B?dkVhVkpvekFwZTd6TVE1YndqQmg4bEVET1F5UUErZUpHc1ZjR3pZZnR1aEox?=
 =?utf-8?B?enkvVFpoZ0tHNVh6eW9FUDlFTmI1eE1acWZwaXlOQ2FNOE5obkJBMFZVNDlO?=
 =?utf-8?B?WXdVK3EvcFE4Ri91cnVTZ21MNi9CcnRlTEg1eHlDcVhTTXZVMHdldUxkTXVv?=
 =?utf-8?B?T3gwMWp3VWVTcDR5YWNwZXBlTmxRK0RIdSs5aVVTc2h4bU5WMVJyeTF5MFN4?=
 =?utf-8?B?L1h0elVGRmRpTnhSWUdNdjljU0hHcEtJRWJVTG5DUUpyOTNEVEg1di9OY3Bw?=
 =?utf-8?B?QnhSR1B5K0ltSjY1Q1JDZVZ1ekl2clRLRmhpQk1Yd2ZyVUNxOEplY0xlMi9u?=
 =?utf-8?B?NzBZM1kvMkZZNmduT3R6VjJsbGMvRmkxb1FPK0s5aGlyWlgzQysyVkowbVAy?=
 =?utf-8?B?QmdNT2pMSSt2R0RrMHVkcVh5U3p2UGNobnBPNnlXR1d6UG1ENmIyTTNLOWVy?=
 =?utf-8?B?SWxIVUZrZm84T1E5VTZubnY2dk5YOWtaajlWVk1VdFc5VkxKMVJ2R0NIUjMy?=
 =?utf-8?B?ZkZNN0ladi90UHFsRTdNMUlHV3VmZkgyNWpFY2pDcTZQeWpQcnowR1liRWdi?=
 =?utf-8?B?c2ZZTGFLN00vN3M3S2M3WUdkM2REYWFlc2gzWE5LeWVkZkw3U29RTXo0bGVw?=
 =?utf-8?B?QTYrZjRVTmRsaUh3Z2lkbjIrNDVGblVsTTZIMklLRWFqUVc4Q3hxT0lQNDZz?=
 =?utf-8?B?aE1KM3N4OE5JLzYwZDdyL2FoeUZKSHQzblZUeFR2cWttZStwTHp3MmhOUng0?=
 =?utf-8?B?WERmWnU0SUErM2lnWEJWOGJ4cEVKUkoySFRoUEl5V2xLM1N3ZURWc21hZ2tx?=
 =?utf-8?B?ZFJKR1ZTek9LRlZFd1lYTGhVb1o3amxEYmdsUnJjN2VzVWdIaWMyKzVEZFJU?=
 =?utf-8?B?ay9TOUFaUWFDNWFHRnFOR3MzQ3NQVzIyQjAyZ0RuRUpGKytoeDQvTGVnWnZY?=
 =?utf-8?B?Q0k1VzhFN0w5TnNZWmh6ZURyamNUYm9xWnVpTEtQUWxyeXNoeWdpUkQzL1VG?=
 =?utf-8?B?S05iMW81Vy9iRUJzR3FJMit0UmkzaWhUdDBlMjEyaElvRU41K3BTQ05qU05H?=
 =?utf-8?B?YW5LbUVTdWJtZDRWUTZUcklvU2RrRGp5NmxrSWhqRkVmOU5XcEdFWDV1VlhN?=
 =?utf-8?B?YWxwTTFEMFJDbDJOeDNCTDFBTmxRdHNkekVjK2ZSb014YU9FTmV6OHVqK3Fq?=
 =?utf-8?B?RE9kY2Q5cW9VZG1WU1dtUzFSN1hWMTBvNEdUMEVXeUhKaG1qSXNxdXV2MjIv?=
 =?utf-8?B?YTRETDliaDFWNmgvanlQWW5rajI3aTVxV2F3N043NnJNdWVBamRLZ01aVXlM?=
 =?utf-8?B?RytCR01yOFdmMWxqbTVGWUF6ZXBHazBzczRZQlB6YjlXdDI0MmhUcVhqNUVT?=
 =?utf-8?B?R01nb1lybVlkazB1TTB3YXNsRjBQeDRGRHF3VzQyc0VZSk5pT1M3VTNuS1Fp?=
 =?utf-8?B?eThLOUJTYlFjNEd3Zk1KejgzY243SDI5QmhhRjlWNkJLTXJ3NmhYY1dmeTBm?=
 =?utf-8?B?VVhyV1lMNGdXZ296emczaTlCZUYxSnptSzIxTlBHNkw1REpwbjhjVW1INHc2?=
 =?utf-8?B?VUdnWmFYcDJpdXdXSVJsbk1IV05INFhhTnMrQlBZZ0lENXpuak4xTVY4bC9Q?=
 =?utf-8?B?ZGZhaVE3Rlg2Z0w5M1dPdVMya1NpdXAwbklPU3dZNGZIaW5uUlBZRUtuM0lM?=
 =?utf-8?B?M0Z5dlpGWWxlOTJZZXplbS96VTdtaDQyUHZpeWFnenpKUlQvaFFQbDIyVGJB?=
 =?utf-8?B?RTlSd3d5aGVjWWVlZHFyZ1dmeERHS3F3NmRNaE5pRkRESlhxY1dMbFRtbWFJ?=
 =?utf-8?Q?W2i2g0?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR18MB4269.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WnFnQStGeDRWclc5cmlqNjRjQTA1QlRjdUlYdG1GTFJnWnFPU3AwSXV6L1FQ?=
 =?utf-8?B?UmtmaGo1RjhIdVUvU1FHdnBLemtyREVCV2RqTTFoT0ptYWJtS2g1YzYxVERE?=
 =?utf-8?B?cFU2UGJzU0JFTFRmeWt6T09HekJLb29UdlVoUG94eDZ0Y3FtQm05ZG4zb2lT?=
 =?utf-8?B?Y3Z3YUs0Q1BaRThHVlJqL3BBS21Pc0RjcjQ1TXdPM01PeVNWQjYyamhkcnoz?=
 =?utf-8?B?VWpoM2xxN2t2Z1AyWk5CQ3F6VmRxejdlTDhFeEJUMVFWQklIYzNLUDQyd2ta?=
 =?utf-8?B?UWdweEVUWFFBbjF3WHk0cUxaWGJqVGI2cDVvMkpGWDFjeWF5V3dJNk0raUJh?=
 =?utf-8?B?NGxxa29lZHF1dE0zWDcyNXpNUFpSWVV3eGFQQlVUOFJQME9PaGdPOXJyVEll?=
 =?utf-8?B?K2RvU2JiaS9sZk5wbnFuclN2Y0xvWGhwYm9zQmppc3NGNVJtcjZ6KzdRbHZP?=
 =?utf-8?B?THR2MjFlNmhQN25uejZxSWNNZ0pmbVpLekFMSjFpSjZHM21DT3EzNytUYXJH?=
 =?utf-8?B?cGl0WkFjam1kV1ZXeStJV1FnZ0s2QmFiWDlLVTVJZGVoM1g1T3ZRUEE5VG41?=
 =?utf-8?B?dWRlWkNiRDUxaFVyWEZKanZDSzROOVlhZnN3Ky9xSDY0VzZGdjkwR0oxT0xZ?=
 =?utf-8?B?SzlqSXVSY3U4VkhsUUtaNkY1aVd5bUVwSkgzdlNjdmZLV3FFNjVJamdpcmsy?=
 =?utf-8?B?K2xRdFM0bzM4ZlhxUWw1ZWNNQWFTa1hPNlI4czlWZThnZWNGSXY1RmxFQWta?=
 =?utf-8?B?YTZwOS9HTGNCZjd5SUw4L3VXZkdrVmhyWVJNSlczVW1NeW8wTDd5dE00M0JT?=
 =?utf-8?B?U0s1SkFMRXlZci9QeDJaSS9TSmJna1BXd2NTUm5HdXNqdjJPdzJ5WUNMVUlv?=
 =?utf-8?B?TjRKZUZzdVFzR2pkcnFaL0pLb0xLenVDV3NOQVFINkhraGhaeHk0clhRNW5r?=
 =?utf-8?B?bVZMc2lCbk9EcmFzaFBKMjl0UUNBRGl3eFo2NFFRaURJRWRwc0t6aVJtU1NJ?=
 =?utf-8?B?OVZTLytaQUdsMnhybUxKa1BDeTRGSm4wV0xPdVR4a0w1dkhJUzlqaXlHRFZQ?=
 =?utf-8?B?ZlNnQTZoenpEQWJsMlhLY29aZSs0SEhIV3NiTm5aL25lQU54MHlmU3BrczVG?=
 =?utf-8?B?dWZMTnFHcDZDZXV1ZzNlQk9QQWVhMXVMWG9rOEN6dFpVT3FRU3Z3K1N4bEYz?=
 =?utf-8?B?VWJXVzc0UkVFalhJVzZteWgxa0JNNDN4Um4rTzR3QTRHNVpYK01hTnBuWS9D?=
 =?utf-8?B?SGxTUmRDVlJNb2sxeW9MTFdXUExlNUlCdE1KK3g4OFVpZXVlaFVpMzM5NDlY?=
 =?utf-8?B?OHYvL3RsNlRMOW5Dd3o0eVEyZlNHakFCS2d6aGMzZ0tPMjdjSUhOVTZWZ3dO?=
 =?utf-8?B?ZDRURGJBWXI1d1JqOExXTldLZTJLRnpBbEtMQnB2cHBhdEhvWHdmZW42TUxE?=
 =?utf-8?B?WVZUc3owV0hjd0xQT2JIMnpyanRSRjhBbWdDbkZackNMTnBucDhUcTNqSFJl?=
 =?utf-8?B?eUpsT3BCVWVqcVhEV0c3allIZk1UR1VOMFU5Q1RNcjNsMkFPYVVXdm10RFNG?=
 =?utf-8?B?OUFvbVZJTlZ2MUNqMjY1OXVtZHJBSTMyL0k5YU5uSmZwUWZrcnVEM2U1RkNw?=
 =?utf-8?B?VG1OMmJZaU9kTi9VQ2ZtRTRDc0xSS0xIbnRSOGlFdUdDOW1USnRXVlhjZlhl?=
 =?utf-8?B?RmtOWXpMUnNveFEzT0lXUzFXaXJEOVo0RUJEQ2R5SFpodGczWGk2VkFQZnlT?=
 =?utf-8?B?Qno5MWlWeUdMMWFMb3JIQkdMemg3MFFGMXprUzN3ZE5ncE03dTRSMnkrYnVv?=
 =?utf-8?B?WFJKb1h3TUZIQitnMlRvcnA2bU5UVy9hYm42OWNFYmJpZnVyR1ZPUUpXY0k2?=
 =?utf-8?B?a3d3MWNCVnJ0THBNK1E3L3dOVWx3cFlOYkZMWi8xZW1MREszVnl0TmtEd3lp?=
 =?utf-8?B?Ri9UUG5GT2tFL0lHdnd0d29XRkFWZ3ZOMUt3REtHak53RjU4Wm0vZWgvS3Av?=
 =?utf-8?B?MGFNd3c5cmVlL0ZxTTUrQWVTRjk1YWc0ZzFMSGZ6c1llOGhPVzBscDdDRzU4?=
 =?utf-8?B?M3gvQVNHQlYyc3JSUVRXNnh5RElJMTIyS2ZUTUhIMjA0dmFWSlNlZzJadHFM?=
 =?utf-8?B?aHZMNnNYMGZZNE0vMUxHRHN5OC93cmNwN0dQWnlya3ljSFJ4bUVtdEgrbVha?=
 =?utf-8?B?M3V3NldkVCtoRFFSQ0tYanpvSFVZWGtKOE0vRnMrTnlEZFZBdjhJbFg0NGhG?=
 =?utf-8?B?WkkrRUJJZ3BkNzBLczc3ckNOUnc2M0ZRcVQ5Rk90UGRVeUtOZHhMNVBwZXg4?=
 =?utf-8?Q?pnTZx4GxaY6lb4Lnph?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR18MB4269.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d10a065-32fe-40da-4110-08de528c23c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2026 10:11:38.1468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hO8tIvXS2Ix4NsWAs8CPwxqu5Ex6Qp3sfsEGAt9dC2FRGPLxztCkI2CkT8kfzEqwV8J/+tNetwGv+m1hcpRu0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR18MB5597
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDA4NiBTYWx0ZWRfX0ol0f8e4C+u6
 zVz2skkiJrNiYQCnfuadg9jAGgFPxS6iZkgIWMtqcBoXLoJt8BjOH8CUwfyL+oLxyabCR/LV9VZ
 Biv8FoAaZ9OLtWGd26WGab6RvMw2Xq1fgOI+Sy2eq00w83xdMKFlLQLyDFawKkQDQ0oNu8dDxG+
 klptn4xsYDg7vE0gGiOtzBsfTofteUn/ZyzRCdZtHJqsH1f9agC9xKBaU+v9NmWkTNkeBfLXZj1
 RODQsKlOqKNXUAqpGFEigaqkTsfIQg7SYAX6m9j5P6hKmNXEryIzuvAwrnePjaJbsDE0+3Q726L
 hrK6f06I/vHN0f8zt5KhySvtH1k+77BEJpeVzvBWRgK2MxPznEafdjVReGIbXZJAdxOcmDzjuE0
 OCJkw/ugodexURUbtm6uCDy3yHw6zCSie62G6Ffq5iRu5q4eA3kEJwWBe0SsrOK4kSRNPg2sycG
 rW4sQDwCc8qWWFd+o0A==
X-Proofpoint-GUID: uYo8Wu9vSAOQDI6SD6miw1av0z1rXQAT
X-Proofpoint-ORIG-GUID: uYo8Wu9vSAOQDI6SD6miw1av0z1rXQAT
X-Authority-Analysis: v=2.4 cv=AZe83nXG c=1 sm=1 tr=0 ts=69661a5c cx=c_pps
 a=LgTXwy+OxRus0W5fFstXuQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RpNjiQI2AAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8
 a=M5GUcnROAAAA:8 a=dtRhXEUe8RYxJtPwphMA:9 a=QEXdDO2ut3YA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_02,2026-01-09_02,2025-10-01_01

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpGcm9tOiBNaWNoYWVsIFMu
IFRzaXJraW4gPG1zdEByZWRoYXQuY29tPgpTZW50OiBUdWVzZGF5LCBKYW51YXJ5IDEzLCAyMDI2
IDEzOjAwClRvOiBTaGl2YSBTaGFua2FyIEtvbW11bGEKQ2M6IGphc293YW5nQHJlZGhhdC5jb207
IHZpcnR1YWxpemF0aW9uQGxpc3RzLmxpbnV4LmRldjsgZXBlcmV6bWFAcmVkaGF0LmNvbTsga3Zt
QHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgSmVyaW4gSmFjb2I7IE5p
dGhpbiBLdW1hciBEYWJpbHB1cmFtOyBTcnVqYW5hIENoYWxsYTsgZHRhdHVsZWFAbnZpZGlhLmNv
bTsgamdnQG52aWRpYS5jb20KU3ViamVjdDogW0VYVEVSTkFMXSBSZTogW1BBVENIXSB2aG9zdDog
Zml4IGNhY2hpbmcgYXR0cmlidXRlcyBvZiBNTUlPIHJlZ2lvbnMgYnkgc2V0dGluZyB0aGVtIGV4
cGxpY2l0bHkKCk9uIEZyaSwgSmFuIDAyLCAyMDI2IGF0IDEyOuKAijI3OuKAijAzUE0gKzA1MzAs
IEtvbW11bGEgU2hpdmEgU2hhbmthciB3cm90ZTogPiBFeHBsaWNpdGx5IHNldCBub24tY2FjaGVk
IGNhY2hpbmcgYXR0cmlidXRlcyBmb3IgTU1JTyByZWdpb25zLiA+IERlZmF1bHQgd3JpdGUtYmFj
ayBtb2RlIGNhbiBjYXVzZSBDUFUgdG8gY2FjaGUgZGV2aWNlIG1lbW9yeSwgPiBjYXVzaW5nIGlu
dmFsaWQgcmVhZHMgYW5kIHVucHJlZGljdGFibGUKWmpRY21RUllGcGZwdEJhbm5lclN0YXJ0ClBy
aW9yaXRpemUgc2VjdXJpdHkgZm9yIGV4dGVybmFsIGVtYWlsczoKQ29uZmlybSBzZW5kZXIgYW5k
IGNvbnRlbnQgc2FmZXR5IGJlZm9yZSBjbGlja2luZyBsaW5rcyBvciBvcGVuaW5nIGF0dGFjaG1l
bnRzCjxodHRwczovL3VzLXBoaXNoYWxhcm0tZXd0LnByb29mcG9pbnQuY29tL0VXVC92MS9DUlZt
WGtxVyF0YzNaMWY4VVluWDYxRy04LVozNkQwVHdPeVhHS0VfeWJxa3d0QXNOR09OVGhEemNlMS1C
elFGSklEbERuX2lXTEpwZTJGSEt5ZW9mUDN1NzduZVN0NzA2U2NwSTVFYyQ+ClJlcG9ydCBTdXNw
aWNpb3VzCgpaalFjbVFSWUZwZnB0QmFubmVyRW5kCgpPbiBGcmksIEphbiAwMiwgMjAyNiBhdCAx
MjoyNzowM1BNICswNTMwLCBLb21tdWxhIFNoaXZhIFNoYW5rYXIgd3JvdGU6Cj4gRXhwbGljaXRs
eSBzZXQgbm9uLWNhY2hlZCBjYWNoaW5nIGF0dHJpYnV0ZXMgZm9yIE1NSU8gcmVnaW9ucy4KPiBE
ZWZhdWx0IHdyaXRlLWJhY2sgbW9kZSBjYW4gY2F1c2UgQ1BVIHRvIGNhY2hlIGRldmljZSBtZW1v
cnksCj4gY2F1c2luZyBpbnZhbGlkIHJlYWRzIGFuZCB1bnByZWRpY3RhYmxlIGJlaGF2aW9yLgo+
Cj4gSW52YWxpZCByZWFkIGFuZCB3cml0ZSBpc3N1ZXMgd2VyZSBvYnNlcnZlZCBvbiBBUk02NCB3
aGVuIG1hcHBpbmcgdGhlCj4gbm90aWZpY2F0aW9uIGFyZWEgdG8gdXNlcnNwYWNlIHZpYSBtbWFw
LgoKPiBkZXZpY2UgbWVtb3J5IGluIHF1ZXN0aW9uIGlzIHRoZSBWUSBraWNrLCB5ZXM/Cj4gU28g
aWYgaXQgaXMgY2FjaGVkLCB0aGUga2ljayBjYW4gZ2V0IGRlbGF5ZWQsIGJ1dCBob3cKPiBpcyB0
aGlzIGNhdXNpbmcgImludmFsaWQgcmVhZCBhbmQgd3JpdGUgaXNzdWVzIj8KPiBXaGF0IGlzIHJl
YWQvd3JpdHRlbiBleGFjdGx5PwpUaGlzIGlzIHRoZSBWUSBub3RpZmljYXRpb24gYWRkcmVzcy4g
Cm9uIEFSTTY0LCB3aGVuIG1lbW9yeSBtYXBwZWQgYXMgd3JpdGUgYmFjaywgbm90aWZpY2F0aW9u
IHdyaXRlcyBuZXZlciByZWFjaGVkIHRoZSBkZXZpY2UuClJlYWRzIG9uIHRoZSBkZXZpY2Ugc2lk
ZSBzZWVzIHN0YWxlIHZhbHVlcy4gCgo+Cj4gU2lnbmVkLW9mZi1ieTogS29tbXVsYSBTaGl2YSBT
aGFua2FyIDxrc2hhbmthckBtYXJ2ZWxsLmNvbT4KPiBBY2tlZC1ieTogSmFzb24gV2FuZyA8amFz
b3dhbmdAcmVkaGF0LmNvbT4KCj4gSSBhbHNvIHdvcnJ5IGEgYml0IGFib3V0IHJlZ3Jlc3Npbmcg
b24gb3RoZXIgaGFyZHdhcmUuCj4gQ2MgbnZpZGlhIGd1eXMuCgoKPiAtLS0KPiBPcmlnaW5hbGx5
IHNlbnQgdG8gbmV0LW5leHQsIG5vdyByZWRpcmVjdGVkIHRvIHZob3N0IHRyZWUKPiBwZXIgSmFz
b24gV2FuZydzIHN1Z2dlc3Rpb24uCj4KPiAgZHJpdmVycy92aG9zdC92ZHBhLmMgfCAxICsKPiAg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCj4KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92
aG9zdC92ZHBhLmMgYi9kcml2ZXJzL3Zob3N0L3ZkcGEuYwo+IGluZGV4IDA1YTQ4MWU0YzM4NS4u
YjAxNzllODU2N2FiIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvdmhvc3QvdmRwYS5jCj4gKysrIGIv
ZHJpdmVycy92aG9zdC92ZHBhLmMKPiBAQCAtMTUyNyw2ICsxNTI3LDcgQEAgc3RhdGljIGludCB2
aG9zdF92ZHBhX21tYXAoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAq
dm1hKQo+ICAgICAgIGlmICh2bWEtPnZtX2VuZCAtIHZtYS0+dm1fc3RhcnQgIT0gbm90aWZ5LnNp
emUpCj4gICAgICAgICAgICAgICByZXR1cm4gLUVOT1RTVVBQOwo+Cj4gKyAgICAgdm1hLT52bV9w
YWdlX3Byb3QgPSBwZ3Byb3Rfbm9uY2FjaGVkKHZtYS0+dm1fcGFnZV9wcm90KTsKPiAgICAgICB2
bV9mbGFnc19zZXQodm1hLCBWTV9JTyB8IFZNX1BGTk1BUCB8IFZNX0RPTlRFWFBBTkQgfCBWTV9E
T05URFVNUCk7Cj4gICAgICAgdm1hLT52bV9vcHMgPSAmdmhvc3RfdmRwYV92bV9vcHM7Cj4gICAg
ICAgcmV0dXJuIDA7Cj4gLS0KPiAyLjQ4LjEKCgoK


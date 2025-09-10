Return-Path: <kvm+bounces-57243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F9FCB52085
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:58:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 385721B253FE
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FAC92D24AA;
	Wed, 10 Sep 2025 18:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="AAGL6Ohx";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="M2QRckvV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E2B22FDEC;
	Wed, 10 Sep 2025 18:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757530726; cv=fail; b=JC1QJin860OnSEFTvBAlvJQaCNabDEOhOwS+pw7MoC4DOHmGgB2TNrcbyrwU31rrXhYfNXia28iY2oNc0CUpa4nIMMbXw1brqrNa8KC1XUWXeAq7Hlhw9Lqyt+57HXT4M7vUtB82Yt1SEMTREdm13qCyq92klZ/Xr5HvFAh6mzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757530726; c=relaxed/simple;
	bh=SCqq6qH6wHklrdPccq0+f9HHRxgUTJRPms81Exg9iD4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fQq5onsrveuwqq5HyqELZh/0V8fvanvkBj4Jw2m8Hnjabzh3bVrsC0993ngTXyJiTdCQmlFvdGuuKFjGctFcDZZBUGlwNgbJ/mY+1/f1foJtHwgBV+iBb9982P+Zx5TeOe3XiRnr1g7m8qMBnoiCGvpTljwQmyBnzz7Lx+VC2vQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=AAGL6Ohx; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=M2QRckvV; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58AFtMZW361325;
	Wed, 10 Sep 2025 11:58:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=SCqq6qH6wHklrdPccq0+f9HHRxgUTJRPms81Exg9i
	D4=; b=AAGL6OhxQEO4LmPKwU2CdRG6qZHqQQIf+NkZAeeFjoLa6R2r48lJNBsVW
	yYlMJaW4T8cTaxp2sV+xzlMBxKkEWetSZhGexam6LsxHhlXMjywgI8YkfD1b9tqV
	HV80jWAexKORQ7Hl5xa9eFkc716tkEUMpuDk0hr+6Qx3YNC7slcHE4calTK4Rp8Z
	fb4mKWyokodLtgfawmL7/hZOaLwRm4m8OzaaSV7oRo1GcLgrpbvZKLXjdbXZz841
	BBR8nmm85HlfJHKpP03+r5jzOh9GQW6lt7uKE5KRCNf0/R9LnNDGLv+X2sgEEGfE
	SW84dfJznw0sbN9/CGcIzLx/kP1ag==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2103.outbound.protection.outlook.com [40.107.243.103])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 493cd9gd5d-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 11:58:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KP58LB1AH66SLWikPiag8WI+7lFdktJZUn3/pC2fmCU+F/JAwEjWvlwtzBe9KuGpy2qQXo/YUbTwpIrpbayGf3fKl8Qy9qixwvtRd9I17Hi8HMMfI0ui9w2LtzUzw8M9uA5hxp2tAOPY7tRMuoVtWDvGIRqagMinSoJoJX0T85mmRft3O/Vj1CzImaFR5E+BWPeykQuKhABs6V5IYIH8zl+ybSaxFKyKJnEY0t/wTsk184SqHHSOHQ78SgZ6wdoBQ7MvzkFUxFlTRLmnvrX5heJWD7lCzuvJDMKOmv+mhO5kWbBvWfF2TUE1NS9jlX3N5bmMuwBZ8GDADLEjPiK4lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SCqq6qH6wHklrdPccq0+f9HHRxgUTJRPms81Exg9iD4=;
 b=Cuy8mbf3K2S4RNuqb9ZOMb0pIKIOObE0oeTvBtEoYVZlLzXBZjPR2J8ZC6S2Hjvo5+bVHqt45cFFdXhxoMafQJFrD8miU4kKgpP2S1mE5m3AaxPptZXKG2cWHVx+4NDo5LlMCPmwCqEeMbq8NsexZ+QsgHQ7JF7PiVcgHa93lDVvbW1J8Cw66QTz6bQ41kPupOCckE+iYoq3NfknL5kes15pEsSQT1XidRIVi6ESoAOA7+DrFzfwEVwEKeT69fWZhWQQD6eflR1Mje/PQsryhjkeqnHPzi3SBUB8BTIou9fVn3WAKCLIJ2FWM+wEpUapONC5Gv4mV7+/I+aqikGP5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCqq6qH6wHklrdPccq0+f9HHRxgUTJRPms81Exg9iD4=;
 b=M2QRckvVRltn7wib5CoD8fDiwI4H58XbvoTg85TbxddNoWrNBA8SckIXzsowIWCf6JhNPKv3nb6E7rBtet5obfK3+TIYRxaFLbhw3Kr325e9hqlnIZqWH0b9Ji86TB3Te/uarbPWQpwGMWyiyNceVi5YH/Y9skfCe555+d6xxI3NV+B5MWvm42k2uI1iNqZ/PIxvpOEK7nFlG5O9leumOYqZfojsHM1Ozj0FTosEdIe8udyrxnWHI6UWxTlGhUPyxMQxv0GNLLLr076dThGWBVovtw69fb7D22FFPuHjX3hJxQle8aTw3X08T5yg4lTB1xMyKE1YsIbkXO0Uz1oHCA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by MWHPR02MB10393.namprd02.prod.outlook.com
 (2603:10b6:303:285::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 18:58:20 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 18:58:18 +0000
From: Jon Kohler <jon@nutanix.com>
To: "patchwork-bot+netdevbpf@kernel.org" <patchwork-bot+netdevbpf@kernel.org>
CC: "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com"
	<jasowang@redhat.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: vhost_iotlb_miss tight loop lockup - RE vhost/net: Defer TX queue
 re-enable until after sendmsg
Thread-Topic: vhost_iotlb_miss tight loop lockup - RE vhost/net: Defer TX
 queue re-enable until after sendmsg
Thread-Index: AQHcIoTfK5T3pE7+Yk+SbusKG/iZMA==
Date: Wed, 10 Sep 2025 18:58:18 +0000
Message-ID: <154EA998-3FBB-41E9-B07E-4841B027B1B5@nutanix.com>
References: <20250501020428.1889162-1-jon@nutanix.com>
 <174649563599.1007977.10317536057166889809.git-patchwork-notify@kernel.org>
In-Reply-To:
 <174649563599.1007977.10317536057166889809.git-patchwork-notify@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|MWHPR02MB10393:EE_
x-ms-office365-filtering-correlation-id: 63a3f9d3-10bc-48dc-8880-08ddf09c018c
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|376014|1800799024|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?TW82K1ZvMnFiVktvK1U2dUdKRTFPamNxZ2tiR1ZwZlhOY2hXNkZUTEY2ckwr?=
 =?utf-8?B?S1lIbzJkTkdEVmtLSWw5ZkdWVnY0QUNBclVtQ3Bxb2tWZmlMcVArVWFweEJJ?=
 =?utf-8?B?bGlNOFNJUHh5Zk5mZHc1TGRsYzNlajRIQmFmRWcrOUczVlB0dWpWSkZHZXQx?=
 =?utf-8?B?V3h6ZkJDUHhpSEYwaXVQQ3p5TnU2dkFIQnV3UGxJUWtFZTczWHFXcUhpQUth?=
 =?utf-8?B?L0F5cWlXYisxeTJ1T1lCcWtocTdyVVJkSEF4RmdIUC9JaGMvaExzSGdoTDBm?=
 =?utf-8?B?L2lPSjc4T2NiYVVpMmY5L3VFa0xDak4zTDI3clprT2xrTDMza0N6by9tbXZK?=
 =?utf-8?B?bENrUEdUWS9DaDY0eHNvdUJiN1VsSTB3Vk1vREF3ejZFRkRsYlFWNmt6UGc5?=
 =?utf-8?B?QUNHZnV6VHJHaDZkYjVsMXlhanFSS0xXaXVXVDZkY2YvZmJoellVdUYwN0RC?=
 =?utf-8?B?eEZVMTNJOU9ieGQ5VDNGaEV4TDhWZ0VFTEljYzQyZlZ4aW9MLzI1SW9VS1dJ?=
 =?utf-8?B?ZS9Ld1ZHWlJ5MVlkK1h1S3pQZ05FOUNLaXhCSktITkRHMVcvbzJBYU56SC9U?=
 =?utf-8?B?UDZ6b2NLZU1sVFZkTk9RU3JYb1ZmaVNKNGtnOTdjQWVYQkVadjdHVnp0aklv?=
 =?utf-8?B?Szg1WGJabGhXM0kzMWJlUkx2YmpjOWpNUnZSRnV3c1VMTzY3TVhBV2xzK1o1?=
 =?utf-8?B?WE5EYUpLSFFiOGdOeHNLREczUDNRT2VuWm9raGNDam5FaHhMa2xJSmo1Q2RB?=
 =?utf-8?B?TCtvT3FKLzBMTytldWpoYmlRTDN2L081bmlCTGFxbVhLTWliUEl4S0pwbVQx?=
 =?utf-8?B?cVZuM2pYcndsK0FMTzNEMG9EWUlmY2tQMEZjYjY1WG42SVZrbmJ5N0x4RHJ6?=
 =?utf-8?B?TFJaWVBiUHpIWkpSRE15S2RvcjFQMnVRc1c3c2hoWmYzRGlmRmk3ZEJmUzRR?=
 =?utf-8?B?KzNnWkhYdDdwaitZTW5ZMVo4WE01RXVSTTl5L1ByUlhMV3hLdGFDVkdzcUVt?=
 =?utf-8?B?dnBNVm1FOE1wWTRqaituakNPRUNXczdZVnpiRThsZ0MzM2U4R2hWTVphdzFp?=
 =?utf-8?B?SlI0SDg0K3BGWXZOVTV2U2wzRnNBNzdTbGhGcmo3RWdmLzhIMkMvUmtDU253?=
 =?utf-8?B?UWdobDJtZURZUS9aYTVCRTMvQVlSeTRIQXd5OVhxQ0MrRWExSEdsVzNlOGZy?=
 =?utf-8?B?dDJDSnpEUy9YQ0hHZjZZTXEyRDg4amk0Qk1GbE52SUFzdHJnT29EZm1OdWhZ?=
 =?utf-8?B?eXR1dG5KVjVUS1lVRExJWFZZbmJ6a2VCNmpVazkyQk96cHc1Z1M4Z2ZSZlFr?=
 =?utf-8?B?U1dGRGRJRWs3ZHl1OWtoemI4NWYrR282cTZzRFpDbTRyWHEzOUpJKzd4eEZy?=
 =?utf-8?B?RmhSSlRRSzd1bGF1U2VGTDBEVHJSUUYyTHZTUnFtRmZFa3EyVEFQQkFCazZP?=
 =?utf-8?B?MkFmRC9tZG13VzYxMTlsdE84T2FTMmNjdzgyb3FRYTdEa0w2NE0weFBaOUQx?=
 =?utf-8?B?bHNLcGl0Z1RaNXhvblhLWFV6NFNrankzZTJmN1dNMkg1U2c1cVBXYW9VNkJO?=
 =?utf-8?B?WktzYllxRHVxd0FGVUJiL1BqSEVJSmduTEFiRS9nUk1FTzVlMkhnUm9ZMTR2?=
 =?utf-8?B?ZnBMOWphekdsVm51bWFXTkVUK0V6MzFQTUt4elZVZnprRVRLdDBMak53OElz?=
 =?utf-8?B?YmR4MlFwekJieDY5WE96eFhhNDEzY2szU0lFWWhqZlZmbHVrWlhWOVRvZC9B?=
 =?utf-8?B?SHEwUjFmdVlaSXdlZXNzTHlzK2dTWE83WDdYM2JqbDVCUjJyUVc1bHNrR1Bq?=
 =?utf-8?B?clJkMGpYelhUN3FmYzd2eEwxdmYyajBDUGZxQ3o1MDRYakluWFFMRXNWSzZK?=
 =?utf-8?B?RkxGOERmNUdrVEE2YWgyMkZUcGtUTlplNkZxYzBsQWU1N0JpMnk4UExSNnV6?=
 =?utf-8?Q?C7movBp6FRs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(1800799024)(38070700021)(7053199007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T01nMzFSYkxNNlo4WlFvMDNzZUpvNUgvM2xWRG5MUkxYRFpiRWQ5OVFBaTJZ?=
 =?utf-8?B?QkR3R1YvbVlZWUhXcjVPRUxwdCtHWHRXaHRucXBtUTI4aUk5TnpZUHpiOTRs?=
 =?utf-8?B?N0NsdGoxYnhqb1J3VGU4N21ZTHF6VHhhU20zZjhzeE9VYk1SV3UrM1lNTTlC?=
 =?utf-8?B?b09uSXZ2YXVtKzhGUEpqWFVmT25PTFJRdmxPTGc1ZkdRL3A2ZkRtU3NySHdD?=
 =?utf-8?B?MEJnSm84OTdiQnVnd2FxZ3pibnFtbkhmaTRSa24vMTBWQ21OcGlBTFl1TnFJ?=
 =?utf-8?B?aWlINk84TnNIdDE3aDJRczg5d1J3QnFVTlhQQmg3L01wSnF5OXc5TndUaUtW?=
 =?utf-8?B?L0NUTzVaWnVVUTdVL3NyT1ExRkxrWjd2SGZWdHh1b2xza2xzcWpKaGRCUzc3?=
 =?utf-8?B?R3VkUklzKzZweWN2Tkp4LzR2MjVVMWRZc25vc01mYWNoZGE0U2o2WEZMaXhT?=
 =?utf-8?B?SVhaU0ljUFBRdWhDVkthazJ4d1o5VStHdVVFM3lHdHlobVhHSFVNYjZ1YjE3?=
 =?utf-8?B?UHpzMTB0UlI4QkQ0YjFQaWcrR1RsSWd0ZU1yNjFqUHdIRkE5ajZrZ3dBZ002?=
 =?utf-8?B?QmppcnhCbUZUb3Z6bHczTVdVaXpnRndjTmY3cmxMZkpvTDUrL2F4STFTVDZR?=
 =?utf-8?B?WEw5bTQ1aDlrMVNsOUV1UnJDUHpiazg2MDQzdE9pdS9UMHY1SmpTbkhIamRk?=
 =?utf-8?B?bHpuQVlwdnNnUFpLV2FnbHRZYTNRVXp4RDJNbmg1TDRFcnJWbTRta2Zkd3Qv?=
 =?utf-8?B?dzhGQlpRcWpaMmFCTEhUL3dsQjczTEN5UlFwN0F5Tk93K0FGOE5VY2ljR29C?=
 =?utf-8?B?NWdXRjcvTkJzcjRFakdCQS9xclYvRHI1TUw4enk5aTBPVjViTnZDejdRbUFq?=
 =?utf-8?B?RVRwNWdON21XYWk0WFBWTlNnRTdFaUx0TER6bE1BWDl4aWhvVkVITDdjZ1k4?=
 =?utf-8?B?QWFvSDBKU0dySU8xRmdhME1haE9oTk1KZVZMb0p6VStaWUZBeUw4anp6RmxK?=
 =?utf-8?B?OWVsTU1FVU5PdzZrbGtrTjdXczNSTzViZlljaHh2ZmlmZXBTUjJtYUVlN0tp?=
 =?utf-8?B?OWVKdis5aXpUMjNFQlpQbHR5ZkpqQ3RxL09aTUN4Tk9OekU3VEdETndpOXpG?=
 =?utf-8?B?bEd5b213UGRTb3hyREtuRTdSeXNLdzI0YnQxYVVXNU4wZ3V3QldsbGxpMmkz?=
 =?utf-8?B?cTZNVzVTei9IQ2VyaEk3RmEycU0wa3IwRmFkMWt1a2txMy9oS0xQNkVWVURh?=
 =?utf-8?B?M29xVFB1YWtIeFl1LzNsYnYrTjFhTW5ibzFaYVRBak5zYXgyblg1V1gzeUpr?=
 =?utf-8?B?NCs4emhCNUNoTkJhcWMxcXErcTZVUkVCRjBhdlJkVDFJODFHME5ZWjJyZWJN?=
 =?utf-8?B?aXl6YkgyZDhPaStzWGRoamljRisxRlRRZ0xYYi82NWFQTDh5YUNsc1NxMk51?=
 =?utf-8?B?WGp3R3pxODZ0L01NMHZhMHhqc1pIdEgrK2J5UzRNd2JtVTRkRVZWbHNTQlVx?=
 =?utf-8?B?VlM0aGt6aGN4akR4RDlHOWlNaUFuRmZpTTM1SjVTWkZMSWlrdUJTRWxPSDlz?=
 =?utf-8?B?T2w2SytGMlRmUnEzVjB5K2lNRlVtNjlqbWJnc1FzRldLT1RHMU00YlltcDZw?=
 =?utf-8?B?OVY5bEluTGsxY2Rqa3pOZ2l5RllHaWdieEZXNFc3alNwL1ZoSERZV0l3TE5V?=
 =?utf-8?B?LzJSTU5Mc1B4bTA5VmdPZzBXS3JQLzVBdDRXbXlkU3F4bzZuQ1RJUHVsdHN0?=
 =?utf-8?B?Ti9saU5WejZ3SGZWQXkybERhTzU0cVFicndQVEZVa2FrU1pSS25zTkg1QnZ6?=
 =?utf-8?B?MWEwak4ydkE4YmhiQ05BUEhKbnNVVitGWlY1ZFNNUC9BdG9HeE02TDNDWW1u?=
 =?utf-8?B?aHdHN0cvSXcvM2VzdExVRXMzNXFGeTJkSy9IK1JpdjdNa1RqWHFOOEpEdXlU?=
 =?utf-8?B?ZHBQcmozUXpRTjZObWFrSEJZRHV6aHBkU1Z0WE94K21xajYrY2tTVHJFYlVE?=
 =?utf-8?B?UFlXdjZUNkMya2tmRzRYZ1RsVGxoV2dGMjFaTEV2WTlJT01FQVJ6KzZ1MWQ4?=
 =?utf-8?B?eENuTnNPK0xCTTJJVGVSdzR1V2w3Rk4zTmptUCtoZzl6MmUyYjFNbTJRWHcv?=
 =?utf-8?B?Mm1uenU3OVNNQzJXZFJ3akpTY2U3ZXZEVVNTclpiK2E4SnYwYU53b0hSUzRD?=
 =?utf-8?B?RzJ3Tk9kV2Q5R0E5TmtHTHFGWEhYR2RlekozeWZ3bTN6R1JaSUJQNytreWNK?=
 =?utf-8?B?TjVNeVNLbUQxU1ArdlRac0JSQWxBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3ADB6C9FA8595E4EB617A7E77BE9EE0E@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63a3f9d3-10bc-48dc-8880-08ddf09c018c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2025 18:58:18.7543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CDqU+ixSUqK9Unhx2r9uDmpkqZwfxEw6tfGvUk6ZiYuzaP3GEK2UJFOVuo0nf7BdCVi2QpAKMAUbH88XysC/AMIcKiABQojlSFuqcrWZU8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB10393
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEwMDE3NiBTYWx0ZWRfXz5QsLhh58uHK
 XzRjf1ungAqSizAsgOPtKiKyVbhWI04L+2DdHJ61SZ3NHqBJu3Ns4ANqC1DcCZSbR2/yimLAqBL
 /4KLxQBCBZugCC7Myk9gg+Ix948RFsoOAmIgrsUFMLb2THOfL2YH2CSNZQ3yoAWTk612Gk2vYPl
 BW1PvaZYKlGmUAq7OpmEx/JVH2JsgN2+dTQKyz7Z0MXQh7GT5sJl2G+X57BS567+WFhHrWwuq/p
 WJGAZWpMRvEof89I7pZ/cus1I+JjFchxA66kWQxFZP1YnIZC5HRyL/gOmtuu3DtwC8eKEcsTCKD
 JYJDwkzUFDw5e2fDqJ4H50N6fTF/WzVfir6EETjmhqCy2r9ktNW3FnrTUoaspc=
X-Authority-Analysis: v=2.4 cv=Bf3Y0qt2 c=1 sm=1 tr=0 ts=68c1ca4e cx=c_pps
 a=z61krFjoy38gr3L9Xg80mg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
 a=9_2eveaNVQKwYXlGHLwA:9 a=QEXdDO2ut3YA:10 a=j_clbiFRiAsA:10
X-Proofpoint-GUID: PG9RCvn4WPjzeDNsQ12P8ppkmSnn7pXl
X-Proofpoint-ORIG-GUID: PG9RCvn4WPjzeDNsQ12P8ppkmSnn7pXl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDUsIDIwMjUsIGF0IDk6NDDigK9QTSwgcGF0Y2h3b3JrLWJvdCtuZXRkZXZi
cGZAa2VybmVsLm9yZyB3cm90ZToNCj4gDQo+IEhlbGxvOg0KPiANCj4gVGhpcyBwYXRjaCB3YXMg
YXBwbGllZCB0byBuZXRkZXYvbmV0LW5leHQuZ2l0IChtYWluKQ0KPiBieSBKYWt1YiBLaWNpbnNr
aSA8a3ViYUBrZXJuZWwub3JnPjoNCg0KSGV5IGFsbCwNCldyaXRpbmcgdG8gZmlyZSB1cCBhIGZs
YXJlIGFuZCBwb2ludCBvdXQgYSBwcm9ibGVtIHRoYXQgd2XigJlyZSBzZWVpbmcNCndpdGggdGhp
cyBwYXRjaCBpbnRlcm5hbGx5LCBzcGVjaWZpY2FsbHkgd2hlbiB3ZSBlbmFibGUgaW9tbXUgb24g
dGhlDQp2aXJ0aW8tbmV0IGRldmljZS4NCg0KV2l0aCB0aGlzIHBhdGNoIGFwcGxpZWQgb24gNi4x
Mi55LWJhc2VkIGJhcmUgbWV0YWwgaW5zdGFuY2UgYW5kIHRoZW4NCnN0YXJ0aW5nIGEgNi4xMi55
IGJhc2VkIGd1ZXN0IHdpdGggaW9tbXUgZW5hYmxlZCwgd2Ugc2VlIGxvY2t1cHMNCndpdGhpbiB0
aGUgZ3Vlc3QgaW4gc2hvcnQgb3JkZXIsIGFzIHdlbGwgYXMgdm1tIChxZW11KSBzdHVjayBpbiBh
IHRpZ2h0DQpsb29wIHJlc3BvbmRpbmcgdG8gaW9tbXUgbWlzc2VzIGZyb20gdmhvc3QgbmV0IGxv
b3AuDQoNCldlJ3ZlIGJpc2VjdGVkIHRoaXMgaW4gb3VyIGludGVybmFsIHRyZWUsIGFuZCBmb3Ig
c3VyZSBpdCBpcyB0aGlzDQpwYXRjaCB0aGF0IGlzIGFsbGVkZ2VkbHkgY2F1c2luZyB0aGUgcHJv
YmxlbSwgc28gSSB3YW50ZWQgdG8gcG9pbnQgb3V0DQp0aGVyZSBpcyBzb21lIHNvcnQgb2YgaXNz
dWUgaGVyZS4gDQoNCldvcmtpbmcgb24gdHJ5aW5nIHRvIGZpZ3VyZSB0aGlzIG91dCwgYnV0IGlm
IGp1bXBzIG9mZiB0aGUgcGFnZSB0bw0KYW55b25lLCBoYXBweSB0byB0YWtlIGFkdmljZSENCg0K
RmxhbWVncmFwaDoNCmh0dHBzOi8vZ2lzdC5naXRodWIuY29tL0pvbktvaGxlci8wZTgzYzAxNDIz
MGFiNTlkZGM5NTBmMTA0NDEzMzVmMSNmaWxlLWlvdGxiLWxvY2t1cC1zdmcNCg0KR3Vlc3QgZG1l
c2cgZXJyb3JzIGxpa2Ugc286DQpbICAgNjYuMDgxNjk0XSB2aXJ0aW9fbmV0IHZpcnRpbzAgZXRo
MDogTkVUREVWIFdBVENIRE9HOiBDUFU6IDE6IHRyYW5zbWl0IHF1ZXVlIDAgdGltZWQgb3V0IDU1
MDAgbXMNClsgICA2OC4xNDUxNTVdIHZpcnRpb19uZXQgdmlydGlvMCBldGgwOiBUWCB0aW1lb3V0
IG9uIHF1ZXVlOiAwLCBzcTogb3V0cHV0LjAsIHZxOiAweDEsIG5hbWU6IG91dHB1dC4wLCA3NTYw
MDAwIHVzZWNzIGFnbw0KWyAgMTEyLjkwNzAxMl0gdmlydGlvX25ldCB2aXJ0aW8wIGV0aDA6IE5F
VERFViBXQVRDSERPRzogQ1BVOiAxOiB0cmFuc21pdCBxdWV1ZSAwIHRpbWVkIG91dCA1NTY4IG1z
DQpbICAxMjQuMTE3NTQwXSB2aXJ0aW9fbmV0IHZpcnRpbzAgZXRoMDogVFggdGltZW91dCBvbiBx
dWV1ZTogMCwgc3E6IG91dHB1dC4wLCB2cTogMHgxLCBuYW1lOiBvdXRwdXQuMCwgMTY3NzYwMDAg
dXNlY3MgYWdvDQpbICAxMjQuMTE4MDUwXSB2aXJ0aW9fbmV0IHZpcnRpbzAgZXRoMDogTkVUREVW
IFdBVENIRE9HOiBDUFU6IDE6IHRyYW5zbWl0IHF1ZXVlIDAgdGltZWQgb3V0IDE2Nzc2IG1zDQpb
ICAxMjQuMTE4NDQ3XSB2aXJ0aW9fbmV0IHZpcnRpbzAgZXRoMDogVFggdGltZW91dCBvbiBxdWV1
ZTogMCwgc3E6IG91dHB1dC4wLCB2cTogMHgxLCBuYW1lOiBvdXRwdXQuMCwgMTY3NzYwMDAgdXNl
Y3MgYWdvDQoNCkhvc3QgbGV2ZWwgdG9wIG91dHB1dA0KMzk5Mjc1OCBxZW11ICAgICAgMjAgICAw
ICAgMTYuNmcgIDUyMTY4ICAyNjcwNCBSICA5OS45ICAgMC4wICAyMToyMy43MiBxZW11LWt2bSAg
ICAgICA8PDwgdGhpcyBpcyB0aGUgcWVtdSBtYWluIHRocmVhZA0KMzk5Mjc2OSBxZW11ICAgICAg
MjAgICAwICAgMTYuNmcgIDUyMTY4ICAyNjcwNCBSICA1OC44ICAgMC4wICAxMzozMy40NCB2aG9z
dC0zOTkyNzU4IDw8PCB0aGlzIGlzIHRoZSB2aG9zdC1uZXQga3RocmVhZA0KDQpGb3IgcWVtdS1r
dm0gbWFpbiB0aHJlYWQ6IA0KU2FtcGxlczogMTNLIG9mIGV2ZW50ICdjeWNsZXM6UCcsIDQwMDAg
SHosIEV2ZW50IGNvdW50IChhcHByb3guKTogNTEzMTkyMjU4MyBsb3N0OiAwLzAgZHJvcDogMC8w
DQogIENoaWxkcmVuICAgICAgU2VsZiAgU2hhcmVkIE9iamVjdCAgICAgU3ltYm9sDQotICAgODcu
NDElICAgICAwLjMwJSAgW2tlcm5lbF0gICAgICAgICAgW2tdIGVudHJ5X1NZU0NBTExfNjRfYWZ0
ZXJfaHdmcmFtZQ0KICAgLSA4Ny4xMSUgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lDQog
ICAgICAtIGRvX3N5c2NhbGxfNjQNCiAgICAgICAgIC0gNDQuNzklIGtzeXNfd3JpdGUNCiAgICAg
ICAgICAgIC0gNDMuNzQlIHZmc193cml0ZQ0KICAgICAgICAgICAgICAgLSA0MC45NiUgdmhvc3Rf
Y2hyX3dyaXRlX2l0ZXINCiAgICAgICAgICAgICAgICAgIC0gMzguMjIlIHZob3N0X3Byb2Nlc3Nf
aW90bGJfbXNnDQogICAgICAgICAgICAgICAgICAgICAtIDEzLjcyJSB2aG9zdF9pb3RsYl9hZGRf
cmFuZ2VfY3R4DQogICAgICAgICAgICAgICAgICAgICAgICAtIDcuNDMlIHZob3N0X2lvdGxiX21h
cF9mcmVlDQogICAgICAgICAgICAgICAgICAgICAgICAgICAtIDQuMzclIHZob3N0X2lvdGxiX2l0
cmVlX3JlbW92ZQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByYl9uZXh0DQogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIDEuNzglIF9fcmJfZXJhc2VfY29sb3INCiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgMC43MyUga2ZyZWUNCiAgICAgICAgICAgICAgICAgICAgICAg
ICAgMS4xNSUgX19yYl9pbnNlcnRfYXVnbWVudGVkDQogICAgICAgICAgICAgICAgICAgICAgICAg
IDAuNjglIF9fa21hbGxvY19jYWNoZV9ub3Byb2YNCiAgICAgICAgICAgICAgICAgICAgIC0gMTAu
NzMlIHZob3N0X3ZxX3dvcmtfcXVldWUNCiAgICAgICAgICAgICAgICAgICAgICAgIC0gNy42NSUg
dHJ5X3RvX3dha2VfdXANCiAgICAgICAgICAgICAgICAgICAgICAgICAgIC0gMi41NSUgdHR3dV9x
dWV1ZV93YWtlbGlzdA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLSAxLjcyJSBfX3Nt
cF9jYWxsX3NpbmdsZV9xdWV1ZQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAx
LjM2JSBjYWxsX2Z1bmN0aW9uX3NpbmdsZV9wcmVwX2lwaQ0KICAgICAgICAgICAgICAgICAgICAg
ICAgICAgLSAxLjMyJSBfX3Rhc2tfcnFfbG9jaw0KICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgLSBfcmF3X3NwaW5fbG9jaw0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBu
YXRpdmVfcXVldWVkX3NwaW5fbG9ja19zbG93cGF0aA0KICAgICAgICAgICAgICAgICAgICAgICAg
ICAgLSAxLjMwJSBzZWxlY3RfdGFza19ycQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
LSBzZWxlY3RfdGFza19ycV9mYWlyDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAt
IDAuODglIHdha2VfYWZmaW5lDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGF2YWlsYWJsZV9pZGxlX2NwdQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAyLjA2JSBsbGlz
dF9hZGRfYmF0Y2gNCiAgICAgICAgICAgICAgICAgICAgIC0gNC4wNSUgX19tdXRleF9sb2NrLmNv
bnN0cHJvcC4wDQogICAgICAgICAgICAgICAgICAgICAgICAgIDIuMTQlIG11dGV4X3NwaW5fb25f
b3duZXINCiAgICAgICAgICAgICAgICAgICAgICAgICAgMC43MiUgb3NxX2xvY2sNCiAgICAgICAg
ICAgICAgICAgICAgICAgMy4wMCUgbXV0ZXhfbG9jaw0KICAgICAgICAgICAgICAgICAgICAgLSAx
LjcyJSBrZnJlZQ0KICAgICAgICAgICAgICAgICAgICAgICAgLSAxLjE2JSBfX3NsYWJfZnJlZQ0K
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzbGFiX3VwZGF0ZV9mcmVlbGlzdC5jb25zdHBy
b3AuMC5pc3JhLjANCiAgICAgICAgICAgICAgICAgICAgICAgMS4zNyUgX3Jhd19zcGluX2xvY2sN
CiAgICAgICAgICAgICAgICAgICAgICAgMS4wOCUgbXV0ZXhfdW5sb2NrDQogICAgICAgICAgICAg
ICAgICAgIDEuOTglIF9jb3B5X2Zyb21faXRlcg0KICAgICAgICAgICAgICAgLSAxLjg2JSByd192
ZXJpZnlfYXJlYQ0KICAgICAgICAgICAgICAgICAgLSBzZWN1cml0eV9maWxlX3Blcm1pc3Npb24N
CiAgICAgICAgICAgICAgICAgICAgIC0gMS4xMyUgZmlsZV9oYXNfcGVybQ0KICAgICAgICAgICAg
ICAgICAgICAgICAgICAwLjY5JSBhdmNfaGFzX3Blcm0NCiAgICAgICAgICAgICAgMC42MyUgZmRn
ZXRfcG9zDQogICAgICAgICAtIDI3Ljg2JSBzeXNjYWxsX2V4aXRfdG9fdXNlcl9tb2RlDQogICAg
ICAgICAgICAtIHN5c2NhbGxfZXhpdF90b191c2VyX21vZGVfcHJlcGFyZQ0KICAgICAgICAgICAg
ICAgLSAyNS45NiUgX19hdWRpdF9zeXNjYWxsX2V4aXQNCiAgICAgICAgICAgICAgICAgIC0gMjUu
MDMlIF9fYXVkaXRfZmlsdGVyX29wDQogICAgICAgICAgICAgICAgICAgICAgIDYuNjYlIGF1ZGl0
X2ZpbHRlcl9ydWxlcy5jb25zdHByb3AuMA0KICAgICAgICAgICAgICAgICAxLjI3JSBhdWRpdF9y
ZXNldF9jb250ZXh0LnBhcnQuMC5jb25zdHByb3AuMA0KICAgICAgICAgLSAxMC44NiUga3N5c19y
ZWFkDQogICAgICAgICAgICAtIDkuMzclIHZmc19yZWFkDQogICAgICAgICAgICAgICAtIDYuNjcl
IHZob3N0X2Nocl9yZWFkX2l0ZXINCiAgICAgICAgICAgICAgICAgICAgMS40OCUgX2NvcHlfdG9f
aXRlcg0KICAgICAgICAgICAgICAgICAgICAxLjM2JSBfcmF3X3NwaW5fbG9jaw0KICAgICAgICAg
ICAgICAgICAgLSAxLjMwJSBfX3dha2VfdXANCiAgICAgICAgICAgICAgICAgICAgICAgMC44MSUg
X3Jhd19zcGluX2xvY2tfaXJxc2F2ZQ0KICAgICAgICAgICAgICAgICAgLSAxLjI1JSB2aG9zdF9l
bnF1ZXVlX21zZw0KICAgICAgICAgICAgICAgICAgICAgICBfcmF3X3NwaW5fbG9jaw0KICAgICAg
ICAgICAgICAgLSAxLjgzJSByd192ZXJpZnlfYXJlYQ0KICAgICAgICAgICAgICAgICAgLSBzZWN1
cml0eV9maWxlX3Blcm1pc3Npb24NCiAgICAgICAgICAgICAgICAgICAgIC0gMS4wMyUgZmlsZV9o
YXNfcGVybQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAwLjY0JSBhdmNfaGFzX3Blcm0NCiAg
ICAgICAgICAgICAgMC42NSUgZmRnZXRfcG9zDQogICAgICAgICAgICAgIDAuNTclIGZwdXQNCiAg
ICAgICAgIC0gMi41NiUgc3lzY2FsbF90cmFjZV9lbnRlcg0KICAgICAgICAgICAgLSAxLjI1JSBf
X3NlY2NvbXBfZmlsdGVyDQogICAgICAgICAgICAgICAgIHNlY2NvbXBfcnVuX2ZpbHRlcnMNCiAg
ICAgICAgICAgICAgMC41NCUgX19hdWRpdF9zeXNjYWxsX2VudHJ5DQogICAgICAgICAgICAgIA0K
dmhvc3QtbmV0IHRocmVhZA0KU2FtcGxlczogMjBLIG9mIGV2ZW50ICdjeWNsZXM6UCcsIDQwMDAg
SHosIEV2ZW50IGNvdW50IChhcHByb3guKTogNzc5NjQ1NjI5NyBsb3N0OiAwLzAgZHJvcDogMC8w
DQogIENoaWxkcmVuICAgICAgU2VsZiAgU2hhcmVkIE9iamVjdCAgICAgU3ltYm9sDQotICAxMDAu
MDAlICAgICAzLjM4JSAgW2tlcm5lbF0gICAgICAgICAgW2tdIHZob3N0X3Rhc2tfZm4NCiAgICAg
MzguMjYlIDB4ZmZmZmZmZmY5MzBiYjhjMA0KICAgLSAzLjM2JSAwDQogICAgICAgIHJldF9mcm9t
X2ZvcmtfYXNtDQogICAgICAgIHJldF9mcm9tX2ZvcmsNCiAgIC0gMS4xNiUgdmhvc3RfdGFza19m
bg0KICAgICAgLSAyLjM1JSB2aG9zdF9ydW5fd29ya19saXN0DQogICAgICAgICAtIDEuNjclIGhh
bmRsZV90eA0KICAgICAgICAgICAgLSA3LjA5JSBfX211dGV4X2xvY2suY29uc3Rwcm9wLjANCiAg
ICAgICAgICAgICAgICAgNi42NCUgbXV0ZXhfc3Bpbl9vbl9vd25lcg0KICAgICAgICAgICAgLSAw
Ljg0JSB2cV9tZXRhX3ByZWZldGNoDQogICAgICAgICAgICAgICAtIDMuMjIlIGlvdGxiX2FjY2Vz
c19vaw0KICAgICAgICAgICAgICAgICAgICAyLjUwJSB2aG9zdF9pb3RsYl9pdHJlZV9maXJzdA0K
ICAgICAgICAgICAgICAwLjgwJSBtdXRleF9sb2NrDQogICAgICAgICAgICAtIDAuNzUlIGhhbmRs
ZV90eF9jb3B5DQogICAgICAgICAgIDAuODYlIGxsaXN0X3JldmVyc2Vfb3JkZXINCg0KPiANCj4g
T24gV2VkLCAzMCBBcHIgMjAyNSAxOTowNDoyOCAtMDcwMCB5b3Ugd3JvdGU6DQo+PiBJbiBoYW5k
bGVfdHhfY29weSwgVFggYmF0Y2hpbmcgcHJvY2Vzc2VzIHBhY2tldHMgYmVsb3cgflBBR0VfU0la
RSBhbmQNCj4+IGJhdGNoZXMgdXAgdG8gNjQgbWVzc2FnZXMgYmVmb3JlIGNhbGxpbmcgc29jay0+
c2VuZG1zZy4NCj4+IA0KPj4gQ3VycmVudGx5LCB3aGVuIHRoZXJlIGFyZSBubyBtb3JlIG1lc3Nh
Z2VzIG9uIHRoZSByaW5nIHRvIGRlcXVldWUsDQo+PiBoYW5kbGVfdHhfY29weSByZS1lbmFibGVz
IGtpY2tzIG9uIHRoZSByaW5nICpiZWZvcmUqIGZpcmluZyBvZmYgdGhlDQo+PiBiYXRjaCBzZW5k
bXNnLiBIb3dldmVyLCBzb2NrLT5zZW5kbXNnIGluY3VycyBhIG5vbi16ZXJvIGRlbGF5LA0KPj4g
ZXNwZWNpYWxseSBpZiBpdCBuZWVkcyB0byB3YWtlIHVwIGEgdGhyZWFkIChlLmcuLCBhbm90aGVy
IHZob3N0IHdvcmtlcikuDQo+PiANCj4+IFsuLi5dDQo+IA0KPiBIZXJlIGlzIHRoZSBzdW1tYXJ5
IHdpdGggbGlua3M6DQo+ICAtIFtuZXQtbmV4dCx2M10gdmhvc3QvbmV0OiBEZWZlciBUWCBxdWV1
ZSByZS1lbmFibGUgdW50aWwgYWZ0ZXIgc2VuZG1zZw0KPiAgICBodHRwczovL3VybGRlZmVuc2Uu
cHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2dpdC5rZXJuZWwub3JnX25ldGRldl9u
ZXQtMkRuZXh0X2NfOGMyZTZiMjZmZmUyJmQ9RHdJRGFRJmM9czg4M0dwVUNPQ2hLT0hpb2NZdEdj
ZyZyPU5HUFJHR28zN21RaVNYZ0hLbTVyQ1EmbT0wWG9SNk45VmJrYUpfd0JFTnk4WjI4dURkcWpD
ZTRIUk5DeVYtOG80ZXRxWGVFSk9xb0ZGR2plR0dQNXNRY210JnM9LVg4c2lfclU4cFhLTnlXTk56
QnF4NUZtdi11dDl3MmdTNUU2Y29NREFwTSZlPSANCj4gDQo+IFlvdSBhcmUgYXdlc29tZSwgdGhh
bmsgeW91IQ0KPiAtLSANCj4gRGVldC1kb290LWRvdCwgSSBhbSBhIGJvdC4NCj4gaHR0cHM6Ly91
cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19rb3JnLmRvY3Mua2Vy
bmVsLm9yZ19wYXRjaHdvcmtfcHdib3QuaHRtbCZkPUR3SURhUSZjPXM4ODNHcFVDT0NoS09IaW9j
WXRHY2cmcj1OR1BSR0dvMzdtUWlTWGdIS201ckNRJm09MFhvUjZOOVZia2FKX3dCRU55OFoyOHVE
ZHFqQ2U0SFJOQ3lWLThvNGV0cVhlRUpPcW9GRkdqZUdHUDVzUWNtdCZzPXN5ZGVkWnNCQ01TSk05
X0xkdzZBbC1CcGx2TTdGb2tMd1ZfODBiSnBHbk0mZT0gDQo+IA0KPiANCg0K


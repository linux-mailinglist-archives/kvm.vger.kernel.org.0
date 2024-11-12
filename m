Return-Path: <kvm+bounces-31555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E0F9C4F2E
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:11:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8052F2820D6
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B5E20A5FA;
	Tue, 12 Nov 2024 07:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="JiaCMKTU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505FA4C91
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 07:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731395485; cv=fail; b=lAU90AD7z+P23zgSHJu1KyCXdccEKv+UFtMhpJIcC+0hqVsRZo9CFhF5LSCgZ+v5t6/iWIwoBrbrmzq6WlOEI23KBjAu44+4CYX1xFIvs2Vi/HHTTSa8ZOkIzzJe06vAtrt4n1fB7gCzP0U2kOZYoWgGW9Ge1joKon+yWuExa7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731395485; c=relaxed/simple;
	bh=kZHkPPBsgJFNNg2wYDhBYtvsvbmfwmG+cgkZwOYJJW0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=Q0lpPuZYw2f8G/kB+GeQOg5D3PlHUIJHDimG1+dpSbEBvoRnDij9pydIbxl88zBI0MbuH1lCF54OQa7DFWfiSHrR1WSH/QXmxBuSsa2LOCzYV84QJpaEfv25uJoG16Ghnm0inUlvEh71CGe2OCueNWlcOkXh+qD9KOMQ+e0pWLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=fail (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=JiaCMKTU reason="signature verification failed"; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ABGF68T010324;
	Mon, 11 Nov 2024 23:11:06 -0800
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 42un9d1cmf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Nov 2024 23:11:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B7amDx0agAokpg1qy1E2sBa0icggl16wB+gJm2Z/qbVma+EiSwoyoxzlI5K6717bS6Bl3MdH+WH53nLo1vvhrxI+DJpbgnGjNEt9BbTEMR+XlT1A0ijTnQv7DDK/Km8ELZ+1Ne9ZLQnb9186mLeT7yjdqG/mcN5BIbCJBf3+KM2aKox8wt3dWXbG0QITXmRH32hK9JgaLa3lnTJ79BT+DWy0dqaAoZJFyItOgs6pVgBbqSUx+cM5sTP/71QzFapzMQKgKQKcK+kh6OhO0uS4Q5VvUyjFemzX2LRYPI4q0SuLnpsHW3Dywy756vgQs6rBituLbiXu3P34A+rQEG1KzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h91ABH5fP0GRnPpbX1cBfMZ13piazp6ONrI7mf4Eh38=;
 b=cOcNTuWDgt68ltix+yAEZX4wBUVJYutxL3ktnGQNRbquyDUycTgsjPEfsVzw4+AlO2CFJT+AJN6PT+rdiEcHFNpN7GcyKPFOpUJ530lG/lxeGmEkrd8eVr6my/yXKC3GnELyZ/lSAWHfR+oPsYhw595bBGvu9N3or07a3yaRuB/Sr+qZjJSpSji3YhW0/bs7uzoitkc+KelV3dWuPpCVJaKhveMaSbS1tJexzKS5HTHncuQc9yX0ymufpF3ajSFlCUwffYNO1hZvpmy6G7zkX8vg4YAG6xddWuYe+3On5x2uKmmdHHnT5XD9QesRuTt/mm0gOsbVZ2cZYgAJKciQRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h91ABH5fP0GRnPpbX1cBfMZ13piazp6ONrI7mf4Eh38=;
 b=JiaCMKTUQCDHQq4aNY8CCpqVFDPfL6T0YRktMNFhHw4YZItlEfNe44AFLgHKV8HFl+HXj2VIJygMhK9v6xY1BxgKCkmVCGZ/ka9FE2eYyRuaRTsAmcheVyCjye2SAMXyRzXEWY0aPbnSNJhoev2cRn92f86xA38ItfXNIVVBnew=
Received: from DS0PR18MB5368.namprd18.prod.outlook.com (2603:10b6:8:12f::17)
 by SJ0PR18MB4010.namprd18.prod.outlook.com (2603:10b6:a03:2ea::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 07:11:01 +0000
Received: from DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac]) by DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 07:11:01 +0000
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
 AQHbE96PlQaeJdnt006ohvbKHfff0rKGTA1AgAD2ZICAAnsvgIAA0r4AgARSlACABScygIAAFo4AgAGfYICAFKe0YIAANmcAgADs0JCABpnvQA==
Date: Tue, 12 Nov 2024 07:11:01 +0000
Message-ID:
 <DS0PR18MB53683185B59B8C69778B1C74A0592@DS0PR18MB5368.namprd18.prod.outlook.com>
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
 <DS0PR18MB5368A3903841BDE3BF8C0234A05C2@DS0PR18MB5368.namprd18.prod.outlook.com>
In-Reply-To:
 <DS0PR18MB5368A3903841BDE3BF8C0234A05C2@DS0PR18MB5368.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR18MB5368:EE_|SJ0PR18MB4010:EE_
x-ms-office365-filtering-correlation-id: 64c8110b-52d7-4104-b9c1-08dd02e929ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YUZabGpiWjFXaERpWlZBWXpseTd5OFRZVy80NzFTbDhCZHREOC9RdjBtTmh6?=
 =?utf-8?B?NW5KVVNYREFOU1VRS29OWTdGRm5jeVZWS3hLYXc0WVptcE9hOStFTWY4M1Rt?=
 =?utf-8?B?WVVkWFhwc3RyeVZQeW4ydEo0dzlqV25EWCtQdGNodkZmallqS2pkUTRBM3RN?=
 =?utf-8?B?ZG4wNXpJZUEzUlFHaUVOVjVURjZJdFNpMnFLTkJjTkpncFhZdk16VDYxWVdD?=
 =?utf-8?B?dldXdmNRQzkwUldML3haSm5NaVNIV0wvYVFhejMwaGZ1K1l4MnYwOWZjNDFj?=
 =?utf-8?B?VjNjWW96TTZNaXgwSWJjckptanVDZC9NYzVYMjRTb3B3RzIzUzdaZW5oejNs?=
 =?utf-8?B?Y25GanVhR2lPd2wzNVZVVlYzeVRGQ0lqc2dsbEhzTFVtVW5rdEhKa2NKMHp2?=
 =?utf-8?B?cnJnRnhjWi93YjVOekRqRTdPRVk0Q1R3cE1WTWdJVjdJMDJXSzlvL3BmdWJN?=
 =?utf-8?B?T053eDA1aThEdkZiZW9EcWVNRVlTdC81Z0dZUG00ZlJUTXRVdmt3K3J5NnFE?=
 =?utf-8?B?cFptUXM2ckNjSHB2eG5kc2hpMmhUNlVmVStKbUE2Qnp3N0hrWEE0eFdwdzEy?=
 =?utf-8?B?TCtxV2RSU3grWjl4SGdjTFJXQUcyOXNtZ29XWi9ERkFDY3Y1ZVMvSEhCN3dM?=
 =?utf-8?B?czdYRE5ib2VuS092VVZiZEVJdG0xQ2ZEM05MQmhFQmY1dzRObjNlY2dlUE51?=
 =?utf-8?B?bkNnaHpxYnJzMWtxWGVUWjg3Z2ZDQzdKVkJJZ1FERkpYWDNUVVVNQTZJTCtW?=
 =?utf-8?B?S3Yvbm1WZ3hKL1RuUThHTXBCSlIvS0R6T3JpZ09nSU5NN1hmTFRoRkRvMU5y?=
 =?utf-8?B?QWpDTFMrZXpobEtYVFkwVk42VXVocVVRZm5UZEcwVXJacUtQR1hWRTZCZksr?=
 =?utf-8?B?ZnRaTlhxSExMV29BMUI5N0d1RzJpR0t2VXVzcmM5SlpLcExOSWZJVmY1bzc2?=
 =?utf-8?B?R1FFbGVxWVJEc1QvT3grTVQxQXVFTCthT3JrL2lSNHBybEdCRVNkeVA4RUha?=
 =?utf-8?B?ZDlsVUJ3S1h3WUcxZUZGRk0wU2VOMWRTbTZNY1hzcFRja1VIeFFIOEo5MmdZ?=
 =?utf-8?B?Vkk5S203SzVGYkUzdTJNY0J5N3JMMlRRUmtBMCt3TENYWjFaL05wbkpqdlVD?=
 =?utf-8?B?K1RrRUl1d1RSR0VBU1hkVDVQbUFYWExOMGtadXg1WEdrb3NhOHBURzlHWkhh?=
 =?utf-8?B?S2s4ejF4STlndi9Fbk84dlNjRmZtbFVNRlJlZUVSZDNtRlhYYjdRa2F2bmt1?=
 =?utf-8?B?ZVBPUk5XMFRzeU9ZbXNTTjNwTVpEaEh2YzRFQk1BbWNFRFJqTUVQSE4rd2Js?=
 =?utf-8?B?TlJlVGV4SktCS1Y2Rm0yZUpwbmxLRVlLVjZYdCs3RTJEMUVaNkl2Z3oyMDRx?=
 =?utf-8?B?ckE0N0U5LzFIYkFPTllGRE9Qb0JvK1pBVlY1NVdBSllMSmt6ZDAxT3F1NEtC?=
 =?utf-8?B?NFVtZmxsbTNkNGpRRFM0OE00VEU1S1poT1F2Ky9zWnR5MGFSVllBSkZrNll2?=
 =?utf-8?B?OVpMMmxqN0RRd1BJNjJUdDBRUXJRQ1E0OHRYcTViMHRDbVFhTUJjaUtKbzdT?=
 =?utf-8?B?Q2RBRVZGZmJRL1MvQUJxOXdXOFZvRW03L0lTMHpuby9tVG5LbU5iZmNnKzBJ?=
 =?utf-8?B?akgvMFcxVDh2YjloOERoei9WL0lxSUlRejMxR0NoU1RNUFo2c0diQytYSklJ?=
 =?utf-8?B?TmpBdm5PYVJlbGRQckpWWi85YjV3eEk5YkwvY3MrSDBlNExHUHZjaGM1S1BU?=
 =?utf-8?Q?Im/jQ3u7xKpVI3t1fYHPQqRj+c+x9UVYkItNWzL?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR18MB5368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Wk5wT3ZDbTYycEN4d2kzbE1EOXFIL0FGTmpDY1F3aEZQZnRNd0VOZXlXTk03?=
 =?utf-8?B?a2tuVnU5M3lNNUNWYkFGWVM0MUpsYWt0V05FNExxUmhpd21uZnZja1VxRUxo?=
 =?utf-8?B?dXB0SU53Y1dZcmt5QlZuQ1pZRHR0WFF1QW1jSE8zOVhlRWcxeDBnWHRCQzdB?=
 =?utf-8?B?L3Zhc20zS0ozT0tEZm9qeHdndG02N3lxSVNkaDd3YTBhMDlXa0NQYnU5SmFY?=
 =?utf-8?B?S2QzaFJOeS9ZWU15MllibStpZHpJZDJYcC9mUkNjdlA5aWFqNENJQVJlUkx0?=
 =?utf-8?B?TjNVaEFTRWdJK0RKenlOS3hNelcvdTM5MWlEM0V5NEFwNEozWlQrZGI5T3NJ?=
 =?utf-8?B?Si8xQVFuNGZJZlhieDVaTWFnYzVpU1lMMWM1cnJKQnBGUG1RTk1lcHFZTDBO?=
 =?utf-8?B?Yi9QZFBOOWZnZnZKRFp5T2dSb0JmVU9CN04vNURXcngwM3ByaEw0bnkyTDVH?=
 =?utf-8?B?ZkJJWWFESHlsdElaVDZhbTI2Q0wvb09RWlpCZnlDck1WbWVKZitscG0wWmFP?=
 =?utf-8?B?Y0JyM0IxWHBCdDBvd2J5UkRlOVRKR3d2RktaVGVIVkxFL2UvdjB0cnkrS2Mr?=
 =?utf-8?B?NWhoMHlVOTNraWlIVUNIZzlFdVI0N3Z1MmhwdlZOQjBhRXBnbndpZEphMFVV?=
 =?utf-8?B?MmF6VDlMYlBKQUUrb3g3cVAwNEdVczhVMExyTlpwZjJYTndBOUNKYVJTajVT?=
 =?utf-8?B?R1p3cmcva2xFQVFJZUptNUJSelgxSEFENjBjemlhTlE3UzJiaHgweDI1RVRV?=
 =?utf-8?B?UlVNakZTdXIyMEdZMjI1TFFIS2lEekowUjJqZDl4WG1FMVhwNVpUWkJzK1I0?=
 =?utf-8?B?amF5VkpQMkxQQVFuQzlXN3AzQlN4bm5ieW4wUVA0OEFSUDljckZEcjUveXdM?=
 =?utf-8?B?aCtkMkRQSlJzZ3krK0tmMEdKZUpObUpkQ3VvaFZWQXdBWWMxb3ZsOTAxL0hX?=
 =?utf-8?B?QU1HMHJCRm93endqT0Y0cjdya2ZDOFJzREFBbzlGUW1NRVY4Q285Wjk2Q0p0?=
 =?utf-8?B?UjRhaWFUNGpVS1d5RytHbzFNUVZTaU1vOVNpK0JOYTlaN24rMC9QRkp3blIw?=
 =?utf-8?B?NlpYWUhWTzZmODVVWlU0MGVMbUFlNVdhdk1taFhNOG5uNXpPcDIya0NFVm16?=
 =?utf-8?B?cm9ReVpnSkV3c3ZhQ1BUUk02Z3MrVEhvRFQxVXJCdVRKbXppSjJBMW84N0VB?=
 =?utf-8?B?MXFBTlBsMGFLallxZXdDdFZvZlVhVTU0Nm51VVdTcnlkRndUb3BXVnFzSkJt?=
 =?utf-8?B?ZFYrWXBzRUpxSnlxZkw5M3dBQk1uK09kUU16TzBiZi9UL1d3NzU4K2RnUnBB?=
 =?utf-8?B?YjFHUFpZT1gzVGhBU21qUE1zcWg2SlZWZ3hmaFRvOENYSFBxb0N0NlJ3cWpa?=
 =?utf-8?B?RVNHUmpEQ0NWL3l3Sjlrbk5XNlg4WHFPNFNZcFNHcjVwc1NsbER2dFhneXM5?=
 =?utf-8?B?V2FDbTNHUHVLaDBPTHdDV2VKRkdpV3kwdVZrSk1QeUNRK1liWGgvTVQ1Mmtj?=
 =?utf-8?B?YlJSMUkxVXlaZXdZLzZ1UE94a1drMnFBL0M3VTNqNHk3MU8rTDlYYXZISWM4?=
 =?utf-8?B?N050S0xSOE5Rck1OY3JseVZtN3NsdTM3K0lxR0N3eW5Qa1VhNFpveGpIanFO?=
 =?utf-8?B?RmtKRWI4RkNaYTgxTkpBeDNhUjIwUDNUS3RDdWFCeEVmUWY2RThFMWQwQVQx?=
 =?utf-8?B?S2RuT3Bvdm12SHE4bHNzKzF6a3d0QWRIR01DTTgzaTEraE43R1d4UWVqTDJK?=
 =?utf-8?B?dzZtZTFmNnNQdDltdG4zVWhxam1MR1h5NjlmR1NjTnhEb0xIUG9jREhuTWhW?=
 =?utf-8?B?UHEwZGtDd0tZeXZnMGtnTDJSNzFwZ000VlhtbUhOL29LRTF4bHJ2RTdzSzky?=
 =?utf-8?B?aEU2MGZqckxDbFhXMVJvV001K2NaVnVtd0hHcFZ1cVF5Rm1mSWJGZDNDSDhm?=
 =?utf-8?B?Uk5sOVcrZVhQaUxQTzVWTk1zL3ZTYTMzb1ZpVGFVS0NQQ2xQVEp1M2tuMGM3?=
 =?utf-8?B?a3JPcWtNRUdLUVRRUitVbnM3SWtRRXlXZ295aXdHTEtjVHlobVFJM0Y3QmFo?=
 =?utf-8?B?MlViVUp0cVJMd2hJWkZKQ3E3TU1sS2ZEcFh6VjRURmR0dDNiTFNQQTFDNFkv?=
 =?utf-8?Q?zguriNhsJ/LoLtWFj8TCZhwVn?=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR18MB5368.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64c8110b-52d7-4104-b9c1-08dd02e929ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2024 07:11:01.0525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jTBt4lqXwWWktBV3DP5LDgA8ji8eYH/nC66vB5HjvJrqNcsIf9e5rv1hoQ3mnFOzm7+HybTwt3iE4DC753evsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4010
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: UW0uYz-EqMhT5IGMKuImy2RHQqo3txjq
X-Proofpoint-ORIG-GUID: UW0uYz-EqMhT5IGMKuImy2RHQqo3txjq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01

> Subject: RE: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for NO-
> IOMMU mode
>=20
> > Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
> > NO- IOMMU mode
> >
> > On Wed, Nov 06, 2024 at 12:=E2=80=8A38:=E2=80=8A02PM +0000, Srujana Cha=
lla wrote: > It
> > is going in circles, let me give the summary, > Issue: We need to
> > address the lack of no-IOMMU support in the vhost vDPA driver for
> > better performance. > Measured=20
> > On Wed, Nov 06, 2024 at 12:38:02PM +0000, Srujana Challa wrote:
> > > It is going in circles, let me give the summary,
> > > Issue: We need to address the lack of no-IOMMU support in the vhost
> > > vDPA
> > driver for better performance.
> > > Measured Performance: On the machine "13th Gen Intel(R) Core(TM)
> > > i9-13900K, 32 Cores", we observed
> >
> > Looks ike you are going in circles indeed.  Lack of performance is
> > never a reason to disable the basic memoy safety for userspace drivers.
> If security is a priority, the IOMMU should stay enabled. In that case, t=
his
> patch wouldn=E2=80=99t cause any issues, right?
Another important aspect of this patch is that it enables vhost-vdpa functi=
onality on machines that do not support IOMMU, such as the Intel=C2=AE Core=
=E2=84=A2 i5-2320 CPU @ 3.00GHz. I believe, this enhancement is essential a=
s it broadens the compatibility of our system, allowing users with embedded=
 or less advanced hardware to benefit from vhost-vdpa features.
Thanks.

> >
> > The (also quite bad) reason why vfio-nummu was added was to support
> > hardware entirely with an iommu.
> >
> > There is absolutely no reason to add krnel code for new methods of
> > unsafer userspace I/O without an IOMMU ever.



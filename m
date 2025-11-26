Return-Path: <kvm+bounces-64692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 371EFC8B0AF
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:48:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1CB63B3CBA
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151E133EAE7;
	Wed, 26 Nov 2025 16:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="OE2gKqZx";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mzoxdgv3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD4923D7CF;
	Wed, 26 Nov 2025 16:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764175660; cv=fail; b=J/HvBETzKd3rXJvCh1TLvZztKketaoHuyP7mU1sEl9uLnTL/tOLXoP1zxy2chgA/pRAv33vUQ4nKU9eT7+fdyQNr74L2+XRY87j4UKgQj0vwlUNwRju7t1955A5ZljIayMiJAGVBmHQ5D04C7XUkWhnvo6dHQUJ5uBmHLoAdgUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764175660; c=relaxed/simple;
	bh=6sCnencCZeg7ShaKE+N0T0Q+Pge/umQ8TM29vLFsmsU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mCfAdA3nMfb+/BfJLxdaOaM93anSMKeVC9tami7rniShCrDwBbfXAtVR3tJBALykdPLIMxa/MrnnwEXwL3kyo1YsifPRK8yqa5+bAYXNw6rOZR7UHfhJxg7Cqp3qWBHc+tIwWP0Dmor/b/MQHEahyXHvozH8w7B6wtNFZyE5sYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=OE2gKqZx; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mzoxdgv3; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQEmWFt956473;
	Wed, 26 Nov 2025 08:47:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=6sCnencCZeg7ShaKE+N0T0Q+Pge/umQ8TM29vLFsm
	sU=; b=OE2gKqZx9GewpHigSc2j6cWnMRrKfzcMKdtZohWewy1Sv5+QESPtTTYPC
	c5Av+PLKvWq/rOb/AZ+asPbp9Cr0q7P6bGLe2M3eNaaIRBad+gSrXSYkFKWMmvYZ
	EVTXfr67K1sV1AfwHBa8A+gCbN52XkLBVeTzxabr35QZnDCnhKUXiIG7rWJAcleo
	xM+0QxsaQ9GARk18PE+oNuBfv6nVvMktPkUbYUsbPpTXEb7KK/qnnfWHyLUy3cKH
	TiNVKrRLs++NVW3+mX344aGEVGUjvCamoKRZehVQlZoHt6IcAOytXfCbU3HEWRtg
	dhaT9k6Jp8hXTzZY+nk4rlz5WFFbw==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020103.outbound.protection.outlook.com [52.101.201.103])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ap3my883q-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 08:47:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q8wkrR/GL/Fpz+i0Izxa1YUbeCM5KDCslJ16fT6xcgO7mGqexzB00fePw4S9Vsy4xdp2g/oNjmP9E9EDOMDJ/cpIU7lIso3P5CUGEaKHaoBRS+RiuFQ7gCMVuoJ63y5fMWh3+J/g+uBIfETBspCuDQPE/N2NFHgs86PgNlUvg4nfTF03YMUKQyP4MnjzkF2LuNctoZPz5hef3R4tk3hV+WRa8TVwlhTx3ggcHDnn344V+0ry6qfakncnxzSbmHTh9rScU+c8MlUYx4CfSNDPo2NU0qFtdtMyl5/BKv01cSWS2kYQbURcT3xzkqGNkSWTTsIO1MWzhxL+ipKOAeY58Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6sCnencCZeg7ShaKE+N0T0Q+Pge/umQ8TM29vLFsmsU=;
 b=xykpGi3HanEJ/kgndW9F2AzDHtBCCUHY42aOEvVf5kZ3xKntIFQXOitY0xkGSCX/sR+UY7u/Qu/yAHbJ+QLOhKvIO7e8jAWUPwKT+C9t8gC3o8tbB8BljXNaoO+BYuq4YFmLFvVtreTIjmlWfNUKLIC3qM814YpEm8h5x+GUf54Uy5dF35eq8+M3V+3+MAeRIRd7sbW6nh+ZxL2yq0q//Cbm2WJ2M1plJ324St6kLWUF/B44YPfE+3a0eH63cbk6x6K9rGKkivX6yRiOxSVFK0DoJ/MZghjcg6zaLWphBl9issH0qp5SNbeZ1eBwn3fbuqCQKWhD9d2U9VMr1u4elg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6sCnencCZeg7ShaKE+N0T0Q+Pge/umQ8TM29vLFsmsU=;
 b=mzoxdgv3Is1P/uZ/S943socfjhiLRpcIKXQ5dRN+k4jxbCtGb/SYhWy8MPMY1m/4heMW+/ts90/8QmAe0pgiaONEqHzhSU+nRiXCp4eubu72vbYRmYhp1GuNWrSaQ00LnAmoUlnwIvjPk6OXjBvzw4ytSt7D890yHWj67nxV0fri4JVvwfUpEpE/i5womJ0BHac+XzQIm8YJVwKnKg8IaRzaVIGGEEGHEEs8F/nOZn6BwxHjOTl24V2lrV5Y2C7K8Na48u1bJJl7coPDSgwM19UFGap+pyNGl3fT7kQamSTnf/3eNwzWrDiJ7zWsX8E9rNZMGL1DkM3lbUq1aSnleQ==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by CO1PR02MB8618.namprd02.prod.outlook.com
 (2603:10b6:303:15d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Wed, 26 Nov
 2025 16:47:31 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9343.016; Wed, 26 Nov 2025
 16:47:31 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] vhost/net: check peek_head_len after signal to
 guest to avoid delays
Thread-Topic: [PATCH net-next] vhost/net: check peek_head_len after signal to
 guest to avoid delays
Thread-Index: AQHcXi98HPUjRK7uJEmyz5eQdWvl9LUEgvAAgACpWgA=
Date: Wed, 26 Nov 2025 16:47:31 +0000
Message-ID: <C814D406-DA1A-497B-9A5F-C6ED60BD018A@nutanix.com>
References: <20251125180034.1167847-1-jon@nutanix.com>
 <20251126012918-mutt-send-email-mst@kernel.org>
In-Reply-To: <20251126012918-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|CO1PR02MB8618:EE_
x-ms-office365-filtering-correlation-id: 0466ad96-ec60-4966-a5f0-08de2d0b7de0
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eHJ4ZEU2QnBsZlNYdzlvRWFsZnI4Tno0d3F0MFZKU0Q5Y2RyYzZxb09ML0Q0?=
 =?utf-8?B?bnZ4NDFBQmp3bk5nSmFFdGpjMklGVlJPanM0ckNJZ3U2bEF0d2ZMOWYwL3U4?=
 =?utf-8?B?Y3BxTk1JUXNYekROTi80dEtrM2RCL1BQUXpYN0Z0TWZtOU5MQXAyaWRBTHVo?=
 =?utf-8?B?bUhKQklweGo2WjhHYlRUbi9nbHlSMnNyaHJLMjZ5c3VDZGQ1TUI1MWFvMzBw?=
 =?utf-8?B?b2hURjVYTFFqR3NoQUppL0twdXFmOFo3bFd1WTZQaG1FUHpUamRtalkxNWk0?=
 =?utf-8?B?ZkpuQ0JTc0VaU25uQzJDUjBmdk1qMEh6WkRHV0Z0ZE92OEVJcVp1eU9WWkZQ?=
 =?utf-8?B?NFBsaWV3TC8ydzlsc0t5ZElRVkhVZk53SWc1TDZKTUNlc1VKYzhlMkxGQ3d3?=
 =?utf-8?B?VmlXenlURUlhNHRtL2o4SUgrczZVUzkxWHlmelVlR3BkZjAyenNVZTlzM0xS?=
 =?utf-8?B?S3pwVWEvM092bC9BcXpNSWc2L1ZSMXN3NEtGYkRHOGZFTTdudlAvN3A3STlU?=
 =?utf-8?B?NlFsQmF1dEpoc05vVzNidUJTZG9sS1orOGpPRkdvc0JVcWJhMko2aXVZQVZm?=
 =?utf-8?B?dUtJLzYyVWdNWkhxVUZsK0hqdE80Qnl2cWRNQ3ZoU0tnZFJ6M25VaGJWRFR3?=
 =?utf-8?B?YzZOeTZCcWF4Nkx4dW5ZU1R2N3FWMVpnWGhXd1JZOWJXYTdvSVM4N05WVjdU?=
 =?utf-8?B?Yng1NG13MUovQ0huMzEyU1VQTmt1MW92bEtnL2ZZVWp3d0VmTnQrcW55SkYr?=
 =?utf-8?B?MjNmS29xSDRQVnV4L01nM01tMHlOajlTMWNFVVlydGtQdzNzMUdKTE91b3Bo?=
 =?utf-8?B?Mm5oWEZxaHZSVDNwN2NMS1cwQjEvd0ptNFgyWTRJeHdCVTBURUdaczdTL0Zx?=
 =?utf-8?B?VlFhMHBQVmhkaHdEYXdwZWtJTjk2NGxsZ3JUNGNkYWJsN3M4dHhsWS9FY1Z1?=
 =?utf-8?B?MDh1K01MTzUxYXI4K0dBQzdzOU9Hc0poS24rWWhlSldFYm9RQ1Y3VE1tcHFs?=
 =?utf-8?B?TGQyOUlaQi8wd1R1V3F6ZThNcXZwdGRWdHdrM0pIdGw4N2dVYVdNZXI2ajQr?=
 =?utf-8?B?eFQ4aVA1aWt5bTByOEhRaFN1UThjMDFUZGpSTUJiMkZ5aklxYmlRTTg4WlE5?=
 =?utf-8?B?UGJEcEJPcE9leGd1SEVzTkI0TGhBZVh0bEtHRmtORndkWGJ4bjZlaUhSRHJ4?=
 =?utf-8?B?d1UrdmFZYUt6MEN3eWlsaGRIUUhHU0VOeXduRy9KYUlIZE9kcjVra2NtM0o0?=
 =?utf-8?B?VzVlQU5OS21hZnhQLzdyRm5naGZSZjNpY2xzOFEzY3VwUURSRGs2VGJmNURQ?=
 =?utf-8?B?SlRCNjBZU0gyemVucHY0KytGbk9KbWFYRXJ1TCtITjZVSEZQWCsvTEdaTWNV?=
 =?utf-8?B?SzlicllEL3ZNSkp6NE5hVWV0R1c5QVdiR1JEbDFKQ1FjZHVpSm5lclU0TFpp?=
 =?utf-8?B?ekl5YXRieS81TTU5cnFYeDJLWTVBRjArUXlxT294OWtVVjJUUFRUQUQxbzNP?=
 =?utf-8?B?V0p2alZMK0licy9TR0JRY1VUNHQrb1poOXgwekdiYkxxK3ZKeFRkaGY2NDhV?=
 =?utf-8?B?NmtZYjdXQzdRY3ZOc1ZtSHlQMnVSR3IydGtFTTltQkhvUFU0akFNVVFqNVVx?=
 =?utf-8?B?YWhPdHUxTkFkc1FZWUV2ZnAxU3lkY0xFblZYdmtFZGJmYU0vMFZ2UE1mSmYz?=
 =?utf-8?B?bmpMRER0TldQRENLRDQ3WGpDNmZzMUlNOGtNSmhqMXVEVU0veU5BSUdXSHc2?=
 =?utf-8?B?YzN1WXJwcHFBYzRCM3FncnplT0tvSlo0Vms2OExZQkhBK1hHVXIreHdCUFdL?=
 =?utf-8?B?YXFOQ3dJakZXN00vdjcyUGNvYm1UQmZaZExCVit0RTNLdUNIcnp6OWlnN2hD?=
 =?utf-8?B?UHRIeFVuQ3FFWFY5R3JHSnBCUjFDSzF5a1VzY0hkcTE4UDBwamtKRWZvTFRi?=
 =?utf-8?B?Q013ZFd4cEEzTzhKc1N1KzNaUW5JU3BMeUJwdDBPVjhjOVZNVVJpV2U1TjBv?=
 =?utf-8?B?aXhpWGdERWNqajVmdDQxaDNyRE5lVnczd3FxckVFMlV6TkU4VXZHS3ptUWZS?=
 =?utf-8?Q?hfnNOx?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NHp5YTE2QkZadjBwcTVNT0hDWXFlbHhXTWFsbWRWVUhoeEtYd3JGRUZ1NmNU?=
 =?utf-8?B?RzU3S0pCKzJna2hCczU0eU4zRGJrM2FRNUowTG1VcEZYL1dUamx6UUFqRzBs?=
 =?utf-8?B?L3NyamZFS2hiK3JpVUlVN3JWNU56RnBnWkFUaVU4NjVvUEJSakM2SjRSYjlX?=
 =?utf-8?B?eENZUUZBeEMwZmNNRC9wK0t3Q1pZdWZUZVVZcTRRQlp3WGxnb2k0cm1wdW5K?=
 =?utf-8?B?V2NxQjAvR3l6S1JoVVdnYzFGdTh5K29vV05qRXBVUUtzTUNVR29aWXNrUGEx?=
 =?utf-8?B?SVRRQ0todzdmMXViUnlPcUF4V0UrWWVBcmFPZTB0Q0VjMXVLZ25LTnFnNHk3?=
 =?utf-8?B?ZkxUTE82clBiYTR4dDF3YkNEc2NZd3M4d2U2RE5KT3lMaWJWSWlLeFB1SVBX?=
 =?utf-8?B?eS9RQWpIeU1zSU9GanZ6eUU2T1dJdGdJQmtQWlFBMVFNN0JtVlZsWFNpbHVh?=
 =?utf-8?B?R3NEbWFtR0k2aXYvRVVYNHR4bit6MTB1aWlTRlU5ZEVpTS9ZMHVnMitzenNO?=
 =?utf-8?B?dXM1ZmE0bVJrZGJ3ZFlHTTU5VDl0KzUwN1ByMEVhUlV5dXNLZ3BWK1hGbGc2?=
 =?utf-8?B?dnQ1WnVHYjV3SHIrMUpTa1ZqT3RLL05kT3dSUXVpalF3M3RScUEwMHNmMU5G?=
 =?utf-8?B?aG9kTnprRVI2MmZ5cmczcWdVd0VvdTU0ZDdROHBoTFdSaXBvQXV6cWNpUjNM?=
 =?utf-8?B?SzZXOEpWMnRBSE1Wb3dPQnZCbktaSEM0a0IvS1Z6NlQ5RFZicmdqaW5PR0Ux?=
 =?utf-8?B?Vnd1bC91RjJIdVNSbS9iQ2hwMHl4THVTV0hyaEtWV3ROYlFmckl0STZOazhB?=
 =?utf-8?B?R0ovVG94M2ozeDVkWTNleTVjZGpOR25NblVKdmgyYk5aNXdsbmJ5NUVmU2RK?=
 =?utf-8?B?OGo5YzNkRUVMSmxUMVJXZVovd2xJTHRlVkFWVW5VaTNqZzZIQ2x2ZS9SdHpv?=
 =?utf-8?B?TlY2clVXcTQ2bXNQOWdGUHRXQ25yeXpLZGRSUWlmQWZHMXpQY2Y3SS94UkFw?=
 =?utf-8?B?amppYkp6SUk2VDFlcXZDOU5rb1QwZ2tlbUFCMW9PdmN1UE5GMHRFMnZhRTR3?=
 =?utf-8?B?MXZzM3R1T2dYNUloMyttYktZRGxKekZKbncyNXlUdUpiKzBqZmI2UWozdW5r?=
 =?utf-8?B?R3RxemFQOVdUL1NZV1hEMlhKZGN3dW8zVmdpYkljNENIMjF4WDIxVVE0Z3pJ?=
 =?utf-8?B?clA5bkkvZXVLdXZ0b1FLbnIzQy9PbGQ0RUNsT0txT3lTYklZVHRmTXhhSG9C?=
 =?utf-8?B?NElBalJ5VXlzS0RRaS9vSVFJeVJaYi9IYUtGc3pjdmxYaTl5ZHhOZHFYeWNl?=
 =?utf-8?B?a25jSFR3VEhXcnlyRTgwQ2pPUzJOQ1hkNUN0eFBoSjBqSDlUNXE1VHhmQ3Ju?=
 =?utf-8?B?MVlPQUxyT25jYzN6bFc2a0VDV2Y5RjBlZUtPQkNWcDZyS053bmRlV3BsNlBW?=
 =?utf-8?B?TzNxVXJqRkIrQ2QyUG16bDFqVXEzT2g2MTNMeVg2bW5CSGFNOWduYjBRUEFx?=
 =?utf-8?B?czVNRkM0NFZNdnpCVEEycVJnMnRuNkxWRUo4VGVxVEk3RnRyYjVNN0ZKMmZh?=
 =?utf-8?B?Q0g3b2trRzNwMmtDNzdHR3hJWksvTnVldW1GMjZ1R0pQTU9taFRRb0theUVa?=
 =?utf-8?B?NEY0SDhkakhyT2s3Ylp1RnVaNkYrRHlrNUZ0NngzZ1MrODlCYzVFcU5Kcyt4?=
 =?utf-8?B?WEw1aVpSL01IMnJ3aHJxTVI5bXVjcE1CTjRZNGZmMVBHMFJmZ2M5M2RJM1dZ?=
 =?utf-8?B?UjRZK1JrQnU0YjBUcE5vSlN3UEswTVdoUTZNRGlJUGhHMXhHVDZ1UHB6QkpJ?=
 =?utf-8?B?NUNWOExWZ0RwVHZzR3hRS3p1WUpOT09XTXZwdGJObG42dGZHenRRRk1yeXh3?=
 =?utf-8?B?bThBTld0eHNRbEova2Y0aUN1ekRhQWRwdFpHL3BZNEMrTGFGYXFLMzJ6OEpP?=
 =?utf-8?B?TVY2b09HaEhORDlKVzJNNFJUbURMYWthY3ZhVmFKQlZ1MTgrUDJWejFKdE9p?=
 =?utf-8?B?YlgwYW01QWkvR3lJNkRKY0JVQ1g3aDYzUzRaeG1Zb1RRZlp3dm83eTlrbzl6?=
 =?utf-8?B?c0x2V3BubGZjN3Jnd2lNVzFaOGlCRlhhMk9uTnp5VUVObjRaZXpXS05EeFNP?=
 =?utf-8?B?c2tBdklhdE9WR21qTnh2L29kZDRUTlE5bmFzUmRqZmdJdENkaWs5ekxXZlRh?=
 =?utf-8?B?TTh0OUx3Qkl2SzRiZVRTSHQ5NlliWFpaa0lxTGMwaXlONVFacWtQUnVMNjFm?=
 =?utf-8?B?eXd1RHpMWjc2RzFHYktvMEhIZzd3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E6DF70707DC8A42A692D046D0038145@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0466ad96-ec60-4966-a5f0-08de2d0b7de0
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 16:47:31.2435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5eR7QBclmcxi7ttZSkaVd1w34r9url/C774Amam1B86CuKTA/xoDdgPj3KuMhaccxFs5axYI0Noi/IpkGzKXsWbPqfPMxBCT8PCIqIDoCxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8618
X-Authority-Analysis: v=2.4 cv=b8+/I9Gx c=1 sm=1 tr=0 ts=69272f25 cx=c_pps
 a=CFps2rDb9cXvy/q1LzOFGQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=CEpVb00vODu5yaGI-zsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDEzNyBTYWx0ZWRfXynMID6SK5NZ3
 4dj2oK4hrSKP5i2iLjIEeqfoHbr7Hj/qL2slYgfC25xPjuA8AH1cXsjomTGQC3M2YZnxQjwNAK3
 PYZL27XMouv3BpejaRFhfrMwwjfFt1ufzNKkwR3AZ0gHsGD6+hu0vBvzjhv023lDOwp3TEuInjv
 19tYthUvXI1bj72RI+y6w9LZSaHSAc4Fmb81+qvTuC5BZ6lIPe9AVetr5FbZQ8j/eN1AJjlO4KT
 xOwl1H6HRq49ke43cGC2IjMxyEo2pngIIH6B+lcDUM+N1g7c945B8KccZj4EItWvBi5nxgjRsqC
 cpeVY+bT6mt4VFP+gkq/Rkf+7+DMWBH/hEwioya0JqlNwuWMfZrZCuXlW9V+S0TxQG1JTXSEqZk
 sgL6YKHnq8N7MXQVF1zedzAcSXLDdg==
X-Proofpoint-GUID: aNYWb1Qfk5MblI7Gco0WhQQAduw0S__p
X-Proofpoint-ORIG-GUID: aNYWb1Qfk5MblI7Gco0WhQQAduw0S__p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDI2LCAyMDI1LCBhdCAxOjQx4oCvQU0sIE1pY2hhZWwgUy4gVHNpcmtpbiA8
bXN0QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9OOiBF
eHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBUdWUsIE5vdiAyNSwg
MjAyNSBhdCAxMTowMDozM0FNIC0wNzAwLCBKb24gS29obGVyIHdyb3RlOg0KPj4gSW4gbm9uLWJ1
c3lwb2xsIGhhbmRsZV9yeCBwYXRocywgaWYgcGVla19oZWFkX2xlbiByZXR1cm5zIDAsIHRoZSBS
WA0KPj4gbG9vcCBicmVha3MsIHRoZSBSWCB3YWl0IHF1ZXVlIGlzIHJlLWVuYWJsZWQsIGFuZCB2
aG9zdF9uZXRfc2lnbmFsX3VzZWQNCj4+IGlzIGNhbGxlZCB0byBmbHVzaCBkb25lX2lkeCBhbmQg
bm90aWZ5IHRoZSBndWVzdCBpZiBuZWVkZWQuDQo+PiANCj4+IEhvd2V2ZXIsIHNpZ25hbGluZyB0
aGUgZ3Vlc3QgY2FuIHRha2Ugbm9uLXRyaXZpYWwgdGltZS4gRHVyaW5nIHRoaXMNCj4+IHdpbmRv
dywgYWRkaXRpb25hbCBSWCBwYXlsb2FkcyBtYXkgYXJyaXZlIG9uIHJ4X3Jpbmcgd2l0aG91dCBm
dXJ0aGVyDQo+PiBraWNrcy4gVGhlc2UgbmV3IHBheWxvYWRzIHdpbGwgc2l0IHVucHJvY2Vzc2Vk
IHVudGlsIGFub3RoZXIga2ljaw0KPj4gYXJyaXZlcywgaW5jcmVhc2luZyBsYXRlbmN5LiBJbiBo
aWdoLXJhdGUgVURQIFJYIHdvcmtsb2FkcywgdGhpcyB3YXMNCj4+IG9ic2VydmVkIHRvIG9jY3Vy
IG92ZXIgMjBrIHRpbWVzIHBlciBzZWNvbmQuDQo+PiANCj4+IFRvIG1pbmltaXplIHRoaXMgd2lu
ZG93IGFuZCBpbXByb3ZlIG9wcG9ydHVuaXRpZXMgdG8gcHJvY2VzcyBwYWNrZXRzDQo+PiBwcm9t
cHRseSwgaW1tZWRpYXRlbHkgY2FsbCBwZWVrX2hlYWRfbGVuIGFmdGVyIHNpZ25hbGluZy4gSWYg
bmV3IHBhY2tldHMNCj4+IGFyZSBmb3VuZCwgdHJlYXQgaXQgYXMgYSBidXN5IHBvbGwgaW50ZXJy
dXB0IGFuZCByZXF1ZXVlIGhhbmRsZV9yeCwNCj4+IGltcHJvdmluZyBmYWlybmVzcyB0byBUWCBo
YW5kbGVycyBhbmQgb3RoZXIgcGVuZGluZyBDUFUgd29yay4gVGhpcyBhbHNvDQo+PiBoZWxwcyBz
dXBwcmVzcyB1bm5lY2Vzc2FyeSB0aHJlYWQgd2FrZXVwcywgcmVkdWNpbmcgd2FrZXIgQ1BVIGRl
bWFuZC4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29t
Pg0KPj4gLS0tDQo+PiBkcml2ZXJzL3Zob3N0L25ldC5jIHwgMjEgKysrKysrKysrKysrKysrKysr
KysrDQo+PiAxIGZpbGUgY2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygrKQ0KPj4gDQo+PiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy92aG9zdC9uZXQuYyBiL2RyaXZlcnMvdmhvc3QvbmV0LmMNCj4+IGluZGV4
IDM1ZGVkNDMzMDQzMS4uMDRjYjVmMWRjNmU0IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy92aG9z
dC9uZXQuYw0KPj4gKysrIGIvZHJpdmVycy92aG9zdC9uZXQuYw0KPj4gQEAgLTEwMTUsNiArMTAx
NSwyNyBAQCBzdGF0aWMgaW50IHZob3N0X25ldF9yeF9wZWVrX2hlYWRfbGVuKHN0cnVjdCB2aG9z
dF9uZXQgKm5ldCwgc3RydWN0IHNvY2sgKnNrLA0KPj4gc3RydWN0IHZob3N0X3ZpcnRxdWV1ZSAq
dHZxID0gJnRudnEtPnZxOw0KPj4gaW50IGxlbiA9IHBlZWtfaGVhZF9sZW4ocm52cSwgc2spOw0K
Pj4gDQo+PiArIGlmICghbGVuICYmIHJudnEtPmRvbmVfaWR4KSB7DQo+PiArIC8qIFdoZW4gaWRs
ZSwgZmx1c2ggc2lnbmFsIGZpcnN0LCB3aGljaCBjYW4gdGFrZSBzb21lDQo+PiArICogdGltZSBm
b3IgcmluZyBtYW5hZ2VtZW50IGFuZCBndWVzdCBub3RpZmljYXRpb24uDQo+PiArICogQWZ0ZXJ3
YXJkcywgY2hlY2sgb25lIGxhc3QgdGltZSBmb3Igd29yaywgYXMgdGhlIHJpbmcNCj4+ICsgKiBt
YXkgaGF2ZSByZWNlaXZlZCBuZXcgd29yayBkdXJpbmcgdGhlIG5vdGlmaWNhdGlvbg0KPj4gKyAq
IHdpbmRvdy4NCj4+ICsgKi8NCj4+ICsgdmhvc3RfbmV0X3NpZ25hbF91c2VkKHJudnEsICpjb3Vu
dCk7DQo+PiArICpjb3VudCA9IDA7DQo+PiArIGlmIChwZWVrX2hlYWRfbGVuKHJudnEsIHNrKSkg
ew0KPj4gKyAvKiBNb3JlIHdvcmsgY2FtZSBpbiBkdXJpbmcgdGhlIG5vdGlmaWNhdGlvbg0KPj4g
KyAqIHdpbmRvdy4gVG8gYmUgZmFpciB0byB0aGUgVFggaGFuZGxlciBhbmQgb3RoZXINCj4+ICsg
KiBwb3RlbnRpYWxseSBwZW5kaW5nIHdvcmsgaXRlbXMsIHByZXRlbmQgbGlrZQ0KPj4gKyAqIHRo
aXMgd2FzIGEgYnVzeSBwb2xsIGludGVycnVwdGlvbiBzbyB0aGF0DQo+PiArICogdGhlIFJYIGhh
bmRsZXIgd2lsbCBiZSByZXNjaGVkdWxlZCBhbmQgdHJ5DQo+PiArICogYWdhaW4uDQo+PiArICov
DQo+PiArICpidXN5bG9vcF9pbnRyID0gdHJ1ZTsNCj4+ICsgfQ0KPj4gKyB9DQo+PiArDQo+PiBp
ZiAoIWxlbiAmJiBydnEtPmJ1c3lsb29wX3RpbWVvdXQpIHsNCj4+IC8qIEZsdXNoIGJhdGNoZWQg
aGVhZHMgZmlyc3QgKi8NCj4+IHZob3N0X25ldF9zaWduYWxfdXNlZChybnZxLCAqY291bnQpOw0K
PiANCj4gDQo+IExvb2tzIGxpa2UgdGhpcyBjYW4gZWFzaWx5IHNlbmQgbW9yZSBpbnRlcnJ1cHRz
IHRoYW4gb3JpZ2luYWxseT8NCj4gSG93IGNhbiB0aGlzIGJlIGdvb2Q/DQo+IA0KPiBGcm9tIHRo
ZSBkZXNjcmlwdGlvbiwgSSB3b3VsZCBleHBlY3QgdGhlIGNoYW5nZXMgdG8ganVzdCBhZGQgYW5v
dGhlciBjYWxsIHRvDQo+IHBlZWtfaGVhZF9sZW4gYWZ0ZXIgdGhlIGV4aXN0aW5nIHZob3N0X25l
dF9zaWduYWxfdXNlZC4NCj4gV2hhdCBhbSBJIG1pc3Npbmc/DQoNCmNvbnNpZGVyIHRoZSBmb2xs
b3dpbmcgcmFjZSwgYWNyb3NzIE5VTUEgbm9kZXMgd2hlcmUgaXQgaXMgbW9zdCBleHBlbnNpdmUu
DQoNClNvY2tldCAxIChwTklDKSA8LS0tLS0tLS0gTlVNQSAtLS0tLS0tPiBTb2NrZXQgMiAodmhv
c3Qgd29ya2VyKQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZob3N0
X25ldF9yeF9wZWVrX2hlYWRfbGVuID0gMA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgcGVla19oZWFkX2xlbiA9IDANCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgdmhvc3RfbmV0X2J1Zl9wZWVrDQogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHZob3N0X25ldF9idWZfcHJvZHVjZQ0KdHVuX25ldF94
bWl0ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwdHJfcmluZ19jb25zdW1lX2JhdGNo
ZWQNCnB0cl9yaW5nX3Byb2R1Y2UoKT0wDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgZWxzZSBpZiAoIXNvY2tfbGVuKQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgdmhvc3RfbmV0X2VuYWJsZV92cShuZXQsIHZxKTsNCiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdHVuX2Nocl9wb2xsDQogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYWRkX3dhaXRfcXVldWUNCnRmaWxl
LT5zb2NrZXQuc2stPnNrX2RhdGFfcmVhZHkoKQ0KICBzb2NrX2RlZl9yZWFkYWJsZQ0KICAgIHNr
d3FfaGFzX3NsZWVwZXI9dHJ1ZQ0KICAgICAgd2FrZV91cCAuLi4NCiAgICAgICAgdmhvc3RfcG9s
bF93YWtldXANCiAgICAgICAgICBUVFdVDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgdmhvc3RfbmV0X3NpZ25hbF91c2VkKCk7DQogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICByaW5nIG9wZXJhdGlvbnMgKHRha2VzIHRpbWUsIFNNQVApDQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzaWduYWxsaW5nIGd1ZXN0
ICh0YWtlcyB0aW1lKQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZo
b3N0X3Rhc2tfZm4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzY2hl
ZHVsZSgpISENCiAgICAgICAgICB0dHd1IHJxIHNwaW5sb2NrISAgICAgICAgICAgICAgIHJxIGxv
Y2sNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNjaGVkdWxlcyBv
dXQNCiAgICAgICAgICBJUEkhICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWRsZSBwYXRoDQogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzY2hlZF90dHd1X3BlbmRpbmcNCg0KQWxsIEni
gJltIHNheWluZyBoZXJlIGlzIHRoYXQgaWYgd2Ugc2ltcGx5IHVzZSB0aGUgc2lnbmFsIGR1cmlu
Zw0KdGhlIHRpbWUgd2hlcmUgd2UgYXJlICpub3QqIGFkZGVkIHRvIHRoZSB3YWl0IHF1ZXVlLCB0
aGF0IHdpbGwNCmdpdmUgcGxlbnR5IG9mIHRpbWUgZm9yIHRoZSByYWNlIGFib3ZlIHRvIHJlc29s
dmUgd2hlcmVpbiB3ZQ0Kd2lsbCBnaXZlIHRoZSBsb2NrbGVzcyBUWOKAmWVycyB0aW1lIHRvIGFk
ZCBtb3JlIHdvcmtsb2FkIHRvIHRoZQ0KcnhfcmluZywgd2UgY2FuIGVpdGhlciBhKSBwcm9jZXNz
IGl0IHJpZ2h0IHRoZXJlIChieSBhc3NpZ25pbmcNCmxlbiBhcyB5b3Ugc3VnZ2VzdGVkIGluIG90
aGVyIG1haWwpIG9yIGIpIHNldCBidXN5IHBvbGwgYW5kDQpwcm9jZXNzIHR4IGhhbmRsZXIgb3Ig
b3RoZXIgd29yaywgd2l0aCBub3RpZmljYXRpb24gZGlzYWJsZWQNCg0KRm9yIHRoZSBzYWtlIG9m
IGFyZ3VtZW50LCBsZXTigJlzIHByZXRlbmQgc2lnbmFsaW5nIHRvb2sgYSBmdWxsDQpzZWNvbmQu
IEEgbG90IGNhbiBoYXBwZW4gaW4gdGhhdCB0aW1lLCBzbyBpZiBzaWduYWwgZmlyc3QsIHRoZW4N
CmNoZWNrIGFmdGVyLCB3ZSBjYW4gYXZvaWQgdGhlIElQSXMgYW5kIHRyaXBzIGluIG4gb3V0IG9m
DQpzY2hlZHVsZXINCg0KPiANCj4gDQo+PiAtLSANCj4+IDIuNDMuMA0KPiANCg0K


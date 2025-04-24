Return-Path: <kvm+bounces-44141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AA1DA9B01D
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C5701B83640
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7973119924E;
	Thu, 24 Apr 2025 14:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ShsPrFNF";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mCDA5uKY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766C42F30;
	Thu, 24 Apr 2025 14:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745503570; cv=fail; b=pAlMW3wDqRO6LfDxp96pM/hqNMH6olj2/Q5Dl2ZtkeKBEYwcupcSx2wDUWeTU6LNNNGgDXZxYNEEcqlm9YVVKqw8v9zpq5R/yuc9ppO9r/iKpga26COMzrYonk82AAeTwLJxOIW3s4Bmp8TcqOmmRCX3t7Iits+bk+8rPQiA/5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745503570; c=relaxed/simple;
	bh=0lHviCa7KPjvc9Vi+pg2yjVsg/c4drLsiwdBmREktXY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iJQgQOwn/+frzH0UFvdddSe0iUPAG+X/N9S/9R/EeJPyCDBMSjeqDtZqfo5pkRjRif4F41gZCjZdRF6D2oIH5hOS+w4VIdg/2Kixk9qgzISwvv5+m/L45dKlALw+A8GmaEvS44eXezzCSjWnOgmMrxF2eCOJIZcB6EtgKZ4MRhE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ShsPrFNF; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mCDA5uKY; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53O8G1Eg013735;
	Thu, 24 Apr 2025 06:53:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=0lHviCa7KPjvc9Vi+pg2yjVsg/c4drLsiwdBmREkt
	XY=; b=ShsPrFNFiopob+aQUX470A/r7rG/yYePzZMVNs0hTwn7BljgGOqjnMhfa
	KI9acKurIxaa5BNXRhvo/hSaA1ewFvn3fKVd2z5n/0MgAAz3zVV6ieluR2l/WDN+
	hNjoPU6uYUc9CjEIKeMZqb7N4W9olOkFSDyDljl4JxrnPuenwkCGjZyKys2E9EGH
	heziEAoNTlzNiinLr9McDfmpRrdrYyMFuieRuJDWODFlXASS4wa1I4ssOLwU3FmV
	RBryLbijuylEBV2fC1+K2G9T1/d8+RmT+OORKiQpqV5yOSumIzejeNyUs/LhY5k0
	tcuNsbtKc/gUIrtOa/OGrI4uwQlsw==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2041.outbound.protection.outlook.com [104.47.58.41])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 466jhvvsq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Apr 2025 06:53:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IW5WtVEpxd/MCsdTTt8owzseiWVdcS+Tqoi4jy2njTXDZZo0ZDAHQ9b/t2fcIQBfgsApyVi7Y1SlteMcFkmA+q00FMqL6mHcfzOVdPQloC5YFffcVRTYaLZ21f9eljVhCF3CH4xWcw99nDuZLOQOdzctyCRoDU9c2/3NG78CPabLcYSeqffZzG+0/mvawTa0Vgh88GSb3zhzpyxvnMO2OehUJrPK1vhEWyVrk2hmgpc4+bfV1jBmGEs/zH+Te7GcMMpM+m51Ln3193WZasxl5ydXpa8WrIIf7AHwTnCnXOqDrU+sVVps2Vrhw5YMnyepSp4dwzOf49XblL7UPrqxFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0lHviCa7KPjvc9Vi+pg2yjVsg/c4drLsiwdBmREktXY=;
 b=j+8UYOMNdN6fO7vH6aTVLoD3BXLjGuDfDo3O+zOFA/YS7DJeHw3jB2v/9JJkcVcUPzsRTbhRdD81y1SWb8174HASEPzUvec9O5eh21fxS9X5BG0Eoyp+9rYCTzwXC1QDqUxYVBmcbDAJfqYXli4dBpJ5fnd+hSghQWIEg5VU6/2mdZTwmRoyUNgoYvkPVq0AnwsAnWVv9r9mjnlPJN9p0r8ZdrWbLz2ZIariFg6nQ/b9u2NrhsQE1NZGlD4wLcQ9TUFRbXVRM0Qoqyc8DFv7D9+YuersQ0VcQ/s8r2sPHf6YkWnEqSBUh1AxlECzqaM53VD5V1D4lYeta8Be0iHaPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0lHviCa7KPjvc9Vi+pg2yjVsg/c4drLsiwdBmREktXY=;
 b=mCDA5uKYRvjDL59+nem/BCM0KRoU4euhTqwMdcfKCFyTlNRYwRp64pV3BP5gVKd6XY2RyqP3lsHE0e4lUCVThZODSU12lCk5shwav3127Fp+b0Fw0SPu8s9t8U2DHDsCbtWF7za5m1/1rFthspV6QIRdU1kUOvZH2Mlt913K3Pli+YBun6yOIrx32Bwnov7lTc+tx4y/6pDie1Z5GKpPYi7edb/Jq59oc+G4caKqb6xAOgXfD9ns0ONGoA365fpOnLm6UChyfo4UwuVyRWcriTPb+Zhifj9OWZMAxh3VqO1xQQMTkWC/M0fYHjiYWRfdIOb35zqnBMaHYTI4vew6EA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by MWHPR02MB10548.namprd02.prod.outlook.com
 (2603:10b6:303:281::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.9; Thu, 24 Apr
 2025 13:53:35 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8699.008; Thu, 24 Apr 2025
 13:53:34 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until
 after sendmsg
Thread-Topic: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until
 after sendmsg
Thread-Index: AQHbsYwmjuQam6Y/SEmtlBggg4gnP7OyupuAgAAGMoCAAByYAA==
Date: Thu, 24 Apr 2025 13:53:34 +0000
Message-ID: <1CE89B73-B236-464A-8781-13E083AFB924@nutanix.com>
References: <20250420010518.2842335-1-jon@nutanix.com>
 <a0894275-6b23-4cff-9e36-a635f776c403@redhat.com>
 <20250424080749-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250424080749-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|MWHPR02MB10548:EE_
x-ms-office365-filtering-correlation-id: 6ce0801c-b584-43b2-28fd-08dd83376813
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?L3dvMm9nWnNBWFRReTJyUzEzLzUvdlhFWlErYXZGM012clp3NWNMVGxJTzY2?=
 =?utf-8?B?YTVZMWdOYitIV3FzaUI4cTg1T25xZUpxUUVEQ3pTRUMxUTEzNGduRGRQUW1v?=
 =?utf-8?B?TGZsTklsYzFibVlKS0UvMUtmWW16NW51YkRUbjRjWENMR25NTFo3eHFiR1U4?=
 =?utf-8?B?VjVwaFRHYXc3OWtaeVRlZ2pVTWNhM1cvRVowRllWOVdaN3NTOGN5S3VuSnYy?=
 =?utf-8?B?K0c4eGxTOTMzR2NLVTVlaXczTXRUWTFMWnUvNkJkaHJWRlNOVXU1eGIwVUpC?=
 =?utf-8?B?dXZVUlFkbGFiVHNRZVNxUEMrKzl2QXYzaTFaWjZ4VXlUMEE4Q2tFM3FyUmQw?=
 =?utf-8?B?ZGFZemMzR2NObERaMVovQ1BVL29SclNMbzYxWFRyWkxHZU45RS9TN3plejVl?=
 =?utf-8?B?ZHhMcXM1QmZDWXZHU1pFWjY4Y256SDFCTkhpbFdldkJFTXJ4ZlJvcHhRL3FB?=
 =?utf-8?B?Y0YveEE1K1Q5TUJUa3FkSEJGWXBKVzR6ZWJhb3JpNlF6N0M4ZCtFV251TzBo?=
 =?utf-8?B?cmdIOWd4MlR6YVdrYlpPMzNTdlJZdzJvQlhmRk9IVmhIQXJlVlJLbnlLS3E4?=
 =?utf-8?B?VDRNY1FWWEcvWHQvNFdwVmx6QmZTNmJzNDAvVVk2ckNEZ2o3Mk9neGN0UkJC?=
 =?utf-8?B?NkR3MWhhSHQxdHF4Qjc3eTk4UU5mS0hjUmg4Ynp0cnhrZDFvYldSNndjTS9L?=
 =?utf-8?B?eTFPSHFmamtUU20wejBrRHQ3Q1l0d3lDT2hFY1ZQLzJLR0t3cE5oYkcwTGhS?=
 =?utf-8?B?T0RaVTdyRXM3Rnp3NEYxWVdaM09BaUpteXlSZk0xUkZ3S2laekVZeGc5ditw?=
 =?utf-8?B?bytFaVQyWVhtWW5vSmVHZ0ZxMXZaR2pDb1d2QW5wN09Zbzk5d1B0YWtCZDMx?=
 =?utf-8?B?Zmpabzl5cjRIaG1mRzdHY3hualp1cHN1NDF1WE5PMGZVSURMUm4zL0tLUkRo?=
 =?utf-8?B?NjNHZ0c3TUtJM3RNMEI3YkxwRU0wcjZqeHV1OTlZRmJXaDB6cml3QmdDeWEr?=
 =?utf-8?B?bWs0TGNTYkJaUnFxdEI5b0dvRGNuaG5CSWNJZ2xxVlNNMWdDVVZ0NmM3T3h4?=
 =?utf-8?B?TFFJa3IrNWgwOG1takVuQjBHWGpnQnlwTnpUU0MzM2hKejFnSXNJMEtZOHNC?=
 =?utf-8?B?SjhQdVQwTGs3Q1hvT2EvYit3dDBrQnBUYzk5eVBMekdSY1NSc1oyZk91bjc1?=
 =?utf-8?B?OGQxbUxLY1Q0YnQ4bWU3T2dVZkJQbmN3STRkVGI1NUJtcDdPVXVQY3JHNVYv?=
 =?utf-8?B?LzY2OFVUUEJDUFpmeVVSRjhPdzljam1SWm5QTHB2VVgzZG84WFkzT3AzRTZN?=
 =?utf-8?B?OGw3U0pkYlh2eklYWE1mMUthT2l0L2hJMkxOR1JnZjZ3cXA3a0dCbStQVnVH?=
 =?utf-8?B?a1ZScXFoQ1J5Zy9ESzQydTVSSXlFUkRJUGlDdFdRU091MmxoT3psaXJad1NG?=
 =?utf-8?B?cDBiZUo2VGlTZnNRVHJ1czZLbnFmV2c3LzU1Z3ZpdVlaQ1Via09Zd0kxK1BK?=
 =?utf-8?B?N3BEL2hJL1BFcWk3a1Q0VHhLMUhWSFNoVVRrZlByNHBqa1ROZHNYakFPVnhB?=
 =?utf-8?B?Z3YwYXRzV2tEM1dhblIvSHd0bG5nWTdETGZBQXZJaS9mdk9FNW01MmdvMHJ2?=
 =?utf-8?B?UHZaOUdERitmU0Fwam55YVlZd3REcUxNTjBTdDZxM0FKakZlY2JOdVRJVDFG?=
 =?utf-8?B?Wk0ycU1kOUNselVRclZzN1Y3elpHQUkyZG50WFZIQ3hXSWpYMEROM080VFVv?=
 =?utf-8?B?dVZZWXNxMG1ZUy9ZSXp1WmJPY1pkZ3V4elQ0eWYxKzNrWG0wbjV4N1l1Vmpi?=
 =?utf-8?B?WUV2dG9CRW1nQ2ZMcTZ2dDQ1MFVzbHE1V3NqNzJJMzZRMTU4cTFyRjRmVkk3?=
 =?utf-8?B?ME1rQkJqS2V6MDRnalBvV2EvczF1MFA3a3J0NjRyS1V3VExDWFdla2lVU3Aw?=
 =?utf-8?B?VW8zK3F6NnNVaTN6MklEbHQ4N1pST2tOcVVLWk52cXh5OTVKdW9EbGhtajNG?=
 =?utf-8?B?WTdtUmwxdUlBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TUpKdmw3ZEJJUXdYSHdJS212QzNyNkRVRzBYRUJVbWV5Zk52aDRUQ1pIMEdX?=
 =?utf-8?B?S3gxVUxxZzJua3BVTk0rRmJrejB3S0d5djFsd1pvNkZnbUZnT1VnZXk2K0lx?=
 =?utf-8?B?WFpaMG1pSGxGTVBiR1lpK3NpdzRkTnNsOGh3dk9zc2ppeUI0R1FsVkp0Y2Ny?=
 =?utf-8?B?RVFsV1QxTGpFK3J3UlVyR3UwVklLR0pWdGF3ZEpOUnFWdGNXR3FyVWQ1bE5V?=
 =?utf-8?B?WEpFOVVQNjRNcWtKQzRzb2hseUR0eHQwMkVVaWlLUngybmtBU2pQdWhnaVVz?=
 =?utf-8?B?aDJ1Mk5jSGRubWJLVXplcWFhRm5SVGJwUXlUaWswZ3R4VkRGclA2STZFcTVB?=
 =?utf-8?B?OW5vWFMwdGpqaUdSZllUSTVEN3dkL3crMWxYM2VQYXAzVUZSZFlMeExtbVc5?=
 =?utf-8?B?SzRxWk92djFNaERONVcwNjh2aWdmZGRXVlZFaWE2SWlwSHIvRWFUcUl3ZjV4?=
 =?utf-8?B?YXI2Y25oWkhqRmJsS2FuUDZNMWRBcmxhN05ibWYwWUREclcwYldVZXJpSHpI?=
 =?utf-8?B?bFZoRzRzKzBNajFWS2ExYlozeGkxV3EwK0JoaEM1ZVVBTzBCRzZxT21uMkRS?=
 =?utf-8?B?OUZYWk1nS1M5WEpzMytuRmI3OVNTTnFCcWdJa2JTeXhVRERSQ0xzOWkwVXI5?=
 =?utf-8?B?MU5iYlpDbUZQbVBFNFFtZ2VEMFhTVXJJS3pZTHlQR091ZkdadFNibnRkTnBW?=
 =?utf-8?B?ODFPb1hUbVZsTnZTTHJUcUpySC90WjVLcGNZWkdDdW05MzgyeVk0Wk9BdEh3?=
 =?utf-8?B?WS9zOGd0enRYQ1o1UzZVdkxMM1ZSa0FwY0VYamZWMzFoeHdJMDU2eXRuYkow?=
 =?utf-8?B?WDdYT3B2ZDJWVmNrMnp4eWNXa0ZpQ1lGNVJTcDgzakw2RkNncnQ2S25hT2tX?=
 =?utf-8?B?Y2R3K2NhQmRWdUY2YXg5OTNKdTBVZkZ0bUd1bDZKeWRJOFd4cVM5ZkdPUjcx?=
 =?utf-8?B?M0J3aitoUnhrS0FYUS9IY01VY2dnazlCV2VPOVowUkg2bmthb0RHVlh6bzN4?=
 =?utf-8?B?MXdhV1FaNHpZM3orOVBBck5sd1dRZWxKd0VHVXZzSFlPTWs2RkJ2cWJqMVdz?=
 =?utf-8?B?VFJLZFBQL3lWTkNsNjlCNGg0bTEyMjVWOTZXemVRUEEvRlQ1Qi9seGxabTR5?=
 =?utf-8?B?eU02bjNYazRVa0hVRVk4MURUWE1jbEJpNktvaTA3bUZPV0JUVWVYcGk2Ukho?=
 =?utf-8?B?ZUJDNlJ2akRrWkVxVHpMQmpiSGV6NU1Tb0UyeDJ5Q1FLQ3FGeEpIN0FMaXVK?=
 =?utf-8?B?ajlVQURFNFNKNUZjdDg2UGNablZxdEZRejczUC8rc2hXTktFMUtrTmwwTlVy?=
 =?utf-8?B?NGpqL3ZBY1JMVkVNMktqS0VOMm84dGNuREFub29KZGM0dnYvVHlBVjUxRzk1?=
 =?utf-8?B?YlU3TytxRVJjL0dacFVZWjI1M0xWVklMSGFBc0dSVnQ1S1JQRHFSOWtJbjJ3?=
 =?utf-8?B?dDFWaW1CU2prZ1AvMkg0REJDSVNIcGRRaHNpK2E1cktDRkt4L3hNRm5QYWVK?=
 =?utf-8?B?MWxidWQ3YWpxT3pYQTB5cFBLcWcvUGZ6UnBBa3RhZ0x6TWMzdlcrUjlOVXhX?=
 =?utf-8?B?NEdObDRPa0xNc2lHcHZ1L2FBS1hjWnFQOXgxRFJUd0pqZ2Mxa1l6aXpLMkta?=
 =?utf-8?B?SE9Lanl2M2w0di9TaUVuTEphQ01Wb293Mnk1Wm1RbHl0VXNraUxQNk56N0Nq?=
 =?utf-8?B?bTN4UjRrS2lHTnNvbEJWUHBoM0IyRytPT2FkZjJISkRZZ1NkbFRDTTVUMEQ1?=
 =?utf-8?B?M2g3RVRUeDQyNEpqS05xbktLRGhqOTBtUFZGZVpZMHZoRU05alQyazRJWE4x?=
 =?utf-8?B?cWRlbmFWcDhCZHdnSTNEdy9HTkFLVnUxTVU3M1RCWFZmZUpVTHRYaFhKREZk?=
 =?utf-8?B?aVF4ZWYwZUJUKzFRcXBoeGdiT2xlbnFCNlJub1hrREFPYUNaQU9JL2NSL3VQ?=
 =?utf-8?B?TlJmU2RzaVlQT1hBWGpDUnllcEhMTm1RbVcybEh4bzI3d0tLc2ZxTFN2d3hj?=
 =?utf-8?B?TUNid3VkUVh1MzFOM1I0N0Z0Y2F1VEFMQTYwaHpxbGdYVlFheDRXa0QwcGdj?=
 =?utf-8?B?T1ViUHJpOFU5akVQdit3K0ZiaDBEampsc2ZEaW5zSnpmMUlGT3R2SEZaYkpw?=
 =?utf-8?B?aGR2YkdLa09VNVVhZk1JWTBOL21obHhmdFd0bEVNcXQ3Ly9QOWN5MlJBMnFS?=
 =?utf-8?B?RGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE27908FACFEA146BD95D74FB972C4B4@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ce0801c-b584-43b2-28fd-08dd83376813
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2025 13:53:34.8354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4dsPLYTGqpmyVqUgyEF0oWWyCBUEanM0okJfF8V9i2NPY7FC5qUl6Ij98ZbvAxtzJXUexR6QMTnqzAC6tbzzNWy8O2P1ETtZwOTHv/kkTOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB10548
X-Proofpoint-GUID: 4076buQdNPjA_wnoGFS5RHkJSyNrvcmy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI0MDA5NCBTYWx0ZWRfXzf1Xa8z6otnl 76ZrcHseAgKLmXKm2cChj+0nQv2L9uuFYHY1WIpoWubBoSRgidO0PLItVG2/Px+vBCAKKik5JLI SCEANfRDlmnvY8okCD7UnIrqtJXcItttPl6fG2msrMYoIE3Is2xtDnDCFNfN5gO8FpdDMC45eBO
 Rm6EVxnzPlX++odknXWNiwzKciWd6HN62iN6Gfuk0BSPyKjyouZNRBKhq6BX96fXnLxZoMknnqA j2HmqCJxLCy0p3uug6bmXh8K6pI6PjaFn5F+sjbfrx6qwAtbJrc9TDmhjVmrn5ScWX9l+s2VYJI RDixtADeru8L+CQS+x5A4gz6gk6HJRcyO3RchcNdN/c3VLE5/ApZccCmZdlBSvmF70zEc3ZyyXr
 qjq+fbMWl25ZVYL+2g5sIYXRCS8Q1hfxK/ifN8DBmM3Wqrq1PYx11pNJ6S/s9ogCLCUkbq7m
X-Authority-Analysis: v=2.4 cv=PNMP+eqC c=1 sm=1 tr=0 ts=680a4263 cx=c_pps a=OnljjeCONrlUuPUItWmgXA==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=XR8D0OoHHMoA:10 a=0kUYKlekyDsA:10 a=20KFwNOVAAAA:8 a=errH5zuwLQWypmTLywcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 4076buQdNPjA_wnoGFS5RHkJSyNrvcmy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-24_06,2025-04-24_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gQXByIDI0LCAyMDI1LCBhdCA4OjEx4oCvQU0sIE1pY2hhZWwgUy4gVHNpcmtpbiA8
bXN0QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9OOiBF
eHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBUaHUsIEFwciAyNCwg
MjAyNSBhdCAwMTo0ODo1M1BNICswMjAwLCBQYW9sbyBBYmVuaSB3cm90ZToNCj4+IE9uIDQvMjAv
MjUgMzowNSBBTSwgSm9uIEtvaGxlciB3cm90ZToNCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92
aG9zdC9uZXQuYyBiL2RyaXZlcnMvdmhvc3QvbmV0LmMNCj4+PiBpbmRleCBiOWI5ZTlkNDA5NTEu
LjliMDQwMjVlZWE2NiAxMDA2NDQNCj4+PiAtLS0gYS9kcml2ZXJzL3Zob3N0L25ldC5jDQo+Pj4g
KysrIGIvZHJpdmVycy92aG9zdC9uZXQuYw0KPj4+IEBAIC03NjksMTMgKzc2OSwxNyBAQCBzdGF0
aWMgdm9pZCBoYW5kbGVfdHhfY29weShzdHJ1Y3Qgdmhvc3RfbmV0ICpuZXQsIHN0cnVjdCBzb2Nr
ZXQgKnNvY2spDQo+Pj4gYnJlYWs7DQo+Pj4gLyogTm90aGluZyBuZXc/ICBXYWl0IGZvciBldmVu
dGZkIHRvIHRlbGwgdXMgdGhleSByZWZpbGxlZC4gKi8NCj4+PiBpZiAoaGVhZCA9PSB2cS0+bnVt
KSB7DQo+Pj4gKyAvKiBJZiBpbnRlcnJ1cHRlZCB3aGlsZSBkb2luZyBidXN5IHBvbGxpbmcsIHJl
cXVldWUNCj4+PiArICogdGhlIGhhbmRsZXIgdG8gYmUgZmFpciBoYW5kbGVfcnggYXMgd2VsbCBh
cyBvdGhlcg0KPj4+ICsgKiB0YXNrcyB3YWl0aW5nIG9uIGNwdQ0KPj4+ICsgKi8NCj4+PiBpZiAo
dW5saWtlbHkoYnVzeWxvb3BfaW50cikpIHsNCj4+PiB2aG9zdF9wb2xsX3F1ZXVlKCZ2cS0+cG9s
bCk7DQo+Pj4gLSB9IGVsc2UgaWYgKHVubGlrZWx5KHZob3N0X2VuYWJsZV9ub3RpZnkoJm5ldC0+
ZGV2LA0KPj4+IC0gdnEpKSkgew0KPj4+IC0gdmhvc3RfZGlzYWJsZV9ub3RpZnkoJm5ldC0+ZGV2
LCB2cSk7DQo+Pj4gLSBjb250aW51ZTsNCj4+PiB9DQo+Pj4gKyAvKiBLaWNrcyBhcmUgZGlzYWJs
ZWQgYXQgdGhpcyBwb2ludCwgYnJlYWsgbG9vcCBhbmQNCj4+PiArICogcHJvY2VzcyBhbnkgcmVt
YWluaW5nIGJhdGNoZWQgcGFja2V0cy4gUXVldWUgd2lsbA0KPj4+ICsgKiBiZSByZS1lbmFibGVk
IGFmdGVyd2FyZHMuDQo+Pj4gKyAqLw0KPj4+IGJyZWFrOw0KPj4+IH0NCj4+IA0KPj4gSXQncyBu
b3QgY2xlYXIgdG8gbWUgd2h5IHRoZSB6ZXJvY29weSBwYXRoIGRvZXMgbm90IG5lZWQgYSBzaW1p
bGFyIGNoYW5nZS4NCj4gDQo+IEl0IGNhbiBoYXZlIG9uZSwgaXQncyBqdXN0IHRoYXQgSm9uIGhh
cyBhIHNlcGFyYXRlIHBhdGNoIHRvIGRyb3ANCj4gaXQgY29tcGxldGVseS4gQSBjb21taXQgbG9n
IGNvbW1lbnQgbWVudGlvbmluZyB0aGlzIHdvdWxkIGJlIGEgZ29vZA0KPiBpZGVhLCB5ZXMuDQoN
ClllYSwgdGhlIHV0aWxpdHkgb2YgdGhlIFpDIHNpZGUgaXMgYSBoZWFkIHNjcmF0Y2hlciBmb3Ig
bWUsIEkgY2Fu4oCZdCBnZXQgaXQgdG8gd29yaw0Kd2VsbCB0byBzYXZlIG15IGxpZmUuIEnigJl2
ZSBnb3QgYSBzZXBhcmF0ZSB0aHJlYWQgSSBuZWVkIHRvIHJlc3BvbmQgdG8gRXVnZW5pbw0Kb24s
IHdpbGwgdHJ5IHRvIGNpcmNsZSBiYWNrIG9uIHRoYXQgbmV4dCB3ZWVrLg0KDQpUaGUgcmVhc29u
IHRoaXMgb25lIHdvcmtzIHNvIHdlbGwgaXMgdGhhdCB0aGUgbGFzdCBiYXRjaCBpbiB0aGUgY29w
eSBwYXRoIGNhbg0KdGFrZSBhIG5vbi10cml2aWFsIGFtb3VudCBvZiB0aW1lLCBzbyBpdCBvcGVu
cyB1cCB0aGUgZ3Vlc3QgdG8gYSByZWFsIHNhdyB0b290aA0KcGF0dGVybi4gR2V0dGluZyByaWQg
b2YgdGhhdCwgYW5kIGFsbCB0aGF0IGNvbWVzIHdpdGggaXQgKGV4aXRzLCBzdGFsbHMsIGV0Yyks
IGp1c3QNCnBheXMgb2ZmLg0KDQo+IA0KPj4+IEBAIC04MjUsNyArODI5LDE0IEBAIHN0YXRpYyB2
b2lkIGhhbmRsZV90eF9jb3B5KHN0cnVjdCB2aG9zdF9uZXQgKm5ldCwgc3RydWN0IHNvY2tldCAq
c29jaykNCj4+PiArK252cS0+ZG9uZV9pZHg7DQo+Pj4gfSB3aGlsZSAobGlrZWx5KCF2aG9zdF9l
eGNlZWRzX3dlaWdodCh2cSwgKytzZW50X3BrdHMsIHRvdGFsX2xlbikpKTsNCj4+PiANCj4+PiAr
IC8qIEtpY2tzIGFyZSBzdGlsbCBkaXNhYmxlZCwgZGlzcGF0Y2ggYW55IHJlbWFpbmluZyBiYXRj
aGVkIG1zZ3MuICovDQo+Pj4gdmhvc3RfdHhfYmF0Y2gobmV0LCBudnEsIHNvY2ssICZtc2cpOw0K
Pj4+ICsNCj4+PiArIC8qIEFsbCBvZiBvdXIgd29yayBoYXMgYmVlbiBjb21wbGV0ZWQ7IGhvd2V2
ZXIsIGJlZm9yZSBsZWF2aW5nIHRoZQ0KPj4+ICsgKiBUWCBoYW5kbGVyLCBkbyBvbmUgbGFzdCBj
aGVjayBmb3Igd29yaywgYW5kIHJlcXVldWUgaGFuZGxlciBpZg0KPj4+ICsgKiBuZWNlc3Nhcnku
IElmIHRoZXJlIGlzIG5vIHdvcmssIHF1ZXVlIHdpbGwgYmUgcmVlbmFibGVkLg0KPj4+ICsgKi8N
Cj4+PiArIHZob3N0X25ldF9idXN5X3BvbGxfdHJ5X3F1ZXVlKG5ldCwgdnEpOw0KPj4gDQo+PiBU
aGlzIHdpbGwgY2FsbCB2aG9zdF9wb2xsX3F1ZXVlKCkgcmVnYXJkbGVzcyBvZiB0aGUgJ2J1c3ls
b29wX2ludHInIGZsYWcNCj4+IHZhbHVlLCB3aGlsZSBBRkFJQ1MgcHJpb3IgdG8gdGhpcyBwYXRj
aCB2aG9zdF9wb2xsX3F1ZXVlKCkgaXMgb25seQ0KPj4gcGVyZm9ybWVkIHdpdGggYnVzeWxvb3Bf
aW50ciA9PSB0cnVlLiBXaHkgZG9uJ3Qgd2UgbmVlZCB0byB0YWtlIGNhcmUgb2YNCj4+IHN1Y2gg
ZmxhZyBoZXJlPw0KPiANCj4gSG1tIEkgYWdyZWUgdGhpcyBpcyB3b3J0aCB0cnlpbmcsIGEgZnJl
ZSBpZiBwb3NzaWJseSBzbWFsbCBwZXJmb3JtYW5jZQ0KPiBnYWluLCB3aHkgbm90LiBKb24gd2Fu
dCB0byB0cnk/DQoNCkkgbWVudGlvbmVkIGluIHRoZSBjb21taXQgbXNnIHRoYXQgdGhlIHJlYXNv
biB3ZeKAmXJlIGRvaW5nIHRoaXMgaXMgdG8gYmUNCmZhaXIgdG8gaGFuZGxlX3J4LiBJZiBteSBy
ZWFkIG9mIHZob3N0X25ldF9idXN5X3BvbGxfdHJ5X3F1ZXVlIGlzIGNvcnJlY3QsDQp3ZSB3b3Vs
ZCBvbmx5IGNhbGwgdmhvc3RfcG9sbF9xdWV1ZSBpZmY6DQoxLiBUaGUgVFggcmluZyBpcyBub3Qg
ZW1wdHksIGluIHdoaWNoIGNhc2Ugd2Ugd2FudCB0byBydW4gaGFuZGxlX3R4IGFnYWluDQoyLiBX
aGVuIHdlIGdvIHRvIHJlZW5hYmxlIGtpY2tzLCBpdCByZXR1cm5zIG5vbi16ZXJvLCB3aGljaCBt
ZWFucyB3ZQ0Kc2hvdWxkIHJ1biBoYW5kbGVfdHggYWdhaW4gYW55aG93DQoNCkluIHRoZSByaW5n
IGlzIHRydWx5IGVtcHR5LCBhbmQgd2UgY2FuIHJlLWVuYWJsZSBraWNrcyB3aXRoIG5vIGRyYW1h
LCB3ZQ0Kd291bGQgbm90IHJ1biB2aG9zdF9wb2xsX3F1ZXVlLg0KDQpUaGF0IHNhaWQsIEkgdGhp
bmsgd2hhdCB5b3XigJlyZSBzYXlpbmcgaGVyZSBpcywgd2Ugc2hvdWxkIGNoZWNrIHRoZSBidXN5
DQpmbGFnIGFuZCAqbm90KiB0cnkgdmhvc3RfbmV0X2J1c3lfcG9sbF90cnlfcXVldWUsIHJpZ2h0
PyBJZiBzbywgZ3JlYXQsIEkgZGlkDQp0aGF0IGluIGFuIGludGVybmFsIHZlcnNpb24gb2YgdGhp
cyBwYXRjaDsgaG93ZXZlciwgaXQgYWRkcyBhbm90aGVyIGNvbmRpdGlvbmFsDQp3aGljaCBmb3Ig
dGhlIHZhc3QgbWFqb3JpdHkgb2YgdXNlcnMgaXMgbm90IGdvaW5nIHRvIGFkZCBhbnkgdmFsdWUg
KEkgdGhpbmspDQoNCkhhcHB5IHRvIGRpZyBkZWVwZXIsIGVpdGhlciBvbiB0aGlzIGNoYW5nZSBz
ZXJpZXMsIG9yIGEgZm9sbG93IHVwPw0KDQo+IA0KPiANCj4+IEBNaWNoYWVsOiBJIGFzc3VtZSB5
b3UgcHJlZmVyIHRoYXQgdGhpcyBwYXRjaCB3aWxsIGdvIHRocm91Z2ggdGhlDQo+PiBuZXQtbmV4
dCB0cmVlLCByaWdodD8NCj4+IA0KPj4gVGhhbmtzLA0KPj4gDQo+PiBQYW9sbw0KPiANCj4gSSBk
b24ndCBtaW5kIGFuZCB0aGlzIHNlZW1zIHRvIGJlIHdoYXQgSm9uIHdhbnRzLg0KPiBJIGNvdWxk
IHF1ZXVlIGl0IHRvbywgYnV0IGV4dHJhIHJldmlldyAgaXQgZ2V0cyBpbiB0aGUgbmV0IHRyZWUg
aXMgZ29vZC4NCg0KTXkgYXBvbG9naWVzLCBJIHRob3VnaHQgYWxsIG5vbi1idWcgZml4ZXMgaGFk
IHRvIGdvIHRocnUgbmV0LW5leHQsDQp3aGljaCBpcyB3aHkgSSBzZW50IHRoZSB2MiB0byBuZXQt
bmV4dDsgaG93ZXZlciBpZiB5b3Ugd2FudCB0byBxdWV1ZQ0KcmlnaHQgYXdheSwgSeKAmW0gZ29v
ZCB3aXRoIGVpdGhlci4gSXRzIGEgZmFpcmx5IHdlbGwgY29udGFpbmVkIHBhdGNoIHdpdGgNCmEg
aHVnZSB1cHNpZGUgOikgDQoNCj4gDQo+IC0tIA0KPiBNU1QNCj4gDQoNCg==


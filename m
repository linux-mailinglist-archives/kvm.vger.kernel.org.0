Return-Path: <kvm+bounces-35293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D05A0BB21
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 16:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F13D516674C
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 15:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4EC420AF8E;
	Mon, 13 Jan 2025 14:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="e/CZNVcp";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="vYZ0STQA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D394D20AF8A
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 14:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736780392; cv=fail; b=TppmrMak568mzEhAGU0SJcRmFPh1MRRbyiFMHXjyMNF1oi9woE/OFbMbzEiBprjBBlX749wpGpyeZoTCWXyMe2wvVosgm2OM3n9iBdLP6bBLbw8kCGtoK4dtrXQ5o/s87GcLuyD4v34piUCqu+Q1DV7y26X1UCgbnNWKJiYTsrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736780392; c=relaxed/simple;
	bh=UF41EaO9j9KRaLmOxd+0aHXQley08fYv5rKERHwlUdk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U/M8ib9fPLu42UkmjZrqKFYgLKH3CVOeY+AzayJcqM40X1sLdb/lx9PI/+wtzAb+0fk4pOWcbuYj60rQcN4MAjaSDOZ7JBcwRnhxes43Yuk7J+KNTpA3cPza9Rc6gl1VpPQf85b+VF8dEV9I0im7PhFOm7aIp9O2cK8+hUPrnvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=e/CZNVcp; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=vYZ0STQA; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50DDDEO5024717;
	Mon, 13 Jan 2025 06:49:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=UF41EaO9j9KRaLmOxd+0aHXQley08fYv5rKERHwlU
	dk=; b=e/CZNVcpA0OfGfnLcTaUnIPNBabvFmxwP5+Py8ukcwHGRRctiRvObYJz7
	eU/mxS5NraIQGpOsf1zObMTwhwLkYeiamkF6HDuUYaP7w9HjTyaaCtLqy7I4ksIX
	bigMhebsjmfu/y4s9lFbRukRBnMLynFLOMQC31IuzM/5Evfz8SERCOBiLLDf0B71
	JFTyMgiaYV/bu9pVEt3vIKZH+GoWwV9mAS+6J7O3pJChJneWcdDCOnT6e4wRpwh5
	iQq09l2rxqfHqhIQbk58KQjw82PVOTwqduHXmQWEeNvXREivHahWK5NlwPdzK53+
	92y5FiCtSSuH4yUMdE+ikT47g2z2w==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazlp17012038.outbound.protection.outlook.com [40.93.6.38])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 443rkkbkxa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 06:49:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NiivRen23Y+FffidWvcrYhDNPp9dunrePLqBWOsPtnK4eFUgXWh+HWxCtQd0CsV1O3YPXcyD6QoiZS9e60B0BS7QUDuokmyKNlr/+LCP0pr0fetTnkyPzGKAWNkzOuIYqJDHb4+WY2ZQzNJbtdUWcCJ1SS8i5vfgr+FzqZcFOwSWThdSAmtaOqJ2uNQG+KPCuJGCr7RqtvGlNegBQWi5c4HHQklWO2Hy2kmyDI4igZGilZMLbDOrrE9LYgPkUvfcyhfL41bDc6qQd/yZMxTLf6jn/i9F7YuERiYYjnfIZvQS7F+jCuuQHl5JbullkBCDKnlPWqLu5MZ1zKiqoR4Uuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UF41EaO9j9KRaLmOxd+0aHXQley08fYv5rKERHwlUdk=;
 b=JG7kAGXO+Pfu6F47TDTVfsMJ2j1zDeBSmSqe/R22VZ/COMF7qBkZLFcKA7E7P5tqjPWie8X4RTfl8rG+GofCGleKY5PTok4y8yTgID63+rMUSX+gQoj46IE6AiWncVC5pJHpund852fLdW1gVHq/JBaQWxedHNn3dSUo0VOn3eqZAllZfH9YydFjZ3k94r5l0ZvfFbXSxTwD5UgPgQGFFmzemdhkjXjMMRfjlWK2J3a70edz7X9g9Lwhl2DHEOtbctAqqsWVjuu/tLPaIKqKFvDaHNH9fhu6Xq5tA5qBEhyg5MzrlJbXZJIkS6pQlaDhAphlCzSvBP3VlB9NkSxXxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UF41EaO9j9KRaLmOxd+0aHXQley08fYv5rKERHwlUdk=;
 b=vYZ0STQA+LnyJCnOWxVe7Qah1gNAhVx9iKzH9YPnLzUTtMqJ2tuFh9ElM5LGH+aDfonQexJt+3z0cC/ctDLtyS0+h9M6EY72Fi7qvRhZwKZETyJuPjJXCoKZmBmiq2j3hFuxZIgrLPsoj/cb9UggxYXTyy1CZAEOY8XL+8t/dvexcLs5rYulviUv1y37tOQ3+WaeQvorrC7epsF1dEXOl1IlUh8PlrsXRdfh+CwU70KJ07jeLRGzt6oQDlhTCaYxrs0crUTC02cnq4fkGVmSENHSJDzTbwZEg721UvW3oJJE3l86h5meMdAxzeg/oCNTTlVnVDQk0lLUWBOgatXCOQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ2PR02MB10147.namprd02.prod.outlook.com
 (2603:10b6:a03:55d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Mon, 13 Jan
 2025 14:49:11 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8335.017; Mon, 13 Jan 2025
 14:49:11 +0000
From: Jon Kohler <jon@nutanix.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
CC: Andrew Jones <andrew.jones@linux.dev>, Thomas Huth <thuth@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nina
 Schoetterl-Glausch <nsg@linux.ibm.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] Makefile: add portable mode
Thread-Topic: [kvm-unit-tests PATCH] Makefile: add portable mode
Thread-Index: AQHbX5f8EXkP7wAqgkWvoAteylAdmrMUuR+AgAAcQAA=
Date: Mon, 13 Jan 2025 14:49:11 +0000
Message-ID: <806860A3-4538-4BC3-B6B9-FA5118990D78@nutanix.com>
References: <20250105175723.2887586-1-jon@nutanix.com>
 <Z4UQKTLWpVs5RNbA@arm.com>
In-Reply-To: <Z4UQKTLWpVs5RNbA@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|SJ2PR02MB10147:EE_
x-ms-office365-filtering-correlation-id: 019498a3-b9da-48df-18db-08dd33e17105
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?OXpmVW11YlVtN2FLQlN0eDFjeEhvWUxteTFCcFIrWmE2SlhwT1A0MUJtWTVo?=
 =?utf-8?B?RkJmV05qWlhqTjMrL0F1S2NMbEFjTzlsc3VpcWFaZGUydml5Yk1QTUpEOVpt?=
 =?utf-8?B?bnluNjRNVHZQdkVZOW1wUUg5UDJxV3FqblN1aXJBOXRmVnY5bEcrRXRhM2Vn?=
 =?utf-8?B?TC9PZHQzbnZvUlZOZTdMNDNDVnJIZmp3NFNsQW8rUk5id215ZFZSbHNPeGVY?=
 =?utf-8?B?MjVIWmppYnd2NzZKS2FkemdJb2tkVUZVd0tjcE9wa0w1MXNhQkdOeEZGNGNC?=
 =?utf-8?B?UUpycEE5dGJPVmVNWS9zTXhtWTJOeG9oUkVURXgxeUZvZndRSzlFai9IWk56?=
 =?utf-8?B?WjVYYytqK3FXNGdsVFc2ZFMzV0tJWWZ4MXpOdUg1WXpBOHhXT1lOTmxXTGhZ?=
 =?utf-8?B?c253dDVkUUFmQmlPQXJWZ1VvS2lvdU1iS3BFRmo2Y2xiYm01REZTQzA4dXZX?=
 =?utf-8?B?VEJYczgwMjZ5bldIcnZnNEJISWk0VjFzcStkcVBGUmtaOFo4RDdDVUFpYU1P?=
 =?utf-8?B?ZHRDYnh1UXZqZWJKQlN1ekZtOGFnZlVrczhQWUFlOXd5ZGU5NGhoVHZheWpq?=
 =?utf-8?B?VzMrRFZ0bkt6WTJyL1UwSlFLUXpPTnBoeDZOWUpaeWhJZHhvcHNzankwS1Ex?=
 =?utf-8?B?TzVBWmRxbEFKZnlnSml2bSs1VjBXYlNuRnZGVW5USzUyY29teGZ2dGtjWGJq?=
 =?utf-8?B?cEtpSitpeUp6dlFRbG1zUGlhLzBObU5TbDhVUzNVUDMvOGozSUZVL3Z3NlZy?=
 =?utf-8?B?N0NxWiszdGI0N0NkSEVLd0tOZzkvdy9qbmhld2dPVkRzQnZQVmM4TWtHMmZC?=
 =?utf-8?B?QUVKYlRZcElhcktWK0lYS1lZQ2ZlYVBlanJrVW85akpFT3kyajUrT0VPajZw?=
 =?utf-8?B?T3dlL3BFYks2Q0xSTU1tQTNrWUVzeXpoNVRUdlRIUThTMHRGcnQwWlhnUzFF?=
 =?utf-8?B?SUtqdDI5WmhEbFpRUUhDNXZoQmNEOXVONjBiditEUXpxNE9DdXRqbSt3RGlm?=
 =?utf-8?B?dlQ0Zys1VDV1emQwTENGTG9UMWxsYURsM3REUk0zV0xPZzNoWU9aUXZIcHNN?=
 =?utf-8?B?SC9lcERNdzVPc0V1REtvODVSZFdEb2VwbzIxa1JzVlVuQVgzMW5vOUNwTUdp?=
 =?utf-8?B?WFZUSUdBb3UrNThDK3VmdjFnaUl2NmdTZnRWYnBpNXV4aWM2bXdLNnVDQWVD?=
 =?utf-8?B?ZnRWd01TRnNJRTg5WGVTQ2Zza0lpaVY2YlZnaEZ4TTFOUFdEWmFhY0NGVU9T?=
 =?utf-8?B?TTJTUFViQmtmK3I1bEpLK3FTUkZZMWVsd0ozeFVQc3VFdXFVOUFmNkRMVHBU?=
 =?utf-8?B?Y3hYcGVlS3J1aitQUm1hM0lUZmR0d3VLdmovQTNLV2IyNHUzNDVHdFFkMGxk?=
 =?utf-8?B?ZHY1Z3NsSWE5YmdEYjFzYnJudE1jTkVkZk9DeCtrbEVrbzlxdGR2S0F5a1po?=
 =?utf-8?B?YVJkU1IxQVkwOFg5c3plRjI5K2RJNStQbE1nVnMvYTUrRllaN2czRjZ2SXVa?=
 =?utf-8?B?bXQ5Vmt1ZzdERWRwOUh2RVZ0QnRGdncwQlZza2tON1Njdi9MdE00Szg4SDk5?=
 =?utf-8?B?dGZDSlRsOTQrRGZmWUJlc3QrQU5kamdLVjA0K0tLMkxtNmR6OERjcTVFZ1h0?=
 =?utf-8?B?NHd6S0M3M0VncVlYSXhzZVJpZS8vdmNnZnJXd3pUbDBjdkdxbERBZ3FUSTdx?=
 =?utf-8?B?cjNmWVEvR2pNTHZlVU5YU01oWHpZWUZ0Yisyb0hJN2drUWVxUU9TM0tTZUZC?=
 =?utf-8?B?Z2FlTVVzUUYwb25vK2R4TzNLNXNGODgyRFNyQWRXeDFQRjhVU3k3emFQNFRQ?=
 =?utf-8?B?SFdTRm4xNlg2ZHhEWmZWNllqQk5Nc1JZcnN0K0tjZDF5QnNQQmM4cWFGaTlw?=
 =?utf-8?B?Qm9WQ0VoK0JRWHJKOVFuR3pyR2w0eER0TWlrb214b2hSa0MzckppbCs4T1ZW?=
 =?utf-8?Q?GDfW9Pv7L8vWRRG7gsothQOmskwQy1aP?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WFBWY3prYnR1cE9Eay9ZemZXZzRSd0dXbi8wMC91NDlaMkYyNVd5dFRtdFdj?=
 =?utf-8?B?REl6QnJsRDRyek5xaWZhWXlFNlpFUDBmOUV2Z05ZMlRZamFmRzlSZGc2aHNS?=
 =?utf-8?B?VG9VeWpYWTVhbXQwY0JJUHFnY05TQXRMYm1hL1BqWDYraDJFeGZtSTBMYmc0?=
 =?utf-8?B?eFM4THZWLzVxN0N2WnBhaEtyOERucCtydkF5eEhaa1IrN2tuRWJYM0kvTFJ3?=
 =?utf-8?B?OVdjeXRPd3VRSTE2alRpc0lMaXJTRlBGYll1V0RtZ2NZNjl4c3BIVkRKeWFX?=
 =?utf-8?B?eUF0SGo0bS9CbGRFbzFmVUdBdzYzNHdaUXVyclRVZENOTTBqMHRBY2s5Nlgv?=
 =?utf-8?B?bUhlaGVIQ1BIbE05ZXVCejlHd3FTK3FROVBnbkxlSEtid241M0tyRlVvcFZs?=
 =?utf-8?B?SmY2U2tGQmVuYzhFUVdsUHU1V0RsSmdlVmZyMks1djc5M2toUVdoZTBRdWZB?=
 =?utf-8?B?U1lpY0E5N3Z6c2pwQzQzNFNUcnNUd3hxa2k3bjJCK1p0Wk1UQjJVV3JGMVVR?=
 =?utf-8?B?djl1V3JrRm9rOXgwbnNxOEgrTWJ4Tlp6Qkt6dmJJVGhJWXpTTFd2U1pLUDBp?=
 =?utf-8?B?SEtwdldUaEFsSTNCc2U3VWxWRmc2TmZGNVZnM050SGcvblZHR3J0V3R6QnhY?=
 =?utf-8?B?K0dYbERNbUd4N2NMSEZYaktLYjZMOXJrSUQyWG40cWh0QkpyemNVbktHSlZW?=
 =?utf-8?B?ZFdVU0hXN1JLY2xvaG82VkFDN21hcGozU0hvY28yYVdUdmdCTk5Sb1pteGlG?=
 =?utf-8?B?ZUpNZlRmNlpKUE45eEcxd0ZUaWVXa1VzUUsvS2dWSEc5azJEVUtxZkVYbi9i?=
 =?utf-8?B?Yyt1TGVQY1ZkZTRPWnhxZkNkTlplWnZjbW92bGNsOU01bUxGR0Y5eEFRcjlp?=
 =?utf-8?B?ZTNOTW41K2NHTjg5ZmdMTzhNYVJZUjdGMS9Jb0lhNnJ4b2hyR25TZXFjd1hN?=
 =?utf-8?B?R3lMUSsydUlPWW56WGMwaTFYem0vYUtQeHNia2hHZko0SUpseUVadW0yVEZw?=
 =?utf-8?B?T3YyenNLVzhwTmJCRXpNZTBIeTZPRW5FVDBCSDVkY1NDNHI4NXprZHp4ZWRl?=
 =?utf-8?B?ajlpMTk1aXQ4cmFuUUNabFZsNkpnTUFIbi9qTEJxeFF1L0RWYkNnWGpXd25v?=
 =?utf-8?B?SDZuaktWOExkRHJuVnRpVmNINTFyMFpLWjIvS0djclhILzBtYys4enRvd2dO?=
 =?utf-8?B?YVFKN2p1QkxndGQwUTlLYnBRSHk5bUZRaEVlNHlwcFowaS9jT0VBbnVLaDlL?=
 =?utf-8?B?Y2lHdDJ3endyS1FEMENEY28rT0xSa3pqL000cG5UZ29zMmhwbE9iWUtGM2VS?=
 =?utf-8?B?MHR1U25Ec29xZnB6eHRIdHA0ZzNWRDFUOU9yOE1pOWNkazhMUlRLVEU3Kzhz?=
 =?utf-8?B?N081ZmxjTi9xaCtaVnI0Nmo2T1dndGFMb1RNelExcE0wMWVUWDc1RWdhTVdI?=
 =?utf-8?B?ckJKc0JKNnhLNGJhdTM4RFN1ZnJkcFVBeWJwbmJvcGlxWlBVeU5XSU41L3cr?=
 =?utf-8?B?SlczR0NnZ2grZ0ttQjl3M1JvMU9FOFVHWE1pK2VtSUtHU05iU3RYY1IrdWpr?=
 =?utf-8?B?WUJhdXFnMjF3Q01CbVpwOHMwUTlHc29vUFZSTjNKNEZ0enI4RWdCdXBXallk?=
 =?utf-8?B?WDVnY3k3VUVhRGdUQTBrZDVWMDIraTlSSWR0ZnhEVkpSRFJxa0U1d1JtdC9q?=
 =?utf-8?B?NXV6a0FIQ3VWS1hnY2c2MWRLeVp5d0t3eFl2ckFDR29PdmhmRkFPY0RaZEpp?=
 =?utf-8?B?bFVkb3l2MWV2dkIwdFJMejNOWHFEMHowSlFhTDVTK0x1Z1FwYzVpSGVJZEoz?=
 =?utf-8?B?UnZHczc2d1dGZE91ZW5lVVN1LytBNVRzOUkreit1SVZIeTJCZHk2a2haN0tW?=
 =?utf-8?B?ZWgyUnV0eVZYSHNQSVVqNlYyRDlsRzNxMkU3WkllSmp2elJkMkltWThtRE93?=
 =?utf-8?B?eHU3a3N1RzVkdWtONkdyMmRybzZha1JKZkxLeG0xYS85OGUrSVRXbXpDTXVz?=
 =?utf-8?B?dGhwc2Y3WEdpdk0vcEQ4ZVAyT2FIaHUyQ0ZSZ1BqcC9vTmNZWkcrRlNMRm1x?=
 =?utf-8?B?MTZHbUQwZk1xRmtBTzN1N2xqSFJmWTRocnE4eU8yZC9STDBSaVFLeGdWVUtY?=
 =?utf-8?B?TnpvWkRUQzhEMmljU0lBRUVyUkVybGpPa3l6U2lkMVoxVTZpYjY5bEExdi90?=
 =?utf-8?B?Yk9hUWduQ2o0TkhQU3FWSFBjTzZBSXRnYkRnM2l6L3U5ZzFoMGVzK2FqYzZC?=
 =?utf-8?B?YTYrTlZsZXZrVk5OOXZjaUgvMkxBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F95F7C48453D244999DE77F07E2F7E04@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 019498a3-b9da-48df-18db-08dd33e17105
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2025 14:49:11.3188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u37VGOhvS2n6HCm8tTkRz0NCB3xzJ+nqxcX5wdmk8ci9BZR5E8cjxlU3qCzEGJiVqbPwnj7hBB3xn3zZSJraryEaPP2l+MYMD+KVou2dRfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB10147
X-Proofpoint-GUID: zOqOa0-MbMr5jsZdvuovDLiuw5Yhk3tL
X-Authority-Analysis: v=2.4 cv=VaYNPEp9 c=1 sm=1 tr=0 ts=678527e9 cx=c_pps a=BX/OqAvQ3O7aab6wCuJmTQ==:117 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdSt8ZQiCzkA:10 a=0034W8JfsZAA:10
 a=0kUYKlekyDsA:10 a=7CQSdrXTAAAA:8 a=64Cc0HZtAAAA:8 a=_-HqjTFe1Ttpdl1-Og0A:9 a=QEXdDO2ut3YA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 a=14NRyaPF5x3gF6G45PvQ:22
X-Proofpoint-ORIG-GUID: zOqOa0-MbMr5jsZdvuovDLiuw5Yhk3tL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-13_05,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gSmFuIDEzLCAyMDI1LCBhdCA4OjA34oCvQU0sIEFsZXhhbmRydSBFbGlzZWkgPGFs
ZXhhbmRydS5lbGlzZWlAYXJtLmNvbT4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4gIENB
VVRJT046IEV4dGVybmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IEhpLA0KPiAN
Cj4gT24gU3VuLCBKYW4gMDUsIDIwMjUgYXQgMTA6NTc6MjNBTSAtMDcwMCwgSm9uIEtvaGxlciB3
cm90ZToNCj4+IEFkZCBhICdwb3J0YWJsZScgbW9kZSB0aGF0IHBhY2thZ2VzIGFsbCByZWxldmFu
dCBmbGF0IGZpbGVzIGFuZCBoZWxwZXINCj4+IHNjcmlwdHMgaW50byBhIHRhcmJhbGwgbmFtZWQg
J2t1dC1wb3J0YWJsZS50YXIuZ3onLg0KPj4gDQo+PiBUaGlzIG1vZGUgaXMgdXNlZnVsIGZvciBj
b21waWxpbmcgdGVzdHMgb24gb25lIG1hY2hpbmUgYW5kIHJ1bm5pbmcgdGhlbQ0KPj4gb24gYW5v
dGhlciB3aXRob3V0IG5lZWRpbmcgdG8gY2xvbmUgdGhlIGVudGlyZSByZXBvc2l0b3J5LiBJdCBh
bGxvd3MNCj4+IHRoZSBydW5uZXIgc2NyaXB0cyBhbmQgdW5pdCB0ZXN0IGNvbmZpZ3VyYXRpb25z
IHRvIHJlbWFpbiBsb2NhbCB0byB0aGUNCj4+IG1hY2hpbmUgdW5kZXIgdGVzdC4NCj4gDQo+IEhh
dmUgeW91IHRyaWVkIG1ha2Ugc3RhbmRhbG9uZT8gWW91IGNhbiB0aGVuIGNvcHkgdGhlIHRlc3Rz
IGRpcmVjdG9yeSwgb3IgZXZlbiBhDQo+IHBhcnRpY3VsYXIgdGVzdC4NCg0KWWVzLCBzdGFuZGFs
b25lIGRvZXMgbm90IHdvcmsgd2hlbiBjb3B5aW5nIHRlc3RzIGZyb20gb25lIGhvc3QgdG8gYW5v
dGhlci4gVGhlDQp1c2UgY2FzZSBmb3IgcG9ydGFibGUgbW9kZSBpcyB0byBiZSBhYmxlIHRvIGNv
bXBpbGUgd2l0aGluIG9uZSBlbnZpcm9ubWVudCBhbmQNCnRlc3QgaW4gY29tcGxldGVseSBzZXBh
cmF0ZSBlbnZpcm9ubWVudC4gSSB3YXMgbm90IGFibGUgdG8gYWNjb21wbGlzaCB0aGF0IHdpdGgN
CnN0YW5kYWxvbmUgbW9kZSBieSBpdHNlbGYuDQoNCj4gDQo+IFRoYW5rcywNCj4gQWxleA0KPiAN
Cj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPg0KPj4g
DQo+PiAtLS0NCj4+IC5naXRpZ25vcmUgfCAgMiArKw0KPj4gTWFrZWZpbGUgICB8IDE3ICsrKysr
KysrKysrKysrKysrDQo+PiAyIGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKykNCj4+IA0K
Pj4gZGlmZiAtLWdpdCBhLy5naXRpZ25vcmUgYi8uZ2l0aWdub3JlDQo+PiBpbmRleCAyMTY4ZTAx
My4uNjQzMjIwZjggMTAwNjQ0DQo+PiAtLS0gYS8uZ2l0aWdub3JlDQo+PiArKysgYi8uZ2l0aWdu
b3JlDQo+PiBAQCAtMTgsNiArMTgsOCBAQCBjc2NvcGUuKg0KPj4gL2xpYi9jb25maWcuaA0KPj4g
L2NvbmZpZy5tYWsNCj4+IC8qLXJ1bg0KPj4gKy9rdXQtcG9ydGFibGUNCj4+ICtrdXQtcG9ydGFi
bGUudGFyLmd6DQo+PiAvbXNyLm91dA0KPj4gL3Rlc3RzDQo+PiAvYnVpbGQtaGVhZA0KPj4gZGlm
ZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUNCj4+IGluZGV4IDc0NzFmNzI4Li5jNjMzM2Mx
YSAxMDA2NDQNCj4+IC0tLSBhL01ha2VmaWxlDQo+PiArKysgYi9NYWtlZmlsZQ0KPj4gQEAgLTEy
NSw2ICsxMjUsMjMgQEAgYWxsOiBkaXJlY3RvcmllcyAkKHNoZWxsIChjZCAkKFNSQ0RJUikgJiYg
Z2l0IHJldi1wYXJzZSAtLXZlcmlmeSAtLXNob3J0PTggSEVBRCkNCj4+IHN0YW5kYWxvbmU6IGFs
bA0KPj4gQHNjcmlwdHMvbWtzdGFuZGFsb25lLnNoDQo+PiANCj4+ICtwb3J0YWJsZTogYWxsDQo+
PiArIHJtIC1mIGt1dC1wb3J0YWJsZS50YXIuZ3oNCj4+ICsgcm0gLXJmIGt1dC1wb3J0YWJsZQ0K
Pj4gKyBta2RpciAtcCBrdXQtcG9ydGFibGUvc2NyaXB0cy9zMzkweA0KPj4gKyBta2RpciAtcCBr
dXQtcG9ydGFibGUvJChURVNUX0RJUikNCj4+ICsgY3AgYnVpbGQtaGVhZCBrdXQtcG9ydGFibGUN
Cj4+ICsgY3AgZXJyYXRhLnR4dCBrdXQtcG9ydGFibGUNCj4+ICsgY3AgY29uZmlnLm1hayBrdXQt
cG9ydGFibGUNCj4+ICsgc2VkIC1pICcvXkVSUkFUQVRYVC9jRVJSQVRBVFhUPWVycmF0YS50eHQn
IGt1dC1wb3J0YWJsZS9jb25maWcubWFrDQo+PiArIGNwIHJ1bl90ZXN0cy5zaCBrdXQtcG9ydGFi
bGUNCj4+ICsgY3AgLXIgc2NyaXB0cy8qIGt1dC1wb3J0YWJsZS9zY3JpcHRzDQo+PiArIGNwICQo
VEVTVF9ESVIpLXJ1biBrdXQtcG9ydGFibGUNCj4+ICsgY3AgJChURVNUX0RJUikvKi5mbGF0IGt1
dC1wb3J0YWJsZS8kKFRFU1RfRElSKQ0KPj4gKyBjcCAkKFRFU1RfRElSKS91bml0dGVzdHMuY2Zn
IGt1dC1wb3J0YWJsZS8kKFRFU1RfRElSKQ0KPj4gKyBjcCAkKFRFU1RfRElSKS9ydW4ga3V0LXBv
cnRhYmxlLyQoVEVTVF9ESVIpDQo+PiArIHRhciAtY3pmIGt1dC1wb3J0YWJsZS50YXIuZ3oga3V0
LXBvcnRhYmxlDQo+PiArDQo+PiBpbnN0YWxsOiBzdGFuZGFsb25lDQo+PiBta2RpciAtcCAkKERF
U1RESVIpDQo+PiBpbnN0YWxsIHRlc3RzLyogJChERVNURElSKQ0KPj4gLS0gDQo+PiAyLjQzLjAN
Cj4+IA0KPj4gDQoNCg==


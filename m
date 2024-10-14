Return-Path: <kvm+bounces-28762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C12AB99CB83
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 15:23:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4A0F1C21206
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03F9A1A76D4;
	Mon, 14 Oct 2024 13:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="dS9hH9kh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBE64A3E;
	Mon, 14 Oct 2024 13:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728912198; cv=fail; b=EdUWOlMkorr/Wku+Asd/aV5DqwL1W2G91hL9HPVT/vh3+o65h1DeWUxY3aXigCsgVRQYDIfJYyTfv8K0VO9tnsbRbFopDkKG/FQJuLEa6NYivEQ/EQvgJXQVHGVEI7Co0m05gtnP3kBW5L4j4XTS6zvPleOKcTa8lBye6bFEBeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728912198; c=relaxed/simple;
	bh=c7YyB9LLVdo3ZeP/sKASxQ9fXZKtWvmNPknQzKkmdzw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XFJXK83ZH9aePh/gKD2K+bQJX8YOQ09Vwq3YOX5T4GcU/l7psMmSnIv+/+O6qWfb2kwCzMtfPGDKI5bIx+IrX8xtD4OkHEK10Ik26CHKObHPjukWFBTQQQ6opWaI+O3gxu1WNJBJdbE8AoI/VvuYiEPokmNN7j4QxX4QGEy7xmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=dS9hH9kh; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49ECQE90005151;
	Mon, 14 Oct 2024 06:18:06 -0700
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4292fd066n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 06:18:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DjwtWLyOiKyWJJpdnHor2NVLkYVrzXXspRlaI3Aw06GuM2av6WE4bXKGFvQHtFiLdcJO6wdvmYS18j5QhrazWXkofFmXTOGho+hfd3pCbWf8WMphu64bpFx8nHm/RVXcZQ/WupwID7NzgGMtFPjmkP49EefnYv3NM5hLF3isUiYh7aCaPx4BNA1Dz9axZcpnWbx1b6YyY5mLMT5unnf8Aw91QqNzZcp9RUvWeQMyhtqQYCzuvJAX1AnrN6h2lWj0TFD0acUbCUPIr0vFf1TYwvp57iqV1YYIUfCgqLNZId+GMgu9YwxhZ1tpGopSNDg3l2kHtZHdnwjZlOyDiDtcdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c7YyB9LLVdo3ZeP/sKASxQ9fXZKtWvmNPknQzKkmdzw=;
 b=mhiKQz3spLkRrgTtRPHn97sUVx4NBr4LBhlwNfhX452mbLHwecUZ5SHxNUEztGTafCaQHLbw0ibM2sPea2/iaf+L7eT85bVygIJuul90FOM1s8pY0ixuPgc+Ldn/lAKCBo9hNvQwQmkyXbGZ6M21xpyiNnstGGXCnXfncTT374/IVTfzQgxTCwwyPBIjV8cR5GfD68iBWGH9X8rXqVTR0P6h/lfYUnFDJOnvEp+ykwASRR74RmT4TEO/P6KhVgOpBu1QIfXBSZnW57NuicpiPBjOdwJOP65ElaiXBOFoj6ds4CxLpUsZDkhfmiuDiM8R1zE1tJwkgKZfD5zogNg3Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7YyB9LLVdo3ZeP/sKASxQ9fXZKtWvmNPknQzKkmdzw=;
 b=dS9hH9khQso6tbH6LWkXuOm1ngTgvodi3nHTUzyhxpmXCHzgCqFluw+FKavkUB1m7FzpJDWCQomUyKhDhWEvunnmDG1rfBAHCtol7osXToX3z0xcKB9883O8a42GoEhSaCPuH8WmzOjv9Z6/8d/IUZWzlD1/Y77eQv6LQbGnAus=
Received: from DS0PR18MB5368.namprd18.prod.outlook.com (2603:10b6:8:12f::17)
 by BY1PR18MB5838.namprd18.prod.outlook.com (2603:10b6:a03:4a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.25; Mon, 14 Oct
 2024 13:18:01 +0000
Received: from DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac]) by DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac%4]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 13:18:01 +0000
From: Srujana Challa <schalla@marvell.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com"
	<mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        Nithin Kumar Dabilpuram
	<ndabilpuram@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>
Subject: RE: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Thread-Topic: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Thread-Index: AQHbE96PlQaeJdnt006ohvbKHfff0rKGTA1A
Date: Mon, 14 Oct 2024 13:18:01 +0000
Message-ID:
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
In-Reply-To: <Zvu3HktM4imgHpUw@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR18MB5368:EE_|BY1PR18MB5838:EE_
x-ms-office365-filtering-correlation-id: 54fd1876-8c21-4b76-4b7e-08dcec52a10a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZW91aWpUVGkyM0lxUnZ3UTlteDdseWYzYlRSVEJpdnM4K05WejdESzNTbkhX?=
 =?utf-8?B?WStkV2lLbERBOHQrNUYwTVkwN3NGLzdkSVBHQW8ycDBkTDh1bDFjUUhIc3hW?=
 =?utf-8?B?V0xyUW0rTGVrYXE2U3hHSHl6OU1GSzRlVUVZNm9BbGlzZGJWNXBoOVgvbXlB?=
 =?utf-8?B?c0dpMFVIREUzZkl0cVVkMURudjRLMjB1VjZqU2pkYkJnMS9QMDNQemFVSXVB?=
 =?utf-8?B?bG5MbkR3a0ZlZTFITnVyank5cWtSZG9Udk5udUVmdnFwWmp5K1E5SFBLb0JB?=
 =?utf-8?B?cWNGVncwZ0FoZmpUR3dSTUM3cXpTdEJncCs3SVdoeklWbkRLSDB1VGtMWkJW?=
 =?utf-8?B?YmVWMjJJSzNzengwdWpmRXJ1M0NxNlloWGN1cEFSY3hMVUV1NE5lQ3NJRDZD?=
 =?utf-8?B?cVRMNjhQRWJzRWZDRUsrUTMveGFiblhVamJ1UWFXbk1MdFFKYTJuaFZhUDJJ?=
 =?utf-8?B?Rzdpa2RPcTRiQWxRcElqVVgxL2JsKzVKZzVNQXhkUGtNSytYOEUrUDhLa2Yy?=
 =?utf-8?B?OUc1dHVLY09LcXRiUFFQVEpubHJwd0V0emhybkJjYXRZeklrNDF2VzhNdUdz?=
 =?utf-8?B?S1I5SFZMQ3VOSDFjdlFQMlNzeUpDZlNWclhXZ2JqbStHa21EMVJRaHFDZTM1?=
 =?utf-8?B?VVpWcHFNVjR5blBuL0lSVjVvUkFHQndxdWZZMERrTU9va3ZiOFhtSjYyRFFj?=
 =?utf-8?B?SGQ5YkxLaklmMzkwRjE4aXRiQkVzcVZwV1JQbmxMMWlNcVBXd3pPSFFHamZ2?=
 =?utf-8?B?Y3hIb05oamZVTnEwTk5aVUsxQU1rYURnR0t0QmJ5VGlIZUl5MXdhY0cxVVpK?=
 =?utf-8?B?MlJBUi9iYlR4dkRnRjkvblZDVkZNQSt4V0lVNm9mN0hpZzFxQjNVUWovckFq?=
 =?utf-8?B?azliSElCSDdzcmxpbmhVTmRMOGFSK1RHdVVNcU5LeFlOV0hvamk0bEFjRWJY?=
 =?utf-8?B?V293Z29VczU4aU1pSHdiQ1BsNFdvaXJEenBKZVlQdkwvVm80ZndRampLTWNL?=
 =?utf-8?B?WXl1bzI5bmpLWERwdnJucUgrVytBYmJvUGQ3cURCaFRiNWdQeFU3Tlc5VXpU?=
 =?utf-8?B?bUJYeUw2cFB2TkE3STM5dFlNR2luTXduZnBRc2hQdCtLeVdCRlhtTE16d2lz?=
 =?utf-8?B?dk1iZjBQeWdENGh6UmppSVlUVFF2Q25aQ2VTdmV4enZQeTZOZHE5NjM3WE1Y?=
 =?utf-8?B?c3JndkVQRTBvdDMrK0JJMTN3RGlZNmpObmtNMi9VUm4waTR2WU1LeWFoQWFX?=
 =?utf-8?B?UnErSmc3UCtKbjl4U0lTQk5uOXdQVGFiSVFzeDZnZWNBdjZzeW9TR2hIWXRh?=
 =?utf-8?B?UWNsZ1U3dTR1bHJPT1NlSGRBYWxvcE1iajE0Q0ZpcTJaYk9TdUhIU2VWNkpU?=
 =?utf-8?B?Z1BNcm05dXhQQ1BJdFE5SExmcTFlNXNISk5seTIxNnB6WUd4TzBmRHRTQXVz?=
 =?utf-8?B?UXVESWJpekZMSFBHa2J5OEdLa0Y2bHVJMTZ0eVhZUElTWitnOW5xQjJXQ0ZG?=
 =?utf-8?B?b1U2RnRIT1hLRGJUMDVPMmVrVzNsT2NQdmJSMTBaNVFsb0w4SVVqUmNHMWli?=
 =?utf-8?B?b3pYYm51QThHZVlmdmdwQ0R1VUpRL2MzSmJVUFVPdTJabFJEemowSDNXekdw?=
 =?utf-8?B?NVhxVGIxZEFMdXlQRStaNC9mSjMxNjRtZW56NFBodGhYcDFtRkhucTlza293?=
 =?utf-8?B?UTgvbWw1NXg4eWdEc3lhR0hVZStvZFFOL1M3TDZDdXpKQ1VvdUFJVkxBZTBa?=
 =?utf-8?B?ZVAzbWhyOGorRjM5V3dSSjJyQTZ1MitvcHZjZkV1T2lEWGlvbThyZFpndzh5?=
 =?utf-8?B?TGpqUHRzbEtNVTh3YmNGUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR18MB5368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RzNNNVNSOTdOcnFOU1p2cjZ5Mmx2Y2VKSzYxYnY4UE1xS1d2bG5aLzNxWlhL?=
 =?utf-8?B?U001YTlIY2FXbnc1YkhCV2xwUitCbmRQQi8xdlUwMzFJUGlOK0dNbEY0Z05L?=
 =?utf-8?B?OWNKNGp4dSszUW10TVA3UHIvdCtCOG5icEZsUVBYRkJtMmNFNzY3MUI3OVNl?=
 =?utf-8?B?YWphMDVVaE44QzNqUVR5M1RCS0RrakxLVkxWQWxCQnR4WG8zNWVJVldkNC9s?=
 =?utf-8?B?alJOODk3MERTT1Z5V2MzV0dlcUZxZk5NcjBiMEU1MjBneFhLdkZybTJBY1hi?=
 =?utf-8?B?Nzk3d0VjZU1xMUpoT3hmLzJELytmSlpuQ1gzS3RIQ2wvVXllY0hyR21oSkRF?=
 =?utf-8?B?a09MQ3dKalRZT1Y4Tll3dlU0SVNwZ2lkaEFnbXZXcTBHY2h1MkZFeWI0cWlO?=
 =?utf-8?B?dzdjQjB5K1R4SWYrZGZhcDFYbnFob0NaSWhSOXBxekgyQjhsaHJUOGorMnBq?=
 =?utf-8?B?S04yNkI4OUx3dCtzbWhvTEF0V2F1TThDYmJOOUlMWlFiczVrcWtpNXVXQnBU?=
 =?utf-8?B?WWdmNGVQY1RQQmdiaUI0SVlSb3Nyd0dYcSt0WS9xdVhnSExkTlEzWUsyUGtX?=
 =?utf-8?B?N3lyeHBXZkU0emgvSWttU2E1MzNZaFY4RjFGdlZQaTJGWEVTLzJTdjVmSWR5?=
 =?utf-8?B?aGNvbjZZRmVISk1PNTFxUjhDMG1rVk5FbmlUM0pqWitXZUlMZysxcnl6Z3Zr?=
 =?utf-8?B?aXBPcWp6MnQzdnVpNkZ0S3VqM0lDNmlCNWM3aFhRRGlNVXc2Syt5WFNtTGp3?=
 =?utf-8?B?WE5ZMDV5QS8vbjFHQlZ5NXBCNjZPeXN4MzVmY2dPZGZGQUN0KzJrOFUyVnpT?=
 =?utf-8?B?RUxaQkdzaUpNWjVKVjdjU2dVTFdkUmg5N3MwcTNoTENSUk9GWHFYYUs5aGI0?=
 =?utf-8?B?YVB2eVAvRlhwRlg5WVNoMVpwWnVIVDJNRzZad0dhellPdjNVUmJETG1FUCtk?=
 =?utf-8?B?QjBpMmdGNUFaTjJobE9TL2RVSnNsaWVUOCt1Ym12TGpkR20zOXpSTmpCUXBV?=
 =?utf-8?B?eFoyRHhlbG05endQcHJJVDN0UndxT0JrRHl6eHpYMjlLcWhSQ2tmcnBIYnhL?=
 =?utf-8?B?Q3ZBM0xXSkp4emNDRUxYZDVDMTliVjRCdE9JUG1qR08xd3N3aDAvcUpKYVVp?=
 =?utf-8?B?YXVrVEFrSWtVbnduVGRDcGt0Qy9RM2NlNUYyTE8zYW5oeWVHdmh5M29mWCtK?=
 =?utf-8?B?V25sY0ViM3NPV29ySUlLRW5Ob3JyYzBjVHN6Z3p3dlZuL2lFWUZKeGhXV3BM?=
 =?utf-8?B?bUgvU1VBbEo1K2h3WG1ndlRENHlLTFFEeXkwcHE2WWFKTExqdUhCS3Z1YWov?=
 =?utf-8?B?WFBYcjA4UGxYbUR6SHR2MXZ2VlFUUkMzNnVGTXBsVU9sbVFUY0swNWxTQ1Z6?=
 =?utf-8?B?MVduTVBFNGtsdlZmQUlxNE0yOXhlWFBYeXNzN04rRHBsbHhjeHprTmhXdkRU?=
 =?utf-8?B?diticDMwOEgvaDdtb2V0OHIybEthUlhvczBWRkJUaTVhUXZteDJoS0hhbDFF?=
 =?utf-8?B?RUlBbncySzlYdlVpVWQxNXRpVG04RTgzZXpwNlR5dWRBeDUrM2lCWFVFWWJn?=
 =?utf-8?B?elZPaGtoa2cyLzNJTmIyMUpzakE5QU5xN2l5SmpxV1MwNnJiOVpKd3c0ZE54?=
 =?utf-8?B?L1NiY1E3a01WMVhUTmRpYVJDQXNtb3NheDZaT0RlS05HclNpSVNrQlROVVRs?=
 =?utf-8?B?TmVuS09LWHJZNFFDMEJiS2NqeUVjZW13SHEvTFJBeGxMb0FKMkNNMWEvbWhP?=
 =?utf-8?B?elZuT0hsZXJEWThJWDNSNU9wT0FBcUxjeXlFRHl5bTRqVFM2WDNSejBSaWNu?=
 =?utf-8?B?dEZGbFBxWTJZd0Zhc3hEODN0bnFFWFIyRng2ajZUb2dvUHBYMEVRSCsrOU4r?=
 =?utf-8?B?WEZOOWZVTmpjK0JVRUxrVEJ4c3dUVDV6bkVhL1NROFdqd0ZjL3djeTlMamZ3?=
 =?utf-8?B?Qkl2R1duMTYrQkpTZ1EvVDRiUWpHYTJKT25SMlpZcURyWldmV21xNXh2eFFv?=
 =?utf-8?B?THRlckQzbDZTdVlRb2pYQjcxcUNQSEprVC9sVzU4TVlLd2dkSFVPNjRaRU90?=
 =?utf-8?B?UmFXSGluRVIxaXpzQ1RtSzRERnZzSU5Gc214NFBTU21XMGRTYWloMHFxTURL?=
 =?utf-8?Q?jQNM=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: DS0PR18MB5368.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fd1876-8c21-4b76-4b7e-08dcec52a10a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 13:18:01.2899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u4t/RvTHpkJn7raaukdahLwzaRqNaT/fwUJu3TWsTwPIoL/7TGKMrqPyhsc1yOOUsHcKiXTsJBbpeRtakluxDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR18MB5838
X-Proofpoint-GUID: mLu8l9B-53qh3u8HwgzMRtFYynclvp3I
X-Proofpoint-ORIG-GUID: mLu8l9B-53qh3u8HwgzMRtFYynclvp3I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

PiBPbiBGcmksIFNlcCAyMCwgMjAyNCBhdCAwNzozNToyOFBNICswNTMwLCBTcnVqYW5hIENoYWxs
YSB3cm90ZToNCj4gPiBUaGlzIHBhdGNoc2V0IGludHJvZHVjZXMgc3VwcG9ydCBmb3IgYW4gVU5T
QUZFLCBuby1JT01NVSBtb2RlIGluIHRoZQ0KPiA+IHZob3N0LXZkcGEgZHJpdmVyLiBXaGVuIGVu
YWJsZWQsIHRoaXMgbW9kZSBwcm92aWRlcyBubyBkZXZpY2UNCj4gPiBpc29sYXRpb24sIG5vIERN
QSB0cmFuc2xhdGlvbiwgbm8gaG9zdCBrZXJuZWwgcHJvdGVjdGlvbiwgYW5kIGNhbm5vdA0KPiA+
IGJlIHVzZWQgZm9yIGRldmljZSBhc3NpZ25tZW50IHRvIHZpcnR1YWwgbWFjaGluZXMuIEl0IHJl
cXVpcmVzIFJBV0lPDQo+ID4gcGVybWlzc2lvbnMgYW5kIHdpbGwgdGFpbnQgdGhlIGtlcm5lbC4N
Cj4gPg0KPiA+IFRoaXMgbW9kZSByZXF1aXJlcyBlbmFibGluZyB0aGUNCj4gImVuYWJsZV92aG9z
dF92ZHBhX3Vuc2FmZV9ub2lvbW11X21vZGUiDQo+ID4gb3B0aW9uIG9uIHRoZSB2aG9zdC12ZHBh
IGRyaXZlciBhbmQgYWxzbyBuZWdvdGlhdGUgdGhlIGZlYXR1cmUgZmxhZw0KPiA+IFZIT1NUX0JB
Q0tFTkRfRl9OT0lPTU1VLiBUaGlzIG1vZGUgd291bGQgYmUgdXNlZnVsIHRvIGdldCBiZXR0ZXIN
Cj4gPiBwZXJmb3JtYW5jZSBvbiBzcGVjaWZpY2UgbG93IGVuZCBtYWNoaW5lcyBhbmQgY2FuIGJl
IGxldmVyYWdlZCBieQ0KPiA+IGVtYmVkZGVkIHBsYXRmb3JtcyB3aGVyZSBhcHBsaWNhdGlvbnMg
cnVuIGluIGNvbnRyb2xsZWQgZW52aXJvbm1lbnQuDQo+IA0KPiAuLi4gYW5kIGlzIGNvbXBsZXRl
bHkgYnJva2VuIGFuZCBkYW5nZXJvdXMuDQpCYXNlZCBvbiB0aGUgZGlzY3Vzc2lvbnMgaW4gdGhp
cyB0aHJlYWQgaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMva3ZtL21zZzM1NzU2OS5odG1s
LA0Kd2UgaGF2ZSBkZWNpZGVkIHRvIHByb2NlZWQgd2l0aCB0aGlzIGltcGxlbWVudGF0aW9uLiBD
b3VsZCB5b3UgcGxlYXNlIHNoYXJlIGFueQ0KYWx0ZXJuYXRpdmUgaWRlYXMgb3Igc3VnZ2VzdGlv
bnMgeW91IG1pZ2h0IGhhdmU/DQpUaGFua3MuICANCg==


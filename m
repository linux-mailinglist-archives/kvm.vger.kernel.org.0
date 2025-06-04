Return-Path: <kvm+bounces-48389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF27CACDC5B
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 13:16:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BC30174303
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 11:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E1CF28E5F8;
	Wed,  4 Jun 2025 11:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fJxC5p7x";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="naQPiqp0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D9A2820C1;
	Wed,  4 Jun 2025 11:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749035747; cv=fail; b=EB+v+NXQj3R3kg0EzCwit51AvLhm29jIogZFiQUP5iM0/vBxQFe22FV34Nskx66C8si7IscHRQAWxY59373PVsj4PoqqhuXie09IHEfYLOJ0Aka3pjHWfC4Tu1ui7ZDJmeOHm7CUW6kGdyqMzoPH9wgeVW237Yv8qwQC5KM/ZW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749035747; c=relaxed/simple;
	bh=2BZx0emfxA1++3SKRoifnCJJ1jCH8OMg34e0R2Xn04E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YwFE+tF31krLrjkITq8y28nLND3EHhzbT6UzmDj7lgY8/tC+FbjNcKZXSHBvoKOD9iArkoXpTibeVM/q4eC3+gB3jMECH4JbuoBFJ1K6DtIIDXendI8xjFbPgax+zkpZUwHPUgQbOs3uWD6DtPrRbS1CsEylBhcxAxv+BEUQmJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fJxC5p7x; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=naQPiqp0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5549Mfr5012256;
	Wed, 4 Jun 2025 11:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=z2kAK1Q0rlrZpxiGMpEQ/nwaLUI9RSslVQgG/Ax8qms=; b=
	fJxC5p7xTiK2gvUklJtf1RRGAK8VtQscdDSiiQzMvq2zZPd/POkZxrbbh0/0Rlbr
	KsoHwk/xd/n0lSwg3iUAv8r3791zXsKEoB7/n+B3xqHn8OwOwHib7jeysJgou51g
	i5OExO9x3QH5KhGOsNIHfiJ9iEyIpploiv8aOUa0lEkZ6k9EPFxkjwvq+ev1w3o2
	RAYBLtdGFbi9Vcqj9icYf9m0z3sa2gRmm7+PKDoB7wRYzj8SzmU0tW0/jUXgjS2k
	O2/wEYZA7PTi3CtiRDNj6Jznl0+BvwQC1LvZu+FlzjaaEueHK7xJibO9wBh6XEkE
	6smtPfJEr1OBtUtOfeu5IA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8cuqhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 11:15:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 554B0PQX034603;
	Wed, 4 Jun 2025 11:15:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7amduk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 11:15:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vjn/Exa/JOuCwyeig2sEx6ncwL6x/aUBqZcWvwWUbWYw1OgM/i7xryx7eQvaU9p14CY2BVsBySnI2/Ta0shUwx+RgRkinc47eiqERiF1uMB5upHyG9iZ8vC0DX+Pv1HTScGYUVoBVfR1NrOBmD/ZN93wXWzH5M+t9Uy0+Kw7oOmIeO+LlIa4QahjgsM5BwuOquPrBfIGrCancs1MODo5YEmaR+wIYxhT8VHfoyq8do6pO3oY6zGS351xhLZv81lvNbgZMsBkz+OSgg3up6ROZdDy4/x7cGbeV388h/urDzntQ12RofWuuZZUaEbACmHJJpaParWLTJs1QyjkALr8wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2kAK1Q0rlrZpxiGMpEQ/nwaLUI9RSslVQgG/Ax8qms=;
 b=wJwLl9kCLl49yTehIWd/OPpT9/PN+i/aq4h9jSBieY9IGAYAS49tiXmCdU2vduyJmyRU85tYxhOMOxCtWcvJXvN2YtaqSl+3oDH1EsTQYOhmQRHwDANetJ8g6xKiDDP54TCjTGte7CjIs9J+E6+IUFus8cmMup/KhhM2grR//oP5mGnQbpmtzWWdeB0b6b42EBlXh0yzUqBjRjvLDt/+Srmx6QfRLWuUiIrFxYiesDz5DUUB2k0hSAjBulEARCMUjbz0y6N3QNh1QgNSLV8pM0eMOvH83xtF1fsF7qvlhKtORzRZc+lzcFGCWn3qud2FxVHpKZ2t4ugB+3G1i7r2Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2kAK1Q0rlrZpxiGMpEQ/nwaLUI9RSslVQgG/Ax8qms=;
 b=naQPiqp0gKq8ucQaLYFoegPvYBB3293KRevIqLG2zbEpLP9bMmUKyrKJTmBlwHvJDxpFZjZZYJfz6rwcOJWeCtstGJewS3+GaM6kwtFwnVqleFOijQcP/OISeN3JjM7BkLDNCpnO7usaU3ii3VG6R8TIDfMYROf+ojLaxmzdEOM=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by IA0PR10MB7133.namprd10.prod.outlook.com (2603:10b6:208:400::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.40; Wed, 4 Jun
 2025 11:15:37 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%6]) with mapi id 15.20.8792.033; Wed, 4 Jun 2025
 11:15:37 +0000
Message-ID: <18b86c31-e657-42e7-bca6-ddae52ead231@oracle.com>
Date: Wed, 4 Jun 2025 12:15:28 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: SVM: Initialize vmsa_pa in VMCB to INVALID_PAGE
 if VMSA page is NULL
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        James Houghton <jthoughton@google.com>,
        Peter Gonda <pgonda@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20250602224459.41505-1-seanjc@google.com>
 <20250602224459.41505-3-seanjc@google.com>
Content-Language: en-GB
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20250602224459.41505-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0204.apcprd04.prod.outlook.com
 (2603:1096:4:187::16) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|IA0PR10MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: 15ceb07a-8d7c-4c7b-c617-08dda35921a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVBOSDFjKzhGM3l0V3FCZEk1QTNLemVoQ1RzTHBGd2VXOFJvVlEwZ1NOWW81?=
 =?utf-8?B?bGxKNVNFNUVKSi9lNjc4dlZOUlV0R2cwSE1lRVBXVHduTDNkRVFLcjdHTXNP?=
 =?utf-8?B?N2p6dk9oT0d1VElxc1psSzhRYXJFc2xDNTkxVkpPL3I4UHMxZ09rZ3lNZDRX?=
 =?utf-8?B?THVIbk1TSmtFSHJnYlZMb2pOSmxNc0ZjdGRhck1wMHZkVGdKWlJrUG9rbUtV?=
 =?utf-8?B?dFVDd3FXV256WjZvUCt4dWNiRDY3SEs4cWtkSi8raDljT0lrL0ltUStMYXht?=
 =?utf-8?B?V1NPV21HZFRXM1c2Um1NUDV1YmNwWHBKRFNWNUNjUFBibTdwQ2NIbDNOLzNz?=
 =?utf-8?B?Y1JCMm9qRjE0Rnp2YzJvdXc2dHo4OTkxdXc1OEtiSHFxYnhBL3JxZ1BIWTV6?=
 =?utf-8?B?VENQaENmZkUvbERYc0ZjMnQ4SytKNVdoQTIzNDBTSmE0c3ZPd0NEOWFscm5Y?=
 =?utf-8?B?MWoyeUNxOE9qSTQ4MXBGejYvRTVwR0ZHeGNyV2xLdk9YeGJwQ1I2QVIrU1Qw?=
 =?utf-8?B?eGozZ0JKOHhjK0RwVUNzdDVyWVo0OFFua2prZVZDelhpN0htSHZtYzdKMGpt?=
 =?utf-8?B?b0N1WVQ4cGRobG5ISHhlNm8vUDhuUmYrOXk3ZnY4cTQrempjeHRxazA0bWdO?=
 =?utf-8?B?Z3ozNDcveGYxcjdvUldlL3BoWGlkZ2hVSk9KRWtPd1Q3cENZamVOUGZIaW1I?=
 =?utf-8?B?MUQ0T1NHZ1R4dnpxUlh1YTBkQ3NTVG5EcjhOenYybVdrQzRQMlRtMjZiN09i?=
 =?utf-8?B?VTFwY3JpSmU2eDkzYXpqM3JXY3QzR3hPalI5akZuTUwxMCtmZit3ZVR0L2pT?=
 =?utf-8?B?b3RRdU9sWWlkL0thWU5RZ3NMbi9MK2ZzeGM0NWxyZ0gxU0FRS0drNFRteEw3?=
 =?utf-8?B?c3NLM08vOFpHclU0UWlSUVF1MjBjSTlVNkY0RmdqejRuazQ2cHh5NWp4M0dC?=
 =?utf-8?B?TE9yVWZyMG1JQVpHdUtHU2VKclRwclovU1RJcDdKTkdlR0NialZhUmE5Rzkx?=
 =?utf-8?B?RERuOUgvUWhha214UjlJU3NVYUF5OHYxd0JmRjkvVFFwNVloODBJRU9iMTFp?=
 =?utf-8?B?SWhURisrTGFsVzVuNW91Umlkekx4MExwNVE3WXZSbm1XaWpJVk5LamlzLzFE?=
 =?utf-8?B?N0pxeG4vcGh4YnZ6SVI0djBaZ09uVmhLdnQrSi95MlArSU1IeWI0OVptK3Av?=
 =?utf-8?B?cHJGenI3YnhJWitvcDlOSW9BK0J4WmdDeUJ3Z0FuN0VUTU9aSUk0MzJIUkJ4?=
 =?utf-8?B?aDJkOWdVRzRnODNIaWJlSXBhaVl0bnA3eXc0d0MwVnRBRFk5aVBHa1ljMXFE?=
 =?utf-8?B?TXFucHdzNW9waUJGU01KMzQ1ZHRJZlRsWWpGOFZIR2xkOThSODRyLy9pZ1Fi?=
 =?utf-8?B?YTQ5U2pxaUVHVkIzOWdPOWtpQytpMDJMZkkxM2Rtc0FqUWJXVUJmempYTzJY?=
 =?utf-8?B?SE5VU2FkK2RtM1BkazN3MWlhcTA0MSs0KzNTQldMM2VhQWVwNTVTeEx3TDV1?=
 =?utf-8?B?QTZWK1l1WnJJZ1haendaT081b0Jib1hnQjJIbVJWek9IQzZVcFBrbHdMUGtJ?=
 =?utf-8?B?WlhrVG1tVlYxTmt1OVo5dkhXb05CQmovTmxIQi95SDVONzl1K1lFbUpzY0ZB?=
 =?utf-8?B?MEVicWRaZXA5VlBsem0zSEdCOURqWVhyb1BuN1VqV2JIWFdEbXVJSzJqYmFa?=
 =?utf-8?B?TmE3UkM5aENDbVVqZDJwSE84M1lvZ0VWMDNBV0JDclJTZE1lRTBvQXJXSi9p?=
 =?utf-8?B?SjF0OWN0ZWo3aHVUUldQRU5MS2VCOENad1c4MjFzd0xtalU1TjRaUkVWZTdZ?=
 =?utf-8?B?OFJ2TnlTVUgwTjhqRHdZbGo3bThRZ0taa2s3cTB6bDh6cHhWc2tuMlJZbVNZ?=
 =?utf-8?B?UWtEVW5QTGVxZ2dOTnd3c1lzUlMwRXZDbEhlLzV1Zm9RU2VxYko1UmhZY0JI?=
 =?utf-8?Q?H1a4k6wjJb4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a04xSGNYYmlBczVpVU9vR0xhSGdNYTZFa0dJTDFaRExKaUVzMzJMVVlsRWxK?=
 =?utf-8?B?SmU1KzJ4TmlPV1F6MFJ6QmVBNWorK3FWcU1HSjB5WXNyY2JyNGd4b1p2eHpG?=
 =?utf-8?B?TzNWalE4RExiYXB6aWxnYVREeVBkVFhSOU5sWllGOUgvbEoxdGgvdmtmenFh?=
 =?utf-8?B?WmNrWXVpMlcveGJDa1ZmQ0ErNWQzQ2M0T1N5Z1lGMHRHKzRRaDAvWHNVZEVY?=
 =?utf-8?B?Rlk4ZGRWRlVDbHBOc2dpTWp5eVg5dGxMOS9vUnUyK3VPWGRjRVhQcUcyVTlU?=
 =?utf-8?B?a3pBakIyTmhHMVF2V01LTWFlNTBXTFRGYUIxZE1PbjcvUE83Q2NxQWNiNThx?=
 =?utf-8?B?dWI0bzVhbDdPeVhjWGMwcjdMcW1pSnlwdVBLbnp6YVdBK0FITWxMNG92VjJZ?=
 =?utf-8?B?Q1R3REYrWVh1QmJSUlNjeHM2N2FXdEJocWhGYkhQc0ozcG16T1JpbGVlY2NV?=
 =?utf-8?B?amw5ck5nbGp6WWF6VHEzK05aWmpacmh2NXBuMFpBQzJEVmpMc2ErYlpra2Rp?=
 =?utf-8?B?ZTg3SlZQTHFkK1JOWGtBbm5JbUZ1V3dOMUpWbzV4Y1RrdXRTVG5Ua29GejBL?=
 =?utf-8?B?aWpVMkFSQTMzYnhPTnBTcDE0ZnBUQmx4YnZIK2xPOWwyT1JiMTFkN1U2ays3?=
 =?utf-8?B?V1Q4WTJuR28zVjhqYTkyYmVYSGdsVkdFRVNKS1Q2b3hEMzRLWFhWM0U3aFZm?=
 =?utf-8?B?TUQ4aWxzdWdYWFNSZnN2YVlhWDUrZ2NIYnp3Ym5qWFU5Y0tjQXozcTJhY3Nq?=
 =?utf-8?B?WVBtekdNR2RMSWI5cndtWHhWMUNTTHF4SWdGdXpMa1ZDbHVqdmYwTWNsd3hq?=
 =?utf-8?B?SlJxZkI4UU16M3EwNlFFaTNPak83Qmo4SnhrQzVsdzJYU0JIWkQ1ZHA0bXBX?=
 =?utf-8?B?d0FqL3lhMGlacGF3QmcwM3pwOWlDYk9TMTMzay9jSE5IanYzVHIzNmp5dllH?=
 =?utf-8?B?ZlBTWGwyNGYvUWlhd3FwbXlzWlZxa0pleVJXZ3kxWUo3WDY2ZW1KZDNleXJs?=
 =?utf-8?B?VlMxWnAvRmpqTUEvNzQ2WTRHUjdmZlFPQlBzUDJBOGxKUFhLNXRrSXVTVlhM?=
 =?utf-8?B?M3JlVytrM1gvdHJ3dWhoUFVwL3dYcEgyUE1zcmg4NFV4b1hpTmxHWVVuT0xy?=
 =?utf-8?B?U3VyMHRRVjVqSWtBRU54QVVmMmZUNjNXamYvaUJGcjFMNktsZ0t6RHRMK2JX?=
 =?utf-8?B?d2JZOWVOTGlkbzJIVUtYOG0xUkh2aXRjcjA1UkJyaWdTR2ZlNEdXSXFGSGVT?=
 =?utf-8?B?QkxaR25DazVtbVdpSEc0Wi9XUUY5VHU0aktKa2dEQTdpaXppRlZnWWRrT3BL?=
 =?utf-8?B?ZWZXai82VURkWWx2YWJNQjBOQVpKc29ob2JwQllEM2dYMlhDdXFqenhXRUJ5?=
 =?utf-8?B?c3cxcWV5MjVGdUlzY0UzQnVTaWd3azgxK2NVK2E3azIxQ2l3M1lRZFVKN21S?=
 =?utf-8?B?QjNWZDNrUW9kbjFzTVFnWEFCYW1FdVRvUzgvVHZ5TWc4Z1RhUDNiTnVlYzh1?=
 =?utf-8?B?aDdyRENFWmdycjJGNWlEKzc5RDZuM0JUWDd1TWxkSHlQZm9XamhnRGxORnlU?=
 =?utf-8?B?TFFVTy9QWWFCVmhaZHYzcStzQkxJRXJmSFdFUTFiQlZ5MXZBbmRaMkw2VDBS?=
 =?utf-8?B?UjkxS3k5aWZTZFhnNkZHbFBhMkRwUG9KWUI5ZldLWk5MVnl3VUJsSTVoUGlX?=
 =?utf-8?B?VnRwdnBwYzJFeTBVVVppbVVtTCtRcXRKWDBPckRnSVRjMlN3clJXSnNvcDE3?=
 =?utf-8?B?S0tBelJiSU0vQUdmL0FZUzFFQXIzb2NPalNPblRxWFNYZzhiLzBPbW9pMklP?=
 =?utf-8?B?enRnNWVlWWN6QUJFZHloYjQ1OU5rUk1XYVJYbllBNE1Wb0VDVnJsMDZBdG1h?=
 =?utf-8?B?L253c0xOQkwzRlhHSzYrMXJDQmVadHBoTml5V0trMiszdy9Lc0JkVEd5NnFZ?=
 =?utf-8?B?cE55akdvZGQycjRET3g1ZCtSOUUxTEhGUlJTY3g2UjZSclVzem5zNHhFenVN?=
 =?utf-8?B?enNTZ1J0ZmJFZFUzRU9kb0FERW5YNFhqUHBXYXdmeXZiOHFmT2NMU0cyMGd0?=
 =?utf-8?B?S21PNjZ0RW9IME9Fa0FoSmRnTE1jRENubEhtYlZzY0ZtM0VPMmM2cjNxRzBO?=
 =?utf-8?Q?MCzmZSeut1blPrF3kz+C3jSO4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6HyM5pMsLC593JFjvWMCcbkD3/8V4v3mM7uQA1x2XC3r2MBJ0UCktfIAA4uWody71oZOMP5IXqVlmGJMCExj2ZwCrZ3TfLMoiX8BIWwDDpqDjSxFixTsPkreY6Jwaa0IBj4Ns8Yk8QANNYFpCg71KxzmAVqU8AjVJGuuHyLlXp86f7bNXRUKEUCES9g/t+O062pResgZ99a/SCZ264qaatbj4fElTlKXWY7/9es5wyPdi3oiVlPqcgwe8MhOHa5A40CBFy9qtWc3uj1x5UyujaujfjZVA1bqbGvQxuFuGEeg6W8YIENZWWZzT3qnSvDM0Wsy5/MyKWEXjDLMdWtTd+9ludThqFu1WXS40w9o7URTXFa7TMbN2Tj5rIMxqMBIRUUZRQii0JGf9byJ3rxWUJcaSVwRZMFhn6i7gwUv4ECtmS0QuHLFe01Cl47O/8OLH8PKBy1CpKjyr6OlKwkV0R1wZ9H9bMOza7InJ1mzNUk2xSTGyxeZn9bywJnrAcu0fojtuC+qzyPvF+JTCH+XDOZEG9Y0kdJfRM0IRpGVJpN2Y1ctvAQhIHBzJ6SYOVicCFuZXBB3pfq7sSkBLtVEBHXdPGYpILWHNOT60pqo6HM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ceb07a-8d7c-4c7b-c617-08dda35921a8
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 11:15:37.2031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4K91kjXUdNB8AptM5rHKgoGFxjyx22i7b0kiCcZhlamdFmeMv2CFiifwbX1C8W2PPATJ3FmPTiKVoPd/MvT9NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7133
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_03,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506040085
X-Proofpoint-GUID: ku7dSEW9wUEaJ5S1P3Ig9ycmp58_p2Yu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDA4NSBTYWx0ZWRfX6VHWa8X5Mmt1 N0yK3gRpk79hhces4BqUbfPSw/B8Ds6YGNT6M91c4f7BRydfx4NCEyX93BZwXjabSaFC0txd7fX b4l2wn8hlddX6sXdIsg8vnsFdtpOhFLKBz3IovEAHN+xZ4NOxdXNqgByEU/HY7jS+sJFE5OLC93
 nMvzE89gPX4Zhweq1VGsaVIYU1sml3XBdOxaQw0AJGiaQU5cpHM9HJVNQtIS/jkBWvyTGywyL54 Plm3NA7TZH9JIm9M7AF8bBmF+T//760P5n8zXrq0/5HBzzM661/p2LgJLlB7/Y4+UXJcZ2ye335 8hG/c5tbPtZ2qHvkTysl2j001MQuhjkOweKlTePm8+2SrVY/1uTiMVi6wHUz4+tK4+5a0if2G20
 /099A2EkZzrzdRsmb0P5uPHeN79SHTFAWMZfn50jaLOGvsrdQ3gdSeT1VMiAuQ/jjv24n1mk
X-Authority-Analysis: v=2.4 cv=KaTSsRYD c=1 sm=1 tr=0 ts=68402adc b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=zd2uoN0lAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=WlJtN08NMJsrYo0BGjwA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207
X-Proofpoint-ORIG-GUID: ku7dSEW9wUEaJ5S1P3Ig9ycmp58_p2Yu



On 02/06/2025 23:44, Sean Christopherson wrote:
> When creating an SEV-ES vCPU for intra-host migration, set its vmsa_pa to
> INVALID_PAGE to harden against doing VMRUN with a bogus VMSA (KVM checks
> for a valid VMSA page in pre_sev_run()).
> 
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   arch/x86/kvm/svm/sev.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 93d899454535..5ebb265f2075 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4471,8 +4471,12 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>   	 * the VMSA will be NULL if this vCPU is the destination for intrahost
>   	 * migration, and will be copied later.
>   	 */
> -	if (svm->sev_es.vmsa && !svm->sev_es.snp_has_guest_vmsa)
> -		svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
> +	if (!svm->sev_es.snp_has_guest_vmsa) {
> +		if (svm->sev_es.vmsa)
> +			svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
> +		else
> +			svm->vmcb->control.vmsa_pa = INVALID_PAGE;
> +	}
>   
>   	/* Can't intercept CR register access, HV can't modify CR registers */
>   	svm_clr_intercept(svm, INTERCEPT_CR0_READ);



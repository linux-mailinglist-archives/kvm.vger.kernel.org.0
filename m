Return-Path: <kvm+bounces-29161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E059D9A3AA4
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 11:58:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 041931C21EC0
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 09:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 945DE2010E0;
	Fri, 18 Oct 2024 09:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A6QNstxn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sVwQzh7y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEBA168C3F;
	Fri, 18 Oct 2024 09:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729245491; cv=fail; b=dHYNbw2erIE+6PajwMPNfrq7Xna0tHkdbPjhwWPw4DAqCrEztrNZPALgBLyj2vBDEfsqcuQ+AYX9aVS1Guh22hcH+MHoFU8G5toVn7wjMTJU2Gu1x4BBFbYpno38rBHqTSKpI7FjBNOS0pHt9MCKlekmJTAIcKt1iIWzw4YldT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729245491; c=relaxed/simple;
	bh=m2+GxzCDTONK5dYru7nvTNXvIq4Q30Tjp/LbgU0WLFQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ovp6PpA5Yc2ptx8fnKQWNcONK20se3gtChSlpt4vt9VUFDF6yEdl5bOevgl9JjR92Xtt0jsgClo9nsIFqdZTKsepcWrW/QueFn5xCir+/XUeb9+L8k/Cg5oAdGUd/B4TUA+4CacjnEJxQpjy8hZN5kfHNuyg5psN9Rh2WPBrqLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A6QNstxn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sVwQzh7y; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49I9ixKP007925;
	Fri, 18 Oct 2024 09:58:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8ccqLkGICq67mCeeL6ctuya1wr3iCZRQOl4EYsKRkIc=; b=
	A6QNstxnwhoQJcNQUzuWdPE1p5BJ2wNkdt4cH7gW+EnxxSn2v+fabG6pQE63JjXG
	2X9s9AzYd+v9tWdiK8rhSxG0KqE86FJd94bmNniIK6OXR3Cx/jYkJ1m14UftncZ/
	5LsGkmHvRXzsfgy5tI/xnRSspoBsFsN9FU7UcibK8pxkAKOgBFH73PO566TRiMg1
	uAvvR1L5tEKBk88+ADVVtppJUKfuoTEPicc6tq8G++IZtPj+7Mo2mblxRlL5Gagl
	WncwTPanywrAbWUdKiHTs7VgenyM1+jueBzdXhygOyh00FiOrMXwLfodDM+55cGP
	tPEGnLqYz+MJDvFb8ZzpgA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427hntgctp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Oct 2024 09:58:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49I7vAdZ027182;
	Fri, 18 Oct 2024 09:58:02 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2041.outbound.protection.outlook.com [104.47.55.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjj0r9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Oct 2024 09:58:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g0NFjLcr7rW5Fxhfi7UbtAselfRM3ZCm0Id3WU3qo2ZDhb+F45jFyYp2/w63KrCtzq8wr5nvx6o+l3GKJLHZSU6TlHQDQcqV3oc4Ii1sWFYrQiMGNkCH76ww8dGmn+4DH+OrlZVLWWTgkLj55OjHgz9LpRQRc3+/92rqqxp+39eenvDHzNwPOSGwNwernkOMOiKVJ0OmSHadhzsQXftSSV2i2JvkPpccR5c8Gs8kz0zaSlvCwXVnqdC2EmwfbmnaB2BY6lgjrnRqOPIwgcz5dTr27F0T3fSJCXr1DZyaHPcYyONlhWbmKUYe0EFpx/ln8mh+Llvg766itTEW9RDw5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ccqLkGICq67mCeeL6ctuya1wr3iCZRQOl4EYsKRkIc=;
 b=MbfSGr0yytoj9sFhN2XA6EOvgTKnlxxu7LdoyATUuA46tQNvm79ZTdtFxYMJCX0X/hrY2NBfwr6j89j8BJKUXVvHgJ0PeEZCtf2JTQI6K4nFwaPWDM3N5w/FQIs/wIrvP26xW+yyVLnaDeWM4lAI8BZkkD9pXpay2Jtwms4aCQA4U9zD3WbSoz7wCtLcz39OO3sH7q3yD6eXVaATU5/INwLe/CJzn4lqe7t2KDzKNwFsGiMKPWbI0OrbYqA1sn4+CQxE7HEp0f7n9tmVlOFqKsjUcdSrhYvlstbbcx+ebsisFm8hpm6R7GHFXEtmLVyjxAe9GkMq8l5gBiaZ4TLUbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ccqLkGICq67mCeeL6ctuya1wr3iCZRQOl4EYsKRkIc=;
 b=sVwQzh7yIsCR4LNeaNOHdvMFaLl2cDGCdKJPYhrdpV8Y9fhqqHEC0mU+Q00Pxsf9sMx5WrJqs90tE0dF4wuJN6+AI0o+5KP67PcGdTwHf/KJ4ZX3uZQ7Jg5Sfs/Ht81qot6K13ueh4o86JwLzsUo83VHPyxIIRt5EndtGw4slDU=
Received: from SJ0PR10MB5891.namprd10.prod.outlook.com (2603:10b6:a03:425::16)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Fri, 18 Oct
 2024 09:57:56 +0000
Received: from SJ0PR10MB5891.namprd10.prod.outlook.com
 ([fe80::6e6e:4f53:8802:73d6]) by SJ0PR10MB5891.namprd10.prod.outlook.com
 ([fe80::6e6e:4f53:8802:73d6%4]) with mapi id 15.20.8069.019; Fri, 18 Oct 2024
 09:57:56 +0000
Message-ID: <13b7b4eb-a460-4592-aec5-a2132ad60b02@oracle.com>
Date: Fri, 18 Oct 2024 10:57:50 +0100
Subject: Re: [PATCH v2] KVM: SVM: Inhibit AVIC on SNP-enabled system without
 HvInUseWrAllowed feature
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: pbonzini@redhat.com, seanjc@google.com, david.kaplan@amd.com,
        jon.grimm@amd.com, santosh.shukla@amd.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20241018085037.14131-1-suravee.suthikulpanit@amd.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20241018085037.14131-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR01CA0138.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::43) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5891:EE_|SJ0PR10MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: e4c58087-7c99-42b1-a138-08dcef5b5659
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Yi8weWovWnZPS3dVQnA2SmpTcmNRWTgyTEpoMTY3RnZnV0d5KzQyY1h6WElJ?=
 =?utf-8?B?QUI4aE00eVFnNFJsRUkwRmYzMnU4eUZBZFhjUnR4bUJDK3VtSGVGMjM2citT?=
 =?utf-8?B?MzF6Y1dxaGNnMis4OExSN1M0WWR6eVF0M2xhYnJPcXhzNWpkcjdzNW9wQ1da?=
 =?utf-8?B?ckxiZmNsRUZjYUE0d3Nrak0rTkFqSTFqTWR3a0dJZmZUZ1FLaDMza1BEeHQ1?=
 =?utf-8?B?S1ovQ1JwMnkza3FWMU83MERkK3dBOEFlRmpjUTdGcytsRHdVUkMvN3diZG9K?=
 =?utf-8?B?ZU9oS1BIcCtZY21PdmFCNklRWDFSVWhpc1hiSy9aWkJjVkExTkc2Mkt5UXBp?=
 =?utf-8?B?RnpxMkxBZ24wNm5TRzE1MkRmb1dPaUVFR0lZWVl6WWNiTWhoYU1kRWlFVS94?=
 =?utf-8?B?cFkrWVVrdEhYMG1NZXJxd0FLeHpudFVBc2pVbHluWVdFU0ZPM2hkK3k2WVJK?=
 =?utf-8?B?clBxTmpSZW5uMTZvVjNYQjgwMXNkS2pzUXpqWUpFdTJBaGM2ck5kUlBOclZE?=
 =?utf-8?B?SVo0TGNGVUwwYzVBWjRSeldzL0k1NE5mdmphOFdvQ0huc2R4Vzl3dHJ6M1kv?=
 =?utf-8?B?TXMrdzQxTVR4NVRTVmV2NHRHTjlvL2k3RW12Z1kva205ckRqSi9jdjZiWGpl?=
 =?utf-8?B?SWhWMzRNeVlEVjI2OTZ2aGt1RnlQTUc0RFVtSnNFUE55dWJEQ1NtR3JtWjZX?=
 =?utf-8?B?RXN0NW03d3hJSzBEWE5yWTFsUjFXMVJVWUNJN1Q1ekdvenpzUnBGR2FZOEZp?=
 =?utf-8?B?d3VBbzZZeG9kaEFUcFBjVVVOODNlWnBrTWdCMHZvMFB4TWpLNTM5MXlxU1Na?=
 =?utf-8?B?dXFvMTlpR2Q5RW80azVpRERMYmwzVXB4NmExNDVwUjVPNGUvSm4rUVNOVjRE?=
 =?utf-8?B?a2lQVm1mWVo2YlFCbWp2aHRXQ001K21Nek5TQWlnakNyY09VN2VlUEN4VkJ2?=
 =?utf-8?B?RWhrd2w3bTc0K0V5aEVRcXJEa1E1UTBYRnpqZ2lFaUQ0dnpiMHkzK084cjBz?=
 =?utf-8?B?aEFrQWZOWncxNThGbGl3U1dhKzVNSTNGVjVXMzlEU2FudkJuVzM3WGdRL0Ru?=
 =?utf-8?B?R3F2UEhJOWl6N2EvSGV3ZlhwdnVwK0kwR2JjVXRnTWppWHZlQ0Vad09CZGFT?=
 =?utf-8?B?cHJzZUtPZ3BoOFMxejE4UWVCK0FPQVlKeDNFTVpyUHROMVA1bDRsbGJZZGM0?=
 =?utf-8?B?d1lKU3NSdG95VzlIMTF2TkVXWTNLVmhPdEhnWThIR3dLTm53SU5yWVB3b0RP?=
 =?utf-8?B?alNCenBaY0VwZEordzRBc2JxNy9jNjEyMmpMdTBqY0VsQU44R0tuMkZYamY1?=
 =?utf-8?B?c0MrdkswbThQcWVxUEtQZERSbXVaeGlqQU9wUGZKRURaZTU3czdnQS8xL05q?=
 =?utf-8?B?UzM0bHZLQUxJSDROTVNQeU1vY3VjSGFHNXRlekhvSjNmWk5QbDNIdk4vUlpR?=
 =?utf-8?B?YVhHRElTcERoZHRiTW9sKy9UK1ZFSjZDV05OSlVBYXpyWUNIQjEyeSt5eDVu?=
 =?utf-8?B?VDlrS1VLb1J2WjZkNkhHY0pNeXdDKy9UdDlVYmdMblRaWHZHZEUrY1lYSFpp?=
 =?utf-8?B?VGZyYlFadDNvNHYvZ1VMcm1BY0ZudHFyOS9VVThRaTgwNHU0VlFrbW9NZ2RU?=
 =?utf-8?B?clBOZHEveWljN1pxeDdoSU9UL0o2QTFQK1dsMEZROHN4MVc2WG94YzdhOWtk?=
 =?utf-8?B?SVJhM0tQd0ZLY0xDOFlpTTB6US9UOS80OEd4S3BmaXUxNXFlUVFKU1dQNTVu?=
 =?utf-8?Q?tkDZHj7AxNrhxfkyLYzA2C9rjiadQYGQaDPgSHy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5891.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDBNdStZekNucnQvaDUvM1E2UFpnQjEwQXh5dS9pMVNBQmJCbmR0OEZrcWZo?=
 =?utf-8?B?Ky9Fall3ZzVzWHRsZnZqbU1nWmE2eWpqeTU4S2dMQmV2dXI5Mm5ReWdJc3lh?=
 =?utf-8?B?WHJhRW9ZeXFwZEFGSWJJa0svNTZWME92b3BSQ1FXSTRsODR2OWR0elNNRzU1?=
 =?utf-8?B?WkdSVUhRTGRpSDhIcWRUb0VoQ05LWUVtTktkdTRVa3AzaWtPK3psNktKb2lP?=
 =?utf-8?B?TE95bDBCYjBBTEFDOEhCWUFHaUV6bWYydnpnajZqRjM2ek90dFZVTGdYUWln?=
 =?utf-8?B?VjE2SGJjTVh2SUIyc2JQdDNSTjM5VTY0Q2RPdnQ0dVkxYjlCaW9iQVZDYTVz?=
 =?utf-8?B?ZHZmU1p6NXAwSEZuc0pSS2lSTjBMTWJnUisvOEtML0t6aFRJY2RiWS9IRkdk?=
 =?utf-8?B?VzhPbThNWTJRV3lFUDN1OGtVZzRXaFlOaGpJWnpsdDVZaFh0SlNKKzJKMXFD?=
 =?utf-8?B?bWVnc1NERHBiVXZwL05aSnA4WXQzNkJCU1lxZ1lWbkV0Z1JWSHMrd2RZOVNB?=
 =?utf-8?B?b2tRQjFaZU1ab3hSeGl0T3BERWVuYmV4NTh3UmcxWXRMTVZScjlOT2lWZitW?=
 =?utf-8?B?UjZkbUFZZHF3bDlpL0sxcklFc0J6YnVqbGh6cUpSZ2N3OU8wWXRZMVJyZDIr?=
 =?utf-8?B?RnI1dVFscDZFS1Y5bnpLL0hLWWdMNTM3a3JiaXZUWTJDZTBza0VMZ09SREJi?=
 =?utf-8?B?WWlTaVowWHhFZ0hEUERtc2hDR3FHN1Y2cnJ3TUdCSU5EV0JNMTlkNnFFZG5O?=
 =?utf-8?B?MEY3NzBRbklqdkVWeDBYWi9kUVBncDJuLzdrcmJKWTgybVdZY1FWc2RhNy9k?=
 =?utf-8?B?YUdIeVNRNXNjZFBVSjRBWmJ0cnUxMm9abnJzc1o2YXBuQlN1Y1hYMjZIamdl?=
 =?utf-8?B?WkUrYm5zZmFNRkNsUzI3SWVVNzk0M0JydFB4VkNkTVA1VEN3UDBROVp4TmUz?=
 =?utf-8?B?cVh0ZnRMUkp1bkdGNU5LUU1aeWpoZkUvV0JObURwMm9EelI4WGREVUpkMVJ2?=
 =?utf-8?B?RlFWYnhqeFl2YzI5ZlZlRXVjYUJ4RjhXR1NaN3RubHkxMkdYbnhIeURDdG9v?=
 =?utf-8?B?U2JEOXJWWDZqdlVGdkVDZkhoMWorK1hGVUJIaHhXNW5pOTZTTDY5NlZFOXk0?=
 =?utf-8?B?WWczVW83aFNueWIyeU81cFcyazA4T2YwcTh3SklvMGxjRGdZZ05DVVlaWEtt?=
 =?utf-8?B?bU5CN09wNWR5ek9oZmo2SDg2elpkSHRjSDRmUEdSWGV6M0dtRE1HUDVIN3Ry?=
 =?utf-8?B?WnIyaU1uaCtQdmQ4Wk9OYWhiTkJ4OUlZU3YvQk9tV3l4K1ptUEpUdExEM2xr?=
 =?utf-8?B?TlUwek9ZRUJ0bXVKOVdpOTFYRmdaR21vNDhJZkw2ditISnlpaXRpNUJFWTN6?=
 =?utf-8?B?RFdkNzZoTFovWUhEL1ZuTHBDWjROdGh6U0JhNDM5VFpPYXJmWUJPRWM4dVZw?=
 =?utf-8?B?aHFLYUV4aTVVOGpwQjM0Ym5PMStSVDBpeEVjV2I1b2ZVZThMWFVtUWpIS3pH?=
 =?utf-8?B?Sm1ldy9hM0RaVmJKRTlrblNudzFZUzNQMmhZcUhoUUQzNGV4ZUk1OXhhajEw?=
 =?utf-8?B?NTZrZ04wNStrRFJzMkNjZjdkTFNackxacWhSNmZ2Z0VXYkUxbDRTbHgvODdj?=
 =?utf-8?B?aklPR0NVaGxtRTh5UXBsMHRyc0lSaE1GeS9oYS9iMUxOeGRWOUtsUXJlYjhm?=
 =?utf-8?B?cmU3WEE5MWhNbkVnZExDMmdmSzE3cG9hZVhFVGxxS29qbCtYdnVJRkorc2Zt?=
 =?utf-8?B?ZmsxTnlXRW5lNzVGSWZibjJ6cVpBZFU0RDJsNmxkK2VyYzZBcnpidnN6a0Nv?=
 =?utf-8?B?ZWNVQnVQMHIxSzQyL2d6akZzcnZ1WGpIQmJzM2FkMGQ5Uzg5OFZWbUhmMk1G?=
 =?utf-8?B?cm1yY1VXSWdka3Y2d1FUYWJsZTJoTmRRSUhVa2Y5cFVZbDVvRXczbThUUU4y?=
 =?utf-8?B?SmZDaVo2d2oyMEdrZ2RPRUFmWUxUcWJYR0M0V3dmbVREZE5mMis5TGttTjYv?=
 =?utf-8?B?YXdGVmZzSmhRWkVPOHVxdnFDM2RpVUZnWG1PeEN6VGJxdUk0U2VkNi8wYTVu?=
 =?utf-8?B?N3VYTC9Qay9sRW9XVG5pTWdEWHViM3ZJejJSRERBVHEvZ1d3NHZxT0xGUTkr?=
 =?utf-8?B?cnRGckRMd01ZU2pTdlNqRUhzZHFxV3F6REFVZ2RVTmQwSUIzRHI1cC9xRkk4?=
 =?utf-8?B?VEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1EgsmQeTpL/lm2uQAtR+sTjtIxK8NHQ+lrsJ3Fk2Hoy/vImOQUqVH9/cb4mswU6IRlJ53HVVqDU9pCIgz4rORU/UW764U9KTyJeWgNoUV0EYbJV8ojGJXDKZPS092jqszZkNcPzfYe42eKKOwzoU5pkiJRqCZ18xZq0kTxyleVQ4trIyHIJSX9hZGBweCLDGI1opJUbOUS6VdX52nSR23vk7CEVyLTFp1kx+YWFv2ONcHgs6orHTBmwOgQHLsGnD+Rhcww2hRVugBhmvG53qjQB06Vys2ALH7VqJYtU39XAUzlGmVD3bbh737VeJSPv8qIVYo0JBq88bACQfoUATrm3Lcgxupi3XN8mvtY+DTHAa7niyeuLfZhF0NDuAzO7xgAzp0GtuORBP8UKC2ocM6+deBrhKq/twoorjPAl6CIk32ii3QrAM+FBhWSQxawNELe1hdnAZPVJ4ZiNq55CwREXR7FEAGvOov5sroQlMaq4tx928raNkaauSlCTt2b+UMIsTAlYMLSa0AmDpsGF+/sFFSA8OVwPUNh14rJDnUSOIfvKVLWHFwKE9BRIblFynNeFYt/gvEGrMXrZDZ2n2G55WmSIGo+yMD6tJ5t1bc/U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c58087-7c99-42b1-a138-08dcef5b5659
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 09:57:56.0746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZTeEf79+5Akwpbvr6A0hN39OSS7ogerRIDIAa6wdvyKr8fKwm6P2eUagOy1qDJWPgtO0K6tSxZKmhSaOs/9K3wGbDzPw67sDrWybFbEojE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-18_05,2024-10-17_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=729 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410180063
X-Proofpoint-ORIG-GUID: SLxd437AzGm0VA9KlQrdNApwDDfU6nyf
X-Proofpoint-GUID: SLxd437AzGm0VA9KlQrdNApwDDfU6nyf

On 18/10/2024 09:50, Suravee Suthikulpanit wrote:
> On SNP-enabled system, VMRUN marks AVIC Backing Page as in-use while
> the guest is running for both secure and non-secure guest. Any hypervisor
> write to the in-use vCPU's AVIC backing page (e.g. to inject an interrupt)
> will generate unexpected #PF in the host.
> 
> Currently, attempt to run AVIC guest would result in the following error:
> 
>     BUG: unable to handle page fault for address: ff3a442e549cc270
>     #PF: supervisor write access in kernel mode
>     #PF: error_code(0x80000003) - RMP violation
>     PGD b6ee01067 P4D b6ee02067 PUD 10096d063 PMD 11c540063 PTE 80000001149cc163
>     SEV-SNP: PFN 0x1149cc unassigned, dumping non-zero entries in 2M PFN region: [0x114800 - 0x114a00]
>     ...
> 
> Newer AMD system is enhanced to allow hypervisor to modify the backing page
> for non-secure guest on SNP-enabled system. This enhancement is available
> when the CPUID Fn8000_001F_EAX bit 30 is set (HvInUseWrAllowed).
> 
> This table describes AVIC support matrix w.r.t. SNP enablement:
> 
>                | Non-SNP system |     SNP system
> -----------------------------------------------------
>  Non-SNP guest |  AVIC Activate | AVIC Activate iff
>                |                | HvInuseWrAllowed=1
> -----------------------------------------------------
>      SNP guest |      N/A       |    Secure AVIC
>                |                |    x2APIC only
> 
> Introduce APICV_INHIBIT_REASON_HVINUSEWR_NOT_ALLOWED to deactivate AVIC
> when the feature is not available on SNP-enabled system.
> 
I misread your first sentence in v1 wrt to non-secure guests -- but it's a lot
more obvious now. If this was sort of a dynamic condition at runtime (like the
other inhibits triggered by guest behavior or something that can change at
runtime post-boot, or modparam) then the inhibit system would be best acquainted
for preventing enabling AVIC on a per-vm basis. But it appears this is
global-defined-at-boot that blocks any non-secure guest from using AVIC if we
boot as an SNP-enabled host i.e. based on testing BSP-defined feature bits solely.

Your original proposal perhaps is better where you disable AVIC globally in
avic_hardware_setup(). Apologies for (mistankenly) misleading you and wasting
your time :/

> See the AMD64 Architecture Programmer’s Manual (APM) Volume 2 for detail.
> (https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/
> programmer-references/40332.pdf)
> 
> Fixes: 216d106c7ff7 ("x86/sev: Add SEV-SNP host initialization support")
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
> 
> Change log v2:
>  * Use APICv inhibit bit instead of disabling AVIC in driver.
> 
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/include/asm/kvm_host.h    | 9 ++++++++-
>  arch/x86/kvm/svm/avic.c            | 6 ++++++
>  arch/x86/kvm/svm/svm.h             | 3 ++-
>  4 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index dd4682857c12..921b6de80e24 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -448,6 +448,7 @@
>  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* AMD hardware-enforced cache coherency */
>  #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" AMD SEV-ES full debug state swap support */
>  #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
> +#define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Write to in-use hypervisor-owned pages allowed */
>  
>  /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
>  #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4a68cb3eba78..1fef50025512 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1276,6 +1276,12 @@ enum kvm_apicv_inhibit {
>  	 */
>  	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
>  
> +	/*
> +	 * Non-SNP guest cannot activate AVIC on SNP-enabled system w/o
> +	 * CPUID HvInUseWrAllowed feature.
> +	 */
> +	APICV_INHIBIT_REASON_HVINUSEWR_NOT_ALLOWED,
> +
>  	NR_APICV_INHIBIT_REASONS,
>  };
>  
> @@ -1294,7 +1300,8 @@ enum kvm_apicv_inhibit {
>  	__APICV_INHIBIT_REASON(IRQWIN),			\
>  	__APICV_INHIBIT_REASON(PIT_REINJ),		\
>  	__APICV_INHIBIT_REASON(SEV),			\
> -	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
> +	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED),	\
> +	__APICV_INHIBIT_REASON(HVINUSEWR_NOT_ALLOWED)
>  
>  struct kvm_arch {
>  	unsigned long n_used_mmu_pages;
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 4b74ea91f4e6..cc4f0c00334a 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -202,6 +202,12 @@ int avic_vm_init(struct kvm *kvm)
>  	if (!enable_apicv)
>  		return 0;
>  
> +	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
> +	    !boot_cpu_has(X86_FEATURE_HV_INUSE_WR_ALLOWED)) {
> +		pr_debug("APICv Inhibit due to Missing HvInUseWrAllowed.\n");
> +		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_HVINUSEWR_NOT_ALLOWED);
> +	}
> +
>  	/* Allocating physical APIC ID table (4KB) */
>  	p_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>  	if (!p_page)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 76107c7d0595..13046bad2d6e 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -682,7 +682,8 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
>  	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
>  	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
>  	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |	\
> -	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED)	\
> +	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED) |	\
> +	BIT(APICV_INHIBIT_REASON_HVINUSEWR_NOT_ALLOWED)	\
>  )
>  
>  bool avic_hardware_setup(void);



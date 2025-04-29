Return-Path: <kvm+bounces-44773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69E06AA0D40
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:16:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88F953B890E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5F72D0261;
	Tue, 29 Apr 2025 13:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BErzPgho";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wcc8Czg/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1567320E023;
	Tue, 29 Apr 2025 13:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745932604; cv=fail; b=VApW0Zc6xwQG1UNG0dw9g3K4Jnb5iq5LIVATVa2mpIjaSjt5W8xVStbV8S7YYULPyWRpZ1WM9aXaPN+db1DYSuKDzemBS3Jaj/cilY16qYuPeTAG4s8L7CTrZxEskCB2jtVsaKqQq+FrGmhXc1C4ZTkvh12fAH6Oc2+eoyoGewY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745932604; c=relaxed/simple;
	bh=nr5Ho9bJp6ZPDHAZY4lvMLMkYlOP8OxF1K42u4/J3A0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lFvaMKRE9D1MHGIiXFLV1yLrsRKx+N3P6Vf1O6h6Q1YgZpH6Btor9rt5Pu9tlRLUnJz/N0M09n2gxHFB7TvbFlWMGJyW2A61hD3gmQkA46AOITfkrKSosiDGR337AsGTDVfELrLiihsvSv0+nrS9b9ivSEVLVIwH7U9FoH7OVpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BErzPgho; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wcc8Czg/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53TCpt0f006708;
	Tue, 29 Apr 2025 13:16:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=V0PJb81g1M4S3M4OXmR1QWFKXPcNChq1cYLd8YKFFaU=; b=
	BErzPghoCXnd/FsBOzW7f2NlxrsOE8lRCriRwFp41uLFDFkTXlnT1zmixpkXFobK
	vLgut1I+b7I4zXQOOkULq3lbpAtLu/8oYhL15JsXbrmf9scCT8Jvt/0Ga5qT1Zrh
	EKPCpIUEwbzUndJ/NTc7pRjQlhmcKKJVa355YL+4JJu8PjfHCvPvcm80gFYaac9k
	vW1hhvFHXyRmwka7EfnvyNRI7v//2Ps1qxjbqthBnwUBmBRqmQ0fYNNODk4/GZU0
	y5ALtiNMcQc3gP7134uhtIdsnSta4dzS4O/SDF0CRSJu13ICi0JR61dhAaINk/1u
	54Vgmd9yLbyIpc92Ktmg7w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46ay5781t0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 13:16:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53TC4GLo013878;
	Tue, 29 Apr 2025 13:16:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2042.outbound.protection.outlook.com [104.47.58.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 468nx9umsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 13:16:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UDURz07lggHn3yGhlpVtmVlgXfSuUoLyTYOC7FI5PVeHds7yEqgA2/wIITv0LuL/Vw71cM5Q3+41Xq5lk7X1odPGjmRfazUBDoz7QXm90ekWm8CvdIIbsPYNSBn8l7elziAaEF/AvaExziO1dJDmVt3ByIrIKpa/Fdvbi6VHTj0HcbgVKBAdFDM0zuD5LLtmlfREJ9xU6s4AdBntNOF7KiA3wYrjpi64iq7bR3JLur88aF92ApMqF9iXYI5wWv/jLxZO6SbRaXWztwBpurVvAm3FB33HKnUjDmDbaSbEjtyvEWZIDApcp6MbajUFC2L6glLmNvWtn5HOogHzZUYKXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0PJb81g1M4S3M4OXmR1QWFKXPcNChq1cYLd8YKFFaU=;
 b=P42Ybed+XmIvxJLlYqT9LPSdVLoLq9YoJDtT0IMeo892BR5mHOD2UhF2z7rC1Yscrng0WMJZxq2Vp8o1EF1PPd4q1CfcYRYe1wS5bYTAyz0xFtTu48HYNsmqvsvUfuYwGM1JCDuaeKvB4TxaZTqRyCubWmq7fw1jZOvwaoxXzp7b4YR0tb+PKLR6QeAGKx5cCu7ojK4mOOycoI8JrbucLy5ppymZ1N5RxIXag4lOgeWRGvjF4FIftY9ZN+eNSUhFxpMrVcrQtkjAxTh2CA7EKOqrR4ufD+TVivyqLKlr9wFe6T40bfkstEtts0V8FhMdi8+0ltf4JO7yQZdM1rsPdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0PJb81g1M4S3M4OXmR1QWFKXPcNChq1cYLd8YKFFaU=;
 b=wcc8Czg/eoyO3W9uM18eUM3k382yGpVsBeJOuqzK5SybUMvgZSajngjsDjIbCaRV+vGOOwDfc1EKJnqpFKOLdQgNuzqfZROyxUhmPQfsycG0/3y2iEJsPYhBvv0d6nxv5kkoDDVt6lfbJFdz5F7eyjdpSVQGfwOX8d46loEkiyE=
Received: from BN0PR10MB5031.namprd10.prod.outlook.com (2603:10b6:408:117::6)
 by MW5PR10MB5849.namprd10.prod.outlook.com (2603:10b6:303:191::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Tue, 29 Apr
 2025 13:16:26 +0000
Received: from BN0PR10MB5031.namprd10.prod.outlook.com
 ([fe80::3ef4:e022:4513:751a]) by BN0PR10MB5031.namprd10.prod.outlook.com
 ([fe80::3ef4:e022:4513:751a%7]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 13:16:26 +0000
Message-ID: <f468ee90-2c10-49a8-b320-5fcdd764a5ca@oracle.com>
Date: Tue, 29 Apr 2025 14:16:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] KVM: SEV: Add KVM_SEV_SNP_ENABLE_REQ_CERTS command
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, jroedel@suse.de,
        thomas.lendacky@amd.com, dionnaglaze@google.com, huibo.wang@amd.com
References: <20250428195113.392303-1-michael.roth@amd.com>
 <20250428195113.392303-3-michael.roth@amd.com>
Content-Language: en-GB
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20250428195113.392303-3-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P123CA0005.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::17) To BN0PR10MB5031.namprd10.prod.outlook.com
 (2603:10b6:408:117::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5031:EE_|MW5PR10MB5849:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e294978-e5e4-4875-4739-08dd87200be1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vlcza096bUxyMTRXcXZPRUduaVdTalp2L0pPdHdrNHlhelJGUWE0UythMnY4?=
 =?utf-8?B?dFNCSzlBbkRodGs5SE5QWFVIcEQ5UEZKcU5OZ2FvT0VWanZybGFObG8xYVdX?=
 =?utf-8?B?NVMvUWtncmo0T1ZoR3lLc1VaUWpFSzBqRHBSTktNaHVlbzAxN3pqWk1TOTUv?=
 =?utf-8?B?Ty9zL3FvNXpkaU9sTi9yVjYxU3NGVW83U2UrVzBNdStlWVlwRVdCdGw5Unlo?=
 =?utf-8?B?S21aTEpuZnp1VFZTZWJONjFKaDcySWl0M01WTW9rRWQ3NUp5d2JXMXlCQldL?=
 =?utf-8?B?ck9yTUVjZzFYRDhibXA2YmxNUVlHc0dWdnl0M0FFSnY1dXZ2VmxwSVF1dkVx?=
 =?utf-8?B?VWtNTVg2bkVsbm8zcUE5dnpuQVdjNDRJdGZ5a29mbGl2U0c2NitBQWxoMkRN?=
 =?utf-8?B?VE5rS0RwZ1AwWTIrMXVzMXNjTGhjVDRrT2M5aDd2RDJGQktxcnZwSUttRWpF?=
 =?utf-8?B?T0plSFF5UlVXaVlLOXVWK0NLMVJOR2hqMkUzb0ZhOTk0ZVN1bjF2RUs2RGV0?=
 =?utf-8?B?UWlwVkMxM2hQSnZmS3BneDlPWkV3NStKRi9leEU1VmVQNmREbDM3UlpjQVk3?=
 =?utf-8?B?UTlFWkZCSGlIdmhuUEV1cDhaZVdtbVNXOUl6RVBpMEdvT0d5U0U4cGtJVVVn?=
 =?utf-8?B?Yk4yV044WUt2M3RaNTdXZjJScHFwUU1nTTAwb3hndDNKc3IxUXRMYTBNcU4w?=
 =?utf-8?B?Y1puYWNoQkZscW11NmlBZG44aHZyd0Z1V0Y2K0duYUlxd0VKOHFlQm1Sckx3?=
 =?utf-8?B?R3FrM0hRcGpaUjF3TWw0Y1dVNkhPdTV2NzJpQjFTOWJad0ZmbXd0TENLMmZR?=
 =?utf-8?B?azNIU29KOUxVYXhqZzQzQjY0c0ovbVJTUU81Y1ErdFQ1UmcwV1RMcjZ5aTBF?=
 =?utf-8?B?cndFems4RzQxNVRMQzVqVEtqaXM3aVhlSHBqQnZpQlpuTWliZkNxNzd4dGlB?=
 =?utf-8?B?RWtaTWRTcjZpY3NtMzlOQi83SnRkUjB0R1Nvc09kYy9pbnVTSzM3ZUo2dHFT?=
 =?utf-8?B?bm9yYjUzaEw0RldtSGp4WnZGWDZlbWRRbHRtdS9Bb1JiU1pmR0FXVnEreUFV?=
 =?utf-8?B?TWRUS05CRVh0V1hpcEFhalNsTERDdEZCOGw5L1Z3aGJRM1JCTXRoMDVGSG9s?=
 =?utf-8?B?UXZ1K0ZhKzVHOEJIR3VUMjUyUE9teFhNZDlRcUgvekU3bmdnU3o3cm5XbEp0?=
 =?utf-8?B?YnJKZDJRQ2dYczN1S1RVcUU4ZEh0ZUZZSkZSQnlBeUhWWmNDYTNReTh1UEta?=
 =?utf-8?B?clc1aGZQRXJBMy9KMEZUcnhyOHN4K3hzY09VT2JCZ0wvY1VJTkZNWjdaSzNp?=
 =?utf-8?B?cklrUWdMbVRiUDdYVnhjNWdrREVpR1hlZzdSYU1LYytmUFdPbmpkQmJPL2Iy?=
 =?utf-8?B?RTR2b2QzUFlaUWhSVjBza0JaU3dWRVVITVhHQ1RkN0hGL3pFWS9Yd1NhYzB0?=
 =?utf-8?B?UXFVbFVHOVd5U0ZDdEt6QjdYSUdqQThhcUMyMEY3WWRiOHRLb053QWdvSnJl?=
 =?utf-8?B?ZmhHYWthK2UyazJDc0VsYVRMVndldGUzTXQ1MkVJWERlMkpKdUJlcW42R2pP?=
 =?utf-8?B?WmlkQ1g4MTh2d2l0eGJGYTdBNGpOZU1xTzhYV1B4OWNlcFN3RzhCOHJ3QnJV?=
 =?utf-8?B?RXVETnlUVDVFZ2NTQTdSTlFFdXR1aGRGb0RYQ1ZORVBwS1BXK2E4MFBRVDh0?=
 =?utf-8?B?QzZMNkl5YmtqUkpPdWNIYWRUM3lwcWQ5YTF3LzA5T3dZYThML01FN3lBRG15?=
 =?utf-8?B?YXlBZWprSnR1OEZLOGdlcHg3ZXRJS0lMcmludGxxQWYzNGJTMUtrc29RTkJn?=
 =?utf-8?B?ZVVBd1FFK2NlQ3NCTmNtVmlYL3BQdTR3OXlFZkhBb2gzNlZZeTh1SWJHMFFP?=
 =?utf-8?B?dG1TTDJQeGNlTmRZdmFKTXNXak9FaTd4YXBFQTBUeDBvVGNQZkNWVDBsYTla?=
 =?utf-8?Q?Dkb7l2EoX4o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5031.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dE14Y2lOZEpvQUNKampCTyt0cm9zeFd1azJBZVVRc1pFblhRUEo1Vk9OMy8w?=
 =?utf-8?B?WXpYdytZV0xUdzlja1U1UkdZWlE5cWJPaDlsOXVuMGtmVHJqdDJGTlhHZEF0?=
 =?utf-8?B?RmxGUTJ1akhoay93MS9tVVhDVVdwYmtLZFpvaWVYMnFMRStUVSsvMEpQNjdk?=
 =?utf-8?B?c3BnUVN4R0tqVXhlWkFOR0FwSWU5RE5Nd2lIQmhucUUvWTlHNjV1ckNXbTRB?=
 =?utf-8?B?VGhuYy9ncjI1aCtMYWV3MlV2dzRzNU1RN1J3VjhNQ3JBWVFaVUZrVUVLbzEx?=
 =?utf-8?B?NHJ4YXBuMlRuUW9vSUVVVVBOQURZcU5qTUZXVU5vcmlTeW05VlJwNXZyMkoy?=
 =?utf-8?B?V25aZEt4MEFSU2V6S0lFbnJCWXN5M1diNGVGNndHU2lHSmlyZUZrckl0bTJl?=
 =?utf-8?B?dXc3dHZCYk50aWdDN3A1bStYUHVVRmxoa3lwRmx3eFFZTDg2QUNWL0FRRk1Z?=
 =?utf-8?B?K2NHTU5pS1pxRVRnMDNOaDY2anhRNUlWakQ5WTJmY2dtbHh6NDAyaFVBK1Yr?=
 =?utf-8?B?TmNjaGY5SmxHRU92bTdCaWFCeStpUTlzbkF4Z1lJWU1IdXUxSlpoZEVjeHdt?=
 =?utf-8?B?cFpzSXhiZERidnVLVWVHMlVxM0VXUGN4ZE1wRkNBRVRBWlFReWV3T3lHSU5J?=
 =?utf-8?B?ZlJiL3grcUN1aFA2SllON3liMmtyS0VHamNpN1pOdmgxaEpaTnNYcjZyQnJ6?=
 =?utf-8?B?UGJ3ekJjWUR5cktVa3RtdnRJWG1ua1AyT2hqWHdvTHZOcjNsUDU2WE5nZlR1?=
 =?utf-8?B?b2VoQTN2QUJtOHNkL0tzbDVVOUlRdFpCOWdGaWNIdFFFRzBJa3FLTHVnWjVZ?=
 =?utf-8?B?Tld1amRyZlNOcUd3K2J3dmFtZnc0Qkg0YXBiQXlNTklvU0E4MlJLRGdiaHMz?=
 =?utf-8?B?bzJwQTNGdWZqMDgzMlV3SFBkM0xlR3hOdCtIU3B2a3NSQ2NGVytpUTFmc2c1?=
 =?utf-8?B?dStWRW1oZXRYK1lMTkx4NVVFbWx2TnZrNjhPYWRpWkdTVlBrSG15em9SeTJh?=
 =?utf-8?B?ZmpiZFB5ckdoUjVyakRXNDdjeFdwQ2tqRzRpa2NwWll4MG9JV1FmZmpLanBH?=
 =?utf-8?B?YndFOHZtUVBmS0F0SnZBUFdBVWk2ZmY3bmFCQkJmQm9pSzJhaXhSSXpFc1Fv?=
 =?utf-8?B?by9HN2V0Ukl6dUk2M3lVV2VMdGVUMEZlcUdDOFUzNGxKL25nSkV5N2loV2kz?=
 =?utf-8?B?bURadGwxNC9ab0FhalVGekNmQUZNRm1PakxIaWxXM1JEZlRaVFhzZzdWV056?=
 =?utf-8?B?YlN5UUwwTVdzUnZuM2loNFp0eElXOGxydE85WUhWT1VsRms1NjFjaXBsYlBB?=
 =?utf-8?B?S05OMzY1QVE2MXdrbkRLMTVtejlzbDVBQ3czWFFCUWZUMWJReGpIM0d5V3pO?=
 =?utf-8?B?TjMwa1FyZEtGbFZEZ3pBazEwSENpMTk3alh1angvUmV1WHFLV0JYN2lxTmIx?=
 =?utf-8?B?dzM2VmJ3SHduMGNJbGFrQ1RIWkxRYUxNbVM2eHhZVVFTU3lFMWFnMGN5YlNJ?=
 =?utf-8?B?ZG54LzBsWmlxM0pXbTdtZ2s0c0JuMThmU2xXNmRXWExETHVRdTdzQ3VQSWhs?=
 =?utf-8?B?cHUxNWwzQ1d2M2Z3aTV5ZVhXei9KV1c5aDhQTFBIT0NZMkhoSmhmN2xTSk5v?=
 =?utf-8?B?b1pWaWpXdUl2LzRGTFVzSmFqYy8yV25sWE5yY2lRNDNIendwNGs2Zm1ZSkhr?=
 =?utf-8?B?dkxIU0d2akFFSWs5K29HZm0wVFJ4dHNrM1Q3ci9UTG5IdTAycDJmS0pmc3ZJ?=
 =?utf-8?B?UmlqY1ZsUDRxSGlKaUY5WHNxcHdUVi9TejUrNmZ5M2JoOXIwV3lXaFR1UUNJ?=
 =?utf-8?B?WTc3NUZlUVVWekNCVHV3SkRHWnE5aWNaVmw4S1RkZWxOOFF3WTlBRk5Oc0tV?=
 =?utf-8?B?RHZuMGhsR0hxUERWcGwwQlJMc2M5RTczNVVGdHdtNW54R0Q1cXlnR0h2TCtR?=
 =?utf-8?B?Rm5qbHRWMUNCTktXVXF4ZzdkU2NsUUVwS05TeTlRUGtDWjlHSjBRNFR5Wk94?=
 =?utf-8?B?eXIwSVpNYkxXTnJuZWY1TDgwTjdYem50SjlPWE5nc3lZcGNGZUVSRjFCeHIz?=
 =?utf-8?B?c2tPYWdsUUxWRFZEa3gybTJ0Sk5tM1ZHR1Qrb285cW01NlFpbzZtVURlV054?=
 =?utf-8?Q?bVrbbbtQ7P4+ISXkEzlP4MI18?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	32s9EecStNvarQG8pcXF6FyC8ilBO8Ts8B5prBsaRL4tNgqYZtlGRSLl9yBIARHScdzmG9uN3ZAQ3AqfJJvqRnIhx9nbnYct0lDgagqvOYNNhgeLAzZUno+gxQ6GEc7ANu67I7dbKrABT2pP2fRKu5tD46IKRg+U4oXywmZG88eIAyAluEbLXrTUgiHbt2jeLctirXGGB+zni/b8+nPBPm/tUdve9bi7f1BkLNgJedCkT758i/iltIsLDtDXpjDeJr5AbSPcqYBhlr3vFN/crSUwiM00r8MO3MkaX+mBZSuvVfS+dOSbEoK8c9JJwUeMOejclaio2hWZVtVGOiBxzHGa/WlPmcnmHWj8TYPOviiD2Mth84oDT/1CurbPZEuZVmF+Li5ts3AdPv9rk6vCDV3GbOwTATUFuNQ9asZ2CqWlVKNQe5VLQfnxdj8D7fIlkppE9VUH8BR3iS0bO7OHgPti6dMbt33Av4ebNi3AZA+rfo+bBEufw2w9plhlpGjipgDoOL4y/iH7C63DZclV2Tn9fJA8p6c6NgBIDjRSQGYXhpHKIlprI90KMqGFxqAwG6Ixa89SA0ZJsg1d0wm/J1wm2Y8dYtCsSYx2KxeAFuw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e294978-e5e4-4875-4739-08dd87200be1
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5031.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 13:16:26.6675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qgp6lcWvGh8LtBDJPzADXbwWLZvI4hM3Sf9xSK/fkSOIzripLwp5nXkDfPbeE0tn+Jkdl+s7HwLh+WHIRz9T2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_04,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504290099
X-Authority-Analysis: v=2.4 cv=J6Gq7BnS c=1 sm=1 tr=0 ts=6810d12f b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=zd2uoN0lAAAA:8 a=yPCof4ZbAAAA:8 a=cuXBgZocUHCnJTRYo-wA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDA5OSBTYWx0ZWRfXxhUX1xCLR/kg sfTd5myL9/5GbcwIYn8p2BfTaDvK9lkcPvFYqyWY2WH3sS+YPrF9MCzceOOSMjTtme4TdjENjwP uuayxWjZF3ycQEu+dw9hQ0ZU1L1pnYNXEluaqCOpbTzecE6HuFEMIiTp2zDs+4gEZ4iS3PKq27H
 4gl6DFaDIWWSurlqa4gB+dzPk73Z18rmxaTHxRfw6mjTAaWgeiibw9bFcKJd1cE1QLDTj6OKaFl kGaNNImQJ0E0m203ttc+UtXFSOKyvfsW0pYaQJahF3Otivl2qJ4Id58nCr54hVoX/UQjtPPH/kR pV/GTaPL7lzSC62NP+Z6Xz160oZqvJhi35/JrkSPZzUiOxk8qrb78gwvogf3LA6f289dQUA8PzQ pkGvLggv
X-Proofpoint-GUID: f1eRvkh48fSDArVQjcaq0cXeQ51AuV6R
X-Proofpoint-ORIG-GUID: f1eRvkh48fSDArVQjcaq0cXeQ51AuV6R



On 28/04/2025 20:51, Michael Roth wrote:
> Introduce a new command for KVM_MEMORY_ENCRYPT_OP ioctl that can be used
> to enable fetching of endorsement key certificates from userspace via
> the new KVM_EXIT_SNP_REQ_CERTS exit type. Also introduce a new
> KVM_X86_SEV_SNP_REQ_CERTS KVM device attribute so that userspace can
> query whether the kernel supports the new command/exit.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   .../virt/kvm/x86/amd-memory-encryption.rst      | 17 ++++++++++++++++-
>   arch/x86/include/uapi/asm/kvm.h                 |  2 ++
>   arch/x86/kvm/svm/sev.c                          | 17 ++++++++++++++++-
>   3 files changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 1ddb6a86ce7f..cd680f129431 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -572,6 +572,17 @@ Returns: 0 on success, -negative on error
>   See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
>   details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
>   
> +21. KVM_SEV_SNP_ENABLE_REQ_CERTS
> +--------------------------------
> +
> +The KVM_SEV_SNP_ENABLE_REQ_CERTS command will configure KVM to exit to
> +userspace with a ``KVM_EXIT_SNP_REQ_CERTS`` exit type as part of handling
> +a guest attestation report, which will to allow userspace to provide a
> +certificate corresponding to the endorsement key used by firmware to sign
> +that attestation report.
> +
> +Returns: 0 on success, -negative on error
> +
>   Device attribute API
>   ====================
>   
> @@ -579,11 +590,15 @@ Attributes of the SEV implementation can be retrieved through the
>   ``KVM_HAS_DEVICE_ATTR`` and ``KVM_GET_DEVICE_ATTR`` ioctls on the ``/dev/kvm``
>   device node, using group ``KVM_X86_GRP_SEV``.
>   
> -Currently only one attribute is implemented:
> +The following attributes are currently implemented:
>   
>   * ``KVM_X86_SEV_VMSA_FEATURES``: return the set of all bits that
>     are accepted in the ``vmsa_features`` of ``KVM_SEV_INIT2``.
>   
> +* ``KVM_X86_SEV_SNP_REQ_CERTS``: return a value of 1 if the kernel supports the
> +  ``KVM_EXIT_SNP_REQ_CERTS`` exit, which allows for fetching endorsement key
> +  certificates from userspace for each SNP attestation request the guest issues.
> +
>   Firmware Management
>   ===================
>   
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 225a12e0d5d6..24045279dbea 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -468,6 +468,7 @@ struct kvm_sync_regs {
>   /* vendor-specific groups and attributes for system fd */
>   #define KVM_X86_GRP_SEV			1
>   #  define KVM_X86_SEV_VMSA_FEATURES	0
> +#  define KVM_X86_SEV_SNP_REQ_CERTS	1
>   
>   struct kvm_vmx_nested_state_data {
>   	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
> @@ -708,6 +709,7 @@ enum sev_cmd_id {
>   	KVM_SEV_SNP_LAUNCH_START = 100,
>   	KVM_SEV_SNP_LAUNCH_UPDATE,
>   	KVM_SEV_SNP_LAUNCH_FINISH,
> +	KVM_SEV_SNP_ENABLE_REQ_CERTS,
>   
>   	KVM_SEV_NR_MAX,
>   };
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b74e2be2cbaf..d5b4f308ab3a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2123,7 +2123,9 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
>   	case KVM_X86_SEV_VMSA_FEATURES:
>   		*val = sev_supported_vmsa_features;
>   		return 0;
> -
> +	case KVM_X86_SEV_SNP_REQ_CERTS:
> +		*val = sev_snp_enabled ? 1 : 0;
> +		return 0;
>   	default:
>   		return -ENXIO;
>   	}
> @@ -2535,6 +2537,16 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	return ret;
>   }
>   
> +static int snp_enable_certs(struct kvm *kvm)
> +{
> +	if (kvm->created_vcpus || !sev_snp_guest(kvm))
> +		return -EINVAL;
> +
> +	to_kvm_sev_info(kvm)->snp_certs_enabled = true;
> +
> +	return 0;
> +}
> +
>   int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -2640,6 +2652,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   	case KVM_SEV_SNP_LAUNCH_FINISH:
>   		r = snp_launch_finish(kvm, &sev_cmd);
>   		break;
> +	case KVM_SEV_SNP_ENABLE_REQ_CERTS:
> +		r = snp_enable_certs(kvm);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;



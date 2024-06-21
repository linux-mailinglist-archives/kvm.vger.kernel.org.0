Return-Path: <kvm+bounces-20295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 667E5912BAF
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 18:45:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CF6328B895
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 16:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB19E7E0F2;
	Fri, 21 Jun 2024 16:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AdYz+cjL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Lwa/CW5b"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5332050A80;
	Fri, 21 Jun 2024 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718988323; cv=fail; b=noP1myv79mtRrYkPOY+8ixzbYR8nCMoUjsxvtx9U0bqCaLJN41k9XYWmyGi5R8l5Pb2yEmNoYN/pn14xN0Nar82UdxyffB2+GUHEcQxGBEh7ISIc05JxqfUDnYCCmun6B/CzvEHcCkfFA+TsjD+cNmFvVozJ5hVdGpIhgviQuVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718988323; c=relaxed/simple;
	bh=akJjbncXtPQzols3UxLvTUwk3wIfx1wTs457a1F0Z7o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NjpzFVW8iUWTbmBkyvowEP/wc1cdLsdHZPA14cWaLucb5FMWJkLeEq40HqIkoP/K0IyNB6GQqhtaho9qeRdI7rBFiEHnQgp5ZntWBo9qnb6Lom1Klce7SxVyMhAbMWo/U9XPXuYuFqeTF+g8W96lyqGnDz5WeMIhKNMOtPeOUZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AdYz+cjL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Lwa/CW5b; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45LEY1Wf005853;
	Fri, 21 Jun 2024 16:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=hwoNKR+SAQqwLBc4Ub50xc5fC74czfrZNd5o/iOyl
	A0=; b=AdYz+cjLht+0xKKDiIcs5WBMtJh3QnWS8EhiG78kvD9TjM0SzCFopRT/y
	L1BcT+l59IzmckyT53oKakfUNzFAq/x0/mxPuXyq/PGIkHlzNNFZ1820gt9vZ04H
	UJYGXShj5Lw+ig0OJgDj14Z1YPL8rrCSVP/OtMXJtqSMKqDFVcvy1FevCmvTwwll
	dQoRXsMNH9SQGQao6x4xYt/xRHpz3XjBwivXVwMtF2/ua9cY3kWX6hJtY92HAMaU
	PSLkSyzqny+Aorq03wIMd7DCjF4d90XoaccSArDbqiUxktGhHDGUUHtHLyWvTz53
	/18qt0hC+CBwaB8MnTV84UAOWmpcQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yvrkj251u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 16:45:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45LF1nDl019578;
	Fri, 21 Jun 2024 16:45:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2048.outbound.protection.outlook.com [104.47.70.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yvrnajygt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 16:45:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brNRCT+rHTE76+cWBR4zf9zlSfBjgLnxdIrmtmMzYZN8TZVgIcNpvSFWUG9kOnE8tK+xm9Bs2Az0YW1lms9RHBPhsz7lPQmtUHaqeo/8d4hh1aJGFYNU+oKqjfIUq6JhC4uA+E3YFd6Av39uYFoXVl7Xu33aAmnd0e2tnBnLTfifG2UnObUkh2/VI+TRQ8iFFV2u9b7d0LJIrDoc021dwjdHqxDSKbMWioSsNi1BDknjfJEtAleo/WxAutH2ZH5h6ZWIDbWkd4miSfcJBoN/wzIei/s24L7FvUTbI9Dm2cW1BJoIM7XhRg4/lPUOKMTbsIjp2hfpRfwVOktAwoYbtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hwoNKR+SAQqwLBc4Ub50xc5fC74czfrZNd5o/iOylA0=;
 b=iRs72RSYKu1F/WoplVtXDQFG0kcxwevrZyTSPtzt6C2akUzJveN1roLJQGcrO8g90FDJXzJXiE1XMGQP1gTpm9EWttvMkv5iIZqWknsYLUm+a7fQEPKnDC9s0YDGnV0oq70LSSfhQntwpp0r9cZq5shtyOAzzgqGTpit3Gys9e6xAcTY07F/fTJSvSft4DHUBEURebljpCNQYAEhgrZtRM3T/quhZBREZ6l4DgenlJ+0/baQEjbp+DWwGgbgO6gGnHQORmWVZI4Ha5AXO8ZbR01WSRry0SUmYYeksFITvS1aOQ6rWDb3MPJTg0mZbk/f8hUFBraFN9/0zFYA8E6CVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwoNKR+SAQqwLBc4Ub50xc5fC74czfrZNd5o/iOylA0=;
 b=Lwa/CW5boYiOf8YaVWuYvYDDxUvrj8tqtTotDPGJyxsi53lu+9b7a0z++Hn+1bD08PnalUPrZDUvteFt8j0Ef0QhON1MAiRQXp1oRWzB/Dhcav8J9OEiX1J0naez/R8567HiK+mgDhai8EPfPJChZigPdCExJIjn5CU8M6UBY30=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by SJ2PR10MB7059.namprd10.prod.outlook.com (2603:10b6:a03:4d2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Fri, 21 Jun
 2024 16:45:01 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%4]) with mapi id 15.20.7698.020; Fri, 21 Jun 2024
 16:45:01 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: Michael Roth <michael.roth@amd.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
        Liam Merwick
	<liam.merwick@oracle.com>
Subject: Re: [PATCH v1 3/5] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
Thread-Topic: [PATCH v1 3/5] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
Thread-Index: AQHaw+Esr9vyUgE2IEyJfUjCa7ryVbHSfVeA
Date: Fri, 21 Jun 2024 16:45:01 +0000
Message-ID: <15731bec-d137-4671-a580-c662fbef9c47@oracle.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-4-michael.roth@amd.com>
In-Reply-To: <20240621134041.3170480-4-michael.roth@amd.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-imapappendstamp: BN0PR10MB5030.namprd10.prod.outlook.com
 (15.20.7698.013)
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5030:EE_|SJ2PR10MB7059:EE_
x-ms-office365-filtering-correlation-id: b5ff01a2-08cb-40fe-5bb8-08dc92117e5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230037|376011|366013|7416011|1800799021|38070700015;
x-microsoft-antispam-message-info: 
 =?iso-8859-1?Q?1W1sctlwepOpbDSjwX6Bp6JAzmxbHLeCDYIlVkrrMnmtlt51EvsEMPbfFa?=
 =?iso-8859-1?Q?7Jaxb22QqGj+x52gMARbOMwF9I1rMjaSZ3ZaqfLivqtXPN2j/ftPFg1YnB?=
 =?iso-8859-1?Q?dbgL1Vuk7mbvejx6mySHbP7e3F+TiuHQk7oUknpm7IEsUckCgm7NRHoDTL?=
 =?iso-8859-1?Q?FEQeAdXKlH3gd24RRqz4bOgflvU8DBjNJVaDHHlvs6ytyw7Y61dsmbY0uR?=
 =?iso-8859-1?Q?n6NH4DF8NqX0Rk+u2EHYN60dXtRKQUJTJefhToTWOh23VJyqwvpaaTcZXY?=
 =?iso-8859-1?Q?++4gW8dW93oC4uFQzjelPvaokMk74BDBAnJQDbjMmebeskUOWaqW9xyGC7?=
 =?iso-8859-1?Q?J3bEOGSuyuhJPzXtO0yLbmBYDlkaHgbCoW0gr/PsUVp09yY11iYssOByTu?=
 =?iso-8859-1?Q?JgfD9pECbuSlren8h71xvYzUVMTchP+AbaJeM7VotvmBLK5eYagbFPJyL6?=
 =?iso-8859-1?Q?7hH0IwN895pJC5NQDg1IkYh253cNmHL+ZELLGF8BUh7ydzLDhptk0ml7sW?=
 =?iso-8859-1?Q?un2zlS0ug3GI6N/dTTstf4jP1q6W1OAuk0loHMaiVZn77lBHF1odW6ReLD?=
 =?iso-8859-1?Q?MpZWGmuD77cfoY0vSzk9GSIWeuMd7sBhT6demPK2Qjjhst6aLJrexozMkZ?=
 =?iso-8859-1?Q?kfhrLIJYOTBS+EbOHqwMCpSNGS39ZzWRjPUgMulqIyGoSJUh+uoSApWdcp?=
 =?iso-8859-1?Q?SNJrbahqm8hzo4mxLv6euh+Z4x0Kx+L+f4vBIOqVPE2hyT6Q4yp2RFYwT/?=
 =?iso-8859-1?Q?JzpvTP0m7ESa0JrQbHIcxr+E2BhtLsR/WdO2gocpp0R+EBg0J8aYQe11BQ?=
 =?iso-8859-1?Q?mP7D9GzDWG/n72GBcV/MgorlhqZPrRXimQz8QAGYXp3vIIPrLlbZYXbG2E?=
 =?iso-8859-1?Q?1TmB1R/JJvX56H9W0pj7NceCvaAFopq2Lw0d4X9czGzjfR9NsYYSXNxN17?=
 =?iso-8859-1?Q?QgKfWdZw5GujQb3WtZKg1woxYhJT0iL0f0oHpagqnWtgaDAT/jLgDuoFki?=
 =?iso-8859-1?Q?alnKalVPz8IhBl5Ih7YNwV0TWChGrzSrwak8NLdYsEXgnJPjzcQOQBfsCn?=
 =?iso-8859-1?Q?ETIBJL7j29z5WLoWDI6Wfd+63+Sx+yRhjEZ6hmpDdHhI7hPVoXMaGDrJ1x?=
 =?iso-8859-1?Q?neVHjWu4TyLPQ5j3sU5syytFm6f4Y/C5Ehct/nFTzRRan30v2Sl5yFU5rH?=
 =?iso-8859-1?Q?D5vEznIgdwywpoXr+DKbSHEK/u0GCLnozw3GStq3QSci/Kkm+D8hPtjxyu?=
 =?iso-8859-1?Q?ayX+0qGtDYR7cJIm2+ADU+7yI4I7iQfw/e0emT4ZehounSgYgJQFbHpW2u?=
 =?iso-8859-1?Q?aPdrAxcfFGsegHDylc7mcUJ+YJJOlFghnwrUhN10waansdvBJMOqu+7mFA?=
 =?iso-8859-1?Q?L7BhbgqDY6RaUPNP2QC5SoPZZvLzRpUagF6I23ynzZX7qy/HtU0ik=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(366013)(7416011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?4VdDdHTiA7JaSM1vv3I+q7nl0GJQVSRxnFgvqVsWsE/BOsOE8hxJ5WhcF4?=
 =?iso-8859-1?Q?XToNAXPWQCVipmW7so5WDS7gBq8Imd8qhT/wZfmqXRnzGbXguEWttJ1ozs?=
 =?iso-8859-1?Q?omF6BHyfRWG4n7SkdEVcYBIOe2ahoG6Z6OteXaIt3EjGNbPx6odmYiHFth?=
 =?iso-8859-1?Q?Dok937jfbUhxk8PY9UplB93WBYcV4wx/lW99M7BCveQd1d2K1rmxx6qSIn?=
 =?iso-8859-1?Q?azWK58yZrT9T3KA5Fil8PIVoqT+VL++r49+SJUkuCAb8lN22tzuzLc3qSg?=
 =?iso-8859-1?Q?cZDZeciu/fgM1LmfKQlUdNWZQ8jJTNT+RVzBs+XE3k4PpBI1SQU/QIku86?=
 =?iso-8859-1?Q?+T7//+AZdnLO85SnYnex/4vwXegTSMEA3mbr/h08vLfHOxpUtD0opVct5e?=
 =?iso-8859-1?Q?3DwWrf0TeZ56GzS37jfguH/NjV8seGGMSepmyC8GcA506hfMU0ikhtmeXX?=
 =?iso-8859-1?Q?GY9LuA4Bs8cYmFFWF9hanMKODxPhCsDpdqYvZdTbkwZvP4tCGDT7YpV4Yw?=
 =?iso-8859-1?Q?XdFZKcvS8W+xh7HFD2wkYqxdvPxZM0kMTAqilPoPI7S/XNCLG7V5PEySdT?=
 =?iso-8859-1?Q?52tyTMIFb48qvBoFgXRHW89046yinAnBMjklEc9tAJSTCv57X3ytAqEVmb?=
 =?iso-8859-1?Q?BPWR8KknJ7Q0JOUHeMnRFYxbHnh1jmsp0Z+kUDIiWDT9F+MrWaFlIE6f82?=
 =?iso-8859-1?Q?U3YM4RVJOU15uFCaAEqbK+rT3VypQiVXJXlNmGPmo8LqPpphrLN2uU3oGi?=
 =?iso-8859-1?Q?kjJRFykSE4bXjjIytg37kQiM4auLaPHyq2+efg7Dv+yrHC4T7suEymjq6H?=
 =?iso-8859-1?Q?c7+DPLrEwxfvWxRjz9NmZtnfhVJwCrwvpb67CYJvhZehr46Eq1Ka63nuoN?=
 =?iso-8859-1?Q?xMCzdlvC7uknN0vat8w0wqc6tg/YQ7LjLaUcrtniaHZOoYQesAJ7c3Kg5o?=
 =?iso-8859-1?Q?66LoVSAn7VqsloxcxLafP1tZhvLIjf7VVIK73f+OH7MkWiNh8/iZY0rnYF?=
 =?iso-8859-1?Q?7V7Ond+Uk+Q8ZgkI0Z7sDWA4ds7e/Vl/Itr0OaNJjF7ZteaAUCWuJkQz4S?=
 =?iso-8859-1?Q?ZCi80erRK6Ih+rgPG+rkeABkXwCkBJuWfFKL+hqOADp2d/3VKbfhyWLhvm?=
 =?iso-8859-1?Q?u3AguDnrd/fhWEF0DCPBn7uOb3yDBTwprIULuFMaV8WAQWTq/5Qt5jjlU9?=
 =?iso-8859-1?Q?Jqu7tv+xF/bTYjF6b9EL+jD0ehvz8zzFppWdo9LP++iYWvHZp+oPs5hFqE?=
 =?iso-8859-1?Q?Q69+HAkzTnnytTKq/8A6JcL7erl0GRiS26YTTwDfWLL2zByh0gRmOBSKFV?=
 =?iso-8859-1?Q?1AE9+vXfN8YhnohBDk4R5cBWSnTN23NWqSrAYidmT8Rg93JYI3HQGMncgK?=
 =?iso-8859-1?Q?SSVmBf7vD0ZjGW5useO5IhDSrra1+Lc6ul+FDGHns7ltl8HVyr4UhlkUtd?=
 =?iso-8859-1?Q?9J/SfOL9/+T2t+HCNkiGIqCDPCQ5p8jVUH3SuNNtqcx9ngMNYyNTUaoxDE?=
 =?iso-8859-1?Q?jOdHIvRGMTSN+5ikh5V7WWr2sRyRYhD4Eo8ka1yG3drY7yMUND2eJ4TXmu?=
 =?iso-8859-1?Q?Tb7kjPp72blN+bY/0KRZeG+n4euilisYULR6Qi3kxeRekO/jNqeIu3orGA?=
 =?iso-8859-1?Q?g34U/vnmLz6n4CInVHd6E6KQkkUYI0WV6nXVicPuHu/rcVPTnN+r/LcQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <AD2302C042E67D498C585E9CE10974E9@oracle.onmicrosoft.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	2MkKGMKNG/HbOoj6fFSCYcE3NkZzvjwjlA8gJjFxPDSNtg156eCS5+KALePPxV2iJLXoKy8vqx/G+LrKie4bXxVSJOKhG8f0bfVm2kN1OikEJPX+hrd9/L05ZrR79dJxfb+VZVHJtVDF5nlZim9UUe/m2SGOYKORM8M8JeBed9fYyz1EeLgL/BDeyVXKYFDJeGVGYurO083OtRaEk2+Fkybzmq6UU+PvXreShjTPVuSFHDf4YcUd68QeHvKrMUQF9hgxLjeLWyAvjpNSJf0hmzf7dnnyaVUjBYLrc8rrH3XoagHm/Mmoiu/h0L4RaghScbHEPykAUyEJ5PpH8ZvScsS1zGP1P/NGTDZrtILJsmwi+hBpPg+ScZ9jFKoCv94tKOfb+mrS0mT+XcQx+PesyXuhq1ftxQx8ZyvRVCznxzscsjZuhYZFX2sK0hYkLM4RtkGCydWnkHJM0k7GV3xWsClmHO4JQea2GbfMpzsyq2lzeiaYHmgCptYdet5WFBfSe/YW3w8N0KzpF01Oy6/pzgN8ippXHaTPRhxDMSsvYtu7G+4z4EkxBDAFo4UwibYbXVZagL3ln8aHP3FfeSwlXGoaTFbPvjvEj8rIxpyV95Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ff01a2-08cb-40fe-5bb8-08dc92117e5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2024 16:45:01.1721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ic9X0ylDOfKy3O5Ycd4a4G3lonxds3m/0eJvBy3Kj5l3cQX8Ys/cBRp0aZ0U4vc2D/0MmMl8oM9Ke9WWLE3pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7059
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_08,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406210121
X-Proofpoint-GUID: a8b2kpVdRfG_-17Y30FOQwnujA8gC3mF
X-Proofpoint-ORIG-GUID: a8b2kpVdRfG_-17Y30FOQwnujA8gC3mF

On 21/06/2024 14:40, Michael Roth wrote:=0A=
> Version 2 of GHCB specification added support for the SNP Extended Guest=
=0A=
> Request Message NAE event. This event serves a nearly identical purpose=
=0A=
> to the previously-added SNP_GUEST_REQUEST event, but for certain message=
=0A=
> types it allows the guest to supply a buffer to be used for additional=0A=
> information in some cases.=0A=
> =0A=
> Currently the GHCB spec only defines extended handling of this sort in=0A=
> the case of attestation requests, where the additional buffer is used to=
=0A=
> supply a table of certificate data corresponding to the attestion=0A=
=0A=
typo: attestion=0A=
=0A=
> report's signing key. Support for this extended handling will require=0A=
> additional KVM APIs to handle coordinating with userspace.=0A=
> =0A=
> Whether or not the hypervisor opts to provide this certificate data is=0A=
> optional. However, support for processing SNP_EXTENDED_GUEST_REQUEST=0A=
> GHCB requests is required by the GHCB 2.0 specification for SNP guests,=
=0A=
> so for now implement a stub implementation that provides an empty=0A=
> certificate table to the guest if it supplies an additional buffer, but=
=0A=
> otherwise behaves identically to SNP_GUEST_REQUEST.=0A=
> =0A=
> Signed-off-by: Michael Roth <michael.roth@amd.com>=0A=
=0A=
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>=0A=
=0A=
=0A=
> ---=0A=
>   arch/x86/kvm/svm/sev.c | 60 ++++++++++++++++++++++++++++++++++++++++++=
=0A=
>   1 file changed, 60 insertions(+)=0A=
=0A=


Return-Path: <kvm+bounces-26216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C29CD9730CE
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:04:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED96EB293A8
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8788B18C025;
	Tue, 10 Sep 2024 10:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h5jTwveO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CKy6czpe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDC018C325
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962555; cv=fail; b=G7RI0j3Cz6u4RYuA1ibOeHqPTIW3FRlBfDgvqS338aOtmRNhYPEVAnCldtRM/UIaPKKEZ6DGbatiDABVC76pDlDwjX7ObW5xi08P8sGuVpndNYMVWKpWFG3CLnNaXNXlGnyMBBXt13GD0sjqHE5g3xjbRIJy67FaQ3xQUT0iBjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962555; c=relaxed/simple;
	bh=xUfJTO5PWmK7Tj2vzJTODuRexjeywIkwmYGAPU4aBd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Uizg5z2PeDK2x+z3UGPOEK6y7cjK02IRHdLayFsmLiUA4D7SAv2+Q4wCbiLIJf6AZ8BgBF0R0HWtrC589oGgwQmXqWSyhSmGk1WtUYaD6ASEBS95/ZAumvIT0S1Ki0GcIgIQX0VtLGpJC5SdiYAXKr6lC5remfrGMHUgkOP5acw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h5jTwveO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CKy6czpe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48A9QnDn024802;
	Tue, 10 Sep 2024 10:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=lTEL6i972hm0brpxKiBCC5Jh/AaomVcIwAnTkmwuThc=; b=
	h5jTwveO8V5SUyzI5wwUJgAZGFDkQ2ORqLXPbxuSeJSHQtFRjvPNQbJVONaG76/8
	iqlyvVm0b+TURu+7Bd3/krCXRGS+lEZJ7FAP/iuF9u1Qk5rpIPCnBLUhepZ+HvsA
	cDsa7YKczjtsbcwJNY9pTa/WYMZeIy3TLccJHxo2WJ1yYzNyyfzkPEkcevOjc+UT
	E7asMADCJILln90SHC67msBktYvkXXuSsH33bVsWOXQm32YB1Qi5Pt9RQKy8pA2l
	zxAlgc3iunbjsmLoAJzMDD/dpSPHauB+Bkkx8sGiRqRaUlLQcYPDe1axzRPH4eiC
	wg1eapkuFzyOH00W1uABvA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gevcn4cs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 10:02:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48A8jrVF006304;
	Tue, 10 Sep 2024 10:02:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd98ba8k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 10:02:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s6vQv/KdvSdP22n5b7T0YdXIPaqBNfYtrTyFplKbRA2rPEMPdJWut5py3JKzOKzQaiuB9NiHSJWCZaN102WO8abIu6Sjcm1MpplPUxixEqCWgIKSiYFl99WDH/uMpFjWIw2qXRMi6uaRVtmBhvxYwEniL4rTfIAGhhgUwxWvvyMWQxsYik8oqu1BW7zwmOiup3gGTwq5Kilyj1KvjIybCh/JPNzk0tlxDx8BU7KeNviQMnfsDFRxzacfa0jQp/PkDCIzFTgup5ICVB/iR6emgAeCwdPJz2ORW82kU4ezFi9tCwu0GrwQdbZ5vF6auudctuPn+ZaLAt0qG2iQDxmzZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTEL6i972hm0brpxKiBCC5Jh/AaomVcIwAnTkmwuThc=;
 b=XxkqVcMxeVx5+DEudTMEZt6mGO3V4xnwf8mRR2pqWjw8NDGhqSwEsRRzoFnO5xef4YX1Op0MlLR4OrTzdVSL+WMNoKN76FNo0WGeGvnke0qzqlJuR9L5i216AG5Pz6JfJxTQhg2jVeF1csVKFkeGnjd1ZTLgntuU7pBrYz06gYu7NbQ7KEx3d1isceOPgJ+NyqUdaOY/jJBdkIhafpH54vsjUTuYSyjEKi6P6ahBJk2pBSXNtfvA0lSZxo9U2q6yQN/Io+LrFFs89JKLfkJwdmERVb5jG48HegpJD5krOYWb6tq5G0uMElPmhEzwo4j3OdDJC9zRzGkh3xDVCEM10Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTEL6i972hm0brpxKiBCC5Jh/AaomVcIwAnTkmwuThc=;
 b=CKy6czpejbytM9dTSyhWMy5w1vm/XB5Jb6Hth+U5zF+LOiQJzHUGWQTri23hodZ/3j9wShhvKIS7aH9Gk+W0JdWlG7xTjBUScn/uUfV/klgzDng6wEq95rFKyCZX3FWvgxRaTbzVhse6IO7Nccw360p6+QmQFvhPbM9xgrjbKCw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.10; Tue, 10 Sep
 2024 10:02:23 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.7939.010; Tue, 10 Sep 2024
 10:02:23 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: pbonzini@redhat.com, peterx@redhat.com, david@redhat.com,
        philmd@linaro.org, marcandre.lureau@redhat.com, berrange@redhat.com,
        thuth@redhat.com, richard.henderson@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org, william.roche@oracle.com,
        joao.m.martins@oracle.com
Subject: [RFC RESEND 2/6] accel/kvm: Keep track of the HWPoisonPage sizes
Date: Tue, 10 Sep 2024 10:02:12 +0000
Message-ID: <20240910100216.2744078-3-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240910100216.2744078-1-william.roche@oracle.com>
References: <20240910090747.2741475-1-william.roche@oracle.com>
 <20240910100216.2744078-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: da1e888c-2ac1-4ec0-a7ee-08dcd17faa80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NT9waOgBSNseEpv7xU8F/FZ3jDam3pnjwlMod4jrIEA60HgNrP+d/AHrQ8Ma?=
 =?us-ascii?Q?5AKZpB2gr3ozLcj1d8uorvAn2UpHGFi+DT+sgHWyrRpqeF9Bn4Rph1CtDqS3?=
 =?us-ascii?Q?5vFmfjAIgDJIUIgGDV/ocAv2jg3SlF/8oxn+ehRzbZ63nEpMGXB69ATbccZg?=
 =?us-ascii?Q?xGZupqs8QZOnY2WgK5iukcBC2V/yCde61ckoQGuiOrcp3JNRk2HlUrZlvjre?=
 =?us-ascii?Q?REeUxDwh23M8EFQ4AT9kWRl6CcaXY+h0kxSiulDDgXOiUSQw1HxedrLFKJuX?=
 =?us-ascii?Q?aGOOY30lQNpGLu89aOExeWFQDeMwtWcrR7wg0ytqPkwzEbxjjonAKlJMxpjg?=
 =?us-ascii?Q?p+NvY8GfrN/29S0lAWP70VV7wb9eU+X21twBMoACBRdMVfYyc+5JH+C1yZPU?=
 =?us-ascii?Q?epnTSGhj1zcT/tKD1/VGpHDO7LWYxwwO16dqJ1KG0qV9PJ6nK1PnzHfa+Zr4?=
 =?us-ascii?Q?1iHsrkxiM1G1bKdIKU3W9LJDDuCPEGbjqFnjFllo8TOJF+SD2PN62GgFN1T5?=
 =?us-ascii?Q?Nd0B2RCdeJEJphJSnj3WjGw35EUnbHT4qnIqgjMYIStCDvkxT+SAclgjN+he?=
 =?us-ascii?Q?CW++MwiSvtjSpRWaXlV0+mGVS350K2d8yYPXwwitNUNO3ufyn8ABp37vS3ON?=
 =?us-ascii?Q?ICsP/f+kCoKk56U9Vz7fPrmteBKAdwneF4Y2g3ZblZHBRbRSBjmTjx+tQ+Im?=
 =?us-ascii?Q?GcyJvJI2oia+sykmktqW7Aiaj4FMgxe79iQZF0f6ZtYtLLvXzzOZa3QMoyW4?=
 =?us-ascii?Q?geyItyndwQfeZlMKUk6XzP/jjNHDQMBxnOHaHb3qUNDf3hJsW+ol+vuSuGEn?=
 =?us-ascii?Q?nd7mM0znRX0mJPetCfDalyt6+zjavy1hyy358I1+h2ZTYtSzapnM3TeJrLKM?=
 =?us-ascii?Q?IFmBv1GgZVNmkFN+CW2qi+/AT6kwTvIn+Swokas1KFBmnunI2BqRGLShRO8J?=
 =?us-ascii?Q?Q6guoXZa4LKOQuGEgi6JmeKA+mRjiSlrjz/mEmawrxdhb6jGcltenwUD4iVK?=
 =?us-ascii?Q?EwhbAxbgYq9rm4P6gsfGm3C6kcsoTGczmI8dBuHxS4lXDmT8jhVX215zTfmq?=
 =?us-ascii?Q?KjBx81Xz31xp79Kjt46NMCZJJfObqzmKCeuC/v6H+TaK0ht0aZmYKqIONepE?=
 =?us-ascii?Q?hnX8XpKZBKuc39qZLbPBifdkYrreFfV0N6cqept/ev0foOajsMaCiPZ2TqBS?=
 =?us-ascii?Q?P06sRfQqPzogCcOaNJzPEKzYafhkJ6xG/UghdF8K1R+MBDEQwBekv9BEp3gv?=
 =?us-ascii?Q?ydoj+McnNZE7BDMAqIcHKPxYoM0E4Z4ASy7RsPtonnu9QfWhrCtl6Cp9hWRJ?=
 =?us-ascii?Q?CCObDqbZP7zO5CxJ35RwLeMGh3cDQwH60dMJQ4MWZbb2N7PjxHBqodGxZT9j?=
 =?us-ascii?Q?jMFZ+A+lYtQDgUHDfYW0zG8ARKb0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1/F8jMERj0t2eWXh6pRJm9RI+hd+Oiq/cezG0gDzo5kmgWhIi9wVgSDtLTUu?=
 =?us-ascii?Q?Sm53RtWjjKUj6u3Q7Xk4DyJENGkXJigeNVWnNOqTMTPfmJ7lAdPaGWf23hAp?=
 =?us-ascii?Q?TJ+gZj6Na6ETvjLwemJxlVDNIY6NkGFeunSJoCVvKsg/9uyKTEPf0OeapW2c?=
 =?us-ascii?Q?5UYAN5CI++CoFJ/ITQhelCxyO4JmP+KXWWyMT0Pq7ywrI7rSxL7F0kw0tMZB?=
 =?us-ascii?Q?6QjyRK1SyMTDrAxJdMPGnLokNPOwuUbaJHMURDh1uj9OOEUtegj4GLVM9nQj?=
 =?us-ascii?Q?aJwaxcpPHFFXyRF3A7yfpmnwgZI6AgGTsHXbJqcXlkG9IkWpZRnrHUjsX5xk?=
 =?us-ascii?Q?Bpbxt5RCyTlrRBvfh3tXiAyB9wb9F0xTaVbIxS0xwBOrHs/UMBL7CdgPHRJ6?=
 =?us-ascii?Q?uVWIesw+DPTD1Ypeq7pxDAL9ok88NAI44MTxTW1sfJ6ZbKIv0+l2ewi7GP2S?=
 =?us-ascii?Q?kXq6CoQWCRD1b0na6FZIQVrZqP3Fc/T/FXreMWCVRdbwUnUBw3kE13gAHMdQ?=
 =?us-ascii?Q?8A/7Ey4v0f/dPbQBQ79L8SOsF1HUwyHq9hSP5do7Yv4stn7JIqDjRZZlMNDp?=
 =?us-ascii?Q?gyNoV8HAPlqR/J7dPKmzxktEIMbYa0de8gtej69Lk9I+jm5w3gP9p11O9TB1?=
 =?us-ascii?Q?He+wKlWFUBbNm1/bSfHMW3sh0uKiJ+Q3D0WHgs211Tfzubb0FKSupUwOAL1l?=
 =?us-ascii?Q?EEoeZUWwH4OndqzRjQr+MIX6/uHH2LhxMeAWPmc2E2wfVosmQZ/8DCriG12q?=
 =?us-ascii?Q?m5ETHfpYc2a2F72Nobg6u8bSui882dQY4Rm9Dx6szYDK8GGJISJUksRqufP/?=
 =?us-ascii?Q?KdfNoge0oXhunc0uhvV7RiRbuXYsHLEWNWaxaNQ5uZxxhy7z//HXwma2Kfl8?=
 =?us-ascii?Q?QvWw+ZDl4k5GaYXh3PzE6KBFwMgVzWHqnvdN310POW7sxjJv8OY0Tumq7pFZ?=
 =?us-ascii?Q?3KsL3iAMGUwxxbsNcKGXvgdEKrqIzjyuk1xWam73CJ3sgLPMyPpSnieiDP8d?=
 =?us-ascii?Q?vcIhbD3a1JJudrjsogPQ6d8hUDbV9WkfZP3gyk7tZCVAADS/GbuWRlNR1ty5?=
 =?us-ascii?Q?vScCPon+F0LpEr1d/TFKWfD8QLFF+4YlFl1m7JGorT6jbm+O+eVEBqpZLjBy?=
 =?us-ascii?Q?btNgzdBh9YTxmPD9+1vfhz6eMtuFH35eX21tjzWIGvkBMNA439uJXuvA8oEY?=
 =?us-ascii?Q?RolO5dwRErpawFZr+rJt2SnVC9eP/8P5LgsXrCYRzbtItn+WCpBZfa0ZV/mb?=
 =?us-ascii?Q?1oGyBg3W+JmTC3fxaVHcZAQBKIhhm+Tp8u6A4dPbp+LOgD4abe6N8ELxhbuY?=
 =?us-ascii?Q?MuIIEBY9F4sCi2bikc2IplQgXPvKNqSBwodpdu2jv8PqFdjbap7MD8GN66Bh?=
 =?us-ascii?Q?MqiPzvlyCiSaJgBtd9Z7VZ9Uv+pTT+rF5L5DGjYbe4y2F8mC9LyHkltN8v85?=
 =?us-ascii?Q?84dpaqFykVDn7TNdNNpXT8T4HsTT5LzU5Bk3jXQ+APrbTQchI7kTTPVftX+L?=
 =?us-ascii?Q?g79WG8+kDwao2v6Et41tyVscFrUNUjHiLfinfTL8yEbTNP8BufwOc1t6kICq?=
 =?us-ascii?Q?xhZ29GIFf64xQGwRFClHmwSPKx8IYX6YBsyTajUYCKfLClFwKnRVAjEW4tqV?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x2i+4vedCq3w9wQe6riH6E08BGqvCU9Bjs7FvyGF/75LbB1o937uOwYmii4e/uGCSn8zlE0hknT9RBMwCIOdDeRXmbNFHxo89c+UaIDMJmkHgOy1h4UrIFUi3cqWb63o6CHHZKlxKkZciznuQEOqF3TRqAU6E9Bu9AcHWzOhUH13kj3i9VTGL65FlMhWNqU5VggaKYLTToHVJRj7RJRzV1fsyuYULRX59P2P2eosOIiZEJ877Ai05OleoBl4G7OLRdOPW5DQo17UXpSxURqr5dLlZ7L9IMFjorJVzjTHcJ4MeSK9GS1s9kfhJ/EDunOG8+qjwEk72kFR9ifkIhqLc1U+xa4/hp3YepQOp+GMo4wHAAh7V/eQe9tuHplb2prEitWZWmn4EhzHsTeVxDcRgnhw/IYS0/7FX/vNRnxhnxiFZYFmbCWYevYDXcTGVjuuFJcNuKpmX053bXhEuMJ4CzKxR+of+q0Z3s0HLLJIAh9oOfOQedFQlKLW5DWlMVW9OALoywje7C6QLYcaTT3K/6G8RUvcpeMWvjfqCg7ce16fq8WUKVvH7vTNDihf0SnNGJWc0e25UJp1sFsRzUezjaczctZerCl/bmXDO8wfeSw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da1e888c-2ac1-4ec0-a7ee-08dcd17faa80
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 10:02:23.3072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 24ixVMRJ6ZGPZ5oTOrjWzTvmg1jvNB3ZX5kSl9enMmR+oMnUQG+O2RPmgu2eCkf4VIGPIZutRuz9bMbmTD9tKRVGE1bPFn8Y/Zm1WSeuRlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_02,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409100075
X-Proofpoint-ORIG-GUID: nOW8GYwFTndQ6XtbnFeOHta8a2f5iM_u
X-Proofpoint-GUID: nOW8GYwFTndQ6XtbnFeOHta8a2f5iM_u

From: William Roche <william.roche@oracle.com>

Add the page size information to the hwpoison_page_list elements.

Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c      | 11 +++++++----
 include/sysemu/kvm.h     |  3 ++-
 include/sysemu/kvm_int.h |  3 ++-
 target/arm/kvm.c         |  5 +++--
 target/i386/kvm/kvm.c    |  5 +++--
 5 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 409c5d3ce6..bcccf80bd7 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1200,6 +1200,7 @@ int kvm_vm_check_extension(KVMState *s, unsigned int extension)
  */
 typedef struct HWPoisonPage {
     ram_addr_t ram_addr;
+    size_t     page_size;
     QLIST_ENTRY(HWPoisonPage) list;
 } HWPoisonPage;
 
@@ -1212,12 +1213,12 @@ static void kvm_unpoison_all(void *param)
 
     QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
         QLIST_REMOVE(page, list);
-        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
+        qemu_ram_remap(page->ram_addr, page->page_size);
         g_free(page);
     }
 }
 
-void kvm_hwpoison_page_add(ram_addr_t ram_addr)
+void kvm_hwpoison_page_add(ram_addr_t ram_addr, size_t sz)
 {
     HWPoisonPage *page;
 
@@ -1228,6 +1229,7 @@ void kvm_hwpoison_page_add(ram_addr_t ram_addr)
     }
     page = g_new(HWPoisonPage, 1);
     page->ram_addr = ram_addr;
+    page->page_size = sz;
     QLIST_INSERT_HEAD(&hwpoison_page_list, page, list);
 }
 
@@ -3031,7 +3033,8 @@ int kvm_cpu_exec(CPUState *cpu)
         if (unlikely(have_sigbus_pending)) {
             bql_lock();
             kvm_arch_on_sigbus_vcpu(cpu, pending_sigbus_code,
-                                    pending_sigbus_addr);
+                                    pending_sigbus_addr,
+                                    pending_sigbus_addr_lsb);
             have_sigbus_pending = false;
             bql_unlock();
         }
@@ -3569,7 +3572,7 @@ int kvm_on_sigbus(int code, void *addr, short addr_lsb)
      * we can only get action optional here.
      */
     assert(code != BUS_MCEERR_AR);
-    kvm_arch_on_sigbus_vcpu(first_cpu, code, addr);
+    kvm_arch_on_sigbus_vcpu(first_cpu, code, addr, addr_lsb);
     return 0;
 #else
     return 1;
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 21262eb970..c8c0d52bed 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -383,7 +383,8 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
 unsigned long kvm_arch_vcpu_id(CPUState *cpu);
 
 #ifdef KVM_HAVE_MCE_INJECTION
-void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
+void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr,
+                             short addr_lsb);
 #endif
 
 void kvm_arch_init_irq_routing(KVMState *s);
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 1d8fb1473b..753e4bc6ef 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -168,10 +168,11 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size);
  *
  * Parameters:
  *  @ram_addr: the address in the RAM for the poisoned page
+ *  @sz: size of the poison page as reported by the kernel
  *
  * Add a poisoned page to the list
  *
  * Return: None.
  */
-void kvm_hwpoison_page_add(ram_addr_t ram_addr);
+void kvm_hwpoison_page_add(ram_addr_t ram_addr, size_t sz);
 #endif
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 849e2e21b3..f62e53e423 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2348,10 +2348,11 @@ int kvm_arch_get_registers(CPUState *cs)
     return ret;
 }
 
-void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
+void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr, short addr_lsb)
 {
     ram_addr_t ram_addr;
     hwaddr paddr;
+    size_t sz = (addr_lsb > 0) ? (1 << addr_lsb) : TARGET_PAGE_SIZE;
 
     assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
 
@@ -2359,7 +2360,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
-            kvm_hwpoison_page_add(ram_addr);
+            kvm_hwpoison_page_add(ram_addr, sz);
             /*
              * If this is a BUS_MCEERR_AR, we know we have been called
              * synchronously from the vCPU thread, so we can easily
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 2fa88ef1e3..99b87140cc 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -714,12 +714,13 @@ static void hardware_memory_error(void *host_addr)
     exit(1);
 }
 
-void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
+void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr, short addr_lsb)
 {
     X86CPU *cpu = X86_CPU(c);
     CPUX86State *env = &cpu->env;
     ram_addr_t ram_addr;
     hwaddr paddr;
+    size_t sz = (addr_lsb > 0) ? (1 << addr_lsb) : TARGET_PAGE_SIZE;
 
     /* If we get an action required MCE, it has been injected by KVM
      * while the VM was running.  An action optional MCE instead should
@@ -732,7 +733,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
-            kvm_hwpoison_page_add(ram_addr);
+            kvm_hwpoison_page_add(ram_addr, sz);
             kvm_mce_inject(cpu, paddr, code);
 
             /*
-- 
2.43.5



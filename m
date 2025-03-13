Return-Path: <kvm+bounces-40870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D5D0A5EB1A
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A518F3B2D07
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 05:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F07FD1FA262;
	Thu, 13 Mar 2025 05:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g1+RNE6F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aL7nkstz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12FB1F8EFF
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843369; cv=fail; b=Z6f0aMGY7SXb23hXsPMnoC9rLHDubvYkhigOhHlOQS4bSPoesv/0G3onCZsz/kn5RrD6qMRlDNYPpG10RUEVbtE7OoUks8MiXGeWIGnNQNG9oHvrLauC+2rsf6rIMgcTv5ts5q64XOMRGAx2+Fuzv9QTu9DsTTze2eNuhffVreA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843369; c=relaxed/simple;
	bh=n5GMfygwILBVetH5xpdbDrWe1FmC0tI3pTd3F9K/uw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CSsM9TV4io+Ansyr7VuEeZ27xKz8g5f03U6G/xwzLkdrGzodGFcl8TtXlbnxhlmR4nY74eS4d9ZUUzSt/T1hKISguZmj11ly5nTG7VfMUkoG5lyPbuIm2nnnhujap3cIIOUdhL2Yl25jOnzN+758a79ACrtdIurrgfK7uQ8K42o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g1+RNE6F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aL7nkstz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3uAqq019315;
	Thu, 13 Mar 2025 05:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=MhstusFrebtg2CVvK1T0jLZmsPovB255F3YpTwT8I5E=; b=
	g1+RNE6FvpAM1TeIYWexE0HqrTesuqZrRBWbKB4IT2Vh7RGgSgKCOmUr/DHLfoya
	wi+lsa4bfuWHod8j28SzWezneTCXB/lKk+2I13XorSppm8d+w1hqUYPmdmFaar+U
	l+9fbNR1bWUiRe+5+D7/8leE5PGV9EhajEcQI0BaDrhwoYgZ1XwvwLHc/A4C26he
	zp7l8oIKu6PakCMzShKyGnTnU8aBmuiWAeQtGwF9wVUeiGxP6BkznvV4ZQsyiv6T
	rRFOhc2i3pLoULAQyblEDXRNqjw5FyYHrhmdAr87Y8Oe+5PhIQ7PElN8gbtx0xsr
	rTeQWRNlKx1fOtHJ+CyVig==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4hbfrb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3RH9R012272;
	Thu, 13 Mar 2025 05:22:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45atn272mx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W+RnWGFs8w00PL77PkJi1LaRIG5FxJ2lQcs7JQjvKXAGRwzW7L0/v0RdP2Xpin+fAA1n13PzrEn1O0AwssdrlRWFXsEUDEit1sU0wgl4bfDVB4o67+n7wuF3GjtGokQKJb+pDwj1GSXG/ztxsPhNqObeuw+jatGuaCk41fuuawq5xsZuDTsA5FK1i6hGuD7op3drMq05y+UE1RKwPpPK0+ahnUBzWiojyXEJInKuuSElU/EudXtoFFKx9JHbRxvd/yxK/FRw1Ju0eQhL+ezcxEHSuSMxxT7hVxDUWTLuFhtxdSLehU4IHOYoRhY3kAouj8/bgpv66Xe/d6szWOPW5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhstusFrebtg2CVvK1T0jLZmsPovB255F3YpTwT8I5E=;
 b=viXkZ534GgDgFfGLmTSEMseVlbMx40ZYOqAjUlgAH1XJ+q6lei7yDsW2vXKCaKSe4NLuEcJScswRiZWDssSs0Fq/ipHZxEWmXII67LvaajCYbqUDne20w0GXUNMsYmssZHmx0a2MezsiFkYQEXOvFNgdtGz20YDoTivT6kuM1gY5rqNwoXiO8zqMkjY8x9SCWHKxGR4Xf+9W+HSEkinr7Ivuyaimf2HiB6BOGktfYWJViszW8gnKjrUBRgrMSYDyOPOhheeBVi59gDm0F9biSGQMimqzCqeCglHvB4laHxLOKIGOXOC/DhtidI06p0nSLqmp+wEjYxuHJHGaQ+Go0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhstusFrebtg2CVvK1T0jLZmsPovB255F3YpTwT8I5E=;
 b=aL7nkstzxaK5SoriNlI191EWo/wpsXcZf1FhWKNRjT4ReRV0yIR9pKY67ul+0oKNDdtDNLZ0v0AWaZooaYSAWTcfzODtBmK+x2YDyUsiMvaJIJiZzH+LF4BpGnh5MVMfSWltJJXdA7cYUW6YLP8hRSAyfGWEmcbL1o9w12YqwJ8=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 13 Mar
 2025 05:22:28 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 05:22:28 +0000
From: Mike Christie <michael.christie@oracle.com>
To: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 02/11] nvmet: Export nvmet_add_async_event and add definitions
Date: Thu, 13 Mar 2025 00:18:03 -0500
Message-ID: <20250313052222.178524-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313052222.178524-1-michael.christie@oracle.com>
References: <20250313052222.178524-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0040.namprd13.prod.outlook.com
 (2603:10b6:610:b2::15) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 4805b95e-32d4-4dea-afc7-08dd61ef0be9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gNxul4C0NbVxCnZrn4XkwhHZTvvzCDRKUWM8NgUerc5tBrtugkVv8OlYnNoj?=
 =?us-ascii?Q?lkjxmffDqDL3DQWvJrffRCqoiM/tJtZ6YQnEJteTe4Bq4+20dGnQBbC4p51O?=
 =?us-ascii?Q?X2BjWg6UkMOP6280NrXutUmSiq2jm3L5lcgjdZyS2N7O0ojrPxO9qtcf/vKn?=
 =?us-ascii?Q?twJpEGkQRH9mLWzl5ENkemA85Wpt2ebVm50nMCkTKjBWp/JK2Uc9yFKcobMG?=
 =?us-ascii?Q?zb8uNSyb8coj3ojSreBe5aUPeoR07uNk8az6YZKwga0nvYTF6tymjkMIioeo?=
 =?us-ascii?Q?gNLkHui224IW5A2eSndeZM6hvfCOSIYETi8SP0sFnHu5RwPTyBzVRtXLikKN?=
 =?us-ascii?Q?o+jcb0+C/Fl0qolnVhWsnn2i5ql5q/jltu4i/48pD3siEAxfez0ZX9TaQsrC?=
 =?us-ascii?Q?63MkvKCKvQN7Uv2xSgz4ggl4cnYWwSwRnjpr2BP1wGp2kq//yKYLnLJtihFv?=
 =?us-ascii?Q?ZQLKhcvH7le7e2qkHnAl0ulc1Z4/vMxo+aT6QXHJY+MgNegW50L4sJMjCvmz?=
 =?us-ascii?Q?v8MGduyT47mS8gTbaZCU1ZlVov+oxMhpy0Tf9laahbMEdZsF3IEgxom++Roe?=
 =?us-ascii?Q?5a4kKE/bGA+DJ0NLlmTgB1MCWEoycOAXQ2g0+/Eg40GA8DzYGkngPwPLLzeJ?=
 =?us-ascii?Q?XwLAf7v5uCMgyBrZpkHFP31O0MiUHYR7jljzxik+WR34ORNPUUSufBNR1fvQ?=
 =?us-ascii?Q?PXR4euTIZumcObfr4y6oRO13HX4CfuROD+5XnztSW38MJ8HlV6iZOiYxo+jy?=
 =?us-ascii?Q?DsQnLzL/XePgVTgLqRILdccO3r5eWBQwyiBDBmbfPp5mniW1cmxgfwDWUbgi?=
 =?us-ascii?Q?Jrqz05/RJ1CPW3Wep48e+/0KkzSLAPZ4eVXCiLwNdh9Y0SlDoN7hxczqVG8g?=
 =?us-ascii?Q?NYiqJ0t/B71AaU3uDhZFkBgEfQMbA2mZZIs08GJ+9vX2Nn7C6mxmA3DsS1pY?=
 =?us-ascii?Q?LF2RceNRJ/OC/yqy+ZDZoMbL/csXdeF7TzfSo00TrmgupOGTBPmr4cAyXmXj?=
 =?us-ascii?Q?vMUxuapLNf5hqbXUh9ZjUlG0uXk8ARK5Z7HOeFJD9bHmiSgyUqVpLkrkjG4S?=
 =?us-ascii?Q?0z7LaSgCOoAd6IDoQJZR7tx2v58NMhUrhC2CRCkpjU6GNx/axN7xbK+hTENa?=
 =?us-ascii?Q?37jJ5VUg6C/Ci1K59F27MZ2TBllrjRpJ/FOcI4z2zqOSOGGeNxMuGCkUnJKK?=
 =?us-ascii?Q?n/ozyMLxZ1gHS78Egy7pFnUX3WV0yHsgJKwSFBjJqblgjBQnRb2Vcc8WaMBd?=
 =?us-ascii?Q?OBBPFzKQXamIQynDiCrRz/exlD16CztyFLgfWwO2udNL/qYWxssanUrcZVSe?=
 =?us-ascii?Q?wls4JWuhH07ABwBtTkrQQI8QnMND+M5D17/5iqVVGBQHoDm8vTukJn/hVRCp?=
 =?us-ascii?Q?Qoi2Uudt2nqOeYu4TBcGb0x4X4HfdqQ8Yhv/WMEVXz7n3e6e6BZOAIEEM0eY?=
 =?us-ascii?Q?eypUL+6jj48=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KCxmrtvl+lk9+QcupEHBci0uqXzGtIOo+z54gDxLk8oR+p6VRyAJtICtTzP4?=
 =?us-ascii?Q?4ebsLLuK+GzgAe4dZYmWlWbvg0tuQdRwxOO/mmdD69G87iveWZHFrYq1bfH2?=
 =?us-ascii?Q?V1M7yw8jzqxstMNuKEaNWmJqVH+oz7moPaB9fUpKcJQmaBewVGSQNgkNj2gf?=
 =?us-ascii?Q?xSDlwTr72xSi7GetaH3cukbBlHrtGB4PvEp6IIdjKjxqUsUS8drapcnpM2QR?=
 =?us-ascii?Q?/3jYarzpT50jFsLi3oc+q8ppWTM3MYJ4EHrhFnjvWagb8r0UorR9YZaN87ip?=
 =?us-ascii?Q?FtooMv++FXMwcv2H9h/0rBkVE9JPMpSmAKBpe+ywucKX4Zu2DYGQeT7hs7Mo?=
 =?us-ascii?Q?yJRb231ld6ahBvIvDf1tYHj6LArLuF7rSjAOZq4wZcLLSxb1n2RG5MlYGB+U?=
 =?us-ascii?Q?DUzY+nR0s1c3KHdMwgXIfm68kqfmDFe1ICgW6OWMmEbx+TcdaADXzXlxeuee?=
 =?us-ascii?Q?U5AgcmT7KAHWa6Cmd9+roH0otPNcYFouP9U/CqPzsaxD4HvmkGYIFPS9oU54?=
 =?us-ascii?Q?myT/c0U6bOjRxlL0ORnif/0HAB3QQ8l/087LcAxD3teYPvmqrgsEFX3gnd/X?=
 =?us-ascii?Q?gHRiFLtr80Srd3uaVIQnKYK78dkYJzszBYtgKRleNNo4Ui4QG8rV4w5gU0HY?=
 =?us-ascii?Q?OpfFvCHNI5H2v0GkfQ32c4rG02lED8FxUHhPNTIqrdxFBa2x+Sk0vDg72NU7?=
 =?us-ascii?Q?d6aa79bBCHKIqbciI9prdKvgomlCDn/G83/3rcQnC1g1bHZRnf0B4bEJpMxD?=
 =?us-ascii?Q?3UEhHtITERgHdPivISRtw4GGZGMXoVeZnwlPCHs4zTjq/71b9A4rE55XQ6Sn?=
 =?us-ascii?Q?SeO88LYQXcqtzS7mu9E4OmXu+lSzbhZFBuqfUzsZXQ4+pe/CCTaVUqe76j/Y?=
 =?us-ascii?Q?Z+0zPtJMseP/E73kUObsga28WjbrT4Zn26ONGxNp4jd427AXmhuQVqE3aaoR?=
 =?us-ascii?Q?ByqV/DCWowEQw2uLCBJdle7pOF/d6xuy6YaMUjzLw5jMNTTUC67LhNk+wrwR?=
 =?us-ascii?Q?4tcDQWQaAFpi+WRpAN2mOT3wcQic9KBaCCZ5UqlvHkxecmN09JZAQV7C+PmU?=
 =?us-ascii?Q?fdZbwXzN9yvqdsUk1w5opu5F2mQ8Rqd3riy3D6+pl1IgIC6GKMnjxnwo/1aK?=
 =?us-ascii?Q?dBEazVYzuQXzxe+nBONEvvoYFyMoXx43FWQM6On/iu/19OM8RCVEK9TIRJU1?=
 =?us-ascii?Q?h36qCXrpRebRMCuY5VRy1zJ7GAvHaBc+OyoH0zJvLJzwwvSk1AhdfDDu1YqB?=
 =?us-ascii?Q?/ANq1EnocaXVD+lkN47S6uSwMp0vMwPz83N1kzaOrA6r6mr/E+laEo2Arx7S?=
 =?us-ascii?Q?ffpuXtoK9mOEA8SZYhRdPBCLEAZBAnNrkG2vzm7MO2H13ailqIWAlqi1SA1Z?=
 =?us-ascii?Q?gy/kcy6e4T6opyGVihxyivXKVh43dRSdvVox5FzKDTq2o7G5486QAKmxbX/6?=
 =?us-ascii?Q?cTATiGn35OYEoeB2qt0+bBLxjfzkA64dmUBA/xIcOZb7EZvomRYC4M2Sb37x?=
 =?us-ascii?Q?0Z/SLa5SdVHLeZj7SH+tVnDeiTftjQAILVWxkeVK6TzGTy9R7GX9+V2CGIsj?=
 =?us-ascii?Q?MMe1r2Z6URODxzjs+uGnwrd5Z2vtx8PpoV4c/hXqYdDIUfUkUhbaIrQavZCL?=
 =?us-ascii?Q?sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3IJkq6KBjPlewBZzO3EIAQACwrmxihOgVMK9tjA9FjOLuaI4Lh6Jcd5eRpxaiqH1ZSRg5MX5odIA6oGEToKbZ7tICES040rzetXzMTPyB8heXLwvYDk7O990v9hGOBELacZGFUfkhtc5Kf1HxMxzJ0eftqfEgFpo53uAoJmMJxYv8XIzZu4GP0icCsZIAHnR5TOqFLp5mQZ737BjRoxMx3pJJ1lUPmESH1lWD5LJiRzdw8Z/7P0MpZ5fnEzXmkwFEtfdX/LQ0xZmyxd58bt0XKaeGvjfPZT7298ZXptb8JHbc6kMLF+cAjqpw01kn/IFESUVBo4G8dJMlFQaflY4Grl1mKDVwG8LGX0hj45qwY4eHWNGPmyy/TMzROX+v+hAMN5XcsT9pRjqKFUJzkE78h8hnUxi5q0fqlFCgpzp1X+8XD1JrHYnTUNCygWJAVY03/b3KAxCPxYwOYbPLtYTm7nTWxt8u4eJnmrvHqWpMVcDJ/FUzdcqi18j81Z/8Anh1f7A5NSezRE5XnAIQuI0gVYExRynRWN631YRBK4Xeh7e3WOfWcVTAMQhxsdm0nN9RFJPaSsjbTd1wXm31r4bSw14jpljuaJmmE4VvkueWZE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4805b95e-32d4-4dea-afc7-08dd61ef0be9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 05:22:28.2349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +mBXZuJMoDvcFWyJdWHsCpyeUaGCLnrxz/IQ1ADmxPar6w1FIUXLQ78Nw6kjwMFSv/8N0ITXLNZtNZFaEkhnBmIxxgPGInx2rbH4UxoN7HU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_02,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503130040
X-Proofpoint-GUID: V7znLuM4V4ZNnX3T31AKitIfxNeFgsJ4
X-Proofpoint-ORIG-GUID: V7znLuM4V4ZNnX3T31AKitIfxNeFgsJ4

This exports nvmet_add_async_event and adds some AER definitions that
will be used by the nvmet_mdev_pci driver.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/target/core.c | 1 +
 include/linux/nvme.h       | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index f896d1fd3326..4de534eafd89 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -214,6 +214,7 @@ void nvmet_add_async_event(struct nvmet_ctrl *ctrl, u8 event_type,
 
 	queue_work(nvmet_wq, &ctrl->async_event_work);
 }
+EXPORT_SYMBOL_GPL(nvmet_add_async_event);
 
 static void nvmet_add_to_changed_ns_log(struct nvmet_ctrl *ctrl, __le32 nsid)
 {
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 2dc05b1c3283..a7b8bcef20fb 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -806,6 +806,8 @@ enum {
 };
 
 enum {
+	NVME_AER_ERROR_INVALID_DB_REG	= 0x00,
+	NVME_AER_ERROR_INVALID_DB_VALUE = 0x01,
 	NVME_AER_ERROR_PERSIST_INT_ERR	= 0x03,
 };
 
-- 
2.43.0



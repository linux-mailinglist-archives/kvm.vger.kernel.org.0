Return-Path: <kvm+bounces-48253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F062ACBF7F
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F19517190F
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 05:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5310B18DB26;
	Tue,  3 Jun 2025 05:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="U5i9AKPr";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="gLtPDTRW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437A244C77
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 05:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748927773; cv=fail; b=tvJ7eempP+xlly5pjYq4M/WYetWnNj2h1RiSVdtI9aLbg+Gm6tl4HKzESJVmaWO5F0QmqpkpGmTf4sWjZlJK+hPk83xqtiExSgG2MaAj8S04yVcZx40aiIHSe6161yiLgTosgUEhO7oZpH+5LMUeNQZ8cIii6eZDi8p8tCVGMEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748927773; c=relaxed/simple;
	bh=r9weCDRabJbLHb7dQbb62mOSkWp199RGdExSvY1iXAg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=WBtgkFWufrlwyicJSsWhsoK1Es7FSOihKSVvifBy+TVqxLow0Vi798/b1r0TDsPG0pTWcHTUtfsYH9gWZdLC4YMyMcHZL+Ofr0sF1QJ/nXmzrY7UfNGxdAMRrBTRCJJl7ni4Yki1avfzgg0cPzKe5CWWxqGNDgyaYSIrmSImSUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=U5i9AKPr; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=gLtPDTRW; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552HHoHx009497
	for <kvm@vger.kernel.org>; Mon, 2 Jun 2025 21:48:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=q7CFPEK8Db3Yh
	xyhIFPb2wwGx29+c1y7MIXCEVJkUkg=; b=U5i9AKPrG06q7A9QPRmzSWKRmpyhU
	9x/oNTkZLgkeCy1K+78lADZDp/Zu191kCw7ba0jfCNxrLdKejHDTiY2z/8lCsCz5
	6ca2KE2Yzmy9Dld0MOxBgYIijF9CdFHpU3ACN1JtwBbKmbX4cYmKUKgGjBNqV6y9
	kDCUmfm1t9CKaJpNPeTLwcHM7oBMYETYlAXw5fU0qXNdSpJH36bCsIqmY6vX15MM
	FEQS1YfANObRtkeTLnwM1FSy4Qwolxk1zG61FWv3XCERSmsi/sAKgpF9dp7XNuls
	h/Tolya6Qx2UhvmGLxQ0PnEMKpMc2tn6pLcH+9ZtB1eazWU22PeqQBKJw==
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2103.outbound.protection.outlook.com [40.107.95.103])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 471g7xh7yp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 21:48:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e81Z9I7qm+d6Al1nnKlmTUj2isWHDZIp4HA5tZCCy1Zn0WZccgcQEs5uAXUCaabBMU8qBmPW5uHJukO7M95LtzawBZS05hQVDZ0726xM3fkya/X8kGIvDVZoWeiKPTMFVSwIu6ReIrM461Y9XgEi4ouIkItZP7jjzKfgfo9pYRS0heeyGXbyeB/Gtzh9/TFxQmpZevW+TCa7uRLob+zTSCoJABVkZ4mC3OozaYLWv8323l5KtMpNQd6PGyiQbNdJITlmf6dnOS8gLoJPiH1LX9NDDuFBiIMrk2C6c9KkjJC7fBi57AvqoL0TZw1+JIsFxnR6mXgDAeMPH1LwV9XHGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7CFPEK8Db3YhxyhIFPb2wwGx29+c1y7MIXCEVJkUkg=;
 b=qAzX07/FyBgjW5qapfUVCx71LcZWWxR0KV4KAznnt46aNlVicCruYf4YUcn+ZOXtL6pNjp/H9ZGwXfe0U7R8AFjiCLQmHuEphDUOTdLxX/Mw7ZvApgtLQX5xeFZIOfMsPRQU4SZFLUUK5H8zNekX6uL3HdHoTsqgKn/TmBpg0Sw+CYlNikT4R4dmtXuuXnkIr94tVAhDbf96FipwaWz6tFeZW8T0cMxRjzIeBcztcFuiwrPnLxkasE/XaFMv3pTi99BTf/PEK3oZX6JqGcael2YcDP30VfzBH9F1sCEv/VbMzkSoxC84vZM5cAqxfrym2YoS1ZzK7jsjjJwet1X9nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7CFPEK8Db3YhxyhIFPb2wwGx29+c1y7MIXCEVJkUkg=;
 b=gLtPDTRW0VJWdqF4x4ecgRvfSQFZh/TreP6nJisfy5cAiJwOjXcPqQ9JtEc94Zqhh2alBGUcIHphBDzY2Zr5Z0nEh3WggW7se+218yxS7aJqSLoAJmo/V7StoeFJzU9iqwPFQnCz2DmVob1Okpu5ATzJBFESq7hOPKlaIqCncuEpbr3q7A1IRirUF1Var5K50/WIHJmV7GW7PdCDJw6Jo42mQwbIBE15FfZ/DwpCgJpSDgErWr5ja+d8JUqn7AWh0XErc+kF2uEAfAW9MxwdCe983N3ZioGpVeFL0IA+Rqx7/bQl/offce6UGiLYPIxlT+L97Ey/LzxW8dUOJ99atg==
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by DM6PR02MB6604.namprd02.prod.outlook.com (2603:10b6:5:21b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.19; Tue, 3 Jun
 2025 04:48:06 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::b78d:8753:23a8:cc78]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::b78d:8753:23a8:cc78%5]) with mapi id 15.20.8813.016; Tue, 3 Jun 2025
 04:48:05 +0000
From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To: kvm@vger.kernel.org
Cc: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Subject: [kvm-unit-tests PATCH 1/2] x86: nSVM: Use PT_* macro for NPT tests
Date: Tue,  3 Jun 2025 04:47:44 +0000
Message-ID: <20250603044745.1387718-1-eiichi.tsukata@nutanix.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0050.namprd17.prod.outlook.com
 (2603:10b6:510:325::22) To CH0PR02MB8041.namprd02.prod.outlook.com
 (2603:10b6:610:106::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR02MB8041:EE_|DM6PR02MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: e7e5a729-a6be-4b0b-5644-08dda259d419
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7Y+skATlTSk0Xm9t0s/XU2HzIpipOxcD3iefWltoCrzmFPHZFc7v6zvwvkGB?=
 =?us-ascii?Q?ORLExYSBTxdi4tco8hWdhQXUQzidPzokiZX3eZZatQ9LArR2LV3nIEOvVIrc?=
 =?us-ascii?Q?Ec/clTs+PbCzBVnZ0m90XTj9nIyNN1D9dq4omqTUl+/TJPYSfpEIlrh+S+iH?=
 =?us-ascii?Q?2uIktPxjlLiRudGazjKT3fZ2J15W94F3RFIUdlQq0qSQ5zMagcNkzjjdO1i1?=
 =?us-ascii?Q?AUPCkYvS/WQU5ajVg9OVTIaDM5w7IK0PW6+8ocYzx78pgV/aAME3uDMjI8ro?=
 =?us-ascii?Q?XNaD7xsGoyZaHm2Hz10s/xrDCyNuEZaPiZ3dtbGK+5BC4Xvttzr1JW3aNmkd?=
 =?us-ascii?Q?LE+b3eqPmu8DSABqV8ZwYU82oBJaTES5mU0iiZQd+QTjo3GgWbqcA0w9wHd3?=
 =?us-ascii?Q?wWGeI1hyO89g8h0Rotc7U4hdy2V8ZxLdAQw4wNqZiF/VJ03jfHcQyIVMwWis?=
 =?us-ascii?Q?jZrARJoQknDbnJc8Bx7eat0NVlzMSRMmdGJAgw3ZvQIosesvi0ZnWmkthiIT?=
 =?us-ascii?Q?cEoPP8z73sf8Xb1wuZsH6jYcHb5VreuYuULbzDPuYJNmeM05NftL5+qwg5gF?=
 =?us-ascii?Q?oxcZScrxWiMVX7w6wCpSX7LaU5eMeJwjZZgSzlVf8PcawZpN29HF480YWWvz?=
 =?us-ascii?Q?pSxehKimlTsRMy3QA7vbuS73ntCvSVvW4RWDoHhpHfuFMcsFbmXdV85muly5?=
 =?us-ascii?Q?801PD+gBdACoPt+bsKHDKI0idTwQMHaR77OrfO+sGBAFlUAc1BiibhyMS6fx?=
 =?us-ascii?Q?Xrg8ar2el9ABorgS84ELs0BenPkeS1BRnoLCWTinR4xFneBM5TruJipRs5S7?=
 =?us-ascii?Q?F2ZFHu4QlNDyx/qWJkv7zUqsUkDm7O/uwoHrLdLFG3a32CvPcTkG9sapOMWD?=
 =?us-ascii?Q?Vbzd5n2/75gXSH+3sYVp6yIYI6kQBa9T9p/9Wb8MzM0Fv3Dj959Ocpq3rFGK?=
 =?us-ascii?Q?4u0B6VxHgbO9dYAjrbn859/WMKJ6VfeMt1XfMfvlg/pmkd3hHJfzWm9YlWmG?=
 =?us-ascii?Q?X1T+jJi+NxRU/P1hj85gAhkhuU7sepW9d9eeFD7BE5xIWqoDxUSUSNT8Ktsr?=
 =?us-ascii?Q?5IC9LB0Gact8I7y/SYQj4JhEFeygTaOfFCQn6FX3dtfg0HjTKzwgPJddo63K?=
 =?us-ascii?Q?NaobG4FqzH60EVMnPntPxaSAW/6dDdXxcOZU1cYwEjsj2dU8Ksgr925grlNm?=
 =?us-ascii?Q?NxBaPuAbigzxJ5VeQc00StR/moRMV+32j0kOAv86xK1G9duFaXKHiv9UZiGX?=
 =?us-ascii?Q?0w5RfbdWmPIr8gp3YG3rmreEz9y/p8TwCQ0tYhBIM4ZxxNcTj8uk7pp2NH2a?=
 =?us-ascii?Q?hTdNlHRHEAFlXXPaiE2hu/JPOZpctIoDj5g6n978X3+zK4e829WxM3DJXnpv?=
 =?us-ascii?Q?Sthgpv62jj32d+3mQPDOGKdhBqY6yeOYZy7lYJjGasaBQzeCJIiSCO5+FAb+?=
 =?us-ascii?Q?zbqx25nGIGs2gVMyAIxbAY5wc0iSqNkf+V+wMlW4T/T0H5EmrWXV9iYBD4lf?=
 =?us-ascii?Q?ErhcgTv9gNqbja0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NQ8jnWZFld244PzvB5eagNoq7mCZd/FVMBS9pgtmd7ojAsB6GpQMe0Z+CCao?=
 =?us-ascii?Q?99GX71D6cxQjLLc58ZM9QHUq8j4XvrOsE0fsAsjDksFrA7vcW5ad9Md+sRKz?=
 =?us-ascii?Q?h6Yxdix08DdZn9y56h/GMsKvy3uVqMdWB7uq5JCAUQwb40SYwqYuWZjbvk5d?=
 =?us-ascii?Q?eMotjTJlFf0jhJ9zPR8NfS975mP2o6jaiyUi38y5JN8Rw6BoDw4SujmP7CPa?=
 =?us-ascii?Q?MXxhvwQhgbWdaKB+unihL1mRHIsSuEKBvGouadw/PiMhs/qrFcH+1jME6kkr?=
 =?us-ascii?Q?6dKZ3WbKBQU1saF1znbqL7yhBZNCJ9g0CpfWB8FpUAOoTVFLbz8WP5PhjPXU?=
 =?us-ascii?Q?YOJ1hKj/B9b46E+upyzvRUkhNQWGIfcXlmTQxrrg4ebx79S8FopfMNQ4iMNJ?=
 =?us-ascii?Q?cTLUne+KhoyYLtkBESy6xTtOW8Oun1AHo+mxL5uT1fVPs4AvukeWuMCJdawj?=
 =?us-ascii?Q?Be3VppVNfk9l3anOyccEUNhYzBdGpgU/7O1l70Chtzzjzp2OOmKFAoCL5zrF?=
 =?us-ascii?Q?4tvabGcSLX8FtE64RejSXBkD7tmr6oS7Hv/pfzcKdkv8ucPr9BcYfQV6zJNH?=
 =?us-ascii?Q?jvcMCB4B9mS1Z9h9eV2OOi96ZYBqdbLx7zkfzAEFLWasyWpB6eLS2fBg3kst?=
 =?us-ascii?Q?R1pJcOKBeFgMLuvEzbRXLUE7Rk+/Fa1Wxh7dRJ9U0uOIGUSULVJ4wNrL+f6Z?=
 =?us-ascii?Q?++K4+bCMnZsEe0c+/8D36e17YLas+eZ/kqahFui9yyPUzLohQoms9JjOc6qp?=
 =?us-ascii?Q?vTlv3qN61y3tb8DQxR33so5ILT6JnBRvbaSw80JFqJP2uu70IAL5c7TjDsxt?=
 =?us-ascii?Q?qgM5xIl66dzU7CxrMrrl2lR6RI95SbS42V7U8AlFwF9gpDQhJ2gS1Y4F9BYV?=
 =?us-ascii?Q?DgX7uBHkkGNzeAvlLlE0IbBA3UCHASq8eG/c42g+uonItFiqk68uhA3z1MGw?=
 =?us-ascii?Q?FYOHtl60i3vOdhb4SysmSseK1QKCzn6+TywtDtugKCWh53qXRvI6VHvzHqCO?=
 =?us-ascii?Q?bmBo8nVpPVImcflDfj/Nhmp1pq+icKwL2M2gSzElkxvrs7a6p9fSDlPgeyg5?=
 =?us-ascii?Q?ZZfX8AJWSqkCXBfuujnj/PENq+J7m1tqFbeJZ+eLzjffOqhsYRDcFBfR8VpL?=
 =?us-ascii?Q?ngRpaLvKbEK8pmwFI3wiil3q4qm7kxdblDSXhhohVrf7fqgpss1QTgtHkqAs?=
 =?us-ascii?Q?0oVgS1UzIP/jkaC+3RuAYTUQ6kaBapMnkxb6tEvkfosOfAXuAOO58NjzQhJK?=
 =?us-ascii?Q?gvmlP+kt/bBy1tkkbCr6it8JbJHGw3gReT6rBp9aphiHELBHIO77N5iYFJTz?=
 =?us-ascii?Q?eaHgH/rXAopYoRYkeHJ4ziVlw47GxbnpJ82dpcEVOaWGezcMp+WGF9sW3tS8?=
 =?us-ascii?Q?XbMUMNG6OYZfuwv06YVJ9+3bCkN8xm0Rzq2b649HW8JZTE3SUAI7AKYz1rMp?=
 =?us-ascii?Q?xvOpohJ7fzXsdBz5CjZBsaz/TPwoOpKlYUtYDy51pPsu5L2ugA/Zzp3T6BUB?=
 =?us-ascii?Q?tfBRYQRm0uY4gqFHurxn+arYvP9LmSHTveXfP96RQakyGGSO7AE5E7+HHTEl?=
 =?us-ascii?Q?hGhsEZF9YmwYdZxLejUXWWZFiyI7RuLI86/Lvbda78ZK6l63URy7dQhsUYbT?=
 =?us-ascii?Q?8A=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e5a729-a6be-4b0b-5644-08dda259d419
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 04:48:05.6089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0mlJXRrGHd0IIJ6/BLv/aSFQ80FsUdhapNdT2vfSxieTxuT/RJvul58cxcRvJyWEE1DnXehW7sn/dGXoT84LF8Jr9rUIX/fuFYBqXLtFdpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6604
X-Proofpoint-ORIG-GUID: eG2jedcUDiKDBWGnGh_cPFZwwQvZuwum
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDAzOSBTYWx0ZWRfXxLqGxwwfJO1q zy20EWKymObPvMULoLt7imT7ebBE6UaJmneXQrK2aVGsOTDA4T9uUi0ypqc0PdsywQvq9l9Y3Xn gsf8V4136eQGVjfo/EKeT+i5ubwnTAvTliXFcyGSBi9dUIAfdZx3drQ/ZkU5utm756335xdGSMo
 l0IvLezlgwr5E6kb0cH1aWspeTT31tWxA/jGRbvDKfFUfaQaU1JI54TlhwPLLlFBpGHHOJ6t8M6 OYCrql1AjcGHfxmnHHNdILZ7S3VXiSFgE0Z03wYg95Kg4vXTrQr43MOdPLPirCzIayZiHX/9mlE pslMWVesDbbEkdaNiyOKUncL2K4tOLwwbmkBRJe+nACkmAfrtbvEQtRbu3u2duQTS/yt9rtQFmI
 zYomvtVOaSNKW+MFqEssY4aKSGufIY2t5+CIeTKcR/XMI1CufDMho0eO5d+hgI31LnB6KQXC
X-Proofpoint-GUID: eG2jedcUDiKDBWGnGh_cPFZwwQvZuwum
X-Authority-Analysis: v=2.4 cv=EKsG00ZC c=1 sm=1 tr=0 ts=683e7e8a cx=c_pps a=atuiHV64BiHqJ9S8Hsrx8A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=eEX6wFUxkSk7giWrztoA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-03_01,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

No functional change intended.

Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
---
 x86/svm_npt.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index b791f1ac..09c33783 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -16,7 +16,7 @@ static void npt_np_prepare(struct svm_test *test)
 	scratch_page = alloc_page();
 	pte = npt_get_pte((u64) scratch_page);
 
-	*pte &= ~1ULL;
+	*pte &= ~PT_PRESENT_MASK;
 }
 
 static void npt_np_test(struct svm_test *test)
@@ -28,7 +28,7 @@ static bool npt_np_check(struct svm_test *test)
 {
 	u64 *pte = npt_get_pte((u64) scratch_page);
 
-	*pte |= 1ULL;
+	*pte |= PT_PRESENT_MASK;
 
 	return (vmcb->control.exit_code == SVM_EXIT_NPF)
 	    && (vmcb->control.exit_info_1 == 0x100000004ULL);
@@ -68,7 +68,7 @@ static void npt_us_prepare(struct svm_test *test)
 	scratch_page = alloc_page();
 	pte = npt_get_pte((u64) scratch_page);
 
-	*pte &= ~(1ULL << 2);
+	*pte &= ~PT_USER_MASK;
 }
 
 static void npt_us_test(struct svm_test *test)
@@ -80,7 +80,7 @@ static bool npt_us_check(struct svm_test *test)
 {
 	u64 *pte = npt_get_pte((u64) scratch_page);
 
-	*pte |= (1ULL << 2);
+	*pte |= PT_USER_MASK;
 
 	return (vmcb->control.exit_code == SVM_EXIT_NPF)
 	    && (vmcb->control.exit_info_1 == 0x100000005ULL);
@@ -93,7 +93,7 @@ static void npt_rw_prepare(struct svm_test *test)
 
 	pte = npt_get_pte(0x80000);
 
-	*pte &= ~(1ULL << 1);
+	*pte &= ~PT_WRITABLE_MASK;
 }
 
 static void npt_rw_test(struct svm_test *test)
@@ -107,7 +107,7 @@ static bool npt_rw_check(struct svm_test *test)
 {
 	u64 *pte = npt_get_pte(0x80000);
 
-	*pte |= (1ULL << 1);
+	*pte |= PT_WRITABLE_MASK;
 
 	return (vmcb->control.exit_code == SVM_EXIT_NPF)
 	    && (vmcb->control.exit_info_1 == 0x100000007ULL);
@@ -120,14 +120,14 @@ static void npt_rw_pfwalk_prepare(struct svm_test *test)
 
 	pte = npt_get_pte(read_cr3());
 
-	*pte &= ~(1ULL << 1);
+	*pte &= ~PT_WRITABLE_MASK;
 }
 
 static bool npt_rw_pfwalk_check(struct svm_test *test)
 {
 	u64 *pte = npt_get_pte(read_cr3());
 
-	*pte |= (1ULL << 1);
+	*pte |= PT_WRITABLE_MASK;
 
 	return (vmcb->control.exit_code == SVM_EXIT_NPF)
 	    && (vmcb->control.exit_info_1 == 0x200000007ULL)
@@ -164,7 +164,7 @@ static void npt_rw_l1mmio_prepare(struct svm_test *test)
 
 	pte = npt_get_pte(0xfee00080);
 
-	*pte &= ~(1ULL << 1);
+	*pte &= ~PT_WRITABLE_MASK;
 }
 
 static void npt_rw_l1mmio_test(struct svm_test *test)
@@ -178,7 +178,7 @@ static bool npt_rw_l1mmio_check(struct svm_test *test)
 {
 	u64 *pte = npt_get_pte(0xfee00080);
 
-	*pte |= (1ULL << 1);
+	*pte |= PT_WRITABLE_MASK;
 
 	return (vmcb->control.exit_code == SVM_EXIT_NPF)
 	    && (vmcb->control.exit_info_1 == 0x100000007ULL);
-- 
2.49.0



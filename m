Return-Path: <kvm+bounces-42654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9766BA7BF19
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 16:25:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8CA63B7D4D
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 14:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53D91F3D30;
	Fri,  4 Apr 2025 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mHexGi2u";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="izhjF6KF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657401EEA30;
	Fri,  4 Apr 2025 14:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743776666; cv=fail; b=fGlphTfnaWMnby+1eqnTo/KsltKZfp4dMxaILmjFHx3rCDnAIUSGs52HZyYglRocxzFIz42Zkeg83pA5FeFvDPNIGyQprQ/jtOOsQlO1O72N/mHKD9WDxev6/APdcV198Gq2GDD3qLJktQKb2Yu+PepcYgWd+PYaIBDHUyC7/uc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743776666; c=relaxed/simple;
	bh=PzG5rs2GoRAQPM3/xUfN9OgNzH4eTIYuXOHxD2XDprw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=AW8gPDdoFKgL3bw1/s5ZsN0X/eEiaPPJ01WUqjs0RiZdJB5WzG5Te6Ae0HiG/T1NZEyL8wfCIlF4PdbAxxlGIUHiHU0jWER1QfALIG82t6jlqFbmjenCS2oF2twq+I4q0CXIHHhT0ABm4M0wHBDPpuGs4OoxWMbew03zY67eKC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mHexGi2u; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=izhjF6KF; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 534DtduL000897;
	Fri, 4 Apr 2025 07:24:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=7GQibaWwUJrm8
	OgqOYUaJPGxBHng9O6EpUuhMe5FRCA=; b=mHexGi2uoK8vIBg53YzQmxk2f/IBj
	dhqazHnEiheU+4hBUPbW+IqWW0jEgWYs7lMweUtV1SEIHgYrY7HEgUr0M8CW5Ygm
	OVB83/eGevhV3oPCTJ+BI3IWDg7bi9DW6UZFVdDzo7vRnzJJJmRLLaWdbf5TKUUR
	xVC/e3C23VOpUd872v5V2E2cTt2mJFRQSpdN41wC9posJ6niC3CGCSgnOd8sZHvn
	CumNjHCqTy5pcgHP7jjQFrmhp/kqYnhqce+hBwUAnLJLVOC39Atgb0ILpR4HYTDR
	HyXHhMpc3yLTz35CPC/3ORv93T80X4AezL7EB/BIuhoK3wjp40dEEFzag==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45pcs95v6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 07:24:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sqKQApMjJDiCF4hNvvBCv1u/xoMgD3Bk+JaOglbrtGtbv658Doq4Pi7uSDT9pmdYIxSREQFfXjbmVOxJG08GOTE5svQl1rcL/H0j2+lZLrBDE5FD8Q6IwF3zh3VtbD5zul83GedxdQ9rdHcoosOh7A7eLeHRKVf/f44vD0/1WtIB2EpLmCrZ2Ne0MqqqocVZXqeJHu4YcU5J+aD5YnfrgTL4TsWIsTpx9TmCcrbQ3Hi4C1TzP1PMbLCVpQ9oXtmOBeq9zMeBnbEI+qBamt0AauT8xUgVUSfoSClLVBBabqEVITWY86FMhhbcXZv4ssOudjvzcRT4Bo49eut2je4kSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7GQibaWwUJrm8OgqOYUaJPGxBHng9O6EpUuhMe5FRCA=;
 b=e1eQcExTH0mAeZbEGXlQG2ILGYam6ub11JAAupkhld2fr+uKME/qpHZCONOA5AA7p1YJ5YWGVhTk4KYskXonYF2ROGjlvL+GpXru22UYKEftVBIjI/kU2giw8sxC4P5rDXUUqD6DoKlCPyq3BEfutTzi+Ve/7V3SeuNbOFgVw5Tz7edHNkb+T5fEqQ7qQcKKvcMgC4hv8kAXSDMP963bg/wGNbPmr/j86Oz6scBUWF6RShENCswUyqkXekBbUlpSgMwDAWdtM97LXuRcOn1KbgiY21fkg6awbtM2FySRR+z4fkCug4+sFr45OpgA7UfhiKkYpy1ZlXO3qSmqnu13FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7GQibaWwUJrm8OgqOYUaJPGxBHng9O6EpUuhMe5FRCA=;
 b=izhjF6KFCc8XRzYnrPSy966alxw6F2+oWvV6/FBFjYTz5wWSf00nP/1rXU4CMCVSODE+8QqHbT6FRnIjenezdYfngFszwf675ENJFm6QfKlwOBCKCiNqP81kxW4Fsx/vhJtasIUTOcFqi8ybWHT4+GMDE/ODRVFz69RtULr0jkYTn5Z17sTbng1zZ82+Y2ydPgvxvV6T3HWAb75zXe/CmnbvGdC1fKHC4F3BgGM51o2/w5BuvEU/G4v/pb9MoyPo0VjG9RLgbZFJbg/PUVQuejSNkMidQivWiva/1re5VkQ6NH/MxO+5VzaN9vIegbtD3xlIgqpUNai+eWtjj2uUHg==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by CO6PR02MB8833.namprd02.prod.outlook.com
 (2603:10b6:303:144::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.52; Fri, 4 Apr
 2025 14:24:05 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.048; Fri, 4 Apr 2025
 14:24:04 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [PATCH] vhost/net: remove zerocopy support
Date: Fri,  4 Apr 2025 07:52:40 -0700
Message-ID: <20250404145241.1125078-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR22CA0019.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::28) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|CO6PR02MB8833:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a3ba352-438b-4d8b-5e3b-08dd73845a4b
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dBrieaQRGe7YGs+nE9Y7eF6OGWFNIRdl9PjKzvM0jhMMnZ7UQTWAQ0y66syn?=
 =?us-ascii?Q?yZ46g8IWf8QCwHVQgjvWBbgRoNl3Hf9ZQcFB3F/9FchXvXobfscBTCjcO8SO?=
 =?us-ascii?Q?hJrRoXGpNXqvXdZP90Rhcxg1Y8JJRIk4EprdU8IHKdFigmwXpjtDDPNENAl7?=
 =?us-ascii?Q?xTFGrvyroZNcuih+e1kbt/6r4E3kUH4U2g2GVixgicIijaRSRRet6NV60vr8?=
 =?us-ascii?Q?zrMqFJ7DOGMaaD+KU5t6dJ4wXSh1Y39SPbTncw1vp7QBC2EmxT+ZStBsTDFI?=
 =?us-ascii?Q?sNbjcU0+L/T5eTaCWSFKA5/ft5mfERBAshgL/sfChpw7vkxSjz2e6O7oInyl?=
 =?us-ascii?Q?VGCFhCWz3lE5oVboEywrjFJWoL37LVY8xqUFHsPSu29+DI4s4Tr0/vAmzdcM?=
 =?us-ascii?Q?DHZOpGw4txaC3WIXIu6UMWx9r0j6KIBW+X7tFvJ+oe1pGdYtAtbhWX3E8AC7?=
 =?us-ascii?Q?E+ztKxx+zS11b5FI1mkqwYtvQ3MfN9K1bhfg/ZEDwtup1QUgvLUOvG4v9oV8?=
 =?us-ascii?Q?Tha7AO5uq1nx7zLum9UtI6s5k01lcUcYzgWRKN2XPKOs4wwUGBp/4Hq6px+y?=
 =?us-ascii?Q?XOMjCGPSmduRjS6PPecBnf6HYU1l7EqDudJygrI7fsbiesSsVPLa6bksXpIw?=
 =?us-ascii?Q?C2m5kEo8Zew5x5owGYWPKy7PV7VHG5vC5NKCApgE4ucq8XWBf6AKMDitJBvT?=
 =?us-ascii?Q?Ki1Oh+9xPJDJxSm8QsCdOGVguGCRLWaYKe1xnnsXTNFTDDPBImO4jTostp45?=
 =?us-ascii?Q?GNEIRd8Ee9eTWhoVqqGdIDPpvBsaT/xp0lGHg9i5GqZC2I9I/JO60a+sxVHS?=
 =?us-ascii?Q?mVWWt3QwSr4GjrnhxH0xtALFH9fpTgG5mK+VkMmh3ruku7f4nM1VaZi4hNlS?=
 =?us-ascii?Q?aymIMp/nbJIhxAaUd1dvf/c7KsCh0F0i57x6umk1UVOKAnXJWaao9nB4cuWx?=
 =?us-ascii?Q?fCW/zGLbd7vVQB7TjbQag22+oGY1ocVnvA9j685U+9VeFNhGvyUkFo1XdhgI?=
 =?us-ascii?Q?RHEvnnkhA03r8OBVAw3UZ4EQYWXclm4vrch69f8k7j43iFnVlgneNFUPfbL9?=
 =?us-ascii?Q?1UFUXMgLMHWLzX+pNODhbMdqBMYUnkb/OplBWzZFE3iDboRrBkNSc8TkbsL0?=
 =?us-ascii?Q?KkptCbvksEwVCuVCXzIaoSo2ng/5wl8GDA+5MfvamrptnG9OtAIRpS4iRzZL?=
 =?us-ascii?Q?wmWqxG+AN9DiibUBhRHp/CxZyWPHCAKufiCjBxjXR8OG26Dw/Cbeq7n4y3kt?=
 =?us-ascii?Q?hhBoT5JGvam8W0iVwCGjgR6lF4hMjyZGDp5EA1O/IQs5RHnm1U6atDkfMznL?=
 =?us-ascii?Q?gwCieMzuIwN9x+XoCHylDGNBdDmznZ1Ad7RFRNt6RQiz2AyZN0/5dSrVtId3?=
 =?us-ascii?Q?v7RDRjsc7kA3M4yhH5fMG+c3zHGWYu949i/tVMmmhVKnEvj+Lquo3QdXcyd1?=
 =?us-ascii?Q?XMtyn/BRD+V6YOLJBkxl7E3sYDbm2NLB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sTl/92d6sIp6YlaXKhBept/TilJbRLaU7Gr1ZgzNrmStJuABCTW4v0zvnMFP?=
 =?us-ascii?Q?EP6QkDGuhrzAgvVgzXs6tBrOuMHEhPi6g1p3lazguIVoO3WZNMuv00by6N/S?=
 =?us-ascii?Q?VnIqcwh51LUGydD3laSU85kITSJI65JRpe5AQFv3WcpbO87hNEecLlzJ1+7A?=
 =?us-ascii?Q?+IzShvdtjU81LLpad0miBPg7IXpjF2Loo70NpRDSx1Hb0R2i+CYL+FZFQGG/?=
 =?us-ascii?Q?rM/vEf6TdFevI7XQpxHd/FbHzc3TLggpAfMnOFCVSNr/193s+XVHlETpH3k1?=
 =?us-ascii?Q?n3A/V/hhwYqDVbUWeZuW1modI0rFcV+pOsAHOH5tjg43mZ4OL2EWT4gXy3ds?=
 =?us-ascii?Q?mL/DJaqO4GvgrQwooIK56Xdxbu1GDR4A882RD9c0o7PLu0aM3l/bmCfSka38?=
 =?us-ascii?Q?n2j9yfEcpJgsKfeahIavgXQMIdB9Yzfm0FT3QvAM94ggb9XV3jIcNptTYjKc?=
 =?us-ascii?Q?FMqxtL5sMQx7Sd9lm72HXMw8wLaYTAWzW8j8JFYRJody4yhStE5Uenv+vNBd?=
 =?us-ascii?Q?7FYSAV7AH8ylQlnYAHSQA0m34m8a2MEb1nm/S65sJrESuxQ7PuIfCq7OGDK2?=
 =?us-ascii?Q?OEvW/XN/EisLtNUAKqqHksPKXEsBDqX7cKc//iOJeJlq0uaW0oYldoaPxt29?=
 =?us-ascii?Q?hINDwpK3Wjo5ou5dZllZyFzoPkBVfxIA0J0TxeEfoksg+hP1A85hjJwLdOCB?=
 =?us-ascii?Q?IDFCeY4uZYgYIOnHVPnMeA6xOTtdsPRYJpDUz1VVitnL4VbH93wUIHLwDdVN?=
 =?us-ascii?Q?/jrOy3bI8yS7A7uVshF5Ugpy53R6dMruU61AtkjBJx/xxvxm2bU6VgrW4a6p?=
 =?us-ascii?Q?WlgG79RCqfAYDJ5h0SXYo3h5/BmLwo/y90qDa8g9LPfqXNGeCF+P+ESt4M2U?=
 =?us-ascii?Q?+vtGJiGz4/OSwcP5mzymp0DWwieYrEbSyuKI8qsZePNb44VJ6ZH+uCWqe0lm?=
 =?us-ascii?Q?d5igXlmByvlUPi/bnpMPbXmKahMnsZ7IZdLsCwoxKrNNxpunZvGYQA85YyPv?=
 =?us-ascii?Q?U2F40jIZm2srz3Tt7AKghI7aQob5eMOmoT/3k97hV1+h4J2uXt1r/zNw3wKU?=
 =?us-ascii?Q?H5iKFTwEm/N1+LXV6/uBe3wa9z7xfV4O3ZpXWOQkBXO4CVXHFeuXxVRCjbKE?=
 =?us-ascii?Q?prM2EjLVMvTcsKnDzVxzEvq4iegDyOU8bgn+HtMf8dmCPcv3uiOYuk7Tci0k?=
 =?us-ascii?Q?XD2ppuAnN4/Aj/e7jzfYLuAvq3oWu9frvUpkPypN7Y7m6HOyngLv0FZ/lzgc?=
 =?us-ascii?Q?4nFxtWUvlUeKQZoYfkKi7MSRk2CnYwniLI10oCjcupOU+VWJ7ti0P6e+1wDN?=
 =?us-ascii?Q?arGMTjshD8OdfHmVP1yQqDb+5K6pio/9+Jwaz+GDbBjb7M9SfNaHssEjhN/6?=
 =?us-ascii?Q?qHPjEXhIDZiLeVY+HrACig+R8u/Oz4eOo5dQCF7msRCGVBbHFoFpl5c0534T?=
 =?us-ascii?Q?eIAxWsJfnCizeXnadeoh7gmct2c357HvGEELx+xIS95Ko2JBt4TQ8mnwrJIk?=
 =?us-ascii?Q?aCvjXgtgATt+4Kdi8ALjsZ4JA2qjhkSBqL+IWKo/e37+AvTgv3hh9t9B3Nd9?=
 =?us-ascii?Q?kSF3KzkCd+HIck+pVAEKw5DFNy8nAFJ4x1NZaNzISaMEsQP3ky7zYJS6GTdN?=
 =?us-ascii?Q?7Q=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a3ba352-438b-4d8b-5e3b-08dd73845a4b
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 14:24:04.6839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lX17ElwgTq0+EIFtTVQhtyxbxPEOVoiVkJpxPNE0AvLEvd9dRotOLo8WJBLnfx2fagHMDu9URZlC4T8BpBSKqz/yheFAy3lt7UhNakhnPV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB8833
X-Proofpoint-GUID: -SPhi-sPVmkl2g1WeKK-vIVfH9NhH6mD
X-Proofpoint-ORIG-GUID: -SPhi-sPVmkl2g1WeKK-vIVfH9NhH6mD
X-Authority-Analysis: v=2.4 cv=PMMP+eqC c=1 sm=1 tr=0 ts=67efeb88 cx=c_pps a=S2IcI55zTQM2EKrhu3zyRw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10
 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=2jTnxWR0YVj3-zsDKhwA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_06,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

Commit 098eadce3c62 ("vhost_net: disable zerocopy by default") disabled
the module parameter for the handle_tx_zerocopy path back in 2019,
nothing that many downstream distributions (e.g., RHEL7 and later) had
already done the same.

Both upstream and downstream disablement suggest this path is rarely
used.

Testing the module parameter shows that while the path allows packet
forwarding, the zerocopy functionality itself is broken. On outbound
traffic (guest TX -> external), zerocopy SKBs are orphaned by either
skb_orphan_frags_rx() (used with the tun driver via tun_net_xmit()) or
skb_orphan_frags() elsewhere in the stack, as vhost_net does not set
SKBFL_DONT_ORPHAN.

Orphaning enforces a memcpy and triggers the completion callback, which
increments the failed TX counter, effectively disabling zerocopy again.

Even after addressing these issues to prevent SKB orphaning and error
counter increments, performance remains poor. By default, only 64
messages can be zerocopied, which is immediately exhausted by workloads
like iperf, resulting in most messages being memcpy'd anyhow.

Additionally, memcpy'd messages do not benefit from the XDP batching
optimizations present in the handle_tx_copy path.

Given these limitations and the lack of any tangible benefits, remove
zerocopy entirely to simplify the code base.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 drivers/vhost/net.c | 398 +-------------------------------------------
 1 file changed, 2 insertions(+), 396 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b9b9e9d40951..d16cb8f69591 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -35,11 +35,6 @@
 
 #include "vhost.h"
 
-static int experimental_zcopytx = 0;
-module_param(experimental_zcopytx, int, 0444);
-MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
-		                       " 1 -Enable; 0 - Disable");
-
 /* Max number of bytes transferred before requeueing the job.
  * Using this limit prevents one virtqueue from starving others. */
 #define VHOST_NET_WEIGHT 0x80000
@@ -50,25 +45,6 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
  */
 #define VHOST_NET_PKT_WEIGHT 256
 
-/* MAX number of TX used buffers for outstanding zerocopy */
-#define VHOST_MAX_PEND 128
-#define VHOST_GOODCOPY_LEN 256
-
-/*
- * For transmit, used buffer len is unused; we override it to track buffer
- * status internally; used for zerocopy tx only.
- */
-/* Lower device DMA failed */
-#define VHOST_DMA_FAILED_LEN	((__force __virtio32)3)
-/* Lower device DMA done */
-#define VHOST_DMA_DONE_LEN	((__force __virtio32)2)
-/* Lower device DMA in progress */
-#define VHOST_DMA_IN_PROGRESS	((__force __virtio32)1)
-/* Buffer unused */
-#define VHOST_DMA_CLEAR_LEN	((__force __virtio32)0)
-
-#define VHOST_DMA_IS_DONE(len) ((__force u32)(len) >= (__force u32)VHOST_DMA_DONE_LEN)
-
 enum {
 	VHOST_NET_FEATURES = VHOST_FEATURES |
 			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
@@ -87,17 +63,6 @@ enum {
 	VHOST_NET_VQ_MAX = 2,
 };
 
-struct vhost_net_ubuf_ref {
-	/* refcount follows semantics similar to kref:
-	 *  0: object is released
-	 *  1: no outstanding ubufs
-	 * >1: outstanding ubufs
-	 */
-	atomic_t refcount;
-	wait_queue_head_t wait;
-	struct vhost_virtqueue *vq;
-};
-
 #define VHOST_NET_BATCH 64
 struct vhost_net_buf {
 	void **queue;
@@ -109,20 +74,9 @@ struct vhost_net_virtqueue {
 	struct vhost_virtqueue vq;
 	size_t vhost_hlen;
 	size_t sock_hlen;
-	/* vhost zerocopy support fields below: */
-	/* last used idx for outstanding DMA zerocopy buffers */
-	int upend_idx;
-	/* For TX, first used idx for DMA done zerocopy buffers
-	 * For RX, number of batched heads
-	 */
 	int done_idx;
 	/* Number of XDP frames batched */
 	int batched_xdp;
-	/* an array of userspace buffers info */
-	struct ubuf_info_msgzc *ubuf_info;
-	/* Reference counting for outstanding ubufs.
-	 * Protected by vq mutex. Writers must also take device mutex. */
-	struct vhost_net_ubuf_ref *ubufs;
 	struct ptr_ring *rx_ring;
 	struct vhost_net_buf rxq;
 	/* Batched XDP buffs */
@@ -133,20 +87,10 @@ struct vhost_net {
 	struct vhost_dev dev;
 	struct vhost_net_virtqueue vqs[VHOST_NET_VQ_MAX];
 	struct vhost_poll poll[VHOST_NET_VQ_MAX];
-	/* Number of TX recently submitted.
-	 * Protected by tx vq lock. */
-	unsigned tx_packets;
-	/* Number of times zerocopy TX recently failed.
-	 * Protected by tx vq lock. */
-	unsigned tx_zcopy_err;
-	/* Flush in progress. Protected by tx vq lock. */
-	bool tx_flush;
 	/* Private page frag cache */
 	struct page_frag_cache pf_cache;
 };
 
-static unsigned vhost_net_zcopy_mask __read_mostly;
-
 static void *vhost_net_buf_get_ptr(struct vhost_net_buf *rxq)
 {
 	if (rxq->tail != rxq->head)
@@ -224,90 +168,12 @@ static void vhost_net_buf_init(struct vhost_net_buf *rxq)
 	rxq->head = rxq->tail = 0;
 }
 
-static void vhost_net_enable_zcopy(int vq)
-{
-	vhost_net_zcopy_mask |= 0x1 << vq;
-}
-
-static struct vhost_net_ubuf_ref *
-vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
-{
-	struct vhost_net_ubuf_ref *ubufs;
-	/* No zero copy backend? Nothing to count. */
-	if (!zcopy)
-		return NULL;
-	ubufs = kmalloc(sizeof(*ubufs), GFP_KERNEL);
-	if (!ubufs)
-		return ERR_PTR(-ENOMEM);
-	atomic_set(&ubufs->refcount, 1);
-	init_waitqueue_head(&ubufs->wait);
-	ubufs->vq = vq;
-	return ubufs;
-}
-
-static int vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
-{
-	int r = atomic_sub_return(1, &ubufs->refcount);
-	if (unlikely(!r))
-		wake_up(&ubufs->wait);
-	return r;
-}
-
-static void vhost_net_ubuf_put_and_wait(struct vhost_net_ubuf_ref *ubufs)
-{
-	vhost_net_ubuf_put(ubufs);
-	wait_event(ubufs->wait, !atomic_read(&ubufs->refcount));
-}
-
-static void vhost_net_ubuf_put_wait_and_free(struct vhost_net_ubuf_ref *ubufs)
-{
-	vhost_net_ubuf_put_and_wait(ubufs);
-	kfree(ubufs);
-}
-
-static void vhost_net_clear_ubuf_info(struct vhost_net *n)
-{
-	int i;
-
-	for (i = 0; i < VHOST_NET_VQ_MAX; ++i) {
-		kfree(n->vqs[i].ubuf_info);
-		n->vqs[i].ubuf_info = NULL;
-	}
-}
-
-static int vhost_net_set_ubuf_info(struct vhost_net *n)
-{
-	bool zcopy;
-	int i;
-
-	for (i = 0; i < VHOST_NET_VQ_MAX; ++i) {
-		zcopy = vhost_net_zcopy_mask & (0x1 << i);
-		if (!zcopy)
-			continue;
-		n->vqs[i].ubuf_info =
-			kmalloc_array(UIO_MAXIOV,
-				      sizeof(*n->vqs[i].ubuf_info),
-				      GFP_KERNEL);
-		if  (!n->vqs[i].ubuf_info)
-			goto err;
-	}
-	return 0;
-
-err:
-	vhost_net_clear_ubuf_info(n);
-	return -ENOMEM;
-}
-
 static void vhost_net_vq_reset(struct vhost_net *n)
 {
 	int i;
 
-	vhost_net_clear_ubuf_info(n);
-
 	for (i = 0; i < VHOST_NET_VQ_MAX; i++) {
 		n->vqs[i].done_idx = 0;
-		n->vqs[i].upend_idx = 0;
-		n->vqs[i].ubufs = NULL;
 		n->vqs[i].vhost_hlen = 0;
 		n->vqs[i].sock_hlen = 0;
 		vhost_net_buf_init(&n->vqs[i].rxq);
@@ -315,103 +181,11 @@ static void vhost_net_vq_reset(struct vhost_net *n)
 
 }
 
-static void vhost_net_tx_packet(struct vhost_net *net)
-{
-	++net->tx_packets;
-	if (net->tx_packets < 1024)
-		return;
-	net->tx_packets = 0;
-	net->tx_zcopy_err = 0;
-}
-
-static void vhost_net_tx_err(struct vhost_net *net)
-{
-	++net->tx_zcopy_err;
-}
-
-static bool vhost_net_tx_select_zcopy(struct vhost_net *net)
-{
-	/* TX flush waits for outstanding DMAs to be done.
-	 * Don't start new DMAs.
-	 */
-	return !net->tx_flush &&
-		net->tx_packets / 64 >= net->tx_zcopy_err;
-}
-
-static bool vhost_sock_zcopy(struct socket *sock)
-{
-	return unlikely(experimental_zcopytx) &&
-		sock_flag(sock->sk, SOCK_ZEROCOPY);
-}
-
 static bool vhost_sock_xdp(struct socket *sock)
 {
 	return sock_flag(sock->sk, SOCK_XDP);
 }
 
-/* In case of DMA done not in order in lower device driver for some reason.
- * upend_idx is used to track end of used idx, done_idx is used to track head
- * of used idx. Once lower device DMA done contiguously, we will signal KVM
- * guest used idx.
- */
-static void vhost_zerocopy_signal_used(struct vhost_net *net,
-				       struct vhost_virtqueue *vq)
-{
-	struct vhost_net_virtqueue *nvq =
-		container_of(vq, struct vhost_net_virtqueue, vq);
-	int i, add;
-	int j = 0;
-
-	for (i = nvq->done_idx; i != nvq->upend_idx; i = (i + 1) % UIO_MAXIOV) {
-		if (vq->heads[i].len == VHOST_DMA_FAILED_LEN)
-			vhost_net_tx_err(net);
-		if (VHOST_DMA_IS_DONE(vq->heads[i].len)) {
-			vq->heads[i].len = VHOST_DMA_CLEAR_LEN;
-			++j;
-		} else
-			break;
-	}
-	while (j) {
-		add = min(UIO_MAXIOV - nvq->done_idx, j);
-		vhost_add_used_and_signal_n(vq->dev, vq,
-					    &vq->heads[nvq->done_idx], add);
-		nvq->done_idx = (nvq->done_idx + add) % UIO_MAXIOV;
-		j -= add;
-	}
-}
-
-static void vhost_zerocopy_complete(struct sk_buff *skb,
-				    struct ubuf_info *ubuf_base, bool success)
-{
-	struct ubuf_info_msgzc *ubuf = uarg_to_msgzc(ubuf_base);
-	struct vhost_net_ubuf_ref *ubufs = ubuf->ctx;
-	struct vhost_virtqueue *vq = ubufs->vq;
-	int cnt;
-
-	rcu_read_lock_bh();
-
-	/* set len to mark this desc buffers done DMA */
-	vq->heads[ubuf->desc].len = success ?
-		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
-	cnt = vhost_net_ubuf_put(ubufs);
-
-	/*
-	 * Trigger polling thread if guest stopped submitting new buffers:
-	 * in this case, the refcount after decrement will eventually reach 1.
-	 * We also trigger polling periodically after each 16 packets
-	 * (the value 16 here is more or less arbitrary, it's tuned to trigger
-	 * less than 10% of times).
-	 */
-	if (cnt <= 1 || !(cnt % 16))
-		vhost_poll_queue(&vq->poll);
-
-	rcu_read_unlock_bh();
-}
-
-static const struct ubuf_info_ops vhost_ubuf_ops = {
-	.complete = vhost_zerocopy_complete,
-};
-
 static inline unsigned long busy_clock(void)
 {
 	return local_clock() >> 10;
@@ -585,10 +359,7 @@ static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
 
 	if (r == tvq->num && tvq->busyloop_timeout) {
 		/* Flush batched packets first */
-		if (!vhost_sock_zcopy(vhost_vq_get_backend(tvq)))
-			vhost_tx_batch(net, tnvq,
-				       vhost_vq_get_backend(tvq),
-				       msghdr);
+		vhost_tx_batch(net, tnvq, vhost_vq_get_backend(tvq), msghdr);
 
 		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, false);
 
@@ -599,15 +370,6 @@ static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
 	return r;
 }
 
-static bool vhost_exceeds_maxpend(struct vhost_net *net)
-{
-	struct vhost_net_virtqueue *nvq = &net->vqs[VHOST_NET_VQ_TX];
-	struct vhost_virtqueue *vq = &nvq->vq;
-
-	return (nvq->upend_idx + UIO_MAXIOV - nvq->done_idx) % UIO_MAXIOV >
-	       min_t(unsigned int, VHOST_MAX_PEND, vq->num >> 2);
-}
-
 static size_t init_iov_iter(struct vhost_virtqueue *vq, struct iov_iter *iter,
 			    size_t hdr_size, int out)
 {
@@ -828,113 +590,6 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 	vhost_tx_batch(net, nvq, sock, &msg);
 }
 
-static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
-{
-	struct vhost_net_virtqueue *nvq = &net->vqs[VHOST_NET_VQ_TX];
-	struct vhost_virtqueue *vq = &nvq->vq;
-	unsigned out, in;
-	int head;
-	struct msghdr msg = {
-		.msg_name = NULL,
-		.msg_namelen = 0,
-		.msg_control = NULL,
-		.msg_controllen = 0,
-		.msg_flags = MSG_DONTWAIT,
-	};
-	struct tun_msg_ctl ctl;
-	size_t len, total_len = 0;
-	int err;
-	struct vhost_net_ubuf_ref *ubufs;
-	struct ubuf_info_msgzc *ubuf;
-	bool zcopy_used;
-	int sent_pkts = 0;
-
-	do {
-		bool busyloop_intr;
-
-		/* Release DMAs done buffers first */
-		vhost_zerocopy_signal_used(net, vq);
-
-		busyloop_intr = false;
-		head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
-				   &busyloop_intr);
-		/* On error, stop handling until the next kick. */
-		if (unlikely(head < 0))
-			break;
-		/* Nothing new?  Wait for eventfd to tell us they refilled. */
-		if (head == vq->num) {
-			if (unlikely(busyloop_intr)) {
-				vhost_poll_queue(&vq->poll);
-			} else if (unlikely(vhost_enable_notify(&net->dev, vq))) {
-				vhost_disable_notify(&net->dev, vq);
-				continue;
-			}
-			break;
-		}
-
-		zcopy_used = len >= VHOST_GOODCOPY_LEN
-			     && !vhost_exceeds_maxpend(net)
-			     && vhost_net_tx_select_zcopy(net);
-
-		/* use msg_control to pass vhost zerocopy ubuf info to skb */
-		if (zcopy_used) {
-			ubuf = nvq->ubuf_info + nvq->upend_idx;
-			vq->heads[nvq->upend_idx].id = cpu_to_vhost32(vq, head);
-			vq->heads[nvq->upend_idx].len = VHOST_DMA_IN_PROGRESS;
-			ubuf->ctx = nvq->ubufs;
-			ubuf->desc = nvq->upend_idx;
-			ubuf->ubuf.ops = &vhost_ubuf_ops;
-			ubuf->ubuf.flags = SKBFL_ZEROCOPY_FRAG;
-			refcount_set(&ubuf->ubuf.refcnt, 1);
-			msg.msg_control = &ctl;
-			ctl.type = TUN_MSG_UBUF;
-			ctl.ptr = &ubuf->ubuf;
-			msg.msg_controllen = sizeof(ctl);
-			ubufs = nvq->ubufs;
-			atomic_inc(&ubufs->refcount);
-			nvq->upend_idx = (nvq->upend_idx + 1) % UIO_MAXIOV;
-		} else {
-			msg.msg_control = NULL;
-			ubufs = NULL;
-		}
-		total_len += len;
-		if (tx_can_batch(vq, total_len) &&
-		    likely(!vhost_exceeds_maxpend(net))) {
-			msg.msg_flags |= MSG_MORE;
-		} else {
-			msg.msg_flags &= ~MSG_MORE;
-		}
-
-		err = sock->ops->sendmsg(sock, &msg, len);
-		if (unlikely(err < 0)) {
-			bool retry = err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS;
-
-			if (zcopy_used) {
-				if (vq->heads[ubuf->desc].len == VHOST_DMA_IN_PROGRESS)
-					vhost_net_ubuf_put(ubufs);
-				if (retry)
-					nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
-						% UIO_MAXIOV;
-				else
-					vq->heads[ubuf->desc].len = VHOST_DMA_DONE_LEN;
-			}
-			if (retry) {
-				vhost_discard_vq_desc(vq, 1);
-				vhost_net_enable_vq(net, vq);
-				break;
-			}
-			pr_debug("Fail to send packet: err %d", err);
-		} else if (unlikely(err != len))
-			pr_debug("Truncated TX packet: "
-				 " len %d != %zd\n", err, len);
-		if (!zcopy_used)
-			vhost_add_used_and_signal(&net->dev, vq, head, 0);
-		else
-			vhost_zerocopy_signal_used(net, vq);
-		vhost_net_tx_packet(net);
-	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
-}
-
 /* Expects to be always run from workqueue - which acts as
  * read-size critical section for our kind of RCU. */
 static void handle_tx(struct vhost_net *net)
@@ -954,10 +609,7 @@ static void handle_tx(struct vhost_net *net)
 	vhost_disable_notify(&net->dev, vq);
 	vhost_net_disable_vq(net, vq);
 
-	if (vhost_sock_zcopy(sock))
-		handle_tx_zerocopy(net, sock);
-	else
-		handle_tx_copy(net, sock);
+	handle_tx_copy(net, sock);
 
 out:
 	mutex_unlock(&vq->mutex);
@@ -1307,9 +959,6 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 	n->vqs[VHOST_NET_VQ_TX].vq.handle_kick = handle_tx_kick;
 	n->vqs[VHOST_NET_VQ_RX].vq.handle_kick = handle_rx_kick;
 	for (i = 0; i < VHOST_NET_VQ_MAX; i++) {
-		n->vqs[i].ubufs = NULL;
-		n->vqs[i].ubuf_info = NULL;
-		n->vqs[i].upend_idx = 0;
 		n->vqs[i].done_idx = 0;
 		n->vqs[i].batched_xdp = 0;
 		n->vqs[i].vhost_hlen = 0;
@@ -1360,17 +1009,6 @@ static void vhost_net_stop(struct vhost_net *n, struct socket **tx_sock,
 static void vhost_net_flush(struct vhost_net *n)
 {
 	vhost_dev_flush(&n->dev);
-	if (n->vqs[VHOST_NET_VQ_TX].ubufs) {
-		mutex_lock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
-		n->tx_flush = true;
-		mutex_unlock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
-		/* Wait for all lower device DMAs done. */
-		vhost_net_ubuf_put_and_wait(n->vqs[VHOST_NET_VQ_TX].ubufs);
-		mutex_lock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
-		n->tx_flush = false;
-		atomic_set(&n->vqs[VHOST_NET_VQ_TX].ubufs->refcount, 1);
-		mutex_unlock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
-	}
 }
 
 static int vhost_net_release(struct inode *inode, struct file *f)
@@ -1476,7 +1114,6 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	struct socket *sock, *oldsock;
 	struct vhost_virtqueue *vq;
 	struct vhost_net_virtqueue *nvq;
-	struct vhost_net_ubuf_ref *ubufs, *oldubufs = NULL;
 	int r;
 
 	mutex_lock(&n->dev.mutex);
@@ -1509,13 +1146,6 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	/* start polling new socket */
 	oldsock = vhost_vq_get_backend(vq);
 	if (sock != oldsock) {
-		ubufs = vhost_net_ubuf_alloc(vq,
-					     sock && vhost_sock_zcopy(sock));
-		if (IS_ERR(ubufs)) {
-			r = PTR_ERR(ubufs);
-			goto err_ubufs;
-		}
-
 		vhost_net_disable_vq(n, vq);
 		vhost_vq_set_backend(vq, sock);
 		vhost_net_buf_unproduce(nvq);
@@ -1531,24 +1161,10 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 			else
 				nvq->rx_ring = NULL;
 		}
-
-		oldubufs = nvq->ubufs;
-		nvq->ubufs = ubufs;
-
-		n->tx_packets = 0;
-		n->tx_zcopy_err = 0;
-		n->tx_flush = false;
 	}
 
 	mutex_unlock(&vq->mutex);
 
-	if (oldubufs) {
-		vhost_net_ubuf_put_wait_and_free(oldubufs);
-		mutex_lock(&vq->mutex);
-		vhost_zerocopy_signal_used(n, vq);
-		mutex_unlock(&vq->mutex);
-	}
-
 	if (oldsock) {
 		vhost_dev_flush(&n->dev);
 		sockfd_put(oldsock);
@@ -1560,9 +1176,6 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 err_used:
 	vhost_vq_set_backend(vq, oldsock);
 	vhost_net_enable_vq(n, vq);
-	if (ubufs)
-		vhost_net_ubuf_put_wait_and_free(ubufs);
-err_ubufs:
 	if (sock)
 		sockfd_put(sock);
 err_vq:
@@ -1654,12 +1267,7 @@ static long vhost_net_set_owner(struct vhost_net *n)
 		r = -EBUSY;
 		goto out;
 	}
-	r = vhost_net_set_ubuf_info(n);
-	if (r)
-		goto out;
 	r = vhost_dev_set_owner(&n->dev);
-	if (r)
-		vhost_net_clear_ubuf_info(n);
 	vhost_net_flush(n);
 out:
 	mutex_unlock(&n->dev.mutex);
@@ -1768,8 +1376,6 @@ static struct miscdevice vhost_net_misc = {
 
 static int __init vhost_net_init(void)
 {
-	if (experimental_zcopytx)
-		vhost_net_enable_zcopy(VHOST_NET_VQ_TX);
 	return misc_register(&vhost_net_misc);
 }
 module_init(vhost_net_init);
-- 
2.43.0



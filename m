Return-Path: <kvm+bounces-40992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2DAFA60218
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:12:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D92C14221EF
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:12:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67C51F869E;
	Thu, 13 Mar 2025 20:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tdilPyni";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ifVa4l3P"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ED31F4CAB;
	Thu, 13 Mar 2025 20:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896641; cv=fail; b=ZyPmKKVAXy2vJIwGcYlS2x9TNlIkNPyRoOMvlX6H1jhmTs0wEq276YY/pWgcvDZqXBe8pLSzcNNgNOBwIjbNoIF1V3QrPxjTudx7j1SbHlEx++Ri9KdpHmPfBH7mthe9g4Kp5DISLV4H8nwOJugrOF52cUGTSQ57Oc4edaKQE6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896641; c=relaxed/simple;
	bh=Qjd9ENq8dsCIMA18rfKc918wPCdXWmANk3S2DDy5v/I=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pZvj6xMxsDo22Q7jXJGxGWfK5ZX83XC90xGZ4dI6W1h6RLwSv2fvm5oxuZj8RzcibjmM6NrY12Y1nf2P6udRxeGYoFUi+CTBad653rj8r7gaKxtHSTtNWFkcHqskEysmOTcEolYyoD1uwhMv51Vc+2uigYNi/euVqPI0JVfJjMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tdilPyni; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ifVa4l3P; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DEkL3G008473;
	Thu, 13 Mar 2025 13:09:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=gprSYzdNxg65W
	VMJDyclY6H2sc631LXxfLygD2zCcSw=; b=tdilPyni6OtcRj+1Hkslz9ssJer2E
	3abuBSt3kbP90Y9cqfeL7OoNsJ9QmqMGkS/SxHKmW0CjehP8AecTF1UEaAQbONyY
	7QOGJkAPKtGcYoWg1xJc9t1lmqUzxyYrDNvhfNX/5AmSbtbYD/vxC85WY4Q+Jcq4
	3XnVfvIKzDjFSrow/TcA0j67q8eh7Nj9vWcs3rYr0zCtu7PXTHNBFrcCQBjl2f92
	ieNXJvUdwLcS1s16wKQcGt++m4Z5dmBFMT06yX7NtqLn5ti+j+ZCZy+0JiQrLaaz
	lQB2hfvQYD5l91erp7JO3ZSdwUB21D8vitQdDMdNWdgQqhRRGdUr0trpw==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazlp17011026.outbound.protection.outlook.com [40.93.14.26])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9gp937-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:09:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jAN/huGRW07WZ31hZ//U3ckDAdJ0POi79tYHD7nOfz2/aHphWvTDRgsQHXowoN3YqVDS3/jw2l+sKtQ7u9g1nbiLvWBZYv7Vxf/W3lp3hHOTHeUXPqhUyCF/UVlzTi5CBSrBJXw7fd6E4D08nckxT9qjuoyg1lqlCFt1sfkRdVh6x23CEuA9jYBSbj6p4BRD5GKB+radHgCA2Pq0LxfteHDWytYNTCPJwXKOq8DlUVOhYBAStGAdkwJZdQznyftd/wp6F42L/7pkLMTx6PcjgQU7nGPn3eXPBEl5FJgqYUMNwYb1M33QtCNlrKbf27Oh1X0SIK1WRamxKC7pbTRwkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gprSYzdNxg65WVMJDyclY6H2sc631LXxfLygD2zCcSw=;
 b=t2eOl3Vk0ITMByHyNaAiyMZW2rdwyonNOuapuZJ79oY7KBPJqSm+TIzWBecseifPZd++vGkM0sxfCvSvK/KswomdTaWFYmSRvz1n/ZGnrYnfXD/a/TqUyzMCwqt7L3aYhkXnH4SLgz9fIiYvZQq7L6xTGiRsr0Je0p9Argfa6HQNyvlqCZbcr/Wn7uV75G6AKU4M/wg4lf2DViAwpc7RBbdTlUQGi/dYdnXXneVLZqnqSIhIvat31RVYx25X9a0a8eG7EWE0dsRTLLTVhXGlTfCJPDI5G/AMcbXmxcai6qlFOnl/NtUVwAeTutwk6XSJmvRErBSjYCvSFRGCD74qPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gprSYzdNxg65WVMJDyclY6H2sc631LXxfLygD2zCcSw=;
 b=ifVa4l3Phw7MMyLYZrdSmA9fmxLuPVHZTDH5ZPy3043o+elGfks3sjrkY/o3wFXBlYqNJp3mt8ZyYYSnF6I+JlLeGoJ2SAT1ludxfYXlq4/b2pDrSdgZR1HefiSlplI7s1qCg+ifc2CJm3HPyDRcSo7zwJHv5lMhQlGmddpSGUCWG35P3z9jUfgBve8AglR85DytUOnWpOIJ8XwP8QeXggNAKMui85G2l0QPMVertulcgiGN980NeXihg01kOUi5YoTOSuqdTPyPBHj+CJXCXtQeSfEG7ZXqEBRUhOsUOSXYzohoa8Tl593wtH9lPVW9P2XjTr9coh+4FvtdImTN+A==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB9384.namprd02.prod.outlook.com
 (2603:10b6:510:280::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:09:51 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:09:50 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>,
        Alexander Grest <Alexander.Grest@microsoft.com>,
        Nicolas Saenz Julienne <nsaenz@amazon.es>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Tao Su <tao1.su@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute Control (MBEC)
Date: Thu, 13 Mar 2025 13:36:39 -0700
Message-ID: <20250313203702.575156-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|PH0PR02MB9384:EE_
X-MS-Office365-Filtering-Correlation-Id: c9646193-ceef-44ce-f74b-08dd626b02fb
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnJUOWJqYjFJMWdyWUpTeDFaK0lTNHg0NTQ0cW1oS1g0eUdvclRUUWJOdzFa?=
 =?utf-8?B?RzdPdDhyRHlwWTgwN0xTSEMzWHNKMHhucmI2Y0RCOWRpV0h2VGszWkxvckFE?=
 =?utf-8?B?aG4vY3V6bXQ5eDV5MzVZS1R6VFl1NFFYdVFVR2lHSDIwQ0xWN2cwTE0zVlQz?=
 =?utf-8?B?NzEwdEhqcU1HT3FyT0Uwb1BZa01UdFlhaElMYjI2SmFTYjBIczZKV2xkaXdK?=
 =?utf-8?B?bitWZ3ROQ29YelpnOEdUdGlseVdkZ2tMNDgydDY3b3ZVMEJ1ZExvdWhsMVBV?=
 =?utf-8?B?K29IOGNZU3VFSmF0U2lhalNTYnllZXlqeEtMRkpPbHVUZVVKQ2RIRzl6ejYz?=
 =?utf-8?B?c29lMG1hWk05c0RvRUQ3Skk2N0wxdGZLZkhCOW44NExTQTZIdjVZYWwxY3Fu?=
 =?utf-8?B?U2Fkc1UvMmhESWZ2UWswQmN4NXlWQmswQXJjbXJrNjdobE55bklXTm9YNity?=
 =?utf-8?B?VHhtV2VHcUVOZkozWk9GRFdSWTk0MTZjKzVJQit5OWVrNC96NHh6V0RBUmlx?=
 =?utf-8?B?L2s1Q3h6SHRNditxRDdsc1VoK2JSUE5VV3JHTnBZV3ZMMFdkbnZrVHdFejFp?=
 =?utf-8?B?T2dFMEpDYVVsbjQxS0hDVHRDMjJxdXJoQWZ4Sm0waEl6SDBJVm83ZGI1Q3lk?=
 =?utf-8?B?V1FwQ2tlTnl2dVpFZnB5ZDlWWFZ6amRsYXJhb0lsYXI0OWlxczRzbS90b2t6?=
 =?utf-8?B?S0RQc0hxQ3liUHg2L0ZwSytRaEFGaTk4bWxKM1dsbzBhT091RitRNWloYWVR?=
 =?utf-8?B?YTEyNW5aTm45dHNYOThqYTN6ZTQ2aEl5d0pDY24wUGp6Umk1bit1ZkpnVURk?=
 =?utf-8?B?bGdET25kaVRLQTFTdmhxcHlEekp1SndnYXJHOCs2ZG96NVBvMURHS3VRenRS?=
 =?utf-8?B?R1FqcFFiVkl5bEU1QUZnZWpRREl1U2tjRjA0RTlvRjk0bGk1ZlQ5UnpOeU5h?=
 =?utf-8?B?elVFbGpMUWtSR2o0U3dqWXNDeXUrZEpZODUvQlVDUkFsOHlWUXBHMzEvS25S?=
 =?utf-8?B?UVBRREFMT0VZRndWaWptc0l6c0huR3J0cUduN2lQZ05nenEwbms2YUs5WDN1?=
 =?utf-8?B?OXZrSHhneVNCRGdhQjBMeDhNQ040NFJGV1dCTWluNC9uVWxmaDFweDc1R0VT?=
 =?utf-8?B?OHRiRmZRNy9VTFRXZ1EvV0JTUWI0RHFNazVUS1orc1czVnpTUUlkSWMwZlVz?=
 =?utf-8?B?cXQ5dEtDU01FekJ5K01LOU9iV2o5b2t0MDExRThweG9VdUZHd0ljMU1kaGlp?=
 =?utf-8?B?cGo0RnBmM0xtTStYWEYyU2srbzQ5eHNjQitobjlQaEpDZnZnM3hJR0hBQ2hx?=
 =?utf-8?B?UEJGZ1FzWUV0V3o5UlVYVEl5U0V0UVFjUklMRTlRdXhtYk9BKzIzdW1mditB?=
 =?utf-8?B?cjg2aUp2VElLaHZ4YXV2V0ViaDB1dkZxa0RGNGMxWW9HOUF0dmdad3E5T3Nn?=
 =?utf-8?B?eHkwLy9nTUphN2FHOC9zRkN3Rk1Ud1pvamNmaDhQS3g3VUFhQ0lVL09oYm52?=
 =?utf-8?B?bjhKb3RWQ1ByV1gyYytKUDVQRnAxSkJJZ3p6ZFRLT3M4UGN3TjZORzBhTmIv?=
 =?utf-8?B?V1ZSQVh0RmllNTRBdlJzUFV2WjJVSVZEa1VIdy9teTJBZWJnTlYyQWlRb1Jp?=
 =?utf-8?B?RjZvbG4wNm9zeWtUVGVGa0xNQ3p4SlR1NHpjdHhyNTlGMFdDMDMyaUdzdUJE?=
 =?utf-8?B?UG5IZ05HRXFUZTBkTGU3cjd1ZEdaa3g2Y2hxZVljcktoUEhHUnpzQXhSWlRa?=
 =?utf-8?B?R1p2Q0tIRUhURVRHZ3k4TUdEN0I4VEZhemRYd2pUN09LT0hqUkE2WGJGSHND?=
 =?utf-8?B?TGE5K05VR1h3VldqMGlydzdIbWhsaHREVzJwbHovTDJRbWw3OHZBWjRhSTJL?=
 =?utf-8?B?RGU0VDBxb2UyQjllWXFRMndoM2JJYWsxOVhiY2JQaXlWb2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDFTdVVlQ0Q2WHVabU81VldIei95QlRGeUpRYVdCZHNjZ3pLTDF1c2VOSWY4?=
 =?utf-8?B?Z2V6dWxDSjg0RHRIN0JSYlVDR2ZpYk5ERFNLOWRuSldkRjBPQjc0alNmRDBr?=
 =?utf-8?B?K0tGNXp4dmlNNjY5UTJSVGRnSVZ1dGhLSUxQMEVNSVdlaWhPb1Bnc1ZXamdD?=
 =?utf-8?B?VjV1blo4Wjl6M1BkRThSMFV2RytIcWlaRmZQYW9nOGt5bFUwNDVla2YyQXp4?=
 =?utf-8?B?SlgreGEyWjBaSUY1YlA0Vy9MSXVZNjJVLzZEczRVRmhUeTUrdC9rcnY5NWpt?=
 =?utf-8?B?elozMnRmMUU3R1ZzYkFnaW1rSUZtdjAzekxVaWFUdUVEVEM2T1VqN2FUbzZB?=
 =?utf-8?B?SUU3UWNOaGZCSEhSWkVKZjV4dENUUXdWeHFRb1N3STdBYjhQTTJQTmRCVjFq?=
 =?utf-8?B?cEI0YmlVbnNGWlUzd0h0QVgrYUhWNktXR01ESEVlalFWNTByY29iKzFtY3JM?=
 =?utf-8?B?L3hOcjZHY1k2YUxhZlNreG11QmpDL2ZnaEtpdWsrNFluRThHZS9VZjh2amY5?=
 =?utf-8?B?bVN5NlFZeWZvYklDNnV2SzJ4a0hBZ1JZbUpzTk10Z2xSKzVxNVBTeEJRWm5a?=
 =?utf-8?B?NXBQY1U1SVpibGpVRzQxQ3lKZUdhZzBUdEZIV29JNWRtZUZKaDZJODhrWjhq?=
 =?utf-8?B?UldYei9WczRtY2NxRUFuKytwUWJwRjROam54S29JeUJ2Zis5UzdJeTdvc3F0?=
 =?utf-8?B?RnV4cXc1UzM3WTczSENrR2JEd2dWV21yNFZ4cjdZdG1lcXh1Q09HS25tN3pS?=
 =?utf-8?B?ajl6T0RNQkdMZmhwVGFYelRzcGM0WmNlcm40SnVoY3M3ZEpjeENON1hzSzAz?=
 =?utf-8?B?c010MUV1U2ozTHRxaHVYSlRNT0hkcHpxeUF4WmdPUHpDZnRsM0NyM2VrZmJ4?=
 =?utf-8?B?VkVORUFNU1ZYdFJBaHZQOURrQzA5MUhxVHFlNnVFYy9OTGR5VEdJRlZtdmpl?=
 =?utf-8?B?MSs5aitnNHdLekpCdWIreGpiS2U5bE1FbmNXTHZiMnpDMVgyRHpwUFVMeWI1?=
 =?utf-8?B?V2tKN1J4OUNUc0VWdXY3UnluSGs2cmhVcTVHeVdxNUJWcm1RVzJPZk9kTEpq?=
 =?utf-8?B?OHhtKzdTTzFIRVBmOWpteVZxTjg1Rm5PazkvZTUxbkVmN2ZQdCt0WGoxQkk2?=
 =?utf-8?B?UUl6ZXZDYytjN0gzVkJDekR4cWRXdVlrMU1YZnJmblF4WTBZa0lTbnkxQnJR?=
 =?utf-8?B?NEpaMTR2K3lTTWZ2R1NiSW9VeWRtQnBhWWVZa29rc2IrUHRMRjZSMHY0S2pw?=
 =?utf-8?B?dXRzYlpqbDlLL2NFVzREVTB0Qlpwa1NmUnh0K2NFc2NFWmk2MVlTWmp1VzEz?=
 =?utf-8?B?d3JrVjdYS1Y1ZE5uMTJTSUl4SnpySzhmaXl3QTdDckpvWm1aL1NOU2VDd2dN?=
 =?utf-8?B?U0hpaWhkMnVwcTZJNlQ2UzhhMzRaWHF1ZnI1RHJUNVRjYjQvcVM0OUg0dUlv?=
 =?utf-8?B?cmd5SEx6SG9QMEhyNGtLMVg3Mkt2Y0lmeGF1NnM4azdpTUlyOURwMGswTjVY?=
 =?utf-8?B?cGErNHpYRFdUQnRXNWFxNkQrYlNtRWNMbVR2aS92RTc2VGQ3c1JSaFJ3aUJz?=
 =?utf-8?B?VzhYWWdDQU1pZXhhellLZlhLQXZXeExDVGtja0VYYXQ4NjZHRXVpYktON045?=
 =?utf-8?B?dzcwcHd0SDZIaXc3blh6b0ZZQ0JPNWdTVzhiamFlWG05M0ROb3p1M25ibHZu?=
 =?utf-8?B?My9hbEd5MFpIYTRJcnpWUzRCeHFFTjEwemIyMXJCVHdXeUJ6cUFsYjNlTzh3?=
 =?utf-8?B?aWV2UjYxNmdUL0NITkMyaHQ3NkJ5NGk1bUpUMzdDZUMvSFIrMHlnNmd3SlBX?=
 =?utf-8?B?eVJOMmRzZUFjNFVkVGc4Z2NaTXBQb0h3T3g4dHhXelBPRmxJaVVsSGNYVXBZ?=
 =?utf-8?B?NTJWNzE1eGhlQm16c0ZjM0MxMnQrT1dZQWdYV1c2ZnpORlVzeFlpdlJNOEFC?=
 =?utf-8?B?SWpvZ3lXQW9BZG1vL09QazBlSDYzVlE4OUpsU1JzWDU3cEFTYnV5czBQempT?=
 =?utf-8?B?cWhrdm5oempodGlVU3ZUZjB4bzZKN2ROTVZHZTBvd2Fmdk1ObmEwRXBxUmw2?=
 =?utf-8?B?M2lJblF3ZWE0RTRHSjdROUNQem1wUkpBT1VpYk5pZCtNajU5TWpMdWs1TFht?=
 =?utf-8?B?Ry91UVYwWW1GMlBCR25OTWpmNy9pUk05TFU3MWhKR0VIMGdhRUo3N3Y1UkFI?=
 =?utf-8?B?SFE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9646193-ceef-44ce-f74b-08dd626b02fb
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:09:50.9090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LK5gsI+zvFRAgWC261+TCqYDY41cXPZ3CYL5om5K+aAoIgAEDLikTjOilkefZDq6arXXSRVPbu+RaDpUBlm+6l97PMlnTUnz+LbOzab0/Ws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9384
X-Proofpoint-GUID: XC-QTZygNlX-hm52BqdRuEW_Gh6tUXYx
X-Proofpoint-ORIG-GUID: XC-QTZygNlX-hm52BqdRuEW_Gh6tUXYx
X-Authority-Analysis: v=2.4 cv=WMl/XmsR c=1 sm=1 tr=0 ts=67d33b95 cx=c_pps a=GnUjYDbtZuq/T0BoTQNfSw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Vs1iUdzkB0EA:10 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=yMhMjlubAAAA:8 a=VwQbUJbxAAAA:8 a=edGIuiaXAAAA:8 a=NEAV23lmAAAA:8 a=QyXUC8HyAAAA:8 a=Xiv-YnGf6EIgopWwbTwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=4kyDAASA-Eebq_PzFVE6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

## Summary
This series introduces support for Intel Mode-Based Execute Control
(MBEC) to KVM and nested VMX virtualization, aiming to significantly
reduce VMexits and improve performance for Windows guests running with
Hypervisor-Protected Code Integrity (HVCI).

## What?
Intel MBEC is a hardware feature, introduced in the Kabylake
generation, that allows for more granular control over execution
permissions. MBEC enables the separation and tracking of execution
permissions for supervisor (kernel) and user-mode code. It is used as
an accelerator for Microsoft's Memory Integrity [1] (also known as
hypervisor-protected code integrity or HVCI).

## Why?
The primary reason for this feature is performance.

Without hardware-level MBEC, enabling Windows HVCI runs a 'software
MBEC' known as Restricted User Mode, which imposes a runtime overhead
due to increased state transitions between the guest's L2 root
partition and the L2 secure partition for running kernel mode code
integrity operations.

In practice, this results in a significant number of exits. For
example, playing a YouTube video within the Edge Browser produces
roughly 1.2 million VMexits/second across an 8 vCPU Windows 11 guest.

Most of these exits are VMREAD/VMWRITE operations, which can be
emulated with Enlightened VMCS (eVMCS). However, even with eVMCS, this
configuration still produces around 200,000 VMexits/second.

With MBEC exposed to the L1 Windows Hypervisor, the same scenario
results in approximately 50,000 VMexits/second, a *24x* reduction from
the baseline.

Not a typo, 24x reduction in VMexits.

## How?
This series implements core KVM support for exposing the MBEC bit in
secondary execution controls (bit 22) to L1 and L2, based on
configuration from user space and a module parameter
'enable_pt_guest_exec_control'. The inspiration for this series
started with Mickaël's series for Heki [3], where we've extracted,
refactored, and extended the MBEC-specific use case to be
general-purpose.

MBEC, which appears in Linux /proc/cpuinfo as ept_mode_based_exec,
splits the EPT exec bit (bit 2 in PTE) into two bits. When secondary
execution control bit 22 is set, PTE bit 2 reflects supervisor mode
executable, and PTE bit 10 reflects user mode executable.

The semantics for EPT violation qualifications also change when MBEC
is enabled, with bit 5 reflecting supervisor/kernel mode execute
permissions and bit 6 reflecting user mode execute permissions.
This ultimately serves to expose this feature to the L1 hypervisor,
which consumes MBEC and informs the L2 partitions not to use the
software MBEC by removing bit 14 in 0x40000004 EAX [4].

## Where?
Enablement spans both VMX code and MMU code to teach the shadow MMU
about the different execution modes, as well as user space VMM to pass
secondary execution control bit 22. A patch for QEMU enablement is
available [5].

## Testing
Initial testing has been on done on 6.12-based code with:
  Guests
    - Windows 11 24H2 26100.2894
    - Windows Server 2025 24H2 26100.2894
    - Windows Server 2022 W1H2 20348.825
  Processors:
    - Intel Skylake 6154
    - Intel Sapphire Rapids 6444Y

## Acknowledgements
Special thanks to all contributors and reviewers who have provided
valuable feedback and support for this patch series.

[1] https://learn.microsoft.com/en-us/windows/security/hardware-security/enable-virtualization-based-protection-of-code-integrity
[2] https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/nested-virtualization#enlightened-vmcs-intel
[3] https://patchwork.kernel.org/project/kvm/patch/20231113022326.24388-6-mic@digikod.net/
[4] https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/feature-discovery#implementation-recommendations---0x40000004
[5] https://github.com/JonKohler/qemu/tree/mbec-rfc-v1

Cc: Alexander Grest <Alexander.Grest@microsoft.com>
Cc: Nicolas Saenz Julienne <nsaenz@amazon.es>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Mickaël Salaün <mic@digikod.net>
Cc: Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Zhao Liu <zhao1.liu@intel.com>

Jon Kohler (11):
  KVM: x86: Add module parameter for Intel MBEC
  KVM: x86: Add pt_guest_exec_control to kvm_vcpu_arch
  KVM: VMX: Wire up Intel MBEC enable/disable logic
  KVM: x86/mmu: Remove SPTE_PERM_MASK
  KVM: VMX: Extend EPT Violation protection bits
  KVM: x86/mmu: Introduce shadow_ux_mask
  KVM: x86/mmu: Adjust SPTE_MMIO_ALLOWED_MASK to understand MBEC
  KVM: x86/mmu: Extend make_spte to understand MBEC
  KVM: nVMX: Setup Intel MBEC in nested secondary controls
  KVM: VMX: Allow MBEC with EVMCS
  KVM: x86: Enable module parameter for MBEC

Mickaël Salaün (5):
  KVM: VMX: add cpu_has_vmx_mbec helper
  KVM: VMX: Define VMX_EPT_USER_EXECUTABLE_MASK
  KVM: x86/mmu: Extend access bitfield in kvm_mmu_page_role
  KVM: VMX: Enhance EPT violation handler for PROT_USER_EXEC
  KVM: x86/mmu: Extend is_executable_pte to understand MBEC

Nikolay Borisov (1):
  KVM: VMX: Remove EPT_VIOLATIONS_ACC_*_BIT defines

Sean Christopherson (1):
  KVM: nVMX: Decouple EPT RWX bits from EPT Violation protection bits

 arch/x86/include/asm/kvm_host.h | 13 +++++----
 arch/x86/include/asm/vmx.h      | 45 ++++++++++++++++++++---------
 arch/x86/kvm/mmu.h              |  3 +-
 arch/x86/kvm/mmu/mmu.c          | 13 +++++----
 arch/x86/kvm/mmu/mmutrace.h     | 23 ++++++++++-----
 arch/x86/kvm/mmu/paging_tmpl.h  | 19 +++++++++---
 arch/x86/kvm/mmu/spte.c         | 51 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/mmu/spte.h         | 36 +++++++++++++++--------
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 arch/x86/kvm/vmx/capabilities.h |  6 ++++
 arch/x86/kvm/vmx/hyperv.c       |  5 +++-
 arch/x86/kvm/vmx/hyperv_evmcs.h |  1 +
 arch/x86/kvm/vmx/nested.c       |  4 +++
 arch/x86/kvm/vmx/vmx.c          | 21 ++++++++++++--
 arch/x86/kvm/vmx/vmx.h          |  7 +++++
 arch/x86/kvm/x86.c              |  4 +++
 16 files changed, 192 insertions(+), 61 deletions(-)

-- 
2.43.0



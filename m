Return-Path: <kvm+bounces-57749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DC08B59E0B
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91974323ED2
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A1B27FD74;
	Tue, 16 Sep 2025 16:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="0kIPt5ja";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="MAn+1W0u"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7212F25FA
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041100; cv=fail; b=bRoDVTJ5fawupZWA9e1X5jGEc31OTdfoxUqxASNcpVf2/KBiIw0ZkOCZF7caW4yDxz3yrhPetdnmAo9KDYhvQEGx7G57vQECy3DhnancC+xTnuB1XXdSQeYKdHtBOtK6dSkBD+RqY4tkcHQc9taPM55dLKAZ3uSumd4pMASDBHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041100; c=relaxed/simple;
	bh=WX7KwiX3rtHVn7s5O8jCBPGAhQgt2mWOCQ/8Fdyxm4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KGXdSXe8/wsNvN/0aM/hY4Eu5B6pIpVZGFlVA3b8m0eayVlQEayfsuao9Eb0aRaLD0ZPf5uSconJspH+aBSV9JDeFUuhVGC0HcqNQoaaKhBzMSzLmMT6aCZ+qcPlvU/JbPqsrOms1XPUM6VvGovJrxxks41zg/Gh2Hj/RWrA1ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=0kIPt5ja; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=MAn+1W0u; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58GGVbp33598659;
	Tue, 16 Sep 2025 09:44:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Oey4gBx2AmPGbmToKowG7kVQklZnrGsV9fGZD1ZPW
	QM=; b=0kIPt5jaPpbKxeCzeQMgf3XI1aurOhSt7FViPEJJ2I252QP2IAImVl2DE
	Ztb04Ev9ZlaRYnu1vf910EHJPPSApKZYdsnZZBzHX65JuKSy1QWBr1rpBdP/198r
	oUN7zIkLkuPDeRhHhGoBCRjAyVlZRSMqu+zX003p2CfBhwNnDSXfshQAqI2k/0+x
	COwJG8K/6gzOJHekLZDjjPbWRHmAEjX9uqR1Dzv3MQz5+CXAjxQ9TgES2XlMKI8A
	M4bZn3kqr4fvevlktx7G82LSg/ZCXG83x5Mqoh7I6qFUE6XsmIDDtgEEsw21A+hJ
	t9TTK5dMdbCtdIE3n4k6GE8zZFmpA==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021100.outbound.protection.outlook.com [40.93.194.100])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 496pby2vm0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MmKBwAf3tOm+8cW3V6gyTkeYIT+yJNs7loWjkMVK1FFsFQcnzYHmyfGYknEFDo7APlg2K00Xhxj/KMjCHkPkjWTZqyuqgD/pZke29xwIcH2meuletsbnPDffm+uWVkApf3OBppBRyVglO5b5QIbHOW9N4ZtNG1IIHwNgCTsJMypnUWqar9mPhcQ7c0M4P0CxZhgggPVsfgYVPvUHZ0EAapskzcw/rF8PM8bYtBMTiSN0aD4EgR9VHa0KfIztqVql/G4t1ScfMzYk9MlNtBTIjemKe41Lu3CxJ3o9mMOdaXXcvlYHXGluEopVD7R0vr+K5doydijl+cx6WLV3M7vGJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oey4gBx2AmPGbmToKowG7kVQklZnrGsV9fGZD1ZPWQM=;
 b=gjy7TofAzha+S5eMCA1/PxRkdpPhpCJ4po5pKgaBff8VJuIZgssPoD9L6gGmphnTjtekXBcNE+aVOsvsEw3dlB/WsSxTpRbjH++tnpGctqviu6R3TqkCb18+L2/9NcZgsJnzyymGeILrpB6OYyWWqPrOq4kfW032wiY9SsncFkBvSz5LT7gy1fuupTu17cU1SokZttnC2YY6VEDNzvuYzByZoS9gBtT1JSQFcTMKVVKQsunkf2dK6ZDe6V2KJ+hT/zrJ/u9YF5nxmuq4QKFizKccjScc1Ov4ZcgNxywAoQIW+vz/u7xBCoDCDb6eN4hJT9WiL19S7JdXBKUETUWtMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oey4gBx2AmPGbmToKowG7kVQklZnrGsV9fGZD1ZPWQM=;
 b=MAn+1W0un2nCOFk0NUBCK1Kv/MmfXfEkBsh45DVCwTmWv/D8wFsbYeISKoU0N4l5K2vjxAxKAglDoCM92UA5ydtB+MyzPMkU3P8Ir8xGC2FVSHgNJbFYkJlhTeAdWTIYyvkt5loRos9xPt2vXJ2aEpfFlYCCJqpfm6xCJhLd+Wbkz0wkrNwwCh4MGMMuw68XkltsECAiFjMRzsGufW5L6eNp/l+OGLk6BZJizN9aaGSDQNNwgYNj7jcgkCJaWJMt3ZkmLDBKwithh5rFB0j9kQIihKepb9f4PVrytlGwenn5idILkxumMjRlah3hHyoieUhEU+njgUKsGmUixSJg7g==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB8501.namprd02.prod.outlook.com
 (2603:10b6:510:100::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:53 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:53 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 14/17] x86/vmx: switch to new vmx.h exit controls
Date: Tue, 16 Sep 2025 10:22:43 -0700
Message-ID: <20250916172247.610021-15-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916172247.610021-1-jon@nutanix.com>
References: <20250916172247.610021-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013309.namprd07.prod.outlook.com
 (2603:10b6:518:1::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|PH0PR02MB8501:EE_
X-MS-Office365-Filtering-Correlation-Id: 3781f547-99e6-4cc9-0208-08ddf5405c13
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B5wQwRMu92zfSnYYQ6GT2Jq3xztjIuNicWsOWdalr5va7oJvNvkW6XswnBcX?=
 =?us-ascii?Q?jooJnkXmPGC/6qb3OU4BQNVz6L99VPKp7LAJogBiR8yWADBi5Izj28VruADX?=
 =?us-ascii?Q?tnGiCSwr2jvRf4X+swXlN2hxd7UZUCES9I0ZH4vJnm+SH0NN9Z4/o/pLoqMM?=
 =?us-ascii?Q?1yLkn23EDKGhN3KwKO+mW822/s4aVNopXzkPvZSweO11TcG524Ezxaqrebc2?=
 =?us-ascii?Q?jg3kmP5MD+lzD1bweQHvAoBDFi3MEgfgjy7N77S4hQejaVTMmLP3TIeKn2RU?=
 =?us-ascii?Q?xY4zEZ69uY6snb/rf9dfQ48wk+Ep7912d8i35IRbaVtZnoKdfT5IdQmMfbzM?=
 =?us-ascii?Q?zCqyFDEJF5DX2BrrF1WYysZZMjy+ElgLQevjca2CaDTv/q+EMjehU2ViuFpX?=
 =?us-ascii?Q?94BWWl6615wAwNVYcuE8/4/OAxR3w+qh8xc0Jam2CHOTHysTqfy12e4hovPy?=
 =?us-ascii?Q?mqVJJFQ7kRLYO8A1uijyM2sJTtypbSdtdn0VBF4a/HIaZREE4QH6TVRU99qG?=
 =?us-ascii?Q?OBC1WVWbQ10vxiIbKhZKdh95CYzS0oHOk18j6g0Fie4MOQmfymhx7iwdW9Gt?=
 =?us-ascii?Q?Ro82/L8Yyt42yW8JN8ZCCU3gOA9DFf79HHbGglpu2S8habiT5LtLeGFSYc2U?=
 =?us-ascii?Q?yk5gw2xhQA8f6ynNGxuHlzY+rw3ySdTu15dbG/zc/ItiR1QGs9O6rMcU9tip?=
 =?us-ascii?Q?eOhyL7If0Kk/GAfEInapzdBpnIWPPgxY+KP3lZkSui7tMDT97t8Xo3Vb5zph?=
 =?us-ascii?Q?pG12hpJ8Upcwe2KKvMHTnTx+cdNN3Yz05+eYbo8v7SYnw5/t7SDyJ8CvTzC4?=
 =?us-ascii?Q?rhzzkFnGj70jOefnnm9LLL6/Ux3ym+vtA3NY9sWDxTFG5ffKXuC+IKTZlcZU?=
 =?us-ascii?Q?XEXwhQJfJ4JH3IX7mQ78u6wbnr7b8kcOzMUn3MEZFdt2OOFtceWV1xNCZ+89?=
 =?us-ascii?Q?Xg4/1ZGRv7tBuBE2rlMnGCKcPKB5OBGVdVWmh3MS09y1iW4wqijwILNtAEvv?=
 =?us-ascii?Q?09KcNyq71WyF1+Cppw7DL8DNOvr/7OWb8XerCn7g4WNAsy9tC/um0zlyKozH?=
 =?us-ascii?Q?Lwfh7kbk+HxR1BOOF1/tdERbuqRcd171ZyK4e6JaX6K9inCcjhQyU3xNvA+w?=
 =?us-ascii?Q?xcgWjMMwoaEcapq3ryiu4BuW2ZaTblCLDh+ViD7fnSaEFPECYQ+vcCY03tY/?=
 =?us-ascii?Q?gpDNGENLct26opN5OasMb/A3Gf5XUio4dOgRUQcYYU/6RqhNeSfOKx0jA2AR?=
 =?us-ascii?Q?fneQXch74Fq8Iq+1wqbQMDd+wTnw3+j9cqkzyi7pQTzeexcoy8ubkfGM1My3?=
 =?us-ascii?Q?eAW6RrMEBV8nnuDXNRnKfro9C8X5rEYEsXDP+aANauNahuUxjfIB9U9ak2d+?=
 =?us-ascii?Q?tlmkyDrQVr33WRrxtKHC1uRy+9in/3iHi8PL7Nh9TFXQX8QC1ojGv4ygImlb?=
 =?us-ascii?Q?BzLiiWaoEhk5VO0ct5KDjhmDzd+OKCHCpnuIEYM/ZUZKszP5kQDKkg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wf0Ph2ZwOr3c+Mv5B1wacriZB4wb6MHM3HVG5bTPnR0X9peCq1zh4dYgwaTA?=
 =?us-ascii?Q?MA1M7nMpo1JIhXAxw0beKm7DLq8oshgr03TdaPgrmQ+MzOlfP0kBguzN/b0K?=
 =?us-ascii?Q?y5Zbo4ZuXLeYdAjmU6QX3ecYDcUD2L+FQlXmjYIVwIkeGihUM3vjLA1Wc1gl?=
 =?us-ascii?Q?LFFMks4eJ7Gfla9qpMlC/hKkutFm5hMf0NT0WY55i5AJ4j6Yl/ECotYvv82Q?=
 =?us-ascii?Q?PN9jo+16XvMmDLe79Cq9YezzKOtRVOrzu/xOdw1NzALGYQFcUYvwMYKSkH8P?=
 =?us-ascii?Q?qftB6kHmGVdUtQibqvFveZx7UrTmiPqdTzhH0y3yIhQHbGwCvEhBxOfG1s1b?=
 =?us-ascii?Q?I2ucsyEl3Q9OOzVQ7krkCLFQ/8jLmj1evf9rkMpII6e4i48sLbVsRrSs5OEH?=
 =?us-ascii?Q?7gCY6/TQ0lVw/x7ai4248/1z+D+YBinFA4aDYQo7NW0Mu+qwtI0PRPGEc1LG?=
 =?us-ascii?Q?VTppxPknTG2YRDsP6k3mm+mt/YgEGM/YO7P7fZ1lDcUrXmZi+0OBuD35Nfhi?=
 =?us-ascii?Q?RXOBov1wIHHNBt1JKlbg08hqCpFzT4pZXzwSth5qOYM/jFj5fkRGG1tNXZKY?=
 =?us-ascii?Q?ICuSErU8dSEdLQanKBOCmFcOynAublL76A2ASN9ijEj9ygVkQ5hE3gf+YrTp?=
 =?us-ascii?Q?LN7XByukoQT6kD9VGJf4v20xGfHVSQq5KfYuPZWRSSHtDET1vTjGveB2+EiC?=
 =?us-ascii?Q?ifxfGOFaaRxO4xh4AmcJ2KX7WQ5uhmFZA0iVit2IDEZemrrf5eexcLm6vX/Q?=
 =?us-ascii?Q?uK+vTc3dbvaRIXyG8cMKYuDZYk+F9iTR8AcNOnzWUdwDc0bTvapFF6WC+CSL?=
 =?us-ascii?Q?3NlVCcAjzmOoY3/hHqUPrv1geKb118rzywCBHP0cA+n4/xLy/0RPyURB64Cz?=
 =?us-ascii?Q?L6duOhzsGFzOfJAWkUHTuPn/BsoJ1cWhDio1yqnA8CXd3nWWG2P4q4vuHzbV?=
 =?us-ascii?Q?7LReFZ05jhC7B8XvBTf54XP7mklYEqevMjY3Q4y3MJwId757+i5bg9EzJ7ai?=
 =?us-ascii?Q?ymULvCaMrjPUpO/Xt3NUr5ZAP9IP74eT0HbbbWMHK7jJH/LFFxh5Tu9igxBX?=
 =?us-ascii?Q?FK3vBKeWmwxZsQgZ1/fcAp4nUspkMNcVMOFCmfK1ptxTnGFNPGQy5uXocmKv?=
 =?us-ascii?Q?sA6xWl6XrVJss4+QMGcu7HSfYauqNbzkjOlhOd85v+Jrsb7tyZT7aqDQnWWZ?=
 =?us-ascii?Q?GKr6WnP18T36HbbZ0Xo1q7Qc3YLMrTkPcdXEbauTkab0UjUMj3tAGc5YjMeh?=
 =?us-ascii?Q?9aOiDR0BVBsjzF/crmqSO8QsJAKZhklnk7XKVlTMy2wHm7Jgg7lLdeMIoIS1?=
 =?us-ascii?Q?6o2q8+OnE6TpabhI2VJh5fhmHcVlYaixfbQeAOUkno2HRbVCfag61WmjfdZV?=
 =?us-ascii?Q?2l3T7aW4wZRc0wZSs1fAbD4h4M/Htd8hrYBnABcvkhSKxSyDou8kBLpqYwX0?=
 =?us-ascii?Q?AaGPphCjUNn9v6RJycaYr/M/DIsmIxXe9dnNdAplUV3fn3ONW7a8GYrj8kOE?=
 =?us-ascii?Q?u0mAolMoKsTlSENjSai1x3BkEnc00K5eoi8+i/rxWRMvEdis1zWCAbK3KZ64?=
 =?us-ascii?Q?mIi5r4I2Vz34jFnDMgbhKZtPC9JmuVab7dGyZxtczhX527N/C2qTPzKG4vPW?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3781f547-99e6-4cc9-0208-08ddf5405c13
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:53.0139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ZkJIXBg8y7xGiCM9HtDnRc62hhMw7w7OAbBPSCx4wzlO3PdocwpULZhwIj8SbwHGtb85dqz+mgycC5j+5WfE1ghEc53azOQBIpaEXeyKXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8501
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX/teJHDqHb+Gd
 L5HWhz1C/VqraVGC7b1aYWswFbkQzBJzstuQLx2w7OSoS44byjGSqm+LfFjCTOZySuZaxobqvy6
 l0aEWTW+3Gs1Y6v92B4wG9ocBixfuDudBKV5/3FZwEjvKQD+gvaxy/Zd9arxoSVR9Vkray25hPv
 bY4VOWLamy+gqiL+8Va9Upj5Szccl4U5cFWZpWNSq2BsS9+AilKl2G2Pl6geJMJtMgosUTceXJz
 SOwKExb2KwzKJ/XNOgCdwgpxQMK0POnPExmQtMq68jKCYoXFKRST/3NU2ZY3vrkuvb4F8gwTvpW
 NbRn2khLBMF9tNePWiV2SUBysBfjMcim1cNfP33/Kb25An4L0nbvQV56I2uotw=
X-Authority-Analysis: v=2.4 cv=ePoTjGp1 c=1 sm=1 tr=0 ts=68c99406 cx=c_pps
 a=q7lH8giswqu+5i8oUQ1grQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=LITVrG0iRTpVO32fp-UA:9
X-Proofpoint-ORIG-GUID: qfTe3N3cxGbZ-hTaGYQgImITtYuWhDyb
X-Proofpoint-GUID: qfTe3N3cxGbZ-hTaGYQgImITtYuWhDyb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Migrate to new vmx.h's exit controls, which makes it easier to grok
from one code base to another.

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 x86/vmx.c       |  6 ++--
 x86/vmx.h       | 12 -------
 x86/vmx_tests.c | 86 +++++++++++++++++++++++++++----------------------
 3 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 25a8d9f8..bd16e833 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1132,7 +1132,7 @@ static void init_vmcs_host(void)
 	vmcs_write(HOST_CR4, read_cr4());
 	vmcs_write(HOST_SYSENTER_EIP, (u64)(&entry_sysenter));
 	vmcs_write(HOST_SYSENTER_CS,  KERNEL_CS);
-	if (ctrl_exit_rev.clr & EXI_LOAD_PAT)
+	if (ctrl_exit_rev.clr & VM_EXIT_LOAD_IA32_PAT)
 		vmcs_write(HOST_PAT, rdmsr(MSR_IA32_CR_PAT));
 
 	/* 26.2.3 */
@@ -1257,7 +1257,9 @@ int init_vmcs(struct vmcs **vmcs)
 	ctrl_pin |= PIN_BASED_EXT_INTR_MASK |
 		    PIN_BASED_NMI_EXITING |
 		    PIN_BASED_VIRTUAL_NMIS;
-	ctrl_exit = EXI_LOAD_EFER | EXI_HOST_64 | EXI_LOAD_PAT;
+	ctrl_exit = VM_EXIT_LOAD_IA32_EFER |
+		    VM_EXIT_HOST_ADDR_SPACE_SIZE |
+		    VM_EXIT_LOAD_IA32_PAT;
 	ctrl_enter = (ENT_LOAD_EFER | ENT_GUEST_64);
 	/* DIsable IO instruction VMEXIT now */
 	ctrl_cpu[0] &= (~(CPU_BASED_UNCOND_IO_EXITING | CPU_BASED_USE_IO_BITMAPS));
diff --git a/x86/vmx.h b/x86/vmx.h
index e0e23ab6..30503ff4 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -406,18 +406,6 @@ enum Reason {
 	VMX_XRSTORS		= 64,
 };
 
-enum Ctrl_exi {
-	EXI_SAVE_DBGCTLS	= 1UL << 2,
-	EXI_HOST_64		= 1UL << 9,
-	EXI_LOAD_PERF		= 1UL << 12,
-	EXI_INTA		= 1UL << 15,
-	EXI_SAVE_PAT		= 1UL << 18,
-	EXI_LOAD_PAT		= 1UL << 19,
-	EXI_SAVE_EFER		= 1UL << 20,
-	EXI_LOAD_EFER		= 1UL << 21,
-	EXI_SAVE_PREEMPT	= 1UL << 22,
-};
-
 enum Ctrl_ent {
 	ENT_LOAD_DBGCTLS	= 1UL << 2,
 	ENT_GUEST_64		= 1UL << 9,
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 1ea5d35b..77a63a3e 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -138,7 +138,7 @@ static int preemption_timer_init(struct vmcs *vmcs)
 	vmcs_write(PREEMPT_TIMER_VALUE, preempt_val);
 	preempt_scale = rdmsr(MSR_IA32_VMX_MISC) & 0x1F;
 
-	if (!(ctrl_exit_rev.clr & EXI_SAVE_PREEMPT))
+	if (!(ctrl_exit_rev.clr & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER))
 		printf("\tSave preemption value is not supported\n");
 
 	return VMX_TEST_START;
@@ -147,7 +147,7 @@ static int preemption_timer_init(struct vmcs *vmcs)
 static void preemption_timer_main(void)
 {
 	tsc_val = rdtsc();
-	if (ctrl_exit_rev.clr & EXI_SAVE_PREEMPT) {
+	if (ctrl_exit_rev.clr & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER) {
 		vmx_set_test_stage(0);
 		vmcall();
 		if (vmx_get_test_stage() == 1)
@@ -198,7 +198,8 @@ static int preemption_timer_exit_handler(union exit_reason exit_reason)
 				   vmcs_read(PIN_CONTROLS) &
 				   ~PIN_BASED_VMX_PREEMPTION_TIMER);
 			vmcs_write(EXI_CONTROLS,
-				   vmcs_read(EXI_CONTROLS) & ~EXI_SAVE_PREEMPT);
+				   vmcs_read(EXI_CONTROLS) &
+				   ~VM_EXIT_SAVE_VMX_PREEMPTION_TIMER);
 			vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
 			return VMX_TEST_RESUME;
 		case 4:
@@ -220,7 +221,8 @@ static int preemption_timer_exit_handler(union exit_reason exit_reason)
 			vmx_set_test_stage(1);
 			vmcs_write(PREEMPT_TIMER_VALUE, preempt_val);
 			ctrl_exit = (vmcs_read(EXI_CONTROLS) |
-				EXI_SAVE_PREEMPT) & ctrl_exit_rev.clr;
+				     VM_EXIT_SAVE_VMX_PREEMPTION_TIMER) &
+				    ctrl_exit_rev.clr;
 			vmcs_write(EXI_CONTROLS, ctrl_exit);
 			return VMX_TEST_RESUME;
 		case 1:
@@ -312,8 +314,8 @@ static int test_ctrl_pat_init(struct vmcs *vmcs)
 	u64 ctrl_exi;
 
 	msr_bmp_init();
-	if (!(ctrl_exit_rev.clr & EXI_SAVE_PAT) &&
-	    !(ctrl_exit_rev.clr & EXI_LOAD_PAT) &&
+	if (!(ctrl_exit_rev.clr & VM_EXIT_SAVE_IA32_PAT) &&
+	    !(ctrl_exit_rev.clr & VM_EXIT_LOAD_IA32_PAT) &&
 	    !(ctrl_enter_rev.clr & ENT_LOAD_PAT)) {
 		printf("\tSave/load PAT is not supported\n");
 		return 1;
@@ -322,7 +324,8 @@ static int test_ctrl_pat_init(struct vmcs *vmcs)
 	ctrl_ent = vmcs_read(ENT_CONTROLS);
 	ctrl_exi = vmcs_read(EXI_CONTROLS);
 	ctrl_ent |= ctrl_enter_rev.clr & ENT_LOAD_PAT;
-	ctrl_exi |= ctrl_exit_rev.clr & (EXI_SAVE_PAT | EXI_LOAD_PAT);
+	ctrl_exi |= ctrl_exit_rev.clr & (VM_EXIT_SAVE_IA32_PAT |
+					 VM_EXIT_LOAD_IA32_PAT);
 	vmcs_write(ENT_CONTROLS, ctrl_ent);
 	vmcs_write(EXI_CONTROLS, ctrl_exi);
 	ia32_pat = rdmsr(MSR_IA32_CR_PAT);
@@ -360,13 +363,13 @@ static int test_ctrl_pat_exit_handler(union exit_reason exit_reason)
 	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		guest_pat = vmcs_read(GUEST_PAT);
-		if (!(ctrl_exit_rev.clr & EXI_SAVE_PAT)) {
+		if (!(ctrl_exit_rev.clr & VM_EXIT_SAVE_IA32_PAT)) {
 			printf("\tEXI_SAVE_PAT is not supported\n");
 			vmcs_write(GUEST_PAT, 0x6);
 		} else {
 			report(guest_pat == 0x6, "Exit save PAT");
 		}
-		if (!(ctrl_exit_rev.clr & EXI_LOAD_PAT))
+		if (!(ctrl_exit_rev.clr & VM_EXIT_LOAD_IA32_PAT))
 			printf("\tEXI_LOAD_PAT is not supported\n");
 		else
 			report(rdmsr(MSR_IA32_CR_PAT) == ia32_pat,
@@ -388,7 +391,9 @@ static int test_ctrl_efer_init(struct vmcs *vmcs)
 
 	msr_bmp_init();
 	ctrl_ent = vmcs_read(ENT_CONTROLS) | ENT_LOAD_EFER;
-	ctrl_exi = vmcs_read(EXI_CONTROLS) | EXI_SAVE_EFER | EXI_LOAD_EFER;
+	ctrl_exi = vmcs_read(EXI_CONTROLS) |
+		   VM_EXIT_SAVE_IA32_EFER |
+		   VM_EXIT_LOAD_IA32_EFER;
 	vmcs_write(ENT_CONTROLS, ctrl_ent & ctrl_enter_rev.clr);
 	vmcs_write(EXI_CONTROLS, ctrl_exi & ctrl_exit_rev.clr);
 	ia32_efer = rdmsr(MSR_EFER);
@@ -426,13 +431,13 @@ static int test_ctrl_efer_exit_handler(union exit_reason exit_reason)
 	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		guest_efer = vmcs_read(GUEST_EFER);
-		if (!(ctrl_exit_rev.clr & EXI_SAVE_EFER)) {
+		if (!(ctrl_exit_rev.clr & VM_EXIT_SAVE_IA32_EFER)) {
 			printf("\tEXI_SAVE_EFER is not supported\n");
 			vmcs_write(GUEST_EFER, ia32_efer);
 		} else {
 			report(guest_efer == ia32_efer, "Exit save EFER");
 		}
-		if (!(ctrl_exit_rev.clr & EXI_LOAD_EFER)) {
+		if (!(ctrl_exit_rev.clr & VM_EXIT_LOAD_IA32_EFER)) {
 			printf("\tEXI_LOAD_EFER is not supported\n");
 			wrmsr(MSR_EFER, ia32_efer ^ EFER_NX);
 		} else {
@@ -1736,7 +1741,9 @@ static int interrupt_exit_handler(union exit_reason exit_reason)
 				   PIN_BASED_EXT_INTR_MASK);
 			break;
 		case 7:
-			vmcs_write(EXI_CONTROLS, vmcs_read(EXI_CONTROLS) | EXI_INTA);
+			vmcs_write(EXI_CONTROLS,
+				   vmcs_read(EXI_CONTROLS) |
+				   VM_EXIT_ACK_INTR_ON_EXIT);
 			vmcs_write(PIN_CONTROLS,
 				   vmcs_read(PIN_CONTROLS) |
 				   PIN_BASED_EXT_INTR_MASK);
@@ -1764,7 +1771,7 @@ static int interrupt_exit_handler(union exit_reason exit_reason)
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
 	case VMX_EXTINT:
-		if (vmcs_read(EXI_CONTROLS) & EXI_INTA) {
+		if (vmcs_read(EXI_CONTROLS) & VM_EXIT_ACK_INTR_ON_EXIT) {
 			int vector = vmcs_read(EXI_INTR_INFO) & 0xff;
 			handle_external_interrupt(vector);
 		} else {
@@ -1916,7 +1923,8 @@ static int dbgctls_init(struct vmcs *vmcs)
 	vmcs_write(GUEST_DEBUGCTL, 0x2);
 
 	vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) | ENT_LOAD_DBGCTLS);
-	vmcs_write(EXI_CONTROLS, vmcs_read(EXI_CONTROLS) | EXI_SAVE_DBGCTLS);
+	vmcs_write(EXI_CONTROLS,
+		   vmcs_read(EXI_CONTROLS) | VM_EXIT_SAVE_DEBUG_CONTROLS);
 
 	return VMX_TEST_START;
 }
@@ -1940,7 +1948,7 @@ static void dbgctls_main(void)
 	report(vmx_get_test_stage() == 1, "Save debug controls");
 
 	if (ctrl_enter_rev.set & ENT_LOAD_DBGCTLS ||
-	    ctrl_exit_rev.set & EXI_SAVE_DBGCTLS) {
+	    ctrl_exit_rev.set & VM_EXIT_SAVE_DEBUG_CONTROLS) {
 		printf("\tDebug controls are always loaded/saved\n");
 		return;
 	}
@@ -1992,7 +2000,8 @@ static int dbgctls_exit_handler(union exit_reason exit_reason)
 			vmcs_write(ENT_CONTROLS,
 				vmcs_read(ENT_CONTROLS) & ~ENT_LOAD_DBGCTLS);
 			vmcs_write(EXI_CONTROLS,
-				vmcs_read(EXI_CONTROLS) & ~EXI_SAVE_DBGCTLS);
+				   vmcs_read(EXI_CONTROLS) &
+				   ~VM_EXIT_SAVE_DEBUG_CONTROLS);
 			break;
 		case 3:
 			if (dr7 == 0x400 && debugctl == 0 &&
@@ -4134,7 +4143,7 @@ static void test_posted_intr(void)
 
 	if (!((ctrl_pin_rev.clr & PIN_BASED_POSTED_INTR) &&
 	      (ctrl_cpu_rev[1].clr & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY) &&
-	      (ctrl_exit_rev.clr & EXI_INTA)))
+	      (ctrl_exit_rev.clr & VM_EXIT_ACK_INTR_ON_EXIT)))
 		return;
 
 	vmcs_write(CPU_EXEC_CTRL0,
@@ -4158,13 +4167,13 @@ static void test_posted_intr(void)
 	test_vmx_invalid_controls();
 	report_prefix_pop();
 
-	exit_ctl &= ~EXI_INTA;
+	exit_ctl &= ~VM_EXIT_ACK_INTR_ON_EXIT;
 	vmcs_write(EXI_CONTROLS, exit_ctl);
 	report_prefix_pushf("Process-posted-interrupts enabled; virtual-interrupt-delivery enabled; acknowledge-interrupt-on-exit disabled");
 	test_vmx_invalid_controls();
 	report_prefix_pop();
 
-	exit_ctl |= EXI_INTA;
+	exit_ctl |= VM_EXIT_ACK_INTR_ON_EXIT;
 	vmcs_write(EXI_CONTROLS, exit_ctl);
 	report_prefix_pushf("Process-posted-interrupts enabled; virtual-interrupt-delivery enabled; acknowledge-interrupt-on-exit enabled");
 	test_vmx_valid_controls();
@@ -5113,7 +5122,7 @@ static void test_vmx_preemption_timer(void)
 	u32 pin = saved_pin;
 	u32 exit = saved_exit;
 
-	if (!((ctrl_exit_rev.clr & EXI_SAVE_PREEMPT) ||
+	if (!((ctrl_exit_rev.clr & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER) ||
 	    (ctrl_pin_rev.clr & PIN_BASED_VMX_PREEMPTION_TIMER))) {
 		report_skip("%s : \"Save-VMX-preemption-timer\" and/or \"Enable-VMX-preemption-timer\" control not supported", __func__);
 		return;
@@ -5121,13 +5130,13 @@ static void test_vmx_preemption_timer(void)
 
 	pin |= PIN_BASED_VMX_PREEMPTION_TIMER;
 	vmcs_write(PIN_CONTROLS, pin);
-	exit &= ~EXI_SAVE_PREEMPT;
+	exit &= ~VM_EXIT_SAVE_VMX_PREEMPTION_TIMER;
 	vmcs_write(EXI_CONTROLS, exit);
 	report_prefix_pushf("enable-VMX-preemption-timer enabled, save-VMX-preemption-timer disabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	exit |= EXI_SAVE_PREEMPT;
+	exit |= VM_EXIT_SAVE_VMX_PREEMPTION_TIMER;
 	vmcs_write(EXI_CONTROLS, exit);
 	report_prefix_pushf("enable-VMX-preemption-timer enabled, save-VMX-preemption-timer enabled");
 	test_vmx_valid_controls();
@@ -5139,7 +5148,7 @@ static void test_vmx_preemption_timer(void)
 	test_vmx_invalid_controls();
 	report_prefix_pop();
 
-	exit &= ~EXI_SAVE_PREEMPT;
+	exit &= ~VM_EXIT_SAVE_VMX_PREEMPTION_TIMER;
 	vmcs_write(EXI_CONTROLS, exit);
 	report_prefix_pushf("enable-VMX-preemption-timer disabled, save-VMX-preemption-timer disabled");
 	test_vmx_valid_controls();
@@ -7284,10 +7293,10 @@ static void test_efer_one(u32 fld, const char * fld_name, u64 efer,
 	bool ok;
 
 	ok = true;
-	if (ctrl_fld == EXI_CONTROLS && (ctrl & EXI_LOAD_EFER)) {
-		if (!!(efer & EFER_LMA) != !!(ctrl & EXI_HOST_64))
+	if (ctrl_fld == EXI_CONTROLS && (ctrl & VM_EXIT_LOAD_IA32_EFER)) {
+		if (!!(efer & EFER_LMA) != !!(ctrl & VM_EXIT_HOST_ADDR_SPACE_SIZE))
 			ok = false;
-		if (!!(efer & EFER_LME) != !!(ctrl & EXI_HOST_64))
+		if (!!(efer & EFER_LME) != !!(ctrl & VM_EXIT_HOST_ADDR_SPACE_SIZE))
 			ok = false;
 	}
 	if (ctrl_fld == ENT_CONTROLS && (ctrl & ENT_LOAD_EFER)) {
@@ -7425,8 +7434,8 @@ test_entry_exit_mode:
 static void test_host_efer(void)
 {
 	test_efer(HOST_EFER, "HOST_EFER", EXI_CONTROLS, 
-		  ctrl_exit_rev.clr & EXI_LOAD_EFER,
-		  EXI_HOST_64);
+		  ctrl_exit_rev.clr & VM_EXIT_LOAD_IA32_EFER,
+		  VM_EXIT_HOST_ADDR_SPACE_SIZE);
 }
 
 /*
@@ -7514,7 +7523,7 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
 				test_guest_state("ENT_LOAD_PAT enabled", !!error,
 						 val, "GUEST_PAT");
 
-				if (!(ctrl_exit_rev.clr & EXI_LOAD_PAT))
+				if (!(ctrl_exit_rev.clr & VM_EXIT_LOAD_IA32_PAT))
 					wrmsr(MSR_IA32_CR_PAT, pat_msr_saved);
 			}
 
@@ -7539,12 +7548,12 @@ static void test_load_host_pat(void)
 	/*
 	 * "load IA32_PAT" VM-exit control
 	 */
-	if (!(ctrl_exit_rev.clr & EXI_LOAD_PAT)) {
+	if (!(ctrl_exit_rev.clr & VM_EXIT_LOAD_IA32_PAT)) {
 		report_skip("%s : \"Load-IA32-PAT\" exit control not supported", __func__);
 		return;
 	}
 
-	test_pat(HOST_PAT, "HOST_PAT", EXI_CONTROLS, EXI_LOAD_PAT);
+	test_pat(HOST_PAT, "HOST_PAT", EXI_CONTROLS, VM_EXIT_LOAD_IA32_PAT);
 }
 
 union cpuidA_eax {
@@ -7698,13 +7707,14 @@ static void test_load_host_perf_global_ctrl(void)
 		return;
 	}
 
-	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
+	if (!(ctrl_exit_rev.clr & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)) {
 		report_skip("%s : \"Load IA32_PERF_GLOBAL_CTRL\" exit control not supported", __func__);
 		return;
 	}
 
 	test_perf_global_ctrl(HOST_PERF_GLOBAL_CTRL, "HOST_PERF_GLOBAL_CTRL",
-				   EXI_CONTROLS, "EXI_CONTROLS", EXI_LOAD_PERF);
+			      EXI_CONTROLS, "EXI_CONTROLS",
+			      VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
 }
 
 
@@ -7853,7 +7863,7 @@ static void test_host_segment_regs(void)
 	selector_saved = vmcs_read(HOST_SEL_SS);
 	vmcs_write(HOST_SEL_SS, 0);
 	report_prefix_pushf("HOST_SEL_SS 0");
-	if (vmcs_read(EXI_CONTROLS) & EXI_HOST_64) {
+	if (vmcs_read(EXI_CONTROLS) & VM_EXIT_HOST_ADDR_SPACE_SIZE) {
 		test_vmx_vmlaunch(0);
 	} else {
 		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
@@ -7899,7 +7909,7 @@ static void test_host_addr_size(void)
 	u64 rip_saved = vmcs_read(HOST_RIP);
 	u64 entry_ctrl_saved = vmcs_read(ENT_CONTROLS);
 
-	assert(vmcs_read(EXI_CONTROLS) & EXI_HOST_64);
+	assert(vmcs_read(EXI_CONTROLS) & VM_EXIT_HOST_ADDR_SPACE_SIZE);
 	assert(cr4_saved & X86_CR4_PAE);
 
 	vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
@@ -9603,7 +9613,7 @@ static void enable_posted_interrupts(void)
 	void *pi_desc = alloc_page();
 
 	vmcs_set_bits(PIN_CONTROLS, PIN_BASED_POSTED_INTR);
-	vmcs_set_bits(EXI_CONTROLS, EXI_INTA);
+	vmcs_set_bits(EXI_CONTROLS, VM_EXIT_ACK_INTR_ON_EXIT);
 	vmcs_write(PINV, PI_VECTOR);
 	vmcs_write(POSTED_INTR_DESC_ADDR, (u64)pi_desc);
 }
@@ -10603,7 +10613,7 @@ static int invalid_msr_init(struct vmcs *vmcs)
 	vmcs_write(PREEMPT_TIMER_VALUE, preempt_val);
 	preempt_scale = rdmsr(MSR_IA32_VMX_MISC) & 0x1F;
 
-	if (!(ctrl_exit_rev.clr & EXI_SAVE_PREEMPT))
+	if (!(ctrl_exit_rev.clr & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER))
 		printf("\tSave preemption value is not supported\n");
 
 	vmcs_write(ENT_MSR_LD_CNT, 1);
-- 
2.43.0



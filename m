Return-Path: <kvm+bounces-40988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 583E6A60210
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:11:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1699B1893EC4
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE09E1F5616;
	Thu, 13 Mar 2025 20:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="UNpWwRFt";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="EwxlRRyV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475091F460A;
	Thu, 13 Mar 2025 20:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896638; cv=fail; b=kID+jH4l2relUdjDgdXESw/UZ9p92eHDzBqmwbbIt0JD9FcXf9p0UTx2wbe89yS1cCKgcZD1fhSeCk0uIso1DlNqYaOa0y7v7MpOd7UExmrtf6IdiyH3gvV03xqWj3Zc3RsovrFj2fmtZQyQmP3PxHJlo3hDqupmCUfPy7O74Nc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896638; c=relaxed/simple;
	bh=DRKjt0qA81aiSZvCi2IxGF62FCtcNJgDkKWReNddGfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KlZywWEBuOWmrDjCLUqYBC0/SK6hAHnAmtPthAAeRA4gYTiN/7TOzICClEP0bZOJnlz4oEwf7PJsUyheGXY18BV8RueZzXm4QMGP5RLsi9adizUEdGIUfjTr3xnTR+lFCwxC5XTXCnk0JzXmJjf6IznpHQnb3A0EH3WncTHfYOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=UNpWwRFt; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=EwxlRRyV; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DF21e2009007;
	Thu, 13 Mar 2025 13:10:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=mwggFSD4i1qyf+HJLFYEPAPR9S5ROs80B8RwNDIwb
	VQ=; b=UNpWwRFt4HFzAbGkIHuR300QGnoxD9F7ivVauFwnLeeb86u8JwRh5W6ca
	PU3Fq5GPmxfdGa2n/iHjPO+B6oKg5LH4eLQbSVsmKs2/3/gXwpEd9T1SsvIcqIvM
	YxMlP3g3N2TGkiGFuC4LmKzz9sXS+m0Qh5aa4ijp1kf65Dwi8kd4u/lTs72IX2UI
	rUL8DHqaKJg5yJtkuk7Xn0xDwLK9PVQ4w7He2jvIkpxT977xbAmMSumSOMJVEL/U
	JAy7seJDDNJkaUhUm5NAeem8LRLIEv27GpTnnARMjk6jZCscKYc3BB337gQoTOgo
	nGIsXc0JDcY1cV/AvJevBWOB8Rr/g==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17013078.outbound.protection.outlook.com [40.93.6.78])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9g67gr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qo0t+3t+mrr6LpNmkVDpFnNxBCyTkH3T/pBcHr0QBLrWIsPLMgt9H07cVJ6ntzc7IcBjiY7TVNFTfgFFOkJelo83RonfjgDC6aqoUH4mGSuqjHudcUvY9U3mi78h5vsgBY6qzEJUqxTFp23plMizsaZOWLrtF52yot7Miks4TexU6JGUnFavY3xWnTHeyfK9JEt3LTQa7NbtuZ9eBmZydS5I9H+d61Q9WYSfyCKoTk5TeddGaTTmAeZYdGrQF+//QE2gCyXyUHzdwaT6emGKVQn7giq6FGcTGOA013BWf8KPhp+JvZ2VxLW+tbjA9aS9OSPJMf3woYXhO6YTnHqv2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwggFSD4i1qyf+HJLFYEPAPR9S5ROs80B8RwNDIwbVQ=;
 b=hgMD+Jb/NCQaVct/n4WRjOocjTETHTTPr0rTPj+h/Osm+3vYgaM0E7O2Qn1R/KKRI8Obt5gSIB9a8N6Us7VoayZ3E0MRovIRtp57hi/qocY7V3xDLru54+wYrWmRANZ8am16kxDvGoiquHZ0uZmXfRAqIgL5LW8dU7BMY7awXNq+patirqWRsPAwA5Y37nCRp0iJCnwATuXL6mMAMxW3QkdhwMo/KVdTsHmUWtMRPkf6ffHxtxmnn9KnzTKnqqcnodZBrOlFSzlHbEJuIDdCOJV0xqQcwsNYNgpgRn2RKCngfH09NV6hBoYE0YzM5iCj4IhF8qr0IrLGh6U00d5cQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwggFSD4i1qyf+HJLFYEPAPR9S5ROs80B8RwNDIwbVQ=;
 b=EwxlRRyVe0SoOBsdsa4d0F/NWDF51O+yzgXYLqlCyxG+qQ8jOWfk6Oq+ppUiGiB3DbEaU4fEqT7X7lxOhlEWQ9qry3bm/LLAvLOBJr+gyqj37yeqcprh5VhSi+WS4eJyFeQwcDIAK0dmpwkUZZug3s0IUzSQ/tc4z3Oabmt5KcYD2KpRzHW1IPd6AfZoTnuEwvDPGJj1pZKSE68vUiEiw37KtJ4BAp3UkcsLrT20dqIy88sZBaHgfsiL73d6874ijZWWzlx0zvmC4W/ZU5/XT/1+vwtPqIPAEvjwIVPqfrhU3xV6raKRsXAmPG8FvpAVbCbNQXWiNIJBqs3oNgPfpw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB9384.namprd02.prod.outlook.com
 (2603:10b6:510:280::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:01 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:01 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>, Nikolay Borisov <nik.borisov@suse.com>
Subject: [RFC PATCH 02/18] KVM: nVMX: Decouple EPT RWX bits from EPT Violation protection bits
Date: Thu, 13 Mar 2025 13:36:41 -0700
Message-ID: <20250313203702.575156-3-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
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
X-MS-Office365-Filtering-Correlation-Id: 2fac5f9d-e011-41f2-3bcc-08dd626b08f9
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Nzon/eTT9FMiUGoVFe4dbv+Fdnh+EVgoIdXAAjHsvfFV4489738/1riNLEAI?=
 =?us-ascii?Q?xPmjMXg6qtFhSNngLpk5QQhBB6VS/9N/FeCpniCfiiMNIusMHu4sTSmFs8Uk?=
 =?us-ascii?Q?fMCmQ2RSuTQFumnkQ+CRvnJXndB+9rjQqjXYcUY2qDwqyr7VgF7q0IkSL5W9?=
 =?us-ascii?Q?1xPdwF2Dfp5nMj4feoE7EBBG/xMVSicEMxdfYWfHlmyKMWDq7CT3Oe+8hUiV?=
 =?us-ascii?Q?EydsUY45WpwYfKmoZDCwJUQndH8XjrkEAIZ4Gg7ffg39L3H7C2hf8OPlW59j?=
 =?us-ascii?Q?bCnjOiWMXKFokQeYsZEmPrkBz9wMm+8Vx5KTGSMS2sVJCEZV15m3Lb4Il/hN?=
 =?us-ascii?Q?4NAw6gn4SzYQRUR0SPiP2ufzM5TGntWBS4DIgIuAy8mikwlRQBUKhD+ThKlp?=
 =?us-ascii?Q?TCLSugNN7T98PwtPR7kfJWqMJW/QBpC53YyjJJ0vsyiilpZVflT0G9YCHT+y?=
 =?us-ascii?Q?0Ztxd4vGeLmgRSpVWiZx/DfnZSDQCBPPr450bjhzADcn/vPuTRdUM6jbAeJM?=
 =?us-ascii?Q?qYsOzu5D1WLgYNGVX+99dHvNORZVcdqXL8gUHB0uNMFRShVING5hMYQDA09F?=
 =?us-ascii?Q?JY+lp3LAq5VOcOWjx41CaylitTozMNAqs3hTs6Qv3Xczx1tJC2+NS1QwDBAr?=
 =?us-ascii?Q?dV6VRpvdxljKS3Pyg2EQWeE1nM0dPfLEs62bjAtkUsAWBXHgufzlpFdt/oUI?=
 =?us-ascii?Q?oa19Gdg1x+0juoU+8i5X58KRyidj7KanLtIc6hgbUvr2H2NBlwY0GBVMBEMf?=
 =?us-ascii?Q?8NuXRL5B/i6hu7hCaClGreWVeocZtngCF5aiBmJDuFJ2uSp9VJFCESWJWlqt?=
 =?us-ascii?Q?i3q8hWVhtr3wNJAKcdF2U2HbLUju5RXVJHKx32FRTPpRyd6yGMa3USHcqsWs?=
 =?us-ascii?Q?ZS1oFaQy7mnEVSvLXMd+nPSCptqB/ttKuouecVcDWGQhExlflcOUn3chkdIO?=
 =?us-ascii?Q?ehu1SJyTfNIm9tbAt3w0U4xwqRFPytUWVHvY+UnBKy+82GQp2W0kD+61aGP+?=
 =?us-ascii?Q?lepkjUZk0t45mKdqOk2rEVNzN/45uIgpavifqpM4ikH4qdQAS7+hF5KGb8t4?=
 =?us-ascii?Q?EsHOKuzowe/jtjbHjaXbn2s26aCMTA2eJdVYHUC7jPU53fJCyYGt/WdU1soj?=
 =?us-ascii?Q?kPRfQamRwxYufYAH0m47WdE275HexJm0nxUbnMdc2N53Sm3bHSYomM1oiKZq?=
 =?us-ascii?Q?3XoXFK5/Hj92lglbvz+7odQNVj6hmi9a6/VZt/ePpim3lw7xnCEXeihv3ejf?=
 =?us-ascii?Q?BLMG1Iafxx7eIbRAPEYpJ5Q8gDzoj1PcHJ4mtgD8+tqHUsxuVJiIiyUM4dDc?=
 =?us-ascii?Q?m72FvDaC/i38vqP6uouMrZTeohXirg31qGjGU3eJ4WqZhYTjJsqX74ZtfV3f?=
 =?us-ascii?Q?78I+vowDh0k5/fQae0o1JhhQS/A0sh80qhPxHzq1YrahqakIhnIJQ0ZFdTDo?=
 =?us-ascii?Q?o6DCCJ5BLzVv0NsI+kJzMM3dcfHlSeW5F0YyENo/FxC4/LU4mHfc+w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AFUQk56AD+VfZfHX3BRfflBWWjdO/wcyD8MEDlejkAC1LrBoGjjFW2aCru/f?=
 =?us-ascii?Q?0rhARqnavvk3T9okN+v/N075vyMhMBlpKKAbDoT8FJZIKjAumloeW53nBCIX?=
 =?us-ascii?Q?8bkvu0V5nRuovWMWlJ+3KnnEApLxuN3TolPwZJ+M/81qg0otDFGy66UPbWbI?=
 =?us-ascii?Q?t0Gv6gL9wEylgFik/vSpHvmvrXzvD0K7Jeq0YEqYCemnVmOxE8KavjAckkPe?=
 =?us-ascii?Q?i+PdWzfgk3xs4adgnaHCxpfX8WnaWIOrKFJ6A+zymtE/O+U9o4UsDReaVHZa?=
 =?us-ascii?Q?+z3pbRx1HMrGjlhuqmDCN2Rfy6ynpb+dfYc9ZFyqnBoU9AHcv4dSE2jFWvtw?=
 =?us-ascii?Q?Bn7pvrh7A/3cy/HKR7OE2TnDbh9tzr9o8veEGACkuTz23ZdosYGdLDt+Gn54?=
 =?us-ascii?Q?UijbfXYSLY135DT5g/K9pCXeeG/ECcazPczVQ2tZzdnhm86wKelxWQBA30IL?=
 =?us-ascii?Q?jmKedLuU/9WuWS3QBHtFiMnDbUt6XhAqp7Mg29ZFYkhirRWi98xQ55a71ahf?=
 =?us-ascii?Q?nYtlqzYso0b8ADSbyBhCRVeR7a8KVsaHxh2fVCrR2yfPsWHPebxQn9XSnKh8?=
 =?us-ascii?Q?jL5e+oWrIz6rUkG2JJoIfYwhTX1HFwexeFC0XvXoqqeXw4aPlqO6epiEzKd4?=
 =?us-ascii?Q?K8eKNTd5LtnQEOBsEWjh/pAY+y6OZZd1CHYjZNUtnoUcW7CnLutgIuE8doBA?=
 =?us-ascii?Q?8l1Th+GzUyYJPWdw1j0g2yadskB28J01ZyPJANU8cc/fqdccxD970y09grL7?=
 =?us-ascii?Q?y0ED3JDgEerrzpcaRgnj9aQtJo2m620ZTG9IZHZjRf4ArbBMy4txxMjhEpe4?=
 =?us-ascii?Q?FP3BNK9PKjZXFGE40jOJt4brb7rKKcmB1i5sowD/fVCdHPdWnULQdOnn9Z2I?=
 =?us-ascii?Q?jFBFXwEgGk2XFKYsZt/FOpFcnH9VTSq+F/iIgDCWhIaPn1fK45AegiQ0UpOs?=
 =?us-ascii?Q?RZ8ZAGNrtL2TC+wEa0uaP79ShD/oPwoixbGEl3XLb6S1B5IBifBDy1i9ac5f?=
 =?us-ascii?Q?RSpUtJyYD2nWfggSmsTNQmaA0HGTDmREIxQNukfAXz1lJ9MoUD286PbzMfjA?=
 =?us-ascii?Q?uR1b+Rp04eD3OT5zdwdGIumosYkPy3ArQrxYWcuwhN4v6eQE5FizdyEaKV1j?=
 =?us-ascii?Q?mtRU89KEvC5niyNYyQxIsRc9Uy0q7oa6pnWG4Z3Rz7oR484h3t0nxCkNrbik?=
 =?us-ascii?Q?/LjpE5dNCXhzPKoGzKjdt3Xi+Q0BLo8Hi5cePFiuM2pATLgPiLFrcLkfqyF7?=
 =?us-ascii?Q?gm7y/wqXza8qZyb6W5g+f/GvyMoOMUHFH47tGVAHrLWwtr5DXlXoVOJ9MqUb?=
 =?us-ascii?Q?cmlXZg2LaPqaj4uF2gvXP6CfneLhZXlvWlXRZFOxhTqZV1q5mzP2/su4SIBL?=
 =?us-ascii?Q?G8OqgGqfQB4Fd+8/MMDYuz/ZUnRjJirSoaCWhFDoafnYfmlOpTtJOXQtA3zr?=
 =?us-ascii?Q?iqnw973GTIMtqCf4i+lLXxRLNXbpf1wxBsvNQ8GBbquph7T625HPTVtdipJJ?=
 =?us-ascii?Q?bdSSjNnL+KaZRjvpjuahCeH7n9JH1XWgeTHp/XqRNMI9bEkm7OuNEyb/oPsv?=
 =?us-ascii?Q?oVcal04sAQINFiDxJMxZ3bcy0TSgKGjc0EwaapaaHqEVbiSCiNB6kKtV30B8?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fac5f9d-e011-41f2-3bcc-08dd626b08f9
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:00.9580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GN5TuPYqXYXwuTnk9OVKuGDWpuu/bgXaCnq0XzVLXvrtkTg0y6N6hqacZri81vaEBFxmcoMvNhJkASU4D58ErAz2eac/BncdWL8ioB662Go=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9384
X-Proofpoint-GUID: whR_QPESW8BAYtz--ZZsK4VUYjw963fV
X-Proofpoint-ORIG-GUID: whR_QPESW8BAYtz--ZZsK4VUYjw963fV
X-Authority-Analysis: v=2.4 cv=c4erQQ9l c=1 sm=1 tr=0 ts=67d33b9b cx=c_pps a=BALyy5icRfvvzfOMzojctg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=iox4zFpeAAAA:8 a=3metJUBeehsC971iASgA:9 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

From: Sean Christopherson <seanjc@google.com>

Define independent macros for the RWX protection bits that are enumerated
via EXIT_QUALIFICATION for EPT Violations, and tie them to the RWX bits in
EPT entries via compile-time asserts.  Piggybacking the EPTE defines works
for now, but it creates holes in the EPT_VIOLATION_xxx macros and will
cause headaches if/when KVM emulates Mode-Based Execution (MBEC), or any
other features that introduces additional protection information.

Opportunistically rename EPT_VIOLATION_RWX_MASK to EPT_VIOLATION_PROT_MASK
so that it doesn't become stale if/when MBEC support is added.

No functional change intended.

Cc: Jon Kohler <jon@nutanix.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://lore.kernel.org/r/20250227000705.3199706-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
(cherry picked from commit 61146f67e4cb67064ce3003d94ee19302d314fff)
(cherry picked from commit 8cddacdb6a6a459c9425b4abd4c982cec89c25e4)

---
 arch/x86/include/asm/vmx.h     | 13 +++++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h |  3 +--
 arch/x86/kvm/vmx/vmx.c         |  2 +-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index aabc223c6498..8707361b24da 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -580,14 +580,23 @@ enum vm_entry_failure_code {
 /*
  * Exit Qualifications for EPT Violations
  */
-#define EPT_VIOLATION_RWX_SHIFT		3
 #define EPT_VIOLATION_ACC_READ		BIT(0)
 #define EPT_VIOLATION_ACC_WRITE		BIT(1)
 #define EPT_VIOLATION_ACC_INSTR		BIT(2)
-#define EPT_VIOLATION_RWX_MASK		(VMX_EPT_RWX_MASK << EPT_VIOLATION_RWX_SHIFT)
+#define EPT_VIOLATION_PROT_READ		BIT(3)
+#define EPT_VIOLATION_PROT_WRITE	BIT(4)
+#define EPT_VIOLATION_PROT_EXEC		BIT(5)
+#define EPT_VIOLATION_PROT_MASK		(EPT_VIOLATION_PROT_READ  | \
+					 EPT_VIOLATION_PROT_WRITE | \
+					 EPT_VIOLATION_PROT_EXEC)
 #define EPT_VIOLATION_GVA_IS_VALID	BIT(7)
 #define EPT_VIOLATION_GVA_TRANSLATED	BIT(8)
 
+#define EPT_VIOLATION_RWX_TO_PROT(__epte) (((__epte) & VMX_EPT_RWX_MASK) << 3)
+
+static_assert(EPT_VIOLATION_RWX_TO_PROT(VMX_EPT_RWX_MASK) ==
+	      (EPT_VIOLATION_PROT_READ | EPT_VIOLATION_PROT_WRITE | EPT_VIOLATION_PROT_EXEC));
+
 /*
  * Exit Qualifications for NOTIFY VM EXIT
  */
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ae7d39ff2d07..9bc3fc4a238b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -510,8 +510,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		 * Note, pte_access holds the raw RWX bits from the EPTE, not
 		 * ACC_*_MASK flags!
 		 */
-		walker->fault.exit_qualification |= (pte_access & VMX_EPT_RWX_MASK) <<
-						     EPT_VIOLATION_RWX_SHIFT;
+		walker->fault.exit_qualification |= EPT_VIOLATION_RWX_TO_PROT(pte_access);
 	}
 #endif
 	walker->fault.address = addr;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 87206dabf020..7a98f03ef146 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5831,7 +5831,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
 		      ? PFERR_FETCH_MASK : 0;
 	/* ept page table entry is present? */
-	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
+	error_code |= (exit_qualification & EPT_VIOLATION_PROT_MASK)
 		      ? PFERR_PRESENT_MASK : 0;
 
 	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
-- 
2.43.0



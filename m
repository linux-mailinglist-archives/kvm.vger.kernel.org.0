Return-Path: <kvm+bounces-57746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA2CB59E0D
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 170214E8065
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BD53016FA;
	Tue, 16 Sep 2025 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="A8vYxzbW";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="HTD4SyBJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0B127FD6E
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041099; cv=fail; b=NJN8DlQdS38zV7PkKobXiPHVNjQnDmoCAIArCR7FE/nsnUgF+0rSmg0RyqfksvR0nw9M+gc1Y8eoCofPwAvnrlU9PY/qkLaghoJWrtBv2DlYWrMt442lCqAyYZNFih4myoZfc7SqSDIJ9HuOqPtn37LfWEfjqV0kaggQ8eovI1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041099; c=relaxed/simple;
	bh=tLS6ycvHEcneyv1rp3w5X8LWPo7V/1uV9s6QB+oZaC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VRBiv5UwzQflHs7P8TvO1sflaTHJ+afnleiD+0aUaY6J3clG3r3LcpZSQ5IDLpQGkMDJp9qMtF98MQn+dUL8iMboFioRg5g+BId7+bn2A1rsr9dY9R3LSrL/n4Bm2xIqNPSFEWeNvffe6hwJKZA9c6XF03GKXKF+5mxQtjnkxyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=A8vYxzbW; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=HTD4SyBJ; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58GG3xO63598632;
	Tue, 16 Sep 2025 09:44:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=O3liqjfc3Ir7wn5ujvU37OrZa1rnFANo3YmM7AL53
	KI=; b=A8vYxzbWew8yoxSZK9Dn+BbZVFqyZO/M6YtSfzqOo9NKqG0j3nPOVj5bX
	ptjRbpw79L+zYElqgg9XZznC+0izr+Fiio4ky2x4k5o+k8Itd1EjpmjRlmeyEEYf
	TSlLxpXUVjn5NbywM97by4ujqrYPB6htgSYQWDHbmJ43bd0f4wzHpdIQLhQvMlE/
	TVTJNwM1724Ejpou42jRE9reArGB/oRdYo+ZkQnBlGMHjIuGIVKaEI7w+t8kp2US
	mU67OLbzuWYzJl05NvE4Gl1Z0qggQHbYFeeb/03BUqTqhprDqhkZJqd/M0tsgdMF
	TV6ytT9E9afo0x5wBTr+87A1tQIYw==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022081.outbound.protection.outlook.com [40.107.209.81])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 496pby2vkx-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p7Q9wbmu9aNOOCiG6XSIWkZAMogr2tCgCs/EmuZgJ/RARNc7lk04q+LWdUsPwblrzhvxy37kvcmdhqG6mI+qx30AjcGxQF3HgvOHcCcZYSDflgF1GQ0B56i++Mgg605vDVyeKub4DnoOwXqPZw4ExbA/u+Ce9Jm9LF0yxSmV6KQWt1IYfxvhE5MSEltMVAj8ej/tA70HPTNcEvpDhwvuwLJ7lwbI8xlKTI16COGcW9JvuuXOC6Pk5cxqz1fT/LNqqVkIEYNJXEz4q5nJdx6HTZsqPInMTiQ9XpW7Jn8mGNEfrb3sPebfnrc7zLLUKvyaJUn1XT6sT9cl39wVkwM73w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O3liqjfc3Ir7wn5ujvU37OrZa1rnFANo3YmM7AL53KI=;
 b=pwgQku9u7KIhJuYdBUopiAlCQjj6Ne6/T4FRqhJTLfOuOliZvQF+AUHkDBU2qdTVl4Z/14ERXOCzPgtYmth/MN4rVPtEM05hE0hzPqSb0xhGaJwm3q514OhMtlGVh8nWRwEQyxffec07uXuqz+koEBWXFpiz/aMRUrLmSVXbcYYxvDHYyDv+SmD/L/Mrf4hf0JG74DGMr+XaaOVkWPKQz9EVyZ3iEX2mGSrvgswZ0KuYAvcxjAbr0Rrt3IFWYWrBqADpochgH0DpV5hGiCSsUHPkzaxiz+66MuFHEXNXMotpOj2vLIJ5R9Xc3eWGs82OFoh5LUjk1B8E/Sk8XPNcoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3liqjfc3Ir7wn5ujvU37OrZa1rnFANo3YmM7AL53KI=;
 b=HTD4SyBJD5nuifOH7IPcUaygbAN7Py8E2tJOWWLNzlJMJiQOYfks99Q8+9WJrPvSeLDSymcuQhO1dWBuJ3Nk2F69UxQW3HqnheQDPqtafdz1mRXgO28n0TxMmzC8EqqiA+/2HEdgp2EjgXyEwG5spzX//XPdH9d67eOLZNvMJYlEgNxiIvp5GqtvYdaWz4reLRuvHTVf9T5G56vxduZ6aEgKZxstFLHAE+OXbvs4lLRTlPuI0wDM7CIRKkGuFJaZcymjOIcyVxW1fa3i1NpOX/GShOxqLFyBmJgBoNE1losxqwiVi+xfSDKMSWNMlqO8g9Ncd8IGbNmzt+R/S0WE1A==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:47 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:47 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 08/17] x86/vmx: switch to new vmx.h EPT access and dirty defs
Date: Tue, 16 Sep 2025 10:22:37 -0700
Message-ID: <20250916172247.610021-9-jon@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|DS0PR02MB9620:EE_
X-MS-Office365-Filtering-Correlation-Id: c9b97c53-6fbd-43b1-800e-08ddf54058a2
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?weN5j2fV0/ybtMPM03B2Dg6MzHSsT7MX5brkBF7ANY3M6A1CoF82IOoBC9MR?=
 =?us-ascii?Q?UlRvt1vRsPZ3wmgvQo2B5IdIuHEYplHdd9AnAaMiSHsMEiH22FuUnxxS7cis?=
 =?us-ascii?Q?zBOexBhGBVCNexFnaI2FasycWVJo9njasdMxzbZhxNyoZCMVSVKg+vptaf9/?=
 =?us-ascii?Q?upt6ME8s0e6csG+gLTNQggovldBqlt486W8JYmDAjd+iX7devRL4IEgUaRIJ?=
 =?us-ascii?Q?Z6jUukz/sIIyfaaadxzhvUP4DwbK9gNIqtvOoeEQAUWTwpXDo/WMqJQqRqCr?=
 =?us-ascii?Q?JMOXQiwr4sBhQ4FnRtvHxmGw10mwLdnojmgH7oYwqjTTJ5JA6tAuRJswjque?=
 =?us-ascii?Q?u1qLiZjNCKVoT/o38lZrMqhcHOv7QH396mhm6XL3Lx0vQOrL+IOBt9SNKaEd?=
 =?us-ascii?Q?a7PpNUNKDxWF3rySHK3cphjd+vlhaB70Y2kKTeVbKdDc8Y3Pn8RvibknIX7H?=
 =?us-ascii?Q?krKeaYDhD57RVNRmaBkHNxUvUdlsOpg/VGgJSA0UvNCP1dLGmh6IQwvbmoPC?=
 =?us-ascii?Q?esceJoZmVFMaHDgiQdPkbDhs+gkGJiXfJJ4lbvsX0pp1FPylarbME1n3CyGC?=
 =?us-ascii?Q?GMByAQZqLVXeHe2h5NBp1SjqgnH5KQhZmGW0lKI5ISGXLqfSr8VFgUkcGP3+?=
 =?us-ascii?Q?pw5Jw3KeyGDgZTHn73rpYZ6NHsfoAnIeJoviiaYjjKX/GXOybvFdh5rCEjYh?=
 =?us-ascii?Q?UNp8CtEPp8ouRQyPN6Ji5UVKDDW/CJdNLHqYo3nAGdWihRIL1zxqBhj1L9/b?=
 =?us-ascii?Q?zpzN7RV5INlbPEht6ddLZV2hCiwanQSvFPANds6iPGtI4XrWjJsalTfrbGDr?=
 =?us-ascii?Q?Xb/3ITbjmfBz+mItH6DG7YWX3RmU5yttWqv1dsMPWlSZQTJJCgmpL6mjs4eE?=
 =?us-ascii?Q?OYpzAevEvAqrEhaA6CY+97vNY0Veo2gEY5H3GL3tbz/opYeq8U11X2oxZDZH?=
 =?us-ascii?Q?cWihpCRlo3Ri+yOBQkz6DSAW79RBnOUJshMezmhkbFQh9Ri9FHWeQbYGzy9/?=
 =?us-ascii?Q?Y6zFZ9p99DfenikpcpRVjyo3m/QIH/wcxnM7oDH6g0WvXcNZ8zHVrwP+o3yt?=
 =?us-ascii?Q?/U2oZqMNJwn1SUNWqlJtvbJvaZDYMdNG06z1uG1EFjs7RhNk0CRCDAJQech2?=
 =?us-ascii?Q?R58LfUCV9XKgNSdhVHY8LLvSYl8AKO3MP7sWqpbi2k3HllzCQarrm9rXZ4Go?=
 =?us-ascii?Q?LPFhnpIfiSGnlUC26tMnKTsOYmdG70GKY2pOztBwMebtQr91UAUwcPCn4GSk?=
 =?us-ascii?Q?/Rh3OxyPKETF+gq4+9PmxxkOquMExnkrqkCmJrB/Z2djJ636XFqm0NVJmsT3?=
 =?us-ascii?Q?Kx2W153AA8/QDroJlc/ovDloWM6M3Y1dfNZ7uJggGcmabFP5R7Nqmero3BZH?=
 =?us-ascii?Q?nYgwJqrTXQm2I06ny7lLCd8GWQdYw3BDRIGKWHTxGs9NsMnx3yzgyfuXxLYo?=
 =?us-ascii?Q?j7QFQLdnw3cwnU+ucSgAcGv45it9X2MdDuZ/ltucCmxgnbFqBJuG8A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DJCDGk8ebXLz4p3rx0oqhyVd7iJaZhb2hrQYpNnRxW2vAeKtMuDfjzyqEFhO?=
 =?us-ascii?Q?KRdDHagkHpTbgutvNjJp9LjqKnMpRvGxGxnIC/h0ghx97c0ZsE1JaYHD28th?=
 =?us-ascii?Q?Zcj9LadllarzdGxD40pVPAGHXK44RBA1lJS0XNistftwUJht1h0d0AdBrkDn?=
 =?us-ascii?Q?mHI3aIa94pA4Stvy0ZChuUG3tlXWo3AJBUhM4g0xtny9mwFWxRY9iyJ359Pb?=
 =?us-ascii?Q?gh/O4dEdJgT2vRCRQ5Sder41Z0j7rCSTHb6Ljpw9ig8WFpgFDNaK5TncTAnG?=
 =?us-ascii?Q?M3X/NcPOa/JJnYM4lxPCiuNrLdk6KI+61tEWOKRRBT67SK+o2H/qVvWPPqZJ?=
 =?us-ascii?Q?LNM+AsXV3ZuSMmC8YntSZXWMCsdws8HhgaFqkvvpfFnGKz9RsMBO31ckH9Gx?=
 =?us-ascii?Q?BE6eBMPYy1VZ22eeWiK+EtycROUq0eR/0l/4z9UNHWK+PdFjln/LInLsKyXR?=
 =?us-ascii?Q?qU/P/b3y2rCq7AUU8rp56HsErkIol/u1o7aZjVjbSiElKzlfzGL2uwDLItbc?=
 =?us-ascii?Q?aLlUbuBQMvXaogHEu5LcPwfGjeYi20/YI551t0/Xyj/gdVwVOYRiN78UU7qB?=
 =?us-ascii?Q?ZtG+CIkUq6LI2BvgISSWNHCqdGCci/d7XmGQKDRIX5WkpVUywxdyVMD19cLC?=
 =?us-ascii?Q?1SrNZXWNq7Z1kZth0ztM66U3nx22UFTJyiDbK4h0GPhSsGzEUaKb+ws6MxtA?=
 =?us-ascii?Q?b9yrYvPZahs/w9olW3mJdigzuYtTBqL/mCZVNN5ZG3MsjfK7iFjzHjmY2Qqe?=
 =?us-ascii?Q?8Yer3pbx6NZgA8QTgmSv5MeqSzOKDu3t3GIWBe1B7eQiS7tg7Y3sM/JdLbJY?=
 =?us-ascii?Q?j8JuwGUybD9r3g6DN9YGfABid82aioBaPeH6PtNq9v/dim6thBnVzrUNTKg0?=
 =?us-ascii?Q?fHahPLHaJfKPYGS2WKMk+Ah/at7pLdSTqOCY6+Zdt6+cC50f6ht9DqJXBuRX?=
 =?us-ascii?Q?vsP9X1Ur+gMf9ngEX8+z1p0w+6I10imJ8+rbqptc8NxkodlELdKGBn7XKtzY?=
 =?us-ascii?Q?QP1f7UZt7FkyFTKBrUeQO5sq3bo8yaIvJyGkWD67FiWRyhBcZgnXPlkQaITX?=
 =?us-ascii?Q?Dq7ElIK7MbEv84Xxgt2fY+4U4a0fFdedSdv+wZXU4mnqiqRwyGHPKW83K7bw?=
 =?us-ascii?Q?GB8rAaQQuW5d5jUVvtYNI8F0OSf1URwFWvtK7B9ZxUkRir4KyUS0BgVhee/L?=
 =?us-ascii?Q?di3ssSPnouphOozdgj9EW4oia+H0iFMB6UiUOJ6ln8ZhEdHoemNNDe1aKxQ/?=
 =?us-ascii?Q?leuEtgO6yStI/WmKP4ON5XCH9JnrnucIu6lONoUPenbDtfwx7dUNVIP2vPdx?=
 =?us-ascii?Q?LsSEHUjJedrkB1qc15sqwRMeHqkKuu4sVylHKV96gj5fQDuZ3NfNIqaprSxS?=
 =?us-ascii?Q?86M49nRrD3XtRVQci3MlAUDy6k/kT46APqO8deXzdxCXIh8yiY1noPZlw4M1?=
 =?us-ascii?Q?wSE4aa4mnKVqANBhNH+pL6tzNjPOXfhyv7/WSZDV4x7cPWFlycr/dJt0m3ur?=
 =?us-ascii?Q?grYAz7i/5l9kuG2V19jGtQcL12Ih7h4IvTGPldjG4rAfRFnRp8IwvxlgrFuZ?=
 =?us-ascii?Q?nQcmRnbyiupErBTF1K+GdnxGrzQWG7Vyo6xNz7+iLj3LSY3yaVtZgEXVNngV?=
 =?us-ascii?Q?vg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b97c53-6fbd-43b1-800e-08ddf54058a2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:47.2952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6x15jjb9ka88blaOu9PYz+jcINGX1vhciTjmJlP/z0yPVKx8DITwl5pgvzYFwfdTwvpkgii3qw3sLss4n5apioDGVvmakduyCTZ92B1Via4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX7i8CcpczShRq
 3gB/8t4CRu5GjzzABg/6j9llcQJoU4i/Dy0Hvx7GNKYMYqinFjQy8o3m27LMwqKLyQhHTtq9suX
 YTsDumhcZMeXt505RtV5iayoPVhTK+6XD/I2aJcy0bUjN4Z/ZqrYUlXUsmV+2eJA5UiSfFofsvk
 2A1/cFUvQoOFV7fv0df840ZiwT3m14XRh/xFb/R8L0aJJwuVB07jO3xcxM7J6m/z2FOVuc9OI0+
 IOW/2ST9iDtUOjFacwJAE05+kL4Z40OEJsHGPihAHp5FNJVlWYUPE9R8tx3C08CG7dUDibmaI62
 r1wN8qbsoWDAhbXnG6Raed9/fBW7Af11CMPKlbD8ZNlPCRHL3Vindods9z3DhE=
X-Authority-Analysis: v=2.4 cv=ePoTjGp1 c=1 sm=1 tr=0 ts=68c99400 cx=c_pps
 a=XJoAL0HPiv6B0cYJlRTKVw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=u94jg9_LdWflmorIW6IA:9
X-Proofpoint-ORIG-GUID: iZIhuDsxShcQ2b7MwdxrWtGmCzzvI44G
X-Proofpoint-GUID: iZIhuDsxShcQ2b7MwdxrWtGmCzzvI44G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Migrate to new vmx.h's EPT defs for access and dirty bits, which makes
it easier to grok from one code base to another.

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 x86/vmx.c       | 20 +++++++++++---------
 x86/vmx.h       |  3 ---
 x86/vmx_tests.c | 43 ++++++++++++++++++++++++-------------------
 3 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 6b7dca34..a3c6c60b 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -986,7 +986,7 @@ static void clear_ept_ad_pte(unsigned long *pml4, unsigned long guest_addr)
 
 	for (l = EPT_PAGE_LEVEL; ; --l) {
 		offset = (guest_addr >> EPT_LEVEL_SHIFT(l)) & EPT_PGDIR_MASK;
-		pt[offset] &= ~(EPT_ACCESS_FLAG|EPT_DIRTY_FLAG);
+		pt[offset] &= ~(VMX_EPT_ACCESS_BIT | VMX_EPT_DIRTY_BIT);
 		pte = pt[offset];
 		if (l == 1 || (l < 4 && (pte & EPT_LARGE_PAGE)))
 			break;
@@ -1043,12 +1043,14 @@ void check_ept_ad(unsigned long *pml4, u64 guest_cr3,
 		}
 
 		if (!bad_pt_ad) {
-			bad_pt_ad |= (ept_pte & (EPT_ACCESS_FLAG|EPT_DIRTY_FLAG)) != expected_pt_ad;
+			bad_pt_ad |=
+				(ept_pte & (VMX_EPT_ACCESS_BIT | VMX_EPT_DIRTY_BIT)) !=
+					expected_pt_ad;
 			if (bad_pt_ad)
 				report_fail("EPT - guest level %d page table A=%d/D=%d",
 					    l,
-					    !!(expected_pt_ad & EPT_ACCESS_FLAG),
-					    !!(expected_pt_ad & EPT_DIRTY_FLAG));
+					    !!(expected_pt_ad & VMX_EPT_ACCESS_BIT),
+					    !!(expected_pt_ad & VMX_EPT_DIRTY_BIT));
 		}
 
 		pte = pt[offset];
@@ -1061,8 +1063,8 @@ void check_ept_ad(unsigned long *pml4, u64 guest_cr3,
 
 	if (!bad_pt_ad)
 		report_pass("EPT - guest page table structures A=%d/D=%d",
-			    !!(expected_pt_ad & EPT_ACCESS_FLAG),
-			    !!(expected_pt_ad & EPT_DIRTY_FLAG));
+			    !!(expected_pt_ad & VMX_EPT_ACCESS_BIT),
+			    !!(expected_pt_ad & VMX_EPT_DIRTY_BIT));
 
 	offset = (guest_addr >> EPT_LEVEL_SHIFT(l)) & EPT_PGDIR_MASK;
 	offset_in_page = guest_addr & ((1 << EPT_LEVEL_SHIFT(l)) - 1);
@@ -1072,10 +1074,10 @@ void check_ept_ad(unsigned long *pml4, u64 guest_cr3,
 		report_fail("EPT - guest physical address is not mapped");
 		return;
 	}
-	report((ept_pte & (EPT_ACCESS_FLAG | EPT_DIRTY_FLAG)) == expected_gpa_ad,
+	report((ept_pte & (VMX_EPT_ACCESS_BIT | VMX_EPT_DIRTY_BIT)) == expected_gpa_ad,
 	       "EPT - guest physical address A=%d/D=%d",
-	       !!(expected_gpa_ad & EPT_ACCESS_FLAG),
-	       !!(expected_gpa_ad & EPT_DIRTY_FLAG));
+	       !!(expected_gpa_ad & VMX_EPT_ACCESS_BIT),
+	       !!(expected_gpa_ad & VMX_EPT_DIRTY_BIT));
 }
 
 void set_ept_pte(unsigned long *pml4, unsigned long guest_addr,
diff --git a/x86/vmx.h b/x86/vmx.h
index 3f792d4a..65012e0e 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -570,7 +570,6 @@ enum Intr_type {
 #define EPTP_PG_WALK_LEN_MASK	0x38ul
 #define EPTP_RESERV_BITS_MASK	0x1ful
 #define EPTP_RESERV_BITS_SHIFT	0x7ul
-#define EPTP_AD_FLAG		(1ul << 6)
 
 #define EPT_MEM_TYPE_UC		0ul
 #define EPT_MEM_TYPE_WC		1ul
@@ -578,8 +577,6 @@ enum Intr_type {
 #define EPT_MEM_TYPE_WP		5ul
 #define EPT_MEM_TYPE_WB		6ul
 
-#define EPT_ACCESS_FLAG		(1ul << 8)
-#define EPT_DIRTY_FLAG		(1ul << 9)
 #define EPT_LARGE_PAGE		(1ul << 7)
 #define EPT_MEM_TYPE_SHIFT	3ul
 #define EPT_MEM_TYPE_MASK	0x7ul
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index eda9e88a..f7ea411f 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1066,7 +1066,7 @@ static int __setup_ept(u64 hpa, bool enable_ad)
 	eptp |= (3 << EPTP_PG_WALK_LEN_SHIFT);
 	eptp |= hpa;
 	if (enable_ad)
-		eptp |= EPTP_AD_FLAG;
+		eptp |= VMX_EPTP_AD_ENABLE_BIT;
 
 	vmcs_write(EPTP, eptp);
 	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0)| CPU_SECONDARY);
@@ -1141,19 +1141,19 @@ static int enable_unrestricted_guest(bool need_valid_ept)
 
 static void ept_enable_ad_bits(void)
 {
-	eptp |= EPTP_AD_FLAG;
+	eptp |= VMX_EPTP_AD_ENABLE_BIT;
 	vmcs_write(EPTP, eptp);
 }
 
 static void ept_disable_ad_bits(void)
 {
-	eptp &= ~EPTP_AD_FLAG;
+	eptp &= ~VMX_EPTP_AD_ENABLE_BIT;
 	vmcs_write(EPTP, eptp);
 }
 
 static int ept_ad_enabled(void)
 {
-	return eptp & EPTP_AD_FLAG;
+	return eptp & VMX_EPTP_AD_ENABLE_BIT;
 }
 
 static void ept_enable_ad_bits_or_skip_test(void)
@@ -1350,12 +1350,15 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 		case 0:
 			check_ept_ad(pml4, guest_cr3,
 				     (unsigned long)data_page1,
-				     have_ad ? EPT_ACCESS_FLAG : 0,
-				     have_ad ? EPT_ACCESS_FLAG | EPT_DIRTY_FLAG : 0);
+				     have_ad ? VMX_EPT_ACCESS_BIT : 0,
+				     have_ad ? VMX_EPT_ACCESS_BIT |
+					       VMX_EPT_DIRTY_BIT : 0);
 			check_ept_ad(pml4, guest_cr3,
 				     (unsigned long)data_page2,
-				     have_ad ? EPT_ACCESS_FLAG | EPT_DIRTY_FLAG : 0,
-				     have_ad ? EPT_ACCESS_FLAG | EPT_DIRTY_FLAG : 0);
+				     have_ad ? VMX_EPT_ACCESS_BIT |
+					       VMX_EPT_DIRTY_BIT : 0,
+				     have_ad ? VMX_EPT_ACCESS_BIT |
+					       VMX_EPT_DIRTY_BIT : 0);
 			clear_ept_ad(pml4, guest_cr3, (unsigned long)data_page1);
 			clear_ept_ad(pml4, guest_cr3, (unsigned long)data_page2);
 			if (have_ad)
@@ -1451,7 +1454,8 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 		switch(vmx_get_test_stage()) {
 		case 3:
 			check_ept_ad(pml4, guest_cr3, (unsigned long)data_page1, 0,
-				     have_ad ? EPT_ACCESS_FLAG | EPT_DIRTY_FLAG : 0);
+				     have_ad ? VMX_EPT_ACCESS_BIT |
+					       VMX_EPT_DIRTY_BIT : 0);
 			clear_ept_ad(pml4, guest_cr3, (unsigned long)data_page1);
 			if (exit_qual == (EPT_VIOLATION_ACC_WRITE |
 					  EPT_VIOLATION_GVA_IS_VALID |
@@ -1463,7 +1467,8 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			break;
 		case 4:
 			check_ept_ad(pml4, guest_cr3, (unsigned long)data_page1, 0,
-				     have_ad ? EPT_ACCESS_FLAG | EPT_DIRTY_FLAG : 0);
+				     have_ad ? VMX_EPT_ACCESS_BIT |
+					       VMX_EPT_DIRTY_BIT : 0);
 			clear_ept_ad(pml4, guest_cr3, (unsigned long)data_page1);
 			if (exit_qual == (EPT_VIOLATION_ACC_READ |
 					  (have_ad ? EPT_VIOLATION_ACC_WRITE : 0) |
@@ -2517,11 +2522,11 @@ static void ept_access_paddr(unsigned long ept_access, unsigned long pte_ad,
 		if (ept_ad_enabled()) {
 			for (i = EPT_PAGE_LEVEL; i > 0; i--) {
 				TEST_ASSERT(get_ept_pte(pml4, gpa, i, &epte));
-				TEST_ASSERT(epte & EPT_ACCESS_FLAG);
+				TEST_ASSERT(epte & VMX_EPT_ACCESS_BIT);
 				if (i == 1)
-					TEST_ASSERT(epte & EPT_DIRTY_FLAG);
+					TEST_ASSERT(epte & VMX_EPT_DIRTY_BIT);
 				else
-					TEST_ASSERT_EQ(epte & EPT_DIRTY_FLAG, 0);
+					TEST_ASSERT_EQ(epte & VMX_EPT_DIRTY_BIT, 0);
 			}
 		}
 
@@ -4783,7 +4788,7 @@ static void test_eptp_ad_bit(u64 eptp, bool is_ctrl_valid)
 {
 	vmcs_write(EPTP, eptp);
 	report_prefix_pushf("Enable-EPT enabled; EPT accessed and dirty flag %s",
-	    (eptp & EPTP_AD_FLAG) ? "1": "0");
+			    (eptp & VMX_EPTP_AD_ENABLE_BIT) ? "1" : "0");
 	if (is_ctrl_valid)
 		test_vmx_valid_controls();
 	else
@@ -4872,20 +4877,20 @@ static void test_ept_eptp(void)
 	 */
 	if (ept_ad_bits_supported()) {
 		report_info("Processor supports accessed and dirty flag");
-		eptp &= ~EPTP_AD_FLAG;
+		eptp &= ~VMX_EPTP_AD_ENABLE_BIT;
 		test_eptp_ad_bit(eptp, true);
 
-		eptp |= EPTP_AD_FLAG;
+		eptp |= VMX_EPTP_AD_ENABLE_BIT;
 		test_eptp_ad_bit(eptp, true);
 	} else {
 		report_info("Processor does not supports accessed and dirty flag");
-		eptp &= ~EPTP_AD_FLAG;
+		eptp &= ~VMX_EPTP_AD_ENABLE_BIT;
 		test_eptp_ad_bit(eptp, true);
 
-		eptp |= EPTP_AD_FLAG;
+		eptp |= VMX_EPTP_AD_ENABLE_BIT;
 		test_eptp_ad_bit(eptp, false);
 
-		eptp &= ~EPTP_AD_FLAG;
+		eptp &= ~VMX_EPTP_AD_ENABLE_BIT;
 	}
 
 	/*
-- 
2.43.0



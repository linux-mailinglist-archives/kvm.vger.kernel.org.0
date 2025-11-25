Return-Path: <kvm+bounces-64521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E303CC862D5
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:18:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 32E14347915
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D99832A3DA;
	Tue, 25 Nov 2025 17:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="JNY5p0/7";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mK/PG1DR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0AD277C9A;
	Tue, 25 Nov 2025 17:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764091107; cv=fail; b=CZG0JqJ3pR/qYwpIHjFQmnNhuQolTd3W3GypErBnYafVtBY8DfNKILY9+yVt2F19GKRvrQijrxth2Fu/dyEo2zqdqgT7NZYkAEPWN1CqFK8sHVZUpITXbGlcfFhw0aehRGn3E4KuueA+qeUgw/ESV76/+g0fD6xUCpnrqZ5lI3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764091107; c=relaxed/simple;
	bh=qDlAsF81+OFmC935iXkr3eFVk9ci5oxGESxaDx2Bv28=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=G9ZDjjWlor5dWtDkPbYOGeORc8h6Lz2nK5hL8bDvxwg3R5UYRqJUguxDpyKrg1LtNfEDr0T8FmrzOleREWIjsDY3o12y3HLUccuLTrn2lZAzXmr9ga/E15JTjWR+Uy2DqtrMZQ+stA0Fihl27wmInSzkT0VfBS3lB3/0z7vDeWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=JNY5p0/7; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mK/PG1DR; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5APGKcqj2184024;
	Tue, 25 Nov 2025 09:18:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=y3JXyEb9emgzo
	GZOWW/swByJPtgIsblLqFLtLUepdLA=; b=JNY5p0/7I5CLPuLc1itusP07PQ2er
	agifZ6H+HnAfqQn/RrUbynECPNfT+xuCijcAH7zwV0MC5a7IHcGazqs3xaVB/sXi
	VreaPm9aWopZecTWuIyEhCN51V6YQ2yMtM+5wy/mDq2co4HjEYSWe17S9BNmT7fS
	PEI0J5/zr2YscC7XRa46x5nV7Mk2Y45Z5G/96GjwMBWCStBhI+oiziFve5rKF4RC
	kJIZmB6Dr4yILHmhtpfx9QYaT8omqXZqzrsGi65qNsAOmHLXhDfvP7POQR1ZWuHw
	VeEfOHkk+Y8vk5DkXGlTDQTpgZJQ4Ga2ELJcXdwx94HwUgGv0k/8hud8w==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023115.outbound.protection.outlook.com [40.107.201.115])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4anfw404hn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 09:18:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ShT7k0ccfRRZk0zEF6AWQdWWu/wqBC0EZ3FZtyBDrZw6JpkuwBG4wA4UaDgWkbuDyuXrSa70ydSfTWJsyeImIMpd/4rxubqI21gqgqfQg6ySV5EtrFrmSNFB0vZp4SHvYVXx8ARVEBEMvXavtZq4OI1toLzfkWNnij5p4B7yE9ftvIDAQa0Yo0k5cnAFbdtndJqZ4pyMT1fz9Lmas4Hpn85pq1B6RCA6Q5r15ncIva1l3zncuyYHBygKgPWV73YqDyp/WrOuIhVn6GNRca8vMtwmM80XzWhi3l0zHLGJS5pxLacVEyef+DWYZ5AgbPWfQTz96Gx3NdEMq6WV1NO7LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y3JXyEb9emgzoGZOWW/swByJPtgIsblLqFLtLUepdLA=;
 b=CfWSfCPMd0phpJrjysgC1nmeE4Y3gseGf7G98m/AygdWFrV/w24F9J4eTdHXqI+Oz8Zn/wZaJAeD86nNFoBGDtcpCgAC5c0aY9+qZwMGbw7keNmWGO/VQdL1WZcWRbog+/Dm+jfDPfIJLskYJwNf4oVV0ffOlIow/lQZqglKM1x0vGI3IcQJLpoblXpELsEkMg2pQCkyURvaFXwOElYf/2G1aEl+UsTp2e9tdA8alF4/62AejhQ6Qpf1Fe4cfn88y9Myc3zfWt3wM+jqVpvDlCyWppGMA+EkJFGiyY/BIr8ufevk/evRRBWw3bAnUH378EXRs6jJCRw63XYJwFkxUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3JXyEb9emgzoGZOWW/swByJPtgIsblLqFLtLUepdLA=;
 b=mK/PG1DRd7C8t2mHHJUCcCFBXezoAa/0KM3rukji6wp2hxSuBSLOFOG3NDVkahN1b9aq4Dovb3o1pk8l9nrIYDA9HUm5KlII8mO5uX2pWPuVz1Sd81gY3XhOSnheCMf0yUwHDDTCNJStUJQv5DwqfNizPAD1B1fK0z1V6P4hIzfjrH6NT/RutSerTZmzNTdRF+qvZjT/j4PHJpSzHh9Bz9veM9V+iXz6VqcwEBJIj2osZzrTyE2xRpSp/TmM23xagfhsR9mLWVAZwj+rf/uhvkValO985KV/1PM4b2lYJAz44y3QfzSSQHyxkgFoSCfALphsSHUnFLwZTVpQGepZfQ==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SJ2PR02MB9365.namprd02.prod.outlook.com
 (2603:10b6:a03:4c0::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 17:18:15 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 17:18:15 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [PATCH net-next] vhost/net: check peek_head_len after signal to guest to avoid delays
Date: Tue, 25 Nov 2025 11:00:33 -0700
Message-ID: <20251125180034.1167847-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::14) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|SJ2PR02MB9365:EE_
X-MS-Office365-Filtering-Correlation-Id: d2928c52-05dd-41cc-d9a1-08de2c469ebb
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?liqww2g6m4/4fUTLP1W/m0HpYG0G0gRORM9xiQFTS0+eQhoh0/IINGdU03pS?=
 =?us-ascii?Q?yg08WQaxUUtyQn7QCaGCqToUZGh9r283avGYjA8RocN+e/LA8exlKXIqyIH7?=
 =?us-ascii?Q?zb+h0ROImo6o7X7KUFNxIYTAg2lJ0MVXVujk9gGzNqu3GYYRgeTLxz6h7s0a?=
 =?us-ascii?Q?Mx7J+0vfiQPGyIR1cIVA16taGtANiotgCGHKH9HDeqPqE59wPAPF5uU5enov?=
 =?us-ascii?Q?zSsbEkMh7vH6ym4nqOdLwZl5VWLjg97e1PRO5x5KTZ+L62FGSNlbexlW/zA4?=
 =?us-ascii?Q?ADPa112SAKYgaCNVbnXb19pUo3P/XdzwWBG9V8SIeVMA1ru2uJKfI1no1TaI?=
 =?us-ascii?Q?cc1HwfXNdWbo1ohsVK5kYFponRpJjLkl4kXMFiryFg1GaNeUyHaLl4uDHgx2?=
 =?us-ascii?Q?nnQSYcFEU7SIxp6LkwSIifHvaaVKbr0FzSh1WW/6L15km3GWk8NbskRrng1d?=
 =?us-ascii?Q?a3xsklkdBcSDkUE/5clYNxZXUvT1EmGxJB4AXBB0BT1igBKrCyRa+P3BZbDy?=
 =?us-ascii?Q?+sH2DDyM4fW7yhKpjUUXvanrzLEwPHpwebEWOj6Infw8nQPN+CfC+2T8ZRQx?=
 =?us-ascii?Q?qcfUgKWvJt4Pe+AJUsADewvJ48O+5M8F6BE3SSSHldo5bacDUpXY7saecnGX?=
 =?us-ascii?Q?px18nxV/49qRtPCFuVMxjUJdZTEMJ+UYcd0YsEuQ1E1XBa2CbX6qlee9lekY?=
 =?us-ascii?Q?nuAR9auPp1bNdEVfqAzMgTDVOMOWUHC+veVleu4fhWNM4CtBsdb/AWm1ibE/?=
 =?us-ascii?Q?gGkCSxy7XNKp1J8qbLCBJwEbps8K30YSnIN9vl5vduJkwj8Itk6Hgfj4a/OX?=
 =?us-ascii?Q?gEwMUyhfZYZx7yu2kL22eyXRIicZhGx0fA3DrEy672ox1r/MZc+7+vDM7HWw?=
 =?us-ascii?Q?haaOVuROCAtTrZlTXMD3LzSUtW2kxvpYz1WEf+YKTLwASapc0/d6eQKXxzks?=
 =?us-ascii?Q?IbcX5MS2UeCyqRj9/kFIwjlfqqjZUOWkPQ9TMuPmu5F3b1Jld8yGDF40lPJ6?=
 =?us-ascii?Q?AvHrtDwzkz09qqfWpel3Klh/V6lUP7rsD1zvVC7BSbQbPuGD1StaFuutO26S?=
 =?us-ascii?Q?p0K4MsXnqIDVfD6zENdSGFCnbB6R+JllDoMlT8cZNQLeb7DHYPv1Fj++/nUl?=
 =?us-ascii?Q?ACs2QuZldYjRuY0sEoKVOryeGSLTuhJQTBN5qk+DIi6Ebh2ccQO2tEqh9WWI?=
 =?us-ascii?Q?WJhAZx5gf2F1usydNitAVDliclAueINJ7NQCvQxxZduYCmVN+hfg2uIUt5ro?=
 =?us-ascii?Q?4srCxLOv8iUwEytdUzHU1KDl0RzJ/Ph68R47ja8PY4dhaMb9oSw74/sKpxYX?=
 =?us-ascii?Q?H5iFAlY/JZKeZOjOJWBQtvrN/LHWX8yA33gXMwAzXI5oDZuhLWLHKm8p7o8M?=
 =?us-ascii?Q?t7t6ZlbZXY8pFiv5D3VjCvwoSBZ8zJ7likUz8jzhxayCcgnhNjcHEI24hfLI?=
 =?us-ascii?Q?oChBUFq83YTX5zdTW0Vyw6iKfeuxfBQlirZYVMZ7Xpy4lBC8qZ0OxVWI1Xse?=
 =?us-ascii?Q?JsW5opVogMo6OsvO8h7fs/YY0ZwoMhLX2nZH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eqzTSaDLKizweBwhWm7qAuj5OjqoNVShe4jySDdL+0TSu0jEYpHKI/zZYflG?=
 =?us-ascii?Q?vxh0fDBLgAqOvj9Aw10oh/UTV3ainAMhuYOEa4QAuU9ZR22SSCuzVjcxmwgR?=
 =?us-ascii?Q?D5OUAYxb3yW2Ij2y2eDHvxa4t2aBfBF1sQeb3ZvWw3MTfTYD9WlER939TWKZ?=
 =?us-ascii?Q?EUrZnH2q/fFva22L7DgYqOOvzf0Ue8DtlV/IfKlYYuUvgnJVk/802gDT413t?=
 =?us-ascii?Q?VQFQ0YKO4SOnL/pfZVTd/0YA4jUYCvjueY5KX+sxJ7POX2rrAi0J+z17jQj3?=
 =?us-ascii?Q?Xpb9qbKMgsWW6CJyOjS8C2Hhg/kLFDGu1hLjdkoMdZmpMwg1ZXy62lNnt6Qh?=
 =?us-ascii?Q?eJXemmGRWi588ymnrC6v76mUnv50T7v+n1td9eVY+UzFOQDeKIKAjmoqYfPq?=
 =?us-ascii?Q?WXlYpEuJXh6ZqMY2GbQXXM5NdvszVFlLwLv1j21wagtbrlabt6sEg2wr0UQw?=
 =?us-ascii?Q?TO3tQdY+mKEStd8VUqTV2eu6BvExJ0zbrH4HMZ83voswBZwjFH6NnK6pOd/F?=
 =?us-ascii?Q?zups3l8zQg0q8urrhkV/cNPjs7RiSxhNhIjQyPpkNXjM7G4WTQmedkhsmyRy?=
 =?us-ascii?Q?FQsdt6zbii3e9LOX7XhcaVbtV/E9EVgw7gpqVure7oQGnLnPk4zUA4Sw6A6M?=
 =?us-ascii?Q?Q8io2FgPfN4gf2aXfbM2dzRJ6Z0Zvm85CrnBH5Px6kP2vw1lDJAhWuEeUm19?=
 =?us-ascii?Q?STAd9WFeYfp//mjx0l6uljyo3e3mwH0XIqsl9LVWMpjeiaoAuCDSNPtgrdCA?=
 =?us-ascii?Q?1a4DK6EqPEpRQ6BJjvpOK9hormMRna9nl+nhqNOcKlijJzLfCLAzzC+U1QsD?=
 =?us-ascii?Q?y0icAsi+Le3JUymSF24afTQl479i0OmgqqdCIQ+Gn2LcL/USTK1Cy8SuXV1A?=
 =?us-ascii?Q?dlCjUWAObzSJnXJYEO+fFf3At+TU0Co81LkayCvjDFYhpiSReGyXRmr8XvH3?=
 =?us-ascii?Q?bTDOk63wtbLTyIzNIqwzarFswmmysdbrflNCVLTM84LvEAf85DhZDOoY8wdw?=
 =?us-ascii?Q?gctWZl7lc2GLRe8rx0d+39ytHyJ7wGwgXjKWn2V8fiRd4K+WKV/etEtWpzdV?=
 =?us-ascii?Q?VjFOH0bqWHt+eZvDC6cIl8MnKCL34FlcjNW04QruMS4O0/vOwdR7u37X9tBZ?=
 =?us-ascii?Q?8V6U+wXY+hD1A8JCq/eMA0gOK80dlitmBSH+e4geecu+rbpWpdk4+fyfTzyj?=
 =?us-ascii?Q?w3hS2Ui7+riSSp99KA/NT9PCp7bhmTvU8RkLIlAobt7EbOpsFgUVs4ClUgrz?=
 =?us-ascii?Q?zO2dKPgEpcLxRLq0VeHqc3gAeXUPVCv08SbczltZHy9NWssKmGu1ZgsGm0Ri?=
 =?us-ascii?Q?EA432Sl1cSr1iu5UcLJc8K+chG5E0iy3vF02lj3NVmXl1kAvNpmBpxBeMcz0?=
 =?us-ascii?Q?snVpbA3FvPunIQrE1OwPXLPOXrsFW/+y72LUGd0vebLb/OuDS0k7flt3qqUv?=
 =?us-ascii?Q?jrTZR1ju4kXPODYk6zzG4R0IR0DrMLEKly1LmomMqOr7/lkldAaSlIiI/AG5?=
 =?us-ascii?Q?OPL+i6Tb2uCtYJ4BTAWPaOljrcvBdGswJeWgsv21bOT3Kq3GmSmXGcRBHpPR?=
 =?us-ascii?Q?NWTUJw9tn3/YKfNBZEtJPI1w5KKxITYxDYB+3L7oC1qzQs+JizKx/0gyuKa6?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2928c52-05dd-41cc-d9a1-08de2c469ebb
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 17:18:15.6302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8m7Cqyced69z6mSKVMErF6db8iomaw+5Fk5HqsxFH3JpRumOVO11ChZPtApiTU8RXa+jMZEFm7RZ+J2hyV66077kX1I5E7FEStmBs4KLOAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB9365
X-Proofpoint-GUID: WNX5CWbPhmK9qVxYwpqd_LF0Q-lltc_m
X-Authority-Analysis: v=2.4 cv=NfzrFmD4 c=1 sm=1 tr=0 ts=6925e4db cx=c_pps
 a=8YD3JtO18OBpAIphJ6JiAg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=NxMCxB6-z5oOyHCSQ6cA:9
X-Proofpoint-ORIG-GUID: WNX5CWbPhmK9qVxYwpqd_LF0Q-lltc_m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI1MDE0NCBTYWx0ZWRfX6vwQBhyns0wS
 /NFg6leFKyuHgndVr3GjP21o3iDjhDGV+uhzDQN1RVCD79SbghlbhuQuWqiBcqA6VWl3XV72atl
 dnHGEW6T2MsLfejRPRniph8o6KSXVI8/IYClk74r+/Zj8rQPXW9lFFQ1+mtSZjkTnjmCc54B1s7
 XZWk6onTA2iErYsK6ZnaCw64p+P1g7AMj7ATPKlM3ceSMAxGs5cz2zHkpE9Q08xTMb4ABBJHDYc
 yKxCJED4LSODrSyg1sPxVKabw8WWuI2wks1JeenNh6kd2f9jRQY3DZlgq0SJ2Zt0sa+ZJVHBKIW
 5c3Pv3Tgsb7SkQLLbi0W50I1fSHJWoRAEYQuwlYNGMjYaCR80+lKbRN82BcsCUUvptj4OSCcQan
 OKrboyev4t4Ml5pmehk2T4KOBKXT9g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

In non-busypoll handle_rx paths, if peek_head_len returns 0, the RX
loop breaks, the RX wait queue is re-enabled, and vhost_net_signal_used
is called to flush done_idx and notify the guest if needed.

However, signaling the guest can take non-trivial time. During this
window, additional RX payloads may arrive on rx_ring without further
kicks. These new payloads will sit unprocessed until another kick
arrives, increasing latency. In high-rate UDP RX workloads, this was
observed to occur over 20k times per second.

To minimize this window and improve opportunities to process packets
promptly, immediately call peek_head_len after signaling. If new packets
are found, treat it as a busy poll interrupt and requeue handle_rx,
improving fairness to TX handlers and other pending CPU work. This also
helps suppress unnecessary thread wakeups, reducing waker CPU demand.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 drivers/vhost/net.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 35ded4330431..04cb5f1dc6e4 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1015,6 +1015,27 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
 	struct vhost_virtqueue *tvq = &tnvq->vq;
 	int len = peek_head_len(rnvq, sk);
 
+	if (!len && rnvq->done_idx) {
+		/* When idle, flush signal first, which can take some
+		 * time for ring management and guest notification.
+		 * Afterwards, check one last time for work, as the ring
+		 * may have received new work during the notification
+		 * window.
+		 */
+		vhost_net_signal_used(rnvq, *count);
+		*count = 0;
+		if (peek_head_len(rnvq, sk)) {
+			/* More work came in during the notification
+			 * window. To be fair to the TX handler and other
+			 * potentially pending work items, pretend like
+			 * this was a busy poll interruption so that
+			 * the RX handler will be rescheduled and try
+			 * again.
+			 */
+			*busyloop_intr = true;
+		}
+	}
+
 	if (!len && rvq->busyloop_timeout) {
 		/* Flush batched heads first */
 		vhost_net_signal_used(rnvq, *count);
-- 
2.43.0



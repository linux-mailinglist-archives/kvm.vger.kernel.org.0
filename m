Return-Path: <kvm+bounces-59654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE524BC67FE
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 21:47:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA9AA189B4BB
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 19:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E8025A2C9;
	Wed,  8 Oct 2025 19:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="rQPuYW1D";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="F6fJA8Ag"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E5F1F462D
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 19:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759952830; cv=fail; b=Lf4mN9wUJm1f/OCjMBP7d+w+MV2a+YLqt8H5iK8fdsnVVncIGHrx26Uap6kFg0cbX0hu7+3xhJ+MijAVup0Ui/dkctGsWaD8ePZmeQR13diR66jxfIzUKiJ0tjgpdhmWOY4w0g/HqptpanZMIFUBsmLFU0W175rmGl1hgElj/6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759952830; c=relaxed/simple;
	bh=6XJ8IY3nBPloJZF2JUOySkWwtyT3Jm+Zc3eD9QUZdPs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lR2ekLir4qXDrOEEx36pZk43YdjjmcLt33U7I6U2PiWHSZnuyjovlFRZ+GHxHrh+Qjsy1+WEZLS/0pEekl1r7Lj6YKV8vFIkS8TCKASgAWtPNQOlF5/Oibcau471B6xVEaxI34IkVA2xHsjgb+tjMX3bL0PuoCAVbYdEOq/77S8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=rQPuYW1D; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=F6fJA8Ag; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 598JLHk0416997;
	Wed, 8 Oct 2025 12:46:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=AjOBsPR09xvpk
	AhRXeY/pD/u5BN9qoFTLTGQLUbHnEs=; b=rQPuYW1DiY8e8OPgGW1CCkKDyUZoD
	cDpf4FZ7aZt76fxSNJNogg2fKkCd85vdHZhRQEx12ucQgKdI9eF1SLvgaPZNjC6q
	WQ/RhuY2xOKLayY2WeGi97xV5huUxT8lN9XEi5PPey49kfABF3I5Eo4P3hKZihBc
	cqaFHPdlo0BRL48rSqlZFn66nPdN8DSmB4oJQA3eZBa3F8LiIaN/hd+lVH8eVLPK
	ts3WQzVEsWmE5TByt9YCpbQTOMqqNo1UCKSutvwAlVM5K0ahuncl+JXcHvqrQZSV
	heQCTYCtt8E56XO/Oaw5LLE5ZOXBowojhcbP2bmeJsiDpRkRs/lg3Sg5Q==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020099.outbound.protection.outlook.com [52.101.201.99])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 49nx1tr1k1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 12:46:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T4CdV4cxd6h1ZNFpCWNfqccXFurQwjrxSScRbBq0SPTGHpArhzHaTQ31o9OBnG1PHUYE6JcU5wnRzsQkD4iDLZFhAvTphxr8z96cPXKmAqMZb1AABwWZ/fcWhX7krtOOC5OUsStOINSmdN9CAj1jCGuitoy1DI9hLURpAhGyJU5VsCUXp/0wtelhUa0JxS3N0zPPiWw35CJvPC7VnSrzvWCiPnLGB+fKMkn14h/cVC5qmu9oml3x/66u0caod3E1EYiL4kd/p1Aics3RFHMJM9G0wCrXU1vODnTJNZZJ8Zaj3Gj3o0JKxQX/mdQZ5BRnpmuPr2Gs3H/qD7mq/SLS8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AjOBsPR09xvpkAhRXeY/pD/u5BN9qoFTLTGQLUbHnEs=;
 b=CCq2v/h81TdFIcJZwl2519nLOFg+Wj43/Enjm/tmaBKSYMnHZsdg7HfN4tE5iKEWJRkAv9/u4UAX+HfTmOm7boK+rsdMetTEQRMN8apxl+WSfvVhBYpegZViF42wXNHpDYf0W5wRKmuhewpaBRj4BAvTCSPXraiI6temGuQwiR5f8hw1kpqjewF2e5boL7SbLKGa4+kM1JP1NlFM3H2oqlEMZcjfmOlbhoGQvIQKWQsbrY7h+kVjVtGXrMXJ0eWZdq+F2zCOjaq8yIv8aYVAA/vkJXHQm/nu+Pd/0pdNeQeMkC+ZYNT11xSBsulS5RDIUSFjClWU73it5weMpaeLXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjOBsPR09xvpkAhRXeY/pD/u5BN9qoFTLTGQLUbHnEs=;
 b=F6fJA8AgwMBjC7z5JzsM7dicO1mwo02m45bRJTAJJKDb6AH1TAoXzlWRNjD0EUmuV7PiT4CvrXNp23IY5Zc2FYCLCqAOWylAgYIr4Jraiz2rU4udwNvxEEyI9O9Nv2Dr35Yap8sRwkEo9jtqeoppgtqMiHEJRnPDoi3MOoqLIxz27KZ1yEAP9MxktmfO5K/xu4C8B3dbIV0Z6Ezb1aNRVDgZjSesCj/hO0llsCL7eTqIiSKFvjkE0LpYPz2bb5U5VsAStHeBLUKoyKAj1vhptwOt1+X/qJvtn7GZyeGVruhB3ofPKEiv1LjCK9XGPvB4z2EetJ1t9B9FVWi70lMiHA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by MN2PR02MB7005.namprd02.prod.outlook.com
 (2603:10b6:208:209::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Wed, 8 Oct
 2025 19:46:30 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 19:46:30 +0000
From: Jon Kohler <jon@nutanix.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: Jon Kohler <jon@nutanix.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH] i386/kvm: Expose ARCH_CAP_FB_CLEAR when invulnerable to MDS
Date: Wed,  8 Oct 2025 13:25:57 -0700
Message-ID: <20251008202557.4141285-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0039.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:33c::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|MN2PR02MB7005:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e50c16b-857f-4a23-26ac-08de06a3608e
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|1800799024|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Rjc5AP3T82B56KDrImDXEGC68bTXdOCYXmUaret2PuWMkWLIoEYR+7RPunIA?=
 =?us-ascii?Q?gUZcpLOIH5llOZpUI+m7s+LkD8gcm/atNSCrtrritB7oRwvD5UOQcV05xhXq?=
 =?us-ascii?Q?Y94fwi9CZOdvYzNN9YfCIX1dJI9y6oDFIj3RD4OjCO2do1ieeuMphDWZLhOR?=
 =?us-ascii?Q?eyUAno1Jb2QqTponFWoOzfY0yWgM04QvmWrWRg75Ugu0cq0T6GHYL2Py1yp3?=
 =?us-ascii?Q?8q7Xj4oPIXnP56P1IRnwTAl/mjxcZ6rCozWA9hXpSzOnWVICM4WsSSoDaO0D?=
 =?us-ascii?Q?Eb0elhdQQ2QdKMnCPTvquBL1TiYZiO697Ygvmdo8jNfl5BpaI/uQtp5pZ/Ev?=
 =?us-ascii?Q?kxLOcFrwg1LtungDiDo5QHyGxklKOgTPMTx96opzLCRX50mp22OHBMSyp1eb?=
 =?us-ascii?Q?qYygnzkEr/l75blOlYrwHug/JspQBJMyXInmrZi5dZBwgZuOCOLQszST3j2V?=
 =?us-ascii?Q?FRoCVLtifaZT4rDJxSJvXHtmfRXXWp2UCVJk7URr51l1MiGhee2noaK1+bsZ?=
 =?us-ascii?Q?Mul/y3k0PwixC8oLTaedTtdX7OEmQtO59ihCNUDgpfWSj87QxxkybmdnBVZF?=
 =?us-ascii?Q?5goRyHEP/V4PHk3VH/0fFD2Igwa46v/faFVMNe5jmeF+dACwa5sBXflspdAC?=
 =?us-ascii?Q?JwS8N9BkB3tkbj9vNeYuIU98QxqhuKA/Zva1jxxZuKZkAoStZBC4yzSz4/Me?=
 =?us-ascii?Q?9U6n9p+vMza+rh4v/BnXpjq2spz/+/yibUhg1OkZbEh1weegX8uJpbrpFsIE?=
 =?us-ascii?Q?pph3YiOGY/mVFpLOMBQ3lMhoEo26cS4R8rNfXFWO6b6ez14zPAVIP1gGJ1gI?=
 =?us-ascii?Q?jHum8zuaX+PL+afnj55KOThVHg1ndbW2lzrrRUxWhJkcgrbUwO04+jptq+jn?=
 =?us-ascii?Q?hRfZfXxSidOLdNUTsFKRpZdazl/J+/FpchFsl459r5kdscMKppffyv4J0xOM?=
 =?us-ascii?Q?69V+w7YcEz47NaXsQ7r6d/yYi2zlzt1bfDhCPSSzWE0MOOyBTYkwVcjpkpYA?=
 =?us-ascii?Q?5KIbK9HR4sQzSWecgWxiFcIAo9PhSyKdmRU7Zn9UxZ7l9ORfzZ0HtRx9LqmI?=
 =?us-ascii?Q?VhT/5DaH4FU27iO3uIi676O4sa30YcvPqZ9JJ5hncXcUcv4v7EoAogsRZtY+?=
 =?us-ascii?Q?RoIC5N8vgX2dp7yXRJsiMr+auwyKXQ6Wz3184Fex14K4TlX+ZebMwzKoUYeS?=
 =?us-ascii?Q?FoYygFBb8m16kiv10FCKXXd0un1Bh+UujStQbboWCsR1qF5QS+R8CtJYLAnD?=
 =?us-ascii?Q?ZLMHlkz4Frf8oFKPV/eB/Cl37ABEe9i5Lf0kQgehdzH5r+UYVG8ABCrDuFvC?=
 =?us-ascii?Q?16T+MFbu/1Vmqvo5hfMLwLRXu355zkfZbPMuB33ZMJqLVJcPNcD/YmpywJ+K?=
 =?us-ascii?Q?3FFvJxs58cgtwhRWYHMPbPJlVBAo49iRI+uNZBhuiTFUMf6QlQCriXRMtLTs?=
 =?us-ascii?Q?jpNbiT20vYKjSzcbjFrYV6jeOiZR0sTPvfZn0BGm/6i4N1gO1Ey+Ukl8ky73?=
 =?us-ascii?Q?PPGQIrQCETsPO7KOGY1MADU6V+3rV6hszvUd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(1800799024)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oqlsmxOcwNa/9H5oxSUVEQB3f246JUVjmhkylYWugzytp2eEmHV/gzZDgwBG?=
 =?us-ascii?Q?MTtFNxxmiowvVgg5R1BMHQWHAfCb3JJ4v3gJ7deNp3u/oaydU8HQvJODUUt7?=
 =?us-ascii?Q?6YoAb0nFKFqguGdZFcovLoZU4mg9ThML0TIk4Nf9reQX8vWhqltAQFHg3uU/?=
 =?us-ascii?Q?j8sLkGmtqvcqD7gt0WP0IiA204H66r5wbFXo78ak3RMcIbmIIche6gZHtXbN?=
 =?us-ascii?Q?rOzr1rOKJltM9Jshj63q7RAVOhrDz/ybII9Ca94uvDXbcAfzcWA5MvpUT82w?=
 =?us-ascii?Q?3MAuMSyQYCoM5GcZD/Vu6qlHue5DjikmDx/m1zmdpg/t3aeoCq1djEI43RIj?=
 =?us-ascii?Q?31EiYaN7ajd1Hxj20+NmMlgOIL88IEFj0T1eFwy2w0JXJ6IS46GeT4JCNfks?=
 =?us-ascii?Q?ipntUNC0sdGifC2fG5BdvCCb35t0BRuWo98NFFg8tur2jgF5xkya7wFMBSUB?=
 =?us-ascii?Q?tsOPiETxrO3KEkcAGksGH7ye6O0Tpnj2udGAPqGBgYqXZQkNMRgbz+SRSiRB?=
 =?us-ascii?Q?xRsZPZgpoteI00zH3NApgZPLZT0XgL5mSfONv1UlfuxsIdN0UyvAjp218BHz?=
 =?us-ascii?Q?eSKT3zdgRjC7/sGUT/K5cWsHVrvnOSZUSOgH0JGphGhmuNTRMm2mv2ehpd3q?=
 =?us-ascii?Q?pfZ7mx1uGo5iKWQBqKaLQW8WA5B8fcvWqazyH85fkYQRciCFidmOxStdGYDm?=
 =?us-ascii?Q?CjHlYE/tomtlxWFWS6YfhLsw12T9Ovz4Ad+mEecUMp97/7S9Vl3XmqGQni1q?=
 =?us-ascii?Q?Ec4vEttCw6Po5tgZfqmWp12K1x64Sm+2o0IlD4jqzU8NU41ZJLoDwlAINQtl?=
 =?us-ascii?Q?G9C1nljc6PtzeUSKlkrUvt0Y6zIlPfBZ7om9Qt9WHHszrxcM5Er3c85OjmIC?=
 =?us-ascii?Q?tGO0rqswiFE3PTwWTUrbUzWKYpG5c6b1+QXiSnaNbyE0mUax4cZnsdfVxfuD?=
 =?us-ascii?Q?ubZNdxJy3TTKmDsLs5px4XjA3Da2sh6IA9imlVEoGwAekXmmWc2ysyIH5h89?=
 =?us-ascii?Q?895yY+7xptrt1ohW63ktIsZpHI+xhwQSTQgPZKwHkAm1C7F5nHa95qty3P+Y?=
 =?us-ascii?Q?2dxTOiQSXo/FlWXbe6XwidkW6C6hLxmOhqBvRJ4V7qQRmIjzLXktsLL/UAyU?=
 =?us-ascii?Q?DBeflPvC6Nj/XwtuhV7qbmuB6Sw4h1XuRA2VlHp7eAU5PTVosjhK5Jx0j4+Z?=
 =?us-ascii?Q?UfPS0HAVTQSDmdgPz0EaCiG4qbNq0rOYkM57e2W7juBQMocKCNoYPTJGsJAM?=
 =?us-ascii?Q?BKM24WwhtFxazaIooC7pr4VLCVP6tT8E5pAgYbt3vjuEvO4e5h+wJ8bHmX/+?=
 =?us-ascii?Q?2ZSAKNj/gST6+bO2t0KQ/ZrCGZFv0lxFB/mpnraLOJGOIzRQzffbz8Gllv+5?=
 =?us-ascii?Q?NY9ngu4Kpx8SrdmpmX7iZLfjpqa0xEXafyu0xMF3F2hgAt6LisHVo7jE2yh8?=
 =?us-ascii?Q?PlsVyAER4WROveWf186E9A+DcqK56Mhc8sudrIUUSNcZ0nDyTWsNpHoSOoki?=
 =?us-ascii?Q?rfWHb74dmsVNNTK1oGU3VjsyB7coGG8GkJzlGy887IgbN0ND1MYOfF2/1cKq?=
 =?us-ascii?Q?qEQ+vWL4fTiJNVtzdHEdk369FBVkhtM/A6s491cuS07ckdX1Zi8JK1ISA2xl?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e50c16b-857f-4a23-26ac-08de06a3608e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 19:46:30.5221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPILzs2iCciiu0Iq8NmLXKShb7s4+IpnWLCQNyIE+HPoPghmqMv3F8uplDLmVKT/cb9tqbCIwcaO0XaCmGvKMcYn0Bbe1QpAeFGCvywh9BM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB7005
X-Proofpoint-ORIG-GUID: JwaKPUXDVp6G-6n8R-7wLHnVAo8t8eE7
X-Authority-Analysis: v=2.4 cv=OdOVzxTY c=1 sm=1 tr=0 ts=68e6bf9c cx=c_pps
 a=kJh41/vVy0mmRivLipeQDA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10 a=0kUYKlekyDsA:10 a=VwQbUJbxAAAA:8
 a=64Cc0HZtAAAA:8 a=QyXUC8HyAAAA:8 a=1XWaLZrsAAAA:8 a=QHeVMHjclCThQL4jRR0A:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: JwaKPUXDVp6G-6n8R-7wLHnVAo8t8eE7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEzOCBTYWx0ZWRfX9sdMIhJUH1aC
 jeXZ9lxPBh/jQN3VGH9AP0R4/ouSJMKT5WYHE2/+eNgr7C4Ny1WNkRQpoPR9wyNtFxt2ZtSAif0
 0zSSGWo628uEF9r3Pqz/4kOi1nUKKBexBF7qClcFtC3uoB6nXwaHKPMo3c25B/k5sIbszlUedV1
 0G6yTSwD3DWXlFOMWNY95dsx4FrjLP6MSOhHWHbB0zmQLJGa4Oec9tuHIx/RykkG9ZuSNCmqdK6
 vZHgF2pUYL0iub7xKMcp/3N9uVrz6cHaHgAeiA4zoq09HY8zX8NmUo1XfiiGAv4uoMWNwYy8UNk
 0zWrcrp29GFYzfJ/QTPoBAy9OOky8m30QdaFusazVYx/EGC8PfH2qIhU3mdKDwZckn4Pky4vXy/
 9fRu+pa8sMdR5MvWjfEP6zRJLuQfag==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Newer Intel hardware (Sapphire Rapids and higher) sets multiple MDS
immunity bits in MSR_IA32_ARCH_CAPABILITIES but lacks the hardware-level
MSR_ARCH_CAP_FB_CLEAR (bit 17):
    ARCH_CAP_MDS_NO
    ARCH_CAP_TAA_NO
    ARCH_CAP_PSDP_NO
    ARCH_CAP_FBSDP_NO
    ARCH_CAP_SBDR_SSDP_NO

This prevents VMs with fb-clear=on from migrating from older hardware
(Cascade Lake, Ice Lake) to newer hardware, limiting live migration
capabilities. Note fb-clear was first introduced in v8.1.0 [1].

Expose MSR_ARCH_CAP_FB_CLEAR for MDS-invulnerable systems to enable
seamless migration between hardware generations.

Note: There is no impact when a guest migrates to newer hardware as
the existing bit combinations already mark the host as MMIO-immune and
disable FB_CLEAR operations in the kernel (see Linux's
arch_cap_mmio_immune() and vmx_update_fb_clear_dis()). See kernel side
discussion for [2] for additional context.

[1] 22e1094ca82 ("target/i386: add support for FB_CLEAR feature")
[2] https://patchwork.kernel.org/project/kvm/patch/20250401044931.793203-1-jon@nutanix.com/

Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 target/i386/kvm/kvm.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6a3a1c1ed8..610d786310 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -657,6 +657,23 @@ uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index)
         must_be_one = (uint32_t)value;
         can_be_one = (uint32_t)(value >> 32);
         return can_be_one & ~must_be_one;
+    case MSR_IA32_ARCH_CAPABILITIES:
+        /*
+         * Special handling for fb-clear bit in ARCH_CAPABILITIES MSR.
+         * KVM will only report the bit if it is enabled in the host,
+         * but, for live migration capability purposes, we want to
+         * expose the bit to the guest even if it is disabled in the
+         * host, as long as the host itself is not vulnerable to
+         * the issue that the fb-clear bit is meant to mitigate.
+         */
+        if ((value & MSR_ARCH_CAP_MDS_NO) &&
+            (value & MSR_ARCH_CAP_TAA_NO) &&
+            (value & MSR_ARCH_CAP_SBDR_SSDP_NO) &&
+            (value & MSR_ARCH_CAP_FBSDP_NO) &&
+            (value & MSR_ARCH_CAP_PSDP_NO)) {
+                value |= MSR_ARCH_CAP_FB_CLEAR;
+        }
+        return value;
 
     default:
         return value;
-- 
2.43.0



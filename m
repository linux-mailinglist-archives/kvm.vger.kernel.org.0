Return-Path: <kvm+bounces-49445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA9B6AD91B2
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C9CD189D834
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC551F9ED2;
	Fri, 13 Jun 2025 15:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MX9UKCDs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ucoImA8j"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688E51F63CD;
	Fri, 13 Jun 2025 15:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749829349; cv=fail; b=PM07vBvaZprVigk3EpT8rXc5TmMlFp6n6BdiejWuEKavJgkBxusLP773GO2JKN0hzH4/XPgILvRk6gBWsO2GVJvOTx0VnjKmt7TzqWWdOxEiEw4ICyLOMuObe5mlDg4ZJu6z7cRxL/9CDFxxkT0Z4M0BcZoi6QyxOOSwnsFWoCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749829349; c=relaxed/simple;
	bh=uG3riLR9RlOXrSgB4kq2k/I1lUy/DzUTIAWHtYirMlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PL9v7o3SiTRqkQSkWQYV1C/DFss2N0OD+YzOW3XmLZDJ5fmZWOdDC2GlV60gfJvlQOn4QGLYMcLG8vU1LnQ4OKK5w4BlvBGLhlHpYzqUmOf18+IIZRmu+6GmoxujX11qi4DUNcQ5UUo5CO8LQ0ca1d9zJavtN5wmqwxmg0cz5Eg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MX9UKCDs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ucoImA8j; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55DCtdMd005753;
	Fri, 13 Jun 2025 15:37:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FqwiHmGEmn+jke7SVU
	2f9Pn2Q2VnlD4I53W/eYrO2oc=; b=MX9UKCDseFfg6gbfXelQNlCIHMcwepOQMt
	MQBeNoZH3WNF1UJDMly5PyMkBBUF15kiJvEoCOfe10EUnJOSH45jMxxMEs7WsOAe
	5hvATU17zXi8gYbSH2qF1e5dzCv/AIgFkvoFH7IGgso6u7XeXHYngqjQQMjd21cF
	Ul8XNbtSvYgw+aHZABqbbZ1U9bqUg+ma9LZo7RiPVnI31Cr694JA1aIPt9YVWt+P
	xM3t658Z/ZDzLY/NeW5KwtAJbepuLN4EoyWy25i+Xf/pDklBt0n+Y1NGf1vmnKEe
	qRBzPuNcXnppOLj9nvKLBZpEYauPuuYexkWb3v5FJQ8JPbT7WO5Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474cbektab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Jun 2025 15:37:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55DFEhwG016734;
	Fri, 13 Jun 2025 15:37:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvd2c89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Jun 2025 15:37:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cz0sJ2YJlMUE6IQYBuoEgafa5aXORFHE6uhJdioH4iVKkbXfIvJf55+w3XBOX26wQKf7DF+dZ8I87zoyhs3SmvzTbHrzfXh8JdZ13YTHoHT0YgEHGPNaTnFTaITOKPNNYe1E76VDtxILP3LfjgFo9Kbvv4Q7/4LAyW4IzXk7C6hr0tB2MNmJyMPAEQT5GF/MECvD0a4rEawEABEOwEXEuDjJCajtRxJoe7myyQxP54gCiIGfV4HaJQ88IvZh+zHxBt3R9lW53maF2yE8Q/7+qkwKLsE+VPZUCtr37pGZ7Kzt8Zdg3XrEiraaLkcJDi3C3RM3SrFKNhAv5zotkL78jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FqwiHmGEmn+jke7SVU2f9Pn2Q2VnlD4I53W/eYrO2oc=;
 b=IRkMqMRTpC0p01of2Z21Of2iDqezMTkDrryrDCdTBQfrxjiYbqUsGcBRKcveNWoEc9/2bEuejgIARll+2Otie7EmUW029b1BQV2asavMxVSZbcFFB6olzpZT9doG7ZHY8Ue0tCJsBsvQOzAa2jCSoKR+5smsuXVsqFGtKDW7qYb3c6/qLaSsK4JNcXmREiQQ6/t2HLD1u+Ou16AWLrCIYQsxr0RCEfosG4vbdvG6TQy4YTN8rPZ4b/CqZ9sFrvlNUz1wHbAdIW7CIZequfJVEufhZQKIJhD+I/WnT9HHk9tQlKVzNik7VisgYxwntwmQJWv80HAUpIyEVvdU+hVxgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqwiHmGEmn+jke7SVU2f9Pn2Q2VnlD4I53W/eYrO2oc=;
 b=ucoImA8jIbFslpMdaD9wogZfXjkWMruaPLfC/OX5Wl49/Ks42qgOGaWmIdM0e32+fwkyrAU8Pcuu18CNERhp/xK4G5XJBtSQjPCZmAeqaeSJvKh7Bp5sPzVn/yWehq7bvvr+55UAgoansNmQhYS/BgxRHRlgQGoMHlurF0FKuOU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7173.namprd10.prod.outlook.com (2603:10b6:8:dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 15:37:00 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8813.024; Fri, 13 Jun 2025
 15:37:00 +0000
Date: Fri, 13 Jun 2025 16:36:57 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
        David Hildenbrand <david@redhat.com>, Nico Pache <npache@redhat.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Message-ID: <08193194-3217-4c43-923e-c72cdbbd82e7@lucifer.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613134111.469884-4-peterx@redhat.com>
X-ClientProxiedBy: LO2P265CA0055.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7173:EE_
X-MS-Office365-Filtering-Correlation-Id: babd0894-d1c0-4e71-ae87-08ddaa902386
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QCx8eRKijUEMbd3u+UHdQegQURq6BG2Iz6QDDjMSCNaftJn5Bw22eS9a3J1/?=
 =?us-ascii?Q?DUCusGZiO+VNTCWfD9MfHqXRHsG2IZx6sp4BcBxYB+c3pfwZMQPoLLRpoltm?=
 =?us-ascii?Q?3NHY0Ov7I3uXdhn6ASZTdWKL/65S+psN9od4onuKN0z69tnlx2ub9NvSrb5p?=
 =?us-ascii?Q?Dq03IaRXi/mS1fQto28dZ9Xs3qF80p6CxEwceCEu4mNUClQP02qCUqrZcK4p?=
 =?us-ascii?Q?K+bsnnWrVMV6TqNmBUIZ8X7YXlop2RG7j9jYyHBY8Sn+m+EpTVktckKz1Yoa?=
 =?us-ascii?Q?5razKucxL+z9o94Gc5bPqxdvgxwvjWQmV1H6FG19kN8N9VupLFnqlVNN2AHa?=
 =?us-ascii?Q?7fXDG8PhojyM9dWLlu5W4SV+BPoZWqXqosCwp69kBgDGMlVnu/pZ6IQ+RrKx?=
 =?us-ascii?Q?bP2oWXTo4ZHsLn1WtK3z3pUbCAQgE1axHPbcUFDYmmGNc9NGoohTjfbR+j4R?=
 =?us-ascii?Q?HDZ/MxSsxIgylhINrAxrCDuOAKQLJjKZ/z+DHjxKOKiDXSW/b3scTr+GjLIK?=
 =?us-ascii?Q?uSKibbzupU7DPWrpYdCmg6U29Cn8S1s/7eDNu7xEDZeCfuHrSMu3OwCbgWbp?=
 =?us-ascii?Q?Iekorg7YEKIT5kMivsZGh4sqWVJTnQxmhzyKJGQ49sqe0q7NXHKO6UDNh1Ze?=
 =?us-ascii?Q?tvM+Gqs9DjM3UIOxOlX+gSHrN5xV4+QOjyTKBg5lMKtVTyvMVW1ZPe9erJ5v?=
 =?us-ascii?Q?Wr05H4P4vcxUL51Cbvw5o6I4hxXe0wmZyQIo6fdO2SJx1mlU6Z0ywljomLef?=
 =?us-ascii?Q?CIH1FNpKoan06b9w0XtWRyZ44ClYq0h/C0joYZRh41979jSNVc7AheJSxW5V?=
 =?us-ascii?Q?UK0mWlxF9EzfZMl40JHC57XuKSNO08Ei/9DPPd2Svib5aQQeGPGYTFDrZhAb?=
 =?us-ascii?Q?Yfru/37R7sG1mWwaSgy2ufW36x0lCZ6Wfwvv0A0AoBQX+IngaiHVT6/jZkiV?=
 =?us-ascii?Q?Diefr6aewReHbX5lD9HvZVgqXGC3+5beC1dFEtx5LESoiByWwekNL45XTUe8?=
 =?us-ascii?Q?KXnogwqi9H+zxMJsJ8IHq+tyvaLAZYhcQTZpteBVrKReNZ6OuXoIQUN8/STL?=
 =?us-ascii?Q?ttkaDpTtcTaTpVQIc/jaLjpG+H7cjUbIqTmXT61P6qIlWmj3/VlE07RrT6n3?=
 =?us-ascii?Q?4iKLHk/ttwN2/xDReAh0PoXDY5tX7VjqHTNztW2jVyTWADNJApQzmM8GBahU?=
 =?us-ascii?Q?6BNUbhOAa0SXQA5oqvdJ+ilHv39hqdefU1IFN4Sn+WM3CJ2qFgOwHbu7NN33?=
 =?us-ascii?Q?sHHdA3vUDqNRc4uUEXHbXQxcvDVs0Pcn7dXs4+1wKQPq5Piie6PJYg9XFv3b?=
 =?us-ascii?Q?m0gnxSQ/yPuu4iodmGAn+w0qKARYAxhziYRIW2rvgZrURPfiuPnLIxApOQZ4?=
 =?us-ascii?Q?4s8Bss3tW+6k+pae8YnKpFb3KFiNKQ5XtypSXNEZ2zQUqtRdmhRDS7ntLMRn?=
 =?us-ascii?Q?O+gMA3GSM1k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9KSIvA49WQgR+nA+vyMrtpORhbp/I6xjEqQbA172CNxlTNjY7Z0JdgQ1Fqbz?=
 =?us-ascii?Q?+dEkdFeOA0Q0q7gjlXjzEqYcSZooSXeLcHDskLG0d+tO7YwKLgoPv2HLnR2t?=
 =?us-ascii?Q?WBmPbM8xdfPUjk+bOwijc6q8EJjK1dwUGMpBogjUhtNLmsLG+k8+t//+g2S8?=
 =?us-ascii?Q?Vvyl2kOVNaELgAR+f8S9KY/EK/0JMC/mQkWJgB1fzXeHldU+tE1K8qST85WC?=
 =?us-ascii?Q?GMY9BxKwJ5ooF5TIsLZpsrLhxBlggQhmMfrFqOeZBa76vTW/piA9vrwxw29J?=
 =?us-ascii?Q?4/kGidGMf8zZe1ZtDWrehAoPLX0qmiz9xqg38UH462tAOyX0w3NIFfC/wZyn?=
 =?us-ascii?Q?Vyo1Ea4qrpquJLcieKBtTFc73wGyXzjqBSl2gP5PGDZGzcdPlT9zvs1AICy0?=
 =?us-ascii?Q?lFEbPBZWFP3chcBrS8zhBAtRQjF9E/gKOGU0Dbwq43JML305ayOBTgiDxfV4?=
 =?us-ascii?Q?69j/rlqm6QRkX3L/VenHRHGRsTe57S6XASZLquxwlpSVyYMvgbBfnRW1oUKi?=
 =?us-ascii?Q?UgEWwwj3qXNuA1S1TTwYFyuLUImUoUigm4HGE9uoglJw7mPAw//F/iSMmyWh?=
 =?us-ascii?Q?5y+KFAJ2H/Poit4QPFWerDdwrQHAwYTbaJUyMCzepxoD/aoluhvuHX3qWBCF?=
 =?us-ascii?Q?4NqN3C4dhqkPuzKtOCfkShaULZ4iSbAqokvCeAlUzCPjntWUTgOLM6sDw4z0?=
 =?us-ascii?Q?KFh8lz8aYJd6LPa9tzcNZPb+NByslhaodqCADXeSYumdm15haj+0XKK4Jaw+?=
 =?us-ascii?Q?yH3iaaLa3oaHlj9QcLH91+yBncWngIx+gtJFarqnn468JzNrcDGwpzZ/THkx?=
 =?us-ascii?Q?lC8X4clIwen1bNRy6ESm49S/cFUySbxBGSZAndGEKJA9EGFB3zhBlmcwU3Gk?=
 =?us-ascii?Q?cmrbJftoMVv+oyMn5vlJRNm3dBvtrrble1j4Qai+3mJ9yUs62NWqmHhJnBCd?=
 =?us-ascii?Q?l0s/sx0fcyMWIezFqehRL1dZE2Jy/l4xJJdw+9ZNTp2PXoU/eQOsLmWIWpdv?=
 =?us-ascii?Q?kSRjvBKs8/NxyP9GlJUPH5HYJer9L2TxGqNddyE4VK4xoG3YQ5UOK1+6B3qT?=
 =?us-ascii?Q?7VbXOiGc62bQXk7KF8gVHOOmJZ0C2w7RCxZaEOXhdugzsZmcTJBXdq45S98M?=
 =?us-ascii?Q?rKpX+ncu6ekLBone+rT+gnXbREm9cGfbBkPFVsHQRdH68ge1kkBD+zOQQbkA?=
 =?us-ascii?Q?fFdIfzy6ps1aTH25cqkNczh6yPfijbfND45u6OsUGHb6or4dgI0eX7f6at6K?=
 =?us-ascii?Q?yJYeyEF8qp0UH7MJHWaYrTGB8Xx4+iyLQ9PnilcEdwz89V3x02CtIcpnVbwi?=
 =?us-ascii?Q?/Pw96F+ZctDIhn1iZdbfMB+UylrGWJAWPS+2oPusDvLGR87U6iISnBeRoykH?=
 =?us-ascii?Q?PpfAmPfUwc6k71MKFjKwuJVjVc53br0ZqrE0gCmkzmE624yt3DZlg9OfLlUy?=
 =?us-ascii?Q?dVVCzS7rq0a6Rmh37HufrIG6qf9A1Ml4YWp+w3LIr5DtdNaBdJitEm1erRIK?=
 =?us-ascii?Q?XCevBwlVvdcOAQgElgE05Yh2APZy07r5NGESQZA8eG6XS8WoRUUgxtecame9?=
 =?us-ascii?Q?9k/xX9Xw2s8F7zwStnm+5fzuNHOrjxCpE9MCqIXnhicPMZFuLjsttdZveF7j?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fwu9sI/5O7xRfBg0wj8/npX2G2IAgm4FGnYM1hBb6882/c04vzN95aQO9AxUjg49Qi6lPa8ReS2pQRvunEUIC18+ItEeYylVgOHJzsf3r0wPra5/ZF3G89ZmLP5So3VC04Q04fMDKNKT+64k6L3D/kOn9jvEB4BQKsFfkiJ0HRrTi6p9Z9WyylpbEqcJw46+8te8cP/3TPYQ8SkT+X4bfcUinumW62Kk2oDe9nzxy9ih4ahVr0D04hnotqb+JaXVqfGY5I5L146HClR3PWHzXbItjkmQ6iLkO6cut2cKiFDam6dMF5Y63RbfHZ1qjyzCtNXf9XQZXskB5lrS4umVuqG+hhEiEC3PPvSgL8/yvkd86mVJ7gJDrP+4HOMy38JdgepeqmUUu8keQ30f+Xio7yzwHoEWkQGeiN5HD52et/beIuJSrnnoj8XzfeuI72PBli+Q2JzwHnb4xLeHFSFvdaJuaToRexBMPikTiaItiFMuXB9gh52nv5uQxSmKO+i3oK3q+KC5/SVh+sAM5aUok5xRk0GWRTWdoaKvWyX0GSR0O/4Uc0aunyWHGfBdONxI2vcwT/5HansBExUS22aLEfMYGsbGuCHoF4tI9VbjqJo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: babd0894-d1c0-4e71-ae87-08ddaa902386
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 15:37:00.5583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Hmg8zxQvGpsnYBWJylhi0ZiJdeBZQjUmjsFkVEIHfET13YSSE08v3VC0gAqjEXcWf6lgKrxuRpf9DiGlInRwLBNTkv2+0Ycqz7ihefUJdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-13_01,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506130113
X-Proofpoint-GUID: mdOX1n2ZbujGaPuX98nPsLk2jhjPboad
X-Authority-Analysis: v=2.4 cv=BffY0qt2 c=1 sm=1 tr=0 ts=684c45a0 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=SRrdq9N9AAAA:8 a=yPCof4ZbAAAA:8 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=OiwiCdSKIVXZL9V_rMEA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:14714
X-Proofpoint-ORIG-GUID: mdOX1n2ZbujGaPuX98nPsLk2jhjPboad
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEzMDExMyBTYWx0ZWRfX5afJY/WIf+qw kBTweygrdopqwYIqrqQiw7FYFvtgvSVbWy0Obx6OO/V2jnbRVlZsDNEPLMBp5MoWTh49JYTkXn+ nwWeJBvQy+/igh2dpJ2Xvr5ApRddg1KcxjKlOzUUZRmWIaD/Vn8vEOxJpCPlBrAAN3we6zGBwPq
 OvL0IY78Irhw0dx+WrIB0hHfkdqWPsr924MwRW3ry0oATfG7e9iYd7QbxRe/ZphcT67MeRcmfze 6hfLQocouIE4jHZVb5/gzIw64cYD8jWSsIQdEom+dAKJEd4SbRdDgN8+z2gVzZH0WEmRJcPbLla Dt7wAwEBR8h0Fmsu2T/HRDg8EgY6UqpK0UXyepxSV7wtgoIjJyuc2CIhAfWU2KcRDlqz6GOIeAK
 j0JHkkjLJm+BVnYj0293zxcE/cf6/ZqAzx0+J/5cT0GFsGD/4dQAW6PDfJ7pNpuwcQy9hORZ

On Fri, Jun 13, 2025 at 09:41:09AM -0400, Peter Xu wrote:
> This function is pretty handy for any type of VMA to provide a size-aligned
> VMA address when mmap().  Rename the function and export it.

This isn't a great commit message, 'to provide a size-aligned VMA address when
mmap()' is super unclear - do you mean 'to provide an unmapped address that is
also aligned to the specified size'?

I think you should also specify your motive, renaming and exporting something
because it seems handy isn't sufficient justifiation.

Also why would we need to export this? What modules might want to use this? I'm
generally not a huge fan of exporting things unless we strictly have to.

>
> About the rename:
>
>   - Dropping "THP" because it doesn't really have much to do with THP
>     internally.

Well the function seems specifically tailored to the THP use. I think you'll
need to further adjust this.

>
>   - The suffix "_aligned" imply it is a helper to generate aligned virtual
>     address based on what is specified (which can be not PMD_SIZE).

Ack this is sensible!

>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  include/linux/huge_mm.h | 14 +++++++++++++-
>  mm/huge_memory.c        |  6 ++++--
>  2 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 2f190c90192d..706488d92bb6 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h

Why are we keeping everything in huge_mm.h, huge_memory.c if this is being made
generic?

Surely this should be moved out into mm/mmap.c no?

> @@ -339,7 +339,10 @@ unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
>  unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
>  		unsigned long len, unsigned long pgoff, unsigned long flags,
>  		vm_flags_t vm_flags);
> -
> +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
> +		unsigned long addr, unsigned long len,
> +		loff_t off, unsigned long flags, unsigned long size,
> +		vm_flags_t vm_flags);

I echo Jason's comments about a kdoc and explanation of what this function does.

>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>  int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>  		unsigned int new_order);
> @@ -543,6 +546,15 @@ thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
>  	return 0;
>  }
>
> +static inline unsigned long
> +mm_get_unmapped_area_aligned(struct file *filp,
> +			     unsigned long addr, unsigned long len,
> +			     loff_t off, unsigned long flags, unsigned long size,
> +			     vm_flags_t vm_flags)
> +{
> +	return 0;
> +}
> +
>  static inline bool
>  can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
>  {
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 4734de1dc0ae..52f13a70562f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1088,7 +1088,7 @@ static inline bool is_transparent_hugepage(const struct folio *folio)
>  		folio_test_large_rmappable(folio);
>  }
>
> -static unsigned long __thp_get_unmapped_area(struct file *filp,
> +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
>  		unsigned long addr, unsigned long len,
>  		loff_t off, unsigned long flags, unsigned long size,
>  		vm_flags_t vm_flags)
> @@ -1132,6 +1132,7 @@ static unsigned long __thp_get_unmapped_area(struct file *filp,
>  	ret += off_sub;
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(mm_get_unmapped_area_aligned);

I'm not convinced about exporting this... shouldn't be export only if we
explicitly have a user?

I'd rather we didn't unless we needed to.

>
>  unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
>  		unsigned long len, unsigned long pgoff, unsigned long flags,
> @@ -1140,7 +1141,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>  	unsigned long ret;
>  	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
>
> -	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
> +	ret = mm_get_unmapped_area_aligned(filp, addr, len, off, flags,
> +					   PMD_SIZE, vm_flags);
>  	if (ret)
>  		return ret;
>
> --
> 2.49.0
>

So, you don't touch the original function but there's stuff there I think we
need to think about if this is generalised.

E.g.:

	if (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall())
		return 0;

This still valid?

	/*
	 * The failure might be due to length padding. The caller will retry
	 * without the padding.
	 */
	if (IS_ERR_VALUE(ret))
		return 0;

This is assuming things the (currently single) caller will do, that is no longer
an assumption you can make, especially if exported.

Actually you maybe want to abstract the whole of thp_get_unmapped_area_vmflags()
no? As this has a fallback mode?

	/*
	 * Do not try to align to THP boundary if allocation at the address
	 * hint succeeds.
	 */
	if (ret == addr)
		return addr;

What was that about this no longer being relevant to THP? :>)

Are all of these 'return 0' cases expected by any sensible caller? It seems like
it's a way for thp_get_unmapped_area_vmflags() to recognise when to fall back to
non-aligned?


Return-Path: <kvm+bounces-26218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B8D9730D8
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12088288E41
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C4519259F;
	Tue, 10 Sep 2024 10:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ndo0yJt2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="edu1U8S+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B191922EA
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962561; cv=fail; b=CKXD/4dxMBAUOWfJEsGFaXEw2hrY/+sMeZkZR4xtCOeXWrdSj6c5NqOIVhmy0LKSBs1oVPFqYqRF2Z8sgsww9I56bs3soVAaGHGR/zjEDiRUbE5zigSf6696d7HjUcxcpsVUbapgigDCEMpuLbsLprv/ffr0XVWuFz04vJWV/58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962561; c=relaxed/simple;
	bh=EzZ95p62oQvM24yrcHqIPrcWlldWTuoJQMuQZr9WfuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L3lkY90occ9o5CKcTj9TLelJM/W1SVUzde2kfqRVmHZYmyyF/9GVbpIERp+noB8B2ZPKWQPUdhTmZAYraXuX2Lb4jngFDk4mjV+dda5Xy2s1+Ca5O2LGS26k19OZ8XIbSZufR0LckzIqoDE3IezBP3Ki4Mx0GRFd2s/V1c3SN4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ndo0yJt2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=edu1U8S+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48A9QXx6026793;
	Tue, 10 Sep 2024 10:02:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=liLEVMlOxr9MKo9jga2VkXBGye4xwDKxHC6nl8W5hQ0=; b=
	ndo0yJt26OPaqlUENhTaTW5adrueFssrnSwzVOfmu6lyWI/DLeN5IfoLXZlNhgNu
	jYNrQs66M544h7kvGzGmtl96SaGqVQvlIAck44J++wfxu4aVY7UHAQ4rZsg+a7WQ
	awx6gu5jnlZNFXeObMaeax3cEpWUWD1pgKIEe9jrnUVJwT2toJBnh9OkS/Dzmd3x
	33uOBmAmCYxJDB0DzHlByR8LQLiBbhO3VQv1HMvvMBnjYQnPtHBEBIHaivrEcaPX
	RGxfkHeTrL/jH5swdFFuUbFpoEn1qtvLwKBrz0yz4gTf3GfI8nDgVBqM5nvzAv6G
	8NrKRqqkV2nx42E+49K8fg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gd8cw2su-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 10:02:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48A8RhKn004165;
	Tue, 10 Sep 2024 10:02:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd98bact-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 10:02:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UpO4YV/Q9rJTLJzFx6nmE8s2XEYGTqpyENN5wjn9iNjnXgSW31tB1xGrOEQ6rBPueqCm7ZdWH8K4OrTrILb8SBQyZ8mZ9pwdNag1Rc7xCwTbcG8pI5C+SYXNnHXI5IHzyjPnqyUtAQFlQdbeqhzwj2Rg32WMi2pd18f5SedGyuDY3g64r4Sir9UBLB57WKr84eZW5BxbZM+Y49pBz7YtBwpLvv3VpvpkbBhZC/w6VI0akUK6aLmWDiutPwI3vEhd+4rLt3kbXa3qtexsSTlZpVW1SaK7ryD8T+9f6NAWIbaDzTSW4d8qLBBYj+BGRgH4Mwlby+lWU1HZlpjuaqFrkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=liLEVMlOxr9MKo9jga2VkXBGye4xwDKxHC6nl8W5hQ0=;
 b=twASUZ3TgCWQgrdS+CvE6M85OM11OlH0JEzKmh9qNojKKrfGVlbl94riK5ReWTgyKgFVwkYgJjB0BTrt5Uv1LY2j9s6fYBDZmhltutnFqgJFjiOteuovocz/S+0r0e7t3uld2xkKmfJeqX9k1x/pkyiNNZ0vHAkchb1hFtOWo/LgWMpo7Qdv3OBI7gfiC3Nl9yQx+q0qRZyGhMZTpoFnEHoxaUZNdEXu0WkUibrnbkm8oW2bEJAztCCCl0XInR5+mytoktNLHFAh1L+0BtBHp+VoJUpvQoSe2a+wi3O2SNxA1vWhGtGypmGwTomrXHKJrL+yZyW2lPNwAmji//+PLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liLEVMlOxr9MKo9jga2VkXBGye4xwDKxHC6nl8W5hQ0=;
 b=edu1U8S+kGKXBBXu1QJTatnCopGUTeim6ehbyd/7eL2kJRlmdhEnSEilDnJLbMqwV1aGW3U49qpRyijLbxrtkTHnS6GfFwgkCraQRQL+oK7iGWOh4YjIfcwhc+3zPu7USEgraDd3Xq1iUFsF4ejZnEAQhPe/XnIAECXd8FF9EYA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.10; Tue, 10 Sep
 2024 10:02:28 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.7939.010; Tue, 10 Sep 2024
 10:02:28 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: pbonzini@redhat.com, peterx@redhat.com, david@redhat.com,
        philmd@linaro.org, marcandre.lureau@redhat.com, berrange@redhat.com,
        thuth@redhat.com, richard.henderson@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org, william.roche@oracle.com,
        joao.m.martins@oracle.com
Subject: [RFC RESEND 4/6] system: Introducing hugetlbfs largepage RAS feature
Date: Tue, 10 Sep 2024 10:02:14 +0000
Message-ID: <20240910100216.2744078-5-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240910100216.2744078-1-william.roche@oracle.com>
References: <20240910090747.2741475-1-william.roche@oracle.com>
 <20240910100216.2744078-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0016.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::29) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: a0d7f173-04fa-4eca-d0ac-08dcd17fad39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/elB657P2ZLYKNaQBzs7dv+IVk25jZlxujp0KIdsZXHNDJE6Wjxk46XO/wgd?=
 =?us-ascii?Q?4e+uSvScQXIRZAPthLFBY8+mb+IhEH1rtNF1/qT+qrOgF90e2oOVh/fwWDtL?=
 =?us-ascii?Q?Jt80SQGpTx6dTG/zmPiYwhvtCTL3oSNJfYG0uZdVZQQzklB/jQcdF3okru1M?=
 =?us-ascii?Q?WGMmbL2xA7np7F9osZDHNgvgGSUNlZAZgym+kvMzFa7cT0fx62ikWV/PMYFs?=
 =?us-ascii?Q?o4UOepGNAXEF8ZRtuFrp2GAiIpvkHUihjZQyLMlyGKK/46lXTPphw/hnt+jy?=
 =?us-ascii?Q?KbbuTuBC1q+goBvq8dkcuCPIBdOUrWiR/nn73KyuUdyURAEPWHV2w+5eqK7v?=
 =?us-ascii?Q?Ne3vZpB1M7c5WmKqX8Jvbl00/o0RfxjRhXuntTIV6jJsnwcTrTyY0tXXM0mx?=
 =?us-ascii?Q?6JQ3GBJjW3hZmuAd+aRGzs4233tK0LM1XeqAe1dMi4j4tj18O6UHJQU0z/Tr?=
 =?us-ascii?Q?/vX9PbPWL4K7w2H5t51ixM/5W82U5nYNVybxxKBvTXSOvXTvGMxk2GVrlSEd?=
 =?us-ascii?Q?XQFm1152lkHjWs06uC4zmbDO1qwcQxHiZZrAYkAn/NxWpVLQqq+0LV7w2SHx?=
 =?us-ascii?Q?LRubZfJpLoHM1JOaCXvxoTFp0XdS2azVvQuoMNys7qYZFcGMMUSxsjXfgQTd?=
 =?us-ascii?Q?K4UoZlRmqHZHcM+3wpfSs4jnzQgd4VQf9rHJY5bPoek83fYyMMLeD0E2beBN?=
 =?us-ascii?Q?xBnkZ4ILepex1FHo3LOw1SWVdZx6IehebIHFtqkEictagbG8gOaV2EPAl+1l?=
 =?us-ascii?Q?+zvZddP5F0XE5uV3wIxUnEIJM9IaSB46RCF0uDzrGqbD6EskOK+QzgeMpDAX?=
 =?us-ascii?Q?AotJHi0lvuHwpCTn71XPf4yxiks4M/MRORevBZzutw4ynD9tvkEDtFZStG4l?=
 =?us-ascii?Q?Omsk3V/8XOCB45Wg5biLpGu9dtzhLuHsr2dhXVMsH6VZUgqEH8FIOXNaRPea?=
 =?us-ascii?Q?lC1qGtU5OCVThnOojxzOAqPyLbv7bSMxbeQvN13zkmSkB/L3/Yy1Bzd+tf2u?=
 =?us-ascii?Q?nhPekbezRI5k7vFqzmHfFppen/g/GWhWyFgataIh+C3RC+nkjNbIxcztA6+h?=
 =?us-ascii?Q?G8pdNX/UccH/e7BWI6rFQtFob85JoUXdOSxAfl1nrHd5VhZhUW+gvU3o9QOC?=
 =?us-ascii?Q?j7aSyUlSXZslJ2J6DAzr1yZz6qLI5KGxsckRtAjLWhePHAk5aijzITN+zt/W?=
 =?us-ascii?Q?4sJ2Ek0sZE0usdqaRDG44mvAsqRGH1iKpz7+dhwiixRa9TcEgg4dGREGE99T?=
 =?us-ascii?Q?vXL/U9Biw0PRkV9hVlx1BBU7ErYtEYWXs1tXR8X/VUlWzF4vLNBo9FasMI+V?=
 =?us-ascii?Q?Sjk3/Z0I7/962ePYP9gbqP0vHYAMrvhIR+UWmaOyLcul/Q70s85YNJfSnwgQ?=
 =?us-ascii?Q?mGe9EoHFMEc1fUZbLrGyulj2nB6r?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jSNRRAZxOr1GtRaSVgarwXfTQb8O1R3lckrkmi/Wcspye0Yvvhl42gy1imvy?=
 =?us-ascii?Q?LrjYcba6rYpAhpq6K084q4zSywmVoNleiLUSKy8dMZrvgyx/qCD/aB5SMJpA?=
 =?us-ascii?Q?uR545Z61Xtr//a3DOf6IWdpCAtQNjqPciek8WHhsQ6ykbuZdb7i9Yf6Y3G8f?=
 =?us-ascii?Q?bDah+f7aqL//eRlB8ALVwmX9/uXkbxqi57glVPF+OPw7KMRZoIs3GyyVscPw?=
 =?us-ascii?Q?Mvk1vTo9aW04e+CkyLUZPblqswgLdOzzHVUWSClF/FkdMeGsgnmb95AwEXYj?=
 =?us-ascii?Q?RnfomETQyGO3n+PsZMf9gorLYcrk/b4w53SUWAY3vDzXi72QMnVM75nw3BpR?=
 =?us-ascii?Q?eAEzaubmSL6IORAz1Calq4DzMy8kwpfc0vlRqr0t7zcNgoB6o1yfDilrXFgl?=
 =?us-ascii?Q?q20ctj2eN4spi9SVa1f7j/OuVwRF/1c0TehNDZZR1jaRfYYk1HJJ50sFa8mC?=
 =?us-ascii?Q?7RNvp1fDF9V3wsPNfCFhQy9cm58M8LYmpt9O9P7qN+MC71VMtrWc5iWBnfPE?=
 =?us-ascii?Q?WPVVfr9iKQTBoAAA91et296mAp5aW0CCLEqAINNA7tttCCnmKmSZXTCmkFsM?=
 =?us-ascii?Q?Kqltq4Y9Ek3YLjBeLkO6K2GYqCw/IWBJpcH5svLrudsJHCCXolCeimsq91LQ?=
 =?us-ascii?Q?Wc6mFPvO+CENWymR3swiITchF9HzKq6tRfEhjCgL4HG7J3EfcBUlktLz47NG?=
 =?us-ascii?Q?qRSDBgDx0uzVuZXKLiC28Fyy7JKck60Ib9rEDhQqSEIoz+ztaIljMAYC+5k1?=
 =?us-ascii?Q?K2j/Dudqhw5Wccrwafa7No3HVeGsjepR/fG3B4R3Bv3pqOkLn/LW2yMnvBt2?=
 =?us-ascii?Q?tlCP6i2bncTWDAAZ/Ah1PS0Sbt6s4Yuf83g5QTqHbg6L/1+FdU8xjnA7ajgx?=
 =?us-ascii?Q?EBxpbmW8NJRmo+Hk5QCxgDCkvLnvZisjqGTHwQahxJurAmo9QYpiPCIhUnkl?=
 =?us-ascii?Q?PnTXx+mRhX9ZpbHztqJ2OpF6sA6QIqJVoIPgJWbtwGacDGWVixa4WztDzAEH?=
 =?us-ascii?Q?2MMnhJB4qEe6v9b5HWnb6BSHEkrLEElpaajEyPorJ3thwQkFPKRSyEXwqphT?=
 =?us-ascii?Q?aOSF7cXBmp90h+ayGCB+EE/3/7l2ANTAzl0mMwZaLj2LiH6n4xoEwoj2/L8S?=
 =?us-ascii?Q?CV8LYLtQFOLXhFPy6lLzSMG/nZgRq1bLGQFiW8SYOj/rFONS01CKSanlNGU8?=
 =?us-ascii?Q?PoyD+ptn5mOOQcRm28OggTPUhIFtckGGUPqOAY5JCBdRMp6lUcfFjg1Kxxs7?=
 =?us-ascii?Q?VRPUp1zCW9j5azKvlcWtCoeEeM902IlUuTxImexnUoMc5n5IxAqJVHjyqY5O?=
 =?us-ascii?Q?DTmR8q6L0Qfka+bXYsNv7D9rI9gjJv6PzAkwpMDsWrBJB2mECp01BNld+aa0?=
 =?us-ascii?Q?zRbYU0/Kof5GKDLzLFHvyK+VjksrHoe99f03NsD/CBVMKruUBm3oZDUoBodN?=
 =?us-ascii?Q?7DCIFROH2SDXoP07BOEOfa3FOkMjvAzxF+KaG5n/zlWYw0I2R/gVvsr5m26p?=
 =?us-ascii?Q?wSmi8XOAFKwYLwDQfDOimJqPzMlTrj4ogRZ/jnQa/EMoWxCf3Xy45/1AzLAF?=
 =?us-ascii?Q?eM/K8iW8tonpgr8sJ7+Ssrnrz0PnTYzNDRRXJEgavHvhaRFHrkYkZVQfmG0a?=
 =?us-ascii?Q?KQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CcIj5Updvgi+gsgArbjR/yrewvr4UcI/NQZXw/Nw6ryuPYz221szVc+2cZRIcHHNmUPILLi66Ph10x/EFBO5RfvmrUtWV+Nfb/KcuJJuH27s2TCmF/F4b3CglWTaSMKug0xfMxRF2rMhvZjOlRqjlsdYCxZjfiFBouF7srPO9EIIF416gs+/lD2Y+ZxHcxQ6QXxb62YxLVcnS3TlalcKB/T3Id6iYvVIQSySxEUcVhsj560YnZB8r9E8PJw5lSX7C21tnJCIYPC8xYE9Q9bmRn9IfrVg6k4nqAVBTaqXM1dFc5GOeip/NEcGAnhl/+Oq++AmgNAvX0aPMSOcdJDYlw7HSbUwaNYl3nO1uNV0rsFz3LUeZpQ5DBt0uC0eAbbGMrYBNr7cwE4czx/PnIJHIAObt3g2LxfZkNCQH2fA9rAJjA6y/xzyvRBznIN4dQE/+pQMiOLCq8vud33kSA0S9MeLehs3NsZ+pdkgzP0Ccc+P3pb+rmMbZie/lm3mELnl2ylTpq4bTZYMPAd3Q/Ms/Zgza+TGpUHKcvv3L+C6ZPCTSibNiz5OFpTH2Xgl/65/ZmcJ2X+yHfT+L6jDTbUE7aITeHqCjuFjIrjfvVB2uPY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d7f173-04fa-4eca-d0ac-08dcd17fad39
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 10:02:27.9947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lkxj8+aTEy17vf2pi9Z3nkw2rVCeIuL+GxvZch8K1iuFxS0W5w61Qbza3jq7o6i4BCEW9oNt5mGGMsostSf+AtyVtFgw2BOhog0o9B7uffM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_02,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409100075
X-Proofpoint-ORIG-GUID: pGlFbq6NfxZNuSAK7nIVGqCa3T834aqd
X-Proofpoint-GUID: pGlFbq6NfxZNuSAK7nIVGqCa3T834aqd

From: William Roche <william.roche@oracle.com>

We need to deal with hugetlbfs memory large pages facing HW errors,
to increase the probability to survive a memory poisoning.
When an error is detected, the platform kernel marks the entire
hugetlbfs large page as "poisoned" and reports the event to all
potential users using SIGBUS.

This change introduces 2 aspects:
. trying to recover not HWPOISON data from the error impacted large page
. splitting this large page into standard sized pages

When Qemu receives this SIGBUS, it will try to recover as much data
as possible from the hugepage backend file (which has to be a MAP_SHARED
mapping) with the help of the following kernel feature:
 linux commit 38c1ddbde6c6 ("hugetlbfs: improve read HWPOISON hugepage")

The impacted hugetlbfs large page is replaced by a set of standard pages
populated with the content of the recovered area or a poison for the
unrecoverable locations, reading the backend file.
Any error reading this file results in the corresponding standard
sized page to be poisoned. And if this file mapping is not set with
"share=on", the entire replacing set of pages is poisoned.

We pause the VM to perfom the memory replacement. To do so we have
to get out of the SIGBUS handler(s). But the signal will be
reraised on VM resume.

The platform kernel may report the beginning of the error impacted
large page in the SIGBUS siginfo data, so we may have to adjust this
poison address information to point to the finer grain actual
poison location based on the replacing standard sized pages.
Aiming at a more precise poison information reported to the VM
gives the possibility to better react to this situation, improving
the overall RAS of hugetlbfs VMs.

Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c    |   7 +
 meson.build            |   2 +
 system/hugetlbfs_ras.c | 546 +++++++++++++++++++++++++++++++++++++++++
 system/hugetlbfs_ras.h |   3 +
 system/meson.build     |   1 +
 system/physmem.c       |  17 ++
 target/arm/kvm.c       |  10 +
 target/i386/kvm/kvm.c  |  10 +
 8 files changed, 596 insertions(+)
 create mode 100644 system/hugetlbfs_ras.c
 create mode 100644 system/hugetlbfs_ras.h

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index bcccf80bd7..6c6841f935 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -57,6 +57,10 @@
 #include <sys/eventfd.h>
 #endif
 
+#ifdef CONFIG_HUGETLBFS_RAS
+#include "system/hugetlbfs_ras.h"
+#endif
+
 /* KVM uses PAGE_SIZE in its definition of KVM_COALESCED_MMIO_MAX. We
  * need to use the real host PAGE_SIZE, as that's what KVM will use.
  */
@@ -1211,6 +1215,9 @@ static void kvm_unpoison_all(void *param)
 {
     HWPoisonPage *page, *next_page;
 
+#ifdef CONFIG_HUGETLBFS_RAS
+    hugetlbfs_ras_empty();
+#endif
     QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
         QLIST_REMOVE(page, list);
         qemu_ram_remap(page->ram_addr, page->page_size);
diff --git a/meson.build b/meson.build
index fbda17c987..03214586c4 100644
--- a/meson.build
+++ b/meson.build
@@ -3029,6 +3029,8 @@ if host_os == 'windows'
   endif
 endif
 
+config_host_data.set('CONFIG_HUGETLBFS_RAS', host_os == 'linux')
+
 ########################
 # Target configuration #
 ########################
diff --git a/system/hugetlbfs_ras.c b/system/hugetlbfs_ras.c
new file mode 100644
index 0000000000..2f7e550f56
--- /dev/null
+++ b/system/hugetlbfs_ras.c
@@ -0,0 +1,546 @@
+/*
+ * Deal with memory hugetlbfs largepage errors in userland.
+ *
+ * Copyright (c) 2024 Oracle and/or its affiliates.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * (at your option) any later version.
+ */
+
+#include "qemu/osdep.h"
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <poll.h>
+#include <errno.h>
+#include <string.h>
+
+#include "exec/address-spaces.h"
+#include "exec/memory.h"
+#include "exec/ramblock.h"
+#include "qemu/thread.h"
+#include "qemu/queue.h"
+#include "qemu/error-report.h"
+#include "block/thread-pool.h"
+#include "sysemu/runstate.h"
+#include "sysemu/kvm.h"
+#include "qemu/main-loop.h"
+#include "block/aio-wait.h"
+
+#include "hugetlbfs_ras.h"
+
+/* #define DEBUG_HUGETLBFS_RAS */
+
+#ifdef DEBUG_HUGETLBFS_RAS
+#define DPRINTF(fmt, ...) \
+    do { fprintf(stderr, "lpg_ras[%s]: " fmt, __func__, ## __VA_ARGS__); \
+    } while (0)
+#else
+#define DPRINTF(fmt, ...) do {} while (0)
+#endif
+
+/*
+ * We track the Large Poisoned Pages to be able to:
+ * - Identify if a faulting page is already under replacement
+ * - Trigger a replacement for new pages
+ * - Inform the suspended signal handlers that they can continue
+ */
+typedef enum LPP_state {
+    LPP_SUBMITTED = 1,
+    LPP_PREPARING,
+    LPP_DONE,
+    LPP_FAILED,
+} LPP_state;
+
+typedef struct LargeHWPoisonPage {
+    void     *page_addr; /* hva of the poisoned large page */
+    size_t    page_size;
+    LPP_state page_state;
+    void     *first_poison; /* location of the first poison found */
+    struct timespec creation_time;
+    QLIST_ENTRY(LargeHWPoisonPage) list;
+} LargeHWPoisonPage;
+
+static QLIST_HEAD(, LargeHWPoisonPage) large_hwpoison_page_list =
+    QLIST_HEAD_INITIALIZER(large_hwpoison_page_list);
+static int large_hwpoison_vm_stop; /* indicate that VM is stopping */
+static QemuCond large_hwpoison_cv;
+static QemuCond large_hwpoison_new;
+static QemuCond large_hwpoison_vm_running;
+static QemuMutex large_hwpoison_mtx;
+static QemuThread thread;
+static void *hugetlbfs_ras_listener(void *arg);
+static int vm_running;
+static bool hugetlbfs_ras_initialized;
+static int _PAGE_SIZE = 4096;
+static int _PAGE_SHIFT = 12;
+
+/* size should be a power of 2 */
+static int
+shift(int sz)
+{
+    int e, s = 0;
+
+    for (e = 0; (s < sz) && (e < 31); e++) {
+        s = (1 << e);
+        if (s == sz) {
+            return e;
+        }
+    }
+    return -1;
+}
+
+static int
+hugetlbfs_ras_init(void)
+{
+    _PAGE_SIZE = qemu_real_host_page_size();
+    _PAGE_SHIFT = shift(_PAGE_SIZE);
+    if (_PAGE_SHIFT < 0) {
+        warn_report("No support for hugetlbfs largepage errors: "
+                    "Bad page size (%d)", _PAGE_SIZE);
+        return -EIO;
+    }
+    qemu_cond_init(&large_hwpoison_cv);
+    qemu_cond_init(&large_hwpoison_new);
+    qemu_cond_init(&large_hwpoison_vm_running);
+    qemu_mutex_init(&large_hwpoison_mtx);
+
+    qemu_thread_create(&thread, "hugetlbfs_error", hugetlbfs_ras_listener,
+                       NULL, QEMU_THREAD_DETACHED);
+
+    hugetlbfs_ras_initialized = true;
+    return 0;
+}
+
+bool
+hugetlbfs_ras_use(void)
+{
+    static bool answered;
+
+    if (answered) {
+        return hugetlbfs_ras_initialized;
+    }
+
+    /* XXX we could verify if ras feature should be used or not (on ARM) */
+
+    /* CAP_SYS_ADMIN capability needed for madvise(MADV_HWPOISON) */
+    if (getuid() != 0) {
+        warn_report("Priviledges needed to deal with hugetlbfs memory poison");
+    } else {
+        hugetlbfs_ras_init();
+    }
+
+    answered = true;
+    return hugetlbfs_ras_initialized;
+}
+
+/* return the backend real page size used for the given address */
+static size_t
+hugetlbfs_ras_backend_sz(void *addr)
+{
+    ram_addr_t offset;
+    RAMBlock *rb;
+
+    rb = qemu_ram_block_from_host(addr, false, &offset);
+    if (!rb) {
+        warn_report("No associated RAMBlock to addr: %p", addr);
+        return _PAGE_SIZE;
+    }
+    return rb->page_size;
+}
+
+/*
+ * Report if this std page address of the given faulted large page should be
+ * retried or if the current signal handler should continue to deal with it.
+ * Once the mapping is replaced, we retry the errors appeared before the
+ * 'page struct' creation, to deal with previous errors that haven't been
+ * taken into account yet.
+ * But the 4k pages of the mapping can also experience HW errors in their
+ * lifetime.
+ */
+static int
+hugetlbfs_ras_retry(void *addr, LargeHWPoisonPage *page,
+                    struct timespec *entry_time)
+{
+    if (addr == page->first_poison) {
+        return 0;
+    }
+    if (entry_time->tv_sec < page->creation_time.tv_sec) {
+        return 1;
+    }
+    if ((entry_time->tv_sec == page->creation_time.tv_sec) &&
+        (entry_time->tv_nsec <= page->creation_time.tv_nsec)) {
+        return 1;
+    }
+    return 0;
+}
+
+/*
+ * If the given address is a large page, we try to replace it
+ * with a set of standard sized pages where we copy what remains
+ * valid from the failed large page.
+ * We reset the two values pointed by paddr and psz to point
+ * to the first poisoned page in the new set, and the size
+ * of this poisoned page.
+ * Return True when it's done. The handler continues with the
+ * possibly corrected values.
+ * Returning False means that there is no signal handler further
+ * action to be taken, the handler should exit.
+ */
+bool
+hugetlbfs_ras_correct(void **paddr, size_t *psz, int code)
+{
+    void *p, *reported_addr;
+    size_t reported_sz, real_sz;
+    LargeHWPoisonPage *page;
+    int found = 0;
+    struct timespec et;
+
+    assert(psz != NULL && paddr != NULL);
+
+    DPRINTF("SIGBUS (%s) at %p (size: %lu)\n",
+        (code == BUS_MCEERR_AR ? "AR" : "AO"), *paddr, *psz);
+
+    if (!hugetlbfs_ras_initialized) {
+        return true;
+    }
+
+    /*
+     * XXX kernel provided size is not reliable...
+     * As kvm_send_hwpoison_signal() uses a hard-coded PAGE_SHIFT
+     * signal value on hwpoison signal.
+     * So in the case of a std page size, we must identify the actual
+     * size to consider (from the mapping block size, or if we
+     * already reduced the page to 4k chunks)
+     */
+    reported_sz = *psz;
+
+    p = *paddr;
+    reported_addr = p;
+
+    if (clock_gettime(CLOCK_MONOTONIC, &et) != 0) {
+        et.tv_sec = 0;
+        et.tv_nsec = 1;
+    }
+    qemu_mutex_lock(&large_hwpoison_mtx);
+
+    if (large_hwpoison_vm_stop) {
+        qemu_mutex_unlock(&large_hwpoison_mtx);
+        return false;
+    }
+
+    QLIST_FOREACH(page, &large_hwpoison_page_list, list) {
+        if (page->page_addr <= p &&
+            page->page_addr + page->page_size > p) {
+            found = 1;
+            break;
+        }
+    }
+
+    if (!found) {
+        if (reported_sz > _PAGE_SIZE) {
+            /* we trust the kernel in this case */
+            real_sz = reported_sz;
+        } else {
+            real_sz = hugetlbfs_ras_backend_sz(p);
+            if (real_sz <= _PAGE_SIZE) {
+                /* not part of a large page */
+                qemu_mutex_unlock(&large_hwpoison_mtx);
+                return true;
+            }
+        }
+        page = g_new0(LargeHWPoisonPage, 1);
+        p = (void *)ROUND_DOWN((unsigned long long)p, real_sz);
+        page->page_addr = p;
+        page->page_size = real_sz;
+        page->page_state = LPP_SUBMITTED;
+        QLIST_INSERT_HEAD(&large_hwpoison_page_list, page, list);
+        qemu_cond_signal(&large_hwpoison_new);
+    } else {
+        if ((code == BUS_MCEERR_AR) && (reported_sz <= _PAGE_SIZE) &&
+            hugetlbfs_ras_retry(p, page, &et)) {
+            *paddr = NULL;
+        }
+    }
+
+    while (page->page_state < LPP_DONE && !large_hwpoison_vm_stop) {
+        qemu_cond_wait(&large_hwpoison_cv, &large_hwpoison_mtx);
+    }
+
+    if (large_hwpoison_vm_stop) {
+        DPRINTF("Handler exit requested as on page %p\n", page->page_addr);
+        *paddr = NULL;
+    }
+    qemu_mutex_unlock(&large_hwpoison_mtx);
+
+    if (page->page_state == LPP_FAILED) {
+        warn_report("Failed recovery for page: %p (error at %p)",
+                    page->page_addr, reported_addr);
+        return (*paddr == NULL ? false : true);
+    }
+
+    *psz = (size_t)_PAGE_SIZE;
+
+    DPRINTF("SIGBUS (%s) corrected from %p to %p (size %ld to %ld)\n",
+            (code == BUS_MCEERR_AR ? "AR" : "AO"),
+            reported_addr, *paddr, reported_sz, *psz);
+
+    return (*paddr == NULL ? false : true);
+}
+
+/*
+ * Sequentially read the valid data from the failed large page (shared) backend
+ * file and copy that into our set of standard sized pages.
+ * Any error reading this file (not only EIO) means that we don't retrieve
+ * valid data for the read location, so it results in the corresponding
+ * standard page to be marked as poisoned.
+ * And if this file mapping is not set with "share=on", we can't rely on the
+ * content on the backend file, so the entire replacing set of pages
+ * is poisoned in this case.
+ */
+static int take_valid_data_lpg(LargeHWPoisonPage *page, const char **err)
+{
+    int fd, i, ps = _PAGE_SIZE, slot_num, poison_count = 0;
+    ram_addr_t offset;
+    RAMBlock *rb;
+    uint64_t fd_offset;
+    ssize_t count, retrieved;
+
+    /* find the backend to get the associated fd and offset */
+    rb = qemu_ram_block_from_host(page->page_addr, false, &offset);
+    if (!rb) {
+        if (err) {
+            *err = "No associated RAMBlock";
+        }
+        return -1;
+    }
+    fd = qemu_ram_get_fd(rb);
+    fd_offset = rb->fd_offset;
+    offset += fd_offset;
+    assert(page->page_size == qemu_ram_pagesize(rb));
+    slot_num = page->page_size / ps;
+
+    if (!qemu_ram_is_shared(rb)) { /* we can't use the backend file */
+        if (madvise(page->page_addr, page->page_size, MADV_HWPOISON) == 0) {
+            page->first_poison = page->page_addr;
+            warn_report("Large memory error, unrecoverable section "
+                "(unshared hugetlbfs): start:%p length: %ld",
+                page->page_addr, page->page_size);
+            return 0;
+        } else {
+            if (err) {
+                *err = "large poison injection failed";
+            }
+            return -1;
+        }
+    }
+
+    for (i = 0; i < slot_num; i++) {
+        retrieved = 0;
+        while (retrieved < ps) {
+            count = pread(fd, page->page_addr + i * ps + retrieved,
+                ps - retrieved, offset + i * ps + retrieved);
+            if (count == 0) {
+                DPRINTF("read reach end of the file\n");
+                break;
+            } else if (count < 0) {
+                DPRINTF("read backend failed: %s\n", strerror(errno));
+                break;
+            }
+            retrieved += count;
+        }
+        if (retrieved < ps) { /* consider this page as poisoned */
+            if (madvise(page->page_addr + i * ps, ps, MADV_HWPOISON)) {
+                if (err) {
+                    *err = "poison injection failed";
+                }
+                return -1;
+            }
+            if (page->first_poison == NULL) {
+                page->first_poison = page->page_addr + i * ps;
+            }
+            poison_count++;
+            DPRINTF("Found a poison at index %d = addr %p\n",
+                i, page->page_addr + i * ps);
+        }
+    }
+
+    /*
+     * A large page without at least a 4k poison will not have an
+     * entry into hwpoison_page_list, so won't be correctly replaced
+     * with a new large page on VM reset with qemu_ram_remap().
+     * Any new error on this area will fail to be handled.
+     */
+    if (poison_count == 0) {
+        if (err) {
+            *err = "No Poison found";
+        }
+        return -1;
+    }
+
+    DPRINTF("Num poison for page %p : %d / %d\n",
+            page->page_addr, poison_count, i);
+    return 0;
+}
+
+/*
+ * Empty the large_hwpoison_page_list -- to be called on address space
+ * poison cleanup outside of concurrent memory access.
+ */
+void hugetlbfs_ras_empty(void)
+{
+    LargeHWPoisonPage *page, *next_page;
+
+    if (!hugetlbfs_ras_initialized) {
+        return;
+    }
+    qemu_mutex_lock(&large_hwpoison_mtx);
+    QLIST_FOREACH_SAFE(page, &large_hwpoison_page_list, list, next_page) {
+        QLIST_REMOVE(page, list);
+        g_free(page);
+    }
+    qemu_mutex_unlock(&large_hwpoison_mtx);
+}
+
+/*
+ * Deal with the given page, initializing its data.
+ */
+static void
+hugetlbfs_ras_transform_page(LargeHWPoisonPage *page, const char **err_info)
+{
+    const char *err_msg;
+    int fd;
+    ram_addr_t offset;
+    RAMBlock *rb;
+
+    /* find the backend to get the associated fd and offset */
+    rb = qemu_ram_block_from_host(page->page_addr, false, &offset);
+    if (!rb) {
+        DPRINTF("No associated RAMBlock to %p\n", page->page_addr);
+        err_msg = "qemu_ram_block_from_host error";
+        goto err;
+    }
+    fd = qemu_ram_get_fd(rb);
+
+    if (sync_file_range(fd, offset, page->page_size,
+                        SYNC_FILE_RANGE_WAIT_AFTER) != 0) {
+        err_msg = "sync_file_range error on the backend";
+        perror("sync_file_range");
+        goto err;
+    }
+    if (fsync(fd) != 0) {
+        err_msg = "fsync error on the backend";
+        perror("fsync");
+        goto err;
+    }
+    if (msync(page->page_addr, page->page_size, MS_SYNC) != 0) {
+        err_msg = "msync error on the backend";
+        perror("msync");
+        goto err;
+    }
+    page->page_state = LPP_PREPARING;
+
+    if (munmap(page->page_addr, page->page_size) != 0) {
+        err_msg = "Failed to unmap";
+        perror("munmap");
+        goto err;
+    }
+
+    /* replace the large page with standard pages */
+    if (mmap(page->page_addr, page->page_size, PROT_READ | PROT_WRITE,
+            MAP_FIXED | MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0)
+            == MAP_FAILED) {
+        err_msg = "Failed to map std page";
+        perror("mmap");
+        goto err;
+    }
+
+    /* take a copy of still valid data and mark the failed pages as poisoned */
+    if (take_valid_data_lpg(page, &err_msg) != 0) {
+        goto err;
+    }
+
+    if (clock_gettime(CLOCK_MONOTONIC, &page->creation_time) != 0) {
+        err_msg = "Failed to set creation time";
+        perror("clock_gettime");
+        goto err;
+    }
+
+    page->page_state = LPP_DONE;
+    return;
+
+err:
+    if (err_info) {
+        *err_info = err_msg;
+    }
+    page->page_state = LPP_FAILED;
+}
+
+/* attempt to vm_stop the entire VM in the IOthread */
+static void coroutine_hugetlbfs_ras_vmstop_bh(void *opaque)
+{
+    vm_stop(RUN_STATE_PAUSED);
+    DPRINTF("VM STOPPED\n");
+    qemu_mutex_lock(&large_hwpoison_mtx);
+    vm_running = 0;
+    qemu_cond_signal(&large_hwpoison_vm_running);
+    qemu_mutex_unlock(&large_hwpoison_mtx);
+}
+
+static void coroutine_hugetlbfs_ras_vmstart_bh(void *opaque)
+{
+    vm_start();
+}
+
+static void *
+hugetlbfs_ras_listener(void *arg)
+{
+    LargeHWPoisonPage *page;
+    int new;
+    const char *err;
+
+    /* monitor any newly submitted element in the list */
+    qemu_mutex_lock(&large_hwpoison_mtx);
+    while (1) {
+        new = 0;
+        QLIST_FOREACH(page, &large_hwpoison_page_list, list) {
+            if (page->page_state == LPP_SUBMITTED) {
+                new++;
+                vm_running = 1;
+                DPRINTF("Stopping the VM\n");
+                aio_bh_schedule_oneshot(qemu_get_aio_context(),
+                                coroutine_hugetlbfs_ras_vmstop_bh, NULL);
+                /* inform all SIGBUS threads that they have to return */
+                large_hwpoison_vm_stop++;
+                qemu_cond_broadcast(&large_hwpoison_cv);
+
+                /* wait until VM is stopped */
+                while (vm_running) {
+                    DPRINTF("waiting for vm to stop\n");
+                    qemu_cond_wait(&large_hwpoison_vm_running,
+                                   &large_hwpoison_mtx);
+                }
+
+                hugetlbfs_ras_transform_page(page, &err);
+                if (page->page_state == LPP_FAILED) {
+                    error_report("fatal: unrecoverable hugepage memory error"
+                                 " at %p (%s)", page->page_addr, err);
+                    exit(1);
+                }
+
+                large_hwpoison_vm_stop--;
+
+                DPRINTF("Restarting the VM\n");
+                aio_bh_schedule_oneshot(qemu_get_aio_context(),
+                                coroutine_hugetlbfs_ras_vmstart_bh, NULL);
+            }
+        }
+        if (new) {
+            qemu_cond_broadcast(&large_hwpoison_cv);
+        }
+
+        qemu_cond_wait(&large_hwpoison_new, &large_hwpoison_mtx);
+    }
+    qemu_mutex_unlock(&large_hwpoison_mtx);
+    return NULL;
+}
diff --git a/system/hugetlbfs_ras.h b/system/hugetlbfs_ras.h
new file mode 100644
index 0000000000..324228bda3
--- /dev/null
+++ b/system/hugetlbfs_ras.h
@@ -0,0 +1,3 @@
+bool hugetlbfs_ras_use(void);
+bool hugetlbfs_ras_correct(void **paddr, size_t *psz, int code);
+void hugetlbfs_ras_empty(void);
diff --git a/system/meson.build b/system/meson.build
index a296270cb0..eda92f55a9 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -37,4 +37,5 @@ system_ss.add(when: 'CONFIG_DEVICE_TREE',
               if_false: files('device_tree-stub.c'))
 if host_os == 'linux'
   system_ss.add(files('async-teardown.c'))
+  system_ss.add(files('hugetlbfs_ras.c'))
 endif
diff --git a/system/physmem.c b/system/physmem.c
index 5c176146c0..78de507bd0 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -82,6 +82,10 @@
 #include <daxctl/libdaxctl.h>
 #endif
 
+#ifdef CONFIG_HUGETLBFS_RAS
+#include "system/hugetlbfs_ras.h"
+#endif
+
 //#define DEBUG_SUBPAGE
 
 /* ram_list is read under rcu_read_lock()/rcu_read_unlock().  Writes
@@ -2061,6 +2065,19 @@ RAMBlock *qemu_ram_alloc_from_file(ram_addr_t size, MemoryRegion *mr,
         return NULL;
     }
 
+#ifdef CONFIG_HUGETLBFS_RAS
+    {
+        QemuFsType ftyp = qemu_fd_getfs(fd);
+
+        if (ftyp == QEMU_FS_TYPE_HUGETLBFS) {
+            if (hugetlbfs_ras_use() && !(ram_flags & RAM_SHARED)) {
+                warn_report("'share=on' option must be set to support "
+                            "hugetlbfs memory error handling");
+            }
+        }
+    }
+#endif
+
     block = qemu_ram_alloc_from_fd(size, mr, ram_flags, fd, offset, errp);
     if (!block) {
         if (created) {
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index f62e53e423..6215d1acb5 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -40,6 +40,10 @@
 #include "hw/acpi/ghes.h"
 #include "target/arm/gtimer.h"
 
+#ifdef CONFIG_HUGETLBFS_RAS
+#include "system/hugetlbfs_ras.h"
+#endif
+
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_LAST_INFO
 };
@@ -2356,6 +2360,12 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr, short addr_lsb)
 
     assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
 
+#ifdef CONFIG_HUGETLBFS_RAS
+    if (!hugetlbfs_ras_correct(&addr, &sz, code)) {
+        return;
+    }
+#endif
+
     if (acpi_ghes_present() && addr) {
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 99b87140cc..c99095cb1f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -69,6 +69,10 @@
 #include "exec/memattrs.h"
 #include "trace.h"
 
+#ifdef CONFIG_HUGETLBFS_RAS
+#include "system/hugetlbfs_ras.h"
+#endif
+
 #include CONFIG_DEVICES
 
 //#define DEBUG_KVM
@@ -729,6 +733,12 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr, short addr_lsb)
      */
     assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
 
+#ifdef CONFIG_HUGETLBFS_RAS
+    if (!hugetlbfs_ras_correct(&addr, &sz, code)) {
+        return;
+    }
+#endif
+
     if ((env->mcg_cap & MCG_SER_P) && addr) {
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
-- 
2.43.5



Return-Path: <kvm+bounces-26221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E90659730DE
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FC992874FD
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5737A18CC16;
	Tue, 10 Sep 2024 10:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RlYYAb8U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hULaZaKT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D764018C32B
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962572; cv=fail; b=FVaAJzqxBVk5inIlMKNLsZQFuE4Z3w+SLHCARRDpft+1PaGL5065/08pZAGb8fmym3T+50F/tBL8/xv4eTJK7AljboXGHzb4XYwyeZA4nPbwlJC4lZ65HHZmXdXpv+qpYFXg0wDEzVVwODaYXcEnmangw23oRO60wO59e4e7F/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962572; c=relaxed/simple;
	bh=Scdh7OiEj4mxTZznQMCy9eALQT+A6VPKk7YaemlYF3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eoU0LIcdozaJzHOWGxcQpepJafKqI6izlQXDsh5ESh87HER+kMro3rdBP7kVsb2zV9UcOQ07aSXRa8zS3vYp+FuvXGaXj3KEKQxVvBQDs7BxfLCObh4vIDNHUEsjL2l3s8FVpKNuVkMMpHzpoVpmGrakHtCzttvxlEn+kqLUTas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RlYYAb8U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hULaZaKT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48A9QVcH022346;
	Tue, 10 Sep 2024 10:02:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=6zRKVP0wxYzEad+yxt0t268SLIx2OcpPGkov/2Pn12M=; b=
	RlYYAb8UTzBVLAXWf57TivquzOqiFxRn9Ntq+xg28dbfqmCJ081JlM0r6qMwjwO9
	+K5tPT+36Up+qOAeR6ZilRxV9MoxSGu4ulguMo7laFJWAI3Ijte/nwSa5oVnyZBA
	QYSrkiBxn2lq9HK8Pi9ubH+/083JGW2I4UAZWMMzvA7J+zGFFliSPXo+QaibydTD
	vZ9tPNJrSyg9hwWIvUVFDXI9pyPnKiz+gyrsZA47guOLxOQMHOrOwXA6OSVKGF3a
	DXkchcHgth8sMhZd6bd0O6KaO52WH8EvHChiMiMIH3PeDbJ2I0ErN+u/B4FT79vo
	TFr2ViXH+/s2EZN+5B9mKg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gfctd3yx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 10:02:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48AA0tjB019798;
	Tue, 10 Sep 2024 10:02:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9eugka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 10:02:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FtxAO6WQbt4Vq3kGGRMt7+b5z58r4cMIeyKf3y6ks1z68J2HHETEUTq45l1DBt1WMy/uEaqhwBJTRfXWOv06a5W0q2Ys2hs99bI7XLW7XuaWLXI8lKbcGeoVw2DJ8M0TDSnqvFdBf0/NakzeFMwZlxCtvzMUpMttO1p5sToSq+I7zrPXcJKAxy4pLy2uCexlB6jXrVAR9Vn7SF/BZ4+ajUYa9+bHoDneaksJeKm+T3v3WUr9al4NbD4/+6j3kzChg+d2gyhFU1f1BEQKj1SRsGngwUk5gUK/ALvGqCf7bsfxNG0MrJslz9n4ifZfFdrk1f90ai26yptvV20rA2NDMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zRKVP0wxYzEad+yxt0t268SLIx2OcpPGkov/2Pn12M=;
 b=BZHWQXtMYeziAeWtszGtHREKR2M2aXwy75FTkGl9AOrZH7OjnNO0mgL5vbTWQWUKJaDmO8ykXWo8Z04RJD/pZGqn2F30fBx4ITLYrwg64Z6X7BWo4p5xymsmbvDq+vsm19v3DkxcSpSg6ANLiB9oft2I1cQ9E5dwaA0LVl+aathQg7zImpvLs0d2nb+9BHA02P2lyGJSvIRIqRm2an8UUOEAP/9XD3CGh9rjppZpHQIScUjlY2kiOMuEhTCatG6S7tCrCtHtJQ0MKUqomaoZXKviCft8izwx346qQtQFO2hqZsIkRBjmvJnn7tXbYNe9Gi1QJyBoYFNOkLxM6/vnPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zRKVP0wxYzEad+yxt0t268SLIx2OcpPGkov/2Pn12M=;
 b=hULaZaKTHXdhSWHzg120OgDUjvbWoXWDDfXdOfEOcNy1hXtvgdVfrYLgGRwNlAaILrem1MAxV7+isY2iaRs7XOWxK0HbTphaYK2ruRZJ8ZUme35LCp4RJvEqHgQPWizixatUtHzgmx8d4RMniI8R5hQIWy6HAODIYBV151FNL3Y=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.10; Tue, 10 Sep
 2024 10:02:32 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.7939.010; Tue, 10 Sep 2024
 10:02:32 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: pbonzini@redhat.com, peterx@redhat.com, david@redhat.com,
        philmd@linaro.org, marcandre.lureau@redhat.com, berrange@redhat.com,
        thuth@redhat.com, richard.henderson@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org, william.roche@oracle.com,
        joao.m.martins@oracle.com
Subject: [RFC RESEND 6/6] system/hugetlb_ras: Replay lost BUS_MCEERR_AO signals on VM resume
Date: Tue, 10 Sep 2024 10:02:16 +0000
Message-ID: <20240910100216.2744078-7-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240910100216.2744078-1-william.roche@oracle.com>
References: <20240910090747.2741475-1-william.roche@oracle.com>
 <20240910100216.2744078-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: 03215d93-5641-49b8-edbe-08dcd17fb019
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EsSO2UGLVZdpUvM0EhBCbsiYew0Fe/viWSjhQxTaupscQyDTmA6fuUm5h2wX?=
 =?us-ascii?Q?3Iws5bC6bt64YFZRzr48lOYY8z2rlpQ+4okLdZCf6JQiOG1PM5iYnM159gR5?=
 =?us-ascii?Q?P97pDvERvwU4qbH51fo2EjO0dmO2tO/jF6prj4Ofn3nHlLBkAuIRX0mf7vwF?=
 =?us-ascii?Q?ZDuYfk68QIKDez7A/CasO8qWW2i6iqCWv4Nw9ea09thyUpFWTYwNskT6llvO?=
 =?us-ascii?Q?6JD0eQR2v3IVkXfpAPWSul5/lvhaZ5fU9HtU8+BwFpVaG3GDjtI1CmVPVhZQ?=
 =?us-ascii?Q?OQi/A1ZLHYy7Ohx7gqrkpurkojwbZn7rofyx+I0nNSOkFSvjTDO6u1zeW4NR?=
 =?us-ascii?Q?IySs/FYoiM4rtK3SYl07EpNG97H81E6xeJyYkTFVsxHpYD3R0X757yNh1x9a?=
 =?us-ascii?Q?YCsg9N0XmY4+0Xsp3yHxNSY+2BPpisw484htcL9p0eIQ8YE6FQBSk6qSs6am?=
 =?us-ascii?Q?80DfSbPybTyjzsJnCB7725LXcrK2txwTY0DmMECRrP/9tOJhylwoK4WWuPjt?=
 =?us-ascii?Q?TkxHILqPqj84qcVleObJsVcQpVTBXS2vSOeeQrnnNLHeiR/FLYQXKFz/hO+7?=
 =?us-ascii?Q?JS5HvJb9AunBjU4xVP+mgPhu/YbeKoXjKtjH4yuDjWSNFcGLb6YFDVPWYD+N?=
 =?us-ascii?Q?BoMFpa3mD3wcnjefxo6dX2RbN2BqhgDrlRdQRhJWEYI4pUU0cXfphlZKbT9F?=
 =?us-ascii?Q?rL+VSAS/e42lcyTPA5zZAD0mkMhn3JD0nvZrPHbjV04CqXBfLT9tR2BhFLZj?=
 =?us-ascii?Q?ekap5orU8M2u/a8e0EWFuhMUH78oCGKAmIA81BD3Qwpo7nv9/Xleh0nBEdby?=
 =?us-ascii?Q?zxj9JJ41uFpWcanX4eyrHlk1d6VdizU4lT7F7TfYqYk8ewspVLcm3TbryxDw?=
 =?us-ascii?Q?bpVL8y+Vs6Zkxtj/6KYD7VQ9rF5FZvKw5AAT7hZxtD0fSLc9PcN9dWq/tJiF?=
 =?us-ascii?Q?MSi97AzRUqwvFyjY96bnEsbviQ3/NU/yAoLPFLODFJAOg52zFRdekWO8vg6i?=
 =?us-ascii?Q?Wf1Gj/dh7ZU1h0DcbdIh9LCE1JxGRHfC/uIINR9TcKwb9rDYF/CRUD+Iw+Lk?=
 =?us-ascii?Q?PsARHnxMxAY7/dG1dNy1ZIdazt6SrsZEqV5gm2aHQBWhDbiiFDtaBalSnE1k?=
 =?us-ascii?Q?z5ZlFqZB+guAcWusnv+/WBAk2zeTZdwdDTVkGCmVS9gEObtHJ+a3G7CXFGtm?=
 =?us-ascii?Q?UtJhmucA7tYexh3NGkORQXqKY4ShXIq4S2AvbJQsDXrzovXfwqhJ6xoHd4gH?=
 =?us-ascii?Q?8AOt5My1r5nN45+bTa5x05TQoncrtkPFsURDagig3Gb0WNWnj3pptmSVmck4?=
 =?us-ascii?Q?dOl/s5Jg3k2gN1anMMbil21fTHucICTEyVTb8b3gD9iLdyutfWLAxWvGeVWS?=
 =?us-ascii?Q?gsEr/QL2csqzUjYVlifqVZVNZ2oH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uDvYovXieU1cDOFAZeolMNhp+W0IxmtcoujbL117EpApkc0T/2zaEZ9Vbryg?=
 =?us-ascii?Q?nhrKGYx9XyVn/yIDZXhLgCc5BLmC5n0vY9e30BtWkci2yQR82xuC+077MrKr?=
 =?us-ascii?Q?NB7uLPu8DgifZcoS60BNFqSOvzfG7mpGt/WQy42d5QUsahh8C8X25I9Jj3Qt?=
 =?us-ascii?Q?1itWHcm+44E1EalL9bR5r2AZPnQ4HMtjGoJHo4wdroYYT1kub4HwQZzM06gs?=
 =?us-ascii?Q?07D3PkJILDObTFFm81zeg5BEHlVQYPn0Oy8aqcdjugDhAp8/a4vJbICUatKR?=
 =?us-ascii?Q?wq9EChzY5DDSPFivwzv1Wj1XRJCq5gSQlRoqKwRZqT+Hrm3KTm7mXXyB/KPL?=
 =?us-ascii?Q?SCHI9nur5HYiXQGdq/+JLVcz22BE0aTZFv2y4veJ/Ta82LEsqPRJ3WlUtgjG?=
 =?us-ascii?Q?9ABSEkuEujJu0vu9UAfv040KPDXa2l3TC9D5DUi8RwJ1X+FXqMN3cI18IMFu?=
 =?us-ascii?Q?pKmpMTDVJBER0xMcsz65hjBg/TqZWcldk6JoUia993sR0cZX3DJ1Op3jYhAq?=
 =?us-ascii?Q?ZDdCHLp9tHGdShCQiZ9f8/VNwuKBq89rJBTCoBs4mIORTn1EQg0QGWP0EpQs?=
 =?us-ascii?Q?mB8ujn2+LtASysLuJPaddLCrmjY/VoyhLxkA8yDOp6GjjMmwdDHWvvhMvBvn?=
 =?us-ascii?Q?YixGm52sZylrGc9P8LNISSGb9LL8tBfko8IdIwzHYGYuf9CWm0ijwfoPpGQ8?=
 =?us-ascii?Q?2RHGqayFf8SEDowpgsQu7bwPPo4a2i2D51K1L8JLNeKWUNPIZIAs5vOM1/IH?=
 =?us-ascii?Q?JDv8LOUzMK1pLLIasmyz4RDjje18ot7NcHk/9VnG8PbcMQb2Dw6T7g7o/uKe?=
 =?us-ascii?Q?1gxm2V0EpflmjnrJoVUtu6hxD7zf0mZQViduXLDvyqKtJ5x0q93qo2rMzH3S?=
 =?us-ascii?Q?ng2QWobSiHYe9gCp8IwoOnonAITd3Wtoo+fQcjmnFoTLCOU9mu34aJyY6Ke3?=
 =?us-ascii?Q?Xhhof5KYw5XznEIHcYdulj61QE5ub+NSIfdEUUWrahK6AQwEYF/a3GNcZf9F?=
 =?us-ascii?Q?47O736xtX57mt0r9ixPS7ccM2qPtLs1X8d1YaPBnjP3rG/Y9eK8Nm5IvyjIT?=
 =?us-ascii?Q?IwLpjB+FFMqW5BShXTmpfannNRupmL31rWw/EeVKcBuI4w6GDaC18MZ6eyCV?=
 =?us-ascii?Q?np0dYJQ8U9monN3JggZDx3Bvt8Nq/Nfy9t2KCH0yTQRg9bjSosQREePYQKzF?=
 =?us-ascii?Q?wbwaR9YJz1VArhckXyZfBKtNp7k+/6D4mVMyY11+pnGBsMGYHwnJRLsuENHL?=
 =?us-ascii?Q?ZYRb1V89Dhc+SXOil4Ft6Dg1FwLGgLpAw6xS+2DF672ai1EFEZpX56xcW0Ix?=
 =?us-ascii?Q?4ELO43gBTJcme4elerWGITH904GuMvTu94Nepl8HJ52ZeOgVyap7EATLQ2HQ?=
 =?us-ascii?Q?rtn0+crSD2XXJlwBML4Myd9HkIqI2ND3X+Koo6lZByhBbh44WFcBlsxTlgMq?=
 =?us-ascii?Q?V8qpafPZ+2rjMximq+RcHOPwuaeG1hhaXKAjHbVd8hqNvvtwWuA2Yb5K7L/Y?=
 =?us-ascii?Q?swZ0Nhrpo4yXCHDlDPmP4Iv2OTkLdctcNB6MvZkC9MKX/TSaH6SdrONCcSWB?=
 =?us-ascii?Q?aZzGwiAFKu7MBB1BDmgV4SIxpthTaPMjZROT1CHA1XpD6qMwmKt6n8dIpkZ0?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q/Y6ktLtNfVnt6qhLbi1vZyVtWm3jKd6KhmJItGcn2BoO/v9LojIwUOYUuoAVR0n5gSTWB/gwK/siRtU101vZBflNe8aN1SX3+FdPOzibUbdgA7dUAEBBhlCF/MznydcZpUzJ1h4siMDzEmzxc8N0YAQmT2u+mfbWlqNG70rEqn16oaHdZq6DY7bzW3blltos0WHnu3nbU7hmuiddL+k8DFqjvTQQUAuA7XunhgUr6vCsgwUILk3s+9qsZOCyb1zNQAm6h4ZdDk7+SIpNGDuj52cdsXsWyoJscfgyqJUf8lWnwuTt2Usij6JwMcXwAkUMfrcab2F7hsG6bkNULAjFskRX5/+myqxb8wyWbuA7eXXu+RN4fOTYnyBM+FPafHAIG2/B4T7Jt7QLan11Qpj1ek+I6H4nQONxTIctt5Mz8Bd6JsGoJaiKxxOuxifzzmS+Y6baYwUsQ3G4zP1gN1XnkFAiRSlOsT3qMD4FU1xHQfwCO0Qfq8KiXk6JAuEuzPKjENsG0KmVnGkF6CuWe0aqPsD8OvhWVy58UN3RmgGL0Wt0zyv4hTWENpQCmtCi+hztQvIdgwQcyfMfZaddGnFZduzo9i8GqbO7N68T8Y2drY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03215d93-5641-49b8-edbe-08dcd17fb019
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 10:02:32.7074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02jud2HlQfU4J1fx52HZD02l9EV8z8KX6zDz2aJq0VYi/HCGB9JbtI+SiWnhD9HuGJdepsx+z6DklSAamLcgD7774eDeUglgMCd1HJsOwGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_02,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409100075
X-Proofpoint-GUID: gc52CITwLG83E-NazIeIKq_AI3ziclBh
X-Proofpoint-ORIG-GUID: gc52CITwLG83E-NazIeIKq_AI3ziclBh

From: William Roche <william.roche@oracle.com>

In case the SIGBUS handler is triggered by a BUS_MCEERR_AO signal
and this handler needs to exit to let the VM pause during the memory
mapping change, this SIGBUS won't be regenerated when the VM resumes.
In this case we take note of this signal before exiting the handler
to replay it when the VM resumes.

Signed-off-by: William Roche <william.roche@oracle.com>
---
 system/hugetlbfs_ras.c | 60 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/system/hugetlbfs_ras.c b/system/hugetlbfs_ras.c
index 90e399bbad..50f810f836 100644
--- a/system/hugetlbfs_ras.c
+++ b/system/hugetlbfs_ras.c
@@ -155,6 +155,56 @@ hugetlbfs_ras_backend_sz(void *addr)
     return rb->page_size;
 }
 
+
+/*
+ *  List of BUS_MCEERR_AO signals received before replaying.
+ *  Addition is serialized under large_hwpoison_mtx, but replay is
+ *  asynchronous.
+ */
+typedef struct LargeHWPoisonAO {
+    void  *addr;
+    QLIST_ENTRY(LargeHWPoisonAO) list;
+} LargeHWPoisonAO;
+
+static QLIST_HEAD(, LargeHWPoisonAO) large_hwpoison_ao =
+    QLIST_HEAD_INITIALIZER(large_hwpoison_ao);
+
+static void
+large_hwpoison_ao_record(void *addr)
+{
+    LargeHWPoisonAO *cel;
+
+    cel = g_new(LargeHWPoisonAO, 1);
+    cel->addr = addr;
+    QLIST_INSERT_HEAD(&large_hwpoison_ao, cel, list);
+}
+
+/* replay the possible BUS_MCEERR_AO recorded signal(s) */
+static void
+hugetlbfs_ras_ao_replay_bh(void)
+{
+    LargeHWPoisonAO *cel, *next;
+    QLIST_HEAD(, LargeHWPoisonAO) local_list =
+    QLIST_HEAD_INITIALIZER(local_list);
+
+    /*
+     * Copy to a local list to avoid holding large_hwpoison_mtx
+     * when calling kvm_on_sigbus().
+     */
+    qemu_mutex_lock(&large_hwpoison_mtx);
+    QLIST_FOREACH_SAFE(cel, &large_hwpoison_ao, list, next) {
+        QLIST_REMOVE(cel, list);
+        QLIST_INSERT_HEAD(&local_list, cel, list);
+    }
+    qemu_mutex_unlock(&large_hwpoison_mtx);
+
+    QLIST_FOREACH_SAFE(cel, &local_list, list, next) {
+        DPRINTF("AO on %p\n", cel->addr);
+        kvm_on_sigbus(BUS_MCEERR_AO, cel->addr, _PAGE_SHIFT);
+        g_free(cel);
+    }
+}
+
 /*
  * Report if this std page address of the given faulted large page should be
  * retried or if the current signal handler should continue to deal with it.
@@ -276,6 +326,15 @@ hugetlbfs_ras_correct(void **paddr, size_t *psz, int code)
     if (large_hwpoison_vm_stop) {
         DPRINTF("Handler exit requested as on page %p\n", page->page_addr);
         *paddr = NULL;
+        /*
+         * BUS_MCEERR_AO specific case: this signal is not regenerated,
+         * we keep it to replay when the VM is ready to take it.
+         */
+        if (code == BUS_MCEERR_AO) {
+            large_hwpoison_ao_record(page->first_poison ? page->first_poison :
+                reported_addr);
+        }
+
     }
     qemu_mutex_unlock(&large_hwpoison_mtx);
 
@@ -522,6 +581,7 @@ static void coroutine_hugetlbfs_ras_vmstop_bh(void *opaque)
 static void coroutine_hugetlbfs_ras_vmstart_bh(void *opaque)
 {
     vm_start();
+    hugetlbfs_ras_ao_replay_bh();
 }
 
 static void *
-- 
2.43.5



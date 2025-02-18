Return-Path: <kvm+bounces-38490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38BCEA3AB08
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:35:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBDD63AC7EC
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FA921DDC16;
	Tue, 18 Feb 2025 21:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wt76vA5I";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="llSaSJ7B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47691D86C7;
	Tue, 18 Feb 2025 21:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739914466; cv=fail; b=sbGFfWCwGoZGf3l6CS2Y+l0f7hwDBH+fufP+T0/+lXBhExfGGV+gM/0uIoUAWIxzS/fJrWqNAYVj6nJknPO8rWaIiOt7Pe2bhaIqqqUp+AIaFQtj+nAFSxiBRIdR44GrJ5XN2gSGIcjxS+YoYyEMHiOJZMR/p9K/CAKUy8IoY0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739914466; c=relaxed/simple;
	bh=DVVhYd/WrhOtb8aUDHlylIdNS9AATp/2thz35KUD9e4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BhDd5LWaBUPYyA+o8jKO+Jn7JzUUqW7o0eri3w99LxkVX8qpz6V2NPFb0hMCd8o/Yz1mxuvEhivMpea53DSdUAAkIYkGhZTcQobVpXebY8NsfVm/Z4HI1x5gQF9V0U9Z8lABu+cQpFT5c1YOlsO5J3bpBWx1g3ep/CtQVhl6n7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wt76vA5I; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=llSaSJ7B; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51ILMZab022656;
	Tue, 18 Feb 2025 21:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vbxLcRDXwMau6ojZuyq/zCmmjpfyFtoL4t1auecO12s=; b=
	Wt76vA5ItepNUj/urMwBIrCd/Kx1v00ygpjfJsw66gyOlu6fX85LceA5cB1RDexq
	HeP+5xnsAdzFhfMKhne1+aUCVEKDR0qjXOTab8TutYI5chhiEV+WlNJSK6+tqViL
	0DhW/8topc5qHXvkdIUhbD8H2+NzEK6Ug9wBpmtUffDymBaBkC2DHLxNTadorK6I
	ncG3w8yLslMT11KlGitzX5Z+UvbRzg7/zpNRrPUN+py6vkEbu63yvxpuCnicnqvD
	2gG/YBojVNsZAoGyUZPFfXZ7UpVbU2i/6C7519siowMMBqp7ZZsMQu83s6zuQ+Kx
	D9VKdYPj0256ZmtfCramaQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00kgaa0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51IL61OD009698;
	Tue, 18 Feb 2025 21:33:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w09bmx5c-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c9IN4rsLPlQ69HSBCORlWi+EJ+YvMvI2O0hiEWbOkUqjU6Q4Yaqf3xoMkgpSbkTW8d5cDWKchcJw1cjWAJw78qVUM0bOCqieqzgtOC0oX5JIIS09Rz+KfTOlhOTFh59trylvDcUx6GtVqzmKZcy5pn9ElLDx8FvNzMqesr5x1Yt/sBbtEUBiXSCos8UxXhVgBhuWRKAAq1f9OwyXDkXVU4ubrtGtUtznAg2ON9TSCEllhzxAWJfzMPf1UYF/6YoLBbpVb/XpQx+lAWUkO/75DjcnvQyHfEhzJaMCAmL6qndXdCiNXAqjzMi+JVpE35Jxwb1j0YhgRmvNkkJ/LN0JKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbxLcRDXwMau6ojZuyq/zCmmjpfyFtoL4t1auecO12s=;
 b=r4doantMV1qNqbUL0gTRRROHf8whwcfxdI7s8IvuQo6ohE7IzZR03e8m5gQqXikpK1k+VLjMShZ62QriUrkUDYFtiW8ClcC8xQXQ9bcaGfbQfoIceTBDxV1GpGvCFnuteP4ko49cAplGqgloajs43bw6m8aHON6Wpw/7OFv152NF2BxWRC58NfOrm6r76IUrFo+hRrmLUaSKpq2ug1aLNSiIeb/P4flR2H3WLwTkxUAWkcKIutQ5X5yOelw9Q++woSKSwDAhJaOWgoT0e1MeJm/99NbBKStMoMe5q9HQYxX0BfChOrB4JOIekgrpB92AhbAj3CKjBYIBh6epbXVQvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbxLcRDXwMau6ojZuyq/zCmmjpfyFtoL4t1auecO12s=;
 b=llSaSJ7BapgmlQkj145Q1DFNW3z1nrVk2K7g85jv5m1W/AuIHWXqrvQFKGOSXonrCObHTK8AQYh7ldvsOEJ7zcr7Fw/ypd6i/KbmvhWd0e9G2y5zeQMhW0i5adMGtBKVDD+YVe2OKKtymRFIU/RMoHCFvP3BsDjfCAwf21F0U/U=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA0PR10MB7275.namprd10.prod.outlook.com (2603:10b6:208:3de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Tue, 18 Feb
 2025 21:33:54 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%2]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 21:33:54 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, x86@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        maz@kernel.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        zhenglifeng1@huawei.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: [PATCH v10 08/11] governors/haltpoll: drop kvm_para_available() check
Date: Tue, 18 Feb 2025 13:33:34 -0800
Message-Id: <20250218213337.377987-9-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250218213337.377987-1-ankur.a.arora@oracle.com>
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0065.namprd04.prod.outlook.com
 (2603:10b6:303:6b::10) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA0PR10MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c39104c-cd43-41a3-f6f3-08dd5063f17d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PTctc6L8vZ+rOcDoL5kaNxVrTwtZ/wN5SrNtmNzSczPWrUM0dZPiuHbF0Cf0?=
 =?us-ascii?Q?rTGLm1JhJfplH5fFyRqMXP8m5ZJblJKlkgnfPyXEdY6Z79chrY2qDGXqYOHc?=
 =?us-ascii?Q?MrztNOeIlnmf9aSqy5GZRWFQwnXIFR+d3evXvcU9XU+3T4uTvqp6V7hJ2FmG?=
 =?us-ascii?Q?4LBEQUYc5ejrAA2rcKWHKAwCxAhHXR0yjQvEPJ+/hH8PzN00mVlUOFmHlxp/?=
 =?us-ascii?Q?in1Gj9jExtiOlC10QwxFj0lSzerygml1nVmpqYRl3/0aJcnYNeC0KBlq1nTR?=
 =?us-ascii?Q?p1oWrwyiUbE/ffIQFTvj2WxEIz4U8szxEsigL4/pOseNKTX/XQLJnMCjcmJ7?=
 =?us-ascii?Q?ONmM6IgETPOQbPoAWaikMJHSzLguM/IGSf5VZg+PU14+KRwqaivxU5jXRlKg?=
 =?us-ascii?Q?ZzLKBKyUgCTx6sUrrB+xjVQhMqr0buUzp5ZcZTmUHf/3sTnn8fc9cdr26bv7?=
 =?us-ascii?Q?aMPDt10FIT4i8AxYl6foJKpv/Xlzy0QE4oWAsg0Q18A8xLlO5Q7JSsF9RL8/?=
 =?us-ascii?Q?0DXgUl3dUNJn5Tt1iuVvUfl1Ta3DGWEDXW3DJtkPMuxP5wJkvwIjyjzkuZGk?=
 =?us-ascii?Q?QoG3pCEHtyPZ9MiBf6NCkBoPm2lqS6fjHuz41UooqyMh2phJSwmc5c1vO/Hl?=
 =?us-ascii?Q?DtBJ1Z59ici/7k4844zd2FQPhZSR1urHAo6n8nbYGay6Xd+Dk9UL8VLkSr/e?=
 =?us-ascii?Q?Xo5waPNq54GNDo32ufOgoNBdgkgI9IlrpDbz1uESn2+2Cgo6AwsdPcdL3fwA?=
 =?us-ascii?Q?3A9DBtVurkfk2W2vxtbbkiXg6jWcuJqow0NyslW2cI7b/cmJU5BeiFb73+ZZ?=
 =?us-ascii?Q?Tnw/TlM9s6jlLUwxL4qwz4CAl4xq7LJV5c8j0mGv1Nw+ZALlnvTSBRO3rcZ9?=
 =?us-ascii?Q?Dsk023fHyaN3auEmzC3kXnf/6umab0rTXSQjssMvyj3a9FoJFyAebKPa92Or?=
 =?us-ascii?Q?DcLQtsW8apxdleZdDg9SXWILJXD5Fy4F+bCuDsYvwklLq4zr5Y/VYuySDAp+?=
 =?us-ascii?Q?Smzwj0QGEItdEtXpx+F8Yunnu3uo2oCaP7ljerxATN8RQo3P5eTXAa80l4ux?=
 =?us-ascii?Q?VF0Yt0TFNzxH0ZxkET3kKDYqYR77JRlg4zJWRbUaUvxmYQy8Dfqz0RvsGs6F?=
 =?us-ascii?Q?9AuDZf/h5BAQHFeyVk7ovPYY+EXAvASZZEeUr2xgfDIPvH3As2dG2pR0U1uG?=
 =?us-ascii?Q?Knf4CVxRZFvQXv2v8dy0MtpOtF8ItBpbhpYMsS/p7TkaSLzSZ/5lubVdmvtd?=
 =?us-ascii?Q?3Ut8wT8VZZiI0ouetX4P1/An2McxsqB7f/3tnXEr9sbR4ejmZoW99b7cswz2?=
 =?us-ascii?Q?oP5QydEZYEViWU2jj4oDe9euoqU0Z6uPCQOkpnlKpF7PI5taR7KMU6+68u/L?=
 =?us-ascii?Q?F31B//8ZwzdMLn1O11WErYrgp6Ab?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lTP7VrZYKuRJKf+I10e5fDhwCNTsiCg3xvMNA5uNba1cr+rIH5uGvYAlfPeW?=
 =?us-ascii?Q?QsIMaQeH4PJ5twJkKmyOKtq0sfkfRcZAMrYqvSsiU6iRodjHFQCflRL8p2W3?=
 =?us-ascii?Q?qoxM+6027I+uI2mSCnpSOttDJRCtLiSsmQHoD+HVJ4g13PgKpBYF8zXOYIfb?=
 =?us-ascii?Q?9wzf9bJsPqtQL/psDvLwztOKVQzNDcZzT9RIYCFU/6yVnCxgEyCgg+Vx0h7f?=
 =?us-ascii?Q?uO2Jy2ewMoScAnLXPYIKbvtDVJuYFOMa280nyhIJ+Ce2pkHdjQ/73sdgUg0a?=
 =?us-ascii?Q?ZUnJgFLCOtjhzUuo50o6eoDi7p+wW3WxVVb6slrRhcu8ziPC1fv88j2gOv8R?=
 =?us-ascii?Q?kBfGaoX0umXaXrkgM9DTEaH25oA8uut/YvvgNxgvCXztUdA3WN6Qw3gLpCCf?=
 =?us-ascii?Q?u9DJJ5FRL9UFGpnv75w+youqnuUH31VrOSdzrvANHmcXoXCCNWyD+TqVUO0A?=
 =?us-ascii?Q?WWQKZl8GEEGZGXT3Hz8J5M5iaVgHO5YU02QDtQa3maWkUAaGj0fwQJmOwrEc?=
 =?us-ascii?Q?j6pJT+t2Cp/U21GPhR2XFcP44rHdubsFy3iCuGvFgEWNrkJaAf4DsJnhME9q?=
 =?us-ascii?Q?jCX+03AMhQdAblMYjLaMflv0MgIanGTsliM27It54xjecpnzvkJlxUED4MAq?=
 =?us-ascii?Q?s6KmmhQuhO1uTD/KlqbfRAJTkVMkTHjOfIUzDtxeYlc/H5j7rkL2zE40Fkxx?=
 =?us-ascii?Q?chUxZrSRJsQwmG/9aYUHxRSu5f7q4AAN/3BALeaViddEGiREi4rxdu5y6p/l?=
 =?us-ascii?Q?TK8WpYqmYYtJl8SoNWoFv1TBbdMBzK/x4EVKw/l9j+PBBZOa7X3pBVx+HVIl?=
 =?us-ascii?Q?iLD1sa8zrXhE2NW8VXQg9r20D5XewtzS2ga42Vws7ZIFWxA3Z02qc6M3pg2N?=
 =?us-ascii?Q?SwMxaP1iFqUNM2Q/ctVShIstQWSBuUrBTfSrMJEMs22+rScv2zFCmr4Y7Z7/?=
 =?us-ascii?Q?yxz7oQF8SnCL1aS+e/b3zMvW1xsg56aE496/YXBqG4qyozqYFzKDnLj2W7bO?=
 =?us-ascii?Q?Bby7jFoMJver+qmnAB4SDwHUaHxSmZ7pOD33lVXt+p3y2jePdnnlN54kWl2l?=
 =?us-ascii?Q?805/kBwZiwEtjC44XJ0iEP8x4ymW/vO6H9+V2ydGd1D5yqKhUl3Fwfz9nT10?=
 =?us-ascii?Q?kryWaHJ1O/6SJ9qLTU/Mmkp8V99IhAe8/fTupiGTKVvaBBRj/QhBeyitXSD6?=
 =?us-ascii?Q?rCXPMyG+2zjOrh78HuAGXQfMPuKTpI+BMOaxJsPM54LE7r3WLWi5ygIN2CmS?=
 =?us-ascii?Q?whYmcl6GIpkwciPrK6siixjs86GxVBsWDvJTy8Hs7pHnQNFGFublq6hc4kqp?=
 =?us-ascii?Q?FESFWbt/tUAqqvdUbLraiQc3ELPggu8BokZnu+7pvNsvyu6UaTyu0Mhbpsex?=
 =?us-ascii?Q?fqmVPIqit0tttq/wsFP8qku+lJnl//sar0+gFRonXJx8492C1mopAejz9FZh?=
 =?us-ascii?Q?c6XM1UNun2/ZtWlHsQkWvBs8akdDUXRwOeZnhPc2vp5x604o3L1bKajZ61ul?=
 =?us-ascii?Q?XfD9+FspnyPPdAxhhsmsAN/SaZrVjOi/j8PBEyX6vfS81VhUQMpGeQXpoyGD?=
 =?us-ascii?Q?9S60UCAA/t/B9OHfyO8aj95JA2aIymsGNNpkwCJ+TpLy8CiQb8dnIhEXNXvS?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aXpPM+F7QZYHdYZGjJpZwh4oEybjoPmO5yXQjTYNUGL9qZfTMQdeojXUSoD3ygf2jcl06aAGKyvRmG09JWVP/Uhfoj0ld1pSWiVH08fzjn8qnYL7JpTweZ6yZ5cfJeGaVKrf9pQg4Vp4sU+8zjyuFibmWwhZ4aLHM++U/AYrTebvPFO1J51l5kF5W51rHQNgBcV8CVr4M+A3ib56VqPp1Vt3Fw6VmK9KkW4gWtsETOE5neAkZJ23yxkLly0FzNfVeOKjNuO3BDoFUVBdzNok8YAU4M2m0fb+jG1OCs6dldSJesDC+r/oUSrGYi1dKqxNJI7Fw3ePKC7krC4JB8X3nSVNqrjwn57sWtvXKcLf0v79M+w32iSFnUas3MZZLXlAt+mx1rfyky3cSX2T+qRkV6bX2jSsVgq3gdpZjyNcxV3ayYJNdpXI/wvOt3uIbamh1PSO3jFp1OhSsFv3UubL0yFXw6cJsnPgaXTUo/GjIc/ZrW4lNtj2RWUL7f5SOSBqKTQWokzZbxTr8VSGRii5uWH326rtXmSoyw6oD8/sKr/KVYy8bReggCCZWpZ9x+m3sH1axOzYzgTc+tkKbPlrkkEKmykFlzbGN4rgeamdOVY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c39104c-cd43-41a3-f6f3-08dd5063f17d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 21:33:54.1130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gRLWBp14MseuHF7e0gVu9/z4jfIfp3/acJXwnWWeC+NLXbJiueAsRVLt9NJ5ZET/o5nVkDqVP9HPPnxHlzOjKJmbTPlZ7ONKcXvsdkEiWow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_10,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502180144
X-Proofpoint-ORIG-GUID: s7I-uFCmyawVl8EWuDAguWLI1hEgYgFh
X-Proofpoint-GUID: s7I-uFCmyawVl8EWuDAguWLI1hEgYgFh

From: Joao Martins <joao.m.martins@oracle.com>

The haltpoll governor is selected either by the cpuidle-haltpoll
driver, or explicitly by the user.
In particular, it is never selected by default since it has the lowest
rating of all governors (menu=20, teo=19, ladder=10/25, haltpoll=9).

So, we can safely forgo the kvm_para_available() check. This also
allows cpuidle-haltpoll to be tested on baremetal.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/cpuidle/governors/haltpoll.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
index 663b7f164d20..c8752f793e61 100644
--- a/drivers/cpuidle/governors/haltpoll.c
+++ b/drivers/cpuidle/governors/haltpoll.c
@@ -18,7 +18,6 @@
 #include <linux/tick.h>
 #include <linux/sched.h>
 #include <linux/module.h>
-#include <linux/kvm_para.h>
 #include <trace/events/power.h>
 
 static unsigned int guest_halt_poll_ns __read_mostly = 200000;
@@ -148,10 +147,7 @@ static struct cpuidle_governor haltpoll_governor = {
 
 static int __init init_haltpoll(void)
 {
-	if (kvm_para_available())
-		return cpuidle_register_governor(&haltpoll_governor);
-
-	return 0;
+	return cpuidle_register_governor(&haltpoll_governor);
 }
 
 postcore_initcall(init_haltpoll);
-- 
2.43.5



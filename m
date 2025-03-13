Return-Path: <kvm+bounces-40878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA72CA5EB21
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:24:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FA321892C88
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 05:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28AC31F941B;
	Thu, 13 Mar 2025 05:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hs2hQBfj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HiooXB+B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2F41D5CDE
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843458; cv=fail; b=Z1F0Iwx6/YWlAlQnnfr5w8vEju8MXWfMpQIUgGYt1TDi3zqheUgt44oWo4gUBk/7kRpzTQdms4PDpZpCzY14ba2ZdzA46PGnjjyVgXr6lbFWf6hfQana2Es/Jwh2zvqFb6D5zKnViFxL7hyKzozcYMIOmvIqiQux4pZDUOG2194=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843458; c=relaxed/simple;
	bh=JedUTLVXNJGEmfBqhM01D9OAk1y6Zru7AbmUZ92TXLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VhmixeG/59irq+rTuSDm51XdHm4OmxCSwUsTJ2kdeV0x/wRDK499/rxOvPU2L6OL0x7cewDn34+bg4oIZP1CRKYmEEqDKedXU80iUlcWGHUoP+RV03r/mpeBMM7PWaSS0UoKvRjpK9R3qU9TBnZ8WhCU2ZWqDjtenr5ooUbTTAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hs2hQBfj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HiooXB+B; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3uN2a025239;
	Thu, 13 Mar 2025 05:22:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=KzgKmFrPi1qZHB74acbxxncfddC+W3GAj+sv6CZAaMU=; b=
	Hs2hQBfjBjD6eR1rVNMQ97Rt6OHx+7+M5Mvn9W4xl9lYQQaNcJmPno0AyXXijTXI
	dXlqsujo4DWJb7gMpr2gRzGLBwJp3RCGqTAUb1ft5A7/KTTcyK5/IirPUVi7FqHW
	Agnu7ESqR5NX0jhdW1nn7epvXeQS2sWBIHAH4RY5I+vinTVbxelTX0aVlEe5yPyM
	3pwEVqzPLFGCTVuNQluRTR7q5asOfKtEqTZpH4rG1d4Oh/Mvmt9aEkAFNgK1dKBA
	+Nt2x9cLwfL7Thza3tzaFHS1xFV9CW0mpFd+/g634p4rqGibUsAJGT2ma5UbSljB
	mgnoolkOCuKSJoqicR95Hw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4dkf1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52D4ZQK8003845;
	Thu, 13 Mar 2025 05:22:47 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2048.outbound.protection.outlook.com [104.47.58.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45atn1nwwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wqvrAAFE0+KZaTffjUxQKmZVLqKCNlcZ1fEaKHeseZUz7PkEMMdefrMb4Zid21J04TjD1JetI9WOEtFsJ9MK3cLl6KhwuL2Q0YGYeX4MxyO80EhkSg5hpwz5t653l/h8RkvPp6pSEVgqVMxC6D/TlWJWRSzbni6cakblxHi6O3ScCsVbO7zK9o0qkAsAeYh67MaUnFEKpF1VnLVVXyfa37sWqboM1NNFUER+aCExWpZpdjfL6FsWX1B6KQGfizGe/wf5YGzr2S6f2pg3DkB2j7xgqOaIbseWKOVEfNBmm50o4375CII0eAOSOIjtIcp1/dpc9lZzhjAxUL+f5LM2pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzgKmFrPi1qZHB74acbxxncfddC+W3GAj+sv6CZAaMU=;
 b=rOcq+013pBSwfzxOx71qhM9eC5BkxxOMyQTTNti8Z4rK6+RB8K5FMIlFLM5lhlfh6Xiq3JCQ5+GSV6JthcF8D6PIHmBJi+QA3XA0NF4/2pC73s7GGTBz+wwr0uLnQmSfplAHjHAtkwm3vvOARyhG4aWrAvxuvtMdYm6eCT1+h0iaantEnjotzQXZtQ2GshtZWTnEkxz/ZuoaKYAeJn61AprE4I5A/YZTZKVrt11NfeH9eflIZ7ojA10sQlWD9QozGyx0CGDdZnV5e/tPLwquqdqQw3GLpOoKeCN3BRZLMiK9NUta21ME/yaFQrseFjgrY+yWE34ngtcrq4Zct0UCcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzgKmFrPi1qZHB74acbxxncfddC+W3GAj+sv6CZAaMU=;
 b=HiooXB+BsSD6edlHVXSQ03psJyz30aaFATlOHcwVaC7nQtEsVvrAbzqXyFLUjvfXRW3LWoEWi60owfz1Z1y0EfLy2sBJChJI9GbcrH9h9jWd7Rqth6OtLurQ0vqkegjmn7mxo/r4YbV/2+ZVY0mELcs9cfr7Sl0J0WHbn6pncWM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 13 Mar
 2025 05:22:44 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 05:22:44 +0000
From: Mike Christie <michael.christie@oracle.com>
To: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 11/11] nvmet: Add nvmet-mdev-pci driver
Date: Thu, 13 Mar 2025 00:18:12 -0500
Message-ID: <20250313052222.178524-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313052222.178524-1-michael.christie@oracle.com>
References: <20250313052222.178524-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH5PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:610:1f0::27) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b8b6cfd-6244-4aa3-b335-08dd61ef1591
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zW4ePmiSsgdD17eNN4mL3yWVCM2Zkf/GqlpLOXA53qwKsJ7WoCGYrtDcXUro?=
 =?us-ascii?Q?gQa8XEjmSvTiO4v+OBx4f+W89Zr84nZx4K/f++8SY5CmfmNysXUZBwhCjYp+?=
 =?us-ascii?Q?ffO+xedG9l+5NHLKt9O7akRtgHUYk3gyyD1sK2mDazB7z8njCen3JEPSXVRn?=
 =?us-ascii?Q?059XCnyp5M/2has2MNdU5/1Kdh6sg6kFADLLw2UiOeCyx3Db+Q1cYZqS7JNr?=
 =?us-ascii?Q?PDsmQTakpNggxf4cfrO79jSv7AuzgE5A3yXw1cgnb65xY57rAbyLVM1Yy1OP?=
 =?us-ascii?Q?XKfAl7J7zevj3FYhsimZOG3/MwXvuffkQtLUkyrt6fBUNSQie4iKhBL4dC2U?=
 =?us-ascii?Q?TtM6rv4g8+nRLSiE4ZOcFSIY8uElKRT/UtqaphbSXtfNvsBo25PVV/eESz/c?=
 =?us-ascii?Q?iqyyxbYDdpO5VT3stMsfYKENsITO+cMhMT2fsd57jz5R+hZLMCCtdskJk3bQ?=
 =?us-ascii?Q?wIxOCqk1z6aObTok5H2Kvbhdb1Yt0tKmwaQID7/boWXUVTsOk8qF/Q/qUM0o?=
 =?us-ascii?Q?d9MHhYx19J4+ur/kJbmiNb2znSzAXL9wFAL1zQqgsXd6aBuyHQprax8pECMl?=
 =?us-ascii?Q?fD6kof1m7ge92WrcxgltETrPeECa9VqrhI+QK6d06ytFo2u9Rwr5vPUwJu5Y?=
 =?us-ascii?Q?lkF5Wk08fdukWaQotMMBVg9n0ZTAJwsgBA1u47UfcYmJ2xWHO88QBcA5oUIQ?=
 =?us-ascii?Q?YBi2Jcm+TfjPQ7jV8KsjI99pMUERjBh+0cLVFoE0WZ44qpNMgnPFFg5+R/La?=
 =?us-ascii?Q?+hUNqCUY0tsCJjyIEE03ZTF3u6GLb4IsABlyJaF0HcKXh9qMsjlL3YjLSRXd?=
 =?us-ascii?Q?DIj6/rDrpKmSbRQokpxJ1Cv4qupfmEDtWf1SIB2AEDtIcBp1yJQdhmcOdmjl?=
 =?us-ascii?Q?aprrSV1MP18aXZKSSepCMjMfPC9RJOzjPT4+TzQXm2G13BINjWltpKs73sDo?=
 =?us-ascii?Q?Is1xnJHgegNZ/4BdFCN4bSESTlTI2ZmkJH2dyUmArdVP+CUXMXFxil6vmJPP?=
 =?us-ascii?Q?trBMO1jyLp49/pN8ttqDPXJ3v8e7IxfVOThqvTE1oEkGR2UUdHmOSncnY7D9?=
 =?us-ascii?Q?LG6xdfpEofO6g/CyWl/i+0HgzLAwINkawS+uOi44AaFdBCzErsw4G9OGrotE?=
 =?us-ascii?Q?FCg3GUPNc/L1VsTlLMZdtQNhZwaIH+jQr8/G1E538k29K21CNvNuzp+Wl5r0?=
 =?us-ascii?Q?7/x5usIhKKwgisdI1pJIIcB9S3zzzSdzA4hIhaYLH4NOYg/4ieBDIWM+QooV?=
 =?us-ascii?Q?jwpBrNtv6DqW/Tt/ZpMTCUOj2yFSL7p/em1E/FgfE/ZTcZkQrBRz6HHoftCm?=
 =?us-ascii?Q?Cle68psTSu9lIzcf3TAtuJeGaq47uzk95jG14KHgQens6XhvPVXvcfzbh7Cj?=
 =?us-ascii?Q?o7SJrCHxg+MDmIvrem09UWU5T1d6EYpg+JtHGhomJPALLkJAiqUyxueUbP03?=
 =?us-ascii?Q?dszCDg3ytus=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n/lYt8SKGh6R3wYfz10BERjWoJ/HU5jz3csQOXahXa81oemqjvbSHWtM2PCa?=
 =?us-ascii?Q?xcUwc5Xr5LaB9YEPmc4gF9hslWW5tPzxEpXcDyOkcmzPk+svhkqAFi3Y/gTs?=
 =?us-ascii?Q?2vy6RaZwbxyFYngYoQiQDti++RW58YbfPk0Oz/DAI5HZTyQl+e1qiFJPdxrP?=
 =?us-ascii?Q?SxB+aWA4Jmsb9M/KTVtgEeaBEF1igeK7siUSMV7CQPH00Nx0FwwSE3NE6yW/?=
 =?us-ascii?Q?rbZF42N2nFQV6vZ8xyU4p9Zle087kDayBO2NitOglWxi9tzqus1hrrMWy/JY?=
 =?us-ascii?Q?BoAhnZ8Jb+weT5JcxcxtxdKfQAZvtQotJb6sPLghSDFmlLG5U3hWtodYF/pZ?=
 =?us-ascii?Q?qRyDRIIEMUf+ouxPLw5bM84RT64OO86zmO2fOMNa2XcyRbluMC8k/e0kxRIi?=
 =?us-ascii?Q?EG3J0gNDo5ngfAwSu9fNsUHjhalI+lL9jdZkiGom+pNuOenhI0tqrdRM2t7I?=
 =?us-ascii?Q?4xa08sdPKKu8ZJE4YPHB6qv4WNu6/aW2/8fpFLLyOO3ZvAmn+Ub7kWeyq3nv?=
 =?us-ascii?Q?sr49AIUgFslNgXfwrPrJpNnSsx16Rnu6RTfpKiMRUBXaGTrOyc02akemcX8a?=
 =?us-ascii?Q?qa7W+WV8kzMYh7Tk67JyyW11xv6rjIdTyO0MWyCsj6e3PA/v4IcTQ7ktk/RS?=
 =?us-ascii?Q?4M/xgXQAFrLwe9uv5TfuxsGCcf90Mr6O1kwNBvdrvdsTWLx0RY8vEJC2ZxOs?=
 =?us-ascii?Q?Ijjayt3EhZGuuRhdN/EUx0nO8soPrqcavKV0ELFfXSr07Ah8d6YJjHyeEi6Y?=
 =?us-ascii?Q?6hfFlP/+eiZ9TGS47UHBg8KQo5NCJ4Ax+ECVgxtoOtsf6X5gSnZbpXMeooBq?=
 =?us-ascii?Q?mwRl9DCKYA3Ku5YWD+Q7fZMFjWA3aw/mqIHqJ4eWpzNnupo0j707+vG7k0/y?=
 =?us-ascii?Q?fU7P2p8KdHDcrRltsrfTj0GjiwozOMlhoFlYAH5fgNisx4Mt6KtKyQgriZcR?=
 =?us-ascii?Q?B817CmyEkSQXXXO4aMn7GxCqcBE+w90buB3h18sEmmH6FA2wHj8srUCJC84h?=
 =?us-ascii?Q?HiKu+uRZtDc394sVdz8+anYlA5gaXDQPxijh8RFOtioI3wod2K+aJMNazas2?=
 =?us-ascii?Q?YS4xYFZjJtPDE8VfXxH8+a63aaNSb4lyRTQyXEVb+wdOHeueG6jvXbqLUY/n?=
 =?us-ascii?Q?mZgJml89MxQ9UviHskadLjLDyyfOikKuMAaML6G8pGA5xTTTWE+3n7tyxcSN?=
 =?us-ascii?Q?D5T7iBEg8j6YwwEWCXBMl+JlD7QAaeFlIlI/1u3yig2qWUZealY4HZrxWfE1?=
 =?us-ascii?Q?CxtHNhUglFUx4fFIyTL5w2Er6dhuHdwJIdGs1blifBH/qHaGMTKhstJnvsGt?=
 =?us-ascii?Q?ZOoe6xFhZv9Q08LCD9oJDgkn1LHCPQk9uudm6nK3/4YLa+7g+BcGeZEjC0wF?=
 =?us-ascii?Q?hhG/K0G+MV0mTdS6FYwQefSF1G9W4GKX3Y9C+nBt7cxC5NPV5rgET9VlNVYT?=
 =?us-ascii?Q?gb/LZk61I/psL7Ja+j+M703RGv8KcNkLfpVNkz3tvJl4HltMASmqo9Tdt90n?=
 =?us-ascii?Q?maqvsINyTKtBBEwV7M6NX0GemNtTmLBO6l7EOJzlIOJohb8vdzZ48GJ2Waha?=
 =?us-ascii?Q?UD0prDx8FthYl6vYwsMxVom+rbI2kB9RvKvIarquuOkz3w38W2YQjKCKLOD9?=
 =?us-ascii?Q?jA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VzhQ9x+I5RYyr3jb/W8j98pUpfgGB6dDioypk/8/cX7mWQ/GgbPHIRDyHuC8jyCwAsDKL5g/iSdTFexQERbOVedjU04iNhXgoNzi+6Hfkc4ar+IECHRecxBpXV2MPDQI+CZNyiIK1wUu0We7gNK5Ak04tkKvHZoSdS9IEhKWGNkIpoVSlwHaA63PRkf9xenAchucykMY92pi6wuygn934zOE/Vitxggt8yBEsY7hokDwNlQw9RELu129NT6T5zjA6mKtay1RNPh0Er+mUhu1SVTfKJRL1MpQGuj5utOAdSgh/mKP+xGbKS0TIaqc2HmMwsKKP92iffUYpSrxnrUZPI/yEXMu6UV0sN47+Ze2P45o66LZGahIArzIMHUy2DxOoM1PnVwn2GQtv5uwbvc1q3aWxDWihGCunhHrcLSnDk+nLwZdhzOZLAzY2dvAsvuypZYEnS407tX93aKh97itB6IOCXwfwDqBXkQGg7flrsE+9V9fpW1zL8WNK0aQO5VrPoLFM0AS53AaD4ahaiovovDXcJdzw7EbnxelJHXkfp9XyooU/POfKLcfm8E+DAXnq7D6VRYijE9qndTqZqtluP3jEogIw08Td2/SKh9her0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8b6cfd-6244-4aa3-b335-08dd61ef1591
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 05:22:44.5912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ePC7RUY1KhTAyus87sMiR9iO353Ocz2Wn/e2TjG1224U0GtsXi+tqXpADhpLsdjommafevKkggmHfzKvZiyuUTOJrGBQ0uFrlCz3XS0wmrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_02,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503130040
X-Proofpoint-GUID: yaBVuKpWa07hzxrF9GiMCJgykQ9DqRWz
X-Proofpoint-ORIG-GUID: yaBVuKpWa07hzxrF9GiMCJgykQ9DqRWz

This adds new nvmet driver, nvmet-mdev-pci, that can be used as a
virtual NVMe PCI driver.

The performance of this version of the driver beats the kernel
vhost-scsi and SPDK vhost drivers at low number of queues/CPUs. Here
we do a fio job per queue and there's a queue per vCPU:

fio bs=4K iodepth=128 and numjobs=$value_below:

        mdev vhost-scsi vhost-scsi-usr vhost-blk-usr
numjobs
1       518K    198K        332K        301K
2       1037K   363K        609K        664K
4       974K    633K        1369K       1383K
8       813K    1788K       1358K       1363K

note: shadow doorbell support has been enabled.

but at higher number of queues vhost kernel and SPDK are better.
However, with changes to the vfio iommu code like being able to pre-pin
pages mdev performs better at higher queue use:

        mdev
numjobs
1       505K
2       1037K
4       2375K
8       2162K

note: shadow doorbell support has been enabled.

To create a device create your subsytem, namespace, and port like usual.
Then create a nvmet controller using the previous configfs patch:

Here we create a controller with cntrlid 1 under port 1:

mkdir .../nvmet/ports/1/static_controllers/1

You then set the type:

echo mdev-pci > .../nvmet/ports/1/static_controllers/1/trtype

Enable shadow doorbell support:

echo 1 > .../nvmet/ports/1/static_controllers/1/shadow_doorbell

and instead of linking the subsys to the old dir, you use the
controller's dir:

ln -s ...nvmet/subsystems/nqn.my.subsys \
...nvmet/ports/1/static_controllers/1/subsystem/nqn.my.subsys"

You then enable the controller:

echo 1 > .../nvmet/ports/1/static_controllers/1/enable

You can then create the mdev device via:

UUID=$(uuidgen)
echo $UUID > /sys/devices/nvmet_mdev_pci/port-1/dev_supported_types/ \
nvmet_mdev_pci-1/create

and pass the mdev device to qemu like:

qemu-system-x86_64 ..... \
-device vfio-pci,sysfsdev=/sys/bus/mdev/devices/$UUID

Note: there is a bug with iommufd which I'm working on so the old
style is used here.

This version of the driver is very unstable. You can do IO, but there
are several TODO items:

1. Decide the interface (driver specific sysfs like pci-epf vs
configfs).
2. Fix interface initiated removal bugs.
3. Add support for DSM.
4. Fix polling support.
5. More integration with nvmet core (more cc and csts integration)
and possibly pci-epf.
6. Pre-pin pages to improve perf or modify the iommu code.
7. volatile use cleanup.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/target/Kconfig             |  11 +
 drivers/nvme/target/Makefile            |   1 +
 drivers/nvme/target/mdev-pci/Makefile   |   5 +
 drivers/nvme/target/mdev-pci/instance.c | 818 ++++++++++++++++++++++++
 drivers/nvme/target/mdev-pci/io.c       | 332 ++++++++++
 drivers/nvme/target/mdev-pci/irq.c      | 269 ++++++++
 drivers/nvme/target/mdev-pci/mmio.c     | 561 ++++++++++++++++
 drivers/nvme/target/mdev-pci/pci.c      | 241 +++++++
 drivers/nvme/target/mdev-pci/priv.h     | 487 ++++++++++++++
 drivers/nvme/target/mdev-pci/target.c   | 284 ++++++++
 drivers/nvme/target/mdev-pci/udata.c    | 304 +++++++++
 drivers/nvme/target/mdev-pci/vcq.c      | 160 +++++
 drivers/nvme/target/mdev-pci/vctrl.c    | 260 ++++++++
 drivers/nvme/target/mdev-pci/viommu.c   | 308 +++++++++
 drivers/nvme/target/mdev-pci/vsq.c      | 175 +++++
 15 files changed, 4216 insertions(+)
 create mode 100644 drivers/nvme/target/mdev-pci/Makefile
 create mode 100644 drivers/nvme/target/mdev-pci/instance.c
 create mode 100644 drivers/nvme/target/mdev-pci/io.c
 create mode 100644 drivers/nvme/target/mdev-pci/irq.c
 create mode 100644 drivers/nvme/target/mdev-pci/mmio.c
 create mode 100644 drivers/nvme/target/mdev-pci/pci.c
 create mode 100644 drivers/nvme/target/mdev-pci/priv.h
 create mode 100644 drivers/nvme/target/mdev-pci/target.c
 create mode 100644 drivers/nvme/target/mdev-pci/udata.c
 create mode 100644 drivers/nvme/target/mdev-pci/vcq.c
 create mode 100644 drivers/nvme/target/mdev-pci/vctrl.c
 create mode 100644 drivers/nvme/target/mdev-pci/viommu.c
 create mode 100644 drivers/nvme/target/mdev-pci/vsq.c

diff --git a/drivers/nvme/target/Kconfig b/drivers/nvme/target/Kconfig
index fb7446d6d682..7e8c64f61486 100644
--- a/drivers/nvme/target/Kconfig
+++ b/drivers/nvme/target/Kconfig
@@ -94,6 +94,17 @@ config NVME_TARGET_TCP
 
 	  If unsure, say N.
 
+config NVME_TARGET_MDEV_PCI
+	tristate "NVMe MDEV VFIO PCI target support"
+	select VFIO
+	select VFIO_MDEV
+	depends on NVME_TARGET
+	help
+	  This enables the NVMe MDEV VFIO PCI target support, which allows
+	  exporting NVMe PCI devices using VFIO.
+
+	  If unsure, say N.
+
 config NVME_TARGET_TCP_TLS
 	bool "NVMe over Fabrics TCP target TLS encryption support"
 	depends on NVME_TARGET_TCP
diff --git a/drivers/nvme/target/Makefile b/drivers/nvme/target/Makefile
index ed8522911d1f..369dab7a03f5 100644
--- a/drivers/nvme/target/Makefile
+++ b/drivers/nvme/target/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_NVME_TARGET_FC)		+= nvmet-fc.o
 obj-$(CONFIG_NVME_TARGET_FCLOOP)	+= nvme-fcloop.o
 obj-$(CONFIG_NVME_TARGET_TCP)		+= nvmet-tcp.o
 obj-$(CONFIG_NVME_TARGET_PCI_EPF)	+= nvmet-pci-epf.o
+obj-$(CONFIG_NVME_TARGET_MDEV_PCI)	+= mdev-pci/
 
 nvmet-y		+= core.o configfs.o admin-cmd.o fabrics-cmd.o \
 			discovery.o io-cmd-file.o io-cmd-bdev.o pr.o
diff --git a/drivers/nvme/target/mdev-pci/Makefile b/drivers/nvme/target/mdev-pci/Makefile
new file mode 100644
index 000000000000..03cc34b13e07
--- /dev/null
+++ b/drivers/nvme/target/mdev-pci/Makefile
@@ -0,0 +1,5 @@
+
+obj-$(CONFIG_NVME_TARGET_MDEV_PCI) 	+= nvmet-mdev-pci.o
+
+nvmet-mdev-pci-y += instance.o target.o io.o irq.o udata.o viommu.o vsq.o \
+			vcq.o vctrl.o mmio.o pci.o
diff --git a/drivers/nvme/target/mdev-pci/instance.c b/drivers/nvme/target/mdev-pci/instance.c
new file mode 100644
index 000000000000..c14bcf47c409
--- /dev/null
+++ b/drivers/nvme/target/mdev-pci/instance.c
@@ -0,0 +1,818 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Mediated NVMe instance VFIO code
+ * Copyright (c) 2019 - Maxim Levitsky
+ * Copyright (C) 2025 Oracle Corporation
+ */
+
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/vfio.h>
+#include <linux/sysfs.h>
+#include <linux/mdev.h>
+#include "../../../vfio/vfio.h"
+#include "../nvmet.h"
+#include "priv.h"
+
+#define OFFSET_TO_REGION(offset) ((offset) >> 20)
+#define REGION_TO_OFFSET(nr) (((u64)nr) << 20)
+
+#define NVMET_MDEV_NAME "nvmet_mdev_pci"
+
+static struct device *nvmet_mdev_root_dev;
+
+struct mdev_nvme_vfio_region_info {
+	struct vfio_region_info base;
+	struct vfio_region_info_cap_sparse_mmap mmap_cap;
+};
+
+/* User memory removed */
+static void nvmet_mdev_dma_unmap(struct vfio_device *vfio_dev, u64 iova,
+				 u64 length)
+{
+	struct nvmet_mdev_vctrl *vctrl = vfio_dev_to_nvmet_mdev_vctrl(vfio_dev);
+
+	mutex_lock(&vctrl->lock);
+	/*
+	 * TODO: This cannot be run while the device is in use.
+	 */
+	nvmet_mdev_vctrl_viommu_unmap(vctrl, iova, length);
+	mutex_unlock(&vctrl->lock);
+}
+
+/* Helper function for bar/pci config read/write access */
+static ssize_t nvmet_mdev_access(struct nvmet_mdev_vctrl *vctrl,
+				 char *buf, size_t count,
+				 loff_t pos, bool is_write)
+{
+	int index = OFFSET_TO_REGION(pos);
+	int ret = -EINVAL;
+	unsigned int offset;
+
+	if (index >= VFIO_PCI_NUM_REGIONS || !vctrl->regions[index].rw)
+		goto out;
+
+	offset = pos - REGION_TO_OFFSET(index);
+	if (offset + count > vctrl->regions[index].size)
+		goto out;
+
+	ret = vctrl->regions[index].rw(vctrl, offset, buf, count, is_write);
+out:
+	return ret;
+}
+
+/* Called when read() is done on the device */
+static ssize_t nvmet_mdev_read(struct vfio_device *vfio_dev, char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	struct nvmet_mdev_vctrl *vctrl = vfio_dev_to_nvmet_mdev_vctrl(vfio_dev);
+	unsigned int done = 0;
+	int ret;
+
+	while (count) {
+		size_t filled;
+
+		if (count >= 4 && !(*ppos % 4)) {
+			u32 val;
+
+			ret = nvmet_mdev_access(vctrl, (char *)&val,
+						sizeof(val), *ppos, false);
+			if (ret <= 0)
+				goto read_err;
+
+			if (copy_to_user(buf, &val, sizeof(val)))
+				goto read_err;
+			filled = sizeof(val);
+		} else if (count >= 2 && !(*ppos % 2)) {
+			u16 val;
+
+			ret = nvmet_mdev_access(vctrl, (char *)&val,
+						sizeof(val), *ppos, false);
+			if (ret <= 0)
+				goto read_err;
+			if (copy_to_user(buf, &val, sizeof(val)))
+				goto read_err;
+			filled = sizeof(val);
+		} else {
+			u8 val;
+
+			ret = nvmet_mdev_access(vctrl, (char *)&val,
+						sizeof(val), *ppos, false);
+			if (ret <= 0)
+				goto read_err;
+			if (copy_to_user(buf, &val, sizeof(val)))
+				goto read_err;
+			filled = sizeof(val);
+		}
+
+		count -= filled;
+		done += filled;
+		*ppos += filled;
+		buf += filled;
+	}
+	return done;
+read_err:
+	return -EFAULT;
+}
+
+/* Called when write() is done on the device */
+static ssize_t nvmet_mdev_write(struct vfio_device *vfio_dev,
+				const char __user *buf, size_t count,
+				loff_t *ppos)
+{
+	struct nvmet_mdev_vctrl *vctrl = vfio_dev_to_nvmet_mdev_vctrl(vfio_dev);
+	unsigned int done = 0;
+	int ret;
+
+	while (count) {
+		size_t filled;
+
+		if (count >= 4 && !(*ppos % 4)) {
+			u32 val;
+
+			if (copy_from_user(&val, buf, sizeof(val)))
+				goto write_err;
+			ret = nvmet_mdev_access(vctrl, (char *)&val,
+						sizeof(val), *ppos, true);
+			if (ret <= 0)
+				goto write_err;
+			filled = sizeof(val);
+		} else if (count >= 2 && !(*ppos % 2)) {
+			u16 val;
+
+			if (copy_from_user(&val, buf, sizeof(val)))
+				goto write_err;
+
+			ret = nvmet_mdev_access(vctrl, (char *)&val,
+						sizeof(val), *ppos, true);
+			if (ret <= 0)
+				goto write_err;
+			filled = sizeof(val);
+		} else {
+			u8 val;
+
+			if (copy_from_user(&val, buf, sizeof(val)))
+				goto write_err;
+			ret = nvmet_mdev_access(vctrl, (char *)&val,
+						sizeof(val), *ppos, true);
+			if (ret <= 0)
+				goto write_err;
+			filled = sizeof(val);
+		}
+		count -= filled;
+		done += filled;
+		*ppos += filled;
+		buf += filled;
+	}
+	return done;
+write_err:
+	return -EFAULT;
+}
+
+/* Helper for IRQ number VFIO query */
+static int nvmet_mdev_irq_counts(struct nvmet_mdev_vctrl *vctrl,
+				 unsigned int irq_type)
+{
+	switch (irq_type) {
+	case VFIO_PCI_INTX_IRQ_INDEX:
+		return 1;
+	case VFIO_PCI_MSIX_IRQ_INDEX:
+		return MAX_VIRTUAL_IRQS;
+	case VFIO_PCI_REQ_IRQ_INDEX:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+/* VFIO VFIO_IRQ_SET_ACTION_TRIGGER implementation */
+static int nvmet_mdev_ioctl_set_irqs_trigger(struct nvmet_mdev_vctrl *vctrl,
+					     u32 flags,
+					     unsigned int irq_type,
+					     unsigned int start,
+					     unsigned int count,
+					     void *data)
+{
+	u32 data_type = flags & VFIO_IRQ_SET_DATA_TYPE_MASK;
+	u8 *bools = NULL;
+	unsigned int i;
+	int ret = -EINVAL;
+
+	/* Asked to disable the current interrupt mode */
+	if (data_type == VFIO_IRQ_SET_DATA_NONE && count == 0) {
+		switch (irq_type) {
+		case VFIO_PCI_REQ_IRQ_INDEX:
+			nvmet_mdev_irqs_set_unplug_trigger(vctrl, -1);
+			return 0;
+		case VFIO_PCI_INTX_IRQ_INDEX:
+			nvmet_mdev_irqs_disable(vctrl, NVME_MDEV_IMODE_INTX);
+			return 0;
+		case VFIO_PCI_MSIX_IRQ_INDEX:
+			nvmet_mdev_irqs_disable(vctrl, NVME_MDEV_IMODE_MSIX);
+			return 0;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	if (start + count > nvmet_mdev_irq_counts(vctrl, irq_type))
+		return -EINVAL;
+
+	switch (data_type) {
+	case VFIO_IRQ_SET_DATA_BOOL:
+		bools = (u8 *)data;
+		fallthrough;
+	case VFIO_IRQ_SET_DATA_NONE:
+		if (irq_type == VFIO_PCI_REQ_IRQ_INDEX)
+			return -EINVAL;
+
+		for (i = 0 ; i < count ; i++) {
+			int index = start + i;
+
+			if (!bools || bools[i])
+				nvmet_mdev_irq_trigger(vctrl, index);
+		}
+		return 0;
+
+	case VFIO_IRQ_SET_DATA_EVENTFD:
+		switch (irq_type) {
+		case VFIO_PCI_REQ_IRQ_INDEX:
+			return nvmet_mdev_irqs_set_unplug_trigger(vctrl,
+							*(int32_t *)data);
+		case VFIO_PCI_INTX_IRQ_INDEX:
+			ret = nvmet_mdev_irqs_enable(vctrl,
+						     NVME_MDEV_IMODE_INTX);
+			break;
+		case VFIO_PCI_MSIX_IRQ_INDEX:
+			ret = nvmet_mdev_irqs_enable(vctrl,
+						     NVME_MDEV_IMODE_MSIX);
+			break;
+		default:
+			return -EINVAL;
+		}
+		if (ret)
+			return ret;
+
+		return nvmet_mdev_irqs_set_triggers(vctrl, start, count,
+						    (int32_t *)data);
+	default:
+		return -EINVAL;
+	}
+}
+
+/* VFIO_DEVICE_GET_INFO ioctl implementation */
+static int nvmet_mdev_ioctl_get_info(struct nvmet_mdev_vctrl *vctrl,
+				     void __user *arg)
+{
+	struct vfio_device_info info;
+	unsigned int minsz = offsetofend(struct vfio_device_info, num_irqs);
+
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	info.flags = VFIO_DEVICE_FLAGS_PCI | VFIO_DEVICE_FLAGS_RESET;
+	info.num_regions = VFIO_PCI_NUM_REGIONS;
+	info.num_irqs = VFIO_PCI_NUM_IRQS;
+
+	if (copy_to_user(arg, &info, minsz))
+		return -EFAULT;
+	return 0;
+}
+
+/* VFIO_DEVICE_GET_REGION_INFO ioctl implementation */
+static int nvmet_mdev_ioctl_get_reg_info(struct nvmet_mdev_vctrl *vctrl,
+					 void __user *arg)
+{
+	struct nvmet_mdev_io_region *region;
+	struct mdev_nvme_vfio_region_info *info;
+	unsigned long minsz, outsz, maxsz;
+	int ret = 0;
+
+	minsz = offsetofend(struct vfio_region_info, offset);
+	maxsz = sizeof(struct mdev_nvme_vfio_region_info) +
+				sizeof(struct vfio_region_sparse_mmap_area);
+
+	info = kzalloc(maxsz, GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	if (copy_from_user(info, arg, minsz)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	outsz = info->base.argsz;
+	if (outsz < minsz || outsz > maxsz) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (info->base.index >= VFIO_PCI_NUM_REGIONS) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	region = &vctrl->regions[info->base.index];
+	info->base.offset = REGION_TO_OFFSET(info->base.index);
+	info->base.argsz = maxsz;
+	info->base.size = region->size;
+
+	info->base.flags = VFIO_REGION_INFO_FLAG_READ |
+				VFIO_REGION_INFO_FLAG_WRITE;
+
+	if (region->mmap_ops) {
+		info->base.flags |= (VFIO_REGION_INFO_FLAG_MMAP |
+						VFIO_REGION_INFO_FLAG_CAPS);
+
+		info->base.cap_offset =
+			offsetof(struct mdev_nvme_vfio_region_info, mmap_cap);
+
+		info->mmap_cap.header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+		info->mmap_cap.header.version = 1;
+		info->mmap_cap.header.next = 0;
+		info->mmap_cap.nr_areas = 1;
+		info->mmap_cap.areas[0].offset = region->mmap_area_start;
+		info->mmap_cap.areas[0].size = region->mmap_area_size;
+	}
+
+	if (copy_to_user(arg, info, outsz))
+		ret = -EFAULT;
+out:
+	kfree(info);
+	return ret;
+}
+
+/* VFIO_DEVICE_GET_IRQ_INFO ioctl implementation */
+static int nvmet_mdev_ioctl_get_irq_info(struct nvmet_mdev_vctrl *vctrl,
+					 void __user *arg)
+{
+	struct vfio_irq_info info;
+	unsigned int minsz = offsetofend(struct vfio_irq_info, count);
+
+	if (copy_from_user(&info, arg, minsz))
+		return -EFAULT;
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	info.count = nvmet_mdev_irq_counts(vctrl, info.index);
+	info.flags = VFIO_IRQ_INFO_EVENTFD;
+
+	if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
+		info.flags |= VFIO_IRQ_INFO_MASKABLE | VFIO_IRQ_INFO_AUTOMASKED;
+
+	if (copy_to_user(arg, &info, minsz))
+		return -EFAULT;
+	return 0;
+}
+
+/* VFIO VFIO_DEVICE_SET_IRQS ioctl implementation */
+static int nvmet_mdev_ioctl_set_irqs(struct nvmet_mdev_vctrl *vctrl,
+				     void __user *arg)
+{
+	int ret, irqcount;
+	struct vfio_irq_set hdr;
+	u8 *data = NULL;
+	size_t data_size = 0;
+	unsigned long minsz = offsetofend(struct vfio_irq_set, count);
+
+	if (copy_from_user(&hdr, arg, minsz))
+		return -EFAULT;
+
+	irqcount = nvmet_mdev_irq_counts(vctrl, hdr.index);
+	ret = vfio_set_irqs_validate_and_prepare(&hdr,
+						 irqcount,
+						 VFIO_PCI_NUM_IRQS,
+						 &data_size);
+	if (ret)
+		return ret;
+
+	if (data_size) {
+		data = memdup_user((arg + minsz), data_size);
+		if (IS_ERR(data))
+			return PTR_ERR(data);
+	}
+
+	ret = -ENOTTY;
+	switch (hdr.index) {
+	case VFIO_PCI_INTX_IRQ_INDEX:
+	case VFIO_PCI_MSIX_IRQ_INDEX:
+	case VFIO_PCI_REQ_IRQ_INDEX:
+		switch (hdr.flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_MASK:
+		case VFIO_IRQ_SET_ACTION_UNMASK:
+			/* pretend to support this (even with eventfd) */
+			ret = hdr.index == VFIO_PCI_INTX_IRQ_INDEX ?
+					0 : -EINVAL;
+			break;
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			ret = nvmet_mdev_ioctl_set_irqs_trigger(vctrl,
+								hdr.flags,
+								hdr.index,
+								hdr.start,
+								hdr.count,
+								data);
+			break;
+		}
+		break;
+	}
+
+	kfree(data);
+	return ret;
+}
+
+static long nvmet_mdev_ioctl(struct vfio_device *vfio_dev, unsigned int cmd,
+			     unsigned long arg)
+{
+	struct nvmet_mdev_vctrl *vctrl = vfio_dev_to_nvmet_mdev_vctrl(vfio_dev);
+
+	switch (cmd) {
+	case VFIO_DEVICE_GET_INFO:
+		return nvmet_mdev_ioctl_get_info(vctrl, (void __user *)arg);
+	case VFIO_DEVICE_GET_REGION_INFO:
+		return nvmet_mdev_ioctl_get_reg_info(vctrl, (void __user *)arg);
+	case VFIO_DEVICE_GET_IRQ_INFO:
+		return nvmet_mdev_ioctl_get_irq_info(vctrl, (void __user *)arg);
+	case VFIO_DEVICE_SET_IRQS:
+		return nvmet_mdev_ioctl_set_irqs(vctrl, (void __user *)arg);
+	case VFIO_DEVICE_RESET:
+		nvmet_mdev_vctrl_reset(vctrl);
+		return 0;
+	default:
+		return -ENOTTY;
+	}
+}
+
+/* mmap() implementation (doorbell area) */
+static int nvmet_mdev_mmap(struct vfio_device *vfio_dev,
+			   struct vm_area_struct *vma)
+{
+	struct nvmet_mdev_vctrl *vctrl = vfio_dev_to_nvmet_mdev_vctrl(vfio_dev);
+	int index = OFFSET_TO_REGION((u64)vma->vm_pgoff << PAGE_SHIFT);
+	unsigned long size, start;
+
+	if (index >= VFIO_PCI_NUM_REGIONS || !vctrl->regions[index].mmap_ops)
+		return -EINVAL;
+
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+
+	size = vma->vm_end - vma->vm_start;
+	start = vma->vm_pgoff << PAGE_SHIFT;
+
+	if (start < vctrl->regions[index].mmap_area_start)
+		return -EINVAL;
+	if (size > vctrl->regions[index].mmap_area_size)
+		return -EINVAL;
+
+	if ((vma->vm_flags & VM_SHARED) == 0)
+		return -EINVAL;
+
+	vma->vm_ops = vctrl->regions[index].mmap_ops;
+	vma->vm_private_data = vctrl;
+	return 0;
+}
+
+static const struct vfio_device_ops nvme_vfio_dev_ops = {
+	.open_device		= nvmet_mdev_vctrl_open,
+	.close_device		= nvmet_mdev_vctrl_release,
+	.read			= nvmet_mdev_read,
+	.write			= nvmet_mdev_write,
+	.mmap			= nvmet_mdev_mmap,
+	.ioctl			= nvmet_mdev_ioctl,
+	.dma_unmap		= nvmet_mdev_dma_unmap,
+	.bind_iommufd		= vfio_iommufd_emulated_bind,
+	.unbind_iommufd		= vfio_iommufd_emulated_unbind,
+	.attach_ioas		= vfio_iommufd_emulated_attach_ioas,
+	.detach_ioas		= vfio_iommufd_emulated_detach_ioas,
+};
+
+/* Called when new mediated device is created */
+static int nvmet_mdev_probe(struct mdev_device *mdev)
+{
+	struct nvmet_mdev_port *mport = container_of(mdev->type->parent,
+						     struct nvmet_mdev_port,
+						     parent);
+	struct nvmet_mdev_vctrl *vctrl;
+	struct nvmet_ctrl *ctrl;
+	u16 cntlid;
+	int ret;
+
+	ret = kstrtou16(mdev->type->sysfs_name, 10, &cntlid);
+	if (ret)
+		return -EINVAL;
+
+	mutex_lock(&mport->mutex);
+	/* Release the refcount taken on the ctrl at remove. */
+	ctrl = nvmet_find_get_static_ctrl(mport->nvmet_port,
+					  nvmet_mdev_ops.type, cntlid);
+	if (!ctrl) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
+	vctrl = vfio_alloc_device(nvmet_mdev_vctrl, vfio_dev, &mdev->dev,
+				  &nvme_vfio_dev_ops);
+	if (IS_ERR(vctrl)) {
+		ret = PTR_ERR(vctrl);
+		goto put_ctrl;
+	}
+
+	vctrl->nvmet_ctrl = ctrl;
+	ctrl->drvdata = vctrl;
+	dev_set_drvdata(&mdev->dev, vctrl);
+
+	ret = vfio_register_emulated_iommu_dev(&vctrl->vfio_dev);
+	if (ret)
+		goto put_vfio_dev;
+
+	ret = nvmet_mdev_vctrl_create(vctrl, mdev);
+	if (ret)
+		goto unreg_vfio_dev;
+
+	mutex_unlock(&mport->mutex);
+	return 0;
+
+unreg_vfio_dev:
+	vfio_unregister_group_dev(&vctrl->vfio_dev);
+put_vfio_dev:
+	vfio_put_device(&vctrl->vfio_dev);
+put_ctrl:
+	nvmet_ctrl_put(ctrl);
+unlock:
+	mutex_unlock(&mport->mutex);
+	return ret;
+}
+
+/*
+ * TODO handle if this is called while opened.
+ *
+ * Depending on if we go with configfs based setup we can get a refcount to
+ * the conifgfs objects to prevent them from being removed while in use.
+ * However, the mdev bus hotplug removal cannot be stopped right now
+ * but we may want to modify it to just not allow it.
+ */
+void nvmet_mdev_remove_ctrl(struct nvmet_mdev_vctrl *vctrl)
+{
+	struct nvmet_ctrl *ctrl;
+
+	if (!vctrl)
+		return;
+
+	ctrl = vctrl->nvmet_ctrl;
+	if (!ctrl)
+		return;
+
+	nvmet_mdev_irq_raise_unplug_event(vctrl);
+	nvmet_mdev_vctrl_destroy(vctrl);
+
+	dev_set_drvdata(vctrl->vfio_dev.dev, vctrl);
+	vctrl->nvmet_ctrl = NULL;
+	ctrl->drvdata = NULL;
+
+	vfio_unregister_group_dev(&vctrl->vfio_dev);
+	vfio_put_device(&vctrl->vfio_dev);
+
+	if (ctrl)
+		nvmet_ctrl_put(ctrl);
+}
+
+/* Called when a mediated device is removed via sysfs or parent removal */
+static void nvmet_mdev_remove(struct mdev_device *mdev)
+{
+	struct nvmet_mdev_port *mport = container_of(mdev->type->parent,
+						     struct nvmet_mdev_port,
+						     parent);
+
+	mutex_lock(&mport->mutex);
+	nvmet_mdev_remove_ctrl(dev_get_drvdata(&mdev->dev));
+	mutex_unlock(&mport->mutex);
+}
+
+static unsigned int nvmet_mdev_get_available(struct mdev_type *mtype)
+{
+	/* No limit since nvmet does not restrict it either */
+	return UINT_MAX;
+}
+
+static ssize_t poll_timeout_ms_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct nvmet_mdev_vctrl *vctrl = dev_get_drvdata(dev);
+	int ret;
+
+	if (!vctrl)
+		return -ENODEV;
+
+	ret = kstrtoint(buf, 10, &vctrl->poll_timeout_ms);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static ssize_t poll_timeout_ms_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvmet_mdev_vctrl *vctrl = dev_get_drvdata(dev);
+
+	if (!vctrl)
+		return -ENODEV;
+
+	return sysfs_emit(buf, "%d\n", vctrl->poll_timeout_ms);
+}
+static DEVICE_ATTR_RW(poll_timeout_ms);
+
+static struct attribute *nvmet_mdev_dev_settings_atttributes[] = {
+	&dev_attr_poll_timeout_ms.attr,
+	NULL
+};
+
+static const struct attribute_group nvmet_mdev_setting_attr_group = {
+	.name = "settings",
+	.attrs = nvmet_mdev_dev_settings_atttributes,
+};
+
+static const struct attribute_group *nvmet_mdev_dev_attr_groups[] = {
+	&nvmet_mdev_setting_attr_group,
+	NULL,
+};
+
+static struct mdev_driver nvmet_mdev_driver = {
+	.device_api		= VFIO_DEVICE_API_PCI_STRING,
+	.driver = {
+		.name		= NVMET_MDEV_NAME,
+		.owner		= THIS_MODULE,
+		.dev_groups	= nvmet_mdev_dev_attr_groups,
+	},
+	.probe			= nvmet_mdev_probe,
+	.remove			= nvmet_mdev_remove,
+	.get_available		= nvmet_mdev_get_available,
+};
+
+static const struct bus_type nvmet_mdev_bus = {
+	.name		= NVMET_MDEV_NAME,
+};
+
+static void nvmet_mdev_destroy_types(struct nvmet_mdev_port *mport)
+{
+	int i;
+
+	for (i = 0; i < mport->type_count; i++)
+		kfree(mport->types[i].name);
+}
+
+static int nvmet_mdev_setup_types(void *priv, struct nvmet_port *port,
+				  struct nvmet_ctrl *ctrl)
+{
+	struct nvmet_mdev_port *mport = priv;
+	struct nvmet_mdev_type *type;
+
+	if (mport->type_count == mport->ctrl_count) {
+		pr_err("Invalid number of controllers found %d\n",
+		       mport->ctrl_count);
+		return -EINVAL;
+	}
+
+	type = &mport->types[mport->type_count];
+	type->name = kasprintf(GFP_KERNEL, "%hu", ctrl->cntlid);
+	if (!type->name)
+		return -ENOMEM;
+
+	mport->mdev_types[mport->type_count] = &type->type;
+	mport->mdev_types[mport->type_count]->sysfs_name = type->name;
+
+	mport->type_count++;
+	return 0;
+}
+
+static void nvmet_mdev_dev_release(struct device *dev)
+{
+	struct nvmet_mdev_port *mport = container_of(dev,
+						     struct nvmet_mdev_port,
+						     device);
+	nvmet_mdev_destroy_types(mport);
+	kfree(mport->types);
+	kfree(mport->mdev_types);
+	kfree(mport);
+}
+
+int nvmet_mdev_register_port(struct nvmet_mdev_port *mport)
+{
+	int ret;
+
+	mport->types = kcalloc(mport->ctrl_count, sizeof(*mport->types),
+			       GFP_KERNEL);
+	if (!mport->types)
+		return -ENOMEM;
+
+	mport->mdev_types = kcalloc(mport->ctrl_count,
+				    sizeof(*mport->mdev_types), GFP_KERNEL);
+	if (!mport->mdev_types) {
+		ret = -ENOMEM;
+		goto free_types;
+	}
+
+	ret = nvmet_for_each_static_ctrl(mport->nvmet_port, nvmet_mdev_ops.type,
+					 nvmet_mdev_setup_types, mport);
+	if (ret)
+		/* we might have partially setup the types arrays */
+		goto destroy_types;
+
+	mport->device.parent = nvmet_mdev_root_dev;
+	mport->device.bus = &nvmet_mdev_bus;
+	mport->device.release = nvmet_mdev_dev_release;
+	dev_set_name(&mport->device, "port-%s",
+		     config_item_name(&mport->nvmet_port->group.cg_item));
+
+	ret = device_register(&mport->device);
+	if (ret)
+		goto free_mdev_types;
+
+	ret = mdev_register_parent(&mport->parent, &mport->device,
+				   &nvmet_mdev_driver, mport->mdev_types,
+				   mport->type_count);
+	if (ret)
+		goto unreg_dev;
+
+	return 0;
+
+unreg_dev:
+	device_unregister(&mport->device);
+destroy_types:
+	nvmet_mdev_destroy_types(mport);
+free_mdev_types:
+	kfree(mport->mdev_types);
+free_types:
+	kfree(mport->types);
+	return ret;
+}
+
+void nvmet_mdev_unregister_port(struct nvmet_mdev_port *mport)
+{
+	mdev_unregister_parent(&mport->parent);
+	device_unregister(&mport->device);
+}
+
+static int nvmet_mdev_register_root_device(void)
+{
+	int ret;
+
+	nvmet_mdev_root_dev = root_device_register(NVMET_MDEV_NAME);
+	if (IS_ERR(nvmet_mdev_root_dev))
+		return PTR_ERR(nvmet_mdev_root_dev);
+
+	ret = bus_register(&nvmet_mdev_bus);
+	if (ret)
+		goto unreg_root;
+
+	nvmet_unregister_transport(&nvmet_mdev_ops);
+	return 0;
+
+unreg_root:
+	root_device_unregister(nvmet_mdev_root_dev);
+	return ret;
+}
+
+static void nvmet_mdev_unregister_root_device(void)
+{
+	root_device_unregister(nvmet_mdev_root_dev);
+	bus_unregister(&nvmet_mdev_bus);
+}
+
+static int __init nvmet_mdev_init(void)
+{
+	int ret;
+
+	ret = nvmet_mdev_register_root_device();
+	if (ret)
+		return ret;
+
+	ret = mdev_register_driver(&nvmet_mdev_driver);
+	if (ret)
+		goto unreg_root;
+
+	ret = nvmet_register_transport(&nvmet_mdev_ops);
+	if (ret)
+		goto unreg_driver;
+
+	return 0;
+
+unreg_driver:
+	mdev_unregister_driver(&nvmet_mdev_driver);
+unreg_root:
+	nvmet_mdev_unregister_root_device();
+	return ret;
+}
+
+static void __exit nvmet_mdev_exit(void)
+{
+	nvmet_unregister_transport(&nvmet_mdev_ops);
+	nvmet_mdev_unregister_root_device();
+	mdev_unregister_driver(&nvmet_mdev_driver);
+}
+
+module_init(nvmet_mdev_init);
+module_exit(nvmet_mdev_exit);
diff --git a/drivers/nvme/target/mdev-pci/io.c b/drivers/nvme/target/mdev-pci/io.c
new file mode 100644
index 000000000000..ece3a01434ac
--- /dev/null
+++ b/drivers/nvme/target/mdev-pci/io.c
@@ -0,0 +1,332 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * NVMe IO command translation and polling IO thread
+ * Copyright (c) 2019 - Maxim Levitsky
+ * Copyright (C) 2025 Oracle Corporation
+ */
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/slab.h>
+#include <linux/nvme.h>
+#include <linux/timekeeping.h>
+#include <linux/ktime.h>
+#include <linux/delay.h>
+#include "priv.h"
+
+static int nvmet_mdev_create_sgl(struct nvmet_mdev_req *mreq, u64 data_len,
+				 const struct nvme_command *cmd)
+{
+	struct nvmet_ext_data_iter *iter = &mreq->data_iter;
+	struct nvmet_req *req = &mreq->req;
+	struct scatterlist *sg;
+	int i, ret;
+
+	ret = nvmet_mdev_udata_iter_set_dptr(&mreq->data_iter,
+					     &cmd->common.dptr, data_len);
+	if (ret)
+		return ret;
+
+	ret = sg_alloc_table(&mreq->sgt, iter->count, GFP_KERNEL);
+	if (ret)
+		return ret;
+
+	for_each_sgtable_sg(&mreq->sgt, sg, i) {
+		int seg_len = min(PAGE_SIZE, data_len);
+		struct page *page;
+		int offset;
+
+		page = pfn_to_page(PHYS_PFN(iter->physical));
+		offset = offset_in_page(iter->physical);
+
+		sg_set_page(sg, page, seg_len, offset);
+
+		ret = iter->next(iter);
+		if (WARN_ON(ret))
+			goto release_iter;
+		data_len -= seg_len;
+	}
+
+	req->sg = mreq->sgt.sgl;
+	req->sg_cnt = mreq->sgt.nents;
+	return 0;
+
+release_iter:
+	if (iter->release)
+		iter->release(iter);
+
+	sg_free_table(&mreq->sgt);
+	return ret;
+}
+
+static bool nvmet_mdev_submit_cmd(struct nvmet_mdev_vctrl *vctrl,
+				  struct nvmet_mdev_vsq *vsq)
+{
+	struct nvmet_mdev_vcq *vcq = vsq->vcq;
+	struct nvme_completion cqe = {};
+	struct nvmet_mdev_req *mreq;
+	struct nvme_command *cmd;
+	struct nvmet_req *req;
+	u16 ucid;
+	int ret;
+
+	cmd = nvmet_mdev_vsq_get_cmd(vctrl, vsq, &ucid);
+	if (!cmd)
+		return false;
+
+	if (ucid >= vsq->size) {
+		ret = DNR(NVME_SC_INVALID_FIELD);
+		goto complete;
+	}
+
+	if (cmd->common.flags != 0) {
+		ret = DNR(NVME_SC_INVALID_FIELD);
+		goto complete;
+	}
+
+	mreq = &vsq->reqs[ucid];
+	memset(mreq, 0, sizeof(*mreq));
+
+	INIT_LIST_HEAD(&mreq->mem_map_list);
+	nvmet_mdev_udata_iter_setup(&vctrl->viommu, &mreq->data_iter,
+				    &mreq->mem_map_list);
+	init_llist_node(&mreq->cq_node);
+	mreq->vcq = vcq;
+
+	req = &mreq->req;
+	req->cmd = cmd;
+	req->cqe = &mreq->cqe;
+	req->port = vctrl->nvmet_ctrl->port;
+
+	if (!nvmet_req_init(req, &vcq->nvmet_cq, &vsq->nvmet_sq,
+			    &nvmet_mdev_ops)) {
+		vctrl->expected_responses++;
+		/* nvmet will complete via queue_response */
+		return true;
+	}
+
+	req->transfer_len = nvmet_req_transfer_len(req);
+	if (req->transfer_len) {
+		ret = nvmet_mdev_create_sgl(mreq, req->transfer_len, cmd);
+		if (ret) {
+			ret = nvmet_mdev_translate_error(ret);
+			goto uninit_req;
+		}
+	}
+
+	vctrl->expected_responses++;
+	req->execute(req);
+	return true;
+
+uninit_req:
+	nvmet_req_uninit(req);
+complete:
+	cqe.sq_head = cpu_to_le16(vsq->head);
+	cqe.sq_id = cpu_to_le16(vsq->qid);
+	cqe.command_id = cmd->common.command_id;
+	cqe.status = cpu_to_le16(ret << 1);
+
+	nvmet_mdev_vcq_write_cqe(vctrl, vcq, &cqe);
+	return true;
+}
+
+bool nvmet_mdev_process_responses(struct nvmet_mdev_vctrl *vctrl,
+				  struct nvmet_mdev_vcq *vcq)
+{
+	struct nvmet_mdev_req *mreq, *mreq_next;
+	struct nvmet_ext_data_iter *iter;
+	struct llist_node *node;
+	bool processed = false;
+
+	node = llist_del_all(&vcq->mreq_list);
+	if (!node)
+		return processed;
+
+	llist_for_each_entry_safe(mreq, mreq_next, node, cq_node) {
+		iter = &mreq->data_iter;
+
+		nvmet_mdev_vcq_write_cqe(vctrl, vcq, mreq->req.cqe);
+
+		if (iter->release)
+			iter->release(iter);
+
+		if (mreq->req.sg_cnt)
+			sg_free_table(&mreq->sgt);
+
+		vctrl->expected_responses--;
+		processed = true;
+	}
+
+	return processed;
+}
+
+void nvmet_mdev_io_resume(struct nvmet_mdev_vctrl *vctrl)
+{
+	if (!vctrl->iothread || !vctrl->iothread_parked || vctrl->io_idle)
+		return;
+
+	vctrl->iothread_parked = false;
+	/* has memory barrier */
+	kthread_unpark(vctrl->iothread);
+}
+
+bool nvmet_mdev_io_pause(struct nvmet_mdev_vctrl *vctrl)
+{
+	if (!vctrl->iothread || vctrl->iothread_parked)
+		return false;
+
+	vctrl->iothread_parked = true;
+	kthread_park(vctrl->iothread);
+	return true;
+}
+
+static int nvmet_mdev_get_poll_tmo(struct nvmet_mdev_vctrl *vctrl)
+{
+	/* can't stop polling when shadow db not enabled */
+	return vctrl->mmio.shadow_db_en ? vctrl->poll_timeout_ms : 0;
+}
+
+static void nvmet_mdev_process_io(struct nvmet_mdev_vctrl *vctrl)
+{
+	struct nvmet_mdev_vcq *vcq;
+	struct nvmet_mdev_vsq *vsq;
+	unsigned long last = jiffies;
+	bool idle = false;
+	int timeout;
+	u16 qid;
+	int i;
+
+	vctrl->now = ktime_get();
+
+	/* main loop */
+	while (!kthread_should_park()) {
+		vctrl->now = ktime_get();
+
+		for_each_set_bit(qid, vctrl->vsq_en, NVMET_MDEV_MAX_NR_QUEUES) {
+			vsq = &vctrl->vsqs[qid];
+
+			for (i = 0 ; i < (1 << vctrl->arb_burst_shift) ; i++)
+				if (nvmet_mdev_submit_cmd(vctrl, vsq))
+					last = jiffies;
+		}
+
+		for_each_set_bit(qid, vctrl->vcq_en, NVMET_MDEV_MAX_NR_QUEUES) {
+			vcq = &vctrl->vcqs[qid];
+
+			nvmet_mdev_vcq_process(vctrl, vcq, true, vctrl->now);
+		}
+
+		for_each_set_bit(qid, vctrl->vcq_en, NVMET_MDEV_MAX_NR_QUEUES) {
+			vcq = &vctrl->vcqs[qid];
+
+			if (nvmet_mdev_process_responses(vctrl, vcq))
+				last = jiffies;
+		}
+
+		/* Check if we need to stop polling */
+		timeout = nvmet_mdev_get_poll_tmo(vctrl);
+		if (timeout &&
+		    time_is_before_jiffies(last + msecs_to_jiffies(timeout))) {
+			idle = true;
+			break;
+		}
+		cond_resched();
+	}
+
+	for_each_set_bit(qid, vctrl->vcq_en, NVMET_MDEV_MAX_NR_QUEUES) {
+		vcq = &vctrl->vcqs[qid];
+
+		/* Drain all the pending completion interrupts to the guest */
+		if (nvmet_mdev_vcq_flush(vctrl, vcq, vctrl->now))
+			idle = false;
+	}
+
+	/*
+	 * Park IO thread if IO is truly idle.
+	 * TODO - expected_responses will always be > 1 because of async
+	 * events.
+	 */
+	if (!vctrl->expected_responses && idle) {
+		if (!mutex_trylock(&vctrl->lock))
+			return;
+
+		for_each_set_bit(qid, vctrl->vsq_en, NVMET_MDEV_MAX_NR_QUEUES) {
+			vsq = &vctrl->vsqs[qid];
+
+			if (!nvmet_mdev_vsq_suspend_io(vsq))
+				idle = false;
+		}
+
+		if (idle) {
+			_DBG(vctrl, "IO: self-parking\n");
+			vctrl->io_idle = true;
+			nvmet_mdev_io_pause(vctrl);
+		}
+		mutex_unlock(&vctrl->lock);
+	}
+}
+
+static int nvmet_mdev_poll(void *data)
+{
+	struct nvmet_mdev_vctrl *vctrl = data;
+
+	if (kthread_should_stop())
+		return 0;
+
+	_DBG(vctrl, "IO: iothread started\n");
+
+	for (;;) {
+		if (kthread_should_park()) {
+			_DBG(vctrl, "IO: iothread parked\n");
+			kthread_parkme();
+		}
+
+		if (kthread_should_stop())
+			break;
+
+		nvmet_mdev_process_io(vctrl);
+	}
+
+	_DBG(vctrl, "IO: iothread stopped\n");
+	return 0;
+}
+
+int nvmet_mdev_io_create(struct nvmet_mdev_vctrl *vctrl)
+{
+	char name[TASK_COMM_LEN];
+
+	_DBG(vctrl, "IO: creating the polling iothread\n");
+
+	snprintf(name, sizeof(name), "nvmet_mdev%d", vctrl->nvmet_ctrl->cntlid);
+
+	vctrl->iothread_parked = false;
+	vctrl->io_idle = true;
+
+	vctrl->iothread = kthread_create(nvmet_mdev_poll, vctrl, name);
+	if (IS_ERR(vctrl->iothread)) {
+		vctrl->iothread = NULL;
+		return PTR_ERR(vctrl->iothread);
+	}
+
+	if (vctrl->io_idle) {
+		vctrl->iothread_parked = true;
+		kthread_park(vctrl->iothread);
+		return 0;
+	}
+
+	wake_up_process(vctrl->iothread);
+	return 0;
+}
+
+void nvmet_mdev_io_free(struct nvmet_mdev_vctrl *vctrl)
+{
+	_DBG(vctrl, "IO: destroying the polling iothread\n");
+	nvmet_mdev_io_pause(vctrl);
+	kthread_stop(vctrl->iothread);
+	vctrl->iothread = NULL;
+}
+
+void nvmet_mdev_assert_io_not_running(struct nvmet_mdev_vctrl *vctrl)
+{
+	if (WARN_ON(vctrl->iothread && !vctrl->iothread_parked))
+		nvmet_mdev_io_pause(vctrl);
+}
diff --git a/drivers/nvme/target/mdev-pci/irq.c b/drivers/nvme/target/mdev-pci/irq.c
new file mode 100644
index 000000000000..38a096427dcb
--- /dev/null
+++ b/drivers/nvme/target/mdev-pci/irq.c
@@ -0,0 +1,269 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * NVMe virtual controller IRQ implementation (MSIx and INTx)
+ * Copyright (c) 2019 - Maxim Levitsky
+ */
+
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include "priv.h"
+
+/* Setup the interrupt subsystem */
+void nvmet_mdev_irqs_setup(struct nvmet_mdev_vctrl *vctrl)
+{
+	vctrl->irqs.mode = NVME_MDEV_IMODE_NONE;
+	vctrl->irqs.irq_coalesc_max = 1;
+}
+
+/* Enable INTx or MSIx interrupts  */
+static int __nvmet_mdev_irqs_enable(struct nvmet_mdev_vctrl *vctrl,
+				    enum nvmet_mdev_irq_mode mode)
+{
+	bool paused;
+
+	if (vctrl->irqs.mode == mode)
+		return 0;
+	if (vctrl->irqs.mode != NVME_MDEV_IMODE_NONE)
+		return -EBUSY;
+
+	if (mode == NVME_MDEV_IMODE_INTX)
+		_DBG(vctrl, "IRQ: enable INTx interrupts\n");
+	else if (mode == NVME_MDEV_IMODE_MSIX)
+		_DBG(vctrl, "IRQ: enable MSIX interrupts\n");
+	else
+		WARN_ON(1);
+
+	paused = nvmet_mdev_io_pause(vctrl);
+	vctrl->irqs.mode = mode;
+	if (paused)
+		nvmet_mdev_io_resume(vctrl);
+	return 0;
+}
+
+int nvmet_mdev_irqs_enable(struct nvmet_mdev_vctrl *vctrl,
+			   enum nvmet_mdev_irq_mode mode)
+{
+	int retval;
+
+	mutex_lock(&vctrl->lock);
+	retval = __nvmet_mdev_irqs_enable(vctrl, mode);
+	mutex_unlock(&vctrl->lock);
+	return retval;
+}
+
+/* Disable INTx or MSIx interrupts  */
+static void __nvmet_mdev_irqs_disable(struct nvmet_mdev_vctrl *vctrl,
+				      enum nvmet_mdev_irq_mode mode)
+{
+	unsigned int i;
+	bool paused;
+
+	if (vctrl->irqs.mode == NVME_MDEV_IMODE_NONE)
+		return;
+	if (vctrl->irqs.mode != mode)
+		return;
+
+	if (vctrl->irqs.mode == NVME_MDEV_IMODE_INTX)
+		_DBG(vctrl, "IRQ: disable INTx interrupts\n");
+	else if (vctrl->irqs.mode == NVME_MDEV_IMODE_MSIX)
+		_DBG(vctrl, "IRQ: disable MSIX interrupts\n");
+	else
+		WARN_ON(1);
+
+	paused = nvmet_mdev_io_pause(vctrl);
+
+	for (i = 0; i < MAX_VIRTUAL_IRQS; i++) {
+		struct nvmet_mdev_user_irq *vec = &vctrl->irqs.vecs[i];
+
+		if (vec->trigger) {
+			eventfd_ctx_put(vec->trigger);
+			vec->trigger = NULL;
+		}
+		vec->irq_pending_cnt = 0;
+		vec->irq_time = 0;
+	}
+	vctrl->irqs.mode = NVME_MDEV_IMODE_NONE;
+	if (paused)
+		nvmet_mdev_io_resume(vctrl);
+}
+
+void nvmet_mdev_irqs_disable(struct nvmet_mdev_vctrl *vctrl,
+			     enum nvmet_mdev_irq_mode mode)
+{
+	mutex_lock(&vctrl->lock);
+	__nvmet_mdev_irqs_disable(vctrl, mode);
+	mutex_unlock(&vctrl->lock);
+}
+
+/* Set eventfd triggers for INTx or MSIx interrupts */
+int nvmet_mdev_irqs_set_triggers(struct nvmet_mdev_vctrl *vctrl, int start,
+				 int count, int32_t *fds)
+{
+	unsigned int i;
+	bool paused;
+
+	mutex_lock(&vctrl->lock);
+	paused = nvmet_mdev_io_pause(vctrl);
+
+	for (i = 0; i < count; i++) {
+		int irqindex = start + i;
+		struct eventfd_ctx *trigger;
+		struct nvmet_mdev_user_irq *irq = &vctrl->irqs.vecs[irqindex];
+
+		if (irq->trigger) {
+			eventfd_ctx_put(irq->trigger);
+			irq->trigger = NULL;
+		}
+
+		if (fds[i] < 0)
+			continue;
+
+		trigger = eventfd_ctx_fdget(fds[i]);
+		if (IS_ERR(trigger)) {
+			mutex_unlock(&vctrl->lock);
+			return PTR_ERR(trigger);
+		}
+
+		irq->trigger = trigger;
+	}
+	if (paused)
+		nvmet_mdev_io_resume(vctrl);
+	mutex_unlock(&vctrl->lock);
+	return 0;
+}
+
+/* Set eventfd trigger for unplug interrupt */
+static int __nvmet_mdev_irqs_set_unplug_trigger(struct nvmet_mdev_vctrl *vctrl,
+						int32_t fd)
+{
+	struct eventfd_ctx *trigger;
+
+	if (vctrl->irqs.request_trigger) {
+		_DBG(vctrl, "IRQ: clear hotplug trigger\n");
+		eventfd_ctx_put(vctrl->irqs.request_trigger);
+		vctrl->irqs.request_trigger = NULL;
+	}
+
+	if (fd < 0)
+		return 0;
+
+	_DBG(vctrl, "IRQ: set hotplug trigger\n");
+
+	trigger = eventfd_ctx_fdget(fd);
+	if (IS_ERR(trigger))
+		return PTR_ERR(trigger);
+
+	vctrl->irqs.request_trigger = trigger;
+	return 0;
+}
+
+int nvmet_mdev_irqs_set_unplug_trigger(struct nvmet_mdev_vctrl *vctrl,
+				       int32_t fd)
+{
+	int retval;
+
+	mutex_lock(&vctrl->lock);
+	retval = __nvmet_mdev_irqs_set_unplug_trigger(vctrl, fd);
+	mutex_unlock(&vctrl->lock);
+	return retval;
+}
+
+/* Reset the interrupts subsystem */
+void nvmet_mdev_irqs_reset(struct nvmet_mdev_vctrl *vctrl)
+{
+	int i;
+
+	lockdep_assert_held(&vctrl->lock);
+
+	if (vctrl->irqs.mode != NVME_MDEV_IMODE_NONE)
+		__nvmet_mdev_irqs_disable(vctrl, vctrl->irqs.mode);
+
+	__nvmet_mdev_irqs_set_unplug_trigger(vctrl, -1);
+
+	for (i = 0; i < MAX_VIRTUAL_IRQS; i++) {
+		struct nvmet_mdev_user_irq *vec = &vctrl->irqs.vecs[i];
+
+		vec->irq_coalesc_en = false;
+		vec->irq_pending_cnt = 0;
+		vec->irq_time = 0;
+	}
+
+	vctrl->irqs.irq_coalesc_time_us = 0;
+}
+
+/* Check if interrupt can be coalesced */
+static bool nvmet_mdev_irq_coalesce(struct nvmet_mdev_vctrl *vctrl,
+				    struct nvmet_mdev_user_irq *irq,
+				    ktime_t now)
+{
+	s64 delta;
+
+	if (!irq->irq_coalesc_en)
+		return false;
+
+	if (irq->irq_pending_cnt >= vctrl->irqs.irq_coalesc_max)
+		return false;
+
+	delta = ktime_us_delta(now, irq->irq_time);
+	return (delta < vctrl->irqs.irq_coalesc_time_us);
+}
+
+void nvmet_mdev_irq_raise_unplug_event(struct nvmet_mdev_vctrl *vctrl)
+{
+	mutex_lock(&vctrl->lock);
+
+	if (vctrl->irqs.request_trigger) {
+		dev_notice_ratelimited(mdev_dev(vctrl->mdev),
+				       "Relaying device request to user\n");
+		eventfd_signal(vctrl->irqs.request_trigger);
+
+	} else {
+		dev_notice(mdev_dev(vctrl->mdev),
+			   "No device request channel registered, blocked until released by user\n");
+	}
+	mutex_unlock(&vctrl->lock);
+}
+
+/* Raise an interrupt */
+void nvmet_mdev_irq_raise(struct nvmet_mdev_vctrl *vctrl, unsigned int index)
+{
+	struct nvmet_mdev_user_irq *irq = &vctrl->irqs.vecs[index];
+
+	irq->irq_pending_cnt++;
+}
+
+/* Unraise an interrupt */
+void nvmet_mdev_irq_clear(struct nvmet_mdev_vctrl *vctrl, unsigned int index,
+			  ktime_t now)
+{
+	struct nvmet_mdev_user_irq *irq = &vctrl->irqs.vecs[index];
+
+	irq->irq_time = now;
+	irq->irq_pending_cnt = 0;
+}
+
+/* Directly trigger an interrupt without affecting irq coalescing settings */
+void nvmet_mdev_irq_trigger(struct nvmet_mdev_vctrl *vctrl, unsigned int index)
+{
+	struct nvmet_mdev_user_irq *irq = &vctrl->irqs.vecs[index];
+
+	if (irq->trigger)
+		eventfd_signal(irq->trigger);
+}
+
+/* Trigger previously raised interrupt */
+void nvmet_mdev_irq_cond_trigger(struct nvmet_mdev_vctrl *vctrl,
+				 unsigned int index, ktime_t now)
+{
+	struct nvmet_mdev_user_irq *irq = &vctrl->irqs.vecs[index];
+
+	if (irq->irq_pending_cnt == 0)
+		return;
+
+	if (!nvmet_mdev_irq_coalesce(vctrl, irq, now)) {
+		nvmet_mdev_irq_trigger(vctrl, index);
+		nvmet_mdev_irq_clear(vctrl, index, now);
+	}
+}
diff --git a/drivers/nvme/target/mdev-pci/mmio.c b/drivers/nvme/target/mdev-pci/mmio.c
new file mode 100644
index 000000000000..f41246b73044
--- /dev/null
+++ b/drivers/nvme/target/mdev-pci/mmio.c
@@ -0,0 +1,561 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * NVMe virtual controller MMIO implementation
+ * Copyright (c) 2019 - Maxim Levitsky
+ */
+#include <linux/kernel.h>
+#include <linux/highmem.h>
+#include "priv.h"
+
+#define DB_AREA_SIZE (NVMET_MDEV_MAX_NR_QUEUES * 2 * (4 << DB_STRIDE_SHIFT))
+#define DB_MASK ((4 << DB_STRIDE_SHIFT) - 1)
+#define MMIO_BAR_SIZE __roundup_pow_of_two(NVME_REG_DBS + DB_AREA_SIZE)
+
+/* Put the controller into fatal error state. Only way out is reset */
+static void nvmet_mdev_mmio_fatal_error(struct nvmet_mdev_vctrl *vctrl)
+{
+	if (vctrl->mmio.csts & NVME_CSTS_CFS)
+		return;
+
+	vctrl->mmio.csts |= NVME_CSTS_CFS;
+	nvmet_mdev_io_pause(vctrl);
+
+	if (vctrl->mmio.csts & NVME_CSTS_RDY)
+		nvmet_mdev_vctrl_disable(vctrl);
+}
+
+/* This is memory fault handler for the mmap area of the doorbells */
+static vm_fault_t nvmet_mdev_mmio_dbs_mmap_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct nvmet_mdev_vctrl *vctrl = vma->vm_private_data;
+
+	/* DB area is just one page, starting at offset 4096 of the mmio */
+	if (WARN_ON(vmf->pgoff != 1))
+		return VM_FAULT_SIGBUS;
+
+	get_page(vctrl->mmio.dbs_page);
+	vmf->page = vctrl->mmio.dbs_page;
+	return 0;
+}
+
+static const struct vm_operations_struct nvmet_mdev_mmio_dbs_vm_ops = {
+	.fault = nvmet_mdev_mmio_dbs_mmap_fault,
+};
+
+/* check that user db write is valid and send an error if not */
+bool nvmet_mdev_mmio_db_check(struct nvmet_mdev_vctrl *vctrl, u16 qid, u16 size,
+			      u16 db)
+{
+	if (db < size)
+		return true;
+	if (qid == 0) {
+		_DBG(vctrl, "MMIO: invalid admin DB write - fatal error\n");
+		nvmet_mdev_mmio_fatal_error(vctrl);
+		return false;
+	}
+
+	_DBG(vctrl, "MMIO: invalid DB value write qid=%d, size=%d, value=%d\n",
+	     qid, size, db);
+
+	nvmet_add_async_event(vctrl->nvmet_ctrl, NVME_AER_ERROR,
+			      NVME_AER_ERROR_INVALID_DB_VALUE, NVME_LOG_ERROR);
+	return false;
+}
+
+/* handle submission queue doorbell write */
+static void nvmet_mdev_mmio_db_write_sq(struct nvmet_mdev_vctrl *vctrl, u32 qid,
+					u32 val)
+{
+	_DBG(vctrl, "MMIO: doorbell SQID %d, DB write %d\n", qid, val);
+
+	/* check if the db belongs to a valid queue */
+	if (qid >= NVMET_MDEV_MAX_NR_QUEUES || !test_bit(qid, vctrl->vsq_en))
+		goto err_db;
+
+	vctrl->io_idle = false;
+
+	if (!vctrl->mmio.shadow_db_supported)
+		return;
+
+	nvmet_mdev_io_resume(vctrl);
+	return;
+
+err_db:
+	_DBG(vctrl, "MMIO: inactive/invalid SQ DB write qid=%d, value=%d\n",
+	     qid, val);
+
+	nvmet_add_async_event(vctrl->nvmet_ctrl, NVME_AER_ERROR,
+			      NVME_AER_ERROR_INVALID_DB_REG, NVME_LOG_ERROR);
+}
+
+/* handle doorbell write */
+static void nvmet_mdev_mmio_db_write_cq(struct nvmet_mdev_vctrl *vctrl, u32 qid,
+					u32 val)
+{
+	_DBG(vctrl, "MMIO: doorbell CQID %d, DB write %d\n", qid, val);
+
+	lockdep_assert_held(&vctrl->lock);
+	/* check if the db belongs to a valid queue */
+	if (qid >= NVMET_MDEV_MAX_NR_QUEUES || !test_bit(qid, vctrl->vcq_en))
+		goto err_db;
+
+	if (!vctrl->mmio.shadow_db_supported)
+		return;
+
+	nvmet_mdev_io_resume(vctrl);
+	return;
+
+err_db:
+	_DBG(vctrl,
+	     "MMIO: inactive/invalid CQ DB write qid=%d, value=%d\n",
+	     qid, val);
+
+	nvmet_add_async_event(vctrl->nvmet_ctrl, NVME_AER_ERROR,
+			      NVME_AER_ERROR_INVALID_DB_REG, NVME_LOG_ERROR);
+}
+
+/* This is called when user enables the controller */
+static void nvmet_mdev_mmio_cntrl_enable(struct nvmet_mdev_vctrl *vctrl)
+{
+	u64 acq, asq;
+
+	lockdep_assert_held(&vctrl->lock);
+
+	/* Controller must be reset from the dead state */
+	if (nvmet_mdev_vctrl_is_dead(vctrl))
+		goto error;
+
+	if (nvmet_cc_ams(vctrl->mmio.cc) != NVME_CC_AMS_RR)
+		goto error;
+
+	/* Check the page size */
+	if (nvmet_cc_mps(vctrl->mmio.cc) != (PAGE_SHIFT - 12))
+		goto error;
+
+	/* Start the admin completion queue */
+	acq = vctrl->mmio.acql | ((u64)vctrl->mmio.acqh << 32);
+	asq = vctrl->mmio.asql | ((u64)vctrl->mmio.asqh << 32);
+
+	if (!nvmet_mdev_vctrl_enable(vctrl, acq, asq, vctrl->mmio.aqa))
+		goto error;
+
+	/* Success! */
+	vctrl->mmio.csts |= NVME_CSTS_RDY;
+	return;
+error:
+	_WARN(vctrl, "MMIO: failure to enable the controller - fatal error\n");
+	nvmet_mdev_mmio_fatal_error(vctrl);
+}
+
+/*
+ * This is called when user sends a notification that controller is
+ * about to be disabled
+ */
+static void nvmet_mdev_mmio_cntrl_shutdown(struct nvmet_mdev_vctrl *vctrl)
+{
+	lockdep_assert_held(&vctrl->lock);
+
+	nvmet_update_cc(vctrl->nvmet_ctrl, vctrl->mmio.cc);
+	/*
+	 * Manually clear shutdown notification bits
+	 * TODO: inherit csts/cc from nvmet core.
+	 */
+	vctrl->mmio.cc &= ~NVME_CC_SHN_MASK;
+
+	if (nvmet_mdev_vctrl_is_dead(vctrl)) {
+		_DBG(vctrl, "MMIO: shutdown notification for dead ctrl\n");
+		return;
+	}
+
+	/* not enabled */
+	if (!(vctrl->mmio.csts & NVME_CSTS_RDY)) {
+		_DBG(vctrl, "MMIO: shutdown notification with CSTS.RDY==0\n");
+		nvmet_mdev_assert_io_not_running(vctrl);
+		return;
+	}
+
+	nvmet_mdev_io_pause(vctrl);
+	nvmet_mdev_vctrl_disable(vctrl);
+	vctrl->mmio.csts |= NVME_CSTS_SHST_CMPLT;
+}
+
+/* MMIO BAR read/write */
+static int nvmet_mdev_mmio_bar_access(struct nvmet_mdev_vctrl *vctrl,
+				      u16 offset, char *buf, u32 count,
+				      bool is_write)
+{
+	u32 val, oldval;
+
+	mutex_lock(&vctrl->lock);
+
+	/*
+	 * Drop non DWORD sized and aligned reads/writes
+	 * (QWORD  read/writes are split by the caller)
+	 */
+	if (count != 4 || (offset & 0x3))
+		goto drop;
+
+	val = is_write ? le32_to_cpu(*(__le32 *)buf) : 0;
+
+	switch (offset) {
+	case NVME_REG_CAP:
+		/* controller capabilities (low 32 bit) */
+		if (is_write)
+			goto drop;
+		store_le32(buf, vctrl->mmio.cap & 0xFFFFFFFF);
+		break;
+	case NVME_REG_CAP + 4:
+		/* controller capabilities (upper 32 bit) */
+		if (is_write)
+			goto drop;
+		store_le32(buf, vctrl->mmio.cap >> 32);
+		break;
+	case NVME_REG_VS:
+		if (is_write)
+			goto drop;
+		store_le32(buf, NVME_MDEV_NVME_VER);
+		break;
+	case NVME_REG_INTMS:
+	case NVME_REG_INTMC:
+		/* Interrupt Mask Set & Clear */
+		goto drop;
+	case NVME_REG_CC:
+		/* Controller Configuration */
+		if (!is_write) {
+			store_le32(buf, vctrl->mmio.cc);
+			break;
+		}
+
+		oldval = vctrl->mmio.cc;
+		vctrl->mmio.cc = val;
+
+		/* drop if reserved bits set */
+		if (vctrl->mmio.cc & 0xFF00000E) {
+			_DBG(vctrl,
+			     "MMIO: reserved bits of CC set - fatal error\n");
+			nvmet_mdev_mmio_fatal_error(vctrl);
+			goto drop;
+		}
+
+		/*
+		 * CSS(command set),MPS(memory page size),AMS(queue arbitration)
+		 * must not be changed while controller is running
+		 */
+		if (vctrl->mmio.csts & NVME_CSTS_RDY) {
+			if ((vctrl->mmio.cc & 0x3FF0) != (oldval & 0x3FF0)) {
+				_DBG(vctrl,
+				     "MMIO: attempt to change setting bits of CC while CC.EN=1 - fatal error\n");
+
+				nvmet_mdev_mmio_fatal_error(vctrl);
+				goto drop;
+			}
+		}
+
+		if (nvmet_cc_shn(vctrl->mmio.cc)) {
+			_DBG(vctrl, "MMIO: CC.SHN != 0 - shutdown\n");
+			nvmet_mdev_mmio_cntrl_shutdown(vctrl);
+		}
+
+		/* change in controller enabled state */
+		if (nvmet_cc_en(val) == nvmet_cc_en(oldval))
+			break;
+
+		if (nvmet_cc_en(vctrl->mmio.cc)) {
+			_DBG(vctrl, "MMIO: CC.EN<=1 - enable the controller\n");
+			nvmet_mdev_mmio_cntrl_enable(vctrl);
+		} else {
+			_DBG(vctrl, "MMIO: CC.EN<=0 - reset controller\n");
+			__nvmet_mdev_vctrl_reset(vctrl, false);
+		}
+
+		break;
+	case NVME_REG_CSTS:
+		/* Controller Status */
+		if (is_write)
+			goto drop;
+		store_le32(buf, vctrl->mmio.csts);
+		break;
+	case NVME_REG_AQA:
+		/* admin queue submission and completion size */
+		if (!is_write)
+			store_le32(buf, vctrl->mmio.aqa);
+		else if (!(vctrl->mmio.csts & NVME_CSTS_RDY))
+			vctrl->mmio.aqa = val;
+		else
+			goto drop;
+		break;
+	case NVME_REG_ASQ:
+		/* admin submission queue address (low 32 bit) */
+		if (!is_write)
+			store_le32(buf, vctrl->mmio.asql);
+		else if (!(vctrl->mmio.csts & NVME_CSTS_RDY))
+			vctrl->mmio.asql = val;
+		else
+			goto drop;
+		break;
+
+	case NVME_REG_ASQ + 4:
+		/* admin submission queue address (high 32 bit) */
+		if (!is_write)
+			store_le32(buf, vctrl->mmio.asqh);
+		else if (!(vctrl->mmio.csts & NVME_CSTS_RDY))
+			vctrl->mmio.asqh = val;
+		else
+			goto drop;
+		break;
+	case NVME_REG_ACQ:
+		/* admin completion queue address (low 32 bit) */
+		if (!is_write)
+			store_le32(buf, vctrl->mmio.acql);
+		else if (!(vctrl->mmio.csts & NVME_CSTS_RDY))
+			vctrl->mmio.acql = val;
+		else
+			goto drop;
+		break;
+	case NVME_REG_ACQ + 4:
+		/* admin completion queue address (high 32 bit) */
+		if (!is_write)
+			store_le32(buf, vctrl->mmio.acqh);
+		else if (!(vctrl->mmio.csts & NVME_CSTS_RDY))
+			vctrl->mmio.acqh = val;
+		else
+			goto drop;
+		break;
+	case NVME_REG_CMBLOC:
+	case NVME_REG_CMBSZ:
+		/* not supported - hardwired to 0 */
+		if (is_write)
+			goto drop;
+		store_le32(buf, 0);
+		break;
+	case NVME_REG_DBS ... (NVME_REG_DBS + DB_AREA_SIZE - 1): {
+		/* completion and submission doorbells */
+		u16 db_offset = offset - NVME_REG_DBS;
+		u16 index = db_offset >> (DB_STRIDE_SHIFT + 2);
+		u16 qid = index >> 1;
+		bool sq = (index & 0x1) == 0;
+
+		if (!is_write || (db_offset & DB_MASK))
+			goto drop;
+
+		if (!(vctrl->mmio.csts & NVME_CSTS_RDY))
+			goto drop;
+
+		if (nvmet_mdev_vctrl_is_dead(vctrl))
+			goto drop;
+
+		sq ? nvmet_mdev_mmio_db_write_sq(vctrl, qid, val) :
+		     nvmet_mdev_mmio_db_write_cq(vctrl, qid, val);
+		break;
+	}
+	default:
+		goto drop;
+	}
+
+	mutex_unlock(&vctrl->lock);
+	return count;
+
+drop:
+	_WARN(vctrl, "MMIO: dropping write at 0x%x\n", offset);
+	mutex_unlock(&vctrl->lock);
+	return 0;
+}
+
+/* Called when the virtual controller is created */
+int nvmet_mdev_mmio_create(struct nvmet_mdev_vctrl *vctrl)
+{
+	struct nvmet_ctrl *ctrl = vctrl->nvmet_ctrl;
+	int ret;
+
+	/* BAR0 */
+	nvmet_mdev_pci_setup_bar(vctrl, PCI_BASE_ADDRESS_0, MMIO_BAR_SIZE,
+				 nvmet_mdev_mmio_bar_access);
+
+	/* CAP has 4 bits for the doorbell stride shift */
+	BUILD_BUG_ON(DB_STRIDE_SHIFT > 0xF);
+
+	/* Shadow doorbell limits doorbells to 1 page */
+	BUILD_BUG_ON(DB_AREA_SIZE > PAGE_SIZE);
+
+	/* Just in case... */
+	BUILD_BUG_ON((PAGE_SHIFT - 12) > 0xF);
+
+	/*
+	 * Inherit nvmet core's defaults and configfs values and then add
+	 * specific settings.
+	 */
+	vctrl->mmio.cap = ctrl->cap;
+
+	vctrl->mmio.cap |=
+		/*
+		 * CQR: physically contiguous queues until we fine a OS
+		 * that needs otherwise.
+		 */
+		(1ULL << 16) |
+		/* DSTRD: doorbell stride */
+		((u64)DB_STRIDE_SHIFT << 32) |
+		/* MPSMIN: Minimum page size supported is PAGE_SIZE */
+		((u64)(PAGE_SHIFT - 12) << 48) |
+		/* MPSMAX: Maximum page size is PAGE_SIZE as well */
+		((u64)(PAGE_SHIFT - 12) << 52);
+
+	/* Create the (regular) doorbell buffers */
+	vctrl->mmio.dbs_page = alloc_pages(__GFP_ZERO, 0);
+
+	ret = -ENOMEM;
+
+	if (!vctrl->mmio.dbs_page)
+		goto error0;
+
+	vctrl->mmio.db_page_kmap = kmap_local_page(vctrl->mmio.dbs_page);
+	if (!vctrl->mmio.db_page_kmap)
+		goto error1;
+
+	vctrl->mmio.fake_eidx_page = alloc_page(__GFP_ZERO);
+	if (!vctrl->mmio.fake_eidx_page)
+		goto error2;
+
+	vctrl->mmio.fake_eidx_kmap = kmap_local_page(vctrl->mmio.fake_eidx_page);
+	if (!vctrl->mmio.fake_eidx_kmap)
+		goto error3;
+	return 0;
+error3:
+	put_page(vctrl->mmio.fake_eidx_kmap);
+error2:
+	kunmap_local(vctrl->mmio.db_page_kmap);
+error1:
+	put_page(vctrl->mmio.dbs_page);
+error0:
+	return ret;
+}
+
+/* Called when the virtual controller is reset */
+void nvmet_mdev_mmio_reset(struct nvmet_mdev_vctrl *vctrl, bool pci_reset)
+{
+	vctrl->mmio.cc = 0;
+	vctrl->mmio.csts = 0;
+
+	if (pci_reset) {
+		vctrl->mmio.aqa  = 0;
+		vctrl->mmio.asql = 0;
+		vctrl->mmio.asqh = 0;
+		vctrl->mmio.acql = 0;
+		vctrl->mmio.acqh = 0;
+	}
+}
+
+/* Called when the virtual controller is opened */
+void nvmet_mdev_mmio_open(struct nvmet_mdev_vctrl *vctrl)
+{
+	if (!vctrl->mmio.shadow_db_supported)
+		nvmet_mdev_vctrl_region_set_mmap(vctrl,
+						 VFIO_PCI_BAR0_REGION_INDEX,
+						 NVME_REG_DBS, PAGE_SIZE,
+						 &nvmet_mdev_mmio_dbs_vm_ops);
+	else
+		nvmet_mdev_vctrl_region_disable_mmap(vctrl,
+						     VFIO_PCI_BAR0_REGION_INDEX);
+}
+
+/* Called when the virtual controller queues are enabled */
+int nvmet_mdev_mmio_enable_dbs(struct nvmet_mdev_vctrl *vctrl)
+{
+	if (WARN_ON(vctrl->mmio.shadow_db_en))
+		return -EINVAL;
+
+	nvmet_mdev_assert_io_not_running(vctrl);
+
+	/* setup normal doorbells and reset them */
+	vctrl->mmio.dbs = vctrl->mmio.db_page_kmap;
+	vctrl->mmio.eidxs = vctrl->mmio.fake_eidx_kmap;
+	memset((void *)vctrl->mmio.dbs, 0, DB_AREA_SIZE);
+	memset((void *)vctrl->mmio.eidxs, 0, DB_AREA_SIZE);
+	return 0;
+}
+
+/* Called when the virtual controller shadow doorbell is enabled */
+int nvmet_mdev_mmio_enable_dbs_shadow(struct nvmet_mdev_vctrl *vctrl,
+				      dma_addr_t sdb_iova,
+				      dma_addr_t eidx_iova)
+{
+	int ret;
+
+	ret = nvmet_mdev_viommu_add(&vctrl->viommu,
+				    VFIO_DMA_MAP_FLAG_READ |
+				    VFIO_DMA_MAP_FLAG_WRITE,
+				    sdb_iova, PAGE_SIZE,
+				    &vctrl->viommu.mem_map_list);
+	if (ret)
+		return ret;
+
+	ret = nvmet_mdev_viommu_create_kmap(&vctrl->viommu, sdb_iova,
+					    &vctrl->mmio.sdb_map);
+	if (ret)
+		goto unmap_sdb;
+
+	ret = nvmet_mdev_viommu_add(&vctrl->viommu,
+				    VFIO_DMA_MAP_FLAG_READ |
+				    VFIO_DMA_MAP_FLAG_WRITE,
+				    eidx_iova, PAGE_SIZE,
+				    &vctrl->viommu.mem_map_list);
+	if (ret)
+		goto kunmap_sdb;
+
+	ret = nvmet_mdev_viommu_create_kmap(&vctrl->viommu, eidx_iova,
+					    &vctrl->mmio.seidx_map);
+	if (ret)
+		goto unmap_eidx;
+
+	vctrl->mmio.sdb_iova = sdb_iova;
+	vctrl->mmio.dbs = vctrl->mmio.sdb_map.kmap;
+
+	vctrl->mmio.eidx_iova = eidx_iova;
+	vctrl->mmio.eidxs = vctrl->mmio.seidx_map.kmap;
+
+	memcpy((void *)vctrl->mmio.dbs, vctrl->mmio.db_page_kmap,
+	       DB_AREA_SIZE);
+	memcpy((void *)vctrl->mmio.eidxs, vctrl->mmio.db_page_kmap,
+	       DB_AREA_SIZE);
+
+	vctrl->mmio.shadow_db_en = true;
+	return 0;
+
+unmap_eidx:
+	nvmet_mdev_vctrl_viommu_unmap(vctrl, eidx_iova, PAGE_SIZE);
+kunmap_sdb:
+	nvmet_mdev_viommu_free_kmap(&vctrl->viommu, &vctrl->mmio.sdb_map);
+unmap_sdb:
+	nvmet_mdev_vctrl_viommu_unmap(vctrl, sdb_iova, PAGE_SIZE);
+	return ret;
+}
+
+/* Disable the doorbells */
+void nvmet_mdev_mmio_disable_dbs(struct nvmet_mdev_vctrl *vctrl)
+{
+	nvmet_mdev_assert_io_not_running(vctrl);
+
+	/* Free the shadow doorbells */
+	nvmet_mdev_viommu_free_kmap(&vctrl->viommu, &vctrl->mmio.sdb_map);
+	nvmet_mdev_viommu_free_kmap(&vctrl->viommu, &vctrl->mmio.seidx_map);
+
+	nvmet_mdev_vctrl_viommu_unmap(vctrl, vctrl->mmio.sdb_iova, PAGE_SIZE);
+	nvmet_mdev_vctrl_viommu_unmap(vctrl, vctrl->mmio.eidx_iova, PAGE_SIZE);
+
+	/* Clear the doorbells */
+	vctrl->mmio.sdb_iova = 0;
+	vctrl->mmio.eidx_iova = 0;
+	vctrl->mmio.dbs = NULL;
+	vctrl->mmio.eidxs = NULL;
+	vctrl->mmio.shadow_db_en = false;
+}
+
+/* Called when the virtual controller is about to be freed */
+void nvmet_mdev_mmio_free(struct nvmet_mdev_vctrl *vctrl)
+{
+	nvmet_mdev_assert_io_not_running(vctrl);
+	kunmap_local(vctrl->mmio.db_page_kmap);
+	put_page(vctrl->mmio.dbs_page);
+	kunmap_local(vctrl->mmio.fake_eidx_kmap);
+	put_page(vctrl->mmio.fake_eidx_page);
+}
diff --git a/drivers/nvme/target/mdev-pci/pci.c b/drivers/nvme/target/mdev-pci/pci.c
new file mode 100644
index 000000000000..dda0eed00854
--- /dev/null
+++ b/drivers/nvme/target/mdev-pci/pci.c
@@ -0,0 +1,241 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * NVMe virtual controller minimal PCI/PCIe config space implementation
+ * Copyright (c) 2019 - Maxim Levitsky
+ */
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include "priv.h"
+
+/* setup a 64 bit PCI bar */
+void nvmet_mdev_pci_setup_bar(struct nvmet_mdev_vctrl *vctrl, u8 bar,
+			      unsigned int size, region_access_fn access_fn)
+{
+	nvmet_mdev_vctrl_add_region(vctrl, VFIO_PCI_BAR0_REGION_INDEX +
+				    ((bar - PCI_BASE_ADDRESS_0) >> 2),
+				    size, access_fn);
+
+	store_le32(vctrl->pcicfg.wmask + bar, ~((u64)size - 1));
+	store_le32(vctrl->pcicfg.values + bar,
+		   PCI_BASE_ADDRESS_SPACE_MEMORY |
+		   PCI_BASE_ADDRESS_MEM_TYPE_64);
+}
+
+/* Allocate a pci capability */
+static u8 nvmet_mdev_pci_allocate_cap(struct nvmet_mdev_vctrl *vctrl, u8 id,
+				      u8 size)
+{
+	u8 *cfg = vctrl->pcicfg.values;
+	u8 newcap = vctrl->pcicfg.end;
+	u8 cap = cfg[PCI_CAPABILITY_LIST];
+
+	size = round_up(size, 4);
+	/* only standard cfg space caps for now */
+	WARN_ON(newcap + size > 256);
+
+	if (!cfg[PCI_CAPABILITY_LIST]) {
+		/* special case for first capability */
+		u16 status = load_le16(cfg + PCI_STATUS);
+
+		status |= PCI_STATUS_CAP_LIST;
+		store_le16(cfg + PCI_STATUS, status);
+
+		cfg[PCI_CAPABILITY_LIST] = newcap;
+		goto setupcap;
+	}
+
+	while (cfg[cap + PCI_CAP_LIST_NEXT] != 0)
+		cap = cfg[cap + PCI_CAP_LIST_NEXT];
+
+	cfg[cap + PCI_CAP_LIST_NEXT] = newcap;
+
+setupcap:
+	cfg[newcap + PCI_CAP_LIST_ID] = id;
+	cfg[newcap + PCI_CAP_LIST_NEXT] = 0;
+	vctrl->pcicfg.end += size;
+	return newcap;
+}
+
+static void nvmet_mdev_pci_setup_pm_cap(struct nvmet_mdev_vctrl *vctrl)
+{
+	u8 *cfg  =  vctrl->pcicfg.values;
+	u8 *cfgm =  vctrl->pcicfg.wmask;
+
+	u8 cap = nvmet_mdev_pci_allocate_cap(vctrl, PCI_CAP_ID_PM,
+					     PCI_PM_SIZEOF);
+
+	store_le16(cfg + cap + PCI_PM_PMC, 0x3);
+	store_le16(cfg + cap + PCI_PM_CTRL, PCI_PM_CTRL_NO_SOFT_RESET);
+	store_le16(cfgm + cap + PCI_PM_CTRL, 0x3);
+	vctrl->pcicfg.pmcap = cap;
+}
+
+static void nvmet_mdev_pci_setup_msix_cap(struct nvmet_mdev_vctrl *vctrl)
+{
+	u8 *cfg  =  vctrl->pcicfg.values;
+	u8 *cfgm =  vctrl->pcicfg.wmask;
+	u8  cap = nvmet_mdev_pci_allocate_cap(vctrl, PCI_CAP_ID_MSIX,
+					      PCI_CAP_MSIX_SIZEOF);
+
+	int MSIX_TBL_SIZE = roundup(MAX_VIRTUAL_IRQS * 16, PAGE_SIZE);
+	int MSIX_PBA_SIZE = roundup(DIV_ROUND_UP(MAX_VIRTUAL_IRQS, 8),
+				    PAGE_SIZE);
+
+	store_le16(cfg + cap + PCI_MSIX_FLAGS, MAX_VIRTUAL_IRQS - 1);
+	store_le16(cfgm + cap + PCI_MSIX_FLAGS,
+		   PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE);
+
+	store_le32(cfg + cap + PCI_MSIX_TABLE, 0x2);
+	store_le32(cfg + cap + PCI_MSIX_PBA, MSIX_TBL_SIZE | 0x2);
+
+	nvmet_mdev_pci_setup_bar(vctrl, PCI_BASE_ADDRESS_2,
+				 __roundup_pow_of_two(MSIX_TBL_SIZE +
+						MSIX_PBA_SIZE), NULL);
+	vctrl->pcicfg.msixcap = cap;
+}
+
+static void nvmet_mdev_pci_setup_pcie_cap(struct nvmet_mdev_vctrl *vctrl)
+{
+	u8 *cfg = vctrl->pcicfg.values;
+	u8 cap = nvmet_mdev_pci_allocate_cap(vctrl, PCI_CAP_ID_EXP,
+					     PCI_CAP_EXP_ENDPOINT_SIZEOF_V2);
+
+	store_le16(cfg + cap + PCI_EXP_FLAGS, 0x02 |
+		   (PCI_EXP_TYPE_ENDPOINT << 4));
+
+	store_le32(cfg + cap + PCI_EXP_DEVCAP,
+		   PCI_EXP_DEVCAP_RBER | PCI_EXP_DEVCAP_FLR);
+	store_le32(cfg + cap + PCI_EXP_LNKCAP,
+		   PCI_EXP_LNKCAP_SLS_8_0GB | (4 << 4) /*4x*/);
+	store_le16(cfg + cap + PCI_EXP_LNKSTA,
+		   PCI_EXP_LNKSTA_CLS_8_0GB | (4 << 4) /*4x*/);
+
+	store_le32(cfg + cap + PCI_EXP_LNKCAP2, PCI_EXP_LNKCAP2_SLS_8_0GB);
+	store_le16(cfg + cap + PCI_EXP_LNKCTL2, PCI_EXP_LNKCTL2_TLS_8_0GT);
+	vctrl->pcicfg.pciecap = cap;
+}
+
+/* This is called on PCI config read/write */
+static int nvmet_mdev_pci_cfg_access(struct nvmet_mdev_vctrl *vctrl, u16 offset,
+				     char *buf, u32 count, bool is_write)
+{
+	unsigned int i;
+
+	mutex_lock(&vctrl->lock);
+
+	if (!is_write) {
+		memcpy(buf, (vctrl->pcicfg.values + offset), count);
+		goto out;
+	}
+
+	for (i = 0; i < count; i++) {
+		u8 address = offset + i;
+		u8 value = buf[i];
+		u8 old_value = vctrl->pcicfg.values[address];
+		u8 wmask = vctrl->pcicfg.wmask[address];
+		u8 new_value = (value & wmask) | (old_value & ~wmask);
+
+		/* D3/D0 power control */
+		if (address == vctrl->pcicfg.pmcap + PCI_PM_CTRL) {
+			u8 state = new_value & 0x03;
+
+			if (state != 0 && state != 3)
+				new_value = old_value;
+
+			if (old_value != new_value) {
+				const char *s = state == 3 ? "D3" : "D0";
+
+				if (state == 3)
+					__nvmet_mdev_vctrl_reset(vctrl, true);
+				_DBG(vctrl, "PCI: going to %s\n", s);
+			}
+		}
+
+		/* FLR reset */
+		if (address == vctrl->pcicfg.pciecap + PCI_EXP_DEVCTL + 1)
+			if (value & 0x80) {
+				_DBG(vctrl, "PCI: FLR reset\n");
+				__nvmet_mdev_vctrl_reset(vctrl, true);
+			}
+		vctrl->pcicfg.values[offset + i] = new_value;
+	}
+out:
+	mutex_unlock(&vctrl->lock);
+	return count;
+}
+
+/* setup pci configuration */
+int nvmet_mdev_pci_create(struct nvmet_mdev_vctrl *vctrl)
+{
+	u8 *cfg, *cfgm;
+
+	vctrl->pcicfg.values = kzalloc(NVMET_MDEV_PCI_CFG_SIZE, GFP_KERNEL);
+	if (!vctrl->pcicfg.values)
+		return -ENOMEM;
+
+	vctrl->pcicfg.wmask = kzalloc(NVMET_MDEV_PCI_CFG_SIZE, GFP_KERNEL);
+	if (!vctrl->pcicfg.wmask) {
+		kfree(vctrl->pcicfg.values);
+		return -ENOMEM;
+	}
+
+	cfg = vctrl->pcicfg.values;
+	cfgm = vctrl->pcicfg.wmask;
+
+	nvmet_mdev_vctrl_add_region(vctrl, VFIO_PCI_CONFIG_REGION_INDEX,
+				    NVMET_MDEV_PCI_CFG_SIZE,
+				    nvmet_mdev_pci_cfg_access);
+
+	/* vendor information */
+	store_le16(cfg + PCI_VENDOR_ID, NVME_MDEV_PCI_VENDOR_ID);
+	store_le16(cfg + PCI_DEVICE_ID, NVME_MDEV_PCI_DEVICE_ID);
+
+	/* pci command register */
+	store_le16(cfgm + PCI_COMMAND,
+		   PCI_COMMAND_INTX_DISABLE |
+		   PCI_COMMAND_MEMORY |
+		   PCI_COMMAND_MASTER);
+
+	/* pci status register */
+	store_le16(cfg + PCI_STATUS, PCI_STATUS_CAP_LIST);
+
+	/* subsystem information */
+	store_le16(cfg + PCI_SUBSYSTEM_VENDOR_ID, NVME_MDEV_PCI_SUBVENDOR_ID);
+	store_le16(cfg + PCI_SUBSYSTEM_ID, NVME_MDEV_PCI_SUBDEVICE_ID);
+	store_le8(cfg + PCI_CLASS_REVISION, NVME_MDEV_PCI_REVISION);
+
+	/* Programming Interface (NVM Express) */
+	store_le8(cfg + PCI_CLASS_PROG, 0x02);
+
+	/*
+	 * Device class and subclass (Mass storage controller, Non-Volatile
+	 * memory controller)
+	 */
+	store_le16(cfg + PCI_CLASS_DEVICE, 0x0108);
+
+	/* dummy read/write */
+	store_le8(cfgm + PCI_CACHE_LINE_SIZE, 0xFF);
+
+	/* initial value */
+	store_le8(cfg + PCI_CAPABILITY_LIST, 0);
+	vctrl->pcicfg.end = 0x40;
+
+	nvmet_mdev_pci_setup_pm_cap(vctrl);
+	nvmet_mdev_pci_setup_msix_cap(vctrl);
+	nvmet_mdev_pci_setup_pcie_cap(vctrl);
+
+	/* INTX IRQ number - info only for BIOS */
+	store_le8(cfgm + PCI_INTERRUPT_LINE, 0xFF);
+	store_le8(cfg + PCI_INTERRUPT_PIN, 0x01);
+
+	return 0;
+}
+
+/* teardown pci configuration */
+void nvmet_mdev_pci_free(struct nvmet_mdev_vctrl *vctrl)
+{
+	kfree(vctrl->pcicfg.values);
+	kfree(vctrl->pcicfg.wmask);
+	vctrl->pcicfg.values = NULL;
+	vctrl->pcicfg.wmask = NULL;
+}
diff --git a/drivers/nvme/target/mdev-pci/priv.h b/drivers/nvme/target/mdev-pci/priv.h
new file mode 100644
index 000000000000..9572a182ddc7
--- /dev/null
+++ b/drivers/nvme/target/mdev-pci/priv.h
@@ -0,0 +1,487 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Driver private data structures and helper macros
+ * Copyright (c) 2019 - Maxim Levitsky
+ */
+
+#ifndef _MDEV_NVME_PRIV_H
+#define _MDEV_NVME_PRIV_H
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include <linux/vfio.h>
+#include <linux/mdev.h>
+#include <linux/pci.h>
+#include <linux/eventfd.h>
+#include <linux/byteorder/generic.h>
+#include "../../host/nvme.h"
+#include "../nvmet.h"
+
+#define NVME_MDEV_NVME_VER  NVME_VS(0x01, 0x03, 0x00)
+
+#define NVME_MDEV_PCI_VENDOR_ID		PCI_VENDOR_ID_REDHAT_QUMRANET
+#define NVME_MDEV_PCI_DEVICE_ID		0x1234
+#define NVME_MDEV_PCI_SUBVENDOR_ID	PCI_SUBVENDOR_ID_REDHAT_QUMRANET
+#define NVME_MDEV_PCI_SUBDEVICE_ID	0
+#define NVME_MDEV_PCI_REVISION		0x0
+
+#define DB_STRIDE_SHIFT 4 /*4 = 1 cacheline */
+#define NVMET_MDEV_MAX_NR_QUEUES 16
+#define MAX_VIRTUAL_IRQS 128
+
+struct page_map {
+	void *kmap;
+	struct page *page;
+	dma_addr_t iova;
+};
+
+struct user_prplist {
+	/* used by user data iterator */
+	struct page_map page;
+	/* index of current entry */
+	unsigned int index;
+};
+
+struct nvmet_ext_data_iter {
+	/* private */
+	struct nvmet_mdev_viommu *viommu;
+	union {
+		const union nvme_data_ptr *dptr;
+	struct user_prplist uprp;
+	};
+
+	/* user interface */
+	/* number of data pages, yet to be covered */
+	u64		count;
+	/* iterator physical address value */
+	phys_addr_t	physical;
+
+	struct list_head *mem_map_list;
+
+	/* moves iterator to the next item */
+	int (*next)(struct nvmet_ext_data_iter *data_iter);
+	/*
+	 * if != NULL, user should call this when it's done with data
+	 * pointed by the iterator
+	 */
+	void (*release)(struct nvmet_ext_data_iter *data_iter);
+};
+
+/* virtual submission queue */
+struct nvmet_mdev_vsq {
+	struct nvmet_sq nvmet_sq;
+	u16 qid;
+	u16 size;
+	/* next item to read */
+	u16 head;
+
+	/* the queue */
+	struct nvme_command *data;
+	unsigned int data_size;
+	dma_addr_t iova;
+
+	struct nvmet_mdev_vcq *vcq;
+	struct nvmet_mdev_vctrl *vctrl;
+
+	struct nvmet_mdev_req *reqs;
+};
+
+/* virtual completion queue */
+struct nvmet_mdev_vcq {
+	struct nvmet_cq nvmet_cq;
+	/* basic queue settings */
+	u16 qid;
+	u16 size;
+	u16 head;
+	u16 tail;
+	u16 phase;
+
+	volatile struct nvme_completion *data;
+	unsigned int data_size;
+	dma_addr_t iova;
+
+	struct llist_head mreq_list;
+	struct nvmet_mdev_vctrl *vctrl;
+
+	/* IRQ settings */
+	int irq /* -1 if disabled */;
+};
+
+struct nvmet_mdev_req {
+	struct nvmet_req req;
+	struct nvme_completion cqe;
+	struct sg_table sgt;
+	struct nvmet_ext_data_iter data_iter;
+	struct list_head mem_map_list;
+
+	struct nvmet_mdev_vcq *vcq;
+	struct llist_node cq_node;
+};
+
+/* Virtual IOMMU */
+struct nvmet_mdev_viommu {
+	struct vfio_device *vfio_dev;
+
+	/* dma/prp bookkeeping */
+	struct rb_root_cached maps_tree;
+	struct list_head mem_map_list;
+	struct nvmet_mdev_vctrl *vctrl;
+};
+
+struct doorbell {
+	volatile __le32 sqt;
+	u8 rsvd1[(4 << DB_STRIDE_SHIFT) - sizeof(__le32)];
+	volatile __le32 cqh;
+	u8 rsvd2[(4 << DB_STRIDE_SHIFT) - sizeof(__le32)];
+};
+
+/* MMIO state */
+struct nvmet_mdev_user_ctrl_mmio {
+	u32 cc;		/* controller configuration */
+	u32 csts;	/* controller status */
+	u64 cap		/* controller capabilities */;
+
+	/* admin queue location & size */
+	u32 aqa;
+	u32 asql;
+	u32 asqh;
+	u32 acql;
+	u32 acqh;
+
+	bool shadow_db_supported;
+	bool shadow_db_en;
+
+	/* Regular doorbells */
+	struct page *dbs_page;
+	struct page *fake_eidx_page;
+	void *db_page_kmap;
+	void *fake_eidx_kmap;
+
+	/* Shadow doorbells */
+	dma_addr_t sdb_iova;
+	struct page_map sdb_map;
+	dma_addr_t eidx_iova;
+	struct page_map seidx_map;
+
+	/* Current doorbell mappings */
+	volatile struct doorbell *dbs;
+	volatile struct doorbell *eidxs;
+};
+
+/* pci configuration space of the device */
+#define NVMET_MDEV_PCI_CFG_SIZE 4096
+struct nvmet_mdev_pci_cfg_space {
+	u8 *values;
+	u8 *wmask;
+
+	u8 pmcap;
+	u8 pciecap;
+	u8 msixcap;
+	u8 end;
+};
+
+/* IRQ state of the controller */
+struct nvmet_mdev_user_irq {
+	struct eventfd_ctx *trigger;
+	/* IRQ coalescing */
+	bool irq_coalesc_en;
+	ktime_t irq_time;
+	unsigned int irq_pending_cnt;
+};
+
+enum nvmet_mdev_irq_mode {
+	NVME_MDEV_IMODE_NONE,
+	NVME_MDEV_IMODE_INTX,
+	NVME_MDEV_IMODE_MSIX,
+};
+
+struct nvmet_mdev_user_irqs {
+	/* one of VFIO_PCI_{INTX|MSI|MSIX}_IRQ_INDEX */
+	enum nvmet_mdev_irq_mode mode;
+
+	struct nvmet_mdev_user_irq vecs[MAX_VIRTUAL_IRQS];
+	/* user interrupt coalescing settings */
+	u8 irq_coalesc_max;
+	unsigned int irq_coalesc_time_us;
+	/* device removal trigger */
+	struct eventfd_ctx *request_trigger;
+};
+
+/* IO region abstraction (BARs, the PCI config space */
+struct nvmet_mdev_vctrl;
+typedef int (*region_access_fn)(struct nvmet_mdev_vctrl *vctrl, u16 offset,
+				char *buf, u32 size, bool is_write);
+
+struct nvmet_mdev_io_region {
+	unsigned int size;
+	region_access_fn rw;
+
+	/*
+	 * IF != NULL, the mmap_area_start/size specify the mmaped window
+	 * of this region
+	 */
+	const struct vm_operations_struct *mmap_ops;
+	unsigned int mmap_area_start;
+	unsigned int mmap_area_size;
+};
+
+struct nvmet_mdev_type {
+	struct mdev_type type;
+	char *name;
+};
+
+struct nvmet_mdev_port {
+	struct mdev_parent parent;
+	struct device device;
+	struct nvmet_port *nvmet_port;
+	struct mutex mutex;
+
+	int ctrl_count;
+	int type_count;
+	struct nvmet_mdev_type *types;
+	struct mdev_type **mdev_types;
+};
+
+#define vfio_dev_to_nvmet_mdev_vctrl(vfio_dev) \
+	container_of(vfio_dev, struct nvmet_mdev_vctrl, vfio_dev)
+
+/* Virtual NVME controller state */
+struct nvmet_mdev_vctrl {
+	struct vfio_device vfio_dev;
+	struct kref ref;
+	struct mutex lock;
+
+	struct mdev_device *mdev;
+	struct nvmet_ctrl *nvmet_ctrl;
+
+	/* the IO thread */
+	struct task_struct *iothread;
+	bool iothread_parked;
+	bool io_idle;
+	ktime_t now;
+	int expected_responses;
+	int poll_timeout_ms;
+
+	struct nvmet_mdev_io_region regions[VFIO_PCI_NUM_REGIONS];
+
+	/* virtual controller state */
+	struct nvmet_mdev_user_ctrl_mmio mmio;
+	struct nvmet_mdev_pci_cfg_space pcicfg;
+	struct nvmet_mdev_user_irqs irqs;
+
+	/* emulated submission queues */
+	struct nvmet_mdev_vsq vsqs[NVMET_MDEV_MAX_NR_QUEUES];
+	unsigned long vsq_en[BITS_TO_LONGS(NVMET_MDEV_MAX_NR_QUEUES)];
+
+	/* emulated completion queues */
+	unsigned long vcq_en[BITS_TO_LONGS(NVMET_MDEV_MAX_NR_QUEUES)];
+	struct nvmet_mdev_vcq vcqs[NVMET_MDEV_MAX_NR_QUEUES];
+
+	/* Interface to access user memory */
+	struct notifier_block vfio_map_notifier;
+	struct notifier_block vfio_unmap_notifier;
+	struct nvmet_mdev_viommu viommu;
+
+	/* Settings */
+	unsigned int arb_burst_shift;
+	u8 worload_hint;
+	unsigned int iothread_cpu;
+};
+
+/* vctrl.c */
+int nvmet_mdev_vctrl_create(struct nvmet_mdev_vctrl *vctrl,
+			    struct mdev_device *mdev);
+void nvmet_mdev_vctrl_destroy(struct nvmet_mdev_vctrl *vctrl);
+int nvmet_mdev_vctrl_open(struct vfio_device *vfio_dev);
+void nvmet_mdev_vctrl_release(struct vfio_device *vfio_dev);
+bool nvmet_mdev_vctrl_enable(struct nvmet_mdev_vctrl *vctrl, dma_addr_t cqiova,
+			     dma_addr_t sqiova, u32 sizes);
+void nvmet_mdev_vctrl_disable(struct nvmet_mdev_vctrl *vctrl);
+void nvmet_mdev_vctrl_reset(struct nvmet_mdev_vctrl *vctrl);
+void __nvmet_mdev_vctrl_reset(struct nvmet_mdev_vctrl *vctrl, bool pci_reset);
+void nvmet_mdev_vctrl_add_region(struct nvmet_mdev_vctrl *vctrl,
+				 unsigned int index, unsigned int size,
+				 region_access_fn access_fn);
+void nvmet_mdev_vctrl_region_set_mmap(struct nvmet_mdev_vctrl *vctrl,
+				      unsigned int index, unsigned int offset,
+				      unsigned int size,
+				      const struct vm_operations_struct *ops);
+void nvmet_mdev_vctrl_region_disable_mmap(struct nvmet_mdev_vctrl *vctrl,
+					  unsigned int index);
+bool nvmet_mdev_vctrl_is_dead(struct nvmet_mdev_vctrl *vctrl);
+int nvmet_mdev_vctrl_viommu_map(struct nvmet_mdev_vctrl *vctrl, u32 flags,
+				dma_addr_t iova, u64 size);
+int nvmet_mdev_vctrl_viommu_unmap(struct nvmet_mdev_vctrl *vctrl,
+				  dma_addr_t iova, u64 size);
+
+/* io.c */
+int nvmet_mdev_io_create(struct nvmet_mdev_vctrl *vctrl);
+void nvmet_mdev_io_free(struct nvmet_mdev_vctrl *vctrl);
+void nvmet_mdev_io_resume(struct nvmet_mdev_vctrl *vctrl);
+bool nvmet_mdev_io_pause(struct nvmet_mdev_vctrl *vctrl);
+void nvmet_mdev_assert_io_not_running(struct nvmet_mdev_vctrl *vctrl);
+bool nvmet_mdev_process_responses(struct nvmet_mdev_vctrl *vctrl,
+				  struct nvmet_mdev_vcq *vcq);
+
+/* mmio.c */
+int nvmet_mdev_mmio_create(struct nvmet_mdev_vctrl *vctrl);
+void nvmet_mdev_mmio_open(struct nvmet_mdev_vctrl *vctrl);
+void nvmet_mdev_mmio_reset(struct nvmet_mdev_vctrl *vctrl, bool pci_reset);
+void nvmet_mdev_mmio_free(struct nvmet_mdev_vctrl *vctrl);
+
+int nvmet_mdev_mmio_enable_dbs(struct nvmet_mdev_vctrl *vctrl);
+int nvmet_mdev_mmio_enable_dbs_shadow(struct nvmet_mdev_vctrl *vctrl,
+				      dma_addr_t sdb_iova,
+				      dma_addr_t eidx_iova);
+
+void nvmet_mdev_mmio_viommu_update(struct nvmet_mdev_vctrl *vctrl);
+void nvmet_mdev_mmio_disable_dbs(struct nvmet_mdev_vctrl *vctrl);
+bool nvmet_mdev_mmio_db_check(struct nvmet_mdev_vctrl *vctrl, u16 qid, u16 size,
+			      u16 db);
+
+/* pci.c */
+int nvmet_mdev_pci_create(struct nvmet_mdev_vctrl *vctrl);
+void nvmet_mdev_pci_free(struct nvmet_mdev_vctrl *vctrl);
+void nvmet_mdev_pci_setup_bar(struct nvmet_mdev_vctrl *vctrl, u8 bar,
+			      unsigned int size, region_access_fn access_fn);
+
+/* irq.c */
+void nvmet_mdev_irqs_setup(struct nvmet_mdev_vctrl *vctrl);
+void nvmet_mdev_irqs_reset(struct nvmet_mdev_vctrl *vctrl);
+int nvmet_mdev_irqs_enable(struct nvmet_mdev_vctrl *vctrl,
+			   enum nvmet_mdev_irq_mode mode);
+void nvmet_mdev_irqs_disable(struct nvmet_mdev_vctrl *vctrl,
+			     enum nvmet_mdev_irq_mode mode);
+int nvmet_mdev_irqs_set_triggers(struct nvmet_mdev_vctrl *vctrl,
+				 int start, int count, int32_t *fds);
+int nvmet_mdev_irqs_set_unplug_trigger(struct nvmet_mdev_vctrl *vctrl,
+				       int32_t fd);
+void nvmet_mdev_irq_raise_unplug_event(struct nvmet_mdev_vctrl *vctrl);
+void nvmet_mdev_irq_raise(struct nvmet_mdev_vctrl *vctrl, unsigned int index);
+void nvmet_mdev_irq_trigger(struct nvmet_mdev_vctrl *vctrl, unsigned int index);
+void nvmet_mdev_irq_cond_trigger(struct nvmet_mdev_vctrl *vctrl,
+				 unsigned int index, ktime_t now);
+void nvmet_mdev_irq_clear(struct nvmet_mdev_vctrl *vctrl, unsigned int index,
+			  ktime_t now);
+
+/* vcq.c */
+int nvmet_mdev_vcq_init(struct nvmet_mdev_vctrl *vctrl, u16 qid,
+			dma_addr_t iova, u16 size, int irq);
+int nvmet_mdev_vcq_viommu_update(struct nvmet_mdev_viommu *viommu,
+				 struct nvmet_mdev_vcq *q);
+void nvmet_mdev_vcq_delete(struct nvmet_mdev_vctrl *vctrl, u16 qid);
+void nvmet_mdev_vcq_process(struct nvmet_mdev_vctrl *vctrl,
+			    struct nvmet_mdev_vcq *q, bool trigger_irqs,
+			    ktime_t now);
+bool nvmet_mdev_vcq_flush(struct nvmet_mdev_vctrl *vctrl,
+			  struct nvmet_mdev_vcq *q, ktime_t now);
+void nvmet_mdev_vcq_write_cqe(struct nvmet_mdev_vctrl *vctrl,
+			      struct nvmet_mdev_vcq *q,
+			      struct nvme_completion *cqe);
+
+/* vsq.c */
+int nvmet_mdev_vsq_init(struct nvmet_mdev_vctrl *vctrl, u16 qid,
+			dma_addr_t iova, u16 size, u16 cqid);
+int nvmet_mdev_vsq_viommu_update(struct nvmet_mdev_viommu *viommu,
+				 struct nvmet_mdev_vsq *q);
+void nvmet_mdev_vsq_delete(struct nvmet_mdev_vctrl *vctrl, u16 qid);
+struct nvme_command *nvmet_mdev_vsq_get_cmd(struct nvmet_mdev_vctrl *vctrl,
+					    struct nvmet_mdev_vsq *q,
+					    u16 *index);
+bool nvmet_mdev_vsq_suspend_io(struct nvmet_mdev_vsq *q);
+
+/* udata.c */
+void nvmet_mdev_udata_iter_setup(struct nvmet_mdev_viommu *viommu,
+				 struct nvmet_ext_data_iter *iter,
+				 struct list_head *maps_list);
+int nvmet_mdev_udata_iter_set_dptr(struct nvmet_ext_data_iter *it,
+				   const union nvme_data_ptr *dptr, u64 size);
+void *nvmet_mdev_udata_update_queue_vmap(struct nvmet_mdev_viommu *viommu,
+					 dma_addr_t iova, void *data,
+					 unsigned int data_size);
+void nvmet_mdev_udata_queue_vunmap(struct nvmet_mdev_viommu *viommu,
+				   dma_addr_t iova, void *data,
+				   unsigned int data_size);
+
+/* viommu.c */
+void nvmet_mdev_viommu_init(struct nvmet_mdev_viommu *viommu,
+			    struct vfio_device *vfio_dev);
+int nvmet_mdev_viommu_add(struct nvmet_mdev_viommu *viommu, u32 flags,
+			  dma_addr_t iova, u64 size,
+			  struct list_head *maps_list);
+int nvmet_mdev_viommu_remove(struct nvmet_mdev_viommu *viommu,
+			     dma_addr_t iova, u64 size);
+int nvmet_mdev_viommu_remove_list(struct nvmet_mdev_viommu *viommu,
+				  struct list_head *remove_list);
+int nvmet_mdev_viommu_translate(struct nvmet_mdev_viommu *viommu,
+				dma_addr_t iova, dma_addr_t *physical);
+int nvmet_mdev_viommu_create_kmap(struct nvmet_mdev_viommu *viommu,
+				  dma_addr_t iova, struct page_map *page);
+void nvmet_mdev_viommu_free_kmap(struct nvmet_mdev_viommu *viommu,
+				 struct page_map *page);
+void nvmet_mdev_viommu_update_kmap(struct nvmet_mdev_viommu *viommu,
+				   struct page_map *page);
+void nvmet_mdev_viommu_reset(struct nvmet_mdev_viommu *viommu);
+
+/* instance.c */
+int nvmet_mdev_register_port(struct nvmet_mdev_port *mport);
+void nvmet_mdev_unregister_port(struct nvmet_mdev_port *mport);
+void nvmet_mdev_remove_ctrl(struct nvmet_mdev_vctrl *vctrl);
+
+/* some utilities*/
+
+#define store_le32(address, value) (*((__le32 *)(address)) = cpu_to_le32(value))
+#define store_le16(address, value) (*((__le16 *)(address)) = cpu_to_le16(value))
+#define store_le8(address, value)  (*((u8 *)(address)) = (value))
+
+#define load_le16(address) le16_to_cpu(*(__le16 *)(address))
+
+#define DNR(e) ((e) | NVME_STATUS_DNR)
+
+#define PAGE_ADDRESS(address) ((address) & PAGE_MASK)
+
+#define _DBG(vctrl, fmt, ...) \
+	dev_dbg(vctrl->vfio_dev.dev, fmt, ##__VA_ARGS__)
+
+#define _INFO(vctrl, fmt, ...) \
+	dev_info(vctrl->vfio_dev.dev, fmt, ##__VA_ARGS__)
+
+#define _WARN(vctrl, fmt, ...) \
+	dev_warn(vctrl->vfio_dev.dev, fmt, ##__VA_ARGS__)
+
+/* Rough translation of internal errors to the NVME errors */
+static inline int nvmet_mdev_translate_error(int error)
+{
+	/* nvme status, including no error (NVME_SC_SUCCESS) */
+	if (error >= 0)
+		return error;
+
+	switch (error) {
+	case -ENOMEM:
+		/* no memory - truly an internal error */
+		return NVME_SC_INTERNAL;
+	case -ENOSPC:
+		/*
+		 * Happens when user sends to large PRP list User shoudn't do
+		 * this since the maximum transfer size is specified in the
+		 * controller caps
+		 */
+		return DNR(NVME_SC_DATA_XFER_ERROR);
+	case -EFAULT:
+		/* Bad memory pointers in the prp lists */
+		return DNR(NVME_SC_DATA_XFER_ERROR);
+	case -EINVAL:
+		/* Bad prp offsets in the prp lists/command */
+		return DNR(NVME_SC_PRP_INVALID_OFFSET);
+	default:
+		/* Shouldn't happen */
+		WARN_ON_ONCE(true);
+		return NVME_SC_INTERNAL;
+	}
+}
+
+extern const struct nvmet_fabrics_ops nvmet_mdev_ops;
+
+#endif // _MDEV_NVME_H
diff --git a/drivers/nvme/target/mdev-pci/target.c b/drivers/nvme/target/mdev-pci/target.c
new file mode 100644
index 000000000000..1b688544db1e
--- /dev/null
+++ b/drivers/nvme/target/mdev-pci/target.c
@@ -0,0 +1,284 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * NVMe target callouts
+ * Copyright (c) 2019 - Maxim Levitsky
+ * Copyright (C) 2025 Oracle Corporation
+ */
+#include <linux/device.h>
+#include <linux/nvme.h>
+#include <linux/module.h>
+#include <linux/mdev.h>
+#include <linux/slab.h>
+#include "../nvmet.h"
+#include "../../host/nvme.h"
+#include "../../host/fabrics.h"
+#include "priv.h"
+
+static void nvmet_mdev_delete_ctrl(struct nvmet_ctrl *ctrl)
+{
+	struct nvmet_mdev_port *mport = ctrl->port->priv;
+
+	mutex_lock(&mport->mutex);
+	nvmet_mdev_remove_ctrl(ctrl->drvdata);
+	mutex_unlock(&mport->mutex);
+}
+
+static void nvmet_mdev_remove_port(struct nvmet_port *port)
+{
+	nvmet_mdev_unregister_port(port->priv);
+}
+
+static int nvmet_mdev_count_ctrls(void *priv, struct nvmet_port *port,
+				  struct nvmet_ctrl *ctrl)
+{
+	int *count = priv;
+
+	(*count)++;
+	return 0;
+}
+
+static int nvmet_mdev_add_port(struct nvmet_port *port)
+{
+	struct nvmet_mdev_port *mport;
+	int count = 0;
+	int ret;
+
+	ret = nvmet_for_each_static_ctrl(port, nvmet_mdev_ops.type,
+					 nvmet_mdev_count_ctrls, &count);
+	if (ret)
+		return ret;
+
+	if (!count) {
+		pr_err("Controllers must be added and enabled before enabling port.\n");
+		return -ENODEV;
+	}
+
+	mport = kzalloc(sizeof(*mport), GFP_KERNEL);
+	if (!mport)
+		return -ENOMEM;
+
+	mutex_init(&mport->mutex);
+	port->priv = mport;
+	mport->nvmet_port = port;
+	mport->ctrl_count = count;
+
+	return nvmet_mdev_register_port(mport);
+}
+
+static u16 nvmet_mdev_adm_create_cq(struct nvmet_ctrl *ctrl, u16 cqid,
+				    u16 cq_flags, u16 qsize, u64 prp1, u16 irq)
+{
+	struct nvmet_mdev_vctrl *vctrl = ctrl->drvdata;
+	u16 ret;
+
+	mutex_lock(&vctrl->lock);
+	if (cqid >= NVMET_MDEV_MAX_NR_QUEUES || test_bit(cqid, vctrl->vcq_en)) {
+		ret = DNR(NVME_SC_QID_INVALID);
+		goto unlock;
+	}
+
+	if (!(cq_flags & NVME_QUEUE_PHYS_CONTIG)) {
+		ret = DNR(NVME_SC_INVALID_QUEUE);
+		goto unlock;
+	}
+
+	if (cq_flags & NVME_CQ_IRQ_ENABLED) {
+		if (irq >= MAX_VIRTUAL_IRQS) {
+			ret = DNR(NVME_SC_INVALID_VECTOR);
+			goto unlock;
+		}
+	}
+
+	ret = nvmet_mdev_vcq_init(vctrl, cqid, prp1, qsize + 1, irq);
+unlock:
+	mutex_unlock(&vctrl->lock);
+	return ret;
+}
+
+static u16 nvmet_mdev_adm_delete_cq(struct nvmet_ctrl *ctrl, u16 cqid)
+{
+	struct nvmet_mdev_vctrl *vctrl = ctrl->drvdata;
+	u16 ret = NVME_SC_SUCCESS;
+
+	mutex_lock(&vctrl->lock);
+	if (cqid >= NVMET_MDEV_MAX_NR_QUEUES ||
+	    !test_bit(cqid, vctrl->vcq_en)) {
+		ret = DNR(NVME_SC_QID_INVALID);
+		goto unlock;
+	}
+
+	nvmet_mdev_vcq_delete(vctrl, cqid);
+unlock:
+	mutex_unlock(&vctrl->lock);
+	return ret;
+}
+
+static u16 nvmet_mdev_adm_create_sq(struct nvmet_ctrl *ctrl, u16 sqid,
+				    u16 sq_flags, u16 qsize, u64 prp1)
+{
+	struct nvmet_mdev_vctrl *vctrl = ctrl->drvdata;
+	u16 ret;
+
+	mutex_lock(&vctrl->lock);
+	if (sqid >= NVMET_MDEV_MAX_NR_QUEUES || test_bit(sqid, vctrl->vsq_en)) {
+		ret = DNR(NVME_SC_QID_INVALID);
+		goto unlock;
+	}
+
+	/*
+	 * sqid and cqid are checked they are equal by nvmet before calling
+	 * this
+	 */
+	if (!test_bit(sqid, vctrl->vcq_en)) {
+		ret = DNR(NVME_SC_CQ_INVALID);
+		goto unlock;
+	}
+
+	if (!(sq_flags & NVME_QUEUE_PHYS_CONTIG)) {
+		ret = DNR(NVME_SC_INVALID_QUEUE);
+		goto unlock;
+	}
+
+	ret = nvmet_mdev_vsq_init(vctrl, sqid, prp1, qsize + 1, sqid);
+unlock:
+	mutex_unlock(&vctrl->lock);
+	return ret;
+}
+
+static u16 nvmet_mdev_adm_delete_sq(struct nvmet_ctrl *ctrl, u16 sqid)
+{
+	struct nvmet_mdev_vctrl *vctrl = ctrl->drvdata;
+	u16 ret = NVME_SC_SUCCESS;
+
+	mutex_lock(&vctrl->lock);
+	if (sqid >= NVMET_MDEV_MAX_NR_QUEUES ||
+	    !test_bit(sqid, vctrl->vsq_en)) {
+		ret = DNR(NVME_SC_QID_INVALID);
+		goto unlock;
+	}
+
+	nvmet_mdev_vsq_delete(vctrl, sqid);
+unlock:
+	mutex_unlock(&vctrl->lock);
+	return ret;
+}
+
+static u16 nvmet_mdev_adm_get_features(const struct nvmet_ctrl *ctrl, u8 feat,
+				       void *feat_data)
+{
+	struct nvmet_mdev_vctrl *vctrl = ctrl->drvdata;
+	struct nvmet_feat_arbitration *arb;
+	struct nvmet_feat_irq_coalesce *irqc;
+	struct nvmet_feat_irq_config *irqcfg;
+
+	switch (feat) {
+	case NVME_FEAT_ARBITRATION:
+		arb = feat_data;
+
+		arb->ab = vctrl->arb_burst_shift;
+		break;
+	case NVME_FEAT_IRQ_COALESCE:
+		irqc = feat_data;
+
+		irqc->thr = vctrl->irqs.irq_coalesc_max - 1;
+
+		irqc->time = vctrl->irqs.irq_coalesc_time_us;
+		do_div(irqc->time, 100);
+		break;
+	case NVME_FEAT_IRQ_CONFIG:
+		irqcfg = feat_data;
+
+		if (irqcfg->iv >= MAX_VIRTUAL_IRQS)
+			return DNR(NVME_SC_INVALID_FIELD);
+
+		irqcfg->cd = vctrl->irqs.vecs[irqcfg->iv].irq_coalesc_en;
+		break;
+	default:
+		return DNR(NVME_SC_INVALID_FIELD);
+	}
+
+	return NVME_SC_SUCCESS;
+}
+
+static u16 nvmet_mdev_adm_set_features(const struct nvmet_ctrl *ctrl, u8 feat,
+				       void *feat_data)
+{
+	struct nvmet_mdev_vctrl *vctrl = ctrl->drvdata;
+	struct nvmet_feat_arbitration *arb;
+	struct nvmet_feat_irq_coalesce *irqc;
+	struct nvmet_feat_irq_config *irqcfg;
+
+	switch (feat) {
+	case NVME_FEAT_ARBITRATION:
+		arb = feat_data;
+
+		vctrl->arb_burst_shift = arb->ab;
+		break;
+	case NVME_FEAT_IRQ_COALESCE:
+		irqc = feat_data;
+
+		vctrl->irqs.irq_coalesc_max = irqc->thr + 1;
+		vctrl->irqs.irq_coalesc_time_us = irqc->time * 100;
+		break;
+	case NVME_FEAT_IRQ_CONFIG:
+		irqcfg = feat_data;
+
+		if (irqcfg->iv >= MAX_VIRTUAL_IRQS)
+			return DNR(NVME_SC_INVALID_FIELD);
+
+		vctrl->irqs.vecs[irqcfg->iv].irq_coalesc_en = irqcfg->cd != 0;
+		break;
+	default:
+		return DNR(NVME_SC_INVALID_FIELD);
+	}
+
+	return NVME_SC_SUCCESS;
+}
+
+static u16 nvmet_mdev_adm_set_dbbuf(struct nvmet_ctrl *ctrl, u64 prp1, u64 prp2)
+{
+	struct nvmet_mdev_vctrl *vctrl = ctrl->drvdata;
+	int ret;
+
+	if (!vctrl->mmio.shadow_db_supported)
+		return DNR(NVME_SC_INVALID_OPCODE);
+
+	if (vctrl->mmio.shadow_db_en)
+		return DNR(NVME_SC_INVALID_FIELD);
+
+	if ((offset_in_page(prp1) != 0) || (offset_in_page(prp2) != 0))
+		return DNR(NVME_SC_INVALID_FIELD);
+
+	ret = nvmet_mdev_mmio_enable_dbs_shadow(vctrl, prp1, prp2);
+	return nvmet_mdev_translate_error(ret);
+}
+
+static void nvmet_mdev_queue_response(struct nvmet_req *req)
+{
+	struct nvmet_mdev_req *mreq = container_of(req, struct nvmet_mdev_req,
+						   req);
+
+	llist_add(&mreq->cq_node, &mreq->vcq->mreq_list);
+}
+
+const struct nvmet_fabrics_ops nvmet_mdev_ops = {
+	.owner			= THIS_MODULE,
+	.flags			= NVMF_SGLS_NOT_SUPP | NVMF_STATIC_CTRL,
+	.type			= NVMF_TRTYPE_MDEV_PCI,
+	.delete_ctrl		= nvmet_mdev_delete_ctrl,
+	.add_port		= nvmet_mdev_add_port,
+	.remove_port		= nvmet_mdev_remove_port,
+	.create_cq		= nvmet_mdev_adm_create_cq,
+	.delete_cq		= nvmet_mdev_adm_delete_cq,
+	.create_sq		= nvmet_mdev_adm_create_sq,
+	.delete_sq		= nvmet_mdev_adm_delete_sq,
+	.set_feature		= nvmet_mdev_adm_set_features,
+	.get_feature		= nvmet_mdev_adm_get_features,
+	.set_dbbuf		= nvmet_mdev_adm_set_dbbuf,
+	.queue_response		= nvmet_mdev_queue_response,
+};
+
+MODULE_AUTHOR("Maxim Levitsky <mlevitsk@redhat.com>, "
+	      "Mike Christie <michael.christie@oracle.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("nvmet-transport-253"); /* 253 == NVMF_TRTYPE_MDEV_PCI */
diff --git a/drivers/nvme/target/mdev-pci/udata.c b/drivers/nvme/target/mdev-pci/udata.c
new file mode 100644
index 000000000000..9fa9f63e9d23
--- /dev/null
+++ b/drivers/nvme/target/mdev-pci/udata.c
@@ -0,0 +1,304 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * User (guest) data access routines
+ * Implementation of PRP iterator in user memory
+ * Copyright (c) 2019 - Maxim Levitsky
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/highmem.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/mdev.h>
+#include <linux/nvme.h>
+#include "priv.h"
+
+#define MAX_PRP ((PAGE_SIZE / sizeof(__le64)) - 1)
+
+/* Setup up a new PRP iterator */
+void nvmet_mdev_udata_iter_setup(struct nvmet_mdev_viommu *viommu,
+				 struct nvmet_ext_data_iter *iter,
+				 struct list_head *mem_map_list)
+{
+	memset(iter, 0, sizeof(*iter));
+	iter->viommu = viommu;
+	iter->mem_map_list = mem_map_list;
+}
+
+/* Load a new prp list into the iterator. Internal */
+static int nvmet_mdev_udata_iter_load_prplist(struct nvmet_ext_data_iter *iter,
+					      dma_addr_t iova)
+{
+	dma_addr_t  data_iova;
+	int ret;
+	__le64 *map;
+
+	ret = nvmet_mdev_viommu_add(iter->viommu,
+				    VFIO_DMA_MAP_FLAG_READ |
+				    VFIO_DMA_MAP_FLAG_WRITE, iova, PAGE_SIZE,
+				    iter->mem_map_list);
+	if (ret)
+		return ret;
+
+	/* map the prp list */
+	ret = nvmet_mdev_viommu_create_kmap(iter->viommu, PAGE_ADDRESS(iova),
+					    &iter->uprp.page);
+	if (ret)
+		return ret;
+
+	iter->uprp.index = offset_in_page(iova) / (sizeof(__le64));
+
+	/* read its first entry and check its alignment */
+	map = iter->uprp.page.kmap;
+	data_iova = le64_to_cpu(map[iter->uprp.index]);
+
+	if (offset_in_page(data_iova) != 0) {
+		nvmet_mdev_viommu_free_kmap(iter->viommu, &iter->uprp.page);
+		return -EINVAL;
+	}
+
+	ret = nvmet_mdev_viommu_add(iter->viommu,
+				    VFIO_DMA_MAP_FLAG_READ |
+				    VFIO_DMA_MAP_FLAG_WRITE, data_iova,
+				    PAGE_SIZE, iter->mem_map_list);
+	if (ret)
+		return ret;
+
+	/* translate the entry to complete the setup */
+	ret =  nvmet_mdev_viommu_translate(iter->viommu, data_iova,
+					   &iter->physical);
+	if (ret)
+		nvmet_mdev_viommu_free_kmap(iter->viommu, &iter->uprp.page);
+
+	return ret;
+}
+
+/* ->next function when iterator points to prp list */
+static int nvmet_mdev_udata_iter_next_prplist(struct nvmet_ext_data_iter *iter)
+{
+	dma_addr_t iova;
+	int ret;
+	__le64 *map = iter->uprp.page.kmap;
+
+	if (WARN_ON(iter->count <= 0))
+		return 0;
+
+	if (--iter->count == 0) {
+		nvmet_mdev_viommu_free_kmap(iter->viommu, &iter->uprp.page);
+		return 0;
+	}
+
+	iter->uprp.index++;
+
+	if (iter->uprp.index < MAX_PRP || iter->count == 1) {
+		/*
+		 * advance over next pointer in current prp list these
+		 * pointers must be page aligned
+		 */
+		iova = le64_to_cpu(map[iter->uprp.index]);
+		if (offset_in_page(iova) != 0)
+			return -EINVAL;
+
+		ret = nvmet_mdev_viommu_add(iter->viommu,
+					    VFIO_DMA_MAP_FLAG_READ |
+					    VFIO_DMA_MAP_FLAG_WRITE, iova,
+					    PAGE_SIZE, iter->mem_map_list);
+		if (ret)
+			return ret;
+
+		ret  = nvmet_mdev_viommu_translate(iter->viommu, iova,
+						   &iter->physical);
+		if (ret)
+			nvmet_mdev_viommu_free_kmap(iter->viommu,
+						    &iter->uprp.page);
+		return ret;
+	}
+
+	/* switch to next prp list. it must be page aligned as well */
+	iova = le64_to_cpu(map[MAX_PRP]);
+
+	if (offset_in_page(iova) != 0)
+		return -EINVAL;
+
+	nvmet_mdev_viommu_free_kmap(iter->viommu, &iter->uprp.page);
+	return nvmet_mdev_udata_iter_load_prplist(iter, iova);
+}
+
+/* ->next function when iterator points to user data pointer */
+static int nvmet_mdev_udata_iter_next_dptr(struct nvmet_ext_data_iter *iter)
+{
+	dma_addr_t  iova;
+	int ret;
+
+	if (WARN_ON(iter->count <= 0))
+		return 0;
+
+	if (--iter->count == 0)
+		return 0;
+
+	/*
+	 * we will be called only once to deal with the second
+	 * pointer in the data pointer
+	 */
+	iova = le64_to_cpu(iter->dptr->prp2);
+
+	if (iter->count == 1) {
+		/*
+		 * only need to read one more entry, meaning the 2nd entry of
+		 * the dptr. It must be page aligned
+		 */
+		if (offset_in_page(iova) != 0)
+			return -EINVAL;
+
+		/*
+		 * Size may be less than a page but it doesn't matter to
+		 * the viommu as we have to get the entire page either way.
+		 */
+		ret = nvmet_mdev_viommu_add(iter->viommu,
+					   VFIO_DMA_MAP_FLAG_READ |
+					   VFIO_DMA_MAP_FLAG_WRITE, iova,
+					   PAGE_SIZE, iter->mem_map_list);
+		if (ret)
+			return ret;
+
+		return nvmet_mdev_viommu_translate(iter->viommu, iova,
+						   &iter->physical);
+	} else {
+		/*
+		 * Second dptr entry is prp pointer, and it might not
+		 * be page aligned (but QWORD aligned at least)
+		 */
+		if (iova & 0x7ULL)
+			return -EINVAL;
+		iter->next = nvmet_mdev_udata_iter_next_prplist;
+		return nvmet_mdev_udata_iter_load_prplist(iter, iova);
+	}
+}
+
+static void nvmet_mdev_udata_iter_release(struct nvmet_ext_data_iter *iter)
+{
+	nvmet_mdev_viommu_free_kmap(iter->viommu, &iter->uprp.page);
+	nvmet_mdev_viommu_remove_list(iter->viommu, iter->mem_map_list);
+}
+
+/* Set prp list iterator to point to data pointer found in NVME command */
+int nvmet_mdev_udata_iter_set_dptr(struct nvmet_ext_data_iter *iter,
+				   const union nvme_data_ptr *dptr, u64 size)
+{
+	int ret;
+	u64 prp1 = le64_to_cpu(dptr->prp1);
+	dma_addr_t iova = PAGE_ADDRESS(prp1);
+	unsigned int page_offset = offset_in_page(prp1);
+
+	/* first dptr pointer must be at least DWORD aligned */
+	if (page_offset & 0x3)
+		return -EINVAL;
+
+	ret = nvmet_mdev_viommu_add(iter->viommu,
+				   VFIO_DMA_MAP_FLAG_READ |
+				   VFIO_DMA_MAP_FLAG_WRITE, iova, size,
+				   iter->mem_map_list);
+	if (ret)
+		return ret;
+
+	iter->dptr = dptr;
+	iter->next = nvmet_mdev_udata_iter_next_dptr;
+	iter->release = nvmet_mdev_udata_iter_release;
+	iter->count = DIV_ROUND_UP_ULL(size + page_offset, PAGE_SIZE);
+
+	ret = nvmet_mdev_viommu_translate(iter->viommu, iova, &iter->physical);
+	if (ret)
+		goto release;
+
+	iter->physical += page_offset;
+	return 0;
+
+release:
+	nvmet_mdev_udata_iter_release(iter);
+	return ret;
+}
+
+/* Map an SQ/CQ queue (contiguous in guest physical memory) */
+static int
+nvmet_mdev_queue_getpages_contiguous(struct nvmet_mdev_viommu *viommu,
+				     dma_addr_t iova, struct page **pages,
+				     unsigned int npages)
+{
+	dma_addr_t curr_iova = iova;
+	phys_addr_t physical;
+	unsigned int i;
+	int ret;
+
+	for (i = 0 ; i < npages; i++) {
+		ret = nvmet_mdev_viommu_add(viommu,
+					    VFIO_DMA_MAP_FLAG_READ |
+					    VFIO_DMA_MAP_FLAG_WRITE,
+					    curr_iova, PAGE_SIZE,
+					    &viommu->mem_map_list);
+		if (ret)
+			goto remove;
+
+		ret = nvmet_mdev_viommu_translate(viommu, curr_iova, &physical);
+		if (ret)
+			goto remove;
+
+		pages[i] = pfn_to_page(PHYS_PFN(physical));
+		curr_iova += PAGE_SIZE;
+	}
+	return 0;
+
+remove:
+	nvmet_mdev_viommu_remove(viommu, iova, npages * PAGE_SIZE);
+	return ret;
+}
+
+/* map a SQ/CQ queue to host physical memory */
+static void *nvmet_mdev_udata_queue_vmap(struct nvmet_mdev_viommu *viommu,
+					 dma_addr_t iova, unsigned int size)
+{
+	unsigned int npages;
+	struct page **pages;
+	void *map = NULL;
+
+	/* queue must be page aligned */
+	if (offset_in_page(iova) != 0)
+		return NULL;
+
+	npages = DIV_ROUND_UP(size, PAGE_SIZE);
+	pages = kcalloc(npages, sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		return NULL;
+
+	if (nvmet_mdev_queue_getpages_contiguous(viommu, iova, pages, npages))
+		goto out;
+
+	map = vmap(pages, npages, VM_MAP, PAGE_KERNEL);
+out:
+	kfree(pages);
+	return map;
+}
+
+void nvmet_mdev_udata_queue_vunmap(struct nvmet_mdev_viommu *viommu,
+				   dma_addr_t iova, void *data,
+				   unsigned int data_size)
+{
+	if (!data)
+		return;
+
+	vunmap(data);
+	nvmet_mdev_viommu_remove(viommu, iova,
+				 DIV_ROUND_UP(data_size, PAGE_SIZE));
+}
+
+void *nvmet_mdev_udata_update_queue_vmap(struct nvmet_mdev_viommu *viommu,
+					 dma_addr_t iova, void *data,
+					 unsigned int data_size)
+{
+	if (!iova)
+		return NULL;
+
+	if (data)
+		vunmap(data);
+
+	return nvmet_mdev_udata_queue_vmap(viommu, iova, data_size);
+}
diff --git a/drivers/nvme/target/mdev-pci/vcq.c b/drivers/nvme/target/mdev-pci/vcq.c
new file mode 100644
index 000000000000..22ac71a67a4c
--- /dev/null
+++ b/drivers/nvme/target/mdev-pci/vcq.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Virtual NVMe completion queue implementation
+ * Copyright (c) 2019 - Maxim Levitsky
+ * Copyright (C) 2025 Oracle Corporation
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include "priv.h"
+
+static int nvmet_mdev_calc_vcq_size(struct nvmet_mdev_vcq *vcq)
+{
+	return round_up(vcq->size * sizeof(struct nvme_completion), PAGE_SIZE);
+}
+
+/* Create new virtual completion queue */
+int nvmet_mdev_vcq_init(struct nvmet_mdev_vctrl *vctrl, u16 qid,
+			dma_addr_t iova, u16 size, int irq)
+{
+	struct nvmet_ctrl *ctrl = vctrl->nvmet_ctrl;
+	struct nvmet_mdev_vcq *q = &vctrl->vcqs[qid];
+
+	lockdep_assert_held(&vctrl->lock);
+
+	q->vctrl = vctrl;
+	q->qid = qid;
+	q->size = size;
+	q->tail = 0;
+	q->phase = 1;
+	q->irq = irq;
+	q->head = 0;
+	q->iova = iova;
+	q->data = NULL;
+	q->data_size = nvmet_mdev_calc_vcq_size(q);
+	init_llist_head(&q->mreq_list);
+
+	q->data = nvmet_mdev_udata_update_queue_vmap(&vctrl->viommu, q->iova,
+						     (void *)q->data,
+						     q->data_size);
+	if (!q->data)
+		goto delete;
+
+	_DBG(vctrl, "VCQ: create qid=%d depth=%d irq=%d\n", qid, size, irq);
+
+	vctrl->mmio.dbs[q->qid].cqh = 0;
+	vctrl->mmio.eidxs[q->qid].cqh = 0;
+
+	if (nvmet_cq_create(ctrl, &q->nvmet_cq, qid, size))
+		goto delete;
+
+	set_bit(qid, vctrl->vcq_en);
+	return NVME_SC_SUCCESS;
+
+delete:
+	nvmet_mdev_vcq_delete(vctrl, qid);
+	return NVME_SC_INTERNAL;
+}
+
+/* Delete a virtual completion queue */
+void nvmet_mdev_vcq_delete(struct nvmet_mdev_vctrl *vctrl, u16 qid)
+{
+	struct nvmet_mdev_vcq *q = &vctrl->vcqs[qid];
+
+	lockdep_assert_held(&vctrl->lock);
+
+	nvmet_mdev_udata_queue_vunmap(&vctrl->viommu, q->iova, (void *)q->data,
+				      q->data_size);
+	q->data = NULL;
+	q->iova = 0;
+	clear_bit(qid, vctrl->vcq_en);
+
+	_DBG(vctrl, "VCQ: delete qid=%d\n", q->qid);
+}
+
+/* Move queue tail one item forward */
+static void nvmet_mdev_vcq_advance_tail(struct nvmet_mdev_vcq *q)
+{
+	if (++q->tail == q->size) {
+		q->tail = 0;
+		q->phase ^= 1;
+	}
+}
+
+/* Move queue head one item forward */
+static void nvmet_mdev_vcq_advance_head(struct nvmet_mdev_vcq *q)
+{
+	q->head++;
+	if (q->head == q->size)
+		q->head = 0;
+}
+
+/* Process a virtual completion queue */
+void nvmet_mdev_vcq_process(struct nvmet_mdev_vctrl *vctrl,
+			    struct nvmet_mdev_vcq *q, bool trigger_irqs,
+			    ktime_t now)
+{
+	u16 new_head;
+	u32 eidx;
+
+	if (!vctrl->mmio.dbs || !vctrl->mmio.eidxs)
+		return;
+
+	new_head = le32_to_cpu(READ_ONCE(vctrl->mmio.dbs[q->qid].cqh));
+
+	if (new_head != q->head) {
+		/* bad tail - can't process */
+		if (!nvmet_mdev_mmio_db_check(vctrl, q->qid, q->size, new_head))
+			return;
+
+		while (q->head != new_head)
+			nvmet_mdev_vcq_advance_head(q);
+
+		eidx = q->head + (q->size >> 1);
+		if (eidx >= q->size)
+			eidx -= q->size;
+		WRITE_ONCE(vctrl->mmio.eidxs[q->qid].cqh, cpu_to_le32(eidx));
+	}
+
+	if (q->irq != -1 && trigger_irqs) {
+		if (q->tail != new_head)
+			nvmet_mdev_irq_cond_trigger(vctrl, q->irq, now);
+		else
+			nvmet_mdev_irq_clear(vctrl, q->irq, now);
+	}
+}
+
+/* flush interrupts on a completion queue */
+bool nvmet_mdev_vcq_flush(struct nvmet_mdev_vctrl *vctrl,
+			  struct nvmet_mdev_vcq *q, ktime_t now)
+{
+	u16 new_head = le32_to_cpu(READ_ONCE(vctrl->mmio.dbs[q->qid].cqh));
+
+	if (new_head == q->tail || q->irq == -1)
+		return false;
+
+	nvmet_mdev_irq_trigger(vctrl, q->irq);
+	nvmet_mdev_irq_clear(vctrl, q->irq, now);
+	return true;
+}
+
+void nvmet_mdev_vcq_write_cqe(struct nvmet_mdev_vctrl *vctrl,
+			      struct nvmet_mdev_vcq *q,
+			      struct nvme_completion *cqe)
+{
+	volatile u64 *qw = (u64 *)&q->data[q->tail];
+	u64 *data = (u64 *)cqe;
+
+	cqe->status = cqe->status | cpu_to_le16(q->phase);
+
+	WRITE_ONCE(qw[0], data[0]);
+	/* ensure that hardware sees the phase bit flip last */
+	wmb();
+	WRITE_ONCE(qw[1], data[1]);
+
+	nvmet_mdev_vcq_advance_tail(q);
+	if (q->irq != -1)
+		nvmet_mdev_irq_raise(vctrl, q->irq);
+}
diff --git a/drivers/nvme/target/mdev-pci/vctrl.c b/drivers/nvme/target/mdev-pci/vctrl.c
new file mode 100644
index 000000000000..0568bec52f56
--- /dev/null
+++ b/drivers/nvme/target/mdev-pci/vctrl.c
@@ -0,0 +1,260 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Virtual NVMe controller implementation
+ * Copyright (c) 2019 - Maxim Levitsky
+ */
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/mdev.h>
+#include <linux/nvme.h>
+#include "priv.h"
+
+bool nvmet_mdev_vctrl_is_dead(struct nvmet_mdev_vctrl *vctrl)
+{
+	return (vctrl->mmio.csts & (NVME_CSTS_CFS | NVME_CSTS_SHST_MASK)) != 0;
+}
+
+/* Create a new virtual controller */
+int nvmet_mdev_vctrl_create(struct nvmet_mdev_vctrl *vctrl,
+			   struct mdev_device *mdev)
+{
+	int ret;
+
+	/* Basic init */
+	vctrl->mdev = mdev;
+	vctrl->viommu.vctrl = vctrl;
+
+	kref_init(&vctrl->ref);
+	mutex_init(&vctrl->lock);
+
+	/* default feature values */
+	vctrl->arb_burst_shift = 3;
+	vctrl->mmio.shadow_db_supported = vctrl->nvmet_ctrl->shadow_db;
+
+	ret = nvmet_mdev_pci_create(vctrl);
+	if (ret)
+		return ret;
+
+	ret = nvmet_mdev_mmio_create(vctrl);
+	if (ret)
+		goto free_pci;
+
+	nvmet_mdev_irqs_setup(vctrl);
+
+	ret = nvmet_mdev_io_create(vctrl);
+	if (ret)
+		goto free_mmio;
+
+	_INFO(vctrl, "device created\n");
+	return 0;
+
+free_mmio:
+	nvmet_mdev_mmio_free(vctrl);
+free_pci:
+	nvmet_mdev_pci_free(vctrl);
+	return ret;
+}
+
+/* Try to destroy an vctrl */
+void nvmet_mdev_vctrl_destroy(struct nvmet_mdev_vctrl *vctrl)
+{
+	mutex_unlock(&vctrl->lock);
+
+	mutex_lock(&vctrl->lock); /* only for lockdep checks */
+	nvmet_mdev_io_free(vctrl);
+	__nvmet_mdev_vctrl_reset(vctrl, true);
+
+	nvmet_mdev_pci_free(vctrl);
+	nvmet_mdev_mmio_free(vctrl);
+
+	mutex_unlock(&vctrl->lock);
+
+	_INFO(vctrl, "device is destroyed\n");
+}
+
+/* Called when new mediated device is first opened by a user */
+int nvmet_mdev_vctrl_open(struct vfio_device *vfio_dev)
+{
+	struct nvmet_mdev_vctrl *vctrl = vfio_dev_to_nvmet_mdev_vctrl(vfio_dev);
+
+	_INFO(vctrl, "device is opened\n");
+
+	mutex_lock(&vctrl->lock);
+	nvmet_mdev_viommu_init(&vctrl->viommu, vfio_dev);
+	nvmet_mdev_mmio_open(vctrl);
+	mutex_unlock(&vctrl->lock);
+	return 0;
+}
+
+/* Called when new mediated device is closed (last close of the user) */
+void nvmet_mdev_vctrl_release(struct vfio_device *vfio_dev)
+{
+	struct nvmet_mdev_vctrl *vctrl = vfio_dev_to_nvmet_mdev_vctrl(vfio_dev);
+
+	mutex_lock(&vctrl->lock);
+	nvmet_mdev_io_pause(vctrl);
+	/*
+	 * Remove the guest DMA mappings - new user that will open the
+	 * device might be a different guest
+	 */
+	nvmet_mdev_viommu_reset(&vctrl->viommu);
+
+	/* Reset the controller to a clean state for a new user */
+	__nvmet_mdev_vctrl_reset(vctrl, false);
+	nvmet_mdev_irqs_reset(vctrl);
+	mutex_unlock(&vctrl->lock);
+
+	_INFO(vctrl, "device is released\n");
+}
+
+/* Called each time the controller is reset (CC.EN <= 0 or VM level reset) */
+void __nvmet_mdev_vctrl_reset(struct nvmet_mdev_vctrl *vctrl, bool pci_reset)
+{
+	lockdep_assert_held(&vctrl->lock);
+
+	if ((vctrl->mmio.csts & NVME_CSTS_RDY) &&
+	    !(vctrl->mmio.csts & NVME_CSTS_SHST_MASK)) {
+		_DBG(vctrl, "unsafe reset (CSTS.RDY==1)\n");
+		nvmet_mdev_io_pause(vctrl);
+		nvmet_mdev_vctrl_disable(vctrl);
+	}
+	nvmet_mdev_mmio_reset(vctrl, pci_reset);
+}
+
+/* setups initial admin queues and doorbells */
+bool nvmet_mdev_vctrl_enable(struct nvmet_mdev_vctrl *vctrl, dma_addr_t cqiova,
+			     dma_addr_t sqiova, u32 sizes)
+{
+	struct nvmet_ctrl *ctrl = vctrl->nvmet_ctrl;
+	u16 cqentries, sqentries;
+	int ret;
+
+	nvmet_mdev_assert_io_not_running(vctrl);
+
+	lockdep_assert_held(&vctrl->lock);
+
+	sqentries = (sizes & 0xFFFF) + 1;
+	cqentries = (sizes >> 16) + 1;
+
+	if (cqentries > 4096 || cqentries < 2)
+		return false;
+	if (sqentries > 4096 || sqentries < 2)
+		return false;
+
+	ret = nvmet_mdev_mmio_enable_dbs(vctrl);
+	if (ret)
+		return false;
+
+	ret = nvmet_mdev_vcq_init(vctrl, 0, cqiova, cqentries, 0);
+	if (ret)
+		goto disable_dbs;
+
+	ret = nvmet_mdev_vsq_init(vctrl, 0, sqiova, sqentries, 0);
+	if (ret)
+		goto delete_vcq;
+
+	nvmet_update_cc(ctrl, vctrl->mmio.cc);
+	if (ctrl->csts != NVME_CSTS_RDY)
+		goto delete_vsq;
+
+	if (!vctrl->mmio.shadow_db_supported) {
+		/* start polling right away to support admin queue */
+		vctrl->io_idle = false;
+		nvmet_mdev_io_resume(vctrl);
+	}
+
+	return true;
+
+delete_vsq:
+	nvmet_mdev_vsq_delete(vctrl, 0);
+delete_vcq:
+	nvmet_mdev_vcq_delete(vctrl, 0);
+disable_dbs:
+	nvmet_mdev_mmio_disable_dbs(vctrl);
+	return false;
+}
+
+/* destroy all io/admin queues on the controller */
+void nvmet_mdev_vctrl_disable(struct nvmet_mdev_vctrl *vctrl)
+{
+	u16 sqid, cqid;
+
+	nvmet_mdev_assert_io_not_running(vctrl);
+
+	lockdep_assert_held(&vctrl->lock);
+
+	sqid = 1;
+	for_each_set_bit_from(sqid, vctrl->vsq_en, NVMET_MDEV_MAX_NR_QUEUES)
+		nvmet_mdev_vsq_delete(vctrl, sqid);
+
+	cqid = 1;
+	for_each_set_bit_from(cqid, vctrl->vcq_en, NVMET_MDEV_MAX_NR_QUEUES)
+		nvmet_mdev_vcq_delete(vctrl, cqid);
+
+	nvmet_mdev_vsq_delete(vctrl, 0);
+	nvmet_mdev_vcq_delete(vctrl, 0);
+
+	nvmet_mdev_mmio_disable_dbs(vctrl);
+	vctrl->io_idle = true;
+}
+
+/* External reset */
+void nvmet_mdev_vctrl_reset(struct nvmet_mdev_vctrl *vctrl)
+{
+	mutex_lock(&vctrl->lock);
+	_INFO(vctrl, "reset\n");
+	__nvmet_mdev_vctrl_reset(vctrl, true);
+	mutex_unlock(&vctrl->lock);
+}
+
+/* Add IO region */
+void nvmet_mdev_vctrl_add_region(struct nvmet_mdev_vctrl *vctrl,
+				 unsigned int index, unsigned int size,
+				 region_access_fn access_fn)
+{
+	struct nvmet_mdev_io_region *region = &vctrl->regions[index];
+
+	region->size = size;
+	region->rw = access_fn;
+	region->mmap_ops = NULL;
+}
+
+/* Enable mmap window on an IO region */
+void nvmet_mdev_vctrl_region_set_mmap(struct nvmet_mdev_vctrl *vctrl,
+				      unsigned int index,
+				      unsigned int offset,
+				      unsigned int size,
+				      const struct vm_operations_struct *ops)
+{
+	struct nvmet_mdev_io_region *region = &vctrl->regions[index];
+
+	region->mmap_area_start = offset;
+	region->mmap_area_size = size;
+	region->mmap_ops = ops;
+}
+
+/* Disable mmap window on an IO region */
+void nvmet_mdev_vctrl_region_disable_mmap(struct nvmet_mdev_vctrl *vctrl,
+					  unsigned int index)
+{
+	struct nvmet_mdev_io_region *region = &vctrl->regions[index];
+
+	region->mmap_area_start = 0;
+	region->mmap_area_size = 0;
+	region->mmap_ops = NULL;
+}
+
+/* remove a user memory mapping */
+int nvmet_mdev_vctrl_viommu_unmap(struct nvmet_mdev_vctrl *vctrl,
+				  dma_addr_t iova, u64 size)
+{
+	bool paused;
+	int ret;
+
+	paused = nvmet_mdev_io_pause(vctrl);
+	ret = nvmet_mdev_viommu_remove(&vctrl->viommu, iova, size);
+	if (paused)
+		nvmet_mdev_io_resume(vctrl);
+	return ret;
+}
diff --git a/drivers/nvme/target/mdev-pci/viommu.c b/drivers/nvme/target/mdev-pci/viommu.c
new file mode 100644
index 000000000000..9ef4281a87da
--- /dev/null
+++ b/drivers/nvme/target/mdev-pci/viommu.c
@@ -0,0 +1,308 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Virtual IOMMU - mapping user memory to the real device
+ * Copyright (c) 2019 - Maxim Levitsky
+ */
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/highmem.h>
+#include <linux/slab.h>
+#include <linux/mdev.h>
+#include <linux/vmalloc.h>
+#include <linux/nvme.h>
+#include <linux/iommu.h>
+#include <linux/interval_tree_generic.h>
+#include "priv.h"
+
+struct mem_mapping {
+	struct rb_node rb;
+	struct list_head link;
+
+	dma_addr_t __subtree_last;
+	dma_addr_t iova_start; /* first iova in this mapping */
+	dma_addr_t iova_last;  /* last iova in this mapping */
+
+	unsigned long pfn;  /* physical address of this mapping */
+	int refcount;
+};
+
+#define map_len(m) (((m)->iova_last - (m)->iova_start) + 1ULL)
+#define map_pages(m) (map_len(m) >> PAGE_SHIFT)
+#define START(node) ((node)->iova_start)
+#define LAST(node) ((node)->iova_last)
+
+INTERVAL_TREE_DEFINE(struct mem_mapping, rb, dma_addr_t, __subtree_last,
+		     START, LAST, static inline, viommu_int_tree);
+
+static void nvmet_mdev_viommu_dbg_dma_range(struct nvmet_mdev_viommu *viommu,
+					    struct mem_mapping *map,
+					    const char *action)
+{
+	dma_addr_t iova_start  = map->iova_start;
+	dma_addr_t iova_end    = map->iova_start + map_len(map) - 1;
+
+	_DBG(viommu->vctrl, "vIOMMU: %s RW IOVA %pad-%pad",
+	     action, &iova_start, &iova_end);
+}
+
+/* unpin N pages starting at given IOVA */
+static void nvmet_mdev_viommu_unpin_pages(struct nvmet_mdev_viommu *viommu,
+					  dma_addr_t iova, int n)
+{
+	int i, npages;
+
+	for (i = 0; i < n; i += npages) {
+		npages = min_t(int, VFIO_PIN_PAGES_MAX_ENTRIES, n);
+
+		vfio_unpin_pages(viommu->vfio_dev, iova + (i * PAGE_SIZE),
+				 npages);
+	}
+}
+
+/* User memory init code */
+void nvmet_mdev_viommu_init(struct nvmet_mdev_viommu *viommu,
+			    struct vfio_device *vfio_dev)
+{
+	viommu->vfio_dev = vfio_dev;
+	viommu->maps_tree = RB_ROOT_CACHED;
+	INIT_LIST_HEAD(&viommu->mem_map_list);
+}
+
+int nvmet_mdev_viommu_remove_list(struct nvmet_mdev_viommu *viommu,
+				  struct list_head *remove_list)
+{
+	struct mem_mapping *map, *tmp;
+	int count = 0;
+
+	list_for_each_entry_safe(map, tmp, remove_list, link) {
+		list_del(&map->link);
+
+		nvmet_mdev_viommu_unpin_pages(viommu, map->iova_start,
+					      map_pages(map));
+		viommu_int_tree_remove(map, &viommu->maps_tree);
+		kfree(map);
+		count++;
+	}
+	return count;
+}
+
+/* User memory end code */
+void nvmet_mdev_viommu_reset(struct nvmet_mdev_viommu *viommu)
+{
+	nvmet_mdev_viommu_remove_list(viommu, &viommu->mem_map_list);
+	WARN_ON(!list_empty(&viommu->mem_map_list));
+}
+
+/* Adds a new range of user memory */
+int nvmet_mdev_viommu_add(struct nvmet_mdev_viommu *viommu, u32 flags,
+			  dma_addr_t iova, u64 size,
+			  struct list_head *mem_map_list)
+{
+	struct vfio_device *vfio_dev = viommu->vfio_dev;
+	struct nvmet_mdev_vctrl *vctrl = vfio_dev_to_nvmet_mdev_vctrl(vfio_dev);
+	dma_addr_t iova_curr, iova_end, iova_start;
+	struct mem_mapping *map = NULL, *tmp;
+	LIST_HEAD(new_mappings_list);
+	int ret, count = 0;
+
+	/*
+	 * iova/size may not be page aligned if this is for IO. We align
+	 * them here because the viommu requires it.
+	 */
+	iova_start = iova;
+	if (!PAGE_ALIGNED(iova_start)) {
+		iova_start = PAGE_ALIGN_DOWN(iova_start);
+		_DBG(vctrl, "vIOMMU: realign iova %pad -> %pad\n",
+		     &iova, &iova_start);
+	}
+
+	iova_end = iova + size;
+	if (!PAGE_ALIGNED(iova_end)) {
+		iova_end = PAGE_ALIGN(iova_end);
+		_DBG(vctrl,
+		     "vIOMMU: realign size %llu -> %llu\n",
+		     size, PAGE_ALIGN(size));
+	}
+
+	if (!(flags & VFIO_DMA_MAP_FLAG_READ) ||
+	    !(flags & VFIO_DMA_MAP_FLAG_WRITE)) {
+		const char *type = "none";
+
+		if (flags & VFIO_DMA_MAP_FLAG_READ)
+			type = "RO";
+		else if (flags & VFIO_DMA_MAP_FLAG_WRITE)
+			type = "WO";
+
+		_DBG(viommu->vctrl, "vIOMMU: IGN %s IOVA %pad-%pad\n",
+		     type, &iova_start, &iova_end);
+		return 0;
+	}
+
+	/* VFIO pinning all the pages */
+	for (iova_curr = iova_start; iova_curr < iova_end;
+	     iova_curr += PAGE_SIZE) {
+		struct page *page;
+
+		ret = vfio_pin_pages(viommu->vfio_dev, iova_curr, 1,
+				     VFIO_DMA_MAP_FLAG_READ |
+				     VFIO_DMA_MAP_FLAG_WRITE,
+				     &page);
+		if (ret != 1) {
+			_DBG(viommu->vctrl,
+			     "vIOMMU: ADD RW IOVA %pad len: %llu - pin failed %d\n",
+			     &iova, size, ret);
+			goto unwind;
+		}
+
+		/* new mapping needed */
+		if (!map || map->pfn + map_pages(map) != page_to_pfn(page)) {
+			map = kzalloc(sizeof(*map), GFP_KERNEL);
+			if (!map) {
+				vfio_unpin_pages(viommu->vfio_dev, iova_curr,
+						 1);
+				ret = -ENOMEM;
+				goto unwind;
+			}
+			map->iova_start = iova_curr;
+			map->iova_last = iova_curr + PAGE_SIZE - 1ULL;
+			map->pfn = page_to_pfn(page);
+			map->refcount = 1;
+			INIT_LIST_HEAD(&map->link);
+			list_add_tail(&map->link, &new_mappings_list);
+		} else {
+			/* current map can be extended */
+			map->iova_last += PAGE_SIZE;
+		}
+	}
+
+	/* DMA mapping the pages */
+	list_for_each_entry_safe(map, tmp, &new_mappings_list, link) {
+		nvmet_mdev_viommu_dbg_dma_range(viommu, map, "ADD");
+		list_move_tail(&map->link, mem_map_list);
+		viommu_int_tree_insert(map, &viommu->maps_tree);
+		count++;
+	}
+
+	_DBG(viommu->vctrl, "vIOMMU: ADD RW IOVA %pad-%pad len %llu count %d\n",
+	     &iova_start, &iova_end, size, count);
+
+	return 0;
+unwind:
+	list_for_each_entry_safe(map, tmp, &new_mappings_list, link) {
+		nvmet_mdev_viommu_unpin_pages(viommu, map->iova_start,
+					      map_pages(map));
+
+		list_del(&map->link);
+		kfree(map);
+	}
+	return ret;
+}
+
+/* Removes a range of user memory */
+int nvmet_mdev_viommu_remove(struct nvmet_mdev_viommu *viommu, dma_addr_t iova,
+			     u64 size)
+{
+	dma_addr_t last_iova = iova + (size) - 1ULL;
+	struct mem_mapping *map;
+	LIST_HEAD(remove_list);
+	int count = 0;
+
+	/* find out all the relevant ranges */
+	map = viommu_int_tree_iter_first(&viommu->maps_tree, iova, last_iova);
+	while (map) {
+		list_move_tail(&map->link, &remove_list);
+		map = viommu_int_tree_iter_next(map, iova, last_iova);
+	}
+
+	/* remove them */
+	count = nvmet_mdev_viommu_remove_list(viommu, &remove_list);
+	return count;
+}
+
+/* Translate an IOVA to a physical address and read device bus address */
+int nvmet_mdev_viommu_translate(struct nvmet_mdev_viommu *viommu,
+				dma_addr_t iova, dma_addr_t *physical)
+{
+	struct mem_mapping *mapping;
+	u64 offset;
+
+	if (WARN_ON_ONCE(offset_in_page(iova) != 0))
+		return -EINVAL;
+
+	mapping = viommu_int_tree_iter_first(&viommu->maps_tree,
+					     iova, iova + PAGE_SIZE - 1);
+	if (!mapping) {
+		_DBG(viommu->vctrl,
+		     "vIOMMU: translation of IOVA %pad failed\n", &iova);
+		return -EFAULT;
+	}
+
+	WARN_ON(iova > mapping->iova_last);
+	WARN_ON(offset_in_page(mapping->iova_start) != 0);
+
+	offset = iova - mapping->iova_start;
+	*physical = PFN_PHYS(mapping->pfn) + offset;
+	return 0;
+}
+
+/* map an IOVA to kernel address space  */
+int nvmet_mdev_viommu_create_kmap(struct nvmet_mdev_viommu *viommu,
+				  dma_addr_t iova, struct page_map *page)
+{
+	phys_addr_t physical;
+	struct page *new_page;
+	int ret;
+
+	page->iova = iova;
+
+	ret = nvmet_mdev_viommu_translate(viommu, iova, &physical);
+	if (ret)
+		return ret;
+
+	new_page = pfn_to_page(PHYS_PFN(physical));
+
+	page->kmap = kmap_local_page(new_page);
+	if (!page->kmap)
+		return -ENOMEM;
+
+	page->page = new_page;
+	return 0;
+}
+
+/* update IOVA <-> kernel mapping. If fails, removes the previous mapping */
+void nvmet_mdev_viommu_update_kmap(struct nvmet_mdev_viommu *viommu,
+				   struct page_map *page)
+{
+	phys_addr_t physical;
+	struct page *new_page;
+	int ret;
+
+	ret = nvmet_mdev_viommu_translate(viommu, page->iova, &physical);
+	if (ret) {
+		nvmet_mdev_viommu_free_kmap(viommu, page);
+		return;
+	}
+
+	new_page = pfn_to_page(PHYS_PFN(physical));
+	if (new_page == page->page)
+		return;
+
+	nvmet_mdev_viommu_free_kmap(viommu, page);
+
+	page->kmap = kmap_local_page(new_page);
+	if (!page->kmap)
+		return;
+	page->page = new_page;
+}
+
+/* unmap an IOVA to kernel address space  */
+void nvmet_mdev_viommu_free_kmap(struct nvmet_mdev_viommu *viommu,
+				 struct page_map *page)
+{
+	if (page->page) {
+		kunmap_local(page->kmap);
+		page->page = NULL;
+		page->kmap = NULL;
+	}
+}
diff --git a/drivers/nvme/target/mdev-pci/vsq.c b/drivers/nvme/target/mdev-pci/vsq.c
new file mode 100644
index 000000000000..69e82b29cc4a
--- /dev/null
+++ b/drivers/nvme/target/mdev-pci/vsq.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Virtual NVMe submission queue implementation
+ * Copyright (c) 2019 - Maxim Levitsky
+ * Copyright (C) 2025 Oracle Corporation
+ */
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include "priv.h"
+
+static int nvmet_mdev_calc_vsq_size(struct nvmet_mdev_vsq *vsq)
+{
+	return round_up(vsq->size * sizeof(struct nvme_command), PAGE_SIZE);
+}
+
+/* Delete an virtual completion queue */
+void nvmet_mdev_vsq_delete(struct nvmet_mdev_vctrl *vctrl, u16 qid)
+{
+	struct nvmet_mdev_vsq *q = &vctrl->vsqs[qid];
+	bool paused;
+
+	lockdep_assert_held(&vctrl->lock);
+	_DBG(vctrl, "VSQ: delete qid=%d\n", q->qid);
+
+	/*
+	 * If this is an unclean shutdown make sure we don't try to start
+	 * new IOs after we free the queue.
+	 */
+	paused = nvmet_mdev_io_pause(vctrl);
+	clear_bit(qid, vctrl->vsq_en);
+	if (paused)
+		nvmet_mdev_io_resume(vctrl);
+
+	if (q->nvmet_sq.ctrl)
+		nvmet_sq_destroy(&q->nvmet_sq);
+
+	/*
+	 * The nvmet sq destruction just waits for the queue_response callout
+	 * to return, so we could still have completions queued. Flush
+	 * them now since we are freeing the queue below.
+	 */
+	if (test_and_clear_bit(qid, vctrl->vcq_en)) {
+		paused = nvmet_mdev_io_pause(vctrl);
+		nvmet_mdev_process_responses(vctrl, q->vcq);
+		if (paused)
+			nvmet_mdev_io_resume(vctrl);
+	}
+
+	kfree(q->reqs);
+
+	nvmet_mdev_udata_queue_vunmap(&vctrl->viommu, q->iova, q->data,
+				      q->data_size);
+	q->data = NULL;
+	q->iova = 0;
+}
+
+/* Create new virtual completion queue */
+int nvmet_mdev_vsq_init(struct nvmet_mdev_vctrl *vctrl, u16 qid,
+			dma_addr_t iova, u16 size, u16 cqid)
+{
+	struct nvmet_ctrl *ctrl = vctrl->nvmet_ctrl;
+	struct nvmet_mdev_vsq *q = &vctrl->vsqs[qid];
+
+	lockdep_assert_held(&vctrl->lock);
+
+	q->vctrl = vctrl;
+	q->qid = qid;
+	q->size = size;
+	q->head = 0;
+	q->vcq = &vctrl->vcqs[cqid];
+	q->data = NULL;
+	q->iova = iova;
+	q->data_size = nvmet_mdev_calc_vsq_size(q);
+
+	_DBG(vctrl, "VSQ: create qid=%d depth=%d cqid=%d\n", qid, size, cqid);
+
+	q->data = nvmet_mdev_udata_update_queue_vmap(&vctrl->viommu, q->iova,
+						     q->data, q->data_size);
+	if (!q->data)
+		goto delete;
+
+	q->reqs = kcalloc(size, sizeof(*q->reqs), GFP_KERNEL);
+	if (!q->reqs)
+		goto delete;
+
+	vctrl->mmio.dbs[q->qid].sqt = 0;
+	vctrl->mmio.eidxs[q->qid].sqt = 0;
+
+	if (nvmet_sq_create(ctrl, &q->nvmet_sq, qid, size))
+		goto delete;
+
+	set_bit(qid, vctrl->vsq_en);
+	return NVME_SC_SUCCESS;
+
+delete:
+	nvmet_mdev_vsq_delete(vctrl, qid);
+	return NVME_SC_INTERNAL;
+}
+
+/* Move queue head one item forward */
+static void nvmet_mdev_vsq_advance_head(struct nvmet_mdev_vsq *q)
+{
+	q->head++;
+	if (q->head == q->size)
+		q->head = 0;
+}
+
+static bool nvmet_mdev_vsq_has_data(struct nvmet_mdev_vctrl *vctrl,
+				    struct nvmet_mdev_vsq *q)
+{
+	u16 tail = le32_to_cpu(READ_ONCE(vctrl->mmio.dbs[q->qid].sqt));
+
+	if (!vctrl->mmio.dbs || !vctrl->mmio.eidxs || !q->data)
+		return false;
+
+	if  (tail == q->head)
+		return false;
+
+	if (!nvmet_mdev_mmio_db_check(vctrl, q->qid, q->size, tail))
+		return false;
+	return true;
+}
+
+/* get one command from a virtual submission queue */
+struct nvme_command *nvmet_mdev_vsq_get_cmd(struct nvmet_mdev_vctrl *vctrl,
+					    struct nvmet_mdev_vsq *q,
+					    u16 *index)
+{
+	u16 oldhead = q->head;
+	u32 eidx;
+
+	if (!nvmet_mdev_vsq_has_data(vctrl, q))
+		return NULL;
+
+	nvmet_mdev_vsq_advance_head(q);
+
+	eidx = q->head + (q->size >> 1);
+	if (eidx >= q->size)
+		eidx -= q->size;
+
+	WRITE_ONCE(vctrl->mmio.eidxs[q->qid].sqt, cpu_to_le32(eidx));
+
+	*index = oldhead;
+	return &q->data[oldhead];
+}
+
+bool nvmet_mdev_vsq_suspend_io(struct nvmet_mdev_vsq *q)
+{
+	struct nvmet_mdev_vctrl *vctrl = q->vctrl;
+	u16 tail = le32_to_cpu(vctrl->mmio.dbs[q->qid].sqt);
+
+	/*
+	 * If the queue is not in working state don't allow the idle code
+	 * to kick in
+	 */
+	if (!vctrl->mmio.dbs || !vctrl->mmio.eidxs || !q->data)
+		return false;
+
+	/* queue has data - refuse idle */
+	if (tail != q->head)
+		return false;
+
+	/* Write eventid to tell the user to ring normal doorbell */
+	vctrl->mmio.eidxs[q->qid].sqt = cpu_to_le32(q->head);
+
+	/* memory barrier to ensure that the user have seen the eidx */
+	mb();
+
+	/* Check that doorbell diddn't move meanwhile */
+	tail = le32_to_cpu(vctrl->mmio.dbs[q->qid].sqt);
+	return (tail == q->head);
+}
-- 
2.43.0



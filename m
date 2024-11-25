Return-Path: <kvm+bounces-32446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A14FC9D891B
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 16:21:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8478B450C1
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65B0B1B218E;
	Mon, 25 Nov 2024 14:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fS8mnoCW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IKz8XjLn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B840185B54
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 14:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732544862; cv=fail; b=jRlLiGywR7LNJ6a8O6ZQZ6z7tX49YqZR1pAyWX+hO6Tb0Ms8wPQQefkCXD+uAPRg37lD4ZkFhzfl0LENYiq4/jobMW+CcH5+BoMirMOjUIKLj6iOodyils9+uEU9leE8PlmZPg/bUDUr2OvsyAffsv3PxLLxZ2+1fgWSE8blUI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732544862; c=relaxed/simple;
	bh=c94GuPQlD86wwAKo2wUGTHGMlb38pzbNQlgk1SojkyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T6eLUGCt+sF8YrCxXUn8PYbk/LqRtQcDgxgp6X7bJ/59Xc7Im5F0oqE+Ba+AKs5gGqK2uN+fg+dMLXUVQOuvhal9FaZT7Sh+uNd61hWKjpv2b0PTJZgB/z71/HoIXLSqXCJlnyolDiPPXh29j7/D3ZO9xh5uwVguJDRci6Nj1JM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fS8mnoCW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IKz8XjLn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP6fcpQ006728;
	Mon, 25 Nov 2024 14:27:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=5A679e/2eKPMHKee/atd42aBQUwZQOa2Q2ipO/drAnU=; b=
	fS8mnoCWDxPD4D7IbS6ZmTD6KMxswooS3NMRrr1PQHMrctCAQEZH6xQ30y6+s9pq
	4w11xL8Po3/cDKdZAhaJpYY02BPDgBw+dPebsWbU7jPzwd9F86eWkr1dmgMIEwEx
	BQAso5q+TgKx0JFR6/aukiGYO1pVEzOjQZPGbHoWPB3EtKYmaHjo8hAMDRvHTvYv
	aG6x5Le0U6Dtt/O3lbnDIQHhibZ8iKpR7DZ6/ih2CnoU3JwQOgOTwSGAEfQPEGLY
	Y9DEnN0GZ4clcebfer7tSffEivJ1dVYIcT2VliJ2jtYMxiQt4FG8pGvDC33JmNls
	SakicwgcPTUM5VDBVWbk/A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43384au7a5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4APE8bJ8023429;
	Mon, 25 Nov 2024 14:27:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4335g7k1m7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rg2v6gWs7BotvhmioxEi1gIjPugmiBiKb+OZamyKeNZ3IfTTcyvhI7fxMjjmUz9nbyQpI/fbc4QmOI7RpTQdp8Pb14IJes3CjjFjnrV6UL/YfLfIvOeB6+Kqs7EXWoq7QrfZC0TSFQ9Z8zwO6ezrEO1nnAcDyGrvOnxJqLyDv+yIaN4CRBsYnZdXXst1gusxVyJD6fk0o0s3aBSUQL1y2DxU/LI5p9VZCyu23HURMWq8skFUU/eFYpOOfzvvdsW/gnefZ7gzvS3Xw9kWCfT2o5fl6ADQaW1jze3nZYm1nPKJzfy0oofaiam8pYi5QnzowqoGvF7Tlypj9pKKXlPR0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5A679e/2eKPMHKee/atd42aBQUwZQOa2Q2ipO/drAnU=;
 b=neP/EE9CxwxiObHr43g5fCMzJ0WpVAThWUMMMgqR6MKSxEnK1lvGBLmyGJ+8Tqkf629ngDk0lGZfFv6V2nT2ceZ5X2xKHtD/+bvbvsLfeyizsHL6ZMqwFm21Pz6tI32FSaogPBHpzyF0V4sf0GV+bVNIUGOaCueYOwkwhH6oWMUOkeI9UWcQbHcaBrtNOKnEn3/CZBw6cILN+Hwj9V+XcF7qcMxfjHlXrYoAiFuVyhDvDsgn1gEhpVD9q+haxfrUvPPNp+Mcx50QlWugmjYkrE0f/oqV2eM6jtQBRUtGsenCUcPxp4bfNcy4jQSz8+V2AtQFGkmG2hUc//zNnBud3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5A679e/2eKPMHKee/atd42aBQUwZQOa2Q2ipO/drAnU=;
 b=IKz8XjLna9T3HnN10McmnY2yJp4TpVz+FctYooKeA/ReBnYQpMi/g3sDQI9MCvfmDwCsNFGMO//ugATfmP6qOC9c3Irn2OJgOYLB/cXzUTUGEPaGVjqCVOr2xsONCj39jXiTDAom0sMeEGFcVyaibrJBR0EVxD1NRX5P/fEDL/I=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB5995.namprd10.prod.outlook.com (2603:10b6:208:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Mon, 25 Nov
 2024 14:27:23 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 14:27:23 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v3 2/7] system/physmem: poisoned memory discard on reboot
Date: Mon, 25 Nov 2024 14:27:13 +0000
Message-ID: <20241125142718.3373203-3-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241125142718.3373203-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY5PR19CA0084.namprd19.prod.outlook.com
 (2603:10b6:930:69::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 09049a0e-94ea-4702-976f-08dd0d5d471e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pilFt6GvHd3DCimyKy1A277mcVavihIo6hFA48TO/qct5or2QzGwW5ixmCpR?=
 =?us-ascii?Q?E+h72N7k/c9/sGZLzbOv7abiIpLu8KlK21eLVxcgYCKQ6zy3JEUP+JVbraxw?=
 =?us-ascii?Q?TnUXFBDe1Dn/sstMeGRzYsit9WFFA5An05WtvqFXrMl+rJO1lf4W8I3RNMXK?=
 =?us-ascii?Q?hLrz/6X0IS+lSkzK5h2z7nMPzGMloOYqqr+nFgzIEZA5jixPUNCpUiTbHM3x?=
 =?us-ascii?Q?zLZnnWO6a8KfAoYBMk7mYiYkfg/3nSgEhfgsp6fr5Ca+H6A9uNk+/3P0JSxH?=
 =?us-ascii?Q?gii92tMdGPaEdPCZaQ0mrSNnJadLglzFS72Qp45BaaPHPl0HAewZ8D/gTYNz?=
 =?us-ascii?Q?jPIljvpLzlHN+PYgCkpXpEQoWhIYlWpGoG9o+itIKuIJUqRoKldf60T8XTPa?=
 =?us-ascii?Q?ue9C5smBsdxM90zNjLr1NGP0sR1xmpGFJofxXGiAAsRuyEj5kw6eFHQ7YNcQ?=
 =?us-ascii?Q?8X0EaNCVSQ6fc04mOHzGIc0pcAFk/aOPQZRScmmIiQllHOR1SX0utyXKjpdi?=
 =?us-ascii?Q?VjEu6UR4wllOAiK30WvfXSxTQ5Af1Y+of0GvImOdX+RckrqJtGCOLfD7b6OM?=
 =?us-ascii?Q?8Pr8j1w+luv5SBs91AT9EM26uPEVw/Jpl2BZer0yzuuv6wQ8uzYcT8vvIxwf?=
 =?us-ascii?Q?glN3kl+OdtF35J2jqUX9S5nOMEi0T7aVMgbVnUCoElGFcVKHLr5u9wATnEz3?=
 =?us-ascii?Q?TeTadnlEmBKw3MLDaKnDbDdnLrsa9kX2SPI5NvmmcJ7QGZ9doF2rnmp8Itoy?=
 =?us-ascii?Q?Fm5j/rDvwTbOBbvO8IHuBtvMftGYRS38OTR8n1n0VChoQPB6AJTSw4lqBPL3?=
 =?us-ascii?Q?PHdH7oZwiNq8CT9XE3tnD84Tr90Hwmd8ncj9msTbztNk0Bj79ur54e4SKmJp?=
 =?us-ascii?Q?lNM5xgSwDsdUDoBOentq+KkffeygGRLvtA3gokCuMvMSreoelGscHd95xFKg?=
 =?us-ascii?Q?Eu8h/Hta/eOiFhHLZ4n02k0oUIRVEZrA5ZOK+xqTyMIyvUkNM0Nl8dtElCdV?=
 =?us-ascii?Q?Blnb9cVrgcGuzbQJcbeUAe8Waw/9mg9Ne/Nth0Oogfq1tHSs7nSCOXAZV+m8?=
 =?us-ascii?Q?jsWImBq2MEmRCTn0zuyoCQJi1JvxQnVM+OnCSYKQVcfFRb06XXb282W4cil/?=
 =?us-ascii?Q?bWw4Zm+CyYMLjCoUvrSyAk6TNkgBS7MKjSe5W7ou43cPea12L8r3otKnnx2F?=
 =?us-ascii?Q?xSp+T5jT5S2WFx2DPUFrQTcPJFPXWz86kytGRZ24YI27vN5rSlJZBCmuOjoQ?=
 =?us-ascii?Q?15YV6wbwLOHcZtXYcCWtdkyFEpKp736qz337mjJbrdvIj36rBDy22lzXYiND?=
 =?us-ascii?Q?CZsVT89WgGqWhqqfLzmlCB40FbnhnULNdAI0h3m5A+SNwA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RPzxHquCn6+4M3wqKZWcYYoJzmx4M+iWN3Nf3ifR4QPHnlLKdiViWZpA0tRb?=
 =?us-ascii?Q?Dns/7VC9VEkHgvBYNZsmm3qWdRHByk7DsZ19MbgWOq7RaYPiHB7II6L0km7N?=
 =?us-ascii?Q?z/vWoj1BP09RM09YaRm2DsqwHdnXBUDVxjphioZAc1Ae3VY+VYQQ/8w7LuZW?=
 =?us-ascii?Q?2t0csaGgvZlShrrqEpc4Lk8dZS9IgsJX7cnrpxBXjexOO9IV1rL5xfaaWWe2?=
 =?us-ascii?Q?lVIZhIyrqTxpssSXi4Fxo97kY1sIW5JTkItibAVkhgnXtiOUC98aaqI2eYu2?=
 =?us-ascii?Q?X+DjyJshjYRopWviG+TaPH6wTKFRduaBBu9VcT3GKjFV2xV6OiwoShZ5vjNf?=
 =?us-ascii?Q?T2iEW0hiYLLrEP03HbyIa4qXRGq7EMY9WkM2lBQQoApzV6vn0rucBYLazTac?=
 =?us-ascii?Q?Y2vz/amefg8ME7tWIjUB9WpP7kNTYK3FzCLftHtO8nfIEzYS5w59yjWwCewx?=
 =?us-ascii?Q?G3WvaSTvLL47E9D89WJeHD7rm+pFk94wsFxp+yL0/WgYji3owabT2t0nw47a?=
 =?us-ascii?Q?Dh6Tyb/cq/j3JGo3hkxnK1CZUvYU2MnpAkpb5o5C4av+NkL3xERX4aCSY3ir?=
 =?us-ascii?Q?c1X6v90+UGjcDJEOg5h1625i3IwSUKgYVekYwPJL3oJu8a170ee54MYThcS/?=
 =?us-ascii?Q?10/DmC+re/vumDB9lj55orXa566Iqyr2F/0CdX7BXATDm4M6Apmxr0b75JB1?=
 =?us-ascii?Q?vnqw6AFlUdsDNr1nsMJqoRihbSVJOz+EqYLnveUM526RKyxBuHmpEKeZ4FPN?=
 =?us-ascii?Q?Yf7IJHfO1BK++/MnfGHJPJfdH4jJiNKhGdXXQseqy7MQKE7xFeOeqEgEaJID?=
 =?us-ascii?Q?+wvhBJg1ynnxDCjcwguo0x8Rw3Hq8w1LxgquFnvHiTMjGcLjz7XjuJADeXs9?=
 =?us-ascii?Q?iubTNkUBga2TvuJpCrST7ZJqune8Tqxz50aYmERiWmlPZd/2rtOUhtpCs2oz?=
 =?us-ascii?Q?nlvudB6It9r734opVHnBomf36v17u3th1ImVmTpkluC48Q/q5ZqOj64xZE7n?=
 =?us-ascii?Q?9kC7biCNcB2tVugCOmIisXg8ABIhS07rdYsm8lVUL4gBteYMoMYyKB3M7/kc?=
 =?us-ascii?Q?ZHOTkVuj58HdjpJUX0PIXBvuOAQ2aaYj37asoEqq/BW2QoL+5VC8eaUQordb?=
 =?us-ascii?Q?3ZbPL+QfLJprZWWk1i/p3S3zVAw+6JJ1s8+PbMWTNDk/VSz+wumb6KM3MLwY?=
 =?us-ascii?Q?5TfIyiF1BPAHUZkFTZN1LAf8knngW6qC2R3+sEQZVyqtSStzB7lMHXiEECIG?=
 =?us-ascii?Q?A0HO03eWTcSUIzP6bB3HK/MVHAqqiqIwa6QNci+qU+/0oLJjl2iD7UUw0cVU?=
 =?us-ascii?Q?+EHv0vb21cYFwPlYJBpKsp1vAD8ZknnFWR4tlWcK7B0665oMrjd4z0jfmZyv?=
 =?us-ascii?Q?HUwq/Udh+eupVKAyTD8d1NkbsGlYeFS8FsYYUaH3jqguDAw5q3BW55haxlLg?=
 =?us-ascii?Q?4/FBdVK/XywceGB1KWCTvZiOFY40xCmqfxvSgIzUXFLJBsIy6vxr8JXlfWQa?=
 =?us-ascii?Q?Wus825nbai+igr/Rc6IQZEQIopkU7bKdTnODQle0vYN5Rolu5qEKP3XPc8zX?=
 =?us-ascii?Q?MvSwcM5ZinL6WhNx4Ll1aNUA8w+N+XYQDQNM8XRb1ksVm355JTM00mpRQE4E?=
 =?us-ascii?Q?Rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eVXE1CAPJ7oIf4EtVqrt2wXfFVTkRftmd8Jd1+MUQbUJvhjH9nnuRWXMFzLkWUccz6QVFCwFrgjmpvjrZis1t0xq74rTmSKy3x9byvX96XCUC+20VlpbRDdrcFX7hkCPLf0XN3JXBWhbmixp117e63nZy/W/0pSE4s0lOohCUB/y7Lp4h6CFvtF0Vzvr3Si2TxWWa7KfL/7PQuCuoX4TEhAg1bFU1PIMGOKcXIwRvJTnYAVGOhVFFz/D2M27uJ3y3gI9txjIxlg4Pu8xLxlEJAypgmetpS4nwfvurONOns7xybCdsU/BJlTREUyKXhv4VmAHsfyfsUQPrdDdM/AT9ffJ7WCd4yB4Izc+2+paIsG7FiXhg67b++QQZcYvonD0omImDmKgwlpMK/Mnwi5B7A7F6vmfief1eKoPcxGdE1GHVwGFU2HOdMJoT80fBRRA2A5XL4N8pK6Wir4vgkypzXNqf9feoruyIjnEaMTv1R1qRRHWx5F21mHkhCbv+kDnroK+ixqDtCoNz0RXidlDTuj/grujxEFydlP/m9nWuGVdgtj4m7SCm2Gxetx3PKJenCBvDxVWUBesHip+J6wcGL79Yjx5n8CcDbYCh6qlsxQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09049a0e-94ea-4702-976f-08dd0d5d471e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 14:27:23.4404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /AkAggE2991FepsoP8oGJdA8kOjL+cEl9UA6TzEm7W3qpP3mdljkVvPyycg5CGVr3GgkNBQ/kCG8vf+VlBq9+uVGeysPhELmZlu5+1iOkQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-25_09,2024-11-25_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411250122
X-Proofpoint-ORIG-GUID: lyZC0jhQefSxZsPpAel929IbpQeXg13r
X-Proofpoint-GUID: lyZC0jhQefSxZsPpAel929IbpQeXg13r

From: William Roche <william.roche@oracle.com>

Repair memory locations, calling ram_block_discard_range(),
punching a hole in the backend file when necessary and regenerate
a usable memory.
Fall back to unmap/remap the memory location(s) if the kernel doesn't
support the madvise calls used by ram_block_discard_range().

Signed-off-by: William Roche <william.roche@oracle.com>
---
 system/physmem.c | 69 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 23 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index 410eabd29d..26711df2d2 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2180,13 +2180,37 @@ void qemu_ram_free(RAMBlock *block)
 }
 
 #ifndef _WIN32
+/* Try to recover the given location using mmap */
+static void qemu_ram_remap_mmap(RAMBlock *block, void* vaddr, size_t size,
+                                ram_addr_t offset)
+{
+    int flags, prot;
+    void *area;
+
+    flags = MAP_FIXED;
+    flags |= block->flags & RAM_SHARED ? MAP_SHARED : MAP_PRIVATE;
+    flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
+    prot = PROT_READ;
+    prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
+    if (block->fd >= 0) {
+        area = mmap(vaddr, size, prot, flags, block->fd,
+                    offset + block->fd_offset);
+    } else {
+        flags |= MAP_ANONYMOUS;
+        area = mmap(vaddr, size, prot, flags, -1, 0);
+    }
+    if (area != vaddr) {
+        error_report("Could not remap addr: " RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
+                     size, addr);
+        exit(1);
+    }
+}
+
 void qemu_ram_remap(ram_addr_t addr)
 {
     RAMBlock *block;
     ram_addr_t offset;
-    int flags;
-    void *area, *vaddr;
-    int prot;
+    void *vaddr;
     size_t page_size;
 
     RAMBLOCK_FOREACH(block) {
@@ -2202,27 +2226,26 @@ void qemu_ram_remap(ram_addr_t addr)
             } else if (xen_enabled()) {
                 abort();
             } else {
-                flags = MAP_FIXED;
-                flags |= block->flags & RAM_SHARED ?
-                         MAP_SHARED : MAP_PRIVATE;
-                flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
-                prot = PROT_READ;
-                prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
-                if (block->fd >= 0) {
-                    area = mmap(vaddr, page_size, prot, flags, block->fd,
-                                offset + block->fd_offset);
-                } else {
-                    flags |= MAP_ANONYMOUS;
-                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
-                }
-                if (area != vaddr) {
-                    error_report("Could not remap addr: "
-                                 RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
-                                 page_size, addr);
-                    exit(1);
+                if (ram_block_discard_range(block, offset + block->fd_offset,
+                                            length) != 0) {
+                    /*
+                     * Fold back to using mmap(), but it cannot zap pagecache
+                     * pages, only anonymous pages. As soon as we might have
+                     * pagecache pages involved (either private or shared
+                     * mapping), we must be careful.
+                     * We don't take the risk of using mmap and fail now.
+                     */
+                    if (block->fd >= 0 && (qemu_ram_is_shared(block) ||
+                        (length > TARGET_PAGE_SIZE))) {
+                        error_report("Memory poison recovery failure addr: "
+                                     RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
+                                     length, addr);
+                        exit(1);
+                    }
+                    qemu_ram_remap_mmap(block, vaddr, page_size, offset);
+                    memory_try_enable_merging(vaddr, size);
+                    qemu_ram_setup_dump(vaddr, size);
                 }
-                memory_try_enable_merging(vaddr, page_size);
-                qemu_ram_setup_dump(vaddr, page_size);
             }
 
             break;
-- 
2.43.5



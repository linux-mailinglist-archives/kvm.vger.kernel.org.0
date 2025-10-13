Return-Path: <kvm+bounces-59920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 38091BD4CC3
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 18:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 57F4A507223
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 15:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACDB931BC95;
	Mon, 13 Oct 2025 15:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S9BNa2W2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h9IdoQ26"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D0A3112A5
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 15:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369801; cv=fail; b=WfirtLD6UOFCa6UnXZc6DRAq2K9zZdwhAbwJa7P3CZFpjff3+H86G7H8pkxNGuk+D3WpyEWMuEcehxp0WjLpX8BOgu2TwmE66KM7tHjf7QG6mN4MEwNZWqnhw99fRtF0SPFKz+t4/YoyK1+tWlTasVcbfB+W+2E1N0lLvdAUcWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369801; c=relaxed/simple;
	bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=kzuIxXvfZ7czHzI1Uo2v8zuzIYFXftPt4OGuvUwKzhA3MHJ4MiKibvPsbyZf5qB2yyfDMXfPm39pq6XzbTB8AhNxDCOJgS/cGVUYRNlFNs02K2Ur6aTIQNvkJB8B/dXbIT84HZP0qvNWyUoQXdc109nJ4O5EDTJmyrR5qQSq5ak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S9BNa2W2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h9IdoQ26; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59DEkved004022
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 15:36:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=corp-2025-04-25; bh=wjunn
	4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=; b=S9BNa2W2R3gUZ32WURIB4
	jD9hHyeqhLZ2STHiJfcc8BwPGE2wLXCtBLGlbPdEBi0h3R94U6UVfyxgkgR6Iuvu
	d77b9INtNkNtgU6wseGIKg524s1PBTZ8vR9XESdrzhl6Vd1FezrCd0YdjsafRMUm
	Cc97fohK6c+kxWix7FazKm98PnuTmZDg70lNvs5PBOm+i98d4TrYzMgyXIMJFWWk
	xYU1BFkCDzfjqxcKHZQwp1GfQUX68NvYaZ/var1L+0+vBJlWGWWE4CSrt8NNKmlY
	3DaPMxmxGALVvG1fDdj1REuhh9lOvii9KulDj/UxVsVyPRNrZfqX8lN+bJn09gvS
	Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdnc2j10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 15:36:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59DF9Qad026324
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 15:36:38 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp7fchv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 15:36:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m86GP/GqNy89NdDRRuda4OrUOWHgRIEcFOssY/1y9XKoCeK2ji0vHIaGzJYp4svo24SlshxwOYjkjyomlTTrDTFDovgPx7Y7dapO52p6bMSazl9+D+1p+ZAfqtWcpgAyBb6lnFa3rv5pSNNzBKsbq1fLssLQkZ1P+eVHENSHDUWM7FwF7E6UqYxXxGRm3PWbkkWnXohUEAp53UzrHmGVwEYy29fSbRk12mnwuZK7paYOq+KyYuyT3SdTt+Xn9M2U7I3USzlLYM+sJ13suWSHjb0mKDGeM/CiQ3a8iNzpvS5rrx1yJpt1Ha666TILX4eWCEEN7ICTlCh4o0NInZN00w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
 b=q3Unj2oWgMurmG7JqwlAb+OVwTIWrysOeVmm8ptKZrDp2L+3NVSZKUJygHOMeC5iNGDx/j0tKsMawMCmqY89h9aDudjwTPeOF5VkLioad5wC+Im6rTm5ItpOGGuUKpGFkOgey91oyklzIo425pL1nWb+HEoWkTYYtJZ9DUU9P8chHgRMa84UjBNoct5pEMH/9J9PTKAVOCttS5U5Zb2vvCwoitAJ/nHrDiZFr6tcu/QmW2/WB6fsdmRCTVJNXfOYOt0lzrirPOzbfcU3FKiSTIoi9gGWMXI6MiKfQDGMm2FWUutY2Nsv3q6Cy/prO596UPOJlDBMKnBpXqtacDDWJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
 b=h9IdoQ26lpDAhrtyl4ItqEKwxVOBZTTkQvowuipHAuiRHDbkdEFODART39pcbkvhd6yx3I085olnzfdR7ttxvUKxBSmBShH3GFo3QzmsvYGjMUMK4ntH9+2seNl7RPC3e/A+F6gdIvPZ7axZs6j+EBO7PqVRo0GfETe1YmiGLNE=
Received: from DS7PR10MB5008.namprd10.prod.outlook.com (2603:10b6:5:3b1::19)
 by DM6PR10MB4124.namprd10.prod.outlook.com (2603:10b6:5:218::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Mon, 13 Oct
 2025 15:36:36 +0000
Received: from DS7PR10MB5008.namprd10.prod.outlook.com
 ([fe80::3190:3396:d0a1:a69]) by DS7PR10MB5008.namprd10.prod.outlook.com
 ([fe80::3190:3396:d0a1:a69%6]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 15:36:36 +0000
From: Jag Raman <jag.raman@oracle.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: unsubscribe
Thread-Topic: unsubscribe
Thread-Index: AQHcPFcobtu/V7bFKkmnk4QCcxTutw==
Date: Mon, 13 Oct 2025 15:36:36 +0000
Message-ID: <DF4E42F2-0A8B-452C-8AAA-9F7BB11B6417@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB5008:EE_|DM6PR10MB4124:EE_
x-ms-office365-filtering-correlation-id: e38b05e2-e43a-4427-c51c-08de0a6e4b6b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|4022899009|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?0bEPFilDsCEvQeoL9JZYk5AcrEjLXk6sr86ufhWPww9qdm3aEV50R82MDt2E?=
 =?us-ascii?Q?2mZ3f7/JMK9o5K8KiOH1eTa6wYZ+2ujwl8S7G+KFBx7hK27hkYcSjdzBQKHW?=
 =?us-ascii?Q?TRX5RKAN9dZJPezGzg+rmNqC7T1dKQ4CD1Fdxhoey/oxS5FZRrtpvNoxrFII?=
 =?us-ascii?Q?ZRFyYHHpbLP9Mj86BTzJ1lCjQy8Iepb2bLpaNPPiThugkHLWWpd9H5TiuA7b?=
 =?us-ascii?Q?U0fGVlM2X2R7BAY7nMEBBiGFFMpChYn1s/wrWHUic58q0T+kXQiMwPtCWizQ?=
 =?us-ascii?Q?rU1DSNsSR8j9lGI9rccv6uFODUMh4NpTELXodlk7AMf8gTdeE7MFAh4QWga0?=
 =?us-ascii?Q?11vJWYGrVGLSyiwV4oFXAOT0r9/emmk7UBStmdc9Uyp281FhTECT40rii/li?=
 =?us-ascii?Q?aQaAYloDOm+lbYF5bOyVySTl7DzWmyNWlzsisdlyF8ZsdWdxTVuJ3G4r7li6?=
 =?us-ascii?Q?eI+kVXkNJafDsxjeSEt2FCMxIals/ECzL7JErQ3NQ0ic7RTh8aoIhdfntf/j?=
 =?us-ascii?Q?4HDps1SBZLPmWzsGQC9OBPmGoEeJDe1WwanlRMeK3XV2vuMstRg+0bNv/Efp?=
 =?us-ascii?Q?Joh2CEohZcA+sVlWUZKBHR5ICpeaBoIs4gfjzl7nL3x4+6cYopz+cPaMdCON?=
 =?us-ascii?Q?DaeNof78h6jjp8tIRXqqf9XtEqRr/B7SDZeYzAfEWe9hGD5bsbm6Ros/5G3Z?=
 =?us-ascii?Q?AKuXds40i9DoMMlkVGTbPo1b1dDdMTW7DQeDLnSCJQuXCmgK1+zn2GTYb0Uc?=
 =?us-ascii?Q?6Ef2v2TvLCMKFH9V0LLTeV6/4aEugR90RT/ouYCKGbF0O0unfdEvZErWLHbC?=
 =?us-ascii?Q?+VWjfbs/SZ79+dV+CKuJ9PBVRMR/xSu/0VYytB0mbLU7xryGK8WuzG8NKDXj?=
 =?us-ascii?Q?bK1Rned0nmL1pBqPk/FO/dO8LlDPxV6bcJmQOceAWndZ3k6kmoPum1TxOSiJ?=
 =?us-ascii?Q?iTq+YdOqVormEJlwg3u9b9APpjWtHh4ElpKykA50Qey3+8M5ZnBVdn51w3aS?=
 =?us-ascii?Q?AjIHSXu5yrn2fMtm51BV0BYYTDx3hSHdIG3pdz02/7FYXyC5DmrAoym8muh8?=
 =?us-ascii?Q?Gf608tBNerWKraFZm3nvopiBoMjPe8DJIMNA03T+YMFzmU4CaE9zoC8b7QdS?=
 =?us-ascii?Q?6KbXeL2xcbxyxIHBj0is8A3GE12wTyADig/7JfDtDax0gRpBB5sVmiho/mYY?=
 =?us-ascii?Q?+ubjvDuWRhUuAsQ/vMhO5dmXmD6guO6ODy7oRD86RrVedLFH1Dikyub65gPX?=
 =?us-ascii?Q?Pi9HVyKaVUrs29XG6LORhtWt99H55Q9bgP/36BFbvO3VFQN8sXYddM+ZGUWn?=
 =?us-ascii?Q?+qMk4rWJfN9QZtHykHGxpcVuTrO/7iPSU/O7cwscwjRGQz3Bv8fMbH670VdR?=
 =?us-ascii?Q?ByKYfzGVsPUcgdNHvJw6asQpMMYvDCgFbb2beDVfYW8vivGYBBsqI2rm5l8m?=
 =?us-ascii?Q?DL2aXQw/YG9ZOZZ6JFt8S690AUJzdz0yC92kSTbFnxA6YCXjr2piJW29yiyC?=
 =?us-ascii?Q?iS6S13UIgrHFtAye8xq5CGxMIptyUOZ8fJxS?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(4022899009)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?p7A0iWzzZEmDUOZNfH1EwunDQ1uSq4tFIGTk/zs0E0wEPWu0zf5BX9E2QSvW?=
 =?us-ascii?Q?1mB6tL3vtfFbMCGr0GJPeFw18utL4uNK85NeKZ9Izh5BP1lUEofyoYFSUjql?=
 =?us-ascii?Q?CODysXVaMg4WJSxBTmV44v/qf69V3QeDKKM79Hl22bNDt6F6KNVWfCz+mu1D?=
 =?us-ascii?Q?vHsQEwmKe2z4H3sQc0WrjJykqNzWbxG0mhwI6b61LI3bvU7ODI/02IHxFWZ0?=
 =?us-ascii?Q?YWEU1SeEgkRkzS0zv52/bSrdv7R3QbRomfhYFYDSpmuj85pMQm+2A+5mAsPc?=
 =?us-ascii?Q?ltjSsV+Y6VTeNvezmGFtTCPuJ2obMnAvwOVQnw06FgB9AXue6R3AOoIXDX+a?=
 =?us-ascii?Q?OGJFxhxF9/HzCqJmi7u/ohBQyWyKspmPzDPAq3ScbOmjFeJzGbVyHz+crgbB?=
 =?us-ascii?Q?FbIcm0KF1XnPY3ClUFOjArRHET33ZeTLIJaJFoAf+RJrHnIJX4Pp/LbtahDg?=
 =?us-ascii?Q?4zSYkUjdrDn+tCsHE8fXDMJ3n5le/GuhMtrZRzFCK/6JiOSUmuu9quNH33iu?=
 =?us-ascii?Q?NX0tJX0WUsQK+1UbGMR7yDz8mbNPM1CaBB6ooueH2uu2d2s+2RHuXpQkIG0h?=
 =?us-ascii?Q?hjlIDJUKPjizKLMWOWdYBnR66ItDZTq/WuixYuPO3tUDJUcRFlFoTljSiBDa?=
 =?us-ascii?Q?l9awKzTAjAOe1LXv/TW0+K5DO9Z1Cxc8nUMGAp0ayfvvkwuCsg2QfqD0VH0I?=
 =?us-ascii?Q?qlo/WwbM2iLaDA3C0GX/HfYHgZfZK1i+62eSXs2XndG1WCNuaXAtJ2kPu+Uc?=
 =?us-ascii?Q?gsuqGkVS2yHkNsR9MPdSweBzQGg4lH7R7NfQstd05LVt+EgK0YUwVIBg9QZb?=
 =?us-ascii?Q?3VizDgmYGNxN0Ve70MyPct7eCXO4V61YwOViBmFIgxI1m7edWTQRGpUMNeos?=
 =?us-ascii?Q?DjEYyGbOn4DuN3qcIHN422GJC45Fy8Mzg+ucpSvT64HTZ4hj0h2MKe+r8a8F?=
 =?us-ascii?Q?Mtqv4FBmzeeBOQdRSzalEMr0GhSpRK54P9Z4FW+PggtZNmLZEuSOkPqJMCTt?=
 =?us-ascii?Q?MU9ubvRJNPSNF6IFdZnGo2Lud5mh7d4Jk5lDy9A0sDa7p9/iTNF9ZHZCSFQh?=
 =?us-ascii?Q?+fhMMXdod5G4bgN6x3sZyvn+J/OJvFgHhB96t7wATMoQxf3FgIbEWhH73Pf1?=
 =?us-ascii?Q?UMOdh31Wf/0gIB0lFAe4/y0AICSXIZytypGdzoUCjhsbF2FLxO3jf+SUBYqx?=
 =?us-ascii?Q?uPjvAPBzvoglqqy/2pOITNBPtdgkDc+dSqWyJ6Mieciok/5uT3yjo48dSLsW?=
 =?us-ascii?Q?en49HoaFJ+NT8BEXTeMzGU5ooYSdNFDg7Xqz64zpPcN38e7i6ZGM4GzMBHRZ?=
 =?us-ascii?Q?QzxoD/IHBxC0H7Jma40GqlzzQs27ZQk82/ZmmzT6lpFKewoe1RXzWW8qr0G3?=
 =?us-ascii?Q?DUOx6JzhhSMRQuv41SQUZE7wsmFf7U/tkirHEwLMz/+WdDC0fqUAH5Y/x4jo?=
 =?us-ascii?Q?M1tLAMJmMqQM7mR14z53zDCTx4AANmiinFUXNQCs/GxixKHYwN0oFAIO7g4k?=
 =?us-ascii?Q?1Mn6qLLWY8hG4ujJlyaML0vHGg56QeBCuCUQJknsYLmYOl8DJbmaZziGxRJp?=
 =?us-ascii?Q?Oxd1Xv1GJaGT8ZYc8T8fZxDsqil9xZV2vQDNMCv4V9GwPsWXxi2iWhN+ckwM?=
 =?us-ascii?Q?XA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AFD34D42D3FB2543B5F04C15CECA0652@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0Vzp1FAb3dT01JirATX5WukK8MwDfk0vYJmQpJVJK3kzTMLvaPg3Lf6Ppf2EhnZc8R4p2IaQTeURCR+Kx4rcsFRgqIdhx3QgVwTEVoeqokTeXu+Lj296w5+zrGC2/P2Iy63x9Km5EATohmJJ/OMAz56G2LMs8+K+MfwZcmBmX8FxWy6HP5SZDVsZuVtXZMFihyizczNEPDdrSxE99k1foGVbQnARdq0wUPi9xOwgo+1J7Phzh8PcwA+QbhHtUSGOlpm4XmYxzdlRTzT4Vh51UbRs4pm2nxalsJmswNhM36jGOrbJ8vDwL5+vSR+qXBLLMV+nb3hSunuQ1GgnVvAXgfgZdvBIA7OUWV3D1QIHM/lH8I1zJyB5nq0y5cGycaIPRXEXkMCT0X604qEWosNv8VKunIQBH/ByEYLQG1xP6kN28JVgEkh6N40q63QK7qkmNRWILhtKSdWnnkHX1DfI7bh+3QLwQvfXDhk6qjGtZeXp/wODciFXqXIh8Jil5RqdGCOMRP1p7xHQ9MDdKp7PjGa3AhRsCByLca45WwcH03GaGyTDSyYv+fxmStr9/VJM5jtlD/cz2Y09Hh4JH/FsA2s9gsfLgjEmNnjcUE/tZ0c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e38b05e2-e43a-4427-c51c-08de0a6e4b6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2025 15:36:36.0830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pi774XLNKVsjeHmVXWXD3WoTZ7PFuEUWeE2fCNKwS0ZeUB2SgRUU2C2+eeIxYNS2eVxjp+AoYDP+0FWHEtohHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=624 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510130070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNiBTYWx0ZWRfX49rf/MPriSFa
 VmrHjfCyt/aWPazut2VtvEbDoSEYe1l/dzAePXtzDa0xFdx3Fy5Ombpd6p3beP6SLr06v/QbNc6
 UZKks12M1EQ1UkK3StCu5mZlAPkBn5cYeGZWfuuPLmZT9NZJftBJhXPDAO3uTt/C+7xtJe6oI7m
 FoRZrYPIiGgw3x7wVE27K78l+rKYRcEYV0wKCwVWTFY6PoU1zimlB8FZyCL8rW9Y/DCVA2BWrFN
 iVE/G1SV6eXBPhtSsnyWj3/7Po1DTNYM3RMe+98laklaTkPbukRsnkoDBe9wLtzBkVOoWeP3Qcy
 G1l7BJMiOdsXYBu0m5MtjCdQs1eaDwH2hoXnKMOAU38Gwkkn2Vi0J13lo/niyEZz1j3tIdNfzqU
 8Ha/N6fWz5eJy72l7F/YvDSD/woe0fOuiUeWN8AFcQ6aCLOIHrU=
X-Proofpoint-GUID: 1RVgdbKd_LguGvyC2JIQJFzhjS7rIL90
X-Authority-Analysis: v=2.4 cv=ReCdyltv c=1 sm=1 tr=0 ts=68ed1c86 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10
 a=b8-Vl266e-1dYu4KQsIA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13624
X-Proofpoint-ORIG-GUID: 1RVgdbKd_LguGvyC2JIQJFzhjS7rIL90

unsubscribe


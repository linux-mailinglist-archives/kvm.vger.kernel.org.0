Return-Path: <kvm+bounces-33820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 666539F1F21
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 14:47:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60EE7167794
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 13:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02FD63C;
	Sat, 14 Dec 2024 13:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BHL4rdyv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kiZJbGr7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1487117E015
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734183990; cv=fail; b=dQqUdjmVUbPVOyBuSEhrbELy+euRVXjDJZfZiOXFkfjtZfGypXQPYJht13CgD9ne5K9kWtu6djIbY695CnnsMBnQHd1xdJ+YoyqlhJUteShcLVQVKe+NLBHAuw8mXxPMzCdM2PcmtPzrLuhkMtBOy6Ci9rr25AS/87UmOGQRa6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734183990; c=relaxed/simple;
	bh=zS/jQYauT8BL8/Cc80hpxNF9L+NLDJawb3OD1R8JoJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Qd8s2OBCq0D+xYG3Hu8yhDzCqmtAr+2Eykqzcj4Mj4/0aESNkvRXVmgQdwIoAxiyXJ6PGzkkIU7t35M2PpM2+D0RkU7wPT5kiGt8JdZkRVmQVFUonrCgkBZRwkxYQQCaO1XZxYxYitqTLODhcWCCWlyHOnekmLQoOAWecjbm4Do=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BHL4rdyv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kiZJbGr7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BEBSN0U028037;
	Sat, 14 Dec 2024 13:46:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=CPzAcY6OV5ZKPJE2OpZitDgEjWpc4olbj0hZFwGGVy4=; b=
	BHL4rdyvb+ZAte32UTdru+pKjfJipAqkYFgQ68wRlGXkwxqymOBKrsfsqEXGHmgH
	/k46yfd+KA72hKbsQuzO+fRGHpd+Gk1maX8QvFwP5Pl/VbGL7Th7YeQyNYj2+bWP
	0SWkSvlA8BqpHml7z0Cg2V8bFf3e3nrAqAx1lYVrgLB+JF8//cTQYVHliZLsIxql
	lSHpwnu0/VIIpvRUWoHIBmpYLTKd7noeSYH+OXpdSBPF2fxuRvcJ4bUYnd9CX1w4
	q1tPi6TJvDiRULD1HvMFAgkbUrvRxthVX6N21iwxkgrXRPegpFzFTqyXk4DmbMVF
	j7zMYnf637BSCgtucwO1og==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0t28gmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 13:46:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BEA1I9E006344;
	Sat, 14 Dec 2024 13:46:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f6k075-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 13:46:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T+tYICUn6F1jlnTc0+jRJXAjfpo9Xzj98utV6P/uJrZmssvrIHn1QZVcsgJdebtchBSgjlWV/ybRxRSmfOew4EljGjJQSnE2ecZH3qu08CK1n58IICOSCcr+YesPPEPLjD7MNfqxR9kB/G/ZqJGeNK1MALFY4DMBOtS4iTRjpMqiHXegqIQTiIKKaxDyOIpliybBjc3PlECnTqi4QaRTUyiM03L8vvV/YCa/jMyhdcvlGfzXtp6EDCCxFTANJ8AWHt71qHd5yAtrKWQN0nSXwSK0vKNxmdW1h+Fy0kAWLZQbLG8ZMjfMUVhT+Sqm2I4sfVp8KF5fgVcJ3Y8QsFW13A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CPzAcY6OV5ZKPJE2OpZitDgEjWpc4olbj0hZFwGGVy4=;
 b=P843tr0LPEbePebzSHCJHjj7dTfz865sMn67oRstzjZCDr9/DXZ7I05GjkTYco8NxEmb29F+bGswBu8v06+j+4eTeM3wBibdECf/7439XxcKNTrTO7IQwUltnGSVhuRMrr4bZqIs+7Epq2iwkMX6XeJ+JaOtBolpTI6QH2mnop2A/OQqJBhsZFubp91/2YiKj58nFhTBSUXXVVIeihl268KlpthH8Tlz6pHbAGv5MzacOqjpVtbwXi+N4+l68N5ZehblwLHIxh9WCt5Qucepan4lH6/WYUGqMEbjC2sM7Idanqpbo4qSD1XIqysPwZIpafiKawRKrG9yjzLmS9z5hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPzAcY6OV5ZKPJE2OpZitDgEjWpc4olbj0hZFwGGVy4=;
 b=kiZJbGr7bj5A6ChXaF/UNRiul0RyE1FERii7vcWFyd2E2WjwzCVGbY4eMd51c4HyfXlSsskY95uc2BBk5ZAsSqX6sFzKU0tu3HAZ5lDEQrahx8pfdOz6wYrgXREFfn/UhIsfyMgF64T8gYRZPDriRlfaO3vDzY1dk9KFVDOEWVc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SN4PR10MB5624.namprd10.prod.outlook.com (2603:10b6:806:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.19; Sat, 14 Dec
 2024 13:46:01 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8251.015; Sat, 14 Dec 2024
 13:46:01 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v4 2/7] system/physmem: poisoned memory discard on reboot
Date: Sat, 14 Dec 2024 13:45:50 +0000
Message-ID: <20241214134555.440097-3-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241214134555.440097-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::29) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SN4PR10MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 473ec113-e89e-40a5-ac19-08dd1c45a5b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Tb51+MJt2RSdHV4SABVdxs0LLGKg+v3/yk/qg13XcDE82M9VF4uHaxR9eEvU?=
 =?us-ascii?Q?e4yN5fKDV7ZtssVX2/rFwJsNJ7CAhKirSKUN5RdsKxjBJCE68ifhGN+jGXPK?=
 =?us-ascii?Q?3qDh1YX00d4GMmLrfhLDoH6kDP3PqXwQxu07xfqOVkefWnLyqfqBZVEHs/uq?=
 =?us-ascii?Q?SvEXMySFDE8dpeq9y9Uw10f15cWERaBxgutqf4cV1RibxJDOjxIEXBNaYlpq?=
 =?us-ascii?Q?+wB1YTz7PXCTCIKixxpupUoFDqonn72C7jc+IM6XS9FsbXp6T94QoOf54Xm8?=
 =?us-ascii?Q?hUsXSwCrdO6l+pg5J6So0QaZJwcvt2fUUgabQ9YVADBYplly9v4sYwJo3m9j?=
 =?us-ascii?Q?p5iSfkSMpuazBDC+tAXPlKvLerJtSzkGlNZa+AF03ZDokpOyfr86pR24tpgK?=
 =?us-ascii?Q?4BMMZTR1OIF/PS7Muempi7PQPni485Olez3jWvHKW8nY5YtA3L4C2yhXnvgn?=
 =?us-ascii?Q?f9SABV3dHklY9cucXt1jirXX/kuCwE4OnJf+70InYZbvJZIsx0imc1Kdf9QU?=
 =?us-ascii?Q?agcmTNmIY/dRLZT1/Uu8EmNDv0N5uMj7P5XohKcp7uXCIFsYlo11M9jvG7QM?=
 =?us-ascii?Q?8dqGiEpJlvAghnuvBeg8KiUIga3TaMQ0lMAnPz8C+jx91ebw9djPHhJWKlzV?=
 =?us-ascii?Q?yy0kaK6c6mcnBzaLSRtORGeMGGKIL4kyFAA5iN8RFIw0zUy8hfCAp3j24obc?=
 =?us-ascii?Q?+HAhrCIEsCWC5H5tamKb+QHQukvEe+AaZxzlTEIEPKrAsM9ByCjq7D0OhQUm?=
 =?us-ascii?Q?rnFGBAu22dtDY0muzztRQVb9c3TfxyT9iFlhCNFBuDV8v9P2Z58Nhj/2Rad3?=
 =?us-ascii?Q?2X5OL737pn99AmAWk/6wQZTFRi02Kxs5iKXg6ZUu66YP8ywvFpqQykDIczzF?=
 =?us-ascii?Q?GCnTDBk46SjfN2oV3b0gQzww4Sj1+1IM+czeDo6/orIQ/cFkmOV/rNDC/+tk?=
 =?us-ascii?Q?D+w3xh3yUPNitXF0Vn8vtA8wo2/6SL5rbumyyw0L0bl0wD2tg0rAQnzGpx+L?=
 =?us-ascii?Q?feFf2RkiIVESieCIlzgN3RixgfOn4Lh2uWRdYQjjJNhPo0/pED54v3m5u09y?=
 =?us-ascii?Q?MpYucqG3PvKMFHbldrdjn9osRqlnXJdyHVhK3UPdSY+swPCDPPzzKDqh8djq?=
 =?us-ascii?Q?wnrfuXb3eESTc1npe3g7/Y8givI2zujJtgRtbYCCsEY6uEjnwuCNZJoGb5yZ?=
 =?us-ascii?Q?n70+fzpGc+lx2evYs0KhmqqoqY83Gj1yyeOso6hOhzxHl/Aj2pGV/mzYe/zY?=
 =?us-ascii?Q?sAKrmOMKLQOgH2EMLrrQ8V30uq2uWyzRKBCp5VHuu91fq90SjjxaVO2KwaAT?=
 =?us-ascii?Q?ojS/nwLkkACtgNtYY6j6sP4m1uJ57maDVvg2AbLm0kZXFw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kynvIpnwy1T3xHHggLEVJaA2IcW7nC8xY31dqrTtK6Sm/o0ne5FCOxEEZptz?=
 =?us-ascii?Q?AUhawhPiqSiM1MJqnUr4CsXSH4+WUuWBcmIfua4XyDj/uypP2SbbwX0dQbtO?=
 =?us-ascii?Q?qkVFCoYtMD5xAV/uBUKPufho7DyYYsbokZEf/nr5ed7+CyVWaEYIaw9Jx4q3?=
 =?us-ascii?Q?HQXXRhEKgIr3qMTI22r/vC0sn/WY7vSlAb7zAgj5Jfw/Hm3C7/gvRQNievz+?=
 =?us-ascii?Q?bkcswSsSGAPRvrqOZAISViQv+loSBVyeOHsMDX6xj60ESt0+unHaHhC/7WYK?=
 =?us-ascii?Q?egLPN1h0kXiA5S0RS4K3jWzR9DeJ1CMO4I8oFgrD6bQxXlkrZhkhf+crp++a?=
 =?us-ascii?Q?y5CMosyn8kvrbkr/JJ9ZQ68SHWQxO+/UFAcdKszKpHdKJvtol79t+OTQY+W1?=
 =?us-ascii?Q?0uZj4xApzzOxWHjI8odcXT+2aD43zcB5fwqup5uERlHafoImuVBYhqK+yNwC?=
 =?us-ascii?Q?2kUZMGDXlEMjX3OYmoaSxAt0hYOfWBl0xLDnfGnWC48w1QCrpw4jSo+0q8x7?=
 =?us-ascii?Q?423sHrLXyUqcH2qHaia4qGCO/MXMxFOlqxicdsH6O7XDIs/A2MHt3Sj/JjRq?=
 =?us-ascii?Q?Dirb280u7Uxijcyxr9SMGnVxQm+l7wnaUPz1HWkUxOFrDYS1TAS04Rv1CS8P?=
 =?us-ascii?Q?MVowh/pKRvJJ9Pv/tXsRSYcehB0rEOTI23H7ENvYhhEddriDWgu/YiXS5BK3?=
 =?us-ascii?Q?pQN1TJaStFPIW63AfcRODxI2DbsyOODl78Pq8fq7mOZSLUe325gqd08CyVuy?=
 =?us-ascii?Q?beXfuRSb1umP097BAOsSbiNAZP7sdli5czA1do7aZb+jzU9sUJ/4xljxjTW3?=
 =?us-ascii?Q?M4a+2wS83ZNE/pBfd1QH214b99Gjbb+dKBmk5YZ9gyMx8id4laqdtT0uAgRQ?=
 =?us-ascii?Q?gmCJ5GNPHS9QrLFIAbJWyFUtpo+5kyT2P/Jk158op7UP/ui2h+OPbi9L4Svd?=
 =?us-ascii?Q?ppmg3R63k2QTu7GKHfKmzQSf8UslotgC0U6cTOVVgNLq3Q7JfRvKM/BJ/pdV?=
 =?us-ascii?Q?eoYauaATJ8MszYI6w+Xfsx1bD277aKdhZxTerr5qy3Nzwr8tcMihxHkIEu7p?=
 =?us-ascii?Q?//AwFO+4QmNbl+KsIASr1GfBUxuGNjDMixjbkRL5b8zMyAs59uJWgIChn/Q4?=
 =?us-ascii?Q?+KOC3kVU30dxMnvzOi0eCnKE0/ZkPO/y9O+w6qDBulpP4Wc6I6vHXhbwekZ+?=
 =?us-ascii?Q?DmD+sA38f+v05VciJInXJj0x5xCyhXQJMuuvUqUdjpkysh8/5XqbCdO325Fv?=
 =?us-ascii?Q?+UwFQisnuUWsuB2ygdPz9ZMSyblf6fBQLNtrYrCgqnkzcP5gkCZMMN6XFnQM?=
 =?us-ascii?Q?ir8h/ynd+Qp2/8Dj9AzF5iqnid1gZfJnmj3EsHR439+zIIwH+5onXx+UQXlm?=
 =?us-ascii?Q?+SFx4OWaDgOwJW3XY32Y+QBT8ZnwVTOPxlrESz48HMD062JQjaVDA+/hBSmX?=
 =?us-ascii?Q?Ox+8aYspR2FhkbTd/kmwDP+OBgmbdp+bjPg2fZI7GzQybovxursuyq13i6zu?=
 =?us-ascii?Q?X5q/KlnPO1yqAXwp1c1SbnOJsyauvcldrxxsDFxOft2Dvbejjgu+F2w98vBa?=
 =?us-ascii?Q?LiuTDe3ypII4a5cABOR9pPcPFPSWk+jRoMp0W+wFrWgSfC024VNSo5qNU3IL?=
 =?us-ascii?Q?4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ghodUF1GsJ2MrEmD8rp+FUP48mDoGQ1SJ10oMS/u2NLe81e9NIE3A3v9sssaTUhiCcT1aLPK3npo1pSJKVE1564DJZrX77h5UUEq1n+QH7lUazW5s18edyc0uzFx88IoeygbFKYhY5iDwgxecmRHzSP8qlBlPZwGyOtttCpo7vJlZrnNXkBBiB7R7ty2mNSYm11486y5E7QFPSJGDR3yBYjPhIV8mRt+UUGQT7VOhO0QsUrtF3jtXffsln8PesF6F+H6FV4uYxvuO5dqcTTNLRPTt2TF7waG+zP6fxaKLa3E3ToTFpYyfiFMhHcIdsWSb+5PDWyCbgSP0kfNK4j2GEWzhGLVDunCbqRxx5FrodZll0YgnUBYGKKskXmabAnm22jjEZz8ya3OD32C1Zx2LEtxtOgX8g3BeTlIr3ohavmkrTtsTPakFLKYFe3rRiqOYfZn5DClhqUmDQ6/GuVLnBQ/ED3t6tlayf8xKEQOb5heeUnWDIPoqpQDXaCvY/JkemV9nHbX5lm+30nKVXnGn3cheCCxv0PyEAsI3af5M0GibmDlq8xEaP2sTbmyAwh4PsXR0pOil9+Jix8qXgbdiAr8EeHs4ZW5NLjO2TEAOMU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 473ec113-e89e-40a5-ac19-08dd1c45a5b3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2024 13:46:01.6441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OlXwzxO8YKsXBTGaZieua0YTZgq4ArIGvzMIDMwvxnHBhIW7gCPvLyS5fXaNQzAljC4nbXHMk5MOOy2b1/Kp2tr0B2b/Gg1dyrFoTnXdteI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-14_05,2024-12-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412140112
X-Proofpoint-ORIG-GUID: YLjYG196WYm5vUT5_UPrDPP35B_K2yUG
X-Proofpoint-GUID: YLjYG196WYm5vUT5_UPrDPP35B_K2yUG

From: William Roche <william.roche@oracle.com>

Repair poisoned memory location(s), calling ram_block_discard_range():
punching a hole in the backend file when necessary and regenerating
a usable memory.
If the kernel doesn't support the madvise calls used by this function
and we are dealing with anonymous memory, fall back to remapping the
location(s).

Signed-off-by: William Roche <william.roche@oracle.com>
---
 system/physmem.c | 63 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index 2c90cc2d78..b228a692f8 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2180,13 +2180,37 @@ void qemu_ram_free(RAMBlock *block)
 }
 
 #ifndef _WIN32
+/* Try to simply remap the given location */
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
+                     size, block->offset + offset);
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
@@ -2202,24 +2226,21 @@ void qemu_ram_remap(ram_addr_t addr)
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
+                                            page_size) != 0) {
+                    /*
+                     * Fold back to using mmap() only for anonymous mapping,
+                     * as if a backing file is associated we may not be able
+                     * to recover the memory in all cases.
+                     * So don't take the risk of using only mmap and fail now.
+                     */
+                    if (block->fd >= 0) {
+                        error_report("Memory poison recovery failure addr: "
+                                     RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
+                                     page_size, addr);
+                        exit(1);
+                    }
+                    qemu_ram_remap_mmap(block, vaddr, page_size, offset);
                 }
                 memory_try_enable_merging(vaddr, page_size);
                 qemu_ram_setup_dump(vaddr, page_size);
-- 
2.43.5



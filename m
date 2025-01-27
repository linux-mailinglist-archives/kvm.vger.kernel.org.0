Return-Path: <kvm+bounces-36701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB5C1A1FFD3
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:32:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4895F16477D
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038961D86D6;
	Mon, 27 Jan 2025 21:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eM65M2jK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lJa89lhx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712841A76D4
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013516; cv=fail; b=feDaEJLEOVghvYIrmT6CBJSCMxAzosemYqtnsCm2iKOoijBKM2IfhqVea1JIm+W44cStx3I6CCGkG8CaY0x+q8z8xcnEXf44hn7bJDRSBesM0C7AmSlM1F+ym2JOsshekHRRUggVvApdZhNh5rFLZA8530YYVZOSVbiiJ6oeJGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013516; c=relaxed/simple;
	bh=RODvL4FVUS3zzA7DgYmKwMOCxdix/IPsXUqqcayUyLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BTJ+c+4dNLqjSM98PUKd3cdKrPcBVoweqJHMZySJAXbtwDKMv/jgPcWvEcWPLIPce6T3tnHjpCpTeaHazhLvs6kH/AEbN6ZWXIfiYT2lkoU3ZEFWEbab/rM3xFta1fu7z/xVfAWhQBHB638FL0kKzqLyIUOo3f6O4kHlgjg8lg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eM65M2jK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lJa89lhx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50RL0lmF024590;
	Mon, 27 Jan 2025 21:31:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=q/xeNyOY+TV4ORploV63k4EIPm0Cbo9WXj8FEDVnMZA=; b=
	eM65M2jKvJWYchyEbqXaCDLDcbI/FFKzQkEcQQxw7NHBndLSey0q8Fo698/i4F97
	Ne55URw8GCnHNRDGHSzB6l6OHbeWtgWG6qZVTRQi7zfP3plv7kkMotyCXLeS/1rP
	THs2+Z7GeK0Sst3uDfsttqzU9MVDV+o8OAkKbcIoNTPyWznHOJ9dmgBRQLXFndQd
	1Jw6aYdueSUP7k4ZrM3yNBhHJU/MmwbYqOYOEVd0/G5Ff8t5vrn9v52x0+U5moJZ
	ets83OnSl5CMcY0DkFhu1lFjE6TsPYBq+59huzexDBr6xmgLYiCID+uUu15sFZ+k
	/RTpAvoNwhTnfWDIZ+rclg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44ehpc8279-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50RJrQHc021411;
	Mon, 27 Jan 2025 21:31:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44cpd7hsr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WYmyhPAvyWHTPczuckbntOa6Bxbb0atiPClgBJR7VnRMZHXIS4aqeiUmVtqhHE/QAzr9xkFWmaxKM97bfN5D8M6NtulAzeAeDIM2XH7EJT9Ha9Eh5k6gimJFZuYqzog4J7ZPZ0s6ASEWTwFQT1DoET98seSvwNylAU9BeCEIDW8k4VAAhCngFB/FUffsWD8ZAVUu2v0PXGJ15xp3+bEfMBjO/HYPjmWvDqpDvQeBG1mrG8qQB+/Dz1JB/GpicuO74U59+4aDsI95i/WKml7LcnhXz2Ifd5vRTC02KKvaezGdKbdkw9Ke1vsAq8kdroq+KDoY0HB36mi4dMYPxNhLXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/xeNyOY+TV4ORploV63k4EIPm0Cbo9WXj8FEDVnMZA=;
 b=hM6ZPm1UG7joCcx16CHO9Mxv//wAtkMd5uh+VAMtlkXjpA66RRx/f1lqbsIQ83Wb06nlS8t4a9pZuyz6hxiww2C9ZTrfnCwK5m4QjHgzLteD2K1H3L1TY2C5HkoBt+7n2sOjoUJSLs6+zDM0eR7R0EH8DtwdPlTf6BRRGCwqakJn+SAw1BX1CObofFzHy+FhUVwHgcMrbZ7RaRVixEFdcP8zsU0iy4hSauaSoNpOJsMF4iYQXToexFkfCXo5rWqz0eAbDJ9eIcRdAVqf1TcJXmpdwG2RoXdnwLaF92b5LTMwh0tVkhp8wyfkiMtqz8XvsO9L1fIFgal7smhx4q5PBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/xeNyOY+TV4ORploV63k4EIPm0Cbo9WXj8FEDVnMZA=;
 b=lJa89lhxZtU9Ee4GlJK5C+p/jVDk/ltayfUFFiqffsVma5ClQ1ypPitluLEPLMHWlfysiLtCPeuibPjmiqYagFmuWdY1DMG0SmZhm7LAaZdaBc2XDdPRGXPjbizRU4iU7EeV62Y+3RO/QSQ+u+PEDn4Uw8mMqo+nwWwTA0L2dh8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.23; Mon, 27 Jan
 2025 21:31:39 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 21:31:39 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v6 6/6] hostmem: Handle remapping of RAM
Date: Mon, 27 Jan 2025 21:31:07 +0000
Message-ID: <20250127213107.3454680-7-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250127213107.3454680-1-william.roche@oracle.com>
References: <20250127213107.3454680-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0166.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4614:EE_
X-MS-Office365-Filtering-Correlation-Id: 13aa597f-bff4-4764-9b35-08dd3f19fc03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I1elrxhJkM9TCFTwNUY+XuL3oy+N2hbr53p/YqSI0NRDF1xGe0A3LR9CN+cq?=
 =?us-ascii?Q?RB25NSW83mmnKZsyV37J3emJQH5nn58UHGHrXSKGuL/HCqsRLmmKfyxeXuW8?=
 =?us-ascii?Q?jNadjz5SdoptaiuJqeRPtZyOIsVweDJTWDNU2cY2pKVJwgb0MRyywuWBCXgA?=
 =?us-ascii?Q?1jm9xCtnuEtkL5GH0XxJ4dlr5Sne1V9FFf3R2vc7O6WzjvW46uGvkvmq2tJs?=
 =?us-ascii?Q?13BC6HjuU7n4FWpwTIm3l+g0ARfd2zbgMnYgikHr8Id7yiOgOLjCz7M3sOvw?=
 =?us-ascii?Q?oqwzPC6VxQUthcSmPzYtvrhU5kj4DINXDhm4pAuVHDiChoDKVVUcfs4eAlZW?=
 =?us-ascii?Q?gSc8QvRJyTv/AAU3BbWD9RZLgRje08L/JohEhQAL/gUrqB88A2/ohO1xi0HD?=
 =?us-ascii?Q?hzfA8ulstTZMrgm10tpfjUY/Pp90RveHBFptEQaWv3j8d5mkYRt3wcD+fsi5?=
 =?us-ascii?Q?z1a3F+BsSUMuyfMxk8LInscb+h4PgAV+XIItmvDymz4rGK/60qxVJ+SWK7O/?=
 =?us-ascii?Q?b1Xy29GZOa56JR8V7igXwUpxqM2pFzTk20FgjbarEk7TFl6UABqK8WLuvwZS?=
 =?us-ascii?Q?hb5yuj1BC+X90tjaFWPNhQF3pp+ZLA+RSTcGAwV8e29ugmWnjJIrNTLV/ghe?=
 =?us-ascii?Q?YORwznnxn6HKdhYXiTrhrcsiCQ063bMSSUrOEHMKIlpkqFSBTAFwzeXH39/+?=
 =?us-ascii?Q?xxliniGCvUrLWPhTaQI6lLrGnVIfiV0azImLj5SXQ01SgfX0DHGU3L4+Fnte?=
 =?us-ascii?Q?8AXF7GF4V6ILkJ50ggF7OBZOzF8zuDeQwb+aKd7heE5Zr5DEdHCm3xI1ULc1?=
 =?us-ascii?Q?NrKVztTKJAZgK71v5/3xlgNdulTKn5206FFpqVeG0TABn+Tn0UyzH8gMbYII?=
 =?us-ascii?Q?VJaQXcSZ4QuEjFH8pazEmLCBK8zQ+b45ajmqB5/dMBEFz70Co256Fpchx50S?=
 =?us-ascii?Q?RUdEdmU/4P1RcdWuAn4QbdLXaiNsYhdbNm/QhK2lit9hOnIYWRcE9QzFC0pf?=
 =?us-ascii?Q?10HLUvfARgYE6EbNpe1MsDi7RCw6vM5S4AmScEw/TOg5KWB5omrSCDb45jyP?=
 =?us-ascii?Q?PonVhHcBcU3XN3nY45KIxB64Z2Ch9Mkv8MgYQzbMUnWisDfMj8l9CPWyLPu6?=
 =?us-ascii?Q?PNJtDVWJjDYOc7qlJaHObMF8ymPWTpKvsVkZAadQD8+JDcatF1QoKhNHlk6a?=
 =?us-ascii?Q?wIPXB4CaPw9X9gZx83CxA7h7FRnQ9qJflZCBDOeBukXPTcZLEywJWtCR9SA1?=
 =?us-ascii?Q?OXtt9A/9+4m/kktRj9GmF9E0uM6RUpZyjwf7WnoTbz6D+THPbQfpvzGW3nO/?=
 =?us-ascii?Q?SPaCMw7+NDBL5jB0yDBd7AayCehzAXkrLOP4guxU+K8bIsfnEtBF2usp9cIo?=
 =?us-ascii?Q?hbToWnLRvcgqMW57gBEo71VoMMlZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l8w9kcEUQPnw75PjAQd/tXrJuO6s1LAB8+XiS5j6Ptxy0TzGVcCExbrpIUZR?=
 =?us-ascii?Q?EtOiu2xFtOxkkPzp38R9kXjsDwrwqqPpz/vu2n4ZxoZbWGS8zDdb948pkDEK?=
 =?us-ascii?Q?reAdQjyL4iUO9BSEuv+oZE6HyNeSh9mZKTGrVcSda4cSgDQhFDNgYcxRpWr/?=
 =?us-ascii?Q?UHc5Ev9LIq8a0dsxcjqfOkguyhQkKJZJSLIfYzOns+xzoa99SR2wX12LWQ9U?=
 =?us-ascii?Q?1bwzaD27rDJqFZDQ4mKVGnuDMUt/WWsfZDFSHtbMRhgIZpNgXBFC7S/9WDjj?=
 =?us-ascii?Q?piuRQC+/XPCAFhnOOqIxDDurlqnHwS4JAgHHvH3QZigU7WG8zLiw/FtbOs7M?=
 =?us-ascii?Q?rvRuTi4vS4c8vFLPlBmNiMX9Me1VziO1BTwCONF56iVDRR16ztlLB9Lfs0Uk?=
 =?us-ascii?Q?b34lLDH1UufJaOZ/wzfCn82LJ9iGATPh1MKyq+3+T6O+vpGEzFfTiVtxTqDP?=
 =?us-ascii?Q?6eUeckNSBixByw5VSLGpL8O+zhLGtJuL7r5c3/pzWJu8jZ6yh++MMUg74ja+?=
 =?us-ascii?Q?DTRQk0I5vPm1uWNoQsTfYxfIpfa0yegKOa1u4s6duMVLKAEGv93yAB8xvtOM?=
 =?us-ascii?Q?uSKjje9ITCX6uvKFMmrZhp/VNGHCoGDAzL5+hoVTWCxXn8mZk/iQQThkxSTt?=
 =?us-ascii?Q?SWXgZ4rFX/ERVg0+Q+i0XQWEyyvzOJDzWQVDzrb2T72Ac7+HTjdGBj6Ar5iv?=
 =?us-ascii?Q?gFeGYF6pmNh7ztO695gE4qvVrrqLaIwyzBE2TMC04iIDxzEaKxcdIM2yAg8i?=
 =?us-ascii?Q?RRyjpWJcE3XZSpcviJfQa6IEaLAW+U0GLvqxd7xr35T2Tknw3ifjSiGGyUic?=
 =?us-ascii?Q?6cf6ryNW6ZN44HZc1z8g+AbFOyJnoxEC5FmokTTn2NhskxpoESmFtlLbjeVB?=
 =?us-ascii?Q?7jquA99ZY6c4+yAVEBwDWm4puozXqBrcyAhnSvaC3vXfnhevdpv2hwM1G6nA?=
 =?us-ascii?Q?gPQBulmWnEJr86huNDImzLmTJr7D1l4AawNlvDGTVQpoaDc4VauZPk+zTCyA?=
 =?us-ascii?Q?YemeIL9ixS2LDsn7qeZrRkaQSI+LBngDltP66Rz4WIcnD8iJrw5Mk4ZcomQ3?=
 =?us-ascii?Q?hnDcxr1RDrCIwZkBpMYVRS6FE1kMlWWFqXJI68+6/f2Zb7cgt8Il0eU6NYAD?=
 =?us-ascii?Q?VVLXD6HvUmUIA6mIiKEZvbci8XxmivEveF4PwoDDVxdx/bZowTXYY/jpXeLn?=
 =?us-ascii?Q?p+u+9TJdXN82539sdshTmwZtRKiKRc87bN+e/Mu1dfPIOUTKvDa0eV91pZat?=
 =?us-ascii?Q?EYsasU2IrRa9Tr3+a69tyh65q0NEF6s/LURrCj2kuWIaKtt29Gv8cJ8A4ihh?=
 =?us-ascii?Q?XGvK8FBOQCiuoxDBkJGmEqo9hgw0K3qlWQrKMBDuJW0m6lzd7keynTjfBqEu?=
 =?us-ascii?Q?cWYy5fpCJ2AOR7k1E0Mx6b8FKOAgB/31BwRcAIKrXE0F+sYrxu+aY5F+A+k0?=
 =?us-ascii?Q?X2xMO1fByt8mnETyBH4U0by7QPPROIl983MProgNTttVfsRcor7E0BUPxqE3?=
 =?us-ascii?Q?+TBKoBVzSq37/TKKCyht08aZGxe34nRrRggsGy/FTrjlSm3rA+HixGaoeLsX?=
 =?us-ascii?Q?wby1Lxn83ewI4FI9REAQ0k24LJhxfINGnAYuQfyzCApVeNyNC36hDuHK2tF5?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mhkhB3EED9S5ZI6x8xyo1KoIIFl1B6wOH5u9bulwYn0qaTIgwwjdk1CPelpyJxlPOWTxjgCeoUtRjM/kb/FIfu61DQpMwW4AfFRRLdbZf2COjlfiMDLSKPyaIMrJFupRjcGapt0hzKpz1S3DaNuTEO3NNqUZNISDEcGPE7XHaDOBP2dluUY0hgK1ojK37QrFe2ueOkvuIqlRCXcbcu1cXvRot+cnDU7KhiwIfzBjuXzYo4E1MNM5IGy6/zvFxNvt/zPXTr9pyyH//7PAS2AeTMF4pm4UL++HDmRDvdkK9BaENiRp/2ZqoXvTaofThV+El+nSFCeIKF4veywMK91WDk8R/6WALDf1uWwJLjb6Tfy4gXh404GGB8ZIsx+l00P3ugGKGuuSq2+3Mxt9Be0sP3v6BppsDc8JVjDWMDpdUMB+iTBlqxbNMGEoBTsCzAOVsTKYg1YInplWrbAfPrqxqjsOUlEEj8VxZuiNSHrGWfDIVwxQTwNLVHEWb5m5MD7tFpaVMq/w/SqesAYYWnO5oOU2czl6pemCVLzpmvnbM9x5K0YTZVlr0KFraO3J7sAYM+OolUwbpQeq/XLTtIWD1XPsptIgEjGZWJRrKgxCUmA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13aa597f-bff4-4764-9b35-08dd3f19fc03
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 21:31:39.2705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d1ljCZruB4zDfgAsisFP+JiuxwCbbtz/yinN/frIftm+0suWiUjlf0bSE3lXCpgRosDOkQKZE4tR6F/+vLyocfG1b5/Ouy63fYRSG1iLLWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_10,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501270169
X-Proofpoint-GUID: 30mOedlXQjhBSKwH9hLv5wLDRiHvjScE
X-Proofpoint-ORIG-GUID: 30mOedlXQjhBSKwH9hLv5wLDRiHvjScE

From: William Roche <william.roche@oracle.com>

Let's register a RAM block notifier and react on remap notifications.
Simply re-apply the settings. Exit if something goes wrong.

Merging and dump settings are handled by the remap notification
in addition to memory policy and preallocation.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 backends/hostmem.c       | 34 ++++++++++++++++++++++++++++++++++
 include/system/hostmem.h |  1 +
 system/physmem.c         |  4 ----
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/backends/hostmem.c b/backends/hostmem.c
index 46d80f98b4..4589467c77 100644
--- a/backends/hostmem.c
+++ b/backends/hostmem.c
@@ -361,11 +361,37 @@ static void host_memory_backend_set_prealloc_threads(Object *obj, Visitor *v,
     backend->prealloc_threads = value;
 }
 
+static void host_memory_backend_ram_remapped(RAMBlockNotifier *n, void *host,
+                                             size_t offset, size_t size)
+{
+    HostMemoryBackend *backend = container_of(n, HostMemoryBackend,
+                                              ram_notifier);
+    Error *err = NULL;
+
+    if (!host_memory_backend_mr_inited(backend) ||
+        memory_region_get_ram_ptr(&backend->mr) != host) {
+        return;
+    }
+
+    host_memory_backend_apply_settings(backend, host + offset, size, &err);
+    if (err) {
+        /*
+         * If memory settings can't be successfully applied on remap,
+         * don't take the risk to continue without them.
+         */
+        error_report_err(err);
+        exit(1);
+    }
+}
+
 static void host_memory_backend_init(Object *obj)
 {
     HostMemoryBackend *backend = MEMORY_BACKEND(obj);
     MachineState *machine = MACHINE(qdev_get_machine());
 
+    backend->ram_notifier.ram_block_remapped = host_memory_backend_ram_remapped;
+    ram_block_notifier_add(&backend->ram_notifier);
+
     /* TODO: convert access to globals to compat properties */
     backend->merge = machine_mem_merge(machine);
     backend->dump = machine_dump_guest_core(machine);
@@ -379,6 +405,13 @@ static void host_memory_backend_post_init(Object *obj)
     object_apply_compat_props(obj);
 }
 
+static void host_memory_backend_finalize(Object *obj)
+{
+    HostMemoryBackend *backend = MEMORY_BACKEND(obj);
+
+    ram_block_notifier_remove(&backend->ram_notifier);
+}
+
 bool host_memory_backend_mr_inited(HostMemoryBackend *backend)
 {
     /*
@@ -595,6 +628,7 @@ static const TypeInfo host_memory_backend_info = {
     .instance_size = sizeof(HostMemoryBackend),
     .instance_init = host_memory_backend_init,
     .instance_post_init = host_memory_backend_post_init,
+    .instance_finalize = host_memory_backend_finalize,
     .interfaces = (InterfaceInfo[]) {
         { TYPE_USER_CREATABLE },
         { }
diff --git a/include/system/hostmem.h b/include/system/hostmem.h
index 5c21ca55c0..170849e8a4 100644
--- a/include/system/hostmem.h
+++ b/include/system/hostmem.h
@@ -83,6 +83,7 @@ struct HostMemoryBackend {
     HostMemPolicy policy;
 
     MemoryRegion mr;
+    RAMBlockNotifier ram_notifier;
 };
 
 bool host_memory_backend_mr_inited(HostMemoryBackend *backend);
diff --git a/system/physmem.c b/system/physmem.c
index 146a78cce7..52cfdeabe7 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2222,7 +2222,6 @@ void qemu_ram_remap(ram_addr_t addr)
 {
     RAMBlock *block;
     uint64_t offset;
-    void *vaddr;
     size_t page_size;
 
     RAMBLOCK_FOREACH(block) {
@@ -2232,7 +2231,6 @@ void qemu_ram_remap(ram_addr_t addr)
             page_size = qemu_ram_pagesize(block);
             offset = QEMU_ALIGN_DOWN(offset, page_size);
 
-            vaddr = ramblock_ptr(block, offset);
             if (block->flags & RAM_PREALLOC) {
                 ;
             } else if (xen_enabled()) {
@@ -2252,8 +2250,6 @@ void qemu_ram_remap(ram_addr_t addr)
                         exit(1);
                     }
                 }
-                memory_try_enable_merging(vaddr, page_size);
-                qemu_ram_setup_dump(vaddr, page_size);
                 ram_block_notify_remap(block->host, offset, page_size);
             }
 
-- 
2.43.5



Return-Path: <kvm+bounces-40869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F8EA5EB18
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:22:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4736D3B9AD4
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 05:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4A81F9EC0;
	Thu, 13 Mar 2025 05:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XVCrox6f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Uvs0X3Ab"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CB08635C
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843368; cv=fail; b=Rv+M3u2/uGhNlpKlMZAHhL+rc4lDymWHGARdRpLi1mufxQJhjrRkSW70ghYFV+UE7TGTjNgUB73y5mrUBjsKPSe8KpVvQ86Gc3hLMBFdFOTuA2n85x5nS9zAnOvExVa6Nub6WxgDyEALaVpvzijb+bAoHyw775p+9grTOpUlrAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843368; c=relaxed/simple;
	bh=gwVBv/YHYz47AocsrnVW1c8/gczkH0078VrjI0MyXz0=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bnRHYGRdC2VVNetwpjOHV6Ev2JQTdwdL1/CusrwpO6cU2i470naqtmwiOqCHUVUIs9Zd04a4fIDuf64l86NvaFye2sQW6doDiE9Lyp59EMgduvK5v/vhr4iVnL5QyNptsOUtJyB8OCdf/cLHxHqnjJ6WcIo81vOoQDZT/PFAKes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XVCrox6f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Uvs0X3Ab; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3tj9Y008197;
	Thu, 13 Mar 2025 05:22:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=SUoNXQZJNzwCb8MC
	8y1k/YjC9cOMgkBJRFDmq3i5bo0=; b=XVCrox6fYqcbb2fDwDn6SJ2nWnOu+Hx0
	sGQ6BT1vWE4BowckQaCuvbCkklZ+LCnf3p8GVt02L9KgzXDXLkNUw4Phq+DRpYL/
	MCYd9bMWO4dhDK8x1odKu4nCJoKv/wNN/OFMIatcEHoLfO/CUZ9VaWGQoRcdqZji
	Sy7KoMeLCOFzOn/CgrbM3NfOZKkwfwtxvzic9uwd9QOahVwloDoiz0HBxAS/XuRT
	zhnEiSUhJ8u1f1tPbySbCwSmrs4xCW9dTbXcWG+x3wrD4WkPJyO8xzyLV69E56H5
	09IKfo+W/KtNchNwZJJeJcP+9fJrS5KEVRWHr+wywW+pcsf05zue5w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4duffa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52D50Knn022329;
	Thu, 13 Mar 2025 05:22:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2042.outbound.protection.outlook.com [104.47.58.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45atmw5mnc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LLnGod/QSgMgcfGh5KnIzOCpYMsYSp0UnuzbW1JxcftPaXabnK8CoYENzfL8TEVKsQfCqp84MFfWBxGKcVH015jjw6ORmgcfRPjCaCVXPuImBgQ1H3kY4pG5HjNb8E/CjsVJr4oJWgklfeXtUjEgpe4Fe+o78L5xUkQGowhXKDF781JDCVEhcwxYBTprG/kFg5mtRbU2uE40TwRsIhQVI2FwJ8CiNooi8d3uD50QGZFhSEm7d6HaQBgxKppWjx9Htc1aT49iIdQycVBnS2JKdMfTGTJDBUhbbhFBC1mk0ZTk3qXYpY4PcJz6CTZyxhG/PrzTef+ykBvhoREKs3SnfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUoNXQZJNzwCb8MC8y1k/YjC9cOMgkBJRFDmq3i5bo0=;
 b=TM8YsgbnN8WGAieyyanZl1VWDhVwFNjTzMK0DyGR4XUrAKQRRGQr2FZ2xe9+t1MfJVzDLNP7hY+Nb8zV/f+/3vRUy+YGhTgWXeDPAnwlcMi8L0RIFue9lJ1ZXDzC0Em1S6AreeCSiQN4DW2qbY3HvUxlak9QvAdPjq3yS9i+mhQVEFXnI1BSlfSB5GSIDcuszMzFmyQDEey0fZvgMK5TciIdBMIIfO0ou19NAigx7ZYzhaSpPaZWe1zJHd9T6Q0Cp3adEwug7ZT+rWZ9tKFnZCOm6GL7w+GKaoMh5hM0Md2rVNSZmpkIG2MwE5UAiCdTfN/p33q2+kxdcgw+3S5rrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUoNXQZJNzwCb8MC8y1k/YjC9cOMgkBJRFDmq3i5bo0=;
 b=Uvs0X3Ablo4GXaX615Bdh9lZQjclZn6EVVCYECdjRg7BR46X3B84SLpTW9nnivrIKPPkr9VAR3f6/mXLZ28pBkRCEX3ufS+mGowZ2Bp3DWM0jwkCihoN91odDf43DoP4D1a2436c18ABC+j79IG1f4Ud3de3jo2KFKArbDcc3cA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 13 Mar
 2025 05:22:24 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 05:22:24 +0000
From: Mike Christie <michael.christie@oracle.com>
To: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
Subject: [PATCH RFC 00/11] nvmet: Add NVMe target mdev/vfio driver
Date: Thu, 13 Mar 2025 00:18:01 -0500
Message-ID: <20250313052222.178524-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0071.namprd04.prod.outlook.com
 (2603:10b6:610:74::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b56ab80-2b54-4f49-b443-08dd61ef09c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Tf+lmiQbZqgRjlKpRzDRnZPiopd0nF6KSCb2oQfwdHWOggEq1IB4VLVOcPOz?=
 =?us-ascii?Q?/EKDOl83yiYAP7rSFjyuPymd3z+vOuxzUpptRcrDkWgcL7WbQmw1wacQSMxr?=
 =?us-ascii?Q?iEp0dy4q7Feuzfjn5bPYE1HL4Xs6yc0J2CdgA4yD84SFtiRRIyH/vmTDALzm?=
 =?us-ascii?Q?LTo+FEMbvCmmSO3xhfgGYDwQDXARRCDPcTeEpFJuExfU9BulViwm6upfwVDo?=
 =?us-ascii?Q?QDZ9JwRAg0VgqHxGJWW/zi8fYHRHGzR+atubQcFeT4UPgZ1vYSj8DIhsUYkA?=
 =?us-ascii?Q?d5NikWrwoBTM1dWEzwA2YH/pNZ9KpWx0tHLZkXEiA3UvG+cHE/kDfwy3pjnF?=
 =?us-ascii?Q?NAU7wC9aVlrl79SgSFLBxMiXufho7JPsmBIK3aKMy+IYMKsJemfeWLCKrwDC?=
 =?us-ascii?Q?UI3mZs++r9Ba5+ZdZbkRVLot03eEX/dDuA0TOw1aROrFRKI3U8DdLEu+Ftku?=
 =?us-ascii?Q?4okfGMeEvfh2MR3+fexhO1JZ5wKHgxK2EBINBAaeUnAbFndyx1E7TZi3TpUa?=
 =?us-ascii?Q?W2FfwzRRgp3CzbBz0Ukcmuc4tp3IkOz3OoAdsGGL2VXN18E3jft42xPFtSrG?=
 =?us-ascii?Q?CMwqn8NTmNCl11KvI08IrMGvAV22rLy6xSjAoHd4Ic/jrB8wH6SJ9ID2oV5s?=
 =?us-ascii?Q?QPOi1tcZbFfuYIq/dUzowufPAvN+mGwOe39xJkFXL2rx1Bxc0hXRq27lPv7L?=
 =?us-ascii?Q?bKGPyugqwlJOOKDc4AVVJB5Nr872wIn187VxMuuF7xlNBvnT69f+gHqIrt6b?=
 =?us-ascii?Q?FMB0EwEsE72LTvpCIr6A9DbQfPuPsi0CYnocv3ZCJ7tdVo1Jr+9WJZnvCf9y?=
 =?us-ascii?Q?C+oIGKCqA4Dtmc+Pmp7HqwPskeGYRxwImUh3gysufgd320dnr5DScpnwkNMk?=
 =?us-ascii?Q?mT37TgGPqfnyFLCMYpSBstcp+hR18PN5yGoPcV8uDkkxPaOvRF8Huco/QaF1?=
 =?us-ascii?Q?B/Lg6f8iTpXxjVVDRf22zmgZN56puHwm90zR1vQnymHDsGkXziUncs7b8WhU?=
 =?us-ascii?Q?mv8LQ6p1fBJzjiXuVKlv3i0jbJX3Q1wmAI6PLlMGXXhHRhZUd/vbYb1S+Zno?=
 =?us-ascii?Q?jGIAn+zfGjj0ddF9+dWFxowZ/GxI6W3jlh/aNhCdEL8r9BVx+mDtsMKkMawY?=
 =?us-ascii?Q?AcZKUMjyxEbOEXXURiv4c/30iRMMG4q6PuPboYYhvV5wU6KStA4Z+ZUhYN+v?=
 =?us-ascii?Q?L2yQGRo2DtDRxLfwonHAvR4LnJDeNqoCSxCocd4ZhptcDSBPiuvG2ctuJUCp?=
 =?us-ascii?Q?VFEPynb99VvL9vNZ6+pUrVkpS0n1y4/01As8YZG1OxgD6MI7aCKco1iwTdfD?=
 =?us-ascii?Q?FjPNk2XLHP+TA3F0yOarh9QiSQUfl5HM4GVSecncQc7fYO3oLqWx3eJTaNj9?=
 =?us-ascii?Q?uXQHtJdek/NvTICR8vCrsRzC/Nks?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fxrmGm5Bf4wpkw3PjRVYTB7cne8tY6yhI1EcGt/HBRNjlyz/bUuDJhR+zksK?=
 =?us-ascii?Q?awEJhVY1aCyyG1M/K4GxtFLlLmFj/2buurCKCg8AZbYQsAE+4s+zymEVy96o?=
 =?us-ascii?Q?ux+bdG1A5m6HTkANDYx7bbpi6AMfwU238gz20bgNmJ5Hy+PqIi/t3EaGQXbH?=
 =?us-ascii?Q?w0luOBzNYwu451i96OpVBUlj0/gib/f9mHLWHGYz+4WXlMdMkZu+St64nQQ7?=
 =?us-ascii?Q?r5KFG1UJoJHllXvZskFStJ95icpES8oRZSDBiFHLkX27FCLEiDuMOZnCNmRX?=
 =?us-ascii?Q?SJBlM4xTsY6LtZJk6pA3NZiO8yr4aswEfbNqNmCNshpGOjxyGRHAfgETWZ0l?=
 =?us-ascii?Q?Su1NFT9ttQsUBMKBfs+8plODVjLAcyAHHRgDQAl+YAYNvE6rZyqhC+jOLQ1L?=
 =?us-ascii?Q?haBS7c1Pd35GxxDvCITPLLgPqX1O2/3PB1T6EWONoMb4j4jioCiRsmdHyjCl?=
 =?us-ascii?Q?oGoEwR0WUJNYh0v9t9tdu9XRyDh+Pm6LrK1Md82u7MQ3aumU8zQrTuidizZ9?=
 =?us-ascii?Q?sXuR0Vuk9+Zx5758dtwX+bWNvOhOfCVwHCtZTawzXPI64wD6IavQNGIzuhfj?=
 =?us-ascii?Q?fZyz96ZqWJukKyqX8DsWDVxUJ/1Yv2YT5iob5XKOmb3iOTdgfSLO/MShvrZg?=
 =?us-ascii?Q?mvKG97fnnSXlbiCJcxBf30H6pYGY0+it8g3mXKuGve8U+WYz7CNgtt7xCh2x?=
 =?us-ascii?Q?m23cgy/4/nQDjwNErdnbzUOjM1d0LGedjXjJq6fvd610WHb5O/cRLiQM8fZo?=
 =?us-ascii?Q?POwtnhvArykorqawkJ4XDml1ExVT8Isp+qQSCH7LIwsPZ1Wi/xvP23yFVD1M?=
 =?us-ascii?Q?vZ8dyIQA8QjGXOBmUazFtJwjINcRJJG+jDI+eB8uC/u1l3J/cuFKXtbhvLdJ?=
 =?us-ascii?Q?y3z47yyyACm7vxfoRlQbJR+Nbhn1DcAX90OBHN8gjKnEw0BybXXpGxHSeJGL?=
 =?us-ascii?Q?7aUm8lrFS40Ym50oSZgvTRIIHg6flBsMnIRbliQjGa0g4t9fhUhVCRd2OYi7?=
 =?us-ascii?Q?5MWZp90+jtBLHvLE9VKXq60J0vkZxzctpyemZDThh+DXk706+m6N89CAPWgc?=
 =?us-ascii?Q?II6d486vQXuvTe2L7dkIWE2ilod0zenvpHnXG4WHsUebrIwz5o0luCsrWKPl?=
 =?us-ascii?Q?DfwBW+gmR45p13ojaL9YP3745ezhLeC//Piidmeo31yuNIipKbUwXAcQYeLE?=
 =?us-ascii?Q?TfRKudkUihtj6+35XH9lpzQ51ufiBdTbZ62nnYpwFouBUJvimfDltfQc1mYD?=
 =?us-ascii?Q?X8WWHuPpFCNbytdsxLDLyxM4UDhRa+mPXeHSIUGlUWSbA9j3wpUGaHMlqLh/?=
 =?us-ascii?Q?yQEkKwPL/dnM+Din/o9KNETtMHo8nurSrFtIol/p7XNekbx2rHN0NU3zeK/E?=
 =?us-ascii?Q?LTVV548A17QwMGzcatgSN6y19zg46LaXNTLD0f89oC67jyfEhhqPFe//6Mjl?=
 =?us-ascii?Q?pVtC1xvrpXRlg8kuAuey5sBBnhCm7FLNiHQwgGElZnfAaD0cilgnFk6GEydJ?=
 =?us-ascii?Q?sQdBz3o4d2zn9npEu1ISndUdNLIVyR4cEpAN0DbNtyixd8sdbvq4n5y6p+5x?=
 =?us-ascii?Q?Zjlj2yYgXNUUm6G4glfVe+MtWr/U0vLiHrUM/odzoVgiiwwfObw6s41k7Fzb?=
 =?us-ascii?Q?YA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xQUkRCc5UhmpbGA0b/vY3XcOwLLxufpRWquqKWommElaa/vhg29gYSWyxp8FeLW/4JwZetm6FuvAXn/HJRUIRMV3pRDg/CkjTRKs9VLACwmnkkRHrPq3q2LAU3WCG5OSoADDN1DT5W3DwrvIQAeEvgYlGewnROyK0yxbuF2c31P2GQVlF6whScJw7ZG+V6YVY7xzYagNTI4nB9PNtDqfr35h6Y2RX4liPPry6lTlZ6RydSq2Z9dljtu236sGSmPPHBfMDh1JMAzxtyg9JAV4EizQ7hWUgL4AWGQ4rmIRXCyjaSODp+itATUd+Z7I/bYr4EVesIqicmQoByHlN2OJDfkpZW3CoG1IJ9dSkBQ+tvO+hyzS33HfbSHZ7b0p08HL3Tpd3EQHrw6tn4eYymkMPb4x0XIEBj7NSB/7qci2SCz6QOII99HXzgsfYMgtzjYj7rE0Gt6i2DR+JT39UGvm+SG78EbuvRzO8E4/VLrxGI18S2kyNcsTzM8KsA0HdhgPh5eX3EdjclyjP6MXA5aM9OCBFqWkROtEqXET2DSyCVl3YFnU8BC3V2395yax01NXoOsmcdg1KxOBnU4N4AH+QfvAZup8/KAiFgY0xBJ2NIE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b56ab80-2b54-4f49-b443-08dd61ef09c2
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 05:22:24.6976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jpt/JOPiMDtlNTziShLQt7CNCeREISINY21h5d42JQzpcMlqrK/VCpjHf+DdkuIDCI8JkKWg9WNF/e67JLL1Z1YuS9PZdo2B+u0nqUGbg2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_02,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503130040
X-Proofpoint-ORIG-GUID: tgx05y5yWCnEe-CYdaZpVtEKvYEGHaXt
X-Proofpoint-GUID: tgx05y5yWCnEe-CYdaZpVtEKvYEGHaXt

The following patches were made over Linus's tree. They implement
a virtual PCI NVMe device using mdev/vfio. The device can be used
by QEMU and in the guest will look like a normal old local PCI
NVMe drive.

They are based on Maxim Levitsky's mdev patches:

https://lore.kernel.org/lkml/20190506125752.GA5288@lst.de/t/

but instead of trying to export a physical NVMe device to a guest, they
are only focused on exporting a virtual device using the nvmet layer.

Why another driver when we have so many? Performance.
=====================================================
Without any tuning and major locks still in the main IO path, 4K IOPS for
a single controller with a single namespace are higher than the kernel
vhost-scsi driver and SPDK vhost-scsi/blk user when using lower number
of queues/cpus/jobs. At just 2 queues, we are able to hit 1M IOPS:

Note: the nvme mdev values below have the shadow doorbell enabled

        mdev vhost-scsi vhost-scsi-usr vhost-blk-usr
numjobs
1       518K    198K        332K        301K
2       1037K   363K        609K        664K
4       974K    633K        1369K       1383K
8       813K    1788K       1358K       1363K

However, by default we can't scale. But, tuning mdev to pre-pin pages
(this requires patches to the vfio layer to support) then it also performs
better at lower and higher number of queues/cpus/jobs used with it
reaching 2.3M IOPS woth only 4 cpus/queues used:

        mdev
numjobs
1       505K
2       1037K
4       2375K
8       2162K

If we agree on a new virtual NVMe driver being ok, why mdev vs vhost?
=====================================================================
The problem with a vhost nvme is:

2.1. If we do a fully vhost nvmet solution, it will require new guest
drivers that present NVMe interfaces to userspace then perform the
vhost spec on the backend like how vhost-scsi does.

I don't want to implement a windows or even a linux nvme vhost
driver. I don't think anyone wants the extra headache.

2.2. We can do a hybrid approach where in the guest it looks like we
are a normal old local NVMe drive and use the guest's native NVMe driver.
However in QEMU we would have a vhost nvme module that instead of using
vhost virtqueues handles virtual PCI memory accesses as well as a vhost
nvme kernel or user driver to process IO.

So not as much extra code as option 1 since we don't have to worry about
the guest but still extra QEMU code.

3. The mdev based solution does not have these drawbacks as it can
look like a normal old local NVMe drive to the guest and can use QEMU's
existing vfio layer. So it just requires the kernel driver.

Why not a new blk driver or why not vdpa blk?
=============================================
Applications want standardized interfaces for things like persistent
reservations. They have to support them with SCSI and NVMe already
and don't want to have to support a new virtio block interface.

Also the nvmet-mdev-pci driver in this patchset can perform was well
as SPDK vhost blk so that doesn't have the perf advantage like it
used to.

Status
======
This patchset is RFC quality only. You can discover a drive and do
IO but it's not stable. There's several TODO items mentioned in the
last patch. However, I think the patches are at the point where I
wanted to get some feedback about if this even acceptable because
the last time they were posted some people did not like how
they hooked into drivers/nvme/host (this has been fixed in this
posting). There's some other issues like:

1. Should the driver integrate with pci-epf (the drivers work very
differently but could share some code)?

2. Should it try to fit into the existing configfs interface or implement
it's own like how pci-epf did? I did an attempt for this but it feels
wrong.





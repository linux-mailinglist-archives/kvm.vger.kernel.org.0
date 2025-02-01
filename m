Return-Path: <kvm+bounces-37070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD30FA24819
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 11:03:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9DC47A312F
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 10:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF52143890;
	Sat,  1 Feb 2025 10:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eaj2pF5v";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wvmbT1w0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3F646447
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 10:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738404180; cv=fail; b=K82Lz+nrPzz/fsUYbQwyoDsNV96mDQZ30Eyb+ANMStfY+worrAz8Wy1X4DYIcvAt/r7n/8lmMmxb32/iGMZn2aylMkVliWH/10PJMcWv+ALBUlhSve0+4s8fKNjTKEmm1ela2+C0QuK1QXsHGRgTtGX0vyMIGCOmCrWmP+byAwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738404180; c=relaxed/simple;
	bh=NiV3fnNU9ZgFImQgPTU8FXCv3w8EO9Lrl+UusSIouNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i/N4MUpZt60Lu9NCYAxQQvnnWTqxAb9jUKZOyWWJbeMDGpXXzaujo3kgxi1ImW9pCWBC49+cyfySmYVfXmfIkDiJiv/dxgJCCQbv1LjzHzGHvnak7U04b6qqdooxk5V6GXT2USwtbw9AcOjbz4GnLYN5cVKO1vRyI1Zui8RtoBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eaj2pF5v; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wvmbT1w0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5117bAKP013219;
	Sat, 1 Feb 2025 10:02:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vL2jjElpiN5znzBZn2+JD/k0LAksvx183MJLEFUYI4c=; b=
	eaj2pF5vHZRgftLD2n0ndMLj0zcMwHMHRRLcOqU2r32bpNp5VTQi1kMRG59I8DvQ
	ruf0u1MIdr8s8CFdMobpNq5f5j9RrUUIJRa5RSZqU5hY3vIKRlc091BBMXoA7YLe
	FcGyOgF8SZa/WciK2PPnC+vpYggHMymzZyik9Y3hwzO4ZlInrisuCibeNdKiRTjn
	QSalRlVLcHgRN6i5cYxnCWdwTN2TZFPGKbMqeYKTLQ2NgoI5hh0GQkD2GFzRvkRf
	lI1P/WGhJw71td38xUcST9atOQaKv2nQLl5Qje5ODPXgzgpxivY/S6WB9RaAWHOh
	lyZPQPOZZTklb5GRodNNtA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfcgr3gk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 10:02:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5119F6IP008788;
	Sat, 1 Feb 2025 09:57:43 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44ha25fbpm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lSHC5QMjunzMtIUfiTxGNqY75BdEBi9mJE+ztdbNJqVVSzac5QZeiIBhYB6bc4UMUnNYr/PbBOIYJTwhxAyS0COmLEsEoEx3VdPG7M2T9yxsDiQf+8jLQooXe/x5nftepHbgRNPu6AV5puNlI2TLHFtFk/WjbVM1EgazJO5VM5RSHMPe0CJjjIevoPKeH1YLSA+nn9/qmUkzFyjxBJ8SP0yLS5SnkfJBeO7Emz+ZYEs4Lm7Y0h2iWttkXaS5qicUnXCFZJkEJc/ohCTu4xwtwvkboOqpF1CoIGshOVEK9aZsEfsCTbSgSR1yfwh7QyUcF2HzI2v7TUUmqA06Glj8JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vL2jjElpiN5znzBZn2+JD/k0LAksvx183MJLEFUYI4c=;
 b=mmIYsG1SGd9+aSYfCUbVj9AgHoCTjYKyPjDEBvvyQE27/wD+fDB5W5mfIMGDdVeL+74FxUZXtptKV8OzXS3ZvbnOKGER4T2tkhZte/8/XzmDkdTZSlppkHDGPooo2w2ckHsMuAr86tu+BbUSrF26EMD1ii8zAwmBVbMjcbI67gLm97Hn4PZvDRoDa+SULFYCeeTmM7ym3NHvOz42IIRws5054WQ4ixsGA9SectrmvgfWNJIuBPtyQHfEKGdQcw4Imvlq2hPGWX4NpI5c2JflBLGsM3PS2VFonx/5MFobcm1m8S2rW3e+RnrZon47OSrTDKq+WwNvAnVZ2IAH7ZfUHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vL2jjElpiN5znzBZn2+JD/k0LAksvx183MJLEFUYI4c=;
 b=wvmbT1w0RW9ORBkgyDZERe8P/a4ViHgKTDCJbwcahr40nhBB4GeQGNiLS6MZKWJpfBGgTZ1QExtDfX8wWwQlufXLlvHxefYlYFg/gy7ijVZFGUI+hW/zMk4WYqk6SUrBcJfzugOjVUGlnhhXRxDNXe6/aAr6QsBG7Agp7ddM+zU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:94::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.22; Sat, 1 Feb
 2025 09:57:40 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8398.018; Sat, 1 Feb 2025
 09:57:40 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v7 6/6] hostmem: Handle remapping of RAM
Date: Sat,  1 Feb 2025 09:57:26 +0000
Message-ID: <20250201095726.3768796-7-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250201095726.3768796-1-william.roche@oracle.com>
References: <20250201095726.3768796-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: f5c1fbe5-ec5d-46b7-44ca-08dd42a6dd9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?loaURQGNAYBqPH4SVSDxt63su/9HJD4ccBoGweYfE/FpTX2t5aQZDOdRgQZ/?=
 =?us-ascii?Q?7CnDhGJmIVCm5+9dpU6519T0rVYrZ1yrlVWq9mtanvAEXpJnVVMuD9zI4fAG?=
 =?us-ascii?Q?gXulY6gj/ECmsWaETx7nP/50Jzrb9v1G06QV78zXpgFeuO1Z1ULlS0awGNFy?=
 =?us-ascii?Q?QQAFBW7kx194hO2H2a3xAr1MuqlMWvVhVy6efm0vER6d/mQRGgPKzOhWwEgt?=
 =?us-ascii?Q?Ngq75XYiCfJc8pS8v+kineGZw63BTjGQFQw4QYbRkU8pdtGK7mD9Y1tQrUaO?=
 =?us-ascii?Q?lD8h1wQFo57hSA4It+h7HUKXzzgl8uxQXtDcX35qbK4Iw6MC50wSGuTlAVA2?=
 =?us-ascii?Q?ECfdy/6aNNzmbNDocOhl/wOwiEuh9yGZ5ZLTnUA3notDa16W833HVo1RrF1Z?=
 =?us-ascii?Q?dE62ZDvvuj9HL9DQWwNCjE93RPDt3ENjv1AfBCQKJN+cM5awxorLBEUJHEix?=
 =?us-ascii?Q?IUuGEa7ocCOphepvjENm9PzJAICBzQyAScefFhR+enQSqo9mGijV6vxVZLTr?=
 =?us-ascii?Q?ctjOiySVntc9C4gEX9X6DnXB00DQccUKLEnUsyskbofawn+y0qOhRMoyFsQD?=
 =?us-ascii?Q?w9S/7amUTNHInRBP3666sphfmUXRI3IELCOiALmyD8bH0t/BtauivF9f4qSF?=
 =?us-ascii?Q?f65WkRJLFu8VkudL2Ix1Qs0tgPU+KKwYDmT8GF3k6eCy1auHW5JEX3HLpyZV?=
 =?us-ascii?Q?EVGX1n7HfSMntA/vYrjt41QiksFAItVhSXu0JafuMKsmwu9L+AUEq4cLBJft?=
 =?us-ascii?Q?42kOQHX4Qjd5XzeX6GfqxhbKdTuQ49f0cmME45fCDXdUoIERoHSU6VJnM67l?=
 =?us-ascii?Q?k3LctjIe80xRphuQ4Z7jqaI8H4E1VrGnqs1P+jL2Sfh9MdGscQJ1MJ+4yxgH?=
 =?us-ascii?Q?6jETIpnMZpNksNCmgIgjXAPMKxDg/IkzVbf6s5AADOpfihA3ZAnpTgtffVV5?=
 =?us-ascii?Q?h3HPR//pUI082SvOrkSw4RLzHC9/BEDLOdg2k8ymrCESU9lgGUN2y+C0IpF+?=
 =?us-ascii?Q?bbqu02MIlIp8+G3M36bN8OY+5uzGDNLs99l7wKKRu4M1YUW92q4jiC4xoi1v?=
 =?us-ascii?Q?rCPzfzWJx7aa5LePAfR8R+GfGE/jPFhzRKxKv20nd72v97SpT8N4PNTF1jn6?=
 =?us-ascii?Q?oA7Kwf7/l6sVX3qspCAMvGsTk4zvL16jfJArZDLOTE+j2hHrmjVKfV907W/z?=
 =?us-ascii?Q?nn83A58Rp9o8E3giHFX1CYAqhoecVIeagGSTokoLvcSF+SJmi/OfW7QMzmeH?=
 =?us-ascii?Q?AUszmpltjan38/4LPaCEslqC+y0uPlHhD0JbgI0vvsjKreYc/JK46xp3TU0d?=
 =?us-ascii?Q?yvTz9z99U0UvY7PcWlNWJ2MLAGVmVbA7sI8PVpgjL8+ncqgRCJt6bme6u5Em?=
 =?us-ascii?Q?JG1dftmhw6IVqi4Pk2syPg1zXOa5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8TTH6c4WgxGJu3sqzSgom9FILAbQ2lSbQZwf2eawIlULQIG0D6BdnOj63WRo?=
 =?us-ascii?Q?W4QBj3hrvf2FEzhUW5809xSDngssKr1l/STlTOl2w+RefjYKwV1wdEpQJhn0?=
 =?us-ascii?Q?gsX3+94jyQlvm/WxPxpKDfOtC6BvE5Zj+exgVMeXL8B6IaXBphhd916MCaXJ?=
 =?us-ascii?Q?CkSU3CMzAa+LTHnMg4PNXI35sKOF7vtOxNe+P1ggmtwUKhvQJqY5VmP0e9zI?=
 =?us-ascii?Q?yCgpakcHYRqsd4jK9fYBK3vNbGhyxkcpPYi2jzY1D/FEjEuWANibEfmR20KF?=
 =?us-ascii?Q?GU9Q4bjTzi2hxqmuuwIcLsUMWBDVgqtdRtFXT/S/8UuZY+XQ5YFBB+j+7q52?=
 =?us-ascii?Q?na5c55fHHi/ccGhlPiQQkIbSb7kctpDRJc0/dMfPnCqleIAsjVg3GQIXCBGd?=
 =?us-ascii?Q?LKF62JguqNxZnFEFzhNf86a2U0eOCNIjH/qnBlRQK3By+y4tle5CYmp7fkNe?=
 =?us-ascii?Q?kL5xt/OhlQyNEIPKGwiRCBmF7DqAyAptrHkwGjLapDyR1dCtTBoZYF1pkmwr?=
 =?us-ascii?Q?j7tqfMdK7rstOq12ZEXy4CsqHGlA9b9i1QHPXs+HJE/AySSSPBK+nxShIEuY?=
 =?us-ascii?Q?ANXWpcaWcPX2w7KGeBJq6TACRMSroHTbv4/dR+meVpAMokpDDtWU/9ueYKCg?=
 =?us-ascii?Q?uLs3CfqqnOKD3qblJFV8OiZWddJjgTGNU8BYDAo0bpVJjilw2ynF4VHACpdz?=
 =?us-ascii?Q?ZrUWPFbwrw3JQS3yAeUDnwD1kcuiGyoVcjSGVA9sLmwGsovUrZEnMTD/8YuJ?=
 =?us-ascii?Q?PLVF8hQK6XXI+coHAYUnYxcGmtsbS/iO5gm2YxAFJbME6PW1XxYVzsWx4hJ/?=
 =?us-ascii?Q?bw/ANZEy4clXRSGMBeZKP36SdaI8VTeYShZRhsAAceKCBmWGAalxqH57MK4I?=
 =?us-ascii?Q?zhLZ13Neg/lkBhiMbOabebjDj46SziYEPPsU00OMsMEjDjcW3OegHoedhmAc?=
 =?us-ascii?Q?aZxno81F4achhsid3UeUfvtz8SK950sBaaM0mDXhH+Yypf6Et+M1FS9e2iHP?=
 =?us-ascii?Q?R1DqymCSSD8NATdGrQEgkRyYNVNHtSEPjjtgPy0u4I6mceD50BCc4irIDtuz?=
 =?us-ascii?Q?/KHuLvVe5jGn7GchrqwYvr6DcHPt6EC+qux6b+rKalSBCj5jia6EHGIWUwEY?=
 =?us-ascii?Q?J7KkEQa7faG0yMcj1ieerprpQy+GJLph5HAMP6EifpXYp5QNpRNNjAKmEdJo?=
 =?us-ascii?Q?SogoHTKXbpQbj4QxHsOlRhFo4VCfV9blItsrecnzXuAepZEkYCEDoTYY3STp?=
 =?us-ascii?Q?xzcbhh24FFqivrZ0CCrI+12E+51qazoOJuR2mGzzoQ7KcUqkQ+rYldO9VagZ?=
 =?us-ascii?Q?myJSGlEGZmqo1Jx60pZKPkCxRD76JOM+mJT4Qa5N+hoP2r3ADAyGF+gEd9oD?=
 =?us-ascii?Q?InouUmcP1BjCRkeJeGKEmRjwvjxgo3YEGmSjHqdQ0+w86eMGSrhl7igx8QMp?=
 =?us-ascii?Q?OnK6OwZY13nJ6+6C6b+6d9IWgnjUyguXPdogbLQ4QT6zsu1IE7RIHG+hd9Vc?=
 =?us-ascii?Q?Pn5EbOZrf9VvOGRL1BmzH+0jfjd/7nGMXeSEo1wYvYFlKBa90xMoF3TQ7NU4?=
 =?us-ascii?Q?DwQCTrFhbgORE7horfwgDwyuQw/3XI11+DdmobYFzooiQgliLdklTvhMRwvi?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y7vWNDNFwjUrAOQbluz+x7kpesfYxceEKssVnXsdCmQ8iwDBANnwMBAuXMn0jWBR/LIjolmjzgd+Hiok5JTtZHS5vRHJWxDNVTLV3K/w5Tq1v2zmuIkhIQQs3D3ikSIt5+sJhqkgaIWA4feWMxR/9Zw9Y6iKoljBwu0W48FLZY2ykzkeNU53vaRbsMAkO9o4lwgJMUTnSQceH/ksEcVeMHYZ7PdPoElJOa5p9YBNrW044B7bf7V7v5WJkeIS/mo1LnTEo2fFbIwsUMeC52T0Ziv9wqX4T0L3x9vaSjSsvskduQVqpDuhTxEuNgKGEMGIMAZTlAzON9Li936Pf4svwZ1xBmb7lx1i2eQ3YL0CHhTjsza2kGyWadrfkYfBw/Yb1qaRkUXBB0i++PiDLKglLT8xHQu5i/UKSEOpwkhpSyOz5xejxW1100hOcbeO+cW6lrb9s+Ur0C1y9IA9Wi7Uoc2AKYOCQOdC9vCMWsOdNDVOJP+VBAFoMTRyGGm5Vhz0b/rrhPQyGeWMunUy4KVwU0a2BI7tCnjCjXq6Ri4W9t14zSAWvEeZpE5r5L1iDPQO3AHPLuVMlZlYLXG1UgF9qnACXvG3/eYzse8epzN9GYs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5c1fbe5-ec5d-46b7-44ca-08dd42a6dd9d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2025 09:57:40.7962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WAbIsdh/W2J6kGest7Kg13RHC35OI1hKfSj6qPuIBqnvKi4LaEiq+aONCpzKtXon3ceJQSiPr9BBPGv2Lw6uDYDGoGzkRUwJBUDq1HNrOhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4418
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-01_04,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502010085
X-Proofpoint-GUID: JR-YDj-r3Vbo3pX-j4qHyBG6ecqMeVBq
X-Proofpoint-ORIG-GUID: JR-YDj-r3Vbo3pX-j4qHyBG6ecqMeVBq

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
index 561b2c38c0..a047fd680e 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2223,7 +2223,6 @@ void qemu_ram_remap(ram_addr_t addr)
 {
     RAMBlock *block;
     uint64_t offset;
-    void *vaddr;
     size_t page_size;
 
     RAMBLOCK_FOREACH(block) {
@@ -2233,7 +2232,6 @@ void qemu_ram_remap(ram_addr_t addr)
             page_size = qemu_ram_pagesize(block);
             offset = QEMU_ALIGN_DOWN(offset, page_size);
 
-            vaddr = ramblock_ptr(block, offset);
             if (block->flags & RAM_PREALLOC) {
                 ;
             } else if (xen_enabled()) {
@@ -2257,8 +2255,6 @@ void qemu_ram_remap(ram_addr_t addr)
                         exit(1);
                     }
                 }
-                memory_try_enable_merging(vaddr, page_size);
-                qemu_ram_setup_dump(vaddr, page_size);
                 ram_block_notify_remap(block->host, offset, page_size);
             }
 
-- 
2.43.5



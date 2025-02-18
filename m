Return-Path: <kvm+bounces-38489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1FAA3AB07
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:35:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D290B173140
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70EC71DC98C;
	Tue, 18 Feb 2025 21:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iEGrqemk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bfLKPlcL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45461C07E6;
	Tue, 18 Feb 2025 21:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739914462; cv=fail; b=nQsItCZ2DJ18elD+QozOPEaRBVsgEVmsG4p9sDAI/ge6vyr0feiCBgjgPscYJ3fg6FMyKnMgIeuiYScOSt1jHArnQXKl7z+C9+oTlzASfaUcCh9kDc6tKvGusCPJXyzOJd4GcRObl1XmNFR935ZoBGGcmjZb4DlHlZ/sf7GqbSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739914462; c=relaxed/simple;
	bh=fIkKve3d4s+tARoLQIvmf1GpLWbBKq2gD7ZxonS0CvU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JouaDIpu/f0/iobBhrYlkokdsYgkKiFkC3ALDv0sPYuT5VE6YY5+DiqEy/Ej/h/D3BB5rJokLjL4/fJ2nsElVs2SxYO6mGU5klc7S6YMGNuiJd7WyEepKcZh4hXQp4ow+LSeVIp0zrcXzwo/CthEFBvWfL0laycTzVhIc3Roh+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iEGrqemk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bfLKPlcL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51ILMYEE022641;
	Tue, 18 Feb 2025 21:33:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=OsL8KmZV0GZqBzyYAkuNNp3MGpfw0D7lahQORSbuV9E=; b=
	iEGrqemkUVdarRHYoM2MZ22q01ibUaiZ4aQOS9EPUcDE6XiNr6yF2VZPunLCGWSE
	02A3MkaHD0BazbDlIVxH3jzIin1kFrTQSQ2itwnWJkxbjsQf2Q1FHt7E4Vg5mS+E
	sszZTnxk5gClHoGVuFr8cThbVQA/6YV/2JGhasa4my9TZAcc0TFHA3keM2136F+u
	DTJhkvW/0YEuvoF5Rtn263BbnZJV6JBbUkfd1rU6xWLVhFLlnjjvOiteGn/YtbCq
	Ga7Qf4+fEhNfuru9Nhd33LEdSBf3KhDWtE/Aq2tyTRjQ0+IxsXmqAadK5LeS1Crm
	ozHUPUY1mWE/FXwyoEHTHg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00kga9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51IL61OC009698;
	Tue, 18 Feb 2025 21:33:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w09bmx5c-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a6EqbcHLdEXKZuP31X6Trny7U+kEpFB8WDBtqXXrkNAnUVUw5/6RStVFVN3SCoD2bWMBzdMulOxiWWXoezESI0b5dvQXVXOgy4AgC7x4uzJaDgoVEe2gQd4HcegrcLRp9Cv7mpmsuNQT2cn17Nknh2gTDvkDN4xxnbdryQu4PS/ik5510g29ykcs1CHq8VbGRJtDeTwxrP6+EP18P/TWXq/HMtyR/QoP1nDudEal4jBsei4lFDRoa/nrYeLWqjz/InRIZor/wv9K9r57TftZWUuR6R29BX6+Cx+U4CRAR2W4eCOFrFAW3NpqXp91pr+RNUIKcUvmHK7avj65R9RhLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OsL8KmZV0GZqBzyYAkuNNp3MGpfw0D7lahQORSbuV9E=;
 b=oyDBraUBodJmKmkk+Dq9WwOaUjtggz5Qf6ejWLZU3gUqOhDn5DsgtY9R4KnVBGVybRNEYt1Q5Hvsj/9+VnrAFoc22S0E3hswu2H/3L/NUG4cXbaufN+JYAOpSvWsIzvO26V84oRK1Wk9PJKeuy5tp0VBgLovKpBQa+ESVCxYHVLmGxdy27GdV4IhiIgi5J+mvwEUkfnXcjaWveUvrgEhe/bUjhiqjpnDohaC6XYUMEAWv79110+h8nQSBkYB4yNFCR2dGq2ezhSt5iHCquLvOlWUT/xffZgRj/6RnHzODgHK3uLH42DrEoJZf4F/o+1qsVSnhICmIYULSsB/dFce1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsL8KmZV0GZqBzyYAkuNNp3MGpfw0D7lahQORSbuV9E=;
 b=bfLKPlcLN99IxCYC5ds/YUkGmNjhDTVkez5rUa3dw90VMgyoiCCsoxlo21tgY89u3Z2BmlKtI5IWVlfvfiPaXmkLLVZsy0SLCdwAntmnB6DxvZpH21i62m1wrubB/kTR5FEMNL6fm/FhZPVpBF968xOjGeJ8HMQ6R37bOH7SN6A=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA0PR10MB7275.namprd10.prod.outlook.com (2603:10b6:208:3de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Tue, 18 Feb
 2025 21:33:52 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%2]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 21:33:52 +0000
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
Subject: [PATCH v10 07/11] cpuidle-haltpoll: define arch_haltpoll_want()
Date: Tue, 18 Feb 2025 13:33:33 -0800
Message-Id: <20250218213337.377987-8-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250218213337.377987-1-ankur.a.arora@oracle.com>
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:303:b4::16) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA0PR10MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: 15a64b5c-d146-4b13-75ce-08dd5063f0ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G23tPhVFjTsG+KOSPGHgEfbcV2gIrw1f3KWZlvwqA8nS5B98UUgTfGBGUpTZ?=
 =?us-ascii?Q?cuVr7ZJIMk1AJZ0VesaMj0WbizJVP3e23MI0HWxXwEIno9r9Os/5UiofKsBU?=
 =?us-ascii?Q?T63rtDrB1DueOFRC+omiiZyExZns//OVSpHdgSP2eV5cCzrZ4sbGlXDo7/rC?=
 =?us-ascii?Q?VmKroxcuV8Oy3gFhi050yKVF65SIS6BXQ9A1GBugFGtR7nV0bCMCRs1wReYv?=
 =?us-ascii?Q?0/9GcK0K6WM7b/1DYlB0HjTWalPXwIBPjVzwUa3y5L8FV7nIuLfxJ0DfJvfU?=
 =?us-ascii?Q?lgvpYlPAEmAjARq8JHPYKm0WGs/bkrYThfhdVolFw0C55hVzeNeZS+UCwrND?=
 =?us-ascii?Q?oPbVZ+J81ST0aB8RvvqHAioMYJGyS6QVnLaoCYNH6P1qCDu2BqKcbpgUCTD7?=
 =?us-ascii?Q?waX5o5zErZ1VSXyjXTew6kHcCJrJNdWyyHENVi2R82FdGgo/dx3CoI5sqY/1?=
 =?us-ascii?Q?QXNuHw+gOq7Xz3P/0ZfIiv0CIwoUmxkuGWs5QYRR+2c4bCATGn6Z23gtQ5nd?=
 =?us-ascii?Q?oDv6/dUUJVfhqmxHJ15YFKtP5/d7qQcQ2VSaobsa+hA0X6JUBDvjYfIxHX9D?=
 =?us-ascii?Q?A6HW51PgGn8Zvkosc4ODXBh/oa8e5pt0ZVwOXe7ZPH0AVcHDmPcr2gJPPHqk?=
 =?us-ascii?Q?J6XALGWSvuwZx9VauPhNtXmIGFzz5eJUkJgp/K9/oi8RX0Bs8SsvXRu/fs+L?=
 =?us-ascii?Q?omYCfVWvWfIA71h7GGQO5AKjNQBXf7rFgrmYr4U+XCD8TIKtlHkEaZjHHtEG?=
 =?us-ascii?Q?kdAnYCO6M5LT/4akCK5PuF4fmwRqQePrXJ9lQudWiT5Tf2GI4s/rccVf/AzF?=
 =?us-ascii?Q?YM/6fQPcxnlaIV/6+N/tseBXFdOOzlRyWjTOn7pbAXwyDCMCTtrWq/a3rxJu?=
 =?us-ascii?Q?fLiqcfKCgZj+FXJZw/CViCD4+TKoGmItVOdhxC7EJlDI3uB9faQeTBtOnmIX?=
 =?us-ascii?Q?otfTeCHaq+2k9uD7dDigSRbx3CkhBqV6DJoLZsWews5j75NrO/5Y5GuVudWp?=
 =?us-ascii?Q?2XjMpXP4MSru3yKOdhp/KnHpLHdzhgQIErOghLsRF8i+/h4qtL/rkj2qqOkd?=
 =?us-ascii?Q?+FFGa9CH9wiBFzNGZaKuXgd2wa5YVHDCQm0m6jY9L29f4QwbonlqiDqgcHLl?=
 =?us-ascii?Q?o4Ir92i5wSknHDHVPXQJL2wYfsZJ9pFQBI/PNv96T6nmgv1GcSKBam+bPh+n?=
 =?us-ascii?Q?IRcP13vP9q8eNYmHZGvfMrh97rQwgbQ+8jC+Q/hSmvMzOFuJVwGt3v4RabwH?=
 =?us-ascii?Q?xSWpuXCocvBoiVn86GIwQCqsA9kjzn4rdVxEIfRKzRbX5Uk35tNgh4vOZBi6?=
 =?us-ascii?Q?betwPXyD530UFTfqk1xt5l+aqtLxnm8pHj8qd/3NPvf7vq/8/z2H+SdHZHvv?=
 =?us-ascii?Q?HQsRA36DVX0rX+WDbgaLLds0qHX1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WMgxOyRtmIFOT1uWUZ32S4Jy/exCc1jCDR8ObcJ7FHoSIDpMXx3YBYMTWZrN?=
 =?us-ascii?Q?WgPOACvwfrDirtCHUGsbCQwPPASX4psWt3dZsolZV4allOddEC+ddS9SaKX+?=
 =?us-ascii?Q?vVpZbsNZjn3+hqNrGAH9vDLE0ePrVNZ3kDrGTPeBHFqaxAp+t9jnEZRIJ6LH?=
 =?us-ascii?Q?Qn7tX1b/Kc5YIFd/qbOMtgf0rrSBq7VNBPo0dLyleIjYuf8HvPtqyETH/S9n?=
 =?us-ascii?Q?Qg4lYPtjTtpqx18BpXoa0JgnYvoWqLGhgjZCcW40X2qMW2gVy3UyGLPRNx0q?=
 =?us-ascii?Q?P51Yp1sVSFFVcGeouBiMvIymsqMSslhuKfv1RPrnj68qMFDtkuRy/3cKzbxE?=
 =?us-ascii?Q?VdTznESjBfHkvxs/h9QZe+F1KpIhUSM5oRA/kipKZ3CXBOoTnUU1Qu1L9ets?=
 =?us-ascii?Q?7jopQo4BPSyYtUouT/Cwjhxu8ZclVr/LhBhVfcICcP4gP7J67zbznThjDzu7?=
 =?us-ascii?Q?Zqc+RgvFvivmkbO1zw5GQhgesztpWBe/52B13eZT5rlpoAtAcdkEzeK4gWB9?=
 =?us-ascii?Q?ew7ifkdi7//TwlTZnswEtfcQXnLSMTplbvrs6Ff5dMsOIIxwtgforowGGKlp?=
 =?us-ascii?Q?mZEGJ1KtZAYW7nepfiQIa2A2Kp6VAWDu6+mT6ed4Idh5Ev6iWOX7OjAwyY+a?=
 =?us-ascii?Q?bdCiCvrTrnjmAw+Z0j+vJt4nWX0haEpnX8DFi5GtU6o8ftuF5YeR5PR3zFIQ?=
 =?us-ascii?Q?ZbGtxu9HAyLTV3jg7pN+cEb/yjgcPTuyqCM/ap6rt0Mygke8GsrCND2eg0JD?=
 =?us-ascii?Q?Ctvusxs1WPfiFmk7pt0/oMIBYGMlv/VLG35YcZCHBcvijfhie4mrWmYzBgkf?=
 =?us-ascii?Q?nLI0v4fuLSM5Uh6U2nz3rBhgt+E5VgeQFQbTOawtEbz7Uh7LwfGGrnaxUoU4?=
 =?us-ascii?Q?sGjHnEXfL+JdMAennEWYObDLgcud2fSKo1x40agmAhistKyf49XMdNlhu4ga?=
 =?us-ascii?Q?S0oBULl0s3t7LINFkASbg+wIdymCCNu3wimAhADHszl07tWKXk1h+cRx9RjB?=
 =?us-ascii?Q?qLMzXHv/whqUqFM5PRRJiUHkgBYJ5aGfPt08GA7m4O3NM7q8hLEAWaDf8x1y?=
 =?us-ascii?Q?8w/hCVs1xupe5vDVnHrNUsSjS78wDqp85Gv0HAvPBubKvoIyOKZ+Fc0YcTuj?=
 =?us-ascii?Q?WEbE1UcCoKnzfwgjGMBSLgHv7tXJR10yL7LxTRWS0kSGcsUhL6BYMYVrHPLc?=
 =?us-ascii?Q?wKDtwqQVPOEl0tLQ9vfFHNdq+lFRFvBzTpCzNzebX6hSHWyiNqg9q/Tf7KhD?=
 =?us-ascii?Q?hj+y/J+zlPe1rhcacHHCZ5dKQoqfhcntmA0ZSMklH75RsA3e35xt4eGwFa/u?=
 =?us-ascii?Q?qbT1xIEBBQFA5RBUdKXq2WmcZjySvVTMTlx09yvHB860ALPKV0lOJZx+Z5hP?=
 =?us-ascii?Q?FD6LYDyFcDIsXaPEuwiGFLuKjsB7cybRs672VCuk7w8NXhH+AmHZXGdVo7IT?=
 =?us-ascii?Q?RfvOZcHHvW0Ksm95aVJ6Vq57i1GMa3S/AfSHxi5puCxMdpF6TQFf786lAkXf?=
 =?us-ascii?Q?PzancU+kCbvXVh/CW8lCc/DdB35fCgypEH31pZLCSA5G2yUXhA+HGhO5Jts5?=
 =?us-ascii?Q?g3ysFem7foOXKWDNyVqy9j5ZYvFb4GUlb6oBpu5Xe+T3PNBmaCjDqBHKWEXN?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZYYpvUOFN4YFetbg3KhODZ/g6BWaBq4e2AU/cXX4Nh8LXa1MmUKsRYJRh7uLjm8QVa/Xn3APixgbEslXNUGJj7q8VNzJyVr0CGX5g3xmCCY1PidLl7HxELy9BLKcFyzDPAStpLQp96Nkn8+MvcnoPlp/9iGp89QryZpkZf4CGoJI3WKMC4qtXZUCWMKnT4BppCGzJLJAT/+M4WZeLk3s0qIEId7KX8YLcj6yz+NI/BpTWHaP21buPXjA7qVUtK/luIrIGpTUfKIWyDvC/90WvzUtHXQljSW/djWnsCHluIFaLe9W9+Vc0Rg16smVye35nxXrJ2wu6LcwMgjHwR5zSIWfT0QHJHih3RFX6UlGlJ9zFQuGQxvt/g6G7Cdqu1CmOQiHXUgJmMRpyG9zlDvnowDlJL9lvbTbXW/GT5zwvser7TB7xrUWVWdUPno7RwesJpoo2LrSgD5+8R+e+R0mDDrWbgYOTtW6cXBKr4/owBhG9c9JFP0SxnhtsS/e4F0GK4lKBM/bfhGXnOTKGmA3EfsM6BjKDuGOnXPTWhTqyftoeGEBt01jlv5h+m40TemdrVWKNrZyfa/tmkg6ELTOVkiaXMTHT1X/YleR53cihD4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15a64b5c-d146-4b13-75ce-08dd5063f0ba
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 21:33:52.8215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vPih/2dGK3dLp5ZJY1PUPWz6+nOy1okTuiHzUN9CN6NIgbEqDF0IdHKbjla4dHvxfMkbAeCjAGVE4u7yVek98iQ7kMCRkwBxn229Id7SZfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_10,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502180144
X-Proofpoint-ORIG-GUID: ANOe7GbC_vnNwGi0Yc1_kaXTUJ-rq9oG
X-Proofpoint-GUID: ANOe7GbC_vnNwGi0Yc1_kaXTUJ-rq9oG

From: Joao Martins <joao.m.martins@oracle.com>

While initializing haltpoll we check if KVM supports the
realtime hint and if idle is overridden at boot.

Both of these checks are x86 specific. So, in pursuit of
making cpuidle-haltpoll architecture independent, move these
checks out of common code.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/cpuidle_haltpoll.h |  1 +
 arch/x86/kernel/kvm.c                   | 13 +++++++++++++
 drivers/cpuidle/cpuidle-haltpoll.c      | 12 +-----------
 include/linux/cpuidle_haltpoll.h        |  5 +++++
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/cpuidle_haltpoll.h b/arch/x86/include/asm/cpuidle_haltpoll.h
index c8b39c6716ff..8a0a12769c2e 100644
--- a/arch/x86/include/asm/cpuidle_haltpoll.h
+++ b/arch/x86/include/asm/cpuidle_haltpoll.h
@@ -4,5 +4,6 @@
 
 void arch_haltpoll_enable(unsigned int cpu);
 void arch_haltpoll_disable(unsigned int cpu);
+bool arch_haltpoll_want(bool force);
 
 #endif
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 21e9e4845354..6d717819eb4e 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1155,4 +1155,17 @@ void arch_haltpoll_disable(unsigned int cpu)
 	smp_call_function_single(cpu, kvm_enable_host_haltpoll, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
+
+bool arch_haltpoll_want(bool force)
+{
+	/* Do not load haltpoll if idle= is passed */
+	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
+		return false;
+
+	if (!kvm_para_available())
+		return false;
+
+	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
+}
+EXPORT_SYMBOL_GPL(arch_haltpoll_want);
 #endif
diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index bcd03e893a0a..e532aa2bf608 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -15,7 +15,6 @@
 #include <linux/cpuidle.h>
 #include <linux/module.h>
 #include <linux/sched/idle.h>
-#include <linux/kvm_para.h>
 #include <linux/cpuidle_haltpoll.h>
 
 static bool force __read_mostly;
@@ -93,21 +92,12 @@ static void haltpoll_uninit(void)
 	haltpoll_cpuidle_devices = NULL;
 }
 
-static bool haltpoll_want(void)
-{
-	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
-}
-
 static int __init haltpoll_init(void)
 {
 	int ret;
 	struct cpuidle_driver *drv = &haltpoll_driver;
 
-	/* Do not load haltpoll if idle= is passed */
-	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
-		return -ENODEV;
-
-	if (!kvm_para_available() || !haltpoll_want())
+	if (!arch_haltpoll_want(force))
 		return -ENODEV;
 
 	cpuidle_poll_state_init(drv);
diff --git a/include/linux/cpuidle_haltpoll.h b/include/linux/cpuidle_haltpoll.h
index d50c1e0411a2..68eb7a757120 100644
--- a/include/linux/cpuidle_haltpoll.h
+++ b/include/linux/cpuidle_haltpoll.h
@@ -12,5 +12,10 @@ static inline void arch_haltpoll_enable(unsigned int cpu)
 static inline void arch_haltpoll_disable(unsigned int cpu)
 {
 }
+
+static inline bool arch_haltpoll_want(bool force)
+{
+	return false;
+}
 #endif
 #endif
-- 
2.43.5



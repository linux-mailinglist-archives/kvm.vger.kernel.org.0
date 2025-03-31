Return-Path: <kvm+bounces-42263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 585E5A76F3B
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 22:28:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 809AD188CDAF
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 20:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F5021B9C1;
	Mon, 31 Mar 2025 20:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZfefKujy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cLHJkdlK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150A821ABDE;
	Mon, 31 Mar 2025 20:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743452908; cv=fail; b=ZzuyX1LER4EQPURsHmpE7WNLxQt+CSviRBu5Nm76GCdEBUMWEVqsBwtS4iY0JXQ8CPGqyxflJiKWZJ+yTx+lQwwd7XzOZufVtFLbqyRxc27bpaVgmr11pQVRKbC8IRKHKciQktME6E265EvMefmIwXDu6cqNET0f574c/rlRSoM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743452908; c=relaxed/simple;
	bh=fL9mGpwYfqB1Vf4mcExLVa0vGIU0gCuy/FyQ3b9ezGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XFaHO03ZVV/GnEhk8JbE8u+5FWIk1C4TW2U/tYDH79C3oSBuoVpiM5BXihtBeUC5Cl0fxRSWVjzg9yUK5l836PnH9Ygoe5h0Tug7HiZLjA6L6ctWXefpdrgwsfaYh1tADWNmzpg/ZN6T5Z2WmmOmrCP2cY5H6D81SewtVYq/yL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZfefKujy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cLHJkdlK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52VJu6o1023227;
	Mon, 31 Mar 2025 20:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=5sn6bag12Cw1E//cxi
	ON3BmHAB2v8EoY3MLyEvL2SsQ=; b=ZfefKujykjhzqXKWMyPR2J/gf+fjpD80dH
	N2odIEMoeSUgMpy65Tp0+WF5Z+QLky6s7oS9tvGN5mLxZgNok2MF2JYgn4R9hix2
	b3D7uENRNQ7zdPVe5OVsgB/Oc9wlPVtIud+flcKoEUp0AG8y3JXsATD4rvuBGi77
	90jFHdYKghfE5zDY6lfZb6lf2pwpFuzOimAshIkaY86QllwlD1AAoCRsuGf0Ecz3
	goW5R1yDDEQiTXCMVHTOVeb35PbVPtYDXzCpWzwJMTycszH78Iac4bjjybqUVost
	MqhzRuuVFdGRX+0xPmzIx1PUUp5F8FUxqRL1JddonlBElSFPreig==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p79c42w9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 20:27:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52VIcFcs004441;
	Mon, 31 Mar 2025 20:27:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45p7a8d4jb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 20:27:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cOVxdlq/jIh4RHzCawGdHC7fbCZh/ZUIwrEeHEcl4X7QlwaDIsReKt7H9o/n5DXe3T9iyojDkFkt6JveqpIdgx/u33igG2akqwDz7Pg+FVReSOs6pnwRTSbOSfpGa4U8BpNqj4LEZ0dUhEeMDPdJXrfIDz1DCUpRmWhn46K8MWSzCuaY2DepyjX17KOT+YU82BV7To4jQBtZXjPvniIvOKxpPkgkHtFOOjGZVZQ4I0vZ8mRXrhntHQbw6NjzByYJTjOJaUYDGb3Zas8J+7d2ZFk1xQ0hkRm7rYldDjeuko3OaZW+gTirh852MU1eKww9Ulj6p6AmRM/howioUSM79w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5sn6bag12Cw1E//cxiON3BmHAB2v8EoY3MLyEvL2SsQ=;
 b=t4lekzBL3wtjCeQXTzadaO1k4XhiS2RUUIwQAmrFFr+S8og6CdBBMSy2mOXI9gNrwdyLzbmrvcEpcBgB9tGjDZUsC3CpyvLEBJsu6hpsOUtLWg4iHfVBhzJbRbvGTdm0hBa2wLm+1nd9S5ng9d7218dp6KF3pBEjG7GvtduuqI3zNQt4XqOjjr1/2/xpE4T/5Shbdr9nK+5yb4KpMvCELCfN0Pu+pCvHO0HopO1Q8/SV+O0NLy0nAcJI+R6mF5ylJgkPHfzUBlb9XNB7JXT5YRPMwj6N5UZ/KhzuOe3NOWFtQDgtBRMB5ztVg0RRynZblmkx0ywCv15UrD299RoXTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sn6bag12Cw1E//cxiON3BmHAB2v8EoY3MLyEvL2SsQ=;
 b=cLHJkdlKlMAK2ZZt9PGM7P3TfgERfhHB/DM/OsDfrGJY4FUmwRqUCy6pc762c5HHXHdAtYWIW2i/+eZpHPsEvhx0qVy8aCpML6ZRNBi91h3XzPCr5z4sbPgmJOmqFL0s/X+/Yjdvm2urO9hhoAf917DQRkC74GiWjolKU7szDvI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5145.namprd10.prod.outlook.com (2603:10b6:610:db::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.38; Mon, 31 Mar
 2025 20:27:39 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.8583.038; Mon, 31 Mar 2025
 20:27:39 +0000
Date: Mon, 31 Mar 2025 16:27:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
        seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
Subject: Re: [RFC PATCH v1 10/15] KVM: VMX: Use WRMSRNS or its immediate form
 when available
Message-ID: <Z-r6qxmk7niRssee@char.us.oracle.com>
References: <20250331082251.3171276-1-xin@zytor.com>
 <20250331082251.3171276-11-xin@zytor.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331082251.3171276-11-xin@zytor.com>
X-ClientProxiedBy: MN2PR12CA0001.namprd12.prod.outlook.com
 (2603:10b6:208:a8::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5145:EE_
X-MS-Office365-Filtering-Correlation-Id: 61213043-560d-4ef0-0a87-08dd70927b8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RaA9lzLO6azzf804bthKuHkcCKAwJy2zqdAfTqLvK5hTBKFOrG0z8+gB1HXQ?=
 =?us-ascii?Q?0F0fvSZ2WonUWvrCCrjW7MP8Xz4rJ4dSMXkwioczFLlItS/D5UTkmRe8XzVe?=
 =?us-ascii?Q?P+BpZy+mcNVchfTo5ybScSShjNyY7iUzp974o6MBJPM5G6Ldm4Y1DN782rEn?=
 =?us-ascii?Q?Q7BmCohoqPiLB6E211+W4EBdruPm8hX4t1UXlpBGlGg/ZXr5gf1EtlrodKRq?=
 =?us-ascii?Q?Smndok/YtHGMHybtigVUPme/FSBcN7+EvhMzdi+bF1xxxygPOayThxkYFUcQ?=
 =?us-ascii?Q?gZvcSkb06sda3jtcYNk/gyIxhRXuGaKIoB7mLZw0vrnqLbp6wgw0tYJ3WeL5?=
 =?us-ascii?Q?nsS3QqxDk0yMbPNbHZ6/ERL494LWHBWMR8ngrn6SwDV1gcxzj5Fq4nWOeQ3c?=
 =?us-ascii?Q?857PrAfzBETZOwlpRoalDxmGEr9uIZwx4AFy2R1VqwN7A42hCe/vVj4TZ0uu?=
 =?us-ascii?Q?GfyCI1TyI/hAyyYO+qyQ0c1n8IaIDP1OMRGUzqCMYlSKfFE0eh6fbtFgZLS1?=
 =?us-ascii?Q?iKfK8jVoQqt5pu/qvXmMDGecms8nWBTwx483J2/aUCXde+u6IXX4VZDEW4++?=
 =?us-ascii?Q?/tstSglQOS9bP94XsGTI2sc3/fejqS6plt6B05vSB7HFuBUQPDBcWvzWKDgD?=
 =?us-ascii?Q?71tqWeqNudbjWpOfgXMJLMYBsApnZUUkXapx7ZTrdCCO94xSIVd5/HffSAnw?=
 =?us-ascii?Q?pWjYJgfmRqBqL+BcQO0SZE+YDLhXCZQUiXkFOOoBo3Fh//2fII0wspeUwQ32?=
 =?us-ascii?Q?bKlkdmbSSP/g1SGRFTnYjMFHGxq1j0nocSc5IAK4YL7U0HXD72St+RuD+mTT?=
 =?us-ascii?Q?qzZ5Srg670BJvTgDHGy6rnR5j/1E2nGD3twUA5JT1prWuJ2RamFgWsi1qIY1?=
 =?us-ascii?Q?cFYNM52A1DpwmraZVstYgYj5bIudTnoQtRPM3eRo6GPegTJJIfB7AY7HqK7x?=
 =?us-ascii?Q?H2SPjqdrxme7oQ9WShCAfhdgmmwjP88ivvHjWgD0kfK3ShUNBv+rHMQ2nK9e?=
 =?us-ascii?Q?8dxDMLc9pcH8W1kK3Fo8tq/68hoVObE6hpA1PyGSPTFKqrL9GxsdMz6ESnev?=
 =?us-ascii?Q?ngF85F5DpnxnVg/S4aM2u+kHVVkYXCG9Kt+7u0Eug0ZTrO+bEid1aI0bJ6C7?=
 =?us-ascii?Q?0AKhaMdvRLFZWBSfBZf0DbFB71kpe3G2BJT93W5PXwgaSthDURA+CFPbkN5K?=
 =?us-ascii?Q?1JTFNunaJTbE+RqkyCnKM9/3ET7/UWKRhbaApWDvVh5RjMA7JfIBfTFdkonV?=
 =?us-ascii?Q?NwejlJBG0Hi3IqGr6B5oAfPLtmhIjvEvZllw1TPxzcXGe0nB5HHAzJqGyHJN?=
 =?us-ascii?Q?xALL/tXymYAo+toJvir0OBOpUhxGFIf40n3eZZNkBsX7sc3f0OvlO3SQD3iW?=
 =?us-ascii?Q?hnsEtjCY1WpKmcOxMT1TF6xaSeY1McPuhAHhyTiHZgudWtaqK+COZKZoUjs5?=
 =?us-ascii?Q?G0/LFYyMvVA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PMTNP0qma3I/kEWRpmlNIb3otrA4UzL4fQhGqu+H/sCpzd6WRmbnKKTljLjP?=
 =?us-ascii?Q?L9Igx89jpptHxgx19Jklp0PJjZBObuLhIbIZAbXEZiMpkElf8qfiC8MyQB/7?=
 =?us-ascii?Q?o19Oq50//6mcHqUbfHdDQ2B5IWai+qohEYHXN2H5L0eSs5COQvyu3d+NiJO+?=
 =?us-ascii?Q?IN5alTR1aFKL9IY83f/gMT94veXVvG9n6CGyqjlYggw8wY4+SmsatIViwmfi?=
 =?us-ascii?Q?1gs8l/tX7wIjELi2JxIsP2OJtjdijrUhn1RvcMe/AkLZSZSNIpPeW2FGU8hF?=
 =?us-ascii?Q?42nV3pXqRr777Co7YfBFu1H2+jOBfCF7f9j9XqAno7Z0SpljNcSFDqyLcAnE?=
 =?us-ascii?Q?sZV4Q7ZrMlODPnltHhfNVYOI+FUxXAHfzeye2IzMHQbWnbdm+bSKRWP3zp5I?=
 =?us-ascii?Q?3FMkvtfcl4YELeyMlhAAW06oIiUJt8Y/itZR81a/+hNTL9qTuqle1KNBn08L?=
 =?us-ascii?Q?FNLt3veqDVo+tMX3dEkkBrWyqgQ7zVjoFTOxK0ZAbszzr89MTZW39fKLy27G?=
 =?us-ascii?Q?H7uEkyvugNtdx01nWskdB67vaGzFmoCtXcDNTGrQOunRwnKNhxYJ6x3Vhpll?=
 =?us-ascii?Q?SRr2rczsvLdfVUAz9dYz3Dbn4W1RLqgHyrv9520vAdrob/DOGxdk1ozr3pcW?=
 =?us-ascii?Q?OifN6j4cpzwUrH9Ss7L8sxDTX9brwgu3vUIY8hDOzpvsLiWjCIcD4s8tvEZ+?=
 =?us-ascii?Q?jgC9VIvmJAfghAonz5T+oR0CGlklewi4IdSjKUPRMxfSx+x9aINO28wczf0U?=
 =?us-ascii?Q?4cX0cCLOEWZ8ECF2AbZwIzID3ic0l9RI6GFrfm1drjCCZHkOkefL99HvG+dG?=
 =?us-ascii?Q?K09atRwLdtpb7dxWZ1LqTqOXzxenOXW090IaEsbu9PvTQxn35HGAsWfbOT/H?=
 =?us-ascii?Q?ywxPVsI160j+pc2P8fDMNCORij3cB+3fwhYK5mVcxsnkVL+K9C2s0Z3Xdbyf?=
 =?us-ascii?Q?iBEOjH1TZnRq+EOHeHVhXPgN9aiKbBarlmGUt8o5EnoDJUWOZ7hWj3dT3znQ?=
 =?us-ascii?Q?v8A15NX6ODLVXB0hF8RV49r37a5NNZm6s7UPdndKDzKdZIbVJXp1Gqq9wxla?=
 =?us-ascii?Q?+/ulvGvPhKp4WLzc7diQU1b1zzQQVE0xzaURMyr4dWIXzZ+pptNYQxnhTc/p?=
 =?us-ascii?Q?oxYn3kv3/PqP1mPpiWlvNMg0+rMS89g73zzNFgEfPpOKRo8MczPcvXkKbIh3?=
 =?us-ascii?Q?TlyG4yo1KOvzp68dq7Ppci8zMmC5/q5RjUxqFWgwxWJTvI8oQJZfRoXDCWks?=
 =?us-ascii?Q?bqwepocRjcHx3gFElECzrLk/B2/W3M90weBSvenPsGksXVMlGoGm2tTJ+OKE?=
 =?us-ascii?Q?CdF3z4cDU6LbYSRZugQE+JzpGmE1/3m2ObYRv0bWAoSY36r1P5BmxwV71Rq2?=
 =?us-ascii?Q?8h2T5vRxxT69VTbLg0cLI9BgYpFsYiV8dZfY7W1Q6dqL1LEypLjgIVLrJXom?=
 =?us-ascii?Q?gzZ3btbAmL3U4MrULEOn2tWScRibMxsuZRu/s/LX1/mWk6nsm/nku0dkLRBU?=
 =?us-ascii?Q?XgcjfYW6S4KpAUKORsT49kzrrjCesI7IqWi9LP4kVZO7Z4ePgQyMP2QTprVW?=
 =?us-ascii?Q?r2EIt4PEUV8/UFFyNkiM9O5YkMklT+qVuEp0iLq2aqduVzRv2RNmdsb5PPsh?=
 =?us-ascii?Q?yA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X8CuATdHrBem+fHACMn/kJ5qp1JE1ZIebgVyLGqViHPeHYhV5ynDz+Dj3NisA8JRo07Fr1DHz54ZQm3RGL3wXFvZUzaaK5q6+j9dKv5gp8Bw79Q5vDFSuF+dqs3UxiZEfWtWp+kxGcNhQBOkW1ufL07cDsU4TlYP4aeTGUuv2Hdji+pXA6csAU7U71uIRm0iT5oPVpkHkJUEft4/dXxYkk5BSRHyqFtFvto8SUErlF0XOTZawLR7+KIKcjxlIldvVk7p5hIltcne2nZN2W96wUUuWkMJngV7b0KfRHzhMiJ367PgpAiMwtKEofSFXu0vRUuRBeT/GtgZkQEMn/0csfX9izPvF68Eq2l5wlstLbOBjpiLDxo6ugKSJQJCxKCKiX/54VYJLS8Q4MRE7Fm/lNsc+lv9X0qdOajikB//OOEBv8YTqaGFCoKNSfD4abtokdK4T1nt9zxniweILMYRdMwI0i6nnRti/uwLkwF8/O0DbRnQNtQmFRFKuz7wrL/ZQIRzQQKC86PUYdfWmXruCDItvaL6D/2FdVS6a0NuX5miFnPUZcW7ccV36Y7SyRz82pYxqveUCxFEH4hgG5QYfA8n1mHSKW2k+AGEhlOVfy8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61213043-560d-4ef0-0a87-08dd70927b8b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 20:27:39.8286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g0zSyetjWCpIdjI4j51R8bwgwYAnDxcxN/kEI9yZplT+pD4SpjcuFL6Q4sMULEYZImHUbzPXd3NvJNcsdF8ZSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5145
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-31_09,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxlogscore=962 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503310141
X-Proofpoint-GUID: 9H-SV8xEyUY09MXoR_h3HzqO541RBlC8
X-Proofpoint-ORIG-GUID: 9H-SV8xEyUY09MXoR_h3HzqO541RBlC8

On Mon, Mar 31, 2025 at 01:22:46AM -0700, Xin Li (Intel) wrote:
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> ---
>  arch/x86/include/asm/msr-index.h |  6 ++++++
>  arch/x86/kvm/vmx/vmenter.S       | 28 ++++++++++++++++++++++++----
>  2 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index e6134ef2263d..04244c3ba374 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1226,4 +1226,10 @@
>  						* a #GP
>  						*/
>  
> +/* Instruction opcode for WRMSRNS supported in binutils >= 2.40 */
> +#define ASM_WRMSRNS		_ASM_BYTES(0x0f,0x01,0xc6)
> +
> +/* Instruction opcode for the immediate form RDMSR/WRMSRNS */
> +#define ASM_WRMSRNS_RAX		_ASM_BYTES(0xc4,0xe7,0x7a,0xf6,0xc0)
> +
>  #endif /* _ASM_X86_MSR_INDEX_H */
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index f6986dee6f8c..9fae43723c44 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -64,6 +64,29 @@
>  	RET
>  .endm
>  
> +/*
> + * Write EAX to MSR_IA32_SPEC_CTRL.
> + *
> + * Choose the best WRMSR instruction based on availability.
> + *
> + * Replace with 'wrmsrns' and 'wrmsrns %rax, $MSR_IA32_SPEC_CTRL' once binutils support them.
> + */
> +.macro WRITE_EAX_TO_MSR_IA32_SPEC_CTRL
> +	ALTERNATIVE_2 __stringify(mov $MSR_IA32_SPEC_CTRL, %ecx;		\
> +				  xor %edx, %edx;				\
> +				  mov %edi, %eax;				\
> +				  ds wrmsr),					\
> +		      __stringify(mov $MSR_IA32_SPEC_CTRL, %ecx;		\
> +				  xor %edx, %edx;				\
> +				  mov %edi, %eax;				\
> +				  ASM_WRMSRNS),					\
> +		      X86_FEATURE_WRMSRNS,					\
> +		      __stringify(xor %_ASM_AX, %_ASM_AX;			\
> +				  mov %edi, %eax;				\
> +				  ASM_WRMSRNS_RAX; .long MSR_IA32_SPEC_CTRL),	\
> +		      X86_FEATURE_MSR_IMM
> +.endm
> +
>  .section .noinstr.text, "ax"
>  
>  /**
> @@ -123,10 +146,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	movl PER_CPU_VAR(x86_spec_ctrl_current), %esi
>  	cmp %edi, %esi
>  	je .Lspec_ctrl_done
> -	mov $MSR_IA32_SPEC_CTRL, %ecx
> -	xor %edx, %edx
> -	mov %edi, %eax
> -	wrmsr

Is that the right path forward?

That is replace the MSR write to disable speculative execution with a
non-serialized WRMSR? Doesn't that mean the WRMSRNS is speculative?


> +	WRITE_EAX_TO_MSR_IA32_SPEC_CTRL
>  
>  .Lspec_ctrl_done:
>  
> -- 
> 2.49.0
> 
> 


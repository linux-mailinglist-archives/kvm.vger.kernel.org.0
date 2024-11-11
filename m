Return-Path: <kvm+bounces-31493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B249C41DC
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:32:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6C9A2852D3
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 15:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 760E719F12D;
	Mon, 11 Nov 2024 15:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XlgZe971";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rENhujHs"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3011A256F
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 15:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731339070; cv=fail; b=VNVlOdnjhHx4yByCcNVEpTRqLVIyu9Cc0QzUrMb1gnufT/k6cWkN/84Y7AbwLIAKPxFFxtZG/m255cM3WK7+jKIgLBSzXq5274xU2b40kaJTl3ejZHiRYAXi60nrm/yN99DqDZnrOMDHZSi/1rz0jRvnAyCsT97cmjhDIlXAONM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731339070; c=relaxed/simple;
	bh=SY7m3tU5979/+OGnrtLsOidg1ORlmP0U54JrPummpzs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VjtsyVEzdGATKGbypkek3UOJ1gsKFx35kPM5Ejf3eYdz4c5K0pmpoZ0w4mXK268Yf1U0al+GDvhFPJpPQL40xHv3GKx8sKdXGGXV5DOvAiOpPaZg8q5w+f2pR9Agx0R6u+9U8Hfn4ps6yJ655Cmztb7KSMoOLjcd+VqPtzx3Ng0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XlgZe971; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rENhujHs; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB9slbL002316;
	Mon, 11 Nov 2024 15:31:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=atgM8u7Ydeim33XHpfzpSDE1YNnmf1p+aqlmbaxKXkQ=; b=
	XlgZe971Bir9oNIKrPYlvpR1yWtwI8y1nIJEutGXxQkxP7ApNDNOYwWUXp70ZkfA
	tAFJ8zJ1R0cKtqNE3qU0EsGniUmEERn0gRvVZaw55fa0zVKiMInlCDGFNAMYrTxT
	Ejng/CzVduXxs7uBzOQjehtPMjTA2cUDyVFShZ9t9oaUQ4u3hp7USziiGzlcrVrS
	d8Wg/Wmffi+dFv2NjYrgtEoa/jkE5PxIZM1HFfMJlRWHXmH1YOBUFIhCD8xV8aK1
	sqP2FoPpVXPGVGwjGeiPA1IFQ0NKKSUHlSPyPjC3i5RgiTb1G08ERVH1STxQQ26Z
	4HICsjOgKuOOuMx8bFlLEA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0hejnc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 15:30:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ABFPsHW023620;
	Mon, 11 Nov 2024 15:30:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx66wbuf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 15:30:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j7h4z4wSWwuPo1B00LhXuIn66Ic8E/3F/3XMwx/nIhv3XnKxca/0sBObi/v1BULxgSokJx/u5JxTkJh9VkA4fT+VLt/5fXjMcYCuaU1Z3jhrlbxu1M56NGGMtMCuYkQg3PNnt/cwXP6r2VAtz095wna9OQn7Q/h10iczytE3aJXHrJhpFQ4K5flqxYYoORwadp92u4MG8Pm4+LAqiVtol3JBv5MZETmSI1zXPFXT4XXba+bXx5hn9EYvhA4P61ekZ9yaQlLvTTpzN5XzH/wo3rBIA7Ljd8ngFn3Jis8uvucDw2DTGaxUYI6HHoj7yt9iGjKZ8OXwq3yCJTnOrPa5Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atgM8u7Ydeim33XHpfzpSDE1YNnmf1p+aqlmbaxKXkQ=;
 b=ioE1yQetjfuL88iaWmpI2GHW8EqHT8MJNbXDhauK50wkpMHNxrt4CXka9edASQQUgGkWhVAQeC+C9+johqekGoa7t/Sd8x4osdUzKStzdy5+9K1rPqeyke2zg1pH6IatlaNqo7dhZcJqSpmNrG25ob8j7+R/UEwZoSK/rNn/oXcRn4tsVMUqTu/KozahekxLMfNo/7VFIh14pRIACcxp02foRSQS/TmHTCU5/ssaKWduUk5mbTKPom2OF6R8E3FUVHIdY9uM57G4m8fzaa6zNMUzTsffU1B8OHV/GI4o+zzLGJ5Hl4CVb1p0qq4Aoc7BXVq0QQW89zgUu5hMr4wPMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atgM8u7Ydeim33XHpfzpSDE1YNnmf1p+aqlmbaxKXkQ=;
 b=rENhujHsp0RO0LiEDjlzXyhzQfrUZhIH2eZ0ajd+iw6yug3pMKV5wyh5jjG/9rJtxBAi93udgd/s/HMnSh8G/ioQiQwuiaqKgYe42BJZyZlmCeCh67QIo4rkNjKZdAH1UbY2MWHU7HaN6n7AFpHGsg5FJ2nV27NoCw29ZbAvock=
Received: from PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11)
 by PH8PR10MB6360.namprd10.prod.outlook.com (2603:10b6:510:1bf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 15:30:55 +0000
Received: from PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53]) by PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53%6]) with mapi id 15.20.8137.019; Mon, 11 Nov 2024
 15:30:55 +0000
Message-ID: <112ebe08-06f3-4cb5-8cf0-8b49c56eac89@oracle.com>
Date: Mon, 11 Nov 2024 15:30:47 +0000
Subject: Re: [PATCH V1 vfio 7/7] vfio/virtio: Enable live migration once
 VIRTIO_PCI was configured
To: Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, mst@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, kevin.tian@intel.com,
        leonro@nvidia.com, maorg@nvidia.com
References: <20241104102131.184193-1-yishaih@nvidia.com>
 <20241104102131.184193-8-yishaih@nvidia.com>
 <20241105162904.34b2114d.alex.williamson@redhat.com>
 <20241106135909.GO458827@nvidia.com>
 <20241106152732.16ac48d3.alex.williamson@redhat.com>
 <af8886fd-ec75-45fa-b627-2cd3c2ce905c@nvidia.com>
 <20241107142554.1c38f347.alex.williamson@redhat.com>
 <4ea48b12-03d0-40df-8c9c-96a78343f8c6@nvidia.com>
 <d2b83eef-4f39-4583-86d8-fc5bf83dd47a@oracle.com>
 <ba487f4f-b8d9-4e42-9aef-300a8ed3648a@nvidia.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ba487f4f-b8d9-4e42-9aef-300a8ed3648a@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0022.eurprd03.prod.outlook.com
 (2603:10a6:208:14::35) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:EE_|PH8PR10MB6360:EE_
X-MS-Office365-Filtering-Correlation-Id: d483058f-2b33-4194-bb00-08dd0265d53d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R3Q2SUpWYTVXSmx0eTYzc0VXbVZtYWQyLytEUGxtcnk2OW4rdXErc2l1RVIv?=
 =?utf-8?B?OEhUbG95NDNhVkVZN1VLOFlRVng5S1ZDazNWUnZXbThUZCtWR1dsdlhuSmt1?=
 =?utf-8?B?WUxuTmszeVB6VjVkUVRtYmVEMFBQcmdmTk9GOFNwY1JGdEhYa0pzamRQeWRC?=
 =?utf-8?B?NXY3YmR0aXQ4NWpkWDkxc3FNUm9TZk5Ta0ZwVGxUcXFpV1B2T2taazZ3S2E4?=
 =?utf-8?B?QXQwcTEwQTVIWVJaRUozZ2pSZzFzd3cwMXhhODRoeWhvSWVpckNic1hoQkRZ?=
 =?utf-8?B?dFpxREwyL2ZSN3kxRkFpeEJPYTF3K3JNdWFaSVlTUDNEekpSNkozQUJvWkhO?=
 =?utf-8?B?U1o1UmJJMXBLNDNpdVlwNGZLWW5CUTEwK2lLbmduejdJSE5vOWFoOUw2bnZX?=
 =?utf-8?B?cm90RW8zbzkrMWFYcDM4NXZlRFVlTGsveXlhTFdsRWVzNXZYcE85c2wyMXlo?=
 =?utf-8?B?eWhNYS9nVEpIUUhXc2pHZXlUMkpZaUFMQ01kcGFmV0Fvb3k3NnlmajUwbkc2?=
 =?utf-8?B?TWF1RC81ZWx0ZXFaa1VxRklFdkVPYmVpTytacmtvbnRkZDd6SXF1TG03QVg3?=
 =?utf-8?B?eVl4QXJVakxWc0hNM1ZTQW9MMkJzbjBTVXIxWUxHY0lJNkFzTG1xRHgyWHRk?=
 =?utf-8?B?VXF1OEhBVmZwWXpiZXNDR3EyK3hHZlVJc2VWc3VWMEpmd1cySUthRTR4c3Fx?=
 =?utf-8?B?VDMwZi9LblhLbWs3bG5zaXJKMTZWempLbTFURFYxZE9MQmFIcjRlK0FzSGlN?=
 =?utf-8?B?ek52VTNveHROQXA2d2kxVjFtWTFXWm83YXNpeHhubUdrelZKS252b0RxQWV2?=
 =?utf-8?B?NHl2ZE1tRkRhaHJwZXlOeGRZUGJicWF0RXlCMjhKaHY0Y2FINzVMVjlLUUx5?=
 =?utf-8?B?VTVIQnBvcFV5RjN3bjEvRHZ4S0lIRTF3TUJnNjlOQ2h4VmNGaUdYR3B6Zzkw?=
 =?utf-8?B?ejg5RXd6MUUvelBwZ01NcW1oa25Pc1hXMzkyVW5NblB3NkgzSE5WR1E1MWZx?=
 =?utf-8?B?ZUtHTlJQdXJHazZxZWRTRVdZdGNCa1d3TGlQYy9TRWxhYi9uTFc5T0hHNHl3?=
 =?utf-8?B?c0hubENMQk5DRlBIWjlEYjh6aTl1ZUFGYTYyYnJNUDVSa2dJYjRGWW5kRks0?=
 =?utf-8?B?WnY4ZE1kUFNMMW0vdmg4ZDAxeEk1ZjdKeDFFY2Q2STQ2UHZ2Rm1McjQ3N3hU?=
 =?utf-8?B?SWpBK3ptd1RpMDNzeCtXNExHTWtzL1FjWHdqamNxVXZCbkozN3pSS2Voa1BS?=
 =?utf-8?B?dWYxbW9RcTloZ09GanlzMnpMejI3eDJHd0d6OTFsQm1ZdytiUnZ3emtuMUpi?=
 =?utf-8?B?ZEw3M0R6K2FOcFg1RU5FTytWa0ZwRUY3dk1mZkF5WnBrWEJBd2pNVzhmK250?=
 =?utf-8?B?elNIMjNoaWFXTWM4Mk1HMlEvaHBIZzYvcXVXQ296NVNNVDVTM0sycW5xaU1u?=
 =?utf-8?B?cW1lNXBZbEF3dHBmcUQyMnVsQ0ZBdEJ6dGNhdHdZS2xPWFFyYVRqNS9UdGdT?=
 =?utf-8?B?UHRWWCt2OUt2R1crNmhOMG55ZVBOMFd1UUdMUnFXZDVCV0phN0RWYkxBbGx1?=
 =?utf-8?B?QjRCSXVwK1lVTmFUeTlNaXdyTnRDSG9Iay91ZXgvQU93Mm9LM0d0YitpNWY2?=
 =?utf-8?B?T1BzRUVPRlJla29Na21MdjhPZWE5VmdER0tFaUovZUJMYVhHb2FUNGZnSUgw?=
 =?utf-8?B?blZlYVdLMG55Ym41QUpEcS9IKzNBUDJsaCtKZmw1ZjFuSno1NWJveTNnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5893.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWZGaDF2L2g2dDM1dDArL1ZiNkxDRlk0VEJsMDFkbDBJVGZVWFQvOEI0VkRJ?=
 =?utf-8?B?QzkwTTdkUlhTdnFmOEt1YTdrdEppOWt4UUZUQmpsMkVYZEZoVGZLOGRVRXRo?=
 =?utf-8?B?R1p2V3VrU0ZoVm5hamljb3B0SXozUUtxN2NaTWNINm91T0swT0pScnZBbSsx?=
 =?utf-8?B?MjE0ZGJsOEZxd3BRbVBDeTFyLzZUWmZNb3UycUhQcFNCSFNwTGF2Z204K0p6?=
 =?utf-8?B?QzRmbTZDaVZXTlNCMWZENTBiY1NGU3BiWGt4VDNEa3FLaVFrNjhjcUtpNHU5?=
 =?utf-8?B?dDlGMkFRKzlWWnZFQXEwT3FQcThYYkVNWGY4b2F1c2RpMk1nVllkeDlDVzRi?=
 =?utf-8?B?SHNiZG8xNTFvRWI4eFBlMWxXa3V5QXVQWW9GMzNqRGJJYzNVUWM5elJlRG1S?=
 =?utf-8?B?d043ZE93VmYyams3a0FzTUFjTkI4TWU1cWRyd3Z4Mm5ycmoybm5LQ3VFQVI4?=
 =?utf-8?B?eCtWQmFoTSt4aWVPY2pFcWFZN1Zzcm1FREFhQnRQcFBLNWRhQUZLWkFNRGkx?=
 =?utf-8?B?ZVoza1JPNVlHb3dLaU9Na2xnMWk2QnpWL09rRGhJYjRiY2xUc3dJMnNOeklG?=
 =?utf-8?B?QVF6Ylpuc2l0bVFlMGlaS2pSUHdoWkRHcTRLVkVqVFZIdFBqZzhxVFNYVG11?=
 =?utf-8?B?WWIyT3JlQTJKREFmNGpCZFM0SExRQys3aXFJVEJLMWtyZGFXQkJxRlp5MjIv?=
 =?utf-8?B?cytON09oalhWUnBmaVhIYWxwZEREbnY2YnROangxSFpMU2dJempUN1E5aWJx?=
 =?utf-8?B?ZTNwYmdXODZDdzAzV2RVelZZNThna3IxNWhRNWZGaDZndXB2RnplVFdJbTNr?=
 =?utf-8?B?QkRONmN6TmlQMmNXeXpadnd0NE9qQjFTekVqNit5YWNNcDE1QUpwazBKdFpy?=
 =?utf-8?B?bnVqUUNzQlVGVy8yVVp0WHMyaVJOSUFJVVBwdmNsWTJZTE5RYmNGL3FpWVFB?=
 =?utf-8?B?OFEwd3FKdjVIWC9tVTJwYzhwYk1zLzRDUW5KMGFLVndUdzJnR0lPZ2t6VmpD?=
 =?utf-8?B?c0dqZEZibzNrbWo3Y3lYaCtXVFdjaTFad0RrSHFLUWhhdFNiWFpwR05KZHc3?=
 =?utf-8?B?YjFqSFNueWpKM3hzRFV1SktId1BOajJPaTFLRDhxUFN3MGE5em44T2NYa3ZU?=
 =?utf-8?B?eDAyN01YalNlR2htbjRQaVZ4cGpVRnd1UGRGaEpLVUZOaHYrL1hMYTBuNENo?=
 =?utf-8?B?M0dmcGRGQ2I4MnBaVkh3Zk5mNmk5OVBmMHBINmhkK2lHSzBFeDBPSmtWRlB6?=
 =?utf-8?B?OGF1eUNkTHdtT3hmRis5S1ZMMEV4UWxMY3BnZGtncGpSejVPa3hDYnhOQ3J1?=
 =?utf-8?B?ZHZ1ZmtZSU8zUlF6Rnh0N283d0FLdHdEWGtFVU1wRFUzU2R3ay82WVg2Zm1V?=
 =?utf-8?B?MEZ4N0hMQXJOOVlzVXNFakNRcmpLUnBjK082Y1pkdG9rSmJTUEtERDh6S2lH?=
 =?utf-8?B?N205UTJYN1JaSjFqWUp6QXlQRE9NWGVBVmdjemZ1MENnSE9xa1Fack9od1Zl?=
 =?utf-8?B?RXgvVmR1U0JzR3lYUzZBSkMwYXBRSUF5NWMwbGlRbnBCT0hVM1V0K3BFemJh?=
 =?utf-8?B?bXpmU3hSZDEwVlpYWXlvTWNTcDJ0SWs2NFQwNE5PQXI3dDlLR0luck1YUG1U?=
 =?utf-8?B?OWJKSitNNkxHWDhhZ2hzeDQ5Ti9YL2Nta3h5OVFINnVMNjFhR3VRUG1waHFS?=
 =?utf-8?B?Umo0a1dTdUtaSk50d0dVK0dHZ3NQQnZESmt4UkNGSHlVZUt0K3pETTRaeEhu?=
 =?utf-8?B?YUFzM1RaY3h1dGtOT0xjSHpjS0Y0QXF6bWE4OFl3azU3SXpPTkM2dXZGMG9Z?=
 =?utf-8?B?Qk9uNmtMY3p4NG05eEROZjhBZEZzdFBaUlB3UDBQTGhZUm1uLzlYYVhMYlBT?=
 =?utf-8?B?VVR1c3ZMVWozbHRNRWw5akFzSUNKWkZSVDByZU5ZcXlJVXVYZmN6ZlEyVTBF?=
 =?utf-8?B?aTNvYWlockt5UDM0eURqanlWSElYeWRoeDcycmcvZktlM0pHaVNzSXI0eVMz?=
 =?utf-8?B?Njd4cmlBZmQvSVB6VFV3MXIyN1R3TWdSNlpLbytXR282cWFuclIxR1p4VHRr?=
 =?utf-8?B?UDZZNWFYR1BONFVmWVh2RWZBUi92V0RXdnM5MHpJd3Blbm1iTVY1ZXgvRTFM?=
 =?utf-8?B?eXR2dnZIZGpJUXp2M09vRzF2dGJZTGRPUTBUaEsxNXJZSTNNQ0NWWGs1Q3RK?=
 =?utf-8?B?OEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PiuolLMh8VEg7zG0yfKfKgWShqkl3sOFv/2fBkTctGiy7cQXyA4wh3i2qSbNvgd8TKNA92b2b8TWemr/tuODQVEvjRxAbe6eoGNHcvhPIw2FXZLIIyhZeBrGXzXdryP5gCofbiVHcAo1MSgXvOvREcC5sGy0Dkbt3BwmFYnE2k0nB4fYphTE09+hzxX7N593OirPQCteTCdFLIIFPY73G2UNHoVRScfkblMqYkW+QWdurhqT8lGPWlxzk/TY3VS8EnzZHSKPD1zoFnoWBKDczpX9DlZ/PG+JYJ1F3qH9m1lnG/UmRIIbGjyWRNO9whvvqVu1H7DDrNrqXviuKQcaC7HD3om8FbVKFkdD/boULXTLhA4GLmFZ23hr1cTF6q66u28YxMiESWkDAqvC3g5j1npxWrd7vC15UFu0FmtUOD0z2lhIgi2I+H1YaVqAZ9VKuQKUMsRpq+oVspYxSLHyLVuBjoy867pD9CJ+14NCnEt7uut89iKElnH2Xn2nP2gv8v9sZg9r/Ii5/Gh4iHUrRjzZoqORY4bfmNvRxim++kATlXVIgjxBE9X+A1aTdciYVD98DI1W9N7PDSmBCkgbzyfq7VuAcWmbzZytNXXFrlU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d483058f-2b33-4194-bb00-08dd0265d53d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 15:30:55.1940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0aHV8NjCnNI1jLOB/Qxaj0dya44FtRk74JV36dGt+XHnVvLc2o8tk/vDFZhQ3JYGhNJ93cr20TXTw8b71l4nOQPTntyU4AWcDrRunW/eG60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6360
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-11_08,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411110127
X-Proofpoint-ORIG-GUID: QYSCnAnhM8kuIrd8UDafawfhcTTZ4LAl
X-Proofpoint-GUID: QYSCnAnhM8kuIrd8UDafawfhcTTZ4LAl

On 11/11/2024 14:17, Yishai Hadas wrote:
> On 11/11/2024 12:32, Joao Martins wrote:
>>>>>            depends on VIRTIO_PCI
>>>>>            select VFIO_PCI_CORE
>>>>>            select IOMMUFD_DRIVER
>>>>
>>>> IIUC, this is not a dependency, the device will just lack dirty page
>>>> tracking with either the type1 backend or when using iommufd when the
>>>> IOMMU hardware doesn't have dirty page tracking, therefore all VM
>>>> memory is perpetually dirty.  Do I have that right?
>>>
>>> IOMMUFD_DRIVER is selected to utilize the dirty tracking functionality of IOMMU.
>>> Therefore, this is a select option rather than a dependency, similar to how the
>>> pds and mlx5 VFIO drivers handle it in their Kconfig files.
>>>
>>
>> Yishai, I think Alex is right here.
>>
>> 'select IOMMUFD_DRIVER' is more for VF dirty trackers where it uses the same
>> helpers as IOMMUFD does for dirty tracking. But it's definitely not signaling
>> intent for 'IOMMU dirty tracking' but rather 'VF dirty tracking'
> 
> I see, please see below.
> 
I should have said that in the context of VFIO drivers selecting it, not broadly
across all drivers that select it.

>>
>> If you want to tie in to IOMMU dirty tracking you probably want to do:
>>
>>     'select IOMMUFD'
>>
> 
> Looking at the below Kconfig(s) for AMD/INTEL_IOMMU [1], we can see that if
> IOMMUFD is set IOMMFD_DRIVER is selected.
> 
Correct.

> From that we can assume that to have 'IOMMU dirty tracking' the IOMMFD_DRIVER is
> finally needed/selected, right ?
> 

Right, if you have CONFIG_IOMMUFD then the IOMMU will in the end auto-select
IOMMU_DRIVER. But standalone at best you can assume that 'something does dirty
tracking'. The context (i.e. who selects it) is what tells you if it's VF or IOMMU.

In your example above, that option is meant to be selected by *a* dirty tracker,
and it's because AMD/Intel was selecting that you would have IOMMU dirty
tracking. The option essentially selects IOVA bitmaps helpers (zerocopy scheme
to set bits in a bitmap) which is both used by VF dirty trackers and IOMMU dirty
trackers. Originally this started in VFIO and later got moved into IOMMUFD which
is why we have this kconfig to allow independent use.

> So you are saying that it's redundant in the vfio/virtio driver as it will be
> selected down the road once needed ?
> 
Right.

Of course, it will always depend on user enabling the right kconfigs and such.
But that would be no different than the other drivers than don't support VF
dirty tracking.

> [1]
> https://elixir.bootlin.com/linux/v6.12-rc6/source/drivers/iommu/intel/Kconfig#L17
> https://elixir.bootlin.com/linux/v6.12-rc6/source/drivers/iommu/amd/Kconfig#L16
> 
>> But that is a big hammer, as you also need the VFIO_DEVICE_CDEV kconfig selected
>> as well and probably more.
> 
> I agree, we didn't plan to add those dependencies.
> 
>>
>> Perhaps best to do like qat/hisilicon drivers and letting the user optionally
>> pick it. Migration is anyways disabled when using type1 (unless you force it,
>> and it then it does the perpectual dirty trick).
> 
> I can drop it in V3 if we all agree that it's not really needed here.
> 

Sure


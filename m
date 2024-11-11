Return-Path: <kvm+bounces-31437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 782299C3C01
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:32:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AEEB1F22349
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77ACB1586C8;
	Mon, 11 Nov 2024 10:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YTWL/Koq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aui97K+k"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C7012F59C
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 10:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321163; cv=fail; b=lX8tL/7YkKLm8eR+swoHlukfpjvj5jrGiQqNP40ijFoTKtHRXVdJXImoZt3tvjuq5H7DqbNUYYexEIZCWUZQ+7YJzg4obMS+SZcpj6UZiy16/KC9DpR/bZ4Umsxhv6VaYlwM9fVR9/8jUkyMlxhqHSEEVgwo9GL0Lm4NuCY+66U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321163; c=relaxed/simple;
	bh=bWDiJgUK1oJ0ThhUcWqieeHeCm2yDvg83/Yl9IEZRYo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y0pzU10hOT0V252bzDB7JqX8l5QEFqtSxGpYljKJOFu4gdx6MNHvbI7vqvFCJNapInUx17gx5CSPfIbyQJgf2NWcU0BJ5dPspSFOFwZdGiyNIkfLrI75xTkx/bdfUPXb3JXkxQpG3qvzSZdVhjMnUJ2W02s5Nr9zeOF/bvp6DpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YTWL/Koq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aui97K+k; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB9slvD032332;
	Mon, 11 Nov 2024 10:32:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=HoFU9xqp8HZbQ8mx3poNnDFi0x/4HPcL+bYN/HKL5Z4=; b=
	YTWL/KoqCASIbfaETJp1Z1lICBh0kmGfY7MIn+8mWOKIiZBs6OoilFNmsKtVjZQ2
	gw62+FBydijIjlLIMsvfOE99FRKHA3qZ71+zUECJdn4CxBEzQKJTB2oC2dOOto+t
	bfvccSNZ6qFLOPOpayB0CfcOYB8yMsYex8cHFmwON9Gt3IehavbGLHY9/GwRLYMX
	o5UMDIVD2ixXBapvDE/cNpBrnL3LdzDkXir8CYHlmK3anreoqwiipPtrZx/rAwo5
	EEfTZXsdmqBAaGDYae7SafQB+sVGGVbx3UY682pK9eV1+Z1vF5LqkXJbzVr/mw8A
	rkA9B2I/5M5/TWjsICoyxw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0nwj5k1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 10:32:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB9kmIZ023767;
	Mon, 11 Nov 2024 10:32:31 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx66me1d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 10:32:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RtYkQAcgwNWhr5XLvi1CViDysbboa0P0g1bRi39Eh4ij6JDDiMvh6By0O6o3UzBv0VH5mnzmZ9ApxfTMZwFDYoZ+F+X8c29d/Av+lTa9Pm17vxokT4oSvtSo2WygZ2qfFwmnQY+ucgXEBAZpTIGZtowV2ALDzMO9cUiGiUgU4kxFIDZRJ1K5qTciq4m7326xD9szXiM7EAuGvaiURzVrftjzYGL+ZiG4+G5trsmSH5FyPpbOUMp5jDKWAWxtaX9nmRmceJZ9WrDJQNVdmxY/U14EkhUUC5XoOeQ15TxHj8buXdD/WjULIQoCNfyCrDFpmuOIhaabKLJlroq5H8dIDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HoFU9xqp8HZbQ8mx3poNnDFi0x/4HPcL+bYN/HKL5Z4=;
 b=HooyP41oNyVTh1/oHeS7650QoR0eBs8/snxds4e6vDUUTko8pc+u78/RVTK7uvHdW/9h+zwsWdBAklwhW659WyZqIol/tGS5Bg+Ujzx/VO1GBu8tRcO6CBHC0cRy+R081UT0bFDIxb+r7HOERn3UajFEooJgMLz8u52rlMT5uIYAKdPK77Mux1n33QdooyrJw08ILrtUDEISXPWIDrPMYaMBNxcJzgBRpn3DzAJr51uVRC3g8Ex8SgQ+ycdCvedMmD+uOkwRrOQ3KTtFjYM0fkupJ4sJXoH8TEKYlleU4oOakvSCDjPZanECtj9eTkNW6BXvK6SSx/C+MGYTTZJNlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HoFU9xqp8HZbQ8mx3poNnDFi0x/4HPcL+bYN/HKL5Z4=;
 b=aui97K+kBFNPqV/oRN5ynHaAbo50Pn998Daap3ka5ptcoKQ/qMgPTpe1ZtI37MSBxsUp9nakeQl9E0ONlGLNnU2s4QhGV3VIlVmxEebhhXBnWP2GSNcXSY8PPON3wu1uhmQATfMiXoZ/wFFbM9z69jR42cV720mOK3FmdZzgIJs=
Received: from PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11)
 by SJ0PR10MB4511.namprd10.prod.outlook.com (2603:10b6:a03:2de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Mon, 11 Nov
 2024 10:32:29 +0000
Received: from PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53]) by PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53%6]) with mapi id 15.20.8137.019; Mon, 11 Nov 2024
 10:32:29 +0000
Message-ID: <d2b83eef-4f39-4583-86d8-fc5bf83dd47a@oracle.com>
Date: Mon, 11 Nov 2024 10:32:23 +0000
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
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <4ea48b12-03d0-40df-8c9c-96a78343f8c6@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0168.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::11) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:EE_|SJ0PR10MB4511:EE_
X-MS-Office365-Filtering-Correlation-Id: aace0bc6-a9b9-43cb-0dd4-08dd023c2455
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzlhQVNiVnBYRFBjOVlOUXBvbFRMNWdQTTkvM1B6WTFMRlplWElQZ0xNSkc4?=
 =?utf-8?B?ZmE0WVplSUpMMXVjVzhidkJ6dTh4YjVZRU5ZakRPUVNHcXJnSlVZMmxhbm8y?=
 =?utf-8?B?dzhkVTBuYURIU25IZDFpTmwzSnZqemsvdWJYMUhtWmxKQjVZM2RBQyttMFBW?=
 =?utf-8?B?UnN6VWtkbDFjT3VLeHRTc0RORlJLZlNHbk1jUWVMOHQzano1QWpwMGFuNUxn?=
 =?utf-8?B?QWV5ZHJJZkdaaHpGSmhHUDZ2eTF6MHdNelBLR3dJMTZNMzk0bTdzM3ZXcU1R?=
 =?utf-8?B?eHNHc1BEQTNpUXQ2c0cyM0UwNmRKZURjYmJHTEd0ZFRINXF1M2JMRTRaWTR0?=
 =?utf-8?B?aEJWOTdzamE5NEtJWWswSmU3V3l6M0hVMDVLMjluWlhUaUJKRGY4ZElhWXZV?=
 =?utf-8?B?UTcxWXlrVE1lMDBkSndYa2g1V2RjNG1wUkxlVS9ZQVlLQXdHV3RvRU5XaXM3?=
 =?utf-8?B?NCsyODN1bW9GZnh1YjFEamRCZDV2VlEzTGpvK1JJcGJDTjk0THEvTmFuMVdP?=
 =?utf-8?B?TmRuNmJ1N3NuU1hhMjBpb09UODNlakNmaUdod2ZraUc4dU5JZGVCdVZ3L0FM?=
 =?utf-8?B?RWtLSHF1cTk1U2gxd2FCbEY2Mmc0RmkybnQ1TVpCUHgrbXBDTFd6bEZ6NnpS?=
 =?utf-8?B?VnBSMjBpZFk3Y2pKMHpjRmtYa3p3cjBwalBFQVQ1aE5BNEZydTNaWEZpNkJE?=
 =?utf-8?B?WjlqZEFLV0d6RTJ4NkhkMVZhME9SYlV6YnFUMkNodWRwNndzS3ZTbU0za2FQ?=
 =?utf-8?B?b0Y1YzA2djdYUVd1UFA1TWxxS0dOcHdwVHNNTUZUSTBvbUQyTTFlM3dweit6?=
 =?utf-8?B?UUFTZnd1a1gyRHdoeGM0Y1lSallLbkkzTlBlei9TNlgxR2Exc0FLazdPd1lw?=
 =?utf-8?B?d1FZQWlnbE1IajQyOHNWc3c3UFk1UlMxd0R1dmtNaUt6dUlPb0JRZHc2S3k5?=
 =?utf-8?B?TThHbVE4MGNuRnQ2djUrTEtybDMvK2REM2ljcXQ4MkhXSXYxYS9ML1Fwekhu?=
 =?utf-8?B?WlJ1OFMwYXZvVnp1R1RJUlNEOFMzYk1yTk4wYjdTS3REMHFOYkNaZTBGRUwx?=
 =?utf-8?B?L0MyZi9QOW9BYktIM3h1Z1h0SGQxRkpmWVA0NWNmMHFSMDNHTUNNNXhHeVNE?=
 =?utf-8?B?QXBXVTZqNThmdGRuVmtvZ0VQZEV3SzVIY3JWd29IL1BlN2RKQ1dPZUpJeEFw?=
 =?utf-8?B?ZkZpY283YjNldUZoSklaNkdJNkVpY1IzNWtSZmJvdGJFdUFOY3d1WWVoZXk2?=
 =?utf-8?B?N29pbjAzZUptQWNMbnBxc2VoK2xSSDdWUHRuZDkvcWJVaEFaa2NFbnVoVDlo?=
 =?utf-8?B?YkJpWThkb3JYU3JvcTY5cWdyL1Z2WEp2cmx6QjZMRjhnNFVBRFZzZ3RnejU1?=
 =?utf-8?B?bEkwNDZyNGRFTng2SkdtcFNvN0RzY2dyMkhTdmtzUWxRbXNwQlU0TzU4Z1Ft?=
 =?utf-8?B?UWxLdlQraVFtLy9JY2pNYmNMQ2F5RUE5WXl2eHg2Q1ZYb3NmRnNmR1FneEhU?=
 =?utf-8?B?T01WVEkybGRLMnNrK0JnenpoVTJqQXlCNUYrdlM1VTUvcWN3VEF5V3pjeStH?=
 =?utf-8?B?eVpTYXlnSitvNVNhZ1l5di9HVlFOZ3ZkNkFiZ0tZZWdqbWlEc2RyVG9GQVp4?=
 =?utf-8?B?clJPbkVDcHNDUEdzcGVES3hYWGo5dnlKZUQwZnZVV2s2eFdsdXp1RVFSWTFs?=
 =?utf-8?B?bzRoS2pOZWJUL0U3dXU3Zk9JRHRaYmxGM2NPWkJsVzQvNjNVSWFTQU5XK2FO?=
 =?utf-8?Q?DqHg1Y/CnfOjJSJ50U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5893.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzZCSktVQzB3NG9xbmJ5R1cvTTcvYXNIdlJXeXNTOEFJQldIaERPd092bkN2?=
 =?utf-8?B?RmZkbFV1Wk5qdFFHbUY5MlRmK3V5RkJQUW1LN1pWUEx1QWJqYmtCY1hWOU5m?=
 =?utf-8?B?bmtXdW80dFdnb0c5T2E4NmZFQ0o3TzVoQmxPOGd1TFBJSEgvUUNnU2NieWs5?=
 =?utf-8?B?K2kwUnNEa1FZSmxtWE9ud0Z2MGFVZTE1Zlc3NFdyTUJoQk9uWVpjS1pNNnZM?=
 =?utf-8?B?ZjdYUmZVMUVHa2JTS1ZBQVFET3gxSTc5OEZSUWxOdVRlY3ZSSlRoQ1dsVVdT?=
 =?utf-8?B?MW9aOEMvQTFSdmZiOXR2bjdRcmR2KzFmaExVTzlDVzVKamEwbEwwYm5BZHVk?=
 =?utf-8?B?WURFNlM1SlRPUnNmOEVLenJYU3A2QmE4QnN6dERDZCtvc3VVRVA5SWtkRUdx?=
 =?utf-8?B?R3M3bTBkZU9yenFZazRsb2tWKzZyajMvYkc5b2tXTGd0SmRLYitSSHFwcWJ3?=
 =?utf-8?B?eUVtZnFEQm03SDNPNVFPZ3BWZDFoeXNNcmduaFVWdUxZOVo3aHYvWWsrWFZI?=
 =?utf-8?B?MHIyN1laT3E4VkNkUndTZ3F0cU5haVNsWVlQZG5mNmFNb0pxUHhrYi81ek5l?=
 =?utf-8?B?YkhPZ09EUUJQakt3YmdNeXl0N2pmeERiemZtZklGSHFKcWptY2VGZWxaZExv?=
 =?utf-8?B?c1ZZRU5idkoveUNPamFqeVdMN3NWS1Q0Y2NnN2E4SGhqUkdRTThrVFMwR0Ur?=
 =?utf-8?B?M2J1SFZRM1h6TDRJWWNndjFYY0dhbElRdXFOM3o0ODNqdnJ2SGlMYlA1Yld4?=
 =?utf-8?B?VURlR29HaTNHRHhPWG5nQ0xiODliMmRUTUFrTjBsQkRENEw0a2Z6QUtXTWNC?=
 =?utf-8?B?bkFqVWQyTUNuUGVhWHVCNzdTeCtKVmVLZTEva05WVTdOb0ZWaVl0Q0xMTzVQ?=
 =?utf-8?B?N1lpZ0YxOVJ1eFphWEV2VUhRcFh1aWtTektJK0dUdmNqUkVDMVJCd1ZPQk85?=
 =?utf-8?B?ck5DNi8wSUxrOVduWGZiSWNMV05lUGgrMTdEdFlwMFVmQ0p0WmhoQ0F6aVZU?=
 =?utf-8?B?VW52Yy9DVUwyK0haeklJazZtWEdUY2YrcTc0TW9ROVdsSVloWmc4NWJBSkVo?=
 =?utf-8?B?UStJa1ZRNGswOHkrNC9HY1dwaEUza3hRelNkR2ZadTg3NG5pcWt1bFhncmdx?=
 =?utf-8?B?T2hsUGpMVkQzRkZKcmhsQ1NWMlZONmtxMkpoN0I3WDNPRmo5a0lsdXIwYUdF?=
 =?utf-8?B?Y01wQXhtTkp2L3g2UmQvNk5EN2tGNWVBTnMzYmlHMnJIRCs2eWdISFFMYkE1?=
 =?utf-8?B?Z05NSndFZUJSTERKb1QrOXZDdnMyajh2WXRPbmltT003Q1RXcVU2MWxKREQv?=
 =?utf-8?B?S3Y2TkphUUZCT0pGVXZwRXQrUjFDYnF6dC9JV2ZlZTFBZWVZalhOOHNsNkx2?=
 =?utf-8?B?NDZRV3d2Qmdod2drVWVyOUtvYW1kUjVsVEJrUitySWQzK3lLRml5TUs1c21E?=
 =?utf-8?B?N056NzgrV293b213NlI1emhMaHNrb3BrTzhySHpPcXJqSTlnTDNxZVVJLzlT?=
 =?utf-8?B?ekQ4WDlETWVYaTcwR2VjT1Y0cVN0blNZUVg1K2VoTXVmMDlRU3ZPOWl0V21U?=
 =?utf-8?B?UW5ZRzJ0Mk9SZW1JRXpCOW1ka29adUpYWm9hMW5QNC9LMENGckZwYmRPK1Rr?=
 =?utf-8?B?SU9id3A3U0FRU01ITGdyNCtyU3hyY3ZhUGM1dWdLM3l4SDgyd1YySmI3Nmh3?=
 =?utf-8?B?MGpISTlNQ2tVUXpXMk03UXV1b0NJK1Y0aG85WE9ZRUY4S3g1eFJwMlZaTWNj?=
 =?utf-8?B?RXR1Zy9RekNsSUx4eW5pQUdZaHhRaVYvNm1zK3dtVlVQekZqY2YxejBSc21x?=
 =?utf-8?B?UjVNeFdEMFZzYU1TZFk3Q052TitwdnZUckRoVEFOVGlBOWFkcWhDNytveEx3?=
 =?utf-8?B?YVhsWGRZMWVpT2JnVWlheE45aWRmK0ZvcytHK0M1eDBRdlp0VVhZMXk3TmdP?=
 =?utf-8?B?ZHNHWGUzQWFSYW1vTXIzdkQ0T2hVK2xkaDE2S0cydEx3cHJ2L3ZrVUdtWlNM?=
 =?utf-8?B?VEhTLzBPMUZPUVZqRldXWDlYRkZkUFhxNDViektraHVoWTBTcFZkS29LNmcr?=
 =?utf-8?B?bFQ0OXNpaFJoNi9FQ1dLWWE2NjBHRm5mR2F0aVU2Njg1OVdKNUVwRTE3ck91?=
 =?utf-8?B?UGRuUzRzNEdZVlhDVVEvdDcyejhRVG1aYzZyM2lVWWE1dWdoMkxLbm9qandC?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NtW5/mJdi5wjx4+Ut3Vfmgtb8CI//mw5aOyqhUVS04CsvWsSodseiYDtCb5/OBUBO19YAMhrxbFwvqzK6o3kFkKeERmcHNlmCyL68DZvAWWgCOpPYweuygsQ89bfW6khGyZRkVD8qG1yaAjd4p3EKs7nqc2OPYYSmEbRHR7kVIp1+azKzqzguFJMUgtK6eb1UF6ftCoJ+JZVf9faB/ZVBkO6e1SlBc0KUFw2hUx+eQSsubhmGeod59ybgGMfF+tIyeKLfYBgaTxtwUytvI0c0PuL/fSPoQsq/jWdSbC32pl106Qz+naYYYWRO/IenPTWz90kFp2ZzOPbuaDjh9w2lVJgWeXusPirMqyYMH2wnkH/JY1RTJ2chLV0ADDEi7nVJ11UfbRF7kiLZTr85l5di+Rs3lCNWF7MLJbzARnNrVzf+F03nMEvXGRuk+sWsADzC8Shbzsx3bh0zq6x9DLF/455P5FTTqtTypaiUOeqIIlCs7Ht6D62fwLDMRGEc5u9IUwBas8eKZvlbcvB2Ujrb0gSOWNK9MHfgDnyDhS8UGcmTYOW30TcV2b781pquQDyTC9sPQLLNUrqfva/2o9Cczx04XdIobQ1D2TsSu0KWBM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aace0bc6-a9b9-43cb-0dd4-08dd023c2455
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 10:32:29.0055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aqjAMYV6kya/6qtHLAnhaU0tdLpVU5dzt8GgOR7QaqSJ/fsD4KKmCivzaYJt8cMNLTCED6Qh6uZ1zorEd8PrsR2MW6tEdpy8sElUVPDplr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4511
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-11_07,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=983 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411110089
X-Proofpoint-GUID: 3YJiWBWI9KuqTRCTyt7hem1Z0lptxF5F
X-Proofpoint-ORIG-GUID: 3YJiWBWI9KuqTRCTyt7hem1Z0lptxF5F

>>>           depends on VIRTIO_PCI
>>>           select VFIO_PCI_CORE
>>>           select IOMMUFD_DRIVER
>>
>> IIUC, this is not a dependency, the device will just lack dirty page
>> tracking with either the type1 backend or when using iommufd when the
>> IOMMU hardware doesn't have dirty page tracking, therefore all VM
>> memory is perpetually dirty.  Do I have that right?
> 
> IOMMUFD_DRIVER is selected to utilize the dirty tracking functionality of IOMMU.
> Therefore, this is a select option rather than a dependency, similar to how the
> pds and mlx5 VFIO drivers handle it in their Kconfig files.
> 

Yishai, I think Alex is right here.

'select IOMMUFD_DRIVER' is more for VF dirty trackers where it uses the same
helpers as IOMMUFD does for dirty tracking. But it's definitely not signaling
intent for 'IOMMU dirty tracking' but rather 'VF dirty tracking'

If you want to tie in to IOMMU dirty tracking you probably want to do:

	'select IOMMUFD'

But that is a big hammer, as you also need the VFIO_DEVICE_CDEV kconfig selected
as well and probably more.

Perhaps best to do like qat/hisilicon drivers and letting the user optionally
pick it. Migration is anyways disabled when using type1 (unless you force it,
and it then it does the perpectual dirty trick).


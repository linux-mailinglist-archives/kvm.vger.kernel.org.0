Return-Path: <kvm+bounces-36699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8B7A1FFD1
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:32:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D51C18875AE
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B610C1D90A9;
	Mon, 27 Jan 2025 21:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GLnDyqLw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0ES7RmbY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3088C1D86FB
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013505; cv=fail; b=hk/MvhGkUHMBschcqxI92vBG3dwdyiybXb5gRxJ09OStagr7lYHi+jUTjehPcXQIwkgi18+d5YR8RWyRfWpX7LyOXMmoHJ7JYVXfqGwJZvfJ0vG0qCJREg6uzNHRX/Shg3FoR5FqnkJiltLs31Iua16xqHfk736A+f0kCy+VGbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013505; c=relaxed/simple;
	bh=jWyChtVMY2aUcbUP43wyEN9FbDpsyiR1yQHeWEX47TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iBLt7d7cWfws4gUHMD7FrNWh5IFs8pmVfs0wkQQZ3SvyyFQe42TRZC0K68UFuAKai09IbHM6phIrOiAlGZEYIokxOtgQV28iZRW1A9EOJ8EDti9eE/urUvLEpHp8s5ofYS3f9PHNMo33ZZcJoTIf+SgoV5tIcT02VCitKDTdJwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GLnDyqLw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0ES7RmbY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50RL0ul9024705;
	Mon, 27 Jan 2025 21:31:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=y9szqM8+igS1V7zEBErk5drGmYfCdPNOM17CjVkyfmo=; b=
	GLnDyqLw8hbc+VUzmCpgR2XjgFtTgRlo3lSZ6BuUQ+EnOgQPyD18J2i6655s0sq7
	QZ8jEUrbCGGjIFGdaqWenZM24WCHhCaJMMaeiDl3v5k77GaG+epFoL6aB7SsIfHW
	CqImSCvZfBH/YC/AYL3MqW6p7JuJCH8KeVErwZN0nJv1fjdfqdR7Iwik/iYRfWTx
	wZ1CxCAAxnA66ewJkmBFI/Aj6hN4zWpxy5ElSoRVnPQsw+uedRfU1Om6Y91p1dY4
	lnVcf1xtq2dtiennclmYIbsrf0Q5wobY/DheLUsMdbs401NcsKPZ1TIELPc5OQ2q
	8OEKKRmDTycw3HAY3NNSXw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44ehpc8267-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50RL9RhU005344;
	Mon, 27 Jan 2025 21:31:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44cpd7k1dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJVvGYZR8HMup9jVOcTArBKSlAY7AvihTxMVkOVCf8zIBEFVirK/eoxloMURK4ALmb4fALvpZt97116i0BHxMJRpyt3IAQgvHwKPJT550XZWzw48k9AFRpyhWVeOTcS5o9iNeYgmGxXyCff1wZQ5AsIgcyPtheMVUYfBcjV1njlkv746zMA24SmkosY3K5voteJ2o1GEt/PaShs9Fmc93lSumFUCuAY/1TnKiotV0ZulIVDESVAUT4vwW9JcR2FmoXOed2e58Fr5Y41BlLMPdBU474BPRTN1Li1oMuUyUqqj+ywW1goEpt4BUl95csaY3vKOxumSD4i8eHkzCuad+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9szqM8+igS1V7zEBErk5drGmYfCdPNOM17CjVkyfmo=;
 b=quSmU2WtKUltC4GKzLnIkHYhc+UKYr9zDd6S8gHu66e82QyLSFgwKswBl3HiIxVae+sLUWWjUlVvHYdjCNWobtsKcYjAKQ2c/8pOqacAHsO+9KU8GBo5uJoHIQX/EwkrmBXxob/4KbfaVmtiTQT8Y1bTtKncbfC4vSj7MDxCpvCAWqc0+t4c7uj7/Zzts19WZdciNwdGbUNBy9wtUVFEyZTwD+dj5/67h9CipZH9I+XOtRhOLlSjzVZZSUOSqlpMxRk8n+mK69nLvbAK3QCTGnuOgMO0DzoGZ6TY3W04yg/5LrobHwVI93N2Tx0pdTdaSwB5RyPCZ1MZ3PzjsQLSXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9szqM8+igS1V7zEBErk5drGmYfCdPNOM17CjVkyfmo=;
 b=0ES7RmbYq3Jyqs1t41ZYS10EKhC9jQqqcwQ+MmzruDQvhLtO1IeybM52LEgrcDfZLjllsjBEni8jFFi+nK7J+l445ly9hIfmfYPhzefXiH9gt+OacciDK2G9mfvENlz0P/4I9gpPLEEhTthIDQjBZUugHUKo6QApN5ePxF+/rG4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.23; Mon, 27 Jan
 2025 21:31:29 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 21:31:29 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v6 3/6] accel/kvm: Report the loss of a large memory page
Date: Mon, 27 Jan 2025 21:31:04 +0000
Message-ID: <20250127213107.3454680-4-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250127213107.3454680-1-william.roche@oracle.com>
References: <20250127213107.3454680-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0695.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4614:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f9f93b0-f708-4c6d-e0a5-08dd3f19f653
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M21H39vUfYSLi2+IzqWxU7e7dnZAkiIJsWDuJKtZddFcTPCTHDrvnn92BAGm?=
 =?us-ascii?Q?lSmEF1uYGFjtdcsqqQ4QQYBeLyV+3HBrJuht6S2XblHp7kqSTSXZPJQPboPH?=
 =?us-ascii?Q?0rTbFi9Y0/32RlGLqdaA0+r4Uawa+EOHNo+n+zjp0vyqHcZPNIxl2aIHFsGe?=
 =?us-ascii?Q?piZbDpM33vNR86odrowD8iDmEpZA+4v8qtNY3G3aq0MP5uNR72CGSZxr9xrT?=
 =?us-ascii?Q?jpZM5N8XK2FlUpeNOnzEbfNZU9lk8jxE70rf+l9hZ0ebJ1Nn6ST/RwvXFDTG?=
 =?us-ascii?Q?Hh/eEKindfvLbXHyBixHalr0m6KSnI3Q9nD9wQnZhAviNNyC1FJ6/spHnIvQ?=
 =?us-ascii?Q?7a76QevQZpJpNtusE64JkF8Ly2FUfPYJ2e+8F8XNkxuA8JPki+lpTjIr9bJ8?=
 =?us-ascii?Q?ubG5S0mNI55iEhAfbZkPHY88VwVgkP/TGUVqiM8DA5OKdD5nbv1ZUWywvRpn?=
 =?us-ascii?Q?Ahuwz+0jYh7IBOuAmBa2LX5DTl0zGbbab1FdxO0qExr4FWWytteVoSdg7GvP?=
 =?us-ascii?Q?ahCTW6d9JyAxzPYWiXmK9YkdnzaAzfQHsdgQtoyP5lIHZyp+1KJ422h/i4NQ?=
 =?us-ascii?Q?HEwEG7o0l+u3CXEUZNYxqS/wMraIprWS0tSINQDjjHL50Pe3b3JF9EzAiT8C?=
 =?us-ascii?Q?QiLpefKWv7woBjPcOt3cgfT5lmPfITPJJmhNXtjbCNv82wrSy1z3Diasad2R?=
 =?us-ascii?Q?3VRBTG+tRXwXIF83Q6cBe25B6xMXmgFWdIv0krczhp5zYckVcWN3fWO4y2qM?=
 =?us-ascii?Q?cdzBCZOUZ8Iiu5+KjSkv+d8BNEurREd56XsKLpqxw82yq978K3f2UhKrqjLl?=
 =?us-ascii?Q?lVLufls/qrQ9+gUleKnuKfHuVpEcNWy6r86rQcpSO8d9CTuIn7viWXXPrOnh?=
 =?us-ascii?Q?NJ7q5Oc8Soe05ZllGt269p/YdHyDtrBSvJ9QIqJlG8KHraEDQwHu7gTmekTS?=
 =?us-ascii?Q?FDJv8f4MhuKXmDkENxbOcHthFcCDXbIS4qXLF+Dl8TkzyX6K0SZ40Wup0yBh?=
 =?us-ascii?Q?nr1ok5NVQOK0zoVwl91zHkkKbA/zCiejR4eckIKhUAuXxyD+Grh/+buo9kfq?=
 =?us-ascii?Q?VYePE9GKa8Wx70ESEeAVftrAgTqoqUITfk14MyAVz9mx3DIP6rOwa0b8wl5Q?=
 =?us-ascii?Q?0iynPOTu9PdqrSbu/mUkpyIg1d08Uj0LdQtzteOA++J/Vt00jzpRGRvP0GgH?=
 =?us-ascii?Q?NqqC5kh8lJduveIMw9k1M+ojEVNsEonfz49ahDnFjcXBIh1McBbZYZ2TfzRk?=
 =?us-ascii?Q?UCqf/spXJD1XZ8kJXsx+CWHgLAEanPHv5TGVH7Hmip/H0ADc4pIJitIU2PPr?=
 =?us-ascii?Q?m13UDXwT8xIaHZURorzdTH8Ph+WJil+5VOOSWHGtluc/YDsAHfuMNzxaZGmy?=
 =?us-ascii?Q?y1kDzRewv852YaWpEfzjnN1rWa+t?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MXt/IfGXF5qsUPZIHKQRbVH5p6aOvz+sdUv5Z1OGuhUJKw7u/PdFcGxbU/3/?=
 =?us-ascii?Q?WXHFRTQp9/9czVJE9WeTIiLxN+MPbNHAQHmtSk7lJ2onLmwF8wmC94ht8nSC?=
 =?us-ascii?Q?kq/sygxozprX8p1RX2m1WsrukbXT71kIlG6veNN/GNS+3FqNYxgs06QRgFjT?=
 =?us-ascii?Q?7i8S8DvuA75D3n27v5M3T07ZSiHekGL4TE6HYnnjW8z9RbLtZ1C6a1XX0NAy?=
 =?us-ascii?Q?yOSzef0YIbb+TzKYJZKQQMQ3POM39hWRAxRh41y22F0d+Otqy0vKmNvKvOUK?=
 =?us-ascii?Q?KfJlNz1X2a32KqjEXsfcOpX7O+QwGaH8RV7ItCeRP6HZXaUiIc/axfE0SWnX?=
 =?us-ascii?Q?uQdb3FfvKD/VVGZmZ3q6pS2J/o73DQ7s9B5pki7P/2KqRyFUIssjYrdNqgoT?=
 =?us-ascii?Q?PFT0SEpkwp/x9iE1uhcjiydyBWdMw259fWI9avvUF4i4xb8/6deZyFP7+K/u?=
 =?us-ascii?Q?W2HfJnIEGML6iosjLApNMYT3FxxS/h43qiC0LDTuON1GfzVAj+lcmLXUgAwM?=
 =?us-ascii?Q?Jmicqy/PDT6MyQ7mYYqYR8hhW8zRD5WUEYZ9v9OmxBZ2OpR49qAA7YU0YV/+?=
 =?us-ascii?Q?aG17w4bRr8XmTPOdI2FrXPr/5uT8u3cIQ3UAzbqBhNIJEjMNOudiyCpMa8UK?=
 =?us-ascii?Q?HloEPdn5Y4cpe1VR/lb3AP24CaeeDyRnecrjb5VC1r4ai5SqDGxSWz3A5K2v?=
 =?us-ascii?Q?iS5FrWyNNkU/96VMBDJ5uiRVrvzTHf2rSP3o4tZJCQD9RyWnl7+kUmBTGSDC?=
 =?us-ascii?Q?JEXi/SBUeuwL5B4KbYvY9fghfAzW2FzLYrsA5Njw8hovlER1sPpwUi4dqjpi?=
 =?us-ascii?Q?SKhdKyH/OW1fcH2K000Zx9q8z5aS/ajTZBL5A5E8IBiUYK1mI9ePAUDfkQLk?=
 =?us-ascii?Q?jD632/YTZskpunZ+XsBFz6f1tBk3o86KSwGU51GrITwCKOtzzjdK3PUC9WPO?=
 =?us-ascii?Q?OivAEVqO105wBuXGjCWI5KUrZiIbHTbCNXvernmZL+DN4bh9mvxH95HK+wp8?=
 =?us-ascii?Q?jaG94onyg4YswvXmafUqoy1jd4V1PdPCIcUo+DyfYf+LN52PM4Ow9gxmuj3k?=
 =?us-ascii?Q?e59VxYAvakX2lzb2HN8OuO+CaQqYKM/BmFDwsVwElOdP2AQOqA2v+h5FyBr2?=
 =?us-ascii?Q?1FVmEi5LCJczhN2Op0REKY252AgpRUzbia/XUFvu2Br2AtUVC1IM0X+akf/7?=
 =?us-ascii?Q?Uz6E5J7GInIQYC/U58pmMnhfC5IG6Rm8gcN5kx6sk0W794d6o9FqzhgCbw9q?=
 =?us-ascii?Q?VFDKPIOZkmL47d5mCuZTZaYgLcjcIdwvDumU+SyvpcWgXpjCjasgSuWAq8p7?=
 =?us-ascii?Q?n7NHQhJn+ynXEBgWptcY2wmAZ6Rs6spMzbfqtwlCwoueO1omw+nDIqb/9wMd?=
 =?us-ascii?Q?DQEjNZlBmkJ33YtQ6jwsbLBuDqymE+A9vLLNFGGQrIVVB1geERJTvC6m9Ykd?=
 =?us-ascii?Q?3UAh5yjuqQqQMk3YjNJjEBTyBBn8AqAyfql+HRlajo3XQ46G341N4ojM5HgS?=
 =?us-ascii?Q?OzA9bmjrGzp8WUg95t5vvx3DOAQ9NpefiZi//zuH0+wsulDwQl2E21OyQYRl?=
 =?us-ascii?Q?UeA338ZQ+IMTBrf/IriCkxZMNYvYdrFD8GI75Qj/j2f8Ezno+rll9uTLghIU?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uFzsD1n4FJjEIJadVMwpmvZP+2BR5xcau2BC+F2GsXiykMRinE2nJdbUadG3A/HnUMCBb9vgqqxelAR+qRrNd4zuHpcaS+MEiIAZxUOeZwhrR3dabcW3Ia4AZzL7yzjKUTgBJhGLf0zZQx/xw5YODAjeLiIIYWVm37imLs/HascQ4Z/xFmoMMsRpeE180KSc4irMJ7taCM6vxBgGaftL++teFKjGWEGa5AfrgMNzK1cZkphCac1yAZ4gwxnKzZfM9IGCdvsqb+6fLlGTcSG3CYBzjqytESor1hylBfbg5KgjsGpGp6ieU3uAbClXAxn8ywiuzTH2KItLurQOlMDaiEYr6N4rCWg9dldC0RlI0s+kgBcSgp5MUU8GiZKMcVmlQzNGau7u5HpIJbgSUSVQ4x6/VyluarV80CtZGHv/e0QZA2Byms5lz17H+9BZNuUow72x+mcVMtDMFQKuGs9uPzzBuTP3/qIqYUSfFqLRBuMTn0yR+DYnrYqPIsUR0XGjpbxdJs+rgRVRTXMRfHeDEBlrErbd46RUb7ysKHULq/WWQHE10V9swDO+B0lnsalfzd2ICbELw1rhSgd+yDZcxbCTfxrGkFd+9RjBvW3qdd4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9f93b0-f708-4c6d-e0a5-08dd3f19f653
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 21:31:29.7918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72tzTSEaVInRSJp5nUGiRAKmTOoFsWIHVKCb9EDJRgAtyZyVWeGdun1WlBywG0mJoqVw+2YRthFs7WoinP+p94xq3Pq1KnOi5dlOgHWTm5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_10,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501270169
X-Proofpoint-GUID: EBa8Mw1YP8K0_H3A2q_zph53PEeLblr0
X-Proofpoint-ORIG-GUID: EBa8Mw1YP8K0_H3A2q_zph53PEeLblr0

From: William Roche <william.roche@oracle.com>

In case of a large page impacted by a memory error, provide an
information about the impacted large page before the memory
error injection message.

This message would also appear on ras enabled ARM platforms, with
the introduction of an x86 similar error injection message.

In the case of a large page impacted, we now report:
Memory Error on large page from <backend>:<address>+<fd_offset> +<page_size>

Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c       | 11 +++++++++++
 include/exec/cpu-common.h |  9 +++++++++
 system/physmem.c          | 21 +++++++++++++++++++++
 target/arm/kvm.c          |  3 +++
 4 files changed, 44 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f89568bfa3..08e14f8960 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1296,6 +1296,17 @@ static void kvm_unpoison_all(void *param)
 void kvm_hwpoison_page_add(ram_addr_t ram_addr)
 {
     HWPoisonPage *page;
+    struct RAMBlockInfo rb_info;
+
+    if (qemu_ram_block_location_info_from_addr(ram_addr, &rb_info)) {
+        size_t ps = rb_info.page_size;
+        if (ps > TARGET_PAGE_SIZE) {
+            uint64_t offset = ram_addr - rb_info.offset;
+            error_report("Memory Error on large page from %s:%" PRIx64
+                         "+%" PRIx64 " +%zx", rb_info.idstr,
+                         QEMU_ALIGN_DOWN(offset, ps), rb_info.fd_offset, ps);
+        }
+    }
 
     QLIST_FOREACH(page, &hwpoison_page_list, list) {
         if (page->ram_addr == ram_addr) {
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 3771b2130c..176537fd80 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -110,6 +110,15 @@ int qemu_ram_get_fd(RAMBlock *rb);
 size_t qemu_ram_pagesize(RAMBlock *block);
 size_t qemu_ram_pagesize_largest(void);
 
+struct RAMBlockInfo {
+    char idstr[256];
+    ram_addr_t offset;
+    uint64_t fd_offset;
+    size_t page_size;
+};
+bool qemu_ram_block_location_info_from_addr(ram_addr_t ram_addr,
+                                            struct RAMBlockInfo *block);
+
 /**
  * cpu_address_space_init:
  * @cpu: CPU to add this address space to
diff --git a/system/physmem.c b/system/physmem.c
index 3dc10ae27b..c835fef26b 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1678,6 +1678,27 @@ size_t qemu_ram_pagesize_largest(void)
     return largest;
 }
 
+/* Copy RAMBlock information associated to the given ram_addr location */
+bool qemu_ram_block_location_info_from_addr(ram_addr_t ram_addr,
+                                            struct RAMBlockInfo *b_info)
+{
+    RAMBlock *rb;
+
+    assert(b_info);
+
+    RCU_READ_LOCK_GUARD();
+    rb =  qemu_get_ram_block(ram_addr);
+    if (!rb) {
+        return false;
+    }
+
+    pstrcat(b_info->idstr, sizeof(b_info->idstr), rb->idstr);
+    b_info->offset = rb->offset;
+    b_info->fd_offset = rb->fd_offset;
+    b_info->page_size = rb->page_size;
+    return true;
+}
+
 static int memory_try_enable_merging(void *addr, size_t len)
 {
     if (!machine_mem_merge(current_machine)) {
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index da30bdbb23..d9dedc6d74 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2389,6 +2389,9 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
                 kvm_cpu_synchronize_state(c);
                 if (!acpi_ghes_memory_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
                     kvm_inject_arm_sea(c);
+                    error_report("Guest Memory Error at QEMU addr %p and "
+                        "GUEST addr 0x%" HWADDR_PRIx " of type %s injected",
+                        addr, paddr, "BUS_MCEERR_AR");
                 } else {
                     error_report("failed to record the error");
                     abort();
-- 
2.43.5



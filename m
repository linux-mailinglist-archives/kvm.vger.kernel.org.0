Return-Path: <kvm+bounces-51983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C4EEAFEEEA
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 18:38:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A5E41C83EB5
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D689321FF26;
	Wed,  9 Jul 2025 16:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TdAHftQ2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JgIIvfHB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2EF13C9C4;
	Wed,  9 Jul 2025 16:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752079117; cv=fail; b=pStqZwB1K2tu0tuy3YLScYWPDg4f9QQ77lqloH/oegOQlhQdLT54vuiNed63WF8eRY+6NN2loWAvk2moknv/EgZ4GeIXN59U54+Dm2nXS9SI9sWPFqGffDdYa2ca+ZQ9/miYnvnMyhN+HqBLDTQdLw51nbOsUNgmz+z0hyAVEc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752079117; c=relaxed/simple;
	bh=elyCRoCicGCBUEDGGyWDujtGEzfFLCkfp53ZKI8ieHo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OlkBmjPLmbKGS4DKSc8MKoWvuoiMWjRrNq4v36kPZ7GeMFQV8MeDwHOUoHhNaO6qgzjcrAOtKUzgPfe4yhCK2XFRGaHM5Fad/IuaoSYLGtPTAplFau6xyYAQ4roSD3Nf5zAmM0+CREu8J4zvyar/OR71Fbohe75NmfET5jwbaOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TdAHftQ2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JgIIvfHB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 569Fg8kk005800;
	Wed, 9 Jul 2025 16:38:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SHtDSZLZkXt20BlLaw01lxVwxWYB4vB83ca7UgjmxC8=; b=
	TdAHftQ2CU69tg0gBoFgVIfPQenrWKvl/2fAZoYfAAX+7TV0MlkPBvNtX8Ssx/ZX
	OuDunUqfSCQoweseUpWWtpBczHODSxQoQXa5MwSqDFn+Zy4lSO1AEw3m0WdtBOG/
	MGNUDPa3WHx+sZFL/9hdzTAeB0RC3dsCnvP6HELNH0Og883qEjq2cXk3n8wTlBas
	LcH5LoJWXtZqGWzXyZ0utQqt7U/mGxXvfkIiGiR6EcDnZtTzSwkJImpP0K3Ptkr+
	hdXj3msTQ6WFQ5vFxH2cDQoFAbRjHSAy0L0apbwDF3QtW10RyqrCCXIiRCcA/pj/
	0RACSUsA8OLFOJ8HxeOmQQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47su9r846j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 16:38:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 569FPJnc014173;
	Wed, 9 Jul 2025 16:38:29 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2049.outbound.protection.outlook.com [40.107.100.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgb75aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 16:38:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c6RUtkhZZbi4W6zwCE3B6pfj4IT0E5VdgWWWR+3pt/h5uogDF5ptmsFG+zWdyQpZAb/rjS6ApxrEjUFeiiSR9+uRO3AjYiDLH++NPM+Bzw/vBvIcspYxqgAIDlQWTIGrPjk0nH59v7YYgPdNQp665852SEdL8FOaM4ErxecwcvmPM+XXBPltGBi/Y0H7vD2+dy1lWDt0bNW22euX5kstFEWKtPFwsdOLd9Yot6oX4q9325wuAd160H1eUuviiF5jVP7nw7fNshHZ2Ka7Md2uoah5Kt4n2pSvqTUNeR3FW1MA58v4zl8C94ocEDzH92gMfNgxYnnI1GeY+K+p6k+dmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SHtDSZLZkXt20BlLaw01lxVwxWYB4vB83ca7UgjmxC8=;
 b=AByVL+JgXNqxnBo+xkW67pdDjxF/d02tgZmoBxqWmjL7Pg/oXGS2zDgh5z2CgE9E3/nO80blX0+r8WDc2YSoFrXvaCSTWRJIsFLCv6XX3vg4tfK2S3uOD9poVCauASG0k6dFWRHwUtUt3hr9NVhR/bXXvYzEM+wVef1syHex9uQ/R5E/5PSVr2MF3KMlO6SN3L1x8FVrFjL1ev41T7PJuYT8LsdkI7SWYAOYJ9Uv3Kps/bOvNmueIC9w2Ys9Eoep0M6dBfp7r0QT1GKYvAJFuENv2cN6+PJGGZIPz1mOo7RVyJE4wph6o06lDymRoZt3ii+e/67C8x2MldRALDazzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SHtDSZLZkXt20BlLaw01lxVwxWYB4vB83ca7UgjmxC8=;
 b=JgIIvfHB8Agc8NZhbhg7u7UuMUQIyrWN6Qd1MaUZEiEeh6jc85tzvYoUNabtI9SFJPxjVzbdOI3voWRuEiOxXJgQkGn0BEh8Pd7c0FAvx4891QBC7FREi5USeBjkIGKJx9T72u7FynQcT0anDQqV3pPkQWuWt16yIQDfNMfGvDo=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by PH0PR10MB7078.namprd10.prod.outlook.com (2603:10b6:510:288::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 16:38:26 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935%3]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 16:38:26 +0000
Message-ID: <f9cc1fe1-79cd-40ec-8fa9-88a14f1b2ca1@oracle.com>
Date: Wed, 9 Jul 2025 12:38:23 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 1/2] vhost: basic in order support
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com, eperezma@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250708064819.35282-1-jasowang@redhat.com>
 <20250708064819.35282-2-jasowang@redhat.com>
Content-Language: en-US
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <20250708064819.35282-2-jasowang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P220CA0164.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:33b::7) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|PH0PR10MB7078:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c1fa793-865a-4501-c6fc-08ddbf070726
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q294UW8xcFlydjNuWkc4S3VsdGpteW1RVGRLaStuOGJKRGx6cXdVaFdHMHB0?=
 =?utf-8?B?aUxlYTJtQ3NkZ3J5MHc3TnBkaGZaM2hVd3JwUDFuQkF4QnZIajY0cWowQlQ2?=
 =?utf-8?B?TVN3eVg2QURtczc3dGxYRklESzhDOG15NFdKcmNCWU9OcGNkM1BjQzlKcDhY?=
 =?utf-8?B?cE5rSjdxcGtsUFVTYjRZL1ZYRHNienJkSkdLbWFSR1VYVC9Vd0NlUEJjWEJy?=
 =?utf-8?B?RTdlbzJVa1VLbmY2ak92eXB3NGZzano1Y2gwZ0poc2gwMDMrbDlRcmwwQkdv?=
 =?utf-8?B?TERDUWNuQkhIaHZNZEd1ZFlBOVBQdGgyVXBrT21qbXNMcFFuWGZBVkFPK0Fu?=
 =?utf-8?B?M05xMlhMTGJjV0IyQVFiMmlrNDliQk1GQlZVOVR3eDN5bnVsMHVRSEpubC9J?=
 =?utf-8?B?eFlvTlNjWjRPbnNmMUdpUEFsVThtZEpBVVFhblpMY0VNekJqV3BMbEo2WUsv?=
 =?utf-8?B?RkQxQzVvK0d4S25lUFFMWjhibmJqclFtcHJlR0d1M3FKR0QrejIreDN3ZStT?=
 =?utf-8?B?a096ZDVqZUpnb2dFQW5Eb3VEaVdxQnRLL2tETlBjUWU0RENyNXFQV3ppczZT?=
 =?utf-8?B?VlIvbFZXUEhjR2RZakl4b29DRUJhRGsrVFU2MUM1YlBvQnNHRkJ2cDZWRi9W?=
 =?utf-8?B?QWViZnE5d0FNSDVSbFgwZWtlN21vM21pUE0yaDk4QVBZcFhYMnArZmJmVDBz?=
 =?utf-8?B?dVFTNEloeDBUYzdWdThGOUU3TzF1ZVBST2tBcDhKQnlEeWZ2SE8ycEpOdFZB?=
 =?utf-8?B?bktjeElFZmMzMkJNOWtBenUwQ0pENGpiZFNIQUU3anUzbk9ML2hsb0ZCTTlk?=
 =?utf-8?B?bzZNMzl2VlZ4MjZaa0pyMW12WlVGVi9xdW5HQ0w1dzNBWkRaeWpUcTY0VDNI?=
 =?utf-8?B?cXN6WXllN0JFYldOR1MzLy9wdFgvcEhkWVNZTFNpYXBmTy9CcGlSaXk1UlN4?=
 =?utf-8?B?N0h2NTF2aHVkT0IrK2dISkxkdnVjamhWOTNLeXdQc3crQ3ZPc24zQ0NBUmkv?=
 =?utf-8?B?RnorSlpVK3p3cHo1WjlmQU5vT21qTUR1YmhwbWtZWWtidTM4cjR5Zk1yTVN6?=
 =?utf-8?B?NnI2c2p4RmFYRGlBc2xrMzc4a1kzbEZQUTA5VzREVUdIMGpFRG1VeWV6b1oy?=
 =?utf-8?B?OExwNEM4OEZaNlRFOUFFQmllTDJtT3V0ODVRZmtoaEloc1Zva0podU84VWp0?=
 =?utf-8?B?NDR0Y3kydlhnSlZvVWlZR3VVd1N2ZmRXamUxUmdkVFFGOVpCQXRzWXZLazU2?=
 =?utf-8?B?WTlGMHZhYUNwWkVXdGg5RGJhczBpWUF4Rmplc044eUVVVFNGLytZakVIcnVI?=
 =?utf-8?B?Z0RYb0h3QU4xZU54Mm9CWUV5T1hIZG5kcWZ4OGs2M1pKdFVWYXBjUVh4eUVC?=
 =?utf-8?B?ZjYrZm4wbHVsYmtnV21FdjEyY1c1RzVISWYyWHhHOVg5bSt4RVhqNksrZllG?=
 =?utf-8?B?MXNGNlR1cjBJd2p6by9URU9UNWRsdDlyU1J1aWtIZGJwREpDdnc2NHQybXB1?=
 =?utf-8?B?T3dCUGtIRGhEQlcrWUhkZFBUS3BoOWZRQ3hibXovNDZqTzFUOEFuVFlWWWx2?=
 =?utf-8?B?aFRpVnh6NXhnc2syYisxMVlBa1ZpTEtTK1QyVXgzRlorUTg5OGxjVDRvNE1Z?=
 =?utf-8?B?cFZIT09OOURyNXN2TThCOVg3UERBdUpjMU93R2wzRzlpaVRKQ1JmWjNWUTZB?=
 =?utf-8?B?eGNQemZZVEkzRVR1WUs4U015LzVMTGxLR1pNd1MvUG0vNUhKbHRXQWN1UUdv?=
 =?utf-8?B?dy9Vck84MFgyZmlBZHg3MzAzZUJ0WDNQVnBuN0dXazIxb0dFbmhWWHdjNWFI?=
 =?utf-8?B?MnNncGZoQnVsUTg5b0VTRGxMZW52ZlhIV29wWjV3YW9hanpYV2hOU1ZOSnFS?=
 =?utf-8?B?c1RvSGt2SXB3czR5ajJsTzk0VTN5Z1dWOEtLS2NlZEtFa0hmZytrM3lEeURC?=
 =?utf-8?Q?A4Uix06UIC8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFFUdDNPVHlTTGx2cWdFU2VvQUhldnpvZXBZbDJrSHp0ei9JbldPNDFQQy9I?=
 =?utf-8?B?MFBTY3FuRDVwTUdXWTliVXd6eEthK2NMcElVaStuUS85L3JaUi9mcWN5Z3M5?=
 =?utf-8?B?Z0IyVWE1YlpvSzE5ZjRpcDhjc1VRTG9qYXlZVWIvc1RtcUJwMFJsR01GYSto?=
 =?utf-8?B?ZUFINGxqQmxKanE0K2ZiQkFyb2k5VlhkYi9ZUFVzWEVSVGptaW01M2VJMzAx?=
 =?utf-8?B?d3ppbWRqblVZMmxjdXF2bGdlT29TdkUxa1liTFN5eWYyeTF2YllWdk5reWFw?=
 =?utf-8?B?d3c3NWpxUHp3eXZ4bEFERXhEUGRBUmY1NkMwNmI0VXVzZFFKZDZyTGpldE9V?=
 =?utf-8?B?OEFNTkZFUmowWnQ0Vys2L2NvSjFTSGltQlB2WFJ6Unl3U1RwYmMrMzZrUzZB?=
 =?utf-8?B?SkF2bEVCcEh4d0ZrakNveFFqa0tSSVlUSjJFZ2Y1aXJjMzZGei9MdEVuazVw?=
 =?utf-8?B?R1llZTRpeThJSXJqOGIzaFh6czQzd3RySEgwSUd0SkFhTE9CcCtBVHFhYkNp?=
 =?utf-8?B?ZWF1VlZ1Z0ZmdjhuZ01MYzIrU3pUNUxzQzNXLy9QaStqQkJZUGRyd1VIUEw2?=
 =?utf-8?B?MzVMemlyTXJ6NE9GUWNGN0RlUmRIR00wL3RMTTl1eGxnUnVMWUEzb2RRTGFi?=
 =?utf-8?B?NjZxcUhJdzZOMzNyZG1QeWNkWnhzcVl2YjEycHJlZE9nS1dVcEEzdUF6bENL?=
 =?utf-8?B?blF2a3BSRE90aTVqZGhhS2NlK2s2T1IvZE4rZHRRQXdaSHNLSFNHQTkzM1JR?=
 =?utf-8?B?cHRqTlcvUW8yeGF1c2J5RENtYnNIRDd6bnNqeTVFRDZhbTliRVVvK3BjdFV6?=
 =?utf-8?B?MUdUSnM3ejVodkRtWW8vbmN3UHp6bytCUWJuRStqa1pQclhLeHBSdEhzTkNK?=
 =?utf-8?B?NlhYYmFUWVpzM2xJSlBINW92cGozRzZxcyt0VnBneHo4Z0pJSnpnbGZKYVBW?=
 =?utf-8?B?cUR2SFEvREI2RE1ubU1QYUMrdFdFK0NNMjFZU0R6Mk9hY0dPTE1vVHNwZjQ3?=
 =?utf-8?B?Ri9xZWNNaU9ic1cwdnMzc1RZWUxKeWY4MTQ4dW56Z3IxcWlwZVczYk4yVTJx?=
 =?utf-8?B?NUxyZ0ptRXJFdWlRVTZaNWVFQitXU1FVUEs3WWVYNlJZbHJvU3pRSTh0TkJy?=
 =?utf-8?B?bDZiczEydlJlY1RjSDBva0ZSWVBENmkzK2tIWlVBNjNqaXI5MFhJT1FUMG15?=
 =?utf-8?B?L2txWXJ5cTF6WmFYeURQd3FVMWR2eVRtWXVLZzA5Q1hqdUdpUlZRUzB4REVC?=
 =?utf-8?B?Rnh6bkk2VDNBbFg1dTlkazZaUFVTNTMxRGRXWTJTRUsyTlFnTGFZRkJQSk5V?=
 =?utf-8?B?ejFWcHBNUUlDdjBUUk1sTk53clY0U3NhMzRIQlpMdW9URll5bU03UUJFcTB2?=
 =?utf-8?B?eGlqMi9selhOaUQxVThVRlpVLytsb0dvaGlhVFVkZEcxWTE3a09zZmw4cHRM?=
 =?utf-8?B?Q2dJcW04anU1WWhoUTV4d3JuZ3NUclhsMWRoUE5WM3BNc3hwUC9RWGxMWnBQ?=
 =?utf-8?B?WWJMQ1pjZTlzTlhPQ1NaWTNtZUhjUEJQWENHNkhPSkJuQ3lYZnl6MTN1eGpX?=
 =?utf-8?B?ZzJ1OVJPeitIODhwOEhjendBUDQ2REFvS2k5bGxXZ0ZLQ1pacEgwdU9QdzdQ?=
 =?utf-8?B?RTAwdjU1RGRocnNINjUxY21uNDhKeFpSZEVnZWxtMURaR1VqS3d5TXBBd2xQ?=
 =?utf-8?B?NFRWSXN6bGpsMXB3U3Z5bHJnaGZsWkUvaFlBbXl5Slk4Uytqd284elo0bGdj?=
 =?utf-8?B?aWliam41Y2lVSHFEdjk1UzFrVnlqZmZiL1ZZV0lycmFDa3k1VERaZGRjZHVj?=
 =?utf-8?B?NXUza3I5cE5wNmNmQVJYSDhLNzNwZTRLTFJ6VmVBVGlMV0loZitHdVAxVGZS?=
 =?utf-8?B?VnlxMkZyU3ZvSmpjQWZWMm5sQitvazlnMFNhczNKZ3AzaTZ3cDROaytvZ3Nm?=
 =?utf-8?B?VHByTUZuRCtDK2xoekJ0UVl5aUk3SjVwa2M4Q3dGRlNjR1kxTDVicVl4T1VH?=
 =?utf-8?B?bXdFYjgwR3JyK1N0M1c0WmpHaHA3ZUxOd0RGc3k5Q2t0UDdubVh4VFJYZzZ3?=
 =?utf-8?B?V204REgwYVd2QVFRUnNHYzlwMWI4OHBuV2NqWGVOYzRYanVKcTlnU3Nsd0ow?=
 =?utf-8?Q?OU0nip+LG1LMJqNzhuCzCVH2U?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DQC3k7oHqhyDz59Pl+pAudHi0znt4OWWSebwXTKxP6jEnRbtEcJkStof7vn93pb5OS+ap2goYC0xwaxVL/spyZCbgLZSTDd6vi/dcAn/z3G9ovErwI/OD1p0APsseK8JFZJ96V1sxBXVKwZTzv6pVxdK1oQJ6eFdPtlo3JlvNBXyjcaq4KIEsCx/VTZ0waMN4GLiCPB1IqWPDjQvPzlKBMTL7FLbbE4xUzO+CcF2n3I393tg/CzO85ZedPWUadWsANJLxKsQ7fS8gv99huPeBmKWVAEDOWGzUWh7KKOb9IDGCBxY/PiL9w9bx/BF1jsyHtNf5kDthP5Pz8S2AuMmzxxtUFnKw9r5ojYrxv1KYY8ckqF5j9ga2F3Juu5/utR9wo+U/1gmCdHTnTWClQGrCZSdRM1yZO5IYlmQGwhRDu9iEMA3gJQLSjdbeQH5emIn4stgctTU+a9snhH0WFDmTMvJwyLtZFWIKgSDDiE25788fC697Q762rGnnFtJMcIYPemx1iOJSmnZj6c9JsIh2RhXxk3FOov/K+/e5nPiy4cfI8LZk4+FEk6FNlyW4vx91eoK3NoLD60QtyTRhWN2PmywF9nCnf7/eIFiTZNN7F0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c1fa793-865a-4501-c6fc-08ddbf070726
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 16:38:26.7694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MIRP11XyrZ8gvBpWVSxIuqyQKQBaAXKGj5yPNFvSGDjzV1RB8SzIndVXcAJ4ie4wkzG+GGE/XwcYWOwYqEuj7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_04,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507090150
X-Authority-Analysis: v=2.4 cv=QJNoRhLL c=1 sm=1 tr=0 ts=686e9b06 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=mxazp8rusr5fQPiLM0cA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12058
X-Proofpoint-ORIG-GUID: ax-DiXusTxMyPBvOYD4LM--FWsZy81Ro
X-Proofpoint-GUID: ax-DiXusTxMyPBvOYD4LM--FWsZy81Ro
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDE1MCBTYWx0ZWRfX8G1VGbyqTrnT ukcvNp9+mlDYOOOld3kFfdtsEHbWDbYt/MMZ4yGqFTque2yyuRzXFgqcmiWOGedwDBxQ0SR61VO M+Z68/2hFzQRy/2kWU95f+9k4KcgdnUY03FQvvGbGDFgDWHoZLonkQBIqdkTt0szRDyPRx7OpBU
 DLdzEzi9/1huhrKdVPU4I29JroFKeNbKIKPYIwW2+vU6sGV8B2GJLreg7rKZkyZxkqP8r1QLMVT 22hsB/uBQ+cWqt2+Q95gDJi1WmUUsW3QREhgu8Mzp21k1ukDaYfxE8hyJXWi0j/HJJWjLTFTwsi yRHFR1zapiCqcjju0KBAlXOutoL5NHWPb9gp46lkyWzG4szopOwoybMdJR5Nb9yQrRqcntgLn/y
 HyHSvJpGe7yILjZeKDrandmDW//OKVIPrUN6ogehcZ38T9WDxSnCso7c/7Pzxn16TJmPUist



On 7/8/25 2:48 AM, Jason Wang wrote:
> This patch adds basic in order support for vhost. Two optimizations
> are implemented in this patch:
> 
> 1) Since driver uses descriptor in order, vhost can deduce the next
>     avail ring head by counting the number of descriptors that has been
>     used in next_avail_head. This eliminate the need to access the
>     available ring in vhost.
> 
> 2) vhost_add_used_and_singal_n() is extended to accept the number of
>     batched buffers per used elem. While this increases the times of
>     usersapce memory access but it helps to reduce the chance of
>     used ring access of both the driver and vhost.
> 
> Vhost-net will be the first user for this.

Acked-by: Jonah Palmer <jonah.palmer@oracle.com>

> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/vhost/net.c   |   6 ++-
>   drivers/vhost/vhost.c | 121 +++++++++++++++++++++++++++++++++++-------
>   drivers/vhost/vhost.h |   8 ++-
>   3 files changed, 111 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 7cbfc7d718b3..4f9c67f17b49 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -374,7 +374,8 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
>   	while (j) {
>   		add = min(UIO_MAXIOV - nvq->done_idx, j);
>   		vhost_add_used_and_signal_n(vq->dev, vq,
> -					    &vq->heads[nvq->done_idx], add);
> +					    &vq->heads[nvq->done_idx],
> +					    NULL, add);
>   		nvq->done_idx = (nvq->done_idx + add) % UIO_MAXIOV;
>   		j -= add;
>   	}
> @@ -457,7 +458,8 @@ static void vhost_net_signal_used(struct vhost_net_virtqueue *nvq)
>   	if (!nvq->done_idx)
>   		return;
>   
> -	vhost_add_used_and_signal_n(dev, vq, vq->heads, nvq->done_idx);
> +	vhost_add_used_and_signal_n(dev, vq, vq->heads, NULL,
> +				    nvq->done_idx);
>   	nvq->done_idx = 0;
>   }
>   
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 3a5ebb973dba..c7ed069fc49e 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -364,6 +364,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>   	vq->avail = NULL;
>   	vq->used = NULL;
>   	vq->last_avail_idx = 0;
> +	vq->next_avail_head = 0;
>   	vq->avail_idx = 0;
>   	vq->last_used_idx = 0;
>   	vq->signalled_used = 0;
> @@ -455,6 +456,8 @@ static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
>   	vq->log = NULL;
>   	kfree(vq->heads);
>   	vq->heads = NULL;
> +	kfree(vq->nheads);
> +	vq->nheads = NULL;
>   }
>   
>   /* Helper to allocate iovec buffers for all vqs. */
> @@ -472,7 +475,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>   					GFP_KERNEL);
>   		vq->heads = kmalloc_array(dev->iov_limit, sizeof(*vq->heads),
>   					  GFP_KERNEL);
> -		if (!vq->indirect || !vq->log || !vq->heads)
> +		vq->nheads = kmalloc_array(dev->iov_limit, sizeof(*vq->nheads),
> +					   GFP_KERNEL);
> +		if (!vq->indirect || !vq->log || !vq->heads || !vq->nheads)
>   			goto err_nomem;
>   	}
>   	return 0;
> @@ -1990,14 +1995,15 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
>   			break;
>   		}
>   		if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED)) {
> -			vq->last_avail_idx = s.num & 0xffff;
> +			vq->next_avail_head = vq->last_avail_idx =
> +					      s.num & 0xffff;
>   			vq->last_used_idx = (s.num >> 16) & 0xffff;
>   		} else {
>   			if (s.num > 0xffff) {
>   				r = -EINVAL;
>   				break;
>   			}
> -			vq->last_avail_idx = s.num;
> +			vq->next_avail_head = vq->last_avail_idx = s.num;
>   		}
>   		/* Forget the cached index value. */
>   		vq->avail_idx = vq->last_avail_idx;
> @@ -2590,11 +2596,12 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>   		      unsigned int *out_num, unsigned int *in_num,
>   		      struct vhost_log *log, unsigned int *log_num)
>   {
> +	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
>   	struct vring_desc desc;
>   	unsigned int i, head, found = 0;
>   	u16 last_avail_idx = vq->last_avail_idx;
>   	__virtio16 ring_head;
> -	int ret, access;
> +	int ret, access, c = 0;
>   
>   	if (vq->avail_idx == vq->last_avail_idx) {
>   		ret = vhost_get_avail_idx(vq);
> @@ -2605,17 +2612,21 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>   			return vq->num;
>   	}
>   
> -	/* Grab the next descriptor number they're advertising, and increment
> -	 * the index we've seen. */
> -	if (unlikely(vhost_get_avail_head(vq, &ring_head, last_avail_idx))) {
> -		vq_err(vq, "Failed to read head: idx %d address %p\n",
> -		       last_avail_idx,
> -		       &vq->avail->ring[last_avail_idx % vq->num]);
> -		return -EFAULT;
> +	if (in_order)
> +		head = vq->next_avail_head & (vq->num - 1);
> +	else {
> +		/* Grab the next descriptor number they're
> +		 * advertising, and increment the index we've seen. */
> +		if (unlikely(vhost_get_avail_head(vq, &ring_head,
> +						  last_avail_idx))) {
> +			vq_err(vq, "Failed to read head: idx %d address %p\n",
> +				last_avail_idx,
> +				&vq->avail->ring[last_avail_idx % vq->num]);
> +			return -EFAULT;
> +		}
> +		head = vhost16_to_cpu(vq, ring_head);
>   	}
>   
> -	head = vhost16_to_cpu(vq, ring_head);
> -
>   	/* If their number is silly, that's an error. */
>   	if (unlikely(head >= vq->num)) {
>   		vq_err(vq, "Guest says index %u > %u is available",
> @@ -2658,6 +2669,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>   						"in indirect descriptor at idx %d\n", i);
>   				return ret;
>   			}
> +			++c;
>   			continue;
>   		}
>   
> @@ -2693,10 +2705,12 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>   			}
>   			*out_num += ret;
>   		}
> +		++c;
>   	} while ((i = next_desc(vq, &desc)) != -1);
>   
>   	/* On success, increment avail index. */
>   	vq->last_avail_idx++;
> +	vq->next_avail_head += c;
>   
>   	/* Assume notifications from guest are disabled at this point,
>   	 * if they aren't we would need to update avail_event index. */
> @@ -2720,8 +2734,9 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
>   		cpu_to_vhost32(vq, head),
>   		cpu_to_vhost32(vq, len)
>   	};
> +	u16 nheads = 1;
>   
> -	return vhost_add_used_n(vq, &heads, 1);
> +	return vhost_add_used_n(vq, &heads, &nheads, 1);
>   }
>   EXPORT_SYMBOL_GPL(vhost_add_used);
>   
> @@ -2757,10 +2772,10 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
>   	return 0;
>   }
>   
> -/* After we've used one of their buffers, we tell them about it.  We'll then
> - * want to notify the guest, using eventfd. */
> -int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
> -		     unsigned count)
> +static int vhost_add_used_n_ooo(struct vhost_virtqueue *vq,
> +				struct vring_used_elem *heads,
> +				u16 *nheads,
> +				unsigned count)
>   {
>   	int start, n, r;
>   
> @@ -2775,6 +2790,70 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
>   	}
>   	r = __vhost_add_used_n(vq, heads, count);
>   
> +	return r;
> +}
> +
> +static int vhost_add_used_n_in_order(struct vhost_virtqueue *vq,
> +				     struct vring_used_elem *heads,
> +				     u16 *nheads,
> +				     unsigned count)
> +{
> +	vring_used_elem_t __user *used;
> +	u16 old, new = vq->last_used_idx;
> +	int start, i;
> +
> +	if (!nheads)
> +		return -EINVAL;
> +
> +	start = vq->last_used_idx & (vq->num - 1);
> +	used = vq->used->ring + start;
> +
> +	for (i = 0; i < count; i++) {
> +		if (vhost_put_used(vq, &heads[i], start, 1)) {
> +			vq_err(vq, "Failed to write used");
> +			return -EFAULT;
> +		}
> +		start += nheads[i];
> +		new += nheads[i];
> +		if (start >= vq->num)
> +			start -= vq->num;
> +	}
> +
> +	if (unlikely(vq->log_used)) {
> +		/* Make sure data is seen before log. */
> +		smp_wmb();
> +		/* Log used ring entry write. */
> +		log_used(vq, ((void __user *)used - (void __user *)vq->used),
> +			 (vq->num - start) * sizeof *used);
> +		if (start + count > vq->num)
> +			log_used(vq, 0,
> +				 (start + count - vq->num) * sizeof *used);
> +	}
> +
> +	old = vq->last_used_idx;
> +	vq->last_used_idx = new;
> +	/* If the driver never bothers to signal in a very long while,
> +	 * used index might wrap around. If that happens, invalidate
> +	 * signalled_used index we stored. TODO: make sure driver
> +	 * signals at least once in 2^16 and remove this. */
> +	if (unlikely((u16)(new - vq->signalled_used) < (u16)(new - old)))
> +		vq->signalled_used_valid = false;
> +	return 0;
> +}
> +
> +/* After we've used one of their buffers, we tell them about it.  We'll then
> + * want to notify the guest, using eventfd. */
> +int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
> +		     u16 *nheads, unsigned count)
> +{
> +	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> +	int r;
> +
> +	if (!in_order || !nheads)
> +		r = vhost_add_used_n_ooo(vq, heads, nheads, count);
> +	else
> +		r = vhost_add_used_n_in_order(vq, heads, nheads, count);
> +
>   	/* Make sure buffer is written before we update index. */
>   	smp_wmb();
>   	if (vhost_put_used_idx(vq)) {
> @@ -2853,9 +2932,11 @@ EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
>   /* multi-buffer version of vhost_add_used_and_signal */
>   void vhost_add_used_and_signal_n(struct vhost_dev *dev,
>   				 struct vhost_virtqueue *vq,
> -				 struct vring_used_elem *heads, unsigned count)
> +				 struct vring_used_elem *heads,
> +				 u16 *nheads,
> +				 unsigned count)
>   {
> -	vhost_add_used_n(vq, heads, count);
> +	vhost_add_used_n(vq, heads, nheads, count);
>   	vhost_signal(dev, vq);
>   }
>   EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index bb75a292d50c..dca9f309d396 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -103,6 +103,8 @@ struct vhost_virtqueue {
>   	 * Values are limited to 0x7fff, and the high bit is used as
>   	 * a wrap counter when using VIRTIO_F_RING_PACKED. */
>   	u16 last_avail_idx;
> +	/* Next avail ring head when VIRTIO_F_IN_ORDER is neogitated */
> +	u16 next_avail_head;
>   
>   	/* Caches available index value from user. */
>   	u16 avail_idx;
> @@ -129,6 +131,7 @@ struct vhost_virtqueue {
>   	struct iovec iotlb_iov[64];
>   	struct iovec *indirect;
>   	struct vring_used_elem *heads;
> +	u16 *nheads;
>   	/* Protected by virtqueue mutex. */
>   	struct vhost_iotlb *umem;
>   	struct vhost_iotlb *iotlb;
> @@ -213,11 +216,12 @@ bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
>   int vhost_vq_init_access(struct vhost_virtqueue *);
>   int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
>   int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
> -		     unsigned count);
> +		     u16 *nheads, unsigned count);
>   void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
>   			       unsigned int id, int len);
>   void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
> -			       struct vring_used_elem *heads, unsigned count);
> +				 struct vring_used_elem *heads, u16 *nheads,
> +				 unsigned count);
>   void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
>   void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *);
>   bool vhost_vq_avail_empty(struct vhost_dev *, struct vhost_virtqueue *);



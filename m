Return-Path: <kvm+bounces-20437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A245F915B8C
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 03:18:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5873D2832E1
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 01:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4DF168BE;
	Tue, 25 Jun 2024 01:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aYm4xRa/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mpcJpAYq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5EA8BEA;
	Tue, 25 Jun 2024 01:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719278277; cv=fail; b=MzuXbiRbgw2ecb1Wpe9NPOxptQFTPioZetvzScX3Uf5Z98vThtWzamMGye/UE5FS4pnUj9gKp7oBe6JJBv2b+u+ESAB6ai11UMEOpyK5TUfQ5sEFWFSU/VEM48jXwabylas0komJb46UShtcEtW18nFfsSlpfnKrRoaKlKcj0Sw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719278277; c=relaxed/simple;
	bh=rhjnF6tfRLQdUd01QFyHkY3TGxnaAW3bBB2Ud2LRuAk=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=P/SvD0YtGrsQZcUKvyeZxwUVKLmLpfiWlgGlk8n2IXt7a0QBou3YmGyuwWBpnzX6I9pCxvufC5u3MVoiZRHfnVturt4QHvJJ+TmB/Kqddm4CdNsSeE5X6USAtzPDeTwUTLfnaqe/bme6h1+r84/a/BTTxhN6w+BaNv0PMta86EI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aYm4xRa/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mpcJpAYq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45OLckIM023363;
	Tue, 25 Jun 2024 01:17:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	references:from:to:cc:subject:in-reply-to:date:message-id
	:content-type:mime-version; s=corp-2023-11-20; bh=rhjnF6tfRLQdUd
	01QFyHkY3TGxnaAW3bBB2Ud2LRuAk=; b=aYm4xRa/an5JyR2fs+UAjFia3uhF+u
	EF36Lqok2RA+qC1rZZoiNMw65p36+fz3K6z+ZBHfIdTVniaxLs1ulYL9VwAGgs8n
	0AQyMY3nt9bOvZ7l4KOeRWIDU7Puo8HMuLkdFN+v4GRZsS6UcebC4CCXDyHM/9FI
	MnKE/iTH50TaFBZ2iqFqquKzfrjSu7dAkUXKb6x6r/7yM7WCko6AklRsWFB+QCZ8
	Er21xULUbMS3g7roz+YZIOGo8y14N9q65RdioNc8y3J8GKkXT+Fi5dzCzgVM8tWn
	Ina8TVHk10SBfuHWmhc5M64EqlQGXtBsmwMr/8xoPpB4IeHlgQPSiAMA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywp7sfkv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 01:17:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45ONKC8Z021690;
	Tue, 25 Jun 2024 01:17:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yxys3ryvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 01:17:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+waokS2rLavVs9enJsGFpQS1uTOjBItCHr/h6+cYsPTQ9o4xtSv19QHbH7+ht4h7wW45gNi0lvB/+ngRESTp3XgZn/hAok+OHXCpas6T59j1UqyEJQBxoz6kkuwHmmgScq1ZfIIavUaQPBaXEVlI66ovelqAvF3PdSm+wIubxyBCF6Y9PpcVYJ8zAyIK1LzNpzpVjWEuw3y/2I2GCvBBDBNlwZsPMx8RTLbDuO63MUUZd7VQPrvpsM1cFQJ7KrTd9dqRa/y/VY2MNc6uNOYiK8aKxXqPyQhgMWMdGvVx5gWM5IkHGH3G0Bj438L04HgNaPMLqZw2QGc8thlhjwVdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhjnF6tfRLQdUd01QFyHkY3TGxnaAW3bBB2Ud2LRuAk=;
 b=BspeUEXHLor/StArlxvu5rhe2yQvecnfyAbMoBhrtRLwu1QnmNf7dOiBaA7LODbKgMUy2MLOjrceke/bQl9E9IPW1hNbHWPlXvmFYlzxlfEMLnTTVQJTAwcq04eZCDMcBaNbMPvCvWIN/dxEr92/PfdH1kLx4SoIIhKIgoDit3Te+ETa427JPnaW/Hgb+o2cCuHLmwhE2HmsP4oRyF27/YNJTLA8wbfZSFNQ7JZh8uF9T9oYOHQHfvCkkUiZilx7siBRahFXkJhwBo8WjiWcmWMM1kizfjVCk6TusxyfMAN4k38YKZChJn0pymHSQvu1SIYDPiVp6Y71bTjo8/EkZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhjnF6tfRLQdUd01QFyHkY3TGxnaAW3bBB2Ud2LRuAk=;
 b=mpcJpAYqKfGfV0JdqA+cD/wJ6gqImAzG8BsS+EJvXXWOMNGDTCgxy+4tH6EHAxvf1H1y09ZIqBELR4CQzPLlBB58CKNswbjhIYD235QIZfEyro2FjaQ6SgMoK/HtmgUu7cEns1rIi86kShturd+0/HTr/JUjq+WlCrgr8HsmCdY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by PH7PR10MB7801.namprd10.prod.outlook.com (2603:10b6:510:308::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.29; Tue, 25 Jun
 2024 01:17:21 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 01:17:21 +0000
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
 <20240430183730.561960-9-ankur.a.arora@oracle.com>
 <20240619121711.jid3enfzak7vykyn@bogus> <871q4pc0f9.fsf@oracle.com>
 <ZnlQg9kcAWG443re@bogus>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org,
        peterz@infradead.org, arnd@arndb.de, lenb@kernel.org,
        mark.rutland@arm.com, harisokn@amazon.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH 8/9] arm64: support cpuidle-haltpoll
In-reply-to: <ZnlQg9kcAWG443re@bogus>
Date: Mon, 24 Jun 2024 18:17:19 -0700
Message-ID: <87bk3pakio.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0312.namprd03.prod.outlook.com
 (2603:10b6:303:dd::17) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|PH7PR10MB7801:EE_
X-MS-Office365-Filtering-Correlation-Id: 658ee3fc-844e-4f61-b961-08dc94b48ffe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|7416011|366013|1800799021;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?lRwTIk/RqHSECIXsrivugKwpiNLm1Hafpb9ZxYppu0haIT31BUnFO5YhEfit?=
 =?us-ascii?Q?DyhU0Ldck4ciKOiiL2KHfDIacFmotauBHNY2sqh1eg5Wy7/xhrslCEP2mu2U?=
 =?us-ascii?Q?4tg5BmNVWNVKTXCWyK10KVvxNfXY2WHPBrV5WQhC2s/BgGcuE2OK697Io2IA?=
 =?us-ascii?Q?j6YiIkLuKjmwLuZvjrTuMnV18CsJ1etqqc77Lc+vlTzR+YARLcektRJWE1V/?=
 =?us-ascii?Q?4UMDco2XYdS5MXt0CPwbmjkOj2wAzFmKZZIpIg7/o/XagbywR71tmGxW88k+?=
 =?us-ascii?Q?3WUhM2xjLfdlkskbFQLwRoUSzzaNtu0Jn7Gg9x61fvxcODTwUSZ9TI5ekjDL?=
 =?us-ascii?Q?aMHZ3AUS9nZWuRDGniL6VzIdVEoeB1+J2szimoIJ+ggwgBIWVuWGgjFuSore?=
 =?us-ascii?Q?9FpQTCFzPOrpWdMQe4Yi4FKruvZMLv3LbPX16rthwXcBVlEg8Nf6QFY9aK7K?=
 =?us-ascii?Q?iXqhtS3H+tDB9qiR4K7coleTN+CCMDYxuWmXamjPOd+NQQWDq6aiKlGatVKD?=
 =?us-ascii?Q?xA+33jzU8iY5T9+m7ElAMVVQIOWul/EaZGVrV6f2Qg8qfqX0OJWs58wRWpUf?=
 =?us-ascii?Q?BaX4lqI42+ZQth3qiZ1y4nEJtOI0ubQTuAP72/burOezMPw7Fh7zHmQKc/AV?=
 =?us-ascii?Q?873c2pKK6AypY4iGya00kLxr0AfuWao8i85jmY/xXuA0ouZLIaFY23vP/dYW?=
 =?us-ascii?Q?qv2ju8/oV5p15rbLUHpysUqKkP4IFeRGarbj31RbDsm+nwAmlZNRVYMCnJgB?=
 =?us-ascii?Q?lQ4Ll4M2xrTNuIo5jjjqdTyoO7TIxiGOWQEMxxViWrbnMZfNGU033vKtuHtd?=
 =?us-ascii?Q?NIm6L0IlVUXGvYvNzXfISf7KfDSmpHjbu1GlMjqMXxsSJNnsi+l2NfYJusu2?=
 =?us-ascii?Q?HqftCqyZST12/exzlVS+DOjZXRlycxWa2fsOI4SU85YSUOIbQ4c2dOr2IilF?=
 =?us-ascii?Q?moQZII8UhVYSMwV3ZolSu6sHGN9eUu8Nya7+9LQpyhP2hOa2jQ2oyhKBOa6m?=
 =?us-ascii?Q?A9zRdY6NCXI22Aanisw2SVa7Jy/sxmYbccjMILNudQcJgg0kJbugm2cucEQu?=
 =?us-ascii?Q?cXvYTy7FSdoRgv/g4bnsECrCxp/ke62aS/nV5YiFERIMe5CEq8V7DtJ6n+G3?=
 =?us-ascii?Q?oCODqr4Nl+TPZLZ0Ert1YVFtTEjuQ2U1H15aHh6m6ycqEr5DWSSALcD5YfSY?=
 =?us-ascii?Q?Nh8il3KWqhqxFTKY0aXWFaFgzXt+Ng/RGSW34gwIt1KgR///LTMu6nSeSmxx?=
 =?us-ascii?Q?h8ZOoT//rEkNjn1zGtu5TSIygzKmYY6L5/GSenmoa0jEKpcMakATodw0zqge?=
 =?us-ascii?Q?1vlU7UJuEfgIgvtga7mwG3PN?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(366013)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?b7ILi4Jla8NshrLWiJ1S/M0xglmZylJ8b28UeV9gOmQKuRz8bpn9G0tX6NB0?=
 =?us-ascii?Q?a0Ok7+GYIESla43k+JiWWDTGscgtoECMluJn9qehg436z6+Mc4vCqk+iz1yB?=
 =?us-ascii?Q?H7ACIClW1nkP8Ka31v6H+NsZ3qYAIEXcw5YU3Q3p1STlywngPMhFTAWe9OiU?=
 =?us-ascii?Q?dV47r6Uc/Hv6auzZSfmhbGJ9WHOFSduVEcHsn4q5C7Sanq1BNLiQvNV5CkiM?=
 =?us-ascii?Q?b4PyU2TflaeNrkSWlQVbmp3gcZw9Pc7+nJ9642NUbftLtXOkaGgCH4KCSQAB?=
 =?us-ascii?Q?cyG/3LehGCqHS1In0ewnhZ6qPvawAsp7ZCUDj+QboIJSS5WwgO9KD38+Hw+4?=
 =?us-ascii?Q?j/1ChB7U4nmI1ZPd+lE5b8s5SxTW8Uur89QoeVdYAkDco0X5hZbxe3bBcLWq?=
 =?us-ascii?Q?9LoD9RwM35D23OUP5Zu0otcp9rWIUh70+6nM8I7ptmV4oozXdFsUoRxHkoUN?=
 =?us-ascii?Q?gjf4ylIjWiFiYUrO9Dwt0Y4n/0IOBX9uqXdSDqCkUoajpQOA9n8lTcHEgX0w?=
 =?us-ascii?Q?AGkAVIOdVrvZpqfAk4mpbGjOfvgHtuXBqnkuClmnnaUzZ+be2g+gjsVT7Fys?=
 =?us-ascii?Q?om2Yqi+/frQhH2m0t452WYlBZCel0n71fcoELwJHQPN/HDQgk3jhs2I4hlU1?=
 =?us-ascii?Q?bqXY4vt4EflQClU8XAjHLWLl/owsBsVaIk9QFnqg3oWA2y+/QRhRomSWVzam?=
 =?us-ascii?Q?GskP9cusiYQUzC/uQBaYIXW+xuwQ872cImWlwq1RuqUH+Ylk+CzQshR7RS4o?=
 =?us-ascii?Q?XgtX883TIC+ZgASOMHyWxCzi0De0Silc+cME4LBbTF/iKUAnfMr8gExFJJv6?=
 =?us-ascii?Q?urLzSVlZo2JLCcxx6ISSeLyasn+Crz0zrlf5AG7BrUvlsFBW1ZXL94in3RAq?=
 =?us-ascii?Q?eUzirn3DNzE7DxX89GH2xryDgoCi8mlPQ4GK64Nfzr+DLYNFcOP+b/w79avD?=
 =?us-ascii?Q?9sVSrPEfVO2mtmoRUnieoMhQ4WE9lVs+QClwlNottMOpXLWTsovMvBcyjw4p?=
 =?us-ascii?Q?UovaI9Z2GjCv36+DEaFLZr9+rUYd8O83O6dq7lt+VKVUYzxFXwMIAzzH8q2h?=
 =?us-ascii?Q?N+kFyrlGXho8mI4csGsjzfgne7DKWVIG9Plc3l6ylrzqfiHwUc+C3N3fClNz?=
 =?us-ascii?Q?WvmvFmiEU+0gbSqfQUNBDBGGmDBGiaNPJisgqjVVy97IFNCeusyd9Y9YaOiv?=
 =?us-ascii?Q?EthviGe1jmfn6b6kYPUT538JA4NpbVr43oF0EoJ9Dograto2xcK80G7aVomB?=
 =?us-ascii?Q?M4k1kdyNBZdOdbxwW61tVHdu0zRUBWN3EBVeyVgNaGULuF/ASJuTY3oVUdbD?=
 =?us-ascii?Q?P9nVhMPWjECkFsqT6C/UtRPwoq9x3xaoFbMxFG51UCnIAPKdJ/PC3nwLTQjG?=
 =?us-ascii?Q?DKZH7tj45x/8xUiQSLMVKIvIJ/KCZ5Ik/yZj6VcpZ0ExHdYqaYlgBXuDWpWr?=
 =?us-ascii?Q?c4bxi/Jia3UTB4zxGTL/8sO42vousjJFVB3BzHkUwVfD0Y4v5Kd95Az4BjeI?=
 =?us-ascii?Q?/smfiMde1IGgHnk8eT0LVrl/c/FINIuoQHb1zAzDd9H4N5A7zgCpk7tMm59u?=
 =?us-ascii?Q?tHdVpafSaf0/xly2hWLYxO6boyPtXATX6wYulFDO5jzlmOotS3/csTc52SSp?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7juKy2MOlKK54iosUeXuv87VOvZteMb5wAiFaK7xHf5K7jD+XBrEQPGdsLbqvsbpOPJkvw3Ka4/bFM60KItel3201H7xWOd2Oc8gXzj2QPh37owMN1Ie1zdy65uGbHA45xcbEa6JsAXY5xSrBc5eDcUfMABbnS4Y0ziYsUzFJ3vHvMxCwiz2OdeNaEjoXxLaDfWZD4SkGuHeAZDhYemhCDxXsKSu3o5aS6Q8vbxIvJHNmcTF7/ys7uAoRUKwZ7z/XXybr4+4FlFHUSsLMicurea+KqExoEXycD/ihIOFHzC9gtXFxr3tRqXNjZST4kCm5ypqFIxvkqfVwl11tQAon4cAoUIJEUGgNBObqsPouWBDU3jmwiZvs6unAS7yccpAevEceBKpTfb+fkgiwPRd6gjXq8oM3OlwL7hv+3xSnZD0G0pqbwF+Cqs4lw4Kdua7SoMJxeUrG2WjCploOE5EAAfHJt78D6BHLrNy7+HzniLy4/QC8PteaWyuBpC46sna1l82LsE1joUtXV9WvKqF4Dq6iGfpy95R6ff4KvexXhtG5LxX2TIgd/0t9vyxNaXUm7oxJbEcWk3LKd0ecFAb5YcNw1RCSnU1Q225TArVClw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 658ee3fc-844e-4f61-b961-08dc94b48ffe
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 01:17:21.2071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EwPn2xl2TUzOGUljeQxoHABMLvqnhRMdhZEMtuNAkK5C1Kq6Jpeajqu34JqZvcaq3T0RKllVgKFyLjlfP1RfbZZ0i9OwwFLyong4w33lxWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7801
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-24_22,2024-06-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406250008
X-Proofpoint-GUID: FnvIn4A2dV-F44J6q43uSiopuB4Z9ZKk
X-Proofpoint-ORIG-GUID: FnvIn4A2dV-F44J6q43uSiopuB4Z9ZKk


Sudeep Holla <sudeep.holla@arm.com> writes:

> On Fri, Jun 21, 2024 at 04:59:22PM -0700, Ankur Arora wrote:
>>
>> Sudeep Holla <sudeep.holla@arm.com> writes:
>>
>> > On Tue, Apr 30, 2024 at 11:37:29AM -0700, Ankur Arora wrote:
>> >> Add architectural support for the cpuidle-haltpoll driver by defining
>> >> arch_haltpoll_*(). Also select ARCH_HAS_OPTIMIZED_POLL since we have
>> >> an optimized polling mechanism via smp_cond_load*().
>> >>
>> >> Add the configuration option, ARCH_CPUIDLE_HALTPOLL to allow
>> >> cpuidle-haltpoll to be selected.
>> >>
>> >> Note that we limit cpuidle-haltpoll support to when the event-stream is
>> >> available. This is necessary because polling via smp_cond_load_relaxed()
>> >> uses WFE to wait for a store which might not happen for an prolonged
>> >> period of time. So, ensure the event-stream is around to provide a
>> >> terminating condition.
>> >>
>> >
>> > Currently the event stream is configured 10kHz(1 signal per 100uS IIRC).
>> > But the information in the cpuidle states for exit latency and residency
>> > is set to 0(as per drivers/cpuidle/poll_state.c). Will this not cause any
>> > performance issues ?
>>
>> No I don't think there's any performance issue.
>>
>
> Thanks for the confirmation, that was my assumption as well.
>
>> When the core is waiting in WFE for &thread_info->flags to
>> change, and set_nr_if_polling() happens, the CPU will come out
>> of the wait quickly.
>> So, the exit latency, residency can be reasonably set to 0.
>>
>
> Sure
>
>> If, however, there is no store to &thread_info->flags, then the event
>> stream is what would cause us to come out of the WFE and check if
>> the poll timeout has been exceeded.
>> In that case, there was no work to be done, so there was nothing
>> to wake up from.
>>
>
> This is exactly what I was referring when I asked about performance, but
> it looks like it is not a concern for the reason specified about.
>
>> So, in either circumstance there's no performance loss.
>>
>> However, when we are polling under the haltpoll governor, this might
>> mean that we spend more time polling than determined based on the
>> guest_halt_poll_ns. But, that would only happen in the last polling
>> iteration.
>>
>> So, I'd say, at worst no performance loss. But, we would sometimes
>> poll for longer than necessary before exiting to the host.
>>
>
> Does it make sense to add some comment that implies briefly what we
> have discussed here ? Mainly why 0 exit and target residency values
> are fine and how worst case WFE wakeup doesn't impact the performance.

Yeah let me thresh out the commit message for this patch a bit more.

Thanks for the review!

--
ankur


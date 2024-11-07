Return-Path: <kvm+bounces-31094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CACC9C022B
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 11:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF80BB236F9
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FCB1EF0B7;
	Thu,  7 Nov 2024 10:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l5oV/OXJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nsRM8FUo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B291EABB4
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 10:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730974920; cv=fail; b=cTwNzw9GfTFy3FP5dhN+yMu7EzT5D4FwK3MIHfu9ALUiNl9XXbufYSH9JexbnEqrinVzPSfON4T+ZU6/QTIFNqpqF1OfN5bB2g9UzDPilW1tbSNneuw7R0+3nV17Xl3TskDs74yGpESyQHx5arVQWkZucCLMn51M880Vjet3iJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730974920; c=relaxed/simple;
	bh=zT8GJn4JaHKxaE1uGuUc5HhJ4rLRM4QLwLqtTFGb8Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RDZ+prwgpXjoFSLyQd5Bypl+IFDGngLq9QPIXSNSOvhpgWrYQ71q0QFuGsRMu5BvjXV/RVkyOoCyxtELFdl4bIYSJwsvZjuKGer3EEulNqsH932JFCTyskYm0DNrnp3OCSCProDfPimm7P5UZctfrT+rMCDsaXAkom2GoVTdCXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l5oV/OXJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nsRM8FUo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A71fdCE031344;
	Thu, 7 Nov 2024 10:21:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=hozTV9COxoNCUrCZJhE/lLeMUbGO/UzlrugUmhEA71g=; b=
	l5oV/OXJYkv4j+ajiBk21YQghWsuFOC2pWkqpTl8bD6n+W+gtY8G0T3I5i2eMhq5
	WLTeYebdHZCZsRhP/SMZGiJgL4x4Oy19sQEfsXbsAIHXTqI7L8oOnKak690z9Zqi
	MeLfxWxiMKhRFCX7K6g9A8HI3fWlbHfM1PXmY5wjywe44M1GvZEWGOJFksYLJu77
	9c1ZLmuBmBX2IFQ0P/b/omW9Uz3tDRef6L6CZfl/dj1yXgHdgVRNd4rMtb78qsP7
	vuo3urGnM+jRzYONjv8mWL+I7Q/n8GxNtnVuk6TvPVZ+AQLdvdCePcGycxJjzB/Q
	GwW2UqaTY4sOseYAW/v5Og==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nb0cj53e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 10:21:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A79USdX005116;
	Thu, 7 Nov 2024 10:21:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42p87d7d9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 10:21:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lCd0vogZqHkGgAxrkxzbg2mhcf5Svv9egw8QqAAGAELggUkMtRLgTjJ7/hyNZpkLB8p345hOhsm4ckoEWtEmNJKpDInqUhHQPX/6uJztIdE32a0OCdZy6QmgnoRRAKSYW10JifQawKwYztfVrU7BCdG3zYchobqo2v3bymz+D46hONVxs814oxfXWKJ1jbFh2biByXcbKi/zEwvYCefu0hqKuJmvNYjt8s6sGmx6kWHBhKRHtHN0CAA2xvYZU4thGGJKnrHzAKZK9wCl3KkH3xEMs9W5H75DptbBONzPmdCGUzqALCuOpHs20AGkwsEKc6fQB/df7HpY8mbu/9dSvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hozTV9COxoNCUrCZJhE/lLeMUbGO/UzlrugUmhEA71g=;
 b=B3LP6EiJiPyuJE9vD1K5KLrSl28hq0IQ63EsG8/vr87Tp1FrhWasBxH1G0zrakCpXl5+hU2RE98TohcYPukQn1udLC7Sw+X86Z5F3BVzGtyP8ua7qdNZwL/1h9aHLctKL9p/rJp+k2m2tl7sIXIKUS2/TGbOxFCsSl7SJ7fKL8US8JBmHvfFkJvomzrFRQu7i37Q2iMGQpz+pObBkdqLyMLT/l3k/WNFXACpOhMUJLNVonbZx7N2vf0cJTglLoH0iHVmg0tV7PP0kpeUddA8b9QV9yr3HsvcTuxnN5Wq2nn7A7sEXDD8n/d5ch5dgN/7tstzsMHrnAq7Bm+U6FLz4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hozTV9COxoNCUrCZJhE/lLeMUbGO/UzlrugUmhEA71g=;
 b=nsRM8FUorZHcwGwDjQUDcKqRhlh0Gi61C9gyURLNMcMEPX2aH6jidyHXG6qZmVhvAR905L51S9rPo5IEKQ/1Sol6C4l6WtzWJu3PVkf+pEfCUcU8GCT1hm1kBb0dNrv9qJL3N3AIChPWx06DqxuqssPi6R4SglWzifdtWgMRr6Y=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM6PR10MB4187.namprd10.prod.outlook.com (2603:10b6:5:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 10:21:42 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%3]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 10:21:42 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v2 6/7] hostmem: Handle remapping of RAM
Date: Thu,  7 Nov 2024 10:21:25 +0000
Message-ID: <20241107102126.2183152-7-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241107102126.2183152-1-william.roche@oracle.com>
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::21) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM6PR10MB4187:EE_
X-MS-Office365-Filtering-Correlation-Id: f0d54f01-4cdf-41f9-972f-08dcff15f923
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7IMGTERChQ7JBe+khOeRG3RHI9ad+Z8u83e1bJPq8KOe0OgfoCSwGwXXkF2l?=
 =?us-ascii?Q?k+40X1DyAarb3GYjbvWX4YjrbZSYlAjstgNXD7wD3/jAOL8veMQ5NGR9Ct3u?=
 =?us-ascii?Q?ugDSYMq9qUv+nAYFKB0PdE7yt187U5LS4/QEm3Xd4PyNihoDNwz/vYIkAvg9?=
 =?us-ascii?Q?yI7WcVUEG1mlCKlxa4BVA/E43yBEfsWszUqSKoA22NOEEE3k3wLBV54AHXG8?=
 =?us-ascii?Q?tyfewlSoGMFqOuiilHMbn6y5W8LqcpKu8D33Ao/ewiJFZx7KpNAxlD3rEQlJ?=
 =?us-ascii?Q?+wTUghFx6kXQYiDyoZxqI2D8hfo9TVjOWr5u8gXByHqzhyToF0kci9RL1jDq?=
 =?us-ascii?Q?8REkk5IJI0vrhb1VBShRX5h62IGN3nOBSsWCNNUU09K1hmoqP7ZBgHhYp1U4?=
 =?us-ascii?Q?GSO0wkcrqz9FzjvZZyQSOKG+eTi9JlI/fSZflkG26oEkbdxR+hDOGBe+08lg?=
 =?us-ascii?Q?xTH79aQ33N9Xp4NVCkdU9I9A/NUKODLAsq027wRm33W7/HH25V7Z8UD4hcHX?=
 =?us-ascii?Q?CAFWYosLwSmCcTjpEdYQMVhWXZxjy3qAo6Zd0zAWQTrV+4szC0YPf4sAelVr?=
 =?us-ascii?Q?ZhtgVXltL1Z8FqG5H20m/Gnrt++L1N9OE8/+vJ4wV5IDsKpzyJ/TkYAAaOpm?=
 =?us-ascii?Q?dDFLNeq84d9YdazhHUwspVRwcpbhEdfRPas/CLHlSJXsRXOUi+OMdJ2Ntt6h?=
 =?us-ascii?Q?ltegFgBUTrRoCL92VfEhXfNJfU0uQoiGbYuQCDO0sgF3Lkvt9+pkp0trvkbd?=
 =?us-ascii?Q?JZCY9KqKcw3Jfmu4IrxZ6t+Nngs6OCFPNXEXsjM5MBC5VirDv/fhkEK9WZBj?=
 =?us-ascii?Q?/tP8f5wNGR3FUcTH2MQ9texjdHmSb7RW3BKB1EQ646UjuY15Mkkj6yahlGnH?=
 =?us-ascii?Q?ZOJ9ihsIrbjERZyNsDLjD4KObxwiQCpb0+U98I/ru+BQHHCMRVeScX6LDsAy?=
 =?us-ascii?Q?OBQKemzb7oF05b16hG/Z9OlNMcREKYTKRsQmZmvSSKbXVrudwgb3K2WQtgvD?=
 =?us-ascii?Q?4aSpnYKP9CW/j9CYaqrvuMzf3RaibUM/rVMMelG3I81c2IgtcYNoK0DwoCJU?=
 =?us-ascii?Q?q4TBJG8MSliG5AEF9Beou1S1rbW7GUZ3v/3jjRyHo3cbTcSQZ52eUeBo06b8?=
 =?us-ascii?Q?l++N852VKyg3vqsohtK/yU0L61wSGZcVpT4P+4SB5z0YiWKYuz2Z2kxalJZ4?=
 =?us-ascii?Q?yL7n9HvbZsFc3Q6hpqoD9yXcwWi1kidU9xx4YyE3odiu/i3+So4ITjvIA3yS?=
 =?us-ascii?Q?OEfdntJG28MTqZDByWa070mVd/6MR1y+zsNMQqamiUA9qZorYd4faO3KaL3w?=
 =?us-ascii?Q?R32k/8NuptM2PB1SX+wQVOHH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FblwEaBH5J1EvFEM8HlokfBYCnTG8wiVlC3DpFpq21aJPYXfXAhgwjpqpZQH?=
 =?us-ascii?Q?sqIrAmpMuCkdQMUbxYJtTRefwvAJkeZ3f+CWMBRkSXMOrXEpFvQb4+k6K+fF?=
 =?us-ascii?Q?EL1F9evKCJAuHl4LgWWjWWt7f+JzxRTbX1fHsKh639IJZnpiNFyCWYSTptUf?=
 =?us-ascii?Q?Fd+D+iUPXzNk/JRJlYxnJXrnuiJKb5vj9sMAAuWo2P8BNst9vjsQ+BFH7Jje?=
 =?us-ascii?Q?m1aZc1T12iyeZzPivugEAeUXqGMPjvhMEkOk9vq68mYki7wsWbG8kYHt4t+R?=
 =?us-ascii?Q?dYeCHK2DLs9Qcrp4OQUsQCCamIl+1e5eiy43q451fnuE7pz0nW4bBn3ob5cS?=
 =?us-ascii?Q?FL+SAFv8GOPQ4phQgMA1UPfbPadIFzIRsKyZkA6+5rusj8doqYy3SLP+YzJz?=
 =?us-ascii?Q?mbb0TuG7E9VuokrkL93XyIXdVKttehbQFGJbtcGCxE9QHv+6/SgYjS3NK3F2?=
 =?us-ascii?Q?5vVbMonaoM+a71LOIWjfpY9nmJ6+fYMpC50AWJWzRyOP4eWgvKKPoQpN8cQc?=
 =?us-ascii?Q?hQb1McTNWagaVwZtDoVwiSgqLsOiX7K2o9aY2YhJnZUvnYrW9VX47u46IFzN?=
 =?us-ascii?Q?kQHHeIixtSrsC4zx0bS8v/NXWwUUC01ECZqv6ACrBzdU6QaPIYv7q7L9sYpg?=
 =?us-ascii?Q?SFWaZ1CV3PQb5pey8rdUqBa152PbF8RRAOz/PKqKQRSfO4SArBIAnC6AIl3n?=
 =?us-ascii?Q?AWn3DXzoeu2Uph7tkCTL6ihlDAJ+wWWRyuzyEJJKSd97P7H6d6uX9VO8U+9k?=
 =?us-ascii?Q?flkAHvINUxCMZoCxC6jLn/VEV2g06qL4k+E+JsA8J4SqVtDWqRsuJSR3njAK?=
 =?us-ascii?Q?AOFdDCK7FGH8aeHcikkUx8QdFAPTfOahw/aNNM66A2u4phL/y8Sgl5TvsFsz?=
 =?us-ascii?Q?o1+vuKbdFCsRVl8bCblMv3GGzuXCpXE7fAtz0AD6cLqbblV4SN4IWXxqFTij?=
 =?us-ascii?Q?U7dFqIgI+Wz+LJZMOkVr8+i2go45Vdrpp/fxq/p1IyaHMgFHvScMhTgfonPh?=
 =?us-ascii?Q?q8UacsS5vDbORWJtqUPXdkpHrbJ7nmqQb4LFs7Xz1wuxwqrkKfv573ZdUuID?=
 =?us-ascii?Q?P3rN4FKgWmf4emu9UdZIvdlsAsTVIZqmjWyBSk8nbNPtAjTlStt77QNFk2tk?=
 =?us-ascii?Q?wqzJ0F1fe6Ep+UXI6Z96HIAYFnuUtP+Pw+rtVjGUKZ9gzdHVsTAy08mXveou?=
 =?us-ascii?Q?GwfFlzJFefQ+7JbdSqATt8MDaQmtr6lSqHz0RG9fr96CR+WgsbkbG4v3+Y5A?=
 =?us-ascii?Q?LNk1qgd8VIQYGVVbZ8qRFGCWyJYuBWSNyq3NaDsG//LXFykmSuu/Ls5CiHdX?=
 =?us-ascii?Q?R8Vd6UXtXBraDzt9jCK+Nv8fwlVmD3IaJ4ZHdVvSDFFXus4e7+BIrQf2ZCVr?=
 =?us-ascii?Q?gHU4liaqNbVHxQVva52nv6SCc7xZvRWkeA30/mQhVzR+ohj9mNzAMCPSa4UJ?=
 =?us-ascii?Q?LkvyYu1ggDtCWyyB7z3J/I4lUOuCfKOCiP8sWhmS/rcSQvBNrF3hCELZIXqm?=
 =?us-ascii?Q?KbWeqpf1ehqXo1RbN7IJkiCxwaG3L3VQAmJM12JXN0Ae4tmE1QbX77vEIk11?=
 =?us-ascii?Q?rSI4PjXN5p32HcOoTmE8qsLO46Qf0bI8qZxNt2g9DPbYHQLipy7dA40R328v?=
 =?us-ascii?Q?Ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C3aP35jgiyrF9KcOPTMg8cFiN5uzLuGfUtnDz4VJ0z/FLzT91zZiOeoLmzDK2m6iMMFlNY5CCC4SEZNtXJPd/2XT62CPXkzgcrvJKU0D2rGaJD6nvs4RU80BUZsUn8DhPwkYxiPkiyeIwSV2zjbKfomxDgew9+sgQKkKFLPN5Fj/gpyqrt5QnseSPSQDR+7lr6Ks26xseixaATXaAFjlp8tEMT5FOhIShv/tyF9bwdEKHEG3IizNaKu62E1PfMq/yr6AEDPE22eBk8/q6qqjPEAx2Gtpv8ZjEwZUMC1bSmUlz41XdQXVzo4ptL5CG+6sorN9OpL+2HBOrUdrKa+d3OpsZ5naV86XGyH2IImoqaNmma9bMZQt8H0KKtkdeiF4+wkplbnTPSPSPNzcCz+ceM1+XO1c6n+lWgdznBrrndK/I/mA9UM2pFhBY/Vn129kFOJ0e1LMIClkAY6rHm/nDbuthv2d82sB4QyRvup/OXDO6qMDPKpf6kYayn9rrLBOrbbkctIH2q3u2NvFKbt0+vm7yvAQSu1nDjYdHwAzTfcmE4UhE7toDqzPf0mrJ4yu6K11cxCW6rb/WbuY2ZDA8m6u+Gvh6pMhvlG7PUbV8r8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0d54f01-4cdf-41f9-972f-08dcff15f923
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 10:21:42.0986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l7tREJNSSbNqT3IXpD6HI3RWgPj+bgNaIDackkqpBm9tWMtEf7rvC/nTdDVv3bI+I/3/ffVoobvk8DgziKd98gmmCBYBdVgpqRx3T3NVYJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-07_01,2024-11-06_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411070079
X-Proofpoint-ORIG-GUID: pdA19SCm8rsDwT1KazcqKeVoGyJiB7ki
X-Proofpoint-GUID: pdA19SCm8rsDwT1KazcqKeVoGyJiB7ki

From: David Hildenbrand <david@redhat.com>

Let's register a RAM block notifier and react on remap notifications.
Simply re-apply the settings. Warn only when something goes wrong.

Note: qemu_ram_remap() will not remap when RAM_PREALLOC is set. Could be
that hostmem is still missing to update that flag ...

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 backends/hostmem.c       | 29 +++++++++++++++++++++++++++++
 include/sysemu/hostmem.h |  1 +
 2 files changed, 30 insertions(+)

diff --git a/backends/hostmem.c b/backends/hostmem.c
index bf85d716e5..fbd8708664 100644
--- a/backends/hostmem.c
+++ b/backends/hostmem.c
@@ -361,11 +361,32 @@ static void host_memory_backend_set_prealloc_threads(Object *obj, Visitor *v,
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
+        warn_report_err(err);
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
@@ -379,6 +400,13 @@ static void host_memory_backend_post_init(Object *obj)
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
@@ -595,6 +623,7 @@ static const TypeInfo host_memory_backend_info = {
     .instance_size = sizeof(HostMemoryBackend),
     .instance_init = host_memory_backend_init,
     .instance_post_init = host_memory_backend_post_init,
+    .instance_finalize = host_memory_backend_finalize,
     .interfaces = (InterfaceInfo[]) {
         { TYPE_USER_CREATABLE },
         { }
diff --git a/include/sysemu/hostmem.h b/include/sysemu/hostmem.h
index de47ae59e4..062a68c8fc 100644
--- a/include/sysemu/hostmem.h
+++ b/include/sysemu/hostmem.h
@@ -81,6 +81,7 @@ struct HostMemoryBackend {
     HostMemPolicy policy;
 
     MemoryRegion mr;
+    RAMBlockNotifier ram_notifier;
 };
 
 bool host_memory_backend_mr_inited(HostMemoryBackend *backend);
-- 
2.43.5



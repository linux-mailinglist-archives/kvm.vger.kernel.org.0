Return-Path: <kvm+bounces-29179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93DB19A4669
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 21:02:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC1971C23676
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 19:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119CD2038BD;
	Fri, 18 Oct 2024 19:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZH5KxJs6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Qdu8a6YB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F9C15E8B;
	Fri, 18 Oct 2024 19:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729278109; cv=fail; b=In1eMXrTPuhnWvcS1y4QTxi2+RhNtp0d98cHilTi9QgaQDQug4jigx83uz+4DHHNF9YejaDnQM2bTCM3yLSq4/BltTOMMIkESfKeu7LUdH1zQZpjjyYzw2EwkJOOveqNJm6KoWTOBq/tbrCZcdTkR05Nt1HI6ym+3cMoa6cBUpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729278109; c=relaxed/simple;
	bh=JZdlr9e6h4ljnF1zGT1Ig5NU2IPOTqedTN3A2jFhNXo=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=BVE3pnAuEPcGM63hQ8P0bGLo5u6/QpW1d6Y0ns9wFRw7lJBftE2CmtlNBohGLGNSgrT3ARB+p0N1mBcmQeFHhBtBtvoY93/Ny6M8EYNv9aKdtx8bHUrHZNeQdCM9dQFYuFNDkTyZIUEDc/OXhIzxcrJ2gvStcM8eYz+sYW/Kwg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZH5KxJs6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Qdu8a6YB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49IIflaw012641;
	Fri, 18 Oct 2024 19:00:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=UuCrlM1yY8RAqG4UZG
	Wv8+t9D1G8dAb4B3icm+Tdl6k=; b=ZH5KxJs6UYGzFcvc/bsJV4YOfRGBCyUFp/
	58w7O+/5s0F3tY2Pdr35ISu9sAqYIwxe6XSPYkxsgWDYQ/R7CB3Ce0pYLaNX/Row
	b1x1zHdukh3XuvfD63y+uFlIzN+5YpJvjTgcNcvv2jjv3+JeCpdFtoJ2GCyAHKSN
	ae7k3paWgaJ7vjV2EQZ30k1zRRGUqFSOG756JLS/HAwIULGNgVjYibyNMuh5FK5Q
	apVKTZ2cCwtfcD+vuHbpWrW0AQidWiKWgZBDJPH9sAfitDITIMt7EgB54dzNwz6L
	HBAHc76xeSoeEfpctFH/XddwUGe+AHr6IvnOwDi4DRE4ogjPTcYA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427hnthgns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Oct 2024 19:00:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49IIRG18038497;
	Fri, 18 Oct 2024 19:00:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjjhb33-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Oct 2024 19:00:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BnKGc/O+0tZE7GD72XcOMcgjmJxPPI91iGyV+2gWyqvz9wLoIZElmJJY6M4gFRG+C3WdTWOe9MxeHynfhaOSvW4mYS7+zDmF6jNeOkRMMeo2XyGriBA497pQlEGXYJVjQ52CieUsJFiIXT1ww5wlGEwkyJaY06C1+3YEp42tztMlhjwpPu9ddXwQtHXyAU3UfFfltfQqLE2F5yqgM9RlKl2bXL5GkWyuIepOAm1GIhxyBSB98ctBMuRr7/0KcQNB11IrXqVNFeu2XSg1K81LvuwqGA0zVfIQvAKthNLgVgKIkZDFBU6m1p6TUBWmKv3TmU7GEC2P+JbGl+yMX6I1wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UuCrlM1yY8RAqG4UZGWv8+t9D1G8dAb4B3icm+Tdl6k=;
 b=sPIDiqsrWN1vB8r/ejTm9l40bDD/GzwrV8sgvZuy3bgOpTzU+xUh+2/BN/0Gw2ybxGmgf7PPgmmUTJBTw3dqD1PMDVVvPYZ++lu2K68JYr3QeQCYgvQRVFIt+f/Q3fcef3ECsHjoeyNw4q1PrG6K3g8b7aq7Zhc1Ct1WEo43NBdj/BN/5QMR7rivqxLtlWtXWul0LACeZ4ufBrXTX/6+CN3hhMJHlF8jiJgOx/naVFBjs611J9PLBtPR7ZUePLzIuu9TABXCCZZ76JGspJqtxwogi/lKQoSlRcZCn3rPzwS/nxFP0Snxim5JIKBSE5u9YhFRsyIs2rhfD2o8SkDreQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UuCrlM1yY8RAqG4UZGWv8+t9D1G8dAb4B3icm+Tdl6k=;
 b=Qdu8a6YBO8N9P7NAMo2dAgMZlwUYNsHVyK/zV4+5iOlq+xJAFu6kFdqAhD0hgR9gNCa/PI25TT3LEgMAdW5VWo7LzAQkq2bhJCy8PS9uFTnfec/FAAspl+Eoofnzj2xkogGxIXQJ6NyLvjrHykZFeB6Yf/j66KEystBGSNVHU+k=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA0PR10MB7668.namprd10.prod.outlook.com (2603:10b6:208:492::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.20; Fri, 18 Oct
 2024 19:00:35 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8069.024; Fri, 18 Oct 2024
 19:00:35 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <7f7ffdcdb79eee0e8a545f544120495477832cd5.camel@amazon.com>
 <ZxEYy9baciwdLnqh@arm.com> <87h69amjng.fsf@oracle.com>
 <ZxJBAubok8pc5ek7@arm.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>,
        "Okanovic, Haris"
 <harisokn@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "sudeep.holla@arm.com"
 <sudeep.holla@arm.com>,
        "joao.m.martins@oracle.com"
 <joao.m.martins@oracle.com>,
        "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>,
        "konrad.wilk@oracle.com"
 <konrad.wilk@oracle.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "cl@gentwo.org" <cl@gentwo.org>,
        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "maobibo@loongson.cn" <maobibo@loongson.cn>,
        "pbonzini@redhat.com"
 <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "arnd@arndb.de"
 <arnd@arndb.de>, "lenb@kernel.org" <lenb@kernel.org>,
        "will@kernel.org"
 <will@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org"
 <peterz@infradead.org>,
        "boris.ostrovsky@oracle.com"
 <boris.ostrovsky@oracle.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org"
 <linux-pm@vger.kernel.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "x86@kernel.org"
 <x86@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-reply-to: <ZxJBAubok8pc5ek7@arm.com>
Date: Fri, 18 Oct 2024 12:00:34 -0700
Message-ID: <87jze5kzhp.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW3PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:303:2b::24) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA0PR10MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: a9beaa4a-a723-4864-625d-08dcefa725a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fXKxTHnvLLARQEimkjpf4Dj4k0AyIHKAxXyP4IoDewuGXWBv+iG2PQ5mW6We?=
 =?us-ascii?Q?7rApx1NUFBeeAFdMSsRVHqNVCjqrbMQk5EStx9BH9FM8ld6HNMtq0W9khWoQ?=
 =?us-ascii?Q?g7JjZSHgLPbXruuAewclc1oE/NONYGcaD6+3wDK+QMgciaU1UHvo48w6Evrp?=
 =?us-ascii?Q?7DpEfCRACrZfpE3ld6HWSJz6VB0HZ8fIgPYqfLyjBDlPso2UFznrHPjbpgHg?=
 =?us-ascii?Q?LsQKYqoasXzxFGvPbPPl4FNjVav4yygrCT5LR5VQ2NLARNzQesWE9j738loT?=
 =?us-ascii?Q?K6nLtHcMCBJw2pz57oLbx49AbEDizqbNhf7l6399S97mEo365qCQDVvCir4l?=
 =?us-ascii?Q?jQI8SisF6tsBsNROmu3ro2gOqXXgVozpQHjq6DlgrVbBg4LgEVNsO3x64Jkw?=
 =?us-ascii?Q?JlgBGmmBlmN+PUsPjJGUB2+qRGln+ouNs5MiCGrKdG/GWVIGPy1Kap6ZmcBu?=
 =?us-ascii?Q?sFZlHJGgfAorOkSTIPKxOybe8ZR+qIGiPel8HaQDSRZeVmk0Sg5F6w8FA64t?=
 =?us-ascii?Q?yOoVd8GpA+ve0MIoi5OWp2FITJXw6x/a9PFL76rkfHuujYyKZN2IYUA2QBoe?=
 =?us-ascii?Q?MYOn7CHBmnfe2iPVu1VAR3Ns98rZBhrCta8kBYNIt1aXrr2Lud7TsycjXWeA?=
 =?us-ascii?Q?cGFqlQkTuZf6Zbb1UuQSXA0JXfdYodsAZh27PnMvLsw6cP9p2KUczDl5Q66V?=
 =?us-ascii?Q?hoLjBK+jUdS5BMrG3wlaVYXvx8ubn57esl5AaEMNGyfuv7B5IPMikTKExBk+?=
 =?us-ascii?Q?19enHDdnDAyj5P3ixLeZQRMmdm/KMX/clJORJzuwYpWDu+WosCWGeSLtxs9K?=
 =?us-ascii?Q?Na1GJ/VVV8zTGpINEAompB6+gJNU0VsygrhT7mFrboiMr6KcMxr5h4Rmq5ZI?=
 =?us-ascii?Q?9AWQYx9DCi9SiSYEB9a+sN5IyVjvvubNl/XpmX8+P4VHcuMxh0RRer6Ry4Vw?=
 =?us-ascii?Q?PVFeje9Ckh6atu9f5Q6uXtIy/O5qFLx7TN9rIb5bgBmv6JAGJYwkGwJhEB3u?=
 =?us-ascii?Q?vpOI5GkN7RdGagPoAVhkByZUPO0gSxJPp2ybGwBPYfQUHbm4S7s58HaQOEuR?=
 =?us-ascii?Q?lv9l7NLPVJPiVFwaRvDcx9/RMPgeZoKt0nXZ2Ij0XBejCsHSwmXGUcrokrYe?=
 =?us-ascii?Q?t00YkuUjmRHNCbTXBZ11oNGnJviLh9/t7dlsOfr0gBuuFAo7jP67X3E1bwzO?=
 =?us-ascii?Q?bpnG//HxncLON57Y9h656JF+r1uaMhuMmtHvdJtQWXI/KChtZpKNXwuf36K/?=
 =?us-ascii?Q?QgJ5NGFFcxpRX67ueztbcSCoVNLhZGNBD83abc/xGuYEDddrqoYSH0OMIOSC?=
 =?us-ascii?Q?eNFWBJ9KzFr2O9yJn9uLd7ui?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w9smRsUMXdIeAOJ9G1CBMk38f/4jJXI5RZyC8qt7vNRtJfXx0Mlwz3fIielS?=
 =?us-ascii?Q?rUMFw9cxO/cqmRqhHXq9IL9QAo+HT90BHftsNmPsPYhMXtL+Sfl0fdS7ylPV?=
 =?us-ascii?Q?rMqWJ+ImEkig7Ym17pgPdviBq9bTA2isUe9C0mFgS1qqMEZTFxcCDIGkPnCK?=
 =?us-ascii?Q?82mcDOLEegdRGc8XHMB+ukLm4LxBh7zBxb+zYIc4NpXCpF0slZMLjy7KaFFR?=
 =?us-ascii?Q?9uOyiS3GVkYT+qSVlT3kAiQUmVDifqhPqX+uVJZqDSHSLK+rK3Ld3iPoamUC?=
 =?us-ascii?Q?HRd7iFxwf3Yh4eFi4lUjM/OBKx8GOsJPZ8ASTqRLB7mTGroAagNzmY6MmXGU?=
 =?us-ascii?Q?/FsukyxhDGN4fSlCBt1OLrFBp7Kt5GHnXisRhcBVl8la47hw59dK52sj6zRy?=
 =?us-ascii?Q?XjU+o3FMpHZmzR6uFs69WzUu+y1RbMLiZ3bYEXgCuz6C0SfWiM75sMhfO4DE?=
 =?us-ascii?Q?PJtjkAUtUdF0+YJmdLvHjH/QElC89s3e3kbszPTHxaHRalyZNCLyiyGRISTB?=
 =?us-ascii?Q?t1uISVTbhAez/7W0CU3JBpmFpRtXinNm8byOB5ooboxKbNvNXDwb4Kghuv8k?=
 =?us-ascii?Q?9PF52AzwqTK/H/9V5gSdZ4XOcrWVkJOW7xm8zSQFnw7E4NaIVELEu++fBcT4?=
 =?us-ascii?Q?Mhln/XPsKBDe03Wcsv0ot1huotiUiwT8oQTDZnnRySOlnOeBC6g3AJKQjVmz?=
 =?us-ascii?Q?3raRzoamchJN6qsgVG/xebIODu63M5rvtRpSHYh1+mjvcuAWncABlOw3AgW2?=
 =?us-ascii?Q?KLzRCKhA/3qOAk6mX7u77c+rW+aYjA/lrNG6VezDBQbU6bEefWCVBqwdlUnn?=
 =?us-ascii?Q?u7Rgv3qXEgojJhbsg1MbMZQ9A4qBTdNZ4zEUfHI+9BLbWmhDresaiVtV3EDH?=
 =?us-ascii?Q?UDmXYrlqVO9dS6Gx5E4ToQH8M5cyVhygL4bxBfPYJ6iW61o739S8pTzL0ZW8?=
 =?us-ascii?Q?wF+9XRWCDmt/FiCMxiE/IacHwoUqSO8QHylkRUk1nSZwRLABVvikNX06SncJ?=
 =?us-ascii?Q?F8HL48/RVn+Nsf8Kcibq0Df3XvWaJK0CfjApBkwQG3PBMe0NGO4y9TeZXzmJ?=
 =?us-ascii?Q?M8LG/fs+EU+DGtJhNTBkZJm7nF078ByHx/+fzX+WLAfsPLKvEvyg3DwTmUv2?=
 =?us-ascii?Q?F9lOXAC08oMRjaXI6It3ELnRQW9LNofroQqrJRsa8va3gctMbXkuUnsvdFhm?=
 =?us-ascii?Q?19tjWm+/aViFi87wtOwpWeyEynX2m2XeEFpjZmMBS6djeVuETgpaNPHkxSNR?=
 =?us-ascii?Q?rGReZVjPNqf5Q0FaL3itvCyvkbDy2F+dv5t9sLNl4N5brrYW3fSktnpN6puw?=
 =?us-ascii?Q?/z7ukcPVMaJ3fsYVaxh4b1tXI0hcgaM3pNmmfFYEArrv6YQAizXhh/fgn432?=
 =?us-ascii?Q?4LKjVVDCsql2rwwfumGDRwfBCFo0yl6u3LrxYbKlyuGXO2TYzDP1uUixpAi/?=
 =?us-ascii?Q?TB4KIkuFciuxZvSQismR9A/Vp2zZYbsLuWNRxgVeahe6ii9c+Lkp1YNfORLz?=
 =?us-ascii?Q?83F/5tw5FryQs2ceZS7QAewPeDdeDj4WjDsT9doqDxU6u1XD+f5qlAtdxx50?=
 =?us-ascii?Q?BLZ2/N+hPjvHkbg1f8zNmWuwELiQxXBLvZC1MbWGkpI11xA1184lBmdmDb2l?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XcvK1BPognMIiwQ3iu98bYlTUSREIF9PUhf96B9ysEz7hpwXf8wTA10fKjESfeFiJEf+50AlB7Hr/9rjSNRembucQeWfc9cTbWyMbL358nBFGmANmMzk7rheySaGIE0tGsJH8orRAADamHmRwe1VfIZ+zH+4IPMahIqWsqAMp3e81Dz3NYQqlhMnfK4V/J22X6Bg3FG+bidozO4teZnpNSvwJH+p+vYNZH+Uq7gh4n2Vf7hMJTiXSDInrIFY23EnAIwG0oPGZ+wgGRvO+TH2qDrhU1nl9CBbxDgvg4g4lAt4iPAECoX3rYkN+At5vAp/V4xixvB5usZPQ1ui95iDCPcF6k+M55XHwcgJbOGFV4Uv6FvP9sRzgBkz3YXfSFKJuDhfYx8Sv3+25rKChmqqIoqPhr33H6487avi1Bc6fdSd2kcouMavuW1DGATdtIxOeoPyjbguMAzgCrgQan6keEmIl+OnplVpafdFXSanqO7sX1r1QOBEWEGqIVf2xmAbFJ7cRhT7+F1j7tq5F/F1ItKWeamKx5X1AwbAmMPchcpaLm1GCNGO4nHQDn4J1O532LdfHHmYWeNus9zQpl0xdRrVEwFSlTbCqgZhqjUHVeU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9beaa4a-a723-4864-625d-08dcefa725a1
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 19:00:35.1683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ozkDtz5upxKKhuvk1IAkcApqREDkR3gSnaAOf9tVsUO3Sq0Z1+CkogV6WYVuwa0W/kfNwGs1X9OTiW2OXuYwnA6SnoPCy02X4Qsex4bjQy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7668
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-18_14,2024-10-17_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=628 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410180120
X-Proofpoint-ORIG-GUID: YxOhVryjflXxJGajfexZqq1Goao94ep4
X-Proofpoint-GUID: YxOhVryjflXxJGajfexZqq1Goao94ep4


Catalin Marinas <catalin.marinas@arm.com> writes:

> On Thu, Oct 17, 2024 at 03:47:31PM -0700, Ankur Arora wrote:
>> Catalin Marinas <catalin.marinas@arm.com> writes:
>> > On Wed, Oct 16, 2024 at 03:13:33PM +0000, Okanovic, Haris wrote:
>> >> On Tue, 2024-10-15 at 13:04 +0100, Catalin Marinas wrote:
>> >> > On Wed, Sep 25, 2024 at 04:24:15PM -0700, Ankur Arora wrote:
>> >> > > +                     smp_cond_load_relaxed(&current_thread_info()->flags,
>> >> > > +                                           VAL & _TIF_NEED_RESCHED ||
>> >> > > +                                           loop_count++ >= POLL_IDLE_RELAX_COUNT);
>> >> >
>> >> > The above is not guaranteed to make progress if _TIF_NEED_RESCHED is
>> >> > never set. With the event stream enabled on arm64, the WFE will
>> >> > eventually be woken up, loop_count incremented and the condition would
>> >> > become true. However, the smp_cond_load_relaxed() semantics require that
>> >> > a different agent updates the variable being waited on, not the waiting
>> >> > CPU updating it itself. Also note that the event stream can be disabled
>> >> > on arm64 on the kernel command line.
>> >>
>> >> Alternately could we condition arch_haltpoll_want() on
>> >> arch_timer_evtstrm_available(), like v7?
>> >
>> > No. The problem is about the smp_cond_load_relaxed() semantics - it
>> > can't wait on a variable that's only updated in its exit condition. We
>> > need a new API for this, especially since we are changing generic code
>> > here (even it was arm64 code only, I'd still object to such
>> > smp_cond_load_*() constructs).
>>
>> Right. The problem is that smp_cond_load_relaxed() used in this context
>> depends on the event-stream side effect when the interface does not
>> encode those semantics anywhere.
>>
>> So, a smp_cond_load_timeout() like in [1] that continues to depend on
>> the event-stream is better because it explicitly accounts for the side
>> effect from the timeout.
>>
>> This would cover both the WFxT and the event-stream case.
>
> Indeed.
>
>> The part I'm a little less sure about is the case where WFxT and the
>> event-stream are absent.
>>
>> As you said earlier, for that case on arm64, we use either short
>> __delay() calls or spin in cpu_relax(), both of which are essentially
>> the same thing.

> Something derived from __delay(), not exactly this function. We can't
> use it directly as we also want it to wake up if an event is generated
> as a result of a memory write (like the current smp_cond_load().
>
>> Now on x86 cpu_relax() is quite optimal. The spec explicitly recommends
>> it and from my measurement a loop doing "while (!cond) cpu_relax()" gets
>> an IPC of something like 0.1 or similar.
>>
>> On my arm64 systems however the same loop gets an IPC of 2.  Now this
>> likely varies greatly but seems like it would run pretty hot some of
>> the time.
>
> For the cpu_relax() fall-back, it wouldn't be any worse than the current
> poll_idle() code, though I guess in this instance we'd not enable idle
> polling.
>
> I expect the event stream to be on in all production deployments. The
> reason we have a way to disable it is for testing. We've had hardware
> errata in the past where the event on spin_unlock doesn't cross the
> cluster boundary. We'd not notice because of the event stream.

Ah, interesting. Thanks, that helps.

>> So maybe the right thing to do would be to keep smp_cond_load_timeout()
>> but only allow polling if WFxT or event-stream is enabled. And enhance
>> cpuidle_poll_state_init() to fail if the above condition is not met.
>
> We could do this as well. Maybe hide this behind another function like
> arch_has_efficient_smp_cond_load_timeout() (well, some shorter name),
> checked somewhere in or on the path to cpuidle_poll_state_init(). Well,
> it might be simpler to do this in haltpoll_want(), backed by an
> arch_haltpoll_want() function.

Yeah, checking in arch_haltpoll_want() would mean that we can leave all
the cpuidle_poll_state_init() call sites unchanged.

However, I suspect that even acpi-idle on arm64 might end up using
poll_idle() (as this patch tries to do:
https://lore.kernel.org/lkml/f8a1f85b-c4bf-4c38-81bf-728f72a4f2fe@huawei.com/).

So, let me try doing it both ways to see which one is simpler.
Given that the event-stream can be assumed to be always-on it might just
be more straight-forward to fallback to cpu_relax() in that edge case.

> I assume we want poll_idle() to wake up as soon as a task becomes
> available. Otherwise we could have just used udelay() for some fraction
> of cpuidle_poll_time() instead of cpu_relax().

Yeah, agreed.

Thanks

--
ankur


Return-Path: <kvm+bounces-23892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77AAE94F9CA
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:44:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 309EF281AFC
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ADE2199246;
	Mon, 12 Aug 2024 22:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n+ZfY9TR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WjDQzy/X"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75B81991AF;
	Mon, 12 Aug 2024 22:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502664; cv=fail; b=Q+qgRmdR1PcnnCtjG+wnRlh/Hy6/xnXJkGccd4o6H3MxjLbDOQ0cx/OstXSjC0YZfU6TXjCOk7z587FR+AU5acUN9THofUHKQ/iARNLOP0b0NiuY9ufh3npBj+L97i03kn48Q0hMZ/hdqX4AtgSOWIuIX04jlEf/zzQ1B5+8dRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502664; c=relaxed/simple;
	bh=8zy/Fr+IIvoHigsJlcc9ihTebgXwCuYXRpteYZfFXk0=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=r2Zyv4GPZop1/2xzAujC1+kUY78aZQ7aEAjv5rZBNuxMwpK9xkgeq16EI39GMw/3VUNBDxvM0JYROa3BueTk5Cmb2eS1L2p5zoJz1f8hjANRTkZQAP0d2RefbCu/f0I4L+fQ1wOErhjNhJtWakGqOxbzS7+piPxmhfBHcJMG6Pk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n+ZfY9TR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WjDQzy/X; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7JEZ017262;
	Mon, 12 Aug 2024 22:43:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	references:from:to:cc:subject:in-reply-to:date:message-id
	:content-type:mime-version; s=corp-2023-11-20; bh=Flu2rjnjiuC2pk
	8QFQEJfl+FcsBzpdwIhBt4jxSk7qw=; b=n+ZfY9TR0gmTjRoCJxCNi2/a4EVF79
	oWGclaUsA9TlrDjW+DdPRHn5Uyi4F9IxT5ewCfBgeuiKSIoGxjR8e8Cr1xczg9O0
	j8g8B97OsTWkyFJ3qaBKpupUUC0rDkuldaA4jfkhkSq3IRF0YJlvHQ8DbG14xG9+
	KgXomkvu8CdNe/HAhqvKfJG+bD5v++IPOpBoijDuo4JFlUjyi77prRKEkrlFr5ex
	DF941bRuX2ZGUZNq9sb3WQXMHb++UEKA1omnPUOA7Ew1LuxujQZLI5p98yxXTlZn
	lOGbLOSL486Pldo1J6nbBkTtD/iKRKVTjAakIlrn95WT6VhNAWQG+INg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy4bcsjj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:43:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CKLJrx010854;
	Mon, 12 Aug 2024 22:43:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn7sh1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:43:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p9CEFXy8fhNopxkr2y6Dy+H+lIORI6ru/8I0nuyc2pEwQWnMIUFd7diTRCOFPb0Rx7xnR/8WZGLR2KXmcbDcjkdQNFHH/eFu4uGzWwDIWEoA4V1xoh+wjnYq2k+C/H/SAjF7tMDG41B9F6pUSvnDAFXgj9mzqLW2bJCDk++tW72TMpjzxFiS226Yzslo2gKE0781LC/RI4sMOj65EC6O2GsPW5UGiadb2TuG3vUNuPak1/0Oi3nWzvgQFBkDlv/OW22tCdF0xULcHFcjr0g0OCCAV6lnlmxEdNXg028sWY16FTHyYxfu3fwTn1bljFyDGstZXuT7VEuj6RioIxOecA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Flu2rjnjiuC2pk8QFQEJfl+FcsBzpdwIhBt4jxSk7qw=;
 b=JfWmexzy9bAUToMCJDkAAnPGDL1OVzZQ6pCd3QoRtxGMbRLcCdrNiIyEKJEzTsGMHO52z0JqcqJC78oBTFVBldlLrYuetIKPiog86hQCxT+Sy9+k1/AfB9CtB6iwmFZq/hlvNy7TIPVuB4Paa2oLfp5n/wCIvx2xoqtpEO0G5kmL0MwTaIkNAxB3QBsK9NCHORGB4ApzPI0Pf878rTQXAG7gmue50xZp28Ms6rqtxi21c0ckN/NvoA3SAMoMoM3ti2LWjo1ADiYejSq1tbxOqzuQvkxj4jsIUPrjZkJRzONeupPsd78wJe+vhpfyjNC6qooMWAQKVTar6wbjhpfXng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Flu2rjnjiuC2pk8QFQEJfl+FcsBzpdwIhBt4jxSk7qw=;
 b=WjDQzy/XkXwcJJomDS+sQSaVRluNYH6Vcl//2m/SSqcW/+h+i7XyBvdN4SfoccCV0xzyLrlCLMjWUIjeV35lnKSmGPgOUAeC5UNNTg14SfRy8W4FYf0LYkGa2Ap3wIwKE82PeDMVCwSpDOiAH7yTCHxXQbDkIoYOtpGmFtGnry8=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 DS7PR10MB4831.namprd10.prod.outlook.com (2603:10b6:5:3ab::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7875.15; Mon, 12 Aug 2024 22:43:38 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%4]) with mapi id 15.20.7875.012; Mon, 12 Aug 2024
 22:43:38 +0000
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <TY3PR01MB111481E9B0AF263ACC8EA5D4AE5BA2@TY3PR01MB11148.jpnprd01.prod.outlook.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
Cc: 'Ankur Arora' <ankur.a.arora@oracle.com>,
        "linux-pm@vger.kernel.org"
 <linux-pm@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,
        "catalin.marinas@arm.com"
 <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com"
 <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com"
 <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "daniel.lezcano@linaro.org"
 <daniel.lezcano@linaro.org>,
        "peterz@infradead.org"
 <peterz@infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "lenb@kernel.org"
 <lenb@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "harisokn@amazon.com" <harisokn@amazon.com>,
        "mtosatti@redhat.com"
 <mtosatti@redhat.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "cl@gentwo.org" <cl@gentwo.org>,
        "joao.m.martins@oracle.com"
 <joao.m.martins@oracle.com>,
        "boris.ostrovsky@oracle.com"
 <boris.ostrovsky@oracle.com>,
        "konrad.wilk@oracle.com"
 <konrad.wilk@oracle.com>
Subject: Re: [PATCH v6 00/10] Enable haltpoll on arm64
In-reply-to: <TY3PR01MB111481E9B0AF263ACC8EA5D4AE5BA2@TY3PR01MB11148.jpnprd01.prod.outlook.com>
Date: Mon, 12 Aug 2024 15:43:27 -0700
Message-ID: <87v805qs4w.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BN0PR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:408:141::20) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|DS7PR10MB4831:EE_
X-MS-Office365-Filtering-Correlation-Id: 025e352b-bb55-423c-0266-08dcbb20346e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xGGjgFPTGeEe4Ex5an9UpeoxWuAOBtoc9xrvGQcavFADZ3J0yCA6+7VeHmYB?=
 =?us-ascii?Q?k1GwCFh2zzKSyAs4Be+YOif2XDzWK5PNrrdsw2dP9ODcPmQ1xdTg4CdNAZv1?=
 =?us-ascii?Q?N2EEEcdam4NjUTJSaJ2Bbj2G/i61c4MOOVJCx1RE80cnoE4nPyrxbbdqb/MF?=
 =?us-ascii?Q?SUtALq2BmnG2EqdPm6S7Hv5jKg9/cSLaFOlWl2MDlX2LJvNtJJuN3MRcv/im?=
 =?us-ascii?Q?BXL9xL16xpVc2KgfiIU9fOO60/D8tol9cc0LqEGOP2/HnNZLEErohtKCUfaq?=
 =?us-ascii?Q?iPpL80kDPVojLQjdbyuWKd4gOakG/5aA5a3gs1LrQodSPwzjmCsf9o+cTRt7?=
 =?us-ascii?Q?sDmQz2roa+0rovn0R80l4KSppoWGhepYLX0Zt5qmLkEyDTJiV/D85X3lI85/?=
 =?us-ascii?Q?fou+Qd+raDKHYDvF9a/GdFis2f2BPW6mP93iGZbBC4WYVkIVoZSPOd9Gi3YU?=
 =?us-ascii?Q?ijtUsjuo4XDhbe/IcmKvsivjW2MAG1ID5nDdQ3aZKorZP/LbmxcdCWujOCA5?=
 =?us-ascii?Q?J16jCRztBCHwj1eWYazqo8Yei5jKNl8IAJvEuniK/hQx32UpnDpjTJLlYjVN?=
 =?us-ascii?Q?fkb6Plg+CPTEXaA45Wp/IlcVdd62RuP+SKqO4sTezz1qwXVtOyNGKmQU8Xmh?=
 =?us-ascii?Q?PEEMMg7PQRH/WSKXb4M5NlTIX2C3Z6WW4+1J2jeTNy9cAO3KPviGxvwuSich?=
 =?us-ascii?Q?E2f3W6pB5bQSTLBLB5KnhHQiq7F9dgmfPT4F6orT3n34T+jMqVi/xqo9JaCJ?=
 =?us-ascii?Q?puoegWOwDjQd5rK56UQ4A0lOQqCZBqH+ULc+ObzKymxv4aOQEi0T6rbMxeCN?=
 =?us-ascii?Q?hYD7NBJOlEnr4//Hfzy160A3LS4Tl7239dH0dFWJ2WkuoIagv9MlUwVk/FZE?=
 =?us-ascii?Q?dlWFw6m0E1KMnudrzTchISreQ50yWtO8UdxiUGTz0ST2hQOx3PZRg+0ePzSr?=
 =?us-ascii?Q?Z9rRyc+wCMLdmhE9qiq927i3QiC5LT+dXMagZnJ18U2g4qSPBBU+pcXKzs0k?=
 =?us-ascii?Q?2mp/k3dPzY8WidRxv8ziBvcC6BsiofTumiFzTlFQiMO8Ozu8RINLIS0h2BWg?=
 =?us-ascii?Q?gnb+9fqynF4bh9vz3CCtIh3lHDBWa5Ckcmf+kQgIbqtFzxKcSG+vJHh3YaHB?=
 =?us-ascii?Q?+/l6rYdLQ9YmCsFVmqZYb4lxXdN1ni5H1HvDWHZG3tDHZsFHAuNizbtVqBz4?=
 =?us-ascii?Q?M/GxkhiekjOFmTuBaWM8i1wpZMxJi3mD+0Bax5W5f6c8uEMozPlXl5EvjZ/+?=
 =?us-ascii?Q?b5yOaOwab9czZhEukol8dEVSJLuWrcCa+BZfq0TCsP7gmOMHw59ekCxHr2RV?=
 =?us-ascii?Q?fkgOlgx2/O0ANUsSeG0dAEfUwG+z/rm6g7/f+go/IYvwzg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mSHyL3CuCR20AERpiEr41fLBUkAglzm4xGNXwr72gQD56T666hXa0ZuTU1g/?=
 =?us-ascii?Q?pQ9ULHIymVyHB1GbbOcr5ZBJwPkJrR6tAN7/lEGD0ik6QJ1IL4lJ8JNXNGoA?=
 =?us-ascii?Q?emL8G/KZnscTt1C1fNsihV14ken7PbCuzD/Bl7XARQXvNUI/MFQdutucgLnJ?=
 =?us-ascii?Q?j8cAJv6rf2bvkcuFwGxBm3d5+tEeMqQZcqHHrCGGSl24YRjjfUF18OWwDLPi?=
 =?us-ascii?Q?s+MEa2OTaRHWY5cSys8shWYRIlXpCr3DXOERGUAXwvrKOBfhG1X/O98NODK/?=
 =?us-ascii?Q?6aB68qFObmdG2xSFB0FBKIsKmZ9MSD1HyavyMds9rQyN9TvTNb0CNmmbdpjN?=
 =?us-ascii?Q?r258PwGAbV/7WWSQL27RBct3iIoYnGY99iUs9ggtc55z56PQWKes+kwpSlVx?=
 =?us-ascii?Q?bC7NA8oV3AUNrG5FMG2K8RlL6DYK2xDTsavQWLcQ7IMSnNSu4UhNMsEPK7nP?=
 =?us-ascii?Q?0VI243+nZ9JNq0tizcjUoj+GRFiXPX56a5RmdMxwCaQmeq3qk8p/n1kGP98O?=
 =?us-ascii?Q?0sXjlrH9wf5Auk6JwESVzKaWXQz097IRnSSCq2ayyWqlYsCWy0bryv1ZFCep?=
 =?us-ascii?Q?TD8OTHSzqp3uLgBSJGJWhtftUVnEante5VLXHa+d1fQrFEIL2PzXb8Mjaagm?=
 =?us-ascii?Q?FvyyvnXPv1i36oRCrvJuKlxVZuMjgglxo3UocwOeKEKlg8WQGtV3jEP2a2eP?=
 =?us-ascii?Q?rq8ZxCesvOhtISLcJHOxXmFZnkdLQF5Qf+vyuFoUOZL6nSKbBu2GEds8ZKWV?=
 =?us-ascii?Q?do48weGt+UmIHb28QdX0YME3J8TY4Qk/hXIcLJZr84O+rF2SWZ7ND+Iaqasq?=
 =?us-ascii?Q?bhfr/7E/eZEw2chdDIM8HZ5q6DhCqCsogFTf8ijWRfTLB/iD2UHStPsoVKtC?=
 =?us-ascii?Q?fdJpG/0v9upJE8kAoRnwa05Hq7W6pUQ71Vn3prPanEOz6PVXbS08CB4QdBZw?=
 =?us-ascii?Q?SdnjjPVPmlitPZyD83T+IrIMhI2C1YVKCODn9ZnXsw17devFlNfPVjOonYbw?=
 =?us-ascii?Q?xAfr5Mh+2oYB5y+fsUNpQ4scQKeXTm8/I78Zho87iMtJjiPcIrBpoF3BUAi9?=
 =?us-ascii?Q?XIwjGzePBmpMN6gsgf2utg9L2VLA6jwFv96WKvFFriQ1B8cL4hfpr1j9YEjT?=
 =?us-ascii?Q?1dmiuf3aa+Jgp9TJMF5nYgsl1pLw67Mtl0b5bjsUukIO4GX75MRNPDuAEqxK?=
 =?us-ascii?Q?N+Mf1N3eILnJpcG0pDWByR8lBCrnJXJN/tte9dpmM4QnLuEMKW4xIwGmqp5a?=
 =?us-ascii?Q?MQLNn95A/0K8/OTYQFzXBr48eHILXmDl6h3ASxTTWAysZqLR1+M+CgnRKdST?=
 =?us-ascii?Q?HE0PMI3RoEm//pZ6zpY54YpCEDzHAqQ+jm46c8Dp7/vqTP8XWIUt6VQpqDGe?=
 =?us-ascii?Q?7zjqKlv4/johl8kTgE9YvcQziHj6wWwE8r17NZkBDzzV/bLby8pZ12+vqEDV?=
 =?us-ascii?Q?lA4PiSWrW9TP+qOIvxRNxokD6vuJb2oNVM0Cg8NYtRjmweGY7VKUckwHIAnE?=
 =?us-ascii?Q?nrG00r6KTWpNn5Q/A/BKKHPnd9xMrb5aGA46vOcUCXqoebPsXthNwe1jxhjX?=
 =?us-ascii?Q?yYbZRMX5NVCgJRbj5CHD+KcGTVvGqg+sYMn6P7m7?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9Nj0WB4ocQYmfl3FGyjbHSc8jOsXOlzz6yEjLyTTDEysBPCvl0mPdhTTbQUEpq+G/m7QcML9jsRoO+W358iBpCOWKvUOHeVtoM+uO2zh/WXtlhaf1r5FbL+V07VtW+T7IbWdECKF2v4mL0QzEW+1FoL9YatWjwBe0w5otJmKoW3x8RdiD5Tj1QHFliAifO3uoCF4NeAXnZrXn9mhoveS64quMmKDvQYGKOETiY3onMhU/owM6d7tTy67c2WGnS+rocae5jAktvM/aWuY2ynjMI3JE/sW0bR/bqpW5h+XVMHDZyXlVkI0OIlDXeuGwnpgGzSoUL0GSGsiLh4OtiCown8HUaocvvgGQQ5bgXbOWh44oEMMjuEzmX4TvNpWuJJ3z+QeDMhM3nPLDjBilLKG7BBrxyVz0gvGyiYIiziHbhnRo7RIVKrNmqM57KJQs6IE1jstEbLbp9Bwpo+dLo9qBTV4gZsOJo+Du50V6BRIK75Mfn1YjdOSu7uKio2muAQajnsJmK/7aUh7zHVklZwb1XXadRFtyS7Yyio7A3r8D8z+fYUt/whbWg4lz3pozO+mh5QalBavGprPuKQcDd6A/MjXgC8wQMFO717bNAu+n4A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 025e352b-bb55-423c-0266-08dcbb20346e
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 22:43:37.9803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AnkTb+JPFIbFcV3Xhhi75Z9A1kLoLICNrb5kIYBu9tllOasrQApvWgcMOd5Fyd1pNJQVrqA6gb8YzUMqhkTN5tR5z322BVRUEJkbdsmhJSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4831
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408120167
X-Proofpoint-GUID: BmCmZllRgYCYWuq3jdjb8t8_sVUpJzpt
X-Proofpoint-ORIG-GUID: BmCmZllRgYCYWuq3jdjb8t8_sVUpJzpt


Tomohiro Misono (Fujitsu) <misono.tomohiro@fujitsu.com> writes:

>> Subject: [PATCH v6 00/10] Enable haltpoll on arm64
>>
>> This patchset enables the cpuidle-haltpoll driver and its namesake
>> governor on arm64. This is specifically interesting for KVM guests by
>> reducing IPC latencies.
>>
>> Comparing idle switching latencies on an arm64 KVM guest with
>> perf bench sched pipe:
>>
>>                                      usecs/op       %stdev
>>
>>   no haltpoll (baseline)               13.48       +-  5.19%
>>   with haltpoll                         6.84       +- 22.07%
>
> I got similar results with VM on Grace machine (applied to 6.10).

Great. Thanks for testing.

> [default]
> # cat /sys/devices/system/cpu/cpuidle/current_driver
> none
> # perf bench sched pipe
> # Running 'sched/pipe' benchmark:
> # Executed 1000000 pipe operations between two processes
>
>      Total time: 23.832 [sec]
>
>       23.832644 usecs/op
>           41959 ops/sec
>
> [With "cpuidle-haltpoll.force=1" commandline]
> # cat /sys/devices/system/cpu/cpuidle/current_driver
> haltpoll
> # perf bench sched pipe
> # Running 'sched/pipe' benchmark:
> # Executed 1000000 pipe operations between two processes
>
>      Total time: 6.340 [sec]
>
>        6.340116 usecs/op
>          157725 ops/sec
>
> Tested-by: Misono Tomohiro <misono.tomohiro@fujitsu.com>

Thanks!

--
ankur


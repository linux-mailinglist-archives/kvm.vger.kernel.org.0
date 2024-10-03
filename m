Return-Path: <kvm+bounces-27837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A21F98E8D9
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 05:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C0EBB263AF
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 03:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 202AD288D1;
	Thu,  3 Oct 2024 03:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e0CFjKBh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ztKUyzmV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2C89475;
	Thu,  3 Oct 2024 03:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727926268; cv=fail; b=Njr7jCMAyxCksABUgbvOLjXNxTjWie7s7QcnqoVb3IpcxzDaBiVYw05VBzFFXJkrOkwNtGTUmLlIGvWf5weXKUMzEPaI+B2yV08+QeV3apDPFbuvf3vSjrjsz7wf/Z01KOsp87PGeui65cDFjv2z+/bOxaf23BiZiZ6O2MIOjKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727926268; c=relaxed/simple;
	bh=uAbeZvYqF0Gr8PveJ6ZnM7TpmYoxT8smomMWSUS8yPc=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=nYygxcjSHJwSRWq6ZpSegl+k4GwgqeM29pcgyoksakeADz3+jeoRV1BFRisSOXeIh+yHmkvFYHXw5UCkXyK9UOA05YlH4OvxFuvYGIeR8WIHLt1N0ls9gsRFsE9lMK96c8Yigjukrg2jKfazqTj/zDBpcL1oenWiFje5Xq0dt/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e0CFjKBh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ztKUyzmV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492MfYSp004009;
	Thu, 3 Oct 2024 03:29:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	references:from:to:cc:subject:in-reply-to:date:message-id
	:content-type:mime-version; s=corp-2023-11-20; bh=th/Nf1067q10Av
	Vd0lh4wkovdVeg1HuFceYY/d+gCfo=; b=e0CFjKBhNHxfM7+w/EJ/GM7lGQoSqj
	kXoBF7aJZ/TC+ZEyZs2rk2cRdb0019NhiV4cQ+aVFsai8Kq9uy4sj390nkiK3n40
	/GccaUKR+ZJ5pu+EA4lLEvBj3aqa7fAXCyQdfQbtqycbxgU9fS+MfoTcdwkV2v5Z
	Q567pglIQdRUnWGr0rMRo7M6GV3f8eizWsiS6eBTDs5jzSQwuauVRucTdQiO0d7R
	EV6TFjGZYF02JuLVkmrcDgjNQGqkIQWTzbQwrF9zaNQi8oNc1X1x3dHl13o+u/XC
	Da3lmHN6OxKgOlxITOruvk2D06Ewr7Kva+r/QQmaJI6wQ9Bwsah2eVMg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x8k3b6dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Oct 2024 03:29:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4930BQNP040505;
	Thu, 3 Oct 2024 03:29:58 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x889mh95-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Oct 2024 03:29:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MeYgSbiu0S7CZ8u8Wap+7bM0IMk9rlRxB5jM5lCLCvvDO0N7ZdpKbP9hhDrAJwLOlE5AVMmdztZ28eUDqPIbU4mH3d1bOtHqfYK7Us+89pdH8CR4KME76JpF/LhAzvgbWFn5lyynYqf7Ho+91rMwTJz3RoxITUccrvKy0pN/SldcL2APfv2p5lJCqKef4kxVSIcmbxSV++0FIwQ1GwvMNCBIUWh5mPrJ3Pzvmtv5O0dKaC2xuoPoBP64ob0TeG87Ift6qWnnpcyyY9FVl8YhUsDZS+ViSEzh4Yw986a+U7Rlc4SXoB9Oczdpr0jqNEl0SxajI9T/aNPKtkaStVjK+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=th/Nf1067q10AvVd0lh4wkovdVeg1HuFceYY/d+gCfo=;
 b=AjTwoY0M9eUuT/X/3DezeUndzP/eSvPVSkPKKl1tKAOQvwUkbyEdOD7iLjyUdqbiNSvpHeVC+nLO7RMFitoAtnrBRV7ie6zokrrJOK+tiQyBQUf/kBgT4FHnnz85rGsnmXSDqD59p1brKk0rZOgIjeBEiI54tW/F2ztoVOcN7J0RSh9VJBpOWI6z3950TIHKxDQDd7reG7Fmi4ZP6t/DulaYujggVpj6+gu10QDvWMo4rQa8smdoU71iZpwyVj02Gw6X7DStZb3SKsuAtfbfhv7LyTTM4Bblfp49m7PWXQ+fUccfgv1eAq4uNVSZvgFGU+6Aqfwz//kj3FApiPL0cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=th/Nf1067q10AvVd0lh4wkovdVeg1HuFceYY/d+gCfo=;
 b=ztKUyzmVpidJMvsEtpQd6EWEyh3foC8BnWxkHYXK9lAvdk+FqSrS5OMF4norpxoKP8OsM2JNQqXQmmNaFJ1ij6N3LkZvw+7pafwsKak2njXsuqNGWRe+Kt1EQ+g3tLvMd5AhSQ5Y2I260ckpp4yhQl7eUUba4xE29S+wTL3V9qg=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA1PR10MB6590.namprd10.prod.outlook.com (2603:10b6:806:2bc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Thu, 3 Oct
 2024 03:29:54 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8026.016; Thu, 3 Oct 2024
 03:29:54 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-12-ankur.a.arora@oracle.com>
 <7d76567549f81a42bf8f944dde3528b18cb3b690.camel@amazon.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Okanovic, Haris" <harisokn@amazon.com>
Cc: "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
        "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>,
        "linux-pm@vger.kernel.org"
 <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,
        "ankur.a.arora@oracle.com"
 <ankur.a.arora@oracle.com>,
        "joao.m.martins@oracle.com"
 <joao.m.martins@oracle.com>,
        "boris.ostrovsky@oracle.com"
 <boris.ostrovsky@oracle.com>,
        "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>,
        "konrad.wilk@oracle.com"
 <konrad.wilk@oracle.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "cl@gentwo.org" <cl@gentwo.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
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
        "maobibo@loongson.cn" <maobibo@loongson.cn>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de"
 <bp@alien8.de>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "mtosatti@redhat.com"
 <mtosatti@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>
Subject: Re: [PATCH v8 11/11] arm64: support cpuidle-haltpoll
In-reply-to: <7d76567549f81a42bf8f944dde3528b18cb3b690.camel@amazon.com>
Date: Wed, 02 Oct 2024 20:29:52 -0700
Message-ID: <87cykhg8y7.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0192.namprd04.prod.outlook.com
 (2603:10b6:303:86::17) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA1PR10MB6590:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fe24f68-40a3-4443-9dba-08dce35ba5d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wd9jLha64enZU4BjWJHxroNn9RPWs5r/tAFlLNmTCJ+dMkiXz0OY/nyEehxk?=
 =?us-ascii?Q?A47L/TbZkBST0PWcgcm4vvzuJyHLnZZFhB+ykFjkbTDbFZsGFpqAVlt1ZQZB?=
 =?us-ascii?Q?6+lu9xSeVuzS/1AfvC52Jk61OcS1307lK+cuvdHloToVZsiOaSvH9+FLMbAP?=
 =?us-ascii?Q?XVIvi+uMLgogCVpOC1BCB6ZTpKUUA08x6pxzAns5UGR2QJxE/Lis8MWeSAA8?=
 =?us-ascii?Q?08mePq4xIgeIhTGMfjk2eGBEYbVF/BeKXw2mQdnXEFhr95YgTATp1jN8VlDR?=
 =?us-ascii?Q?XACt7HDrvsCDwV6bsuh/kexiiS7fv2DOMp23roaOPEVi5wE464jgxkmS1HDs?=
 =?us-ascii?Q?eK1/f4z/cJVsiZ2u2U2U4TPv6ALF+BiLsLTQx3cVfu3UnQ3NaSfhXoVwNJCM?=
 =?us-ascii?Q?awSz/wvtmvwd6aZ2A5sOdhz73qJWd83Z1yYNtZtNic3cgHm5luZ/Rnevhynk?=
 =?us-ascii?Q?PzphT67bpL0vx2fDb3HRDEfizDCmJJIDzJobjH5QwYkpp1VrGkype02EEHlV?=
 =?us-ascii?Q?qCqGnNqaLPrMt6jbI5s5R0xyMEZ6URg5oqp0fSumiHAdyKCvToGNGORIG56I?=
 =?us-ascii?Q?CP1zHrL8YTWqU2ZMCC0VFr2Uv3HY1EktEq6sptwfR05OAddanwUOxRFZhcUf?=
 =?us-ascii?Q?fZf5Mf3wEKMZ0oNXF9Rh/Mh0XoNhVMPuzUQviHV8TF8cgZAqW+a/RWYXwPjN?=
 =?us-ascii?Q?VOYwAI9NfoRXB/8QqvPahzR2EkJXN1szHF40tLZsnJmZk6pHIAhiNM6A5B0o?=
 =?us-ascii?Q?R4yKp18ZnikqYOIsoBQcEeI+l5JRf43EOx/KX0schSAh2Ih26OFEwdEfe8D+?=
 =?us-ascii?Q?cuDA3pmLh+5EzLePfr9c3C3RHLozo7iUCpOXtQtQE8/iSqwlgcjmPAejsasI?=
 =?us-ascii?Q?f2dS5Lzt6gxds3LJluMcS9vyBxlj/vE4TbHN9hc07PR29QZEh4HiWK3MrBYU?=
 =?us-ascii?Q?ZptHQcAlw4IA51O7T48i2pcZnhHBZrTkKUVmfNrrVzEnU2qDmeA8LJrEKr3P?=
 =?us-ascii?Q?l+H5Pm8bCC/baRAyVYWRfZDfvnb78lX1fBmGKy+7g8sBUzJOQT+DLALuGIJ6?=
 =?us-ascii?Q?9MsXXxEYpm0gRAmnTwFQgHfhMUVwrWYnQ3/nnmnIEIwGT0VjfN+yTBWnZdxs?=
 =?us-ascii?Q?h6bMjXpCTA4HFyPr5Ful+TOOWT2C94cepdydyc0eUUfSwr4KGVHSx/zBZYSV?=
 =?us-ascii?Q?arQPjOsnFla82ty0WCgqLzSlI51X2hdB/VReLmjL5UvqDI6HYvaWdXL618qa?=
 =?us-ascii?Q?QouH4ziijrS7OQMPk7qt79tAZemviHoceJiI855v/g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l/vhQAycx9jGQrueSKjLEYBMmycScwQS1YPTJtDz4ZMBsaHeB7jwpDcl7AMO?=
 =?us-ascii?Q?rBiUnuqco9uvVi+6Ce/tEaXDZoJDM3Fx8U4tPHOFU4lEkvxoyBknwn0cUzd0?=
 =?us-ascii?Q?OPcf/8g+w/oHX2O3rlJJfswXiYrxc+YtWxbo8jRJhj0Zdy3kQVvYwTpKkYQF?=
 =?us-ascii?Q?18QaiOa60YOOjXuobxXeu/dq9jDbe8fAKpZ3zS+XX349mOyBIC9o2iOlIf9b?=
 =?us-ascii?Q?1YPW5nzXKLOCn2yjztPXSMH078MtYMoq/vuFQS3qGhF23AnPiYTvHTrrf6ox?=
 =?us-ascii?Q?YtP4RiiN2s1QlG6kpeX552hNBE1lSfFsBnitDQXUfg7tuTZFqeqBMWY24Oic?=
 =?us-ascii?Q?WC1kWWcJz335NZO+SobLlCQ1l2BUkxa7dZ3m1iPiIc0KtGGoty1fi6RPdTaP?=
 =?us-ascii?Q?ClolTUjGlWquDAq29F/uUW1tk/Lzwle9VU7VQD++R/XjOZ2FvKkeVZQ/8FiJ?=
 =?us-ascii?Q?iZ1d8obIzUI/EtO1IFCH3mhTdk8mPvsirYbXNp8pwPE8EacjUT+5OJcqOHSi?=
 =?us-ascii?Q?84eFi5XR8Tb2RwWiIkblMoB7RjvW5RUHOTSPdPLpTQNp0uJeGDZg+hsvi/jB?=
 =?us-ascii?Q?oRH5Vthxo/Ccn54sqhLk/h42ru7sPPpXdaqFMH6rxT5ESSXyK+AyLBWx5tDL?=
 =?us-ascii?Q?D2wivqEYJe3v+JVHQip4VGq74HmwZ8go7Ue5TSMTRDBskevjh8SGgN5SelJN?=
 =?us-ascii?Q?Bfo0ZAhuuL/zsS8aH3PISQWit3ZJjrXbJKBbUN+4/7+MZ7wDBwjnbWouWTOz?=
 =?us-ascii?Q?Ly/pmSVfkivZ66dD/Eb2W5v7xvsVFS0mtPcv5XOCL33UxWvUTIMDiNE9hnyn?=
 =?us-ascii?Q?3uDl9/lZB+Fkz0ydU8EPlT922A17TANhThMRiErZQ1Yt/DENet8MlCF613NF?=
 =?us-ascii?Q?MefDKd5SLUfJEo26OZhCaNUFio9op315pBpufW29/Bt+HQ/imG83hPdEG4wD?=
 =?us-ascii?Q?yGIYb70DFGh8xRPnBmmyB8/zIi+L+e3Coz5KTw3V3MBIncmeOymxFIWaiTCJ?=
 =?us-ascii?Q?ZSD0WKTDIVZ0sobeu9FPQTrSJADA5bpPOtN+0jMWdYALX8Mfy08Srwueifzg?=
 =?us-ascii?Q?t1vaY5J5IIkoSAjODSAAB5wEvua+QxGnca/Ze+nTPKLYqJvhq3OMs8ueMow8?=
 =?us-ascii?Q?AAQiT28yOY6Im28K36gfAhh3eIHbroy7chgK3haMQU47fuy50V78Ey1KVFMW?=
 =?us-ascii?Q?wc7S09tu9ZICh5y1SyeJxksXwm44I1foxhwJwGYZJ84AGT+GofPcOYKPVwoq?=
 =?us-ascii?Q?zBnjwdPVQmEa2WFjpevtyZzu/s9gYmgr091puETgqrYeKqzoLkx7XrhA7DFi?=
 =?us-ascii?Q?awN6/voAdrcM/zL2WylTOszStCdt/2IKkibPLC7CQoKc1D5Ocj9AC+2cqheG?=
 =?us-ascii?Q?cSvd4SFSKexo2tH0Y+o01OaVvEqi5vue5FSeMOjXjThWbJYjDC6SjMz1Hq9j?=
 =?us-ascii?Q?6FrtO/j6cK9ep4+rnf0UErCP1uEOHkkOLrexSgkfAbrGP2A89O1KbWZpfuJA?=
 =?us-ascii?Q?6nWZLhvbAOmgx/SStjIK09mRLOHu6/6zMKVAKIr6jjJk4wiD5tSV/WQ4l6KQ?=
 =?us-ascii?Q?v/bkzk+pwlrZT6ibzjODOcewr2QI43vKiVlpPMOnCfw66Ksiq2w+bEj5YxBr?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rQqgOxJmMedzvXq8zQsZ+AOVHiyRu7t8k/BgoBC7rfQWydHbSnlNShCSQ9K9lPhwNBbU4pLBhCA7OZtRXzs2shSyFp0Y6dGTLp4lnDpCL0APgg2R55k0UO6ws2sBbzP4DcmeIarg1UlzIEGh1jO0nVaxho7G6dHAEIO/AtldZ0XenxwW+q8PcUrh7nGfdyajbYa8R9SWJOPAmiui3Iwo7J9D7QtCewUiVfv/4oCKqla/DJXfjUUZyR9NV7PrU+oxm37yQvzbypEuUoBYyUSc1oWhxMgM/RjGi00mcZ0v7nOrH++MDAbUAJcv0CVlNhNMHejxucsRlrRZz37Swd2UFfBJcUoUTXAovBJFMPmoaGgAaqUwNmKrX3f6J0nyF9lEfYQDl+lL3Hd8I5O9R/9lF4fVWWTRutLPHUp37EHlATUQyAXgPrZ5+0NoWcjH9HTOXky/yv8taH9/XSmNM+rbkOqAs5OFI/68nFbmncoHkm+IeBDJRGAlAtQyoc9fhVhgGStaKscyuULF5kDHD9+9hNAh04hwIjCbco5SzeezSd6W0W8HzbwUCuM/4urFXCUoRGtFTsmvMGJe2N5fQ07/2Afah8gbxas0QxPRiHrVIXk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe24f68-40a3-4443-9dba-08dce35ba5d9
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2024 03:29:54.5783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6qeBITTpILTsbBTtlrzvjVbS5fhrXf9FtEWgb1QD9t3611PQb87i7DaMTmliZIrHX//Pf6MOr6DkKJstBGvx7rQV+YrzKrU1NDD68K1XRWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-03_02,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2410030022
X-Proofpoint-GUID: oFHK55jvlt5YLYOyzZZCPTxsiUkg6y2u
X-Proofpoint-ORIG-GUID: oFHK55jvlt5YLYOyzZZCPTxsiUkg6y2u


Okanovic, Haris <harisokn@amazon.com> writes:

> On Wed, 2024-09-25 at 16:24 -0700, Ankur Arora wrote:
>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>
>>
>>
>> Add architectural support for the cpuidle-haltpoll driver by defining
>> arch_haltpoll_*(). Also define ARCH_CPUIDLE_HALTPOLL to allow
>> cpuidle-haltpoll to be selected.
>>
>> Haltpoll uses poll_idle() to do the actual polling. This in turn
>> uses smp_cond_load*() to wait until there's a specific store to
>> a cacheline.
>> In the edge case -- no stores to the cacheline and no interrupt --
>> the event-stream provides the terminating condition ensuring we
>> don't wait forever. But because the event-stream runs at a fixed
>> frequency (configured at 10kHz) haltpoll might spend more time in
>> the polling stage than specified by cpuidle_poll_time().
>>
>> This would only happen in the last iteration, since overshooting the
>> poll_limit means the governor will move out of the polling stage.
>>
>> Tested-by: Haris Okanovic <harisokn@amazon.com>
>> Tested-by: Misono Tomohiro <misono.tomohiro@fujitsu.com>
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>  arch/arm64/Kconfig                        |  6 ++++++
>>  arch/arm64/include/asm/cpuidle_haltpoll.h | 24 +++++++++++++++++++++++
>>  2 files changed, 30 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index ef9c22c3cff2..5fc99eba22b2 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -2415,6 +2415,12 @@ config ARCH_HIBERNATION_HEADER
>>  config ARCH_SUSPEND_POSSIBLE
>>         def_bool y
>>
>> +config ARCH_CPUIDLE_HALTPOLL
>> +       bool "Enable selection of the cpuidle-haltpoll driver"
>> +       help
>> +         cpuidle-haltpoll allows for adaptive polling based on
>> +         current load before entering the idle state.
>> +
>>  endmenu # "Power management options"
>>
>>  menu "CPU Power Management"
>> diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/include/asm/cpuidle_haltpoll.h
>> new file mode 100644
>> index 000000000000..91f0be707629
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
>> @@ -0,0 +1,24 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +#ifndef _ARCH_HALTPOLL_H
>> +#define _ARCH_HALTPOLL_H
>> +
>> +static inline void arch_haltpoll_enable(unsigned int cpu) { }
>> +static inline void arch_haltpoll_disable(unsigned int cpu) { }
>> +
>> +static inline bool arch_haltpoll_want(bool force)
>> +{
>> +       /*
>> +        * Enabling haltpoll requires two things:
>> +        *
>> +        * - Event stream support to provide a terminating condition to the
>> +        *   WFE in the poll loop.
>> +        *
>> +        * - KVM support for arch_haltpoll_enable(), arch_haltpoll_disable().
>> +        *
>> +        * Given that the second is missing, only allow force loading for
>> +        * haltpoll.
>> +        */
>> +       return force;
>> +}
>> +#endif
>> --
>> 2.43.5
>>
>
> I applied your patches to master e32cde8d2bd7 and verified same
> performance gains on AWS Graviton.

Great.

> Reviewed-by: Haris Okanovic <harisokn@amazon.com>
> Tested-by: Haris Okanovic <harisokn@amazon.com>

Thanks!

--
ankur


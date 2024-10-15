Return-Path: <kvm+bounces-28956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28DB399FA9B
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 23:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD1CB281B25
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 21:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CABD221E3CB;
	Tue, 15 Oct 2024 21:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FV6FnDNN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Zs6xlJWJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4040321E3A9;
	Tue, 15 Oct 2024 21:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729029352; cv=fail; b=rrvYLCBs87kdQXD+xb91oe1wtySGKGlPZDCVzmG4N+uZFut/Rc6FL74D75/HfYFpQQrQYbQX7CXlqgnZ8tCMAiGZwgAEFpB6Ue19e6hJ9AhGirVcuXJlHFxRm1FPka7kT82F4XaPtU451bXnatq32VHc+CcqipdlE4v1IVikXlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729029352; c=relaxed/simple;
	bh=CpddGkmrgUlRFbpDvn74spenQBNRm7gMkCpqSs+G1uo=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=EunK/zth3FpnaIoqWvfKLu7+9l8rUq1f1v1F6fl8NHov7usivtXknW3K2wqNVC5BnqZXPvPwMal1ZhP1TiRdwVE0cg9aNVKULNe9WsT0oYKYrN8q6khHxSp0c3jg3W9dlKQ1eAObZLbQEVoMD2yzZT0puUvEnyC3Erv60u52AGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FV6FnDNN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Zs6xlJWJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtdIE029006;
	Tue, 15 Oct 2024 21:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=CpddGkmrgUlRFbpDvn
	74spenQBNRm7gMkCpqSs+G1uo=; b=FV6FnDNNWbfjefWPQq7zxGuSO3yqRY5iH7
	n5LT/WDKwyWQ+rfnYCwPyZ0mU4a5NNOm61bABTTcjSE491S5l4YsCoDspA21agoK
	mh+wP6m4X45rNjxr69yCmODJ+2RyjKx1Gi20hwOruxQZtjh5LDxsniKpid4KXOwp
	cIs34sILkUKVXQ+5PWzk5HkPlh83hDkbFtInaxyC4hgpghNRuik1jbM/vGvIAmGD
	bGI/b9j5YiYrmr9Vv2NtMR8Is6gwey5hQMrVIDPgKTaQ+yTqbudpY4LjkMDK31dD
	nBaPj0oZIuf8ecBcHq6lbS+ppUlO+vGivwN2Jp9v2rmae0YVYegQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427fw2jdcx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 21:54:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FL1mWq019862;
	Tue, 15 Oct 2024 21:54:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj82dn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 21:54:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TfdokG5/Gt0LRr7T9hb1uBhR+4+TGdQDmatU0+yvvO9PYYYN67mSmxaT4LAcUuhbpH1MudufDf0XYxzUk/Rv1p5G+ECj04rOy/LhCHF5lSHQQCv/utpHRbovtfRUzpGmO2b3lxJj6AuozZtrrH4dIRli5oBt0A7baE9/S58mNbz3kQdRNEG0Mf9BVVfrNPKPS/npfRjo+g4SOHiNAVfHi6KSJ8GVRg0NneGmuuavbCKCn7giqy+qhNDY0E1sBC5fBekN2NmcNoRWmWCDUcFbODuupSK+mdJAKYiKn9YoPOng/ejjWVqowfJpsUjf9rmR2POMviPraDTrYAZDF3N4qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpddGkmrgUlRFbpDvn74spenQBNRm7gMkCpqSs+G1uo=;
 b=i7ZouruW4vJdSISL/EdKU6FYiSflfp/0G7+2CDEbFz8Az6aYlv6D3vGqLPTe2/9uu8EibiJd8CiOPXjnb+B+j+rUGYjXD2uN3pxmlMTJerTZOwHAjJrgoGbdFsrTeZVr7o7GBVskWZOsgBEuubDP2zLi8m7iJhf04dWJ/osa++3ucppX5xs6FRX684LnEtO6nc9SLOY6U3ib/CigG5HdyiGJqg7cJQ31uArXoq9PEVMM9qCBfTLGx/NvPHQusWMykPf3C43FE6gndEE4v74qeU9NEGtIZ2J03mlCwRrIpnnip0wNj+zP54oR/bLLhX5HYIeY9/2eIARwAkRfBanZew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpddGkmrgUlRFbpDvn74spenQBNRm7gMkCpqSs+G1uo=;
 b=Zs6xlJWJUx5lbzVB5M9UbUNthT6ZplKOHMckVC2/py7o/fyv4YMjWjN1ihz45jiRBcxIr3S8/IOQdIWXgEqq3+bE/T2XX3hWJeQ8HLSlP9tUrf1DhPE35Kxl2a23arLi+w9XPsNrLAG5iV2YQM8cggNd1U1t6d+HVBD89rXk+Lk=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by PH7PR10MB6506.namprd10.prod.outlook.com (2603:10b6:510:201::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Tue, 15 Oct
 2024 21:53:59 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8069.016; Tue, 15 Oct 2024
 21:53:59 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org>
 <Zw6dZ7HxvcHJaDgm@arm.com>
 <1e56e83e-83b3-d4fd-67a8-0bc89f3e3d20@gentwo.org>
 <Zw6o_OyhzYd6hfjZ@arm.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
        Ankur Arora
 <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, misono.tomohiro@fujitsu.com,
        maobibo@loongson.cn, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-reply-to: <Zw6o_OyhzYd6hfjZ@arm.com>
Date: Tue, 15 Oct 2024 14:53:58 -0700
Message-ID: <87jze9rq15.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0320.namprd04.prod.outlook.com
 (2603:10b6:303:82::25) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|PH7PR10MB6506:EE_
X-MS-Office365-Filtering-Correlation-Id: 1da764f5-32e4-4a9a-194f-08dced63dfec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y7vaR+UfFvCZbOmux7N7B4jXxuI/TI43Aq5H2mrAwqeNPBfTPM4z2S6KSYmO?=
 =?us-ascii?Q?zQZZImQ1l2OL6ZrIqzMO0yo3rsAjLhlYPiN6xa7Zpza6mWLZVt/S29UouKNJ?=
 =?us-ascii?Q?GuUQAKMyH54bFDEI8VOLpNWMrFvCdb45I0yS9YzEohF5EdbvungdxCPbgUJu?=
 =?us-ascii?Q?9ixsb14JnP4Be0H6r1sehyZOBjx7Jo8h6fOnnk6IWyp+t4GbibJiItDlMR4K?=
 =?us-ascii?Q?jhJmSv0XsdIAzuh1/hYWdT7V0mYtsBgPDjlzzDevbR0LpLzsAfU6F3F+AL48?=
 =?us-ascii?Q?rBgZl+SDdEBw3eVm80E+CitA8nMBJLZRjw39MrlQh2kuVPYUzpKJIXECb8uQ?=
 =?us-ascii?Q?qM2AT6Wemt62WT6yvEw+tJnlYBx00etcZ3B+Nwvct9c/1uKPn0gF7VhMIXWp?=
 =?us-ascii?Q?mdHUmEYcg4fJ9YWwEdIApY3e/tKiCyEgrDUsfGTazwI68PyJ8xfC6FqllOFz?=
 =?us-ascii?Q?MvOaorWL2Et+xmNqSjJMdDJ9psRO+BC3X//0KP3krJyTkHo3H6JQfnKAO6dI?=
 =?us-ascii?Q?nvOItK1mxnbx3anwIaBLhgEoeVSd4S3QRdcu6Mb3jKQtiM7Gti4fbaI8H/zw?=
 =?us-ascii?Q?SNlagQ2+K/erEaGpkUrxdR1UirScKXi/Qkt1fHFa9Q8LVzvkc4pOwguOY5ll?=
 =?us-ascii?Q?8bDANrKHlE8qEHQkU9EnDG1E+mIradsxBZx24bJWKXUKgDHdx7QtuNAkdRiV?=
 =?us-ascii?Q?9SKAMU5kCL2N2WPQ/xZb3PA0JPvUd5DgsodgUKNv6tYk/gLlDqsbVfjVVuIG?=
 =?us-ascii?Q?nu4AzCvMSaWdJzZBbW1OiQ9k7WxDG6PNIaiHAkFQEPQoXnhyVxZ3XCVo2Bn/?=
 =?us-ascii?Q?jvHLmjNnOpTzdNZSEeVOD8WutlOetfi8gw/HpXfVuxXg+Bf8IyH3LcfMeQ3W?=
 =?us-ascii?Q?NenWqcHzcQVuCJL9L23g2/pPuYD7cz1jxAVM7l8/ruqevCHOxi/IEdMJ50OH?=
 =?us-ascii?Q?ONht/tnRdQEa8u/HYKaqvA0el2T5FfVq6kjgqK9ji6T2dQhJlK5RCx9VKl7v?=
 =?us-ascii?Q?LGbLMzSC5hkdt9nO90BBi65ZqCOUDrHC1AdvzFebFfkW4TZqoONRluVEKroV?=
 =?us-ascii?Q?adVRwxfCdWN/yHNuG1RreQxhLmwmqxDJ5mT19MKp3ryNwV8OSUz/SKovBnpw?=
 =?us-ascii?Q?hpZFatID5mO2bw2HeXuk3kIzd9CYkHBu/luTv/HbJ9kM/rTdQy9tjk8x73LE?=
 =?us-ascii?Q?6bcWvOWWeh4m7qmCCenJSg0ydJLuF1Zy+L0UWOxDzLaQbNasRhMP6UXOZSV/?=
 =?us-ascii?Q?Jp0wUu36ieMmLviOkVda2xf/fx/ze1pXSE0MT2SD+Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YsHB1P4pitdOPr3YYWWzOa6yPgKEFrvTw7mavMK0fx5bHOe7mstXqKyOFW02?=
 =?us-ascii?Q?GxuHDPrlpmnLiVWMEvf5VDckb5pRvHzzlCQCS+tcS4Nu2y57uEAQr+Sfz3IJ?=
 =?us-ascii?Q?U5d5aajCkM8eaifZOSpokBvJjo5rd9ZD2ubehQqyUaLa3N20IkT+5JsgYx9B?=
 =?us-ascii?Q?wlJAQlm0nqfzWLcSv6JPxerxSYxPApTSMHJKW4qzaZY08dsKb0df+UtLgNnz?=
 =?us-ascii?Q?CWKevP1pdm+2bcn5Bg5eq0U4ms2X5UJieMEvkLRkp65T9bnHvTAi5nFMioY2?=
 =?us-ascii?Q?YmPT92tsgaPkVv8AOG0RUCMyC1rFP3E2EDxLD8Z8YOr4sHF8hK/H8iK+Gs2h?=
 =?us-ascii?Q?V9PbwDrCtlyCk8k1x/7yPo0PFSgwr1D+G29sH6LeGp/osKQAGxoT5K/10MKm?=
 =?us-ascii?Q?D9Mk9ZUuvu4HDIOvOAM+Y2p96U5DQqZyuPTPjmTwQiumZUHgU9xosXufI01H?=
 =?us-ascii?Q?/NCzct4qg0ur4TJU/QhKtlDCyfWKvgSXhd4YybHeEnWHgPVP1aQ6ZN/TPFFJ?=
 =?us-ascii?Q?t7BX6pHUYtGBtEUvRUgN9II+8SxOWm8rjYiRQF3bKXjE5Bdie0eQ7N/obw1X?=
 =?us-ascii?Q?4i2HFzVE5Ju8BH/hneQZpZ0FkFP2aq/PF1YFUf+ldDLlcMJl1jEP8SZaWSS4?=
 =?us-ascii?Q?CDgq+tHiKaG8gqiaO+WVsFzM+jdJqRQHZuG9dLtfj91iqPJw3Z8tZW1VZKHe?=
 =?us-ascii?Q?tcJ5xxkzV3KSE+w5YSUdYzjCxJVLok51I5MLvW1vA1PFxQo2OCX9+d8fmAbA?=
 =?us-ascii?Q?2NfRRg4dvQMhtzvHiLNcDrSBbfQHRPuh2NCv7ad2doX3dnLseza4TloVnqf5?=
 =?us-ascii?Q?8Ts2S4MGu0T8CLESHkkpMBxj4mOH7h+akZwf1kh21nNAJ8BNojYRV3fYhsTs?=
 =?us-ascii?Q?M/JyCWjnATp+Q5xztRrCwl36ZJ9bzNg14FM2WtdFkbhF1UIAFT1jPcpzWPTZ?=
 =?us-ascii?Q?mqPlLYgGfCASX/qvaOWnUn+8lbI2KrakPnOuQaF80rLi73ulXkuVtAMZl1u2?=
 =?us-ascii?Q?diufmqHgYbxm3M9wD38M2h/PH29sghsoOUz/YBtTk6K/KNbc3+6mimbZlqhi?=
 =?us-ascii?Q?ZaBUvSOM9/lzb86Indbro5WaUZH1VwiL0alBFCvsJpjYmrBx8Y7z5VEz+zUe?=
 =?us-ascii?Q?a81FAHmaKhqi0Z7YNRsYDLoGQ8FegBJN69BBLzpe/5QygkpawvRTOAxeAyAO?=
 =?us-ascii?Q?4TftpZjDH8CZrdDSKaqkOpQU/duRVQMpWCj5HdLkjI6jkpCdT8PnzTt1mUUM?=
 =?us-ascii?Q?mq0vuBVpPATD9X27IKqBNSc0Sg3IU+sTPKH6Ja6tBkAup0FKPdaoeCSPwDzz?=
 =?us-ascii?Q?79SE33k5M7Io1+JGd18hzK0BEk5Pp/FiVUWgShu6aw8uhXIbOY2Lcoc09SRN?=
 =?us-ascii?Q?0KyXCGQM/E96hyVd9c9GWWMiuEktNAYWWN6Toref8ADwjhdCIw9Am23Ndi+t?=
 =?us-ascii?Q?p2LY40QaYUZoILvltxDeG/Ypc9xNY/Lpuj+BsMaGvuvC7KNYuQGAgYyZ+G6T?=
 =?us-ascii?Q?d8e8oiV4OtdwmKfu1873QGwkdLuhzQEyu6cwmUuRsWeYGfHyzQ3QYUtUOuin?=
 =?us-ascii?Q?O20I+2vLc2o6KM+P4xMSlE5hJfQxrvTqVwPaYmgmykqcDqvJnbMxIoPokCX0?=
 =?us-ascii?Q?1g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	asYZNSZPvl625iYeKWaGN7Taew5OyaWoPH7KAEvlS2M3hlVsOVNauni96fsorqR1TQIBPadWWnGz+i59dSTRwlZg2s8e6kFQGbBgAoqVvq1zY3tkQXpO80X/lMS0XYpNeyEcxU9puI9tO1ZX2wLGSWrf4CPlILLXxphshD/hbteNDeksLYhMe0xrS+RoKfHp1eqB/EWXQRmjdII4NrB6ALN5JDjyUlOo54r7Wy0cVluullzDmrwTndTmO1jOOSYCYcX7Umg+dtAcJB37lh0dpY1kw4iey1jZUOEwMdDCQZ/g8dc4OaU51uJjunuxniucUst9whCQJb3aOUA1IYWKMw2qtppYeGTHXmjEAfnEJv0DeYP6UpbpwBtS/aP+EpBxSmGtV8ohx0pUkxiUb+G+lQyaYPxZKILFVqgUSfJr4FqkhOcj/OhBmfKMUODvEcNhxB7tXnyzrl4ZB/WsDwCVFbJziaGdv9SjguX295KtgbeCHY1VDY7U0orVsrnrsJzrmgQRCZkeyy7sF+o5avYmHTt5Djtk9VvNXzFq/FwaPndDdDG14goRJ6Vml7oZwLyZaKrpkEyUMk0CDZkm+juQIdsxkKhvjeqR02zk5tT3qxY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da764f5-32e4-4a9a-194f-08dced63dfec
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 21:53:59.5461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SNEwOPRwM0CJ4kj0gFQBBS4Qq3Zt2PFO1ZFITAVD4aRbIUUHZ48/D/b3u0WgsCNcNAemhg/BUM0ar51GDX//S2yNnqky5d6qdu8/V3CfCwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6506
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_17,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=846 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150145
X-Proofpoint-GUID: onGdm2AGHE1oCCmMy_DN4n-NsyNfx6ru
X-Proofpoint-ORIG-GUID: onGdm2AGHE1oCCmMy_DN4n-NsyNfx6ru


Catalin Marinas <catalin.marinas@arm.com> writes:

> On Tue, Oct 15, 2024 at 10:17:13AM -0700, Christoph Lameter (Ampere) wrote:
>> On Tue, 15 Oct 2024, Catalin Marinas wrote:
>> > > Setting of need_resched() from another processor involves sending an IPI
>> > > after that was set. I dont think we need to smp_cond_load_relaxed since
>> > > the IPI will cause an event. For ARM a WFE would be sufficient.
>> >
>> > I'm not worried about the need_resched() case, even without an IPI it
>> > would still work.
>> >
>> > The loop_count++ side of the condition is supposed to timeout in the
>> > absence of a need_resched() event. You can't do an smp_cond_load_*() on
>> > a variable that's only updated by the waiting CPU. Nothing guarantees to
>> > wake it up to update the variable (the event stream on arm64, yes, but
>> > that's generic code).
>>
>> Hmm... I have WFET implementation here without smp_cond modelled after
>> the delay() implementation ARM64 (but its not generic and there is
>> an additional patch required to make this work. Intermediate patch
>> attached)
>
> At least one additional patch ;). But yeah, I suggested hiding all this
> behind something like smp_cond_load_timeout() which would wait on
> current_thread_info()->flags but with a timeout. The arm64
> implementation would follow some of the logic in __delay(). Others may
> simply poll with cpu_relax().
>
> Alternatively, if we get an IPI anyway, we can avoid smp_cond_load() and
> rely on need_resched() and some new delay/cpu_relax() API that waits for
> a timeout or an IPI, whichever comes first. E.g. cpu_relax_timeout()
> which on arm64 it's just a simplified version of __delay() without the
> 'while' loops.

AFAICT when polling (which we are since poll_idle() calls
current_set_polling_and_test()), the scheduler will elide the IPI
by remotely setting the need-resched bit via set_nr_if_polling().

Once we stop polling then the scheduler should take the IPI path
because call_function_single_prep_ipi() will fail.

--
ankur


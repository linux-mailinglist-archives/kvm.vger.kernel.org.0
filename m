Return-Path: <kvm+bounces-51317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77FB5AF5E96
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:28:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 380001C44765
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 268022FC3D9;
	Wed,  2 Jul 2025 16:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JrpTlWXf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GOCArBuC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864772FC3C4;
	Wed,  2 Jul 2025 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751473695; cv=fail; b=OpftYy5OOMeUbE1TTeHyFJ+hA+SxkuOfCMtO/rkEY1toc63RplLj/nUl13rOQ6YsTZCaXVb8BWAZWNeoff9JMg7fgb9LxfKKApiWB2aMQjeUtqMGkoaqFWuIITcKPEsCTx7OEPklfNM+waZZ9FqYB6uuQrLuHF7dyxw9zti5F7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751473695; c=relaxed/simple;
	bh=M1SorWupW0YZnwAK1tYIpl0AiFwpSg+x7VqtxS+arTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=vDeQbKJ/2B8SLBsHjKveN01DuOeJtr4Ce0aYAiPURQpv51d3ZPSMFbll6M9hDvn0Aqu2ifbmiLvLwxcKliOgr45jYdCudfi2eQAGKUYBTf+xO6/e+/kw6feL72+RxQU6fNilu8NLxnX58rSXexnxW/SAEfH8+QaGZd8UFh+wxcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JrpTlWXf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GOCArBuC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 562GBgMX009677;
	Wed, 2 Jul 2025 16:27:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+n9ysjTiEK2kreiMGKYuDKPMVwP3jF86/WTc4Ih6hqs=; b=
	JrpTlWXfZOYeC+JD+DzDHRIlY9ipyJ4FraMoWbEkjBhbx6oAUWkqS3fHYRj3UzmE
	CdWeiHK64p+H19cpGxBAFWrVbbU3qe8TI3pA/BPGDQF6wiatGL7PRRib7TIxt2fo
	Tey2SV6N0hob2q8fWdtnMsdhiY6IEKpYd0YXllUv1dw9PpEKZOdqOOV9njhzlHgW
	VKK6ryiStLkNa3fZWFV/rzPiyEKo3AxHBAHB53YxEh/0M/UfyKNOVDcTpuzdh3r3
	DLSiBDqS7gy0XBQ7gbWBQX5trq3wlA6unvQ7OKW4Z/Dyf0FfmUwiARgA72W5lef/
	hZyJbQA3N2eLTtNAraIV+Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j80w79y6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 16:27:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 562FKIVG024950;
	Wed, 2 Jul 2025 16:27:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47j6ujpwyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 16:27:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gOtfxItYWLzg6T4MVcrsUUhzEkMXwtXVpc5qkDv7gKLZpwDStd8dcaFJ6NN/Qhca4Ym6sp1sZv4eVTkPdmk5JK6HPC9YvCsx9XOhU9XMyl+koRXW9w/Sll/Kxv16J/g0uw7/AIcVcmsytn8n0/mTx9xsqZ0X0PaTIdylRS/a7COklyAuaMP3hm4d2Cu0wo33q+TXuA70Wmppr5LuVbRz0zFiHM6kASMPOWMEGxRjnOiMijInQ6FyZrm4GoWwW6k22mWxFv/1lzkP4A6UIyzT98gptY0eIoP7GWZZnxkVstpzFo86UTOWw+EUYRlby5dXvIh9zbvke2LBAXeZANz+cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+n9ysjTiEK2kreiMGKYuDKPMVwP3jF86/WTc4Ih6hqs=;
 b=HcLhjVah4Uilf4CJ2HDd1iLuyK7n63kj8JYQfdHs8IpIqO7yi2E/I/6GBRKNM8Ie3U10qwknRKp1JsMAPlKDnd5duKAZla7aTNwEYLlOM6i06vjH5ZixeZDJWNuz1VAlsqU6GtX8DRvC4AOWD0OQMnD3k2x+abQMIygPxoSBMlx5luyHXqUIrn8rL11faQyVDduotLd1qcIqUlLAgVOA85LR4vt04ts9bioekCNilQUiZjJygZ5u12SyJ8Ld95waSu1Y9QZmA4uVffUJNehYwKMwiVMp1rmIdl1Hz9jmynpNJv/lmfeycNNhz5H8AtFtL2gZZlZ8/gqLyCoHjizvlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+n9ysjTiEK2kreiMGKYuDKPMVwP3jF86/WTc4Ih6hqs=;
 b=GOCArBuCX2Dd1PyeufzbJ9JSlsohj6ENttzABaPi118cbKCykyekHpjkoWkXgJj6flCBasiD5JZnivcGD9xRRxYETO0Snbnh8uXIjxcMTikOgVx1KJ33FKSTwDjaPVwldkKO+w+JEfpRQalhh6lNQRe4Lb4ylsn1+m59DtJzPfw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6036.namprd10.prod.outlook.com (2603:10b6:510:1fc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.32; Wed, 2 Jul
 2025 16:27:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 16:27:07 +0000
Date: Wed, 2 Jul 2025 12:26:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Liangyan <liangyan.peng@bytedance.com>
Cc: Bibo Mao <maobibo@loongson.cn>, pbonzini@redhat.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, wanpengli@tencent.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [External] Re: [RFC] x86/kvm: Use native qspinlock by default
 when realtime hinted
Message-ID: <aGVdykqnaUnPBkW-@char.us.oracle.com>
References: <20250702064218.894-1-liangyan.peng@bytedance.com>
 <806e3449-a7b1-fa57-b220-b791428fb28b@loongson.cn>
 <8145bb17-8ba4-4d9d-a995-5f8b09db99c4@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8145bb17-8ba4-4d9d-a995-5f8b09db99c4@google.com>
X-ClientProxiedBy: SJ0PR05CA0070.namprd05.prod.outlook.com
 (2603:10b6:a03:332::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6036:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e83fd99-81b0-4e6f-f634-08ddb98549b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHZCamVGVnBLMDlydDJVb1loVFp5U1I0NHdaNkc4d3NsS1FqS2tYOWNYcWtZ?=
 =?utf-8?B?YllzdDluaktkVm96aXg0SDZQWFFwZ3pzU2I4Y293eHBkYkx2Z2hldlAybnBX?=
 =?utf-8?B?WjVPeVMrT0NvR2JlcC92YVlGejdqRGhvaFd0YXF3WW1QZUU4RFFjQlZQZjRq?=
 =?utf-8?B?bnlkQm9hREdNNjdGMVVNcXd0NzdHWnBNcDg5R0NwT0hISUxXcDNpL013Ukw5?=
 =?utf-8?B?N2g2WXBSRDJOeXp1TkI1Qi9aMzN4N3RBaitOLy9QT1FDYXBUUFNPS1B1LzdZ?=
 =?utf-8?B?TWFSaVBQaXJuS1JxSlhxenRrMlBYUGVEeGxJbUNjcWxXZ1hVZjVBenBBNW9J?=
 =?utf-8?B?NHRHOTlTTkwySmhGMm5pV0x4Nm1aL3dKWVVMbmcyM2xTRjVENkJIQm50cEdM?=
 =?utf-8?B?dzdmL1l1TlFkMlhqR0RxU2VENW1mWEY0MERzRExnKzJmeG51RG1uZDV5b2kr?=
 =?utf-8?B?RUN5WXBFSWV6VkZ6ZWFuV3ROWFhwa091MFdwMjNTenFwcUgrenpaRXJyVS83?=
 =?utf-8?B?MDE0K2VHRkZkWW5rN3ZWY09VazdlV1p1V3dDUGtrS0lEOXZMQ1VOWGsvSkow?=
 =?utf-8?B?bGdTTVJpQXV5UHhnZUlTUys0NHRwN3cwRVVBbEk1MDNYTDB0UXl0WFNTZms4?=
 =?utf-8?B?NEo5SnQzUUtrQmp1MmxxbEJ5UUVyd3BKT2swcWFnemkvNWVuVlMrZjU1dzA5?=
 =?utf-8?B?anVsVk5rVk9lR2hzUE9lUGErZUdiOW5Cb1BBWWxtb2thMmhIOEh2TXRPcit0?=
 =?utf-8?B?ZnBGazBwMHpCbUc0Q0tBMGEzRG9SMHVHT29pZkg0ZFRaSThUbWJZRXJrU050?=
 =?utf-8?B?bmkrWEYrcjlrQTloMmlqcjdURk10dzFlTUI5UjRPTVlwaTBEUlgxaG92ZThD?=
 =?utf-8?B?Z1NGVXl5SHlXc1M3TC9UYURaUHZPMmdmMHVmM0NjTXczRkFlYVUwWDJZWjlE?=
 =?utf-8?B?QnVMOTF4cWVnMkhRM0xpeXVGZWtKcStMZFJCSVVGZ3BtWmRhejdPK3l3N01E?=
 =?utf-8?B?SEQ0d25JTkxLSkFoU0VJaVlFYVFMVnRac29uNE92TUdtZFFqU3Q1NE84RXpp?=
 =?utf-8?B?VEhoeExsbzJlSGs2N0M4d25pL0JidjhqdVRJUFRNbjVJbnBLWjd0TnJSNk83?=
 =?utf-8?B?VVRiRGRTT0xWdzN4SE5XVEZZb1JMcGNVZG5VZHlHOWk0cVlJN0VXWmd5b2VV?=
 =?utf-8?B?aHBKWkhDSzk4cTgvVlBjR2FPVVRWWTVFa0lzbHAzSFhKRjdxUGhCWS9HTUJ0?=
 =?utf-8?B?aFlVamJtL3RBWUZoY0xCRjNwZ0RJczdCNEhIcTRrcUZ5TExUU0YrRHFlb0VG?=
 =?utf-8?B?MVVEMVJlUkpGVXQ1ajFyQkllcTZLVEVyRzJla2lvcWlJY1VaZ0JEWlI0cTFm?=
 =?utf-8?B?aEVLcmlxZkJjS2JCeXRsTUdHRktnR2FJdVdVOVpnS3lEemZtMDZkK05yanpE?=
 =?utf-8?B?U2hhZmpSOEsrVWdqbWI4NVpZYTJENUFiMTAyamhWVXJ3TmR3dlpSY0JpK3Z6?=
 =?utf-8?B?N0pzcFUyOC9QcmlPVjkzckR6UVhlSTY0RGZha2t0NXZTR2pwa1BiakhTYmN1?=
 =?utf-8?B?Zkw0TlpMbWsraFc1OUsrMG4yMk1vbTZqenBKTGVhb0NkdUVxNUJYdmJuTk9r?=
 =?utf-8?B?K1JMKzRLVFZhTXRUK0VvNi81L2NoVTZFY0l3UkxzYjN3T0txd0QreEVvbnhn?=
 =?utf-8?B?aDRybWszOHBxcnUrWDhaK3NDVlFhRzBsSW5wRmFOV2NFMGt2MUp4RFYyRDdp?=
 =?utf-8?B?NW1RQ3QvekpCKzgrbWhMSURBZitBMlVaNVYzalNPY0IxNWJNS1dSdENHekxl?=
 =?utf-8?B?OXdoenV5RkQxcFQyRkxsdGwyMml4TWNlb21SakdKQ29FRHhiNHk2Q1U0WlRq?=
 =?utf-8?B?TDg4UFhXQ0k5TmUwZGdpTXNJVW1RWkd0K3NicDM1N2dRcWkzQUJaWWhxcjQz?=
 =?utf-8?Q?oPxbJGAdxAo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dy9QNldwd2Nya3VhQkhQSDlJMGowQ1NVTkc2S1ZoT1dLMkF3SXpFL3ZqM0h3?=
 =?utf-8?B?NjJxZTBzZzlmWDN1eFh2aGE0bHFZWENOV0dmWXF3enN3Ti9qWXlFZ1kzZG5E?=
 =?utf-8?B?aWU3Z2ZLOURXQ3VzM29hcjkrMEcvWHduSU45bnNjMVhKSDE2T3JyTHRhOXl1?=
 =?utf-8?B?SnFxdjJpaklLMElsR1A5MEo1bXNrVDQzc1ptQkxDSGUxWjFkdnhlVEUvRmly?=
 =?utf-8?B?UGE1MDQrc3VLK0pORUpabnVYbG9CR3NZSU9ONkNqMEVHbTlFaDJBOURmU1Fu?=
 =?utf-8?B?aU82RTlVSFdSd1JybSs1QlZ0WHpTNkhnSHVrY05PZlB4UVdXdGg2UmhvV3Vl?=
 =?utf-8?B?RjhGUzhGcDNITlBZSERFMTJVRCt6aVU3RGw3ZkFXNlNMcVExYnRmOXVVeHc4?=
 =?utf-8?B?dUw4aUVwTm0reEV3UDh3MmgzVVp0bmpVQXZvcnoyS05oMmhqemp1QWlqdEds?=
 =?utf-8?B?eDJNSmRFaDAwR0p6WEorUGpxNTY4SVp5ZW8rYjdZb1NBbUp1ZnRSWWdFUmxj?=
 =?utf-8?B?TXhTT2RnTEI1QmphQ2IrK0JETm00RHd4b3Y5OEt0Wll4MkR3VGl3aitwSTZl?=
 =?utf-8?B?QmJ1aHJlV0FWRjZPbytQcGRBNEJkVjQwSkFHSU5JdE1RdURLMlJuL2JMVWlr?=
 =?utf-8?B?S1d6enp2RWg1VXU2akhMcElvS3d3N1NxbWpWNzA3UjdlMHBmMy8rTnBuZUEw?=
 =?utf-8?B?WlUxdGN4NVdEd2dRZ0ZEVTBUbTBGT1JHNmQvQWpzZ3FoeHVlenB1dG5ya25T?=
 =?utf-8?B?RWlQVFgwdTJQakl3Z2wxQnQ1V3U0cW5MNmhLTitPbDAwVnpHdFRiVFlOd3U1?=
 =?utf-8?B?RUd4MmVqbjJlL2dLZ2F5ZjJKYlVTQUJMQXV1M3ZPQzJKRDhUWmcxeGJhMjg1?=
 =?utf-8?B?NkhNTlRZcjM0ZTVFQy9ONGcxWWVnZVJXWm54RFpSVmNhQmJwOGZKOEFhUXRj?=
 =?utf-8?B?SEhjdk1NTkprN1BRYXdXQ2J6dmhSYS9jSTNFL0dmK1ZOUzlkcEFjVzE3amMx?=
 =?utf-8?B?U0NidnQ4VGxFMDhBYmJBTDA5MXFiQUNpa2tzeUVKUWhyYWcrWU85M2NxWjNt?=
 =?utf-8?B?amxPcURIbytGRlhiSnRZQ3dCQ1Y3NWRLbG8rTzJkRWZkMy9sajlkQ1JRR1JM?=
 =?utf-8?B?ZlBVYU5wbG05aU1wUnBNWk95OE0vRG9WMnUvWkludUFFU3RVQVFKZHdyN1RI?=
 =?utf-8?B?enc4NUxjNnBwK2QyYWhUMEpOSWxjMnBvbmd5VFJmQ0daa05kT0RjbU5XYk9y?=
 =?utf-8?B?bzRuanZMNTJuWnFtNlh3R3Y0K3pWUHpYcmlHWkRSMmYxODRrMWtxUjBHY0tV?=
 =?utf-8?B?b2hFTS8yMFZST2JKNmhLNnhTQTd5TGsxcjZxRDFkZVBqRjgrbC9jdXpVbnhP?=
 =?utf-8?B?U0kwRVNJR3QweXY0ZTdjWWNNODQ4djVXbTZXenZJNVBYdW9hL2ptajdBYmlG?=
 =?utf-8?B?dndJYm15U0t5bnpIampubllleGFtODkwODhJTTFVdGt6eEJkWmRHNXl5blBU?=
 =?utf-8?B?bzRNbVN2VzNvVDVkTlloaWs3aTRVTEVZTC9NV2RLNXFMMUd3RzJHTTRwVXIz?=
 =?utf-8?B?bXhWN1VKd2J3MWI5MXdQK3h2SGliRmMwOGpRWHpEWjNSTE5ldURIS0h3andt?=
 =?utf-8?B?dlhPUXg2RW5qaDRwcXFHYVV6R2ZHYzU4RFREYW5MWldLKzhJQ0F4YUM3ODY2?=
 =?utf-8?B?OW1KMDF1ZzFaREgvZ1JJY3JxQ1V3OXEzR3dDZnB0QkU2cjhHVGtteEI5K0Uz?=
 =?utf-8?B?Q3hzK1NwblUxVEwvTS9wQU9NK0YzeTh2eGd4dzNwaDl6dTVnNXE1Q3VBTkY5?=
 =?utf-8?B?RkNvQ0Q1dFJUK1dSY0J1OXJEMWppQTdWOGJyQ0w4WTNEbFBPVE1tTUp4b2ZD?=
 =?utf-8?B?bm9wcHN5M3FFQlFPYnFQQ2NhelZBU2txUU5lVitXQVB6NXRNNXZhRDhVUzVh?=
 =?utf-8?B?b3NOcmViR1cydzY5T2Q0d3IvTFIzQ0F6T0l2T1NwRndsdjVROThXNmFFUXIr?=
 =?utf-8?B?dVJWenl6UDJEOWxDOW9QYnRsTTZ0Rk1jbS8vL05FTmx1MzRicCtGN1RpaEpS?=
 =?utf-8?B?cFE1NnNDcnJCblozVDBDYmZnZzNjdEJyMXJ1dG1kNElCczVnT3U1b253TFJH?=
 =?utf-8?B?MnMxUERTQjhUbllia1FtL1p3eStyUTBveFhFRVRlQzRvc2hEc0szQTQwNStZ?=
 =?utf-8?B?Tnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9ZFMUCzfI9xotl/N+5/8OsIGC95okvMzFd8DV84vR1Q7IjvvmVU7Gj8LvUrGpfLK8p3EUQQ47Hg9HTlSehFoOcfMiADpfzHn7zgXY4x5G65NXysY+oOxy5I/B6YjzZhSol/X/Lzue/hqAGU3kJRJIjsUBI2XVTY0pOZGXV3pZxViNZdrFXMyI5ofC6J6fFBWPYU1HIKZyuqdSq4iAF58xQesZSVu94Gaal3zUQitd8HDECY8gnu230oagDhsEZzTCe9TQSDHwlyEhZRhT5rK6VC3VfhemBUxbY/oMlN2kM+FAR3oGz9Y5DdGUj98/ON06SdtP0dOPxbmMY8CE9YkEAK4DIcG3bsp7aFBjUVpPhe4V3iqwKJyo5jn2mNS117juOLUGyA1XR6VIw1o3oQa6lY4SgjwklNs78geXyoFei5RGnA1xX5q/2HYCIahyZMPInTeHYg64L0QC52NAhcVkmbBKVazVIeszNNYGqicOyYHfRGe8L5Id2eNHIJj+47SwoLF65nLQXABbUfM1sdX04KN5sdRBmFI8AlOzXcJ6mk8Rug7d4nZRL1g5SS/U3lQFm2HiNiK+nAq8eiEC+wwQ1qEVfy08O6NTOdkFkPmxEw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e83fd99-81b0-4e6f-f634-08ddb98549b8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 16:27:07.7699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vr5XmzmxJq5opMQIxeTLSqWyqfgK6Zq/JykOHOKHkXaZw1Ywl8+ZhsbcLV7011BeApbM6sENFk+MWHu19A6UEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6036
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-02_02,2025-07-02_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507020135
X-Proofpoint-GUID: 52oQaA1fIn-FIiQ-QvEBPKF1btFX84cu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAyMDEzNSBTYWx0ZWRfXwTt5lRl0G+oF H7uAH+Oe5wt0BvDAdzH1NiF6I56DtaLnf3UMeToCBNpfmbQIPoZOlLMWHFD3PsEbMl4rB9QT7TL 3WhCfnrZpok5PbtSNQUQ5Tovovi10GWvxJug9d8aDFT2wPj1YU96GfEM/q2jQ0eqF0xK6ke8Kjn
 1nRANxUdbD9sulseSxoUcPYWqP2UMjo5mlJM0sP2naR8STFtznok6vNyDDT1DwM6Xpufq7audIW kqrne53ow1wMEPt+906AZglu/qAqpukimY/yB1mEcus551zPkMVvVja9A6ElpN2pUmk21siAsME UQdczkV7fePnXqNz3ZpXDlp1xEx71uy+DZfXdYupvGvbLjm1/64X+KcITHr3ku7UzsiRz8Sx1u1
 wdjWSwv2IlnrdpH+pJy28TzLDGWxWBxCUtsJN/aaHohD5jcerKBeVQCWOoJskN2IgVO0PLcA
X-Authority-Analysis: v=2.4 cv=D6hHKuRj c=1 sm=1 tr=0 ts=68655de0 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=968KyxNXAAAA:8 a=E2GMToCHSwIVQm4d3g4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13215
X-Proofpoint-ORIG-GUID: 52oQaA1fIn-FIiQ-QvEBPKF1btFX84cu

On Wed, Jul 02, 2025 at 08:23:58PM +0800, Liangyan wrote:
> We test that unixbench spawn has big improvement in Intel 8582c 120-CPU
> guest vm if switch to qspinlock.

And ARM or AMD?

> 
> Command: ./Run -c 120 spawn
> 
> Use virt_spin_lock:
> System Benchmarks Partial Index   BASELINE       RESULT  INDEX
> Process Creation                     126.0      71878.4   5704.6
>                                                         ========
> System Benchmarks Index Score (Partial Only)              5704.6
> 
> 
> Use qspinlock:
> System Benchmarks Partial Index   BASELINE       RESULT    INDEX
> Process Creation                     126.0     173566.6  13775.1
>                                                         ========
> System Benchmarks Index Score (Partial Only              13775.1
> 
> 
> Regards,
> Liangyan
> 
> On 2025/7/2 16:19, Bibo Mao wrote:
> > 
> > 
> > On 2025/7/2 下午2:42, Liangyan wrote:
> > > When KVM_HINTS_REALTIME is set and KVM_FEATURE_PV_UNHALT is clear,
> > > currently guest will use virt_spin_lock.
> > > Since KVM_HINTS_REALTIME is set, use native qspinlock should be safe
> > > and have better performance than virt_spin_lock.
> > Just be curious, do you have actual data where native qspinlock has
> > better performance than virt_spin_lock()?
> > 
> > By my understanding, qspinlock is not friendly with VM. When lock is
> > released, it is acquired with one by one order in contending queue. If
> > the first vCPU in contending queue is preempted, the other vCPUs can not
> > get lock. On physical machine it is almost impossible that CPU
> > contending lock is preempted.
> > 
> > Regards
> > Bibo Mao
> > > 
> > > Signed-off-by: Liangyan <liangyan.peng@bytedance.com>
> > > ---
> > >   arch/x86/kernel/kvm.c | 18 +++++++++---------
> > >   1 file changed, 9 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > > index 921c1c783bc1..9080544a4007 100644
> > > --- a/arch/x86/kernel/kvm.c
> > > +++ b/arch/x86/kernel/kvm.c
> > > @@ -1072,6 +1072,15 @@ static void kvm_wait(u8 *ptr, u8 val)
> > >    */
> > >   void __init kvm_spinlock_init(void)
> > >   {
> > > +    /*
> > > +     * Disable PV spinlocks and use native qspinlock when dedicated
> > > pCPUs
> > > +     * are available.
> > > +     */
> > > +    if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
> > > +        pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME
> > > hints\n");
> > > +        goto out;
> > > +    }
> > > +
> > >       /*
> > >        * In case host doesn't support KVM_FEATURE_PV_UNHALT there is
> > > still an
> > >        * advantage of keeping virt_spin_lock_key enabled:
> > > virt_spin_lock() is
> > > @@ -1082,15 +1091,6 @@ void __init kvm_spinlock_init(void)
> > >           return;
> > >       }
> > > -    /*
> > > -     * Disable PV spinlocks and use native qspinlock when dedicated
> > > pCPUs
> > > -     * are available.
> > > -     */
> > > -    if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
> > > -        pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME
> > > hints\n");
> > > -        goto out;
> > > -    }
> > > -
> > >       if (num_possible_cpus() == 1) {
> > >           pr_info("PV spinlocks disabled, single CPU\n");
> > >           goto out;
> > > 
> > 
> 
> 


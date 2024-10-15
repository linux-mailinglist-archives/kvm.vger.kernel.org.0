Return-Path: <kvm+bounces-28829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EB6399DBE2
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 03:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2D1CB2219A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 01:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0EF156C62;
	Tue, 15 Oct 2024 01:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RIk3dK7r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ymasorl/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393A51E4A9
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 01:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728957006; cv=fail; b=YmCht6nhL26wh8V7OzmqOxotZQJbxd21Muj40Bl9wNjoGddQV0tAd07LcXadYBHuxUrVIq5qUK0mRJ6V58XLFerPVNG5NpqJq3ajeA2gLdE1cBYe/rZbixP2BMrd3dLK73PkQNHifbxTnv5o7cas+jO/dgigaWMvk3E9BSuzk4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728957006; c=relaxed/simple;
	bh=794FsjV0aFWWU8gZhLim86cC4KNT2q31gr052QakMCI=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=Yxot28Hs+D/lasnG1sdQldgBH/q49B+g7ItS+9o4vribV+MkMFYxC0qXfPG0n+XKBIpEtYs061bM6DEbSe0J3OJ6U3f4GSypOEx6siT07run/awTfevn8OnMQFygDdHE2zNs3ZGdlYUntqf/JisXmvue3G0sh3+vCmVBG4p7waw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RIk3dK7r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ymasorl/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F1BdiJ004655;
	Tue, 15 Oct 2024 01:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=794FsjV0aFWWU8gZhL
	im86cC4KNT2q31gr052QakMCI=; b=RIk3dK7rxGEEWJfX7iy0aPGvNdFAoN68R/
	yNV3ugfBpu0Elg57Xw8cYDEq7ziDR9BRIoQKvcw1o+QnjBf/CNzE50Ge6/IsShAi
	l4A52qO6mFlOyVU3NQUWoHH5ofnt24WI5VWspDNpj4nOY5XCpydhZaRcP4ClAkg0
	tlAyx9Zqt58qe4cwqek64rCwErj8IEBv9ZfmRJjT8TdjZIkPcTL/P/6RmkD5mUzb
	99A+wdBkGGMCNwPwrdElQ6FJ23RTLg43FS1MlAlpr2s9QuZB/sQGH5qwzGXSyYfY
	enssvy+Iu1F/xGzTl2eIW7/6Y/FpPXRVGFlOzENp0k28i41DiNQA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427hnt7q2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 01:49:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49F12n8W027308;
	Tue, 15 Oct 2024 01:49:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjdayrp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 01:49:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AoqZBz3IPuNKGzOhdvUrGGEPF/Zli3vaz9kaPFwBtiHVDdOuQCGOP/oh7B8kkFxccHzuPNOMnC6ePqEXrWs2Ya3yxuGkGrynMvuZ3igxQTy7GZfUMyrjxGq0zVmCOm8LW1a0oAfffVb2ZnrC7+ddodz2WndOwCZVSoOFxpgrHHxOWSIMQwWGJa9LlIX2FlDNtZp1OKYzjE5YaxmvgX9tqjcDzv1BAyiceXYRV/UiMGUGSxF/1GWxfrzCjMj18IF/dz80xeMcmRhMXitGBu9dS6/nw1vBdgxzYTMwokOub1Ad4TVCbt0Rrh3TU1zWDrjC//IySF63M+Y54WJ9i0HNeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=794FsjV0aFWWU8gZhLim86cC4KNT2q31gr052QakMCI=;
 b=vy3qAUcrhs/YmqwiwwP2zjzojRLBt1liitdIoXF17BtJySNrAqguTy4xqNZ+3CQJ0FLs96aV2/SXVLQWs9W+BssRxJDSuAqlOPYuCTK6rvmeldWP6cuCYiIerdWMXCP4/hj3ORb+PPt6ECBa4TxwxelyoUZG7PEZZwoLkutoJrzmJCHS5rq+RuEVrnaTZAdi+HT2vBmS/xORLcxDAQ47FSq5cjt0aOWOhfP95gy6g1XD3V7TFgs97TnVcN1zMQKD0TZHfF9/bYIrM4WUhdPCTr44cajyQ89FzvL45HYej+L/CWhdgg+AcbLNGFgJhTh/4OK3iJggf2/Ged1bn+ci/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=794FsjV0aFWWU8gZhLim86cC4KNT2q31gr052QakMCI=;
 b=Ymasorl/vrhh2fRFqKcAaPFkza4GG6lH/63WgK1+sV/hoH1K//5hCjBjYN/LZZpIEfYvfGuwrCEepNKjmViF3s1a+6U1L4h14ijd38HYu0YYYYHEiQKHJ/4j1A3k9P5gGqpC58kOSrs/uV5pL2BUcTVBO9MX9fikOAVLFt5cPoo=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by MN0PR10MB5933.namprd10.prod.outlook.com (2603:10b6:208:3cf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 01:49:04 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 01:49:04 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-12-ankur.a.arora@oracle.com>
 <7d76567549f81a42bf8f944dde3528b18cb3b690.camel@amazon.com>
 <87cykhg8y7.fsf@oracle.com>
 <c026a115-722e-e406-df8a-596b0088df5b@gentwo.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>,
        "Okanovic, Haris"
 <harisokn@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "wanpengli@tencent.com"
 <wanpengli@tencent.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
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
In-reply-to: <c026a115-722e-e406-df8a-596b0088df5b@gentwo.org>
Date: Mon, 14 Oct 2024 18:49:01 -0700
Message-ID: <87sesyt9te.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0071.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::48) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|MN0PR10MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ef2e539-79ac-4a4c-d1e9-08dcecbb8c5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aDZ8SrT42DfFEb3X5YHqzAUjW3/0/z23q16OFw4NJH3m5Uemw7L3FXR39gSu?=
 =?us-ascii?Q?geVbYV6Yeq0rNOibYgpl7RXjk9T9jo9UEQIyR9N8urPF0Om9ddVAStWHFmCg?=
 =?us-ascii?Q?3pwjfR7YYm+wd2hduN3Q1w/JOulAlbgiVh5Cg0WnL6JrTGscgZbMbMnrkuZO?=
 =?us-ascii?Q?qonsgYi4eiGJ3mt4kMHIJanvsxijgqesO/0sXQHw+fPCze8QZwHcav3tskbP?=
 =?us-ascii?Q?Mwn3D7E+mDtZ0SynlhNQKcnq5XDkqwsCTl3S8fZJ6tPqMhH8CzOoa4nxyrPC?=
 =?us-ascii?Q?iuGB6KHU+urP5a0kN+JLx885/k77zxAtA8e6Z0g8BmQfvv4Yyt+guY64HWSx?=
 =?us-ascii?Q?tSVUvwS1ooMbNw4RIrS5vScFVwFgSuqMAQ1Bkfos/i7/aWwJzr1fCD2LSFeU?=
 =?us-ascii?Q?BK/FP4X1TEbTInSjgLPGDex/sdZCKlJV8GbVi/PjpiuxShNXjvNaTnaLMolq?=
 =?us-ascii?Q?txauZQ08q34+ckcEA3WRQzm3F3VK2v6xcX8Ue/x8ACDRbtBjxxLaYgp9zLNi?=
 =?us-ascii?Q?0K80+wJy9f8XOhD91DQujKaoiZI8qNi+KUw+M462dTAl5Ex2gjoK6bbj7p0F?=
 =?us-ascii?Q?vxI/lOySW/lf03jzqk1KWWVufkdXsGES6SLTpp/FNU5uG29jnuuNeTyaeTfR?=
 =?us-ascii?Q?0d6XHIXQovpSoiGEncAfbHOXu7n9P0MDl60cRzarMJvzD/gG/lGCouoSesym?=
 =?us-ascii?Q?LB5MTwsHSOGWeVr4Di7aB+nkhZUxXrjQ1OsL5bfc5XiKGGksbcpeuMMVzW6N?=
 =?us-ascii?Q?FejuucZe2YaJNYRlIOQoMKsjYrFQqymzVIng/JuP9M3m038V9cUNNtmfp5dZ?=
 =?us-ascii?Q?9G9WHzflSm/1uYDgSvBIbxS3P5a2ealtsaFwNLV9KUsFQKsBKIsCFUsf9kq8?=
 =?us-ascii?Q?2W7QK5TlG3kgnzsRH1Q/Vz2gky99p9yglhY+hCw5TMAgwGyJEomGAT6rcN6J?=
 =?us-ascii?Q?52K4aflNu9AzFzH5+rytG60U6DnIITSPQC0oZTh6ThnzqSuZFaHOAgF4/u3k?=
 =?us-ascii?Q?x602vK4LzJCfgPq/xd+lk7jXVTFlNMaF4dPs+gDkk2IOjBvnuiUCm8cRYJrr?=
 =?us-ascii?Q?D/A5jQ76J/cuop1CFAfzl9YJeqJIun+G6FdqWAV3P16igS12Tc3XsPOjDcLh?=
 =?us-ascii?Q?RkIxfI+vwL2Nis20dvUmsBqFR0heGOgPmLjr6bWkLm2MPCDsWQdL88QsUVDg?=
 =?us-ascii?Q?GwWx6OwaYwEs7ej6yBtB9ADhEP6SGHT57ISaxfIgpAwTcqtsBOEhW8VkRKbh?=
 =?us-ascii?Q?8YXBUyHytsl5pNxlfp19mk8zqoJvLKvTTw945eZd7g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8Jf4mztOsD44JSR5y3KLE1+JTNO0KnZZCwXXIDyA74qNY7M0GnAIQ7IcIoAd?=
 =?us-ascii?Q?1bMfp4MMZZYkNPuTz2Otb/frqLYKh4v3sqlVzbMmCPOBW2AJOUt4DYd+QLbx?=
 =?us-ascii?Q?QUojXhU8k23ljPW0OuZvk3/vZFZ8/gLtoHxdW8MaNco/WcatuST3TiHMyVZh?=
 =?us-ascii?Q?82W1s8Fj203lKJBFeFZoPCncpl8DXFbfR+AeoSSRj5JjETlNMMXNTscJj6TN?=
 =?us-ascii?Q?IuMiKuMjrZdIQNfdDFoNsrHK+Wbrpg54OCSXXbdJEPWLb7p3bZ88lp9kLfrs?=
 =?us-ascii?Q?N+ZACxLb72R7OwEQZ0+9ionqmi16SM0MaLmygqSAdlD+J+u0jLCPeR92b783?=
 =?us-ascii?Q?89PbN+1XDzAvbsdsXyrz6qPlD9FKvufzkNXX/pU1urucoLbJKZQAEW2G82qF?=
 =?us-ascii?Q?4Xy+U8mQwmLYfhtCkKKxalEA6bfZqJj9z67KgSfQAYSYLEpI9epsE7fIntHZ?=
 =?us-ascii?Q?nhVSPWH2nI9SoCRyvWHeR8IAz07xu7aKU0HqF7gflmoQVp3QRG08q3wqDnnU?=
 =?us-ascii?Q?oRE9b8ozMle++bZn4CDvkyW49n4K0LtUIeS+fJAsVoO1RSuyMgqaEjH1ICTl?=
 =?us-ascii?Q?v3A6uGux5QgkYjHPXHl/vzr0wvjc+ZePpHOOvnNfsT+Fle8/J3SOiwfRCqPR?=
 =?us-ascii?Q?HBuRu2ScCz4x5IC51UPC8UcuB92dyvU5SbGfAbxoX+WFjQSCfZy/uTCAMSde?=
 =?us-ascii?Q?T2B7RbgeTdxx9nc4nP5nRsoMhKl3r0u+qOswPQhoa00QUyaXTPvMbz2lgv9r?=
 =?us-ascii?Q?Nb6X12XxfCbMcLg0CCI90IjObCS8fGYPodsCNWTwYyqImQGi1twyhp0M5AJh?=
 =?us-ascii?Q?thU+bEm2Mi2Dgx5S2O4J+T50CvQ3aMep/7YqRxFiax4ShJftPl28gBYIFzKO?=
 =?us-ascii?Q?q8xXnGYNF766EGubHXjwfUUHtUqYfsSDPGB0dMlLANfcN9e1IHcJv3ZjFhq7?=
 =?us-ascii?Q?mMLpvaC97rkeJ0OdZipWGXMMLn4byj0HdRjCSxpEFmpzx71T2T9isuEqSk7S?=
 =?us-ascii?Q?TV4+1yDA7jSQhELHfbKuECUDRW4tqdfigcTUn43QklUP32AomZ7Nv6OE04gK?=
 =?us-ascii?Q?xIaRRt3JfWADxXlWMQKMHnIZ2V3+x0hWv8/3ZNNY8j8+F0pqbKL9bvCKIFYF?=
 =?us-ascii?Q?ByX566mT6OvCv2c/i1a82JoVfvnG6EY/opQcHLcsYcrLsoz0TjXchmm2zP+5?=
 =?us-ascii?Q?T0E+7cDVs83IqpWLDilgsOVAa7ARDUyv9twlY737geEVFodSoTxB9eB7NvqF?=
 =?us-ascii?Q?Hj1KYHUHTW0wOjTD8I/wsX8QI9wypSa79UKUvJbxESPFnvL7Y09T0P+JmDBC?=
 =?us-ascii?Q?+D1P00LqnZOMrh5vKFLmwsiXUIw0BzFJNL8hjZLiBGnXwsaE4x49k4j3X5ux?=
 =?us-ascii?Q?2L6uCFCjnB/D8SDxBhn8+R7/POLE6HaZKoIvJAvSviPBhQiwmGB3uMjRjFRw?=
 =?us-ascii?Q?3sZQy49TLiR37u93C1jCbV3HFifzCDpTnJQVxbeagNfTKSfEn1uq/6q4hHMN?=
 =?us-ascii?Q?XjLIRHX00ZfmGxmRjVxCfR+xF6VihLQX6R6BtCg01jkG+DPvh5p5tgGntDxZ?=
 =?us-ascii?Q?PPOsW2vZw2EA3eItc1vuTBp2iVwvcPlMmkKmfDmg?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Hou4jMcY7Btu6RP/uYnmsWvHGXMtkBvURQlUy/jXDN48n32EyslAL10pgSI6UPDx2ZyT6918JO+X+uAXNIfh+x/lD9Wz/mzCB6qrcH1/57CNI2tC4QZZLLsA43giKu5syl9DXp7vWYPPHHFZVteikktppa7Z/OzcqIYyIR8C4Tlb3tDGLjl6GHNRME4+kxZF5q/rTzoa1GK1u+XDvgKVTzRx1MWpeZraX0BKwxgHynMxc5R5oqFQ3/K0WvtW0wHVRYUBwd5Ha3Q/psRUG/9KpfwJhy77uRTmoxCDN/LQKMQbw6SVtgT1VmzL2RGJr8sOxBTJTT2iLQ7PVV4xLg7r+1AxKmNS8matrLOgutk7ekr1kzvqTIfqP4oWiWMNmQBTLFavp6VQuOd8FG7qJ6aSHlhefsLc26/NuXfae2WkNqiV+E+AmmB4cWvBKpEeutXpglwV1uWJixrX6qfGLT+YAtG82dIHWicq8aWWFYAkxUDcvXaWSf1cblDONnKWgwaXWZrWhpiah5hCipk+7+k+13/MXyXOCYgMWh/ZxhO7UoZ3/0ZuOoJcgCKCsrmAvwRlpzqQ6RnMzJ46csSPgxXr24IBcwCKa7qTu/R0prE+ECM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ef2e539-79ac-4a4c-d1e9-08dcecbb8c5e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 01:49:04.0651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DsYWSIKoOtAftER7+2bavSCfRhJU87ojRoWNHsEj9jLer/B+Istwm50wxd8qv65ZL5qx48JRp9GDl0j/mQoy1FEtyBrlyMGglELaPiuq0wY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5933
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_19,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=854 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410150011
X-Proofpoint-ORIG-GUID: miRJdCsGvjiNbVaAiUU0bKLoeQbjixdW
X-Proofpoint-GUID: miRJdCsGvjiNbVaAiUU0bKLoeQbjixdW


Christoph Lameter (Ampere) <cl@gentwo.org> writes:

> Reviewed-by: Christoph Lameter (Ampere) <cl@linux.com>

Thanks Christoph.

--
ankur


Return-Path: <kvm+bounces-72325-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qF7MJ6WTpGmxkwUAu9opvQ
	(envelope-from <kvm+bounces-72325-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 20:29:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F75B1D1525
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 20:29:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ADE06300BB9E
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 19:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B17337107;
	Sun,  1 Mar 2026 19:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SJShKU4H"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011043.outbound.protection.outlook.com [40.107.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1342F320A24;
	Sun,  1 Mar 2026 19:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772393374; cv=fail; b=M8Fl+yulZ/QR3HpQZnQ6aFoB7PAQ/xCD0OcezLTqh+BBeLC0DAfykeet1Ds9VPaGjD8zLcgBcMZwQtOr2iP3fE/gAJe8SCTeB9pZLlBgSHxP3hbpmJJwcgMbKA+eG0W3nD1nrSwf7LH98OA2KYdlX9y+s5PQwUoiyAkWetL3rkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772393374; c=relaxed/simple;
	bh=MX+yQJleX5GJghpdj7Xk+YKIvPyvO5I3xZNRwZlTweA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E/FEoaYSFUIVZR+SHTcaLWXw9mWuPWh4gwVDNQfXlJDZQ0VEDkf1wi3d590WkrXerk06gnkit1AQUi0yWjTQOPQzX7D0vUJ4wlKeFVj2ARpoJGrqma3xkLDsWD90aMtTWLo7QHgJ5Q9DZ6wYQSt+uJGOrSIjZ232CfJTbv6Na1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SJShKU4H; arc=fail smtp.client-ip=40.107.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g8DeFgY9VFqnccMTyprbrZr0bYlxVsSY5T+1f+zX3/hewlsop/K6Zdxcanb6rDmG4f/3+u1g2es5sEAfBK0m6dCA0RcWYUHcPcPI2FwMCpJ7xogfS/7/chB8UZYTRtMR+DQU5FAzu75gMz8NpFz1OGZzw0Zvkdr+rKWF0uj2F+ZAQiCsvhtmGygDCARQ+Z2hVfpD/Xw5REjGEgUP7q3ST77NhFZnuAhHFewgYzfQvaCBNMtLLBc/sxIKVdG69nu0MP/fsWFjAcZVI4ZBJdU7lMu2AaABfZNaFT7rEbSP93H4If7Nwh2sL2TJbW82esnCwCGAeqHYRffh6STemVvzDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MX+yQJleX5GJghpdj7Xk+YKIvPyvO5I3xZNRwZlTweA=;
 b=ZDU5qDayi9ec6GH6+Y60Jv4RtbiUmI0L9WrZIAeiTAOEm2zWWF5JE2A8Wi3m9iiYrMsGXr8v+Pgma134aHRKlJaLYVL84DgsBOWq4rTGHpOm7DL26z7VRvRNt5oisV7JGMWo516HG+3/UY6/3Rmc5y/e9DW9c+RR4c6vUWS5c6Z2hQ8cTPerBmZ+LS1m/Cj+5kJbivF9tp8si09o+IpCooSbRqq9pa2tjbpY1DWdp3VDiAxreX92nfXdUy0zBHg6SJap+FYefI+34SAMpOUzqhyZ+nMXInVSKeP9tmFAFUR9rfAyaoxBpqo97wT+cgmttZpaDvVhFkgdqR5x7DkxFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MX+yQJleX5GJghpdj7Xk+YKIvPyvO5I3xZNRwZlTweA=;
 b=SJShKU4HXjh4jsRDGi3kXfBqZJPfneihYXwl8HIPyGh+Mro88TbRpwdChZWxBgxiThMr9HbrevVL4Bhi5qQCZ/gJlsl6N4cjmfQivQzFu3Tk/z5Ud4pVZuI1uVufubZvKdv1LgjADZaAlBFBldVD2L2ZFqjIjzK80FTpKagAQKT3dI0Xb8kX1A9HyAt6LAjlqhfF++GIdHaJD+jpshhdgw+Q+xK+aDJSYmGLTd6LebFpVSBm8zuTQdHIQBIwwIfovkMY4EDT3CsUyDXiou+7dAx8R6I1UZXjL3iR+wAGODGoZy7rUe3mXC7sKuFSsr0cfLrImzkexH1hx2hh9zAOwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM4PR12MB6591.namprd12.prod.outlook.com (2603:10b6:8:8e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Sun, 1 Mar
 2026 19:29:26 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Sun, 1 Mar 2026
 19:29:25 +0000
Date: Sun, 1 Mar 2026 15:29:24 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>
Cc: David Matlack <dmatlack@google.com>, Bjorn Helgaas <helgaas@kernel.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <20260301192924.GR5933@nvidia.com>
References: <20260129212510.967611-3-dmatlack@google.com>
 <20260225224651.GA3711085@bhelgaas>
 <aZ-TrC8P0tLYhxXO@google.com>
 <20260227093233.45891424@shazbot.org>
 <CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
 <20260227112501.465e2a86@shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227112501.465e2a86@shazbot.org>
X-ClientProxiedBy: BL1P223CA0034.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM4PR12MB6591:EE_
X-MS-Office365-Filtering-Correlation-Id: 18d723bb-316c-49d9-0b0c-08de77c8d93f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	5bFEiRkDkqiJ6IwnEZJuhEuWjuCHm12MZ19LH7aM7bKNEru+HTQArfq7q7KMj/MIio4oRQyI/y7Sq5e4AcGsG61pWdPVrnKx70SpThRazmyN7iWZSPRD79ed8PxbOS9UwhhNvEemPuTnFPOsrqp/lUFjqmD9Ow/uhQYcxZO6uI4TaNR2+j9Un3B4UTr+FcNzwn/jJYU84UWGvzbub+X9mhYLEWKi7f8+uwE5kRAl/QxCcK3LGhI6D30goSheut01l2qqG1ebTHyW1RPNQgWF6E+Smu+jKpQZUCsQ1BjWnRvma8RZNQhevRFYnz68gMXSVXzs9S4kiUmEuwiBpaDnp9r6yHXQ8MKIBONAW7dSt15RwlygJu93AJ22QFDBWENLNNXuA8oQ6KoizH5Q54nqSFqnxKAUMwtkcN2gHdwCqwpzEuza+AY7OQ1f0Hi3jWyI4NCvSYSXyAnCraX6RPUjAiHKsL8dLf80OH6ZbY9ckhdrMJ+u2ikgxciuR1DWd5wWlM1faDFaVgrNcYqzNe86JewtrRmfKsJsTYG59bn8NZ5oO9uxsk7CfQiqIK19c/kLGgZQSOSFq9/EnXvpQJVcN4EU/8uqCx+PIyUbjasqA6w181PFFFKwuwGqY+dZwlVpqNZlUZLQ4QkiMlfu2lG8i+d/Gcs4pg4DNZNAYT/htPMuO7olRL11iL0K3lGx/iAqCUtKfWj9zRnuRsJmUkYzZ0CbPlMoUDvE7wQ2hQATGU0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TNPJx7wggLy4ocH9Yj526ndA2xiuMcYpbDiyVtcJVloJN2MNyVX0dky8G6o3?=
 =?us-ascii?Q?Z8cv6MUa9OAlM0/aXv+CHgPmMXXhXjipvH9ZgdY56XMT+T4700912B8S2rPz?=
 =?us-ascii?Q?iHaKK7P3lzvi01k/vliBrh1Tbe1B5L93wiI3AXTnwFa5hilpYw2bSTXx7JQa?=
 =?us-ascii?Q?GZCvItojrZTUnCkJL4AAGtITOsGhqdA4Fl4VjRWA8Uws9Fqlx0YGuyujCiJM?=
 =?us-ascii?Q?vWzv2yNprubnoulbUPnWxW4t8kffxEevikL/eyytlcE4rO4bcjmOo886xddM?=
 =?us-ascii?Q?WyfiFBJBoWgEb/t9uplOIoWYcRpD/qs8fpnwWE7sPJuHyfcO/VbwyMWv963L?=
 =?us-ascii?Q?hCsT/ko+n2vuS6HlGlRFrQvERM6OFsgAC4DDBh7Tucf6jiSnIR8jCcSMz2Ma?=
 =?us-ascii?Q?mDAm0QLUv5m6hTYtpn6trZ+HZyULme8ePNSFPcyI9QQ88C812zFdWY1Q1syv?=
 =?us-ascii?Q?hc4uGgMucDGtMwOSWyjxWkdfuI4MaAkUa15Nvh0uOpUwadWDWQMxblVAYkyO?=
 =?us-ascii?Q?Kezzz+gmzhQjYCz4gqe1UW7nQ27AwWKxTAyJVnBr+edzEKjzQVWxP49Eubpj?=
 =?us-ascii?Q?NvPhO88soTJb6O5iUktO6X0oq7Hcb/6evS1fOdzY/GCJZPd19BybSgdfpWUw?=
 =?us-ascii?Q?mnkp9VERuyiUt1fNPFvsv4YOVBtSSBop10GZt+RYLrR6d9qcZpI8fjstVwao?=
 =?us-ascii?Q?de8tsFIyIRSOjTDxlIyG16p5xnPju5D9Trdq/AXfrlAx8rXzMcDH+MgrQsP9?=
 =?us-ascii?Q?OwTM4JQV5wExpGMa36BHFJkbaNqjrrOCnqw+10eAiVV+SFu0eXvt/mCGvUcs?=
 =?us-ascii?Q?9IlgLPyAmX3sjF37sYMIEY860zB1vZMHw2zw/K2Ty+AY06aohfpZobiAsYEK?=
 =?us-ascii?Q?G5eeXj7HIdDExou4HbzHIUz8yjyRjHbX2S3uNyZoDMVtg+Ub7w17VeoZrUwu?=
 =?us-ascii?Q?eUsCUDciOcg0Rh7E0a0jQcgZQAIDHWVHc+1Vslp7F7xbRX03F8FbjS836umr?=
 =?us-ascii?Q?kRmF0wSYO6HCJk/X9i/O4eh9wz7/28u+3Bhzd1vdzAxnuZpT3mUwD8aXk8sI?=
 =?us-ascii?Q?4ysHAQPjxjNVqBFJhIlXd9LGvJHTHuaCoa0rexi7xlfsEM20c/KdVs1q3hkO?=
 =?us-ascii?Q?tmyGYQ7ved2ERw3guEsRQHbsBij83RAkzOTFGcHwadAUg2m63yO1VaKIUBx4?=
 =?us-ascii?Q?NiOWZnSGUmethPQLBdv80tiQTUNcStG5FrY53fkCBDg1P9dEwEFK3e335V+P?=
 =?us-ascii?Q?l1RDrKDOpThpcIqrGRp++5EiDwmzAUs0rVe0tEGHxmHPF4gIgNNLb7QR9rB7?=
 =?us-ascii?Q?VAP1VmArGbqiuzDzOa+KFMqBjYFVeOth+79glViDG1SWuI3B292NaEJg7uTl?=
 =?us-ascii?Q?eFYbPrMN21Yv7c1ZCBFj4KslBIzMIKkRQ8uFpiOTiTWV14/IWO4ktrLuZyhW?=
 =?us-ascii?Q?opRZTyoJVj0X91dareYv74udyq749QFJOPQXB3iAs3agU009xCXO5YqpNlQl?=
 =?us-ascii?Q?k6QuF/hORqZIwM1UTi07c9V2l1BhVbOhfokwL8g5QYL99fZSMhuUS8dcKgNV?=
 =?us-ascii?Q?3hRMnKRMcbE/lIAzyAw9KWkDBVWXivJ7VjbFgkRFcgdP1tnZwIhPj1+7vhgx?=
 =?us-ascii?Q?T7P13E+PSbbEOmAVO9vmmaQV61HhwBWgYR6EjCtPPK6dWTXNRCLM7ev/IZgj?=
 =?us-ascii?Q?7Ldo1ARlIt/zqIzSQ+Z+lrOFEbWqGb46ZS7gIPna0V0hXANnpg49BDCr+D/S?=
 =?us-ascii?Q?cGg1zuDQ0Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18d723bb-316c-49d9-0b0c-08de77c8d93f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 19:29:25.8232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DpLA7FfUJaPCXb0GSlpgepU3bVCHItRLhSTrLmdhlr/muqZmEJogeXj8Bv0ZuMA4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6591
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[google.com,kernel.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,linux.microsoft.com,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-72325-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 3F75B1D1525
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 11:25:01AM -0700, Alex Williamson wrote:

> There's obviously a knee jerk reaction that moving PF drivers into
> userspace is a means to circumvent the GPL that was evident at LPC,
> even if the real reason is "in-kernel is hard".

Given we already have GPL licensed kernel drivers for the PFs it
doesn't seem like a reasonable worry to me to fret about some cut down
version of a kernel driver running in userspace.

Further, let's be honest here, the people most interested in all of
this are doing it to support their proprietary VMMs. I'm pushing that
we must have at least a reference implementation in qemu before the
kernel parts should be merged..

Jason


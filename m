Return-Path: <kvm+bounces-72007-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mCJtLeRfoGmMiwQAu9opvQ
	(envelope-from <kvm+bounces-72007-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:59:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E2801A8235
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DBB5D30A8FE7
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F0A3D649B;
	Thu, 26 Feb 2026 14:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J3sjUNcO"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1605C37BE63;
	Thu, 26 Feb 2026 14:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772116866; cv=fail; b=J393AjpPXkdc59TsxMqsWmn8suwjkwCHl4Zo4p6oeVQQoDXxHWqB+dpOVVbbP1WfeVpY2JkUruM1SAXvIrZRdcBP97BFmUP4/wVo42wpdwoyKPlzi2p7O5QeAR4HqI/CMk5/9MkKJBqB2kLICUSzMVibneiI9xdMdLeAjKffgFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772116866; c=relaxed/simple;
	bh=n7JJP9LAmBaFHz2S0pqqYj1X75d8QxceqVLssqZtHco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VyvI6ORe7BtTh5sEuQQkugqqAbZZCSwd3eaNOXJZ0fpzSqkoN0nMV6snUd8arLYR4HvoM+LZFK7zgI5iJskB/1VFW5OqdhfF+gkg4fDuwjqVxkGFPhny3mteJsHtVmxpksaA9rXJXtwmRTH9+ixC9vGUdbGnuM08Ebg3dYYJ7hA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J3sjUNcO; arc=fail smtp.client-ip=40.93.196.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uweKwx4cKX+jH/bYcB8gJRHfY9KzV4FY3tTUvV4pJaA3Bw4uy6HXBaabKln0+jewXKuqd9h0gVot1TskQGRsOYsWhvAV3cgmON0Jesv+BUPyLmN+5UB36x3Nu/y5+tQyLG8XTwkmuyIHosBwU+EUOXwc6nGYY9fWMpxVuJQBysmQ0qmWSz4bLyevci6WCvcrCrRiLni8OOHya5uuH7vjsP/ilordG+vAXFhWPVa2EGRVFQHUKqXISpYZK5mTSBY2GQrxw0gKRmLdqIHpzQqctYPBnfwrKraXyFRgqiKT799mi33DP9Dt9qAFKdIhmyPUodvhNQUtEcps1b3ZbErS3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sdDaeAAnU4gV1IKk4nGwD8n8YGh6K4MhxiDfPH6h48w=;
 b=pOsGHXBqrKhDUIMZO8zvggBt0DTlQkQZgJq5aSGBiX+ZiQTgT/kqe1RGrzLN9lli4wfbNF2znctub7MhyUYcUpP2vpiO8jpJ3i7zZ7J0JCjSEdY7QlDTZp7U/yAr5kUwRovLsNyCYducSEcrL4rqxmSIxeIMsulSX28q++l511UwQwvq1I2QP1hIY7+qmo5rlHUJGrcXGRfcqkNoplShR9+dzR/aN2nR8NQwgT5tni7gWqCpqYzQHS2c27yFWY4Pey0CS+8Da7Gy25li2iWulnPvCVthrUFdKT4/bWLDHVIA6RqLN2NCJDhRx3uucF7hyqICq7UxNyEDf/V29Rk0yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdDaeAAnU4gV1IKk4nGwD8n8YGh6K4MhxiDfPH6h48w=;
 b=J3sjUNcO7wLKIqgSQaTUIWW9SvXrynrdCbwivfvklomJlNdYjfIyNLfag/Cfo6htd+VJLxknLU3x36kNguOyz/l5rNS1pWvjrXYxH+KDdshOxl6C9HRlqH/nU51RFoBNhJQ3zp10Ezf9MSdpBfHf/L4STaX0hVDAFrxYzDSCpEaWB3MvH0doaiUc0mprzePHqvuiQm8gzsCoIdTO0OM+Kg/tjaK0PyWYc9deEMbezWTu7HHurOWcIyce0JsVhzK6XmyK2f1IyTE5JTOqyKD4qhh1atgEXYivzuItMlucH6L0ZgyxlNGXR6YPIlhA97m5SEA8oAlm+SDATfpZlhVtEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB8144.namprd12.prod.outlook.com (2603:10b6:806:337::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Thu, 26 Feb
 2026 14:40:58 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Thu, 26 Feb 2026
 14:40:58 +0000
Date: Thu, 26 Feb 2026 10:40:57 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Alex Williamson <alex@shazbot.org>,
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
Subject: Re: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel
 during Live Update
Message-ID: <20260226144057.GA5933@nvidia.com>
References: <20260129212510.967611-4-dmatlack@google.com>
 <20260225224746.GA3714478@bhelgaas>
 <aZ-Dqi782aafiE_-@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ-Dqi782aafiE_-@google.com>
X-ClientProxiedBy: MN0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:208:52f::31) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB8144:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dd7efbd-26d5-4f61-af6a-08de75450e25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	MYDgBcvoHSdQy4KevnnNKjXu2GT4RvW0p5g5YBpPcZmkoa0EtZw5rv0Jfp4tPTRi5C+8VltNOv61f9tKSp89XwGxeP/vzkoZdubCuMug9F1U2I/8f6iUFfG0jstm/5s1LomO2YD9ZLodsdogCQzSejIO4+75papRHlwU2CTKmePxO6tWZMRzhYJFij7YizxUrYrgirRnhdezLywgC11Rhv6uXBkedX7MPkJUvVMQ72C7tTnUDhXv1mveLONIdAIDM8ssvE7HydCGt7V9LYd7XVX9EJHRoEo8LliyHjMdq3pS9UBVe9XLGQbt4WWdfXdT/d5FXxPbxvOfHnjYxjk4qFi3JT/ljFKW1oaSmW5GwRQanmiXS8XaxwCZ0JthUyug3Eeu8X3z9sons/0b02ANvvX35IZU1aWWA+uNUQ//08KC3SFlAuhDKM+miDdx/1ZAm9lQes7lfdPSQhqIBNgoGO7h3X3ShZSkhz1S4nkzJVPBFbXr4cvyaPnSw4QQPZuxZ5quFIiXBNa1NkKxuDYjtvlugDyYJzViXQ0NDvac7oxB7XisHRo8hSAlmyjWthhJgUKiN7lFqT17PkZQl8/h0lV27qix2Vh33q2HyJ2Ww1jribGg51LeI8HByNVBxBURPRw2IdignP1aeSPaiekDh3NaNTSEorlgpf4ppbMsd69QmGb+HgD/iulqGKLv7BiqErHVxjhbFpLJUcaGyyLJ369MjPvqDfHgQO2lWGAxI6Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xT/Bl07T7SXDuKOVB3WYIw46aKsxtbJY1u1aT4xqeMnbrGUVvmeJSaTEzzNJ?=
 =?us-ascii?Q?hggD0ab8NfU9Ev8TCU2soYP2kwL9P8SrfFbzAjuIyfFU4x88nw30WZxTiPeX?=
 =?us-ascii?Q?shioe3j77r/0jI15a41UY4tPrpJN9yIzcGlQDD9tCE2d5DIA34zTGw4raem+?=
 =?us-ascii?Q?HmTZ2M8KLmNH87ZTeLBTGPxOBkIROSqbdw09Wwh3B1XgXObTlHQN83aUS69M?=
 =?us-ascii?Q?OKlxHbbQmJ1yTTf1J5VKffhkVv8b0KzkbFNerUk/YFTRyNxp6czk9SjYUnnY?=
 =?us-ascii?Q?Cy0OZDAkNNAL5J0KBLP8awG5NB4Rh8wYuhjQvZt5sdklSryJmUFNITSJpUNM?=
 =?us-ascii?Q?HO6kS2RVHQlF2D7PgkHI36d9GQzgbPweyr2SuU5dJwi7ANkGiHSlpZf4YaEF?=
 =?us-ascii?Q?fhPTOJEiQRZ54oXPEPh42DeL2oI/tbmpuxDBtvZmGKId2ucOy36jTbHNQyV+?=
 =?us-ascii?Q?gmDqfBsz7lcBzHFbhh2MFDVlHYlmXvFktDB5a/beVh803sZ+tqqwvOYKCyG1?=
 =?us-ascii?Q?f4oEFDTck+8OZ5ytx2lGxNHcpP0vt96r6RheJ+b18ob1fNYg4n3KcNeGd1JI?=
 =?us-ascii?Q?yEbpYgCeqxyyma4+GYQHQ2WvfyIsSQnoSaz2W5Npxb6Euta2bvxmhCfRiwQV?=
 =?us-ascii?Q?wO08gvvogIBSwCNdOkLvBvFA27ZhX6jnlSdbsIFuEBneyS1EMMLbcShsGT+J?=
 =?us-ascii?Q?2ff1bOzKP+0Fa9/R8mLP7HAk3Ro8+UnPoyY/uLhT4NOF5uTNcnccyCws7KVp?=
 =?us-ascii?Q?tORi8JzcGyVy9IytHrk87CdYPyFetHiQZBy50F34TLQv60siRVFkxfVh9rTA?=
 =?us-ascii?Q?0TcZPvXaytvC0Qx4ylON3V4i4MOh71MGcWy1ivHq9aHsuBGC4NN+wKzAFJ5f?=
 =?us-ascii?Q?+uVxyEAaSXfFH8JYRrFqXN3VhdvMF7PTGpFfMEgkupaUe85iQcgx1L2nInq+?=
 =?us-ascii?Q?o7k2Vju8OxcW2WdZwWMhxr1Hmg8v6helmcUrsDR0TJMUkRdGqkos9ehs3FBd?=
 =?us-ascii?Q?ZXW+LcfEqTYIx8veDwA1EGmzXu4awULSNqM8QF97gxQ8IiN82X9FTJ40rP4m?=
 =?us-ascii?Q?v2tgts+tiJ4l0qvBWjsoWzjDZbwn5DyTOA2Sd/K8Aa3Ne1ogrVJ8qsQNa2fa?=
 =?us-ascii?Q?dTXjgLNHSVPcF8GcX3i+CLQnmSO4Flv0xeB1QmrJpPdOb/gI4yRFkHt6gVUi?=
 =?us-ascii?Q?EzAM/jbyFFx53PYMkM2hOtXend7io0ROONFCjWbaDHoMaantk6rViz7f8m3/?=
 =?us-ascii?Q?QYg9R+9UtMEE9emjlaW9DqeFTHJDhqhFTf+fGJKxuojjeZ8JK4thAf+QGyyJ?=
 =?us-ascii?Q?G6symLvNwTlgJMTXf38uDz8OHYrPdDJVQQV1T/3Tofz2vf55ArEwptUnVCq5?=
 =?us-ascii?Q?hMZK1UycUZTp2ACGpfzom4glWsPDlJO3xgojsJ/cCbMZSFA1KVWtPUyHwXV3?=
 =?us-ascii?Q?9coh40+0zcF5bPmxY9Mho96wpZcAXbPnmQ/Fq26jw6g+ocQvUMbWJhkruRLp?=
 =?us-ascii?Q?FEQ1lU6787G/ur6KqtDu8keSGlYqBGUqlRYxvR8qEz4u7YTk0Do6v0QGirhU?=
 =?us-ascii?Q?/O4YpACFXRTSoeMu1qm6s/HDJzBl0xL1L7pzP+rlK5bH8H5TIbfTyGIJbSpD?=
 =?us-ascii?Q?+PsMWlpPJprlUV6K84H/RFfSbeU7VZSowCE2ZA1AHhV5D2sxSex3GDcXaHpj?=
 =?us-ascii?Q?u7VRaR/5u4lzDJd8UK3tFNNoK4y4uql2uMzWsYflz16BkujtiUKrvfb6iWT7?=
 =?us-ascii?Q?BJ9VhNXBnw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dd7efbd-26d5-4f61-af6a-08de75450e25
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 14:40:58.6401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n9wsfqh3xf69O1SbnL8BWHhxD36Zz4brIEx4QlOAIr+5GRyznCAEqBtTXbWY+xYK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8144
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,linux.microsoft.com,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-72007-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,nvidia.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1E2801A8235
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 11:20:10PM +0000, David Matlack wrote:
> On 2026-02-25 04:47 PM, Bjorn Helgaas wrote:
> > On Thu, Jan 29, 2026 at 09:24:50PM +0000, David Matlack wrote:
> > > Inherit bus numbers from the previous kernel during a Live Update when
> > > one or more PCI devices are being preserved. This is necessary so that
> > > preserved devices can DMA through the IOMMU during a Live Update
> > > (changing bus numbers would break IOMMU translation).
> > 
> > I think changing bus numbers would break DMA regardless of whether an
> > IOMMU is involved.  Completions carrying the data for DMA reads are
> > routed back to the Requester ID of the read.
> 
> Ahh, makes sense. I'll clarify the commit message in the next
> version.

More broadly you can't shouldn't the fabric topology while Memory
Enable is active.

Renumbering or readdressing the fabric requires disabling and flushing
any memory transactions.

From that reasoning it is clearer that you can't do that if the device
is expected to hitlesslly continue performing memory operations.

That may be a clearer long term basis for describing the requirements
here.

Jason


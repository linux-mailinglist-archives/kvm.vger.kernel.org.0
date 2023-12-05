Return-Path: <kvm+bounces-3568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94ACA805567
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EBDE1F21456
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7244F5B1FB;
	Tue,  5 Dec 2023 13:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hx4Gpxlt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8D2120;
	Tue,  5 Dec 2023 05:05:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJLxMwdt+wfVAQyAgiUxKivbVGIOLiHUKV3mKtkz6sRLWcxTKAAj4uPptH7sUb1SnVsfyBOSi5HlSALPsVLr5xrhl5jaE0ZvaGBEoFvT/LICCgNBGU660xmPOWSZjqXaJui9Vfgd9xHyUYgXVIVFaGRTI4Ovx2otatrclsEKusHecIsSzsRMsMauP3teqY0kzqoy101lBXRWJZFKoK0snOo5o0hRrz6xPAO5/7tFxbm+RSm0vj44wWLIT94rEAjOCt5A9tE2bw+bt9foz6FV7unBOXj815jKxf24tMMi1QwF6+uj7T2jMQi1iP6uRj3OqOOjOBmP2KVVaYBEh9PEEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHmnCaZhRlWey4KzVWDVkIaCDfev9jXMQHFofQAnzDY=;
 b=jDPzBxigN1LRJHBqSeFg7OFELLaSq/jMcGPPINU+8KNLNTQ3knfZFf3xAYu8EhbGuLjFWNLe9nCPN8BRUEmspRSJDyR4tQ9tVFj0K9JmelV7E7HuWEtDhqjUXKHQ9TQm5AmSYNT2YUb50KE2Ewc2Q91rhIxfs5rbdsGBwqAb5/a7KAOFwdNiuBSi3ALdugwXUd/GCcGiBp/ABaVs2qF0fFbxpxh7eK5rNQen26yFs4KtWf9sospbKJBQ+ARg37D+iogTSr+oNqV7r9iS8b8lerPrCRlKqrs/3pf3uhy6qwl3BqYsOCQIIdKxrpSCD8lFDl480rDuNeLQ2IJrI2vpoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHmnCaZhRlWey4KzVWDVkIaCDfev9jXMQHFofQAnzDY=;
 b=hx4GpxltnaCc3YXWjRndzvJY6CGza5PKGbCcYRHGcaoNR/kNgB4ILCjBCx3Wo47nY4qafKHY6fNVBFmrkxRoolaOrZ6MFKiLkYMu36CV5aHyvdSu+8ezk79UeuQfpNSnGkM0dtD8roKgV3N57jeoQJwuxITJmRjUEHMdg2gHjT1xNUXYwp/2Vk1f/kL43UHkqN5BZDtSrEYeml7BCaSMiBfo4xFmPFoWWoq+XWmXFcBFJ9MIOgTsW/SdOfoEzBi6yulaAvKmdRl3Q93XML8seodzSArFUCy+mXNIJBEg3bBHMP6/qxbHP2GVzJxsES0ZlJlS97vG/lkz5rtY3T5HIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6738.namprd12.prod.outlook.com (2603:10b6:510:1a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Tue, 5 Dec
 2023 13:05:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 13:05:18 +0000
Date: Tue, 5 Dec 2023 09:05:17 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, lpieralisi@kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <20231205130517.GD2692119@nvidia.com>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW8MP2tDt4_9ROBz@arm.com>
X-ClientProxiedBy: BLAPR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:208:335::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6738:EE_
X-MS-Office365-Filtering-Correlation-Id: bb5669e1-140f-49c5-c9d2-08dbf592d4a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QCBz3Ge2Y/nbrY60U5iWSZ21iXDjOr8bx3u/vumLHCxagj6aE41YX223Q7Me71oARAGYb5atbYJpQbeo3iS9svw4GRqXTniNlryI/vA1Hmj4l2FPPbTV7CTxzCZPqSiIcTlBbQeuA9Yw2t25sBkllkOSGeC3WB9JIO9T3AKFgfKLPwjCgRFdhfzf1FHCc+yYnkvHjyt6d5UXi5SLZUYBtgqxGKA/iy8KTM+7AvtaEMbzcYxLSv/y6pGitOQQ7l/wI04VwJrN59NPrVh5DKaoZd98Fu8ruIyTfb8dTeZO/+RrNlF8deuvVZcTQNMKKmlzn3BhSJlhg+tIvLJ+koyvcTqz5gJ4NgNVOImDqaJmWJL8tFHo9wynQFV0f5YS5pCOobUx8MFopdRwY1Jz6OuFPMzoPscJKMSEXGp/IdcBpiD4dQr/YgTaOX70vUH9JY0w6cERIv3MNJP+WBxSGnbOk4cWuAPlvOwGyHS9Qig4aLT3Qoo4w7LpmXQcZ7pYKPrNPpGSUwhGD0KvsJ9pM09OK3BF3/1CF2wr3fBc84psF6vQ9Nu1w7ZyocbFdVz2zRKEV0yq4wV3owi9zmlEI7J3krFF0/K8TjDI+CYEj9ATp0E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(376002)(396003)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(83380400001)(6916009)(7416002)(41300700001)(36756003)(66946007)(5660300002)(66556008)(26005)(1076003)(38100700002)(6506007)(2616005)(6512007)(33656002)(2906002)(966005)(66476007)(478600001)(6486002)(316002)(86362001)(54906003)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e7bNus6lxkkGg3qK6NnYfg57Pjw1hptAHOjGhq2kimQN+zPDNlnl8r62eSzw?=
 =?us-ascii?Q?8dxnhVSFCIJOYCzWxMQxcjZTmRxX3KWiM/VsnmtgEqixhKvCYCJQrtMXmVR6?=
 =?us-ascii?Q?EsrH+dio0QTiXwp1LE8ko982r28kHY8PFIrYix6kex0HSOF2MkgwOGNfxnNE?=
 =?us-ascii?Q?X+XqIg7V/bHFebVJt5QZ0Kkr7un1QtiE2uoYUDrkZhGUAtv+U68yrifUlpkS?=
 =?us-ascii?Q?fj/OdnMxDdB4U2zHETRjBIwx20AuroL8lHVTyD1fJNsLWomWV5kSKjZgSg8o?=
 =?us-ascii?Q?Wh5CLQhedgsxGgqWUkuriDaGS54G18L3F7HPo4IoIWe1C9lJoGz0YqJnTL/L?=
 =?us-ascii?Q?xOIFrNvTRloquThfLA1Y2wRSCUMAPYjBuCFT7HVtW8V9YHzvvbKWp/0NR8KA?=
 =?us-ascii?Q?ol+Kmv33spEwRy5YKcN7sE0XXA1SwT4m+rtWf8ncN198T+k8UTX/cK/8c04E?=
 =?us-ascii?Q?Thx7hkn2A67P1JakDlSBF4XmXMyay3scINrlReTrPx5GqrkT8TQgH/pC5rko?=
 =?us-ascii?Q?xFI+s1cjFskjrmH334vnOFyoS/XahGrxeQO5PgPhj3vRDmLv7rLZGFI7q/wO?=
 =?us-ascii?Q?UNsvHkxqY55VM2i161aM7YtJ4FP6Lv8KY/xCQX1JqsRHmZkk1lpNy8TAt4gI?=
 =?us-ascii?Q?jd8spf6UK2fWUMUQmUhyXbYEuaeqiQeWM+UC/1BQMz1sAOegA9LsZ4VmPO7d?=
 =?us-ascii?Q?yqmyKqbHUD5mGRDRrFdQUhTT0SVQuUeBHrOO3eany3i/+imkFZjb38vkBdnP?=
 =?us-ascii?Q?vENZ5ufbjTPbfWnH1DTYLA7p8Ma9wsNAw1y7POr76zzM8hdeP3WKjTkOg7sS?=
 =?us-ascii?Q?MAZ8N6DNBbRXpywl+B+Ltslglw8BWIaXfXnc6xU2xTCn8xzZPp+fasAGtX+z?=
 =?us-ascii?Q?w0FyUUM37UvFhYCA2TDQhRhLqE4AZ69b/3dAZfVqdNpcjIs2ZBv++8ybs57p?=
 =?us-ascii?Q?mYl5a5tdD2ADHTJGfn35+iLRGpp8K9qd3r5o06UUXeUJRwGWKzoFGB3TzZ4K?=
 =?us-ascii?Q?WBbHqYpar531t50sCkpB8cXHUCBNBR/sVg2VRVHHazJ0tJyBJa1iWgMe7K5Z?=
 =?us-ascii?Q?pmB6+6bxoZBYjJCOzcEf+E9aL3krqXaQ5UvErVYI+0uCLuwbV8953VqRNzP7?=
 =?us-ascii?Q?yTLAoiUotR94mWsWv7CahIC9UZD/O1eEYFA8vedFmWl6yRpZ+LFTvmYgOoBj?=
 =?us-ascii?Q?9UbrTahn1S2RlVf4ZQYNAfOzq2gg4g1PFzdFAnBSoI+xQW85Mkfk2rZfxAXF?=
 =?us-ascii?Q?wLaxY2VaHM+BA6xcZNeRbil3pkpnOsJPTMzl2WN1W8QTdgn2Txgi8rNeeDFQ?=
 =?us-ascii?Q?vUh9w7Ds3BAzs7TlVoZVuc4ffENm5Ry0St7DtCxUGdTYN0oP4t6pr454ytbp?=
 =?us-ascii?Q?Ohi+mo04pBGRr9P7bhFnbudB5nBAtMJK8Ck02oMTnNzwLorBIhsBwidTuxSe?=
 =?us-ascii?Q?4aI5qrhhWBnPTUqaxfZ389ui3mosiKW+y5hz10TiLZHMEe++t1E+7sNTgZ27?=
 =?us-ascii?Q?3ntiVWcnya1tRX7KoViY2ubEd+KDLc9AiaTmOJzAk30NNoCJzYghiRO8jEtx?=
 =?us-ascii?Q?PYFUZhy7xgo7gKUKcMZNQ0zYoOElsEU9QVVfNUBd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5669e1-140f-49c5-c9d2-08dbf592d4a1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 13:05:18.6264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWCuyrMlPwTvPFym0+leD+qRh3BN+nTC1KGGWzyP6pcaazBh6tFBufM55PQIBoEn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6738

On Tue, Dec 05, 2023 at 11:40:47AM +0000, Catalin Marinas wrote:
> > - Will had unanswered questions in another part of the thread:
> > 
> >   https://lore.kernel.org/all/20231013092954.GB13524@willie-the-truck/
> > 
> >   Can someone please help concluding it?
> 
> Is this about reclaiming the device? I think we concluded that we can't
> generalise this beyond PCIe, though not sure there was any formal
> statement to that thread. The other point Will had was around stating
> in the commit message why we only relax this to Normal NC. I haven't
> checked the commit message yet, it needs careful reading ;).

Not quite, we said reclaiming is VFIO's problem and if VFIO can't
reliably reclaim a device it shouldn't create it in the first place.

Again, I think alot of this is trying to take VFIO problems into KVM.

VFIO devices should not exist if they pose a harm to the system. If
VFIO decided to create the devices anyhow (eg admin override or
something) then it is not KVM's job to do any further enforcement.

Remember, the feedback we got from the CPU architects was that even
DEVICE_* will experience an uncontained failure if the device tiggers
an error response in shipping ARM IP.

The reason PCIe is safe is because the PCI bridge does not generate
errors in the first place!

Thus, the way a platform device can actually be safe is if it too
never generates errors in the first place! Obviously this approach
works just as well with NORMAL_NC.

If a platform device does generate errors then we shouldn't expect
containment at all, and the memory type has no bearing on the
safety. The correct answer is to block these platform devices from
VFIO/KVM/etc because they can trigger uncontained failures.

If you have learned something different then please share it..

IOW, what is the practical scenario where DEVICE_* has contained
errors but NORMAL_NC does not?

Jason


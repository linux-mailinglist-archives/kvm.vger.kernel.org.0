Return-Path: <kvm+bounces-3348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9329E803709
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:37:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B58521C20B93
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C7628DD1;
	Mon,  4 Dec 2023 14:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="krqqZb8q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1381728;
	Mon,  4 Dec 2023 06:36:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eyJfKcLGBDKP0r1u2mAN/kv/OqQpOERlzSkFAA/QEHWcGLKwpbTAlNySZdFdWcZNF+F62100JtglqihRhf5dWiP0+BjJosmKNZuQmCF0AD3QeSZL6xoAzGmpEN9AaH7uz8T12LcJenGL0TVGz6lPUxV8MYeeK6SpDVQCP4IcVkYe44SiOdA8tDBVESCUST28NgMueqbKOTbHotxR8m8B05XVhV5DFQRy3n2aB5N2+3NUrDvWYJaIFg9BmnoO2Ocq+LrhyRAlUwjyY1gRkkj7P3cqD3uLSXO9HPKOQB83GY33rRIXyJhiEDC8N53EuXOpvQSs59jOSnUbu1FGj9mvew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhEw8yhQo8smSQ+6mRtsnELMSExMXUfZatW0dZY5K5g=;
 b=UQMO3auQfx/CjidRUufYIXkc219VoAHLxyecjnjNhd41E6thrZetXXJiuRxyuY5jl32Ld4Mv4HKacN+TTkLd8uO5qb0Fd3I8svRPAkkrsRPP1OvHKeCHBc2qLkpQ+iBcraXsbTCCLASq1xvYP0yQj2xpgc0AdBld5NJxVv+wRtP1gb43lYkfdlp50huWWi9jD43DA3Y8BHNC5qjNVmpjfAAOiqABhEWM99lDiHAw8ZUt5dZoupfpUMmz7tzx/mDQU3Bh6zCGn1sUyHzEGW5R0Q67wnbVMIhJgOmpm8RfhXSAWTYjiHAKeGvFp2tliXH/NUTc5qUA5n+CTaRp/5iqug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhEw8yhQo8smSQ+6mRtsnELMSExMXUfZatW0dZY5K5g=;
 b=krqqZb8qwikCfSCMfstIuPwameE+r/3qfFyx4JytNkcE4q/L4V/KzPGbShe1u9nUjTJY6DtFstg+Hp42HWS4jkvQ1VH8XNcM+ewdla5VV0sbH9YuUuZ/SNncppTF0Xm9ecgPLRtbgSpUD7u2g+HxugrPHYV5X0H9uuEjlkMekUMZr1WwPQs0bQPHiitmJoHx3DlzbcfauF9022zY8H3RS4SK6jN1fjEskiO3f36KzNRh0eovq5ExkBU/z27tbaFhyJZKhwZXs2o6Mh0/7H5xmrvcYfD/YU8SoPEG4eVGqB7fQadOBb4zfQS1IGoLO4plzt1Bt5vZQeaRayfyB1XFKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5110.namprd12.prod.outlook.com (2603:10b6:208:312::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Mon, 4 Dec
 2023 14:36:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 14:36:51 +0000
Date: Mon, 4 Dec 2023 10:36:50 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Borislav Petkov <bp@alien8.de>
Cc: ankita@nvidia.com, alex.williamson@redhat.com, naoya.horiguchi@nec.com,
	akpm@linux-foundation.org, tony.luck@intel.com,
	linmiaohe@huawei.com, rafael@kernel.org, lenb@kernel.org,
	james.morse@arm.com, shiju.jose@huawei.com, bhelgaas@google.com,
	pabeni@redhat.com, yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, anuaggarwal@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, mochs@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm: Change ghes code to allow poison of
 non-struct pfn
Message-ID: <20231204143650.GB1493156@nvidia.com>
References: <20231123003513.24292-1-ankita@nvidia.com>
 <20231123003513.24292-4-ankita@nvidia.com>
 <20231202232319.GAZWu8Z6gsLp1kI5Dw@fat_crate.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231202232319.GAZWu8Z6gsLp1kI5Dw@fat_crate.local>
X-ClientProxiedBy: BL1PR13CA0075.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5110:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f5076a9-00ba-45f2-9a27-08dbf4d673f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qFaGEZjqK48HfSpYYYZrG22ajkBcC0+n2vj/gKIhzb2tv1PBq4kncVvviGyh7h5feqYPGB3FQSbaOq4JWV1xoH24tVggqp8zIzmbcFxbvQKqHXMs7t0nzMMI8boFN4t3BlFis6mIeGhngZa7aX3WK60L0LASqaUXXys3PSiv1jPQonfgLobqILKgHHrFQXMEtTi3JZHPVFi9VhVIHLA3NCfczgx1yREPjFfY3h8E26SrD7kWs07jUfEQG4FvJz/f+L5GYBZ8SfLeTNtIeSFkDKzK9uZ+WPCefrevwdVxmMWFwZzvBQfale/oQt3D8jVZB2kRjItUSeLRus0z+aLdYGZmfrvrH5Oq284nUicyHsP2S/9kwvhtDGro1a6kR9ikOXmxQ0pBQfgvFXoe1EZ+VCdCuWrAnX+eZd3EaShC20XubKH4OKvY60i6eAqyJ3+WYC0YjVGPTNz0zcHBKSPVp+xRH4vNFej0THHyWZFJ8VsRKeIPqOeWHvsDJ4KMQg0RqVxgQk/JFd7j7lKPi+vikjFqcCGnp6GrizM2r5AL1jIPvu24z602Kd5e2N8J/2cu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(136003)(39860400002)(396003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(478600001)(26005)(6486002)(83380400001)(6512007)(6506007)(1076003)(36756003)(2616005)(316002)(6916009)(66476007)(66946007)(66556008)(38100700002)(5660300002)(86362001)(4326008)(2906002)(8936002)(8676002)(7416002)(4744005)(41300700001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8XTRJ0y5qOe8OVBCwqk8Ag92yJj36qBdidDhEXh8PTOAKipZjZmUk7bw53tJ?=
 =?us-ascii?Q?1wItBiX9hBPVcuQccbTQDE9NebRmb12Po/FxwZYVJ5glmM+2aPkLMcdUMX5C?=
 =?us-ascii?Q?kegfA5IknuAGvipJVeyqjKzJAMNjzsrKp/OC1UpvB595dhLtRTqseU3sX7hC?=
 =?us-ascii?Q?kdqybMb+cWbduvkV3FV4lOaw5CaCOzq9+w84bwIJshx8G4CiV2yHlZQK0sHh?=
 =?us-ascii?Q?T6XHn97vJO15cCzljdcMSk+ukx8rQE/U4vOcC5RbBPeVEqdeU0R+qVlHo08n?=
 =?us-ascii?Q?MmqAYpoGmjHvXsahvyqnq6vgWGDzAkiBzBVrQ3Mvui+KlI19DEScEAD6mkyC?=
 =?us-ascii?Q?kr/Sp0TSXslAOLnX6wOxTHXnXbWCCeB4zNci/3dWQmkdYDfoLK1WclIuCCio?=
 =?us-ascii?Q?ant7MS/hwLAinZ3I3eUFTItnwfvOZWNdBALPnNaJ2E2KA0KLow+WYwBYopqI?=
 =?us-ascii?Q?VM9utvDS3okVtaoEY1sFe33f8oL0VRA7UwecErnruYUEuGBB9iiiAmlboE7o?=
 =?us-ascii?Q?EwgoWgPvSZVpNPkVikhMV5xfqTka5OO9OSe9lk8hKa7mAmpihJGfTzPuE3kI?=
 =?us-ascii?Q?kFaIHx9zkGpgXacitg0YIM9TF608x8F69+v/65esG5x3Sz4Hx9StL+4NjWws?=
 =?us-ascii?Q?IX2tPd0yNBYPKW3ExDCGPS7WnCvn3vJe5/us6GvINblBMjq0qqCdi5tOY9/U?=
 =?us-ascii?Q?213JFZF5Ur4ZF7H7etsKgqi52VlU0LroshGQYJ/pugHbfdh3koLOP1pI2Ybz?=
 =?us-ascii?Q?nTXIQTirg7lMDqjKLJWyRYpuF47ikbIuBUIMY36pzNKPk71olk6h9JGDHUGB?=
 =?us-ascii?Q?SdNwjeAAJ/lBU2gepCaBGoRXEaeZWW+LaTluS/o/tG1Ha6ln/wxTX8g7dbWb?=
 =?us-ascii?Q?rffjCe8/++sxgCZEllnXd5oGtXZ0NLz7FLD8zZlqJIhA5hnqiAwNUfp6hXnP?=
 =?us-ascii?Q?LBo5Hz+wNBbwUjdr2E5L+CdQIJOKtmlnhhn9dmEOfbxqoYH/l68axL/7s5x6?=
 =?us-ascii?Q?TVMwGmOBEZ7BbE8xQsqOBhqkSabVC0wvh/E8U9fZGF/4jWvQH0U2jht6cyWt?=
 =?us-ascii?Q?R0HuzGjt+ZyD9p9vlqLx84ZcgNRgox+Ro6+eJpx+Mr/Hoes5/Qa6VjlfOFof?=
 =?us-ascii?Q?u0U1wPPoWNegYHKudVBO8OD0MLnkoDOlmUDkm9k5ObwB+dlGHpYWTAVPO8aE?=
 =?us-ascii?Q?eKltx7yE7YHEWZPqEV2UIdCvoh3tqF9hgYbp/VK2a9VSdK70dZ2+/Z0c2n9h?=
 =?us-ascii?Q?WHcdDT/mHGVaWUwH7oO2W+6n48e13x18dDjtPEv/X0z//f+8MXYvx5aqNsWp?=
 =?us-ascii?Q?vsA+owenTC7QsOAHQTTH9HUXi6/WeulMewTsF1gf9PicjGFibTOZnzDGip6X?=
 =?us-ascii?Q?H+GNYk0obqsKxiKw0X7eMBuWUDv5ttIXp71jwvtzjkm+3ZMHAZpD0rnsz13u?=
 =?us-ascii?Q?FJTgkduhyhyIH3ujYkl9eiuHVPcBu6p/vpEacL3Iux7X76T2V5KVGsHunhI/?=
 =?us-ascii?Q?gvQW7d8Rgq/kyhX/03YYwILqv3337ubA06Ovg48Rmi7X+eSVGh0jQWOZ9Dec?=
 =?us-ascii?Q?CGxNFCOhn3Aj0YSU5mDxJTlZQDNcZ3MOHpCnvLY0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f5076a9-00ba-45f2-9a27-08dbf4d673f8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 14:36:51.1206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +EI32Z4t7c+rBB+jcvB3z6Yjfbr+bCHqGdpequP2Co8hjITionB9JvE+uICnAobR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5110

On Sun, Dec 03, 2023 at 12:23:19AM +0100, Borislav Petkov wrote:
> On Thu, Nov 23, 2023 at 06:05:11AM +0530, ankita@nvidia.com wrote:
> > -	pfn = PHYS_PFN(physical_addr);
> > -	if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
> > -		pr_warn_ratelimited(FW_WARN GHES_PFX
> > -		"Invalid address in generic error data: %#llx\n",
> > -		physical_addr);
> > -		return false;
> > -	}
> 
> You don't just remove a pfn valid test just because your weird device
> can't stomach it - you extend it, like

It wasn't removed. patch 1 moved it to memory_failure() where it makes
a lot more sense.

Jason


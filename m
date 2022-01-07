Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F86548799D
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 16:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348065AbiAGPSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 10:18:13 -0500
Received: from mail-bn7nam10on2080.outbound.protection.outlook.com ([40.107.92.80]:51129
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239617AbiAGPSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 10:18:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bqu428lP1hnTrSghXusUV0pY2y6EcChyOR60SZZnPUQx2SWgzbVMTy1Leqt3uOiGcWSB4py/Nol65Nk7oK0ewtZxUzW4gBkbFQUsB8h9/PriKdKeTFwXtllVXRuWeLamt8rLxOrLXXC7CMABVI3sblk+RXYgmW5aeSirexp4AU4XXWSagdByVHjePizlY8uadYyRNfJD51yTTSAngT2kCO2YLuOQdaomrc9G+1WIj854++tpSCLnRO4yOo7uZZdptOd+EtPTol/kiCaFqlGzIQSR2D6XHCwXUWle2X5Rr1qKqLgyWZg/jzZRxg/CXBcJ4fEawjffmudJ5C4OKF6cxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjWUcS1DVHQJa0StZNqi25FwkP/KNEXsNdT9IcysAPk=;
 b=Hh77D/QBuRAn3+Zb+A2kOvs7ko440n0mwre0udmAL573aGCxZfGlEul/0RInji1yf87a3S+lYhlzYjndvu94r5qiXfqLWqteWzH3NU/ujA9hsvZlQEMah75ZLyvmQYbElhXIW7+rr02ZtAK6B4PA7SDxzkgWnrLzuz9lmGMB+HSOV/Jl4c8GHwFJ7fQWh53K1EgNROhhRfTbV/BjhbXJQOtfLC/7IyCEk57roTlJsSaWloJH4d0xv9fsrkSTrZqG1XdmuUVaH+2ENkdeCT4gOpafE+iT8PFhc2PftPpaoLVQ8ObmRowFN9V7+Hac3scc2aDQ+D2bPbrg/Xd4i8C70Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjWUcS1DVHQJa0StZNqi25FwkP/KNEXsNdT9IcysAPk=;
 b=XW5ONKexMsZpSpS+ZstQAw7KZxTxAFRcwA2ApbQCwllF3vtJCYTPUBlIYM+NcFUg2ID9faFhaGKJ4GczY7hpuyZWuTfUbR30f5AI9gmz6eCtENgY+JC9KAz8+oImt1fycoYS6rIkuXC6Gjew3wqeUG7PT9rN3DGWhBb2EiNhTn2tTOX5TVSewbGqnajZS5jIy7JX04sppYi5t3DuSxBNFAV/X4B5RrbV/CI0qHQJmbMcZAigN9I6VYgYyzt+vq26dpQkdKWfPURmy8jPIGCWxHP8xld6Y9hriPiep1Kl9lTCT+99CyqrRRYzvuM6lVoEpooia8RkGmtYbNzfjkilyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5378.namprd12.prod.outlook.com (2603:10b6:208:31d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 15:18:09 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 15:18:09 +0000
Date:   Fri, 7 Jan 2022 11:18:07 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 08/16] vfio/type1: Cache locked_vm to ease mmap_lock
 contention
Message-ID: <20220107151807.GT2328285@nvidia.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-9-daniel.m.jordan@oracle.com>
 <20220106005339.GX2328285@nvidia.com>
 <20220106011708.6ajbhzgreevu62gl@oracle.com>
 <20220106123456.GZ2328285@nvidia.com>
 <20220106140527.5c292d34.alex.williamson@redhat.com>
 <20220107001945.GN2328285@nvidia.com>
 <20220107030642.re2d7gkfndbtzb6v@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107030642.re2d7gkfndbtzb6v@oracle.com>
X-ClientProxiedBy: BLAPR03CA0082.namprd03.prod.outlook.com
 (2603:10b6:208:329::27) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c821ef8-3639-40d2-59ea-08d9d1f0e96d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5378:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB537886ACE31793F3C791FF73C24D9@BL1PR12MB5378.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xruv4VKKckSEBEymxb3p0ANLtdqDhqXQGHFefv9HkaVhPIOQwN37qgnGb5DcbzUierx7PFG5efpKaJuTOCy8MmTPzdGmpG6MOOsRAVqUadSGkchcHJMCEDOHJlNbSD1wRf93QJbfivnr7ehxNnsyXu9sf5WIKl+YwJOm1s07v2YodvmKpUuYEEE/ZJLnbLNtyuhejo2NgSuFYIJbXjKJEJ/AJE2ECCZvwgkWr5wNhwdrvad2D9e+1dKdS8LEhzSOjeZ8/Aj5IabdZz9LnVIjatzLPsebm06vi/gSKmEkDRH0c86WwCPe7hsIszzZu3Kj8jiFnmEwczjUvPdo6l7qkSAu41eSqlbiaPLEA3rVEUeVu3pRYvsnuzNsd8vxiXfehq3RTlH3B/ELH7tZNab3/UYAY4JE3cZ16xRQcSrbDCh7oo2iSamPfufM+6nvHz438TyHQFDSNZHP5VbICJH8u2XdfzebxoFThkHsEDdUG/U/U4FuFh8lSGt8jNgkQdJSB936sxBe1SBN7j/ELIsAeRku0UfnFosEprFc9IvC/IgCOXKR1b5R0Ll05MIlYqBnXylfDaivvFB6yWEq8QViLxGluhNAcOSxyHD8ywHkKUMg4ZmIbIWPKgEkSOsJUB7zEibgj6Mf8bBvIxzSIV0fRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(38100700002)(316002)(6506007)(2906002)(33656002)(6916009)(7416002)(36756003)(508600001)(66946007)(5660300002)(8936002)(26005)(86362001)(54906003)(186003)(1076003)(8676002)(66476007)(6512007)(4326008)(2616005)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BM0KVRpe6h7S44Fyrkf63b+YChv8Upzl+dzJyj5MKvf0CZV99NpRxwpCVbFX?=
 =?us-ascii?Q?AlKjGQC5h7d2LCqJKTIqIicq/ZNLM+xODpUFDgILYlwUsWq/hIZcZQOJQXeH?=
 =?us-ascii?Q?05CI1qTKUPYjEWgLrMwB6a22QaFjvV++5Dpfs6U8m9UOrSiBqLGwNfLkRa/j?=
 =?us-ascii?Q?kBtfgLBVZcFH3tQrcSOWM3OqiUL23XW/JfofrTiEQKxfVv1o+ntWnc4nxYlW?=
 =?us-ascii?Q?Qdip6X28eJU5uPo9z9QvatTLk4m4e70w9cej8ZKk5Z/aQAsM8as4JDiQkBZ0?=
 =?us-ascii?Q?Qsps5XUpHhat33IcI9jFJnq27iyHQ8LmdyA2HCnUgMy+SIa4eGrYCGODMU2J?=
 =?us-ascii?Q?S3ZwCnNdlZ1e+tx2nocVNSPncKTdRZeIWBVJAdRoefokKHIsY7hooIjq3eOz?=
 =?us-ascii?Q?IOE6tXYEf8nuVyzxw2KoRAXPwcZ2RoHZQmJwSeIQZGpIudZtf5xgLpB0hX5n?=
 =?us-ascii?Q?DVshzp/9S8eiVCs2bldmiq5YgKPncnuZW1KYrYc2p8n5enGhqHCf2ypjMRnu?=
 =?us-ascii?Q?fu1HqAlPcnvwyFWf0i8fnUM/E8ZHSp67ozp5d6j5j3KBc1rcUinDz+HiLVsh?=
 =?us-ascii?Q?lrpLw8cAJWgkPl5aM0TI8nvSDLeT5cQEep9bHJep0BfapDE3cqr29qBaIGd9?=
 =?us-ascii?Q?KRvS6XzwYbv7tGfRrTqEgXn5BU/83/IME07r4zPGsmBg0euso5xsDcYteWhJ?=
 =?us-ascii?Q?dd3L60TXEaHsdN2VlGMOicGFSffZ7InRPu1NgeBLE/caUt+i6zDoKp14aNBM?=
 =?us-ascii?Q?0W4+Uim2RY5/ge6YfE8ePROP+H8uC+YXrp65VrP6J+RR97BRkhU+zXYhVMvW?=
 =?us-ascii?Q?7NB/QBNALKBQGRYjNQN1LIN/vKeyn4ev0qXCHJPg+w2KSKH8yOtSJCpXYClU?=
 =?us-ascii?Q?wYltNru3Zubl/bbAW8q3ByOzt12IkjCETvjkGrHRPT/tj9PxnA/ZVGECz6lE?=
 =?us-ascii?Q?LU2TTX1mb0i4D8mnjajuuCnNX0UkADglftSV7lxdIYlz/Jg/kHnz5x18pFE+?=
 =?us-ascii?Q?N8ISdoT/ctncL+4snggVmUgwGMEAq8rJJT948yoGfkvfC7ZEAzO6LinjoM+R?=
 =?us-ascii?Q?VWqJFWKjaGeZ81JylzxZgQfh6e3IRsc83UrYyHaVonGeJYXofjqUYF4FdQ47?=
 =?us-ascii?Q?ly08mG58ywgQeHU19pWfE1VN0DwYvulkfMZgofmDEMK/10c/L2CQX4OfCSZ2?=
 =?us-ascii?Q?xdF+yfjfq28zjBW3C+/RTSO39GTNXgBjAVZ7+/5lCKSX74dBnKrO7D7kaZhg?=
 =?us-ascii?Q?6JAbdujKB15tFhxmp0rw6nSB9r+K7UZswkedbty8SXpmFoZQHQNHkpq78QLJ?=
 =?us-ascii?Q?5piKeD2sYdyktL/rxJvWFTx8eYZME+oPzEdU2duUSjXVL52qqxTdBqFsvD3Q?=
 =?us-ascii?Q?1odQp02FFp++pNy87a1lOIRVNTWJ5GG89sW6/RYLjYqcNrOQCDoEFpPElC0U?=
 =?us-ascii?Q?Gv8yETdfxe1OHJwZFTzxbLfXDf4jPTseVCVEC/RhRVHThSZ0WxMEz8CTEAbJ?=
 =?us-ascii?Q?iemVr5B7tVwfq7QLNSvvewBEzPJ4L6PFeE97zMqIklbCniVo2w2DtjP/z3td?=
 =?us-ascii?Q?RLtRyvrzkdrnjOqiaIU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c821ef8-3639-40d2-59ea-08d9d1f0e96d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:18:09.1530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WZnUXwvOVhESJXbfhGTf+YWscx4mRCOYDVdJ2RNRj39FffzrA6u3fQ3JIiud4rpj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5378
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022 at 10:06:42PM -0500, Daniel Jordan wrote:

> > At least it seems like it is not an insurmountable problem if it makes
> > an appreciable difference..
> 
> Ok, I can think more about this.

Unfortunately iommufd is not quite ready yet, otherwise I might
suggest just focus on that not type 1 optimizations. Depends on your
timeframe I suppose.

> > After seeing Daniels's patches I've been wondering if the pin step in
> > iommufd's draft could be parallized on a per-map basis without too
> > much trouble. It might give Daniel a way to do a quick approach
> > comparison..
> 
> Sorry, comparison between what?  I can take a look at iommufd tomorrow
> though and see if your comment makes more sense.

I think it might be easier to change the iommufd locking than the
type1 locking to allow kernel-side parallel map ioctls. It is already
almost properly locked for this right now, just the iopt lock covers a
little bit too much.

It could give some idea what kind of performance user managed
concurrency gives vs kernel auto threading.

Jason

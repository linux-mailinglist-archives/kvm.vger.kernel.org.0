Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F88E3B66B6
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 18:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbhF1Q2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 12:28:36 -0400
Received: from mail-mw2nam12on2060.outbound.protection.outlook.com ([40.107.244.60]:7763
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231472AbhF1Q2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 12:28:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UftTFqCvTT0ZutOKBheJ2H6lQF1R+CSTdVzmVWEh0v7xyZXQXrpRRH8IL+UG3w2WwyFj0NReTEG874sDzBTTD9YtMSmNSdOET1kim5BfpvDbMQL/j1Arkh3Hw+V0Bs30fziQmqlAtIe8jwZakv8SItIp+YTNwtzIyQR2JpqAyXtt//Wv5eB/iWD1aQQ6wJ3chcZ0DCY5cmTFCVDzOqwyIwvADzkgtNaxVoaBya8hPYm/OLiyJPah9FVZac9AMLWGpZkTR8mX8OU5b1H+5QDRF02tx2h8CQNIlrUC+js1zh3N0Ur3IDtDx9GI+FqtNI5GRl0nvzZUXrvKHTFEqNCaBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HD1qgjSAiL9lE/VgoH6PNKRjdPp5G9mVXFNvZfrAS04=;
 b=WlGpa7UoTqucCtXyg75Nq2oaMnMwqFatawyA5h7v68TgppNiKgQh2Kt2yIUAnDFFB6nWJ3rzucenMdAZX0Def3dIXk/zW4yqGAit8sG/bGBFqJGI0unVORAFFM0VIjJVOzSIaDcpU+STSYBf7wcB6mY90mqQPV26ebABCr/3wVlWiEUuMPeDp4+oew45EeILyeg/wYjqR56EYA19xam45jvLF4GIhhjxjf2zZZKuIKrTtsBpRPNbHe5batOK0YALtz/+Xe0CpHRFqgnhqBbxT9lN7TgjltFmGXqVJ2lKxxT8OfgQhkY49B0eRQfbVPkgFMnePZoOC5h54tXOw5mPtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HD1qgjSAiL9lE/VgoH6PNKRjdPp5G9mVXFNvZfrAS04=;
 b=JDUD4hRP+eYwvqyjQt3eWmRh2z30NNf3cD9wgnKpesUhWikhhylK0Hxco2GnXOdcMcD7eu4JLnKyHwgSrK69T4720BJx5yOl3lCE17NkjqCYcOBHF9ODAt83xrQ6+GwXDzT8dYGy8Va3kRlDbxCzfNk3e5JhP4SkN0/UG22bdMFjB0fOibbFrp6sJPJIcWvs6rC4OnQ+cRtJJ38T+blDKzSGN0BcCbwaOxYQTeivgi6fMyiDtLmYezLdtMamfa6gpgAjVz3/rkA1dAL5hADHUTWsfKJAt/T1Z4YXd8rJv80GPsdaITStIssVPP+4q+Fml77cEEZdqxmyVFgkPG/n9A==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Mon, 28 Jun
 2021 16:26:06 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 16:26:06 +0000
Date:   Mon, 28 Jun 2021 13:26:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210628162604.GE4459@nvidia.com>
References: <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210617151452.08beadae.alex.williamson@redhat.com>
 <20210618001956.GA1987166@nvidia.com>
 <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210618182306.GI1002214@nvidia.com>
 <BN9PR11MB5433B9C0577CF0BD8EFCC9BC8C069@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210625143616.GT2371267@nvidia.com>
 <BN9PR11MB543382665D34E58155A9593C8C039@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB543382665D34E58155A9593C8C039@BN9PR11MB5433.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR18CA0011.namprd18.prod.outlook.com
 (2603:10b6:208:23c::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR18CA0011.namprd18.prod.outlook.com (2603:10b6:208:23c::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Mon, 28 Jun 2021 16:26:06 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lxu5E-000evq-FL; Mon, 28 Jun 2021 13:26:04 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 805a388f-c048-4ac2-5421-08d93a516e09
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53625AA935CE01668230043DC2039@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZwAtVgiuoPhFtwibLePnJ2XWVqsCnjNYND6n9zvGGAVOeuj01jNSm1wGRhJP2QB0JPWbmrpV8n8IlGNb1SZQZASpyF6tonWLdONMoszngUTBUDYWRgBeA0C7PyZV1j0tFlIia6wVKq2c11qGqaaIXWyvBDVXejy6mgP6RkYhDLoWvvx/SyoZQBHdz5oUPFiibffwbS1TaTDcaMIeT+pPrFTX/nmfo1ro5qfGXGFuSApod8mXKwfkgIZeldphThEeP8UeofXi98eWE05Um1gtGe0yPnYp7mTVLA0hhPdRuVvwBJ5YRPcSmvYI1O/G+xrm5ft695stTniZLnnaaEnCocIc3yk2y1rjHSSEWFWlrVJaDDxp3QCYa1w38Z43Y/oCxNDXzE82j4FxBnJQ6KjBN9uemSCjF/7GooOwViB4QpVGqLKN16Kalist5PbaHvh/WX9Qh1BrYbDDkHp+cYGxyMf05+XIK0sMwqUxGrxa6EOUTGrCqNXwROBzPiUk44KT/oGudwWXB1DjesAcvSNw/Wn8dh6Dtu+N0G3k7i/vmF1H6WaUbLiJnhlYhGp5JCYenozGBdRW+948Pky80qcjEZETqnbMz/euw1Ucy81jl8zgNYXhQgUnoif7+JycHaLITBRgE9X33QLswn5fbbuB5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(5660300002)(66476007)(33656002)(6916009)(66946007)(4744005)(66556008)(83380400001)(7416002)(8676002)(8936002)(1076003)(186003)(9746002)(54906003)(478600001)(316002)(86362001)(2616005)(4326008)(426003)(9786002)(38100700002)(2906002)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ANgkzasxLHV6UbbUDqdmny/3R6LuhWp7B9Kma/lp4L3uTZnHm7fUWPKtEX2K?=
 =?us-ascii?Q?bHlsL0D0GBY6uIqbhs7seNIHaL0rVAYXoH7zdWkWYw7lW3JKhXfXY6AZk9Ox?=
 =?us-ascii?Q?5cyP31sifh5VxHTFqalgURY5EXp0+5GkCjTtlcwhYTSh2Fp3EFWcovRGAKaG?=
 =?us-ascii?Q?cryYMndE/VRpywwwzeVl+wIIp2u/CjiAs7Smc/K3PlXmknD2ByrMMuzKIzHo?=
 =?us-ascii?Q?reo4N0Mz4JRLH2XZsUQCnwtdzFAJtFtGZuyachLJpumsmIzpNaGP+iwj9ykN?=
 =?us-ascii?Q?b+1plmlbQBJkZfFuebFXDHAFo1o/6a95RGFNezCUa+1XuKkElRptQoxS19eC?=
 =?us-ascii?Q?YwxDK9cqg/GZuosbm8mhrNBdHnpPAuZWpjnyBD0IfPk4OCHJc1C7FPVjTVPK?=
 =?us-ascii?Q?JrNZgQA7gV6avW0JduWOPRs5NQo/uvSQeKUAYh+3PvHa0ycLqh+q9zE4r9rI?=
 =?us-ascii?Q?8HKfv+QTM14TqIGOd8gUBS0D3oU6jMPPlXwpQUmN7O0asl6TqKPpNjRyvwet?=
 =?us-ascii?Q?aeOxCAt61tuLqMzfDbVbrMjSv/hwnTvchXM54LL8oOuhWhiaX8MOmC9CSj2+?=
 =?us-ascii?Q?lDabPbMUhUjMSzMeu/uKmJ7V+3UmD3VPx7rsJ0QCcUp5hMKnf2i7EQ65CKUk?=
 =?us-ascii?Q?N0WNhYlq0UpFnw4xMoSZ9kxYM1tibodJYplYDGTwsSQ/IsUetMkdhNYUp6uo?=
 =?us-ascii?Q?H4UyOkwjCdXX2SecQVnNsA33L9liumUFatrL84mx0yYOrvoRySAL4PW//HtL?=
 =?us-ascii?Q?4Vqm+ZO4ttvl/4e1LU1ckCh1uo7gsd3wELSiQewPBkgJYnH17qTTKojIWCnW?=
 =?us-ascii?Q?PnAT+AHc5G7indvZoJkJt/p2M+IDjUYThIAc1ZHr/ngolw2yMWpMQ0VAkReI?=
 =?us-ascii?Q?2cVo6Vl20BCdsXp3JWfvwnhGWrkgVSb3pCOVkAeKDjLZ5Bv3ISbP5904Sdf7?=
 =?us-ascii?Q?3jyKja7fgVjgajfM4R7YfYMSbkbbEwyK3HhNxSTCLuVX99ffhLlxZWd+1AJq?=
 =?us-ascii?Q?N8wIbfYiD8WTP+3S05Jnodr7hRMYGA6T8wbAo3X28S6QoFM4eo/KLEgd/37I?=
 =?us-ascii?Q?XJ9RLPQoHWbiYUvXGGQIOf7vO+TAs5R8qlC3o5S0y9A7AXNL+eEFyiRWkuQY?=
 =?us-ascii?Q?TM8T3K7jE0WEho5qQG2fswxkhF4mLvSlAYk7jGhDtzzTHZkvyJAgq2DEt790?=
 =?us-ascii?Q?GW33T+LzZLl9aEsPijU+cFHB8MwY6dEQuPRGHIycHV4LKxSG6ShEDZtcThsY?=
 =?us-ascii?Q?CXU6X1cZbJcyMPi7jJhRWyID+Cm76BtC3hg90myCMSUpAJl0vwp+siMaHY10?=
 =?us-ascii?Q?6jRsii8b2B7LKnrPc5Z4UE+c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 805a388f-c048-4ac2-5421-08d93a516e09
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 16:26:06.4733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2KeVcQ2NbH2ooiR6IDGeMFjFkw+PUDdXYRtAniJ0gEJs6rdp6Rw9tKVFYotQOmza
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 06:45:23AM +0000, Tian, Kevin wrote:

> 7)   Unbinding detaches the device from the block_dma domain and
>        re-attach it to the default domain. From now on the user should 
>        be denied from accessing the device. vfio should tear down the
>        MMIO mapping at this point.

I think we should just forbid this, so long as the device_fd is open
the iommu_fd cannot be destroyed and there is no way to detact a
device other than closing its Fd.

revoke is tricky enough to implement we should avoid it.

> It's still an open whether we want to further allow devices within a group 
> attached to different IOASIDs in case that the source devices are reliably 
> identifiable. This is an usage not supported by existing vfio and might be
> not worthwhile due to improved isolation over time.

The main decision here is to decide if the uAPI should have some way to
indicate that a device does not have its own unique IOASID but is
sharing with the group

Jason

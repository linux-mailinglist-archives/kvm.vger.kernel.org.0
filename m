Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7734B65DC10
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 19:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbjADSZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 13:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239662AbjADSZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 13:25:32 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A23F1BEA1
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 10:25:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJ3WmgmN3Gm+ahzG99bLV3NNJEv5xeX4eAxKNFexXhyGRjkBi9y+yOxDP/08vfCzy6gn6PyrcvLYWZGxODG6YxLkT9V2BXjEnBmuVwz4zgMydQNzMfXMb5zH/wS6LlVjfnfPGciui7kSEMSm4y5Dds2Wqk8NWjLrODHvX0g5Lvtl8My3eHdfrL+xO7+eFI+ilEecPVwJyh9VU3C4PI8Lkl0Su28Nyh7oQF2+g0Ikir2GA5+ao4t+rOomGME2/+rIgSSmxNjv/QYRNpnunxUTyRCtQDjWY81DAKpvs/aiPunwYobId+4bI9tE+1eCeqIwVao3yeaK33bdHtLz0ksEig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=npwYpR2RLf6T0TzqcuBB2npnbOpCsB7s9h23ouwZnZY=;
 b=U2cVeQgU1jcBq2lMPcenp/Jm2hc2K7+CybBzofM9XEqRLqjIjpMBpFYP7V3xvqRtgJWb3vvoLXGSf6nNApvKJik0P1J1p5mHgye/dwTwUlC+Brgv/SpWAjKazsh+SjyWtnrfXzZJCO2eTMqUxEknsQ9HpgTh+gXgHF/WhaWh86Zl9+zMzJrTuL+5WI1bpsb/Np3fIZWv31bS6B/wPh3w2hK4KGLShtdMjXQlpcy504gqufxHl14TFlskoz/nTmLH9NgMBI0VBaLrtfqJUA6UW6skkruylHb9e5KZPetu3VzMaBJLjvB/ju7WEDvL7iVZzlwJU77jyjwty11KTW4XOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npwYpR2RLf6T0TzqcuBB2npnbOpCsB7s9h23ouwZnZY=;
 b=Nns2xFqBAKhB9LmK0iifNS7Cjg8V92+rcCLqcrkK5gkNht6OsVJfhr64PoP18fIhjjzKBjqA2aJyO2QUe+14XhZVtnTkuTt9IuATz6JIyLfMHJU2aaIz5pNRDPocs92TvppuhBGxC7NfJATN8owY8oEnYOWcoUY3cuxAFW/Hh7Hos1XNT9KvBio2kV3rn2brCWpQkdNr8ghwgL7rN8ChLwnMahC50kzmHQaDPhUCi+E60ustY5f9aDae+vACBNLp42bXJpgz8HJGe3/cmYKGkCVEiMy+CO4tMCEoqJmeX6cPvYoC9tAeHuGKUF+ATEmfebNDNAHwmDgjUltQ74IQuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB6767.namprd12.prod.outlook.com (2603:10b6:806:269::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 18:25:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 18:25:26 +0000
Date:   Wed, 4 Jan 2023 14:25:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [RFC 03/12] vfio: Accept vfio device file in the driver facing
 kAPI
Message-ID: <Y7XEld4Kx8kXYC+Z@nvidia.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-4-yi.l.liu@intel.com>
 <BN9PR11MB527678C180EE0BBD1F40E3698CEB9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527678C180EE0BBD1F40E3698CEB9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR0102CA0026.prod.exchangelabs.com
 (2603:10b6:207:18::39) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB6767:EE_
X-MS-Office365-Filtering-Correlation-Id: d9d87d55-4e28-4b8e-d80b-08daee810d18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jzmc5JPYUMzsmrWrwV6UxUmtKAYZvGUR3Y/M7eQONDwAjEfykM6fIuzp2krfJniAOsM7DwKXPoV18bx6XROBx3Z9MPGkE+AvkiMjL3FOaukovWbW1XYeviICHaDzNNMmgy3K+BW1mf+h1o0g9GrqHjtDTss0Y3gws1360uYKgN8fIaUFiA6gsyVr5yEQBygoH8A0plOIqGwBhr+HxsZ+MgY7OP6/PTnykobx8dLUAL8IBuJHpkYxcY5xsDgVavvR2bn1IcpASMVqYfO1Bjc7NX74TRZK7PvlNlON0ZwmR0OxAP9kQO9lqRKceJaIR0secXKlj1FYt8kL7+Fq1oV93epQDkUM6ObNiYpGqK8JWNpTWhzK/TlAqQFFN6TYhQq9WiHCyLxYhOQMuRQZRbRFS7CNu5jgM2o5Suht9NS0nvr796enBh4Q50/6NXd0fuqoacAIvxYup3JDaWTKLTRCS218kK/MjcbPXpuBAvgnPtGQf3ztFGNFR+CLYJRqhbbmWLN+Fr3YmfhzHAhp3rj0UolCaZvaB3lRaq2JgpaavZrBxGFiiyOmgE1K/O0XYEXPwn0ZgutE7zVJ5OMInm+iq8CML4ISivKEzFeR6YVHBWNXlUOjj1bKP6L/boeWXNbF2o2nzaiy9Ejn9RFp0HdMffT99iKxYu1O2Q/Qdxwjmctj1sL+3ua08sOL84WApp0a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199015)(186003)(26005)(6512007)(86362001)(36756003)(38100700002)(2616005)(316002)(66556008)(54906003)(6916009)(2906002)(4326008)(66946007)(4744005)(8936002)(41300700001)(8676002)(7416002)(5660300002)(66476007)(478600001)(6486002)(6506007)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qw2HUp46HnhgGNNLTRAYgBlzg8ypsQ9tlUA8ul3JuEvUW6yxFQf7VZWs8nOb?=
 =?us-ascii?Q?ouqhFYMzpGN4zw4ITX1QbXCtEyPVax0VwBfsGE6S9GqJQ8lNhim4XGXNC7gA?=
 =?us-ascii?Q?jxkNcXekkidw4PkNxO7uc/riebi8e9RhehVeJ4IUXYfy05NGcycD9tgNL0bJ?=
 =?us-ascii?Q?aa8BLXmKTgnXRUiEjux/yGkggkM7VfBcTH5keE0eTNpPvU+BTUC4qVZEBOR2?=
 =?us-ascii?Q?eU12RKjtXSfWndUGadM8cHHv9w5n7SwydJs0AdN2bYTkvg1iP0LkVKCwGoMc?=
 =?us-ascii?Q?ORjZRiA1Mm2EJbn/yqPRTP3QjT89b7mhkUB/oiy8cqkCUV9+YqjLK2K210hM?=
 =?us-ascii?Q?eeU48QzDJaApkNsEvCiKvsRlBx597hrXPhiQV9ilEcUYtOxghyH5JeOsmQl1?=
 =?us-ascii?Q?0qs7zIE63oyFVlIa5JpwwdIUfx2ZnS12a6ataJP445MDnK4g+pU0imuwePZq?=
 =?us-ascii?Q?aMA6xRvF15IA8C8fjeX2DslJ9bDphFBEaJtrQX8LukJtk7xETqr+84wqwlwn?=
 =?us-ascii?Q?ajn9+kW3wA91OU4T5kQ7ViCwSzsok7X+BrzywAkHkG0RqMoaRiCrecjYt4qg?=
 =?us-ascii?Q?GF+RUikp6bV2bN0V0Ijb3Z0PMHYEdCKGxP9eBt5eDlmsQy9v0r/7iSL5eMgM?=
 =?us-ascii?Q?O/qsMmtUjT5t5i56lc/TGpsJld083D8EQrpn06BcitkXl3u7Wk25zJKSgD0Y?=
 =?us-ascii?Q?+1SBiLLYPx5vBzGTnbm0NTIPjmMALJDhpXfnrrHJLrf1HtlMRSsmBpRQCb3Q?=
 =?us-ascii?Q?XaSA36l2laS5nscgI/eo0df1PKvEn87qEi5Aar7ZB0J1xE0xqyHeJzQUdd8+?=
 =?us-ascii?Q?1QGfP1qyWCMmwWIWBq3L4xtU4wCj0WdC47G7xKD8UYn6LNnPe4NqXGfgj8Sf?=
 =?us-ascii?Q?//gaqtCX5RGAJgCAiYkTdRGhbgl0kxXaZJaOsy8rRHtYQtjBEUgQFqLltD3y?=
 =?us-ascii?Q?cnAtzvf/9OmyfcsNEsM6thbpNlNL2/FJUMGRlO6hK13tBRsALDLXnivYJURB?=
 =?us-ascii?Q?aYBUTz1M0EuBLagvi8qMI52Qod/3o+MK/T/Oiep1jcjJ6CYDAqDO1lr9diBV?=
 =?us-ascii?Q?babjF4jQCd6og5C/qnwBrKI821QGrituiIy8jbiwbYsNYNYFPgiGsn62kjbs?=
 =?us-ascii?Q?JshJDtd8oVvx8wvb6aWkNNSkEs/ngkk0plUmyrYB2Dt7PrKUKOMmSUWFar9R?=
 =?us-ascii?Q?dywpl962i719/pBzYCOnZ6pESZY+yVGAh2f0tfe+Vbi1F6U0rKX7Kx/qc60a?=
 =?us-ascii?Q?KnIyy0oa/opFs2yUss9ypTVsEUmll4xOlZWYlaqQbkiJacRRMld0rM3qcsSQ?=
 =?us-ascii?Q?ztN9c4B8d2q9OkXPTNAA3lP1N1fIqw7OnUK6mBKVlFEU67RTva26tmb/H2/X?=
 =?us-ascii?Q?JswRd150e0satf8/peQweEGnhFMgWRsjsF7fFdcy7HcLfcskDAKTrYubw8JX?=
 =?us-ascii?Q?mN8Wr3HF8DlN8ta3Md9hh2DVjY/l4uVg9ugI0WMpsb501mpM1nxmAk4N3Yah?=
 =?us-ascii?Q?J6hLVMYSiUf3EFt8RZCeQpirdCD5IKOdjVkSmZeGYmTrgOdBt4ia9VYaBueY?=
 =?us-ascii?Q?7IOHwNDegW8DvBv2MhUv1zHhR5i8aNPih5A9AA2h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d87d55-4e28-4b8e-d80b-08daee810d18
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 18:25:26.6144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6P/X6TBRSUqgz9qh/amSgzH3qtj/hCxX+dumLPvWkc0KN+t8/8UQiM+Yllgx0mYf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6767
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 04:07:42AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Monday, December 19, 2022 4:47 PM
> > 
> > +static bool vfio_device_enforced_coherent(struct vfio_device *device)
> > +{
> > +	bool ret;
> > +
> > +	if (!vfio_device_try_get_registration(device))
> > +		return true;
> > +
> > +	ret = device_iommu_capable(device->dev,
> > +
> > IOMMU_CAP_ENFORCE_CACHE_COHERENCY);
> > +
> > +	vfio_device_put_registration(device);
> > +	return ret;
> > +}
> 
> This probably needs an explanation that recounting is required because
> this might be called before vfio_device_open() is called to hold the
> count.

How does that happen? The only call site already has a struct file and
the struct file implicitly holds the registration. This should be
removed.

Just inline the whole thing and make it clear:

       device = vfio_device_from_file(file);
       if (device)
       	  return device_iommu_capable(device->dev,
                                  IOMMU_CAP_ENFORCE_CACHE_COHERENCY);

Jason

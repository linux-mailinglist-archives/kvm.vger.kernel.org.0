Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F95C5148AD
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 13:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358784AbiD2L7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 07:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243200AbiD2L7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 07:59:38 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A2AC8A89
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 04:56:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YuhzRBT9XqLNTSJDocUfKFHWYJOxLHFHXIXE1RcZndnFr7fNpVaQWSeFQrCDgX4/WocCxbomiuwSW4KRkg1qz2SXnV6yCvVAc7BkWvX7dOBMv3TUdfAdt8UFYeie88mfXteXWczkxslmfq/KUpQt2recSCWJR7KBKBcwBboVYI201jg3vOJ2Keo8bmpB5YdkQijEMCRFat3zA58ID2Gk+BMzVuhPnHtn7cGU8+WmC510J65Mzp2z9iDFl9mVVNFxl0Q7femHxq6ad2z1WH9XLERmGYaiQnc/mHlzXb4vbbQcpmp/X4EYFxX61SXCmwualkVpIcHViDvczMeLtzd9cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RM0R2KMKYeHhzgBNzgsVxsQLYSShgK2vRBdqnbmO3ko=;
 b=QhokhStEDeODJI8gdjfSkS6h4bOcxqwQ8m/E86y8HS69ZYWgNoPrR2U0cVzrjOAPF4/1lm3gLksOSI4R3xTU9sM3Gz45HHLn8O5dlok2wWNyCsqbVpGsigtxd79dMaO2t+x6s06fdEoie2x979vxPibezrCJ6x9BKkChcFaPZOxt6kpYfOZIEugnAZGkNvH3Pv1/AeFWCXgMfN91sJemeLFEkARJSLKcITmrV7UL+HX8pGQ4WVUl4w3ZV+SAaBuwRgecTpBhQwpP62XBhXS/un/4Es+yO4LHUZkjAnkOmhH1usBrFdJQeisNZQlVW7Uf7TdFbE3hFu9Usa1IH2IBgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RM0R2KMKYeHhzgBNzgsVxsQLYSShgK2vRBdqnbmO3ko=;
 b=hhOrkapRf1ZVNMThjA0WMhjR8Ik16kbpklUaB2Yj2HxT8P+6Qo4i3Nj4/6qe/8+fQirwi2DZgOfq38hsYGU1guW+tyMov6m86FiuVeNbVWs6sSFj154/LIlYdQB0+RYu5A8R2ORkB+qmJDHVtZyXvcwa8d2ipL4l9N7gRnroIEq+Zl+Fq7MJt9+CiQQiVQ8EzzoEpbDWoxPG73WwIVmQybaGAjjJ00x67DlD+LdGw6C7MBaapTPCalO99RQTkKk/AAood42F+xN1Ga/TuK5ILuY3q5z6rj46Av1HVvxjAQyMisCO3o/tSXmPQwXjmVXc9oqyKvKlKKNsN1/Q0Rzh7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1645.namprd12.prod.outlook.com (2603:10b6:301:b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 29 Apr
 2022 11:56:18 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 11:56:18 +0000
Date:   Fri, 29 Apr 2022 08:56:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Martins, Joao" <joao.m.martins@oracle.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 02/19] iommufd: Dirty tracking for io_pagetable
Message-ID: <20220429115616.GP8364@nvidia.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-3-joao.m.martins@oracle.com>
 <BN9PR11MB5276338CA4ABF4934BF851358CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276338CA4ABF4934BF851358CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:208:fc::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca63195e-6586-4efc-aa06-08da29d7452b
X-MS-TrafficTypeDiagnostic: MWHPR12MB1645:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB164563EEDDF2F3FBDA01F9E8C2FC9@MWHPR12MB1645.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4RW99GvMVtd+D0b1Oeg/i44xpDFomzXUyJfHKGMUzVFR8Szv0gyYSA475qWJWdox4Hf9p79W4lldV2Fafk9n6E97BYDRiUwjRZc+cD/TYNk0NWikadPR7fu0La23VwRju/HyUDEB0vvj/HKuTxcyY+aX3Y373yOmwnAHNnYzpCB0lvg3ppfKQxLbBEhFczrl2mL7Duzdj5YCr3gNhrT9vertjs+6HP8qbn+I6rMkOKonYNSNqv1R6Z0SJfhQRyrNhZdIiuT0P8bU2gInOOoD63f7jP7nJUxzBzkGk13AgM7T/SkeR6V7/PU/heQMG6F4Boe4Rc5YQ8TthnTjTMWCTFTdxPW+t7mhujDn8hnd8qWnW10VEqjvoDwzqEK6OjkIUIflaKmzgDCRRJYUBZ1mDYD2xSUn4XxBxJiLJRBShSthReuAttTaUzOHLESysH1QoWmjfnjfQRX0KyTH6BcdF0oUTI8M4VHyjilZGH0I1MHdDJ32oUNDPVHv7cxeZJde8L6mDmsdMH0kmKak7Jtnfs3cgnt75KtJjTRA9w1LOsJzPztwKK91Q/0GHkjHSQ1TXCIvyOWkNF2C9ibwfi2am6giHkvmzF1D0vk+LvWeolCwD3KqmD13oDRxfwdE+SplYhT1FCNNmef04nK0uSuVZBRSELGx6ASqr/Vg0UuAdpubI4Ian73u9A67sVRbCEMgWc9btxYo+f36LruT/DHkdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(33656002)(6916009)(54906003)(186003)(2616005)(83380400001)(1076003)(2906002)(36756003)(6506007)(6512007)(8936002)(26005)(5660300002)(7416002)(66556008)(86362001)(508600001)(4326008)(8676002)(66476007)(38100700002)(66946007)(6486002)(316002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qT80om0KsMr5C8wAnwZY4Dfszs7ip83Gvj7tStEvKpg21NHgKgiZ5Rm/VKEY?=
 =?us-ascii?Q?DK4bzCzycfDQUaK0zYd2EtaywfJ8YcC9zAPBfbwqsPNXv9jI9CzDtAIV6126?=
 =?us-ascii?Q?02x0kOMSLetZZomnMxt2uwQcNcUBXShenTD9aZAFMuFrJUp3RRosYwP9Zako?=
 =?us-ascii?Q?Qjr2xhLN+an9ldcCCaMIgvT8PFQDmguhjNZxyjabaOdTQMCKcwm28vfIt8Px?=
 =?us-ascii?Q?guBDlzK4Jsjvi3JDh1ql6wCCLzvSHriG5x0PKlrCEqPT2X+OlxGTDN3oCvsb?=
 =?us-ascii?Q?e9EKV9pWjW39XNKHI4gXnB6xSHttOXQPZReF01C/7O3o8aLOx0LwhLSJkIDz?=
 =?us-ascii?Q?Hr8UsZKJ5+vycu11Yu2LCrfz69K7tCXQopziSZtZtSGxTTM0RApyXf+CafFD?=
 =?us-ascii?Q?P/eY0FfDNfxF1cVT2rwAmIGwNxucKa/rMTN97FBnYFO11jg1nLTKUfTxX2Ah?=
 =?us-ascii?Q?tMQtRb/G7QumrJedy5srKC4rUa8pNMLbDtRYOpRFBiH7nA2mUDp32AW+r4fN?=
 =?us-ascii?Q?IYr2L8Qnz8fbMUJ2TYca6NKwBT8c64ow2B/lnUK2A3vzn3TesIP1TECdn+qM?=
 =?us-ascii?Q?TWsKW7zDlFyEH2k3/B1ZMS0MFMeIk/QnXagQfv44rgKxMevosuNYGfr04OQz?=
 =?us-ascii?Q?natlbTe98GF/JszvidH6tzyiXNg9Jr1rpDe2Lv9iyciLQ3ZyOhl0YVMgWsvP?=
 =?us-ascii?Q?d3o0YA8jY/fcTjNJVHJsYh4oXT5ileZZkFMkgYdYwDR2kut6V8YbanzSyCZZ?=
 =?us-ascii?Q?9vr+ly3a7DLptyiGiNWR8D40yzT/LbZbHwZmvgn4eqe4j6kZLrP3o+8AS/UL?=
 =?us-ascii?Q?BZwwWlLw+WX/Gxs9/cQnd3SQ6WUenyVz/TVKSYVALqPQMchUxRpDj5w7vp9i?=
 =?us-ascii?Q?YPCWSTOx9ck+jRChaV4NZOEnhATlpngzZ9orlZDMugVpj6SyoEsypx7n9H7A?=
 =?us-ascii?Q?GWZVde+ZAXhK4aZgkHeL3BkmL57wJ7fhEvpFnIwTE992cyNcBeTpPwAWxPXR?=
 =?us-ascii?Q?IICLu6iLhrPEUZY/pT/yOe9Q2aB/7dSFtpuAGA3v/yZ0IEDnJb5n+nrPY348?=
 =?us-ascii?Q?ovEyQ5IGWJmrRChacv89x0O2SWi9WGhy2SbPDNBpn0UUiqi5Ye8pPEb57jQe?=
 =?us-ascii?Q?TWezBoNeuG2oq94wSDAxYQsDu/l9vnGKPCRT3dSvu5DN4uwM4zSruGDRCPWS?=
 =?us-ascii?Q?YikYQDaC8t8TTEAUdg5cF3MKHzTaIGNEJXtzsoaAwKlKOoQTRhXxytkBAo4P?=
 =?us-ascii?Q?g/6N2ZCKFOAb6TE3+MeFVkZhCLvbSaL0yJVAITzljljrOVi0HIMp5rci1bJw?=
 =?us-ascii?Q?KXuD0nKcTQLu8oIjsbeZ2ztdpHCSaatTvlcWXSV1sH9KAs9Xt2BM3R29PvXg?=
 =?us-ascii?Q?+UXHKclMooXMJPjQlWYCC7Gq/HmE6GgudB51lnmaBtaYrvkrig7FfwxZPynX?=
 =?us-ascii?Q?fY06862IEZ5hhMLUpyyHOHT7QAlCW5fGeb+xas3fiVypyJEznuPPfVOQ/MVc?=
 =?us-ascii?Q?xNth9FE0W82cVFsAlwNHyL21rp4YgNy2au3Xk0Qmo9y47Og0gg6Jeyrf6UeV?=
 =?us-ascii?Q?U7EmR5sFgkr0Ng3aj6jxc5uR1DA7BCTXBLWRq+VUujzNj7lWGW1Y/v+PYDPh?=
 =?us-ascii?Q?Xr4AjOG+/HWlqlDnN1Mxd9KU8xRxHsj4bkF079/8zKtsIe2easXv6I5RrxUC?=
 =?us-ascii?Q?7vK2ha6cLcxxTv52PPvsblX+1bF8FpQr1mjbgCtbRtotTpOXO/ZU3G5CMliG?=
 =?us-ascii?Q?ayG88oir9A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca63195e-6586-4efc-aa06-08da29d7452b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 11:56:18.3730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kYvNrgedHcst2dUIx4/bqllPbGHtqzubpmq0lbmT+R75goFf9Zsj6qOUagy0pKR+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1645
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 08:07:14AM +0000, Tian, Kevin wrote:
> > From: Joao Martins <joao.m.martins@oracle.com>
> > Sent: Friday, April 29, 2022 5:09 AM
> > 
> > +static int __set_dirty_tracking_range_locked(struct iommu_domain
> > *domain,
> 
> suppose anything using iommu_domain as the first argument should
> be put in the iommu layer. Here it's more reasonable to use iopt
> as the first argument or simply merge with the next function.
> 
> > +					     struct io_pagetable *iopt,
> > +					     bool enable)
> > +{
> > +	const struct iommu_domain_ops *ops = domain->ops;
> > +	struct iommu_iotlb_gather gather;
> > +	struct iopt_area *area;
> > +	int ret = -EOPNOTSUPP;
> > +	unsigned long iova;
> > +	size_t size;
> > +
> > +	iommu_iotlb_gather_init(&gather);
> > +
> > +	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
> > +	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
> 
> how is this different from leaving iommu driver to walk the page table
> and the poke the modifier bit for all present PTEs? As commented in last
> patch this may allow removing the range op completely.

Yea, I'm not super keen on the two ops either, especially since they
are so wildly different.

I would expect that set_dirty_tracking turns on tracking for the
entire iommu domain, for all present and future maps

While set_dirty_tracking_range - I guess it only does the range, so if
we make a new map then the new range will be untracked? But that is
now racy, we have to map and then call set_dirty_tracking_range

It seems better for the iommu driver to deal with this and ARM should
atomically make the new maps dirty tracking..

> > +int iopt_set_dirty_tracking(struct io_pagetable *iopt,
> > +			    struct iommu_domain *domain, bool enable)
> > +{
> > +	struct iommu_domain *dom;
> > +	unsigned long index;
> > +	int ret = -EOPNOTSUPP;

Returns EOPNOTSUPP if the xarray is empty?

Jason

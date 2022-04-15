Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE475030AD
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356288AbiDOW1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiDOW1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:27:08 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8D32ED67
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 15:24:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QynSjXkdPal9EE4facWwPz269BEptLUIbg13Wq2F0g239ieJOe/eHZoKIpLhv0oYYuimketKSkbLGaa60ROXPcpvMfR6djHQ83hqJR9pVQI0Au7l6fQFJsX3D+VvbKZuhZrOYjZfQk5aO27B3YBSrjzjuEsUvTNFhXcqScnJW6bDQAg/twMLfpiOo2uOp82CW4fKYQnMv28B2N1RiVMa0tMQc8c88F4vXg5sPR7fRArzMjOSTjy6scufyGBL/lIi5dbDlX6lD01GIp/9G+uZE4TlgVKtEQJ5IL4x3YmtQ7gvkpNyvBDKKdxl+7RHibFxqGcldxfTqRq4LHt0DanGpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3won54WXcFxnyZlUkEf2y8znGjy4ZU7J5X2xVKH8KI=;
 b=XGuwVGriPJyd3P6BFLOOvaXfqvYwlmjkVbjuWZo3zDJ5KZkEm5Ot+SLy4rVIPfb/xc+vgRANwZ/SpuQH7mX3fUf9FUXvvYzLvifO1eOm/OCUSyiLgDRMncbwqseyb1kh3yoZtrUpG6SHqY7rF8VQUuMt/J/Vw1VGTTnWrYRusUa60JzmlxsbHKkm60NdpyCjcOPC/MFwuoy53Zeevul1zs+I0JBCPxLyx1xxAnPHSWU0U3IInVZreerokjZ0FoONz0Hl3FdPmgh0iXZuDlzVi+B6NDeR1ehhKX9tEFgFvqJCkw1muLFKH16A0kUxJIhJQom0OAjyEm0Piip2jN3bww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3won54WXcFxnyZlUkEf2y8znGjy4ZU7J5X2xVKH8KI=;
 b=AFxGdtR6HjwQTmiEH6mcNA3WjLj7lkhVBMXPZqUPbe2AQkQq/zIZV2oOdIuA9qvcVM9vY5cwWiyFb5dp20fJAjTnR3+2TUqVJ7mPjsRzkAsGwYQIqnzKMg90FZveG47YxaeNm7r4biXm6mOR2PW/0NBMFMuXdp3uxQWToixu5dFU1H9zZOv2jc0SDvgMvxMq+W0GJaBUTrA7uHOOdl5JZecWs4MSLNk+6DCrIMFMEZONLueuwm6GyAMGbLoqmOyteSv0/ZHVqIq64hylvahGvNXdwFFXmcDwH+aM7mg2hEXetzHdUKDxXNvZIvZHr7Dz1bq6EqcypvcGsD7IbJB7Kg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1130.namprd12.prod.outlook.com (2603:10b6:3:75::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 22:24:32 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 22:24:32 +0000
Date:   Fri, 15 Apr 2022 19:24:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 03/10] kvm/vfio: Store the struct file in the
 kvm_vfio_group
Message-ID: <20220415222430.GO2120790@nvidia.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <3-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <BN9PR11MB5276A8591FD649A1C42E520A8CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276A8591FD649A1C42E520A8CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR02CA0083.namprd02.prod.outlook.com
 (2603:10b6:208:51::24) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 062251dd-6bbc-4d01-521d-08da1f2eb6b1
X-MS-TrafficTypeDiagnostic: DM5PR12MB1130:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1130A2B1F7039DE1CDC90EA8C2EE9@DM5PR12MB1130.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1tPpWpiDDdeo+HKHFYF3jgqRePZzNCeImJ1g6FlMCW9jaWEhqe0T+nxKEcvxFGwG6TmmpXJvRcPmXYouHXsrIvqoiJJAx1q4Rhbo97K7K1g0ApnRzP7OEQFR8KRvt1cZ0tv+kDxJ7D0ok+x1n+DpnMFb8GXIlM2z7TAxh7sywxB3bM7ZS6GHEc1TNJRjJfPGoBjhqWShJdVjSy4043NIKy0er7Zo6IwFIdMAAd+I8YgvgcW/Sgdo5vy0qsHSWQgXL9mG3d/nmgxJwDSMepDNHCHZNNYI20tB0zupf+yrGUjxSO9orxyWmf0qSEqmIUfMc2pBpbxlIZCemLxUdsxosPrgN13neOFxmjW18kiTIYnQWK26++dek4gqlxOoBDr8SuCJXlPh6a7WMuEd9yJUO08aX6Ge/Dl1yjlEWYAc64XSdxIVp4afUaYRKzcAEbvBypjf8xO+X9QZnLIn0dg/7X63h0j7iiulGJpnYdUPSYb8cZw73CgMsQqVDpBkxOD7uf2A+LGorKcu20CiKIU2kcrfwTEuOfYGL0jzzgmLJ/Y+2Y+JIJy1+/j+kQiQb5BIWDf11vCBBx7NstPXpABCUm0WCmEw99Y0hWOVqy9c0fLBAxE4jOOOO+aMOC1mzAuW6MuZaaax/fHx/T9FUT0ClQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(5660300002)(54906003)(33656002)(83380400001)(1076003)(2616005)(36756003)(38100700002)(316002)(86362001)(6486002)(508600001)(8676002)(4326008)(2906002)(66946007)(66476007)(66556008)(8936002)(186003)(26005)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VZc83ascH9tm1pTzNn5QPl5NEk6D8Z2WYupZPMM3ROamFjFpUwAQCJw50u9I?=
 =?us-ascii?Q?GjKLKckU5BUJrAJrEeqOjOr+RRWp78S9uCOoYMoQIpZa4DfX24KtfA1MsADr?=
 =?us-ascii?Q?0Lhs2g7/G1KI0RfqEnInFbJsV++zNr1ypSaCKfO+xVfZRExYb1i6c4YfPJro?=
 =?us-ascii?Q?YLVbIJ/K8X/cHs/C7trjR4du/Onz8KtjVGKuKZ8XKShRI9RmzQT7P8Ma8qe1?=
 =?us-ascii?Q?gKwXduIiW7OwY/bDzHywkon2yQU8MSZwbbzSaG1sY6b9Eb7c5tWLw8tIFUEd?=
 =?us-ascii?Q?Y0hT8ekMSzuANRfp8/rE1T206zp14InaeLa5pqNWpyY5M3yC2fBTkjjdflAK?=
 =?us-ascii?Q?2IIJVfIeT88xJ3CmnG8kAICmUrEw0jJtMUfxHJSf2bHfYjk1X/voi2BBJqli?=
 =?us-ascii?Q?/mZqJrUMpw3g367671ePA2PTxfZx37UNsVG4a33qJSejtxjIjU5/PgUNvtUQ?=
 =?us-ascii?Q?HQVDMcR7MeiXo4jXXew7eFFuiu27gkeiRfSXhWDZygCrB50KDeHmW1QChAIX?=
 =?us-ascii?Q?WvsLh0r6Rt23uedcdTekfN2Pzbx6pTsoaM3Lkk4EJadpFfvNJAndAj9pHabw?=
 =?us-ascii?Q?xEiJc0NQI8ymBjd0hhcm2nLHOXCq7Px+HYaxMmUYlr/kOh2DHopFA/SuzMXv?=
 =?us-ascii?Q?cPY2HqGvGSnV7l1QoZQ3M/sGZziohBCR72hSxXWftmamK+c5zAZOyA/mqgol?=
 =?us-ascii?Q?dYv2oHMZgbIHJZRrGt6MgSvBIwJ6XRQfNdMHN3lZmaqKhIPy+tWuCVbmvE++?=
 =?us-ascii?Q?iQg6sJvs9FTy6qzqO7bciKqSCDK/qfeT3Hk+crPgc8Lgt1NcssyNGcZGkTAY?=
 =?us-ascii?Q?ChIaGPOGwC9Z6VcI3Kbfzp9aTOHQWj6vGw9xRX5ZYnAVwBE+zw1KuzhJ15oB?=
 =?us-ascii?Q?90K+2RTLw0mJVt+ytAXqD98hsLNAhT8Lh9IXIkZVCeSFb8IzReCnBGi9r42k?=
 =?us-ascii?Q?KuKVlSJP8VnYaveKFeykt7l73dhOQCz7PRTfeJmhRZsRC1BqJoJ2S0xoZqh0?=
 =?us-ascii?Q?Ltc8MHJzv+5/JLxKcmvWN9auXnqsSkr7aSiVWuwgT//o8n+vNc3ZmN4fCX4A?=
 =?us-ascii?Q?LNjLuih0/dhKCXO+4lIU22GqcNYQFryFa7XQCKDMLJ29GqEVKPC9QRT39O1b?=
 =?us-ascii?Q?u3XgAV4bTftmVZOx/4PwKCNtxtOL7nHolNd7v0aUvYlumEeuTxbj1Zrxe4Hq?=
 =?us-ascii?Q?h4l75EPSoBM9RLr1qTsWYOS4dARZ9O9vpeCbtyyok11GEsKpbxiuK1eUtpJN?=
 =?us-ascii?Q?H1DxzrERrD7N3doQN7Nuiex9ah0HKiIkARxzozNCFAuBAKfik5EHa24hIa4f?=
 =?us-ascii?Q?Jkps2v23JkvX66TYEspUYP+CQ9uVyYyofwfEJydlp2JqTsK4PpI7Y/fQvWRx?=
 =?us-ascii?Q?wB4XigU7poCq1VPEs15eTVc6OoR04FViCMHRpNy+qIINE1u0qVSXva0+Ez6E?=
 =?us-ascii?Q?ldwy4evzJVD8vJrLFjxUymz7e7q2MxCXYlNjOAa9qIRR2e8j5a3GNFs8IbHP?=
 =?us-ascii?Q?sB24gG6CHud3wg7WOIji3lN6wrHYkBNbS6GY5jm/EAtcpVLd9T6fZKnkuGyY?=
 =?us-ascii?Q?/1s0d9PZm7R4DbCU7zWLjM0uapTEPmR8Op9NaYHFvoyPed1aPU+sAgUAEsKq?=
 =?us-ascii?Q?m3+uOVa1uH3gt1oWdKGsim/n4rSEbQDvNK5W//aeWelISI/ty/B+FzdETZqW?=
 =?us-ascii?Q?0ystEll1qz4ZvU1rzbQRRcXRVrglncMs4X90ehOfNV0E/dZMzEcMD4tlR95r?=
 =?us-ascii?Q?SLnbpvU1ow=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 062251dd-6bbc-4d01-521d-08da1f2eb6b1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 22:24:32.2096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YOo4dV9jh0FuyphwRXHHH/fBtEJ9q/FcnBJCh0FODZdkUF94HR/0FRKnCgkWhMmc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1130
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 03:44:56AM +0000, Tian, Kevin wrote:
> > @@ -304,10 +309,10 @@ static int kvm_vfio_group_set_spapr_tce(struct
> > kvm_device *dev,
> >  		return -EBADF;
> > 
> >  	vfio_group = kvm_vfio_group_get_external_user(f.file);
> > -	fdput(f);
> > -
> > -	if (IS_ERR(vfio_group))
> > -		return PTR_ERR(vfio_group);
> > +	if (IS_ERR(vfio_group)) {
> > +		ret = PTR_ERR(vfio_group);
> > +		goto err_fdput;
> > +	}
> > 
> >  	grp = kvm_vfio_group_get_iommu_group(vfio_group);
> >  	if (WARN_ON_ONCE(!grp)) {
> 
> move above two external calls into below loop after file is
> matched...

Actually we can delete the kvm_vfio_group_get_external_user() since it
is the same as kvg->vfio_group and we no longer need the group to
match the kvg.

> > @@ -320,7 +325,7 @@ static int kvm_vfio_group_set_spapr_tce(struct
> > kvm_device *dev,
> >  	mutex_lock(&kv->lock);
> > 
> >  	list_for_each_entry(kvg, &kv->group_list, node) {
> > -		if (kvg->vfio_group != vfio_group)
> > +		if (kvg->filp != f.file)
> >  			continue;
> 
> ... here. Though they will be removed in later patch doing so at
> this patch is slightly more reasonable.

Sure, it is nicer

Thanks,
Jason

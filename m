Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C34507A2D
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 21:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345871AbiDST03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 15:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbiDST01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 15:26:27 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016591263E
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 12:23:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=We+Hv7X6g2/4SKjU5oQVw9eMUIqLNtAlK5qKub52bq34zj591hOl+aeC+2siYjSyrJkPDACY3wmOhvdVPQVpcvRg6Cjt5TYxXZ04mneyuioi9wjbayXjw5MrZ+QnUL2EZuIro2vFZ1qlGIfDRHPrbP31xacBXoQWh6ZqI6O05LkluR4mPLl6PMFeKvX5dtTmNEGcjRG0feXfagzBnUWjfQsthgwQp/ZfkEGExnrAOkZbqmMWp+LwSRdNJvCDpaDE/C1YqJw9+sXMSAdzGo5WmkIpCmG2eY6NyjqlzYG5oIHAerWZme5lZ0WL3Fa89er6+2cJyaU2NFdJoDiRW/K/Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XbIBbkhLKDWUtiV5oG8G7czAwcc+8xYv7i/cmRkmvio=;
 b=dHStxwYsdUDunx/mBTSSuUadfG2uWhFp+raB34asR6UhxTYSls25uWKZGTetnoja5gf6Nw2DZt9F5/nQTBs6jZsZI0Z/KaZxkSGBThq6f9vJnwSFfA5bRmm640XBvD1herOvoYDqlFpBkpJLrm8GNMGKlJApYZudydvej1o7HjcCdOXLUcqov8LIkNhJRqjUYrb6Jmf3gmfxwQWjUcq7coJE9BkLSzQdLlIDZ7zyE5LnU+P+F/jllye2fUJQReTDCpfI8xklzhkj2DSnlj3MNMg6L7cm7HfACO5qxQqAdv5hvrmN1PCfs66ScDfoSoPVQcaYYmwljIDhSlPxY2lupA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbIBbkhLKDWUtiV5oG8G7czAwcc+8xYv7i/cmRkmvio=;
 b=mYU4GLOhJyGwwb2Xg4Ah5ZD71OCbraQOT4D6LKIELOg4qe5B/OM3bZmAN+tZPb9hp52DTCkQ1Tn+kGDjj7bPKGdJn+TpJP/PU0TSqgi3+b/I/Q8KIZllOKhrqtBIzrync24XeFtiTsK8UzF091BNeSx/XlK/8Lk0W6MiIZnTk8dSI1Dr9cXj9rekM3xdFbSNPpB/gZFx3+XAHmjuBfXnD5ioql5/OgC3+pWAQNOpY+Q2h9YxJ8RCbhRBU+mbqyLBtgKhUIbR/MVgtoBwjtB8Rq575ncVIw3YCmEnVq0laiT7Orb+wseiHTrRrKcYGIwtoc7fyi60CxPy+jTpZP16Yw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1491.namprd12.prod.outlook.com (2603:10b6:405:5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 19:23:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 19:23:42 +0000
Date:   Tue, 19 Apr 2022 16:23:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 07/10] vfio: Move vfio_external_check_extension() to
 vfio_file_ops
Message-ID: <20220419192340.GB1251821@nvidia.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <7-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <BN9PR11MB52761E7F5FB90976888A24088CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52761E7F5FB90976888A24088CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR19CA0008.namprd19.prod.outlook.com
 (2603:10b6:208:178::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ecbeaea-3491-4523-ff2f-08da223a1d17
X-MS-TrafficTypeDiagnostic: BN6PR12MB1491:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB149112502D78B259D50BBD55C2F29@BN6PR12MB1491.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ap+ePns5lw16ihsEyFiyAS4P5p3dD5RkYtOhN2Xvrzva3oPzoeNM49TbqmaGCcphDKCdjr/oSsBabk8jPOkq73rNuYiNY3DK1DlClcMmlzvi+RFbv6m79g80cL52+kC0SmuTzlSF5kHdMkO85B/aaP14xgMuOFTcRlMvhbQgY5GSlEae7pqgW5D75LPPAFFmxY7OcLG+HbuR/XX5+nS+4Gy93/cJxvwhqjZZwgDe7Vv7YKD7lvfmybPdVYT63m978/TCwYVxP9B7G5B6mFFohqgr0AkhRXQibFuPgQ5k8CW/Ki3mfTa4LVVjKhrrhGFo2DrxDdoqEthLjHVxcYw/ynrlApsp7VKRyQpfmrLzy6wqdBegKGJOrKdx0ELJRZWsuhzoxLkXgsmDnvfCYgd1X3fRMuOh1r1fTKnRryzTmvKTW/l8RJuL/jjtIwzVEJbImE9C8qlu3UDsKIQPDznFH6VKTWJAIGP3stkR7TuZZP+hRdiPNxkwh6gPTFVd5fEveCmZwtqF2Q2+AiJOCEhIWB5xX/Zr0qmMs9qiuYbR7VH4iAY8L+tbciQxBqyTUsH5W15B3qLPM0vtT5DeCAq8Vma5fYD/sxTKG2bi2C2WLWlYlQLSVJpOxY/DYzTb+K3GvMdCQ+QDVAnh4dnRXarMMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(5660300002)(1076003)(4326008)(66556008)(54906003)(86362001)(508600001)(316002)(66946007)(36756003)(186003)(4744005)(6486002)(2906002)(6512007)(8676002)(26005)(2616005)(6916009)(33656002)(6506007)(38100700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CuwMd5J+cnOTGItHRd85DyIYVrVyvirVbgfHF7kcVsISkFYVeR4OHEKG/C7o?=
 =?us-ascii?Q?jr+5ZMDLSVh/Z6ehzu9oUL+mj/zL119pfuORxCEp5uWs6z7tQPONY1ThvPjI?=
 =?us-ascii?Q?oMlQgDPkwqi2Q4W2jjVjMsOzqCf0sqwqUgvX3m7R3Xt4pB16DBr/GKE9gOcL?=
 =?us-ascii?Q?5qeLawZIV9b1apxikGaj1VU/3HoNWpf0Rbs1nm+MsCge2TJ52jbeMciwEjQz?=
 =?us-ascii?Q?3f0LnN1XJ2XatEAVfv0QImYl30iUEmw0oxsJp/pZttci6t/wmQyZ1ggj27D2?=
 =?us-ascii?Q?nZQ68+6EDMpmV9qj/E9FH3H1u1TeK9GVKTxCJHWSebxsgrZdz5blsm7dnQFg?=
 =?us-ascii?Q?T9prl9pZyn6eZd2i6TzaEK29I6AlrOJ2kx7395mTjQxyATMsGunIDZ2uKPpV?=
 =?us-ascii?Q?MhX+nHu2KRX3h/whto4p1N2mbzgjXfkZ6J5vG3FZffky8mkHB8KIe7vPSADU?=
 =?us-ascii?Q?3/p0EBQWLMRinMx48BQZK5mIGs3oORQhR8Qub+5CbR/xj/VdpmFbcuSuK2I1?=
 =?us-ascii?Q?dHWvFs/G6/zh3BnNDn6lfuWo9rnJEgLuucIpEJE149jVWMedl9jVjB/i+wJU?=
 =?us-ascii?Q?DDIwuXcH3k93NDx7q13CPm4COZUBNy4mp+hjS3ufhh9ck3tktTYRSbEeGKXt?=
 =?us-ascii?Q?vepEYkm+M4XtCZsTlUQI0rQ9mVG0JZTmyg9674XI5PRtqwEdzeqlCuT4S0VE?=
 =?us-ascii?Q?bR1hGStTymp75TevRnKuSR8ASEAp6hL++T+p0FrotNNyw6DMsLtFTPTi/ITN?=
 =?us-ascii?Q?cyH2PR+ecuLxEETcIAZ+LLE/VHy/k5WaZnia0DNoHg/vQDdvBLPrnmKtR/Zw?=
 =?us-ascii?Q?WRDWIOEk17tUhpgBN2mWdZjirMWOcEen+9faoimVeuyiZjSDEI7M47ixZ4JC?=
 =?us-ascii?Q?jaE57XkOnWw2mXu42XDooBnE/J/CGnOAoqEycBBWMV0F8YnjuqR2NMxoTMbM?=
 =?us-ascii?Q?kYS4fmnDYjxGw6vMCwsCT84YBt5zyc1sCM0V62jlOcPBTa7Lpo/cDuGNrysG?=
 =?us-ascii?Q?WJhmqIEQ+WJrXXaPQAHIIOxvJkpkS1fXxRgT+V/VfIignQr/8dWYfxQ4fdd2?=
 =?us-ascii?Q?qXS6qxdC/w+3JmZ/MYIvs+YacqHBoBFXRoDIpQMeVLQIO4EQzTUUqLE/oQ7C?=
 =?us-ascii?Q?3ma3XquSdSTaszK4h3vLrCq8mMP0izX1tUp804KElZU6gpKFSH2M28Tht9CN?=
 =?us-ascii?Q?9HrEngLT/LZ8mAQiyKeLAYvzkvyDxSWp6OdOlM6blnQeBdyY1JsPjXQy71YR?=
 =?us-ascii?Q?SPDnUb0lIg2Sza1Zlo3nrnpJJIIFtMf4whiRk8z6EoqvaUzAcWin9xSUI62C?=
 =?us-ascii?Q?Spu1tUQ9ILrtXOc/bnzYRLx5xrbKh8zyKQEWi9wOGCCD4JWsWgYepzkeVyad?=
 =?us-ascii?Q?0t+rqU7XldAw2IOk/9v/5rhV9jihzvHR2NR9v0h7MfLyFNtZ0MHmRxvjFYxW?=
 =?us-ascii?Q?pu1Zl8tw3aPlZzNVs4UYaeLR+ba3F8NSErqFCMhWd8i5TNXkMoHJSBdwOoG7?=
 =?us-ascii?Q?pmg1gbfxka+HCJqPeq/QCFkl1Hm1nwvKza6DubDB6jM70LiDS7YGxDuYIrg1?=
 =?us-ascii?Q?S/39IYbrKdaGeg+Si7Ua57pl23BWia5U6h/gEt+lTTHoGw9RqPB9BW5bK8uI?=
 =?us-ascii?Q?kKhYRvIUzBKgbTWFlMIwU01lIj1ZbFo2RsFMvM9mMIITCFlPySTZRBC/uOlt?=
 =?us-ascii?Q?YqLztSk5bnrhLvFDkyfhYtRfVlb3DAfHthy31aBTGRYa3N7vMeBunzm0jrS6?=
 =?us-ascii?Q?eAailb2HHA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ecbeaea-3491-4523-ff2f-08da223a1d17
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 19:23:42.2123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UpgWk2hsxQ/k3WBimOP5dMoKjxYVHIaqnSqi35iRSGKBGIs1QJVCiDo7ZM8CJ6hB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1491
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 04:07:51AM +0000, Tian, Kevin wrote:

> > +	struct vfio_group *group = filep->private_data;
> > +	bool ret;
> > +
> > +	/*
> > +	 * Since the coherency state is determined only once a container is
> > +	 * attached the user must do so before they can prove they have
> > +	 * permission.
> > +	 */
> > +	if (vfio_group_add_container_user(group))
> > +		return true;
> 
> I wonder whether it's better to return error here and let KVM to
> decide whether it wants to allow wbinvd in such case (though
> likely the conclusion is same) or simply rejects adding the group.

Since the new model is to present proof at add it is OK - it just
means the user doesn't have a proof to enable wbinvd.

The thing that is missing here is a notifier so kvm can track changes
in the group's assigned iommu_domain, but I think it is not necessary..

Jason

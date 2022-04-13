Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED3A4FFD11
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 19:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbiDMRub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 13:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbiDMRua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 13:50:30 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA726D39B
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:48:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ow+88iMP7Q56DUe35ajq5DKYrVrZlP4BqwQmN1ws4pYbDTChojpP8m7SCESljiwBjtHmB/GvF82nRMPaC4XH1Ne2GlXW1sxE4zTQDVB+6s4lfUg/jHtpoRMdN+JBGMhRjGIj3FRMmuF+lpVISqCI8540+bvESwYHo0MtaEmn0g37e+pgOWXTuDxyACOBnxq7CfaFC57K0qYpm9vA7ILTul1LN4CeoYy3C4Td3Y0XcgsBoNWf1vo73klVfRxICCzH+aJDwMtNY1sTiK2A6UfJxS1J9r1TrH5h/4W4dItPudpWg7OLmoYC8sxRzWe1kllEghlLPOxzgKmE8E+pphUoWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fuFYeuj0B5SKOQkTfwoX0Jf4ry25ucLQF7n3nAdeWvQ=;
 b=infWVEX5sPAdCsRDnw1lYxEsBZ/BwmDlvgK6OdX9nCv028GqqEicZAXbwUCzLbJoq9T/Bro3tCXsYwfHKyA6B9XocqOdyKOoVh217FmYDepaq2rZVndOFgyeJ1i0gYR8eJSci8hYRMMjtoN+vTGUj8oW4IOu9/9ewPCj6Dx1AHQ0frXVYmIno+DzYWhOZhEGdLl+Xe4pUHevFpxH3Up5Wb4JY78QQH6A0hmHSYWRBckIheXJPb/Gch5VIuLa3fKBJcoBEq3LOczuVo1pq/sVrJT7B/1is/x9cgKql3uB3POyXBLhOioOOVSkJjeKp37xQ/xtEJjhOqaPhGHX0+vUxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fuFYeuj0B5SKOQkTfwoX0Jf4ry25ucLQF7n3nAdeWvQ=;
 b=iFRLrwvb7LBZ2T+AHgS3nNoCMvNeUNlMcg7YKbOjapL69oOe1IhEpXMqj5G61qxbSnHMsIeCbgeOUdHMKNaILla99hNNv5nPPJ9WNg79wEFYqPJ5mGodSlmQw7CCfsBDZ54qbnf2RfD7qXlSxP2b4YqmT9w/L9uZswh32YrJEJ5Ce1m8blENAtTKOgCKKG9KsPzHkJr2un3aXrdH0mGxw9F8JZm5QbeXes9jRvi8QLFs78RBf69rlK6+9pgHNAoHkBT91t+F89nJB4SJV87IGjuYm5YoDUuEK5H6sq8tAVf2O3SwlR/B/lCKH0NfUe/AnhewQMOLhBwI0syiTa234w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB3798.namprd12.prod.outlook.com (2603:10b6:610:23::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 17:48:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.018; Wed, 13 Apr 2022
 17:48:07 +0000
Date:   Wed, 13 Apr 2022 14:48:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3] vfio/pci: Fix vf_token mechanism when device-specific
 VF drivers are used
Message-ID: <20220413174806.GV2120790@nvidia.com>
References: <0-v3-876570980634+f2e8-vfio_vf_token_jgg@nvidia.com>
 <20220413114525.534d8b76.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413114525.534d8b76.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:208:256::10) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de38b422-59e8-4d02-dce7-08da1d75c4ae
X-MS-TrafficTypeDiagnostic: CH2PR12MB3798:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3798FB5D449522B6E4D3B154C2EC9@CH2PR12MB3798.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f1Wp1xSmcQoNZY9qCy6mFuk3GEYPtWuHAr2yPm+IgJ3xw+Nwxp+uYE4fwQ/44fGlBz90EgoJyORPwU5pmPyM9RolMDfURwg8simExPAqRwPYcdRvBfixN+T5VJV7qAjkFPwpVDFId1Jl919WL7yqwuOY//OrddHpwuZdK33NvuM0cuboL7zhunGW+u6DxIz/o8ya8q7zTIY8s8x/mT0Vr8eqoTorAWy7feSkNRvnHOpec+0HSMC1v5uw4SfZHGUZ00Ru3uUFZl6wtrdBoyQpwnSUalE7nqlgGGf2Z0Rh0nJQWzdD9S/vCcLKDFVM3YIlJp2BFsC3KhUkTOoem44yHnZ4wPKmZgUZ8mPsDzzLfAOe6Hi+T3VImgByA3muvKW/LZcUSLdDJLqA8BZecFpk6PJikuFVs1l0nU38v9dz2bSs+v2qMhSnbeCMIrbPCpsqqAFaMlqPN089JFePievKZneAMkYsyhBnqQOA+Is3aJGdzYK9/Ydty7a86CNvqgiwfzZD/Hv9xVHiwhxOoXbHuiHILAm4kPhTCIbF+TGQkgFamWLZTkVxCSEJX+bBUcJY7MnMPDJ/hp7az7nUDhHEQVwnn/e1spbUCaNZXqcz8A3UAvrP0FZUsIdMpaQIPgZCtosdEKUJLqsvpq2awj4t3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(316002)(5660300002)(6486002)(36756003)(83380400001)(6916009)(8936002)(33656002)(6506007)(66556008)(66476007)(8676002)(2906002)(6512007)(66946007)(4326008)(1076003)(86362001)(26005)(186003)(2616005)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bp/gh52t0zI3ZihxehCk2Vl6Go/TelEWj15b+od2xalho39NMVG5kpcYAZay?=
 =?us-ascii?Q?KCS9I2iq4zhzb22JOblfiKouUC6O0sAgTT/6W5g+YbAQg+Js9JFmoZ/P6nkl?=
 =?us-ascii?Q?+zA6QuuUPI5UfRaDox/R2qmhLrVU4SBuC1R7JEjx68w+e644v/O2Iz4ixGW9?=
 =?us-ascii?Q?m8ng/bAavIIktj4PxyR9Y0bn0JA8TvCUulhNJ7yKFoeaJ9+cGlBmLFLU9Aj0?=
 =?us-ascii?Q?127u37MkrikRMSqr1hjEKjYkFUCVh7UQeF9RXLStpKBmfO6LPNwjwv/xeB3j?=
 =?us-ascii?Q?U8LJMydP68nsoo9+W/BGa5oqZ4TPKGb+Hw1/SWAhZtHJVO/Z9NbK6DGu2cR8?=
 =?us-ascii?Q?40uxyPSlc3MdCi0awzPgF1ZD3EOzrqqUP82quhfSCiVmmQm7KZN4NpgwmJnq?=
 =?us-ascii?Q?mLBfLTWBQ44DsYnMaWz3LAZ+PPGrVStZMeJGkqw7NDYG7mXQ51V6+bP7C/va?=
 =?us-ascii?Q?EimhiczhWn+8cAiku7FjG8xgtVGVwOcHMCLdkqTwLTS7fzWR6hN9Yi4ddu12?=
 =?us-ascii?Q?aVVHFB5LZnm0MXiRYKZ0YF78PN7RqeEebvmrHjmXcw0L8rTHtD176J+89tiU?=
 =?us-ascii?Q?E09wsLFXSCdKCSTgqjWNoJmZq7mAKRBnPmoxKyGzZPn83ddZ1h1DMWiVGxy9?=
 =?us-ascii?Q?FjcT+67UM6tUvD7gjrmsGnKaoyYxXcU4BQcwMV73SIKTZzshHDxUFtHY2Zqf?=
 =?us-ascii?Q?Kq7qbfAQPiNZ0uFblMUcggpcUPcWlPdbKZR2064nilsOXBl6BWg1vNdGHuY5?=
 =?us-ascii?Q?fw70xJRJMueq2RzvW5ku4ATQ9OAunOyrPF5wL5krOYVNv7RQYLothgEUHoLD?=
 =?us-ascii?Q?Ogrf+MzSPYClV63+XGMtbnz9hpILVrxmxcgI/6l15PX34DTbL66me/Y8AES3?=
 =?us-ascii?Q?6dzwJXF5iPCeANmRN6TyjxLDKXcvLJFKN3NLz89hBEkNH+QYTiq0B+Ip9qGb?=
 =?us-ascii?Q?xTKZH2Gk+5cE88YNq7VsF4o60bwbHzqCRB5l6/M9NOqrVCpAw5PsfaHhPEta?=
 =?us-ascii?Q?8z6HnUs3uS+eBgSZQ67moxi/qaUkC3wPXUajzOqwB7i0EL2OmG0ZV9hDwY65?=
 =?us-ascii?Q?W7ETLIMoY2L0fbzHLB0xkOZgDasGv6gwzmE3Qy2F0G1FwnvcphbAb0uBaPID?=
 =?us-ascii?Q?HBAihVD3YbNkaAaWxOaiCxxpo7501VHerMuSph64GQevoIfUeT/L+0uqLpEz?=
 =?us-ascii?Q?Q8NPxzLzfwkAUnVFsIfZQJlZN+shVvMQCK0U5NoFgyoT1vB3TbyaDUhfc1CI?=
 =?us-ascii?Q?2dNLXlSFalUk/HvSTomHUykvnqCOJXMmFUw9qs+MOmrJsYQ9wysVv/Z9XnP9?=
 =?us-ascii?Q?IyHBocxNnM4/zuer2CSwsM3U5nJePTCZpgPmLb/a0nCw76Z28t6fyniWEpvs?=
 =?us-ascii?Q?i/RH7IRQ0x706A+t78ghwBGIL6cMM8APu9Jrnt2EAhfkWsJm2gC62l6pqUhU?=
 =?us-ascii?Q?G4ygVJzJ+qUb9jlrHfGKM71XKK5VnH7mNGhCzon+hKwEwgvcYjUMtz8/wopS?=
 =?us-ascii?Q?tzViJV+O7NwX1suoZd7ycSOKeahXRveUsZpzlwRcaGHs47l6bD+WHL74bnnq?=
 =?us-ascii?Q?qvfMNJsxx2LY78dPeDyRXAG34fFUQ1kdA8ois0pNpikIRV7kn6bvZbN33eLn?=
 =?us-ascii?Q?VuUhG9N2sdqLlAb3GeSXZ9RFkf5D1JOUr1ck3Q4iJuzWbW1NJrbJ9yyLBCic?=
 =?us-ascii?Q?Wq0LPh0KVFS/QqY+rfk9d26ce4ueG4hNa2PRoGFUkePVOPJ9l6D3CjL0O0TP?=
 =?us-ascii?Q?LctS9n4nxQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de38b422-59e8-4d02-dce7-08da1d75c4ae
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 17:48:07.5300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CsJuBPXFc9zVwHmDkrKc4wyIGuE6gYOG8300EBi+xsmBDKbxc/ycUsFVMKW1+8p2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3798
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 13, 2022 at 11:45:25AM -0600, Alex Williamson wrote:
> On Wed, 13 Apr 2022 10:10:36 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> > @@ -1732,8 +1705,30 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
> >  static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
> >  {
> >  	struct pci_dev *pdev = vdev->pdev;
> > +	struct vfio_pci_core_device *cur;
> > +	struct pci_dev *physfn;
> >  	int ret;
> >  
> > +	if (pdev->is_virtfn) {
> > +		/*
> > +		 * If this VF was created by our vfio_pci_core_sriov_configure()
> > +		 * then we can find the PF vfio_pci_core_device now, and due to
> > +		 * the locking in pci_disable_sriov() it cannot change until
> > +		 * this VF device driver is removed.
> > +		 */
> > +		physfn = pci_physfn(vdev->pdev);
> > +		mutex_lock(&vfio_pci_sriov_pfs_mutex);
> > +		list_for_each_entry (cur, &vfio_pci_sriov_pfs, sriov_pfs_item) {
>                                    ^
>                                    |
> checkpatch noted the space here ----

Yeah, I usually ignore that.. we don't write "for()" after all..

> Fixed on commit, looks good otherwise.  Applied to vfio for-linus
> branch for v5.18.  Thanks,

Thanks!

Jason

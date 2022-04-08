Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E3A4F9B57
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 19:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbiDHRKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 13:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiDHRKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 13:10:48 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE79FFF64
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 10:08:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1TY2ASzuOk4PFcVyNvXzTYdoxDQawHs8eGNlhFfvw0YL/5xPP+21wn0bxWVFl7JGs6vIgb1TUMJvMDBgGNJ0UHOIeriwbHZ96TK7+sIdA9B48lwst6Qs4GV53CTlMC119B08PxecZsTSf1c0o2dbfiYmrxszcw1HTtG9v2iQUu4LkQI0WNeqS9cqrg40qEEjacbRb0mMsyAfoHsPZx38q9QPlpb6WlXn33CMvA7uIvbZIIKiEH0lkkIQYGvEPCxn3Zbs02tHtQPoC7GTjTZQex0nKyFk/crQcv5ThcgnYeHUWeG6/N2A1GEmhQDQgIZo8/4IM45J0ObVzoIMgWtfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zoIcM+jY52ZOVXUyw85kV82CzXDMW/UX+LVaAhfAEbw=;
 b=i2fWg4REnCQIPKlv/V5gxWi309h7n+QCnAwWsaVg6kHbdbSliyMxFlgAa1Hvul//LAfvUlvP2vOvAb17yc8xl6pOy8vNmRRn/ecMysEA8SA65rGpnDxXG4f61eVGsMCjHADkOGUJEHUf/AeNOElZ4+TE9RtUfz9qiYw60sgJtYWoQ/pwGswX19jNKMz9HM9eUu7xlzIjgN6O6AAaWAX1SE9pnodRVsBcibLmE6cVQrHyM2KWOuehhkPXetmDyYGkJE6KXSOfsppZd5juqMkEIwlvMAKI2FNscKR/uI49OR4AVzi/gh/gKb/2ZncBzJ8Cz/8QgjiHUX+B4KIYOQB/Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoIcM+jY52ZOVXUyw85kV82CzXDMW/UX+LVaAhfAEbw=;
 b=VGzzEIUxb83Igl2teot+x0xNeVb4J7H7ehSlZ9RbQBJ1C2i5Fg/g4RmcdMAYkZ1Y0NMPOUZnrpncmN4fiWRnTGAczumRwTDzOeC3GiCsDbm5/g5f4sbIZWLpJswd1fEyESTXAPAE+Qkt8FfBeLHq2jGcmoCWfOyZljrt0OEkTi/NRuGhu2qwmI3Ddxu3rgPHQNvOg2wej6MtIhmJ1fr8v2YsU3rX21Xb/HolOXNFgztlchny3i0VL2IUc+32aVF1O4cTQSy7hegK9lE0BG+EqiLkDxZ50y94kmcZH6D8jSQIJjiSxqf7xkqjBPTEiXrTyYdB4xsjsnOwRfZy5n+lZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1775.namprd12.prod.outlook.com (2603:10b6:300:109::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 17:08:41 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 17:08:40 +0000
Date:   Fri, 8 Apr 2022 14:08:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH] vfio/pci: Fix vf_token mechanism when device-specific VF
 drivers are used
Message-ID: <20220408170839.GA2120790@nvidia.com>
References: <0-v1-466f18ca49f5+26f-vfio_vf_token_jgg@nvidia.com>
 <20220408105305.1ee00b44.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408105305.1ee00b44.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0280.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9e977cc-d8bb-49a3-caeb-08da19826db2
X-MS-TrafficTypeDiagnostic: MWHPR12MB1775:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB17757ED256B31B71CF79F915C2E99@MWHPR12MB1775.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /mkfUE6yklDgbRgq06u0LtC/OAwVoGL+NMDWauDCQV66KBSMrN1ELAKzzXQ13RMtz9ySq8vss8wPVGozigbuX0dRSSEdgLEaLi+gRYOurSX6lfZ2eeuZkBNpEvVmZG33S6tcfX0FoCtW/WjdVOuTapwx15Kto1+OVdJ8nbCd0pZkkh/r03xQtr4cUSBg7aAUf9V7DR1YAdGkxqr5lE2Wd2NC7S86auj6+1YtvQniQb4NEBHXM7+9UQDqNy2WQ7zU6thfP9HutjfmkNnW8zufNKpvVmEVb4xgCgh/KqA+FcO/7ONpVyBmHbZxnlGVasEG0Olc9eCHPQF4dNAtDEuXV+txdb+D+4623H0/RmXt1tkGYmy+wdoRbjSXGwbclUpSxpXzB7ptzrJtipf/FqcyXFp0mfuBIlYMn5w9bc7rOVn0QXDXLWovIr6liuGtPfSjzBZLGLN4GH/RGiLx1q0K81SvaUqinEjQBW56h9Qgy545gZmR7NZAOhnkxdy+DZ36peRgrJsE1jn9tbKMjvLxjVScpXE39Fa0s/OJdGt0oNuYcU0tgL+j477m1gXOfbspGUZvLj1E/ETcMfLPq18KpWUuT5hrgZ1uLBh7JjBEL3STUHew+Gno4AQNp+cwFjtNpJJ150Pf3ra5SdW+nW6tkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(4326008)(508600001)(8676002)(2906002)(6512007)(8936002)(107886003)(38100700002)(2616005)(1076003)(66946007)(6506007)(66556008)(54906003)(5660300002)(66476007)(6916009)(36756003)(316002)(186003)(26005)(86362001)(33656002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R5r5CZFGgJZHro3Hxl/3E6Qyc3hYHmODtCTQhBIxpFng0prCe7ZuDf0ffmDA?=
 =?us-ascii?Q?gn50UEc8mvl/0kyGth+kpiXd/osisEIxkk70r3W0vFZvusYu+q21goJd+Qdq?=
 =?us-ascii?Q?2jsGKnRCdb6VhEFQIe1GJma+9NMXoH3XgiuFKJXlGxpgwEPvVZ/OBYtP/2Xe?=
 =?us-ascii?Q?Tt/XEB1DcptfXqvkiuNHmHb5OboTfloM/JpnsTQ+qDpLJ25/zz6GEMIRy6MZ?=
 =?us-ascii?Q?T+5Gyq4cHpbsWoEXmw8uzEMAS3rA1tQ8bu9X1VqdgWPbEj+Oouf43tOXUL4D?=
 =?us-ascii?Q?OD+ENK5A/ox6odbhHfm4/HEPDe2+6Fwatt956iLtwHNyhVP3P23GZnzliWv5?=
 =?us-ascii?Q?euJMRVksoI3XoUiLokmvQTz4xv4UkQVieI3reKud6r94GHabipd4NQwUiXcW?=
 =?us-ascii?Q?+HZibioML3aKol3hf1IxeGZxJN7fmY0KMRWDzP20i5rXuT7Y4M2ZnJ9Z+4xe?=
 =?us-ascii?Q?EyHUfL70T9aNb6AdxbQ2zCEHsarFRE8rLrDqAoBR0+vJGajtCoBQSU9ZNoP/?=
 =?us-ascii?Q?eBwQnvFdsUrk94YrQZTOY80pX0ELwBJfjbmmMe5VfCop/ZAdT3w2VUnGO4X9?=
 =?us-ascii?Q?SBXs3UrJzDk2l641PTNJCj/RE/aWleLYSeykr9djnY7uWxpZQvrkZ0gFaPWM?=
 =?us-ascii?Q?RVoc5dRahtK8X134NU4GGdFZcJVZ0ualRaXKTEhjKWOgUR0dIZXsGeqj8VTk?=
 =?us-ascii?Q?ZQbTh80aM5OqoesYT64itHNlm8Ou5pdx0BD6U3osL6YpWOd4yB/kwYcWoPfU?=
 =?us-ascii?Q?VXQgkQ7KsEPKOaiP2i9Kg7WYfGI+YvdUFQbmYtAJ2mfiNv2YmGUktBbw0w8t?=
 =?us-ascii?Q?V57vSwwnGYtDlK6I9kUI4H41uletvFsAwjC0Dj6FPynEj2zybET4gSiBzxrj?=
 =?us-ascii?Q?2hdm/8Uj5A4IOhFR1BmomngCFBUmod9EEc3n+neQL+b536eoRd3TMY+uBtiI?=
 =?us-ascii?Q?lFb44+M49Z1ud5jEsxxSYjL6/Fod9SdJFjujUF8lFpxh0tSX5P9jvmlMVLVt?=
 =?us-ascii?Q?L+Cp0pWp6kQWTx91y5Y0F+fdn5shpqMeK8bTDApvlW1zXuKFxNmTOsfVYel9?=
 =?us-ascii?Q?ORpHH3T9ugeI64WvnlcLAHKriCR1iZDzgUah7uZgBj4EF0NHoQb6PZPIzbSZ?=
 =?us-ascii?Q?8I2JnmrTRNx6HTMGFLdo8FWjAShytLD9ltXrrbcz4C4NmbRra16StdezjRl9?=
 =?us-ascii?Q?9VqzY570956KuLVK4iNJb8vaVvkNFPpfB624r2FYsO7Uhui3sAKw7XNB1SNt?=
 =?us-ascii?Q?biAhMRgwsWUhOkbadToy3SbOsjZ9n9Lxj8ZQ4DvQX3nqKyNplF+AFLR9KyWb?=
 =?us-ascii?Q?01+bs65tB2gRRrEdr7UArOC9S8DzdxY+lfVAhndhOvy7rMxJ6j7N7TMJ4paD?=
 =?us-ascii?Q?rXtBg6GZEtGH1jwmzA3jvdM4BYNI52FP/MuYpMMBEgNo4zfSuSy7C7dI8cZ1?=
 =?us-ascii?Q?W8IIQiWML4M3vjG62gEaK8iHxrHeNPVOf5L90Jf/VDW1GkC5Df/l0+igNTmD?=
 =?us-ascii?Q?CIY+KUjhm91Zs9L7LMyEnTg4AFgtbYfkgSoiXo+wesKFl+BAJ8FpnYlN79/l?=
 =?us-ascii?Q?MgWzXJ++nCT1Qo+daqon4Oaq/GY4Sk7C523w3M95V0TkqHloqK8sjFTZ6kVP?=
 =?us-ascii?Q?6JcfFuOW1+Wfn968WcMSNrjnP6lRsfmRAlHRZz1sGBpCBLxHh94mXw9Vzh6V?=
 =?us-ascii?Q?lkSvAVe06+E31lDY9PsEKrUF8SV6YSDepMt9dlAIp9Grw+CjU2NNNlJyf/tZ?=
 =?us-ascii?Q?Sb+N916QLg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e977cc-d8bb-49a3-caeb-08da19826db2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 17:08:40.5722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Vv+h2eTamVFJjYtELQf8ySRHnJL5v0TYcU09Ogze9ZBlZYNAwEbVnqMQ6hYLBJp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1775
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022 at 10:53:05AM -0600, Alex Williamson wrote:
> On Fri,  8 Apr 2022 12:10:15 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > get_pf_vdev() tries to check if a PF is a VFIO PF by looking at the driver:
> > 
> >        if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {
> > 
> > However now that we have multiple VF and PF drivers this is no longer
> > reliable.
> > 
> > This means that security tests realted to vf_token can be skipped by
> > mixing and matching different VFIO PCI drivers.
> > 
> > Instead of trying to use the driver core to find the PF devices maintain a
> > linked list of all PF vfio_pci_core_device's that we have called
> > pci_enable_sriov() on.
> > 
> > When registering a VF just search the list to see if the PF is present and
> > record the match permanently in the struct. PCI core locking prevents a PF
> > from passing pci_disable_sriov() while VF drivers are attached so the VFIO
> > owned PF becomes a static property of the VF.
> > 
> > In common cases where vfio does not own the PF the global list remains
> > empty and the VF's pointer is statically NULL.
> > 
> > This also fixes a lockdep splat from recursive locking of the
> > vfio_group::device_lock between vfio_device_get_from_name() and
> > vfio_device_get_from_dev(). If the VF and PF share the same group this
> > would deadlock.
> > 
> > Fixes: ff53edf6d6ab ("vfio/pci: Split the pci_driver code out of vfio_pci_core.c")
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/pci/vfio_pci_core.c | 109 ++++++++++++++++---------------
> >  include/linux/vfio_pci_core.h    |   2 +
> >  2 files changed, 60 insertions(+), 51 deletions(-)
> > 
> > This is probably for the rc cycle since it only became a problem when the
> > migration drivers were merged.
> ...  
> > @@ -1942,14 +1935,28 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
> >  	if (!device)
> >  		return -ENODEV;
> >  
> > -	if (nr_virtfn == 0)
> > -		pci_disable_sriov(pdev);
> > -	else
> > +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> > +
> > +	if (nr_virtfn) {
> > +		mutex_lock(&vfio_pci_sriov_pfs_mutex);
> > +		list_add_tail(&vdev->sriov_pfs_item, &vfio_pci_sriov_pfs);
> > +		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
> >  		ret = pci_enable_sriov(pdev, nr_virtfn);
> > +		if (ret)
> > +			goto out_del;
> > +		ret = nr_virtfn;
> > +		goto out_put;
> > +	}
> 
> If a user were to do:
> 
> 	# echo 1 > sriov_numvfs
> 	# echo 2 > sriov_numvfs
> 
> Don't we have a problem that we've botched the list and the PF still
> exists with 1 VF?  Thanks,

Yes, that is a mistake. We need to do the list_add before the
pci_enable_sriov because the probe() will inspect the
vfio_pci_sriov_pfs list.

But since pci_enable_sriov can only be called once we can just gaurd
directly against that.

I fixed it like this:

		mutex_lock(&vfio_pci_sriov_pfs_mutex);
		/*
		 * The thread that adds the vdev to the list is the only thread
		 * that gets to call pci_enable_sriov() and we will only allow
		 * it to be called once without going through
		 * pci_disable_sriov()
		 */
		if (!list_empty(&vdev->sriov_pfs_item)) {
			ret = -EINVAL;
			goto out_unlock;
		}
		list_add_tail(&vdev->sriov_pfs_item, &vfio_pci_sriov_pfs);
		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
		ret = pci_enable_sriov(pdev, nr_virtfn);
		if (ret)
			goto out_del;

Let me know if you have any other notes and I will fix them before
resending

Thanks,
Jason

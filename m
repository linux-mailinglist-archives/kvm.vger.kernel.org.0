Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BF740DBF6
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 15:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbhIPN76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 09:59:58 -0400
Received: from mail-mw2nam12on2042.outbound.protection.outlook.com ([40.107.244.42]:6465
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232753AbhIPN75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 09:59:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpV/gnKDcobGB6GrvxVl3b62wc9RLB0vArNDaQR00S3mvPDnxtEz6IG8yrIubrMVtiVS8aJNEs91KeLG78b3MJf/FCMJbedV7YBq/A+UZTF1/0Ty69IzhSAjSk/wEw5n4s5b6hdexrDdi6uurKCJxCVU/OtW8XePyX0gEjDr1AMnb5QaizTODyRE2muBavvHYb2PWuP6e0DS+oxYATHNJJywIlWFeT2h2EtCj4y/EpMolyKDqWPmzDSpLP061KoXjAGbLq38IqltJvaGQLiuqOAj01/Q3AvN79/UrjRg8U6NVYeqOEgnU29yS6XOll25ssQt7awP1CKT9vVjEFlWLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jOKj1pXxm6TK3BhA4iaZ/DrpQRZk2NTT4QSu5qigxDA=;
 b=BzUXhx/lTCapAaO5gbe7lWw+sRdINGtkdNHazjqANWrzSHW8kLO0Tqbm8ewhcJZqU1G8Qsj7w5IEhGf+l86Q45derG5Ww+EC2vBuMxj4GQsD+alYROZyTeh3BE3XNR2PVzjnGYmPYqg0SoNm6jyR6aIk4hulZea++L1QmZSdRuMakQCpS5YABJ5L3eXg9tOW1X41xDWlyaSvaE2+ZWCKkOYstJSCq2hfpvMaXygpChlfgqjv6FOJcoOkkRUhjVv3rQh6df5YxgrmLt1tbU5DjTU7hZCPCgD02w/poMAtjnPPPr5mCdchOKHffGpzuzHUDmFiPCue7/TlEMz5Cc6sZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOKj1pXxm6TK3BhA4iaZ/DrpQRZk2NTT4QSu5qigxDA=;
 b=fs0RGJzhLOPiiIt/UkxwkVMd8yUggzlBDCvuTPdv5JlKhKC1mCDVKWkbuyg8QSEnYrktcy3oKrKfdmgjBsT9xw9O89R3XXb18OA9BhIOZfSxu6zLJ+K/A3IZYNnatE0cZpdE8ovzW21WzTErPEfUbxy62os5O35W8bd8HJ7W6uyWXzSx+3oHKHodO5qhjGzZU1Q6pj9OmJ8enuZrg8coy7VlU82gYov82f2eZLhGqydkV38tXDIidrlIt++e1iBpT4ohI39+Ehwo0GRhLY6tVOAFjbsuYud9xV3MG7ANyN2Gz3A8H+rpciPstfPcWxnf1IMeohEvLD01y7sceHRyoQ==
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5361.namprd12.prod.outlook.com (2603:10b6:208:31f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 13:58:35 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 13:58:35 +0000
Date:   Thu, 16 Sep 2021 10:58:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20210916135833.GB327412@nvidia.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-7-shameerali.kolothum.thodi@huawei.com>
 <20210915130742.GJ4065468@nvidia.com>
 <fe5d6659e28244da82b7028b403e11ae@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fe5d6659e28244da82b7028b403e11ae@huawei.com>
X-ClientProxiedBy: YT1PR01CA0139.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::18) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0139.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2f::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 13:58:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mQruL-001NeO-Ej; Thu, 16 Sep 2021 10:58:33 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f2d7184-86cb-4da4-0d2a-08d9791a1334
X-MS-TrafficTypeDiagnostic: BL1PR12MB5361:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB536143A01A30887F6D272EA4C2DC9@BL1PR12MB5361.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ruwKQwpkmo6itMkvqbUVrqp2lURTj0W2UvwN0Y4bY7gmwsvf5vGnYf5D7MKT/SO4eIfX0F3OF0+hxFhMgxcwPOA4AxKorTR1BweqlcKLQr12g9brtI6vaydt0R7Dx4u0LHd08TaxuurqWeBwXcbY/RIVobPvhnMTcUy99ZCsd8jGtRUlOiKnkPkDKzj0HUmMBRKirwWl9VqJsZ5qGhareXsiCxZpZOzh5BGIJHPsfe26aoFdN54BIeLw/ybngPBPPvUeOmxvvm0O/+yGcBPPawb17CuvA3CvJnnQtVD0Sy9cVn5AQ5Ct82lRPmWNbiFeYpevYrdXP7AypzItVtGhAOiRjORp+y16bffUi8DsMtOTkdikjZ5L9uN3EjgRCOG7EegiHrp613nhqueVG2ZAP56mK+l8EkpiVHWZv56/VbrSoDt6JVOXZuA6oyZJgqKfKFO7Pmi9ih6HSVUN3I38NfEGc3FW1sw0l4CmOfp1J1wkshuSVlHNuR0XUZOH/7PWfJvswPD9rOcc/6JPBvPEq+1qYwr9TNSKvUAR/x5LAPJGy5kDjVMJxAgaUQ2Kwhbm2hmRcZUUeguBSTFOK08OKq3DkYzn+DqyitC33PTSHndHnC+9boyqahqqySWOUNlAJiid4s7zCB9PWpA+DNuzEN6o6UuYwcwGhONZcyftERc2hpaEj5Cab9Q7CShAocWW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(5660300002)(508600001)(9786002)(4326008)(83380400001)(6916009)(8936002)(53546011)(86362001)(66946007)(26005)(1076003)(186003)(54906003)(426003)(2616005)(66556008)(316002)(66476007)(38100700002)(8676002)(36756003)(2906002)(9746002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3RvSHlTREllWlJWQzVmSGRGQTlQbmV3RUI5VWpGZUUzZnBRSzg0S3FpM0JU?=
 =?utf-8?B?NWlNYlByMkNVaUZ4bXZtSFN3WlV4MVFrcFFhMk9BUW4yR0Zma2NzRnEzUFVT?=
 =?utf-8?B?aTF6RDl5NC94ZHFUV2xhZXdpUDhuOWZoMC84Z2NmcU83R09PMDRUeVEwd3dX?=
 =?utf-8?B?SHR1azVTQjlBT0VJUWVaYlVRa1B2OFMraE5yR3VuMlM5OFVoN1NwSUpWVk5L?=
 =?utf-8?B?Qm5wOVkrUzZMNGJvQjdVSVNOQmV5N1lUSHoyUUE2L3VDc3I2eXlSTWlXU2x1?=
 =?utf-8?B?Z0RGd0FQU2ZuVTRTdmRuZDl2V2pQWkJvT3FVZmtnQjhLSVA3SVBXM2M0OHNK?=
 =?utf-8?B?d2N1YkdOZzJFWGFhRTQwVFc0NnZSQXQxblFSUFkwZUxCVzRPVWRXTy9sc2Jm?=
 =?utf-8?B?VnErQnc1UnlxWWJUcElzZzVaVVB2OFFPcXQ0aHE0M1hMbDNkZEhTOVVHMU15?=
 =?utf-8?B?ZzhiVlNOb3ZEdTZCOXNESkl1TmZTVGEzOUxPYUEybE9wS3BQdGtxd1dTM1Ja?=
 =?utf-8?B?R055U3RSOWROR09NSzJlV3Q4Wk1VdkR0T2hnT2V5NGNXeUlVZGZhV0lyTFBF?=
 =?utf-8?B?VFVDSWtXZThkNzdacTBRSDcwWUV1amgwVjFlZHcwaHdsWHdBdXBNMjNOMTR4?=
 =?utf-8?B?bFd1d1pkMnRMTTQwUWZmWUJrWmt1TnFnRGJmbkJtcFJyVGZNTHNodnFSWUNE?=
 =?utf-8?B?T21uc3p1SzM4T2ZoVERnWS9KNkRtNjFMRWNSeTVXaktvMWRpYURXdHJCZi9W?=
 =?utf-8?B?Q2VUUzZUb0o1djVTM3FiMytEQ1ovNzRiRExtdTJsSTRHd084UWpuaSs3aGgy?=
 =?utf-8?B?VVd0VlRlOWs0SkRoWHJhdWdyMEF5ZkFIZG9mU210Tk4rQnR2OHNLUnFzaDJ0?=
 =?utf-8?B?MHZBYThPRlhjZlJYYW9sbmlsaStYSUhJVUtFYVBoenVBL202K0wvQ25RMXFJ?=
 =?utf-8?B?b1JuTGdtV2VWZDdiMU5jOFVDUU9lQmp1SXVkSFVhSk5BS3hIZ2IrTndwbWUv?=
 =?utf-8?B?Y0xLR1paa0ErQjZsRGMrOFFod0FoYmRGL08ybnZldEpNaDErcGJZQ2lMc1F4?=
 =?utf-8?B?VlBXOFMvRG9iSlN0aDIvRDY1UEZOQllLTDBONjRzaU1KVlVSMTN4RnZzSENJ?=
 =?utf-8?B?YVFsd2pSVnFvVTh4NEhjdk9MM25tVEFxSnBXdm01K3l0M1Fzek5jbWF5QnFy?=
 =?utf-8?B?OGo2Nk51N2I5elBrVmVhNk5xTTB2WlFUQ0RicWtmeXUzdFg5MENDMEhQZVY3?=
 =?utf-8?B?YXU1Qyt0U01oMCtCY3c3TTI1OGxrczNZcXNUTHhjWUhkUzhxSXFnN1gycktL?=
 =?utf-8?B?emdGa2hxQzVzTDFNNWRiREhqZGNIU3REdExMbzVuYVVrYzdhY253cGhadDBI?=
 =?utf-8?B?SndrYUNsUFpzWlFHRWZQNEZscVRGOFp6MUlscG04MGg3Mnlkb1Z4cFIrTklw?=
 =?utf-8?B?aFpnVDduQmF6UEFRZlVRcnBzbW9iV2NsT2JydHRvYWc1WnpyU05EUi9KU0RR?=
 =?utf-8?B?cEtuSUN2a1N4V0gxVUhPRG5YRjFDQ2NhblFuSlFjSFJwamRsUkhFaE1mMjFk?=
 =?utf-8?B?WXFNL0NhZUplcGowTGFKMnNKczVIcWI1UmcyVi95V2EzaGs0ZE5PWGE0R0lS?=
 =?utf-8?B?RFh4dnFJK25Xdmo4cXRjNDlyakpaY0QrWXg0WDJCeG5OaWZyVzFCT0ZhMlBo?=
 =?utf-8?B?bHFRUTZoUjdSVEFmSnhKc0d3VjBZazBIN2tOLzlOUEJMK0lteWFyTzdZeWpL?=
 =?utf-8?Q?RODLRX45cJ3R3yi20FwGPeFlByjrGcacfW1BAmv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f2d7184-86cb-4da4-0d2a-08d9791a1334
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 13:58:34.9338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rzrSfNYiMiYxoWo3Dlwwmyawp7qSt9p8xgVLXJ5dKr4Sqgo2duB+VEJbd8ZdO7gL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5361
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 01:28:47PM +0000, Shameerali Kolothum Thodi wrote:
> 
> 
> > From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> > Sent: 15 September 2021 14:08
> > To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-crypto@vger.kernel.org; alex.williamson@redhat.com;
> > mgurtovoy@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> > <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> > Jonathan Cameron <jonathan.cameron@huawei.com>; Wangzhou (B)
> > <wangzhou1@hisilicon.com>
> > Subject: Re: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
> > migration
> > 
> > On Wed, Sep 15, 2021 at 10:50:37AM +0100, Shameer Kolothum wrote:
> > > +/*
> > > + * HiSilicon ACC VF dev MMIO space contains both the functional register
> > > + * space and the migration control register space. We hide the migration
> > > + * control space from the Guest. But to successfully complete the live
> > > + * migration, we still need access to the functional MMIO space assigned
> > > + * to the Guest. To avoid any potential security issues, we need to be
> > > + * careful not to access this region while the Guest vCPUs are running.
> > > + *
> > > + * Hence check the device state before we map the region.
> > > + */
> > 
> > The prior patch prevents mapping this area into the guest at all,
> > right?
> 
> That’s right. It will prevent Guest from mapping this area.
> 
> > So why the comment and logic? If the MMIO area isn't mapped then there
> > is nothing to do, right?
> > 
> > The only risk is P2P transactions from devices in the same IOMMU
> > group, and you might do well to mitigate that by asserting that the
> > device is in a singleton IOMMU group?
> 
> This was added as an extra protection. I will add the singleton check instead.
> 
> > > +static int hisi_acc_vfio_pci_init(struct vfio_pci_core_device *vdev)
> > > +{
> > > +	struct acc_vf_migration *acc_vf_dev;
> > > +	struct pci_dev *pdev = vdev->pdev;
> > > +	struct pci_dev *pf_dev, *vf_dev;
> > > +	struct hisi_qm *pf_qm;
> > > +	int vf_id, ret;
> > > +
> > > +	pf_dev = pdev->physfn;
> > > +	vf_dev = pdev;
> > > +
> > > +	pf_qm = pci_get_drvdata(pf_dev);
> > > +	if (!pf_qm) {
> > > +		pr_err("HiSi ACC qm driver not loaded\n");
> > > +		return -EINVAL;
> > > +	}
> > 
> > Nope, this is locked wrong and has no lifetime management.
> 
> Ok. Holding the device_lock() sufficient here?

You can't hold a hisi_qm pointer with some kind of lifecycle
management of that pointer. device_lock/etc is necessary to call
pci_get_drvdata()

Jason

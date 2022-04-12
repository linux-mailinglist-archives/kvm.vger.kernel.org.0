Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D06D4FE92D
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 21:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbiDLUAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 16:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbiDLT76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 15:59:58 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029EA6D861
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:52:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgKqFtP6Hb9wnNSSowhn8qsp2pRJY54YoJyhKzxtt79WJfg+Ak9naE8GRySdcgVBC8TaBJB5ShAFoXa55DXy+YEPCyXWlv0CEjvG/ECl+z+vxUP91EG1pQEAg6QuwuvGxGiRVbh0+A+OQPpcYgw0wtdvrAs7d2nANzY+jSYSrmTZqts4TM9pJBRerNyAfNon6mHR38mcE9883o2YsIwZ0/Mt5OaNk3G0MrbBZDtdBvbE/t80QTMQ27tW2LlImJBvZT4vlnovGZvonxQPVdfOcD3/vQ+Tk92J0VsYlVhrC01IDWNyjjMTSWm8rXJ3Neje8bfTPa456CLs+CzdnOs91w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xObiOvHyDu2MRiVbm4ABRq7LXQX8vdTAcNEW6ev3gZc=;
 b=jI+Ej8n0SLGyNXRkQCgx89r3b3vW79q8+fsvTrQwjgMKjXIHOaMpyH8nhqsc1O88EWLtmBea7aIEJwZlSq3bEbbcsqrrQQEZkmMJQDiyuOM/WdFbvPnlQDV8UiWASOiSAv0e0OU0iWkrvlCxlRM6vkUkTJlaN7XczSuTP+dIK4sntF75NjzwslNZHFuBgNYdhjB/qjPma8GGxr6umxshOqyNa6VT2V7VAg3VWJGMqVMSH0EHQ5YeVRQgaiOADJvoUcVpdTvp3BZ735X9PKlHzjQa0vZnELIlOTucmkgwzYjneTdXrTbpSsqSstH/L0/VsC38v+7Pc/YXcgRKVxcj6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xObiOvHyDu2MRiVbm4ABRq7LXQX8vdTAcNEW6ev3gZc=;
 b=Sti3Oe5CCLFAcp/p4ZgDkS9iNugq+WlSXFu3SIhgy2m8nYNHcMt3jOyCfkGIbUgeLryM1S/FhqJps0h2inWY8HG0i36ulLTrm+f08DzsaSJppN4N8ixj3WKopsyQdUyQcJ6zNWrVxZQT4PlbyI/T/mEC8a0cSx9tNHw/3zLYGfHIArc9gYbfEXuDHzUMPcNgbcd/IvuAmcMB4hcv6KD+hkxKgxNADWwU3rK4xLtnogmPHXOO43xQq1mfYIEHvuXZ3J2kJ1sQbdC85TAjbTewW/7vIfNI3hMrAzv6YIVIKmMX1zCoDI6EdzeCxOZZJ7Yn5npF+b+kHAR3lqR7WPJZbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by MW4PR12MB5602.namprd12.prod.outlook.com (2603:10b6:303:169::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Tue, 12 Apr
 2022 19:52:46 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::c911:71b5:78e6:3a38]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::c911:71b5:78e6:3a38%8]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 19:52:46 +0000
Date:   Tue, 12 Apr 2022 16:52:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH v2] vfio/pci: Fix vf_token mechanism when device-specific
 VF drivers are used
Message-ID: <20220412195244.GK2120790@nvidia.com>
References: <0-v2-fe53fe3adce2+265-vfio_vf_token_jgg@nvidia.com>
 <20220412122544.4a56f20a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412122544.4a56f20a.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0403.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::18) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf0dbc63-e8c4-4ffe-10ea-08da1cbe03c3
X-MS-TrafficTypeDiagnostic: MW4PR12MB5602:EE_
X-Microsoft-Antispam-PRVS: <MW4PR12MB56023A857AFE9CD910B1D09DC2ED9@MW4PR12MB5602.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jRg2NAfCQIQX3U/mCTo+zCUtpjvuTKm/KnqVr48l0Scz0yLNAryMIaAZo/6gSyWCiknUIoHS2y7EJpabCYhOpPC3MyQ5xlTlOXm0LMigt+RZYjBIiXfEIwizBr62RUOuyViw2nllx5vPneCnqP5prYT24FGnjyaOkChlQRAVgaI4GuHm9xFJD6uJtRP2JDo0YrBJdjDTtcm8eDL+Pw4noGkqhgpc6lzFQmuYX/BcM4GgBFA2Py99mNu3VfPEpo+pQ8AYIISIxIi8nT4lrRFXB0od9Dt+VRAxORGSrqu8/Y21KeKwvOxqytw4oMzYWVsceLh5ta/3I3lgVuuXW4gHte16+Vn3GEtJWoaHzp7fp73uDOAOPnwoNo7HdHYUX6VbUMKtSswRexK03Bcp3aBWdSG9pDhdZl26LjacYR71vI2J5bFmxYcodsqdfJYkF8DqVCUvjDIYe6ShZu5dlTM1fprzzE7Ii6qEPKbGwq64ms/JCRBxBwYgMq/Q73fonw0jXeJ9j3s3x/cS0H33wD1h/SSG749IcFZlMs3SQrrCQX6jujjHJL/7CTeU/FDhUgroPnsjHb9ZseBlbySm01JH2mIXQmW0mpeQ0WiOCNgF30x6zBTORWSBXshr0sn7M5KBLw3GLmhn0scffqsrsxLe7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(2616005)(6506007)(6512007)(107886003)(26005)(186003)(83380400001)(2906002)(8936002)(5660300002)(6916009)(54906003)(508600001)(6486002)(4326008)(316002)(66946007)(8676002)(66476007)(66556008)(33656002)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0ASsBdVI5LcqKbONtYccPwwSpdazFOkhkDn1LmRXP0ukd+m+APWiMO4n7m3U?=
 =?us-ascii?Q?phEdBLfckugyEa7jvd5KcsA4tQGn+mgTzjGWw3hzmYLuJ3O9nbmcuHoQfARV?=
 =?us-ascii?Q?TDLSfzsrhK3O2q8C1gQzkR0gMsh8s4/ZdbrEUwbE1o1qnLpNVrdvpZyc0t3a?=
 =?us-ascii?Q?clYnLRqyZpj2Io6kJS1O0RT5t4myUaC5nTqh9sK1YBXwCjpcMFFtrwRNnOKg?=
 =?us-ascii?Q?WCQIoUgHlK1vx+qaNMkW33MfCA2+KcxZJxHJzAUjBjhLE6qasbHFEauEGlPq?=
 =?us-ascii?Q?AzoHy0ph8GxVkdfMfT7xXekkw1ljF0+iRWlBR7ozIAjCqYylvKmiInVIk1py?=
 =?us-ascii?Q?8eFCHR4lZTt7zcfqOfWA8h2vCWTUfZ0aQcZmGdpUhqDXGVWQr6xMSmgYvNBM?=
 =?us-ascii?Q?Y6NWFlM0vsjgWF6qGdiaXDmUyTVPGPQjzrgkQqu2/3N4hRdENW+/dxqJFkD3?=
 =?us-ascii?Q?RlK2fOt06lskm1vLXKnsRfM7uC1Ljo1RFTZUO+snV4vh0VSCd0449oQSlNfR?=
 =?us-ascii?Q?kFgSamwqAd03+YOjvWrQqb9te0tsTcmcyhTiADv8N0gQ2n6X3JaZQUporrDC?=
 =?us-ascii?Q?cHOpoZi4Vakj+3tRzC5eyApyaxTy6xUj4h6/eP7QvjmUVsarkHY1B1w/5h1Y?=
 =?us-ascii?Q?MeqZuL1hjdomvx9eDnPRiX4kcIp+cDw4FOmXm7GoBygrwWtgNVYfIAOd+Rb6?=
 =?us-ascii?Q?OtaD3BzJ2+OI40GuVkjVnXeRsJCCvihDrWIBf0tcp6vMO58XiE4XfzUX3r5x?=
 =?us-ascii?Q?y/Tv1UmoPT4XDXrbn/LO7dFi8NC8wiIpxKjfnw+eiMikNZU0l4H1mb6BeaEb?=
 =?us-ascii?Q?OLsXL/G7bEeVNLw76OdPBvatzRzBiH7HJZeX1cJtCgfs7lyMnjw8YIF0pfWy?=
 =?us-ascii?Q?vKr5yxhGiBSybgAZroaURmVuJpLW5sZB5XvDo2CtDFarjO4nyuajZbftYAY0?=
 =?us-ascii?Q?Z2gcVk+DpOFZfnq66Fye2NJz7501YaVvZTehMw6qcerCzze1FFb5/ig20jKD?=
 =?us-ascii?Q?pHwEzSPxuRfqQVHF0WH0JkW9mX9FpCM6wuiiwq02VHOk6GhgIETib8JQsPyT?=
 =?us-ascii?Q?UPZc58s3VL5Eth+FHefDF+2Px7LvOePP5B472+6JxeYA02gScGPKYwTWw3nn?=
 =?us-ascii?Q?vSzbnoBRhzbzVl9Wvlu74/QL3cNxQOtoCH/ckAiahstDhsNthM7HukBiqNAK?=
 =?us-ascii?Q?Hvew8FfBr2dpd1btJrzydOifrkEwCmvOJ7FrkeQnVYIBvPTXPl8ymyPLa7lq?=
 =?us-ascii?Q?rD3Erh1gEQ9+xs5O5SJn+8BUFhrCmjLqrFYPd/WSRZw/knjmjHv0sN3EoFEb?=
 =?us-ascii?Q?uLB/dsIntLsIVj+gMFqCKl++m2yS7g7n/cyHLR0v8m81LBoYhWhQeDwqvmVN?=
 =?us-ascii?Q?zR7cNEAnbME1KoE97YOrIjz07NJqPVt6er7C7Oh5GM9GTxLHjhxNzvL4TJ/H?=
 =?us-ascii?Q?geRmKek2gJdzpBfGJ1muyzIs6b72JjcUXWMMlY8/JMcTGvc0/t1t0XaNS2De?=
 =?us-ascii?Q?lmWsLnC7MftP9Pk2ln8+p5q7JUcUOD11ay8JvoYZmkao7mSPfhQkUPNNqLlS?=
 =?us-ascii?Q?eEtBUjjDHfurhcrWIpzWKQTMKmznam6NXH6c9vKR+Pf0VAeUGt9TcKLTWSaf?=
 =?us-ascii?Q?+9RLYSdGaST/+eFNFh+MSho/NqaaVqa0aIPN1dEA8iu7Bolmw9jnvBTnz9dF?=
 =?us-ascii?Q?7JOEHEnvTpgwtsKRDDuiRS7WKOHeucPZl08Wxi5x8u5nGVPCahJg//lASpLo?=
 =?us-ascii?Q?mYoZUModPQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf0dbc63-e8c4-4ffe-10ea-08da1cbe03c3
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 19:52:46.0700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T2892xS/01ItGJwvb9v4L1UruTv17MsC9Q4hJqCQcMHhLCxIHYuNGgr6I1DTRcYm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5602
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022 at 12:25:44PM -0600, Alex Williamson wrote:
> On Mon, 11 Apr 2022 10:56:31 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > @@ -1732,10 +1705,28 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
> >  static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
> >  {
> >  	struct pci_dev *pdev = vdev->pdev;
> > +	struct vfio_pci_core_device *cur;
> > +	struct pci_dev *physfn;
> >  	int ret;
> >  
> > -	if (!pdev->is_physfn)
> > +	if (!pdev->is_physfn) {
> > +		/*
> > +		 * If this VF was created by our vfio_pci_core_sriov_configure()
> > +		 * then we can find the PF vfio_pci_core_device now, and due to
> > +		 * the locking in pci_disable_sriov() it cannot change until
> > +		 * this VF device driver is removed.
> > +		 */
> > +		physfn = pci_physfn(vdev->pdev);
> > +		mutex_lock(&vfio_pci_sriov_pfs_mutex);
> > +		list_for_each_entry (cur, &vfio_pci_sriov_pfs, sriov_pfs_item) {
> > +			if (cur->pdev == physfn) {
> > +				vdev->sriov_pf_core_dev = cur;
> > +				break;
> > +			}
> > +		}
> > +		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
> >  		return 0;
> > +	}
> >  
> >  	vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
> >  	if (!vdev->vf_token)
> 
> One more comment on final review; are we equating !is_physfn to
> is_virtfn above?  This branch was originally meant to kick out both VFs
> and non-SRIOV PFs.  Calling pci_physfn() on a !is_virtfn device will
> return itself, so we should never find a list match, but we also don't
> need to look for a match for !is_virtfn, so it's a bit confusing and
> slightly inefficient.  Should the new code be added in a separate
> is_virtfn branch above the existing !is_physfn test?  Thanks,

I started at it for a while and came the same conclusion, I
misunderstood that is_physfn is really trying to be
is_sriov_physfn.. So not a bug, but not really clear code.

I added this, I'll repost it.

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 8bf0f18e668a32..3c6493957abe19 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1709,7 +1709,7 @@ static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
 	struct pci_dev *physfn;
 	int ret;
 
-	if (!pdev->is_physfn) {
+	if (pdev->is_virtfn) {
 		/*
 		 * If this VF was created by our vfio_pci_core_sriov_configure()
 		 * then we can find the PF vfio_pci_core_device now, and due to
@@ -1728,6 +1728,10 @@ static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
 		return 0;
 	}
 
+	/* Not a SRIOV PF */
+	if (!pdev->is_physfn)
+		return 0;
+
 	vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
 	if (!vdev->vf_token)
 		return -ENOMEM;


Thanks,
Jason

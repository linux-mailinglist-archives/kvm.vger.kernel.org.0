Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4501E559CCC
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 17:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbiFXO72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 10:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiFXO7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 10:59:13 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2073.outbound.protection.outlook.com [40.107.96.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C74C8EF83
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 07:54:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7QfAEOMUIwIV9SArlfYSz7ThZ4zi0fBOPnlqxII0x3W95GYJiPRwm+0SHOY4Sr+QjK4ICg1Yp6Tv3aXmXdQShpoH+1TtYnJRiYdMBaj0kuTmKsaOp5UKuQp83FJjQ28gDXOpNImOjknAkAVfspmdGx2oG4IwAX75+7+TfxSs+9boY6ryLuOcr85pzt+qWIzYsqgRo9FlsYYoNjuGAM0+RZ4nAoMO+Y2z+2L4vs9vSOxVj/xLA81vG8Dr6OO93PfShHtwj/Qon1YqiZEJens7asR2QGxlAKkXkZ8x9wf2ExZrqw8ctFEbKpJRYA4xCUSOv2dAI8QxHcWE7vJ2MuRTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WrhF/RWafNPD8p+6aD7b+ENXNC3za65nDuEMnM+COkQ=;
 b=HSDAedplhwmUjTH63DJDn/HRffoN9vMT+KPtmTs1qhZ0BWiS973ZA1JPh1JSUbaXoHi9NXZF0tgVCON+lHuSetqbZW5GcMpb1NwTJ9IVYJDwLxwRkzFGQFZE2C583fm5DW7iXgA9VbjyUgYpzGtOmavLuV12sZ6z5lg9rBijybZRFgnCqyO2cYUrafNs2t+bErVQkk7DhpA6VIpx8ir2M3gHlZt8oILFjpFvG8FjkmJGlc6RVmDXg+j+Y/bWvGOmsjum5JiylxtyvNbdQscstIJCQBa1xaHoDjPAHIMjMQHfm0RdfJArInuKllL1EDqxkg9MPdjxTUnftNsMeLbdpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WrhF/RWafNPD8p+6aD7b+ENXNC3za65nDuEMnM+COkQ=;
 b=pDrRTthsvOQPsRSaLQ5Yz9WZKp5RemOQeXms7zjyDyju1a/L2CVIvAhYePMvIZP3Cts4Zi1UE79IAyrg43SQNFbLsP5asz1xaJd1IpSVLJdgOAPL5v3l3/vapuFK/lVUGkTd4vBtixsX72Bs8QIhqaF8w09Pua+wCFHxbLWG9gKdPw8WmfOrSqRpN4tmDsodIivKzwab/HMxtiI0pc4bA6lXst9dwi/fSqsGSkcTMGQb0IU4/gKpGViOk4UspSe9TvcNeLASpHASFdiqnk1VVuc5LQXa/FIX4Smy7Jbv9QUBW8oDuYjKd2nrqDnn+KjDf1fJOnne+cggCojALQpi4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR1201MB2467.namprd12.prod.outlook.com (2603:10b6:404:a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 14:53:59 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 14:53:59 +0000
Date:   Fri, 24 Jun 2022 11:53:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        liulongfang <liulongfang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Message-ID: <20220624145358.GT4147@nvidia.com>
References: <2c917ec1-6d4f-50a4-a391-8029c3a3228b@nvidia.com>
 <5d54c7dc-0c80-5125-9336-c672e0f29cd1@nvidia.com>
 <20220616170118.497620ba.alex.williamson@redhat.com>
 <6f6b36765fe9408f902d1d644b149df3@huawei.com>
 <20220617084723.00298d67.alex.williamson@redhat.com>
 <4f14e015-e4f7-7632-3cd7-0e644ed05c99@nvidia.com>
 <20220620034909.GC5219@nvidia.com>
 <20220621104146.368b429a.alex.williamson@redhat.com>
 <20220624141237.GQ4147@nvidia.com>
 <20220624084125.6d819a3c.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624084125.6d819a3c.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:207:3c::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61aacc20-4673-4df7-46d0-08da55f15f09
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2467:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YhU6JLH9D0eRRcTa8enyuPV3Y2vFtOE0ErVDuyVTpVskauwfe1HHwDRqogzqJ1M2YvC7RPAKPeFzFdWkTqvO9zMDLgfUUrVG2eCpg+b13LwIS3IkkiN0+0XO0PxJRD1wWtrkQ8hu6lp3eWUj3lvQQin+H6gDXi0dVI6sjkJefiFOZrbJxpoMnQhPteNyCv/EuoDufAehHO6ZCM+E0Utnic36mfZN0jTFE8k+QhUf7Sv+lt8+pBKpbXJb8+ee/f4W2RNPdvovsZm7lT7fh524xVpiOhHmRqRnthq53tjNRDWl1xgnaYIJ+igv1t86WtnJILF99M/ciZWVuvSufNPd9Kj8C/S5Chbjo8w+lvcizXFjR1r4cMx/RAMaizGTCuFaSxNlmZmcKg7tExtIhDbl6Aa4m2nLA3EuXlAeLZ2hAACJbh9VTq7N9juHXZNrbwT/Q442fzq5gaVGVF1cS/eB/WLpx+AUS+tASnFvlbYywUOAyK2rT5bTXbWJTBVwe+dSdfze6h/cE63+GiVXBnCzXxkNX5uRIqm9gwitDP532lYYOd90nZUJkpmOgzzPqxawFd11li5fa+dwAvWIj/PRbgCMSYffp954RFVs9eV/bT0tlHYUDLLGyL4njiYlC2zPYDT3vVk9iywDk7PjzdlcPI1EZU/WNlkHX8AfiiJXCM5oWf07/j6UIbnxcsLdtTRm+Fz6hc6ZvoU7o3TsgToCzuRW6tvVvT3qc37BJUQVNRixLcwqWcjUeaAuSDG3EmwU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(6506007)(86362001)(41300700001)(2616005)(2906002)(33656002)(36756003)(316002)(38100700002)(186003)(6916009)(66946007)(4326008)(1076003)(5660300002)(66556008)(8676002)(6486002)(26005)(478600001)(6512007)(8936002)(54906003)(4744005)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3hKQbU7lRCcZRdWrzQvgCMLfSSVvoOmczRLf5T5M6i7c7p0JOj0SiTPvVm9L?=
 =?us-ascii?Q?IjWOTwZyZj7CTpZF+gOnfa4QL3JpKYH9/CnpEP//jPiSebw+6CHNcbA4M0U+?=
 =?us-ascii?Q?JkWoMMVDMRPZ6ZvDPoazBj2MDKrH6PLSFHd/rVLL68eAIHPnNxUQpF5dDdie?=
 =?us-ascii?Q?g7RnDmzigf47GTfEryx6g3W7pdV1CUpbXgrMLT+puv5sDRxSJdYhXUMrOE93?=
 =?us-ascii?Q?dvNCytzXsfcPZwnbTExJsy4Q+j78GO2VHJntt6g516/iFke1aE6MEgz0IpAN?=
 =?us-ascii?Q?rg/inZd13deYMFYfsoFRLwj68H5F58tljfLYZ+l5/bzg+/ecun5pEILApoZY?=
 =?us-ascii?Q?07oGEbQsNDflWL03M+5qFW6cP3O+iIp14NYDbNZ0ZPCA/r0D1JzJb6y7peyK?=
 =?us-ascii?Q?tuwgRC8kq2Qx/MmS/nXKEoSpJE5hb9X7PToZ7AmWNfyyY0nna9+iJLnCeYKu?=
 =?us-ascii?Q?8uF8rYxQXOITv0nae0D5t7NyZnK+q8T7f1F+aFHQoMuO5EyGrkT5tS8wAdaf?=
 =?us-ascii?Q?RNZKkXXKsIOrxApmZ9Kxh7z+YJvNkMqTp8XmdJIzo+YWNN6cdrtxUxnNo2QP?=
 =?us-ascii?Q?K8ChYbMZk9KZdyzDok/6s1Sh/OwIhvBOlP7ACZSAFlVTWlVBAYZts3R7smtM?=
 =?us-ascii?Q?q0g4tHxrwE8Hk6vbZRX4MvOmOQUEEkv04d2UWC325CkChQOydJi16HjAk6F+?=
 =?us-ascii?Q?rVpq9Zt7W6Q2C1SZtb1mh6vh+oUacQlnYgFRq6ZlachdFXpQmj0p1WeSfa9Z?=
 =?us-ascii?Q?x5RB9cKsPbrvTYhfrZEPGOcejPM9TBYJnmdBUM4ZMivQteECX6tM87S9+wsl?=
 =?us-ascii?Q?+R7r6teF7j3GAgABhur19QnYoNAYCS7xI1bgeJdvCpGVpeg4Mg0aCsfsujci?=
 =?us-ascii?Q?bg71HelhJ3GGrweUDd87ost6SxxW0N6cBtaq5ig/FVmZSPoRXjvfEUg1MCnW?=
 =?us-ascii?Q?MPy3cD9/1DWf9Lqn9Rjnut4rVU4+k1F3w01i1E+U1aL5YDugsETxXCUdtuTn?=
 =?us-ascii?Q?sXuLbeTD5qAJYtEtLTww9p/VTh8CTtdeZiSl62B407qZ7ANeRrEdxov7be+P?=
 =?us-ascii?Q?S2NY4bdzMJztpxQ7GuhGFSrBueF2JSiN22ahcxyrCdHF7lEDkVmqTTuUU0nu?=
 =?us-ascii?Q?ry5KMHzyPIlIQ2E8b/6oMXgGvgmBygzzwHDRGx243mJG4neX8vV5RzzKgV4a?=
 =?us-ascii?Q?hBT3gzFdlIX6pqCB4DNh1Ikbijsyq7JHIHs8Z0q+zQotYat5HXh+P6Wu+1t7?=
 =?us-ascii?Q?hv1JW099WhXBchELUf/VaXBE6IVxqMdXnSzGL02xk9KuLsCvKEK/CT32+W/t?=
 =?us-ascii?Q?yGOLs6nfqZLDwM9mz3JrpiabtqO8iEkGh14yoAQ1ng83bW+3Sm38ulvNCKmj?=
 =?us-ascii?Q?7ifPUeDPtFwsfAH440xaG6eqlb08Hijvu+CW/GyPLFRSFJEIaJ/dsxjy78bX?=
 =?us-ascii?Q?yremSFmp/Wvgk3SYFr3yn4oNqEBBum+3z2sLxtUP2OqvElxZrZAuVAc+cZrK?=
 =?us-ascii?Q?GqKTdjdp4xO3cEMSnxyepXv5dVilbjhkpeprQ/MCbC3bXpO7l9fa1gkptGX6?=
 =?us-ascii?Q?Pdv/EiNB+1OVMh7RJylR69smIEbnW1jPEiOy1WDM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61aacc20-4673-4df7-46d0-08da55f15f09
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 14:53:59.7362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jc56ikPS+AB7bUM7z9VR4eqQ3bj/VfeBZCUM31cHlrOcWorJHw8SufMw2sYhUiYV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2467
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 08:41:25AM -0600, Alex Williamson wrote:

> > RDMA uses a function ib_set_device_ops() but that is only because
> > there is alot of code in that function to do the copying of ops
> > pointers. Splitting avoids the copying so we don't really need a
> > function.
> 
> So maybe we just need a comment in the definition of the
> vfio_migration_ops that vfio_device.mig_ops is a static property of the
> vfio_device which must be set prior to registering the vfio_device.

Sure

Jason

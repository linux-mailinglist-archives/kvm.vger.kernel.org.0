Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE8B419709
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhI0PDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:03:03 -0400
Received: from mail-dm6nam10on2047.outbound.protection.outlook.com ([40.107.93.47]:45994
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234922AbhI0PDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 11:03:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMWhlMUJKCsX3NxPDgjZ/XKEETQgrZdFtB1XESOlUFZbtKRGJ3+s8ROOueFOM+lzfMTWS9v6cTzASFKdLCn8dys1H24GcmNmHcZQvSOshGpqE27WZoUWUUzbMdeKk9Y9emJznYZANd8T30HmsSoaCucfsJ4iYkiAFYweB2mb+j8iJ5PTwB25c93ZPWlKH0OwGHmlHHFvsYzdiNxikANgO7Y6OxjBDIcyO/e29sZuK/+ajbi962JJfpIuUeEAoby3Yn3886FE6awMTEAUMJbmkJIs0M5Syd8dDqlyBo+pfHKO7MirAHuUPBAUIEXN7Ee/iKYKi+MZw4LOr8oMz7ZF/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1aOVUQKK0H7/56/TlRQW2WS+jrmuBZ3dZ8bBey0i47U=;
 b=el/nw0t3uW/ssrAdgrtefScu8j9MLFn73JpDvZcK7OvOfZyNjnEjpnWBGCBFGMWGL/v7LPwmmdiQeByAK+RKMrKMTpeQrLMRcjzeUB1Cy8XMak/2dq6jDRlF4OBUBRKeyyfOGLu4OS00LNjPBi+cW8ZVRyYDTTS7/6ewPR8ZZqaaGj6CBVSN8Qgz2B4dc6SIuO1OC/vfn4EQ0IslqDCMastAssnlpxpd9QHLmadynCLVlSht/+ock8JAlLX4uCNg93kJJIjrw6Sc0laX/rBn8I+/JeOWaTPBSXQrjgvIkqqhEhXqjnGJwkhagAYYaiy/0Ps6Pe8lH4Fu0ypEG+sMyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1aOVUQKK0H7/56/TlRQW2WS+jrmuBZ3dZ8bBey0i47U=;
 b=V9MOSZCAiMv/6tKkqWU93WCwiLdQ1jFfKr2NLBhez/F+XGMb8XZAEs6eXIPSeeng5nTIDzCTG2kAEiguNYjzyTrmQDOESAky9Cbpq10Z4n9w7hZ90cqMQTLzag0i0PxVGcUd+ozEFB8KFvhgrCiHoXXDxVMOqNIwVU7ssQGGWFEjWFyP9ZkkujLZHo47RT96Yt8JRNt1GK7yV3BEnUjSfR5Odeckn0AA5qpA60om/AQO/Qd3NRHl1i6yDkz2/QMjIW1+u104+oma2plJEcsVHUYBP1nl/CAxLsp5Gf2evtpWnGfmVg1m8uF+af2yRD4+Ww3SRC6BDrDbS8DAzUiPJw==
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 15:01:21 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 15:01:20 +0000
Date:   Mon, 27 Sep 2021 12:01:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>
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
Message-ID: <20210927150119.GB964074@nvidia.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-7-shameerali.kolothum.thodi@huawei.com>
 <20210915130742.GJ4065468@nvidia.com>
 <fe5d6659e28244da82b7028b403e11ae@huawei.com>
 <20210916135833.GB327412@nvidia.com>
 <a440256250c14182b9eefc77d5d399b8@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a440256250c14182b9eefc77d5d399b8@huawei.com>
X-ClientProxiedBy: BL0PR02CA0082.namprd02.prod.outlook.com
 (2603:10b6:208:51::23) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR02CA0082.namprd02.prod.outlook.com (2603:10b6:208:51::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 15:01:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mUs87-006Moh-UI; Mon, 27 Sep 2021 12:01:19 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 598f8267-2adc-41e3-77af-08d981c7aa63
X-MS-TrafficTypeDiagnostic: BL1PR12MB5304:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5304C48A342873E63D61BDCAC2A79@BL1PR12MB5304.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pxvBRQiUEkCLSywn6Q6bgwQiKgYXrIKnuGRKGndnm3Jy0i6k269ZMXXHOqkNO1veOQuOl8EtesCn33quIbeSTIxOPrIbKmqp0VeihOSxXuDwXV+F64BP9Jt6kjQ2WO3lHy84KchUTVkoWGnfOQH+dSpIzKGvOTDLLZJK2+lK6+1UpU/kFDKa8YUhpzEu7y5F+4QwuV1ykk7qHI2C1N9Lb30xUEbz/OvffMfZZQ46cFvuSss5np1KUFcW/KmU3p1Z0jlN43IOSxB5mBQqngSK11aN/zfWUYXMFyZiJjHUPPFSjVNEFU41iQOc7ZgvJ/7c33q7aEEXsLPK3SOytXKnhOruZ4uVhBh0EekSlkt1rBwEiXYWG7Tq31TP03WCF9iGWDJBOapXL5LX6yfmiHZ4WPit1t+2K6HJowohCZsvJB3S8fhPWHV7S/f7PY3hM1jW5/gJVgW14NwTTc1qkKVFeVvD3tT7gAPG1/DqwQ/saIdgSGNI93YOde3lTVu6I6BHoHYngJZgmsEzgQu1Je5BwnOl+ShTltwZ8KkWIJksPk0im9pyER3JNNtpeOlAB8TsL3z2cvJONBq87B7GGrrF+n//uILmpKP6qDo60D3rXLxZYvWHxTDE1dce/7cjfWeUpx7AEkYoEqUxwrXCrVwZzCo1OKjWb8x7ezDwdpvVpiOmRaSb7iTnsRIM6Rio0fQT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(9746002)(54906003)(426003)(6636002)(508600001)(4326008)(36756003)(9786002)(66556008)(86362001)(2616005)(66946007)(66476007)(33656002)(2906002)(38100700002)(5660300002)(8936002)(316002)(1076003)(8676002)(83380400001)(110136005)(186003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xACYfh3VLm+Yin/0UxqVjr6CAkf5nWukw+yEQPFdF7b2/RSY2itPJeDBkqsV?=
 =?us-ascii?Q?Cbm0gKp19Ai5dBjWL2mlJK0SM65+JO3SQWZnAKHOuMi5WXsfLjoBP9SQ2wyu?=
 =?us-ascii?Q?LECPsZ0HumGS7bEqVQeVpBoz8ZLVBud1oy/KHFwKf1Qp3uCEhhFgjymd1wQJ?=
 =?us-ascii?Q?MSx054aHyGhQo9VpePDf0zOZiFXwtRTv1nWHX1u28EusosV5BHWMOafxKR8S?=
 =?us-ascii?Q?c+KRfhX7833casUUrBHGDYYsJOzrwJvl12UwZOgJTkoGVLRAuuiJXkOmo1kJ?=
 =?us-ascii?Q?3F/Sek7tkuetoN4I6wYUNbkcjYBZEhH3x5k4Vf9eSIeuYewt+oja+xj5Col/?=
 =?us-ascii?Q?uYDvQPOWbpSlzIN6uV9K3q/oiAxCeg40MkposLJOJtfil1Up9hTws3QnoqdX?=
 =?us-ascii?Q?HCn2PG607QjCHOHUVZRySGUb2lUMsNs0g70MBA4mbk9Bx8sUU32pFVc7SO11?=
 =?us-ascii?Q?nvavv3V8YE+DgL2TMTC1gg8Bq2ehZam7g4+XQG9QhXwfwqcgqsKx1wFaWfmA?=
 =?us-ascii?Q?IDAWXZonOxvjFgpDvbBizUC0PdoBWDbf0JmZ0jSMkElyWYQmHdkGipkErrx/?=
 =?us-ascii?Q?nkxTT6zVw897YvKij9aQIm92w9AZmvFXdfNgAiXj4eEV7nC1tZ5E+cU4VtVH?=
 =?us-ascii?Q?qzHsaNm5B+A1MsuJvl6cOzHC6cPYEtPoFqKoF0xMlMPr3jLSX2fI7WWoSYQJ?=
 =?us-ascii?Q?iXiXZGq5yXnTu8+Ch1v799sUlbb9xIdYR2AV+SXG3Z4Zo48Fz3nRLXFjtCsF?=
 =?us-ascii?Q?UAC69i5/hiV4lXVFdUVs5pwURQpqc5H8vpbqyzhEeDcUmvMs63937dU9QBoo?=
 =?us-ascii?Q?WYqjDc0qksrJ5VpHj+AL2bn1GwtEZ85dDH6VcOJQ8EFbf42qudpZ6U8rZAvo?=
 =?us-ascii?Q?fdVsSIqxmZtrB/gHr0prQx3j+BlsiS015iHi0ltGD8p/dxqtsh2B+rEhXwp8?=
 =?us-ascii?Q?2uLf1ZgLjLdkmwYEQ+m5ID5QvuEoN72WBP4b7Smtk6sRL9SmGJTPM/kdSSYm?=
 =?us-ascii?Q?k4b8imUs4OcNJHs6rl+bYJhpeER/iW2NukMJJEtVtwJc01SRRAwBreyj6DF0?=
 =?us-ascii?Q?k9/2Uj9wSYRjZrBPTcsbNH5wRZ5+LxdRNEFiALbEoOA6ZREhOf96sTsbOFfH?=
 =?us-ascii?Q?+gvmUpyG+SNCdbkGJEPz3KHUOKVlV0Anis3121tnd3qRMrPeexpAASWjU/T5?=
 =?us-ascii?Q?RXjSHIECARt6krN2L87IhAh/otfCEb0F7Nq2/JK7pYav20duL/RDidinm3WZ?=
 =?us-ascii?Q?3XeCjQuiEtcsRLZNWMRfSwA3ME+mJZPoHkrAhDkEiI03Q6ik+/RFsKk02Uon?=
 =?us-ascii?Q?PEccffFhSxqHLE3mH+xzczsJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 598f8267-2adc-41e3-77af-08d981c7aa63
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 15:01:20.8608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZv0ReOAmNKwhdELNsCpPiBk0E3ZYi+al6hrvqvmIxSRX+Y3mGZ5/WiAfRA3UHOu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5304
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 01:46:31PM +0000, Shameerali Kolothum Thodi wrote:

> > > > Nope, this is locked wrong and has no lifetime management.
> > >
> > > Ok. Holding the device_lock() sufficient here?
> > 
> > You can't hold a hisi_qm pointer with some kind of lifecycle
> > management of that pointer. device_lock/etc is necessary to call
> > pci_get_drvdata()
> 
> Since this migration driver only supports VF devices and the PF
> driver will not be removed until all the VF devices gets removed,
> is the locking necessary here?

Oh.. That is really busted up. pci_sriov_disable() is called under the
device_lock(pf) and obtains the device_lock(vf).

This means a VF driver can never use the device_lock(pf), otherwise it
can deadlock itself if PF removal triggers VF removal.

But you can't access these members without using the device_lock(), as
there really are no safety guarentees..

The mlx5 patches have this same sketchy problem.

We may need a new special function 'pci_get_sriov_pf_devdata()' that
confirms the vf/pf relationship and explicitly interlocks with the
pci_sriov_enable/disable instead of using device_lock()

Leon, what do you think?

Jason

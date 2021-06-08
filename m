Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B02E39F82C
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbhFHNz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 09:55:28 -0400
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:25184
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232841AbhFHNz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 09:55:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGLoHSb0QkkPn25S7yLoRWL7lRDQdR/vTiLxEdSA4u+xzYiMHQ7IRUQuIlSCkJf8gQ+HUJeC8Yva/rxjCEhhSze/G6Gdy9EB2/vWC3hZ1NVMohH7KBc04dt1bELAK5UR23+Luv3zTJ2Kkj6TwFXevOa/dO0ocf73HhF5O8upS9LRo8vWQiX7Fcj7Zt36TxlCGZpEp9D7Xmn2Mkn9cQGiHZy2WY4wGFn4XDWLVq4a/Ldm9wDphpdmjBSSat2Zq0+e4EXEP/ycvX+JVhiads5jnrZ+QXll6n63q/jDCbd0QRLLL1wSKXlsogP9OCm2qXWXXsjt3uF59QU9+xIyZe+GaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGcBAU2GjUHaUydc1bPNe/KDMObj7ynwPIkUZBmbLbM=;
 b=gAVIWK/gt7m3ij74y0g58Hux8u5uvkgnupUquO3YmwSTAzd3VQZKfeldah4LsrrsZeuVcQ+AGdl/rKurrWfemHGjO4kJUfwk7c9m8asJa/IrnKKjZLP85YcV0SPSUXJ6+gBQ9MGs3HZLChJEKfmCDFjVklXuRZpN5q9w9BdLXRaBYeFygvNuyNPg2MdDpheBzJLEFio+meVLN8dSesLbtDaRjwgCOvO+DuqijZBViV+hs46k9Yy9JOcICUt38H/trORPT36xjrUCrQ+AbwY91S4MHbMps6I45Iy4hWM+pOs7z2N8oYtHUv3XbXSIEjXyqjOCO40Ck3AcGMSTqhfYgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGcBAU2GjUHaUydc1bPNe/KDMObj7ynwPIkUZBmbLbM=;
 b=sffq3olZHhKsxTOmZ0kl7EVHO7NfwK25DXfTGm0aPQKyUojCjao4P/0E7fxvyl5VLOIRmiwbbglv3M5s4qtubRcfD1HPQbmBxHnLH9TpWytFXzATaMPAVo2V+XMT9Zh1DA8+z+lpiLmxxMlgG82hvg+24g3AF0e8Kw95Sz3x18WCIcCsrNr3Oyiu72d65u8K65Xi061y07yWB5vinMxe2mxXWJyqfqhKoAr5LrTLfgGGNpbJbxQl7BS2W14NrF+jRttEtKiB5SZTVR2wgU0F6TDTn585zPFDLkMnxQZTe+m65Sagb3mh79TvvTANi5Lc94TfF6PO8T24EmgrM3enQA==
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5523.namprd12.prod.outlook.com (2603:10b6:208:1ce::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Tue, 8 Jun
 2021 13:53:33 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 13:53:33 +0000
Date:   Tue, 8 Jun 2021 10:53:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 01/10] driver core: Do not continue searching for drivers
 if deferred probe is used
Message-ID: <20210608135331.GH1002214@nvidia.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <1-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <YL8RxPEMCDTXnPDg@kroah.com>
 <20210608121654.GX1002214@nvidia.com>
 <YL9tAdxK+RMhwPFi@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL9tAdxK+RMhwPFi@kroah.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR07CA0004.namprd07.prod.outlook.com (2603:10b6:208:1a0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 8 Jun 2021 13:53:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqcAd-003s2d-Ss; Tue, 08 Jun 2021 10:53:31 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1e94b18-8448-4b2f-8ac2-08d92a84ce15
X-MS-TrafficTypeDiagnostic: BL0PR12MB5523:
X-Microsoft-Antispam-PRVS: <BL0PR12MB552394A3785B0897A29C7B46C2379@BL0PR12MB5523.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJVlw8OqkMDpNw2zSVA4W4pJAxvaYezxp4ovflzhYzjbGzEWHcMR6pwmYJbGqEUBeGmNKNI5WWc04dHiEWgoFXpGOrbVkQnsMWkEEh+JbJRCacLrfCcH5O9Ikvt42WQiIucS3ljuLbMZApEROEGANG+XSkMDgZR92TKfThCr3r9OHMau8j7SerqtlTGpoU+Kjum+N6pBnqkJt8jr4Wr0my8+H/jFPzYdXFXSXTkkcxdQsXMUVRiaWjSQCQVCXE/GFz2FOgkW+54fC/dPl4/wRGm8Aqh6ba1OX2knFRZN4C43FGVvF2FauEySgeYN3svZ6eXU2jr26rtjlvTz369D4zHDgQLFSqytmjN5kQKgUdBEvWLC3rxwTyxzyWPHTVKFUZUKjTcpyuKOjDMMF/42OZpJ1hzjVeFt0MFoISy4wDNBc2U2wQQ+zQFwZaqVsbH0+dMMuwLyFdZlHkqvCMPRCxZh1iqQYIBSImQbC2fALGixJhsJhUQN2LpwUg9s1zuNVYfBnDNBrHebD2jd+/UtwCAeX2x/sbmwap3ZRw2tcQ+EPaVI9MA6r1toNBEn/2rRH6H16+kg+bhDNTz8I31swkQ6OW/EuqHCPqUo25htTr7SvikfJ6Gn3zNnMHi+XDEbTv6uvuWRufDn3pxKp8kc2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(8676002)(6916009)(498600001)(4326008)(426003)(5660300002)(1076003)(38100700002)(86362001)(66476007)(186003)(36756003)(26005)(33656002)(66946007)(66556008)(9786002)(2906002)(9746002)(2616005)(51383001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EUZO4YyEugAKH4OzeVS3dwfIpsHMxL9ntu3MSeozAYCBcNYm4bBKaVgzX9of?=
 =?us-ascii?Q?HxJDTxsT7U24DKLQRD5ms7cdBVpGxTLlGPGcbULMXssKnz/+Bf+NO2bmJOUQ?=
 =?us-ascii?Q?CK1RHCj1G6wawEVxYwQ2R/fML+HAo+QBcqncupyHAZV1Akcjnkju++1P3eJz?=
 =?us-ascii?Q?9NUWY+iUdACIjZDox3KFH3Fxzp8uWd9oskGdsF3rhJTUO43jlFzC3bwxlgYQ?=
 =?us-ascii?Q?ZEsXX/2VwMXQLVFSXr9kdUft1OuYvQiV5pwEFt6D3sAW2/AVTNZIypfwx+h6?=
 =?us-ascii?Q?+ksUO4QAn48ZHkJPYc1+Uf2caN1oAyDR/gVLv68xSlYhlo/DHXal244ETakC?=
 =?us-ascii?Q?g+w408TzBQCVytb2S1kHSqVGLm4ltQeTkQtPer0QRmQwS3RtRjk04KNu9Y4F?=
 =?us-ascii?Q?VHy8u4DqFoq9OezMW0OfBPVfN8ZSb+snAZBRLhXFt2PR/qKYiodsxR4Yk8oC?=
 =?us-ascii?Q?Iarwsr4JcbojmtL7XX8R1fCg3KYh1KMl9TBD1dY/hpYn4Z4pG/jj0wl1jdHC?=
 =?us-ascii?Q?+nf1q3PvFn9XcGsAGyZP+Gy7KZq4hgObjsm1nYMa8N+CzBmlZ0h9ubwZ51KS?=
 =?us-ascii?Q?twlIRqYKoFLstwTweGp5UKQpziEqEIrv8V29aJYchVchSyqUw88DV3qVfPDq?=
 =?us-ascii?Q?nMQJNvayByCaORbkOPD+oVvXNVjpKwvIfnPaRofDevHY3r31TjHjw+0sFe2/?=
 =?us-ascii?Q?a7H0R+AGSrDzKhH5hZWVTRx0i7ZyFaLKfIXuMTlTP+cIwdggntdDmhs5uUbF?=
 =?us-ascii?Q?D/yki6/IuYmv9dPxh9AvEHpi2keI6fChkOoel9cn15+k/S4QyB5fXLcLkW2m?=
 =?us-ascii?Q?94JwUaLUYq0R9HxzaTbj+c6NpDEe2dkUqxGvo9R6pT09I59gHWuBj2xn1o7f?=
 =?us-ascii?Q?kNQdIVQfZNZG7PjZl49XSzVi5w2qsdll6yVUZwpES/P7QJPp7CprvGQDk09H?=
 =?us-ascii?Q?KxCdZpYQMdGXY7TERayORnRUCGYwGAs1baOYqZln88MiAuKiCCMTs/K/ir2K?=
 =?us-ascii?Q?pPBCmd9U1OuO0tlOyOlBdpAkJIr7eRETE0BrJ5El2D1CweQi6XB+cRbCg9/b?=
 =?us-ascii?Q?FmpKY+gXbc38eJYNR9m1Vg+KOEYBnbKD0bsa9ZEKQV0LWWInpMqcedZPl70E?=
 =?us-ascii?Q?INF375AQe16KTk1EsdSknXYM8d+H0ZCNWuq/+WgL0fatG4fjkenlvVhgZ+ud?=
 =?us-ascii?Q?c9M3z/P7QOeYBeezYdBMdPqKbAvLldj0l0MZeKZgj37BkUj/nm/+B2zexLyT?=
 =?us-ascii?Q?srwgN1m3D7ULlBT0vzXS3U60okjRHcZ64BnY/aXamjfkgurR5GSmxlNoJM27?=
 =?us-ascii?Q?rpVRv5X8YDiSiOYtyNIh/a4s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e94b18-8448-4b2f-8ac2-08d92a84ce15
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 13:53:33.2468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EKM1M9s4/OJSIUmS8Uul1xXOH3KAOKwSruDYxfy3uIAp/5U6BSXyWYy0yTV9xSg2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5523
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 03:13:37PM +0200, Greg Kroah-Hartman wrote:

> > If multiple drivers are matchable what creates determinism in which
> > will bind?
> 
> Magic :)

I suppose you mean something like this code:

        /* Probe the USB device with the driver in hand, but only
         * defer to a generic driver in case the current USB
         * device driver has an id_table or a match function; i.e.,
         * when the device driver was explicitly matched against
         * a device.
         *
         * If the device driver does not have either of these,
         * then we assume that it can bind to any device and is
         * not truly a more specialized/non-generic driver, so a
         * return value of -ENODEV should not force the device
         * to be handled by the generic USB driver, as there
         * can still be another, more specialized, device driver.
         *
         * This accommodates the usbip driver.
         *
         * TODO: What if, in the future, there are multiple
         * specialized USB device drivers for a particular device?
         * In such cases, there is a need to try all matching
         * specialised device drivers prior to setting the
         * use_generic_driver bit.
         */
        error = udriver->probe(udev);
        if (error == -ENODEV && udriver != &usb_generic_driver &&
            (udriver->id_table || udriver->match)) {
                udev->use_generic_driver = 1;
                return -EPROBE_DEFER;
        }

So it does use EPROBE_DEFER to recycle through another attempt at
driver binding. Yikes. Why didn't it return -ENODEV I wonder?

But OK, I can think of no way to find all the cases like this to even
try to do something else at this point, so this has to be
preserved. I'll try to do that, maybe add a comment or two.

Jason

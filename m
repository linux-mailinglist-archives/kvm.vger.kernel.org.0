Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634964CCA45
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 00:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237310AbiCCXun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 18:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbiCCXul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 18:50:41 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455C2166A4D;
        Thu,  3 Mar 2022 15:49:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GF8+yMwcaqaFFYq9drAdS/beo9u9syz9r63S+v2diHLfDXcJCZpylJQwrAHldqg2hXm3HkcVfLHR3WSC5bFVIy93M2tlQerjxUGLJAyCt/OfAY5nqAuLj166PPAuzxZpQZYyBHEimEFleVinpDkaB+PYbL29nypoihtf5nkI0I0iQjMSEdcbqBUwBa7alZ4VCBHLKD/ZcAhp4LOhiIKt/QHckof1ebV7sjMiZgRxbeTpKG2ys8KnKdmn7A3p7inPNjSnx55YS7xCiXYkUY+AXeVIyev70atdoTCQY6Fv9nRHt3iILI9J9D3/spaXMNcPH3LT/H3jpgPzsxPFmBtu5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YqQe1MvJwX2HKZJo8D25feA67gkw2eZaWBbECMkKil4=;
 b=k88dlq5tVY6xR2iLH+yHxlN8OcPwgJcWfy/nbSZcDR5WvNCdbAtdP5C0GoJ1gHD0tpbO465KUzSFSjqP4Oi5BCzGloG4PNgI0Jq+jWRBZ1jcDBgj8Tsg8bocPZCiGkuK6u1ozt+xzEE3haU3NUcsq1Ff7SEHxwqggEjP2GtHMZGtmv4cd6VMMqeTZHBunp5Qh+K2J5nSsjeXGKaBRn5wsqYln4DKkhMbHbmGf8F5V9HkNblei46Zjn1AVcfMEPdfkh/FkJMk0EKTliAUsILQyUDswqEZ3LjMqmPZA3Leu6hTbUbUg+i/j1VbLdcWAOkXMULQvwnk1fBkD+TCLXkg2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqQe1MvJwX2HKZJo8D25feA67gkw2eZaWBbECMkKil4=;
 b=VmvNJugY0jvOdSwznfNzT5qxwAJRVCTCpuYztCLH6doE2kCKeuOIgEWGAzrKtE9fdAoYiMaap0NbinyFyxOTTRXxsbGfV9wh+imUQKKok+Hbj4ddY/hkQeNCNs6F3GYuVJ0zDKd8X3QzfXoLOY0zGZViS2xYD0vw/vA1wRYZuA0x3blh+XnDwBy4DD9A2pWVmDlN8d26BbXycP3rbDigL3a9QUu4AOOG2ObUG0NaVXvYORwTs0dJHbnbk6Fbv/6+1RcKo5vQI16gIs1ZuSJ+uP7zkx6SiVAbMP/5Heh4wqlx8NOriXmcUVYXxlhgllxSYLSEXIHi3QvtP/wOZYXJbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1281.namprd12.prod.outlook.com (2603:10b6:404:1b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13; Thu, 3 Mar
 2022 23:49:52 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.015; Thu, 3 Mar 2022
 23:49:52 +0000
Date:   Thu, 3 Mar 2022 19:49:51 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v7 07/10] vfio: Extend the device migration protocol with
 PRE_COPY
Message-ID: <20220303234951.GB219866@nvidia.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
 <20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com>
 <20220302133159.3c803f56.alex.williamson@redhat.com>
 <20220303000528.GW219866@nvidia.com>
 <20220302204752.71ea8b32.alex.williamson@redhat.com>
 <20220303130124.GX219866@nvidia.com>
 <20220303082040.1f88e24c.alex.williamson@redhat.com>
 <0cee64d555624e669028ba17d04b8737@huawei.com>
 <20220303125930.43d9940b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303125930.43d9940b.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:208:236::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: affe49b5-5f24-42f8-6271-08d9fd7082f4
X-MS-TrafficTypeDiagnostic: BN6PR12MB1281:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1281F38EA42E2273BED5A934C2049@BN6PR12MB1281.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /3w2wpIqqEd1E8M244Vx/DP6HSdV/h8pK3qFz95rIY7rGUNlcYsHmynEMwRviFJgPC0Wk76tvT/Fv2S8XlrqjB4b7YcDisT2bUowj6wdW6svIXCn8weJ10c5mrDUxEy45/PvbaJ1p4SRrG8TTt3xXUs4QPDIv2i0gs/cc/3NGg8g/i+3P1F6FPBrLcAU6ATk6rSt8sDbaOZmy9sWRV+matot9fQTv45IqtzJJzexcRhXvn2kobxpZDCwBSN1UN/mFwkUUHt0/68iTFxJls89CZNfjTKrAwWNBW9yuuxS/XRd8QB1eQlCR8TC/bcZ3Qh4Cz7UPl4QkZ5i5VTKUHW+6Vg5Vz9EeBJo1JDkB0i1gWMObFgoVYw7VYdrKb9+rSHw8ebIi+OyXB7Ud15DRFfzXxnXSQ+1hQQ8HrNFoo8VKS0SDaN9Bi+0TmgaAyisGg/QEAzSHVDAbfLYlojou02E0NWO76Rolk0hPR5RlDNePOGuNUW6Fjdh2J3pMzuJOVh/X1nLWySjSrUMGZu+Wy/fTOepDUknHw3rULm8wMkKBFLB7OtHf1+fGReOA8NY70bai1eS7ZOXEOSQTYq2DN4eXp6tAqJoyFqHjqtgyWKDtUh5SdL9LZ2AEkocPfWFGDZ9LLb5+Xwd8wma5IRYrJ/4lhRWtf+tQZFzbbFjvaj+75uhYq4bet62rDjHSLOTk9u4nebTEoSv8DvTCkJkyBpzMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(6512007)(6486002)(6506007)(508600001)(36756003)(1076003)(26005)(316002)(33656002)(54906003)(6916009)(8936002)(5660300002)(2906002)(8676002)(66556008)(66476007)(38100700002)(66946007)(4326008)(186003)(7416002)(86362001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ht4A5JCzQdMSjxG6tCM/m2wH+Csa5IVXDP1OB9ILkUynybbn0klVoqc8XJMR?=
 =?us-ascii?Q?If035buBDK8go2IdXAsA3eOkXzN7dgt15OAXjYIH/ytzRN0lILtyyYUpQNzc?=
 =?us-ascii?Q?buCNDRXe3feP60AzJwyDmu6v3yKAvjqZ1X1/NYqYl3I+zujYDX0TcowxCqmP?=
 =?us-ascii?Q?hBIKXLVuQ51OaZ8H7k+E/Toi8sz6wNvqejebQUaOlcvt3hyqGgvEsLBnlSTC?=
 =?us-ascii?Q?jYDvO4ZiiGLQLL7vA6rIrP7Q+0eUVblpAiC0Qws5AWXg7fdOJcTB+fLJ2Tdx?=
 =?us-ascii?Q?rZmlGZErnIN3wsnJTVCGlzfVMTZxJKDNNpRIiZO5jPQHUjWN0fSsgYwiDAV9?=
 =?us-ascii?Q?oRCad1nl/v65y+W+neUiDV9965rhwXimOXCiI7XvYsK0+Mu8OLYSGOgkYmQl?=
 =?us-ascii?Q?XPmgKpOHMKEgKitWEVyYEBk9ePqqNPOpidCANQP9yOnqNtW8zgDZRsiNPqjy?=
 =?us-ascii?Q?9rYcX2w0+wUePjWhuf8bbLI2ZX4wOPPhJmB3GrvX1Ev7r3567LfWaw4ZneT9?=
 =?us-ascii?Q?rwNaVbJ/0mTEason8m/6BYwKsfYUB/HayVrskMeYzM03+pRIf+60x7Ez1j26?=
 =?us-ascii?Q?4hmWdvYPb4uOd7JUH+CXJlYBQ0ar9kD8rCiNvTWIBom4/1ohcL9E/w98Oocu?=
 =?us-ascii?Q?BjVn0gzkou+l8eR7CTr1jezyUAG8I/BYfIXS2ZxiuoT3Ava+XZtZJM1q27Jq?=
 =?us-ascii?Q?55XMSKvOSNjpr7OmuqPifTLx430TNls295fkb4yidA36/qiEudEVIzwPOqv/?=
 =?us-ascii?Q?Mw7OoxwYBdaZZIPd/Lhv+y7YanD3XN9nGkMgsWowLl4rrH9mQAXaTyLWU+aC?=
 =?us-ascii?Q?45wX0fToi56d6YPJWXBEDMuoIrsVOcQ7dIJ9iJIz5V5EN/Xcu43iFnh3Nsqa?=
 =?us-ascii?Q?u5vzHHZkVg09xL4BvMhdS7R14R0bnlgjyW27BxZN96exhR+zFHlDyHptl5RK?=
 =?us-ascii?Q?ywttl51GeFz69c6B08SQG01kwz2mZ50v7c9ZTSouyAFgLYeUu2EE42ysBF+2?=
 =?us-ascii?Q?2i0jC9/37aVFn/PpCe0dBCb785ydqMrRVpsqu9ycV8Dbe6p7GCF1EUgbjRCU?=
 =?us-ascii?Q?FuQz1dC7WM++txu3RSzGDf300fdPSX+R16E4mcrTCChkeDNkVBzkYzH7QmiJ?=
 =?us-ascii?Q?cSphWlJAp6EoQ8ORF3T0L9b7eyCYt4R0IHHniWZDMsOuBom2FUH6scyXYexL?=
 =?us-ascii?Q?TH3szuanypcRQ7ZtjIegIplSUOJ9Pv8z5KHvTPRigQTpDlL//RvOzFFKS/eA?=
 =?us-ascii?Q?Wqy4M1te6KmVCKmvNWi3g/N8aC5ciyromRNx56v0cFBz1JphEBHEDhwasuC1?=
 =?us-ascii?Q?KCllUeehefgq5yWIdmlhsD0IbQgRswXIALHwBQKkDusyocgvs6ulzPczLA5P?=
 =?us-ascii?Q?BbStvVeOCdRp2emoDdTU2zpPOSuLUKwSwWXm4l+rC2r8jQ1Kokaj0CvPyKIe?=
 =?us-ascii?Q?rdJzlWMWbuWH32iV+Ea7K3cEb0TRZwfz4WTOvhDMQ1dWxZ99KxN7myTshqUS?=
 =?us-ascii?Q?SutJMM7o6NOhYfjNaCXaa/Z2bO/8qQlkAMUPNdyhiH8VDRRSFB9hpGTL5cCK?=
 =?us-ascii?Q?/wgwmQ0obQhrQhJwBh8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: affe49b5-5f24-42f8-6271-08d9fd7082f4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 23:49:52.6416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1uJvXzCCamPMzY1eWWpLnU6QUseGuUCUiWFYLAfh9Bs4SrRYeO3dq3At4HSt4/QS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1281
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022 at 12:59:30PM -0700, Alex Williamson wrote:

> > > If it's an abuse, then let's not do it.  It was never my
> > > impression or intention

So maybe abuse is the wrong word, but I don't want to mess up this
interface, which is intended to support real pre-copy devices, just
because devices that don't actually implement true precopy might do
silly things.

The vGPU case you imagine will still work and qemu will switch to
STOP_COPY with a huge trailer and be slow. That is unavoidable and I
think it is fine.

> > > Furthermore the acc driver was explicitly directed not to indicate any degree
> > > of trailing data size in dirty_bytes, so while trailing data may be small for acc,
> > > this interface is explicitly not intended to provide any indication of trailing
> > > data size.  Thanks, 

Yes, trailing data is not what this is for. This is only to help
decide when to switch from PRE_COPY to STOP_COPY. If the device can
execute STOP_COPY in the right time is a completely different
discussion/interface.

> > Just to clarify, so the suggestion here is not to use PRE_COPY for compatibility
> > check at all and have a different proper infrastructure for that later as Jason
> > suggested?
> > 
> > If so, I will remove this patch from this series and go back to the old revision
> > where we only have STOP_COPY and do the compatibility check during the final
> > load data operation.
> 
> Hi Shameer,
> 
> I think NVIDIA has a company long weekend, so I'm not sure how quickly
> we'll hear a rebuttal from Jason, but at this point I'd rather not
> move

Yes, company long weekend.

> forward with using PRE_COPY exclusively for compatibility testing if
> that is seen as an abuse of the interface, regardless of the size of
> the remaining STOP_COPY data.  It might be most expedient to respin
> without PRE_COPY and we'll revisit methods to perform early
> compatibility testing in the future.  Thanks,

Shameerali has talked about wanting this compat check early from the
start, and done all the work to implement it. I think it is pretty
extreme to blow up his series over trailing_data.

To me acc is fine to use it this way until we get a better solution
for compatability. We all need this, but I expect it to be complicated
to define.

Jason

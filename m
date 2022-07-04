Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECB0565341
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 13:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbiGDLZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 07:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbiGDLZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 07:25:14 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3D4101F8;
        Mon,  4 Jul 2022 04:25:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cfi6ILfm4xV+r0rj9T2RTLzJmBeZdPRM7C71WkufJzTwXpyT1tDzJRHUkrpJs50mP1liFsVNHdpv2fvA/mstnpr2+kfReG9PfY4OxeSbfcfv7XZdFbKdC6k+awfWoTMHPIAeNB770JGRILtJboDrFxOkjDpS1aN+RxsAIXiB/s+TYmFelXxObX39VotGIHEaF9w7fLY+NHb8w76Fwyll3VX2CGpbcyhQ4frqU98rSn1NVtI+Wp0SSgHJ+Y6v5kclzhFQ+UqduRrgy2/mhkIeVVQuQfAyeg3TFcDw+rxYUJSFSkkoJLrfAx0hR8iK1vtQY/sWOCQVomoWZCE3yrc4SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3cyYipmzIgffZaMuO3KCre+mbX2ya9GhsyUmg+Fhe7w=;
 b=CoMmHqLoUpPwuWxNpASkUM2wZCPGPmD2C+BGVILO0HY5kqf6wV6IQLPXFFZfH4mkpi1RjAc/y77MxGk2wH+OOSwQDvg4SFzQv+t6m79E2OY7Mm4pFLPlZgx7WfoQ9ZBCsow4wOZpsa5uVK2ZIXWMCV9oAoOSj8I7CgEnPsau2PKM4FRPcxuBLSapHEp43AwN7Fr9peKAVynmjizdznSNHT300dn9IXKi20d366LcSWiWD2AsOorZsVSQmDnWviRRPnBBw3tl2e4pHsV9frMAFcUBMveckOGmbajPwBMsoZd9QqKJZG+LqNCUDC/ST/NxThmZ35UjH/ldtB31ZpNloQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cyYipmzIgffZaMuO3KCre+mbX2ya9GhsyUmg+Fhe7w=;
 b=t53FuFnn3IGjdp3xJ6rVbzGTRtFZcL2CsXNSHWlpHkdPG4ucAHDWuVxtSA6OubxPUK3+D9jvLONcQvtY/5Wbi/GXW5cU58WXNC3lM8ylhI+N1RiMPD3e17Bc6BSswgKDWT1KALfbwdlp0TCxVm1pCNj+GLTV1U4bC99kUf7ftQixGIKByg2gnK/k412dBIFhWGHDOH8/XaTEGoS3hiPoe5raRT0PIMkLvLhfbTWSh8RB8q3dPk2MUZ4nV23l7ogcrV+XBabQ5cRFCPBNmsZMMSwRKftRGn7J+V1nIv0Kp5ARe/h2+OXCTZdECCeOAGxZFITan7VUqwZm5meyD8Z2hw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (52.135.49.15) by
 MN2PR12MB3741.namprd12.prod.outlook.com (10.255.236.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.14; Mon, 4 Jul 2022 11:25:12 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 11:25:12 +0000
Date:   Mon, 4 Jul 2022 08:25:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 00/11] s390/vfio-ccw rework
Message-ID: <20220704112511.GO693670@nvidia.com>
References: <20220630203647.2529815-1-farman@linux.ibm.com>
 <20220630234411.GM693670@nvidia.com>
 <e8f1748eb1bae3e90521b0d5d4471266f4ea7c98.camel@linux.ibm.com>
 <f21307d9-6490-c39d-cff0-2a50c5f1cb35@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f21307d9-6490-c39d-cff0-2a50c5f1cb35@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0213.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::8) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1906524-2d90-4802-48d5-08da5dafdc41
X-MS-TrafficTypeDiagnostic: MN2PR12MB3741:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YcW1ow4aBVm9IisaSfF/yQzqXa7xOUZoVJCUcZSyiz/vZmjUjOVXbeVV+szdQPX4nwaaUNhEF434DRAyEZlccsUOtHdYJPVNIvQSwxgU7PcaS5UnBVdBU6TtZLTZKCrYy8cqcPfTwrTmT+nnvUvCoNylRORZOqMq0JMLaj/Y/WOTlCqpY0Klnr6KAES2odaI5ndRRlSzergPC9hgAWv0Oai84X3h55BatOrajxYv2qPOqhsQ2lxWzBrBIsWOK1w1kgid3EiGlHpgOu87dhFPumTO+BdeesmWyvkb74z3LeFyBUdRP7fZ2hqx8q1tdB6K9EUE5amGhirDE3PBW4ZiPXJgXoeqjRKcIe34Ls+sL+LMUQ50U/ZaBpehKCshILz6L7U6H7VM96jw/klWMCC+wbfnkRDI5ktDSPvYXsmrXqTmKuR4eLxb1040EaerZdJcff1zGWD7OwAZH0Jnqjd7MmwRjiPm3hpgm8y0eBuKIniqbRBH4wZXj3j3WpawZFrrwozsDdRMI7pS0pP1MC98cvYYBBZ5FnfUPLA8i/Olmph7d/ivJUzLSi6aaZ2+00QNk4GifbyUJwAgTASG8r09fvlZ0KI5/05jNidI3+RYtwRDVpt0Tl732FD8VlwESAlIzMlnBAVH3D5NH9gapHS4y1yQEfCOAhIThJD7jZeeOD0Nv8IPpavVV1FaUqhyLMK6WfLjJi590LDR+q+W/RNBQHgdnvrOeOH5L3k2I05gPvX2XsDMm1WVD7cPfsCn2I8gm8BIf9eUZxDNCj3ZCXDxDVI8G4qCBBeX9OfWYZimlKwJyxerx2vHfZYkEZz8Xqyh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(8936002)(316002)(8676002)(66556008)(66946007)(1076003)(6916009)(4326008)(54906003)(41300700001)(83380400001)(66476007)(2616005)(38100700002)(26005)(6512007)(6506007)(86362001)(5660300002)(33656002)(2906002)(478600001)(36756003)(6486002)(186003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MB5uctct78Jn1I20NyVwO32+Rv7+8ARet3hjCRTxWIL+xAQNUKKzZF2g1Hpx?=
 =?us-ascii?Q?TuU5nm7cbvFP0gi9Ry9WVfWDGjaoWPiV+wPSjHQrHbcv/j2Zodt7Yca1IDYT?=
 =?us-ascii?Q?qLgPHYVCpt05JzRY+I40W/bmrU9yrGJE0X+8HT4qH3Pa6P41t/Y3QlvwSP+r?=
 =?us-ascii?Q?TnU4Exg2K78tocG1ApXDg3HMu90sPGi9QP4MQjnN2vtwNVzrV2D91Ta83HGs?=
 =?us-ascii?Q?I+wX+xuyhdTemkKN8h/Izn7FOEadg4k1kO0yUwjSSFr+nRrvwotCcJ4Cg92z?=
 =?us-ascii?Q?2tcAM6Anik/XrQWaM6pdzIaWCiWbsz1HsG5kDWmCjYt3lQDDSbfQq5baXq8X?=
 =?us-ascii?Q?5Evt3kvu53IWB8FUi2OAFJs6bw7zIJ8C3gzNDHFA15h+xY7KaOE+nOZuIvgR?=
 =?us-ascii?Q?KVahCfHB+92e4Q8pOn95VLWbpaCQQs2n+UWTv2PhDUKzi7nb72ljvCxXqBfn?=
 =?us-ascii?Q?StgIOEpPPoNpx7NasqmTUK/Jy8iH09i0i9D0c2tVlFwhFSRs8pD58VY0FHM8?=
 =?us-ascii?Q?ploN3WrKw6ov50WHLm5Zh0YNmJDMHx7NUmFZWwO/ER90B3dSbtvpXEvvWMNL?=
 =?us-ascii?Q?B+QL1Lyc2X3vuU3Q4dpXbqabqbj9Z6bgQhTobgYUy201YOuRdg/V8NZsfHRF?=
 =?us-ascii?Q?Mow3Sz6IVS8qOI77u6bX9D/CpmXivs7o2U/ydkwQ7iQKg0RtjszaTFwRB6Ep?=
 =?us-ascii?Q?aBipjOSLt2USPf0rRhkawTwM+iplEEzR8xrW8dTA1NuFBAgaSkfFG8bIqjnu?=
 =?us-ascii?Q?T9a07VxqOB2hC03s9hcHWqJ3hPHe5Isx2Q8gI/TxCBuUAJSYxYsE+eqigo5X?=
 =?us-ascii?Q?YLD1zCHa2la9Jzr7vL7orHJgBUVx7WUhh4YmUmuQEi2qZy+++G42dW6JUlir?=
 =?us-ascii?Q?wRNzmRmmR1xDQOHOYCTMBcLDqa7EO/iAji6jSq4+aogbulHldlsnP23lZa8w?=
 =?us-ascii?Q?pwJ1hXCcuoCcCuLQPQDtohRoXfFBJJ8yecwK+RaT0PsXCn4+LHB6aomPC567?=
 =?us-ascii?Q?QmFqUzXI2v0/nE2PEMgoX1QvjuGv9kwmDjK+dgFWE+zdiDU6kBK7TMXP+9P1?=
 =?us-ascii?Q?91A45oFZa1HgG00ZO1NrB63m0jd3hqzrz0ENvcdHTyZEFg7BECMt7IdMQqqj?=
 =?us-ascii?Q?1Z5sV9yjLIavD9a7CleMqCciMlf+cHm0or9b5epw3MKGBA4+59kMfts2FA2a?=
 =?us-ascii?Q?Ga39EVHSZZ9WTDICYrFyWNdpE+R/hSizq1dTaxQh6lAg0p5cx2MtMiSml2ry?=
 =?us-ascii?Q?81BsHt3ZraYCMHBgZ3+MAWsmjARojG78b1BooSBYgk6SKN7W5aIxDgNV7i68?=
 =?us-ascii?Q?0Z83hF70OQgIPPaTGKH6qVy399F489z43n4fdoD6EiCEarsx7DfStRM6nPER?=
 =?us-ascii?Q?y2q8/iznqxHosLen4v9v0JCjNZG6mJFXnxLXA1eWx4QNL2Oxt4qrHL43s54Z?=
 =?us-ascii?Q?qJuCnINBI01F3pBTSRs/T46/F9q1osRlMC1Rf6k/ybFDUOYN4eZtkuTxvphD?=
 =?us-ascii?Q?mH1KXMIWcc5iGA/+nyJMG8+LiAyt8RSjwK9CdruBP1ffdOZI0JfiKdKF1H4y?=
 =?us-ascii?Q?5RC777HeIdpPV0HGQ7kCeWhNqD6aeSszg+o1Z/Bn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1906524-2d90-4802-48d5-08da5dafdc41
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 11:25:12.3834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l8nS65ATqi7CJTA8/PKjO/bbBCBTmAkPjDZ/3Grd/0SUr0udMYyxp6nhnehSDKLN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3741
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 01, 2022 at 02:48:25PM +0200, Christian Borntraeger wrote:

> Am 01.07.22 um 14:40 schrieb Eric Farman:
> > On Thu, 2022-06-30 at 20:44 -0300, Jason Gunthorpe wrote:
> > > On Thu, Jun 30, 2022 at 10:36:36PM +0200, Eric Farman wrote:
> > > > Here's an updated pass through the first chunk of vfio-ccw rework.
> > > > 
> > > > As with v2, this is all internal to vfio-ccw, with the exception of
> > > > the removal of mdev_uuid from include/linux/mdev.h in patch 1.
> > > > 
> > > > There is one conflict with the vfio-next branch [2], on patch 6.
> > > 
> > > What tree do you plan to take it through?
> > 
> > Don't know. I know Matt's PCI series has a conflict with this same
> > patch also, but I haven't seen resolution to that. @Christian,
> > thoughts?
> 
> 
> What about me making a topic branch that it being merged by Alex AND the KVM tree
> so that each of the conflicts can be solved in that way?

It make sense, I would base it on Alex's VFIO tree just to avoid
some conflicts in the first place. Matt can rebase on this, so lets
get things going?

Jason

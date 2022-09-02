Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261035AA45E
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 02:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbiIBA2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 20:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiIBA2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 20:28:50 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA8696748
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 17:28:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amX7K00zEMA9qVRToE3KB/eboMlBibUa8dhE7dun+GGF7xMG9B/Hn6BQTSdNgxUw2n/JqtMj7ZPTQznIzhS327A3DhPiVHAVKqsdES97TCjFDXTAAxWnVoz0mqCu+Z4ldhvQeKnGih3tQaM6qBRuaeCNDhfTurYW7lD/A5OPLdwBhKdW5keYYJcJHtOrgSnhHr7Qxc4JhGKGOeDGQM4DHgGetS/bhIH2eWdGvUFX6N5+D/2yO3SPLyBmuy5puPiD8Vad/rVqkh/fSbahvGPS3j5HOV2/zBR3TN+swdPS81GrRup/xnre4I1Hbk/p8NTJTjBJX4/9PVoGV9/T75OnOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avNVBW0a9jsQApDYpVxVdlgWsGf7M6Si+1F4aARrOO4=;
 b=c9pylfqxoHpRgzpT8ssdVccO+7Y8p6btTBSl3zqHhWQXXUBVHUhX6cUl//+FMsziCMuXsc9Lo+KeT9YjJv1+2pGoOYN4+0Tk3P2R9ASyW5BoGFZFXv0j9dny5gHWVfaB1JXswxufsgAT6HBVZ7Vg3+yukO6FuxilTRpdmQX4i8xcXOSbdv2lBEBmd/3RNOkzXjf7dBzTaqOzy7veAEVOGRa5CXSbuPdUD/pxu+mKE404j89U7exwP8aLwfo/pknXEz5LxEXnqaGZiC8l95yRQx0OzemSM72BCl35HKYQwpC7r0aDGWFl5zeA2Dhv19CV/MjFj+xqtjrhSZS+SocAdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avNVBW0a9jsQApDYpVxVdlgWsGf7M6Si+1F4aARrOO4=;
 b=U+yQPj4y34q4LDYDvThHeBFU84JIGxrhMB3qWICKrdwTT3zlpbEarabDlAcWZZYPW73Ga2Z6dnSpkJncOmsiLR++WAQfR+gyE/AceFvnC8oJM881nfC58R3hZTWMuv9hHrXj64biKC4yTJoZNDWtv6GbHbWTirp782HViYEnqheTOGmRjqvrQneq0Jxdv1EWKyRgCuaU747uIOG9ZZhr1Zc9nGlRGH+16wbAaptXWjXBk4M6FvwA3c8JNXhdxT5/GkQYj1dAyEnoW8DF0HS7lP4d7e23uFW6btzeq8VMFNhKQReaZV5BB+JO8Nr6kv22wjfgVIdUjGNI1AdpLvlnNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5171.namprd12.prod.outlook.com (2603:10b6:610:ba::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 00:28:48 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.012; Fri, 2 Sep 2022
 00:28:45 +0000
Date:   Thu, 1 Sep 2022 21:28:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/8] vfio: Rename __vfio_group_unset_container()
Message-ID: <YxFOPUaab8DZH9v8@nvidia.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <2-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <BN9PR11MB52767A4CCD5C7B0E70F0BA2C8C789@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52767A4CCD5C7B0E70F0BA2C8C789@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR06CA0010.namprd06.prod.outlook.com
 (2603:10b6:208:23d::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94a5cceb-3123-4a55-8d2b-08da8c7a18c9
X-MS-TrafficTypeDiagnostic: CH0PR12MB5171:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ulPsmZzHj9Mc1J1mD9XOfh4Y6eldIywAOgsjq1V3qVvUQ7gx/GvplSlO+1joEX7zU3xrc/bWi/jiExo9U1V7Ntnm+QeA8TGNZfCKgdUCzm1/h7tJa/PW9ZT8mYqi1b1S8NxRs5e2eRl974NHHTDFdR4VAeE7LA35C3Wdcnf0Z6HjMHcvFwSRvHcfqZ3fJ12xiCpmkJL1KVy/QU81ivj0Gz/JkdwYMWkXIFzeUIeU5GaJwy4QlZrY70Z9RXytWB0b7V6j27PglSwY3SWxbG/5j8mz9CFZdp8d5RfhANxVUHaXubXN8ptK6K5tvb0yv2/omJ1QeAr6Vjo0U50ZmtlAjdrM2pHLpImsbsEHy6E8CzWSk97AeYjm+7hit3+7YKAY46nV5IKdspHPoXzCGXmsqIHcN0guBawocT5rLLQhO2ZODAqnViFvZNfX1i6cNpu5gYMBSTAwZ3zMkBa29Se9QadPFHunPJlxx6DFrv8I0un44oQwMDFsacUuypgEZf/EtbIIwABGNTiuyzxNtRZDE9TEg0PaP9wNkSsznR7L8i33bjXGRYs95IBdhPZozI6ZpiuhdPFtXP82lmqE50OabWkQYu8L8m6Pr5sWqGupLCp3pb9bovoCIynruiDl3db1qlVmib9YHxk7C5LsSCQOW+yIKXALelBPbyKGOWxOsOGVG1ExhYjuCPxtcYLWGnlJxpKEljVeY8uwCoG0Q6Zxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(6506007)(316002)(186003)(83380400001)(8936002)(6916009)(54906003)(2616005)(6486002)(36756003)(6512007)(26005)(2906002)(5660300002)(41300700001)(66476007)(86362001)(66946007)(8676002)(4326008)(66556008)(478600001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d+uhBQhV/rEaf0Q22bHmkRAOyG6qYufM+Rzz777GyTJXZ1YIv7EdyDik+NFQ?=
 =?us-ascii?Q?fauOFSzZwQg9hye/W4yTEV9xH0TrBJJDUHIRxUzlo1T4nFFyT6m9vhjcWP9B?=
 =?us-ascii?Q?XszR8ANjDMoQSdEi2PCX4Msp8t/C401HTb8u2DrhlqvmaUov30hS/qbzPPdL?=
 =?us-ascii?Q?saDNPcK01/jU1peHl3Og+WHy7m4c4YV2grA4aaQabZvUgU9o1ztdV/x7U29X?=
 =?us-ascii?Q?yILlQj/ZxgdG+nE646dCs++a6jseji7WrhRlN/E36mxhFwUxlO89sazebEdV?=
 =?us-ascii?Q?hEiCxEObw6WqweHKKztN4+TaK5g7801rTrrYwwG+464Opy+SKABMnTTRgcUU?=
 =?us-ascii?Q?ehT6gSN/LwoyKP2RtOO+yt33ovHetRwBK4l39a1+LEqrboxw3Jdic80hGV6v?=
 =?us-ascii?Q?eNCIv+InvH3CM6jxaI4X0CFlHzllZFfIBoh3YHpOadtOIKXeyk2IoM/5Nw1r?=
 =?us-ascii?Q?w18eOrClsUp5bhmF/puOzCiUNSY3lRwm37dbcnPAQXXYEg5zHPd8b+t3Q0qt?=
 =?us-ascii?Q?N7OGAiN10JDjP50sV1pA5neXM+XdfCefKbSoxaqVa9fYIpPercDuZkyOGizq?=
 =?us-ascii?Q?GKtIgFfgs/8ChQPFVqfapTP3pKap1iXmVII1dQmj6gT57urhO/t3eMr27g60?=
 =?us-ascii?Q?i2AAmMTx9tv7cvQ+73r0Xwk5Kjs2MdDXXRPDt3r0qlF9X1o1C1UkETQjn+zJ?=
 =?us-ascii?Q?gOcPMtNNUsj0bGBSQjxUh1Mv5BMKWAhUfsj3WT3LWBqoAi/FTeHH4zufil7Q?=
 =?us-ascii?Q?WPjvBW0cGsrUrAadNYzWJbIeeO6oEIkkKT8C+EXsdnlQXd4bGszJUuljkYBY?=
 =?us-ascii?Q?c7deF7iXkVmNlHmoKqpJ1xPjLmL0h+h1ChTQUMhVXCfd7sJXi9Qo0QW9cCD9?=
 =?us-ascii?Q?WFGdK/l2f+dGhC8TvAlBK9y7hjvivppTtw6aALzo7k9vfkJHjZ5jijbGOIoG?=
 =?us-ascii?Q?4D/d0QaraiHlcVjByB/NygIRmpYvt/MCphyDMC1mnj4BqToKtMgdO6DIW5NK?=
 =?us-ascii?Q?PGa33CK6ZbkL7XTRfW3heEaG8A/5kdxHiOSW0JVCUNCu0nAhxYQb3oa71T1r?=
 =?us-ascii?Q?oKN4rvT+Id+BYBQ+54zjGzQvZLNXAewJaTYearnR/VNReU527z6jWW1qWpW+?=
 =?us-ascii?Q?qTdc+6wXNDAu53fhGfyrWyb3KrOrT0VX89+ClkI9LAYWjcANDf1LoSNespVu?=
 =?us-ascii?Q?SMi7qCZT/aWz9ea0A6uacOZTv07SIq+2P1beuNbru9QqHwsCFC+vlFssIrDD?=
 =?us-ascii?Q?lEbYfTr6fOdykvkIUuUYSJfEBae+d08xHKyXxOO3z6lsVTDQRj1NoSIcwvCF?=
 =?us-ascii?Q?Xjtwd69+vz8IIuBOsQlywk/xM6gjFI/QPjylAdOYT4fYTJ92s/gxsdyurKaX?=
 =?us-ascii?Q?fMuxLj6RNMJYQvdZWcIZQd9nTvtxzCFe4skFUmOruAvN2xErqJDiyw2wBozn?=
 =?us-ascii?Q?YHOtUjboQ2bXUTRvL/syCEk99IuoMf490+pd2fFFMoPfuPAbQ2hQCXpog6L2?=
 =?us-ascii?Q?7AyaBJPCDlf6nQDXQS67a+OAhi/qLhmIXjmT0J6PkFciyKVecmMObs4PxXYj?=
 =?us-ascii?Q?dEF7318YT5zELDrySEroJvcUQrRXwJRX1AYrYqbL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94a5cceb-3123-4a55-8d2b-08da8c7a18c9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 00:28:45.8149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XJFRPHGzynq/LB58f+nYweE//7xtv4DyYk0rBfwg/JhvrRwUgIS7nkhkePzKgUpG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5171
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022 at 08:46:30AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, August 31, 2022 9:02 AM
> > 
> > To vfio_container_detatch_group(). This function is really a container
> > function.
> > 
> > Fold the WARN_ON() into it as a precondition assertion.
> > 
> > A following patch will move the vfio_container functions to their own .c
> > file.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/vfio/vfio_main.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index bfa6119ba47337..e145c87f208f3a 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -928,12 +928,13 @@ static const struct file_operations vfio_fops = {
> >  /*
> >   * VFIO Group fd, /dev/vfio/$GROUP
> >   */
> > -static void __vfio_group_unset_container(struct vfio_group *group)
> > +static void vfio_container_detatch_group(struct vfio_group *group)
> 
> s/detatch/detach/

Oops

> Given it's a vfio_container function is it better to have a container pointer
> as the first parameter, i.e.:
> 
> static void vfio_container_detatch_group(struct vfio_container *container,
> 		struct vfio_group *group)

Ah, I'm not so sure, it seems weird to make the caller do
group->container then pass the group in as well.

This call assumes the container is the container of the group, it
doesn't work in situations where that isn't true.

It is kind of weird layering in a way, arguably we should have the
current group stored in the container if we want things to work that
way, but that is a big change and not that wortwhile I think.

Patch 7 is pretty much the same, it doesn't work right unless the
container and device are already matched

Thanks,
Jason

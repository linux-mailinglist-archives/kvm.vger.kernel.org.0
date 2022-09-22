Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47265E64DE
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 16:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiIVONv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 10:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiIVONp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 10:13:45 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCD258B6F
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 07:13:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zs2qU3N+UDNKif7rdUzG6WlDm5+FFFqvlE849AVAphPinE1h9tUthpv9sU4nk1zGZNXnfRmKtLB5PSlZ5scXznWbYaDOp3C6/YHCztv1yYCdVJ6QzPiO3n7vUWF2CjO9GKTat1MGFtXKyj3I42A70733DetiCY63S/t09VZWmNLyLLHgQukbUY2LK6d24rQepFRcrqEFv5kJphHS8d6HO0vYntwDyaRckf8HovoVzfiCv1E2af5HMEXj2dr9eKsdH6VO/33Jt4Ry632dUMWv49ZbcBV2SdvNVbfBD0QPDGqjoE34ZimQrdZ8Qu8BwSujO4jSi0KR6a2K60W4nNTQcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KcQMT4Kegn54MXexabP5203bM+2GU6bdwLOJp/4XOS4=;
 b=DXp7uZx/hqwDGYlHPmJQBkdSNXv8QLqL8y78YIWMxeWkZE4dzBbOVYufyquPprMaU1xMsi5FQOULRDNWt6YOCYdyAusfFbMXBIt86GXVkrzB8RrYhMPZgryBrPnSf/F9QblRRloWjkj0Yck5c9myacLVWToikQ4ekNVRQ8YsSMrW03IS5P4ezwVHWOOwNQ2L77FA9Fbfe6YeXRlXuP+bJytA7Ix60GkVi/f/uGFuYcnTK1wC/dRIJxR9/YwxGuWWqFkBZuOatSopch7gDRV6Rc2q9undrUwAqnHztJ3e80yWElS8d3eOjbgAfCAu/wJT30LR3xGExn8QllPRoGP8uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcQMT4Kegn54MXexabP5203bM+2GU6bdwLOJp/4XOS4=;
 b=qvCZCQlV0Tp1HQYx+KANwqKwCm1RKNwoE3pqiSrhERGEMKMwG91f4sqRqi6/7DzUpTTqkyo59qNmqWUoGbL6LZQw/+MMnd41RA/cyrKedllf/ZZpoXUwMDyUKgJSIRjP4Gafm+gVsGF0oVoztPQ3LzPekR/wdgqDIqvp8TYvmG8xkz4D7qq9GDsBzXGQYAFOpo8VDpIoW4r6uiJqxdgKcLPCPk2bz+lu2/5ws8W7Gcytg4NWZTeLxz4JJn65jBuZPzm0/fnXQvOBQjak6qsvDFuSuoTBz+1RW2LcPWsKGS68DtqCFSDv3hmW60Jfekl2+G8QBr786vWjEnM9pHj3Xg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN9PR12MB5163.namprd12.prod.outlook.com (2603:10b6:408:11c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 14:13:43 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 14:13:43 +0000
Date:   Thu, 22 Sep 2022 11:13:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <YyxtljfKFYQh9Y+H@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YyxBuQwIUdiqGoR3@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YyxBuQwIUdiqGoR3@redhat.com>
X-ClientProxiedBy: MN2PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:208:236::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|BN9PR12MB5163:EE_
X-MS-Office365-Filtering-Correlation-Id: 26583ddf-f84a-42f2-4083-08da9ca4a7ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nXuc6d0lpYl4VV8oObV622/ebapeEp4U5gkymdF/2CfNkuxLPqugSl9x2shUg9nRexxXQjRyfkGJqvspKZd9g+9TL829cVQiHTB2l9F2QJNCpedY0covnAIoukZzQFhT+chGTgDXaXL9sOktc0ImfW+vK6NQbtzPBBTMGsUZCBjz5kY6Gw2OJOsa0+rDREkvG9J8rNcAXvEzjsRwFE5Tn+0b9RAVpz/M5bckNvjJ9jw6xs9z2p/twIhLc3ZjOY1vBkScx/cY7PZcqH/h2qd3MbpzHH8d1zeSlHgQJf24wgrv8Zj3grgbIdEi5uJc8Dx8crj8awdXfl3d+aLKQInfVIFUCy80rcjh1RrmYvZS7tgrmjJ0ShfaGbYOgbRaBQ30qK4Enq4hYjj97v7HvEx7qDEsMUaHCUbPCoU6oTBhS3sJ8DaEtve0Iq5lWM2pkvT0f6LUOW528fc4gq5opN2bEExwzTb/R1lKmqcEiG06JaaWVZDOp1i/QKKw8Ea4+b6ZoZMaOvDHQ6zLqtOKw/Uu0uhSXT/3VCY8i9jDITuFFyjYCcltXR1Bm/SG74cWIorGwwMtV7zyG4BD7gMIOYOSgcPsedQbguw4RDTspOedcezEDxiFEIAUxyoOu8YDQYc/RJJIv2xD+S9b5JahOFKefVFLyIvrVKLgyQHiElhLporA73m3U+xDSg+gkWf1gVF81tFgiRgpMpLFJU+XUwOFnDwMd7HzW3neZHHoYhu1LMOMBuV9wXoo4m+Koa12Vk/sN6xYwgL6VC9v91eRCN9FVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199015)(8936002)(41300700001)(38100700002)(66946007)(8676002)(4326008)(66556008)(66476007)(86362001)(36756003)(4744005)(7416002)(5660300002)(2906002)(6486002)(2616005)(6512007)(6506007)(26005)(186003)(478600001)(316002)(83380400001)(6916009)(54906003)(41533002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjBXWmc3dUtBMFBOY2M1ZW14dW1SMCsxay84U1A1T01tMEx5RU5PbGh1NzJZ?=
 =?utf-8?B?RU1QTnpjd3VVNGVmQ09iZ0ZTaUs3dTd2eHA0QnIxSDcxck5zTlFkNHFOd2Fy?=
 =?utf-8?B?akJIbTd0eERMMG9KVmljemNyWkV2WW9ya2IzSHNLRGRxQmhqUmRGUzg1V1Y5?=
 =?utf-8?B?NjdSVTNXVDVVTmFGTHBia2Y2clpEb2dTOWlSdUtkYUF0MkMzOTZrQ2dQY2Iw?=
 =?utf-8?B?akRaanBJOWJrK25MRUxldjJjTytDQ1B0a0RHTVgrVDB5cGVXelFOZUNlNkpn?=
 =?utf-8?B?TzNZRjVwbFNaWWF1eVBSTUxLOUI3ZXdFbjNJdDljOTVFcGVkdG1UczFydm1h?=
 =?utf-8?B?OEh0OTN1dmx0ekFvYjJ6dlhnWVlDektINGdLZW1PRW9xN2M2Tm53Z1czUGcy?=
 =?utf-8?B?K0xtcHFJUnNyOFRYazBJWVc4TDFqb2FBV2YreUhnSHNKZUxwUTVrSWRVdnk1?=
 =?utf-8?B?Q0xoTXQwQUFZYlUxMXJUMGJabktDWnhVRmVlU3dnb2xhQUQ5REh3ZG5JZUJ2?=
 =?utf-8?B?L0hZUHlNTENjOWRsTEc2cDBWZ3Z1R1BsWWdDbzNQcjhkd0NlVDJhamZ1YVhB?=
 =?utf-8?B?dkJ6TlRkd3lpZnlJcTg5MkpDR21ieE84RHVGVkQwbkRyeVBaOVBMMHdoTnBj?=
 =?utf-8?B?UVZITXBwWldEVGsyUEhvRnNpVjFaeHZ1aWc3eWowS1hFVkxNOHZhak4xVnNX?=
 =?utf-8?B?MFllMjJweTMrMXg2UG5TbVg2UFRIUmI0U3I4QzBDV29nTng4OVA5Y1hacVRo?=
 =?utf-8?B?Ylh6YlZYTldXejl5djFGb0ZBNXd5QStiY0VVVkxZaWp3VERRVkFqSzBlZU5F?=
 =?utf-8?B?NS9Yb2JVelNhUngyL2RZQU0yVHpDMkRzdUNPVmgybGZ2Q1QzcnlUYVNJZmlq?=
 =?utf-8?B?eFplekhpNXpaejJvU0FJb1h5NFFoRWNvYjNXL28vUE52V2dlMGV4WXNON3V5?=
 =?utf-8?B?MUxMV05sMFBqQjJtTmNXdHhxSGh3Zlpsb1Rzajd4V1U3amxFOTN0SUROY3JU?=
 =?utf-8?B?Y2RybWdySzA5SWFQMktZeEZlL2VhenpvSHczNTRaU2xxYkhWZ29hSXBmTXJN?=
 =?utf-8?B?bUk5NnROZS9uL0MwQUI4dDYxV0hUdzdHL2o0UUFEL0VxM0xkNVRWUWRwYzRD?=
 =?utf-8?B?bFJEZnJTWElxeUlkVDM1ZEl0emVwd0R0NnJ1YkZPbFpSQnNMNXMzdDQ5Rk1l?=
 =?utf-8?B?dWFoMm1xS216NFByZWg1MzdwODRTWm9WU2krNzd6TnlqdlZlTE8yTlVtU0V0?=
 =?utf-8?B?N0EzYTFWWEs3WFExVFFybDM4QnRVUmN1b0p1dVkxaFU2MWZEQklOTEN2V1kw?=
 =?utf-8?B?MWdNQ2xPTEVVQkMzTHRydG82VlFjMi9qT092SGI1OGZZVkV3L1J3ZnJOTG9E?=
 =?utf-8?B?OFJFUFF6LytROFFEeCswc2dPQy91ekkvd01zL2tNTFpRYUUyamRxSzM2SDJ6?=
 =?utf-8?B?TGhXMGxpNGpORlZMcEtGZmE4V0t0ZkROT05SeUp4RUF1cmE0eEtHVEUrV0Vy?=
 =?utf-8?B?TEM4Tzk1M0R6M0E5cWZvQ1FyZjk5R09VcTNOTXpCTlM4QVZmM1B4a3BBaytX?=
 =?utf-8?B?YXlTTnNwVGh1ZFdybnZIVnRrYzRsTFF3Ym9xYWtKK04vWTg2cXp2QUp1eEZY?=
 =?utf-8?B?UjRWUGlxelJrL3BobEptQ1ltWlI1aFh5U3p6dmRKbkdkcW85S0lUckRYdDYr?=
 =?utf-8?B?VVI5UEROM1ljMjlpWTJJZUI5R2VJVlYrRDZ3MHkxSTBEOXBHUWxtdGtzK0Mx?=
 =?utf-8?B?Y0NHb2xjRWVkaXQxbkRqNFZiQWFsbmtWL1hJY2NCOGpaS243Vnhpb0RrR2pk?=
 =?utf-8?B?ME93WC9uZkMrNEk2UWFiVjNqYTkxejBvbmVkbzByQmdDMjJHMUNMQ3ZEUXBF?=
 =?utf-8?B?cmVtQlp0RWdlekNHYVczamhMZ0Z5eFoyamJDRmlFU3ZYMjZXaHZrY3Y1dHRu?=
 =?utf-8?B?dTlHOHgzQ1ZneWxRNkt4bWtaYTBPYmVNaVNIZ3dlUG5vaGNlQWVoY3FJRElQ?=
 =?utf-8?B?MC9BaWNpMFVGL09LT0VwZVlhelc4cXJUbVphRzhqa25sQ2ZPdUZTY0QxOVV5?=
 =?utf-8?B?dk52TzJJazYrN1VSa2VTSTQwaktkaitGNFYzVDRITDREd2FhOHlQcmhUVTV1?=
 =?utf-8?Q?CSY9XuZoBDTlD7WrPAi1iESkS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26583ddf-f84a-42f2-4083-08da9ca4a7ff
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 14:13:43.5470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2p9A0C5rHeMvd3ZCni5eHjH9XXszVIAT0PYgGA7r1cBD0qZV5Zd6qH1Bmo5NA1kC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5163
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 12:06:33PM +0100, Daniel P. Berrangé wrote:

> So per-user locked mem accounting looks like a regression in
> our VM isolation abilities compared to the per-task accounting.

For this kind of API the management app needs to put each VM in its
own user, which I'm a bit surprised it doesn't already do as a further
protection against cross-process concerns.

The question here is how to we provide enough compatability for this
existing methodology while still closing the security holes and
inconsistencies that exist in the kernel implementation.

Jason

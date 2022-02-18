Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F2E4BBD9E
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 17:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbiBRQhl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 11:37:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiBRQhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 11:37:40 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21899D556B;
        Fri, 18 Feb 2022 08:37:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNEtKfhexwJ/b35CiYUQry/qfqahAgkOacbY6wsiXOnSvM8MpzGRB++5xuNjKQ5D+n29XgLfgxh2wprUr7tJ6Xcah/KPqbceD+TyHjDF4Buv5dZbZixjp6xyeiQ9B/PJszs8Brdy6w9qCHQ/6Fden67eUxGkCikKKsDvqXvIwmhFHJnxe63w/hEWqdn8nW8L1grZlGY0NRz4bdFplZXKmBGM/AMvA8+RW150StfboK/Azqe+myASMC9nObJ92p45UFiPClrHJYNikhUqpq6iVxMfu5gHpIF7tDtqXqXE06ZOMiOK1lblySznwp5qApyxhEuz5+REbc/xknPE3qmLJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RrS0mn2ZLJHXqfQPDVh2F89GTBw0GCtnk7rmujxBX9o=;
 b=XhOdUeb/mXdWhvQoZxRN2SgcyPpYHRTboTkBlbMR2woe7Ak8mVtI9DUt62ipNAdv0BnSuSnHm8/5t02eG1vvpIvqwd9zGI3YPPaKVTaGp3JX7+U1anL/j7b6KioxL12mKzVUIYok+tj4d08ZwnPKrtLuJluOE5O9SJYxXA4Vzb3brLFoExSt/ZvFzAynw5wi93aAENWgxEjUumy9y3ngIuP+q+4ycRIYheNH/lfStl+vUfPjS/5t6AsELgr3SdSN4TxwI1uwNMeEoSm4yeRQvf0zRzmXiks4QEAz7zoqRk3KPgwOuTRsNO+MSeTVRV9XaIvN0rfPUIwGrGi8zUgqeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RrS0mn2ZLJHXqfQPDVh2F89GTBw0GCtnk7rmujxBX9o=;
 b=LR7MZvyBXttw+faAWEAagkouhhHuLjOZdWJCRIV9HQSNzFGjEPc128mCNwtMxH1Ax061xeSgByKdcoOlDaPaqICIx8MvGbKTEzv2PtIcMXL7God0DEnJMMfgChadzEHJ+SY/RKGiOKWRS7eOyuvHkMpXmm0KP0vArU+IMMh5N/ZJbULdB7DEcdVViitmhLhfkAPu5aqINrkEPOk/wjikyXFGQMFsZmYvYCOCDqhY0X7mY6IqwVMy8vRNlXIpSH7WwZ0vdlh4eU97a4OB5y38X+wQ4HN+mawsN5fTAequZINndq+tqgy5wx7WWNi9gMRwSSVBgczT4hAcfQlvtu9VsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR1201MB0204.namprd12.prod.outlook.com (2603:10b6:4:51::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Fri, 18 Feb
 2022 16:37:21 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%5]) with mapi id 15.20.4995.024; Fri, 18 Feb 2022
 16:37:21 +0000
Date:   Fri, 18 Feb 2022 12:37:20 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, alex.williamson@redhat.com,
        mgurtovoy@nvidia.com, linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, yuzenghui@huawei.com,
        jonathan.cameron@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220218163720.GA1592391@nvidia.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: MN2PR18CA0002.namprd18.prod.outlook.com
 (2603:10b6:208:23c::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c758f555-1904-425e-646b-08d9f2fcef6b
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0204:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB02043F74E85DFEA9982BB39AC2379@DM5PR1201MB0204.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rt/Xm27C1s8cnsCU1QLrJbkgP4i3VlSBq7Bviru6QK5oypjvhVIX2jE1V2Q7U9VGMdJtWCbgkZ4wxKFKrwN3tYLhHc2liJnYtEREzqTX2eosthWAhDTp0W3DqinejoxilNioRtD7v/oH4597RfyjLtRiJyHEAYvGK8e+le0d13qAEwI7zk7AXb4N9mMfbRMFrjgaz+rkT5GTHU/8dA8vVvV+a76UVkTD3hX9b0/yzm76dx6u0/qSTbhj1aQO/Vie0FPmN27ORkC8V/ypNIqTudXA8ec7aP9KLp7nRVHUlYKFOW0dsgRd2FtO1G2Y1qm1zEti57eVnuH4VFOpFZPJWl7DkaH90VMucw4LqS9PUyv6jam3fZl0GKba514BCTvZETmQ4I8Jd9vE9GF6Z6HB2G7yg8OCD5GRy35FdioX845aAtuTuNNUg1/4JuVnSNqIAUrtR/0E873N6dDTAwBJtIx5IcOcPJrXgxLoVS4StKXjbDZM1ELFsAsg9Xr03+QO9EuFQYgykjcOhPenHI81NdzHSIZK69h+jyuPgFqObbbThtrj8gY9mDpvIazD7gZ2N0CR7XMSbxekZMXSGMD4QerlaN7KF6qo/zSH5IUh86Rs/y5sAQtGkJgkTW0IwIUjEXvNOOFoj40ZCshJAugphw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(8936002)(26005)(4744005)(38100700002)(4326008)(2906002)(83380400001)(2616005)(66556008)(7416002)(5660300002)(36756003)(1076003)(6916009)(33656002)(316002)(6506007)(86362001)(6486002)(66476007)(186003)(6512007)(66946007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sJLGXTzKY9EYoMjnjRDCY079hvxb7k2lwul5rLePHRamhakRsetG50RXTEU3?=
 =?us-ascii?Q?R6PzQt+HSBQdpILMV3Sx3l5DgXL+zeZLFmiDmx6+QpreoarFPtvqXT8sN15C?=
 =?us-ascii?Q?Stiue/cWXaNIFroqdzWYXh5R/okZSsC7qANkMarGDE9R1uptriqgONvWPbdv?=
 =?us-ascii?Q?m35Vzs6adDceNMSB5OixIUofYABeih3HoSZbgAf0PHZSaT26El7Ijtg/0WIB?=
 =?us-ascii?Q?0tgXVEcKnQtKpAuKb10AdfRserqsTL8PlasD+lPIj2ULE55pjNuCJjRghLHp?=
 =?us-ascii?Q?d+5P2wQUl+gqATw9IxKJwV6zvkf0fkcxLS/xRjsRU+DjGeVjgZUXJDHmVSjD?=
 =?us-ascii?Q?xrmkzRhdJKlbh40Zp+5QPNw461Rc0kEZK2uaWikH4I45GpglToUvAEG1SCS7?=
 =?us-ascii?Q?ni8L/KYwMVAVOqQkEX3Gg0Mur7u0ucdudskDaJQsf+iHiZtKs8lC4QCRlESH?=
 =?us-ascii?Q?p1riU0g2jyXksbDGhD6qsPrWs8wc/1oF+2yubWN/GYaoJ8RQlaKOWelhOXFl?=
 =?us-ascii?Q?wwHkcQN7O24iTri1vdz5csjZ08zS8Cl3nagNk9Zl7kfy7Co09u5T8tvtmdo8?=
 =?us-ascii?Q?V7Ed6kT89q6OGrJ4QT6LD2HZO5LyvElrPKCGHSDs7EY0UBL21Oe48DFxeDVs?=
 =?us-ascii?Q?5M03k8y6qA+FxKdf5afUrLSRbk/D/WeFZ/j8wfX685aJzwR+ln04puj7cwRV?=
 =?us-ascii?Q?BoEF1BdhsQ53k1n2GVj8OE7aKz09yvZfzf1WPnfx+6OjkZpQy2iGeWUWl4Bo?=
 =?us-ascii?Q?TuufZqbMCSP0FBklq/boSNrVUKeKsjtOFBr489+PW3e/D5zvrRnNUYt/N2zi?=
 =?us-ascii?Q?Wq0j9Ej7d1H97vMpYZ2F5tcO2jzCIohY7Dfhnr9DpxdgYX4jBBc3J/FxwJsb?=
 =?us-ascii?Q?TimDlRacKtPKBAprI6pggV7X5CfeEbrZyEVds8wZV/r96/r6Ujr+R1uYAskW?=
 =?us-ascii?Q?9+Ot5p41BMgvEKwDESEbca+DYufLXk/Zpn+cxGa2ecRsmSrVSLP8mPsdYK9m?=
 =?us-ascii?Q?w7V30LMDMSmd4Gsoq9UfmBIALVZs2dxJ0A32iinVZeTXslbmXJ8dPcY94O6n?=
 =?us-ascii?Q?mbqi6drIGgYdeMFB1hK7ZCcO3AeLjONJWNho4HBQ4bcsITsN3gTz09QaIOl6?=
 =?us-ascii?Q?P5A5kRvl4matIPm0C3zYjtA8B0SxShKfWc8VCybpgdNmh3xTNFAoXkf167gQ?=
 =?us-ascii?Q?KBHA9u2Fc7U8+3e03XJVWP+AgJ4qsiDe6CtDdOeYfWibmxM4ZRAd5lfu7D37?=
 =?us-ascii?Q?qpacLlAuFc+onnpXITX/x5m9deegMncPGkX4vM+yi08RTDGcdtKbQkT14Dvd?=
 =?us-ascii?Q?qnXpTzbExX8nqrmhvxw1oECgnxQ/5KeLpAg1ewqWQl/FH+gsGi8Xy1rnJfrE?=
 =?us-ascii?Q?GuoTqiLvj7RXrIZ8sf2HEKHMJpIUIpOsN6vReHizYNYrHDfx46EtAcFIZ15F?=
 =?us-ascii?Q?9VyCFCGr5Rp7GPKVFTqIkNH+suqMaWbYcZyOIZtTfu/VDIQ2PXRMVihl4k15?=
 =?us-ascii?Q?YLv1hGL99/lOxEMj3CMdeo/rtaDi0g9TM8eFkBfWuWO0SgMwfCwFhVx+SA3c?=
 =?us-ascii?Q?eKFtw8EF+LFkuKu19HQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c758f555-1904-425e-646b-08d9f2fcef6b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 16:37:21.4295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tgs4WSOV7y4WHbMMXeCXMToHHK7x/mnsJFHHpkLKjS7OPFUsljjQeIvMqtc4LUH7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0204
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021 at 10:58:45AM +0100, Shameer Kolothum wrote:
> Hi,
> 
> This series attempts to add vfio live migration support for
> HiSilicon ACC VF devices. HiSilicon ACC VF device MMIO space
> includes both the functional register space and migration 
> control register space. As discussed in RFCv1[0], this may create
> security issues as these regions get shared between the Guest
> driver and the migration driver. Based on the feedback, we tried
> to address those concerns in this version. 
> 
> This is now based on the new vfio-pci-core framework proposal[1].
> Understand that the framework proposal is still under discussion,
> but really appreciate any feedback on the approach taken here
> to mitigate the security risks.

Do you want to try to get this into this kernel along with the mlx5
driver? How RFCy is this?

If you can post a v2 with the changes discussed soon I think there is
a good chance of this.

Thanks,
Jason

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B75584FFA
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 14:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiG2MJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 08:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiG2MJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 08:09:22 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2064.outbound.protection.outlook.com [40.107.102.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C6F87F7D;
        Fri, 29 Jul 2022 05:09:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVyvEWzxFiJKJbcZWX4McRd+FMnHJoNGuFu8n01UBB+44lnQb7HG9RYmOLhnE4NGbeGuvkzgkA+fU98DBmFuE762IHM8CkP4n0m5O1cJXXFBo//FSUSnGk+id99dsPNVqY0FTCDh2V+ZQzjjLHPqZLQy3QFxwIsCTICowQ6DHutkKrDEPTLDpB5yEkU8cjE4xC65JPVThH73At7ZMdQUsKdoR2vQmVBwxVOWT8JZxKpThfmtJEuI8BMrRxdmmlFuRGO0qLZR1LNhwCMFyTMQPfS1bOWHpHPhWoo1EUm4OWkT7bFv2//OpsnPrXXC/sSMIpSKy0eKw1bCdKXf4UZ1yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BUQS6kt+NpSUvndVbH5R64F4tA4bJrGRXBz6xHy1xsk=;
 b=ZVhBpFHLHwb9xm4bMjYle2m0o5ZRCCQ72ZiNiRqoUR9h8WvpjOpdOz8DEAeCUuh9ZvBYdhMl9XOl767HU5YUFuqESWS9Pf4qZL/AVlxoyITMav9yidss50USYUH7ES0+NrjIL9UsMHZXj3qLTuyC069q8qIHnzVdUpeRzaEVuCrGuC6yeSfO3mbmdRUPtwapiTnrC7l4hSZhbbbJ7sZV/Xzd+ivB2Dmge8v+q0EUlq5/1n0hBiLNk+NJTMt1ciGuK7xAnabHWUNa/Tx7RApL3iTodEJGJSv8zEUxoDzp7yhS1tXd9Sopr8Pg1LwNL7Tx1X9ppy5KcWdBCXFxQ9nGxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUQS6kt+NpSUvndVbH5R64F4tA4bJrGRXBz6xHy1xsk=;
 b=VBmugkWQ+78i59nYY9rsIyKegnonaOGll3gEeMU1MQfW+k4XVY4fvolkwkV3zVhr0ZZwkTd58SkFtwNX3w+HukNKYqZqbuyY8l6r9dRQAgg8uUqNJ6S9rHKgfmM0cFr5hCTL+qI+Txsapau6Vt+nxqOmOWslTzqy64qitZkl9QouUzVEFUhdDebfvbUlniyMhx+gGxBNa+ohT+e/km0EsW7NwbKVPxt46KAADLl+fDg3uno5Rx8D24+iNcC0moYMwnDTvZkw1pbWLj272OTR29wdAxWkOSv7LpiRfLALjCsGgcTreDhhmUUXDPj8SEc+MrMxL2rbbjOJwXSt6s7A1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1377.namprd12.prod.outlook.com (2603:10b6:404:1c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Fri, 29 Jul
 2022 12:09:19 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58%8]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 12:09:13 +0000
Date:   Fri, 29 Jul 2022 09:09:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Oliver O'Halloran <oohall@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rodel, Jorg" <jroedel@suse.de>, Joel Stanley <joel@jms.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH kernel] powerpc/iommu: Add iommu_ops to report
 capabilities and allow blocking domains
Message-ID: <YuPN5dJUPezitwn2@nvidia.com>
References: <20220707135552.3688927-1-aik@ozlabs.ru>
 <20220707151002.GB1705032@nvidia.com>
 <bb8f4c93-6cbc-0106-d4c1-1f3c0751fbba@ozlabs.ru>
 <bbe29694-66a3-275b-5a79-71237ad7388f@ozlabs.ru>
 <BN9PR11MB527690152FE449D26576D2FE8C829@BN9PR11MB5276.namprd11.prod.outlook.com>
 <300aa0fe-31c5-4ed2-d0a2-597c2c305f91@ozlabs.ru>
 <CAOSf1CHxkSxGXopT=9i3N9xUmj0=13J1V_M=or23ZamucXyu7w@mail.gmail.com>
 <BN9PR11MB527626B389A0F7A4AB19B6728C999@BN9PR11MB5276.namprd11.prod.outlook.com>
 <78db23aa-ff77-478e-efaa-058fe08765d9@ozlabs.ru>
 <BN9PR11MB52766CDF5C0A96DF0575AADE8C999@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52766CDF5C0A96DF0575AADE8C999@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:208:d4::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b59f4e29-5c95-4003-16bc-08da715b270d
X-MS-TrafficTypeDiagnostic: BN6PR12MB1377:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LPpD4EY5b7Y9M1yQgzsREbiwH00yNDutFUHnqgzT7MyapUwMPY0jtKw3RicMHeer0zTKqwsQ5fah/Ua4cz/AJu++Kethx1+Jfg5Stz03ZxVLTopVNurSkxmAjs/LMs7qhWYtQp0xPm4I3RGeVj6WDeHR333sVKjjikcCgeuXUQcFMQMRa6io/P3fKmMfRS1DLneXpG7vYI/7OOq7RuT4hS4Q2Vnos6Y31ifAvX/CWm/MlVNZ56JjSsqv+6zvYRlIcKKR0ErquBkork7bUdLx+lsN6aIGXBKALnDz7IqryDwHLjF3Hy6YYLrplVpHqIj8rX+OQEw/TGs3UWg00nCkSPJC41XmWiLZXi1qrI1EeYqabCe7lianDLAbXepBg+A+8Dsz3YWk4gDzuydTLFcXEWF5qan9W/K9c4BlmXBQW7m96vS0kL074IwdSY8NENpm4N0ioxsMOZUemGcXh5740JFCDnfPyldISd3O4TLT+3gl1m+OO5yX0H2iBnRIy2iQxn9/ZpnaTCazq4oARmsMKZs5kaztXbOv9Sf1hWhJBZW98pWzwp8dCcVef279a3B5cL/xKIQlZtAoOHTCGj7m1hhQQP+5WHZvZFtFPKPIFZ/ulQJC6aVMkFvGyso7XB48fiDFtb67P7Rgk/8k+ztgYgO7dIdqBPMxvL6lHTpWkIJvt5cYVkB0i96fqXju1zVOa1CsWIfsg2QWEJ+nctFsXL1elgCIN8ylORW0/wX9UrHEqoJ3p4/79IEPxi88Gc8e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(41300700001)(2906002)(6666004)(186003)(26005)(6506007)(6512007)(2616005)(38100700002)(86362001)(316002)(66946007)(7416002)(36756003)(4744005)(54906003)(478600001)(6486002)(66476007)(66556008)(6862004)(5660300002)(8936002)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2ihlL+VjFLgR59FY24Ak35O5dt0L9TW69Qft419cjmDB58GktZM/jwDACF5g?=
 =?us-ascii?Q?0oVP+qm0hyVGkwIasY0Cq2qVdeRWjzP3aDVnxl2Qst2NJFElXIOmooNgJwRX?=
 =?us-ascii?Q?bEzGP/im77QMDwr39YQL2KnMBdgVjZ8ye/YPZiPSb5pXMxCikOX0GVKo46uE?=
 =?us-ascii?Q?Tc7pIZZ6ktjTkhrYHoFrZadRE7GhbD9NGs2pLZlPYNzHqzeCGhc3w2V81yjI?=
 =?us-ascii?Q?KaiDcIgUxs1IYXUA+SNk+xr6oG/eadYKhQnMEHRSAmNacsxeeAxIzZX+pPnj?=
 =?us-ascii?Q?dqeWygk5e9u/b/z75ttmXGYQZD3c24DKsaMo7VuFpkNYXYWFbMPEbMc1Q7zC?=
 =?us-ascii?Q?+PNLOzVkD0hsGWQ4aLsWfi8mqTbcbip7mbJZIR0iUIUj4owFUuq8EuYn6iVQ?=
 =?us-ascii?Q?4KD46CPmgfi6rQ3gxs7lH9QgcYyyq9iU+nOIPY+ShRNaRhyCMxShzfAb3VRf?=
 =?us-ascii?Q?mCL6aZQDppyUe65aO1JcDG8TcEpXoCVRM0+7D57nd2F15+/MwFuwAq1A3VyY?=
 =?us-ascii?Q?g98qAc8EM5PAWJdaaNrQi3aExAzEvm1vHU22y1ESlPcwCXlyd1BN80iACXGm?=
 =?us-ascii?Q?h9PW2aGiZNHHOXD5X2s91KUEFF1SAIHctF7r6LScz0O5n0+a0GLdtXl4QrGX?=
 =?us-ascii?Q?7RKP+TnfTbVtm+9SvYWWuIu9UsYtIq+HpDAqb4v5Ee1eHrXRUBPkVI87cjOJ?=
 =?us-ascii?Q?MYmA+dcRuZrRaFtzlsB8xPApSai7Cny52pzZBy4Owb0YTkS4d+DQk50MVNxb?=
 =?us-ascii?Q?qZo5HkY4CqsdgDos4hhz9KUXJi2ueGGXSTf0Iw/2IWJ9nKlpgThuJtGoxvwx?=
 =?us-ascii?Q?dRjfEU/oUdzsAnZqNHJNRcEhcKCCUl+IZdw1aNma5aGKzHnG0A5jzq+BbxSs?=
 =?us-ascii?Q?2lg2KgOAQFAHnX/3UWU/Or/jwPlaVwZHbFsd9pmODgTyCDAccplHBgSM4gop?=
 =?us-ascii?Q?C+ojqJWXXCgr7uISoEOG+QDJuOER0t21u+dsJ4WCLxf4YGwyBO7E48tyfete?=
 =?us-ascii?Q?nUka1V2aQU5cC98k1iuZwpf56IYoR+s4RmW+UjTaEzFfaC4Wl9qbJzWPoZnz?=
 =?us-ascii?Q?qBDnt52UPQxz1fK6oBLKEpZJdfY99UjLlnpVakjfyy4Sk0zmB84c1jetuMzV?=
 =?us-ascii?Q?CPkrfxqsbyItiKj+vgHz69gK+vnlBnyPuYydCSRrVlfXTf2n25Uw5PGxKKv0?=
 =?us-ascii?Q?/RT7j8zMIHGUeP6p1QnBalQCbnkt/t2SNyfXew44u+sRNbvDHz66f5cAya8v?=
 =?us-ascii?Q?+wS75ydpCyOQOcXRIw0ICP2k79Qkd783d7D5NqU58YxC+tbYp2U2dTmDW/vm?=
 =?us-ascii?Q?YHPTwgpWOveHGy9EBs84jL0XCuj5PwZV2uaYwF+gKL0YFrjUeWRJqIe9PBYx?=
 =?us-ascii?Q?g14w/T39ET/pacWgFPVzBnRCo0DqThfAcUhLeZD5rmNb16pFsXdpaIV8Avgn?=
 =?us-ascii?Q?2WiG+2QxsqL/Zswfi9NJNRLIDlxE6MmhR0jgeoNwFfFAQ6PvvhFmwIacaX0N?=
 =?us-ascii?Q?Yt7YfIOFOIxhKkBbSmbgKAPum5QvTLp2EAAmmM/jcZ4DATarJaZ6djMVrdnK?=
 =?us-ascii?Q?fkiAR120idhugXdBdiY/uz3XxDnDVoYR+boW2QQD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b59f4e29-5c95-4003-16bc-08da715b270d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 12:09:13.9196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PF+Svv/L6lqoYOTdNQk+GZZfYElaTmAf/kxCrD5EYJaHbIOyw9Wkcx2xuOhjn1Ya
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1377
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 29, 2022 at 04:24:36AM +0000, Tian, Kevin wrote:
> > It is a POWER specific thing with one not-so-obvious consequence of each
> > window having an independent page size (fixed at the moment or creation)
> > and (most likely) different page size, like, 4K vs. 2M.
> 
> page size is anyway decided by the iommu driver. Same for other vendors.
> the caller (e.g. vfio) just tries to map as many contiguous pages as
> possible but in the end it's iommu driver to decide the actual size.

An iommu_domain with a non-uniform page_size is weird, but it could be
made to work as some device-specific thing. The only thing the core
codes care about is the minimum alignment, so you'd just have to set
it to 4k and mapping the wrong thing to the 2M area would fail.

domains with their io page size != PAGE_SIZE are already very special
things that require special handling by userspace..

Jason

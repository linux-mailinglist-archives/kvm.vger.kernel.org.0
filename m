Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF274B0E0C
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 14:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241909AbiBJNBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 08:01:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241915AbiBJNBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 08:01:53 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7B01015;
        Thu, 10 Feb 2022 05:01:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qe2eu70uC1GsRC2CQYmrf+667yVrfYJ+npdzUoOGIwouvLsQ8fKVdDWLw2xXbsMogYVTNgbgDEYLJqp1zbRABkpmIYHcvutvE22LkG1QXq12QLg6yLrSWa8YMDR5s4o3d7PF3MM144PM96uTaGRAnWHsdM8Iy4Mz2h15yioizUobcWZf93ajHQ+D9WAM1X3qexwkiIBauwceIBYcJUWaP5qA9HdbOcQmojNaciePUeIK84VV1pl6Yj5P8IlF2q+mX3nlH6mk2ZfFm9ys+CDdrN/BO1vSKR2pDmzSwKstg6PlYtfSifaUohbk2JGLGLHDh6vFarzph6+ku5QH+zo6ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzNlunZGTewDeYjGXkK6yZaG1PykwZfZvIxLbxNioY4=;
 b=K0stnvKPMRvQzIKaOHy75xh708GW6mlIffAnCkWVGnQvc70kejwXopfCZVx9AVgC/hZ3i6d2KCvjZ80Th6lD0d/s7+6KIxbnYGFd2o7YGvO3CP8BDsyKntbROPENmM1ylM3GXXeSNdtULlwUscTPjoAFq+GBkJuogUQNY2lghXE+A84JftyKp8SVViiVm7vFFcjtR3ydBv1FoTldGZJuYB4Ii0H7CHrHauahUNFWwc/D5R9es5LZ4LKk3/HcCxxKo4oCuKU2ThVHud89FBloMYWKt4djJj5blEXxsZpLBW3BEfFkuZale6uEFlEggbLn5ZMwITnP6HScMaqSUywUug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzNlunZGTewDeYjGXkK6yZaG1PykwZfZvIxLbxNioY4=;
 b=JssYE5j1CVSpmpAHqHQB4xQQmoerKHzMXtKAXVkSYIBQK+S0We76FoqzJ4uwnTE8Ia09WUtnqrunD7ZuIUMDyomK0kojEJEQITOA/BSpqyoEXOQVwIHsRsg2yxgPqCb2IGycAvbEyEuadPf57usRs1rFY2gPPhwbsJbLsRXnZltuDlkM3nxECHsk37cxgSimlCEvoRngYnF3fyN6XHZYZssOmsC4YpaZpjgpQ/8ztt3sMywx5jha0l2OdhXePZ/6sQsVbXfWksp6KiM1zQUD2Yziws5zOzD5+CwfKRhXTYxVZg6eiUNmwyHrFSeYQUAjAYcElVt6P6DOsN0yGDO0CA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3407.namprd12.prod.outlook.com (2603:10b6:208:c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Thu, 10 Feb
 2022 13:01:52 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 13:01:52 +0000
Date:   Thu, 10 Feb 2022 09:01:50 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-s390@vger.kernel.org, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 24/30] vfio-pci/zdev: wire up group notifier
Message-ID: <20220210130150.GF4160@nvidia.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-25-mjrosato@linux.ibm.com>
 <20220208104319.4861fb22.alex.williamson@redhat.com>
 <20220208185141.GH4160@nvidia.com>
 <20220208122624.43ad52ef.alex.williamson@redhat.com>
 <438d8b1e-e149-35f1-a8c9-ed338eb97430@linux.ibm.com>
 <20220208204041.GK4160@nvidia.com>
 <13cf51210d125d48a47d55d9c6a20c93f5a2b78b.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13cf51210d125d48a47d55d9c6a20c93f5a2b78b.camel@linux.ibm.com>
X-ClientProxiedBy: BLAPR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:208:329::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba7cb96c-e492-4c8c-9b38-08d9ec9581a7
X-MS-TrafficTypeDiagnostic: MN2PR12MB3407:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3407C3CAA92DC006772902F5C22F9@MN2PR12MB3407.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GSSTa831tZ5pTe39p98aOyzSabI/cQ19kkl2Xe/Gj8vW3IZwL2IsnBmySEH/0AU0al8zGaoRQwhz/mqAj1dRmHA6TpJlY0ceXpnSBzWCKnioCMDLVg0rVD6kLJfLebcu3Xvfs8Nrkv1IYAK+SkN/6uGfJE2bKzw1rRzm9duHy609yrwReh45yd1BlHSkuS6ObyvLxFuuDHhcpgpM7/Fu6Rbu4ntaIBnkKRe2MOr6ij9r2I0eW7ZEhzLk9tuboHbYAWdhE9veYMKAs0aocpQ9kfj7BNvfD2/eGjnNXAXvO+rB77PWTQRAL/pYgFnqeGX+f7cNA7OVE3xZYOXHyHSqCxKdFceh7reD9hfAlVLtJtfQkqiWOWpet8yJxlliTqeuY/26Dk4atVmahJYC9wqkBIyIX8TjefMd8OilLvQ9Rl8ZGCBlctJNamjatNGSfBVel7Pd0MYsd4WcMXs3FOfbf+/5omP/apxJjNKPUBKlI3ZX5r3CfYXPLZREYebEOL5WHKQfqXAnbjCkcr7XJdPRYb1IpVKP1dj7u2ae/TfCB0M9dklfX2oqijs1HNvGehwVHUWVuvNe2MCmNJkYOI7AMiLQx5Q7H5FvEt7D7+fmInT4VvEGqvGI1nU21m78sf5G+eEhYQQKpCsp7kYgJQ6DQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(508600001)(6506007)(66476007)(8936002)(8676002)(36756003)(6512007)(316002)(66556008)(33656002)(54906003)(4326008)(7416002)(2906002)(26005)(2616005)(1076003)(186003)(86362001)(6916009)(6486002)(38100700002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9OhIWrmasl/Ips22q7U6oXYVp3s821oZa0y/Q0cZMqBCZRyo00y8OGc5zuPo?=
 =?us-ascii?Q?fwxyaALraB1WWH1C60EHClPEl8mZB2zDvIhaXEzGjtvkITvbgRfo6xo2PL53?=
 =?us-ascii?Q?k8HjCZzW8N/sEBLT9DTJsWZMTfubkn3sbHgpOK8l/+hWeZQkbUcIJ/yzYlCe?=
 =?us-ascii?Q?0DxfoIqY/koHquOI0FY9CGC2Nxtv9mZ0y2AjstrVZpC2NLBAKVJDxKpan7aJ?=
 =?us-ascii?Q?cpCxqCA0xtErE5kj8MkKrTaEmsRind63HB5EZ6woPU3t2mw9zlE73O8zrt+W?=
 =?us-ascii?Q?PCJkJhimqhLlfpTtlICBdvRfDbPRONrYqFzTG3SzRcBsAXsdltxjTBd30m2O?=
 =?us-ascii?Q?lctUEXv1BhQapEkPZqk4h7TFQO165kczeUfJzf73UuW5tmYetLBTxlh8VmN1?=
 =?us-ascii?Q?7U401YqQAANyQM0VyaeyvJvbKRPotOmo6GlCcGXhZ/xHkGB2xXa5Me0OSpDl?=
 =?us-ascii?Q?al8JjqgA1ZnkxsiWSlGWUDwNtcryNh0DXetlYGY9XOZE1jgul1keiQxXWEH7?=
 =?us-ascii?Q?aJmCmKHsCRA5NI5FBKpRb3Fbp+W+OZj0Fw4gW3L1qjFHubsFtAOxZ35U6Okr?=
 =?us-ascii?Q?H1AKpiComWkNGWLmvD7bcxoT27PCZXp/QZd6ZS0esPcDPOmhIEiZ3OKC9fJZ?=
 =?us-ascii?Q?FJBu1ogD4KcdE/JuXCiPt5tsdOffIgf2mORpshUJMt7/ihvmrU+nW+vIuwop?=
 =?us-ascii?Q?Yjook1utyDlYm28wRi3b4Q0UadmNmN0sgjmGHF6m7BSCzoU9zzce+tvcLpww?=
 =?us-ascii?Q?NiM2t58VWT7BBbLKzF2cbxIlJAV4AT2XSZoiJHCA7lYUk55w76YTLsc5vuvm?=
 =?us-ascii?Q?4Qm7YXKNGSIqDWowW2Ow7oqniD8Wr9LIDwjVRsLiA12ZSJEX6cROtUdkVC7b?=
 =?us-ascii?Q?ThwvUX5JIzUDbYCEms/WuHWRcXW5jOOVzs7e9KtAIDFjFM/cOXiCX+zNYHV0?=
 =?us-ascii?Q?w6m9hF5LmKI5e+Yr7TkZlBNSwmxsYsFqA7QnooPvrnEZ9Z2ZsSlBGko7Oliw?=
 =?us-ascii?Q?b59JHFY3RjH//CuN6XzG9ygQXOqC+IB75QSDtfB48gDfrTfNKEiOvnlB3JQl?=
 =?us-ascii?Q?L2RyknJvN+0jppXz/g9n08no7wLk2z8oHNb0n5dG8EnwRqDL0YP/zK3P6T9J?=
 =?us-ascii?Q?OHsjGBjuep/HK//F3nthZkMtmeZTsK77ercOFg7z19JDmFFI9bltDQFcScxa?=
 =?us-ascii?Q?JoSZ0rkQQho3pPU7enTFr5VpTOmfDNheWHUWJ9DjEwubysSxBVN6GbQLD3lq?=
 =?us-ascii?Q?ZLaSLxKjyp6XlfJGK64lkEF0CEeBbz0n+NQunpvDs0s6Hp3KpUTrnDdQOKr0?=
 =?us-ascii?Q?AqGi7F5bRkwcOXx/2kMfohAai7HtudTi2NILKAqcryYGV04v3ffRpPTnT6Zp?=
 =?us-ascii?Q?PF315mCfmhnTq2uh/6pVzlXVh3VTIeRUkvIeYSc/tFWQM8FeqZG61k6jg/Fb?=
 =?us-ascii?Q?W7LmSkfmdDH8ELiotCU1dPrxzrZiUK7uVnprq+YdZqziSbC+SgWu8+DLs0L9?=
 =?us-ascii?Q?mIwGvC9vVFqwxqUu37vZxygBAAIn2+0fH2QRO++qH1Ewj9BnVla5MqFW87tj?=
 =?us-ascii?Q?EUGFKIVbbipSuIRe7xU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7cb96c-e492-4c8c-9b38-08d9ec9581a7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 13:01:52.2143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z3MLexeS4u9gQujhIYUk0CTl+QPdVNcEgy13lNy48vNhz7VfSkVzaDgNbrSMQVXH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3407
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 10, 2022 at 12:15:58PM +0100, Niklas Schnelle wrote:

> In a KVM or z/VM guest the guest is informed that IOMMU translations
> need to be refreshed even for previously invalid IOVAs. With this the
> guest builds it's IOMMU translation tables as normal but then does a
> RPCIT for the IOVA range it touched. In the hypervisor we can then
> simply walk the translation tables, pin the guest pages and map them in
> the host IOMMU. Prior to this series this happened in QEMU which does
> the map via vfio-iommu-type1 from user-space. This works and will
> remain as a fallback. Sadly it is quite slow and has a large impact on
> performance as we need to do a lot of mapping operations as the DMA API
> of the guest goes through the virtual IOMMU. This series thus adds the
> same functionality but as a KVM intercept of RPCIT. Now I think this
> neatly fits into KVM, we're emulating an instruction after all and most
> of its work is KVM specific pinning of guest pages. Importantly all
> other handling like IOMMU domain attachment still goes through vfio-
> iommu-type1 and we just fast path the map/unmap operations.

So you create an iommu_domain and then hand it over to kvm which then
does map/unmap operations on it under the covers?

How does the page pinning work?

In the design we are trying to reach I would say this needs to be
modeled as a special iommu_domain that has this automatic map/unmap
behavior from following user pages. Creating it would specify the kvm
and the in-guest base address of the guest's page table. Then the
magic kernel code you describe can operate on its own domain without
becoming confused with a normal map/unmap domain.

It is like the HW nested translation other CPUs are doing, but instead
of HW nested, it is SW nested.

Jason

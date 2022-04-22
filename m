Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A632C50BDC3
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 18:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346606AbiDVRBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 13:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiDVRBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 13:01:37 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCC5606D2
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 09:58:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+6BaE4McADpgU9ZKbH/eVHUB9zvO0SIow1quNkWO6GGiXZQ9jeFGwYj4bnsTTrBg/f9DvOvZnXY3e8w05hl+/g1IqYYwA1OptDaE/5EeGWE9F+M+2juP0TDFS40eqsmfr7CigRvr/N+qi0/6Vd1afBmAsdDOj8jnu5aggpEiiDThnmASl9IzQz4jntWtEWBMrcZAO2MubFr60GUzy4NcV5r9f0TktFz1wLDZa7GTiR+3TVaWyjCT5O1Vz6PViEIg6erzVTD0sjV4Jn3nV6i/+1WQJ1k1XOsVFVxk3ZFTaER2us3nlx0v8pwvtYDRdVbiqUbBaLaW7Rbzsh5WGHo1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jwuD96ir2wzfLiQky7dgy3X2M5D5oUwsk/qwiXNVW0=;
 b=n5Ho5pSN7A8gUensvcXuZPaBmHy18xBmY1F4JbA6KiBCax6rgOg8hJ1XAViX+GQma3vQRXiao+Wx7+vsaUFlyHkerKNS7WBiRvTr77+9fzSU0/cXOFIAi7J2bSDzWkmybG9IWDa6+Dw71WxiDdr3ZViVktTwURScomYqBLS6P3dBHb6CYgfBpfSuCj9YKJHVwF/3fQ08b8/3IgemMkh+GIcR47KInZVIZQJHxvgUTueU4ueftyr2TjxApl5oBLl5MT0L7TEICFZfqX31v2dg9sNZaHA2LQOvs+Ob6r92aYMt1Bhrxi+uWJaKtG8tXbRHqXF4RoSCogC6Eoi81lPe/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jwuD96ir2wzfLiQky7dgy3X2M5D5oUwsk/qwiXNVW0=;
 b=F/QTpvuVLvUGAXZAAFlfpfpk+kzhFCJnM9+TYPiVTjfYhZUOQCZoTDRe+hVQ1+EGFCHiDOhRusTI5QhiGb0uVnyl+mYD7p+NBvHNH2aFaPjQ2o37taRvdz6zsyhy23toW8vSNAm4hkHo5Xf7HiGkPJuWBe8DgARvnOTTW50zUa9xva5aHFrWGUrao7Yv33yJSVugzV4AN0WdR5aop6fSlqOPYsxoEd7r1HWQhL+09VWVe0a9LaVh6l2h63upB6Ehsjt8Lm2/jGUfeSWx+sr3VS5wbMiKlQjw63V9KUmMXHOKkY6TctqQ1xqZgkjt6DStlrNJEmQEOQWHIS4s4K0guQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5347.namprd12.prod.outlook.com (2603:10b6:610:d6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 16:58:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 16:58:34 +0000
Date:   Fri, 22 Apr 2022 13:58:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 5/8] vfio: Change vfio_external_check_extension() to
 vfio_file_enforced_coherent()
Message-ID: <20220422165832.GA1951132@nvidia.com>
References: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <5-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <20220421054116.GC20660@lst.de>
 <BN9PR11MB5276CFD31471D4EE85DD705A8CF79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <BN9PR11MB527616A86D88299C7E5F4B598CF79@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527616A86D88299C7E5F4B598CF79@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR01CA0028.prod.exchangelabs.com (2603:10b6:208:10c::41)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5abe0926-8662-4edb-5e02-08da24815635
X-MS-TrafficTypeDiagnostic: CH0PR12MB5347:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB53478FE3D69697235F9272A2C2F79@CH0PR12MB5347.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2smaXcg2ZE7uqHvdiw4+Kd3y4EmSXGUgd9yjcF1L7fv51lpTqysz5W/XkKOIFQqgl+X2bMHmzo2CcEukxKjwEcB+5v7OCEmH8C/nLQimiHAl9x6xvZIFKNOcHzfADS1cfhOcegNKPs8/STHOYOTrmMqT0BqXJYk+5DeVum8xXTZPDT6hcPNtE/mCvupltKU3fd/eqixdqKjbF/QCOC/+6+2On7MMP7v+XZV2W9CkyOcucIKGARwV9xZtsn8PR5TJvX4ufT4pBIIRJkTCu98amjz/766b+k8qfX9E78LTbncd+SAlLd8GwiF6mPO0K1KfL3oQFIIqH495d4dr70FunYiN1qOqfhc5luKW3VubKlcnqVxeiVjAlQ94zcf3rXYEXXm1r91cprM4F+k3u7RfofvISKoOZXBEjXq2GnNFyDKbuIf2MoQFLQnrNrgxiHqDd3KRGLi+pDSJxTosqn5zsuIAduGeYz0pBL2NcwYSML0eDPQN0GgT8p1Xzn6Pw7qdC0tKJNgC2NLMnRGpGgDIeGAK6yXJFCvyxP3Ywvj+U/oYq6uAS/lZO8H2IA11JsKqMfF+5HPydHbD/khwQr7d3L5l8WtzM97lca9F8j4wV9y8Bh6Bd0ohcOOX3scUfiwPurFnNrRLmtzgqw2J8EsqLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(316002)(8676002)(86362001)(6506007)(66946007)(2906002)(66476007)(66556008)(38100700002)(4326008)(54906003)(508600001)(8936002)(6486002)(5660300002)(33656002)(6512007)(1076003)(36756003)(186003)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dXo+b77zcFIyVoLE2987h/hMp/4TgEqOV0tL48GNO+HUeagG1JyDsZ7xuKBx?=
 =?us-ascii?Q?vnfestFArN589w0LEs28sf+A6mghKBOemiqDE2WdPS9eoWi49jbiNIa0SjxP?=
 =?us-ascii?Q?8l2ydZQhREaDhNi4PgYfImdd+looS+hiGQwW8Ho+x1Ili+MkGYAt0JFoDJkJ?=
 =?us-ascii?Q?u7te0LIfjylTn9O8/5wG0h74K08dOCgghsrpI7rdxUhVGcIkoCV+a41qmpec?=
 =?us-ascii?Q?gnOxX2SlHFNjg1L0MHirApuKkUFmE8olBNJYZcq6gtbQpNA3iaUYSRC7X9cH?=
 =?us-ascii?Q?vaLDH2DgAW0wTtPEI+H8Q1jaW1XEmf3RlQEFJwVquu5VeuCQD9Im3rPMH0A/?=
 =?us-ascii?Q?Xx+17f+m9R1FFlTFoDji7fghNf6BrTZK6Lz4p6416vIHtEc7A3wWk9cTrB4M?=
 =?us-ascii?Q?KuEgZg0ATN/ySOArJ6maDzwjoSeUgrujc3yXnLdqvP50EMekWhE2ZoZfrDHV?=
 =?us-ascii?Q?1qhUvcaG6hpcKXmCVuc72M3XJYPLMEI3BtiKSYG4RcfdLuI87KOnt/Y3ulGs?=
 =?us-ascii?Q?1LcZ+zT2IR5CUvVrNFsv82wDskTrxIgoF+IX6fAkJb+a3VG9L5yb2BkDMw3r?=
 =?us-ascii?Q?I6PolQVIDLPhnrb+LNZqeO0rxICQD/jQJ0t37/GU0bh1bf7tn505WtBROAiZ?=
 =?us-ascii?Q?Fui7M7CCU+Zkv6qIYXX/JFhAwInkkFPtDtiEPtjFSUZ9IHtFyS+dMRWkZxs3?=
 =?us-ascii?Q?r5Q0zGZL1LhdCe7pkQ4B1m5pwgkxM0Ou9KFgI5o32JbCxlKe3GE6v9mUCiO7?=
 =?us-ascii?Q?qCmPvYP6M5tAxCzNyTM9Jqhi1msLaMZNreHBXa/nECgsNYrbxmTTFskznr4c?=
 =?us-ascii?Q?m9Lsz72Y69AO0qED3j4qZU+Tulh17Bdn9p9f5M2LqVNSUOzQIDLRJVVbzCiS?=
 =?us-ascii?Q?gqRx3fs0qotBBpCLOz4pBaGS4SnOEJePut9eLSJqXKye3RvEkmqEmiIerC2V?=
 =?us-ascii?Q?owHE7Z0Pute5whnngb6GYsdobuTNqW+jJWM7KLVr/wqZkLhTxOIqUgue4ibd?=
 =?us-ascii?Q?6XHQLZREyg/VGRZAO7B6UjMV2Z5hqfNC3eaWV0iA5V7taCm0cTUmqgksJZcx?=
 =?us-ascii?Q?VnpCUcWYqD+3Ei6noCaegDfuJ5zr3KLQzAZ4X10M8eO/8SrKwsm+oi+GfVEm?=
 =?us-ascii?Q?Y4x8tsExv/KXfZvF0aXF5lbzPukjRXXio5aa24w2AOEPa9ck0N+Euhsv7XA/?=
 =?us-ascii?Q?qjRnnXJpNDgzWYKEHajG0Od6PTabLP33oLtOKwFVEfKnqEScXzaIBWYJpTMF?=
 =?us-ascii?Q?/RgsUW6vDe5+sLmY9zPUeULdF6HSkGnLlCuI91vnO1C2rQnrmE12h4yWbNb8?=
 =?us-ascii?Q?QzNW9gG2vXGHq8s8eCBWWUrHsZ5NwiRoiI/83c89tQ8Z/zWsdEbFMfFmLoGr?=
 =?us-ascii?Q?wlS8b+70IXD8QoMzRTh4At0NLA7MxgfyzseErIY13xJYoR5WD/0luDkZ+YAW?=
 =?us-ascii?Q?ZmJaiLn9QEQU5Rp0aajZlMd9W+M7rDwOhkFd6UBbIjLtdziNzHxOiSYKCdCt?=
 =?us-ascii?Q?LnpkMjHAm2kbgh2eUBrL9Rnc0zUM38OFkXCTmqk8ErLrK2mx3JOM2A6v4UIW?=
 =?us-ascii?Q?UmNJKOqWnslp5eFUSH00EdL0MOeteIZKtySHIghsk/MoFRfUmBcfTvEe9udQ?=
 =?us-ascii?Q?O/JqSMjuVfqptvPJV4bdAXWYZ1XBdNsz86vgwPIw/JFHP3EHOdv/uRE3qnJU?=
 =?us-ascii?Q?Axi3RDnJskJFGrEz4wU0Dz5ncKG6fdbc0RwNZamgNoTYhG58dwK3CyNH/IQV?=
 =?us-ascii?Q?x4rvF9TPag=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5abe0926-8662-4edb-5e02-08da24815635
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 16:58:34.4252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rPTKzvcPV28cNyKUekK1DvTN+JJYPVMip40Ez2AU4ks8XcpV9NCI4yQcnJD+VVAr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5347
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 22, 2022 at 12:32:58AM +0000, Tian, Kevin wrote:
> > From: Tian, Kevin
> > Sent: Friday, April 22, 2022 8:13 AM
> > 
> > > From: Christoph Hellwig <hch@lst.de>
> > > Sent: Thursday, April 21, 2022 1:41 PM
> > >
> > > I can see why a specific error might be nice for some cases and am
> > > open to that, but as a simple transformation this already looks good:
> > >
> > 
> > There is a slight semantics change together with patch7.
> > 
> > Before patch7 the container must be attached before calling
> > KVM_DEV_VFIO_GROUP_ADD, otherwise vfio_group_get_external_user()
> > will fail. In this case the result of cache coherency for a group is
> > deterministic, either true or false.

No, it isn't. The coherency is a propery of the iommu_domain/container
and it can change when more groups are attached to the same
domain. The best KVM can say is that if it is reporting coherency
enforced it won't stop reporting that - which doesn't change in this
series.

> > After patch7 vfio_group_get_external_user() is not called. It's possible
> > that KVM_DEV_VFIO_GROUP_ADD is called before a container is attached
> > by the group. In this case cache coherency of the group cannot be
> > determined at that point. 

groups don't have cache coherency, only iommu_domains do. In this case
it is correct to report that no non-coherent DMA is possible becuase
it isn't possible at that instant when no domain is attached.

> I prefer to returning an error in this callback > so KVM can still
> fail adding the group, instead of letting the inaccurate > coherency
> info to bit the user in a much latter point...
> 
> More accurately: s/cache coherency/enforced coherency/ in above.

An error here will not cause KVM to fail adding the group without more
changes to how it works.

I'll check, it would be nice to preserve the ABI behavior of rejecting
groups with no container.

Jason

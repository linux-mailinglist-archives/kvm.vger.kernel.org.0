Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DDE4F97D0
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 16:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbiDHOT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 10:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236483AbiDHOTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 10:19:54 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2B426AF7;
        Fri,  8 Apr 2022 07:17:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXxV1DbSVIaFmeZSVihZwyrV6bmK2PLLUEGyJ/XmlLI9kZD7kUuESEn2I9obmEHcUu6y0skZxBk7Ly0uPmBGZWxI17JZMDIc09uZDS+Fc4zGg5Bf4/qPKTw7vsNxFKgK0iLvM+aRBosRdZzCrrcnVzJsp7QOhLdffxxXnIqQm/9ytUVjn9S/zm+r6WXMtbufs2nd7nOQl0XYaNfTFomBDDIFAthR/7Fvy/YNr5kFS2f+Aqj7//ON8XPQChlFsJjxaaOdlwjvxWQxsdt0nxewhWUtZQ8Eht5kYzX1Xf3W2oltcliR698+CGq0B04VtEB8gNipBgpSE7QTpTAel1qKfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GqmP3gR22CpK7iW+X2ACYogrw+uPngEmaNVp2m3NglQ=;
 b=h7AiLJui07r+wlQJZTlw4Kc7s7nR97LQ3Qwx8T7Jqqq1ktC0f9JiHCIIJSmX2As13Ln0bIq0znzF/WMCN4nL53YC1Iky22kW83ae5GFFLYDoQbH/xNQ7SyFwDRpS4uYn4HHOsz/2uxnFFlNSqEgNIOw9U+BY7bpkrrsC33qETvX4OsUdVUlA8wZFGil0B60XYr8ZXZokiN3y5XHfyh3oQKnD+3ADnnFXQ76b+4WmQ8TT0VdqG/SVBR1N5eJ3m7CxQOsGv3dcVJGRorp75mdcf+dphCkOohS2Qmhp/uQA4xQnnGrGYIg/0oM1+xqS89MlLlYYf086A406k60bP8mV7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqmP3gR22CpK7iW+X2ACYogrw+uPngEmaNVp2m3NglQ=;
 b=EeO5HnChYBIUpOX225HMIOfuNwPLS48C+69A9+0Ke45owVCZyUNO8dHRWBNrPF2u1YRgBoVRkcGoejXbK5YA9zO4knNyV9fpO1b7018P/JAY5nteQfzwz5XeBW5GUFcJzQS+ljpAo0qhxH1kBbOdeYo7pNjYkOQ1feaYYIukzovDT0d1bcYkHc2V/jTjytOL0EKzSoCppwvCm7IdtkyA9dGmDVJ/5L9DAWWdfEwpnSJkCwGYfs/vKZ8UOfdkA4cDh64oiRqjMEzdl89nK9lrNY/eQSMnFZR6vdmPXaMInvKnICt2JXzDKrXLV+RRWlg1T5Jzli8+smGq7xMlglU5NQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3360.namprd12.prod.outlook.com (2603:10b6:208:c7::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 14:17:49 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 14:17:49 +0000
Date:   Fri, 8 Apr 2022 11:17:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/11] Fix BUG_ON in vfio_iommu_group_notifier()
Message-ID: <20220408141747.GZ2120790@nvidia.com>
References: <20220308054421.847385-1-baolu.lu@linux.intel.com>
 <20220315002125.GU11336@nvidia.com>
 <Yk/q1BGN8pC5HVZp@8bytes.org>
 <1033ebe4-fa92-c9bd-a04b-8b28b21e25ea@linux.intel.com>
 <20220408122352.GW2120790@nvidia.com>
 <YlA//+zdOqgaFkUc@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlA//+zdOqgaFkUc@8bytes.org>
X-ClientProxiedBy: BL1PR13CA0313.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::18) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85a4cbe2-4043-4dd8-ffb8-08da196a8f74
X-MS-TrafficTypeDiagnostic: MN2PR12MB3360:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3360BF0BDFC2EE47D5AB3C8AC2E99@MN2PR12MB3360.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9MN1Iam9JMOMHE2tI8Oyd4FX3DzOsVm1Gk0ubPP23JBCyKq13k1Omk3mLlSFPV9lYbva1T1idcJCq0DdlLBBj8buWfo55plHei1DXvMP7jd8XcpvSFJUCYWBvdgQzI8OdgnsyW50OjMzQLPhoHlvq3qj61/vN5llKUAPBlihMB60ixUeTItmBj6EKwqcU+5i3ufetTB8scWIk9CpneVD2DKtAA91eNB7lD1kY/CsZL0Gh2XWNbRp3Du9xbf1jfGMvbl5vD78uQIP0dE15E7kxVLmA6lCXK4M7H+t9IBYXOHkSxP8cSIV1Nw8dpA7M9zTaRunR3fA6iZXgyVLX583Z4dq8NcmYXenn1k61QW4xiIYN+6onq8fQmMM0KRj1DahT2Kc+FWyf9fAqOrvsjofXBbhrQ3uEdiUfMtkZaMWcRPynos/BTnyJGB9StRz2rft/fuk97Z0nb6G2CYV5qiyVvzDzBqP7YpcCcg/JKT6ag2yjB6CMTS7rokHyycG6O3Mh6duXi6ONv2nztTcv1kS0mOqphPWWQifcZ7SWdtRj+sHhN4eXZoUmsPONY12MfYN3iqF3bcZOX8cHICqGJsjX23l49fuczIQDMZTZ9IH5JLysUqPXyXldiJpNls9ooyFSlG2BtitWQyrpa8GPZYiIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(33656002)(4326008)(1076003)(86362001)(2616005)(26005)(66946007)(66476007)(66556008)(316002)(6916009)(54906003)(8676002)(186003)(508600001)(5660300002)(7416002)(6506007)(6512007)(6486002)(8936002)(36756003)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FDMGY3urnd74cH5oe/WPI4tPhbHrtObf61ucfkSskEL7UA3JgKUswm792gUO?=
 =?us-ascii?Q?BtSqb5n8qKAGiquXKcQO3CcneiHfmR5Q6wKHvdCT84LUit+UWEcrltF+GaL6?=
 =?us-ascii?Q?8Xe/tRFP88LGuQA0+CvOL4K2KS/46SwnfMH4m1Zyp5W9RDN4gRs99LtMCsUr?=
 =?us-ascii?Q?wODi+eEv2K8Wx6iJRvNl2io5HcHh3hcGFSqd+Jv8aZJkwcbFafmYimomJvVj?=
 =?us-ascii?Q?FauWXHuNf/N9GkZNOW9Pno2T6lyW9BwO0DHw+5dOUEVu60dETQPKb91u0w0S?=
 =?us-ascii?Q?VBTs/M6LVGLOUxkm9L+letc+HuEmQCpEYeq4w1Q2jb0nOonGG/0FoZmhjwU3?=
 =?us-ascii?Q?AP6M3lmNDzqEEFOoY5dynxuBwceSBmsunP2zsNpcA35le01GM9AQovsoH7a7?=
 =?us-ascii?Q?ilQ8MffEcfv0KYLen/9e19yCSENp1kMj99rQtMQYbd1KPjTVzatklxZqsYH6?=
 =?us-ascii?Q?1QpkwTKxRc0vM9Fyg92jy/wuD9/3/AbpV3gM5e6qMTv+OJAo30qeF8i42M3q?=
 =?us-ascii?Q?bPq98QvgJTCcjs4IDUjQBH9BRGRHMXmSXPdt8l6B6fG85J1KTVZlczZlnQU8?=
 =?us-ascii?Q?yDVT7CU8/vTk6zSLXOyjGM++8EBMesp5vknCR0TcJUPmMs2gBsl6H6SooJGB?=
 =?us-ascii?Q?8G6P9LWZlDBCZ/Uw/RDF3YTUqQQlVYknlxPm4NKTMSEtU/vwp33UtKLAm3mM?=
 =?us-ascii?Q?Hph2vLTOS5LxuVyHq3HQa3IgdHnmcMdfUSMEpkUpGEkfCRGXNq1eEz/QwrS0?=
 =?us-ascii?Q?c9J7uClfDr81WTpZyGVxudmd+iOSsG9YgEfiZqYcT24Jw/1dmU0JDbagls4s?=
 =?us-ascii?Q?78WBmOC5t/9VRrXPG87Klnl5HKILHTJ0WR8KNDyoAlYoc8E4qQlpXxuTffqP?=
 =?us-ascii?Q?3qRxLEA88SE8aVmIyw4zXzWSrGMflslsxt2LjpIYR9316yfA36Le6bFDxpxp?=
 =?us-ascii?Q?H0O70x8aE2IszpgPD40vxKIRFU78GpSLca5N7J05PvHqocHn8eIjCCPtAkt2?=
 =?us-ascii?Q?iiQYkmILH3EIjmnJFhuToeaiBsbVgKbI2n+8vtqDwzW57zSnGL29WWpe7iXY?=
 =?us-ascii?Q?eWzzT4mtXKljFA3KgcBH1LpCMSFMwBpFy2YEW/jO3oKeO9RZuPQ+4d4BGkdu?=
 =?us-ascii?Q?+cftN28ejywfvLBBytFcgIV/yrqXrG8BHMmmnl3I6Mqn527nSWuLghH3r4Zq?=
 =?us-ascii?Q?MAwp+pY/f64Cb9n79itC5iInocFG2EzAohltNgBQyh0nHlGlYha8+7tPn5GB?=
 =?us-ascii?Q?3MywS6iEiikKDVukgTUNQl4F33frY2zcUwoyt8HorIdHD5m06kNd34rBgBmi?=
 =?us-ascii?Q?1tIcVP9rhzIuRs0ap2Aiw20I6nV+7SQK54YZmCidL+Z5h9y65U6YL9CCINF0?=
 =?us-ascii?Q?QDOK7B1l/t1XkaWLEhWWpH7sWcG1ZlshyXITwA4iS2yiO0mfkWIcJUL+hyiY?=
 =?us-ascii?Q?IxUwWHU9DEADEbWjaD/y+gVU6Jpj1E5Veu3ikfDPohx7wda1BjkZGUTstzna?=
 =?us-ascii?Q?ncWFSjjNo4x+kP0MPWfVefh5onrOKBfknaZwBLc+k65TemTG6mjXo7L/v1vF?=
 =?us-ascii?Q?mENS8unFA8sx+PmPGv6AhNqlzRPYTz+aBOGLAVKCK8w10uKNlHKe7OTvTpis?=
 =?us-ascii?Q?b5WImhvSTQhwgeU8561J236+qow30y3NQ5F1ZMmQ0AG99UL5/TcfWSDkE/Lp?=
 =?us-ascii?Q?Tt2ST6pozZ/4QfM/YAoq/SgPd86iFKpVGc2PnSy8BfPonUdnQggZbvQoHx9R?=
 =?us-ascii?Q?Vr4aRHSkIg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a4cbe2-4043-4dd8-ffb8-08da196a8f74
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 14:17:49.2258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BBiNmdcBkQIvlLynOJwEfTwCizzg2pmuI9CdDkSZOU9c8JJ9ke68tG9wTX9F6m+6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3360
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022 at 04:00:31PM +0200, Joerg Roedel wrote:
> On Fri, Apr 08, 2022 at 09:23:52AM -0300, Jason Gunthorpe wrote:
> > Why rc3? It has been 4 weeks now with no futher comments.
>
> Because I start applying new code to branches based on -rc3. In the past
> I used different -rc's for the topic branches (usually the latest -rc
> available when I started applying to that branch), but that caused silly
> merge conflicts from time to time. So I am now basing every topic branch
> on the same -rc, which is usually -rc3. Rationale is that by -rc3 time
> the kernel should have reasonably stabilized after the merge window.

You might consider using a linear tree instead of the topic branches,
topics are tricky and I'm not sure it helps a small subsystem so much.
Conflicts between topics are a PITA for everyone, and it makes
handling conflicts with rc much harder than it needs to be.

At least I haven't felt a need for topics while running larger trees,
and would find it stressful to try and squeeze the entire patch flow
into only 3 weeks out of the 7 week cycle.

In any event, I'd like this on a branch so Alex can pull it too, I
guess it means Alex has to merge rc3 to VFIO as well?

Thanks for explaining

Jason

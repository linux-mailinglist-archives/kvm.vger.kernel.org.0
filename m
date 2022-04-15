Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63D15031A5
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356195AbiDOV6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 17:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiDOV6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 17:58:37 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4E9338B1
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:56:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKbTEOZOgxVtc3EaUw4QW0vkXPJ2mSvilAsE7GDIuqmhkRMPylZjVonFObE40HxZbr7pMmZMDf61Bm4QsCFChzsk0UE0c0by04Dckk/Mv5jhIElu/AGy5lETwQimRjGyX01wPNC6y6rQJIvCZNa9fXsHtq2pX3LbhmJiUBNY9LHaZQ/zHU/X28Q1Py2XZFoSmt2M4tvAQwN79VGUUQciqiCHmUcsBlNLX8OFRKYD6t0N0QKTTVFzlv4deJdNKfZWVa8eB0RIkUoUiuKk8zHJsTCBCVDrMCpz78yyKxXDx4QuEJQo788QxR6OzQAON/RAMX9B0nkdbKgTxennmdT6oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUZhoHJMwtsZL1R0BwKqrT7u6vGvWjcdopaRb4Iynk8=;
 b=XIc6FQinlhUk6xXHERuDyfvTuj/Ryejg2lORlFKMwZpKnvfFhG5tu1NQjIYbBueRI7+9w6py6ZFEsP00ltY9WWDi6ySFl0xrQSa79cshHkKzQ9E+FRqF4hLwuO7fRvgrNWBj49CIiekA4XszhgbDlUswHemsFZI9YkO8QZOtHh3R7ROlsSzU8ukwYElUqCVjRGWS1PZm9w2WN6UkTJ2Vi+iV1ZsZio2P5vaWLuTONWZ6C7NM0e8DuLGeTPbNY+Vu38akfvjejhOlNlm7mqxOyjXK30OVfV2iQR9taVxAmj3UDWLH3ag6wFnlY4RPUvBlD5MN7X856MyJswUJm0+FTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUZhoHJMwtsZL1R0BwKqrT7u6vGvWjcdopaRb4Iynk8=;
 b=fUh3kIevmIZjW41Ok5ay9VQziHNLlPVOp0VKERcUT5FDbEvmQKujjhqTa3QgrFMDGS+1j+a8MfGa2eyTFZIZTuYvLoxTUNsh8Vga1/T3TlZWLE6F49nwVN0POCvyZEaKI0kaKnSmlsx+UMyATCo5XIzqDfBRY+4NnQQ7FU3wZb3vEA/lLF8s+XNiD/G05pu7q2xNeTmLvZUc4PpCWUcE+Q15IGfAfjLnABi9SiP1HD8+CUyFnoD+RTUgUCsyfm3D2qRRa9Dm88BKWS1bsc6lROSsu3ji4jJwNRNS49wsK8umkozoO2CmvTbS1OOl/hysoogirH7R/wwBd/RZGP9Frg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4198.namprd12.prod.outlook.com (2603:10b6:610:7e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Fri, 15 Apr
 2022 21:56:06 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 21:56:06 +0000
Date:   Fri, 15 Apr 2022 18:56:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 09/10] kvm/vfio: Remove vfio_group from kvm
Message-ID: <20220415215604.GN2120790@nvidia.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <9-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <BN9PR11MB5276994F15C8A13C33C600118CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276994F15C8A13C33C600118CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1P221CA0009.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::24) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a4e3ee9-09ed-41f1-db95-08da1f2abdc8
X-MS-TrafficTypeDiagnostic: CH2PR12MB4198:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4198CBB36A63B29606676CAAC2EE9@CH2PR12MB4198.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VS1gfEUUi3aRh+wVGhDo39nsIvSNoROW/hRacPutzM0+fbWjavbibqN0ceb1XClJ66mUSgz/I645WdaD/mL+RxxvPqhD+O/grabbiSfTZCSXuPsBhajXdyHOjI63kY/a+E27jQNiJ9zcSsDPhE+mx9fxYe8G96EyUUa9Wy8kWxxFkI/VbFZWM82K/8Wf9t5qh5sBL2MgyJpeT+aqeWcgbsOngyUzbqUTbf3RPBt92qmrVpQfrZRMXvM/467uWL8SzwOGkInOHngfI8ESMg9ORRueieyFZUavIr3rGH+VCEZjp6xuF/gi0r0cQ4QqvGTn7TdguBRA3oj97W8TcWJQOk2trNRzC1wMq3/DdozUSl9jrZOdjwrLDBfIw3uCyABGSlpRZEBqQ/wFqoLk0kZI9pGeFmQr3WUU7iNLFTmKg1z2B2+DiFt8zv1/2iNWQie5Ds0TpcNArEVJL+bNPKMUkimS3L9c3wBFblS3j+9hh+hG8lxbLwrQVkNNe/UC/ajQ4LZAs83WIj7DeqZfeEh20otYP7szyLmcZUVNcbM6dzsw3ZOOhwN9EY2tOU9yhrRO+4TgiSD2/xld4X4qQ0PdbTOxYpSvARhVfkm1S2+e6dhubG+n3htVvQeKrmP/vjIcwyV3/xWE7vTIFWBlPoKfLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(8936002)(4326008)(1076003)(6506007)(26005)(186003)(54906003)(2616005)(6916009)(6486002)(508600001)(6512007)(316002)(66556008)(83380400001)(8676002)(66946007)(66476007)(36756003)(33656002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jZy39c1y/bYCNp+onX2FUCR2gEoygCqimjitFG7XJrKtrf5ZLo4fxQU6RKL6?=
 =?us-ascii?Q?hJJkuzi2HKB2rnO0EHs/IWWmvguhI7XKTID/9el6wJzRX8SmC4hWuH3JAL1s?=
 =?us-ascii?Q?TIsAgzpwHiLBthi49sqC1nhvY15TY2o9jJ2w3Rmh0QzftsTsp7QQsiouUu7W?=
 =?us-ascii?Q?RbMfqNzGzUHlw94CQKlBkCfH9J/mG3Vs0+4IkF4KoQJZuFZ/W8XDHv6P5VsH?=
 =?us-ascii?Q?9EeFpwlUTpCvtnSjOvR8ovdqINd1BQYsa3ARAzugZILwgnuTbnR+naN7sxuk?=
 =?us-ascii?Q?CFhfUXAL19zkuA+NNVqxo+viTMenPhxgRhN5CqovCQV7vR8v+HnjvnqLQaVb?=
 =?us-ascii?Q?/SqzHMyxicmI1MRZ9FDVYXRn6+P3YlJEjXYBV4paZE9QmEZrwSQk8vy9/8Ib?=
 =?us-ascii?Q?D5f1Z0rnj8wHJ0Knh+aUcr/oyP4BnPyixK+bWk53pXFJoS2DCuOegH6QlWMd?=
 =?us-ascii?Q?1FQEP6zrZe54SeklPUEOHfYCgjTDhtlsqvQA5ahbYxvYLyceU+aNacBzKsWx?=
 =?us-ascii?Q?jbFvte21JV53o348HpUbwH0ukdOrpq7xxHn2K8+ZhKD4otGU2NzD1WDJWhoS?=
 =?us-ascii?Q?K1HK6O1kFEZHUCORZxdoaAtjlHbiFZ6M9v9ur20QfIulJ6u4bR1xBw45/3E9?=
 =?us-ascii?Q?/7xw6kqJa0J8oaU9mBARA/eMKc9aHqFDJuTU80mtKJWn+m0cuLIq+zojc1Ce?=
 =?us-ascii?Q?xI0w6XFi00BdIddFiPaRlQ/ypiPKHRvGxPGJBVN4YGghNX1rWC1MlNKehStG?=
 =?us-ascii?Q?x+FFrndCCClQKjVRgn8qEbSrY1eTPSF3/TqKI7GeJjn9i87A/8I0z0mzggnf?=
 =?us-ascii?Q?tfMPAJdZX0l1Gbr54DlImz1rN2Cr14tNxXEmAvz0AdVids9AICehMqQIDBh7?=
 =?us-ascii?Q?2SZBW9rGsGqd8qIUM2yjRzHtd7wixSrMTQVSVDN4Ai0vcvtDVOvmMO9Ty64y?=
 =?us-ascii?Q?wmphFCvXFKuXp1b8dR2C2YdB2tPmWoiq3lagrr2LpJEOBx8xFqi4CuRVteTj?=
 =?us-ascii?Q?mbX8tkqwmr6QAQ1i+GcAs3bClDcgFwG6momE2eQkTvN5vtnmoK53T928sGYa?=
 =?us-ascii?Q?I2YJrsUCVGuC5uXprf5xUWdKcnnUFugcNXpVTweTEpwWSVOFY6xSnAhbP576?=
 =?us-ascii?Q?BrKUU3R6NCsJdrPF4PzKj+Qityg4H7cSj5ij09DWwo58y7L2fAKDSihSpQ9/?=
 =?us-ascii?Q?MUTo4gdugWd/4Yyw4IGuKZm0AkNRxBBsbczik8D3aRzX/kvBqdtJ1VuzxFSq?=
 =?us-ascii?Q?erkvvxc85PLpX6U5SVMBiphhfHLQb81J+eRjrW8Q6brpd66M6RAIaFJnBLyq?=
 =?us-ascii?Q?5gGWrLPaWuq5V7cSisVj4n+CIfH0pIsBCZwsMB0PVLj+qU9Zp4IaNt9FFjOB?=
 =?us-ascii?Q?J/r50xo5lHDe8wh7TY3A7iKmdgwRIGQCJevxEGxgocSAbJ5wNrvMOiVyAEMa?=
 =?us-ascii?Q?mim1FLo+gyggbwQpDHRLPwtf3wU2482cDEqyHddNSJTfONfRZojntnFbnDS1?=
 =?us-ascii?Q?OzQ54gI9vRrLfFy6CHwSiJxRmRQUAT8/Tkx6QorgS6uOgBJOZKs+59UGLz9+?=
 =?us-ascii?Q?Au8+5hDaBrh4i2ZiTVvhn3g7AfiydNAqL8yqEfJ/jfKlbhbxNHws3MOPjf4A?=
 =?us-ascii?Q?0j+PeVcLIhn//tpPKyH06P94ocHFQC8cfGqbZUy1lQnLtWDqGA+XOte7V2AY?=
 =?us-ascii?Q?TRcsep+6UT8sqf0LoVBhF7O5lZMLbh5BRr7kthDj4tLCtOMOVaI6YMfOXpiZ?=
 =?us-ascii?Q?e4wIE60S+w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a4e3ee9-09ed-41f1-db95-08da1f2abdc8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 21:56:06.0741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 06VPwbu0mqmav8vcPfHazejZbZ1lsajo0QmIETs3ua0sms1tVX9CRbH0tzNLhVaw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4198
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 04:21:45AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, April 15, 2022 2:46 AM
> > 
> > None of the VFIO APIs take in the vfio_group anymore, so we can remove it
> > completely.
> > 
> > This has a subtle side effect on the enforced coherency tracking. The
> > vfio_group_get_external_user() was holding on to the container_users which
> > would prevent the iommu_domain and thus the enforced coherency value
> > from
> > changing while the group is registered with kvm.
> > 
> > It changes the security proof slightly into 'user must hold a group FD
> > that has a device that cannot enforce DMA coherence'. As opening the group
> > FD, not attaching the container, is the privileged operation this doesn't
> > change the security properties much.
> 
> If we allow vfio_file_enforced_coherent() to return error then the security
> proof can be sustained? In this case kvm can simply reject adding a group
> which is opened but not attached to a container. 

The issue is the user can detatch the container from the group because
kvm no longer holds a refcount on the container.

Jason

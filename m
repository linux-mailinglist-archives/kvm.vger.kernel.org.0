Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4A5482106
	for <lists+kvm@lfdr.de>; Fri, 31 Dec 2021 01:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242400AbhLaAhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 19:37:01 -0500
Received: from mail-sn1anam02on2042.outbound.protection.outlook.com ([40.107.96.42]:43418
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242388AbhLaAhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 19:37:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSX/ud+0c1ffKak5U/Oiy74l7C3gJR9Su0lfU7vAXHuqoRDZZmJnd8iD5sO9rnDKpQ0rN8OoIW+D/VY6TbumrUBxfyL2AkFD8lN491MlmoQUJpfPBrkCmKpD/kZp65/TXGgt2GueUqG5tF9cMYvGcQQQnQvXhfvKJuKwo3xaZsMZ945ogDlECecNXN93jW9K9tzFDFKFJZYkYLrjLsbm1Y2syFjGNxow5+/LxGlJSoRpHZpPpGr9Qh8VHs8QDkCflF+QET8UKsZPW/yQYzPXd1pnmdZEvM3TAUfNaeo+6szsgt+T0rCkCX9AerBx2DVP4swv90AlJDaZDkspRqLNmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wozJ/jMKG0UlJUd8SAweilVWWLaeuVluMvmsOH9hMaw=;
 b=B5EYW9v+u43qXT1Pb1grBUm486UgC4sOc7d/aowIKipanY/5zNkRILaC8HjB5aiDnHTkgIVIjPdHq+5orfZhxbW5JHnVzkYP4kHjRq9rpE7NF9VbqB5GJbVngAOc46L43RLX5QLFmvf5MI42e8O45mgSvnkvOff6Plc7Xvbv9ucLORnBxLuok6/izzgs6zPD9dhaR7f5lgofzuoClEj5QT2ui+ORSUlRg2S3hdpjru+MqcJSG/9yFa9q4xU9lSu02aFB6XEMsBmfYCVopokgpOjEXGtRu/GIJYb1DAjaMJzthooN8VDL7zmnGYtxdfARIc4oRBncgv1MEJU/G6s99A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wozJ/jMKG0UlJUd8SAweilVWWLaeuVluMvmsOH9hMaw=;
 b=iY80aUWYU6kdAy0JuQkjt+tTfSzORceWK2UUjjkTx0gtxTaroqAZFxxtkMLCqGC8JU+4WwOAujA1l+DDoxRyUgnMgdhpu73183IGXuIQRSCsKKOF59QpyPdMslWWYc4phX7u0g11/OKW8wjsDCWTyBumtviQ6t60d7M+t6Q/nymyMhccwVBypuw+WDJDkHwrwymBqlzNGcQJQcwTGq149E7Yv3pCZHdRZiHsuZTF6A6hrq4lzTROrfaZxKb/ZPFhs5ozHMWBD/gTjh7ryLwK2mUCO6r+yoiMsnpqKWPtubFj5RZA3wn4W53B9EGJIqsf/ceKhOi98R4QNV708t1efQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5223.namprd12.prod.outlook.com (2603:10b6:208:315::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Fri, 31 Dec
 2021 00:36:58 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4844.014; Fri, 31 Dec 2021
 00:36:57 +0000
Date:   Thu, 30 Dec 2021 20:36:56 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
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
Subject: Re: [PATCH v4 02/13] driver core: Set DMA ownership during driver
 bind/unbind
Message-ID: <20211231003656.GA2327632@nvidia.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-3-baolu.lu@linux.intel.com>
 <YcMeZlN3798noycN@kroah.com>
 <94e37c45-abc1-c682-5adf-1cc4b6887640@linux.intel.com>
 <YcQhka64aqHJ5uE7@kroah.com>
 <2350bea8-1ca0-0945-2084-77a3c7f54f27@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2350bea8-1ca0-0945-2084-77a3c7f54f27@linux.intel.com>
X-ClientProxiedBy: BL1PR13CA0449.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55136452-affe-4756-a167-08d9cbf5a6c9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5223:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB52239583D22CFE4F59034B01C2469@BL1PR12MB5223.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LZ4uOFiCeOlTFo9SgfsHE5ppV5SM4Q4lsV9WZvgJsavy749sQBoXoGCZUDsNg9A1oRNRFBrWyPL/L8Os9MPwZNY+hGODV9cvP5driHCfIKGg/jtPW4BlptMgG9Mlt8Ev8+/IBKVcTCwLK6la0nXxTlY/fPLr8h1A3BfhT0qkoH5baUNcO46Db+MA9eNQnFL5NjQoZyQFY2BR3eajS3ksOQljLrZOjQL94+TOLNmlZQX8G3sdKPqffwJmhkcGBEtaDrvVOCVdq/re1tZx/YFBtX0PS7sTs6dwfEVBCpIyyYkE5adcsBUMVSr5vnbZSK29M9uGVcuokgql03nTxFtpDmzCVdOMlZmNd+fLrkHjd9zGroJMQVW9TnTZUEjmZ/c7Y6Snx6FehY0MfCe843C27rHZq8zkFNXkQjvMpvnOem2ct7yf+iMvsgfmtiZAlvfErVq/llWK/PzVW1EJ/Zwnr1gOTgac0Yxr4j4t4d9kepOm6zBUrYy4yXOd8rTr6IFNv5/Pw6WToGf3mxOB86T2cCmbfXQmzwVpbMm74l3oHIr2Lei+gcQHk6S136uytLFrd5C+yygcLcydQCqLfvgTA5ch7zRQrt48vV+h4dNLjGx478Qs93YFHSFsE9DotutM1ZeDqIa6gaqPrdAMg+/aHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(83380400001)(7416002)(316002)(66946007)(26005)(66556008)(66476007)(186003)(38100700002)(2906002)(6916009)(8936002)(6506007)(6486002)(4326008)(33656002)(86362001)(36756003)(4744005)(5660300002)(2616005)(54906003)(6512007)(8676002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DWjWhN90YAVOPdSwqlqA9hHFPMXhNw8TrnWKOSTmDzl6pX4RrCGmL46o3+Yy?=
 =?us-ascii?Q?yoJwdp1EGX0PW1Io84AJzTVA7r3lZu5UAj72ZqCi8MP2LP9dHz5k6HaHZ6ko?=
 =?us-ascii?Q?UaCur7o1/1a3jY6Pmo8sztET2eSQvtTSO/G9zRamEA7tKDECZwYV74AyPrac?=
 =?us-ascii?Q?50Oye7ysSqGvrhoss4Hrr1LHXxkvYrKh5KEb61X9mVyLckgVrRFjQa3+8uEo?=
 =?us-ascii?Q?G5nN6nFkMnzKG8nZmjIvaVuH0wCLNlqsfSiWyHgdKhFZDyTFm1WafB+yr/Af?=
 =?us-ascii?Q?gOWoscDXrU08629TGksRyJiCNd9WnDOG5iOXXoN9KhyPDGBkZlRJi46GnWbB?=
 =?us-ascii?Q?Y/hgRtZoDRNsAYVxF1Xf4qcNXIjUYeVdv5ccg5NHSf+nLk+88dAHKg2aH4uT?=
 =?us-ascii?Q?qsBc63taIBYwrZ6Rc57RDopnEeUUrU9ifbZJ3yaHneGzlshKCQ5toyzx2iVe?=
 =?us-ascii?Q?wA3O9OOfL5hxdyXwyzoKr6huOGrSzy2AkfzAHrREiIRD8fL5NojYNRkgzjp2?=
 =?us-ascii?Q?V+VIdjQ0WeBrjQIqODAVQeeZh5Y4waT24dW3HSUBTNBzqnSCxAsLr4a9+HsW?=
 =?us-ascii?Q?hGtaiXPiaCO5iM26SsHWpIL4OillwMlyTmBDcmfAsXiUHh1B45FOjjO1kJn2?=
 =?us-ascii?Q?aGftMujiLFCY9ZIhzBIyTdJ82toatTLTek2Nr/2sXjKYIIHtBCVQsB2/CmbJ?=
 =?us-ascii?Q?lq7+PMqBkX3dKrhbMFAs9tkh9aWkxxL/CCYDQJqUmB2lWbDVreHs3sxx2PLN?=
 =?us-ascii?Q?a1jvVHgK7nLgkQMcchWgINsvB3TWAXL6t44HjBCi+FA7tgXWDDLVd6E5oQQD?=
 =?us-ascii?Q?IPYmaIZQjOzaNAH1fs933/wmRSA0aAzXB8SAcO40o39wCO2MS+Rc9N5waalV?=
 =?us-ascii?Q?Ch6JDWPr+ySEBsmmFdEg+olRkLYEYA+d/vHrRiwyiBtUtBsU2mc1GcYVpBtt?=
 =?us-ascii?Q?AfWp6pQD0XVdZdFw5aPawgEcBV0+t/f6/u+FSMTYlHJ9jR9kvCC+UoNJ5JFT?=
 =?us-ascii?Q?DCVrFuDWZ4q6H+XHF70a9qPBfd+qWSh8plaZwGXkZSpxC5XyWFyR7DVRQzmB?=
 =?us-ascii?Q?d2YU8myYbAR3Fd5rR66uHBmIPYk99JMH3nPETmnEgT0VVGi91NuXYvO7M/2s?=
 =?us-ascii?Q?Zfen0fuZyvoTlJWU9eraT62YNM3qNy223+Mntz0Gy1nXznv1MkEeLOb5Zn8L?=
 =?us-ascii?Q?rLhNpcVQDwYHwhCSg22f+loQ/6w+e2myaDS7KiMM2XUR5VXN+Ct+oIGVs+n8?=
 =?us-ascii?Q?NsF4d4ZQtUTAo5zdkS47Dtf5v9ifaOko16kDYTE15CCeqMhahCeJUBAGqFFg?=
 =?us-ascii?Q?hm+71g90mot/1LPjlUJ/zbCHYRQm4dEGwTQp3riSofVpeFb6MXn5Bg+UaGn2?=
 =?us-ascii?Q?a+p2Fbwqkf+0pc2687iBD7tCFjmfK6F4nwjHWnyT+tHN6eWWIlq3st19itdA?=
 =?us-ascii?Q?R5I+bHmTVVwLAC4LdKaq372iwC9VKd3aXSJbzqbGLHYQkCjbnRoXcWXKaz7A?=
 =?us-ascii?Q?n+cSYc5AEeuOynegT8Ugn33tgWVpM+1guTvy3GvaZKp9fcTCR8pIF8ommEBG?=
 =?us-ascii?Q?FnxokyyEH4NAZJ2zs7I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55136452-affe-4756-a167-08d9cbf5a6c9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2021 00:36:57.7949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2VnHKTv6b/YPUysezANhLZCKj2W41qiaxjuNY+8TTIm80WBrXf5rl/RZrztSEX3L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5223
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 23, 2021 at 03:23:54PM +0800, Lu Baolu wrote:

> > If this is a bug in the existing kernel, please submit it as a separate
> > patch so that it can be properly backported to all affected kernels.
> > Never bury it in an unrelated change that will never get sent to older
> > kernels.
> 
> Sure! I will. Thank you!

I recall looking at this some time ago, and yes the ordering is not in
the strict pairwise error unwind one would expect, the extra calls
turned out to be harmless. Do check carefully..

Jason

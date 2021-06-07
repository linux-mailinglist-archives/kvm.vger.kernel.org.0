Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860BA39E6AB
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 20:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhFGSaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 14:30:02 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:62817
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230253AbhFGSaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 14:30:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wjj8XAqFsOPxqpGlT4LVgS8UWmPzsCrc8Mz3nIJtIntKr68YPc0L3ngEiO230sLPkC9SFSeYw1bnkhWztJlKvpHOTY+d7ruL1RESmX7l+oKeqhs1FZFAm/nMdYB0mDKRjXFi5/hrs4ztjLEqagkVAniCszBn4v3nWWFpxQAVEMEVfH7rzrF128smCgZjPu14dFKKcZpTSqRdqrdJUbtpKDiE3ydx2j7Gtd+zp6b9VwmFgUqQApBmtzsOBXezvdJzxh4b6yoC2hWpB5Li5HZQAsVHP444yTHzs1pBc7twHV/TlmFUStq4BP/QorAYMXKkCh/pfd0FibDH0nRlBoq5zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZgZt6FM7tEGLB9ZXrqT4mGUTX2aXZwduCsdq80vu/I=;
 b=Nbd29LJVzFiyy2xp64WZg8W6gz7oneYGGqfpCl3lw+fEDNrjMLA+5To/7DdC+GYqatCpDZjFsZ0ZefA2Q7NXrljxYM6UKUi+ZVtLdA17baQutlDlDGpe9gWpySIwpn7PddGJxtPzRow9aLKpTdJry0WjOwtwIEe+89U4L0W6dGMv/IXAw5R778Mgu8HmFifvIgBzJxPxb8gC7h00hUykTHOXfpI6NoDvHCRjCrkt9WWAOh3QcjdAztYIpHPg8MTzQlmWLYGtNeKiUltEh9S2te+mhP4/4WQorCsCnOdSveWTjsVkEnCyHFd53EvQv5zcf++p4DK7VNkG04Z/icVqpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZgZt6FM7tEGLB9ZXrqT4mGUTX2aXZwduCsdq80vu/I=;
 b=igZTlefA1YS2uz1VLVCxjfFUQQ1CQS8iBphDwrjtPy9+2bj+YafOOnFijkXT0WFwApWbK6GK/INuGxrI0AdrDFAjEpSWycR8QWYZjFndC77STWSAK7uU0IgT+nTIzeaIXKyEkGE2GzKbxSM035NwbIJOTwJDDyu1X5IeCp0hxsFFYjWb9r+zJ2Lj8p4mj3J3IAycm0NlbLRVbMPo+2Y5IB2R7GGmcZ5gxSHWTQgLDdWwip+SD30V4MZScHqYuZDWMdyJJHb9raNfh6A/NQ83NhtL/+jqeDNqyxatH1CbvhS4/xCDGQFS+c2q4r1B0EK5O4hFZZEtUQIRHcazf020Mw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5319.namprd12.prod.outlook.com (2603:10b6:208:317::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Mon, 7 Jun
 2021 18:28:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 18:28:08 +0000
Date:   Mon, 7 Jun 2021 15:28:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20210607182806.GN1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <20210523232219.GG1002214@nvidia.com>
 <86cde154-37c7-c00d-b0c6-06b15b50dbf7@intel.com>
 <20210602231747.GK1002214@nvidia.com>
 <MWHPR11MB188664D9E7CA60782B75AC718C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603014932.GN1002214@nvidia.com>
 <MWHPR11MB1886D613948986530E9B61CB8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603214009.68fac0c4.alex.williamson@redhat.com>
 <MWHPR11MB18861FBE62D10E1FC77AB6208C389@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18861FBE62D10E1FC77AB6208C389@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR06CA0001.namprd06.prod.outlook.com
 (2603:10b6:208:23d::6) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR06CA0001.namprd06.prod.outlook.com (2603:10b6:208:23d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Mon, 7 Jun 2021 18:28:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqJyo-003PFq-Qn; Mon, 07 Jun 2021 15:28:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8128a290-34ff-44a4-8d87-08d929e1ff7e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5319:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5319975758FBCDBDFCCE6A2EC2389@BL1PR12MB5319.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XBPOo3JrOK3lEzI47/BCH4qPmM3RxSiX/gdidBRaNZ+byIH2oX8c60fVpomfCydkYBpM3B/H8Mp0/ZyigIahIAXDrc7cbJ7CWZlcXNoJ//d+QbDZyhTXL/LsN8vixcJa7h16usmUIm7DkTN2fZ/xDKzlhkwspFxUWr4s8P+LVWZUthKNk3hhpTi+Hl5SYCOPtpr8Y5bRmnRYZk5tzPVkRrR+2DunsKRldEt7AMELWcnCu2NkyGVLogKE+NuuXjwtdo71UU5W1YJm4zkCjx/Gwz1pBIolFcf0D45NM4gNEbnMzY61v5MznwT+ApZt+34hLAAbK/hR0fnK0mLB0oI4TZe/c6IzIPl9f3lduoHaYwTql+zM4ld2UxSbTXQ3OS69ilIRKBNdweruLkgjr5Xf0XbCjyujQK7Heso+QrG6WoKwZhIaUbFWT7cNJ9LvUWyzX5zZNAXVkhPxZnN7+36oRAImvoTjT/xGq9uOhjMFzCAhHTpX6sy5GJlXEC67MqW6xKu7AVNz+wTnN0RbBSSdlLifboBjqf4+UYc/acBZWXs7nbSv1tR+nkxgtGXNdPPwuI3nzfCp4+14rQPd95ocKc7sQTfaamEog2OWAch6r43klfX5aqSIMkHUw3vs44nSqcT+N8ovWaAW2EfR42W0mtsAseO2VaZPGcUbRv8lfCwOXk3DbN/H97HwZnc7DZos+aQgYc1mS8ysXvgzVKn+MnGqpZokU1MPso/kcaZkf7s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(2616005)(4744005)(38100700002)(316002)(26005)(5660300002)(1076003)(2906002)(426003)(66556008)(9786002)(66476007)(4326008)(186003)(7416002)(66946007)(54906003)(33656002)(9746002)(478600001)(83380400001)(966005)(6916009)(36756003)(8676002)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Y+Qx6ZnxtiidePQg0O8Psq4GjOHjE2IWl7WgcpmDtXpoufMlr3W38IUOPQc4?=
 =?us-ascii?Q?ijF7hjbxuoF8LBuJ7RM2m/Jn0INzpEaxBrN4hAEmIaEFpwRj2TpIJYhCP8XO?=
 =?us-ascii?Q?agPmpmBlRCv48HM3IDomt/sDyBykD+GO/lS6W/jCNv6yxVNd4+hq0b5+10ia?=
 =?us-ascii?Q?Vs1AN6z+WieeOEN+chKQ1yawFHiDce1d0BxmMaMYBgmgILpukkpQjtOXGR3J?=
 =?us-ascii?Q?t8BoYP+SNIUtTuMefoOCIC/4Hgdm2/0r4ReWJzoZOldqJ9rfAj+a8STHrr6T?=
 =?us-ascii?Q?mRF1v54czq5p5bcIt587eWz5347d5ClaOm3lL/6C2SUAimK/164Ga6tbHE29?=
 =?us-ascii?Q?yoEaSVQ/jiQH05XD+YIunjCREyyrcCZCaZ0OcBWSr1mCUhamolxPyX27Aari?=
 =?us-ascii?Q?OGwXnGl4i624ThOEOJkC8yCSP3XIs3BrsC1gaW8HYJEnn7RsltRoi0vSbR0Q?=
 =?us-ascii?Q?TnBVGkOTmZsaUrLCVafvoOkJsFztAmfuro6K3f5xgMxrqJ0S+l3+Pid0+C+n?=
 =?us-ascii?Q?BZPfh6vftRZ71BrxE9Fh0t8TjPSQQpP2dqUvtEONvbDbhj05xq0STXncaI4U?=
 =?us-ascii?Q?SFl3tvDx1q9y/jidK8fGCzJFnEOrvsN7mPf9md5OeYQSsWlf1b8MbqMQ/VWI?=
 =?us-ascii?Q?F5XWr7wI0WikX5mf+kGHJoN+NsfitJCF89kidkm7qH5Q3tM4zBIYd/BmPPDn?=
 =?us-ascii?Q?c18qV2hS8A1b8lw2/5Rn356YAAB+yBjxAbvRkcjGV2629ItaWc0MDBDWDH/E?=
 =?us-ascii?Q?1awEecgfwe/qHM9Rc9HqOpYSFMhboqiJ4KOllurY6OAcsMuZdbaWYHQg+Hf2?=
 =?us-ascii?Q?6Lbme+lb8O9CV5L+8n7A/F83Pqgw3QrtuAsN/S4GsIi072dUxDYOIK1UTHoD?=
 =?us-ascii?Q?zuvj8MgvoGgm+iZ1KcX8kJIFR4l2W0UBXOfv9CQWH1FQC3cT7UI9G6g5G9Ka?=
 =?us-ascii?Q?JnwAoP22tyYgloW6gWIzu13CTHKDbEbLy4zYvMiYIfdEdkbC9WRCHLnILjMu?=
 =?us-ascii?Q?d0ifRp5Ib+Lw9hUA/AJ0yQ04ffocxckSJwWg2Z9IsoBF60ke43sloK0drprf?=
 =?us-ascii?Q?b2rIf5GmSjLW0zcQ3LH1FXkeiK3AZYG2DOgSgTOakHtxnWsY3cdrdFG+/Ano?=
 =?us-ascii?Q?hf60+jZA+KvJYxELP2rMUie4mdZ2J+P1jVnmxmKRzdRZbbEx2DKkFS/KKMQA?=
 =?us-ascii?Q?Nl6bebAyyi7sPEW3EtTaHXBU14oo6wJ4bft9Ay52S7vx1zKiY2BSCBfs7a+f?=
 =?us-ascii?Q?URQKLOsWz+JbjTe6WpiCUhzPbh2qc07HQVnTFebZlxrOmnOmjEJr04TUgGzj?=
 =?us-ascii?Q?DjUPu2+fWZu5UhyHLiha+Pvo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8128a290-34ff-44a4-8d87-08d929e1ff7e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 18:28:08.2421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TovpuJvDVGFTl7AxfhGLS6N8rqaPFr2Z+zi9twYpGXJRwVUTwQE9faLb3nYrQcHW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5319
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 06:22:08AM +0000, Tian, Kevin wrote:
> 
> btw I'm not clear what the netlink interface will finally be, especially 
> about whether any generic cmd should be defined cross devices given 
> that subdevice management still has large generality. Jason, do you have
> an example somewhere which we can take a look regarding to mlx 
> netlink design? 

Start here:

https://lore.kernel.org/netdev/20210120090531.49553-1-saeed@kernel.org/

devlink is some more generic way to control PCI/etc devices as some side
band to their usual uAPI interfaces like netlink/rdma/etc

Jason

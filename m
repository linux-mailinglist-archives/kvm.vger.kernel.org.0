Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A654050FD18
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 14:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349997AbiDZMg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 08:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349964AbiDZMg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 08:36:57 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C0B12EF25
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 05:33:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lljH0uj9DgBW84jxfNMdjJQ/k80IxS6eVh5f7YPqrOo+TWJxAxyzLElGEzcX+j7gWkRpRGgp8nDwUdNGqho6TJ/JM2hNW/w+4ebCPOkXfd1L6lN8hsrJ6W9vLN+clvOMoL2HvB/+fvDoFLFKUkd1MMHK9jVfJOXVIyjeriw05G53431UUEgYqUBsuAux2Sq43lqXJiE35T8hbWOCIRQHGynQHxh8WyjsmAKDwBRhmnYSKLuWBNPYllH5A5Rt3KNkAcVpqEi4pdqjWIl5zPVDZYqawOJmdNpWhGMLo9eWUW73RAxGlfHuJYt/ASTkWQEw+hHBUP9/Q74ty7Yp0cznpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BL5lXcch4qzs01tIjhC12BQSsBAK5PPyF3WNx+LnexM=;
 b=fkBFM1Zfzr9SRYg+TeMkc60VdSzjpKMopMHegPk6r6SS/WTuRBEzUTtcrsTzFev3MXnFp7istms3fXfM0JgzthdT1ZxH+cdc+X/C3enkKeO9Mh6FbIPWP9iYCiDH7YRFhR0MilyDBtTSg/DUuXYIH1yUTc8g/udRrrlq98sxm4K8NZONu7jmEUCiyxlfyujrxrftVVr3Bq0DihT+BcL9ROSzonHOTKWf8S68Y5gST0+1Z5ydqO5Pu2rCp4A+PtOttWHScgtWNdmmGgtg1bQixVTF1M0VBYauWqVUrjYGxr3wVxw3MOV7IztzF3UyDL8cQN22Md//qqcTLI/C5GsiCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BL5lXcch4qzs01tIjhC12BQSsBAK5PPyF3WNx+LnexM=;
 b=ZNEQAC9CeuQbcugqO4PUpmv3nEsdHutvTLaBwcbk3s5J/wlf+gzG1M+cV1Nej31oDjrz0fRBu1fW+mldKutxVArk+Ffg1Pvq0L0oNrrh2jhwtCrgIWzenZydTUvlMbJD6r/gavHj15O4d5jD9gsFfxJGxb2wQ1OLBPCb0OLjFfRNpY3zPE4//OyZiejrZlHY2m20Vu8gF81zJN2m9wn4mdO23+n03rGyJfkiQC3uEO3d/c6M43JZ5QTclSlo3MiqxzJGhAkTIwiKkj/NHcH3L00By2em+rfVZIW3kwbJEEUKx8oF0+zGDzAmcmx9zdnB+2NHYg7BqRNRtGeeotyiOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3387.namprd12.prod.outlook.com (2603:10b6:5:3a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.18; Tue, 26 Apr
 2022 12:33:46 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 12:33:45 +0000
Date:   Tue, 26 Apr 2022 09:33:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Laine Stump <laine@redhat.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Message-ID: <20220426123344.GL2125828@nvidia.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <20220422160943.6ff4f330.alex.williamson@redhat.com>
 <YmZzhohO81z1PVKS@redhat.com>
 <20220425083748.3465c50f.alex.williamson@redhat.com>
 <BN9PR11MB5276F549912E03553411736D8CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276F549912E03553411736D8CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0210.namprd13.prod.outlook.com
 (2603:10b6:208:2be::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0253944e-35e9-4675-0765-08da27810175
X-MS-TrafficTypeDiagnostic: DM6PR12MB3387:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB33870F1FD5DA7666467E775FC2FB9@DM6PR12MB3387.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HWzLMt741RGfZBP35m9fj5T7Tivu3H1ICHAaMUVHa0wwLqF9h5MMKKgS+/tqwRn2Hzrz1uoENLUM1kvdysXKNgthPVkkn4IXK9q/vuDBfOyzvv3FRAmaf79agJlB88lFkva5yACh8RTQMmUQ02p7Lok7CgrNr+HbnVsaJdwij97nr/Bd2SZGZjderHizNGrKTPQa/05DUbVKw7LZmyn9Qf5TPTivACjDtgnCbEWI+0KvfdnDXbxGwoMhoIIXy5aHu4117wx7tb57E3u6YDVO6kO1X4vN/WPK301DZyUlFcbRt6yJuzQEGo2nqd2Ck+EZgYg4Yk3amOPs4aPjCS8JZmpgepbsoo4TM50xHEIyVj1RG2EVPCFVSUErpTIbpuzvRoy8AAQB5aHNLIl82n1FS07A81yvuJs8jB//7JOI3aWj+vBKzcqQF4Rfb+m/jJCw9zxeSYz/II+ogcYRkQ3Af/8MyeUmiO+nYVt0RmU1NmakxqMaQHC5kyyEwDRJW6FyfvJHHnQLrebF7XOqzQHrzrSmpBa9c6AentGcWN0BZpUpWT6xoPwYtLx+bMlU+IQ/eVJo6/LTUC3kDvtZNu+i187JoD+2Qy5zKCG18DUQYjrMBEzZymZ+d4KFDAIOym4udGPRk2SWpM+JRcM8D7llGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(186003)(54906003)(508600001)(6486002)(8676002)(36756003)(4326008)(66556008)(33656002)(66946007)(66476007)(2906002)(8936002)(7416002)(4744005)(2616005)(1076003)(26005)(5660300002)(6512007)(316002)(6506007)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aTXywMKhIJ2ozqd9FV4wQZI8S1zUFzXIaYRgDIAJsgWVuadptFtHwo0Cymbj?=
 =?us-ascii?Q?uAut34ZnZ5eIBbPinyAYCyNisFnSzI4aCcfuMuCWmDqVkbCPAG7Kr1C4VoFR?=
 =?us-ascii?Q?dNXeWrmWXW7GfkUltQk13rtqWcKmtRji5WKZEuDlE0G91ykh1wRls1c2szyd?=
 =?us-ascii?Q?Z8TWCQDKy+cnQc1AytCn1s/VGo1Alvmo0I8UAmqt/FgZG5bnwsTHkbKr/CG2?=
 =?us-ascii?Q?iLgBrRFCj/eUFRjukXYdOIXkc39w90ew1cHmyftVMMNSf98kSjjVo4Eh6BCf?=
 =?us-ascii?Q?6DzR7Gk54E+QFauqGLUVTY4Qvdt5tQv139hMuvBxHx77vvu9NgrVh/fFzQcJ?=
 =?us-ascii?Q?6dsGp939jPlNIRefrr8Is8PZHsh0WPA3UgToQuA2NdRXPwJKI61qRbiNtawk?=
 =?us-ascii?Q?BO3FF7amdNsYFsF2dBEHNII58Rr+pIBrB47aPK5MMBVAybJfvS/bFdEilPuw?=
 =?us-ascii?Q?1vNNsomL6GbODFG3hroBdLVMFLB8cyEg6fIA6cK8dqWr7oJbDTfrjUea3H2S?=
 =?us-ascii?Q?InCYcTyKaw7cEq9SjsesDDTs/AQGPGf+nGUdgsOcwg6heOyM9nMjCApozJ2P?=
 =?us-ascii?Q?uK5v04wj1bx/jN2hNN9+gg33FTo4JABGsmNibyNRZQ4IHZZjrtXHqY1p9ARv?=
 =?us-ascii?Q?JacyYe9Z9/KD8OklebzCNbeq0XiQrJYvHJ4GI7Wp19jeHNN2TfVRmYOB9cod?=
 =?us-ascii?Q?1r59esaugZbgocgR/B8sNX7JynJp6qUIrhRW4urd6yeac6+WsMSCL6OaT6ap?=
 =?us-ascii?Q?/bPIA4q8MWrZvbiFLkHJxUC7Sovx5L7kj9S9+CMHYr359l/F6YeFOnqSqywG?=
 =?us-ascii?Q?DUSaTYtObooTKjVd9oIIm3inUbTlxC2cMsdNwXEbn7KGa4QWdGZp1Ymj1flh?=
 =?us-ascii?Q?JgWxbl4Bs3YTq9Qo7+t8ci7WtZE/hKzO4UOpoKxml4MM2FXoheM4ZWaelihq?=
 =?us-ascii?Q?mJLQgaQR7+kfuYdABdK6zxW+GNTp5742Bph5XfQh0wI/PlPWBGyxmA2x0H/o?=
 =?us-ascii?Q?EfDxJvEK2vRiIRwX/E1yEL9dK9pUa4Cw9HrwfRmFypFIK0iui2j5xgRT1u0I?=
 =?us-ascii?Q?4h1S6VEm05ONH3Z8lqNdNHqtTg2AzApj+kyC8qyl4khZ8lk+LKFCQQ1aV2tk?=
 =?us-ascii?Q?E3LsKHvxMhcmiGhn0iL0MLJUjGZL4cOKtWok35SpuKClUtKWIFIQhH5lVFnI?=
 =?us-ascii?Q?+oU0bR9Yr1HenwNsdWVwkz0vYLg74NKERx77B+ZPsCwXu+ADm4uAscMd5oAm?=
 =?us-ascii?Q?BzXOTV4pg8oyMgXqkFmqBsJg3NMPkDZuZ40dysSve424SRtOpzYS8LaFaJDY?=
 =?us-ascii?Q?BXOVN5DrhkwL48nuyygSCrEG5H/uT2bMnvIQ1t7DroAR5gncRps5VwWN1/YI?=
 =?us-ascii?Q?IWBT4xr/QreYClKn9ewykKnOowwQ5HLAsV97+dX+r3kYJL9b4e6pu3am3b+T?=
 =?us-ascii?Q?wO2qGZ45svaxunIGas+T0gW04hy7UHo933OXhrmx7K06OWl0XGIORvbAklrM?=
 =?us-ascii?Q?K3AtWhFeJjoByZzjsoD2ON1sOvEmeTppKhtMnsY6yH0FzmBOq4WI6YVenXoK?=
 =?us-ascii?Q?DWeAMbppROQ1wrpt3Z54+RERTfpAwqsppzz7tgzFiTbKt0frmvhy6sxlyqaq?=
 =?us-ascii?Q?rpOUG3VvOgo1Bh6n/DqW5xmEJ/drNuE47PhLSG97oTBWBnM8nqwg8UcTVG3d?=
 =?us-ascii?Q?cVK8kWc6gauLa0wpTXL0vcLxBrKzBhhqLl2ojO3zmHfOLY53ER4XpqY3RKdq?=
 =?us-ascii?Q?LS2C+2rK0g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0253944e-35e9-4675-0765-08da27810175
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 12:33:45.7557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tQT/SeghSRFBY12NOlAOKOWlDf6YPUQf1GiyuDEH5gm5+9PU1kbIlhjDokywS0Sg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3387
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 08:37:41AM +0000, Tian, Kevin wrote:

> Based on current plan there is probably a transition window between the
> point where the first vfio device type (vfio-pci) gaining iommufd support
> and the point where all vfio types supporting iommufd. 

I am still hoping to do all in one shot, lets see :) 

Jason

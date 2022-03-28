Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100934E9678
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 14:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242415AbiC1MY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 08:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242413AbiC1MYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 08:24:25 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3EF46662
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 05:22:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mo3pQuAjw5G9FXmBQSVOTL+rXHlR2d0hOjeEp8JZ4WkYNPEtHMZIQPwQ3F4w12nugOpUMjoHVfDFCr/TclQ20inrjCjMBpBLcY9Fl8prvZlVDTTeIzDLknkj2ErCdFSOiT9YG9OQDPUkC/lImDPDH3kSHZ2sfyGgNA5iItUZxWc3S+NCyX0ZkyuOtEe+YtzxkacXFUrvsFJVlHrgQ7iMnmDox6KaPP2yR33Hd3VG6IYv+tDhVsshKn4AfiAPLsWq/D/tdfkI/l5utVPLXw/LpoGqYgHnUM7kt22np4wpZ256sDK4rfo9Epk6z7ljagRwJQ9wSej55gbEX9g4UaKFtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=leRXqSISEjf+QsN6uXjqGo+pNy63RFr1/INsmU/04c4=;
 b=RBskU51kJb2iLuf7SgzLkKG2lNSGD/jZjgglBspKEeqd3jvS3pK5So8smiVzfVpvn8wKL6IkQBiBMNJsrLkFEkfDbemQsBqM8DIo6PSTre1KqFfZKDbzawU6LeUwrHTJfRjBC0yjnnvfvCoSis69Iq7kBBnxOjPjz1KhlDAhe5jKwLTZ7lj9CwMARKU8w1kI2aLII+8iJzR5F6B7J8K4AyxMIK9igRkHybA0npDY+gzRNe21edj9PnHDcLQoIanZVAb8La+MD/Ic6wzBLRK3nklrWBfgQGAMVJLEWYX/NsaYOI5zUsQnDcwgcyA9TOtZ6iEeqGmCPdPxAiIx0zLmLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=leRXqSISEjf+QsN6uXjqGo+pNy63RFr1/INsmU/04c4=;
 b=HE6xKx8PaLWUg0myNj0MZlBcmgD9mMtmkDJBSmLGaw9RIjUzsjDD3HK9VsxfkCyCIi7YjonSMbHpumeD7lULW1ujGZPpIEVVjdM6ykWVa2VE+yhKdAVkPErdlqQU5kAFn9uMxWjIRMfYlX8Mr3T9bJ3Pvcki19KFuGup19KwWGsyySrc+5yzJoftIln6wDvtztmu1P/Z0SH0FMPMX27oI+BK6U5YGaF8heuHmkZ2rjF7pwmxdkYvICFkq0OPv0HgsG/t5CFCNdiRroQpWOCp+p4VzPQMgrz0QBFWXQinXagpqogJr9hcmGAccExmH49TWkYXxMKN4nPFeEXQjJX0xA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR1201MB0012.namprd12.prod.outlook.com (2603:10b6:3:e7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Mon, 28 Mar
 2022 12:22:41 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.023; Mon, 28 Mar 2022
 12:22:41 +0000
Date:   Mon, 28 Mar 2022 09:22:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Sean Mooney <smooney@redhat.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Message-ID: <20220328122239.GL1342626@nvidia.com>
References: <20220322092923.5bc79861.alex.williamson@redhat.com>
 <20220322161521.GJ11336@nvidia.com>
 <BN9PR11MB5276BED72D82280C0A4C6F0C8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEutpbOc_+5n3SDuNDyHn19jSH4ukSM9i0SUgWmXDydxnA@mail.gmail.com>
 <BN9PR11MB5276E3566D633CEE245004D08C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEvTmCFqAsc4z=2OXOdr7X--0BSDpH06kCiAP5MHBjaZtg@mail.gmail.com>
 <BN9PR11MB5276ECF1F1C7D0A80DA086D18C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEtpWemw6tj=suxNjvSHuixyzhMJBYmqdbhQkinuWNADCQ@mail.gmail.com>
 <20220324114605.GX11336@nvidia.com>
 <CACGkMEtTVMuc-JebEbTrb3vRUVaNJ28FV_VyFRdRquVQN9VeQA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEtTVMuc-JebEbTrb3vRUVaNJ28FV_VyFRdRquVQN9VeQA@mail.gmail.com>
X-ClientProxiedBy: BL1P223CA0013.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::18) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c18c30c6-ba1a-433c-c2de-08da10b5a759
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0012:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0012466D7A0DF0D61CEA30B6C21D9@DM5PR1201MB0012.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: StwqwO0Ns9Xo/rfrjF7fAe5c1zVYhyiS2Ysn5Y9YbvHsr+1OAkVSpw3txwgMwAqVhyBTA39dzIbUa/daf8RDJcmYgbvC8sP8pGzncIyd0ZgxeX0RQvr5yUc2VfdalDsRXQ7jo5mOxr12rQP0H+oNz14XDlUCE24muGHHKL/g+S59evHd2bfunuWTPGhpAPAyXZPKJ+j7XeerMrXNeYmdUQASftN9sQIwCBLQyaqDANiECY/gb0iHt7oChfurWWZgwVRcsUSM7ZEPoPDZ1goT9JZSm/z712AVaM7LV1jJqxnCfcn/KS2jLwU05sycxMVpDE5vvimK4SiUotJtTQ5tzgLljKsilxhccPgLdUBwMdE8MHOFqDmvLVEvcMxbzDCVFHkWXC1owGwLSlCYv7Me5lWSreTCOvyRtvx6DKMyyqgtbc5SBEbfMgP/UnxmlSA/K2O79wiPYBc2KHUOZ+dPZaMNDvNO4onx2mATCNHOIsheHiViIcI5jKGJuHRL+3KxcrUB2hs1yrb3d7hUEDJQxRKJzfRJWuz9H80/oNEhuBD8maaq8XZYDyuyIWX9iqxuHQ1DN9P7Eug0gDoJ30KgbdEONXhHC2IACoC5DTzBJQu9KjWDZ5BrR7AzRROVkapR3QqjddWDKbb+3pBrduqdQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(36756003)(7416002)(6486002)(6916009)(316002)(54906003)(2616005)(66556008)(66476007)(8676002)(4744005)(66946007)(4326008)(508600001)(86362001)(8936002)(38100700002)(2906002)(6506007)(6512007)(1076003)(33656002)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u9Yef1VZbu0Lv4NsKquELRfI4MzieG/0YnriZ3wq8Aa5wC60WZE/NSWN/Fk1?=
 =?us-ascii?Q?4BrkPrO8jLtS3WLquVRvV3kq+15oDbvkWKUwmlGvVzhd41sU3VB4B+m7tPwh?=
 =?us-ascii?Q?OEEaUIc21qaTT0NNgj8sueC88HDq2zVBLIZWgP7WIA7Sr24dE9o2OpZdj6Hp?=
 =?us-ascii?Q?Usiddm9p9BD9aOCSc98s2btNcvr9Gw/ry4zCe6YrYdrQ3AQbywnZhzvgsNu/?=
 =?us-ascii?Q?W0v/5jPGV5V6MSViZj/7ot68lz1kkymCdOptpVSi5gCr/N+s6n6t8YlcwtL6?=
 =?us-ascii?Q?NqKHG7UaKQWZyeBZyQfBIsjPyUyencFjMlspr62r8vFKgFk3sU6aQLN0qUlE?=
 =?us-ascii?Q?M4yAetAEPmFIhOGrwdZTuQvztBh1ZdJ5ukQ/xGrb5YIgFO6RME131JnFS9Zy?=
 =?us-ascii?Q?R0ua/ID7u5905OuxzEajw5H23848qowk0/UQ54K7NydvVGjwQkIyJa7yu+/v?=
 =?us-ascii?Q?vHNSPUlOdd4KWajTWA18gAxB2w/uNCOk4VgKV4+5E+kgouAwiq+LJ4hzri47?=
 =?us-ascii?Q?2KVZgnwmLeUXm5bD0IPM5JfnoRNb/wQjIibt8TutQdVvZzUI7IkoBQpNdCi0?=
 =?us-ascii?Q?WdqHZp1q3CeQoOEG1emDAkoH/S3nOJMF+Aa58Qk8U6KARdCVg6Hp2TjyU616?=
 =?us-ascii?Q?4YlfM2EflebLH3yistGG6H6CWezzpVQKFWAqfKAt3Y31b6l6QPSwVaRi0O/a?=
 =?us-ascii?Q?HunqhV07xcIB6RVQNqyTpU1YD1vkSV1ivaFGfKSqcE8P1SQHCaA7GX5zKD3E?=
 =?us-ascii?Q?5WIlXwGUKpKebF1C7rN//+0081vG51gkRzxjRZ3CrxwitLBFSU5jU2jMPxcn?=
 =?us-ascii?Q?6vm8UsGUVlhqEan0S7nJvvqVea/lF+zX2lUER3fVoqefD6yFbBjI4EuBzIvr?=
 =?us-ascii?Q?oUOAypnIkhD2wtjOgPz+hoqhkQkQUCH62p6HpDd1nKDsxuvfpCxFx9MPoC4N?=
 =?us-ascii?Q?MfRr8u9F4jwsCsac2zJxgWaJEUgPEoFip15gtHS+ghAaKtLsf8nhgYX+NyS0?=
 =?us-ascii?Q?0Bo9DOP9RnG2CtzDpyNtO9UoA9xW2nHM88jeKaSRGjsu00e/r9NBqHmJ8BBG?=
 =?us-ascii?Q?HheUo30RzLOA1vONUwqDy92PLfNgrUmUKazYEOj8p2YQyOzxyYMPHynUb2Jl?=
 =?us-ascii?Q?8575TUfz/OBpCO53wROvFuVI1tIzRq6gUiJo09dCXiP93XrVMI8+Gun2FagW?=
 =?us-ascii?Q?WidP4B1+q1BTAhiv+DUm3MT5c37o81TYSW9VWVPrDMp65ehAQG/7Lm19UsyG?=
 =?us-ascii?Q?jbUBG0zCpGJBTwgRNXFEUsgzhvC9T8QYm88ilvtxXUU9/gBCMu+j6eEl2yF6?=
 =?us-ascii?Q?z3N9ruMIR6GcDxK3zHvY+ZW4+0UoCtOLUKN7mzzNe4KTeSC0TLYUfW5dSS2X?=
 =?us-ascii?Q?K8d6h+M+XdjhhwyfxNLcO9iHf5vj8l4J0TJGjZVO1S3hq460zOc+JqBTgOKK?=
 =?us-ascii?Q?OPkBBNve5aEGTYst+gXSppQdn2lftQxwHaeRf0esITFN7RGM1ehFHD+c9ER3?=
 =?us-ascii?Q?J1oy3OBp3arIfz5klAZo6mpC2Pvz+mnewGFaYsQ7RN5n8FLVqygbfaiScLWp?=
 =?us-ascii?Q?o8NDEPrFBRqathSQDFYSyAUoYemEnQvUFMbVwSkoR8gKwpKlXh+P+VBozDhL?=
 =?us-ascii?Q?mTMwJgTjl9g0J9Ifmka/1r7clZygCI1fUfy4ADV6qQIepdlsVyw5SPf+kYU1?=
 =?us-ascii?Q?J10efGTP6Vqv84S2/+2lJFaNRDOcJlwCO0WdwA9llJ8l6pGJXST4CJY7kvrm?=
 =?us-ascii?Q?PksVikuuFg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c18c30c6-ba1a-433c-c2de-08da10b5a759
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 12:22:41.2117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cBCWE12KV/5WZKOdR5QZgP1EGQdU+XZTMNGHhLzWp2X7UuBIcdyiGoMD75zVPIMG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0012
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022 at 09:53:27AM +0800, Jason Wang wrote:
> To me, it looks more easier to not answer this question by letting
> userspace know about the change,

That is not backwards compatbile, so I don't think it helps unless we
say if you open /dev/vfio/vfio you get old behavior and if you open
/dev/iommu you get new...

Nor does it answer if I can fix RDMA or not :\

So we really do need to know what exactly is the situation here.

Jason

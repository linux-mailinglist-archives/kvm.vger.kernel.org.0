Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C85729D0F
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 16:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241535AbjFIOi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 10:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241522AbjFIOiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 10:38:22 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2060.outbound.protection.outlook.com [40.107.101.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC7F1BFF;
        Fri,  9 Jun 2023 07:38:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1Ff2fOD8FS8lXdW6uyqLtNW28z15TrGIUp7hCEh77QoZfxk3A2QAzNjBWE3lMfeXaL8jLsx/a3IY3XHlkcNWGhaUeAsBBEIqg/AXRQjr8+L/NG3DTb3jiEnuG4gfe0xgU8jCBgUiZE+b2hGqZ+RckgLR2NPUCvBTJIrzIIVRPMdT6Ur4vzwFz5w7/EMWfdM+7oGsm9FvyMuIUEGqEEV9NhydKLs/IGP3V4PsqVwvNVWzC8kjmSkNmaOndzU2IuxY1OcAigiub09wm3BrLwLdRexADtji8F1N7SpV8aDPFpT0L4SKVp7+1Qk8t7pMY9j6Kmc/MFu/vSyffCNJTpR7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pjbHLKYRVU+/wLcoIIbQm+61mg+/cl/Nd+M1lVWyetk=;
 b=U3X26hXpIKsr5Nr66JcQ7pbdpT5K9eyHFckQ3CsVRWNOptf+dz/OysGvhzXUVEQPRa2jLf6flB2p3DAP/W/SgndmK2sZqjcRhwdH0WQr0NO2vrB+0CksBGNr4dPidHX0ZNC6FVWgcaHzNPyZDWCfGDkpUCLyiROs0idYGYkiLXQ1gKEInYFABrDJTo5fs9DkP+OfUhHZRG8XF0i38z0qr0LYrdQ09sY0fxHo7LcUj+vPb7ZhyJaJAsYN2SQsAFBKXtu2PNvsrvdbwWvrlxHnzq6rAkVbHPtdlDEWyKMAKIYSYfQufl/VWPOEywM/8MGAkM8b383pR6jWz0G4kvU5wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjbHLKYRVU+/wLcoIIbQm+61mg+/cl/Nd+M1lVWyetk=;
 b=aMLBFzFikVtoJxZSxUSJc7Expe7fP8iqln6LLiPXG051gi8uaI/JVKjDqh0CaIzEWQglilQfO598gXCIQjeHYPPlwDicy1CxJs2ZtKvmsCz6FkjT+Qs2Jvh3zMsa40ZMIl1Vr+B+jl5q73eA3m/o48xmz9vatCKvm8LcdHuWGbAJcKekmuIhQC6PaliLIYVUhRX2+C+8xij7GwO0uLnzKo2R1TqeWKCaxwTnSTNnZd7OLDLmCKXSF/oLcnPqnPcxtJq+vaC3GQggKwmZ+jy4sWcBtLmpRyKU7oOtql0/fnY/YIXLDmNSqpdfGDim/o4NpIbJJnlLJl+5CDZ6JDPfbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5155.namprd12.prod.outlook.com (2603:10b6:610:ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Fri, 9 Jun
 2023 14:38:19 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 14:38:19 +0000
Date:   Fri, 9 Jun 2023 11:38:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v7 9/9] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZIM5WTWhWi7jjd6U@nvidia.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-10-yi.l.liu@intel.com>
 <20230608163018.70bf3345.alex.williamson@redhat.com>
 <DS0PR11MB7529919796EF251B6D65D26BC351A@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529919796EF251B6D65D26BC351A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: SJ2PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:a03:505::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5155:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d6c9029-592e-4312-efea-08db68f72b1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e58PhGawH5MiDVCvW8ikt+CIBDfwwcodosfudGkSstdWqK4eqmB0pk0CrwY+7ivby2RxKYUtW6SFI57W/CtcNj2fRm/KZmBnTc5eLRy/YrwcL1UebOM19X407UprYMIKNUIP+gor/7Ft//kWo2Xr1IjuWJi+IuwNiQqDTHhWbztatRi3Q+GltR3IVTeYlrEEzSaLpIJpA7jEx4AIYqTm015fUUMmidQ84j2ePTpnFlNcA24uLWgLKMK0k8nJmc11NgtLbL1XT/eBP1EpxcyOo8rikTDqbS5GOEBwW47uZtOqL7Ua3R6zqJm2Hz3+JFuSF9VuHz9LfHEW3seh21VALiJdcA57KKKUeyvuGOslx5uB9E6z0Ve3t3TMavMNrUm6LwLsuukqnSUuoPq5xP+Kg5A4fym3VMS+6FU6LUbPaioYVXBiJbIxM8WXUj07LTqP+IeVhc15quBELfrJ/hl+pz663IwXWGdjVDpDhTOhQjUgw6d5Dlc+pYUnlsUy7h1F5Yia27/KZ51678W8Y+Bijx+c57t92zmNPk8HHp0OGXj2uQ4rTdBXz2gtNTYyEc2W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(2616005)(186003)(6506007)(6512007)(26005)(86362001)(4326008)(66946007)(316002)(41300700001)(5660300002)(4744005)(2906002)(7416002)(6916009)(66476007)(66556008)(38100700002)(54906003)(478600001)(36756003)(8676002)(8936002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H5ptZhP3Olbzx82Lhk1G8OMnML64MWT9k/s1lnmubS9V6NRpp75U1bBlhGDv?=
 =?us-ascii?Q?MPx/CPomzOaaR+JE+3CBAi4hdU9ICwCjk5dHPik6gedu8oUSEqvm0FsqyhEE?=
 =?us-ascii?Q?OfFEirY5Wvm7Zg3DHIC+pc2fJETgUe2tAMqVYwmuUYRce8T62+oJ8MhhWwSF?=
 =?us-ascii?Q?QVQPiDb+yRxtTGk/c6YJZeDFy8c0ylZm6LJt1Kd9VjTCl0Ik+qntgHTxjvv2?=
 =?us-ascii?Q?Ch/fvvxTOC7jGpfVL3Gz5mW5IECMinYGTkDzTn35WVlxqPS9dkWFZu/QQrFs?=
 =?us-ascii?Q?EpH5taGpWjwEcZVKC1487Uw/SJ8IxIgiR7TmyijWAHZb9nOE6JuhHb1qiJ+U?=
 =?us-ascii?Q?rbYNw0sgFjlfb4IEh7wF27DkWX3W6p/u0x0tyCUsrS3h5iwRlICDT/PbAs+h?=
 =?us-ascii?Q?ctqEto1/StaJFOBqt2YD3J3fR/enag53XfRf0bEbNk6tnMDBoalWyX8MSjJt?=
 =?us-ascii?Q?k0Bn60XF/pB/hEvF4NwgiTx2rxRqv0mPQcr0tz7555CaFpiTkFAbCGRaTHzc?=
 =?us-ascii?Q?kGMMPCSFoqNNPIlj6Dz4915fqnNpwuXay4XqUk2B3OHyMh9yEiTIl2kj/IWe?=
 =?us-ascii?Q?6gq2B14y5eW8JtSy7gD1sxgTU6GbF2o94Ph5rxmHdBLhUAr23scNdsgMD4Bb?=
 =?us-ascii?Q?k+Dps4ii7UPm7OxzSI19VGqsRwAcpbP9ofVx5fjV2cg+FB29btA/ZXdXlXka?=
 =?us-ascii?Q?o/PRCfHJUlDvpf+cebCOWb2QA1iTEX/oV1skTD7DktZIjN/+uFPci1h3RqdR?=
 =?us-ascii?Q?ARqoj5+cV6uiGaW4y4m3/XzY4Aee6dceg1Wg/keonfpV7c0I7/F17HUcCt29?=
 =?us-ascii?Q?TwOM+p7Nro1Dqv7JSBsR+AT5Uz6fBVWC6H3gtQE3nGOMoVKJzaTNiOqCerzl?=
 =?us-ascii?Q?7HrZTCcYnwhv3Ma+ftw9k2Wo1nor9qtdfDZWvZjZuk+LkbjYll2KnMNNTGj9?=
 =?us-ascii?Q?wZdt9oWHwOsIIFfbfJ8B7/jqZVRy874qLpR+wJa4Ot0dTTUocUBNa6c+nGwi?=
 =?us-ascii?Q?iranx/y+F2hFHYBoWgZwS4jwqNyE0eQaW3OPETTR5BdFnw7Ym7fB0sru3Z5L?=
 =?us-ascii?Q?cHCPt4fJKvs340GIa2oNxuM3XQ8k0Z5rB7vgl1O9si5d4EWxz1cI1iV26cHC?=
 =?us-ascii?Q?oe2RxKy73rSKRsz1PwmHYq46dBSIlMn8Cq8qlCtpqorHxkEvdVQPXLaio0pt?=
 =?us-ascii?Q?/wdcfUOVOILmyC13WgDak7E9bceiinvxWdXVz4+gy50T7hsjTc5npIM7JpIn?=
 =?us-ascii?Q?5KkURrJR+o8/adP0WC6qEzc7itQnUbR2L7SLnOJsrEzckmmr6Tk5tpShhOg8?=
 =?us-ascii?Q?khzn7zhIeWwiAczDVB3vkXjmfBeHOZTlL/Au46u+MU1/K6Yi1p/tL0dkQuvY?=
 =?us-ascii?Q?IA/kSoTcg5zYyL7Wi3TtecWIaeq831Rc8wxUYfFRmKAjVop8h6WzFCXhcep3?=
 =?us-ascii?Q?EA3IZc6FNEF6fGEE3r9N2MoCrFGxkfBcEiZxhI3gf/1brjZkQpmdplsiumO4?=
 =?us-ascii?Q?59RJz6OxwJqMENwoPvAYJ39wjbDkp5N0aQkPDsAs1E1ejBpEvucogxyRIw0y?=
 =?us-ascii?Q?3UyvZJqfI5aSLkVxkoVoqyxW49Y16341ImvcVeXn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6c9029-592e-4312-efea-08db68f72b1f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 14:38:19.4273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XE37SwTF/S03TuHKchoCkOdm36Rx5tb/6JZ9i1OJeHWElTd/F0wHRS0qgSC5WXkX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5155
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

On Fri, Jun 09, 2023 at 12:13:58AM +0000, Liu, Yi L wrote:

> > Other than this and the couple other comments, the series looks ok to
> > me.  We still need acks from Jason for iommufd on 3-5.  Thanks,
> 
> Thanks, perhaps one more version after getting feedback from Jason.

Yes, perhaps today I can reach it

Jason

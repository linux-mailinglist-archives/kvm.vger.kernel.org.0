Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2583D6C34C4
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 15:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjCUOvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 10:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjCUOv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 10:51:29 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4113C1D;
        Tue, 21 Mar 2023 07:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679410287; x=1710946287;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vemOf1fyGFW4s6CiIfO9t628S18BLnHeG/R08ujKgYw=;
  b=hAxc/9HsowJGJ/rmWqlTZQN+yPyn8owClS0k1H8eVZf2TdwbsEOalj8X
   4ga2fe3KaO906GVrxREK3/bKwztU+5c0qIAVcJffUsQD9XcCwuDua6T94
   BMyq6O6UaIPX7nyzL/arVua9NczkPEpBZyeG2HMkTiOgwM+vjAXrdjr75
   OW3vnxjfksw3FBldbxZRfVJQboJpA/9XcU7woR2WN1ZzjuLzNL9CiW1xt
   7g9wGCdW+ym03DKB/C0FI6nhihwP6c3t9LFbfUtL3In7aQZC76207hS7I
   k6/iXPrnEK3lLGG6+CzF2VJuaqvkgcVNBLzauWrqhkT/BlRlEQ/qjIOfG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="401527433"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="401527433"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 07:51:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="750587482"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="750587482"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 21 Mar 2023 07:51:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 07:51:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 07:51:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 07:51:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJuE/nLZypNLPTSw9r/Y23ePn+8TMrtzL9dwB7xMyrrHQSrO9vUE1lYfSo5xFRptwyVv4eb/sXa/s8tU5qCXvKhB0rADbSI1wsm/Iai+8F5VNMwOW3sODfGYxcTaBmtrtfmNhn6pSkjsECjiVRzRMztn5BFgWDNQhbT5Nmd6sUfhF1rFsKprrU9dUoXvaq2ISjoo7CgfKZBq0qjIA7YcHRxnMXic2cf6UuEg+ZVNGmxmfelxLJ7lnbeb3vqZxswpM8HhyHLy/ZiCwsLsZMl6/K/spbFlHqsvaZgTiMPGUL3EPUpCcUH0J83K26SyikY5MTRf7ksVofLVRTp+lBdASQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D5/o/Died0E4G2v3ZgqKFmQyeugKNN93FFOpiXgBvdY=;
 b=SsWy1M/KX34+0i0PJX2SzE1GYiIFEXPo5QtxemHAdQIR5VT07jojiOuAJUdCe2ag3K+QCjrIfVVH2R2lKI3Ui/vi87EAx2mJzu+XRbiU7TmdDwla8HYgg3FDi9EZhCGIxfGeCc/Xa4TKMRe+tVZXL9/rvF4B3r4EK6s+5waC9wLFpvDJc1ET/Np3AOTE3iEKgMQilUmk4P1Ne1NV7e8+qtjI3D/mBwjZPgXsdXdMlr5qQ9poqU6qs/hAEN5TPZWFd+IYVzGENFvRZVQq0Vt5iqoOZcCuGQzRyjexaZDuyFQ5iB6VneJY4UIRCcJv80ai4Nryt7yaoboiL/PAfAJCGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ1PR11MB6299.namprd11.prod.outlook.com (2603:10b6:a03:456::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 14:51:23 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 14:51:21 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZUcIP+SZa7TzGK02S6HlHFxIIra7zumiAgAAAm6CAABGNAIAHfd5ggAh9XYCAAAYegIAALgEAgACKCACAALARAIAAKW1AgAADXQCAAACcEA==
Date:   Tue, 21 Mar 2023 14:51:20 +0000
Message-ID: <DS0PR11MB752959B246705258EEC4109AC3819@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <BN9PR11MB527665CA5753E413CB4291AE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529B3BFD999C9720836F049C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276684B2C0CD076FA3CD0938CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBhpNyrBr9nm5Ae+@nvidia.com>
 <9875e60c-68a7-b360-9d52-66d4915808a0@intel.com>
 <ZBiU8KoSmiM+JkAw@nvidia.com>
 <BN9PR11MB527605E6609222431DFB8AA58C819@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBmcbMuE4lyDIpT6@nvidia.com>
 <DS0PR11MB7529569D40415AA283E1EA55C3819@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBnB/mOIvzYEPdsj@nvidia.com>
In-Reply-To: <ZBnB/mOIvzYEPdsj@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ1PR11MB6299:EE_
x-ms-office365-filtering-correlation-id: 43cc66cd-f925-4213-c4b6-08db2a1bbbfc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PnEM6Y6njxpKgB6VEDHiOQwgaNWzdv6kFpAS24mMEbPfJzwj3dLKEEWSV5vv+wMdAYs17eXXOVQ92a4huQIFBF4W8lI2ksGbgPSecVKRaigNVr54AJ2MldzDm/s62SmT51QkSo1Qhr1bMbZhBIcXEFUWO0Xxx3j6BsgswtytLJk4q7mpNmISSo1qvkT40mKT452768S0jVQ+KqPA/MBu6fEe/3N147sHAx2M6oZDDSRbY9gUrA/pM/k6L+V7kdN6Hsf8rgX+ISuzkEHz0Qzqojlb8M/VzgKfDbR8oR8TS4Xpx2L/yjXv6rpbrx2RAolNQi+dK1kQ97BGp9K/y7/eNrgOR4SJs+dPEN1zDpjpeDH3ccaupHsM6jf0est9IASGTE2VnFzle7pbjOmnx01QFnaWusvUe4l8aPIy44A5hTxDg4z6RIEQ/JjA4gQrpw2xAegfhYAIZ3RPU9kpKu6jVoy3mWKEw8Wtsn0FzyPui9bPX0SsLPUbkA+E0bP6Q06eOdL70JoMyzmDXiu2qv3mbIUFatEoucP7SzyvUsCZue4lZH8iKfJcytRQx6+5eToIpDEHy2MvJrkPzawg7N7DdENWwBjIBPEQJ/I/3p8gQIYEoGyZ+zdaumMaAlbYKX6gr3rvkoNkNK0wiGSnE9IphiHoUm7oI+9QLffrMzDE2FX0qmADFVZkFTv3qIst91Ji1JXu0/h6wg9KJ/jMXIERMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(396003)(366004)(136003)(39860400002)(451199018)(86362001)(54906003)(478600001)(83380400001)(316002)(52536014)(122000001)(41300700001)(6506007)(5660300002)(7416002)(186003)(53546011)(38070700005)(2906002)(26005)(8676002)(66946007)(6916009)(76116006)(66556008)(4326008)(66446008)(7696005)(33656002)(9686003)(82960400001)(55016003)(66476007)(8936002)(71200400001)(64756008)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8MpA++4me1ZjNDERdUhDWUtrPQKSPgz6nwjkV0HCc3T8pjj274xKkYFwC/uW?=
 =?us-ascii?Q?3OBr8+DNbrMgD6w7U8ui/YHiYvu8EO7riFW7Nf/J5Cd0Nua0/TDpEY424qSi?=
 =?us-ascii?Q?tuDsUq4F/mveVZ64kFkiMyzXe1WzeICVHDRdyiPAtaA9fekojHVdO/ZwtksD?=
 =?us-ascii?Q?en4oFCKY6I3IOdSirs7KTnxlx+vNC+5EQyGYzpB1nPscv1zlNBF05E6aYVT5?=
 =?us-ascii?Q?/c+7RUkfMCMprrpG2B8fuUORUUZnZdTluTBzQes7Jm0VoKWEjp3Hcl5/CmAY?=
 =?us-ascii?Q?f1cv7uUGCqHKxPDl0Vt7LhzA5cIKWYa76I48/LACfTQuPZfELWrpOZ0l+dIc?=
 =?us-ascii?Q?LKCEOaH+sP/RSGf4w4PHMRARHLezW3YFiQ4yB0Pt7riVj3Rl8cXnDAWrLFBg?=
 =?us-ascii?Q?uGDIpBrrlHys8dNLoMAclwH2xqP2cpVpUVIJpz0m3Z2SeZSRyZfBm1d2bV5w?=
 =?us-ascii?Q?+kkizsky/PE39+ZB7V94PS0WT8RPp7v0ZjL4mas2OBNfyxPJzzUQG09tfqXz?=
 =?us-ascii?Q?nIK30svZtqov8gbzcgOJE8kp/2y15GKgridP3f212Z+sdHBkBq779o6niO0w?=
 =?us-ascii?Q?xkfrqJ2uiEBSNiG0LmQ2RLDRWm7yYFsRak60Dt5+HEWwb175vEn0uooGaZDT?=
 =?us-ascii?Q?Sdu/md4Y93J8D5R6dFDMPwTlsq16HfgY9ZnRcT+If4GZ4Xj7sOJWXlUtJbKp?=
 =?us-ascii?Q?/Co2bGp0aaieAMlwF2oerg9uU2HQ0zYuct8HnhuMCKic+ryLd2f8xaGRV4oH?=
 =?us-ascii?Q?/BDbpSWJBccdkdG/1k77qCnAYX1rV1aCdQ32NIY4QBx5rDMTNuscbnbA0Pd4?=
 =?us-ascii?Q?8sAdY1V2Knm4qF+7p3xAWtJhGjpZhYw5uDbX97hJ0pciXfVMf8Cd5g+56wZb?=
 =?us-ascii?Q?Xt9V738Prjxch4oYt5LsAR7MxpkxmPnIGbIt7fU5BVC1Uz4tq6JP8q1tJqfw?=
 =?us-ascii?Q?IkWY7ahTYHx9ONoMSwQfotVKxVFlf7xml8WRUWLq8WuIfi9MaYac3cfvHz0g?=
 =?us-ascii?Q?flodYOtHlfj3JsbfR346PlZ43TvfRgB9HUjbYH82qf7/rrhKqFwrEGnKJqKS?=
 =?us-ascii?Q?/179k6jluScXBJ7WA6GtwledPl9Upo9EfYL58ridg8VFsMILVrNL9BmQWmAu?=
 =?us-ascii?Q?o2CNd8/glySBWATl+DerJ3JLB88DuBrBmnnSF7lUMRynVJfq8ulPoXXox+b9?=
 =?us-ascii?Q?1VznZDwYt572EsFaiJ0JwGENfBweScARs+mf7LUfadAr3JByHCLgEwdZmIaf?=
 =?us-ascii?Q?cBTRpXxLKoGhnZqfEf746Yl4MSMM2+qP5PcsWlEWmaDpV4/XUn5TTOcAQJvJ?=
 =?us-ascii?Q?cSn0yz/giK+rsuXbYJt9a89Y2f3zPWWStJHIuip4FTH7BWs8OWQtvji7Ggkr?=
 =?us-ascii?Q?86WkiknOy4GsrS9ppPAy7Yvhuo3V7p/GKz45V4t8wppCbBJBuANJTixr4xPP?=
 =?us-ascii?Q?2Op8S3QnxpM8/AoETIrw9u37zYsmKmxnrSyIVOOUyCnqTCRScxxdbZm+byK8?=
 =?us-ascii?Q?sjBndijRogySiDEGbxrbIvqLLRHH30dxf0g7L67NNArUXLuSZqQSPLzf/UzI?=
 =?us-ascii?Q?UzLvtvchlAuKb0mmPISL1efHp+Cs6ogfff7xPojZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43cc66cd-f925-4213-c4b6-08db2a1bbbfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 14:51:20.8820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mNwcJe52OJg1Ditp8L4ikyzI7q721C7FZAzn1fG6f0N4bpgdgUCL6Z8WfrHGwXgPWfiaPkBHkJ1F9XLEK82WAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6299
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, March 21, 2023 10:41 PM
>=20
> On Tue, Mar 21, 2023 at 02:37:58PM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, March 21, 2023 8:01 PM
> > >
> > > On Tue, Mar 21, 2023 at 01:30:34AM +0000, Tian, Kevin wrote:
> > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Sent: Tuesday, March 21, 2023 1:17 AM
> > > > >
> > > > > On Mon, Mar 20, 2023 at 10:31:53PM +0800, Yi Liu wrote:
> > > > > > On 2023/3/20 22:09, Jason Gunthorpe wrote:
> > > > > > > On Wed, Mar 15, 2023 at 04:40:19AM +0000, Liu, Yi L wrote:
> > > > > > >
> > > > > > > > # if IS_ENABLED(CONFIG_VFIO_GROUP)
> > > > > > > > static inline bool vfio_device_is_noiommu(struct vfio_devic=
e
> > > *vdev)
> > > > > > > > {
> > > > > > > >          return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > > > > > > >                 vdev->group->type =3D=3D VFIO_NO_IOMMU;
> > > > > > > > }
> > > > > > > > #else
> > > > > > > > static inline bool vfio_device_is_noiommu(struct vfio_devic=
e
> > > *vdev)
> > > > > > > > {
> > > > > > > >          struct iommu_group *iommu_group;
> > > > > > > >
> > > > > > > >          if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU)
> > > || !vfio_noiommu)
> > > > > > > >                  return -EINVAL;
> > > > > > > >
> > > > > > > >          iommu_group =3D iommu_group_get(vdev->dev);
> > > > > > > >          if (iommu_group)
> > > > > > > >                  iommu_group_put(iommu_group);
> > > > > > > >
> > > > > > > >          return !iommu_group;
> > > > > > >
> > > > > > > If we don't have VFIO_GROUP then no-iommu is signaled by a
> NULL
> > > > > > > iommu_ctx pointer in the vdev, don't mess with groups
> > > > > >
> > > > > > yes, NULL iommufd_ctx pointer would be set in vdev and passed
> to
> > > the
> > > > > > vfio_device_open(). But here, we want to use this helper to che=
ck
> if
> > > > > > user can use noiommu mode. This is before calling
> vfio_device_open().
> > > > > > e.g. if the device is protected by iommu, then user cannot use
> > > noiommu
> > > > > > mode on it.
> > > > >
> > > > > Why not allow it?
> > > > >
> > > > > If the admin has enabled this mode we may as well let it be used.
> > > > >
> > > > > You explicitly ask for no-iommu mode by passing -1 for the iommuf=
d
> > > > > parameter. If the module parameter says it is allowed then that i=
s all
> > > > > you need.
> > > > >
> > > >
> > > > IMHO we should disallow noiommu on a device which already has
> > > > a iommu group. This is how noiommu works with vfio group. I don't
> > > > think it's a good idea to further relax it in cdev.
> > >
> > > This isn't the same thing, this will trigger for mdevs and stuff that
> > > should not be noiommu as well.
> >
> > But the group path does disallow noiommu usage if the device has
> > a real iommu_group (the one created by VFIO code is not real). Would
> > it be better to keep it consistent from this angle?
> >
> > > If you want to copy what the group code does then noiommu needs to
> be
> > > statically determined at physical vfio device allocation time.
> >
> > There is another reason which may not that strong. For devices protecte=
d
> > by iommu, user needs to program IOVA mappings in order to do DMA.
> Such
> > device has a real iommu_group.
>=20
> Oh that is a good reason for sure
>=20
> But still, this check should be done at device creation time just like
> in group mode, not during each attach call.

Seems like requiring a noiommu_capable flag in vfio_device. We
set this flag only when the vfio_group->type=3D=3DVFIO_NO_IOMMU
or no real iommu_group (for the case in which vfio group code is
compiled out). Perhaps the below check should be added as well.
Then in the time of bind, just check the noiommu_capable flag
and capable(CAP_SYS_RAWIO).

if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)

Regards,
Yi Liu

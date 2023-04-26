Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6706EEF46
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 09:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbjDZHXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 03:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239597AbjDZHXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 03:23:08 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEED30EB;
        Wed, 26 Apr 2023 00:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682493760; x=1714029760;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yi1a9EsM7a/1yw+tvFfhhmzxMOz5qxjfooQGpdza1zU=;
  b=EQK68MgRJqEsu1jqwhpUBCz9VwbVIeniVChe+vQru2EKwDOaHfJ5ga6r
   ImJr0l+t0AAZFXlBXKIA32Ocsw3LG/7cL5SERpLTaQzHhIPxE76J1nV+L
   6BdrrsgN0KURG4S9utBaQepY+1HlD20oLAx6xspyXaQA8JcOFrmwvGN7w
   8hMFuiOe9SYNxHVTq02gnzvoyY6MGiJYW8MrD9E/ZcwqKSBJXm1eWWQ+t
   9MStAO/6or2C/hCHNDXpEReSCuSeH+tuHvfUG6dmgGcUWj5QRxFw9UJcq
   GdNTrsHsZfEGMyRg+1b8yxfG90DZaMsZV9xf4nXe99U/cClHACEemupyO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="412331754"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="412331754"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 00:22:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="696497868"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="696497868"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 26 Apr 2023 00:22:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 00:22:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 00:22:25 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 00:22:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyrHcNToNIqqEc4OKsjKn+ln271ey1g3kkg5V+EFmJAUXrlAaEcN8vHBuiB/M68A5IyvEfz0wcWRKCvFgzw/P6MACi9RyhpHd8SDZwefcwEHhb/Uf9YTfTwaRIHCKtEf9Fjnm4Kn40pVraTcu6T/4xsPFjnDoqvH/kcJ5Hcdj3lm8FSEk2hlPwWSUmR0SQ/PY+RHKDPY+DQ8IndkBAtmMsaP3a9/WU2K29Cms0nBlAtW8Mh3YfzHhupCvBJQYizeR/hqSJQ+K3xnufXNSFhbIRqqRrCLdOyXSpM/8WUzEk/juUeeZZu3nSjeRMlcsAKfK/REmvrgxZg7EEwG4O5yzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CiyIQiUvHCcJ5rnSrtNPp8sKX/1629lnWjQ96g+g91o=;
 b=lEwe3++NCjTJ6EU1HhT8WUy/L2s3UPaYZn5fJTBnfwcMUYxYr4yve0W1hu9LKkSdQO7cSvjMWzeu1dJltr15ZODftC/o5ufu2oUys8d10i2cSchAzXSyngjesMNDCreChptod/S8GJDz3VALF9eob3kpweDI3yQI+sqbRUMSocdKb/3MXpHrS/2R1Mfi6PT/xD6dEL5K7n/EkdLBZf8AFORMeMljb19uGILTfZZSNgei194HHv0JDcknFdlJAQor2hCWQ4JO3DRfMaFIKX88jxiZSYE7OPiB5zVJFD1e0UxHfmx3egVtyAPePrbXzyFiD+pEycbp/ACNrkM8NybLCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY5PR11MB6317.namprd11.prod.outlook.com (2603:10b6:930:3f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Wed, 26 Apr
 2023 07:22:18 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%5]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 07:22:18 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACaIeCAAJxQgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIABGhiAgAA2uYCAAM6MAIAAOT6AgABpLgCAAPyoAIAAA7kQgACCLICAA9TGQIABATgAgAAIdQCAAAm2AIABGm0AgABffwCAArUGYIAAJAOAgAj7bjA=
Date:   Wed, 26 Apr 2023 07:22:17 +0000
Message-ID: <DS0PR11MB75298CDC8108BA213243DBB8C3659@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDfslVwqk6JtPpyD@nvidia.com>
        <20230413120712.3b9bf42d.alex.williamson@redhat.com>
        <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230414111043.40c15dde.alex.williamson@redhat.com>
        <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230417130140.1b68082e.alex.williamson@redhat.com>
        <ZD2erN3nKbnyqei9@nvidia.com>
        <20230417140642.650fc165.alex.williamson@redhat.com>
        <ZD6TvA+9oI0v4vC2@nvidia.com>
        <20230418123920.5d92f402.alex.williamson@redhat.com>
        <DS0PR11MB7529C11E11F187D7BD88C18AC3639@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230420080839.652732dc.alex.williamson@redhat.com>
In-Reply-To: <20230420080839.652732dc.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CY5PR11MB6317:EE_
x-ms-office365-filtering-correlation-id: d1aa4def-ef46-4faf-1074-08db4626f769
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u3KrnVfSQVLuppNeKVzkZO2EyxRg8cXgWmsDrPaUczCEY66nF1I/OIUtVdCBiXGmL4Kfy6oKzxZF5r3o75w+3gsb/SsdopgkyP1GGtq399gyzDLZlltQmlRVZL0zuoxDs5YPAF0dUt5E/EX/TvTPOx34TRGn2IO5EXXtTkgMsBWx3Unu7VtYlOBbDOfdZJ32kUofFTXAwXDelPq0iCn9Z9Kg053s/mMUAOZ3FujsGwfxRWTS8nnHgYeoQxEatQcB3p3rF2ELplTrzlhXHQY6yW8bAbyY80HPRz3QF8Th3iCectnLSyCr11BPPYzu3XKFYyWHIMc5eAurgmY3IqFoW5VWlRLt0VHKJemWzxd3tmMDtE5wtGGS3QygqBtSAbd7OVXcYshKF08wnLWbmUzq+iTEbBVXEhBk05bwSqHWlg6Pv8s9P++xGN2hzMi4SfrlHL4ImNntDniLBVifB/drKxEh7MhEcQlU/vXIjYILSSoERA13p2dmaWwbttyeB37Fiqc2uAfhOyk0qFDku80fCbRmsPJEhEjLat/jRX7djBY+qget9KWQa6cIi9FcyA4vYC3nCJkNduKb01bGNkXFK2Ud3EZ8JH8Oe6rvIQNWMFDaig1ygijTYVlmnECmza2m
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199021)(86362001)(186003)(9686003)(6506007)(26005)(38100700002)(5660300002)(52536014)(7696005)(33656002)(83380400001)(71200400001)(478600001)(54906003)(38070700005)(7416002)(41300700001)(2906002)(8936002)(8676002)(82960400001)(316002)(66446008)(66946007)(64756008)(55016003)(66476007)(122000001)(76116006)(6916009)(66556008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pU7H86DDSRz3n8BKNlYgt+Il1fNQFaLH+tsDdJ2UEZ+olBwjhCi71+vU6AF3?=
 =?us-ascii?Q?QDXUVxm43mA25pisxg7Lwa5bF6iN6pXXee6hd/kuLeFuKBFFPWSz3tSoZQRV?=
 =?us-ascii?Q?zOdbNN73CJBwdxTz2StJeD/EQ+uVBDBrZZtzKhsLiPulXQumsOrUgbN0AmXy?=
 =?us-ascii?Q?PjyM/Da46FAYnWR2oIt6zzjI1eVDWjk4PWrSIhK9dpBDpKgBdtUJM9mMcKmU?=
 =?us-ascii?Q?ZbECz6Gt4g3EcAy30Ztsl5C/pe4Oj7dDqw7JXUNpYfqDgIBV9KYBJF7OC+w4?=
 =?us-ascii?Q?iRVcSsEOz0+OGVxPGpCroG8Tb3m5RoYQJpzOd5/uDqjB1EqqUUdMmKKItE+E?=
 =?us-ascii?Q?Ow92aN3wCxlThcLTcL00oEE9bwubxyb4ceKH1Wcquk66n1JKglvb7u8OEWOg?=
 =?us-ascii?Q?U7tiH0JtjUsebSQQqTBJHHLZxR0AXW54sBqZvKSq26axcx1wW4xya55U/6h6?=
 =?us-ascii?Q?uNo4wKN6/M1nRfWC/WiBq2KbHZsMDOw/Mm3WwFYDXIOTAqUJxdMCzSCJKYgF?=
 =?us-ascii?Q?QztBJjHK33ghIBncbgHcCzIFXC47vKkoD/K5wtYQnn2l5TUjVaGvlLdoc6y5?=
 =?us-ascii?Q?9ghFaR3ITFqezk8zRUAcN26ckLB/kupV1Q7i2qErZa03Cg1ro4vb0jN9QR6k?=
 =?us-ascii?Q?NRLfGfJwPrYrwkINBWnqHYekgtzfHZjLDj6xJ46DEgUBALxvFNZ+GQzVVR6x?=
 =?us-ascii?Q?/XA6EMg7G31LlG9+J+x7hdkDtFEuWQC6zRg+C5tI342OOk+BlBf+LTwjuvSg?=
 =?us-ascii?Q?kWExloHQdsUtfbdAMcYfJq+7OJgWaa2rzFs6DTrVmFZ8d/kspTxXD2znZ5mD?=
 =?us-ascii?Q?IgrfbMWdOY3ZmypLsPBBzdPzoicXqakbnzGubOzCx3FSCnFbjVE9QmveCkjd?=
 =?us-ascii?Q?nJQTlnOuGUm7ji9Up5a3X79gSUxNJhEph4FcTgQRXBXYtbsPguwwplwKtGYP?=
 =?us-ascii?Q?y/hoMjJEq3bH9wI6tnmR0BTcp1itG9JJ3DBqE8aal/W5oLLdkvfCIfN4zm0L?=
 =?us-ascii?Q?GVYZ3eXS/vlH+sjrdHcU0Gf+tLVDDYR2whi/Eq0s8Q8yrCCUem2Qc+IJotU0?=
 =?us-ascii?Q?eLoPWLZjL4n8nKetaTsQLmmOiZSqABsRDEMCGLj+Iveegg71mr61YIVrVSMv?=
 =?us-ascii?Q?wMXqbqe4Hu8ohSae2zpOjy186HE+HhcfeYJN8iMxbgCAzvKqN7xJn9AryKeM?=
 =?us-ascii?Q?ruQBn9bS9vpdZ5k5Be+gTUaWGczcdkrPOY6X8Ed3WTN1lfpzRZiFa+q1cEyN?=
 =?us-ascii?Q?g51D+coREN/g57BHzVb1ag65ozcDfv9htGXRhHNl+Tam2P+T4RWF7hBTDFAR?=
 =?us-ascii?Q?RTesEkMwzkVl6IhUOtyx86uKzpKiTlvoicteG3lP5dOCab7jjjc8pWnzN0Kn?=
 =?us-ascii?Q?EQCC5B/4AB5M0bKEncjhuS9ldlRKsfIgterCpA5iGvtP3mXz2JyGNUyZFW8N?=
 =?us-ascii?Q?v6jzuXrB1ycUQvIGrf9hKT0Y9SWi5mmTuCMTcRYUF9Tprm+jmRBFUc4zkYCr?=
 =?us-ascii?Q?iUCysBC3nd4L2TNFys8eGlftQH+TOe5GqgVM4t7B/Wm4F/f6zEk2flPcxBs+?=
 =?us-ascii?Q?UwiOtPHC8mf1bBrNkHlds73fqx7TE26ziJJMfBX2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1aa4def-ef46-4faf-1074-08db4626f769
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 07:22:17.6604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vQ05H6ZuX1WpLORv573iJMb7SiFBtfHbwWE5997Geoj+mzht96psdMq1hxhdnJRbpa1RTiMBq4DCLPNehDOgBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6317
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, April 20, 2023 10:09 PM
[...]
> > > Whereas dev-id < 0
> > > (=3D=3D -1) is an affected device which prevents hot-reset, ex. an un=
-owned
> > > device, device configured within a different iommufd_ctx, or device
> > > opened outside of the vfio cdev API."  Is that about right?  Thanks,
> >
> > Do you mean to have separate err-code for the three possibilities? As
> > the devid is generated by iommufd and it is u32. I'm not sure if we can
> > have such err-code definition without reserving some ids in iommufd.
>=20
> Yes, if we're going to report the full dev-set, I think we need at
> least two unique error codes or else the user has no way to determine
> the subset of invalid dev-ids which block the reset.  I think Jason is
> proposing the set of valid dev-ids are >0, a dev-id of zero indicates
> some form of non-blocking, while <0 (or maybe specifically -1)
> indicates a blocking device.  I was trying to get consensus on a formal
> definition of each of those error codes in my previous reply.  Thanks,

Seems like RESETTABLE flag is not needed if we report -1 for the devices
that block hotreset. Userspace can deduce if the calling device is resettab=
le
or not by checking if there is any -1 in the affected device list.

Regards,
Yi Liu

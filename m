Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CCD705CF4
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 04:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjEQCO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 22:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjEQCOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 22:14:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAB85B97;
        Tue, 16 May 2023 19:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684289635; x=1715825635;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SdiK8uiAxs1SbrF8+MydM7Of9kdiGdx3T9IVNNeI7hs=;
  b=eT4iixP9gAnRha+ijzeUruqZuEFLdGNfdLadr8nNClUE7pdhf7hkcXQ9
   hRdEGO4UiNpZ7PjlintHbUnmoRLWmklQP4ea3hSczS1gIDhyXc6N3L/Ue
   NNpSayjTf7Do8EoN/rCMfLxTR2fczPehQpnQviH11yJUbyulsA2/6CFD8
   PR7ulhX8RodS66d5lGhU8PM4kKiNppJkcKMUQOdIwQTuA4OsyW5TDmHcU
   ORXDdq5CrN9ptb0kNb/8fsMgfa9lTcAcNaNCd7b/YiEg6mrVEhpQcV+Cf
   mrc7RDHw1VrxC2xQlggSvygRmTCGCX/Ym082JTcFcvd+oH4XOy0V6+XEH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="354813710"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="354813710"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 19:13:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="791310865"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="791310865"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 16 May 2023 19:13:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 19:13:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 19:13:53 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 19:13:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFr+6JuN0uZ/CWKFqOsIM6zA1iMBXKs3L6ixQwdjt1SzYjzSUdfARuQ5Z/sNxZ9eOxw8u6pB2x3l14PQr6cxmt/o9izr8Ur6iYzDFuoLRvSg0fM/pb90umsc13Q0HtLaAdkXrXOzw1ymleQly5J0a540IhikxeV/6sG/IEtJTCjhjjYPqJNZf0UDTNbuNkwgIPJ4BtSoEy6z5pQUFuZ6DcVkKGde1Gsdj2rOMEr3lDzuGp/soPCD6WvCabBQQ/u5moojiocgn6OVeOMTGM0rKlv3sjWCAXTyb6sBiOHDURuUMo0GOvRqAzn6G5joH1wL/ER6Ep2rDtTf3xrFMbHokA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SdiK8uiAxs1SbrF8+MydM7Of9kdiGdx3T9IVNNeI7hs=;
 b=JhorYoIZRpUjdwJ1Qf5q8dCg3OaHZqHLXCMopXVJV9Vcmvmo2Ajbly7VhK821nVr+w3+ICgBlmhiuSDcY8is280kDb/h5wcI1CxBLpUUCUrF+PiHDA3tkj48ViPhVUGLJl8axKgyVhYpAg4pfmYrYRcEvfPy40EiHNeOzr9r4RNLLJ7bn/Wmy9iRYltHJwMaMLOdOkgDr+epFlG+5aeyrAQpC8DxPsgnK/nFjx4Ime9dt0TC6fm4hoQIResyvY4Nq0uzm5r/lV2APmYJYUMA5gr8VA3SXSF1y2+czh5/Jq1gnyzXmU6pZ8W0W/wcg4+LPd/Pr5sFR0poly2S/ThNLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7568.namprd11.prod.outlook.com (2603:10b6:806:34e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.29; Wed, 17 May
 2023 02:13:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 02:13:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V5 10/11] vfio/pci: Support dynamic MSI-X
Thread-Topic: [PATCH V5 10/11] vfio/pci: Support dynamic MSI-X
Thread-Index: AQHZhB+IeU7mj6qlzE+Lk1dIkXBe369dwiZw
Date:   Wed, 17 May 2023 02:13:52 +0000
Message-ID: <BN9PR11MB52769B2F4B45E354ED9E2B598C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1683740667.git.reinette.chatre@intel.com>
 <956c47057ae9fd45591feaa82e9ae20929889249.1683740667.git.reinette.chatre@intel.com>
In-Reply-To: <956c47057ae9fd45591feaa82e9ae20929889249.1683740667.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7568:EE_
x-ms-office365-filtering-correlation-id: 1722cb4b-d38c-482c-1a1c-08db567c5be1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yrEIKnUA0uw4v2l/aFgA7ggWs/u3sDVXyrnRnF9PR397j1km+L8vOV7DzXm2y9qjkgtFmWuEJb5+WO1MOnB6QPRxrI+i3ncNxyo/Yw+8+fIKK6d+nHXd1+cTwLrPCn8lWnvFVaJ/VzrekLa9z+clsQ/VClN8ePKT7zIPfZYaB8Xjbzr0L3VkdHAkjvHR1+AD0I6V42phkpAnFv8Y70IpzOtM6flY+719CV29t8ceZKulqKXVvldmjCMRyvKDdhr1t+QrNEBCHjqJB5bH790PBASfzaTPl6nUZQ94XPQvC7w8ECcBcVCWMBW01/YsxbIX7d5ZNUiwBVRJUwnOQ+EfiP94LCuYUhDyOF39sB+g+FCmpkYaQY9C17VhixxRgtlHVx8TKrlxANf2lniMDjjHm1bnZ2zxXfzsjC51OahGjrZ/maroScqFQdbRG20jTA0dCtmPe1fTmxemD6Q0hhktbvonXopmTHhlB9ijnB6UcPOF4BYyACqNAYoofEMRz/3r26ImcJITwl/kiCkCxZPgw+290mY3HGLsz3C2qbuIkbxKVTezCJZZ/biNvc4hGCXZ6FuQZyxC/OMuXJOUkD5fFR4xP65nzTM9K8tBdYIuGaQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(33656002)(966005)(316002)(86362001)(54906003)(110136005)(66946007)(76116006)(66446008)(66556008)(66476007)(4326008)(478600001)(64756008)(7696005)(55016003)(52536014)(8676002)(2906002)(5660300002)(8936002)(38070700005)(82960400001)(38100700002)(41300700001)(122000001)(6506007)(186003)(9686003)(26005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rp7cvXmtMje46Y6llcAVo8PQfMd//WXtYHFVOI6AJfWuEJ9flkF0wDfCAZLt?=
 =?us-ascii?Q?BmGit52rA28DJL4Xy5fxYuv9SsHMRuexYCKUg3GhA2M2Yr3++F+I2EVe9M5f?=
 =?us-ascii?Q?Xb+SaU+iIa2Liu2EAD9GIAeq8d6CZpOTA5/PPjVVW4K3wMSvm4dcDzn+d0HP?=
 =?us-ascii?Q?DjrVHzEEGFreMayKMNiGRR08IRBcOePX5yfJrtTniSkYSa4fHrNrwX33hA5T?=
 =?us-ascii?Q?BLCFTB86Pnm49nX4oG90QhmBbZlUek2CXrZ/R2mRu36Wi3MbncKlzDtn8n7T?=
 =?us-ascii?Q?OcyOcmrQ6zTM/3SmV8vJUJoSkQEv9YElhaW29jyRkkroRiO+Ofd8JV+CcqB6?=
 =?us-ascii?Q?zpPe1oqD2cPVb50udpbyAdCImyrb/1fbL7OHZLxp47OF8pWYUDLz0slenUFl?=
 =?us-ascii?Q?AkhCN4FKUc+mOdhARKPz29hGPKR+/A1nnra4EJ+WuzdOU/fenDT3hncmzKFT?=
 =?us-ascii?Q?Hp83VsCB3Rjm1CnfcHXKm8bZ2m6HzlU9RVpIj3IYII9VzKH3TXOI9mT1oVst?=
 =?us-ascii?Q?xzhpaSvVRfLhxq6dTVIa8mryLk6cVf9ekNN0ZST6KfxBx13oryYQdR4nrkch?=
 =?us-ascii?Q?3JjsoMW9Y2b099bs0WwiywBMZp2fkB3aushKV5Hbio4k3gM2/N8+1nnj5iqg?=
 =?us-ascii?Q?OUaFgebTslQFDA4oafXXdSVUW3rFRR6Vl7pgCJIX6rBis0j2GZT59/nOpCur?=
 =?us-ascii?Q?up76LIJ1DZoara0k7XK/PW5rwExe3Xps1Ct0ezucgXVBqeO72gfGBsLIn3iw?=
 =?us-ascii?Q?kS8zjAKQZrVK3BszJ8pZFblecjOF/W5s5Io2dbyNRC7CVhaaIfZZ5GlupwVg?=
 =?us-ascii?Q?M82Rp5fap3ETGCcqJUzWe6X/kIl21j6e8OVUtRhcHM3UbzKCai55H2FfeAV4?=
 =?us-ascii?Q?92VvyqlQzc6XQR2DRn21GSNkwRQz83pnG/j1sSr0n+Dm5bh5XJnOFa/m1cSC?=
 =?us-ascii?Q?ftMjuyOBuOMxDssd4bxl1yjUiyhn0yk0SG418RrxH/fQIazKX2Fu2xFJpa3X?=
 =?us-ascii?Q?G59mvki0aq+YqWzNBDsouhvt0qMh51BE9ktmwIdINReaxYYhkuElck6weLOO?=
 =?us-ascii?Q?ZBjqRn+iWgwdzWpOR6s8z65Mlpp9Mx9/N9bIN+qO5eplDUkYK7+SJoKlgLr0?=
 =?us-ascii?Q?uu+jgQY8Au5HnhXveT0espNvOHqAaDca6dqJwMSj3MjHla26sszUuRMQb+Uv?=
 =?us-ascii?Q?ze8O1JErdGxS/G1exGKmvcsVE+IMyouoIaT/TGI+rZXoT+lBhmmBIeahzey3?=
 =?us-ascii?Q?oohe3RdijIwfmP8WQBwHHIhK7jAEdUwNy2Rs1N3+hBaarEu6dlEgQUKwCeQy?=
 =?us-ascii?Q?JZbcFsI+WfDfYRBfdR0tbJAiUp4kpzzHiCVEBOKChkr5suia9yMzVdxLOU9A?=
 =?us-ascii?Q?Kd6Ym+x/TvGNzFnJR6st+cxJt+EEFbBd9YdWPRQUEGgpDbiVhSIoyDHtl7nt?=
 =?us-ascii?Q?kUrKmTlVmJXmO4aVgXfB/utmK4VSUHa/OzL0vJXdu8hhlhP7GMxYk8doSseI?=
 =?us-ascii?Q?+IJoxnwad9KNGzBn5VV2pEFTs+Nd/pRhlMj2Sbi7bsKtKfSrI+w8wq8fVKKu?=
 =?us-ascii?Q?hP4G0BRDm7ZpqxUxmAu7YckUdWuelx7EfcWK6v2I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1722cb4b-d38c-482c-1a1c-08db567c5be1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 02:13:52.0189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YiG1zzVI51L1rc6HceBHCz4zB+VUSIVEs9Gni8lBzCBFte9RgM06mCJthlXoJJ/MMhVzMEG3QjTAlywnYksKPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7568
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chatre, Reinette <reinette.chatre@intel.com>
> Sent: Thursday, May 11, 2023 11:45 PM
>=20
> pci_msix_alloc_irq_at() enables an individual MSI-X interrupt to be
> allocated after MSI-X enabling.
>=20
> Use dynamic MSI-X (if supported by the device) to allocate an interrupt
> after MSI-X is enabled. An MSI-X interrupt is dynamically allocated at
> the time a valid eventfd is assigned. This is different behavior from
> a range provided during MSI-X enabling where interrupts are allocated
> for the entire range whether a valid eventfd is provided for each
> interrupt or not.
>=20
> The PCI-MSIX API requires that some number of irqs are allocated for
> an initial set of vectors when enabling MSI-X on the device. When
> dynamic MSIX allocation is not supported, the vector table, and thus
> the allocated irq set can only be resized by disabling and re-enabling
> MSI-X with a different range. In that case the irq allocation is
> essentially a cache for configuring vectors within the previously
> allocated vector range. When dynamic MSI-X allocation is supported,
> the API still requires some initial set of irqs to be allocated, but
> also supports allocating and freeing specific irq vectors both
> within and beyond the initially allocated range.
>=20
> For consistency between modes, as well as to reduce latency and improve
> reliability of allocations, and also simplicity, this implementation
> only releases irqs via pci_free_irq_vectors() when either the interrupt
> mode changes or the device is released.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Link:
> https://lore.kernel.org/lkml/20230403211841.0e206b67.alex.williamson@re
> dhat.com/

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

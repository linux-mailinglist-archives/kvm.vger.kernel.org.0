Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D094DE6DC
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 08:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242437AbiCSHxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 03:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236778AbiCSHw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 03:52:59 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE932EF0E6;
        Sat, 19 Mar 2022 00:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647676297; x=1679212297;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2LfVqBpd+TLghS4xg3rg8Irzftbany52HVtIbRTd62k=;
  b=eDLg2JBUJGSHjBFzWOrqNdueDIgzw6LNuv8rdSGCfZ/PzDiJEu4houES
   LylP9WIGL0he3zM0OMEOM99dvQ63UwLgjIOULtlBNbWFmG8893KHGQZ3z
   Pj4XAi6/fFoq4tUHpntOEsEf3G4dP8k68Zzeui2ELUNLaZNtrN2+9s2s+
   IpNvb1qMi0hkgt+RwsTacvtHbZFqH2dVUXvXbbgD3ggMQgW9ovMpVt/lb
   RfBZ+0Uklq4bQuUpLEH+qJQ6WzRljhg9SSo/D+6bVS5ijwtqqWyJQHZmH
   uq3DZ0EVG36DHKUEqrdfbYcJ5C9a7uJqZpx1RBJxdET3iTziLVnkM7mV+
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="237228102"
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="237228102"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2022 00:51:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="822908462"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 19 Mar 2022 00:51:36 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 19 Mar 2022 00:51:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Sat, 19 Mar 2022 00:51:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Sat, 19 Mar 2022 00:51:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpbZLNNtHctIKnksiiTTnWs79NSHTcSPruMC0LxrY4JAfHe4rL0fjT89WlHzHzQ9GRx+61Wmg0wjKqxkCB21L9pHXjsu7l/KNtk7b8FGE5YspzmJ0cPO5apydtjFgGmRzRbpXdIdxY2O6DbARXM50z2ff5kvPgAaTbJTyiRMA4cFdgtE6CJM7UaEEQmyiUUeeYFA7Er7bgs3lVUlj22KmOdQL6xDiBP63B8TraDuWyAGFnUBsguAhwkRx1MiXv+v6xv4vaN2bQXA/xuATwJrB4TOiUSxc8d+0Yze3XITEGdEc69CfDsFIlGpAp9L6sn38P844S/G92HMobMeILYZ6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2LfVqBpd+TLghS4xg3rg8Irzftbany52HVtIbRTd62k=;
 b=csRROHL4WiW4X4Zw4zOuidiuCyEKyDnOwmpg/HtPZVbxooDULQosBnR8Fst68GtreeY8pC1nyeNqAIIVuoovhQdaC1351SdhxWe7dyO7P4dz0X0lehzAH7MIuOAFVd/V33Me3x2yfDpnA7nL9sPvFBkodkPHPgOqZEACqPvZ9rkjxg/Oz6PrVBGfItllRbLfLvodA5n8Ydd7Ci7aWWzTn4BOgofpN1YvXH91v8Op1R559Yw7LImOzXEIyaOvXiztJl3F4AfqbI0ni7yN6cj7N2ixdupTkyBYomniQDauodYlNb0XJHufWRtVVc7r/AxyeIu9wbaPfOZtK1sYD5rbfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB1494.namprd11.prod.outlook.com (2603:10b6:910:6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sat, 19 Mar
 2022 07:51:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%8]) with mapi id 15.20.5081.019; Sat, 19 Mar 2022
 07:51:31 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "vneethv@linux.ibm.com" <vneethv@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "will@kernel.org" <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH v4 14/32] iommu: introduce iommu_domain_alloc_type and the
 KVM type
Thread-Topic: [PATCH v4 14/32] iommu: introduce iommu_domain_alloc_type and
 the KVM type
Thread-Index: AQHYN9xnDDDBVY4pLUqXQfRGdryZ0KzARNcAgALO3mCAAIkrAIAAzPRAgADLE4CAASbdkA==
Date:   Sat, 19 Mar 2022 07:51:31 +0000
Message-ID: <BN9PR11MB527649907D241347BCB540528C149@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-15-mjrosato@linux.ibm.com>
 <a9637631-c23b-4158-d2cb-597a36b09a6b@arm.com>
 <BN9PR11MB5276360F6DBDC3A238F3E41A8C129@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220317135254.GZ11336@nvidia.com>
 <BN9PR11MB52764EF888DDB7822B88CF918C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220318141317.GO11336@nvidia.com>
In-Reply-To: <20220318141317.GO11336@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88f1ade7-2beb-4757-5949-08da097d484e
x-ms-traffictypediagnostic: CY4PR11MB1494:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CY4PR11MB149493652F9E34B3DAAEAD2E8C149@CY4PR11MB1494.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uto6jo2tOIkWSnyFUk9UVTqlAOypKkonLFa9wwHBTxFTl60nN7hl7thUJKtTgk3GTeEOo3OvuiIN5T4pJQjTxVSwq5yDq/zAbK/Q66i+08XPx1iCaP4BSqQUWMmg2RlP7IIUufBBlQdr0yC/PVZZjPqTLK/EN9PI2ssBYOGUthxsOQZzUjPF5wvjF3qWJtsYJ6dOaK1UHYVs7v4y5oUusU9W/0tjUwUcD+r8NhiffZ31eS5WjSAFDHBQebOI8neo/SnzTJV0UafQoqkX2cvYMr7qVacJK6TNP7kV1M74OFvA7yJm771cgqTsgMz1khlrLIxja3jtaV6rrmZY5nLNEUfSC96GkoBjEK+sDmKo33VQePgCDu6ocVGsAm3cz9/9eQTHEcjW5VUDUUSaIXVTOJ9mBtE856TjL2yiqm7DyYdwo0y9vXsQmZ7mZarnlW0FYwcShVMJwFHMGgmdKz0ytfqiPe5/f20oaHgLSf/ql6C+5XeY1tMDocS9GKvb9DXq7RzgzwDWNoUD6zEUWmZUF1X4XN/Q+f3aHKoFkQIeqcU0xJdjAfopvURPopCbX6lW9733bFYbOrNPoFe0vTzmge9fstGWvrETrLsFuQIHCtgisTvoOhx7mrLHTCYJYug6aFG2aEqQlgoVfCxP/n2pkTFflrPqHA5DvjZ5Lm5o+cbjEhwfnRf01lH5jRzqzydW2BRS2fl5q9qHMpL+J9fjEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(8676002)(66476007)(4326008)(66446008)(64756008)(76116006)(66946007)(86362001)(38100700002)(508600001)(9686003)(71200400001)(26005)(7696005)(186003)(55016003)(38070700005)(6506007)(33656002)(54906003)(8936002)(5660300002)(52536014)(7406005)(7416002)(122000001)(107886003)(2906002)(6916009)(83380400001)(316002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uAOzhfoo1DEQjfDmCysGTpG/H4l/l8X24rUePhtsPJEcUwcIdAMKYI7u18DW?=
 =?us-ascii?Q?zR4nzjEqRQHLE5gRkdp1Dg7yr3KdDiukQJSgWM7e+yZDJOy52uMH6wnRxn5D?=
 =?us-ascii?Q?sIX95hMWFeph4sEdO4UG+VfRAWdO8B0HiUJZ+IaJjTT2SEvJHvcUWkUxDV1C?=
 =?us-ascii?Q?45kpw7SCFhw4DMaZIqArLv3jUss5QlYOb9Potwf+qt2tzhWLHp40Z8Lhyiio?=
 =?us-ascii?Q?aYorB6fsZnQuz20h9PlwUWEUuHVgOUCxecAJzKkU/qT3XSWaKsk7U/E3cWsM?=
 =?us-ascii?Q?6BIqVlmYgz9hf7iw3xamTSx1AKP5//eilQ2idkydwCcUVlFiJ5noI6Xv50xR?=
 =?us-ascii?Q?TpVtcLAEDeIQ8KDBQhygJ3TxBtSPcAuhA3eqqX3OXrp39exPSJjb44xWg0XW?=
 =?us-ascii?Q?hb+Tosr48Rpw7+T7eolbWlRbqKWHc/kNJkCWBL8OPZdxrqJpb/Xni1iJPI+f?=
 =?us-ascii?Q?eD7DIh2L+2Av7PdTc7g+pshQA4A5XaByfCA/esjlbkbv8jNpw38/e912NtoT?=
 =?us-ascii?Q?G0IbTuv1TdFgnp+u1pW6pyM9LS5Pnqr9D5fTgH70ocppIjsaU2Qs7X0Luxnh?=
 =?us-ascii?Q?Ub4VZoFwJtcz2+RylYpz9Hpc0aw7r9ESgq1RTNJ5+1mena+wmrCkIViND91a?=
 =?us-ascii?Q?fJBjMURoEuwdcbSBIKyH1EgSQaBrOc7gYLtFubnhYtRNv6VK3v1gmcyXOdbD?=
 =?us-ascii?Q?hq/rh0v2Z6B4djuk8GDcvzfjmJd4V/+Bz1NHocPIywrXW+qzxzK3/YzsLzyo?=
 =?us-ascii?Q?joG1Xm65jo+Ef6yi8fYHphYo1tZRIKY1rUn39PuBnxItl5+THgmxFxwWXxcK?=
 =?us-ascii?Q?AiBUBO+0PI+l1Zb2NRYZNWxQXvNj6guruPvDU2U/Djo/srncE08xkz/WnQDk?=
 =?us-ascii?Q?Dp19VkBT1NQjdKn3ar/nO4JTr76wykt5cJHBATnDq987q+yZI9u4tqZchDbB?=
 =?us-ascii?Q?QMo3aE06ZmJbL3V6u2Tmpo++RU2Ro/LfqF2Y27tU2LOQ7Lk9PtHRHczzUouL?=
 =?us-ascii?Q?oGhWPwwnQglQgTll1OSRhszJKW2B/Z3GkN7/iOTnZNEL6UBbC7gNE08jQmwC?=
 =?us-ascii?Q?v1/A1Xfw9II2532jA3Q8ror/5mia9Pa4kJm1OLmXszb0UcD+LvF//9pvgDDq?=
 =?us-ascii?Q?M2vPGMunbA1P4U7fhb/m3nMGG9G6JFHXpERy0faJGsy3R3P3HaL3gUNy9t9G?=
 =?us-ascii?Q?fE96L+OgohdET6b2AIa9DyTouUVNVLzw9UWUMj1416JiFeeR6g/jgdm+513u?=
 =?us-ascii?Q?sWxlR31oBhR72kxEoQSTMGBzZ7vXLW7sEE9Y06zUbdaGk5+EtQ8cptmCrLXd?=
 =?us-ascii?Q?QqkZdmsPcgdYrXclxtdvRY/b45S+giyqkq/MBNTNlUpKh938RHtXCoIpY+Gq?=
 =?us-ascii?Q?bijNGPGcg/NxlsojDpJOWG3Q/kMj47YrubkGjXCU9H9zxL8OXjm09VCyyKEJ?=
 =?us-ascii?Q?CjYfo/UqZXUW6OWBDLmc/Z1XQty3oMap?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f1ade7-2beb-4757-5949-08da097d484e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2022 07:51:31.3596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pSNwe36jVzZXfL6YsTXZLQW+Gc6HTbJD6ncvqkOWRbPWgzW7hWM656zAy1gPV7eBjJlasalA7g1cV35KzF8XpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1494
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, March 18, 2022 10:13 PM
>=20
> On Fri, Mar 18, 2022 at 02:23:57AM +0000, Tian, Kevin wrote:
>=20
> > Yes, that is another major part work besides the iommufd work. And
> > it is not compatible with KVM features which rely on the dynamic
> > manner of EPT. Though It is a bit questionable whether it's worthy of
> > doing so just for saving memory footprint while losing other capabiliti=
es,
> > it is a requirement for some future security extension in Intel trusted
> > computing architecture. And KVM has been pinning pages for SEV/TDX/etc.
> > today thus some facilities can be reused. But I agree it is not a simpl=
e
> > task thus we need start discussion early to explore various gaps in
> > iommu and kvm.
>=20
> Yikes. IMHO this might work better going the other way, have KVM
> import the iommu_domain and use that as the KVM page table than vice
> versa.
>=20
> The semantics are a heck of a lot clearer, and it is really obvious
> that alot of KVM becomes disabled if you do this.
>=20

This is an interesting angle to look at it. But given pinning is already
required in KVM to support SEV/TDX even w/o assigned device, those
restrictions have to be understood by KVM MMU code which makes
a KVM-managed page table under such restrictions closer to be=20
sharable with IOMMU.

Thanks
Kevin

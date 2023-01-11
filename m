Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB84665302
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 06:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjAKFBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 00:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjAKFBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 00:01:10 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8046264
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 21:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673413268; x=1704949268;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ll/W1hrD4N+Fg5DKqA3h+WTntuyUe3ULsplAffK8gaU=;
  b=ZmvACMnLEL0rDrq4/v+CZctmlP5MnEb3u+2vC5B59s5BssRymv73iVEl
   yFYuxOcchjQ3cix4+xk8fI1l3wdu0gTmowx9QSc/FibZFfxN9SilXquqR
   PxIrs/m/ZMC5VAV5Hvd1gZyFl1RnOH4yzTjkvLsPN09AV4NsECCI/yhpr
   QMdgrAI6/nwiNzBa6YUJHlrHVPBvP/alCV6EClzuiAG4LxZRpTxRFN8mp
   LnWglLHeG2yWpVAmjNd+Sl4ipkIJey8Dv6f7ETlc1wSC/A5UAUILYK22K
   Yf9HZ04O2LVbkI9ZyvGYzzpDeBN9zRynOskrjNIHMTj+salxG4OJSuILO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="303028174"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="303028174"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 21:01:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="831228077"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="831228077"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 10 Jan 2023 21:01:06 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 21:01:04 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 21:01:04 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 21:01:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jlyq+G2kQtIPeF6x9nuHGI8XUFK+AA4AP6ZYl0VS7wjvnS0qLsfGCEVEVYxdm5fUpia8VPFg05urSCyKi8aWjA7zUyD36FeLLt78y1d1pnKjkgJ5t9b5VQK/0zmaBb37W4sGA0oEXwm9A8q4wRfGCpdpXoQ0bUBAV/vSEtc0QnjMJtjduYUldZ+wyI0rKP5w8wIBnufml6vIvCf2U/lqOeCHBdqg4ZuNREDMz0HfHXNkEaipRTwYcu8OzBeJFpmmm7FRJ/Vyqi7F30lZtBxaGcJYkLXnixwZ1PD8MKFAXl9DaNxYF8+mN4Ac2WfEEuWSaTx8vO7PStN9DEXaNLBTtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ll/W1hrD4N+Fg5DKqA3h+WTntuyUe3ULsplAffK8gaU=;
 b=WbJxjTionV7PvSPOpJpkfc/4baNUo2L5iaJJ3DHIZqLsf28NzHxKhPPNSavO0OiF0rkW4D9ap6aKjM0qzPyJ7OTBQ9Kywl/bfH+BdPDXx9SXHn7q9a12tY2ibjnf98UEt2Ied6nQkYWwexVPV0jdHtThOIPQZY5QzKk5YFMA1UBob1JoGe9LjEOAVTK4vCDAj89w+CGxV6Dxj8QyAimXMHy+H4XqLNEEHfdyGoqkyGak8XJw5oGZCrGyIQNKOwkq0TUQLu8/5HkrffjtYd8vK0kYXr+v9w716yKMxOBmBLiYV5QBz4szR5W7peYjQsk9bW7iBOJ5BBlQJh5WL/bbVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7775.namprd11.prod.outlook.com (2603:10b6:208:3f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 05:01:00 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%7]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 05:01:00 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2] vfio: Support VFIO_NOIOMMU with iommufd
Thread-Topic: [PATCH v2] vfio: Support VFIO_NOIOMMU with iommufd
Thread-Index: AQHZJS8keINhRoYm6kuj3nql1Iq9666YqOqg
Date:   Wed, 11 Jan 2023 05:01:00 +0000
Message-ID: <BN9PR11MB5276B603CF2A2BA2462BBCE78CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-568c93fef076+5a-iommufd_noiommu_jgg@nvidia.com>
In-Reply-To: <0-v2-568c93fef076+5a-iommufd_noiommu_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7775:EE_
x-ms-office365-filtering-correlation-id: 93602cb7-46cb-4470-ee5e-08daf390d55c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8EAWTGGo6THK3s46JrVKgLAGm2q7XdMUd/N6RT7VTs/4eErpvgkk77T/BsEhXyDP6gqn0FjUXGkRB2W7LrHYLP84EsXLnN+QxjuqSUjGPnSDmsBhYBh3YgPc+NYUlD9MYf621y3iWVoHoawHjMbscKR3DCshrAZyUPdzYLi1HHuOYgNNlQWp6MCs2CIYw4PSwox71TQUEBBEgzoSdmBvy5E7QR/q14zW1fWQfOxzdDqUpPR2PuBRTrSiQUhjnZvBPqdn0OMLLrTuSKMnmoqaWP+0p1JoNwgZ6o+gfxJCLIaRruhpZHEeChKkH48q2hYk/TQ/nsJcDX24V7++C0wqwjX5nLCmZJ7unJ86+K2XQyqGRsX7laSdWTDPCw3ROQ2TYi8Kg4VH8yq89Hckin10Dax+qFEJXIUoKZYJLHkTJuNu5c8XGir2e/HH8J9j8KpvWN+n7tEswG+p7B8TJDqtjPoMoAh+hDQkwcuJhiEbQ+u+XTFdzdWpGIhvJ9vKvDx3QZydWlHQp+bsz+LFiSEIqouX96PrIQ6HSsmWryRNG6eZZbB7kS/WY5RmZ7Lf5PY4Eju3X/6+zDD7YqrV5TeGX7reldavmu4P963xSJ9/0wa8i0z6HgUrclo422wjHTrGTOf9krJc6GDDSu/v918iUNUTR7bVmTXur/g349KWv7n37nAS+HvGbR+dro/yJdNIXwS4ZZt2Lvo2pqi9o2TmuoVTM+Eo07jSdyt/Gr9I2lo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(136003)(376002)(396003)(451199015)(9686003)(6506007)(186003)(55016003)(110136005)(76116006)(4744005)(86362001)(66446008)(38100700002)(66946007)(38070700005)(66476007)(64756008)(5660300002)(122000001)(66556008)(478600001)(8676002)(2906002)(26005)(82960400001)(6636002)(71200400001)(33656002)(316002)(52536014)(41300700001)(8936002)(966005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wGV+41FkZMxAHDPPP6D0NSBWBL3usaJNcbcmLE6wNfYKWqi2m5piZMa0x+4v?=
 =?us-ascii?Q?IZ9kmOnzE69toGAPCKyU9Eopos2bPuJgWgcITOT9wXY/liyWv46V34eej6us?=
 =?us-ascii?Q?MTEoJsu2OVcZkYqHOJ2WgxSl34QEljoXzf0kTDqD/fJNBq9DYyd6Y1MLx1NF?=
 =?us-ascii?Q?++YHw5EkblR5pck0rzAUnEOGrWgIosjvvRBSlpMJdqzcd0K4W5b+Oq6e2l1k?=
 =?us-ascii?Q?kWPHs0XdcGuVwuEYpyarKlcbprfz3udo60/69F6+zC5O2MhZK7U2fTLkK8sl?=
 =?us-ascii?Q?HsKAtPi8scQRRbiCrnp9b2RxMHQiG5wjHh8cLaUHb8kacx44716AtIYO+iL/?=
 =?us-ascii?Q?3OvYvLHxiy8EZbSi3Xa/oKeK4Jkf+CNP0V5jHtQPH6dVxozdwe8avQ7514qL?=
 =?us-ascii?Q?Wc2sybc6FNvm4gMMyj4N+CLui9iq9dWLMsjfkxcxEDlV7eMmUpbpBBqwj9UF?=
 =?us-ascii?Q?mu9s+sxyrHVl9uoWdE7StyX5X5b17erKg2OsN1aBwjNus2CLYjGcXL4X36RG?=
 =?us-ascii?Q?QlA4iMG0VzQ6Ref5F5oXGH6J9TakCO9Z5mulon5KT1vG6jd0OipcBKwYiICv?=
 =?us-ascii?Q?C+a8zYxb0hu60xyv7+QiNih/0qEQN1/C8/Sp+hW83oV0GbdOCGmFFmAqAs2L?=
 =?us-ascii?Q?WUFHqgiih9OUPiq8x8HxooE/HaN4JEe8kjyb6Onoiep4kN7FSiYjOfbudX22?=
 =?us-ascii?Q?mBJHKL9BAlHToDWEOi3S+wORNqsKzNSp20KwHiRLx7+0BQ47CsavqUWzqW3C?=
 =?us-ascii?Q?IRKJDeRKsw4Z4Sbs/XcjYfm3oiY3cKvIY3aCpM6KsgbJXCtCA7eP8iCAY8Fb?=
 =?us-ascii?Q?0v+Wr3LdjS+yD9g3aN9owgwkbViRsvPacexE4WfDyw7CO9ZKiuxDQaYDB2D9?=
 =?us-ascii?Q?WzBHfaT67TX/IHeOXp5kdJgXUJ1g4OgYsXIYvg8Gv3swUnmK2OmymLfCQZng?=
 =?us-ascii?Q?WMaEDQiPXcFTCypHM7ZQmhwabDtaGegdBNjIMt8q4Z2fjNbpBGhowQlNqm/4?=
 =?us-ascii?Q?eFKBedahv/Tgt7PY/7qVhSyMCwtOmpbgnE2NxiCz17aY8xjHV4w3oqpPbw5p?=
 =?us-ascii?Q?zYiY0gie3tmN2Pzxnn21FseLgfmHPMii4s/onAGrtIdcS/244dWAc6zv0kIf?=
 =?us-ascii?Q?5t/AXJurrweRYnB+sBCi5TOOGdBmXMrIGdcvhRqLTh5xbLghuZRfV1CPBoJp?=
 =?us-ascii?Q?BELTs2F+4HNyfx87jhHyPP/ew2C/a229PYO2EI3e5Ee0epiGijU5XuveWKUH?=
 =?us-ascii?Q?pAZrGwZTWS/kmabgRfxOyHXZ+QEerVdYT0Q7lB2tPhIvODzh37r4Eu2wh2bK?=
 =?us-ascii?Q?u3GC9NMHfRuATa8ptd75SH7mmf1PdCv0nmMm5xNSEkPRLjGASK+ndjCRf5kH?=
 =?us-ascii?Q?9EiBNmvLtOp4MMgMu792HC7IX4pE/ZC+DNmnRgDKjDHlGz4sPifF5MTpZnNS?=
 =?us-ascii?Q?iy6PHsY1JIrUqu9YqisXBrealmkXY5CcM4CtVj54vHbEB475E2on1ADglto9?=
 =?us-ascii?Q?Z2UpmUZ3zgkfkoRgrN7VwEA1v6rHOv8M4qqoGtc8AnnKJJOfSYAO4a+zYthP?=
 =?us-ascii?Q?dS4Jfc32yE6elahJxcpQEuRNgHCEyR+bGGTeBWgh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93602cb7-46cb-4470-ee5e-08daf390d55c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 05:01:00.6355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MF3CvCRX6/vJfLeV61OwG0DbrZjYsp3QWP1GL++v+J4M+lAno6pkPyRx/gdbktBL9symBFIjxYayrrMNiN+Z8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7775
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, January 11, 2023 4:07 AM
>=20
> Add a small amount of emulation to vfio_compat to accept the SET_IOMMU
> to
> VFIO_NOIOMMU_IOMMU and have vfio just ignore iommufd if it is working
> on a
> no-iommu enabled device.
>=20
> Move the enable_unsafe_noiommu_mode module out of container.c into
> vfio_main.c so that it is always available even if VFIO_CONTAINER=3Dn.
>=20
> This passes Alex's mini-test:
>=20
> https://github.com/awilliam/tests/blob/master/vfio-noiommu-pci-device-
> open.c
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

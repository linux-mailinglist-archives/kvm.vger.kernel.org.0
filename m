Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D717751D3
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 06:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjHIEND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 00:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjHIENB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 00:13:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AAA19A1;
        Tue,  8 Aug 2023 21:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691554380; x=1723090380;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GMg5ahPTFglmzuyVTFDW2m8EjnV5r2+WSguPMMfDpVc=;
  b=jHnrSiuFT+ARm+CjmQ5CZ5GQOgYTs36QcdVWie8BKyI/KHfs7Xloh4vi
   /z/mKtBR7TNcaHQd58jhkkA7VVJTG1vV6jyLBzEXORLrmk+NMz7x+NivU
   h7waffCp+kLbUzIHTr5K8RAYtP5UETVi3qjDQxpdtzFgUlhKVRMmTUEq1
   dQyDqJhpKEXMtplwRN/UmMQBftgOIpWjLalu53cdSAfGskaxX/AODTCzM
   +xpXlYm3cxNPAyOESIue8Kek2TW2ze7ypOrE75NuODjLGe4sDsx6e1yhL
   UyZEkpKlO9Hz575oVZokhl4+ELQriE8a6hnpYYVGpTf7J9uXB4TnCnNnI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="401983510"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="401983510"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 21:13:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="845771347"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="845771347"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 08 Aug 2023 21:13:00 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 21:12:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 21:12:59 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 21:12:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXb3qn4twZpGPiLjCCUKv2+RVieJ/uijHhZ+7ehhIxnFGxRCcE0KIWtG91+NWZJjCfBCg3Fb4eDjrs87oGUS3XYZLtgCorpuCRYH3WBLRjcJePDPI0dVhablw8+3JW1aY4tOG1SOERZQg3S01aYRSQTn51fTwRWMAusveth2e1agNZUD8UFN2ce9I/jIsUraSl1kx8a5LsULEvrO5jJU3Z8I98/9fBIsiOdP+nOjWoVqPXDGcUXPcQvXXuByzb8i9veJcBAYNLIvUs10Yx4F55y6F2dzERb5sZpgIU2XW14U56mtw6keSXjc/MDnVNO88pHXmxayO6fvG/dyj6ZaJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1J6225uqjP5nEmPYDM9Uf8+9U3XOYJyB3NycDzXopD0=;
 b=VIuI9qNbiHOwiEaxMTE/nUpo7Ma6dTqsRBT0Cz7L64u3uVqvxW2FnQjJH4Mc4WgUrRo3kJ1IcRmxxcG/SFTuDyN+WVPD7RciWcGYLNLBUz94t8HLa+V3Znvi9hmcd0ssCsNBmsbcUdZAnoSa/b7Olha5kJ2Ax5bJChSSQJQmCo6ON/fuK7j3zCZhHwwFDlq7JrDvLeTtMLoypVnKtfTdOiK1lkl6Dz7FOrGewdW3HDet3V92778eaPGMFBtkxXQZFH1SpJknGLKQuG2o4D3Y2OijImbRL1WRoQuLNsfsZb+Cdc9ug5uwz7JZy4T4xX+UDJX54x7D3F7ed62HvvlOMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4944.namprd11.prod.outlook.com (2603:10b6:a03:2ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 04:12:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 04:12:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] vfio: align capability structures
Thread-Topic: [PATCH v2] vfio: align capability structures
Thread-Index: AQHZyhPRoQtbrQtb3ka03fvc/lDEIa/hWtrw
Date:   Wed, 9 Aug 2023 04:12:57 +0000
Message-ID: <BN9PR11MB527635149A3E117E6D56C09A8C12A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230808144216.2656505-1-stefanha@redhat.com>
In-Reply-To: <20230808144216.2656505-1-stefanha@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4944:EE_
x-ms-office365-filtering-correlation-id: 1785c89b-7fac-4133-1f20-08db988ee98b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qOei5NcX+eTta9PX99P3JnKwiWtFv8nfL+CrSil5nd9sF7L1uWXSW2+UA5wp+jUxwsufgPmFDMft1+EgEFk6+SW2NCmRwPsg8W1IztzwrPN2PY+pNouDofHfh07txOiPZPGa6WjF2PUxS9SpM2tbvV5038JgL6CMBkeUX/VDwcfvqHn3QREkIoZ+qUHwAvNxmds6DutfbK0SGxrLWWKT8z7vEA+PQMso6VN/C0rCCIpq7YLiXnWHtTsMhxccgK3vZ3oDXr8bexd9WioeGH2okTjK7iOTTKK8Kwp/ZiwEuKBRpRZ7dCY5Ps9AYjW6ff7na/uJv3wlNRM+scFyD2JsGTTTmPUwzuTjLxOPu4dxxXRhtfU88rW+jkPKXRiK0aCr9Elr9xjbj1AI0nxDQ89GxjtWpKyJUEPZ9/Au6z/eYYtrzHm/2vZMACqXddKfXWAkiyzpTqApbqv+gOowUf3vdg1li7++YIHnwIicQsUTzyP5U1RdNt4bLrbObYdTxq+NWoBiOg7+/Ud/yMUXNmXzIltISVnxC+WfcOEbO7h7FVC7bzlammBENQsRaSfmECykPAnKH1ej5ROgBI6Q5jGQ3utN69pS0AfAt2Qgqe6IrdlDcT0i+1v4jHTvCWt/lryO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199021)(186006)(1800799006)(55016003)(316002)(83380400001)(2906002)(122000001)(82960400001)(26005)(66476007)(38100700002)(52536014)(7696005)(5660300002)(41300700001)(76116006)(66946007)(66446008)(64756008)(4326008)(6506007)(66556008)(8936002)(478600001)(110136005)(54906003)(86362001)(9686003)(71200400001)(38070700005)(33656002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lJfEyK/zwgSIPrjmQN5h4GLwHD+HspP4Ejs6oUVvpfj+DLEClGtyWCFKwdM5?=
 =?us-ascii?Q?a0Zkq5W5Xg99i7ZWVof0WPk4xzR5T/aY3o/nK4YbMuls75DIPY0J/nbThKlb?=
 =?us-ascii?Q?N80WU9CNbu6S128sXd93XVO5Tj8kumn5A9UnhOJAZCRe/sO1jbUlcffD6FTe?=
 =?us-ascii?Q?wjfmGYQVaU1sNxJlV1ckuNkyvPWb4VErtEDYwSl4esjFXY7px2y7WEYY8igJ?=
 =?us-ascii?Q?jCFNUz6eoaP3qcx3I0KxxzHYWRzpCfAvVRKymbQGZUmMMMQJrcE1fEksmHlm?=
 =?us-ascii?Q?ywqd3i5oai+48CzybukNZzW6+rFZAJfS+jnE7DcEOvy+kDsvSuSyWTAAQ9rZ?=
 =?us-ascii?Q?l3B3zlgvJQU26LlKXs3utOLpgCte7PdbNhisBLtJEDC08n4+0zxlfm4pMOiC?=
 =?us-ascii?Q?NwTgfrZzYoJUMMfQt7SERCCbBhtflH9Nmfc5YyXN3IELwaHDZpHvzVma5c2h?=
 =?us-ascii?Q?Xt122PDt1c1Ra3dKCy5jP3/z7uoRxJmSkeCivERaCJKmal/6jzSwPYyrwNkc?=
 =?us-ascii?Q?UlQGmls3cBeIhzGGfrAU/IqMXKdiSflg/Y3R+8PyOcL8LjDsbqi59U6nVLh+?=
 =?us-ascii?Q?M+8N3Csd48/E/Ea0n9+HqhhA9OK9dGwTxNxHL6x6vTr/y6Qb9TgwTPlac1Zu?=
 =?us-ascii?Q?CatWstnC0NbiEGjcE2kuPuKqS+H0VsDumO2zbSh2TXO0cHi407P9T+RHicaY?=
 =?us-ascii?Q?sqxosu2gjcR6IHFyd1E4HtBatWcE4VnO90hRvzvExfXReBGQk5KgoP45k4H7?=
 =?us-ascii?Q?xGoKA2t/b634Ds4w/E7MtSMqUfRXhSlObHKVud4YQAQO8RV/VAHvZpgimt5G?=
 =?us-ascii?Q?YXZthbCxbZsOvKUlyzx9v8aVm0bJDxFd62BfrcRHTrBGYCIClQKOOPlkyn14?=
 =?us-ascii?Q?a6Ux7w1T3xS6cwfeqYBmXFA7uhSPJA2geevEpHqAaXYyZSG7i8veH8bl17O0?=
 =?us-ascii?Q?QdhSkk/CeBRBlo8PUI1miXQF49R7Sx0wRnw2K+elLPEcQfW/6tsvlLZ0eBP1?=
 =?us-ascii?Q?ZnOQd7ml2UQLW1e94Ym9d6iZ3BAek5p8fZL8tDIDGwNJAe1kUQH1T+mEWStK?=
 =?us-ascii?Q?5QEVqZej/NsxyC4KsfFSB2UgUG42PorVAHB9GOHRR1/8pKjg/elwHrTywKHb?=
 =?us-ascii?Q?ue4MVZcZTIasZOGqdqjipxzaKn3qmg4ZkTOzaYg0/e6UIhnSO1G4TF/0V6py?=
 =?us-ascii?Q?NYL7d8R5Z9DilQRQoVBHD+u2dB4CFuyjxhY/ess5l8Z28lqMlrcpk8prmge0?=
 =?us-ascii?Q?QyXHpKYd+3Ch0xwP7wKcKZHQ+Dme78bMu3d9Q0S0fV0dkHotNAo2AkqruNUR?=
 =?us-ascii?Q?4QYDagUWl1bE3MKiNSjeE9nPC1T5n8gF9j+ZG/P426HGJv+V7iuiPuN+yVjv?=
 =?us-ascii?Q?MUkaOjzDkO+c+cW+9zcHVPnP3WlP3N3i8zEUtd74/CMJ1IwMSGXU5HaigC4j?=
 =?us-ascii?Q?3UdaMU0oeztbvknKAppuKf0sbZsM8ywF/blVfFz6+Y/JmhsYAVnnb8xYM5J0?=
 =?us-ascii?Q?cjXREWkynZ0KsEehA/5I2iZkrMBlcpuj7ZGCLl5OXn2Im5kE4N4k+OQC25OV?=
 =?us-ascii?Q?b7DECVjrT8pj/wZd1faYz51w9oVEEb8OcGH3Snic?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1785c89b-7fac-4133-1f20-08db988ee98b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2023 04:12:57.3804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P0knRTzfCxSTdrVtf7gLdvj+ixPfFYly93cvXabGVxEjedHb9z5ufupKcu8OY4STbzA8ORejo4aU1aQc5ee2ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4944
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Stefan Hajnoczi <stefanha@redhat.com>
> Sent: Tuesday, August 8, 2023 10:42 PM
>=20
> The VFIO_DEVICE_GET_INFO, VFIO_DEVICE_GET_REGION_INFO, and
> VFIO_IOMMU_GET_INFO ioctls fill in an info struct followed by capability
> structs:
>=20
>   +------+---------+---------+-----+
>   | info | caps[0] | caps[1] | ... |
>   +------+---------+---------+-----+
>=20
> Both the info and capability struct sizes are not always multiples of
> sizeof(u64), leaving u64 fields in later capability structs misaligned.
>=20
> Userspace applications currently need to handle misalignment manually in
> order to support CPU architectures and programming languages with strict
> alignment requirements.
>=20
> Make life easier for userspace by ensuring alignment in the kernel. This
> is done by padding info struct definitions and by copying out zeroes
> after capability structs that are not aligned.
>=20
> The new layout is as follows:
>=20
>   +------+---------+---+---------+-----+
>   | info | caps[0] | 0 | caps[1] | ... |
>   +------+---------+---+---------+-----+
>=20
> In this example caps[0] has a size that is not multiples of sizeof(u64),
> so zero padding is added to align the subsequent structure.
>=20
> Adding zero padding between structs does not break the uapi. The memory
> layout is specified by the info.cap_offset and caps[i].next fields
> filled in by the kernel. Applications use these field values to locate
> structs and are therefore unaffected by the addition of zero padding.
>=20
> Note that code that copies out info structs with padding is updated to
> always zero the struct and copy out as many bytes as userspace
> requested. This makes the code shorter and avoids potential information
> leaks by ensuring padding is initialized.
>=20
> Originally-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

As Jason suggested let's also fix vfio_compat in iommufd.

otherwise,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

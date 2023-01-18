Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1FE6718F6
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 11:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjARKaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 05:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjARK3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 05:29:39 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A4DBCE07
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 01:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674034553; x=1705570553;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tt2DxdLnG2HlP7WcrSeb0fJk2X1BhxHdNSQaGyAb3H8=;
  b=muol565keKXrJW5D0iPXnCj7fv2OiCgOG1i0tSO4NAiliymjoHPQRt6z
   W5ISAV/dMggzQeyK514OPvtdjTWGni/rF1tZdMstb24hThDDfTRZ2QcF1
   TGWjKHmcOEYW/M5qAzc9nGSueZKnaheEza6kgjvNUvzpSldzXR53G43VB
   7RXGVUEPKt1/DRDHZhN4rM9nWlbe3Z2Zsn8SE13lkWXb0kV9MSYK/6lBy
   jwEv79sFVHGwCVLDNfupjPEbGHzrfBCefu7JN+7y8mVP7Dcsw7OHQ00/j
   T/aL5Sw+mvsJEFvyMELlsOzX/Re5VkgJ9TCMX84XAm7UbnMCECes0x8s3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="389443853"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="389443853"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 01:35:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="748397548"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="748397548"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jan 2023 01:35:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 01:35:35 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 01:35:35 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 01:35:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmJteT+ggj9L9wrSgR5RWCZC08U8lp/MK1X2qRnAxG4Igcv+PlGzfnQ0nnua8EcDSNGJoUWbzrGJKfj4Xp5hvDkbJ8b4K8LvEe+sMoyUvDzqlcpGFCOR0erqyhi/jQwxPlwMfzVIQgivXqAQRt4lMJy5Jpa582ESDOfi1/xLuQ6U2UBr14sne5lN5GHavox8dCWDfBq0BmbktX0SCUnAXLCnYZQKf7Bmb8usEb4N/Mo1FPo6kvNSXviRzVqA/IrucjawqfWU9eRaqcPDLvCR6Fhwl1EL+hc7UQruN5cYX/7Iw3IPyINR4D6tnxbyuwgVL4I9dCUkNOPSaEmpCrcEvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tt2DxdLnG2HlP7WcrSeb0fJk2X1BhxHdNSQaGyAb3H8=;
 b=R26MD5oG4v9NoS1g6cK00X+Eoe61q3ds9wBgdgJZyLJ+hX435O1K32/7JExas7/YYFu0GtNiT+ON3iXP3BD89LQNmLtS02G2i2F71Vjd4SPz8bN614VJlzR4quRg4Ggr4AJ0JAh/XMI/Pap/cMY/xpOaJ2L+zJ3nMv9tgd/atT9yU6bmMA3P9HrGQY+PSZbJHnbJ8suiyVAkg9MOr6aTEEPQD+8l4dxWw4uEHH+WUP7VAlAPu0IPK1chlGFbtP4+xOVtcoghrTc4lR0+ILDzVm57PrMyBJYhLzMxc0bVrrbScJjLWV9QcUMSIMiLvuHJ/wbNeL3lGWUSfCs7M6U4Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6008.namprd11.prod.outlook.com (2603:10b6:510:1d0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 09:35:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 09:35:33 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 08/13] vfio: Block device access via device fd until
 device is opened
Thread-Topic: [PATCH 08/13] vfio: Block device access via device fd until
 device is opened
Thread-Index: AQHZKnqYgxUzhzjIGEixJ/hIzOZ5Sq6j6vbg
Date:   Wed, 18 Jan 2023 09:35:33 +0000
Message-ID: <BN9PR11MB5276941A0F5FD7880DD1C41C8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-9-yi.l.liu@intel.com>
In-Reply-To: <20230117134942.101112-9-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6008:EE_
x-ms-office365-filtering-correlation-id: 2b6a788f-1cc0-4e17-684b-08daf93758a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y8JuyN0j6J4DqXwo0LeVNlwXL4lmgoBP7rFZmY79oXKiEuCqfF2IrsfKjY8Nz0snkuTrKxKu6ARN6IScNERPe2hYv+GuiKltQ+Ct8fwiqc8g+ego3SG3hpJyQYDHfkcaGjXG0M5QJkqgfkQ/43KDeuwpAisNteGgIHJZC37pH3fBJA+NbI+xr/VkpQo/KbIGXqLLyG6aCPIYa/Jyf5jj2hkLKiFYlEB8KSJVF8TKW6II+kD3hNx+Ubr4VQA1GSU8jgVX4bHll3xl1faBryuEN/QjdMbEiMx8GHRMJ4f+pcv3qSdt0WFjH7tyfIdQs8ZnumtScR9mM2w1d7yX6jlNWioSjndfYPi7fsDkBwbc+fFRyyTFCu3e3tADadk0A6xduXy8wp03t7SvNdHOKfuOpMa9ksIcbOQjAea3xwaBG5GixiViEIO/fX/HsHEgv86AjNtWnqj9z7ej/0aCfHDVotDqN5WJRlDtKkriw/QOtFkvmWjS+zMk7G5dLGAw6QZmEgR6o1cg6AGQ20PJHextszH3zNjDgheN1NmzXrV3rM+70JXkLEEJf5/jXG6oWoVaWaFLHJLLeb0W+WwWtjtjAnf4r2CN1bjtRMxQMHvg/+dBcrxJmAPcgFCwBROmn6+7mptdDE3K4bv/2Zja8S+2niyO2xB/6c1hxY73BCdxnNQqchnhgwUes7uFyt1Tf49euSZAS2NUi3jBdJNzfg76pA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199015)(26005)(4326008)(66446008)(86362001)(76116006)(33656002)(55016003)(64756008)(186003)(9686003)(8676002)(66556008)(41300700001)(66476007)(66946007)(71200400001)(316002)(54906003)(478600001)(7696005)(6506007)(110136005)(122000001)(38070700005)(38100700002)(2906002)(7416002)(82960400001)(5660300002)(83380400001)(52536014)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9PmH2U9zM1LySTP0+5UKjsZsU0TDWNgLEHNDcDHkelATi5VG2RrymmryOt9t?=
 =?us-ascii?Q?dfwckZIwI/uyX3E4KPgPWx003AyBuk/xPlMrHRAWFhQgol7FeOqKGLaJiml0?=
 =?us-ascii?Q?OGWHdZauERBWCL0w82NRva1HEWXU34VDbdORptJpYqXww914ONLkqqWf67uS?=
 =?us-ascii?Q?ekVE9bb0hu9HY5/WGxwcVBktSf93v0VX3zw3nTfch2fJMQwDEmb1v3FJU5yh?=
 =?us-ascii?Q?cSLGpB6vVB9RkmjWFFqIrZDa8m8JqHyQnpOFH9QxF4Ub1tE/ZxuHpTaYy8YB?=
 =?us-ascii?Q?mUdr6h9QoVzc3LJNapfy+si0V29/iQul4N3hIS+FTO2tNsI0n4zuCpaCW0UU?=
 =?us-ascii?Q?LIWQ+v7QVi/Rwa0tF+s4siOcjLkPkf50OrC4YKBWZSo6/w0vJyDVq7vWVbgi?=
 =?us-ascii?Q?I7vfqrf7JwOWFT+PGmzNJlbZWvEu0gDQ+TwoNGfo49hugbw5LWQ+ByV7maUS?=
 =?us-ascii?Q?1/0a9N7XwTh+kQRlaZJoPMlNzvrCIt/ct8SzBnB2j6Lk2WLPsHuxFZZ73TQ8?=
 =?us-ascii?Q?jOd8m9AvKy8fW2CE462tyZ5gSlytJUmZKMseGmNhwzZPJ6TORsefsXwqzPJ2?=
 =?us-ascii?Q?m04wevJXLnHG5v8nlL98A/+JJ+Mq6gTci3V7Fqut1JEVtzCfOXbFuR2ZAkkJ?=
 =?us-ascii?Q?4k0GLmIp/CfhAINEtl3S3wmWpsREmsDP21CcERzv0+safxVrMwS9nTb860Gx?=
 =?us-ascii?Q?ylljNCFlIjQZahV1bFSSRbjXaaRjvbPitEH2b7CVPO/jXOiX5bzKtS3x8gX8?=
 =?us-ascii?Q?983kQZfvQ6wObVS0rgSB6st1tDLR2jU9ynWDvHxsjPSJ4wm0oUE5G2mqGsdq?=
 =?us-ascii?Q?NtkPTqnz30XeVdpNfct3zUgFyGcu/B/dmquXbW4mJERPStYFOzIRPTspJX4o?=
 =?us-ascii?Q?DEPjji/rZutN1JPpD3MpwD4RzGOLq8AjEy7l74efH+7DbezEkNWe+5+vOtrN?=
 =?us-ascii?Q?gD8Yzt6WiWnOwpu3HoI0tatDMWYCaZoFyzME3MOWzdJMQV5u++Cr4D4pFbqT?=
 =?us-ascii?Q?AjZFqUNkWqz1x8XUaoxsIod+jqZ9SFD61DDq1gM42xMpO7r+STx3VlyhqNhe?=
 =?us-ascii?Q?UZlwEeCCuhwoYrbZyfb2Jw3Lhslur+X+JN2lJ5PtAxwCX8vAtVeDEH9eWXoe?=
 =?us-ascii?Q?9VvJb+FMa679j+qeb6qDLBy3T0ACuqqkr1H1eGu8kBA3I2OHcm7BbIvaFczM?=
 =?us-ascii?Q?K+rDD+bAKC25fwIeWZh05OWxPowKuxwlOZ5PAT++5vk9DIqhmL6Cj0rk+Op9?=
 =?us-ascii?Q?fljfe5ON9+0ou5hkYU/66KCCnLOHNQU0TZGtcjG0CE4JdNm8CF1RP7OLmF15?=
 =?us-ascii?Q?/KmKWjsKdHmQUx8uIgBhBwLwMJDOg/3Qmwn/IkIABhXYHu0g4h5nN08zZjvc?=
 =?us-ascii?Q?DFz+/tP5V3L33Cw1UJcQLqorDGQ0xaEkvsj2cfmCxc/iiwM3iOwb6yAECaR1?=
 =?us-ascii?Q?A7B+AnA/gsA7SdLpWWKT7K2BoPp34y/VXTRVjB0FHrtLtuBlT111lrtHsms1?=
 =?us-ascii?Q?puKG6pLcXN5ajEw85HvmWaNhdHcv2NLABojIFFZ5bRW9H9AZiarwO/Tlzsca?=
 =?us-ascii?Q?C6a9lr9i2mfq0nqE3SC4SlI23QthSubdBjABjFOi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b6a788f-1cc0-4e17-684b-08daf93758a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 09:35:33.2009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ug8OMh8neAIEIUeWSVGQ6GNG71M5FbdQPUx7OmExWN2T+2Tq72bW5m9BTks93QkMhnJeyPvFPhlNXVA/5+ijzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6008
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, January 17, 2023 9:50 PM
>=20
> Allow the vfio_device file to be in a state where the device FD is
> opened but the device cannot be used by userspace (i.e. its .open_device(=
)
> hasn't been called). This inbetween state is not used when the device
> FD is spawned from the group FD, however when we create the device FD
> directly by opening a cdev it will be opened in the blocked state.
>=20
> In the blocked state, currently only the bind operation is allowed,
> other device accesses are not allowed. Completing bind will allow user
> to further access the device.
>=20
> This is implemented by adding a flag in struct vfio_device_file to mark
> the blocked state and using a simple smp_load_acquire() to obtain the
> flag value and serialize all the device setup with the thread accessing
> this device.
>=20
> Due to this scheme it is not possible to unbind the FD, once it is bound,
> it remains bound until the FD is closed.
>=20

My question to the last version was not answered...

Can you elaborate why it is impossible to unbind? Is it more an
implementation choice or conceptual restriction?

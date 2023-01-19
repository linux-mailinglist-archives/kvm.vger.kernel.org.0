Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F8C67301D
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 05:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjASETV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 23:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjASDqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 22:46:52 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C4F4DE32
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 19:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674099908; x=1705635908;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aulRhudl4bS+GMiachwi7jrbOWpvKnnQz5u/Sh4+u+Q=;
  b=h7/PWnL/W7XXaDNpuBgUFFDC21LDdjDxBFcdgWcWLpgj1RVeVY55nJmB
   0DKWm0QZ50tcCwlDmy1HmxLvcmGeYBFbMwiFjUbS+RfA8lLieaoHjBKKE
   hgbtxlJt82L64Sq998iH+bPui5uifH1Hl0XGFAr0kG02MJI+E5uc0iTAw
   TwaultyGXlkFQnDWFtlRetJrfbscr+t51VFbKs8CBehexDfhO3f+v2zJn
   eUeQbb1kWvqSeg/bclu8La9LJ7o6e6vPg5bM4mbrdt/8YMPCxqEQMW5J6
   8hKCW6mJArSVD4raF7z1+D6JROBBykOckmZd1rKbUmjbkmWYnz4GHa9zi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="304868242"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="304868242"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 19:42:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="609919650"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="609919650"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 18 Jan 2023 19:42:10 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 19:42:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 19:42:09 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 19:42:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiLUgxSbIsw69BvTreBFWs6fUf2wm/EuqgNAs5g8EM/P4jzttfcZo8qExejWVJBeLJN7yXJFS/vz6/HKZP83DjeOXx+J4tSfKF6VB6qhqH3RwqREHtIiMKophkaPplx8cAYLkRwMkjizsQYM1x61gnI4jdQ60ogM8rP7NoaxZ6M6QDWgHjFPsak/jGYW50VaTTKsbq/UG1yq3iELfr5pX8P5OWjYu4ZVlTfW2HVexO6dCOKyMWZy7DlLIls7xPYh2PVj+SqVei3zqRIRJAspWS9jzskWC/aiR0gj/0OXi01gSY3uuAXhnyE5RF1G9b3cNpACasNszy+KAMOaEEelIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aulRhudl4bS+GMiachwi7jrbOWpvKnnQz5u/Sh4+u+Q=;
 b=h9rtQEqHecObSIniBeD0qMsRduBYGrnCzD/vS46pVpOsS8zcebme+Ka7Ukog13QvtVDc0JTvFHwpCOxtGTNTnE0EfT4BGatBOXrF+AmWaN50V1QZZkTCrEV6m3LnnkHeNF649N6g3Grc7OQKpRP5tdM2/sFeeRXNpokh/uGqdVmiO/RR1km/YFWYdBNpK4i3GrRIO5m6KkG23KBw5MxNt1UeILn7n5rtV/payX4uZJF4PEfE8xrKcD97g0tzMwDid3Ytg/Y49kll3CF4RoXoh9XIPIujGNG19diVe0a93gqLg9TqDZjkwBnw9L4coZxO32lHoE3/Bs7NI4wulqZhSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB7374.namprd11.prod.outlook.com (2603:10b6:8:102::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 03:42:08 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6002.025; Thu, 19 Jan 2023
 03:42:07 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
Thread-Index: AQHZKnqYgxUzhzjIGEixJ/hIzOZ5Sq6j6vbggABIPwCAAOeakA==
Date:   Thu, 19 Jan 2023 03:42:07 +0000
Message-ID: <BN9PR11MB527637735DDEAEEE742852968CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-9-yi.l.liu@intel.com>
 <BN9PR11MB5276941A0F5FD7880DD1C41C8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y8f5lEcYaL6QgiDD@nvidia.com>
In-Reply-To: <Y8f5lEcYaL6QgiDD@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB7374:EE_
x-ms-office365-filtering-correlation-id: 2ec85f18-1405-4c05-f459-08daf9cf23a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y88X/80UB+w6TXki1Nvfw273YSSsv6UaZznBC3aQ6gecJYuP7q2BKe76/JDa/5zdDa+MTBUEiUnQliMAK6te2kWIvQx5TngW8FOV8VK/YnSZVm62M/nBYdOf2tCKi+RwfNCmTGqyFEdYKkyh63anBWXKQaOQKMp2oPA6TXWrtZiazpQxUm93W+q0is/wBhxyN2o3Jb5Qi/GnWd88Of3UOZWyIMYWBC4C/KwIMkD4q8FJSsibo8+fsyg+MIEpoFx47Y6nUQchZ+24UAfYxMzD3Z+mqudAlpV3FJ8NakBk59bkUBKoGribFSKCNRYLvsTlrwdUYktdYOp5AzcUhCPGnJmVKXHmlW/z5hYZxGqx4l8Wu19bFYyZ/V/Z6vpzHs4UvogxZev6Bl3qpoYsF0/D87gUh3InUstxDqYZAiBGenRsMMnc8a4gCzfwyKKFKG/205x7Io8pyaIIoqlqsJ+sDM/yX72hipsb4Cc2Lm0lmu14GPpIf4b6D1qjf+oS3DTotUzgt1RYLdJCWHTvlggETuOkqa3U3LIu1NlHMKPt+RqzvEDwqvsSS8WpVEH1wXu9AWTLrc3jSA4Hag4C0WZv7YZidtyBlkfpzrFrvXgvNfXEw/hwiLHAxrGfc4A0Qlx2N0KPofm2052U/+CytikzP7ahwmQdo1MRkr7zBsN5e0wP+YNFeA+PAu+XmWyt+tMPpvCoyj7tLEg6ulW7NUTkwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199015)(4326008)(38070700005)(64756008)(76116006)(8936002)(316002)(66446008)(66946007)(52536014)(66476007)(7416002)(8676002)(5660300002)(66556008)(55016003)(6916009)(2906002)(83380400001)(38100700002)(82960400001)(41300700001)(122000001)(33656002)(7696005)(54906003)(478600001)(71200400001)(86362001)(6506007)(186003)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FsqO4o2eB8WfDUyF3F+hfOKn73raadE9nE+3C8y2XADdy7hchUwG94QKg43k?=
 =?us-ascii?Q?sAYem4CTLn95++l+n3JlZz/pw6MKDGmfODB8yGUZ72Dn4yhNmar7h/xRuTOj?=
 =?us-ascii?Q?jLo59wveFRCm8G23cWz0WtVTT2Mvof5Zuq1G+wRcGvWTrjuL7b6cC2RQcKWC?=
 =?us-ascii?Q?tlseZLJ7VPJx4ApNZATddx7sJ9dKDf0npZO7zg6p1jXieAROEQ4yQV9jy+hA?=
 =?us-ascii?Q?JMBhrzo/DjXCmMtEPFy4wRreTzWPM2T+xZRh9aWy+Ss5ktBwxFUIDxzvopbD?=
 =?us-ascii?Q?TD3T/ULX9WRKKtLZF2h3oRfmT+DkCixh0ndTVsnUjBtZEDm89znGss7hBt1q?=
 =?us-ascii?Q?jmXvKyFXMHGuaQ4hYJYqcjl1OI4fwn8O8zq7YULwCVug7RiEcXB/S1LuS0gu?=
 =?us-ascii?Q?bLQ91H13MdediXe5vsIZUyz9v/f8AmiDCIsVihcnz+cDl00OjXfDzqIVukse?=
 =?us-ascii?Q?xWuFqZWE133r4cVYffBsH9Dq/BabnZG82gds/s/VuYY04+yelisAmeX2DmDw?=
 =?us-ascii?Q?4HD5bjfJx9KDft+X7//a92nG+8Mbr+Vpebb39uVUPDgwOCSMrT8M2TvDiFph?=
 =?us-ascii?Q?AiNyqpNTAUI/UhDn2MAqF+C04RueBg4acl/WBK/Ju/TRzN+QFto8J5Ln2rd6?=
 =?us-ascii?Q?LEKMVGzN2f1U1Vunjv0iB3c1vGLtnKqsI4quKASt4fSzYBEQa5PouzGb0OXm?=
 =?us-ascii?Q?NGwgogND6HTAiUTAoEdQqSImvjM1BDHxFllZoNev4myPalfxI3xh6hsPSuyx?=
 =?us-ascii?Q?hStI0TPmOtU7Nd2e/dvEwygp5ETSt0ONBugxfqJk0XhQh96CzRB3RyVAFy+I?=
 =?us-ascii?Q?aEYtuQfqJvr3xVWbPKF9H0/E2EuJI6NnTIzkT2qY0Chz1oCUpBz6x+bgDR/e?=
 =?us-ascii?Q?Yjp4kYdWJt3m8JA2iuSL1yQK+YlHP9TlMyoZvjxROiJXQaMttCCxU/JgH6u6?=
 =?us-ascii?Q?u1pc+XrQe8/HYavZPRxz7U7Pmbb7/uFpeioLKDZBfYgJAvU3ZuoiE4jjGBWl?=
 =?us-ascii?Q?aj8rqcPYklMi7e0xG2kk9a++LVJaPtVEOkSf1op18n0+mijIrCBNqBr2yxST?=
 =?us-ascii?Q?BsZty2idD9lPgD6BnGZ6erJIuOW8IqRVDsf7J5sIcIxJW/rYP/MRREr3mG5K?=
 =?us-ascii?Q?UbTjbzCOrMuJz4y2NVhVZm43Wn2jwClQtbfq75cx5VrchbjIaCV1r250EfH5?=
 =?us-ascii?Q?8g34Ze+ATceVuU1eYUAtocani7vMVPRmFHGHq8MV1WYWOaFqV8+Yp6ZSKYbH?=
 =?us-ascii?Q?xvJaohKaxZlxiHevHegwsvJQHuoC9sYKNcFJH3I47WjvQp7kkM168o/QMJUW?=
 =?us-ascii?Q?6nrSMcvtv6ZrgDkT9WgQVaq34USjpjTyxNtlbeQioOJB4lFYvhS3OVdxupDE?=
 =?us-ascii?Q?p7I2vCSWux3741Q5ZfOeTpdi0A2zrzIb5GoB9QtMPPcQ2hllESNeu5BreAJJ?=
 =?us-ascii?Q?ggc1ikWjRbfrD1BXESqVuIn8XNwP0qO5eZSjBJan0wK7f2j0SFChNYe13X7C?=
 =?us-ascii?Q?cl1+VjLQc/6n/T5FJRewAN2qAa9mlo+5dGZrNnpw/ON7JG12Q5FZyQ5aFJZC?=
 =?us-ascii?Q?PauCeBAtmUd+Z2+jsGkRir+GgRaWcdvDhNiAdOF2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec85f18-1405-4c05-f459-08daf9cf23a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 03:42:07.8077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g5BxMknq6eMWQP8x3UmTr2TPukaJJwzMQEcLEvXyeqfe4isFL88o62b3UGhOxSU/++6HeTKRK2HRiijdItQx7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7374
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
> Sent: Wednesday, January 18, 2023 9:52 PM
>=20
> On Wed, Jan 18, 2023 at 09:35:33AM +0000, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Tuesday, January 17, 2023 9:50 PM
> > >
> > > Allow the vfio_device file to be in a state where the device FD is
> > > opened but the device cannot be used by userspace (i.e. its .open_dev=
ice()
> > > hasn't been called). This inbetween state is not used when the device
> > > FD is spawned from the group FD, however when we create the device FD
> > > directly by opening a cdev it will be opened in the blocked state.
> > >
> > > In the blocked state, currently only the bind operation is allowed,
> > > other device accesses are not allowed. Completing bind will allow use=
r
> > > to further access the device.
> > >
> > > This is implemented by adding a flag in struct vfio_device_file to ma=
rk
> > > the blocked state and using a simple smp_load_acquire() to obtain the
> > > flag value and serialize all the device setup with the thread accessi=
ng
> > > this device.
> > >
> > > Due to this scheme it is not possible to unbind the FD, once it is bo=
und,
> > > it remains bound until the FD is closed.
> > >
> >
> > My question to the last version was not answered...
> >
> > Can you elaborate why it is impossible to unbind? Is it more an
> > implementation choice or conceptual restriction?
>=20
> At least for the implementation it is due to the use of the lockless
> test for bind.
>=20
> It can safely handle unbind->bind but it cannot handle
> bind->unbind. To allows this we'd need to add a lock on all the vfio
> ioctls which seems costly.
>=20

OK, it makes sense. Yi, can you add this message in next version?

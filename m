Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FC86BC5EA
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 07:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjCPGCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 02:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCPGCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 02:02:18 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30774A1F6;
        Wed, 15 Mar 2023 23:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678946537; x=1710482537;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=buW8bwfJs0Lg6ouU2+JbzEfvoNll71WYjxW9UzlMFFo=;
  b=DAEW7YUMheOnIf5YjXzNJt/xPoai1yRGpCzXhoHJv9NWyzvjlZ1CMlEv
   Y9IvcCQPbHRR2TEjceGXXnOImpWxTBQfGC6K4BIsg6PFq0MWne0ILNJP3
   WHsZRVyXot6ifedpZrqoYYjUT8JHrbDG0H2P729Qbl6ZwpVa43xBAsey6
   5nsT8Y59HoSUcTzOk3whIRS6iPXfAdvfVmHAAQcBwy/+h+5wmOd1X9NFD
   7V4BLdLPv1efbUNg9hbpVh1OiLflFQfFma8VgZiQJ0kpgHe1ycSPAZLq3
   ty696hYXDsLgtqXNOsaJEU67N2e5jGkrsW2qgdrI9lc2n14ClP0AAaS1E
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="318296855"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="318296855"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 23:01:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="629735936"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="629735936"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 15 Mar 2023 23:01:33 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 23:01:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 23:01:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 23:01:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b04EBbCT+ysFq5flMzsw3zn24lvbguFBWABPYprks2ZcMISIeRomrAxYgzpV/IBMAoP+wJuP4DqKRyDz8pnDRlxi6eS0jm33PD5KbbPrqFl+aKixhMMTc+lhtSIbL4VIhZlhPSR2ta/lStRhG3Y1kKjLpDuZH+GbM6Jq4C4bvnKmqVQKQvM5EAFG7MbATMvKAX1Ue2T2fiBTcpXATpOUVbwGhOadqDoXLB3SuCurSqX08tAmsrgyPO5yksZW5cV7Vf2/X35cOeyTZAlz74k6/h0GKuQwhrVOLnkbiqNqQdXBvq9Vg36ReXaKd2/zpHq/6O4bghGAeDVPPDGRRNFh/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uu7TR1P0jVZFVB/nzhTuZby34ohr/hX4G/xWc9tTr2k=;
 b=FkIC0g5EYYv8jD3BOfst9Bos2lrgt0aIfdHBZfSQJQ87KshGMwDIQp9EzDSraBE07mHTQKpc/TlYNyWNMtCWUtynO03p96T0uRwdYLsSquROwvQOSpmCLqbr74q/i1uClnbsmR00RqgpeliHdFGlUJ65r06XfzwZL7RFE8CoTIzC7BISnl27QWdHb478kHtqokcLHHrjflrXuKQb2KgeoDTHBw77NmxoVNsDc2BYfdnEK93RETaJAOZ8fnE1OXPl/gWEzrdXVtZ8rO4BqEDFfa7Dp3HhIfUrNWaY4zbdzWzyZZPSVp1I4UpBuwY+a10v9dqEaqVO0SJNu3zuHMxnqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB6957.namprd11.prod.outlook.com (2603:10b6:303:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 06:01:30 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 06:01:30 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Topic: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Index: AQHZUb/VywVS1tWF6Uet+ZnBHpWUv670SikAgAWuFwCAAReSgIAAV7uAgAAE04CAAAUYgIAAJPWAgAErJQCAACyPgIAAAYCAgAABb4CAAAGLAIAAAnRg
Date:   Thu, 16 Mar 2023 06:01:29 +0000
Message-ID: <DS0PR11MB75290A0982D313EDECDA066AC3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <ZAtqlnCk7uccR5E7@nvidia.com> <ZBAuXo166M+z8b3z@Asurada-Nvidia>
 <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
 <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
 <BL1PR11MB52710B5DCB08214EF4542D098CBC9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <ZBKp9BXwX3+txIEC@Asurada-Nvidia>
 <BN9PR11MB5276EDB7E88E9AE5F059C8948CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBKsldu+EKT5jd98@Asurada-Nvidia>
 <BN9PR11MB5276229F63C9BE37CC8542868CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276229F63C9BE37CC8542868CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW4PR11MB6957:EE_
x-ms-office365-filtering-correlation-id: 327fd22b-c00f-4d59-2770-08db25e3e2e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LfVnejA/dGtlXz1SquZx7uhhMNjLM8DIt+E6wq4moFrEnG6utJHoI2+joBUtHshtKy1HhN6KraSq1eOvYRZCcQEGB+LRdkGmL8LtQO4XFZGQ6m9qQZtLbO/Nw1gNi9pVGJjaZIAmurUL2P5ONkTzjVBaQKOetXz2Vi5JMsOrtol9zg3JdtDnMBnaIPRbadVSM5eyoIX3x9yPxJtBJmSs8/8JmUgS1K9J0h2IeL6CHoJRBoW2ZH9Rw7YIUT4T/Wu/+wAx0Gn9MeJRYaEn4Vjo2xPZaciaP5YPlT30a8DUoev9ly3nnN2o4peINd02wuQON53yn7qIKN4ldURHf6ng1ji7yVPz+U01RG4WTgn8ycRi6cvMEnCIMO4/OU5PERifOC3s3QcOoBsSrEvjOm/l8Aj1MSXyGawP7Jb079VnaYedAzRK9mHMvSzb3ZyAfjj8/5WTggu8rnOt9ujQyY1rekbLMo1v1d1A0dmxbjos03Frruxu1enxjAZc9Uqm4SAXnNdgzdqdFGdenlhpcPUC9Hw1EK5fMcDYwuS47majjwPMYFJ48bYtiUEIUIGgxrjTSKgafhyvbEb7/Yh1QA72GLv/HFRqULVbBL5RSKriLTO7xtny8PVRRIJSD/w4H67gvkaJb4bR6Pu3iPmuENGWcqUGJAefaKqR9MsBKw7elc44Z2UCOuoLAI2sdwVtqobu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(366004)(396003)(39860400002)(376002)(451199018)(7696005)(52536014)(41300700001)(5660300002)(7416002)(8936002)(2906002)(38100700002)(38070700005)(33656002)(86362001)(122000001)(82960400001)(71200400001)(478600001)(8676002)(76116006)(66556008)(66476007)(66446008)(64756008)(66946007)(966005)(4326008)(55016003)(83380400001)(110136005)(54906003)(316002)(186003)(6506007)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xTagmAvc8UmsNrtC1FuWsO+1h/t2amGkQXVCoTfP6H6xEyNWCj4l9zRycaBG?=
 =?us-ascii?Q?AGtbYOqISrbP+k4uhpYlLsYA0xwWJm1dLLIWGmgi7IcgiTKJ6SwQW9ldaNJH?=
 =?us-ascii?Q?GruY4CLkcLGOdV0dt3kRuYtdV7a9LH5T6tyJNZ6mGQQnMGjidI6Zb64yh3qY?=
 =?us-ascii?Q?2FWhyd5n9O4mNFzMrPYQi6DjR0xVTKsFR9LPJYnpNHuio9da9VvBW7moQQaM?=
 =?us-ascii?Q?zGpLVlRwrc4vq05jhbeJ+w5VRetDPxJC9Z9MP9kob+oIsoj5MdKMGOsGh1vQ?=
 =?us-ascii?Q?Z9PwrN/O9JIGh5psvj9fp/Uw3UyLfD1pqDDncCoTeFmGsRy7J3LgohsVswhi?=
 =?us-ascii?Q?ceEiUfCL+CPCCy+XkTViYYbOUQpd/Fm8290UprhdVl2S3ILvPgDm2TFVbURv?=
 =?us-ascii?Q?opqi/O43bnYi4Zo0v+bE5uromrJsCiLoXMVcnKwkZ0lt9pnXNdXbyQYeLr/X?=
 =?us-ascii?Q?lQlWnZYnqPbNOhvRg6BmLKBhEbCehW1gu/yjYE+UsJ2aVtxTH+14MS+t21YZ?=
 =?us-ascii?Q?KWFvArYJ1QUN9UUvV8+SyDITKoDrYe4Fjw7tnj1Y8HbiLSHpArWZ2Alae0sP?=
 =?us-ascii?Q?6aTmH42eeKKGxW/HInf68xOyDVLpGS3Y2+ulaJ5Z68pn6f31oAWrfSSA8NW1?=
 =?us-ascii?Q?qpDsQVwnUGtUMI18M4VeGdCcMIE3dQvLD+A9JF6fpZ/9xC/03BxOEyjE+uXh?=
 =?us-ascii?Q?3RDFejZHQrlFNYXpa6FPVoCKr8Rp2WR+y1lJjA9il4ezrdjc5w+qivKJgBO/?=
 =?us-ascii?Q?r8/aVHGHLI4OaJ66dFJWtqDFohxqNszuREajPZwPcTNuv2Y48KrBK6jveFHg?=
 =?us-ascii?Q?5HUe3SaOYYv+JCkmaq3phOwkGu/pXNDABTm4gdZ5ta8IFPcQksvjxX/jRqir?=
 =?us-ascii?Q?DnKqifrPuPsmumEGAcw+tncLCcy4/I77dgyBK7upnAaxqmGSWfm/RNF+YTOx?=
 =?us-ascii?Q?c6/9nct66+M/jsyRWwf08zz0sx5Xkdx6PBbKWQRjQByQU8NS/mY/cXhntiDB?=
 =?us-ascii?Q?mdXsJyNLjkPDmynF/BsvrBWKVx47r5khvVQMHqX0J3K6dfuBSvKFz3iI/kP7?=
 =?us-ascii?Q?EP01Hj9X0y3Ma18ERUrjSl75T8Bw+qI0033Wip6URtL3lY8xuEhdkcTPeDIU?=
 =?us-ascii?Q?sPJoQ/tJWbtnEd9aMfZukmyVf6fa3v24o71py/xcWk9Z2VAWCp8UDW80yzs5?=
 =?us-ascii?Q?Ieg38pgbYsmOTJ/qAtHoMO96GRk8PEk3am0aX/6Bz7YhawD6627nwCj0B+sL?=
 =?us-ascii?Q?ExDtfuVk2UMotTXQYR4rbruv9JL3Eb+KxYOLR158Wi74xNM5aVZ26sh9d0eo?=
 =?us-ascii?Q?mJmEd8h+cWay08EVM6J1udaHm3rUU7SbriiJ0O0y7qdHfi2eN5BC/xG5aLG0?=
 =?us-ascii?Q?L63urXAPE+6W9Q9oj3nK6YevQGZB3S+qwC/JGdkXKfWUm2eoDKGrsNpCC4LA?=
 =?us-ascii?Q?8m/yi90UM4TdBkIHm7eFxsmCT/jIcVgYhVap6MPh+/jGPWC0rNSAoSY5cV5V?=
 =?us-ascii?Q?oXKecN9AMNqeX3x5kK2NbQ6Y8/94NAgsGTuFelcuwRC3c+oT1Ta4d+xZPb1k?=
 =?us-ascii?Q?W1LwcWlh9BdULMiACDsbybhmCrFtxFvxTwoMMRm1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 327fd22b-c00f-4d59-2770-08db25e3e2e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 06:01:29.7373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aBlBJ2LP26vwMpT2FgHkdFbn08h5A5U5hQL/ul0fQydEXLtPTBL7oRwR8jQPkFP843yMRKGup069r/v5QvNS2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6957
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Thursday, March 16, 2023 1:49 PM
>=20
> > From: Nicolin Chen
> > Sent: Thursday, March 16, 2023 1:44 PM
> >
> > On Thu, Mar 16, 2023 at 05:38:41AM +0000, Tian, Kevin wrote:
> > > External email: Use caution opening links or attachments
> > >
> > >
> > > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > > Sent: Thursday, March 16, 2023 1:33 PM
> > > >
> > > > Hi Kevin,
> > > >
> > > > I've fixed the other two commits. Here is the one that I am
> > > > not sure about:
> > > >
> > > > On Thu, Mar 16, 2023 at 02:53:50AM +0000, Tian, Kevin wrote:
> > > >
> > > > > > [2] This adds iommufd_access_detach() in the cdev series:
> > > > > >     "iommufd/device: Add iommufd_access_detach() API"
> > > > > >
> > > > > >
> > > >
> >
> https://github.com/nicolinc/iommufd/commit/4110522146ca1fc0d5321c04a
> > > > > > 097e2c9d9e26af4
> > > > >
> > > > > also add a check if old_ioas exists it must equal to the new_ioas=
 in
> > attach.
> > > >
> > > > This is the commit adding detach(). And there's a check in it:
> > > >       if (WARN_ON(!access->ioas))
> > > >
> > > > Do you mean having an "if (access->ioas) return -EBUSY;" line
> > > > in the commit adding attach()?
> > >
> > > if (access->ioas && access->ioas !=3D new_ioas)
> > >         return -EBUSY;
> > >
> > > yes this is for attach.
> >
> > OK. For attach(), the access->ioas shouldn't be !NULL, I think.
> > At the point of adding attach(), the uAPI doesn't support the
> > replacement use case yet. And later we have a separate API for
> > that.
>=20
> what about user calling attach twice in cdev?

In the cdev series, VFIO only one attach is allowed so far. If
vfio_device->iommufd_attached is set, would return -EBUSY to user.
But this does not prevent the iommufd side to allow attach twice.
Nic's replace series would relax it if user means to replace existing
attached hwpt/ioas.

Regards,
Yi Liu


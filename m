Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEAB72E5BB
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242915AbjFMO2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239831AbjFMO2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:28:50 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378C2199;
        Tue, 13 Jun 2023 07:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686666529; x=1718202529;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u/B62aMneXfn13ODyxBxQ97kf0uMlbP8SPvDvDJDe2g=;
  b=cjxlogRmu+73ZHKCGKlII5vYlGqNx0Exrhf/JsGrqI3oUla3+gxZN8SK
   WIO5N2D2b7YagT07/7A+s2qysOKJT392rGSbKb3vN9UvuWV8r0xQK7aP+
   WZJPVcESR/lUUUyq9t+jjqwVYKOxwJIcIbx2zsFtctv/u8Hoi6N21L8MQ
   Z32s6SPXQ9baEeAK2mfAmYbNiWbAbowIF1eroLuiSZH5/kTul6jAcUx54
   zzQaHkjy61MWVS/pwJs0BRKgJ4nwOtaaNpcM1nJ8kiDcnhS1Kv0YwWjgL
   ymIPwHuicSY3rZvwcEg4lfSmaezznEeCNfbXMxfEDsoMlWKz8JACXTeRI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="343036630"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="343036630"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 07:28:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="1041786503"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="1041786503"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jun 2023 07:28:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 07:28:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 07:28:45 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 07:28:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAbW0/sJbOtMresp4wcnkCQuMLpSkKGw6pJKFzX3VqA/MHFLPeXLChrJ3ngfoqo4y45QmgmqSzt1Tbco+t0TATh7neRNFPNa/MLJzSq73PPoKEuwmxRWYDt9k987miVXcxdatzgPqJhJRmCSuGuxEumN/qQ+qHGLp+5ysa5YcE/9ypDYnY0XmRcS9Q0zpZEA2V4DHNQXDOq/XeYqaUqWhe68AzhhLWYibrxzXcNtfDga03SQZ0pJ/59L1GRJWFUSh6jh0a+UeSErmtrovWzf3B8NyYc9cUjQaLY84+0bHzCWGD1rFvWQzTdGWPyVNg+kLfFJowD9IP0wJUOOFh8V4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4oB6c82UjfSWaPGOcoyYeJ1pn5uvDNig9qXn7hwMSig=;
 b=gV2nM+8Owt4hqvECrvsgAkqQyJeowCetVollUOrMIhyK1vKj/gLi8rdqO222LIOB3nWSS0jzitU655Q67kpxVk+CZwwVKFp9radELDLOppAGbVgWcJqFo/FRR7grFv344EHUhUZ/Kujl1YLzkt/PagCkkwGbkb+AywC5q4tULMMFuxA8MBd46QCLg1KB4aOIPzHO2svOFXxaz6+eE2OpJ1cj6EyMUaJbKkJq0VsLmTX9eKze1aee5wqngbICOtKcORlS+JXKDEW1bwJxjGlk0sd32OmGf9/acMjgXOMPneE53s11O4YkaZJ1IeYTPjwJ+sadevC0PAljW/UwKxxd5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB8396.namprd11.prod.outlook.com (2603:10b6:806:38d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Tue, 13 Jun
 2023 14:28:44 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 14:28:43 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
Subject: RE: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZlUw0PINbjPidUkeXtdGCTAzTl6+Hz4gAgAB6suCAAI7uAIAAAkAQ
Date:   Tue, 13 Jun 2023 14:28:43 +0000
Message-ID: <DS0PR11MB7529F0A41AA58AE37BCF8458C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-19-yi.l.liu@intel.com>
        <20230612162726.16f58ea4.alex.williamson@redhat.com>
        <DS0PR11MB752985BA514AFF36CA3A2785C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613081808.049b9e6d.alex.williamson@redhat.com>
In-Reply-To: <20230613081808.049b9e6d.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB8396:EE_
x-ms-office365-filtering-correlation-id: e14c8568-c4db-4750-0eb6-08db6c1a7daa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GomwYT7TelAc1K4f/EtRviguU7oVGfUFq6jZORYdpg5w5HeVktfiFJcI3bSHH6blRHn//U1mSrJBFIBnjX72T+RoIK5v/gacYb4si2t2S3rku/HneFyACQohxxCsUugFegkAGUhZin4rrH+kez1HRa/AwLVIF9QpF3RBE9s9h+xRZWq0JHAxaJZ8zSQcNqzir4lHpjAon/wPcqjQqVz7ckeJUDhFVbhrVnDdKD9cQecx41gCWl23KbEBM2kWc559iEoR7ktQy8xIYUgLf7DnlqmBupGeq6gFOOVu7TyhI+ALZRf6b6RpqqY1BPikbTIo/8dOEkMCO532qI8OWmSwYQRFjsQxCw5ZEcaIOtibXAsJgeos6b9fUHGfMa5Wvqe/iPeqlCS/ksigVGl/Sp6rJiv8C9BnB//fqPkOzREihLG8L8aX9l6/yegg5vJesflVOwKEl/MTJP+lcbmVnXAPPa/J1m9JKwap0TSWK0EMDd90iWiDzOOBNJ7YPSDNgxuNv+QrWsk8v+jcNqussiFXEZpvWfi3fuDP2AU0JdlnYMGkqUTljzXZ87alBCGV0HivJRh+4YPAHkj/Upk/QNH2IAi3/trKVWrtyEX2Tj7V58GzY3Qjxbf2eVFrA3NUD69W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199021)(316002)(7696005)(41300700001)(86362001)(38070700005)(7416002)(6506007)(9686003)(26005)(186003)(33656002)(4744005)(2906002)(82960400001)(122000001)(38100700002)(55016003)(8676002)(52536014)(5660300002)(66476007)(66946007)(66446008)(64756008)(66556008)(54906003)(76116006)(478600001)(8936002)(6916009)(71200400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q5eHnGSNT5t3dvebLd0f3TJU+BPdqtY4ZM72ysub7I4N0Jt23vmjp3ESTZaj?=
 =?us-ascii?Q?fu3KYP0VMcE/dOeK5QcZj7USDIe+7/OXtScTQR7r5/mRbUJ2VyCA63dMe06r?=
 =?us-ascii?Q?h5ob4+UYV/aQf8wUYhjkq+N0Q1eR2W9QwQjMimoDFZjWNk2HiCXlIDzhkdKN?=
 =?us-ascii?Q?9jrqG3w5kPyXkhx1L5t83ofSDLa4YllutH1+1bSiD9BWmFZzikGVxvcu7j2h?=
 =?us-ascii?Q?10mbEBxAQSz19Nx0hNEhPKY17JBU4RSYzOSPNtqxyghQPXrGDbqrtwYdbyeX?=
 =?us-ascii?Q?l7rLIi3IdCnEbXSv4KvZnUA7Xhq+LL6diIIz7Jgarufkfdr7XBZSKhlfdCbM?=
 =?us-ascii?Q?3ARzahR1bmopgcRhNrei/DyM8vvD9LtwlbfflaBdnEX4ta4xMQ/wVmhMa8lP?=
 =?us-ascii?Q?JVM9ltx8A78yyr0Z5Uw2kWsiTT2qm1nUp3dlfgw2iIN/YIYHwuPStwUHHjwm?=
 =?us-ascii?Q?oMO8tjGwmFktvZaKI3NRQm3vj8DK41l99dU794GVnWyXP2jhDvrj2iI0TcWa?=
 =?us-ascii?Q?1zyw6SBgRL+BrOaOk+VNnoBI0ONqRA5f4AXiKeRl1j37zo/a0ajy0ztBwPCt?=
 =?us-ascii?Q?QnNhzUcoSBecLZDog3S1yqGufGL7LCTLzqkvoDsrnQ0OamrSsQ55AI5n+W/Q?=
 =?us-ascii?Q?U7g0nIgEAROaXtszwPd+SSbcpLJaVfoR9+WAZsvJaTPOiBYILT3Ig0uDTvvp?=
 =?us-ascii?Q?ECcxSln3/C9f1mQAiLli2H5gleljZ0zXdROOXPQoT9K+NXgfpePOuBOO03W6?=
 =?us-ascii?Q?dY+yKiYt+bGs4umYfx/8wZqLyAFWSsUsndxxuRUQiShhnFZ6fhFPP/Hajfkt?=
 =?us-ascii?Q?1s/PsHacjlPzQN9/D/GaTbe9jpJm/3smzDieEo8C3DanbckrJ2wDNPwIg2KS?=
 =?us-ascii?Q?OXdm7AnMu6DJiI3q3+FV4pr41JBuqOWysivygsDIOUFPha6gVuWa1vu8GPa5?=
 =?us-ascii?Q?plMoqOhZzoFD36wzXizR8nkc4eEyxWG+OyaLn3vQl+vXrPRR1RsANO0S3oNs?=
 =?us-ascii?Q?O7K6/9KnQ3tknXom6HKBRPa/ALgDMlFIg2VN2pRQBhNfjEs6sLkCWsvxxm1k?=
 =?us-ascii?Q?XBYyUPZBuaeA3EURSyl8VzJxRbFY9gYtUne3UqKQpnzHJf5NzMs3zR6ELEqi?=
 =?us-ascii?Q?3b/vCja+vYeEmfV5wAjVDDZmaf7SBBFgNk0Olycf9SFFo4/sofzGpFy4itZb?=
 =?us-ascii?Q?u+JBPVu5VYTNyb4cUjHAh663tAaG+ncmOc7Ncqb5W/jcDRAkTc4/QH0bfjlI?=
 =?us-ascii?Q?4pmABxKgEupYPJU3t5KswXWBt1dST9+86dwW3Ull+AZjIMDzdABSqqKJXLcg?=
 =?us-ascii?Q?mzbtprZBa3AY+4o4QvETH5fMRTvP8znmM7jycxFrxYezTApSPSTjyMdGelZF?=
 =?us-ascii?Q?UL7uNU54/FGp1XoILIlhKMh49IhqqwyV+hM5HDMqyihY/pTe4skCTG5i6bHF?=
 =?us-ascii?Q?EXw4Wfj0mVKB/y1vJiwGesAq00g+fDic/hqELWnUc7c10rb/2oA6ekPD3oBC?=
 =?us-ascii?Q?/HTUtrhVQqhy/aJVpsxiX+HtTFw92i4h7d6QXtMFOyqW7iJVHCf/Kbn22Av2?=
 =?us-ascii?Q?SE6zo9YTaoLVL9nuMcnSC+IvVBQJf3Znwlnr8w+5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e14c8568-c4db-4750-0eb6-08db6c1a7daa
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 14:28:43.5989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X1Oa9gTIW193NUnsUfH/BEN5osFcItbgi23r2eU4wI89MtD/S97crrIVdsxvwtAMbMhw9MT/2Y3tv/7s234d6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8396
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, June 13, 2023 10:18 PM

> > > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > > index 83cc5dc28b7a..e80a8ac86e46 100644
> > > > --- a/include/linux/vfio.h
> > > > +++ b/include/linux/vfio.h
> > > > @@ -66,6 +66,7 @@ struct vfio_device {
> > > >  	struct iommufd_device *iommufd_device;
> > > >  	bool iommufd_attached;
> > > >  #endif
> > > > +	bool cdev_opened:1;
> > >
> > > Perhaps a more strongly defined data type here as well and roll
> > > iommufd_attached into the same bit field scheme.
> >
> > Ok, then needs to make iommufd_attached always defined.
>=20
> That does not follow.  Thanks,

Well, I meant the iommufd_attached now is defined only when
CONFIG_IOMMUFD is enabled. To toll it with cdev_opened, needs
to change this.

Regards,
Yi Liu

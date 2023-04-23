Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C216EBE9B
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 12:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjDWK3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 06:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDWK3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 06:29:10 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91CC10D1;
        Sun, 23 Apr 2023 03:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682245748; x=1713781748;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=il3M0Z7GnPeah/8ZyAuIE0lkV5UG6elAMSDLmSRDA3M=;
  b=EpvlHr75IjxJMxrKbybtfzealjoW+NVeUVV7E8zd7A+mkABkftqCadUn
   Xqq/1D8LvA3C3i7wl9pv3aln18KewTW/7UGkAYNMZAp5dJzGQldSfp5Er
   33FM1STIpm2Fb/coLp3LjfgX2Kj9/iPHjiJUIxVbZ2bAhvX5U69+nidi1
   J551jqMaf5lRfikjp04KSx7txTdXUoTihEEpTAoXMisG9/9mPR/HNjOm4
   E3xPY0x8WnyW8cJflwyYFkLizSlDdRgtUTOZOFp2LLULRR8NOvYSey+7j
   q0Sv8acx9r0Iq994mY9wFmlHBSwlsYv3XPoMQ+6ePIKtAwfKefqjF5cVP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="349068608"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="349068608"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 03:29:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="725356933"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="725356933"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 23 Apr 2023 03:29:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 03:29:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 23 Apr 2023 03:29:07 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 23 Apr 2023 03:29:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XS4+RP0TypNS2lFHySVqL1EleB71OCMu/sryAmagqCMQCudi+WC9jpZTLZhytTKC2TE7qPnJ+EJwWTrqUP38LdD6ZSq0eu4z3mDI4Cd0gsQofadNWcIO89idfboaxs3kY/SqDlIgFV4GqWCfIWoOK6iToKYTeGtgwwsFFYEyVp+19epX5GNwlwBwfmn5I8RgqMv9qF8YxGyAt57Aqg3PUL3TtsxGfRGuNUNphVn4cojYRXw6/KrmPVEguYO2RVVebpSw1Wf1s9cHfH4viQESjcA2VsReYtB0wQhgooJALozzQJC95QKCzDhVb8fSuCpJy2pNE3qz0OHs6Hd2re17Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=il3M0Z7GnPeah/8ZyAuIE0lkV5UG6elAMSDLmSRDA3M=;
 b=lgYttT7b+rAtMbfSsS2DuwfxgXN6GfRST56gyZWpC7WHtKAgUkNxCiS9pzDDYOI9tad7+faJCSiHr3UFHwvc2cvSe/9p3luz0CSyklayPbCN/IUJjtKYgMtzqPPwa3WfRkXau6oL0CSj5ti8KBCn2nKjYeOM/eBoAvvCRM5rW9zh1e3LpTZbpS49Gyo0FJCfhcORqwxxvVUen1tiRjpda2Gj8+lqUHZ/g5pHbfYGmjY1mzlaDBbvgIoISfA8wuyVqjyNtXEFFdJSCMgDVLaJxSayjbZV/ZYPfvW5X6/HfqizKFRT5UnKT01MdNT/lVAdXM4iulx/7pYeijrja7RR7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB6888.namprd11.prod.outlook.com (2603:10b6:303:22d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Sun, 23 Apr
 2023 10:28:59 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%5]) with mapi id 15.20.6319.022; Sun, 23 Apr 2023
 10:28:59 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACaIeCAAJxQgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIABGhiAgAA2uYCAAM6MAIAAOT6AgABpLgCAAPyoAIAFAdWAgAFWfNCAADGMgIAHqkWw
Date:   Sun, 23 Apr 2023 10:28:58 +0000
Message-ID: <DS0PR11MB7529BC457408E5816DC3E313C3669@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
 <20230412105045.79adc83d.alex.williamson@redhat.com>
 <ZDcPTTPlni/Mi6p3@nvidia.com>
 <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZDfslVwqk6JtPpyD@nvidia.com>
 <20230413120712.3b9bf42d.alex.williamson@redhat.com>
 <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZD1MCc6fD+oisjki@nvidia.com>
 <DS0PR11MB7529F4A41783CA033365C163C39D9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZD6U5Tf1xseDawPE@nvidia.com>
In-Reply-To: <ZD6U5Tf1xseDawPE@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW4PR11MB6888:EE_
x-ms-office365-filtering-correlation-id: a82d0493-3967-48a9-6f95-08db43e58c62
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i9eqIg3zv9mg8BeQPtw52fyoem996go/b1LmfPYJ9RY9GvnjZa8NvclOcGzgYMEKtss53geTfyHTZmv4jreqD8q0A4d8A7+V4qpM9hUyWOkc3OoeEqAesxkE/ZirSsEnNQP99OCDHuzx/xfE7QIIADV2W3im4jJOzStecdzxjkBnNOBaH/nUHT9MYEhbvKae+W/m61VJvhz0pDskaFG2dPP7AZ0dIWFFAgVcMGRf9ZgKpEPn4k8D6RN9iYTmDMBwoRhhOInhLMbgnc2mZqRf+ObxDD5KFXx4FIEAHsRj9KBfvfDMPIwqS+5OrZznsZb1CmTvgf88016EdMcCvnaviZ9aa5jaOqQVQ83aQPUPuPhgkNBjYrXERhy1soHs8P/k7wfVDDyQn3PiV72L94kLOuvew3+o8K1Woscw5fAHrEYdhw22RF83rZgL63MzMnt0cqLsyFgoPejoqCv4YlTinj0qDNHfvqvR3nrfA4kG+Fj84NeVGkiyfOH0HrTG1+xYd2pN0qNiHhtqAab/5Az7GeBJxin0+FQXxVODZco9HsmJJNTlNAnv4Bwip9p1JouQh5p9T7/C1VqS7wfTp5RxX3GVcZiFs4ocr5wG/HHuoszWO6am/xqVj8BR4Wug5kkjFYh6DIYCcikn4/a5G+p80g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199021)(66446008)(66476007)(2906002)(26005)(38100700002)(6506007)(122000001)(7696005)(186003)(71200400001)(64756008)(82960400001)(38070700005)(83380400001)(316002)(86362001)(7416002)(478600001)(9686003)(54906003)(8936002)(76116006)(5660300002)(52536014)(6916009)(8676002)(4326008)(41300700001)(66946007)(33656002)(55016003)(66556008)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lIFywnV9uwwiiXMTK9VIumvPfvQoOLt0cdjMUgZQcSUnUzI7sHMMPQov218u?=
 =?us-ascii?Q?KGTGqlpDtNSJwbVmNnltfToonxCt51oKW1ooa9TRKidTusR8PPEx34OviaAa?=
 =?us-ascii?Q?76RqPTIZmKzY8N2jf0kK6NIdm8mQJbjtsKPZ9BMvsmgSARDVV8GVIxF29YBV?=
 =?us-ascii?Q?BVgvAHtkadHDbIIY6pOyePNGrKvgTvodiBrRLI2A+8sD5zspHl7wOyislO9q?=
 =?us-ascii?Q?lU2uprn05lv3fZ4UQRMZZsmxltnQg5p3oiY3w2/P0iQHCUvc/azTa871QSoT?=
 =?us-ascii?Q?BVHTw/vdlhRlE5TEA9O7+BicEF6RtGqLoBfJB5uVGAnVzI7XR3mowlP6JQGQ?=
 =?us-ascii?Q?7cZZGbg+jU0JrTjnc7hyqU6zOdF8Hdf/tNTgqIT8Eur4T0akQiJxHiwRQOSo?=
 =?us-ascii?Q?stHsmdR03UV+Zz6jAe0lNdMZYWGKvj4XV4+R61/TjFJX49kFL9GH7kKUQs/j?=
 =?us-ascii?Q?7ve0I/26asJz3awONUdwfnnvfCSlcM2hr+vYaZTfUp/xmH0C0GirWzMPEEul?=
 =?us-ascii?Q?XE+rys2xCMeFg/Kpd5fPwyLrBj/J3kNk97bg3mPYQ3hNeNyYp1FKKXxlZLWf?=
 =?us-ascii?Q?xwc7NA+Szh02nDvxC8b+d97WT56EEq1CtmeiHb9Ih9v0Z6BA4xo1gW8z98uN?=
 =?us-ascii?Q?mEzZQibN7tznJOPz4JyiKDMjvah3HGkYGhuVsZt7Vdla5RrBBUGLps5zs1kK?=
 =?us-ascii?Q?dA935+gtZvIMlmU4XkNTFAYkdAXUd0QXOqY1PfjwJQ9CIno5v9sSoiZ697QR?=
 =?us-ascii?Q?uEV0AfjfavriWrBkeXC/TunX07+ro2n3dUmuBr8RobP0130Cei4b8qQSD9Tu?=
 =?us-ascii?Q?uEN2J99ljOy4tyGM3e10qwBcP4xn9HxylXcqBaBKEzyPk2p9RIASwtgHUywM?=
 =?us-ascii?Q?hZoYrL8vPX3QWy/QPq73jQ23TILme2bXvDks54QAXc9UR4VTRE+j2EJNPbRg?=
 =?us-ascii?Q?Jp98lDwTG7vAEFD8yPKLhCxYFHxzmYquci6pWubfCPZZsWWzcpjsU0vQas25?=
 =?us-ascii?Q?jmURRBvLQM6/WAj04FjuRW0+giOhs0fnDQOxxeh1je21R//wXAe6xLArxUKd?=
 =?us-ascii?Q?PukDUqqINdLPld9U5MLvg4Y/knVpUCMd+gQjqpY1zERSqFLDWZlmFGenUpm7?=
 =?us-ascii?Q?LDK+lE2oz4SHThd2jYRE4LdKFGol8kt2q13QkkMCaRgTol3425dm7mxgIFvJ?=
 =?us-ascii?Q?3h7GLju1g/BaH/e6t9DWz7TC8RM8VLtvp51N6gmem6bPf4tIDIpdnG6HuSZZ?=
 =?us-ascii?Q?CvI0si2CfDawO6HLxmBvsKlOzf7chm9hZDkf/NVgWA00/EPGP6JF3kvrrln2?=
 =?us-ascii?Q?80iRdW2shwQ4NezAaL7PVvyg7aYxOj7DC6QVb+BoRQ5Rb2o92hiRDqjO+ZU2?=
 =?us-ascii?Q?vBi2vORFT/exfp8cFrEBTVqKcCKX8F86msDT7AkmNpsm/Lkv/NOZ/gDNOK88?=
 =?us-ascii?Q?HIwSFbQIYq1fITgS7TJzk3XZPDyIHOhHqGNXj9jtRo0b6cK7hMTAIdio8RPA?=
 =?us-ascii?Q?FYZAirK5jMl7bP+IWuzVzHwb9M/JaRXG1L/NeHRY3GBa6rHtr9/1UBHxQcIS?=
 =?us-ascii?Q?i4aNKr+awsDyVxkwIrk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a82d0493-3967-48a9-6f95-08db43e58c62
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2023 10:28:58.4321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 11AiTrtlwY0YgaNJ8X+4WJKx+EbTYFQ5kJVap2RZJ3TRReYQhQ8JdlHXN/1rpWR3RyuN+oglpgdJ4H518V9l3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6888
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, April 18, 2023 9:02 PM
>=20
> On Tue, Apr 18, 2023 at 10:23:55AM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Monday, April 17, 2023 9:39 PM
> > >
> > > On Fri, Apr 14, 2023 at 09:11:30AM +0000, Tian, Kevin wrote:
> > >
> > > > The only corner case with this option is when a user mixes group
> > > > and cdev usages. iirc you mentioned it's a valid usage to be suppor=
ted.
> > > > In that case the kernel doesn't have sufficient knowledge to judge
> > > > 'resettable' as it doesn't know which groups are opened by this use=
r.
> > >
> > > IMHO we don't need to support this combination.
> >
> > Do you mean we don't support hot-reset for this combination or we don't
> > support user using this combination. I guess the prior one. Right?
>=20
> Yes
>=20
> > Ditto. We just fail hot-reset for the multiple iommufds case. Is it?
>=20
> Yes
>=20
> > > I suppose we should have done that from the beginning - no-iommu is a=
n
> > > IOMMUFD access, it just uses a crazy /proc based way to learn the
> > > PFNs. Making it a proper access and making a real VFIO ioctl that
> > > calls iommufd_access_pin_pages() and returns the DMA mapped addresses
> > > to userspace would go a long way to making no-iommu work in a logical=
,
> > > usable, way.
> >
> > This seems to be an improvement for noiommu mode. It can be done later.
> > For now, generating access_id and binding noiommu devices with iommufdc=
tx
> > is enough for supporting noiommu hot-reset.
>=20
> Yes, I'm not sure there is much value in improving no-iommu unless
> someone also wants to go in and update dpdk.
>=20
> At some point we will need to revise dpdk to use iommufd, maybe that
> would be a good time to fix this too.

This noiommu improvement shall allow user to attach ioas to noiommu devices=
.
is it? This may be done by calling iommufd_access_attach(). So there is a
quick question. In the cdev series, shall we allow the attachment for noiom=
mu?
I think the noiommu improvement shall require extra effort, so it is not
ready yet. If so, seems like I just need to fail the attachment for noiommu
devices. But when in the future it is ready, how can userspace know attach
is allowed for noiommu devices? Will it be an easy thing? or we may just le=
t
the attach as a noop and always succeed for noiommu devices? any suggestion=
s?

Regards,
Yi Liu


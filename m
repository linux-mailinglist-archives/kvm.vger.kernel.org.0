Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA0A6CA2EC
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 13:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbjC0L5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 07:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC0L5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 07:57:45 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42222D4A;
        Mon, 27 Mar 2023 04:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679918264; x=1711454264;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D+K9EEYZBeQYTPmt/KssEE9krfKhAClQoIdEvGw3xhA=;
  b=iqw023Nc9KfCu2cOybbQk58RGZhwTSVznkdiIzZhnck+IuV9cyndhfww
   dElLMIaixtbydLQdWj3L9WNYiJRrNMOmWj1gHuIOQORVTDWwrkq2Np1CA
   kAwXPoXti4N0x5/jVPdr4KRKGpmWbu1YsyvOFyVGzmmnR57n0KDPHOe+I
   f5T9N+Kkn/YBtxjejxEyMe0jNoBzvYTfi6HuiYHb3ZyNDvoTWB91U42Rk
   VQKbSz1YB39eLPVGdolc/Ch/uG+YMxmS35mwbB7Yp93VA0Kle7V50vjOt
   bVVsWOMwRTgEunCQEk1MkyRslbC1Q3ZV27dsuQ7YUn12iKR+mr571CKDQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="338965028"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="338965028"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 04:57:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="857629734"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="857629734"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 27 Mar 2023 04:57:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 04:57:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 04:57:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 04:57:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRXmcpZ+uIwE3Zxht80T3zJwrURmuNV6+GjdIJJ3YvpVOu9pLgHE6owle84LymVVdFrLQUTWk9piMK2KqQrnOLZ1Nw2DPYnm5ueuHZ34qJYCwy3el/+AK6mkoaFcw9RAu7BIyYgA6JjHZVpSXF+lRhV+t6q03et6M43hJHuwjEa/GDhDHAQnhWo0Ijt1fn5PqOasxzIvag5wkRBGglB39nvZOiOvxkOeWC0A9/AJGNfHr52M6bnwaVyFbVcDJNpiCKyAnDrBa1/V6JXOaQ+Mk8CkFZAI+ZwMiyGa1/VCS7s//S/D3tamIHlYua674oCUYZ31ev/Zvv3T8ehsdCfFtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NhXK8Dl8idyELd0+vqBDoNu3jTTZK054YqHLNbjn+74=;
 b=OVdcJC+o3NrM0qudqUzMAVtngPCbaMKeBNtWx3e+7lQ2LRu7/i1R8dNKUXDLim1OXKdcrq0syxEFwd0nQ2YuOzTPyfralJ0riPW1N6yBSfq4PRtD9Lyav6nb0uT/AqbUoynSrTYWu2sqb46M3sQLT4Lwd/nT3rZAwVYmxxQHgyh6g0HVagvLnA1pfZmJ6mozC1HX43J8BCAsZF5Ob19nrLMQ7H5sf5RF1BIHeVA/JDpW/8l2Zg6SB4vbj5QE3tyu/ytCieOxn1rljzDl1PlU3Uu+/o0TQhHKUWEB02RUIGqY9ovLGwmPYIj47gEV92d5Dlfoo0xyHUsJR2FIJGgKww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB7698.namprd11.prod.outlook.com (2603:10b6:806:332::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 11:57:41 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.041; Mon, 27 Mar 2023
 11:57:40 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZW095081R6kW/70aeRy5pC5KSt68ERp6AgAANFoCAAV3gAIAABT4AgACOijCAAHSzgIAAD3jAgAAIX4CAABLsgIABYx8AgAFjh7CABOQy0A==
Date:   Mon, 27 Mar 2023 11:57:40 +0000
Message-ID: <DS0PR11MB75291D53403A80C260BBB751C38B9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <ZBiUiEC8Xj9sOphr@nvidia.com>
 <20230320165217.5b1019a4.alex.williamson@redhat.com>
 <ZBjum1wQ1L2AIfhB@nvidia.com>
 <20230321143122.632f7e63.alex.williamson@redhat.com>
 <ZBoYgNq60eDpV9Un@nvidia.com>
 <DS0PR11MB7529B8A8712F737274298381C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBrx98kqNZs3jeWO@nvidia.com>
 <DS0PR11MB7529E4C6196C8581CD39A7C7C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBsF950laMs2ldFc@nvidia.com>
 <DS0PR11MB7529E2DEEB1CBBC9413A0480C3879@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBw/vL9JyueByMv9@nvidia.com>
 <DS0PR11MB7529AAB4FD8739C615227D7BC3849@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529AAB4FD8739C615227D7BC3849@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB7698:EE_
x-ms-office365-filtering-correlation-id: e9510f95-4307-4f5c-cc17-08db2eba7763
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u/S2ucWTfbFkeYZSh9wijySkl0iVHIag0cytIS7eOxm1/NR5qbifXZcELHW383o0CoSM18oEYeFVG0n9m/sm0eaIoea7/OCeMIZWLv7HTnzS8YRmAnBwpEiGIv1KNYP/A+6uwPUl9isDHbY62w4ao5FD88Mm/L1hdkM01QPwerMQP0bJKrc5hlmHJI10qpQ81SonTeHX3cx4T4408sd3YMn2/r/8CxOFtHVEw3BRI8xkBwjUYeTIfsXmZR9kmV7pTh9MnxV3AfBbO/WouZ6SLaBMBlETGvR5f1E7bh8R1sFwahG1+lkm7b7DpDo8iajxZkY3L7xfY185Ethm4Yf1AjsKkOmoMW0QgpuFE80c2PHY/WiPBHxXyexelTMx/TD3ypPv7WATtHLt/cx9tAaX9jZyGNg7BVdIOp79jLJu0mpOH6soOJbBXoIqgOOSglWB439nUoiiIWnfAr0B8KGQf/JXu52HHxDhWYXcOzqE1+dSB0PAffpBZ4rKYiDXbGOoV3pCT4fN48XB+lnpeqhaeh1W20fJIvxgZFTUCXHKOVjiV13EjkSLMb55hyj9RHauypCjm4RXP5/sG1qB1vFYS56kYs1r4EiMi3AxQqPNvkjV79o+DlW9GcnY2PShPKfu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199021)(7696005)(122000001)(7416002)(38070700005)(8936002)(52536014)(5660300002)(71200400001)(6506007)(9686003)(26005)(55016003)(2906002)(86362001)(33656002)(966005)(186003)(83380400001)(82960400001)(41300700001)(38100700002)(478600001)(76116006)(66946007)(8676002)(6916009)(66556008)(4326008)(54906003)(66446008)(66476007)(64756008)(316002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n2CYO7bDbgfppi1Qt70OZpxOvc+/9+4/0Qg+cHrB5+YiuBuOPg0wmB6o9bM0?=
 =?us-ascii?Q?iBuS+a2b021BSEP5yVzvnr7EyPAjXe8pVKCc6JoEJu77Pf9bT5PiR7JkPxvG?=
 =?us-ascii?Q?cA3J0HeRxKS1tPvMepzUmt9+VmYkwxaX6YFDBfT20QbhVY2Wm6o0o+zFZ4zH?=
 =?us-ascii?Q?sjGNUumBsK+1WQ00GjmAFa/fspUaPoVv+6qgWuowr1shilZWxTzUxl4GYNIm?=
 =?us-ascii?Q?vyUCgOLb9274XdR0nau1XpDe2MoUwn/JVj7drbKyzzrQga3JZ8yAoczH9PCu?=
 =?us-ascii?Q?rbOWakDJQljRhk4u6rquVLc4UGoERC5s3LUGoQoxqSNAYqyVgSHte1bL06uy?=
 =?us-ascii?Q?H5Wnu2bAEUCfs9xck0io/eAXwY0lGIWcydbk/+R1WjzzZofm3ukLgu7qrPWW?=
 =?us-ascii?Q?xkqfjzhWfCWcUkowpdafUI3baS8QXHe4YeJlEmotmNDcs9CouXMNv1eImSIX?=
 =?us-ascii?Q?tBEl0Gk4VGn+ZBr4W8ydH0rh0f/um4GCClmfkDon1pmZbhfVElqaQJPyHd/6?=
 =?us-ascii?Q?93dNujDhhm2HlawOzYcXEQF0t035AwSUbuw5sUd0GWnz6fGCuhebloQSAI2k?=
 =?us-ascii?Q?tNP5LMGpOkfxVzq9BvZK750nPSY2EW6TcbmsKOO5wk9UKGRYK/QJLLRZ02Ph?=
 =?us-ascii?Q?MXi9RFy1gGMGPscxgcXG3PF4LIP0Sf+kJMXHFm3wSXbNozI4Ra0xPp6SD/wJ?=
 =?us-ascii?Q?br7u+s9IXdFtI8iXzLxWK9RWtTras9ilsRZwKi93dnavtW2mYPXCErrqSFrY?=
 =?us-ascii?Q?DA+eHVV9y1kElKudqbagqwytbJhj594BHs5W88T+YbR0Jy6RdJT6Ojp8FcXx?=
 =?us-ascii?Q?3U9OaoegwJ/aN9ZuHZDokkIY9qb+Hvzbidu9Ck8VYrS7hm26Yilu0T15s5c7?=
 =?us-ascii?Q?DV3FPEkgBQU1hqvjFgofsKX2eL30sG5E12NHFkcHBK3WDXYXc6eSVA1jyvbZ?=
 =?us-ascii?Q?/JZpeaAocZd6kOsbik5vcT61cKi/Gk4FrUN4NqYHM4qNITaD1f3h2KBODtRu?=
 =?us-ascii?Q?OHqeFokAHIIP/lvBa6YOWeEHveTdBA9pB/1FdoN27MIZDjdQ9k8s6CUgsuKX?=
 =?us-ascii?Q?YHTVx8GPwGpkzmNXj1L7b71hAOC7zsUTBHNVHtnmWlyoBjFcXXd2CZZ6stXa?=
 =?us-ascii?Q?KLXCWILNmQqDGmEtWEb5AY32PPeTDiPW9tnVpDZMR9JhNg+0sF7Xaygnws00?=
 =?us-ascii?Q?LR3NfUGJWjeSbpr8i38hnoLuSDOzisUlZTUlaMQ/JsUxPa9pmXmpUQRUQFkK?=
 =?us-ascii?Q?LvS6E60RW+CjWoJSNAhcMm1ncbSsO4fcjRPyt9vTvLGEP/ZKf7yzDHB7Ll1y?=
 =?us-ascii?Q?gx9n/CEMPZTp+1preBQ6Kv0d7p9OHykY1Ocu5UO5wG8tQpAC0lMizi5rcbyx?=
 =?us-ascii?Q?M797C213ZwQ/4a8S0cY3ziNkUbUbb+4scxLKjgfAfDodbAiJKgUXhL7Es6+1?=
 =?us-ascii?Q?2o4ON+xHDr1N+/PflXFVngFN4veJDLrsD5ij00r9SgE3q20xcQlgFBae574b?=
 =?us-ascii?Q?5Qkq+9LTBk0ltf15JO0741hwQkoNNHkFWH4lfcsPMEczzcj9Rwp+TB5fVwi2?=
 =?us-ascii?Q?TGHHATE0UN3G36op9aauIHLzk6mEZ7szo02a5Ocw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9510f95-4307-4f5c-cc17-08db2eba7763
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2023 11:57:40.4567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ppXCguflHIElsds/JyxiilPNFCBrykVvMaXR0LhcXGIC9vKMjtLKpH1HHlbEBFxgCTOpbTblvR8TMezffwN7Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7698
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, March 24, 2023 5:25 PM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, March 23, 2023 8:02 PM
> >
> > On Thu, Mar 23, 2023 at 03:15:20AM +0000, Liu, Yi L wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Wednesday, March 22, 2023 9:43 PM
> > > >
> > > > On Wed, Mar 22, 2023 at 01:33:09PM +0000, Liu, Yi L wrote:
> > > >
> > > > > Thanks. So this new _INFO only reports a limited scope instead of
> > > > > the full list of affected devices. Also, it is not static scope s=
ince device
> > > > > may be opened just after the _INFO returns.
> > > >
> > > > Yes, it would be simplest for qemu to do the query after it gains a
> > > > new dev_id and then it can add the new dev_id with the correct rese=
t
> > > > group.
> > >
> > > I see. QEMU can decide. For now, it seems like QEMU doesn't store
> > > such the info return by the existing _INFO ioctl. It is used in the h=
ot
> > > reset helper and freed before it returns. Though, I'm not sure whethe=
r
> > > QEMU will store the dev_id info returned by the new _INFO. Perhaps
> > > Alex can give some guidance.
> >
> > That seems a bit confusing, qemu should take the reset group
> > information and encode it so that the guest can know it as well.
> >
> > If all it does is blindly invoke the hot_reset with the right
> > parameters then what was the point of all this discussion?
> >
> > > btw.  Another question about this new _INFO ioctl. If there are affec=
ted
> > > devices that have not been bound to vfio driver yet, should this new
> _INFO
> > > ioctl fail all the same with EPERM?
> >
> > Yeah, it should EPERM the same as the normal hot reset if it can't
> > marshal the device list.
>=20
> Hi Jason, Alex,
>=20
> I got a draft patch to add the new _INFO? It checks if all the affected d=
evices
> are in the dev_set, and then gets the dev_id of all the opened devices wi=
thin
> the dev_set. There is still one thing not quite clear. It is the noiommu =
mode.
> In this mode, there is no iommufd bind, so no dev_id. For now, I just fai=
l this
> new _INFO ioctl if there is no iommufd_device. Hence, this new _INFO is n=
ot
> available for users that operating in noiommu mode. Is this acceptable?

The latest _INFO ioctl is in below link.

https://lore.kernel.org/kvm/20230327093458.44939-11-yi.l.liu@intel.com/


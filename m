Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDF854ADCD
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 11:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241919AbiFNJym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 05:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241170AbiFNJyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 05:54:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF4F427CC;
        Tue, 14 Jun 2022 02:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655200478; x=1686736478;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6r9ZMy8lNxOvMkN/kjemai4UYca6gLglNVxzNZCvtoI=;
  b=hXb/jDcRx0H9zEmQ58/XYEktvp2WxR299CL62gooUQ7eJqvNa00Y+F2y
   VzO5GbWRFVtd1YglIIjEHRE5ybFjl2qLlNciSUmCXmhMRA8TvpFnHKzB6
   W432M2Li1nWKYVVV+phRwAQ5f05oZbuM0FmYDZnks+3/4CDSfG8NlrnZO
   GwWNzu/XvkXhamQVwQ7upj5adRojpGHYlaO28IyF1cVsG/Q2fiTHARawn
   UTsKA7vuSuC07mZLynfupHHLPU5a8aIh35OhzWt0FSWPIKtIL4OA0C8II
   Tfa05mtzMsV/6LJmWK2pfqd+mS+ARN5QYxCV40NpWU+S8Blfre9UmE76q
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="303979763"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="303979763"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 02:54:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="651942583"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jun 2022 02:54:37 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 14 Jun 2022 02:54:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 14 Jun 2022 02:54:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 14 Jun 2022 02:54:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5yFlSwlitycq1bRrxLEDCv2elEF6ysBBok/9XEQ325NC5X9BfXbcBPyUmDafkYqDHEdercorP7aoCZmaEbgUmWzexj+72LqE1TZPDnyhybzCiEZXwOcxYzj/pW1WD0BUDMN7RNxSoHhewuRJlowfGdboA1mn44hdIiRuie0eG+dSICGB52sOGRnY4wNXjYusxWWaJBWCezgzYWo+3dtbDUE0u/S5q1sotoGamoc/ijbCX2sU6kmaJ/Hmle5ce432ZxW2nC2WfxP8/QC0mMAHf3EIKfDQvQE3+cOjY9YuHPa3k8vFlWMgW+AlJeUN1E20MwAQajzKmP0p75Ei3rizw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipXZe1Yt29QbK+dpLXj/YzB2cz4m8GJ2KpaLHD3/8n8=;
 b=KwErcRaONCka6SNitAmDOsbAo1QsCgA1zSI99T9PMFan5ChZQKrRCiokJF5/8EZkeaM6qVX8Pl8qRjbKnZ5OKn5JeiNHaP1Bf0zVx6iPNErYk3Unrc8EJhbNdOBNe1GDFxi0GZiFAS/EHWA5l9Eos2rVOjEQIdL3VastrOS1eR0dCucp4xTo64rIkcYLL0Hzs1CRXm4yR3nRI1/bPyU1er7izEuKr4nfSoIf/QmVO5EFccHEi/3vKPVYZ0OAS3GOUyINu/e5uSnXbGgo2nflnFExx+eDforynTk1eqBgsqE6tmbVkJwW71fv/sRwhCVd81PpULjidXe6Fb6n+07B2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW5PR11MB5786.namprd11.prod.outlook.com (2603:10b6:303:191::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Tue, 14 Jun
 2022 09:54:35 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 09:54:34 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 02/13] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
Thread-Topic: [PATCH 02/13] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
Thread-Index: AQHYf6ro9yEiclm5aEK4jcew43ga961Oqetg
Date:   Tue, 14 Jun 2022 09:54:34 +0000
Message-ID: <BN9PR11MB527624AB396D91AA0A5FFEF28CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-3-hch@lst.de>
In-Reply-To: <20220614045428.278494-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45982f27-d351-46da-3e8f-08da4debe2bc
x-ms-traffictypediagnostic: MW5PR11MB5786:EE_
x-microsoft-antispam-prvs: <MW5PR11MB57861F0E06EC4EB463FEC14C8CAA9@MW5PR11MB5786.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z6tS9Hj287aCVsnS4wECL4bhM9VI0pJvL113kB/XrQQ/taTZT7X40WEwpj1qdIibbAbc26bYKj/ksPiEwAm/U7vSTmt8evyrDfmzk3D3oCobo1ukc8a4fgMPrCFU9Znb4TbFWag46Q9aoH06FPoFwXdEq+gI7IygCENV38yI/wtzr2owG22j4tfbz79CpljpaaPtDGkvR6vy8/KlI19/vcHB3Ja/arvN5BfZNfR2zw+rlBHI6t0zVEF3JJXn9bf9s9F+KjYKYGclCuCfDdrWn+b6marn+tM1ed06DNInnPFPCe0rgBNvAb6vZ2StMkAsgCfsMjIlAiLoiwvLssFXDCjZOtVWOBas91JBzXQcSVMjSfzfGkZEspIF5PkzOJvisrQwjHkd4cZ/LDY3dFgexTRYmgqNrqcsVgJzByQCDxwFbI6rwjLKF1//ARGBarszxT4hEOYPpcz7cEKryW8R8sVkerh7OtjYw2DGPLJjICzwsBZOx/yUQOMrP98RulOGHCtM5hFoIzKEKLDlqJmo2aZd3FHl+gWUAVaQuVn1bcicOLKPpImOe3Q/i//GsNmytMOE/fJbRVym8b2o7qcCb0cFwFUPoHxzyAlq0MlTyRJy/QjRFgFx5IlATSTBby7ZG/DgBFVqZtQcTOE9ce5HCm/Alw+9W2jgDP4Y0I9gSKRPM3KYNIDxmhBYCKn199o1zS79GVwm8XPFiKhLwylqZos4c3JtQLKaB/fSJrvyK8U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(38100700002)(508600001)(71200400001)(4326008)(55016003)(86362001)(66476007)(66446008)(82960400001)(52536014)(2906002)(66556008)(8936002)(110136005)(122000001)(66946007)(64756008)(54906003)(8676002)(316002)(921005)(6506007)(7696005)(7416002)(38070700005)(5660300002)(76116006)(186003)(4744005)(9686003)(33656002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h5F6CvMQ68P05KXqsKllMXkK9suWjlTOG8Kn9KOqxddV6xULTMSY4gsprvsT?=
 =?us-ascii?Q?dCKWSzYah3QWNGmS7BKW/Ye6Ho6X9CIWzGx6w/tXZ/DtUOwHiZ6Wdnn2YJz1?=
 =?us-ascii?Q?Wb35kDRI5eZ06jmsD2HaGxtCOcKZWGsa1nkmcgdTLei1MWZVj06OQkZC6h09?=
 =?us-ascii?Q?cjXnZfAjx2lYq2RZ7aJJaRecbkfd9gevs0uv4o+qf92rRI2GndpajkSb+B52?=
 =?us-ascii?Q?DcsB2v8uyoPtX+dUrD0re5XfiIQGbR2ODcY6fWjdjmx/76TAaozwBz12bcyN?=
 =?us-ascii?Q?g6Jq0ThAKyIyHmXgh6fo/4I5wVGmYqHTF/LqycdgdB8EIaYi86QnvOUQ3XpO?=
 =?us-ascii?Q?cyRrUz7G+tOwPWX2WexiIuAtBkeJ7ozr3wYNRqF6qzBq9NbV7m3joFi7KpXz?=
 =?us-ascii?Q?z0WAjVAzBvI9lk2SdZNIIsTYuDj/qvXgKAnpL4oEMTXXFPkpgNI1nBjy5vED?=
 =?us-ascii?Q?9SZzYJHSD2oQGO/sMM/y2gavzgyOUbM+YJ5HiUSh+6KKhjYEoQcL9WikOSPX?=
 =?us-ascii?Q?Cfa+uhEIcaMZDLFOAl4gf4o2xEZmRnZPeV62PtJMrcH4tLmcZAGRjiBR0IWo?=
 =?us-ascii?Q?pgAT0yyyQwAQsASsKX4pUMAr0TsYAr/u+R7Eu4rgMNAqcCsJl0ut7vTvfv0p?=
 =?us-ascii?Q?QeMxtQMcdLuZICww70l93IsQQfV8hhZJE1u3xJnJeHyvwR0Sjsm2QTmsHx81?=
 =?us-ascii?Q?lhlfzr772IXrdODU5+6gW862meI/O/Zmxvia36/84V2i7vuibBbcFeB66zA2?=
 =?us-ascii?Q?RexTMovlEWnoywP4FdkeLtDwN4GHZWd2E9NmiFFFtyYiqYQ27LhiHbG9RRzs?=
 =?us-ascii?Q?AIRq5pPHMOGWCEf1MOp/1S6r8YelvklFjcfHy8Mxfw1ttQ2h2Gl7gW0lolkX?=
 =?us-ascii?Q?gSxkdJ/2hQfeoo+WrO4NO/1mZvUGXlZg4FlHfFpfmVbTxVeellWp+y5BYQu6?=
 =?us-ascii?Q?/M0IutzkUGgnVjhHdKpIm/1ZK+iVOvfqnksLuxg82ulP66gpvqFGBmjdAHOf?=
 =?us-ascii?Q?wFJbOXeQ9p9gZJM5t+tYHwZOPH3XlhX55RMj82RBHM3PTgbGlVCcJ7jQ7oNC?=
 =?us-ascii?Q?ENCjyFVuzyl75tKA+sSsniy5MAw2Kf4bDYdhBmhwC/irGOuG9Khfm7nYM1dT?=
 =?us-ascii?Q?AzWTgQtaIoMc7fj3+q09Mh9xLYPVtyEI1c5T9VjWCpKTv392t9AZ1NGFE/H9?=
 =?us-ascii?Q?1YfZ+6UjMPwpBRPyEEKm7hVN2kJJJf2PsvOL9LOmNKA2A0uTjCPqG5YYz64M?=
 =?us-ascii?Q?EanPyw6TuF4sYhPg+/aMPPoZitX1wcrLH70pLmukVMtdB3mg7BC7RnnZIEXO?=
 =?us-ascii?Q?7Yqr52jHx09dgu2Qq+ehFPQeLo+SiwTgstjynOr95Iptt6N8gMN/YFgZz20z?=
 =?us-ascii?Q?viG6UruFZ3AW0tLqHz0YRr7zfk9c/ipUkYIprlXHkM9gY4Z7RCeGa6a0z/+b?=
 =?us-ascii?Q?kZvQx8yrT1q+w253fuCqGC/dr5hcGtDw2zy7u7aflaZbeb/gvZYUr9cjDyKu?=
 =?us-ascii?Q?lUV0tOrHsco10gjsmRgWa1Iw/W/a1PSIDoi+COiiM63Q0YDpilyt3gucE0//?=
 =?us-ascii?Q?CcJRsL1c5uC1J8zn0VzKfVNfILGlXmkkzeIcQsna3VfcBgVMUS7dUf1l9Ofl?=
 =?us-ascii?Q?ZJClWF8q5AHDUtKeu0IpMsfK1fgcVkAG60meRr+LHx2BaCFJHNANNyzNPfHC?=
 =?us-ascii?Q?LmQmvJAvHddSt7SaT3NH5jE88OsySUp+RjLA8y4BPEbQOEjBF3hRAGtfZ/Fu?=
 =?us-ascii?Q?Lmot+yHyWA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45982f27-d351-46da-3e8f-08da4debe2bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 09:54:34.2518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l5wHZFCcJAOCydTqrMTGBDHmj8tVa6x2nQWVHP/GO2RMk4pub1ClFpQPjipvfjQQqV/BoAogvqdixOacY4yWfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5786
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Tuesday, June 14, 2022 12:54 PM
>=20
> Simplify mdev_{un}register_device by requiring the caller to pass in
> a structure allocate as part of the parent device structure.  This
> removes the need for a list of parents and the separate mdev_parent
> refcount as we can simplify rely on the reference to the parent device.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

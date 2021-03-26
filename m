Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E779734A047
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 04:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhCZDeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 23:34:19 -0400
Received: from mga14.intel.com ([192.55.52.115]:35753 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230304AbhCZDd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 23:33:59 -0400
IronPort-SDR: SudI6w5r05I58byCPkU/rqsWYBWYQHAH3TU/BkQu0t5hFSYqBTrau8gaBqpyER8jgq5ZqW3Sr+
 sOsRhmwgqCZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="190501391"
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="190501391"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 20:33:58 -0700
IronPort-SDR: bW55OCrE8ugIWopTopUm/7qtTw92mBfCIAfQXqmqf6uRMikXRqWwL10f+WSjIqJEyGbyp0JR5b
 NM+lJfDe1gqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="414404563"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 25 Mar 2021 20:33:58 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 20:33:57 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 20:33:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 25 Mar 2021 20:33:57 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.53) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 25 Mar 2021 20:33:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3EXu5w9ubmgum17+UA6rkCzYEZoCVwcsFuaHesRRkSoOEi+nFHIp6BdRn4WXmuXIuaKZ5UhVZIcf+uytal1wIkn78beQbr6OU21SPcZv+AwmyEcbMIlgrFOYNdW9W3PYLoiqr63aon6wvm4SJUYkuhPBkRJYhZzP2LDnYJ9YSUutfHb1JLmFxvSGIxirMtckE39auCjqqnINgcsy9AdPfZSNBwaQsC3q/7PWd1GvBbD2rO5mA5xGxnLmIbiWHgCL0ft6bp2s3/v6vHrE4O3hY4auKsvnWLnzdIukyeThNkSalOpoTIIgnl73TeOCYNc/rHd9l5ofzzMsLiYMUz7Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vw0KpPSEC7sAvyPMRAMKzhDKqKmgHcG6IGZfRd7lzbc=;
 b=B/m1sk+BREkRaDUwjgQdXCZGrGJDRxVl4JeM8/O87KsL4xJCIzsCYkts5llfV+W456GwfDBQUMGpZwhCn2wBBGuykqqKtK4u1ZAWrdtVMnCpggJxj9u41PdqGlOeShRwJq/f90KPDW09xi4bLs/NXFw0R8emM+8gjRGtxwNjO5nFT1ClpBLJyqFulHsnk9GSLEIgvgd2Rko830tokJ52I1Rz24kkaKJUls0iYLXeXxB81gNIz8oJWVe1BHlCBoWHbaqGWCr/RE3KkF0pSjEOlZGMO0rjMQuGfCLRP1rpMPQ9peou30ybJmRRPEodldWIQF2KsFyaD3tuSYPjxyA8AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vw0KpPSEC7sAvyPMRAMKzhDKqKmgHcG6IGZfRd7lzbc=;
 b=xTnKcKUzxsFVEfSdcZpOaA5stk+MUOfutuhPpUCwICG/OyEHzNjZtAFP1lYo57BzVs92EDruSYlhFI9uN5Y9xlTBHbsNwPfTJ1JQ1AUjzmvNzl4Vs/nWZ2a4NWTjBl85UBSQcZPZjDIWbSDpIvgvWeOm0dG/a+MiLEMovK+bs4A=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB4932.namprd11.prod.outlook.com (2603:10b6:303:98::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 03:33:54 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 03:33:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH 08/18] vfio/mdev: Reorganize mdev_device_create()
Thread-Topic: [PATCH 08/18] vfio/mdev: Reorganize mdev_device_create()
Thread-Index: AQHXIA3q9lE4ogaG6kK1jMCZehbxM6qR8xwAgAOt21A=
Date:   Fri, 26 Mar 2021 03:33:54 +0000
Message-ID: <MWHPR11MB1886DED32FA634ACF81BD0B78C619@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <8-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <20210323192040.GF17735@lst.de>
In-Reply-To: <20210323192040.GF17735@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.220]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 838747b1-9eb4-4782-b976-08d8f007fb8f
x-ms-traffictypediagnostic: CO1PR11MB4932:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4932BF51D3E0B9A8382B20928C619@CO1PR11MB4932.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uz9Y4xLKazIgXaHJGXcnt70tY75ZMSNAJNCOXyM0Qj/q6G93r4S1l9Us5CI6cdHSB+x1ptfH7Eiqbe8qIttcqHfUgOftcYLUQ8QSwq+psipgUjkAVuAXFL0/3s0pUHfgk59pIcQiJQxBn070eHnfQeWZV4nQUqhtohhYIdS2OQwIu1devnT1JiH2ytvMmc3DkvTSxVDYgK4shS/XgcC/tTB0rfRycqBOxTdysA0DrrF2MJcc2lcdetU2KLGo1kvwr8RKw6P/8wzXt+BASzsdCaihUnKruslHhyBrNVY5iwYowmqpzr4fmHBlv/21e4aiyi6OeA3YiHz3ioK6gMGdV4asntPibo9lATsuWUx/JPuRqyxzPva9S45GynA9ByAww/vPdoS4IqM87mOGKWrEW5mgjCRTqHziye5fwpDNAyteHfPdPzTrz1+aZkUD5bQNTXb0YDvIiLXR2Ad2BDNyYslxjB+SIXtsIedaSoQhE5v8cCgAQ36yfUu8NFGAlwuesQbI0w+codnyfpdHy/IftH+jBXnxsQGZTY0MCiv9iUOw25aC4ENTa/4a3XBomF9TEWqY8ywlYGpQ1ryk9/nyfW01oLNNak5394vjimH56N8liLb9hpEW3vHoYxJOitxCQXwcqtk0MVzKMNjaF+lnmOq2+yz+DEOO7ivL19g5c0U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(39860400002)(366004)(376002)(66476007)(76116006)(66446008)(64756008)(83380400001)(8676002)(8936002)(5660300002)(33656002)(66946007)(4744005)(52536014)(86362001)(38100700001)(66556008)(9686003)(4326008)(7696005)(110136005)(478600001)(2906002)(316002)(26005)(55016002)(71200400001)(6506007)(7416002)(54906003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?18zWbPVUb8tSiwLGHkzPGalggeE2rZe5l4MFJcqyMf56Gg5QmPZhGro33OEW?=
 =?us-ascii?Q?zxAfj25y4qa0+YIxRtvArLB6mm6Imim1RUZKF77v8cmYEtu4LQlZYWHmbc9n?=
 =?us-ascii?Q?bAwq6cY4lhBmDMGC5tzgnZZcUCNfLFjNWIAbjoRHeCz8T1Llzhuo8c3JrHtv?=
 =?us-ascii?Q?thq/q4M9t6vZMJxwsteNGG+Yf2tkXHpnLB0otOjaGdh+qZ6Y3hIzcWIXDaRL?=
 =?us-ascii?Q?mNlmDy2TR2Azj9tQp5GZF8R2N0ML/XughCR1DvTjk/rCT47/cUJbtGR3MF5w?=
 =?us-ascii?Q?qaEcTJVYfUnFIpVLWfrxRyflmjeJJXBj4wr13rA5fIgqnpPiIBXWW1WYTcJS?=
 =?us-ascii?Q?wtpm427Y1jJTfAPOatKdllqPIcb7p1Xbyat3BhmVjNyFXnoWPbSJMukJsOSn?=
 =?us-ascii?Q?t+1ijJww4vfBQUxQPlUHkCQ/0Vsr31+2PrI9/i9ZRO3Pb37/iyUqlnVM4ub8?=
 =?us-ascii?Q?MKhwB/D19FNNUsLVv1X22ieBDG3PxpvqlDEW19Z/BrzjPIg4+CufLXUj+KfL?=
 =?us-ascii?Q?OKCfxD6cP2mE5Qs+d49l3cz3J1zdFeCiVKTIiUfJzsEz4w5irFxspPnkUyER?=
 =?us-ascii?Q?Pj9cLO/7UnLnt7m0HPGNoBMhWQYsDjznkvi3fjFNXGwE0JymMYmObAk0r+De?=
 =?us-ascii?Q?B03JbfKfZiiXrsVmzhz7IQE3nacHTgMFDCDm7GLNQqF3GT1fIzWIyUhMQIN/?=
 =?us-ascii?Q?ELaySlyxcAHjBv9YRs9ym8yYuEiYIniJ1a8d9ta3uVFWeWCIYJ+U5gM1fs2u?=
 =?us-ascii?Q?XDmtTKcdoYqvsCidGwoJSAuy5gacFp73ZWEHIdv9IfJ+XLr0cxYqNB4UP91L?=
 =?us-ascii?Q?Ty6o2W+5QOOeu8XMewOCEJs1ojXuw7ifAO4HD5h5ZPt2WrTMB2qxBPTKPC9+?=
 =?us-ascii?Q?z+75AWVLSNQinV9VyLQt3mvuYKDKe6kqamrLEw/1hwmMmf6bxEFYQq9Cyn4e?=
 =?us-ascii?Q?3LyB4DN1PO/yZYxBrYigIi+9IAnWisHNARFgrU+524csNRYK1Jlzc2MO5fDL?=
 =?us-ascii?Q?86Qae3WhDC6jDQsoLPzXrLjh6zlTYk5KEWqlwMr6ljVswz/lDek0LanN1PT6?=
 =?us-ascii?Q?+0RNX+bxHm88Dw8QCnjD2MMZ4b3x+z+9LtbP2xAUO6N4BoARkk7dOAYJeAnQ?=
 =?us-ascii?Q?KuAMr1z9sR5lW+Q3VsE4J5D0h5W/jcaQOYqQEdpar+dRLMoMTvcIfCOn2PhT?=
 =?us-ascii?Q?BCplQBt6kNi6GFwKHEzBqTon1fb2lH4Sy4mo67DOLQpjw6gkcjxbF95TRCFJ?=
 =?us-ascii?Q?DnqqN+MNm/jUbw3xwEwZr8wEEXaXLcW1zNxMw3pCZfowFD9f86tsdQZOVw+m?=
 =?us-ascii?Q?rEXbsqN7vHUgVO8hhRmk11VB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838747b1-9eb4-4782-b976-08d8f007fb8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 03:33:54.7043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2mm4zX2M5Y8MsDk73xMlcLzrhuXbDF21DJLfSnjPLVn5Xfeo3Nopl4XsxY533skBAeEGJSKi5yGEwcreC7CfvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4932
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Wednesday, March 24, 2021 3:21 AM
>=20
> >  	up_read(&parent->unreg_sem);
> > -	put_device(&mdev->dev);
> >  mdev_fail:
> >
> >
> >
> > -	mdev_put_parent(parent);
> > +	put_device(&mdev->dev);
>=20
> That mdev_fail label is not very descriptive, what about free_device
> instead?
>=20

There is only one goto to this place after this patch. Possibly just=20
call it trylock_fail.


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3674D3AD0CF
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 18:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbhFRQ7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 12:59:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:50893 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhFRQ7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 12:59:53 -0400
IronPort-SDR: Yd/HEHPDQPwH/Tfyw7G8HCM+KdaqsUuI4NFL+44AJzwJcfPQ02bwaddh7yEV+jXryWvnM+s/x9
 BWzDOacJ0QTQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="193715912"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="193715912"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 09:57:44 -0700
IronPort-SDR: S4xW0ZOBDK3iqCbhFoctWjFaGcRZUlpMgbeXbr7XKLKS/mIu4815FG8Qj8JkW/0+Xhus46NOpr
 KmRkVXGWWT2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="405026079"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 18 Jun 2021 09:57:43 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 18 Jun 2021 09:57:42 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 18 Jun 2021 09:57:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 18 Jun 2021 09:57:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 18 Jun 2021 09:57:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkFiqbCdhZUHXrP3pVmQkTTZOFp/GDyRVaMI1M0ohJSHW7DcHbJR8Ck1sjexGxfchZOIPokCaF0l8++aHH65trw4cRWklwA1r6WKh23yCjv4upmXFB+Q8yGZKezEGekZwZRQEi2pVd67Z0mfg4rfDFnKKN9ai7BavLFCsfE0tv6dSdjJatS2WnRZ5KBudR4xKlHFB7jyCqRV1hY2YavV8uDetWBCuOOWDDEWC9cNhYWX0Mxt9Sv3LcpNGYsUwL1oqwc6B9rpAI3/Z684OAUr24IjvTSfWtpn8RLz5HCJp7IN3LHyhFFU9clDvW6WFIEYWrOcHrbjcD9bXl+7wFgrXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UV0SbCj1g+zpB3cwOVNetcTJ5x8uM3lW4xH0Z3jY8A8=;
 b=flktnb+rpEsHOTGth/arwX+KVyZ8tGpYDDzcBK2UOQcdKUpKtH564NitOx0pv0I0QY/zwNSN9a+Ms5S5mci22D5eAfOEeiQmzJodYxCXabyJ8JeRwx6sRnHV5hOx+z2uu8Msj+kWeakMTn5/XJp1B6rUO2EbP39chN8WTDAqSIylQuUzYgbleSafQFZOcqyH+MLxlzoxdtsPUO5Cw2/T/2Os32gq8tGyTcmDzyUdQ8nmo30bcvy/vNpcjiIUUAhgCPsuVmQW2cjR8zEUHD3hPHjVcZzVyT5JjVFmedJiNSOfqjFZX0q78VuHVvKTn35WUWKggZbPczB+SMfF76cz0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UV0SbCj1g+zpB3cwOVNetcTJ5x8uM3lW4xH0Z3jY8A8=;
 b=GUT+ykG5MLQoQe8rIgKoJ8lJcGa4274j0TyHKcjwSTyTeKRqC/I4nmp6YLWlVKuOsPyM5tW4Hqv4371vDSqhn07bd8u3t37p3pOcB0zOJZXRLljBaqMblyl66gz2kYdtchGeIgfyV+cd5pPti01aoCqPzCDhAZyHQFNZfo4fQ9M=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB4996.namprd11.prod.outlook.com (2603:10b6:303:90::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Fri, 18 Jun
 2021 16:57:40 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4219.027; Fri, 18 Jun
 2021 16:57:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Jason Wang" <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagB7l+uAAACIfoAAAdwYAAADDw6AAAHKgwAAANd4AAAAacwAAAT4QwAAK587AAA0n7GAAAYKlwAADDvuAAAgbLGAAF6lSYAABO0WAAATSRtQAB5ymYAAEyKHQAAmZhSAAAo/ocAAK16TAAAGdqAAACJdiVA=
Date:   Fri, 18 Jun 2021 16:57:40 +0000
Message-ID: <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210612012846.GC1002214@nvidia.com>
 <20210612105711.7ac68c83.alex.williamson@redhat.com>
 <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210617151452.08beadae.alex.williamson@redhat.com>
 <20210618001956.GA1987166@nvidia.com>
In-Reply-To: <20210618001956.GA1987166@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 507a175a-4a08-444f-8071-08d9327a2f20
x-ms-traffictypediagnostic: CO1PR11MB4996:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4996D44C081074EB50E902B38C0D9@CO1PR11MB4996.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g2DbI/XqO3lX77bsF1XjBHMuoMT7bOcpCeKqFOYy3d5e8iCFfyUvxovBKoN0LP3CmEP/WI0lqsevSZw4z9UuoWIWCYV68vR6d26UvsS3fHkmZjyKJrT42FhvMdUTUh44WjuXcxzm0JwYdIObdCFnEQfNV7gmE1xGwSPfJjpQlNXbEUfNBKJX0/j76SJYQbBgLNSnSI0ZdCymfE1nJMHcFFwyo+egoBfVSGgcePKOZkxKEZCVhj6TuDXWoLm76kzgvwbZw5WtH5LQoByT7miFASZUYGMbmvyjyGcX0ZLZH+V4XJswqsy7cDeN09z+TaHeTxNIlp/1LqQR/7/E3TvVfioKUOHoX8lDzttSsSPOWjILsTsUov0m93Qp/71fNMt60IkhA3XB10oSSAE/Kjbul0ZQGOIubMzYsUNCLFygzxZRlXKdJC9LBktE+fgkx3Kk9I/KKXSbRWbnIR6nKxZXSEOfE+OQST5ETSTRaV14BOFZaQlAgYOty0VdO/KPMlfiF+7CLMNMrEVQP9Uogmulp3tmMhbukawN8T56Z6azh6f5GBhOnQjrvWoPp5fIGOFy4R10Y3nUcBldLlX1n9WZe0LtYvyAxfC0aL3Tey6o074=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(376002)(366004)(136003)(54906003)(186003)(5660300002)(7696005)(8936002)(316002)(478600001)(33656002)(76116006)(66476007)(64756008)(52536014)(26005)(66946007)(66556008)(110136005)(6506007)(7416002)(38100700002)(66446008)(71200400001)(122000001)(8676002)(2906002)(55016002)(9686003)(83380400001)(86362001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EDnJRwnxBBD5n9jfO3P98kfqqB2t7xkd/E4XNNfKcQUOblyfXlWPCe99P30S?=
 =?us-ascii?Q?wRg1tX/EawREgNXRVAmv6LycdACZf4RKYABVWTW76qJ1gEaqtbrcDTN/WiaZ?=
 =?us-ascii?Q?gVi7AlNU7GOzB7HbBKFIIoehHE8IZSeEqmX7NpYTEepbgQ2rA0Ht/qKz8EYX?=
 =?us-ascii?Q?y7bE9FKqukG5kQ7lEuCBp601PlSFGPvzx/kp632kuoOUE3l0LapoRAqIIxK7?=
 =?us-ascii?Q?R6O0IN4ja3E7UV1ZeB3P6bJbzxW7urAdT35SUP28f9TKOBTZ4801dNrkEj1P?=
 =?us-ascii?Q?sc9aVu1y8w/lus5zVpmVZq5oO6k2k5qvl7QoQWZdmLmLHyu6246zcm8Aea/i?=
 =?us-ascii?Q?3MPqzghiA8+qKy3pq7tx3bsydmioL8SgZHvI+yExL5yFyO4bLMuVBnz33u/W?=
 =?us-ascii?Q?oaXqFhVO/wbXkSDK4Xw/2hiAwaBDssyVcCwSjZYSENKWr7AC9TOscIAiWD9M?=
 =?us-ascii?Q?Z70KHaTDNl21ZzZyd4hWC0rwKA+ixbUbJ19ZkIxA2LhO3mRYFTShL2Axq1o+?=
 =?us-ascii?Q?rhwaPuOh6brxxCNY2GDUWn41CplP9b57jHOdS9IzEkE6+6XDM35eeFKldABn?=
 =?us-ascii?Q?OLWHxHkDXAxDcisNWg8rotFfWhg6FlpvO5b/k6oX+TRXVQDE1vMyko9vH4L9?=
 =?us-ascii?Q?B2lqtq9r0HeikAemoADJuR7UM2QvyP21njGawnOciHhVXagrhz7AmvVkBG8d?=
 =?us-ascii?Q?NTs9nCxQfURZO81lcL+6bhjawsMIVapIswokD0eUprdZH9IlX/5gAWU9xsCz?=
 =?us-ascii?Q?Iy1k5S1wFK2Q9TuR50AnlV66aRMpGic+Mn2fxyqxj2kahRBVsppAUHoGWXpK?=
 =?us-ascii?Q?Gvm/fTnNWKNl0wIW4nA2TfLerILzHPEk00iYIqEW5SaCAfXSeilP2iY+cfTQ?=
 =?us-ascii?Q?bT/YWkH+aPdGYx/gfD27r9DkGbGdGcyyp7QyzTdv01wnahxbRJwgi6/YoCnv?=
 =?us-ascii?Q?z5tzN5gmwGTVHIvEAW71fVt2q7NfipXMTCwGApVtAxYN7vHKkXQW/7YJE7Ad?=
 =?us-ascii?Q?JwmMu3sXkfeuvc/NRroxWGPi1xRq7K3uHOJ3pzGIrY1czsPqCRxFGdeTBww6?=
 =?us-ascii?Q?cCHocy7e/L9IKXXcWZ1FMGmsfmCIDpXLhBzx3KsIeqyoNreODn333g0oL0ZX?=
 =?us-ascii?Q?ocD1r0gRrN7y9z1/qiKoDsFjFFEo5ix6ldp8Hs72uOzfLNHsHm2+upbYl/LU?=
 =?us-ascii?Q?QHTcDZ7F9udPzmPmDCM0b4iIyRwVqw1Tk0FQ+ZJiVacUCu6VEOhVvR2Iaeys?=
 =?us-ascii?Q?K/9QUFFf6zUeu0AU2MUccLGh2yrJMoW50soBHHl02WdkgevUK0iwF5kUIMLb?=
 =?us-ascii?Q?kamCKB4jH//IgZx0r3coiXEH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 507a175a-4a08-444f-8071-08d9327a2f20
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2021 16:57:40.5994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LyqFdgzAzbWAZaridupLavRE/CC07D4l4Qr1hX7TA6RtUjm++221JPaqxOIHEh4MppMXJzwUFlUL7aUXKvE6rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4996
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, June 18, 2021 8:20 AM
>=20
> On Thu, Jun 17, 2021 at 03:14:52PM -0600, Alex Williamson wrote:
>=20
> > I've referred to this as a limitation of type1, that we can't put
> > devices within the same group into different address spaces, such as
> > behind separate vRoot-Ports in a vIOMMU config, but really, who cares?
> > As isolation support improves we see fewer multi-device groups, this
> > scenario becomes the exception.  Buy better hardware to use the devices
> > independently.
>=20
> This is basically my thinking too, but my conclusion is that we should
> not continue to make groups central to the API.
>=20
> As I've explained to David this is actually causing functional
> problems and mess - and I don't see a clean way to keep groups central
> but still have the device in control of what is happening. We need
> this device <-> iommu connection to be direct to robustly model all
> the things that are in the RFC.
>=20
> To keep groups central someone needs to sketch out how to solve
> today's mdev SW page table and mdev PASID issues in a clean
> way. Device centric is my suggestion on how to make it clean, but I
> haven't heard an alternative??
>=20
> So, I view the purpose of this discussion to scope out what a
> device-centric world looks like and then if we can securely fit in the
> legacy non-isolated world on top of that clean future oriented
> API. Then decide if it is work worth doing or not.
>=20
> To my mind it looks like it is not so bad, granted not every detail is
> clear, and no code has be sketched, but I don't see a big scary
> blocker emerging. An extra ioctl or two, some special logic that
> activates for >1 device groups that looks a lot like VFIO's current
> logic..
>=20
> At some level I would be perfectly fine if we made the group FD part
> of the API for >1 device groups - except that complexifies every user
> space implementation to deal with that. It doesn't feel like a good
> trade off.
>=20

Would it be an acceptable tradeoff by leaving >1 device groups=20
supported only via legacy VFIO (which is anyway kept for backward=20
compatibility), if we think such scenario is being deprecated over=20
time (thus little value to add new features on it)? Then all new=20
sub-systems including vdpa and new vfio only support singleton=20
device group via /dev/iommu...

Thanks
Kevin

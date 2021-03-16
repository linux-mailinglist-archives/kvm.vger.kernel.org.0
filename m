Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEC433CF58
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 09:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhCPIKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 04:10:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:31580 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234112AbhCPIKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 04:10:07 -0400
IronPort-SDR: HDmYGQLtNSugDVUzLrvzOY0ELucFQd+XV5N3oVsAQcATZbhWs8WiXZib9fZO/j9koBbpZeoKEK
 zKLQewBsUgdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="168493467"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="168493467"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 01:10:07 -0700
IronPort-SDR: POyUibgUYITeU+3WBSUGWuuuS8UuHVXUOlN4VHURAxKEQ0PwNb97PmqcvoIfSx9rKbh/srN4fG
 m8AOWK88sdJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="605172112"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2021 01:10:07 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 01:10:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 16 Mar 2021 01:10:06 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 16 Mar 2021 01:10:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3G1cvHzcKyKSAgQfhMxjRaxnQDsCG/PTOk2t1JuLTAv53FynNwBD9Gg3OIsE6Bz7bdIK6zkW5dPPLD4Z7KEBQ1+UgG9msQ/Re4eWZ/ag9ZQNkm+gz7nRJZEq3x2QnceXehH4ZZRuUxUhddYGjoe7u9r1btQUg5CDi8D7r+9zfETspc+p0ZpARH+cjsq7Llv9lW6kCHpY0L14Z2wXCy9yE4mvZuIz6WDzxxl0mYAmPzkn9NfetPkvJHTFB3nnIRjzepNKAX8+Mgy8nlMtGw4WjlOdmaO3Li4RjrIOeAF4Rn2YO53PcMCplk8b/sQp5Czizu2iNLBhd8nc1OM9B0d2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67yi2FMNXyXm7ZbqiFhQkjtIBlYhp9YWZchrnbRuWIo=;
 b=niE9NfA/kqEwWtECVWNhFbo5sndL9Z5leBJXZYutHqhXSholWIl6oB7vIv+zk8yf4AXgXgStL0md3js1zyelQ9unNMi7ODvcw6Amvc1fPepH6CUwjaEIBS2f4Pj1gMSRZTyuSlJSDM0Fk29B8CeMQ94qa6wKNGHWFWVGEhDHrgonKnazBkDcjOhNWUSWExLbGCGagHDQmsP8Kw9E/lZqQXX49Cv6caIQProYR6Hm5xP8KgQFTSbctRw1iEH64AkE9uOMNxi55QxBDIQSCeTQqZubN5vT/fqUCbi9OI4FNfy/2ZGUGKqqShT4gUqbAit0zdvVjZu9JzqkMjl/gT9f0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67yi2FMNXyXm7ZbqiFhQkjtIBlYhp9YWZchrnbRuWIo=;
 b=cMJg8OB7NEcVRjNwyLqc/TDQ12g9kjuzxMYzt3a2IkIe8GGwifrBIZT7n+X38pGmMyriqGwAoJEK09yH27Bg6OBNU5QjNabMasne4ntnbx4N/KS7Kd7I6347f3PutVCxWSpgG2D11eBQ50b8TgtXkENY3Gy1rbolPZBvjmq16gg=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR1101MB2174.namprd11.prod.outlook.com (2603:10b6:301:50::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 08:10:03 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 08:10:03 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH v2 11/14] vfio/mdev: Make to_mdev_device() into a static
 inline
Thread-Topic: [PATCH v2 11/14] vfio/mdev: Make to_mdev_device() into a static
 inline
Thread-Index: AQHXF6Pqc2bu6cws1UyP82PtqlBFRqqGSA6w
Date:   Tue, 16 Mar 2021 08:10:02 +0000
Message-ID: <MWHPR11MB188608CFFDCA818ADB8D74DD8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <11-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <11-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ab38a9f-3b57-42f9-8935-08d8e852e6cd
x-ms-traffictypediagnostic: MWHPR1101MB2174:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2174CBC183A2E1E20D97EF118C6B9@MWHPR1101MB2174.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DPtTWJdCxSbDPPcMR3usmoTU5Ls1oNLaqpeXOEFP8BGpcE7byvRD+c64sgQcPn/9WAeYLjK3DAYirXwYQ7IYrYPxkwKydi1My3zLFsRzPwn36b/Y7jW1pkFxY8fg9WEuRwbBLcXv2DZyHltSophLea+bm7SEtNTMggNRgPujcsEmfPFLXQNe1lNRkLELSNO4cBuFFCqTngQKYBFOnSeSzf/r4EEtTuV6AI02pTky3UvRJXsgh2dJmv+Aita5qfnZ9fvogV1CS4j+lV1dY7xD9hEznTdCGx8E07N00YMtUWa2tbgcCC5/m9+G1BKJkYE+p+0qgVAZ+h8RERQMM1tRj2Ne9xV0nkgdX9LIFA8ST/9+BEbGc4kP3TMf1uluubd11NdkS4FpGa521QkyryvOr2nV8ivtodpOCR68RZUj629mld5biBaU8kvzTmxOhstF8V7DSBtFHWxr/catAYdKDakJBATC3B6xhzNvEt/NTtN0zr601PT7MyEu/tbK5jkT7jjPfem88EdnljQux0MlGWwm/Ohv64VGgsssggIs0rLpoBRNXCzqt+HTUk0qy6mb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(396003)(39860400002)(64756008)(4326008)(76116006)(26005)(66476007)(8676002)(55016002)(66556008)(52536014)(54906003)(316002)(66446008)(478600001)(5660300002)(7416002)(6506007)(83380400001)(7696005)(86362001)(9686003)(71200400001)(8936002)(110136005)(33656002)(66946007)(2906002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?W0qjpiFey4eBtvPIHPoDvo3DvT4QD3ngOG4um52DSnpdLYgkO1UzDIQg2S9F?=
 =?us-ascii?Q?1jWaVLBS64R533etIjxSIhUqsRYnyP4osG0w2HhL2LTztpmQr5o8RDOxKgnQ?=
 =?us-ascii?Q?ENB95s5dq6gkQlDccteXDA435ihfSLFtyii6R9TNVMyv6bvrMbpogS1MGCf9?=
 =?us-ascii?Q?MseSGDyX2uPsqU08EGTBnAFOmBXIoZDKvndfcxPnLpKCEECW+HlhBE4nwYL8?=
 =?us-ascii?Q?DFm/ym3bTx2QtXItfHY1MDOebJqPpQiGgrpazO8xhJ5GFPRdvMMeMRAceImz?=
 =?us-ascii?Q?1MQBU5M3+ZGhGPMPG1WQ28TVRT1ROrPkJy6VS+GWTl1QQ08H0lcRFNrZNust?=
 =?us-ascii?Q?6xwVLPkjLwetdh7B2uY9cm/cUNEUG4Gih0J3a+WnZv6v4gCBppVWs1Fb7ooE?=
 =?us-ascii?Q?57vhgMqkb2eHKFR5C4+mWYCFg4tMSZfAV4BN420exiMXMsTU8xLfWuAi/TuC?=
 =?us-ascii?Q?i/CufMb/We8kzz/SQc056wbUOl0SCkbCvVhKiJP24B2bb2iJ8WD6PuRhzI1Z?=
 =?us-ascii?Q?k+qpv6bk6i3+zFFWD5hHEoNyXDCUsmYwoVL9LSUDm9gvVgBVeGDBay6QEAE/?=
 =?us-ascii?Q?EMgxRYTsBp0TlUSfeCPypgwWdjGYvtv6pXWp3y4NObwYZe5g8EBtDrZR6sNc?=
 =?us-ascii?Q?PvoldDkmIEZ8DdLWjic+anytrgvp+qZvFPCV8WPodp1rdUtZRRm9jg5ZFort?=
 =?us-ascii?Q?bSTpa5pmGV+qXVJtmsZypDqorNLP3qDe1CveHri/Kxk5Pw4/wAIRFFFmtz79?=
 =?us-ascii?Q?ZJYr/1pGsaMLULLrhaVxldKL6GKRHK5ziaWdc8jF0c7fpBb+YUeNLhroDMJn?=
 =?us-ascii?Q?ysBxEW+OJAcVMEg8MPaRycR5s9ja4OPcbJ9PwWDezta5sLUID+wDNSutaoRr?=
 =?us-ascii?Q?FjuGKJnu0MisfOyIQhZva0qwwzPzUZg3DE2fcJ7vgj63pAooVC9Yarn0zfaz?=
 =?us-ascii?Q?vwaHoRUAHk3IgFw+Y7hTbZZcqvwOsHd4xRBRYlwXprLQj48YBQb27CLTXgJJ?=
 =?us-ascii?Q?qNHX/g1U7wz0XMRf0/58W7fA11ATgVKY1ztGM8k8QRMSbMsbyxSwcAm8JOD+?=
 =?us-ascii?Q?+4AshsmBCsRdhkLcaSMzNf/TEecqQ8pjt2OAwbI2WGxgBO+7GXB3wR4vp6ed?=
 =?us-ascii?Q?7F3BiOuxuERfKpUDAQr224fp6RtzCvlPhrLFiHzzmIYx+os6nPQQC/TWmm0P?=
 =?us-ascii?Q?FVl1LQaBlq+WuxNWzZRBR43FAaBKVSbnuqbB1Tzvf7p/GbVwe9XZ+JkT1lCZ?=
 =?us-ascii?Q?0w3BFn0jZEJFreLiPAEfziJ03b45e7uYA71ByQc95eXElh5ijV1j3BgnOjPy?=
 =?us-ascii?Q?DleCjTukqfdT0FkxYDVhuyYb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ab38a9f-3b57-42f9-8935-08d8e852e6cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 08:10:02.8947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZJD3GtW71P08QsKn0OGci/qxUabHZaHvdS0xwkTkmItMctfeo6CLWSk389+rZ3oPQH8hjoW3x/4Hx38MPuT+Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2174
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, March 13, 2021 8:56 AM
>=20
> The macro wrongly uses 'dev' as both the macro argument and the member
> name, which means it fails compilation if any caller uses a word other
> than 'dev' as the single argument. Fix this defect by making it into
> proper static inline, which is more clear and typesafe anyhow.
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/mdev/mdev_private.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_private.h
> b/drivers/vfio/mdev/mdev_private.h
> index 7d922950caaf3c..74c2e541146999 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -35,7 +35,10 @@ struct mdev_device {
>  	bool active;
>  };
>=20
> -#define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
> +static inline struct mdev_device *to_mdev_device(struct device *dev)
> +{
> +	return container_of(dev, struct mdev_device, dev);
> +}
>  #define dev_is_mdev(d)		((d)->bus =3D=3D &mdev_bus_type)
>=20
>  struct mdev_type {
> --
> 2.30.2


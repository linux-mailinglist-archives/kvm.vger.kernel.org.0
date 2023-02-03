Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EBE688E6D
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 05:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjBCEH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 23:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjBCEH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 23:07:56 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85EB3C36
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 20:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675397275; x=1706933275;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uPNSf6h4G3M34cGdkpmwIlvEdNgnYYximWdIgs93D/E=;
  b=AoPp3hA/YCn5xxPq0WJRPyaNanTDw1bPpNLVAWkzv2ia1s6l8Sc07H3V
   M14iOBweA8WSgrQDNMXt40EacJCVdIKVEAtVSSejnsPek24D387/o3FqN
   YHKWLjSmdmrjf/iXuAQlPlAlabQ7vw0ZzvDiNu8QG0uTOyACi8L2j9yVM
   3ZfNfp7+Pgsrj4ffW0mAz4EKAXKv/D+IHs8Xx19BjN5+msNVfMdW/rIXt
   QXQTDYPcUwMmtBjM0wCiKS5QRAkFmff+KWGldRFUPMm5ri1JdcMxAwM5s
   hbggdlq/7TjqtCWagS1TmGcfb5eh++g7vVePhF2+6NWuWug1cjF2QqldP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="308987846"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="308987846"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 20:07:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="808200146"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="808200146"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 02 Feb 2023 20:07:55 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 20:07:54 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 20:07:54 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 20:07:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0skBSfCbfUaL3US1yExSi6TcXSKrfosRdxN/xq6u9PAwqhqSJXXQgWuVucte/WdIXyqBDah1qn4N74L36GpV1pS4ap+qvVT1FXnofGQY01FaKRI/Tevkhr2ARWbuwVIvKaehdABBIrqhzrlHSAeZY546LACREsnip36e5WzCCZza9k/OS5BggxgualDVGxWhhMjXLvS0h/XMlrTusmfjZ8EVQciVJOnnEeScEZ2kjJjL8rNjLWQ/nwjs3m4UbP2O3D3M30UtmT62OCmdS3Mjna9TSIkQVxiq+++0BVOVT2mocNFCNwmD0hjrm5xrFN7tR7P4hJisZOBXsHLbo2uPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwDjsDjAjf3ElR3nFPNJyKpB9/Rcwhgq6Wv37epuRl0=;
 b=nD5YnFHCvdAbZ0jPOOUU5roVXz2bbavWH1qLr4ftYks5+XFGAtJ11d5TJrkTYX9f0hIfrQuGYJ3g0bNQF9ZJ7wRo1KGXpcBDiksb091eV5IiZxEU39q2Xf0OX6tcaD1i/SWh+zxkt5GXXnPcItdAj50qoEV3C9BkqKh09i0LWKC9P6lvHMbHHvsEXs+dGJKWSEnsXWJIYQ7aNI3u6jbYS4JoWBpmPCCUoRIo12oFFR7U5PITVnFrlKLXFwYdkxgagZQmeFDS5dQoVn3GvC/jOI+HiV/WalI2q2rx6hnnlrz119WyFEgaDrPTcHWzgYdbPkSWRcTgZxyZ6FFFfvawew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5041.namprd11.prod.outlook.com (2603:10b6:303:90::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Fri, 3 Feb
 2023 04:07:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 04:07:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Topic: [PATCH 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Index: AQHZNtymRg8eocUJL0GpJUe4G2Nw6668muPw
Date:   Fri, 3 Feb 2023 04:07:52 +0000
Message-ID: <BN9PR11MB52767455B0FAA0CCEABB05238CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230202080201.338571-1-yi.l.liu@intel.com>
 <20230202080201.338571-3-yi.l.liu@intel.com>
In-Reply-To: <20230202080201.338571-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5041:EE_
x-ms-office365-filtering-correlation-id: 479c4baa-80ec-4a38-df55-08db059c3890
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eHIge6iJccnBQqDCaOqKGfPFXqL8YeecMA3p2Hq8h7XqWnNkbMTEwxTdl3vBgitYypYX1Rt2kzBscruRxjBBlm0b37BnpduGd9496iS6zCLwu5oD0vfaVFSoP65sSdPXT8gC70dbtIb7s0BB/nhCHaxi64OEhZGTgP1DqX27i5K9Y0crgy5vPn1O55oxgAUdsMLZwvfFsa0YHkdkAQ5fof1G3W/dP0XLmvvM669sGipZEDzca2oB18Eyr40r8WEpw1OZjXcLwc8KSGXu23COOdDWBiWKcQhiECeNskZVVWf5fRgsxq+LLl9pHOON2GDn+yPzL+ykCEZTdU/IyeOPaQAXeW0tPyF/CPRTdtpn7wPU6i/pdruM7M396iZrpLRBDYiVi4TmBE7aGnbmRTg5buQyc0ukyVJyLKCdtsjy+z8VaEzCJ5Iq3WKmXDuMOt2lWSfDPJXCXTc04zofv83c41aXo9qMaTwVpHc4/fTApgKf3qcFouOPuKvkf2J3K3KsIMwpd1HEvFM9XN+CoyC3tJN7z1mJTkhnxbccekzcru8XxNUuzuuiEU64pnYr1jEABXPxuFEb5hLM4gqweRdsSxUWaJhatpauIj1GBrf+pZUAW3vk3P58o3yiWuXRQi4yh5qSw32G1CQg2GgGlQDmkHzvtmU4SSeVN94Ix8ZhhoYZp1NQwwa70ZMWDAb9QBuTZyHS3hFtHzL67yMeW4xnGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199018)(83380400001)(122000001)(316002)(478600001)(9686003)(38070700005)(41300700001)(26005)(186003)(86362001)(55016003)(71200400001)(7696005)(52536014)(8936002)(82960400001)(38100700002)(33656002)(6506007)(5660300002)(66946007)(4326008)(66556008)(66476007)(66446008)(64756008)(8676002)(76116006)(2906002)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K2crFxE3YMTJdw1y696BKfA+hwbpoMS4bGE2a7tOW59Jhxyy9DQ0aBu/+ZQT?=
 =?us-ascii?Q?XhNSBQvPMJzvWiwNpIr+0uQwxOYZf+N+Z1UVAtqQgyS68NY11ay7ooJcLEFU?=
 =?us-ascii?Q?48/PFyjPVEaLbS0TvgvP5iIcq+jiX22s4EE0mYylWUzMtSzTCoagI2BR1SvC?=
 =?us-ascii?Q?TKyygKNfAqxGA7OsQFgFiBbVOGFh4E+QflvVuD0T+q7ATAMkPbjoMH8ZJA6a?=
 =?us-ascii?Q?ZgsdxG5DkCgfoNun9noXAq0LI/N1ZZXcKwwfmKNZyZzBouZs+WRb832Nomum?=
 =?us-ascii?Q?qROrII1bTax2Sy0dOTa+fAOfDGkfMIX5zn8JpaOcfnGVId0XX5nevFnCUvmr?=
 =?us-ascii?Q?wJ2pdeCh0WcMnxR1ZBwvjXsNBSb2+wGUY3Rgk1KxxhAyw9XvcUpXbJbbg0YZ?=
 =?us-ascii?Q?IxkrFHB9/P47c6TxOPKT572YvkZL5Na0uMdma/tx7CVPqFvxRE/XLpIUKGu5?=
 =?us-ascii?Q?4kea1dj24C5qevnivqGRNwBNosYv1jOObZ6nHcCvWfBErW7gYKDiLy1S2qVS?=
 =?us-ascii?Q?SZc8nvtlETFJ2gjw4PYfkZSV10evKiTqTcQOeCBFZ79UwafcM2oVFGSnvbnA?=
 =?us-ascii?Q?aaRgsmKLqL5GUrXZO4BDuTgR08WRXxxWLJmgtLHGjjzfSvUqHBpAuLol6ww7?=
 =?us-ascii?Q?eTivVfmdYrlZX6i4e+I/1cgp1resW6Vk9uLje5+9vYnuDGJPZFVYgw0EpjuQ?=
 =?us-ascii?Q?kmiz6PYjumBH/7x/eIa2ErJNVgNfXAThIMHmzry2LLEGSprLXqpmkzFnljXc?=
 =?us-ascii?Q?y8QLrgKkFm7MyEz2qrRl0TeMsDWQLnrHFETjVWbG5N2nXOiJCWyGuOUauOKY?=
 =?us-ascii?Q?lUzhuFFEGlvDWNwQ1ch9d93T0Q4eAfRVnkeySNP8o3a98fGaf7AyULW4rg5F?=
 =?us-ascii?Q?4K8B6ESo0+mF1YbSg6vJ+95P2swuh7fdN6tbGOliHJakquw0oRP7Ne6c9oJc?=
 =?us-ascii?Q?qONTQi6BCTZmdjTjMgwdsrhsSeZMV5A/8zNdhlGiNa88XsbIp3BVhuEe0WyC?=
 =?us-ascii?Q?rtMhyGPuucs/cf4nWFd4nzX+v1+Jt16at622xMPv4SUXQ50Vpz78QG7wkV4b?=
 =?us-ascii?Q?r9qUUWdQiVzl39srw67aW0e07vVqg3TRF7kt1ZZ0bFuHbFhb14uXOw2n7RbI?=
 =?us-ascii?Q?F8jDS7IUov4zLSwT7Ales9VcNX2Hyz6B5s7BJLPSfXa7JT4Go/nT7eX5ICA1?=
 =?us-ascii?Q?LWlgQDpWEayg4uMYqRqL8q4WSRNfXKVJOMoXrvISn4/Zog81J12QLDIF0eag?=
 =?us-ascii?Q?eu2Tkc8m8BrKmIYJdg94fjik4cJZzEAUndKAgoZHM4DXebiwbUYn50ORv/3j?=
 =?us-ascii?Q?O0yzre1FCO7nsW5qZiZ5SaMkRkqNUvAwFxWA6N5ICJmot2En1PkP7MiExBpg?=
 =?us-ascii?Q?Yf9IwxZEHs1F1nmIPu58cOzmIrVydg4CGNgcFryWei0oPSvFJMHzqVehndRR?=
 =?us-ascii?Q?UvMQ1D6oVQMnA/ndTSnBnNQfLb1Xel2B3c/Jtut80TQTU3jlT45QzxXnlM0x?=
 =?us-ascii?Q?S9t79t6Tmrc41kVEvxSPMYr7+dJxtiGqhg1SysiYZwikLrziCR0Fm66vymN9?=
 =?us-ascii?Q?qXvpJHnBX2LSoMARUqtADXmH5+CiK8pIvDqelrDz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 479c4baa-80ec-4a38-df55-08db059c3890
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 04:07:52.4819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tq5PkY2Zzwax0GEQifcOKlpIltGo+RchcTsCTN2ZPOxUX5hMJgNxPWS07sSJCSKH+4McF4SBMr6DckyDe3dyPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5041
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
> Sent: Thursday, February 2, 2023 4:02 PM
>=20
>=20
>  VFIO bus drivers, such as vfio-pci make use of only a few interfaces
>  into VFIO core.  When devices are bound and unbound to the driver,
> -the driver should call vfio_register_group_dev() and
> -vfio_unregister_group_dev() respectively::
> +the driver should call vfio_register_group_dev() or
> +vfio_register_emulated_iommu_dev() and vfio_unregister_group_dev()
> +respectively::

No need to duplicate every function name with the below list. Probably
just say that "Following interfaces are called when devices are bound
to and unbound from the driver:"

> +in the vfio_register_group_dev() or vfio_register_emulated_iommu_dev()
> +call above.  This allows the bus driver to obtain its private data using
> +container_of().
> +- The init/release callbacks are issued in the drivers's structure alloc=
ation
> +  and put.

"issued when vfio_device is initialized and released"

> +- The open/close_device callbacks are issued when a new file descriptor =
is
> +  created for a device (via VFIO_GROUP_GET_DEVICE_FD).
> +- The ioctl interface provides a direct pass through for VFIO_DEVICE_* i=
octls.
> +- The [un]bind_iommufd callbacks are issued when the device is bound to
> iommufd.
> +  'unbound' is implied if iommufd is being used.

I didn't get what the last sentence tries to say


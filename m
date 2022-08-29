Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FFA5A405A
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 02:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiH2Aba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 20:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH2Ab3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 20:31:29 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B217F2E9D4
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 17:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661733088; x=1693269088;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=HLwt4+SKrZ19Htb8XnYBoIH9cukq6yF7WdCu4l0q+zQ=;
  b=ZzZW2CP9XGFv6jEuUeYFrhaB5o08lTjuHpNFfxbksVbkk8I9hzlOqIq6
   Tb18mq9LCehEw498s1hND7eWSc0TGG90YlROeCf9DQZbvcUu/t2xyEMDC
   6F3Ti/AlPL+Y0hzVbJQLpeZ01DO3Nq4g9rT9/t4yPEDFkphpxQZ88D0Pf
   UJCidvWm9LvNcXN4wmkDXZ2Kn1WNZ/+EAHbXFDaHxq5meXWbhcr+MhiAH
   iokEwSh2DDIIG4Narht6N4THl9HpyaQHtND6Y1Uw0ileM4nQulBzWzFNk
   2cb0mmVlaflTduDjh7lYt9i9+w1DrewImpNBPjOADCApwtrghivg+Wokl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="293524688"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="293524688"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 17:31:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="714668341"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2022 17:31:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:31:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 17:31:25 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 17:31:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDsk+JSxME8Iyeg/VE8i1IYRiYY5yWUKmkQ19rpKFw8IjxwVSfs9PBMBZZskO9A49Epvsvfpp1+563bDLygJQTfJRxqlwfTaWuWzUXe8m/iVNvAIi26z2dYznq3hEA4AF05tECpCYN3NPprsktVzpWoGFlMTmUjejRBFN2lCQoS/qZXC2hvglyibkv+QzdOtYILyv6Ozutx8G7Odhu6uHyZvOOJ5rvhmbXAmIdwX2kRunJKlSS6Fy+BOCPZZ9rEn1ZsXXWZqTA9Da0kzGEryYrq+SQ22VD56tzNpHxCZnsdMNxG+bp778MnQjkTzMVnNkqjSgQ+jqBk1MaXoFUdpbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLwt4+SKrZ19Htb8XnYBoIH9cukq6yF7WdCu4l0q+zQ=;
 b=U8YR6Pkslofpq910pEN7GOSI7/BA1Vg2r9nCwszjpoD857DFvica/Wl6G1dIjgrFm5YSWAvMzoADWV+fKqM+JltgbbJ8icoxzvBRaihzc2c62CEdssMBovCXW9e0Gy86RUtAXeVDrHr/fRaVvtLs9BEVgJUqQlyMy1pBm/a1ZsKOrPsyHSWMJsNNX9R0B68E/UE5/aOjvYZDQ8R5dKyAVJHE+gNrZSj3HgUGszxmecitxxnIL7DPrQ3X0a85J3+bFkmRhcvPlsKAi7hYQmJ8fwPsWx3yzY2m8cdMztAF90AMmMtJoHqdHw18GhxMruO72H2LhXQYR7s3hHw8sH+Q5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5792.namprd11.prod.outlook.com (2603:10b6:a03:425::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Mon, 29 Aug
 2022 00:31:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 00:31:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: RE: [PATCH 2/8] vfio-pci: Break up vfio_pci_core_ioctl() into one
 function per ioctl
Thread-Topic: [PATCH 2/8] vfio-pci: Break up vfio_pci_core_ioctl() into one
 function per ioctl
Thread-Index: AQHYslOeZNnKdFSOxEKW4qbWWSNmxa3FGIkg
Date:   Mon, 29 Aug 2022 00:31:23 +0000
Message-ID: <BN9PR11MB52763B5ABDB52DB9D8F80EDB8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <2-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <2-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e78ca14b-57d9-4ceb-f250-08da8955cd4d
x-ms-traffictypediagnostic: SJ0PR11MB5792:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K4HzEZrYwK8Qcc7Xvg41kipz7Nx3k1NXm+1VOuQ99zg/pUredSgD9wJUXTUuWeFtPH7DbFZq0966j4QO+E8oTPcz7eLExB55vGgaNUzGBjZFqXDVtyWaCSdSeyLr05CkTMB63v/m8jo13mb0TLsp19AlweTPt6ByrRfME+tC8jT2XdRHw3kFovLN5a9o8j1zOhcNLxnnWwWPRk/mKHhZGEj6fLGtjHUfFPemylQ3hAv8mhfTWu7+KOEwfBKnC58aYStybLGRDEGRYyDyoRPUyNCob8Fu5g69QyV4+4d3GwSTUitbic6GihIR3/kvfOWIfet14aSM4amGUL3muDtzDYNWLKl8n9WGvRpn+lSt9mDprpPE0952KHo4tajIeyfE5Sq9btiEbwUn66JtKvu+WvHkpT1Q4bNBvGGCJUR0JNoIFqyl63cCmyZNOm4I+9QQ1LRPMsUZcnW34ueQ1HQl2mwKM5KM1vQYU0HhK01BB7embDj3vQLVBBzm5kaXQVjNWTBVqMPf4jgGiBfn6RNr7emyrA3MbFLXWrBgyaq0eziuORe8OElWCrCDrPpDg7/GNrA0o4b4Euy9tVF0jn+4v/8oimDrnBwoIntWu5k+42u1hEsiHeKHQagI30r6luDfYVhLhP70AGYOOqq89BL9PzZ+qu0JiRrQHemWiAaHHZgaICERjLiIZv4yEDdWiJ32Qj2fu3Ce+JcBy2na0dviqmsCVvKakeUNZD+MeLFw1UH+qkuBZ2JObxFDfrus9ILHNrwVpzQwNZdUzdYxElXYoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(366004)(376002)(346002)(8676002)(110136005)(66946007)(66556008)(66476007)(66446008)(64756008)(71200400001)(316002)(76116006)(38070700005)(8936002)(86362001)(5660300002)(478600001)(52536014)(41300700001)(82960400001)(4744005)(7696005)(122000001)(6506007)(9686003)(2906002)(38100700002)(26005)(83380400001)(55016003)(186003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AqlxQy22CjJlvVkn4DPa0y7uXd0tRMMTyGlMeca7wJ82KZQgnzYGYSEWiYND?=
 =?us-ascii?Q?lKMRo9pnFv82bUM2lxG5V39R/GwgWnsBVtKnJD8i42ezCVaehKkPN4Hw9h3A?=
 =?us-ascii?Q?fl0U53h8OvZPDIBEtU4OIw0sUM7j1wXEk4E7ArNua5Foqu4dBtUXQBOpRmv3?=
 =?us-ascii?Q?Ar7ZtnU8hZZsylETLF6kmXkR3S/b7aluDHvicfdn23sySdFqu27kya8t/PYA?=
 =?us-ascii?Q?42KpI4Xu6HO9cHedUcLWhYigsbArvAydI++EqPgXZsWphwKN7h7EeYJTueFj?=
 =?us-ascii?Q?unbb72bUe2EunlZrYrw5DYrFkK9yPe3vYJgpKJw3VrHO83w02ZI57dtzXKj9?=
 =?us-ascii?Q?0o1Bat0XwvszYzO9BtH5jMwsYIuUszPVD6QieRewX/ik3avCmPG2cbGFdp2e?=
 =?us-ascii?Q?Rcn9NfpkbC01yDXdYJQAdmg8ewEN8KIMLAFKRuWGHi8kluS73JpwAmLM0Klu?=
 =?us-ascii?Q?UGrp9D9u7av8T7LiEVxBP5Cqfr1n6HGtWLi9L2K+XrG3s/bKI/5D9QejJrnd?=
 =?us-ascii?Q?oaeZutCG8xFwSgiaynfOa1XqVyxPTn1uEd+KfOSSsnsmy9xg+DzQ08FlH84F?=
 =?us-ascii?Q?MSy4kHk/oO9Z9wXUklL/nTXayH+PpggbzcKnvH/MDNrDbprNJ9RSXCwjtjrx?=
 =?us-ascii?Q?xtXxcNlWs3TY05sD8hGxhuRgq0v+HcducWOkls755349R9Os0q8tiLrkkxns?=
 =?us-ascii?Q?uaqcNpLk4ijinxezdn7IRhjhEcETskJBsUymqxs7kO7WVu0BshrK9hbcHTDG?=
 =?us-ascii?Q?n3q57R5vnNa5ExQavHJZEEeLtuN8OLQlNFcluKZypMXrnDNg5IUybuUVrahX?=
 =?us-ascii?Q?ZnIoqJzG221pIdS4veZbDrWE+Qzk2p0uSf302OA7Ffk6jpLEpK0nOzeuBYV+?=
 =?us-ascii?Q?C5RHOUfjIit2vvDmWWMwBfV0V5c3zgzbyYwcPLrscV2z9ZjAPbN8tATdFSTY?=
 =?us-ascii?Q?WbIsGH4TV4jotTiEoXIIswtRQYvY6JWzddJRxJmixmeP2RQpev5pWy0Fk+kQ?=
 =?us-ascii?Q?iKPWbkxJnvkARXipLMWA33kDHKSYi9QmUX+X2SsM48JHgJnySqRu+ww/0jht?=
 =?us-ascii?Q?M4LdZTdIiiE5ZEqPKPNYWvqkErvKxiQ/xMDnBbahpOn5EqH10TZDY0JEod31?=
 =?us-ascii?Q?CXGRxTrZoCjiwxfS67XeiymV2+DQMXBBDR5XXIDAz2pCT1PHVb6usJSmIl1n?=
 =?us-ascii?Q?cRpk5YJ64DyB2lR83E0tg3oOGbUz3REMyX5U6fJMUKys/GuZp5kt9u9rGsFK?=
 =?us-ascii?Q?vSv6X7pFYTCNO97U/AbNfxMcCsvogBG5+/vGLhNq15JIr4bKcHwN3ZwsT2w3?=
 =?us-ascii?Q?Sm7SSXbpzrubaEf+KN4WihedpUVSaL6zKqR7iGVyte88Cu3GUMuX+kW0Y+pi?=
 =?us-ascii?Q?iAsFHbOeKtLSsujuFKf86Iu2ytR1IH9KfvN5PS/TkZnmbK4WRisUAuycWHkP?=
 =?us-ascii?Q?7A9OpJMeWwzHJvWzctBEWjoTRlggXOCicRip1bELy8zrxx+kLiJ1Mfpydtp5?=
 =?us-ascii?Q?T99U2NUi3YUXJbqoulsNirKiKKBUVObv1MiQdtMxg0/OscoknlG5EP3GKgSL?=
 =?us-ascii?Q?i8//l3LUf05+JAoYjALrz8WpMBOX1KEMXqX0rGCu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e78ca14b-57d9-4ceb-f250-08da8955cd4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 00:31:23.5540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7I7OHdsqm99Ztg3+apzlHfStB+77TyCZlpwHZqOUAeeC/89uoyasfaZUVhIDyEom+bIg9Hloeap3yXZbxEXeTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5792
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, August 18, 2022 12:07 AM
>=20
> 500 lines is a bit long for a single function, move the bodies of each
> ioctl into separate functions and leave behind a switch statement to
> dispatch them. This patch just adds the function declarations and does no=
t
> fix the indenting. The next patch will restore the indenting.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Signed-off-by: Kevin Tian <kevin.tian@intel.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF502786856
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 09:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240352AbjHXHaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 03:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240368AbjHXH3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 03:29:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6764610E0;
        Thu, 24 Aug 2023 00:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692862186; x=1724398186;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GtrptAsWlQSrc0LhPkV7fyD2WvTR7p8Z7nS2U4Pvqr0=;
  b=dBd+arT6Sny4xBuyoHAWkDadUZloSlYUOTn+Z/owx1Iu/MfxbnZh96pU
   V3TNkxw+gG7Xfqte+LjM6hvNL0ceKIFWzOnEOOse9jhltT4mWqmGk0ZWV
   Roqw0mFO+1KIe4FskOL5/TlPFrB39trA1jTIkPsdguKZDmlIutzRIyene
   uNrIZwPILumHGzuEoC5wdvaXYuEJCHslNN46sCtRfjgH9F6yGXMKfNGOq
   R0m0IpzosEycT186YGYS5bB/Y79dby7+cKqLHq8v4/6zwmCOW0fvwVzrG
   KaZfDovyi03xc0metgukf3rTHLN9ooHMylhVmavuOViVyuUZr5zjVnWFQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="354699803"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="354699803"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 00:29:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="740069764"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="740069764"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 24 Aug 2023 00:29:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 24 Aug 2023 00:29:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 24 Aug 2023 00:29:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 24 Aug 2023 00:29:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f81SLpQHe9FefTGu58riOBb1q3JsTTBg7Z9yzlKNhcrtx476x8StxNo/0sHtpZBSnnRLLKF0RRD9nCPf0d09DrpuOIEjSLNWyiB3HOxoGCwxGlLipMIgzfH/8vGgi1QjiDHqutCCFGhcxn4Ue+ksjI5Ld0/+pzoVAufBxv5KiFdMjwL69WwdTIRZy/CbdhykT/PDvSPMpYgyVEuagwG3K5cdf9Tvh4hPN4ZXKwTVyrwPKN1dkzL21sbKLMw6JzfES+FpOb+8xxQA1lRB3NwamGcThau7LvCDRf0xy+RVmOahB0Xp2Fe0f0rVSi+YjSnY71CjIJkH73YhQGCUUnh52g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GtrptAsWlQSrc0LhPkV7fyD2WvTR7p8Z7nS2U4Pvqr0=;
 b=A+039w0RCNTBSy1y+wQfRtfTW5pJ629kH1W0sRD8rwxDAVJPAwT1iFtR7WklwaixpMqYrjTNHAtYF72jC65H/At1y9m8UiXGNrQfPIBYEyoc8Aq3DHjWF+dJ5JE3o7QobuitLeCnJ1wUXXaAe5UFV/mantbw6wXSKVJGbiGw7NpO4axKo8qGv2G3Oj23fs7cf86iz0D5C/WjpMzC9RcZW27ZFzcOmXtEWgdukt+1HQQi07228mxnK7pNuIZrWy99v9Pf6n1rBVZqNHmszPQCen3g54Oay7ZFWbYqfl4isLHX0RNS4uftKPVFZympgzpebS2cXe4lWFwjlNCdLM8snw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by DS0PR11MB6376.namprd11.prod.outlook.com (2603:10b6:8:c8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Thu, 24 Aug
 2023 07:29:43 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::889e:2c90:67be:2005]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::889e:2c90:67be:2005%4]) with mapi id 15.20.6699.026; Thu, 24 Aug 2023
 07:29:43 +0000
From:   "Zeng, Xin" <xin.zeng@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [RFC 5/5] vfio/qat: Add vfio_pci driver for Intel QAT VF devices
Thread-Topic: [RFC 5/5] vfio/qat: Add vfio_pci driver for Intel QAT VF devices
Thread-Index: AQHZq1VcBEuBLxaWQUiMZlgj/qpcxK/Z/08AgB7uEUA=
Date:   Thu, 24 Aug 2023 07:29:42 +0000
Message-ID: <DM4PR11MB55020CA7EE0B02034C925EDF881DA@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
 <20230630131304.64243-6-xin.zeng@intel.com>
 <BN9PR11MB52764EE5BA68B6E47028FFE58C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52764EE5BA68B6E47028FFE58C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|DS0PR11MB6376:EE_
x-ms-office365-filtering-correlation-id: b645db19-49b1-4402-1886-08dba473e268
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8LTwA4eHXqUivwWw6wVqWZeUf04zNXWnEaO/vx8K3Huv8BpFt+L+xvp/06xuVnutA0DhLXTBroBSZzks6eCoJ4QIxIw9xkU3mk7bAHLEbH9l9o0XuWhZ0DmaHDuR49QWuV+DwVw/5a0KOXwM+KTY2bbYNOhFe6FbfyW7eB9fGz6mVOk1Ltlaz2KoUbJoltDPM0nRQibaOBwM2p2lHTgFUF3m+JGNhY00v/tw+R5F8/gbdk8oMmWJrq6yErjh50IWc/TkG+iRWjWDn7fBVE4lNLfczlbbIjaG+1Gt8Z+yP8SCZ4MKbw/n2W7+BtV/lSHbCp3h33g2z7KBbF+58/DDW+cTVPlOlGefN6TdFmNbaDDaVwCzBlvb9rV27DH8Bu6dA75KVywmUPrhUIlCu+LIgJfoVHwvLKSRe/GtL3Xoc+be7Vp7HVhq3yKDTWbPxZRpJK5nt+YSNwQYVAPRHyQwKcnz4qmUnxMfnGiTVMFrwZhrY64MJRxCcmIAhjeYHnTI6ULXavrUh6NtOQSeuC7ozhTbQ5UH6Lv6f4anV+8bNDa0Urln2V862F0OzZRnx60cB7Eo1d4a6dnSMuj8JDcZRFLMlkJy6ZFAmSf0lD9TxmKdoIuI5avG06Th/dxAT9q5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(346002)(136003)(396003)(186009)(1800799009)(451199024)(52536014)(5660300002)(4326008)(8676002)(8936002)(4744005)(33656002)(55016003)(26005)(71200400001)(38100700002)(38070700005)(82960400001)(122000001)(66946007)(76116006)(66556008)(66476007)(54906003)(64756008)(66446008)(316002)(110136005)(478600001)(41300700001)(7696005)(9686003)(2906002)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T+qExL7Pb0qchCjcHhZXrY3pKNkqPU7V+S+ilI+cuft8iVsw/4av4EBfTk1F?=
 =?us-ascii?Q?82SsYIR/SMFkwnZXNqarGWCsciTybAQnAdNIeL7EG9EXUg4t1qp5/nRBVwOR?=
 =?us-ascii?Q?LRebvQtKSq5CVEMUgooLBAqO1HGWhOsALt8ztm0hiFYJZ8k7OuH7Z1BUPdlZ?=
 =?us-ascii?Q?utab4ovWRDFH0l6Q9ZL/OQ734+2cl2yn7Gi98vEjeTcSQjJqCLd51DqNehgl?=
 =?us-ascii?Q?21/tsCjCpCYlpu+LKUJb/44Q+NTyJS3Wjc/DVCHTQZSKFfHdpc+Hx7XTju3g?=
 =?us-ascii?Q?D4FEqhRw1Pz3XrnOp/6pLHg7w6TTY8++1gySQHSZB7cw6ARd/JY4xLuaiG3N?=
 =?us-ascii?Q?V5lsvBW5gsUyg4TlNxb8wHILmnTDvRvEtB4vGz0PC30QXP/lLJg6o/VUwUcy?=
 =?us-ascii?Q?JyOqghiT5T8Du2B61JbTaAnmeMOhhvYelJB74urSGr4killHDW4cKYarXqgq?=
 =?us-ascii?Q?kOa9t44wx3RSv46Mmhj6a2aJEeHBWR8UOnin67mxBFTg3T2K2VnRRAnKtlba?=
 =?us-ascii?Q?MjmOtZcdqod6lzF5yJ8HnL8r4lyUSaYM2pqYsqYMpm07ADp8J2+2g3iIINs8?=
 =?us-ascii?Q?KM/EDb+nLel0uqEY0AaySYVM2R+DxNcqQLRAJ/OH96eekKDgAVFnacW+eVBO?=
 =?us-ascii?Q?ngOoZw+cWM/Baq760ok89vmeWo9IgPVxvyFxy5fz11q19VcfSZh8opQBGubI?=
 =?us-ascii?Q?lB44k8s5oAXDJDdTZDWJaAr5DhuR4Jlx954mKCt01kvQ6A7xkd2Hx4QwJCH7?=
 =?us-ascii?Q?sHqphe9BpkldRF7r7vIM6c4gtXOQD/WKk11etUAI0cuXxyh6o7WR1vRECyAG?=
 =?us-ascii?Q?Bb/XoKkXjoDUjCn0broCh3aJwPP/5HJ+QRTMWiPvXwD/9BtuQ/T2EcJ5euPi?=
 =?us-ascii?Q?iKpN7eLLffgab3MCJW1SvORgRqeXfnxJUVPcf8LiuEOz3kPiIDRYbSIUtMcb?=
 =?us-ascii?Q?inYU3zrS/8bo6hRDwEbonB0nS1lezC/8UxfV30jtrDG4yctWyypGECpz1sH9?=
 =?us-ascii?Q?UIFbV1j4n/CzEbutARVh7gPWUUTBMle0dLPSDt91MI4aA+fPKwWe1Ev3F64W?=
 =?us-ascii?Q?D9HZsN8rOyCZ0VH4WLsXi6Rsat39Ko8+q7wbtwyz08LYqjpl59ukTjB/2nPA?=
 =?us-ascii?Q?B8eQAfByjnu2DbFUsEsJDqRYUJ62TFBBVHkJ4f9HxRraObIIaDs2u/f3LiOS?=
 =?us-ascii?Q?I+GSB/i7TXQl2t8slX41BD4LyWTZwaXRkU6EuMgePapozWNR2kd06oh4jmoZ?=
 =?us-ascii?Q?7RDs06+Vzb1y4kqJ7YyiabnOIxa0aVhMoNZmoXe1J/fo3qEex47C4VfHkNkm?=
 =?us-ascii?Q?gKsZgeE8P1fqr77otEeHGWV11cNzIGtyOymgFarsbK8AIB/q0TcKLTXVG/BI?=
 =?us-ascii?Q?LYSQVt124LMU0lH9HlPuGV/RDnU3FndEleSuna5Oude41IgL82SZZivQiRND?=
 =?us-ascii?Q?UNIEJVfxtVH4TLZYhgrYvL7LE3jWBO0t7pHIeAKN+Zr0gHf5pJ+3CgeKJ7Bk?=
 =?us-ascii?Q?m0f5CS8tc8Ho1snOR54BSxzXRgIOKQy8yV5v0MS6AgwxPYSKOo5TOkrgUnL6?=
 =?us-ascii?Q?p0GFho4TzzC4CtAnVhG6pAtG30DnL+9VX5sPR8Ow?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5502.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b645db19-49b1-4402-1886-08dba473e268
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2023 07:29:42.9551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2MlbTXA8mct2zxF41B6Sfts5yaRVPFfivVms8nSrO+uwVrjsgaLKEtFTgSm8pEG8HDb2CNiygLGbPJMMXFL8og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6376
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, August 4, 2023 4:09 PM, Tian, Kevin <kevin.tian@intel.com> Wrote=
:
> > Add vfio pci driver for Intel QAT VF devices.
> >
> > This driver uses vfio_pci_core to register to the VFIO subsystem. It
> > acts as a vfio agent and interacts with the QAT PF driver to implement
> > VF live migration.
> >
>=20
> this lacks of P2P support and .err_handler.

Thanks for the comment, will implement these in later version.

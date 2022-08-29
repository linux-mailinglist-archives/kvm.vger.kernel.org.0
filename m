Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC505A4059
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 02:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiH2Aaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 20:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH2Aah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 20:30:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4946634F
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 17:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661733036; x=1693269036;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=IpfyuRvDOhjSa5ptdsYASoVgvp0pS2rHIpiNKm0S2Uo=;
  b=LzkeBvoCijaEtfH3d6M3mDEIOxB4H+UFMqKn7mj44JIQtmyzcVBAlY5B
   ICi1pWCIuyjojWutEN/jG4m90HzQF4uq0EE0vYWgUrgZ2T/iuHJGlhN0f
   yr05as/vitHbo3mytDWNkEd+3B6xMTea08CwyxG6FAHLrwLjma2n5OcPk
   +c2VNkDtzYSmQ2YAdsgeSW8WVIy8mWLnrBPKC7B8BDhyjvUsP0QnlB+40
   cHrheuav4JGRwBhiueq3DEb7KA0rF2WCwPtYpb/ybZogDC9mpU+rBoM1C
   ZnJ+rsrFZjukJGjf2TgXHGaqVBi7LE6gUa/NeuCEHtbhx7Rjl6hgfOq1s
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="381084433"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="381084433"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 17:30:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="714668142"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2022 17:30:36 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:30:36 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:30:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 17:30:35 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 17:30:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ei7nOsECFkv2wp93mDXokJ+/vOD5astXa+BCyFvMJu8PEuaR02vW/ZvV7Y6Me7mF/GdV2o28rarZh3XcJrO7y+e1oRXMcCU2FoNG0luJCRl1lY3PhoSbjzNNI0OYKcqklClPbmHSieOuDXZAaH51AW95ykASA5Jdgy4A/murnb565/nA7RtgbGWiHDFh6vhxxEJ8bMMqn/vBzJw87/FhMxxV7pFo7ArgmTAnApfcXCauk+wk+17rMUrOrkjauusaOzRHt0dvzpeOJrzqqCpTzMM3aQ1bRk1aA6/ShgSfTYadP30147JpwnDs1AOLtbz7tUO//iZuWj/pnPT5dmFOUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IpfyuRvDOhjSa5ptdsYASoVgvp0pS2rHIpiNKm0S2Uo=;
 b=axnXmyPB+5TXNqr2ZL36/d+IhSYo0yApsoN/cbpcniFVYdb+aHSqeVAC4NOsBZyK7pLVrpqiWpdfFB7AswIWgK9qmIjSKsUCTh3RO5iQtEGjR2YCInZTZ1yfqTPwqKiLmXMSHH9eEor3zNvOMEEy2FZFjHQO+HF0iqwR455HgATls4rKwjPsb28POKqDmeICBYLUbSccHa7OqF0N/3ESK0VOtlQXpaXnvA9kEUSLyRGJkNxVNZf0FuRLouBussPpP65IoVSEMBUSr3tgCKM3+o0um1v2/Mzb8mtTKYy/LwjWZ1ATtX9WtYQR+GyskI+3FUaUqa+Rvz+/BIdxbbgLRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5792.namprd11.prod.outlook.com (2603:10b6:a03:425::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Mon, 29 Aug
 2022 00:30:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 00:30:33 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: RE: [PATCH 1/8] vfio-pci: Fix vfio_pci_ioeventfd() to return int
Thread-Topic: [PATCH 1/8] vfio-pci: Fix vfio_pci_ioeventfd() to return int
Thread-Index: AQHYslOdUiIDrBEu30ChCRNoXWkeWa3FGD/Q
Date:   Mon, 29 Aug 2022 00:30:33 +0000
Message-ID: <BN9PR11MB527620401B91E2EFB364BFC48C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <1-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <1-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6b47c63-cfbc-45a8-972c-08da8955af64
x-ms-traffictypediagnostic: SJ0PR11MB5792:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OjwJb0p3rYcwyCam7HtG2N0xTydIEEwxOZGFIjIVSCQ3SMd/VheJztntuEBqnP6hhyZ2JPeX8O/JFlKBf+BprdnkS+fIEu9x+RWlKotZLguwgFYxvXmn+jmBHOfDo1gZocfs0a01CbzB5U7V1b/Atw1rYLbfMPgebEdm4LtQvQ9zHXTl6lrSf878YqX+rEYszNUtwQKH7hIye7Sprbfj8rinEjp2e5JPbZC2WR4y4WmKe/ooC8FNgfv8xA0ddbNiGOyazzBB8NUMdlyPddYJ8auq9Ofad0GTMzPqZiF4glaa7hOSRU3JVE3sMwV6lKiioEyh03JKPHiRFikfBh17aLld1y/o7sD77nZZNbXflTQKDZm6wfp8jNxhOXDe5K2lAmLxZkN4kAv1BPpDucsODQ6dXQXhSaVjXQfjX6wzRPcT25pQRlleMi0vvUK7bF5yqxLe/ReMaAlSF2W1TRJuFYjuVeWvuA9F/S3+x0umngZVZYx75um63pVF3GzgfEgT9THAb5i9EgUrGHBgQZwipuw2sd8JimQG1UxOXjzmkPXmWY/hEaUR2VWTUMYGyOc2ai/cy+QXU/7086YD3JCwPblmGtV1iiCEtg4D9+3po/HXCIcy1MZacDHm0WEAO7MNZNg24zhEMoxVEaR0MiELwH0qLtIRd3EoyZ/+/RK1BbNORzA/Y9vUYQHzE9VF38TslDQvqJIgXqm/dDigko5ehEkecuE88gj6v7M2Fa4pmFyklvUGXGHrnxTQRuztkXKnyBrkyuy5czHgbOSzPWAAmg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(366004)(376002)(346002)(8676002)(110136005)(66946007)(66556008)(66476007)(66446008)(64756008)(71200400001)(316002)(76116006)(38070700005)(8936002)(86362001)(5660300002)(478600001)(52536014)(41300700001)(82960400001)(7696005)(122000001)(6506007)(9686003)(2906002)(38100700002)(26005)(558084003)(55016003)(186003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qG9HCmKrLHwVWQ/Km1hxjw2X5wkgEMSUqNpxZUj/oQvIWkYYej/LBRuF6Iwv?=
 =?us-ascii?Q?Fnf0QKsjFUT0ST6MmHoXcFsb5TdsjvT5ex9vDoSt7A6cc+ADotOUPtdDJ4tz?=
 =?us-ascii?Q?0WCzb9QQa7G74Rkt6HTi/HwOJQL3jEMIOEsSOTtBX9N0TEyq/59S88V2dAMy?=
 =?us-ascii?Q?Sww3tdAtN7cSjBwEZVU0J/UXovN+ieryivv9B2ECrofQBbLMNBXQ6fRZ/qXp?=
 =?us-ascii?Q?vXT+7aeJtJ2Au1QVR7tVGJzrzlbKJ9if1K5grPK5UtG9d4ZYGGTIJUf/ARON?=
 =?us-ascii?Q?TC7VfLoTRfvxkIKdsFPO97bM4eDhhoAV+pEpOD3DQzEWz313xMSOEvSJEAfm?=
 =?us-ascii?Q?6Uxv9JKAU1vE9+y7hmcNzNMTAX1ONIigJoJA6X0Xrc6U6cUNzjUnmjgT8ITZ?=
 =?us-ascii?Q?t7BRS9adwZc/qcUioKEpWmHiCtKGwIVgnrXkdFmiM8H+Uhh9oxiDYK3bhNEq?=
 =?us-ascii?Q?JecpXutv1YXyIG4cKW23hqmgsEnKqDrCWh0KBh4LAkdrnSv6daYjo7yFy31B?=
 =?us-ascii?Q?wbBcqAfTFgcGyF2x3drMllPh5f6zAk9M7j1JYOns3tl+QlBLpPNbO3t11oET?=
 =?us-ascii?Q?L654rejPLHWtwCvOU6iBGQW9pA6fSU5xHHqf5sOh9IBKQlIIH2dhiEkrQ/jD?=
 =?us-ascii?Q?71ZQjqC4rSvp7WxBR5Vxebnh3+I4ZAr6kgKEOBy4ksIUfuMB8gnd4vgY0nlS?=
 =?us-ascii?Q?wjlI6DO1f2kEMhHdFdmW4m5xqYkGa064fC2Iqgtubw4bfW/EEKX6ZntyxMdp?=
 =?us-ascii?Q?VXkjYAJXd8st2WAW9RoWqiHUi3v6PkYCKVpX8fXYek7uTQM88MgSBzZp5+a2?=
 =?us-ascii?Q?6hv9dQmae/z+RblcwzIpBXo8KHv7N4nqtqwJkgoGKpWTvrxHuW7ylupUXUaW?=
 =?us-ascii?Q?t8BX1dGvI6gATlhk0A+3wf7ZsPj7S7Ar7j6Jr/hDY2J/+npVSIMRBDzv5eSw?=
 =?us-ascii?Q?VyAXk0bbrPLbwH3GcdZ4ZNgIDyUBuuJCeT9REsg6Cq8ep8pZG8aX3Ynn/8UR?=
 =?us-ascii?Q?/QpuiFyvwiuV5jppGTZIgIrlUZVKzeMBzy+LeJYYEuhXQD8s4Fu/6Qf3nLGf?=
 =?us-ascii?Q?zkdDDCNeaTjAuqynRRc9UyZllZQ3jEti2hPnNzJo0IVNh+lBohIwqHejvzyN?=
 =?us-ascii?Q?YpAHRQ6ITL/tLJYV5q7LgRHJ9s4HwVqRC7H4dQeCrYs5nwtQS72Vd5a8Em7j?=
 =?us-ascii?Q?yEGCddHVBGx4qv1bsEsVZgcbqdKWZjlVii0hmh+PguiS2w+83gdKmemvO7h6?=
 =?us-ascii?Q?u+ClNtuFrnolQ3aiOgsVVKFb+xE8rOTkEQcMMZen+BiuqZJlVCnVTZ5OxUXL?=
 =?us-ascii?Q?QFcNh2X1WPwugCHdKSJyGvL1rh5gFOI8a6xwCn0TvmT84X36JJg3iRDl4gaX?=
 =?us-ascii?Q?KGxiJ2QMNABy2aUn0+Ouzyg+vTS0xHCCaI0wH8OOlQB8fkw+xMPG266Cwsg+?=
 =?us-ascii?Q?tPlGO8be4V7OoQmhxqZLP79d4+NxkvcueeQNXOgPNH2O45YmFOXdB+jFQ8Dd?=
 =?us-ascii?Q?kUkvTZhkGzfuhQWeKc9trQ7ysgjJ54+/w9sN9b/Wwi8MkiGGK0J1kO+Edc7i?=
 =?us-ascii?Q?+J+1yVcFG7Zy/wqGG3SwFTNru+Kud0HvjooAY43o?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b47c63-cfbc-45a8-972c-08da8955af64
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 00:30:33.3552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FioEhNshBcdi2I7jT0nTRYUkgmUbKU/Eludi5uvx/2HPHQcpqsEgedzXAUekQxfYbn35mlQJ/kEIexA2gEujwA==
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
> This only returns 0 or -ERRNO, it should return int like all the other
> ioctl dispatch functions.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB187758D2B
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 07:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjGSFdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 01:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjGSFdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 01:33:42 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE11D2;
        Tue, 18 Jul 2023 22:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689744821; x=1721280821;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JPjaC5fQYl8jbuaFEIFZWV1bRttFP83WFTZklHFsuuI=;
  b=cBw238COAaYIX/xUKEReGBbNSAscL+fE2vXeIETY0IgagEJWkoolH5gm
   dsXNckPJZN3wjCezG8cY1Y3/gF/cJIYRobJsPbctUKb3RZ7cIk5cO7CKQ
   TWcnWWadpoMel4SdzEz6khiu6/FZbVeRu+wDFCyLcISDZayjc4sQD8CZq
   fMOtFJG/rNIT5O8Atsm4OPPlDFUT3/vh0WghvUgzbmKZjNFfz10cP6ylx
   Z6QGy9vCBkJ9UMx8Nx3H0IIwWxtrEp3wICZcpr5Vwc4Sq9CJzjzpwm+6M
   VIZ8Q5033FmFGhZN6Jam+4SBMVYAYUkbUgcg4qo3Ri8lFYxNglNbTMWvg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="356324795"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="356324795"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 22:33:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="897796466"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="897796466"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 18 Jul 2023 22:33:40 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 18 Jul 2023 22:33:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 18 Jul 2023 22:33:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 18 Jul 2023 22:33:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHjFL1BKNp9N+NuAwaorXrSzgk+od1xlH26Gj+cdiMAPq+LXVJT4PfdOdSHv3EKGv0JN3c6P9kB1W9lQGf3J8xqVFytGqiJ7VF78SjmmQ75BNPsJYfj//Ta1SGTlHMdIomjYnYzL/Lpfzb5c88pts1qLHkuqvhy9Hgl956kgi2jUjy1bhJlgC6ei6lS2y2xwG5KFk6PAdDrzHCk5fOznXDbQFmHSYo3D2KLX4W01y+TWy8KviLd6aP7BswwezbM/P/+ladXmKB8QgqFHqvJ74e4aglM5/gqPtwZ7Et0Es7oN9VuQKezdk/8mXZ7Gx+0I95SQTZNQQy6gbQPWOD3rZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPjaC5fQYl8jbuaFEIFZWV1bRttFP83WFTZklHFsuuI=;
 b=TGFCZ+CWkI55BbX8+gDNsl90lML1gJlXb4RokUawzXgFqXoI7WorjDFq2GulwGkAwzMTB8hEZx733SdTvgBVWS6PtUS7VBqg+FbFGgT6I6qaN+PwdW0dJykHXVCFs+0NF0rngfKe1xz+/lzAM3xxlHlaTt+1JEq1tzwb2yOw613oWIW40BVsrbDd7IEJQxtYfMzdDtBc/TXQvU8ONDj+sveASCk/ck4tR356sej8rS/U3lkEkE6Ao7TpWmDhdXuuArMYpBg39l9NKQrw/wPiI+WrNuZGnFKMkvENbC87irKkg4wusVcFUkIIYPgpVUSTOpeA6A4jncgnj6wg11I/xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB7007.namprd11.prod.outlook.com (2603:10b6:303:22c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Wed, 19 Jul
 2023 05:33:15 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159%4]) with mapi id 15.20.6609.024; Wed, 19 Jul 2023
 05:33:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Bradescu, Roxana" <roxabee@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] kvm/vfio: ensure kvg instance stays around in
 kvm_vfio_group_add()
Thread-Topic: [PATCH v3 1/2] kvm/vfio: ensure kvg instance stays around in
 kvm_vfio_group_add()
Thread-Index: AQHZtqT5QK8Zp21i/kizgSonHXKdu6/Al6Fg
Date:   Wed, 19 Jul 2023 05:33:15 +0000
Message-ID: <BN9PR11MB5276F50E3421C846D19645638C39A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
In-Reply-To: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB7007:EE_
x-ms-office365-filtering-correlation-id: a12f7049-e5e5-43ac-c445-08db8819a686
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cZk6aLLdv1AefPhkQxFbOVooI3uq/qFQq1ZhLMIFwHqgf4cfiuX9YA7xrb/wOSNtgQpoYAlRHWUQJLxyZ45wPveB4UiX8H174A5kPaJoHpNdsxzyJWPy37tNQzTI9NeEkBHNsVDBbVNaDVPNFPMvXRSydmiPIhAoEnxrNGduF1gcg8WGff3p2bcZ1eDQcqQ2CWmDFsiyLaw8p1UFTFNBDRIyjWKK51uFDE28ktoGZpw8XH575vPMxFRw0ldjEA7Jc6Be0ae4BAHC6S8JJp3lTZAIWB+O1sIiULjMrSpxCYwtUXNNweI9VUMQmrlFzIJ7hT6U0PCzJxff9Y7rZJgycE1ps3Og6EuRMo32c/s4sCGu+FYk+PoZoLsrFCOUWCw0bOWMMr1Gu3vJiWOO/eJu3eu1hOeQnTUiTxDrtKFUCOd+H3w9PrxcW70TWR5vnFZ8rd0pDTs6EHt0xDlyNqBAfuT7BPQZ9ziQhmcIeHLFgzUygq0LTmDuM3yzbC6m3nAm/ItDeaa/83MF4G5rLktBMdSWumNYhesm/IOIakWAwXcD7OWnQiaLVEcOlbozk9idY4stQ5813aN8fr5qPTmA7rTNfRotCoyOE4cvYOWTzvriQCFEFavvw4I0Rr39H0kg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199021)(186003)(6506007)(9686003)(83380400001)(316002)(41300700001)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(4326008)(52536014)(2906002)(5660300002)(8676002)(8936002)(7696005)(478600001)(54906003)(110136005)(55016003)(71200400001)(82960400001)(38100700002)(122000001)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ttJFbO6MQo5+dzC3FgtxTaLOoNkwVapfRaf0AEZ1UfC6zNGTTeJw8+7iXyHW?=
 =?us-ascii?Q?aVtidNYrVx8hFmHOGVoQvhY/9OSvUfFGFC2peNnfCg28fKG8Q24Evji9PqJ3?=
 =?us-ascii?Q?KoI9fN7wB9KLbYmqYuPOucND4TCJa9jTG4+AV/0N8l5difXRBosb5KSBdEKn?=
 =?us-ascii?Q?ICwUWzWK7EzbT/IMKE6Sne30Rywup3HbIhISFr2nJq/gqyvRD55ZlrmC5x3b?=
 =?us-ascii?Q?sfiK9tl+z3KeM11eRY2cCxIaSPiwLXTxAYzA4jwddLQVS8LHG91gL11HymH2?=
 =?us-ascii?Q?iTW89hRdG928lf6UL5jtl2vd/io8rq5Fk5hhhP1ee7iH8E2FpTpdYAwiy3Cu?=
 =?us-ascii?Q?5Ui+pOPJ9h/ps+6W3CZgKsoRxkXNb5JFT+nuqjPJvForDDbQ87bNfozX+tHN?=
 =?us-ascii?Q?k6mQWKX3bZUp9R7eWZUCT9VTMQQ4dwEd44zo5TyYMPKmJyKY/eIgD4ZkKjOK?=
 =?us-ascii?Q?4reJ4h2Iswb61xj8GDh88+s4OIDtzYux7C4OAIB4VIZbSiYS0tRToe79teFI?=
 =?us-ascii?Q?lWxlJtvVn1w1tEwGRc2Ej+7gw+Hzw43yWOrHyh5dXGx2WCSdpQl3pljSeurE?=
 =?us-ascii?Q?4vYW9qah4T56yWTik0IBBNVQ9ujR6fGYYmJEwVRpiWKK0BRYvKP84TdSmK3J?=
 =?us-ascii?Q?vZB9nyZud0JCk2omA/pp0bvqhnJMxTq2ouwxoed3mtaUK6sqEhVXa5SMILoZ?=
 =?us-ascii?Q?b3Xq8tbauZ98uF2XcGSMOS41QYuuyHcJba/F05kh0+YtrGKNI5M3xI2La2Te?=
 =?us-ascii?Q?OSwBiUr+ERe8Y9vZ2gKnsVYDjdLM0ELGCxrINMwYZIfEhufUOlACJT0p0tjY?=
 =?us-ascii?Q?0Gj0P8mSr531L4k/HvsPodFFKrdPpG+2bg7IaJ/x9VVoOhWZxpT/1WNWfHmF?=
 =?us-ascii?Q?N5oHCJT8CGYIa3c2KeYJeF3X4wj123Duzock856g/Oa2AE60O5u75Z4kRf1Z?=
 =?us-ascii?Q?wcQ8u3ziarVL+uCJKuUM80OMLlbFV7yJMztncEljga+Ly+qJ4e6icNl36/Lk?=
 =?us-ascii?Q?i6I63xXBCZEPfgHe/N43tOX1qU1VWZOPCwD+Jp0v7IB+U0bm8T2mQqaRh/xL?=
 =?us-ascii?Q?38ZX00qpeu+QN9TzRaBi9dwzCFBD3mYPyxNJxZNcLXi6EX6WMmr4ybv+t9qK?=
 =?us-ascii?Q?+5WMHSTcUMsripPU6cx+nxN9dmE13H+nKJzg50LURziNHTu5VFBmkk1Q7iZO?=
 =?us-ascii?Q?WyHvfsI0xt6z4LjxlVKweuMkz7O0Kydm3uI71nTigbpq4Oi+KrdRKfCINK39?=
 =?us-ascii?Q?P9obqAqg1r+GtgDxjvRgJCpGgVib1s5GkQqdZItgdKaTQsGqIPjrOhvNiKwE?=
 =?us-ascii?Q?A6L/C171l8Vjjj3PpH7nqZqh1DejqTNWKBRPRnOiAZsClavRnBg0+3t5cYMT?=
 =?us-ascii?Q?DWUwQH7bEnfHzUjIHWEjuT7bLH9LVub030KriLMexPS0ShwyRroZorpYx5Om?=
 =?us-ascii?Q?kXJymLc1G1VliHjh/9TtQOY+w5ffpPJxf6nG2EErU7WQSdDUYPfUm2TLtqh3?=
 =?us-ascii?Q?EVKOYoko+bsoHtg4BqKbLm/n2U8OdYXMaUOrSj7I14rVRq5tEa9wep5lNQ?=
 =?us-ascii?Q?=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a12f7049-e5e5-43ac-c445-08db8819a686
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2023 05:33:15.2390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rmgu7vCE8iGO7qQhQuu4URAfBN+rzjfj9AAAkiax3w1j87fQjE8UCZNVLvtRJCefQfHERb1PbI9Zxjz+zLfP+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7007
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Sent: Saturday, July 15, 2023 6:46 AM
>=20
> kvm_vfio_group_add() creates kvg instance, links it to kv->group_list,
> and calls kvm_vfio_file_set_kvm() with kvg->file as an argument after
> dropping kv->lock. If we race group addition and deletion calls, kvg
> instance may get freed by the time we get around to calling
> kvm_vfio_file_set_kvm().
>=20
> Previous iterations of the code did not reference kvg->file outside of
> the critical section, but used a temporary variable. Still, they had
> similar problem of the file reference being owned by kvg structure and
> potential for kvm_vfio_group_del() dropping it before
> kvm_vfio_group_add() had a chance to complete.
>=20
> Fix this by moving call to kvm_vfio_file_set_kvm() under the protection
> of kv->lock. We already call it while holding the same lock when vfio
> group is being deleted, so it should be safe here as well.
>=20
> Fixes: 2fc1bec15883 ("kvm: set/clear kvm to/from vfio_group when group
> add/delete")
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

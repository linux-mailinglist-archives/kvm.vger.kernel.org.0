Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A39788190
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 10:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240562AbjHYIGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 04:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243505AbjHYIGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 04:06:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9CE1FF2;
        Fri, 25 Aug 2023 01:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692950794; x=1724486794;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UbnosbA2RoBXwfwok+XeS8jCEZ//rGaHw8SI8S9cqTw=;
  b=LT8Vh3yXQXczcsyZF53w9Gz3K7cXmQkQTGlYTy/OmGwYM1v0LDbIFGK3
   6q6mgssBAaYw3R3VKia4bHJWw72z2V/wVAhhW1oJ4C/yye5IaZ91YxCau
   P06T0mHBEI5ZIeQCJJ66jrZAZ9t6mhaL+5g2dNywYk/ERAo1wDKbhrbRs
   5Cp+mr3t3NibB2kU1HDrnFpm2a9AhfPX9Cm2CZqzP37Iccqj232+vvJT5
   4jW8kLsCXZ4e8d9Y3jTVP1tednVFrNyj9tFMTte5ABt7aCDufrO9QETgH
   R0SDDgvQF8bGvd23fbCqF2mg19TCo4e8Ypp4dEgeEqVdckAFsllDTj/NX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="378445557"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="378445557"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 01:05:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="860998078"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="860998078"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 25 Aug 2023 01:05:51 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 01:05:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 25 Aug 2023 01:05:50 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 25 Aug 2023 01:05:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/UaXt4PaYqIPW0aOaZkMVtB9yBJZK4CUaPMomR26hO4H9c4PHA1TmcjEtHhMz4LW06Vmu7wBe9def3/Ug4e/NQINLn47rC8jIszzzDlK0rcm+kenyBE1HoTPkNZuQpiAtasgKFMvNBbbFzld1ZFwSyU6BGPoE54vtGCjDNTPa1Snv8PmL1l5hFijWHg3WCBlLsINrXugJoyfjYpI6qHRUhKqoUTShdJ4XS0bhAd3AfAw6LUox6acnGde4PDFexTuITrIN16s8AOKx6kTrr/idA8m9N3tHBjs3EG1elwyUUHMYBv8c0yNHRgN0Cox1TUdar3oJjsI/PyXnm89qzhrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xlm5e37Yll2CszbAuLc8iJS1moUwEF4CGOltMdwRcVg=;
 b=Qubuxm0yExEdmr/4Qhl2BAMxr7SIg3y74hahXzkhnw5umkoCUMWv51GRcUQyFs4ilFyxdW+lKFmdG+joM3fiAxPMFPsqn60evDYCv5dyvuCuS414vqt+32OsP3j/D/fOlGCgV0KAbxyVQS3Xp3oatJIuylQ9o98gWJDMAXN8qgRi4D4E7rHYYbmVqHydqnDKmvR+86Flja+Fwuf4BZUcRwk/sb9WwYS4y24C9LOUBRF20cjfs0MAyWhQUlxpHNG7kOTcffLjnMgwAu1232q4UIWCzmBpPKn5+NOaCV5icIuwQRFgr9f6qOID/9aP4PbUAEoA0Yfb+ElbZxRhok9J5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6440.namprd11.prod.outlook.com (2603:10b6:930:33::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.29; Fri, 25 Aug
 2023 08:05:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 08:05:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jason Gunthorpe" <jgg@nvidia.com>
Subject: RE: [PATCH v4 08/10] iommu: Prepare for separating SVA and IOPF
Thread-Topic: [PATCH v4 08/10] iommu: Prepare for separating SVA and IOPF
Thread-Index: AQHZ1vybU9/ewo8DSkGN7QTeg2WPua/6p3Jw
Date:   Fri, 25 Aug 2023 08:05:48 +0000
Message-ID: <BN9PR11MB5276BF8DD07ED055B271BFCC8CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-9-baolu.lu@linux.intel.com>
In-Reply-To: <20230825023026.132919-9-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY5PR11MB6440:EE_
x-ms-office365-filtering-correlation-id: c20d410f-4e91-4e49-3e08-08dba54217b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6S+VCMeia0Un09MJrbGBTLukUATGcO079U9WjA3aUbCkiwAfivde5eVDyo2HbE3QXQAMXbMmqUjOwyh7BGuhFuU5P9eftkIv0xSuQ1QQP2WFkSbxZ7gbYH7+8LgI/4awu+FtvVKewqBxI1SC/G8IteqWaBIRNEivoGezDYFepvuAhs7tgDjjglUsgZKi8qWVDnDeV1rHkHz9pvNJE8WQthr8Cvvp101DukFPdSAaq9epLYFCRy08mAyP+2XBXAesw5n9CtQJta+Q57J7LvRWPoJT61M8paHudxelzP5KfjE8pOJO+MqTe9BlAT79vitacyeINLoPrb1SCh0wevUZwAbOUpXP3X7YAqa+e1iYXwi0dkJRkBZK34lmCyoI7OV1vxWXaddCqU1YCdNOHAB22NLN1Y+jYVeb0ABH7HpcrVY96/clmgjYrzE5IVUHXYg6ogP1L5XlWZ87sJrELchUSMUEPK3uCmlEb+N6eqNl91NTwbcjhWAIMh3rTczrufnE8Wn2zWNR92qlkD0Jq5+uwQQuZr1aIKp6Y21s72WbhmhEDt56fiPDAo8U26qz0gmeLvwR06giH4Yuu/vpo8VB2vE1qNfgtbZerX3pk0tthGI/0vvvMMPNdd9UXL1V/Fbu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199024)(1800799009)(186009)(82960400001)(122000001)(38070700005)(38100700002)(8676002)(4326008)(8936002)(54906003)(64756008)(41300700001)(6506007)(33656002)(316002)(66446008)(7696005)(66476007)(66556008)(110136005)(66946007)(76116006)(86362001)(71200400001)(9686003)(55016003)(26005)(478600001)(7416002)(83380400001)(2906002)(4744005)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iR+4CvVaAZaXhWnKc/UeeZKKU8L7w55xrnqyOO4/LfojohyXHkq3xsDqgZSn?=
 =?us-ascii?Q?KgaPJEdy2nFB6YHCBEwlmLlkAUJ6g9GgrKoaU+xalBc9+jPGMGKHjhZAkVNI?=
 =?us-ascii?Q?VprwSC9MjCqmMwkWLPF94dLx+CRJJ3UaP+TNlcilE9mJj8Ivewu32P3dgQyP?=
 =?us-ascii?Q?DuRdACS2G8hPwZltn0/wj4gBJkaOFT1e6BwAyNuPZFGoa76a0JcRcpZxRFqB?=
 =?us-ascii?Q?dndUIdQRxZwOVrbg6tIzye19ap8K7jqjmG1u1GxjGANuoXqrFJq21Ra7s4//?=
 =?us-ascii?Q?cXXzfIIZqBzv6UqeJlxM+vk0lxA/dqsz6H/PG8Bn8yJ1ejER3BmqdogyttTt?=
 =?us-ascii?Q?AtA4yTRtDUWGEK84a48Nw0zlp8V1Fnpc1HNNUp/cXSepa0HfFjx04hiVM8iu?=
 =?us-ascii?Q?Lwa6T8MDZNqwv1I0WImHBsVxi7ybObQGYLIrDjA1yQnYJojz33LJE75hbwLd?=
 =?us-ascii?Q?JihC9WnjC77GlVq+5jdiRR7yyQ1hOBWSdhwgXBCxVY9sf4AMGwe7QXxrnyjZ?=
 =?us-ascii?Q?d/V/Kc+1VK8nGwlicXss9PzXDoYxkjmIkXNQdxA0Xnur0xXGecjIH4T7VvFp?=
 =?us-ascii?Q?NatEbzZyYWVNJskdO/Sei7+k9OIJZUybxSYOeJApowUmKD/sOWcbC8zwjJKg?=
 =?us-ascii?Q?/QEyZHYr0Ah1yK8zKDcAq+oHI7fLdaK25/u4Ljkm9taz8Xs2QkIKX+rsp41U?=
 =?us-ascii?Q?6vLCmNgwVf9vlCkdrscsy09YstTP1bcU8C8pH9h7bKnyO3pCeX6V1T/lAUXc?=
 =?us-ascii?Q?APj6n0dkspiDTC00nZrw0oWZtfv/7uSXa8FJ45BOckBWLi/tU4fBcKXyHC1h?=
 =?us-ascii?Q?/K2Hj+RrmgDYssUgOKxFxAkbx1Ds+AZ6TSja4kYWGTDhoGF97J64p7N0RkoW?=
 =?us-ascii?Q?DsiaXnm+TBebl69TEJOQ0sGsAt/fkZOnLYcl4RRyeSYqyoAf7xEkuim83YKN?=
 =?us-ascii?Q?CeX5iXsybsC56J4a/AbobY7g6irzugVwp7UgNIj3F3t87INvNYKx3GtR16C0?=
 =?us-ascii?Q?sFjJMF2TzQSpZHW1BmhcsZ8Ni35keDcGpcf2WyJo/ZzWG8bg/Wo+Fvdidnqh?=
 =?us-ascii?Q?3sYEp4lQ5SQj6JjIVDegsuEeapU2q22TCk1Xsztl6L1GMUbuyjRl72J+QMaj?=
 =?us-ascii?Q?KDTipaoDaH6hbHUWzi6BGLhbWwVTJhhdzXsnAs1OWhX7vk/MRnCv9aJ2ayMF?=
 =?us-ascii?Q?vnTTuaaPGichXzvLXTRpnwikt+2aSGxBpz9yNEjB8zxxx7eIY8xMzgSZxHB7?=
 =?us-ascii?Q?Gq8kUtwfJayyeQ/teZEEd83kZ3w41q/RPwRHBQd2MBH/WkDT+0NdTFQMZDKC?=
 =?us-ascii?Q?aFqHHL8EVZNFSfJKDcy5HTo5m9jfVMV7V6AF1MJV6gye40eEy2fvSRenT4ei?=
 =?us-ascii?Q?Jnc1laxlCejb7TWkbgpmZh5athK0CRzey79aEyVVYkR04gJsmCrnuzig3Vqu?=
 =?us-ascii?Q?xOYTWsUxyOoD1N+CmP2vV192bEamyZxmAPEdMmiOn2ZQJ3sN8/5gZM0tf8af?=
 =?us-ascii?Q?MXDlnyR0qFMLgy1gn9xwvCCyfpro/C2Qt/XMgiVwElGnQ/XS9UyoXZ1XQRMd?=
 =?us-ascii?Q?mnmvvzFBR60RdmcFpnzBTjWeTFZ4CtrAcZ62WpE+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c20d410f-4e91-4e49-3e08-08dba54217b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2023 08:05:48.7148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GLX1y+OjXgYm9NsAmXhnIs51cWaAcB5EEwmNZ1DWEE2pRqmcdatUo7xEKYTvotDMX1BpkTfSG7trsBsknWTPJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6440
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

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Friday, August 25, 2023 10:30 AM
>=20
> -	list_for_each_entry_safe(iopf, next, &group->faults, list) {
> +	list_for_each_entry(iopf, &group->faults, list) {
>  		/*
>  		 * For the moment, errors are sticky: don't handle
> subsequent
>  		 * faults in the group if there is an error.
> @@ -69,14 +62,10 @@ static void iopf_handler(struct work_struct *work)
>  		if (status =3D=3D IOMMU_PAGE_RESP_SUCCESS)
>  			status =3D domain->iopf_handler(&iopf->fault,
>  						      domain->fault_data);
> -
> -		if (!(iopf->fault.prm.flags &
> -		      IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE))
> -			kfree(iopf);
>  	}

then no need to continue if status is not success. Yes this is fixed
in next patch but logically the change more suits here.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

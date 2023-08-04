Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C38176FB7E
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 09:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbjHDH4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 03:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjHDH4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 03:56:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809A013E;
        Fri,  4 Aug 2023 00:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691135770; x=1722671770;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z/UITKAGaR/v9j2RkN2t8N5ApF3c4ogFDckOwFU+oFw=;
  b=mV1ZR5EeRCBuhDVmB4raGDsdgBxF5jnDiGOkUi1jifS1ijP0+bxF0W62
   x8ug20MYgUNljDNvnaF/vf1N0v9X5Bu3rFMAXD8dci0ABw9DY9p/j2BhF
   R3PtUM70Xtht5BmINOch7hLKH/DXMC58jEZFXKKMHQ14YUUn1GkccNr3o
   v3kGh/gWsuyEHy+nyjObLuZb5ABg3a2H69/g6A9Ox9iVSL4SZNaBAp7jG
   6pmU9G/7wjAJFzdzFlKtwQjynRlUwWxpVNNWAKN8B0fKMsu6RXFnRWR1U
   3caccInO9zxRhRKzFeuiC3zxJBmBR/+SsRSppmN9GYMoZih20a1zYqhMO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="372843611"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="372843611"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 00:56:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="679823481"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="679823481"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 04 Aug 2023 00:56:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 00:56:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 4 Aug 2023 00:56:09 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 4 Aug 2023 00:55:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ecf6RvdZsNAvCpBINJq65gTafKIr1LsQIace+vWTO65UtnwYo/hMEiH/ny1NwgUlhdqblqUDv12KYuq13U5IfuqYKbHrYhN2OtAbBxa9CJNQ7R9aiMLZC0XejhTP4+DBdadQoCVZphTCYPf+qMEGThN7bvmaSbHzVip6cSAw8/tKkJdySdLjZBxugombCDM9PBpERJF7CnwW10eM9FdcN0aCwW1Mrctmrd1S635rSW0G0Av740rXDAD5CnzSqcMbok75alE4Xv5w3tSXzBH54Pw+XxQi4SJF8bmemmUl2MmUQBZJozaEBRM7ZSC76zODTSqpANWrytaUF51EEMXPKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YG2jwBjkXyBUkKI3CVlf21T5RGb1ocCcTEpSp1iZwrg=;
 b=KIu5qOAGlzxeIvFxC+sLMCpuopSvHmaJqoJGacEL4OTCibq1BoVIgWDI7e2oraHhetZdCYvUtaOevLvfOHXP1nlU8VHXsDXm/tYuB93mRogFqwkqIFTBB/+/3rCPSRF7v2rtAUnG8GEdcm4vbOWq2MM/is0tshxRkLRrHzlPZ9FnrHgkG3K5r1Nk2MvdVxwXz5zQpbzXvvlX0GRXQMDmjI0YZ85sJFsKR6ER8kyeHyNLVefJ6IM6/PHtyNBOdwkFBcPsHVBOdwiB81O9f92JkeED1Kg/8stxCFpOCn3LkniOi0U9dhF9TgUJJ3HXXvRjMxrPImTAq2bWUAwJQ62ewA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6426.namprd11.prod.outlook.com (2603:10b6:510:1f6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Fri, 4 Aug
 2023 07:55:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Fri, 4 Aug 2023
 07:55:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Zeng, Xin" <xin.zeng@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Zeng, Xin" <xin.zeng@intel.com>,
        "Wan, Siming" <siming.wan@intel.com>
Subject: RE: [RFC 4/5] crypto: qat - implement interface for live migration
Thread-Topic: [RFC 4/5] crypto: qat - implement interface for live migration
Thread-Index: AQHZq1WCG0Kftx6lpEKi6jBcMnEel6/Z+yxw
Date:   Fri, 4 Aug 2023 07:55:49 +0000
Message-ID: <BN9PR11MB52768334F696E7009E8D80008C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
 <20230630131304.64243-5-xin.zeng@intel.com>
In-Reply-To: <20230630131304.64243-5-xin.zeng@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6426:EE_
x-ms-office365-filtering-correlation-id: eb78f2d0-ae65-47de-c467-08db94c037c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kBaiQnkyERPTchTShz8HW8aADXJ+vgVKOEZredi8PPIpeJQ1vNwhj4+HGaalk3i41zcjmfjZ+CHMMJ7CkE8mo5ORR/m4d1zdJGxLpG8qmJi9e4rDFr6f2K6s1+jdd3dZ3lPw4zEoaA2EP5qr7OpyyUvLJbjldFXb06WxRbV27NOYXqy/oeN3Mr3Ncu4iM/+ervBWfKMi29M7hiS4ZHxTlA89sqwZhizBAZAxZaDmwuIaqhMc85yMsPhs+PGoao3rRKQ4erERCy0qhVNXzDwTFpUfqKKNW3rq90orRp6XmtTxxaIJfcLMa1PwOT6bWaCR2No1DN0HtD2xhnmUFwu1GwZZt/kxcHAGWlMcy704TyF/x6Trrzm/jxejk+BEveIUPxpNW0Fxf/sSMOnh4y0oaWUwCGT/+3NO9X6Zd1+0WxoIf4ITVBZktONxNJ3RvaZ+u9ZidHH3oZ8E7O1dqGfh00c7/sirjQhzZYbO2tZnU/DrJ8hj9wPJFf0ALRA2Jmw8BhZoWLr83UGch7ohzHdHYo+rgZB3zziAwn92AzReaiStsktnz115J8svCqZDoFRrBqzPokgy3Fv9yzmOTbeRBCNqZEx5Q0cHi6LlTpooEM1ERTV2oGjKyDFeOKB89mq1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(136003)(366004)(396003)(1800799003)(451199021)(186006)(8676002)(26005)(6506007)(83380400001)(66476007)(2906002)(316002)(76116006)(4326008)(4744005)(66946007)(5660300002)(66446008)(64756008)(66556008)(8936002)(41300700001)(7696005)(71200400001)(52536014)(9686003)(110136005)(478600001)(55016003)(54906003)(38100700002)(82960400001)(122000001)(33656002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/dMCukP32ptdMmBnkEzaW6RTpQtKS8PySdmphTwvFuNkNDKmwocFD2CQM7cx?=
 =?us-ascii?Q?LGlmM7OP6KqQSSh1wosb16BNwhi+9thcU/6RqFw+B25/wJCIQLFXINJFG8ZD?=
 =?us-ascii?Q?y76+pHA5v5DdSVC5ivlyGPPVfeZmGkxN2VilDxYD4SIAIJS7ivHKct8ZVkqY?=
 =?us-ascii?Q?Kw/E0a1JZFNb92TuKg1yxzLoUtnnvDebxDCC44HJPUrjdUTYq2FbNzm4SXaB?=
 =?us-ascii?Q?86aF3Wkxfztduiptjb46bo/eTPSvliQkcllrBCUT+bs3hiRPpj6wrHko/tvL?=
 =?us-ascii?Q?kUWGsRZqTYqYO8QJ5Gq21wF5if68ub9k3iAoyKRMexO61BUF6yNkdSOs1TcI?=
 =?us-ascii?Q?Ek1WD2ieEw+4MlzP/Fgrid5N1M4HEBaqfrlFGIcnfiN0EMW4WnpbkpHvQ2nk?=
 =?us-ascii?Q?atEYP8ELtRZTMP8NiM3pAumX0HQHR5vrjtnGhYF9dQZha4GZ8RyBZjH2pqRi?=
 =?us-ascii?Q?EY62AfBJT2wUPLxIsRxmbu3t4aYDRXwy9uVVwYnxdJRFsmjMFdxcKaYfjLQC?=
 =?us-ascii?Q?4UKlrVH9ObY4ejwB0ZvvhbaUivEc7gaMYbnxWLP0OehYClCVzTVcED2MiWwu?=
 =?us-ascii?Q?Le4DHumfGldm+tfCSTbO0oF52BK2GbCXrOpdKWB0ZM2yCMuHVLtiXc+daiTY?=
 =?us-ascii?Q?BLt6AHOMTPmq6fyG0OYAsjBspfX3PS3V+Q2BT5IxS7Tbhnzju5CTn+THb4yE?=
 =?us-ascii?Q?fm8e7xTbx+PERWImg/S/5/ZW8ODDoIha4OMG1OOO9i09cOseK3ZWD/cgZOOX?=
 =?us-ascii?Q?5xtL1VX1UrQWwJyw4a5CFuKfmkBUdmbeJtM8L4WmniiMxOkU6tpDOMHxt3LO?=
 =?us-ascii?Q?gvu1q33uUcc2sCtW+NrjJIJyWXoTNc/jhsCFlqesYyejY1fLaTjbh8SgbXiA?=
 =?us-ascii?Q?pVZ9yhCuUcBKlc8N70wyT3m2+7YOYZegeGr3sebQhvzmMNdQZ2kl9c9UXWYg?=
 =?us-ascii?Q?6hnsrMgYsurG4U0ATq3pUVNVtUVo7LOMbfO9q15efM/i1jclQKyaPJmXVCOe?=
 =?us-ascii?Q?/U336x97BSSaP8h37vOWQ6YxA9bSn7muCgsI4tSSQR4jRaXqdxclrFICPUi5?=
 =?us-ascii?Q?6ltul+YTRZkWU6lcOo/o6fZ5mDCdDWGQENYBp8WxeEowF5+NIr+rd8E2cix7?=
 =?us-ascii?Q?lVkFBrcF7+TX+lShFRAs12nU93Xx83cIu2IC3Yeg03pAta8Vj3S2uGFSvN23?=
 =?us-ascii?Q?+NIZhQr2cXeviQePTkSJXaHKKWcLMQppKf49D30JFiHK0cNt54xNH9//YXE8?=
 =?us-ascii?Q?hT0lJv3WPPm4REPBMIGOSG3eUe7vJQS4HBo0nBjzFVLwsaFBWeKjNzqFz8DH?=
 =?us-ascii?Q?IFqBhz2DXrG1YDkW+GD4dysauRtAxxkE5m4NSyjlFRVRaFN/f9PlZN9tU/07?=
 =?us-ascii?Q?daZ9Dwq0TDqqEgW9z6GmJSfzT2wHTfnZMghhjSUonUBMoC3Uqu8shUVUlbHP?=
 =?us-ascii?Q?V1hfnuO7S4/1jdgtZhMEKuUr0tixyaXPsSMcOOEnPzcYwgeEWzPTmIkREx9N?=
 =?us-ascii?Q?VcCmfBUDflaNYEPdTQatukdIxZfK3DuddDhJCBNsaOZPCRQiNCxjkI6XlYrc?=
 =?us-ascii?Q?b0QaZ8G4ug5RExatTPVx8QbjPL2twGDreOOo35FE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb78f2d0-ae65-47de-c467-08db94c037c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2023 07:55:49.2947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qqv8QGAzLMylbMoxoyRGRb7jpAvGNtBEtvpZoz/jzMOlz8bKMeL2G8JppyIQVYPrtrp+N4oNjDyVABbFHUN4bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6426
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Xin Zeng <xin.zeng@intel.com>
> Sent: Friday, June 30, 2023 9:13 PM
>=20
> Add logic to implement interface for live migration for QAT GEN4 Virtual
> Functions (VFs).
> This introduces a migration data manager which is used to hold the
> device state during migration.
>=20
> The VF state is organized in a section hierarchy, as reported below:
>     preamble | general state section | leaf state
>              | MISC bar state section| leaf state
>              | ETR bar state section | bank0 state section | leaf state
>                                      | bank1 state section | leaf state
>                                      | bank2 state section | leaf state
>                                      | bank3 state section | leaf state
>=20
> Co-developed-by: Siming Wan <siming.wan@intel.com>
> Signed-off-by: Siming Wan <siming.wan@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>

this is a big patch. Need reviewed-by from qat/crypto maintainers.

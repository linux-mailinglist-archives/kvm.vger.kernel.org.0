Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE0976E2BC
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 10:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbjHCIQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 04:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbjHCIQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 04:16:16 -0400
Received: from mgamail.intel.com (unknown [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CDE4481;
        Thu,  3 Aug 2023 01:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691050146; x=1722586146;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qGEAg1bfWLHyrVZcriQ000JgDp4pH6Kv+WZ7jbH9YfQ=;
  b=PeNeaq47J098pvjaMoZIPclXke0/IlN1CtfA7a4yVEkzlHHFP3PZeMn7
   ivOsISOOKFBMFe1ekNc4J2Hh/Ah2X9fhvpdQrM9+Knk3jaAxz6x7FoTs1
   VZDmVJVjQXsJ9GkQKFH2TahoQD2MSf+7QOpGUijHEkaNTq0DczkMPQFaI
   bqW2/8kiCIpYpaIVLXh943m/BOqr+k4p4wb18VAJZbQ1xCX7I1YTSuJxA
   kBHnrkcM9fT7P+PUxAPSVJ7I0K+NkGMXccH3/t12y6aCjmUPti/enPX9/
   Yb/Q0KlDzhJpowdjLMekRs0nssimyV3DsiuT9npnzWI1r5gZoDKRV2hLw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="372540909"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="372540909"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 01:08:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="843499222"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="843499222"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 03 Aug 2023 01:08:38 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 01:08:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 01:08:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 01:08:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gik19M3CiD8gdQhqzvAPTzVTx5eo6saIXYszGmDxCX8nnKLyBKXlqhjir4jamq9MyikaK+qWki8GDvBYNCBlkEe5i4hiORGGeBAq28DD680j/dfOuVshjFOx/9mNWGXCOY8MqAGvhZaErRHuWhdiHpoz7iBLxeFGvPQW8zDnRWs7SrJpy6KCZe85K40shV2eKPVxR2KSLmNDN0tXyrPHlsvWq2pvvIHhqIE2NzznH8B6wJP3szhxMT/9OIsS+Qyee4Vsn1dwdSbf7oPjFUa1wGvpY6xk5XYXETM+nKJa0T0Ha8yRSmqx35JCPaxmR/sKekLBRFB0s5D1BqIW5WhAeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqOuDQKWjWnv16GQozXpqOw87jmfHI8PlYS+o433imw=;
 b=IOsmPaDz+9a67zrQLnrwIplzAnw0ezGRv1GVq5n1SeEMmpkQZIxbaNaDIxDQ3KlXEJYue5BrP6TsIOFdvbYDCctLVB58WSOeH0lDwkvf1ZS4Y19HnKo0YtKS2BFQlDoCxyyv4zJedRPZLTXgTy7+cIA1feA3SBpQZcVcz2cn2ow9wiAVIkFGL8E/jcT4OslafpRDsW8GMIf5xTgHNznIfKY06MSerA11f+ykuVJ02ZULhPEyqtVzgq2onwpSycK9uBzwSy++2j46jQs7sqjjWbDiaY8M330hgNez6Vc0zS3MgwoU76P3U9NjSkZEcq4mGoixmZ25aPjczN+mRAgu+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6346.namprd11.prod.outlook.com (2603:10b6:208:38a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Thu, 3 Aug
 2023 08:08:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Thu, 3 Aug 2023
 08:08:31 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 06/12] iommu: Make dev->fault_param static
Thread-Topic: [PATCH v2 06/12] iommu: Make dev->fault_param static
Thread-Index: AQHZwE5fZVS62dLiF0SVYTshX5iUe6/YQHng
Date:   Thu, 3 Aug 2023 08:08:30 +0000
Message-ID: <BN9PR11MB5276BE0DB32E8E7ACD84828E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-7-baolu.lu@linux.intel.com>
In-Reply-To: <20230727054837.147050-7-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6346:EE_
x-ms-office365-filtering-correlation-id: 00ab3079-c1d2-4603-2954-08db93f8d33b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gbi9Hdf3kWitjInUl2C2SW4XhZJkHvhSXdFHY8vma1DjhTmFFKllKkOtXrhI+vGjJss6XZ0uYPdPl6EnHTS/ogIel4v8fg25r6cka3v7FTNrcRHe8vHhjT+jql91zZFc55vopgh0QKBLrqOcHQbHjSSpi9XNnYRilrgpdsZYzDeV4+8HVrQVQuumtDw1wqANz7Qg0eSHIm0iJMC7e9IJtHWQPWypEGaFVMbkcUDcePWX++TONWd+BbqmW14HROCRqkpjs7kdn7mjJZGV9r4tEXjmKbgX4F+kaoQRjo0Jkij3jwmupHv0oBZTiHTNNhV1JIhnwVEvdtIWyX+ajePXn8Q9pDEzX4x+NSvqnvljnWAhaBBr1i4K+HJRlBPd3wK/03w8xmWaAgh5tkFm+1JexxnBXTbv/2FLgQn4rUd9Y0Faezj1utelQki/j8jSS62jh/swnEQsoXz5GX4CsPZJtxQf96sxiAaRYnag0am/cv+LyjbeXKqbtXs7rB+MTzg8/9Q2UEDJADFsiCyDNn6gIPQMEei0iS4OUGvmGGWtofTmDAEiOcvSBf3idTYn924Iy9gFENMRa2HPeodQZ0CVORa6iwHqbOMJ9vQyT42Tax1y+nJGJBq/m8mRyVW3LwkQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199021)(7416002)(5660300002)(8676002)(83380400001)(122000001)(82960400001)(38100700002)(41300700001)(4744005)(186003)(316002)(8936002)(26005)(6506007)(64756008)(4326008)(86362001)(66946007)(66556008)(52536014)(76116006)(66476007)(66446008)(2906002)(9686003)(7696005)(71200400001)(38070700005)(478600001)(33656002)(54906003)(110136005)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oORZQYIgasdAc+LE2ZRVy/avf4v4De2ki461kfJLTIqp2ABMZ2dIb8ZDqsav?=
 =?us-ascii?Q?kCTLzPX0esZeEdo/RuU3l9FY2Pvx4MWWo/XKpdZDP8fi8dXuxTDQ1YrSXXBs?=
 =?us-ascii?Q?9scCx97zFuE7YZU4ySpyWIBtswwdrwbj1yfq5RSFsRtASTsmyHr09V4WupQB?=
 =?us-ascii?Q?QhBooo1hfipqPNyCZQTOWvSXzHmAmlaJb8u1f3v6x7KzuvZGGJAtSakBlVif?=
 =?us-ascii?Q?BfPMZVSjDaLLR7+beqIpHZMf3v4brAS1U2jZ6O/O9qzrLc1jJcvtJzs3V30c?=
 =?us-ascii?Q?K7vJfPgEEGBe/N9u/ECQblqj81xi2YOSuxhIyIVBEO6qS1NfOvXWADZGoy5A?=
 =?us-ascii?Q?OeKg2OjnVlFoYO6fcjz2d0Svx2bfwRCtBdHBypHdR+xqKHIKO83yxhGgwgpV?=
 =?us-ascii?Q?+gb8cxd9hQlD0GuDPxRUUJDMJnOGL3cSZha8nOACnw2xTXI3yF8765WRH/O5?=
 =?us-ascii?Q?15i7gmPXZVGqepvXDl8DVUGL9M7H6nnHVaBI1AuapWxqc0chj/ApqZKWricy?=
 =?us-ascii?Q?2s5PebYyvhoA6kTrSZIKd54RabqGYm97+qEwUvprJ/jdk6mvXxkXd9mzgRsv?=
 =?us-ascii?Q?7AFG5CwLmztd3ntSeNsnRusXnWkQayYf3r4/eAMT5uuSL/x2gqfe0s6+3o7H?=
 =?us-ascii?Q?e8ozgzNlhOWoKhuFHQoDSxka9XaE0PikaD5qM3bTqyjW3CsJmua/ehvXlhMg?=
 =?us-ascii?Q?D2n0FPSKz+Pa98aK4o7FaBjORos6O7QIoLSp95t10bayCj/6IArMsUHUjA9e?=
 =?us-ascii?Q?0xvk12sAi0CL3TGNWCQPc6wmCxcaesVGG7oN3DazyEVXQtC8jQFd0N1v46wp?=
 =?us-ascii?Q?drxR+RhxZBcn5y1Yj19HAOvyl/xAHVH08R2RAhgchdnHXVW9fKYviuubpAZh?=
 =?us-ascii?Q?ItmIbVlCPoJTxg8C6BEGQiEgsV1RvGYi3ULgJc9kdxd2zLyvnGfL51iiHJIv?=
 =?us-ascii?Q?zk082KW7LpV+EbCm1LVgiehXbWTQ2G2/DjPGauJiFmsKwU6/pU5WfR8dsZeK?=
 =?us-ascii?Q?LCYPYOXnJ5QjdtGeMn2tJ6K88LjYrCTsQVLLcAJ+FVU9z91UNG8VZFL9bA39?=
 =?us-ascii?Q?6LQ44DUfO+63QgEV0uRmoWnST8bLnLwMVuaEuL2MUZlyG1VY9ZFs1vsNPYwD?=
 =?us-ascii?Q?YoRGjPV8W4EcJ7GejWCFFk8g39eFB4Cr/vHlWU6Q/Ov9jfzdaVlbMnLtOPcD?=
 =?us-ascii?Q?+47HmiaaJY4DFUAPiVmFx/c9Mxure6EmcX6iN+hAL+4GQti7G0SDhkEtf2iy?=
 =?us-ascii?Q?+l78Zg39sVOkQ0aWXOfzplGggJJM0YCzGfg3bhcOL0xzDnwt6tYbmx3yz3Y0?=
 =?us-ascii?Q?gFUQLssXR4Z1Bqb64cttIsq0kq4DSCYYj2x8AqhT+tqYAlM5MmaZ1jD1D8Vx?=
 =?us-ascii?Q?qYU0kHWAV9pmBZY+cDeYXFIRMUKkPGmsZLc+HFZZFglT6yjv1AKQSYodZYv5?=
 =?us-ascii?Q?5KFnZYlxbLcINCcjiufKWpSayaR76iF0g+6mE6Q37Jr6UMxl6suPW7jSPZKY?=
 =?us-ascii?Q?T4sLlLQ+ZoxQWUBRPjzEoe+4raCIaH1tesBnJiUVyQH6v//s301np5ZnLN9l?=
 =?us-ascii?Q?ZGx03DDeanwp17XCRd12ldzy8XeRIbclRpRgV6m7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ab3079-c1d2-4603-2954-08db93f8d33b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 08:08:30.8004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8wg3TRU0p/vPzQa4tWeUdih2/0C2DBcx4SPYVWl7hfn3IMeNEKU57tUTGcmA8gIdLAXeKdXaAnzLRNyDKoQvhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6346
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, July 27, 2023 1:49 PM
>
> @@ -4630,7 +4621,6 @@ static int intel_iommu_disable_iopf(struct device
> *dev)
>  	 * fault handler and removing device from iopf queue should never
>  	 * fail.
>  	 */
> -	WARN_ON(iommu_unregister_device_fault_handler(dev));
>  	WARN_ON(iopf_queue_remove_device(iommu->iopf_queue, dev));

the comment should be updated too.

>=20
>  	mutex_init(&param->lock);
> +	param->fault_param =3D kzalloc(sizeof(*param->fault_param),
> GFP_KERNEL);
> +	if (!param->fault_param) {
> +		kfree(param);
> +		return -ENOMEM;
> +	}
> +	mutex_init(&param->fault_param->lock);
> +	INIT_LIST_HEAD(&param->fault_param->faults);

let's also move 'partial' from struct iopf_device_param into struct
iommu_fault_param. That logic is not specific to sva.

meanwhile probably iopf_device_param can be renamed to
iopf_sva_param since all the remaining fields are only used by
the sva handler.

current naming (iommu_fault_param vs. iopf_device_param) is a
bit confusing when reading related code.

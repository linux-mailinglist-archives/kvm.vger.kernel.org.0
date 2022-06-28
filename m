Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C060555DE8B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343910AbiF1Jlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 05:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343497AbiF1Jlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 05:41:42 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1A61E3F9;
        Tue, 28 Jun 2022 02:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656409301; x=1687945301;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PPoQhqKCB97rvXZTFEj4u3mjLEZTjYRt6RxNC0y82Jo=;
  b=EWsQaILIJdCHa03cwT3qA27ZeXELl0uKrnC1gS3PFF1UxCVKzgDDBK41
   QLCgYbD7GTGAC//llLK7D8UZsl9A7m9k/0fNkvR2ktpcx7IcOIgJ+PBDS
   vjnH+BUFNYaEb5uf4t/UP1EVfHsWxyzx/5mYi2IFEwhELyIdxTzN1tLzA
   QjYUUmNRyrr/2TqESfKRX1Xj12KgcFxYihpioyl8o4xUlsgffb8+82J9K
   2lPIkhYepYzwABLFJxjhiai6kjVaTVB6TDwAkZ0rsBjJnKBnw9TAEWINi
   9k9Be4srvISUPtQmy85aJOD+HC0y8IUAaypwgK+fb9qLFng3pvfgqTbgN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="280453630"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="280453630"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 02:41:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="622885580"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 28 Jun 2022 02:41:40 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 02:41:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 28 Jun 2022 02:41:39 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 28 Jun 2022 02:41:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eru8dCPfe/m4Fas3CxxAAiz2TKWpdBV/QMXHJMZ0XsgLMLFVGb0Al39xN7P/buuF/W2SgUY/RGnUhB2Z03u3cgqI7EEdqZ49n8+ZGD2rjJ+n/613UgYOUYI4HnuBb4en9BpjDUNZRvOXpyBzzYiMifuq8JThKsQOC0F9skYASTP+VggqXlo9DwW8D510xwejt+jL9Sxq+wmGN1IwGpS3l8ZBaruLNHK73cA+diWoUofmbxzuqqR3FIJlRIQF4jgDz/TE7QjMLeCw61r2b6n1iLAbnkzNlpg61rdbf1ouMs8MgXaqlqrP+KTKwjulv9985KOKjerN0/Oldej4qW6MHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PPoQhqKCB97rvXZTFEj4u3mjLEZTjYRt6RxNC0y82Jo=;
 b=W0Rzq/Kg+HF0+JczUf4mZFnP5r5TV0kvvkKnOnwez1NjWdO4eqlQLuZ4xY4C5IL5nbBjFsRJwIdl4XIxWOm/upyshKBN3zdL7Tv5kybUDQG0O6rFsFdo2gjTNdZ2rgIVmF0AgD10znhP1cszQsq1U7Z6J5ZvnMbzoRKb+U5KH+3fBwsMCysvQz5inscDb3y21VYI1eALkN2ib821HeVbiGHa5kJ2d3oYksjK7yTj1ZIi9OLSrZjZr66fnEkr+qCqVBHY57D+5oSu55SzBVjnH4eHUTzMra5iyHhKFIoewoVOlOzAxjSq8EVE32BCfXS1udmnVxfKJjoNvpirv6DDDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB3721.namprd11.prod.outlook.com (2603:10b6:5:142::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Tue, 28 Jun
 2022 09:41:38 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 09:41:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>
Subject: RE: [PATCH 01/13] drm/i915/gvt: fix a memory leak in
 intel_gvt_init_vgpu_types
Thread-Topic: [PATCH 01/13] drm/i915/gvt: fix a memory leak in
 intel_gvt_init_vgpu_types
Thread-Index: AQHYiq38LgOdw9BtOEazH/PR8ELOWK1kkQbg
Date:   Tue, 28 Jun 2022 09:41:38 +0000
Message-ID: <BN9PR11MB5276798C4BEEFF0A6B2794C78CB89@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220628051435.695540-1-hch@lst.de>
 <20220628051435.695540-2-hch@lst.de>
In-Reply-To: <20220628051435.695540-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9de7cf5b-d75b-4bd5-9885-08da58ea6609
x-ms-traffictypediagnostic: DM6PR11MB3721:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wysCH2+in62bgOetPlxh2pG2JwcN/19QfWU6WrN+vLYBbRAF6etMr41gWpoG+Bjzif9FsTxkeXOD0M1QXIyTYONVMWbMjilkTJBtfbu/DLjIPZMiQQaC+K6NBW6rcGocAUIM2EGikOpTbkxCIMkyPkIRdNvi6olMwMMc4q84d5jaDc+fn08lr/6+9mfi34NHCwuiVrvGTX5DO6slYfPAMnfP6E6je6RfIoTMPmsCOrijD/q1JxYJnzuwXLtses8FLJ1z2vwN2zZcW5Vp99LvVseqKDeuaqkeQvfWhTA7tfVdIsZT1PD7GHzbzKJgV1oXJtVn0QQ0cxd71+MP5AdytdKpREaIOj8ivtQKIiJR5ahkvdQNdTKW/tpUW9DvN8kHqUxJjFwx0WJL1rKxn5TV6DIFx9uPFVnWvCyfMb5Mj7WLAmw7YrV15ndmnf/JGjBPrKPaRBPk1CwAHyorQr6WqilaMtsVk6jaBDON823+1vEKtfODcedYJEkQRX+Vf3tXZsGBhOHhzn7wR5yeSGzgpPWtKhmesoSHuqKcFXxY3szpd1TsRq/H91VyveQrwnc3SR8U/9P29QgTHe8rWs4664THFHpYA48R6lE3PYy3Qj+4imIIA7fIYCBXhb3t7RfluefK4c/SAYK8M6TXQVl0zvZdnKA+xSN3UgJ6UeXP6bEnVNbItKR/xHLuMyWAGk1HRWPg2JUEDdEbXFVnJ5UwoPyzNZ+kQ7x+kd/GlQIC8BwdggAG4aw4TIzve2EYTKtjpyKmqaEyKvgTcFiL5eDjibm6rJl6DsZTO/6aLvEQy9s9kNMA1M7iYeupv9/ulBRy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(136003)(376002)(39860400002)(366004)(71200400001)(55016003)(921005)(66476007)(26005)(82960400001)(64756008)(66446008)(66556008)(6506007)(110136005)(316002)(2906002)(33656002)(8936002)(8676002)(9686003)(86362001)(66946007)(38100700002)(7416002)(54906003)(52536014)(478600001)(41300700001)(5660300002)(38070700005)(122000001)(4326008)(186003)(76116006)(558084003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tIHWPVEYzBe0Q0RMg0NXFLz9/zxMoA9qFhv7hq90lnmV5sBmaui9IxS6unFP?=
 =?us-ascii?Q?aDjmOPh/96MwV03n+di789QaHPnemhkIvDwAxRidxZ2NdrKotHq236g/q3bx?=
 =?us-ascii?Q?DEDKRT81mgL/ssyq/3TdEK0fBafWGnzDiZneATSjvei3vxLs1QHN83poR6Lj?=
 =?us-ascii?Q?HR218CTeLw23kV2tzYI/qSjtHzwVFqMdLAu0aSZpk/Telrt2FlmwXDGVBtbd?=
 =?us-ascii?Q?KJ/8wXZH5UZdK/Bz/KB1hoJmxnRCwygY3GL8w0WOaxydRDpRqtITKEEmvR+m?=
 =?us-ascii?Q?rywKB+fjTJwcZtNiBFE9+qiNAqFmid1n4UcYFMSXSYDEdwOGCIb6yVFWUZPq?=
 =?us-ascii?Q?GNJ7c2LdZcUktkQXn3jXRx2RpGGnscOMdzWDRTGsDkAhFOGgTm4845qDsPV7?=
 =?us-ascii?Q?cSxWxfVKyQjjfKPtDS4w2r1gstz7lHo/HVu+3OEpZ2TjpNl2Wr2X+AG5AJZb?=
 =?us-ascii?Q?mmTY1xx3W94gwJnCDyp96UO+0BuymeeY657OTxC32+6+2PRfegKnpHT3lDkd?=
 =?us-ascii?Q?oQ343Pot0qinjtfIANp7z1OX3TJEgPMU9+FRhmL8UHGziEAQIPLj6RqKxtSI?=
 =?us-ascii?Q?jXXNKA56IaR6HvqVFVJQtbZknbniZgCSLPjmoYHreb6IpyM/e9aS12atBZDN?=
 =?us-ascii?Q?JdXV5Ou9bStr+qugi4JnCcwXNFFEkTCe1xa3xhDpzCKvDufbg3voGV+q2GZ2?=
 =?us-ascii?Q?KVMooLucyBpHM21ismcagiYD0oOo3onUHcNryYhPiDfZOP+DqCpsi8vgIIT5?=
 =?us-ascii?Q?OzcrdS34Ymald4ieXNYKweH1SjKJ7x01/HpSwTNrDlknqBH7IY6MD7crkZTk?=
 =?us-ascii?Q?k905E6aS6zlGGcs181tgXROc4+thjBvA+xkgZwYLzn0ilzLS6nm9CckX/1Cu?=
 =?us-ascii?Q?75dFDsCrAHDoBTSL5ueM+ElOMX9qIyOKqMDqnTU5kRu7jcZjgjpT3iTtLHAi?=
 =?us-ascii?Q?a27/2VXYQHlgHUzKG8ztZoh1Mug5pzUHpRsVgZSVB09ARk+hRV8tzrMwBTIr?=
 =?us-ascii?Q?K2RhMrzLoBqlp7qDkfeIBV0YDwLgLcLZ1svbamcWIftul2XcOUTWCzlwIGmM?=
 =?us-ascii?Q?CNXzTWmFxZJraAp7Pdtjmi4KnENiobONipMwzxBu7HBrgSbx4rnd2WgBiofu?=
 =?us-ascii?Q?pGIblsF/wuzxt5t44ks8GIitcD95df4Bky+nqZGy4u6deCjlLCMNYrE8aaKc?=
 =?us-ascii?Q?XPumrgUcb2nLwQ5myj2b/Da2kwISLEqFTsOpWNSWapuB8GMnvAC52YAmoQP0?=
 =?us-ascii?Q?urY/2wD47eOkm+yUWOk2nCQUiztIqW6gB0zPwFB4Q8hHtPvfARAjpNKP8mr8?=
 =?us-ascii?Q?Xn6/iK8xRUwLOk+mdAWD5GPqd9d+T182wThmFhsH8YU9EJNai6/tHa2nJDBE?=
 =?us-ascii?Q?8SeSAsmKR0Umz1UJuMjV7CXM1HvXYGKE8jQtkQD74LHbjjMWQ5wjk2wpDuCZ?=
 =?us-ascii?Q?N2VtQ8FQjlFSHkSnwSC+x46FIvY7K74J9/w1GT/6yTxff02k09mk/dkfqvHM?=
 =?us-ascii?Q?kBaYpcTPgiFcZEBU5W9NmgU2jzetQSFGfla81lCgLVtGv0STojd2meO6TqYG?=
 =?us-ascii?Q?nmbkGX0eVc3enF6CbWKmccPT5P/63AxNLRHaX73F?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de7cf5b-d75b-4bd5-9885-08da58ea6609
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 09:41:38.3218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QcA3oRPCDl+aBywFjBfQfGIHxjKPh43PjJ4HZgTOjkSUk4fEa5LVVPiw0ocF3V/eT/sEoWxoehQLQo/eUc2mBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3721
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Tuesday, June 28, 2022 1:14 PM
>=20
> gvt->types needs to be freed on error.
>=20
> Reported-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

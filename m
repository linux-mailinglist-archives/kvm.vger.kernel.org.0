Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8491759B846
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 06:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbiHVEYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 00:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiHVEYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 00:24:10 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DC819012;
        Sun, 21 Aug 2022 21:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661142249; x=1692678249;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=3jHfoM8U1Uf91FXHEugws/bRRhvuOA93vJ7NB0BGxtE=;
  b=B+ifBPmzZMrD324cLwplGP+wUx2WJuPyC9u+WOUz5AEruN2k7WSu3jsf
   3omWh67MU/MkF6NTTXFApzYHKmj7dZRobaNGj0fUp5glHbjeUTsdK+KQ4
   8HIV9tPbwW1b6/rwsn/KNllPz55cl95kPqxl0NTYbndNM0NAqUNZB1q3X
   wUa+Mq/aY0xse9kUpi7OxF03iF5Wibi0gUIRwfZ+DleuWWQvk5yMvyJDv
   qlxqrwl89SgUIhOBtDG+NsPW3tHiTMD2MgQXn4ZVdBXEX/rxMbyghPphg
   ToFq5Eko7VBBDJWEGqAUBj42Olt4bp/hlgo8iOcTp9WHHehncuhde3s6r
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10446"; a="293315177"
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="293315177"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2022 21:24:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="936872598"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 21 Aug 2022 21:24:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 21 Aug 2022 21:24:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 21 Aug 2022 21:24:08 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 21 Aug 2022 21:24:08 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 21 Aug 2022 21:24:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpNdKrc536atW0a4JTGWWI+p0QjVLVZKxhCDjkHB6c1fEhl4TleYqsTkVuhgTJpqOOl2Ak5IvtCwR/gebc1aaJ+lQt7iRD6YJu+Xnjh85752xa6x7OPk1Hl0uZ3K3cjonr5Rc8IAjoy4N09+UmRZMfE+BAJPtYDfF88KDPV2xbTLmtwHU+MYXObqc7IPS90qJE+ge0m49QR8e2qgAiR2kkbWJl//qVPXDRSM7kjWFI+0YXf4dScsOODVKm5bFFgk5ALPJge2rYJ5ovdmuT6A2iob6xx9Dx4JFeUFQYi9qBxGP8Uzzk8KOQ8/+zK3IXbdPKwA7KnVKC1X2A3sUw9cJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3jHfoM8U1Uf91FXHEugws/bRRhvuOA93vJ7NB0BGxtE=;
 b=d5zH4VCUAGNOYFpIi8ytc9SjGFrSA2bsqwHtM8BYPDJvV7k68AeJr4+nt4+wnYYkhokPerDAE7RvAMYkgM9EmZpxIizQ3NTLk3hCR3ITK9ZeFNd3h8WJ7E/ANvMZg3QB3itYGJQHqaqiLmRBiN1cBffPXuRD1sEK9MnrUnboUbI5w5JZZpYDgJuzEEjEn+A1bKqlmkgSXfIhF+SEZYqXXN59YNINmJBn/rAWt8HUuoKS/PF4hKFxOoHX4zTOjxdsrPc7k2Lc/pUC9A5BwylMjqNKxnJpCmdV5RM5kvuO2/mFTKIeGdaOKCAUx6YkNY7OO98m2k2Z6Gbc8J1EyYbU4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN6PR11MB3488.namprd11.prod.outlook.com (2603:10b6:805:b8::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Mon, 22 Aug
 2022 04:24:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac%3]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 04:24:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: RE: [PATCH 2/2] vfio/pci: Simplify the is_intx/msi/msix/etc defines
Thread-Topic: [PATCH 2/2] vfio/pci: Simplify the is_intx/msi/msix/etc defines
Thread-Index: AQHYsk70nsDfR54E9UK2vlIBmsmPf626WVZQ
Date:   Mon, 22 Aug 2022 04:24:06 +0000
Message-ID: <BN9PR11MB5276AEC135AD3769479D1B758C719@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com>
 <2-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com>
In-Reply-To: <2-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc498da6-7046-46dc-f728-08da83f626e6
x-ms-traffictypediagnostic: SN6PR11MB3488:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T9YEKEqDVfpKB1gPqFKD2KTCgfi9+IYl/N3u5gOOaBlyNGLskC0OIr4RYf1LqPH0f7XjUwWstBhEA+YUWeNGCpBYGeU6HD6Aj/SeRPzdBDwlgAZo0oIF2f1a5Ow63gE+3laE/cYBChrrGrseqBWw3WsOtu3/V2koa4cNNPJ++hMHSaKgE9e7w3fxJ7qRiBfUXVOjenJeWWBr+ByxapQ0RBrkvyycz36q4D4P3hvFB06N61R8c8mGrEix256BXfRV50JGI9k6Crlj/7umxF5NYDVrYt8qyevxwldt1530GOhSnmG+xbXw6s8FYzum1aETCXVV8NIqGzq/caww471LHe4/nk8JLHO6bgqiNgZ82CGyt2UKMAoZDOQNUcqc0m6+abk9NRde9hEC2y0v62ys3JYEXaoclPJTzIIhpvdveRZB/5SO8nXuBeVH26pO8Kr4XyWjcea/kZm32glEovukvsljIYl5uLN+OGMf+hQ9NjMlCQdTxqsr6+AfNszDEUaaxe8FAbKzLu1FZMMKYOU0dYro2pGKT65SlcGJbF4qgyWdpAEK4ZRorF/xJ0RXIZSzzhVZttFQ/ff78L5CgMakTmQRQ0k8NZlD+xRJWJ99Hg+3pnI8A2a8Uu1AvB5n5I1o2d0q8lkg45Em7mwvWqHj9fjSWnSyhXmoYigvxqOWnF7lFUTJyDpvxGz/pQhlhLQQGgLTrCmyQGy1jomxXXJ8lnfwgJuHV3toiSauFkVaLBuA5xxBNvt2DTw6KClOVCt9C4TmlXa+indilmtsAC1tkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(366004)(346002)(136003)(396003)(8676002)(52536014)(66446008)(64756008)(66476007)(66556008)(316002)(110136005)(76116006)(66946007)(55016003)(5660300002)(8936002)(2906002)(38100700002)(122000001)(86362001)(558084003)(33656002)(82960400001)(38070700005)(41300700001)(478600001)(6506007)(7696005)(71200400001)(186003)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mkgdBbHd+HvASRaz0ZCL8F77rR/ETtDxTc7bvZcVdam6tlRe2pjhykBeL/aV?=
 =?us-ascii?Q?2WQEH7nR/kr4xzZ6Rb96fhhE9H3iiFHfqtdDhmLoDzHLB6mcEN/6GQBq81zA?=
 =?us-ascii?Q?C2DIK2DnLS3Uw6VgddeLLLN/7E0EgdEnk71PbFfqHqB7mCDaez19WdZYOdg2?=
 =?us-ascii?Q?88RQAZbK9tmlt4liPCzOM7/yNm066G7RyOR6NltMcu6FqzXN+42V2v+rsjDK?=
 =?us-ascii?Q?97Vwr1H3Cp257ZoCXDzwdqKC+GrNIaiD77koILJ1mef8q8Y2KVwh1l4qSshj?=
 =?us-ascii?Q?8a67/oFDxkzcp0sg8pv0aDDSBxV7oNavEdzpYKCzZWx0Csj0odD63LaFKoHN?=
 =?us-ascii?Q?jVbsyekI/slHXpL66f0uIczIIMiwhY8Q2qVa3jlQn+iwspLiDh7Hg5VLrRjV?=
 =?us-ascii?Q?aMNKoEVnhXXU3HeU6erTO2n/6sc+cdlcH7PCupkvcHtnILyu+jqL0356D6mK?=
 =?us-ascii?Q?lsDw7+i2nO+4vnGOuBYHBQ1IiLDeNobx4+QLZFqaoi0Y1F7r5RueIw7Anw3y?=
 =?us-ascii?Q?kSgKWLpAtSpAVtM+fLAFICqPocMwQbcRuDBV00+dFkSwlCuPEGil1LSbILz0?=
 =?us-ascii?Q?i14dOjtg3dvqiNIzhpdBegJX69ZlhVVGh25OYXPtI4NTMs7qQqpaVrKujRCN?=
 =?us-ascii?Q?KvZGy1JlR4Di311tJf5IQIBkiKU2YWKlS96DiBopE8nLUESJRnj0UPjeAbm/?=
 =?us-ascii?Q?RDS6MkOFy8/5DDDuKBgX6Eb07MUkoI9n4i578PmXRZF/drAPg45mfLurosCF?=
 =?us-ascii?Q?jBXL1hV6/qPIZ7LmmXo80IjYZ83qJDX//NPyOdBXknZj91DInQPm9YnAlLSh?=
 =?us-ascii?Q?6xparx9XBOt8Pp++VMOorcjwlzSdSAHRlKvYmM0QTdKDMnNrROWfcXk+ZfBQ?=
 =?us-ascii?Q?lFv46/prwBkFl02jEi0oRMQK/rN1wx0s+aJhwKr63U2EozAHgdDiEMVERhQ7?=
 =?us-ascii?Q?0d9Ygltov1rOIlrYe7yE1Gxa643+NraTIRkA0Utnr9CDoBSigKCXykWCvhYC?=
 =?us-ascii?Q?vy94/DPz+ubeMj8a5h7M5rE3XNqRomORzgykgWa5C3hFZq/cMD5uIWE5IlSe?=
 =?us-ascii?Q?T4vu2QWFCxPZ2YU9tseoO61q+cfWl7qlCHThjJEOfN9W6uSA3aUa2O4k4SES?=
 =?us-ascii?Q?Lm6LRqZ8CyhTEfxkgmXfF2nvbJvXHcFqkvv65YHW1PdQ3Fbak0sChq8XKTaW?=
 =?us-ascii?Q?heJdFZjchIaYOT7P/Pp39oQj2p5v/n3tDsMb0YzMztFFdNelPaip3l3lKBRd?=
 =?us-ascii?Q?vK+pwEOuUGpw9dpqQSe3Jvhtv2HM243D3ZmVzhJS/B1yCFUuoc+imPzpUtR7?=
 =?us-ascii?Q?eQvzHtYYZCejxxfymjqDxrJjD/D2O5yr4o8UIGftej1ZqZ01qcVcvy48p+3e?=
 =?us-ascii?Q?WIHvJrGeRYbLRlTiFyO+yAe8oZk663xBip1u8i4UFcuKNI+EQz9weIR2ldam?=
 =?us-ascii?Q?VvaAitQ7kRo14mN54LU0DJ6TSSbQOr+NfrKlykAG5iTA3EvIz/A0Xv6UR/zh?=
 =?us-ascii?Q?hhpF/jwPlpdxNzbIBQyVZGnYVYSbgzl7+nWQfnr1+wKVF+eq2SQFSGJEDbOC?=
 =?us-ascii?Q?jPTBedV0wZhclyEJ5reOjVjckZDvrRPQa/QdiGIO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc498da6-7046-46dc-f728-08da83f626e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 04:24:06.3585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fH/fNXUNEavj8NzglzrheQ1Ej+UXrytz5cGVjd3tsONRB2mY6LdZNhaNiqiO1eWZyA4Gg3I9s/AWuk3tdtRUrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3488
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 17, 2022 11:30 PM
>=20
> Only three of these are actually used, simplify to three inline functions=
,
> and open code the if statement in vfio_pci_config.c.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

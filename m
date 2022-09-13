Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8715B6547
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 03:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiIMBzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 21:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiIMBzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 21:55:23 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1990501B7
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 18:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663034121; x=1694570121;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VguIjbmcZ/7YMVkvRFcsvGjUPlqVvuJRMwiY44VzmHc=;
  b=FtidGLCPx+gpwxJ8uP5hmrqaKYoR2fi/awF5jGBWP2xnyT2u0hYoVccT
   fpZESp/44IQ0Na/9LBdupSOd/By3/qqwvB+u1AbRa8mnz7K4lki5iQpCx
   AjSXR/42xM4Tx7gXzrO5JxvY4Wh/GQ5KD9b2rBEB2DsCmvZWHkkqLKmvc
   Snd4i0crpmo/lp1IGNQu0EXlVzugMsnoKeAkC1g4rik/pywjdDVTJBN+e
   h7/sZkg4WH3yw7tvipMc3VyyiuNO+g0TBfVuKH7I+hvVkK0EQQZrRE/dJ
   g9FvzLHRjkI2xUBMYNMjVn0aazRWluqwvNctxNY327EsN5wXtubNa6s0B
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="285033954"
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="285033954"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 18:55:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="944861176"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 12 Sep 2022 18:55:20 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 18:55:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 12 Sep 2022 18:55:20 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 12 Sep 2022 18:55:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3PjwkzOTDsOSTPNpeQE/T0C3VeJH0IJITdYNNUwLKe9SfG3MF1K8YYWjbBKxoNp+FnJMGv+RlGPHhH99GHYgD9sMzm2Hv2FTnqj++vYSlMSeoioVVPr0uKMnmmru1JJb8B+xiyPxNEEYuXNykh6ZuJgmY6TV4SOkrZhx/htn9O3F/+61pcZEIxeHpctkbwm35RXheDjDjQ/HqCXf3NgckFhYSqLvRHlCkAudxTm49n3jZ0YcFEzDoDXp/qYpcaLjrzsV7ZoMxCPAQ3LEozY3L/Hk21M5CKK1X2KppACjuUfz7+Z883FIhnBhJndIFGMnp04e/pBKy1qgRO/Rwuywg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hTReUL6W/qaKYmA9s+qwz5ehP7vxOb+6kCwH9qLwYHs=;
 b=F7TuZRTzhkJdRGYUrJ2m4xjYxOb72E8eLm6gYS2fVE3+iorPkNOc3c4APjNYg971941r0AY/OcZyEWDC0NRgHeh+CIZViddMMa/ZRGBrD+T6hdZwBUrdgRlmOrPO5aff6ChGweEYmKiNvmp7qwM6prWYlqmWhADDFv1dmvfoiQveDwALDJzfNuorVV0t2o7Fq4rQutGIkkS/nNsneWhseaC0B7sbbMQlo24spUmaLC6sdOEoTvQEW3SQaDXST4JHZaUKy/c9YPvBCLubxdrbct4jkzfRLcMlzQvYj+FLQMK7jPjk7YUm7ie1h32k0KEMnlgWHI9fZwjatCyAjHtITg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB6609.namprd11.prod.outlook.com (2603:10b6:510:1cc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 01:55:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 01:55:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Rodel, Jorg" <jroedel@suse.de>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Niklas Schnelle" <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: RE: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Thread-Topic: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Thread-Index: AQHYvwaitkEm6TEO00KJwkFy6AT+ga3cooLw
Date:   Tue, 13 Sep 2022 01:55:14 +0000
Message-ID: <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB6609:EE_
x-ms-office365-filtering-correlation-id: 44c8e24d-d372-4c69-6886-08da952b0048
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?us-ascii?Q?KeUX9unc6NxsHIQ4IFRQFJCNJswhKI/Eky2mHVVtCUr+pL7Huy63Fn7D21AI?=
 =?us-ascii?Q?zpjYKf3s85m5FnwDqSeQdGlR7QpIDo/+CqOHIOMrknICeRU2fPt4mwyexwDO?=
 =?us-ascii?Q?3oBr2C8i6KsXdi8cLoxIhf7lBwefyZ8twWLMGOmHkZORWbvHHzqvcmAD4toc?=
 =?us-ascii?Q?4LUtrDC+6XdeHq6+JpDKyz6RvcL1Pz/dx1CLeysX/ktV8VIOEOSWB3znI3W8?=
 =?us-ascii?Q?XqVhlaJ/Z1Ey4QtQWoTMDBREe/t5koB6BLTklD9e0AVlzUPH65dTb7p6846t?=
 =?us-ascii?Q?V+d8mlhbcnkDTc2HoKGesTgwHePQZcYa+JBKJoIoNP+LlAADf3WwZyGyRndf?=
 =?us-ascii?Q?RCxerjwgRkLVCDzT6nP6sHGDjRAxQzLR4LqxmI2TC8hBLulqq5BPCvRvIyWe?=
 =?us-ascii?Q?SiwMN5mfGBUTg/JWatoqC4QBNgDKrh3eJeu6MEG2a1UzyhUoNV22oUXNyvV7?=
 =?us-ascii?Q?+/O8jqtBIRGdRHAwPa0hggfLFQe2lgjWnKrqYqjZ5PEYpkW3PLFvPyNN1OtC?=
 =?us-ascii?Q?XH0ZuoHAsSJ/Qvb++EmHcq6m86N2AguRes4Q4ClePiEYPj5zR1LkjPnzVkii?=
 =?us-ascii?Q?pvoJeChNefXx8xJaTXvP2jsesS99QvXR8v60amvDlahyJ20vCpxbZGvqHHyQ?=
 =?us-ascii?Q?toJxZR82h4xzw89tvqNbeswqPB1UOllF4pOlSwL6KGmsrC1EhlbxewbYhdvI?=
 =?us-ascii?Q?1Q33Ei8HkTdrcpwMIqV1Z/bzydL3UZREyc2RXgPO2F6uX4U4fdSUqJst1PEL?=
 =?us-ascii?Q?lZlyd5m6raqEht/7loFEkLg2fGD/1ImpqTw97RweYoohv0XFgJsD9DBnA0n5?=
 =?us-ascii?Q?DJTcPl/7vWNo+Qd4Lmw25R/9tPNwAm2kvjq6oWM7ZZWtebE2yPKP+Zo+prpc?=
 =?us-ascii?Q?bgH/M9Pdz+NqvRUk/TVM/sr7PnSI917A5RRPIplrel9hrW9UWbHyy3Iz03Lx?=
 =?us-ascii?Q?jGHfeaVUdjM0ra30IAUPKsEZ85duDDIbAGpm9OjpkraoUV/txCSy7MueANlT?=
 =?us-ascii?Q?S0Py/eYeZOBJNC/tbZv3jOOiu+Go+QUCmzfVE0NpBYcQwSkUiJ4H6NUmdUOY?=
 =?us-ascii?Q?dCJIkzQZjdMa0DUXf1mizpKoerV9pv5o3NzoxwX+xjIjkhCKTscQsev4nBZP?=
 =?us-ascii?Q?9iBteTp1DbcfUZwBdA+WTjzOM7JHLy0lVOe+G+LY+YxTVfX2TRZuRYGOKbLi?=
 =?us-ascii?Q?RYg84OX2Nka0p9dBqaVLp+f1jYF8ZCCjuFA7PlrsLVju0d8bdwKx5vGKC1z+?=
 =?us-ascii?Q?Dd/LGg/vczUHygT96jqwk857whGVmcdWmPgHVCdicOGIdx+TvG7Xssc11ZgX?=
 =?us-ascii?Q?AuAbRQKrHtiunuYsJSStgCn3NloLRpiBJXfm1Pibii8tcD0MOwgk7RnXQyiv?=
 =?us-ascii?Q?KxxfkAT9xNxVc/FI8GIDrQZrF72SZOtnIcmxpssW9neKzt+H5WwKI3zC/7lH?=
 =?us-ascii?Q?fyPGreAnZaIDa3wCy9elEcYi0OT/HuJk?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:9;SRV:;IPV:NLI;SFV:SPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:OSPM;SFS:(13230022)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(8936002)(30864003)(5660300002)(122000001)(38070700005)(38100700002)(82960400001)(66476007)(316002)(2906002)(186003)(54906003)(7696005)(6506007)(4326008)(86362001)(52536014)(26005)(83380400001)(110136005)(7416002)(9686003)(966005)(8676002)(66556008)(66446008)(64756008)(71200400001)(478600001)(41300700001)(76116006)(66946007)(33656002)(55016003)(41533002);DIR:OUT;SFP:1501;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2bMAm1y/lO/LK5RnKUW14ViDU6PSiM3Vx3AlT7ntwTRaFwSBWBgXmFQgcHE8?=
 =?us-ascii?Q?osckNBZXg7tiAVfgwB783bL3XZ5rPKgCDHGUy8k9Jzi58GGr4pteQ/Dybteh?=
 =?us-ascii?Q?vWWfKlOvUUVLkMDa+h9bb+oGLK5cSKm5o/QXhMnophXmEEjdHISsiPknrZPl?=
 =?us-ascii?Q?GXhsnSTKZTnqHIXeOz/yo5b9DbtxhXn8Stmev+czez2SDbixxDfrhJO1NDEI?=
 =?us-ascii?Q?MtVAhenqK1o0lHfwsvxwrj0dsdeZzdtoCBvqIRRy6aFz1q7frnXi0ErENMTp?=
 =?us-ascii?Q?7VXJamnrFsC9elc230ejMu5pBtM3sFgocP9rKBiDvEYOHCYa6o90Q7ectXan?=
 =?us-ascii?Q?sivXx3mhMlj820iDEV+36SxBSgmPpanp2az3zXNMM3jfbyN8CpyoUA1dcJCX?=
 =?us-ascii?Q?+UKSKsaVliOLQOLaOTaBOZDBw+7OlNdgIbK2FcSkw8SSBvsY3K+WpaTVoAKp?=
 =?us-ascii?Q?142/FbznqqXmKbWqkVdmP7LkLpMCzvT4H5pZ0qym+JSB5sYViwI8OS95Zc0N?=
 =?us-ascii?Q?XdaGbNs9UMOPCaCWW9t+e25eOAbP0QEZCMm8ImT2UHKahTaAMz2RXGWATp9s?=
 =?us-ascii?Q?sa62pFky0j8CY5kwZI0Tp/VeQHTKlkMSwVj89BNvhGa5rWZq9kmGhml+DWOZ?=
 =?us-ascii?Q?+xJ7H1aoZ64ARQeJezveCNoS8c/DUYjCoTaBj8HsNlTwK9vnRptqj9cmX6pD?=
 =?us-ascii?Q?7zL5Pd7xNy034sYY7n8GhcTewUvncwekyY1+RXw1dja1AGl6vQox0+6gh+hg?=
 =?us-ascii?Q?nXoO8HvTM2oiXk+lQm7tIITrB/uM14ahD7ozid4ASD/YuEKEY+LcjxC78yww?=
 =?us-ascii?Q?6fb6/9/JZQiavL8FlpSxngcRlE1bgQVmtCDIF4g9egggtFQdqd2xWBk6A+45?=
 =?us-ascii?Q?YadJrZeMX009h0EHK+8l852pSCOFSq8Zq9adQcJAQPm9Htewb6RLrJMSo7RF?=
 =?us-ascii?Q?BL33BLPKXA+dBGZfU4H7mTLdf6/m8lqh/BAviZP5aD/hsSrcBs4wlUrHzucz?=
 =?us-ascii?Q?+9oB4TWnBM856qnoU2ZRmSFPdGnRg2aGxPNGxOJOhijrbivKvrALy+WRUwFA?=
 =?us-ascii?Q?ZzqJjRIzw4ndsiFnssFCoEItqM4P8Iszb4yL+RYXs2ygyd2gNBbzN/ZAMzsj?=
 =?us-ascii?Q?sKXtb3FS5XzJA/zGtWvDHrd0KdKOLSFN6unG99tJIB4/p6qPg/l74RWDGfeM?=
 =?us-ascii?Q?wv0Bp78FdsKbAR+KO70UH0sHXlz//DrIho5aCopyt2LiuApZVqXxBmqDm3k6?=
 =?us-ascii?Q?RA/EDXZpH+Kk7AlN/ufgW+/dm5YOmuiQRd1dJy7G2GSYIo+lhqUAf3Pa5uGi?=
 =?us-ascii?Q?8wlmN9TJAjt0RK5T6AF9roOpAz4tsonLYYM8Fkbsw5iC5S/9MZ4YbfXctSoU?=
 =?us-ascii?Q?1bs+lGlce6tBbqTpoD8pfaSUzdwupP1a8AbdQNc2hbHY6T+V/pvX59Xv1SbU?=
 =?us-ascii?Q?/5Jkaoq6trpHdEzonu/WBGcC8lVg0Z8DyF+faOJ9nHPsXC/yt4qjy4n93o6R?=
 =?us-ascii?Q?iRtAetKdKoFMmLVPKynB4SIzrliJTtHQdWPCB+RXsF88dUK2CrfQ2ZtI797S?=
 =?us-ascii?Q?H8sq0JkVyGDQbfkDf1H3+bzYrxYeyBl/ipGm5qCT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c8e24d-d372-4c69-6886-08da952b0048
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 01:55:14.7067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +DtgQYf+Xe57VxzKhXu/Uw0P5EKYJJ8RJey+WS1kDrHG9YMTo0CdMnk7CrYREI4MbvXZM1on10qHCYB4D5140Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6609
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-1.2 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We didn't close the open of how to get this merged in LPC due to the
audio issue. Then let's use mails.

Overall there are three options on the table:

1) Require vfio-compat to be 100% compatible with vfio-type1

   Probably not a good choice given the amount of work to fix the remaining
   gaps. And this will block support of new IOMMU features for a longer tim=
e.

2) Leave vfio-compat as what it is in this series

   Treat it as a vehicle to validate the iommufd logic instead of immediate=
ly
   replacing vfio-type1. Functionally most vfio applications can work w/o
   change if putting aside the difference on locked mm accounting, p2p, etc=
.

   Then work on new features and 100% vfio-type1 compat. in parallel.

3) Focus on iommufd native uAPI first

   Require vfio_device cdev and adoption in Qemu. Only for new vfio app.

   Then work on new features and vfio-compat in parallel.

I'm fine with either 2) or 3). Per a quick chat with Alex he prefers to 3).

Jason, how about your opinion?

Thanks
Kevin

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, September 3, 2022 3:59 AM
>=20
> iommufd is the user API to control the IOMMU subsystem as it relates to
> managing IO page tables that point at user space memory.
>=20
> It takes over from drivers/vfio/vfio_iommu_type1.c (aka the VFIO
> container) which is the VFIO specific interface for a similar idea.
>=20
> We see a broad need for extended features, some being highly IOMMU
> device
> specific:
>  - Binding iommu_domain's to PASID/SSID
>  - Userspace page tables, for ARM, x86 and S390
>  - Kernel bypass'd invalidation of user page tables
>  - Re-use of the KVM page table in the IOMMU
>  - Dirty page tracking in the IOMMU
>  - Runtime Increase/Decrease of IOPTE size
>  - PRI support with faults resolved in userspace
>=20
> As well as a need to access these features beyond just VFIO, from VDPA fo=
r
> instance. Other classes of accelerator HW are touching on these areas now
> too.
>=20
> The pre-v1 series proposed re-using the VFIO type 1 data structure,
> however it was suggested that if we are doing this big update then we
> should also come with an improved data structure that solves the
> limitations that VFIO type1 has. Notably this addresses:
>=20
>  - Multiple IOAS/'containers' and multiple domains inside a single FD
>=20
>  - Single-pin operation no matter how many domains and containers use
>    a page
>=20
>  - A fine grained locking scheme supporting user managed concurrency for
>    multi-threaded map/unmap
>=20
>  - A pre-registration mechanism to optimize vIOMMU use cases by
>    pre-pinning pages
>=20
>  - Extended ioctl API that can manage these new objects and exposes
>    domains directly to user space
>=20
>  - domains are sharable between subsystems, eg VFIO and VDPA
>=20
> The bulk of this code is a new data structure design to track how the
> IOVAs are mapped to PFNs.
>=20
> iommufd intends to be general and consumable by any driver that wants to
> DMA to userspace. From a driver perspective it can largely be dropped in
> in-place of iommu_attach_device() and provides a uniform full feature set
> to all consumers.
>=20
> As this is a larger project this series is the first step. This series
> provides the iommfd "generic interface" which is designed to be suitable
> for applications like DPDK and VMM flows that are not optimized to
> specific HW scenarios. It is close to being a drop in replacement for the
> existing VFIO type 1.
>=20
> Several follow-on series are being prepared:
>=20
> - Patches integrating with qemu in native mode:
>   https://github.com/yiliu1765/qemu/commits/qemu-iommufd-6.0-rc2
>=20
> - A completed integration with VFIO now exists that covers "emulated" mde=
v
>   use cases now, and can pass testing with qemu/etc in compatability mode=
:
>   https://github.com/jgunthorpe/linux/commits/vfio_iommufd
>=20
> - A draft providing system iommu dirty tracking on top of iommufd,
>   including iommu driver implementations:
>   https://github.com/jpemartins/linux/commits/x86-iommufd
>=20
>   This pairs with patches for providing a similar API to support VFIO-dev=
ice
>   tracking to give a complete vfio solution:
>   https://lore.kernel.org/kvm/20220901093853.60194-1-yishaih@nvidia.com/
>=20
> - Userspace page tables aka 'nested translation' for ARM and Intel iommu
>   drivers:
>   https://github.com/nicolinc/iommufd/commits/iommufd_nesting
>=20
> - "device centric" vfio series to expose the vfio_device FD directly as a
>   normal cdev, and provide an extended API allowing dynamically changing
>   the IOAS binding:
>   https://github.com/yiliu1765/iommufd/commits/iommufd-v6.0-rc2-
> nesting-0901
>=20
> - Drafts for PASID and PRI interfaces are included above as well
>=20
> Overall enough work is done now to show the merit of the new API design
> and at least draft solutions to many of the main problems.
>=20
> Several people have contributed directly to this work: Eric Auger, Joao
> Martins, Kevin Tian, Lu Baolu, Nicolin Chen, Yi L Liu. Many more have
> participated in the discussions that lead here, and provided ideas. Thank=
s
> to all!
>=20
> The v1 iommufd series has been used to guide a large amount of preparator=
y
> work that has now been merged. The general theme is to organize things in
> a way that makes injecting iommufd natural:
>=20
>  - VFIO live migration support with mlx5 and hisi_acc drivers.
>    These series need a dirty tracking solution to be really usable.
>    https://lore.kernel.org/kvm/20220224142024.147653-1-
> yishaih@nvidia.com/
>    https://lore.kernel.org/kvm/20220308184902.2242-1-
> shameerali.kolothum.thodi@huawei.com/
>=20
>  - Significantly rework the VFIO gvt mdev and remove struct
>    mdev_parent_ops
>    https://lore.kernel.org/lkml/20220411141403.86980-1-hch@lst.de/
>=20
>  - Rework how PCIe no-snoop blocking works
>    https://lore.kernel.org/kvm/0-v3-2cf356649677+a32-
> intel_no_snoop_jgg@nvidia.com/
>=20
>  - Consolidate dma ownership into the iommu core code
>    https://lore.kernel.org/linux-iommu/20220418005000.897664-1-
> baolu.lu@linux.intel.com/
>=20
>  - Make all vfio driver interfaces use struct vfio_device consistently
>    https://lore.kernel.org/kvm/0-v4-8045e76bf00b+13d-
> vfio_mdev_no_group_jgg@nvidia.com/
>=20
>  - Remove the vfio_group from the kvm/vfio interface
>    https://lore.kernel.org/kvm/0-v3-f7729924a7ea+25e33-
> vfio_kvm_no_group_jgg@nvidia.com/
>=20
>  - Simplify locking in vfio
>    https://lore.kernel.org/kvm/0-v2-d035a1842d81+1bf-
> vfio_group_locking_jgg@nvidia.com/
>=20
>  - Remove the vfio notifiter scheme that faces drivers
>    https://lore.kernel.org/kvm/0-v4-681e038e30fd+78-
> vfio_unmap_notif_jgg@nvidia.com/
>=20
>  - Improve the driver facing API for vfio pin/unpin pages to make the
>    presence of struct page clear
>    https://lore.kernel.org/kvm/20220723020256.30081-1-
> nicolinc@nvidia.com/
>=20
>  - Clean up in the Intel IOMMU driver
>    https://lore.kernel.org/linux-iommu/20220301020159.633356-1-
> baolu.lu@linux.intel.com/
>    https://lore.kernel.org/linux-iommu/20220510023407.2759143-1-
> baolu.lu@linux.intel.com/
>    https://lore.kernel.org/linux-iommu/20220514014322.2927339-1-
> baolu.lu@linux.intel.com/
>    https://lore.kernel.org/linux-iommu/20220706025524.2904370-1-
> baolu.lu@linux.intel.com/
>    https://lore.kernel.org/linux-iommu/20220702015610.2849494-1-
> baolu.lu@linux.intel.com/
>=20
>  - Rework s390 vfio drivers
>    https://lore.kernel.org/kvm/20220707135737.720765-1-
> farman@linux.ibm.com/
>=20
>  - Normalize vfio ioctl handling
>    https://lore.kernel.org/kvm/0-v2-0f9e632d54fb+d6-
> vfio_ioctl_split_jgg@nvidia.com/
>=20
> This is about 168 patches applied since March, thank you to everyone
> involved in all this work!
>=20
> Currently there are a number of supporting series still in progress:
>  - Simplify and consolidate iommu_domain/device compatability checking
>    https://lore.kernel.org/linux-iommu/20220815181437.28127-1-
> nicolinc@nvidia.com/
>=20
>  - Align iommu SVA support with the domain-centric model
>    https://lore.kernel.org/linux-iommu/20220826121141.50743-1-
> baolu.lu@linux.intel.com/
>=20
>  - VFIO API for dirty tracking (aka dma logging) managed inside a PCI
>    device, with mlx5 implementation
>    https://lore.kernel.org/kvm/20220901093853.60194-1-yishaih@nvidia.com
>=20
>  - Introduce a struct device sysfs presence for struct vfio_device
>    https://lore.kernel.org/kvm/20220901143747.32858-1-
> kevin.tian@intel.com/
>=20
>  - Complete restructuring the vfio mdev model
>    https://lore.kernel.org/kvm/20220822062208.152745-1-hch@lst.de/
>=20
>  - DMABUF exporter support for VFIO to allow PCI P2P with VFIO
>    https://lore.kernel.org/r/0-v2-472615b3877e+28f7-
> vfio_dma_buf_jgg@nvidia.com
>=20
>  - Isolate VFIO container code in preperation for iommufd to provide an
>    alternative implementation of it all
>    https://lore.kernel.org/kvm/0-v1-a805b607f1fb+17b-
> vfio_container_split_jgg@nvidia.com
>=20
>  - Start to provide iommu_domain ops for power
>    https://lore.kernel.org/all/20220714081822.3717693-1-aik@ozlabs.ru/
>=20
> Right now there is no more preperatory work sketched out, so this is the
> last of it.
>=20
> This series remains RFC as there are still several important FIXME's to
> deal with first, but things are on track for non-RFC in the near future.
>=20
> This is on github: https://github.com/jgunthorpe/linux/commits/iommufd
>=20
> v2:
>  - Rebase to v6.0-rc3
>  - Improve comments
>  - Change to an iterative destruction approach to avoid cycles
>  - Near rewrite of the vfio facing implementation, supported by a complet=
e
>    implementation on the vfio side
>  - New IOMMU_IOAS_ALLOW_IOVAS API as discussed. Allows userspace to
>    assert that ranges of IOVA must always be mappable. To be used by a
> VMM
>    that has promised a guest a certain availability of IOVA. May help
>    guide PPC's multi-window implementation.
>  - Rework how unmap_iova works, user can unmap the whole ioas now
>  - The no-snoop / wbinvd support is implemented
>  - Bug fixes
>  - Test suite improvements
>  - Lots of smaller changes (the interdiff is 3k lines)
> v1: https://lore.kernel.org/r/0-v1-e79cd8d168e8+6-
> iommufd_jgg@nvidia.com
>=20
> # S390 in-kernel page table walker
> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
> Cc: Matthew Rosato <mjrosato@linux.ibm.com>
> # AMD Dirty page tracking
> Cc: Joao Martins <joao.m.martins@oracle.com>
> # ARM SMMU Dirty page tracking
> Cc: Keqian Zhu <zhukeqian1@huawei.com>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> # ARM SMMU nesting
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> # Map/unmap performance
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> # VDPA
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> # Power
> Cc: David Gibson <david@gibson.dropbear.id.au>
> # vfio
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> # iommu
> Cc: iommu@lists.linux.dev
> # Collaborators
> Cc: "Chaitanya Kulkarni" <chaitanyak@nvidia.com>
> Cc: Nicolin Chen <nicolinc@nvidia.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Yi Liu <yi.l.liu@intel.com>
> # s390
> Cc: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Jason Gunthorpe (12):
>   interval-tree: Add a utility to iterate over spans in an interval tree
>   iommufd: File descriptor, context, kconfig and makefiles
>   kernel/user: Allow user::locked_vm to be usable for iommufd
>   iommufd: PFN handling for iopt_pages
>   iommufd: Algorithms for PFN storage
>   iommufd: Data structure to provide IOVA to PFN mapping
>   iommufd: IOCTLs for the io_pagetable
>   iommufd: Add a HW pagetable object
>   iommufd: Add kAPI toward external drivers for physical devices
>   iommufd: Add kAPI toward external drivers for kernel access
>   iommufd: vfio container FD ioctl compatibility
>   iommufd: Add a selftest
>=20
> Kevin Tian (1):
>   iommufd: Overview documentation
>=20
>  .clang-format                                 |    1 +
>  Documentation/userspace-api/index.rst         |    1 +
>  .../userspace-api/ioctl/ioctl-number.rst      |    1 +
>  Documentation/userspace-api/iommufd.rst       |  224 +++
>  MAINTAINERS                                   |   10 +
>  drivers/iommu/Kconfig                         |    1 +
>  drivers/iommu/Makefile                        |    2 +-
>  drivers/iommu/iommufd/Kconfig                 |   22 +
>  drivers/iommu/iommufd/Makefile                |   13 +
>  drivers/iommu/iommufd/device.c                |  580 +++++++
>  drivers/iommu/iommufd/hw_pagetable.c          |   68 +
>  drivers/iommu/iommufd/io_pagetable.c          |  984 ++++++++++++
>  drivers/iommu/iommufd/io_pagetable.h          |  186 +++
>  drivers/iommu/iommufd/ioas.c                  |  338 ++++
>  drivers/iommu/iommufd/iommufd_private.h       |  266 ++++
>  drivers/iommu/iommufd/iommufd_test.h          |   74 +
>  drivers/iommu/iommufd/main.c                  |  392 +++++
>  drivers/iommu/iommufd/pages.c                 | 1301 +++++++++++++++
>  drivers/iommu/iommufd/selftest.c              |  626 ++++++++
>  drivers/iommu/iommufd/vfio_compat.c           |  423 +++++
>  include/linux/interval_tree.h                 |   47 +
>  include/linux/iommufd.h                       |  101 ++
>  include/linux/sched/user.h                    |    2 +-
>  include/uapi/linux/iommufd.h                  |  279 ++++
>  kernel/user.c                                 |    1 +
>  lib/interval_tree.c                           |   98 ++
>  tools/testing/selftests/Makefile              |    1 +
>  tools/testing/selftests/iommu/.gitignore      |    2 +
>  tools/testing/selftests/iommu/Makefile        |   11 +
>  tools/testing/selftests/iommu/config          |    2 +
>  tools/testing/selftests/iommu/iommufd.c       | 1396 +++++++++++++++++
>  31 files changed, 7451 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/userspace-api/iommufd.rst
>  create mode 100644 drivers/iommu/iommufd/Kconfig
>  create mode 100644 drivers/iommu/iommufd/Makefile
>  create mode 100644 drivers/iommu/iommufd/device.c
>  create mode 100644 drivers/iommu/iommufd/hw_pagetable.c
>  create mode 100644 drivers/iommu/iommufd/io_pagetable.c
>  create mode 100644 drivers/iommu/iommufd/io_pagetable.h
>  create mode 100644 drivers/iommu/iommufd/ioas.c
>  create mode 100644 drivers/iommu/iommufd/iommufd_private.h
>  create mode 100644 drivers/iommu/iommufd/iommufd_test.h
>  create mode 100644 drivers/iommu/iommufd/main.c
>  create mode 100644 drivers/iommu/iommufd/pages.c
>  create mode 100644 drivers/iommu/iommufd/selftest.c
>  create mode 100644 drivers/iommu/iommufd/vfio_compat.c
>  create mode 100644 include/linux/iommufd.h
>  create mode 100644 include/uapi/linux/iommufd.h
>  create mode 100644 tools/testing/selftests/iommu/.gitignore
>  create mode 100644 tools/testing/selftests/iommu/Makefile
>  create mode 100644 tools/testing/selftests/iommu/config
>  create mode 100644 tools/testing/selftests/iommu/iommufd.c
>=20
>=20
> base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
> --
> 2.37.3


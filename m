Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B576BDE05
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCQBQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCQBQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:16:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F216F5B432;
        Thu, 16 Mar 2023 18:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679015770; x=1710551770;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I0TcKusuzVH8lzqVxUA7OYI6oS/KrScmlSoYjB3NpP4=;
  b=n5a31VSCm21kdWsaChTw4H5rw1i0sCnYqgMte8XcJfuex3qP41EabUro
   u4gepsLb2qtERkB8ZSo2FQ74auCsTurA/Gnm2uYojp6VUPN6388+7gzkd
   G6K37TDTEIx8qw5hzMjIBiPZpUJoxPuwNlkweiY7d+dWnTJC5Ad/Z4dbB
   sV9Wcz8s+FK7x089Cg2CdglVe6vLlwVxC7v2stv9gzCiT9Jk2I7+WbqYJ
   Y8NhEtN3ZJZPbdelg0Vmydk3nyC3/yT6UTUWRBSUugVExXkD+ACAaa/Tb
   He8Ff4mB3sh2dZ3d7ehdE669v/RK2NuxQxYRG/GzOcA1/Czx/XSvxEYpH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="318547984"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="318547984"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 18:16:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="657386806"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="657386806"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 16 Mar 2023 18:16:10 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:16:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 18:16:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 18:16:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTTMORjmfO0fk1SoQndJ6sjsEr5OBSWqX1Hnl6z0UFtmxSQqxK4x7X/v1yj8MPkGFO97e5qPLTD49meXF7e9gghSGgr+yNBrBqr+ANx+uIZZZvDBTx/aLvomsjADaf1sJNfF6VwmncIQllrMAvHpDLwm+3RKQd1OaJyQVkXWYKOTeYXErg64L+8/hOo/LbxYSBTQzVdMdBn5kkchlbBz0FPdg86Pq8UA1fiVlPppKJ/Qej99UEVYC3hPaen1UT/GfZeP0icsfMBM5y24sdgRqMJ/EFKNcsGh++4MgWny2gL/0SpLgZj1elubL+64H8UeBH/DGG+FsAA0PpFtz2qL1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RiQ0MHTykHPyMhZoehf/vmtBc4Z9R7UPSDMcpVjkhXA=;
 b=go5RTg4Gxj/O9AmXDAwow5PH9Uy1USfqAa8BMHuE2/FP2enFYkZe/uA1UPWYXIV1TvT2HSEx6qD0LDzKBHCvKvM/eH1SBHZYGB59ZFl5cYNnhSZshlOTV9qhcNkvri3ab6zXYRAhn7Z7PlYC2o/m5NqFhBUQRPMX/N8uQRdvRL8Axc/kEo3GYMUjTSCNyhQUODjtcXJ5lqAFLLnw0tH3dnWo0NKVzCeUDmIYMZRp1RwYAvVX28X3+0MXtPQPSVk4l4aepJhUIOIJ8LSrb0B/eyceDk0fWNApLcYzZ9d9xcd/qWYWahf4UjYjPOEHkpw7B4kRBZ6aqYQSGYtHE1pA2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6242.namprd11.prod.outlook.com (2603:10b6:208:3e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Fri, 17 Mar
 2023 01:16:08 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 01:16:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH 4/7] vfio/pci: Renaming for accepting device fd in hot
 reset path
Thread-Topic: [PATCH 4/7] vfio/pci: Renaming for accepting device fd in hot
 reset path
Thread-Index: AQHZWATByN1YLVDj9UqyIVvzvbooI67+K9cQ
Date:   Fri, 17 Mar 2023 01:16:07 +0000
Message-ID: <BN9PR11MB5276EE06B0EEDC458B26AA038CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
 <20230316124156.12064-5-yi.l.liu@intel.com>
In-Reply-To: <20230316124156.12064-5-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6242:EE_
x-ms-office365-filtering-correlation-id: f1600ce9-749d-4923-a3fe-08db26852fd1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +CbCtKBobcqomF6u0xApfw1eb/Vjvut+qprTdYFZbxtJzvaBRzBVEOjnje+/B3yiNNXhg85kjBbtviaQwqAP1aEaAlYAxcRV6ZRY5DcvEZq0yVbpeHrNhl0wpJk3R3sqW27npozF/xg7E604tBi2X8Ou2sb4IFub5NRI/P+pEqEsuajmFJDKWsfpXkj1ahSNkysMpn5sbMnqUSCXFf+NSLNO/36P1JCTVkx89DxwWA8lILQgIFl64fIXl/5i+nORVJKY7ctBZh7NdIh5RIW1Es9l/g+wTzoqs2upOvX1SWFXtq1gv3kfCaLPMVnq7Nq0r8KHxRLrnCIcveddSbXK6aK3vrKCxp8FU4UDBltnNpgbWk+fWM1X/Zc0xrV70plI2JLcd3HOAcpxiQxH0o45UMgxogJ1ldlYvJdI6lCZ6pXTfr88VOAqPU6PY1gvuUuSl6qYfbw+mwAT0BRvrah/iubEdN515NkwRhgwoY9iJkOo5AGk1ILV4LMRSpUVDAddw+H74+NgAdkE1M6i6dRJm+U1w++HabGQATSE2xKppHRUHfwol1DrYGun69j5CWTfeYcl5dzoTbhwtUrACUHWvP4EFlUYvGHvY3y9XBvhr1jieyLuFeXLc2SmWTOp8uLPWWVYVhIZre0/snCRTJ04GFWRPodiyRBnipBKL4svm2SnDS9gEMUoe+s6aN7WdR2YjyCrGOzPWEm8J9za9+kenA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199018)(54906003)(9686003)(8936002)(55016003)(52536014)(186003)(316002)(110136005)(82960400001)(7696005)(122000001)(38070700005)(38100700002)(71200400001)(2906002)(5660300002)(33656002)(478600001)(7416002)(66476007)(66446008)(64756008)(66556008)(76116006)(66946007)(4326008)(8676002)(86362001)(4744005)(41300700001)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fCDKy1wqsV6ic5CZZWFKWQHDGhljDZgYXrwkRRIkjXlcGxdgKC8AOkq9lei2?=
 =?us-ascii?Q?2f+dZ7ssocKeQeigrhY5my5RoZ7Rh2lSIeinNnYmt7sQxjFw19Y366dIPu40?=
 =?us-ascii?Q?fAsILEgS66Sx6vPZw9U4sgm2uRprC/NkHWWh+6MpInqmDVG+hX+UxDHs+G/L?=
 =?us-ascii?Q?p/Lc7Ft9RWwKA6ei1a/I8ftZzfm8DTZS59S1bbQtZMirsZyngM8bZ46csu8I?=
 =?us-ascii?Q?9PcuxgV4q/aYrWo69AVo7XdkSigerk1WGUsxLz0ycryKK0w9fhS5NmKqLN5n?=
 =?us-ascii?Q?w9O37JWPXc+Rg+5CRQuBMgYV5E3u6rL9VNrSSL0lI1/2p/XO/6Ho7mGZAGZS?=
 =?us-ascii?Q?75tAWwoaMMd6+J/cXdbEm3hpBxBN52rI6q/toZsz2xyLv/0fz2KoHFKzDmbE?=
 =?us-ascii?Q?rFRNhAKCJuhG+heyIiN/HYgRFcGe/I339hO6wTY/h2Prz7Ly4u6guj5QUqAM?=
 =?us-ascii?Q?7B4Ha2wjTTMZwl8FlW3zZ5ZBGNQdjOwODl/t2wL/LRoGg9iYXO0tHlmpJymv?=
 =?us-ascii?Q?X+geLFgQIFluFJ1r6KyLMsrkkisfLchXTacK7yLB8HaNcGXBAe/1uzmPnaGW?=
 =?us-ascii?Q?ZkpSrKczr2R3Zv6vTcfHXjsMSmdMh+iQc6C5Os7E5QyMEAnjEIegi3/Mwpt8?=
 =?us-ascii?Q?+xGgrfSm6tvSuy6PIcvLjWIsOeYasgC4UCjfKVdiX3L7AZjuJOb0J07H1Skv?=
 =?us-ascii?Q?4LLxthItVM9QpCwqarSS5ntGch3yNvAkjeB/xqRKYLrWO94IftKGwnsW6Bys?=
 =?us-ascii?Q?IR+Jw8qUEr09yUGA3F4UGwHURK1d4sBCwTYaH8krYPFPVTyW5lsQhyzAVVhq?=
 =?us-ascii?Q?8o3Nykx63a715Bx7CcvCTGD6K3MU8rJyt9caKoFkrSlPuEtxXEay7klH9wun?=
 =?us-ascii?Q?UBXxXXC3zZVoyF/ZDFrud4YR3IJpX3wtI3imjxAdRLIXuUxKK73DPPFMWGJ+?=
 =?us-ascii?Q?7XAgxEvvA7/LbOCKE+3aczRnYRq7DVf9vbrTLNI3re+uD4cR8tQKg/2JMFRI?=
 =?us-ascii?Q?3H5i4x3/ptUkNFuruN9ZbqvpEf4lZYz6znXWnGcyGFfXVz2nH3cEEGkcZELZ?=
 =?us-ascii?Q?4ENamvYAOI84tfcxaRXuRGxXJxQIPPEOs/p/hj40GhFStscaHRzjOhYmQ7gf?=
 =?us-ascii?Q?ujf6YGlN0DT1Uc2Qr6lYOIfVKKQT6XRPAEcUl57W5dAZ/F1gPcrqe1fBrWYx?=
 =?us-ascii?Q?PYmEGv4XKZyvwUtOqnfx2ztOI1bvMWbGgc/wc6DdhRxYHwOkjuJexk+tGc4t?=
 =?us-ascii?Q?Y+g14R9jCDQMUFL/QGCeuIem+7QWs3xeLpkqD1pCz0zhbLn1Zii+PieZ08el?=
 =?us-ascii?Q?MDWxRw1ZNz10g6k0LtUhc1J+nDshiwUoQa/OVdOyoxPl9nHfuSqZe2FfRm1R?=
 =?us-ascii?Q?o1w+LsJtfKuEue8nBfgQYVplc5cdIgUFHaumWf74eS5pqaBUBtaDyI35L0om?=
 =?us-ascii?Q?TyMChOjWEVT40hBe9VY2D7jorrLr92x5CP9i9X9LF3Yoz8NWo5m/Dea+O3P+?=
 =?us-ascii?Q?SHzD7rIRXhdVb8czck1TuFCaz28q98Q4xiCE5GE6JHrZbceJaGk3M8661Li3?=
 =?us-ascii?Q?5Es+ftP2meXjOahsZ2wntc/bWqMFi6fEeo7yBekP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1600ce9-749d-4923-a3fe-08db26852fd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 01:16:07.7362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IhJyL4BaScVJv4rVnCwbYQbehfDYS3SfQ3rqU/EdSooi/G02FEuj6X+z866rPwMT8EI9N1+brmRN862rB6oRsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6242
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:42 PM
> @@ -2469,7 +2469,8 @@ static int vfio_pci_dev_set_hot_reset(struct
> vfio_device_set *dev_set,
>  		 * cannot race being opened by another user simultaneously.
>  		 *
>  		 * Otherwise all opened devices in the dev_set must be
> -		 * contained by the set of groups provided by the user.
> +		 * contained by the set of groups/devices provided by
> +		 * the user.

just a nit. You may want to add "devices" in the last patch.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

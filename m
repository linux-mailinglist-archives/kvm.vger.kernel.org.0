Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A256F11C8
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 08:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjD1Gd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 02:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjD1GdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 02:33:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0573C35BD;
        Thu, 27 Apr 2023 23:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682663604; x=1714199604;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nkdeK0Cp8M/1Mh8T3WgO5wDj2/l4bul3hQtladOu5UE=;
  b=MYmeq5LX9bSTfApzvmcCTB6qZwyuIitNTxZ1Uilmhn8x5vcoSbx0VFCi
   f65yBUr3bjhefDp105aOqlxWIAMHPGxjI68wB8laFFmPWZcTDTF75WW5T
   nXjsoj/lJsYrHsAnIV1daSMVN1n2NdYLvIaLbqY4ypCkTFm9j7ib5V7Gv
   QWLpE9mMBUzcxWCWcoVBohMS/ikSGpinjk1KptgD3saJky16+A68X0Ch2
   SV3P6NuOFTU9kMCqN8uoKrjnlVL5yb0McsMppvdgPVlvvZv6Ay6jihvb6
   dma4eJI9FsD2TcB7hYYM3F4hLwKGv7ZqMViswhqJ855hqcw0LwRdp7FAi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="349687451"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="349687451"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:33:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="725246771"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="725246771"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 27 Apr 2023 23:33:23 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:33:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 23:33:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 23:33:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWMe3nRqhlQauS/T8gagb5dU/a+POoZ+7mUBBeEShxEsSc5n2jKXJAi5ufRg5Wl2A77UtW2TF/r6P9Ug9hmu9SUmsyrdwOc7gqN1k43/7x3tLgXQIyH1dQcshIo8H9g+3uYJhmyLzAU7Wb0hEhXG9THyVxeOGjFKR58+Kv1B2YliRaY7sorYFNn+3KZnM9LQ1wTr0yFNLvdtZyLKRcPDDqXFyqmnNvnxJQM3d57Wd1qMl6uMA7WTyqX6f8Obuxnvn/sbeR0qZZ1uFT6h74wXMtyMLi/xy7TVaFuCeV2A8lT72+WgXkd35Jg4xz8uVOIUNhsSREskInIAVOrbJLg0wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=juHFHf7kqmIi/eHs2Y1nVBc0+1jizmr+wTT/wa2jV20=;
 b=fBGDtVlIMWjGw7rnNz8PRxKvgHTmTa92LCv7aUYceU2GTqdiDmWok7Hs+vk7t3ISFNGiJ963Wm5QlGIlIqaS+hWXueRAQTTs5BKosISD7WCSpCEjnccXxGyMZvvwlZUFJaVsvLmtBuvPVgo/beUrzce6uAVKFlYkYoZGAEl3A/dVeFLwclH+mzNy7I5evtRFJqimRRgAuAInGUY5Ca8GQxZpFZ/ALldlCc7ZfE8Huia12+OzjYCMgVFfRbh8akTneN2v+9UpJyUCuNvj06ygY6IlDI9fYN3ZMbYM/K9Lq3giUSg3eeO3BhBc0bdOPUnJ/bixzBooPesqREuN2s1MHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5581.namprd11.prod.outlook.com (2603:10b6:a03:305::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23; Fri, 28 Apr
 2023 06:33:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 06:33:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 03/11] vfio/pci: Prepare for dynamic interrupt context
 storage
Thread-Topic: [PATCH V4 03/11] vfio/pci: Prepare for dynamic interrupt context
 storage
Thread-Index: AQHZeS7LM0WEo3lFJUe4AxtjXzq3+a9AQzGw
Date:   Fri, 28 Apr 2023 06:33:15 +0000
Message-ID: <BN9PR11MB5276242E8D9F4C082E6D2CB68C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <6fcd4019e22931a97d962b6e657e74d6fd1049ba.1682615447.git.reinette.chatre@intel.com>
In-Reply-To: <6fcd4019e22931a97d962b6e657e74d6fd1049ba.1682615447.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5581:EE_
x-ms-office365-filtering-correlation-id: ef2388bf-3cf0-495f-9d6b-08db47b2725e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dqYUWz4f3PGj7KGu5Zy2pmDTlEXG6Saxmjf/ay2HG/dzZHFQRu/6lLRLqELxnZ8qYari/MQN+qoce8OTyV7/6+TIoLe4fpXsL/QgjQESZFzrkVcVK56DIs7CF0c5x4bQGPjcRggAHUAIsPLZg9oEjOW/i/Swq5vMxSsG398vVr97THxORoLqATzKCEly4uV6+k6XAP2vSq6ASN8SV/WJEHb8Jjh+28Ezl4z2HVr0HuUVe63Vw+NFrD3IpqC+RGYcLonPj/v3HFLqCcsS9jCm7OdpV9qKzRlJbkIuuDkGkTinStq3ZtFWWx3Pj3iLEJDDPQfjuRTayUnwL+NY6oJxkJ+DQ8TFTyslw+2zc+bbRIhuFmKgS3m0mggcKDsUpltngWqvwOhoCpxdZHfMdDP9+b+UCFpLrQn9bSOvCUifQ20Hw29wwGdqE13XRTNbksf3l7X03Is/UQ7LEyXq4nuRXAOQjGF+w+oFRvbWxH9og3DgVITk2psfsaw0GcdFWnm8ycjVtzkWMRpel5CGf9/QeyPGnKA5V48dByauHBhOveHKZZdlfsWQdzX/hD+qnl0RmbesPOCOxbUUEkNhYfyA1WSt2C5J96zhAO0tyA+LyOrodX6Os0Sc/tk5+vDCmj/Z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199021)(76116006)(66446008)(66946007)(66556008)(66476007)(38070700005)(8936002)(8676002)(316002)(38100700002)(64756008)(41300700001)(33656002)(186003)(4326008)(2906002)(4744005)(110136005)(54906003)(5660300002)(82960400001)(122000001)(83380400001)(52536014)(478600001)(86362001)(7696005)(55016003)(71200400001)(6506007)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sqtD+XnrhJJCp7imzWwIdCeYg01x1wOWLNob17Oq3No0Ma/7IHcJa/wXo+Em?=
 =?us-ascii?Q?SWt6NuxSgOha/+nSAb0wavENbhrd50EDBeX1J5uVZx9J04b1ytDSGlDhwou6?=
 =?us-ascii?Q?Vtvy+wI6MPg5mcjWGiKfm6it6SRqFUBU4aGHuG7GojXfPjOH7cmKTqBos7MU?=
 =?us-ascii?Q?Th0TfzoZT7P5RalzPe4dKF+srRF3mgd4QzHhtLIDMYsiWX7++1Vei9LHAiaH?=
 =?us-ascii?Q?rTge6JowJa/FR2KE56kDE5nITwDM+sNPArmdk2MuZxzM+SVbMeWv04mS+BRO?=
 =?us-ascii?Q?NjjtqYSA4P7/wQODF8Q/Qs5wlIzl5qZaEi9Oer4Ha1Llj3HKwu2vk27sDAp2?=
 =?us-ascii?Q?6WQ+JF+/mDvS9nSdjhwYKYQtEz+eBnOZ67ax9Il04Win1vqHnf0hSXOqHV74?=
 =?us-ascii?Q?8iIZ2oAenee/CxHoRsoKFs/SJmX3AADb2KTkq8QbzRY8/bdp+XECJf8i6/75?=
 =?us-ascii?Q?/UHW2l8aYIXY4onHOvJmei5qPQgCeX2KSmhnMFLhsqGrmfH2T7zC0wRXrIrD?=
 =?us-ascii?Q?c6Vrg028sWxv0OetA4hT22OkWNpSdQccTv2Kz+FAHizHl3Q86CP1/2gZw9Cz?=
 =?us-ascii?Q?CzJN9ox6y9RCO4E9StCUh3yPxMfhi5oMW68QodFszhMTbCH9IrI7zM/aNpf4?=
 =?us-ascii?Q?lKEQxryvHqo9sDy4heRFnIXTru9ZsMZC36INihbAIc58fF22fRkzYOMQErl3?=
 =?us-ascii?Q?NDhZ9hDBPxCyXqVTpE633QgojtqrsseeH+sgapzuehJK4KabtibMt/zCXfHI?=
 =?us-ascii?Q?E38taqFrEW6MmWEGZm1eXB4oIopUoa0h/CwvHyaRuzrW+9UZg/Rn6anDErwR?=
 =?us-ascii?Q?qPGC+SxpnNy7hKe77vRggIadoIiGdQwyAYNXzTZaC1qOTvP45WSf6jFmVjVL?=
 =?us-ascii?Q?tf/LNAyGod6XXBuMiSnEw9Ju/SD2qA+AU/9jyL0JHIywKcRYIxhChyMFgx8P?=
 =?us-ascii?Q?lKfvZHnLu4HE6Dws7IR9EdplVSl2xIAZZfke253nGrC/CvcMLWVh5kvVva+p?=
 =?us-ascii?Q?JFI0NJyKKNLB2zPvBozJ7FlO1ZtQZ9JmQOf4icHWEWwGzU9p5sEQHhFHST6u?=
 =?us-ascii?Q?ZcdYiJDrlhCB8x1Qgl9ClJtLn3WtqmMGpCGMj/KhbCQUATahHxSbJvnKjxIi?=
 =?us-ascii?Q?jIPYscdQQpSpvdoDQoFCaZRy32tQdgOKiMtDwCjNZiRvO1BdQjtkuWnFEEGE?=
 =?us-ascii?Q?KWu1UEaINsrLBZUJhwoKTh7dnhhHpP7mU/5J3nBBNuiz4mfmOu1LI+ruUNwE?=
 =?us-ascii?Q?UVhCuUAA9s7xq15ECzx1FLzBAjd1gMWuFf2/7MjnwQ2rikW5VC6VOaYzPOoV?=
 =?us-ascii?Q?zVvDcvA9eH0OCPIBL2LR52jz57wHVi8EQMkRRC5t0Ce2kmehOnsd6iuPw5m9?=
 =?us-ascii?Q?SbkiFd+3xYB1drszxzVeK5QY7smjdpuH3KFKffuZJgD8gv9TtL4+tdXbJGNi?=
 =?us-ascii?Q?tg1hLKR9wJS9ywpnkYg7PFG5dHkjKeHJ6UvXT2D+RNx+/H7p9YW4DldQLGNG?=
 =?us-ascii?Q?DpSFybta+yteSGOcwQNZOUnoftvvAGYiu4oDJYaabP0EF2CVH4D8VvKWrdJU?=
 =?us-ascii?Q?PZ6nYYBVYeUnSh3DwYAkLWEMkjcthMiz57F8rB7/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef2388bf-3cf0-495f-9d6b-08db47b2725e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 06:33:15.1102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wlcsMHHFRcgarak9XNsKjx4ymadOXIltFSIvHlZ19oJ0zsoX6eiSqK4d0AnzIzRBYmC5nAZ2xLTptsf6Zxc9AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5581
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chatre, Reinette <reinette.chatre@intel.com>
> Sent: Friday, April 28, 2023 1:36 AM
>
> @@ -55,17 +80,28 @@ static void vfio_send_intx_eventfd(void *opaque,
> void *unused)
>  {
>  	struct vfio_pci_core_device *vdev =3D opaque;
>=20
> -	if (likely(is_intx(vdev) && !vdev->virq_disabled))
> -		eventfd_signal(vdev->ctx[0].trigger, 1);
> +	if (likely(is_intx(vdev) && !vdev->virq_disabled)) {
> +		struct vfio_pci_irq_ctx *ctx;
> +
> +		ctx =3D vfio_irq_ctx_get(vdev, 0);
> +		if (!ctx)
> +			return;

if this error happens it implies a kernel bug since the same check
has been done in vfio_intx_enable(). Then should be a WARN_ON().

ditto for other intx functions which can be called only after intx
is enabled.

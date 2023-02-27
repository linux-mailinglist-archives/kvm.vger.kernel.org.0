Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9A06A406F
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 12:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjB0LQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 06:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjB0LQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 06:16:33 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232981DB87
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 03:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677496591; x=1709032591;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0lrqXsXp663cZzMH3gOKF766bM+A06OsVaqX0Gg4z/o=;
  b=ncdVlVj+qlH6X2Zpcnu4wjYQorIw0mimMKUrRCzrAjoWsJmOsueOrkVN
   scyP7yKMALyDVqCh6o5oFrcrPZWyCD9dI9ZedrTaZ5HyiJsJOKfcb+Yt+
   IYnnvLFWRSefLEytBVm5BbNdQPSoVrB/Fj8/t2IJi9poaj76FcezgFRU4
   8GAhtKsc/1yWVsW61zDJqn46sEG3lzioedm57et6NXnYVxRZ0XFaB8SpB
   8a8jpw4hGa9I6e5f5RDzxBOEF3/BCA3qrLm3+YpX4bNElPioTW9LMGGqJ
   IJsb2Qj4b1+K+g/cXQT4i9YzNV9XjxTY2/Sn692wJycB2Ro2egEg3IHO6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="333877056"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="333877056"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 03:16:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="816601710"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="816601710"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 27 Feb 2023 03:16:30 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 03:16:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 03:16:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 03:16:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6V1CQC0ZHRWfgxONCR1jcmoB2Hw7pBHBO91cq9Z27Cgq2qvQevmgiQP4yY7+9DWwvbCR9ShECWvnBoM8Y6K3fSz+8b9f4/T/WPU8aJE7jdstsB7S8y4abpHLH86lxVU9vV5NWvQlblV955UNIEYAUnMj1jICssdQJJhp3+3eE3GO+bOJKQZS4Tom7D78R2QVThzGoWbEpEMkN/uWZOHpZDDw3in6jUEHgkUsRFnY8LFENJWDg0kxO1Z3RyUPB0rUCLTTthNgUc1SOQWYXBK1op/iYu93S95rwNoqNSs7M7UsLRymy4NklUT18gGB+jyiKcPVcykStUyy+csiIBdfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StHcmhdd+fyH9FNaB3HfZmxua0uczLcdS5ZFrC+3i8I=;
 b=P7tfCLTgImY7cJ30rksIsAngehouYhq0RV1t0FZY05fMrTVsd+AUtrTV3Ql0C0X/y9TbbnKVwp118vfNku3Ue+4g9wnQxOlbYH3Gni5m62mQPMysKwaEX4CuKHNN7xVtR+jnU1NK6hJ34p6o6VUpx9LwZWpa5+lN8cGqmR4UYwDDjbecqaUse3yglTUUtBd5rd8NHPg/E3rer3ZLzCq5gmYQtYLRE3W7WXn4E18yxleIrek+OMIAZP9HIZaf8Ju0FNMimQFLrMRlBSwjJMzKxTDDM5h7llTh98KxljW3Q5wxmFVuEU8+kqA80+gL5OynCSLjQqSvyOFs2v8DWJ3mYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB6542.namprd11.prod.outlook.com (2603:10b6:8:d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 11:16:22 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 11:16:22 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Dan Carpenter <error27@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [bug report] KVM: Don't null dereference ops->destroy
Thread-Topic: [bug report] KVM: Don't null dereference ops->destroy
Thread-Index: AQHZSpsu+aiUoKzWcUiWOjoJhoDsWq7io/dQ
Date:   Mon, 27 Feb 2023 11:16:22 +0000
Message-ID: <DS0PR11MB75298965FD56152E49897FD6C3AF9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <Y/yNsYDY9/7v14vG@kili>
In-Reply-To: <Y/yNsYDY9/7v14vG@kili>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB6542:EE_
x-ms-office365-filtering-correlation-id: 198f8c19-8bcf-4ec6-8e30-08db18b40ead
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2YU1AlwJeqWNCSpD3+F8dWWe2vVwhfEs1Yhjs50GVmVoFIvCHjVgr1X2yNZ8Yp9lYrj8/voVrmEmgMoXaRn5McoxKQnpUOBgw8L3UMlmpwmytRCL+3WKOE3iwJ9uZU7cyBTdXa1lgWFZloPmstN4zCXR3VqDLfbDtyNP8uhBUS0NZWbmRLIcKrJwC1xff7DErx0CYMinVjjU5D9aieBdz5c5kw80bWgOSAzpFX9lm5cOmCnPLWhUSO0dBSJGJopRSagXCO3RBJ0MjsrzHsY5eQthB4f0a9f4L3oa3RFtqucAnXa3aOgmArjffykdf6UKUzCfxg8tMKmC8Bt1txnzu0YedUVnT27+okqfgrvQwZPmg17E015JxnawLi/XMq/aIOlAz+UKE75ZjX9zpbSNz0NConbnE9Ii0Ga84Fjq1u2Uj031a0XjKY3DO04lcT7sEv0BbAyz5JUgLpoM3vF+HtSmBgsP1dEB/9QBdzvYwUDB9oHDknf0swC5x3iZM++th1OaagjozE8yPx1CozAH6MGxS3RAXVRkutYHt+abP0xK44JA5tg4UZwIdm/vlVh5BDj0fgbHQyhoQTKYCTr58zbZGIu9kbHyKxXOfZIY7Wg/WZ+73g4F9VXtQIl2KU3JqLWZqhT0Wucs5b3bpqM6IG0ds5RaMObW0K4WWEmT7apx9HQAlfM9mY+w8FJitxn6YABVAiq0v7DTGgLgJD4kvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199018)(83380400001)(316002)(110136005)(33656002)(4326008)(122000001)(82960400001)(8676002)(64756008)(66446008)(55016003)(38100700002)(6506007)(478600001)(26005)(66476007)(9686003)(186003)(7696005)(71200400001)(5660300002)(66946007)(66556008)(76116006)(2906002)(52536014)(8936002)(86362001)(41300700001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qZC6nM9pO9iSy1cCe1i8OdRLMhSTVeGy7hlK+z8DtfKg/rwtYAsDthjZk82J?=
 =?us-ascii?Q?5oKjvtPRwPL1RwhCwnsETqMgFd0B19FqRB5zDYWmua6dF6s4whR4TfarhW+8?=
 =?us-ascii?Q?EYcHbmHRLDcdXjATC9YrPkOf0EE3SSLIgxxUS6FfvgtZKXCMPGdJgux2JQxF?=
 =?us-ascii?Q?55kxXatZS2/hqXw46eZgPfZ20Khc196RSuPoq3grdFCrZtFdZM75xlNNaSY4?=
 =?us-ascii?Q?FhuNJjKRvKpz+RpQphSoVBuxGAYINXkokSNne4EYvEhjGlLXnEXO7Ja/zTkd?=
 =?us-ascii?Q?eUJw9rGqIil4upNLkHKsE6OkIVg9+omjhFZpZGBqeBi8fVcqUblrxLkLmhJx?=
 =?us-ascii?Q?HKzL4Fc2moYK181dJKgMs7XXitHtB0jT+nK2ziIbGbWXvNEn6uLBM40jNGR7?=
 =?us-ascii?Q?9bySnVofscymJYL3k4vVWb+Ogj0B2uum0zH4eAHpwgLwYO3x1UPiWtWoUr59?=
 =?us-ascii?Q?IfYmeisXjT5weVynG2OykCX5B6IyYeNi39ohhEsokxB/HcNhzZopt0zmRMSu?=
 =?us-ascii?Q?RaSl4ge+pFLTf/5hkcKRpsyaQuH+83PIjFJ2uHwQhAS8BMi4bbPw5Zc7AQuk?=
 =?us-ascii?Q?SMRjnXWHswb4JPPlKxCxIqbqdMWZ5+ZdAiYQdUh6ny5ztL+qJJC2METtalpk?=
 =?us-ascii?Q?P/ZH8vH+PKy28uUh3n2lLtVFOpexdURX7Begc0JyBgOr2x78I0WNZ1jBknuh?=
 =?us-ascii?Q?0a8IU/nCSJRxyfPHPf+5oIaTTjbZBbcmJ8XHVBdCYe+gsl+y2rvzi5oezzD8?=
 =?us-ascii?Q?fa4mnwfDqIS+Efru8Ng6ChzNYrfk0M5B89BDRpX6SHyAqLzPRjzQHkjmPeqM?=
 =?us-ascii?Q?1DnwGBOVu6JhBtf43gOtjghezaJcNTwbVtYyjkN2xM9wlDgYbn8nkUYTRSYk?=
 =?us-ascii?Q?gI64RsjTtz1j8AZhMfbZS9/ZGk6Z/l6bu5uxybgB8YUNffUh00wxGUsUTk5m?=
 =?us-ascii?Q?WgJmQOQGiWmvZl6MAL+bq3uzgQfi4YBBxtyoas8vMyrjj6mgwvHFefHpHNA2?=
 =?us-ascii?Q?kSmJ+Waf2KrTzZQh+nC3dJBtjjOBpneVCcTvDmQOH6f5c8sQoWTv/QwQFrXp?=
 =?us-ascii?Q?SB70rT5ZV5EeWAH6VFo0sLNG4J6+StIsb+c13df6H7S8FC2CoqquG1i/XFRe?=
 =?us-ascii?Q?+KvZW76HmSbJkYw5eSKrsaVS8MSrsZZ7tgmIbI5bfEegrLnd948jnNfk2+Ja?=
 =?us-ascii?Q?ndem3ngioIHmlHEapR2AGFztJWHohKho/21YaLvlGekKhixZxhqVzQZLd9MH?=
 =?us-ascii?Q?z0+91vsltiz5698pEZjbSXV8IxFZ2cDO9bSb/ewEpPLzqmsfR6Irf9uLNEGe?=
 =?us-ascii?Q?MCVSLhKz35Zt6HalCXQMveN3vZZeVy9+GAjnyyWAd4BdCzP2Iii5EF9PU4XL?=
 =?us-ascii?Q?pTnuX1i+e4nXrjdOs88F03yJsHvU/TnuzUkgPIkOBaOZINcnLXcmjQx/5yrY?=
 =?us-ascii?Q?H3lkNLZ7zM9Lny8B2NKTiozKUKbCTshRw9Q6Qxgunl+0ZyNOZ/j1E9k837Tg?=
 =?us-ascii?Q?HcEjaUPr79gm2i1LMtu4RjE2x5Ffa35eXNssKd3sPJj1A6mV6itwoimQo7Qr?=
 =?us-ascii?Q?biyGgCpcWr4CyrTRpf9ahf7Ix5tg4lxnRmiAud1x?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 198f8c19-8bcf-4ec6-8e30-08db18b40ead
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2023 11:16:22.2335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pxxqNvhHIITXK7OQhi/+W6rH+AMMjaE+uhq1JgCbqimXyJk/KtIQ5hpc50g3Dp1sMVGc2IWDprTAZhc/vqQIkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6542
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Dan Carpenter <error27@gmail.com>
> Sent: Monday, February 27, 2023 7:02 PM
>=20
> Hello Alexey Kardashevskiy,
>=20
> The patch e8bc24270188: "KVM: Don't null dereference ops->destroy"
> from Jun 1, 2022, leads to the following Smatch static checker
> warning:
>=20
> 	arch/x86/kvm/../../../virt/kvm/kvm_main.c:4462
> kvm_ioctl_create_device()
> 	warn: 'dev' was already freed.
>=20
> arch/x86/kvm/../../../virt/kvm/kvm_main.c
>     4449         if (ops->init)
>     4450                 ops->init(dev);
>     4451
>     4452         kvm_get_kvm(kvm);
>     4453         ret =3D anon_inode_getfd(ops->name, &kvm_device_fops, de=
v,
> O_RDWR | O_CLOEXEC);
>     4454         if (ret < 0) {
>     4455                 kvm_put_kvm_no_destroy(kvm);
>     4456                 mutex_lock(&kvm->lock);
>     4457                 list_del(&dev->vm_node);
>     4458                 if (ops->release)
>     4459                         ops->release(dev);
>                                               ^^^
> The kvm_vfio_release() frees "dev".

It appears that release op and destroy op will not co-exist. So this
use after free may not happen. Is it?

         /*
          * Release is an alternative method to free the device. It is
          * called when the device file descriptor is closed. Once
          * release is called, the destroy method will not be called
          * anymore as the device is removed from the device list of
          * the VM. kvm->lock is held.
          */

>=20
>     4460                 mutex_unlock(&kvm->lock);
>     4461                 if (ops->destroy)
> --> 4462                         ops->destroy(dev);
>                                               ^^^
> Use after free.
>=20
>     4463                 return ret;
>     4464         }
>     4465
>     4466         cd->fd =3D ret;
>     4467         return 0;
>     4468 }
>=20
> regards,
> dan carpenter

Regards,
Yi Liu

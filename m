Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8A9758D29
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 07:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjGSFck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 01:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjGSFcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 01:32:39 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93971FC8;
        Tue, 18 Jul 2023 22:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689744756; x=1721280756;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mfUnqdB4F+u3eE7btYlbGCr70asJzq+rYgkygA5kHlQ=;
  b=jZQLQOwtkHe0XcrMCBD1SaYOdd6PhjsEGf7DX+3xbwv9VGeL/T72YYk+
   ozbBJ2VR9NHy7S7sAkVaj+/tce/fiKCU0GuEVnjzz1K2eTSjshyL9Cjet
   /ABjnfG9b0DaT10gNmBjxg5h+nMzqz7WhLlyhNlwrRQGJPfOUMq3dYVPq
   RI+01PTTjTHSAwRXR0DNZHwYobJOvj3stmT+DEEzifR5B5R1hOUZM99KZ
   LIOBdDME3JJdc49hQqFTX3M94F+nSLjg7cZLHzp/nI1AeIXpia5XIrwyL
   1aQWrMP8rpr+QaVQOzvcRSsO6nTxWANI/kkkmyrg5MV2FN9RQ9JZiT+ay
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="452752407"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="452752407"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 22:32:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="717866263"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="717866263"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 18 Jul 2023 22:32:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 18 Jul 2023 22:32:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 18 Jul 2023 22:32:34 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 18 Jul 2023 22:32:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6SqdYJx+SSNS6ZadvBops7z6dRFZ4XvQlvBCnSbajfqOOCUQBaKC34MLjJNVN1CNPXYRWO1Pd4HkA6q9ycXDBmPXYGOlsMHceH7Ub4lWNZhIzlyZvbCy0zOyZda4BqJSK2rLaTzZLfUrGxbdwg4GBd/IzhacoRImA9PlMJ3aomVPo1AyTXiXNMyyrHXZemRT16FfC/958XzsE88ZLP6411OB7uWQLAUkiYqnDHsWkvNtUxTdigWsS9XKjKCnmnF6uQ34w7oCJ10IGxMHGhILlXYvQghLZkDtptmMJOc/iS2j6RTMGQptE3I48FnSnzFPN0p/u/W1VFnpprk+W7WUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Mqr+Kw8TabqQFBdPqU6+KXhLCJnvhSwbdsgk0vzZxA=;
 b=CnOnt+27PMB9WCaUfEY+6Iptdi73JllGV1a6irorosWwDvnDmSFcgsdV6e9FmocR3jsvTyl4wLzg4dPSoyaJwa57cBiWGriV7OHZEjQlsl4KI0aSHtfI4CcDI11qGh5HqJ2qr8jisOx67OuXZVhh5WTQo16CZ/wZwcLTyNuOUHgzJu1wD3KlbUNpcetVj54mge804UmQMjYBR+1jTYn5mRUWNl/DS0pVSlQW8Kd/JyyEWVEMW2/fcP6/YvtbRES8WQK1jCS4ZW54c6+eNKCOhSLPCMp7EX5R46j7IqblnSspLPhGSAZz2f5Pd6a2OBy8QJwrJwl5lJ5lkVbK9yNAng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB7007.namprd11.prod.outlook.com (2603:10b6:303:22c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Wed, 19 Jul
 2023 05:32:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159%4]) with mapi id 15.20.6609.024; Wed, 19 Jul 2023
 05:32:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Bradescu, Roxana" <roxabee@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] kvm/vfio: avoid bouncing the mutex when adding and
 deleting groups
Thread-Topic: [PATCH v3 2/2] kvm/vfio: avoid bouncing the mutex when adding
 and deleting groups
Thread-Index: AQHZtqT6WmtjXEfJ/0GeKcImZTi8I6/AlmDw
Date:   Wed, 19 Jul 2023 05:32:27 +0000
Message-ID: <BN9PR11MB5276BCE644231C440053AA118C39A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
 <20230714224538.404793-2-dmitry.torokhov@gmail.com>
In-Reply-To: <20230714224538.404793-2-dmitry.torokhov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB7007:EE_
x-ms-office365-filtering-correlation-id: 67627afb-4082-4351-aaf8-08db88198a78
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +kjzu4D3mAqM8JAk4pKoL1ny7MCAdpfz/V2bZl3MWSS7+KHcrIOgWSzJcn1+2sKEcGEnFOggmQ3kwPT5Pyce4920uLevnQ6/Y/Ay8vK7yzF+aPThJzRSQgHfQMqwhGZQXAepO+usrPf1DfzWfPIyEhLRcQ6XgoHiQPN4FK1SSqIJLidVW7BQZ0bIHZDenW1JX5GFm3YztOEDa6HDEzOpqudrszSjEiNcD+z1IR53j65301hHmKl5fnMgxLSpf9Ds/n036aT8S9RA6RqIbhjtQQTGK7dyg/e2U8lEnTN2m+xnG3y+MFM+TtEvgPVxc3MkJQSfznTDvJed+aK7K51Pf1JkmJYOtQMb30SwtwYZOvOkGpFIs3OfxPzHcdL4HF8MzSNUs7HN2fN8kF2wtcC0IPDYuRk55IhqU17TPCMTv5T8Dr5YnHB2GLIa3M25/BGQ2MWiF7TioNBEr+0Q9zzKQM1fUytU1BWqgUN8R9ctlVE31mcnfmcUlPQeAUcWp5Wq5soDQ4SInRLww9Xee2BVFEo58OZYD+1yL4194f/jEKLZzb/vigzy2MfHqdJhfm0modIQ96pS9LD4J6rPlQMHviwa3QMWiIJ8odv7M3lC26w1lAADxGnTbCKVB0lYb2yV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199021)(186003)(6506007)(9686003)(83380400001)(316002)(41300700001)(4744005)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(4326008)(52536014)(2906002)(5660300002)(8676002)(8936002)(7696005)(478600001)(54906003)(110136005)(55016003)(71200400001)(82960400001)(38100700002)(122000001)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+Cdao/02FKC+xw9A8bmBoKuVXYX3xiRcuOAHw5ueC5epm6zUIdZHgIE0kXfD?=
 =?us-ascii?Q?w6rXt+TuI3+OgxDTfQ/V2Wvq9jURHM+Ob/qKAu/XdSW1igs9HW2Pkot1ONVL?=
 =?us-ascii?Q?5nnvYYUgQfU9rVIyF1p30zF1k9zTaJfsnGYCuLTxhmWMOHghKjOc3HZIYEkv?=
 =?us-ascii?Q?Kv+VfQ6zapzGEuuWk5HLYLnms+B/xLLMSonKoof1ZXGR1uzdRFTrqFL2wpiW?=
 =?us-ascii?Q?7cxciZLii2Rzfxy8lJXbLwS7oXS/d8QUBMG7a1NVJhAAy0y5D0NNum+FApjv?=
 =?us-ascii?Q?Ip+WptaZwL9Cysarb/m+E/9zsILekz/1n3pXQZb/uscjOVO/MK3dR8lmBvQx?=
 =?us-ascii?Q?TfqxOB1eGUjsTD0dnVH0yIsesa4Y57NFFGHVqwzNfjeB0W/lD8rodFZ288GA?=
 =?us-ascii?Q?oukcL2+8IorD8LUkRU7/Ou15+pkLv3sCsReBQ1xaR/vNUGy9p4+J77LEzQ7N?=
 =?us-ascii?Q?N0/nz7r5oz76dj7scvmUwbyHCLS1ozAJWv1zvc6C4V5JWvx6TGur2C/awcV6?=
 =?us-ascii?Q?cH0Pg6TLX7c2zZDbsej/5RkjUR6sduRHfao8lR+UHnm8AfqgGJji155Q7wZl?=
 =?us-ascii?Q?V/iWMAo/LPqN00nA2iRRb6w3CXtdYkd/Q5oT5V+Aqc61jkybyDF88fFCcFIl?=
 =?us-ascii?Q?IQ+f3IkgVWx3C2j7+e9OH/nXjr/EpixDMP9v/FQhS1OLsXTlUkE4DIChnsei?=
 =?us-ascii?Q?jeJFHwCY0bh0o7wQcUgv/2cMEJlJ6thW/ZKrivcQ4SH6Masymksv6lHBSu/K?=
 =?us-ascii?Q?5AXoEagUn5xxpyrgAkNxMg4jpCw3fdZafqt0zX1/GIabauycvtgMi6pb0Pnt?=
 =?us-ascii?Q?4kBS6YvYRjrZDp1X14Zgkrv3UMLHSMSeFzKM7xXizywbY/rBm6hA4Y+200VE?=
 =?us-ascii?Q?M6Mipv8WlHiqrWH2WDLGCgGlw8fQNwoZie3r908EmNJdyFGITkO2ZCpeVyIc?=
 =?us-ascii?Q?hcFClf5hhXRKcS0K71v7saVtKKuOwMUxphFOpnVWi0JcsRPoIVlQ4oYV2W5u?=
 =?us-ascii?Q?1wMOzg+I19LRNyApuKEnLFK45VOheIFKaBYfQ09cL78hCCjh+ZuUwpr4mR5J?=
 =?us-ascii?Q?Liw5pCdeXPHEKDGAXywe8w9zopeSc1RTtRHWhc1UoQPxtFnA5MtDD+9f7rBK?=
 =?us-ascii?Q?4tFOBhMbKVi01uLWoOYZl8+Qg2wU5SFbkN8EbFJn4v9SQuLd0POlJq1kZU7A?=
 =?us-ascii?Q?vE/s5uiS3c7Elj5efdONLXdnyH0lWSeWurJwClimbVqLzYyEVTGIazkMzcup?=
 =?us-ascii?Q?15oYEaYo1qbhoeaQPsjFd1t4JDBKUtTmHYJBAnuzjxsW46UIfViLOy76TP7G?=
 =?us-ascii?Q?emYbuoBiK8G8Ube9x1wIVgmY4hLfWnZZIYNnQUEr2a11hrMTbwmdl4Su0UtK?=
 =?us-ascii?Q?ssd50ms1qeutRU4iwJqDJ2aU7DZ+D4kC0/DO3b7eXrCbcWi7fFm3xNZFddXt?=
 =?us-ascii?Q?9rU+3i7+fKWRYRg3QG2ztSwHnos4VghpPWoK4ih2zcn5bKgWVGfzAiOWHN1Y?=
 =?us-ascii?Q?C98YLyJ49t/R4nrPR2REFM1z/txjiZ7b5wa2NnyQypuiC0xXB0ZE7lhQ0A?=
 =?us-ascii?Q?=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67627afb-4082-4351-aaf8-08db88198a78
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2023 05:32:28.1231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ug48VByUxSx46Tn5saiJHo436iAb6+qfheyrcvaBpaa5JrlMjUb/w9qLFoaj3NF5VBm+13TeUSHm8xuKTnwFdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7007
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Sent: Saturday, July 15, 2023 6:46 AM
>
> @@ -165,30 +161,26 @@ static int kvm_vfio_group_add(struct kvm_device
> *dev, unsigned int fd)
>  	list_for_each_entry(kvg, &kv->group_list, node) {
>  		if (kvg->file =3D=3D filp) {
>  			ret =3D -EEXIST;
> -			goto err_unlock;
> +			goto out_unlock;
>  		}
>  	}
>=20
>  	kvg =3D kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
>  	if (!kvg) {
>  		ret =3D -ENOMEM;
> -		goto err_unlock;
> +		goto out_unlock;
>  	}
>=20
> -	kvg->file =3D filp;
> +	kvg->file =3D get_file(filp);

Why is another reference required here?

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E827705CDB
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 04:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjEQCMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 22:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjEQCME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 22:12:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF28EE47;
        Tue, 16 May 2023 19:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684289523; x=1715825523;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mZTcHvUCtMY292Fz+AHXdN01IjhKeGvXuqopFzq8/JM=;
  b=kL+aEkVd1jJC72W3vYNU197jLlzXwJTCuGurICN6Gcklx4kR50PdbbDJ
   1MHF38l9qFFTpe9RmzsFu/m6SbKMkrDsxF+scJ7R0xqsaMbwRgsrh8yGf
   1SGhbxGIiLL5xJwZQlHhuLbTf/aXCekA98zr+5zzLXLpwnSt+OGWktfco
   cEfVo7hQHJVVgakIBJ8J3h2OrL/1O28DoMWSEm0sk8mGmnxDNqQjR1kOg
   Lqht37evPNB1MX/QHdiYAdyIQOfJh/K4lucpq37DUCZd9BnVUGMx7cUov
   2f4gMfQ+PdH9SzQVgnXu47dtisc9pqxi8UHPRnkr/kKh707OmB0C3afWn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="379830033"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="379830033"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 19:12:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="1031517074"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="1031517074"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 16 May 2023 19:12:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 19:12:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 19:12:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 19:12:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JahQu5fjuO+dhqcY/WkHDWO3zxg0mnsDmgyUXCG6iPLSYQ9aDhr87KP2FsWpkHPlfQ7OlT4dG7Wo90pvOBsNOZq9wjxxDv0Xom3P5FsaAV4tA3dU6UlcSq9H3XEmwjO1lCEE5e85dI1/S4o3wxsDqsQY9v1+Z4ki51D+Q9LxwRemlsVkA8QCLCgumgH7Lt4JItgTeC8vZuVdAxUvkjjJASyG7nbMRe9eAFM8GQspNxEvuB/5O45O9iUdJUfMYbUR6TbwjSbfOhm2j4K25TcBqJVj2ZpzK4nv3ZXnhmgQFgr/5z7H5PKf+C+Fogl1yAGr//VAjC5RquPQ0mu7DCJ20g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZTcHvUCtMY292Fz+AHXdN01IjhKeGvXuqopFzq8/JM=;
 b=dkXz3xDiT444htmb49sK9bKZgiOOw6Qvij10Rzmi41a7kmf5uzazkWA7KSxZcTSA4MQETWKVxQdBk8rKp/a1OwRugYAV1ywMotRjpla3b5dQD4BNR/K7kpbANAQJ4UeqAarGycm4JWKzlLtp1l60abzOeogpk/0iPcnGXCEUyFEK/6STqz0Xl5UoG9XHOgy0l9vY5x91aOpKxwXRq6QQT86ULpeUMrxLNjhK2A4Ms53MpAqYN3/ihbGrhVY91J9+3J+PcQJauJJBchSCP/NdCb7aY6wOUxr/Bsfiw4I1LhaoX0Ro6jwP4EKbXevD2ORJHokcwujdeXEsDw7wVd0ZiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7568.namprd11.prod.outlook.com (2603:10b6:806:34e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.29; Wed, 17 May
 2023 02:12:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 02:12:01 +0000
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
Subject: RE: [PATCH V5 03/11] vfio/pci: Prepare for dynamic interrupt context
 storage
Thread-Topic: [PATCH V5 03/11] vfio/pci: Prepare for dynamic interrupt context
 storage
Thread-Index: AQHZhB+NML0SOweBJ02fBu9B9TGuza9dwX7w
Date:   Wed, 17 May 2023 02:12:01 +0000
Message-ID: <BN9PR11MB5276B08334B4AD974D6302508C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1683740667.git.reinette.chatre@intel.com>
 <eab289693c8325ede9aba99380f8b8d5143980a4.1683740667.git.reinette.chatre@intel.com>
In-Reply-To: <eab289693c8325ede9aba99380f8b8d5143980a4.1683740667.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7568:EE_
x-ms-office365-filtering-correlation-id: b18abab6-0416-4efa-d5c3-08db567c19bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lBBs46VYZ9NOwoCMW585xdv54vSEd7vK0rP2bXkDwMuMTV8a8HMvZoTQI0BrvPK3gSvmxeKuGVQUJY0/2DFeZLYEmCoIXpoT10YZrcYDFxJjOMtuoXrTi5gW8TFdFSXsCzM3UGO9w+Baeio40i4Qlujtaskq3N0b+tJb29C8yufWj5nROCP8i7mg+hQ4zGZUVKxqg9AjI7YfDcDA+D/ZHm7TNkJf+Z3yb3HzcTH9Gmqtz2izdmk+sWtrkqufl8uLZtfriRQodCJwllOx5sZ9apHQyuONjm5uzOpu1t+ZpOctafegXi1/44NWgBJtIpexitzrHGN6Hqegn7ITyarZdZCwT9LCLQg2HEyXNwBZmgw/4JgpNn0hAjdFOEpzpWCjwHDwtNzYIPnBmpXJ6Qwbg8jse/4gjRr4kdZP0W4ng2FU11LB6lA7J5qlBAafvz3CR9hkYTQHcqeAP5UEM7iyew0H+svN1c6vwsTAJDHDgc0/ZXMV83lRGxMNcdlw+nP2uDQRU5QmpGao7KMEAZgHr6Gs7QvrrqZbrNs/critc5yDNWJB3CGQiA1Zf0zyUWMPZXVV6eUXr3vptYHvTJJQ98T8MpACjtOzXGs5h0i38gK3qmGURKRpDbm1GgjzdbVV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(33656002)(316002)(86362001)(54906003)(110136005)(66946007)(76116006)(66446008)(66556008)(66476007)(4326008)(478600001)(64756008)(7696005)(55016003)(52536014)(8676002)(2906002)(5660300002)(8936002)(38070700005)(82960400001)(4744005)(38100700002)(41300700001)(122000001)(6506007)(186003)(9686003)(83380400001)(26005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I2+We/WSn/aUOcjmF9YrtXF4jkgnFMdh2vYICtTUm6VkF9Ze/P8w8VIJdH9z?=
 =?us-ascii?Q?2mi/rijvWQyNtgN5fOkmTI4TTsXEiLGU6dngSin8jSUkHU0wyelbRqfbPoBO?=
 =?us-ascii?Q?vJT78IxoXuPibSYOGLpgSv9aD+wbRJkvGkmqlDe4jG7zFCgCs0nagjVSlvm1?=
 =?us-ascii?Q?VbSQr4Zme7I0vT4JJFmGPOADqpJeQr0SH9khFFAvmGzTo34LoKLhY0IjAIat?=
 =?us-ascii?Q?O0jYv1pZ0EYgigt++ueZCjVQR3/h7t0p/iv/nDxJGn83LcenKZ1xTWblfXhe?=
 =?us-ascii?Q?CPg1PPbUFemK4ZK8V+HEb6DOWzH45Tnr9ZHOqi/Ex03i5Hl5xmh7o7M4+z1i?=
 =?us-ascii?Q?LrEG9tlVxNEBxEqKU9LCsGaprY0EhFweFqnEDaB4Be8Btgyhhs/sQTwlV6lw?=
 =?us-ascii?Q?JJgehlpl2WmIdz/cf/KnIKc7K/QMZEMKsyjk7jadXa7/qQmBmlnA7fM+mY97?=
 =?us-ascii?Q?M1PFcMFkxuj8Eg5AXsvw5ndSMd7nR3XDS3HM99MfBw+8UHxLszAXF/VxP/qe?=
 =?us-ascii?Q?e+y2O/E7u3DPjN3+b0ao3YOWxlrGYOl0FtQmyJpFej6jpILzub6KWYDZzT+T?=
 =?us-ascii?Q?U7vp4z4WB1EMMqSme17akj1S4uFfcXhADLcaYp6E/LlCLoXxa/L26n/2Mg2U?=
 =?us-ascii?Q?LPyRVrvEhEuvtX3FgNyLYeB8or+XVwxIuDEwYu04jGx748FwbJChM4MMNv5V?=
 =?us-ascii?Q?qdRpsp8DfWP3H0FG/UOmeIE1kyLY1mZa1PD2vSTLpLqK9NyHr/FYEXNouNVd?=
 =?us-ascii?Q?43cnGopGFcOQQthMy2Mrr/dAXkrix42a9UBqRiDp0d9980LhFvucXzg+yDbV?=
 =?us-ascii?Q?eatsI80h8hStPfDWUNS1+cMqDcoXFBToDSAOYszDiDM9XPfidbvXuWvLIZDD?=
 =?us-ascii?Q?BipaFDr9f60Dv1DJ/TQRBxyDkcq6AxeGn3dDzJylhmrU9Z7r+PF7dc/s3S8I?=
 =?us-ascii?Q?T67dWe8FZuGPl4etNd9rcKaqNtGJEzm/XHHmneye0gxQiXnCvCIo08wcm7Iq?=
 =?us-ascii?Q?SolSCzLCo+lhqbfJfWhmG3pUZjs+ZNBfNJ18jY72EyMFA4rZA9QwmmjW+Lbb?=
 =?us-ascii?Q?gyTDUe4p8igMIev2wtNf+Lw5edpn74IumIsyOg3JZeIMs/WwCuxesZx9fTm8?=
 =?us-ascii?Q?TXByDXjnOTakytNakxFDl/TRNhu8HGLgIIhKETirMAZUWWo+SJQnd49ALwvy?=
 =?us-ascii?Q?J5c88SdyhS8Wm7PdlrC3V6PivF+rdPoINm4XZyzPPF4ekmwqeOUl9nsrPV7M?=
 =?us-ascii?Q?D3/QpZlRxy6p3ID91uFYQ39PfntFsFC2PJxDkmzXD6ILdZt7QMuxLYVkVYd+?=
 =?us-ascii?Q?iUrYhpG9zAdCH1F5Qt29Igcrb6rT/48JT9ifNcSajJM9ClQ9VuSbgJ9vflVR?=
 =?us-ascii?Q?Nk7RHk/ZAkjCUKY4nXzzTC4RfiZ8BtNPOdQYppK5XC1oNiuYxR9GK8sAcDbg?=
 =?us-ascii?Q?nrCAepGDAiiq42Tx3B7v6WEH4ZFQKAmdE/UEKZk7W0b4CQiibzqccmfv9yqd?=
 =?us-ascii?Q?S6phWijBEuOl3mqWQpHIfEFN9CHjS0GhnRpFhQvZvpy6QvCV7x9vTgiFEvQ1?=
 =?us-ascii?Q?A7QrMK9n0tZGbNPrmedE/hKlWO01w/PWRxk1Rgcm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18abab6-0416-4efa-d5c3-08db567c19bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 02:12:01.0396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tZtPfbsjKrhAcbDtmRAf/Vpfs25VN7M+bHp0iR70mWASUrCggW8MGhBRs7ywhQvTHvlbYAC11qliWTEbcnszzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7568
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
> Sent: Thursday, May 11, 2023 11:45 PM
>=20
> Interrupt context storage is statically allocated at the time
> interrupts are allocated. Following allocation, the interrupt
> context is managed by directly accessing the elements of the
> array using the vector as index.
>=20
> It is possible to allocate additional MSI-X vectors after
> MSI-X has been enabled. Dynamic storage of interrupt context
> is needed to support adding new MSI-X vectors after initial
> allocation.
>=20
> Replace direct access of array elements with pointers to the
> array elements. Doing so reduces impact of moving to a new data
> structure. Move interactions with the array to helpers to
> mostly contain changes needed to transition to a dynamic
> data structure.
>=20
> No functional change intended.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

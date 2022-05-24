Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B37532968
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 13:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbiEXLkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 07:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbiEXLkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 07:40:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982A58D69B;
        Tue, 24 May 2022 04:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653392389; x=1684928389;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=96ir8+LsCQKRq5kq8mc8ia76nfmw/lmhQqVEDxrtKa4=;
  b=eREWgrtMW7wD3sc0xI4QjISbk1c6VtetyTEzs5Eqk9Y5vvRK2kP8Wt4p
   pIAQjuSEbAkAaiy2M4VnBIyoRuKe5szckkqy9eVUsb8VmfpdMtfoj2Hlu
   0tpG8VuUUx57baIvloLE2QeEqZ+yoXkaxoub09VC+D+ZEJlCHNrzM3+8H
   H17oMHWicu+jjBUG0hvD4MBaVVWCPb12lKr7T+04xtF/8rFf8V//t7YUK
   7ljL2cv2SMYawpmuvTaZv8+qdmEH1L2ABB9hBjIt1e796o8LMWl5gXsPx
   t3YMA/ut1CYSXREAB+8LLslz+eCLZPD7rPFZYK6cyMVythvDZXdjjVJS9
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="273618011"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="273618011"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 04:39:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="526370115"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 24 May 2022 04:39:38 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 24 May 2022 04:39:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 24 May 2022 04:39:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 24 May 2022 04:39:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IxAecBQKkbUdBwZQl7x+T5ywVjl5WLIfWEZJo/aB4hHSWQ9nH7l9vqMKujF6rnsz5W7QxuMIlCMs+psi1jr9j2dG4zkcOv+jByd1BF1xEl3p2pq8RoUzg3IWvncvEQ90MNXTixmy2BvgMNVDbktKx6Ohc08hiCvxpyXr5/fek+s9ppOe3kx6SdSGXhWkp6Vv6shNkYAP6AOO6qYfZCYgR2RFVw4Oq71JrRsQi5EjK2jCBdyC9TtPNdqzQuuRH6zdcqk3dEZVjvc259NIhWKHP+/IGMD9MZ1gMhe0UfPZbiBUZI9zoWOL0LGFlYjVIWlX3Lj/epI/LJF7JNHdl9Xp1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Zn7qScQaa7ew4rWy9hLCVKgQAjoOKwmZTIt+dbXAtg=;
 b=R5gHD8c+80s7z+LnxGGMJwzYl/s5qjc9F+7uFOUm46YiS6Qku1G7nJ9NA1BsxAamnqUUD89/C1Q+8RIYc62IMuj6cVctChiVOu5fRdPKExAhyARz5GOUTXLy4zK4ylIR9w5imqcUvjUJF+oFCHIiSca2DuL3zufs+yGs9Eae4X5EefoH8DEK3/+5MzKFAQP/kD+JMnlYX0+cmlE83Ogh9RTG0TIGq+13bdIbyJEX/QB+ztZ7IZjk0GQFuO/llXPdMmBHQGqPZKYSLu7J6oYPiTROrqzx08hlWfSjGA0tCeNLfUtxzYHlq6fxMW15K/bm2cTgXpljvDMJQ5vSEDo3Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 CO1PR11MB5188.namprd11.prod.outlook.com (2603:10b6:303:95::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.13; Tue, 24 May 2022 11:39:34 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::748e:ed0c:39b5:fe99]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::748e:ed0c:39b5:fe99%7]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 11:39:34 +0000
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>
CC:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Thread-Topic: [PATCH v3 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Thread-Index: AQHYa671j+KgqQmYjU2ypfSPa4o1H60ssKIAgAE934A=
Date:   Tue, 24 May 2022 11:39:34 +0000
Message-ID: <7a7d7c5b-2c91-8e52-e9b2-4d12ad5c881f@intel.com>
References: <20220519183311.582380-1-mjrosato@linux.ibm.com>
 <20220519183311.582380-2-mjrosato@linux.ibm.com>
 <20220523104150.49c001f8.alex.williamson@redhat.com>
In-Reply-To: <20220523104150.49c001f8.alex.williamson@redhat.com>
Accept-Language: en-FI, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 636f19e4-6ca9-4a7d-0a2e-08da3d7a1364
x-ms-traffictypediagnostic: CO1PR11MB5188:EE_
x-microsoft-antispam-prvs: <CO1PR11MB5188675FB9CA124D13AF7A92CAD79@CO1PR11MB5188.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zbnhwdBUfmMotbunkAnhXwDNh6T/kSr48y1x8J1yG1MKcePayA091P0C3ylYm7xWRHse/fzZtkP/RHIJHJYdeBNJk6urI9XFakBBE6mOGj9s4Bmjf5ms59Bs4NF6GmRBuf1qeIT3iBa27SFswEaj8qXxALGfYWByBY6AshacRDogaKL+scTJ8KN7Z7JcqXdIxu3dsYGMyB5fjjywfqlVXFwYI+GvVoa/kt6mkAYw0DbpOPqD6JBKlxcxd3UrNxV9AvoIsISbBSJUvlHmOEKDAVcSzcFIejfQKLIwFM7+czwrhwrlJp8FooZ+dd+hB/9vFBOfRGhg42qLZo8kwQ6l8/vq0mBo0AJH9M7HUq00jE/9ZZSLKjpELnsdY1pw7GAql0BFBQXp9ByB/wrzlp6ihVvfbFO1JW2AY8hojRE5xTSGWCCQY28equLcS3F2V9nHI+b7ngR6aXoVAwgV4XjoVozT6YL0tZ6LW7jqko+d/vtWub3mqL0tcC2KQuRaS7GvMRiFVqWCSRO7oaPbL8RrunHMmIxVnwjD5HYjLgWnYmJj1hc3r76MN/9I2BaIcMBhwslPfQzBqNE09Xg5GAv8TTulivtzEQytmCJw/ptFTaDjQD1j8tVYVj/XsYVeOikzKVS/7FwZvtS+jKelJpRxG5op807pw/EvztU5/+hnsGQ2ipQxa6i50HCORbwhJVY5wWlVLrodfmj0L1icNmjbHZYdVNmao/LbWdt5ApmUSF5PzF46VHmUz/XuRWfHDG6hsbXh3qI/6K3S64YSrywh2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(122000001)(38070700005)(54906003)(316002)(110136005)(2616005)(71200400001)(31686004)(91956017)(76116006)(36756003)(8676002)(66556008)(64756008)(66446008)(66476007)(82960400001)(66946007)(4326008)(86362001)(2906002)(30864003)(83380400001)(6506007)(53546011)(7416002)(186003)(8936002)(31696002)(5660300002)(508600001)(6512007)(26005)(6486002)(43740500002)(45980500001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?yq1qCef06GPPHLPNCyHLaELPLLGnDaIrXjSfd5ICG6xJ8reYeHPXyK6C?=
 =?Windows-1252?Q?tFelRvF+rjUma5IHb6iCkIRdYqIyiDCwFa/1cF+qzxnfYT3IIOdTo0WU?=
 =?Windows-1252?Q?hjH6zTnsUdwYCPlO/7uNz8nMjzhO3+8k3+oL8G5zWOP9EUY/iPP45O/2?=
 =?Windows-1252?Q?AbPAZZ2G34Q5TfYHFDSf4viA692S0otdL7gga8kzFk3HIKrlAJOQHQJB?=
 =?Windows-1252?Q?rY5miu+4tr+n/w23ltAHaCv8x3wGzMKKjYy9RQZKX7XiIztplvS3OeqF?=
 =?Windows-1252?Q?+rpbENQtz3+ke6Ma1qAMiT9hupxMhDz1y8uh0a4vF4E2pJb6nxyMcAWb?=
 =?Windows-1252?Q?v7L9C1B9VZOSjLc/rXSzMQcnHQ+J501vn9YVVCY6Lw2W/c2hAV7m3Drd?=
 =?Windows-1252?Q?HgTePF5RHfw6Cd+Y/uTGjDag45QuZH4zriHaIHYdSSbz3vw1czFi1z77?=
 =?Windows-1252?Q?Pf4jyV1CVU4ZmPc6isS1/x60ZXhyKT3ksRJ//kD1BR755nO3ycjFdHgz?=
 =?Windows-1252?Q?PwV5elq5QdGzDvbrqYkQk7NoAM1GhC9+WKTBEDSgW8xUwYW34qyzA5Q/?=
 =?Windows-1252?Q?n2i7niKa44a1M0VmmOatkaedU3zT7rDIGWraExSyPZ1TgwKXUc4iN84z?=
 =?Windows-1252?Q?tJ+eMdtcA1K+d0s4bCfJjnSMaP66KkZ7R5VQ7q20DVDp8N8dfVbiaNKQ?=
 =?Windows-1252?Q?YHuwHnUBi/yEkARAM3ur2/19sWubW8lcOqpW/2t2iZkzKlFQs/LY2jgJ?=
 =?Windows-1252?Q?uKDf4O4VffSGi7HlmlaDuCJ3vwVOoZg4KkQdpEDZoH/V+tVRINZAlARN?=
 =?Windows-1252?Q?euN9pktpdonsDz/IcUaMAk/QS+WMmkQMg12y6zkpugDnFiOsmDnim+MV?=
 =?Windows-1252?Q?O4/kuN8q+LNNqZ+ZoyUU3eBT2PJ3QG3wx09BT8Crh/rjLDSUTpJhy7ss?=
 =?Windows-1252?Q?TZT//d+VMPF63Q5dOUfx/MjTATeeGyL2+vTNM6R2CIitw59VWzbE93cs?=
 =?Windows-1252?Q?eLFzsnSE9LF7BRsWqmJ11CgE0YdHA/HVLJvQ3MdJ7ml+bKpf9G6lq0ry?=
 =?Windows-1252?Q?JfKiBS8qZV2SNlgnInD8um+1Pek6Kh0R0JrZ67su5D195RelYGM1hwph?=
 =?Windows-1252?Q?tRCLwuog7aHdkmNwwJc3wO8pcDjvBgXbIQK9Xd0XA3U97M7g8JwILQSV?=
 =?Windows-1252?Q?Ut0OixNHc5qtTcNXhjggORRdCMudS+Pta6vRzqb6+SBZKVM1HmAigJaV?=
 =?Windows-1252?Q?IEjmtRfVevJLPWXDbJO7kQj0dfN8wx7LBDdJsb2g37UOD2y4WAFA/+ED?=
 =?Windows-1252?Q?9dfq9A95ckhzxHnBQ0dp3GohA6rGThqDHwr/4TqB6dW6OMEZUi2hSJ54?=
 =?Windows-1252?Q?ndQ3pe4zzw7EyX1aoZNsITv1gRCfrSThvflR1AJJgDrfW6FfBqXXJNBk?=
 =?Windows-1252?Q?+lnBPpJQz1z3M/mR5oT0mUVMqQazcKNgYtNoQj77yhWVL0z5d64kCiof?=
 =?Windows-1252?Q?0nrdLIuTKMNEdkcpfUurysBMmDMfs4v7EGdcdQ5OqP8Ee7mupAaV6hgF?=
 =?Windows-1252?Q?cqVaYD0Z9Ay0q+i1kUiX5yp13DtzIATv4C/aplckgvkKei8VUJApVhgr?=
 =?Windows-1252?Q?SrjuSWHTPeMlH5Gz29B98bXS5qAJLJJ6IDhyAcugwlNCE9EikIXhwYCv?=
 =?Windows-1252?Q?GEEZmApE4LA4wHlJrFh0ungrhvPYVgGA5K94ZRjPXVxtkqydJZOqD/2Y?=
 =?Windows-1252?Q?GhG7WgHndOxUAzxLHDbSt+mNA5DHz0OBv+yjjc0Ihq3U1/3vH0H56wtN?=
 =?Windows-1252?Q?/X4x3z0lYa7Tf5b1x1stkTFHjhzgJe+M27XpfdvMrFTCVsThV53jnNKV?=
 =?Windows-1252?Q?rF3g+xkoMlgtJw=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <2ED53E2FD23AE04DB03D5F8931437929@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 636f19e4-6ca9-4a7d-0a2e-08da3d7a1364
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 11:39:34.6349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XtFaPjwaqbSZuDAFnKRmqQCcD8yqVwSsrcbIvoCaFiKHSu+h5vFJVSNSs8QSaSuMwg/3rG2UwGYd4IyZoOhcmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5188
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-11.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/22 4:41 PM, Alex Williamson wrote:
>=20
> Hi Zhi & Zhenyu,
>=20
> Please review gvt changes below, I'd prefer to get your ack included.
> Thanks!
>=20
> Alex
>=20
> On Thu, 19 May 2022 14:33:11 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>=20
>> Rather than relying on a notifier for associating the KVM with
>> the group, let's assume that the association has already been
>> made prior to device_open.  The first time a device is opened
>> associate the group KVM with the device.
>>
>> This fixes a user-triggerable oops in GVT.
>>
>> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>  drivers/gpu/drm/i915/gvt/gtt.c        |  4 +-
>>  drivers/gpu/drm/i915/gvt/gvt.h        |  3 -
>>  drivers/gpu/drm/i915/gvt/kvmgt.c      | 82 ++++++--------------------
>>  drivers/s390/crypto/vfio_ap_ops.c     | 35 ++---------
>>  drivers/s390/crypto/vfio_ap_private.h |  3 -
>>  drivers/vfio/vfio.c                   | 83 ++++++++++-----------------
>>  include/linux/vfio.h                  |  6 +-
>>  7 files changed, 57 insertions(+), 159 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/g=
tt.c
>> index 9c5cc2800975..b4f69364f9a1 100644
>> --- a/drivers/gpu/drm/i915/gvt/gtt.c
>> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
>> @@ -51,7 +51,7 @@ static int preallocated_oos_pages =3D 8192;
>> =20
>>  static bool intel_gvt_is_valid_gfn(struct intel_vgpu *vgpu, unsigned lo=
ng gfn)
>>  {
>> -	struct kvm *kvm =3D vgpu->kvm;
>> +	struct kvm *kvm =3D vgpu->vfio_device.kvm;
>>  	int idx;
>>  	bool ret;
>> =20
>> @@ -1185,7 +1185,7 @@ static int is_2MB_gtt_possible(struct intel_vgpu *=
vgpu,
>> =20
>>  	if (!vgpu->attached)
>>  		return -EINVAL;
>> -	pfn =3D gfn_to_pfn(vgpu->kvm, ops->get_pfn(entry));
>> +	pfn =3D gfn_to_pfn(vgpu->vfio_device.kvm, ops->get_pfn(entry));
>>  	if (is_error_noslot_pfn(pfn))
>>  		return -EINVAL;
>>  	return PageTransHuge(pfn_to_page(pfn));
>> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/g=
vt.h
>> index 2af4c83e733c..aee1a45da74b 100644
>> --- a/drivers/gpu/drm/i915/gvt/gvt.h
>> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
>> @@ -227,9 +227,6 @@ struct intel_vgpu {
>>  	struct mutex cache_lock;
>> =20
>>  	struct notifier_block iommu_notifier;
>> -	struct notifier_block group_notifier;
>> -	struct kvm *kvm;
>> -	struct work_struct release_work;
>>  	atomic_t released;
>> =20
>>  	struct kvm_page_track_notifier_node track_node;
>> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt=
/kvmgt.c
>> index 7655ffa97d51..e2f6c56ab342 100644
>> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
>> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> @@ -228,8 +228,6 @@ static void intel_gvt_cleanup_vgpu_type_groups(struc=
t intel_gvt *gvt)
>>  	}
>>  }
>> =20
>> -static void intel_vgpu_release_work(struct work_struct *work);
>> -
>>  static void gvt_unpin_guest_page(struct intel_vgpu *vgpu, unsigned long=
 gfn,
>>  		unsigned long size)
>>  {
>> @@ -761,23 +759,6 @@ static int intel_vgpu_iommu_notifier(struct notifie=
r_block *nb,
>>  	return NOTIFY_OK;
>>  }
>> =20
>> -static int intel_vgpu_group_notifier(struct notifier_block *nb,
>> -				     unsigned long action, void *data)
>> -{
>> -	struct intel_vgpu *vgpu =3D
>> -		container_of(nb, struct intel_vgpu, group_notifier);
>> -
>> -	/* the only action we care about */
>> -	if (action =3D=3D VFIO_GROUP_NOTIFY_SET_KVM) {
>> -		vgpu->kvm =3D data;
>> -
>> -		if (!data)
>> -			schedule_work(&vgpu->release_work);
>> -	}
>> -
>> -	return NOTIFY_OK;
>> -}
>> -
>>  static bool __kvmgt_vgpu_exist(struct intel_vgpu *vgpu)
>>  {
>>  	struct intel_vgpu *itr;
>> @@ -789,7 +770,7 @@ static bool __kvmgt_vgpu_exist(struct intel_vgpu *vg=
pu)
>>  		if (!itr->attached)
>>  			continue;
>> =20
>> -		if (vgpu->kvm =3D=3D itr->kvm) {
>> +		if (vgpu->vfio_device.kvm =3D=3D itr->vfio_device.kvm) {
>>  			ret =3D true;
>>  			goto out;
>>  		}
>> @@ -806,7 +787,6 @@ static int intel_vgpu_open_device(struct vfio_device=
 *vfio_dev)
>>  	int ret;
>> =20
>>  	vgpu->iommu_notifier.notifier_call =3D intel_vgpu_iommu_notifier;
>> -	vgpu->group_notifier.notifier_call =3D intel_vgpu_group_notifier;
>> =20
>>  	events =3D VFIO_IOMMU_NOTIFY_DMA_UNMAP;
>>  	ret =3D vfio_register_notifier(vfio_dev, VFIO_IOMMU_NOTIFY, &events,
>> @@ -817,38 +797,32 @@ static int intel_vgpu_open_device(struct vfio_devi=
ce *vfio_dev)
>>  		goto out;
>>  	}
>> =20
>> -	events =3D VFIO_GROUP_NOTIFY_SET_KVM;
>> -	ret =3D vfio_register_notifier(vfio_dev, VFIO_GROUP_NOTIFY, &events,
>> -				     &vgpu->group_notifier);
>> -	if (ret !=3D 0) {
>> -		gvt_vgpu_err("vfio_register_notifier for group failed: %d\n",
>> -			ret);
>> -		goto undo_iommu;
>> -	}
>> -
>>  	ret =3D -EEXIST;
>>  	if (vgpu->attached)
>> -		goto undo_register;
>> +		goto undo_iommu;
>> =20
>>  	ret =3D -ESRCH;
>> -	if (!vgpu->kvm || vgpu->kvm->mm !=3D current->mm) {
>> +	if (!vgpu->vfio_device.kvm ||
>> +	    vgpu->vfio_device.kvm->mm !=3D current->mm) {
>>  		gvt_vgpu_err("KVM is required to use Intel vGPU\n");
>> -		goto undo_register;
>> +		goto undo_iommu;
>>  	}
>> =20
>> +	kvm_get_kvm(vgpu->vfio_device.kvm);
>> +
>>  	ret =3D -EEXIST;
>>  	if (__kvmgt_vgpu_exist(vgpu))
>> -		goto undo_register;
>> +		goto undo_iommu;
>> =20
>>  	vgpu->attached =3D true;
>> -	kvm_get_kvm(vgpu->kvm);
>> =20
>>  	kvmgt_protect_table_init(vgpu);
>>  	gvt_cache_init(vgpu);
>> =20
>>  	vgpu->track_node.track_write =3D kvmgt_page_track_write;
>>  	vgpu->track_node.track_flush_slot =3D kvmgt_page_track_flush_slot;
>> -	kvm_page_track_register_notifier(vgpu->kvm, &vgpu->track_node);
>> +	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
>> +					 &vgpu->track_node);
>> =20
>>  	debugfs_create_ulong(KVMGT_DEBUGFS_FILENAME, 0444, vgpu->debugfs,
>>  			     &vgpu->nr_cache_entries);
>> @@ -858,10 +832,6 @@ static int intel_vgpu_open_device(struct vfio_devic=
e *vfio_dev)
>>  	atomic_set(&vgpu->released, 0);
>>  	return 0;
>> =20
>> -undo_register:
>> -	vfio_unregister_notifier(vfio_dev, VFIO_GROUP_NOTIFY,
>> -				 &vgpu->group_notifier);
>> -
>>  undo_iommu:
>>  	vfio_unregister_notifier(vfio_dev, VFIO_IOMMU_NOTIFY,
>>  				 &vgpu->iommu_notifier);
>> @@ -880,8 +850,9 @@ static void intel_vgpu_release_msi_eventfd_ctx(struc=
t intel_vgpu *vgpu)
>>  	}
>>  }
>> =20
>> -static void __intel_vgpu_release(struct intel_vgpu *vgpu)
>> +static void intel_vgpu_close_device(struct vfio_device *vfio_dev)
>>  {
>> +	struct intel_vgpu *vgpu =3D vfio_dev_to_vgpu(vfio_dev);
>>  	struct drm_i915_private *i915 =3D vgpu->gvt->gt->i915;
>>  	int ret;
>> =20
>> @@ -898,35 +869,19 @@ static void __intel_vgpu_release(struct intel_vgpu=
 *vgpu)
>>  	drm_WARN(&i915->drm, ret,
>>  		 "vfio_unregister_notifier for iommu failed: %d\n", ret);
>> =20
>> -	ret =3D vfio_unregister_notifier(&vgpu->vfio_device, VFIO_GROUP_NOTIFY=
,
>> -				       &vgpu->group_notifier);
>> -	drm_WARN(&i915->drm, ret,
>> -		 "vfio_unregister_notifier for group failed: %d\n", ret);
>> -
>>  	debugfs_remove(debugfs_lookup(KVMGT_DEBUGFS_FILENAME, vgpu->debugfs));
>> =20
>> -	kvm_page_track_unregister_notifier(vgpu->kvm, &vgpu->track_node);
>> -	kvm_put_kvm(vgpu->kvm);
>> +	kvm_page_track_unregister_notifier(vgpu->vfio_device.kvm,
>> +					   &vgpu->track_node);
>>  	kvmgt_protect_table_destroy(vgpu);
>>  	gvt_cache_destroy(vgpu);
>> =20
>>  	intel_vgpu_release_msi_eventfd_ctx(vgpu);
>> =20
>> -	vgpu->kvm =3D NULL;
>>  	vgpu->attached =3D false;
>> -}
>> -
>> -static void intel_vgpu_close_device(struct vfio_device *vfio_dev)
>> -{
>> -	__intel_vgpu_release(vfio_dev_to_vgpu(vfio_dev));
>> -}
>> -
>> -static void intel_vgpu_release_work(struct work_struct *work)
>> -{
>> -	struct intel_vgpu *vgpu =3D
>> -		container_of(work, struct intel_vgpu, release_work);
>> =20
>> -	__intel_vgpu_release(vgpu);
>> +	if (vgpu->vfio_device.kvm)
>> +		kvm_put_kvm(vgpu->vfio_device.kvm);
>>  }
>> =20
>>  static u64 intel_vgpu_get_bar_addr(struct intel_vgpu *vgpu, int bar)
>> @@ -1675,7 +1630,6 @@ static int intel_vgpu_probe(struct mdev_device *md=
ev)
>>  		return PTR_ERR(vgpu);
>>  	}
>> =20
>> -	INIT_WORK(&vgpu->release_work, intel_vgpu_release_work);
>>  	vfio_init_group_dev(&vgpu->vfio_device, &mdev->dev,
>>  			    &intel_vgpu_dev_ops);
>> =20
>> @@ -1713,7 +1667,7 @@ static struct mdev_driver intel_vgpu_mdev_driver =
=3D {
>> =20
>>  int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
>>  {
>> -	struct kvm *kvm =3D info->kvm;
>> +	struct kvm *kvm =3D info->vfio_device.kvm;
>>  	struct kvm_memory_slot *slot;
>>  	int idx;
>> =20
>> @@ -1743,7 +1697,7 @@ int intel_gvt_page_track_add(struct intel_vgpu *in=
fo, u64 gfn)
>> =20
>>  int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
>>  {
>> -	struct kvm *kvm =3D info->kvm;
>> +	struct kvm *kvm =3D info->vfio_device.kvm;
>>  	struct kvm_memory_slot *slot;
>>  	int idx;
>> =20
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfi=
o_ap_ops.c
>> index e8914024f5b1..a7d2a95796d3 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1284,25 +1284,6 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matr=
ix_mdev *matrix_mdev)
>>  	}
>>  }
>> =20
>> -static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>> -				       unsigned long action, void *data)
>> -{
>> -	int notify_rc =3D NOTIFY_OK;
>> -	struct ap_matrix_mdev *matrix_mdev;
>> -
>> -	if (action !=3D VFIO_GROUP_NOTIFY_SET_KVM)
>> -		return NOTIFY_OK;
>> -
>> -	matrix_mdev =3D container_of(nb, struct ap_matrix_mdev, group_notifier=
);
>> -
>> -	if (!data)
>> -		vfio_ap_mdev_unset_kvm(matrix_mdev);
>> -	else if (vfio_ap_mdev_set_kvm(matrix_mdev, data))
>> -		notify_rc =3D NOTIFY_DONE;
>> -
>> -	return notify_rc;
>> -}
>> -
>>  static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
>>  {
>>  	struct device *dev;
>> @@ -1402,11 +1383,10 @@ static int vfio_ap_mdev_open_device(struct vfio_=
device *vdev)
>>  	unsigned long events;
>>  	int ret;
>> =20
>> -	matrix_mdev->group_notifier.notifier_call =3D vfio_ap_mdev_group_notif=
ier;
>> -	events =3D VFIO_GROUP_NOTIFY_SET_KVM;
>> +	if (!vdev->kvm)
>> +		return -EINVAL;
>> =20
>> -	ret =3D vfio_register_notifier(vdev, VFIO_GROUP_NOTIFY, &events,
>> -				     &matrix_mdev->group_notifier);
>> +	ret =3D vfio_ap_mdev_set_kvm(matrix_mdev, vdev->kvm);
>>  	if (ret)
>>  		return ret;
>> =20
>> @@ -1415,12 +1395,11 @@ static int vfio_ap_mdev_open_device(struct vfio_=
device *vdev)
>>  	ret =3D vfio_register_notifier(vdev, VFIO_IOMMU_NOTIFY, &events,
>>  				     &matrix_mdev->iommu_notifier);
>>  	if (ret)
>> -		goto out_unregister_group;
>> +		goto err_kvm;
>>  	return 0;
>> =20
>> -out_unregister_group:
>> -	vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
>> -				 &matrix_mdev->group_notifier);
>> +err_kvm:
>> +	vfio_ap_mdev_unset_kvm(matrix_mdev);
>>  	return ret;
>>  }
>> =20
>> @@ -1431,8 +1410,6 @@ static void vfio_ap_mdev_close_device(struct vfio_=
device *vdev)
>> =20
>>  	vfio_unregister_notifier(vdev, VFIO_IOMMU_NOTIFY,
>>  				 &matrix_mdev->iommu_notifier);
>> -	vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
>> -				 &matrix_mdev->group_notifier);
>>  	vfio_ap_mdev_unset_kvm(matrix_mdev);
>>  }
>> =20
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto=
/vfio_ap_private.h
>> index 648fcaf8104a..a26efd804d0d 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -81,8 +81,6 @@ struct ap_matrix {
>>   * @node:	allows the ap_matrix_mdev struct to be added to a list
>>   * @matrix:	the adapters, usage domains and control domains assigned to=
 the
>>   *		mediated matrix device.
>> - * @group_notifier: notifier block used for specifying callback functio=
n for
>> - *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
>>   * @iommu_notifier: notifier block used for specifying callback functio=
n for
>>   *		    handling the VFIO_IOMMU_NOTIFY_DMA_UNMAP even
>>   * @kvm:	the struct holding guest's state
>> @@ -94,7 +92,6 @@ struct ap_matrix_mdev {
>>  	struct vfio_device vdev;
>>  	struct list_head node;
>>  	struct ap_matrix matrix;
>> -	struct notifier_block group_notifier;
>>  	struct notifier_block iommu_notifier;
>>  	struct kvm *kvm;
>>  	crypto_hook pqap_hook;
>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>> index cfcff7764403..831fc722e3f8 100644
>> --- a/drivers/vfio/vfio.c
>> +++ b/drivers/vfio/vfio.c
>> @@ -1083,10 +1083,21 @@ static struct file *vfio_device_open(struct vfio=
_device *device)
>> =20
>>  	mutex_lock(&device->dev_set->lock);
>>  	device->open_count++;
>> -	if (device->open_count =3D=3D 1 && device->ops->open_device) {
>> -		ret =3D device->ops->open_device(device);
>> -		if (ret)
>> -			goto err_undo_count;
>> +	if (device->open_count =3D=3D 1) {
>> +		/*
>> +		 * Here we pass the KVM pointer with the group under the read
>> +		 * lock.  If the device driver will use it, it must obtain a
>> +		 * reference and release it during close_device.
>> +		 */
>> +		down_read(&device->group->group_rwsem);
>> +		device->kvm =3D device->group->kvm;
>> +
>> +		if (device->ops->open_device) {
>> +			ret =3D device->ops->open_device(device);
>> +			if (ret)
>> +				goto err_undo_count;
>> +		}
>> +		up_read(&device->group->group_rwsem);
>>  	}
>>  	mutex_unlock(&device->dev_set->lock);
>> =20
>> @@ -1119,10 +1130,14 @@ static struct file *vfio_device_open(struct vfio=
_device *device)
>> =20
>>  err_close_device:
>>  	mutex_lock(&device->dev_set->lock);
>> +	down_read(&device->group->group_rwsem);
>>  	if (device->open_count =3D=3D 1 && device->ops->close_device)
>>  		device->ops->close_device(device);
>>  err_undo_count:
>>  	device->open_count--;
>> +	if (device->open_count =3D=3D 0 && device->kvm)
>> +		device->kvm =3D NULL;
>> +	up_read(&device->group->group_rwsem);
>>  	mutex_unlock(&device->dev_set->lock);
>>  	module_put(device->dev->driver->owner);
>>  err_unassign_container:
>> @@ -1315,9 +1330,13 @@ static int vfio_device_fops_release(struct inode =
*inode, struct file *filep)
>> =20
>>  	mutex_lock(&device->dev_set->lock);
>>  	vfio_assert_device_open(device);
>> +	down_read(&device->group->group_rwsem);
>>  	if (device->open_count =3D=3D 1 && device->ops->close_device)
>>  		device->ops->close_device(device);
>> +	up_read(&device->group->group_rwsem);
>>  	device->open_count--;
>> +	if (device->open_count =3D=3D 0)
>> +		device->kvm =3D NULL;
>>  	mutex_unlock(&device->dev_set->lock);
>> =20
>>  	module_put(device->dev->driver->owner);
>> @@ -1726,8 +1745,8 @@ EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>>   * @file: VFIO group file
>>   * @kvm: KVM to link
>>   *
>> - * The kvm pointer will be forwarded to all the vfio_device's attached =
to the
>> - * VFIO file via the VFIO_GROUP_NOTIFY_SET_KVM notifier.
>> + * When a VFIO device is first opened the KVM will be available in
>> + * device->kvm if one was associated with the group.
>>   */
>>  void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>>  {
>> @@ -1738,8 +1757,6 @@ void vfio_file_set_kvm(struct file *file, struct k=
vm *kvm)
>> =20
>>  	down_write(&group->group_rwsem);
>>  	group->kvm =3D kvm;
>> -	blocking_notifier_call_chain(&group->notifier,
>> -				     VFIO_GROUP_NOTIFY_SET_KVM, kvm);
>>  	up_write(&group->group_rwsem);
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
>> @@ -2006,7 +2023,8 @@ static int vfio_register_iommu_notifier(struct vfi=
o_group *group,
>>  	struct vfio_iommu_driver *driver;
>>  	int ret;
>> =20
>> -	down_read(&group->group_rwsem);
>> +	lockdep_assert_held_read(&group->group_rwsem);
>> +
>>  	container =3D group->container;
>>  	driver =3D container->iommu_driver;
>>  	if (likely(driver && driver->ops->register_notifier))
>> @@ -2014,7 +2032,6 @@ static int vfio_register_iommu_notifier(struct vfi=
o_group *group,
>>  						     events, nb);
>>  	else
>>  		ret =3D -ENOTTY;
>> -	up_read(&group->group_rwsem);
>> =20
>>  	return ret;
>>  }
>> @@ -2026,7 +2043,8 @@ static int vfio_unregister_iommu_notifier(struct v=
fio_group *group,
>>  	struct vfio_iommu_driver *driver;
>>  	int ret;
>> =20
>> -	down_read(&group->group_rwsem);
>> +	lockdep_assert_held_read(&group->group_rwsem);
>> +
>>  	container =3D group->container;
>>  	driver =3D container->iommu_driver;
>>  	if (likely(driver && driver->ops->unregister_notifier))
>> @@ -2034,47 +2052,10 @@ static int vfio_unregister_iommu_notifier(struct=
 vfio_group *group,
>>  						       nb);
>>  	else
>>  		ret =3D -ENOTTY;
>> -	up_read(&group->group_rwsem);
>> =20
>>  	return ret;
>>  }
>> =20
>> -static int vfio_register_group_notifier(struct vfio_group *group,
>> -					unsigned long *events,
>> -					struct notifier_block *nb)
>> -{
>> -	int ret;
>> -	bool set_kvm =3D false;
>> -
>> -	if (*events & VFIO_GROUP_NOTIFY_SET_KVM)
>> -		set_kvm =3D true;
>> -
>> -	/* clear known events */
>> -	*events &=3D ~VFIO_GROUP_NOTIFY_SET_KVM;
>> -
>> -	/* refuse to continue if still events remaining */
>> -	if (*events)
>> -		return -EINVAL;
>> -
>> -	ret =3D blocking_notifier_chain_register(&group->notifier, nb);
>> -	if (ret)
>> -		return ret;
>> -
>> -	/*
>> -	 * The attaching of kvm and vfio_group might already happen, so
>> -	 * here we replay once upon registration.
>> -	 */
>> -	if (set_kvm) {
>> -		down_read(&group->group_rwsem);
>> -		if (group->kvm)
>> -			blocking_notifier_call_chain(&group->notifier,
>> -						     VFIO_GROUP_NOTIFY_SET_KVM,
>> -						     group->kvm);
>> -		up_read(&group->group_rwsem);
>> -	}
>> -	return 0;
>> -}
>> -
>>  int vfio_register_notifier(struct vfio_device *device,
>>  			   enum vfio_notify_type type, unsigned long *events,
>>  			   struct notifier_block *nb)
>> @@ -2090,9 +2071,6 @@ int vfio_register_notifier(struct vfio_device *dev=
ice,
>>  	case VFIO_IOMMU_NOTIFY:
>>  		ret =3D vfio_register_iommu_notifier(group, events, nb);
>>  		break;
>> -	case VFIO_GROUP_NOTIFY:
>> -		ret =3D vfio_register_group_notifier(group, events, nb);
>> -		break;
>>  	default:
>>  		ret =3D -EINVAL;
>>  	}
>> @@ -2114,9 +2092,6 @@ int vfio_unregister_notifier(struct vfio_device *d=
evice,
>>  	case VFIO_IOMMU_NOTIFY:
>>  		ret =3D vfio_unregister_iommu_notifier(group, nb);
>>  		break;
>> -	case VFIO_GROUP_NOTIFY:
>> -		ret =3D blocking_notifier_chain_unregister(&group->notifier, nb);
>> -		break;
>>  	default:
>>  		ret =3D -EINVAL;
>>  	}
>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>> index 45b287826ce6..aa888cc51757 100644
>> --- a/include/linux/vfio.h
>> +++ b/include/linux/vfio.h
>> @@ -36,6 +36,8 @@ struct vfio_device {
>>  	struct vfio_device_set *dev_set;
>>  	struct list_head dev_set_list;
>>  	unsigned int migration_flags;
>> +	/* Driver must reference the kvm during open_device or never touch it =
*/
>> +	struct kvm *kvm;
>> =20
>>  	/* Members below here are private, not for driver use */
>>  	refcount_t refcount;
>> @@ -155,15 +157,11 @@ extern int vfio_dma_rw(struct vfio_device *device,=
 dma_addr_t user_iova,
>>  /* each type has independent events */
>>  enum vfio_notify_type {
>>  	VFIO_IOMMU_NOTIFY =3D 0,
>> -	VFIO_GROUP_NOTIFY =3D 1,
>>  };
>> =20
>>  /* events for VFIO_IOMMU_NOTIFY */
>>  #define VFIO_IOMMU_NOTIFY_DMA_UNMAP	BIT(0)
>> =20
>> -/* events for VFIO_GROUP_NOTIFY */
>> -#define VFIO_GROUP_NOTIFY_SET_KVM	BIT(0)
>> -
>>  extern int vfio_register_notifier(struct vfio_device *device,
>>  				  enum vfio_notify_type type,
>>  				  unsigned long *required_events,
>=20
Acked-by: Zhi Wang <zhi.a.wang@intel.com>

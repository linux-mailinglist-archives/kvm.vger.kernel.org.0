Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF1060F6FE
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 14:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbiJ0MSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 08:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbiJ0MSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 08:18:14 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3EB2250B;
        Thu, 27 Oct 2022 05:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666873092; x=1698409092;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ShT+ohHodXQdRMDxgmVsLbYg/HXuecdD39G5U/P15mc=;
  b=YwiK1w3egyPVaXZqkSwiHIxOVDXp598INdPgf9GnWBT4D92TiflnFtSv
   OoCr/NXnFjixEpZjT02xfcca5rBI6K/UMVLC/GnF8Ud3mZnDxs8i5PA+H
   TPskjfFvEwF4+4TdpxOcOIDFqsMCkbulDHqfhUApzR+N2x88U1luAoaEz
   WjFLgmGLlByc41kT2TV39uRMk4pA5qnq0rjWtKcicgbQU8iCWxffqmIf9
   0TAflx6Zu/k7G9yZP7ls/qS/hw/V3jbwimDlVTYvSVSeU+S6WAR8pglvU
   8e/h0IvA8AvMuOijVodqz6jeSuU61iCU3BVp7zzAEcazUN7sfS9mId2So
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="308200455"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="308200455"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:18:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737659058"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="737659058"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2022 05:18:11 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 05:18:11 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 05:18:11 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 05:18:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9tHSz4hOFzWwMQKsDDmuSN53G849YSmhqveEWxhlJk/kXstK6EVYg4+K8VKfI2UNmNiE7lH0qH5py7nSbxlMXis6l+8ymEmhg900ezeOhAwFj6MTaMNj8Up2RGl64ZqG1TnVbq2zA6/2LjHOARQ0zA3ReNBCzxgPtTJ29FkNxi9WIrCGDTUYVQrAITdXh/Ocsbk1tQPae15GnAQbk2XMm+uVDCTnZ6XpfWmlqoHUqe3VehU978DhVi8qQq4SdwVdujVnFCoFs9ocX51/2kWmO0PiKqkrfoHPr+n/QNfR+Df4xyrn/ObXSP5RunRyfkOxC+CpqUbFntZMLFomQSmgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dLW8M6epLTE/GeAjyX0aWHjo3NnvpSDls7i4nGS9IVM=;
 b=KINmd7YD4xQnVvWdTj+8EL4juvAoK6q+HnPJrfnc5cGXsO9cGnimCRPnpJ0uCwapHCME8jBlE0iRINPRp8p7V96hBTFxOHCJLmVePem8bavdKzKiKC2AkcYJiSIYY/lH0xH18F6NU5SS/dGv5fOrkiR6P9c+vkcC+i1t8WNDUGbHscPBnulr7Ch7j0tYaUv3yVCR3lsEJz0Q9v0eTE4cRsYRPuno7YVh0WPMg3YXH1k9kLSH46ykA4XScowwsTjPuMJae02sDX5LoGjVyE5uk6ODFaHod8K6DLU3MGlVtlo4OreACPj0z5yT+FdeL7CpfPfwL4IYYP5g1H1MRDtmqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 IA1PR11MB6444.namprd11.prod.outlook.com (2603:10b6:208:3a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Thu, 27 Oct
 2022 12:18:08 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%6]) with mapi id 15.20.5746.021; Thu, 27 Oct 2022
 12:18:08 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     David Matlack <dmatlack@google.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 00/18] KVM selftests code consolidation and cleanup
Thread-Topic: [PATCH v1 00/18] KVM selftests code consolidation and cleanup
Thread-Index: AQHY55yiwQJVciN2Gk26RCSAzzsjaa4hMvUAgACUSLA=
Date:   Thu, 27 Oct 2022 12:18:08 +0000
Message-ID: <DS0PR11MB63731F2B467D4084F5C8D9B5DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <Y1mlJqKdFtlgG3jR@google.com>
In-Reply-To: <Y1mlJqKdFtlgG3jR@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|IA1PR11MB6444:EE_
x-ms-office365-filtering-correlation-id: 7cdd2982-5f3e-4d20-0e39-08dab8154ef3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HAEN6YbOguu1hoGwO3UhMvkhoPIcw6V3qR3af5gMjRspZYVNNrXrwcz6VmtF1YUZ4BWoMXuxlansb2VFGoU3PED8sb1oIiZ9e/svq1+ONS2uXPxxtWPqPfHY+jPHARamSlrev8U2rifgfBwBSBg4AcbEWJjEZQj3QYsCYRgvtI4gpQiq7qQkveF4TsIUrwxsDltJmokxZeWhQLN0oQ/89WE/g8OWYg5mbEfe3WY3Smu1CbtC/7fTVWUZ1+GzKRKGidKMLBpNTH3SPpNKgrIprPVqg1MwT867PkL8u/9xA2F76eYXg3v1QgRbVPUVSCZ8Gx9VwcycBSRHGI4KkSDR5W2NsRNFR+U9fizpR7DbuEA26dFVZwj1VccaK0Iqv4Vc3pz5d8HjmlXZLAYU9LBD9u+JsFsY5wgLqeSeZ11C9IwprNM9XCB2gjBpdgLrwjChwP65vVYdIBDyE6rHqTU6UuO+cgUSE+QYo+I6DVzECF4Th/fHibQZ/ndjEV5KRSLWJjb6scxX8dnU5XEoyDT7I5VDbjjqFHDoxtd9+kNRFIEj51urRNb1nnYvCfZA1SJr8RNjl7+sJQwz94PfAYLX8wG4Nh2WKYPp9TCXqgam02ojp627ZZGlL5NnICtSkgCCuZ/ohwVfJ+b4Q7IysaaGmnr5F7fWHTykniEB93Cc8yaCuOhOIIwT1BTDfdSWw1D24Lx9kt04MWWp10qz3L3Gbm32pUBGLfjvcmUxXwdwBcTGz3osxAt8SRfww16FLi47
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199015)(38100700002)(122000001)(478600001)(38070700005)(71200400001)(6916009)(55016003)(54906003)(316002)(86362001)(9686003)(26005)(76116006)(4326008)(8676002)(64756008)(66446008)(82960400001)(41300700001)(66476007)(83380400001)(2906002)(186003)(52536014)(8936002)(33656002)(5660300002)(66946007)(7696005)(6506007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?L/uk+gD0k5D1jr4CWKGpmM3LWRrkUjlzvCP0YwSGDqI3y8gb9kGj1GNdzTLa?=
 =?us-ascii?Q?jhvnB2fDO9fxqB/sUkTgbEvjYDnK/BZU/j9aSum92Qkm5MWAU2z68z4oak5i?=
 =?us-ascii?Q?ToHqA60LZd4VdAyw6+zNQRvQ5YUGGWgFZLynF3uDdHDN9U48Jy1n0ZiT+ZQk?=
 =?us-ascii?Q?CeWyvgGUA+WLUbYwRftz+y6Ac2l7jsBweT/gK65CSdLbqMI5aUubolR8k3Xt?=
 =?us-ascii?Q?cSTCnXDAJUCyttGw6miU9AlY56HkoR0WaFrEpCPEJFZY5ejEJMEiZl3nU21s?=
 =?us-ascii?Q?a9iwa67UmkwDcRH8oJCGldV6IHt3TlWntQQKXXqqN8mpXPs3X0GhmUmmNz+Z?=
 =?us-ascii?Q?01vKTMlF4YBWtG9FMCWiS6UeU3sPq4giG1fl8XS+1tWoPI5/+Dyrpa2RPdy5?=
 =?us-ascii?Q?SlW/P/JqG/X0D7wpTyuS8QJWs/aZ9yF5lWZKFmIwxEAr6Lz5dhXXZwD5Pp03?=
 =?us-ascii?Q?vEcbWnIY9LidF7T9b6jy5BnmwJlICoSmJA2AxYo5Tk3uaqgU9Y5vi1jMjI5l?=
 =?us-ascii?Q?vOh07C5vMpa8ugl8osydoxbP0C+ht1nNT8zOhPsQCyPzg+C8cxYY3Bka/z1O?=
 =?us-ascii?Q?74Ki914H/lnV7uaFQ63HKeDrQXQxNzh2CFk5WAJ1tl9rcJNbY/JqJKDAw49m?=
 =?us-ascii?Q?NE+3WvBenUnukxrBzSHDUmkr4uIoidENwJlPDnStWxuZbB34UEDU6pkRH9EL?=
 =?us-ascii?Q?mEhoECS7t6Ve8U0+faaOoI5GERpX7JB+ET0RTed4PmqM+DhsHxiXNxS/zHTM?=
 =?us-ascii?Q?qlwPmlfrwW9FG81fIxQ39Uq5lr58w+f/Xlrjnnmtmu68JZfXGl+8/FJLZRPZ?=
 =?us-ascii?Q?BpRY6vyJILngiOXWDiUAkIOCukl3cIcYJuJWYVKeWr4BOUJFwdUYkuwdyYAW?=
 =?us-ascii?Q?WOulibibuZ61psTTNMw7/ANvgzRxzEOOnIACwYMRVHwdiAr2B5v8emAs5n/W?=
 =?us-ascii?Q?BoNgIr3/I9yK/CaZ1fOydigMMWmpyMBQmVK1ry1Je60hzJdh447bCahVXuNf?=
 =?us-ascii?Q?vup99Rhi3iG/pGbj+KgePL1z/pgQ5YhxcZlUhaE8llwB9Vpyfl16UBQns7LB?=
 =?us-ascii?Q?9JmWbyBmxBbKy9wpKBRkZPy672IOgZpCFXIqwvwjFV98WJQgGT870n+6elm6?=
 =?us-ascii?Q?wsk+W6seROd52pCXLFe1KDZo7qeh6EgkkIBvbMPkpcG0TvrmU7Im6rpGvAEV?=
 =?us-ascii?Q?vjeuZrNiBHMlOA3M+U/tsALizRJpSJNklrEEGWggZlbzNVOb3y7h761HrqIv?=
 =?us-ascii?Q?QLdWMSJZIiuDqnWCB2Wv7IIm1rlnEgvKK7uh41UcL24IZeeM4NQ1ZywROSj4?=
 =?us-ascii?Q?QYvqUpNtkSLm3rFlqDwnLDWdEldDsS8G7nR1IFWHxNkoe+nB7jpuFmL7J/MW?=
 =?us-ascii?Q?41vt1gOn55f9b2Hg+uKno/BRRrHhq98aq+ak+WsZ5xFw4GseSmIHpee0zgXN?=
 =?us-ascii?Q?a5rExSIoG6HfiuNGm2LxHPBgiQjLsBmCqotYF3uWJYUSreX73lkxVg3d1+9x?=
 =?us-ascii?Q?r/3VYUW4f2u89ruK3ysXFrgmdaH2khuwLmzIQPcCN1J99aKNGkBBNZV80tns?=
 =?us-ascii?Q?49KzlaOIIjWGhm2vYs66ukfX81Ific6VP8EEg0IB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cdd2982-5f3e-4d20-0e39-08dab8154ef3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 12:18:08.4253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5CYLt9bnPOxOksQqWQ82cFiBJHxKonF4BmapSt3usT/NjR4ss61sZrQOXSAaMbsJ2L5z8Eikrn5DJSxrUn9G5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6444
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, October 27, 2022 5:23 AM, David Matlack:
> On Mon, Oct 24, 2022 at 07:34:27PM +0800, Wei Wang wrote:
> > This patch series intends to improve kvm selftests with better code
> > consolidation using the helper functions to perform vcpu and thread
> > related operations.
> >
> > In general, several aspects are improved:
> > 1) The current users allocate an array of vcpu pointers to the vcpus th=
at
> >    are added to a vm, and an array of vcpu threads. This isn't necessar=
y
> >    as kvm_vm already maintains a list of added vcpus. This series chang=
es
> >    the list of vcpus in the kvm_vm struct to a vcpu array for users to
> >    work with and removes each user's own allocation of such vcpu arrays=
.
> >    Aslo add the vcpu thread to the kvm_vcpu struct, so that users don't
> >    need to explicitly allocate a thread array to manage vcpu threads on
> >    their own.
> > 2) Change the users to use the helper functions provided by this series
> >    with the following enhancements:
> >    - Many users working with pthread_create/join forgot to check if
> >      error on returning. The helper functions have handled thoses insid=
e,
> >      so users don't need to handle them by themselves;
> >    - The vcpu threads created via the helper functions are named in
> >      "vcpu-##id" format. Naming the threads facilitates debugging,
> >      performance tuning, runtime pining etc;
> >    - helper functions named with "vm_vcpu_threads_" iterates over all t=
he
> >      vcpus that have been added to the vm. Users don't need a explicit
> >      loop to go through the added cpus by themselves.
> > 3) kvm_vcpu is used as the interface parameter to the vcpu thread's
> >    start routine, and the user specific data is made to be the private
> >    data in kvm_vcpu. This can simplify the user specific data structure=
s,
> >    as kvm_vcpu has already included the required info for the thread, f=
or
> >    example, in patch 13, the cpu_idx field from "struct vcpu_thread"
> >    is a duplicate of vcpu->id.
>=20
> I haven't dug too much into the actual code yet, but I have some high lev=
el
> feedback based on a quick look through the series:
>=20
>  - Use the format "KVM: selftests: <Decsription>" for the shortlog.

I know it's not common to see so far, but curious is this the required form=
at?
I didn't find where it's documented. If it's indeed a requirement, probably=
 we
also need to enhance checkpatch.pl to detect this.

If it's not required, I think it is more obvious to have /sub_field in the =
title,
e.g. selftests/hardware_disable_test, to outline which specific part of
selftests the patch is changing. (the selftests are growing larger with man=
y
usages independent of each other).

>=20
>  - Make the shortlog more specific. "vcpu related code consolidation" is
>    vague.
>=20
>  - Do not introduce bugs and then fix them in subsequent commits.  This
>    breaks bisection. For example, kvm_page_table_test is broken at "KVM:
>    selftests/kvm_util: use vm->vcpus[] when create vm with vcpus" and
>    then fixed by "KVM: selftests/kvm_page_table_test: vcpu related code
>    consolidation".
>=20
>  - Try to limit each patch to one logical change. This is somewhat more
>    art than science, but the basic idea is to avoid changing too much at
>    once so that the code is easier to review and bisect. For example,
>    "KVM: selftests/perf_test_util: vcpu related code consolidation" has
>    a list of 6 different changes being made in the commit description.
>    This is a sure sign this commit should be broken up. The same applies
>    to many of the other patches. This will also make it easier to come
>    up with more specific shortlogs.

OK, will re-organize the patches.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3160973F435
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 08:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjF0GFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 02:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjF0GFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 02:05:45 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4431BEB
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 23:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687845945; x=1719381945;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b2bFdDZvrtj8oFqcV6IzknfkH1danL92dZotYGSNeco=;
  b=S2tfMJbqqR/DS0vq7w0Y6L1gxgNV+fjdaNyvmAoqSN1EMMd/C2CwsDem
   U2IRgZ9zsKQasRV/zg25aVwsN9Ijzast4cYLDx1DA4Zed/9/NgD7+JyL8
   rFgeSr9DhamsfURQgDlGChBF45G3tEyn2gkiR9YXXZvPvU0OV63YyvTd4
   vnxmwq6NVRTbyeaQhRHAtG8X/tRkR6nbQQkrS62IYsD8u9QBmE9rpDuy8
   hHdLrHFPa4+OfAV9ePIVvgM7fLH6lLVHD5MLvkJxWTLGT1ESlUSnGlx6t
   FcNvGXnOAKpflo7Rc35FMtki8pPaT6lzL2fozxBPH70QqJXO1igdCZvxH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="391954970"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="391954970"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 23:05:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="746090034"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="746090034"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 26 Jun 2023 23:05:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 23:05:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 23:05:43 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 23:05:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jmibf43m6UmW94wAu78gODkPA5ZuyQBZU7peu61BvZJuKNSXAiRd3fEVhL7i5iMKIJG1G0gxmMBfMAU2N5/oQAstpaGRVSPTteatiHkoMF3TxLhpkQjq9yaDlmcfbnNhmbTRV9iRF5nyRzaosrrR4ZcIsiy+ERC8odvIbqdOQ1cIevaLVzqKujCHO9zN/ugJgd6KcAqxCveMYtuUi+Fzo1FKBtBHIWydB26S29C/vuv8T5DnhDw6SBCULp09rvmWG3BdMSxdeQlQbT5u/5hH7VXL2VJimERVK/qRTQKmTtFJvIaeZsgtRpbsZ0lHEDCGrHxWbnghrzUSxrBOyOS66g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UE3mgd7YHn5m/ppkkRfXCQxpiFDJ8UcE2396SYPJrzk=;
 b=SC2mofTnuIjh98iWyLIrCKvmD2nOjZPa3IVSQ+xiOsi6KTn22esKM2+bdpFDXN1kHQH9Bf1WOItS4Dt06EIw9KS66Ma/m8Me0ybd037+M48g/vH7S3rHXsPR8soGFccpaQv9LvJF/rrtNOHw7YSB4pdrWe5BqaT4Y1wcAIDzpA+erIDtH1+k80qLcBD12X2o1pO8oYLrY3pCWBQuWlV7ZJcHh9du2E2WWazU/AaaedhNqtpgIINMenH4BrD5FT9LEH4TufRj/lR9748qBTr6Qe2gWZQTaXPlWo7CIsem+HVqyRLP6whiGrKJBOgfDlPGTttVYwXW9/6U6p2RgtKdqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB8327.namprd11.prod.outlook.com (2603:10b6:806:378::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Tue, 27 Jun
 2023 06:05:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 06:05:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Eric Farman <farman@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>
CC:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: RE: [PATCH] vfio/mdev: Move the compat_class initialization to module
 init
Thread-Topic: [PATCH] vfio/mdev: Move the compat_class initialization to
 module init
Thread-Index: AQHZqDNQW0qxtO7DTEq1FzUAnFmSfK+eKlKw
Date:   Tue, 27 Jun 2023 06:05:41 +0000
Message-ID: <BN9PR11MB5276AE1AA07FA571D2A67A528C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230626133642.2939168-1-farman@linux.ibm.com>
In-Reply-To: <20230626133642.2939168-1-farman@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB8327:EE_
x-ms-office365-filtering-correlation-id: 7588f387-2843-4380-52eb-08db76d48996
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JLUBYIMvq4UPw7eMztGJQuIM0rPr/+58yjaqmd0bRh7eApo/exShLHV8t5RItZsXnX+D/Z/ZohRPPOIAkDW/minwTdyZAn1LbY83BvBhydWRhIoh8C9R8FyrOOVtYm5tMX1BX9rrmbPjaLogQ+8f2zh85kw8CpfQhmEhUEi9RR+uLsndX4g+iwuilIVUDpegLyr7FuV9vwoeL2JIaWkmDUOikTt9BNSQzwwokiyuZFt02RtHgGJbt9jNxM251+MOkJdrhjIbo3z+dxxDWxDqMwmLumQXW8vqokmT3+4KVM53o4UxkCOrr+20cpjaUEw7DUvjWPNd5xUl5J24y+nvdo1KEEOxGI9VULOb11mp4acxp//oZ6L8hqlGueRD7A1tDvmhYBPTg8aXWuwXnq+ldgjIePOh0LZWLcEzFbNF9W/eOzzSOxzTIYlPDwcHXLVeC4i1Yt8t1/FcyyiGfNKLPLPNSgtSeE9l4oCTy4y3udq/wNgnHYKc99DEHbS74l+Gt3PH1615x1s8cuW26xjMDjl+x3aQx6vlaSKEIikNjRWAaPMxiVm7nNHdYgsMcIvHLWds2teflowuigQmVAffEyZkk0xvUNTkDb1tLQM3hTA9rDF5fd57KJygWnUiGXBE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199021)(33656002)(5660300002)(52536014)(76116006)(4326008)(64756008)(66556008)(66446008)(38070700005)(8936002)(8676002)(86362001)(66946007)(66476007)(41300700001)(55016003)(38100700002)(122000001)(82960400001)(316002)(9686003)(6506007)(2906002)(186003)(26005)(110136005)(71200400001)(83380400001)(54906003)(7696005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OY/QBjGRvTXEF+HfrgFxFPgTnnSDb4JNq9A+XV2Iq1sh9nI2c/M6mIr6zyVM?=
 =?us-ascii?Q?boxpg4gbWcLkzpOmeDC3cczVmXESa7eFPm/E/Cm18AMrdA1kJpDQNzW0K1Az?=
 =?us-ascii?Q?mfDk/UHXpCwaW1+blfsazjieHhPpy7LDXUmez9CSCsyqp9FI9dO9reN+FE/d?=
 =?us-ascii?Q?JAUj+iBlV7zMrdeV3XOFGxEOcMuOcX4HJpz18sAT1lSje+I79y8tl0PYyHeL?=
 =?us-ascii?Q?CGWgnmnCQnXzakhgYqllMVJB8QqN5sj/IttDAV9KDyQQVqqckihrlHXQ1Hom?=
 =?us-ascii?Q?hF52plpmSzHFY5MSIomQ60Qnm8LHr3vDZO1YRl8ZzIJnQJHhRQua2Hj1p7Mh?=
 =?us-ascii?Q?+0jngWAsebGKqxoYPfZ1Ee8W4itT1CYtEt4kkOqZ992gfb3rNqlWwv7V3k8H?=
 =?us-ascii?Q?SNyfLux+yFSJrnJqHingqiQdbcAG7oz3i6ARcsYSNcLaUWhiXg0Z02SAmMn9?=
 =?us-ascii?Q?1PQYRindZslYCTBVR3CUJnI54mzOuQG9p7nr5gC2ojOTw3V59M1GfqY3QA5p?=
 =?us-ascii?Q?SFM/BqrgnM4C6LHFmA7zLrQWk82Wv4HZBsn5KaSjZfzF6/BTV2ln0SFvgVMg?=
 =?us-ascii?Q?GKCAQ/cIPJ72rGJ55UTsFD8b4xAJHj28kfvc1M9NyL1r+fGiC7H2zmzwtJ5L?=
 =?us-ascii?Q?7sibULNyVa991l36ZhXQgiO9NFjXECHz2m6Jmbdbi9MWhpZCS1HzsJ3Sc0aX?=
 =?us-ascii?Q?mGvGnqsjpw5Rpnn6KtOZkCIcP6ZBZsA3FTWRHPuM9ZExbalkkcyw4/aCOWgx?=
 =?us-ascii?Q?bTg01KawqrwwUpguFSGpTaaTOHmlSOolf5Hffwq76ORfUBN5ElNnOY/Xyu4H?=
 =?us-ascii?Q?nrLe4ARGrdQMtaa0EzGGUL7ZkQnFd+GYLi31upMKtkqyvZ3yOo4tRtf8vN/v?=
 =?us-ascii?Q?XnwuddbglEKed2JF41xdT74w9aqCbIROEEqMpBCiEwsakg+yFOdV8730FSLl?=
 =?us-ascii?Q?e8GPKNw0u5iFUo52asO4LMiiAflali/x6KM6V/4DYdwOH/nbAUSLZRru5WRe?=
 =?us-ascii?Q?JmOhS+UCq+kj+k/prN5mFXAImjSYjeFqvHMuBYadZYjsjKdtRIhKp025SrEf?=
 =?us-ascii?Q?/fEGaRV2bDhgNKiIh0eK9IwGk+spAXqXd2G9He4mQE8VIvac936RD/C+/6z5?=
 =?us-ascii?Q?o0puOIqx9vAsQ/dDXzb29wfVrqbdOFoNJaNVxmyz1+nJuwZrHOKA18qSAZgO?=
 =?us-ascii?Q?mNVq1L/NS2r0VadKYPNyyVr2+mGln2z5HTBW+pvYOc5VGA0cgfs3PBASrftZ?=
 =?us-ascii?Q?nsFAVxh5fG3sF3uv8jgwa+SCmDPsgmF8LUpNAWtprCRySPM1r+fbEPtVQxLJ?=
 =?us-ascii?Q?Wapfiy+2L9MS1aaoXJwWDOaKnbzvW0gZ4NXRsc5FO6jDZzKRbj5N5jUE4vYp?=
 =?us-ascii?Q?fQvvu2Quj+uzYpj+fdU7xbfAtJqwGfnZwvpzRsetAA8DNzCmWz+iOc8mahqM?=
 =?us-ascii?Q?AvdleAxnBwS3/QA6UFgFEXKVsfiEsrfbS/XeIeJUUrzcnxKovIrRud2ToYpI?=
 =?us-ascii?Q?VMH8I3xxay/nUI1faBdwO50oWdCPYlxeoEAjePUPCxb54Vs6rtN5ODInJv4/?=
 =?us-ascii?Q?jmORlovg87tXHs3/z2oVB4cEdgbCQKoWpU/au0Yv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7588f387-2843-4380-52eb-08db76d48996
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 06:05:41.6081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AAWhclDDf6QulLkAKdKvouz79+uYP2cXqg9juH29pEKhjWfe1yu7xCqRCKyZD9AYDuQdLJcmE0GjNuc0ZKjddg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8327
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

> From: Eric Farman <farman@linux.ibm.com>
> Sent: Monday, June 26, 2023 9:37 PM
>=20
> The pointer to mdev_bus_compat_class is statically defined at the top
> of mdev_core, and was originally (commit 7b96953bc640 ("vfio: Mediated
> device Core driver") serialized by the parent_list_lock. The blamed
> commit removed this mutex, leaving the pointer initialization
> unserialized. As a result, the creation of multiple MDEVs in parallel
> (such as during boot) can encounter errors during the creation of the
> sysfs entries, such as:
>=20
>   [    8.337509] sysfs: cannot create duplicate filename '/class/mdev_bus=
'
>   [    8.337514] vfio_ccw 0.0.01d8: MDEV: Registered
>   [    8.337516] CPU: 13 PID: 946 Comm: driverctl Not tainted 6.4.0-rc7 #=
20
>   [    8.337522] Hardware name: IBM 3906 M05 780 (LPAR)
>   [    8.337525] Call Trace:
>   [    8.337528]  [<0000000162b0145a>] dump_stack_lvl+0x62/0x80
>   [    8.337540]  [<00000001622aeb30>] sysfs_warn_dup+0x78/0x88
>   [    8.337549]  [<00000001622aeca6>] sysfs_create_dir_ns+0xe6/0xf8
>   [    8.337552]  [<0000000162b04504>] kobject_add_internal+0xf4/0x340
>   [    8.337557]  [<0000000162b04d48>] kobject_add+0x78/0xd0
>   [    8.337561]  [<0000000162b04e0a>] kobject_create_and_add+0x6a/0xb8
>   [    8.337565]  [<00000001627a110e>] class_compat_register+0x5e/0x90
>   [    8.337572]  [<000003ff7fd815da>] mdev_register_parent+0x102/0x130
> [mdev]
>   [    8.337581]  [<000003ff7fdc7f2c>] vfio_ccw_sch_probe+0xe4/0x178
> [vfio_ccw]
>   [    8.337588]  [<0000000162a7833c>] css_probe+0x44/0x80
>   [    8.337599]  [<000000016279f4da>] really_probe+0xd2/0x460
>   [    8.337603]  [<000000016279fa08>] driver_probe_device+0x40/0xf0
>   [    8.337606]  [<000000016279fb78>] __device_attach_driver+0xc0/0x140
>   [    8.337610]  [<000000016279cbe0>] bus_for_each_drv+0x90/0xd8
>   [    8.337618]  [<00000001627a00b0>] __device_attach+0x110/0x190
>   [    8.337621]  [<000000016279c7c8>]
> bus_rescan_devices_helper+0x60/0xb0
>   [    8.337626]  [<000000016279cd48>] drivers_probe_store+0x48/0x80
>   [    8.337632]  [<00000001622ac9b0>] kernfs_fop_write_iter+0x138/0x1f0
>   [    8.337635]  [<00000001621e5e14>] vfs_write+0x1ac/0x2f8
>   [    8.337645]  [<00000001621e61d8>] ksys_write+0x70/0x100
>   [    8.337650]  [<0000000162b2bdc4>] __do_syscall+0x1d4/0x200
>   [    8.337656]  [<0000000162b3c828>] system_call+0x70/0x98
>   [    8.337664] kobject: kobject_add_internal failed for mdev_bus with -
> EEXIST, don't try to register things with the same name in the same direc=
tory.
>   [    8.337668] kobject: kobject_create_and_add: kobject_add error: -17
>   [    8.337674] vfio_ccw: probe of 0.0.01d9 failed with error -12
>   [    8.342941] vfio_ccw_mdev aeb9ca91-10c6-42bc-a168-320023570aea:
> Adding to iommu group 2
>=20
> Move the initialization of the mdev_bus_compat_class pointer to the
> init path, to match the cleanup in module exit. This way the code
> in mdev_register_parent() can simply link the new parent to it,
> rather than determining whether initialization is required first.
>=20
> Fixes: 89345d5177aa ("vfio/mdev: embedd struct mdev_parent in the parent
> data structure")
> Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

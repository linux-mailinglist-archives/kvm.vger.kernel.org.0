Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F85657A751
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 21:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235565AbiGSTjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 15:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiGSTjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 15:39:11 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F68045040;
        Tue, 19 Jul 2022 12:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658259550; x=1689795550;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=nohxgLSDBgW6fz4v1285lXi8oIxqvKXW6CYfq+7wIiw=;
  b=figeyOZBmj8cWvHAejHPIPypLw922trjG6nFrOcq1q5aQ4GdYMVjB6FR
   B54/ytf9qsUw76d/XWiMvfmzIk+TvvoTM5OP7U2t994lGoonDsWsPntyb
   WxgaPgkOzs1dtCtjUxFzVqMZLNPG/E0UQrihAFZN1lRhOU9DbE4FKYWHZ
   L6H9HJn0JP2kOVtH/euIpdJV5Dof1le/jChDZvruT2fE277py36oM+LJj
   dmYfzQ4vVl2JXQGA7wXLTHfNAqVbBVmCPxjZ4+Efs7gC3js0t4KcMKGmS
   MBpCXjDLIHUPiK5Yg1uU1jUzNKMxj5dsZjgPgtwNIhVM1TkQhPNevtkLc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="348277233"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="348277233"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 12:39:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="572987522"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 19 Jul 2022 12:39:09 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 19 Jul 2022 12:39:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 19 Jul 2022 12:39:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 19 Jul 2022 12:39:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWyysbzwKTfZdZ4m4HDLLcij4Sz2Lm4uwgjX9WNQTsY0efvgbuTc2vX6eoH3H71Pm+p/lG4N6eRsY5ozssJ+0ZpaU8T80XBdpDagW3f5sa0ffrY6ldMvTjrsqfnQY54Bydj+aJQw6b30Hpdl5S2Rcvxit41cB2Ozze3UaBc37fkTFxsW40mcWd2tKh+KU00QBxkG2FKeJ/z0xz6jQ9H3MtUbEG5chk5yzKJetpXr7I5XKC/LsyFOTiZ9r5vNmbM+CxP20zwL7GL8+g/z+dzZKlvpw/+krdRHebZoUyQ7W3xNYnaDyYHV7cCkrt6KdSA554FNAcnTtFU206mO1CpGnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ET2MYeg16EkfJSWeNBdW7y8qVPPZu0zfzjDm+xx/F0w=;
 b=cumYlCtH4Alf+thvl+En4okd7lYsZyX2ivhgYaQwPxR/nJZWFGcgiCw9500W3Pu4TCFArkK8f5UvlE9qmdnIQt25u5lqJyrIYr025k50DjDnfRr2KrRSRhHBuIKy1Wexkx6LpdOOZq8Lv+kePPcKTTvotRD0RYPpgi0l5YR4LGP98LZBJ1zG1DYxyu9P5tcEsxCs3+LGYMoAWGrmsO2GjML3s9kWjHPnDi3Mt1wlFIsBu8vgZt6Cok4r972bpPNo/Oct2QwfX7b3c2Hg2XdV0O6GKfoq/13+zKlEcRqp10tswhHabgvTvuC3MQkWqKAKDAIHchuGcgqj0/1cF27OTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM6PR11MB2795.namprd11.prod.outlook.com
 (2603:10b6:5:bf::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Tue, 19 Jul
 2022 19:39:06 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5438.024; Tue, 19 Jul
 2022 19:39:05 +0000
Date:   Tue, 19 Jul 2022 12:39:03 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <len.brown@intel.com>,
        <tony.luck@intel.com>, <rafael.j.wysocki@intel.com>,
        <reinette.chatre@intel.com>, <dan.j.williams@intel.com>,
        <peterz@infradead.org>, <ak@linux.intel.com>,
        <kirill.shutemov@linux.intel.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <isaku.yamahata@intel.com>
Subject: Re: [PATCH v5 07/22] x86/virt/tdx: Implement SEAMCALL function
Message-ID: <62d7085729358_97b64294f2@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1655894131.git.kai.huang@intel.com>
 <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
 <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
 <5ce7ebfe54160ea35e432bf50207ebed32db31fc.camel@intel.com>
 <84e93539-a2f9-f68e-416a-ea3d8fc725af@intel.com>
 <6bef368ccc68676e4acaecc4b6dc52f598ea7f2f.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6bef368ccc68676e4acaecc4b6dc52f598ea7f2f.camel@intel.com>
X-ClientProxiedBy: SJ0PR05CA0170.namprd05.prod.outlook.com
 (2603:10b6:a03:339::25) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 641b549b-2ff9-4655-60f6-08da69be574d
X-MS-TrafficTypeDiagnostic: DM6PR11MB2795:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DP9cQExpBQlAeexRUZmeh+1CzH8DcxKMEpaaUPtTJ3khvVYVIhisNViohk1dJy/ouupNe46h4LwEa5Ggg9GA3qajaamY6jpmU/CqzVfWW3ynmnXb9fuSlbH4AlUfpqo1FF4YeAF09Nnx6RMrzM+3xyQgVj4FPvYsieEXAL4NC6PloghnMBQl6sK3j+D2O6SKPeKPEKr2kZ9c0ZaIsjQU5SQzWwJ01ThSNr8ZDoQNvarqIy/4MoTJIW/EuRAM9UwQKmrYCctwYqtzsSOKke0MOfxEtaOR5l/9ZaPJCrnI2FckUylqBEudmOaV+gdsSGJHw2AF201u4XJcrkPC+PNSSVQ4A86hznGec9kgUhPbvTbw4r2VThLbR8HeGXvhWIyBu/VvbpxZTKZqF8gIJMLEGgKuuUoE/IRr/JWA4syzKDXlmRWM/2iq/rzdmTMAxsNkTADvKHBzuq+0c1ngSd9vo275PlyE3FqjxJJZitLtvaVeiv6deYndua0KYQgfLlRAZdSFB9r7wLjL+wuYIKrlxTERAaFpP+PxEekb972Zl3D+68Fnk56Jkk0t3jxHGrmbYydRpRjZVfvOguHKPVxSrLvmacjmIpuooQucLi0IIrNbCmEE3QC3k2BxnQIhXdY6RYCmEECB/Olr8fubC/1FmoOneA3l6WUGhHl3IQFz4912/k45pkxThAzCLvGnP+xxdBx6MB5Y7u2m45v8cIywI6F2yrXGBhPQsf7yIr/AsiAdi7Z7xLO9FD5j7bMFDBI7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(136003)(366004)(396003)(376002)(8936002)(5660300002)(2906002)(110136005)(8676002)(4326008)(86362001)(316002)(66946007)(66476007)(186003)(478600001)(9686003)(6512007)(6506007)(83380400001)(26005)(6486002)(53546011)(82960400001)(66556008)(38100700002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?4cs0MUYitlAO5kCNOh3UBIBgDdx2mcDXaeYxdFQQtYqHevPnJv9b9vSn3C?=
 =?iso-8859-1?Q?yzOB438D4Gi77NtPGC1q9BwI/U8L7jgWA3FghBwHE1aRebYJZHHYz6wU8r?=
 =?iso-8859-1?Q?rJEC/SfpSXHOmG5BRyc48CZTVWa4RfCvovtzBnFCobtBY3ZaoL9AH/09Vs?=
 =?iso-8859-1?Q?HSOgWKXy4wKHjZB7MaWPICsY01fyPFhcacY5PsOYd8fiDYwK2n5zAAV43E?=
 =?iso-8859-1?Q?y3y7siL4OSIiPXM5vFzo0mVL+TRsoYaMwwR7kqbEHK6ZuPN3WD0V/ad5oV?=
 =?iso-8859-1?Q?DiINqZGqWi3PoVOAAf+lVOiIVhwZImgcrtUYNJdHqVsMHMfmvG/BcixU01?=
 =?iso-8859-1?Q?PDdMAcGaMq6t9FgAj9K/KGyoBHdqXo7xv49SGoht7+c/PWbDkehZ5mEPWu?=
 =?iso-8859-1?Q?T4H0u4Bs/ilOIf+oaEfRxF/8AWBhyLChKvspyVHucpSGZp1EUJGGheAyGb?=
 =?iso-8859-1?Q?UZxNgYZ125M50E7o9Gvj8DIt4BGLuryySdelJWFT11kaAKCmWknezENqpl?=
 =?iso-8859-1?Q?kchezpW/SJSzM9QKR2O/4Oauc15xE8Y4vEZ7uNGnuzwGpp+PpFB2itYU6+?=
 =?iso-8859-1?Q?RxIHhPyBzN1JX/9j+dED51QMOOlf4Mal3dA1PrKNKRmESOFkIbWULJeGso?=
 =?iso-8859-1?Q?JsnoR0ipQ2OdFpecZSKoOUSwCaDaWDzTAWEmOkvegMdezBpqvYkO5d9sIU?=
 =?iso-8859-1?Q?G9l3919Z+h07mNWu0BAj5XFXVEsGg8X+owtD3zn1ftpZdpGV0E44FN4amE?=
 =?iso-8859-1?Q?Ou4vDSo8Jmyn8cP18pHPMNJreBt/3uW4K+bq0xqIf5oNeVD8RfdeRQt+OF?=
 =?iso-8859-1?Q?bE8P6WgVrm0vAhcdJjoCXh0jYGziNu0RVq0jSIQDQZZbZkayiF3TYb9tVq?=
 =?iso-8859-1?Q?wWGoKsa2P6TXCC1l7wEzUr8piKHwj0/DC1FftDaz/ZCPa5xuQri5SK3o7n?=
 =?iso-8859-1?Q?BgNRAOBY7rWK+bxbKybiV+4FxODlz38XhQi9qsIQHxBZVl1lpJhpOzr6OP?=
 =?iso-8859-1?Q?pRdkKHuytv3trmGcl2/x48jCwwWhfW0+LzruCodBjGvJGwijW6ePY0bxGr?=
 =?iso-8859-1?Q?ByohSNn7HDXaCBTvrx7TEdnNKUpzH46RLqbB1nKE4f5BzXr4j5Rnu29jLa?=
 =?iso-8859-1?Q?mcT5kPIuirixn1B39iHug7yOwwqDv+FmNfwHj3xr0kpwne2aeT9nifjvRU?=
 =?iso-8859-1?Q?TSMd4xiCMDTNVYHPC8Fihdd2UracuWXZWYdJj9xinIHRZ0tvWLUEqATYIe?=
 =?iso-8859-1?Q?EVVwcO6S1v5YPOCwi6hlirkz7rq4kK7iJDo+LLP/m6+1KEHeynXE1+QUeF?=
 =?iso-8859-1?Q?/gN9lrZXnNCE1jvaE7Dt5HmNsm8mlJi0GANvC+yz2bJExIuUyMzATWJq6l?=
 =?iso-8859-1?Q?+zDqFR2v9pyOxRhUFefoUObRKcVu4+Jlp2j4bCtIRQcxn+QwJ7ECEahjMQ?=
 =?iso-8859-1?Q?eCxwrqTKhi5LR/cje7cDbh0wdVl2s/Xp1EMUcnH+8hxLJDLVt9mm5ben9p?=
 =?iso-8859-1?Q?NjCimCq16ceYphrEP71mRRUg7OO9OYMZ8ONRs/gt658cVmioMDxtscBYCa?=
 =?iso-8859-1?Q?jeA/yRyViKRK8Qd3sVbDkjQsPtiU1CEIZ3hVDuwixss7JyfD8/g4hYT+LH?=
 =?iso-8859-1?Q?xPtotXFnON6+bTp6LJOtT37iHwyBGsbFjEcDPHsoyyeALcLhCLrwgjhQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 641b549b-2ff9-4655-60f6-08da69be574d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 19:39:05.7925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VrqBe7FwZJ7Lw+vX5WCmdY2WmLWDU/A4pAf/bHQPfJAeid7XYVomm2gbHwPy5SRBNtwT82oR7MURkxmWkSIikDtl1qzsaOgCmlPDCsjKMqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2795
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kai Huang wrote:
> On Mon, 2022-06-27 at 13:58 -0700, Dave Hansen wrote:
> > On 6/26/22 22:23, Kai Huang wrote:
> > > On Fri, 2022-06-24 at 11:38 -0700, Dave Hansen wrote:
> > > > On 6/22/22 04:16, Kai Huang wrote:
> > > > > SEAMCALL instruction causes #GP when SEAMRR isn't enabled, and #UD when
> > > > > CPU is not in VMX operation.  The TDX_MODULE_CALL macro doesn't handle
> > > > > SEAMCALL exceptions.  Leave to the caller to guarantee those conditions
> > > > > before calling __seamcall().
> > > > 
> > > > I was trying to make the argument earlier that you don't need *ANY*
> > > > detection for TDX, other than the ability to make a SEAMCALL.
> > > > Basically, patch 01/22 could go away.
> > ...
> > > > So what does patch 01/22 buy us?  One EXTABLE entry?
> > > 
> > > There are below pros if we can detect whether TDX is enabled by BIOS during boot
> > > before initializing the TDX Module:
> > > 
> > > 1) There are requirements from customers to report whether platform supports TDX
> > > and the TDX keyID numbers before initializing the TDX module so the userspace
> > > cloud software can use this information to do something.  Sorry I cannot find
> > > the lore link now.
> > 
> > <sigh>
> > 
> > Never listen to customers literally.  It'll just lead you down the wrong
> > path.  They told you, "we need $FOO in dmesg" and you ran with it
> > without understanding why.  The fact that you even *need* to find the
> > lore link is because you didn't bother to realize what they really needed.
> > 
> > dmesg is not ABI.  It's for humans.  If you need data out of the kernel,
> > do it with a *REAL* ABI.  Not dmesg.
> 
> Showing in the dmesg is the first step, but later we have plan to expose keyID
> info via /sysfs.  Of course, it's always arguable customer's such requirement is
> absolutely needed, but to me it's still a good thing to have code to detect TDX
> during boot.  The code isn't complicated as you can see.
> 
> > 
> > > 2) As you can see, it can be used to handle ACPI CPU/memory hotplug and driver
> > > managed memory hotplug.  Kexec() support patch also can use it.
> > > 
> > > Particularly, in concept, ACPI CPU/memory hotplug is only related to whether TDX
> > > is enabled by BIOS, but not whether TDX module is loaded, or the result of
> > > initializing the TDX module.  So I think we should have some code to detect TDX
> > > during boot.
> > 
> > This is *EXACTLY* why our colleagues at Intel needs to tell us about
> > what the OS and firmware should do when TDX is in varying states of decay.
> 
> Yes I am working on it to make it public.
> 
> > 
> > Does the mere presence of the TDX module prevent hotplug?  
> > 
> 
> For ACPI CPU hotplug, yes.  The TDX module even doesn't need to be loaded. 
> Whether SEAMRR is enabled determines.
> 
> For ACPI memory hotplug, in practice yes.  For architectural behaviour, I'll
> work with others internally to get some public statement.
> 
> > Or, if a
> > system has the TDX module loaded but no intent to ever use TDX, why
> > can't it just use hotplug like a normal system which is not addled with
> > the TDX albatross around its neck?
> 
> I think if a machine has enabled TDX in the BIOS, the user of the machine very
> likely has intention to actually use TDX.
> 
> Yes for driver-managed memory hotplug, it makes sense if user doesn't want to
> use TDX, it's better to not disable it.  But to me it's also not a disaster if
> we just disable driver-managed memory hotplug if TDX is enabled by BIOS.

No, driver-managed memory hotplug is how Linux handles "dedicated
memory" management. The architecture needs to comprehend that end users
may want to move address ranges into and out of Linux core-mm management
independently of whether those address ranges are also covered by a SEAM
range.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63ABC796E4B
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 03:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244891AbjIGBEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 21:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242016AbjIGBEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 21:04:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614F819A9;
        Wed,  6 Sep 2023 18:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694048669; x=1725584669;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ukqXqZ/mqq2LnT5QhHoGsuP4IfRdhooUCK99jgoz/yg=;
  b=EGuxQsOUhSc71zRNgTmL9UkKAGi8cuy7Hd1qbkPQzMHhBrPEaZiBXmXT
   RDMhH7KmKdG4rB/1XNL3KfG41FPjh7/Up6UWgicTGlTtpgIb1zzgP2qXD
   pw7oWwwZip8o7GSNzjR68SiOjDI8v+pH6jSZJWyG7r6O2X0j/Kok3FSTk
   YjwMYn6xjNpaCaPB3dDEGEU/8+jjftmA1974IYGrNWdcq8zj1uknYiuKW
   yFsZfuMRdwwKyUo8fMKyVVmxF6B0e656udYVH/HvaJ9j2lUyi2RimefrO
   cLgBvObAusIqbgGGyKYcm7lo33AYFJLbNGnkCyl8BDa4BPlfbC38B/G4+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="463605900"
X-IronPort-AV: E=Sophos;i="6.02,233,1688454000"; 
   d="scan'208";a="463605900"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 18:04:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="741795063"
X-IronPort-AV: E=Sophos;i="6.02,233,1688454000"; 
   d="scan'208";a="741795063"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Sep 2023 18:04:27 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 6 Sep 2023 18:04:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 6 Sep 2023 18:04:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 6 Sep 2023 18:04:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 6 Sep 2023 18:04:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFL/qt+nfFZo2gmlD9OU1+GDkZU0TfTLqS7cWoU2/9TUThHdoPdMtsxd3JcJM5sVdZyGpUYmHKg92TIgx6YgQWTNa4p5tlTjNT9cwKOlUwaefotUdr6+smEveQWBFjl1iGOW/PP6ANeuY14VdsSKCFgzdpU0u16n/UqDRQkB6L4YI0F1z6+VS7MRdD5frql/elpCah2Q9mzycXcUHDssj6SQ1W/cIFvdYnsUNuqNso1jOXNmmcBpIaIt1jcxDUtVufZoW2gLg693T2QleIbArqDLjCgzAZU0+LDWt0qfyyHVfMW4aQawGvJeh47wQClkPiyMDN2yw0b/1EP13Zf3xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/hXZLyfNrNuuW3/446LxsAEDZxKcdE/SlQZmzJOvkWU=;
 b=laG58Yc3dMta/a9irdXCGgiAtreXTpaBSifNAAADUbENOPVIfrEnreR4y7MJy9mhfryu5Ral40b6QXPj8RfW/laM8+ptXthWB45jnNJfBINyL0ODelu4wzSRnkfT/Bicxnop+Lt1N9ziF1cwL+TFUbUwL3dzpr7UHygVXAJnlaba6ZPJG6128xmbckgL4noZ/zne5izyUvnoS0/fNzDtGBALSLRqOL4GZ1v73V+XfxJm+uyWZW4/YRWsUGeGv0Xr9yo0jOOdXJqmdZhIdDjl/5S/UFtYPfiaZSDhHhx7BALYP7c0qxa9psXzY2oBlarO6+VzNKfg0T597HwyWtkLBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB6669.namprd11.prod.outlook.com (2603:10b6:a03:449::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Thu, 7 Sep
 2023 01:04:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6745.034; Thu, 7 Sep 2023
 01:04:23 +0000
Date:   Thu, 7 Sep 2023 08:36:47 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
Message-ID: <ZPkbH0FYzfPC3pMS@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230808085056.14644-1-yan.y.zhao@intel.com>
 <ZN0S28lkbo6+D7aF@google.com>
 <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com>
 <ZN5elYQ5szQndN8n@google.com>
 <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com>
 <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com>
 <ZPeND9WFHR2Xx8BM@google.com>
 <CABgObfZ7MRShYm79NsH2=WwvTAcaoz5jUSBxPb57KEhotcr_oA@mail.gmail.com>
 <ZPkemGED1QD7kgUo@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZPkemGED1QD7kgUo@google.com>
X-ClientProxiedBy: SI2PR04CA0018.apcprd04.prod.outlook.com
 (2603:1096:4:197::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB6669:EE_
X-MS-Office365-Filtering-Correlation-Id: 269671d3-889d-44f7-7c49-08dbaf3e5fe6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ix+SwYgIKvpbbbeRd62XjLiZsjyMecXd8ZFL6ng6svpip6D28aaht3NUElOP7WRXm73NLhs9kTqQKd/gRUsXNESsfwxvcUpdW54mQ4MfNOOVW7FYdDXSiBQQdwYb8B8kjow1p81lvxSm82qDSoiCGrLAcBccdXeFmQWqkPsAguwOUnGxfZHQpjXDz/gKSq/y/pn69T2Pzu0vBNKr7AcHa71UXBB2bWh8tJgmaKeAJcu831TkoanTz2/EHTqIlHM59mVxinQ24sO05TnD0Rlypp2J0iHi2c2/+btzcWPAWElruV6S/Iit8Wl5fwXBgufklu/x9yN/vKUF2ajy/VLQW1smPW2HDshlqPEt5DbXD5whuKSSwbrT+vgu5wCsXObB0tJBpdMULPoYWvdlxTJUG7Q1d3AXglvPj/efk5HUQkM6FvTB7eiuIjDQtTe4+GxrvUABdfRsz0yI4qMqPq6wdq3q4ysJ3Q4B4mBkTMbdDTwX9gqQS0HkijEZZhHLQv0WLYgrmQcTnLIFKq9e3cGV1Mu4jnzTzZYxlcyxqXvzaJvsLuSn7i0bJo11hpN57BWU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199024)(186009)(1800799009)(86362001)(5660300002)(8676002)(2906002)(4326008)(8936002)(3450700001)(478600001)(82960400001)(38100700002)(6512007)(53546011)(6486002)(66946007)(316002)(6916009)(6666004)(26005)(66556008)(66476007)(6506007)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGJkN1RnTU82eTVtT3hOZ0tkRitjeFhnOGY3UEF0TlNLKy9JSjFUNXFjb004?=
 =?utf-8?B?Q0xYYlJFKzE4RlVEd21FL0t6NEhHSHp5dHZuWi9ZaFFRcFNNQmdzQ1d3ZmVy?=
 =?utf-8?B?cUpWUUFndnpvSFZYVDE3MmRTRkRCMGczaWl3THBBQUk4YmFhWmdIVFErbEpH?=
 =?utf-8?B?eVllbk5TbTVONmdDc2lXWlVTR210QjBXd2xISWpEQkMwSldxS3Nxb0wrbkVu?=
 =?utf-8?B?akJJSGlvQkxPUnJHOTgyMlFJSXNuUjZod2VXdW9SZ3JtU0UvWSsra1dOVGZL?=
 =?utf-8?B?MnlJWHFoTTc0Q01rWDFoTTIrT1RyTjM4YWsrK0xEclF5TUpLak9rRG9hcVMr?=
 =?utf-8?B?amg5emdWdDJ1ODRpK0pvdFpqVENzUmNiVStFem9KQnNXQTdYTjYxYW9JM3Ax?=
 =?utf-8?B?Ylp2RUJtWW1lSHdMdmttWmpMdndkdXFKbkUxUGpZckhrNHpnZzlFbGdUYVBs?=
 =?utf-8?B?bFpzOU1DcTNZTzNaeWZuWGFrUkk3STNkRjlCSk96WFRKRUs3ZlNwcHErdGI0?=
 =?utf-8?B?MXVlRTVLSHNsRCtzMXBKWlRPK3QxaU03eE9rYTNBSlVRS1Ava00vTW5YVjk2?=
 =?utf-8?B?K3RvRzU2VDJ3Q0VRL3Z4VkxYU0RxRFowbWswRVhKclRESmpQN01rdGJkWnRI?=
 =?utf-8?B?QlA2ZWlOcHhGc0MrSkRCNzlzUEp5T1hOaEJ1SVlKRUFZZXhldW80SjlCeXdK?=
 =?utf-8?B?KzhTR1Z1cmdqRURkV0E5Sk5STkZCT0hWZ0pqSFBWeGVqWnc4U3RFV0Q4Y3Vv?=
 =?utf-8?B?cVJ5OWkzanJDdm5SZG1LSTVoejJSc09hSVBNYUcwWEtpdStWdFIzUHpFRktR?=
 =?utf-8?B?SWNoVkFRWEI2TlJSTG9iWUJ6ejlJTHJxUzU4Tm1hTGRpRkpRbFF0cmwxRG5U?=
 =?utf-8?B?RUtPR2szZkZQYm5iZ0xXVnNJOW9aUEFoNlp0ek5lM1l2bEV4bDNVVEhGU0dx?=
 =?utf-8?B?ZjUwZ3RRVnFaSmF3SVBaUkc3aFZSbVB1cms1SWNwZWZnWjRRcXlyK2d1U3lk?=
 =?utf-8?B?M2lpUllSL0k4R3NFcFRHWldaZjExc3dQdW5mNmRIYTY0VHFtWGdLeWtUdG9X?=
 =?utf-8?B?OGhXbWFHTHR6MWdLNU9tR21qSVo5bjZab2hrWmxnR05IMEFSYUxHNGNyR0Nl?=
 =?utf-8?B?RU9pWnZBSU85QUZZa0FON2Qzdjlxd3JEUVFIV0Mwd2QydzlabGxLUUZEV2xT?=
 =?utf-8?B?ZWpkdkUvaEhBcTlCNmRTV3RFU0ZTaTM5N3VNRHNQUEpYWTRjQVVkMnlqYVUx?=
 =?utf-8?B?UzlWRVI2V3k4U1MzSDF0b2J2cmt4bFFhQjFqWjN6bm5vRkt1SU9VUWUvWTlC?=
 =?utf-8?B?QVNtb3UyaVhpV1pZTmR3cDAxTVpJOC9GMUZoZzNoYXhqYVVTMDhoaDJ1Nk9l?=
 =?utf-8?B?NFNrZGJ0aFUrM1dDRVFOcjFIQWY5ME5uSERGRmhkUStxendqMEtJZW12b2lm?=
 =?utf-8?B?OGV3N2s2d3JhU25xMWdSR1kxaFdmNGY2b1hFb2ZhWlZLc0RYYmNZOEwvOVhB?=
 =?utf-8?B?Y0RkZ29XdXlCc3pJQVNOWG5ZL0d0bFU4UjJWOXdFVTZlcS9WQlgyM1l5eVJL?=
 =?utf-8?B?eGRVUHUvbVozbzMzbmx0V1hTbklwSWJjSnJIamJDRkx4QnpzYVkvWHkxcldz?=
 =?utf-8?B?RDRESGRIVUJEMGFzcVdQbk5BSFVONEtEdVYrS3hackxsUTEyM1cvZEhNZTBN?=
 =?utf-8?B?VVJrUHFzRmt5eGYwZE9NUmcxQU9wWUFlUDYrSlJjZVNpOG1iUjNQSkpacGlp?=
 =?utf-8?B?bEs2MWo1eW1ZSTRlMUVhcUhrNW1MNHYyeDFGZUxDZWlJcjN5eUlITU0rRE9I?=
 =?utf-8?B?bVY3MDBVM2RHSDBCNE90aWRDaGRsTVo5RVN0bjlwdmxFMU0xZThmdGFnZXNY?=
 =?utf-8?B?L3NhNWQ4ME1nZlpJamFyZGlXeEMvb0FxaDZZd1gxbjVmblg1TGdRaWFiUWZv?=
 =?utf-8?B?U1BkNmVnb0hNcWpIbXNZZzJ4MDBHc29lN1dtR1ZyUkxCL3BjS2EvNTVjbFdR?=
 =?utf-8?B?Q1A1S3NqeHhYNXdmclNuUWpqTWdHN2pQSEd2ZTdaNjRIQVFSRjYzKzZEUUpF?=
 =?utf-8?B?MzJxYkNhOExjYmJlTTY4MHdaUWl1czRPZStVbHFuc1JLSVBMK3MxcWYvbCsy?=
 =?utf-8?Q?X74iJM1sHENsa2h1LyuI4VuaJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 269671d3-889d-44f7-7c49-08dbaf3e5fe6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2023 01:04:23.6624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3gI1PuadZutuN2M96N2HhMnaNU6QDTwNyn0P6z/fxl7KZ/VhavZkhEWY3tP33JFrnba1PlZBFtT+h9BjUZndRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6669
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023 at 05:51:36PM -0700, Sean Christopherson wrote:
> On Thu, Sep 07, 2023, Paolo Bonzini wrote:
> > On Tue, Sep 5, 2023 at 10:18 PM Sean Christopherson <seanjc@google.com> wrote:
> > > Ooh, actually, maybe we could do
> > >
> > >         static bool <name_tbd> = !IS_ENABLED(CONFIG_KSM);
> > >
> > > and then cross our fingers that that doesn't regress some other funky setups.
> > 
> > It probably breaks gvisor-like setups that use MAP_PRIVATE mmap for
> > memslots? It would instantly break CoW even if memory is never
> > written.
> 
> Doh, I completely forgot about gvisor and the like.
> 
> Yan, I don't think this is worth pursuing.  My understanding is that only legacy,
> relatively slow devices need DMA32.  And as Robin pointed out, swiotlb=force isn't
> something that's likely deployed and certainly isn't intended for performance
> sensitive environments.

Yes. Then will you reconsider my patch 2?
I think it can remove the second EPT violation for each page write and
doesn't break KSM, and COW.

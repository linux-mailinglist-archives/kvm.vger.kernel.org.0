Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7504D7093EF
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 11:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjESJqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 05:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjESJpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 05:45:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD52171E;
        Fri, 19 May 2023 02:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684489482; x=1716025482;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AXYXaH3uyjnxHsAJgFx3f4hq3JRuOCmStm/DkVKT1O0=;
  b=ZQonuVgU135hULnuRa80utfaH1cU7s6R/MN7dYZa6R+ut0kerKy0M3pK
   UVL2pkJ5shA6TP5j1N59xf4mgE2K4lEngjn3GwEBgPKzDIrZLlV/hGMiz
   6xE4AY4Jnu7h3z4dSeIPO+CxP9Eg5ssLYRNPvgU7//aUsA0MtpheOjPef
   djzPnAmgBaQ5wGxahE3f2JCgMYwlMIaiacleR/D4HNdlh6VuJTI0VeEqv
   v5HsE9GACkKqUN9TxUy3YKsPa+u2iYQ6eAHmD+0rwuUIUeyu7RDn78ahG
   CMC40VT2aN8dRmCe8GjRS4gWj4q1ogEW55b5IZ2tOi/f0su+N3XN94OLP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="380541820"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="380541820"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 02:44:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="652991152"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="652991152"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 19 May 2023 02:44:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 19 May 2023 02:44:13 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 19 May 2023 02:44:13 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 19 May 2023 02:44:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Id5fcdar771mBR4S5llpp1YpcEUcZcxzrbXIFDDaB9XgITUAqCL6e9jve95BhIVf2m9lrSYiiFWFcg9rXZiZ6mOTyfZ36RXpd6TqebM9EH3QLlWbgx0/Bv7mOupro9cWkwv8Gt6ChrqPHDtM9+385UvkWs8eJWfUSMA2CorW2UdyiSdtQhyxrr+2bGV7cE3PUXzkJoZue9+NPZsFU8FGabNr29GNahHjzFMyyRI74V2Rao+GJzxE3Yzc22l6LT3rq5x7mPIlC4k5Zrgad4oa1GCm5ekBTfsbKRLdK/gmr2ectyVotniNniwKyOVLOoNDUD9rsQJ/MdxppK5BzAzokw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qG+P8eFuJ3wNFgTjA8Sc0WUnOt9RxtOJUs1EHSGH/Ts=;
 b=PkHm7cZk3rLKWS1M8LpltsUH9FqvZ2YBLXGht5usFyym0AvC29J2dQBwPhTxtlgLOVi+aJJS6s4F9KIwL/7fuH2K53VcA74TfKh+r8NGJyro/bk6n68cMlld4bAxc3Hbj9dGJyGhw8liKed/1pb3K1+otoP3RfdOfP/i0MUcLcbhrij4ELBRhBSPFKKdOen8HrSkltS3EdEaqXmk8oCK0ApAPON01bq9M03vpEXjYCwqrNJclSfbHTMYolFVo1Wlwq0w8yPaOkhlWcBqfvJjsz6CxXL/Qhb0Xga2S9tzOlkI+/wex8cTcYGy9dTluQhxZ81TgMhC8LQTcrUTurunVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH3PR11MB8344.namprd11.prod.outlook.com (2603:10b6:610:17f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 09:44:10 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%2]) with mapi id 15.20.6411.019; Fri, 19 May 2023
 09:44:10 +0000
Date:   Fri, 19 May 2023 17:43:58 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     <kvm@vger.kernel.org>, Jiaan Lu <jiaan.lu@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 02/11] KVM: x86: Advertise CPUID.7.2.EDX and
 RRSBA_CTRL support
Message-ID: <ZGdE3jNS11wV+V2w@chao-email>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-3-chao.gao@intel.com>
 <a88b2504-b79b-83d6-383e-a948f9da662b@intel.com>
 <ZGLkvlx5W0JStTjD@chao-email>
 <9c75663c-6363-34e7-8341-d8f719365768@intel.com>
 <ZGLyEhKH+MoCY/R4@chao-email>
 <11b515b3-bb5a-bea1-ad01-caffdd151bf6@intel.com>
 <ZGNIN7O8BErVP88x@chao-email>
 <d9be9385-4101-2e9e-c6d7-1d980697c02f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d9be9385-4101-2e9e-c6d7-1d980697c02f@intel.com>
X-ClientProxiedBy: SG2PR06CA0241.apcprd06.prod.outlook.com
 (2603:1096:4:ac::25) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH3PR11MB8344:EE_
X-MS-Office365-Filtering-Correlation-Id: cbccc9bd-f100-47ed-ec05-08db584d981c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DIcoC8H4ls4HOqZs6ANB8HX6NuakL9qkrZmGoujw2lUFoNBTDWDZ7DS7JOxj+asWQBZbDxvidjPuq1E4hWV4KyeWBtfEFL5AALzkXHj9zqAJ786ibWPcl3Bli1FHXQumseG97PmUrCPJZlHPC0OxNx2GnDJUQYBTJa489sC9V6ftNc40kyJUzPl5bUnpx7KQ+Q2nW4h9DQ06m6BXY4o1UTbDVY2e3G6AQpotU046Eroks0gzJD2iNzkQUmQHxOsgbAb/D35TWR7Nv+Yd0ihdgwOgUbIMWblZI2PmuWdKwU3UVTySESd+0e67gaF94SoMpJvb8cAftgvzwE0MrsdIjppHYVyD2r38vbhf1jDFtz9/UFA58BEduNhLMY+4jFT1TkvZmv5uhMgbzvbdjkisM765USXKsdbPPyG2IgpVc5gUSWOZYDo6oJh+EhnUxurxU7eS50V1hmYEvbPc5B2D41UMEa7/vJyF76i7BtkSzDqVfHrrA2YXum5GCo5mH5CxJdVWVb4lv97xxrLx54eempqFU6oNgBWg1QwZy0+tlbsQ1rcJuyWLDDuOeyNNkX0rmss4Ovwn3PapibLuYuY6i7J3uzMkZsPXrn6hsf+dfI0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(396003)(366004)(346002)(136003)(39860400002)(451199021)(6512007)(9686003)(6506007)(2906002)(66476007)(53546011)(6862004)(7416002)(8936002)(8676002)(6666004)(83380400001)(44832011)(26005)(186003)(41300700001)(5660300002)(66556008)(66946007)(316002)(6636002)(4326008)(6486002)(82960400001)(86362001)(33716001)(38100700002)(478600001)(54906003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uGjgcocYCxAPUNxB5R7aOYWSXe/Cvjor+yrpt7DkkIyHfMYwkzQspSFMPxwv?=
 =?us-ascii?Q?GIQ2ENm+6/CuI/BMTuIeZMLaTlBLsBT1J6eWgwHe9uphK/Kz1klP4sv4NF07?=
 =?us-ascii?Q?PZM9/6UzFQHOj9TKfFCEGvjh7xr3cs6B/CeyVr+LCAzG68GOKy93eGy25oMD?=
 =?us-ascii?Q?JDJvmS64PCTy8hoUBt/htye3Fyst2iP/mtrx9XGpYqd0bHN38ivrQJ8lo5SR?=
 =?us-ascii?Q?Kc0/IvqTbvwm7dHaEgP/ni1AtYjfOo5fQA0PttM3Hj9EP5b2mL9dahL4aQD7?=
 =?us-ascii?Q?/os99emIZEvQM8D5HPcVbQ0Jo7Rj1EYt3L23X9SO4cliLExXvn7YpWs5TMZ4?=
 =?us-ascii?Q?SaAnHdw5wqLeoxFZcQn1VvnjGJ3vCvT/5HP75coELg9pL8TdzDunTlnkaaVs?=
 =?us-ascii?Q?qj68u6Tqxprp66GgGwaQMYNwbGGvVmdVRY1znA6ztPNH/rsKIn5mqZPl49pe?=
 =?us-ascii?Q?5ZdZGCeeadMVNwse4J7IXAQRAqW4+NW0//dJiTjvXQnFllAAVWbSRame+d39?=
 =?us-ascii?Q?V4iSYQvLMoWe3EJ3ejp47gzuy2uT83B36R8zrFjstozTgz0RLXWTVmzyjj8j?=
 =?us-ascii?Q?kBHIZSVyzC0J0y1u48LUNWW+HjwyfYEDMsWYJK4RCk/nwgoTf5sRw7n4NwiC?=
 =?us-ascii?Q?lhUo0e0bg6afKjsh/XsUi8Fx2mImrq0YDiAvp4TYTNKiZt6Jy8oLkAiaXPLF?=
 =?us-ascii?Q?Dzbx92qagPhv7eekF4rz2uDO1abAcUQsV8u7gftfqA7ijn/lHuZsP17Hrhpn?=
 =?us-ascii?Q?ztTy+Mi4GR+CZk7UyBsRMjUhJiPH8kcsuX2FDd5tx5ca5WLuBi0MN0IzmiRD?=
 =?us-ascii?Q?/PCFCOPrjh8MVoLr5EeHWp2okybs/7yyNJNBnbk5rognJAlxZWLbCQ+4xBFB?=
 =?us-ascii?Q?7BjgjprS+lvMGOadvYxcUOqnfJv/Sooc9p/oLdEc/UBUysdGiQ/VWBonrZkV?=
 =?us-ascii?Q?bm2FvbdTAWDvFBjvPwFsZatjZU8t9dE3NtOxPsojHn9Ct3d5slP5QhTPELgT?=
 =?us-ascii?Q?I5LVq6RFyBt9ptbutwBewLGo/qL6wUYvnJlQbF5rPr48kNAhCeZ9ePQRNokE?=
 =?us-ascii?Q?ANHoMH2ZniUVNqdTOaIwIHkkA94yXKDKETyNru9Dncn/tSNDRS2/fdlO5Bwn?=
 =?us-ascii?Q?voDTj8Qu2NfX9Q+HdSeaiv1XpIiUgCC3eiKrxoYNh6Xi7xlInIS6qoLaIoby?=
 =?us-ascii?Q?lOTpfnPiTl3ulPbZ+cILxMwzCW4A0qMNhMzdg8vEKO1+h5zLTn+80TsV+frP?=
 =?us-ascii?Q?r++EPcObzPzxCZmKlottHuIXowuEXiFuUr+egER8VBtLQ8rUZpLL+4cSrDZQ?=
 =?us-ascii?Q?dXwsrL3137FuKV6Z+Y78o8vdcWLii67sjvtIDY5VbqPQ/ZE4tE4Vihf651GT?=
 =?us-ascii?Q?xgKNFv+0zQKj4ZMbzV9yfDL8ht4clHM0usGYjHuo1jjiHAdukV0sCLPlHr7q?=
 =?us-ascii?Q?R2Qnv78TAbMPLh4wsU30t8Nf2M+23qlRngc8OlPPPJC087Ri0m4iRJYokL8m?=
 =?us-ascii?Q?zOvHgEstGf0J/WuVwx1N2HGGhMh2vO3vf8ed29Bd23eODx0/myMBOs0IVTpH?=
 =?us-ascii?Q?wAaiIm+KO6cJdhlarI6MEZt0+7RwbFZrlcbLSwWI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cbccc9bd-f100-47ed-ec05-08db584d981c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 09:44:09.6318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tTNVymZ/1wQKi04ADD0DvVbQNxMoItDPNBAxadNVWbLozzkfu333crIqVc2QTICNJVgsmyC12TDH0qXEGtArMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8344
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

On Thu, May 18, 2023 at 05:50:17PM +0800, Xiaoyao Li wrote:
>On 5/16/2023 5:09 PM, Chao Gao wrote:
>> On Tue, May 16, 2023 at 03:03:15PM +0800, Xiaoyao Li wrote:
>> > On 5/16/2023 11:01 AM, Chao Gao wrote:
>> > > On Tue, May 16, 2023 at 10:22:22AM +0800, Xiaoyao Li wrote:
>> > > > > > I think we need to fix this bug at first.
>> > > > > 
>> > > > > I have no idea how to fix the "bug" without intercepting the MSR. The
>> > > > > performance penalty makes me think intercepting the MSR is not a viable
>> > > > > solution.
>> > > > 
>> > > > I thought correctness always takes higher priority over performance.
>> > > 
>> > > It is generally true. however, there are situations where we should make
>> > > trade-offs between correctness and other factors (like performance):
>> > > 
>> > > E.g., instructions without control bits, to be 100% compliant with CPU
>> > > spec, in theory, VMMs can trap/decode every instruction and inject #UD
>> > > if a guest tries to use some instructions it shouldn't.
>> > 
>> > This is the virtualization hole. IMHO, they are different things.
>> 
>> what are the differences between?
>> 1. Executing some unsupported instructions should cause #UD. But this is allowed
>>     in a KVM guest.
>> 2. Setting some reserved bits in SPEC_CTRL MSR should cause #GP. But this is
>>     allowed in a KVM guest.
>
>The difference is that for virtualization hole, there is no way but intercept
>and decode every instruction if we want the correctness. It's a disaster.
>
>But for MSR virtualization, we do have an option and we don't need to trap
>every instruction. MSR interception is the designated mechanism to correctly
>and elegantly virtualize the MSR.

The gains in this two cases are similar: some operations in guest are prevented.
But the costs on performance are not. So, how do you draw the line when we can
sacrafice correctness for performance?

>
>> > 
>> > Pass through MSR_IA32_SPEC_CTRL was introduced in commit d28b387fb74d
>> > ("KVM/VMX: Allow direct access to MSR_IA32_SPEC_CTRL"). At that time there
>> > was only a few bits defined, and the changelog called out that
>> > 
>> >   No attempt is made to handle STIBP here, intentionally. Filtering
>> >   STIBP may be added in a future patch, which may require trapping all
>> >   writes if we don't want to pass it through directly to the guest.
>> > 
>> > Per my undesrstanding, it implied that we need to re-visit it when more bits
>> > added instead of following the pass-through design siliently.
>> 
>> I don't object to re-visiting the design. My point is that to prevent guests from
>> setting RRSBA_CTRL/BHI_CTRL when they are not advertised isn't a strong
>> justfication for intercepting the MSR. STIBP and other bits (except IBRS) have
>> the same problem. And the gain of fixing this is too small.
>> 
>> If passing through the SPEC_CTRL MSR to guests might cause security issues, I
>> would agree to intercept accesses to the MSR.
>
>I never buy it. How to interpret the security? If the user wants to hide one
>feature from guest but KVM allows it when KVM does have a reasonable way to
>hide it. Does it violate the security?

I would say no. By "security", I mean guest becomes vulnerable to some issues or
guest attacks host or guest can access unauthorized data.

I tried to say that if the value of intercepting IA32_SPEC_CTRL outweighs the
perform penalty, it makes sense to do that. I guess the decision has been made
when enabling STIBP and it means people care more about performance than
preventing guests from setting STIBP.

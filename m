Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8109E7717B3
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 03:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjHGBQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Aug 2023 21:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjHGBQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Aug 2023 21:16:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E198C170E;
        Sun,  6 Aug 2023 18:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691370999; x=1722906999;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4TGcjTrVn97WcqFI/J9OcgxG7o6IioJaT5HRkBvlsig=;
  b=Aj6z9J7lFRLsdYntcqY56OxGjFXZvpEUjQYLdgwop8Vam37rwN3+QIFg
   it3bq8FqbGLyGj0Dgo3FStR/oveo6qVisrBeGczmaFccPxwtGp//VLeoU
   fzaqBbjtzvwI3fCsPYw9vS58kbFehOvYQnilT2wvDgEvztQAxVgke9Gln
   /93T/Rf95CXw1f4Ttci9kN9bmtmFssQ8P119IJDrUQ9kaBaHtvCgcB/bW
   lm6i8fnCP3Z2x2dm4qxVTvhMjG6INwGSeRuUlYix69SmtS3oFY8dVqJOr
   VZpx/rwqmJ8lblR1lAMiUldLSlBrYZn83rYLNdH4U71ClItgmbZZoOjca
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10794"; a="456809076"
X-IronPort-AV: E=Sophos;i="6.01,261,1684825200"; 
   d="scan'208";a="456809076"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2023 18:16:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10794"; a="724329140"
X-IronPort-AV: E=Sophos;i="6.01,261,1684825200"; 
   d="scan'208";a="724329140"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 06 Aug 2023 18:16:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 6 Aug 2023 18:16:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 6 Aug 2023 18:16:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 6 Aug 2023 18:16:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRQg/4O72IJaex4GvxmajsUmfld9KmaEO8gpMWnG2EV9bq0WISo/es52Wy4UXEmFBmkZdRJ17rETgDJll8HX6tzYBUT3odNx6LRuiNlfXc3w21ch6JldV8KjXp5TdqtFisbgMjSvEYti1eWLz9oYQjpiI4HqsGcEquinXt+6ZMeyz/gw2muhNjwR6rWFANAkKFPddVGv5o2JUFKuZ57DbHwSZmw44TdAYigrNfer3o1YObqymSYSZClk9Q87aP7Mr8pWgPwQbEVt30LuRVbwG0JFR6njc5OeC08cUQM0lo7nM/bDGrkNwVBxn8KzqCLAs2ndlsHY1K6i2JcF5ixg4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLdzoob6+MSHIqGwHQIa0NfLf6CG3ZkLL9n8uJ6SpiA=;
 b=BRjxh3wV+0ZFIr+gX5NVEMtJlkKZrg+MX7ggPSJKkeHptNVuDe4YwVYyNq1LZpBnEt2O773NAy866mZVcJkrS3o9NMzupO2esxdmkS9X0s5iCGzuUOKTSTZS2PmLHrwRFBgV9SAd1jkqpx0Qpq2GlJO+t6Z9mG64xmkHsD/aaM6f2pNTDtdnyHOQR+vm13DMW6aWECmlwNctW2fZygxR96YaLFd6rK2vtMpoWTdbP1XqGedBGb8i/uqhByHw11qBj7F+eBrioMNLpNtO9uIsLbzEdGPQeZtzQGVgbv/F9QW6/UgExHsX6Zvb/7NjTIKi+JcJ9FSsuD6wrnm8uXMM0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DM4PR11MB5247.namprd11.prod.outlook.com (2603:10b6:5:38a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.26; Mon, 7 Aug
 2023 01:16:29 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6652.026; Mon, 7 Aug 2023
 01:16:29 +0000
Date:   Mon, 7 Aug 2023 09:16:18 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v5 13/19] KVM:VMX: Set up interception for CET MSRs
Message-ID: <ZNBF4t+x5Gf14PV7@chao-email>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-14-weijiang.yang@intel.com>
 <ZMyz2S8A4HqhPIfy@chao-email>
 <f894d23a-5c6a-d189-57ee-8f2bae0baf6b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f894d23a-5c6a-d189-57ee-8f2bae0baf6b@intel.com>
X-ClientProxiedBy: KL1PR0401CA0027.apcprd04.prod.outlook.com
 (2603:1096:820:e::14) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DM4PR11MB5247:EE_
X-MS-Office365-Filtering-Correlation-Id: 184f7038-c81d-45bf-dcb1-08db96e3ede6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /m9ACiAZUxrCCgdjhV169/qwxRf3KgENBIA+48ofiJObEDGEEYxnqp6xtZlwSS8aSF0I85A7RobAjr1TCwMEx9yFGkkKkVR4dvLTBX7bv2bKOwWHsOrUoPTN3PHDYvSPAblbeIXEQSFqnXwowJUJK1wauNBN9ywemwScs798v/RODP4ED5Q4aKZhfk77qlSTC+hjtfnBiLWgtR5ZIjFWlw8YWkUAX8oGZwiP2kgb7hz6QIbnAm+DMwy2QvEkN/RbfMEqaOghM2SxVOYApL6kPpx29AP7od/1S1xbMXI3Q2Da6vbW0hzGeKFe6SgRgZ8vDMr6gVeWa0gipHYd/bgJn493UBw9FsqADi13v7hPul5rgrKnCSkzKNIUPc9KiDGhDABBffnFGRf3exQ2vaicpy6myQWOWVRE4enz1jaOorWfeZ4XBRERzDl9dkIhWadyYkd++FzBmuVPhbflUH3Q/hfOFatqbLuKBTT+Q5fO8HEmSXbskXU68mXdftiIHuzOVspZIsEKx/9j1RMc6BASfpZE8lhbDd3hxSO9CaKPd0LFXvxQtE+MiInZYW8iG6NG21Q8SAurXUhoYo7jd1Zy99f2IcZ2q9oSsypms66MsYg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(366004)(346002)(39860400002)(396003)(1800799003)(186006)(451199021)(38100700002)(2906002)(6636002)(4326008)(5660300002)(4744005)(316002)(8936002)(8676002)(6862004)(44832011)(66946007)(66556008)(66476007)(86362001)(33716001)(6512007)(478600001)(82960400001)(9686003)(6666004)(6486002)(41300700001)(6506007)(26005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S9z8Xz2KS/8/13YcZh5n15JTtk2TIna0Md9N6fGTxU2jPFcN1Z+vPswI5QbC?=
 =?us-ascii?Q?R59CtTKqmn2J6SxHFjh4gPfD0ibMDolqy7n80FvdDg77l60+gpEiXwUDE/hk?=
 =?us-ascii?Q?zsxQ0IGsWS/3XbSCDgNfDC1eJIDHkHTHO3sawaWl7oaVs5XyWBGJuoj9xMjB?=
 =?us-ascii?Q?ySvVc/uvt9f54bISx9xhseD9/v1BToUUgsGPgFC3Pl5M+k2swq1XseVetlJU?=
 =?us-ascii?Q?wurukcP/enbeT7wElA/nwM7a8RTZQwc8v7Z7Rj9MpNW7RGp7boXe6CaZ7cXH?=
 =?us-ascii?Q?HhIb/IDMC7Raga4NprRZ0PAk5doc3tKaj+kPsGZFSGLaN2boqm0P1WU02sJV?=
 =?us-ascii?Q?tVANtyNOdDE/wVVQnHyV/GwWErsVaB/B7WZyip00oJ0bmoeIUFg2l4iu0Y2F?=
 =?us-ascii?Q?z9Uvkefwt+d3eaCRP79CLHYPoOH6Ty7GgPHI4APjuoFdoB+zWDKEzl4z1hP8?=
 =?us-ascii?Q?jGQujBB0WfuLDpCK1DILaVcQsuTF7OjkLpHotoEt3EOItj6j6VbPW/hwMHnN?=
 =?us-ascii?Q?p142T+bo7AbHcVqXZQwgpyDU+gNBSkMVSiOzp6n7T8FxMXYdN8+6pgvV3TE9?=
 =?us-ascii?Q?YSpHyYYkDSJXS1we9qhr4+h/DCGlpJFRdZMfFbC1HdIjA5DrcM0nHKGj5iHt?=
 =?us-ascii?Q?V1vTwPqZ98lWrj4GDNaz7KL8U/Miusj98hvBjwxr5m0riXAjqCchs8PomDGo?=
 =?us-ascii?Q?ftOoCdttE4CCmbqT0+KoThExdTIeBT+h8VyZvHm8gsC/a5wHVQgfLZhvELWz?=
 =?us-ascii?Q?Ep2jiX96brYljAETtvcz7TedtIYIVFCLvUZfFvu5lrczjLo0TE0zZAg/uRIz?=
 =?us-ascii?Q?ZanWL3GRz2t4vPk7CEbrY31HVJUgrBp7Tle6ecQaUH+CEskfQUgSq3rTC3kM?=
 =?us-ascii?Q?YWASH81tmORiMEuXVbqffY+/qdnecw1/jTtw8fC9bjmd0wTuP//SPqFVuj95?=
 =?us-ascii?Q?8SQZKglp92qgAfLVmWA/RRruebeerGiZY9kZjLaQUydiah0TjayBw4Ko6nac?=
 =?us-ascii?Q?Zbd5cCaEJrHgC/IfOVqTdxtXiLR9xKgSERAU39fEsDpG7N8x7trJ3wgY+MdX?=
 =?us-ascii?Q?XmUnMWGNS507Se5ZU2Z3XjuxyNaylZa6xdHHSUPzNqP8yXTOYPvCQ701+F5x?=
 =?us-ascii?Q?LYQ0Ufqw+AEcKEuLl5oCGqrLMPsqcNrJpxX/o5czigAM43x5pRoKN4gBv8Tp?=
 =?us-ascii?Q?h0m1xdDQxsWdgiXhSNbNWv8ehS715O8LPBi9iBWbz364MtCBQbDW+4Y2Szrv?=
 =?us-ascii?Q?NXpaiDB6NUaz7seFA8fl7AGK+uePBuDKX7sia/aFmsvK+03HgjgrO7KV2Vjz?=
 =?us-ascii?Q?8v+4WHrWGerpkkCtIWGpzPgSoZl3W8OuxIZZeU1fIePIqLhYLB0MEE/xQ5nF?=
 =?us-ascii?Q?kQAW27g2RxMw9T33tKIjO0x4VZ2gUFo9On2Rsn+IJTnArObuHyNgCYk0dViA?=
 =?us-ascii?Q?njczmWBXqh/DkuB3gz6SblKcQ1fqpVejRozAQA67qqHY89/s1zxTzHOgZj0+?=
 =?us-ascii?Q?JE4ceDae2CGJ2USARFVKXAOA0qWMctMrzpoKTgla8Alp6YEVl6A6rpdg072q?=
 =?us-ascii?Q?fkySP1mpSJZ/jpPp+bRapCcHAsTUWsYiPc1OtYUf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 184f7038-c81d-45bf-dcb1-08db96e3ede6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2023 01:16:29.7574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E4kIrxAXGxAR1q72m012/2awlP1Ff+sEBXHaYzzGIqrb+3GduLwTBsqi2Pf4siPeBqQgKV/COzYlEHgMgcQ6NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5247
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> > +	if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
>> > +		incpt = !guest_can_use(vcpu, X86_FEATURE_IBT);
>> can you use guest_can_use() or guest_cpuid_has() consistently?
>Hmm, the inspiration actually came from Sean:
>Re: [RFC PATCH v2 3/6] KVM: x86: SVM: Pass through shadow stack MSRs - Sean Christopherson (kernel.org) <https://lore.kernel.org/all/ZMk14YiPw9l7ZTXP@google.com/>
>it would make the code more reasonable on non-CET platforms.

then, can you switch to use guest_cpuid_has() for IBT here as you do a few
lines above for the SHSTK? that's why I said "consistently".

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E485B5EDAB7
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 12:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiI1K6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 06:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiI1K5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 06:57:33 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E877B7BF;
        Wed, 28 Sep 2022 03:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664362618; x=1695898618;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Q0MKVBMePeYzMbULJ5ipgxkKHQJae4VAfnFhX7fRFvE=;
  b=aNo1RXbNuTybbmsDJmeJIJPKAuqzoVvwDL9zKsG0MlByLXOZIXkPu3N6
   A3QJQ1Rse4/2D83w7X0PSqTfuSKxEbJSp/uK8maZwu8Wnn2AIC7682mIX
   TuEMCGSijWZ/+c5ruBt95rnoEVmS//E37RhEtfMsnxWz/NqQGHqaQqa4J
   m2O+w4LPUO+QCT4phdbDHQhgh7s+AtVHvFQt6k44JCqSC6N1WUdt1svO8
   MTw/TQsHx+cZbv2Ess1NsMgNbKX6UsoWrFY9JJIbYkXXLKA+Ku3Liw3gy
   N5yfLSqjvdcrtmNoUYYVgzGr8Ke3eSvZK3YEF907pC8hEBYqWJikpL34+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="363410273"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="363410273"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 03:56:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="764247278"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="764247278"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 28 Sep 2022 03:56:57 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 03:56:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 03:56:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 03:56:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iebp0QMl9UiS9PpzegGDkyItOOoZWrp/wE6D7Z+Nggn1oFlh77HjrIrbPj+u3JRbJUQ1s7JAkMzd276kcgNykL1ieZHaZ4RyFeNbTmRBAXK1IMuBMDJXDTdk4eCZgh/QFXJdoaFHr9KfW1pMxGUA7xzcgt8Ak0DEHLeFjWqsOpTcH45QdCF4si492M1rSfzwCHcwGCifWrvlyXmHPJmhf2IUPnM6BMtYBzMa0MG0uttARol90FPIIk+dNKiN3act0VMXyZOT3YBFnv0vsj97hLhLC4X5HgbNP3TIjllEDN5fF5kjsbZc5itqprTwbWh62t+iJC1qCTP4FBii17m8Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LVM6USpmdErI3zCIC7/YgbwjTYtI/wmhlIpNMgyM9GE=;
 b=R2EqVOdbmFKToQc25aG/rxwptxfT7PRU3GRwJ0pmaslL9bz0eZhBt7fFnBWYL49ubhD/ytJ0tWPFhNH+LxF0iSCDMAZU0GdDXYuGnvA71Rnfg2xWl8auPHP1/SxIKcAtueFjYbRIk89uls0EYPGbIK8ai0Pqp9ijviUpZfXBsj2KuFM1BNAd9BX4TFdU/TbF32Yk4vA25Aj5+se9o6kVG264w/voyw5AWVQhLUzgcfJZIyRLWb/XriNSgLTUCvf9f8RC2M9Wi4XibxofoHXw3EaRWUlrCAofAjUY0eZKQY0GabsD1DMtBEAwoy3ge86/HpwHx2fmhscB9MLoI+vxAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by SA1PR11MB6687.namprd11.prod.outlook.com
 (2603:10b6:806:25a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Wed, 28 Sep
 2022 10:56:54 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::a071:6245:5340:793b]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::a071:6245:5340:793b%6]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 10:56:54 +0000
Date:   Wed, 28 Sep 2022 18:56:54 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kohler, Jon" <jon@nutanix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v2] KVM: x86/vmx: Suppress posted interrupt notification
 when CPU is in host
Message-ID: <YzQodrSUCNchdaQs@gao-cwp>
References: <20220923085806.384344-1-chao.gao@intel.com>
 <BL1PR11MB52712631CBBED273F5E4E1828C549@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BL1PR11MB52712631CBBED273F5E4E1828C549@BL1PR11MB5271.namprd11.prod.outlook.com>
X-ClientProxiedBy: SG2PR01CA0132.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::36) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|SA1PR11MB6687:EE_
X-MS-Office365-Filtering-Correlation-Id: e3aca568-cbea-4aec-7512-08daa14027b0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Omz10qbCkywMRJKuUZ1lNtFg8zr+fYR36FWLGAND1b0ofs4BC4fACq+aGKKUs7wsAWYMcnvMbmOFT4cUX7MFy2C7mcoOdeSgXxF9pe0ij11jx6trz7AE3XCQi6bsKpqMUTB+JjmKkxBFxkRbJmxgLaa46j0SLwXyrOw8ikFIT8LyA+NsnNLs/Q2L281Vv2ZVhWu6+KAtMqP8yo5t0hbJD7oKITlimq2j+yozxfRZCSLLVa0T6s3NWosejkygoe9D//a705d9OMeOZ+6PDZ1PBy8P5opjP8TyaL8oPHfuJfVoXV8BgQ0GSBGGKHSxH0H/aSwQkD28XPI48UTyuzpUxbKEx39aXY04+XU4wCfVJNsgW9z4LLp1mLlRqfbXvH7OqCwva1lKOy3+pk087R36bUcpX7dWDL9Rn9CAhbkOUGHMVSHmLGKEuBEiGSoScmjwey1WWkJoo+EYusy7hlXMg86c76F+ZyqQXlo/LfI9nGaW3uep8lqAANF+N/2fR0grS3kIv/OzMdOOjzJRccn4VqACE2/WNv8/zaf5oI3vVvuMVe9R7WxnPnFsZvVSqdr+aTLZio6PPlcp2HsF1/ff7r7437dN3w+i1NL1HevrV4amh34DWap0hdBpECsJ86OSjqjJI4tX23lMWketw0d0WFvj0ah/L4cdZqClSUweZBydrAdU7mpnhLhO0KuOAGXsgsFqr2suh5ULXsnkTCPzow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199015)(478600001)(26005)(9686003)(6512007)(6506007)(83380400001)(186003)(2906002)(44832011)(8936002)(7416002)(4744005)(6862004)(33716001)(54906003)(316002)(6636002)(6486002)(4326008)(8676002)(5660300002)(41300700001)(66476007)(66556008)(66946007)(82960400001)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6IDmUmFmDG0Ag1JqJ166NgVXA+ux8HIfhzr+Ffaw/4mCyk43f0Wd4sN0DUhZ?=
 =?us-ascii?Q?uk/mj0SeJP18Pa/yhKmEqX4IUYe399iw1a3YsxnK6OzCMbWbFSUg54Esj3GA?=
 =?us-ascii?Q?36XmvVdOOSXcm3CGI0F8nmBjEqZrRXXAyafRs+9FCTFHYDUbcdgQhXYL2Kde?=
 =?us-ascii?Q?5udDFaD+khtrFUyTlQgbLR3lHvw9FyXalZKnaC2PmaOA6z7oAhPemM7t41cv?=
 =?us-ascii?Q?uPQFnbv4EL4dVqjIRrjt9ChnOOpe822iPR5mz7mgESGfPM8lLeUZ6bJzqv/e?=
 =?us-ascii?Q?jjMwzzlUixv3RgMbXPkiYuyquIvw9PP75XkrvEpPaRNCg1eKFQxrhylQKkks?=
 =?us-ascii?Q?rIabXTA+u3yUxoKBKPDD/e/WyujY62BsnVn1sOfrNGY1efu8oykfvIc6hDAR?=
 =?us-ascii?Q?kZDM/zy4ZlhdaY813kgDL1GE1k7sIYeBpkl/rkz9WWhv2J+NmtsXkE2IRtxu?=
 =?us-ascii?Q?cj1BwXIE+tVTZoTuf9H3mtDHAX2NL3wlAZarac8JUFIYrOM2xblJymWoJIJd?=
 =?us-ascii?Q?EcUMCuhrEnNEhwV0eKocJ2VNuyu/PdmmyD0XtDeGpi4BYu1Spp6rDDOWsSEu?=
 =?us-ascii?Q?/cqiJarQnf2vin6A7B7xaAIeAt/RgXUeXkZUASmACWPgYHv/csMcUgIWOYgU?=
 =?us-ascii?Q?Ekx8d++1HhLgXKi2t/hv7a+AgjW4kcFHJMHPMVdj+bO0QDsCfoqtw/3XlHbI?=
 =?us-ascii?Q?s9tWPO70baMVFTJgrk8WaLp5XRotIHpBzzA6Mhc+I1+Cnx2l6McW+P4dBQ4/?=
 =?us-ascii?Q?b22RJrVM+5nthYzuXoUZ9BWZ3lhCvrqiZwrtH3LvatJtdrPpHgWO7PJ01nWF?=
 =?us-ascii?Q?NAp7ilF+q8U6POm5ux+pMm4NpOzj7gFC7D3Vb7HXSacfqmQAX4EAmhqTgHWb?=
 =?us-ascii?Q?AHTWcBwW3njYhJarTWg9d/3sNREQKYMaS8QEk1y6j2n9t8DzuphKhWsOG8tc?=
 =?us-ascii?Q?dMWhRfFASNUZb/gOU3POW//OcGlkoUCBpRRwMs9ggWDwnT8W8BlM+IgJWb/g?=
 =?us-ascii?Q?YCSK/8MBIpIzQtaWMr7tn6xiaRuqzHsoSH05urfLNgyzB1uXos1bFAbBIaIs?=
 =?us-ascii?Q?uqkFf1eihWn5UE0yHCjF6AVDcKGWNNDrkOhEQSEdY6icf3zNP16vG59AgW/6?=
 =?us-ascii?Q?Dp+EOep6hH1f58qj1n9b0NpyIYLf56/th2wBBTGLJE0Knq5YKXtGwewY1BFm?=
 =?us-ascii?Q?blsHZfJ1ptyapF+N+CSVF0hjKYyooiOpwCGuAJ9KvKOBvz9LkmWN9g+GXfKH?=
 =?us-ascii?Q?TmfafxSINBO9llEdkeEgYuTzdVoj51/8fCR5wu2cEpPy3NQEoJd0zz1/raNL?=
 =?us-ascii?Q?sXqRiJnx1IzOfdYujdsQ25Y44ZKzEFHk4XHzmlQnlPNyXPuKXciinja2jqdH?=
 =?us-ascii?Q?HnOWlvItXwzR2a8BG7CEOok+/fIMD89p04HUl8l0DjS5uUIwKNrLDNSoN+mh?=
 =?us-ascii?Q?Jb9IZYWkoVoqP81Pxn4I9FVlxwg7zZ4jNDYBWi/Lgy92dus0Bpfk/Ugdwpay?=
 =?us-ascii?Q?0VSzCTd2DcriTX6XdXO0Gp8g6K9+DQ6Zmfa6UEld2mRS7SyQhHx9Ntnsh+wW?=
 =?us-ascii?Q?6txo5zCrJYqouX2oNeTW1850kC2swLu//5jtttkz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e3aca568-cbea-4aec-7512-08daa14027b0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 10:56:54.4075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oy1KPTJcf+dfOIXxWjJ/hmFZjEs1e6eMpmp/bCg3mLu6+p3qR+tl4192EudVdJIMhrGV57CWig+FFCZJN+0OVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6687
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> Changes in v2 (addressed comments from Kevin):
>> - measure/estimate the impact to non-IPC-intensive cases
>> - don't tie PID.SN to vcpu->mode. Instead, clear PID.SN
>>   right before VM-entry and set it after VM-exit.
>
>One correction here. My comment in v1 [1] was actually close to Sean's
>suggestion, i.e. opposite to above description:

Hi Kevin,

Yes. The changelog is misleading. You suggested using a dedicate hook.
And I indeed agreed to follow the suggestion. But as you said, what v2
does is the complete opposite of the suggestion.

The reason is when I started v2 recently, the idea of clearing SN right
before VM-entry came to my mind. Since it could also solve some problems
of v1 without a hook (hence, more self-contained), I thought it was
slightly better. But I missed that clearing SN right before VM-entry can
cause unnecessary SN toggling to VM-exit fast-path.

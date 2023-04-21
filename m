Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1706EA25D
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 05:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbjDUDci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 23:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjDUDcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 23:32:36 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201231BE7
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 20:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682047955; x=1713583955;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=C7ysZjyyk6A43TXXb3sEBUme9jAdeVr5DTDbnqlBROw=;
  b=ioDw0I27g3RIHosX4BmI74lL51Ec7AaMaOI1R2bohwq10UPDTvhhWbqS
   v7exuE4/LR4lMPvdMIx0kg5zTc2N733qpZ5U4ArQ4+0lQ3B+5fUtKYv6H
   mlEr+pCXtOn14VsChbvCEy2VRVpej+BQtIUlPnCCP2I0J4SAFWZfChi2T
   YM08phurIE4IysVc6gBI/o91oJMMe3jbXDh0Mdc3CL8oYdnB3debsrWss
   T5ua2yNZQvAkGANz919rgY9Z/nzg97GuKmCJ2ikIduo8I6Za4qZ7MNBH+
   MGYL+M+eQtG4bo0OK+EQ8ZFqZGr6Vxsvq+ieDpzAYINcbzwtwDs+jLVOj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="373827833"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="373827833"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 20:32:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="781454545"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="781454545"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2023 20:32:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 20:32:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 20:32:28 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 20:32:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caunadZ6din9t4lR8EcoVhw3jwaQ/WVfHeY07e628ftsgHAQ726tPqA1XRcywJENZDf51eJjI6RAZAJNWBY6ZuPuD+CjqvQbbbPamUMr1VATNrrlNUFTm+ea8lcfObTOBOnGCcytP35tpQ233hBJzc8+h2L5Kju0MIy2FABepNEhrkypHy3053XZ5aN1cyyRrHImQMRbdITAi1e0HUTE+VNz5n+8w92hhRD76qVSdENTh4Pl8lV4vdxKjPFbCLohoP2DDsLWt4EK5QqjyMUfckyqK7sinhW0TJ9dHTMubpMdaZpxveDPEqeni8Fcv5hD7+1mFRE+jMf0NBUa+76r8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsV8FX25w0adZZ0swbpPmkCM+86OQM1vUxiHyYVnOxg=;
 b=XOsAPn0l4ywGPS7UNsXj24HBcr79lyOA0Eq5YOTiy6G9ANTj3OKk9OHVr2XG2uJRMe27dhCXK3ojpdAPMDtq6h1Fu5Co8IvTYKdlXQItxr9Cs3Ldjti6OheD+NxyiMJdWJyWIzjWVmmSDbAxO6TPakrwkuLZ0vjZjY/JDRl6CMAq4XbA8quRYxJJmySEGJJ4OQc9k+60IMYAmD6/0qEpR4AKCWrv5nA8PoAfcXa7ZbPIqKWtADdMkxsQk6NloKCxjaY58qnQGKpw0C30bCJ6yyuRCiJujWTAr45gQeFmcAcIMqu1Blod/nP4fcDt8DVJLkV3EAwTQ+amxXrrafIvVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CYYPR11MB8387.namprd11.prod.outlook.com (2603:10b6:930:c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 03:32:25 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 03:32:25 +0000
Date:   Fri, 21 Apr 2023 11:32:14 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [kvm-unit-tests v3 2/4] x86: Add test case for LAM_SUP
Message-ID: <ZEIDvnwPe5LcCVNW@chao-email>
References: <20230412075134.21240-1-binbin.wu@linux.intel.com>
 <20230412075134.21240-3-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230412075134.21240-3-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2P153CA0047.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::16)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CYYPR11MB8387:EE_
X-MS-Office365-Filtering-Correlation-Id: daa5c5c7-6164-44d4-6e44-08db42190603
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: etF0B976EzuTtdeJQo+F2kT5o9dpm/WRetX+Fj1TTV2Fo82DWALVpOcbVIRkVh+OdzlTr7kyqss3MGn9NNSp8e77a6tntDzIBGf2M3dh5fBrDEC5rf9VbtBS5BAk+xEaWHYrpSzWPxAynopacc9J00uggS17yOCpXZv6C7uWzQ4dsF1W5Y3yjCibgbRiS+BS0QLbJ0iQC/T5oWl7XHT4lplIDB8P2prGipkejwGKBJ8IsaT3lStYWFIrKlDCVF8fXR/Cbv1NoXu5HlgR9SYEE5JVcU51/arCmzF1IjDdn1vVYnfmnSzyLmCYOuCzzlWL39moIAkhZj7Izsmkd+hIq048EKvMDKiJKOHdkc6enHtiw4wlYwVqK0kFfBqUUThoDcjsJz6engvQ9GgWG8lTO4f1uPXqM3uZnWm7Bg0K+W1bHdqgk3eY+3mfwp62wbMP+5jB/VAfeoRieggPYgOvaxIU0Mxae9u5B+RgktFq060h6F+YL+iRSTXg5eYRi142PjW8feJLMGIMl14vK3lDnYAfE/+IWFjr0Jvr8uAZ8vo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199021)(4326008)(6916009)(316002)(966005)(66946007)(66476007)(66556008)(9686003)(26005)(6512007)(6506007)(82960400001)(38100700002)(186003)(83380400001)(5660300002)(8676002)(41300700001)(33716001)(8936002)(6486002)(478600001)(6666004)(86362001)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F8yx1wGI7YKSm9AYHjF2/zABYnliuLrgC+fTXv+Q7yPdx5yv/GjiWLzFzEv/?=
 =?us-ascii?Q?6SrRJwFh9eLWue1W9OnYJi1LVCTEKdKxli56Goc8UcRgUdmW3N0K1sHamCWO?=
 =?us-ascii?Q?uvvjLQjDmDPLCjAnp26ARYUk0jHlTSY0Gih/p15EKbhPyJBK1gj9ghXQpwFY?=
 =?us-ascii?Q?9X9V3i3NGieclGlG3z5+wYIsvA9nVN4+I5Ukc2dBoaKlS7MDx9a2ZCMq5Dyl?=
 =?us-ascii?Q?lliAFVM8V4w2SDr17Ro+yQmBPsAzOJi9Bd4BFwt8PXdyC7baF2GYM9UGXpNL?=
 =?us-ascii?Q?LzZhqvkqI2r2P1nrAV1orM1pjhVMObESKI6GuSWfWJ15t9wb/x5tq4kmLwhI?=
 =?us-ascii?Q?+v4LSR6FwzgfyzxNUgIBZJg000Fs990gLjJMQ/20jNXIfYpPkCDdpJolHhpA?=
 =?us-ascii?Q?TeQLrf/Z6KROXei3A4Ng3ihNRZnJjNolf2Q8sWN0UvQuxzIYClBlX6dBGJ5T?=
 =?us-ascii?Q?yfJIVNsHn7DkUYibS/huSCuFRtUprD5m3TGlPJuSnFDDev+anceYpx0cY01+?=
 =?us-ascii?Q?b3cgwSlHWWygSzyxqhCyK0778JGBlWMn8OVNIoU1N3IrWLM6cPTQv4VzLBaG?=
 =?us-ascii?Q?AWOTTkPQ/VGU9SkvGzKprB3EtYlNmywQGfGTS7w+JU+zU0mg54Bxjyd/L53w?=
 =?us-ascii?Q?cni9ZHVVPymTQ3mLaD7eftKCgm+/+YALeWELGz0Xtm0HeYnxSHvtMY2zgCfn?=
 =?us-ascii?Q?Hk5XyLIyizHfDOHDL8Bso44392OH+EF9dMIMPPJ8o6nR2HOeHqWerV9ICUTw?=
 =?us-ascii?Q?E2lM6mN1mEZG3N20INiw3EBk+ah4syHoACm7X60bWLdWCx11PkhKIMoPyFU2?=
 =?us-ascii?Q?1SVgtwJBxqOVyxNM9NpMHziZLG+up6McuoVtq5f7EOdJWHmpD9auP0ltL6TK?=
 =?us-ascii?Q?y0/WfJSWn2+gf30dfO11d19cTg74fxJsaVLXKn+jBrwlqDPg74Xgsfk6dA0u?=
 =?us-ascii?Q?e32paVIKNlnI+KKM0+rTogUXPTGIoQRZluUzA1f7FWAL15TAJyItx4XJDEYl?=
 =?us-ascii?Q?Tsw89tW7/LeJFNvIA2CUD3TfGrBAp0BOS4VwJIfI9nOHUSDpjywwoUo+5Prd?=
 =?us-ascii?Q?9PGIw+FoEfrW6Kf3UDxx7Swbexbwz5XRcNjVwMNK3+bLikoN5GOYfbSADlsw?=
 =?us-ascii?Q?TtJMQ8NBwRQarlNsAF+NhlqLvwMHrIhGSqPzCnicCh8+jaMW36bYtCHCx564?=
 =?us-ascii?Q?S0aNDWsjw6ld/S7xxGsKbEYrvRKkKmzatnxB0kkGMBIgKV+tlUBVulgLlDml?=
 =?us-ascii?Q?bur1VnkcX/APpw+V6/rY4f/SR0VBg+gK778vaCnOja46YMaLJ0BbmlIac2I7?=
 =?us-ascii?Q?j6sIOv33MEbzIxDXxZixup6ETUAXqLgXf3VRqrIOwR08qc72MMmrr7L/aLrr?=
 =?us-ascii?Q?XCVt/p1Lv0yROoOQpoS2dSuwoOsxT8eTT/mHi23br9ZCBmwnD112AfUh9Qnf?=
 =?us-ascii?Q?7lwHDTwOTOP5rSuLc6E2pPmLHaYxAEqfKMGLkVjP4t7hjY/H1sVzjFHdk/aJ?=
 =?us-ascii?Q?nBYEW2f50bpSp+U853q2LMmXYhUVawhJbVwDBZHN9qeXVaTes93yS22CWKfz?=
 =?us-ascii?Q?78ITxRStRk5438x+4JsXqiaWMjUb0az95OFxC8NO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: daa5c5c7-6164-44d4-6e44-08db42190603
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 03:32:24.9548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JX98Z0O24HHhYjS/+t/zL5DeYKt59HeCb9ggUTANY+LI3hdWCvQcck43gGiVYuoBROhUKnlfJOnf9eNRBF0fsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8387
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

On Wed, Apr 12, 2023 at 03:51:32PM +0800, Binbin Wu wrote:
>From: Robert Hoo <robert.hu@linux.intel.com>
>
>This unit test covers:
>1. CR4.LAM_SUP toggles.
>2. Memory & MMIO access with supervisor mode address with LAM metadata.
>3. INVLPG memory operand doesn't contain LAM meta data, if the address
>   is non-canonical form then the INVLPG is the same as a NOP (no #GP).
>4. INVPCID memory operand (descriptor pointer) could contain LAM meta data,
>   however, the address in the descriptor should be canonical.
>
>In x86/unittests.cfg, add 2 test cases/guest conf, with and without LAM.
>
>LAM feature spec: https://cdrdv2.intel.com/v1/dl/getContent/671368, Chap 7
>LINEAR ADDRESS MASKING (LAM)
>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

one nit below

>+static void do_invpcid(void *desc)
>+{
>+	unsigned long type = 0;

the local variable isn't needed ...

>+	struct invpcid_desc *desc_ptr = (struct invpcid_desc *)desc;
>+
>+	asm volatile("invpcid %0, %1" :
>+	                              : "m" (*desc_ptr), "r" (type)

You can simply use
	"r" (0)
.

>+	                              : "memory");
>+}

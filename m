Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A9F708D85
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 03:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjESBvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 21:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjESBvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 21:51:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63CEB1;
        Thu, 18 May 2023 18:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684461072; x=1715997072;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zE8A00MHlXY8B6dc3nUfwU32iFd32+1ohnkObXzGM6Q=;
  b=jUMufKAkmXrHgrjnIBBLiOfnYcvvmcHP+ORxTl8zwna5bjVh4EfIHri8
   bJCq2yJqVMg/9E2P7XuLU+7mHPthaerLCQnj9R+1vwZpde6Eds6KrtqU9
   4sBP785ESU58VEE+futokN1T6Qk6CsT5Iamvcrd2Hd4OaSaGY4xH3cNNZ
   DZxuhxtgKFDHrbWyOhzme4etc9AES8ILWHWubxAuWalCyPVQ2TJbjLrEH
   81ag7GPIXiIZlNkK16QfovZPuQO5/P7CW7eOjuadjX40JwuFSbtXiK9VF
   0/+78FkwVSim/Kr92ER+746HEZJPQLcYTpcIA+UgcxxxTugTaXpzhmXrs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="438601854"
X-IronPort-AV: E=Sophos;i="6.00,175,1681196400"; 
   d="scan'208";a="438601854"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 18:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="792173933"
X-IronPort-AV: E=Sophos;i="6.00,175,1681196400"; 
   d="scan'208";a="792173933"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 18 May 2023 18:51:12 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 18:51:12 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 18:51:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 18:51:11 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 18:51:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCfHNybTkGk+3FJJxkSCCibzVr4whFiKr/RMmd9eJ+PGBe8SGZj0GdQ7JkgL57i+6EegmnT5O8IQ0xLYFymDkLE9b9+w+PaWYLr6EOcKggKfOAwdn4XkgVqjutGn7miCS0jBa3EW/W1KrfOybLXJmk6G6tZYSjy5wo9n8C86J6ot4E7ldPWA4cCkCOUEPPWeBKADY0jTbkedcLoCxVER0rJYfdwSk61T7cI+Er35aylth3S15dSYwytF9u6LH0BFcP7XUIEPzOAGchuEoTGLOc+Qui/+qViYD4gmwl0bogY8ke/mPYA6yeba4Ja3XHV6Ec1uC3TDiLxlCx2Axtgpvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZvTO2OyXOqwk7hmPcncWAYYQJv6E5h6lu6ZFm5CKFYg=;
 b=TVkWyeQESQoT4qOzaES8H0lPP618pCW9V7WDOUdHrP+5ZEHfy8ncTekqz5nSW+EyAAc6Vbh0fEhNQOn4hV0eEr16p70dS6vjLgfl5/x7mS9WnAo39Fo99WHMI5mUqcSuEaquxxcT0tmQhQ/Sv3jP1AZ2OOLAhT0OYjisZHwfdPbIedVmLI6bp0XRc8GLxQObF8BYYUSrtX3g1baZC0+Rfh92/O76Ms0Fqc8K7HgBfz9jVzSZ6kdu8xR+0mcenW6SjBCW63eSy+RNqD3ebnEmcynMqPxT5B1Q8adM6ZA/AUp0v4s3PpwCpaNq634iapf1UQdhrXA9kaWPDT4fGHdt+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB6445.namprd11.prod.outlook.com (2603:10b6:8:c6::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.17; Fri, 19 May 2023 01:50:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 01:50:49 +0000
Date:   Fri, 19 May 2023 09:25:43 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <jgg@nvidia.com>
Subject: Re: [PATCH] vfio/type1: check pfn valid before converting to struct
 page
Message-ID: <ZGbQF57Jl+me7Gpy@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230516093007.15234-1-yan.y.zhao@intel.com>
 <ZGTwaP6peRcpl+GA@google.com>
 <ZGV2vF0MQwQ+LZRX@yzhao56-desk.sh.intel.com>
 <ZGZpTWnnbzAr+AwN@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZGZpTWnnbzAr+AwN@google.com>
X-ClientProxiedBy: SG2PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:54::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB6445:EE_
X-MS-Office365-Filtering-Correlation-Id: b9eddffd-b7c1-4ea7-63b0-08db580b7880
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xWF+G13ZHGTzE8d+YipH/rjYmMt7sRxrsa3wI1zFtGIbdm+pYwvAmVYOp9G98rsTdSeKSPE8E4asryzfdWTzEtwXl7oI1OLEfQnUOhyVAL4OmSHDQB3CGuFuZsCrDHSC95jLUVsUb8e4wP59e1eieZFtsl2tV6b0UEfj9wBieH5nrtl4Eea43NdMpXp7l/zbjOcGuj6NznfMRioujlpFB5xI//F0VwFRTeKW9z7uEyjK7qrntTCAJ57qk0TPoBAxNhmIMc0r+4Y1VGntCr/1B7hUJXDnxm0KWlwVNKB8FuL8tRIyvQcR4Ykndkg8CTkEPr5GmOpPC56N/1NI8mH7BSkeRDshn0dvedng8NBAZE44CvM+yph/mKSevp6O8h6e5oY4SBl8vOndMomVE85gFmKiVzYgf/0YBZDixbywiK8gVBzMFtH4bw3DEcF0MOpkfFRdplcIci2C5D+M4xT+VlESb8NJWISiRO6HMPw7cnCEN9j9oeS6RfBFanu0g3aSSmEddbbIVD7S+u9Ks2+Wr4Qtmbe/m5Bs1YH4i/XN1q4RwiLZ0PgRFH6duu5VOfmoMbzT6r1w3Gm1wSy9KoKqnTKpN3M8y3PydbLKnUUwlvc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(346002)(39860400002)(366004)(451199021)(83380400001)(186003)(478600001)(6666004)(6486002)(3450700001)(6512007)(6506007)(26005)(8936002)(5660300002)(82960400001)(6916009)(38100700002)(41300700001)(66556008)(66946007)(8676002)(66476007)(4326008)(2906002)(316002)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wI67dpplUYGhBEsJPGL7ro2+PM+jp6kVfqg938UT2txS/L2QKOXMAcRheFye?=
 =?us-ascii?Q?sGr5KTuVrKrA5FXXT+JisAirZ1tU4obeUtMFp7XjUsfxPFF/75gMYRoVeTLB?=
 =?us-ascii?Q?QToH8ymOWEG174j8IV2zG65OTh8kyR7mcgPKdFf2cfJxFZuAqHiEjPG5YflP?=
 =?us-ascii?Q?aRYW6EuxPYXD0ut4DqGQ1IQ8fNo13KoSCUgqcAdlFeOlMHIxcPHklTk23N/G?=
 =?us-ascii?Q?IsWRDtKkHcF79r4c8ZC1Kwcf8o6O90ucqoYaG5iibDXBo2Wtohd4iRGpQZBF?=
 =?us-ascii?Q?jBYIzJJznDkNQc3f+AqEXEn0T1HksHuyXA/uJccg972gAsZyacX0iC2ovq4y?=
 =?us-ascii?Q?HLxFQnbPfXLweDVHWOjMCN5BNxWNLIF+pBQTnJmbYRzAO6b+2YtbjSvWRwhq?=
 =?us-ascii?Q?Gz9r6eABRBbFs22kIEyoHvYxJi1e7UuBzpQsrdeKUdGUcvxYerFj6hY4O7Mv?=
 =?us-ascii?Q?lRwkMb3YD0TAc9RtpV/khC7gFG8D4HDo6ApMcv0v1TcuXWle8LjwscB9ef7I?=
 =?us-ascii?Q?NGEZTDt1e3h35N53PoAuvhzICamywsLxBJ9L/HDQkNy9De3VT6PeLgWN2yNf?=
 =?us-ascii?Q?NZ7uoukOsD2alwLlHkMCp4pWRbVy9gLnd6wD0toI+GeoG/++e6UJuzW6LDtC?=
 =?us-ascii?Q?LEyuzSGtawy5rdLhZ05Y5Fkc8KvghIuZJy5Q3ThSUKnXTWCVXxhwiBjE7Xb3?=
 =?us-ascii?Q?rt0drP+XFe6cb8wLafa2MYIl+y0QYmNwaU4nvuS2BCyhPuWwFvB9OgC+vrmI?=
 =?us-ascii?Q?bTOBLzBMqAG1lo+E8FM3TMTMImI8+kRxaefPQG7Yp0B9qoNu44pnOZT+7JZ8?=
 =?us-ascii?Q?dvQ5PbG4nVZEGnyB6GFq7sweRFu2jzExiiONGEoylqCTClXmQ88jTQqezIf7?=
 =?us-ascii?Q?B8hvjc0XVrabbrzJC+AhG54B4ncT1qGINFJkGk0gt3ZDwol2MH/FcNUgfdqv?=
 =?us-ascii?Q?qpYFzRX3rb0i8N3zf7B9M0q+rT4+AUh+7eJnPdxWFxh+Uht4ieiF8fmSnP5q?=
 =?us-ascii?Q?aejmVy8BHiEd1D7Oj+I7H3e8dJeS360gZVW4mg+x8M6OX71SL1lSVzBB333K?=
 =?us-ascii?Q?SXXGfFnrYcu1Ak72BsK3vKHxRX+pryYbsk/+DusOifThqj6KMCI+dSxde/gD?=
 =?us-ascii?Q?P+ESReLX593EmYLN0TF1NbOQ+9LTFqqU0AT/mtK8ZXVG1qESa0J55xEaWpOz?=
 =?us-ascii?Q?e/JB77P08k9AzgAW1WCLLv3chKMpWnz/nyizZb6Wjgz8bj9ymicKTwLhqxKJ?=
 =?us-ascii?Q?gQTVIo1XdJ+5BKpfLJwPYS7sUc19Vd899vaTf0zXBWx+oUtR9s3zwHm8DyXT?=
 =?us-ascii?Q?b6xaHqQdehgIZNJK7fVtp6JPrLo64HP/z25G5IJKQCZn3dbaXV9675IzTrw3?=
 =?us-ascii?Q?DuvZSSbLr0m5KHWTjNNLyeWIH3X0MY7YXBlFybQzOu/HBc+02BxXAa6LRiZJ?=
 =?us-ascii?Q?YjVrLxMl6DNR2bq/lBYmQgHPuiXxoiYu7y5OfRMPQQtzA30k0aCVlGHDtcps?=
 =?us-ascii?Q?UQkUId1fP0/BES7vc/mMnjJ5Ee8mDUPxx5R7vn+8I3dEljOiiQsWdA6X4bFE?=
 =?us-ascii?Q?az/acQoqT9EVTs198QJ+t+YF1cabkio9+hWUg7Xc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9eddffd-b7c1-4ea7-63b0-08db580b7880
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 01:50:49.4575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5MCwVh/G7xfN57sRKMVvv8PkYhm3D+HbybREPFKsbaorXPoQV1dWNB8XBmsTD/tkMb9JVfVH2wg35M7/LSQDGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6445
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 18, 2023 at 11:07:09AM -0700, Sean Christopherson wrote:
> On Thu, May 18, 2023, Yan Zhao wrote:
> > On Wed, May 17, 2023 at 08:19:04AM -0700, Sean Christopherson wrote:
> > > On Tue, May 16, 2023, Yan Zhao wrote:
> > > > vfio_pin_page_external() can return a phys_pfn for vma with VM_PFNMAP,
> > > > e.g. for MMIO PFNs.
> > > > 
> > > > It's necessary to check if it's a valid pfn before calling pfn_to_page().
> > > > 
> > > > Fixes: 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()")
> > > 
> > > Might be worth adding a blurb to call out that this is _not_ ABI breakage.  Prior
> > Do you mean "_not_ ABI breakage" with
> > 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()")
> > or with this fix commit?
> 
> Mostly the former.  I brought it up because _if_ there was breakage in that commit,
> then this fix would be "wrong" in the sense that it wouldn't undo any breakage, and
> would likely make it harder to restore the previous behavior.

Ok. Let me post v2 to describe the problem and background clearly.

Thanks!

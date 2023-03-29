Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E54A6CCFE1
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 04:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjC2CSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 22:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjC2CSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 22:18:45 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F59A1FE8;
        Tue, 28 Mar 2023 19:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680056323; x=1711592323;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=nLFlGs09xp7uQVM1QfP9NbFmAPQZERrO1MefSXzjnPU=;
  b=Ca0Z+waLq7bOimiq/nQhi4aXq+rt0aYcUMuNMQ+TO681BWAkv4mobFDq
   7VSaXhWrbCNE+PXsJfy0L5SToQ7tbBBsRROSUt+hU4zB4N+PznzsqqlBC
   iDvEj9GZ1sR3ymIPrjI5r470/VFk6U6As6fs6FLG5SQ3co2QCeedZ7FMz
   DwQ2k8FeNk3ZYKxv5TgUYZ9euLFoava7KxiXFH0ykgVws7a3gm2vBoGHs
   QmY62TCI7G7nZqf9X49/CUkNXZxihjTbTwvikOM5zTf/unSl1oC+vM1bp
   4MTUKrxhEQlCMetSD+fFDZALTqgxeQCX4fpnfLJ7UwnIcLEo83ujaGsXa
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="338254497"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="338254497"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 19:18:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="661431672"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="661431672"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 28 Mar 2023 19:18:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 19:18:41 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 19:18:41 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 19:18:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5vqUsPWj0lOzjdsiO7Vayb4GCV04079sMScUsCc+OaBecgcRLbRno6tZOtsMrx1maaX+/huJgVCLTKiyVk3UDJB0+u5QKQ3xTHoZOg/XVrHGxuWrL9VtdiPYiFKBgwBfS8zKnoGwGEap/6uClYogZz3l+gsiQcNAqHOTVX0Tl+sL0efBsZUsBf5iWSD0aATevveL6YbKJ0EJ1w1U0781i5vRD0Vb/UOMU2a8SsT8+YMjh9dLlk+r/kfCDHiBEwkihbV74zVCvS93gZAMbLzyoLmAK3DRYf2ACCs8/K6JM9XDTWGj0W6lgo5MGYf9Yyxt05O9GXwf1zseBf90BqPqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yU/uaOAyJZRomqcNqUG+/s6srzMiDnJyq7HBg1KeWdk=;
 b=mflG0td49uvE4YZMKW4OuAdLYvTaozGZMYFXXWuli1jEZU1SU/+whqF2Mj0EYgdC5+kPeN3mCtPyhrEq0pSIzZzCNN2y1mdfu/4KY98uX984R+tDBM4+u9VsdLAQcQ14DY8CP0MJZaCohCkctQ2hX27Yq2thxBrCjd0IjX2PmwGriOc/HMK6Iiuh7fmU8u+nJBB/2kgl/vARZ1JNUYKfm7iY9+0roBfbtZFobs1BatG/amdgx3M86DlptlfUE9JhUmxP8UJ0TLgIkp0W4vhRqFFZt5up883xWoqdQl8zDSQhc9twfdoUZ7xZIbDo8GmGsJNenzQfnbvzrJVNUZ+nzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM6PR11MB4676.namprd11.prod.outlook.com (2603:10b6:5:2a7::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.33; Wed, 29 Mar 2023 02:18:34 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%5]) with mapi id 15.20.6222.030; Wed, 29 Mar 2023
 02:18:34 +0000
Date:   Wed, 29 Mar 2023 09:53:33 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
Subject: Re: [PATCH v3] KVM: VMX: fix lockdep warning on posted intr wakeup
Message-ID: <ZCOaHWE6aS0vjvya@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230313111022.13793-1-yan.y.zhao@intel.com>
 <ZB4uoe9WBzhG9ddU@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZB4uoe9WBzhG9ddU@google.com>
X-ClientProxiedBy: SG2PR02CA0114.apcprd02.prod.outlook.com
 (2603:1096:4:92::30) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM6PR11MB4676:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b5d1599-0b37-4ccd-32f6-08db2ffbe589
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pK8wkL/PArnlxweIxbHhsLwcQuZGxImW4YM9kr3FfKRWsd6CzgdT46Bm8PEJbVDNOa/msThbCBrLC5MplMRhSo4vNO2AlCw/FvkEsOBl+pgolTKTT0MnpsOD3QG6/ImBE7zKYMXe61btYlxvrD6juNE4bNVTqOft3bSIXLuCSmHT07fhTBXnFErg6D01GpfB64zBYIoUzLXeeUYXT3Vv1JRpEqw5UUgDIm9mDfSl0iM3Tq5wtydPl63etsjjO5QOxFD82ghJ1k/hhN2qTOLaJ0riu29fTRIOYwWGfCjTZ6SLhj3PStwmyh+ahgayg0cavIdABdF7IJp4VAVPL0W/MnYTWV6rT7weeRDPoXSsrBqUJlSiWUc0Tj9LxisOOGNOtLs7RMGV8xwSQud4HYYfCvcVjZEEes67ui4HeD+p2RmssMB7G7sZp2/tGL6BD3Y+e/r+JdNmsgk3P/IGnTJK8tien8gIbdIpUMj0/f0JuGUxsKSduuTOZXDAilpKVDQ8v84CqW1qcFCUHnsZiAboZ3QADYgWYqcPOlswJZhJR5fyMGLO0Umi8NKoSiyGrnMF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199021)(2906002)(3450700001)(8936002)(5660300002)(83380400001)(38100700002)(86362001)(82960400001)(6486002)(6916009)(66556008)(66476007)(8676002)(4326008)(41300700001)(66946007)(186003)(316002)(26005)(6506007)(6512007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/eiHdVy2oL+x9O3xAoKRYHA/YKxI2xrD5VRHbc0XhF/Z5Kyl/4WsyOqO/grC?=
 =?us-ascii?Q?OUl8AtCyHUPgYldHOOewpIhTGJFiKNuAzTn8wS+bp0W00896oAKDpv80LSdr?=
 =?us-ascii?Q?5LK1EzBUlRQFbpxNY92PNsKzts+PxXVVX758RFtlFsNvm0IRy87qFjZqRVBe?=
 =?us-ascii?Q?7nrX+SNMItn9ro5AFnIrJ4pJopd+gKO7gqqZ7n0qVizZdI2ZBMmcxtQ1C/2b?=
 =?us-ascii?Q?S4Q85GTQHAXFyMSqW7iVvSGZ8Clk+ecaJK78ohqF94bwXvrHQzxlWVcbwWnm?=
 =?us-ascii?Q?zmLQZxe5pXmRC9kr0oLF64gdHX9RS7kr/SRFDu3aTdzc4R+AN3iPB8F9yyml?=
 =?us-ascii?Q?rVMmY3HfaJHl5gB31yjgvPAuzybRlaO4URLvGtineT7Lxrs7E0YvssvITXny?=
 =?us-ascii?Q?P6kvrZGiieqcwon7nKyNFsLKzrlfFFb8YLvrQCBGTnIe+PdBW422zhOtbo/q?=
 =?us-ascii?Q?0smx2R+4/SxiGY9sHgHml5SSDBgS1HPiDN7Uggwh6HfpiKDhxUjLRpEFFokL?=
 =?us-ascii?Q?TcyyaTq/ASsSJNR9/4CdsGRcxQnkyTqo8GznNLK8lrPGJsjI38BrD31c5mJt?=
 =?us-ascii?Q?fA+hk0A9dPZhK5QYzJ2wN88VPZ7sR77ULZWpzJl2lN6jUg/jy+mMzTGKxVWt?=
 =?us-ascii?Q?4Cl2HVeOpJKsEKdcy7oqXD+HhFmtu5SuDX6hfwC2KnnGQyiahs6JvAPcra7E?=
 =?us-ascii?Q?ElDQ16wea5+G1zylWXKXY/28J3GEpxmBCpPurCLBUnREXZGSIAPsGIPr1Omw?=
 =?us-ascii?Q?LFShi2byuyGftP5Cpi7plw6NY2bIZeLIC0dRpl6a0tXid38Ypg7nTXndyh8m?=
 =?us-ascii?Q?IvsH0yuC5O8xI2SMik/LYeUjXuE6XA0tUhR586+ntTa9apFSqrae58jd+KVO?=
 =?us-ascii?Q?lynrou3gytxnfBqaDlTgExQ+Opit1jiHSPzvNW5L7aaRXtaPJmZ78kJoLu75?=
 =?us-ascii?Q?RNjghsq5VSJCIaGS91SkWOnF86yi19LZqQgBr2kWTm4WbBVQECsFzIpbNBFc?=
 =?us-ascii?Q?oPgPGLmknUnh8OE+vY5yIEFV6ihzpKAdjPxxEJlbJfJXWu/rnDoVp0zuOrfi?=
 =?us-ascii?Q?wextp4LuKiwmXXsTEkafCfd63Kqoll1DjuIYQAoq/579bg7+wDO4rrngPEBj?=
 =?us-ascii?Q?CAfnChdauotoznxYaRzY4kKDfQzex2fn/KH6q4knzBj9FAC7XIjjPbgskEXV?=
 =?us-ascii?Q?gf6Ozp4UBI8N7OI8vuUMT/F1CeUlrH+mAD84+Ys54WnkrduUmuTmd4s/iX/B?=
 =?us-ascii?Q?MDWtEcZ0lEorsxAg6Pdt1Xc0tKErTdr4octPuGf2PhRVKKQBucTNhereBtxg?=
 =?us-ascii?Q?GRgOKVcZi9GEPwFsz1ylUIHhlKojYv8jdubu6t2x8IdYIJ2KaoPQrnQtd2He?=
 =?us-ascii?Q?VLFCNAsLrebjzh2JBcEnv3J69mUo8wVwP5FP3gVEauT2V8308ltaTAh9fkx2?=
 =?us-ascii?Q?F4aJMf03RDqj90O+jWfHcMTLoLaMkwE8woHp3Y0bKPqrYKFwtN7A4K4ieAMv?=
 =?us-ascii?Q?8yl8Ylti9tXaEYlnTInko7DGmiNVu7kIsrv49pdXI67MpgWTfYylh0ToICtb?=
 =?us-ascii?Q?3JWWHIb8wbRA1wZIVE+ddNUuCCIhT/y0ncVAdiPa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b5d1599-0b37-4ccd-32f6-08db2ffbe589
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 02:18:33.9473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4+Z36zbj393T1qYZJtAwzqWz7eSy8+gUlFnkS7PWBsrZietjb+IQSCCSgKLWY6+sN+1D9T6mkWp42FkAgLrOCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4676
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 24, 2023 at 04:13:37PM -0700, Sean Christopherson wrote:
> On Mon, Mar 13, 2023, Yan Zhao wrote:
> > The lock ordering after this patch are:
> > - &p->pi_lock --> &rq->__lock -->
> >   &per_cpu(wakeup_vcpus_on_cpu_lock_out, cpu)
> > - &per_cpu(wakeup_vcpus_on_cpu_lock_in, cpu) -->
> >   &per_cpu(wakeup_vcpus_on_cpu_lock_out, cpu)
> > - &per_cpu(wakeup_vcpus_on_cpu_lock_in, cpu) --> &p->pi_lock
> > 
> > Currently, &rq->__lock is not held in "path sched_in".
> > However, if in future "path sched_in" takes &p->pi_lock or &rq->__lock,
> > lockdep is able to detect and warn in that case.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > [sean: path sched_out and path irq does not race, path sched_in does not
> > take &rq->__lock]
> 
> But there's no actual deadlock, right?  I have zero interest in fixing a lockdep
> false positive by making functional changes to KVM.  I am definitely open to making
> changes to somehow let lockdep know what's going on, but complicating KVM's actual
> functionality is too much.
Yes, there's no actual deadlock currently.

But without fixing this issue, debug_locks will be set to false along
with below messages printed. Then lockdep will be turned off and any
other lock detections like lockdep_assert_held()... will not print
warning even when it's obviously violated. 

[  118.873499] ======================================================
[  118.880413] WARNING: possible circular locking dependency detected
[  118.887325] 6.2.0-rc5+ #600 Not tainted
[  118.891613] ------------------------------------------------------
[  118.898519] swapper/5/0 is trying to acquire lock:
[  118.903869] ffff88810f5cac90 (&p->pi_lock){-.-.}-{2:2}, at: try_to_wake_up+0xbb/0x510
[  118.912624]
[  118.912624] but task is already holding lock:
[  118.919138] ffff88885f7fdab8 (&per_cpu(wakeup_vcpus_on_cpu_lock, cpu)){-...}-{2:2}, at: pi_wakeup_handler+0x36/0x80 [kvm_intel]
[  118.931962]
[  118.931962] which lock already depends on the new lock.

Any suggestion?

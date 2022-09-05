Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0715AC8D7
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 04:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbiIECid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Sep 2022 22:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234561AbiIECi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Sep 2022 22:38:29 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1B02C649;
        Sun,  4 Sep 2022 19:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662345506; x=1693881506;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Ipp4tyNb9S8pGrOSQXS6cG8s1J6PXSbTrtxO2ZLbozQ=;
  b=aWXCOxeiTcS4vsdQ8ZFSeSFrDVAxwaM1XjW1tcEykUMXEaLhJpncFsVo
   M3ZF2r3Ut3EwNxNTAUek7ZNL/DymCcQuZU7Ox/Yr6VK/rQ/fGdxP4ZgZS
   YrqT85GoTvlciV68yfz0nIfamKcwkfZYWrtJbph/0MQTZ8/2jccMUDk++
   XfzdnSW09YCNiPJkYOYRp/kZ+zrqdior3Wfac5BA2iRlVdbFLx6MkzzQG
   2Z5goIErFCPeecfTU+/dOWE0dvVu0riiAmcO6aFeP8lzhGKtDKekdwj72
   FeV5Q2H9EGt+73csgFiL9VcTZxBkE2zlcRmpplf20SE3ZEuSlo0hSeTIV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="358008399"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="358008399"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 19:38:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="702734584"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Sep 2022 19:38:26 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 4 Sep 2022 19:38:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 4 Sep 2022 19:38:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 4 Sep 2022 19:38:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 4 Sep 2022 19:38:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AV0fw+IZAg6u9wPedOJalFrrLVCkiW9wKhNivnKZfZAAkj4E1+h/lKfBCYLmusbJ0ghrbO2uWrXs/3cLozbkNNdGlzRJRvNxNO9Gv32sROQY3Jxz0PoxThpyaSwmCYpOzSbjJRE/7MV06KmLf+kfJbq4B7W777VjU3IMJRv0jQ3fWS3Z+KtGoqVNCt7X5PV5uyG0KRmgJIq2TpW0uvHbOcZWm/6SEFBlmmohm5hYlj58FKsak8HkzYfsA9z4NArwqEriYoKxw0DEdNyQJ3Zuu3HISOIUPknfoRrU3KYTjwTbWd7WCqZEQWS2y5+9bMnZTeLv/n8qPvQAa9O3eQ18yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C475xN1ha+sdzrQ/Lsj+vQL3FaNfPLCXXmi2Sj5MQqA=;
 b=QVK+tumjimsPJour2mzkEV3FbdOG+CUV27sM+0twjAnR/rMhW/Mh3Qvf+cHwC1zLv0SyZi205jFcwrT1jyYZMNM4GN6p6ei1j+cdvo40hwdD6IZnV1k+hgEWP/TdkQ2usQObg1NKeeL+yyXln1fSG5110J5Yqjnak3s9/CGEX/ma+noWAmTSMpIBeFl4NhrP7VyPKjWsks+bUxxgbbbIp9yuV7cGHWHFGNOZ+a1F4IuVwnA2iffFSY9bSTy/6CmNsJ6laH/BTezDWLIbkszXmAjwx0ULJwRD9vkfVy1rMvGe/mFRCi2WFE8v7t/oDiPZdrRwFjnV7mYNP3kf6r3K2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
 by DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.15; Mon, 5 Sep
 2022 02:38:18 +0000
Received: from BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::5482:e4d0:c7d9:e8be]) by BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::5482:e4d0:c7d9:e8be%4]) with mapi id 15.20.5588.018; Mon, 5 Sep 2022
 02:38:18 +0000
Date:   Mon, 5 Sep 2022 10:38:06 +0800
From:   Philip Li <philip.li@intel.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
CC:     kernel test robot <oliver.sang@intel.com>,
        Kai Huang <kai.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <lkp@lists.01.org>, <lkp@intel.com>, <regressions@lists.linux.dev>
Subject: Re: [LKP] Re: [KVM] c3e0c8c2e8:
 leaking-addresses.proc..data..ro_after_init.
Message-ID: <YxVhDnUBWHxErg0S@rli9-MOBL1.ccr.corp.intel.com>
References: <YvpZYGa1Z1M38YcR@xsang-OptiPlex-9020>
 <04ce8956-3285-345a-4ce5-b78500729e42@leemhuis.info>
 <YxCyhTES9Nk+S94y@rli9-MOBL1.ccr.corp.intel.com>
 <57c596f7-014f-1833-3173-af3bad2ca45d@leemhuis.info>
 <YxH2X8gMWyJeKPRa@rli9-MOBL1.ccr.corp.intel.com>
 <e633e50a-a72a-0d55-7c96-a1853eff1b8e@leemhuis.info>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e633e50a-a72a-0d55-7c96-a1853eff1b8e@leemhuis.info>
X-ClientProxiedBy: SG2PR04CA0172.apcprd04.prod.outlook.com (2603:1096:4::34)
 To BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbdec1f8-3fef-446e-5e26-08da8ee7b0c7
X-MS-TrafficTypeDiagnostic: DM6PR11MB3420:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2i2hGGuXN1LnIUGb45OwCWN+gwgkW1DddTzG1TeUz34aBoQeGqKSEwXJrG1x/RNlETKwsce5sAPxOxP5BccI7K0D8Y3ElovEMotUZT/bb1bWB0enldWI7VfyjwKnKCfMhdyWr00xDIVHEdd2dHClKOo2LElnAFFe2Ilnk7Jtn5Ix8X8uWEIb9SVQf/qBpxYolvAgcED37SvRxn5ddOQ7pCMGkEXjKzrSUqXvZNOrW/Ri/TZV0F6iXBIi6c87oedRrm91OKzIeQ0Ata4xP7QGzwuiri7VeTFbg8ScecmpzasYoI+IKChikPB33RjKcJa1Yj9Yis4ujlWdSsIMcNYljRHX8UWUcM2EjUb+kjw6dsup9Ol947WgfanPxf+6oC1/8HW9WqCqVwNYGrtCQyR12JXBAVwRjYx55z+hKNfv2v5J0vBnIcTTVOdJjfvf3vVm3pxwrMXWIrosZQUaRfNCDrZtxHLnaExraagOFCvYhdPEFNDMRXOymuZ7fhy+ktLrS7F2ZiPGFrMuEUfZrOFyqwBV953O/Qo79rb6vy6ExiuByTUdh4CBEabAKcSlvbdD4ux62gIqSgzK9cY6Ktco+mzXc2Ck59OAXYlLZgA4B2SXipC5cZGaqMZRu40BO2lLHTMmmnranF8K/JquwJ4x9BJ1tzYgDFTr2E5cc2UfW4jLHLdi3LG5U3YZEqploiyKZzD1HeypLrMS6/oQdwY02c82/IAE+LQGiVUQezk7WVht1y7xqJZFWlL4x29fr3catrHeOTDTWZMsnsukrczmTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(396003)(366004)(39860400002)(44832011)(2906002)(8936002)(82960400001)(5660300002)(38100700002)(6486002)(478600001)(6506007)(53546011)(6666004)(41300700001)(316002)(54906003)(6916009)(83380400001)(66476007)(66946007)(4326008)(66556008)(8676002)(6512007)(186003)(26005)(86362001)(101420200003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q0xcBHvCSv3L+nEW46UzIpff/6H9EFCOXDtGRPhE5hUh2bVqObfHBd4HNB1U?=
 =?us-ascii?Q?gOkOR+oXzqZKRWuNGGFOuweVZTFjWp+8G5Ih8YvFCxecaxiq01exT6RSmIaa?=
 =?us-ascii?Q?ujtzBYk0QYv1H0+Gh0sFRF65uVsDixouqwKzdTvTR/ry4dGSYxe19XdCOGco?=
 =?us-ascii?Q?3h1zxRZI7ILQns8miQsHArU+/fEp+BQIoOp2rngIbmOQapBCaoIShR1VgIi2?=
 =?us-ascii?Q?mU9vq0SP0YemlLak3PXf8ZCXcJ4n4uQJv6+ftl9HDg19KVePQjvi1MhtcCdj?=
 =?us-ascii?Q?/HTWxi+T9zYtBqUQRg2aoidHmy5+VWOe5+4NkNA0lfl+C26YC9cgcmEeDrv0?=
 =?us-ascii?Q?7XuEzvpvB+k2FHBWHEVVmfPXur2xP9gS2LhaGE96Bnm5FTWVs5iqciPaJm1R?=
 =?us-ascii?Q?SmhYgIgyF8zCDgKkBQvtYr8XooLNA+FkUCcvBRB5gHaoq4+Bi2DhTNHQ4clB?=
 =?us-ascii?Q?hPwDCRcIJVBe+i5vAwuGo3tU8Ad+H+wxt6zTjgdPfqC1wI7DBlTetOhIh/6g?=
 =?us-ascii?Q?PZEh5D+CzJ2eoADP4KfrwyMk7G5B6E9xKGfji1GWrtgpJiXMeYkPRhW6IL7n?=
 =?us-ascii?Q?rsKte9CSjCyl9xCDtZqgHv7DNQQbJ2OfhsnC96IG7tWuuXVywso0H760JVlS?=
 =?us-ascii?Q?FPJ8hx8+faooVQkHMkb3hPgv7Vn6mgTvuaOkYSRS1Z7FVKCUjBsMwxlUvUTp?=
 =?us-ascii?Q?eJkGuNS/Q5uW19xCBS+/HI2/x2oV3v4a7VpZjJvjhM+AKiuSmOfjCqq7myn1?=
 =?us-ascii?Q?+6KeSY+zd2/nIm7loNIB9PEy8f566Fs0AQwTUVkYRWa2CrHs7GMhhGvan7+B?=
 =?us-ascii?Q?Sddl4zCbEYSR7wsANbEocx7zmAr4JKeH1StTWhpqEu09vg3/ajmruHbR3aJt?=
 =?us-ascii?Q?fUfthG2Vqefc7fQDxHT4HNn308zYJlUxZ2ZG+x5B7Gg/2d/q0i+ITo43GUzo?=
 =?us-ascii?Q?jzrUo8I5N7a8rWypAU19g32vSL4olfxIC8uvB4CA9lnPhbqvgBSRIsOAuouW?=
 =?us-ascii?Q?J/Ai98LyXbTt0EzA+20+nwLW5rL5QMgoMwPYugKcyKYMxzPX0skBYR6dMJ4g?=
 =?us-ascii?Q?48hCVHtXP+ld9HgepJXGhoHfc724x4TcV4/Has4qfIpRoduVbRmogSVAnl2J?=
 =?us-ascii?Q?qYyiEEJZEZMzFDu9y4Yz1KoEUCdBv7Z2XYsdR9DaS2hs0IUJhAXFD6esdxps?=
 =?us-ascii?Q?7ROPMK3da17oThzG4/PVcvuGu0EytQSRm/jOnKXfE5QdZrZ9z2QKi8kNPHfT?=
 =?us-ascii?Q?Qw+JJB68xyi8ncyVdvK7tMEuxlZDcLCghwxvcVmdLU2yEYjX+B2Dlww9oPHJ?=
 =?us-ascii?Q?DXJsysaFynXQNzDE0V2gjfAzD4jXaLzUKjcXt7PZy8oMF1fAU2bQn5nIVib8?=
 =?us-ascii?Q?lNtO0gaSqf/nQMrUpUGfKaPleQyWspvSOr5sd6uiesWqboNYDD2K45Enwpu2?=
 =?us-ascii?Q?GNJkrU36uLt1WsI2nvPpRLvClb5jD8ISJ6qijX+UUdPojYh0tWPI4G4bGdRq?=
 =?us-ascii?Q?zEZnVRhn9Zy7o1GE1nrCYrwU0cYKz6NGetdCizdqUextFfAIFx8qxV5iBrX3?=
 =?us-ascii?Q?CKv8O9prEUjEPwaSw20Ag3p8aCpFP+1Z8RPw8/YWmGSoXFU59baGd436M4Pg?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fbdec1f8-3fef-446e-5e26-08da8ee7b0c7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 02:38:18.4072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qQLdNFRWDb9iLuSUo4PSCQzK+auta0apMy8KO4JiF3Sl1Y2/oBMx0fpwC9nkExrMmoRx8aOY8ivx18aX8LPn4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3420
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 03, 2022 at 12:27:19PM +0200, Thorsten Leemhuis wrote:
> On 02.09.22 14:26, Philip Li wrote:
> > On Fri, Sep 02, 2022 at 12:54:05PM +0200, Thorsten Leemhuis wrote:
> >> On 01.09.22 15:24, Philip Li wrote:
> >>> On Thu, Sep 01, 2022 at 02:12:39PM +0200, Thorsten Leemhuis wrote:
> >
> > [...]
> >
> > Thanks for the encouragement :-) The flow/process is very helpful. We will follow
> > up a few things before we resuming the tracking
> > [...]
> 
> Great, thx!
> 
> >>> Usuaally, we also ping/discuss with developer when an issue enters
> >>> mainline if there's no response. This is one reason we tries to connect
> >>> with regzbot to track the issue on mainline, but we missed the point that
> >>> you mention below (it need look important).
> >>
> >> I just want to prevent the list of tracked regressions becoming too long
> >> (and thus obscure) due to many issues that are not worth tracking, as I
> >> fear people will then start to ignore regzbot and its reports. :-/
> > 
> > got it, we will be very careful to selectly tracking. Maybe we don't need
> > track the issue if it is responsed by developer quickly and can be solved
> > directly.
> 
> Maybe, but that will always bear the risk that something gets in the way
> (say a big problem is found in the proposed fix) and the regression in
> the end gets forgotten and remains unfixed -- which my tracking tries to
> prevent. Hence I'd say doing it the other way around (adding all
> regressions reported by the 0-day folks to regzbot and remove reports
> after a week or two if it's apparently something that can be ignored)
> would be the better approach.

Got it, we will follow this approach, to track the issue but remove them
after a week or two.

> 
> > But only track the one that is valuable, while it need more discussion, extra
> > testing, investigation and so one, that such problem can't be straight forward
> > to solve in short time. For such case, the tracking helps us to get back to this
> > even when there's a pause, like developer is blocked by testing or need switch
> > to other effort. This is just my thinking.
> 
> Yeah, the problem is just: it's easy to forget the regression to the
> tracking. :-/
> 
> >> Are you or someone from the 0day team an LPC? Then we could discuss this
> >> in person there.
> > 
> > We will join 2 MC (Rust, Testing) but all virtually, thus not able to discuss in
> > person :-( 
> 
> Okay, was worth asking. :-D
> 
> > But we are glad to join any further discussion or follow the suggested
> > rule if you have some discussion with other CI and reporters.
> 
> Yeah, I'm pretty sure we'll find a way to make everybody happy.
> 
> Ciao, Thorsten

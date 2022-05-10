Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2A7520BE2
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 05:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbiEJDVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 23:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbiEJDVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 23:21:42 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3E41581D
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 20:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652152659; x=1683688659;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+qLf3Hn6aP9OPTul5x+vsTYlXXHQAnG1RiYJ2QE6wRQ=;
  b=SeFYcLCCaKJjcPOLYnU8nBVogv3dRAmI734gsR2/1HSAmCfSvwzlaK4g
   EEXNcMyLIr5kRV8tPTg9/rGbKwqSXH9nC5n5tRQ5VQMeKmDiO3AeNy434
   FYPFtP6Gi2wRHfOd0rWbEvQC82WbGgRCe0Yi1W4L2NfuWBifgK0ayAqzI
   Z3ThZJJY4cDJrq9ywFrgMxb2gH80qMniDL+2nQGjY6BKYqEVDq/a1fHgd
   KJKJNY6B0dGHHSQmHdD8Hw9LKsE8JXzSdcIfJhknJ4NfzdKKAEBtj8TYM
   OtugUBYaUT80frtFalrAHx9AgVSPBEhEQgD6SAv+qy2NpO1tCyDJQ6dYp
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="329839757"
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="329839757"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 20:17:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="602261993"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 09 May 2022 20:17:37 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 9 May 2022 20:17:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 9 May 2022 20:17:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 9 May 2022 20:17:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwyFMO5dzy+xtshCCVG703jTsTSEtCa/ffwlm1tdGh4Cj31chS53Dmq4rVj+BN6oI4v/Sh6Qud2SnND6HjYiSapPV2G+lDJesIypGnuZxkTt5Mg8gCxQfrbhpbqF12jTZ3FR9B3JS7Ecn1LMve8XNUSLF49WGLxK2gNNUa1DH2AgY0S1/sS89gWVritIZsj3PdvFLB96Cy0maFNpgq/CnfIJoG87buBVv19S+6JAQPx6yqiLLGAQ2tHlmHAgG4pqBc841GDB3qQa5sue5rxkgF4BLowgRVj574SNYZDqjAlN/yVW3iXzzgU/ZYTHSvdy9HatgGxqIcADZWNN3tFThA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=88TKNyMSXE9WBc3w4q8EZgQ9U5kijYaC3OUaBE+wTtQ=;
 b=UgfcWIZUWpI+UG9kJo01S0PJ11p3CIgXAv6Uxl2GZty6/f8D1S8wDl4ieOYKDAXPSTsIUr1P4fRc+5NWDW61RKfx7qG2vHAeh5At/4e07IA2DkXU/MTNGcqMZoZ8cncb5+I6yMd8XQ4xUD5D3HJ7fWIPNRt0Vl75MQ80RePBltROFfH0HZcb7ObX0nP8bywnK0JC6xuLm0SL7Y9W8DLnYpNGTNpeaw09eT+WyLWjU/kqkLVt83gXpV4qfEjjMuOQhvE8ctv4bAOTIC6Tmf5hMlHuenbaCPJWTaPOYseOSYTf8yj7fz7mKml/Si0EGpjpQ1vzB1Ey3PIj3sHhfLaaUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by MWHPR1101MB2141.namprd11.prod.outlook.com (2603:10b6:301:50::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 03:17:35 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::21cf:c26f:8d40:6b5f]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::21cf:c26f:8d40:6b5f%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 03:17:35 +0000
Message-ID: <0d9bd05e-d82b-e390-5763-52995bfb0b16@intel.com>
Date:   Tue, 10 May 2022 11:17:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Content-Language: en-US
To:     Zhangfei Gao <zhangfei.gao@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "chao.p.peng@intel.com" <chao.p.peng@intel.com>,
        "yi.y.sun@intel.com" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <4f920d463ebf414caa96419b625632d5@huawei.com>
 <be8aa86a-25d1-d034-5e3b-6406aa7ff897@redhat.com>
 <4ac4956cfe344326a805966535c1dc43@huawei.com>
 <20220426103507.5693a0ca.alex.williamson@redhat.com>
 <66f4af24-b76e-9f9a-a86d-565c0453053d@linaro.org>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <66f4af24-b76e-9f9a-a86d-565c0453053d@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK0PR01CA0060.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::24) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a87a079-3620-4b0e-66d8-08da3233a0e6
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2141:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1101MB21417F14812B07ED0788DB5AC3C99@MWHPR1101MB2141.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vzV+cmmdMvUtJJciKugRTQXZgZUp/xnB5mgNmJ65UyXdeA5/vJ7U+T1KqVV6rLUBY7CHGTrnD42uG6Z64k/Vlpef9Mi1u5XbdAI+MuF+qRXkihObM7IoOh+OIoQ6nK3hQuTyjoyLGg+MKUa6SWcACg+GcVuJ/KofZKwzafAsKiMmZObHn7nk17n4O6PKErZLOqashL4fyfktdUfvGkr/tGISfOlhbU+ElbjfeCE4M3Z9Sc3LOPw+N2qVQhwdWJIUcjFuose+eWLXEanVv1V+Lqj3tFr7QdFShWnz2gnV+jS57TifisSjkBE4KYsh4N6vxs+yQR5nwBTQHf2Of/bboNYFTY6kZ5IW3CsSpwKY7AfO3VCHJ6YKb4qieT6bkCASFdYWnNhMq17v//Bmd+5yju2VZlnlhE8AoQ+dyVkCIQBpfCY6V3d0O+VSsaVlmAKTrB5u8VPXXm6QDbmqrOIeIN3qmkwr70jz5EJLrmzHVAVa6Q7Ucr85BOBJgLqhsyyq8MpPRyzaBXEbv1i6y43wRFBaojOZOfNGHMlFmcFAPgEB+C4nrKChflf55yijurQNosD3C8+A/IJzjmCePL47/4+7I+huuUd0jx9TsvfW0ARMIQFRAfIWVUNHAzLOpqQtoagrhf9rbMveYFvnXruJYUa7of0QqY/gPVKaaCHzAPv8qbTZVbsAnnLFtr/ibSPgo4TyLIyVpykgBmSMinjgpR3fyzZhnop7SDnSqaIRaLI+QbYIFzlPIZIulK/aK7u5O4oYNRkE8L+sqONGh+13cWLQ5hwKWyeZdUVA1ql1qQXS3Pt6HpnIqQmp6Wls0E3/y8YLFTfk/T86GxHPYFWIXj2N7RvKBC3AJRrdSxeQIU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(66556008)(66476007)(316002)(26005)(6512007)(966005)(66946007)(508600001)(6666004)(2906002)(86362001)(186003)(4326008)(54906003)(8676002)(31696002)(38100700002)(2616005)(6506007)(83380400001)(8936002)(31686004)(7416002)(53546011)(36756003)(5660300002)(82960400001)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3ZaYzlBQitTaklSNUJmRzJsYjdCRW1tQ0tvcGhlUDZGQ0NmREZFcCtQcXpS?=
 =?utf-8?B?WG90WGRjQ3NtT1VHWEU1RW5tQWdHMDcwTG1raVZIU2NuY0hlNTBsUmFtWjRw?=
 =?utf-8?B?T2lMN1BPUVdyODJuZEdmZ1lnemJsM09EaDFaWXd1eHpXaHZZMHRwNzN6ZWxL?=
 =?utf-8?B?WURBQ3RrWHdNY05idEJ1V0JmNFo5ZUJPUHRWU0JJdlE5Ri94MDNza2tPWnFL?=
 =?utf-8?B?V3BLWE5vM3ZYMVNBLzlmbmtPL2xQN0RkM2RkRSt1Z0tzZy8vcVB2ekJJSnJI?=
 =?utf-8?B?SVZsU2ExRjZ3VXpoVlk4R0FJMHBMOVNOOXl6OHJxNXh0YlJWUzV0Y2VLcFcz?=
 =?utf-8?B?UTVWOTBZT1d1N1FzYkNpVXByT0RoclNPTG9DRjBUQkZrQkU4UlBqK1JWSnRE?=
 =?utf-8?B?M3hCbkwzU0tWMGlQWUpUa1k0QWVtaUFpZWZtZWpzblRJZXVSUTN4aWhYRmdJ?=
 =?utf-8?B?ZG9MR2lwamdKMDErTVRFZVBoYmVVa2J3Y3ZFckhnNFlSQ1RDdXRKMmUyK0Vo?=
 =?utf-8?B?a3pEc1lCQUYrVytRVFNkUk5jZkF6NkVVR1FSZ0o2Q2lITUd3bUNhRW8zdjAx?=
 =?utf-8?B?c0FPUWd2TFgxUFZkUVFDQUJ2K2ZDd2xnK0U0T0FnL2pVLzVocjRIYzB5ZXVx?=
 =?utf-8?B?QTgvQXh4dTlacjAydVlqV3Q1UmlGUytLQ2puUnBsQzE1aURiblBjYlFVbWxS?=
 =?utf-8?B?WWtIaldMUElLdzJMRlBtbGlKL0N6RkNtVDNQVDI2T3J2ZnNGM2ZxYVIxM2J6?=
 =?utf-8?B?UG9FZDZBZWJ0MUpjeVM2QmdHRFRCRmxqR0ZFMVVvRWk3T0VzVjZ2RWtaSGRl?=
 =?utf-8?B?VXZISDFLVEMrUHRTS05Ba044SHdKcTFBcTQ3RFFPQTIyYzRwWkdabTRtdFFy?=
 =?utf-8?B?OURId3lGMWxIdHZkZmt4YnpLZXN1amJQcnFVVE4rTGpLalFPQTZLUXRnVEtu?=
 =?utf-8?B?UU40QS96Q1EyWHZMYTFHajZ3WjB3ZTB5dEdGaWFBVThVcU1TMjMvb1lRdzNM?=
 =?utf-8?B?TWVQMElOL243ZlNaTEpQajdKTXFMQkJPRDYzRjNHOTZnNzZwMkM4bnVpNmFU?=
 =?utf-8?B?Ym9zWTk2RkZQeGtVWGZzaEtyQ0NlNGxwT3BFMzd2V0xTempFbFE3N20yWUUv?=
 =?utf-8?B?WllOY1hHR1htVkFpUDc0eEh4MzlKNUl2RlY5RGp0RjZmaWVEUzlKRzUrejNq?=
 =?utf-8?B?bGg0dEpLL2hFZjhvbU9tcUFHY3ZqL3V1TGxJU3FEMWxSYUtGRzJlSDEvNHBU?=
 =?utf-8?B?N2Q0REJ2N1NuQk9KVDJJYTc0anVvWXBscXNxSUJha3FHdUFUN09mbWdKZHFo?=
 =?utf-8?B?UVJnMFpIOUNodkZhRnh6eld5bXBYZVRjNHkzcXJ2R1BSdG9kbDdITFJPc0xE?=
 =?utf-8?B?QzRMVEpLY093V2ZIZ0ZJZllhZndvV2F0RzIwaERWVld5UDAzZWUzRTl5bGpQ?=
 =?utf-8?B?MGgwdTdnbkdaOThTU1BUWUdJYVN4b0RXZ2tFNUNiZzZWUllKZXE1T1E0MWdN?=
 =?utf-8?B?clVTSXY5RHNub2NLbmg4UXlNcldySDNNclp6Rk1seGlBUnRXcTV5dW1zcUJW?=
 =?utf-8?B?VGk2Mm0zQUtVV1lSbGlXNThsdkRwUlBHVUNndllMSWpYc3BiMUtvVjd5ODMy?=
 =?utf-8?B?bGpONEdEZk40dmN3ZnVFUHJhQ0dwVm5vSVRmamNBZUhtWHc2M3dCU2JaSm1k?=
 =?utf-8?B?Tm91V21xQU5qR0g3R0VjalVoaGhjMThyWDJ2aG5hTHhhZm93d0NaejNrYllF?=
 =?utf-8?B?dEJ1WmQ1TTlicUZ3K3ZwOXRsODFrRjhLMEtLQUZRTWMxNndJSmQ3M0dualcr?=
 =?utf-8?B?WUF0S2xDMy9kcUtOaVdNdU4zZFZhV0FRWnlBc1V0Q0VQa1gvWVp0SEgxNmt2?=
 =?utf-8?B?NVludCtXTDN2TzdOY0xlVDJJUnNMMnQ2WU9oTmM2L3kvRWlOaStMTWxqNkt6?=
 =?utf-8?B?MDVEOFhFdXhOVlVCYU8vZGJqT3hDWWlEQ1YySWdZSkczdEFneFR6Zzk1a0s4?=
 =?utf-8?B?V2wyRGNxSzg1ZWpKbHVsRUZKdGRXYjgwWE5xVjdvK0VUQVFhMURFdGY1dHdw?=
 =?utf-8?B?Nm56QWlWVmZwcTZzWFc4UmlhN1FsZ0RpU1ZNNHpTVTNOUUxKT0x3R2hqVUtO?=
 =?utf-8?B?MFNsdkRkbytid2NjQ0pRdWRXbkFKZHRRN2crVG1oUnBpbUdYb2p2NTV1Z3lR?=
 =?utf-8?B?V0pNZUJFcGV4cDkzUHk3dE1Wd1Q2a0xuOW83ZzBFRHlDbHc0Q1U2cEI5NWNE?=
 =?utf-8?B?elRYWFRiNFFJQ21UWjFwM0krdUpMTWxyU2gveVhkaHNueUVqUE11L0xjbGM3?=
 =?utf-8?B?QkRYZ25TbXNJY2pvdGtraEtER2tweVBibmw2ZndCdTMzQUpvYkEzUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a87a079-3620-4b0e-66d8-08da3233a0e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 03:17:35.3177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4fCr2ScUQzFzd+tTYXbwu+gHp7+pDY8rp4BKVH8xdivKc2rnEyTzMi7xxFlAq4qRPcc0M/YI+vmmTL9+xcYI2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2141
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhangfei,

On 2022/5/9 22:24, Zhangfei Gao wrote:
> Hi, Alex
> 
> On 2022/4/27 上午12:35, Alex Williamson wrote:
>> On Tue, 26 Apr 2022 12:43:35 +0000
>> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:
>>
>>>> -----Original Message-----
>>>> From: Eric Auger [mailto:eric.auger@redhat.com]
>>>> Sent: 26 April 2022 12:45
>>>> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>; Yi
>>>> Liu <yi.l.liu@intel.com>; alex.williamson@redhat.com; cohuck@redhat.com;
>>>> qemu-devel@nongnu.org
>>>> Cc: david@gibson.dropbear.id.au; thuth@redhat.com; farman@linux.ibm.com;
>>>> mjrosato@linux.ibm.com; akrowiak@linux.ibm.com; pasic@linux.ibm.com;
>>>> jjherne@linux.ibm.com; jasowang@redhat.com; kvm@vger.kernel.org;
>>>> jgg@nvidia.com; nicolinc@nvidia.com; eric.auger.pro@gmail.com;
>>>> kevin.tian@intel.com; chao.p.peng@intel.com; yi.y.sun@intel.com;
>>>> peterx@redhat.com; Zhangfei Gao <zhangfei.gao@linaro.org>
>>>> Subject: Re: [RFC 00/18] vfio: Adopt iommufd
>>> [...]
>>>> https://lore.kernel.org/kvm/0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com
>>>>>> /
>>>>>> [2] https://github.com/luxis1999/iommufd/tree/iommufd-v5.17-rc6
>>>>>> [3] https://github.com/luxis1999/qemu/tree/qemu-for-5.17-rc6-vm-rfcv1
>>>>> Hi,
>>>>>
>>>>> I had a go with the above branches on our ARM64 platform trying to
>>>> pass-through
>>>>> a VF dev, but Qemu reports an error as below,
>>>>>
>>>>> [    0.444728] hisi_sec2 0000:00:01.0: enabling device (0000 -> 0002)
>>>>> qemu-system-aarch64-iommufd: IOMMU_IOAS_MAP failed: Bad address
>>>>> qemu-system-aarch64-iommufd: vfio_container_dma_map(0xaaaafeb40ce0,
>>>> 0x8000000000, 0x10000, 0xffffb40ef000) = -14 (Bad address)
>>>>> I think this happens for the dev BAR addr range. I haven't debugged the
>>>> kernel
>>>>> yet to see where it actually reports that.
>>>> Does it prevent your assigned device from working? I have such errors
>>>> too but this is a known issue. This is due to the fact P2P DMA is not
>>>> supported yet.
>>> Yes, the basic tests all good so far. I am still not very clear how it 
>>> works if
>>> the map() fails though. It looks like it fails in,
>>>
>>> iommufd_ioas_map()
>>>    iopt_map_user_pages()
>>>     iopt_map_pages()
>>>     ..
>>>       pfn_reader_pin_pages()
>>>
>>> So does it mean it just works because the page is resident()?
>> No, it just means that you're not triggering any accesses that require
>> peer-to-peer DMA support.  Any sort of test where the device is only
>> performing DMA to guest RAM, which is by far the standard use case,
>> will work fine.  This also doesn't affect vCPU access to BAR space.
>> It's only a failure of the mappings of the BAR space into the IOAS,
>> which is only used when a device tries to directly target another
>> device's BAR space via DMA.  Thanks,
> 
> I also get this issue when trying adding prereg listenner
> 
> +    container->prereg_listener = vfio_memory_prereg_listener;
> +    memory_listener_register(&container->prereg_listener,
> +                            &address_space_memory);
> 
> host kernel log:
> iommufd_ioas_map 1 iova=8000000000, iova1=8000000000, cmd->iova=8000000000, 
> cmd->user_va=9c495000, cmd->length=10000
> iopt_alloc_area input area=859a2d00 iova=8000000000
> iopt_alloc_area area=859a2d00 iova=8000000000
> pin_user_pages_remote rc=-14
> 
> qemu log:
> vfio_prereg_listener_region_add
> iommufd_map iova=0x8000000000
> qemu-system-aarch64: IOMMU_IOAS_MAP failed: Bad address
> qemu-system-aarch64: vfio_dma_map(0xaaaafb96a930, 0x8000000000, 0x10000, 
> 0xffff9c495000) = -14 (Bad address)
> qemu-system-aarch64: (null)
> double free or corruption (fasttop)
> Aborted (core dumped)
> 
> With hack of ignoring address 0x8000000000 in map and unmap, kernel can boot.

do you know if the iova 0x8000000000 guest RAM or MMIO? Currently, iommufd 
kernel part doesn't support mapping device BAR MMIO. This is a known gap.

-- 
Regards,
Yi Liu

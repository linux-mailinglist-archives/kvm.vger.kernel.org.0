Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADAE521CC7
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 16:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344723AbiEJOtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 10:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344966AbiEJOt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 10:49:26 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9696CF48
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 07:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652191750; x=1683727750;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zA2aAlDVtbF2HtH48KAc7Vey59yfoBnwyyps3y1lSyo=;
  b=b2PwPxmNG2SF+HKxoEmp1MAZL4mSp4l3Fxpp11PHGKVaFDZHXUOFwk61
   HSMb2UXcRvb4g0szaPahFwTrREGSyB7KB2yW8sXB3FcNIpzpde2x3zXdl
   fwOp5SSrbMWxBLYyfN0J4KT+ao+BBNSqjdbk3AB9lofKdyyfrnjlrdKZh
   7Xi1V5PiuPWTd+bxcp2FgVMOy6yutiM6D2c4BarbAdXmnpIrcMrTRzci9
   Hl3V7eQP61e9DAR+pDNea+fa/1Dm8tyum7Kq9hTGA+/WNHOY5abyXBzCb
   aOl4Pz6wUQhWo7LuHvtJ/3WROdgHwbyTV84e8pxspaVzXANvpleeGnfW+
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="249912792"
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="249912792"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 07:09:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="565658966"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 10 May 2022 07:09:09 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 10 May 2022 07:09:08 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 10 May 2022 07:09:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 10 May 2022 07:09:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDJG6eyZ8CgXYGVwnSb31xqhNQ13GAa8EU9p1kS/hn7VzjyoeUqLTvUKtYk8hWDZwamZENLWmyg6E9NAKdzH9Oc73SsJyLIHViUHa2C3u8HCY1RPIRHtlkdG9V0gA5cjLxfzC557tW6mzIa9V8qViC1TdOpWJBCkNzTQIRynhzV4JUZZiMkN1LpG+nbEybb/AuDm48lneV8ifL7liAh0oR1HU30yKayIAGZtUM7zvGoT5C/To45aRFCnYw/BEbBG0oHeY+shr0014uK8MRbplJGJIzrQ7sSvr9pZnBxJRWGkaYrbtxzkQ6UOvwB8ZsN9FC7nc4WZHe6rHj7AsJGz5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRGUMOrKDZOL11XmctCjeRZnp8XXsipe2VL24KMGGfw=;
 b=d4KEOMa6UORBSs6BBcjTCAu/Q/0rspciP0QZpX68bSjKc5UiyVUryLoCq84wKvtOa5i3jpkm9hentywNhjzWAAu6e7isTW7ocVmXwXl9SY0b7U33XrLV7gKT+YEVvUvS5ybw0aCVahSyOedo9z7xAp9/F2yaLDbmsEV8ETyomwRi+cAM7dvzCeB2tW2ORxO4PRtjWec3pz+wf8KZ3WxixbNDYJJdm7KXdpiBX9mZJ5/R2Yd/zEn69c5fEL3UMGNaZrDKsAPexrQP5Q0hKvhuc2LBtPyCES+ZkUfX6YfnoMYssIpMWVyIThpig6gV93hzU1uFlgSCgPm2H3Kq92mbtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by MWHPR11MB1405.namprd11.prod.outlook.com (2603:10b6:300:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 14:09:06 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::21cf:c26f:8d40:6b5f]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::21cf:c26f:8d40:6b5f%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 14:09:06 +0000
Message-ID: <637b3992-45d9-f472-b160-208849d3d27a@intel.com>
Date:   Tue, 10 May 2022 22:08:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
CC:     <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
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
 <0d9bd05e-d82b-e390-5763-52995bfb0b16@intel.com>
 <720d56c8-da84-5e4d-f1f8-0e1878473b93@redhat.com>
 <29475423-33ad-bdd2-2d6a-dcd484d257a7@linaro.org>
 <20220510124554.GY49344@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20220510124554.GY49344@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR04CA0076.apcprd04.prod.outlook.com
 (2603:1096:202:15::20) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfe1d267-d59a-4f48-0ffa-08da328ea4fb
X-MS-TrafficTypeDiagnostic: MWHPR11MB1405:EE_
X-Microsoft-Antispam-PRVS: <MWHPR11MB1405A39970927FD05439EC13C3C99@MWHPR11MB1405.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gfR44OVnaDWTFnyIHUh89pxxtS5q3YcXUS6qbC/BDk/pr0LKYOS+VF2y8/6X5X8+uPxYYAuwv/NwQ06u+ZQx4v9KWAcPCBTASl3m14pgyF4OGOTYS2q1grF2O4HuXo1xpsWwdqErX4YACIQZM9LQqEeCesrI80N0NAp3K+2K32UALe/F2xcg9VJ4iRSm9vb2aJ1HVM06+BaWxreJ78XwEj4QSV0g1hvz7TOpCC4ba31NziOcp5Z+IrtnYNZyicWaRZmtcQw1YhWPNhC/lUoD67kli/RxgmVRslQwbTX7Yk7274Em4E8b0ASCsd2/4cP3zzgBxPCB4VKcWmBUC3xo1c5SU4oND2XtCQnd2lSgt47Z4jP6tEOEQ0h9SMut7Z8TRJAfXLvQx5bIlLszYzs1LlkxHENocOxttIwZvWTSK3C7rcmn64ZuDkF/Sid4OvJrgBtetUxznmMPCoVZ82QUQ0jiiEgD3m7JsLYjqfheu2uWFqxm4GgUdTYgrjoA9H6TUJCgGLGqRFtzDiDVyWZ7J4Ec6Ucd8XPlXffo4QsBc/KV3f0aZzYdRafKf6ChYSqKubAKy3D7mLOHeB1X0ocjo7YIy74AefOjahs2yK8xjK8XLl/Kl1B5U3NnMKm+WdM28UecVyYrbn4+g7qnNk6oPM6FFe7/0upJZWZldH3MoDKqUAr6ILV6jh/AWcTVllD9xwPci3dY9HlOYL4CwFWywnWqYx8Zy1768I4+GcfY6cTItzTe+QDluCHkv45b9kzB/8nqtfazY5tk6BaadDjgQfX6iBNAAFDx+Kk+8U7T7BnmfPw3Ja39ePwEkLlYlytGKTUo8LqCFzlcctASYNhphg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(2906002)(36756003)(4744005)(7416002)(82960400001)(8936002)(31696002)(38100700002)(5660300002)(83380400001)(508600001)(4326008)(186003)(8676002)(66946007)(66556008)(2616005)(66476007)(54906003)(316002)(53546011)(6506007)(110136005)(86362001)(6666004)(6486002)(26005)(966005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFhkV0xJWktTR1RYR0RlSHRrRXAzTGs1Yy95bmpBRVp2MHpCUG9uTkphMHp0?=
 =?utf-8?B?ODIvNFNORHlBUEpZcndXaUdsTlA1RWozaG9HdjRFdHR3S3pYNlZqcGVoUEZZ?=
 =?utf-8?B?Z1ZCMFZpTlc5RjFHT1NVYldMRWtSdnhJMHVvTWZ6bkVSUHZNNGtmcTRhblVt?=
 =?utf-8?B?ZlJWSlJrZzdVb09rT1A3bmRlK0trRlNVaEsrbEIrN3IwQkw3WEc4MTE5MUJ4?=
 =?utf-8?B?SXJhZFhkdjlicm5rOFRRdWxnL3BQK05odXpsWkRmbzN3VHlKSVh1UHgvTkVx?=
 =?utf-8?B?VUl4RkplQ0RUK3VWTG8vazVrYjYxTFFPc29nY2N0ay9ET1FlL3V3b01Mc3FQ?=
 =?utf-8?B?ZjB2QzFRQVpwZkoyNy9XYXdzQVI2QTZRL0hPRXZXeHBvM2UzZ2MyRldWMXow?=
 =?utf-8?B?aFltY3RZTkc0TTEzV2RkUGl1OXdaQldOeTUvT0VxdlRtUytKeStJVjlSU0Fs?=
 =?utf-8?B?TXA0a3VHRWloRXk1SU1yaDBvNWV2WGVwZG5JV3kvNjBGMXE1dzk1czdBVHdP?=
 =?utf-8?B?U1hHOWVwenlXMDgwSVdSUEx0cEpNV2RJa29iaXV6YXdiYmE2RVZWTnpNQlRi?=
 =?utf-8?B?bUplcThhaUVPL05rcktWV09nOEFmL3VkdkJ2U3k0ZTNxclgrWFlyTERER2hT?=
 =?utf-8?B?am5TRUxSc0paWTJZTmtOcHhEdXRCWXJjbHozQmxJejluQkp4Zmh3UEE3YWNM?=
 =?utf-8?B?dmF3ajVPK012ZDJQTS9CQzVNVGhlMWJQUG83MjIvWFgyTS9xZFBJVkpocGEx?=
 =?utf-8?B?Y2xrQlBKNFhXSXozNUg2TWJRc3A2bFRIMTN6RW9vSVhTWEIxUEpNaXBLeURX?=
 =?utf-8?B?eUl2QlVvenlxellYVnpRRWV5R3dReEZ5ZVYyb2I0Ymg3TTdaWUY0aHM2Zk9L?=
 =?utf-8?B?Znp4cW5PMHZyZGRuL3R4MnNZVlgvbGUrbk15Y280NEVsbjMwV1kzdnVrKzVk?=
 =?utf-8?B?QUpRamsxL1RRbnJVL3YyNGQweFk0cEs0SFYyODZua1J0eHdXVEJxZGNOc3dP?=
 =?utf-8?B?Y081b3BmN3ZDNXZNRXRNT2ZHY2ZoZXlVelFDYnNlUzVURllZcGcydEtheCs1?=
 =?utf-8?B?Tm1Sb3V0SUxpdkZyL3dRNC9mbGtiOXdZWDI5QSsxRERGeTFRNmIzenRhS1Nq?=
 =?utf-8?B?S2RQa3F3azV1REpJWlVzR1Q3SkVmdGdGdFJGYmV0OEQ3NmpmU09yN2d4ZDBR?=
 =?utf-8?B?RHJmblN3US9DSU5GV2RtdUlDT0tKNHFNQURCZ2hsYnVDeGRUSXBrREVHaTJa?=
 =?utf-8?B?TUtNRU5od3pFY1Nmc0dXRkM1NlFlL2ZpRkhRcUw4NTM4TmkwdDM3Q3F1MHNM?=
 =?utf-8?B?c2RNbVRXTitRR1FCSTZJejh0LzJpQ3I5OExpT1YvYm0ya3dXR0E0R285MEgv?=
 =?utf-8?B?enowdmhwaVRNeFJTVk43Q2ZYTjNsa1Y1ZVZHNkxzVGlPZGRWcXZFNjVhdGhw?=
 =?utf-8?B?MWxSeEFldWh5RHdhUUZpTlIwbXQ0UGZERi9xaU5jK0V0Nk9SL1hqU2UxQ29P?=
 =?utf-8?B?R2RUM0F0Z0hPSThmUHNBVytLeDZ5bi9WQkp3eFVLMXhxVVpaZGtTaWlQQ3JS?=
 =?utf-8?B?WEFGbGVQSnFaQjk3REozbFBDZDFibm9JbXgvR2x4MHBzY25sQU1FZHZFRTJw?=
 =?utf-8?B?aUZYZGNWRm5NTEo3WGdnSWZLU1BhTVR4TUozb0svVVVGdG45dTJDOXVtVjRi?=
 =?utf-8?B?U2FzR2VLc2VVV1o2dHRhSWNhei9INjMySG5SeVFjSmpTbDAwNVNYUkozSndD?=
 =?utf-8?B?b3RPenRkQXZUa0YzYUp5cGwwekJna29md2RYOVRxL1dQZFNNdlFVNHhZTFZM?=
 =?utf-8?B?R3hQSTNSKzluY1Q5eFU5ZGo5TkJENmplR0JUQ08vdTQramMyYkk0YnJLQjZQ?=
 =?utf-8?B?RnIwL0tDQlhDemZBZkhvYVU4Sml3WmZaT1RyNVRqS1JWRXdSSDdyMTNjUE42?=
 =?utf-8?B?eGJtbVBVcEtlL0F4b1VNS1pPMmdwNG1adHNJd0Q0ZE9iOXJadytDcnorS3Ba?=
 =?utf-8?B?ZEoyYmlwNFZwS1R6RWh4RnBhNEtBSUcwK0hDVWh3Vng0cnBtM2lIb3J6dFRr?=
 =?utf-8?B?aWRuWHRmNm1WQ2ZWWmN6QTgxRGJBaHVzL0E1OGVuaXlYY3FHVHpCOGUzYlBn?=
 =?utf-8?B?b0RnZXl3M1RHMmRta3dxZ1RoaCt6WWpaV01Na1JtQUZSdSs5aTJJNlZxbkVP?=
 =?utf-8?B?dENybHZZelZpcjFUMldzL29OaEhHMS93L3Bob2d5RlF2aFllUmpib1hldmYz?=
 =?utf-8?B?ekszYVp2ek82OGFRbkR6aDNWaDFndWZsUVBmM29oSkZha0U1WHFDUHFOZy9j?=
 =?utf-8?B?TXRWRXEyN2I2a295U3YyYzQySFJZOXlDaDQ5YTNCckZLTnBIU2VoQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bfe1d267-d59a-4f48-0ffa-08da328ea4fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 14:09:06.2883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zcc6m80iYNtaSzqLPWgzFG15T2N7BQIyJOtGuC1NjzsOK8z1b8MtLQNQrZ3nSUoPEsfKV/a4ftCTqExqM7usxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1405
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/5/10 20:45, Jason Gunthorpe wrote:
> On Tue, May 10, 2022 at 08:35:00PM +0800, Zhangfei Gao wrote:
>> Thanks Yi and Eric,
>> Then will wait for the updated iommufd kernel for the PCI MMIO region.
>>
>> Another question,
>> How to get the iommu_domain in the ioctl.
> 
> The ID of the iommu_domain (called the hwpt) it should be returned by
> the vfio attach ioctl.

yes, hwpt_id is returned by the vfio attach ioctl and recorded in
qemu. You can query page table related capabilities with this id.

https://lore.kernel.org/kvm/20220414104710.28534-16-yi.l.liu@intel.com/

-- 
Regards,
Yi Liu

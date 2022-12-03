Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDC164171E
	for <lists+kvm@lfdr.de>; Sat,  3 Dec 2022 14:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiLCNqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Dec 2022 08:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiLCNqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Dec 2022 08:46:33 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A97A1B8
        for <kvm@vger.kernel.org>; Sat,  3 Dec 2022 05:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670075192; x=1701611192;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vZMoApNi1TJUZrxzSLBg80B0X29TibCRvDNGLW2lfJs=;
  b=ik5zgOCA+gx5rBsWL7jjVVDh0Qk7MTMYak+3NBN4h08LYDYTwrSjrU4F
   VSlaVdBnDH+325g5Se3wtLaazVpy2kraXgP3LAxat8T5PPL8eUi8gNcwR
   iDJyMbe/0kvEsF4V0zsJSSniHGh98ma/2szIghyhq7T1rehFjVF/r8Diz
   L1858ccqFq18vLbvRs7C2JA1xwSoGX+YznbDsWUIMyTpDTokH5CKHR4zm
   zVF9ebjDnt8b7NQQoBjaCiUjCgw0uNV9SA//hcUZ3h8BTJeuXLdZN4YNr
   ClloPBETdh8axtqpui1rgRRskW65p2xfRj01HNnLAj/M5uUvx3UTC+U5Q
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="313762651"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="313762651"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2022 05:46:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="751616494"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="751616494"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 03 Dec 2022 05:46:32 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 3 Dec 2022 05:46:31 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 3 Dec 2022 05:46:31 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 3 Dec 2022 05:45:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYdpD1eL0WYVOC/dT0vSeHpMU/EiqJFd+WYFWt2WuxLAFk6sDMM4MCUlJDRojz1fKlXVw1gcs0aGYmxdoaLjTcyp2lWEx4NT6xZyjxiUsRac4fcgBA1brgFs2tFpWSk3Wt7T4FK9eAUIa6Q+hbFjn8fx1wQ1Pj7KzIpZEYu7WkHGEK8AS0moQkeBR3wcg1fC+9IdJHQddCpeL/ibJELzuehgEIIOiCHiLCjmHVE4uYuJJi5hxOJyqqmrWXIn3Q2lxm5HSgHSiC4T6WRXz4xgqJg9cXTbKBK3DwQo/64N2CXIGzSAxct6DsLPKOYXNc70vunAusGQywP+eg0TZRoF0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZePgb/UDVkg6Gu0oNnTcxmfHVJ9Vm1YszAmp1HHVk4k=;
 b=Fs0WrYdfyI3MD9IVptml61kybBvTsriNfb7WN4ikfiemJRnT/wG+GuSzewbmviNaLqJWlvcUAKCstE8zsWa6TugcyKzHXDgfIpRtTp7g4oy/W5YNFdmVAVHsClBzlpVCDAWCoCdzV96wSFagb0sUS8lL4Gb2Qfy9+egSJoARj4NMwbKkYXas78EvGlp2cbEroQVT8nGkAxoMvAT3ZCXQ9r0sDE/uCxJeh/9tm3nt+5L6uUcBnMBzYuD2aAwo+Uy+k2OA5jMbzfdvjySEbS8+p7r+HrPSuthOXzK5xKgX8OCvytodsbMCBmbjTeO/x5edM1BZFwVWmBkYcxkWxuLuHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL3PR11MB6362.namprd11.prod.outlook.com (2603:10b6:208:3b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Sat, 3 Dec
 2022 13:45:45 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%5]) with mapi id 15.20.5880.010; Sat, 3 Dec 2022
 13:45:45 +0000
Message-ID: <549a223b-cfb8-c849-a7ed-ee510687da2f@intel.com>
Date:   Sat, 3 Dec 2022 21:46:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 07/10] vfio: Refactor vfio_device open and close
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <kevin.tian@intel.com>, <cohuck@redhat.com>,
        <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <chao.p.peng@linux.intel.com>, <yi.y.sun@linux.intel.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <20221201145535.589687-8-yi.l.liu@intel.com>
 <20221202145853.5c09b470.alex.williamson@redhat.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20221202145853.5c09b470.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::13) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BL3PR11MB6362:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f62a9bc-b400-4d58-d3f8-08dad534ad58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uJPkzw1PyH2ROZWSAFP1K1VEny/VEnEB6T+DwCEu6oJh7P8oJtKLN5g8y7hC2c5ixSnjvN3k+N5uOkoClWwMfrF+hWZklm71yROyuOjxj2tgPSCMKHkahvWHLhPu65OfgRzv+I2CzTsbzzLgtNIcgrrSAn7MP1JxwFNqOXXOC0ZRPsL8zT6KeYqA7eMsgYng908CW7jbd1j6CnhdUK76z76SVGWTcrSC8K2eHgwvbVK4CLrWlnFQG0wQmVdm1QuhBOV3nNiVF5ce99E6hM2vBDb6bfn+Ns1W/oFMcO0xWnbTDi0B0CbAZeYMePDPE7mhaPBcY6iT5v5d4htfe1mU9zD/8AGcvwQVH0qVnd2XxisBVQucfttiBrUnK0L1UDJW/Syx/D9WS7AljyO52aqacmw1RIa3uXn4z/A1PQv0AQq+L3UjErOLeiBgG9zuY/XGUs5hU1DrsjPdA2QtGd5X9IpKW3VOhsE7iRO27+x0uJSwfIk+io+hezcZoKyt2xxMbgN1OBVfdT3G0H9FCd9ykOrp7T0FTlc5veS9KNudWdsw0dbK9DoanS3+ctdyfJadAUwOudln8TygvGcRjgjDfbw3fgjSI4TTIy/6NDSPM7Q+O7Fo9Xi5aRV19IYQ0iHKsPLQ0gXQFHeBrP7iKo1YRu/TwQD/bIUsF9XfDb3h7mzFrf5LpvptaLUbd1b5Ms9GhBwQMfIaC9CpzJYGznN237xMWoytjauFIkE2b8Tzx8I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(366004)(39860400002)(451199015)(26005)(6512007)(31686004)(2906002)(316002)(6486002)(478600001)(6916009)(8936002)(6666004)(86362001)(2616005)(66556008)(82960400001)(38100700002)(31696002)(66476007)(8676002)(66946007)(4326008)(4744005)(6506007)(5660300002)(53546011)(186003)(41300700001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUNxZk1nZ3BTNGp5eEFPOFJQZW5jN2pQRFhkTWQ5VGN4am5DRFYzbzRxejBM?=
 =?utf-8?B?S3RrL1lyK0RwUUxMNUFBLzIzNDR5Y0oxdnZneWo4a0xkTWxuSmZXVHdpQnRp?=
 =?utf-8?B?RFo3NkY5YmVOZXlLWUNuVkVjQldrNzZFcG1DNjZyV3dyNFNQV2grS1BoTUJi?=
 =?utf-8?B?YTNydWdPbEdRanVaYnNRdlJBbnh4dEZjOTd5aGpJaWphaTRVNU5RbllQb09K?=
 =?utf-8?B?cTVxUmRhVUlOdllGbWlITUJwczlweEI3b1NieFhaYXI0bmFYUGNOSTJITTA5?=
 =?utf-8?B?YzErRmtKYVEvS0wwcEFvVUVTd1FiZ2VBUEdsenhpYkd3RGZWSGV0UnFVTnpq?=
 =?utf-8?B?V0d2bFBqeHhkVTlla1pmMXdrZm5ucVlPbldiMFlWNTFSVk53ekVBckUxZi83?=
 =?utf-8?B?NlJydnNQaHY2ZUFYQTRHRTB4bFZqb3Y5TXVBNDUzS0oyM3ZKZVkySDliUlRv?=
 =?utf-8?B?KzdOVUFQS2F4ZmpwVFVVNDB4YUd3OCt2eW9Ka05Ja3p3MGFQeHdSVVpEU1RX?=
 =?utf-8?B?T1NWZXRpUzYvSTRIWlAxMHVZZUswaFFqOEZzdlpkWXozSEQwUWlsVGNTWWU2?=
 =?utf-8?B?ekJTcVgwZVk0S3dFbll5MEJGaEsyWk5HTUxic000YmpFekROdWg2Q1FjL2tG?=
 =?utf-8?B?eHdlekI0Ykd0ZVpOd0x2eVBCTDVhSDdlZTRVMkh5RlFpZVlJR0V2L29TaytZ?=
 =?utf-8?B?TSt1QUpIN0FSdHBLZWtSNXcrek9vYS83WHFsaFM2Vnlhc3RCVFN1c3llVmIr?=
 =?utf-8?B?RStRMTd3MWJxQk1YMnZRRCt1VEI1blRSZWpuNDRCSnJpWmFmSU95emNiMUx1?=
 =?utf-8?B?cVV2ZURnL3NHQXB5RFAwNGdtOHAwVmtMSjhJUmJ4aUdOenp1SGVZNlgzZUVi?=
 =?utf-8?B?Z2ZNZVlHeVNEaEZQOHU0WXhKdnlZd3h0VjJwcjZtTW5QaUREMjkzK1hjUk80?=
 =?utf-8?B?bFAwcFd1OUxWRllBTHZZbzZTdG9KYWtETTVlaFdyRHFBOGM0elM0N1VuVStI?=
 =?utf-8?B?ejN4NDBJU2VzTS9NTm1qR2tNVWJIVUx0UENmeG9ZL0xVWTJPcXdnMGVlRnBs?=
 =?utf-8?B?dnZ2WS9BWnYwQ1VVUXJmS0QvOExlWGlIRTZiZkxxTFB2c1dqdXk3V3gxbUxD?=
 =?utf-8?B?VU40b3QzTkJaOGYrZ2JmRFZpbEY2bkliWmdJdlh1ZktZVGlPQ0ExSHJRbWFs?=
 =?utf-8?B?SVo0SmRCL0V6U0tJUWxHL3FtYXFYVUIvems0ZEtMQ0JCdGVZK3g2SG1iRmZO?=
 =?utf-8?B?bzQ1RVczM2lPbnMzODFyTVBkMnR1VkVSN3drVTd3NmVXYjhwa1FZWXhQenZ1?=
 =?utf-8?B?QmM5ZGtmN2pUZFZXSmVxZ041MHM5d2xNTFVadk1PSTFndFBMOW1OQzhzV2NT?=
 =?utf-8?B?TDRVRFFpcmQ4djNBRkZ0SE9pV2pCNW1kNDNyRVlyRUlTV25QMmtFVGdxcUhO?=
 =?utf-8?B?RGR2aEZ5RmVycGI5RmVwdWMxS05JTW0ydjBoRDZiL1RmNXBUUnIybC9NRUE4?=
 =?utf-8?B?ZllsTnRFUjgyN2kza09TajJNUW9nWTdLNDhlSzduc3VPemlwb1p4a1FyMUF1?=
 =?utf-8?B?RnV3dGRJVWJiN3Z6NGtubmdURjlmY1ZyK20vREpUczRySFk5Ny9ud3RYRHhr?=
 =?utf-8?B?NFllYk5DaGltaW94OGRrYVcreFpWSDRJa2l1OGozR2xOc25jL21Xa2RVWkUy?=
 =?utf-8?B?Z0oyY2tKTHVUR1dJbTVZaWI3cU0rbnVXcmpzbWUvQVZkMnVGK3UyYVRXNVZP?=
 =?utf-8?B?VFVNbTBycEpWbEN2VVV2dnNxWDRZNkxYMkVRaXE3MmIxOFFyMU4vai9DQzNP?=
 =?utf-8?B?d0pMOE1MemNWclVZY1lSQkZwck8vQjRNTTh1b2JEUExJV2d3d1QwR2s3K3lY?=
 =?utf-8?B?eVRMcXVNRkQ1eEtIaUQ3N0xBbVhScUI1eDcrL0QwSHFaYmF2TTZvRkw2OUpT?=
 =?utf-8?B?cUliS0N3TVZLWkErZWQyd2pRUE9qTXFnVlVEN1Bld3d1aGFmUkRkaFlaYmEz?=
 =?utf-8?B?RDVmaHFmY1VPclhHRnJmSUFIQmlFU0Z6TWNkZ0k4bFlrTXg2ajFqakR5cFNm?=
 =?utf-8?B?K0xOa1gySzZKOTAwTGZ1VkdIY3ROeWs3WlJOSDhheDFrUlpmdnR5bm1sSE5W?=
 =?utf-8?Q?JuxVcUWHG8MEB2dAM2VnAel6M?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f62a9bc-b400-4d58-d3f8-08dad534ad58
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 13:45:45.3234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bEmYTECw111brD8IyG1NBfGs3NQXFIwxBtxaCLbyOoNS2b0j4Hw2LjUXi7kGSbzZrUsIlO4iKxMKh4OlQNKvRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6362
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/12/3 05:58, Alex Williamson wrote:
> On Thu,  1 Dec 2022 06:55:32 -0800
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
>> This refactor makes the vfio_device_open() to accept device, iommufd_ctx
>> pointer and kvm pointer. These parameters are generic items in today's
>> group path and furute device cdev path. Caller of vfio_device_open() should
> 
> Minor nit beyond what's already been mentioned here:
> 
> s/furute/future/
> 

got it.:-)

-- 
Regards,
Yi Liu

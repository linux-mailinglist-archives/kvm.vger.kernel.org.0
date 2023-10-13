Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BFA7C8E2B
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 22:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjJMUOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 16:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjJMUN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 16:13:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C66B7;
        Fri, 13 Oct 2023 13:13:57 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DIEr2a005140;
        Fri, 13 Oct 2023 20:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=WJFTLwzUiDpaM2s461CeNTkPef6VysBcsCHOFgUZ1TA=;
 b=m7XgIXLYg5Q/eoqgWItohYo1ZvCq0AYWywKF9rTUnAYuOlGSoCFlZcjaEjSbUGm4/sOM
 hfpT6FqiiFL540HxShdhUPfjt9OLjpg7XMN3ImY6VYAjmwAmCVtH6dwIHHxx8En+rzxq
 LY/FzK1du8b7guz74/uzH+xlkFoMIPkWiexk/q1mDAcwpHWEVm+MR0e2FRoqPtC5f1/U
 GMnKSFvwAmsw5FhISibQnz3j6nonBURwLQvOXSn7FlLnquBPY72tAyLljGQUMsz5946W
 ofEzgrwfjfXfwlCOmoI27f40Ag2rPe3/VMOgzy/O5394kx/GQu+QqJrpcri4zkETDFUS cg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tmh8a33ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 20:13:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DJ5b5i006007;
        Fri, 13 Oct 2023 20:13:19 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tptcsw4gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 20:13:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1BQHNvDZY/JejYrE8izNOaDz4oz9mFLAOdoqBycs3IXNFqLcP8Lx4teWhnYbras83rdPvsxrkhg7JehEV7qykOQyESNQ7mVHbef21rZa2zdOTT/Q4wAZjGSHt3cnMx0lYaLYl5AHVTAM+BPQWIY98+h3bOPecgR0oZXQwZuagw1h1WLReBUuAOm7WaHYby54LF8jigVE6amLUFq3ebZS1yB2wq56biXyI0K7Nn2xNBtKu1/yE95+DNCnS7HJOsq8r0MK6/fKokFKNip2TgXMLACX4Yau8Nr8mT/q8kkzKIRSdeqv+VC/ovwmaMKMUEoSymGC65IRvlPCfhuEMf0uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJFTLwzUiDpaM2s461CeNTkPef6VysBcsCHOFgUZ1TA=;
 b=Xog3mDqfOZXL8+7KleJsobG9Nyz0IbHhRDJ7kvkmeN2JslXbENkbVeNIGVNKZKvLVQJt8tNNR2h4ulZ75RInEqeZIAHraZgX/Ju5eBcQY+8t3iTGbFt0tlxyj72vgo+l0IPnr2XgQ5vgG70NFvNbOf9KCXWFv6HTknH4+V5bWCC5JMUA6BrU1z4jOvqa9SzxUuSw9BeIOe3v73wYvis+dtBe8pXif0HXezcKj1EmjQQayMC7zLUhCMX37SoUHdLaStITWRp640946uUpYABqt5tt5iJ4S0GRvk5doSJZFXLU3Qkx1rNdftgMHtoDSTtJupH6tKPDtp3jGKoyXzsBtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJFTLwzUiDpaM2s461CeNTkPef6VysBcsCHOFgUZ1TA=;
 b=qPzzeDwOcM3/nfSmSLESKrtbrdo+Jk5fJvWRfu53yvft32+AoL8NzeyUZTtpQRMQQEbmvOZR5Nkai4wbAW4KETnHFj2HjQ+W1fm++u/3Ria89G8y3AvHwSN99Wt8SWbcg8SqtSwPVdZLOBwzMajdakW0fXIoKzqI8VA8ysqWNDI=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SA2PR10MB4618.namprd10.prod.outlook.com (2603:10b6:806:11f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 20:12:52 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8e27:f49:9cc3:b5af%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 20:12:52 +0000
Message-ID: <cf2b22fc-78f5-dfb9-f0e6-5c4059a970a2@oracle.com>
Date:   Fri, 13 Oct 2023 13:12:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
To:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Joe Jin <joe.jin@oracle.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
References: <ZRrxtagy7vJO5tgU@google.com>
 <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
 <ZRtl94_rIif3GRpu@google.com>
 <9975969725a64c2ba2b398244dba3437bff5154e.camel@infradead.org>
 <ZRysGAgk6W1bpXdl@google.com>
 <d6dc1242ff731cf0f2826760816081674ade9ff9.camel@infradead.org>
 <ZR2pwdZtO3WLCwjj@google.com>
 <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com>
 <ZSXqZOgLYkwLRWLO@google.com>
 <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org>
 <ZSmHcECyt5PdZyIZ@google.com>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZSmHcECyt5PdZyIZ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:207:3c::38) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|SA2PR10MB4618:EE_
X-MS-Office365-Filtering-Correlation-Id: a65f9cea-4ba2-4281-ba1e-08dbcc28c7bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QRQEhhTEQVJWR6rF9n6haVSUZOBSpaa6FJ5xfeMwe/lw9fbYPRjr5d8R1GFI15RiGEh5hQN8Rb+kKutqUUsPpa8tFJJXDJDc6I3s7qFg3gBPuH6VlgYRXeRTkngap0HEcsoE4co7S8xAADcoq0ix7E39FLN989YbQMcOqvZb5WKptdlCpegcf5iIYoqKTtsEwfyUPHc7Svn8K/CUu1I9jrNgefGdHnUV5llbudoWYuXiiIc5yshv5ASopmslovAFIRwW6FJbj873rxd2yz8z/4OJGv8cTn5/7IYzfguVMKsXARd0jlptGHJfNh/3x3foEwnGZ5Y5RojqqhEd/PdWG5mwC6eML5mlYSSOX+66pJI4ZiIMsv+LYSDEt5HYtDlRUzxUfPqs5zz0cqcuGSgauRQlVIxe796UmQGQWSvP7gxKqavxJjpF9aR05/5BevFduzb4hp5Njt8lQ/4SCJjrwatk90PvU/jCV51vz3VwoBidxLL51QDhXnz32/SuU5JaisHXuFrRcb1498Dw8HDf561sNV03DNesDi91ShsUTmTjQEOfMeGj2UsM3ig5iybHBqNQj+WGIvU+naNF59rdEs1MpeLY8wiYz4S3oN/xYSI3qjt2deo2llLvmDzWc9sGsMorYVzdg1be8MYTz3vKJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(396003)(366004)(346002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(83380400001)(6486002)(6666004)(53546011)(6512007)(966005)(478600001)(6506007)(7416002)(2616005)(26005)(4001150100001)(2906002)(8936002)(8676002)(110136005)(66476007)(66556008)(66946007)(4326008)(44832011)(15650500001)(5660300002)(316002)(41300700001)(31696002)(38100700002)(86362001)(36756003)(66899024)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0VXU0RkVURLMTJrUmdHMGRhRnVFMzVVVUdnVTZQNHlOY1NFcFNlVG9WaU8v?=
 =?utf-8?B?b2hUMFZiUU1LWXBHK1hXZHYvVUhNN0R2Q0FsR3ZEbHg0emxYblVWQ3NCcVhP?=
 =?utf-8?B?K0lnQlo4aHQ4SVVhVllJYW5SenQ2TVRNVFdzUXBJWVJKSFJEMWJINGM3TG1i?=
 =?utf-8?B?dW5WTzZrL1kxNDEvWWFwcUFsdnpVOUZDalVwVEVxZ2ppYUNYMXF6UmV1UkFZ?=
 =?utf-8?B?TkF1YkJGL0p4TFhadjBTZ1VaL3RCNUJCY3puZ2xLVGl3QlB6YTJrRkZHYkpw?=
 =?utf-8?B?dUVzMHkwWVpIOGZlMW8wU0lqVWdDRDB4cllMUUVyYWdWa3lrYzZwS3VIYnhN?=
 =?utf-8?B?RndDV1lHYUhkb1ZNcDhIaWwrTTM0c0hrK1RkTGN6SWpYSU9IWUdHbmN1QUs0?=
 =?utf-8?B?UGRlVW1vZk1keThxejdVTGxtbllaVkF6QWEzYXVjUFJ1REdTYVJTQnV5NFNE?=
 =?utf-8?B?eSszSHNVYVVudW9YRnhLTFRpL2VwVjBKcnkvT1lwL1pOaEg4SCt6eC82N2M3?=
 =?utf-8?B?bWxoaVBzZzhwL2dDSzY3djBZMmhtWDJCUmxuY1NocVR6L2NvZzkzd2F4Qlhj?=
 =?utf-8?B?RWVtRkNIcDlXY3ZrK1JUUU9RN3VZdytoc1BTaGRFcTJXQWs3Sk1kUjlDdyty?=
 =?utf-8?B?NDZTZFh2S2VnT2FNdWRkRVp6cVFFb2FScVJDS0tzOXVSaXVTOHBjcVA3LzZZ?=
 =?utf-8?B?SWo0dThxMDdXR0xCTUU2MDA3MDhEYmZOa1hnbDRnMzBsUisybVRGbVBHWHZW?=
 =?utf-8?B?S29PYXozZm1zR01sbmZTOHRjeTBUdGJiaHVYQkR1V0NaSWt5ODZyN2ZoN0Fp?=
 =?utf-8?B?Tk40a3NlVU1peGJjTngxeE5vRXVYTjc0NldXZWxmaHpjY0RVNVZyR2xDbEZ5?=
 =?utf-8?B?aWhwVm9RU3diTUV5QTFrT2gwTmVhNGtvelNtNmVocnhPdUtsME50L2ZvcTU3?=
 =?utf-8?B?OVRZMkxGTCtpanVsaVZiRXdqS3RIaUJ6KzRMbkhKTWZ5NHpUUnNTSzRodDBq?=
 =?utf-8?B?WlE5WEM1cXlxWmNORGZhZGRVcGx2UXpzb0g3VnBvdXV5YUtOUjBJN2Z1YTRn?=
 =?utf-8?B?ekY3bkFXTUtxc1pDU094c0RDVVExanUzWEdacUk0dG9QcndvQ3FZdzczWFQ5?=
 =?utf-8?B?aTZlUG90bnFiaE1jaXdDaDVLSlExY2RlV2l3Ym1OSUh6TEpZWFd2cXNVT1gx?=
 =?utf-8?B?MFlkUlVyNVkwVFRkTW5ydVVhVkRUMTVkVkgvLytheEV3bHpTVkM1aHJyR3lr?=
 =?utf-8?B?bkttM2oyYVZaNDB6OEdkNFBsTzErRnJuNzl5RjYzUG9VaFM4a1l4VU9GcVdX?=
 =?utf-8?B?Y2pkcTFMWVo3R0FCNWtsT0gwOStNMWUyOVgwdVF1bjBidUZNZ1dLdE5oSnNU?=
 =?utf-8?B?cEdqN29QY1BJRC9CQW1XVzl4dWNRUE5vZVU2T2dmS0NycFhMcmdBbjFDYTNs?=
 =?utf-8?B?azhGbE9KVEJ4REVhUi83V2VFQUxQemlJV0V2UjFnVHVhK3BLWXp2RGVPcG1B?=
 =?utf-8?B?ZmxWSGsva2lmMXRCL1F3R3E0dUkzR3ZWMUxqbmJudWgvQnloMUE4NWl4TVJC?=
 =?utf-8?B?VEh3a2Mwbml2d1Q3QWxnQmRKTlJjaDlQYWYxWXlhOTJZc2EvaVdkU0htU1Ev?=
 =?utf-8?B?dUFwTnhrYVdEZlJ2eEJ5VGtvUkNTZnNBVjBYTUNFZzl4ZnlPN1FnL3RQWjB3?=
 =?utf-8?B?anFmTjNTSGxEb3RxSVNYYU8zTkMrZ0NVMlJCTHE2VnRRUmJqRUh6UHJydWdn?=
 =?utf-8?B?NG5ubFNaSE9hNS93MVNublB2UUVnTE1Hajh6ZHREVXZLNU5VUjlzQzN0cmNC?=
 =?utf-8?B?NlNtaE96ZWwza0xMbzZpai9zU1FWM2xHSjExci8yV0tWU0k1WGhVaFd0ZkNw?=
 =?utf-8?B?eTcrK2dPWE8ydDVpV0lmeGYvRStGMlZ6eXRLWGpUZldwY2xOa012NWdMZS9C?=
 =?utf-8?B?ZHBWZkZSOFhjbURCM0dVcTRKbEM0bmtDSE5BNjVQN3JBTzZ1bE84ZmlWRlNH?=
 =?utf-8?B?R1o3WmY5U3hyb0dXanlkRm1oQk9zNkV1RVhmbXdBRGJ2M1FRa0kzbUhvbjUr?=
 =?utf-8?B?cHcxVmN4Rk4rbWNhOHhQTmdSbm5RRzFBV2dBZ0FjeGlNbDZmNmpuYmRiMHN0?=
 =?utf-8?Q?k0QktD6266jOhAWrVSkOhbIlH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dmFIMlFXZzhTZkJXQ2gxakdKY1l5OWJxRklqNmc4TWpYMmpqb0ZwTEJyOStS?=
 =?utf-8?B?THRBbml6L1A3TGdFb043SVZsc09hcng5bHByK0N5RzB6dHEzYkk1VFJvb1Vm?=
 =?utf-8?B?WEsvM2ljNHNFa05OdnlTTjhMa0YxU0twMHA1c0Qvb1ZwRDB5VFlIR2ZnUDJ3?=
 =?utf-8?B?a0NNVjRPV01sendWWFlHSHI5cVRmNHpma2tUTUdIS0QrM0gzUFNzSnZ1L2tr?=
 =?utf-8?B?c05LT1lmcTR0U3V5aXVBTXFPL2xHd3grbFdjdjd0enozcnJ0T3lWRVZ2MVVW?=
 =?utf-8?B?RGk5Y2ptRkF6MEkrUERvdWJlczJTRmpSMnpia2Y4R2dRWmF6ZWdtTU03bzV0?=
 =?utf-8?B?V0VscmVtcHpOOWNJRHVncTNlK2lXcS9YUE9pVkpTcVBXMHQ0QlhSKzk2a2JI?=
 =?utf-8?B?cVNxQlpCNDgzN1ZIL3VBZFhUbXNzbTJraWNaWkVJc0R3aUhtWWkwWHpVbVBJ?=
 =?utf-8?B?RUI0eWRxdm93ajAySS93UC9sMDErcUFxdUFkRURQNXBGYUZCU2FpMGtGaExz?=
 =?utf-8?B?U040RSs2MGdCaVlyenZSQ282ZWVDNXhGVFNkZWxHZUxCeWZkK1FFNXJMQ3ov?=
 =?utf-8?B?WERnZnZRcC9JN250RGdIbExlTmR2L0pWdXZtWHJOVSt0bE9mUkllYW5mbDI0?=
 =?utf-8?B?aDBkUDhXbFVRbnZtamEyQmNVN1VJWVN6aTJJK2JxZkZaeElneUh6UXcwN3pG?=
 =?utf-8?B?YWlrSXd3WHhUT2JuNEZmT0gwTUsyTThFWGp2WWsvbE9WMG4raFlucXUvSEVT?=
 =?utf-8?B?ZjZmKzB1NU5Vd3p0d1ZaSUxURy9Hb09xNnBUS3BXTm1FcncxN0M5aXVWM0pU?=
 =?utf-8?B?aG5vUytIMzJ2TVdvUzJwUW0rRUdhVEdVSFEyMkt3aVNUMTdQTXZ2UGhxcmho?=
 =?utf-8?B?SkZNUXlVcGdQL3lBc1hsT0xLVTJMcFgwS3RMbXBFMENmU2tRMmpNbnhSNXZE?=
 =?utf-8?B?MjE3UWJLRXRoWjlHQWlNNDJ3aWZjM0pqanVpK1N1VHhhR2tuY0o2UDdkbmkv?=
 =?utf-8?B?eHVuRi9MKzhRaTV2Wk5ma1BzZDRTazA1MDlkTllaRkcxVEQ3UkRJMk4zOTRw?=
 =?utf-8?B?SG8rQnRNUk40R1hoMG1VcDRTUWN1Ly9kNXVnWmpORkFIQnl6cTBJcmo2N0RC?=
 =?utf-8?B?VVdDTnpTUkl4ME9TUkpGcEs1aGlHTGFVSVZDdGhkNDVKRFA5cEdpd1RteitM?=
 =?utf-8?B?UmduYzVnVUdidm5BYTZjWFMzTm5yRHRuT2xOUW93bG56a2JvdTloYXNkUDlp?=
 =?utf-8?B?dEVlckNCNlQwaEUzcmRnN3I5dDlPYWpCdmIvSGk1Y1k3Q3REVGkzbVcvcFpp?=
 =?utf-8?Q?EfvmWRAYA5llR7LCeL6I/S4SmhlJe8o5LE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a65f9cea-4ba2-4281-ba1e-08dbcc28c7bc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 20:12:52.6119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWdDzItP89YdDVNZx7rOCzC87ZTIQwzD6InmLM9VQdY7Zg6ZddZtk70/XJf79/d5IVNgXBvKZYMsHKhqu1kTmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_12,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310130175
X-Proofpoint-GUID: 4-GkbRp4NcIZ2pJjfxlxlOCH67C1w-vh
X-Proofpoint-ORIG-GUID: 4-GkbRp4NcIZ2pJjfxlxlOCH67C1w-vh
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,TRACKER_ID
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 10/13/23 11:07, Sean Christopherson wrote:
> On Wed, Oct 11, 2023, David Woodhouse wrote:
>> On Tue, 2023-10-10 at 17:20 -0700, Sean Christopherson wrote:
>>> On Wed, Oct 04, 2023, Dongli Zhang wrote:
>>>>> -static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
>>>>> -{
>>>>> -       struct kvm *kvm = v->kvm;
>>>>> -
>>>>> -       kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
>>>>> -       schedule_delayed_work(&kvm->arch.kvmclock_update_work,
>>>>> -                                       KVMCLOCK_UPDATE_DELAY);
>>>>> -}
>>>>> -
>>>>>  #define KVMCLOCK_SYNC_PERIOD (300 * HZ)
>>>>
>>>> While David mentioned "maximum delta", how about to turn above into a module
>>>> param with the default 300HZ.
>>>>
>>>> BTW, 300HZ should be enough for vCPU hotplug case, unless people prefer 1-hour
>>>> or 1-day.
>>>
>>> Hmm, I think I agree with David that it would be better if KVM can take care of
>>> the gory details and promise a certain level of accuracy.  I'm usually a fan of
>>> punting complexity to userspace, but requiring every userspace to figure out the
>>> ideal sync frequency on every platform is more than a bit unfriendly.  And it
>>> might not even be realistic unless userspace makes assumptions about how the kernel
>>> computes CLOCK_MONOTONIC_RAW from TSC cycles.
>>>
>>
>> I think perhaps I would rather save up my persuasiveness on the topic
>> of "let's not make things too awful for userspace to cope with" for the
>> live update/migration mess. I think I need to dust off that attempt at
>> fixing our 'how to migrate with clocks intact' documentation from
>> https://urldefense.com/v3/__https://lore.kernel.org/kvm/13f256ad95de186e3b6bcfcc1f88da5d0ad0cb71.camel@infradead.org/__;!!ACWV5N9M2RV99hQ!Kv3rZZ4bxmh0LeZKB1dQQnbCs8aTkGnEWsWu-eSawdYR3qszqITOY_XkAlWZeIODupS-N18Mnc9TBgk_vw$ 
>> The changes we're discussing here obviously have an effect on migration
>> too.
>>
>> Where the host TSC is actually reliable, I would really prefer for the
>> kvmclock to just be a fixed function of the guest TSC and *not* to be
>> arbitrarily yanked back[1] to the host's CLOCK_MONOTONIC periodically.
> 
> CLOCK_MONOTONIC_RAW!  Just wanted to clarify because if kvmclock were tied to the
> non-raw clock, then we'd have to somehow reconcile host NTP updates.
> 
> I generally support the idea, but I think it needs to an opt-in from userspace.
> Essentially a "I pinky swear to give all vCPUs the same TSC frequency, to not
> suspend the host, and to not run software/firmware that writes IA32_TSC_ADJUST".
> AFAICT, there are too many edge cases and assumptions about userspace for KVM to
> safely couple kvmclock to guest TSC by default.
> 
>> [1] Yes, I believe "back" does happen. I have test failures in my queue
>> to look at, where guests see the "Xen" clock going backwards.
> 
> Yeah, I assume "back" can happen based purely on the wierdness of the pvclock math.o
> 
> What if we add a module param to disable KVM's TSC synchronization craziness
> entirely?  If we first clean up the peroidic sync mess, then it seems like it'd
> be relatively straightforward to let kill off all of the synchronization, including
> the synchronization of kvmclock to the host's TSC-based CLOCK_MONOTONIC_RAW.
> 
> Not intended to be a functional patch...
> 
> ---
>  arch/x86/kvm/x86.c | 35 ++++++++++++++++++++++++++++++++---
>  1 file changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5b2104bdd99f..75fc6cbaef0d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -157,6 +157,9 @@ module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
>  static bool __read_mostly kvmclock_periodic_sync = true;
>  module_param(kvmclock_periodic_sync, bool, S_IRUGO);
>  
> +static bool __read_mostly enable_tsc_sync = true;
> +module_param_named(tsc_synchronization, enable_tsc_sync, bool, 0444);
> +
>  /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
>  static u32 __read_mostly tsc_tolerance_ppm = 250;
>  module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
> @@ -2722,6 +2725,12 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>  	bool matched = false;
>  	bool synchronizing = false;
>  
> +	if (!enable_tsc_sync) {
> +		offset = kvm_compute_l1_tsc_offset(vcpu, data);
> +		kvm_vcpu_write_tsc_offset(vcpu, offset);
> +		return;
> +	}

TBH, I do not like this idea for two reasons.

1. As a very primary part of my work is to resolve kernel issue, when debugging
any clock drift issue, it is really happy for me to see all vCPUs have the same
vcpu->arch.tsc_offset in the coredump or vCPU debugfs.

This patch may lead to that different vCPUs added at different time have
different vcpu->arch.tsc_offset.


2. Suppose the KVM host has been running for long time, and the drift between
two domains would be accumulated to super large? (Even it may not introduce
anything bad immediately)


If the objective is to avoid masterclock updating, how about the below I copied
from my prior diagnostic kernel to help debug this issue.

The idea is to never update master clock, if tsc is stable (and masterclock is
already used).

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b443b9bf562..630f18524000 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2035,6 +2035,9 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
 	struct kvm_arch *ka = &kvm->arch;
 	int vclock_mode;
 	bool host_tsc_clocksource, vcpus_matched;
+	bool was_master_clock = ka->use_master_clock;
+	u64 master_kernel_ns;
+	u64 master_cycle_now;

 	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
 			atomic_read(&kvm->online_vcpus));
@@ -2044,13 +2047,18 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
 	 * to the guest.
 	 */
 	host_tsc_clocksource = kvm_get_time_and_clockread(
-					&ka->master_kernel_ns,
-					&ka->master_cycle_now);
+					&master_kernel_ns,
+					&master_cycle_now);

 	ka->use_master_clock = host_tsc_clocksource && vcpus_matched
 				&& !ka->backwards_tsc_observed
 				&& !ka->boot_vcpu_runs_old_kvmclock;

+	if (!was_master_clock && ka->use_master_clock) {
+		ka->master_kernel_ns = master_kernel_ns;
+		ka->master_cycle_now = master_cycle_now;
+	}
+
 	if (ka->use_master_clock)
 		atomic_set(&kvm_guest_has_master_clock, 1);


That is, to always re-use the same value in ka->master_kernel_ns and
ka->master_cycle_now since VM creation.

Thank you very much!

Dongli Zhang

> +
>  	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
>  	offset = kvm_compute_l1_tsc_offset(vcpu, data);
>  	ns = get_kvmclock_base_ns();
> @@ -2967,9 +2976,12 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
>  					&ka->master_kernel_ns,
>  					&ka->master_cycle_now);
>  
> -	ka->use_master_clock = host_tsc_clocksource && vcpus_matched
> -				&& !ka->backwards_tsc_observed
> -				&& !ka->boot_vcpu_runs_old_kvmclock;
> +	WARN_ON_ONCE(!host_tsc_clocksource && !enable_tsc_sync);
> +
> +	ka->use_master_clock = host_tsc_clocksource &&
> +			       (vcpus_matched || !enable_tsc_sync) &&
> +			       !ka->backwards_tsc_observed &&
> +			       !ka->boot_vcpu_runs_old_kvmclock;
>  
>  	if (ka->use_master_clock)
>  		atomic_set(&kvm_guest_has_master_clock, 1);
> @@ -3278,6 +3290,9 @@ static void kvmclock_sync_fn(struct work_struct *work)
>  
>  void kvm_adjust_pv_clock_users(struct kvm *kvm, bool add_user)
>  {
> +	if (!enable_tsc_sync)
> +		return;
> +
>  	/*
>  	 * Doesn't need to be a spinlock, but can't be kvm->lock as this is
>  	 * call while holding a vCPU's mutext.
> @@ -5528,6 +5543,11 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
>  		if (get_user(offset, uaddr))
>  			break;
>  
> +		if (!enable_tsc_sync) {
> +			kvm_vcpu_write_tsc_offset(vcpu, offset);
> +			break;
> +		}
> +
>  		raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
>  
>  		matched = (vcpu->arch.virtual_tsc_khz &&
> @@ -12188,6 +12208,9 @@ int kvm_arch_hardware_enable(void)
>  	if (ret != 0)
>  		return ret;
>  
> +	if (!enable_tsc_sync)
> +		return 0;
> +
>  	local_tsc = rdtsc();
>  	stable = !kvm_check_tsc_unstable();
>  	list_for_each_entry(kvm, &vm_list, vm_list) {
> @@ -13670,6 +13693,12 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
>  
>  static int __init kvm_x86_init(void)
>  {
> +	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> +		enable_tsc_sync = true;
> +
> +	if (!enable_tsc_sync)
> +		kvmclock_periodic_sync = false;
> +
>  	kvm_mmu_x86_module_init();
>  	mitigate_smt_rsb &= boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible();
>  	return 0;
> 
> base-commit: 7d2edad0beb2a6f07f6e6c2d477d5874f5417d6c

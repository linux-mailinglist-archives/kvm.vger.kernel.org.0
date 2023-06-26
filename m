Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E1373E2AE
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 17:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjFZPEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 11:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjFZPEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 11:04:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008C0130;
        Mon, 26 Jun 2023 08:04:03 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35QCoU6s022677;
        Mon, 26 Jun 2023 15:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=nP0IUVypZK01UvpVGKhSKsgPDZkYzgQDPni+ZnBfU+Y=;
 b=KSlmaDpO9ifrDflAfjjtzrNFUaRa1gza9GdHWDQzdBklt40wuiFG4CRlRm8Q/Q1IXn2W
 xyieZMm6pgAIpg9iI7AQb4yV9sA77XLAMzg/R4GFyvmiWhwXqhbuadNoDFZNLh7q6FkU
 23zMtbBKrBe/RPqlOEzMf+kiqQVLHKnGZeN2j8h9/o7liY7ZfqJBlsEnSKeoKtAEULWq
 +dDXmgl+JKCNT80/V5v2dGztCJGHjYYpoZNK+OVd1DBvLeRGsqlL1VzhSTbD0fZx0Rh0
 FRtWNbBoobvheewYmJlI2oz9vzdp9qja0+aGWQEQs08Pm87wQ43NcNMktp0ca2YXqU8e pA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rdq932vh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jun 2023 15:03:47 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35QEs35G033834;
        Mon, 26 Jun 2023 15:03:46 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rdpx8yrm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jun 2023 15:03:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5fk3QHiuTh9FJH47GkO7t+ZGKGNfeJNnM7NfKZodvtJewcppQig2PCeGTwJmoAnR4PIIB/vu5pKco6GHbSXHlhAKCQCEEPdbGUFhy6pEvPcwtMEUYUfwPx1VzZT6hyviHK3Y3JNE5nJh+QAZlVHACfYjUZ4+6Mv03juoIbNu8mb7hmfW19tATAXcJA85GUDyBfLNOynpYR9PUMCRdlLQY+Dpxz4doOkZPoXiSU/lWEL/LtitaCqBw0tRRjtmpj0lLtXuO/dNu1s8j0JBv1M5dC+l2pSUvRXwVDhNnjDvcbOu0P/vGApcqKuH7krd8LxymKBlxYBURj0R9U01IEr4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nP0IUVypZK01UvpVGKhSKsgPDZkYzgQDPni+ZnBfU+Y=;
 b=XgbPAH3IJiLA7xGqYqrfBYC3npVgvUnG4f+R9/j77uX5xptuWlVAubgHVC+qOfrz8rfPnsc5XFxDFaKJjMHF7BPielMnGAZt3Oa4wTPUs/S2ZIDnetoZ5gQUu/6HIVdxF4h92BX6fv3oS8ssI4m6D4nZl7byKRgun3HOBqi4BHLyqCysRRtYvwKauhGT7RjY2h7h25me6Xxxum0o/rCONjWq3RWd8heGYy8RwJl/1fIkqsooxayWT3At6UKy5xJ68OPc2IzK850bkQXwmR3eAAqVOVldTCmfbRKCOPElqzKv3fDSKIC78arEEsgQqHWlxNWN1dG9B+Hc6ObsAlgSZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nP0IUVypZK01UvpVGKhSKsgPDZkYzgQDPni+ZnBfU+Y=;
 b=b8B1QxlWw01QGV89HjcHK8dZpDGoK+Wx2rDX1tS1W1BNl3xnToraCCYKKQmnWR1ZTzUC1prp6JmLxIjoiO6RsHgaQ5y+t1AkPkQsa6iePu8pB0Y8tDfwEF6z4Hddh5u/L3B28RsH/08jkpoSdeIDqTInd8EZMeLefJMMlUcoeMI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BL3PR10MB6137.namprd10.prod.outlook.com (2603:10b6:208:3b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Mon, 26 Jun
 2023 15:03:27 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6521.026; Mon, 26 Jun 2023
 15:03:27 +0000
Message-ID: <216718d1-1e32-9ebc-bd5e-96beab3fdc1b@oracle.com>
Date:   Mon, 26 Jun 2023 10:03:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [syzbot] [net?] [virt?] [kvm?] KASAN: slab-use-after-free Read in
 __vhost_vq_attach_worker
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        syzbot <syzbot+8540db210d403f1aa214@syzkaller.appspotmail.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
References: <000000000000df3e3b05ff02fe20@google.com>
 <20230626031411-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230626031411-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:8:2f::18) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BL3PR10MB6137:EE_
X-MS-Office365-Filtering-Correlation-Id: 251bef17-610a-4575-7a6d-08db76567f0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E2wjFcZy84vLE4aaBDPjLQlVeJuJjMb+b7IxOuMZDvrH0zCu4hBlBWzOcMpenqX43uqxL+1NDqVOlNK/0EAMp80f+b8iv7ZJerrnwZVT1OYeY61SgJ5cD9sKcikrmPDX73hN5/YvDdO13Euwkaypox3U62oSdJD68zLFw3eW8M4u4VGHmKpDP8kpA1/xMNGdjCBc6h7aXtRhhA4n11t8hxpq9XPUCKOM3RGPUmE+6eXABBqpPpEYh3qvZG86JxrdCJSAyTOumI4OLLVRqrQ5PpHwh8ME3WUGBnDgw5daF+P6xR0VVWH5/SJioyT4goGs+Y+c98yGrc+a0SAhsyQqr0Nwj6VkNYg4jGb8II0kBpPvcQz2ZCLNbfi+/GqMdw8tdA51FOEvBJHFS+owT2GvA/mWpSI5mBG8TUQ7wMU43ZobRqYvJyW7J7/LOSqHy1d1SPh6Z1/s3rbIe4X0m6pcJMbsxwANv+4Y0MqcB5irjuCH9Ey6iKxUiSjdWbF4h8arHO7VzLF3lmgB8oi2FtlLLv9HzvSWkAWkeNbzKItkKgsYREQy6Jw68UNhjFWlKM+Jio8rTQgjKXBt5qORCcZjGxzPmDoO21n+cI0Kb/qQ6tNz0/OBILwXBdEDEo4VcKb8DDBV6Lp1n0WydYjScmQ0UpJesLB4YHjy9SuFGWoAFMuYmDDq5zFMAx1N3LdvNDyUpnvu3jjjqrdCx4USwcjPGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199021)(966005)(478600001)(6486002)(110136005)(83380400001)(2616005)(26005)(6512007)(6506007)(53546011)(186003)(2906002)(5660300002)(36756003)(38100700002)(4326008)(66946007)(31696002)(316002)(86362001)(8936002)(8676002)(41300700001)(66556008)(66476007)(31686004)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nk9kc0lvRjFDaWdXbGJFV01WNmpQWFc2K0lNejM2RVIwQTV5UXdhOGlJN3Rx?=
 =?utf-8?B?ejB0QnI5aG0wMzY3UUJXaFBnbkYzVmhYYWZJOWRyTkZjRkJ0NEdRSUZIeXRB?=
 =?utf-8?B?MTl1b0F3RVlEc2ZPSXZTWDl5enphK0F4cnVzMFdYWGFHclJOTFFyRjlPbkl3?=
 =?utf-8?B?L1NYSWtlSVBWR2JqdDdhQzBQUllRczJQVldNVUp1Q29HZ24wTHVTZmRkUEpL?=
 =?utf-8?B?RWxad01ubmpxa0lsdDd5OTYrNDM2aktjcWg4c2hONmlET0RFK0ZqM1Q4Q2d6?=
 =?utf-8?B?bDYxZGwzUSthYUMrLzhIMElMWEluSGR4ODduQXNzT25zZDdTZGcwVlY4c2xV?=
 =?utf-8?B?bHB3d0NXQUc3dm1CS1JMdmNNcHB1a0swcUZFeTNFRUFqTWN5MU1sZGhLVXpv?=
 =?utf-8?B?czZFKzZhb01xTFVKZG14eXpIUC9sVUlJNzMvRWVlM0hqckxzai9LUUtHbnd5?=
 =?utf-8?B?Y1VnelRLVjJGQ3VDRTM2dCtXWmFORi9SdklneGZaV2lqeXY0Sk4vdllEUCtM?=
 =?utf-8?B?anRTZWtldW9PRFUxU1hFYlppK3FWS293Y1hlWVVPZk1HalZZaEJFM3ZWME13?=
 =?utf-8?B?TXhzeTZmSXEzK29ZMDRpVUE3WkpxdkpSNDh6Ylk5eHU5ckFoaW9Wa0lDLzFm?=
 =?utf-8?B?WEIwemdjYXpJKzRkZTNrOEZGaU9xdGxzWnVUaUJzdHNJQjZEL0JtcnRqVUdH?=
 =?utf-8?B?Z3BiZUg0aE1qc2VSTVJTdytRZGJEeFFEMW5QN3h1OForak5aZk5Fd3BRZUp0?=
 =?utf-8?B?RjVlZ2IxcjIva09kS2ZwR1paNU5xeThJU00zb1B4SFNoMXlKcDQxR3NIRFlt?=
 =?utf-8?B?aDZXL1ZqOEhnSVFOa1Z1UHFpRWt1MDdjaXlBMDllOWIzbWN0NFZ2S2M5a1Ey?=
 =?utf-8?B?VjJsT1MwbnZIejV1U2w2cWM3MHdidjdTVlQyWU1DcUkwNU5CY1RGVmpraHg4?=
 =?utf-8?B?YkcxODNqZHY0VFNwdEZXcnZkWUJPWG5Qamx4Vy9GMTlENUJWMUpsc1UvRkk3?=
 =?utf-8?B?Y0tRRXBsOWpTYU5VY3RDZC9ZdzJjUlVKYlRmbWNOWDA2TjhVWXZaa3Y4d2dE?=
 =?utf-8?B?ZzMzeHRnNk9VbThVUm9wVmdqMHlnOUlIOTdZY3hNSG9nSCswcWhQcFprNlpi?=
 =?utf-8?B?cWkxek0rdm0vYU1wYzJVa0RIOUNJSmtBelM2QXRTdDRzNmlKY2RyeTlLVHlH?=
 =?utf-8?B?QW5BQVhLeFN1WnFvWVlxSWcxZlVJV0NjOTJiMHNaNTNSdVNYUGdQQTM0MVdS?=
 =?utf-8?B?YkVDbTN0WmlEdnRZR28xOEhVMU5KeWtSWUt0cU9QTnFTZ1BMSFBFdDV3SU9u?=
 =?utf-8?B?eTlScHpzVWx6cEJqbDIrZ1B4S0JyRkd4Q3pRTkFzSm9ZRVU0NWZZMXNMa2FX?=
 =?utf-8?B?M0tBMjhPY2cyT2FuVlpFVU9kK1kySGNKRnU5VkgyUENvaWFZZ2RLM3lrV3R0?=
 =?utf-8?B?ZWZMOERkQ21saEEvZGc1M0dZQkppZm93aTZITllqQ05pNCtiRHVscDhKQVRB?=
 =?utf-8?B?aWRTbEpOamZUaHdtU2dvVDJKRU4wby9nWnpQcVliUmExSUZRSXVDdWc0V0F0?=
 =?utf-8?B?K1VjSUExajF5eHYxbzR6enVGMWRNNkw3VkZFcUsvaDgwd2VNTU9mWkpKTjRW?=
 =?utf-8?B?NHZOM0lCTjN5STcvMnJkWkJvMmM4cDlRYXczek8vRWQ5T3JMa3RtZG5kZXE1?=
 =?utf-8?B?RUk0aFNJR3ljY215T2hPMTV1M1dBWEZXc1FOYlVnUjdWRW1pWGZ4VEdwelZZ?=
 =?utf-8?B?WElranR4d3FTSTR1TTZLOXloMGFxc2VteTVmRXhpWE83TFlESVdvdWdRSk1G?=
 =?utf-8?B?K3oxVjZRM0xvT283bUhscW9ySlZBQUhLbXZjNGNiSEtUUkZhVlVwMTl5WVl6?=
 =?utf-8?B?TytOWkI2dVVldlIzNldjMDZSazJqTW1IL1U1T1VlKzJ6VldoTndlUU5SelJh?=
 =?utf-8?B?TXlKc3dlQm9JY0tYVG92RU4xNGwvN3JKeC9nSi9lbi9mb0JKQUZRUGExV0RI?=
 =?utf-8?B?Q2VVQ3hHdmI5bFFmeDdaUmNHS3JRSy9IaEJ6OUh1aEkxVWdQNVN2cGp1RHVv?=
 =?utf-8?B?dURyaXNMa0NyZHBjZDlBQlR4NE56Q29HaWdvTm5HUmRHZWhOWDVyMWtadURx?=
 =?utf-8?B?dUpFRExBcHF0dzNaNStGMEJ0cGthV2tsYXRCRVBycjdBN1IraTZvT01lamN2?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SkZSeHJKWVJWTWJwd0w1OVdwR0Y3QVdDZFFRU0VkUkhvTzRVbWVXa0IvbW1i?=
 =?utf-8?B?MUtmbzQ4bXpsV3lqZGxpc05lWW5wQXgwSDlkZWVVZWRxYXo3MFZJdmQzMTF6?=
 =?utf-8?B?U05qeDVERUFKRjRRRFh1QUc2ck9NNFlrMmxDbEFSbEVWOHl3S2FOT1NqTEdu?=
 =?utf-8?B?dElXSjRyM0ZGTkxSTDBlNW9LbWhna21aMk40cWQ4OEpVOGJFN01PVzRIUEdU?=
 =?utf-8?B?S3RkaVh2N3NKMTFmMDFneTMzZ2VUMzM0b2FIS1FnQ20xUngzeHR6SWtPbmxL?=
 =?utf-8?B?elBrblY0blU0UUg3UFpHNm9aQzVibG5QTU1pMmI1Y3E4dm84Z2pRaCtKM0Jq?=
 =?utf-8?B?TFl5MkRER1UwSG1QSFNQSHJEWWlrSm14NlhzOWNBakJWakNhTWQxY1ZHZTBO?=
 =?utf-8?B?L2VIeG0rUVVjdTJ5LytaSm9senlUalZ2NnlDaWhnbCt6ZXpqMmZUTkhuZElu?=
 =?utf-8?B?OW9HNUlUWnJJaEdpTjQ4czAvTUlHSHpzQmpRWGJmVmoyRXBJSlltZk9Sd29H?=
 =?utf-8?B?aE5HdVhXRW01NjNOSVltTmo5SmFKNUtQTWNPY1B1NnFjVDdkUGNqYVFhSFA0?=
 =?utf-8?B?MWZDdUVncklRZFdsMmlDQ1hDRzZVbFh0TmNYSnRwYngwQXdudUFjRit1bUtT?=
 =?utf-8?B?d2hjZlRIUTdXV3pGaUdCWVZFUDhYUGx6QmpBT3VxZXdQQ1lmK3l3ZThCSnlv?=
 =?utf-8?B?eUJyTVM0UW15bGc5VFIrenJya1l6Z3NJWUdoazhkZDVGSnpWQ20vdGt2REQ5?=
 =?utf-8?B?SGJONmxVbllBbGVHV29reG4ra2V5Zk93eG5LY1IzT1Vrc1hXaTJjU3RGV1RC?=
 =?utf-8?B?QkdZdHZWS2R2Rm5ab3BsVGV5S0EyRW16QVp5bkpvR05JdkhaN0NiWDViNlFC?=
 =?utf-8?B?ZTdJemMzWVBYbHEzVHgyUTJ0VkVXK3RnUXZGZ2xBM25zUVdTSXpzMzlrWlFQ?=
 =?utf-8?B?U1dlSTJseVVqK1phcEFqL3BUcjFWVlowdUMyQnd5dnFiQVRsWU5DNWNmSTVK?=
 =?utf-8?B?enZZRmFOYjlEamxpblBISEpTV2RtY0JiOUx0SVBTaHFlYSt2MzJGOHVTdmdp?=
 =?utf-8?B?aC9pbVJKRzl5SVFKakJYUlpCdUhlSnMvUUVMbndxcHdGSFhSdEw5UTg5S21J?=
 =?utf-8?B?R1BWelg0SEFDSGYyUkw5bFlndzR6SkJjd2xRMTZDMDVZaWE0UEY0UWJNNXA0?=
 =?utf-8?B?NzUrR1RiMkpxMDRVdk5TTEZMYVVFTGFreDVPdW8vSVJRbTJwcGd4MVg0UzVn?=
 =?utf-8?B?RU9aZVc4dkh6SU1ibTU3ZzY1MGhQT2dpQTJmMlVQWUIzWStBdUV3eVZVekhR?=
 =?utf-8?Q?VObaOt4r3CMrk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 251bef17-610a-4575-7a6d-08db76567f0d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 15:03:27.5723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q/YvhSe74JlIRwq5N9Q80zj/uPQiaNy3Hbqu3q+mLvgcC9WNwZLqVckI7yHtRn/wxCukiDMqNttm4O/cXJlK9cXUII3VYzUG6Ckt/qsNR2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-26_11,2023-06-26_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260136
X-Proofpoint-ORIG-GUID: WhxrPaYxQ9QJ2gAfNdHAqZahDXFtl5CL
X-Proofpoint-GUID: WhxrPaYxQ9QJ2gAfNdHAqZahDXFtl5CL
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/26/23 2:15 AM, Michael S. Tsirkin wrote:
> On Mon, Jun 26, 2023 at 12:06:54AM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    8d2be868b42c Add linux-next specific files for 20230623
>> git tree:       linux-next
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12872950a80000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=d8ac8dd33677e8e0
>> dashboard link: https://syzkaller.appspot.com/bug?extid=8540db210d403f1aa214
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c1b70f280000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=122ee4cb280000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/2a004483aca3/disk-8d2be868.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/5688cb13b277/vmlinux-8d2be868.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/76de0b63bc53/bzImage-8d2be868.xz
>>
>> The issue was bisected to:
>>
>> commit 21a18f4a51896fde11002165f0e7340f4131d6a0
>> Author: Mike Christie <michael.christie@oracle.com>
>> Date:   Tue Jun 13 01:32:46 2023 +0000
>>
>>     vhost: allow userspace to create workers
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=130850bf280000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=108850bf280000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=170850bf280000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+8540db210d403f1aa214@syzkaller.appspotmail.com
>> Fixes: 21a18f4a5189 ("vhost: allow userspace to create workers")
> 
> Mike, would appreciate prompt attention to this as I am preparing
> a pull request for the merge window and need to make a
> decision on whether to include your userspace-controlled
> threading patchset.
> 

Do you want me to resubmit the patchset or submit a patch against your vhost
branch?

The bug is that vhost-net can call vhost_dev_reset_owner and that will
free the workers. However, I leave the virtqueue->worker pointer set so
we end up referencing the freed workers later on. When I handled a
review comment between v5 and v6, I deleted that code thinking it was
also not needed.

So the fix is:

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index ab79b064aade..5a07e220e46d 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -607,6 +607,10 @@ static void vhost_workers_free(struct vhost_dev *dev)
 
 	if (!dev->use_worker)
 		return;
+
+	for (i = 0; i < dev->nvqs; i++)
+		rcu_assign_pointer(dev->vqs[i]->worker, NULL);
+
 	/*
 	 * Free the default worker we created and cleanup workers userspace
 	 * created but couldn't clean up (it forgot or crashed).




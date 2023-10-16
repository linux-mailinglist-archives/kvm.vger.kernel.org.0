Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557807CA6B0
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 13:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbjJPL05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 07:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjJPL0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 07:26:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D7B8E
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 04:26:53 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39G6n5Z3022868;
        Mon, 16 Oct 2023 11:26:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=FDrWxR9mxSb4sFesz7tQAEop8FBxn6fqBbJuWMSYKbM=;
 b=GztloVLNyuApamaMG9zAIA3oMFs3g9kkpRq0aa01qrLZjvZ4g2ThcKPqFf5IQ6da3HNQ
 Wm4Opy9T1hx3gLA7814fGBpueYaZMJXDEvSn3XbWE4VrE7nShrebzMp4VjVprBBdhSJg
 HtZFD0fbKHGMmjWcM6PxsD+DLpPrRilnmkFvwBq2RGT11hSF331sExGwfAo2NwlA9fK6
 5xS2BlV2xI+F0gLcpwAEYjXwiDcGkjSffZVDB9BYKQLfNc8z8PrxEmWEv/+R+T3QKYma
 yH91dBWBuR5lFsa8/szn1zVdf+4h3DWxSGqCdt5+ujekZvXoAvYU8iOTXwwCWrdrHwfd DQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1bjf3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 11:26:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39G9UA6c040635;
        Mon, 16 Oct 2023 11:26:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trfyjr4cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 11:26:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jSr2OQKjmj1mTRvRnxGYAnPHEb8QMjRoJdBOEUPsQaH4MN4ZgYfAM/kLBqvzJzQV3dnPsFitvEadftqkbZAGYTqgdQPUFiuACCklwqUu3hvc6Eo2FZNvdKC6up2sDTc1fovYSqoNPwy+3I4udlYlr1T8k4vq16eWhnegaD7j4zAg2a9iljb8OaMNjk+NJGIctxmbVWbZsCLbLYRrZ9JNVTIq9G8tsvhy0sT++2V+p9fNlveKExopBV+DUY+0Op4GSlHC9qZqLZaEAPFCc7dySH/iHlaHjfsPrATHDN3VHQ0k2uK3N1YTa4uHRWWAQjSTf4kVpyYX5uJUoJKF4BBYeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDrWxR9mxSb4sFesz7tQAEop8FBxn6fqBbJuWMSYKbM=;
 b=akvtILlI64iwqzhtTJn2EtZVH8ZRg5gixk2JixBRW+411tgDp+0ryB+PlpVitJVmkUXw7doG6SvQICmxqK3xoVd6hfD1Qh9jnJaZyn3BifA5w4VUi98qXSyCYFql/hRLLpwBqr2Ld36lLhic59vstDGzmXSivSaLt5jXP590r1JwSUCyxF9KRKPbBT4AWfccjjjpcHk5k2i83RlPvO5BcdGj9JNouhQ3M2ZQFWl2H8QGVkLq+CnrPO+Y5I+B+e8zdSyeqWtObQsCOwdorbbpkGByHuOQAOV9ibcoNCsuuD2q1O8mr03CnaiF63W9NNfSstRXufQ8fVVz9cqjuTiFNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FDrWxR9mxSb4sFesz7tQAEop8FBxn6fqBbJuWMSYKbM=;
 b=a8WBhUcmPH2IA94DCCCfxpGFSxORYhyq6UwiCkm9sZ3hySGdZIrf6ygjomoxIEH2W3tL3XkeoOpmpiuVuuF17tcqQOgnTqfr2/M1WqsoIyrnqranIYH0lf6FDykk86qixQ4k15RkNTS7uQlyjVoMqECZSH69h2j9IvKuSe0ld/Q=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH8PR10MB6670.namprd10.prod.outlook.com (2603:10b6:510:220::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Mon, 16 Oct
 2023 11:26:11 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 11:26:11 +0000
Message-ID: <83f9e278-8249-4f10-8542-031260d43c4c@oracle.com>
Date:   Mon, 16 Oct 2023 12:26:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <d8553024-b880-42db-9f1f-8d2d3591469c@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <d8553024-b880-42db-9f1f-8d2d3591469c@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0133.eurprd04.prod.outlook.com
 (2603:10a6:208:55::38) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH8PR10MB6670:EE_
X-MS-Office365-Filtering-Correlation-Id: b9151b9d-7222-42e4-05e3-08dbce3ab318
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lzgaHdUi0DorOxEPuMMM47kTGzXE8U5qucBSLJaMk1Ug2B31pd6K2G55x5ztkpoy52gcDWuvKtLEE8MZtWoHeBRdwHuOHnx+fIaX4vrJJ1WFbkOTFKQq9NvEyN9Evu+ac01sMr1EMIeFWuavBy39UNDXjacKiJl+NqvsXsA5PPOrM7w24wV0j6RKV0gRYrQe5+3QeU3D8n9XT+j8jx7NRkMcLt3naVNCsV7aqFYcWU3ZH3CMFoLOuMV+1k5HrEIucXKMTadBkAdu5T+LEDBQ62wJYIWwsRVjTXcLo07dvZZrrgfCeuIX5PjJgcLr8HtifgBWBA00ONQX/OZXeO4RcEWJg2cHAjte9tOf9divnCZnM7c8a0EVMOFLXWFCNLHftPl9xLssKLko/06hMkrIV7ivPsPrr18JpjTzGhOOkja6wMEtfyO/1Jvs4229x9r6Rx5kx6uZdHE23eGWd4ukBrerP5BL4KCFsQjakcWA1TAoDMkznieUP2z1ybG0fvL/5zJwjELFtAvK6U+rHNLDwc64BrvupKqTX+stL16l5noxiMrdJyWKu3ZTsZ43OiKxrEkWkt4rGDyuR8pJRkqGXanwnvoV8KigNd+QsYAgIpYFOGtOQ5UwhnXsKG9ozl5KilQM4h5FTepNi1gjWYgU7k3+I7mrXH/nQdHSjGfI2NA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(366004)(136003)(396003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(7416002)(2906002)(36756003)(54906003)(41300700001)(66556008)(66476007)(316002)(66946007)(8676002)(4326008)(5660300002)(8936002)(26005)(38100700002)(53546011)(2616005)(86362001)(6486002)(83380400001)(31686004)(478600001)(31696002)(6666004)(6506007)(6512007)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0hxNThvVm45UFd3L0U5ZzZweFFFd1F5QnphU3gvY1hnd1B5bHVmTkd1ZTAv?=
 =?utf-8?B?UFg0REJxdVE3Z0NxY3hxVHZ2TEM5WFgvaDUvbVFWOHg0L2ZuemRtbFJiaVB0?=
 =?utf-8?B?allOZnZHeUVOUWphN0pvb2MydWlXN2JFMDNHMitHSk1ZZW8yZFdLNDZTRjVL?=
 =?utf-8?B?c3hobnR6bW96enl6Zk9kUGhyWHpNZytyVEc4cTdsNVV6Wm8vZXNMWVV1azJL?=
 =?utf-8?B?NnZ5TzhyZ0I3VGczaXFQU1ZCT1dsdVExUisxVUxRMDcyOTlMcnZ3aFU1djVN?=
 =?utf-8?B?U3dVUkdBY0hDMmgzWWdPUnM1L3ZqYVZ0dElVdjJZSlpsMW82WG1GUFRWTnhq?=
 =?utf-8?B?eGVGYy9mZWVEVlFTajFaZkZmR3k0cnhxQVI4QXp4OWNXWlZ4cGxpa1dMTmli?=
 =?utf-8?B?RHdyMFg3WklLS00wVHRVTlJiV3NkcEF1TWNUSUQ5NVJ3VzZNV1ZnSjNsYWNE?=
 =?utf-8?B?Q3o1SkRBcEg4MWxoV3NCWTJHd1dySXdKUkNXQkpScVhubGtoQ3EvcWpkNFlF?=
 =?utf-8?B?T0RJby9rRXlPUXdldERtNWtLOTVRdk5yMDRRUEcrK1FkUzdrZWljQ0ZDM1Bm?=
 =?utf-8?B?ZWVUUFJTNzd0Yms4V0l6OFBkbXQ5ZE1Tdm02cXNJRjNGd0UvcFVicUZTYnNR?=
 =?utf-8?B?RzREVG92MGJOKzB2ZEhLaW1NMUs4ei8vc1U0dHg2SUw0aWpmYit4WDN0WC9I?=
 =?utf-8?B?YjFMYjZXck1lYWs2aDIyTHZxMStEUERuOGNRTGJ0ZXNCN2RZblkrOVllS3ZE?=
 =?utf-8?B?S085c2FMZS9HN0k3WGpXWnhvKzhLOGtqVDdDZlpoMGR1ajdJL0dDa2NMK1RJ?=
 =?utf-8?B?TXlMUzl3TVI5R25zcVRHdDZqYklybTJZeTVTdkxEVWVvZ0Y2TWliREJYUlZn?=
 =?utf-8?B?RWRYektXVG5qK1A1Lzh5akJ0Rnlxc2t0TVM2bHkzeW12SFpwNGFjeGZPZ0FZ?=
 =?utf-8?B?NUVPK2orMzVkV1Z4OVVNaFpPNWFwcVZEQTNtT2IyREs2SmtkUW9ocVd4bVU0?=
 =?utf-8?B?WmgvY0lxcTY0VDU2YUVCRUF5MUJoYzROU2tkYzR5V2FmZkNmY25RNmlZSnB5?=
 =?utf-8?B?Q0JjdHNSb0RYQXhWdUhsWThWdkMxNSs3OHVNNlpNSGl5OFN4SC8vVThPVmN0?=
 =?utf-8?B?d0FKWjlqV1VjaG9TS1dnUnp3TWVjN2UyYmJ3a0YxTDdQOWxlT0tzT3NCd2RD?=
 =?utf-8?B?N2J6bGhjcTlEUWx2Mkh3L283U3d0ZFRtOXZUNXo5ZHVYNVErbmt6L3VIL3l1?=
 =?utf-8?B?ZGFDUkJiU25XNWRENjZoTkxOMks4c0VlejdwT09UUlNsaUpxb2hlazlsc1Nj?=
 =?utf-8?B?dHl0djhFc2I2UDdubm5RN0I5Nm5hSjAzWUdVV04zaXdBUWxWZjdXbUJ2T2ps?=
 =?utf-8?B?Q3Y4eGsvMVJ2N0hyWFhRVmxaNFU5cmZIQW55NjMyVW5MdGg4djZyRWplMGRN?=
 =?utf-8?B?RFhpZ3lHRjB6MVl4dWV1MEE2MExWNnljNDFYUi9UYkhDakRtQVB6RVJ1d2Zu?=
 =?utf-8?B?SzN6Z0RuTDIxOWhrcFpCU05xamNyU2FtVyttaE5JbTJZeUZFMVQ3dDJwMVdK?=
 =?utf-8?B?UVBXTHg2SFJSMUtkeFBXV3k2SHRleFpVZUxYUVZjVU5DNTBmaFNzdkIzTXpt?=
 =?utf-8?B?UlFjUmV0L0JuTms5OVUxWDNYcGtyVTMxbmFINHFwcUw1OXpFMlNxckZYZ0VV?=
 =?utf-8?B?dUF2b1FPWkwyekhFYWR1M2hpZjhMNlRobGdJQ3QwallqOEdiNHpIZmlYUEFG?=
 =?utf-8?B?RnVacnZ4RUo4Z09IUXFOWlRRVWc3bGxPOHdLUDBib3RDUytXT0ozclJ2aG4z?=
 =?utf-8?B?aTBXSHNOaFg3SGI4TmZTZVFQelRaa1VrR2VxYmxvNkIxU25KOGRwS2lBbG40?=
 =?utf-8?B?K3Y3elA0T2tMZkkyT0xLdldka2JnR0dzVkRrYituTUdKaEZhUFhKcjl5ZWJX?=
 =?utf-8?B?czVFN09NSmNKRFhqYmpCSEI1NFZMZHpKa3M5TFJhTjA5QVEwMkNGRUJtNHFv?=
 =?utf-8?B?VndySnR4T0t5ZXZxdDIrT2xmQkl5QVhGNmVwMjNyLzlaZGpPY3dpRG1GTGxv?=
 =?utf-8?B?bTltZU50WWtZL25nRmxncnJBaEpTWHJyNHZVdEFMMXJPc2p6YzBXVmtIVWNW?=
 =?utf-8?B?MnBnMXR0VCtJVlBFZFg2VGFhbWtoaFJZRm5VdDgyRVUrRW1kWWM5dGZ4QnhD?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YUtaNkV3cWhFU25YbWVIUENZY2ZxZ2lVajhDQkRwRndqUHlTR1VGMXlkTXdk?=
 =?utf-8?B?dDByVFBtbHhIQk9KSUNvUGFQamZ3MjUwQ01NS2pTdlVIZzBGMnJQY0tyUjBk?=
 =?utf-8?B?UnFJS1lsZEhHb0RtYzBuMVNhNStiNGM5MW9JMnBGSHFUTkdxdHNqTjFwaW1w?=
 =?utf-8?B?UDBXZ1dDWU9ObEh6MVVpaXNTSFBIOE03UmkwVkhhZmorREE3bmxsR2ZxaTJU?=
 =?utf-8?B?U3ZiN1pDb3pMN1o2NVJVblc5ZU1PM1Z1dTB1UzRXWEc2NFFzQW1tMThrUXBZ?=
 =?utf-8?B?cDQ1NkFRSVVBUk5aS0kxTi82WnBPNmlRQ2YwK29BRzhRNFBvRnRWOGRUYjhL?=
 =?utf-8?B?VWI0NDBoOVBwclY3WWpqYmFCUkMwaHdqaXhwOUsxbkc4RkZWcGVuQWs5TkRH?=
 =?utf-8?B?WU5YYW9pQkhYWXJ3aDJIQy9xUWRSdGxOeU16alNabUdRYU14N1BLRmFoVFJF?=
 =?utf-8?B?c2lxUGpaMCtENG5NNmxYamNuanByejZsTSs0SWlsQ0lobE5yQjNrY21vbjBi?=
 =?utf-8?B?dHlQb2VudG1FU3dkODVXQzJiTVc1ekYxb1BnSktOaStlREZvVHZ0M1B2Z0RZ?=
 =?utf-8?B?akVHd2xBU2NsaFI5b25TMWJuNjlzSzBWMEJkWUs2WmpoY2wzTmxEZGUreldt?=
 =?utf-8?B?dXBQTFc2WDh4cGFjS2JRV1MxREErNTFWdTM2NW5nbHBKU2lVOU1oVHcyRFdY?=
 =?utf-8?B?SVdORTdkbjFYM3ozVVFvbG1ueDRxbW9UbHlYbzhyZFpmbjB6MzdTUUZ4c2M0?=
 =?utf-8?B?Z2c1NTNVVnpWTkdPZTBEblhxdGlJZHBQVzZqTGVaalRpZVdCT2x3ZjVTRDhh?=
 =?utf-8?B?R1BHODEyRDVrRDVJQ0htekRoZGpFa1hjU1FOYUc5WDlzV1YyS2s2eVg5T2M1?=
 =?utf-8?B?eFJzNldvVnl4TzhGM1R3YmpKT2lrMndZdWdxcDRrWFFGRnJEaWdKN0Ezd2Mw?=
 =?utf-8?B?Mi8vUTZBMGIwbUVtTGluRHpGdk5OR09hVnZTOUhuL1lWZnNiYVhCYU8rRWs1?=
 =?utf-8?B?ZnY3NFVmd3dlR0lXNVEyTGtKWG10cEZxeEtJM3lqd3ExWkNzR0Yzc1RKYlRt?=
 =?utf-8?B?bVRoVy9ZUy9lbXBHSytkdlF2QzNTV0U2N29SSWJsUHhoNGxEOXg2Qmsvdm9I?=
 =?utf-8?B?OVErQlZ6QVNTL2xSR2V1VVlJUkdJZDNUUHlIWWN2TTNiWXhRSnFQRjNmWS9s?=
 =?utf-8?B?OWkxS2xTNWkyZTJGbXNCVUV3b0dsRDNya1Jpd1JOdHY2NFVSeVovTm9XcCs5?=
 =?utf-8?B?LzJjdEJyd2lBQUgxSk1XNnBGWkF0R29Qa0ZpSjVJRm95dElJVHpmTWMzaWVz?=
 =?utf-8?B?SGdPWkh6OVp3bjczSFNSNUVWSTI0OUdpR3pHNjBBeHZ5eDduZXNjSEMzQUdj?=
 =?utf-8?B?NXJ3QUlsVXBVa0MyT1pQOVlCd0UwRzhhQ3JpeXBoZWsvd2JDVnVScnVoNGlD?=
 =?utf-8?Q?6J+xC8ch?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9151b9d-7222-42e4-05e3-08dbce3ab318
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 11:26:11.2884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XzeREWLvdxgjJqnt115ppbYR+/zEnfGs+ipBAZubzVRYqh63t9PWskWCG8H0Rp9SdCxOE32FZCHfG7PDeaa74JXayeO8Mq1h27epw+llnc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6670
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_04,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310160100
X-Proofpoint-GUID: 2CZfLZgRaLOqPetMQif1xOFbH0wvSfvq
X-Proofpoint-ORIG-GUID: 2CZfLZgRaLOqPetMQif1xOFbH0wvSfvq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16/10/2023 03:07, Baolu Lu wrote:
> On 9/23/23 9:25 AM, Joao Martins wrote:
> [...]
>> +static int intel_iommu_read_and_clear_dirty(struct iommu_domain *domain,
>> +                        unsigned long iova, size_t size,
>> +                        unsigned long flags,
>> +                        struct iommu_dirty_bitmap *dirty)
>> +{
>> +    struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>> +    unsigned long end = iova + size - 1;
>> +    unsigned long pgsize;
>> +    bool ad_enabled;
>> +
>> +    spin_lock(&dmar_domain->lock);
>> +    ad_enabled = dmar_domain->dirty_tracking;
>> +    spin_unlock(&dmar_domain->lock);
> 
> The spin lock is to protect the RID and PASID device tracking list. No
> need to use it here.
>
OK

>> +
>> +    if (!ad_enabled && dirty->bitmap)
>> +        return -EINVAL;
> 
> I don't understand above check of "dirty->bitmap". Isn't it always
> invalid to call this if dirty tracking is not enabled on the domain?
> 
It is spurious (...)

> The iommu_dirty_bitmap is defined in iommu core. The iommu driver has no
> need to understand it and check its member anyway.
> 

(...) The iommu driver has no need to understand it. iommu_dirty_bitmap_record()
already makes those checks in case there's no iova_bitmap to set bits to.

> Or, I overlooked anything?
> 
>> +
>> +    rcu_read_lock();
> 
> Do we really need a rcu lock here? This operation is protected by
> iopt->iova_rwsem. Is it reasonable to remove it? If not, how about put
> some comments around it?
> 
As I had mentioned in an earlier comment, this was not meant to be here.

>> +    do {
>> +        struct dma_pte *pte;
>> +        int lvl = 0;
>> +
>> +        pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &lvl,
>> +                     GFP_ATOMIC);
>> +        pgsize = level_size(lvl) << VTD_PAGE_SHIFT;
>> +        if (!pte || !dma_pte_present(pte)) {
>> +            iova += pgsize;
>> +            continue;
>> +        }
>> +
>> +        /* It is writable, set the bitmap */
>> +        if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
>> +                dma_sl_pte_dirty(pte)) ||
>> +            dma_sl_pte_test_and_clear_dirty(pte))
>> +            iommu_dirty_bitmap_record(dirty, iova, pgsize);
>> +        iova += pgsize;
>> +    } while (iova < end);
>> +    rcu_read_unlock();
>> +
>> +    return 0;
>> +}
> 
> Best regards,
> baolu

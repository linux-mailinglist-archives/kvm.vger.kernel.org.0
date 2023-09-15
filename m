Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FAE7A1634
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 08:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbjIOGep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 02:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbjIOGeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 02:34:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58102719;
        Thu, 14 Sep 2023 23:34:37 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38EKxkEG000825;
        Fri, 15 Sep 2023 06:34:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=BP+SaTfJQaDEDlh3phf8tOR9i/T/Cqx5WFZaa9WfhPM=;
 b=vts2gJN3L3ZuHJ7sBAdcahQgsqtUnEc33rViuqGliTubW5Sv4Xg9Vpn89AdtT2c3wwDE
 05wpUloKm3/M55BHNCzqI3x6tWUk9vvSp/C1Q72Y1UfjRoT013mMhxZModohU4F03QzZ
 bYeu3yJQ5jX6AfqL9YV1p0o0p2BkOyWpZdrdYbngwwZpPewflRqqSs+91wT+FYm4ll0D
 JnYk1LNew7Dn7w6PcreJSxsWQV+kAGtQbXQs5u+MT6F6RZPSNdX5AQIw2RR43MLop9HC
 aMHQEXjO4EQorwnkQMXQFZmmKq95CgXCufpRAY8gIjbrWgssEc1ljb5kxY5nPoc0O3Zl FQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t37jr6b0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Sep 2023 06:34:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38F6Q1wf036208;
        Fri, 15 Sep 2023 06:34:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f5fxx7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Sep 2023 06:34:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+wyAIlPX3e15gHelyledgwvXONUiWhN84NN3Ad51rl6j8N9r1pH6EHSgonDdFJrQ/aziaoMghsl9npyMQTWp8e3sZkAuDb72G3JqQh9TYweeARSP9zzpGbAldeHVpwvz9bIO9Y//sOGUd5tIztjvguRYfQSzKv8E6H63XqiBOGSSh8omHccoCuNp0Izz3x7WDwh3LNZ6uFsKd9v4zJglHQ2i8YLREtGS9b4Pf4EKbAwhG/oZQiF3dm/433WfQk6rT8qBbSF2lBr/eSOoK0xiP7rW2aYL4mzhjaoiEFKNbWWy295B+rocum36NSw6ovAZ1RC1LmSxNGIuM6TfSXAyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BP+SaTfJQaDEDlh3phf8tOR9i/T/Cqx5WFZaa9WfhPM=;
 b=NYvQJnvpc10Y3jRbVyzOgHbS9HC8RQlarMxbnwV+9uGwefYQuzy7KcufxZNX4lRnNa40myj7EKgGK9z0KOYP9RzD33hlDXmRMAiv9aTw73JHONhOWqL306kzp1IJgN3AGyn3KQhwEPQlHpE/hjEjex4IPo9zAeTwcWcXK/PvZBJhROAwvQl6Yhys0aBVXruEmAlMHOmc4UkBcEQ0LPjoNVcUP5eVPeqLHTAhbQFrPHFt8blpf21inG8aDDXV54Q/84BeauElu7zb1SbwimwmUHUF4Aih1FS1XEhfnolPU7HuZw9sA5fcmrPOF/0Rs5gmOK6C0nu2AN3uaffAdkYIAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BP+SaTfJQaDEDlh3phf8tOR9i/T/Cqx5WFZaa9WfhPM=;
 b=kpG1Nc32Q90TDWyAXItWEY/JMrpuLX7QTnvhxF5ZafRAt2X4ST2kT5ER4m3f79m+ZKu9pr55akcLEce9njVXiZXnF3tXjOV2GvAX/ABYzEv8QzppJqeHx12RXPsK4geAPPWCxvHweKN51Tgh5gs2rj2a6kZLZkpPLLl6F3401PA=
Received: from MW4PR10MB6535.namprd10.prod.outlook.com (2603:10b6:303:225::12)
 by DS7PR10MB7321.namprd10.prod.outlook.com (2603:10b6:8:e5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Fri, 15 Sep
 2023 06:34:23 +0000
Received: from MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::9971:d29e:d131:cdc8]) by MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::9971:d29e:d131:cdc8%3]) with mapi id 15.20.6792.021; Fri, 15 Sep 2023
 06:34:23 +0000
Message-ID: <b223d828-2c08-841f-47fb-7cb072fa5ec9@oracle.com>
Date:   Thu, 14 Sep 2023 23:34:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 00/16] vdpa: Add support for vq descriptor mappings
Content-Language: en-US
To:     Eugenio Perez Martin <eperezma@redhat.com>,
        Lei Yang <leiyang@redhat.com>
Cc:     Dragos Tatulea <dtatulea@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, kvm@vger.kernel.org
References: <20230912130132.561193-1-dtatulea@nvidia.com>
 <CAPpAL=w6KeBG5Ur037GNQa=n_fdoUwrFo+ATsFtX9HbWPHZvsg@mail.gmail.com>
 <CAJaqyWeVjKTPmGWwZ26TgebuzCaN8Z2FmPontHvZauOTQj0brQ@mail.gmail.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CAJaqyWeVjKTPmGWwZ26TgebuzCaN8Z2FmPontHvZauOTQj0brQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0018.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::31) To MW4PR10MB6535.namprd10.prod.outlook.com
 (2603:10b6:303:225::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR10MB6535:EE_|DS7PR10MB7321:EE_
X-MS-Office365-Filtering-Correlation-Id: cc378059-9ad3-4037-a9e9-08dbb5b5cc7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Spb1a2alsD1/ylnqMV6KaQOffe1eKgsEy1wKfKr0sBxxKZCP5fP1Y741KuqtQlpMaUVlfwuT5t5RR4eU88ILKyG1IQCN/LmFWqFtmdQ/qAAD/luheC/jfE35SSz+FC/LaxiN4jsCjhVOdYBYipG6VA/xTVBPJzG5VhDu9p528l9Vz0ESUgw8aEoTbfpj1hrtuwcCV/HlBkOSzVHxUo186VC37mLy4nWFbfln7xB8lCjAak+/7R/RnspST3DYi/LsFpcgv+2T4HVNKNiQs/FEbKz1SB3BWkTUVTanDON6sNQqTpDH2D4p29OVLGaVcktoUK8Ki2O3GsKxyKYywhAkA3XloNukP71/OL0S3prd8dv2vxxG+c3muOOG/Hn5k5LJ78IHJ0Nj0RkwoH/7TBXHPIlbkEdrwYtl77CjWf6NvaMJ01rgT0My7nJMgNpOEnBbcUJD5tydypjIOwfXGiN7N7sKnFyc8tWdBRYJ7JULUSB9BKCaPj2uPvluFo042XanaWyTlnffBQczOBE6f2fzaUJKyU9dnBHSVvRSEa2wlfeUblZoNZOT1NclCAa/ENT2h1sHuOtmFSdZFhlSpZ6jqfJTbGwKa6C958G92Ipg1rF2rGBpG1iqJrc1p4y1q6yHwI8b4iOpnS7K5zfX1r09Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR10MB6535.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(396003)(136003)(39860400002)(346002)(186009)(1800799009)(451199024)(966005)(6512007)(6506007)(6486002)(53546011)(66899024)(36916002)(83380400001)(38100700002)(31696002)(86362001)(36756003)(26005)(2616005)(4326008)(2906002)(7416002)(8676002)(41300700001)(5660300002)(66946007)(110136005)(316002)(54906003)(66556008)(66476007)(31686004)(478600001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlhLRW1xVUswRUhRSnVPcWhmdDBteEZDZGtFY253amtiMHJoNjd1QmRMbm5x?=
 =?utf-8?B?TmwwMFFiUTJMMzBnMkl5S2JQanA2OHNGclRqUW5DYkpybm1TeUR1M1I0ZUdp?=
 =?utf-8?B?VkNEM2VOejdUbmI3MUEyZk9WeW9wTEVxalJMZU5WNm56ZHdkWGVOWUlqcWMz?=
 =?utf-8?B?WXZ2VkNwZEwyMVJVN0pKWjVueFJETVNQUkM3TFpib1dmSkxJcGk0NWlEeGFs?=
 =?utf-8?B?b1FxTFpRV0Q4Z1hZZnRRRGgxc0VXa084YWFzOUVacjhQOERyU3F0Vlp2aVR0?=
 =?utf-8?B?Um1jc3R1bll5NDQyODJUcjhhVXVITkNSeWNLQWpaQlBUVlUzQituZW8wZFpw?=
 =?utf-8?B?SVNxVnVSR1BEZE81VzBnVWVBNjVBbnduZ0ZySHcxR1JFUzA1eE1WWDhyQy85?=
 =?utf-8?B?bGRKd3dheWZ3L0lsaEFBQmpIb09Ic1JPUkRjM1Y2WURFdmQ4SlVkTGh2b2xx?=
 =?utf-8?B?WHNiNENBZTNiOTROK3FUOTgyWnJEVVgvZ1FKNW9FclE3UkxsUkZOYThVWlB5?=
 =?utf-8?B?UHBJYkFIQ0FmUE5xeFcvSk5hWnYvKytUdFF3RlZSdVBsZHUvUTJIcGgvekNy?=
 =?utf-8?B?ZEI5MVZUWGQ0cTBqd2FFbk9vT2llbUtOejJEb0Fja2V5NmNHbU9md3ViSXE4?=
 =?utf-8?B?Vnd4anptWUVYV0RkWm1TYVlLR3ZjS0xENW5ZMU13NGtpL0NQYjRFYkhzZHUy?=
 =?utf-8?B?Z0xaNWV1SENyMUhZTmR5cmJIWXRlK3M3WEM4VXUxSnV1SnlvMS9sUDZseXRj?=
 =?utf-8?B?dDlsbmtVQlFtWW5mb1AxSlFKQnJHT0VpbXZJdStIaFljS3ZIMkZ1R1A4VVJk?=
 =?utf-8?B?eWRneGp0UlRZM0d4SU5ZWjExRXR4SUpXOVhCZ1ByWnlkVFU5MDFob2J6c0hh?=
 =?utf-8?B?azB0bDg2OTNVZ1NNWm5mV0M2b2diTit5SXJTMUJiWk0yRFRlSXZ5KytxdDlj?=
 =?utf-8?B?ZUZxZDhVaGtHdEkzSFlpRXNtV0k5d0F5U2laL2dHcVhkZ0laMUtOL2ZEdEdp?=
 =?utf-8?B?MndFakpCMzFiMkg1dTBGNEhKbXEwS3E1SU1vYlNqaVRGMHAwS01uMW1IT0RL?=
 =?utf-8?B?ekJjenBCVldoTXpIZzNkSFp0RkdUOTdoV1luNEtvTkZwVVpZWk5ueHRLMHpS?=
 =?utf-8?B?NzRrTWxXOGlpYlBrUmRqdzZPM010NXk0bUFoYzdEUG5aM3BwYjltREovZ0Fv?=
 =?utf-8?B?am9VNnFDSnZSc0x0WXBiNEN3WVpJdDJac2tPYklSaXl3ZVF1T211VnB3WUhM?=
 =?utf-8?B?cnpHaWtROCsxbXlpc0Z3eUNxejZ3TmpQb1QvWjdFdkNVMGozWVZ1M3JNSVpP?=
 =?utf-8?B?bXB0akJ2TW5iSTJuTFNoUkh2VEppQXh4S2FDb1QyUm1NOHI2V1ROeDBRTXJS?=
 =?utf-8?B?SCtKWmtaY1NWLy9xdlV1dm13UjYxQkVNY1BiTlV2c2JPK08vOWxyRExHRGho?=
 =?utf-8?B?UDR0b2xrWUhyQVo5UWRYckh0VVpLRHFTdVRnVTErOEUzUnRmVkpMUmszSDMx?=
 =?utf-8?B?ZE9MUXArQU1QU0xITGsxZ1E2QlJnaFR1ZXkwNmVQY1pscXVydWM2S2JFV09o?=
 =?utf-8?B?VCtpaTlnV09BTVloQnY5aVJRWEVoOE11dEozczFQS0pmTEZhZXpRc2c5NE1C?=
 =?utf-8?B?dnZab2htWFhPZGQzSitiZHRMRFVMcjNTcDRSZ25mT2xkNHJjQm9raC9heXVj?=
 =?utf-8?B?Zjg2elVBY29HMm04UGtncmZKdGRuaU1oNndpYnNQQ0N5RCtGeHJ2NjN5SzEz?=
 =?utf-8?B?Tml6Rm40T29sVjlUNXlUeExjTHF6UkplUVQ2UjdsZHZqVzl5d08wM2ptbWZB?=
 =?utf-8?B?bER0bSt6TCt3RjZoMTl5MG9sdnZpR1hDblFQUGdoN3hPNjV5MFg1TmlNNXRP?=
 =?utf-8?B?Skw0N2c1cjlxSjRaTkNmdmZsMG1EaStFTXJRTHFBRWFoNTh5TGhNenVJNDg5?=
 =?utf-8?B?d0p2VGg4VnVwVGlGc2NwUVM2TFVkUCt6TWZNSmNjUkI2RG1QZUNFYithdXlY?=
 =?utf-8?B?Y3VOK1FHazdrMjAzYU96M2d6SlV3Y3c4eWVUQlFpclUzOGJnb0VUSCs0Sy9h?=
 =?utf-8?B?NCt6bnFaMmpZUGtmQkdMTEFJVmE5TnFoYkR2dk1EczBmMS9RUGgvNlAyc25F?=
 =?utf-8?Q?6Zkfw1yfV/LpG8+9/G+PcfKcQ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cGxjZXo3M1BSNmlqeDhOY204THNWSmI1Sy9hQ2NkaVUybEIwOFVJOUh2WCtB?=
 =?utf-8?B?Um9zMmRmbW9LcGIyRHk0REpRQXY4SnVtc0s1dS9iV2Q2YjNaalpQT2Z2d1pH?=
 =?utf-8?B?eTQreTBySyt5NmZzMi8zdXRlaW5QYk13NHBMU3dyNnlyMjdPYUljbi96NmY4?=
 =?utf-8?B?SHhKdUp3cWMyUFJHMVNjV0tLbC9OOHZFczZJWnQ3TXd1TnR3b2FMZXVic2Rq?=
 =?utf-8?B?dEZ4aGFMWDl3YlJDSWRNSThrdU9XWWIrSUdldWYxeUI2N2hGNVU0ODNXRHpm?=
 =?utf-8?B?WUZMcUhpbGJiUjRaRmIzOExrRndQUzBjajV3elV4WFBNb0Zmc0FYZTMweHR5?=
 =?utf-8?B?Tlhld1FLYkg1TUs2cnB2VWhnajBoQThCV1Fkck1tQXVLUzVEV3dZVkUwd0lH?=
 =?utf-8?B?ZVlZRHlhbGpTc0FjZ0lDdDIrRDdvd25TVERKa1pZbVViNUVlbTV6UXozM05m?=
 =?utf-8?B?V0lHQkRrYVdmM2hVWUhEdGIxbVdleGJlOFphVlFpbkdWMGR3M3o2a1NLQjc3?=
 =?utf-8?B?emtiZXMzS1ZMbm41a1l0ZW5PYnNZMUZGUGpybnd2d2QvZkNjVXpCSVRKN3VH?=
 =?utf-8?B?V3JmVFhPUnR5ZWJNZUhVS25jSnh5WnJvNVRsZkM1aCtqS251MUtGUUZuYjNE?=
 =?utf-8?B?cGZGQWNGZ2dsSkVOc2FUZWlIMVA1ZWowVGd4ZXBQOExUV0llMTJYem9wU2xX?=
 =?utf-8?B?NmtBQVdpRHppS2pkNnlIcEtScHk3WG9rYUE1aEtxamNHbzBHWjdUdGhOV256?=
 =?utf-8?B?NFdyNlBBNDhHdlNTT1FhaDYrakVweWJ4U2FZcXpRVmtEaXZQeW9QY1lxMnZB?=
 =?utf-8?B?UCt4cGFrUVFEdDZrdFBtQzZUMTBJbGFZUFBZUmczeno2ZnBTcEdhNGUyakhh?=
 =?utf-8?B?YU93UDl0ZUx0ZHEwNjNPU2pISmRxOGFWVEtVeGQ4ZlVHZTh5VmMxTk5mT2hE?=
 =?utf-8?B?eFlWeHkyN05EMXdHd28wRmluNi82TENicENPUVBoSzBFVDBySDdpQnFyZ0FD?=
 =?utf-8?B?SnhoLzQzSTE0aVhpVTkwT2VLRGwyVTRGQ0YrRFRJQWROQm5zcmZIZGJ0VFV1?=
 =?utf-8?B?b3M4WjBDT3dRb3NtVnZkc3BxazFwaERoTldEcmZLU1plMmxTbmI1TGQ4REky?=
 =?utf-8?B?V2RlTi94SCtleXNlU2d4aGtoQWpXS0Vudm1rSVdBSGgwTFlETllFcjJscmls?=
 =?utf-8?B?Ti9aWitEZDZRNjE2Z2VSNWtTK1plUjc5M0d0a1kwdUpwWCtOTVpOZ2xKN0NU?=
 =?utf-8?Q?NS7BqFi5dfTi0GZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc378059-9ad3-4037-a9e9-08dbb5b5cc7f
X-MS-Exchange-CrossTenant-AuthSource: MW4PR10MB6535.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 06:34:23.1574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7jIfhXl0qthACs2/jSd2R6g2xG/apatVIJXGMIXdO5F8UVtMpvO6fTmLdKo36eEeORiRaKm7Wayh/ZDJn4SNOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7321
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-15_05,2023-09-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309150057
X-Proofpoint-ORIG-GUID: ZKy0hcK-5oPC8WflXS1mfZe4dssctfO-
X-Proofpoint-GUID: ZKy0hcK-5oPC8WflXS1mfZe4dssctfO-
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/13/2023 9:08 AM, Eugenio Perez Martin wrote:
> On Wed, Sep 13, 2023 at 3:03 AM Lei Yang <leiyang@redhat.com> wrote:
>> Hi Dragos, Eugenio and Si-Wei
>>
>> My name is Lei Yang, a software Quality Engineer from Red Hat.  And
>> always paying attention to improving the live migration downtime
>> issues because there are others QE asked about this problem when I
>> share live migration status  recently. Therefore I would like to test
>> it in my environment. Before the testing I want to know if there is an
>> expectation of downtime range based on this series of patches? In
>> addition, QE also can help do a regression test based on this series
>> of patches if there is a requirement.
>>
> Hi Lei,
>
> Thanks for offering the testing bandwidth!
>
> I think we can only do regression tests here, as the userland part is
> still not sent to qemu.
Right. Regression for now, even QEMU has it, to exercise the relevant 
feature it would need a supporting firmware that is not yet available 
for now. Just stay tuned.

thanks for your patience,
-Siwei
>
>> Regards and thanks
>> Lei
>>
>>
>> On Tue, Sep 12, 2023 at 9:04 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>> This patch series adds support for vq descriptor table mappings which
>>> are used to improve vdpa live migration downtime. The improvement comes
>>> from using smaller mappings which take less time to create and destroy
>>> in hw.
>>>
>>> The first part adds the vdpa core changes from Si-Wei [0].
>>>
>>> The second part adds support in mlx5_vdpa:
>>> - Refactor the mr code to be able to cleanly add descriptor mappings.
>>> - Add hardware descriptor mr support.
>>> - Properly update iotlb for cvq during ASID switch.
>>>
>>> [0] https://lore.kernel.org/virtualization/1694248959-13369-1-git-send-email-si-wei.liu@oracle.com
>>>
>>> Dragos Tatulea (13):
>>>    vdpa/mlx5: Create helper function for dma mappings
>>>    vdpa/mlx5: Decouple cvq iotlb handling from hw mapping code
>>>    vdpa/mlx5: Take cvq iotlb lock during refresh
>>>    vdpa/mlx5: Collapse "dvq" mr add/delete functions
>>>    vdpa/mlx5: Rename mr destroy functions
>>>    vdpa/mlx5: Allow creation/deletion of any given mr struct
>>>    vdpa/mlx5: Move mr mutex out of mr struct
>>>    vdpa/mlx5: Improve mr update flow
>>>    vdpa/mlx5: Introduce mr for vq descriptor
>>>    vdpa/mlx5: Enable hw support for vq descriptor mapping
>>>    vdpa/mlx5: Make iotlb helper functions more generic
>>>    vdpa/mlx5: Update cvq iotlb mapping on ASID change
>>>    Cover letter: vdpa/mlx5: Add support for vq descriptor mappings
>>>
>>> Si-Wei Liu (3):
>>>    vdpa: introduce dedicated descriptor group for virtqueue
>>>    vhost-vdpa: introduce descriptor group backend feature
>>>    vhost-vdpa: uAPI to get dedicated descriptor group id
>>>
>>>   drivers/vdpa/mlx5/core/mlx5_vdpa.h |  31 +++--
>>>   drivers/vdpa/mlx5/core/mr.c        | 191 ++++++++++++++++-------------
>>>   drivers/vdpa/mlx5/core/resources.c |   6 +-
>>>   drivers/vdpa/mlx5/net/mlx5_vnet.c  | 100 ++++++++++-----
>>>   drivers/vhost/vdpa.c               |  27 ++++
>>>   include/linux/mlx5/mlx5_ifc.h      |   8 +-
>>>   include/linux/mlx5/mlx5_ifc_vdpa.h |   7 +-
>>>   include/linux/vdpa.h               |  11 ++
>>>   include/uapi/linux/vhost.h         |   8 ++
>>>   include/uapi/linux/vhost_types.h   |   5 +
>>>   10 files changed, 264 insertions(+), 130 deletions(-)
>>>
>>> --
>>> 2.41.0
>>>


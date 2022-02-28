Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060154C6D5B
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 14:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiB1NCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 08:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbiB1NCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 08:02:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074E35938D;
        Mon, 28 Feb 2022 05:02:13 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SCoOO7008190;
        Mon, 28 Feb 2022 13:01:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=MY6SWaeDkedEqRTT5yGAgvqCORRFSVgubLU67IZK9YM=;
 b=Jt2JAzCmJwOuk+9TKNSfpgaDRP/QDCqHiIlnmgT7s9sqZOKi7H4FpiQ8LHz4jCHi7b8/
 y7AX/jEfx3LE7agO+aTyfng5sTaEim0ZJVP7qT9UpKtURb2DwHl+Oq9ZlkXUCc+fAYdX
 jfX43r4vGV+8++WNC95EynDFEbBBMDFGjN8fTJOK91aUVaWr7hkySY4TBK84y+TZCI+X
 gUZgRMcACtKoCQtiCrQLDrU8cKHGwMdBZQ9OAJ9W5vqSyJw1e/XuPFvRIfEcvygbUKvV
 huqF/MnihGbe/+OZVNHi9hYNjWhagCvkYJY042erO6HzLvAUB7tjPKBiGYj+haMTSkhq 5w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efb02m6k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 13:01:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SCtGOU031553;
        Mon, 28 Feb 2022 13:01:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by userp3020.oracle.com with ESMTP id 3efdnjwmeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 13:01:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbLRU8iRv/lfjr9CfqrRz33TURJihmJUgPLHgAZb6/8fES0g7ecIh7q9BP/FDApmM2Bbxfsu2lDczua+B6lsj/3PycDI9gDsQHUqNzeTb0+qDKW4jP/a3954nt3w1MHCqHB4uxDDdBHXE4d4SgldGEGy+8H8UEZAbcMp3L4zoRWIxvltWrZalMfl8gifoX7g1bT4W9PLqpBOvkecfNnhPGrsvdzuejtDRjef/gAEgcRdTT9jEv/HN/DJy+RRWCuohlI8XMz1yfmdlyiNpMhNZKCCMsiH/qQPsx+9RWAZjAOAAlID+iVQjXS7RBnYOWsthxSkm/4aMZVRGEe/U1JxaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MY6SWaeDkedEqRTT5yGAgvqCORRFSVgubLU67IZK9YM=;
 b=fW/6OUWHKDRp/GN8xBg5hTvDMag7rJaF2i5S8nT4rSkpLW59POJb1yn9vW9TymXS+T+sHcDOHPzOwZV0xVxhgGGNNoGrbBHQJ3AZeZuWgbPRkML517BikEBmvGwRcU1oYgyxB5xYbjkyH5Mgh2ksFOS1xC1cKjqz7WwkcwoTNslJRQD1qnpYzLWDTEoxZSdjfy8/v3NvEcx7tejECcdnSGqhccidswD3o2AQEzkGOXRJkPtk58rVVUcD9Wgx7Q8cVeflxZUASEtnsm2j9BaEM0AbwMhohOKS2gnAlI59MbBJbw/nMYvWOge6zHVIAX70svFF/X7uYpVuXhoj63U1nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MY6SWaeDkedEqRTT5yGAgvqCORRFSVgubLU67IZK9YM=;
 b=t6CPhQ/niCFFgZUVw0Ly2UFdLkeo6MogB+F2rB1DcXfiwsLsapnVeNxhO+iejRU+SbAIr1I/QlQ13ijmx4Dd7EF3jrnalZ41jBuLbskm+T4toQjuyjDFYdKJSyvjvRSS7EExAO+SN1EnQ0/3Hbi/BuFZyMKFowWvyklXpPi0KK0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN0PR10MB5048.namprd10.prod.outlook.com (2603:10b6:408:117::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Mon, 28 Feb
 2022 13:01:46 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 13:01:46 +0000
Message-ID: <30066724-b100-a14e-e3d8-092645298d8a@oracle.com>
Date:   Mon, 28 Feb 2022 13:01:39 +0000
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
References: <20220211174933.GQ4160@nvidia.com>
 <34ac016b-000f-d6d6-acf1-f39ca1ca9c54@oracle.com>
 <20220212000117.GS4160@nvidia.com>
 <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
 <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
 <20220223010303.GK10061@nvidia.com>
 <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
 <20220225204424.GA219866@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220225204424.GA219866@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0044.eurprd03.prod.outlook.com (2603:10a6:208::21)
 To BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46d1780d-d35d-426b-f487-08d9faba79e6
X-MS-TrafficTypeDiagnostic: BN0PR10MB5048:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB50486916C6769EE4604565C2BB019@BN0PR10MB5048.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 33tVH6Va9iRZ/YFV4oBEVglruHeZqKSGporWWlCT/OydeHfEz1DZfVU0MVgGjlSQlAP8FLsMyeXJEG2Spv8CdHs5oVwsPQ6zRWuRzbHgf/DoWQlXARvqdag//LsgnP23ZuArdRiyOvg7MyvB/CPauoIwRJvpF5InkUIPjbC5jeRWIjB4hyN5bxWKcdDGiw/kxA9Tyi3w28sbYhfJcNivURigjlkTio0xJwAF7cxgzFLtF9LCTmWh5hLGm4fIeTS87SoqFr20aSe+DDJd7qGlYjM+F9VtWOqblcOdBrf1T8DI/Y4bbVxg5gZfotwIL3AdzWB5AS2dJV5kTTubZvSycytV57P2u8vtsrwhJ4Q26g5nPQbbXd2dFpK4F6wDEW5qpLbGPOdGQ3+s0t9kTgIZTYE3uUZqL4Y061/8qPM1sgpFifP1kvFpxRqPtmJ3A0yx6j1kYKECFm6YInj3DV1/st9vkhC5NHnI8FgSaZ0xMvhQaJ/ZrvCuyzLquuZl4UZwA69+/Ww8PEiGMvDdczQmCcOlEAPyBQQaXJUEZ+yg7Ji4s9FRz6C5cIpXYOLl8G3pv8pFRwepT8W8e5ch+w7cr2QcE/Wu1mLO4ZBcw1s0RqAvKqgqNcDxta8ZLjqV7nfhIH6UVbC5DUGIR0x3pYEG/4cpYVWOotlvsjO2vChEY68ZTmYuTXtuac41OWtvwsWJ0R0u9keB4dvCSCYO5X9NHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(86362001)(186003)(8676002)(26005)(6916009)(2616005)(66476007)(31686004)(66946007)(316002)(66556008)(2906002)(4326008)(6486002)(508600001)(6512007)(6666004)(53546011)(8936002)(30864003)(38100700002)(83380400001)(7416002)(5660300002)(31696002)(6506007)(36756003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2EzZTdCdnBDMFJjQVdVNDZnNldBVVUweU83cVZvRjdKdGZPY2E1N0VlTDVK?=
 =?utf-8?B?aEZ0d29ZTG9tVHE2T25uejI2Mkd0bTBvSFRtTURxdmdxZzJHaVhQSnZUNit1?=
 =?utf-8?B?WTVQa2RPbmw2cGJ3d1JsTEJ2R1VoYmZnZTIyUERIY3JNUUt6RVdHMWFIaFp0?=
 =?utf-8?B?NjBWSEIrL3p4QXpLMDNDSis5TWNJTGliUmNxbEJBL0ZxODd3LzVqU1ZvNHRu?=
 =?utf-8?B?YmlsZDk5WWFpa0MzR1ZaaW1IUzlXN3htaGNHa3ExZk1xVGRtMERiLzJCWmM1?=
 =?utf-8?B?aUt6ZkRGc1NQOHN1ZHk0azRHcTE2bXZQL1RobUVDeTBzNlQ4K0xBNVNZcENF?=
 =?utf-8?B?Z0VGWDMvQm5VTVpDakZxQURkSlJPVVJvcUpMT2JQMWFLd2ZCdXJ6MWFERTJO?=
 =?utf-8?B?dU5Qc2ZzMXR1R2IrR2tBWmxCRktRV2djTEdXaFZsOVh3K3gyMXpuYzBXeE9Y?=
 =?utf-8?B?cGZPMHVHK3k3TXRxdVgwZ2h0RU1KLy9nRm1SYWhLS2I1R3VtVkkxZTVIMnRq?=
 =?utf-8?B?NXIzelAvVUlHalVxN09sbk9tYXI1SllJb1pnSkp5TXJUTVVlSGJKWW9hVU4r?=
 =?utf-8?B?Z2pYK29SOVhLendUNUtvRmpQNElUZytBanRrS05sY2J4dEVzSTU1emdrcTdr?=
 =?utf-8?B?NW9xYnZ6VjI0Q29yOFk3SmE2WHlIRUw0S0xmZ09vd2pGMGd6WGJHMVY2dGRY?=
 =?utf-8?B?SnZhdzRiWE55UmY1QVhXcGlDMWZEbEtoMG9TTzNMOG5La3NNUnJiZk1ISVhW?=
 =?utf-8?B?M1prQXo1OXpodEZjMXJzYXFPSXZqVVNkRGEySkN2dXVBWXpjQk5hc21XM05m?=
 =?utf-8?B?NFI3Y2ZIaEVPQ1hYdCtkWHFaV0ZydThrclkwYkxkSmJaZXFlZHkvVnZhQ0xt?=
 =?utf-8?B?TDlrSVE5TWZYNzRjVUdPTXZQWHkyTHhBeVJWbWRCano1ZFpXdVJnWnRVNVRR?=
 =?utf-8?B?a3ExL3QrNXNoQitSOTE4NE53RWdvcXlVVEo3czh4OEc5TUdRdDdjZS85Wi9V?=
 =?utf-8?B?ZE1ndExQUHlCMnp3WDcvWTk4ZEVvS1lpckJsVGxVbk1TYUwwWEJsNGE4ZXNW?=
 =?utf-8?B?U1djM3dBK3FKemlHYVZCQVRJNnhEeHREK0NRYU44eDNRck5CTHEvTVZ0aWRO?=
 =?utf-8?B?c2RKaVV5aTB0eGJaUTVNSCt6eVE4SUtLQStSNWxlVENKME03R1o0TW1BUCtw?=
 =?utf-8?B?Slp6TjhQYWxrOFhjNXRXVmJUU2UrdHRyNzg2N0Z0UEFoTVFwQi9uOU5OUURz?=
 =?utf-8?B?b0EwRXhkUk5GbEwzMWQ1dFZTb0tjbVE0dTdJdnI5OGNrWUJzT3gzUUNOZHdI?=
 =?utf-8?B?SGV6cjZqNk1PZHR6YWVqdTJ4OVk5cjhWRzZvMmtNdCtvOU83bHVoNlU5YjdK?=
 =?utf-8?B?VFNUNTlJNFkyc0pwRkY4cktQdSs0Rm9uWGlucjhpWDNLUU1GL1JCRm1TUFoz?=
 =?utf-8?B?UVNMMmFCRk9vejRqTTVIMzkwcWFta0JWakpqeHF2aDZHWmttK1B3M1lJc3Fp?=
 =?utf-8?B?U3JZai9RemdwTXdKSTh2b1poOUh5TzN4M1RpL3JmR3pVTko0akJHRHFVN3hw?=
 =?utf-8?B?WnJpbXc2VDlRNHU4aEN4VENQWWlJejF0UnNXTXFsSjg4a1BpRjZHK2dJK0l5?=
 =?utf-8?B?bFF0YllhQ21tbU0xVHQzYTdCa3luT2c5MzhVdWh1Rkl3aGoydHRxRC91L2Zt?=
 =?utf-8?B?bitQclBnSVJuZElmU2JBQ2d4WlhDOWg4NVFmVjlaSjB3eFBsUDZsZE1ta1pP?=
 =?utf-8?B?ZmVUUnRQTmhpdzRvRHFaNjVlbFF5K2JDSXRtRXJaS2l3RlJWVU1aeGJlb3dq?=
 =?utf-8?B?SGdDQ1puUEw0ZEl5eitHMEpQdFAyZ0pQYXFYZ0FWcjJwQjJTVDBKSHlKSVNO?=
 =?utf-8?B?SGE2dDR2THhjMDlDU3JLQlEwdTBoakJFeURpWEEzVHowOUNwNGpMMUsvZEVh?=
 =?utf-8?B?eE4zdDVPczNxS1lqR0JoQ0h5V2FQdnVFK0x3ZnUzUDRlaVFzZjR2UndtN00w?=
 =?utf-8?B?a3dBa1ZvcFI4WFNKVU5LMlVmUEJZSHliR0lrYU5WNkRNeUFzdVJ4cWlCWkZG?=
 =?utf-8?B?L2dZUjVFOHl0RXIyQ2o0QzFJaU5TZExleU9QTjNBVVVpYnMyOTNnM1ZEc2Rh?=
 =?utf-8?B?Mjd2aXkwaTZmL2lxRjdUR2VtUzFHSXkvSmtTZ2xpT3FYMDVNV1hCN3hwczVw?=
 =?utf-8?B?Wm0zQ3JFZDh2aUJUWFA5eVV5d3pKNENVcGRtQmVKRndobmF1a282ampTVHBB?=
 =?utf-8?B?RW1xeFhON3daMTAraDVxa0pVOTdBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d1780d-d35d-426b-f487-08d9faba79e6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 13:01:46.6613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBSYjUD0laRgg5n1fpXylmLPK42Amju/4pjVYtJ5m38Djra6Rsuq5VtDN5WhWp3/UX6dCamk0OwF3X+Ax+pDpBPWoiK2ijQ1AX551GU8FXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5048
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10271 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202280070
X-Proofpoint-GUID: 3tfLL3WXrxeMeplfYNluSDhef_RxI78l
X-Proofpoint-ORIG-GUID: 3tfLL3WXrxeMeplfYNluSDhef_RxI78l
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/22 20:44, Jason Gunthorpe wrote:
> On Fri, Feb 25, 2022 at 07:18:37PM +0000, Joao Martins wrote:
>> On 2/23/22 01:03, Jason Gunthorpe wrote:
>>> On Tue, Feb 22, 2022 at 11:55:55AM +0000, Joao Martins wrote:
>>>>>> If by conclusion you mean the whole thing to be merged, how can the work be
>>>>>> broken up to pieces if we busy-waiting on the new subsystem? Or maybe you meant
>>>>>> in terms of direction...
>>>>>
>>>>> I think go ahead and build it on top of iommufd, start working out the
>>>>> API details, etc. I think once the direction is concluded the new APIs
>>>>> will go forward.
>>>>>
>>>> /me nods, will do. Looking at your repository it is looking good.
>>>
>>> I would like to come with some plan for dirty tracking on iommufd and
>>> combine that with a plan for dirty tracking inside the new migration
>>> drivers.
>>>
>> I had a few things going on my end over the past weeks, albeit it is
>> getting a bit better now and I will be coming back to this topic. I hope/want
>> to give you a more concrete update/feedback over the coming week or two wrt
>> to dirty-tracking+iommufd+amd.
>>
>> So far, I am not particularly concerned that this will affect overall iommufd
>> design. The main thing is really lookups to get vendor iopte, upon on what might
>> be a iommu_sync_dirty_bitmap(domain, iova, size) API. For toggling
>> the tracking,
> 
> I'm not very keen on these multiplexer interfaces. I think you should
> just add a new ops to the new iommu_domain_ops 'set_dirty_tracking'
> 'read_dirty_bits'
> 
> NULL op means not supported.
> 
> IMHO we don't need a kapi wrapper if only iommufd is going to call the
> op.
> 

OK, good point.

Even without a kapi wrapper I am still wondering whether the iommu op needs to
be something like a generic iommu feature toggling (e.g. .set_feature()), rather
than one that sits "hardcoded" as set_dirty(). Unless dirty right now is about
the only feature we will change out-of-band in the protection-domain.
I guess I can stay with set_ad_tracking/set_dirty_tracking and if should
need arise we will expand with a generic .set_feature(dom, IOMMU_DIRTY | IOMMU_ACCESS).

Regarding the dirty 'data' that's one that I am wondering about. I called it 'sync'
because the sync() doesn't only read, but also "writes" to root pagetable to update
the dirty bit (and then IOTLB flush). And that's about what VFIO current interface
does (i.e. there's only a GET_BITMAP in the ioctl) and no explicit interface to clear.

And TBH, the question on whether we need a clear op isn't immediately obvious: reading
the access/dirty bit is cheap for the IOMMU, the problem OTOH is the expensive
io page table walk thus expensive in sw. The clear-dirty part, though, is precise on what
it wants to clear (in principle cheaper on io-page-table walk as you just iterate over
sets of bits to clear) but then it incurs a DMA perf hit given that we need to flush the
IOTLBs. Given the IOTLB flush is batched (over a course of a dirty updates) perhaps this
isn't immediately clear that is a problem in terms of total overall ioctl cost. Hence my
thinking in merging both in one sync_dirty_bitmap() as opposed to more KVM-style of
get_dirty_bitmap() and clear_dirty_ditmap().

Hopefully a futuristic IOMMUs would just get a new DTE/CD/etc field for stashing a set of
PFNs (for a bitmap) that the IOMMU would use for setting the dirty bits there. That is,
rather than forcing sw to split/merge pagetables for better granularity and having to
flush IOTLBs for dirty to be written again :(

>> I'll be simplifying the interface in the other type1 series I had and making it
>> a simple iommu_set_feature(domain, flag, value) behind an ioctl for iommufd that can
>> enable/disable over a domain. Perhaps same trick could be expanded to other
>> features to have a bit more control on what userspace is allowed to use. I think
>> this just needs to set/clear a feature bit in the domain, for VFIO or userspace
>> to have full control during the different stages of migration of dirty tracking.
>> In all of the IOMMU implementations/manuals I read it means setting a protection
>> domain descriptor flag: AMD is a 2-bit field in the DTE, on Intel likewise but on
>> the PASID table only for scalable-mode PTEs, on SMMUv3.2 there's an equivalent
>> (albeit past work had also it always-on).
>>
>> Provided the iommufd does /separately/ more finer granularity on what we can
>> do with page tables. Thus the VMM can demote/promote the ioptes to a lower page size
>> at will as separate operations, before and after migration respectivally. That logic
>> would probably be better to be in separate iommufd ioctls(), as that it's going to be
>> expensive.
> 
> This all sounds right to me
> 
> Questions I have:
>  - Do we need ranges for some reason? You mentioned ARM SMMU wants
>    ranges? how/what/why?
> 
Ignore that. I got mislead by the implementation and when I read the SDM
I realized that the implementation was doing the same thing I was doing
i.e. enabling dirty-bit in the protection domain at start rather than
dynamic toggling. So ARM is similar to Intel/AMD in which you set CD.HD
bit in the context descriptor to enable dirty bits or the STE.S2HD in the
stream table entry for the stage2 equivalent. Nothing here is per-range
basis. And the ranges was only used by the implementation for the eager
splitting/merging of IO page table levels.

>  - What about the unmap and read dirty without races operation that
>    vfio has?
> 
I am afraid that might need a new unmap iommu op that reads the dirty bit
after clearing the page table entry. It's marshalling the bits from
iopte into a bitmap as opposed to some logic added on top. As far as I
looked for AMD this isn't difficult to add, (same for Intel) it can
*I think* reuse all of the unmap code.

>>>> I, too, have been wondering what that is going to look like -- and how do we
>>>> convey the setup of dirty tracking versus the steering of it.
>>>
>>> What I suggested was to just split them.
>>>
>>> Some ioctl toward IOMMUFD will turn on the system iommu tracker - this
>>> would be on a per-domain basis, not on the ioas.
>>>
>>> Some ioctl toward the vfio device will turn on the device's tracker.
>>>
>> In the activation/fetching-data of either trackers I see some things in common in
>> terms of UAPI with the difference that whether a device or a list of devices are passed on
>> as an argument of exiting dirty-track vfio ioctls(). (At least that's how I am reading
>> your suggestion)
> 
> I was thinking a VFIO_DEVICE ioctl located on the device FD
> implemented in the end VFIO driver (like mlx5_vfio). No lists..
> 
Interesting. I was assuming that we wanted to keep the same ioctl()
interface for dirty-tracking hence me mentioning the device/device-list on
top of the DIRTY ioctl. But well on a second thought it doesn't make sense
given that we query a container and we want to move away from vfio for iopgtbl
related-work and rather into iommufd direct access instead by the VMM. So
placing more dependency on that ioctl wouldn't align with that. I suppose, it
makes sense that this is on a per-vfio-device basis, hence device-vfio ioctl().

> As you say the driver should just take in the request to set dirty
> tracking and take core of it somehow. There is no value the core VFIO
> code can add here.
> 
>> Albeit perhaps the main difference is going to be that one needs to
>> setup with hardware interface with the device tracker and how we
>> carry the regions of memory that want to be tracked i.e. GPA/IOVA
>> ranges that the device should track. The tracking-GPA space is not
>> linear GPA space sadly. But at the same point perhaps the internal
>> VFIO API between core-VFIO and vendor-VFIO is just reading the @dma
>> ranges we mapped.
> 
> Yes, this is a point that needs some answering. One option is to pass
> in the tracking range list from userspace. Another is to query it in
> the driver from the currently mapped areas in IOAS.
> 
I sort of like the second given that we de-duplicate info that is already
tracked by IOAS -- it would be mostly internal and then it would be a
matter of when does this device tracker is set up, and whether we should
differentiate tracker "start"/"stop" vs "setup"/"teardown".

> I know devices have limitations here in terms of how many/how big the
> ranges can be, and devices probably can't track dynamic changes.
> 
/me nods

Should this be some sort of capability perhaps? Given that this may limit
how many concurrent VFs can be migrated and how much ranges it can store,
for example.

(interestingly and speaking of VF capabilities, it's yet another thing to
tackle in the migration stream between src and dst hosts)

>> In IOMMU this is sort of cheap and 'stateless', but on the setup of the
>> device tracker might mean giving all the IOVA ranges to the PF (once?).
>> Perhaps leaving to the vendor driver to pick when to register the IOVA space to
>> be tracked, or perhaps when you turn on the device's tracker. But on all cases,
>> the driver needs some form of awareness of and convey that to the PF for
>> tracking purposes.
> 
> Yes, this is right
>  
>> Yeap. The high cost is scanning vendor-iommu ioptes and marshaling to a bitmap,
>> following by a smaller cost copying back to userspace (which KVM does too, when it's using
>> a bitmap, same as VFIO today). Maybe could be optimized to either avoid the copy
>> (gup as you mentioned earlier in the thread), or just copying based on the input bitmap
>> (from PF) number of leading zeroes within some threshold.
> 
> What I would probably strive for is an API that deliberately OR's in
> the dirty bits. So GUP and kmap a 4k page then call the driver to 'or
> in your dirty data', then do the next page. etc. That is 134M of IOVA
> per chunk which seems OK.
> 
Yeap, sort of what I was aiming for.

>>> This makes qemu more complicated because it has to decide what
>>> trackers to turn on, but that is also the point because we do want
>>> userspace to be able to decide.
>>>
>> If the interface wants extending to pass a device or an array of devices (if I understood
>> you correctly), it would free/simplify VFIO from having to concatenate potentially
>> different devices bitmaps into one. Albeit would require optimizing the marshalling a bit
>> more to avoid performing too much copying.
> 
> Yes. Currently VFIO maintains its own bitmap so it also saves that
> memory by keeping the dirty bits stored in the IOPTEs until read out.
>  
/me nods with the iommu, yes.

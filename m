Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602C74B2FB9
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 22:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353920AbiBKVo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 16:44:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353886AbiBKVoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 16:44:22 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2CCC6D;
        Fri, 11 Feb 2022 13:44:20 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BL9dW0023170;
        Fri, 11 Feb 2022 21:44:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=tVPQwIdWdEii1DhR4ZH/hhuMhp+lrB+z0GlQO75S+gI=;
 b=HBRJzk6NfHKOOzNzK/SUMWKZ3so+XH3SSza7mmgJoxRoK4CzIfGfLTS9KiJG3Q27ky4k
 BX9wOZ5kVzGilNGSeZESG2HIzQJE5yeb50kIHjWoLS6OkOUBXtO1d5K0QEil7tOK8d4G
 /PrVE3hpaOsfRQyc+tXTjQvEeX4vinc58FB4WvdtRptsVw2dYPheIme6AvxoTl4Sy2Zu
 NnmUGTI3Vucc+pGPUHER+i49Oe9s+3HT+9/0IACPVJv8L8kgSKiOht/2I4Efly40fqy1
 rBin7ephdOtYphn0F+RFlvmZjPpjWBJps6gJm6WOyTMn5JHSEwMiX/ItKJcyyAImX+xY 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5pmv9ekj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 21:44:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BLVhIG108803;
        Fri, 11 Feb 2022 21:44:07 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by userp3020.oracle.com with ESMTP id 3e1jpyg7n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 21:44:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRA4b+sF/2fy3UBEwWtH75k2TEBL414lytS8qg/+c2GwbE8nMQzUitafWrXytT5OrGz/xMJdZ1btm9Dgm88g8t+Ipk2js742qvfoRNtH/HI052B4fbZHm8ieTIKXjlURm+2UF6CXQynI49AM5wnf0FykBkAwe1xe7e7tLnR1GNNvqSYm6E2lNENpEFbX4Fozd2T2q4ucId66VKAAS68L/lGsm5k+Hlyf1eIwjpijvy9slOcBepduvmobrMRHcATYmdIfGShw4V1BQhFj899wJ1KRRl5ZqJNkR63i4B++KEt91D46bW83AvKP0Iv/3qIoChevc3IPGsw62CPOEB/Ixw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVPQwIdWdEii1DhR4ZH/hhuMhp+lrB+z0GlQO75S+gI=;
 b=M0xstfcaZ47D5yXwMOvRwxlaBKbFF9DSnzNvY78pty1SFNvg+SNbwF2Bm0PvvqPz5+S4KN5MVPY6898w6rXYlKa/UmppPMOzUYQJjRSRG0M1m0rxY1WsunX/eEA2fgQBGiX+glSc4nOfeigjRjBaZIRcgg7VLiG/YurhIB1tuGHvKwFfE3Na8LWJojflPOQBDyzWo3bGlYjsKjibKLtVCjLd3dFW0hNWaNw8F+/R836ySMuhn2ar1i42xJ3hxziCEdtDgcMDVdi7591xcCcb/Uy/6qigrxc81kFrjXOlE6fCyBlEUnaRnGyh2cWycgsxYRTejrHzY/QJw1HdIsmmhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVPQwIdWdEii1DhR4ZH/hhuMhp+lrB+z0GlQO75S+gI=;
 b=RbgkjRbCy+cYukAs1yaR1PKW4yJvIAIjiUWlrrxEN1ltxymwXE8bx2AdPQu7VbDvhhnV0klb5legu5yeLeDWjp3OCLLbA5sEwUjR8f68MAiRCMpqg7RqVy9OmMp+bXuG63jpcAnxOc4Ly4NteAmWUaKGdVzKH4NqsiHcsRNHsek=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB2569.namprd10.prod.outlook.com (2603:10b6:5:ae::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Fri, 11 Feb
 2022 21:44:05 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.011; Fri, 11 Feb 2022
 21:44:04 +0000
Message-ID: <34ac016b-000f-d6d6-acf1-f39ca1ca9c54@oracle.com>
Date:   Fri, 11 Feb 2022 21:43:56 +0000
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
References: <20220202131448.GA2538420@nvidia.com>
 <a29ae3ea51344e18b9659424772a4b42@huawei.com>
 <20220202153945.GT1786498@nvidia.com>
 <c8a0731c589e49068a78afcc73d66bfa@huawei.com>
 <20220202170329.GV1786498@nvidia.com>
 <c6c3007e-3a2e-a376-67a0-b28801bf93aa@oracle.com>
 <20220203151856.GD1786498@nvidia.com>
 <e67654ce-5646-8fe7-1230-00bd7ee66ff3@oracle.com>
 <20220204230750.GR1786498@nvidia.com>
 <0cd1d33a-39b1-9104-a4f8-ff2338699a41@oracle.com>
 <20220211174933.GQ4160@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220211174933.GQ4160@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0018.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19e::23) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2da08f10-1753-4d9e-4e3f-08d9eda79fab
X-MS-TrafficTypeDiagnostic: DM6PR10MB2569:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB256999D956D607FF29F9A1EBBB309@DM6PR10MB2569.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j4SKUULs15KB8kfb2zJPe5T3fbt8pKiFMvhITlzRhvKaf0A1hiZBXDtvX5v/qMdJKTOV09Hguvt28gig6tCU0zZjcU7vNBD3Lp9jDvy5A59lGZ+3N5Yiz+sR0Rj0E6Jj69ofvMpdKha53pDlfefZwkvq6CVtL72X1u6gDR/sndz961rcQ0dFPrNm+mTIV5VmOTJgf7PBtroJM+Xt5TSW4VD3EFSfIelTAmulbzL1DnQyebs2mQMVczESqGyIE9VPntv5bGK7JGyOuwwM47Z29xPtBvDTHALe2YvBZV4/YcLmTLyfj/KWVNBO2PZzefaecoIM7lnRW0e+PtyV02fAmeRSAQoPwkk2ZvRxnZfLEMwA1rosYtGJc0JdHqD7KmTHuxQhBGpwsD9O10SuEjQuyuJzJuRFrw7hBWtESNbMbIPXSEoYNmSM0xpvPFxuFjPFuPfxBgTrnW5Df4MWUr+59L0v3K1avWhanekpl27k3lFfvPFrVuo5EYNLbQDAHkEtEodrXj9Z31mHfn/yNYsng1gC1Z3SLub6/BXHAMi2SM9FmyZ3SBWDzkRdMMRRSqTERZSoujnM7QCfpROgGnfYgyYf+8LfLEVx3lNOqcfNvxHjUtJo38ZP6cKQJdYBEj2PHzp3VVSXCE4EZKRBtgnh7Q5/QTTjpRP6KHpnU82LgLFjIt9RlzzFFsG47MbDXuIvVp1V7sOcQZuw1+ZZWotbw7IgKLXBK5TaUskS+HZPn3mg4Lbz20TnR+yrJ6I06OIhObKcN34Sdkkp9k3uLQxWjN3JZ+K+UwFjERQ52MMT7Sg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(966005)(31686004)(31696002)(508600001)(66556008)(66476007)(316002)(6486002)(6916009)(86362001)(53546011)(6512007)(83380400001)(186003)(4326008)(6666004)(54906003)(2906002)(5660300002)(8676002)(2616005)(38100700002)(6506007)(66946007)(8936002)(26005)(36756003)(7416002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?elZpRjZoTVJWMnM2c2tBMkk3VTA5aktrWXNYSmUzc3l3SXFndVpTNWltVmRv?=
 =?utf-8?B?aHBxWERrcUNzOGZsVHR1QUVmQllMQ3UrV2Mvdlh2NkpRM1pBWktUQkdSZ1R4?=
 =?utf-8?B?eGJ3SUs0aXlha0RyTitiRFBPWDhYMkx4Qm8zdnhMNmZGM1NHR2JGdCtxTWxW?=
 =?utf-8?B?OGlVRzMxSkJQYi9CODJUZFMyZ3NXOG9qYU9VME5hNkhKY01nZVNPaFBMVk1h?=
 =?utf-8?B?dTNaWXAvVFJZN0N6VkQ1L3E3RGdieUdDUDY3bklieDgwdkJTcXhyMnhBenll?=
 =?utf-8?B?SVVxUHVIUW5QWGdoRnowNG1la05iUmc4MzVKeXpxanpvWWxZN2VOelJvd1Br?=
 =?utf-8?B?S0gwbzh3UStXU1Ewb0ZCaTdHKzJtRXNJRkpRbURyaUJ1V3VqT0orT3NKQnds?=
 =?utf-8?B?Z1UveW85TjV4ODVFZ2crblJrSWJNb0JCTnFkWk1XNTYzWlpZenJjTTFubFlx?=
 =?utf-8?B?akJHSVBrSEwvd3VJcXJzK2lTRVNETENyNmtENEF1N0xURjNPTjNWQ3Zwd3pI?=
 =?utf-8?B?QkhMa1Bwc254TWh4RlBkWExkQ0hKdVRWdVduQm5qUW85R3g4SGNLcWdmd1hs?=
 =?utf-8?B?Q1krWjRlVXVLUTZYSEpGSUptUWtQVTlMaU00dXcwQVRXU2IzU1F6SVZ1dE5K?=
 =?utf-8?B?L0NnaDFEQ095dThJOUZ1YnNIT01jQ3MyT1N3R3NqWDVKbUpWYXp2cjBCUy9C?=
 =?utf-8?B?TTNjOUpaSFZyemY3bzVlZTVFOWg4aU5OblJHaCtqQTc5YytRR1FhWjhTRnRD?=
 =?utf-8?B?Z295alNRd2RKQ0wxZGNKbTh0Q1F5YXdvOGxuZHlRNzVDL0I0R1RHVzRqanY3?=
 =?utf-8?B?SUtKZEFRaXJ1dmFWT0Roc2ZPR0ZKMzQ0R3ZmNUsvbzdyTHI2TXRJK0RvZmU5?=
 =?utf-8?B?aHdzd3QvWDJLMEJyUE5xNllCNDFXMUZzNldETEwvSEREbFZNL1EvUy9KNXk0?=
 =?utf-8?B?ODVpVGlaZkFLYkpDY1hQbHptaVBGbUtHUm94Y3NpRkxpTkxwWWZLUDF0MXQz?=
 =?utf-8?B?Q214WE0yUHhZaUVGajZpOFEycVZCNGtHS3J5cnBaaXh0V04weHg5YnJDSmtJ?=
 =?utf-8?B?QTkvSWhCaEpiSGFUcFRiKzR6MUc3c3habWlNWlFnb2tIQmZhU0RsdjFqSDlk?=
 =?utf-8?B?NXZBV3Y1YVFjUzFNSWZLM09xUWoxMzhkb0JqczZQazFaWm5MSEQyZS9yUUV3?=
 =?utf-8?B?SUtpQllYY2hBS3hyelN4VURtSGs4cVc4UXpxUjN3UTdIS3hpM2xoeTNhMVZn?=
 =?utf-8?B?Zm9WWWhpYkJRRjlKSmNpcXZnREN0aml1N3ZDdzY3eFlvL3YzUExERGF4YkJ4?=
 =?utf-8?B?ZmtudEN2WlF4bFpJNHFWck8rcVcyTFVDM1B6Q3BCUi9NREdGc0xnTUVsTXJh?=
 =?utf-8?B?dlRjZlJ4MjVCTjBNL2VRYUlZRmxPT29RZC94UkJ1cXV6STdtaEUxa2o2V2RQ?=
 =?utf-8?B?WFVGenc2RWFpRTRnK3B4MzB4NzVRWDBhQWlsVEIrZHBuMFNSOWliUHVRdVJ4?=
 =?utf-8?B?S21xTkY2TURyZkxUU0c0MTVlVmdQSFpEY3hYZ21xck9WOHQ5QnlCZmY3dXJY?=
 =?utf-8?B?ekp1RUtrbnRxWVRGL25TUGY2UGVrcWxIeWZkdDBoWkhNaytFeE9VRnFoM0N5?=
 =?utf-8?B?ODcrY3FkSDIwUDZoYlJPeTlBNVJyNnl0MXpsTzBHZHlpZkRCS0xyWTNqZyt6?=
 =?utf-8?B?UGtmbjNLYUIzUDg2TFZCOS9nZXM2QjN1aUsvSU1iU2dGcWd6S043YXovRG1i?=
 =?utf-8?B?V2huVnovbE5pbXNTWEw0KzlZK3h0aUtsSzY4Vjl0WlBsbmVTQkhEbi9jbHZW?=
 =?utf-8?B?NGdqYUx0U2RxLzhtSUFIRC9aM1V3eHM0eTRLOTlXdzFoL2hGWlYwMXJDaVhp?=
 =?utf-8?B?QkVoZHR3TUpNWi90cW5wVnBpaWUxaTI2MzdRS2JaQzlvSUhoMlZIZWtiOG5H?=
 =?utf-8?B?VktzM2dVSlByOGhTOE1YUUlub0VsTXUvWjNCaTI4bS83L3JadnZzcjhTOXp4?=
 =?utf-8?B?K3diVWQrSnUvajdZMVdSSSswTnF6WENYc1Jaai94RlUyWFJvM2N6YXJWK0x6?=
 =?utf-8?B?QmV2S2xJbXNOUW83Zjl1U0hOZTNhWGxadldpY0xyYWV4aStRMEZ0Q2FaNDVE?=
 =?utf-8?B?VUE3WDdVR1VRNmtQVXExaFl3Q3RwUGk3YVo5OXEvS0puSDdycTQzVllHTm1p?=
 =?utf-8?B?ZGl3d2pUeXpZL29haExNWnh2ZUliNGNzbUUydks3eWx0bG5Zemh6SVhRTW9V?=
 =?utf-8?B?eUhDS01FQ0ZUVHJIL1d3WDFpRDlBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da08f10-1753-4d9e-4e3f-08d9eda79fab
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 21:44:04.5948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i4vApmQEWO+Kg1AHDeD8W79d8RkJVNJZYz1+Fzrh9PElk8xEKryVP/mVIUxauEArpQsJ99k2XMOwfwXIH+Nlkvf7mk20la2cSrZ/ISBRx7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2569
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202110108
X-Proofpoint-GUID: EBFHbcOpScEVBg_H7gktf2BANVfuRQ_J
X-Proofpoint-ORIG-GUID: EBFHbcOpScEVBg_H7gktf2BANVfuRQ_J
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 17:49, Jason Gunthorpe wrote:
> On Fri, Feb 11, 2022 at 05:28:22PM +0000, Joao Martins wrote:
>>> It is basically the same, almost certainly the user API in iommufd
>>> will be some 'get dirty bits' and 'unmap and give me the dirty bits'
>>> just like vfio has.
>>>
>>
>> The 'unmap and give dirty bits' looks to be something TBD even in a VFIO
>> migration flow. 
> 
> It is essential to implement any kind of viommu behavior where
> map/unmap is occuring while the dirty tracking is running. It should
> never make a difference except in some ugly edge cases where the dma
> and unmap are racing.
> 
/me nods

>> supposed to be happening (excluding P2P)? So perhaps the unmap is
>> unneeded after quiescing the VF.
> 
> Yes, you don't need to unmap for migration, a simple fully synchronous
> read and clear is sufficient. But that final read, while DMA is quite,
> must obtain the latest dirty bit data.
>

The final read doesn't need special logic in VFIO/IOMMU IUC
(maybe only in the VMM)

Anyways, the above paragraph matches my understanding.

>> We have a bitmap based interface in KVM, but there's also a recent ring
>> interface for dirty tracking, which has some probably more determinism than
>> a big bitmap. And if we look at hardware, AMD needs to scan NPT pagetables
>> and breaking its entries on-demand IIRC, whereas Intel resembles something
>> closer to a 512 entries 'ring' with VMX PML, which tells what has been
>> dirtied.
> 
> KVM has an advantage that it can throttle the rate of dirty generation
> so it can rely on logging. The IOMMU can't throttle DMA, so we are
> stuck with a bitmap
> 
Yeap, sadly :(

>>> I don't know if mmap should be involed here, the dirty bitmaps are not
>>> so big, I suspect a simple get_user_pages_fast() would be entirely OK.
>>>
>> Considering that is 32MB of a bitmap per TB maybe it is cheap.
> 
> Rigt. GUP fasting a couple huge pages is nothing compared to scanning
> 1TB of IO page table.
> 
... With 4K PTEs which is even more ludricous expensive. Well yeah, a
lesser concern the mangling of the bitmap, when you put that way heh

>>> You have to mark it as non-present to do the final read out if
>>> something unmaps while the tracker is on - eg emulating a viommu or
>>> something. Then you mark non-present, flush the iotlb and read back
>>> the dirty bit.
>>>
>> You would be surprised that AMD IOMMUs have also an accelerated vIOMMU
>> too :) without needing VMM intervention (that's also not supported
>> in Linux).
> 
> I'm sure, but dirty tracking has to happen on the kernel owned page
> table, not the user owned one I think..
> 
The plumbing for the hw-accelerated vIOMMU is a little different that
a regular vIOMMU, at least IIUC host does not take an active part in the
GVA -> GPA translation. Suravee's preso explains it nicely, if you don't
have time to fiddle with the SDM:

https://static.sched.com/hosted_files/kvmforum2021/da/vIOMMU%20KVM%20Forum%202021%20-%20v4.pdf


>>> Otherwise AFIAK, you flush the IOTLB to get the latest dirty bits and
>>> then read and clear them.
>>>
>> It's the other way around AIUI. The dirty bits are sticky, so you flush
>> the IOTLB after clearing as means to notify the IOMMU to set the dirty bits
>> again on the next memory transaction (or ATS translation).
> 
> I guess it depends on how the HW works, if it writes the dirty bit
> back to ram instantly on the first dirty, or if it only writes the
> dirty bit when flushing the iotlb.
> 
The manual says roughly that the update is visible to CPU as soon as the
it updates. Particularly from the IOMMU SDM:

"Note that the setting of accessed and dirty status bits in the page tables is visible to
both the CPU and the peripheral when sharing guest page tables. The IOMMU interlocked
operations to update A and D bits must be 64-bit operations and naturally aligned on a
64-bit boundary"

And ...

1. Decodes the read and write intent from the memory access.
2. If P=0 in the page descriptor, fail the access.
3. Compare the A & D bits in the descriptor with the read and write intent in the request.
4. If the A or D bits need to be updated in the descriptor:
* Start atomic operation.
* Read the descriptor as a 64-bit access.
* If the descriptor no longer appears to require an update, release the atomic lock with
no further action and continue to step 5.
* Calculate the new A & D bits.
* Write the descriptor as a 64-bit access.
* End atomic operation.
5. Continue to the next stage of translation or to the memory access.

> In any case you have to synchronize with the HW in some way to ensure
> that all dirty bits are 'pulled back' into system memory to resolve
> races (ie you need the iommu HW to release and the CPU to acquire on
> the dirty data) before trying to read them, at least for the final
> quieced system read.
> 
/me nods

>>> This seems like it would be some interesting amount of driver work,
>>> but yes it could be a generic new iommu_domina op.
>>
>> I am slightly at odds that .split and .collapse at .switch() are enough.
>> But, with iommu if we are working on top of an IOMMU domain object and
>> .split and .collapse are iommu_ops perhaps that looks to be enough
>> flexibility to give userspace the ability to decide what it wants to
>> split, if it starts eargerly/warming-up tracking dirty pages.
>>
>> The split and collapsing is something I wanted to work on next, to get
>> to a stage closer to that of an RFC on the AMD side.
> 
> split/collapse seems kind of orthogonal to me it doesn't really
> connect to dirty tracking other than being mostly useful during dirty
> tracking.
> 
> And I wonder how hard split is when trying to atomically preserve any
> dirty bit..
> 
Would would it be hard? The D bit is supposed to be replicated when you
split to smaller page size.

>> Hmmm, judging how the IOMMU works I am not sure this is particularly
>> affecting DMA performance (not sure yet about RDMA, it's something I
>> curious to see how it gets to perform with 4K IOPTEs, and with dirty
>> tracking always enabled). Considering how the bits are sticky, and
>> unless CPU clears it, it's short of a nop? Unless of course the checking
>> for A^D during an atomic memory transaction is expensive. Needs some
>> performance testing nonetheless.
> 
> If you leave the bits all dirty then why do it? The point is to see
> the dirties, which means the iommu is generating a workload of dirty
> cachelines while operating it didn't do before.
> 
My thinking was that if it's dirtied and in the IOTLB most likely the
descriptor in the IOTLB is cached. And if you need to do a IOMMU page walk
to resolve an IOVA, perhaps the check for the A & D bits needing
to be updated is probably the least problem in this path. Naturally, if
it's not split, you have a much higher chance (e.g. with 1GB entries) to stay
in the IOTLB and just compare two bits *prior* to consider starting
the atomic operation to update the descriptor.

>> I forgot to mention, but the early enablement of IOMMU dirty tracking
>> was also meant to fully know since guest creation what needs to be
>> sent to the destination. Otherwise, wouldn't we need to send the whole
>> pinned set to destination, if we only start tracking dirty pages during
>> migration?
> 
> ? At the start of migration you have to send everything. Dirty
> tracking is intended to allow the VM to be stopped and then have only
> a small set of data to xfer.
>  
Right, that's how it works today.

This is just preemptive longterm thinking about the overal problem space (probably
unnecessary noise at this stage). Particularly whenever I need to migrate 1 to 2TB VMs.
Particular that the stage *prior* to precopy takes way too long to transfer the whole
memory. So I was thinking say only transfer the pages that are populated[*] in the
second-stage page tables (for the CPU) coupled with IOMMU tracking from the beginning
(prior to vcpus even entering). That could probably decrease 1024 1GB Dirtied IOVA
entries, to maybe only dirty a smaller subset, saving a whole bootload of time.

[*] VMs without VFIO would be even easier as the first stage page tables are non-present.

>> Also, this is probably a differentiator for iommufd, if we were to provide
>> split and collapse semantics to IOMMU domain objects that userspace can use.
>> That would get more freedom, to switch dirty-tracking, and then do the warm
>> up thingie and piggy back on what it wants to split before migration.
>> perhaps the switch() should get some flag to pick where to split, I guess.
> 
> Yes, right. Split/collapse should be completely seperate from dirty
> tracking.

Yeap.

I wonder if we could start progressing the dirty tracking as a first initial series and
then have the split + collapse handling as a second part? That would be quite
nice to get me going! :D

	Joao

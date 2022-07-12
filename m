Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C941F572705
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 22:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbiGLUMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 16:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiGLUMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 16:12:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43DFC04EC;
        Tue, 12 Jul 2022 13:12:33 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CJY3OA000443;
        Tue, 12 Jul 2022 20:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=f21zEfOoHlLmZ+hyjX4FnaXqZapexvOJ3KdlLpXc7qU=;
 b=NOxZqOOsuh943SvEwOh1XXeHqDN4KUN7oLc8Kh1OrLlAEJwwE4QQD/E7LRQPW1LEfZUS
 VfGEaoXZrDEty77iM2d0hf1d2w8dEGtULcUMG5a0iA2LK1mtsvb3k+KFMPr5gUc1PYJX
 fKHI/dEt6D3CZRGWsr2p7c9DEoVDHqQscn+48sZlVQIn0IKsXQCAv221C0UJoVnAw0as
 6oB7AkPvMabk0A2nqAeHHhocz3HSjmBtlqD6+TQ/la7PCuctGBZDhqkUcKzrsjBibQCH
 ncrEaUMAHRpG3JF650D8a+1mjmzWf2UvEn93pp1nqyS9JyGeiwZz/XVDGeLc+AZ0JLk9 cg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h727sgdwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 20:12:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26CKAEYZ029995;
        Tue, 12 Jul 2022 20:12:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h70447mkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 20:12:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vq3quhWa0vrF1S0UHnY4RZaqzguZfE4dXY3HXfiIPX+FFY0EeDOGQWf75Nd+UuTw7uYZO+79GNHTGmXGIjZsiOiTOOQyPk7Pel9W67LBe2CD9Nb6WQt5GXkUE4kttLVAuJNY+kroeu4+IOqXDAnKmOAFxUXMqvzhsoDGP3SQF6ghk6ajOLhMXrTl1IATmXm9xHEWSPuMA2WoJa1NrkG2JjSwzS5iap6VFxF54QI+m1BAFSlhnDWBg6OfTcFoJC41Ap7l/0llz+Lz1WsJrQEMG+d+wTF9nsdbFXfHGYxhXkXyTpF6J/nd6xqokZNyqQ4gkdKdZWjo9QEY8Br9NLSmcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f21zEfOoHlLmZ+hyjX4FnaXqZapexvOJ3KdlLpXc7qU=;
 b=aLM/FWjlTS7rb5ud+Vnd2dHBasS7vku5btQ+xPnaeel/gF0BUs2UVsiPWimGxB8uTMlUILtbTGUaqezWQwjhK2yFFbgVIr3WciDGIYdCKnb0tfZkSTLH4umgEDP2558NMoJZWJwQ4vIq4Ep3i/gD+NLS/Vq1+ht+mhigE/a3T561ya87/FQaEt5nRTLft7t1mBz3NMrjC3XD42Gzca5J+MMoaDorECVREMKW98Ws9w34Igh/zuCg51ST1/lCeREOS+zFLj9p4DJBHhtmdaqZgYEzMaw0c97ESnBC4R2kKqABLtyT9I9yauW2bxxfj+DEdqYaGleSC4Mf9omHNXf9Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f21zEfOoHlLmZ+hyjX4FnaXqZapexvOJ3KdlLpXc7qU=;
 b=nl0YIym224li4QsM56y4kTQPfN0SI4WspUngDfrOhQ8nfwbhqs8Yj3jvcGHap3ZvWlocZUPVR/PAZhEgYytGiU4ZOD5/Gy4X+U9EPVFtno/d3KLXiGOEBNXdThqWiDOU4VYvx/atUv7Dp2jaElHqh48CBNmJCRBrmfaw9xDqKDY=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH2PR10MB3976.namprd10.prod.outlook.com (2603:10b6:610:e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Tue, 12 Jul
 2022 20:12:02 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::51f5:32d5:ff0a:98df]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::51f5:32d5:ff0a:98df%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 20:12:02 +0000
Subject: Re: [PATCH] KVM: nVMX: Always enable TSC scaling for L2 when it was
 enabled for L1
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20220712135009.952805-1-vkuznets@redhat.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <ed923f16-86a7-1f87-f192-c935371dc48c@oracle.com>
Date:   Tue, 12 Jul 2022 13:13:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20220712135009.952805-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0076.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::19) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bf60b7b-46e6-44cc-96c5-08da6442c814
X-MS-TrafficTypeDiagnostic: CH2PR10MB3976:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Bo1oL00s4daLuBbUIFTx+PPo+WdWGkIh1ywIeLLggtsP8PjRW+vlEBnXa2yEnYwWgpUKARNDtqfr9sArIOGOc3hyIH9zHc/otCeTkmRiyXa0hcU9TnjRCs0S1lfmBoOO7CJYHdI3vG3HdEJ6yvHlc0kCKfcRfpwb6qM+d8SQDpDxR0lB3I3JDL3p/xvMvpcFnqq8M3CkSHDP9oGAjGYcgKDwi8/W2s6alpuneHcumjHO3amdOO0u4+uNaXaJK4C8rhgMRgVW3jGZEZ1CXYHWtwa9L1oiQEq8p4a2asr3kDQC4Z7TXVTOMSDDLgG75gcjXzaiUgdqL9/KHMUGCTIQ5nuu3LIrE5KvtWyG15rC+iSuE2HQddFvvU+t9GVGQJJTmGlUTMakMtDfGg5CvRD8BIHmRBWNuhk1pbDtaU+kfMQqVPIpqWw4BPdXQS6X1I5WATVC5Z7Pp5ZcdmO84eJYGxACI0a5tURLxFpkuAPubStL1q8yC/STopa4gHH406+iFyQEeObl4DJM99iUXUhnNW7x4gXJvlzMlpJaTD2A/ZEf6V6vMQy5+jy6cMvtCANCRYniLudBeiOK7G9HkITvhPEMMEU7x9yi8ULSEnK5hZhXrMnbHajU8s4lbZCnEB8Ggd2e6/Y/9Kz1aTcWAA61CVYICmZdQfvKFUjf1rYwY1TpnHFSNxIgnnlInebxSZkU+eJELJaYCQ22BaMYj3b5/V9SdC4loZbPNyjyS2teJQ2M7aB3YW9Xwrn0sNk4FV3j5el0kMVu6TEiKTa/G+d/Yb82cDnyK2pXMoAqtErOYdt0lEt0TW9WHXjcjh0oj0sIsVm6Fzj8Aa7TeMQf2JUPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(346002)(39860400002)(366004)(316002)(8676002)(66556008)(66476007)(66946007)(186003)(6666004)(2616005)(31696002)(83380400001)(6486002)(53546011)(478600001)(4326008)(31686004)(6512007)(38100700002)(6506007)(5660300002)(6916009)(44832011)(54906003)(36756003)(8936002)(2906002)(41300700001)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFpvQlJHSmxuZGUyRCtScUw2MmFlNGw0Q29tVWFuUWJZYTRsdHpIcWVRdEw5?=
 =?utf-8?B?WmM4aExneFY1V1VsOCtQT3hULzQvbWd2RGVIRWVwUE1mbi9KNGI4NnN2MU0w?=
 =?utf-8?B?alFmS3AwKzF1enRKQWFFWEV1alh3VzVMaG13ZElWckcvaXZRVjVaaUFCZ1Iw?=
 =?utf-8?B?U3BzVkdvUlkvSU9qakJ3ZHJpWTliNHZpRTdGQkVWekR0WW9kcHBGNkF1LzhC?=
 =?utf-8?B?Y2EwQ0JOWDBhMTlnT2NDZW5uMGxGb2hBNWVIUUpnck9tVVlzSkxJeVFYVkRt?=
 =?utf-8?B?OU94WUZOQmdOb20yenkyc3Z4WC9rRStlcjRJU3JpZ1VtbzFwRGpyMGkwa0t4?=
 =?utf-8?B?cjdvL3p0ZWZaY1JsQ0FPakx3ajM2YUx6WTVrQXNsMFpnc2ttYU5pUCtaZHZ1?=
 =?utf-8?B?VlJLSFF5YWtVMXhzdW14cXIvTFkxdFpQUzJpc1cxZW5nMVVlNUxJeHZyVjBv?=
 =?utf-8?B?L3dwelh3YnVhRm5aTDRsU0JtTXpWTFVkaWdiUk1zM212VkNQUkhLM2JWSGgw?=
 =?utf-8?B?RFlCUFA0clpneWRpMmRSZHhRaTB6NGlnWXJldkh3eUNlMXljcjJnb01RZW5j?=
 =?utf-8?B?T2luczRYeldpM05KU1dNNmFmdk1yWkF6SWJCVGREWWdFZmxiNlR4di9DaVhF?=
 =?utf-8?B?SUhIMFlkb3NlTXB1MzZCZHpEMHg5U0NhWVV2OVp3YW51YnVlQmwrVjd5ZGNw?=
 =?utf-8?B?aUY2Qm5NdDZuS0Y1ZEhDc3V3bWFYZkdXdS9weFJiK0ZVKzJ4NjVBZ0RUQ1Zs?=
 =?utf-8?B?aEtIQ0NiQkxJNVd3QW15VEtGOTl6OFUyMEROOVdzbnZVTG9kTk5hNkxHWkt2?=
 =?utf-8?B?SXBuRmZNNXZvdVI0Y3ZXMXhySFk0WXFxNFJYMk9tRzNSVWphaW1MNnJMeENT?=
 =?utf-8?B?Vk9ZaDZjcHFDSVRKa1R0QmtHeUkxMzNaQ0g1UVB4RUJ4MUlqa3NSZVJRREVs?=
 =?utf-8?B?RzkvbnB1V1RaTEVTc3ZheVRPRXg1aGFUVHh4NmJ0eXBaTjBuNStURTVuNzBY?=
 =?utf-8?B?d1gwOFREeUZtNktCaU90Q0ppQ1ZsbXFNRzdKQU1IbkVlOFhLWGtqM0wzaEhZ?=
 =?utf-8?B?VjVEYnNqWkJnSEFGaXhLT0hrdFZ1TDZiWFBiM0g4Vy9YWERacXdreXJTQUR5?=
 =?utf-8?B?WmZBQUc2VWw2b0lDb05GZnBvVEk4NGFreWdDMFBoRm54K0U1V0N5dzlOcXlR?=
 =?utf-8?B?QXJycE1LbC8vWUJEOTA0MTVuMFlZRGJYYlFlajByL2VTTGl0OXlJdnNwdlRX?=
 =?utf-8?B?SUpUTmdiSXo2c2dmanQ1TldyeHFpNGxIRC9pZFdScTdoajJOVHp2VWdwb1U2?=
 =?utf-8?B?Umx4cWxiaTVoT0lJaEdoNlUwTVBUMjBUTVBPV25SZnlNMHJNaTloREFnZHFU?=
 =?utf-8?B?TDBhbTZhQTBHazBVUENBQXRySHZrS0l1Y0d4akNhVVpCdHVsUzRaRCtWYnRl?=
 =?utf-8?B?d3BBcmp3Wi9qTFBuZmRhcGo3enlhaVVwcHJrR0JGWlNPM3NwMmovdFhwQU44?=
 =?utf-8?B?VTNkVlRwTmtmR3lzUXlkTkx4bmRsTXhIY0RxcjlTVWIyN3ZhMlNOdUF5RHFq?=
 =?utf-8?B?WFNyQU9ZZUV0L3hBZ1dKa1Y4VU5ja2dPcUJ4Y2FGcE9Md0hrRm1SN1Jjek41?=
 =?utf-8?B?QTFLWERReThEVmpRNFFMU2lMTW5vN05ZeUNCVHVreFpoL0pLb0Y1RDVpN3RX?=
 =?utf-8?B?bmhrbWRpcGJMcG4wTU1WS0hja0F5UWpJVlpFbzlrUmZoU0JEbDNrWHpOUFQ3?=
 =?utf-8?B?Q01pS3prVkQwdEhhNTY4Und1UEJJMFZzZkNVNE81a083L3puVlNOSkhBSnAw?=
 =?utf-8?B?OEdyMkFPRGMxTFlsQ0V0cEdRcmcxZUtPZlNCSWgybjVNSzdRUUo4WU5qOWNK?=
 =?utf-8?B?ZXhlaDZmTGpIdk1LczlHeVcrNHpvLzQvVktBbUhrZWFLcnVlRUw1TDBGeGRn?=
 =?utf-8?B?OWR5VU1kNnZncmpFVXFYZlF5eUU3N2h2VjVaOUNBaHFXOFcxTFZaMG9peGZq?=
 =?utf-8?B?MlFwemYzenNOVTVVVEFHNG0wbnY1NGJkaGh5Y3RPbmJIZk55Zm56YlJROWRr?=
 =?utf-8?B?eW9DWGQ1aTVGMFJQdHhLMDVyN2xnRnhvSDV3WmNYaGQzRTU3SXNCWnZETFdq?=
 =?utf-8?B?Z0NGZXhBVDU3d25kclNlcDRveTVLcmN2MmNhMWR4TmRKdGNidUlnZ2VwVU9i?=
 =?utf-8?Q?4JsaEZDahNHRe4Lqp3IozuI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bf60b7b-46e6-44cc-96c5-08da6442c814
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 20:12:01.5633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUEiGMfZnrAfRrVWid8iF/Asu0t5G4mHfOCu/WwS6xuCVjsE3SRzyjGNt6GFZS/GjXPnncutBaiPKhKYegLnIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3976
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-12_12:2022-07-12,2022-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120082
X-Proofpoint-ORIG-GUID: 7xX1HdofFuRoLK_WQp6vkInAgIxBvzZ5
X-Proofpoint-GUID: 7xX1HdofFuRoLK_WQp6vkInAgIxBvzZ5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

On 7/12/22 6:50 AM, Vitaly Kuznetsov wrote:
> Windows 10/11 guests with Hyper-V role (WSL2) enabled are observed to
> hang upon boot or shortly after when a non-default TSC frequency was
> set for L1. The issue is observed on a host where TSC scaling is

Would you mind helping clarify if it is L1 or L2 that hangs?

The commit message "Windows 10/11 guests with Hyper-V role (WSL2)" confuses me
if it is L1 or L2 (perhaps due to my lack of knowledge on hyper-v) that hangs.

Thank you very much!

Dongli Zhang

> supported. The problem appears to be that Windows doesn't use TSC
> frequency for its guests even when the feature is advertised and KVM
> filters SECONDARY_EXEC_TSC_SCALING out when creating L2 controls from
> L1's. This leads to L2 running with the default frequency (matching
> host's) while L1 is running with an altered one.
> 
> Keep SECONDARY_EXEC_TSC_SCALING in secondary exec controls for L2 when
> it was set for L1. TSC_MULTIPLIER is already correctly computed and
> written by prepare_vmcs02().
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 778f82015f03..bfa366938c49 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2284,7 +2284,6 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>  				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
>  				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
>  				  SECONDARY_EXEC_ENABLE_VMFUNC |
> -				  SECONDARY_EXEC_TSC_SCALING |
>  				  SECONDARY_EXEC_DESC);
>  
>  		if (nested_cpu_has(vmcs12,
> 

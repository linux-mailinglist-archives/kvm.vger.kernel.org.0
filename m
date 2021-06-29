Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAB03B7486
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 16:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhF2On1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 10:43:27 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:15792 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229529AbhF2On0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 10:43:26 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TEWtv1014729;
        Tue, 29 Jun 2021 14:40:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=bp+5wxKczOG8YNm+/XuQ79AzA/wuAaIPIVU7TGMY83w=;
 b=hmi3cq1DlLS/7abo7pTmbMhCGgH9k1G4FLyN/84ToEhTUpWQVG7jxn2bpyddWDuNga3R
 HIEcd6E/mSQIxbsHK3T/2KZcKWiicRlL9tk8J3S8O+RSiUnbEEPZmODndtUXy0yitZgr
 QNqbcXlT4RJyn6Z+Pv+lMZXA1kaJ2h19jZ+1L+7jdaEqMIcCD2ybOsix8j9uywpNUxq2
 osAU4IvQets78i9+VNpWpTHy7hPk8Be2uWHR8/GTSkIZKEqEhddB5VxxSCMiHznBZ/qz
 vxUsA1jdjBuyWoNCR/BIW1i1Qg9Rz58DQT+adrHlSivhQrrfixZ+OSHC4Pqzflwjmu7e zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f174kybe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 14:40:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15TEUCr6083377;
        Tue, 29 Jun 2021 14:40:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3020.oracle.com with ESMTP id 39ee0v00cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 14:40:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHRlETFHbUAK1TkiCxJDQwjY1Q+4LA9cR2zW4y5P8iMPC6E2KXitU4putU3u4TX6Kf0gC4dVpVWzshqqlOx+6Cx04sYR3WGJ3Vd5PndaaSEZQTz/df6V5/hF1E3EY7wU39x5A9F/plpmRpgxwIVc0XKOh0ym1nHBJkjx9vJB9Eup0bAc22s1nAjXKu1fxJib4oITc52O+foM01BekX0dL1TaHljZ3d34zJLkPzKihkiUP6wlDPpRm5g3bLZRG46a/rpqzO5CxbrOCa4OnG8t+9Y15Suoju1Kn3GIHqIvwfK0nSaXIZOy8/cq33fldM6fJzh8Wiko76RnXfhpj/vCdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bp+5wxKczOG8YNm+/XuQ79AzA/wuAaIPIVU7TGMY83w=;
 b=nUoqzwg0Utn+MtOYG30rf2SwEB8NK9y3ziFTP56CrWTwuAmW6SCHwwRQefteGGKe68aP2FFKRIwIcS9lU77tV6z3kpUuL5bN0IuyjpnwUHUm7bFi1GbusFfie6PZTJyPYZPFSDYkm11u/0v6pzfsNRhaRhr2px+XbDPRgHwSWSzsDQsv8jpHi1kgLx+6k5D0hBr+9870VwtHx1tSIv0ulhgBRXU7x5YaiE7dOQQqXpN5SE/odyzBCdZDV7QyrQm5cczJocvYY962ztbWD020YhCIEUHCNYopAURzF3Ev1t4Cc6kJSraQ88qOKirobXrtUdQ3H+RykV4MLB8Du+QyMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bp+5wxKczOG8YNm+/XuQ79AzA/wuAaIPIVU7TGMY83w=;
 b=SUPjeMvn0X55MjbqRdSbgxqLQYxXEVyHlq4om9E36wrxzqi0PZBWTL0IbVh8Jwj6u+lMkeq3uL18Iqhf5viL2P+mfEBhrS42zHvKmAW3jjgI+e6Iqa1HEg8aioLbbRBCHVkRDB6VcQdHKU/X+R8z51sqBmzu/A4CDYjzf9/95Ss=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
 by CH2PR10MB4248.namprd10.prod.outlook.com (2603:10b6:610:7e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 14:40:48 +0000
Received: from CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::9490:e23f:3d15:9cd6]) by CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::9490:e23f:3d15:9cd6%9]) with mapi id 15.20.4264.027; Tue, 29 Jun 2021
 14:40:48 +0000
Subject: Re: [PATCH] KVM: arm64: Disabling disabled PMU counters wastes a lot
 of time
To:     Marc Zyngier <maz@kernel.org>
Cc:     will@kernel.org, catalin.marinas@arm.com, alexandru.elisei@arm.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, konrad.wilk@oracle.com
References: <20210628161925.401343-1-alexandre.chartre@oracle.com>
 <878s2tavks.wl-maz@kernel.org>
 <e3843c2c-e20a-ef58-c795-1ba8f1d91ff6@oracle.com>
 <877dicbx61.wl-maz@kernel.org>
 <abcbd6db-da75-a6ad-01f3-7c614172ebd4@oracle.com>
 <62e6fa4693c87e7233642e7192344562@kernel.org>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Message-ID: <fdf22426-b5e1-d71e-4d4d-3a698f714902@oracle.com>
Date:   Tue, 29 Jun 2021 16:40:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <62e6fa4693c87e7233642e7192344562@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2.7.202.103]
X-ClientProxiedBy: LNXP265CA0080.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::20) To CH2PR10MB4391.namprd10.prod.outlook.com
 (2603:10b6:610:7d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2.7.202.103) by LNXP265CA0080.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:76::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Tue, 29 Jun 2021 14:40:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 993c7b6c-4693-4a60-5c7d-08d93b0be2e5
X-MS-TrafficTypeDiagnostic: CH2PR10MB4248:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR10MB42489D491844A9707CFB1ED79A029@CH2PR10MB4248.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:389;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CRlVi/NlqViujV1RBXBzCWMub1Tpy2+X+S8NRYNRYdV3v/1GXAONx87JYUAl1yB3+NYRKcC5SJgQpFJKVN2qjl5XJjiJnqn7tXj96zrLgYSXMa/C+ZS3SKaHma7E9pUCRJwHO/Nffz5pz33S9AQ/ZZvWPbQeV73HeWfyV4hooBre9Dkxh4N+Q1LygHyLqbNwy8kPDJTICMl0hdikQ4+aoWPOWZPzvDxnVvXpprMlExo4hTjJ5m/H0tJAtkcYfz9+2gXqdiv2Rpz2+oEj/xwHH8L99JD1hiKq6aJFJ2gzmJzxrtUhPJS84pOisBvfaYONxxUG7qCa8eOLQJfKAUZRVTKrApa1wYHMj18KWRqo+5VC5+MrfHB1y343hbaXWWpveMRpWpvjXCqCFRYX76XNlK2TqTXLWIszrJOEDSquAAGfYh3E63c0XUqbFuUn+jLvaPpqA4F15oxLbNduH8EWjv7rphvL4G+P2kdJctL7cV0bMYi/3mZmYSE/0Z+y1qVm5GmlwdS26FyCWvD4ZYbkWEmZVJDWX4br4lAb8ONlaQTmv2kOw32KTwQHb+L8nFYiYAhmmIRMXAPWxr1jmHh3ccdpafRnLYs2o1Bx8peIK1IuHen3Y2EZuWXSTJxANfX5hXfkfhY1DSJ6hbJwT2dx3ADUBygYZ6gpO4MVqSIK0GiZ9ShRFLjr4evZTtH6XJOBLXd33xftL8242nk8zHFDOQlXPLDZNWeIpKAdZUyBGjk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4391.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(376002)(136003)(366004)(316002)(66946007)(31696002)(66556008)(66476007)(4744005)(31686004)(186003)(86362001)(16526019)(26005)(107886003)(6506007)(8676002)(53546011)(5660300002)(4326008)(38100700002)(8936002)(6666004)(956004)(2616005)(2906002)(36756003)(6486002)(6512007)(83380400001)(478600001)(44832011)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVEwTnhVUVBJTG9UVlBUb2l5cWpyYWJTQ0pDQm8ybGU2TVhjK2JpZzNLb1Fu?=
 =?utf-8?B?aGNCeTlLMnNQdUlXNm5uRkVyRjlMSERYOVdCODQ1bEZjdFZxQnJSaVg5bDlC?=
 =?utf-8?B?a0x4U0pIOHpKK3d3RUpDZmZLSm51ekN1SmgvZnU3VFExS2NXaC9uQks2eEM3?=
 =?utf-8?B?R2xaWUdxUEFUNFlML1NBZlMyb0oreGt2enRhRDVMS0pTbjczTUwwZnpaMkhH?=
 =?utf-8?B?c1YyQWlxZVRMY2J6SURmY01WZklhakZ4eHZFUHppVUkyd3REVFJoRG4rcklu?=
 =?utf-8?B?dmQ5MHlsd3RnbUdzbVZReG05Rkhpa1o0aXhWU0N0RXFzN3hlQ2FaNTlOUFFZ?=
 =?utf-8?B?ZndxaVdRS3Z4YlJHWWhhSkV5cm9pdmNiUlpUcTZ4aUdxU2IyWGd6V05ac0ZF?=
 =?utf-8?B?aVN2WnhINEIyUXgrblRRVnFHRUFRcHBoRGd3dGpHaitYenNwUVRCM0RpMTFR?=
 =?utf-8?B?cDZvWkNEWHNueEdFQXJhR1FxSHFicGZncG13RURmb0MyQmNoR2NjRldJVy9s?=
 =?utf-8?B?TWxpRnc2RjloRktwOThrZS9TSEwwcytXeVBmaG1LL2Mvcm93bUdSYmNLQllB?=
 =?utf-8?B?WGpJMXVxZEFFOTBnOWRuS3pPY0JUTVRzY2lPUmk3LzU3VHQ0djkveStVbm5Z?=
 =?utf-8?B?OXlQaWZTT1g0UFJsYkRHR3hxK2pqN2lkVEI4U3pwa3R2R0M3c2tCMkV6MjVO?=
 =?utf-8?B?WGZVa1hEM0xGVWpCZmk3c2lwOVNtaHBsdTdaTnpxU05zdGdVSG5NckptdGF4?=
 =?utf-8?B?V1Q2VC82R2pxRnRzS1NkY3pQVHB2ZEx5UnlRclZXQTVBZTQ0MVQ2d0ROcVpi?=
 =?utf-8?B?MXVMM3ozUm1veE45R2RGeVZDM2FsQkllWUV4QWpYN3VpaU05US9SdENTQk1K?=
 =?utf-8?B?LzJiaUNDUzdRbFJwRzBoSGZTb0thK3Y5RnFMUFF6M3BKOVFmMkQybjNwU09q?=
 =?utf-8?B?YTVXSWdLMHA4WXhBQnJUd0FEc1F2eHZNT2RsKzlTUlpSNlQ5U3lEcHhEamNN?=
 =?utf-8?B?NlAzMUdOM2dSTUxYOEJtTEloT3NLQUxLMVMzdi9wSTU1R3Y5RWxqRlg4ZlIz?=
 =?utf-8?B?RURXaHBvS09MRk12cEo5RnEvQWFqT2FxUTFQZ1NZQ0R3SkRGQjVKcUVJQWVL?=
 =?utf-8?B?ZDl5dS8xUXN5emc3NXNnTXhLTmYzR3BjOU5ya0k2WWtiZUwyRWJpYnN6WmFs?=
 =?utf-8?B?a05vaXFFenNOdGpCWDc5TEpkamp5YVh0UXNGa29UcmdwenRoVnJERDRWMXZZ?=
 =?utf-8?B?cDJ3dk05VWZGdmZHdVk1djd0WWZ4eUFpeDNBSUNhRXNRdkl1N0xLM1JPMVhF?=
 =?utf-8?B?QXNsUy9UdFNMWlU0RnlCNUtLV3JCNWxDbFBjMWhUVXJJeURiRWw4ZWoydmVH?=
 =?utf-8?B?dDA5QmpJSGRPM3lFZUdra0VqRzZ5ZWdvRmpoTEVnd1FteGJuSVRnZThKUFRT?=
 =?utf-8?B?SzNxa2U3SHdSY3JIWlg5T094K2ZySTB0VjBCRXJESnNTOVgvSUEwcGx1SWl5?=
 =?utf-8?B?WjV1cnZRQUh6VU9IS1NXOE9NNWI1em5GKzg5NXVaSTJGbFdYTU1oZjQ1VWk0?=
 =?utf-8?B?S2JuOGpNVW9lSFNaT1dlSU52Nkt2WkduK09sRkJoTEFvWjlWay9SMzhBVDhU?=
 =?utf-8?B?Zk1QWXJ5TTdDNnA1cmtyOXR3WVFGWVRVeHdkZnZCT2dScmM2S1VBeG9aZnl1?=
 =?utf-8?B?RFZlMHBROHFWejVHTEVnR2dTZHIvSWhDZEVDTTBnNUcxZklIVnFCM0xlUWFv?=
 =?utf-8?Q?a/wl441MCXqD/gkiWmGlJTH5qrdQOOCPpFzZJeE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 993c7b6c-4693-4a60-5c7d-08d93b0be2e5
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4391.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 14:40:48.7933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NBBJV8QIkikbStvHWn2sww7eLlM8EubTD9sQZSVfy6wV+eQTirULxXw7gmRbRy2dfrA6EbhUXE87j9+0L1ca3rmYOeuxpCFHTkSBBFSguNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4248
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290097
X-Proofpoint-GUID: ntndlR86xuczC74X13zNDtuG8kPHFt7l
X-Proofpoint-ORIG-GUID: ntndlR86xuczC74X13zNDtuG8kPHFt7l
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/29/21 4:25 PM, Marc Zyngier wrote:
> On 2021-06-29 15:17, Alexandre Chartre wrote:
>> On 6/29/21 3:47 PM, Marc Zyngier wrote:
>>> On Tue, 29 Jun 2021 14:16:55 +0100,
>>> Alexandre Chartre <alexandre.chartre@oracle.com> wrote:
>>>>
>>>>
>>>> Hi Marc,
>>>>
>>>> On 6/29/21 11:06 AM, Marc Zyngier wrote:
>>>>> Hi Alexandre,
>>>
>>> [...]
>>>
>>> If you are cleaning up the read-side of sysregs, access_pminten() and
>>> access_pmovs() could have some of your attention too.
>>>
>>
>> Ok, so for now, I will just resubmit the initial patch with the commit
>> comment fixes. Then, look at all the mask cleanup on top of Alexandru
>> changes and prepare another patch.
> 
> Please send this as a series rather than individual patches. I'm only
> queuing critical fixes at the moment (this is the merge window).
> If you post the series after -rc1, I'll queue it and let it simmer
> in -next.
> 

Ok, I will prepare a series and send it after rc1.

alex.

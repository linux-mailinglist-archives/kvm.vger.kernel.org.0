Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4F13F6B97
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 00:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbhHXWNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 18:13:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11448 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbhHXWNq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 18:13:46 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OJtIqw001072;
        Tue, 24 Aug 2021 22:12:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=57wrucMCrw1q8RIEKhP7wXD7d1s/1TReV6LMgZYVCAA=;
 b=vwOQLn+x4I6giDrwBjTIEDUsqUtGfwR9MvGGA1GrONASM3X3dnj8w/beJUNwKGUoi34D
 wJa9WixL+GZpEhmaT/CdEGqKYl7Dik6GLluZPmit/HU7m27IMVe2XC3Y08sHX9fQMUKK
 29MIeAjF0tUi57ISUQCcroZ99I/U6MRsqccMcWkSlXV2aAleMBCVpBgFUeeKWeD30Omy
 6ZpoV/YgQVZNqj/E/IMsNI9wHNwxy0ylcukrWrWvjegTOvdAeSmnkuQY8vlybTk1vZUl
 0UpAmN+PTXjPVMDagOtpZG7r2mvIYv3Je9t2HVnBEa6H2I8n7hTvDKw27UD1M/lOY9e6 1g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=57wrucMCrw1q8RIEKhP7wXD7d1s/1TReV6LMgZYVCAA=;
 b=tAnTfobgYh4wFZBmdLr1qfsQNSxOB1YDJa52cU5QkPQQcU92xjBoO6ceF+FiffjPlBQW
 1Kcim8Edr/cqS/cTDE+xH48hhedDcpBBJ3FTaHW3ZP8hp50P4ry1YpObnVq+86LrK4lr
 7RaF7+luYaxFMNuK/b6oTzyt/nbUrJn4v8VF7fyzgJB5t9y4dJfY1Y/Tf/IFbhzPKaZW
 fHxnrh1SGHR7fIIXdsaclK6U3NefRSlpdsCngBpfROTCM3HGw83Qkxh6ukF0fO2Z56Mv
 Jr2HTWc2BNSoBgkV40xezJFCSOyYEVTSVxQZJhDBUycXaSG/5HARvTuw+DAFlphpFMol lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amvtvt3fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 22:12:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OMBGVk152557;
        Tue, 24 Aug 2021 22:12:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3020.oracle.com with ESMTP id 3ajsa62kbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 22:12:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNxZz55KkWSYntsIT32SGbD61tOIwVxTFDMwGkcoRS34iDNp+rm2Pe9m4zlPiTGP+qXBQ/D4uCaIBpD3ALmVkhwrNIkJup92wtsDSoiFyur621F4yLKLIpbpxe6aL/f3jJVRd+V4ht7X6XQRxSQPHAtFlo3fTOvuDejI/vbMTWBGOJrp5pFvHb45QKb0kMvD3PIIB5Kx19DbeQuAav9NWx4CtKdvo5Y+e9ZUF8BgYwQ8SIWwVOv+l+UJA/xE71v03nJeakSNGNfZjjV+4AL/D/FNWSHaw3tOTM+ndudhCUbDfj+aGthXqmFSFNo/kMvr8zPpcbSdkT9WfcpwsSMx4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57wrucMCrw1q8RIEKhP7wXD7d1s/1TReV6LMgZYVCAA=;
 b=DciGtbh5UNvs1jd3jzR8AZl2SMOZyoyCEJOK+Y/EiR1frlmeR9PVlnlNpqxFeCHipxZ3W5pog750W5wsthe4De355ISZJsnkCsPhO5Sg7iqfPRfmt++7wPKlEyOV8KdMjUNzeKL4F+oYuMskly6bTb5THj11yG1NdciQ/llban/rX8rpuP9GQa4CYnnFcGGIM2irPOkJMFcJ+0DUKq5WWgUnqbfP1rG1e8pVgUpjLXArMDnPvqSvJwE2EuhmPGsdgV7PBOrglMdHO8cgp2+TmodRfrwcnpT2kSMiGyoevb+mrllyytmdATR5iszgibqIbyNyiv0aZA0gm2PxXbCBjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57wrucMCrw1q8RIEKhP7wXD7d1s/1TReV6LMgZYVCAA=;
 b=PzP12dppo1cdWWEk1GAWMTlDogxS5rkd7fmEb4XiX7+aT/ysyd7jW2cnF0mwgHIjAdcn7OM8HFoxO7mUjxm1R4DD5fNghL2JwfJ+BwEWTOInofwt2IKank5LXoIfN7DGouuHjBrJXHSok/F2M9cNTYCZ4kYpq8yy789GgBCDHiw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DM8PR10MB5400.namprd10.prod.outlook.com (2603:10b6:8:27::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.19; Tue, 24 Aug 2021 22:12:50 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::f9b8:94dd:1c44:cb2b]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::f9b8:94dd:1c44:cb2b%7]) with mapi id 15.20.4415.023; Tue, 24 Aug 2021
 22:12:50 +0000
Subject: Re: [kvm-unit-tests PATCH v2 6/6] x86 UEFI: Convert x86 test cases to
 PIC
To:     Varad Gautam <varadgautam@gmail.com>,
        Zixuan Wang <zixuanwang@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        Hyunwook Baek <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
References: <20210819113400.26516-1-varad.gautam@suse.com>
 <20210819113400.26516-7-varad.gautam@suse.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <2b3efdc2-2fc1-1b3f-3f07-edc4ccf41583@oracle.com>
Date:   Tue, 24 Aug 2021 15:12:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210819113400.26516-7-varad.gautam@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA9P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::17) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SA9P221CA0012.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:12:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2d97966-85be-4232-29f9-08d9674c4fb6
X-MS-TrafficTypeDiagnostic: DM8PR10MB5400:
X-Microsoft-Antispam-PRVS: <DM8PR10MB54003EB38DC7F5994ECB55DA81C59@DM8PR10MB5400.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:546;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: moWte8xpIsZlbc2VXr1XYLk8jBx0NomLtq0y/x0gH87Yd0t6vT1qgsUW/7WM/ctAJYtlUYdFXvrCb01SOOHnuTtqjUzjTmqMhr2K5Pwt+t6+fXyCsdbq/mO8XqQKfshKbF0MUw/pvsmeT8Kt0R5LiW9ITKfuBsam1CaILsoDFIoj7OxilcYus80JU4CjN3Zyw637WUpWtoILgw9keyn5IrJZXI+tUGhLr0vZ2UqJt//7/hgmayLDxsVEzGHlfVua9FUuVDkyb1LFXmEBfO3RG3urRwZaFSOKSn7md2zBcljNZR/UM/q820/lkYFV2aA+jWPeF1Wkdg/bMEfpr5p2vYUvGSdGW95/q/ifbSy8tIGbzEc4zGSTUTfS8gxTQNaUphXtsvpIM/aUkCwcMV98wZg+yskbtZvnurz47Os/p1u/340/BXWX7d6Av4mtm/GKojGbWMUsEmJfpzWCAop7t0nwIugDJDDEuWE+0IBRV0QTMUpm2MAXy29XQttTopAaanx4DM6Gf8YxgiX2zWoz4xqSotAvkJ/auRZbdrfw+bP/ALFbt+1+1CAavjQV/GDOq7yzm8/+TbPuJvs3MD+VkXL1hWvgPFVVxVAawitfR6uhSk5oKQuMJ5L1dWIuZhYMy+0PP96XK6hPR/1XHD6OHUV7nsRqS9eJXityS8ys9Mhu7UQL2jdgMX8D+Xj7g3IfD0N5CU31k5alE83r8ykSiGZsQat7zCKbGks+bXMH0Mbgj0lHY2em9emtMooeCh9E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(478600001)(2906002)(921005)(5660300002)(83380400001)(86362001)(2616005)(8676002)(31686004)(8936002)(316002)(31696002)(6506007)(36756003)(110136005)(53546011)(6486002)(66556008)(66476007)(66946007)(44832011)(6512007)(7416002)(186003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGI3aG9JSFhGOU1Hd0NrZ0FQSzVkbVI2dWExQXlQanJaYXdoTldyTWk2M0xT?=
 =?utf-8?B?QTdZOXcxK1FlekdBcHE3SHZmMFlLdndZeHU5UGx5NXVVQXdDSlJ6MzVoMWJD?=
 =?utf-8?B?d2ZWMDJjOEpHRGw1U0tkUzcwU2Q5VzdPd3VlKzFzdkdrUFVmeDhLVStMdDE0?=
 =?utf-8?B?cVRPSG5XeTk2S05NRVAwODNrejEwTzNvY2dlRkJXWldOR3FjOU5lTzVuTG1q?=
 =?utf-8?B?RkpVekJhREVVZldWWEhCcndqTithWTkwdEVUM0owL3hzZlRtby9aaUZEQ2M5?=
 =?utf-8?B?SGZMNGNtN1RJb3BMRjBrTExPWExEVzZlbFBQUG9hdEV3UmY5eDhYblE3YmpZ?=
 =?utf-8?B?eW1na0swdTZUNFMvVEEzSitWWFZBdis0UkYzWG1UMEV4ZmYxaDEwUnVMcDZO?=
 =?utf-8?B?UW5BRE1jd2ZSNkxGenFuM3JYNmFsbXVyMys5RXAxUWV6QjJhOWtzaFJDL1lQ?=
 =?utf-8?B?SGo4ZytyQThWRHZOMHphdTA4SHhlYVRVSjVzeGZtVmxNdW41emxtWEorSjk5?=
 =?utf-8?B?Vk5WRWxwT3VJZjBBT1hIQ1FIbEhHdzNZMzBQWTRCY0VKblFPcm1vdkt0dVdM?=
 =?utf-8?B?UWQ2Y0FNQ0hHcTFpRTFBOFFFdi9tQW9sckpCemhadDlJVjFxS3phUFFsMXNM?=
 =?utf-8?B?MVdyZlR2VkFJQ0lyVzdGMW5VNUd3Nm5wTWhHNDBtdTRUMmNMYkE3MjlWbFlL?=
 =?utf-8?B?Zi9SM25VcmJSSVdvQWRvTHcwYnZQMzZIVHRFRHA5Z3VlUitMdXM4SkdrckpM?=
 =?utf-8?B?SDgyOEVXZndrNFVsVy9veFhHcWNEYVdkTDBsbWNOZGdJa3BycmtIdmI2NTNJ?=
 =?utf-8?B?MWZFeE4vV3czYkc3Z2lZdk5JVDJDWWdMd0E2eGxTWU9kd1EvNjFxV1g3dVVQ?=
 =?utf-8?B?V0xoR3B2ZmtBdVJYaE9DQ3RuWGFPQjFaZmZHWmlLbUJFV0dybnFOVW1qeUdU?=
 =?utf-8?B?QWFDRjFWa0YwbEpEQzRubll2anFaYzFXVk9qMERBS0ozTitXZlFwZmRMcGlB?=
 =?utf-8?B?TjdETXdVL2RmbFc5K0pqbFU4ak5EUXFqaXN4bE9zbFUvTkpmeDgwdVJxUXoy?=
 =?utf-8?B?NDBlNzZvMGpUekwxNFE5VGM5NDFQcG92RytlSWgyMVpsKzhrYVB0aUJrekRS?=
 =?utf-8?B?YWU0R200K090VlNHSGtYZEFlUVVrNjdxaUF6UkRGQXJxTXp6VWV2OVA2UlI3?=
 =?utf-8?B?OHMwbmJraGxqcTZ1Zmw0UWNnK280d0ppM3JTTFdWVFFUTFBiTTFvcG5WejYv?=
 =?utf-8?B?QVNyamVvVnF0cHlMQWZGVmYxY2U3cTFQdE5HYU4vUzhaRzFXK1ZMTjBFVTdH?=
 =?utf-8?B?UUt1VC80QVJ6T3VPYThySTJrOGxXQ1RJMkhDVjJOdC9qdnNkVm1QWWRlZ05z?=
 =?utf-8?B?WW9QYVQ4MEljait2eEU3U2JUejZhTjV1bllFVENJd0dVWE9UcDhHaHFEZ2tJ?=
 =?utf-8?B?ait3dVF5cTI1bVRmMmMyeUtwa1pCUThzdm0vWTB1VzlyK1FUUnFDeGJZNVNN?=
 =?utf-8?B?bkVuMjJsaEM4bnZPZUtzdWNxSkh3VGUyd05NVDFHb2k5TlhHTXcybFFqVk1Y?=
 =?utf-8?B?bXQvZnRVeGd4enpSSk9WM1E2anBpT0ltNWw4RmhXQVVLbXU2d0FJRXRvblFB?=
 =?utf-8?B?T2tRSU9HMFZ4ZUsxd0xtNXEzVjdFQ0JnWEFmbnFPZmNvMHEvdzQyU1VPdzBJ?=
 =?utf-8?B?YVp3dGVYMDVKVHh6VWpMY052ZUFaQjVJT1hQTFFFNHpZVklZOFpMSVJXNFJ1?=
 =?utf-8?B?WFZpZmF1N1VOMFc3N09vUUFoVUpNbGhXVHhZMmM5UHJ2eFA0TDNTdmFFNFZ0?=
 =?utf-8?B?M1pmc1FNMnJDVFNnZXRBdz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2d97966-85be-4232-29f9-08d9674c4fb6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:12:50.3408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBXhcpsc1lSXFdZVOiaTI5xeRBCubZ6/eTgqUJwmSumDWUjkLPjmgVmNZcmCkbsKLF0s2CPkxxoaF6FXZrZLGYHX1Uz1Z7ZJG1nbkdrBDvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5400
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108240139
X-Proofpoint-ORIG-GUID: CAvzHlXsC7XVxePI7AvL-uFimIYUNqZF
X-Proofpoint-GUID: CAvzHlXsC7XVxePI7AvL-uFimIYUNqZF
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/19/21 4:34 AM, Varad Gautam wrote:
> From: Zixuan Wang <zixuanwang@google.com>
>
> UEFI loads EFI applications to dynamic runtime addresses, so it requires
> all applications to be compiled as PIC (position independent code). PIC
> does not allow the usage of compile time absolute address.
>
> This commit converts multiple x86 test cases to PIC so they can compile
> and run in UEFI:
>
> - x86/cet.efi
>
> - x86/emulator.c: x86/emulator.c depends on lib/x86/usermode.c. But
> usermode.c contains non-PIC inline assembly code and thus blocks the
> compilation with GNU-EFI. This commit converts lib/x86/usermode.c and
> x86/emulator.c to PIC, so x86/emulator.c can compile and run in UEFI.
>
> - x86/vmware_backdoors.c: it depends on lib/x86/usermode.c and now works
> without modifications
>
> - x86/eventinj.c
>
> - x86/smap.c
>
> - x86/access.c
>
> - x86/umip.c


I am wondering if these changes can be part of patch# 1 instead of being 
a separate patch.

>
> Signed-off-by: Zixuan Wang <zixuanwang@google.com>
> ---
>   lib/x86/usermode.c  |  3 ++-
>   x86/Makefile.common |  7 ++++---
>   x86/Makefile.x86_64 |  5 +++--
>   x86/access.c        |  6 +++---
>   x86/cet.c           |  8 +++++---
>   x86/emulator.c      |  5 +++--
>   x86/eventinj.c      |  6 ++++--
>   x86/smap.c          |  8 ++++----
>   x86/umip.c          | 10 +++++++---
>   9 files changed, 35 insertions(+), 23 deletions(-)
>
> diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
> index f032523..c550545 100644
> --- a/lib/x86/usermode.c
> +++ b/lib/x86/usermode.c
> @@ -58,7 +58,8 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
>   			"pushq %[user_stack_top]\n\t"
>   			"pushfq\n\t"
>   			"pushq %[user_cs]\n\t"
> -			"pushq $user_mode\n\t"
> +			"lea user_mode(%%rip), %%rdx\n\t"
> +			"pushq %%rdx\n\t"
>   			"iretq\n"
>   
>   			"user_mode:\n\t"
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index ca33e8e..a91fd4c 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -61,8 +61,8 @@ FLATLIBS = lib/libcflat.a
>   		    -j .reloc -j .init --target efi-app-x86_64 $*.so $@
>   	@chmod a-x $@
>   
> -tests-flatonly = $(TEST_DIR)/realmode.$(out) $(TEST_DIR)/eventinj.$(out)		\
> -		$(TEST_DIR)/smap.$(out) $(TEST_DIR)/umip.$(out)
> +tests-flatonly = $(TEST_DIR)/realmode.$(out)						\
> +		$(TEST_DIR)/smap.$(out)
>   
>   tests-common = $(TEST_DIR)/vmexit.$(out) $(TEST_DIR)/tsc.$(out)				\
>   		$(TEST_DIR)/smptest.$(out) $(TEST_DIR)/msr.$(out)			\
> @@ -72,7 +72,8 @@ tests-common = $(TEST_DIR)/vmexit.$(out) $(TEST_DIR)/tsc.$(out)				\
>   		$(TEST_DIR)/tsc_adjust.$(out) $(TEST_DIR)/asyncpf.$(out)		\
>   		$(TEST_DIR)/init.$(out) $(TEST_DIR)/hyperv_synic.$(out)			\
>   		$(TEST_DIR)/hyperv_stimer.$(out) $(TEST_DIR)/hyperv_connections.$(out)	\
> -		$(TEST_DIR)/tsx-ctrl.$(out)
> +		$(TEST_DIR)/tsx-ctrl.$(out)						\
> +		$(TEST_DIR)/eventinj.$(out) $(TEST_DIR)/umip.$(out)
>   
>   ifneq ($(CONFIG_EFI),y)
>   tests-common += $(tests-flatonly)
> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
> index f6c7bd7..e8843aa 100644
> --- a/x86/Makefile.x86_64
> +++ b/x86/Makefile.x86_64
> @@ -18,9 +18,8 @@ cflatobjs += lib/x86/intel-iommu.o
>   cflatobjs += lib/x86/usermode.o
>   
>   # Tests that have relocation / PIC problems and need more attention for EFI.
> -tests_flatonly = $(TEST_DIR)/access.$(out) $(TEST_DIR)/emulator.$(out) \
> +tests_flatonly = $(TEST_DIR)/access.$(out) \
>   	$(TEST_DIR)/svm.$(out) $(TEST_DIR)/vmx.$(out) \
> -	$(TEST_DIR)/vmware_backdoors.$(out)
>   
>   tests = $(TEST_DIR)/apic.$(out) $(TEST_DIR)/idt_test.$(out) \
>   	  $(TEST_DIR)/xsave.$(out) $(TEST_DIR)/rmap_chain.$(out) \
> @@ -33,6 +32,8 @@ tests += $(TEST_DIR)/intel-iommu.$(out)
>   tests += $(TEST_DIR)/rdpru.$(out)
>   tests += $(TEST_DIR)/pks.$(out)
>   tests += $(TEST_DIR)/pmu_lbr.$(out)
> +tests += $(TEST_DIR)/emulator.$(out)
> +tests += $(TEST_DIR)/vmware_backdoors.$(out)
>   
>   ifneq ($(fcf_protection_full),)
>   tests_flatonly += $(TEST_DIR)/cet.$(out)
> diff --git a/x86/access.c b/x86/access.c
> index 4725bbd..d0c84ca 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -700,7 +700,7 @@ static int ac_test_do_access(ac_test_t *at)
>   
>       if (F(AC_ACCESS_TWICE)) {
>   	asm volatile (
> -	    "mov $fixed2, %%rsi \n\t"
> +	    "lea fixed2(%%rip), %%rsi \n\t"
>   	    "mov (%[addr]), %[reg] \n\t"
>   	    "fixed2:"
>   	    : [reg]"=r"(r), [fault]"=a"(fault), "=b"(e)
> @@ -710,7 +710,7 @@ static int ac_test_do_access(ac_test_t *at)
>   	fault = 0;
>       }
>   
> -    asm volatile ("mov $fixed1, %%rsi \n\t"
> +    asm volatile ("lea fixed1(%%rip), %%rsi \n\t"
>   		  "mov %%rsp, %%rdx \n\t"
>   		  "cmp $0, %[user] \n\t"
>   		  "jz do_access \n\t"
> @@ -719,7 +719,7 @@ static int ac_test_do_access(ac_test_t *at)
>   		  "pushq %[user_stack_top] \n\t"
>   		  "pushfq \n\t"
>   		  "pushq %[user_cs] \n\t"
> -		  "pushq $do_access \n\t"
> +		  "lea do_access(%%rip), %%rsi; pushq %%rsi; lea fixed1(%%rip), %%rsi\n\t"
>   		  "iretq \n"
>   		  "do_access: \n\t"
>   		  "cmp $0, %[fetch] \n\t"
> diff --git a/x86/cet.c b/x86/cet.c
> index a21577a..a4b79cb 100644
> --- a/x86/cet.c
> +++ b/x86/cet.c
> @@ -52,7 +52,7 @@ static u64 cet_ibt_func(void)
>   	printf("No endbr64 instruction at jmp target, this triggers #CP...\n");
>   	asm volatile ("movq $2, %rcx\n"
>   		      "dec %rcx\n"
> -		      "leaq 2f, %rax\n"
> +		      "leaq 2f(%rip), %rax\n"
>   		      "jmp *%rax \n"
>   		      "2:\n"
>   		      "dec %rcx\n");
> @@ -67,7 +67,8 @@ void test_func(void) {
>   			"pushq %[user_stack_top]\n\t"
>   			"pushfq\n\t"
>   			"pushq %[user_cs]\n\t"
> -			"pushq $user_mode\n\t"
> +			"lea user_mode(%%rip), %%rax\n\t"
> +			"pushq %%rax\n\t"
>   			"iretq\n"
>   
>   			"user_mode:\n\t"
> @@ -77,7 +78,8 @@ void test_func(void) {
>   			[user_ds]"i"(USER_DS),
>   			[user_cs]"i"(USER_CS),
>   			[user_stack_top]"r"(user_stack +
> -					sizeof(user_stack)));
> +					sizeof(user_stack))
> +			: "rax");
>   }
>   
>   #define SAVE_REGS() \
> diff --git a/x86/emulator.c b/x86/emulator.c
> index 9fda1a0..4d2de24 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -262,12 +262,13 @@ static void test_pop(void *mem)
>   
>   	asm volatile("mov %%rsp, %[tmp] \n\t"
>   		     "mov %[stack_top], %%rsp \n\t"
> -		     "push $1f \n\t"
> +		     "lea 1f(%%rip), %%rax \n\t"
> +		     "push %%rax \n\t"
>   		     "ret \n\t"
>   		     "2: jmp 2b \n\t"
>   		     "1: mov %[tmp], %%rsp"
>   		     : [tmp]"=&r"(tmp) : [stack_top]"r"(stack_top)
> -		     : "memory");
> +		     : "memory", "rax");
>   	report(1, "ret");
>   
>   	stack_top[-1] = 0x778899;
> diff --git a/x86/eventinj.c b/x86/eventinj.c
> index 46593c9..0cd68e8 100644
> --- a/x86/eventinj.c
> +++ b/x86/eventinj.c
> @@ -155,9 +155,11 @@ asm("do_iret:"
>   	"pushf"W" \n\t"
>   	"mov %cs, %ecx \n\t"
>   	"push"W" %"R "cx \n\t"
> -	"push"W" $2f \n\t"
> +	"lea"W" 2f(%"R "ip), %"R "bx \n\t"
> +	"push"W" %"R "bx \n\t"
>   
> -	"cmpb $0, no_test_device\n\t"	// see if need to flush
> +	"mov no_test_device(%"R "ip), %bl \n\t"
> +	"cmpb $0, %bl\n\t"		// see if need to flush
>   	"jnz 1f\n\t"
>   	"outl %eax, $0xe4 \n\t"		// flush page
>   	"1: \n\t"
> diff --git a/x86/smap.c b/x86/smap.c
> index ac2c8d5..b3ee16f 100644
> --- a/x86/smap.c
> +++ b/x86/smap.c
> @@ -161,10 +161,10 @@ int main(int ac, char **av)
>   		test = -1;
>   		asm("or $(" xstr(USER_BASE) "), %"R "sp \n"
>   		    "push $44 \n "
> -		    "decl test\n"
> +		    "decl test(%"R "ip)\n"
>   		    "and $~(" xstr(USER_BASE) "), %"R "sp \n"
>   		    "pop %"R "ax\n"
> -		    "movl %eax, test");
> +		    "movl %eax, test(%"R "ip)");
>   		report(pf_count == 0 && test == 44,
>   		       "write to user stack with AC=1");
>   
> @@ -173,10 +173,10 @@ int main(int ac, char **av)
>   		test = -1;
>   		asm("or $(" xstr(USER_BASE) "), %"R "sp \n"
>   		    "push $45 \n "
> -		    "decl test\n"
> +		    "decl test(%"R "ip)\n"
>   		    "and $~(" xstr(USER_BASE) "), %"R "sp \n"
>   		    "pop %"R "ax\n"
> -		    "movl %eax, test");
> +		    "movl %eax, test(%"R "ip)");
>   		report(pf_count == 1 && test == 45 && save == -1,
>   		       "write to user stack with AC=0");
>   
> diff --git a/x86/umip.c b/x86/umip.c
> index c5700b3..8b4e798 100644
> --- a/x86/umip.c
> +++ b/x86/umip.c
> @@ -23,7 +23,10 @@ static void gp_handler(struct ex_regs *regs)
>   
>   #define GP_ASM(stmt, in, clobber)                  \
>       asm volatile (                                 \
> -          "mov" W " $1f, %[expected_rip]\n\t"      \
> +          "push" W " %%" R "ax\n\t"                \
> +	  "lea 1f(%%" R "ip), %%" R "ax\n\t"       \
> +          "mov %%" R "ax, %[expected_rip]\n\t"     \
> +          "pop" W " %%" R "ax\n\t"                 \
>             "movl $2f-1f, %[skip_count]\n\t"         \
>             "1: " stmt "\n\t"                        \
>             "2: "                                    \
> @@ -130,7 +133,8 @@ static int do_ring3(void (*fn)(const char *), const char *arg)
>   		  "push" W " %%" R "dx \n\t"
>   		  "pushf" W "\n\t"
>   		  "push" W " %[user_cs] \n\t"
> -		  "push" W " $1f \n\t"
> +		  "lea 1f(%%" R "ip), %%" R "dx \n\t"
> +		  "push" W " %%" R "dx \n\t"
>   		  "iret" W "\n"
>   		  "1: \n\t"
>   		  "push %%" R "cx\n\t"   /* save kernel SP */
> @@ -144,7 +148,7 @@ static int do_ring3(void (*fn)(const char *), const char *arg)
>   #endif
>   
>   		  "pop %%" R "cx\n\t"
> -		  "mov $1f, %%" R "dx\n\t"
> +		  "lea 1f(%%" R "ip), %%" R "dx\n\t"
>   		  "int %[kernel_entry_vector]\n\t"
>   		  ".section .text.entry \n\t"
>   		  "kernel_entry: \n\t"

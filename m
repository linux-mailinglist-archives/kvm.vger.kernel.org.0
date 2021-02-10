Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F721317493
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhBJXlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:41:13 -0500
Received: from mail-co1nam11on2059.outbound.protection.outlook.com ([40.107.220.59]:12736
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233800AbhBJXlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:41:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bocXyi5cV1LiiCBY0lg0rhojIFllvbsHcdkGVxh3pgBEor+PB6U5DpmzyjXAe8gzkD7wdMnMjBVer8TuCXKH4Z23H5yagAcNlS3Zw/1kpEIpxQFtEM45nRVnwdFDWOTcb6SwW8ewhekUSIy3HViled9m5SI0YLle12N5l8zul7htTKzmNvvj4WyyGAAOAsRraAW36+M1uNqYszF+OVlwPtuLY9Etqj8Pcirdwn0ET3LImPLML5Kyq26VgFUJsmkzUym/s7p5dysCNsnkVOgunUd1LEQ864bgP7i9COTa5C8hCzJQQMg3V0w0j3xxnBnZuuciMDg69MFryOJQ2tPu4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FST/A9InmLQ7bHsC1xQ6tA1QKAnAIKfFnpDfVvx4Px4=;
 b=aOAzWr8ch3Js+7Ct1eD0sp6jJ4QyrlVXEkt5xdY/Zl25poMLyzcwk0038DVdR4ap/egT1fA8CFJjZ19f3Y0EvgQ5jzDS6PTVOTuT3OaMmgYt+VMr9HOxUkRfygKkA5DOej44DVadDZuhb5Ba9tlgiIN1Ps4Ba2DbCc6iKvAQszY/OMuyezf8/WG1M+KNRGJU5Sd8aT2ZV+rCbEKca8kzt+65SUOya9sT//IFyI7BFH75trbvMzBTOw7v7gZj/TavYGGQTsrLoLP5lA0ElPO+IZGhDL81FIHIO74a9l2ZpD31d6DBuAmhZMIbKhc0CZiQTD+HGHCcBSrljKfHVzDOlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FST/A9InmLQ7bHsC1xQ6tA1QKAnAIKfFnpDfVvx4Px4=;
 b=OCYB11l+Yk1/laXyUO2BnzMzl9CTczXnLFonq/yzjBoGB1sKLHoFH2H2petku9zTL3qoZ7HOl/6GKZoxrwc2FjBJFUcsU7ArNEPHZUTqBjJX+qEYrcZIxavqCAdXzYSgnX/BIKzHkfdQKSVbhTO9iPRTT8klmrlNunS++NjyuxE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB4686.namprd12.prod.outlook.com (2603:10b6:805:d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 10 Feb
 2021 23:40:12 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 23:40:12 +0000
From:   Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v4 0/2] x86: Add the feature Virtual SPEC_CTRL
To:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de
Cc:     fenghua.yu@intel.com, tony.luck@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org, thomas.lendacky@amd.com, peterz@infradead.org,
        seanjc@google.com, joro@8bytes.org, x86@kernel.org,
        kyung.min.park@intel.com, linux-kernel@vger.kernel.org,
        krish.sadhukhan@oracle.com, hpa@zytor.com, mgross@linux.intel.com,
        vkuznets@redhat.com, kim.phillips@amd.com, wei.huang2@amd.com,
        jmattson@google.com
References: <161188083424.28787.9510741752032213167.stgit@bmoger-ubuntu>
Message-ID: <da68dc9d-0c9b-a3e1-0e95-ea86024fadee@amd.com>
Date:   Wed, 10 Feb 2021 17:40:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <161188083424.28787.9510741752032213167.stgit@bmoger-ubuntu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0072.prod.exchangelabs.com (2603:10b6:800::40) To
 SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN2PR01CA0072.prod.exchangelabs.com (2603:10b6:800::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.28 via Frontend Transport; Wed, 10 Feb 2021 23:40:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f33c9f79-1a69-43e4-8188-08d8ce1d351a
X-MS-TrafficTypeDiagnostic: SN6PR12MB4686:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4686D578399EA8B9DF89CE57958D9@SN6PR12MB4686.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0XU0F616L2qphxlASL/iT6k5IsJYn/0mWQ2Nx7SPpLQyuKthpktI+TxuCfU5F9rcsNSUKq7RxJ5nAef45SBxcL3FHGB6xGpz2v2IW4DZH1Euv4VOQcDb1+Rla0WDSXf0cvyMcKb6cSsYBjgv0+KBgX/XsAOq6SZExz97/1EzyeMxl1lN4j/XBr3RaBqlA9kmMWRC7oSokpkA/FNo7NK8fVU/qkBeDpRZrP6QccN2+jw84rsRaz38yK0gxjWgIwjRL2MxAIX700WJCL6/TaXWP1F5tQUIqzySkWfSqp3Ckqt2QCO3O6PH1CLUVAnFxsq0FsVFHv8AcsuOwWUdv16aNlIl53Sbj8Y1gzoFpdc5htX80t73siX8Mw0Z4QYsdscTHYNQwdGaF6zHjkKr176S/kpcSLeqinKqKNqriT6qH+PPdjG7c0IY0YxobjRszp7qcPuWvfkNJrSIUV65TgdSID4wFAjp/GqPO7OC9318bR0keXwuP+PnKmykaHlZFrds8o33d6yRMNn44giPxBPIZC3UJRs0JS55pIE6+fC61jkhPlifT5bIbpakZgb053qDvSw8DIW+RAJGgeNu/xfwrq0aQvAm3Y9Pyb0KZ7oGcbnLg5o2j4CxjtmXu97xdwAsZyTYu4aXJm7gy+Yp09OFCeBVaB62BmrRJvVFLQjndAM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(136003)(396003)(366004)(2906002)(4326008)(8676002)(31686004)(44832011)(7416002)(53546011)(66556008)(83380400001)(66476007)(2616005)(956004)(5660300002)(26005)(478600001)(52116002)(86362001)(8936002)(6486002)(66946007)(316002)(16576012)(186003)(31696002)(16526019)(966005)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bWk3YzY5UVpBQTRsR2hJMzh4dDI5UUozQyt5ZHo4NThtRVFFRm9LWDI4aWlN?=
 =?utf-8?B?Qm51SDAwKzVVbDNCd0FYczBYTEVpVk5ReUVLWXZaS0tPZnRjb0ZHQUQyY2VL?=
 =?utf-8?B?QW52MVdpS2lpbkZ3ekZUenk5aE9SMnJRSGduZHppNkNwYVlnazJDL3NweHNO?=
 =?utf-8?B?Umx2K0JySXlVMTNNYnlRaHFqK083WWVQWHFvZU1rV01LbkpwU2J1VTZ3Zmxl?=
 =?utf-8?B?amlVZVZBVVJ6R1VwTUd2U3k5aG5nSzA2U2FkbkdPNHZoSm1VdmxPSHBvZEpn?=
 =?utf-8?B?VTdFRVI4Qi9OSEN4T21PQjVyTkJyVGJrd0szdHNVN09qL0ZvMlpnVTlCc0xU?=
 =?utf-8?B?WEJrSVEzazBueVpOd1JYN0VrNTFZS3VnQU05QTZlNGl5aC9BMTJQeVZGdHVY?=
 =?utf-8?B?MjRudnlFUnAzOVQ4NUl2TXFCcWZ5VjZPWmpkMytWL0QyK1RTK0pKYXR0dU1p?=
 =?utf-8?B?MkNRNFBaRG4yN085bmx2Tmd5TmN1bGZWTVVXblhka1V3MUNiNFpwR25wUFFC?=
 =?utf-8?B?QldLN2JhbzJRSE1UdG1MWm9SM1dDMnJtM3hiU0xXS0lnSlVHb1RHTXJ0UHFL?=
 =?utf-8?B?dXJONUE4RHM3Ti9VbmNXVDFud01yRDhneWpDbi9QeVdNcERXei81bXVZRTBY?=
 =?utf-8?B?dTVyWEJBMTdzRGV2Sk1lMEFMbUp0WXNYK01hMkJ2WU14ZWNDM24yL1lXS2t6?=
 =?utf-8?B?c2h1enp4MVlCaHBuYUVHVU5uRGJCUk54dDVDKzAzNTlVYk9RTUlhMURnTU4r?=
 =?utf-8?B?ZnozOWU2bkRjZDdvY1EyRXdTa0gyTzMzRi9PR3NpeFd1TEgyd0s0SWxpRUN0?=
 =?utf-8?B?eGVSZjJ3WEc5cWNXRXRxTEM3VW82dzEyRE02bHloc3M4Q2o1d2VxcHc2cU1r?=
 =?utf-8?B?U2pVVVB3ZUcrT1diM0F3QkwyZmIrZmdCNVlUZm11b2E5K3dNamJiUXVId1Nh?=
 =?utf-8?B?a1VLcUJPTXZxQ0ZVai9LMkdqK3kwRTNzWUh5dzVucEs2T3JkK1hmZ3hiZXlH?=
 =?utf-8?B?ZVo1YnhnczJOVE1XZlZYdW5DRE9LN0Z6SjZUR3h2NmwzeDROOG9tL1p2V01P?=
 =?utf-8?B?cGQ3Zmk3UDVibG5leWRMbkNlNmMyRkh1UUhBaUpxSUl3anRqV1dGMFhaQytV?=
 =?utf-8?B?NVJzb2kybzFxemxOcWVYeUZPQzI2eStxekFxZjRlT1JkUzJXd0JnTW9UT3Nq?=
 =?utf-8?B?Ukx4WXBuankrU2duUVdpL0xGdEliRmlCbWsrVXR0d1huZzNDQUIyVFU2ZjZa?=
 =?utf-8?B?R3huNVh1R1luSXAxN1JkNWV0WXBKZGkxLy9MZk55YzZ4a0NaQ2pWVXVzUTV4?=
 =?utf-8?B?QWxjZ2lkeVd6eXhkZkNyR1lOcVRRZ0pmMlZNWFBIVHRPdmhEUUd6cisxTGZ3?=
 =?utf-8?B?R1pIYkpsZlZnWGIwcENJZ290d3c4WVA0bS9UQ3hqRmcvdTBldGJGY2JSNnpJ?=
 =?utf-8?B?K0pYcUI0R2ZsQ2dZaGxRRnV0bFVrUVpVN2NZMlhocjhrNU5neUNTODM3VlJq?=
 =?utf-8?B?bDQxYThpZGZGZmwzUXZwTlpvRFJoVnhuUkdDV1NrQVdhaEFXUHFJWWsyV0FO?=
 =?utf-8?B?KytrOEZhN05OT29NZjhpakNrbXFpb3pHdjI4azZHZnZmZVoxeDRtOUhFTVNi?=
 =?utf-8?B?NFRPdzJEMW1LbjljZTU4QlFNT0IzWWhqcTRiWS9KTzRBNUZ5dTROSThPeHJx?=
 =?utf-8?B?Nm1Wckx5TktYaWowbGZHbVFKTG4wMXp2MUpRc3NNdHZTOU9iMkNSTzU0dXFH?=
 =?utf-8?Q?G/uKqdfjaOgRJ9PoV7GfuVDFiDcnr4Z40Bh3NZG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f33c9f79-1a69-43e4-8188-08d8ce1d351a
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 23:40:12.0144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q/3a7NTgTSXReF2tr4i8s0JdWyWRvdrxlwOslDcAbHLOdwrzTVQBwIwdCZBM+HS3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4686
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo/Sean,
Any comments on these patches?
Thanks
Babu

On 1/28/21 6:43 PM, Babu Moger wrote:
> Newer AMD processors have a feature to virtualize the use of the
> SPEC_CTRL MSR on the guest. The series adds the feature support
> and enables the feature on SVM.
> ---
> v4:
>   1. Taken care of comments from Sean Christopherson.
>      a. Updated svm_set_msr/svm_get_msr to read/write the spec_ctrl value
>         directly from save spec_ctrl.
>      b. Disabled the msr_interception in init_vmcb when V_SPEC_CTRL is
>         present.
>      c. Added the save restore for nested vm. Also tested to make sure
>         the nested SPEC_CTRL settings properly saved and restored between
>         L2 and L1 guests.
>   2. Added the kvm-unit-tests to verify that. Sent those patches separately.
> 
> v3:
>   1. Taken care of recent changes in vmcb_save_area. Needed to adjust the save
>      area spec_ctrl definition.
>   2. Taken care of few comments from Tom.
>      a. Initialised the save area spec_ctrl in case of SEV-ES.
>      b. Removed the changes in svm_get_msr/svm_set_msr.
>      c. Reverted the changes to disable the msr interception to avoid compatibility
>         issue.
>   3. Updated the patch #1 with Acked-by from Boris.
>   
> v2:
>   NOTE: This is not final yet. Sending out the patches to make
>   sure I captured all the comments correctly.
> 
>   1. Most of the changes are related to Jim and Sean's feedback.
>   2. Improved the description of patch #2.
>   3. Updated the vmcb save area's guest spec_ctrl value(offset 0x2E0)
>      properly. Initialized during init_vmcb and svm_set_msr and
>      returned the value from save area for svm_get_msr.
>   4. As Jim commented, transferred the value into the VMCB prior
>      to VMRUN and out of the VMCB after #VMEXIT.
>   5. Added kvm-unit-test to detect the SPEC CTRL feature.
>      https://lore.kernel.org/kvm/160865324865.19910.5159218511905134908.stgit@bmoger-ubuntu/
>   6. Sean mantioned of renaming MSR_AMD64_VIRT_SPEC_CTRL. But, it might
>      create even more confusion, so dropped the idea for now.
> 
> v3: https://lore.kernel.org/kvm/161073115461.13848.18035972823733547803.stgit@bmoger-ubuntu/
> v2: https://lore.kernel.org/kvm/160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu/
> v1: https://lore.kernel.org/kvm/160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu/
> 
> Babu Moger (2):
>       x86/cpufeatures: Add the Virtual SPEC_CTRL feature
>       KVM: SVM: Add support for Virtual SPEC_CTRL
> 
> 
>  arch/x86/include/asm/cpufeatures.h |    1 +
>  arch/x86/include/asm/svm.h         |    4 +++-
>  arch/x86/kvm/svm/nested.c          |    2 ++
>  arch/x86/kvm/svm/svm.c             |   27 ++++++++++++++++++++++-----
>  4 files changed, 28 insertions(+), 6 deletions(-)
> 
> --
> 

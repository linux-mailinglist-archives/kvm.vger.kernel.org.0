Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6649077CF9A
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 17:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbjHOPvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 11:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236263AbjHOPvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 11:51:14 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC73E10C6;
        Tue, 15 Aug 2023 08:51:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtDQYYbaDrI11lF1Hecg2gQ9Y8febEF0SJPRz+FeCMQfO2tznbDc3Mkg21N+sVlhXIANUl7b9ZjZvs5sLBFhegCjv/OU4S3uuqP0Ljvbvapcyy6/Yd2rah66WeojMhKBBuLv8OCGmJ0PCRHcLDlGA0F52/gdfMzu94OZB2cRrY2MMzIpYZ+8qBF8ol+Gt1Tbl03MtX//itzyuuoxPKff+J9ik/CFEAk+w2hR8h5jppL1dT50R/CZ4gAX4Lj13te6XFbWpDdZCyob0Kc3G3WDP8JLBrIF7e6JK/JzBuovDdHOcqJp+kw/u5uXWXgIBdykO4zycBxVjoB2luKN3HrwmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=slZsflMliJ7MlBj9odh5Rshma0VgD/8+rE8oxMwjTbw=;
 b=OHpCpru2af7rJis23OamZhlZqbhm0E57ougIrUTrydjCsAr8nvd3xYtsfI/49a9b0+VSdBGvpYwIaw9RiWy8qUa4sG/JvxcoMmxfeWQojdMy05ZjJs9d0zkS2SJOxL9P1KaKReQakw4bukWGHfjl/x15h2Zx6oSWOWqpGdF/6Kqd0GvmnATWyX6xlGQLeNr193GbA2WJg6kcqYpLyqZIt9VxKsrE1af4CgDpoO7UP47FiKVDI8jGtds7Ms6NNiWvcRH8Zgy1rTWHZod3ttVVoiLdg0h7mXim24FxDAjigeaelTFKqrtUkvP4OF3/gQKQ1RgQ/KFimJI8icGrnzQKKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=slZsflMliJ7MlBj9odh5Rshma0VgD/8+rE8oxMwjTbw=;
 b=VEnvFreXDDAZNtFrI/7UMmB2P7Mo7UKRRX2yiCZwJag2mDzRfPvjn+gupv44T4QNTajxws84v2mfAhDPsM9f1e/2w20DC5TM9d1Btu62gtByFtltWsTlrVDlg/xIyBoBbSe2btYdd+okYXCKYMvjmZwQWkhoInB0NdxZE6GdZ6w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SA1PR12MB5616.namprd12.prod.outlook.com (2603:10b6:806:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Tue, 15 Aug
 2023 15:51:09 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6678.025; Tue, 15 Aug 2023
 15:51:09 +0000
Message-ID: <930c4030-9581-cded-9349-c4486749c7d7@amd.com>
Date:   Tue, 15 Aug 2023 10:51:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 2/3] KVM: SEV: only access GHCB fields once
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com, theflow@google.com,
        vkuznets@redhat.com, stable@vger.kernel.org
References: <20230804173355.51753-1-pbonzini@redhat.com>
 <20230804173355.51753-3-pbonzini@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230804173355.51753-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0154.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::27) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: b3696f55-6f86-4ee8-f2c7-08db9da77145
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F5HVrMNgdHd2rHXPTBf3bx+LwkkXsvDD87aQNpWN/UcsM6rugn3o3hRsT3eZNVGE4YDG02wKLW8ZJWEe3YzqpmNLijqxIELmItMkU3mFGuK22OBdsl+/L5x+Cbv80oj7CH6OJEFa5LLXzRjDOQUliaLFUArPzahEj8DVcWGjnqoZe+1h1eUdNtuif1UnORElVvdPYEB1wCLplYXcODNoOo05BhaXtgTg96V8utW3T1vzvg5A4I+WNn+7SwCRYDTAHR5EAw7sPVVW496YFGA4X1iN9GKQHjnuxQhfe4sb07nEidM0rpKEO+Bnac0J/5HbbRgRECaj21PUMhNBwhlRUFnNhZ6mFBAuLSkDKyHi06XBRR58lH7parrVZgLycXKLu6M3ZQ2AE0QT/dVAUk1C+NeIbe2z9qsMN0SrxWz/1OEswGTYwL+fbynuUt74DTqkYSod0WuOl3w9Iom54fXtJoMioT6RpNzCPBmyTO+cFb+4dG+dA/XFqgJLerSbLgkeeDGy7MLdcxy3iUCy7RdD2+V8unpDxYbpAAeCTwFg9sf3Fh2UFBNDEMpf1hg6CdpirdRVlAVfBkQlXXdAT06P+1tFjBPdaKt5xjom5WVQz7ug1Uz/VLiiU5AE4o9JJc5KgnzthqlZh3xTh84OnoexTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199024)(1800799009)(186009)(2616005)(38100700002)(2906002)(83380400001)(8676002)(31696002)(6506007)(31686004)(86362001)(26005)(5660300002)(66556008)(6512007)(66946007)(316002)(66476007)(6486002)(478600001)(53546011)(8936002)(41300700001)(4326008)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEkrcjZYbDg2U1YyOVplalJSNllNdGZlWjlvRTA1SEtTNERZYzdFeUx5eTIx?=
 =?utf-8?B?OFVpNFVGbG5XWUZXcXB0N3ZqOW1JM1htZ2lxTkhlaTFVSGc5d0F4SFgvUG5U?=
 =?utf-8?B?K3NVNzQvalhFTDFMaVNUOTgySEx5UkJvSS9EVmN5Vm5iRVh3VFpPdGRZMGcr?=
 =?utf-8?B?SURrcjVWek45WjVsVWowQ25DbXhtZlFrTkVuakNTYXFWVGpWWWlRU01rMTYy?=
 =?utf-8?B?ZkRBdE9NREVBQjh1WUFWN1FNcDJjclIyY1lYbmR1aCtSdi9yNmVidkdUOEc4?=
 =?utf-8?B?VHNkbWRsUUE0SmtuUkdjbnR3QlZxaDliWklUMFpxalFxRXhwSldabXBySlVY?=
 =?utf-8?B?UW1FT2FMZUtScDk4cWRoOUVVdE5IakE4c0UyM2FKajZ0YXE1REZsWDN4aVNo?=
 =?utf-8?B?cDJKMFF3cUdMZ2tEMGtNNUlEMVVKTXZTb3JQUEQzUmg1YWtqck8waEtCTjUv?=
 =?utf-8?B?blRNbHp4ckhlV1Zzd0tjcmFBQ05tTDJVWjRSRFZqTlB1TlViM3g5VWF6UUJS?=
 =?utf-8?B?aFVIUHpYNENjYlFtRG1BODJscFFXY2VxVVRmblpwQklTek5RWEhiSlRVbXhT?=
 =?utf-8?B?SmZvMUwwRE1NRFFpOVVpN2Y0V0FNVXNRVnI0RmdRbkpGcVNjL1BqaU9tbzV5?=
 =?utf-8?B?aG1wZ0VWNWdKYmRLYUhGenhzUmlMUHU5eTI4bklPZURUaXgzT1dyc01XdklU?=
 =?utf-8?B?K3RmZ0RhUFF6R3N3WEVlNGhCN2c0VmVISkhqZzNVOVRCd0RWbnN3ekNPZnpq?=
 =?utf-8?B?QXd3MHdqVTA3ZWdndmxvVnF1b3hDMGkyYXErNE85U0c4YnBVaElBQmVsb2cx?=
 =?utf-8?B?ZVJzZzlwdkFtcEVTU0FjQ0FKN0dIbzM0SFpCQlRpK25BcDZNRHBxQnZlZ2lp?=
 =?utf-8?B?eFJaMjQrVVhOQ3QwOGtXa29MdXR4MmdlMzJ6bGtNb3NNQmF0SVhWby8yby9l?=
 =?utf-8?B?KzI2MWNZZXJBT1N1UlkvRWtqdXpLVWd1VS9LUVFjSkdBUmRFa0s2MFdBQytT?=
 =?utf-8?B?b3lVTVh4YllMUGFTZlZCeVA2ZGpEbWFxUi9JRy9YVU01c3k4UktJUnZjektq?=
 =?utf-8?B?cEdBQnB3ZVVIMnZIeXdpVTZpWXI2R1NoU0NjaUNWZC9WU09iT2d0Mk5OTHlt?=
 =?utf-8?B?RHlQYTdpdnVmRFJ2OHdVZXkwbXJtbHNlaU84eWxORVYvU1B6WUxEclQxcWpH?=
 =?utf-8?B?TExsdzUyd3Bqb01qaXpVUVhIRXNnK3hwV25pQTBIT001VnBvWGxjRjJJYkwx?=
 =?utf-8?B?eEJ5L3pJUnRhbUdSQXNLdzU4VHNwaGNiMzhUTWd0SXcxSkNUb1pGTTlDYk4x?=
 =?utf-8?B?YXdHdnNXZEZYWnRZYmtha1VBZ3RUREZvUXNLSmJPZTg1VGM3eTJFbWtYZkdk?=
 =?utf-8?B?M1RTSGx3dzhLZTVzZ3U4enAzUW5ZTkpGU2I1TDNzbjErNld2cldzT0d6VFV6?=
 =?utf-8?B?RS9nR1RWWllMNDFZWEgwYVNSR1RxTGUrOU51MVFucTBjY1VMQy9UZ1I4ckk1?=
 =?utf-8?B?RFozS1k3ck1jZ3VBbFh5UzFFZGpVSVh5WnZzQUJFN2c3QStzcm5IRzlZVVBS?=
 =?utf-8?B?dFRFcFZqK0xPS25ERHVpODZOcUoyRE16b3V0amd4MGRrQ3k3d2trNzRPbVlB?=
 =?utf-8?B?NUhzYm5vMkVEOHZ5UFJianQwNXNDOXg3UnJtdTMwNDhaOFFVczdLaFRFaG5S?=
 =?utf-8?B?cFNjZFlQUDc1di9ZL1lieHBYQ2h2SjBaK0FHTGJvRG02Vjl5U1ZNOFlVQi9X?=
 =?utf-8?B?cjJyeGJkNFNlWmhXZFhPZlV1MHVUS1N6NmMzdklHSm9XS3NPd1I3eU1Lc1J0?=
 =?utf-8?B?bFhIazJzempJMmtET004OXFhNTF1QlhhSTNNQXRhcndPMWJ3cHBPaktyT0FS?=
 =?utf-8?B?Wk1mWUNGMVJ5b0V5aG5pN2hoUVgyZk5mR240U1lvbkZiUUN4cTI0Q2JaQ1NB?=
 =?utf-8?B?RVVpdVppRjJyRzlaOFZHY1M2d3dKcVFERG5BaDlDWC8xY2FhUnp0U1FXeExq?=
 =?utf-8?B?OVluTTV3KzBLcmMxZUtTNXRKZWZ5OFMwNGk0SVNRVFBITjRzcFJWbWxkMzRl?=
 =?utf-8?B?SDQ1WlZzNlFSY2dzNjVrS3MvdVVnTWNuTWJySEI2MytJMjZ5R0Y5di8yTXdE?=
 =?utf-8?Q?KRxxx5n0KE2tLAhplqbhv6I7u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3696f55-6f86-4ee8-f2c7-08db9da77145
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2023 15:51:09.0072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 67vewOOqbX/ZmSPEJEkAbzDBU3D/4oJtGgJCgqvjrddl42/JCf9+wa3LgoPwiaOpS21jiIi3DSRxR4YsbtIALA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/23 12:33, Paolo Bonzini wrote:
> A KVM guest using SEV-ES or SEV-SNP with multiple vCPUs can trigger
> a double fetch race condition vulnerability and invoke the VMGEXIT
> handler recursively.
> 
> sev_handle_vmgexit() maps the GHCB page using kvm_vcpu_map() and then
> fetches the exit code using ghcb_get_sw_exit_code().  Soon after,
> sev_es_validate_vmgexit() fetches the exit code again. Since the GHCB
> page is shared with the guest, the guest is able to quickly swap the
> values with another vCPU and hence bypass the validation. One vmexit code
> that can be rejected by sev_es_validate_vmgexit() is SVM_EXIT_VMGEXIT;
> if sev_handle_vmgexit() observes it in the second fetch, the call
> to svm_invoke_exit_handler() will invoke sev_handle_vmgexit() again
> recursively.
> 
> To avoid the race, always fetch the GHCB data from the places where
> sev_es_sync_from_ghcb stores it.
> 
> Exploiting recursions on linux kernel has been proven feasible
> in the past, but the impact is mitigated by stack guard pages
> (CONFIG_VMAP_STACK).  Still, if an attacker manages to call the handler
> multiple times, they can theoretically trigger a stack overflow and
> cause a denial-of-service, or potentially guest-to-host escape in kernel
> configurations without stack guard pages.
> 
> Note that winning the race reliably in every iteration is very tricky
> due to the very tight window of the fetches; depending on the compiler
> settings, they are often consecutive because of optimization and inlining.
> 
> Tested by booting an SEV-ES RHEL9 guest.
> 
> Fixes: CVE-2023-4155
> Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
> Cc: stable@vger.kernel.org
> Reported-by: Andy Nguyen <theflow@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Just one very minor comment below, otherwise

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 25 ++++++++++++++-----------
>   1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e898f0b2b0ba..ca4ba5fe9a01 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2445,9 +2445,15 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>   	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
>   }
>   
> +static u64 kvm_ghcb_get_sw_exit_code(struct vmcb_control_area *control)
> +{

Since ghcb is in the function name it might be nice to have a comment 
indicating that the actual GHCB value was copied to the VMCB fields as 
part of sev_es_sync_from_ghcb() and this is used to avoid reading from the 
GHCB after validation.

Thanks,
Tom

> +	return (((u64)control->exit_code_hi) << 32) | control->exit_code;
> +}
> +
>   static int sev_es_validate_vmgexit(struct vcpu_svm *svm)

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8693F9B2F
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 16:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhH0O46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 10:56:58 -0400
Received: from mail-dm6nam12on2054.outbound.protection.outlook.com ([40.107.243.54]:57398
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231327AbhH0O45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 10:56:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=er4yNvB3dPFS0EOXd6wQVE0VHGg9vkwXRrhQx+Va9/1ethYnnGJCOGQWKIbXr+m8J5eBc2hJNojbqPgwhLGN6UAnflX8mlnF+mz1NFhLXhHnjBx2KxGN+gtrDto0i7avgKJSnmnLs17XsvBkD/I1g3Pgotz3wUwf8TaNv+odSrfJpMhmy9ZcSTK0g/aV/mn6HXRyW9xmb0i3dnVrsFWLXVGQKQUCTLFgbthmONBZ2tJ+syt+ha3THG3M+/nPS7QE1sy3/j91fbC4EA9eI5D0rFIpC5m+g/n+WlTBVj16pSfL383Qqxr8fbEMGe/uAbd065NxymyKY1Pis+gO2b2FCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OlOl39YCd1TmhJieaJqnIww72WQNLbofjO9PKeMs4qg=;
 b=fYuPS8J05+DwreV1vQ2OHH/ZFEZjM5W0ryg0Pf/qSC61JBDjJ//LAtxGWOMqaRKa7WrL1/TpF5AYFFDATsVAOWosSPG0ws/x0Q8AVveYUYRRMy9pGX4vmYJczyZVyOdMdQowqSwmV9WH/kBqGd8aPk/DxeX4ffA8VgSpHLcidHvJBMfFVx5mAj7I709wVMqBfZjpr1HtIYMssSVK1ZG5KlEj8pms3DmJuo79l1sDUSmBYXSq2smFrPd+dEm/yrmriFUjil0mht41NmUOZJGdP3unzRIRqLsPHpJq1sdUfwLVJX2vxeU0OTNkyvUSkhmGXoB7Pcjd46UO6+T2vCimdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OlOl39YCd1TmhJieaJqnIww72WQNLbofjO9PKeMs4qg=;
 b=D7nYnFy+1cbz+8ijjpF+sU8vdPJaBK1u4YNEeD28K0IqtCasGpvwHONsQUeo5r561XZn6qAL0P8EnTCBzDWlz44T2hLipIEcragGgd0d0DIDuLVWd2hpz+6BWUbLOLP3TGq6CfyVETQ7447vF4qfoaaYIj6hQiLuWzLVMb1widU=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Fri, 27 Aug
 2021 14:56:02 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%6]) with mapi id 15.20.4457.023; Fri, 27 Aug 2021
 14:56:02 +0000
Subject: Re: [kvm-unit-tests PATCH v2 13/17] x86 AMD SEV-ES: Check SEV-ES
 status
To:     Zixuan Wang <zixuanwang@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-14-zixuanwang@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <ec4e6492-ec42-84d2-7ed9-f30d3bfd2543@amd.com>
Date:   Fri, 27 Aug 2021 09:55:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210827031222.2778522-14-zixuanwang@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0055.namprd13.prod.outlook.com
 (2603:10b6:806:22::30) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9PR13CA0055.namprd13.prod.outlook.com (2603:10b6:806:22::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.8 via Frontend Transport; Fri, 27 Aug 2021 14:56:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06931a6f-dd68-4ed7-83ec-08d9696ac9c8
X-MS-TrafficTypeDiagnostic: DM4PR12MB5150:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5150A12A3318A7F151D5784DECC89@DM4PR12MB5150.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V+tXA1br1Tty+4YBdo20YJETt0h4uH9wTW/jGa7RHwP6rNFHcRgh01lEQCn1Y1S8LF62y/7wGO3y0eOtOEYamqFDv0UcMWCH0oN8V0LQPQdVA8OMjzf/gitXpCTKIxNDFjEDoyoTEK1n3NrLvk/TS7wZo60C24EbOc7YbRGGtnz9Cavr2zPGsFXHQJHntOBRIOqx5xeBXWVrR4L5UA1fd7VCv+h4Z9j+qdENv1/TlMridC7ViLaFdmK6KJCctyFPtHHHrdKoqdwe8DpWGF8jxYYMb/DHq4xdHFdS5FlJulcypzX4Ue8st8pZVvBIAVDNCXxWHs+JZUwv8w2k3F9EKtn7l4a9FvMljzslj/wuGRvizSBW0VTjNkyedaGEVIfk1QhNsW8LkRNYZWdhr8CeitNS7ByS49v0scmtQQLwYc2SODwJbXGRX3IR0jOToYw1pU4SxSvMrxeu44VN8DhCYGgg31c5m4UnvCetl70gqlraxTaFz+5+H8Sp6IXkHmKfNEhjYG2gX/trsV901y/Gl4xdhDf3lqpjy1GAuw9olYs9C/apjvRXCJmtjQ9OrqEHg6Xhd1AFBp37HDud3nGpCLP3k8rcC25SfC60hDd8b2GPbXMoEHPr8adch+/jFRCGrph1rJnuL/GWZYAjYFkl1PzkOD45EDK3ZVzcb/DRskjNoj19DYQi6tqdB0H1NzuZn4aEw5MW8gwyhOUu2YpQx9AEt+7x9o76oWZdfq4LED0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(6506007)(31696002)(31686004)(53546011)(38100700002)(26005)(2616005)(186003)(36756003)(8936002)(2906002)(956004)(86362001)(66476007)(4326008)(83380400001)(5660300002)(478600001)(66556008)(6512007)(316002)(8676002)(6486002)(7416002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnVodmdxZEFleGFtcGNRaXAxQjZ3Y05GZ1pOUGEya0owMDgxQ0tlbWtDN1JE?=
 =?utf-8?B?SElFMFMwWkI3ZS9jelNwVUVxWFg5V2VNY1BLaXM3TnV6dFMvNkMveVZiejM2?=
 =?utf-8?B?NEVUOWFHQ3BUc0hnalpsdnBMSDlNWlJ0TFFycWlOL1FaM1M3R3drWGtFOWxa?=
 =?utf-8?B?MStYN0luN2dQQVdYd04rVGMwUkFLdjk3czdYR2ZlN3dPSGZaenZYb1VFb1cv?=
 =?utf-8?B?OTJLZFp5OHBxY1ZyTEVRc0l5dk5zWlpjNEtRdmdObjJ5VUY2ZXBINnRRcVUw?=
 =?utf-8?B?SXB4ZkcrbkovYWVhZ2xVMTBGcm9LdlYvdEFhR3hOVUxqQ3BhdkEvblU4ZDNk?=
 =?utf-8?B?aTVwUDBwRE01dmVXemVOdTVwQi9TU1Q1YVhieFI2Yy9Lb2VWcWVRcDZlR3FC?=
 =?utf-8?B?c1Q3S2txRkFacC9jOHBuM1RyOGJDODJrblpIdklCU2xCZmM1TURRN1YyVTh2?=
 =?utf-8?B?b0ZaaEx1VFNUOUFSM2NBWStjUmNiSCs3WjVhc1Z0QTBJb3A3YytrSFg5RjFa?=
 =?utf-8?B?SVBYbXVaei9ReVZQWWFqblphajlwaHJ5STB1N0VKdWl1Sm9USXZaTjVCejJU?=
 =?utf-8?B?Vll0L3gwZzVkVmo0SU1XVG94UUVHTk5DcytuZ2tGSzZvWUZkNTdHdzRZVDND?=
 =?utf-8?B?Y05KQlJEQkZiTm9CKzBRNFdYOGlORjVOdGdBV0RzTmpGREJkVVVqazVZWVBL?=
 =?utf-8?B?cnlHUDcwK0Via0dyL3hSTytKSVQxZGE2N09IMm9aTDg0REhJODZnVFJ6Lzhl?=
 =?utf-8?B?enNJR2p1TFFvdjJUSGRaR0VDU2dPVmtodjhHYXhBd0VpWFRUWjdLdXhab0xq?=
 =?utf-8?B?bG1VblZabVVCSENUT1VoVGIrdDZxYlZRYVFzRWx6U0c4emFLZ3padXp2VmFX?=
 =?utf-8?B?bFFQUE1OV1RRbWNtRWhWV2g3WDBaeWlCMS9LWlZxdlBpaTZuK1A0YVJJZzZO?=
 =?utf-8?B?M0ExN0FiK3V1YUpxQ1FGT1h6WDlNaUNqbGkxN1NMWk8vUGVNMEN6WEFjWGxS?=
 =?utf-8?B?WS9BcFE4UTFHcVZRVzRKNmR6ejdDN2xtem5yZjNGRkNCait4cXFiQU93c3RM?=
 =?utf-8?B?KzJNb005Tm5xbWtvOUE2T25wVHpSVFNVbUJtK2ZJMWNQV2xVN1duQnBLTnNm?=
 =?utf-8?B?bTFrZ0ZHYVZTWlo0WWgxblhCZEFaY2V6K2h1NUtaMWZTQTVBZ1o4dUQ4Q3Na?=
 =?utf-8?B?eDllZHRNTVUyeWtSM2pCcHZmTTJRU0F0SW0rOTk5NmVJZkx6NUdPelQ2bThq?=
 =?utf-8?B?dVJ1MTJuRzE0TmJYVXFuZDl1R2hqaDQ2YzBHSC9MNm40SEc4ZkYyc1QyQWI1?=
 =?utf-8?B?QWk1cFBIVEhKb3BtWVlQSWZsczEvMTJZcHZleHJRckw0TUY0dENTTzAvQmxZ?=
 =?utf-8?B?YmExeGYxTUZEdWxyWGVUZjRwYnloS2F1VGFkbHhqOXFkZGc2bUJUWk9GZmxU?=
 =?utf-8?B?TElHQSthVzE3RDluUGNUT05YUlliayt5ZUc3T1M2MzhXUVg4Q0h2V3BMa3k5?=
 =?utf-8?B?K0t5T1JiMkFRSmt6SmJ5OUlGb0tCSCtuMldOUG5GWGs1VWlrUnR0MmdvTVNq?=
 =?utf-8?B?TUJvZExLSlJUZHk3eSs3YnBGeDhJdEhCQXlDSUh1bTN6ZVZRYmdSVVlGajUz?=
 =?utf-8?B?OTVWK1B0MWYyUDMvMU9vWFJEMW83WDIvR0dMTzh4aHh3YStkUEdCTzF2TlZ1?=
 =?utf-8?B?MVpFaVpHNnUzNmhsckVVTUlRMzFTZGtEWm10N1pldjl0U2I5ajIwWXlNcVhk?=
 =?utf-8?Q?jgFVBws4dBQemZIhfPdOgR7pBv5RO/JwdofA59g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06931a6f-dd68-4ed7-83ec-08d9696ac9c8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 14:56:02.4050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pviy18IDlnvVr7ZVNEwsXaqv9YRRB7ms7iNsTXZ8cJSYJlPYGDnPIbi2tGr0v+JMab0F4KT5n9mPAu0AzmNyYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5150
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/21 10:12 PM, Zixuan Wang wrote:
> This commit provides initial start up code for KVM-Unit-Tests to run in
> an SEV-ES guest VM. This start up code checks if SEV-ES feature is
> supported and enabled for the guest.
> 
> In this commit, KVM-Unit-Tests can pass the SEV-ES check and enter
> setup_efi() function, but crashes in setup_gdt_tss(), which will be
> fixed by follow-up commits.
> 
> Signed-off-by: Zixuan Wang <zixuanwang@google.com>
> ---
>   lib/x86/amd_sev.c | 24 ++++++++++++++++++++++++
>   lib/x86/amd_sev.h |  7 +++++--
>   2 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
> index f5e3585..8d4df8c 100644
> --- a/lib/x86/amd_sev.c
> +++ b/lib/x86/amd_sev.c
> @@ -67,6 +67,30 @@ efi_status_t setup_amd_sev(void)
>   	return EFI_SUCCESS;
>   }
>   
> +bool amd_sev_es_enabled(void)
> +{
> +	static bool sev_es_enabled;
> +	static bool initialized = false;
> +
> +	if (!initialized) {
> +		sev_es_enabled = false;
> +		initialized = true;
> +
> +		if (!amd_sev_enabled()) {
> +			return sev_es_enabled;
> +		}
> +
> +		/* Test if SEV-ES is enabled */
> +		if (!(rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK)) {
> +			return sev_es_enabled;
> +		}
> +
> +		sev_es_enabled = true;

Same comment here as previous for the amd_sev_enabled() function in 
regards to readability.

Thanks,
Tom

> +	}
> +
> +	return sev_es_enabled;
> +}
> +
>   unsigned long long get_amd_sev_c_bit_mask(void)
>   {
>   	if (amd_sev_enabled()) {
> diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
> index 2780560..b73a872 100644
> --- a/lib/x86/amd_sev.h
> +++ b/lib/x86/amd_sev.h
> @@ -32,12 +32,15 @@
>    * AMD Programmer's Manual Volume 2
>    *   - Section "SEV_STATUS MSR"
>    */
> -#define MSR_SEV_STATUS   0xc0010131
> -#define SEV_ENABLED_MASK 0b1
> +#define MSR_SEV_STATUS      0xc0010131
> +#define SEV_ENABLED_MASK    0b1
> +#define SEV_ES_ENABLED_MASK 0b10
>   
>   bool amd_sev_enabled(void);
>   efi_status_t setup_amd_sev(void);
>   
> +bool amd_sev_es_enabled(void);
> +
>   unsigned long long get_amd_sev_c_bit_mask(void);
>   unsigned long long get_amd_sev_addr_upperbound(void);
>   
> 

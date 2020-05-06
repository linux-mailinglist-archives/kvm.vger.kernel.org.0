Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A644A1C652D
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 02:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgEFAmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 20:42:51 -0400
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:11249
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728356AbgEFAmu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 20:42:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Azu423jshHjs3FvvCNc0YLhLNydJ+pmMnVAydyauH1hLsccXzqeQIViVt6R9pfZG8/Eq1IYOo7dYRl520UShWSzcEHTtilaEDFTq044qUAd7k3KAmLR0StPdtOMl9Ftc4knqn2q8fFiiCYZW/2LEEsyTzzYtRvnQ6xsJAMA0+/bEIrDd88PENT4iqr0GIcuvm3erqpwwR88Gsb3meTo7W9V8xeBRo6ebdDKoGkPZxjrUjCRWUSAISEn3bq1VETg0teU1PfiH2VeSEEMShJGej+ipkPvuSP4mJvi4YKRZ2HEVLbQ50MYaWEP98m5WjeqqLVInXupyVanfrH4PKvghhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpXZXNc3Ur6AEs+KuJYPpLUSYcva2EgWrcUs1f9e02g=;
 b=Eds82Jfr/ltZLk58VnnnurqefhvFPpjTlbS9sKlFjihp/96I9sR+TsT5c5iSLjSQH1cIIgSm65LLp7Au2sRBaPeh6RcvjMywa1YreHrfR0VTprz/BLNgsYeGx2nYgGbVADkPwQqKU4jalQ5du4iWOU6GFAkHWowfLXzSmYzHBXQcsgP2eDBG2WtXeLodA2TL0XZH/esqk4TNh5TpeTAMO9w/RJghaoNu2IuOMmWfYlR4cfSTPPF5J4Y0GhImfPQOoKhvpRcVCGFfV5OPx5vXK5+ywMtFZArHgMwMAkDHKHemPZOC8FM1nP6ZSCCJDcW6wssxQa25dRtZY0SvqroUXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpXZXNc3Ur6AEs+KuJYPpLUSYcva2EgWrcUs1f9e02g=;
 b=eWWOOauMDr032LiEbjpczX9x+Aq3c3LubeDKJ1sPeeBCPS1CawTGZlwPEA77bzcy19hi4AdWM7teYFFd1K7HZlaUPAJL1Bi5rm48beiOR8y54fnSGfc9gfmitjP24TZ/BSspuCZxxT/29iFxxn5jtlR3AQWwFqfC0Ql2+zu6OT0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1257.namprd12.prod.outlook.com (2603:10b6:3:74::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.27; Wed, 6 May 2020 00:42:47 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 00:42:47 +0000
Subject: Re: AVIC related warning in enable_irq_window
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
 <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
 <c5c32371-4b4e-1382-c616-3830ba46bf85@amd.com>
 <159382e7fdf0f9b50d79e29554842289e92e1ed7.camel@redhat.com>
 <d22d32de-5d91-662a-bf53-8cfb115dbe8d@redhat.com>
 <c81cf9bb-840a-d076-bc0e-496916621bdd@amd.com>
 <23b0dfe5-eba4-136b-0d4a-79f57f8a03ff@redhat.com>
 <efbe933a-3ab6-fa57-37fb-affc87369948@amd.com>
 <6e94e9e1-64d1-de62-3bdb-75be99ddbb35@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <ce6c3f43-07a4-be37-9d72-5a664d2fb09e@amd.com>
Date:   Wed, 6 May 2020 07:42:35 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <6e94e9e1-64d1-de62-3bdb-75be99ddbb35@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1P15301CA0014.APCP153.PROD.OUTLOOK.COM
 (2603:1096:802:2::24) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2403:6200:8862:d0e7:581:5d48:c702:870a) by KL1P15301CA0014.APCP153.PROD.OUTLOOK.COM (2603:1096:802:2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.4 via Frontend Transport; Wed, 6 May 2020 00:42:45 +0000
X-Originating-IP: [2403:6200:8862:d0e7:581:5d48:c702:870a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 483608de-1a99-49d7-74d8-08d7f1566576
X-MS-TrafficTypeDiagnostic: DM5PR12MB1257:
X-Microsoft-Antispam-PRVS: <DM5PR12MB125743C0C5D8713B60803CC8F3A40@DM5PR12MB1257.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SC/FFC5znrH1VKpoNVC00JRbHROeL9YIJ1SF33MMuRr4CSQoREUY7/zkPknACY0hT7NF1QffKQmhIXZ43SbPzDAgIQ+ItKA4jTB8ZiaZt0AeIYZLfuVlEEoFV4LS7NLtZJ1t21s2Wfc+uZA+Locp2wYU8WlYmtu6yTVVE4UvzpGZqwbXynRkUUXHT1G/A65hWuWBcxd3Fcr8DDvkl5dxjB+s/UPbxgCex2SmKP+nFYsqvDXTHwzsfjm0o8MIGgyNO9MkYOZhu/atBdzbIMiUL9Dx+1SPg8z+IV+J7iKvw2O8sAtKeDqxQKiafcuFNf2ahDcWOWMFHv+cX6JCjYAooVTK3orpFvb1xVM2UVKR9df6AuXtWWMLqnm5NOYJ7MIh4lMS3IlpY179i/ivsPyCvQH58Arh/G7HSAzdZUOZ58oYOHgmBBJIoS6iMdwg52gpoRiLK4hu0avxCI/hE9PqTslD5c3p/rjT3Z2aR3f1aL6y32W8gdBK1739dsBTQaoAEfAKtXRbvOzLQTPBAaLR0RozqVbK+Lp9caalkSlstGnfxJCsFet6mnsE80jvgBHV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(33430700001)(2616005)(52116002)(186003)(44832011)(31696002)(6486002)(53546011)(6506007)(16526019)(6512007)(86362001)(31686004)(4326008)(478600001)(66476007)(2906002)(8936002)(8676002)(36756003)(66946007)(66556008)(33440700001)(316002)(110136005)(6666004)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZrUyRNYnhCToqySutoLVBE9PiyEjDiA/VfRbtDW330c+KHusw7nMzmL+q+PKiNduKrCJFDUsApQ0S4j/jh9ghtsh3EAhACfOvUyrf/YiLVzCNHBmSmCX4TVGwRdVT8V/GJz/OMrxhDQ/pmi4x/RDx0RDbJsJmLOT/1Y8VFPE4YOETriAuA2Aencq7lb54iPWdWyTB25GsShpny0UlQAykisK0Mf6WD6gcHiAGFlPcTfJiV5xbXrbv4x4Si0G3bJLXwBWlzhwkYHVKky0KPq3FaeHHA5TdDsN4LhJpPOv0H08jdW5LIUwgRElx2pdPaHXo+qLGNnfGO14ABZj7BwjSMcfLETF76ATTHGeyUVC9IfH52hXMTZG06Co9RWmAF3lfLM7x7WEjJYB7yTi13Ek81/zgSwyNdiFPWigfpUTUhYcYhgY+gbSHy/cI2NI0xVq01401dA248upBak9Qvq/QcWQmFeOvG5yjzLzHbbxaYVCPW9pun1Ob+CLlBmpxgNJOZImvjBuvRT5YRjOiP2WmS3eEXOXW+efPwB2m+teDnl2SobWxalV/c2HDwqQRQRKkoCBazaeEB8vyFrqEDYidg9/sBxPMbslOLyPx72Ihp5a1n/SF2iOipCwzbvmEHrmgs1cP2k7BhLT7NqsDw8+QTjnEBJT2lcLDRh2OXH84SvXHAeXlidpO5PCwSVwZ4pW2PWC2K4b2Y48Mwjw08X5Xarl07htZ2dNj4RSPOzgfJpkQsvCPcnxPFmYjkdEbTEpZSResW2RR4zad8eY/mbZOhuKLsYL76Sgk60BaVV7Kq2HmE3tdIG6yS98uizQ0a9/Qg1UmVSd0NNGbwtvLMPZzXIKwcF+TxUmhzesHxHFjPM=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 483608de-1a99-49d7-74d8-08d7f1566576
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 00:42:47.0666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NwG/wtWDetuk2JOBDtX2ymr22n0JlTwdetEhkW2+inFhw9HhREueIwpkWah1qZgLIakhZ+/EunQ8x0VCFm5fHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1257
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/5/20 7:12 PM, Paolo Bonzini wrote:
> On 05/05/20 09:55, Suravee Suthikulpanit wrote:
>> On the other hand, would be it useful to implement
>> kvm_make_all_cpus_request_but_self(),
>> which sends request to all other vcpus excluding itself?
> 
> Yes, that's also a possibility.  It's not too much extra complication if
> we add a new argument to kvm_make_vcpus_request_mask, like this:
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 74bdb7bf3295..8f9dadb1ef42 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -258,7 +258,7 @@ static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
>   	return true;
>   }
>   
> -bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
> +bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req, struct kvm_vcpu *except,
>   				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
>   {
>   	int i, cpu, me;
> @@ -270,6 +270,8 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>   	kvm_for_each_vcpu(i, vcpu, kvm) {
>   		if (vcpu_bitmap && !test_bit(i, vcpu_bitmap))
>   			continue;
> +		if (vcpu == except)
> +			continue;
>   
>   		kvm_make_request(req, vcpu);
>   		cpu = vcpu->cpu;
> 
> 
> Paolo
> 

Sounds good. I'll take care of this today.

Suravee

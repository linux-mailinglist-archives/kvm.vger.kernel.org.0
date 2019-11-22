Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672821072A9
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 14:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfKVNBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 08:01:32 -0500
Received: from mail-eopbgr820047.outbound.protection.outlook.com ([40.107.82.47]:10688
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726548AbfKVNBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 08:01:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWyeVyw8KoEP74JzKEiB7lMGNMmArflY79ryPZHQN5vPX3IEcU0pNQcp7snSAEJ2XBmThluefVB+aA1imKqwbLr8upqqgsBS/WHmN0ysTSo+Tj2FlEUNlc3go4T6eaZ97baRnN0e2uiMCgLqmVRnF7JJh9bgKDG95nD0JIHp+fFJM1b+KRGTXLLP44xvk0bucud70hKOgFjvAW34DJf0gvRG+oIIaluZs+86nJFHBMfxlA6f6ERAQZR7zyNAZi6/5giosGNOpm4IE5KgckHn/g8ACeFaSUqPZRAUnx9gAGCn+5LgNC6s81YZYXl5gtIDM3JNjeOHiflnI3L6V43Eww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1LoIC86SkLkv1Zzs3WxdzydAUFFn7w8beBLCFC+skhg=;
 b=WAZbK6NU57/02pQ1f0QgjkwWsdliYTKWVAolPvjEUcIaq8MdQ3/Eu2QWLjeLUAWsd9st9ZJErpEwTX8Ah4rkByvE+k7yOWprgm2Pxsk88iF/3r3i4OtDH2GX3YUn8FjtFkJsiad+m8KUxD1cEscdylO04xO0cVGrrheYhMwEDsO6ydbURoN0KqAx4IDAk/5vxEZ2FdE/7aQOt1zzo6BdC8BgRr1K2fbkRN26LKLVcf0yA7lLWIexzJiD7JVAnyw+zMtIoeaOwq4n30Asz4iLi7mjniz/qhw+V51oYK4kbFlMXJimYNqx1MqzIhXo5pb1PiyMACuAVNSL4NV/LufZvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1LoIC86SkLkv1Zzs3WxdzydAUFFn7w8beBLCFC+skhg=;
 b=h7DF397/StbdvwMCcZgWVYIcoYzPMdBL2Sd2JLxtVD4klb+YAd/l7cKDndRFmPrxQ1ZOM0pujCnRBAm6vC1ezoVvrElb5ka4S31UuLfj4M9H4+b94eL6HhVZBkqFLAEZIc0KI8lmEyKbVIDEMV0Wh+XwBtw5wi33uaO6AER86Vo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3497.namprd12.prod.outlook.com (20.178.199.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Fri, 22 Nov 2019 13:01:28 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9%7]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 13:01:28 +0000
Cc:     brijesh.singh@amd.com, Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 2/2] KVM x86: Mask memory encryption guest cpuid
To:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20191121203344.156835-1-pgonda@google.com>
 <20191121203344.156835-3-pgonda@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <d876b27b-9519-a0a0-55c2-62e57a783a7f@amd.com>
Date:   Fri, 22 Nov 2019 07:01:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
In-Reply-To: <20191121203344.156835-3-pgonda@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0201CA0004.namprd02.prod.outlook.com
 (2603:10b6:803:2b::14) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
MIME-Version: 1.0
X-Originating-IP: [70.112.153.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8dd8cd0f-f9db-4e37-beb2-08d76f4c1425
X-MS-TrafficTypeDiagnostic: DM6PR12MB3497:|DM6PR12MB3497:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3497E81A9108B5AD9CD3889BE5490@DM6PR12MB3497.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 02296943FF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(199004)(189003)(6246003)(66066001)(316002)(229853002)(186003)(8676002)(65956001)(54906003)(11346002)(47776003)(4326008)(66476007)(305945005)(58126008)(14454004)(110136005)(6486002)(2616005)(478600001)(26005)(66556008)(230700001)(6436002)(65806001)(50466002)(66946007)(25786009)(52116002)(6512007)(44832011)(7736002)(86362001)(81156014)(2486003)(5660300002)(2906002)(99286004)(446003)(14444005)(23676004)(8936002)(76176011)(36756003)(31696002)(53546011)(31686004)(6506007)(386003)(81166006)(6666004)(6116002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3497;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hc6f670DI0HGWcc2ijMJ3PiUrgMzuYqJf5cl82wDlTb+RHj8r52XKW2cHX6o1UQ8hoDqtpirSLtJDcoj9yyvagwCeWHqSFUQLP4xrCgEnwDw27oG0t8xhwvowxnH+aiUUm5dUaE1+3qf2VI76WY1XK25aBhky4Pj0teVXygSWPKe9GFn0ovu7lxDUj2/vXUUU2FYhCbWxo/IRG+Z+pPk4oXQjiBKSi87w5riOJAJ/9wF1M9F1A8sb8a0q7VulKEie/FcCUtfmjymVnd7fdag3OcDkvrBWUZjvmgXfmzFUVygTSF+h8daCoieg6PKyoTGVJR86n7dZkl35J3j4aACacRRkfR+0ispL352HfqUTQPIB234uproGQrJJbHylvaWDk4XhKYCq2DN1P6imyF9gzOw93BjwBwURGOjsF63opPVBZFX/aC9IW0juL/by3dT
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dd8cd0f-f9db-4e37-beb2-08d76f4c1425
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2019 13:01:28.1326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PVG2IyU2Kp6wjbWeoAcQTMrF5vVVgMKYW3vyjHtSxMc98Y53EKLJTIVRS+zHvcsvPutloz1EwOqapw2F/pDfew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3497
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/21/19 2:33 PM, Peter Gonda wrote:
> Only pass through guest relevant CPUID information: Cbit location and
> SEV bit. The kernel does not support nested SEV guests so the other data
> in this CPUID leaf is unneeded by the guest.
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 946fa9cb9dd6..6439fb1dbe76 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -780,8 +780,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  		break;
>  	/* Support memory encryption cpuid if host supports it */
>  	case 0x8000001F:
> -		if (!boot_cpu_has(X86_FEATURE_SEV))
> +		if (boot_cpu_has(X86_FEATURE_SEV)) {
> +			/* Expose only SEV bit and CBit location */
> +			entry->eax &= F(SEV);


I know SEV-ES patches are not accepted yet, but can I ask to pass the
SEV-ES bit in eax?


> +			entry->ebx &= GENMASK(5, 0);
> +			entry->edx = entry->ecx = 0;
> +		} else {
>  			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +		}
>  		break;
>  	/*Add support for Centaur's CPUID instruction*/
>  	case 0xC0000000:

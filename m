Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D4E36FB20
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 15:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhD3NGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 09:06:31 -0400
Received: from mail-bn8nam12on2088.outbound.protection.outlook.com ([40.107.237.88]:6379
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230020AbhD3NG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 09:06:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQgmbTLUZCT4OR3ISzehPN4iGFCyVJKVYuym4utK7jhmyMHx8B5E58llKDGhgdxf/pEZNJc7hFixvvAD10E4ZLoylKOlXzbQEkO9ZFDHICm3XfRiSTwg/XMJpqJBE3FFivruYu3H9LE5A9VuhE8yF2wre6kJGAcXibRTC+8IsJgR0NGBFt6soJbIYyhBqsw8qEVPchlJVe2O75R6XmP+RNJKRcaPHPUJn00RHVEOQl7X1uAk4WpQtOZxixWRIyNCL4v0YQ8M+M078kvo+RIgHEdbu73Dv/Q0aDrOXr3oGQRd98Q8TpNi7R+xVsC7oekujKZEa88e6sEMs5hcpaAP3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlxGnEKCmkpTmdE3j+I5e4zu4QhJz8y+rcmuKaiUhgw=;
 b=RcDcoe97K4jZIsZnTP/zme+N30dv1Jm3NOTD9Pxkg8pAkKHx7UnrvfnFp6dhIZ8tKUwcLDW9IOBF9Kf3zdN2CW3Q51cIe/WT8O56xB9mSAfgoajzYoB+zx98PRgRFkGIghrLQIoAwKfZa5pACRDugtoOKTwKe8Aj482mJNFofgLbFd2cWwvEQk6iEzC6N/oYd0veJ5p1uYm5qpDx6jKF1tHvV9ESFOArFV3l4A3uY4jqnIlz0UHfJVxcxqtKxULcl3TGm8jrY7/KRxFII0B5rNos1dz5A+O83jcrUVTGQ/am3Xfpfi/kkakFQ2hl5V/qeOOzYYPJKOomWwUZbVxx9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlxGnEKCmkpTmdE3j+I5e4zu4QhJz8y+rcmuKaiUhgw=;
 b=I+/khbeocRftcwHnnbtaa1SRsF/A9JtAreLUQAxWWR87DjjSG67chWVi8doz/D8GykY4kx2Uc6WQ8UIPH8+K5H25jN9x3jfXtBIkk1Qxfz5RmetiZUOH63jWWEbbpPIBidMJ8vo0H9S+/oOkXdg05C6xpGylLIaPuUXHKTaDYOY=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2784.namprd12.prod.outlook.com (2603:10b6:805:68::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Fri, 30 Apr
 2021 13:05:38 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 13:05:38 +0000
Cc:     brijesh.singh@amd.com, tglx@linutronix.de, bp@alien8.de,
        jroedel@suse.de, thomas.lendacky@amd.com, pbonzini@redhat.com,
        mingo@redhat.com, dave.hansen@intel.com, rientjes@google.com,
        seanjc@google.com, peterz@infradead.org, hpa@zytor.com,
        tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 10/20] x86/sev: Add a helper for the
 PVALIDATE instruction
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-11-brijesh.singh@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <4ecbed35-aca4-9e30-22d0-f5c46b67b70a@amd.com>
Date:   Fri, 30 Apr 2021 08:05:36 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <20210430121616.2295-11-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:805:de::46) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR05CA0033.namprd05.prod.outlook.com (2603:10b6:805:de::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 13:05:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0d4653c-1b67-4acc-4b4c-08d90bd8a654
X-MS-TrafficTypeDiagnostic: SN6PR12MB2784:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27842E7ADF65544FEB5CF0BFE55E9@SN6PR12MB2784.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fSPJvx7g0s/V0IBbmGdG9Fcy695IarAVVhRPmXF93V3vVCn1MmMBIItBweICu9nWG1y2a336TKb7v081gyIhcLDtmMX0bjN2+DVFW4xxbXwQYmXIeo5YMXre/Ov+SGk+2NvVnpJXcUsSO97+fX/FGUF1+xzakq4g79EJ13gXWKAT3vBJ8BfcY/5XRSEMglD5B2NJoyGOmySthOvam84OJwGGuKcUFV8lh5hGups3x+6jfUYfDBYcvDC+860TA0Idg864kq9ikAu3b7nhb6EDceRV4hhmLuMnXfWBalCF9Z7UiKf+tl93UjUcNemlvMKmpqHLLGrBP9B0p5gEqbhVTyeRKk7IEP6bt0Ei/pIFJOSY7zPdHrt6d3w4B7rGA4FeeGqIzFVBXl06nuxMKc/FhL83YKpjdDWTXp/pxSk76nJITjxCwAkNJDzNT3M53XtY9vydq2pvNVHida9bjusutwxfkM0Kr1IcZxm1aMMsquIY25QP9TmxJu/OluCpjRyXJsaZnevRBmCYmOHEZVJkLajNrrfAa33mPXn+1/hdd+XnanS7YyzYHmXzAt15vsAtwqSp0nmUSNHOjAXjEoQrGA+uOgJHM0FuIdmehd5vboBol3UfOPD5lCsGOHncWQVtExJXQTsXwsmOIi3vWG7lrezq908QGRaqwuVVbFRGgyy/7zOaGmXIyaP74SOA8COEUYmgqXwChfQ1WkpxBvEsgb0djxrLV9sGvE+/xr64/9GDeOnrGSBS0A2EH27lgRYua4JIul7J1yKGWlfgpR/BW2crFTXcPdR798jqz2VVARU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(966005)(7416002)(2906002)(5660300002)(86362001)(478600001)(31696002)(53546011)(36756003)(8936002)(8676002)(31686004)(38350700002)(66946007)(66556008)(83380400001)(38100700002)(6512007)(316002)(44832011)(26005)(66476007)(186003)(16526019)(2616005)(956004)(4326008)(52116002)(6486002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WmFQaFZBaFIxUEpER2ltRmZSM3B4QW1sMTZPVHJhMnRYZnh1UmRiclIrSDFO?=
 =?utf-8?B?T0V2TmFRMDVxMGNGbm0wZUM0a3hrY1h4Zk11dTBFOGtRS0FZK0IvbFhSRWk4?=
 =?utf-8?B?M1orWHJaNk91RUFyMVdLSWovemg0anJmUm1uTS9IRDhQY2FjOEZYd3ZIbWw1?=
 =?utf-8?B?eEdhajNQWG5Yd2hvTWtpR1R0VEw3OU9OeC81dXJONWpSQ1RwWGEycXlSSGw2?=
 =?utf-8?B?cS9aVEZtSXJhV0RpZkZobjM5MDZqY1JOYTBhUVhRNnZwQkxMY1VLZ1hDdUhG?=
 =?utf-8?B?VnE3MlhoZ2lGL0lGaG5lYndpTnN3TUhySVJPNmVOSzB2Y0dUVEpIYkxQMVV2?=
 =?utf-8?B?ejVVQ0d1UXNFUVpIVlpKN3poNlJQUXErQktaOGR6VDZ2SkZhSUc0cWFJcnZF?=
 =?utf-8?B?dHJMeDQ3aE84TzhmQ0FEcEx0QXZ4b0xQSW44Nnc2VHViNC8zLy9tWmhDbWpv?=
 =?utf-8?B?dHZKS05Ga2NmTXo0dEJYdUJKQ1VuQ3VhK2xTUk1qNUt4cVJlc0NQQ1QrczZy?=
 =?utf-8?B?SiswTnlnOG9iWFpmemJhSlQrK3VJdGc3d0VYcDRxTUlyRk9nSTFBS1NQWVE5?=
 =?utf-8?B?TmpkcEh6ZG8vMmNEZk9lVmJIY2x5bDhTVjJ4MnZsMmJjTmhkZ05LMGEzU1JE?=
 =?utf-8?B?QUZFdWhxQUZRcmp4MjRueFp5NFRaSU1PVG4zQmUxNG1odXJ0NG5yWmlsVkk2?=
 =?utf-8?B?R2xSWkd0TjRNQk9FYjIrb0dFRUpGMEpqVmRnc2ZZVCtlQzRmM05LRmNaZmhY?=
 =?utf-8?B?Y1hSQWtCZTd0VFVUZGlqZGpidisvNXR6bXVJSVBEdno0QlRCdUxvZWY1TjV5?=
 =?utf-8?B?UG9HVm5mVnZ0UlUzelZYeGkzbGFDOGNsdmt5cmgyaFJIVzBxWDBDSkZLK3k3?=
 =?utf-8?B?S1owb3c4RUF1TnVtL2dwKzdCb2F0ZW9lN3dPc2ZIVkxsQnViTC9rcnQwNUVK?=
 =?utf-8?B?VitVNm13dEt6RStWRWdSM1N4Q3hzZWNuRWhxRExzVERDcnE4c202UjdxcXVN?=
 =?utf-8?B?Z0tKYzJZL1BEV2kyNnIwK0VERk5rLzFJa0owbmRRUHRGbDVpVmJZOVBCTWw2?=
 =?utf-8?B?cUJEZjRnYWYvNWR0b2ZZc1h2WXVZa0VVTU1Ta1E4Z1BJZ0o1MHBUTENPU0l1?=
 =?utf-8?B?dURMa2hjQVVoNFdjTlltOHlBUW4wS0JnREplNHlzM3lQWFViam9IU2RJWnk4?=
 =?utf-8?B?ZUgrVVNIcTRWbUFsOFJsWk1nN0RmTEVtdkVBQmhPQ2J1UXBZSkJOQTJGa1Jp?=
 =?utf-8?B?QUI2UC9Nb0p0TGtyVWpSRGMvN0l1STRZYzRDQXZJeUVzZFI2SVl5d0kzWFQx?=
 =?utf-8?B?dnhyMzZDbmZHMlFta2ZFa09xQzhmcHBjOVZ4c21XZlpBVkhKd05uQk14MFZC?=
 =?utf-8?B?cGJSbldocE51THpiTU5PZnJWZ0NkTkdHb2g0aG93ZFpjZVMzVE1xVGd0Qldh?=
 =?utf-8?B?V3FHMno1eUNLM2QxemljOTFOTzNhK1IvbTM1enI4dE1ESUhIa05IQ21IVGVK?=
 =?utf-8?B?SlNITjVBTS9ZUXE0RnRvUXczMFBnSitvZjN5bmtDSmhSMlRQR2M1ZU1YWmZm?=
 =?utf-8?B?ZTd5bU1RZ0srUWhCaUU2VUJjeHJsZ004cCtFMDBxNmFvOUFyUXN2OVRtemFm?=
 =?utf-8?B?MEhncEdrcTBqM0hnK1FRZEZBV2ZYRlM1Z1BvSlhCZzI4UFI0OEFFVXA5cmEx?=
 =?utf-8?B?YkE3c0FjNEo1cEhDMU9ZSHpJYk95NU1WdTM3elduREVXWURLRDZMc0FPNjNy?=
 =?utf-8?Q?9UQQrHzWM1NVCk+9Q+KUMziOxeLSvVO288L0ztd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d4653c-1b67-4acc-4b4c-08d90bd8a654
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 13:05:38.2938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9F2LSaVCzSHSY7Ad25+vnBpvSXo1RuCHyyGPWxysVnUfAR31U4qMQaPity4q879wIk4CgVAmrzml5Shu3IqAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2784
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/30/21 7:16 AM, Brijesh Singh wrote:
> An SNP-active guest uses the PVALIDATE instruction to validate or
> rescind the validation of a guest page’s RMP entry. Upon completion,
> a return code is stored in EAX and rFLAGS bits are set based on the
> return code. If the instruction completed successfully, the CF
> indicates if the content of the RMP were changed or not.
>
> See AMD APM Volume 3 for additional details.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev.h | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 134a7c9d91b6..48f911a229ba 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -59,6 +59,16 @@ extern void vc_no_ghcb(void);
>  extern void vc_boot_ghcb(void);
>  extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>  
> +/* Return code of pvalidate */
> +#define PVALIDATE_SUCCESS		0
> +#define PVALIDATE_FAIL_INPUT		1
> +#define PVALIDATE_FAIL_SIZEMISMATCH	6
> +#define PVALIDATE_FAIL_NOUPDATE		255 /* Software defined (when rFlags.CF = 1) */
> +
> +/* RMP page size */
> +#define RMP_PG_SIZE_2M			1
> +#define RMP_PG_SIZE_4K			0
> +
>  #ifdef CONFIG_AMD_MEM_ENCRYPT
>  extern struct static_key_false sev_es_enable_key;
>  extern void __sev_es_ist_enter(struct pt_regs *regs);
> @@ -81,12 +91,29 @@ static __always_inline void sev_es_nmi_complete(void)
>  		__sev_es_nmi_complete();
>  }
>  extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
> +static inline int pvalidate(unsigned long vaddr, bool rmp_psize, bool validate)
> +{
> +	unsigned long flags;
> +	int rc = 0;
> +
> +	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFF\n\t"
> +		     CC_SET(c)
> +		     : CC_OUT(c) (flags), "=a"(rc)
> +		     : "a"(vaddr), "c"(rmp_psize), "d"(validate)
> +		     : "memory", "cc");
> +
> +	if (flags & X86_EFLAGS_CF)
> +		return PVALIDATE_FAIL_NOUPDATE;
> +
> +	return rc;
> +}


While generating the patches for part1, I accidentally picked the wrong
version of this patch.

The pvalidate() looks like this

static inline int pvalidate(unsigned long vaddr, bool rmp_psize, bool
validate)
{
    bool no_rmpupdate;
    int rc;

    asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFF\n\t"
             CC_SET(c)
             : CC_OUT(c) (no_rmpupdate), "=a"(rc)
             : "a"(vaddr), "c"(rmp_psize), "d"(validate)
             : "memory", "cc");

    if (no_rmpupdate)
        return PVALIDATE_FAIL_NOUPDATE;

    return rc;
}

https://github.com/AMDESE/linux/commit/581316923efb4e4833722962b02a0c892aed9505#diff-a9a713d4f58a64b6640506f689940cb077dcb0a3705da0c024145c0c857d6c38


>  #else
>  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>  static inline void sev_es_ist_exit(void) { }
>  static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { return 0; }
>  static inline void sev_es_nmi_complete(void) { }
>  static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
> +static inline int pvalidate(unsigned long vaddr, bool rmp_psize, bool validate) { return 0; }
>  #endif
>  
>  #endif

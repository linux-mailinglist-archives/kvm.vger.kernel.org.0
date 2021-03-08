Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C027331406
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 18:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhCHRCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 12:02:53 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47466 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhCHRC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 12:02:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 128GxNRl057490;
        Mon, 8 Mar 2021 17:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=daP0eS7DKjw/+pNTAUvjnxRcOnE0s9+Kg1bQ2QfZFvQ=;
 b=Tf72KW67Hruyro+3yrwVR7JGVVfILROicbkT09l1ue79/MkfaVU23Px9s4ZCMxdcXBKU
 z/u78PHcNVmTmXEv2hbu8YWlzB8Pkndg6uZ9VS/7Yr07RCkxQ/cOjvytKv0zKTLrWtbY
 3gd3rGM7Ktx+Y/WegHX9CDCZRso00fqDHUz+zrkpyLFCoLUu3zs0JjoOpgrPC/EOTAh2
 nKD0QvIrgyTJCUdS5WeKwX2RWht5EBqHMu0i30HuuIQf3wCGrTlkeVZSSTHf1rV150sI
 6ZYtma0YhnX4SLYJyu1baCnrAAJsASpi0tBmHeYeWNIY691I+C46rFj70jInHmujGV+3 cA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 373y8bmeav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Mar 2021 17:00:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 128GfNEk100728;
        Mon, 8 Mar 2021 17:00:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3030.oracle.com with ESMTP id 374kamfwjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Mar 2021 17:00:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGbEHjBQcyzj4p+XG5VXrDnnfUFQX7Pp3MW0HZeE+el3k7Km8MhD9iHPXEpUh0uNM+pITh+c1nb//W3gioi6f841eRzqXykBlgmlrvkCoWifwwSmgoQvNGujVOODFfRujxsMnl6i3Nrfk1ioGlddgURHxsCM/nWrLVL2K7bVwll+6Evf7QsKAkjgqdoHwhev/+T6T9HAMand+4Wk5oPUIE2kKYYyjyahM+O9tC05Lg8Pln7ERt/+RKbCzues8WHA22Mqm7EN3bqmq721lUdEzBaSs9Rm2MEazs59Nyj102pZdLCT2MHDRo36gaH9QYy8iZasQI1DT//DAKjywpRQ6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daP0eS7DKjw/+pNTAUvjnxRcOnE0s9+Kg1bQ2QfZFvQ=;
 b=m1P2AaIvtGUwgLt6GQ86H86jFrM2VZEZvUuRK17LMZj9Hm8Ez2yW0HB8BDZbdCTp+HJsNgZ7W63xHlEq/DsVpDltQXmkkV9PSnh1Td9jV4btMK08B5dMcX1JRbBTKeR3J64dpLnh6XNO4NrSguUBWkNxE4b+FcGhpYwVXEr4Qf9JZy+UZG1uZbKxCJ//yY5n/AILKAvoVARv8WEPaLFNsV8sq4qsT7KoBjmkMP/qJjfAbp2kxKG2RnIFitaE+cONBpgFrzG7I97U4ec8SvbuJriTtdCE3kqD/EokLc2cR7A6Bjjc4RXDuKq6E6qFsRFhD/kyxJaFW4jOd4AD8AuHyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daP0eS7DKjw/+pNTAUvjnxRcOnE0s9+Kg1bQ2QfZFvQ=;
 b=htozUCEAjFfE0/gb/XutOnzachwvCOX5xpgDfMHJi5T3iEtporhvPp/bDnLnfIlzFDSp9VisGEKr0y9fQgp5t9Ak/x6T04voJHKElgxIOsoDAS4VgQSL+toG6ZasNFYfBeu19HLwPaftbt8HQE6ghj+bcOy+SWus7+rppvKrsaQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3288.namprd10.prod.outlook.com (2603:10b6:a03:156::21)
 by BYAPR10MB3623.namprd10.prod.outlook.com (2603:10b6:a03:11b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 8 Mar
 2021 17:00:32 +0000
Received: from BYAPR10MB3288.namprd10.prod.outlook.com
 ([fe80::f489:4e25:63e0:c721]) by BYAPR10MB3288.namprd10.prod.outlook.com
 ([fe80::f489:4e25:63e0:c721%7]) with mapi id 15.20.3912.027; Mon, 8 Mar 2021
 17:00:32 +0000
Subject: Re: [PATCH v5 02/12] x86/paravirt: switch time pvops functions to use
 static_call()
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        x86@kernel.org, virtualization@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org
Cc:     Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>
References: <20210308122844.30488-1-jgross@suse.com>
 <20210308122844.30488-3-jgross@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <1346dbb1-c43e-9ac2-10e4-3c10cb2ead78@oracle.com>
Date:   Mon, 8 Mar 2021 12:00:23 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <20210308122844.30488-3-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [138.3.200.0]
X-ClientProxiedBy: CY4PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:903:32::11) To BYAPR10MB3288.namprd10.prod.outlook.com
 (2603:10b6:a03:156::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.106.64] (138.3.200.0) by CY4PR13CA0001.namprd13.prod.outlook.com (2603:10b6:903:32::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.13 via Frontend Transport; Mon, 8 Mar 2021 17:00:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5981fe8-a9cd-4ab8-e923-08d8e253af24
X-MS-TrafficTypeDiagnostic: BYAPR10MB3623:
X-Microsoft-Antispam-PRVS: <BYAPR10MB36238C52330B3CD1AECE6BE68A939@BYAPR10MB3623.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cS3pYGo0LzcDgP8l9RlxY7mtDqW/DVw9sllgD/KZalTVFgFUzYEVrVfqZzUMxzzqGv/xpTMhAi06k2QYibB8vngdmqP1u2gcK9rK2JfuzmlpEYdPyoAKBnFzB8X3RRvhKen+cRwD8KetmemkNb5cx90VdoyiCz1jbkMmrgC3Ig85lIu65vYoaRE51V5zI/8gTxhVZjKhmu5v8RBAuxh2dyWQPtW7i2aKxPGlXYTkYY1Hye1WkUbEPfHVZpc1VWJ6yHGs1Pueht4nyXXkGjeyrdTjd2Ot5hRQHUVR50tAQoO2nVABFFmTVVcIBSlNG7siTplTfOzi0s+QUCKcED1D3fv99C2eCD9SlWn4j/qEJandVW6pzpbsthsHKw5JTlYWxw78M4No2qkQ46SQ2pC+5d8y3nYIh1ef6uxgeJ6JKy01b3tsTR7p7wKEKwZMoGX9yZibqPwrruB5hdnIdp0RGGmop3XJmHHgnZdNuU8uXW1sAQywHWfoK1+TA6CKepoKj9EitxhgLchBKKALJl/2R5MHEEme5lUZ3ISoOJXaiKVOb8Zf2ODPfaR9H0C0ltKf8/hGunAgsT64tde9HlXMWjmBxC8Lk6amSybzxR48lnc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3288.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(396003)(136003)(346002)(36756003)(83380400001)(2906002)(956004)(86362001)(2616005)(53546011)(6486002)(4326008)(316002)(16576012)(7416002)(31696002)(44832011)(66476007)(8936002)(8676002)(66946007)(478600001)(54906003)(6666004)(5660300002)(31686004)(186003)(26005)(16526019)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UWZpUE44TVZCUEp0Vng5TFdnRUtwbTZxVUN4VzdKK3oreUpXS053RmN5Y3F6?=
 =?utf-8?B?NSt4VTF1SUxlS2NBYlJYaVU4eVIwZFBCWEU4aGlyaWVoZG1VNWRIUXNuSjR5?=
 =?utf-8?B?aE9CdW5zVE5kU0ZRVW1rTFVWQWhtL1ZQVzUrMHhkaTc5ZlNJUndUT0t5VDhG?=
 =?utf-8?B?ZWNrYVJnM3dPdVV6SEs2NmszQkZXYU0vc1RPdWU1aytBL0pBYk1VZWVwdmNP?=
 =?utf-8?B?aCtNck5ubFljRjJPa1hXWTFBaGIwamlDdmxUaVpJdnZwWUMrQ1B3dDJVTFFy?=
 =?utf-8?B?NlpnRUxWdkdvcEJ2UTVxMnd5QUppVm9IQ1YxQVVTZUhaMFY1QkhNUFlWYmFx?=
 =?utf-8?B?eXlmUDcvQTMzUXFpZVZVaGVXN1VXTFMyWG80M3puSno0aUF2dFo3ekJhOXJM?=
 =?utf-8?B?bHU3QStIVnM0RGU2V2k5Y2NDem4zNlk0UWJEeEVUUkZhTVFKZnEzUmRPNG9r?=
 =?utf-8?B?amRab2xkS1hFeTdnRVVqd1BsclE2cEZXQnlHY2xHMi93ZU1XQTBkczYzMGhP?=
 =?utf-8?B?eUdBOEl0akJJbEJBQXhIRnN1WVZBQTMzbW9LV2FOM3ZTTGF4L1lqS2dScUN0?=
 =?utf-8?B?TE5pRFRXcUJ5TzJteWpMZnBheEhuWkJ1RmN3SnBzYzJGeGIybm5TWUVtSkFv?=
 =?utf-8?B?bDdwSzVSYkhzd04vR1JJaXU2YUtqOUFQZk5QUVVqNFluellJN2xOYjZIdVZo?=
 =?utf-8?B?dzdXaDJZNzBINDNQZll1MElHU0xzZmgzaXc2NlBiR3hPOWdOcVE4YW9zYy9P?=
 =?utf-8?B?Vk1GenRvNUd4aGl3VmdiRHMvMEVKRnp1N2g5Sk1RUU81Vi90Qk15QUhZeTlE?=
 =?utf-8?B?STh3Y0o4b3FoZGJzUG5XNTVDVkFXaG16ZjZKL3Vjbno5ZFloajNyVWVDVFhN?=
 =?utf-8?B?aTRSbHJzM3hYbnBZYWpFU00wcTVxYmpoSEVmcFczUkdFSXhyejI5MkhmdWtD?=
 =?utf-8?B?alBwRWRiK05JbWJQWU9wRFVvRWMxSnRPdm80MzgxVzlRQlRWSG9vc3FtbTM3?=
 =?utf-8?B?K3cwV3ZESUdYNUQxQ0VVWStqYUJRMlE4U3NiQXNINFh4WXppcjA2RDRSbi90?=
 =?utf-8?B?Yno2b3NPd1VXUmpiYmRyZTVXaWN5V2JDOXdGT3NhQUFMMjVCRGVSdXNsU0tw?=
 =?utf-8?B?UFExUVhENGlISHlJaklVZ0lFMm1Wdkt0SUIveEhOdTgreFV4c2RtVHdmNW04?=
 =?utf-8?B?TUs1cWlFNkVEalNud3dLTXRGVHgzMHYrT0htUTNTN09zOGRwdFVwUTNJbUtP?=
 =?utf-8?B?eGx3dkJoVFFaV0QycDBwZWJNTExBU256dlh1RlFkWlhaSzZUWUZrMnFUcERj?=
 =?utf-8?B?eVplVmhGVW51STlWb0ZsZkRmblRIczRSbi9HWmIzYXh4UVp2dkFHcks0WThQ?=
 =?utf-8?B?ZXNXUk04ZzMyWUxISjVpV2k0Qy8yZTJLVzhJSDNDSENkMGRka1hUc3BjRmt4?=
 =?utf-8?B?N3BHNTVCQ2tZWE14YlZiMkEyZml1dW5YYTcvcHA5QThWb3dKd0U5ZWFjN2J5?=
 =?utf-8?B?SXRERnBoVGNiQ2dYMllzakdCditTTFNnTjVxMXdCRVgyWlVCWUtIelBtcWt3?=
 =?utf-8?B?MCtWZE5tSGN2Q3RBZlhFemNZL1dSM3VuVzR0SUdacFpFZlhCYnlxTnp5OGNn?=
 =?utf-8?B?U3lFaW5PeFErbnRXK3crV1ZwdFZhN3NpM2pFL0hIQkhsN3ZTRE1WNjFKdHk4?=
 =?utf-8?B?ZSt0U3g0YzJVc1RYZzhBc0c4RG9pTlI0dFlNYkxidUNxcE04TC9yNjBTTVpT?=
 =?utf-8?Q?LxKckNeFRJLZ38qfQawI37569PSfnti8G2l/l9R?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5981fe8-a9cd-4ab8-e923-08d8e253af24
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3288.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 17:00:32.4478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqPVK0PEqOWnpekBDlvbA8ahaoYNkpUO2xCgO4pw+xKii5mgPptubRFRvsamml33WsHg1hmVk60FiPEiR/ydG+6SElOaVmgmUOk3ok949y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3623
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9917 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080090
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9917 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 mlxscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103080091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/8/21 7:28 AM, Juergen Gross wrote:
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -379,11 +379,6 @@ void xen_timer_resume(void)
>  	}
>  }
>  
> -static const struct pv_time_ops xen_time_ops __initconst = {
> -	.sched_clock = xen_sched_clock,
> -	.steal_clock = xen_steal_clock,
> -};
> -
>  static struct pvclock_vsyscall_time_info *xen_clock __read_mostly;
>  static u64 xen_clock_value_saved;
>  
> @@ -528,7 +523,8 @@ static void __init xen_time_init(void)
>  void __init xen_init_time_ops(void)
>  {
>  	xen_sched_clock_offset = xen_clocksource_read();
> -	pv_ops.time = xen_time_ops;
> +	static_call_update(pv_steal_clock, xen_steal_clock);
> +	paravirt_set_sched_clock(xen_sched_clock);
>  
>  	x86_init.timers.timer_init = xen_time_init;
>  	x86_init.timers.setup_percpu_clockev = x86_init_noop;
> @@ -570,7 +566,8 @@ void __init xen_hvm_init_time_ops(void)
>  	}
>  
>  	xen_sched_clock_offset = xen_clocksource_read();
> -	pv_ops.time = xen_time_ops;
> +	static_call_update(pv_steal_clock, xen_steal_clock);
> +	paravirt_set_sched_clock(xen_sched_clock);
>  	x86_init.timers.setup_percpu_clockev = xen_time_init;
>  	x86_cpuinit.setup_percpu_clockev = xen_hvm_setup_cpu_clockevents;


There is a bunch of stuff that's common between the two cases so it can be factored out.


>  
> diff --git a/drivers/xen/time.c b/drivers/xen/time.c
> index 108edbcbc040..152dd33bb223 100644
> --- a/drivers/xen/time.c
> +++ b/drivers/xen/time.c
> @@ -7,6 +7,7 @@
>  #include <linux/math64.h>
>  #include <linux/gfp.h>
>  #include <linux/slab.h>
> +#include <linux/static_call.h>
>  
>  #include <asm/paravirt.h>
>  #include <asm/xen/hypervisor.h>
> @@ -175,7 +176,7 @@ void __init xen_time_setup_guest(void)
>  	xen_runstate_remote = !HYPERVISOR_vm_assist(VMASST_CMD_enable,
>  					VMASST_TYPE_runstate_update_flag);
>  
> -	pv_ops.time.steal_clock = xen_steal_clock;
> +	static_call_update(pv_steal_clock, xen_steal_clock);
>  


Do we actually need this? We've already set this up in xen_init_time_ops(). (But maybe for ARM).


-boris


>  	static_key_slow_inc(&paravirt_steal_enabled);
>  	if (xen_runstate_remote)

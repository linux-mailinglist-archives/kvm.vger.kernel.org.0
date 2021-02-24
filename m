Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAA1323F96
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbhBXOOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:14:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41288 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237279AbhBXNfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 08:35:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODTMGD051871;
        Wed, 24 Feb 2021 13:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 in-reply-to : references : from : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=w+//88K7Mto8jFpX4T9O6tlIOH9pVdT20uqmwusJ1vc=;
 b=OzoKbs73/1TI+fXkFUn3V4QB0mkwMsOEILsRth8XqpCP5wHSze6N1XdfKOcfj4r+BUuK
 sUIybPBZTIjrMCTdR3P35jB4KjvDzi0JHCbjLCLyYxSOkHJdw3c0Y5f9RwbWRME3AQ1F
 DP2v3ga6TlTO9+Bq2vv1ueTSUjCybRJ43UBVXzzScqC/iUQqxtIj86cq5XpaWUD/T/V4
 Ohd0akGSGvj3CvKGiuzt0hPJMdEav/WPt9DAM1CDHaMjpCKFmXk7MZ/CMfIV5q1gA9L3
 5S+NLzzRWcy+fQNR3dDdCZGA+yyV8pIK/xwobPCmtoMaO5jCiXjzuLNvWD42E3NpOhtl 6Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36tsur2xnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:33:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODUWNM016469;
        Wed, 24 Feb 2021 13:33:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3030.oracle.com with ESMTP id 36v9m5y6dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:33:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ec+Z+UOGPzTqJzw1jJA3zfekh0wRyr9QgjSKhiD2mzHFIqt4MdDrOqgjYyKV1jkDq9MKTBSLv0oFGuFA7YV1Ykg1tvuYtCx445PhP/yHQzPMVaogpxeBQYpGk8/rZTLHIEG0qTo1USj8TgTlwvV1zV/IcbJC8YvuUyMWByZqvHdJV+i3JxoJxwZ5LXSdwV8rxhdUiQrs563KJnaqYE2xcbmafWGQ53ofTpivFEPukem65be7OMsbOBAVKIcdyZn5LXMFKaqLwpf7esQ+a/ed78YH3RFQznDwIWsc6/faGj+uqHBkG9dEDLYSwxMDuOAkFhNwkLu4GHemAjm0fnYpQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+//88K7Mto8jFpX4T9O6tlIOH9pVdT20uqmwusJ1vc=;
 b=bkcsyIBwSgttkkUNrC6dj88nZFxxkaV2L3QPsXiftoYNEkjNY0jAuibz8rCWOyNH5F3HERNPQ5S+iMNCSvGEV2AsAsVRqCqbyrb0x8z6M4fO8HM9kekruiNo5P1OpsHoaqa3D7Ily44hDTQLMFYn65QHcjSUiti2Toz5qRZ9+w4+PwCAcoYj7KOUh0sIFreYXXtMDqAkeGGGSAsaiwexCFkGtDU5q+nYALGWWLur9VBMzfaVvN8RVYg9ztLbrO/D4c9jXKdamgCmIj+r317Hj/367OKpu31W8W+YGe4t3QZ0p2QvtbY8lKj6KE1uDWQXMjGEgi8BKRcpIXUvxyjZhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+//88K7Mto8jFpX4T9O6tlIOH9pVdT20uqmwusJ1vc=;
 b=H0etwsKvRcT9en+L2VpnjZuq2m3OOQFeAQqkO65mMBewnr/1AHnyc00e02ORDtJFq702etGPJWhnwYUb9hldqZJpSNtSu/8mhoPXaJjrHzZAa3BcfeaLxCKJVI4uyDvXw+/nhBLqJ7QslOqYuAc2+Gvyz1RJ0HQhLBpUwSaUzPU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB4394.namprd10.prod.outlook.com (2603:10b6:5:221::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Wed, 24 Feb
 2021 13:33:20 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 13:33:20 +0000
To:     linux-kernel@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3 4/5] KVM: x86: dump_vmcs should show the effective EFER
In-Reply-To: <20210224132919.2467444-5-david.edmondson@oracle.com>
References: <20210224132919.2467444-1-david.edmondson@oracle.com>
 <20210224132919.2467444-5-david.edmondson@oracle.com>
X-HGTTG: heart-of-gold
From:   David Edmondson <david.edmondson@oracle.com>
Date:   Wed, 24 Feb 2021 13:33:13 +0000
Message-ID: <m2wnuxegkm.fsf@oracle.com>
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO4P123CA0179.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::22) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO4P123CA0179.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29 via Frontend Transport; Wed, 24 Feb 2021 13:33:18 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id e4b17d91;      Wed, 24 Feb 2021 13:33:13 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 207569c0-b4b2-4d57-e56a-08d8d8c8c026
X-MS-TrafficTypeDiagnostic: DM6PR10MB4394:
X-Microsoft-Antispam-PRVS: <DM6PR10MB4394101A3F1736B8F2660CC0889F9@DM6PR10MB4394.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: twMfLATGSUjB4jpnsqt2EJwj3oQi3OriYwQz/LqFdJhLe2HmMQuaofJKPQbsEXmzFKpO9T4eZKLW0dCpIF8/X1H3agEjB5rjxqcG3Y9KCwrl9pZUM9z2/CAow+/EsGVVXovXiMbKuy+Klo5fiLMx6wBB2aRR/DZHF/YUy3iefwYcjVn0VsU5NwOwJmmRPfYq4OnZ/py1q/bWJq9w9xSvliGhs9l5LxsvdYWcmK94C6RCBurvWP4d3fMz4kGOlsT/HMX07yK4hAu5WiVFobWxli+A8oJt7dxl5XSQqY9tIbGTi08shjfVsxlp4+07c1kZ+RtR762IIgCcB+EE9oLRJsAAQR1oUxGlawWmU8QH4qe3SO7XGqt6Hoa/Mi8bHEE4QQVFA9s4CQMTAJ6Gi33AdmZZdpS78fo38ATORfu0CtYTo00ug4HpLXnRGYJuVkHFXsei6jBi38tklluI5IskGxXbgS4900pezVsq8x16n/DO/5gi80nbcsmKikxaoWgCBeO4+oqkGntJLcPCFxMoHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(396003)(366004)(186003)(83380400001)(5660300002)(4326008)(7416002)(54906003)(316002)(6916009)(44832011)(2616005)(52116002)(66476007)(2906002)(8676002)(66556008)(36756003)(86362001)(8936002)(66946007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bfOfjf3BpYdbVZ6uwEKDsqz/qtAzrwlBx/ZSi999/+S1wqOSxhRVlDE8ZYEy?=
 =?us-ascii?Q?SM/pfDL/L8WhqUbDAnQ8RiDbWQZEtAmkLaB8oBHUlzjXtHRR8pvyO5uS4R/8?=
 =?us-ascii?Q?6rSJcuXqutvu/y04EGjunYGBoSHOWuASdRpgzULFgGer63AacvztT3cLwQu9?=
 =?us-ascii?Q?1skkn/Y+vlXQOOtcwiFkIF/o5lTFUiPJByk/vH3K5Ajk71dRwtFXjgPT7tjz?=
 =?us-ascii?Q?BqI2GI2ggy29g/aYqsWm3s1078CtCyhViFfqobu0EG4Nv0ddvZAJJGN8TINO?=
 =?us-ascii?Q?W4fpobHtqYCU+pfesbRkiq/PXq3eHHI9skAGwb/U1oquHtM5AksC44kTVCf5?=
 =?us-ascii?Q?FodlXZkS4tdUdtZxAjK40PuKuCLin1/MIEGgFuMvk3BVoUXFlPc/fuwKfU/i?=
 =?us-ascii?Q?FIHLugo2Fq5+HPnRjb6i66ECpkae2UGOcZSbY3ilDTFIF8QrX8eFOakMP8fp?=
 =?us-ascii?Q?XMvNDUgUxjf/NBxOu82xJooIu3uAu7YDiASpUvjqFz8bjeqSGNYzrLWjuVb8?=
 =?us-ascii?Q?ty8NH7+Pf1mYZ0HmZzsal+AbNSDkkYPi5hg2WcU0Iyju72ZmJE9cLfl3oRDX?=
 =?us-ascii?Q?P7w0VZQDrAM2kscPyx7OvfKTjSM6PdJ3cKq60pM+TDYL72mkwTLEzScTKeji?=
 =?us-ascii?Q?AL38Kh5SknbZkYGdvPjRWeK06sefYy/JbJHg3ql3BCuzUemnojaXkdd0csTv?=
 =?us-ascii?Q?+kz0fVSvFUNCqfHPwxTW4otOVwvU1ikzC5/0Xx0PrB1BxY/+kgAT2HbKKLUX?=
 =?us-ascii?Q?KhuwxpWg1UhUXBvooIMCGNZ0UGXlysbW8x8Hf2gGdhyUdL4Vst6oPPE87hA2?=
 =?us-ascii?Q?jUnfomd3qtILP4f08YT+CiQis0Yuep4x8LlJTejNZyOBOXDgxd9cD4wyMFyo?=
 =?us-ascii?Q?yWa6liN1kBqYNR+SBUlv5tbo583rhD2m3zwj7+QyW50Ux6ioQJ0mCSiLHWhp?=
 =?us-ascii?Q?AD6TiLRRasqZhMIqtJViDaE8OYHCN5YZLorpZhi46YkzcVdgvprcHNyiZnaL?=
 =?us-ascii?Q?3UpOhnhNG5etW2ADvbumCa5ggZRH0NqwFys9pNLXKMeqm2CMYLvQDYRminnA?=
 =?us-ascii?Q?AZzT+VLJqsKr4NzMxaX2M8zqlfsmF4aB2+cHyhe1whUCrx3p5fsXGJpDLgup?=
 =?us-ascii?Q?BAL5uBN9aHxoYXQ0gKS7SLOPHbMIZ8ZvFxVDDGv9fHb4SwyOfl7JFWTqXxxF?=
 =?us-ascii?Q?qQeQ7ZWiMtfJlCkoga6b1JvX4bwMdW6divPVFtHgT+2q8JCOOqNRR7jyDTce?=
 =?us-ascii?Q?pIq7eViRt6EqkFicFaPD3TN2iarSWVgYR6QzjByrR1+N+09XE7crR9T2R4lT?=
 =?us-ascii?Q?aNJTLZP5VXEk7t6dkMNfe/31/7PxUGUQbbnyG0TQSj6ouA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 207569c0-b4b2-4d57-e56a-08d8d8c8c026
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 13:33:20.2728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RcM/5NvVRFlHbZm613BqzoiCpxVfpxN4COHFjqkPZLbdMVrmFKu+/O9LOOyu8IXoLed3h+fBYw6+vHB/XJJEfmdYMXKzCrw2I477A+lil/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4394
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240105
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bah, I will resend the series, as it won't build with patch 4 but
without patch 5.

On Wednesday, 2021-02-24 at 13:29:18 UTC, David Edmondson wrote:

> If EFER is not being loaded from the VMCS, show the effective value by
> reference to the MSR autoload list or calculation.
>
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index faeb3d3bd1b8..ed04827a3593 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5815,6 +5815,7 @@ void dump_vmcs(void)
>  	u32 vmentry_ctl, vmexit_ctl;
>  	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
>  	unsigned long cr4;
> +	int efer_slot;
>  
>  	if (!dump_invalid_vmcs) {
>  		pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
> @@ -5860,8 +5861,18 @@ void dump_vmcs(void)
>  	vmx_dump_sel("LDTR:", GUEST_LDTR_SELECTOR);
>  	vmx_dump_dtsel("IDTR:", GUEST_IDTR_LIMIT);
>  	vmx_dump_sel("TR:  ", GUEST_TR_SELECTOR);
> +	efer_slot = vmx_find_loadstore_msr_slot(&vmx->msr_autoload.guest, MSR_EFER);
>  	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER)
>  		pr_err("EFER= 0x%016llx\n", vmcs_read64(GUEST_IA32_EFER));
> +	else if (efer_slot >= 0)
> +		pr_err("EFER= 0x%016llx (autoload)\n",
> +		       vmx->msr_autoload.guest.val[efer_slot].value);
> +	else if (vmentry_ctl & VM_ENTRY_IA32E_MODE)
> +		pr_err("EFER= 0x%016llx (effective)\n",
> +		       vcpu->arch.efer | (EFER_LMA | EFER_LME));
> +	else
> +		pr_err("EFER= 0x%016llx (effective)\n",
> +		       vcpu->arch.efer & ~(EFER_LMA | EFER_LME));
>  	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_PAT)
>  		pr_err("PAT = 0x%016llx\n", vmcs_read64(GUEST_IA32_PAT));
>  	pr_err("DebugCtl = 0x%016llx  DebugExceptions = 0x%016lx\n",
> -- 
> 2.30.0

dme.
-- 
I'm in with the in crowd, I know every latest dance.

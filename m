Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FAB4B9FA7
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 13:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240193AbiBQMFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 07:05:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiBQMFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 07:05:22 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0919D62D3;
        Thu, 17 Feb 2022 04:05:08 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HBYsxI021431;
        Thu, 17 Feb 2022 12:04:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : references : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=sQ054MwiNb+s2lx2goKJuQPgQAVhwl/q+XGiVtkK9iY=;
 b=MFRHdmwHncKR8Trng1CuoaQCjqa0I16FWPL1rm7Vg2slxqeaIf+irzY/4RMSzWuJEWzE
 xuMBVFNiKfjHfauLAApm/d9+XUmrFXZVtOxZaE0ZyGG7lR5HGdRF+L+3Xdd1nvfjJVWX
 Y7z0gTOJZbRbpU4u7B1rahTwgdRFILsziMgAkXB1nOXB9mF2B9PFi1T75qg+dqAdA8Z0
 evanAXt2t9XsqtHNBNBzIUwju/aoLIoCQa46dkPXxrLcM75WdznnDnC14XZPHyCdfr4l
 HB1+kWkDZG0pXLi8Gw6lrutSWe8fqWqQT6pLYM2sKI2wieUN6urdYj85yliT2BaJKdPc kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8n3fd5wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 12:04:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21HC1Kcl033234;
        Thu, 17 Feb 2022 12:04:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 3e8nkyxke6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 12:04:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6ETUAeM9iaOz0AX0Mo4qYuH+rm4BGWB1HkVLxyaGGb6q70RoiApQ5MyEeM9+aFT3hO2gxBrOn3KZxV0VWlb7gydCUrDqgwg1WGE7flVJ6y0OR5qtsp57V2XjAe+CSMmFNydIJ+CudQvh200egoc/91R1gtp3tHadWCC4pTebs9bsW8aKawsG7V69Lxq7gFhKzB6Wu6PZTNjUbD9wwTse4CokVqMeCbkynUeGhRSHWH6WVQzUrGCmAZ8BDsroT4WLobDGp8mUvxeEXmWE3ArqIXSRG447b+fBDu8zJeS8ZCMYA6JKGRkY3LeiQvHFMzEyUBYOa2ip7Me68CRtnQoXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQ054MwiNb+s2lx2goKJuQPgQAVhwl/q+XGiVtkK9iY=;
 b=QxmEUUmk/CAHqnvXiG7q7bMQC8EOENZNKLCTv5IsAMFahWT8RIFQnlEszNiVex7wDQfaHhIon/gENTYLTUrUv8WitpvSsutpaEn1FIaFgt++16VD1OisicVFG7f/UImTQzSH9inHWpoGxY1wjb0x964s6r3YNfs7Qt0PpIV08I9qWiBemix85g7FJOg67otWHxKN//O6hPDc1mOFMrHeYPKjtu0n87QVVTV9FmY+r9gvABUHt8Yu6AuF1LC5E1QF/GS5P0M//et4U2Moup8iN+1cNK7i+mMYD7TGE3PtH8ynxz5OxXvtd0HleANHVBgniuZA6/z7XSjLfXHDbfZjsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQ054MwiNb+s2lx2goKJuQPgQAVhwl/q+XGiVtkK9iY=;
 b=Ozc7H9OSp3qM+lP37hpsjvmZQMQz2nBNxrxn0Wjuxqj1PVSLqOlDTPlUUGauQ/g0CXxcNpZIscQHpUR9bMuDdpl5nxWK5KbRI+RvbeIesN5MHUTKkSKDWVjYlAcGQiFcFLa2+FKH4z3wogWWy7C6NmAlIRo38TYJtN6URhtSwdg=
Received: from DS7PR10MB4926.namprd10.prod.outlook.com (2603:10b6:5:3ac::20)
 by MN2PR10MB3533.namprd10.prod.outlook.com (2603:10b6:208:118::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Thu, 17 Feb
 2022 12:04:05 +0000
Received: from DS7PR10MB4926.namprd10.prod.outlook.com
 ([fe80::e429:a820:ef6e:98d9]) by DS7PR10MB4926.namprd10.prod.outlook.com
 ([fe80::e429:a820:ef6e:98d9%6]) with mapi id 15.20.4995.017; Thu, 17 Feb 2022
 12:04:05 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     Leonardo Bras <leobras@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        David Gilbert <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] x86/kvm/fpu: Remove
 kvm_vcpu_arch.guest_supported_xcr0
References: <20220217053028.96432-1-leobras@redhat.com>
        <20220217053028.96432-3-leobras@redhat.com>
Date:   Thu, 17 Feb 2022 12:03:57 +0000
In-Reply-To: <20220217053028.96432-3-leobras@redhat.com> (Leonardo Bras's
        message of "Thu, 17 Feb 2022 02:30:30 -0300")
Message-ID: <cunsfshpumq.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/29.0.50 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0254.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::26) To DS7PR10MB4926.namprd10.prod.outlook.com
 (2603:10b6:5:3ac::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a06df6e7-bf32-40e5-80fb-08d9f20d97f2
X-MS-TrafficTypeDiagnostic: MN2PR10MB3533:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB35338F12790E29E540C637E888369@MN2PR10MB3533.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PX+A647wQ1x0UGjI25w6P4ONAoorBlGDDxIw4VIzOlv1QckG/gOriS6TGXjAJFTZ+T8zci9o7iLZVIjIhe2xfUvKO6OMowvE6Jv62Fj1/THxjJ3uM71t9H9VaU+IDDyFRRDE6WvbDbnJKoGz7U2Juyt1vw1kmZnKzssRqNJcjndNxX0InMPLCz18WJKgYL9kE7byt2JlZrM/BQ40CcRHcnBSvebTara9fM2R3/EuqOWQP8xKKr5Af1VjTyiZIFvTjctD1O4/Mvr8xmAuVtTAMQB4H9WnH2VOTGUJ2ZIWPmbExY6s2UH060C2321W1SiMXFGgVKMtQjDf9o73nINEBMxKrCI+V3bPi2bPa43/UGb2FYe999SxMgPfwq4KJwH2lzdlcl6zRMj3dN1KDjfbKILs9wnY/iK+2Ix0iPxDpg8RF49auAkVXNHijRE5BztLP58frX1+yDEV/bOTtt9lhfeyRvxMf5jrKMjHYq0w+24aMB4NY2GN1EhG457YULsLW53GJJwStmfdzojadtm12GLdJzyeblvjyG0Ycbz/wBN8bVUorxgcvzSpMbyUNST4ipMJOKpfIdKW1Xldy8bHi7GOONm9kxcyC4eQPqq12/YB0nnC2/euLjFfzNLMBPTi7YsYJKa0NSglQg27xSau5xrLfX40sUhamGUSYtipBCEiqQcHNtmTEyeTXhKbW4cg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4926.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(83380400001)(6512007)(6506007)(52116002)(66476007)(2906002)(38100700002)(36756003)(66946007)(66556008)(8936002)(6666004)(86362001)(7416002)(44832011)(5660300002)(2616005)(8676002)(6916009)(6486002)(316002)(508600001)(4326008)(54906003)(4226005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QetsVFfcR8VoiT6iHwQilRA/E+vktq8+4PC5f/tVVDQFYMcq+n5F3RfgjypY?=
 =?us-ascii?Q?L2jZFS4J4PDRpV811kv8L8VlHvBMj0ayJmK927yI0zBA0lOg6lg5nuiDDAF9?=
 =?us-ascii?Q?nhzOoISQpPzRCbhZ3ygM/sB0UsmkZuHUDQ+7R+dYUk951m4VTc7nslj2CLIe?=
 =?us-ascii?Q?5E+qMq1ovwHtK+YgNCwLYDzPXa8rVTZRJJaGwThinXQ9ELProUIhuELyqftY?=
 =?us-ascii?Q?uzkzYHtsfvXFz+ZqVcqBa7YIhaf56Quc0V9e3M0qKVk3c6sUHhCbEfA1EjGA?=
 =?us-ascii?Q?tPLdjhtj9gxGR6E215k9hFR+ocopVwbjFT5evFeaY6gVYAa+8i0yX8CijVWU?=
 =?us-ascii?Q?RzQhgX+fVputnyCuvffuOYqhjcSwaGCet5aWAI/F4rCnvmJB1cuVuk/eX3W4?=
 =?us-ascii?Q?1VwCHSdYkjKKGDN4YXHqJLYOVIg4JYvjUMSI8Ev0pEVLrmY3/6cAu96n5TcD?=
 =?us-ascii?Q?CbZU9T8go7GAp1SfBUou5fdLLoicTc1FLH+xGMX8mnLqNmK58/idvS3ssnQf?=
 =?us-ascii?Q?Xs5or5dVWz1Z++oqz6l7IYtdjEk+MhzpLk6DRWXPsRpwFbWWdQE0zTVzp1ML?=
 =?us-ascii?Q?u1zrcy37PaM+Xid24LJkqIkoL+72MotqwYczAVUr9aL0vtLZj+fXjwS089b+?=
 =?us-ascii?Q?M+U5jH6SZNdBylOefD1Vdesc8nCPtRY9x5JapgpmzuWssTSYXrH+Cfy/1KQ7?=
 =?us-ascii?Q?d1jXEuIYu9rJor1bFhCiMbeYEE+XCBoRltD049z8T34k+QlLhcRskhDARVBa?=
 =?us-ascii?Q?7s5F7J0VnnN0y/SUzUlIH3czJEvdcfB+QOafOTLITosk/YC+rPZ71f68GN1k?=
 =?us-ascii?Q?X3i52+f7hWHZKMAyNfeucuXJM1mxyQpTuiPLbJ+M4ObyNijCQt+3g1nXWXgd?=
 =?us-ascii?Q?CW3Gio0LSvwJPLApscrDlkVFpUNpyc0r4hpFCrv/UV0J9g7VsnsvpSgPGs6g?=
 =?us-ascii?Q?qulLhVY3z1xZL9OpM7A4uwD12kmcol5KshpAuzTPYdH2uSXtVgxdY9LTBYeT?=
 =?us-ascii?Q?Jn7bWl6r/swK61Hk7Xx8cmRRkxDgbGZ4ttFliy1J7aTKk8H7n0J9A14WC2hy?=
 =?us-ascii?Q?2n2v6+hLHndiynkYyvwkW19uIgI165rS1KS/oZ8STo8ev5+pv+DwzwEEBNLL?=
 =?us-ascii?Q?1/Zr+FdoMFC17TTCwWpwmYYBxM2AQrpCTFc+FJwkgYCxcyQFWU2NjfWp6AvQ?=
 =?us-ascii?Q?LCBXqcm7ZN4Tt3UOT6GpRZ8lQGvaGuuLC84mbA9kzHAiwanyc6lN2WIq8GGj?=
 =?us-ascii?Q?skcncZ6hE4Uf5YnvCac80OwmHTMtL+rSWwGp2a2jcY4mamsiV0o0zOpvTdXl?=
 =?us-ascii?Q?5iRlSm4a/M0FylDbPV4jTt4j+pZ1suumIfE6W6cKYjD2LcRWDKtHJK44lTwl?=
 =?us-ascii?Q?UP457oP3N66kyrEq+n10O/oAuhG7BY+dCqZainBgRCO8A1bAOUfREo5K4kp0?=
 =?us-ascii?Q?FmKgaXbiC9r8ReStq1Jh7w7Z0YX/3YfqA2xD43nKxtcXhAjQadxpt1u8uGNv?=
 =?us-ascii?Q?XLo/2Ox9TIOULoulVHIZq85ryWMjuyAiCLPlCBeq4sN9ZwALWWmYNmmNmp8y?=
 =?us-ascii?Q?B00Q5It8w7a+p0clwqmVp3Y3hOQETmB12I2vr9WmW86uj5+vRxueIp4m50f2?=
 =?us-ascii?Q?HkPAQSR5X6XbkkQrh6+hg3YzTpXtWJEko4dMa9kRFndq2RNXTWpaiNCDivMk?=
 =?us-ascii?Q?UPRlDh1sH6EbGgdyA6oWZJegY/e6B3V5VJAV13sxUYPLCpwy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a06df6e7-bf32-40e5-80fb-08d9f20d97f2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4926.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 12:04:05.0509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MO+HffFpeoYJy57JB3JjQphWx8uxHCY6/0+mavYwMj7fPPwSPVTfe3qBGAEtssH8XAZ8f2aHthKv8t6/5bmWe/tqX9DoEAy3km1GcsBA224=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3533
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10260 signatures=675971
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202170054
X-Proofpoint-GUID: 8D5OvBL2gJCOcv0BfxusiPG_wN6XtcWE
X-Proofpoint-ORIG-GUID: 8D5OvBL2gJCOcv0BfxusiPG_wN6XtcWE
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, 2022-02-17 at 02:30:30 -03, Leonardo Bras wrote:

> kvm_vcpu_arch currently contains the guest supported features in both
> guest_supported_xcr0 and guest_fpu.fpstate->user_xfeatures field.
>
> Currently both fields are set to the same value in
> kvm_vcpu_after_set_cpuid() and are not changed anywhere else after that.
>
> Since it's not good to keep duplicated data, remove guest_supported_xcr0.
>
> To keep the code more readable, introduce kvm_guest_supported_xcr()
> and kvm_guest_supported_xfd() to replace the previous usages of
> guest_supported_xcr0.
>
> Signed-off-by: Leonardo Bras <leobras@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/cpuid.c            |  5 +++--
>  arch/x86/kvm/x86.c              | 20 +++++++++++++++-----
>  3 files changed, 18 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6dcccb304775..ec9830d2aabf 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -703,7 +703,6 @@ struct kvm_vcpu_arch {
>  	struct fpu_guest guest_fpu;
>
>  	u64 xcr0;
> -	u64 guest_supported_xcr0;
>
>  	struct kvm_pio_request pio;
>  	void *pio_data;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 71125291c578..b8f8d268d058 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -282,6 +282,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	struct kvm_cpuid_entry2 *best;
> +	u64 guest_supported_xcr0;

The intermediate variable seems unnecessary.

>
>  	best = kvm_find_cpuid_entry(vcpu, 1, 0);
>  	if (best && apic) {
> @@ -293,10 +294,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		kvm_apic_set_version(vcpu);
>  	}
>
> -	vcpu->arch.guest_supported_xcr0 =
> +	guest_supported_xcr0 =
>  		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
>
> -	vcpu->arch.guest_fpu.fpstate->user_xfeatures = vcpu->arch.guest_supported_xcr0;
> +	vcpu->arch.guest_fpu.fpstate->user_xfeatures = guest_supported_xcr0;
>
>  	kvm_update_pv_runtime(vcpu);
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 641044db415d..92177e2ff664 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -984,6 +984,18 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_load_host_xsave_state);
>
> +static inline u64 kvm_guest_supported_xcr(struct kvm_vcpu *vcpu)
> +{
> +	u64 guest_supported_xcr0 = vcpu->arch.guest_fpu.fpstate->user_xfeatures;

...and here.

> +
> +	return guest_supported_xcr0;
> +}
> +
> +static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_guest_supported_xcr(vcpu) & XFEATURE_MASK_USER_DYNAMIC;
> +}
> +
>  static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  {
>  	u64 xcr0 = xcr;
> @@ -1003,7 +1015,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  	 * saving.  However, xcr0 bit 0 is always set, even if the
>  	 * emulated CPU does not support XSAVE (see kvm_vcpu_reset()).
>  	 */
> -	valid_bits = vcpu->arch.guest_supported_xcr0 | XFEATURE_MASK_FP;
> +	valid_bits = kvm_guest_supported_xcr(vcpu) | XFEATURE_MASK_FP;
>  	if (xcr0 & ~valid_bits)
>  		return 1;
>
> @@ -3706,8 +3718,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
>  			return 1;
>
> -		if (data & ~(XFEATURE_MASK_USER_DYNAMIC &
> -			     vcpu->arch.guest_supported_xcr0))
> +		if (data & ~(kvm_guest_supported_xfd(vcpu)))

Brackets could be removed...

>  			return 1;
>
>  		fpu_update_guest_xfd(&vcpu->arch.guest_fpu, data);
> @@ -3717,8 +3728,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
>  			return 1;
>
> -		if (data & ~(XFEATURE_MASK_USER_DYNAMIC &
> -			     vcpu->arch.guest_supported_xcr0))
> +		if (data & ~(kvm_guest_supported_xfd(vcpu)))

...and here.

>  			return 1;
>
>  		vcpu->arch.guest_fpu.xfd_err = data;

dme.
-- 
But he said, leave me alone, I'm a family man.

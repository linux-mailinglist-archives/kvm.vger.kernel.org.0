Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB545308BCB
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhA2RnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:43:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39646 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbhA2Rlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:41:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THctUY088543;
        Fri, 29 Jan 2021 17:39:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=9i/uOoB4ZdRn1J3VB1WRhUoX+A4sDUqww9eICQv3RDM=;
 b=luE+J28VBHejcEMmcNTXgIh+vQJzgT1utEcpSpDiLC7/ZXrUKHfYfG+3VgxLtCSrgqhY
 liH4m3h+Hnz1oaMMcU8to6RdZZJkRrMyLYyg5wMJKGEmMGCGiTz6UAGzy7hs3/m5Icqw
 8yAY2S3Sj1jM7PFYh7O8xNDw6rAc/2GZPvNMTMkSvZmkKxVlS+kpBkyA9oji344dfWNK
 Xakg2ZL4qW9V/6GPtDaqwh21OqmnUeGe2kOCHt+RJSrFQsTQAndfEnR5N6pHqehBSza+
 5Ht5/VcTRs6k5R8ohYLDQMYCLa/22/eyP93k2OISg6sjR15K8XWRnomD7e54VOSTjTFV VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36cmf88t7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:39:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THZvlZ158876;
        Fri, 29 Jan 2021 17:39:34 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2055.outbound.protection.outlook.com [104.47.45.55])
        by userp3020.oracle.com with ESMTP id 36ceugyf9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:39:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRRnMsFuv1nSISmfRw6p6hwe782CC0ByBII1JzbTkrmhM6UbiRokc/mOeOHgUMbuZgNhU0jzq9A2OidkXPRtsALHkQszXdUOhXORNpWFOi+XA4fEpl5Uf1Uh1AFfQaB97jewfnr1D6yn0yNzWQr1lQDZpUa5idsgbLQBrKa82v7VXLJhxXaEQka/rqhdD5DDdR3i9SheLyKMwX07MxYA7g1dLmOr5aUuArV2O0d6klJHNnxFvWSYT8vUCe0yzZjmsu760scJi5GrZontW8Vv4uyNuDvyLq2DbYfO44J3LdG9XW3kgmscR1XdctEeCPYZI9kkUoeT4plgzEf/8hb+YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9i/uOoB4ZdRn1J3VB1WRhUoX+A4sDUqww9eICQv3RDM=;
 b=UAaedKFCxiTD24PlCJnhj5KeLls8uD2SRfrjzGNgqbeMcY6zzVdM1a8HKK9PIIeSsjpUncPTsJ44dS7RB7KZdVvudBzS5EpShL9alVYV9U+p7VqbEQEF1paVbEGMUOTHONBAGKOC9SJhJGwNe9O3WgiMWbnxHyKbYukg8CCwYXs6WthA+tra+tk/hhmvRuSzwmlsvTT6kClOBf+jN94iDzp6+zwmr4VTU3rkxaJD+ikB7vbF2kVPs5IXU9CKVfnDaTrOtnRR/9GwsdJDJBsN90CPhzgJGnDwzwTkkAEKZMtVoUafdPocqzsPuPKWqsfujIjMJQWpfyBEvtFOV9O4+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9i/uOoB4ZdRn1J3VB1WRhUoX+A4sDUqww9eICQv3RDM=;
 b=Wkxj4XuTgAtdABPA3A80uqUYLUkUMVG9UhO+9cXc86Y7LOiGFQf4s1uzJVaS9hw23S/2ASCGhUipIDjBMBmw/Pv/oat4SyyHO1oz7Wz2JKtgPHJiBoKF4kd1R7ZDAvo3WZ+pVejD3zTsCmysIF5i9UZAZrjWFYBxgOJ/OX19sjk=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB2044.namprd10.prod.outlook.com (2603:10b6:3:110::17)
 by DM6PR10MB3018.namprd10.prod.outlook.com (2603:10b6:5:6d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 17:39:32 +0000
Received: from DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe]) by DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe%6]) with mapi id 15.20.3805.019; Fri, 29 Jan 2021
 17:39:32 +0000
Date:   Fri, 29 Jan 2021 11:39:25 -0600
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 1/6] sev/i386: Add initial support for SEV-ES
Message-ID: <20210129173925.GA231819@dt>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
 <2e6386cbc1ddeaf701547dd5677adf5ddab2b6bd.1611682609.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e6386cbc1ddeaf701547dd5677adf5ddab2b6bd.1611682609.git.thomas.lendacky@amd.com>
X-Originating-IP: [209.17.40.36]
X-ClientProxiedBy: MW4PR03CA0273.namprd03.prod.outlook.com
 (2603:10b6:303:b5::8) To DM5PR10MB2044.namprd10.prod.outlook.com
 (2603:10b6:3:110::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dt (209.17.40.36) by MW4PR03CA0273.namprd03.prod.outlook.com (2603:10b6:303:b5::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 17:39:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cb48646-8a29-415c-ad67-08d8c47cd5f6
X-MS-TrafficTypeDiagnostic: DM6PR10MB3018:
X-Microsoft-Antispam-PRVS: <DM6PR10MB30186F6036A7A98A1AD41DC8E6B99@DM6PR10MB3018.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nXsIxP+laH/cyUQC2Dpmsa7/Flc+KtU//DlRqprje9/xlq5xBqj6FSFgTlXN1I05tIR/fANstutZTQOISRJDecJ/Ypt+3326QzLzAg8U6mnkndrd4AySD0xARWnC5jkIBntClXVia/H9FoBMnp4R3xmibtNl4Qk8DP4LcqPeFwJ0783HRZTOFYNTwwCfsDL5nA5d29wGWUm0Dq2Z3FRoe7PfhhddKs4xcAowjzDyzfnAVJ4HZH8b9NgFiBF72UtYCm7vZ9ZtGR04JDnSQ70d/1tLvCdTIEVoleWHMgk30hM9r3yVyQz8Olge1B+qJh+QWTxgRUY8Yssd9z2T1wVAJpAV3twOgJyFcM+HJ9vPo3pIxRZ+mclRTpf1QnS6nE4Z0o9p3HkNdgZwiEi5PwwLKZ7Tu7Ntt7eTUNEdo9g6OsDHYUdiBzsH2g4t97EragcaDg11oS5zHZiK0NBFxN/DjL/pvDr3Y5ai8PyXhzeSatSvQ8NlrWt4DgJfdVyal7C1qZF0n5alITx8enQEwjUN5QN+iZ3XGunCgUrkQt3W5zpaq4yjvl1DQ81ls/kW0E/mEFtMTxemby97UqQJJiqFFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB2044.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(346002)(136003)(376002)(33656002)(55016002)(186003)(9576002)(6666004)(16526019)(7416002)(8936002)(86362001)(9686003)(2906002)(1076003)(54906003)(6916009)(6496006)(4326008)(5660300002)(52116002)(66946007)(44832011)(66556008)(956004)(53546011)(26005)(8676002)(478600001)(33716001)(83380400001)(316002)(66476007)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WMG/arDF9v03nwh5RpIxQmtOdnwGC/HvywlBK1XAkY1QWsMPk00bH43X68AX?=
 =?us-ascii?Q?Ebh8AYeaZwCQZh5zWHjnFgo3ngmBrFq1zqYwDxHtQGHZ7ifx32urmqVmTeCt?=
 =?us-ascii?Q?apDzjqXsF9nSgrY+nlIkPCsXXlv070NkYubAIUL51uIP2uvutYuv5HHzAWWQ?=
 =?us-ascii?Q?QVceVeUWW1TDVJylov+ouPykEyxk9Ts/wsHBcbH6luPQwDf2giBcpy2pza/w?=
 =?us-ascii?Q?cGyRk9c7AW8f8I1IElNgmUKBeM/+lRZOd9ee5FM4KNdv+ho8NurQpQWGCaFF?=
 =?us-ascii?Q?3GK/srzC93LLIWIASg0vqJLx0783mhT+QMfpGk3WZjZyyKN05XZN+z1guJoz?=
 =?us-ascii?Q?yBIvt7O+n9uZP2+om+CaO6gOQbdJYFu11cB4fvmo3mzXCRow9+1o9x/m5BGG?=
 =?us-ascii?Q?1pdMU+AT2yHAvuJmwR21bQCeLPAk7cq4SvmHhvRicgew+ERbOSdBFYwcIsrC?=
 =?us-ascii?Q?tt4U/IXroQpLB2Vff/HCQOMueHo8NrBCniChLuJk/adk4zRPOqVgqxX7AUY9?=
 =?us-ascii?Q?nC5F3rh6JgJe3dpuY10JZKdaPjAkD90RScypnkQUc/XbGMm+JRxSqUxDx2oH?=
 =?us-ascii?Q?+np/2MrvCT8keolxVsRJJyMlIa1KIEwvst4j48++UhX+npamzWsFeR7RwJXF?=
 =?us-ascii?Q?uMYGjjNE/ovUIM6EGGEkBmk4GLk3bsrbSRlNyXxiwGZq/HHsMWz2Nlf09D0z?=
 =?us-ascii?Q?Ey40GLR+7aOBCCwmRvg7wRYsY3judW8D7KNRBSRuYSNwqvJm0/9QjvjL2OKi?=
 =?us-ascii?Q?vPjwTz+0cBW5xrbEjdqFipDUnsZ/jlhrdstzBxAVIqykgKyH65LPYBMyC1ia?=
 =?us-ascii?Q?FmQ4Is87jm/mOgKkNBqOz3nwm4VEj4qSyeCa8M2SVSQTy5Aw7dD06ml8fDUc?=
 =?us-ascii?Q?adxJ5lD48anHUa3EPDhcZal5jCY2MgzMUpS7GIp3Kj61FOoZ6G4IreME5P2D?=
 =?us-ascii?Q?fqaSZtQwaBPA1zR/gIDd/Sd47xya4Nz/Sd/yf11cu9wJ/4+fN3zoGwCEa5kn?=
 =?us-ascii?Q?EmY52zjlkI6pAuJOhf8PUS66EbSe0LPE4E8T2oogBQcwfeDCgpj2z/03kNz/?=
 =?us-ascii?Q?4/TagEqO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cb48646-8a29-415c-ad67-08d8c47cd5f6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB2044.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 17:39:32.0685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H60Uu0GKsiGmjWLi5WKbNF9g+sGnMishfo7r9wdDMryq1B75fKokdBiw9DR52xdxIirnTg8QkyM/Rrw6ogzo11pA6W3DcvB1E+DHbv9VPt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3018
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-01-26 11:36:44 -0600, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Provide initial support for SEV-ES. This includes creating a function to
> indicate the guest is an SEV-ES guest (which will return false until all
> support is in place), performing the proper SEV initialization and
> ensuring that the guest CPU state is measured as part of the launch.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Co-developed-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>

> ---
>  target/i386/cpu.c      |  1 +
>  target/i386/sev-stub.c |  6 ++++++
>  target/i386/sev.c      | 44 ++++++++++++++++++++++++++++++++++++++++--
>  target/i386/sev_i386.h |  1 +
>  4 files changed, 50 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 72a79e6019..0415d8a99c 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -5987,6 +5987,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          break;
>      case 0x8000001F:
>          *eax = sev_enabled() ? 0x2 : 0;
> +        *eax |= sev_es_enabled() ? 0x8 : 0;
>          *ebx = sev_get_cbit_position();
>          *ebx |= sev_get_reduced_phys_bits() << 6;
>          *ecx = 0;
> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> index c1fecc2101..229a2ee77b 100644
> --- a/target/i386/sev-stub.c
> +++ b/target/i386/sev-stub.c
> @@ -49,8 +49,14 @@ SevCapability *sev_get_capabilities(Error **errp)
>      error_setg(errp, "SEV is not available in this QEMU");
>      return NULL;
>  }
> +
>  int sev_inject_launch_secret(const char *hdr, const char *secret,
>                               uint64_t gpa, Error **errp)
>  {
>      return 1;
>  }
> +
> +bool sev_es_enabled(void)
> +{
> +    return false;
> +}
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 1546606811..fce2128c07 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -360,6 +360,12 @@ sev_enabled(void)
>      return !!sev_guest;
>  }
>  
> +bool
> +sev_es_enabled(void)
> +{
> +    return false;
> +}
> +
>  uint64_t
>  sev_get_me_mask(void)
>  {
> @@ -580,6 +586,20 @@ sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
>      return ret;
>  }
>  
> +static int
> +sev_launch_update_vmsa(SevGuestState *sev)
> +{
> +    int ret, fw_error;
> +
> +    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL, &fw_error);
> +    if (ret) {
> +        error_report("%s: LAUNCH_UPDATE_VMSA ret=%d fw_error=%d '%s'",
> +                __func__, ret, fw_error, fw_error_to_str(fw_error));
> +    }
> +
> +    return ret;
> +}
> +
>  static void
>  sev_launch_get_measure(Notifier *notifier, void *unused)
>  {
> @@ -592,6 +612,14 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
>          return;
>      }
>  
> +    if (sev_es_enabled()) {
> +        /* measure all the VM save areas before getting launch_measure */
> +        ret = sev_launch_update_vmsa(sev);
> +        if (ret) {
> +            exit(1);
> +        }
> +    }
> +
>      measurement = g_new0(struct kvm_sev_launch_measure, 1);
>  
>      /* query the measurement blob length */
> @@ -686,7 +714,7 @@ sev_guest_init(const char *id)
>  {
>      SevGuestState *sev;
>      char *devname;
> -    int ret, fw_error;
> +    int ret, fw_error, cmd;
>      uint32_t ebx;
>      uint32_t host_cbitpos;
>      struct sev_user_data_status status = {};
> @@ -747,8 +775,20 @@ sev_guest_init(const char *id)
>      sev->api_major = status.api_major;
>      sev->api_minor = status.api_minor;
>  
> +    if (sev_es_enabled()) {
> +        if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
> +            error_report("%s: guest policy requires SEV-ES, but "
> +                         "host SEV-ES support unavailable",
> +                         __func__);
> +            goto err;
> +        }
> +        cmd = KVM_SEV_ES_INIT;
> +    } else {
> +        cmd = KVM_SEV_INIT;
> +    }
> +
>      trace_kvm_sev_init();
> -    ret = sev_ioctl(sev->sev_fd, KVM_SEV_INIT, NULL, &fw_error);
> +    ret = sev_ioctl(sev->sev_fd, cmd, NULL, &fw_error);
>      if (ret) {
>          error_report("%s: failed to initialize ret=%d fw_error=%d '%s'",
>                       __func__, ret, fw_error, fw_error_to_str(fw_error));
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index 4db6960f60..4f9a5e9b21 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -29,6 +29,7 @@
>  #define SEV_POLICY_SEV          0x20
>  
>  extern bool sev_enabled(void);
> +extern bool sev_es_enabled(void);
>  extern uint64_t sev_get_me_mask(void);
>  extern SevInfo *sev_get_info(void);
>  extern uint32_t sev_get_cbit_position(void);
> -- 
> 2.30.0
> 

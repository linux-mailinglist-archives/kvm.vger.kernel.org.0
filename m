Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A073CD4D7
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 14:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbhGSLy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 07:54:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12570 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231388AbhGSLyZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 07:54:25 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JCXkaJ119961;
        Mon, 19 Jul 2021 08:34:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2wMrOmOaMfVeFVX7tNb5AIsXI9mO7cENkLTsH3g4nNE=;
 b=PsE7PE+B6AVN4YkQYybLkXpNnK/T2zYj/pZLzMdefyOxY3TklaXLwV6RVQs3aSvn76M5
 75tUCUSg9pfTZEMhlxXeeATHLKtWyOotsMYnBNqQu2xE9SG10k4wpldTdFkEoGKJ9Cck
 /o220vZnKSfsLb/Szo4HQ1FO7UT7ZRZA8mMRDbSuoDbEb3fUcvxcEs4CdOxysvXd9oAV
 8R3U6tS6Bzvpe56NmbZlHS1+8pmQSui9XEBb+DcWYWcr/YZzEW5OXO5iqEAsakkRdOvd
 EAsR7HSuSEb9DdI0HdHJKcdOYej/prWQx7bixC/Oig4B9SPEKnGxcNItbB9+m4Dzv6i9 JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39w7ykugej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 08:34:55 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16JCXll3119999;
        Mon, 19 Jul 2021 08:34:54 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39w7ykugdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 08:34:54 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16JCSs1a031965;
        Mon, 19 Jul 2021 12:34:53 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 39vuk3x47p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 12:34:53 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16JCYqi936372798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 12:34:52 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A395812405A;
        Mon, 19 Jul 2021 12:34:52 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9197124054;
        Mon, 19 Jul 2021 12:34:48 +0000 (GMT)
Received: from [9.65.195.237] (unknown [9.65.195.237])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 19 Jul 2021 12:34:48 +0000 (GMT)
Subject: Re: [RFC PATCH 4/6] i386/sev: add the SNP launch start context
To:     Brijesh Singh <brijesh.singh@amd.com>, qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-5-brijesh.singh@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <d38d99dd-0248-bc96-cb4d-82ec8cc782f2@linux.ibm.com>
Date:   Mon, 19 Jul 2021 15:34:47 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210709215550.32496-5-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mzMUnhXLv0GHVr23VtPdoX38i_7122-u
X-Proofpoint-ORIG-GUID: wwY5Lok3vEV7-sSpUstUjp4CpIrosZSa
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-19_05:2021-07-19,2021-07-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Brijesh,

On 10/07/2021 0:55, Brijesh Singh wrote:
> The SNP_LAUNCH_START is called first to create a cryptographic launch
> context within the firmware.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  target/i386/sev.c        | 30 +++++++++++++++++++++++++++++-
>  target/i386/trace-events |  1 +
>  2 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 84ae244af0..259408a8f1 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -812,6 +812,29 @@ sev_read_file_base64(const char *filename, guchar **data, gsize *len)
>      return 0;
>  }
>  
> +static int
> +sev_snp_launch_start(SevGuestState *sev)
> +{
> +    int ret = 1;
> +    int fw_error, rc;
> +    struct kvm_sev_snp_launch_start *start = &sev->snp_config.start;
> +
> +    trace_kvm_sev_snp_launch_start(start->policy);
> +
> +    rc = sev_ioctl(sev->sev_fd, KVM_SEV_SNP_LAUNCH_START, start, &fw_error);
> +    if (rc < 0) {
> +        error_report("%s: SNP_LAUNCH_START ret=%d fw_error=%d '%s'",
> +                __func__, ret, fw_error, fw_error_to_str(fw_error));

Did you mean to report the value of ret or rc?


> +        goto out;

Suggestion:

Remove the `ret` variable.
Here: simply `return 1`.
At the end: remove the `out:` label; simply `return 0`.


> +    }
> +
> +    sev_set_guest_state(sev, SEV_STATE_LAUNCH_UPDATE);
> +    ret = 0;
> +
> +out:
> +    return ret;
> +}
> +
>  static int
>  sev_launch_start(SevGuestState *sev)
>  {
> @@ -1105,7 +1128,12 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>          goto err;
>      }
>  
> -    ret = sev_launch_start(sev);
> +    if (sev_snp_enabled()) {
> +        ret = sev_snp_launch_start(sev);
> +    } else {
> +        ret = sev_launch_start(sev);
> +    }
> +
>      if (ret) {
>          error_setg(errp, "%s: failed to create encryption context", __func__);
>          goto err;
> diff --git a/target/i386/trace-events b/target/i386/trace-events
> index 2cd8726eeb..18cc14b956 100644
> --- a/target/i386/trace-events
> +++ b/target/i386/trace-events
> @@ -11,3 +11,4 @@ kvm_sev_launch_measurement(const char *value) "data %s"
>  kvm_sev_launch_finish(void) ""
>  kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa 0x%" PRIx64 " hva 0x%" PRIx64 " data 0x%" PRIx64 " len %d"
>  kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
> +kvm_sev_snp_launch_start(uint64_t policy) "policy 0x%" PRIx64
> 

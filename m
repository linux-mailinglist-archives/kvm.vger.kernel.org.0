Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FB3271B08
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 08:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgIUGph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 02:45:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726011AbgIUGpg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 02:45:36 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08L6XCpx121323;
        Mon, 21 Sep 2020 02:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Qc+TFvGdxkbzSsv1yg1yWx1oPyx1PkEfeCodzvuGZo4=;
 b=CYrW6eAShvqWn23QIKnpprhrsJnjI0bqxovMQBHV06uTByjxOv257BQTQsMun2TbWIwY
 0YrZWF2YelX4wF+T6AIc4qGTkGjJNd4YcqqRLLwSaN7Jj6YilZ6cEKuAnpg/r0xJSGN7
 +0b7Q3kCVvLLZJtSjW/u+vw30HWuVdalZr21AY/JV8/jeyF7t1HE0N4m8QuZqCqN7Mq1
 hsQf8fn7YupstrkxZe5v6rVya9NiEMrBvLcsLrJ4is5BjI4QgElj0Dwb6QcrB0U+4lQB
 lVkzyvw1VmHUzcXxqCnB9Gth7PCEEoazjevygTqYnKwLV7NoZ+3u2G2ZOApEq1EfqObG aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33pprhgjye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 02:45:16 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08L6YMq8124106;
        Mon, 21 Sep 2020 02:45:15 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33pprhgjwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 02:45:13 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08L6bEro007577;
        Mon, 21 Sep 2020 06:45:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 33n9m7rvfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 06:45:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08L6j7lw26738998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 06:45:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73A6A5206D;
        Mon, 21 Sep 2020 06:45:07 +0000 (GMT)
Received: from [9.65.232.226] (unknown [9.65.232.226])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 13F3852054;
        Mon, 21 Sep 2020 06:45:03 +0000 (GMT)
From:   Dov Murik <dovmurik@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/5] sev/i386: Add initial support for SEV-ES
To:     Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Richard Henderson <rth@twiddle.net>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
 <e2456cc461f329f52aa6eb3fcd0d0ce9451b8fa7.1600205384.git.thomas.lendacky@amd.com>
Message-ID: <e8cf44ef-3180-8922-5f0a-2ce532005e51@linux.vnet.ibm.com>
Date:   Mon, 21 Sep 2020 09:45:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <e2456cc461f329f52aa6eb3fcd0d0ce9451b8fa7.1600205384.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_01:2020-09-21,2020-09-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1011 mlxscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210049
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/2020 0:29, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Provide initial support for SEV-ES. This includes creating a function to
> indicate the guest is an SEV-ES guest (which will return false until all
> support is in place), performing the proper SEV initialization and
> ensuring that the guest CPU state is measured as part of the launch.
> 
> Co-developed-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>   target/i386/cpu.c      |  1 +
>   target/i386/sev-stub.c |  5 +++++
>   target/i386/sev.c      | 46 ++++++++++++++++++++++++++++++++++++++++--
>   target/i386/sev_i386.h |  1 +
>   4 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 588f32e136..bbbe581d35 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -5969,6 +5969,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>           break;
>       case 0x8000001F:
>           *eax = sev_enabled() ? 0x2 : 0;
> +        *eax |= sev_es_enabled() ? 0x8 : 0;
>           *ebx = sev_get_cbit_position();
>           *ebx |= sev_get_reduced_phys_bits() << 6;
>           *ecx = 0;
> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> index 88e3f39a1e..040ac90563 100644
> --- a/target/i386/sev-stub.c
> +++ b/target/i386/sev-stub.c
> @@ -49,3 +49,8 @@ SevCapability *sev_get_capabilities(Error **errp)
>       error_setg(errp, "SEV is not available in this QEMU");
>       return NULL;
>   }
> +
> +bool sev_es_enabled(void)
> +{
> +    return false;
> +}
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index c3ecf86704..6c9cd0854b 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -359,6 +359,12 @@ sev_enabled(void)
>       return !!sev_guest;
>   }
> 
> +bool
> +sev_es_enabled(void)
> +{
> +    return false;
> +}
> +
>   uint64_t
>   sev_get_me_mask(void)
>   {
> @@ -578,6 +584,22 @@ sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
>       return ret;
>   }
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
> +        goto err;

goto (and the err: label) is not needed.

> +    }
> +
> +err:
> +    return ret;
> +}
> +
>   static void
>   sev_launch_get_measure(Notifier *notifier, void *unused)
>   {
> @@ -590,6 +612,14 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
>           return;
>       }
> 
> +    if (sev_es_enabled()) {
> +        /* measure all the VM save areas before getting launch_measure */
> +        ret = sev_launch_update_vmsa(sev);
> +        if (ret) {
> +            exit(1);

Other error cases in this function just return on error. Why quit QEMU here?

> +        }
> +    }
> +
>       measurement = g_new0(struct kvm_sev_launch_measure, 1);
> 
>       /* query the measurement blob length */
> @@ -684,7 +714,7 @@ sev_guest_init(const char *id)
>   {
>       SevGuestState *sev;
>       char *devname;
> -    int ret, fw_error;
> +    int ret, fw_error, cmd;
>       uint32_t ebx;
>       uint32_t host_cbitpos;
>       struct sev_user_data_status status = {};
> @@ -745,8 +775,20 @@ sev_guest_init(const char *id)
>       sev->api_major = status.api_major;
>       sev->api_minor = status.api_minor;
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
>       trace_kvm_sev_init();
> -    ret = sev_ioctl(sev->sev_fd, KVM_SEV_INIT, NULL, &fw_error);
> +    ret = sev_ioctl(sev->sev_fd, cmd, NULL, &fw_error);
>       if (ret) {
>           error_report("%s: failed to initialize ret=%d fw_error=%d '%s'",
>                        __func__, ret, fw_error, fw_error_to_str(fw_error));
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index 4db6960f60..4f9a5e9b21 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -29,6 +29,7 @@
>   #define SEV_POLICY_SEV          0x20
> 
>   extern bool sev_enabled(void);
> +extern bool sev_es_enabled(void);
>   extern uint64_t sev_get_me_mask(void);
>   extern SevInfo *sev_get_info(void);
>   extern uint32_t sev_get_cbit_position(void);
> 

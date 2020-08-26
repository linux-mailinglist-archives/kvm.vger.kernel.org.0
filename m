Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F44F2537DF
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgHZTHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:07:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55239 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726753AbgHZTHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:07:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598468868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fVep2B4rylS0bpaULAVyUSCm0CgEUUj39CpboLrO51k=;
        b=Svcsmld1zTctYlWAS1J9CU5pTf6jCba7tDCSD4Asqv1kxPZNYHjRxpIsYtPBEPM+SAMY9Q
        63vJbz8r+MveI2E+KX5HpgxQQ188hXIVeRJlZVm//VSEMrj6b1rCiR2WCgLpDVMqljVxaW
        F0ZsJghyJzqdY/C+bFkijfMZ1y81pq8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-WgSW7xsbP3WEbIRdz55YQw-1; Wed, 26 Aug 2020 15:07:38 -0400
X-MC-Unique: WgSW7xsbP3WEbIRdz55YQw-1
Received: by mail-qt1-f197.google.com with SMTP id z16so2517000qtq.16
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 12:07:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fVep2B4rylS0bpaULAVyUSCm0CgEUUj39CpboLrO51k=;
        b=MsHP2KdAeAEmxUvnPNILEb4D2zt2KDijdrKdOImvDn3YUXTZ6OPqafn0gwHMIYo7mV
         u4078FvY/VCSUVdgbbWhc41ly7cyZLSNY659+bhSKyHUZ1voPZC5s3uz+6UiZ860UzV3
         sgvgxJgNjs0TsENaEgpz7RpN8/sWq3lCSg14FPChyr2SbghpHOK5CX8QU8kB9kcZZ1Df
         OZLGkgw4RvvbKJ+5ySzjytxm+A+uAe7v1BpI1CxQg8q6dLCOtwX59QkxJsanrzHHEyxy
         ReRhsk/nQ3HoGY7kSASumFiKaG2RXTgqdZDp2J4Q/ZYM9t8RxPFf5524iFxInFFzPlbC
         0p4g==
X-Gm-Message-State: AOAM530vr+yF/s/04p+IyZ6cyMV4rxQosdglG3iafmEs8xHVroUbheQd
        EP2b1ZkMBNhhMHfuero0crDlEYPfiCl9WtSUMLepUgnxqT/BF2/H/NJrT76SaKdr3kAcHPBya1i
        Cir7NEuI/BKN/
X-Received: by 2002:ac8:1084:: with SMTP id a4mr14612385qtj.83.1598468857708;
        Wed, 26 Aug 2020 12:07:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbtnHxoGSfcMZAVv7fv0lcuMNBfecaNShlXNMgjz/Ckru2Tt4MhmjttcwCvlM5BTy/2lSDFQ==
X-Received: by 2002:ac8:1084:: with SMTP id a4mr14612350qtj.83.1598468857391;
        Wed, 26 Aug 2020 12:07:37 -0700 (PDT)
Received: from [192.168.0.172] (ip68-103-222-6.ks.ok.cox.net. [68.103.222.6])
        by smtp.gmail.com with ESMTPSA id l5sm2376635qkk.134.2020.08.26.12.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:07:36 -0700 (PDT)
Subject: Re: [PATCH 1/4] sev/i386: Add initial support for SEV-ES
To:     Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <cover.1598382343.git.thomas.lendacky@amd.com>
 <88dc46aaedd17a3509d7546a622a9754dad895cb.1598382343.git.thomas.lendacky@amd.com>
From:   Connor Kuehl <ckuehl@redhat.com>
Message-ID: <9cd2e58f-dfa2-e2ae-4886-dc194318c411@redhat.com>
Date:   Wed, 26 Aug 2020 14:07:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <88dc46aaedd17a3509d7546a622a9754dad895cb.1598382343.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/20 2:05 PM, Tom Lendacky wrote:
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

Hi Tom!

Overall I think the patch set looks good. I mainly just have 1 question 
regarding some error handling and a couple of checkpatch related messages.

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

I don't think this bothers checkpatch, but it'd be consistent with the 
rest of your series if this function put the return type on the line above.

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

Disclaimer: I'm still learning the QEMU source code, sorry if this comes 
across as naive.

Is exit() what we want here? I was looking around the rest of the source 
code and unfortunately the machine_init_done_notifiers mechanism doesn't 
allow for a return value to indicate an error, so I'm wondering if 
there's a more appropriate place in the initialization code to handle 
these fallible operations and if so, propagate the error down. This way 
if there are other resources that need to be cleaned up on the way out, 
they can be. Thoughts?

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


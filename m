Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4D06656C6
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 10:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjAKI7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 03:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236548AbjAKI6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 03:58:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4335310543
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 00:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673427450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oCZp470aw4dEjZsFd+fqL7Enxs229S6a8dCK934dTM4=;
        b=fXAI507MYdCxP3nd+/FqyNQ+LS5Sn4ENRX7y8tFIP2112C2PCmeXhSM8o4LiW3foW4pg45
        qKqFJojx1bVsKkBjEI4QIb/N/8nAkXUEIz2AdSkMOMnv03JG4rOxgxavMq86oXmYsi5xJN
        WKYi3O3wRa6lpm12xVLyD+xakWvZTAg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-515-B6RypQxSN8CYiVzgEMd5zg-1; Wed, 11 Jan 2023 03:57:28 -0500
X-MC-Unique: B6RypQxSN8CYiVzgEMd5zg-1
Received: by mail-qt1-f198.google.com with SMTP id e18-20020ac84912000000b003a96d6f436fso6890496qtq.0
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 00:57:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oCZp470aw4dEjZsFd+fqL7Enxs229S6a8dCK934dTM4=;
        b=lZ25ZxopWMUTAJPvtCcAaz54PIK69srQ9a/reT+7JhKCkBZ1PoUYRo0WHGcGTwKbG/
         4ihs4QjALfiCO8B+40cZzjQu0Lw5NZOxFvMKsl96ZjtQusuftpU+elzO6eTbEnAaxdoc
         eMSGOf0ljQ4dc4uLDvm/hXmIsRFJc9ff4DizScaGG1jgMkJzLWFCy2hLFcV+TSycu4+k
         1CXC2GolwqN/o5ZPyJGZ6+xQA9IzIspXO5vsxP8nNd7s7E89FxlzXDU86YzJ9azyFml6
         6TB69YaTIKuoEO30Y4kn3FN5rg6RooiZBO6KSg5HUUNQe4ZhAS7DvTc0pxTwfkOD2KON
         HZMA==
X-Gm-Message-State: AFqh2kolFOTILpLP3VWo7yImtOeWAbT7HwxubbAYXVQogh/71P+elYJJ
        qQNqWr494LLcHcHZ95RC0pJObtkGfDeiN/hSxb9jnWbxFf+i6xCxvCMk1BaGYSF7GSC9G/Qe1ww
        26uoUv9srRuKL
X-Received: by 2002:ac8:41d4:0:b0:3a5:402:4bcf with SMTP id o20-20020ac841d4000000b003a504024bcfmr99558554qtm.24.1673427448210;
        Wed, 11 Jan 2023 00:57:28 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtf1DVxBh1iPHh4gDjTTUs+xnP/MFMBHIprnZ9rnb16rmsqdKgzvommHBXUsn7MSOg1haxENA==
X-Received: by 2002:ac8:41d4:0:b0:3a5:402:4bcf with SMTP id o20-20020ac841d4000000b003a504024bcfmr99558532qtm.24.1673427447981;
        Wed, 11 Jan 2023 00:57:27 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-91.web.vodafone.de. [109.43.176.91])
        by smtp.gmail.com with ESMTPSA id t20-20020a05622a149400b0035d432f5ba3sm7371201qtx.17.2023.01.11.00.57.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 00:57:27 -0800 (PST)
Message-ID: <e65bce5b-977c-ed19-9562-3af8ee8e9fba@redhat.com>
Date:   Wed, 11 Jan 2023 09:57:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v14 04/11] s390x/sclp: reporting the maximum nested
 topology entries
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-5-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230105145313.168489-5-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/01/2023 15.53, Pierre Morel wrote:
> The maximum nested topology entries is used by the guest to know
> how many nested topology are available on the machine.
> 
> Currently, SCLP READ SCP INFO reports MNEST = 0, which is the
> equivalent of reporting the default value of 2.
> Let's use the default SCLP value of 2 and increase this value in the
> future patches implementing higher levels.

I'm confused ... so does a SCLP value of 2 mean a MNEST level of 4 ?

> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   include/hw/s390x/sclp.h | 5 +++--
>   hw/s390x/sclp.c         | 4 ++++
>   2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
> index 712fd68123..4ce852473c 100644
> --- a/include/hw/s390x/sclp.h
> +++ b/include/hw/s390x/sclp.h
> @@ -112,12 +112,13 @@ typedef struct CPUEntry {
>   } QEMU_PACKED CPUEntry;
>   
>   #define SCLP_READ_SCP_INFO_FIXED_CPU_OFFSET     128
> -#define SCLP_READ_SCP_INFO_MNEST                2
> +#define SCLP_READ_SCP_INFO_MNEST                4

... since you update it to 4 here.

>   typedef struct ReadInfo {
>       SCCBHeader h;
>       uint16_t rnmax;
>       uint8_t rnsize;
> -    uint8_t  _reserved1[16 - 11];       /* 11-15 */
> +    uint8_t  _reserved1[15 - 11];       /* 11-14 */
> +    uint8_t  stsi_parm;                 /* 15-16 */
>       uint16_t entries_cpu;               /* 16-17 */
>       uint16_t offset_cpu;                /* 18-19 */
>       uint8_t  _reserved2[24 - 20];       /* 20-23 */
> diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
> index eff74479f4..07e3cb4cac 100644
> --- a/hw/s390x/sclp.c
> +++ b/hw/s390x/sclp.c
> @@ -20,6 +20,7 @@
>   #include "hw/s390x/event-facility.h"
>   #include "hw/s390x/s390-pci-bus.h"
>   #include "hw/s390x/ipl.h"
> +#include "hw/s390x/cpu-topology.h"
>   
>   static inline SCLPDevice *get_sclp_device(void)
>   {
> @@ -125,6 +126,9 @@ static void read_SCP_info(SCLPDevice *sclp, SCCB *sccb)
>   
>       /* CPU information */
>       prepare_cpu_entries(machine, entries_start, &cpu_count);
> +    if (s390_has_topology()) {
> +        read_info->stsi_parm = SCLP_READ_SCP_INFO_MNEST;

This seems to be in contradiction to what you've said in the commit 
description - you set it to 4 and not to 2.

  Thomas


> +    }
>       read_info->entries_cpu = cpu_to_be16(cpu_count);
>       read_info->offset_cpu = cpu_to_be16(offset_cpu);
>       read_info->highest_cpu = cpu_to_be16(machine->smp.max_cpus - 1);


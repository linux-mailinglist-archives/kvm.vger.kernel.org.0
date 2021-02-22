Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCEB321E77
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 18:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhBVRrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 12:47:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231673AbhBVRrt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 12:47:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614015982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a3xauJaR66hfM3jitPOYh7RFO07zXJKYLcWPgDvmEWs=;
        b=PaUN9kSw/Dj9bhsaTEmJSH3renZze1rqu9xofHsz1Bk4bv5GDAqlrpjJNYCsX3BYGSDFhZ
        m7c5SY7jbZgxc81RmugyjdYZ0oYo0PhnUvJV5hhU1C6OjQil2OQbgfANzIRjCnu70NB4qb
        lwD+xdQbOsTT+a+bYmc0MfcawewiQSo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-ysP5spelNoCoFUPBiHhxnA-1; Mon, 22 Feb 2021 12:46:21 -0500
X-MC-Unique: ysP5spelNoCoFUPBiHhxnA-1
Received: by mail-ed1-f69.google.com with SMTP id j10so7414995edv.5
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 09:46:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a3xauJaR66hfM3jitPOYh7RFO07zXJKYLcWPgDvmEWs=;
        b=HhHTpCoh3uxVdJOsTlwtRfqYved8gWMzr2+an9mKbDR0MUQFXd0u+4znBRCm9Qwi8i
         MEnpgCaLvjc+xISggFy4lgoLqXAAo6ZzLTxnCI0d6shjYiESMSlvVqGbzGlYzTTIEwYQ
         bs4OI78mjDBQdCzIxB3lii5n14fW/Af1e0SU7nnszS0aVKBW12SqIJbGahGV0ZlK6tkK
         RbllGzlxBDaKIRZvyhx25iIm7YEQrK6Hb4JstC8JsQQHoDwClVjSLX1lfRubSgl4PWNC
         l1Y5MgO9rgScMplLlVBE5n+akKW+pnW44eA/7l8FShLDDj5otOfAsTYoKEdAllJo44QN
         7kSA==
X-Gm-Message-State: AOAM533vM99NyBSQ4H3j9n8MA4z6kCIEGFhOWWvl+IfKmJ/m19ahFfM0
        Ej/5y92f6sYagkCVP4QadxNGBh3WTK0LQAAH2eHpqUbOA1xEpzt8hR1pU8h5OqEegaEhhBHDOX9
        xLd/bIgSCi22Z
X-Received: by 2002:a05:6402:17b6:: with SMTP id j22mr23112092edy.325.1614015978954;
        Mon, 22 Feb 2021 09:46:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDAve+ys1o3Ix/SlRK4csT4W1S2Ma59p+Xf1UMouPtJ1ZRfjAz9b8cjfXQB2d67f6WzKBREw==
X-Received: by 2002:a05:6402:17b6:: with SMTP id j22mr23112063edy.325.1614015978791;
        Mon, 22 Feb 2021 09:46:18 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id s2sm8446265edt.35.2021.02.22.09.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 09:46:18 -0800 (PST)
Subject: Re: [PATCH v2 02/11] hw/boards: Introduce
 machine_class_valid_for_accelerator()
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
References: <20210219173847.2054123-1-philmd@redhat.com>
 <20210219173847.2054123-3-philmd@redhat.com>
 <20210222183400.0c151d46.cohuck@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <6ceff55c-6da4-e773-7809-de3be2f566ab@redhat.com>
Date:   Mon, 22 Feb 2021 18:46:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222183400.0c151d46.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/21 6:34 PM, Cornelia Huck wrote:
> On Fri, 19 Feb 2021 18:38:38 +0100
> Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
> 
>> Introduce the valid_accelerators[] field to express the list
>> of valid accelators a machine can use, and add the
>> machine_class_valid_for_current_accelerator() and
>> machine_class_valid_for_accelerator() methods.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  include/hw/boards.h | 24 ++++++++++++++++++++++++
>>  hw/core/machine.c   | 26 ++++++++++++++++++++++++++
>>  2 files changed, 50 insertions(+)
>>
>> diff --git a/include/hw/boards.h b/include/hw/boards.h
>> index 68d3d10f6b0..4d08bc12093 100644
>> --- a/include/hw/boards.h
>> +++ b/include/hw/boards.h
>> @@ -36,6 +36,24 @@ void machine_set_cpu_numa_node(MachineState *machine,
>>                                 const CpuInstanceProperties *props,
>>                                 Error **errp);
>>  
>> +/**
>> + * machine_class_valid_for_accelerator:
>> + * @mc: the machine class
>> + * @acc_name: accelerator name
>> + *
>> + * Returns %true if the accelerator is valid for the machine, %false
>> + * otherwise. See #MachineClass.valid_accelerators.
> 
> Naming confusion: is the machine class valid for the accelerator, or
> the accelerator valid for the machine class? Or either? :)

"the accelerator valid for the machine class".

Is this clearer?

"Returns %true if the current accelerator is valid for the
 selected machine, %false otherwise.

Or...

"Returns %true if the selected accelerator is valid for the
 current machine, %false otherwise.

How would look "either"?

The machine is already selected, and the accelerator too...

> 
>> + */
>> +bool machine_class_valid_for_accelerator(MachineClass *mc, const char *acc_name);
>> +/**
>> + * machine_class_valid_for_current_accelerator:
>> + * @mc: the machine class
>> + *
>> + * Returns %true if the accelerator is valid for the current machine,
>> + * %false otherwise. See #MachineClass.valid_accelerators.
> 
> Same here: current accelerator vs. current machine.
> 
>> + */
>> +bool machine_class_valid_for_current_accelerator(MachineClass *mc);
>> +
>>  void machine_class_allow_dynamic_sysbus_dev(MachineClass *mc, const char *type);
>>  /*
>>   * Checks that backend isn't used, preps it for exclusive usage and
>> @@ -125,6 +143,11 @@ typedef struct {
>>   *    should instead use "unimplemented-device" for all memory ranges where
>>   *    the guest will attempt to probe for a device that QEMU doesn't
>>   *    implement and a stub device is required.
>> + * @valid_accelerators:
>> + *    If this machine supports a specific set of virtualization accelerators,
>> + *    this contains a NULL-terminated list of the accelerators that can be
>> + *    used. If this field is not set, any accelerator is valid. The QTest
>> + *    accelerator is always valid.
>>   * @kvm_type:
>>   *    Return the type of KVM corresponding to the kvm-type string option or
>>   *    computed based on other criteria such as the host kernel capabilities
>> @@ -166,6 +189,7 @@ struct MachineClass {
>>      const char *alias;
>>      const char *desc;
>>      const char *deprecation_reason;
>> +    const char *const *valid_accelerators;
>>  
>>      void (*init)(MachineState *state);
>>      void (*reset)(MachineState *state);
>> diff --git a/hw/core/machine.c b/hw/core/machine.c
>> index 970046f4388..c42d8e382b1 100644
>> --- a/hw/core/machine.c
>> +++ b/hw/core/machine.c
>> @@ -518,6 +518,32 @@ static void machine_set_nvdimm_persistence(Object *obj, const char *value,
>>      nvdimms_state->persistence_string = g_strdup(value);
>>  }
>>  
>> +bool machine_class_valid_for_accelerator(MachineClass *mc, const char *acc_name)
>> +{
>> +    const char *const *name = mc->valid_accelerators;
>> +
>> +    if (!name) {
>> +        return true;
>> +    }
>> +    if (strcmp(acc_name, "qtest") == 0) {
>> +        return true;
>> +    }
>> +
>> +    for (unsigned i = 0; name[i]; i++) {
>> +        if (strcasecmp(acc_name, name[i]) == 0) {
>> +            return true;
>> +        }
>> +    }
>> +    return false;
>> +}
>> +
>> +bool machine_class_valid_for_current_accelerator(MachineClass *mc)
>> +{
>> +    AccelClass *ac = ACCEL_GET_CLASS(current_accel());
>> +
>> +    return machine_class_valid_for_accelerator(mc, ac->name);
>> +}
> 
> The implementation of the function tests for the current accelerator,
> so I think you need to tweak the description above?
> 
>> +
>>  void machine_class_allow_dynamic_sysbus_dev(MachineClass *mc, const char *type)
>>  {
>>      QAPI_LIST_PREPEND(mc->allowed_dynamic_sysbus_devices, g_strdup(type));
> 


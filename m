Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E67399BB9
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 09:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhFCHk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 03:40:26 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57870 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhFCHkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 03:40:25 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7C3CA1FD46;
        Thu,  3 Jun 2021 07:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622705920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uEFBfMk89CyrYPSomeys4aMs+J0TYiVniiUJB/Uavhg=;
        b=sbVqsdKOildIq409Ijh+4G6ndLCORuarpYPxcT10xZ+ga4/kO830EAKO+v5xzLyPGwmJH9
        xksenIZFgDjO5VdZe5BOCjI50kKzBqXoRU0r8G2e2w7Q3/uMgglfaYXpAplpsdUn1lCK9B
        FntZHgNNvWB94pLpnKMGzxKP9fphpu8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622705920;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uEFBfMk89CyrYPSomeys4aMs+J0TYiVniiUJB/Uavhg=;
        b=LNPgUtahS+Y2aPGXiM+CD5k+yu3ptIJEO25FYAxLaCS9JXfvZTOQ5VE3fBwzfghmon0H0e
        2yciagfUCcBoiGDQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 21D50118DD;
        Thu,  3 Jun 2021 07:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622705920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uEFBfMk89CyrYPSomeys4aMs+J0TYiVniiUJB/Uavhg=;
        b=sbVqsdKOildIq409Ijh+4G6ndLCORuarpYPxcT10xZ+ga4/kO830EAKO+v5xzLyPGwmJH9
        xksenIZFgDjO5VdZe5BOCjI50kKzBqXoRU0r8G2e2w7Q3/uMgglfaYXpAplpsdUn1lCK9B
        FntZHgNNvWB94pLpnKMGzxKP9fphpu8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622705920;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uEFBfMk89CyrYPSomeys4aMs+J0TYiVniiUJB/Uavhg=;
        b=LNPgUtahS+Y2aPGXiM+CD5k+yu3ptIJEO25FYAxLaCS9JXfvZTOQ5VE3fBwzfghmon0H0e
        2yciagfUCcBoiGDQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id XlgtBgCHuGCYGAAALh3uQQ
        (envelope-from <cfontana@suse.de>); Thu, 03 Jun 2021 07:38:40 +0000
Subject: Re: [PATCH 2/2] i386: run accel_cpu_instance_init as
 instance_post_init
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-devel@nongnu.org
References: <20210529091313.16708-1-cfontana@suse.de>
 <20210529091313.16708-3-cfontana@suse.de>
 <20210601185955.upjlobdgi366ruhh@habkost.net>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <8251d2d7-8e55-1272-4d72-ebb4633f78de@suse.de>
Date:   Thu, 3 Jun 2021 09:38:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210601185955.upjlobdgi366ruhh@habkost.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/21 8:59 PM, Eduardo Habkost wrote:
> On Sat, May 29, 2021 at 11:13:13AM +0200, Claudio Fontana wrote:
>> This partially fixes host and max cpu initialization,
>> by running the accel cpu initialization only after all instance
>> init functions are called for all X86 cpu subclasses.
> 
> Can you describe what exactly are the initialization ordering
> dependencies that were broken?
> 
>>
>> Partial Fix.
> 
> What does "partial fix" mean?

Hi Eduardo, this is in response to the report that Windows + UEFI is not booting anymore:

https://lists.gnu.org/archive/html/qemu-devel/2021-05/msg06692.html

Probably "Partial Fix" does not make sense in the context of the commit log, as there the context of the overall issue is not present.

> 
>>
>> Fixes: 48afe6e4eabf ("i386: split cpu accelerators from cpu.c, using AccelCPUClass")
>> Signed-off-by: Claudio Fontana <cfontana@suse.de>
> 
> The fix looks simple and may be obvious, my only concerns are:
> 
> 1. Testing.  Luckily we are a bit early in the release cycle so
>    we have some time for that.


Indeed, and unfortunately neither make check nor gitlab CI capture this issue.
Smoke testing a boot with OVMF_VARS.secboot.fd does:

./build/x86_64-softmmu/qemu-system-x86_64 \
        -cpu host \
        -enable-kvm \
        -name test,debug-threads=on \
        -smp 1,threads=1,cores=1,sockets=1 \
        -m 4G \
        -net nic -net user \
        -boot d,menu=on \
        -usbdevice tablet \
        -machine q35,smm=on \
        -drive if=pflash,format=raw,readonly=on,unit=0,file="./OVMF_CODE.secboot.fd" \
        -drive if=pflash,format=raw,unit=1,file="./OVMF_VARS.secboot.fd" \
        -global ICH9-LPC.disable_s3=1 \
        -global driver=cfi.pflash01,property=secure,value=on \
        -cdrom "./Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.ISO" \
        -device ahci,id=ahci

> 2. Describing more clearly what exactly was wrong.  This can be
>    fixed manually in the commit message when applying the patch.
> 

"max features" cpu models (cpu "max" and "host", which is child of "max") rely on the instance initialization code
to set max_features = true;

this is then checked during feature expansion to add features not explicitly set by the user.

The original code in the instance initialization was performing different actions depending on the accelerator,
with a fallback "else" that was used to set properties for TCG and all other accelerators not explicitly handled (KVM and HVF).

My patch went on to split the code that was accelerator-specific, into kvm accel-cpu and hvf accel-cpu,
to perform the accelerator-specific initializations there, for the case where cpu->max_features is true.

However I inserted the call to the accel cpu initialization at the end of the x86 base class code initialization (x86_cpu_initfn).

That was wrong, because the code in the accel cpu for KVM, for example, ends up being called _before_ the subclass ("max") initialization,
so it has no chance to see "max_features = true", and so does not initialize the KVM properties.
And further, since the subclass "max" code gets called after kvm-cpu accel, it goes on and writes defaults properties that were supposed to be overridden for the KVM specialization.


> 
> An even better long term solution would be removing the
> initialization ordering dependencies and make
> accel_cpu_instance_init() safe to be called earlier.  Would that
> be doable?


I think that the max_features mechanism would need to be reworked for that, currently I do not see how to make this doable with the existing way x86 is initialized and realized.

If the post_init method works for everybody I personally think we should go with that,
along with an improvement of our tests (make check + CI) to capture such problems specifically looking at cpu "max" and "host".

Thanks,

Claudio

> 
> 
>> ---
>>  target/i386/cpu.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 6bcb7dbc2c..ae148fbd2f 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -6422,6 +6422,11 @@ static void x86_cpu_register_feature_bit_props(X86CPUClass *xcc,
>>      x86_cpu_register_bit_prop(xcc, name, w, bitnr);
>>  }
>>  
>> +static void x86_cpu_post_initfn(Object *obj)
>> +{
>> +    accel_cpu_instance_init(CPU(obj));
>> +}
>> +
>>  static void x86_cpu_initfn(Object *obj)
>>  {
>>      X86CPU *cpu = X86_CPU(obj);
>> @@ -6473,9 +6478,6 @@ static void x86_cpu_initfn(Object *obj)
>>      if (xcc->model) {
>>          x86_cpu_load_model(cpu, xcc->model);
>>      }
>> -
>> -    /* if required, do accelerator-specific cpu initializations */
>> -    accel_cpu_instance_init(CPU(obj));
>>  }
>>  
>>  static int64_t x86_cpu_get_arch_id(CPUState *cs)
>> @@ -6810,6 +6812,8 @@ static const TypeInfo x86_cpu_type_info = {
>>      .parent = TYPE_CPU,
>>      .instance_size = sizeof(X86CPU),
>>      .instance_init = x86_cpu_initfn,
>> +    .instance_post_init = x86_cpu_post_initfn,
>> +
>>      .abstract = true,
>>      .class_size = sizeof(X86CPUClass),
>>      .class_init = x86_cpu_common_class_init,
>> -- 
>> 2.26.2
>>
> 


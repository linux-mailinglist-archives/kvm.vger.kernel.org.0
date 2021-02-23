Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AFC322973
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 12:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhBWLZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 06:25:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50788 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231591AbhBWLZU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 06:25:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614079433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fqXHpRX9rxmTQG166I9+zJJichU2jtp55FS+xZ4AgUs=;
        b=V8QhmDZDsPRLyTSyb4mSzCxKqXi6SB/3ZtA3vEAgYj72RrcHSKMloGp1O/D+O/1K0AZYA8
        ykrjqbI4m8gTMx4W27z0OYgH9aWKxasnAaz4xYCibOUsu3UfUFpMegSNr176l+uKpb22Kz
        gRIwQhoCchkCDgLIxfuvUXgqZvz4tFg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-mkLq8VJxPJ6VnYB2hVYzsg-1; Tue, 23 Feb 2021 06:23:50 -0500
X-MC-Unique: mkLq8VJxPJ6VnYB2hVYzsg-1
Received: by mail-wr1-f69.google.com with SMTP id v3so725262wro.21
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 03:23:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fqXHpRX9rxmTQG166I9+zJJichU2jtp55FS+xZ4AgUs=;
        b=p6YWHWpX14oAG6JYgn2J535xE6Ph+R3xVwQR3BBw9+pGt9cE+E6BhafatQW/r5nZ/V
         mder42GfWbe+Qi091xtFnTQxhksdrPIBI3qjToV0jXBzobvyKj/+0RsCc2xBw/7mkSZ3
         iPv14sQHMcKUZzWX8ZGCFYsR72Too7msMXsf8fcYDetaMqFI6vmi9WJUdPP+BYybu4LR
         2AaYd6351K8MH4yVUseOFoESmiTKBOvxZ1F07OlU1r2ZdtQ3ahkvlepPiCIJ0DzQ4YHs
         f5wLn4vZhaQF1gF20i0/ON3kLErGXbYD+7A5BfrezUrVNw1k3aBBhT6hLMX0FmOel9NK
         wTAw==
X-Gm-Message-State: AOAM530gOmt7uJlu4e5lN5CAVGCj53PyebOrAXjFXIT0kv1LoJO9kGQ6
        mjaXefDqQytetYw60TUz704p41Y+iTJ1oMnvkvYqJ5PLhRjF60UHHTggZSucJS1Jokuec92m5Z2
        Ax85Bs72t6lqN
X-Received: by 2002:adf:e444:: with SMTP id t4mr15063406wrm.97.1614079429523;
        Tue, 23 Feb 2021 03:23:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwL+4SwYURVZHwXSt7T2jcYFKjCeE7PCTmR6MVNodayFVhJQhTgY/EVJ9CycKefcbMINHdzhQ==
X-Received: by 2002:adf:e444:: with SMTP id t4mr15063387wrm.97.1614079429294;
        Tue, 23 Feb 2021 03:23:49 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id a3sm4521531wrt.68.2021.02.23.03.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 03:23:48 -0800 (PST)
Subject: Re: [PATCH v2 01/11] accel/kvm: Check MachineClass kvm_type() return
 value
To:     Cornelia Huck <cohuck@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        kvm@vger.kernel.org, BALATON Zoltan <balaton@eik.bme.hu>,
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
 <20210219173847.2054123-2-philmd@redhat.com>
 <20210222182405.3e6e9a6f.cohuck@redhat.com>
 <bc37276d-74cc-22f0-fcc0-4ee5e62cf1df@redhat.com>
 <20210222185044.23fccecc.cohuck@redhat.com>
 <YDQ/Y1KozPSyNGjo@yekko.fritz.box> <YDRAHW1ds1eh0Lav@yekko.fritz.box>
 <20210223113634.6626c8f8.cohuck@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <98ed9478-240d-cd20-ac84-82c540bd3e21@redhat.com>
Date:   Tue, 23 Feb 2021 12:23:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223113634.6626c8f8.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/21 11:36 AM, Cornelia Huck wrote:
> On Tue, 23 Feb 2021 10:37:01 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
> 
>> On Tue, Feb 23, 2021 at 10:33:55AM +1100, David Gibson wrote:
>>> On Mon, Feb 22, 2021 at 06:50:44PM +0100, Cornelia Huck wrote:  
>>>> On Mon, 22 Feb 2021 18:41:07 +0100
>>>> Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
>>>>   
>>>>> On 2/22/21 6:24 PM, Cornelia Huck wrote:  
>>>>>> On Fri, 19 Feb 2021 18:38:37 +0100
>>>>>> Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
>>>>>>     
>>>>>>> MachineClass::kvm_type() can return -1 on failure.
>>>>>>> Document it, and add a check in kvm_init().
>>>>>>>
>>>>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>>>>>> ---
>>>>>>>  include/hw/boards.h | 3 ++-
>>>>>>>  accel/kvm/kvm-all.c | 6 ++++++
>>>>>>>  2 files changed, 8 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/include/hw/boards.h b/include/hw/boards.h
>>>>>>> index a46dfe5d1a6..68d3d10f6b0 100644
>>>>>>> --- a/include/hw/boards.h
>>>>>>> +++ b/include/hw/boards.h
>>>>>>> @@ -127,7 +127,8 @@ typedef struct {
>>>>>>>   *    implement and a stub device is required.
>>>>>>>   * @kvm_type:
>>>>>>>   *    Return the type of KVM corresponding to the kvm-type string option or
>>>>>>> - *    computed based on other criteria such as the host kernel capabilities.
>>>>>>> + *    computed based on other criteria such as the host kernel capabilities
>>>>>>> + *    (which can't be negative), or -1 on error.
>>>>>>>   * @numa_mem_supported:
>>>>>>>   *    true if '--numa node.mem' option is supported and false otherwise
>>>>>>>   * @smp_parse:
>>>>>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>>>>>> index 84c943fcdb2..b069938d881 100644
>>>>>>> --- a/accel/kvm/kvm-all.c
>>>>>>> +++ b/accel/kvm/kvm-all.c
>>>>>>> @@ -2057,6 +2057,12 @@ static int kvm_init(MachineState *ms)
>>>>>>>                                                              "kvm-type",
>>>>>>>                                                              &error_abort);
>>>>>>>          type = mc->kvm_type(ms, kvm_type);
>>>>>>> +        if (type < 0) {
>>>>>>> +            ret = -EINVAL;
>>>>>>> +            fprintf(stderr, "Failed to detect kvm-type for machine '%s'\n",
>>>>>>> +                    mc->name);
>>>>>>> +            goto err;
>>>>>>> +        }
>>>>>>>      }
>>>>>>>  
>>>>>>>      do {    
>>>>>>
>>>>>> No objection to this patch; but I'm wondering why some non-pseries
>>>>>> machines implement the kvm_type callback, when I see the kvm-type
>>>>>> property only for pseries? Am I holding my git grep wrong?    
>>>>>
>>>>> Can it be what David commented here?
>>>>> https://www.mail-archive.com/qemu-devel@nongnu.org/msg784508.html
>>>>>   
>>>>
>>>> Ok, I might be confused about the other ppc machines; but I'm wondering
>>>> about the kvm_type callback for mips and arm/virt. Maybe I'm just
>>>> confused by the whole mechanism?  
>>>
>>> For ppc at least, not sure about in general, pseries is the only
>>> machine type that can possibly work under more than one KVM flavour
>>> (HV or PR).  So, it's the only one where it's actually useful to be
>>> able to configure this.  
>>
>> Wait... I'm not sure that's true.  At least theoretically, some of the
>> Book3E platforms could work with either PR or the Book3E specific
>> KVM.  Not sure if KVM PR supports all the BookE instructions it would
>> need to in practice.
>>
>> Possibly pseries is just the platform where there's been enough people
>> interested in setting the KVM flavour so far.
> 
> If I'm not utterly confused by the code, it seems the pseries machines
> are the only ones where you can actually get to an invocation of
> ->kvm_type(): You need to have a 'kvm-type' machine property, and
> AFAICS only the pseries machine has that.

OMG you are right... This changed in commit f2ce39b4f06
("vl: make qemu_get_machine_opts static"):

@@ -2069,13 +2068,11 @@ static int kvm_init(MachineState *ms)
     }
     s->as = g_new0(struct KVMAs, s->nr_as);

-    kvm_type = qemu_opt_get(qemu_get_machine_opts(), "kvm-type");
-    if (mc->kvm_type) {
+    if (object_property_find(OBJECT(current_machine), "kvm-type")) {
+        g_autofree char *kvm_type =
object_property_get_str(OBJECT(current_machine),
+                                                            "kvm-type",
+                                                            &error_abort);
         type = mc->kvm_type(ms, kvm_type);
-    } else if (kvm_type) {
-        ret = -EINVAL;
-        fprintf(stderr, "Invalid argument kvm-type=%s\n", kvm_type);
-        goto err;
     }

Paolo, is that expected?

So these callbacks are dead code:
hw/arm/virt.c:2585:    mc->kvm_type = virt_kvm_type;
hw/mips/loongson3_virt.c:625:    mc->kvm_type = mips_kvm_type;
hw/ppc/mac_newworld.c:598:    mc->kvm_type = core99_kvm_type;
hw/ppc/mac_oldworld.c:447:    mc->kvm_type = heathrow_kvm_type;

> 
> (Or is something hiding behind some macro magic?)
> 


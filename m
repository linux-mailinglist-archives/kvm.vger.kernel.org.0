Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3539A42D944
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 14:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhJNM2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 08:28:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230339AbhJNM2m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 08:28:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634214397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nw9W7HyIzCeo5RrN6lM9UA8wdwwigGUEHJS6J9krvP0=;
        b=XJGZRdo2OPLhMxqWhPrugCyCksCz2w7bOK74bGnFZouAp/Vq9vfcvMG3yau07AAs/ZI63Z
        3iQiD8PUsWuUKH8/OxQUc++0iBQ1XVHhMGK3ygZEmyUvkilC+JBqX0y9GR6hncPw9Jzitp
        KeJTiVZ07zKjJXWJTJYGLmv2SKgRZ8E=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-cjgkEAGHOsy1AgK2gXLL1w-1; Thu, 14 Oct 2021 08:26:34 -0400
X-MC-Unique: cjgkEAGHOsy1AgK2gXLL1w-1
Received: by mail-ed1-f71.google.com with SMTP id v9-20020a50d849000000b003db459aa3f5so4980554edj.15
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 05:26:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Nw9W7HyIzCeo5RrN6lM9UA8wdwwigGUEHJS6J9krvP0=;
        b=vNzaUpy4ruxPk9Ze4TIZ9MpQG7tAabn/+Ezw2b3qCq+t4x/P6zDZjdXf9J+WipQdSx
         sKlfjlShbOD0Uk1UazzhzEeUT5gh0Il+q12QsvHqEdCg61GUexppv4wQ06OYAdl4dkmu
         BeHl6Xt3Ci2Q2x+75Z1UEc7XLsYJ5eTPWzRdORVxnuuHRyf4pq1m8p4DDQN+MwZjQLWc
         lFg68zyXgJal3vG1FxS8XUlOVg+o8TBlCFJHUktNv4yM3ZAxKs+H1THN8Y3giAk8zTz9
         ojTf3lqGXrpS69+OrCsj1jEMrTzANVl4OwNwTb0sYI4+lgMxgFFhetMSMND5Oodme+o8
         h6cw==
X-Gm-Message-State: AOAM531aLZv0mGkWyCxEHBpe7O2ig/+gBLRVdu4e3/SxG4BLjLwSoQG+
        Sge4UrBLJKpUSYdLbs8D9U9QaRKq4z5gWFLrUmKpHlMXkwKq+x01xuPc73cpi4rsC9aenSmNn77
        rj79yQOQ9Zvv9
X-Received: by 2002:a17:906:c041:: with SMTP id bm1mr3477316ejb.280.1634214393531;
        Thu, 14 Oct 2021 05:26:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTB0hQgUCoVigLcm7gDa+Nn2NZNaSf2eIC82HTFKDicUQIlwso41JQ/erZLteLVzwc2ywzrg==
X-Received: by 2002:a17:906:c041:: with SMTP id bm1mr3477290ejb.280.1634214393348;
        Thu, 14 Oct 2021 05:26:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o12sm2087672edw.84.2021.10.14.05.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 05:26:32 -0700 (PDT)
Message-ID: <0a5aa9d3-e0d4-266e-5e25-021a5ea9c611@redhat.com>
Date:   Thu, 14 Oct 2021 14:26:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com> <875ytz7q2u.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <875ytz7q2u.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/21 14:23, Thomas Gleixner wrote:
>> In principle I don't like it very much; it would be nicer to say "you
>> enable it for QEMU itself via arch_prctl(ARCH_SET_STATE_ENABLE), and for
>> the guests via ioctl(KVM_SET_CPUID2)".  But I can see why you want to
>> keep things simple, so it's not a strong objection at all.
> Errm.
> 
>     qemu()
>       read_config()
>       if (dynamic_features_passthrough())
> 	request_permission(feature)             <- prctl(ARCH_SET_STATE_ENABLE)
> 
>       create_vcpu_threads()
>         ....
> 
>         vcpu_thread()
> 	 kvm_ioctl(ENABLE_DYN_FEATURE, feature) <- KVM ioctl
> 
> That's what I lined out, right?
> 

I meant prctl for QEMU-in-user-mode vs. ioctl QEMU-in-guest-mode (i.e. 
no prctl if only the guest uses it).  But anyway it's just abstract 
"beauty", let's stick to simple. :)

Paolo


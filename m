Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933B6E4A16
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 13:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439225AbfJYLiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 07:38:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33893 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726463AbfJYLiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 07:38:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572003482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=PysqRYmNFBeRKrtuuuJUdQqfgo1USOdE6k0/L7Zipbo=;
        b=YAmv98oox7/6X/1qryyuIR92auph/SjXgA7yvOyaMIAZ8bYN7+hsprUfuLK1ck1jEPCgs/
        HI66Cy6GjLPEG4NBNQAlh34xNZr/qkS+3tl8q9xHKz8svK9SKq/xvacWVx4R1nrGAfQSNT
        xgdhVgbET1qTTy+SOMds5IAGl4dZKq8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-NZK3IwiJMr22iLCoUHaCuw-1; Fri, 25 Oct 2019 07:37:58 -0400
Received: by mail-wm1-f72.google.com with SMTP id a81so973364wma.4
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 04:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D4JzsqahIh0s9vYpnOQpzkQNytgqZsZFAS+/078x/Mo=;
        b=sKwYArCbShf6W+xeP8iBZpvQH4C22trgd0lv0e7S7cZLBPVVdfgGH9qbfLbDCWOjyL
         so5jhKkzMVPGUy/MOZRH70ASs0AlL7eCERTh+QY+CT/S5+6S0A0nln+IXmsn1Qmx3Hxy
         YhBrjMSqvwsHOz5i9ZG9ncvSFdoLwf6ylqMQG+dioeNX4YGix8oye0J4Yb9TB8T1o0fT
         spYOG3YKBGrPraEHkcdd2CIPengojqH1m56KvkMSlSTWNj7jrjPILvs74ZTZEIkNWBM4
         4rnLvfbFiznnNM3bmJKWZ85n6CIj+1xvMFop6s49z19QwdpAOtGknX+s3J71vHjdA6O2
         LvCA==
X-Gm-Message-State: APjAAAWJUPG3VU4cSyNa1iZFUed3joXoNp8VQuI5c70WJqEfagbu9E40
        pdlGRHIpnXpFyV9n/CdNgI3zemRKW/1X8PtjSCC7BiqDKBD+54P9BwVFNK6Tsy/4yoALaTTgfKg
        C5bBFlLXFW7Ov
X-Received: by 2002:a1c:9a43:: with SMTP id c64mr3039391wme.20.1572003477265;
        Fri, 25 Oct 2019 04:37:57 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxIxsU0QTfFgzIor++IV5uTLfqa68GbFWET0a7gQ3UoDeVQaAv87KTVKAGklb/Cp4KY6moTjQ==
X-Received: by 2002:a1c:9a43:: with SMTP id c64mr3039366wme.20.1572003476951;
        Fri, 25 Oct 2019 04:37:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9c7b:17ec:2a40:d29? ([2001:b07:6468:f312:9c7b:17ec:2a40:d29])
        by smtp.gmail.com with ESMTPSA id v20sm1621650wml.26.2019.10.25.04.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2019 04:37:56 -0700 (PDT)
Subject: Re: [PATCH v3 3/3] kvm: call kvm_arch_destroy_vm if vm creation fails
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, John Sperbeck <jsperbeck@google.com>,
        Junaid Shahid <junaids@google.com>
References: <20191024230327.140935-1-jmattson@google.com>
 <20191024230327.140935-4-jmattson@google.com>
 <20191024232943.GJ28043@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <48109ee1-f204-b7d4-6c4f-458b59f7c428@redhat.com>
Date:   Fri, 25 Oct 2019 13:37:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191024232943.GJ28043@linux.intel.com>
Content-Language: en-US
X-MC-Unique: NZK3IwiJMr22iLCoUHaCuw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/19 01:29, Sean Christopherson wrote:
> On Thu, Oct 24, 2019 at 04:03:27PM -0700, Jim Mattson wrote:
>> From: John Sperbeck <jsperbeck@google.com>
>>
>> In kvm_create_vm(), if we've successfully called kvm_arch_init_vm(), but
>> then fail later in the function, we need to call kvm_arch_destroy_vm()
>> so that it can do any necessary cleanup (like freeing memory).
>>
>> Fixes: 44a95dae1d229a ("KVM: x86: Detect and Initialize AVIC support")
>>
>> Signed-off-by: John Sperbeck <jsperbeck@google.com>
>> Signed-off-by: Jim Mattson <jmattson@google.com>
>> Reviewed-by: Junaid Shahid <junaids@google.com>
>> ---
>>  virt/kvm/kvm_main.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)

Sorry for the back and forth on this---I actually preferred the version=20
that did not move refcount_set.  It seems to me that kvm_get_kvm() in=20
kvm_arch_init_vm() should be okay as long as it is balanced in=20
kvm_arch_destroy_vm().  So we can apply patch 2 first, and then:


diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ec14dae2f538..d6f0696d98ef 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -641,7 +641,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 =09mutex_init(&kvm->lock);
 =09mutex_init(&kvm->irq_lock);
 =09mutex_init(&kvm->slots_lock);
-=09refcount_set(&kvm->users_count, 1);
 =09INIT_LIST_HEAD(&kvm->devices);
=20
 =09BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
@@ -650,7 +649,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 =09=09struct kvm_memslots *slots =3D kvm_alloc_memslots();
=20
 =09=09if (!slots)
-=09=09=09goto out_err_no_disable;
+=09=09=09goto out_err_no_arch_destroy_vm;
 =09=09/* Generations must be different for each address space. */
 =09=09slots->generation =3D i;
 =09=09rcu_assign_pointer(kvm->memslots[i], slots);
@@ -660,12 +659,13 @@ static struct kvm *kvm_create_vm(unsigned long type)
 =09=09rcu_assign_pointer(kvm->buses[i],
 =09=09=09kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
 =09=09if (!kvm->buses[i])
-=09=09=09goto out_err_no_disable;
+=09=09=09goto out_err_no_arch_destroy_vm;
 =09}
=20
+=09refcount_set(&kvm->users_count, 1);
 =09r =3D kvm_arch_init_vm(kvm, type);
 =09if (r)
-=09=09goto out_err_no_disable;
+=09=09goto out_err_no_arch_destroy_vm;
=20
 =09r =3D hardware_enable_all();
 =09if (r)
@@ -699,7 +699,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 out_err_no_srcu:
 =09hardware_disable_all();
 out_err_no_disable:
-=09refcount_set(&kvm->users_count, 0);
+=09kvm_arch_destroy_vm(kvm);
+=09WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
+out_err_no_arch_destroy_vm:
 =09for (i =3D 0; i < KVM_NR_BUSES; i++)
 =09=09kfree(kvm_get_bus(kvm, i));
 =09for (i =3D 0; i < KVM_ADDRESS_SPACE_NUM; i++)

Moving the refcount_set is not strictly necessary, but it is nicer as
set+init is matched by the destroy+dec_and_test pair in the unwind path.

If it's okay, I can just commit it.

Paolo


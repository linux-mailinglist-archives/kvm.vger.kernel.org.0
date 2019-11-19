Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327181023B4
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 12:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfKSL67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 06:58:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31131 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727255AbfKSL67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 06:58:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574164738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WNk7YwivNmBzTn4XAkmjNVLEoNEllKj//e1z8yJUxjE=;
        b=ASUNcd5aI63IoLI83hO74gdKVfzce5j6fSdCsY9/u9jeCi84jKJ9dLlv8z7rveTa6Wgs2o
        K7jXxqoZAwtcg4h6zlvJLk96XkgVBYaJvnIY5Rq8Js7bBNuio+K//MAYVhlfRcW4AYZKvh
        LMw4pjD+GNxH9bJzWyau0V2nXMICELU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-bM263FBXMZ284zZtwJaRbg-1; Tue, 19 Nov 2019 06:58:56 -0500
Received: by mail-wr1-f72.google.com with SMTP id g17so18170722wru.4
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 03:58:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yA4apHy1PY+sWWp6DFYpM/EfZ8tIiKSEcg1QvrGG96M=;
        b=oW1/Yo2t9W9hHwAN6m0xgdT+9YTyvnu51RAkPLNbCSiQGvFA+rPZoxFE+4qrFQQeg6
         jgP3qdquz63o386+OSKbfcqjQOcEUj6KTDO/KkDM1nsv6TJf4c0E1q4IQPOV32zmYQIG
         Q8JZlU8hWwslTIqDGfqAU6pDRJdfU8P9Df8wfKtFUfQKtitzgowxE7p6YvYj8FUOVaL3
         Eve5fPCb3MWWZRFhY8TQq2X/Vlq6f0sydAnsYbEP7Eo51bxURjlXZm6qN+p0GLGfQk2c
         UNgjYHcTyQT9ZEKuY1UQLPzOtU58/1+Zc7VlXdjvV1VnMn1ycUxSlJSsmoPsR/I5+UQQ
         GMtw==
X-Gm-Message-State: APjAAAUbSGpiqKD0YumRk6Rt305PrsNIFSI3jDSrzLXawkR2yiAL3gYg
        20wIPSE5+6uAvXWJcGFplyDhYCkeIZW/I2i3Tij+5kDlpr+fCnzEftFL8GQSzw+MVf7qQV4n4We
        tT3vMBaAYi3Qx
X-Received: by 2002:a1c:f20c:: with SMTP id s12mr4811512wmc.37.1574164735670;
        Tue, 19 Nov 2019 03:58:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqwPvUClyKVAjFSwfYlymJ1AsJYdK5NmB51fvFtMn2o5bJnNnKM1MEvX4/tn/DqMYfIgcEOnpg==
X-Received: by 2002:a1c:f20c:: with SMTP id s12mr4811487wmc.37.1574164735432;
        Tue, 19 Nov 2019 03:58:55 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j22sm29535555wrd.41.2019.11.19.03.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 03:58:54 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Mao Wenan <maowenan@huawei.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Mao Wenan <maowenan@huawei.com>
Subject: Re: [PATCH -next] KVM: x86: remove set but not used variable 'called'
In-Reply-To: <20191119030640.25097-1-maowenan@huawei.com>
References: <20191119030640.25097-1-maowenan@huawei.com>
Date:   Tue, 19 Nov 2019 12:58:54 +0100
Message-ID: <87o8x8gjr5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: bM263FBXMZ284zZtwJaRbg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mao Wenan <maowenan@huawei.com> writes:

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> arch/x86/kvm/x86.c: In function kvm_make_scan_ioapic_request_mask:
> arch/x86/kvm/x86.c:7911:7: warning: variable called set but not
> used [-Wunused-but-set-variable]
>
> It is not used since commit 7ee30bc132c6 ("KVM: x86: deliver KVM
> IOAPIC scan request to target vCPUs")

Better expressed as=20

Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target v=
CPUs")

>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  arch/x86/kvm/x86.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0d0a682..870f0bc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7908,12 +7908,11 @@ void kvm_make_scan_ioapic_request_mask(struct kvm=
 *kvm,
>  =09=09=09=09       unsigned long *vcpu_bitmap)
>  {
>  =09cpumask_var_t cpus;
> -=09bool called;
> =20
>  =09zalloc_cpumask_var(&cpus, GFP_ATOMIC);
> =20
> -=09called =3D kvm_make_vcpus_request_mask(kvm, KVM_REQ_SCAN_IOAPIC,
> -=09=09=09=09=09     vcpu_bitmap, cpus);
> +=09kvm_make_vcpus_request_mask(kvm, KVM_REQ_SCAN_IOAPIC,
> +=09=09=09=09    vcpu_bitmap, cpus);

IMHO as kvm_make_vcpus_request_mask() returns value it would probably
make sense to explicitly show that we're not interested in the result,

(void)kvm_make_vcpus_request_mask()

> =20
>  =09free_cpumask_var(cpus);
>  }

--=20
Vitaly


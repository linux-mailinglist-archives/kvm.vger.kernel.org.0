Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE9CD0740
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 08:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfJIGcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 02:32:36 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35843 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727572AbfJIGcg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Oct 2019 02:32:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570602755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=88rO8maf6ORE/54FW3Gxqd5KR1vxX04MoPoXPbMbvSQ=;
        b=hDoMCFoKJmEDdkcI8iEyP3Er97QQfIDR9DNkny13sp7D3F1/txyIcrZMvcQEiGoMnNs/bp
        CggVQec3Bl7tnCJszVqi/hHpuqHHqdLhYHuWe38BKLvvZRMMUavXTmyQ8Uf2gDA3tOoZNI
        5c9p4pFGua13xBMQzLojZ3qh9rXTcLE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-DK08zQh9MLCN9UXBkYNNGA-1; Wed, 09 Oct 2019 02:32:32 -0400
Received: by mail-wr1-f70.google.com with SMTP id 32so617531wrk.15
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 23:32:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MOn7ZTJOBGzAGfz9gxMmUiw0rDGTShgSG278+JF42T8=;
        b=ZsUC/pCyyjVAloMtWtsF7dwi9+WadeWQRYM17gEcyzJJNLQAPbz6DgQW7uAzT1Avdc
         biWAm6AuG2VYAwW8V0MR2GLBeWNkB0e5ZWDRFJImu92Huwwyn/zohOvlKgTe28C6RB74
         Ile2vBeBzh8eU5ijjkU7vqp0/FZA/nzwqs90e0Gy7htN8V323g1NGIjnYq1Dbg4V2Dk2
         rRgLXEdX3nlc1IYMaEpu32mmCR9FzB4/TxdZpPfAmglf0PvJRVOvq6bljvxCmkazbnTM
         TzAOOykkdT0dYOOR1y3oXL5KNkg0Y8BuTYBt7gNByM4QUMaJY3WUB3Z8ryGTTNv/Wk/k
         CnNg==
X-Gm-Message-State: APjAAAWk0vvkhHDAZNH0OGQl55keseC/6drxHVF5NYYSdeRhh9jOMPEc
        Lc6bImoHYFKzTPoB1yw3TuN4qUfoiivsDyxNsNp1aiod78YoQs0hVH3urMIFZcxNGaHLdZxkZy6
        3snatkE+i7pbJ
X-Received: by 2002:a7b:ce93:: with SMTP id q19mr1211708wmj.11.1570602751163;
        Tue, 08 Oct 2019 23:32:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwZUGDLNHAuLfndh4fo/jxMh7I12iE3PRp07j3+lCXCkRGTKjM4VaIpVfIPXIginXD8KU5XdQ==
X-Received: by 2002:a7b:ce93:: with SMTP id q19mr1211696wmj.11.1570602750877;
        Tue, 08 Oct 2019 23:32:30 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 33sm4023040wra.41.2019.10.08.23.32.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 23:32:30 -0700 (PDT)
Subject: Re: [Patch 6/6] kvm: tests: Add test to verify MSR_IA32_XSS
To:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-6-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f3bcebe3-d82d-7578-0dd9-95391fe522e0@redhat.com>
Date:   Wed, 9 Oct 2019 08:30:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009004142.225377-6-aaronlewis@google.com>
Content-Language: en-US
X-MC-Unique: DK08zQh9MLCN9UXBkYNNGA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 02:41, Aaron Lewis wrote:
>   * Set value of MSR for VCPU.
>   */
> -void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index=
,
> -=09uint64_t msr_value)
> +void vcpu_set_msr_expect_result(struct kvm_vm *vm, uint32_t vcpuid,
> +=09=09=09=09uint64_t msr_index, uint64_t msr_value,
> +=09=09=09=09int result)
>  {
>  =09struct vcpu *vcpu =3D vcpu_find(vm, vcpuid);
>  =09struct {
> @@ -899,10 +901,30 @@ void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpui=
d, uint64_t msr_index,
>  =09buffer.entry.index =3D msr_index;
>  =09buffer.entry.data =3D msr_value;
>  =09r =3D ioctl(vcpu->fd, KVM_SET_MSRS, &buffer.header);
> -=09TEST_ASSERT(r =3D=3D 1, "KVM_SET_MSRS IOCTL failed,\n"
> +=09TEST_ASSERT(r =3D=3D result, "KVM_SET_MSRS IOCTL failed,\n"
>  =09=09"  rc: %i errno: %i", r, errno);
>  }

This is a library, so the functions to some extent should make sense
even outside tests.  Please make a function _vcpu_set_msr that returns
the result of the ioctl; it can still be used in vcpu_set_msr, and the
tests can TEST_ASSERT what they want.

> +uint32_t kvm_get_cpuid_max_basic(void)
> +{
> +=09return kvm_get_supported_cpuid_entry(0)->eax;
> +}
> +
> +uint32_t kvm_get_cpuid_max_extended(void)

I would leave the existing function aside, and call this one
kvm_get_cpuid_max_amd() since CPUID leaves at 0x80000000 are allocated
by AMD.

Otherwise looks good.

Paolo


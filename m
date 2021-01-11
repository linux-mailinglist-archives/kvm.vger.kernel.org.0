Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85B52F1DBC
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 19:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390119AbhAKSPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 13:15:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390021AbhAKSPC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 13:15:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610388815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XMVqNDXhVBfgYasHU7WbnA7Bzjgx7oMA1MPdLnO9iGY=;
        b=bWmESOPKdf3WbpCe0dsfZ8lvWu9FrsPddseaAY9YgNMiW44c7XVspZnX+79fNWHNm/33PH
        5KxPiUlc+7SgFm+/ilnHNcylVas1hwEfBIkqvXjDKxcFmnFSzEBAzuqkalh7MwYNPCnvgk
        m40CnNaAT48wAXstm51w5t1+9Aql0PU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-UCoRCCH6MvmJFKtUYJS2kg-1; Mon, 11 Jan 2021 13:13:31 -0500
X-MC-Unique: UCoRCCH6MvmJFKtUYJS2kg-1
Received: by mail-ed1-f72.google.com with SMTP id y19so51749edw.16
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 10:13:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XMVqNDXhVBfgYasHU7WbnA7Bzjgx7oMA1MPdLnO9iGY=;
        b=KOR4qgvJWKTgYoWMzA++wfcdBeDxb30SKfkCoOyRI5igVbQwQ9regpB3wZastLmrSq
         i8jpep3WTUxO37z3YesW217xYgmiAjzoBOqC8zRKa1mqeRkanIV+TqxA81t+/edAAg5+
         LLmO8w0jUD4fuznzS9iYJVPx0lupLrr+QJYyQ3BrAC0RF+9j3cXJD/yjrAG0VuGnij+U
         Rwx8dZ+XeNgwlODSaeJM2JFtjWp28TmUwgtp6uO5JhLfyq+VhP6M4L2jwvWLr4x8KCD0
         7zzWimoMX2Q0EsducMFo3LivXMz39cbSmZ1E8bBLWlSx7SbrrpD/eDjXgThEQhwWiLAr
         eV5Q==
X-Gm-Message-State: AOAM532L+KQb9HYRtPECpO2vVIWsEy0VsbESXlL6PcaUexd2J462bqdW
        U8C2BMvl/DqY2Lcq3C30mhxBtWqepH0ES3UQMuTEf5HHZjkTbVvllxfGyNwvJlOl+mYGh3u/lKn
        0C7xab1iPze2P
X-Received: by 2002:a17:906:234d:: with SMTP id m13mr507840eja.270.1610388810463;
        Mon, 11 Jan 2021 10:13:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy2VUws8bJTsf90eDubNx6PHzyPCAFdFVEZ+6itmXCzLLMigPo9Pqp3tf2gYBxIpCha9PLMow==
X-Received: by 2002:a17:906:234d:: with SMTP id m13mr507825eja.270.1610388810318;
        Mon, 11 Jan 2021 10:13:30 -0800 (PST)
Received: from [192.168.1.36] (129.red-88-21-205.staticip.rima-tde.net. [88.21.205.129])
        by smtp.gmail.com with ESMTPSA id h12sm137927eja.113.2021.01.11.10.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 10:13:29 -0800 (PST)
Subject: Re: [for-6.0 v5 06/13] securable guest memory: Decouple
 kvm_memcrypt_*() helpers from KVM
To:     David Gibson <david@gibson.dropbear.id.au>, pair@us.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, brijesh.singh@amd.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     thuth@redhat.com, cohuck@redhat.com, berrange@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, david@redhat.com,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        rth@twiddle.net
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-7-david@gibson.dropbear.id.au>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <e8c1f2a7-e5b9-8181-2c7b-0287699ac9c9@redhat.com>
Date:   Mon, 11 Jan 2021 19:13:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201204054415.579042-7-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/20 6:44 AM, David Gibson wrote:
> The kvm_memcrypt_enabled() and kvm_memcrypt_encrypt_data() helper functions
> don't conceptually have any connection to KVM (although it's not possible
> in practice to use them without it).
> 
> They also rely on looking at the global KVMState.  But the same information
> is available from the machine, and the only existing callers have natural
> access to the machine state.
> 
> Therefore, move and rename them to helpers in securable-guest-memory.h,
> taking an explicit machine parameter.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>  accel/kvm/kvm-all.c                   | 27 --------------------
>  accel/stubs/kvm-stub.c                | 10 --------
>  hw/i386/pc_sysfw.c                    |  6 +++--
>  include/exec/securable-guest-memory.h | 36 +++++++++++++++++++++++++++
>  include/sysemu/kvm.h                  | 17 -------------
>  5 files changed, 40 insertions(+), 56 deletions(-)
...

> +static inline int securable_guest_memory_encrypt(MachineState *machine,
> +                                              uint8_t *ptr, uint64_t len)
> +{
> +    SecurableGuestMemory *sgm = machine->sgm;
> +
> +    if (sgm) {
> +        SecurableGuestMemoryClass *sgmc = SECURABLE_GUEST_MEMORY_GET_CLASS(sgm);
> +
> +        if (sgmc->encrypt_data) {

Can this ever happen? Maybe use assert(sgmc->encrypt_data) instead?

Otherwise:
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

> +            return sgmc->encrypt_data(sgm, ptr, len);
> +        }
> +    }
> +
> +    return 1;
> +}


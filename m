Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04A8440DBA
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 11:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhJaKEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 06:04:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44354 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229638AbhJaKEb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 06:04:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635674519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=29xBbVDsUcrcE3TC4NzcFXJcgXZAeKLeQHCyBM7YADI=;
        b=R60cGIA87WNQwk85e949wdsaeOOyXmhU/7XbfkSIxH4KOizlIve07Ahc487KE3cr3fxxG/
        nvYuBLGQR5os3HMOWf1Q+pj7Zt1tl3YdOs7KlMfpsoeLHCej24Eal9LinYi1WfJSCWV7Ao
        XQwx6lvpFuKYqw2EiRZ2gqbT0G375wU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-HqlmGqHhM-mEdADBOm80Sg-1; Sun, 31 Oct 2021 06:01:57 -0400
X-MC-Unique: HqlmGqHhM-mEdADBOm80Sg-1
Received: by mail-ed1-f71.google.com with SMTP id v21-20020a056402349500b003dfa41553f3so9432700edc.11
        for <kvm@vger.kernel.org>; Sun, 31 Oct 2021 03:01:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=29xBbVDsUcrcE3TC4NzcFXJcgXZAeKLeQHCyBM7YADI=;
        b=B1uc3dmE6YQI0eQfmWx9+0nsJopXnZV9ew26hgczyr7DZ/XFl957rzaaZ67AZ/8Bxj
         Vgn+aFiMriqb3ChWMfSiGFjdcM48sqmCH5df5g//YU8BHP6eIAAiodarDjLRKThCTTkU
         c8wQyifcUsrXPYQgJuEyOqfuplLDhmcIA1QiYbpTQCtjrD01hg3Jki/rzQ+Q+mcZWH5T
         QoVUNqdjpvXFbY6pEJgcAK4aNKZlPWWuPQJ7+3X9Sb9WG1RltLBI1ODd+TdTI0PxTgRS
         fpZQslW1edliBWC9P3f+5nrA2/OHJTVbUvwN/nL0QdjBlJXTRQmmNv7WTO9LPNOABi7u
         rFmA==
X-Gm-Message-State: AOAM532ROkCCeG+EwaT6u83zOyaV4VzbkkJ9SurJ5DR2TiCs6MxDDFSd
        fsevGerAFCkZuuQFqNZ/bqqQWdOdZP+0uV7Pn3LuPpcPNibbRh9YdM/hF9W8y80WVdSr8mFBHjE
        o2NoTp8oIc8Xy
X-Received: by 2002:a17:906:c20e:: with SMTP id d14mr28642628ejz.80.1635674516548;
        Sun, 31 Oct 2021 03:01:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQyhKTJSd9TMHnPLCWJxDANRAj/Gbs/Uen62XP2coPHV56G5fhyGPlqbFw8p5SKGHQsWEMoQ==
X-Received: by 2002:a17:906:c20e:: with SMTP id d14mr28642604ejz.80.1635674516340;
        Sun, 31 Oct 2021 03:01:56 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p6sm906528edx.60.2021.10.31.03.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 03:01:55 -0700 (PDT)
Message-ID: <5460ca03-4547-b538-e187-6eb8e9ce8641@redhat.com>
Date:   Sun, 31 Oct 2021 11:01:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v1 5/7] x86 UEFI: Exit QEMU with return
 code
Content-Language: en-US
To:     Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
References: <20211031055634.894263-1-zxwang42@gmail.com>
 <20211031055634.894263-6-zxwang42@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211031055634.894263-6-zxwang42@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/10/21 06:56, Zixuan Wang wrote:
> From: Zixuan Wang <zxwang42@gmail.com>
> 
> kvm-unit-tests runner scripts parse QEMU exit code to determine if a
> test case runs successfully. But the UEFI 'reset_system' function always
> exits QEMU with code 0, even if the test case returns a non-zero code.
> 
> This commit fixes this issue by replacing the 'reset_system' call with
> an 'exit' call, which ensures QEMU exit with the correct code.
> 
> Signed-off-by: Zixuan Wang <zxwang42@gmail.com>
> ---
>   lib/efi.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/efi.c b/lib/efi.c
> index 99eb00c..cc0386c 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -87,7 +87,7 @@ efi_status_t efi_get_system_config_table(efi_guid_t table_guid, void **table)
>   
>   efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>   {
> -	int ret;
> +	unsigned long ret;

Why this change?

>   	efi_status_t status;
>   	efi_bootinfo_t efi_bootinfo;
>   
> @@ -134,14 +134,14 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>   	ret = main(__argc, __argv, __environ);
>   
>   	/* Shutdown the guest VM */
> -	efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, ret, 0, NULL);
> +	exit(ret);
>   
>   	/* Unreachable */
>   	return EFI_UNSUPPORTED;
>   
>   efi_main_error:
>   	/* Shutdown the guest with error EFI status */
> -	efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, status, 0, NULL);
> +	exit(status);
>   
>   	/* Unreachable */
>   	return EFI_UNSUPPORTED;

It's better to keep the exit() *and* the efi_rs_call(), I think, in case 
the testdev is missing and therefore the exit() does not work.

Paolo


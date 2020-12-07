Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E67F2D0DC4
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 11:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgLGKGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 05:06:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbgLGKGR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 05:06:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607335490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NYGMZWwBeIh3fFPx69mvYjTdx1z088fxfHeToI+lsX8=;
        b=IUj/WNf5h8IqWTIOYg2z84Hv9lQBHEyKKAIlxidutKotmmyqXc3FpcRUuwERstCHy0B0tT
        kf9Z+L1alyvdKNdvuqCwkaIXbeuvz7wF3DLBEs2HwE8c6/p5vABFyblj54irnClcuEHY6I
        I/KvIc6erd2CSwBb2aGFbDlmayJoaX4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-MrDrvghsPUCjUJwU4WA3og-1; Mon, 07 Dec 2020 05:04:49 -0500
X-MC-Unique: MrDrvghsPUCjUJwU4WA3og-1
Received: by mail-wr1-f69.google.com with SMTP id p18so4634030wro.9
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 02:04:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NYGMZWwBeIh3fFPx69mvYjTdx1z088fxfHeToI+lsX8=;
        b=JUjeRoO9Np8ALzmgHZzRwGQQpUmzA/G3FWxeWkzVgF0xdfc693He0EDZmoBgyMWgtC
         3JU1j7FSTPvVWZI4D+EDHjUeBNfEZneA8ooTaZ48u2kBXV4jwq2MlY8r361jlVfdt4qL
         MGbSessRAOPPX7WErB/OrKdjXBWA2LqVq5XgwB9D9tJNhjnKhoEvqe9I+uskVYV8hBKV
         ZT1RPiU4F1SwkpocmjjzyDI5nJ+EM8TxBp+PkUe299jnKVMW7PYLauQMY67Rs703WkHG
         RvpNd6H/EJdi5VGf6G6EPUJSyUgboOg6+auOdTJtnRdgjbkCxhLyCyTr89uMyX32bqH2
         0hbQ==
X-Gm-Message-State: AOAM533RqySfVy98JQgqIqoWOriWYu1MdZmgBm/PNtgIzM+fOkriwdDA
        dpS8JPH0BcBSz5cWOszaKyFH0NzlDthMEahH3mP7F/UfToT1taiORz1uY3hIqehB74Czab8NwDe
        Z5Q8u3oBiCc0J
X-Received: by 2002:a1c:4604:: with SMTP id t4mr16984343wma.17.1607335487738;
        Mon, 07 Dec 2020 02:04:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxh2IvFXXS0Sn+Z6xWooK0ZB7J3J/ucSwA/Wd5Mn37PSJsH8VDS/ZbIW+jBzvFF1CRvg0hS8w==
X-Received: by 2002:a1c:4604:: with SMTP id t4mr16984316wma.17.1607335487585;
        Mon, 07 Dec 2020 02:04:47 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id e17sm4403139wrw.84.2020.12.07.02.04.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 02:04:46 -0800 (PST)
Subject: Re: [PATCH 3/8] gitlab-ci: Add KVM X86 cross-build jobs
To:     Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Huacai Chen <chenhc@lemote.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Claudio Fontana <cfontana@suse.de>,
        Halil Pasic <pasic@linux.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org
References: <20201206185508.3545711-1-philmd@redhat.com>
 <20201206185508.3545711-4-philmd@redhat.com>
 <1048bbc0-7124-3564-4219-aa32ed11a35b@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <951882fd-fae0-2dec-5a81-d72adf139511@redhat.com>
Date:   Mon, 7 Dec 2020 11:04:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1048bbc0-7124-3564-4219-aa32ed11a35b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 6:20 AM, Thomas Huth wrote:
> On 06/12/2020 19.55, Philippe Mathieu-Daudé wrote:
>> Cross-build x86 target with only KVM accelerator enabled.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  .gitlab-ci.d/crossbuilds-kvm-x86.yml | 6 ++++++
>>  .gitlab-ci.yml                       | 1 +
>>  MAINTAINERS                          | 1 +
>>  3 files changed, 8 insertions(+)
>>  create mode 100644 .gitlab-ci.d/crossbuilds-kvm-x86.yml
> 
> We already have a job that tests with KVM enabled and TCG disabled in the
> main .gitlab-ci.yml file, the "build-tcg-disabled" job. So I don't quite see
> the point in adding yet another job that does pretty much the same? Did I
> miss something?

I missed it was x86-specific myself.

> 
>  Thomas
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4CA4220A7
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 10:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhJEI1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 04:27:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230286AbhJEI1g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 04:27:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633422345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=klLTM38m8AVOZiQC2QI4nrkV4JPwL7t0pdo1OBretqQ=;
        b=hqi3C3AP3rcJYHcVDVfZ9cgRdykOLVMF2ESo5yeDt1PJtLvwXZMh7U/1X/QG1li9ZtXH1l
        sy1ON9V4aoiClOfjRQFZiyoeTArl4CCilr06I4U3t6Sy8CemL13xhT8rcQ7CYARy3/bhMW
        REnjsGqNu9z7NQKdqiQKtoHTCx+3+TY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-5mJ4VyEbNkiubTgX3SLRIA-1; Tue, 05 Oct 2021 04:25:44 -0400
X-MC-Unique: 5mJ4VyEbNkiubTgX3SLRIA-1
Received: by mail-ed1-f69.google.com with SMTP id w6-20020a50d786000000b003dabc563406so15497901edi.17
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 01:25:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=klLTM38m8AVOZiQC2QI4nrkV4JPwL7t0pdo1OBretqQ=;
        b=vnpEj9d115SupP83aAJTUGN3bQs5p994BHgLCbSbxPcgWQ6HKtCoazlBVep9dKQ9g/
         4v5T6gwPEkGKn5+lUFf/SiH3D0VOS8c5bgQA1GBu6U3iPqJfxw2G3DSrf2xsUuuID40a
         F1UmGhpxZxJxbMbHfDHzFd7FgeqA2wmppootB/X57hz6vtvMSKlThHo6a0Xh4oWRtPfd
         hrofbIHX62KjfELqb4YVwt5jqXikvqDa6uQChnKctOijEKOj2Tl3lUOYmU1mE5WlPjtZ
         Af0DQmDStJ2+odXM/LGoYL1+0yrFLmueVBGBmrBPSAA6ZxO5zmHywvV5gCOiDzCmMnoB
         uoCw==
X-Gm-Message-State: AOAM532iv8lFnKDgvSD1rTSdYyTUk+pzLGZwOMXRXUjq7mVRZhtE61ob
        JX+29BH8NolJyN3EdVL4x2uc6uxPEGcs/vhAj+HlM7z3Qsf+OC05/7gRjXkxJeauLgH47Iw2du3
        0gz+g/rV1R0bD
X-Received: by 2002:aa7:cb8a:: with SMTP id r10mr24610031edt.237.1633422343347;
        Tue, 05 Oct 2021 01:25:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwt1VKhq/RBXzX5ipjFdmZ4SJ96APOZh3Kl36oSEowMgWp+YD2AB6TtkzyVRAn0of8NmaYlxw==
X-Received: by 2002:aa7:cb8a:: with SMTP id r10mr24610005edt.237.1633422343111;
        Tue, 05 Oct 2021 01:25:43 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id kw10sm7412696ejc.71.2021.10.05.01.25.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 01:25:42 -0700 (PDT)
Message-ID: <82568eff-1eff-5e63-4264-ef0c25f79fc3@redhat.com>
Date:   Tue, 5 Oct 2021 10:25:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL] KVM/riscv for 5.16
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy37xNOs3udMe4GuLJ3=huKD1bsHEO_RfUPvuMiVw56GCQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy37xNOs3udMe4GuLJ3=huKD1bsHEO_RfUPvuMiVw56GCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/10/21 09:55, Anup Patel wrote:
>    git://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.16-1

Pulled, thanks!

Paolo


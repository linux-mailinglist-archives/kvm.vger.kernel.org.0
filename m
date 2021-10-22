Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50C94374FF
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 11:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhJVJsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 05:48:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231992AbhJVJsj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 05:48:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634895982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q5FJnOMRZWvjOB3d1Ox+t5Wfgcuzi9WlMtPofRf2ri0=;
        b=UioksrHGoCJ97LcJIBfeLW/GRD26j5Uqi2KlrDxKvru+fhxgYlXM091AQITOfz37Inux7M
        uFKn/942Y+ZHE2Edo4tWAhATAh2ncETJgxWjE5MH2H43s8xQ+Dg42SOaUkxFjSBOAaxGrN
        uvfI+p53wUoqZ8SREus3iS9Q5wS3dzI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-xYjD1xVwOYOWQg40abSslg-1; Fri, 22 Oct 2021 05:46:20 -0400
X-MC-Unique: xYjD1xVwOYOWQg40abSslg-1
Received: by mail-ed1-f71.google.com with SMTP id s12-20020a50dacc000000b003dbf7a78e88so3190450edj.2
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 02:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q5FJnOMRZWvjOB3d1Ox+t5Wfgcuzi9WlMtPofRf2ri0=;
        b=FKMxJgjRHBhNQW10uI9iX1LO0I2A9BlUG+0LTA9nRFuHuQDkOkRog+Vlf8E6Kx8Stw
         yOr7fLxmR3eojTr/FRcxx446eeiF2tLkypO89rkQy4Bs4sB5lXV3R7N09pC9E5i3wulL
         1BqvssQO1MzXaTEf0LeKLZfY2+ukIzPX95hCXRkDKJYEMP18cDkA9MAUca0Icx5pX2P3
         E6Ln2iWVlB6KB9eFxgTW2cIElJw9iZlFcL00Fqz4qhVEVeXimlk3iqZ9x3znwvQ+Wmzy
         8pY0y6MeACC3+h8dXsLhfug54aedMyCeZwSc0jHs0icTA5dxjpZtFx1KE8087qPk+E70
         yFqQ==
X-Gm-Message-State: AOAM531K1brBqy4LoQc8ExWlWvBeaJOjXRmyVL/Qe+5NCdDyTRT7T9oD
        iMZtxI6uMty6iugQPRTY9pmlxu51oSjauoP587DvbRTABHzruDow9fAAe2fbJ7SeaUjOqwqslN2
        Ig/nOGJgl45wL
X-Received: by 2002:a17:906:9b88:: with SMTP id dd8mr14397082ejc.467.1634895979488;
        Fri, 22 Oct 2021 02:46:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbwGkiPtZVczfGl3NMgm/t64A/jGQwnkx+5JyzXgvZp3WDfg4w0m6tSBx9uT3j5lmZV9uahQ==
X-Received: by 2002:a17:906:9b88:: with SMTP id dd8mr14397059ejc.467.1634895979202;
        Fri, 22 Oct 2021 02:46:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n23sm4235382edw.75.2021.10.22.02.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 02:46:18 -0700 (PDT)
Message-ID: <bebc39f8-0ebc-c8cb-413e-bb4e30397057@redhat.com>
Date:   Fri, 22 Oct 2021 11:46:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/2] KVM: some fixes about RDMSR/WRMSR instruction
 emulation
Content-Language: en-US
To:     Hou Wenlong <houwenlong93@linux.alibaba.com>, kvm@vger.kernel.org
References: <cover.1634870747.git.houwenlong93@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <cover.1634870747.git.houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/21 04:59, Hou Wenlong wrote:
> When KVM_CAP_X86_USER_SPACE_MSR cap is enabled, userspace can control
> MSR accesses. In normal scenario, RDMSR/WRMSR can be interceped, but
> when kvm.force_emulation_prefix is enabled, RDMSR/WRMSR with kvm prefix
> would trigger an UD and cause instruction emulation. If MSR accesses is
> filtered, em_rdmsr()/em_wrmsr() returns X86EMUL_IO_NEEDED, but it is
> ignored by x86_emulate_instruction(). Then guest continues execution,
> but RIP has been updated to point to RDMSR/WRMSR in handle_ud(), so
> RDMSR/WRMSR can be interceped and guest exits to userspace finnaly by
> mistake. Such behaviour leads to two vm exits and wastes one instruction
> emulation.
> 
> After let x86_emulate_instruction() returns 0 for RDMSR/WRMSR emulation,
> if it needs to exit to userspace, its complete_userspace_io callback
> would call kvm_skip_instruction() to skip instruction. But for vmx,
> VMX_EXIT_INSTRUCTION_LEN in vmcs is invalid for UD, it can't be used to
> update RIP, kvm_emulate_instruction() should be used instead. As for
> svm, nRIP in vmcb is 0 for UD, so kvm_emulate_instruction() is used.
> But for nested svm, I'm not sure, since svm_check_intercept() would
> change nRIP.

Hi, can you provide a testcase for this bug using the 
tools/testing/selftests/kvm framework?

Thanks,

Paolo


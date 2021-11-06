Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C1E446ED4
	for <lists+kvm@lfdr.de>; Sat,  6 Nov 2021 16:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbhKFP7Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 6 Nov 2021 11:59:16 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:34743 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbhKFP7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Nov 2021 11:59:15 -0400
Received: by mail-ot1-f48.google.com with SMTP id s7-20020a056830148700b0055ad72acb7eso16895568otq.1;
        Sat, 06 Nov 2021 08:56:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eBDSUIjOttiaXGIBqHqfJQJUcKgBFvtaHFb5EhflaV4=;
        b=b1txsNtE1JejwznR1IbZ4kkCbvfvlKIfgfptuuOkWmUw9ebT8Q2lPtaTwqflAdH2/d
         tJv4fpwYb/b9RIEvy1ZN6rB23DhSBR1EZ+ThFVKSTV7gM6XzXQZNGw71vZXHXUa75oR0
         PmhmSqISBD06IDkNnLjPl4685jKCuEiRZdlblYY4B8ptLiFioR4rsvumnPivuuFjZwFj
         +WkiXku1jiEaykWv6BB/Y43gj4x/YnpmLPaYZk0fNcMz882ADq7f/4bq93Gw55kPX6f2
         HVOn0YIEHPSSmwCymdEowOssm8yg4jf84AVW/gzuUiOdu63QcFSGb/n/mv4MsUn5L3T9
         pZbg==
X-Gm-Message-State: AOAM531pJY+MFHm18LkEsfIjW85nUVxAGpLzt49CxFAbh/9waSRlvobX
        jOXKsjLtXAaE0h8Ek+fgRk56i9Ab6mlvAET0Mws=
X-Google-Smtp-Source: ABdhPJxwhCJyC+uhck/vVYoIRwMhWus9uJyoYA8q1C4DG6hFBkzj6XG5LHI4onqLHXxXLvHpBvFJjhBzstBp2T8d+3A=
X-Received: by 2002:a9d:4e97:: with SMTP id v23mr20053935otk.190.1636214193915;
 Sat, 06 Nov 2021 08:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211105192101.3862492-1-maz@kernel.org> <20211105192101.3862492-3-maz@kernel.org>
In-Reply-To: <20211105192101.3862492-3-maz@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date:   Sat, 6 Nov 2021 16:56:22 +0100
Message-ID: <CAAdtpL4UKw2s7ekxKjKy8XxPR5acq0u1qLR5ontL3T9MWJ5VPQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] KVM: mips: Use kvm_get_vcpu() instead of open-coded access
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm <kvm@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 5, 2021 at 9:14 PM Marc Zyngier <maz@kernel.org> wrote:
>
> As we are about to change the way vcpus are allocated, mandate
> the use of kvm_get_vcpu() instead of open-coding the access.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/mips/kvm/loongson_ipi.c | 4 ++--
>  arch/mips/kvm/mips.c         | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>

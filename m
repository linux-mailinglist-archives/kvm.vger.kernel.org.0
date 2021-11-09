Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DFB44B204
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 18:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241090AbhKIRgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 12:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238382AbhKIRgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 12:36:02 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5532C061766
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 09:33:16 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b11so8982484pld.12
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 09:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dAQ4ipHe6mj+S5wNiendTeS5LEXc10OoPefcaaMxaM4=;
        b=X7XoFdgKxoUfdExi/8T7fGzwE8la73btPlIVP+HuJp9bL/hU85oxlA3kUHjSzaYQnh
         G8u/08InsEZY6n/6bNf2eaHu8J6OjiMTJb4+lTqFTeGQMG7T11GPhWMNQcMMMiyJ0niT
         8AgmYxmn59QNW5izfAmer0EqCiPfHEL8DmNA/Izq+7vBo+tgvTWXBvSjW5lYxxlsj+Dp
         0/HVF+Xfe2uHl/7T9J88HV2/3miPiM5PAkS6piL2Bqz+4kcqp5rlYbZYrLyTekzvKZJA
         cDACERmR3UvLKrzkkM1tjgp4FE6PQl0xnSzpkesf5czQEfMFMFDmuDyuAuOoJre11REA
         NKQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dAQ4ipHe6mj+S5wNiendTeS5LEXc10OoPefcaaMxaM4=;
        b=wYCwSq2EE4yjpy9vx/BQeElj4ClsAeNjk6VX2UedzlTk5G3Fu4HcNlXxdeO2KsjICv
         ayzXAdV6841G0etb7c8oaBYJoRbXu5G+kNNo6pJxesIrZEeASemY4awy+wpRGZPKdb54
         4JqZLTrSejbvMxoTzk0rPACM7oMN6l0WdP8rs4sMUxaIPajdmIMoawvNDlxj6aS7174Q
         hokLbzMIMd8Om3BoILrttn4OUjGfiLAh0lvhXCnp8esqA3/27IUcw4DkO65sjLrR7rH+
         MPVugtphaTZHmPAG+l+SlT4AEbq8AQ9Fk2PcnxMwCiK4AHYocVRDct7TYXRiV7/iXHg6
         coJA==
X-Gm-Message-State: AOAM532bSweNkkOXXO7vowt3noAzUx89RUiywDnEcyiduawco2fgkc/c
        CgOgzHexHm0Q57r+yL0V9OOp5w==
X-Google-Smtp-Source: ABdhPJxcCsg0NSzFuffu/U0QqNGykfFjyw0u+oK5KaYzr61kSayzkoK+RJCyWGZvV9MiERP2Zg40yQ==
X-Received: by 2002:a17:90b:1a87:: with SMTP id ng7mr9146277pjb.230.1636479195981;
        Tue, 09 Nov 2021 09:33:15 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p16sm15460419pgd.78.2021.11.09.09.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 09:33:15 -0800 (PST)
Date:   Tue, 9 Nov 2021 17:33:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/8] KVM: nVMX: Enlightened MSR Bitmap feature for
 Hyper-V on KVM (+ KVM: x86: MSR filtering and related fixes)
Message-ID: <YYqw15a/Z+eDvuEv@google.com>
References: <20211109162835.99475-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109162835.99475-1-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 09, 2021, Vitaly Kuznetsov wrote:
> This series combines "Enlightened MSR Bitmap feature for Hyper-V on KVM v4"
> and Sean's "KVM: x86: MSR filtering and related fixes v4" 
> (https://lore.kernel.org/kvm/20211109013047.2041518-1-seanjc@google.com/)
> series as they're code dependent.

Series as a whole looks good, thanks for doing the dirty work!

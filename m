Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2BB1E6046
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 14:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388741AbgE1L42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 07:56:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33633 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388724AbgE1L40 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 07:56:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590666985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G6bfws9MwiCCMvZrWzAJyuiNns7YUWzpHu60JOrsU/o=;
        b=IMOPZ6eejD1SSUWSCBkLRlPIKhhXcS+pf8e4CyMDtxm4amUehp4qHrKSSanNIBIg4btKSC
        AoOpJN0QRYOIYMfeq1LPkWH1rXVg2fUrTGOr4FjVd9ocOaixdCtt/Kfcy4qF9VQgg6NRJc
        fk7W5nkNPzelCRl1K13o1BFbDSnuVG4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-3knW8UOWNIyZE-9X8XXSFQ-1; Thu, 28 May 2020 07:56:22 -0400
X-MC-Unique: 3knW8UOWNIyZE-9X8XXSFQ-1
Received: by mail-wm1-f69.google.com with SMTP id z5so883061wml.6
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 04:56:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G6bfws9MwiCCMvZrWzAJyuiNns7YUWzpHu60JOrsU/o=;
        b=mjxqLaxObRk+w3mStnTiLp1MrEfxK8r3xo6etz3CXVPmxr1glqHQK1/LwTtbeC+E6A
         +O3EgbaQHWlX8R/B+86vvV5UYJrRx+CzDhLDXu1II4HbacQQ7RxgqUIas7xCd7ICn/dQ
         gwkx9ZiFCXLlZUJHM+1LwQUPzaNTLKb6mt2lr2XqNDaWyyTp3XbUsYSr1bD258lQWjsI
         IURKsXK9lMrdUu2DhxVpS6eGF3cPeZRwFvkuivWvQmBadBcfWdt3RJneFGQYfabPqEBt
         B/1mqX907uwckEUnIcL9nysTQze9+mwfc5vPqKmwGsi4Bk7nPhl8Qg8eRb/Ulkrkwp/T
         uQ3g==
X-Gm-Message-State: AOAM533uGL/A4qe1oSnh+7+/IWoAiiIJU4fjXgQQPuWdL884UU7NK2ZC
        ANkkyV6Q39r6Q3m81F1pKpge7T0Ft+rXjbRC3PzI2cUQRuTTQCQ+Bq8M3KHa0KDbyfvi6QDD7QM
        5QS3EYvqqDyX0
X-Received: by 2002:a05:600c:146:: with SMTP id w6mr2984002wmm.97.1590666981590;
        Thu, 28 May 2020 04:56:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJbHKuC/6XBtiV1KUuSLpUmiBDD5SLecdb26n6zIP6TbQf3zEubqSsXxt97G1Deyo1noUmFA==
X-Received: by 2002:a05:600c:146:: with SMTP id w6mr2983988wmm.97.1590666981329;
        Thu, 28 May 2020 04:56:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id h74sm5853862wrh.76.2020.05.28.04.56.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 04:56:20 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Add .gitignore entry for
 KVM_SET_GUEST_DEBUG test
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200528021624.28348-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ce6a5284-e09b-2f51-8cb6-baa29b3ac5c3@redhat.com>
Date:   Thu, 28 May 2020 13:56:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200528021624.28348-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/05/20 04:16, Sean Christopherson wrote:
> Add the KVM_SET_GUEST_DEBUG test's output binary to .gitignore.
> 
> Fixes: 449aa906e67e ("KVM: selftests: Add KVM_SET_GUEST_DEBUG test")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  tools/testing/selftests/kvm/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 222e50104296a..d0079fce1764f 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -3,6 +3,7 @@
>  /s390x/resets
>  /s390x/sync_regs_test
>  /x86_64/cr4_cpuid_sync_test
> +/x86_64/debug_regs
>  /x86_64/evmcs_test
>  /x86_64/hyperv_cpuid
>  /x86_64/mmio_warning_test
> 

Queued, thanks.

Paolo


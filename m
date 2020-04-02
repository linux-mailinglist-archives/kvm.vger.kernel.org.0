Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809C719C9F8
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 21:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389982AbgDBTXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 15:23:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47006 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388945AbgDBTXM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 15:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585855390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cxt+LO+/D+LWZGAf62ME434VQmNIvwgAEaDvQHLIBZg=;
        b=Wlbq/DL7uBloOHCNJNjpxjeZzj5cUcjwVqLL8MZe6YxJ63YFkrUZgcZ53zDg16yA+AcGod
        Ak4mlDtTttOqr8oqGzwsQtGEbninpHwS0Va6xrjMMd/6rI6qmgc/rxAgGHf1VMm687UfyC
        RUBooECKffWJ1Csi1FmPS19eg9lI4x4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-14K0Q2A3MBW-0yePvNoSEA-1; Thu, 02 Apr 2020 15:23:08 -0400
X-MC-Unique: 14K0Q2A3MBW-0yePvNoSEA-1
Received: by mail-wm1-f69.google.com with SMTP id p12so125855wmi.0
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 12:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cxt+LO+/D+LWZGAf62ME434VQmNIvwgAEaDvQHLIBZg=;
        b=Sozd7WDywBQZiw97ZCCVQ0Nr8SDSpEg9yFR0G0vf2fkCy/bJo2aBq8In+9B1FFgf3O
         tS2E/EJjkJcS/xaSiCKyXnPHXe+x0t8VfwRBixjATBO3yTNplXW9J3lEiiPDoYQBNeu/
         2MPDoRn/2EVuI0wWPcrLd5IEPoGTaZ7xiBx5Q8Z2GZfka/Il4j3qWDG1OFRTnXCmBshf
         K9ZGs86nBbfCZWy/79SNqVsjz3GPNOrm/XBf2XjQi8a0eSlZbLckE72XZuDZbum0h5Nk
         2g8kumtVxsUKgaRX2ZD9eX2LHGKaAmwjjoKb125P4pvn6wVzBsQr4MRyn4HADKQmmG7v
         bXGQ==
X-Gm-Message-State: AGi0Pub4vDS/lWvROc+TvUyoev/DFA/OEjfnBl68fyOCRqjxSvFkPXK8
        2HG840Aw14az+JZgskmLQPfTKmS2OwnsOmhdDyVp0htS1tklE3pqG8ujFWWJfbM+jPNInhfUeHT
        tavoyHoE75ydo
X-Received: by 2002:a1c:9805:: with SMTP id a5mr4801361wme.119.1585855387493;
        Thu, 02 Apr 2020 12:23:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypIhqOMduV95ID1TOu+8/286w64w+I2dfqIZk2Y7Q7JUkbcQkwaQl5dfAOKAwswECuH8pPBbbQ==
X-Received: by 2002:a1c:9805:: with SMTP id a5mr4801347wme.119.1585855387242;
        Thu, 02 Apr 2020 12:23:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1868:42dd:216c:2c09? ([2001:b07:6468:f312:1868:42dd:216c:2c09])
        by smtp.gmail.com with ESMTPSA id v7sm8596686wrs.96.2020.04.02.12.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2020 12:23:06 -0700 (PDT)
Subject: Re: [PATCH -next] x86/kvm: fix a missing-prototypes "vmread_error"
To:     Qian Cai <cai@lca.pw>
Cc:     sean.j.christopherson@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200402153955.1695-1-cai@lca.pw>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2e823923-4b81-8cb5-59f6-4376dc71fce2@redhat.com>
Date:   Thu, 2 Apr 2020 21:23:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200402153955.1695-1-cai@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/04/20 17:39, Qian Cai wrote:
> The commit 842f4be95899 ("KVM: VMX: Add a trampoline to fix VMREAD error
> handling") removed the declaration of vmread_error() causes a W=1 build
> failure with KVM_WERROR=y. Fix it by adding it back.
> 
> arch/x86/kvm/vmx/vmx.c:359:17: error: no previous prototype for 'vmread_error' [-Werror=missing-prototypes]
>  asmlinkage void vmread_error(unsigned long field, bool fault)
>                  ^~~~~~~~~~~~
> 
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  arch/x86/kvm/vmx/ops.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
> index 09b0937d56b1..19717d0a1100 100644
> --- a/arch/x86/kvm/vmx/ops.h
> +++ b/arch/x86/kvm/vmx/ops.h
> @@ -12,6 +12,7 @@
>  
>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>  
> +asmlinkage void vmread_error(unsigned long field, bool fault);
>  __attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
>  							 bool fault);
>  void vmwrite_error(unsigned long field, unsigned long value);
> 

Merged, thanks.

Paolo


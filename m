Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898E5376A93
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 21:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhEGTRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 15:17:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229742AbhEGTRF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 15:17:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620414965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MB5ncAGYdykK27R25fWvdgHAfoJfDxp5CH8tHyJXPRE=;
        b=Gu38e27h3GdcV8zdOFMk5CA/NPTr4m1E37V09Y8UNisyZitXKV30x1pBlk2HZp7TKTgD8g
        bwk1DQEZcdj7ujalDebJntfHkzcpXOhReikNLF6pQMmqJ+i8//dZS6E52SV7sf0I+rJcPL
        HfNVUo/uo0pWdONzp1VI6yOiFLUPfvc=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-q7CQ414NM0OlDHfNVRSi9w-1; Fri, 07 May 2021 15:16:03 -0400
X-MC-Unique: q7CQ414NM0OlDHfNVRSi9w-1
Received: by mail-qt1-f200.google.com with SMTP id g21-20020ac858150000b02901ba6163708bso6407679qtg.5
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 12:16:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MB5ncAGYdykK27R25fWvdgHAfoJfDxp5CH8tHyJXPRE=;
        b=pGHyhhLfp5wROFXFq+K33nbmLQVhOhNAf1GRcPypAFrYDhzyLV++id3LFrx+0fuVXX
         g+3yk4O8us3C7ZwE+paHQpSi+fORZhysiq3st/N/p00FcyyhS/maguQchxPAKKgW6Mox
         oKFKQIE+yefyl7Bx+JeY6ABt0mb6WbzYhMhK12l4lhZLmidHT5jBmnLm7bIivyPIdHmr
         641znyqqP6Z4aRCxAIxIVAZzfsQyJLh6H8IAWk66Mi/3e0Yi9MDZL8Z0+79+VH1qZ0rr
         rZsoeHcQ7/BeymiEujCVA+AxsjCbTXiiJzYarBhH3yxiblyJsghgTnQXmgW5Rd9Xb7o1
         oW+A==
X-Gm-Message-State: AOAM531+0yeSZVFaIaTjR0RARHYWboYWSfaiWcLJWDDUoAl1qVTlwzUn
        PlSPC6CooOP1YoyeCrerEKmtjEAQf3VDJIuP/fmVpDFfQv4x07eQLS5hxqeEnz63+nwUTO6t8fN
        mfPk8q9rv6QbF
X-Received: by 2002:a37:6a47:: with SMTP id f68mr11200965qkc.12.1620414962979;
        Fri, 07 May 2021 12:16:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLiGZG9URA/v9L5ayIxdSjICn4xRZYcytXlnguwldGknGCs2D1IuRV0x5UFCLATbkc24jZ1Q==
X-Received: by 2002:a37:6a47:: with SMTP id f68mr11200940qkc.12.1620414962733;
        Fri, 07 May 2021 12:16:02 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id n15sm5501969qti.51.2021.05.07.12.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 12:16:02 -0700 (PDT)
Date:   Fri, 7 May 2021 15:16:00 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [patch 1/4] KVM: x86: add start_assignment hook to kvm_x86_ops
Message-ID: <YJWR8G+2RSESOQyS@t490s>
References: <20210507130609.269153197@redhat.com>
 <20210507130923.438255076@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210507130923.438255076@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021 at 10:06:10AM -0300, Marcelo Tosatti wrote:
> Add a start_assignment hook to kvm_x86_ops, which is called when 
> kvm_arch_start_assignment is done.
> 
> The hook is required to update the wakeup vector of a sleeping vCPU
> when a device is assigned to the guest.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> Index: kvm/arch/x86/include/asm/kvm_host.h
> ===================================================================
> --- kvm.orig/arch/x86/include/asm/kvm_host.h
> +++ kvm/arch/x86/include/asm/kvm_host.h
> @@ -1322,6 +1322,7 @@ struct kvm_x86_ops {
>  
>  	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
>  			      uint32_t guest_irq, bool set);
> +	void (*start_assignment)(struct kvm *kvm, int device_count);

I'm thinking what the hook could do with the device_count besides comparing it
against 1...

If we can't think of any, perhaps we can directly make it an enablement hook
instead (so we avoid calling the hook at all when count>1)?

   /* Called when the first assignment registers (count from 0 to 1) */
   void (*enable_assignment)(struct kvm *kvm);

-- 
Peter Xu


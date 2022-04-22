Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB91550B265
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 09:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382596AbiDVIB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 04:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242754AbiDVIBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 04:01:23 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EE134678
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 00:58:31 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id y11so4582044ilp.4
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 00:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bs1ARD/3mYc/Q8GOvyTn31OWHleeyCohrGDUgjVzb5c=;
        b=p+I+yyKB3vk9fRPIkec81mqI7u7jjNG4T/gBJ7wEluxmyol/g/AAulxisd7IjBxgr2
         IO6BpSnF1kpLqLtrdnvrHaTUJv0X2wBtdniE/vF2ftltP2695m9jCGk4rRlGK8tOchIX
         DlGhM0xaSPRnCZQx7+9tFMg1cvBMYUTK09FM0PNRn+VHNTXzyvQATMS8o6aBe40UaOqB
         FGfOWAw7zIE0ev4+5dxe0f2SMwTyZlRzBP/x3mUsH/00DNrTIfks0QKDdqfywjvbK+ut
         zMxmoLAKwNdMgG1bQDz8doVsp1uwm2fWWa2FRdN8rgAwgg7shr1NqQb3KPlHx0IHfH+x
         1Xeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bs1ARD/3mYc/Q8GOvyTn31OWHleeyCohrGDUgjVzb5c=;
        b=Nt5vA2WHDRqfOHC/SWDn/Yl75MATe01HBNB1AZHthfbHgfPs0kTY5vLH6lPLZ47Mr5
         lGtTBS6BrSDC+x1WJ0rHj4WLs++mC3NiKgiNxNpPF7mfgmOaCYQzTZf2qqC3W8WyIOTy
         LSWGFNLTkXUjdAx47B/5FauWIwfHg+Q0QeMG/U4g4UqRi1oeV4qX7v2zSWNII6+86ncc
         IU5jiSUrDzpM3F0jla2+mVv4OK0wVZYcSuSvThW3DsLzoKbnwuBJMJorZ/tO7Z++1T6c
         M5naI210qLCPPl/s17wvo+DMxD/0LTad4MVZcloGkC9ucpGHdH+/rWKHgAvpZeIJPzGc
         lLFg==
X-Gm-Message-State: AOAM5328boNOTStARWtFmVu2rAZAj12K89mEYLvuX+CHH7u7ylZp4qRT
        GfniwR7PVEJThWySIdktDEXT6w==
X-Google-Smtp-Source: ABdhPJxGh4l1P/5zNuiHNIaIg80R6S4iA2eyq7GpR4Gotde6duI/fSeWt3QpVY9yefAmiuwTK8d/2A==
X-Received: by 2002:a05:6e02:148f:b0:2cd:2242:40d6 with SMTP id n15-20020a056e02148f00b002cd224240d6mr1503449ilk.187.1650614310633;
        Fri, 22 Apr 2022 00:58:30 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id f4-20020a056e0204c400b002caa9f3cc3fsm893115ils.56.2022.04.22.00.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 00:58:29 -0700 (PDT)
Date:   Fri, 22 Apr 2022 07:58:25 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, will@kernel.org,
        maz@kernel.org, apatel@ventanamicro.com, atishp@rivosinc.com,
        seanjc@google.com, pgonda@google.com
Subject: Re: [PATCH 0/4] KVM: fix KVM_EXIT_SYSTEM_EVENT mess
Message-ID: <YmJgIQe+5zGbrxoF@google.com>
References: <20220421180443.1465634-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421180443.1465634-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Thu, Apr 21, 2022 at 02:04:39PM -0400, Paolo Bonzini wrote:
> The KVM_SYSTEM_EVENT_NDATA_VALID mechanism that was introduced
> contextually with KVM_SYSTEM_EVENT_SEV_TERM is not a good match
> for ARM and RISC-V, which want to communicate information even
> for existing KVM_SYSTEM_EVENT_* constants.  Userspace is not ready
> to filter out bit 31 of type, and fails to process the
> KVM_EXIT_SYSTEM_EVENT exit.
> 
> Therefore, tie the availability of ndata to a system capability;
> if the capability is present, ndata is always valid, so patch 1
> makes x86 always initialize it.  Then patches 2 and 3 fix
> ARM and RISC-V compilation and patch 4 enables the capability.
> 
> Only compiled on x86, waiting for acks.
> 
> Paolo
> 
> Paolo Bonzini (4):
>   KVM: x86: always initialize system_event.ndata
>   KVM: ARM: replace system_event.flags with ndata and data[0]
>   KVM: RISC-V: replace system_event.flags with ndata and data[0]
>   KVM: tell userspace that system_event.ndata is valid

Is there any way we could clean this up in 5.18 and leave the whole
ndata/data pattern for 5.19?

IOW, for 5.18 go back and fix the padding:

	struct {
		__u32 type;
		__u32 pad;
		__u64 flags;
	} system_event;

Then for 5.19 circle back on the data business, except use a flag bit
for it:

	struct {
		__u32 type;
		__u32 pad;
	#define KVM_SYSTEM_EVENT_NDATA_VALID	(1u << 63)
		__u64 flags;
		__u64 ndata;
		__u64 data[16];
	} system_event;

Where we apply that bit to system_event::flags this time instead of
::type. Could also go the CAP route.

Wouldn't this be enough to preserve ABI with whatever userspace has been
spun up for system_event::flags already and also keep the SEV stuff
happy in 5.19?

It is a bit weird to churn existing UAPI usage in the very next kernel
cycle, but could be convinced otherwise :)

--
Thanks,
Oliver

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8D64FFF61
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 21:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237018AbiDMTfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 15:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbiDMTfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 15:35:45 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52103765BF
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 12:33:23 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o5so3035799pjr.0
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 12:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hV/H8KXb1u1bVyvfqTqt+bNKq1N6P+ZCAZk76VK4gPQ=;
        b=F7hKOLDt0ouUufGPuxfRuLkpaMOjt3CE4E33P7gWfSFAfaGetyKJGhJE9q9E1QP/A4
         qGYKzkb7CV1tgoxgW4KDDSQs90Spb2/JxXTkihHGF73L40NIBmq5FYk7kusl6UFJrxY6
         /YAVi0muyJO5wB4a1sK81foRvgoKTG0DnBa9r+GIK4Fmn1mEQxuP0y/5PM0QBBYTwnBr
         XExwl+t5R4ZaOICi6DNeSg9xp6mCUhf2IeU8YFJ4L2JcghLRhzq96P71j89y1+CPbyi+
         LTvEy7s+BQQoHXxxjd0a9bBbNIqWUeJGvgPj2g86b34ABFm0NtTH5fQhxgTeycwM+SiT
         drSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hV/H8KXb1u1bVyvfqTqt+bNKq1N6P+ZCAZk76VK4gPQ=;
        b=podEnyBIvuS2UFii/LpCEBnL+Pvxg0WMIf9IOIyAPEleykzBwCr6f2OD6hNJIzy2/d
         cYVCbkoUbYOgFDi0Dh6iOop9I5ZS71kJaXtzakZwwPFr2KcSlpvlplgcs1Yp1Daeuimf
         o2a91gw+5Yy5N9jjalEyLjtU2pnDwkNg5nV4S4a6LdHac3+VQVF4F/IyYtDVRc1YzOiY
         ZOSYWnwVtefU999CtnPCk9ZOgIIJuQQvQQ8z5DqQ/QXwSnKg/hBTeFjpwYRKQshDYiVL
         5S91xQ4xB88w6fzTfP45YZoaJl/ZOMKy49O+x+u9C1ex24B+i3h5218j++/9rKK75Dcn
         4RMQ==
X-Gm-Message-State: AOAM532IWZGyqb5bzjyQiUB3DIxZI+9m/dIrbbVQkA5+aIqKdFKJj22+
        MJu0hv7MTxJHtIFXTewdEipVwA==
X-Google-Smtp-Source: ABdhPJyQT2FNV5chkEcXbsh7Q2nu2kP73Csp40WIuXteGCelDsct/Mv/5Y7qLCwvAKEA+V4LqDrNtA==
X-Received: by 2002:a17:90a:8595:b0:1bf:4592:a819 with SMTP id m21-20020a17090a859500b001bf4592a819mr275744pjn.183.1649878402625;
        Wed, 13 Apr 2022 12:33:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79574000000b005061f4782c5sm3316360pfq.183.2022.04.13.12.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:33:21 -0700 (PDT)
Date:   Wed, 13 Apr 2022 19:33:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 08/10] x86: Move 32-bit bringup
 routines to start32.S
Message-ID: <YlclfjU6BMN72hUm@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-9-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173407.13637-9-varad.gautam@suse.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, Varad Gautam wrote:
> These can be shared across EFI and non-EFI builds.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
> diff --git a/x86/start32.S b/x86/start32.S
> new file mode 100644
> index 0000000..9e00474
> --- /dev/null
> +++ b/x86/start32.S
> @@ -0,0 +1,62 @@
> +/* Common 32-bit code between EFI and non-EFI bootstrapping. */
> +
> +.code32
> +
> +MSR_GS_BASE = 0xc0000101
> +
> +.macro setup_percpu_area
> +	lea -4096(%esp), %eax
> +	mov $0, %edx
> +	mov $MSR_GS_BASE, %ecx
> +	wrmsr
> +.endm
> +
> +.macro setup_segments
> +	mov $MSR_GS_BASE, %ecx
> +	rdmsr
> +
> +	mov $0x10, %bx
> +	mov %bx, %ds
> +	mov %bx, %es
> +	mov %bx, %fs
> +	mov %bx, %gs
> +	mov %bx, %ss
> +
> +	/* restore MSR_GS_BASE */
> +	wrmsr
> +.endm
> +
> +prepare_64:
> +	lgdt gdt_descr
> +	setup_segments
> +
> +	xor %eax, %eax
> +	mov %eax, %cr4
> +
> +enter_long_mode:
> +	mov %cr4, %eax
> +	bts $5, %eax  // pae
> +	mov %eax, %cr4
> +
> +	mov pt_root, %eax
> +	mov %eax, %cr3
> +
> +efer = 0xc0000080
> +	mov $efer, %ecx
> +	rdmsr
> +	bts $8, %eax
> +	wrmsr
> +
> +	mov %cr0, %eax
> +	bts $0, %eax
> +	bts $31, %eax
> +	mov %eax, %cr0
> +	ret
> +
> +ap_start32:
> +	setup_segments
> +	mov $-4096, %esp
> +	lock xaddl %esp, smp_stacktop
> +	setup_percpu_area
> +	call prepare_64

I suspect this will conflict with my idea of using a dedicated percpu area.  But
can't that be remedied by adding a prep patch to drop setup_percpu_area and add a
C helper to the setup (using the dedicated area), called from ap_start64()?  I don't
see any instances of gs: being used before reset_apic().

Then the funky save/restore of MSR_GS_BASE also disappears.

> +	ljmpl $8, $ap_start64
> -- 
> 2.32.0
> 

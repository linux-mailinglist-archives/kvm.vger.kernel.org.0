Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0FC539711
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347308AbiEaTjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345150AbiEaTj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:39:29 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250CF562EB
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 12:39:28 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id w2-20020a17090ac98200b001e0519fe5a8so3251593pjt.4
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 12:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0mQPcYFy8mM+96zbgJ+oQhNhKHCc0LNt7c679Q5oveg=;
        b=HVim7kJ0YdygiWIjmmBICcaMPf5sAua4KnHtdR/fKxfJngYaVKGxyI+LDLMkk3MTHr
         XPkZyJu+/wzaX7gmgaON5ize1deoGJHKWzC3VrTmb4T9SufHiFrT038Js7qWlRR0kV21
         xSQ58JOF9ciO2+oJznly9TQheRsRDuXG37YbYl18nwsuDOPG4IpDRwNylr/goahNyqWP
         wUsRH8Aqe8bUrVnAia0hne2T4ZklAva/+mnAHwM+pHXY3McsEwDa5ROuhlhsLxdoRfCV
         NcKA7Y3Sw9CIL0GAUMEF7oc+okKGxfm12ZIp0fFTGHXTlDYhRtiJGIR1DeG4915oE9HZ
         89YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0mQPcYFy8mM+96zbgJ+oQhNhKHCc0LNt7c679Q5oveg=;
        b=wP1eS3byhzn2YemjmNBi0FCCTHWCZsLMFD5SmDqjP5HvQr9Tt8HD84hN1tT6X4ODdZ
         8xapNN5aKrVo9IMACusiYw6ZZoPS75jPjoZMTSOQxQjbWqS8fQ5dC7GZYl8+IGUFihM8
         CJwMvQdWVqTSo9JZw1UbTZ1OTqPvnNEvWWYi6zPHhleNFpbE8YsXQa9fsLxu/QiYzP0c
         kV9hH3G7QQBTKU9UErLx70vTZsVUSHvqEinZAm1EeQekznEvbFTpWNFxMPC6TjoBu1Wl
         E0xVlmp55ssovfHOleBY79AtJuv8kaO34VZeznEmr3rr0QifFjyV4+HX7Li8KkmAzMZO
         87ew==
X-Gm-Message-State: AOAM533KOmr9LmgCpgf4sOz8BuvDY61XL9SI91ppzQz0f3razG7OeuNV
        fVclMlcQc5cKc/uZJweXl+oG/g==
X-Google-Smtp-Source: ABdhPJxTZAcl7iQWstjSWF0N/wRDRXCsUc7sWdacq43Z0jno5vV7U/WPDqtvq3gvSrI/vtWY97E04w==
X-Received: by 2002:a17:90a:ba11:b0:1df:2d09:1308 with SMTP id s17-20020a17090aba1100b001df2d091308mr29797604pjr.184.1654025967457;
        Tue, 31 May 2022 12:39:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l26-20020a635b5a000000b003fc2411d5adsm4041184pgm.70.2022.05.31.12.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 12:39:27 -0700 (PDT)
Date:   Tue, 31 May 2022 19:39:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: Adjust the return type of
 kvm_vm_ioctl_check_extension_generic()
Message-ID: <YpZu6/k+8EydfBKf@google.com>
References: <20220531075540.14242-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531075540.14242-1-thuth@redhat.com>
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

On Tue, May 31, 2022, Thomas Huth wrote:
> kvm_vm_ioctl_check_extension_generic() either returns small constant
> numbers or the result of kvm_vm_ioctl_check_extension() which is of type
> "int". Looking at the callers of kvm_vm_ioctl_check_extension_generic(),
> one stores the result in "int r", the other one in "long r", so the
> result has to fit in the smaller "int" in any case. Thus let's adjust
> the return value to "int" here so we have one less transition from
> "int" -> "long" -> "int" in case of the kvm_vm_ioctl() ->
> kvm_vm_ioctl_check_extension_generic() -> kvm_vm_ioctl_check_extension()
> call chain.

LOL, I was going to play devil's advocate and say that it would be just as easy
to adjust kvm_vm_ioctl() to use "long r", but there's actually lurking bug, sort
of.

KVM_GET_NR_MMU_PAGES => kvm_vm_ioctl_get_nr_mmu_pages() returns an "unsigned long",
and it very much can be a value larger than an "int" because KVM_SET_NR_MMU_PAGES
allows setting an arbitrary value (it may also be possible for KVM's default to
be that large, but I don't feel like doing math).

But, the very original commit 82ce2c96831f ("KVM: Allow dynamic allocation of the
mmu shadow cache size") only tracked and returned an "unsigned int".  It was the
relatively recent commit bc8a3d8925a8 ("kvm: mmu: Fix overflow on kvm mmu page
limit calculation") that bumped the internal tracking to "unsigned long" and
overlooked the long/int mess.

Looking at other architectures, kvm_vm_ioctl_create_spapr_tce() also returns a
"long", but that's unnecessary as it only returns -errno or propagates "int" returns.

Ditto for kvm_arch_vm_ioctl_hv(), kvm_arch_vm_ioctl_pr(), and
kvm_vm_ioctl_mte_copy_tags().

Ignoring KVM_GET_NR_MMU_PAGES for the moment, I like the change, but would rather
phrase the justification along the lines of:

  KVM uses "long" return values for functions that are wired up to
  "struct file_operations", but otherwise uses "int" return values for
  functions that can return 0/-errno in order to avoid unintentional
  divergences between 32-bit and 64-bit kernels.

and then make the same change to kvm_arch_vm_ioctl() and all its subordinates.

As for KVM_GET_NR_MMU_PAGES, my vote would be just sweep it under the rug with a
comment and blurb in the documentation that it's broken.  I highly doubt any VMM
actually uses the ioctl() in any meaningful way as it was largely made obsolete by
two-dimensional paging, e.g. neither QEMU nor our VMM use it.

> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  This patch is of very low importance - if you don't like it, please just
>  ignore. I just came across this nit while looking through the code and
>  thought that it might be somewhat nicer this way.
> 
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 64ec2222a196..e911331fc620 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4309,7 +4309,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
>  	return 0;
>  }
>  
> -static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> +static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  {
>  	switch (arg) {
>  	case KVM_CAP_USER_MEMORY:
> -- 
> 2.31.1
> 

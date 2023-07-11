Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AD274F36C
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 17:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbjGKP3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 11:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbjGKP3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 11:29:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5ADC133
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 08:29:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bacfa4ef059so6511186276.2
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 08:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689089357; x=1691681357;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BZNT+5cYt7mx7oEaiQ13ihjtEzSR8MjFtzStZZPURr4=;
        b=gypF4zw0UurGdZNnY7tnZPzjmzPO0RfqKibCydwdPBEGXgbUv+lfc/TYNQ7xQhqnoH
         IHDl5pNu9grquWf9ybhtrBkmnXq2a2enN7dZlVAChyz8igGvGXR7X1/0+Ye41RCY6eET
         z9pITmnv5VbSV7ed+9hXSzgMhmpdgdFx4dPujjW4ngz2zJKWIp42x/Pz/UPvMG5zA5BM
         893hc/eA8cM8/u5uaIkZEJKM4VaPBigIj1MOOgMjRIiYUyhztY194IZdvSvkD2bqEByG
         2hng92wvdPACTfDST52dj+cJejFvfOBiF9YkgWXarz8E5tP/HwfQez9roz5A1iundo/P
         80aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689089357; x=1691681357;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZNT+5cYt7mx7oEaiQ13ihjtEzSR8MjFtzStZZPURr4=;
        b=J1kcjWhZLXIsjDePOoCLnyMCRdetspLDDmNxbyKU3PHZYRZ3nd4/jWiFiBEIKk7zHP
         TWkdR258CAaHgO5N+hix93xEsugamuwQeajgjmdZOkxv9ev+AQ5fxrKl9mlA8JqFFT9q
         HajYtwl8oyuDT5XETjSJBFR4RWTaG7mMMQOvXK7QfqFedPzMhbHW9jdd6nH+i2cmebos
         6HtCESFOP/nfKLW4HmAFbtW8HsTZLRS6k6ks0AtSjk+ISsE5TbAJtzd9oubZwdknthfB
         cG/+yUor9jZh5JfEWgcqbqQ8EwhQr6BdIpU0TOtjSDaJp4IZIk7oMQrjKjcfZeTwJtIQ
         kc8Q==
X-Gm-Message-State: ABy/qLY6Ssz9b0wlIju4hWfhQRMAhQ01X8R2cVcp6LHOcXc9XiNCTibv
        JJuES7BdyOE+TICWKP0fpt2QeY84BNU=
X-Google-Smtp-Source: APBJJlGFGYYGagVN7vTY3wC9eCumsMZqXbeKPXvjR5MQqtf90kvmwuPYWXIb7T3NbU7esv5D5N974RuQD6o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5585:0:b0:bed:d03a:fc5f with SMTP id
 j127-20020a255585000000b00bedd03afc5fmr90974ybb.11.1689089357189; Tue, 11 Jul
 2023 08:29:17 -0700 (PDT)
Date:   Tue, 11 Jul 2023 08:29:15 -0700
In-Reply-To: <CAF7b7mrabLtnq+0Gtsg9FA+Gfr12FqbmfxwJZuQcBNDz1+3yLw@mail.gmail.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com> <CAF7b7mqKJTCENsb+5MZT+D=DwcSva-jMANjtYszMTm-ACvkiKA@mail.gmail.com>
 <CAF7b7mrabLtnq+0Gtsg9FA+Gfr12FqbmfxwJZuQcBNDz1+3yLw@mail.gmail.com>
Message-ID: <ZK11Sxobf53RsAmH@google.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 07, 2023, Anish Moorthy wrote:
> > Hmm, well not having to modify the vendor code would be nice... but
> > I'll have to look more at __gfn_to_pfn_memslot()'s callers (and
> > probably send more questions your way :). Hopefully it works out more
> > like what you suggest.
> 
> I took a look of my own, and I don't think moving the nowait query
> into __gfn_to_pfn_memslot() would work. At issue is the actual
> behavior of KVM_CAP_NOWAIT_ON_FAULT, which I documented as follows:
> 
> > The presence of this capability indicates that userspace may pass the
> > KVM_MEM_NOWAIT_ON_FAULT flag to KVM_SET_USER_MEMORY_REGION to cause KVM_RUN
> > to fail (-EFAULT) in response to page faults for which resolution would require
> > the faulting thread to sleep.

Well, that description is wrong for other reasons.  As mentioned in my reply
(got snipped), the behavior is not tied to sleeping or waiting on I/O.

>  Moving the nowait check out of __kvm_faultin_pfn()/user_mem_abort()
> and into __gfn_to_pfn_memslot() means that, obviously, other callers
> will start to see behavior changes. Some of that is probably actually
> necessary for that documentation to be accurate (since any usages of
> __gfn_to_pfn_memslot() under KVM_RUN should respect the memslot flag),
> but I think there are consumers of __gfn_to_pfn_memslot() from outside
> KVM_RUN.

Yeah, replace "in response to page faults" with something along the lines of "if
an access in guest context ..."

> Anyways, after some searching on my end: I think the only caller of
> __gfn_to_pfn_memslot() in core kvm/x86/arm64 where moving the "nowait"
> check into the function actually changes anything is gfn_to_pfn(). But
> that function gets called from vmx_vcpu_create() (through
> kvm_alloc_apic_access_page()), and *that* certainly doesn't look like
> something KVM_RUN does or would ever call.

Correct, but that particular gfn_to_pfn() works on a KVM-internal memslot, i.e.
will never have the "fast-only" flag set.

	hva = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT, <===
				      APIC_DEFAULT_PHYS_BASE, PAGE_SIZE);
	if (IS_ERR(hva)) {
		ret = PTR_ERR(hva);
		goto out;
	}

	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
	if (is_error_page(page)) {
		ret = -EFAULT;
		goto out;
	} 

On x86, there should not be any other usages of user memslots outside of KVM_RUN.
arm64 is unfortunately a different story (see this thread[*]), but we may be able
to solve that with a documentation update.  I *think* the accesses are limited to
the sub-ioctl KVM_DEV_ARM_VGIC_GRP_CTRL, and more precisely the sub-sub-ioctls
KVM_DEV_ARM_ITS_{SAVE,RESTORE}_TABLES and KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES.

[*] https://lore.kernel.org/all/Y1ghIKrAsRFwSFsO@google.com

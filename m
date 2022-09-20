Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8345BEC5A
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 19:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiITRuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 13:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiITRt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 13:49:59 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61916B7DE
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:49:45 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id rt12so1394614pjb.1
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=a2oYsLQ3PVWHBh7aJPcuMHK0Eov6Y7MY3uJqzL8zsI0=;
        b=DfDVeMnWujZV+9FFOGgmWOKii3IfaaLDv7GDK1T6JqVPGewlcolYuGYSA9r9P6FyYW
         DRN/YLG/z/OvwAwvtuS+5R4HufEmGGgIEy7tRyafgCZiRqGIuByRFRS7uvIi3v05BPSM
         YvR+y264eP+9AKSGOFnmCG4IYsMdEK/umaSMij4xuJKdqCL7VTEvdg5tnMMNEH/usxBF
         bUAtjGd+S2ujjr/NHPRKXQyhc+BSi/Ljb1+BhmVLAJnySXmRyq7+Se+DPepri72Hu53p
         9i84x2JY2Dvc+DJkiJuGzoNr+/PDGZwyX/shalJxVrep6XBp7j7fqFsI8vZWV9sCIrL+
         +b+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=a2oYsLQ3PVWHBh7aJPcuMHK0Eov6Y7MY3uJqzL8zsI0=;
        b=SApBnzvm9qReCDUh5RDtN+kDJCdMw/MoI/GBsMcDeO3JBv3mmMirB8d0Nm2w7yb+Jv
         LOvps/wuF1i7eZUK355Y6/2pWvfKTUwQNJOV2cOZYieu/AaAhcZ5RLQCEAtUIL5Vz9Lh
         kF/8Jz5meA0HyxlyRQdsIhDHw5GMlDl+Tf/Jp6zhW7GAtQ1L6ErMdevDyzHsX6O8TK0/
         07TLcfXD34TSofMXgaGo8AUABeEQLzWhFsuSRgd0AHrUAt2WsJHX0oHP7jp0c5Yh0X/7
         XlkwWCb2QbE5fDWzjT7HZvoUzebXzXWfD2j6QTtXYgKM6lLjsuem+r4lis1I9xJUU7Of
         ga6w==
X-Gm-Message-State: ACrzQf05Ur9FEP5QzsVuDGVxQJAWbhk+TYZ4smPE/mcI0j7g5dao6kEw
        XMPDas2MsId359kipPWiZWBFVw==
X-Google-Smtp-Source: AMsMyM4OMIqPdmgjX4n9vxLmpMRKJZmYnaVXN+rH/Ma3Oj4UcUc4AdAUZuNnrasjaczhxUEXXMVx3w==
X-Received: by 2002:a17:902:c189:b0:176:b871:8a1 with SMTP id d9-20020a170902c18900b00176b87108a1mr799560pld.30.1663696183470;
        Tue, 20 Sep 2022 10:49:43 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id z16-20020aa79e50000000b00537d7cc774bsm164533pfq.139.2022.09.20.10.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 10:49:42 -0700 (PDT)
Date:   Tue, 20 Sep 2022 10:49:38 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v7 07/13] KVM: selftests: Add vm->memslots[] and enum
 kvm_mem_region_type
Message-ID: <Yyn9Mny/EJS3ffQ8@google.com>
References: <20220920042551.3154283-1-ricarkol@google.com>
 <20220920042551.3154283-8-ricarkol@google.com>
 <Yyn6x6Y8wlMgSrgZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yyn6x6Y8wlMgSrgZ@google.com>
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

On Tue, Sep 20, 2022 at 05:39:19PM +0000, Sean Christopherson wrote:
> On Tue, Sep 20, 2022, Ricardo Koller wrote:
> > The vm_create() helpers are hardcoded to place most page types (code,
> > page-tables, stacks, etc) in the same memslot #0, and always backed with
> > anonymous 4K.  There are a couple of issues with that.  First, tests willing to
> 
> Preferred kernel style is to wrap changelogs at ~75 chars, e.g. so that `git show`
> stays under 80 chars.
> 
> And in general, please incorporate checkpatch into your workflow, e.g. there's
> also a spelling mistake below.
> 
>   WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
>   #9: 
>   anonymous 4K.  There are a couple of issues with that.  First, tests willing to
> 
>   WARNING: 'spreaded' may be misspelled - perhaps 'spread'?
>   #12: 
>   the hardcoded assumption of memslot #0 holding most things is spreaded
>                                                               ^^^^^^^^
> 
>   total: 0 errors, 2 warnings, 94 lines checked
> 
> > differ a bit, like placing page-tables in a different backing source type must
> > replicate much of what's already done by the vm_create() functions.  Second,
> > the hardcoded assumption of memslot #0 holding most things is spreaded
> > everywhere; this makes it very hard to change.
> 
> ...
> 
> > @@ -105,6 +119,13 @@ struct kvm_vm {
> >  struct userspace_mem_region *
> >  memslot2region(struct kvm_vm *vm, uint32_t memslot);
> >  
> > +inline struct userspace_mem_region *
> 
> Should be static inline.
> 
> > +vm_get_mem_region
> 
> Please don't insert newlines before the function name, it makes searching painful.
> Ignore existing patterns in KVM selfetsts, they're wrong.  ;-)  Linus has a nice
> explanation/rant on this[*].
> 
> The resulting declaration will run long, but at least for me, I'll take that any
> day over putting the function name on a new line.
> 
> [*] https://lore.kernel.org/all/CAHk-=wjoLAYG446ZNHfg=GhjSY6nFmuB_wA8fYd5iLBNXjo9Bw@mail.gmail.com
> 
> 
> > (struct kvm_vm *vm, enum kvm_mem_region_type mrt)
> 
> One last nit, what about "region" or "type" instead of "mrt"?  The acronym made me
> briefly pause to figure out what "mrt" meant, which is silly because the name really
> doesn't have much meaning.
> 
> > +{
> > +	assert(mrt < NR_MEM_REGIONS);
> > +	return memslot2region(vm, vm->memslots[mrt]);
> > +}
> 
> ...
> 
> > @@ -293,8 +287,16 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
> >  	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
> >  						 nr_extra_pages);
> >  	struct kvm_vm *vm;
> > +	int i;
> > +
> > +	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
> > +		 vm_guest_mode_string(mode), nr_pages);
> > +
> > +	vm = ____vm_create(mode);
> > +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
> 
> The spacing is weird here.  Adding the region and stuffing vm->memslots are what
> should be bundled together, not creating the VM and adding the common region.  I.e.
> 
> 	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
> 		 vm_guest_mode_string(mode), nr_pages);
> 
> 	vm = ____vm_create(mode);
> 
> 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
> 	for (i = 0; i < NR_MEM_REGIONS; i++)
> 		vm->memslots[i] = 0;
> 
> >  
> > -	vm = ____vm_create(mode, nr_pages);
> > +	for (i = 0; i < NR_MEM_REGIONS; i++)
> > +		vm->memslots[i] = 0;
> >  
> >  	kvm_vm_elf_load(vm, program_invocation_name);
> >  
> > -- 
> > 2.37.3.968.ga6b4b080e4-goog
> > 

Ack on all the above. Will send a v8 later today.

Thanks!
Ricardo

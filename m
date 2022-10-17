Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E35600C1A
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 12:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiJQKP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 06:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiJQKPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 06:15:51 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE89DFE9
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 03:15:50 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id a3so17795097wrt.0
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 03:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FcjnuXRaDiwRJahvKb8RBCSyzSGwOC5LjhLUGe1uDng=;
        b=hyvfh2EkmGJkje0pk/QxmrMK3wu58HezXpCWZTir75qkSbdgybYs5f9BdEJQ8VRxZo
         y6aRpYY6PJTNs0keePmRwtJhkNJD/XdF8OsFUhWZ+UwwjrnzDoAYIKRkdVUgvJixyXjW
         nD/o6Eqw8u2mx1XAbOWJsbL1mUmxxl7uY7YrsW4c+w0aEXLsr3iTAgFzKFCcXNq9JWeD
         DtktHswPI1Ib69o/b5Xw5PWUIeu21lJtPIx06bfk/qBH1eUXTV/osa+5ULa0LTre2WLP
         s1m1famLesITF3XC4ZTWNGzXqcgELAkbqC6CXhHknsOgV91Knx2CcUJjk+K6FMwFZKrp
         i0nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FcjnuXRaDiwRJahvKb8RBCSyzSGwOC5LjhLUGe1uDng=;
        b=sU1Brihkvd91XgfzROo9FSfCph9d0mtf++rDChDKj0AtkEq/ks+Z5/ql+7w/mRGD/F
         0P2J1h16EST2q7uv8hnP2FD+pJFpzf0a+oEaxPYBFRx+NrIVniY+RUuzHHKaxDUqyJLp
         n2z38immvs1uaEmf8enRUurv7vRVVwfsAGZq0DlKZfkqZ/Dne8sQs6vnvQ4RS1sriXO1
         gaNtZsRg2/j3VtT12vMKEGPxVDpPvY05sNGyd+weDtjQ+GklrzNL9iDcPsDmi1v1jf9o
         vntOZkvK2IQy6Bj0VuLQQUsvuoar08d/vvuf+bPfARkLL+gcAOXgkEfaFhilcdGrOss6
         sp8Q==
X-Gm-Message-State: ACrzQf169T3XAfI4g7AmZdICECfsNrz82rwxvuT6AJwuvOlJTyXJswhR
        CLmzefO63PlmF/nghjM9VhTsh31W4lof7hmYUFGobQAQ3ip1Dw==
X-Google-Smtp-Source: AMsMyM5H+U3jrxyNNUs6l1VKxbOPrLqVbM8TSFTJ1Nj0WQRe3+Q8Gepb86AIPBI4Du2SI+pEA/5+OnPmPbAp2YR5khI=
X-Received: by 2002:a2e:bd12:0:b0:264:7373:3668 with SMTP id
 n18-20020a2ebd12000000b0026473733668mr3490403ljq.18.1666001738408; Mon, 17
 Oct 2022 03:15:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220915142913.2213336-1-chao.p.peng@linux.intel.com>
 <20220915142913.2213336-6-chao.p.peng@linux.intel.com> <CA+EHjTxukqBfaN6D+rPOiX83zkGknHEQ16J0k6GQSdL_-e9C6g@mail.gmail.com>
 <20221012023516.GA3218049@chaop.bj.intel.com>
In-Reply-To: <20221012023516.GA3218049@chaop.bj.intel.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 17 Oct 2022 11:15:02 +0100
Message-ID: <CA+EHjTyGyGL+ox81=jdtoHERtHPV=P7wJub=3j7chdijyq-AgA@mail.gmail.com>
Subject: Re: [PATCH v8 5/8] KVM: Register/unregister the guest private memory regions
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, jun.nakajima@intel.com, dave.hansen@intel.com,
        ak@linux.intel.com, david@redhat.com, aarcange@redhat.com,
        ddutile@redhat.com, dhildenb@redhat.com,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>, mhocko@suse.com,
        Muchun Song <songmuchun@bytedance.com>, wei.w.wang@intel.com
Content-Type: text/plain; charset="UTF-8"
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

Hi,

> > > +#ifdef CONFIG_HAVE_KVM_PRIVATE_MEM
> > > +#define KVM_MEM_ATTR_SHARED    0x0001
> > > +static int kvm_vm_ioctl_set_mem_attr(struct kvm *kvm, gpa_t gpa, gpa_t size,
> > > +                                    bool is_private)
> > > +{
> >
> > I wonder if this ioctl should be implemented as an arch-specific
> > ioctl. In this patch it performs some actions that pKVM might not need
> > or might want to do differently.
>
> I think it's doable. We can provide the mem_attr_array kind thing in
> common code and let arch code decide to use it or not. Currently
> mem_attr_array is defined in the struct kvm, if those bytes are
> unnecessary for pKVM it can even be moved to arch definition, but that
> also loses the potential code sharing for confidential usages in other
> non-architectures, e.g. if ARM also supports such usage. Or it can be
> provided through a different CONFIG_ instead of
> CONFIG_HAVE_KVM_PRIVATE_MEM.

This sounds good. Thank you.


/fuad

> Thanks,
> Chao
> >
> > pKVM tracks the sharing status in the stage-2 page table's software
> > bits, so it can avoid the overhead of using mem_attr_array.
> >
> > Also, this ioctl calls kvm_zap_gfn_range(), as does the invalidation
> > notifier (introduced in patch 8). For pKVM, the kind of zapping (or
> > the information conveyed to the hypervisor) might need to be different
> > depending on the cause; whether it's invalidation or change of sharing
> > status.
>
> >
> > Thanks,
> > /fuad
> >
> >
> > > +       gfn_t start, end;
> > > +       unsigned long index;
> > > +       void *entry;
> > > +       int r;
> > > +
> > > +       if (size == 0 || gpa + size < gpa)
> > > +               return -EINVAL;
> > > +       if (gpa & (PAGE_SIZE - 1) || size & (PAGE_SIZE - 1))
> > > +               return -EINVAL;
> > > +
> > > +       start = gpa >> PAGE_SHIFT;
> > > +       end = (gpa + size - 1 + PAGE_SIZE) >> PAGE_SHIFT;
> > > +
> > > +       /*
> > > +        * Guest memory defaults to private, kvm->mem_attr_array only stores
> > > +        * shared memory.
> > > +        */
> > > +       entry = is_private ? NULL : xa_mk_value(KVM_MEM_ATTR_SHARED);
> > > +
> > > +       for (index = start; index < end; index++) {
> > > +               r = xa_err(xa_store(&kvm->mem_attr_array, index, entry,
> > > +                                   GFP_KERNEL_ACCOUNT));
> > > +               if (r)
> > > +                       goto err;
> > > +       }
> > > +
> > > +       kvm_zap_gfn_range(kvm, start, end);
> > > +
> > > +       return r;
> > > +err:
> > > +       for (; index > start; index--)
> > > +               xa_erase(&kvm->mem_attr_array, index);
> > > +       return r;
> > > +}
> > > +#endif /* CONFIG_HAVE_KVM_PRIVATE_MEM */
> > > +
> > >  #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
> > >  static int kvm_pm_notifier_call(struct notifier_block *bl,
> > >                                 unsigned long state,
> > > @@ -1165,6 +1206,9 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
> > >         spin_lock_init(&kvm->mn_invalidate_lock);
> > >         rcuwait_init(&kvm->mn_memslots_update_rcuwait);
> > >         xa_init(&kvm->vcpu_array);
> > > +#ifdef CONFIG_HAVE_KVM_PRIVATE_MEM
> > > +       xa_init(&kvm->mem_attr_array);
> > > +#endif
> > >
> > >         INIT_LIST_HEAD(&kvm->gpc_list);
> > >         spin_lock_init(&kvm->gpc_lock);
> > > @@ -1338,6 +1382,9 @@ static void kvm_destroy_vm(struct kvm *kvm)
> > >                 kvm_free_memslots(kvm, &kvm->__memslots[i][0]);
> > >                 kvm_free_memslots(kvm, &kvm->__memslots[i][1]);
> > >         }
> > > +#ifdef CONFIG_HAVE_KVM_PRIVATE_MEM
> > > +       xa_destroy(&kvm->mem_attr_array);
> > > +#endif
> > >         cleanup_srcu_struct(&kvm->irq_srcu);
> > >         cleanup_srcu_struct(&kvm->srcu);
> > >         kvm_arch_free_vm(kvm);
> > > @@ -1541,6 +1588,11 @@ static void kvm_replace_memslot(struct kvm *kvm,
> > >         }
> > >  }
> > >
> > > +bool __weak kvm_arch_has_private_mem(struct kvm *kvm)
> > > +{
> > > +       return false;
> > > +}
> > > +
> > >  static int check_memory_region_flags(const struct kvm_user_mem_region *mem)
> > >  {
> > >         u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
> > > @@ -4703,6 +4755,24 @@ static long kvm_vm_ioctl(struct file *filp,
> > >                 r = kvm_vm_ioctl_set_memory_region(kvm, &mem);
> > >                 break;
> > >         }
> > > +#ifdef CONFIG_HAVE_KVM_PRIVATE_MEM
> > > +       case KVM_MEMORY_ENCRYPT_REG_REGION:
> > > +       case KVM_MEMORY_ENCRYPT_UNREG_REGION: {
> > > +               struct kvm_enc_region region;
> > > +               bool set = ioctl == KVM_MEMORY_ENCRYPT_REG_REGION;
> > > +
> > > +               if (!kvm_arch_has_private_mem(kvm))
> > > +                       goto arch_vm_ioctl;
> > > +
> > > +               r = -EFAULT;
> > > +               if (copy_from_user(&region, argp, sizeof(region)))
> > > +                       goto out;
> > > +
> > > +               r = kvm_vm_ioctl_set_mem_attr(kvm, region.addr,
> > > +                                             region.size, set);
> > > +               break;
> > > +       }
> > > +#endif
> > >         case KVM_GET_DIRTY_LOG: {
> > >                 struct kvm_dirty_log log;
> > >
> > > @@ -4856,6 +4926,9 @@ static long kvm_vm_ioctl(struct file *filp,
> > >                 r = kvm_vm_ioctl_get_stats_fd(kvm);
> > >                 break;
> > >         default:
> > > +#ifdef CONFIG_HAVE_KVM_PRIVATE_MEM
> > > +arch_vm_ioctl:
> > > +#endif
> > >                 r = kvm_arch_vm_ioctl(filp, ioctl, arg);
> > >         }
> > >  out:
> > > --
> > > 2.25.1
> > >

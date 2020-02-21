Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D5A168201
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 16:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgBUPlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 10:41:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36827 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728177AbgBUPlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 10:41:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582299671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PkrHTmMnLDCI5Vhqht83ivkWslTjiNlZ/bmjt1mLoEs=;
        b=arHS8ZQ8Bsdxtg2duoIy76xqZdVYOoimmtQpvmuq1yz6c3Kol37EAp7cEdc51eEaDKWYPw
        HZdtCBd8tTVvkX9Zea89gu2i9hwNY7S8MrJ+3cgQI0vMKzK/u78ZhBwR7YOSzBFAj73LHn
        oVMyoo2cDI0iJcjxVERfDH6SfBvtprg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-yKqwa6_DPpmY6Es37_QlIA-1; Fri, 21 Feb 2020 10:41:09 -0500
X-MC-Unique: yKqwa6_DPpmY6Es37_QlIA-1
Received: by mail-qt1-f197.google.com with SMTP id k27so2018617qtu.12
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 07:41:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PkrHTmMnLDCI5Vhqht83ivkWslTjiNlZ/bmjt1mLoEs=;
        b=mMZOvzuLaPDbt5ZXiF+jQ13E/QLylgHMHHWdY10M6R+Zxb2SmAUMrQNXeUNjWbjLC1
         XjBgB1qwBbnL5I8d4PmiWQ7CwykGNbzN9x1lEPzq+SZ3Cq++l9am/m4jHGhrjWxThYDd
         y8jnYn4n9pm6wR5t1czv9i352KwuUKfIRrZaYkepkfzJWJGn+xLKfGOYk0p93jECHWKd
         1XUM2AadGK//XvcxyWvpqXipP0b484FB9ot3TlQbsnBHSG7Fq+edlm2CdM6rsHxWnA/u
         H6RAvF0B0fuphNHJPsNHf3uLgOpNzRd2Vqj9aLVcXxhanUqyb2dETXERwlMb7OsN0sX6
         8/5Q==
X-Gm-Message-State: APjAAAW+HcefNLK9Gwa4vqOCWaYsoYD6cp26mU9TwnSHf2HbjKbJO+dd
        nVdyATQmxFLFkiVJwVZwK698KoGsX8btBVFFd3C+1F33mWZYacgu9sHXkMuMRlji/K2b3AU76il
        /0zwt8s0cRipU
X-Received: by 2002:a37:9b82:: with SMTP id d124mr14344049qke.74.1582299669230;
        Fri, 21 Feb 2020 07:41:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqwTnu54BnM/00MYCZYwvyC1xkx3Y08+1oCEHY9h9YebXryFCLr0kSOUoiZz9U/b4zV2f9LpSg==
X-Received: by 2002:a37:9b82:: with SMTP id d124mr14344020qke.74.1582299668978;
        Fri, 21 Feb 2020 07:41:08 -0800 (PST)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id b84sm1661060qkc.73.2020.02.21.07.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 07:41:08 -0800 (PST)
Date:   Fri, 21 Feb 2020 10:41:06 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Zhoujian (jay)" <jianjay.zhou@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: Re: [PATCH v2] KVM: x86: enable dirty log gradually in small chunks
Message-ID: <20200221154106.GB37727@xz-x1>
References: <20200220042828.27464-1-jianjay.zhou@huawei.com>
 <20200220192809.GA15253@xz-x1>
 <B2D15215269B544CADD246097EACE7474BB06606@DGGEMM528-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B2D15215269B544CADD246097EACE7474BB06606@DGGEMM528-MBX.china.huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 09:53:51AM +0000, Zhoujian (jay) wrote:
> 
> 
> > -----Original Message-----
> > From: Peter Xu [mailto:peterx@redhat.com]
> > Sent: Friday, February 21, 2020 3:28 AM
> > To: Zhoujian (jay) <jianjay.zhou@huawei.com>
> > Cc: kvm@vger.kernel.org; pbonzini@redhat.com; wangxin (U)
> > <wangxinxin.wang@huawei.com>; Huangweidong (C)
> > <weidong.huang@huawei.com>; sean.j.christopherson@intel.com; Liujinsong
> > (Paul) <liu.jinsong@huawei.com>
> > Subject: Re: [PATCH v2] KVM: x86: enable dirty log gradually in small chunks
> > 
> > On Thu, Feb 20, 2020 at 12:28:28PM +0800, Jay Zhou wrote:
> > > @@ -5865,8 +5865,12 @@ void
> > kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> > >  	bool flush;
> > >
> > >  	spin_lock(&kvm->mmu_lock);
> > > -	flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
> > > -				      false);
> > > +	if (kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET)
> > > +		flush = slot_handle_large_level(kvm, memslot,
> > > +						slot_rmap_write_protect, false);
> > > +	else
> > > +		flush = slot_handle_all_level(kvm, memslot,
> > > +						slot_rmap_write_protect, false);
> > 
> > Another extra comment:
> > 
> > I think we should still keep the old behavior for KVM_MEM_READONLY (in
> > kvm_mmu_slot_apply_flags())) for this...  
> 
> I also realized this issue after posting this patch, and I agree.
> 
> > Say, instead of doing this, maybe we
> > want kvm_mmu_slot_remove_write_access() to take a new parameter to
> > decide to which level we do the wr-protect.
> 
> How about using the "flags" field to distinguish:
> 
> 		if ((kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET)
>                 && (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES))
>                 flush = slot_handle_large_level(kvm, memslot,
>                                         slot_rmap_write_protect, false);
>         else
>                 flush = slot_handle_all_level(kvm, memslot,
>                                         slot_rmap_write_protect, false);

This seems to be OK too.  But just to show what I meant (which I still
think could be a bit clearer; assuming kvm_manual_dirty_log_init_set()
is the helper you'll introduce):

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 40a0c0fd95ca..a90630cde92d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1312,7 +1312,8 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,

 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
-                                     struct kvm_memory_slot *memslot);
+                                     struct kvm_memory_slot *memslot,
+                                     int start_level);
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
                                   const struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 87e9ba27ada1..f538b7977fa2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5860,13 +5860,14 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
 }

 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
-                                     struct kvm_memory_slot *memslot)
+                                     struct kvm_memory_slot *memslot,
+                                     int start_level)
 {
        bool flush;

        spin_lock(&kvm->mmu_lock);
-       flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
-                                     false);
+       flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
+                                 start_level, PT_MAX_HUGEPAGE_LEVEL, false);
        spin_unlock(&kvm->mmu_lock);

        /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb5d64ebc35d..2ed3204dfd9f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9956,7 +9956,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 {
        /* Still write protect RO slot */
        if (new->flags & KVM_MEM_READONLY) {
-               kvm_mmu_slot_remove_write_access(kvm, new);
+               kvm_mmu_slot_remove_write_access(kvm, new, PT_PAGE_TABLE_LEVEL);
                return;
        }

@@ -9993,8 +9993,20 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
        if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
                if (kvm_x86_ops->slot_enable_log_dirty)
                        kvm_x86_ops->slot_enable_log_dirty(kvm, new);
-               else
-                       kvm_mmu_slot_remove_write_access(kvm, new);
+               else {
+                       int level = kvm_manual_dirty_log_init_set(kvm) ?
+                           PT_DIRECTORY_LEVEL : PT_PAGE_TABLE_LEVEL;
+
+                       /*
+                        * If we're with intial-all-set, we don't need
+                        * to write protect any small page because
+                        * they're reported as dirty already.  However
+                        * we still need to write-protect huge pages
+                        * so that the page split can happen lazily on
+                        * the first write to the huge page.
+                        */
+                       kvm_mmu_slot_remove_write_access(kvm, new, level);
+               }
        } else {
                if (kvm_x86_ops->slot_disable_log_dirty)
                        kvm_x86_ops->slot_disable_log_dirty(kvm, new);

Thanks,

-- 
Peter Xu


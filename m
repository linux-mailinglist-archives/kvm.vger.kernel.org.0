Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F15168154
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 16:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgBUPTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 10:19:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51742 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727053AbgBUPTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 10:19:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582298372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lce68JJ6kZl7LSh6wgGvke4i12dEBEHPdmOXurQukMs=;
        b=hkesLXvueA4LpM3E0fpU0I26PaHjG8DG7eHRtqJJfNLYZ9ipH2Qsf33bllowbHbdo+DDiw
        ixSYyhq2692o9KnBOhxYUyGJGGClaxW3c0IQ/mbXIAimkKHm8i8lgG0xRGSSSCOg/J1YAz
        vs8+6BeDNYJPPD7nmojvdcYSXRgpDj8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-SGdXrlf2M26VlLRNWv2flg-1; Fri, 21 Feb 2020 10:19:30 -0500
X-MC-Unique: SGdXrlf2M26VlLRNWv2flg-1
Received: by mail-qt1-f200.google.com with SMTP id l1so1952488qtp.21
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 07:19:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lce68JJ6kZl7LSh6wgGvke4i12dEBEHPdmOXurQukMs=;
        b=ppr+fyIaHznyRjvW2hHXI6Ujlbm0Adn0gZz5TyAu3dlJyE+dX/M0XiHS0Zvr8Du0Vu
         3TwcuAvOUdMCuqhCdd5Tn5dmH6n1nQDQ1RtnloqRC880i8S64c+GZ4h7kQ0ZiPSRiBgA
         +iJig7jekcBQ9D6sxjMzeXPE95y1VPlN+i8j6i8WxPp11WzoBb+kyqLqfEtPChnjxPrV
         jynNIwa3zUnAEHJGqfRkM8c4SE770g8CrpyGm1gexld2iovn3/P0f2LCyCfjxhXDHAPO
         XNGUfBW2JJxuK++xQko7fT/wARv6Njhdtqc5zbknVQeRZYHT6GH55Kg7UEWD7MSnkm2U
         5Nrg==
X-Gm-Message-State: APjAAAV5qnBVHmlKhq/RRRQawGyFbMmIncPKH1COMu5qObSGtFtso8dN
        iFZcsy0AND837v1vhRpV45Xp9HVy8HTXI1q0/CMXD54sJraCI95dRNJIbN+kQgYaLacxtMlkW1a
        AXQ/tQKqeig97
X-Received: by 2002:ac8:5448:: with SMTP id d8mr31305308qtq.205.1582298369559;
        Fri, 21 Feb 2020 07:19:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqzn2VTAa5YnBD3OZl3Gszdth37YfsaLnDOdiFGdRnV/9VIExa0lnLJMfgNkAyOJPC+1tL1+kA==
X-Received: by 2002:ac8:5448:: with SMTP id d8mr31305282qtq.205.1582298369222;
        Fri, 21 Feb 2020 07:19:29 -0800 (PST)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id g84sm1603055qke.129.2020.02.21.07.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 07:19:28 -0800 (PST)
Date:   Fri, 21 Feb 2020 10:19:26 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Zhoujian (jay)" <jianjay.zhou@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: Re: [PATCH v2] KVM: x86: enable dirty log gradually in small chunks
Message-ID: <20200221151926.GA37727@xz-x1>
References: <20200220042828.27464-1-jianjay.zhou@huawei.com>
 <20200220191706.GF2905@xz-x1>
 <B2D15215269B544CADD246097EACE7474BB064B7@DGGEMM528-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B2D15215269B544CADD246097EACE7474BB064B7@DGGEMM528-MBX.china.huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 09:31:52AM +0000, Zhoujian (jay) wrote:

[...]

> > > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c
> > > b/tools/testing/selftests/kvm/dirty_log_test.c
> > > index 5614222..2a493c1 100644
> > > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > > @@ -317,10 +317,11 @@ static void run_test(enum vm_guest_mode mode,
> > unsigned long iterations,
> > >  	host_bmap_track = bitmap_alloc(host_num_pages);
> > >
> > >  #ifdef USE_CLEAR_DIRTY_LOG
> > > +	int ret = kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> > >  	struct kvm_enable_cap cap = {};
> > >
> > >  	cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
> > > -	cap.args[0] = 1;
> > > +	cap.args[0] = ret;
> > 
> > You enabled the initial-all-set but didn't really check it, so it didn't help much
> > from the testcase pov...  
> 
> vm_enable_cap is called afterwards, the return value is checked inside it,
> may I ask this check is enough, or it is needed to get the value through
> something like vm_get_cap ?

I meant to check what has offered by the initial-all-set feature bit,
which is, we should get the bitmap before dirtying and verify that
it's all ones.

> 
> > I'd suggest you drop this change, and you can work
> > on top after this patch can be accepted.
> 
> OK, some input parameters for cap.args[0] should be tested I think: 0, 1, 3
> should be accepted, the other numbers will not.

Yes. I think it'll be fine too if you want to put the test changes
into this patch. It's just not required so this patch could
potentially get merged easier, since the test may not be an oneliner
change.

> 
> > 
> > (Not to mention the original test actually verified that we don't  break, which
> > seems good..)
> > 
> > >  	vm_enable_cap(vm, &cap);
> > >  #endif
> > >
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c index
> > > 70f03ce..f2631d0 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -862,7 +862,7 @@ static int kvm_vm_release(struct inode *inode,
> > struct file *filp)
> > >   * Allocation size is twice as large as the actual dirty bitmap size.
> > >   * See x86's kvm_vm_ioctl_get_dirty_log() why this is needed.
> > >   */
> > > -static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
> > > +static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
> > 
> > This change seems irrelevant..
> > 
> > >  {
> > >  	unsigned long dirty_bytes = 2 * kvm_dirty_bitmap_bytes(memslot);
> > >
> > > @@ -1094,8 +1094,11 @@ int __kvm_set_memory_region(struct kvm *kvm,
> > >
> > >  	/* Allocate page dirty bitmap if needed */
> > >  	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
> > > -		if (kvm_create_dirty_bitmap(&new) < 0)
> > > +		if (kvm_alloc_dirty_bitmap(&new))
> > 
> > Same here.
> 
> s/kvm_create_dirty_bitmap/kvm_alloc_dirty_bitmap is Sean's suggestion to make
> it clear that the helper is only responsible for allocation, then set all the bitmap bits
> to 1 using bitmap_set afterwards, which seems reasonable. Do you still think it's
> better to keep this name untouched?

No strong opinion, feel free to take your preference (because we've
got three here and if you like it too then it's already 2:1 :).

> 
> > 
> > >  			goto out_free;
> > > +
> > > +		if (kvm->manual_dirty_log_protect &
> > KVM_DIRTY_LOG_INITIALLY_SET)
> > 
> > (Maybe time to introduce a helper to shorten this check. :)
> 
> Yeah, but could this be done on top of this patch?

You're going to repost after all, right?  If so, IMO it's easier to
just add the helper in the same patch.

Thanks,

-- 
Peter Xu


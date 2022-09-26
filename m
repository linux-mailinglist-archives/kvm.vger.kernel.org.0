Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE6D5EB5D0
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 01:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiIZXej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 19:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiIZXeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 19:34:37 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9BF627F
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 16:34:35 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id e145so8523063yba.11
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 16:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=l7SnbtLPEM732+/qIFc6jUHik8WmAvcTMIc2OL0ANLM=;
        b=R/HBbSp8ZJdNsQ2bHMipIXtlmDXh/g7gTfzr+ZE4jgKVfrItATo6fTj+K5nI3jN0wv
         dRBcjiDu2s96Qg1T1y79+dy1rfiuJMVZObK+Z4WhFDkuI6ZWno0ffVC46TyRsXZXvZNG
         mbTXe1HZ0ZEF5uzn+d/Ud4tXACBJWQaRAkIWtQLgVMnS4vOukcOWC8KitL+uwEfuOvQF
         5sy53EMF5HrhTVqQxim+ZeylqICZANm7/4rWDzOc0p2xoPpW0QzHZcSUUEVod955cQXt
         xD7EIppmTgkUhAXCzs2L77dEEJ8h03X/WutMB5pMOKLXy/teP2ojpDqHawvanI7Y5Gkh
         DoPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=l7SnbtLPEM732+/qIFc6jUHik8WmAvcTMIc2OL0ANLM=;
        b=O6uFni4ZnSuxqOQrtpEmeBkKeCRVVUAmWP4MC5aETEOEJZFisEDLO+jpk4FG/pVuHD
         s/LKiqoiEBsrGZWlQfsl8hp6fKHf40u0oYnagV1LWL6gMk8vaKYIWcPIV0dJSO/1zfwQ
         fhMAiyCjtZcMQr/RwQ3DIOPi0R3bI1TFec0lNsYGFytk59OI0Nl/Sp7JuzvB7hRk9KpW
         wrwRx6Owb1xyWdvvMAjxsRyOTc2/uC7NM0mrZ8g41PnwA5jlzdGJADS1NfKnjbgVO3ot
         7W74EivWHulvr7+BfDlAzxdCVoCeu5HYtK5AdbuuYLVz9AeG3iAp5Sth4P0ICPOGdXW8
         PA1A==
X-Gm-Message-State: ACrzQf0kIrn+nRF2IFQZAwUgIKGGQ8uW8UWn59niTyNRGuYVsApk7xO4
        YzARi2WNvQyTy+TZprcIMDAoMRBEetX7uQ8oYxVehg==
X-Google-Smtp-Source: AMsMyM7Z9uPtPHRyKMi7tSAsgduZnZLsWG66mPrbstXnDaqJKv9A0z+k2PuYb6LVgVs4uFiCEcZwbNyRnUV/CWxX0qA=
X-Received: by 2002:a25:4fc2:0:b0:680:f309:48e5 with SMTP id
 d185-20020a254fc2000000b00680f30948e5mr24198828ybb.0.1664235274918; Mon, 26
 Sep 2022 16:34:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220915000448.1674802-1-vannapurve@google.com>
 <20220915000448.1674802-5-vannapurve@google.com> <Yyt/xgPkHfbOE3vH@google.com>
 <CAGtprH-4nRyA81wock_OVwL-xA+LgNfqZFhJeE7T4iUyEscJKg@mail.gmail.com>
In-Reply-To: <CAGtprH-4nRyA81wock_OVwL-xA+LgNfqZFhJeE7T4iUyEscJKg@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 26 Sep 2022 16:34:08 -0700
Message-ID: <CALzav=fGpN0C1duR8ArnAUyko5bqytNS_V47eBa9JM89pehyAw@mail.gmail.com>
Subject: Re: [V2 PATCH 4/8] KVM: selftests: x86: Precompute the result for is_{intel,amd}_cpu()
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     x86 <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, shuah <shuah@kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Sep 26, 2022 at 4:27 PM Vishal Annapurve <vannapurve@google.com> wrote:
>
> On Wed, Sep 21, 2022 at 2:19 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Thu, Sep 15, 2022 at 12:04:44AM +0000, Vishal Annapurve wrote:
> > > Cache the vendor CPU type in a global variable so that multiple calls
> > > to is_intel_cpu() do not need to re-execute CPUID.
> > >
> > > Add cpu vendor check in kvm_hypercall() so that it executes correct
> > > vmcall/vmmcall instruction when running on Intel/AMD hosts. This avoids
> > > exit to KVM which anyway tries to patch the instruction according to
> > > the cpu type.
> >
> > The commit shortlog makes no mention (nor even implies) that this commit
> > adds AMD support to kvm_hypercall(). Please break this commit up into 2.
> > One to precompute the result of is_{intel,amd}_cpu() and one to add AMD
> > support to kvm_hypercall().
> >
> > If you really want to keep this as one commit (I don't know what the
> > benefit would be), please change the shortlog and commit message to
> > focus on the kvm_hypercall() change, as that is the real goal of this
> > commit. The precomputation is arguably and implementation detail. e.g.
> >
>
> is_amd_cpu is used by guest code within fix_hypercall_test.c, just
> caching the result will break the guest code execution. I have clubbed
> these two changes together in order to ensure that is_amd_cpu works
> fine for both host userspace and guest vm logic.

Ah, so the sync_global_to_guest() part needs to go in the patch that
adds caching to is_amd_cpu().

But the point still stands that adding AMD support to kvm_hypercall()
is a logically independent change.

>
> >   KVM: selftest: Add support for AMD to kvm_hypercall()
> >
> >   Make it possible to use kvm_hypercall() on AMD by checking if running
> >   on an AMD CPU and, if so, using vmmcall instead of vmcall. In order to
> >   avoid executing CPUID in the guest on every call t kvm_hypercall()
> >   (which would be slow), pre-compute the result of is_{intel,amd}_cpu()
> >   as part of kvm_selftest_arch_init() and sync it into the guest
> >   after loading the ELF image.
> >
> > But again, it'd be cleaner just to split it up. Caching the result of
> > is_{intel,amd}_cpu() is useful in its own right, independent of the
> > kvm_hypercall() change.
> >
> > >
> > > ...
> > >
> > > @@ -1314,8 +1321,10 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
> > >
> > >  void kvm_selftest_arch_init(void)
> > >  {
> > > +     is_cpu_amd = cpu_vendor_string_is("AuthenticAMD");
> > >  }
> > >
> > >  void kvm_arch_post_vm_elf_load(struct kvm_vm *vm)
> > >  {
> > > +     sync_global_to_guest(vm, is_cpu_amd);
> > >  }
> > > --
> > > 2.37.2.789.g6183377224-goog
> > >

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A4D6B3384
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 02:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjCJBKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 20:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCJBJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 20:09:56 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3781D7FD6B
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 17:09:51 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-536cb25982eso68399347b3.13
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 17:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678410590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6Z/ryk2HB9ybkzva9NmuuaKEjsMinWP4YEUWXTsROY=;
        b=e/lNExAyMpC9c4xXlt8T9iR+S4iF9XdtE6imlrAyh7sZhXw/a7Z/dkyYCHAaKc04nX
         0HcweOSUtwx8rvKK5rvpmf61ub+N5fI9x4NKRA/bL8nXVGtTHk7EPh/5Gwklrim7+Ow2
         k2Jtjog5AEYIcMPgFu++XZr9iEXmTfYJ7aZBTFHO0aoQ455i3Jeq9tX3ZeiHV00BC9Vu
         1dbO3p0VSgMhmh1QboDerDoQ7Hnzw8j7k6UjTigoLzQo3rn5/KD7djWY7555ojJiIET9
         DJ7CrlVtuWSUaFeN89lfwHgKUvZe582jcY5OtHb+afgODuF0UWiqezvZDpHQoIOmgEZa
         h6Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678410590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F6Z/ryk2HB9ybkzva9NmuuaKEjsMinWP4YEUWXTsROY=;
        b=gPTTHaZ3G53gD8o+52IepDXN27zNkFXlNsYYheNIGiDiI3pRllWUCmrpCLBvhCuV/4
         tDq6KJFu3CHqqsGvyO6t9JDOM7rd7gx01FSrIX1zgUvWZoU6JU+CdNK97X0AO5YH8RUr
         PQP03pjXPegdu0Q3qezPIb83PWX6JNb9vMVdPi8GzpuEn4eiviFw/gTXNnczC0xPoJSD
         L8j8cr+p0kID/4DBE+06qBj3j57DUhXYMvUn7dhvIb0FU/f3f4LYCaEOFHh1k0k3twMf
         FUn0EZplnjodhFuQ5Iuj4sOnP/0l713Z41chdHUmrb03q+XKJqaX/fGPLFXdKqQwxc6c
         D4EQ==
X-Gm-Message-State: AO0yUKV+HlxotLjPxvM7NUJrvr2YBzTfRUOyy8mC56Hzmt2/GMCkQj67
        7JbtaE+yUXzz+BKS7qgnJ1/YFMSHk5eLf90rlxWr/w==
X-Google-Smtp-Source: AK7set8M99J9D09u9PVi4aPjNx25n5Ke6vClbypiGVlKs7nHyDSy7kgFmMmJaPfo3op4OyQe/3b7zj/WprUaCqUaJbQ=
X-Received: by 2002:a81:ad44:0:b0:52a:92e9:27c1 with SMTP id
 l4-20020a81ad44000000b0052a92e927c1mr15319486ywk.10.1678410590074; Thu, 09
 Mar 2023 17:09:50 -0800 (PST)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-4-vipinsh@google.com>
 <ZApxh/GYfqev7sHA@google.com> <CAHVum0eQzmLXDxMy3+LpmGxVU7YsT1wRNYkFq9o7sfR2uNK-xA@mail.gmail.com>
 <ZAqAHiaCz0b2OKJF@google.com>
In-Reply-To: <ZAqAHiaCz0b2OKJF@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 9 Mar 2023 17:09:14 -0800
Message-ID: <CAHVum0dKBQxuCQG0HhpBpN8TqsUCyBaRkLJyAS7g-kLrs4-q5Q@mail.gmail.com>
Subject: Re: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU
 page caches globally
To:     David Matlack <dmatlack@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 9, 2023 at 4:56=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On Thu, Mar 09, 2023 at 04:28:10PM -0800, Vipin Sharma wrote:
> > On Thu, Mar 9, 2023 at 3:53=E2=80=AFPM David Matlack <dmatlack@google.c=
om> wrote:
> > >
> > > On Mon, Mar 06, 2023 at 02:41:12PM -0800, Vipin Sharma wrote:
> > > > Create a global counter for total number of pages available
> > > > in MMU page caches across all VMs. Add mmu_shadow_page_cache
> > > > pages to this counter.
> > >
> > > I think I prefer counting the objects on-demand in mmu_shrink_count()=
,
> > > instead of keeping track of the count. Keeping track of the count add=
s
> > > complexity to the topup/alloc paths for the sole benefit of the
> > > shrinker. I'd rather contain that complexity to the shrinker code unl=
ess
> > > there is a compelling reason to optimize mmu_shrink_count().
> > >
> > > IIRC we discussed this at one point. Was there a reason to take this
> > > approach that I'm just forgetting?
> >
> > To count on demand, we first need to lock on kvm_lock and then for
> > each VMs iterate through each vCPU, take a lock, and sum the objects
> > count in caches. When the NUMA support will be introduced in this
> > series then it means we have to iterate even more caches. We
> > can't/shouldn't use mutex_trylock() as it will not give the correct
> > picture and when shrink_scan is called count can be totally different.
>
> Yeah good point. Hm, do we need to take the cache mutex to calculate the
> count though? mmu_shrink_count() is inherently racy (something could get
> freed or allocated in between count() and scan()). I don't think holding
> the mutex buys us anything over just reading the count without the
> mutex.
>

You are right, mutex and percpu_counter both are not not solving
accuracy problems with the shrinker. So, this can be removed.

> e.g.
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index df8dcb7e5de7..c80a5c52f0ea 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6739,10 +6739,20 @@ static unsigned long mmu_shrink_scan(struct shrin=
ker *shrink,
>  static unsigned long mmu_shrink_count(struct shrinker *shrink,
>                                       struct shrink_control *sc)
>  {
> -       s64 count =3D percpu_counter_sum(&kvm_total_unused_cached_pages);
> +       struct kvm *kvm, *next_kvm;
> +       unsigned long count =3D 0;
>
> -       WARN_ON(count < 0);
> -       return count <=3D 0 ? SHRINK_EMPTY : count;
> +       mutex_lock(&kvm_lock);
> +       list_for_each_entry_safe(kvm, next_kvm, &vm_list, vm_list) {
> +               struct kvm_vcpu *vcpu;
> +               unsigned long i;
> +
> +               kvm_for_each_vcpu(i, vcpu, kvm)
> +                       count +=3D READ_ONCE(vcpu->arch.mmu_shadow_page_c=
ache.nobjs);
> +       }
> +       mutex_unlock(&kvm_lock);
> +
> +       return count =3D=3D 0 ? SHRINK_EMPTY : count;
>
>  }
>
> Then the only concern is an additional acquire of kvm_lock. But it
> should be fairly quick (quicker than mmu_shrink_scan()). If we can
> tolerate the kvm_lock overhead of mmu_shrink_scan(), then we should be
> able to tolerate some here.
>
> >
> > scan_count() API comment says to not do any deadlock check (I don't
> > know what does that mean) and percpu_counter is very fast when we are
> > adding/subtracting pages so the effect of using it to keep global
> > count is very minimal. Since, there is not much impact to using
> > percpu_count compared to previous one, we ended our discussion with
> > keeping this per cpu counter.
>
> Yeah it's just the code complexity of maintaing
> kvm_total_unused_cached_pages that I'm hoping to avoid. We have to
> create the counter, destroy it, and keep it up to date. Some
> kvm_mmu_memory_caches have to update the counter, and others don't. It's
> just adds a lot of bookkeeping code that I'm not convinced is worth the
> it.

Yeah, it will simplify code a lot. Also, we also don't need 100%
accuracy with Shrinker. I will remove this global counter in the next
version.

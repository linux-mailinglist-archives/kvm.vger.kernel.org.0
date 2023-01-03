Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC9365C539
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 18:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238167AbjACRkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 12:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238354AbjACRjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 12:39:37 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CCEFD24
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 09:39:34 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-4a263c4ddbaso108364587b3.0
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 09:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qKTgLEVHfpoE4LRyGeW2aBvpWAAPdaN/ODQpVhyWmJg=;
        b=r4Ry87zih11LdqU6ILa2uPmN/JJ4XIyd0xMj+t4dTCEJq5U99ZDfGSAB6+zG/H9nX/
         JiQtDJOp1I1GXDc70gHhc3X8HbdQBC6pgxKn4BrCc2GW6nerocXkGCv1ZkvPipdzxmEZ
         0dGMIaKkib8cyARCkkEdMHPrtiTQz885H7t7wMz0mhjiIgVs/cRgfNcB2B0/XkMdlMJu
         NpHqMwwyCA6FQQ856ggx7YpZyDlDJJ/y3mxh/YMaciEpGcQoTk9DL8R12J52xkvlKvHV
         0WHTGdcbocafgKq0W+qhIvMJzpVyV41Cl79W/TNJuy1+lYRa4EYTGgVPddot0ItUeSt4
         Nx5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qKTgLEVHfpoE4LRyGeW2aBvpWAAPdaN/ODQpVhyWmJg=;
        b=OdrC8YMHX11JPy1AU5Jj5ySiF/vEejVy+EvMUnlghBpN3Ta3BXsACwQ78AApQ31ji0
         HDDdd7O9jfLrtQikP277XaUD9vvxjf78XaQcrjJOGTGbz0Z0wz4Mi7lJMelVAEBmQV7S
         EMK4axC00rfXlBOUOUeaQ/mr8qgHNdeEofnUwiguuHZfeCHvTVXoK293dsh9/bY075GU
         YW8OSLFmU6eg7AOWz85FZ/HY+Ah1X3n2WOz5E5NIn7En49eWbYbPsjJewYtOsC2Fjkzu
         8Oe6zCR6DQ0v0BNDhrXEnEUARCLo/LrcUJg8sCIxEtaDQ7Zh8WA9TV0wkK7wSqVDcdgR
         9G7A==
X-Gm-Message-State: AFqh2koax33EzQT3JM4aGMXbxF3AEufIULoyeR30h2g+ERCpDb6h/Nmu
        QqdCp3nJUAhEf4FnDt6JheJSPRL616GcTi9lXakMwA==
X-Google-Smtp-Source: AMrXdXu/Gtq80JKxA7VpKizOf0cM3DCjP2+vKObMadEMlMqdD+hI0/XP28eOJ+//fCpQL48X3i5DnmJt7y9U2haCIF4=
X-Received: by 2002:a0d:cc87:0:b0:475:3ae:cf with SMTP id o129-20020a0dcc87000000b0047503ae00cfmr4888663ywd.354.1672767573896;
 Tue, 03 Jan 2023 09:39:33 -0800 (PST)
MIME-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com> <20221222023457.1764-2-vipinsh@google.com>
 <CANgfPd9fr0KfRRg9LMD=3DTLJ9CKGLe0HaY512BeK16sgFX4kQ@mail.gmail.com>
 <CAHVum0efHuRmER-whXnwHYMsBLBcb-mgDu+uogCJbMhz2e0_MA@mail.gmail.com> <Y64DgHuPd8oTPSm5@google.com>
In-Reply-To: <Y64DgHuPd8oTPSm5@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 3 Jan 2023 09:38:58 -0800
Message-ID: <CAHVum0e5MurqNnTJ1uG9RqiqQscJOCBa+OmMFTbJGVjmjDS68g@mail.gmail.com>
Subject: Re: [Patch v3 1/9] KVM: x86/mmu: Repurpose KVM MMU shrinker to purge
 shadow page caches
To:     David Matlack <dmatlack@google.com>
Cc:     Ben Gardon <bgardon@google.com>, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Dec 29, 2022 at 1:15 PM David Matlack <dmatlack@google.com> wrote:
>
> On Wed, Dec 28, 2022 at 02:07:49PM -0800, Vipin Sharma wrote:
> > On Tue, Dec 27, 2022 at 10:37 AM Ben Gardon <bgardon@google.com> wrote:
> > > On Wed, Dec 21, 2022 at 6:35 PM Vipin Sharma <vipinsh@google.com> wrote:
> > > >
> > > > Tested this change by running dirty_log_perf_test while dropping cache
> > > > via "echo 2 > /proc/sys/vm/drop_caches" at 1 second interval
> > > > continuously. There were WARN_ON(!mc->nobjs) messages printed in kernel
> > > > logs from kvm_mmu_memory_cache_alloc(), which is expected.
> > >
> > > Oh, that's not a good thing. I don't think we want to be hitting those
> > > warnings. For one, kernel warnings should not be expected behavior,
> > > probably for many reasons, but at least because Syzbot will find it.
> > > In this particular case, we don't want to hit that because in that
> > > case we'll try to do a GFP_ATOMIC, which can fail, and if it fails,
> > > we'll BUG:
> > >
> > > void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> > > {
> > >         void *p;
> > >
> > >         if (WARN_ON(!mc->nobjs))
> > >                 p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
> > >         else
> > >                 p = mc->objects[--mc->nobjs];
> > >         BUG_ON(!p);
> > >         return p;
> > > }
> > >
> > > Perhaps the risk of actually panicking is small, but it probably
> > > indicates that we need better error handling around failed allocations
> > > from the cache.
> > > Or, the slightly less elegant approach might be to just hold the cache
> > > lock around the cache topup and use of pages from the cache, but
> > > adding better error handling would probably be cleaner.
> >
> > I was counting on the fact that shrinker will ideally run only in
> > extreme cases, i.e. host is running on low memory. So, this WARN_ON
> > will only be rarely used. I was not aware of Syzbot, it seems like it
> > will be a concern if it does this kind of testing.
>
> In an extreme low-memory situation, forcing vCPUS to do GFP_ATOMIC
> allocations to handle page faults is risky. Plus it's a waste of time to
> free that memory since it's just going to get immediately reallocated.
>
> >
> > I thought about keeping a mutex, taking it during topup and releasing
> > it after the whole operation is done but I stopped it as the duration
> > of holding mutex will be long and might block the memory shrinker
> > longer. I am not sure though, if this is a valid concern.
>
> Use mutex_trylock() to skip any vCPUs that are currently handling page
> faults.

oh yeah! Thanks.

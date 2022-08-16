Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097D55963EE
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 22:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbiHPUrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 16:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbiHPUrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 16:47:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD9089809
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 13:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660682860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3JoZZmMRTLKhHqlvu8uJZ3OdJLMTuykuadzU2PRUVyo=;
        b=HfULhG6FF0CDCsfYL0BbhyoZM2GPxb6aovAEAMbfFiyRwIX9tCC60XYpfnzpBAsbLAqj5R
        leHFy0T0fyBNNHGcEjAohXqEdlSpTyH5P7A6YOgbSpX9FFVhJzZ8Ld0P5VglkfXf6XpdRX
        qGm2wWpm8Ahi1CNaJl5hDz5C5kMbDZc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-287-ViUfXMeqPRGtuWHQEV-Adw-1; Tue, 16 Aug 2022 16:47:39 -0400
X-MC-Unique: ViUfXMeqPRGtuWHQEV-Adw-1
Received: by mail-qv1-f71.google.com with SMTP id o6-20020ad443c6000000b00495d04028a6so1088439qvs.18
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 13:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=3JoZZmMRTLKhHqlvu8uJZ3OdJLMTuykuadzU2PRUVyo=;
        b=O56fUXJwzTQFf4UElUD687Z3S80kOLJZx+Jf96E/66Ag/jeknaCVwG76+dNgU1XbH1
         vv3ajW3rFwkcbgXfGQ9aPIP9pm1WSSh+v8TMyofaeUuFEgiLyRvddm5rZlECUM843iEy
         P/6LMlsEwHizdMl0lI+z/Lq8Pkm7C7NAtDDtlBOncLlkaSbk1lzJaiAE4TRdblhDcwOG
         pHovNTRquFuM/seiGGvMm6NpIygs+2p7UooV9LL/QmjOzJ4K2fEuoKRWYaIkRkYwpOsg
         GQu2SiNj5lYS2edrEH8PdPA3t8H2MQM2s0th4cyz2b9VCmrYqHSa5cCFAb2k0SLnzRFZ
         78lw==
X-Gm-Message-State: ACgBeo3rH4OdNd5TX30vFrrhwWqscxPGMQMJmSgprWfukYtQDHjHSp99
        cCqYria2/EWfOFg777dD9JhTtFIGO8YWjaR/zNrp6JTdbavXrDXwzHh79s5AJDlMu7FBDzEgD84
        CbT77GrgBBp4l
X-Received: by 2002:ac8:4e45:0:b0:343:5faf:3af6 with SMTP id e5-20020ac84e45000000b003435faf3af6mr20160980qtw.340.1660682857448;
        Tue, 16 Aug 2022 13:47:37 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6IwiJJXWm5YftOp/luO9AW0MDhFAjgzItfksuHh5hDaCvWVcPNx39suKAdXZ2GyDmA+23zUg==
X-Received: by 2002:ac8:4e45:0:b0:343:5faf:3af6 with SMTP id e5-20020ac84e45000000b003435faf3af6mr20160915qtw.340.1660682855766;
        Tue, 16 Aug 2022 13:47:35 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id h5-20020a05620a400500b006b615cd8c13sm12717718qko.106.2022.08.16.13.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 13:47:35 -0700 (PDT)
Date:   Tue, 16 Aug 2022 16:47:34 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 3/3] kvm/x86: Allow to respond to generic signals
 during slow page faults
Message-ID: <YvwCZsHxZV9kPn6I@xz-m1.local>
References: <20220721000318.93522-1-peterx@redhat.com>
 <20220721000318.93522-4-peterx@redhat.com>
 <YvVitqmmj7Y0eggY@google.com>
 <YvVtX+rosTLxFPe3@xz-m1.local>
 <Yvq6DSu4wmPfXO5/@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yvq6DSu4wmPfXO5/@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 15, 2022 at 09:26:37PM +0000, Sean Christopherson wrote:
> On Thu, Aug 11, 2022, Peter Xu wrote:
> > On Thu, Aug 11, 2022 at 08:12:38PM +0000, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 17252f39bd7c..aeafe0e9cfbf 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -3012,6 +3012,13 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> > > >  static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> > > >  			       unsigned int access)
> > > >  {
> > > > +	/* NOTE: not all error pfn is fatal; handle sigpending pfn first */
> > > > +	if (unlikely(is_sigpending_pfn(fault->pfn))) {
> > > 
> > > Move this into kvm_handle_bad_page(), then there's no need for a comment to call
> > > out that this needs to come before the is_error_pfn() check.  This _is_ a "bad"
> > > PFN, it just so happens that userspace might be able to resolve the "bad" PFN.
> > 
> > It's a pity it needs to be in "bad pfn" category since that's the only
> > thing we can easily use, but true it is now.
> 
> Would renaming that to kvm_handle_error_pfn() help?  I agree that "bad" is poor
> terminology now that it handles a variety of errors, hence the quotes.

It could be slightly helpful I think, at least it starts to match with how
we name KVM_PFN_ERR_*.  Will squash the renaming into the same patch.

Thanks,

-- 
Peter Xu


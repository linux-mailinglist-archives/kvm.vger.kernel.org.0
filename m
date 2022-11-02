Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7AC7616DF5
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 20:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiKBTr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 15:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiKBTr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 15:47:26 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC84F5B7
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 12:47:24 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id g24so17583514plq.3
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 12:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XZUg37uJOYfpvjSeVnjDTPG9wFYr/ltSGt4/E37UDaE=;
        b=T6n+ZNy6EJsuUFK142/EHb28MY0RHQS0F3csirBX1F4szkFH3Oa1GmcjrbMzMqlehR
         PvjsJwJm7zQIiFKAQ+k5bRqj3r5MNjpdC5QRkWxNtnvQEVAEPB0xpqh4V/qBgfoZFH/0
         X3Dr4HnK3V1IBtSh/4vfOTaOu0DmXUFWj6fWoc4wVthF+lGODGd5TBZPkeQhh2JpHeyp
         ZJoFYF8I+pq6CfhphcrQl+pAJSgexA1ATjhi8/HGr0ViJe2DXVkDmdTX0/O3PAlo5tHC
         1qsWaUE1rHB77yvUEvxqLKB8XZrzBsq5tHtS1s84o8MbSlwJZiAU4a0qutIvlFqV3sub
         sUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZUg37uJOYfpvjSeVnjDTPG9wFYr/ltSGt4/E37UDaE=;
        b=7wZqM/mkTsbirj3+9M6BSrOf7xXMwcxUhfU8BvDaTImLLuVQjP+F7tyUDC21aoU/5w
         GCk2gGicd2FLNsmQdI4YlfsTi5BkusgY5y7+gLozwn+K//DS5OTVhnhIWMOtN+T+9ESy
         zSWCgdfKyGw2nipFk/aE84gefbHt2WzswLVjhrq67RoLQbKwOZomifwZW9vZ3KydLYIX
         8dKQA25r9TlKoRbn4YjuGdnrp0cGCDR78XdSuAhikSBRBSZJZ1bcmPprXjtgv6Rh2JwJ
         Ha6QaskrhaemFzWtWvFPyYPOJAEXiPo3hmYRzN954YKxm4Z0rYoh2z1NCCHJ0TstpHqW
         3jLg==
X-Gm-Message-State: ACrzQf3PL604kTyi3490Y1lKMgbUyn2AlePkRCDscNgdNxqYEwc8rVX1
        E2kgCWtOYlU24EhU4XotactqiUksKiR9SQ==
X-Google-Smtp-Source: AMsMyM7oyCdBbkPZUPhhDvi7k1UptHvFb1HUn9nf2o5jtHc+LvzTsYv4dx5WGGQHkKa1hX1esfULbw==
X-Received: by 2002:a17:902:f686:b0:187:16a0:fd2b with SMTP id l6-20020a170902f68600b0018716a0fd2bmr20793406plg.91.1667418444372;
        Wed, 02 Nov 2022 12:47:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h18-20020a63df52000000b00434272fe870sm7937729pgj.88.2022.11.02.12.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:47:24 -0700 (PDT)
Date:   Wed, 2 Nov 2022 19:47:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Anish Ghulati <aghulati@google.com>
Subject: Re: [PATCH] KVM: x86: Use SRCU to protect zap in
 __kvm_set_or_clear_apicv_inhibit
Message-ID: <Y2LJSE5nuHZJV7fF@google.com>
References: <20221102193020.1091939-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102193020.1091939-1-bgardon@google.com>
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

On Wed, Nov 02, 2022, Ben Gardon wrote:
> kvm_zap_gfn_range must be called in an SRCU read-critical section, but

Please add parantheses when referencing functions, i.e. kvm_zap_gfn_range().

> there is no SRCU annotation in __kvm_set_or_clear_apicv_inhibit.

__kvm_set_or_clear_apicv_inhibit()

> Add the needed SRCU annotation.

It's not an annotation, acquiring SRCU is very much functional code.

> Tested: ran tools/testing/selftests/kvm/x86_64/debug_regs on a DBG
> 	build. This patch causes the suspicious RCU warning to disappear.
> 	Note that the warning is hit in __kvm_zap_rmaps, so
> 	kvm_memslots_have_rmaps must return true in order for this to
> 	repro (i.e. the TDP MMU must be off or nesting in use.)

Please provide the stack trace or at least a verbal description of what paths
can reach __kvm_set_or_clear_apicv_inhibit() without holding SRCU, i.e. explain
why this bug isn't being hit left and right.

E.g.

  Unconditionally take KVM's SRCU lock in __kvm_set_or_clear_apicv_inhibit()
  when zapping virtual APIC SPTEs.  SRCU must be held when zapping SPTEs in
  shadow MMUs to protect the gfn=>memslot translation (the TDP MMU walks all
  roots and so doesn't dereference memslots).

  In most cases, the inhibits are updated during KVM_RUN and so SRCU is
  already held, but other ioctls() can also modify inhibits and don't
  acquire SRCU, e.g. KVM_SET_GUEST_DEBUG and KVM_SET_LAPIC.  Acquire SRCU
  unconditionally to avoid playing whack-a-mole, as nesting SRCU locks is
  safe and this is not a hot path.

> Fixes: 36222b117e36 ("KVM: x86: don't disable APICv memslot when inhibited")

Reported-by?  IIRC this originated in a syzkaller report?

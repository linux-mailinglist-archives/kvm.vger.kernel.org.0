Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFA86AE6B1
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 17:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCGQf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 11:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjCGQef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 11:34:35 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB8E392A2
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 08:33:08 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id i6-20020a170902c94600b0019d16e4ac0bso7896201pla.5
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 08:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678206772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cAnPTKFPaZZYbMqYNII6LME42nYkJ5JY0hW7y0YDxo0=;
        b=YNj3WP/xnWkrqPeVn2wy7dFzf5QgS1Khs46WBIdFRrUDayakJ8EkvixqL1rgvHQ66S
         0WwS9nQHhqrjKFID3Pf4qvqEZykGEAOOAZLDbJgY80csvDFJr+7qsMK+Jlbey9swPQp0
         Vn/W263LRvE4cqaxVPjSu8LcCuJjVbo3XrkooSGzhsLcL1+aqBXzaGdsaeQWltwQ2HNp
         O+1oBFQEhvDJ2dOaQsEgZFGI9w2V2Sq+w46tmAkgW8g6IH6CSxW2LwhxRY28C6YpXvik
         p/jyW7fqQvE/jN06u/x1zwcDZdw5Nr6Bpy4+r5v0szcuKSX0lvPDWugxQbehZ7EP5dsY
         S7VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678206772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cAnPTKFPaZZYbMqYNII6LME42nYkJ5JY0hW7y0YDxo0=;
        b=GxkPr3UIvY1pjEg7hm3/tESyIvJIP/kdmZZsJlbyS74HocBzjQQEl9YKywhrQX3OIV
         6OVoW/hQgIS2jcbBT8APuh3eStaiPxEwcxtEox9dslilPaDrbD+S0m1CwcxQBEGTxNrf
         sw+Oww96bTryp532IcDB0VfhMgfDaLKSmrGiH15t7N0WoGttX8COwX+uFWTOvaAvA0RC
         IayCAEHprOfInxo4vb+/0wqOu0NKo2+937qG0XypCm0GybA8WbJgohfY4pQ9JnjQaG0B
         SrHYrhTOOskgPK/G6mVJDbittLFn7BJTcsXRP3omYTitM4b0XufqZ7jwcLpQOSmacya7
         bq7Q==
X-Gm-Message-State: AO0yUKUPhSXr3MV2Vc83V4gusuN8XhesSSnWab9WJj/oL48vrFbQ3Mw/
        eJI5bHnrGyeQoqvwAIEWxLkUyB/r18k=
X-Google-Smtp-Source: AK7set/8v1ZNAjS83kEp7/gE5+UwxP45nURQeh1otLfp7DadjsPCEHMwMobVdy5avOeQ63lA6fX63aSw4Ac=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6846:b0:19c:9999:e922 with SMTP id
 f6-20020a170902684600b0019c9999e922mr5839338pln.5.1678206772333; Tue, 07 Mar
 2023 08:32:52 -0800 (PST)
Date:   Tue, 7 Mar 2023 16:32:50 +0000
In-Reply-To: <20230227065437.j7f7rfadut532fud@linux.intel.com>
Mime-Version: 1.0
References: <20230217231022.816138-1-seanjc@google.com> <20230217231022.816138-9-seanjc@google.com>
 <20230221152349.ulcjtbnvziair7ff@linux.intel.com> <20230221153306.qubx7tfmasnvodeu@linux.intel.com>
 <Y/VYN3n/lHePiDxM@google.com> <20230222064931.ppz6berhfr4edewf@linux.intel.com>
 <Y/ZFJfspU6L2RmQS@google.com> <20230224092552.6olrcx2ryo4sexxm@linux.intel.com>
 <Y/ji6MAlEmbNfZzf@google.com> <20230227065437.j7f7rfadut532fud@linux.intel.com>
Message-ID: <ZAdmecm4Pp7pT3jM@google.com>
Subject: Re: [PATCH 08/12] KVM: nSVM: Use KVM-governed feature framework to
 track "vVM{SAVE,LOAD} enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023, Yu Zhang wrote:
> On Fri, Feb 24, 2023 at 08:16:40AM -0800, Sean Christopherson wrote:
> > On Fri, Feb 24, 2023, Yu Zhang wrote:
> > > But why it is related to nested migration? 
> > 
> > I understand why it's related, but I don't understand why we bothered to add "support"
> > for this.
> > 
> > In theory, if L1 is migrated by L0 while L1 is running an L2 that uses SYSENTER,
> > problems will occur.  I'm a bit lost as to how this matters in practice, as KVM
> > doesn't support cross-vendor nested virtualization, and if L1 can be enlightened
> > to the point where it can switch from VMX=>SVM during migration, what's the point
> > of doing a migration?
> 
> Oh. So that is what people call "nested migration". I had thought "nested
> migration" is to migrate L2. Instead, it is still a migration of L1 with
> VMX/SVM capability... :(

More or less, yes.  I personally would prefer a less ambiguous description, e.g.
"migration with nested VMs", but unfortunately I can't mind control others :-)
 
> Is it a possible scenario that:
> 1> A L1 VM is created on Intel platform, with VMX capability virtualized
> to it.
> 2> The SYSENTER_EIP/ESP is set to a 64-bit value in L1.
> 3> Before creating a L2 VM, this L1 VM is migrated to a AMD machine.
> 4> The migrated L1 VM is exposed with SVM capability.
> 5> And then when L1 tries to create L2, the virtual vmload/vmsave shall
> be disabled.
> 
> But is step 4> a valid operation in KVM?   

It's valid in KVM (as L0), but I don't see how L1 can handle it cleanly without
an absurd level of enlightenment.  And if L1 is highly enlightened, I don't see
why it's desirable to do cross-vendor migration of the VM.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C7559A54C
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350808AbiHSSa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 14:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350800AbiHSSaZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 14:30:25 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27831BB69E
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 11:30:24 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pm17so5387827pjb.3
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 11:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=qAUR7Xfx1bdRlrncGd1cRbyx7ZwF1wAgDN52OFRP/pU=;
        b=P3tIJszFK+1qv0er4ZOdUim5/T/IS03kr/WJs+z0OYZcdokyKRKsnH54dgLO19V7yr
         IPWprnTve2r2W9AdPvMQzb1dskxWRDu5yfsMTFt8JMw3CYHOAaMnu0jEv1fK9XsaKeLm
         SVrQTUYVnmoPY5tQg+YAggxFq2Y6OIpYdsFuV7WlvQ6LSxq+7+gMj7f+FfFijHWjvP9t
         fwH4QuFcmMNCdDcHYfsgs5D7UYa93dfrmhekFARBuYRyGFYUL6yTpbMcvDb+Uu25BiUy
         8uhTv/TsekUDvDtdL/pK4e4mh6wh3Lb7UphSrPfluHUNczET+3LAJHxhXHTi41r34N+R
         BeUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=qAUR7Xfx1bdRlrncGd1cRbyx7ZwF1wAgDN52OFRP/pU=;
        b=BWzyhh+bHCGbDGUFTGl8lkEuXpu8O+FguyiLONlKTWe/qXdQnnN/JHHSsF6b4zZ2AB
         k7xMp7KWnNNB47y5n7PkHITEJguxSxLhYghz5g0d6QRzj+VccDc6K0mvdPZH/WQqC/QV
         NjOT5N3lwpAmsHaV72SiYXJtRVCmHRIns505ZjCaIAi9i0SDjBZdNBJd9mdUAGrrRmVH
         zDprYgmm94cqPYSpwtrzMarhtnDKuXfuNFdo2iEnJP0VoOQ6VT+uxgT3q46LmfuCjYP1
         dNOzIePSYwm+/EVLEwdVZIRZllOtRAjXwgigorqPDVIE4v8PEqC/YJPPtfQVwkSFFSuI
         giTQ==
X-Gm-Message-State: ACgBeo1VZGdIrJIHc9XIAHTNSTgPPmqryIlc39pE05p/CW120C8Vu5ht
        Hx92wAdX1WViuqdRNZ7e5Tx2kQ==
X-Google-Smtp-Source: AA6agR7UYsrj19zbIFeYD2jDVB8isYbhTm3h1c0fbJZBExhGx+VBiKnSnRIwqdwGn6OnQp7cOEd9Og==
X-Received: by 2002:a17:90a:8984:b0:1fa:f77a:ed9b with SMTP id v4-20020a17090a898400b001faf77aed9bmr1186765pjn.118.1660933823309;
        Fri, 19 Aug 2022 11:30:23 -0700 (PDT)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id t11-20020a1709027fcb00b00172c7dee22fsm823283plb.236.2022.08.19.11.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 11:30:22 -0700 (PDT)
Date:   Fri, 19 Aug 2022 18:30:19 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 3/8] KVM: x86/mmu: Rename NX huge pages
 fields/functions for consistency
Message-ID: <Yv/Wu46A98nz57YQ@google.com>
References: <20220805230513.148869-1-seanjc@google.com>
 <20220805230513.148869-4-seanjc@google.com>
 <YvhL6jKfKCj0+74w@google.com>
 <YvrAoyhgNzTcvzkU@google.com>
 <YvwHpjxS9CCEVER7@google.com>
 <Yv0Tk0WAdxymSyUt@google.com>
 <Yv65c/t23GqpLPg3@google.com>
 <Yv7PHx2qSB0PwkP/@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv7PHx2qSB0PwkP/@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 18, 2022, Sean Christopherson wrote:
> On Thu, Aug 18, 2022, Mingwei Zhang wrote:
> > On Wed, Aug 17, 2022, Sean Christopherson wrote:
> > > Yes, they are shadow pages that the NX recovery thread should zap, but the reason
> > > they should be zapped is because (a) the shadow page has at least one execute child
> > > SPTE, (b) zapping the shadow page will also zap its child SPTEs, and (c) eliminating
> > > all executable child SPTEs means KVM _might_ be able to instantiate an NX huge page.
> > > 
> > 
> > oh, I scratched my head and finaly got your point. hmm. So the shadow
> > pages are the 'blockers' to (re)create a NX huge page because of at
> > least one present child executable spte. So, really, whether these
> > shadow pages themselves are NX huge or not does not really matter. All
> > we need to know is that they will be zapped in the future to help making
> > recovery of an NX huge page possible.
> 
> More precisely, we want to zap shadow pages with executable children if and only
> if they can _possibly_ be replaced with an NX huge page.  The "possibly" is saying
> that zapping _may or may not_ result in an NX huge page.  And it also conveys that
> pages that _cannot_ be replaced with an NX huge page are not on the list.
> 
> If the guest is still using any of the huge page for execution, then KVM can't
> create an NX huge page (or it may temporarily create one and then zap it when the
> gets takes an executable fault), but KVM can't know that until it zaps and the
> guest takes a fault.  Thus, possibly.
> 

Right, I think 'possible' is definitely a correct name for that. In
general, using 'possible' can cover the complexity to ensure the
description is correct. My only comment here is that 'possible_' might
requires extra comments in the code to be more developer friendly.

But overall, since I already remembered what was the problem. I no
longer think this naming is an issue to me. But just that the name could
be better.

> > With that, since you already mentioned the name:
> > 'mmu_pages_that_can_possibly_be_replaced_by_nx_huge_pages',
> > why can't we shorten it by using 'mmu_pages_to_recover_nx_huge' or
> > 'pages_to_recover_nx_huge'? 'recover' is the word that immediately
> > connects with the 'recovery thread', which I think makes more sense on
> > readability.
> 
> mmu_pages_to_recover_nx_huge doesn't capture that recovery isn't guaranteed.
> IMO it also does a poor job of capturing _why_ pages are on the list, i.e. a
> reader knows they are pages that will be "recovered", but it doesn't clarify that
> they'll be recovered/zapped because KVM might be able to be replace them with NX
> huge pages.  In other words, it doesn't help the reader understand why some, but
> not all, nx_huge_page_disallowed are on the recovery list.

I think you are right that the name does not call out 'why' the pages
are on the list. But on the other hand, I am not sure how much it could
help clarifying the situations by just reading the list name. I would
propose we add the conditions using the (flag, list).

(nx_huge_page_disallowed, possible_nx_huge_pages)

case (true,  in_list):     mitigation for multi-hit iTLB.
case (true,  not_in_list): dirty logging disabled; address misalignment; guest did not turn on paging.
case (false, in_list):     not possible.
case (false, not_in_list): Any other situation where KVM manipulate SPTEs.

Maybe this should be in the commit message of the previous patch.


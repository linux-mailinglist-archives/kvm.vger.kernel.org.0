Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40AA54A6EA
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 04:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356446AbiFNCfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 22:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355344AbiFNCfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 22:35:10 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C25738BDB;
        Mon, 13 Jun 2022 19:13:28 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id z9so3878128wmf.3;
        Mon, 13 Jun 2022 19:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qx1x66X9cxQ2Do1EWzHRpluo9ytwIzS6EQlleJWoehY=;
        b=fFWt4iizlpVuwbqmb/m8i1/dvxNDmKsIyRbCjZdRm21fChV8QpPP50TmJbkR0aUw4T
         whze9ldyTpOeVy0dNlAs2t6gV0/cogGNdu+uKbWzrUGPCwN2WISJ3b6Sa1F7LlTzHO4g
         iUUn78rEiGDdleKX2k0OJZHvgiFOl7swWPVBeIQsJDGlDhSR4tgaHSsLEwmrHGI8TAal
         BVxefl1+gEOgHXo0BKa13hmmbqKSDnPHqyXMnezfuiX19BPp9z4Ycd4De6m3cmeoi4Lu
         zgdC9oBfcizi9O2ZfoEAJOzluaxR9QbTtLCA+tSdUUUPAvsrbxuLkhn0OCiM8sTMKntD
         0eJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qx1x66X9cxQ2Do1EWzHRpluo9ytwIzS6EQlleJWoehY=;
        b=QoW4ruPvF29zFVaby59Xb+72BLJLC25xxp/Ag91glRevLTEH37B0Uh20Y9+TzjM27Q
         tM2P1x2cOtu8g3Um6BnnMByPPYdxti66GxVBV71i0J7F6c2Qe8BFDA/r/hO75QO0paHs
         tpJTGT/ep+udfBi026yDPcF0pieExlWgp6/zSVQNF/LkHetEWotlmp3GNDqJKpGCye6p
         eNkL4pVmv+7NI6pxYkVCaINAmp0lX3tPKo+bwnhkaiXmjyXE46F1Fc0N1JjTfPv5C6rE
         gmOLzZe1WDV2hs7R3o+YA467lrFE5ooddh22KHk5qz5tnvLMCYYI6WMknLZRWoHnjrfW
         Mtgg==
X-Gm-Message-State: AOAM530hpBlkBxtGKbp8BbYF9S4kRSyNZEvGa6si+nq1ZoOuYazIrqw+
        YHanv3+udQqL2ak6yBt6htbZTc+n4KFAAqvB4yo=
X-Google-Smtp-Source: ABdhPJwoEYy9BBV9NZpta2nTXCP5Zq6MIoI/3/DMRpBP8zIM1i4VyoWJH5O8IzMLWNWoe6HQ1whA1Vcf9JKdtDo3Zj8=
X-Received: by 2002:a05:600c:d0:b0:39c:5927:3fa7 with SMTP id
 u16-20020a05600c00d000b0039c59273fa7mr1629426wmm.36.1655172805503; Mon, 13
 Jun 2022 19:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220613225723.2734132-1-seanjc@google.com> <20220613225723.2734132-2-seanjc@google.com>
In-Reply-To: <20220613225723.2734132-2-seanjc@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 14 Jun 2022 10:13:14 +0800
Message-ID: <CAJhGHyDjFCJdRjdV-W5+reg-3jiwJAqeCQ7A-vdUqt+dToJBdA@mail.gmail.com>
Subject: Re: [PATCH 1/8] KVM: x86/mmu: Drop unused CMPXCHG macro from paging_tmpl.h
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 6:59 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Drop the CMPXCHG macro from paging_tmpl.h, it's no longer used now that
> KVM uses a common uaccess helper to do 8-byte CMPXCHG.
>
> Fixes: f122dfe44768 ("KVM: x86: Use __try_cmpxchg_user() to update guest PTE A/D bits")
> Signed-off-by: Sean Christopherson <seanjc@google.com>


In https://lore.kernel.org/lkml/20220605063417.308311-2-jiangshanlai@gmail.com/
two other unused macros are also removed.

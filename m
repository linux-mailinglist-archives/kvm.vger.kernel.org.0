Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E147C45D9
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 02:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344262AbjJKAIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 20:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjJKAIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 20:08:11 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9144A8F
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 17:08:10 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9a581346c4so1837129276.0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 17:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696982890; x=1697587690; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zd/nacEbxpo/jAXF8pqfkyF745LkcXcc4cVmKOG5Cnc=;
        b=bRa8OQEfYVX+NWc9dsps3hAtbxwl6xhCaCdfGPb87lERItoje9u/wLlc3eTE1P/HKz
         6ydAbsbZUrgaUXU9Ylm9JRFz403scKolnCxHRBnlLuSrIUuPyEpi5WtanqHUBfqy+21k
         x/q68oIwG/LOcIFMOnJNYYZ6ypdDEn9NfetUhrylfesVTehhXNAjn51Ds9QnQdRmL74p
         zjK5F37/623wxaY2VSS5rPwxoRRXrgslMrF4FqSlz5h8fJaQMZkI9akUkbaEe9U9U+6y
         ssvLfTeJH54fo+yzuWA5dE5c76t4ZLv8xl1gojIT5VYiS3cNPV8NJXG3xVVYtzSW92qA
         U8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696982890; x=1697587690;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zd/nacEbxpo/jAXF8pqfkyF745LkcXcc4cVmKOG5Cnc=;
        b=KocDJiSNdRr/p0OLrByAGrzGQOZiVCu5iv957JTeVORSfveVuy+RYaWPDo+GP5oMIg
         AwesQ1ovC76J3bWiJdS6ZfhC3A1MxQLM2521a1/8JR4tEoonw8Jg+EaKYkGC0ALzEbY2
         wv8JQs0ByUM3UAysQsWytNXG/kQMrpNfsW28fX46i5OqALbpm4du4d2RLAJc0okaFg+p
         VYJwlH+6fOkcci70p1L7Sr4z7susxkMQmCfotlyjATEjtv4IVYE7XHbe2C5kaYItCkl6
         U7RCLZZWJwtWQMDRH2Lq282hZPp8WA+SL6x5ypc2bUFtWJn3RyWmipUAb74cH9SA94v4
         Ntwg==
X-Gm-Message-State: AOJu0YxYig3G/VOUwsk5CaFRTyqmoLEHZebo6xf78R1hXaWrqD6UnbhY
        vYqjzMJfK/AIFBI+R/tkkq+U+pXI09Q=
X-Google-Smtp-Source: AGHT+IFQ66Ca540lvih4SLhNTTRYCUUNHt9H2N1GvXrlAGsoLUfqbdcMRs9ubpWDRQxYrK7C/D1lL1ukK7c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:514:0:b0:d91:c7f2:764 with SMTP id
 20-20020a250514000000b00d91c7f20764mr272449ybf.0.1696982889881; Tue, 10 Oct
 2023 17:08:09 -0700 (PDT)
Date:   Tue, 10 Oct 2023 17:08:08 -0700
In-Reply-To: <ZSTJEJepdnmC5PA5@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230714064656.20147-1-yan.y.zhao@intel.com> <20230714065006.20201-1-yan.y.zhao@intel.com>
 <553e3a0f-156b-e5d2-037b-2d9acaf52329@gmail.com> <ZSRZ_y64UPXBG6lA@google.com>
 <ZSRwNO4xWU6Dx1ne@google.com> <ZSTJEJepdnmC5PA5@yzhao56-desk.sh.intel.com>
Message-ID: <ZSXnaIi454ATEdH0@google.com>
Subject: Re: [PATCH v4 01/12] KVM: x86/mmu: helpers to return if KVM honors
 guest MTRRs
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Like Xu <like.xu.linux@gmail.com>, pbonzini@redhat.com,
        chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com, yuan.yao@linux.intel.com,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023, Yan Zhao wrote:
> BTW, as param "kvm" is now removed from the helper, better to remove the word
> "second" in comment in patch 4, i.e.
> 
> -        * So, specify the second parameter as true here to indicate
> -        * non-coherent DMAs are/were involved and TDP zap might be
> -        * necessary.
> +        * So, specify the parameter as true here to indicate non-coherent
> +        * DMAs are/were involved and TDP zap might be necessary.
> 
> Sorry and thanks a lot for helps on this series!

Heh, don't be sorry, it's not your fault I can't get this quite right.  Fixed
up yet again, hopefully for the last time.  This is what I ended up with for the
comment:

	/*
	 * Non-coherent DMA assignment and de-assignment will affect
	 * whether KVM honors guest MTRRs and cause changes in memtypes
	 * in TDP.
	 * So, pass %true unconditionally to indicate non-coherent DMA was,
	 * or will be involved, and that zapping SPTEs might be necessary.
	 */

and the hashes:

[1/5] KVM: x86/mmu: Add helpers to return if KVM honors guest MTRRs
      https://github.com/kvm-x86/linux/commit/1affe455d66d
[2/5] KVM: x86/mmu: Zap SPTEs when CR0.CD is toggled iff guest MTRRs are honored
      https://github.com/kvm-x86/linux/commit/7a18c7c2b69a
[3/5] KVM: x86/mmu: Zap SPTEs on MTRR update iff guest MTRRs are honored
      https://github.com/kvm-x86/linux/commit/9a3768191d95
[4/5] KVM: x86/mmu: Zap KVM TDP when noncoherent DMA assignment starts/stops
      https://github.com/kvm-x86/linux/commit/362ff6dca541
[5/5] KVM: VMX: drop IPAT in memtype when CD=1 for KVM_X86_QUIRK_CD_NW_CLEARED
      https://github.com/kvm-x86/linux/commit/c9f65a3f2d92

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B634A76BE17
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 21:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjHATtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 15:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjHATtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 15:49:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F44A2116
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 12:49:02 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bbb97d27d6so42581225ad.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 12:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690919342; x=1691524142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ymMuGbXslfyJGs4W/pBqFuGxl9xUvy7q5fX4QbBoOtQ=;
        b=CydE6ofDFbki4OoGOG75dPf8HjmzdP4bx8vverzkUAQVtD69mMn7n68FWR8AAp7DXQ
         w+dl1y5zJGShPu6hUhv3xWgs0RLuDKkU1QeFVeAkGndzTQF4ejZ1rYTen/R2bDlQiGdt
         p2JE4NI74wSzCDPayw3C3EPUnZHQ6AwVPX7+Hr/id3ZzAXZ75VD1wArInmjbenyfG79V
         cEByprzGAc4WBhBRZXFreyy3tDtKJhpsG+vPyPTXY7LVerieG5d/K0kioNLl2WhELfBY
         ntCCC/ISdhA9syO12Y1PCPSKi59/fx8iNJKpcw07IuHVOLESRbk7CVIj2E7rNQ0Q4Awv
         rGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690919342; x=1691524142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ymMuGbXslfyJGs4W/pBqFuGxl9xUvy7q5fX4QbBoOtQ=;
        b=ZadZkFi/QWso2HvObdVpF/+QpPf61MxrCReOPiR3DKi1pXeMdE5PFuT48JTDLC7Qaz
         GdCu+RcxMgnYp/OkkGmjtpNCpCsg3iAKapjBbrKEivypksbMfYRuHS25MUAnkXweiEIa
         678sq6QNl+QZYH5B6wi4o4X9XahzCuU6htWhKQZbTbrWNsfoaCpWYlbbwnQkFvc9BP6J
         ysCnVtw9DKnQZna1wEsG81n1M5gddxjCTevf04/WCKxddJHSLXgdpdhjvqWw4He4h7Zm
         WBR8CH35ifFn2UCgELgLxzSqOnTLlVi28uxuWTNl+vhsPpGMuu4IS+zZIN/bOX+NpPTg
         W7jA==
X-Gm-Message-State: ABy/qLYq9tIwv0yJCZyZTlbtb/EaSvgSto3cBiGxXSj61LC3cpGe2OXf
        9A6PJnvpPHfjvBXPJiX8IVjKIS7tYdk=
X-Google-Smtp-Source: APBJJlHzs/CPjAfxg4yY07jd2lFS2uJwEiSQkwxUoufms67SS+axZJeOfATbgdLU+XSQqEOfpNJp/uAu49A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f683:b0:1b8:a54c:61ef with SMTP id
 l3-20020a170902f68300b001b8a54c61efmr67559plg.9.1690919341844; Tue, 01 Aug
 2023 12:49:01 -0700 (PDT)
Date:   Tue, 1 Aug 2023 19:49:00 +0000
In-Reply-To: <20230801193750.GA119080@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
References: <20230801083553.8468-1-xin3.li@intel.com> <20230801083553.8468-7-xin3.li@intel.com>
 <ZMlWe5TgS6HM98Mg@google.com> <20230801193750.GA119080@hirez.programming.kicks-ass.net>
Message-ID: <ZMlhrHv1c9P6HQXw@google.com>
Subject: Re: [PATCH RESEND v9 33/36] KVM: VMX: Add VMX_DO_FRED_EVENT_IRQOFF
 for IRQ/NMI handling
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Breno Leitao <leitao@debian.org>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Brian Gerst <brgerst@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ze Gao <zegao2021@gmail.com>, Fei Li <fei1.li@intel.com>,
        Conghui <conghui.chen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sathvika Vasireddy <sv@linux.ibm.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023, Peter Zijlstra wrote:
> On Tue, Aug 01, 2023 at 07:01:15PM +0000, Sean Christopherson wrote:
> > The spec I have from May 2022 says the NMI bit colocated with CS, not SS.  And
> > the cover letter's suggestion to use a search engine to find the spec ain't
> > exactly helpful, that just gives me the same "May 2022 Revision 3.0" spec.  So
> > either y'all have a spec that I can't find, or this is wrong.
> 
> https://intel.com/sdm
> 
> is a useful shorthand I've recently been told about.

Hallelujah!

> On that page is also "Flexible Return and Event Delivery Specification", when
> clicked it will gift you a FRED v5.0 PDF.

Worked for me, too.  Thanks!

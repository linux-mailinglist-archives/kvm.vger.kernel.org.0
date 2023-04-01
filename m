Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E613E6D2ECE
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 09:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbjDAHAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 03:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjDAHAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 03:00:46 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6871A470;
        Sat,  1 Apr 2023 00:00:44 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id h25so31737333lfv.6;
        Sat, 01 Apr 2023 00:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680332442; x=1682924442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4N/zqwZCwI+hFvEisSUVXazz/w3zutZ7e26nPhhd1c=;
        b=OWFV/otHntfgbZf/w47Qi7A8BurSREAyhNBg+gGxzwaY/+g2DnbUipiem796mu4wLv
         qx5qDMMk6WLMP+FXsuWf5iy06Mw0uOEQ9F/gevMKv5nT7BNOEdlVswsR4TEVjMNLJR2p
         48Fx8dnFc1Z2N0xTBVsLAQCCk93KqAyH6uI1Vd7m1GEbxY8U6pBQ8z3csstkLMydhACY
         wGA+ZGmjowtMZgAjNlBubBUjp/0BHxcL8+zoSch8slpw1MkiTMfVAJl6Xz9uXT77z3Ph
         QIaIixWAKIwrWLRAJzfU77dogTtiRJvljdOlMippskPvO53FRyVxb+j7F+EZ1OibKqXz
         xMHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680332442; x=1682924442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z4N/zqwZCwI+hFvEisSUVXazz/w3zutZ7e26nPhhd1c=;
        b=tCuf9Duc95P31xbfWASAlUJK+3sKd3rL2z9YHYKaouPAtGoSwpQ2tW0ddzf0FJUMzp
         5xTRV3qnxucONm2kj00aNSD6XbbxjhpmLODk32YAfhVw9XkN+coPaScfDXMR+UoSXPEO
         MBGkqjO1PKwU1PYgGNLFHWSijssKm3hMB9QBwY81Cs6mJ3bRlb3r1xyJsnZq6za5QWSB
         NUbp9tFyyHp7l7ao69WJO/WMBTpzcdwYGOdfshHstvyFHy2jqbwKx+oUaW1K3wnEeWPr
         RXDAM4y2/p2VSXb+5CmF31REgQ/WogKTCYf7ThA2KPxfd/Y+NLMYj34mLigWC19dAQ9U
         bdjg==
X-Gm-Message-State: AAQBX9c372A8C3+sv4F97d89X9ul5A1s7kakxSNHGz27tGSEnewr1fzK
        7PJdbYiuVoHXk+4XDE8tj7E=
X-Google-Smtp-Source: AKy350bX3oyjM1fk52UPbQp3gI4Arl0r3n2g09mjo9ID5ZrfUYzn8EsM61ZQ9KMwJKCzs5juwoN3IQ==
X-Received: by 2002:ac2:4884:0:b0:4db:387f:a3aa with SMTP id x4-20020ac24884000000b004db387fa3aamr7445525lfc.1.1680332442120;
        Sat, 01 Apr 2023 00:00:42 -0700 (PDT)
Received: from localhost (88-113-32-99.elisa-laajakaista.fi. [88.113.32.99])
        by smtp.gmail.com with ESMTPSA id y22-20020ac255b6000000b004d0b1327b75sm706968lfg.61.2023.04.01.00.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 00:00:42 -0700 (PDT)
Date:   Sat, 1 Apr 2023 10:00:40 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v13 018/113] KVM: x86, tdx: Make KVM_CAP_MAX_VCPUS
 backend specific
Message-ID: <20230401100040.0000515c@gmail.com>
In-Reply-To: <20230329233258.GC1108448@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <87f6baf8419103077f0a42859a0a847c695f5f59.1678643052.git.isaku.yamahata@intel.com>
        <20230325201326.00002d4d@gmail.com>
        <20230329233258.GC1108448@ls.amr.corp.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Mar 2023 16:32:58 -0700
Isaku Yamahata <isaku.yamahata@gmail.com> wrote:

> On Sat, Mar 25, 2023 at 08:13:26PM +0200,
> Zhi Wang <zhi.wang.linux@gmail.com> wrote:
> 
> > On Sun, 12 Mar 2023 10:55:42 -0700
> > isaku.yamahata@intel.com wrote:
> > 
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > TDX has its own limitation on the maximum number of vcpus that the guest
> > > can accommodate.  Allow x86 kvm backend to implement its own KVM_ENABLE_CAP
> > > handler and implement TDX backend for KVM_CAP_MAX_VCPUS.  user space VMM,
> > > e.g. qemu, can specify its value instead of KVM_MAX_VCPUS.
> > > 
> > 
> > I think enabling the cap here is actually "configuring the cap". KVM_CAP_MAX
> > _VCPUS is actually always enabled whether userspace enables it or not. It
> > would be nice to configure of the max VCPUS in kvm_arch_vm_ioctl() where
> > routines of configuring a VM should belong. E.g. KVM_SET_MAX_VCPUS.
> 
> I'm not sure I understand your point.  Although KVM_ENABLE_CAP sounds like
> only on/off feature, but it isn't. It's also used to set parameters. For
> example, KVM_CAP_MAX_VCPU_ID.
>

Yes, I understand your point. But what has been there might not be right as
well. That doesn't smell right as "enable" is for something which is previously
"disabled". I understand that there can be some caps require configuration
when being enabled. But later, for those caps which don't have "on/off"
state, KVM_ENABLE_CAP doesn't actually enable a feature, it is just
configuring a feature. It seems like the KVM_ENABLE_CAP has been mis-used
little by little in the history. Also, I don't find KVM_DISABLE_CAP
accordingly. So KVM_ENABLE_CAP is actually used as "KVM_SET_CAP". 

I realize it is not realistic to solve the problem in this patch series.
You can keep the current approach. 

> KVM_SET_XXX is for run time feature. But the maxium number of vcpus is not
> runtime changable. Set it at vm creation.


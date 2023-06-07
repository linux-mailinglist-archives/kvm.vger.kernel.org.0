Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5FC726A1E
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 21:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbjFGTr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 15:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbjFGTr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 15:47:27 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0AE101;
        Wed,  7 Jun 2023 12:47:24 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso7011968a12.1;
        Wed, 07 Jun 2023 12:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686167244; x=1688759244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jcZW7HM4Z+VTpJgqxtgAswvzaTnMfZjVuQ9QEZa6vH4=;
        b=IGFnu//niFMk5TiITkVoJUsAqE/6IcQ5sIU++gOt2HZ/2WOLAsyj9D9YiNEQvJxM7l
         OxxP680fQmNGmkclthwx7/6esh6O5yyZ1JSEgHEdHN+SFwcW3LzgyhD1seTnQ2KRGBZV
         0vBtS9DjAYkj4n8kjft0FQlxhd1U4ce+4ne0APWum+YX462FQUou6h+2g6nuDs23lK83
         e9aEizsHeBcZHDYr34EGrqpwGEgfBLDy/YqkHRM3+CkVelzkfLCCslkaX5u8eKOJ2lFu
         woFoOYystmK1Gxy5jrC1E7ZVbOLVcTfgjT/R7udmBChKvxgvYwJAcyZ8ic42oOoK3HMB
         lshA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686167244; x=1688759244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcZW7HM4Z+VTpJgqxtgAswvzaTnMfZjVuQ9QEZa6vH4=;
        b=Ck6DY0S0NhIgtHdjSqZT4EfBMfb3uTGPEvNdiGPdV6hV6NGecwPMCZeL2vEgarWTXD
         +g3m7KM7rPbw1wpnRohDXxYC3T/UyqxxzahfHM84LVWrEWjltwsdYdm82TCMWbFAPUW0
         i72TK+6k/EWHwOxKUqrK+ckOal30x6XeLMQyUJGVTOW22uY7t3V6/Phh317ABXA/BiXH
         u2fSD/wAEO3/AnBu1vlh3t1HhX+h5E2NWenlvlRDqTvMRqZ4MPi5uk9HJRcYU52+Y4+O
         bibV8NSkIgEVrnmLlbBHLpxrD9UZEle1kCd9Z2F2Nc1GeDeRBDLdKYws+ce6J93LjslT
         iR7Q==
X-Gm-Message-State: AC+VfDy8Jr9OItRF/krx3qU2ly2ps8FLlmjak1IrsZ8zlEY9RAysiD3V
        xDRtD++EGX1t8xsRzkCgd4M=
X-Google-Smtp-Source: ACHHUZ4iCwdXBq6qN9fQHvCx/Cnsqn/cVFFgxIJTLHi516LAiFZQLtd3kKIDR8MnHYa9wtTRSXQGpw==
X-Received: by 2002:a05:6a20:a5a9:b0:10e:d134:d686 with SMTP id bc41-20020a056a20a5a900b0010ed134d686mr4352946pzb.6.1686167243612;
        Wed, 07 Jun 2023 12:47:23 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id b20-20020aa78114000000b00660f0e4da6esm2758909pfi.183.2023.06.07.12.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 12:47:23 -0700 (PDT)
Date:   Wed, 7 Jun 2023 12:47:21 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Message-ID: <20230607194721.GI2244082@ls.amr.corp.intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
 <92e19d74-447f-19e0-d9ec-8a3f12f04927@intel.com>
 <20230607185355.GH2244082@ls.amr.corp.intel.com>
 <f7ef157e-8f26-8d7b-a9b8-cb8de7f7aa2b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f7ef157e-8f26-8d7b-a9b8-cb8de7f7aa2b@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023 at 12:27:33PM -0700,
Dave Hansen <dave.hansen@intel.com> wrote:

> On 6/7/23 11:53, Isaku Yamahata wrote:
> >>> VMX enabling, and KVM is the only user of TDX.  This implementation
> >>> chooses to make KVM itself responsible for enabling VMX before using
> >>> TDX and let the rest of the kernel stay blissfully unaware of VMX.
> >>>
> >>> The current TDX_MODULE_CALL macro handles neither #GP nor #UD.  The
> >>> kernel would hit Oops if SEAMCALL were mistakenly made w/o enabling VMX
> >>> first.  Architecturally, there is no CPU flag to check whether the CPU
> >>> is in VMX operation.  Also, if a BIOS were buggy, it could still report
> >>> valid TDX private KeyIDs when TDX actually couldn't be enabled.
> >> I'm not sure this is a great justification.  If the BIOS is lying to the
> >> OS, we _should_ oops.
> >>
> >> How else can this happen other than silly kernel bugs.  It's OK to oops
> >> in the face of silly kernel bugs.
> > TDX KVM + reboot can hit #UD.  On reboot, VMX is disabled (VMXOFF) via
> > syscore.shutdown callback.  However, guest TD can be still running to issue
> > SEAMCALL resulting in #UD.
> > 
> > Or we can postpone the change and make the TDX KVM patch series carry a patch
> > for it.
> 
> How does the existing KVM use of VMLAUNCH/VMRESUME avoid that problem?

extable. From arch/x86/kvm/vmx/vmenter.S

.Lvmresume:
        vmresume
        jmp .Lvmfail

.Lvmlaunch:
        vmlaunch
        jmp .Lvmfail

        _ASM_EXTABLE(.Lvmresume, .Lfixup)
        _ASM_EXTABLE(.Lvmlaunch, .Lfixup)


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

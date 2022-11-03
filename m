Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C48617333
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 01:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiKCAFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 20:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiKCAFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 20:05:33 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502DA2678;
        Wed,  2 Nov 2022 17:05:32 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id v28so135083pfi.12;
        Wed, 02 Nov 2022 17:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gN1mKfLTOfiBIachHef1NvCz2+Mp1pI1D3scxDhbX2Q=;
        b=VoMoH5s1BaOgvMgxmxoaPSwIJ8csJ12qeDMhgkAZfx8dggO8aBmKyGFJonnw5N6UAG
         uOyMsPS8VtwD9n0cMlotq0o8rXdSvdDihbRJv8fdd44k6IvqOu3iiqi2vkH/59wOnESa
         YmgBDkdpDxqVv06Pcx3IaPrLjCgM6zzJKIA+LyqViCr64R3kbryML579QXUXMVq9j6N8
         nJEO8kUqLntVvB9FMuX3dW0JCOmIuHZRzQRQj791lZdM99vhP/1f5vDsiImKbwM9oLRJ
         KNtkrhOBSsXZ2bjFUnZhPWWCRDpIVGUZlPaSV3VmIZ3QDGCN5qzRxtstIYDwcew2bZJ0
         dMyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gN1mKfLTOfiBIachHef1NvCz2+Mp1pI1D3scxDhbX2Q=;
        b=O67LWDHl9Xv/bEWja18lw8QC6ySVxdwQkpFUsxNFbeb47qUz2uCpT/uS+6MtNPyaId
         /keFOZh16/queb7IcGW2bNidBIf/mE5xJ1PMrJCpAJZ8Q1jVf0Jxpv/XVTHEYPPI3Rxs
         hN4bt/EWy3z3SSsgHzbFu8eryGT+fH8/f8t9ji6n9EvlHyyYA3FUnqeoZirUPDkacs+r
         5CzSzwQZneWmua8HpcZR/o0vxgoVtGIsBRVYWKU1UbHoMCpJphIKcmzi0KGohJWhzTRW
         7UiKiPiygPibXksZdPDGQaCzfwyCfW5WH5s+/eXs9wmUMMu00+sDwsa47rS4Pz7vUI7x
         jovQ==
X-Gm-Message-State: ACrzQf2v78JFz7tLEuv09XvSJHZ94/zALD7wgt5T9ubYuKZ7I7KCxeH8
        SbdSa/sFSYpDRLDM1hzG1TFwwxj0pp4=
X-Google-Smtp-Source: AMsMyM6g7lsgrfrPjXE/AcpfOSIAQAVmLQDsXcOWJ3BZT8e2elxDiXSDqV8yNe2gtN5nJ1oRn4LM3w==
X-Received: by 2002:a63:1f5c:0:b0:469:d0e6:dac0 with SMTP id q28-20020a631f5c000000b00469d0e6dac0mr23190352pgm.427.1667433931649;
        Wed, 02 Nov 2022 17:05:31 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902ea1000b001837b19ebb8sm8955062plg.244.2022.11.02.17.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 17:05:30 -0700 (PDT)
Date:   Wed, 2 Nov 2022 17:05:30 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v10 010/108] KVM: TDX: Add TDX "architectural" error codes
Message-ID: <20221103000530.GA954260@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <679bb45187dc54b82ebc9df5381a7d5de0b782d5.1667110240.git.isaku.yamahata@intel.com>
 <f1fdc428-f407-9582-c392-579f873f7562@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1fdc428-f407-9582-c392-579f873f7562@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 05:22:13PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> On 2022/10/30 14:22, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Add error codes for the TDX SEAMCALLs both for TDX VMM side for TDH
> > SEAMCALL and TDX guest side for TDG.VP.VMCALL.  KVM issues the TDX
> > SEAMCALLs and checks its error code.  KVM handles hypercall from the TDX
> > guest and may return an error.  So error code for the TDX guest is also
> > needed.
> > 
> > TDX SEAMCALL uses bits 31:0 to return more information, so these error
> > codes will only exactly match RAX[63:32].  Error codes for TDG.VP.VMCALL is
> > defined by TDX Guest-Host-Communication interface spec.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >   arch/x86/kvm/vmx/tdx_errno.h | 38 ++++++++++++++++++++++++++++++++++++
> >   1 file changed, 38 insertions(+)
> >   create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
> > new file mode 100644
> > index 000000000000..ce246ba62454
> > --- /dev/null
> > +++ b/arch/x86/kvm/vmx/tdx_errno.h
> > @@ -0,0 +1,38 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/* architectural status code for SEAMCALL */
> > +
> > +#ifndef __KVM_X86_TDX_ERRNO_H
> > +#define __KVM_X86_TDX_ERRNO_H
> > +
> > +#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
> > +
> > +/*
> > + * TDX SEAMCALL Status Codes (returned in RAX)
> > + */
> > +#define TDX_SUCCESS				0x0000000000000000ULL
> > +#define TDX_NON_RECOVERABLE_VCPU		0x4000000100000000ULL
> > +#define TDX_INTERRUPTED_RESUMABLE		0x8000000300000000ULL
> > +#define TDX_OPERAND_BUSY                        0x8000020000000000ULL
> 
> one minor format issue, spaces are used  instread of tabs this line.

Thanks, fixed it locally. It will be include in the next respin.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

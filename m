Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6662C5A19CA
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 21:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242702AbiHYTsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 15:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237407AbiHYTsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 15:48:33 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F515FAEB;
        Thu, 25 Aug 2022 12:48:32 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 142so1690499pfu.10;
        Thu, 25 Aug 2022 12:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=OaWDF3tpGoRU6/AyqqMW1f8xc8xe3+LZ3UaQBdMhu3Q=;
        b=WCHeoWbSf1BohfDyzd2zo93eEPPd8iwfLlbtwZkoab5FdZ1UdnKuf6zi6qtolgo8Ey
         LSJwtiaW60/iAEXoYZobmBHVjzbgV2TC7pOHtziyD9corHwWfIiBqu38D8HdKVx3wYUW
         WrcI3rfAXg0Tw8+i+aEaXbEKoZ8r+apcq5FOZ5Tp81H/Keuk7pBaHYba8aw06y5hSIy9
         SfVW63p7UQdaGNdyjGhbsKVFtJ4KU0stUnhfnu90oHS7qMwGLNgfLVe7N9Et5268H+UG
         q849NA46Ap4HeXO8daH2i9l0BCSxwn05ad33ptRyM06BNtZkNgXJVRVpEux7M5wIKI1V
         EdUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=OaWDF3tpGoRU6/AyqqMW1f8xc8xe3+LZ3UaQBdMhu3Q=;
        b=wbSs/h1/aCfMqj1vS2sYaYDLGihod74KB7N55ofbBD1XrLYmBX+SSWwiDg0xMD5rUy
         SCVTW690Wqnm29axDA2b1woT2fHMcwxB1+goGBRal2qWwU8cJQKLo6u2LtEhmQzQQgoV
         t0tXfisge17XI4vvjUNLtqkAfU4EcgyJKpsU1/3Y6qjE7tmfcjGEGb5JK/Vm13rE/JJ7
         XWB6Nbzxbn+26z1dVRilDHKWeQqUyFqevjEq6ISaU6To3vAEHOqRxWI9hIobGOKmCfty
         pGwh36jPGNA3jmWIn8NEWUJJ8u39Oi4Gtry6I3FbepMVCGm/6vCqOAmhQ4Vg5Yp60ppx
         mTqQ==
X-Gm-Message-State: ACgBeo2Csp6o2eudrBB85Wt4Ul55zb9K/Ki1cC6nDqbQR2odYDo+lRMr
        ZlYziDI8afWGJyyLuSpt+qU=
X-Google-Smtp-Source: AA6agR7nPfIyGzudfXlCB8kQRsVjW8mcqYegG9oGUzyJ33skMukzMcWIEgc8+8mazIXS2dw4sByPYg==
X-Received: by 2002:a63:4c:0:b0:42b:2673:2180 with SMTP id 73-20020a63004c000000b0042b26732180mr514022pga.491.1661456911653;
        Thu, 25 Aug 2022 12:48:31 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id g10-20020a17090a67ca00b001fa79c1de15sm106388pjm.24.2022.08.25.12.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 12:48:31 -0700 (PDT)
Date:   Thu, 25 Aug 2022 12:48:29 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v8 002/103] Partially revert "KVM: Pass kvm_init()'s
 opaque param to additional arch funcs"
Message-ID: <20220825194829.GA2538772@ls.amr.corp.intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <3af25cc7502769b98755920807bc8a1010de1d45.1659854790.git.isaku.yamahata@intel.com>
 <c2e61778ca549e8ee4cb44194df367455a20f645.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2e61778ca549e8ee4cb44194df367455a20f645.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022 at 09:59:34AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sun, 2022-08-07 at 15:00 -0700, isaku.yamahata@intel.com wrote:
> > From: Chao Gao <chao.gao@intel.com>
> > 
> > This partially reverts commit b99040853738 ("KVM: Pass kvm_init()'s opaque
> > param to additional arch funcs") remove opaque from
> > kvm_arch_check_processor_compat because no one uses this opaque now.
> > Address conflicts for ARM (due to file movement) and manually handle RISC-V
> > which comes after the commit.  The change about kvm_arch_hardware_setup()
> > in original commit are still needed so they are not reverted.
> > 
> > The current implementation enables hardware (e.g. enable VMX on all CPUs),
> > arch-specific initialization for VM creation, 
> > 
> 
> I guess you need to point out _first_ VM?

Yes. I'll add "first".

> 
> > and disables hardware (in
> > x86, disable VMX on all CPUs) for last VM destruction.
> > 
> > TDX requires its initialization on loading KVM module with VMX enabled on
> > all available CPUs. It needs to enable/disable hardware on module
> > initialization.  To reuse the same logic, one way is to pass around the
> 
> To reuse the same logic for what?  I think you need to be specific (and focus)
> on why we need this patch:  we will opportunistically move CPU compatibility
> check to hardware_enable_nolock(), which doesn't take any argument, and this
> patch is a preparation to do that.
> 
> 
> > unused opaque argument, another way is to remove the unused opaque
> > argument.  This patch is a preparation for the latter by removing the
> > argument
> 
> So how about replacing the last two paragraphs with:
> 
> "
> Initializing TDX will be done during module loading time, and in order to do
> that hardware_enable_all() will be done during module loading time too, as
> initializing TDX requires all cpus being in VMX operation.  As a result, CPU
> compatibility check will be opportunistically moved to hardware_enable_nolock(),
> which doesn't take any argument.  Instead of passing 'opaque' around to
> hardware_enable_nolock() and hardware_enable_all(), just remove the unused
> 'opaque' argument from kvm_arch_check_processor_compat().
> "
> 
> Or even simpler:
> 
> "
> To support TDX, hardware_enable_all() will be done during module loading time. 
> As a result, CPU compatibility check will be opportunistically moved to
> hardware_enable_nolock(), which doesn't take any argument.  Instead of passing
> 'opaque' around to hardware_enable_nolock() and hardware_enable_all(), just
> remove the unused 'opaque' argument from kvm_arch_check_processor_compat().
> "
> 
> With changelog updated:

Thanks, I'll adapt the simpler one.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

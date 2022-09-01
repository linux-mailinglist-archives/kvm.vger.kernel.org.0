Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844AF5A9E8D
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbiIASBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 14:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiIASBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 14:01:42 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EC66B8DD;
        Thu,  1 Sep 2022 11:01:41 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id x80so13508933pgx.0;
        Thu, 01 Sep 2022 11:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=MQnEtly0rT5VEW/OKtfv9DWInMChBOiwnjogwLslQfo=;
        b=SID8hHy2UJJEu1tLqX0wqWDisxK+FNS4UewHCbU69hfscwDpGerJ5vh5Quv4/0Gu4f
         snqkB20uSeyW0Qulg2AH0cjdxQiDONw/DS3jbILXr6ffBOM+1D2d2xa+ansXJk/lXAtb
         Q/8rQ4J1ySSSoc+6Ed+ukMs47k9pF4UQaYTgNi3PqDaaT2Gnj98U2LPYFw2tm7q53+H8
         PJdV0y7uAkIl0+Rs+ylbEJrtIzk1r9BDHQNvV+YFo1w31mjoActtwcimcvgxpvtt+MY9
         Z52uRPhJhD8CPzVWCN5GyYEIFR5CuIkEkY3IT9jsCVL2nV/vfI1d1JMsi/iHr32UCieO
         kQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=MQnEtly0rT5VEW/OKtfv9DWInMChBOiwnjogwLslQfo=;
        b=dKOMxRpokWC1yC7ScOU0l1MLeXA24BHxn4IKr3trFQN2biuRS4V+3NfGVO6XCkvjI4
         mkHbgUtEvFG3qgXYlQY56aO5COQEaXxWG0purqHrmIryiOgtFQOW7h2sPI62cyCLiFTi
         S/5q8pW7e1ftQizJpe+GvAVrvfilglqvaC5NkPF9MxnbLER8GvkhBxRaVXIZ5C5K9lvD
         wJCXZzWDOxWwoWy6YjljTgQLbaPsUGO5mGWRHboIj4viJ8waW16wHUrD5fm1d0FUv5DM
         4eseYNya3M2s0Azs+/4QoiEooCMbZQCTLeeOa3Vkyn4yPiS67J6BfPBLUd3yXk/9Ru7o
         4EMw==
X-Gm-Message-State: ACgBeo184uJn4lSr4riBE0Xzs0QZo4U4+x5lmNQckAAoZdyNyfZlDhHX
        dTblwGOqELxZkm+GtpNGVSo=
X-Google-Smtp-Source: AA6agR4pI77Z8xR/ZQwidTCnDkAeLZVo9Vna0UXdOf9J0ty6rz59XjPLV25jnRxNCgGKdBZ4y3NrpA==
X-Received: by 2002:a05:6a00:850:b0:52e:d1c1:df48 with SMTP id q16-20020a056a00085000b0052ed1c1df48mr32013994pfk.75.1662055300606;
        Thu, 01 Sep 2022 11:01:40 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id x10-20020aa7956a000000b005387bf85ea0sm6480993pfq.128.2022.09.01.11.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 11:01:39 -0700 (PDT)
Date:   Thu, 1 Sep 2022 11:01:37 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>
Subject: Re: [PATCH v2 04/19] Partially revert "KVM: Pass kvm_init()'s opaque
 param to additional arch funcs"
Message-ID: <20220901180137.GI2711697@ls.amr.corp.intel.com>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
 <7f4a3ef13cc4b22aa77e8c5022e1710fd4189eff.1661860550.git.isaku.yamahata@intel.com>
 <7f3003465bc8e7a75d7e27a0928271210c5e2323.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7f3003465bc8e7a75d7e27a0928271210c5e2323.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 10:39:48PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Tue, 2022-08-30 at 05:01 -0700, isaku.yamahata@intel.com wrote:
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
> > arch-specific initialization for the first VM creation, and disables
> > hardware (in x86, disable VMX on all CPUs) for last VM destruction.
> > 
> > To support TDX, hardware_enable_all() will be done during module loading
> > time.  As a result, CPU compatibility check will be opportunistically moved
> > to hardware_enable_nolock(), which doesn't take any argument.  Instead of
> > passing 'opaque' around to hardware_enable_nolock() and
> > hardware_enable_all(), just remove the unused 'opaque' argument from
> > kvm_arch_check_processor_compat().
> 
> This patch now is not part of TDX's series, so it doesn't make a lot sense to
> put the last two paragraphs here (because the purpose is different).  I think
> you can just use Chao's original patch.

Ok.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

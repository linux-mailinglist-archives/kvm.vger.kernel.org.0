Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CBD4F8E6E
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 08:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbiDHDnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 23:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiDHDnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 23:43:02 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884B062FC;
        Thu,  7 Apr 2022 20:41:00 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a42so771260pfx.7;
        Thu, 07 Apr 2022 20:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=pQ3qKw1cpdTuOMnW8XO0UfWbxnBpZP9Z51yPQ0+S3vY=;
        b=GGcaLejhCvGkmYGBsgqOlr+R3ISka7TvB4jP38j5hLaFAcT7YkqDoHMOARChyvBQYt
         DL7NilLdv8DRTxKGru5U2TJVLFYf0/jP72Fe6QwbyInIH1VoEO4mvgl64UpQZaVVQrRH
         NI/JPzi8pbmf+KfexS1wkr0ngWgLTXMdFr0MO6jWRd//iuOLfq+FTw5kLxK9tim+amQy
         S+EHNI+sfKfts0cYncgLgZ4fbUXMg/Im2eMpfhrMI8zX1VsCcGLyOzEkeYIdg9ks+1Uy
         l3B778jgfUe1wab3vi4bhYJxLy0U6OIgh5Y/B8Q/2wql1/i4wK3xvQzK9spMwmaFrTOS
         J8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pQ3qKw1cpdTuOMnW8XO0UfWbxnBpZP9Z51yPQ0+S3vY=;
        b=WUOAKcd4+6YWLp59bhfdwb5HYP7mrGZD7t+bFVF+UisBDwRo9I0iC8binappnaETVP
         icx6kIzYKAxJvvy/G4sR5YkXYusLl+IrQ1PkhqPnt08jTNeA4cEx9g8E6TtwCy16wxEm
         ZS7JUZS2xaArOpRvfx+navvPaGKP9aQxs0LlDQLyVA8l78O1yOjFU86xtHkQmQNGIFrV
         aZCe7RfCstU3VznImnVK9J1vvRwnXhOd6HirUD4rR3AiHH8yfpT2p68dC05A/fxCFehX
         nFum+WP2EC6fdmUNThOtzSCp0557y3lOhAyZwW/lZDipImUnLFrLn6L3u37b5oH52J3k
         OKDQ==
X-Gm-Message-State: AOAM533TfywXj0DAQj/haCxIiByOwmj/zP/bbwPfFix0DflIaFWo+WVi
        gXl7q8uSM2ZKVe9bBDkfRK4=
X-Google-Smtp-Source: ABdhPJwhP+StSSvSxGPf9hAiBTRLKCFOMkQ8dbykesgYA/aPcvuwS59sMQwpQiqjPjoT8a0nLpTT2w==
X-Received: by 2002:a05:6a00:c8d:b0:505:6f48:8434 with SMTP id a13-20020a056a000c8d00b005056f488434mr4445866pfv.47.1649389259869;
        Thu, 07 Apr 2022 20:40:59 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id m13-20020a62a20d000000b004fe0ce6d7a1sm15006630pff.193.2022.04.07.20.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 20:40:59 -0700 (PDT)
Date:   Thu, 7 Apr 2022 20:40:58 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v5 101/104] KVM: TDX: Silently ignore INIT/SIPI
Message-ID: <20220408034058.GG2864606@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <d0eb8fa53e782a244397168df856f9f904e4d1cd.1646422845.git.isaku.yamahata@intel.com>
 <efbe06a7-3624-2a5a-c1c4-be86f63951e3@redhat.com>
 <48ab3a81-a353-e6ee-7718-69c260c9ea17@intel.com>
 <f13f2736-626a-267b-db38-70a81872a325@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f13f2736-626a-267b-db38-70a81872a325@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022 at 02:12:28PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 4/7/22 13:09, Xiaoyao Li wrote:
> > On 4/5/2022 11:48 PM, Paolo Bonzini wrote:
> > > On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> > > > +        if (kvm_init_sipi_unsupported(vcpu->kvm))
> > > > +            /*
> > > > +             * TDX doesn't support INIT.  Ignore INIT event.  In the
> > > > +             * case of SIPI, the callback of
> > > > +             * vcpu_deliver_sipi_vector ignores it.
> > > > +             */
> > > >               vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > > > -        else
> > > > -            vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
> > > > +        else {
> > > > +            kvm_vcpu_reset(vcpu, true);
> > > > +            if (kvm_vcpu_is_bsp(apic->vcpu))
> > > > +                vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > > > +            else
> > > > +                vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
> > > > +        }
> > > 
> > > Should you check vcpu->arch.guest_state_protected instead of
> > > special-casing TDX?
> > 
> > We cannot use vcpu->arch.guest_state_protected because TDX supports
> > debug TD, of which the states are not protected.
> > 
> > At least we need another flag, I think.
> 
> Let's add .deliver_init to the kvm_x86_ops then.

Will do.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

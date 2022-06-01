Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10A953AFA7
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 00:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiFAUwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 16:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiFAUv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 16:51:57 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161F11F62E8;
        Wed,  1 Jun 2022 13:50:08 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id i1so2823413plg.7;
        Wed, 01 Jun 2022 13:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x7SiiXtdSg/AZep1wp9+274XMIvkQ8QgBS061aeEDxQ=;
        b=JXFXO1zcpCArlFcjqNamEdZhPBE8QTNRw27l06VnUJHEEDQps6Dm5772r/lpF0AViL
         jUbMJSgInhoF8fdb/a8PpMX2AzWPXUUTWwzfc1Vo7fUK2iEBMlff4y+uaKtgXPiktz19
         oqidqUJXRRsjmYEItFn7PFBxGcdwixIshv5AUWk2LPAZkEDVGJ+1/QdNh/A5PLeVLbc6
         zrscESu8MJg4nKMF09oG0jnTFF3YisTl/GlUiL5dcaWeTR3WWSTpy1035Irsm5q9yE2U
         KOFOMCCfIXU9hzRSEjr/NKMZEfJ8TUaaW2u1WwbU7zoAV0JMypXlk/S+t4hEOUG7eKv2
         k1bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x7SiiXtdSg/AZep1wp9+274XMIvkQ8QgBS061aeEDxQ=;
        b=yTHK0Vez0ccqn3fB/u7WlHV7aT0x9Rkx5AmXfwxHJrOlkwWNJelNdG/etxVfOA5JRX
         Fv0A/ZgWf9s/OZlAoaG7W9NVTRSSv5JAi/lFIqOJodUUy3fOhC8XMs5ONp38p7deUrYN
         woyob9QIylvob/tyzTzXDK5bL1pYUIByU0SGNXayeJgD97on1yT0N7pl3xXMmD4F3fdk
         Ki8w0BUvz6G4uITmYh7GlyHmo4RcMJhunhIs6JLJ1PE2+cyLJrhunf8AbPmXuPJGfGVh
         snLBLcf94uAqsQ9kBsfoC+SNRkNiZGR1zOyJO8lEMXu/nG5m+zzHvkHJGiPEfHYboR0H
         kynA==
X-Gm-Message-State: AOAM532xfZW/2w52rdoo4DMgeL5YFBhyZLmKqMg2aM5kUkG4SjTZaQMt
        QQpDdVUcuvF9MKXuTxGZuM8=
X-Google-Smtp-Source: ABdhPJxyTTuuXdD/q5pDCy2KsYSVPL56X/GtjdP/ks02YUxwpPJ7cluqWsvbCueM/5ocijXtgwPtoQ==
X-Received: by 2002:a17:902:d5d2:b0:161:f03a:eb41 with SMTP id g18-20020a170902d5d200b00161f03aeb41mr1256063plh.65.1654116606735;
        Wed, 01 Jun 2022 13:50:06 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id h2-20020a635742000000b003db580384d6sm1739544pgm.60.2022.06.01.13.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 13:50:06 -0700 (PDT)
Date:   Wed, 1 Jun 2022 13:50:05 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [RFC PATCH v6 064/104] KVM: TDX: Add helper assembly function to
 TDX vcpu
Message-ID: <20220601205005.GB3778155@ls.amr.corp.intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <f40b7827026d65963fea84d4af78cb1cbca85149.1651774250.git.isaku.yamahata@intel.com>
 <bf76a63c-c687-34bf-4c46-ecc9cea575eb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bf76a63c-c687-34bf-4c46-ecc9cea575eb@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 31, 2022 at 05:58:39PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 5/5/22 20:14, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX defines an API to run TDX vcpu with its own ABI.  Define an assembly
> > helper function to run TDX vcpu to hide the special ABI so that C code can
> > call it with function call ABI.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> "ret" needs to be "RET" to support SLS mitigation.

Thanks for pointing it out. As it's fixed in github repo. will be fixed on the
next series.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

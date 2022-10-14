Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B645FF225
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 18:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiJNQSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 12:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiJNQSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 12:18:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100731D1A98
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 09:18:43 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id cl1so5247749pjb.1
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 09:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+rwJcZoSLzvl752vkHgduerXDWCkM/4mG6DevuxAJqE=;
        b=l5pISY4h/0axbk5ZlTO3f813qzqj32KnqvRQ54dWUsSoA+SemH1xuWAwHrzj6lXVwI
         +abjmKUPlJqAamfLotZPI8NcURaQf39edYJVsQfdflV5Z3DaZPhOvcMjANNRaMeBbV1w
         L/4xrC0T4+TkbRa9+6lCwDc8APXjM9+s6LJ+N8pU+ZZcOezthQwO3d+Ek/YSl/khArIj
         2nhhAhwjZncUZIdlSirBnXAIXqPjphcTgd+i+wsu7/2M17hYTDaMZKNt1rODJlghzK0V
         cZsOhCOrJ/BOOGKlGQ65XEBybEb5vqiIc+84ktLwvm4oNC0JFXq1Y6806SkGsPo/eQgO
         UBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+rwJcZoSLzvl752vkHgduerXDWCkM/4mG6DevuxAJqE=;
        b=yMOSjKvIijsa1NkRObL9fsuXJVAUfmXnTrSKKF0JCmP2GlsFr5tA6vHoFO3RnJ3Gey
         RwGp6sbYGNfzkmfJ6iE4h/Hl/LA5oSlqn0+CUBIHGDe1Shw4D4Fjr9OSvW/UvN4tjUam
         93ZfvdddkReqr43g6ZoV8HlFWEvwNGvhRmcNhdgypqB3Wx2TrKzFBooNGf3Uz8kl+Q6W
         2BfSl1OohZ8suXQkcX7+DsUQVTAaAPLprPevPGmc1hcIZWJfUZ2GaZksMV+M0GMHgWHd
         IbK24LI6IdFNcxhiyK9+EZ2gU9TNcZzRGA5T0Uk9LiWPhpxcvwR53+hACiG8gXkpymBO
         X/bw==
X-Gm-Message-State: ACrzQf3891k/C3OuTpCfk0wvCd5EVxoufuvszuEPCURxf03kb3gjHBk6
        /5l7fPwGdjaYPGv+GxUMat/IYA==
X-Google-Smtp-Source: AMsMyM6DK2yegrD7Ey8OJYMpHuYOFpe2OPIYXQzZmB5sLGabFf50HN50ug8cQlrd1iXwmE6G+bpfYw==
X-Received: by 2002:a17:902:ea10:b0:185:41c2:a71e with SMTP id s16-20020a170902ea1000b0018541c2a71emr4508232plg.21.1665764322401;
        Fri, 14 Oct 2022 09:18:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id nn12-20020a17090b38cc00b0020d9c2f6c39sm3899009pjb.34.2022.10.14.09.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 09:18:41 -0700 (PDT)
Date:   Fri, 14 Oct 2022 16:18:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v3 1/3] KVM: x86/pmu: Stop adding speculative Intel GP
 PMCs that don't exist yet
Message-ID: <Y0mL3g2Eamp4bMHD@google.com>
References: <20220919091008.60695-1-likexu@tencent.com>
 <Y0CAHch5UR2Lp0tU@google.com>
 <a90c28df-eb54-f20a-13a5-9ee4172f870e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a90c28df-eb54-f20a-13a5-9ee4172f870e@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022, Like Xu wrote:
> On 8/10/2022 3:38 am, Sean Christopherson wrote:
> > Does this need Cc:stable@vger.kernel.org?  Or is this benign enough that we don't
> > care?
> 
> Considering stable kernel may access IA32_OVERCLOCKING_STATUS as well,
> cc stable list helps to remove the illusion of pmu msr scope for stable tree
> maintainers.

Is that a "yes, this should be Cc'd stable" or "no, don't bother"?

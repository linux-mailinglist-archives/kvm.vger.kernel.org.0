Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD6455A4FC
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 01:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiFXXnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 19:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiFXXnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 19:43:12 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D7025285
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 16:43:11 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id bo5so3819467pfb.4
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 16:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9N529bIxDfr9XbpXlA0R0zIti7KU9RJXWvcDazd0Qjo=;
        b=ieCervRftYNQfOUPtqT6hkOOGrCZWyg3vQ5GhHz/U5JRmO/HItGhZrHA6OzmQXBdC0
         Ac9IkEd+msyAwmXtPJ6rWTEhyrkpQKpX2sw+nhor48+P6b+gbuTyTCBkNz8fRHm1Scf3
         24MMnlrjJ5MG3ZOvwEDY/kzIzZWmZc8fs1lWaAVVFm3CycNcjn8aXd2LiF96Iq0BJS+A
         U8KnJyNRYjEvdnfA9xErA51o5+rLSbZzhXkKWbhE/fSd89onwZY4LPXVknYAr9Do5Ejm
         TFT9GRZdhoTlRWMjGT6qTGPYrwIMBA7P39BUfl31Loxw27SAkFmJOhERxv78X/DVChue
         73Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9N529bIxDfr9XbpXlA0R0zIti7KU9RJXWvcDazd0Qjo=;
        b=dzBMeA3/m9TxFotehClWe/W8v1IFaaionj+U/iB0pZJ+jj4WalSOfEs0gIby8pJh+/
         cKhmJY6y0CWWvF1CT8Xnn6Uhtc5UILbWSjE5jYlZvvkVoMaY2fxEmiWgB9PDC24bZIN2
         I2Ny9SJBGdNjns2IvpVPBILUOd17Lfjvfiu5ZBjhTxuTP4NnAt8UpbOAB0thSUaC+Xug
         9ru2t9C3hAZE2ibi5wGKv9sM/uZz1Srk8+C5saHsE1CjuXYyEUw0/wGY2vNXTt4xPWyY
         ZUSLl8Ux+qNTKvrxqOicS9zRopiP9PvtlPD08UV55nKCaw4Iu2v8ve9ufQbpWofWm4Sf
         yy6A==
X-Gm-Message-State: AJIora+UAYr9kUsKsU0dWbZyl6EljQrk0LsDjL42SOj3qgfUgryktx0s
        xyoVMC+0HkSUH0SSHygLZ1f9dQ==
X-Google-Smtp-Source: AGRyM1tEVk6ipro476mDieO78m8ow5umUhkMSny5j044gxk6q2M6B9oRJCAVDDNl/5pl4UtR/hw50w==
X-Received: by 2002:a62:e919:0:b0:51e:7b6e:5a3b with SMTP id j25-20020a62e919000000b0051e7b6e5a3bmr1377529pfh.78.1656114191098;
        Fri, 24 Jun 2022 16:43:11 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902d40500b0016a13bd845csm2347656ple.165.2022.06.24.16.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 16:43:09 -0700 (PDT)
Date:   Fri, 24 Jun 2022 23:43:04 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] KVM: x86/mmu: Expand quadrant comment for
 PG_LEVEL_4K shadow pages
Message-ID: <YrZMCO9V97KD58xV@google.com>
References: <20220624213039.2872507-1-seanjc@google.com>
 <20220624213039.2872507-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624213039.2872507-3-seanjc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 09:30:37PM +0000, Sean Christopherson wrote:
> Tweak the comment above the computation of the quadrant for PG_LEVEL_4K
> shadow pages to explicitly call out how and why KVM uses role.quadrant to
> consume gPTE bits.
> 
> Opportunistically wrap an unnecessarily long line.
> 
> No functional change intended.
> 
> Link: https://lore.kernel.org/all/YqvWvBv27fYzOFdE@google.com
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

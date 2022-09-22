Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD895E6FB5
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 00:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiIVW35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 18:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiIVW3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 18:29:55 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4356D5E556
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 15:29:54 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id bh13so10579997pgb.4
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 15:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Hq4VzhV1vFCPluUxov2hJ8h9q9nLgfZQccQ5ZzRz8nU=;
        b=s/iuJhWGle8z5leFKaQiBQmVbxHdv7MgGUyBM7mtqKQVjziEeSvXwL7xdx6JR714Ax
         TQJUvv18XkiRrKHSsMgR50TK1axlClW3be6xrnoRRzmFuFt2ExbMio27saM9z4sB+7Lh
         ZQRtPkjUyodiv/lDXf1cMu2Ub7v8iAAgEFnc8v5ESHO1yQT2DIPXnICGXuLPfHL2x5Mq
         rc5nLvE3wDgTKDXWPIX9RkASsSEvWoNCWHEsykeMFuaYnLu5F/CP1V8MH43sNst9Mbn6
         0fK3PWDKDvAWL6EcOwGE0tWa/BTcZ/zpmYXt+kWmXOx1m+fUokHB33zTP75PEvIebzEq
         ZiUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Hq4VzhV1vFCPluUxov2hJ8h9q9nLgfZQccQ5ZzRz8nU=;
        b=Dx18d7TiwfiUoZvAgf5H0VBlEYPvWCOFZVr2cFG/rW+m6qRLNgdc4ZYNR48r5T8cYa
         vQAmqwu9TgE2szF8n7ppAX9Q6qg8AUX4IJmAY8go8yXdgjZKskIhyw0vP69JyMU2NK4e
         aN5WQt5XH4J7+ZVAT/XhDAEbjLg8UQRNqMnI6FRn+wLX6FeSxZLS8srQKP9EXj81qWAq
         7qVZUbDQmwnpnHR/2BbGa3WrGztjBmTodGWkbkAlvQarU88NCxCWz6ecqX1FvQG/iZDU
         DgabhuHzIV+0sGh02P0LFhKfc5utMf9zs3cNJA3HwaxDFbnUKrrDMwgZroVDvGr1iRRF
         T2HA==
X-Gm-Message-State: ACrzQf2yBz2eYvGb8xQkQSHyer1g/tpCBi1z9u1CG5gbOEU50DzcUtjZ
        dVG2TO6q/2+Spq5YDFrucSXHlQ==
X-Google-Smtp-Source: AMsMyM7aVDrzLB/Eho3X+Yq41oanBi1Ibx/BwEPkvcT8tylbO+g7Gb/I1duiYRxM3hUFBKPNvT+IHg==
X-Received: by 2002:a62:fb18:0:b0:548:9dff:89da with SMTP id x24-20020a62fb18000000b005489dff89damr5698921pfm.23.1663885793547;
        Thu, 22 Sep 2022 15:29:53 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902654400b001754e086eb3sm4604986pln.302.2022.09.22.15.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 15:29:53 -0700 (PDT)
Date:   Thu, 22 Sep 2022 22:29:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] x86/pmu: Corner cases fixes and optimization
Message-ID: <Yyzh3VD+Gji8t9OO@google.com>
References: <20220831085328.45489-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831085328.45489-1-likexu@tencent.com>
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

On Wed, Aug 31, 2022, Like Xu wrote:
> Like Xu (7):
>   KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
>   KVM: x86/pmu: Don't generate PEBS records for emulated instructions
>   KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
>   KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
>   KVM: x86/pmu: Defer counter emulated overflow via pmc->prev_counter
>   KVM: x86/svm/pmu: Direct access pmu->gp_counter[] to implement
>     amd_*_to_pmc()
>   KVM: x86/svm/pmu: Rewrite get_gp_pmc_amd() for more counters
>     scalability

With a few tweaks (will respond to individual patches), pushed everything except
the "Defer" patches to to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

Unless you hear otherwise, it will make its way to kvm/queue "soon".

Regarding the "defer" patches, your patches are ok (with one or two tweaks), but
there are existing bugs that I believe will interact poorly with using reprogram_pmi
more agressively.  Nothing major, but I'd prefer to get everything squared away
before merging, and definitely want your input on my proposed fixes.  I'll post
the patches shortly.

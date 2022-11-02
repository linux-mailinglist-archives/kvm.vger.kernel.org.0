Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1884C616B14
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiKBRmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiKBRmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:42:20 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F192DE
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:42:20 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id p21so13393377plr.7
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RLpnbjRbYQuYAhYvQNMRmQrvVc2jXOuheCFqr0mOlbM=;
        b=UeV5sbcgU4uAtPVk8PB3sPsNxlnUalhKl8YPSy5ieaJ40v2v/jfVW4ViSe/owTZSuu
         iYNvlCl9LEEkuz0oYaTLg9EEo4YHgjgawe3vieeZ8HjUDyttJaKIbjQ4aFmfAPdCwTio
         3X7G8tgCluL+LpytPA9HwASZM9sI8MNNKYOtGW+4i0wwzzHcOu3soI3R+rJlE5zbHLwF
         SSxCKqa2jMhGv5dwkub7vjRjiaAgMRuOSCrnmFe2nJLE4q3Os+bfgDxQ5eXEUsuBjsau
         0X7T0kXyqepv5N6NDYrp6TTJ74DwgAz1PY0HsZqoHM/66YZ6QCGfdVb4FlyXBKiJv8sB
         9TmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RLpnbjRbYQuYAhYvQNMRmQrvVc2jXOuheCFqr0mOlbM=;
        b=AbEFfMy44Lny4DlIj1U26kIrnk34GmqolINetRBs8EVp+2nOGHBOJLj77sNjdPzNhx
         tha3XR9kshMHbz9z3p2Yh10FGInO7o9lHcsAjdz06Oi3ODgj6F1U9KS6Z0Mgw14Nn4vn
         qO20TRLlbQ78G508SeCWEmb3/z3aufYDgMPGs03gXURQiKoTdbjXWVgLKLaGTWL+3/LT
         170jPcRZ5Jj/wnR1p7M4iNLqEd8VazVqD+PFxBagLsLZ2BwohQVac8DpyMZ+ZdPnnuEG
         JsIue76yMYY9RY1Ilw27gnJ7MWvpfLOsz5ucF4HvKoUM0vbPxas95E7dU245DcVHAoqq
         /1pA==
X-Gm-Message-State: ACrzQf0x1Uhwr9acmOVBfWVvC5ETs8JSJyPK9WUoS6nJdmq3pT5aJDAd
        EHTNv245yXjwgg235QKnoLbwLHbbWyk9rQ==
X-Google-Smtp-Source: AMsMyM6Xo7I8nvz6OvahC771tbl10C0vJJgWjt14TIhHIyrZr0y4DAKHnSKHdfXOLw3kNxkoAkYtpA==
X-Received: by 2002:a17:902:f651:b0:184:6925:d127 with SMTP id m17-20020a170902f65100b001846925d127mr25751819plg.140.1667410939780;
        Wed, 02 Nov 2022 10:42:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e18-20020a17090301d200b00172cb8b97a8sm8729946plh.5.2022.11.02.10.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 10:42:19 -0700 (PDT)
Date:   Wed, 2 Nov 2022 17:42:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 11/24] x86/pmu: Update rdpmc testcase
 to cover #GP path
Message-ID: <Y2Kr+AFgMI1aCvpt@google.com>
References: <20221024091223.42631-1-likexu@tencent.com>
 <20221024091223.42631-12-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024091223.42631-12-likexu@tencent.com>
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

On Mon, Oct 24, 2022, Like Xu wrote:
> +	assert_msg(!vector, "Unexpected %s on RDPMC(%d)",
> +			exception_mnemonic(vector), index);

Alignment is slightly off.

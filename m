Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFC56AE6C9
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 17:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjCGQhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 11:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCGQfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 11:35:47 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D72650F9E
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 08:34:27 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-536af432ee5so255640557b3.0
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 08:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678206863;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jvy9w3/ryl+HeOiWnr51O81EEv//kB8rMScsDmnxcVI=;
        b=nHQRzgSxT/F3jYeyWfizGLaZZb4WMNxMfddgFeYAE9wd0gfi784f1U4vIWL62Y4vYQ
         jZzm9V7a7rsykrc1ucRZdzMaztKoZgAP3QOsYGvNhZW78NMRxWFDj9zka8tpx2PbKFtK
         nXWKnkcT/98rA3QSVqoAQAZn7qfZ1/qQUsER+wsBsPlDvX4nr8B31SNjwJ7q9V+Md6Se
         Pxj2H+jV579lIQNBLuY7ZaV6YglxQseENH7afBNzesYujhbmTsGetmkFetbrRKtd3ee7
         CYfAQ/OM0Helv+z2R7KWkPO212PMlWxdobaAtdzrJGGgSYvZhEXlix/aMUnPc7iVnbW9
         2mTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678206863;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jvy9w3/ryl+HeOiWnr51O81EEv//kB8rMScsDmnxcVI=;
        b=pTZGE6s852rS94n7cnEXILHoIkE9qGc+vb+xEpHkm155AIQ2WMVH+qi5Q4/1kOSuS7
         Z9yfTHtewGOZLH8BMuiOGaTEtyl0xwo42hdaTOBfIEGfQiC4LZ+vAcm1oYuP4BXHb9B6
         ukhvCdyG1w44JmkzNGMb5/KGQpPPbUwbJfbILjY6RhejOdJ/Nol8HvJqpM6vJqypOVvo
         DOm89R7H3vWhZtib1tf6F0HyDQiEl0bTTGsJ+foyKCKA8x1NXudLBTQ08BUJe/ibAXtp
         J0M8X5VeY5QNY26YvHWuveRqgYLH7MHihs1xRiGwg+60Rk8CiXH+f8CgLLDC5x07rhm4
         btcQ==
X-Gm-Message-State: AO0yUKVJwrEbQo8ct52v70mvuhrDcORzN2w8D+QdpT+CUo9odPb90oxX
        rOrVXOEssYTPcMKhsC797YtEzTKZouZHXl0iHAa2qg==
X-Google-Smtp-Source: AK7set+3Ae82E2oyDdBQvhCz8/W7lre94tpExRQKqu9Vvxb+ihPyjwxLWLNbdGRIiQaD2wFxSmRMuuDIRDrGASsf/IU=
X-Received: by 2002:a81:b704:0:b0:53c:7047:14c4 with SMTP id
 v4-20020a81b704000000b0053c704714c4mr9200209ywh.8.1678206863562; Tue, 07 Mar
 2023 08:34:23 -0800 (PST)
MIME-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-8-aaronlewis@google.com> <ZAJjoiZopqIXDoDc@google.com>
 <CAAAPnDGjNjWczonLU1NNv4zk8865bpGB=Df-W-r4Wy=qi1--CA@mail.gmail.com>
In-Reply-To: <CAAAPnDGjNjWczonLU1NNv4zk8865bpGB=Df-W-r4Wy=qi1--CA@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 7 Mar 2023 08:33:47 -0800
Message-ID: <CAL715WJNPiX7_8Kv1wC-Yd3GQjd_xJ7opF_QP1ezfcbcYORVTA@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] KVM: selftests: Add XFEATURE masks to common code
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
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

> > Can I take your commit into my series? This seems to be closely related
> > with amx_test itself without much relationship with the xcr0 test.
> > Thoughts?
>
> Yes, please do.  I still need to have it here to have access to the
> common xfeatures.

hmm, you are right. Then, this series should go before the selftest series.

Thanks.
-Mingwei

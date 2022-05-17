Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B8052A93A
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 19:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351486AbiEQR1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 13:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351502AbiEQR1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 13:27:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B500230566
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 10:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652808461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KKq680AnszBszJpoGIG9251C41AK5g6xGWKr2ftGslI=;
        b=YCWK0UhQ5kWWTjHmTOiUEeBVBIHrjQF5cVVzQ46k/knYq3W8R+agO+n3YPAsqU4mzDdmIY
        GZ6nlalvafk08bWkv5t7Gyyp7AW4FS+fJI2hrOVUkxqJkmXrpfzkvOSd3o9/FeinuKipTO
        n/ZUmRffjGQ/fq+PQuYyVU2caAsZAhE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-x6rLiu3dO0W_zJIYI_kcWg-1; Tue, 17 May 2022 13:27:40 -0400
X-MC-Unique: x6rLiu3dO0W_zJIYI_kcWg-1
Received: by mail-ed1-f71.google.com with SMTP id f20-20020a50d554000000b0042abba35e60so3224390edj.15
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 10:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KKq680AnszBszJpoGIG9251C41AK5g6xGWKr2ftGslI=;
        b=vD5cyP8vowTv99tGHmhkXW79OWhPK/2DY181sAtBiEBsn/cKJY8ZNIg9rqDar6dqgi
         0mAABAZY0981OheeGIRVXF0bpFYKFZetG56UkEPyBiqhW8uoIDFs/1ob3dmTNkY9NzzC
         7EE+OwkgoyLbfd1YJRqbSiEIm/2IYYuVM+sw29sUoTSAAyp5MwxbMjsnlcJGTkh1vtpO
         eaX50j55qqn2DVfdcvcPAYU5ZdSbOY5x1Yxu2PPd3ve614fGpq/pPEIvEJFE9Tv34+Rk
         CAorK/qQffClbnGIXlFRqIhc8sOYPdF24nvQo7cofeFxdtv7dUDbwWJrbhUS96fsBfvx
         eFXA==
X-Gm-Message-State: AOAM530F1yg2iHsedHR56K82NllBfxbjMCEBVWTWS7/56hWwu6ldARkk
        l8f2GCT8MXrwV1auNuDO8eyRI9KFQuSnq1SYeuZX5QtnxcNoi9g/19DbxeFjBovkcUNpiiXaZwe
        ZusFJ5j9s+/dK
X-Received: by 2002:aa7:cd87:0:b0:427:f800:220d with SMTP id x7-20020aa7cd87000000b00427f800220dmr20576157edv.112.1652808459177;
        Tue, 17 May 2022 10:27:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxC3PVDHfL41xd+PMS921zEyYofQiMDC6L+gf8Y0ZLX22T50TYUkDJEchPjpPGtx0JkS++qnA==
X-Received: by 2002:aa7:cd87:0:b0:427:f800:220d with SMTP id x7-20020aa7cd87000000b00427f800220dmr20576144edv.112.1652808459006;
        Tue, 17 May 2022 10:27:39 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id u2-20020aa7db82000000b0042617ba63a7sm7196571edt.49.2022.05.17.10.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 10:27:38 -0700 (PDT)
Message-ID: <64895c87-743f-191d-b28e-dc8f17508773@redhat.com>
Date:   Tue, 17 May 2022 19:27:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.18, take #3
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oupton@google.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
References: <20220516125151.955808-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220516125151.955808-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/16/22 14:51, Marc Zyngier wrote:
> Paolo,
> 
> Here's the third (and hopefully final) set of fixes for 5.18. Two
> rather simple patches: one addressing a userspace-visible change in
> behaviour with GICv3, and a fix for pKVM in combination with CPUs
> affected by Spectre-v3a.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 85ea6b1ec915c9dd90caf3674b203999d8c7e062:
> 
>    KVM: arm64: Inject exception on out-of-IPA-range translation fault (2022-04-27 23:02:23 +0100)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.18-3
> 
> for you to fetch changes up to 2e40316753ee552fb598e8da8ca0d20a04e67453:
> 
>    KVM: arm64: Don't hypercall before EL2 init (2022-05-15 12:14:14 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.18, take #3
> 
> - Correctly expose GICv3 support even if no irqchip is created
>    so that userspace doesn't observe it changing pointlessly
>    (fixing a regression with QEMU)
> 
> - Don't issue a hypercall to set the id-mapped vectors when
>    protected mode is enabled
> 
> ----------------------------------------------------------------
> Marc Zyngier (1):
>        KVM: arm64: vgic-v3: Consistently populate ID_AA64PFR0_EL1.GIC
> 
> Quentin Perret (1):
>        KVM: arm64: Don't hypercall before EL2 init
> 
>   arch/arm64/kvm/arm.c      | 3 ++-
>   arch/arm64/kvm/sys_regs.c | 3 +--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 

Pulled, thanks.

Paolo


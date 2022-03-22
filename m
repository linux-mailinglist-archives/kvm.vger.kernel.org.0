Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9434E43F7
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 17:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238961AbiCVQNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 12:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbiCVQNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 12:13:21 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FBD29831
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 09:11:53 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j18so14478082wrd.6
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 09:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=NkUM/U0D3JQUxbDA0GNXJr81JNXeEBFHHY9Bfm+t3hhkkLzmmtwo0FQJWhea/ytF1C
         ZVZ1jIDq+WIRgnMEvXoNYYGdLlmqimlkims4Z9dAD5WgB4ti61Jv4KhW99JSTYC2kHnH
         Eep24qBdroP0Z+h5W6t8RsnoMxlDE+Uot4LJBsAx6aRnGJLRn1B8yEYnDn3CSsGvaVXD
         7brfLJYEdU3VFxAw2l6IG9JX7fF89ZrMT5nlsh9IC5Pv/QejaFLUwtwVoAhs0wchi5uh
         0fYidLXB9zZMSKd88npdRgeDUoMRpGVw6WeFPCac48dXDL75cfJ+s3nPVbxv6sIIRtqK
         D8+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=fv8l/T0q47nUBvSNr9cZzIllQmX6S3+Xt9B5EFePyjIlrpco1bUg9kFiHNVQo9gjos
         +FX/aOgPe+R/+XO9MA7qkKtkJLssjbxvC5v/YhSaTw1ACr8yqh1+mvyZM+HUZmlmhe2p
         yeKEYA7UjLpA2EJ3ELV7q7kEk2KcE5RSEql10Y5iUdR2d4p7eKQ8CdjffLtYOMB/Chme
         DUST87jLp15aVOnfDd4MUVHIxd8noGWVULASXDgeMuidBMiy4QS4reDydbSWv3qoJhwN
         sFYdVUMB3gNdfTr3AmQtYc4zxeAVLBzme0D1+pK5ExdIyVH1dDQFWV5LdLApfHv3PKZf
         0X1A==
X-Gm-Message-State: AOAM532i0YFeQ1qIHybonC/Tikkk5ZlsIDjdL7cPcV3O0SNG495KTzmd
        YHVY6MupJWN+imLzF/hZoZU=
X-Google-Smtp-Source: ABdhPJymWmXuECdO6We7BmwgG//r/VphLDizJaovvwQIdsSLyWnL8llg+G2pPkWGSD9zmK4zIbmpow==
X-Received: by 2002:adf:9794:0:b0:203:e074:1497 with SMTP id s20-20020adf9794000000b00203e0741497mr23704121wrb.75.1647965512254;
        Tue, 22 Mar 2022 09:11:52 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f8-20020a5d6648000000b00203e64e3637sm13850298wrw.89.2022.03.22.09.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 09:11:50 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Cc:     qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH-for-7.0 v4] target/i386/kvm: Free xsave_buf when destroying vCPU
Date:   Tue, 22 Mar 2022 17:11:45 +0100
Message-Id: <20220322161146.261513-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220322120522.26200-1-philippe.mathieu.daude@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A010278FF52
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 16:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242654AbjIAOjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 10:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbjIAOjG (ORCPT
        <rfc822;kvm+subscribe@vger.kernel.org>);
        Fri, 1 Sep 2023 10:39:06 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AF2B9
        for <kvm+subscribe@vger.kernel.org>; Fri,  1 Sep 2023 07:39:03 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3fef56f7223so19688035e9.3
        for <kvm+subscribe@vger.kernel.org>; Fri, 01 Sep 2023 07:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693579142; x=1694183942; darn=vger.kernel.org;
        h=content-transfer-encoding:from:to:content-language:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=HZVisYP9ggWLWMsCIIprQ2po30e1Qi2p5QBi97wcngFTMf6OK/9xh54VYv6xLzzsUw
         dkEqM2O7WlqnQeQH4w0742E1Y5uhu+YIV24UK41fn89tcpasjO9WeuI+m2UgYF+Hg/t4
         +T9VbT4BN9kl3Q7tMrRayG1IMqNqExmdW3RUwMDsTrSPONbyLoHJrkjUfmFxfEgdeabX
         lkg3rihgH2yBpUMHEmhEp+VrfBxhw0J7Ql6mpKnRShfwCuKDz8o1kYUaFa33GnZ+agDh
         j/t9Dm1Pe2o02o1hCd9ROQIDdZYRMQ6LYyiqA2szoox2JN0Ryu8ByUfiirEiWZ+QaxyZ
         Y0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693579142; x=1694183942;
        h=content-transfer-encoding:from:to:content-language:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=BqaXCbaq2K3BA2XkBg/9HZ8oVWOcNhZ9OjT6ygi+TFLQUpe3jSdtpNP0eRSDqlkdLZ
         C4C2RlV5ULSYtvneO+tCVWROcs3mUqZX6Dg2dVSGZgNDRcw2mAf52fNdoY90+WDhTSQ7
         R0h/yohN1jTiKicQQ+TDBUnV+qpBOgda6cAXoN0tEoHJdpFzvm0KpE5ckxAxLZRTSIFC
         +2rN+BNKvpOLGpOTSzNS+k4rJDkoUizHnR1uLNwYghIYdonGYHc4InD72erfL+tk0562
         3r8sPBfkNVXjdfU5k/EPbBFfYZhqtA36nIP+GzTu2KiaehQ4Xvu8ZcArn8q10KGj71oi
         7l3Q==
X-Gm-Message-State: AOJu0YyowoR5MvbCkWSOxa7hBs1HRS0/oaefNY5zpafZ85NBjAxLNayA
        d1FpF5emlS70l21CyaIcSxXF3xhSH1sIIxeH
X-Google-Smtp-Source: AGHT+IEPrdsHus2SzVxxkFzX4Do+TsCi/s2yH/ZffGX/p+J682mKoCjbdXd9Ahd96Z4xNhpIxT/MYw==
X-Received: by 2002:a05:600c:2283:b0:401:b53e:6c57 with SMTP id 3-20020a05600c228300b00401b53e6c57mr2100601wmf.9.1693579142163;
        Fri, 01 Sep 2023 07:39:02 -0700 (PDT)
Received: from [192.168.195.128] ([188.25.207.114])
        by smtp.gmail.com with ESMTPSA id f3-20020a7bc8c3000000b00401c595fcc7sm8239069wml.11.2023.09.01.07.39.01
        for <kvm+subscribe@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Sep 2023 07:39:01 -0700 (PDT)
Message-ID: <2f9eea61-6ccb-4ac9-baee-3f06bd98353c@gmail.com>
Date:   Fri, 1 Sep 2023 17:39:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     kvm+subscribe@vger.kernel.org
From:   =?UTF-8?Q?Sabin_R=C3=A2pan?= <sabin.rapan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,EMPTY_MESSAGE,FREEMAIL_FROM,
        MISSING_SUBJECT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



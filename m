Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F360211C95
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 09:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgGBHWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 03:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgGBHWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 03:22:31 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFA3C08C5C1
        for <kvm@vger.kernel.org>; Thu,  2 Jul 2020 00:22:31 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id u9so7345996pls.13
        for <kvm@vger.kernel.org>; Thu, 02 Jul 2020 00:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:message-id:date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=IM8OcCd1J5H5NYYxqt8/UURDJnjX3/PpwHj5eTTFHqg=;
        b=W7sHmyPPSar3CSpNQR/4NeCtkaSfl27pNE/cZ+/x0F0sHLePMCy+/PNJUV0S81Y7LX
         FI/jwfVAUX0M1vLEsJ+pqGMY2pUTvBXsxQzTXreSHhhnO+UQAq4MiFoFNPnAnz7PqBIt
         QwvjY/LYorePEwj0ccs7iMMRTLqbxQg6Avte9v2H3o7MY02uqeljVoFPRka+wJPafOWH
         rmCoxWqyG6Q+FjucOx3ffBkWKDyPy7f+WBeV/2lM1l50tNIHqXS4D8iV9pxcYW22y2zD
         fCoUp7pOhAycsQ/6TRCglRcHDRji0BvIxQOsiOgwXt+UXduQs1KTYgmTYY7TOzyCipvb
         2wkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=IM8OcCd1J5H5NYYxqt8/UURDJnjX3/PpwHj5eTTFHqg=;
        b=PE2vuQoSoq94eJROE8BBsTSt+SwcPJMgNIqgA1zHPzch26LjBC6a0SiUJhovoo8Czb
         Z4T3i8R9Nfa6CvsLkksKmVUGN1OkUGN4LRI9WLfFi6oIx+DV+ROEoG0EraF7T88Kem8I
         y87P/TH+dgH5s7hb7Htgl6niDnB6yvuA4D4kKAgRRVmWLdywJ2OGh1fk7Z12+9DaMfdJ
         y4NZQXfisWljHVFoJ1Ly1Cp8qOMDr8r8o0ysahtSgQYZCrkfmsszW+PqRIB4iy6xDWHz
         xQ0OthDHGaxgZ+R2AUHyCr5WnL2KtMzX3asOcMeVMlRNlSJa50AyWJhV7Ob7fvoINjy+
         5CmQ==
X-Gm-Message-State: AOAM531dknFMnnfkayYEVKDlunKKNYzuXN3zzcqbmHuTAh+je2o9N6Fa
        K36WnFvu9/d49iUHTD2F77Hsamxz
X-Google-Smtp-Source: ABdhPJzLD8QR1SigGGBKuLAlbi/BTYhBFXYx9uWwyv3gjH+HtufiW5WBxnJHGkPkqBnhW8GhexheAA==
X-Received: by 2002:a17:902:8681:: with SMTP id g1mr24976069plo.161.1593674550840;
        Thu, 02 Jul 2020 00:22:30 -0700 (PDT)
Received: from JAVRIS.in.ibm.com ([49.206.9.181])
        by smtp.gmail.com with ESMTPSA id x7sm8226960pfp.96.2020.07.02.00.22.29
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 00:22:30 -0700 (PDT)
To:     kvm@vger.kernel.org
From:   Kamalesh Babulal <kamalesh.babulal@gmail.com>
Message-ID: <3fe827ba-b665-6372-f6af-95d6c1f0d739@gmail.com>
Date:   Thu, 2 Jul 2020 12:52:27 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Subscribe

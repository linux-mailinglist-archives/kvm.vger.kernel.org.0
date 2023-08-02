Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC1B76C16C
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 02:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjHBAT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 20:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjHBATZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 20:19:25 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEDE2115
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 17:19:24 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-583b256faf5so6616267b3.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 17:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690935563; x=1691540363;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jiCX9Q8KQzCFHIlN9fUWjnIbzXZVmYqy+m4ur8MULw4=;
        b=raM3TQYxoc69K4q3TwZQkpULsmtzajVV+TpSg0H45LM07mdSFdn6l7+fbA7qJVLXMU
         wp2EUU7ABIdxIVAlfwNtHZ50lJy/uu8c/xxyGfnMDPHVLAOwWRjspZVnsR9NAxk20Dyy
         NhEuobqdf5I966y3Vl7b02hGf2Gi86efR3yIPzkEEHG0bWW34aTZ8oAcwKiaD2FIEvD+
         J1Pu4iVuzQ0KVlWET5R22D9H3bGFsYIyqk9CLpoStn4iktG0W2lDqwK3DUSMNSOFtVcI
         GpgR445vHgQ21jNeWh+g+RtU9jpkqctThWQ/2x3/KgS52GmErpYQVKtwpS8MfojYQwxF
         v8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690935563; x=1691540363;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jiCX9Q8KQzCFHIlN9fUWjnIbzXZVmYqy+m4ur8MULw4=;
        b=fL9jvEb2SRn5ssov4uBjRJXCNmHJDZYbF+D/xTdwWrMZkejO6mPXszsh1MLeARQ+q8
         9S1qKRomFREauvcpHt1SSpPBEpsYPqCrHMGzjvpX29X1YEy1ycycll1CQVeUWP0DN5Ki
         DHc9fNso4rC+33SJkphkI6p9wC0sIVY5Lzan2dYJhyLy8Y7AMZ3+314QXpXd8/WJghlS
         EJuuaBGoYwrqc8IvTqtBlj6Om0x3f5HySaEwzLry+QTcvzMIGWLd7b90I8XxG/PlgLl2
         O2vW7wpMik6Cf5s5ezi1WG5ameiJzYc0S1AptEc/L++2bAdHzh6rbm7l68vDLKNYZfxs
         oXeQ==
X-Gm-Message-State: ABy/qLZ94XWsx/h02xnUxUz11/QqgrhuobOAkDSvpKilbEzuUELljcvu
        B2T2Ggcx1hkZsF/jyDYg/LTr75H7Iv4=
X-Google-Smtp-Source: APBJJlGabaulGySud5eED3qwTBU5nOND0oeDMCKN/iqAFIEwIWc7V2ByJCSLHXKDGcSdrjYb2gXkJaJyoNI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3504:b0:57a:6bb:c027 with SMTP id
 fq4-20020a05690c350400b0057a06bbc027mr199062ywb.1.1690935563806; Tue, 01 Aug
 2023 17:19:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  1 Aug 2023 17:19:20 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230802001920.1530188-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.08.02 - CANCELED
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Canceling tomorrow to focus on reviews for 6.6 (and obviously because there's
no topic).

Future Schedule:
August 9th  - Available
August 16th - Available
August 23rd - Available

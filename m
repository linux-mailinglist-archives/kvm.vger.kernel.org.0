Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4837679DC99
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 01:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbjILXVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 19:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbjILXVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 19:21:07 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ECE1702
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 16:21:03 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58c8b2d6784so69539787b3.3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 16:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694560862; x=1695165662; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i2yKiL7UrV2W3oIuzSuDJKbrYeZQM4aEB+p2LpmA+bo=;
        b=A3HB32qVCzbWciZ78THZjZtpmvzEFvFBzZ5EHbPH0qA2mdVwX+eWHqFJj14fUBLn7i
         h4yqrOKzUECrjujMcHDCEoaM7H5tNKiK58DaICxIp/aiBcnORvkHBmAc6hC3TvWP/ebV
         +LP4elSGiXl1WY/iB7Qub239RxY8eHMcXugdYPwiTA825i41nftT/MJdCKhyM0bLKfKo
         zAJ3bVBu45VDsxq9nMR2R7t52cHjy57Rmh/uTkKoDadqjZjNngb9TvAFUyOHxLsldlZX
         HJ5o6Uqvybdfy5Jk2el1URwaYA81yOJKmuejFARqtyAPJoToI7BQtN/Yw1tisUhorU7d
         P0Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694560862; x=1695165662;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i2yKiL7UrV2W3oIuzSuDJKbrYeZQM4aEB+p2LpmA+bo=;
        b=gQaCSR2imYjzG8EYnXiNyqki9t10NbvkMoGuLntYaa8M4LKlBc7jm4AXuFurSc7HsD
         6HYR1LIw+pFCXo5gm+8Z311N7uvBumi4OyLDSCveBhQ+/VrLcH4/ximAPJaiUXetQU1r
         4uJ/XoWh3RcCC+PfVAo8XQRJtwS8PjsAByF4zw9n8rX7xD6Ze37NK6CnAc+qo1ri2b+9
         sV6vE3yg0DKoVTOEJsF/eAi6zOXIpWUNMf/3wW4t1pKIquW8+hpi9kcSpkMxF8GmiljT
         SMPS4DdBaf5pf8g2IM87wAeLICZcFe964P2mukoUgi+sRb8AE6D04JR32MSl3cQA9UoT
         m71Q==
X-Gm-Message-State: AOJu0Yz7mhKXSWvlNqOl0xJZtwUhPxZEnJKic9Xo9q2E1fmu5H6X6LZY
        +XjTUTsN3CF5n5bOiW2UtWpuwBiqUw4=
X-Google-Smtp-Source: AGHT+IF1nwbYw+IIssLcKJz517xhldsLguhjQH9pf6FLI9hZKsAh6/s6tYOSEahOAxjNyYtc9753QskwCpA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:481:0:b0:d7a:bd65:18ba with SMTP id
 n1-20020a5b0481000000b00d7abd6518bamr20096ybp.3.1694560862708; Tue, 12 Sep
 2023 16:21:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Sep 2023 16:21:00 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230912232100.978817-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.09.13 - CANCELED
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Canceling this week.  I will get v12 of the guest_memfd() series posted
tomorrow (it's more or less ready, need to test and capture the remaining work).

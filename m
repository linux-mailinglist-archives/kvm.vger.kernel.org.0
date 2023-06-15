Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5427731DD8
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 18:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbjFOQbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 12:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbjFOQbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 12:31:45 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBAF2119
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 09:31:44 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b3f66dda65so23544765ad.1
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 09:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686846703; x=1689438703;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+1/VV8j6fQRCDvP34PuPiKV8+Th/ZGWCJfGCDWhHI+Q=;
        b=TjOsnZEJ4mmP5GGQfK/IcqBIWq+Q1ouN6bArqtmRNaPyImEvyciMvPPEEHidQboTe8
         RgKypmc/0G691IKdGsM3D7FhN9u+G/3yWqkme6zqiEvmIAI3EuadRyv+K3cuRDraHFPs
         H71bBzN0DbtJgaZmV1jmCgDDOyYgfz49dOnITV+09JORw0YnolSnVP6eTfU6oTasGzHi
         HmWmXZxmI4IvWAW+1yp7l9I2bRs+V8k/Aj0uWq7OygsIYI363/AYSIXLJnaFa9bzhVWN
         ygFdedOUrFmlr6RHX7NVyS91i+EKHzT2QrdJQfqKzcsjCTbXp69QZq2Hwt3HzpRA5wDc
         LD1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686846703; x=1689438703;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+1/VV8j6fQRCDvP34PuPiKV8+Th/ZGWCJfGCDWhHI+Q=;
        b=e4raEIEPuGxxbDvku+ElYmmwzr12UhJhwn7mb6Vm8YoL9iqOdA2zZwd15fBy9bRl+Y
         efSFX8jYBsxsaCxk4VzFnzbx9mjDKyqPPahGDbf1zBdK/krJLVFyFfldeI3tGd4ww8vp
         RhkgGDACz94pNhRoFAWbObHognXy3aLe+vlj0WnngEYvkUV449IbtHfuK8FeM5C+9rhD
         i+OSiGX8UgFmJntqIqlHIqErvRZxi/CPAdtG7HGLIYJPc+ahJNC5DFnKYeTuMZ4JgHhz
         Df31jOhuN4/a9mNm0FyGceI45bXnPz2gi4nmfyDamyuKRt2/37kkOhI0JGiX2NwcglbF
         CWPQ==
X-Gm-Message-State: AC+VfDzjGohqRYW4etSAJQYsQt6TL5FXYMHC3+h4cVlkVlpH+MdZNney
        c+prVojYmNnV1SMt4jLLVHV36qZSlY8kgt2rJGt5UCCCX6c=
X-Google-Smtp-Source: ACHHUZ4H5Y85yrL/a3xyu2QHKhHOcKOlud5utkpSU9v8Vg2UgKf+5JuTE0g/ik363jgEADM9iZcTCSbRdczAanjYz3c=
X-Received: by 2002:a17:903:22d0:b0:1b3:cdfc:3e28 with SMTP id
 y16-20020a17090322d000b001b3cdfc3e28mr15915625plg.23.1686846703353; Thu, 15
 Jun 2023 09:31:43 -0700 (PDT)
MIME-Version: 1.0
From:   Iggy Jackson <notiggy@gmail.com>
Date:   Thu, 15 Jun 2023 09:31:32 -0700
Message-ID: <CAF5Oe5cf_Vvje8zJr+C+ZGUgKm63PX0WU_ObksvLYAA+xX19eA@mail.gmail.com>
Subject: linux-kvm.org cert expired
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just a heads up that the cert for the linux-kvm.org website has
expired. Wasn't sure who to reach out to about it, so hopefully
someone on this list can help.

--Iggy

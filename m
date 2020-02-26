Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7BF416FB1F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgBZJok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:44:40 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:44250 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgBZJoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:44:39 -0500
Received: by mail-pj1-f73.google.com with SMTP id c31so1641103pje.9
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qyh4wTyFO4XAmJigNXSlbgoQSA7Ex0nWckpueaZj5KI=;
        b=bzZUNCNKGH9NtjctDQoH0vyDnlb0zU8gAcHqE5bReEOPhZzubAYntLpgMu/TvSrWx8
         uFu5TEi3dQZ1o6uIkOQRL6KQRMAk1ny8WsL0t1Mp5r56pKFYoxfIPqUTdSpguiduSrN7
         XKhj3/F4t5Nxe1QfuUko0mRuQTDqdvIHcOC/nGCNEWkdOdc1aq0j8dmA9SDM+Wpw9kW4
         YWa/NqadFUGDsYLMSAiYUyfmSL9VSNxM4q1r5zRoB985bfoLAOxbMehLpoYa1EmNRJGR
         u1H71WZRhBUxq03UJ9M3ZDMhHsLKjx6EvXIEXu6qd4yo2ABxbbu7L71HkdX2rSh5EsO0
         a5iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qyh4wTyFO4XAmJigNXSlbgoQSA7Ex0nWckpueaZj5KI=;
        b=fbesTqzoP7LDOF17rK0GL3g+uuphKZOkBuosnVCFE30DwZyYQg9LY0H9p7sF4uz6pI
         BiAL/1hSA+aV4De7brPoeZ0MR89XKjs4+qVKY2gIogMOslPXCIzR3ZWyKp55cja5d2Uy
         erIjXloIEvAT1jKP1V83Ng7q6T9Po5I3frVwQRCaunL/RfK/aLQ7v2s/LMcWeAq2xJX2
         HGmcMorKC7qyyYiMoAKqSXly0k1Pw5o8U2krvvN2aeGHNYSBch5QPUUyVW65F0odA46e
         rVGUiY0k3nlZ8VpENwqKRxW/P0u1xevmyOq7QAQ5jBlkUNjzVbNtj2vHLjJj227bepjl
         /LWg==
X-Gm-Message-State: APjAAAW/E98yVDOgU1NB5rw5NQx70TafYb1Xsfalzqh/XRF/JFe5Z7iI
        Ce90dXcuPNtI4GrCKo9L5TzllCkM6saD6+g/es5736l84HD3vmoGgxBoRPwhMp+s81rH2K5G4cg
        3acORJ0yFX4phnl/14LenLbLEPxVxMObNHs+PD91saoinMmwTt/A8PA==
X-Google-Smtp-Source: APXvYqzzPmf0vZiHJHpthgF0oVEk2ZScpl4RbdDd4FpukrtXpiYrs6V9YfMmJXC+VB23XIU6HgfaTil/Pg==
X-Received: by 2002:a63:4a47:: with SMTP id j7mr3063194pgl.196.1582710277242;
 Wed, 26 Feb 2020 01:44:37 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:19 -0800
In-Reply-To: <20200226074427.169684-1-morbo@google.com>
Message-Id: <20200226094433.210968-1-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH v2 0/7] Fixes for clang builds
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     oupton@google.com, pbonzini@redhat.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes to "pci: cast masks to uint32_t for unsigned long values" to
cast the masks instead of changing the values in the header.

Bill Wendling (2):
  x86: emulator: use "SSE2" for the target
  pci: cast masks to uint32_t for unsigned long values

Eric Hankland (2):
  x86: pmu: Test WRMSR on a running counter
  x86: pmu: Test perfctr overflow after WRMSR on a running counter

Oliver Upton (1):
  x86: VMX: Add tests for monitor trap flag

Paolo Bonzini (2):
  x86: provide enabled and disabled variation of the PCID test
  vmx: tweak XFAILS for #DB test

-- 
2.25.0.265.gbab2e86ba0-goog

